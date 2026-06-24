-- ===========================================================================
-- otbi-atd : 18 notification message templates (UI-editable)
-- Adds three message-template keys to ATD_RUNNER_CONFIG so the operator can edit
-- the runner's Telegram/email/webhook text on the "Runner Settings" page instead
-- of in code. The runner overlays these onto its environment at startup and
-- notify.render(key, default, ...) formats them (falling back to the default and
-- tolerating a missing placeholder, so a bad template never hides the event):
--   ATD_MFA_MSG    -> auth.surface_number   placeholders: {number} {vm} {host} {env}
--   ATD_JOB_MSG    -> runner truncation warn placeholders: {job} {note}
--   ATD_DRIFT_MSG  -> runner schema drift    placeholders: {job} {drift}
--
-- Idempotent: MERGE inserts only when absent, so re-running never overwrites a
-- value the operator has edited in the UI. Schema-qualified PROD. CRLF, UTF-8 no BOM.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON

MERGE INTO prod.atd_runner_config t
USING (SELECT 'ATD_MFA_MSG' AS config_key FROM dual) s
ON (t.config_key = s.config_key)
WHEN NOT MATCHED THEN
  INSERT (config_key, config_value, value_type, enum_values, description, display_order)
  VALUES ('ATD_MFA_MSG',
          '{number} - {vm} OTP for OTBI (use MS Authenticator - expires in a few minutes)',
          'STRING', NULL,
          'MFA sign-in approval message. Placeholders: {number} = the number to enter, {vm} = VM short name (e.g. vm181), {host} = full worker id, {env} = environment name. {number} is auto-appended if omitted; {vm} is prefixed if omitted.',
          100);

MERGE INTO prod.atd_runner_config t
USING (SELECT 'ATD_JOB_MSG' AS config_key FROM dual) s
ON (t.config_key = s.config_key)
WHEN NOT MATCHED THEN
  INSERT (config_key, config_value, value_type, enum_values, description, display_order)
  VALUES ('ATD_JOB_MSG',
          'otbi-atd {job}: {note}',
          'STRING', NULL,
          'Job status / truncation-warning message. Placeholders: {job} = job name, {note} = the warning text.',
          110);

MERGE INTO prod.atd_runner_config t
USING (SELECT 'ATD_DRIFT_MSG' AS config_key FROM dual) s
ON (t.config_key = s.config_key)
WHEN NOT MATCHED THEN
  INSERT (config_key, config_value, value_type, enum_values, description, display_order)
  VALUES ('ATD_DRIFT_MSG',
          'otbi-atd {job} schema drift: {drift}',
          'STRING', NULL,
          'Schema-drift warning message. Placeholders: {job} = job name, {drift} = the drift details.',
          120);

COMMIT;

SET ECHO OFF
PROMPT otbi-atd 18 message templates : done
