-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 32 GL Balance YoY Register (Excel)
-- File   : reporting/db/32_rpt_ebs_yoy_register.sql
-- Seeds  : EBS_GL_YOY_REGISTER -- year-over-year YTD GL balance comparison on
--          the FUSION account basis (user decision 2026-08-02): EBS years
--          (<= 2025) read the STORED YTD measures from
--          DCT_EBS_BALANCE_MAPPED_V (Budget/Encumbrance/Actual YTD carry
--          opening balances) translated forward through the ACCOUNT map;
--          Fusion years (>= 2026) read DCT_GL_DOF_FACT_V summed over periods
--          <= the cutoff month (encumbrance = commitments + obligations +
--          other encumbrances). EBS YTD-at-cutoff = the 'MM-YYYY' period
--          SLICE; Full Year (month=0) = the '13-YYYY' adjustment slice when
--          present, else '12-YYYY'. Section SQLs are in LOCK-STEP with the
--          GL/db/18 /gl/ebs-balances/yoy handler.
--          Sheets:
--            1. YoY Comparison  (long format: account x year with the three
--               YTD measures + prior-year actual + change -- pivot-ready)
--            2. Year Coverage   (per-year account count + measure totals at
--               the same slice, so sheet 1 reconciles visibly)
-- Params : years (required, pipe list e.g. 2026|2025|2024, max 6);
--          month (0 = full year, 1-12 = YTD cutoff); search / atype /
--          chapter optional.
-- Deploy : SQLcl (sql -name prod, JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8) or
--          python-oracledb. Idempotent; count-then-insert/update (no MERGE).
-- CRLF-safe. Zero blank lines inside statements.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. EBS_GL_YOY_REGISTER definition (MULTI, 2 sections, XLSX) ===
DECLARE
  l_ebs  VARCHAR2(32767);
  l_fus  VARCHAR2(32767);
  l_yoy  VARCHAR2(32767);
  l_cov  VARCHAR2(32767);
  l_src  CLOB;
  l_body CLOB;
  l_spec CLOB;
  l_desc VARCHAR2(1000);
  l_n    NUMBER;
BEGIN
  l_ebs := q'!SELECT e.fusion_account AS account_code, MAX(e.fusion_account_desc) AS account_desc, MAX(e.account_type) AS account_type, e.period_year AS yr, SUM(e.actual_ytd) AS actual_ytd, SUM(e.budget_ytd) AS budget_ytd, SUM(e.encumbrance_ytd) AS encumbrance_ytd FROM prod.dct_ebs_balance_mapped_v e JOIN (SELECT period_year, MAX(CASE WHEN SUBSTR(accounting_period,1,2) = '13' THEN '13' END) AS m13 FROM prod.dct_ebs_gl_balance GROUP BY period_year) fy ON fy.period_year = e.period_year WHERE e.account_mapped = 'Y' AND e.period_year <= 2025 AND INSTR('|'||[COLON]years||'|', '|'||TO_CHAR(e.period_year)||'|') > 0 AND SUBSTR(e.accounting_period,1,2) = CASE WHEN NVL(TO_NUMBER([COLON]month),0) = 0 THEN NVL(fy.m13, '12') ELSE LPAD(NVL(TO_NUMBER([COLON]month),0),2,'0') END AND INSTR('|'||NVL([COLON]bg,'1')||'|', '|'||e.budget_code||'|') > 0 AND ([COLON]chapter IS NULL OR e.chapter = [COLON]chapter) GROUP BY e.period_year, e.fusion_account HAVING SUM(ABS(e.actual_ytd)) + SUM(ABS(e.budget_ytd)) + SUM(ABS(e.encumbrance_ytd)) > 0.005!';
  l_fus := q'!SELECT f.account_code, MAX(f.account_desc) AS account_desc, MAX(f.account_type) AS account_type, f.period_year AS yr, SUM(f.expenditures) AS actual_ytd, SUM(f.total_budget) AS budget_ytd, SUM(f.encumbrance) AS encumbrance_ytd FROM prod.dct_gl_dof_fact_v f WHERE f.period_year >= 2026 AND INSTR('|'||[COLON]years||'|', '|'||TO_CHAR(f.period_year)||'|') > 0 AND (NVL(TO_NUMBER([COLON]month),0) = 0 OR f.period_month <= NVL(TO_NUMBER([COLON]month),0)) AND ([COLON]chapter IS NULL OR f.chapter_name = [COLON]chapter) GROUP BY f.period_year, f.account_code HAVING SUM(ABS(f.expenditures)) + SUM(ABS(f.total_budget)) + SUM(ABS(f.encumbrance)) > 0.005!';
  l_yoy := q'!SELECT account_code, account_desc, account_type, yr AS fiscal_year, actual_ytd, budget_ytd, encumbrance_ytd, LAG(actual_ytd) OVER (PARTITION BY account_code ORDER BY yr) AS prior_year_actual, actual_ytd - LAG(actual_ytd) OVER (PARTITION BY account_code ORDER BY yr) AS actual_change FROM (!'
        || l_ebs || ' UNION ALL ' || l_fus
        || q'!) WHERE ([COLON]search IS NULL OR UPPER(account_code||' '||NVL(account_desc,' ')) LIKE '%'||UPPER([COLON]search)||'%') AND ([COLON]atype IS NULL OR account_type = [COLON]atype) ORDER BY account_code, yr DESC!';
  l_cov := q'!SELECT yr AS fiscal_year, COUNT(*) AS accounts, SUM(actual_ytd) AS actual_ytd_total, SUM(budget_ytd) AS budget_ytd_total, SUM(encumbrance_ytd) AS encumbrance_ytd_total FROM (!'
        || l_ebs || ' UNION ALL ' || l_fus
        || q'!) WHERE ([COLON]search IS NULL OR UPPER(account_code||' '||NVL(account_desc,' ')) LIKE '%'||UPPER([COLON]search)||'%') AND ([COLON]atype IS NULL OR account_type = [COLON]atype) GROUP BY yr ORDER BY yr DESC!';
  l_src := '{"required":["years"],'
        || '"sections":['
        || '{"key":"yoy","title":"YoY Comparison","layout":"table","sql":"' || l_yoy || '"}' || ','
        || '{"key":"coverage","title":"Year Coverage","layout":"table","sql":"' || l_cov || '"}'
        || ']}';
  l_src := REPLACE(l_src, '[COLON]', CHR(58));
  l_spec := '{'
    || '"years":{"label":"Fiscal years","label_ar":"السنوات المالية","hint":"Pipe list, e.g. 2026|2025|2024 (max 6)","required":true},'
    || '"month":{"label":"YTD cutoff month","label_ar":"شهر الرصيد التراكمي","hint":"0 = full year; 1-12 = YTD as of that month","required":false},'
    || '"bg":{"label":"Budget groups","label_ar":"مجموعات الميزانية","hint":"Default 1 (Current operations); pipe list may add 2 (Capital) / 8 (Accrual), e.g. 1|2|8","required":false},'
    || '"search":{"label":"Account search","label_ar":"بحث الحساب","hint":"Fusion account code or description","required":false},'
    || '"atype":{"label":"Account type","label_ar":"نوع الحساب","hint":"e.g. Expense, Assets","required":false,'
    || '"lov_sql":"SELECT DISTINCT account_type FROM prod.dct_gl_coa_snap WHERE account_type IS NOT NULL ORDER BY 1"},'
    || '"chapter":{"label":"Chapter","label_ar":"الباب","hint":"Chapter classification of the appropriation","required":false}'
    || '}';
  l_body :=
    '<p>Dear {{ recipient_name }},</p>'||
    '<p>The <strong>GL Balance Year-over-Year Register</strong> (Excel) for years '||
    '<strong>{{ params.years }}</strong> is attached: YTD Actual, Budget and Encumbrance per '||
    'Fusion GL account across the selected years (legacy EBS years translated through the '||
    'account mapping), with the prior-year actual and change per row ({{ row_count }} rows).</p>'||
    '<p>Prepared by Financial Planning and Budgeting, Finance Department. '||
    'Generated {{ generated_at }} by i-Finance Reporting.</p>';
  l_desc := 'Year-over-year YTD GL balance comparison on the Fusion account basis: legacy EBS years (up to 2025) read the stored YTD measures translated forward through the COA account mapping; Fusion years (2026 onward) read the GL balances at the same cutoff. Long-format sheet (account x year with Actual/Budget/Encumbrance YTD + prior-year actual + change) plus a per-year coverage sheet. Parameters: years (required pipe list); month 0=full year or 1-12 YTD cutoff; search, account type, chapter optional.';
  SELECT COUNT(*) INTO l_n FROM prod.dct_rpt_definition
   WHERE report_code = 'EBS_GL_YOY_REGISTER';
  IF l_n = 0 THEN
    INSERT INTO prod.dct_rpt_definition
      (report_code, name_en, name_ar, description, category, source_type, source_ref, engine,
       default_formats, email_subject_tpl, email_body_tpl, params_json, param_spec_json,
       enabled, created_by, updated_by)
    VALUES
      ('EBS_GL_YOY_REGISTER',
       'GL Balance YoY Register (Excel)',
       UNISTR('\0633\062C\0644 \0645\0642\0627\0631\0646\0629 \0623\0631\0635\062F\0629 \0627\0644\0623\0633\062A\0627\0630 \0627\0644\0639\0627\0645 \0633\0646\0648\064A\0627'),
       l_desc,
       'General Ledger', 'MULTI', l_src, 'PYTHON', 'XLSX',
       'GL Balance YoY Register - {{ params.years }}',
       l_body,
       '{"years":null,"month":"0","bg":"1","search":null,"atype":null,"chapter":null}',
       l_spec,
       'Y', 'SETUP', 'SETUP');
  ELSE
    UPDATE prod.dct_rpt_definition SET
       source_type       = 'MULTI',
       description       = l_desc,
       source_ref        = l_src,
       engine            = 'PYTHON',
       default_formats   = 'XLSX',
       email_subject_tpl = 'GL Balance YoY Register - {{ params.years }}',
       email_body_tpl    = l_body,
       params_json       = '{"years":null,"month":"0","bg":"1","search":null,"atype":null,"chapter":null}',
       param_spec_json   = l_spec,
       updated_by        = 'SETUP',
       updated_at        = SYSTIMESTAMP
     WHERE report_code = 'EBS_GL_YOY_REGISTER';
  END IF;
  SELECT COUNT(*) INTO l_n FROM prod.dct_rpt_recipient
   WHERE report_code = 'EBS_GL_YOY_REGISTER' AND recipient_type = 'SELF';
  IF l_n = 0 THEN
    INSERT INTO prod.dct_rpt_recipient
      (report_code, recipient_type, recipient_ref, channel, enabled, created_by, updated_by)
    VALUES
      ('EBS_GL_YOY_REGISTER', 'SELF', NULL, 'EMAIL', 'Y', 'SETUP', 'SETUP');
  END IF;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('EBS_GL_YOY_REGISTER seeded (definition + SELF recipient).');
END;
/

PROMPT === 2. Verify ===
SELECT report_code, source_type, engine, default_formats,
       CASE WHEN source_ref IS JSON THEN 'SRC OK' ELSE 'SRC BAD' END AS src_ok,
       CASE WHEN param_spec_json IS JSON THEN 'SPEC OK' ELSE 'SPEC BAD' END AS spec_ok
FROM prod.dct_rpt_definition
WHERE report_code = 'EBS_GL_YOY_REGISTER';

PROMPT ============================================================
PROMPT  32_rpt_ebs_yoy_register.sql complete (EBS_GL_YOY_REGISTER).
PROMPT ============================================================
