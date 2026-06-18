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
import re

# Oracle reserved words we must not use as bare column names
RESERVED = {"ORDER", "DATE", "LEVEL", "NUMBER", "COMMENT", "ROW", "ROWID", "SIZE",
            "TABLE", "COLUMN", "ACCESS", "GROUP", "USER", "SESSION", "START", "TO",
            "FROM", "SELECT", "VALUES", "RAW", "DESC", "ASC", "MODE", "UID"}
LEN_BUCKETS = [10, 20, 30, 40, 60, 100, 150, 200, 300, 400, 600, 1000, 2000, 4000]
DATE_RE = re.compile(r"^\d{4}-\d{2}-\d{2}( \d{2}:\d{2}:\d{2})?$")
INT_RE = re.compile(r"^-?\d+$")
NUM_RE = re.compile(r"^-?\d+(\.\d+)?$")


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
    ne = [v for v in values if v.strip() != ""]
    if not ne:
        return "VARCHAR2(40)"          # all-null: safe default
    if all(DATE_RE.match(v) for v in ne):
        return "DATE"
    if all(INT_RE.match(v) for v in ne) and maxlen <= 15:
        return "NUMBER"
    if all(NUM_RE.match(v) for v in ne) and maxlen <= 18:
        return "NUMBER"
    return f"VARCHAR2({bucket(maxlen)})"


def profile(csv_text):
    """Return ([{header,name,type,maxlen,nulls}], row_count) from CSV text."""
    rows = list(csv.reader(io.StringIO(csv_text)))
    if not rows:
        raise ValueError("analysis returned no rows")
    hdr, data = rows[0], rows[1:]
    used, cols = set(), []
    for i, h in enumerate(hdr):
        vals = [r[i] if i < len(r) else "" for r in data]
        maxlen = max((len(v) for v in vals), default=0)
        cols.append({"header": h, "name": colname(h, used),
                     "type": infer(vals, maxlen), "maxlen": maxlen,
                     "nulls": sum(1 for v in vals if v.strip() == "")})
    return cols, len(data)


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


# ---- oracledb path -------------------------------------------------------
def _table_exists_ora(conn, table):
    owner, name = _split(table)
    cur = conn.cursor()
    cur.execute("select count(*) from all_tables where owner=:o and table_name=:t",
                o=owner, t=name)
    return cur.fetchone()[0] > 0


def ensure_prepared_oracledb(conn, job, csv_text):
    """If the job has no column map yet, profile the CSV, create the staging
    table when missing, persist column_map_json (+ stage_table) onto the job
    row, and mutate `job` in place so the caller can load immediately."""
    if not _needs_prep(job):
        return job
    cols, n = profile(csv_text)
    stage = (job.get("stage_table") or "").strip() or ("PROD." + derive_table(job.get("source_ref", "")))
    cmap = json.dumps(column_map(cols), ensure_ascii=False)
    cur = conn.cursor()
    for tbl in [stage, (job.get("final_table") or "").strip()]:
        if tbl and not _table_exists_ora(conn, tbl):
            cur.execute(create_table_sql(tbl, cols))
    cur.execute("update prod.atd_otbi_jobs set column_map_json=:m, stage_table=:s "
                "where job_name=:j", m=cmap, s=stage, j=job["job_name"])
    conn.commit()
    job["stage_table"] = stage
    job["column_map_json"] = cmap
    print(f"[prepare] {job['job_name']}: created/mapped {len(cols)} columns -> {stage} "
          f"({n} sample rows)")
    return job


# ---- SQLcl path ----------------------------------------------------------
def _table_exists_sqlcl(table):
    import sqlrun
    owner, name = _split(table)
    rows = sqlrun.query_json(
        f"select count(*) c from all_tables where owner='{owner}' and table_name='{name}'")
    return bool(rows) and int(rows[0].get("c", 0)) > 0


def ensure_prepared_sqlcl(job, csv_text):
    if not _needs_prep(job):
        return job
    import sqlrun
    cols, n = profile(csv_text)
    stage = (job.get("stage_table") or "").strip() or ("PROD." + derive_table(job.get("source_ref", "")))
    cmap = json.dumps(column_map(cols), ensure_ascii=False)
    for tbl in [stage, (job.get("final_table") or "").strip()]:
        if tbl and not _table_exists_sqlcl(tbl):
            sqlrun.run_sql(create_table_sql(tbl, cols) + ";")
    jn = job["job_name"].replace("'", "''")
    cm = cmap.replace("'", "''")
    sqlrun.run_sql(
        f"UPDATE prod.atd_otbi_jobs SET column_map_json='{cm}', stage_table='{stage}' "
        f"WHERE job_name='{jn}';\nCOMMIT;")
    job["stage_table"] = stage
    job["column_map_json"] = cmap
    print(f"[prepare] {job['job_name']}: created/mapped {len(cols)} columns -> {stage} "
          f"({n} sample rows)")
    return job
