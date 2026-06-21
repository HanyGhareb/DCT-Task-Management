"""otbi-atd : derive a job's table + column map from the live analysis CSV.

A job can now be created with ONLY its analysis path (source_ref) and, optionally,
a target table name. Everything else - the staging table's columns and the
{CSV header -> target column} map - is PREPARED BY THE JOB on its first run:
the runner already downloads the CSV, so on a job whose column_map_json is empty
it profiles that CSV, CREATEs the staging table (if missing) sized/typed from the
real data, persists the column map + stage table back onto the job row, and then
loads. Subsequent runs skip preparation (the map is now set).

This module owns the profiling/identifier logic (shared with add_analysis.py) and
the two `ensure_prepared_*` entry points (oracledb / SQLcl) the runner calls.
"""
import csv
import io
import json
import os
import re

# Oracle reserved words we must not use as bare column names
RESERVED = {"ORDER", "DATE", "LEVEL", "NUMBER", "COMMENT", "ROW", "ROWID", "SIZE",
            "TABLE", "COLUMN", "ACCESS", "GROUP", "USER", "SESSION", "START", "TO",
            "FROM", "SELECT", "VALUES", "RAW", "DESC", "ASC", "MODE", "UID"}
LEN_BUCKETS = [10, 20, 30, 40, 60, 100, 150, 200, 300, 400, 600, 1000, 2000, 4000]
# Recognise every date shape the loader (load._to_dt / loadsql) can parse, so a
# DATE column fed non-ISO dates (e.g. 15-JAN-2026) is NOT mis-flagged as drift.
DATE_RE = re.compile(
    r"^(?:"
    r"\d{4}-\d{2}-\d{2}( \d{2}:\d{2}:\d{2})?"          # 2026-01-15 [00:00:00]
    r"|\d{1,2}-[A-Za-z]{3}-\d{2,4}"                     # 15-Jan-2026 / 15-Jan-26
    r"|\d{1,2}/\d{1,2}/\d{4}( \d{2}:\d{2}:\d{2})?"      # 01/15/2026 [00:00:00]
    r")$")
INT_RE = re.compile(r"^-?\d+$")
NUM_RE = re.compile(r"^-?\d+(\.\d+)?$")
ALPHA_RE = re.compile(r"[A-Za-z]")
# Oracle NUMBER holds 38 significant digits; allow decimals/measures up to that
# (sign + dot + 38 digits). Integers keep a tighter cap so long IDs / account
# codes with leading zeros are NOT coerced to NUMBER (which would drop the zeros).
INT_MAXLEN = 15
NUM_MAXLEN = 40

# Name-based NUMBER hint. A column whose header carries an amount token is created
# as NUMBER regardless of OBIEE value formatting (apostrophes, commas, parens) and
# its values are coerced on load. The *_AMOUNT/_AMT/_NUM/_BAL/_QTY suffix is the
# explicit, guaranteed contract for new analyses; the keyword list covers existing
# finance columns. Override the whole pattern via ATD_NUMERIC_NAME_PATTERN.
NUM_SUFFIX_RE = re.compile(r"(?:_AMOUNT|_AMT|_NUM|_BAL|_QTY)$", re.I)
NUM_NAME_RE = re.compile(
    os.environ.get("ATD_NUMERIC_NAME_PATTERN",
        r"(?:_AMOUNT|_AMT|_NUM|_BAL|_QTY)$"
        r"|AMOUNT|EXPENDITURE|COMMITMENT|OBLIGATION|ENCUMBRANCE|BUDGET|BALANCE|FUNDS|PCT"),
    re.I)


def is_numeric_suffix(header):
    """True when the header ends with an explicit numeric suffix (_AMOUNT, ...)."""
    return bool(header) and bool(NUM_SUFFIX_RE.search(header))


def is_numeric_name(header):
    """True when the header carries any amount token (suffix or keyword)."""
    return bool(header) and bool(NUM_NAME_RE.search(header))


def coerce_number(v):
    """Aggressively normalize a value bound for a NUMBER column: strip the OBIEE
    text-guard apostrophe, thousands separators, surrounding whitespace, and turn
    accounting parentheses into a minus ("(1,234)" -> "-1234"). A non-numeric
    leftover is returned as-is so the NUMBER insert fails loudly (surfacing real
    bad data) rather than silently corrupting it."""
    if v is None:
        return v
    s = v.strip()
    if s == "":
        return ""
    if s[0] == "'":                          # OBIEE text-guard apostrophe
        s = s[1:].strip()
    neg = False
    if s.startswith("(") and s.endswith(")"):   # (123.45) -> -123.45
        neg, s = True, s[1:-1].strip()
    s = s.replace(",", "")                   # thousands separators
    if neg and s and not s.startswith("-"):
        s = "-" + s
    return s


def clean_cell(v):
    """Normalize an OBIEE/Excel export cell so numeric values type & load cleanly.

    OBIEE prefixes a 'text-guard' apostrophe to negative/measure numbers on CSV
    export (e.g. "'-33750"), which makes the column profile as VARCHAR2 and stores
    the apostrophe verbatim. Strip that leading apostrophe — but ONLY when the
    remainder is a plain number, so genuine text ("'NORTH") is left untouched.
    Used by the profiler AND both loaders so every value is normalized identically."""
    if v and len(v) > 1 and v[0] == "'" and NUM_RE.match(v[1:]):
        return v[1:]
    return v


def slug(text):
    """A clean upper-case identifier fragment from arbitrary text (<=26 chars)."""
    n = re.sub(r"[^A-Za-z0-9]+", "_", (text or "").strip().upper()).strip("_")
    n = re.sub(r"_+", "_", n)
    if not n or not n[0].isalpha():
        n = "C_" + n
    return n[:26]


def derive_table(path):
    """PROD.ATD_<leaf> table name from an analysis path."""
    leaf = (path or "").rstrip("/").split("/")[-1]
    return "ATD_" + slug(leaf)


def derive_job(path):
    leaf = (path or "").rstrip("/").split("/")[-1]
    return slug(leaf)


def colname(header, used):
    n = slug(header)
    n = n[:28]
    if n in RESERVED:
        n = n + "_"
    base, i = n, 2
    while n in used:
        n = f"{base[:26]}_{i}"; i += 1
    used.add(n)
    return n


def bucket(maxlen):
    want = max(int(maxlen * 1.5) + 1, 10)
    for b in LEN_BUCKETS:
        if want <= b:
            return b
    return 4000


def infer(values, maxlen):
    ne = [clean_cell(v) for v in values if v.strip() != ""]
    if not ne:
        return "VARCHAR2(40)"          # all-null: safe default
    if all(DATE_RE.match(v) for v in ne):
        return "DATE"
    if all(INT_RE.match(v) for v in ne) and maxlen <= INT_MAXLEN:
        return "NUMBER"
    if all(NUM_RE.match(v) for v in ne) and maxlen <= NUM_MAXLEN:
        return "NUMBER"
    return f"VARCHAR2({bucket(maxlen)})"


def profile(csv_text):
    """Return ([{header,name,type,maxlen,nulls}], row_count) from CSV text.

    Single streaming pass: per-column max length, null count and type flags are
    accumulated row-by-row (the old version made one full pass *per column*, which
    cost ~1s on a 65k-row export). Type rules match infer()."""
    reader = csv.reader(io.StringIO(csv_text))
    try:
        hdr = next(reader)
    except StopIteration:
        raise ValueError("analysis returned no rows")
    nc = len(hdr)
    maxlen = [0] * nc
    nulls = [0] * nc
    seen = [False] * nc                       # any non-empty value?
    date_bad = [0] * nc                        # non-empty values that AREN'T a date
    is_int = [True] * nc
    is_num = [True] * nc
    has_alpha = [False] * nc                   # any value with a letter (-> real text)
    nrows = 0
    for r in reader:
        nrows += 1
        for i in range(nc):
            v = clean_cell(r[i]) if i < len(r) else ""   # unguard OBIEE numerics first
            if len(v) > maxlen[i]:
                maxlen[i] = len(v)
            if v.strip() == "":
                nulls[i] += 1
                continue
            seen[i] = True
            if not DATE_RE.match(v):
                date_bad[i] += 1
            if not has_alpha[i] and ALPHA_RE.search(v):
                has_alpha[i] = True
            # numeric tests run on the COERCED value so OBIEE-formatted numbers
            # ('-33750, 1,234.56, (123)) are recognised as numbers, not text.
            cv = coerce_number(v)
            if is_int[i] and not INT_RE.match(cv):
                is_int[i] = False
            if is_num[i] and not NUM_RE.match(cv):
                is_num[i] = False
    used, cols = set(), []
    for i, h in enumerate(hdr):
        nonnull = nrows - nulls[i]
        suffix = is_numeric_suffix(h)
        hint = is_numeric_name(h)
        # DATE if (nearly) every value parses as a date — tolerate <=2% dirty cells
        # (real OTBI exports occasionally misalign a row via free-text commas); the
        # loader nulls an unparseable date cell rather than failing the whole load.
        date_ok = seen[i] and maxlen[i] <= 30 and date_bad[i] <= nonnull // 50
        if not seen[i]:
            typ = "NUMBER" if suffix else "VARCHAR2(40)"   # explicit suffix wins even if empty
        elif date_ok and not hint:
            typ = "DATE"
        elif is_int[i] and maxlen[i] <= INT_MAXLEN:
            typ = "NUMBER"
        elif is_num[i] and maxlen[i] <= NUM_MAXLEN:
            typ = "NUMBER"
        elif hint and not has_alpha[i]:
            # amount-named + no alphabetic values -> NUMBER (coerced on load). Guards
            # against a keyword false-positive on a text column (e.g. CONTROL_BUDGET
            # holding words), which keeps its letters and so stays VARCHAR2.
            typ = "NUMBER"
        elif suffix:
            # explicit suffix is a hard contract: force NUMBER even past alpha values;
            # if the column is genuinely text the load fails loudly (named it wrong).
            typ = "NUMBER"
        else:
            typ = f"VARCHAR2({bucket(maxlen[i])})"
        cols.append({"header": h, "name": colname(h, used),
                     "type": typ, "maxlen": maxlen[i], "nulls": nulls[i],
                     "allnull": not seen[i]})
    return cols, nrows


def column_map(cols):
    """{CSV header -> target column name} from a profile()."""
    return {c["header"]: c["name"] for c in cols}


def create_table_sql(table, cols):
    """CREATE TABLE DDL sized/typed from the profile (+ a load_ts audit column)."""
    tbl = table if "." in table else "prod." + table
    lines = [f"CREATE TABLE {tbl} ("]
    for c in cols:
        lines.append(f"  {c['name']:<26} {c['type']:<16},  -- {c['header']}")
    lines.append("  load_ts                    TIMESTAMP DEFAULT SYSTIMESTAMP")
    lines.append(")")
    return "\n".join(lines)


def _needs_prep(job):
    cm = job.get("column_map_json")
    return not (cm and str(cm).strip())


def _split(table):
    owner, name = (table.split(".", 1) if "." in table else ("PROD", table))
    return owner.upper(), name.upper()


# ---- schema-drift reconciliation (shared, DB-agnostic) -------------------
def _evolve(cur, live):
    """Decide how an existing column should change for the live data.
    Returns ('widen', new_type) | ('incompat', message) | None."""
    # An all-empty column this run carries NO type evidence: it profiles to the
    # all-null default (VARCHAR2(40)), so without this guard a DATE/NUMBER column
    # that's simply empty in this extract would be mis-flagged "incompatible" (or a
    # narrower text column would be force-widened). NULLs load into any type fine.
    if live.get("allnull"):
        return None
    ctype, clen = cur["type"], (cur["len"] or 0)
    ltype = live["type"]
    if ctype.startswith("VARCHAR2"):
        if ltype.startswith("VARCHAR2"):
            need = int(ltype[ltype.find("(") + 1:-1])
            if need > clen:
                return ("widen", f"VARCHAR2({need})")
        return None                      # numbers/dates load fine as strings
    if ctype == "NUMBER":
        if ltype.startswith("VARCHAR2"):
            return ("incompat", f"now has non-numeric values (needs {ltype}) but column is NUMBER")
        return None                      # NUMBER is unbounded in our DDL
    if ctype.startswith(("DATE", "TIMESTAMP")):
        if ltype.startswith("VARCHAR2"):
            return ("incompat", f"now has non-date values (needs {ltype}) but column is {ctype}")
        return None
    return None


def _plan_drift(cols, cur_map, table_cols):
    """Diff the live CSV (cols=profile()) against the stored map + table columns.
    Returns (adds, widens, removed, incompat, new_map)."""
    by_header = {c["header"]: c for c in cols}
    used = set(cur_map.values())
    adds, widens, removed, incompat = [], [], [], []
    new_map = dict(cur_map)
    for c in cols:                       # columns the analysis grew
        if c["header"] not in cur_map:
            name = colname(c["header"], used)
            adds.append((c["header"], name, c["type"]))
            new_map[c["header"]] = name
    for h in cur_map:                    # columns the analysis lost
        if h not in by_header:
            removed.append(h)
    for h, col in cur_map.items():       # surviving columns: widen / flag
        if h not in by_header:
            continue
        meta = table_cols.get(col.upper())
        if not meta:
            continue
        d = _evolve(meta, by_header[h])
        if d and d[0] == "widen":
            widens.append((col, d[1]))
        elif d and d[0] == "incompat":
            incompat.append((col, d[1]))
    return adds, widens, removed, incompat, new_map


def _drift_warnings(adds, widens, removed, incompat):
    w = []
    for h, name, typ in adds:
        w.append(f"new column '{h}' added as {name} {typ}")
    for col, typ in widens:
        w.append(f"widened {col} -> {typ}")
    for h in removed:
        w.append(f"column '{h}' no longer in the analysis - loading NULL")
    for col, msg in incompat:
        w.append(f"{col}: {msg} - load may fail")
    return w


# ---- oracledb path -------------------------------------------------------
def _table_exists_ora(conn, table):
    owner, name = _split(table)
    cur = conn.cursor()
    cur.execute("select count(*) from all_tables where owner=:o and table_name=:t",
                o=owner, t=name)
    return cur.fetchone()[0] > 0


def _table_columns_ora(conn, table):
    owner, name = _split(table)
    cur = conn.cursor()
    cur.execute("""select column_name, data_type, data_length, char_length
                     from all_tab_columns where owner=:o and table_name=:t""",
                o=owner, t=name)
    return {r[0].upper(): {"type": r[1].upper(), "len": (r[3] or r[2])} for r in cur.fetchall()}


def ensure_prepared_oracledb(conn, job, csv_text):
    """Prepare/reconcile the job's staging table from the live CSV, then return a
    list of drift warnings (empty = clean). First run (no column map): profile,
    CREATE the table when missing, persist column_map_json + stage_table. Later
    runs: diff the live header vs the stored map and auto-adapt - ADD new columns,
    widen outgrown text columns - keeping dropped columns (load NULL) and flagging
    incompatible changes. `job` is mutated in place so the caller can load now."""
    cols, n = profile(csv_text)
    cur = conn.cursor()
    if _needs_prep(job):
        stage = (job.get("stage_table") or "").strip() or ("PROD." + derive_table(job.get("source_ref", "")))
        cmap = json.dumps(column_map(cols), ensure_ascii=False)
        for tbl in [stage, (job.get("final_table") or "").strip()]:
            if tbl and not _table_exists_ora(conn, tbl):
                cur.execute(create_table_sql(tbl, cols))
        cur.execute("update prod.atd_otbi_jobs set column_map_json=:m, stage_table=:s "
                    "where job_name=:j", m=cmap, s=stage, j=job["job_name"])
        conn.commit()
        job["stage_table"], job["column_map_json"] = stage, cmap
        print(f"[prepare] {job['job_name']}: created/mapped {len(cols)} columns -> {stage} "
              f"({n} sample rows)")
        return []

    cur_map = json.loads(job["column_map_json"])
    table_cols = _table_columns_ora(conn, job["stage_table"])
    adds, widens, removed, incompat, new_map = _plan_drift(cols, cur_map, table_cols)
    if adds or widens:
        for tbl in [job["stage_table"], (job.get("final_table") or "").strip()]:
            if not tbl:
                continue
            for h, name, typ in adds:
                cur.execute(f"alter table {tbl} add ({name} {typ})")
            for col, typ in widens:
                cur.execute(f"alter table {tbl} modify ({col} {typ})")
        cmap = json.dumps(new_map, ensure_ascii=False)
        cur.execute("update prod.atd_otbi_jobs set column_map_json=:m where job_name=:j",
                    m=cmap, j=job["job_name"])
        conn.commit()
        job["column_map_json"] = cmap
    warns = _drift_warnings(adds, widens, removed, incompat)
    if warns:
        print(f"[drift] {job['job_name']}: " + "; ".join(warns))
    return warns


# ---- SQLcl path ----------------------------------------------------------
def _table_exists_sqlcl(table):
    import sqlrun
    owner, name = _split(table)
    rows = sqlrun.query_json(
        f"select count(*) c from all_tables where owner='{owner}' and table_name='{name}'")
    return bool(rows) and int(rows[0].get("c", 0)) > 0


def _table_columns_sqlcl(table):
    import sqlrun
    owner, name = _split(table)
    rows = sqlrun.query_json(
        "select column_name, data_type, data_length, char_length from all_tab_columns "
        f"where owner='{owner}' and table_name='{name}'")
    out = {}
    for r in rows:
        out[str(r["column_name"]).upper()] = {
            "type": str(r["data_type"]).upper(),
            "len": r.get("char_length") or r.get("data_length")}
    return out


def ensure_prepared_sqlcl(job, csv_text):
    """SQLcl-mode prepare/reconcile (see ensure_prepared_oracledb). Returns drift warnings."""
    import sqlrun
    cols, n = profile(csv_text)
    if _needs_prep(job):
        stage = (job.get("stage_table") or "").strip() or ("PROD." + derive_table(job.get("source_ref", "")))
        cmap = json.dumps(column_map(cols), ensure_ascii=False)
        for tbl in [stage, (job.get("final_table") or "").strip()]:
            if tbl and not _table_exists_sqlcl(tbl):
                sqlrun.run_sql(create_table_sql(tbl, cols) + ";")
        jn = job["job_name"].replace("'", "''"); cm = cmap.replace("'", "''")
        sqlrun.run_sql(
            f"UPDATE prod.atd_otbi_jobs SET column_map_json='{cm}', stage_table='{stage}' "
            f"WHERE job_name='{jn}';\nCOMMIT;")
        job["stage_table"], job["column_map_json"] = stage, cmap
        print(f"[prepare] {job['job_name']}: created/mapped {len(cols)} columns -> {stage} "
              f"({n} sample rows)")
        return []

    cur_map = json.loads(job["column_map_json"])
    table_cols = _table_columns_sqlcl(job["stage_table"])
    adds, widens, removed, incompat, new_map = _plan_drift(cols, cur_map, table_cols)
    if adds or widens:
        ddl = []
        for tbl in [job["stage_table"], (job.get("final_table") or "").strip()]:
            if not tbl:
                continue
            for h, name, typ in adds:
                ddl.append(f"ALTER TABLE {tbl} ADD ({name} {typ});")
            for col, typ in widens:
                ddl.append(f"ALTER TABLE {tbl} MODIFY ({col} {typ});")
        cm = json.dumps(new_map, ensure_ascii=False).replace("'", "''")
        jn = job["job_name"].replace("'", "''")
        ddl.append(f"UPDATE prod.atd_otbi_jobs SET column_map_json='{cm}' WHERE job_name='{jn}';")
        ddl.append("COMMIT;")
        sqlrun.run_sql("\n".join(ddl))
        job["column_map_json"] = json.dumps(new_map, ensure_ascii=False)
    warns = _drift_warnings(adds, widens, removed, incompat)
    if warns:
        print(f"[drift] {job['job_name']}: " + "; ".join(warns))
    return warns
