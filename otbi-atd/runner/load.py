"""otbi-atd Track B : load CSV into the target database.

Generic, config-driven:
  - column_map_json maps {"CSV Header": "TARGET_COL"}
  - both modes clear the staging table first; MERGE then upserts stage->final
    on key_columns. Stage and final are assumed to share column names.
  - DATE/TIMESTAMP target columns are parsed in Python (mixed date-only and
    datetime values are handled), so no NLS dependency. Empty -> NULL.

For a LOCAL_ATP target this reuses the same connection that read the control
tables. For a REMOTE target, pass a separate connection.
"""
import csv
import io
import json
import os
from datetime import datetime

from prepare import clean_cell, coerce_number, resolve_pairs   # shared w/ profiler

DATE_FORMATS = ("%Y-%m-%d %H:%M:%S.%f", "%Y-%m-%dT%H:%M:%S.%f",
                "%Y-%m-%d %H:%M:%S", "%Y-%m-%dT%H:%M:%S", "%Y-%m-%d",
                "%d-%b-%Y %H:%M:%S", "%d-%b-%y %H:%M:%S", "%d-%b-%Y", "%d-%b-%y",
                "%m/%d/%Y %H:%M:%S", "%m/%d/%Y",
                # day-first numeric dashes (BIP templates on this AE pod emit
                # '14-07-2026'; a US month-first value would fail %d-%m and fall
                # through to None exactly as before this format existed)
                "%d-%m-%Y %H:%M:%S", "%d-%m-%Y")


def _to_dt(s):
    s = (s or "").strip()
    if s == "":
        return None
    for f in DATE_FORMATS:
        try:
            return datetime.strptime(s, f)
        except ValueError:
            continue
    # lenient: a stray non-date in a DATE column (e.g. an OTBI row misaligned by a
    # free-text comma) loads as NULL rather than failing the whole load
    return None


def _split(name):
    return (name.split(".", 1) if "." in name else (None, name))


def _col_types(conn, table):
    owner, tname = _split(table.upper())
    cur = conn.cursor()
    if owner:
        cur.execute("""select column_name, data_type from all_tab_columns
                        where owner=:o and table_name=:t""", o=owner, t=tname)
    else:
        cur.execute("""select column_name, data_type from user_tab_columns
                        where table_name=:t""", t=tname)
    return {r[0].upper(): r[1].upper() for r in cur.fetchall()}


def _parse_csv(csv_text, column_map):
    # positional reader: unlabelled OTBI columns (sentinel keys) resolve by CSV
    # position, real headers by normalised text - so blank-header columns still load.
    reader = csv.reader(io.StringIO(csv_text))
    raw_headers = next(reader, [])
    pairs = resolve_pairs(column_map, raw_headers)   # [(csv_index, TARGET_COL)]
    if not pairs:
        raise RuntimeError("no column_map header matched the CSV")
    target_cols = [v for _, v in pairs]
    rows = [[clean_cell(r[idx]) if idx < len(r) else None for idx, _ in pairs] for r in reader]
    return target_cols, rows


def load(conn, csv_text, stage_table, final_table, load_mode, key_columns, column_map_json,
         run_id=None, job_name=None, warning_state=None):
    column_map = json.loads(column_map_json)
    target_cols, rows = _parse_csv(csv_text, column_map)
    types = _col_types(conn, stage_table)

    # per-column converters: dates -> datetime, NUMBER -> coerced numeric string
    # (strip OBIEE apostrophe/commas/parens so it binds cleanly), blanks -> None,
    # everything else kept as the (lightly-cleaned) string.
    is_date = [types.get(c, "").startswith(("DATE", "TIMESTAMP")) for c in target_cols]
    is_num = [types.get(c, "").startswith("NUMBER") for c in target_cols]
    warnings = warning_state if warning_state is not None else {"total": 0, "items": []}
    warnings.setdefault("total", 0)
    warnings.setdefault("items", [])
    warning_limit = max(0, int(os.environ.get("ATD_WARNING_SAMPLE_LIMIT", "200")))
    conv = []
    for row_idx, r in enumerate(rows, start=2):  # CSV row 1 is the header
        out = []
        for i, v in enumerate(r):
            if is_date[i]:
                parsed = _to_dt(v)
                if parsed is None and v is not None and str(v).strip() != "":
                    warnings["total"] += 1
                    if len(warnings["items"]) < warning_limit:
                        warnings["items"].append({
                            "row_number": row_idx,
                            "column_name": target_cols[i],
                            "raw_value": str(v)[:1000],
                            "warning_code": "INVALID_DATE",
                            "message": "Value is not a supported date; NULL loaded",
                        })
                out.append(parsed)
            elif is_num[i]:
                cv = coerce_number(v)
                out.append(None if (cv is None or cv == "") else cv)
            else:
                out.append(None if (v is None or v == "") else v)
        conv.append(out)

    cur = conn.cursor()
    # Always clear the staging table first so it holds ONLY the current extract.
    # TRUNCATE_INSERT: stage IS the destination -> atomic replace. MERGE: stage is a
    # scratch table merged into final; if old rows lingered, a re-extracted key would
    # appear twice in the merge source -> ORA-30926. DELETE (not TRUNCATE) keeps the
    # clear-out in the same transaction as the INSERTs below — committed together at
    # the end. A failed reload thus rolls back and the table keeps its prior load
    # (caller must rollback on error before logging; TRUNCATE is DDL and would
    # auto-commit the empty state). Volumes here are the OTBI export cap, so cheap.
    cur.execute(f"delete from {stage_table}")

    # chunked array-bind insert: fast (one round-trip per chunk) and memory-bounded
    binds = ", ".join(f":{i+1}" for i in range(len(target_cols)))
    insert_sql = f"insert into {stage_table} ({', '.join(target_cols)}) values ({binds})"
    chunk = int(os.environ.get("ATD_DB_CHUNK", "5000"))
    for i in range(0, len(conv), chunk):
        cur.executemany(insert_sql, conv[i:i + chunk])

    # Store samples in the same transaction as the data load. If the load rolls
    # back, its warnings roll back too. The total can exceed the sample limit and
    # is carried in ATD_LOAD_RUN_LOG.message by runner.py.
    if run_id is not None and warnings["items"]:
        cur.executemany(
            "insert into prod.atd_load_row_warning "
            "(run_id, job_name, row_number, column_name, raw_value, warning_code, message) "
            "values (:1,:2,:3,:4,:5,:6,:7)",
            [(run_id, (job_name or "")[:80], w["row_number"], w["column_name"],
              w["raw_value"], w["warning_code"], w["message"])
             for w in warnings["items"]])

    if load_mode == "MERGE" and final_table:
        # stage and final MUST differ: the staging clear-out above empties stage, so a
        # same-table MERGE would wipe the data then self-merge an empty source.
        if stage_table.strip().upper() == final_table.strip().upper():
            raise RuntimeError(
                f"MERGE misconfigured: stage_table and final_table are the same "
                f"({final_table}). Point Final Table at a separate base table.")
        keys = [k.strip().upper() for k in (key_columns or "").split(",") if k.strip()]
        cols = target_cols
        on = " and ".join(f"t.{k}=s.{k}" for k in keys)
        setc = ", ".join(f"t.{c}=s.{c}" for c in cols if c not in keys)
        ins = ", ".join(cols)
        vals = ", ".join(f"s.{c}" for c in cols)
        merge = (f"merge into {final_table} t using {stage_table} s on ({on}) "
                 + (f"when matched then update set {setc} " if setc else "")
                 + f"when not matched then insert ({ins}) values ({vals})")
        cur.execute(merge)

    conn.commit()
    return len(conv)
