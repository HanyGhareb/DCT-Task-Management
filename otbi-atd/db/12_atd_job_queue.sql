-- ===========================================================================
-- otbi-atd : 12 job queue (multi-host shared queue, design #3 steps 1-2)
-- Adds claim state to ATD_OTBI_JOBS + ATD_QUEUE_PKG so N hosts can drain one
-- queue with no overlap via SELECT ... FOR UPDATE SKIP LOCKED.
--   run_status  READY | CLAIMED | DONE | FAILED
--   claimed_by  host id holding the job
--   claimed_at  when claimed (lease expiry)
--   last_run_id link to ATD_LOAD_RUN_LOG
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
  -- Queue (mark READY) all enabled jobs, or one named job. Returns count.
  FUNCTION enqueue(p_only VARCHAR2 DEFAULT NULL) RETURN NUMBER;
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

  FUNCTION enqueue(p_only VARCHAR2 DEFAULT NULL) RETURN NUMBER IS
    n NUMBER;
  BEGIN
    UPDATE prod.atd_otbi_jobs
       SET run_status = 'READY', claimed_by = NULL, claimed_at = NULL
     WHERE enabled = 'Y'
       AND (p_only IS NULL OR job_name = p_only);
    n := SQL%ROWCOUNT;
    COMMIT;
    RETURN n;
  END enqueue;

END atd_queue_pkg;
/

-- start all current jobs READY
UPDATE prod.atd_otbi_jobs SET run_status = 'READY' WHERE enabled = 'Y';
COMMIT;

SET ECHO OFF
PROMPT otbi-atd 12 job queue : done
