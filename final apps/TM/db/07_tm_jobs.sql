-- =============================================================================
-- Task Management Module (App 207) -- Scheduler jobs
-- File    : 07_tm_jobs.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @07_tm_jobs.sql   (after 05_tm_reminder_pkg.sql)
-- Notes   : Daily reminder sweep -- due-soon + overdue task reminders to assignees
--           and overdue escalation to team leaders, via DCT_TM_REMINDER_PKG.run_job.
--           Fires 07:00 Asia/Dubai. Re-runnable (drops then recreates the job).
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

DECLARE
    c_job CONSTANT VARCHAR2(61) := 'PROD.DCT_TM_REMINDER_JOB';
BEGIN
    BEGIN
        DBMS_SCHEDULER.DROP_JOB(job_name => c_job, force => TRUE);
        DBMS_OUTPUT.PUT_LINE('Dropped existing job ' || c_job);
    EXCEPTION WHEN OTHERS THEN NULL;   -- not present yet
    END;

    DBMS_SCHEDULER.CREATE_JOB(
        job_name        => c_job,
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN prod.dct_tm_reminder_pkg.run_job; END;',
        start_date      => SYSTIMESTAMP AT TIME ZONE 'Asia/Dubai',
        repeat_interval => 'FREQ=DAILY; BYHOUR=7; BYMINUTE=0; BYSECOND=0',
        enabled         => TRUE,
        comments        => 'i-Finance TM: daily due-task reminders + overdue escalation (App 207)');

    DBMS_OUTPUT.PUT_LINE('Created scheduler job ' || c_job || ' (daily 07:00 Asia/Dubai)');
END;
/

-- Verify
SET LINESIZE 160
COLUMN job_name FORMAT A26
COLUMN repeat_interval FORMAT A42
SELECT job_name, enabled, state, repeat_interval
FROM   user_scheduler_jobs WHERE job_name = 'DCT_TM_REMINDER_JOB';

PROMPT
PROMPT === 07_tm_jobs.sql complete ===
