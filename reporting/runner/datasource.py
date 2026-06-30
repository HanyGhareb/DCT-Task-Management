"""Run a report definition's data source and return (columns, rows).

source_type:
  SQL  -> source_ref is a SELECT (may contain :named binds drawn from params)
  VIEW -> source_ref is a view/table name -> SELECT * FROM <name>
  PKG  -> source_ref is a PL/SQL expression returning a ref cursor (not used yet)

Only binds that actually appear in the SQL are passed, so a definition's default
params can carry extra keys harmlessly.
"""
import re

_BIND = re.compile(r":([A-Za-z_][A-Za-z0-9_]*)")


def fetch(conn, source_type, source_ref, params):
    source_type = (source_type or "SQL").upper()
    params = params or {}
    if source_type == "VIEW":
        sql = "SELECT * FROM " + source_ref
        binds = {}
    elif source_type == "SQL":
        sql = source_ref
        names = set(m.group(1).lower() for m in _BIND.finditer(sql))
        binds = {n: params.get(n) for n in names}
    else:
        raise ValueError(f"unsupported source_type: {source_type}")

    cur = conn.cursor()
    cur.execute(sql, binds) if binds else cur.execute(sql)
    columns = [d[0].lower() for d in cur.description]
    rows = cur.fetchall()
    return columns, rows
