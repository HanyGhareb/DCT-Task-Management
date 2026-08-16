"""otbi-atd action : extract Project Budget Transactions (PBT) from the ADG_FIN
VBCS app into PROD.

This is the first READ action. Every other action writes into Fusion through the
UI robot; this one pulls JSON out of a REST service and loads five tables:

    prod.pa_budget_trx_headers       all budget types (transaction_type col)
    prod.pa_additional_fund_lines    34 fields
    prod.pa_estimated_cost_lines     21 fields
    prod.pa_annual_budget_lines      38 fields
    prod.pa_budget_trx_approvals     all types, delete-then-insert per txn

WHY A BROWSER AT ALL: the data lives on a plain ORDS service
(apex.aderp.addigital.gov.ae/ords/dge_custom/extn/fin010/Budgets), but its
credential is held server-side by the VBCS proxy and is not available to us
(Route A was ruled out). The worker's EXISTING Fusion SSO session already
covers the VBCS host, so we load the app once and call the proxy from there -
JSON in, JSON out, no DOM scraping. Full API contract + gotchas:
docs/fusion-actions/pbt-api-spec.md.

NEVER INITIATE A LOGIN: a sign-in redirect means the session died; we fail the
action clean (SESSION_EXPIRED) and let the worker's normal MFA path recover it.
Typing credentials here would fire an unattended Authenticator push.

Run modes (payload "mode"):
    RANGE         on-demand, filtered to dateFrom..dateTo (child calls for every
                  header in range)
    SYNC_DEEP     whole dataset, child calls for everything
    SYNC_SHALLOW  whole dataset, child calls ONLY where the header's row_hash
                  changed or the header is new

The master call is cheap (~10s, complete, no pagination) and the child calls are
not (~0.11s each), which is exactly why SHALLOW exists. The header payload has
no last_updated_date, so a line edited without touching its header is invisible
to the hash diff - that blind spot is what the nightly DEEP pass covers.
"""
import hashlib
import json
import os
import time
import urllib.parse
from datetime import datetime

import config

# --- the VBCS app + proxy ---------------------------------------------------
# Both carry deployment-specific segments (the ;profile= and the webApps path).
# They are constants HERE so a redeploy upstream is a one-line change, never a
# hunt through string concatenation.
VBCS_HOST = os.environ.get(
    "PBT_VBCS_HOST",
    "https://oic-vbcs-dge-oic-prod-vb-axsqv5rxfcdo.builder.me-abudhabi-2.ocp.oraclecloud29.com")
APP_URL = f"{VBCS_HOST}/ic/builder/rt/ADG_FIN/0.1/webApps/adg_fin_pbt_view_app/"
PROXY = (f"{VBCS_HOST}/ic/builder/rt/ADG_FIN/0.1;profile=prod_configuration"
         f"/services/auth/1.1/proxy/finance-ords-services/uri/https"
         f"/apex.aderp.addigital.gov.ae/ords/dge_custom/extn/fin010/Budgets")

DEFAULT_BUS = ["Department of Culture and Tourism",
               "Abrahamic Family House",
               "Museum Shared Services"]
DEFAULT_TYPES = ["Additional", "Estimated-Cost", "Annual-Budget"]

SIGNIN_MARKERS = ("login.microsoftonline.com", "/ui/v1/signin", "oamsso", "/sso/")


class SessionExpired(RuntimeError):
    """The saved SSO session no longer reaches the VBCS app."""


# --- field maps -------------------------------------------------------------
# (json key, column, kind). kind: n=number, t=text, d=date.
# The three creation_date FORMATS differ by type (spec section 5.5) - the date
# parser tries all of them rather than assuming one mask.
HEADER_FIELDS = [
    ("identifier", "identifier", "n"),
    ("transaction_num", "transaction_num", "t"),
    ("transaction_type", "transaction_type", "t"),
    ("project_type", "project_type", "t"),
    ("status", "status", "t"),
    ("transaction_date", "transaction_date", "d"),
    ("trx_year", "trx_year", "t"),
    ("dept_1st_level_approver", "dept_1st_level_approver", "t"),
    ("business_unit", "business_unit", "t"),
    ("decree_no", "decree_no", "t"),
    ("organization", "organization", "t"),
    ("project_num", "project_num", "t"),
    ("project_name", "project_name", "t"),
    ("project_num_1", "project_num_1", "t"),
    ("project_id", "project_id", "t"),
    ("project_approved_cost", "project_approved_cost", "n"),
    ("project_estimated_cost", "project_estimated_cost", "n"),
    ("project_total_cost", "project_total_cost", "n"),
    ("changein_duration", "changein_duration", "t"),
    ("creation_date", "creation_date", "d"),
]

_COMMON_LINE = [
    ("identifier", "identifier", "n"),
    ("transaction_num", "transaction_num", "t"),
    ("project_num", "project_num", "t"),
    ("project_name", "project_name", "t"),
    ("task_num", "task_num", "t"),
    ("task_name", "task_name", "t"),
    ("notes", "notes", "t"),
    ("cost_center", "cost_center", "t"),
    ("expenditure_type", "expenditure_type", "t"),
    ("created_by", "created_by", "t"),
    ("last_updated_by", "last_updated_by", "t"),
    ("creation_date", "creation_date", "d"),
    ("last_updated_date", "last_updated_date", "d"),
    ("baseline_status", "baseline_status", "t"),
    ("baseline_error", "baseline_error", "t"),
    ("transaction_line_error", "transaction_line_error", "t"),
    ("gl_funds_available", "gl_funds_available", "n"),
    ("code_combination", "code_combination", "t"),
]

# commitments arrives as a STRING while its neighbours are JSON numbers
# (spec section 5.6) - _num() copes, the column stays NUMBER.
LINE_FIELDS = {
    "Additional": _COMMON_LINE + [
        ("total_actual", "total_actual", "n"),
        ("additional_amount", "additional_amount", "n"),
        ("total_annual_budget", "total_annual_budget", "n"),
        ("fund_available", "fund_available", "n"),
        ("previous_year_actual", "previous_year_actual", "n"),
        ("current_year_actual", "current_year_actual", "n"),
        ("approved_annual_budget", "approved_annual_budget", "n"),
        ("revised_project_cost", "revised_project_cost", "n"),
        ("current_annual_budget", "current_annual_budget", "n"),
        ("commitments", "commitments", "n"),
        ("line_status", "line_status", "t"),
        ("acc_annual_budget", "acc_annual_budget", "n"),
        ("period_from", "period_from", "t"),
        ("period_to", "period_to", "t"),
        ("validation_status", "validation_status", "t"),
        ("jv_status", "jv_status", "t"),
    ],
    "Estimated-Cost": _COMMON_LINE + [
        ("estimated_cost", "estimated_cost", "n"),
        ("line_status", "line_status", "t"),
        ("current_year_budget", "current_year_budget", "n"),
    ],
    "Annual-Budget": _COMMON_LINE + [
        ("project_phase", "project_phase", "t"),
        ("revised_project_cost", "revised_project_cost", "n"),
        ("approved_annual_budget", "approved_annual_budget", "n"),
        ("estimated_task_cost", "estimated_task_cost", "n"),
        ("variation_task_cost", "variation_task_cost", "n"),
        ("approved_task_cost", "approved_task_cost", "n"),
        ("previous_year_budget", "previous_year_budget", "n"),
        ("current_year_budget", "current_year_budget", "n"),
        ("previous_year_actual", "previous_year_actual", "n"),
        ("current_year_actual", "current_year_actual", "n"),
        ("total_actual", "total_actual", "n"),
        ("approved_budget", "approved_budget", "n"),
        ("proposed_budget", "proposed_budget", "n"),
        ("attachment", "attachment", "t"),
        ("available_project_cost", "available_project_cost", "n"),
        ("acc_annual_budget", "acc_annual_budget", "n"),
        ("period_from", "period_from", "t"),
        ("period_to", "period_to", "t"),
        ("validation_status", "validation_status", "t"),
        ("jv_status", "jv_status", "t"),
    ],
}

LINE_TABLE = {
    "Additional": "prod.pa_additional_fund_lines",
    "Estimated-Cost": "prod.pa_estimated_cost_lines",
    "Annual-Budget": "prod.pa_annual_budget_lines",
}

APPROVAL_FIELDS = [
    ("submitter_name", "submitter_name", "t"),
    ("assignee_username", "assignee_username", "t"),
    ("assignment_state", "assignment_state", "t"),
    ("creation_date", "creation_date", "d"),
    ("change_amount", "change_amount", "t"),
    ("view_amount", "view_amount", "t"),
    ("priority", "priority", "n"),
    ("dept_1st_level_approval_flag", "dept_1st_level_approval_flag", "t"),
]

DATE_FORMATS = ("%Y-%m-%d", "%d-%m-%Y", "%d-%b-%y", "%d-%B-%Y",
                "%Y-%m-%dT%H:%M:%SZ", "%Y-%m-%dT%H:%M:%S")

MAX_TEXT = {"notes": 4000, "baseline_error": 4000, "transaction_line_error": 4000}


# --- coercion ---------------------------------------------------------------
def _num(v):
    if v is None or v == "":
        return None
    if isinstance(v, bool):
        return None
    if isinstance(v, (int, float)):
        return v
    try:
        return float(str(v).replace(",", "").strip())
    except ValueError:
        return None


def _date(v):
    if v is None or v == "":
        return None
    s = str(v).strip()
    for f in DATE_FORMATS:
        try:
            return datetime.strptime(s, f)
        except ValueError:
            continue
    return None


def _text(v, col=None, widths=None):
    """Truncate to the column's REAL width. Widths are read from the data
    dictionary at run start (_load_widths) rather than hard-coded here, so the
    handler can never drift from db/77 and hit ORA-12899 mid-run."""
    if v is None:
        return None
    s = v if isinstance(v, str) else json.dumps(v, ensure_ascii=False) \
        if isinstance(v, (dict, list)) else str(v)
    lim = (widths or {}).get(col) or MAX_TEXT.get(col, 400)
    return s[:lim]


def _coerce(row, fields, widths=None):
    out = {}
    for key, col, kind in fields:
        v = row.get(key)
        out[col] = (_num(v) if kind == "n" else _date(v) if kind == "d"
                    else _text(v, col, widths))
    return out


def _load_widths(conn, table):
    """{column: max chars} for one table, straight from the data dictionary."""
    owner, name = table.split(".", 1) if "." in table else ("PROD", table)
    cur = conn.cursor()
    cur.execute("SELECT LOWER(column_name), char_length FROM all_tab_columns "
                "WHERE owner = UPPER(:o) AND table_name = UPPER(:t) "
                "AND data_type IN ('VARCHAR2','CHAR','NVARCHAR2','NCHAR')",
                o=owner, t=name)
    return {c: int(n) for c, n in cur if n}


def _row_hash(row):
    """Digest of the 20 source header fields - drives the SHALLOW diff."""
    parts = [str(row.get(k)) for k, _c, _t in HEADER_FIELDS]
    return hashlib.sha256("\x1f".join(parts).encode("utf-8")).hexdigest()


# --- SQL generation ---------------------------------------------------------
def _merge_sql(table, fields, extra_cols):
    """MERGE keyed on the source's own surrogate `identifier`, so a re-run can
    never duplicate. Every bind is CAST in the USING clause: an all-NULL column
    in a batch would otherwise be inferred as VARCHAR2 and fail on a NUMBER."""
    cast = {"n": "NUMBER", "t": "VARCHAR2(4000)", "d": "DATE"}
    using = ", ".join(f"CAST(:{c} AS {cast[k]}) {c}" for _j, c, k in fields)
    using += ", " + ", ".join(f"CAST(:{c} AS {t}) {c}" for c, t in extra_cols)
    cols = [c for _j, c, _k in fields] + [c for c, _t in extra_cols]
    upd = ", ".join(f"t.{c} = s.{c}" for c in cols if c != "identifier")
    ins_c = ", ".join(cols)
    ins_v = ", ".join(f"s.{c}" for c in cols)
    return (f"MERGE INTO {table} t USING (SELECT {using} FROM dual) s "
            f"ON (t.identifier = s.identifier) "
            f"WHEN MATCHED THEN UPDATE SET {upd} "
            f"WHEN NOT MATCHED THEN INSERT ({ins_c}) VALUES ({ins_v})")


HEADER_MERGE = _merge_sql("prod.pa_budget_trx_headers", HEADER_FIELDS,
                          [("row_hash", "VARCHAR2(64)"), ("load_run_id", "NUMBER"),
                           ("last_seen_at", "TIMESTAMP")])


# --- HTTP through the VBCS proxy -------------------------------------------
def _get_json(ctx, page, path):
    """GET a proxy path. ctx.request reuses the session cookies without paying
    for a page round-trip; the in-page fetch is the proven fallback."""
    try:
        resp = ctx.request.get(path, timeout=180000)
        if resp.status == 200:
            return resp.json()
        status = resp.status
    except Exception:
        status = None
    r = page.evaluate("""async (u) => {
        const res = await fetch(u, {credentials:'include', headers:{'Accept':'*/*'}});
        const t = await res.text();
        return {status: res.status, body: t};
    }""", path)
    if r["status"] != 200:
        raise RuntimeError(f"proxy GET {r['status']} (ctx.request={status}) for {path[:120]}")
    return json.loads(r["body"])


def _q(params):
    return urllib.parse.urlencode(params, quote_via=urllib.parse.quote)


def fetch_masters(ctx, page, ttype, bus):
    """One call = the COMPLETE set for a type. p_business_unit is OMITTED on
    purpose: omitting it WIDENS to every BU in bu_arr, and there is no 'all'
    sentinel. p_transaction_date is omitted for the same reason (spec 5.2/5.3)."""
    url = f"{PROXY}/Transactions?" + _q({
        "bu_arr": json.dumps(bus, ensure_ascii=False),
        "p_transaction_type": ttype,
    })
    return _get_json(ctx, page, url).get("items", []) or []


def fetch_lines(ctx, page, ttype, txn):
    url = f"{PROXY}/Transactions/{urllib.parse.quote(ttype)}/{urllib.parse.quote(str(txn))}/lines"
    return _get_json(ctx, page, url).get("items", []) or []


def fetch_approvals(ctx, page, ttype, txn):
    url = f"{PROXY}/Transactions/ApprovalHistory?" + _q({
        "transaction_id": txn,          # NB: means transaction_num, not identifier
        "trx_type": ttype,
    })
    return _get_json(ctx, page, url).get("items", []) or []


# --- the action -------------------------------------------------------------
def extract(ctx, env, data, action):
    """Entry point. Returns (run_id, summary)."""
    mode = (data.get("mode") or "RANGE").upper()
    types = [t for t in (data.get("transactionTypes") or DEFAULT_TYPES) if t in LINE_TABLE]
    bus = data.get("businessUnits") or DEFAULT_BUS
    statuses = data.get("statuses") or None
    want_appr = data.get("includeApprovals", True)
    purge = bool(data.get("purgeMissing"))
    d_from = _date(data.get("dateFrom"))
    d_to = _date(data.get("dateTo"))
    if not types:
        raise RuntimeError("no valid transactionTypes in payload")

    page = ctx.new_page()
    conn = config.connect()
    run_id = None
    try:
        # 1. establish the VBCS session on the worker's EXISTING Fusion SSO
        page.goto(APP_URL, wait_until="domcontentloaded", timeout=120000)
        page.wait_for_timeout(6000)
        low = (page.url or "").lower()
        if any(m in low for m in SIGNIN_MARKERS):
            raise SessionExpired(
                "VBCS bounced to sign-in - the saved Fusion session has expired. "
                "Not authenticating here (an unattended MFA push would fire); "
                "the worker's normal login path will recover it.")

        run_id = _log_start(conn, "PA Budget Trx Extract")
        run_ts = _db_now(conn)
        widths = {t: _load_widths(conn, t) for t in
                  list(LINE_TABLE.values()) + ["prod.pa_budget_trx_headers",
                                               "prod.pa_budget_trx_approvals"]}
        totals = {"headers": 0, "lines": 0, "approvals": 0, "childCalls": 0,
                  "missing": 0, "purged": 0}
        notes = []

        for ttype in types:
            t0 = time.time()
            masters = fetch_masters(ctx, page, ttype, bus)
            scoped = [m for m in masters
                      if _in_scope(m, d_from, d_to, statuses, bus)]

            # which transactions need the expensive child calls?
            if mode == "SYNC_SHALLOW":
                known = _known_hashes(conn, ttype)
                todo = [m for m in scoped
                        if known.get(int(m["identifier"])) != _row_hash(m)]
            else:
                todo = scoped

            _merge_headers(conn, scoped, run_id, run_ts,
                           widths["prod.pa_budget_trx_headers"])
            totals["headers"] += len(scoped)

            nl, na = _load_children(conn, ctx, page, ttype, todo, run_id,
                                    run_ts, want_appr, widths)
            totals["lines"] += nl
            totals["approvals"] += na
            totals["childCalls"] += len(todo) * (2 if want_appr else 1)

            # deletion reconciliation - only meaningful when the run covered the
            # FULL scope (the master call always returns everything, so a header
            # missing from it really is gone upstream)
            if _full_scope(d_from, d_to, statuses):
                gone = _stale_headers(conn, ttype, run_ts)
                totals["missing"] += len(gone)
                if gone and purge:
                    totals["purged"] += _purge(conn, ttype, gone)

            notes.append(f"{ttype}: {len(scoped)} hdr / {len(todo)} refreshed "
                         f"in {time.time() - t0:.0f}s")

        msg = " | ".join(notes)
        _log_end(conn, run_id, "SUCCESS",
                 n=totals["headers"] + totals["lines"], msg=msg)
        summary = (f"{len(types)} type(s) | {totals['headers']} headers, "
                   f"{totals['lines']} lines, {totals['approvals']} approvals"
                   + (f", {totals['missing']} missing" if totals["missing"] else "")
                   + (f" ({totals['purged']} purged)" if totals["purged"] else ""))
        print(f"[pbt] {mode}: {summary}\n[pbt] {msg}", flush=True)
        return str(run_id), summary[:200]

    except Exception as e:
        if run_id:
            _log_end(conn, run_id, "FAILED", msg=str(e)[:3000])
        raise
    finally:
        try:
            conn.close()
        except Exception:
            pass
        try:
            page.close()
        except Exception:
            pass


def _in_scope(m, d_from, d_to, statuses, bus):
    """Client-side filtering: the API has NO server-side date range at all -
    p_date_from/p_date_to are silently ignored and p_trx_year filters to zero
    (spec 5.9). bu_arr is honoured server-side but re-checked here."""
    if statuses and (m.get("status") or "") not in statuses:
        return False
    if bus and (m.get("business_unit") or "") not in bus:
        return False
    if d_from or d_to:
        d = _date(m.get("transaction_date"))
        if d is None:
            return False
        if d_from and d < d_from:
            return False
        if d_to and d > d_to:
            return False
    return True


def _full_scope(d_from, d_to, statuses):
    return not (d_from or d_to or statuses)


# --- DB helpers -------------------------------------------------------------
def _db_now(conn):
    return conn.cursor().execute("SELECT SYSTIMESTAMP FROM dual").fetchone()[0]


def _log_start(conn, name):
    cur = conn.cursor()
    rid = cur.var(int)
    cur.execute("INSERT INTO prod.atd_load_run_log (job_name, track, status, host_id) "
                "VALUES (:n, 'BROWSER', 'RUNNING', :h) RETURNING run_id INTO :r",
                n=name[:80], h=(os.environ.get("ATD_WORKER_NAME")
                                or os.uname().nodename)[:120], r=rid)
    conn.commit()
    return rid.getvalue()[0]


def _log_end(conn, run_id, status, n=None, msg=None):
    conn.cursor().execute(
        "UPDATE prod.atd_load_run_log SET finished = SYSTIMESTAMP, status = :s, "
        "row_count = :rc, message = :m WHERE run_id = :id",
        s=status, rc=n, m=(msg or "")[:3900], id=run_id)
    conn.commit()


def _known_hashes(conn, ttype):
    cur = conn.cursor()
    cur.execute("SELECT identifier, row_hash FROM prod.pa_budget_trx_headers "
                "WHERE transaction_type = :t", t=ttype)
    return {int(i): h for i, h in cur}


def _merge_headers(conn, masters, run_id, run_ts, widths=None):
    if not masters:
        return
    rows = []
    for m in masters:
        r = _coerce(m, HEADER_FIELDS, widths)
        r["row_hash"] = _row_hash(m)
        r["load_run_id"] = run_id
        r["last_seen_at"] = run_ts
        rows.append(r)
    cur = conn.cursor()
    cur.executemany(HEADER_MERGE, rows)
    conn.commit()


def _load_children(conn, ctx, page, ttype, todo, run_id, run_ts, want_appr,
                   widths=None):
    """Lines are MERGEd on their own `identifier`; a line that vanished from a
    refetched transaction is then removed by the last_seen_at sweep. Approvals
    carry no key of their own, so they are delete-then-insert per transaction."""
    if not todo:
        return 0, 0
    fields = LINE_FIELDS[ttype]
    table = LINE_TABLE[ttype]
    sql = _merge_sql(table, fields, [("load_run_id", "NUMBER"),
                                     ("last_seen_at", "TIMESTAMP")])
    cur = conn.cursor()
    n_lines = n_appr = 0
    lw = (widths or {}).get(table)
    aw = (widths or {}).get("prod.pa_budget_trx_approvals")

    for i, m in enumerate(todo, 1):
        txn = m["transaction_num"]
        rows = []
        for ln in fetch_lines(ctx, page, ttype, txn):
            r = _coerce(ln, fields, lw)
            r["load_run_id"] = run_id
            r["last_seen_at"] = run_ts
            rows.append(r)
        if rows:
            cur.executemany(sql, rows)
            n_lines += len(rows)
        # lines of THIS transaction not refreshed by this run no longer exist
        cur.execute(f"DELETE FROM {table} WHERE transaction_num = :t "
                    f"AND (last_seen_at IS NULL OR last_seen_at < :ts)",
                    t=str(txn), ts=run_ts)

        if want_appr:
            appr = fetch_approvals(ctx, page, ttype, txn)
            cur.execute("DELETE FROM prod.pa_budget_trx_approvals "
                        "WHERE transaction_num = :t AND trx_type = :y",
                        t=str(txn), y=ttype)
            if appr:
                arows = []
                for seq, a in enumerate(appr, 1):
                    r = _coerce(a, APPROVAL_FIELDS, aw)
                    r["transaction_num"] = str(txn)
                    r["trx_type"] = ttype
                    r["seq_no"] = seq
                    r["load_run_id"] = run_id
                    arows.append(r)
                cols = ["transaction_num", "trx_type", "seq_no"] + \
                       [c for _j, c, _k in APPROVAL_FIELDS] + ["load_run_id"]
                cur.executemany(
                    "INSERT INTO prod.pa_budget_trx_approvals (" + ", ".join(cols) + ") "
                    "VALUES (" + ", ".join(f":{c}" for c in cols) + ")", arows)
                n_appr += len(arows)

        if i % 100 == 0:
            conn.commit()
            print(f"[pbt] {ttype}: {i}/{len(todo)} transactions", flush=True)
    conn.commit()
    return n_lines, n_appr


def _stale_headers(conn, ttype, run_ts):
    cur = conn.cursor()
    cur.execute("SELECT transaction_num FROM prod.pa_budget_trx_headers "
                "WHERE transaction_type = :t "
                "AND (last_seen_at IS NULL OR last_seen_at < :ts)",
                t=ttype, ts=run_ts)
    return [r[0] for r in cur]


def _purge(conn, ttype, txns):
    cur = conn.cursor()
    table = LINE_TABLE[ttype]
    cur.executemany(f"DELETE FROM {table} WHERE transaction_num = :1",
                    [(t,) for t in txns])
    cur.executemany("DELETE FROM prod.pa_budget_trx_approvals "
                    "WHERE transaction_num = :1 AND trx_type = :2",
                    [(t, ttype) for t in txns])
    cur.executemany("DELETE FROM prod.pa_budget_trx_headers "
                    "WHERE transaction_num = :1 AND transaction_type = :2",
                    [(t, ttype) for t in txns])
    conn.commit()
    return len(txns)
