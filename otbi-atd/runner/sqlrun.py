"""otbi-atd : DB access via the already-configured SQLcl connection.

No python-oracledb credentials needed - everything goes through
`sql -name <conn> @script`, reusing SQLcl's stored `prod_mcp` connection.

Env:
  ATD_SQLCL       path to sql/sql.exe (default: known local path, else 'sql')
  ATD_SQLCL_CONN  SQLcl named connection (default 'prod_mcp')
  ATD_TMP         scratch dir for generated scripts/spool (default system temp)
"""
import json
import os
import subprocess
import tempfile
import uuid

_DEFAULT_SQLCL = r"C:\claude\tools\sqlcl\sqlcl\bin\sql.exe"
SQLCL = os.environ.get("ATD_SQLCL") or (_DEFAULT_SQLCL if os.path.exists(_DEFAULT_SQLCL) else "sql")
CONN = os.environ.get("ATD_SQLCL_CONN", "prod_mcp")
TMP = os.environ.get("ATD_TMP", tempfile.gettempdir())


def _tmp(name):
    return os.path.join(TMP, f"atd_{uuid.uuid4().hex[:8]}_{name}")


class _Result:
    def __init__(self, returncode, stdout):
        self.returncode = returncode
        self.stdout = stdout


def _empty_stdin():
    # SQLcl's console init calls available() on stdin; on Windows NUL/DEVNULL
    # that throws "IOException: Incorrect function". An empty REAL file works.
    p = os.path.join(TMP, "atd_sqlcl_empty.in")
    if not os.path.exists(p):
        open(p, "w").close()
    return p


def run_script(path, check=True):
    """Run an existing .sql via SQLcl; return a result with .returncode/.stdout.

    Output is redirected to a real file (not a pipe) and stdin is an empty real
    file - both required for SQLcl to start headless on Windows without a console.
    """
    out = _tmp("out.txt")
    try:
        with open(out, "w", encoding="utf-8") as ofh, open(_empty_stdin(), "rb") as ifh:
            cp = subprocess.run([SQLCL, "-name", CONN, f"@{os.path.abspath(path)}"],
                                stdout=ofh, stderr=subprocess.STDOUT, stdin=ifh)
        txt = open(out, encoding="utf-8", errors="replace").read()
    finally:
        try: os.remove(out)
        except OSError: pass
    if check and cp.returncode != 0:
        raise RuntimeError(f"SQLcl failed ({cp.returncode}):\n{txt}")
    return _Result(cp.returncode, txt)


def run_sql(sql_text, check=True):
    """Run a SQL/PLSQL snippet via SQLcl (a WHENEVER SQLERROR EXIT FAILURE guard is added)."""
    path = _tmp("run.sql")
    with open(path, "w", encoding="utf-8", newline="\r\n") as f:
        f.write("WHENEVER SQLERROR EXIT FAILURE\nSET DEFINE OFF\nSET SQLBLANKLINES ON\n")
        f.write(sql_text)
        f.write("\nEXIT;\n")
    try:
        return run_script(path, check=check)
    finally:
        try: os.remove(path)
        except OSError: pass


def query_json(select_sql):
    """Run a SELECT and return its rows as a list of dicts (via SQLcl JSON format)."""
    script = _tmp("q.sql")
    # SET LONG: SQLcl truncates CLOB columns to 80 chars by default, which
    # corrupts JSON columns (column_map_json/params_json) - raise it.
    body = ("SET SQLFORMAT JSON\nSET FEEDBACK OFF\nSET ECHO OFF\n"
            "SET LONG 100000000\nSET LONGCHUNKSIZE 100000000\n"
            f"{select_sql.rstrip().rstrip(';')};\nEXIT;\n")
    with open(script, "w", encoding="utf-8", newline="\r\n") as f:
        f.write(body)
    try:
        cp = run_script(script, check=True)
        txt = cp.stdout
        start = txt.find('{"results"')
        if start < 0:
            start = txt.find("{")
        if start < 0:
            return []
        data, _ = json.JSONDecoder().raw_decode(txt[start:])
        return (data.get("results") or [{}])[0].get("items", [])
    finally:
        try: os.remove(script)
        except OSError: pass
