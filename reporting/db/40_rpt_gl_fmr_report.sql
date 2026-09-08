-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 40 GL Financial Performance Report
-- File   : reporting/db/40_rpt_gl_fmr_report.sql
-- Seeds  : GL_FMR_REPORT -- the GL app's Financial Performance Report /
--          Budget Overview page (FMR_Dashboard.pdf layout) as a generated
--          report. ONE definition, THREE formats picked per run by the GL
--          bridge (final apps/GL/db/41): PDF (custom landscape template
--          gl_fmr_book.html.j2, DB-stored via /rpt/templates -- the default
--          report.html.j2 has NO sections loop), XLSX (sheet per section)
--          and PPTX (render_pptx.py _fmr_deck -- dispatches on report_code).
--          Sections (LOCK-STEP with final apps/GL/db/37 /gl/fmr handlers --
--          bg=1 via REGEXP_SUBSTR(cc_string,pos 4), Chapters 1/2/3 only,
--          entity via pos 6 / appropriation 301439 carve-out, plan = GL
--          cashflow upload + project cashflow):
--            1. overall   -- one row: the 5 page KPIs + pcts
--            2. entities  -- DCT / ALC / Museums / Masterpieces
--            3. trend     -- Payroll / Opex / Capex (budget-actual-plan)
--            4. sectors   -- sector split sorted by actual-vs-plan pct
--            5. notes     -- Current Month / Expected Variances commentary
-- Params : period (REQUIRED, MM-YYYY -- drives everything incl. the plan YTD
--          cut via pre_sql GL_CTX.BUTIL_END, post_sql ALWAYS clears);
--          entity (optional pipe any-of, sectors section only).
-- Deploy : python-oracledb (reporting/runner/deploy_seed.py or local wallet)
--          -- the source_ref build is >10KB, Linux SQLcl would swallow it.
-- NOTE   : TO_CHAR time masks use 'HH'||CHR(58)||'MI AM' -- a literal colon in
--          a section SQL becomes a phantom bind in the python datasource.
-- CRLF-safe. Zero blank lines inside statements.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. GL_FMR_REPORT definition (MULTI, 5 sections, PDF+XLSX+PPTX) ===
DECLARE
  l_ecase_p VARCHAR2(500);
  l_ecase_c VARCHAR2(500);
  l_ecase_b VARCHAR2(600);
  l_yr      VARCHAR2(80);
  l_ovr     VARCHAR2(8000);
  l_ent     VARCHAR2(8000);
  l_trd     VARCHAR2(8000);
  l_sec     VARCHAR2(32767);
  l_not     VARCHAR2(4000);
  l_src     CLOB;
  l_body    CLOB;
  l_spec    CLOB;
  l_desc    VARCHAR2(1000);
  l_n       NUMBER;
BEGIN
  -- entity classification (GL/db/47, data-driven): period-view rows carry
  -- entity_class_code; cashflow / butil rows resolve through entity_of()
  l_ecase_p := q'!NVL(p.entity_class_code,'UNCLASSIFIED')!';
  l_ecase_c := q'!NVL(prod.dct_gl_class_pkg.entity_of(c.cc_string, TRUNC(SYSDATE)),'UNCLASSIFIED')!';
  l_ecase_b := q'!NVL(csb.entity_class_code,'UNCLASSIFIED')!';
  l_yr      := q'!TO_NUMBER(SUBSTR([COLON]period,4))!';

  l_ovr := q'!SELECT a.budget, a.actual, NVL(pp.amt,0) + NVL(pj.amt,0) AS ytd_plan, CASE WHEN pp.amt IS NOT NULL OR pj.amt IS NOT NULL THEN 'Y' ELSE 'N' END AS has_plan, a.funds_available, CASE WHEN a.budget <> 0 THEN ROUND(a.actual*1000/a.budget)/10 END AS actual_vs_budget_pct, CASE WHEN NVL(pp.amt,0)+NVL(pj.amt,0) <> 0 THEN ROUND(a.actual*1000/(NVL(pp.amt,0)+NVL(pj.amt,0)))/10 END AS actual_vs_plan_pct, CASE WHEN a.budget <> 0 AND (pp.amt IS NOT NULL OR pj.amt IS NOT NULL) THEN ROUND((NVL(pp.amt,0)+NVL(pj.amt,0))*1000/a.budget)/10 END AS plan_vs_budget_pct FROM (SELECT NVL(SUM(p.budget_ytd),0) budget, NVL(SUM(p.gl_actual_ytd),0) actual, NVL(SUM(p.funds_available_ytd),0) funds_available FROM prod.dct_budget_actual_period_v p WHERE p.period_name = [COLON]period AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '1' AND p.chapter_code IN ('CH1','CH2','CH3')) a CROSS JOIN (SELECT SUM(c.cf_amount) amt FROM prod.dct_gl_budget_cashflow c WHERE c.cf_type = 'APPROVED' AND c.budget_year = !'
        || l_yr || q'! AND c.budget_group_code = '1' AND TO_DATE(c.accounting_period,'MM-YYYY') <= TO_DATE([COLON]period,'MM-YYYY')) pp CROSS JOIN (SELECT SUM(p2.plan_appr_ytd) amt FROM prod.dct_budget_utilization_v b LEFT JOIN prod.dct_gl_coa_snap csb ON csb.cc_string = b.budget_combination JOIN prod.dct_project_cf_butil_v p2 ON p2.budget_year = b.budget_year AND p2.project_number = b.project_number AND p2.task_number = b.task_number AND p2.expenditure_type = b.expenditure_type WHERE b.budget_year = !'
        || l_yr || q'! AND b.chapter IN ('Chapter 2','Chapter 3')) pj!';

  l_ent := q'!WITH ent AS (SELECT v.value_code code, v.name_en name, v.display_order ord FROM prod.dct_gl_class_value v WHERE v.class_type_code = 'ENTITY' AND v.is_active = 'Y' UNION ALL SELECT 'UNCLASSIFIED', 'Unclassified', 9999 FROM dual WHERE EXISTS (SELECT 1 FROM prod.dct_budget_actual_period_v p WHERE p.period_name = [COLON]period AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '1' AND p.chapter_code IN ('CH1','CH2','CH3') AND p.entity_class_code IS NULL AND (p.budget_ytd <> 0 OR p.gl_actual_ytd <> 0))), ba AS (SELECT !'
        || l_ecase_p || q'! ecode, SUM(p.budget_ytd) bud, SUM(p.gl_actual_ytd) act, SUM(p.funds_available_ytd) fun FROM prod.dct_budget_actual_period_v p WHERE p.period_name = [COLON]period AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '1' AND p.chapter_code IN ('CH1','CH2','CH3') GROUP BY !'
        || l_ecase_p || q'!), pay AS (SELECT !'
        || l_ecase_c || q'! ecode, SUM(c.cf_amount) amt FROM prod.dct_gl_budget_cashflow c WHERE c.cf_type = 'APPROVED' AND c.budget_year = !'
        || l_yr || q'! AND c.budget_group_code = '1' AND TO_DATE(c.accounting_period,'MM-YYYY') <= TO_DATE([COLON]period,'MM-YYYY') GROUP BY !'
        || l_ecase_c || q'!), prj AS (SELECT !'
        || l_ecase_b || q'! ecode, SUM(p2.plan_appr_ytd) amt FROM prod.dct_budget_utilization_v b LEFT JOIN prod.dct_gl_coa_snap csb ON csb.cc_string = b.budget_combination JOIN prod.dct_project_cf_butil_v p2 ON p2.budget_year = b.budget_year AND p2.project_number = b.project_number AND p2.task_number = b.task_number AND p2.expenditure_type = b.expenditure_type WHERE b.budget_year = !'
        || l_yr || q'! AND b.chapter IN ('Chapter 2','Chapter 3') GROUP BY !'
        || l_ecase_b || q'!) SELECT e.code AS entity_code, e.name AS entity, NVL(ba.bud,0) AS budget, NVL(ba.act,0) AS actual, NVL(pay.amt,0)+NVL(prj.amt,0) AS ytd_plan, CASE WHEN pay.ecode IS NOT NULL OR prj.ecode IS NOT NULL THEN 'Y' ELSE 'N' END AS has_plan, NVL(ba.fun,0) AS funds_available, CASE WHEN NVL(ba.bud,0) <> 0 THEN ROUND(NVL(ba.act,0)*1000/ba.bud)/10 END AS actual_vs_budget_pct, CASE WHEN NVL(pay.amt,0)+NVL(prj.amt,0) <> 0 THEN ROUND(NVL(ba.act,0)*1000/(NVL(pay.amt,0)+NVL(prj.amt,0)))/10 END AS actual_vs_plan_pct FROM ent e LEFT JOIN ba ON ba.ecode = e.code LEFT JOIN pay ON pay.ecode = e.code LEFT JOIN prj ON prj.ecode = e.code ORDER BY e.ord!';

  l_trd := q'!WITH typ AS (SELECT 'PAYROLL' code, 'Payroll' name, 'CH1' ch, CAST(NULL AS VARCHAR2(20)) chname, 1 ord FROM dual UNION ALL SELECT 'OPEX', 'Opex', 'CH2', 'Chapter 2', 2 FROM dual UNION ALL SELECT 'CAPEX', 'Capex', 'CH3', 'Chapter 3', 3 FROM dual), ba AS (SELECT p.chapter_code ch, SUM(p.budget_ytd) bud, SUM(p.gl_actual_ytd) act FROM prod.dct_budget_actual_period_v p WHERE p.period_name = [COLON]period AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '1' AND p.chapter_code IN ('CH1','CH2','CH3') GROUP BY p.chapter_code), pay AS (SELECT c.chapter_code ch, SUM(c.cf_amount) amt FROM prod.dct_gl_cashflow_v c WHERE c.cf_type = 'APPROVED' AND c.budget_year = !'
        || l_yr || q'! AND c.budget_group_code = '1' AND TO_DATE(c.accounting_period,'MM-YYYY') <= TO_DATE([COLON]period,'MM-YYYY') GROUP BY c.chapter_code), prj AS (SELECT b.chapter chname, SUM(p2.plan_appr_ytd) amt FROM prod.dct_budget_utilization_v b LEFT JOIN prod.dct_gl_coa_snap csb ON csb.cc_string = b.budget_combination JOIN prod.dct_project_cf_butil_v p2 ON p2.budget_year = b.budget_year AND p2.project_number = b.project_number AND p2.task_number = b.task_number AND p2.expenditure_type = b.expenditure_type WHERE b.budget_year = !'
        || l_yr || q'! AND b.chapter IN ('Chapter 2','Chapter 3') GROUP BY b.chapter) SELECT t.code AS type_code, t.name AS type, NVL(ba.bud,0) AS budget, NVL(ba.act,0) AS actual, NVL(pay.amt,0)+NVL(prj.amt,0) AS ytd_plan, CASE WHEN pay.ch IS NOT NULL OR prj.chname IS NOT NULL THEN 'Y' ELSE 'N' END AS has_plan, CASE WHEN NVL(ba.bud,0) <> 0 THEN ROUND(NVL(ba.act,0)*1000/ba.bud)/10 END AS actual_vs_budget_pct FROM typ t LEFT JOIN ba ON ba.ch = t.ch LEFT JOIN pay ON pay.ch = t.ch LEFT JOIN prj ON prj.chname = t.chname ORDER BY t.ord!';

  l_sec := q'!WITH act AS (SELECT NVL(p.sector_code,'UNCLASSIFIED') sector_code, MAX(NVL(p.sector_name,'Unclassified')) sector_name, SUM(p.budget_ytd) budget, SUM(p.gl_actual_ytd) actual FROM prod.dct_budget_actual_period_v p WHERE p.period_name = [COLON]period AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '1' AND p.chapter_code IN ('CH1','CH2','CH3') AND ([COLON]entity IS NULL OR INSTR('|'||[COLON]entity||'|', '|'||(!'
        || l_ecase_p || q'!)||'|') > 0) GROUP BY NVL(p.sector_code,'UNCLASSIFIED')), ccsec AS (SELECT DISTINCT cost_center_code, sector_code FROM prod.dct_gl_coa_snap WHERE sector_code IS NOT NULL), plan_pay AS (SELECT NVL(m.sector_code,'UNCLASSIFIED') sector_code, SUM(c.cf_amount) plan_amt FROM prod.dct_gl_budget_cashflow c LEFT JOIN ccsec m ON m.cost_center_code = c.cost_center_code WHERE c.cf_type = 'APPROVED' AND c.budget_year = !'
        || l_yr || q'! AND c.budget_group_code = '1' AND TO_DATE(c.accounting_period,'MM-YYYY') <= TO_DATE([COLON]period,'MM-YYYY') AND ([COLON]entity IS NULL OR INSTR('|'||[COLON]entity||'|', '|'||(!'
        || l_ecase_c || q'!)||'|') > 0) GROUP BY NVL(m.sector_code,'UNCLASSIFIED')), secname AS (SELECT value_code, name_en FROM prod.dct_gl_class_value WHERE class_type_code = 'SECTOR'), plan_proj AS (SELECT NVL(sn.value_code,'UNCLASSIFIED') sector_code, SUM(p2.plan_appr_ytd) plan_amt FROM prod.dct_budget_utilization_v b LEFT JOIN prod.dct_gl_coa_snap csb ON csb.cc_string = b.budget_combination JOIN prod.dct_project_cf_butil_v p2 ON p2.budget_year = b.budget_year AND p2.project_number = b.project_number AND p2.task_number = b.task_number AND p2.expenditure_type = b.expenditure_type LEFT JOIN secname sn ON sn.name_en = b.sector WHERE b.budget_year = !'
        || l_yr || q'! AND b.chapter IN ('Chapter 2','Chapter 3') AND ([COLON]entity IS NULL OR INSTR('|'||[COLON]entity||'|', '|'||(!'
        || l_ecase_b || q'!)||'|') > 0) GROUP BY NVL(sn.value_code,'UNCLASSIFIED')), plan AS (SELECT sector_code, SUM(plan_amt) plan_amt, MAX('Y') has_plan FROM (SELECT sector_code, plan_amt FROM plan_pay UNION ALL SELECT sector_code, plan_amt FROM plan_proj) GROUP BY sector_code) SELECT a.sector_code, a.sector_name AS sector, NVL(a.budget,0) AS budget, NVL(a.actual,0) AS actual, CASE WHEN NVL(a.budget,0) <> 0 THEN ROUND(NVL(a.actual,0)*1000/a.budget)/10 END AS actual_vs_budget_pct, NVL(pl.plan_amt,0) AS ytd_plan, CASE WHEN NVL(pl.plan_amt,0) <> 0 THEN ROUND(NVL(a.actual,0)*1000/pl.plan_amt)/10 END AS actual_vs_plan_pct, NVL(pl.has_plan,'N') AS has_plan FROM act a LEFT JOIN plan pl ON pl.sector_code = a.sector_code ORDER BY CASE WHEN pl.plan_amt IS NOT NULL AND pl.plan_amt <> 0 THEN ROUND(a.actual*1000/pl.plan_amt)/10 END DESC NULLS LAST, a.actual DESC!';

  l_not := q'!SELECT CASE n.note_type WHEN 'CURRENT_VARIANCE' THEN 'Current Month Variances' ELSE 'Expected Variances' END AS commentary, n.note_text AS note, NVL(u.display_name, n.updated_by) AS updated_by, TO_CHAR(prod.dct_to_local(n.updated_at),'YYYY-MM-DD HH'||CHR(58)||'MI AM') AS updated_on FROM prod.dct_gl_fmr_note n LEFT JOIN prod.dct_users u ON UPPER(u.username) = UPPER(n.updated_by) WHERE n.accounting_period = [COLON]period ORDER BY n.note_type!';

  l_src := '{"required":["period"],"orientation":"landscape",'
        || '"pre_sql":"BEGIN prod.dct_gl_class_pkg.set_butil_end(LAST_DAY(TO_DATE(''01-''||[COLON]period,''DD-MM-YYYY''))); END;",'
        || '"post_sql":"BEGIN prod.dct_gl_class_pkg.clear_butil_end; END;",'
        || '"sections":['
        || '{"key":"overall","title":"Budget Overview - KPIs","layout":"table","sql":"' || l_ovr || '"}' || ','
        || '{"key":"entities","title":"Entity Level","layout":"table","sql":"' || l_ent || '"}' || ','
        || '{"key":"trend","title":"YTD Trend by Type","layout":"table","sql":"' || l_trd || '"}' || ','
        || '{"key":"sectors","title":"Sector Level","layout":"table","sql":"' || l_sec || '"}' || ','
        || '{"key":"notes","title":"Commentary","layout":"table","sql":"' || l_not || '"}'
        || ']}';
  l_src := REPLACE(l_src, '[COLON]', CHR(58));

  l_spec := '{'
    || '"period":{"label":"Accounting period","label_ar":UNQ1,"hint":"MM-YYYY, e.g. 08-2026. Figures are YTD to this period.","required":true,'
    || '"lov_sql":"SELECT period_name AS d, period_name AS r FROM prod.dct_budget_actual_period_v GROUP BY period_name, TO_DATE(period_name,''MM-YYYY'') ORDER BY TO_DATE(period_name,''MM-YYYY'') DESC"},'
    || '"entity":{"label":"Entity","label_ar":UNQ2,"hint":"Optional, sector section only. Pipe separated any-of: DCT|ALC|MUSEUMS|MASTERPIECES. Blank = all entities.","required":false}'
    || '}';
  l_spec := REPLACE(l_spec, 'UNQ1', '"' || UNISTR('\0627\0644\0641\062A\0631\0629 \0627\0644\0645\062D\0627\0633\0628\064A\0629') || '"');
  l_spec := REPLACE(l_spec, 'UNQ2', '"' || UNISTR('\0627\0644\062C\0647\0629') || '"');

  l_body :=
    '<p>Dear {{ recipient_name }},</p>'||
    '<p>The <strong>Financial Performance Report - Budget Overview</strong> is attached: '||
    'entity-level KPIs (DCT / ALC / Museums / Masterpieces), the YTD trend by Payroll, Opex '||
    'and Capex, the sector-level split and the variance commentary for the selected period.</p>'||
    '<p>Prepared by Financial Planning and Budgeting, Finance Department. '||
    'Generated {{ generated_at }} by i-Finance Reporting.</p>';

  l_desc := 'The GL Financial Performance Report / Budget Overview page as a generated report '||
    '(FMR_Dashboard layout): the five entity-level KPIs, the DCT / ALC / Museums / Masterpieces '||
    'entity split with Actual-vs-Budget gauges, the YTD Payroll-Opex-Capex trend (Budget, Actual, '||
    'YTD Plan), the sector-level split ranked by Actual vs Plan, and the Current Month / Expected '||
    'variance commentary. Scope = Budget Group 1, Chapters 1-3, figures YTD to the selected period. '||
    'PDF = landscape book (gl_fmr_book.html.j2); Excel = sheet per section; PowerPoint = executive deck.';

  SELECT COUNT(*) INTO l_n FROM prod.dct_rpt_definition WHERE report_code = 'GL_FMR_REPORT';
  IF l_n = 0 THEN
    INSERT INTO prod.dct_rpt_definition
      (report_code, name_en, name_ar, description, category, source_type, source_ref, engine,
       default_formats, pdf_template, email_subject_tpl, email_body_tpl, params_json,
       param_spec_json, enabled, created_by, updated_by)
    VALUES
      ('GL_FMR_REPORT',
       'Financial Performance Report - Budget Overview',
       UNISTR('\062A\0642\0631\064A\0631 \0627\0644\0623\062F\0627\0621 \0627\0644\0645\0627\0644\064A'),
       l_desc,
       'General Ledger', 'MULTI', l_src, 'PYTHON', 'PDF',
       'gl_fmr_book.html.j2',
       'Financial Performance Report - Budget Overview',
       l_body,
       '{}',
       l_spec,
       'Y', 'SETUP', 'SETUP');
  ELSE
    UPDATE prod.dct_rpt_definition SET
       source_type       = 'MULTI',
       description       = l_desc,
       source_ref        = l_src,
       engine            = 'PYTHON',
       default_formats   = 'PDF',
       pdf_template      = 'gl_fmr_book.html.j2',
       email_subject_tpl = 'Financial Performance Report - Budget Overview',
       email_body_tpl    = l_body,
       params_json       = '{}',
       param_spec_json   = l_spec,
       updated_by        = 'SETUP',
       updated_at        = SYSTIMESTAMP
     WHERE report_code = 'GL_FMR_REPORT';
  END IF;

  SELECT COUNT(*) INTO l_n FROM prod.dct_rpt_recipient
   WHERE report_code = 'GL_FMR_REPORT' AND recipient_type = 'SELF';
  IF l_n = 0 THEN
    INSERT INTO prod.dct_rpt_recipient
      (report_code, recipient_type, recipient_ref, channel, enabled, created_by, updated_by)
    VALUES ('GL_FMR_REPORT', 'SELF', NULL, 'EMAIL', 'Y', 'SETUP', 'SETUP');
  END IF;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('GL_FMR_REPORT seeded (definition + SELF recipient).');
END;
/

PROMPT === 2. Verify ===
SELECT report_code, source_type, engine, default_formats, pdf_template,
       CASE WHEN source_ref IS JSON THEN 'SRC OK' ELSE 'SRC BAD' END AS src_ok,
       CASE WHEN param_spec_json IS JSON THEN 'SPEC OK' ELSE 'SPEC BAD' END AS spec_ok
FROM prod.dct_rpt_definition
WHERE report_code = 'GL_FMR_REPORT';

PROMPT ============================================================
PROMPT  40_rpt_gl_fmr_report.sql complete (GL_FMR_REPORT).
PROMPT ============================================================
