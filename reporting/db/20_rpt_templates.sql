-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 20 report templates (docxtpl GUI-editable)
-- File   : reporting/db/20_rpt_templates.sql
-- Schema : PROD table + ADMIN synonym
-- Run as : sql -name prod_mcp   (FRESH session -- synonym fresh-session rule)
-- Purpose: DB-stored report templates so layouts are managed from the BI app
--          with no worker redeploy. A row's TEMPLATE_NAME is the exact value a
--          definition stores in DCT_RPT_DEFINITION.PDF_TEMPLATE. Kind derives
--          from the name extension -- .docx (Word / docxtpl -> LibreOffice PDF)
--          or .j2 (Jinja2 HTML -> Chromium PDF). The Python engine resolves
--          templates DB-first with a bundled-file fallback.
--          Also seeds config key TEMPLATE_MAX_MB (upload size guard).
-- Idempotent: guarded ORA-00955 + NOT-EXISTS seed; safe to re-run.
-- CRLF + UTF-8 no BOM. No blank lines inside statements.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. DCT_RPT_TEMPLATE table ===
BEGIN
  EXECUTE IMMEDIATE q'[
    CREATE TABLE prod.dct_rpt_template (
      template_name  VARCHAR2(200)  NOT NULL,
      description    VARCHAR2(400),
      mime_type      VARCHAR2(120),
      content        BLOB           NOT NULL,
      file_size      NUMBER,
      enabled        CHAR(1)        DEFAULT 'Y' NOT NULL,
      created_by     VARCHAR2(100),
      created_at     TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
      updated_by     VARCHAR2(100),
      updated_at     TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
      CONSTRAINT pk_dct_rpt_tpl      PRIMARY KEY (template_name),
      CONSTRAINT ck_dct_rpt_tpl_enab CHECK (enabled IN ('Y','N')),
      CONSTRAINT ck_dct_rpt_tpl_ext  CHECK (
        LOWER(template_name) LIKE '%.docx' OR LOWER(template_name) LIKE '%.j2')
    )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

PROMPT === 2. ADMIN synonym (fresh-session rule applies) ===
CREATE OR REPLACE SYNONYM dct_rpt_template FOR prod.dct_rpt_template;

PROMPT === 3. Seed TEMPLATE_MAX_MB config key (never clobbers UI edits) ===
INSERT INTO prod.dct_rpt_config
  (config_key, config_value, value_type, is_secret, enum_values, description, display_order)
SELECT 'TEMPLATE_MAX_MB', '10', 'NUMBER', 'N', NULL,
       'Max upload size (MB) for a report template file (.docx / .j2)', 125
FROM dual
WHERE NOT EXISTS (
  SELECT 1 FROM prod.dct_rpt_config WHERE config_key = 'TEMPLATE_MAX_MB');
COMMIT;

PROMPT === 3b. Seed DOCX_PDF_TIMEOUT_SEC config key ===
INSERT INTO prod.dct_rpt_config
  (config_key, config_value, value_type, is_secret, enum_values, description, display_order)
SELECT 'DOCX_PDF_TIMEOUT_SEC', '480', 'NUMBER', 'N', NULL,
       'Seconds allowed for LibreOffice to convert a rendered Word template to PDF (large tables are slow; prefer .j2 templates for big tabular reports)', 126
FROM dual
WHERE NOT EXISTS (
  SELECT 1 FROM prod.dct_rpt_config WHERE config_key = 'DOCX_PDF_TIMEOUT_SEC');
COMMIT;

PROMPT === 4. Verify ===
SELECT COUNT(*) AS tpl_table FROM all_tables
WHERE owner = 'PROD' AND table_name = 'DCT_RPT_TEMPLATE';
SELECT COUNT(*) AS tpl_cfg FROM prod.dct_rpt_config
WHERE config_key = 'TEMPLATE_MAX_MB';

PROMPT ============================================================
PROMPT  20_rpt_templates.sql complete.
PROMPT  DCT_RPT_TEMPLATE + ADMIN synonym + TEMPLATE_MAX_MB config.
PROMPT ============================================================
