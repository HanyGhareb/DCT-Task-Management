"""i-Finance Reporting runner : DB connection + UI-managed config access.

Connects to the SAME ADB that holds the DCT_RPT_* control plane (thin mode + wallet).
Reuses the otbi-atd runner's env-var names so it can share a worker VM / env.ps1;
RPT_DB_* overrides ATD_DB_* when set.

  RPT_DB_USER|ATD_DB_USER, RPT_DB_PASSWORD|ATD_DB_PASSWORD, RPT_DB_DSN|ATD_DB_DSN
  TNS_ADMIN                -> wallet directory (myDoc/)
  RPT_SMTP_PASSWORD        -> SMTP password (SECRET; never in DCT_RPT_CONFIG)

Non-secret runtime/SMTP settings live in DCT_RPT_CONFIG (UI-editable) and are read
fresh each run via load_config().
"""
import os
import oracledb

# return CLOBs (source_ref, params_json, email_body_tpl) as plain str, not LOB locators
oracledb.defaults.fetch_lobs = False


def _env(*names, required=True, default=None):
    for n in names:
        v = os.environ.get(n)
        if v:
            return v
    if required:
        raise KeyError("missing env var (any of): " + ", ".join(names))
    return default


def connect():
    """Connect to the ADB holding the DCT_RPT_* tables (thin mode + wallet)."""
    tns = os.environ.get("TNS_ADMIN")
    return oracledb.connect(
        user=_env("RPT_DB_USER", "ATD_DB_USER"),
        password=_env("RPT_DB_PASSWORD", "ATD_DB_PASSWORD"),
        dsn=_env("RPT_DB_DSN", "ATD_DB_DSN"),
        config_dir=tns,
        wallet_location=tns,
        wallet_password=_env("RPT_WALLET_PASSWORD", "ATD_WALLET_PASSWORD",
                             required=False),
    )


def load_config(conn):
    """DCT_RPT_CONFIG as a {key: value} dict (non-secret runtime/SMTP settings)."""
    cur = conn.cursor()
    cur.execute("select config_key, config_value from prod.dct_rpt_config")
    return {k: v for (k, v) in cur.fetchall()}


def cfg(conf, key, default=None):
    """Read a config value with a fallback for None/empty."""
    v = conf.get(key)
    return v if v not in (None, "") else default
