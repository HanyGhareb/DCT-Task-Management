-- =============================================================================
-- Task Management Module (App 207) -- Reporting-cycle scheduler job
-- File    : 15_tm_cycle_jobs.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @15_tm_cycle_jobs.sql   (after 12_tm_cycle_pkg.sql)
-- Notes   : Daily cycle sweep -- generate upcoming periods, open due windows, remind
--           non-submitters on configured offsets, mark overdue, escalate to leaders,
--           auto-close + snapshot after the grace window. Via DCT_TM_CYCLE_PKG.run_job.
--           Fires 06:30 Asia/Dubai (before the 07:00 task-reminder job). Re-runnable.
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

DECLARE
    c_job CONSTANT VARCHAR2(61) := 'PROD.DCT_TM_CYCLE_JOB';
BEGIN
    BEGIN
        DBMS_SCHEDULER.DROP_JOB(job_name => c_job, force => TRUE);
        DBMS_OUTPUT.PUT_LINE('Dropped existing job ' || c_job);
    EXCEPTION WHEN OTHERS THEN NULL;   -- not present yet
    END;

    DBMS_SCHEDULER.CREATE_JOB(
        job_name        => c_job,
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN prod.dct_tm_cycle_pkg.run_job; END;',
        start_date      => SYSTIMESTAMP AT TIME ZONE 'Asia/Dubai',
        repeat_interval => 'FREQ=DAILY; BYHOUR=6; BYMINUTE=30; BYSECOND=0',
        enabled         => TRUE,
        comments        => 'i-Finance TM: daily reporting-cycle sweep -- open periods, remind, escalate, auto-close (App 207)');

    DBMS_OUTPUT.PUT_LINE('Created scheduler job ' || c_job || ' (daily 06:30 Asia/Dubai)');
END;
/

-- Verify
SET LINESIZE 160
COLUMN job_name FORMAT A26
COLUMN repeat_interval FORMAT A42
SELECT job_name, enabled, state, repeat_interval
FROM   user_scheduler_jobs WHERE job_name = 'DCT_TM_CYCLE_JOB';

PROMPT
PROMPT === 15_tm_cycle_jobs.sql complete ===
