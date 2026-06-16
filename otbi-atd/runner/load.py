"""otbi-atd Track B : load CSV into the target database.

Generic, config-driven:
  - column_map_json maps {"CSV Header": "TARGET_COL"}
  - TRUNCATE_INSERT clears the staging table first; MERGE upserts stage->final
    on key_columns. Stage and final are assumed to share column names.
  - DATE/TIMESTAMP target columns are parsed in Python (mixed date-only and
    datetime values are handled), so no NLS dependency. Empty -> NULL.

For a LOCAL_ATP target this reuses the same connection that read the control
tables. For a REMOTE target, pass a separate connection.
"""
import csv
import io
import json
from datetime import datetime

DATE_FORMATS = ("%Y-%m-%d %H:%M:%S", "%Y-%m-%d", "%d-%b-%Y", "%d-%b-%y",
                "%m/%d/%Y %H:%M:%S", "%m/%d/%Y")


def _to_dt(s):
    s = (s or "").strip()
    if s == "":
        return None
    for f in DATE_FORMATS:
        try:
            return datetime.strptime(s, f)
        except ValueError:
            continue
    raise ValueError(f"unparseable date value: {s!r}")


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
    reader = csv.DictReader(io.StringIO(csv_text))
    headers = {h.strip().lower(): h for h in (reader.fieldnames or [])}
    pairs = [(headers[k.strip().lower()], v)
             for k, v in column_map.items() if k.strip().lower() in headers]
    if not pairs:
        raise RuntimeError("no column_map header matched the CSV")
    target_cols = [v.upper() for _, v in pairs]
    rows = [[r.get(src) for src, _ in pairs] for r in reader]
    return target_cols, rows


def load(conn, csv_text, stage_table, final_table, load_mode, key_columns, column_map_json):
    column_map = json.loads(column_map_json)
    target_cols, rows = _parse_csv(csv_text, column_map)
    types = _col_types(conn, stage_table)

    # per-column converters: dates -> datetime, blanks -> None, else keep string
    is_date = [types.get(c, "").startswith(("DATE", "TIMESTAMP")) for c in target_cols]
    conv = []
    for r in rows:
        out = []
        for i, v in enumerate(r):
            if is_date[i]:
                out.append(_to_dt(v))
            else:
                out.append(None if (v is None or v == "") else v)
        conv.append(out)

    cur = conn.cursor()
    if load_mode == "TRUNCATE_INSERT":
        cur.execute(f"truncate table {stage_table}")

    binds = ", ".join(f":{i+1}" for i in range(len(target_cols)))
    cur.executemany(
        f"insert into {stage_table} ({', '.join(target_cols)}) values ({binds})", conv)

    if load_mode == "MERGE" and final_table:
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
