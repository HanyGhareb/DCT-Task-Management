-- =============================================================================
-- General Ledger (App 210) -- Reconciliation ORDS endpoints (ADDITIVE)
-- File    : 14_gl_recon_ords.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp @14_gl_recon_ords.sql   (fresh session)
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            re-run THIS script right after it. Post-05 re-run list = 07..14.
-- Source  : prod.dct_gl_recon_fact_v + prod.dct_gl_recon_glbudget_v (db/v2/105)
--           + prod.dct_budget_utilization_v (PPM budget side, db/v2/37).
-- Security: reuses the GL_VIEW_BUDGET_UTILIZATION privilege (reconciliation is
--           part of the Budget Utilization surface) + SECTOR data scoping.
--
-- Endpoints (all read the SAME filter set: year [req], period MM-YYYY [YTD],
--   + pipe-delimited multi-select sector/chapter/glaccount/costcenter/
--   appropriation/program, all code-based against the COA snapshot; period sets
--   SYS_CONTEXT('GL_CTX','BUTIL_END') so BOTH dashboards align to the period):
--
--   GET /gl/recon/filters -> years, periods, budgetChapters default (CH2..CH5),
--       + code+label LOVs for every dimension (from the COA snapshot).
--   GET /gl/recon/summary -> per-measure {actuals, butil, diff, noProject,
--       apValidation, noBudgetLine} for AP/GRN/PR/PO + derived totals + GL
--       budget (Expense scoped to budgetchapters) vs PPM budget + fund
--       available each side. Drives the KPI/status cards + charts.
--   GET /gl/recon/rows?grain= -> the register at a chosen grain
--       (account|sector|chapter|costcenter|appropriation|program|combination|
--        budgetline); one row per dimension value with both sides + leakage
--       buckets + budgets, so every difference is drillable.
--   GET /gl/recon/drill?measure=&bucket=&grain=&key= (or project/task/etype)
--       -> the SOURCE records behind a difference: the AP/GRN/PR/PO documents
--       in that dimension cell and leakage bucket (no_project = "combination
--       with no project/task/etype", ap_validation, no_budget_line, matched,
--       all). Rows carry doc #/line + project/task/etype + why-excluded flags.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_recon_ords_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'gl.rest';

    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => p_pattern);
    END;

    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => p_pattern,
            p_method      => p_method,
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;

BEGIN

    -- =========================================================================
    -- FILTERS
    -- =========================================================================
    def_template('recon/filters');
    def_handler('recon/filters', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_dy   NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  SELECT MAX(budget_year) INTO l_dy FROM prod.dct_budget_utilization_v;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('defaultYear', l_dy);
  APEX_JSON.open_array('years');
  FOR r IN (SELECT DISTINCT budget_year y FROM prod.dct_budget_utilization_v ORDER BY budget_year DESC) LOOP
    APEX_JSON.write(r.y);
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('periods');
  FOR r IN (SELECT DISTINCT period_name p FROM prod.gl_balances WHERE period_name IS NOT NULL
            ORDER BY TO_DATE(period_name,'MM-YYYY')) LOOP
    APEX_JSON.write(r.p);
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('budgetChapters');
  APEX_JSON.write('CH2'); APEX_JSON.write('CH3'); APEX_JSON.write('CH4'); APEX_JSON.write('CH5');
  APEX_JSON.close_array;
  APEX_JSON.open_array('sectors');
  FOR r IN (SELECT DISTINCT sector_name s FROM prod.dct_gl_coa_snap WHERE sector_name IS NOT NULL ORDER BY 1) LOOP
    APEX_JSON.write(r.s);
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('chapters');
  FOR r IN (SELECT chapter_code c, MAX(chapter_name) n FROM prod.dct_gl_coa_snap
            WHERE chapter_code IS NOT NULL GROUP BY chapter_code ORDER BY 1) LOOP
    APEX_JSON.open_object; APEX_JSON.write('code',r.c); APEX_JSON.write('name',NVL(r.n,r.c)); APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('glAccounts');
  FOR r IN (SELECT account_code c, MAX(account_desc) d FROM prod.dct_gl_coa_snap
            WHERE account_code IS NOT NULL GROUP BY account_code ORDER BY 1) LOOP
    APEX_JSON.open_object; APEX_JSON.write('code',r.c); APEX_JSON.write('desc',NVL(r.d,'')); APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('costCenters');
  FOR r IN (SELECT cost_center_code c, MAX(cost_center_desc) d FROM prod.dct_gl_coa_snap
            WHERE cost_center_code IS NOT NULL GROUP BY cost_center_code ORDER BY 1) LOOP
    APEX_JSON.open_object; APEX_JSON.write('code',r.c); APEX_JSON.write('desc',NVL(r.d,'')); APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('appropriations');
  FOR r IN (SELECT appropriation_code c, MAX(appropriation_desc) d FROM prod.dct_gl_coa_snap
            WHERE appropriation_code IS NOT NULL GROUP BY appropriation_code ORDER BY 1) LOOP
    APEX_JSON.open_object; APEX_JSON.write('code',r.c); APEX_JSON.write('desc',NVL(r.d,'')); APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('programs');
  FOR r IN (SELECT program_code c, MAX(program_name) d FROM prod.dct_gl_coa_snap
            WHERE program_code IS NOT NULL GROUP BY program_code ORDER BY 1) LOOP
    APEX_JSON.open_object; APEX_JSON.write('code',r.c); APEX_JSON.write('desc',NVL(r.d,'')); APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- SUMMARY -- per-measure both-sides + leakage + budgets + fund available
    -- =========================================================================
    def_template('recon/summary');
    def_handler('recon/summary', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_uid    NUMBER := dct_auth.get_user_id(l_user);
  l_secok  NUMBER := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  l_year   NUMBER := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_period VARCHAR2(10)   := [COLON]period;
  l_sector VARCHAR2(2000) := [COLON]sector;
  l_chap   VARCHAR2(2000) := [COLON]chapter;
  l_acct   VARCHAR2(2000) := [COLON]glaccount;
  l_cc     VARCHAR2(2000) := [COLON]costcenter;
  l_appr   VARCHAR2(2000) := [COLON]appropriation;
  l_prog   VARCHAR2(2000) := [COLON]program;
  l_bchap  VARCHAR2(400)  := NVL([COLON]budgetchapters, 'CH2|CH3|CH4|CH5');
  l_end    DATE;
  l_glbud  NUMBER := 0; l_ppmbud NUMBER := 0;
  ap_a NUMBER:=0; ap_b NUMBER:=0; ap_np NUMBER:=0; ap_av NUMBER:=0; ap_nb NUMBER:=0;
  gr_a NUMBER:=0; gr_b NUMBER:=0; gr_np NUMBER:=0; gr_nb NUMBER:=0;
  pr_a NUMBER:=0; pr_b NUMBER:=0; pr_np NUMBER:=0; pr_nb NUMBER:=0;
  po_a NUMBER:=0; po_b NUMBER:=0; po_np NUMBER:=0; po_nb NUMBER:=0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  IF l_period = '' THEN l_period := NULL; END IF;
  IF l_period IS NOT NULL THEN
    IF NOT REGEXP_LIKE(l_period,'^(0[1-9]|1[0-2])-[0-9]{4}$') OR TO_NUMBER(SUBSTR(l_period,4)) <> l_year THEN
      dct_rest.err(400,'period must be MM-YYYY within the selected year'); RETURN;
    END IF;
    l_end := LAST_DAY(TO_DATE('01-'||l_period,'DD-MM-YYYY'));
  END IF;
  IF l_end IS NOT NULL THEN dct_gl_class_pkg.set_butil_end(l_end); ELSE dct_gl_class_pkg.clear_butil_end; END IF;

  -- consumption bridge (fact honours BUTIL_END internally)
  FOR r IN (
    SELECT measure,
           SUM(amount_aed) act,
           SUM(CASE WHEN in_butil='Y' THEN amount_aed END) but,
           SUM(CASE WHEN bucket='no_project' THEN amount_aed END) np,
           SUM(CASE WHEN bucket='ap_validation' THEN amount_aed END) av,
           SUM(CASE WHEN bucket='no_budget_line' THEN amount_aed END) nb
    FROM prod.dct_gl_recon_fact_v v
    WHERE v.budget_year = l_year
      AND (l_sector IS NULL OR INSTR('|'||l_sector||'|','|'||v.sector_name||'|')>0)
      AND (l_secok = 1 OR v.sector_name IN (SELECT cv.name_en FROM prod.dct_gl_class_value cv JOIN prod.v_dct_sec_user_scope sc ON sc.object_key = cv.value_code AND sc.object_type_code = 'SECTOR' AND sc.user_id = l_uid WHERE cv.class_type_code = 'SECTOR'))
      AND (l_chap IS NULL OR INSTR('|'||l_chap||'|','|'||v.chapter_code||'|')>0)
      AND (l_acct IS NULL OR INSTR('|'||l_acct||'|','|'||v.account_code||'|')>0)
      AND (l_cc   IS NULL OR INSTR('|'||l_cc||'|','|'||v.cost_center_code||'|')>0)
      AND (l_appr IS NULL OR INSTR('|'||l_appr||'|','|'||v.appropriation_code||'|')>0)
      AND (l_prog IS NULL OR INSTR('|'||l_prog||'|','|'||v.program_code||'|')>0)
    GROUP BY measure
  ) LOOP
    IF r.measure='AP' THEN ap_a:=NVL(r.act,0); ap_b:=NVL(r.but,0); ap_np:=NVL(r.np,0); ap_av:=NVL(r.av,0); ap_nb:=NVL(r.nb,0);
    ELSIF r.measure='GRN' THEN gr_a:=NVL(r.act,0); gr_b:=NVL(r.but,0); gr_np:=NVL(r.np,0); gr_nb:=NVL(r.nb,0);
    ELSIF r.measure='PR' THEN pr_a:=NVL(r.act,0); pr_b:=NVL(r.but,0); pr_np:=NVL(r.np,0); pr_nb:=NVL(r.nb,0);
    ELSIF r.measure='PO' THEN po_a:=NVL(r.act,0); po_b:=NVL(r.but,0); po_np:=NVL(r.np,0); po_nb:=NVL(r.nb,0);
    END IF;
  END LOOP;

  -- GL budget (Expense, scoped to budgetchapters), YTD through the period
  SELECT NVL(SUM(total_budget),0) INTO l_glbud
  FROM prod.dct_gl_recon_glbudget_v g
  WHERE g.budget_year = l_year
    AND UPPER(g.account_type) LIKE '%EXPENSE%'
    AND INSTR('|'||l_bchap||'|','|'||g.chapter_code||'|')>0
    AND (l_end IS NULL OR TO_DATE(g.period_name,'MM-YYYY') <= l_end)
    AND (l_sector IS NULL OR INSTR('|'||l_sector||'|','|'||g.sector_name||'|')>0)
    AND (l_secok = 1 OR g.sector_name IN (SELECT cv.name_en FROM prod.dct_gl_class_value cv JOIN prod.v_dct_sec_user_scope sc ON sc.object_key = cv.value_code AND sc.object_type_code = 'SECTOR' AND sc.user_id = l_uid WHERE cv.class_type_code = 'SECTOR'))
    AND (l_chap IS NULL OR INSTR('|'||l_chap||'|','|'||g.chapter_code||'|')>0)
    AND (l_acct IS NULL OR INSTR('|'||l_acct||'|','|'||g.account_code||'|')>0)
    AND (l_cc   IS NULL OR INSTR('|'||l_cc||'|','|'||g.cost_center_code||'|')>0)
    AND (l_appr IS NULL OR INSTR('|'||l_appr||'|','|'||g.appropriation_code||'|')>0)
    AND (l_prog IS NULL OR INSTR('|'||l_prog||'|','|'||g.program_code||'|')>0);

  -- PPM (project) budget -- from Budget Utilization (BUTIL_END-aware). Dimension
  -- filters best-effort against the view's resolved columns (codes embedded in
  -- the formatted gl_account/appropriation/program strings; chapter by name).
  SELECT NVL(SUM(budget),0) INTO l_ppmbud
  FROM prod.dct_budget_utilization_v v
  WHERE v.budget_year = l_year
    AND (l_sector IS NULL OR INSTR('|'||l_sector||'|','|'||v.sector||'|')>0)
    AND (l_secok = 1 OR v.sector IN (SELECT cv.name_en FROM prod.dct_gl_class_value cv JOIN prod.v_dct_sec_user_scope sc ON sc.object_key = cv.value_code AND sc.object_type_code = 'SECTOR' AND sc.user_id = l_uid WHERE cv.class_type_code = 'SECTOR'))
    AND (l_chap IS NULL OR INSTR('|'||l_chap||'|','|CH'||REGEXP_SUBSTR(v.chapter,'[0-9]+')||'|')>0)
    AND (l_cc   IS NULL OR INSTR('|'||l_cc||'|','|'||v.cost_centre||'|')>0)
    AND (l_acct IS NULL OR INSTR('|'||l_acct||'|','|'||REGEXP_SUBSTR(v.gl_account,'^[0-9]+')||'|')>0)
    AND (l_appr IS NULL OR INSTR('|'||l_appr||'|','|'||REGEXP_SUBSTR(v.appropriation,'^[0-9]+')||'|')>0)
    AND (l_prog IS NULL OR INSTR('|'||l_prog||'|','|'||REGEXP_SUBSTR(v.program,'^[0-9]+')||'|')>0);

  dct_gl_class_pkg.clear_butil_end;

  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  IF l_period IS NOT NULL THEN APEX_JSON.write('period', l_period); END IF;
  APEX_JSON.write('budgetChapters', l_bchap);
  APEX_JSON.open_object('measures');
    APEX_JSON.open_object('ap');
      APEX_JSON.write('actuals',ap_a); APEX_JSON.write('butil',ap_b); APEX_JSON.write('diff',ap_a-ap_b);
      APEX_JSON.write('noProject',ap_np); APEX_JSON.write('apValidation',ap_av); APEX_JSON.write('noBudgetLine',ap_nb);
    APEX_JSON.close_object;
    APEX_JSON.open_object('grn');
      APEX_JSON.write('actuals',gr_a); APEX_JSON.write('butil',gr_b); APEX_JSON.write('diff',gr_a-gr_b);
      APEX_JSON.write('noProject',gr_np); APEX_JSON.write('apValidation',0); APEX_JSON.write('noBudgetLine',gr_nb);
    APEX_JSON.close_object;
    APEX_JSON.open_object('pr');
      APEX_JSON.write('actuals',pr_a); APEX_JSON.write('butil',pr_b); APEX_JSON.write('diff',pr_a-pr_b);
      APEX_JSON.write('noProject',pr_np); APEX_JSON.write('apValidation',0); APEX_JSON.write('noBudgetLine',pr_nb);
    APEX_JSON.close_object;
    APEX_JSON.open_object('po');
      APEX_JSON.write('actuals',po_a); APEX_JSON.write('butil',po_b); APEX_JSON.write('diff',po_a-po_b);
      APEX_JSON.write('noProject',po_np); APEX_JSON.write('apValidation',0); APEX_JSON.write('noBudgetLine',po_nb);
    APEX_JSON.close_object;
  APEX_JSON.close_object;
  APEX_JSON.open_object('derived');
    APEX_JSON.write('totalActualActuals', ap_a+gr_a);   APEX_JSON.write('totalActualButil', ap_b+gr_b);
    APEX_JSON.write('totalEncumbranceActuals', pr_a+po_a); APEX_JSON.write('totalEncumbranceButil', pr_b+po_b);
    APEX_JSON.write('noProjectTotal', ap_np+gr_np+pr_np+po_np);
    APEX_JSON.write('apValidationTotal', ap_av);
    APEX_JSON.write('noBudgetLineTotal', ap_nb+gr_nb+pr_nb+po_nb);
    APEX_JSON.write('consumptionActuals', ap_a+gr_a+pr_a+po_a);
    APEX_JSON.write('consumptionButil', ap_b+gr_b+pr_b+po_b);
  APEX_JSON.close_object;
  APEX_JSON.open_object('budget');
    APEX_JSON.write('gl', l_glbud); APEX_JSON.write('ppm', l_ppmbud); APEX_JSON.write('diff', l_glbud-l_ppmbud);
  APEX_JSON.close_object;
  APEX_JSON.open_object('fund');
    APEX_JSON.write('actualsSide', l_glbud - (ap_a+gr_a+pr_a+po_a));
    APEX_JSON.write('butilSide',   l_ppmbud - (ap_b+gr_b+pr_b+po_b));
  APEX_JSON.close_object;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_gl_class_pkg.clear_butil_end; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- ROWS -- register at a chosen grain
    -- =========================================================================
    def_template('recon/rows');
    def_handler('recon/rows', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_uid    NUMBER := dct_auth.get_user_id(l_user);
  l_secok  NUMBER := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  l_year   NUMBER := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_period VARCHAR2(10)   := [COLON]period;
  l_grain  VARCHAR2(20)   := LOWER(NVL([COLON]grain,'account'));
  l_meas   VARCHAR2(8)    := LOWER([COLON]measure);   -- optional: scope to AP/GRN/PR/PO
  l_sector VARCHAR2(2000) := [COLON]sector;
  l_chap   VARCHAR2(2000) := [COLON]chapter;
  l_acct   VARCHAR2(2000) := [COLON]glaccount;
  l_cc     VARCHAR2(2000) := [COLON]costcenter;
  l_appr   VARCHAR2(2000) := [COLON]appropriation;
  l_prog   VARCHAR2(2000) := [COLON]program;
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit DEFAULT NULL ON CONVERSION ERROR),500), 10000);
  l_end    DATE;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  IF l_meas = '' THEN l_meas := NULL; END IF;
  IF l_meas IS NOT NULL AND l_meas NOT IN ('ap','grn','pr','po') THEN dct_rest.err(400,'invalid measure'); RETURN; END IF;
  IF l_grain NOT IN ('account','sector','chapter','costcenter','appropriation','program','combination','budgetline') THEN
    dct_rest.err(400,'invalid grain'); RETURN;
  END IF;
  IF l_period = '' THEN l_period := NULL; END IF;
  IF l_period IS NOT NULL THEN
    IF NOT REGEXP_LIKE(l_period,'^(0[1-9]|1[0-2])-[0-9]{4}$') OR TO_NUMBER(SUBSTR(l_period,4)) <> l_year THEN
      dct_rest.err(400,'period must be MM-YYYY within the selected year'); RETURN;
    END IF;
    l_end := LAST_DAY(TO_DATE('01-'||l_period,'DD-MM-YYYY'));
  END IF;
  IF l_end IS NOT NULL THEN dct_gl_class_pkg.set_butil_end(l_end); ELSE dct_gl_class_pkg.clear_butil_end; END IF;

  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('year', l_year); APEX_JSON.write('grain', l_grain);
  IF l_period IS NOT NULL THEN APEX_JSON.write('period', l_period); END IF;
  APEX_JSON.open_array('rows');
  FOR r IN (
    SELECT
      CASE l_grain
        WHEN 'account'       THEN v.account_code
        WHEN 'sector'        THEN v.sector_name
        WHEN 'chapter'       THEN v.chapter_code
        WHEN 'costcenter'    THEN v.cost_center_code
        WHEN 'appropriation' THEN v.appropriation_code
        WHEN 'program'       THEN v.program_code
        WHEN 'combination'   THEN v.cc_string
        WHEN 'budgetline'    THEN v.project_key||' / '||NVL(v.task_key,'-')||' / '||NVL(v.expenditure_type,'-')
      END AS gkey,
      CASE l_grain
        WHEN 'account'       THEN MAX(v.account_desc)
        WHEN 'sector'        THEN NULL
        WHEN 'chapter'       THEN MAX(v.chapter_name)
        WHEN 'costcenter'    THEN MAX(v.cost_center_desc)
        WHEN 'appropriation' THEN MAX(v.appropriation_desc)
        WHEN 'program'       THEN MAX(v.program_name)
        WHEN 'combination'   THEN MAX(v.account_desc)
        WHEN 'budgetline'    THEN NULL
      END AS glabel,
      SUM(CASE WHEN v.measure='AP'  THEN v.amount_aed END) ap_a,
      SUM(CASE WHEN v.measure='AP'  AND v.in_butil='Y' THEN v.amount_aed END) ap_b,
      SUM(CASE WHEN v.measure='GRN' THEN v.amount_aed END) gr_a,
      SUM(CASE WHEN v.measure='GRN' AND v.in_butil='Y' THEN v.amount_aed END) gr_b,
      SUM(CASE WHEN v.measure='PR'  THEN v.amount_aed END) pr_a,
      SUM(CASE WHEN v.measure='PR'  AND v.in_butil='Y' THEN v.amount_aed END) pr_b,
      SUM(CASE WHEN v.measure='PO'  THEN v.amount_aed END) po_a,
      SUM(CASE WHEN v.measure='PO'  AND v.in_butil='Y' THEN v.amount_aed END) po_b,
      SUM(CASE WHEN v.bucket='no_project'     THEN v.amount_aed END) np,
      SUM(CASE WHEN v.bucket='ap_validation'  THEN v.amount_aed END) av,
      SUM(CASE WHEN v.bucket='no_budget_line' THEN v.amount_aed END) nb,
      SUM(v.amount_aed) act_all,
      SUM(CASE WHEN v.in_butil='Y' THEN v.amount_aed END) but_all
    FROM prod.dct_gl_recon_fact_v v
    WHERE v.budget_year = l_year
      AND (l_sector IS NULL OR INSTR('|'||l_sector||'|','|'||v.sector_name||'|')>0)
      AND (l_secok = 1 OR v.sector_name IN (SELECT cv.name_en FROM prod.dct_gl_class_value cv JOIN prod.v_dct_sec_user_scope sc ON sc.object_key = cv.value_code AND sc.object_type_code = 'SECTOR' AND sc.user_id = l_uid WHERE cv.class_type_code = 'SECTOR'))
      AND (l_chap IS NULL OR INSTR('|'||l_chap||'|','|'||v.chapter_code||'|')>0)
      AND (l_acct IS NULL OR INSTR('|'||l_acct||'|','|'||v.account_code||'|')>0)
      AND (l_cc   IS NULL OR INSTR('|'||l_cc||'|','|'||v.cost_center_code||'|')>0)
      AND (l_appr IS NULL OR INSTR('|'||l_appr||'|','|'||v.appropriation_code||'|')>0)
      AND (l_prog IS NULL OR INSTR('|'||l_prog||'|','|'||v.program_code||'|')>0)
      AND (l_meas IS NULL OR v.measure = UPPER(l_meas))
    GROUP BY
      CASE l_grain
        WHEN 'account'       THEN v.account_code
        WHEN 'sector'        THEN v.sector_name
        WHEN 'chapter'       THEN v.chapter_code
        WHEN 'costcenter'    THEN v.cost_center_code
        WHEN 'appropriation' THEN v.appropriation_code
        WHEN 'program'       THEN v.program_code
        WHEN 'combination'   THEN v.cc_string
        WHEN 'budgetline'    THEN v.project_key||' / '||NVL(v.task_key,'-')||' / '||NVL(v.expenditure_type,'-')
      END
    ORDER BY ABS(SUM(v.amount_aed) - SUM(CASE WHEN v.in_butil='Y' THEN v.amount_aed END)) DESC NULLS LAST
    FETCH FIRST l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('key', NVL(r.gkey,'(unmapped)'));
    APEX_JSON.write('label', NVL(r.glabel,''));
    APEX_JSON.write('apAct', NVL(r.ap_a,0)); APEX_JSON.write('apBut', NVL(r.ap_b,0));
    APEX_JSON.write('grnAct', NVL(r.gr_a,0)); APEX_JSON.write('grnBut', NVL(r.gr_b,0));
    APEX_JSON.write('prAct', NVL(r.pr_a,0)); APEX_JSON.write('prBut', NVL(r.pr_b,0));
    APEX_JSON.write('poAct', NVL(r.po_a,0)); APEX_JSON.write('poBut', NVL(r.po_b,0));
    APEX_JSON.write('noProject', NVL(r.np,0));
    APEX_JSON.write('apValidation', NVL(r.av,0));
    APEX_JSON.write('noBudgetLine', NVL(r.nb,0));
    APEX_JSON.write('actualsSide', NVL(r.act_all,0));
    APEX_JSON.write('butilSide', NVL(r.but_all,0));
    APEX_JSON.write('diff', NVL(r.act_all,0)-NVL(r.but_all,0));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
  dct_gl_class_pkg.clear_butil_end;
EXCEPTION WHEN OTHERS THEN dct_gl_class_pkg.clear_butil_end; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- DRILL -- the SOURCE records behind a difference cell.
    --   GET /gl/recon/drill?year=&measure=ap|grn|pr|po&bucket=&grain=&key=
    --       [&project=&task=&etype=] [&period=] + the same dim filters.
    --   bucket in all | no_project | ap_validation | no_budget_line | matched.
    --   Generic doc rows: docType/docNumber/docLine/docDate/party/description +
    --   project/task/etype + amount + hasProject/validation/onBudgetLine +
    --   linkId (Fusion header id). {measure,bucket,total,count,columns[],rows[]}.
    -- =========================================================================
    def_template('recon/drill');
    def_handler('recon/drill', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_uid    NUMBER := dct_auth.get_user_id(l_user);
  l_secok  NUMBER := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  l_year   NUMBER := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_meas   VARCHAR2(8)    := LOWER([COLON]measure);
  l_bucket VARCHAR2(20)   := LOWER(NVL([COLON]bucket,'all'));
  l_grain  VARCHAR2(20)   := LOWER([COLON]grain);
  l_key    VARCHAR2(200)  := [COLON]key;
  l_project VARCHAR2(120) := [COLON]project;
  l_task    VARCHAR2(120) := [COLON]task;
  l_etype   VARCHAR2(255) := [COLON]etype;
  l_period VARCHAR2(10)   := [COLON]period;
  l_sector VARCHAR2(2000) := [COLON]sector;
  l_chap   VARCHAR2(2000) := [COLON]chapter;
  l_acct   VARCHAR2(2000) := [COLON]glaccount;
  l_cc     VARCHAR2(2000) := [COLON]costcenter;
  l_appr   VARCHAR2(2000) := [COLON]appropriation;
  l_prog   VARCHAR2(2000) := [COLON]program;
  l_end    DATE;
  l_total  NUMBER := 0; l_count NUMBER := 0;
  PROCEDURE col(k VARCHAR2, l VARCHAR2, t VARCHAR2) IS
  BEGIN APEX_JSON.open_object; APEX_JSON.write('key',k); APEX_JSON.write('label',l); APEX_JSON.write('type',t); APEX_JSON.close_object; END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  IF l_year IS NULL OR l_meas NOT IN ('ap','grn','pr','po') THEN dct_rest.err(400,'year and measure(ap|grn|pr|po) required'); RETURN; END IF;
  IF l_grain = '' THEN l_grain := NULL; END IF;
  IF l_key = '' THEN l_key := NULL; END IF;
  IF l_project = '' THEN l_project := NULL; END IF;
  IF l_task = '' THEN l_task := NULL; END IF;
  IF l_etype = '' THEN l_etype := NULL; END IF;
  IF l_period = '' THEN l_period := NULL; END IF;
  IF l_period IS NOT NULL THEN
    IF NOT REGEXP_LIKE(l_period,'^(0[1-9]|1[0-2])-[0-9]{4}$') OR TO_NUMBER(SUBSTR(l_period,4)) <> l_year THEN
      dct_rest.err(400,'period must be MM-YYYY within the selected year'); RETURN;
    END IF;
    l_end := LAST_DAY(TO_DATE('01-'||l_period,'DD-MM-YYYY'));
  END IF;

  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('measure', l_meas); APEX_JSON.write('bucket', l_bucket);
  APEX_JSON.open_array('columns');
    col('docNumber', CASE l_meas WHEN 'ap' THEN 'Invoice #' WHEN 'grn' THEN 'GRN #' WHEN 'pr' THEN 'PR #' ELSE 'PO #' END,'text');
    col('docLine','Line','text'); col('docDate','Date','date'); col('party','Vendor / Supplier','text');
    col('project','Project','text'); col('task','Task','text'); col('etype','Expenditure type','text');
    col('amount','Amount (AED)','money');
    col('hasProject','Project?','text'); col('validation','Validation','text'); col('onBudgetLine','On budget line?','text');
    col('description','Description','text');
  APEX_JSON.close_array;
  APEX_JSON.open_array('rows');
  FOR r IN (
    WITH bl AS (
      SELECT b.budget_year,
             COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(b.project_id)) project_key,
             COALESCE(tk.task_number,'#'||TO_CHAR(b.task_id)) task_key, b.expenditure_type
      FROM prod.projects_budget b
      LEFT JOIN (SELECT project_id, MAX(project_number) project_number FROM prod.projects GROUP BY project_id) pj ON pj.project_id=b.project_id
      LEFT JOIN (SELECT task_id, MAX(task_number) task_number FROM prod.tasks GROUP BY task_id) tk ON tk.task_id=b.task_id
      WHERE b.budget_year=l_year
      GROUP BY b.budget_year, COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(b.project_id)),
               COALESCE(tk.task_number,'#'||TO_CHAR(b.task_id)), b.expenditure_type
      HAVING SUM(b.budget)>0 ),
    proj AS (SELECT project_id, MAX(project_number) project_number FROM prod.projects GROUP BY project_id),
    tsk  AS (SELECT task_id, MAX(task_number) task_number FROM prod.tasks GROUP BY task_id),
    po_dist AS (SELECT po_distribution_id, prod.dct_cc_canon(MAX(charge_account)) charge_account, MAX(po_header_id) po_header_id,
                       MAX(project_id) project_id, MAX(task_id) task_id, MAX(expenditure_type_name) expenditure_type,
                       MAX(budget_date) budget_date, MAX(distribution_amount*NVL(rate,1)) amt_aed, MAX(funds_status) funds_status
                FROM prod.po_distributions GROUP BY po_distribution_id),
    hs AS (SELECT po_header_id, MAX(status) po_status FROM prod.po_headers GROUP BY po_header_id),
    gpd AS (SELECT po_distribution_id, SUM(ledger_amount) grn_aed FROM prod.grn_all_v2
            WHERE (l_end IS NULL OR NVL(accounted_date,transaction_date) < l_end+1) GROUP BY po_distribution_id),
    src AS (
      -- AP
      SELECT 'AP' doctype, i.invoice_number docnum, TO_CHAR(d.line_number) docline,
             TO_CHAR(i.invoice_date,'YYYY-MM-DD') docdate, se.supplier_name party, d.distribution_description descr,
             COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(d.project_id)) pkey,
             COALESCE(tk.task_number, CASE WHEN d.task_id IS NOT NULL THEN '#'||TO_CHAR(d.task_id) END) tkey,
             d.expenditure_type etype, NVL(d.distribution_amount_functi,d.distribution_amount) amt,
             CASE WHEN d.project_id IS NOT NULL THEN 'Y' ELSE 'N' END hasproject,
             i.validation_status validation,
             CASE WHEN i.validation_status IN ('Validated','Unpaid','Available') THEN 'Y' ELSE 'N' END apvalid,
             i.invoice_id linkid,
             coa.account_code, coa.sector_name, coa.chapter_code, coa.cost_center_code, coa.appropriation_code, coa.program_code, coa.cc_string,
             d.project_id, d.task_id
      FROM prod.ap_invoice_distributions d
      JOIN prod.ap_invoices i ON i.invoice_id=d.invoice_id
      JOIN prod.dct_gl_coa_snap coa ON coa.cc_id=d.cc_id
      LEFT JOIN prod.dct_ap_supplier_eff_v se ON se.invoice_id=d.invoice_id
      LEFT JOIN proj pj ON pj.project_id=d.project_id
      LEFT JOIN tsk tk ON tk.task_id=d.task_id
      WHERE l_meas='ap' AND d.po_number IS NULL AND NVL(d.reversal_indicator,'N')<>'Y'
        AND EXTRACT(YEAR FROM d.accounting_date)=l_year AND (l_end IS NULL OR d.accounting_date < l_end+1)
      UNION ALL
      -- GRN
      SELECT 'GRN', TO_CHAR(g.receipt_number), TO_CHAR(g.receipt_line_number),
             TO_CHAR(NVL(g.accounted_date,g.transaction_date),'YYYY-MM-DD'), ph.supplier_name, NULL,
             COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(g.project_id)),
             COALESCE(tk.task_number, CASE WHEN g.task_id IS NOT NULL THEN '#'||TO_CHAR(g.task_id) END),
             g.expenditure_type, g.ledger_amount,
             CASE WHEN g.project_id IS NOT NULL THEN 'Y' ELSE 'N' END, 'N/A', 'Y', g.po_header_id,
             coa.account_code, coa.sector_name, coa.chapter_code, coa.cost_center_code, coa.appropriation_code, coa.program_code, pod.charge_account cc_string,
             g.project_id, g.task_id
      FROM prod.grn_all_v2 g
      JOIN po_dist pod ON pod.po_distribution_id=g.po_distribution_id
      LEFT JOIN prod.dct_gl_coa_snap coa ON coa.cc_string=pod.charge_account
      LEFT JOIN (SELECT po_header_id, MAX(supplier_name) supplier_name FROM prod.po_headers GROUP BY po_header_id) ph ON ph.po_header_id=g.po_header_id
      LEFT JOIN proj pj ON pj.project_id=g.project_id
      LEFT JOIN tsk tk ON tk.task_id=g.task_id
      WHERE l_meas='grn' AND pod.charge_account IS NOT NULL
        AND EXTRACT(YEAR FROM NVL(g.accounted_date,g.transaction_date))=l_year
        AND (l_end IS NULL OR NVL(g.accounted_date,g.transaction_date) < l_end+1)
      UNION ALL
      -- PR
      SELECT 'PR', TO_CHAR(d.requisition), NULL, TO_CHAR(d.budget_date,'YYYY-MM-DD'), NULL, h.description,
             COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(d.project_id)),
             COALESCE(tk.task_number, CASE WHEN d.task_id IS NOT NULL THEN '#'||TO_CHAR(d.task_id) END),
             d.expenditure_type, d.distribution_amount*NVL(cc.exchange_rate_to_aed,1),
             CASE WHEN d.project_id IS NOT NULL THEN 'Y' ELSE 'N' END, 'N/A', 'Y', d.pr_header_id,
             coa.account_code, coa.sector_name, coa.chapter_code, coa.cost_center_code, coa.appropriation_code, coa.program_code, prod.dct_cc_canon(d.charge_account) cc_string,
             d.project_id, d.task_id
      FROM prod.pr_distributions d
      LEFT JOIN (SELECT pr_header_id, MAX(description) description FROM prod.pr_headers GROUP BY pr_header_id) h ON h.pr_header_id=d.pr_header_id
      LEFT JOIN prod.dct_currency_codes cc ON cc.currency_code=d.currency_code
      LEFT JOIN prod.dct_gl_coa_snap coa ON coa.cc_string=prod.dct_cc_canon(d.charge_account)
      LEFT JOIN proj pj ON pj.project_id=d.project_id
      LEFT JOIN tsk tk ON tk.task_id=d.task_id
      WHERE l_meas='pr' AND d.funds_status='Reserved' AND d.charge_account IS NOT NULL
        AND EXTRACT(YEAR FROM d.budget_date)=l_year AND (l_end IS NULL OR d.budget_date < l_end+1)
      UNION ALL
      -- PO
      SELECT 'PO', TO_CHAR(ph.order_number), NULL, TO_CHAR(b.budget_date,'YYYY-MM-DD'), ph.supplier_name, NULL,
             COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(b.project_id)),
             COALESCE(tk.task_number, CASE WHEN b.task_id IS NOT NULL THEN '#'||TO_CHAR(b.task_id) END),
             b.expenditure_type, GREATEST(b.amt_aed - NVL(g.grn_aed,0),0),
             CASE WHEN b.project_id IS NOT NULL THEN 'Y' ELSE 'N' END, 'N/A', 'Y', b.po_header_id,
             coa.account_code, coa.sector_name, coa.chapter_code, coa.cost_center_code, coa.appropriation_code, coa.program_code, b.charge_account cc_string,
             b.project_id, b.task_id
      FROM po_dist b
      LEFT JOIN gpd g ON g.po_distribution_id=b.po_distribution_id
      LEFT JOIN hs ON hs.po_header_id=b.po_header_id
      LEFT JOIN prod.dct_gl_coa_snap coa ON coa.cc_string=b.charge_account
      LEFT JOIN (SELECT po_header_id, MAX(order_number) order_number, MAX(supplier_name) supplier_name FROM prod.po_headers GROUP BY po_header_id) ph ON ph.po_header_id=b.po_header_id
      LEFT JOIN proj pj ON pj.project_id=b.project_id
      LEFT JOIN tsk tk ON tk.task_id=b.task_id
      WHERE l_meas='po' AND b.funds_status IN ('Reserved','Partially Liquidated')
        AND NVL(hs.po_status,'x')<>'Finally Closed' AND b.charge_account IS NOT NULL
        AND EXTRACT(YEAR FROM b.budget_date)=l_year AND (l_end IS NULL OR b.budget_date < l_end+1)
    )
    SELECT s.*,
           CASE WHEN bl.project_key IS NOT NULL THEN 'Y' ELSE 'N' END onbudget,
           COUNT(*) OVER () full_n, SUM(s.amt) OVER () full_tot
    FROM src s
    LEFT JOIN bl ON bl.project_key=s.pkey AND NVL(bl.task_key,'~')=NVL(s.tkey,'~')
                AND NVL(bl.expenditure_type,'~')=NVL(s.etype,'~')
    WHERE NVL(s.amt,0) <> 0
      AND (l_sector IS NULL OR INSTR('|'||l_sector||'|','|'||s.sector_name||'|')>0)
      AND (l_secok = 1 OR s.sector_name IN (SELECT cv.name_en FROM prod.dct_gl_class_value cv JOIN prod.v_dct_sec_user_scope sc ON sc.object_key = cv.value_code AND sc.object_type_code = 'SECTOR' AND sc.user_id = l_uid WHERE cv.class_type_code = 'SECTOR'))
      AND (l_chap IS NULL OR INSTR('|'||l_chap||'|','|'||s.chapter_code||'|')>0)
      AND (l_acct IS NULL OR INSTR('|'||l_acct||'|','|'||s.account_code||'|')>0)
      AND (l_cc   IS NULL OR INSTR('|'||l_cc||'|','|'||s.cost_center_code||'|')>0)
      AND (l_appr IS NULL OR INSTR('|'||l_appr||'|','|'||s.appropriation_code||'|')>0)
      AND (l_prog IS NULL OR INSTR('|'||l_prog||'|','|'||s.program_code||'|')>0)
      AND ( l_grain IS NULL OR l_key IS NULL
         OR (l_grain='account'       AND s.account_code = l_key)
         OR (l_grain='sector'        AND s.sector_name = l_key)
         OR (l_grain='chapter'       AND s.chapter_code = l_key)
         OR (l_grain='costcenter'    AND s.cost_center_code = l_key)
         OR (l_grain='appropriation' AND s.appropriation_code = l_key)
         OR (l_grain='program'       AND s.program_code = l_key)
         OR (l_grain='combination'   AND s.cc_string = l_key)
         OR (l_grain='budgetline'    AND s.pkey = l_project AND NVL(s.tkey,'~')=NVL(l_task,'~') AND NVL(s.etype,'~')=NVL(l_etype,'~')) )
      AND ( l_bucket='all'
         OR (l_bucket='no_project'     AND s.hasproject='N')
         OR (l_bucket='ap_validation'  AND s.hasproject='Y' AND s.apvalid='N')
         OR (l_bucket='no_budget_line' AND s.hasproject='Y' AND s.apvalid='Y' AND bl.project_key IS NULL)
         OR (l_bucket='matched'        AND s.hasproject='Y' AND s.apvalid='Y' AND bl.project_key IS NOT NULL) )
    ORDER BY ABS(s.amt) DESC NULLS LAST FETCH FIRST 5000 ROWS ONLY
  ) LOOP
    l_count := r.full_n; l_total := r.full_tot;
    APEX_JSON.open_object;
    APEX_JSON.write('docNumber', NVL(r.docnum,'')); APEX_JSON.write('docLine', NVL(r.docline,''));
    APEX_JSON.write('docDate', NVL(r.docdate,'')); APEX_JSON.write('party', NVL(r.party,''));
    APEX_JSON.write('project', NVL(r.pkey,'')); APEX_JSON.write('task', NVL(r.tkey,''));
    APEX_JSON.write('etype', NVL(r.etype,'')); APEX_JSON.write('amount', r.amt);
    APEX_JSON.write('hasProject', r.hasproject); APEX_JSON.write('validation', NVL(r.validation,''));
    APEX_JSON.write('onBudgetLine', r.onbudget);
    APEX_JSON.write('description', NVL(r.descr,'')); APEX_JSON.write('linkId', r.linkid);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('total', l_total); APEX_JSON.write('count', l_count);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

END setup_gl_recon_ords_tmp;
/

BEGIN
    setup_gl_recon_ords_tmp;
    COMMIT;
END;
/
DROP PROCEDURE setup_gl_recon_ords_tmp;

PROMPT GL reconciliation ORDS endpoints created (recon/filters, recon/summary, recon/rows).
