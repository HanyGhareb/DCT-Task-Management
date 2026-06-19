"""otbi-atd Track B : orchestrator.

For each enabled BROWSER-track job in the control tables:
  1) ensure an OTBI session (reuse saved, else MFA login - number to Telegram),
  2) download the analysis CSV via the Go-URL,
  3) on a not-yet-prepared job (no column map), derive its staging table + column
     map from that CSV and persist them (see prepare.py) - so a job needs only its
     analysis path to be created; everything else is prepared on first run,
  4) load into the target table,
  5) write an ATD_LOAD_RUN_LOG row (SUCCESS/FAILED), warning on likely truncation.

Two DB modes (ATD_DB_MODE):
  sqlcl    (default) - all DB work via the configured SQLcl connection
                       (sql -name prod_mcp); NO separate DB credentials.
  oracledb (fast)    - python-oracledb chunked array-bind load (~10x faster on
                       big tables); needs ATD_DB_USER/ATD_DB_PASSWORD/ATD_DB_DSN
                       + TNS_ADMIN wallet. Best for large analyses / the OCI VM.

Usage:
  python runner.py            # all enabled BROWSER jobs (single host, direct)
  python runner.py JOB_NAME   # one job

Multi-host shared queue (oracledb mode only — design #3):
  python runner.py --enqueue [JOB]      # mark enabled jobs READY (run once per cycle)
  python runner.py --worker [--forever] # claim+run jobs from the queue until empty
  python runner.py --enqueue --worker   # single-host convenience: queue then drain
Each host calls --worker; ATD_QUEUE_PKG.claim_next (FOR UPDATE SKIP LOCKED) hands each
job to exactly one host. Host id = ATD_WORKER_ID or the machine hostname.

Build new analyses (oracledb mode only — "Add New OTBI Analysis" from the Jobs page):
  python runner.py --build   # drain QUEUED prod.atd_analysis_request rows: build each
                             # in OTBI (create_analysis), register it as a job, load once
  python runner.py --discover# drain QUEUED prod.atd_sa_catalog rows: scrape each subject
                             # area's folders+columns -> cache for the UI column picker
"""
import hashlib
import json
import os
import socket
import sys
import time

from playwright.sync_api import sync_playwright

import config
import auth
import extract
import checks
import notify
import prepare


def _warn_truncation(name, n):
    note = checks.truncation_note(n)
    if note:
        print(f"[WARN] {name}: {note}")
        notify.send(notify.render("ATD_JOB_MSG", "otbi-atd {job}: {note}", job=name, note=note))
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
    drift = []
    try:
        params = json.loads(job["params_json"]) if job.get("params_json") else None
        csv_text = extract.download_csv(ctx, env, job["source_ref"], params)
        # first run: derive table + column map; later runs: auto-adapt to schema drift
        drift = prepare.ensure_prepared_sqlcl(job, csv_text)
        if drift:
            notify.send(notify.render("ATD_DRIFT_MSG", "otbi-atd {job} schema drift: {drift}",
                                      job=name, drift="; ".join(drift)))
        n = loadsql.load(job, csv_text, extra_msg="; ".join(drift) if drift else None)
        _warn_truncation(name, n)
        print(f"[ok] {name}: {n} rows -> {job['stage_table']}")
        return True
    except Exception as e:  # noqa: BLE001
        # prepend drift so the job log explains *why* a drifted load failed
        loadsql.log_failure(name, "; ".join(drift + [str(e)]) if drift else str(e))
        print(f"[FAIL] {name}: {e}")
        return False


# ---- oracledb mode (fast, chunked array-bind) ---------------------------
def _log_start(conn, name, track="BROWSER"):
    cur = conn.cursor()
    rid = cur.var(int)
    cur.execute("insert into prod.atd_load_run_log(job_name, track, status) "
                "values (:n,:t,'RUNNING') returning run_id into :r",
                n=name[:80], t=track, r=rid)
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
        drift = []
        try:
            params = json.loads(job["params_json"]) if job.get("params_json") else None
            csv_text = extract.download_csv(ctx, env, job["source_ref"], params)
            # first run: derive table + map; later runs: auto-adapt to schema drift
            drift = prepare.ensure_prepared_oracledb(conn, job, csv_text)
            if drift:
                notify.send(notify.render("ATD_DRIFT_MSG", "otbi-atd {job} schema drift: {drift}",
                                          job=name, drift="; ".join(drift)))
            ck = hashlib.sha256(csv_text.encode("utf-8", "replace")).hexdigest()
            n = load.load(conn, csv_text, job["stage_table"], job["final_table"],
                          job["load_mode"], job["key_columns"], job["column_map_json"])
            note = _warn_truncation(name, n)
            _log_end(conn, run_id, "SUCCESS", n=n, ck=ck,
                     msg="; ".join(drift + ([note] if note else [])) or None)
            print(f"[ok] {name}: {n} rows -> {job['stage_table']}")
            return True
        except Exception as e:  # noqa: BLE001
            # discard the failed (uncommitted) delete+insert so the table keeps its
            # prior load — otherwise _log_end's commit would persist the empty/partial
            # state. prepare's ALTERs already auto-committed (DDL) and are kept.
            try:
                conn.rollback()
            except Exception:  # noqa: BLE001
                pass
            # prepend drift so the job log explains *why* a drifted load failed
            _log_end(conn, run_id, "FAILED", msg="; ".join(drift + [str(e)])[:3900])
            print(f"[FAIL] {name}: {e}")
            return False
    return run_one


# ---- multi-host shared queue (oracledb mode, design #3) -----------------
def _worker_id():
    return os.environ.get("ATD_WORKER_ID") or socket.gethostname()


def _enqueue(conn, only):
    n = conn.cursor().callfunc("prod.atd_queue_pkg.enqueue", int, [only])
    print(f"[enqueue] marked {n} job(s) READY" + (f" ({only})" if only else ""))


def _run_worker(conn, load, forever):
    """Claim+run jobs from the shared queue until it's empty (or forever)."""
    host = _worker_id()
    lease = int(os.environ.get("ATD_LEASE_MINUTES", "30"))
    idle = int(os.environ.get("ATD_WORKER_IDLE", "15"))
    run_one = _make_run_one_oracledb(conn, load)
    processed, failures = 0, 0
    ctx_by_env = {}
    browsers = []
    # crash recovery: return any jobs left CLAIMED by a dead worker past the lease
    reaped = conn.cursor().callfunc("prod.atd_queue_pkg.reap_stale", int, [lease])
    print(f"[worker {host}] starting (lease={lease}m, forever={forever}"
          + (f", reaped {reaped} stale" if reaped else "") + ")")
    with sync_playwright() as p:
        try:
            while True:
                name = conn.cursor().callfunc(
                    "prod.atd_queue_pkg.claim_next", str, [host])
                if not name:
                    if forever:
                        time.sleep(idle)
                        continue
                    break
                jobs = config.get_browser_jobs(conn, only=name)
                if not jobs:
                    print(f"[worker {host}] claimed {name} but no job row -> FAILED")
                    conn.cursor().callproc("prod.atd_queue_pkg.mark_failed", [name])
                    failures += 1
                    continue
                job = jobs[0]
                env_name = job["env_name"]
                if env_name not in ctx_by_env:
                    env = {"env_name": env_name,
                           "analytics_base_url": job["analytics_base_url"],
                           "credential_ref": job.get("credential_ref") or env_name}
                    browser, ctx = auth.authenticate(p, env)
                    browsers.append(browser)
                    ctx_by_env[env_name] = (env, ctx)
                env, ctx = ctx_by_env[env_name]
                ok = run_one(ctx, env, job)
                conn.cursor().callproc(
                    "prod.atd_queue_pkg." + ("mark_done" if ok else "mark_failed"), [name])
                processed += 1
                failures += 0 if ok else 1
        finally:
            for b in browsers:
                b.close()
    print(f"\n[worker {host}] done — processed {processed} job(s), {failures} failure(s)")
    return failures


# ---- analysis build queue (design: "Add New OTBI Analysis" from the Jobs page) -
def _set_req(conn, req_id, status, job_name=None, message=None):
    conn.cursor().execute(
        "update prod.atd_analysis_request set status=:s, job_name=NVL(:j,job_name), "
        "message=:m, finished=CASE WHEN :s2 IN ('DONE','FAILED') THEN systimestamp "
        "ELSE finished END where req_id=:id",
        s=status, j=job_name, m=message, s2=status, id=req_id)
    conn.commit()


def _register_built_job(conn, spec, analysis_path):
    """Insert/refresh the ATD job for a freshly-built analysis (column map stays
    NULL -> the runner prepares it on first load). Returns the job name."""
    job = prepare.derive_job(analysis_path)
    stage = "PROD." + prepare.derive_table(analysis_path)
    cur = conn.cursor()
    cur.execute("SELECT env_name FROM (SELECT env_name FROM prod.atd_otbi_env "
                "WHERE enabled='Y' AND extract_track='BROWSER' ORDER BY env_name) WHERE ROWNUM=1")
    r = cur.fetchone(); env_name = r[0] if r else None
    cur.execute("SELECT target_name FROM (SELECT target_name FROM prod.atd_target_db "
                "WHERE enabled='Y' ORDER BY target_name) WHERE ROWNUM=1")
    r = cur.fetchone(); tgt = r[0] if r else None
    cur.execute("""MERGE INTO prod.atd_otbi_jobs t USING (SELECT :j job_name FROM dual) s
      ON (t.job_name = s.job_name)
      WHEN MATCHED THEN UPDATE SET source_ref=:src, stage_table=:stg, load_mode=:lm,
        key_columns=:k, params_json=:pj, enabled='Y'
      WHEN NOT MATCHED THEN INSERT (job_name, env_name, target_name, source_ref, output_format,
        stage_table, load_mode, key_columns, params_json, enabled, priority, run_order, run_status)
        VALUES (:j,:env,:tgt,:src,'csv',:stg,:lm,:k,:pj,'Y',5,100,'READY')""",
      j=job, src=analysis_path, stg=stage, lm=spec.get("load_mode", "TRUNCATE_INSERT"),
      k=spec.get("key"), pj=json.dumps(spec["params"]) if spec.get("params") else None,
      env=env_name, tgt=tgt)
    conn.commit()
    return job


def _run_job_now(job, run_one):
    env = {"env_name": job["env_name"], "analytics_base_url": job["analytics_base_url"],
           "credential_ref": job.get("credential_ref") or job["env_name"]}
    with sync_playwright() as p:
        browser, ctx = auth.authenticate(p, env)
        try:
            return run_one(ctx, env, job)
        finally:
            browser.close()


def _build_requests(conn, load):
    """Drain QUEUED analysis-build requests: build each in OTBI (create_analysis),
    register it as a job, then load it once. Marks each DONE / FAILED."""
    import create_analysis
    cur = conn.cursor()
    cur.execute("SELECT req_id, spec_json FROM prod.atd_analysis_request "
                "WHERE status='QUEUED' ORDER BY req_id")
    reqs = [(r[0], r[1].read() if hasattr(r[1], "read") else r[1]) for r in cur.fetchall()]
    if not reqs:
        print("[build] no queued analysis requests")
        return 0
    run_one = _make_run_one_oracledb(conn, load)
    failures = 0
    for req_id, spec_text in reqs:
        print(f"[build] request {req_id}: building analysis...")
        _set_req(conn, req_id, "BUILDING")
        try:
            spec = json.loads(spec_text)
            path = create_analysis.build_analysis(spec)        # OTBI UI build + save + verify
            job = _register_built_job(conn, spec, path)        # register as an ATD job
            jobs = config.get_browser_jobs(conn, only=job)
            loaded = _run_job_now(jobs[0], run_one) if jobs else False
            _set_req(conn, req_id, "DONE", job_name=job,
                     message="built + loaded" if loaded else "built; load pending")
            print(f"[build] request {req_id}: DONE -> job {job}")
        except Exception as e:  # noqa: BLE001
            _set_req(conn, req_id, "FAILED", message=str(e)[:3900])
            print(f"[build] request {req_id}: FAILED: {e}")
            failures += 1
    return failures


# ---- subject-area discovery queue (column picker for "Add New OTBI Analysis") -
def _set_sa(conn, sa, status, message=None):
    conn.cursor().execute(
        "update prod.atd_sa_catalog set status=:s, message=:m where subject_area=:sa",
        s=status, m=message, sa=sa)
    conn.commit()


def _save_catalog(conn, sa, catalog_json, folders, columns):
    import oracledb
    cur = conn.cursor()
    cur.setinputsizes(c=oracledb.DB_TYPE_CLOB)
    cur.execute(
        "update prod.atd_sa_catalog set catalog_json=:c, folder_count=:fc, "
        "column_count=:cc, status='READY', message=NULL, scraped_at=systimestamp "
        "where subject_area=:sa",
        c=catalog_json, fc=folders, cc=columns, sa=sa)
    conn.commit()


def _reap_stale_discovery(conn, minutes):
    """Recover discovery rows stranded in SCRAPING by a crashed/killed scrape.

    --discover only picks up QUEUED rows, so a row left in SCRAPING (process died
    mid-scrape, or finished the catalog but lost the READY status flip) would never
    retry. A row is stale when NO DISCOVER run-log row for it has been RUNNING within
    the last `minutes` — i.e. no scrape is actually working on it. Reset those to
    QUEUED and close their dangling RUNNING run-log rows as FAILED so the Discovery
    page stops showing an eternal RUNNING. Runs at the top of each --discover cycle;
    a genuinely-live scrape keeps a fresh RUNNING log row and is never reaped."""
    cur = conn.cursor()
    cur.execute(
        "UPDATE /*+ no_parallel */ prod.atd_load_run_log SET status='FAILED', "
        "  finished=systimestamp, message='reaped: scrape did not finish (stale)' "
        "WHERE track='DISCOVER' AND status='RUNNING' "
        "  AND started < CAST(systimestamp AS TIMESTAMP) - NUMTODSINTERVAL(:m,'MINUTE')",
        m=minutes)
    cur.execute(
        "UPDATE /*+ no_parallel */ prod.atd_sa_catalog c SET c.status='QUEUED', "
        "  c.message='re-queued: previous scrape did not finish' "
        "WHERE c.status='SCRAPING' "
        "  AND NOT EXISTS (SELECT /*+ no_parallel */ 1 FROM prod.atd_load_run_log l "
        "    WHERE l.track='DISCOVER' AND l.status='RUNNING' "
        "      AND l.job_name = c.subject_area "
        "      AND l.started >= CAST(systimestamp AS TIMESTAMP) - NUMTODSINTERVAL(:m,'MINUTE'))",
        m=minutes)
    n = cur.rowcount
    conn.commit()
    if n:
        print(f"[discover] reaped {n} stale SCRAPING row(s) -> QUEUED")
    return n


def _discover_requests(conn):
    """Drain ONE QUEUED subject-area discovery request (the oldest): scrape its full
    folder/column tree in OTBI (create_analysis.discover_subject_area) and cache it for
    the UI column picker; mark it READY / FAILED. One-per-invocation by design — the
    dedicated 1-minute 'OTBI-ATD Discover' task (run_atd_discover.ps1, MultipleInstances=
    IgnoreNew) calls this each cycle, so a multi-minute scrape never overlaps the next
    tick, and each subject area gets the full ExecutionTimeLimit to itself. Returns the
    number still queued AFTER this one (so the caller/log shows remaining backlog)."""
    import create_analysis
    # first recover anything stranded in SCRAPING by a dead scrape (lease = ATD_LEASE_MINUTES)
    _reap_stale_discovery(conn, int(os.environ.get("ATD_LEASE_MINUTES", "30")))
    cur = conn.cursor()
    cur.execute("SELECT subject_area FROM prod.atd_sa_catalog "
                "WHERE status='QUEUED' ORDER BY requested_at FETCH FIRST 1 ROW ONLY")
    row = cur.fetchone()
    if not row:
        print("[discover] no queued subject-area discovery requests")
        return 0
    sa = row[0]
    print(f"[discover] {sa}: scraping...")
    _set_sa(conn, sa, "SCRAPING")
    run_id = _log_start(conn, sa, track="DISCOVER")       # history for the Discovery page
    try:
        tree = create_analysis.discover_subject_area(sa)
        # full-depth tree: counts come from the nested walk (create_analysis._count_tree)
        cc = tree.get("column_count", 0)
        fc = tree.get("folder_count", len(tree["folders"]))
        _save_catalog(conn, sa, json.dumps(tree, ensure_ascii=False), fc, cc)
        _log_end(conn, run_id, "SUCCESS", n=cc, msg=f"{fc} folders, {cc} columns")
        print(f"[discover] {sa}: READY ({fc} folders, {cc} columns)")
    except Exception as e:  # noqa: BLE001
        _set_sa(conn, sa, "FAILED", message=str(e)[:3900])
        _log_end(conn, run_id, "FAILED", msg=str(e)[:3900])
        print(f"[discover] {sa}: FAILED: {e}")
    cur.execute("SELECT COUNT(*) FROM prod.atd_sa_catalog WHERE status='QUEUED'")
    remaining = cur.fetchone()[0]
    print(f"[discover] {remaining} subject area(s) still queued")
    return 0


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
    args = argv[1:]
    enqueue = "--enqueue" in args
    worker = "--worker" in args
    forever = "--forever" in args
    build = "--build" in args
    discover = "--discover" in args
    only = next((a for a in args if not a.startswith("-")), None)
    mode = _resolve_mode()

    # queue commands require oracledb (the function lives in the DB; the loop
    # claims via a live oracledb connection)
    if enqueue or worker or build or discover:
        if mode != "oracledb":
            print("[queue] --enqueue/--worker/--build/--discover require oracledb mode "
                  "(set ATD_DB_USER/PASSWORD + ATD_WALLET_PASSWORD)")
            sys.exit(2)
        import load
        conn = config.connect()
        config.apply_runner_config(conn)
        if discover:                    # drain subject-area column-picker scrapes
            sys.exit(1 if _discover_requests(conn) else 0)
        if build:                       # drain "Add New OTBI Analysis" requests
            sys.exit(1 if _build_requests(conn, load) else 0)
        if enqueue:
            _enqueue(conn, only)
        failures = _run_worker(conn, load, forever) if worker else 0
        sys.exit(1 if failures else 0)

    # ---- direct single-host run (unchanged) ----
    if mode == "oracledb":
        import load
        conn = config.connect()
        config.apply_runner_config(conn)
        jobs = config.get_browser_jobs(conn, only=only)
        run_one = _make_run_one_oracledb(conn, load)
    else:
        config.apply_runner_config()
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
