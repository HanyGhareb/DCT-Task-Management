-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 05 scheduler sync
-- File   : reporting/db/05_rpt_sched_sync.sql
-- Run as : sql -name prod_mcp
-- Purpose: rebuild DBMS_SCHEDULER jobs from DCT_RPT_SCHEDULE (mirror ATD_SCHED_SYNC).
--          Each schedule -> one job DCT_RPT_SCH_<id> that calls
--          prod.dct_rpt_run_schedule(<id>), which enqueues a run (the PYTHON
--          worker, or -- Phase 3 -- the native engine, then processes it).
--          Re-run prod.dct_rpt_sched_sync (or POST /rpt/schedules/sync) any time.
--          Also installs DCT_RPT_MAINT_JOB (reclaim stuck runs + purge old output).
-- CRLF + UTF-8 no BOM.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON

-- ---------------------------------------------------------------------------
-- enqueue one schedule's run (called by its DBMS_SCHEDULER job). Routing by
-- engine: PYTHON -> queue for a worker; NATIVE -> queue too (Phase 3 swaps this
-- to call dct_rpt_native_pkg directly). Stamps last_run_at.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE prod.dct_rpt_run_schedule (p_schedule_id NUMBER) IS
  l_code   prod.dct_rpt_definition.report_code%TYPE;
  l_crit   prod.dct_rpt_schedule.criteria_json%TYPE;
  l_run    NUMBER;
BEGIN
  SELECT report_code, criteria_json INTO l_code, l_crit
    FROM prod.dct_rpt_schedule WHERE schedule_id = p_schedule_id AND enabled = 'Y';
  l_run := prod.dct_rpt_pkg.enqueue(p_report_code => l_code,
                                    p_params      => l_crit,
                                    p_trigger     => 'SCHEDULE');
  UPDATE prod.dct_rpt_schedule SET last_run_at = SYSTIMESTAMP WHERE schedule_id = p_schedule_id;
  COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN NULL;  -- schedule disabled/removed between sync and fire
END dct_rpt_run_schedule;
/
SHOW ERRORS PROCEDURE prod.dct_rpt_run_schedule

-- ---------------------------------------------------------------------------
-- rebuild the per-schedule jobs from the control table.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE prod.dct_rpt_sched_sync IS
  l_jobname VARCHAR2(128);
BEGIN
  FOR j IN (SELECT job_name FROM user_scheduler_jobs WHERE job_name LIKE 'DCT_RPT_SCH_%') LOOP
    BEGIN DBMS_SCHEDULER.DROP_JOB(j.job_name, force => TRUE);
    EXCEPTION WHEN OTHERS THEN NULL; END;
  END LOOP;

  FOR r IN (
    SELECT s.schedule_id, s.repeat_interval, s.timezone
      FROM prod.dct_rpt_schedule  s
      JOIN prod.dct_rpt_definition d ON d.report_code = s.report_code
     WHERE s.enabled = 'Y' AND d.enabled = 'Y'
       AND s.repeat_interval IS NOT NULL
  ) LOOP
    l_jobname := 'DCT_RPT_SCH_' || r.schedule_id;
    DBMS_SCHEDULER.CREATE_JOB(
      job_name        => l_jobname,
      job_type        => 'PLSQL_BLOCK',
      job_action      => 'BEGIN prod.dct_rpt_run_schedule(' || r.schedule_id || '); END;',
      start_date      => SYSTIMESTAMP AT TIME ZONE NVL(r.timezone,'Asia/Dubai'),
      repeat_interval => r.repeat_interval,
      enabled         => TRUE,
      comments        => 'i-Finance reporting schedule ' || r.schedule_id);
    DBMS_OUTPUT.PUT_LINE('created ' || l_jobname || '  [' || r.repeat_interval || ']');
  END LOOP;
END dct_rpt_sched_sync;
/
SHOW ERRORS PROCEDURE prod.dct_rpt_sched_sync

-- ---------------------------------------------------------------------------
-- maintenance: reclaim stuck RUNNING runs + purge expired output BLOBs.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE prod.dct_rpt_maint IS
  l_retain NUMBER := TO_NUMBER(NVL(prod.dct_rpt_pkg.cfg('OUTPUT_RETAIN_DAYS','90'),'90'));
BEGIN
  prod.dct_rpt_pkg.reclaim_stuck;
  IF l_retain > 0 THEN
    DELETE FROM prod.dct_rpt_output
     WHERE created_at < SYSTIMESTAMP - NUMTODSINTERVAL(l_retain, 'DAY');
    COMMIT;
  END IF;
END dct_rpt_maint;
/
SHOW ERRORS PROCEDURE prod.dct_rpt_maint

-- install the maintenance job (every 15 minutes)
BEGIN
  BEGIN DBMS_SCHEDULER.DROP_JOB('DCT_RPT_MAINT_JOB', force => TRUE);
  EXCEPTION WHEN OTHERS THEN NULL; END;
  DBMS_SCHEDULER.CREATE_JOB(
    job_name        => 'DCT_RPT_MAINT_JOB',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN prod.dct_rpt_maint; END;',
    start_date      => SYSTIMESTAMP AT TIME ZONE 'Asia/Dubai',
    repeat_interval => 'FREQ=MINUTELY;INTERVAL=15',
    enabled         => TRUE,
    comments        => 'i-Finance reporting maintenance (reclaim stuck + purge output)');
END;
/

-- ADMIN synonyms (for the ORDS sync handler / manual EXEC)
CREATE OR REPLACE SYNONYM dct_rpt_sched_sync   FOR prod.dct_rpt_sched_sync;
CREATE OR REPLACE SYNONYM dct_rpt_run_schedule FOR prod.dct_rpt_run_schedule;
CREATE OR REPLACE SYNONYM dct_rpt_maint        FOR prod.dct_rpt_maint;

SET ECHO OFF
PROMPT 05_rpt_sched_sync.sql complete  (run EXEC prod.dct_rpt_sched_sync to build report jobs).
