-- ===========================================================================
-- otbi-atd : 34 job -> run-log cascade
--   Run-log rows had no link to the job that produced them, so removing a job
--   left its load history behind as orphans. A row-level AFTER-delete trigger on
--   ATD_OTBI_JOBS now clears that job's load rows (track API/BROWSER) whenever a
--   job is removed (any path: ORDS, SQLcl, future). DISCOVER rows are keyed by
--   subject area, not a job, so they are left untouched. A one-time cleanup
--   sweeps already-orphaned load rows. Idempotent / rerunnable. PROD-qualified.
--   CRLF / UTF-8 no BOM.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED
SET ECHO ON

-- row trigger: a removed job takes its own load history with it
CREATE OR REPLACE TRIGGER prod.trg_atd_job_log_cascade
AFTER DELETE ON prod.atd_otbi_jobs
FOR EACH ROW
BEGIN
  DELETE FROM prod.atd_load_run_log
   WHERE job_name = :OLD.job_name
     AND NVL(track,'BROWSER') IN ('API','BROWSER');
END;
/

-- one-time sweep of load rows whose job no longer exists (keep DISCOVER history)
DECLARE
  l_n NUMBER;
BEGIN
  DELETE FROM prod.atd_load_run_log l
   WHERE NVL(l.track,'BROWSER') IN ('API','BROWSER')
     AND NOT EXISTS (SELECT 1 FROM prod.atd_otbi_jobs j
                      WHERE j.job_name = l.job_name);
  l_n := SQL%ROWCOUNT;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('orphaned load rows removed: ' || l_n);
END;
/

SET ECHO OFF
PROMPT otbi-atd 34 job -> run-log cascade : done
