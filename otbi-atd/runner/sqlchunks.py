"""otbi-atd Track B : chunked logical-SQL extraction (Go-URL '&SQL=' variant).

Why this exists (2026-08-11, PROJECTS_BUDGET_PERIODS): the BI Server started
taking a catastrophic plan for the Projects Budget analysis whenever the
Project Key predicate is anything but a SINGLE-VALUE equality (2 projects via
IN/OR = ~350s, 5+ / BETWEEN / no filter = killed by the web tier at ~570s with
a raw WebLogic 500). Runtime P0..P3 Go-URL filters are silently IGNORED for
Action=Download on this pod, so the saved analysis cannot be filtered at
request time. What DOES stay fast is slicing by a pushdown-friendly equality:
one Fiscal Period across all projects ran in 165s. So the extract is issued as
N raw logical-SQL requests (one per accounting period), and the CSVs are
concatenated into ONE stream for the unchanged prepare/load pipeline.

A job opts in via a params_json runner directive (never sent to OTBI):

  {"_atd_sql_chunks": {
      "sql":     "<logical SQL with a {chunk} placeholder in the WHERE>",
      "chunks":  ["01-2026", ... "12-2026"],
      "headers": {"<raw export header>": "<column_map header>", ...},
      "min_rows": 1000,          -- optional: fail below this TOTAL (protects a
                                 -- TRUNCATE_INSERT target from a bad extract)
      "retries":  1,             -- optional: extra attempts per chunk
      "parallel": 4              -- optional: concurrent chunk fetches (default 1)
  }}

Parallelism (probed 2026-08-13): 4 concurrent single-period requests each ran
188-195s vs ~180s solo (~8%% degradation), so waves of 4 cut the 12-chunk job
from ~35 min to ~10 min wall. The parallel pass uses plain urllib threads with
the Playwright context's cookies (the sync Playwright object is NOT thread-safe
and must never be called from the pool); any chunk the parallel pass could not
land is retried SEQUENTIALLY through the Playwright path, which owns the full
session triage (sign-in bounce -> SessionExpired, "No Results" -> empty chunk).

'headers' is both a whitelist and a rename: a '&SQL=' export emits headers
from the presentation layer (plus a junk literal '0' column from the Answers
'SELECT 0 s_0' convention), which do NOT match the saved analysis' custom
headings that the job's column_map_json keys on. Only the mapped headers are
emitted, under the map's VALUE text, so load.resolve_pairs matches exactly and
prepare's drift engine stays quiet. A key may also be POSITIONAL - '#N' = the
1-based CSV column position - for selects whose presentation names collide
(e.g. two different logical columns both exporting as 'Accounting Date'); the
author of the 'sql' controls the select order, so positions are deterministic. Values keep another export artifact in
check: OTBI sometimes prefixes a numeric with an Excel-marker apostrophe
("'-42339"); the leading quote is stripped.

FETCH FIRST n ROWS ONLY is REJECTED by the '&SQL=' parser (nQSError 27002)
even though the Answers Advanced tab displays it - never put it in 'sql'.
"""
import csv
import io
import re
import time
import urllib.parse
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed

import extract   # SessionExpired / ReportError / _download_timeout_ms

_WS_RE = re.compile(r"\s+")
_XLMARK_RE = re.compile(r"^'(?=[-+]?\d)")   # Excel-marker apostrophe before a number


def _norm(h):
    """Header text for matching: trim, collapse whitespace, casefold."""
    return _WS_RE.sub(" ", str(h or "").strip()).casefold()


def build_sql_url(analytics_base, sql, fmt="csv"):
    base = analytics_base.rstrip("/")
    return (f"{base}/saw.dll?Go&SQL={urllib.parse.quote(sql, safe='')}"
            f"&Action=Download&Format={fmt}")


def _fetch_chunk(ctx, env, sql, tag):
    """One timed '&SQL=' download with the same HTML triage as the Go&path
    extract: sign-in bounce -> SessionExpired (worker re-auths + retries the
    job); an OTBI error page while still authenticated -> ReportError, except
    the legitimate 'No Results' view, which is an empty chunk."""
    url = build_sql_url(env["analytics_base_url"], sql)
    resp = ctx.request.get(url, timeout=extract._download_timeout_ms())
    ctype = resp.headers.get("content-type", "").lower()
    body = resp.body()
    is_html = "html" in ctype or body[:15].lstrip().lower().startswith(b"<!doctype")
    if resp.status == 200 and is_html:
        final = (resp.url or "").lower()
        on_analytics = ("/analytics/" in final and "signin" not in final
                        and "login.microsoft" not in final and "/oam" not in final)
        if on_analytics:
            raw = body.decode("utf-8", "replace")
            txt = _WS_RE.sub(" ", re.sub(r"<[^>]+>", " ", raw))
            if "no results" in txt.lower():
                return ""                    # a period with no rows - not an error
            if "enable javascript" in txt.lower() or "doFrameBust" in raw:
                # OBIEE's JS frame-bust/landing shell: the web session needs
                # re-establishment - a SESSION problem, not a report defect
                raise extract.SessionExpired(
                    f"SQL chunk {tag} got the OBIEE JS landing page - "
                    f"session needs re-establishment")
            raise extract.ReportError(
                f"OTBI returned an error page for SQL chunk {tag}: {txt[:400]}")
        raise extract.SessionExpired(
            f"SQL chunk {tag} bounced to sign-in - session expired")
    if resp.status != 200:
        raise RuntimeError(
            f"SQL chunk {tag}: HTTP {resp.status} (the web tier kills queries "
            f"at ~570s - a chunk this slow means the predicate lost pushdown)")
    return body.decode("utf-8-sig", "replace")


def _fetch_chunk_http(cookie_hdr, env, sql, tag):
    """Thread-safe chunk fetch over plain urllib with the session cookies (the
    sync Playwright objects must NEVER be called from a worker thread). Returns
    (tag, csv_text|None, secs, error|None); anything not a clean CSV is left
    for the sequential Playwright retry, which owns the real session triage."""
    url = build_sql_url(env["analytics_base_url"], sql)
    req = urllib.request.Request(url, headers={"Cookie": cookie_hdr})
    t0 = time.time()
    try:
        with urllib.request.urlopen(
                req, timeout=extract._download_timeout_ms() / 1000.0) as r:
            body = r.read()
        secs = time.time() - t0
        head = body[:300].lstrip().lower()
        if head.startswith(b"<!doctype") or b"<html" in head:
            return tag, None, secs, "html response (error page or sign-in)"
        return tag, body.decode("utf-8-sig", "replace"), secs, None
    except Exception as e:  # noqa: BLE001 - classified by the sequential retry
        return tag, None, time.time() - t0, str(e)[:150]


def _append_rows(w, text, headers, tag):
    """Parse one chunk's CSV, emit only the mapped columns (renamed)."""
    if not (text or "").strip():
        return 0
    rdr = csv.reader(io.StringIO(text))
    try:
        raw = next(rdr)
    except StopIteration:
        return 0
    # an EMPTY result set exports as a one-cell body "The query resulted in
    # no rows" (plain text, NOT the HTML No-Results view) - a valid 0-row chunk
    if len(raw) == 1 and "resulted in no rows" in _norm(raw[0]):
        return 0
    norm_pos = {}
    for i, h in enumerate(raw):
        norm_pos.setdefault(_norm(h), i)
    take, missing = [], []
    for k in headers:
        if k.startswith("#"):                # positional key: '#N' = 1-based CSV column
            idx = int(k[1:]) - 1
            if idx < 0 or idx >= len(raw):
                missing.append(k)
            else:
                take.append(idx)
        elif _norm(k) in norm_pos:
            take.append(norm_pos[_norm(k)])
        else:
            missing.append(k)
    if missing:
        raise RuntimeError(
            f"SQL chunk {tag}: export header lacks mapped column(s) {missing}; "
            f"got {len(raw)} column(s): {[h for h in raw if str(h).strip()]}")
    n = 0
    for row in rdr:
        vals = [_XLMARK_RE.sub("", row[i].strip()) if i < len(row) else ""
                for i in take]
        if not any(vals):
            continue                         # separator / fully-blank row
        w.writerow(vals)
        n += 1
    return n


def download_csv(ctx, env, job, params):
    """The extract.download_job entry point for '_atd_sql_chunks' jobs."""
    d = params["_atd_sql_chunks"]
    sql_tpl = d["sql"]
    chunks = d["chunks"]
    headers = d["headers"]
    min_rows = int(d.get("min_rows") or 0)
    retries = max(0, int(d.get("retries", 1)))
    parallel = max(1, int(d.get("parallel", 1)))
    out = io.StringIO()
    w = csv.writer(out)
    w.writerow(list(headers.values()))

    # ALL first-pass fetches go through the urllib pool - even at parallel=1
    # (pool of one = sequential): the pool reuses the ORIGINAL cookie header on
    # every request, which OBIEE tolerates for long &SQL sequences, while
    # back-to-back Playwright ctx.request downloads pick up rotated cookies and
    # start drawing the JS landing page mid-sequence (seen live 2026-08-14 on
    # AR_INVOICE_LINES). Playwright remains the fallback for missed chunks,
    # where its full session triage (SessionExpired etc.) matters.
    texts = {}
    if parallel >= 1:
        cookies = ctx.cookies(env["analytics_base_url"])
        cookie_hdr = "; ".join(f"{c['name']}={c['value']}" for c in cookies)
        t0 = time.time()
        with ThreadPoolExecutor(max_workers=parallel) as ex:
            futs = [ex.submit(_fetch_chunk_http, cookie_hdr, env,
                              sql_tpl.replace("{chunk}", str(c)), str(c))
                    for c in chunks]
            for f in as_completed(futs):
                tag, text, secs, err = f.result()
                if text is None:
                    print(f"[sqlchunks] parallel chunk {tag} missed after "
                          f"{secs:.0f}s ({err}) - will retry sequentially")
                else:
                    texts[tag] = text
        print(f"[sqlchunks] parallel pass x{parallel}: {len(texts)}/"
              f"{len(chunks)} chunk(s) in {time.time() - t0:.0f}s")

    total = 0
    for chunk in chunks:
        sql = sql_tpl.replace("{chunk}", str(chunk))
        text = texts.get(str(chunk))
        t0 = time.time()
        if text is None:
            for attempt in range(retries + 1):
                t0 = time.time()
                try:
                    text = _fetch_chunk(ctx, env, sql, chunk)
                    break
                except extract.SessionExpired:
                    raise                    # worker re-auths + retries the job
                except Exception as e:  # noqa: BLE001 - one more try, then fail the job
                    if attempt >= retries:
                        raise RuntimeError(
                            f"SQL chunk {chunk} failed after {attempt + 1} "
                            f"attempt(s): {e}") from e
                    print(f"[sqlchunks] chunk {chunk} attempt {attempt + 1} failed "
                          f"after {time.time() - t0:.0f}s ({e}) - retrying")
        n = _append_rows(w, text, headers, chunk)
        total += n
        print(f"[sqlchunks] chunk {chunk}: {n} row(s) in {time.time() - t0:.0f}s")
    if total < min_rows:
        raise RuntimeError(
            f"chunked extract returned {total} row(s) total, below min_rows "
            f"{min_rows} - refusing to load (protects the target from a "
            f"bad/empty extract)")
    print(f"[sqlchunks] total {total} row(s) from {len(chunks)} chunk(s)")
    return out.getvalue()
