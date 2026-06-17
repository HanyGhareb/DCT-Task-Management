-- ===========================================================================
-- otbi-atd : 14 runner config (UI-managed operational settings)
-- ATD_RUNNER_CONFIG holds the NON-SECRET runner settings that were previously
-- only editable in env.ps1 (MFA wait, lease, chunk, notify channel, truncation
-- caps, OTBI user, Telegram chat). The ATD app "Runner Settings" page edits
-- these; the runner overlays them onto its environment at startup (DB wins).
--
-- SECRETS (Fusion password, Telegram bot token, DB/wallet passwords) are NOT
-- stored here -- they stay in env.ps1 today and move to OCI Vault for the VM.
-- The is_secret flag exists so a future secret-by-reference can be flagged and
-- never returned to the UI in clear.
--
-- Rerunnable. Schema-qualified PROD. CRLF + UTF-8 no BOM.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE prod.atd_runner_config CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

CREATE TABLE prod.atd_runner_config (
  config_key    VARCHAR2(60)  NOT NULL,
  config_value  VARCHAR2(2000),
  value_type    VARCHAR2(20)  DEFAULT 'STRING' NOT NULL,  -- STRING|NUMBER|ENUM|BOOL
  is_secret     CHAR(1)       DEFAULT 'N' NOT NULL,
  enum_values   VARCHAR2(400),                            -- CSV of allowed values for ENUM
  description   VARCHAR2(400),
  display_order NUMBER        DEFAULT 100 NOT NULL,
  updated_by    VARCHAR2(100),
  updated_at    TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
  CONSTRAINT pk_atd_runner_config PRIMARY KEY (config_key),
  CONSTRAINT ck_atd_rc_secret CHECK (is_secret IN ('Y','N')),
  CONSTRAINT ck_atd_rc_type   CHECK (value_type IN ('STRING','NUMBER','ENUM','BOOL'))
);

-- seed the managed (non-secret) operational keys with their current defaults.
-- Individual INSERTs (INSERT ALL + defaults is fine, but keep per-row per house style).
INSERT INTO prod.atd_runner_config (config_key, config_value, value_type, enum_values, description, display_order)
  VALUES ('OTBI_USER', 'hg2248@dctabudhabi.ae', 'STRING', NULL, 'Fusion / OTBI login username (the password stays in env.ps1 / Vault)', 10);
INSERT INTO prod.atd_runner_config (config_key, config_value, value_type, enum_values, description, display_order)
  VALUES ('ATD_MFA_WAIT', '420', 'NUMBER', NULL, 'Seconds to wait for the MFA push approval before failing the run', 20);
INSERT INTO prod.atd_runner_config (config_key, config_value, value_type, enum_values, description, display_order)
  VALUES ('ATD_LEASE_MINUTES', '30', 'NUMBER', NULL, 'Minutes before a CLAIMED job is reclaimed (worker crash recovery)', 30);
INSERT INTO prod.atd_runner_config (config_key, config_value, value_type, enum_values, description, display_order)
  VALUES ('ATD_DB_CHUNK', '5000', 'NUMBER', NULL, 'Rows per array-bind round-trip in oracledb load mode', 40);
INSERT INTO prod.atd_runner_config (config_key, config_value, value_type, enum_values, description, display_order)
  VALUES ('ATD_WORKER_IDLE', '15', 'NUMBER', NULL, 'Seconds a --forever worker sleeps when the queue is empty', 50);
INSERT INTO prod.atd_runner_config (config_key, config_value, value_type, enum_values, description, display_order)
  VALUES ('ATD_NOTIFY', 'telegram', 'ENUM', 'telegram,email,webhook,sms,off', 'MFA-number delivery channel', 60);
INSERT INTO prod.atd_runner_config (config_key, config_value, value_type, enum_values, description, display_order)
  VALUES ('ATD_TG_CHAT', '721809903', 'STRING', NULL, 'Telegram chat id the MFA number is sent to (the bot token stays in env.ps1 / Vault)', 70);
INSERT INTO prod.atd_runner_config (config_key, config_value, value_type, enum_values, description, display_order)
  VALUES ('ATD_TRUNCATION_CAPS', '25000,50000,65000,75000,100000,250000,500000', 'STRING', NULL, 'Row counts that flag a likely OTBI export truncation', 80);
INSERT INTO prod.atd_runner_config (config_key, config_value, value_type, enum_values, description, display_order)
  VALUES ('ATD_EXPECTED_MIN', '', 'NUMBER', NULL, 'Warn if a load returns fewer rows than this (0/blank = off)', 90);
COMMIT;

SET ECHO OFF
PROMPT otbi-atd 14 runner config : done
