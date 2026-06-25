-- ===========================================================================
-- otbi-atd : 27 proactive session management
--   * ATD_WORKER_HEARTBEAT.session_started  -> when the worker's Fusion session
--     began (worker writes it from the auth_state file mtime), for the pre-expiry
--     "session aging" nudge + the dashboard session-age column.
--   * ATD_DAILY_RELOGIN job  -> once daily at the Break-window end (06:00 Asia/Dubai
--     = 02:00 UTC) flags every worker to re-login (sets refresh_req) IF
--     ATD_AUTO_RELOGIN='Y', so the day starts on a fresh session (one predictable MFA
--     per VM) instead of a surprise dead session mid-day.
--   * config (ATD_AUTO_RELOGIN, ATD_SESSION_WARN_HOURS) + ATD_AGING_MSG template,
--     UI-editable on the Runner Settings page (MERGE = never overwrite operator edits).
-- Rerunnable. Schema-qualified PROD. CRLF / UTF-8 no BOM.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON

-- when the current Fusion session began (NULL until the worker reports it)
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE prod.atd_worker_heartbeat ADD (session_started TIMESTAMP)';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;
END;
/

-- daily re-login flag-setter (06:00 Asia/Dubai = 02:00 UTC; DB is UTC)
BEGIN
  BEGIN
    DBMS_SCHEDULER.DROP_JOB('PROD.ATD_DAILY_RELOGIN', force => TRUE);
  EXCEPTION WHEN OTHERS THEN NULL;
  END;
  DBMS_SCHEDULER.CREATE_JOB(
    job_name        => 'PROD.ATD_DAILY_RELOGIN',
    job_type        => 'PLSQL_BLOCK',
    job_action      => q'[DECLARE
  v VARCHAR2(20);
BEGIN
  BEGIN
    SELECT config_value INTO v FROM prod.atd_runner_config WHERE config_key = 'ATD_AUTO_RELOGIN';
  EXCEPTION WHEN NO_DATA_FOUND THEN v := 'Y';
  END;
  IF UPPER(NVL(v,'Y')) IN ('Y','1','TRUE','ON') THEN
    UPDATE prod.atd_worker_heartbeat SET refresh_req = SYSTIMESTAMP;
    COMMIT;
  END IF;
END;]',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=DAILY;BYHOUR=2;BYMINUTE=0;BYSECOND=0',
    enabled         => TRUE,
    comments        => 'otbi-atd: flag all workers to re-login each morning (06:00 Asia/Dubai)');
END;
/

-- config + template (UI-editable; MERGE inserts only when absent)
MERGE INTO prod.atd_runner_config t
USING (SELECT 'ATD_AUTO_RELOGIN' AS config_key FROM dual) s ON (t.config_key = s.config_key)
WHEN NOT MATCHED THEN
  INSERT (config_key, config_value, value_type, enum_values, description, display_order)
  VALUES ('ATD_AUTO_RELOGIN', 'Y', 'ENUM', 'Y,N',
          'Daily morning auto re-login: when Y, ATD_DAILY_RELOGIN flags every worker to re-login at 06:00 Asia/Dubai (you approve one MFA per VM).',
          200);

MERGE INTO prod.atd_runner_config t
USING (SELECT 'ATD_SESSION_WARN_HOURS' AS config_key FROM dual) s ON (t.config_key = s.config_key)
WHEN NOT MATCHED THEN
  INSERT (config_key, config_value, value_type, enum_values, description, display_order)
  VALUES ('ATD_SESSION_WARN_HOURS', '7', 'NUMBER', NULL,
          'Pre-expiry nudge: Telegram-warn when a worker session is older than this many hours (the Entra session lives ~8h). 0 disables.',
          201);

MERGE INTO prod.atd_runner_config t
USING (SELECT 'ATD_AGING_MSG' AS config_key FROM dual) s ON (t.config_key = s.config_key)
WHEN NOT MATCHED THEN
  INSERT (config_key, config_value, value_type, enum_values, description, display_order)
  VALUES ('ATD_AGING_MSG',
          '{vm} OTBI session is ~{hours}h old and will expire soon - send "refresh {vm}" to re-login before it dies.',
          'STRING', NULL,
          'Pre-expiry session-aging nudge. Placeholders: {vm} = VM short name, {hours} = session age in hours.',
          202);

COMMIT;

SET ECHO OFF
PROMPT otbi-atd 27 proactive session : done
