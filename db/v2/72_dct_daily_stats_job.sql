-- =============================================================================
-- i-Finance — Daily PROD optimizer statistics maintenance
-- Runs every day at 00:00 Asia/Dubai and gathers only missing/stale statistics.
-- Rerunnable: updates the existing job without deleting its Scheduler history.
-- Run as ADMIN via: sql -name prod_mcp @72_dct_daily_stats_job.sql
-- =============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

DECLARE
  c_job    CONSTANT VARCHAR2(30) := 'DCT_DAILY_STATS_JOB';
  c_action CONSTANT VARCHAR2(4000) := q'[
BEGIN
  DBMS_STATS.GATHER_SCHEMA_STATS(
    ownname          => 'PROD',
    estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
    method_opt       => 'FOR ALL COLUMNS SIZE AUTO',
    options          => 'GATHER AUTO',
    cascade          => DBMS_STATS.AUTO_CASCADE,
    degree           => DBMS_STATS.AUTO_DEGREE,
    no_invalidate    => DBMS_STATS.AUTO_INVALIDATE
  );
END;]';
  l_exists NUMBER;
  l_start  TIMESTAMP WITH TIME ZONE;
BEGIN
  l_start := TO_TIMESTAMP_TZ(
    TO_CHAR(SYSTIMESTAMP AT TIME ZONE 'Asia/Dubai' + INTERVAL '1' DAY, 'YYYY-MM-DD') ||
    ' 00:00:00 Asia/Dubai',
    'YYYY-MM-DD HH24:MI:SS TZR');

  SELECT COUNT(*) INTO l_exists
    FROM dba_scheduler_jobs
   WHERE owner='PROD' AND job_name=c_job;

  IF l_exists = 0 THEN
    DBMS_SCHEDULER.CREATE_JOB(
      job_name        => 'PROD.' || c_job,
      job_type        => 'PLSQL_BLOCK',
      job_action      => c_action,
      start_date      => l_start,
      repeat_interval => 'FREQ=DAILY;BYHOUR=0;BYMINUTE=0;BYSECOND=0',
      enabled         => FALSE,
      auto_drop       => FALSE,
      comments        => 'Gather missing/stale PROD optimizer statistics daily at midnight Asia/Dubai');
  ELSE
    DBMS_SCHEDULER.DISABLE('PROD.' || c_job, force=>TRUE);
    DBMS_SCHEDULER.SET_ATTRIBUTE('PROD.' || c_job, 'job_action', c_action);
    DBMS_SCHEDULER.SET_ATTRIBUTE('PROD.' || c_job, 'start_date', l_start);
    DBMS_SCHEDULER.SET_ATTRIBUTE('PROD.' || c_job, 'repeat_interval',
                                 'FREQ=DAILY;BYHOUR=0;BYMINUTE=0;BYSECOND=0');
    DBMS_SCHEDULER.SET_ATTRIBUTE('PROD.' || c_job, 'comments',
      'Gather missing/stale PROD optimizer statistics daily at midnight Asia/Dubai');
  END IF;

  DBMS_SCHEDULER.SET_ATTRIBUTE('PROD.' || c_job, 'NLS_ENV',
                               'NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA''');
  DBMS_SCHEDULER.ENABLE('PROD.' || c_job);
  DBMS_OUTPUT.PUT_LINE('Enabled PROD.' || c_job || ' from ' || TO_CHAR(l_start,'YYYY-MM-DD HH24:MI TZR'));
END;
/

SELECT owner, job_name, enabled, state, repeat_interval,
       TO_CHAR(next_run_date AT TIME ZONE 'Asia/Dubai','YYYY-MM-DD HH24:MI TZR') next_run_dubai
  FROM dba_scheduler_jobs
 WHERE owner='PROD' AND job_name='DCT_DAILY_STATS_JOB';

PROMPT db/v2/72 daily PROD statistics job complete.
EXIT
