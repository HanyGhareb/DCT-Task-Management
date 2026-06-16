-- ===========================================================================
-- otbi-atd : 04 scheduler
-- ATD_SCHED_SYNC rebuilds DBMS_SCHEDULER jobs from ATD_OTBI_JOBS rows that are
-- enabled, API track, and have a schedule. Each DB job calls
-- atd_otbi_pkg.run_job(<job_name>). Re-run any time to resync.
-- CRLF + UTF-8 no BOM.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON

CREATE OR REPLACE PROCEDURE prod.atd_sched_sync IS
  l_jobname VARCHAR2(128);
BEGIN
  -- drop existing ATD jobs
  FOR j IN (SELECT job_name FROM user_scheduler_jobs WHERE job_name LIKE 'ATD_OTBI_%') LOOP
    BEGIN DBMS_SCHEDULER.DROP_JOB(j.job_name, force => TRUE);
    EXCEPTION WHEN OTHERS THEN NULL; END;
  END LOOP;

  -- (re)create from the control table
  FOR r IN (
    SELECT j.job_name, j.schedule
      FROM prod.atd_otbi_jobs j
      JOIN prod.atd_otbi_env  e ON e.env_name = j.env_name
     WHERE j.enabled = 'Y' AND e.enabled = 'Y'
       AND e.extract_track = 'API'
       AND j.schedule IS NOT NULL
  ) LOOP
    l_jobname := 'ATD_OTBI_'||UPPER(REGEXP_REPLACE(r.job_name,'[^A-Za-z0-9_]','_'));
    DBMS_SCHEDULER.CREATE_JOB(
      job_name        => l_jobname,
      job_type        => 'PLSQL_BLOCK',
      job_action      => 'BEGIN prod.atd_otbi_pkg.run_job('''||r.job_name||'''); END;',
      start_date      => SYSTIMESTAMP,
      repeat_interval => r.schedule,
      enabled         => TRUE,
      comments        => 'otbi-atd job '||r.job_name);
    DBMS_OUTPUT.PUT_LINE('created '||l_jobname||'  ['||r.schedule||']');
  END LOOP;
END atd_sched_sync;
/
SHOW ERRORS PROCEDURE prod.atd_sched_sync

SET ECHO OFF
PROMPT otbi-atd 04 scheduler : done   (run EXEC prod.atd_sched_sync to build jobs)
