-- =============================================================================
-- Finance KPI Management Module (App 213) -- Scheduler jobs
-- File    : 07_kpi_jobs.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @07_kpi_jobs.sql   (after 04_kpi_pkg.sql)
-- Jobs    : DCT_KPI_PERIOD_JOB  -- yearly (Jan 2, 06:00 Dubai): ensures the
--                                  current + next year measurement calendars.
--           DCT_KPI_REMIND_JOB  -- weekly (Mon 09:00 Dubai): notifies KPI
--                                  administrators of elapsed periods without a
--                                  submitted or approved result.
-- Also    : seeds the live measurement calendar for the current + next year so
--           the app is usable immediately after deployment. Re-runnable.
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

DECLARE
    c_pjob CONSTANT VARCHAR2(61) := 'PROD.DCT_KPI_PERIOD_JOB';
    c_rjob CONSTANT VARCHAR2(61) := 'PROD.DCT_KPI_REMIND_JOB';
BEGIN
    -- live calendar now (idempotent)
    prod.dct_kpi_pkg.ensure_periods(EXTRACT(YEAR FROM SYSDATE));
    prod.dct_kpi_pkg.ensure_periods(EXTRACT(YEAR FROM SYSDATE) + 1);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Measurement calendars ensured for current + next year');

    BEGIN
        DBMS_SCHEDULER.DROP_JOB(job_name => c_pjob, force => TRUE);
    EXCEPTION WHEN OTHERS THEN NULL;
    END;
    DBMS_SCHEDULER.CREATE_JOB(
        job_name        => c_pjob,
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN prod.dct_kpi_pkg.ensure_periods(EXTRACT(YEAR FROM SYSDATE)); prod.dct_kpi_pkg.ensure_periods(EXTRACT(YEAR FROM SYSDATE) + 1); COMMIT; END;',
        start_date      => SYSTIMESTAMP AT TIME ZONE 'Asia/Dubai',
        repeat_interval => 'FREQ=YEARLY; BYMONTH=1; BYMONTHDAY=2; BYHOUR=6; BYMINUTE=0; BYSECOND=0',
        enabled         => TRUE,
        comments        => 'i-Finance KPI: yearly measurement-calendar generation (App 213)');
    DBMS_OUTPUT.PUT_LINE('Created scheduler job ' || c_pjob || ' (yearly Jan 2, 06:00 Asia/Dubai)');

    BEGIN
        DBMS_SCHEDULER.DROP_JOB(job_name => c_rjob, force => TRUE);
    EXCEPTION WHEN OTHERS THEN NULL;
    END;
    DBMS_SCHEDULER.CREATE_JOB(
        job_name        => c_rjob,
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN prod.dct_kpi_pkg.remind_missing; COMMIT; END;',
        start_date      => SYSTIMESTAMP AT TIME ZONE 'Asia/Dubai',
        repeat_interval => 'FREQ=WEEKLY; BYDAY=MON; BYHOUR=9; BYMINUTE=0; BYSECOND=0',
        enabled         => TRUE,
        comments        => 'i-Finance KPI: weekly missing-submission reminder to KPI administrators (App 213)');
    DBMS_OUTPUT.PUT_LINE('Created scheduler job ' || c_rjob || ' (weekly Mon 09:00 Asia/Dubai)');
END;
/

SET LINESIZE 160
COLUMN job_name FORMAT A26
COLUMN repeat_interval FORMAT A52
SELECT job_name, enabled, state, repeat_interval
FROM   user_scheduler_jobs WHERE job_name IN ('DCT_KPI_PERIOD_JOB', 'DCT_KPI_REMIND_JOB');

PROMPT
PROMPT === 07_kpi_jobs.sql complete ===
