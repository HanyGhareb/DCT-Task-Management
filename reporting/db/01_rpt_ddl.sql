-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 01 DDL (shared control plane)
-- File   : reporting/db/01_rpt_ddl.sql
-- Schema : PROD tables + ADMIN synonyms
-- Run as : sql -name prod_mcp   (FRESH session -- do NOT follow an ALTER SESSION
--          SET CURRENT_SCHEMA=PROD run, or the synonyms self-reference ORA-01471)
-- Purpose: ONE control plane that BOTH report engines plug into. A definition's
--          ENGINE column (PYTHON|NATIVE) routes execution; everything else --
--          schedules, recipients, run history, generated outputs, delivery
--          status, and the UI-editable runtime/SMTP config -- is shared.
-- Tables : DCT_RPT_DEFINITION  report catalogue (what to run, how, who gets it)
--          DCT_RPT_SCHEDULE    DBMS_SCHEDULER calendar(s) per report
--          DCT_RPT_RECIPIENT   distribution rules (USER/ROLE/ORG/EMAIL/SELF x channel)
--          DCT_RPT_RUN         run log (one row per generation attempt)
--          DCT_RPT_OUTPUT      generated artifacts (PDF/XLSX BLOB per run)
--          DCT_RPT_DELIVERY    per-recipient delivery outcome
--          DCT_RPT_CONFIG      UI-editable runtime/SMTP config (mirror ATD_RUNNER_CONFIG)
-- Idempotent: every CREATE is guarded (ORA-00955); safe to re-run.
-- CRLF + UTF-8 no BOM.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. DCT_RPT_DEFINITION ===
BEGIN
  EXECUTE IMMEDIATE q'[
    CREATE TABLE prod.dct_rpt_definition (
      report_code        VARCHAR2(60)   NOT NULL,
      name_en            VARCHAR2(200)  NOT NULL,
      name_ar            VARCHAR2(200),
      description        VARCHAR2(1000),
      category           VARCHAR2(40),
      source_type        VARCHAR2(20)   DEFAULT 'VIEW'   NOT NULL,  -- lookup RPT_SOURCE_TYPE: VIEW|SQL|PKG
      source_ref         CLOB           NOT NULL,                   -- view name | SQL text | package call
      engine             VARCHAR2(20)   DEFAULT 'PYTHON' NOT NULL,  -- lookup RPT_ENGINE: PYTHON|NATIVE
      default_formats    VARCHAR2(40)   DEFAULT 'PDF,XLSX' NOT NULL,-- CSV of RPT_FORMAT
      pdf_template       VARCHAR2(200),                             -- template key/name (file or DCT_DOCUMENTS)
      xlsx_template      VARCHAR2(200),
      email_subject_tpl  VARCHAR2(400),                             -- Jinja2 / #PLACEHOLDER# subject
      email_body_tpl     CLOB,                                      -- Jinja2 / #PLACEHOLDER# HTML body
      params_json        CLOB,                                      -- default params {"period":"05-2026"}
      enabled            CHAR(1)        DEFAULT 'Y' NOT NULL,
      created_by         VARCHAR2(100),
      created_at         TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
      updated_by         VARCHAR2(100),
      updated_at         TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
      CONSTRAINT pk_dct_rpt_def       PRIMARY KEY (report_code),
      CONSTRAINT ck_dct_rpt_def_enab  CHECK (enabled IN ('Y','N')),
      CONSTRAINT ck_dct_rpt_def_pjson CHECK (params_json IS NULL OR params_json IS JSON)
    )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

PROMPT === 2. DCT_RPT_SCHEDULE ===
BEGIN
  EXECUTE IMMEDIATE q'[
    CREATE TABLE prod.dct_rpt_schedule (
      schedule_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      report_code      VARCHAR2(60)  NOT NULL,
      schedule_name    VARCHAR2(80),
      repeat_interval  VARCHAR2(400) NOT NULL,                  -- DBMS_SCHEDULER calendar string
      timezone         VARCHAR2(60)  DEFAULT 'Asia/Dubai' NOT NULL,
      criteria_json    CLOB,                                    -- run-time params/filters
      enabled          CHAR(1)       DEFAULT 'Y' NOT NULL,
      last_run_at      TIMESTAMP,
      created_by       VARCHAR2(100),
      created_at       TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
      updated_by       VARCHAR2(100),
      updated_at       TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
      CONSTRAINT fk_dct_rpt_sch_def  FOREIGN KEY (report_code)
        REFERENCES prod.dct_rpt_definition (report_code) ON DELETE CASCADE,
      CONSTRAINT ck_dct_rpt_sch_enab  CHECK (enabled IN ('Y','N')),
      CONSTRAINT ck_dct_rpt_sch_cjson CHECK (criteria_json IS NULL OR criteria_json IS JSON)
    )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

PROMPT === 3. DCT_RPT_RECIPIENT ===
BEGIN
  EXECUTE IMMEDIATE q'[
    CREATE TABLE prod.dct_rpt_recipient (
      recipient_id     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      report_code      VARCHAR2(60)  NOT NULL,
      recipient_type   VARCHAR2(20)  NOT NULL,                  -- lookup RPT_RECIP_TYPE: USER|ROLE|ORG|EMAIL|SELF
      recipient_ref    VARCHAR2(320),                           -- user_id|role_code|org_id|email; NULL for SELF
      channel          VARCHAR2(20)  DEFAULT 'EMAIL' NOT NULL,  -- lookup RPT_CHANNEL: EMAIL|INAPP|PUSH|WEBHOOK
      enabled          CHAR(1)       DEFAULT 'Y' NOT NULL,
      created_by       VARCHAR2(100),
      created_at       TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
      updated_by       VARCHAR2(100),
      updated_at       TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
      CONSTRAINT fk_dct_rpt_rcp_def  FOREIGN KEY (report_code)
        REFERENCES prod.dct_rpt_definition (report_code) ON DELETE CASCADE,
      CONSTRAINT ck_dct_rpt_rcp_enab CHECK (enabled IN ('Y','N'))
    )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

PROMPT === 4. DCT_RPT_RUN ===
BEGIN
  EXECUTE IMMEDIATE q'[
    CREATE TABLE prod.dct_rpt_run (
      run_id           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      report_code      VARCHAR2(60)  NOT NULL,                  -- no FK: run history survives definition delete
      trigger_source   VARCHAR2(20)  DEFAULT 'ONDEMAND' NOT NULL, -- lookup RPT_TRIGGER: SCHEDULE|ONDEMAND
      engine           VARCHAR2(20)  NOT NULL,                  -- snapshot of definition.engine
      status           VARCHAR2(20)  DEFAULT 'QUEUED' NOT NULL, -- lookup RPT_RUN_STATUS: QUEUED|RUNNING|SUCCESS|FAILED
      params_json      CLOB,
      formats          VARCHAR2(40),                            -- formats requested for this run
      row_count        NUMBER,
      requested_by     VARCHAR2(100),                           -- username (SELF resolution)
      worker_id        VARCHAR2(100),
      attempts         NUMBER        DEFAULT 0 NOT NULL,
      started_at       TIMESTAMP,
      finished_at      TIMESTAMP,
      error_msg        CLOB,
      created_at       TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
      CONSTRAINT ck_dct_rpt_run_pjson CHECK (params_json IS NULL OR params_json IS JSON)
    )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX prod.ix_dct_rpt_run_rep ON prod.dct_rpt_run (report_code, created_at DESC)';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX prod.ix_dct_rpt_run_claim ON prod.dct_rpt_run (status, engine, run_id)';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

PROMPT === 5. DCT_RPT_OUTPUT ===
BEGIN
  EXECUTE IMMEDIATE q'[
    CREATE TABLE prod.dct_rpt_output (
      output_id        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      run_id           NUMBER        NOT NULL,
      format           VARCHAR2(10)  NOT NULL,                  -- PDF|XLSX|CSV
      file_name        VARCHAR2(260),
      mime_type        VARCHAR2(120),
      file_bytes       NUMBER,
      sha256           VARCHAR2(64),
      file_blob        BLOB,
      created_at       TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
      CONSTRAINT fk_dct_rpt_out_run  FOREIGN KEY (run_id)
        REFERENCES prod.dct_rpt_run (run_id) ON DELETE CASCADE
    )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX prod.ix_dct_rpt_out_run ON prod.dct_rpt_output (run_id)';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

PROMPT === 6. DCT_RPT_DELIVERY ===
BEGIN
  EXECUTE IMMEDIATE q'[
    CREATE TABLE prod.dct_rpt_delivery (
      delivery_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      run_id           NUMBER        NOT NULL,
      recipient        VARCHAR2(320),                           -- resolved email / user / device
      channel          VARCHAR2(20)  DEFAULT 'EMAIL' NOT NULL,
      status           VARCHAR2(20)  DEFAULT 'PENDING' NOT NULL,-- lookup RPT_DELIVERY_STATUS: PENDING|SENT|FAILED|SKIPPED
      sent_at          TIMESTAMP,
      error_msg        VARCHAR2(2000),
      created_at       TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
      CONSTRAINT fk_dct_rpt_del_run  FOREIGN KEY (run_id)
        REFERENCES prod.dct_rpt_run (run_id) ON DELETE CASCADE
    )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX prod.ix_dct_rpt_del_run ON prod.dct_rpt_delivery (run_id)';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

PROMPT === 7. DCT_RPT_CONFIG  (UI-editable runtime / SMTP -- secrets stay in env) ===
BEGIN
  EXECUTE IMMEDIATE q'[
    CREATE TABLE prod.dct_rpt_config (
      config_key    VARCHAR2(60)  NOT NULL,
      config_value  VARCHAR2(2000),
      value_type    VARCHAR2(20)  DEFAULT 'STRING' NOT NULL,   -- STRING|NUMBER|ENUM|BOOL
      is_secret     CHAR(1)       DEFAULT 'N' NOT NULL,
      enum_values   VARCHAR2(400),                             -- CSV of allowed values for ENUM
      description   VARCHAR2(400),
      display_order NUMBER        DEFAULT 100 NOT NULL,
      updated_by    VARCHAR2(100),
      updated_at    TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
      CONSTRAINT pk_dct_rpt_config PRIMARY KEY (config_key),
      CONSTRAINT ck_dct_rpt_cfg_secret CHECK (is_secret IN ('Y','N')),
      CONSTRAINT ck_dct_rpt_cfg_type   CHECK (value_type IN ('STRING','NUMBER','ENUM','BOOL'))
    )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

PROMPT === 8. ADMIN synonyms (fresh-session rule applies) ===
CREATE OR REPLACE SYNONYM dct_rpt_definition FOR prod.dct_rpt_definition;
CREATE OR REPLACE SYNONYM dct_rpt_schedule   FOR prod.dct_rpt_schedule;
CREATE OR REPLACE SYNONYM dct_rpt_recipient  FOR prod.dct_rpt_recipient;
CREATE OR REPLACE SYNONYM dct_rpt_run        FOR prod.dct_rpt_run;
CREATE OR REPLACE SYNONYM dct_rpt_output     FOR prod.dct_rpt_output;
CREATE OR REPLACE SYNONYM dct_rpt_delivery   FOR prod.dct_rpt_delivery;
CREATE OR REPLACE SYNONYM dct_rpt_config     FOR prod.dct_rpt_config;

PROMPT === 9. Seed DCT_RPT_CONFIG defaults (MERGE -- never clobber UI edits) ===
DECLARE
  PROCEDURE c(p_key VARCHAR2, p_val VARCHAR2, p_type VARCHAR2, p_secret VARCHAR2,
              p_enum VARCHAR2, p_desc VARCHAR2, p_ord NUMBER) IS
  BEGIN
    MERGE INTO prod.dct_rpt_config t
    USING (SELECT p_key AS k FROM dual) s ON (t.config_key = s.k)
    WHEN NOT MATCHED THEN INSERT (config_key, config_value, value_type, is_secret, enum_values, description, display_order)
      VALUES (p_key, p_val, p_type, p_secret, p_enum, p_desc, p_ord);
  END;
BEGIN
  c('EMAIL_ENABLED',  'N',                 'BOOL',   'N', NULL, 'Master switch -- send report emails (Y) or generate-only (N)', 10);
  c('SMTP_HOST',      'smtp.mail.yahoo.com','STRING','N', NULL, 'SMTP relay host (pilot: your mailbox provider; prod: OCI Email Delivery)', 20);
  c('SMTP_PORT',      '587',               'NUMBER', 'N', NULL, 'SMTP port (587 STARTTLS / 465 SSL)', 30);
  c('SMTP_TLS',       'STARTTLS',          'ENUM',   'N', 'STARTTLS,SSL,NONE', 'Transport security', 40);
  c('SMTP_USER',      '',                  'STRING', 'N', NULL, 'SMTP username (the PASSWORD stays in env.ps1 / secret store, never here)', 50);
  c('SMTP_FROM',      'no-reply@dct.gov.ae','STRING','N', NULL, 'From address shown on report emails', 60);
  c('SMTP_FROM_NAME', 'i-Finance Reporting','STRING','N', NULL, 'From display name', 70);
  c('WORKER_IDLE_SEC','20',                'NUMBER', 'N', NULL, 'Seconds a --forever worker sleeps when the queue is empty', 80);
  c('LEASE_MINUTES',  '20',                'NUMBER', 'N', NULL, 'Minutes before a stuck RUNNING run is reclaimed by another worker', 90);
  c('MAX_ATTEMPTS',   '3',                 'NUMBER', 'N', NULL, 'Retry attempts before a run is marked FAILED', 100);
  c('PDF_RENDERER',   'PLAYWRIGHT',        'ENUM',   'N', 'PLAYWRIGHT,WEASYPRINT', 'HTML->PDF engine (Playwright Chromium reuses the ATD dep)', 110);
  c('OUTPUT_RETAIN_DAYS','90',             'NUMBER', 'N', NULL, 'Days to retain generated output BLOBs before purge (0 = keep)', 120);
  COMMIT;
END;
/

PROMPT ============================================================
PROMPT  01_rpt_ddl.sql complete.
PROMPT  7 DCT_RPT_* tables + indexes + ADMIN synonyms + config seed.
PROMPT ============================================================
