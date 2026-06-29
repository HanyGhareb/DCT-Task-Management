-- ===========================================================================
-- DCT Actuals Reporting - hourly snapshot refresh job (db/v2/35)
-- ---------------------------------------------------------------------------
-- Keeps prod.dct_gl_coa_snap (db/v2/33) fresh against the date-tracked
-- DCT_GL_COA_V so the actuals fact + budget-vs-actual views reflect the latest
-- ATD loads and GL classification edits WITHOUT a manual refresh.
--
--   Job  : PROD.DCT_ACTUALS_REFRESH_JOB
--   Does : BEGIN prod.dct_actuals_refresh; END;   (DELETE+INSERT+stats, atomic)
--   When : every hour, on the hour.
--
-- The same proc is also exposed as a manual button in the GL + ATD apps
-- (POST /gl/actuals/refresh, POST /atd/actuals/refresh).
--
-- Rerunnable: the job is dropped first if it already exists.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

BEGIN
  BEGIN
    DBMS_SCHEDULER.DROP_JOB(job_name => 'PROD.DCT_ACTUALS_REFRESH_JOB', force => TRUE);
  EXCEPTION WHEN OTHERS THEN NULL;
  END;

  DBMS_SCHEDULER.CREATE_JOB(
    job_name        => 'PROD.DCT_ACTUALS_REFRESH_JOB',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN prod.dct_actuals_refresh; END;',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=HOURLY;INTERVAL=1',
    enabled         => TRUE,
    auto_drop       => FALSE,
    comments        => 'Hourly refresh of DCT_GL_COA_SNAP for the actuals reporting layer (db/v2/33-35).');
END;
/

PROMPT PROD.DCT_ACTUALS_REFRESH_JOB created/enabled (FREQ=HOURLY).

-- show what we just scheduled
SET LINESIZE 200
COLUMN job_name        FORMAT A34
COLUMN repeat_interval FORMAT A26
COLUMN state           FORMAT A12
COLUMN next_run        FORMAT A30
SELECT job_name, repeat_interval, enabled, state,
       TO_CHAR(next_run_date,'YYYY-MM-DD HH24:MI') AS next_run
FROM   all_scheduler_jobs
WHERE  owner = 'PROD' AND job_name = 'DCT_ACTUALS_REFRESH_JOB';
