"""otbi-atd Track B : orchestrator.

For each enabled BROWSER-track job in the control tables:
  1) ensure an OTBI session (reuse saved, else MFA login - number to Telegram),
  2) download the analysis CSV via the Go-URL,
  3) load into the target table,
  4) write an ATD_LOAD_RUN_LOG row (SUCCESS/FAILED), warning on likely truncation.

Two DB modes (ATD_DB_MODE):
  sqlcl    (default) - all DB work via the configured SQLcl connection
                       (sql -name prod_mcp); NO separate DB credentials.
  oracledb (fast)    - python-oracledb chunked array-bind load (~10x faster on
                       big tables); needs ATD_DB_USER/ATD_DB_PASSWORD/ATD_DB_DSN
                       + TNS_ADMIN wallet. Best for large analyses / the OCI VM.

Usage:
  python runner.py            # all enabled BROWSER jobs
  python runner.py JOB_NAME   # one job
"""
import hashlib
import json
import os
import sys

from playwright.sync_api import sync_playwright

import config
import auth
import extract
import checks
import notify


def _warn_truncation(name, n):
    note = checks.truncation_note(n)
    if note:
        print(f"[WARN] {name}: {note}")
        notify.send(f"otbi-atd {name}: {note}")
    return note


def _drive(jobs, run_one_fn):
    """Group jobs by env, authenticate once per env, run each job."""
    by_env = {}
    for j in jobs:
        by_env.setdefault(j["env_name"], []).append(j)
    failures = 0
    with sync_playwright() as p:
        for env_name, env_jobs in by_env.items():
            j0 = env_jobs[0]
            env = {"env_name": env_name,
                   "analytics_base_url": j0["analytics_base_url"],
                   "credential_ref": j0.get("credential_ref") or env_name}
            browser, ctx = auth.authenticate(p, env)
            try:
                for job in env_jobs:
                    if not run_one_fn(ctx, env, job):
                        failures += 1
            finally:
                browser.close()
    return failures


# ---- SQLcl mode (default, no DB creds) ----------------------------------
def _run_one_sqlcl(ctx, env, job):
    import loadsql
    name = job["job_name"]
    try:
        params = json.loads(job["params_json"]) if job.get("params_json") else None
        csv_text = extract.download_csv(ctx, env, job["source_ref"], params)
        n = loadsql.load(job, csv_text)
        _warn_truncation(name, n)
        print(f"[ok] {name}: {n} rows -> {job['stage_table']}")
        return True
    except Exception as e:  # noqa: BLE001
        loadsql.log_failure(name, str(e))
        print(f"[FAIL] {name}: {e}")
        return False


# ---- oracledb mode (fast, chunked array-bind) ---------------------------
def _log_start(conn, name):
    cur = conn.cursor()
    rid = cur.var(int)
    cur.execute("insert into prod.atd_load_run_log(job_name, track, status) "
                "values (:n,'BROWSER','RUNNING') returning run_id into :r", n=name, r=rid)
    conn.commit()
    return rid.getvalue()[0]


def _log_end(conn, run_id, status, n=None, ck=None, msg=None):
    conn.cursor().execute(
        "update prod.atd_load_run_log set finished=systimestamp, status=:s, "
        "row_count=:rc, csv_checksum=:ck, message=:m where run_id=:id",
        s=status, rc=n, ck=ck, m=msg, id=run_id)
    conn.commit()


def _make_run_one_oracledb(conn, load):
    def run_one(ctx, env, job):
        name = job["job_name"]
        run_id = _log_start(conn, name)
        try:
            params = json.loads(job["params_json"]) if job.get("params_json") else None
            csv_text = extract.download_csv(ctx, env, job["source_ref"], params)
            ck = hashlib.sha256(csv_text.encode("utf-8", "replace")).hexdigest()
            n = load.load(conn, csv_text, job["stage_table"], job["final_table"],
                          job["load_mode"], job["key_columns"], job["column_map_json"])
            note = _warn_truncation(name, n)
            _log_end(conn, run_id, "SUCCESS", n=n, ck=ck, msg=note or None)
            print(f"[ok] {name}: {n} rows -> {job['stage_table']}")
            return True
        except Exception as e:  # noqa: BLE001
            _log_end(conn, run_id, "FAILED", msg=str(e)[:3900])
            print(f"[FAIL] {name}: {e}")
            return False
    return run_one


def _resolve_mode():
    """oracledb is the default fast path; fall back to sqlcl only when its
    credentials are absent. Explicit ATD_DB_MODE always wins."""
    m = os.environ.get("ATD_DB_MODE")
    if m:
        return m.lower()
    if os.environ.get("ATD_DB_USER") and os.environ.get("ATD_DB_PASSWORD"):
        return "oracledb"
    print("[mode] ATD_DB_USER/PASSWORD not set -> falling back to sqlcl "
          "(set them + ATD_WALLET_PASSWORD for the ~155x oracledb path)")
    return "sqlcl"


def main(argv):
    only = argv[1] if len(argv) > 1 else None
    mode = _resolve_mode()

    if mode == "oracledb":
        import load
        conn = config.connect()
        jobs = config.get_browser_jobs(conn, only=only)
        run_one = _make_run_one_oracledb(conn, load)
    else:
        jobs = config.get_browser_jobs_sqlcl(only=only)
        run_one = _run_one_sqlcl

    if not jobs:
        print("no enabled BROWSER-track jobs" + (f" named {only}" if only else ""))
        return

    failures = _drive(jobs, run_one)
    print(f"\ndone [{mode}] — {len(jobs)} job(s), {failures} failure(s)")
    sys.exit(1 if failures else 0)


if __name__ == "__main__":
    main(sys.argv)
