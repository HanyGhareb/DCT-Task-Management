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


def apply_runner_config(conn=None):
    """Overlay the UI-managed operational settings (ATD_RUNNER_CONFIG) onto the
    process environment at startup. DB value wins over env.ps1 for these keys;
    secrets are NOT stored there (they stay in env.ps1 / Vault). Best-effort:
    a failure here never blocks a run. Reads via the live oracledb connection
    when given, else via SQLcl (sqlrun)."""
    try:
        rows = []
        if conn is not None:
            cur = conn.cursor()
            cur.execute("select config_key, config_value from prod.atd_runner_config "
                        "where config_value is not null")
            rows = cur.fetchall()
        else:
            import sqlrun
            data = sqlrun.query_json(
                "select config_key, config_value from prod.atd_runner_config "
                "where config_value is not null")
            rows = [(d.get("config_key"), d.get("config_value")) for d in (data or [])]
    except Exception as e:  # noqa: BLE001
        print(f"[config] ATD_RUNNER_CONFIG not applied: {e}")
        return 0
    n = 0
    for k, v in rows:
        if k and v is not None and str(v) != "":
            os.environ[str(k)] = str(v)
            n += 1
    if n:
        print(f"[config] applied {n} runner settings from ATD_RUNNER_CONFIG")
    return n


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
                     j.column_map_json, j.schema_reviewed, e.analytics_base_url, e.credential_ref,
                     e.extract_track, t.db_kind
                from prod.atd_otbi_jobs j
                join prod.atd_otbi_env e on e.env_name = j.env_name
                join prod.atd_target_db t on t.target_name = j.target_name
               where {where}
               order by j.priority, j.run_order, j.job_name"""
    return sqlrun.query_json(sql)


def get_default_browser_env(conn):
    """First enabled BROWSER-track env — used when an action row has no env_name."""
    cur = conn.cursor()
    cur.execute("select * from (select * from prod.atd_otbi_env "
                "where enabled='Y' and extract_track='BROWSER' order by env_name) "
                "where rownum = 1")
    rows = _rows(cur)
    return rows[0] if rows else None


def get_action(conn, action_id):
    """Fetch one ATD_ACTION_REQUEST row (+ its env's URLs/credential_ref).
    env columns are NULL when the action carries no env_name (caller falls back
    to get_default_browser_env)."""
    cur = conn.cursor()
    cur.execute("""select a.action_id, a.action_type, a.env_name, a.source_module,
                          a.source_type, a.source_id, a.source_ref, a.idem_key,
                          a.payload_json, e.analytics_base_url, e.xmlpserver_base_url,
                          e.fusion_apps_url, e.credential_ref
                     from prod.atd_action_request a
                     left join prod.atd_otbi_env e on e.env_name = a.env_name
                    where a.action_id = :id""", id=action_id)
    rows = _rows(cur)
    if not rows:
        return None
    a = rows[0]
    v = a.get("payload_json")
    if v is not None and not isinstance(v, str):
        a["payload_json"] = v.read()
    return a


def get_browser_jobs(conn, only=None):
    """Enabled jobs whose env is BROWSER track (Track B owns these)."""
    cur = conn.cursor()
    sql = """select j.job_name, j.env_name, j.target_name, j.source_ref, j.params_json,
                    j.stage_table, j.final_table, j.load_mode, j.key_columns,
                    j.column_map_json, j.schema_reviewed, e.analytics_base_url, e.credential_ref,
                    e.extract_track, t.db_kind
               from prod.atd_otbi_jobs j
               join prod.atd_otbi_env e on e.env_name = j.env_name
               join prod.atd_target_db t on t.target_name = j.target_name
              where j.enabled = 'Y' and e.enabled = 'Y'
                and e.extract_track = 'BROWSER'"""
    if only:
        sql += " and j.job_name = :n"
    sql += " order by j.priority, j.run_order, j.job_name"
    if only:
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
