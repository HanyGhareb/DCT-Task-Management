"""otbi-atd Track B : CSV extraction via the OTBI analytics 'Go URL'.

Uses the authenticated session (Playwright context cookies from auth.py) to
request the analysis output directly as CSV - no click-path scraping:

   {analytics}/saw.dll?Go&path=<url-encoded path>&Action=Download&Format=csv

IMPORTANT (learned on the live pod 2026-06-17): the query parameter is
lowercase 'path' and the path value is fully percent-encoded (slashes -> %2F).
Capital 'Path' returns a WebLogic 404. Returns the CSV text; raises if the
response is HTML (i.e. the session expired and it bounced to login).
"""
import urllib.parse


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
    resp = ctx.request.get(url, timeout=180000)
    ctype = resp.headers.get("content-type", "").lower()
    body = resp.body()
    if resp.status != 200 or "html" in ctype or body[:15].lstrip().lower().startswith(b"<!doctype"):
        raise RuntimeError(
            f"Go-URL did not return CSV (status={resp.status}, type={ctype}). "
            f"Session likely expired or path wrong: {analysis_path}")
    return body.decode("utf-8-sig", "replace")
