"""otbi-atd Track B : orchestrator (SQLcl mode - no python-oracledb credentials).

For each enabled BROWSER-track job in the control tables:
  1) ensure an OTBI session (reuse saved, else interactive MFA login),
  2) download the analysis CSV via the Go-URL,
  3) load into the target table via SQLcl (TRUNCATE + INSERT),
  4) write an ATD_LOAD_RUN_LOG row (SUCCESS/FAILED).

All database access goes through the already-configured SQLcl connection
(`sql -name prod_mcp`), so no separate DB username/password is needed.

Usage:
  python runner.py            # run all enabled BROWSER jobs
  python runner.py JOB_NAME   # run one job

Env: OTBI_USER, OTBI_PWD (Fusion login), ATD_STATE_DIR (saved sessions),
optional ATD_SQLCL / ATD_SQLCL_CONN (default the local sql.exe / prod_mcp).
"""
import json
import sys

from playwright.sync_api import sync_playwright

import config
import auth
import extract
import loadsql


def run_one(ctx, env, job):
    name = job["job_name"]
    try:
        params = json.loads(job["params_json"]) if job.get("params_json") else None
        csv_text = extract.download_csv(ctx, env, job["source_ref"], params)
        n = loadsql.load(job, csv_text)
        print(f"[ok] {name}: {n} rows -> {job['stage_table']}")
        return True
    except Exception as e:  # noqa: BLE001 - record every failure in the run log
        loadsql.log_failure(name, str(e))
        print(f"[FAIL] {name}: {e}")
        return False


def main(argv):
    only = argv[1] if len(argv) > 1 else None
    jobs = config.get_browser_jobs_sqlcl(only=only)
    if not jobs:
        print("no enabled BROWSER-track jobs" + (f" named {only}" if only else ""))
        return

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
                    if not run_one(ctx, env, job):
                        failures += 1
            finally:
                browser.close()
    print(f"\ndone — {len(jobs)} job(s), {failures} failure(s)")
    sys.exit(1 if failures else 0)


if __name__ == "__main__":
    main(sys.argv)
