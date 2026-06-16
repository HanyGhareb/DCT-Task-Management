"""otbi-atd : load a CSV into the target table via SQLcl (no oracledb creds).

Generates a TRUNCATE + INSERT script (per-value typing: dates -> TO_DATE,
blanks -> NULL, everything else quoted and let Oracle implicitly convert into
NUMBER/VARCHAR2 columns) plus the ATD_LOAD_RUN_LOG row, and runs it through the
configured SQLcl connection. Returns the row count loaded.
"""
import csv
import io
import json
import os
import re
import hashlib

import sqlrun
import checks


def _logvals(job_name, n, checksum):
    """Build the (row_count, csv_checksum, message) tail for a SUCCESS run-log row."""
    note = checks.truncation_note(n)
    msg = "NULL" if not note else "'" + note.replace("'", "''") + "'"
    return f"{n},'{checksum}',{msg}"

_DT = re.compile(r"^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$")
_D = re.compile(r"^\d{4}-\d{2}-\d{2}$")


def _lit(v):
    v = "" if v is None else v.strip()
    if v == "":
        return "NULL"
    if _DT.match(v):
        return "TO_DATE('" + v + "','YYYY-MM-DD HH24:MI:SS')"
    if _D.match(v):
        return "TO_DATE('" + v + "','YYYY-MM-DD')"
    return "'" + v.replace("'", "''") + "'"


def _parse(csv_text, column_map):
    reader = csv.DictReader(io.StringIO(csv_text))
    headers = {h.strip().lower(): h for h in (reader.fieldnames or [])}
    pairs = [(headers[k.strip().lower()], v)
             for k, v in column_map.items() if k.strip().lower() in headers]
    if not pairs:
        raise RuntimeError("no column_map header matched the CSV")
    cols = [v.upper() for _, v in pairs]
    rows = [[r.get(src) for src, _ in pairs] for r in reader]
    return cols, rows


_BAREDATE = re.compile(r"^\d{4}-\d{2}-\d{2}$")


def _date_columns(table):
    """Names of DATE/TIMESTAMP columns in the (PROD.)table, via SQLcl."""
    owner, tname = (table.split(".", 1) if "." in table else ("PROD", table))
    rows = sqlrun.query_json(
        f"select column_name from all_tab_columns where owner='{owner.upper()}' "
        f"and table_name='{tname.upper()}' "
        "and (data_type='DATE' or data_type like 'TIMESTAMP%')")
    return {r["column_name"].upper() for r in rows}


def _load_bulk(job, csv_text):
    """Fast path: rewrite headers to column names, normalize dates, SQLcl LOAD."""
    cols, rows = _parse(csv_text, json.loads(job["column_map_json"]))
    stage = job["stage_table"]
    checksum = hashlib.sha256(csv_text.encode("utf-8", "replace")).hexdigest()
    job_name = job["job_name"].replace("'", "''")
    date_idx = [i for i, c in enumerate(cols) if c in _date_columns(stage)]

    data_csv = os.path.join(sqlrun.TMP, f"atd_{job_name}_data.csv")
    with open(data_csv, "w", encoding="utf-8", newline="") as f:
        w = csv.writer(f)
        w.writerow(cols)                                   # header = target column names
        for r in rows:
            row = [(r[i] if i < len(r) else "") or "" for i in range(len(cols))]
            for i in date_idx:                             # bare date -> add 00:00:00
                if _BAREDATE.match(row[i].strip()):
                    row[i] = row[i].strip() + " 00:00:00"
            w.writerow(row)

    script = os.path.join(sqlrun.TMP, f"atd_load_{job_name}.sql")
    with open(script, "w", encoding="utf-8", newline="\r\n") as f:
        f.write("SET DEFINE OFF\n")
        f.write("ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';\n")
        f.write("ALTER SESSION SET NLS_TIMESTAMP_FORMAT='YYYY-MM-DD HH24:MI:SS';\n")
        f.write("SET LOAD BATCHES 50\n")
        f.write(f"TRUNCATE TABLE {stage};\n")
        f.write(f"LOAD {stage} {os.path.abspath(data_csv)}\n")
        f.write("EXIT;\n")
    try:
        out = sqlrun.run_script(script, check=True).stdout
    finally:
        for p in (script, data_csv):
            try: os.remove(p)
            except OSError: pass

    m = re.search(r"rows in error[: ]+(\d+)", out, re.I)
    errs = int(m.group(1)) if m else (0 if "rows in error" not in out.lower() else 1)
    if errs:
        snippet = "\n".join(l for l in out.splitlines() if "#ERROR" in l)[:1500]
        log_failure(job["job_name"], f"LOAD had {errs} row error(s): {snippet}")
        raise RuntimeError(f"LOAD reported {errs} row error(s) for {stage}")

    sqlrun.run_sql(
        "INSERT INTO prod.atd_load_run_log(job_name, track, status, finished, row_count, "
        f"csv_checksum, message) VALUES ('{job_name}','BROWSER','SUCCESS',systimestamp,"
        f"{_logvals(job_name, len(rows), checksum)});\nCOMMIT;")
    return len(rows)


def load(job, csv_text):
    if job["load_mode"] != "TRUNCATE_INSERT":
        raise NotImplementedError("SQLcl loader currently supports TRUNCATE_INSERT only")
    # NOTE: SQLcl LOAD ("bulk") was measured ~3x SLOWER than batched INSERT on this
    # ADB (368s vs 115s for the 3 jobs), so INSERT is the default. Keep bulk opt-in.
    if (os.environ.get("ATD_LOAD_METHOD", "insert").lower() == "bulk"):
        return _load_bulk(job, csv_text)
    cols, rows = _parse(csv_text, json.loads(job["column_map_json"]))
    stage = job["stage_table"]
    collist = ",".join(cols)
    checksum = hashlib.sha256(csv_text.encode("utf-8", "replace")).hexdigest()
    job_name = job["job_name"].replace("'", "''")

    batch = int(os.environ.get("ATD_LOAD_BATCH", "200"))
    script = os.path.join(sqlrun.TMP, f"atd_load_{job_name}.sql")
    with open(script, "w", encoding="utf-8", newline="\r\n") as f:
        f.write("WHENEVER SQLERROR EXIT FAILURE\nSET DEFINE OFF\nSET SQLBLANKLINES ON\n")
        f.write("ALTER SESSION DISABLE PARALLEL DML;\n")
        f.write(f"TRUNCATE TABLE {stage};\n")
        # batched multi-row INSERT ALL (no identity cols -> safe); load_ts defaults
        for i in range(0, len(rows), batch):
            f.write("INSERT ALL\n")
            for r in rows[i:i + batch]:
                vals = ",".join(_lit(r[k] if k < len(r) else "") for k in range(len(cols)))
                f.write(f"  INTO {stage} ({collist}) VALUES ({vals})\n")
            f.write("SELECT 1 FROM dual;\n")
        f.write("INSERT INTO prod.atd_load_run_log"
                "(job_name, track, status, finished, row_count, csv_checksum, message) "
                f"VALUES ('{job_name}','BROWSER','SUCCESS',systimestamp,"
                f"{_logvals(job_name, len(rows), checksum)});\n")
        f.write("COMMIT;\nEXIT;\n")
    try:
        sqlrun.run_script(script, check=True)
    finally:
        try: os.remove(script)
        except OSError: pass
    return len(rows)


def log_failure(job_name, message):
    jn = job_name.replace("'", "''")
    msg = (message or "")[:3900].replace("'", "''")
    sqlrun.run_sql(
        "INSERT INTO prod.atd_load_run_log(job_name, track, status, finished, message) "
        f"VALUES ('{jn}','BROWSER','FAILED',systimestamp,'{msg}');\nCOMMIT;", check=False)
