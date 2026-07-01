-- ===========================================================================
-- otbi-atd : 12 job queue (multi-host shared queue, design #3 steps 1-2)
-- Adds claim state to ATD_OTBI_JOBS + ATD_QUEUE_PKG so N hosts can drain one
-- queue with no overlap via SELECT ... FOR UPDATE SKIP LOCKED.
--   run_status  READY | CLAIMED | DONE | FAILED
--   claimed_by  host id holding the job
--   claimed_at  when claimed (lease expiry)
--   last_run_id link to ATD_LOAD_RUN_LOG
-- NOTE: enqueue() references prod.atd_set_gate_ok / prod.atd_set_eff_freq (Job Sets,
--   db/40) so a set can gate/re-interval its members. Apply db/40 as well; until it is,
--   those wrappers are missing and this package body is INVALID (auto-revalidates once
--   db/40 runs). A job in no set behaves exactly as before.
-- Rerunnable (ADD guarded against ORA-01430). Schema-qualified PROD. CRLF/UTF-8 no BOM.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON

-- ---- columns ----
BEGIN
  EXECUTE IMMEDIATE
    q'[ALTER TABLE prod.atd_otbi_jobs ADD (run_status VARCHAR2(12) DEFAULT 'READY' NOT NULL)]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE prod.atd_otbi_jobs ADD (claimed_by VARCHAR2(120))';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE prod.atd_otbi_jobs ADD (claimed_at TIMESTAMP)';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE prod.atd_otbi_jobs ADD (last_run_id NUMBER)';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;
END;
/

-- status domain guard (drop+add so rerun is clean)
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE prod.atd_otbi_jobs DROP CONSTRAINT ck_atd_job_runstat';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -2443 THEN RAISE; END IF;  -- not found
END;
/
ALTER TABLE prod.atd_otbi_jobs ADD CONSTRAINT ck_atd_job_runstat
  CHECK (run_status IN ('READY','CLAIMED','DONE','FAILED'));

-- claim-probe index
BEGIN
  EXECUTE IMMEDIATE
    'CREATE INDEX prod.ix_atd_jobs_claim ON prod.atd_otbi_jobs (run_status, priority, run_order)';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF;  -- already exists
END;
/

-- ---- queue package ----
CREATE OR REPLACE PACKAGE prod.atd_queue_pkg AS
  -- Atomically lease the next READY job to p_host; returns job_name or NULL.
  -- Pure SKIP LOCKED claim (no lease logic in the hot path - see reap_stale).
  FUNCTION claim_next(p_host VARCHAR2) RETURN VARCHAR2;
  -- Return CLAIMED jobs whose lease passed p_lease_minutes back to READY (crash
  -- recovery). Call occasionally, e.g. once at worker startup. Returns count.
  FUNCTION reap_stale(p_lease_minutes NUMBER DEFAULT 30) RETURN NUMBER;
  -- Mark a claimed job DONE / FAILED (records the run log id when known).
  PROCEDURE mark_done  (p_job VARCHAR2, p_run_id NUMBER DEFAULT NULL);
  PROCEDURE mark_failed(p_job VARCHAR2, p_run_id NUMBER DEFAULT NULL);
  -- Hand a claimed job BACK to the queue (-> READY) WITHOUT marking it failed/done.
  -- Used when a worker's Fusion session died mid-run so a peer with a healthy session
  -- retries it (cross-worker failover) instead of the job being consumed as FAILED.
  PROCEDURE release_job(p_job VARCHAR2);
  -- Queue (mark READY) all enabled jobs, or one named job. Returns count.
  FUNCTION enqueue(p_only VARCHAR2 DEFAULT NULL) RETURN NUMBER;
  -- Atomically claim the next QUEUED subject-area discovery (-> SCRAPING); SKIP LOCKED.
  -- Returns subject_area or NULL. Lets N hosts drain the discover queue with no overlap.
  FUNCTION claim_sa RETURN VARCHAR2;
  -- Atomically claim the next QUEUED analysis-build request (-> BUILDING); SKIP LOCKED.
  -- Returns req_id or NULL.
  FUNCTION claim_build RETURN NUMBER;
END atd_queue_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.atd_queue_pkg AS

  FUNCTION claim_next(p_host VARCHAR2) RETURN VARCHAR2 IS
    CURSOR c IS
      SELECT job_name FROM prod.atd_otbi_jobs
       WHERE enabled = 'Y' AND run_status = 'READY'
       ORDER BY priority, run_order, job_name
       FOR UPDATE SKIP LOCKED;
    v_job prod.atd_otbi_jobs.job_name%TYPE;
  BEGIN
    OPEN c;
    FETCH c INTO v_job;
    IF c%FOUND THEN
      UPDATE prod.atd_otbi_jobs
         SET run_status = 'CLAIMED', claimed_by = p_host,
             claimed_at = CAST(SYSTIMESTAMP AS TIMESTAMP)
       WHERE job_name = v_job;
    END IF;
    CLOSE c;
    COMMIT;                 -- releases the row lock; the CLAIMED flag now owns it
    RETURN v_job;          -- NULL when the queue is empty
  END claim_next;

  FUNCTION reap_stale(p_lease_minutes NUMBER DEFAULT 30) RETURN NUMBER IS
    n NUMBER;
  BEGIN
    -- compare both sides as plain TIMESTAMP (session TZ) so a fresh claim is
    -- never mistaken for stale (mixing TIMESTAMP with SYSTIMESTAMP-WITH-TZ skews
    -- by the session/db TZ offset).
    UPDATE prod.atd_otbi_jobs
       SET run_status = 'READY', claimed_by = NULL, claimed_at = NULL
     WHERE run_status = 'CLAIMED'
       AND claimed_at < CAST(SYSTIMESTAMP AS TIMESTAMP)
                        - NUMTODSINTERVAL(NVL(p_lease_minutes,30), 'MINUTE');
    n := SQL%ROWCOUNT;
    COMMIT;
    RETURN n;
  END reap_stale;

  PROCEDURE mark_done(p_job VARCHAR2, p_run_id NUMBER DEFAULT NULL) IS
  BEGIN
    UPDATE prod.atd_otbi_jobs
       SET run_status = 'DONE',
           last_run_id = NVL(p_run_id, last_run_id)
     WHERE job_name = p_job;
    COMMIT;
  END mark_done;

  PROCEDURE mark_failed(p_job VARCHAR2, p_run_id NUMBER DEFAULT NULL) IS
  BEGIN
    UPDATE prod.atd_otbi_jobs
       SET run_status = 'FAILED',
           last_run_id = NVL(p_run_id, last_run_id)
     WHERE job_name = p_job;
    COMMIT;
  END mark_failed;

  PROCEDURE release_job(p_job VARCHAR2) IS
  BEGIN
    UPDATE prod.atd_otbi_jobs
       SET run_status = 'READY', claimed_by = NULL, claimed_at = NULL
     WHERE job_name = p_job;
    COMMIT;
  END release_job;

  FUNCTION enqueue(p_only VARCHAR2 DEFAULT NULL) RETURN NUMBER IS
    n        NUMBER;
    v_defreq NUMBER := 15;
  BEGIN
    -- Break / blackout window: during the configured off-hours window pause the whole
    -- fleet -> queue no new work (the scheduled bulk enqueue). A manual single-job
    -- enqueue (p_only set) is allowed through as an explicit operator override.
    IF p_only IS NULL AND prod.atd_in_break = 'Y' THEN
      RETURN 0;
    END IF;
    BEGIN
      SELECT TO_NUMBER(config_value) INTO v_defreq
        FROM prod.atd_runner_config WHERE config_key = 'ATD_DEFAULT_FREQ_MINUTES';
    EXCEPTION WHEN OTHERS THEN v_defreq := 15;
    END;
    -- never reset an in-flight (CLAIMED) job - that would let a peer double-run it.
    -- Per-job frequency: on the scheduled bulk run only (re)queue a job that is DUE,
    -- i.e. has no run within its frequency_minutes (NULL -> ATD_DEFAULT_FREQ_MINUTES).
    -- A manual single-job enqueue (p_only) always runs as an explicit override.
    UPDATE prod.atd_otbi_jobs j
       SET j.run_status = 'READY', j.claimed_by = NULL, j.claimed_at = NULL
     WHERE j.enabled = 'Y'
       AND j.run_status <> 'CLAIMED'
       AND (p_only IS NULL OR j.job_name = p_only)
       -- schema-review hold: a job awaiting review that is ALREADY prepared is not
       -- (re)queued (it would only re-HELD). A held job not yet prepared IS queued so
       -- the worker can prepare the table+map for review. Resumes once approved (->'Y').
       AND NOT (NVL(j.schema_reviewed,'Y') = 'N' AND j.column_map_json IS NOT NULL)
       -- Job Set gate (db/40): on the scheduled bulk path only, hold a member while its
       -- set is paused / inactive / outside its window. A manual single-job enqueue
       -- (p_only) is an explicit operator override and bypasses the gate (like the break window).
       AND (p_only IS NOT NULL OR prod.atd_set_gate_ok(j.job_name) = 'Y')
       AND (p_only IS NOT NULL
            OR NOT EXISTS (
                 SELECT 1 FROM prod.atd_load_run_log l
                  WHERE l.job_name = j.job_name
                    AND l.started > CAST(SYSTIMESTAMP AS TIMESTAMP)
                        - NUMTODSINTERVAL(NVL(prod.atd_set_eff_freq(j.job_name, j.frequency_minutes), v_defreq), 'MINUTE')));
    n := SQL%ROWCOUNT;
    COMMIT;
    RETURN n;
  END enqueue;

  FUNCTION claim_sa RETURN VARCHAR2 IS
    CURSOR c IS
      SELECT subject_area FROM prod.atd_sa_catalog
       WHERE status = 'QUEUED' ORDER BY requested_at
       FOR UPDATE SKIP LOCKED;
    v prod.atd_sa_catalog.subject_area%TYPE;
  BEGIN
    OPEN c;
    FETCH c INTO v;
    IF c%FOUND THEN
      UPDATE prod.atd_sa_catalog SET status = 'SCRAPING' WHERE subject_area = v;
    END IF;
    CLOSE c;
    COMMIT;                 -- COMMIT releases the row lock; the SCRAPING flag now owns it
    RETURN v;
  END claim_sa;

  FUNCTION claim_build RETURN NUMBER IS
    CURSOR c IS
      SELECT req_id FROM prod.atd_analysis_request
       WHERE status = 'QUEUED' ORDER BY req_id
       FOR UPDATE SKIP LOCKED;
    v NUMBER;
  BEGIN
    OPEN c;
    FETCH c INTO v;
    IF c%FOUND THEN
      UPDATE prod.atd_analysis_request SET status = 'BUILDING' WHERE req_id = v;
    END IF;
    CLOSE c;
    COMMIT;
    RETURN v;
  END claim_build;

END atd_queue_pkg;
/

-- start all current jobs READY
UPDATE prod.atd_otbi_jobs SET run_status = 'READY' WHERE enabled = 'Y';
COMMIT;

SET ECHO OFF
PROMPT otbi-atd 12 job queue : done
