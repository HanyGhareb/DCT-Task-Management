-- =============================================================================
-- General Ledger (App 210) -- Sector Financial Performance report (ADDITIVE)
-- File    : 24_gl_sector_perf_ords.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp @24_gl_sector_perf_ords.sql   (fresh session)
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            re-run 07..24 right after it.
-- Purpose : serves the new GL tab "Projects > Sector Performance", whose layout
--           is docs/Reports/GL/Sector Report_October.pdf (4 pages: Business
--           Overview / Budget Overview / Budget Overview-Project Level /
--           Revenue Overview).
-- Data    : prod.dct_sector_perf_v (db/v2/123) which is itself built ON TOP of
--           dct_budget_utilization_v, so budget / actual / encumbrance / funds
--           available reconcile to /gl/butil for the same scope BY
--           CONSTRUCTION. PLAN comes from dct_project_cashflow, revenue from
--           dct_gl_revenue_fact_v + dct_gl_revenue_plan.
-- Params  : year (REQUIRED) - period MM-YYYY (YTD cut-off, drives BUTIL_END) -
--           sector (pipe-delimited any-of) - costcenter i.e. Department
--           (pipe-delimited any-of, or a single contains-match) - kind
--           (expenditure kind, defaults to Opex|Capex which is the source
--           pack's own footnote) - projecttype - bu - plantype.
-- Endpoints:
--   GET    sectorperf/filters      -> every LOV + the sample-data banner state
--   GET    sectorperf              -> page 1 + 2 header: matrix, revenue,
--                                     revenue-to-opex, KPI band, gauges, data
--                                     quality
--   GET    sectorperf/sectors      -> page 3 sector table (expand=Y adds the
--                                     project level under each sector)
--   GET    sectorperf/departments  -> page 2 department series
--   GET    sectorperf/trend        -> cumulative monthly budget / actual / plan
--   GET    sectorperf/revenue      -> page 4 (streams, categories, MTD trend)
--   GET    sectorperf/sample       -> sample-plan status
--   DELETE sectorperf/sample       -> purge the sample plan (GL_MANAGE_PLAN_SAMPLE)
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_secperf_ords_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'gl.rest';

    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;

    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => p_method,
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;

BEGIN

    -- ---------------------------------------------------------------- filters
    def_template('sectorperf/filters');
    def_handler('sectorperf/filters', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
  l_year NUMBER := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_SECTOR_PERFORMANCE', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_SECTOR_PERFORMANCE required'); RETURN;
  END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;

  APEX_JSON.open_array('years');
  FOR r IN (SELECT DISTINCT budget_year y FROM prod.dct_butil_scope_v ORDER BY 1 DESC) LOOP
    APEX_JSON.write(r.y);
  END LOOP;
  APEX_JSON.close_array;

  IF l_year IS NULL THEN
    SELECT MAX(budget_year) INTO l_year FROM prod.dct_butil_scope_v;
  END IF;
  APEX_JSON.write('year', l_year);

  APEX_JSON.open_array('periods');
  FOR i IN 1 .. 12 LOOP
    APEX_JSON.write(TO_CHAR(i,'FM00')||'-'||TO_CHAR(l_year));
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('sectors');
  FOR r IN (SELECT DISTINCT sector s FROM prod.dct_butil_scope_v
            WHERE budget_year = l_year AND sector IS NOT NULL ORDER BY 1) LOOP
    APEX_JSON.write(r.s);
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('departments');
  FOR r IN (SELECT DISTINCT cost_centre cc, department dept FROM prod.dct_butil_scope_v
            WHERE budget_year = l_year AND cost_centre IS NOT NULL ORDER BY 2, 1) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('costCentre', r.cc);
    APEX_JSON.write('department', NVL(r.dept, r.cc));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('kinds');
  FOR r IN (SELECT DISTINCT expenditure_kind k FROM prod.dct_sector_perf_v
            WHERE budget_year = l_year ORDER BY 1) LOOP
    APEX_JSON.write(r.k);
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('projectTypes');
  FOR r IN (SELECT DISTINCT project_type p FROM prod.dct_butil_scope_v
            WHERE budget_year = l_year AND project_type IS NOT NULL ORDER BY 1) LOOP
    APEX_JSON.write(r.p);
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('businessUnits');
  FOR r IN (SELECT DISTINCT business_unit b FROM prod.dct_butil_scope_v
            WHERE budget_year = l_year AND business_unit IS NOT NULL ORDER BY 1) LOOP
    APEX_JSON.write(r.b);
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('planTypes');
  APEX_JSON.write('APPROVED'); APEX_JSON.write('REVISED');
  APEX_JSON.close_array;

  APEX_JSON.write('defaultKinds', 'Opex|Capex');
  APEX_JSON.write('sampleActive', prod.dct_gl_plan_sample_pkg.is_sample_active(l_year));
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- ------------------------------------------------------------- overview
    def_template('sectorperf');
    def_handler('sectorperf', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_uid    NUMBER;
  l_secok  NUMBER := 1;
  l_year   NUMBER         := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_period VARCHAR2(10)   := [COLON]period;
  l_sector VARCHAR2(4000) := [COLON]sector;
  l_cc     VARCHAR2(4000) := [COLON]costcenter;
  l_kind   VARCHAR2(400)  := [COLON]kind;
  l_ptype  VARCHAR2(1000) := [COLON]projecttype;
  l_bu     VARCHAR2(2000) := [COLON]bu;
  l_ptyp   VARCHAR2(30)   := NVL([COLON]plantype, 'APPROVED');
  l_end    DATE;
  o_bud NUMBER := 0; o_act NUMBER := 0; o_pl NUMBER := 0; o_pla NUMBER := 0;
  c_bud NUMBER := 0; c_act NUMBER := 0; c_pl NUMBER := 0; c_pla NUMBER := 0;
  t_bud NUMBER := 0; t_act NUMBER := 0; t_pl NUMBER := 0; t_pla NUMBER := 0;
  t_enc NUMBER := 0; t_fun NUMBER := 0;
  r_bud NUMBER := 0; r_bal NUMBER := 0; r_act NUMBER := 0; r_pl NUMBER := 0; r_pla NUMBER := 0;
  q_lines NUMBER := 0; q_planned NUMBER := 0; q_nosec NUMBER := 0; q_nosecb NUMBER := 0;
  q_orphl NUMBER := 0; q_orpha NUMBER := 0; q_uncat NUMBER := 0;
  FUNCTION pct(p_a NUMBER, p_b NUMBER) RETURN NUMBER IS
  BEGIN
    IF NVL(p_b,0) = 0 THEN RETURN NULL; END IF;
    RETURN ROUND(100 * p_a / p_b, 1);
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_SECTOR_PERFORMANCE', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_SECTOR_PERFORMANCE required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  l_uid   := dct_auth.get_user_id(l_user);
  l_secok := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  IF l_sector = '' THEN l_sector := NULL; END IF;
  IF l_cc     = '' THEN l_cc     := NULL; END IF;
  IF l_ptype  = '' THEN l_ptype  := NULL; END IF;
  IF l_bu     = '' THEN l_bu     := NULL; END IF;
  IF l_period = '' THEN l_period := NULL; END IF;
  IF l_kind IS NULL OR l_kind = '' THEN l_kind := 'Opex|Capex'; END IF;
  IF l_ptyp NOT IN ('APPROVED','REVISED') THEN
    dct_rest.err(400,'plantype must be APPROVED or REVISED'); RETURN;
  END IF;
  IF l_period IS NOT NULL THEN
    IF NOT REGEXP_LIKE(l_period, '^(0[1-9]|1[0-2])-[0-9]{4}$')
       OR TO_NUMBER(SUBSTR(l_period, 4)) <> l_year THEN
      dct_rest.err(400,'period must be MM-YYYY within the selected year'); RETURN;
    END IF;
    l_end := LAST_DAY(TO_DATE('01-'||l_period, 'DD-MM-YYYY'));
    prod.dct_gl_class_pkg.set_butil_end(l_end);
  ELSE
    prod.dct_gl_class_pkg.clear_butil_end;
  END IF;

  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  IF l_period IS NOT NULL THEN APEX_JSON.write('period', l_period); END IF;
  APEX_JSON.write('planType', l_ptyp);
  APEX_JSON.write('kinds', l_kind);
  APEX_JSON.write('sampleActive', prod.dct_gl_plan_sample_pkg.is_sample_active(l_year));
  APEX_JSON.write('sampleBatches', NVL(prod.dct_gl_plan_sample_pkg.sample_batches(l_year), ''));

  -- page 1 matrix: one row per expenditure kind. Every derived value is
  -- computed IN THE CURSOR -- a scalar subquery handed to APEX_JSON.write is an
  -- uncatchable ORDS 555.
  APEX_JSON.open_array('matrix');
  FOR r IN (
    SELECT v.expenditure_kind AS kind,
           SUM(v.budget_annual) AS fy_budget,
           SUM(v.actual_ytd)    AS ytd_actual,
           SUM(CASE WHEN l_ptyp = 'REVISED' THEN v.plan_rev_ytd    ELSE v.plan_ytd    END) AS ytd_plan,
           SUM(CASE WHEN l_ptyp = 'REVISED' THEN v.plan_rev_annual ELSE v.plan_annual END) AS fy_plan,
           SUM(v.encumbrance)   AS enc,
           SUM(NVL(v.fund_available,0)) AS funds,
           COUNT(*) AS lines
    FROM prod.dct_sector_perf_v v
    WHERE v.budget_year = l_year
      AND (l_kind   IS NULL OR INSTR('|'||l_kind||'|',   '|'||v.expenditure_kind||'|') > 0)
      AND (l_sector IS NULL OR INSTR('|'||l_sector||'|', '|'||v.sector||'|') > 0)
      AND (l_ptype  IS NULL OR INSTR('|'||l_ptype||'|',  '|'||v.project_type||'|') > 0)
      AND (l_bu     IS NULL OR INSTR('|'||l_bu||'|',     '|'||v.business_unit||'|') > 0)
      AND (l_cc     IS NULL OR (INSTR(l_cc,'|') = 0 AND v.cost_centre LIKE '%'||l_cc||'%')
                            OR INSTR('|'||l_cc||'|', '|'||v.cost_centre||'|') > 0)
      AND (l_secok = 1 OR v.sector IN (SELECT cv.name_en FROM prod.dct_gl_class_value cv
             JOIN prod.v_dct_sec_user_scope sc ON sc.object_key = cv.value_code
              AND sc.object_type_code = 'SECTOR' AND sc.user_id = l_uid
             WHERE cv.class_type_code = 'SECTOR'))
    GROUP BY v.expenditure_kind
    ORDER BY 2 DESC )
  LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('kind', r.kind);
    APEX_JSON.write('fyBudget', r.fy_budget);
    APEX_JSON.write('ytdActual', r.ytd_actual);
    APEX_JSON.write('ytdPlan', r.ytd_plan);
    APEX_JSON.write('fyPlan', r.fy_plan);
    APEX_JSON.write('encumbrance', r.enc);
    APEX_JSON.write('fundsAvailable', r.funds);
    APEX_JSON.write('lines', r.lines);
    APEX_JSON.write('actualVsBudgetPct', pct(r.ytd_actual, r.fy_budget));
    APEX_JSON.write('targetPct', pct(r.ytd_plan, r.fy_plan));
    APEX_JSON.close_object;
    IF r.kind = 'Opex'  THEN o_bud := r.fy_budget; o_act := r.ytd_actual; o_pl := r.ytd_plan; o_pla := r.fy_plan; END IF;
    IF r.kind = 'Capex' THEN c_bud := r.fy_budget; c_act := r.ytd_actual; c_pl := r.ytd_plan; c_pla := r.fy_plan; END IF;
    t_bud := t_bud + r.fy_budget; t_act := t_act + r.ytd_actual;
    t_pl  := t_pl  + r.ytd_plan;  t_pla := t_pla + r.fy_plan;
    t_enc := t_enc + r.enc;       t_fun := t_fun + r.funds;
    q_lines := q_lines + r.lines;
  END LOOP;
  APEX_JSON.close_array;
!' || q'!
  -- revenue: ACTUAL from the AR distribution extract, PLAN from the revenue
  -- plan table, FY BUDGET from Fusion budgetary control. The Fusion revenue
  -- budget sits on ONE cost centre, so a sector filter can legitimately zero
  -- it while actual and plan stay populated -- both the scoped and unscoped
  -- figures are returned so the page can say so instead of showing a puzzle.
  SELECT NVL(SUM(f.actual_amount),0) INTO r_act
  FROM prod.dct_gl_revenue_fact_v f
  WHERE f.budget_year = l_year
    AND (l_end IS NULL OR f.period_date <= l_end)
    AND (l_sector IS NULL OR INSTR('|'||l_sector||'|', '|'||f.sector||'|') > 0)
    AND (l_cc IS NULL OR (INSTR(l_cc,'|') = 0 AND f.cost_center_code LIKE '%'||l_cc||'%')
                      OR INSTR('|'||l_cc||'|', '|'||f.cost_center_code||'|') > 0);

  SELECT NVL(SUM(CASE WHEN l_end IS NULL OR p.period_date <= l_end THEN p.plan_amount ELSE 0 END),0),
         NVL(SUM(p.plan_amount),0)
    INTO r_pl, r_pla
  FROM prod.dct_gl_revenue_plan p
  LEFT JOIN (SELECT cost_center_code, MAX(sector_name) sector_name
             FROM prod.dct_gl_coa_snap WHERE cost_center_code IS NOT NULL
             GROUP BY cost_center_code) c ON c.cost_center_code = p.cost_center_code
  WHERE p.budget_year = l_year AND p.plan_type = l_ptyp
    AND (l_sector IS NULL OR INSTR('|'||l_sector||'|', '|'||c.sector_name||'|') > 0)
    AND (l_cc IS NULL OR (INSTR(l_cc,'|') = 0 AND p.cost_center_code LIKE '%'||l_cc||'%')
                      OR INSTR('|'||l_cc||'|', '|'||p.cost_center_code||'|') > 0);

  SELECT NVL(SUM(CASE WHEN (l_sector IS NULL OR INSTR('|'||l_sector||'|', '|'||c.sector_name||'|') > 0)
                       AND (l_cc IS NULL OR (INSTR(l_cc,'|') = 0 AND c.cost_center_code LIKE '%'||l_cc||'%')
                                          OR INSTR('|'||l_cc||'|', '|'||c.cost_center_code||'|') > 0)
                      THEN b.total_budget ELSE 0 END),0),
         NVL(SUM(b.total_budget),0)
    INTO r_bud, r_bal
  FROM prod.gl_balances_cc b
  JOIN prod.dct_gl_coa_snap c ON c.cc_string = b.cc_string
  WHERE c.account_type = 'Revenue' AND b.period_name LIKE '%-'||TO_CHAR(l_year);

  APEX_JSON.open_object('revenue');
  APEX_JSON.write('fyBudget', r_bud);
  APEX_JSON.write('fyBudgetAllSectors', r_bal);
  APEX_JSON.write('ytdActual', r_act);
  APEX_JSON.write('ytdPlan', r_pl);
  APEX_JSON.write('fyPlan', r_pla);
  APEX_JSON.write('actualVsBudgetPct', pct(r_act, r_bud));
  APEX_JSON.write('targetPct', pct(r_pl, r_pla));
  APEX_JSON.close_object;

  APEX_JSON.open_object('revenueToOpex');
  APEX_JSON.write('fyTargetPct', pct(r_bud, o_bud));
  APEX_JSON.write('ytdActualPct', pct(r_act, o_act));
  APEX_JSON.close_object;

  -- KPI band (pages 2 and 3) over the SELECTED kinds
  APEX_JSON.open_object('kpi');
  APEX_JSON.write('budget', t_bud);
  APEX_JSON.write('actual', t_act);
  APEX_JSON.write('plan', t_pl);
  APEX_JSON.write('fyPlan', t_pla);
  APEX_JSON.write('encumbrance', t_enc);
  APEX_JSON.write('fundsAvailable', t_fun);
  APEX_JSON.write('actualVsBudgetPct', pct(t_act, t_bud));
  APEX_JSON.write('planVsBudgetPct', pct(t_pl, t_bud));
  APEX_JSON.write('actualVsPlanPct', pct(t_act, t_pl));
  APEX_JSON.write('actualVsPlanAmount', t_act - t_pl);
  APEX_JSON.write('fundsAvailablePct', pct(t_fun, t_bud));
  APEX_JSON.close_object;

  APEX_JSON.open_array('gauges');
  APEX_JSON.open_object;
  APEX_JSON.write('kind','Opex');  APEX_JSON.write('budget',o_bud);
  APEX_JSON.write('actual',o_act); APEX_JSON.write('plan',o_pl);
  APEX_JSON.write('pct', pct(o_act, o_bud)); APEX_JSON.close_object;
  APEX_JSON.open_object;
  APEX_JSON.write('kind','Capex'); APEX_JSON.write('budget',c_bud);
  APEX_JSON.write('actual',c_act); APEX_JSON.write('plan',c_pl);
  APEX_JSON.write('pct', pct(c_act, c_bud)); APEX_JSON.close_object;
  APEX_JSON.close_array;

  -- data quality: a figure that cannot be attributed is SHOWN, never dropped
  SELECT COUNT(*), NVL(SUM(CASE WHEN v.plan_annual <> 0 THEN 1 ELSE 0 END),0),
         NVL(SUM(CASE WHEN v.sector IS NULL THEN 1 ELSE 0 END),0),
         NVL(SUM(CASE WHEN v.sector IS NULL THEN v.budget_annual ELSE 0 END),0)
    INTO q_lines, q_planned, q_nosec, q_nosecb
  FROM prod.dct_sector_perf_v v
  WHERE v.budget_year = l_year
    AND (l_kind IS NULL OR INSTR('|'||l_kind||'|', '|'||v.expenditure_kind||'|') > 0);

  SELECT COUNT(*), NVL(SUM(plan_annual),0) INTO q_orphl, q_orpha
  FROM prod.dct_sector_plan_orphan_v WHERE budget_year = l_year;

  SELECT NVL(SUM(actual_amount),0) INTO q_uncat
  FROM prod.dct_gl_revenue_fact_v
  WHERE budget_year = l_year AND category_code = 'UNCATEGORISED'
    AND (l_end IS NULL OR period_date <= l_end);

  APEX_JSON.open_object('quality');
  APEX_JSON.write('lines', q_lines);
  APEX_JSON.write('plannedLines', q_planned);
  APEX_JSON.write('planCoveragePct', pct(q_planned, q_lines));
  APEX_JSON.write('unmappedSectorLines', q_nosec);
  APEX_JSON.write('unmappedSectorBudget', q_nosecb);
  APEX_JSON.write('orphanPlanLines', q_orphl);
  APEX_JSON.write('orphanPlanAmount', q_orpha);
  APEX_JSON.write('uncategorisedRevenue', q_uncat);
  APEX_JSON.close_object;

  APEX_JSON.close_object;
  prod.dct_gl_class_pkg.clear_butil_end;
EXCEPTION WHEN OTHERS THEN
  prod.dct_gl_class_pkg.clear_butil_end;
  dct_rest.err(500, SQLERRM);
END;
!');

    -- -------------------------------------------------------- sector table
    def_template('sectorperf/sectors');
    def_handler('sectorperf/sectors', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_uid    NUMBER;
  l_secok  NUMBER := 1;
  l_year   NUMBER         := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_period VARCHAR2(10)   := [COLON]period;
  l_sector VARCHAR2(4000) := [COLON]sector;
  l_cc     VARCHAR2(4000) := [COLON]costcenter;
  l_kind   VARCHAR2(400)  := [COLON]kind;
  l_ptype  VARCHAR2(1000) := [COLON]projecttype;
  l_bu     VARCHAR2(2000) := [COLON]bu;
  l_ptyp   VARCHAR2(30)   := NVL([COLON]plantype, 'APPROVED');
  l_level  VARCHAR2(20)   := LOWER(NVL([COLON]level, 'sector'));
  l_end    DATE;
  t_bud NUMBER := 0; t_act NUMBER := 0; t_pl NUMBER := 0;
  t_enc NUMBER := 0; t_fun NUMBER := 0;
  FUNCTION pct(p_a NUMBER, p_b NUMBER) RETURN NUMBER IS
  BEGIN
    IF NVL(p_b,0) = 0 THEN RETURN NULL; END IF;
    RETURN ROUND(100 * p_a / p_b, 1);
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_SECTOR_PERFORMANCE', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_SECTOR_PERFORMANCE required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  IF l_level NOT IN ('sector','project') THEN
    dct_rest.err(400,'level must be sector or project'); RETURN;
  END IF;
  l_uid   := dct_auth.get_user_id(l_user);
  l_secok := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  IF l_sector = '' THEN l_sector := NULL; END IF;
  IF l_cc     = '' THEN l_cc     := NULL; END IF;
  IF l_ptype  = '' THEN l_ptype  := NULL; END IF;
  IF l_bu     = '' THEN l_bu     := NULL; END IF;
  IF l_period = '' THEN l_period := NULL; END IF;
  IF l_kind IS NULL OR l_kind = '' THEN l_kind := 'Opex|Capex'; END IF;
  IF l_period IS NOT NULL THEN
    IF NOT REGEXP_LIKE(l_period, '^(0[1-9]|1[0-2])-[0-9]{4}$')
       OR TO_NUMBER(SUBSTR(l_period, 4)) <> l_year THEN
      dct_rest.err(400,'period must be MM-YYYY within the selected year'); RETURN;
    END IF;
    l_end := LAST_DAY(TO_DATE('01-'||l_period, 'DD-MM-YYYY'));
    prod.dct_gl_class_pkg.set_butil_end(l_end);
  ELSE
    prod.dct_gl_class_pkg.clear_butil_end;
  END IF;

  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  APEX_JSON.write('level', l_level);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT NVL(v.sector,'(Unclassified)') AS sector,
           CASE WHEN l_level = 'project' THEN v.project_number END AS project_number,
           CASE WHEN l_level = 'project' THEN MAX(v.project_name) END AS project_name,
           SUM(v.budget_annual) AS budget,
           SUM(v.actual_ytd)    AS actual,
           SUM(CASE WHEN l_ptyp = 'REVISED' THEN v.plan_rev_ytd ELSE v.plan_ytd END) AS plan,
           SUM(v.encumbrance)   AS enc,
           SUM(NVL(v.fund_available,0)) AS funds
    FROM prod.dct_sector_perf_v v
    WHERE v.budget_year = l_year
      AND (l_kind   IS NULL OR INSTR('|'||l_kind||'|',   '|'||v.expenditure_kind||'|') > 0)
      AND (l_sector IS NULL OR INSTR('|'||l_sector||'|', '|'||v.sector||'|') > 0)
      AND (l_ptype  IS NULL OR INSTR('|'||l_ptype||'|',  '|'||v.project_type||'|') > 0)
      AND (l_bu     IS NULL OR INSTR('|'||l_bu||'|',     '|'||v.business_unit||'|') > 0)
      AND (l_cc     IS NULL OR (INSTR(l_cc,'|') = 0 AND v.cost_centre LIKE '%'||l_cc||'%')
                            OR INSTR('|'||l_cc||'|', '|'||v.cost_centre||'|') > 0)
      AND (l_secok = 1 OR v.sector IN (SELECT cv.name_en FROM prod.dct_gl_class_value cv
             JOIN prod.v_dct_sec_user_scope sc ON sc.object_key = cv.value_code
              AND sc.object_type_code = 'SECTOR' AND sc.user_id = l_uid
             WHERE cv.class_type_code = 'SECTOR'))
    GROUP BY NVL(v.sector,'(Unclassified)'),
             CASE WHEN l_level = 'project' THEN v.project_number END
    ORDER BY 1, 4 DESC )
  LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('sector', r.sector);
    IF l_level = 'project' THEN
      APEX_JSON.write('projectNumber', NVL(r.project_number,''));
      APEX_JSON.write('projectName', NVL(r.project_name,''));
    END IF;
    APEX_JSON.write('budget', r.budget);
    APEX_JSON.write('actual', r.actual);
    APEX_JSON.write('actualVsBudgetPct', pct(r.actual, r.budget));
    APEX_JSON.write('plan', r.plan);
    APEX_JSON.write('actualVsPlanAmount', r.actual - r.plan);
    APEX_JSON.write('encumbrance', r.enc);
    APEX_JSON.write('fundsAvailable', r.funds);
    APEX_JSON.close_object;
    t_bud := t_bud + r.budget; t_act := t_act + r.actual; t_pl := t_pl + r.plan;
    t_enc := t_enc + r.enc;    t_fun := t_fun + r.funds;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_object('total');
  APEX_JSON.write('budget', t_bud);
  APEX_JSON.write('actual', t_act);
  APEX_JSON.write('actualVsBudgetPct', pct(t_act, t_bud));
  APEX_JSON.write('plan', t_pl);
  APEX_JSON.write('actualVsPlanAmount', t_act - t_pl);
  APEX_JSON.write('encumbrance', t_enc);
  APEX_JSON.write('fundsAvailable', t_fun);
  APEX_JSON.close_object;
  APEX_JSON.close_object;
  prod.dct_gl_class_pkg.clear_butil_end;
EXCEPTION WHEN OTHERS THEN
  prod.dct_gl_class_pkg.clear_butil_end;
  dct_rest.err(500, SQLERRM);
END;
!');

    -- --------------------------------------------------------- departments
    def_template('sectorperf/departments');
    def_handler('sectorperf/departments', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_uid    NUMBER;
  l_secok  NUMBER := 1;
  l_year   NUMBER         := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_period VARCHAR2(10)   := [COLON]period;
  l_sector VARCHAR2(4000) := [COLON]sector;
  l_cc     VARCHAR2(4000) := [COLON]costcenter;
  l_kind   VARCHAR2(400)  := [COLON]kind;
  l_ptype  VARCHAR2(1000) := [COLON]projecttype;
  l_bu     VARCHAR2(2000) := [COLON]bu;
  l_ptyp   VARCHAR2(30)   := NVL([COLON]plantype, 'APPROVED');
  l_end    DATE;
  FUNCTION pct(p_a NUMBER, p_b NUMBER) RETURN NUMBER IS
  BEGIN
    IF NVL(p_b,0) = 0 THEN RETURN NULL; END IF;
    RETURN ROUND(100 * p_a / p_b, 1);
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_SECTOR_PERFORMANCE', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_SECTOR_PERFORMANCE required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  l_uid   := dct_auth.get_user_id(l_user);
  l_secok := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  IF l_sector = '' THEN l_sector := NULL; END IF;
  IF l_cc     = '' THEN l_cc     := NULL; END IF;
  IF l_ptype  = '' THEN l_ptype  := NULL; END IF;
  IF l_bu     = '' THEN l_bu     := NULL; END IF;
  IF l_period = '' THEN l_period := NULL; END IF;
  IF l_kind IS NULL OR l_kind = '' THEN l_kind := 'Opex|Capex'; END IF;
  IF l_period IS NOT NULL THEN
    IF NOT REGEXP_LIKE(l_period, '^(0[1-9]|1[0-2])-[0-9]{4}$')
       OR TO_NUMBER(SUBSTR(l_period, 4)) <> l_year THEN
      dct_rest.err(400,'period must be MM-YYYY within the selected year'); RETURN;
    END IF;
    l_end := LAST_DAY(TO_DATE('01-'||l_period, 'DD-MM-YYYY'));
    prod.dct_gl_class_pkg.set_butil_end(l_end);
  ELSE
    prod.dct_gl_class_pkg.clear_butil_end;
  END IF;

  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT NVL(v.department, NVL(v.cost_centre,'(Unclassified)')) AS department,
           MAX(v.cost_centre) AS cost_centre,
           MAX(v.sector)      AS sector,
           SUM(v.budget_annual) AS budget,
           SUM(v.actual_ytd)    AS actual,
           SUM(CASE WHEN l_ptyp = 'REVISED' THEN v.plan_rev_ytd ELSE v.plan_ytd END) AS plan,
           SUM(v.encumbrance)   AS enc
    FROM prod.dct_sector_perf_v v
    WHERE v.budget_year = l_year
      AND (l_kind   IS NULL OR INSTR('|'||l_kind||'|',   '|'||v.expenditure_kind||'|') > 0)
      AND (l_sector IS NULL OR INSTR('|'||l_sector||'|', '|'||v.sector||'|') > 0)
      AND (l_ptype  IS NULL OR INSTR('|'||l_ptype||'|',  '|'||v.project_type||'|') > 0)
      AND (l_bu     IS NULL OR INSTR('|'||l_bu||'|',     '|'||v.business_unit||'|') > 0)
      AND (l_cc     IS NULL OR (INSTR(l_cc,'|') = 0 AND v.cost_centre LIKE '%'||l_cc||'%')
                            OR INSTR('|'||l_cc||'|', '|'||v.cost_centre||'|') > 0)
      AND (l_secok = 1 OR v.sector IN (SELECT cv.name_en FROM prod.dct_gl_class_value cv
             JOIN prod.v_dct_sec_user_scope sc ON sc.object_key = cv.value_code
              AND sc.object_type_code = 'SECTOR' AND sc.user_id = l_uid
             WHERE cv.class_type_code = 'SECTOR'))
    GROUP BY NVL(v.department, NVL(v.cost_centre,'(Unclassified)'))
    ORDER BY 4 DESC )
  LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('department', r.department);
    APEX_JSON.write('costCentre', NVL(r.cost_centre,''));
    APEX_JSON.write('sector', NVL(r.sector,''));
    APEX_JSON.write('budget', r.budget);
    APEX_JSON.write('actual', r.actual);
    APEX_JSON.write('plan', r.plan);
    APEX_JSON.write('encumbrance', r.enc);
    APEX_JSON.write('actualVsBudgetPct', pct(r.actual, r.budget));
    APEX_JSON.write('actualVsPlanPct', pct(r.actual, r.plan));
    APEX_JSON.write('actualVsPlanAmount', r.actual - r.plan);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
  prod.dct_gl_class_pkg.clear_butil_end;
EXCEPTION WHEN OTHERS THEN
  prod.dct_gl_class_pkg.clear_butil_end;
  dct_rest.err(500, SQLERRM);
END;
!');

    -- --------------------------------------------------------------- trend
    def_template('sectorperf/trend');
    def_handler('sectorperf/trend', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_uid    NUMBER;
  l_secok  NUMBER := 1;
  l_year   NUMBER         := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_sector VARCHAR2(4000) := [COLON]sector;
  l_cc     VARCHAR2(4000) := [COLON]costcenter;
  l_kind   VARCHAR2(400)  := [COLON]kind;
  l_ptype  VARCHAR2(1000) := [COLON]projecttype;
  l_bu     VARCHAR2(2000) := [COLON]bu;
  l_ptyp   VARCHAR2(30)   := NVL([COLON]plantype, 'APPROVED');
  l_budget NUMBER := 0;
  l_cact   NUMBER := 0;
  l_cpl    NUMBER := 0;
  TYPE t_n IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
  a_act t_n; a_pl t_n;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_SECTOR_PERFORMANCE', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_SECTOR_PERFORMANCE required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  l_uid   := dct_auth.get_user_id(l_user);
  l_secok := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  IF l_sector = '' THEN l_sector := NULL; END IF;
  IF l_cc     = '' THEN l_cc     := NULL; END IF;
  IF l_ptype  = '' THEN l_ptype  := NULL; END IF;
  IF l_bu     = '' THEN l_bu     := NULL; END IF;
  IF l_kind IS NULL OR l_kind = '' THEN l_kind := 'Opex|Capex'; END IF;
  FOR i IN 1 .. 12 LOOP a_act(i) := 0; a_pl(i) := 0; END LOOP;

  -- the trend is built WITHOUT a period cut-off: the monthly actual view keeps
  -- every month and the page cuts it. Sum(months <= cut) is identical to the
  -- butil actual at that cut-off (asserted in db/v2/123t).
  prod.dct_gl_class_pkg.clear_butil_end;

  SELECT NVL(SUM(v.budget_annual),0) INTO l_budget
  FROM prod.dct_sector_perf_v v
  WHERE v.budget_year = l_year
    AND (l_kind   IS NULL OR INSTR('|'||l_kind||'|',   '|'||v.expenditure_kind||'|') > 0)
    AND (l_sector IS NULL OR INSTR('|'||l_sector||'|', '|'||v.sector||'|') > 0)
    AND (l_ptype  IS NULL OR INSTR('|'||l_ptype||'|',  '|'||v.project_type||'|') > 0)
    AND (l_bu     IS NULL OR INSTR('|'||l_bu||'|',     '|'||v.business_unit||'|') > 0)
    AND (l_cc     IS NULL OR (INSTR(l_cc,'|') = 0 AND v.cost_centre LIKE '%'||l_cc||'%')
                          OR INSTR('|'||l_cc||'|', '|'||v.cost_centre||'|') > 0)
    AND (l_secok = 1 OR v.sector IN (SELECT cv.name_en FROM prod.dct_gl_class_value cv
           JOIN prod.v_dct_sec_user_scope sc ON sc.object_key = cv.value_code
            AND sc.object_type_code = 'SECTOR' AND sc.user_id = l_uid
           WHERE cv.class_type_code = 'SECTOR'));

  FOR r IN (
    SELECT MOD(m.period_num, 100) AS mth, SUM(m.actual_amount) AS amt
    FROM prod.dct_sector_actual_month_v m
    JOIN prod.dct_sector_perf_v v
      ON v.budget_year = m.budget_year AND v.project_number = m.project_number
     AND v.task_number = m.task_number AND v.expenditure_type = m.expenditure_type
    WHERE m.budget_year = l_year
      AND (l_kind   IS NULL OR INSTR('|'||l_kind||'|',   '|'||v.expenditure_kind||'|') > 0)
      AND (l_sector IS NULL OR INSTR('|'||l_sector||'|', '|'||v.sector||'|') > 0)
      AND (l_ptype  IS NULL OR INSTR('|'||l_ptype||'|',  '|'||v.project_type||'|') > 0)
      AND (l_bu     IS NULL OR INSTR('|'||l_bu||'|',     '|'||v.business_unit||'|') > 0)
      AND (l_cc     IS NULL OR (INSTR(l_cc,'|') = 0 AND v.cost_centre LIKE '%'||l_cc||'%')
                            OR INSTR('|'||l_cc||'|', '|'||v.cost_centre||'|') > 0)
      AND (l_secok = 1 OR v.sector IN (SELECT cv.name_en FROM prod.dct_gl_class_value cv
             JOIN prod.v_dct_sec_user_scope sc ON sc.object_key = cv.value_code
              AND sc.object_type_code = 'SECTOR' AND sc.user_id = l_uid
             WHERE cv.class_type_code = 'SECTOR'))
    GROUP BY MOD(m.period_num, 100) )
  LOOP
    IF r.mth BETWEEN 1 AND 12 THEN a_act(r.mth) := r.amt; END IF;
  END LOOP;

  FOR r IN (
    SELECT TO_NUMBER(SUBSTR(p.accounting_period,1,2)) AS mth, SUM(p.cf_amount) AS amt
    FROM prod.dct_project_cashflow p
    JOIN prod.dct_sector_perf_v v
      ON v.budget_year = p.budget_year
     AND v.project_number = TO_CHAR(p.project_number)
     AND v.task_number = p.task_number AND v.expenditure_type = p.expenditure_type
    WHERE p.budget_year = l_year AND p.cf_type = l_ptyp
      AND (l_kind   IS NULL OR INSTR('|'||l_kind||'|',   '|'||v.expenditure_kind||'|') > 0)
      AND (l_sector IS NULL OR INSTR('|'||l_sector||'|', '|'||v.sector||'|') > 0)
      AND (l_ptype  IS NULL OR INSTR('|'||l_ptype||'|',  '|'||v.project_type||'|') > 0)
      AND (l_bu     IS NULL OR INSTR('|'||l_bu||'|',     '|'||v.business_unit||'|') > 0)
      AND (l_cc     IS NULL OR (INSTR(l_cc,'|') = 0 AND v.cost_centre LIKE '%'||l_cc||'%')
                            OR INSTR('|'||l_cc||'|', '|'||v.cost_centre||'|') > 0)
      AND (l_secok = 1 OR v.sector IN (SELECT cv.name_en FROM prod.dct_gl_class_value cv
             JOIN prod.v_dct_sec_user_scope sc ON sc.object_key = cv.value_code
              AND sc.object_type_code = 'SECTOR' AND sc.user_id = l_uid
             WHERE cv.class_type_code = 'SECTOR'))
    GROUP BY TO_NUMBER(SUBSTR(p.accounting_period,1,2)) )
  LOOP
    IF r.mth BETWEEN 1 AND 12 THEN a_pl(r.mth) := r.amt; END IF;
  END LOOP;

  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  APEX_JSON.write('budgetAnnual', l_budget);
  -- the FY budget is shown as a FLAT line: the platform holds no budget-version
  -- history, so a rising budget line would have to be invented. When the
  -- published-month snapshot lands (report enhancement 2) this becomes real.
  APEX_JSON.write('budgetBasis', 'annual-flat');
  APEX_JSON.open_array('items');
  FOR i IN 1 .. 12 LOOP
    l_cact := l_cact + a_act(i);
    l_cpl  := l_cpl  + a_pl(i);
    APEX_JSON.open_object;
    APEX_JSON.write('period', TO_CHAR(i,'FM00')||'-'||TO_CHAR(l_year));
    APEX_JSON.write('month', i);
    APEX_JSON.write('actual', a_act(i));
    APEX_JSON.write('plan', a_pl(i));
    APEX_JSON.write('actualCumulative', l_cact);
    APEX_JSON.write('planCumulative', l_cpl);
    APEX_JSON.write('budgetCumulative', l_budget);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  prod.dct_gl_class_pkg.clear_butil_end;
  dct_rest.err(500, SQLERRM);
END;
!');

    -- ------------------------------------------------------------- revenue
    def_template('sectorperf/revenue');
    def_handler('sectorperf/revenue', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_year   NUMBER         := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_period VARCHAR2(10)   := [COLON]period;
  l_sector VARCHAR2(4000) := [COLON]sector;
  l_cc     VARCHAR2(4000) := [COLON]costcenter;
  l_ptyp   VARCHAR2(30)   := NVL([COLON]plantype, 'APPROVED');
  l_end    DATE;
  s_act NUMBER := 0; s_pl NUMBER := 0; m_act NUMBER := 0; m_pl NUMBER := 0;
  FUNCTION pct(p_a NUMBER, p_b NUMBER) RETURN NUMBER IS
  BEGIN
    IF NVL(p_b,0) = 0 THEN RETURN NULL; END IF;
    RETURN ROUND(100 * p_a / p_b, 1);
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_SECTOR_PERFORMANCE', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_SECTOR_PERFORMANCE required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  IF l_sector = '' THEN l_sector := NULL; END IF;
  IF l_cc     = '' THEN l_cc     := NULL; END IF;
  IF l_period = '' THEN l_period := NULL; END IF;
  IF l_period IS NOT NULL THEN
    IF NOT REGEXP_LIKE(l_period, '^(0[1-9]|1[0-2])-[0-9]{4}$')
       OR TO_NUMBER(SUBSTR(l_period, 4)) <> l_year THEN
      dct_rest.err(400,'period must be MM-YYYY within the selected year'); RETURN;
    END IF;
    l_end := LAST_DAY(TO_DATE('01-'||l_period, 'DD-MM-YYYY'));
  END IF;

  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  APEX_JSON.write('planType', l_ptyp);

  -- categories: actual and plan resolved through the SAME account -> category
  -- map, so the two can never disagree about what a category contains.
  APEX_JSON.open_array('categories');
  FOR r IN (
    WITH cat_map AS (
      SELECT account_code, MAX(category_code) AS category_code
      FROM   prod.dct_gl_revenue_cat_map WHERE is_active = 'Y' AND cost_center_code IS NULL
      GROUP  BY account_code ),
    cc_sec AS (
      SELECT cost_center_code, MAX(sector_name) AS sector_name
      FROM   prod.dct_gl_coa_snap WHERE cost_center_code IS NOT NULL
      GROUP  BY cost_center_code ),
    act AS (
      SELECT f.category_code, SUM(f.actual_amount) AS amt
      FROM   prod.dct_gl_revenue_fact_v f
      WHERE  f.budget_year = l_year
        AND (l_end IS NULL OR f.period_date <= l_end)
        AND (l_sector IS NULL OR INSTR('|'||l_sector||'|', '|'||f.sector||'|') > 0)
        AND (l_cc IS NULL OR (INSTR(l_cc,'|') = 0 AND f.cost_center_code LIKE '%'||l_cc||'%')
                          OR INSTR('|'||l_cc||'|', '|'||f.cost_center_code||'|') > 0)
      GROUP BY f.category_code ),
    pln AS (
      SELECT NVL(m.category_code,'UNCATEGORISED') AS category_code, SUM(p.plan_amount) AS amt
      FROM   prod.dct_gl_revenue_plan p
      LEFT JOIN cat_map m ON m.account_code = p.account_code
      LEFT JOIN cc_sec  c ON c.cost_center_code = p.cost_center_code
      WHERE  p.budget_year = l_year AND p.plan_type = l_ptyp
        AND (l_end IS NULL OR p.period_date <= l_end)
        AND (l_sector IS NULL OR INSTR('|'||l_sector||'|', '|'||c.sector_name||'|') > 0)
        AND (l_cc IS NULL OR (INSTR(l_cc,'|') = 0 AND p.cost_center_code LIKE '%'||l_cc||'%')
                          OR INSTR('|'||l_cc||'|', '|'||p.cost_center_code||'|') > 0)
      GROUP BY NVL(m.category_code,'UNCATEGORISED') )
    SELECT NVL(a.category_code, p.category_code) AS code,
           NVL(MAX(g.name_en), NVL(a.category_code, p.category_code)) AS name_en,
           NVL(MAX(g.name_ar), NVL(a.category_code, p.category_code)) AS name_ar,
           NVL(MAX(g.stream_code),'OTHER') AS stream,
           NVL(SUM(a.amt),0) AS actual,
           NVL(SUM(p.amt),0) AS plan
    FROM act a
    FULL OUTER JOIN pln p ON p.category_code = a.category_code
    LEFT JOIN prod.dct_gl_revenue_category g
           ON g.category_code = NVL(a.category_code, p.category_code)
    GROUP BY NVL(a.category_code, p.category_code)
    ORDER BY 5 DESC )
  LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.code);
    APEX_JSON.write('nameEn', r.name_en);
    APEX_JSON.write('nameAr', r.name_ar);
    APEX_JSON.write('stream', r.stream);
    APEX_JSON.write('actual', r.actual);
    APEX_JSON.write('plan', r.plan);
    APEX_JSON.write('achievementPct', pct(r.actual, r.plan));
    APEX_JSON.close_object;
    IF r.stream = 'SOVEREIGN'  THEN s_act := s_act + r.actual; s_pl := s_pl + r.plan; END IF;
    IF r.stream = 'COMMERCIAL' THEN m_act := m_act + r.actual; m_pl := m_pl + r.plan; END IF;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('streams');
  APEX_JSON.open_object;
  APEX_JSON.write('stream','SOVEREIGN');  APEX_JSON.write('actual', s_act);
  APEX_JSON.write('plan', s_pl); APEX_JSON.write('achievementPct', pct(s_act, s_pl));
  APEX_JSON.close_object;
  APEX_JSON.open_object;
  APEX_JSON.write('stream','COMMERCIAL'); APEX_JSON.write('actual', m_act);
  APEX_JSON.write('plan', m_pl); APEX_JSON.write('achievementPct', pct(m_act, m_pl));
  APEX_JSON.close_object;
  APEX_JSON.close_array;

  APEX_JSON.open_object('total');
  APEX_JSON.write('actual', s_act + m_act);
  APEX_JSON.write('plan', s_pl + m_pl);
  APEX_JSON.write('achievementPct', pct(s_act + m_act, s_pl + m_pl));
  APEX_JSON.close_object;

  -- MTD trend: revenue actually posted in each month (not cumulative), which is
  -- what the source pack's bar strip shows.
  APEX_JSON.open_array('trend');
  FOR r IN (
    SELECT MOD(f.period_num, 100) AS mth, SUM(f.actual_amount) AS amt
    FROM   prod.dct_gl_revenue_fact_v f
    WHERE  f.budget_year = l_year
      AND (l_end IS NULL OR f.period_date <= l_end)
      AND (l_sector IS NULL OR INSTR('|'||l_sector||'|', '|'||f.sector||'|') > 0)
      AND (l_cc IS NULL OR (INSTR(l_cc,'|') = 0 AND f.cost_center_code LIKE '%'||l_cc||'%')
                        OR INSTR('|'||l_cc||'|', '|'||f.cost_center_code||'|') > 0)
    GROUP BY MOD(f.period_num, 100)
    ORDER BY 1 )
  LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('month', r.mth);
    APEX_JSON.write('period', TO_CHAR(r.mth,'FM00')||'-'||TO_CHAR(l_year));
    APEX_JSON.write('actual', r.amt);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- -------------------------------------------------------- sample plan
    def_template('sectorperf/sample');
    def_handler('sectorperf/sample', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_year NUMBER := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_exp  NUMBER := 0; l_rev NUMBER := 0; l_map NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_SECTOR_PERFORMANCE', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_SECTOR_PERFORMANCE required'); RETURN;
  END IF;
  SELECT COUNT(*) INTO l_exp FROM prod.dct_project_cashflow
   WHERE loaded_by = 'SAMPLE' AND (l_year IS NULL OR budget_year = l_year);
  SELECT COUNT(*) INTO l_rev FROM prod.dct_gl_revenue_plan
   WHERE loaded_by = 'SAMPLE' AND (l_year IS NULL OR budget_year = l_year);
  SELECT COUNT(*) INTO l_map FROM prod.dct_gl_revenue_cat_map WHERE loaded_by = 'SAMPLE';
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  APEX_JSON.write('active', prod.dct_gl_plan_sample_pkg.is_sample_active(l_year));
  APEX_JSON.write('batches', NVL(prod.dct_gl_plan_sample_pkg.sample_batches(l_year), ''));
  APEX_JSON.write('expenditureRows', l_exp);
  APEX_JSON.write('revenueRows', l_rev);
  APEX_JSON.write('categoryMapRows', l_map);
  APEX_JSON.write('canPurge',
    CASE WHEN prod.dct_sec.has_priv_or_role(l_user,'GL_MANAGE_PLAN_SAMPLE',NULL,'GL') THEN 'Y' ELSE 'N' END);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('sectorperf/sample', 'DELETE', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_year NUMBER := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_exp  NUMBER; l_rev NUMBER; l_map NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_MANAGE_PLAN_SAMPLE', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_MANAGE_PLAN_SAMPLE required'); RETURN;
  END IF;
  -- deletes strictly WHERE loaded_by = 'SAMPLE'; a plan Finance uploaded
  -- carries a real filename and username and is unreachable from here
  prod.dct_gl_plan_sample_pkg.purge(l_year, NULL, l_exp, l_rev, l_map);
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('purged', 'Y');
  APEX_JSON.write('year', l_year);
  APEX_JSON.write('expenditureRows', l_exp);
  APEX_JSON.write('revenueRows', l_rev);
  APEX_JSON.write('categoryMapRows', l_map);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

END;
/

BEGIN
    setup_gl_secperf_ords_tmp;
    COMMIT;
END;
/
DROP PROCEDURE setup_gl_secperf_ords_tmp;

PROMPT === verify ===
SELECT t.uri_template, h.method, LENGTH(h.source) AS src_len
FROM user_ords_handlers h
JOIN user_ords_templates t ON t.id = h.template_id
JOIN user_ords_modules m  ON m.id = t.module_id
WHERE m.name = 'gl.rest' AND t.uri_template LIKE 'sectorperf%'
ORDER BY t.uri_template, h.method;

PROMPT gl.rest Sector Performance endpoints published (/gl/sectorperf*).
