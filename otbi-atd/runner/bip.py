"""otbi-atd Track B : BI Publisher (xmlpserver) report extraction.

A job whose source_ref ends in '.xdo' is a BIP *report*, not an OTBI analysis.
It is fetched from the xmlpserver direct-export URL with the SAME warm session
cookies as the analytics Go-URL (one Fusion SSO covers both apps):

   {xmlpserver}/<report path>.xdo?_xpt=1&_xf=xlsx&_xautorun=true&_paramsP_X=...

  * _xpt=1 makes the response the rendered document itself - no interactive
    viewer, no 'Apply' click; _xf picks the format (job.output_format).
  * report parameters come from params_json, e.g. {"_paramsP_BU":"*"}.
    A JSON ARRAY value repeats the key (multi-select params like DOCTYPE).
  * keys starting '_atd_' are RUNNER DIRECTIVES, stripped from the URL:
      _atd_require : header whose value must be non-blank for a row to load
                     (banner / summary / fully-blank rows are always dropped).

The XLSX is converted to CSV text so the whole downstream pipeline (prepare
drift detection + load) runs unchanged. When the job has a column_map_json,
ONLY the mapped headers are emitted (matched case-insensitively, emitted under
the map's own key text so load.resolve_pairs matches exactly) - that is what
keeps "extract only these columns" true even when the report ships more, and
what stops prepare's drift engine from ADDing the report's extra columns.
"""
import csv
import io
import json
import re
import urllib.parse
from datetime import datetime, date, time as dtime

import extract   # SessionExpired / ReportError / _download_timeout_ms

_WS_RE = re.compile(r"\s+")


def _norm(h):
    """Header text for matching: trim, collapse whitespace, casefold."""
    return _WS_RE.sub(" ", str(h or "").strip()).casefold()


def xmlp_base(env):
    """xmlpserver base URL: the env column when set, else derived from the
    analytics URL (same host, standard Fusion layout)."""
    x = (env.get("xmlpserver_base_url") or "").strip()
    if x:
        return x.rstrip("/")
    a = (env.get("analytics_base_url") or "").rstrip("/")
    if a.lower().endswith("/analytics"):
        return a[: -len("/analytics")] + "/xmlpserver"
    raise RuntimeError(f"env {env.get('env_name')}: no xmlpserver_base_url and the "
                       f"analytics URL does not end in /analytics: {a}")


def build_export_url(base, report_path, fmt="xlsx", params=None):
    path = "/" + urllib.parse.quote(report_path.strip().lstrip("/"), safe="/")
    qs = [("_xpt", "1"), ("_xf", fmt), ("_xautorun", "true")]
    for k, v in (params or {}).items():
        if k.startswith("_atd_"):
            continue                      # runner directive, never sent to BIP
        qs.append((k, v))
    return base.rstrip("/") + path + "?" + urllib.parse.urlencode(qs, doseq=True)


def _prime_sso(ctx, base):
    """First xmlpserver touch of a session may need the SSO redirect dance (an
    auto-submitting form that requires JS), which ctx.request cannot run. Open
    the BIP home in a real PAGE once: with live Entra cookies the hop completes
    silently and the context's cookie jar gains the xmlpserver session."""
    pg = ctx.new_page()
    try:
        pg.goto(base + "/", wait_until="domcontentloaded",
                timeout=extract._download_timeout_ms())
        pg.wait_for_timeout(4000)            # let any auto-post/redirect settle
        print(f"[bip] SSO prime landed on: {pg.url[:120]}")
    except Exception as e:  # noqa: BLE001 - priming is best-effort
        print(f"[bip] SSO prime failed (continuing): {e}")
    finally:
        pg.close()


def download_bytes(ctx, env, report_path, params=None, fmt="xlsx", _primed=False):
    """Fetch the rendered report via the Playwright context (shares cookies)."""
    base = xmlp_base(env)
    url = build_export_url(base, report_path, fmt, params)
    resp = ctx.request.get(url, timeout=extract._download_timeout_ms())
    ctype = resp.headers.get("content-type", "").lower()
    body = resp.body()
    is_html = "html" in ctype or body[:15].lstrip().lower().startswith(b"<!doctype")
    if resp.status == 200 and is_html:
        # same triage as the analytics Go-URL: still on the BI app = a report
        # error page (bad path/param - re-auth will NOT help); otherwise we
        # bounced to a sign-in page -> prime the xmlpserver SSO once via a real
        # page (JS dance), retry, and only then call the session expired.
        final = (resp.url or "").lower()
        on_bi = ("/xmlpserver" in final and "signin" not in final
                 and "login.microsoft" not in final and "/oam" not in final)
        if on_bi:
            raise extract.ReportError(
                f"BIP returned an error page (not {fmt}) for report: {report_path}. "
                f"The report path/params are wrong (moved/renamed/deleted?) - fix the "
                f"job's source_ref/params_json. Re-auth will not help.")
        if not _primed:
            _prime_sso(ctx, base)
            return download_bytes(ctx, env, report_path, params, fmt, _primed=True)
        raise extract.SessionExpired(
            f"BIP export bounced to sign-in (status=200, type={ctype}) - session "
            f"expired: {report_path}")
    if resp.status != 200:
        raise RuntimeError(
            f"BIP export did not return {fmt} (status={resp.status}, type={ctype}) "
            f"for report: {report_path}")
    if fmt == "xlsx" and not body[:4].startswith(b"PK"):
        raise extract.ReportError(
            f"BIP export for {report_path} is not an XLSX (no zip signature; "
            f"type={ctype}) - check _xf/output_format and the report template.")
    return body


def _cell_text(v):
    """Serialize an openpyxl cell value the loader can parse back."""
    if v is None:
        return ""
    if isinstance(v, datetime):
        return v.strftime("%Y-%m-%d %H:%M:%S")
    if isinstance(v, date):
        return v.strftime("%Y-%m-%d")
    if isinstance(v, dtime):
        return v.strftime("%H:%M:%S")
    if isinstance(v, float) and v.is_integer():
        return str(int(v))                # 12.0 -> '12' (doc numbers, day counts)
    return str(v).strip()


def _find_header_row(rows_probe, want_norm):
    """Index + header list of the first row matching the mapped headers.
    BIP Excel output usually opens with title/parameter banner rows; the real
    header row is the first one containing at least 2 mapped headers (or, with
    no map, at least 3 non-blank text cells)."""
    for i, row in enumerate(rows_probe):
        texts = [_norm(c) for c in row]
        if want_norm:
            hits = sum(1 for t in texts if t in want_norm)
            if hits >= min(2, len(want_norm)):
                return i, [str(c or "").strip() for c in row]
        else:
            if sum(1 for t in texts if t) >= 3:
                return i, [str(c or "").strip() for c in row]
    return None, None


def xlsx_to_csv(data, column_map=None, require_header=None, probe_rows=50):
    """Convert a BIP XLSX export to CSV text.

    column_map    {"Report Header": "TARGET_COL"} - only these headers are
                  emitted (in map order, under the map's own key text).
    require_header a header whose value must be non-blank for the row to load.
    """
    import openpyxl
    wb = openpyxl.load_workbook(io.BytesIO(data), read_only=True, data_only=True)
    try:
        want = list(column_map.keys()) if column_map else None
        want_norm = {_norm(k) for k in want} if want else None
        for ws in wb.worksheets:
            rows = ws.iter_rows(values_only=True)
            probe = []
            for r in rows:
                probe.append(r)
                if len(probe) >= probe_rows:
                    break
            hdr_idx, headers = _find_header_row(probe, want_norm)
            if hdr_idx is None:
                continue                     # try the next sheet
            norm_pos = {}
            for i, h in enumerate(headers):
                norm_pos.setdefault(_norm(h), i)
            if want:
                missing = [k for k in want if _norm(k) not in norm_pos]
                if missing:
                    raise RuntimeError(
                        f"BIP XLSX header row lacks mapped column(s) {missing}; "
                        f"sheet '{ws.title}' headers = {[h for h in headers if h]}")
                take = [(k, norm_pos[_norm(k)]) for k in want]
            else:
                take = [(h, i) for i, h in enumerate(headers) if str(h).strip()]
            req_idx = None
            if require_header:
                rn = _norm(require_header)
                if rn not in norm_pos:
                    raise RuntimeError(
                        f"_atd_require header '{require_header}' not in the XLSX "
                        f"header row (sheet '{ws.title}')")
                req_idx = norm_pos[rn]
            out = io.StringIO()
            w = csv.writer(out)
            w.writerow([k for k, _ in take])
            n = 0
            data_rows = probe[hdr_idx + 1:]
            for r in data_rows + list(rows):
                vals = [_cell_text(r[i]) if i < len(r) else "" for _, i in take]
                if not any(vals):
                    continue                 # separator / fully-blank row
                if req_idx is not None:
                    rv = _cell_text(r[req_idx]) if req_idx < len(r) else ""
                    if not rv:
                        continue             # no Document Number etc. -> excluded
                w.writerow(vals)
                n += 1
            print(f"[bip] sheet '{ws.title}': {n} data row(s) from the XLSX")
            return out.getvalue()
        raise RuntimeError("no worksheet in the BIP XLSX contains the expected "
                           "header row - check the report output/template")
    finally:
        wb.close()


def download_csv(ctx, env, job, params=None):
    """The extract.download_job entry point for '.xdo' jobs: fetch + convert."""
    fmt = (job.get("output_format") or "xlsx").strip().lower()
    body = download_bytes(ctx, env, job["source_ref"], params, fmt)
    if fmt != "xlsx":                        # e.g. a BIP layout that emits csv
        return body.decode("utf-8-sig", "replace")
    cmap = json.loads(job["column_map_json"]) if job.get("column_map_json") else None
    require = (params or {}).get("_atd_require")
    return xlsx_to_csv(body, cmap, require)
