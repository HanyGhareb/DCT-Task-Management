-- ===========================================================================
-- otbi-atd : 28 job health (chronic-failure alert + stale-run reaper config)
--   * ATD_OTBI_JOBS.fail_alert_sent  -> de-dupe flag so a chronically-failing job
--     alerts ONCE (flipped N->Y atomically by the worker that hits the streak;
--     cleared on the next SUCCESS). Single-actor-safe across the 3 VMs.
--   * config ATD_FAIL_ALERT_STREAK (consecutive fails before alerting) +
--     ATD_RUN_REAP_MINUTES (stale RUNNING run-log row age) + ATD_FAIL_ALERT_MSG,
--     UI-editable on Runner Settings (MERGE = never overwrite operator edits).
-- Rerunnable. Schema-qualified PROD. CRLF / UTF-8 no BOM.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON

-- chronic-failure alert de-dupe flag
BEGIN
  EXECUTE IMMEDIATE q'[ALTER TABLE prod.atd_otbi_jobs ADD (fail_alert_sent CHAR(1) DEFAULT 'N')]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;
END;
/

MERGE INTO prod.atd_runner_config t
USING (SELECT 'ATD_FAIL_ALERT_STREAK' AS config_key FROM dual) s ON (t.config_key = s.config_key)
WHEN NOT MATCHED THEN
  INSERT (config_key, config_value, value_type, enum_values, description, display_order)
  VALUES ('ATD_FAIL_ALERT_STREAK', '4', 'NUMBER', NULL,
          'Chronic-failure alert: Telegram-alert after this many consecutive failures on a job (a config break, e.g. a moved report path). 0 disables.',
          210);

MERGE INTO prod.atd_runner_config t
USING (SELECT 'ATD_RUN_REAP_MINUTES' AS config_key FROM dual) s ON (t.config_key = s.config_key)
WHEN NOT MATCHED THEN
  INSERT (config_key, config_value, value_type, enum_values, description, display_order)
  VALUES ('ATD_RUN_REAP_MINUTES', '60', 'NUMBER', NULL,
          'Stale-run reaper: close a RUNNING run-log row (crashed/killed mid-run) as FAILED after this many minutes.',
          211);

MERGE INTO prod.atd_runner_config t
USING (SELECT 'ATD_FAIL_ALERT_MSG' AS config_key FROM dual) s ON (t.config_key = s.config_key)
WHEN NOT MATCHED THEN
  INSERT (config_key, config_value, value_type, enum_values, description, display_order)
  VALUES ('ATD_FAIL_ALERT_MSG',
          'otbi-atd ALERT: job {job} has failed {count} times in a row on {vm}. Last error: {error}',
          'STRING', NULL,
          'Chronic-failure alert. Placeholders: {job} = job name, {count} = consecutive failures, {vm} = VM short name, {error} = latest error.',
          212);

COMMIT;

SET ECHO OFF
PROMPT otbi-atd 28 job health : done
