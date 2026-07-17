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

Fusion write-back actions (the INVERSE of extract — oracledb mode only):
  python runner.py --actions [--forever]
                             # drain prod.atd_action_request: perform each action INSIDE
                             # Fusion (first type AP_INVOICE) via the shared SSO session.
                             # Idempotent (handler pre-checks Fusion); writes are gated by
                             # ATD_ACTION_LIVE=1 (else dry-run: probe + validate, no save).
"""
import glob
import hashlib
import json
import os
import socket
import sys
import time
from datetime import datetime

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
                   "xmlpserver_base_url": j0.get("xmlpserver_base_url"),
                   "credential_ref": j0.get("credential_ref") or env_name}
            browser, ctx = auth.authenticate(p, env)
            try:
                for job in env_jobs:
                    try:
                        ok = run_one_fn(ctx, env, job)
                    except extract.SessionExpired as e:
                        # direct (non-worker) run: no retry loop here — just fail the
                        # job cleanly instead of crashing the whole batch.
                        print(f"[FAIL] {job['job_name']}: {e}")
                        ok = False
                    if not ok:
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
        csv_text = extract.download_job(ctx, env, job, params)
        # first run: derive table + column map; later runs: auto-adapt to schema drift
        drift = prepare.ensure_prepared_sqlcl(job, csv_text)
        if drift and not prepare.is_no_data_drift(drift):   # never Telegram a no-data run
            notify.send(notify.render("ATD_DRIFT_MSG", "otbi-atd {job} schema drift: {drift}",
                                      job=name, drift="; ".join(drift)))
        if str(job.get("schema_reviewed") or "Y").upper() == "N":
            loadsql.log_held(name, "; ".join(drift + ["prepared - awaiting schema review (not loaded)"])
                             if drift else "prepared - awaiting schema review (not loaded)")
            print(f"[held] {name}: prepared, awaiting schema review (not loaded)")
            return True
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
    cur.execute("insert into prod.atd_load_run_log(job_name, track, status, host_id) "
                "values (:n,:t,'RUNNING',:h) returning run_id into :r",
                n=name[:80], t=track, h=_worker_id()[:120], r=rid)
    conn.commit()
    return rid.getvalue()[0]


def _log_end(conn, run_id, status, n=None, ck=None, msg=None):
    conn.cursor().execute(
        "update prod.atd_load_run_log set finished=systimestamp, status=:s, "
        "row_count=:rc, csv_checksum=:ck, message=:m where run_id=:id",
        s=status, rc=n, ck=ck, m=checks.scrub(msg), id=run_id)
    conn.commit()


def _make_run_one_oracledb(conn, load):
    def run_one(ctx, env, job):
        name = job["job_name"]
        run_id = _log_start(conn, name)
        drift = []
        try:
            params = json.loads(job["params_json"]) if job.get("params_json") else None
            csv_text = extract.download_job(ctx, env, job, params)
            # first run: derive table + map; later runs: auto-adapt to schema drift
            drift = prepare.ensure_prepared_oracledb(conn, job, csv_text)
            if drift and not prepare.is_no_data_drift(drift):   # never Telegram a no-data run
                notify.send(notify.render("ATD_DRIFT_MSG", "otbi-atd {job} schema drift: {drift}",
                                          job=name, drift="; ".join(drift)))
            # Schema-review gate: the table + column map are now prepared (so the
            # end user can review the structure in the Schema panel), but HOLD before
            # loading any data until they approve it. Re-armed each run while held.
            if str(job.get("schema_reviewed") or "Y").upper() == "N":
                _log_end(conn, run_id, "HELD", n=0,
                         msg="; ".join(drift + ["prepared - awaiting schema review (not loaded)"]))
                print(f"[held] {name}: prepared, awaiting schema review (not loaded)")
                return True
            ck = hashlib.sha256(csv_text.encode("utf-8", "replace")).hexdigest()
            n = load.load(conn, csv_text, job["stage_table"], job["final_table"],
                          job["load_mode"], job["key_columns"], job["column_map_json"])
            note = _warn_truncation(name, n)
            _log_end(conn, run_id, "SUCCESS", n=n, ck=ck,
                     msg="; ".join(drift + ([note] if note else [])) or None)
            print(f"[ok] {name}: {n} rows -> {job['stage_table']}")
            return True
        except extract.SessionExpired:
            # The warm session died mid-run. Log THIS attempt as REQUEUED (neutral,
            # retryable — NOT a FAILED, so it doesn't trip the chronic-failure alert),
            # then re-raise so the worker re-auths (one MFA) and/or hands the job to a
            # healthy peer. Roll back the uncommitted load first (general-case reason).
            try:
                conn.rollback()
            except Exception:  # noqa: BLE001
                pass
            _log_end(conn, run_id, "REQUEUED",
                     msg="; ".join(drift + ["session expired mid-run; requeued for retry"])[:3900])
            print(f"[requeue] {name}: session expired mid-run; requeued for retry")
            raise
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


def _env_of(job, env_name):
    """The env dict auth.authenticate expects, built from a claimed job row."""
    return {"env_name": env_name,
            "analytics_base_url": job["analytics_base_url"],
            "xmlpserver_base_url": job.get("xmlpserver_base_url"),
            "credential_ref": job.get("credential_ref") or env_name}


def _session_files():
    d = os.environ.get("ATD_STATE_DIR", ".")
    return glob.glob(os.path.join(d, "auth_state_*.json"))


def _session_mtime():
    """Newest auth_state file mtime (epoch) = when the current Fusion session began;
    None if no saved session."""
    files = _session_files()
    if not files:
        return None
    try:
        return max(os.path.getmtime(f) for f in files)
    except OSError:
        return None


def _session_started_dt():
    """UTC datetime the session began (for ATD_WORKER_HEARTBEAT.session_started)."""
    m = _session_mtime()
    return datetime.utcfromtimestamp(m) if m else None


def _session_age_hours():
    """Age of the current session in hours (same-clock, skew-free); None if no session."""
    m = _session_mtime()
    return None if m is None else (time.time() - m) / 3600.0


def _in_break(conn):
    """Whether NOW is inside the configured Break window (DB is the single source)."""
    try:
        return conn.cursor().callfunc("prod.atd_in_break", str, []) == 'Y'
    except Exception:  # noqa: BLE001 - if the function is absent, never block work
        return False


def _heartbeat(conn, status, job=None):
    """Upsert this worker's liveness row (ATD_WORKER_HEARTBEAT) for the UI Workers
    panel. Best-effort: a heartbeat failure must never break the worker."""
    try:
        conn.cursor().execute(
            "merge into prod.atd_worker_heartbeat t "
            "using (select :w worker_id from dual) s on (t.worker_id = s.worker_id) "
            "when matched then update set last_seen=systimestamp, status=:st, "
            "  current_job=:j, session_started=:ss "
            "when not matched then insert (worker_id, last_seen, status, current_job, session_started) "
            "values (:w, systimestamp, :st, :j, :ss)",
            w=_worker_id()[:120], st=status, j=(job[:256] if job else None),
            ss=_session_started_dt())
        conn.commit()
    except Exception:  # noqa: BLE001
        pass


def _handle_refresh(conn, p, host, ctx_by_env, browser_by_env, browsers):
    """Operator-triggered re-login: if atd_worker_heartbeat.refresh_req is set for THIS
    worker (by the UI 'Refresh' button or the Telegram 'refresh <vm>' command), clear it
    and FORCE a fresh Fusion login (one MFA push) — dropping any cached session first.
    Best-effort: never break the idle loop."""
    try:
        cur = conn.cursor()
        cur.execute("select refresh_req from prod.atd_worker_heartbeat where worker_id=:w", w=host)
        row = cur.fetchone()
        if not row or row[0] is None:
            return
        cur.execute("update prod.atd_worker_heartbeat set refresh_req=NULL where worker_id=:w", w=host)
        conn.commit()
    except Exception as e:  # noqa: BLE001
        print(f"[worker {host}] refresh check error: {e}", flush=True)
        return
    print(f"[worker {host}] operator refresh requested -> forcing a fresh login", flush=True)
    denv = config.get_default_browser_env(conn)
    if not denv:
        print(f"[worker {host}] refresh: no enabled BROWSER env to log into", flush=True)
        return
    en = denv["env_name"]
    dead = browser_by_env.pop(en, None)
    ctx_by_env.pop(en, None)
    if dead:
        try:
            dead.close()
        except Exception:  # noqa: BLE001
            pass
    envd = {"env_name": en, "analytics_base_url": denv["analytics_base_url"],
            "credential_ref": denv.get("credential_ref") or en}
    try:
        browser, ctx = auth.authenticate(p, envd, force=True)   # force a clean login (MFA)
        browsers.append(browser)
        browser_by_env[en] = browser
        ctx_by_env[en] = (envd, ctx)
        print(f"[worker {host}] refresh: fresh login OK", flush=True)
    except Exception as e:  # noqa: BLE001 (e.g. MFA not approved)
        print(f"[worker {host}] refresh: login failed: {e}", flush=True)


def _alert_stale_workers(conn, stale_minutes=5):
    """Telegram-notify once when a peer's heartbeat goes stale, then flag it DOWN so
    we don't spam (it re-arms when that worker next heartbeats). Best-effort."""
    try:
        cur = conn.cursor()
        # compare both sides as plain TIMESTAMP (session TZ) - mixing a TIMESTAMP column
        # with SYSTIMESTAMP-WITH-TZ skews by the TZ offset and falsely flags live
        # workers (same fix as ATD_QUEUE_PKG.reap_stale).
        cur.execute("select worker_id from prod.atd_worker_heartbeat "
                    "where status <> 'DOWN' "
                    "  and last_seen < CAST(SYSTIMESTAMP AS TIMESTAMP) "
                    "                  - numtodsinterval(:m,'MINUTE')",
                    m=stale_minutes)
        stale = [r[0] for r in cur.fetchall()]
        for w in stale:
            notify.send(f"otbi-atd: worker {w} is silent (no heartbeat > {stale_minutes}m)")
            cur.execute("update prod.atd_worker_heartbeat set status='DOWN' where worker_id=:w", w=w)
            conn.commit()
    except Exception:  # noqa: BLE001
        pass


def _reap_stale_runs(conn, minutes):
    """Close orphaned BROWSER run-log rows left RUNNING by a crashed/restarted worker
    (the load equivalent of _reap_stale_discovery). Best-effort; returns count."""
    try:
        cur = conn.cursor()
        cur.execute(
            "update prod.atd_load_run_log set status='FAILED', finished=systimestamp, "
            "  message='reaped: run did not finish (stale)' "
            "where track='BROWSER' and status='RUNNING' "
            "  and started < CAST(systimestamp AS TIMESTAMP) - NUMTODSINTERVAL(:m,'MINUTE')",
            m=minutes)
        n = cur.rowcount
        conn.commit()
        if n:
            print(f"[reap] closed {n} stale RUNNING run-log row(s)", flush=True)
        return n
    except Exception as e:  # noqa: BLE001
        print(f"[reap] stale-run reap error: {e}", flush=True)
        return 0


# aging-nudge de-dupe: host -> session mtime already warned for (re-arms on new session)
_AGING_WARNED = {}


def _alert_aging_session(conn, host, vm, in_break):
    """Pre-expiry nudge: when this worker's Fusion session is older than
    ATD_SESSION_WARN_HOURS, Telegram-warn once (per session) to refresh before it dies.
    Suppressed during the Break window. Best-effort."""
    try:
        warn_h = float(os.environ.get("ATD_SESSION_WARN_HOURS", "7") or 0)
        if warn_h <= 0 or in_break:
            return
        age = _session_age_hours()
        m = _session_mtime()
        if age is None or age < warn_h:
            return
        if _AGING_WARNED.get(host) == m:        # already warned for THIS session
            return
        _AGING_WARNED[host] = m
        text = notify.render("ATD_AGING_MSG",
                             "{vm} OTBI session is ~{hours}h old and will expire soon - "
                             "send \"refresh {vm}\" to re-login.",
                             vm=vm, hours=int(age))
        notify.send(text)
        print(f"[worker {host}] session aging ~{int(age)}h -> nudged", flush=True)
    except Exception as e:  # noqa: BLE001
        print(f"[worker {host}] aging-alert error: {e}", flush=True)


def _post_mark_health(conn, host, vm, job, ok):
    """Chronic-failure alert: on SUCCESS clear the job's alert flag; on FAILURE, if the
    last ATD_FAIL_ALERT_STREAK runs are all FAILED, atomically claim the alert (so only
    one VM sends) and Telegram-alert with the latest error. Best-effort."""
    try:
        cur = conn.cursor()
        if ok:
            cur.execute("update prod.atd_otbi_jobs set fail_alert_sent='N' "
                        "where job_name=:j and fail_alert_sent='Y'", j=job)
            conn.commit()
            return
        streak = int(os.environ.get("ATD_FAIL_ALERT_STREAK", "4") or 0)
        if streak <= 0:
            return
        cur.execute("select status from prod.atd_load_run_log where job_name=:j "
                    "order by run_id desc fetch first :k rows only", j=job, k=streak)
        statuses = [r[0] for r in cur.fetchall()]
        if len(statuses) < streak or any(s != 'FAILED' for s in statuses):
            return
        # atomic claim: only the VM that flips N->Y sends the alert
        cur.execute("update prod.atd_otbi_jobs set fail_alert_sent='Y' "
                    "where job_name=:j and fail_alert_sent='N'", j=job)
        claimed = cur.rowcount
        conn.commit()
        if claimed != 1:
            return
        cur.execute("select message from prod.atd_load_run_log where job_name=:j "
                    "order by run_id desc fetch first 1 rows only", j=job)
        row = cur.fetchone()
        err = (row[0] if row and row[0] else "")[:300]
        text = notify.render("ATD_FAIL_ALERT_MSG",
                             "otbi-atd ALERT: job {job} has failed {count} times in a row "
                             "on {vm}. Last error: {error}",
                             job=job, count=streak, vm=vm, error=err)
        notify.send(text)
        print(f"[worker {host}] chronic-failure alert sent for {job} ({streak}x)", flush=True)
    except Exception as e:  # noqa: BLE001
        print(f"[worker {host}] health-check error: {e}", flush=True)


def _relogin(p, host, en, envd, ctx_by_env, browser_by_env, browsers):
    """Drop env `en`'s cached browser and FORCE a fresh Fusion login (one MFA push).
    Returns True on success. Shared by the mid-run self-heal and the idle keep-alive."""
    dead = browser_by_env.pop(en, None)
    ctx_by_env.pop(en, None)
    if dead:
        try:
            dead.close()
        except Exception:  # noqa: BLE001
            pass
    try:
        browser, ctx = auth.authenticate(p, envd, force=True)
        browsers.append(browser)
        browser_by_env[en] = browser
        ctx_by_env[en] = (envd, ctx)
        print(f"[worker {host}] re-login OK ({en})", flush=True)
        return True
    except Exception as e:  # noqa: BLE001 (incl. MFA-not-approved / still expired)
        print(f"[worker {host}] re-login failed ({en}): {e}", flush=True)
        return False


def _log_orphan(conn, name, status, msg):
    """Write a run-log row for a job handed back / failed WITHOUT a run actually
    starting (e.g. the Fusion login failed before run_one). Keeps the failover budget
    (_recent_requeues counts REQUEUED) honest and makes the event visible in Run Logs."""
    try:
        conn.cursor().execute(
            "insert into prod.atd_load_run_log(job_name, track, status, finished, row_count, host_id, message) "
            "values (:n,'BROWSER',:s,systimestamp,0,:h,:m)",
            n=name[:80], s=status, h=_worker_id()[:120], m=checks.scrub(msg or "")[:3900])
        conn.commit()
    except Exception:  # noqa: BLE001
        pass


def _recent_requeues(conn, job, minutes=60):
    """How many times this job bounced on a dead session (REQUEUED) in the last
    `minutes` — the cross-worker failover budget guard. Best-effort -> 0 on error."""
    try:
        cur = conn.cursor()
        cur.execute("select count(*) from prod.atd_load_run_log "
                    "where job_name=:j and status='REQUEUED' "
                    "  and started > CAST(SYSTIMESTAMP AS TIMESTAMP) - NUMTODSINTERVAL(:m,'MINUTE')",
                    j=job, m=minutes)
        return cur.fetchone()[0]
    except Exception:  # noqa: BLE001
        return 0


def _enqueue(conn, only):
    n = conn.cursor().callfunc("prod.atd_queue_pkg.enqueue", int, [only])
    print(f"[enqueue] marked {n} job(s) READY" + (f" ({only})" if only else ""))


def _run_worker(conn, load, forever):
    """Claim+run jobs from the shared queue until it's empty (or forever)."""
    host = _worker_id()
    vm = host[4:] if host.startswith("atd-") else host    # short name for messages
    lease = int(os.environ.get("ATD_LEASE_MINUTES", "10"))
    idle = int(os.environ.get("ATD_WORKER_IDLE", "15"))
    run_one = _make_run_one_oracledb(conn, load)
    processed, failures = 0, 0
    ctx_by_env = {}
    browser_by_env = {}
    browsers = []
    reauth_at = {}          # env_name -> monotonic time of last self-heal re-auth attempt
    reauth_cooldown = int(os.environ.get("ATD_REAUTH_COOLDOWN", "1800"))  # 30 min
    # Tier 1 (keep-alive) + Tier 2 (cross-worker failover) session auto-heal.
    keepalive_min = float(os.environ.get("ATD_SESSION_KEEPALIVE_MIN", "3") or 0)
    keepalive_strikes = max(1, int(os.environ.get("ATD_KEEPALIVE_STRIKES", "2") or 2))
    requeue_max   = int(os.environ.get("ATD_REQUEUE_MAX", "6") or 0)
    last_keepalive = 0.0
    session_dead = {}       # env_name -> True while its session is known dead (pause claiming)
    ping_fails = {}         # env_name -> consecutive failed keep-alive pings (2-strike guard)
    # crash recovery: return any jobs left CLAIMED by a dead worker past the lease
    reaped = conn.cursor().callfunc("prod.atd_queue_pkg.reap_stale", int, [lease])
    print(f"[worker {host}] starting (lease={lease}m, forever={forever}"
          + (f", reaped {reaped} stale" if reaped else "") + ")")

    def _action_env_ctx(en, action):
        """(env, ctx) for an idle-path Fusion action — reuses the worker's warm
        session for that env (or logs in once), and overlays fusion_apps_url
        (the extract env dicts don't carry it)."""
        if en not in ctx_by_env:
            envd = {"env_name": en,
                    "analytics_base_url": action["analytics_base_url"],
                    "credential_ref": action.get("credential_ref") or en}
            browser, c = auth.authenticate(p, envd)
            browsers.append(browser)
            browser_by_env[en] = browser
            ctx_by_env[en] = (envd, c)
        envd, c = ctx_by_env[en]
        env = dict(envd)
        env["fusion_apps_url"] = action.get("fusion_apps_url") or env.get("fusion_apps_url")
        return env, c

    with sync_playwright() as p:
        try:
            while True:
                # Break window: pause ALL work (claim nothing; in-flight jobs already
                # claimed will have finished). Resumes automatically at break-end.
                in_break = _in_break(conn)
                # While THIS host's session is dead, stop claiming so a peer with a
                # healthy session drains the queue (we re-auth on the idle path below).
                hold_claim = bool(session_dead)
                name = None if (in_break or hold_claim) else conn.cursor().callfunc(
                    "prod.atd_queue_pkg.claim_next", str, [host])
                if not name:
                    if forever:
                        # idle (or paused for the Break window): keep liveness fresh,
                        # honour operator refresh, recover dead peers' jobs + stale runs,
                        # nudge on an aging session, and — only when NOT in break — reuse
                        # the warm session for discovery + builds.
                        _heartbeat(conn, "BREAK" if in_break else "IDLE")
                        _handle_refresh(conn, p, host, ctx_by_env, browser_by_env, browsers)
                        conn.cursor().callfunc("prod.atd_queue_pkg.reap_stale", int, [lease])
                        _reap_stale_runs(conn, int(os.environ.get("ATD_RUN_REAP_MINUTES", "60")))
                        _alert_stale_workers(conn)
                        _alert_aging_session(conn, host, vm, in_break)
                        # Tier 1: keep warm sessions alive so they don't idle-expire
                        # between sparse jobs (a cheap authenticated GET resets OBIEE's
                        # idle timer — no MFA). If a ping finds the session already dead,
                        # mark it (pauses claiming) and self-heal via a rate-limited
                        # forced re-login (one MFA), so the fix is automatic.
                        if keepalive_min > 0 and not in_break and ctx_by_env:
                            now = time.monotonic()
                            if (now - last_keepalive) >= keepalive_min * 60:
                                last_keepalive = now
                                for en, (envd, c) in list(ctx_by_env.items()):
                                    alive = False
                                    try:
                                        alive = auth._validate(c, envd)
                                    except Exception as e:  # noqa: BLE001
                                        print(f"[worker {host}] keepalive error ({en}): {e}", flush=True)
                                    if alive:
                                        ping_fails[en] = 0
                                        if session_dead.pop(en, None):
                                            print(f"[worker {host}] keepalive: {en} recovered", flush=True)
                                    else:
                                        # 2-strike guard: one failed ping can be a transient blip,
                                        # so only declare the session dead (-> pause claiming + MFA
                                        # re-login) after N consecutive misses.
                                        ping_fails[en] = ping_fails.get(en, 0) + 1
                                        if ping_fails[en] >= keepalive_strikes:
                                            if not session_dead.get(en):
                                                print(f"[worker {host}] keepalive: {en} session dead "
                                                      f"({ping_fails[en]} consecutive misses)", flush=True)
                                            session_dead[en] = True
                                        else:
                                            print(f"[worker {host}] keepalive: {en} ping miss "
                                                  f"{ping_fails[en]}/{keepalive_strikes} (transient?)", flush=True)
                        for en in list(session_dead):
                            now = time.monotonic()
                            if now - reauth_at.get(en, 0.0) < reauth_cooldown:
                                continue
                            reauth_at[en] = now
                            envd = (ctx_by_env.get(en) or (None,))[0]
                            if not envd:
                                d = config.get_default_browser_env(conn)
                                envd = ({"env_name": en, "analytics_base_url": d["analytics_base_url"],
                                         "credential_ref": d.get("credential_ref") or en} if d else None)
                            if envd and _relogin(p, host, en, envd, ctx_by_env, browser_by_env, browsers):
                                session_dead.pop(en, None)
                                ping_fails[en] = 0
                        if not in_break:
                            try:
                                # reuse the worker's warm Playwright (p) — opening a
                                # nested sync_playwright here raises "Sync API inside
                                # the asyncio loop".
                                _discover_requests(conn, pw=p)
                                _build_requests(conn, load, pw=p)
                                # Fusion write-back actions (PPM org ref, AP invoice…):
                                # nothing else on the fleet runs --actions, so drain
                                # the action queue here too (2026-07-13)
                                _drain_actions_idle(conn, host, ctx_by_env, _action_env_ctx)
                            except Exception as e:  # noqa: BLE001
                                print(f"[worker {host}] idle discover/build/actions error: {e}")
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
                    # Opening the session for a claimed job can need a fresh login (one MFA).
                    # If that FAILS (MFA not approved, or the session is dead at its absolute
                    # lifetime) DON'T let the exception escape — that would crash the worker
                    # and leave the job orphaned in CLAIMED until the 30-min reap. Instead
                    # apply the same Tier 2 failover: pause claiming here and hand the job
                    # back to the queue for a peer with a live session (or FAIL past the cap).
                    try:
                        browser, ctx = auth.authenticate(p, _env_of(job, env_name))
                        browsers.append(browser)
                        browser_by_env[env_name] = browser
                        ctx_by_env[env_name] = (_env_of(job, env_name), ctx)
                    except Exception as e:  # noqa: BLE001 (MFA timeout / still expired)
                        session_dead[env_name] = True
                        reauth_at[env_name] = time.monotonic()
                        if requeue_max > 0 and _recent_requeues(conn, name) < requeue_max:
                            _log_orphan(conn, name, "REQUEUED",
                                        f"login failed before run; requeued for a healthy worker: {e}")
                            conn.cursor().callproc("prod.atd_queue_pkg.release_job", [name])
                            print(f"[worker {host}] {name}: login failed -> released back to the "
                                  f"queue ({e})", flush=True)
                        else:
                            _log_orphan(conn, name, "FAILED",
                                        f"login failed before run; requeue budget exhausted: {e}")
                            conn.cursor().callproc("prod.atd_queue_pkg.mark_failed", [name])
                            _post_mark_health(conn, host, vm, name, False)
                            print(f"[worker {host}] {name}: login failed; requeue budget "
                                  f"exhausted -> FAILED ({e})", flush=True)
                        failures += 1
                        continue
                env, ctx = ctx_by_env[env_name]
                _heartbeat(conn, "BUSY", name)
                session_bounce = False
                try:
                    ok = run_one(ctx, env, job)
                except extract.SessionExpired as se:
                    # The cached warm session died mid-run. Try a rate-limited forced
                    # re-login (one MFA) + a single retry on THIS host; if that doesn't
                    # land, fall through to hand the job back to the queue (Tier 2) so a
                    # peer with a healthy session retries it (cooldown stops an un-approved
                    # expiry from re-prompting MFA every cycle).
                    ok = False
                    session_bounce = True
                    now = time.monotonic()
                    if now - reauth_at.get(env_name, 0.0) < reauth_cooldown:
                        wait = int(reauth_cooldown - (now - reauth_at.get(env_name, 0.0)))
                        print(f"[worker {host}] {name}: {se} -> re-auth on cooldown "
                              f"({wait}s left); handing back to the queue")
                    else:
                        reauth_at[env_name] = now
                        print(f"[worker {host}] {name}: {se} -> re-authenticating (forced)")
                        if _relogin(p, host, env_name, _env_of(job, env_name),
                                    ctx_by_env, browser_by_env, browsers):
                            env, ctx = ctx_by_env[env_name]
                            try:
                                ok = run_one(ctx, env, job)        # retry once, fresh session
                                session_bounce = not ok
                            except extract.SessionExpired:
                                ok = False
                            except Exception as e:  # noqa: BLE001
                                print(f"[worker {host}] {name}: retry failed: {e}")
                                ok = False
                if ok:
                    session_dead.pop(env_name, None)
                    ping_fails[env_name] = 0
                    conn.cursor().callproc("prod.atd_queue_pkg.mark_done", [name])
                    _post_mark_health(conn, host, vm, name, True)   # clears the job's fail flag
                elif session_bounce and requeue_max > 0 and _recent_requeues(conn, name) < requeue_max:
                    # cross-worker failover: pause claiming here, release the job READY.
                    session_dead[env_name] = True
                    conn.cursor().callproc("prod.atd_queue_pkg.release_job", [name])
                    print(f"[worker {host}] {name}: released back to the queue "
                          f"(session dead) -> a healthy worker will retry", flush=True)
                else:
                    if session_bounce:
                        session_dead[env_name] = True
                        print(f"[worker {host}] {name}: requeue budget exhausted -> FAILED", flush=True)
                    conn.cursor().callproc("prod.atd_queue_pkg.mark_failed", [name])
                    _post_mark_health(conn, host, vm, name, False)  # chronic-failure alert
                processed += 1
                failures += 0 if ok else 1
        finally:
            for b in browsers:
                b.close()
    print(f"\n[worker {host}] done — processed {processed} job(s), {failures} failure(s)")
    return failures


# ---- Fusion write-back action queue (the inverse of the extract jobs) ---------
def _action_result_callback(conn, action, fusion_id, ref):
    """Hand the Fusion result back to the source module so it can mark its own row
    (e.g. PC reimbursement -> POSTED with the invoice id). New source modules add a
    branch here. The worker commits after this returns."""
    mod = (action.get("source_module") or "").upper()
    sid = action.get("source_id")
    if sid is None:
        return
    if mod == "PC":
        conn.cursor().callproc("prod.dct_pc_fusion_pkg.receive_fusion_result",
                               [action.get("source_type"), int(sid), fusion_id, ref])


def _drain_actions_idle(conn, host, ctx_by_env, get_env_ctx):
    """Idle-path drain of ATD_ACTION_REQUEST reusing the LOAD worker's warm
    session (2026-07-13: the fleet's atd-worker runs --worker --forever, and
    nothing ran --actions — enqueued UI actions sat READY forever). Mirrors
    _run_action_worker's claim loop for one pass until the queue is empty.
    get_env_ctx(env_name, action) must return (env_dict, browser_ctx) with
    fusion_apps_url populated (the extract env dicts lack it)."""
    import actions
    live = os.environ.get("ATD_ACTION_LIVE", "0") == "1"
    lease = int(os.environ.get("ATD_ACTION_LEASE_MINUTES",
                               os.environ.get("ATD_LEASE_MINUTES", "30")))
    conn.cursor().callfunc("prod.atd_action_pkg.reap_stale_actions", int, [lease])
    while True:
        aid = conn.cursor().callfunc("prod.atd_action_pkg.claim_next_action", int, [host])
        if not aid:
            return
        action = config.get_action(conn, aid)
        if not action:
            conn.cursor().callproc("prod.atd_action_pkg.mark_action_failed",
                                   [aid, "no action row after claim"])
            continue
        env_name = action.get("env_name")
        if not env_name or not action.get("analytics_base_url"):
            dflt = config.get_default_browser_env(conn)
            if not dflt:
                conn.cursor().callproc("prod.atd_action_pkg.mark_action_failed",
                                       [aid, "no enabled BROWSER env configured"])
                continue
            env_name = dflt["env_name"]
            action["analytics_base_url"] = dflt["analytics_base_url"]
            action["fusion_apps_url"] = dflt.get("fusion_apps_url")
            action["credential_ref"] = dflt.get("credential_ref")
        try:
            env, ctx = get_env_ctx(env_name, action)
        except Exception as e:  # noqa: BLE001
            conn.cursor().callproc("prod.atd_action_pkg.mark_action_failed",
                                   [aid, f"env/session unavailable: {e}"[:3900]])
            continue
        if not live:
            print(f"[action {aid}] ATD_ACTION_LIVE != 1 — dry run only", flush=True)
        try:
            fusion_id, ref = actions.dispatch(ctx, env, action)
            conn.cursor().callproc("prod.atd_action_pkg.mark_action_done",
                                   [aid, fusion_id, ref])
            _action_result_callback(conn, action, fusion_id, ref)
            conn.commit()
            print(f"[action {aid}] DONE {action['action_type']} "
                  f"{action.get('source_ref') or ''} -> {fusion_id} ({ref})", flush=True)
        except actions.DryRun as d:
            conn.cursor().callproc("prod.atd_action_pkg.mark_action_failed",
                                   [aid, str(d)[:3900]])
            print(f"[action {aid}] DRY-RUN: {d}", flush=True)
        except Exception as e:  # noqa: BLE001
            try:
                conn.rollback()
            except Exception:  # noqa: BLE001
                pass
            conn.cursor().callproc("prod.atd_action_pkg.mark_action_failed",
                                   [aid, str(e)[:3900]])
            print(f"[action {aid}] FAILED: {e}", flush=True)


def _run_action_worker(conn, forever):
    """Claim+perform Fusion actions from ATD_ACTION_REQUEST until empty (or forever).
    Reuses the shared SSO session (auth.authenticate) and the single-browser lock.
    Each action is idempotent (the handler pre-checks Fusion); writes are gated by
    ATD_ACTION_LIVE=1 (else the handler raises DryRun and the row is marked failed
    with a clear reason)."""
    import actions
    host = _worker_id()
    lease = int(os.environ.get("ATD_ACTION_LEASE_MINUTES",
                               os.environ.get("ATD_LEASE_MINUTES", "30")))
    idle = int(os.environ.get("ATD_WORKER_IDLE", "15"))
    live = os.environ.get("ATD_ACTION_LIVE", "0") == "1"
    processed, failures = 0, 0
    ctx_by_env, browsers = {}, []
    reaped = conn.cursor().callfunc("prod.atd_action_pkg.reap_stale_actions", int, [lease])
    print(f"[action-worker {host}] starting (lease={lease}m, forever={forever}, "
          f"live={live}" + (f", reaped {reaped} stale" if reaped else "") + ")")
    if not live:
        print("[action-worker] ATD_ACTION_LIVE != 1 — DRY RUN: idempotency + form "
              "validation only, nothing will be saved in Fusion.")
    with sync_playwright() as p:
        try:
            while True:
                aid = conn.cursor().callfunc(
                    "prod.atd_action_pkg.claim_next_action", int, [host])
                if not aid:
                    if forever:
                        time.sleep(idle)
                        continue
                    break
                action = config.get_action(conn, aid)
                if not action:
                    conn.cursor().callproc("prod.atd_action_pkg.mark_action_failed",
                                           [aid, "no action row after claim"])
                    failures += 1
                    continue
                # resolve the Fusion env (action's own, else first BROWSER env)
                env_name = action.get("env_name")
                if not env_name or not action.get("analytics_base_url"):
                    dflt = config.get_default_browser_env(conn)
                    if not dflt:
                        conn.cursor().callproc("prod.atd_action_pkg.mark_action_failed",
                                               [aid, "no enabled BROWSER env configured"])
                        failures += 1
                        continue
                    env_name = dflt["env_name"]
                    action["analytics_base_url"] = dflt["analytics_base_url"]
                    action["fusion_apps_url"] = dflt.get("fusion_apps_url")
                    action["credential_ref"] = dflt.get("credential_ref")
                if env_name not in ctx_by_env:
                    env = {"env_name": env_name,
                           "analytics_base_url": action["analytics_base_url"],
                           "fusion_apps_url": action.get("fusion_apps_url"),
                           "credential_ref": action.get("credential_ref") or env_name}
                    browser, ctx = auth.authenticate(p, env)
                    browsers.append(browser)
                    ctx_by_env[env_name] = (env, ctx)
                env, ctx = ctx_by_env[env_name]
                try:
                    fusion_id, ref = actions.dispatch(ctx, env, action)
                    conn.cursor().callproc("prod.atd_action_pkg.mark_action_done",
                                           [aid, fusion_id, ref])
                    _action_result_callback(conn, action, fusion_id, ref)
                    conn.commit()
                    print(f"[action {aid}] DONE {action['action_type']} "
                          f"{action.get('source_ref') or ''} -> {fusion_id} ({ref})")
                    processed += 1
                except actions.DryRun as d:
                    conn.cursor().callproc("prod.atd_action_pkg.mark_action_failed",
                                           [aid, str(d)[:3900]])
                    print(f"[action {aid}] DRY-RUN: {d}")
                    failures += 1
                except Exception as e:  # noqa: BLE001
                    try:
                        conn.rollback()
                    except Exception:  # noqa: BLE001
                        pass
                    conn.cursor().callproc("prod.atd_action_pkg.mark_action_failed",
                                           [aid, str(e)[:3900]])
                    print(f"[action {aid}] FAILED: {e}")
                    failures += 1
        finally:
            for b in browsers:
                b.close()
    print(f"\n[action-worker {host}] done — processed {processed}, {failures} failure(s)")
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
           "xmlpserver_base_url": job.get("xmlpserver_base_url"),
           "credential_ref": job.get("credential_ref") or job["env_name"]}
    with sync_playwright() as p:
        browser, ctx = auth.authenticate(p, env)
        try:
            return run_one(ctx, env, job)
        finally:
            browser.close()


def _build_requests(conn, load, pw=None):
    """Drain QUEUED analysis-build requests, claiming each via ATD_QUEUE_PKG.claim_build
    (FOR UPDATE SKIP LOCKED -> flips QUEUED->BUILDING atomically) so two workers never
    build the same request. Build each in OTBI, register as a job, load once; mark
    DONE / FAILED."""
    import create_analysis
    run_one = _make_run_one_oracledb(conn, load)
    failures = 0
    while True:
        req_id = conn.cursor().callfunc("prod.atd_queue_pkg.claim_build", int, [])
        if not req_id:
            break
        cur = conn.cursor()
        cur.execute("SELECT spec_json FROM prod.atd_analysis_request WHERE req_id=:id", id=req_id)
        row = cur.fetchone()
        spec_text = (row[0].read() if row and hasattr(row[0], "read") else (row[0] if row else None))
        print(f"[build] request {req_id}: building analysis...")
        try:
            spec = json.loads(spec_text)
            path = create_analysis.build_analysis(spec, pw=pw)  # OTBI UI build + save + verify
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


def _discover_requests(conn, pw=None):
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
    # claim the next subject area atomically (FOR UPDATE SKIP LOCKED -> SCRAPING) so two
    # workers never scrape the same one
    sa = conn.cursor().callfunc("prod.atd_queue_pkg.claim_sa", str, [])
    if not sa:
        print("[discover] no queued subject-area discovery requests")
        return 0
    print(f"[discover] {sa}: scraping...")
    run_id = _log_start(conn, sa, track="DISCOVER")       # history for the Discovery page
    try:
        tree = create_analysis.discover_subject_area(sa, pw=pw)
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
    do_actions = "--actions" in args
    schedgen = "--schedgen" in args
    only = next((a for a in args if not a.startswith("-")), None)
    mode = _resolve_mode()

    # queue commands require oracledb (the function lives in the DB; the loop
    # claims via a live oracledb connection)
    if enqueue or worker or build or discover or do_actions or schedgen:
        if mode != "oracledb":
            print("[queue] --enqueue/--worker/--build/--discover/--actions require oracledb "
                  "mode (set ATD_DB_USER/PASSWORD + ATD_WALLET_PASSWORD)")
            sys.exit(2)
        import load
        conn = config.connect()
        config.apply_runner_config(conn)
        if do_actions:                  # drain Fusion write-back actions (AP invoices...)
            sys.exit(1 if _run_action_worker(conn, forever) else 0)
        if schedgen:                    # drain "Generate Schedule OTBI Data" requests
            import schedgen as _sg
            sys.exit(0 if _sg.drain_requests(conn) >= 0 else 1)
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
