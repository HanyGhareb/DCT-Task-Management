-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 30 EBS GL Balance Register (Excel)
-- File   : reporting/db/30_rpt_ebs_balance_register.sql
-- Seeds  : EBS_GL_BALANCE_REGISTER -- the FIRST prior-year (legacy EBS era,
--          <= 31-Dec-2025) report: every EBS historical balance line
--          (db/v2/110 DCT_EBS_GL_BALANCE) translated to the Fusion dimension
--          world through DCT_EBS_BALANCE_MAPPED_V (account via the ACCOUNT
--          map, appropriation via the APPROPRIATION/Future1 map, chapter via
--          the standing chapter classification, sector via the cost-centre
--          snapshot). XLSX-only (build_xlsx_multi = one styled sheet per
--          section), run from the GL app Legacy (EBS) page via the GL/db/16
--          bridge (/gl/ebs-balances/register).
--          Sheets:
--            1. EBS GL Balance Lines  (per combination x period, PTD + YTD)
--            2. Unmapped Coverage     (EBS accounts / Future1 values with no
--                                      active mapping -- nothing is silently
--                                      dropped, coverage is measurable)
-- Params : year (required, from the loaded balance years); period / account
--          (EBS or Fusion) / chapter / search optional.
-- Deploy : python-oracledb from the dev VM (MERGE-bearing -- Linux SQLcl
--          swallows these blocks). Idempotent.
-- CRLF + UTF-8 no BOM. Zero blank lines inside statements.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. EBS_GL_BALANCE_REGISTER definition (MULTI, 2 sections, XLSX) ===
DECLARE
  l_ln   VARCHAR2(4000);
  l_cov  VARCHAR2(2000);
  l_src  CLOB;
  l_body CLOB;
  l_spec CLOB;
BEGIN
  -- sheet 1: the mapped balance lines. YTD = running PTD per EBS combination
  -- within the year, ordered by period.
  l_ln := q'!SELECT ebs_combination, accounting_period, entity_code, cost_center_code, cost_center_desc, sector, budget_code, account_code AS ebs_account, fusion_account, fusion_account_desc, account_type, activity_code, future1_code AS ebs_future1, fusion_appropriation, fusion_appropriation_desc, chapter, future2_code, ptd_amount, SUM(ptd_amount) OVER (PARTITION BY ebs_combination ORDER BY period_date NULLS FIRST, accounting_period) AS ytd_amount, account_mapped, appr_mapped FROM prod.dct_ebs_balance_mapped_v WHERE period_year = [COLON]year AND ([COLON]period IS NULL OR accounting_period = [COLON]period) AND ([COLON]account IS NULL OR account_code = [COLON]account OR fusion_account = [COLON]account) AND ([COLON]chapter IS NULL OR chapter = [COLON]chapter) AND ([COLON]search IS NULL OR UPPER(ebs_combination||' '||NVL(fusion_account,' ')||' '||NVL(fusion_account_desc,' ')||' '||NVL(cost_center_desc,' ')||' '||NVL(sector,' ')) LIKE '%'||UPPER([COLON]search)||'%') ORDER BY account_code, ebs_combination, period_date NULLS FIRST, accounting_period!';
  -- sheet 2: unmapped coverage (per segment, ordered by absolute amount)
  l_cov := q'!SELECT segment, ebs_value, line_count, ptd_total FROM (SELECT 'ACCOUNT' AS segment, account_code AS ebs_value, COUNT(*) AS line_count, SUM(ptd_amount) AS ptd_total FROM prod.dct_ebs_balance_mapped_v WHERE period_year = [COLON]year AND account_mapped = 'N' GROUP BY account_code UNION ALL SELECT 'FUTURE1', future1_code, COUNT(*), SUM(ptd_amount) FROM prod.dct_ebs_balance_mapped_v WHERE period_year = [COLON]year AND appr_mapped = 'N' GROUP BY future1_code) ORDER BY segment, ABS(ptd_total) DESC!';
  l_src := '{"required":["year"],'
        || '"sections":['
        || '{"key":"ebs_lines","title":"EBS GL Balance Lines","layout":"table","sql":"' || l_ln || '"}' || ','
        || '{"key":"coverage","title":"Unmapped Coverage","layout":"table","sql":"' || l_cov || '"}'
        || ']}';
  l_src := REPLACE(l_src, '[COLON]', CHR(58));
  l_spec := '{'
    || '"year":{"label":"Fiscal year","label_ar":"السنة المالية","hint":"EBS fiscal year (legacy era, up to 2025)","required":true,'
    || '"lov_sql":"SELECT DISTINCT period_year FROM prod.dct_ebs_balance_mapped_v WHERE period_year IS NOT NULL ORDER BY 1 DESC"},'
    || '"period":{"label":"Accounting period","label_ar":"الفترة المحاسبية","hint":"Exact EBS period name as loaded (e.g. JAN-25)","required":false},'
    || '"account":{"label":"Account","label_ar":"الحساب","hint":"EBS or Fusion account code","required":false},'
    || '"chapter":{"label":"Chapter","label_ar":"الباب","hint":"Chapter classification of the mapped appropriation","required":false},'
    || '"search":{"label":"Search","label_ar":"بحث","hint":"Combination, account, cost centre or sector text","required":false}'
    || '}';
  l_body :=
    '<p>Dear {{ recipient_name }},</p>'||
    '<p>The <strong>EBS GL Balance Register</strong> (Excel) for fiscal year '||
    '<strong>{{ params.year }}</strong> is attached: every legacy EBS balance line translated to '||
    'the Fusion chart (account, appropriation, chapter, sector) with PTD and YTD amounts, plus '||
    'the unmapped-coverage annex ({{ row_count }} lines in total).</p>'||
    '<p>Prepared by Financial Planning and Budgeting, Finance Department. '||
    'Generated {{ generated_at }} by i-Finance Reporting.</p>';
  MERGE INTO prod.dct_rpt_definition t
  USING (SELECT 'EBS_GL_BALANCE_REGISTER' AS report_code FROM dual) s
  ON (t.report_code = s.report_code)
  WHEN NOT MATCHED THEN INSERT
    (report_code, name_en, name_ar, description, category, source_type, source_ref, engine,
     default_formats, email_subject_tpl, email_body_tpl, params_json, param_spec_json,
     enabled, created_by, updated_by)
  VALUES
    ('EBS_GL_BALANCE_REGISTER',
     'EBS GL Balance Register (Excel)',
     UNISTR('\0633\062C\0644 \0623\0631\0635\062F\0629 \0627\0644\0646\0638\0627\0645 \0627\0644\0633\0627\0628\0642 (EBS)'),
     'Prior-year (legacy EBS era) balance register: every EBS historical balance line -- full 7-segment EBS combination per accounting period with PTD and running YTD -- translated to the Fusion dimension world via the COA account mapping (EBS account to Fusion account) and the Future1 to Appropriation mapping (chapter and sector attached). Sheet 2 lists the EBS values with no active mapping so coverage is always visible. Parameters: year (required); period, account (EBS or Fusion), chapter, search (optional).',
     'General Ledger', 'MULTI', l_src, 'PYTHON', 'XLSX',
     'EBS GL Balance Register - {{ params.year }}',
     l_body,
     '{"year":null,"period":null,"account":null,"chapter":null,"search":null}',
     l_spec,
     'Y', 'SETUP', 'SETUP')
  WHEN MATCHED THEN UPDATE SET
     t.source_type       = 'MULTI',
     t.description       = 'Prior-year (legacy EBS era) balance register: every EBS historical balance line -- full 7-segment EBS combination per accounting period with PTD and running YTD -- translated to the Fusion dimension world via the COA account mapping (EBS account to Fusion account) and the Future1 to Appropriation mapping (chapter and sector attached). Sheet 2 lists the EBS values with no active mapping so coverage is always visible. Parameters: year (required); period, account (EBS or Fusion), chapter, search (optional).',
     t.source_ref        = l_src,
     t.engine            = 'PYTHON',
     t.default_formats   = 'XLSX',
     t.email_subject_tpl = 'EBS GL Balance Register - {{ params.year }}',
     t.email_body_tpl    = l_body,
     t.params_json       = '{"year":null,"period":null,"account":null,"chapter":null,"search":null}',
     t.param_spec_json   = l_spec,
     t.updated_by        = 'SETUP',
     t.updated_at        = SYSTIMESTAMP;
  MERGE INTO prod.dct_rpt_recipient t
  USING (SELECT 'EBS_GL_BALANCE_REGISTER' AS rc, 'SELF' AS rt FROM dual) s
  ON (t.report_code = s.rc AND t.recipient_type = s.rt)
  WHEN NOT MATCHED THEN INSERT
    (report_code, recipient_type, recipient_ref, channel, enabled, created_by, updated_by)
  VALUES
    ('EBS_GL_BALANCE_REGISTER', 'SELF', NULL, 'EMAIL', 'Y', 'SETUP', 'SETUP');
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('EBS_GL_BALANCE_REGISTER seeded (definition + SELF recipient).');
END;
/

PROMPT === 2. Verify ===
SELECT report_code, source_type, engine, default_formats,
       CASE WHEN source_ref IS JSON THEN 'SRC OK' ELSE 'SRC BAD' END AS src_ok,
       CASE WHEN param_spec_json IS JSON THEN 'SPEC OK' ELSE 'SPEC BAD' END AS spec_ok
FROM prod.dct_rpt_definition
WHERE report_code = 'EBS_GL_BALANCE_REGISTER';

PROMPT ============================================================
PROMPT  30_rpt_ebs_balance_register.sql complete (EBS_GL_BALANCE_REGISTER).
PROMPT ============================================================
