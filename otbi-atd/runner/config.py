"""otbi-atd Track B : configuration access.

Reads the SAME control tables as Track A (ATD_OTBI_ENV / ATD_TARGET_DB /
ATD_OTBI_JOBS) from the ATP, so both tracks share one source of truth.

DB connection comes from environment variables (never hard-coded):
  ATD_DB_USER, ATD_DB_PASSWORD, ATD_DB_DSN   (DSN = a tnsnames alias)
  TNS_ADMIN  -> the wallet directory (myDoc/)
Fusion login is interactive (SSO/MFA) in auth.py, so no Fusion password here.
"""
import os
import oracledb


def connect():
    """Connect to the ATP that holds the control tables (thin mode + wallet)."""
    return oracledb.connect(
        user=os.environ["ATD_DB_USER"],
        password=os.environ["ATD_DB_PASSWORD"],
        dsn=os.environ["ATD_DB_DSN"],
        config_dir=os.environ.get("TNS_ADMIN"),
        wallet_location=os.environ.get("TNS_ADMIN"),
        wallet_password=os.environ.get("ATD_WALLET_PASSWORD"),  # None for auto-login wallet
    )


def _rows(cur):
    cols = [c[0].lower() for c in cur.description]
    return [dict(zip(cols, r)) for r in cur.fetchall()]


def get_env(conn, env_name):
    cur = conn.cursor()
    cur.execute("""select * from prod.atd_otbi_env where env_name = :n""", n=env_name)
    rows = _rows(cur)
    if not rows:
        raise KeyError(f"env not found: {env_name}")
    return rows[0]


def get_target(conn, target_name):
    cur = conn.cursor()
    cur.execute("""select * from prod.atd_target_db where target_name = :n""", n=target_name)
    rows = _rows(cur)
    if not rows:
        raise KeyError(f"target not found: {target_name}")
    return rows[0]


def get_browser_jobs_sqlcl(only=None):
    """Read enabled BROWSER-track jobs (+ env/target fields) via SQLcl (no creds)."""
    import sqlrun
    where = "j.enabled='Y' and e.enabled='Y' and e.extract_track='BROWSER'"
    if only:
        where += f" and j.job_name='{only}'"
    sql = f"""select j.job_name, j.env_name, j.target_name, j.source_ref, j.params_json,
                     j.stage_table, j.final_table, j.load_mode, j.key_columns,
                     j.column_map_json, e.analytics_base_url, e.credential_ref,
                     e.extract_track, t.db_kind
                from prod.atd_otbi_jobs j
                join prod.atd_otbi_env e on e.env_name = j.env_name
                join prod.atd_target_db t on t.target_name = j.target_name
               where {where}
               order by j.job_name"""
    return sqlrun.query_json(sql)


def get_browser_jobs(conn, only=None):
    """Enabled jobs whose env is BROWSER track (Track B owns these)."""
    cur = conn.cursor()
    sql = """select j.* from prod.atd_otbi_jobs j
               join prod.atd_otbi_env e on e.env_name = j.env_name
              where j.enabled = 'Y' and e.enabled = 'Y'
                and e.extract_track = 'BROWSER'"""
    if only:
        sql += " and j.job_name = :n"
        cur.execute(sql, n=only)
    else:
        cur.execute(sql)
    jobs = _rows(cur)
    # CLOB columns come back as LOB objects in thick paths; read them
    for j in jobs:
        for k in ("params_json", "column_map_json"):
            v = j.get(k)
            if v is not None and not isinstance(v, str):
                j[k] = v.read()
    return jobs
