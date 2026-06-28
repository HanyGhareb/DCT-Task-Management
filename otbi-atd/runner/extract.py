"""otbi-atd Track B : CSV extraction via the OTBI analytics 'Go URL'.

Uses the authenticated session (Playwright context cookies from auth.py) to
request the analysis output directly as CSV - no click-path scraping:

   {analytics}/saw.dll?Go&path=<url-encoded path>&Action=Download&Format=csv

IMPORTANT (learned on the live pod 2026-06-17): the query parameter is
lowercase 'path' and the path value is fully percent-encoded (slashes -> %2F).
Capital 'Path' returns a WebLogic 404. Returns the CSV text; raises if the
response is HTML (i.e. the session expired and it bounced to login).
"""
import os
import urllib.parse


def _download_timeout_ms():
    """CSV download timeout in ms. Config ATD_DOWNLOAD_TIMEOUT_SEC (default 300s);
    raise it for large/slow OTBI reports that exceed the default (the cause of a
    'Timeout … exceeded' FAILED on big analyses)."""
    try:
        return max(10, int(os.environ.get("ATD_DOWNLOAD_TIMEOUT_SEC", "300"))) * 1000
    except (TypeError, ValueError):
        return 300000


class SessionExpired(RuntimeError):
    """The Go-URL bounced to the SIGN-IN page (HTTP 200 + HTML, final URL off the
    analytics app) — the OTBI/Entra session died. The worker can re-authenticate +
    retry (one MFA push). See runner._run_worker."""


class ReportError(RuntimeError):
    """The Go-URL returned an OTBI error PAGE (HTTP 200 + HTML) while STILL
    authenticated (final URL still on /analytics) — e.g. 'Path not found' (the report
    was moved/renamed/deleted) or a report runtime error. Re-auth will NOT help: the
    job's source_ref or the report itself must be fixed. Kept distinct from
    SessionExpired so the worker fails the job cleanly with an honest message instead
    of pushing useless MFA prompts."""


def build_url(analytics_base, analysis_path, fmt="csv", extra=None):
    base = analytics_base.rstrip("/")
    qp = urllib.parse.quote(analysis_path, safe="")     # encode '/','@',' ' -> %2F,%40,%20
    url = f"{base}/saw.dll?Go&path={qp}&Action=Download&Format={fmt}"
    if extra:
        url += "&" + urllib.parse.urlencode(extra)
    return url


def download_csv(ctx, env, analysis_path, params=None, fmt="csv"):
    """Download via the Playwright context's request API (shares the session cookies)."""
    url = build_url(env["analytics_base_url"], analysis_path, fmt, params)
    resp = ctx.request.get(url, timeout=_download_timeout_ms())
    ctype = resp.headers.get("content-type", "").lower()
    body = resp.body()
    is_html = "html" in ctype or body[:15].lstrip().lower().startswith(b"<!doctype")
    if resp.status == 200 and is_html:
        # 200 + HTML means we did NOT get the CSV. Distinguish two very different causes
        # by the FINAL url (after redirects):
        #   * still on the analytics app  -> OTBI rendered an error page while we were
        #     authenticated (e.g. "Path not found" = report moved/renamed, or a report
        #     runtime error). Re-auth will NOT help -> ReportError (fail cleanly).
        #   * redirected to a sign-in page -> the session expired -> SessionExpired
        #     (the worker re-authenticates + retries).
        final = (resp.url or "").lower()
        on_analytics = ("/analytics/" in final and "signin" not in final
                        and "login.microsoft" not in final and "/oam" not in final)
        if on_analytics:
            raise ReportError(
                f"OTBI returned an error page (not CSV) for path: {analysis_path}. "
                f"The report path/definition is wrong (e.g. moved/renamed/deleted) — "
                f"fix the job's source_ref or the report. Re-auth will not help.")
        raise SessionExpired(
            f"Go-URL bounced to sign-in (status=200, type={ctype}) — session expired: "
            f"{analysis_path}")
    if resp.status != 200:
        raise RuntimeError(
            f"Go-URL did not return CSV (status={resp.status}, type={ctype}) for "
            f"path: {analysis_path} — unexpected non-200 (likely a wrong path/URL).")
    return body.decode("utf-8-sig", "replace")
