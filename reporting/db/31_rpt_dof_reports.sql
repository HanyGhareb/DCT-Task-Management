-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 31 DOF submission reports (Excel)
-- File   : reporting/db/31_rpt_dof_reports.sql
-- Seeds  : DOF_YOY_PERF       -- 2 sheets: (1) YoY Performance at entity x
--          chapter x appropriation x account grain with EBS + Fusion account
--          codes, prior-year FY/YTD actuals (Fusion era via
--          DCT_GL_DOF_FACT_V + legacy era via DCT_EBS_BALANCE_MAPPED_V),
--          revised budget, YTD actuals, variance and the persisted
--          Reasons-for-Variance notes; chapter total + grand total rows come
--          from GROUPING SETS so the workbook matches the DOF template.
--          (2) Budget Utilization at appropriation grain: initial/revised
--          budget FY, APPROVED/REVISED cashflow YTD (DCT_GL_CASHFLOW_V),
--          actual YTD, variance, utilization pct, reasons.
--          DOF_QUARTERLY_PERF -- 1 sheet: appropriation grain, per-quarter
--          approved/revised budget cashflow vs actuals with variance, pct,
--          quarterly reasons and remarks.
--          Section SQLs mirror the GL/db/17 /gl/dof/* handlers in LOCK-STEP.
--          2026-08-03: the CURRENT-year leg of every section is Fusion UNION
--          legacy EBS (bg-1), so the reports run for ANY loaded fiscal year
--          (2016-2025 from DCT_EBS_BALANCE_MAPPED_V, 2026+ from the fact
--          view); for EBS years Initial = Revised budget (one EBS measure).
-- Params : year (required); period (MM-YYYY YTD end, YoY only, optional --
--          defaults to the latest loaded GL period of the year).
-- Deploy : SQLcl (sql -name prod) or python-oracledb. Idempotent; the seed
--          blocks use count-then-insert/update (deliberately no
--          keyword-risky statements, safe for Linux SQLcl).
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. DOF_YOY_PERF definition (MULTI, 2 sections, XLSX) ===
DECLARE
  l_yoy  VARCHAR2(32767);
  l_bu   VARCHAR2(32767);
  l_src  CLOB;
  l_body CLOB;
  l_spec CLOB;
  l_n    NUMBER;
BEGIN
  l_yoy := q'!WITH prm AS (SELECT NVL(TO_NUMBER(SUBSTR([COLON]period,1,2)),(SELECT NVL(MAX(period_month),12) FROM prod.dct_gl_dof_fact_v WHERE period_year=[COLON]year)) AS me FROM dual), cur AS (SELECT entity_code, MAX(entity_desc) AS entity_desc, chapter_code, MAX(chapter_name) AS chapter_name, ap, MAX(appr_desc) AS appr_desc, ac, MAX(account_desc) AS account_desc, SUM(rev_budget) AS rev_budget, SUM(actual_ytd) AS actual_ytd FROM (SELECT f.entity_code, f.entity_desc, f.chapter_code, f.chapter_name, f.appropriation_code AS ap, f.appropriation_desc AS appr_desc, f.account_code AS ac, f.account_desc AS account_desc, f.total_budget AS rev_budget, CASE WHEN f.period_month <= p.me THEN f.expenditures ELSE 0 END AS actual_ytd FROM prod.dct_gl_dof_fact_v f CROSS JOIN prm p WHERE f.period_year = [COLON]year AND SUBSTR(f.account_code,1,1) = '4' UNION ALL SELECT eb.entity_code, NULL, NULL, NULL, eb.ap, eb.appr_desc, eb.ac, eb.account_desc, NVL(eb.bud,0), NVL(eb.act,0) FROM (SELECT MAX(e.entity_code) AS entity_code, LPAD(MAX(e.fusion_appropriation),6,'0') AS ap, MAX(e.fusion_appropriation_desc) AS appr_desc, LPAD(MAX(e.fusion_account),6,'0') AS ac, MAX(e.fusion_account_desc) AS account_desc, MAX(e.budget_ytd) KEEP (DENSE_RANK LAST ORDER BY e.period_date) AS bud, MAX(CASE WHEN EXTRACT(MONTH FROM e.period_date) <= p.me THEN e.actual_ytd END) KEEP (DENSE_RANK LAST ORDER BY CASE WHEN EXTRACT(MONTH FROM e.period_date) <= p.me THEN e.period_date ELSE DATE '0001-01-01' END) AS act FROM prod.dct_ebs_balance_mapped_v e CROSS JOIN prm p WHERE e.period_year = [COLON]year AND e.fusion_account LIKE '4%' AND e.budget_code = '1' GROUP BY e.ebs_combination, p.me) eb) GROUP BY entity_code, chapter_code, ap, ac), pri AS (SELECT ap, ac, SUM(fy) AS prior_fy, SUM(ytd) AS prior_ytd FROM (SELECT f.appropriation_code AS ap, f.account_code AS ac, f.expenditures AS fy, CASE WHEN f.period_month <= p.me THEN f.expenditures ELSE 0 END AS ytd FROM prod.dct_gl_dof_fact_v f CROSS JOIN prm p WHERE f.period_year = [COLON]year - 1 AND SUBSTR(f.account_code,1,1) = '4' UNION ALL SELECT eb.ap, eb.ac, NVL(eb.fy,0), NVL(eb.ytd,0) FROM (SELECT LPAD(MAX(e.fusion_appropriation),6,'0') AS ap, LPAD(MAX(e.fusion_account),6,'0') AS ac, MAX(e.actual_ytd) KEEP (DENSE_RANK LAST ORDER BY e.period_date) AS fy, MAX(CASE WHEN EXTRACT(MONTH FROM e.period_date) <= p.me THEN e.actual_ytd END) KEEP (DENSE_RANK LAST ORDER BY CASE WHEN EXTRACT(MONTH FROM e.period_date) <= p.me THEN e.period_date ELSE DATE '0001-01-01' END) AS ytd FROM prod.dct_ebs_balance_mapped_v e CROSS JOIN prm p WHERE e.period_year = [COLON]year - 1 AND e.fusion_account LIKE '4%' AND e.budget_code = '1' GROUP BY e.ebs_combination, p.me) eb) GROUP BY ap, ac), e1 AS (SELECT MAX(entity_code) AS ec, MAX(entity_desc) AS ed FROM cur), apr AS (SELECT appropriation_code, MAX(appropriation_desc) AS appropriation_desc FROM prod.dct_gl_coa_snap WHERE appropriation_code IS NOT NULL GROUP BY appropriation_code), acc AS (SELECT account_code, MAX(account_desc) AS account_desc FROM prod.dct_gl_coa_snap WHERE account_code IS NOT NULL GROUP BY account_code), chp AS (SELECT m.segment_value AS ap, MAX(v.value_code) AS chapter_code, MAX(v.name_en) AS chapter_name FROM prod.dct_gl_seg_class_map m JOIN prod.dct_gl_class_value v ON v.class_value_id = m.class_value_id WHERE m.class_type_code = 'CHAPTER' AND TRUNC(SYSDATE) BETWEEN m.start_date AND NVL(m.end_date, DATE '9999-12-31') GROUP BY m.segment_value), d AS (SELECT NVL(j.entity_code, e1.ec) AS entity_code, NVL(j.entity_desc, e1.ed) AS entity_desc, NVL(j.chapter_code, ch.chapter_code) AS chapter_code, NVL(j.chapter_name, ch.chapter_name) AS chapter_name, j.ap, NVL(j.appr_desc, ap2.appropriation_desc) AS appr_desc, j.ac, NVL(j.account_desc, ac2.account_desc) AS account_desc, j.rev_budget, j.actual_ytd, j.prior_fy, j.prior_ytd FROM (SELECT NVL(c.ap, p.ap) AS ap, NVL(c.ac, p.ac) AS ac, c.entity_code, c.entity_desc, c.chapter_code, c.chapter_name, c.appr_desc, c.account_desc, NVL(c.rev_budget,0) AS rev_budget, NVL(c.actual_ytd,0) AS actual_ytd, NVL(p.prior_fy,0) AS prior_fy, NVL(p.prior_ytd,0) AS prior_ytd FROM cur c FULL OUTER JOIN pri p ON p.ap = c.ap AND p.ac = c.ac) j CROSS JOIN e1 LEFT JOIN apr ap2 ON ap2.appropriation_code = j.ap LEFT JOIN acc ac2 ON ac2.account_code = j.ac LEFT JOIN chp ch ON ch.ap = j.ap WHERE ABS(j.rev_budget)+ABS(j.actual_ytd)+ABS(j.prior_fy)+ABS(j.prior_ytd) > 0.005), ebs AS (SELECT fusion_value AS fv, LISTAGG(ebs_value, ' / ') WITHIN GROUP (ORDER BY ebs_value) AS codes FROM prod.dct_gl_ebs_map WHERE segment_type = 'ACCOUNT' AND is_active = 'Y' GROUP BY fusion_value), nt AS (SELECT appropriation_code AS ap, account_code AS ac, note_text FROM prod.dct_gl_dof_note WHERE budget_year = [COLON]year AND note_type = 'REASON' AND account_code IS NOT NULL AND quarter IS NULL) SELECT CASE WHEN GROUPING(d.chapter_code) = 1 THEN 'GRAND' WHEN GROUPING(d.ap) = 1 THEN 'CHTOTAL' ELSE 'DETAIL' END AS row_kind, CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.entity_code) END AS entity_code, CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.entity_desc) END AS entity_name, CASE WHEN GROUPING(d.chapter_code) = 1 THEN 'Grand Total' WHEN GROUPING(d.ap) = 1 THEN NVL(MAX(d.chapter_name),'Unclassified')||' Total' ELSE MAX(d.chapter_name) END AS chapter, d.ap AS f2_appropriation_code, CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.appr_desc) END AS f2_appropriation_description, CASE WHEN GROUPING(d.ac) = 0 THEN MAX(ebs.codes) END AS ebs_account_code, d.ac AS fusion_account_code, CASE WHEN GROUPING(d.ac) = 0 THEN MAX(d.account_desc) END AS account_name, SUM(d.prior_fy) AS prior_year_actual_fy, SUM(d.rev_budget) AS revised_budget, SUM(d.actual_ytd) AS actual_ytd, SUM(d.prior_ytd) AS prior_year_actual_ytd, SUM(d.actual_ytd) - SUM(d.prior_ytd) AS variance, CASE WHEN GROUPING(d.ac) = 0 THEN MAX(nt.note_text) END AS reasons_for_variance FROM d LEFT JOIN ebs ON ebs.fv = d.ac LEFT JOIN nt ON nt.ap = d.ap AND nt.ac = d.ac GROUP BY GROUPING SETS ((d.chapter_code, d.ap, d.ac),(d.chapter_code),()) ORDER BY GROUPING(d.chapter_code), d.chapter_code NULLS LAST, GROUPING(d.ap), d.ap, d.ac!';
  l_bu := q'!WITH prm AS (SELECT NVL(TO_NUMBER(SUBSTR([COLON]period,1,2)),(SELECT NVL(MAX(period_month),12) FROM prod.dct_gl_dof_fact_v WHERE period_year=[COLON]year)) AS me FROM dual), cur AS (SELECT entity_code, MAX(entity_desc) AS entity_desc, chapter_code, MAX(chapter_name) AS chapter_name, ap, MAX(appr_desc) AS appr_desc, SUM(init_budget) AS init_budget, SUM(rev_budget) AS rev_budget, SUM(actual_ytd) AS actual_ytd FROM (SELECT f.entity_code, f.entity_desc, f.chapter_code, f.chapter_name, f.appropriation_code AS ap, f.appropriation_desc AS appr_desc, f.initial_budget AS init_budget, f.total_budget AS rev_budget, CASE WHEN f.period_month <= p.me THEN f.expenditures ELSE 0 END AS actual_ytd FROM prod.dct_gl_dof_fact_v f CROSS JOIN prm p WHERE f.period_year = [COLON]year AND SUBSTR(f.account_code,1,1) = '4' UNION ALL SELECT eb.entity_code, NULL, NULL, NULL, eb.ap, eb.appr_desc, NVL(eb.bud,0), NVL(eb.bud,0), NVL(eb.act,0) FROM (SELECT MAX(e.entity_code) AS entity_code, LPAD(MAX(e.fusion_appropriation),6,'0') AS ap, MAX(e.fusion_appropriation_desc) AS appr_desc, MAX(e.budget_ytd) KEEP (DENSE_RANK LAST ORDER BY e.period_date) AS bud, MAX(CASE WHEN EXTRACT(MONTH FROM e.period_date) <= p.me THEN e.actual_ytd END) KEEP (DENSE_RANK LAST ORDER BY CASE WHEN EXTRACT(MONTH FROM e.period_date) <= p.me THEN e.period_date ELSE DATE '0001-01-01' END) AS act FROM prod.dct_ebs_balance_mapped_v e CROSS JOIN prm p WHERE e.period_year = [COLON]year AND e.fusion_account LIKE '4%' AND e.budget_code = '1' GROUP BY e.ebs_combination, p.me) eb) GROUP BY entity_code, chapter_code, ap), cf AS (SELECT v.appropriation_norm AS ap, SUM(CASE WHEN v.cf_type = 'APPROVED' AND v.period_month <= p.me THEN v.cf_amount ELSE 0 END) AS init_cf_ytd, SUM(CASE WHEN v.cf_type = 'REVISED' AND v.period_month <= p.me THEN v.cf_amount ELSE 0 END) AS rev_cf_ytd FROM prod.dct_gl_cashflow_v v CROSS JOIN prm p WHERE v.budget_year = [COLON]year GROUP BY v.appropriation_norm), e1 AS (SELECT MAX(entity_code) AS ec, MAX(entity_desc) AS ed FROM cur), apr AS (SELECT appropriation_code, MAX(appropriation_desc) AS appropriation_desc FROM prod.dct_gl_coa_snap WHERE appropriation_code IS NOT NULL GROUP BY appropriation_code), chp AS (SELECT m.segment_value AS ap, MAX(v.value_code) AS chapter_code, MAX(v.name_en) AS chapter_name FROM prod.dct_gl_seg_class_map m JOIN prod.dct_gl_class_value v ON v.class_value_id = m.class_value_id WHERE m.class_type_code = 'CHAPTER' AND TRUNC(SYSDATE) BETWEEN m.start_date AND NVL(m.end_date, DATE '9999-12-31') GROUP BY m.segment_value), nt AS (SELECT appropriation_code AS ap, note_text FROM prod.dct_gl_dof_note WHERE budget_year = [COLON]year AND note_type = 'REASON' AND account_code IS NULL AND quarter IS NULL) SELECT CASE WHEN GROUPING(d.chapter_code) = 1 THEN 'GRAND' WHEN GROUPING(d.ap) = 1 THEN 'CHTOTAL' ELSE 'DETAIL' END AS row_kind, CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.entity_code) END AS entity_code, CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.entity_desc) END AS entity_name, CASE WHEN GROUPING(d.chapter_code) = 1 THEN 'Grand Total' WHEN GROUPING(d.ap) = 1 THEN NVL(MAX(d.chapter_name),'Unclassified')||' Total' ELSE MAX(d.chapter_name) END AS chapter, d.ap AS f2_appropriation_code, CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.appr_desc) END AS f2_appropriation_description, SUM(d.init_budget) AS initial_budget_fy, SUM(d.rev_budget) AS revised_budget_fy, SUM(d.init_cf_ytd) AS initial_budget_ytd_cf, SUM(d.rev_cf_ytd) AS revised_budget_ytd_cashflow, SUM(d.actual_ytd) AS actual_ytd, SUM(d.rev_cf_ytd) - SUM(d.actual_ytd) AS variance, CASE WHEN SUM(d.rev_cf_ytd) <> 0 THEN ROUND(100 * SUM(d.actual_ytd) / SUM(d.rev_cf_ytd), 1) END AS budget_utilization_pct, CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.note_text) END AS reasons_for_variance FROM (SELECT NVL(c.entity_code, e1.ec) AS entity_code, NVL(c.entity_desc, e1.ed) AS entity_desc, NVL(c.chapter_code, ch.chapter_code) AS chapter_code, NVL(c.chapter_name, ch.chapter_name) AS chapter_name, NVL(c.ap, f.ap) AS ap, NVL(c.appr_desc, ap2.appropriation_desc) AS appr_desc, NVL(c.init_budget,0) AS init_budget, NVL(c.rev_budget,0) AS rev_budget, NVL(f.init_cf_ytd,0) AS init_cf_ytd, NVL(f.rev_cf_ytd,0) AS rev_cf_ytd, NVL(c.actual_ytd,0) AS actual_ytd, nt.note_text FROM cur c FULL OUTER JOIN cf f ON f.ap = c.ap CROSS JOIN e1 LEFT JOIN apr ap2 ON ap2.appropriation_code = NVL(c.ap, f.ap) LEFT JOIN chp ch ON ch.ap = NVL(c.ap, f.ap) LEFT JOIN nt ON nt.ap = NVL(c.ap, f.ap)) d GROUP BY GROUPING SETS ((d.chapter_code, d.ap),(d.chapter_code),()) ORDER BY GROUPING(d.chapter_code), d.chapter_code NULLS LAST, GROUPING(d.ap), d.ap!';
  l_src := '{"required":["year"],'
        || '"sections":['
        || '{"key":"yoy","title":"DOF YoY Performance","layout":"table","sql":"' || l_yoy || '"}' || ','
        || '{"key":"butil","title":"DOF Budget Utilization","layout":"table","sql":"' || l_bu || '"}'
        || ']}';
  l_src := REPLACE(l_src, '[COLON]', CHR(58));
  l_spec := '{'
    || '"year":{"label":"Budget year","label_ar":"سنة الميزانية","hint":"Fiscal year of the report","required":true,'
    || '"lov_sql":"SELECT yr FROM (SELECT DISTINCT period_year AS yr FROM prod.dct_gl_dof_fact_v WHERE period_year IS NOT NULL UNION SELECT DISTINCT period_year FROM prod.dct_ebs_balance_mapped_v WHERE period_year IS NOT NULL) ORDER BY yr DESC"},'
    || '"period":{"label":"Period (YTD end)","label_ar":"الفترة (حتى تاريخه)","hint":"MM-YYYY; defaults to the latest loaded GL period of the year","required":false}'
    || '}';
  l_body :=
    '<p>Dear {{ recipient_name }},</p>'||
    '<p>The <strong>DOF YoY Performance Report</strong> (Excel) for budget year '||
    '<strong>{{ params.year }}</strong> is attached: sheet 1 = year-over-year performance per '||
    'appropriation and account (EBS + Fusion codes, prior-year FY/YTD actuals, revised budget, '||
    'YTD actuals, variance, reasons); sheet 2 = budget utilization per appropriation with the '||
    'approved/revised cashflow YTD ({{ row_count }} lines in total).</p>'||
    '<p>Prepared by Financial Planning and Budgeting, Finance Department. '||
    'Generated {{ generated_at }} by i-Finance Reporting.</p>';
  SELECT COUNT(*) INTO l_n FROM prod.dct_rpt_definition WHERE report_code = 'DOF_YOY_PERF';
  IF l_n = 0 THEN
    INSERT INTO prod.dct_rpt_definition
      (report_code, name_en, name_ar, description, category, source_type, source_ref, engine,
       default_formats, email_subject_tpl, email_body_tpl, params_json, param_spec_json,
       enabled, created_by, updated_by)
    VALUES
      ('DOF_YOY_PERF',
       'DOF YoY Performance Report (Excel)',
       UNISTR('\062A\0642\0631\064A\0631 \0627\0644\0623\062F\0627\0621 \0627\0644\0633\0646\0648\064A \0644\062F\0627\0626\0631\0629 \0627\0644\0645\0627\0644\064A\0629'),
       'DOF submission workbook, two sheets. Sheet 1 -- YoY Performance: entity x chapter x appropriation x account with EBS and Fusion account codes, prior-year actual FY and YTD (Fusion-era balances plus legacy EBS balances through the account mapping), revised budget, actual YTD, variance and the persisted reasons-for-variance; chapter totals and a grand total row. Sheet 2 -- Budget Utilization: appropriation grain with initial/revised budget FY, approved/revised budget cashflow YTD (user-loaded plan), actual YTD, variance and utilization percent. Parameters: year (required); period MM-YYYY (optional YTD end, defaults to the latest loaded GL period).',
       'General Ledger', 'MULTI', l_src, 'PYTHON', 'XLSX',
       'DOF YoY Performance Report - {{ params.year }}',
       l_body,
       '{"year":null,"period":null}',
       l_spec,
       'Y', 'SETUP', 'SETUP');
  ELSE
    UPDATE prod.dct_rpt_definition SET
       source_type       = 'MULTI',
       source_ref        = l_src,
       engine            = 'PYTHON',
       default_formats   = 'XLSX',
       email_subject_tpl = 'DOF YoY Performance Report - {{ params.year }}',
       email_body_tpl    = l_body,
       params_json       = '{"year":null,"period":null}',
       param_spec_json   = l_spec,
       updated_by        = 'SETUP',
       updated_at        = SYSTIMESTAMP
     WHERE report_code = 'DOF_YOY_PERF';
  END IF;
  SELECT COUNT(*) INTO l_n FROM prod.dct_rpt_recipient
   WHERE report_code = 'DOF_YOY_PERF' AND recipient_type = 'SELF';
  IF l_n = 0 THEN
    INSERT INTO prod.dct_rpt_recipient
      (report_code, recipient_type, recipient_ref, channel, enabled, created_by, updated_by)
    VALUES ('DOF_YOY_PERF', 'SELF', NULL, 'EMAIL', 'Y', 'SETUP', 'SETUP');
  END IF;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('DOF_YOY_PERF seeded (definition + SELF recipient).');
END;
/

PROMPT === 2. DOF_QUARTERLY_PERF definition (MULTI, 1 section, XLSX) ===
DECLARE
  l_q    VARCHAR2(32767);
  l_src  CLOB;
  l_body CLOB;
  l_spec CLOB;
  l_n    NUMBER;
BEGIN
  l_q := q'!WITH cur AS (SELECT entity_code, MAX(entity_desc) AS entity_desc, chapter_code, MAX(chapter_name) AS chapter_name, ap, MAX(appr_desc) AS appr_desc, SUM(approved_budget) AS approved_budget, SUM(rev_budget_q1) AS rev_budget_q1, SUM(rev_budget_q2) AS rev_budget_q2, SUM(act1) AS act1, SUM(act2) AS act2, SUM(act3) AS act3, SUM(act4) AS act4 FROM (SELECT f.entity_code, f.entity_desc, f.chapter_code, f.chapter_name, f.appropriation_code AS ap, f.appropriation_desc AS appr_desc, f.initial_budget AS approved_budget, CASE WHEN f.period_month <= 3 THEN f.total_budget ELSE 0 END AS rev_budget_q1, CASE WHEN f.period_month <= 6 THEN f.total_budget ELSE 0 END AS rev_budget_q2, CASE WHEN f.period_quarter = 1 THEN f.expenditures ELSE 0 END AS act1, CASE WHEN f.period_quarter = 2 THEN f.expenditures ELSE 0 END AS act2, CASE WHEN f.period_quarter = 3 THEN f.expenditures ELSE 0 END AS act3, CASE WHEN f.period_quarter = 4 THEN f.expenditures ELSE 0 END AS act4 FROM prod.dct_gl_dof_fact_v f WHERE f.period_year = [COLON]year AND SUBSTR(f.account_code,1,1) = '4' UNION ALL SELECT eb.entity_code, NULL, NULL, NULL, eb.ap, eb.appr_desc, NVL(eb.budf,0), NVL(eb.bud3,0), NVL(eb.bud6,0), NVL(eb.a3,0), NVL(eb.a6,0)-NVL(eb.a3,0), NVL(eb.a9,0)-NVL(eb.a6,0), NVL(eb.af,0)-NVL(eb.a9,0) FROM (SELECT MAX(e.entity_code) AS entity_code, LPAD(MAX(e.fusion_appropriation),6,'0') AS ap, MAX(e.fusion_appropriation_desc) AS appr_desc, MAX(e.budget_ytd) KEEP (DENSE_RANK LAST ORDER BY e.period_date) AS budf, MAX(CASE WHEN EXTRACT(MONTH FROM e.period_date) <= 3 THEN e.budget_ytd END) KEEP (DENSE_RANK LAST ORDER BY CASE WHEN EXTRACT(MONTH FROM e.period_date) <= 3 THEN e.period_date ELSE DATE '0001-01-01' END) AS bud3, MAX(CASE WHEN EXTRACT(MONTH FROM e.period_date) <= 6 THEN e.budget_ytd END) KEEP (DENSE_RANK LAST ORDER BY CASE WHEN EXTRACT(MONTH FROM e.period_date) <= 6 THEN e.period_date ELSE DATE '0001-01-01' END) AS bud6, MAX(CASE WHEN EXTRACT(MONTH FROM e.period_date) <= 3 THEN e.actual_ytd END) KEEP (DENSE_RANK LAST ORDER BY CASE WHEN EXTRACT(MONTH FROM e.period_date) <= 3 THEN e.period_date ELSE DATE '0001-01-01' END) AS a3, MAX(CASE WHEN EXTRACT(MONTH FROM e.period_date) <= 6 THEN e.actual_ytd END) KEEP (DENSE_RANK LAST ORDER BY CASE WHEN EXTRACT(MONTH FROM e.period_date) <= 6 THEN e.period_date ELSE DATE '0001-01-01' END) AS a6, MAX(CASE WHEN EXTRACT(MONTH FROM e.period_date) <= 9 THEN e.actual_ytd END) KEEP (DENSE_RANK LAST ORDER BY CASE WHEN EXTRACT(MONTH FROM e.period_date) <= 9 THEN e.period_date ELSE DATE '0001-01-01' END) AS a9, MAX(e.actual_ytd) KEEP (DENSE_RANK LAST ORDER BY e.period_date) AS af FROM prod.dct_ebs_balance_mapped_v e WHERE e.period_year = [COLON]year AND e.fusion_account LIKE '4%' AND e.budget_code = '1' GROUP BY e.ebs_combination) eb) GROUP BY entity_code, chapter_code, ap), cf AS (SELECT v.appropriation_norm AS ap, SUM(CASE WHEN v.cf_type = 'APPROVED' AND v.period_quarter = 1 THEN v.cf_amount ELSE 0 END) AS acf1, SUM(CASE WHEN v.cf_type = 'APPROVED' AND v.period_quarter = 2 THEN v.cf_amount ELSE 0 END) AS acf2, SUM(CASE WHEN v.cf_type = 'APPROVED' AND v.period_quarter = 3 THEN v.cf_amount ELSE 0 END) AS acf3, SUM(CASE WHEN v.cf_type = 'APPROVED' AND v.period_quarter = 4 THEN v.cf_amount ELSE 0 END) AS acf4, SUM(CASE WHEN v.cf_type = 'REVISED' AND v.period_quarter = 1 THEN v.cf_amount ELSE 0 END) AS rcf1, SUM(CASE WHEN v.cf_type = 'REVISED' AND v.period_quarter = 2 THEN v.cf_amount ELSE 0 END) AS rcf2, SUM(CASE WHEN v.cf_type = 'REVISED' AND v.period_quarter = 3 THEN v.cf_amount ELSE 0 END) AS rcf3, SUM(CASE WHEN v.cf_type = 'REVISED' AND v.period_quarter = 4 THEN v.cf_amount ELSE 0 END) AS rcf4 FROM prod.dct_gl_cashflow_v v WHERE v.budget_year = [COLON]year GROUP BY v.appropriation_norm), e1 AS (SELECT MAX(entity_code) AS ec, MAX(entity_desc) AS ed FROM cur), apr AS (SELECT appropriation_code, MAX(appropriation_desc) AS appropriation_desc FROM prod.dct_gl_coa_snap WHERE appropriation_code IS NOT NULL GROUP BY appropriation_code), chp AS (SELECT m.segment_value AS ap, MAX(v.value_code) AS chapter_code, MAX(v.name_en) AS chapter_name FROM prod.dct_gl_seg_class_map m JOIN prod.dct_gl_class_value v ON v.class_value_id = m.class_value_id WHERE m.class_type_code = 'CHAPTER' AND TRUNC(SYSDATE) BETWEEN m.start_date AND NVL(m.end_date, DATE '9999-12-31') GROUP BY m.segment_value), nt AS (SELECT appropriation_code AS ap, MAX(CASE WHEN note_type = 'REASON' AND quarter = 1 THEN note_text END) AS rsn1, MAX(CASE WHEN note_type = 'REASON' AND quarter = 2 THEN note_text END) AS rsn2, MAX(CASE WHEN note_type = 'REASON' AND quarter = 3 THEN note_text END) AS rsn3, MAX(CASE WHEN note_type = 'REASON' AND quarter = 4 THEN note_text END) AS rsn4, MAX(CASE WHEN note_type = 'REMARK' AND quarter IS NULL THEN note_text END) AS remark FROM prod.dct_gl_dof_note WHERE budget_year = [COLON]year AND account_code IS NULL GROUP BY appropriation_code) SELECT CASE WHEN GROUPING(d.chapter_code) = 1 THEN 'GRAND' WHEN GROUPING(d.ap) = 1 THEN 'CHTOTAL' ELSE 'DETAIL' END AS row_kind, CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.entity_code) END AS entity_code, CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.entity_desc) END AS entity_name, CASE WHEN GROUPING(d.chapter_code) = 1 THEN 'Grand Total' WHEN GROUPING(d.ap) = 1 THEN NVL(MAX(d.chapter_name),'Unclassified')||' Total' ELSE MAX(d.chapter_name) END AS chapter, d.ap AS f2_appropriation_code, CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.appr_desc) END AS f2_appropriation_description, SUM(d.approved_budget) AS approved_budget, SUM(d.rev_budget_q1) AS revised_budget_q1, SUM(d.rev_budget_q2) AS revised_budget_q2, SUM(d.acf1) AS approved_budget_cashflow_q1, SUM(d.rcf1) AS revised_budget_cashflow_q1, SUM(d.act1) AS actual_q1, SUM(d.rcf1)-SUM(d.act1) AS variance_q1, CASE WHEN SUM(d.rcf1) <> 0 THEN ROUND(100*(SUM(d.rcf1)-SUM(d.act1))/SUM(d.rcf1),1) END AS variance_pct_q1, CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.rsn1) END AS reasons_q1, SUM(d.acf2) AS approved_budget_cashflow_q2, SUM(d.rcf2) AS revised_budget_cashflow_q2, SUM(d.act2) AS actual_q2, SUM(d.rcf2)-SUM(d.act2) AS variance_q2, CASE WHEN SUM(d.rcf2) <> 0 THEN ROUND(100*(SUM(d.rcf2)-SUM(d.act2))/SUM(d.rcf2),1) END AS variance_pct_q2, CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.rsn2) END AS reasons_q2, SUM(d.acf3) AS approved_budget_cashflow_q3, SUM(d.rcf3) AS revised_budget_cashflow_q3, SUM(d.act3) AS actual_q3, SUM(d.rcf3)-SUM(d.act3) AS variance_q3, CASE WHEN SUM(d.rcf3) <> 0 THEN ROUND(100*(SUM(d.rcf3)-SUM(d.act3))/SUM(d.rcf3),1) END AS variance_pct_q3, CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.rsn3) END AS reasons_q3, SUM(d.acf4) AS approved_budget_cashflow_q4, SUM(d.rcf4) AS revised_budget_cashflow_q4, SUM(d.act4) AS actual_q4, SUM(d.rcf4)-SUM(d.act4) AS variance_q4, CASE WHEN SUM(d.rcf4) <> 0 THEN ROUND(100*(SUM(d.rcf4)-SUM(d.act4))/SUM(d.rcf4),1) END AS variance_pct_q4, CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.rsn4) END AS reasons_q4, CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.remark) END AS remarks FROM (SELECT NVL(c.entity_code, e1.ec) AS entity_code, NVL(c.entity_desc, e1.ed) AS entity_desc, NVL(c.chapter_code, ch.chapter_code) AS chapter_code, NVL(c.chapter_name, ch.chapter_name) AS chapter_name, NVL(c.ap, f.ap) AS ap, NVL(c.appr_desc, ap2.appropriation_desc) AS appr_desc, NVL(c.approved_budget,0) AS approved_budget, NVL(c.rev_budget_q1,0) AS rev_budget_q1, NVL(c.rev_budget_q2,0) AS rev_budget_q2, NVL(f.acf1,0) AS acf1, NVL(f.acf2,0) AS acf2, NVL(f.acf3,0) AS acf3, NVL(f.acf4,0) AS acf4, NVL(f.rcf1,0) AS rcf1, NVL(f.rcf2,0) AS rcf2, NVL(f.rcf3,0) AS rcf3, NVL(f.rcf4,0) AS rcf4, NVL(c.act1,0) AS act1, NVL(c.act2,0) AS act2, NVL(c.act3,0) AS act3, NVL(c.act4,0) AS act4, nt.rsn1, nt.rsn2, nt.rsn3, nt.rsn4, nt.remark FROM cur c FULL OUTER JOIN cf f ON f.ap = c.ap CROSS JOIN e1 LEFT JOIN apr ap2 ON ap2.appropriation_code = NVL(c.ap, f.ap) LEFT JOIN chp ch ON ch.ap = NVL(c.ap, f.ap) LEFT JOIN nt ON nt.ap = NVL(c.ap, f.ap)) d GROUP BY GROUPING SETS ((d.chapter_code, d.ap),(d.chapter_code),()) ORDER BY GROUPING(d.chapter_code), d.chapter_code NULLS LAST, GROUPING(d.ap), d.ap!';
  l_src := '{"required":["year"],'
        || '"sections":['
        || '{"key":"quarterly","title":"Quarterly Performance","layout":"table","sql":"' || l_q || '"}'
        || ']}';
  l_src := REPLACE(l_src, '[COLON]', CHR(58));
  l_spec := '{'
    || '"year":{"label":"Budget year","label_ar":"سنة الميزانية","hint":"Fiscal year of the report","required":true,'
    || '"lov_sql":"SELECT yr FROM (SELECT DISTINCT period_year AS yr FROM prod.dct_gl_dof_fact_v WHERE period_year IS NOT NULL UNION SELECT DISTINCT period_year FROM prod.dct_ebs_balance_mapped_v WHERE period_year IS NOT NULL) ORDER BY yr DESC"}'
    || '}';
  l_body :=
    '<p>Dear {{ recipient_name }},</p>'||
    '<p>The <strong>DOF Quarterly Performance Report</strong> (Excel) for budget year '||
    '<strong>{{ params.year }}</strong> is attached: per appropriation, the approved and revised '||
    'budget cashflow against actuals for each quarter with variance, variance percent, quarterly '||
    'reasons and remarks ({{ row_count }} lines).</p>'||
    '<p>Prepared by Financial Planning and Budgeting, Finance Department. '||
    'Generated {{ generated_at }} by i-Finance Reporting.</p>';
  SELECT COUNT(*) INTO l_n FROM prod.dct_rpt_definition WHERE report_code = 'DOF_QUARTERLY_PERF';
  IF l_n = 0 THEN
    INSERT INTO prod.dct_rpt_definition
      (report_code, name_en, name_ar, description, category, source_type, source_ref, engine,
       default_formats, email_subject_tpl, email_body_tpl, params_json, param_spec_json,
       enabled, created_by, updated_by)
    VALUES
      ('DOF_QUARTERLY_PERF',
       'DOF Quarterly Performance Report (Excel)',
       UNISTR('\062A\0642\0631\064A\0631 \0627\0644\0623\062F\0627\0621 \0627\0644\0631\0628\0639 \0633\0646\0648\064A \0644\062F\0627\0626\0631\0629 \0627\0644\0645\0627\0644\064A\0629'),
       'DOF submission workbook, one sheet: entity x chapter x appropriation with the annual approved budget, the revised budget as of Q1 and Q2, and per quarter (Q1..Q4) the approved and revised budget cashflow (user-loaded plan), actuals, variance, variance percent and the persisted quarterly reasons plus remarks. Parameter: year (required).',
       'General Ledger', 'MULTI', l_src, 'PYTHON', 'XLSX',
       'DOF Quarterly Performance Report - {{ params.year }}',
       l_body,
       '{"year":null}',
       l_spec,
       'Y', 'SETUP', 'SETUP');
  ELSE
    UPDATE prod.dct_rpt_definition SET
       source_type       = 'MULTI',
       source_ref        = l_src,
       engine            = 'PYTHON',
       default_formats   = 'XLSX',
       email_subject_tpl = 'DOF Quarterly Performance Report - {{ params.year }}',
       email_body_tpl    = l_body,
       params_json       = '{"year":null}',
       param_spec_json   = l_spec,
       updated_by        = 'SETUP',
       updated_at        = SYSTIMESTAMP
     WHERE report_code = 'DOF_QUARTERLY_PERF';
  END IF;
  SELECT COUNT(*) INTO l_n FROM prod.dct_rpt_recipient
   WHERE report_code = 'DOF_QUARTERLY_PERF' AND recipient_type = 'SELF';
  IF l_n = 0 THEN
    INSERT INTO prod.dct_rpt_recipient
      (report_code, recipient_type, recipient_ref, channel, enabled, created_by, updated_by)
    VALUES ('DOF_QUARTERLY_PERF', 'SELF', NULL, 'EMAIL', 'Y', 'SETUP', 'SETUP');
  END IF;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('DOF_QUARTERLY_PERF seeded (definition + SELF recipient).');
END;
/

PROMPT === 3. Verify ===
SELECT report_code, source_type, engine, default_formats,
       CASE WHEN source_ref IS JSON THEN 'SRC OK' ELSE 'SRC BAD' END AS src_ok,
       CASE WHEN param_spec_json IS JSON THEN 'SPEC OK' ELSE 'SPEC BAD' END AS spec_ok
FROM prod.dct_rpt_definition
WHERE report_code IN ('DOF_YOY_PERF','DOF_QUARTERLY_PERF');

PROMPT ============================================================
PROMPT  31_rpt_dof_reports.sql complete (DOF_YOY_PERF + DOF_QUARTERLY_PERF).
PROMPT ============================================================
