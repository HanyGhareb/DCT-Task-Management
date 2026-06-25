-- ===========================================================================
-- otbi-atd : 29 per-job scheduling (frequency)
--   * ATD_OTBI_JOBS.frequency_minutes  -> how often a job should run. NULL = use
--     ATD_DEFAULT_FREQ_MINUTES (15 = today's behaviour). enqueue() (db/12) only marks
--     a job READY when it's DUE (no run within frequency_minutes), so heavy "Real
--     Time" jobs can run hourly/daily while hot jobs stay every cycle.
--   * config ATD_DEFAULT_FREQ_MINUTES (UI-editable on Runner Settings).
-- Rerunnable. Schema-qualified PROD. CRLF / UTF-8 no BOM.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON

BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE prod.atd_otbi_jobs ADD (frequency_minutes NUMBER)';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;
END;
/

MERGE INTO prod.atd_runner_config t
USING (SELECT 'ATD_DEFAULT_FREQ_MINUTES' AS config_key FROM dual) s ON (t.config_key = s.config_key)
WHEN NOT MATCHED THEN
  INSERT (config_key, config_value, value_type, enum_values, description, display_order)
  VALUES ('ATD_DEFAULT_FREQ_MINUTES', '15', 'NUMBER', NULL,
          'Default run frequency (minutes) for jobs whose own Frequency is blank. The 15-min enqueue only marks a job READY once this much time has passed since its last run.',
          230);

COMMIT;

SET ECHO OFF
PROMPT otbi-atd 29 job scheduling : done
