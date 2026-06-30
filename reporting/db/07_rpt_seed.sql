-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 07 pilot seed
-- File   : reporting/db/07_rpt_seed.sql
-- Run as : sql -name prod_mcp
-- Purpose: bootstrap the first pilot report -- GL Budget vs Actual (PYTHON engine,
--          PDF + XLSX) -- plus a DISABLED sample monthly schedule and a SELF email
--          recipient, so an on-demand run can be tested end-to-end. The rest is
--          managed from the Admin Reports UI (Phase 2).
-- Idempotent: MERGE (never clobbers later UI edits).
-- CRLF + UTF-8 no BOM.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
  l_src   CLOB;
  l_body  CLOB;
BEGIN
  l_src :=
    'SELECT period_name, sector_name, program_name, account_code, account_desc, '||
    '       budget_ytd, encumbrance_ytd, gl_actual_ytd, ap_direct_actual_ytd, '||
    '       grn_actual_ytd, funds_available_ytd, variance_ytd '||
    'FROM prod.dct_budget_actual_period_v '||
    'WHERE period_name = NVL(:period, (SELECT MAX(period_name) FROM prod.dct_budget_actual_period_v)) '||
    'ORDER BY sector_name, program_name, account_code';

  l_body :=
    '<p>Dear {{ recipient_name }},</p>'||
    '<p>The <strong>Budget vs Actual</strong> report for period <strong>{{ period }}</strong> '||
    'is attached (PDF + Excel). It covers {{ row_count }} GL combinations.</p>'||
    '<p>Generated {{ generated_at }} by i-Finance Reporting.</p>';

  -- definition
  MERGE INTO prod.dct_rpt_definition t
  USING (SELECT 'GL_BUDGET_ACTUAL' AS report_code FROM dual) s
  ON (t.report_code = s.report_code)
  WHEN NOT MATCHED THEN INSERT
    (report_code, name_en, name_ar, description, category, source_type, source_ref, engine,
     default_formats, email_subject_tpl, email_body_tpl, params_json, enabled, created_by, updated_by)
  VALUES
    ('GL_BUDGET_ACTUAL',
     'Budget vs Actual (YTD)',
     'الموازنة مقابل الفعلي',
     'Per GL combination x period: budget, encumbrance, GL/AP/GRN actuals, funds available and variance (YTD).',
     'General Ledger', 'SQL', l_src, 'PYTHON', 'PDF,XLSX',
     'Budget vs Actual - {{ period }}',
     l_body,
     '{"period":null}',
     'Y', 'SETUP', 'SETUP');

  -- sample monthly schedule (DISABLED -- enable + edit in the UI to activate)
  MERGE INTO prod.dct_rpt_schedule t
  USING (SELECT 'GL_BUDGET_ACTUAL' AS rc, 'Monthly (3rd, 07:00)' AS nm FROM dual) s
  ON (t.report_code = s.rc AND t.schedule_name = s.nm)
  WHEN NOT MATCHED THEN INSERT
    (report_code, schedule_name, repeat_interval, timezone, criteria_json, enabled, created_by, updated_by)
  VALUES
    ('GL_BUDGET_ACTUAL', 'Monthly (3rd, 07:00)',
     'FREQ=MONTHLY;BYMONTHDAY=3;BYHOUR=7;BYMINUTE=0', 'Asia/Dubai', '{"period":null}', 'N', 'SETUP', 'SETUP');

  -- SELF recipient (the requester gets it by email; no-op while EMAIL_ENABLED=N)
  MERGE INTO prod.dct_rpt_recipient t
  USING (SELECT 'GL_BUDGET_ACTUAL' AS rc, 'SELF' AS rt FROM dual) s
  ON (t.report_code = s.rc AND t.recipient_type = s.rt)
  WHEN NOT MATCHED THEN INSERT
    (report_code, recipient_type, recipient_ref, channel, enabled, created_by, updated_by)
  VALUES
    ('GL_BUDGET_ACTUAL', 'SELF', NULL, 'EMAIL', 'Y', 'SETUP', 'SETUP');

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Pilot report GL_BUDGET_ACTUAL seeded (definition + sample schedule + SELF recipient).');
END;
/

PROMPT 07_rpt_seed.sql complete.
