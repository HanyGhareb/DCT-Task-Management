-- ===========================================================================
-- otbi-atd : 19 central enqueue job
-- One DBMS_SCHEDULER job marks all enabled jobs READY every 15 min so the
-- always-on parallel workers (runner.py --worker --forever on each VM) pick them
-- up. Single actor -> no VM contention. enqueue() (db/12) skips CLAIMED rows, so
-- this never disturbs an in-flight job. Rerunnable (drops + recreates the job).
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON

BEGIN
  BEGIN
    DBMS_SCHEDULER.DROP_JOB('PROD.ATD_ENQUEUE_JOB', force => TRUE);
  EXCEPTION WHEN OTHERS THEN NULL;   -- not present yet
  END;
  DBMS_SCHEDULER.CREATE_JOB(
    job_name        => 'PROD.ATD_ENQUEUE_JOB',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'DECLARE n NUMBER; BEGIN n := prod.atd_queue_pkg.enqueue; END;',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=MINUTELY;INTERVAL=15',
    enabled         => TRUE,
    comments        => 'otbi-atd: re-queue enabled jobs every 15 min for the parallel workers');
END;
/

SET ECHO OFF
PROMPT otbi-atd 19 enqueue job : done
