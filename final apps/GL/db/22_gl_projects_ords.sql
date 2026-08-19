-- =============================================================================
-- General Ledger (App 210) -- Executive Project Dashboard API (ADDITIVE)
-- File    : 22_gl_projects_ords.sql
-- Adds to : gl.rest (does NOT delete or redefine the module)
-- Run     : sql -name prod_mcp @22_gl_projects_ords.sql   (fresh session, ADMIN)
--           Running under the prod connection fails: gl.rest lives under ADMIN
--           and ORDS.DEFINE_TEMPLATE raises ORA-01403 there.
-- Needs   : db/v2/122_dct_project_dashboard_views.sql deployed and granted.
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            re-run 07..22 right after it.
--
-- Routes (all GL_VIEW_BUDGET_UTILIZATION gated, all SECTOR data scoped):
--   GET projects/filters          filter LOVs, served from the butil caches
--   GET projects/lov              type-ahead lists scoped by year
--   GET projects                  the portfolio register + KPI aggregates
--   GET projects/:num             Project 360 header + KPIs
--   GET projects/:num/tasks       task register with planned dates
--   GET projects/:num/pipeline    open PR / PO / GRN / pending, per stage
--   GET projects/:num/invoices    AP invoices with derived paid
--   GET projects/:num/revenue     AR billed + the receipts DATA GAP marker
--   GET projects/:num/trx         budget transactions touching the project
--   GET projects/:num/cashflow    uploaded plan by period
--
-- Metric drills are NOT reimplemented here. The 360 page calls the existing
--   GET /gl/butil/lines?year=&fproject=&metric=ap|grn|pr|po|budget|budgetannual
-- which already returns reconciling rows with Fusion deep-link ids. A second
-- implementation of the same figure is exactly what this design avoids.
--
-- Privilege: GL_VIEW_BUDGET_UTILIZATION is reused deliberately. These pages
-- read the SAME budget data as the Budget Utilization page for the SAME
-- audience, so a separate privilege would add a seeding step and a chance to
-- lock people out without changing who may see what. Split it later if the
-- audiences ever diverge.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_proj_ords_tmp AS

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

    ----------------------------------------------------------------------------
    -- 1. projects/filters
    ----------------------------------------------------------------------------
    def_template('projects/filters');
    def_handler('projects/filters', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_year NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  SELECT MAX(budget_year) INTO l_year FROM prod.dct_project_portfolio_v;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('defaultYear', l_year);
  APEX_JSON.write('stallDays', 90);
  APEX_JSON.open_array('years');
  FOR r IN (SELECT DISTINCT budget_year y FROM prod.dct_project_portfolio_v ORDER BY 1 DESC) LOOP
    APEX_JSON.write(r.y);
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('projectTypes');
  FOR r IN (SELECT DISTINCT project_type v FROM prod.dct_project_portfolio_v
             WHERE project_type IS NOT NULL ORDER BY 1) LOOP APEX_JSON.write(r.v); END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('sectors');
  FOR r IN (SELECT DISTINCT sector v FROM prod.dct_project_portfolio_v
             WHERE sector IS NOT NULL ORDER BY 1) LOOP APEX_JSON.write(r.v); END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('chapters');
  FOR r IN (SELECT DISTINCT chapter v FROM prod.dct_project_portfolio_v
             WHERE chapter IS NOT NULL ORDER BY 1) LOOP APEX_JSON.write(r.v); END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('businessUnits');
  FOR r IN (SELECT DISTINCT business_unit v FROM prod.dct_project_portfolio_v
             WHERE business_unit IS NOT NULL ORDER BY 1) LOOP APEX_JSON.write(r.v); END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('appropriations');
  FOR r IN (SELECT DISTINCT appropriation v FROM prod.dct_project_portfolio_v
             WHERE appropriation IS NOT NULL ORDER BY 1) LOOP APEX_JSON.write(r.v); END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('programs');
  FOR r IN (SELECT DISTINCT program v FROM prod.dct_project_portfolio_v
             WHERE program IS NOT NULL ORDER BY 1) LOOP APEX_JSON.write(r.v); END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('statuses');
  FOR r IN (SELECT DISTINCT project_status s FROM prod.projects
             WHERE project_status IS NOT NULL ORDER BY 1) LOOP APEX_JSON.write(r.s); END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('bands');
  APEX_JSON.write('GREEN'); APEX_JSON.write('AMBER'); APEX_JSON.write('RED'); APEX_JSON.write('GREY');
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    ----------------------------------------------------------------------------
    -- 2. projects/lov  (type-ahead lists, scoped by year)
    ----------------------------------------------------------------------------
    def_template('projects/lov');
    def_handler('projects/lov', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_year NUMBER := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  APEX_JSON.open_array('projects');
  FOR r IN (SELECT project_number p, MAX(project_name) n
              FROM prod.dct_project_portfolio_v WHERE budget_year = l_year
             GROUP BY project_number ORDER BY 1) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('p', r.p); APEX_JSON.write('n', NVL(r.n,' '));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('costCenters');
  FOR r IN (SELECT cost_centre cc, MAX(department) dept
              FROM prod.dct_project_portfolio_v
             WHERE budget_year = l_year AND cost_centre IS NOT NULL
             GROUP BY cost_centre ORDER BY 1) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('cc', r.cc); APEX_JSON.write('dept', NVL(r.dept,' '));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('managers');
  FOR r IN (SELECT DISTINCT pj.project_manager m
              FROM prod.projects pj
             WHERE pj.project_manager IS NOT NULL
               AND TO_CHAR(pj.project_number) IN
                   (SELECT /*+ UNNEST */ project_number FROM prod.dct_project_portfolio_v
                     WHERE budget_year = l_year)
             ORDER BY 1) LOOP
    APEX_JSON.write(r.m);
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

END setup_gl_proj_ords_tmp;
/

BEGIN setup_gl_proj_ords_tmp; COMMIT; END;
/

DROP PROCEDURE setup_gl_proj_ords_tmp;

PROMPT GL 22 Project Dashboard ORDS part 1 (filters, lov) : done

CREATE OR REPLACE PROCEDURE setup_gl_proj2_ords_tmp AS
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

    ----------------------------------------------------------------------------
    -- 3. projects  -- the portfolio register + KPI aggregates
    --
    -- THE RECONCILIATION CONTRACT LIVES HERE. The predicate block below is a
    -- VERBATIM copy of the one in 07_gl_budget_util_ords.sql, run against
    -- DCT_PROJECT_PORTFOLIO_V, whose column names deliberately match
    -- DCT_BUDGET_UTILIZATION_V and which preserves every filterable dimension
    -- in its grain. Because SUM is associative, filtering here and
    -- re-aggregating by project is byte identical to filtering butil. Verified
    -- live: all seven measures differ by exactly 0 for 2026.
    -- If you change a predicate here, change it in 07 too, or the Budget
    -- Utilization page and this page will quietly disagree.
    --
    -- The FULL OUTER JOIN to DCT_PROJECT_SPEND_V is what surfaces projects that
    -- consumed money with NO budget line. butil cannot show them (its HAVING
    -- drops them) and they are real: 9 projects carrying AED 27.3M in 2026.
    -- They are EXCLUDED from the reconciling totals and reported separately as
    -- unbudgetedSpend, so the KPI band still ties to butil.
    ----------------------------------------------------------------------------
    def_template('projects');
    def_handler('projects', 'GET', TO_CLOB(q'!
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_uid     NUMBER;
  l_secok   NUMBER;
  l_year    NUMBER         := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_ptype   VARCHAR2(1000) := [COLON]projecttype;
  l_sector  VARCHAR2(200)  := [COLON]sector;
  l_chapter VARCHAR2(2000) := [COLON]chapter;
  l_bu      VARCHAR2(2000) := [COLON]bu;
  l_approp  VARCHAR2(2000) := [COLON]appropriation;
  l_program VARCHAR2(2000) := [COLON]program;
  l_cc      VARCHAR2(2000) := [COLON]costcenter;
  l_proj    VARCHAR2(2000) := [COLON]project;
  l_search  VARCHAR2(200)  := [COLON]search;
  l_period  VARCHAR2(10)   := [COLON]period;
  l_status  VARCHAR2(200)  := [COLON]status;
  l_band    VARCHAR2(100)  := UPPER([COLON]band);
  l_mgr     VARCHAR2(200)  := [COLON]manager;
  l_ovr     VARCHAR2(4)    := UPPER(NVL([COLON]ovr,'N'));
  l_sort    VARCHAR2(30)   := LOWER(NVL([COLON]sort,'health'));
  l_end     DATE;
  l_limit   NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit  DEFAULT NULL ON CONVERSION ERROR), 200), 5000);
  l_offset  NUMBER := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_total   NUMBER; l_projects NUMBER;
  t_bud NUMBER; t_buda NUMBER; t_ap NUMBER; t_grn NUMBER; t_pr NUMBER; t_po NUMBER; t_fund NUMBER;
  t_ovr NUMBER; t_ovra NUMBER; t_ovrn NUMBER; t_misscc NUMBER; l_misscc NUMBER;
  t_spend NUMBER; t_unbud NUMBER; n_unbud NUMBER;
  t_paid NUMBER; t_inv NUMBER; t_bal NUMBER; t_billed NUMBER;
  n_pdocs NUMBER; t_pamt NUMBER;
  b_green NUMBER; b_amber NUMBER; b_red NUMBER; b_grey NUMBER;
  f_over NUMBER; f_nobud NUMBER; f_stall NUMBER; f_back NUMBER; f_nospend NUMBER;
  n_artot NUMBER; n_arproj NUMBER; n_actdt NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  l_uid   := dct_auth.get_user_id(l_user);
  l_secok := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  IF l_period = '' THEN l_period := NULL; END IF;
  IF l_period IS NOT NULL THEN
    IF NOT REGEXP_LIKE(l_period, '^(0[1-9]|1[0-2])-[0-9]{4}$')
       OR TO_NUMBER(SUBSTR(l_period, 4)) <> l_year THEN
      dct_rest.err(400,'period must be MM-YYYY within the selected year'); RETURN;
    END IF;
    l_end := LAST_DAY(TO_DATE('01-'||l_period, 'DD-MM-YYYY'));
  END IF;
  IF l_end IS NOT NULL THEN dct_gl_class_pkg.set_butil_end(l_end);
  ELSE dct_gl_class_pkg.clear_butil_end; END IF;
  dct_gl_class_pkg.set_butil_ovr(l_ovr);

  -- pass 1: the reconciling aggregates, over the SAME predicate block as /gl/butil
  SELECT COUNT(*), COUNT(DISTINCT project_number),
         NVL(SUM(budget),0), NVL(SUM(budget_annual),0), NVL(SUM(actual_ap),0), NVL(SUM(actual_grn),0),
         NVL(SUM(commitment_pr),0), NVL(SUM(obligation_po),0), NVL(SUM(fund_available),0),
         NVL(SUM(override_budget),0), NVL(SUM(override_budget_annual),0), NVL(SUM(override_lines),0),
         NVL(SUM(missing_cc_lines),0), NVL(SUM(missing_cc_budget),0)
    INTO l_total, l_projects, t_bud, t_buda, t_ap, t_grn, t_pr, t_po, t_fund,
         t_ovr, t_ovra, t_ovrn, l_misscc, t_misscc
    FROM prod.dct_project_portfolio_v v
   WHERE v.budget_year = l_year
     AND (l_ptype  IS NULL OR INSTR('|'||l_ptype||'|', '|'||v.project_type||'|') > 0)
     AND (l_sector IS NULL OR v.sector = l_sector)
     AND (l_secok = 1 OR v.sector IN (SELECT cv.name_en FROM prod.dct_gl_class_value cv JOIN prod.v_dct_sec_user_scope sc ON sc.object_key = cv.value_code AND sc.object_type_code = 'SECTOR' AND sc.user_id = l_uid WHERE cv.class_type_code = 'SECTOR'))
     AND (l_chapter IS NULL OR INSTR('|'||l_chapter||'|', '|'||v.chapter||'|') > 0)
     AND (l_bu IS NULL OR INSTR('|'||l_bu||'|', '|'||v.business_unit||'|') > 0)
     AND (l_approp  IS NULL OR INSTR('|'||l_approp||'|', '|'||v.appropriation||'|') > 0)
     AND (l_program IS NULL OR INSTR('|'||l_program||'|', '|'||v.program||'|') > 0)
     AND (l_cc     IS NULL OR (INSTR(l_cc,'|') = 0 AND v.cost_centre LIKE '%'||l_cc||'%')
                           OR INSTR('|'||l_cc||'|', '|'||v.cost_centre||'|') > 0)
     AND (l_proj   IS NULL OR (INSTR(l_proj,'|') = 0 AND UPPER(v.project_number||' '||v.project_name) LIKE '%'||UPPER(l_proj)||'%')
                           OR INSTR('|'||l_proj||'|', '|'||v.project_number||'|') > 0)
     AND (l_search IS NULL OR UPPER(v.project_number||' '||v.project_name||' '
                                   ||v.department||' '||v.cost_centre) LIKE '%'||UPPER(l_search)||'%');
!') || TO_CLOB(q'!
  -- pass 2: the non budget legs. Separate scans on purpose: they must NEVER
  -- change the reconciling totals above.
  SELECT NVL(SUM(s.spend_total),0),
         NVL(SUM(CASE WHEN b.project_number IS NULL THEN s.spend_total END),0),
         COUNT(CASE WHEN b.project_number IS NULL THEN 1 END)
    INTO t_spend, t_unbud, n_unbud
    FROM prod.dct_project_spend_v s
    LEFT JOIN (SELECT DISTINCT project_number FROM prod.dct_project_portfolio_v
                WHERE budget_year = l_year) b ON b.project_number = s.project_number
   WHERE s.budget_year = l_year
     AND (l_secok = 1 OR s.sector IS NULL OR s.sector IN (SELECT cv.name_en FROM prod.dct_gl_class_value cv JOIN prod.v_dct_sec_user_scope sc ON sc.object_key = cv.value_code AND sc.object_type_code = 'SECTOR' AND sc.user_id = l_uid WHERE cv.class_type_code = 'SECTOR'));

  SELECT NVL(SUM(ap_invoiced_aed),0), NVL(SUM(ap_paid_aed),0), NVL(SUM(ap_balance_aed),0)
    INTO t_inv, t_paid, t_bal
    FROM prod.dct_project_ap_paid_v WHERE budget_year = l_year;

  SELECT NVL(SUM(billed_revenue_aed),0), COUNT(*)
    INTO t_billed, n_arproj
    FROM prod.dct_project_ar_rev_v WHERE budget_year = l_year;

  SELECT NVL(SUM(pending_docs),0), NVL(SUM(pending_aed),0)
    INTO n_pdocs, t_pamt
    FROM prod.dct_project_pending_v WHERE budget_year = l_year;

  SELECT COUNT(CASE WHEN health_band='GREEN' THEN 1 END),
         COUNT(CASE WHEN health_band='AMBER' THEN 1 END),
         COUNT(CASE WHEN health_band='RED'   THEN 1 END),
         COUNT(CASE WHEN health_band='GREY'  THEN 1 END),
         COUNT(CASE WHEN flag_over_budget='Y' THEN 1 END),
         COUNT(CASE WHEN flag_no_budget='Y' THEN 1 END),
         COUNT(CASE WHEN flag_stalled='Y' THEN 1 END),
         COUNT(CASE WHEN flag_pending_backlog='Y' THEN 1 END),
         COUNT(CASE WHEN flag_no_spend='Y' THEN 1 END)
    INTO b_green, b_amber, b_red, b_grey, f_over, f_nobud, f_stall, f_back, f_nospend
    FROM prod.dct_project_health_v WHERE budget_year = l_year;

  SELECT NVL(SUM(tasks_with_actual_finish),0) INTO n_actdt FROM prod.dct_project_schedule_v;
  SELECT COUNT(*) INTO n_artot FROM prod.projects;

  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  IF l_period IS NOT NULL THEN APEX_JSON.write('period', l_period); END IF;
  APEX_JSON.write('considerOverride', l_ovr);
  APEX_JSON.write('total', l_projects);
  APEX_JSON.write('rows', l_total);
  APEX_JSON.write('limit', l_limit);
  APEX_JSON.write('offset', l_offset);
  APEX_JSON.write('healthScope', 'PROJECT');
  APEX_JSON.open_object('totals');
  APEX_JSON.write('budget', t_bud);            APEX_JSON.write('budgetAnnual', t_buda);
  APEX_JSON.write('actualAp', t_ap);           APEX_JSON.write('actualGrn', t_grn);
  APEX_JSON.write('commitmentPr', t_pr);       APEX_JSON.write('obligationPo', t_po);
  APEX_JSON.write('fundAvailable', t_fund);
  APEX_JSON.write('overrideBudget', t_ovr);    APEX_JSON.write('overrideBudgetAnnual', t_ovra);
  APEX_JSON.write('overrideLines', t_ovrn);
  APEX_JSON.write('projects', l_projects);
  APEX_JSON.write('spendAll', t_spend);        APEX_JSON.write('unbudgetedSpend', t_unbud);
  APEX_JSON.write('apInvoiced', t_inv);        APEX_JSON.write('apPaid', t_paid);
  APEX_JSON.write('apBalance', t_bal);         APEX_JSON.write('billedRevenue', t_billed);
  APEX_JSON.write('pendingDocs', n_pdocs);     APEX_JSON.write('pendingAed', t_pamt);
  APEX_JSON.close_object;
  APEX_JSON.open_object('bands');
  APEX_JSON.write('green', b_green); APEX_JSON.write('amber', b_amber);
  APEX_JSON.write('red', b_red);     APEX_JSON.write('grey', b_grey);
  APEX_JSON.close_object;
  APEX_JSON.open_object('flags');
  APEX_JSON.write('overBudget', f_over);      APEX_JSON.write('noBudget', f_nobud);
  APEX_JSON.write('stalled', f_stall);        APEX_JSON.write('pendingBacklog', f_back);
  APEX_JSON.write('noSpend', f_nospend);      APEX_JSON.write('missingCc', l_misscc);
  APEX_JSON.close_object;
  APEX_JSON.open_object('dataGaps');
  APEX_JSON.open_object('arReceipts');
  APEX_JSON.write('status','DATA_GAP');
  APEX_JSON.write('reason','Billed revenue only. No AR receipts extract exists on the platform, so collections, outstanding receivable and DSO are not shown rather than estimated.');
  APEX_JSON.write('requiredSource','Fusion Receivables receipts and applications');
  APEX_JSON.close_object;
  APEX_JSON.write('actualTaskDates', n_actdt);
  APEX_JSON.write('actualTaskDatesNote','ATD_TASKS actual start and finish dates are empty in the source, so schedule slippage is not computable and is not scored.');
  APEX_JSON.write('arProjectsCovered', n_arproj);
  APEX_JSON.write('projectsTotal', n_artot);
  APEX_JSON.write('unbudgetedProjects', n_unbud);
  APEX_JSON.write('missingCcLines', l_misscc);
  APEX_JSON.write('missingCcBudget', t_misscc);
  APEX_JSON.close_object;
!') || TO_CLOB(q'!
  APEX_JSON.open_array('items');
  -- Columns are enumerated with unique aliases on purpose. A SELECT * over
  -- these joins exposes project_number, project_name and budget_annual from
  -- several sources at once, and the duplicate names make the cursor record
  -- unusable (the PLS-00402 class of failure, which surfaces through ORDS as
  -- an uncatchable 555 rather than a compile error).
  FOR r IN (
    SELECT
           g.project_number, g.project_name, g.project_type, g.business_unit,
           g.sector, g.chapter, g.department, g.cost_centre, g.appropriation, g.program,
           g.budget, g.budget_annual, g.actual_ap, g.actual_grn,
           g.commitment_pr, g.obligation_po, g.fund_available,
           g.budget_lines, g.override_budget,
           h.utilization_pct, h.elapsed_pct, h.days_since_activity,
           h.health_score, h.health_band,
           h.score_burn, h.score_funds, h.score_approval, h.score_activity,
           h.flag_over_budget, h.flag_no_budget, h.flag_stalled,
           h.flag_pending_backlog, h.flag_no_spend,
           a.ap_invoiced_aed, a.ap_paid_aed, a.ap_balance_aed, a.ap_invoice_count,
           ar.billed_revenue_aed,
           pn.pending_docs, pn.pending_aed, pn.max_pending_days, pn.docs_over_30d,
           sp.spend_total,
           pv.project_manager, pv.project_status,
           sc.task_count, sc.tasks_planned_finish_past
      FROM (
      SELECT v.project_number, MAX(v.project_name) project_name,
             MAX(v.project_type) project_type, MAX(v.business_unit) business_unit,
             MAX(v.sector) sector, MAX(v.chapter) chapter, MAX(v.department) department,
             MAX(v.cost_centre) cost_centre, MAX(v.appropriation) appropriation,
             MAX(v.program) program,
             SUM(v.budget) budget, SUM(v.budget_annual) budget_annual,
             SUM(v.actual_ap) actual_ap, SUM(v.actual_grn) actual_grn,
             SUM(v.commitment_pr) commitment_pr, SUM(v.obligation_po) obligation_po,
             SUM(v.fund_available) fund_available, SUM(v.budget_lines) budget_lines,
             SUM(v.override_budget) override_budget
        FROM prod.dct_project_portfolio_v v
       WHERE v.budget_year = l_year
         AND (l_ptype  IS NULL OR INSTR('|'||l_ptype||'|', '|'||v.project_type||'|') > 0)
         AND (l_sector IS NULL OR v.sector = l_sector)
         AND (l_secok = 1 OR v.sector IN (SELECT cv.name_en FROM prod.dct_gl_class_value cv JOIN prod.v_dct_sec_user_scope sc ON sc.object_key = cv.value_code AND sc.object_type_code = 'SECTOR' AND sc.user_id = l_uid WHERE cv.class_type_code = 'SECTOR'))
         AND (l_chapter IS NULL OR INSTR('|'||l_chapter||'|', '|'||v.chapter||'|') > 0)
         AND (l_bu IS NULL OR INSTR('|'||l_bu||'|', '|'||v.business_unit||'|') > 0)
         AND (l_approp  IS NULL OR INSTR('|'||l_approp||'|', '|'||v.appropriation||'|') > 0)
         AND (l_program IS NULL OR INSTR('|'||l_program||'|', '|'||v.program||'|') > 0)
         AND (l_cc     IS NULL OR (INSTR(l_cc,'|') = 0 AND v.cost_centre LIKE '%'||l_cc||'%')
                               OR INSTR('|'||l_cc||'|', '|'||v.cost_centre||'|') > 0)
         AND (l_proj   IS NULL OR (INSTR(l_proj,'|') = 0 AND UPPER(v.project_number||' '||v.project_name) LIKE '%'||UPPER(l_proj)||'%')
                               OR INSTR('|'||l_proj||'|', '|'||v.project_number||'|') > 0)
         AND (l_search IS NULL OR UPPER(v.project_number||' '||v.project_name||' '
                                       ||v.department||' '||v.cost_centre) LIKE '%'||UPPER(l_search)||'%')
       GROUP BY v.project_number) g
    JOIN (SELECT * FROM prod.dct_project_health_v WHERE budget_year = l_year) h
      ON h.project_number = g.project_number
    LEFT JOIN (SELECT * FROM prod.dct_project_ap_paid_v WHERE budget_year = l_year) a
      ON a.project_number = g.project_number
    LEFT JOIN (SELECT * FROM prod.dct_project_ar_rev_v WHERE budget_year = l_year) ar
      ON ar.project_number = g.project_number
    LEFT JOIN (SELECT * FROM prod.dct_project_pending_v WHERE budget_year = l_year) pn
      ON pn.project_number = g.project_number
    LEFT JOIN (SELECT * FROM prod.dct_project_spend_v WHERE budget_year = l_year) sp
      ON sp.project_number = g.project_number
    LEFT JOIN prod.projects_v pv ON pv.project_number = g.project_number
    LEFT JOIN prod.dct_project_schedule_v sc ON sc.project_number = g.project_number
   WHERE (l_status IS NULL OR INSTR('|'||l_status||'|', '|'||pv.project_status||'|') > 0)
     AND (l_band   IS NULL OR INSTR('|'||l_band||'|', '|'||h.health_band||'|') > 0)
     AND (l_mgr    IS NULL OR UPPER(pv.project_manager) LIKE '%'||UPPER(l_mgr)||'%')
   ORDER BY CASE l_sort
              WHEN 'budget'        THEN -g.budget_annual
              WHEN 'actual'        THEN -(g.actual_ap + g.actual_grn)
              WHEN 'committed'     THEN -(g.commitment_pr + g.obligation_po)
              WHEN 'fundavailable' THEN g.fund_available
              WHEN 'utilization'   THEN -NVL(h.utilization_pct,0)
              ELSE NVL(h.health_score,0) END,
            g.budget_annual DESC
   OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('projectNumber', r.project_number);
    APEX_JSON.write('projectName',   NVL(r.project_name,' '));
    APEX_JSON.write('projectType',   NVL(r.project_type,' '));
    APEX_JSON.write('businessUnit',  NVL(r.business_unit,' '));
    APEX_JSON.write('sector',        NVL(r.sector,' '));
    APEX_JSON.write('chapter',       NVL(r.chapter,' '));
    APEX_JSON.write('department',    NVL(r.department,' '));
    APEX_JSON.write('costCentre',    NVL(r.cost_centre,' '));
    APEX_JSON.write('appropriation', NVL(r.appropriation,' '));
    APEX_JSON.write('program',       NVL(r.program,' '));
    APEX_JSON.write('manager',       NVL(r.project_manager,' '));
    APEX_JSON.write('status',        NVL(r.project_status,' '));
    APEX_JSON.write('budget',        NVL(r.budget,0));
    APEX_JSON.write('budgetAnnual',  NVL(r.budget_annual,0));
    APEX_JSON.write('actualAp',      NVL(r.actual_ap,0));
    APEX_JSON.write('actualGrn',     NVL(r.actual_grn,0));
    APEX_JSON.write('commitmentPr',  NVL(r.commitment_pr,0));
    APEX_JSON.write('obligationPo',  NVL(r.obligation_po,0));
    APEX_JSON.write('fundAvailable', NVL(r.fund_available,0));
    APEX_JSON.write('budgetLines',   NVL(r.budget_lines,0));
    APEX_JSON.write('overrideBudget',NVL(r.override_budget,0));
    APEX_JSON.write('spendAll',      NVL(r.spend_total,0));
    APEX_JSON.write('apInvoiced',    NVL(r.ap_invoiced_aed,0));
    APEX_JSON.write('apPaid',        NVL(r.ap_paid_aed,0));
    APEX_JSON.write('apBalance',     NVL(r.ap_balance_aed,0));
    APEX_JSON.write('apInvoiceCount',NVL(r.ap_invoice_count,0));
    APEX_JSON.write('billed',        NVL(r.billed_revenue_aed,0));
    APEX_JSON.write('pendingDocs',   NVL(r.pending_docs,0));
    APEX_JSON.write('pendingAmt',    NVL(r.pending_aed,0));
    APEX_JSON.write('maxPendingDays',NVL(r.max_pending_days,0));
    APEX_JSON.write('docsOver30',    NVL(r.docs_over_30d,0));
    APEX_JSON.write('taskCount',     NVL(r.task_count,0));
    APEX_JSON.write('tasksPastPlan', NVL(r.tasks_planned_finish_past,0));
    APEX_JSON.write('utilizationPct',NVL(r.utilization_pct,0));
    APEX_JSON.write('elapsedPct',    NVL(r.elapsed_pct,0));
    APEX_JSON.write('daysSinceActivity', NVL(r.days_since_activity,-1));
    APEX_JSON.write('healthScore',   NVL(r.health_score,0));
    APEX_JSON.write('healthBand',    NVL(r.health_band,'GREY'));
    APEX_JSON.write('scoreBurn',     NVL(r.score_burn,-1));
    APEX_JSON.write('scoreFunds',    NVL(r.score_funds,-1));
    APEX_JSON.write('scoreApproval', NVL(r.score_approval,-1));
    APEX_JSON.write('scoreActivity', NVL(r.score_activity,-1));
    APEX_JSON.write('overBudget',      r.flag_over_budget);
    APEX_JSON.write('noBudget',        r.flag_no_budget);
    APEX_JSON.write('stalled',         r.flag_stalled);
    APEX_JSON.write('pendingBacklog',  r.flag_pending_backlog);
    APEX_JSON.write('noSpend',         r.flag_no_spend);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
  dct_gl_class_pkg.clear_butil_end; dct_gl_class_pkg.clear_butil_ovr;
EXCEPTION WHEN OTHERS THEN
  dct_gl_class_pkg.clear_butil_end; dct_gl_class_pkg.clear_butil_ovr;
  dct_rest.err(500, SQLERRM);
END;
!'));

END setup_gl_proj2_ords_tmp;
/

BEGIN setup_gl_proj2_ords_tmp; COMMIT; END;
/

DROP PROCEDURE setup_gl_proj2_ords_tmp;

PROMPT GL 22 part 2 (portfolio grid) : done

CREATE OR REPLACE PROCEDURE setup_gl_proj3_ords_tmp AS
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

    ----------------------------------------------------------------------------
    -- 4. projects/:num  -- Project 360 header, KPIs, health, AP, AR, pending
    -- The 404 is decided BEFORE dct_rest.json_header: once the header is
    -- written the status line can no longer be changed.
    ----------------------------------------------------------------------------
    def_template('projects/[COLON]num');
    def_handler('projects/[COLON]num', 'GET', TO_CLOB(q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_num    VARCHAR2(60)  := [COLON]num;
  l_year   NUMBER        := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_period VARCHAR2(10)  := [COLON]period;
  l_ovr    VARCHAR2(4)   := UPPER(NVL([COLON]ovr,'N'));
  l_end    DATE;
  l_n      NUMBER;
  p_name VARCHAR2(400); p_type VARCHAR2(200); p_status VARCHAR2(100); p_mgr VARCHAR2(200);
  p_bu VARCHAR2(200); p_unit VARCHAR2(200); p_appr VARCHAR2(400);
  p_start DATE; p_finish DATE; p_closed DATE;
  p_sectors VARCHAR2(2000); p_depts VARCHAR2(2000); p_ccs VARCHAR2(2000); p_progs VARCHAR2(2000);
  p_chapter VARCHAR2(400); p_tasks NUMBER; p_etypes NUMBER;
  y_bud NUMBER; y_buda NUMBER; y_ap NUMBER; y_grn NUMBER; y_pr NUMBER; y_po NUMBER;
  y_fund NUMBER; y_lines NUMBER; y_ovr NUMBER;
  s_spend NUMBER; s_apc NUMBER; s_grnc NUMBER; s_prc NUMBER; s_poc NUMBER; s_last DATE;
  h_score NUMBER; h_band VARCHAR2(10); h_util NUMBER; h_elapsed NUMBER; h_dsa NUMBER;
  h_b NUMBER; h_f NUMBER; h_a NUMBER; h_ac NUMBER; h_comp NUMBER;
  h_over VARCHAR2(1); h_nob VARCHAR2(1); h_stall VARCHAR2(1); h_back VARCHAR2(1); h_nos VARCHAR2(1);
  a_inv NUMBER; a_paid NUMBER; a_bal NUMBER; a_direct NUMBER; a_cnt NUMBER;
  a_p NUMBER; a_pp NUMBER; a_up NUMBER;
  r_billed NUMBER; r_trx NUMBER; r_cust NUMBER; r_lines NUMBER;
  n_pdocs NUMBER; t_pamt NUMBER; n_p30 NUMBER; n_pmax NUMBER;
  k_tasks NUMBER; k_plan NUMBER; k_past NUMBER; k_actf NUMBER; k_ovd NUMBER; k_elapsed NUMBER;
  k_pstart DATE; k_pfin DATE;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  IF l_num IS NULL OR NOT REGEXP_LIKE(l_num,'^[A-Za-z0-9._-]{1,30}$') THEN
    dct_rest.err(400,'invalid project number'); RETURN;
  END IF;
  SELECT COUNT(*) INTO l_n FROM prod.projects WHERE TO_CHAR(project_number) = l_num;
  IF l_n = 0 THEN dct_rest.err(404,'project not found'); RETURN; END IF;
  IF l_period = '' THEN l_period := NULL; END IF;
  IF l_period IS NOT NULL THEN
    IF NOT REGEXP_LIKE(l_period, '^(0[1-9]|1[0-2])-[0-9]{4}$')
       OR TO_NUMBER(SUBSTR(l_period, 4)) <> l_year THEN
      dct_rest.err(400,'period must be MM-YYYY within the selected year'); RETURN;
    END IF;
    l_end := LAST_DAY(TO_DATE('01-'||l_period, 'DD-MM-YYYY'));
  END IF;
  IF l_end IS NOT NULL THEN dct_gl_class_pkg.set_butil_end(l_end);
  ELSE dct_gl_class_pkg.clear_butil_end; END IF;
  dct_gl_class_pkg.set_butil_ovr(l_ovr);

  SELECT MAX(project_name), MAX(project_type), MAX(project_status), MAX(project_manager),
         MAX(business_unit), MAX(project_unit), MAX(appropriation), MAX(chapter),
         MAX(project_start_date), MAX(project_finish_date), MAX(project_closed_date),
         MAX(sectors), MAX(departments), MAX(cost_centres), MAX(programs),
         MAX(task_count), MAX(expenditure_type_count)
    INTO p_name, p_type, p_status, p_mgr, p_bu, p_unit, p_appr, p_chapter,
         p_start, p_finish, p_closed, p_sectors, p_depts, p_ccs, p_progs,
         p_tasks, p_etypes
    FROM prod.projects_v WHERE project_number = l_num;

  SELECT NVL(SUM(budget),0), NVL(SUM(budget_annual),0), NVL(SUM(actual_ap),0), NVL(SUM(actual_grn),0),
         NVL(SUM(commitment_pr),0), NVL(SUM(obligation_po),0), NVL(SUM(fund_available),0),
         NVL(SUM(budget_lines),0), NVL(SUM(override_budget),0)
    INTO y_bud, y_buda, y_ap, y_grn, y_pr, y_po, y_fund, y_lines, y_ovr
    FROM prod.dct_project_portfolio_v WHERE budget_year = l_year AND project_number = l_num;

  SELECT NVL(MAX(spend_total),0), NVL(MAX(ap_invoice_count),0), NVL(MAX(grn_receipt_count),0),
         NVL(MAX(pr_count),0), NVL(MAX(po_count),0),
         MAX(CASE WHEN last_activity_raw > DATE '1900-01-01' THEN last_activity_raw END)
    INTO s_spend, s_apc, s_grnc, s_prc, s_poc, s_last
    FROM prod.dct_project_spend_v WHERE budget_year = l_year AND project_number = l_num;

  SELECT MAX(health_score), MAX(health_band), MAX(utilization_pct), MAX(elapsed_pct),
         MAX(days_since_activity), MAX(score_burn), MAX(score_funds), MAX(score_approval),
         MAX(score_activity), MAX(scored_components), MAX(flag_over_budget), MAX(flag_no_budget),
         MAX(flag_stalled), MAX(flag_pending_backlog), MAX(flag_no_spend)
    INTO h_score, h_band, h_util, h_elapsed, h_dsa, h_b, h_f, h_a, h_ac, h_comp,
         h_over, h_nob, h_stall, h_back, h_nos
    FROM prod.dct_project_health_v WHERE budget_year = l_year AND project_number = l_num;

  SELECT NVL(MAX(ap_invoiced_aed),0), NVL(MAX(ap_paid_aed),0), NVL(MAX(ap_balance_aed),0),
         NVL(MAX(ap_direct_aed),0), NVL(MAX(ap_invoice_count),0),
         NVL(MAX(paid_invoice_count),0), NVL(MAX(part_paid_invoice_count),0), NVL(MAX(unpaid_invoice_count),0)
    INTO a_inv, a_paid, a_bal, a_direct, a_cnt, a_p, a_pp, a_up
    FROM prod.dct_project_ap_paid_v WHERE budget_year = l_year AND project_number = l_num;

  SELECT NVL(MAX(billed_revenue_aed),0), NVL(MAX(transaction_count),0),
         NVL(MAX(customer_count),0), NVL(MAX(line_count),0)
    INTO r_billed, r_trx, r_cust, r_lines
    FROM prod.dct_project_ar_rev_v WHERE budget_year = l_year AND project_number = l_num;

  SELECT NVL(MAX(pending_docs),0), NVL(MAX(pending_aed),0), NVL(MAX(docs_over_30d),0), NVL(MAX(max_pending_days),0)
    INTO n_pdocs, t_pamt, n_p30, n_pmax
    FROM prod.dct_project_pending_v WHERE budget_year = l_year AND project_number = l_num;

  SELECT NVL(MAX(task_count),0), NVL(MAX(tasks_with_planned_finish),0), NVL(MAX(tasks_planned_finish_past),0),
         NVL(MAX(tasks_with_actual_finish),0), MAX(project_overdue_days), MAX(schedule_elapsed_pct),
         MAX(planned_start_min), MAX(planned_finish_max)
    INTO k_tasks, k_plan, k_past, k_actf, k_ovd, k_elapsed, k_pstart, k_pfin
    FROM prod.dct_project_schedule_v WHERE project_number = l_num;
!') || TO_CLOB(q'!
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  IF l_period IS NOT NULL THEN APEX_JSON.write('period', l_period); END IF;
  APEX_JSON.write('considerOverride', l_ovr);

  APEX_JSON.open_object('project');
  APEX_JSON.write('projectNumber', l_num);
  APEX_JSON.write('projectName',   NVL(p_name,' '));
  APEX_JSON.write('projectType',   NVL(p_type,' '));
  APEX_JSON.write('status',        NVL(p_status,' '));
  APEX_JSON.write('manager',       NVL(p_mgr,' '));
  APEX_JSON.write('businessUnit',  NVL(p_bu,' '));
  APEX_JSON.write('projectUnit',   NVL(p_unit,' '));
  APEX_JSON.write('appropriation', NVL(p_appr,' '));
  APEX_JSON.write('chapter',       NVL(p_chapter,' '));
  APEX_JSON.write('sectors',       NVL(p_sectors,' '));
  APEX_JSON.write('departments',   NVL(p_depts,' '));
  APEX_JSON.write('costCentres',   NVL(p_ccs,' '));
  APEX_JSON.write('programs',      NVL(p_progs,' '));
  APEX_JSON.write('startDate',     TO_CHAR(p_start,'YYYY-MM-DD'));
  APEX_JSON.write('finishDate',    TO_CHAR(p_finish,'YYYY-MM-DD'));
  APEX_JSON.write('closedDate',    TO_CHAR(p_closed,'YYYY-MM-DD'));
  APEX_JSON.write('taskCount',     NVL(p_tasks,0));
  APEX_JSON.write('etypeCount',    NVL(p_etypes,0));
  APEX_JSON.close_object;

  APEX_JSON.open_object('year');
  APEX_JSON.write('budget', y_bud);           APEX_JSON.write('budgetAnnual', y_buda);
  APEX_JSON.write('actualAp', y_ap);          APEX_JSON.write('actualGrn', y_grn);
  APEX_JSON.write('commitmentPr', y_pr);      APEX_JSON.write('obligationPo', y_po);
  APEX_JSON.write('fundAvailable', y_fund);   APEX_JSON.write('budgetLines', y_lines);
  APEX_JSON.write('overrideBudget', y_ovr);
  APEX_JSON.write('spendAll', s_spend);
  APEX_JSON.write('unbudgetedSpend', GREATEST(s_spend - (y_ap + y_grn + y_pr + y_po), 0));
  APEX_JSON.write('hasBudget', CASE WHEN y_lines > 0 THEN 'Y' ELSE 'N' END);
  APEX_JSON.write('apInvoiceCount', s_apc);   APEX_JSON.write('grnReceiptCount', s_grnc);
  APEX_JSON.write('prCount', s_prc);          APEX_JSON.write('poCount', s_poc);
  APEX_JSON.write('lastActivity', TO_CHAR(s_last,'YYYY-MM-DD'));
  APEX_JSON.close_object;

  -- the funnel the 360 page draws: each stage is a share of the one before it
  APEX_JSON.open_object('funnel');
  APEX_JSON.write('budgetAnnual', y_buda);  APEX_JSON.write('commitmentPr', y_pr);
  APEX_JSON.write('obligationPo', y_po);    APEX_JSON.write('actualGrn', y_grn);
  APEX_JSON.write('apInvoiced', a_inv);     APEX_JSON.write('apPaid', a_paid);
  APEX_JSON.close_object;

  APEX_JSON.open_object('health');
  APEX_JSON.write('score', NVL(h_score,0));  APEX_JSON.write('band', NVL(h_band,'GREY'));
  APEX_JSON.write('utilizationPct', NVL(h_util,0));
  APEX_JSON.write('elapsedPct', NVL(h_elapsed,0));
  APEX_JSON.write('daysSinceActivity', NVL(h_dsa,-1));
  APEX_JSON.write('scoredComponents', NVL(h_comp,0));
  APEX_JSON.open_object('components');
  APEX_JSON.write('burn', NVL(h_b,-1));        APEX_JSON.write('funds', NVL(h_f,-1));
  APEX_JSON.write('approval', NVL(h_a,-1));    APEX_JSON.write('activity', NVL(h_ac,-1));
  APEX_JSON.close_object;
  APEX_JSON.open_object('weights');
  APEX_JSON.write('burn', 40); APEX_JSON.write('funds', 20);
  APEX_JSON.write('approval', 20); APEX_JSON.write('activity', 20);
  APEX_JSON.close_object;
  APEX_JSON.open_object('flags');
  APEX_JSON.write('overBudget', NVL(h_over,'N'));   APEX_JSON.write('noBudget', NVL(h_nob,'N'));
  APEX_JSON.write('stalled', NVL(h_stall,'N'));     APEX_JSON.write('pendingBacklog', NVL(h_back,'N'));
  APEX_JSON.write('noSpend', NVL(h_nos,'N'));
  APEX_JSON.close_object;
  APEX_JSON.write('disclaimer','Advisory only. Weighted from burn discipline, fund headroom, approval friction and activity. A schedule component is deliberately NOT scored: task actual start and finish dates are empty in the source. No workflow or budget decision should key off this score.');
  APEX_JSON.close_object;

  APEX_JSON.open_object('ap');
  APEX_JSON.write('invoiced', a_inv);   APEX_JSON.write('paid', a_paid);
  APEX_JSON.write('balance', a_bal);    APEX_JSON.write('direct', a_direct);
  APEX_JSON.write('invoiceCount', a_cnt);
  APEX_JSON.write('paidInvoices', a_p); APEX_JSON.write('partiallyPaidInvoices', a_pp);
  APEX_JSON.write('unpaidInvoices', a_up);
  APEX_JSON.write('paidBasis','Derived: each invoice header paid ratio, capped at 100 percent, applied to that invoice project distributions. ATD_PAYMENTS carries no invoice id or project so payments cannot be joined directly.');
  APEX_JSON.write('directTiesToButil','Y');
  APEX_JSON.close_object;

  APEX_JSON.open_object('revenue');
  APEX_JSON.write('billed', r_billed);      APEX_JSON.write('transactions', r_trx);
  APEX_JSON.write('customers', r_cust);     APEX_JSON.write('lines', r_lines);
  APEX_JSON.write('reconcilesToButil','N');
  APEX_JSON.open_object('receipts');
  APEX_JSON.write('status','DATA_GAP');
  APEX_JSON.write('reason','Billed revenue only. No AR receipts extract exists on the platform, so collections, outstanding receivable and DSO are not shown rather than estimated.');
  APEX_JSON.write('requiredSource','Fusion Receivables receipts and applications');
  APEX_JSON.close_object;
  APEX_JSON.close_object;

  APEX_JSON.open_object('pending');
  APEX_JSON.write('docs', n_pdocs);  APEX_JSON.write('amount', t_pamt);
  APEX_JSON.write('over30', n_p30);  APEX_JSON.write('maxDays', n_pmax);
  APEX_JSON.close_object;

  APEX_JSON.open_object('schedule');
  APEX_JSON.write('taskCount', k_tasks);
  APEX_JSON.write('tasksWithPlannedFinish', k_plan);
  APEX_JSON.write('tasksPlannedFinishPast', k_past);
  APEX_JSON.write('tasksWithActualFinish', k_actf);
  APEX_JSON.write('projectOverdueDays', NVL(k_ovd,0));
  APEX_JSON.write('elapsedPct', NVL(k_elapsed,0));
  APEX_JSON.write('plannedStart', TO_CHAR(k_pstart,'YYYY-MM-DD'));
  APEX_JSON.write('plannedFinish', TO_CHAR(k_pfin,'YYYY-MM-DD'));
  APEX_JSON.write('actualDatesAvailable', CASE WHEN k_actf > 0 THEN 'Y' ELSE 'N' END);
  APEX_JSON.write('note','Planned dates only. Task actual start and finish dates are empty in the source, so slippage is not computable and is not scored.');
  APEX_JSON.close_object;

  APEX_JSON.close_object;
  dct_gl_class_pkg.clear_butil_end; dct_gl_class_pkg.clear_butil_ovr;
EXCEPTION WHEN OTHERS THEN
  dct_gl_class_pkg.clear_butil_end; dct_gl_class_pkg.clear_butil_ovr;
  dct_rest.err(500, SQLERRM);
END;
!'));

END setup_gl_proj3_ords_tmp;
/

BEGIN setup_gl_proj3_ords_tmp; COMMIT; END;
/

DROP PROCEDURE setup_gl_proj3_ords_tmp;

PROMPT GL 22 part 3 (project 360 header) : done

CREATE OR REPLACE PROCEDURE setup_gl_proj4_ords_tmp AS
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

    ----------------------------------------------------------------------------
    -- 5. projects/:num/tasks -- planned dates + the task money position
    ----------------------------------------------------------------------------
    def_template('projects/[COLON]num/tasks');
    def_handler('projects/[COLON]num/tasks', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_num  VARCHAR2(60)  := [COLON]num;
  l_year NUMBER := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_period VARCHAR2(10) := [COLON]period;
  l_ovr  VARCHAR2(4) := UPPER(NVL([COLON]ovr,'N'));
  l_end  DATE; l_n NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  IF l_num IS NULL OR NOT REGEXP_LIKE(l_num,'^[A-Za-z0-9._-]{1,30}$') THEN
    dct_rest.err(400,'invalid project number'); RETURN; END IF;
  IF l_period = '' THEN l_period := NULL; END IF;
  IF l_period IS NOT NULL THEN
    IF NOT REGEXP_LIKE(l_period,'^(0[1-9]|1[0-2])-[0-9]{4}$')
       OR TO_NUMBER(SUBSTR(l_period,4)) <> l_year THEN
      dct_rest.err(400,'period must be MM-YYYY within the selected year'); RETURN; END IF;
    l_end := LAST_DAY(TO_DATE('01-'||l_period,'DD-MM-YYYY'));
  END IF;
  IF l_end IS NOT NULL THEN dct_gl_class_pkg.set_butil_end(l_end);
  ELSE dct_gl_class_pkg.clear_butil_end; END IF;
  dct_gl_class_pkg.set_butil_ovr(l_ovr);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('projectNumber', l_num); APEX_JSON.write('year', l_year);
  APEX_JSON.write('actualDatesAvailable','N');
  APEX_JSON.write('note','Planned dates only. Task actual start and finish dates are empty in the source.');
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT b.task_number, MAX(b.task_organization) task_org,
           SUM(b.budget) budget, SUM(b.budget_annual) budget_annual,
           SUM(b.actual_ap) actual_ap, SUM(b.actual_grn) actual_grn,
           SUM(b.commitment_pr) commitment_pr, SUM(b.obligation_po) obligation_po,
           SUM(b.fund_available) fund_available,
           COUNT(DISTINCT b.expenditure_type) etypes,
           MAX(t.task_name) task_name, MAX(t.planned_start_date) pstart,
           MAX(t.planned_finish_date) pfinish, MAX(t.work_type) work_type,
           MAX(t.chargeable_task) chargeable
      FROM prod.dct_budget_utilization_v b
      LEFT JOIN (SELECT tk.task_number, tk.task_name, tk.planned_start_date,
                        tk.planned_finish_date, tk.work_type, tk.chargeable_task
                   FROM prod.tasks tk
                   JOIN prod.projects pj ON pj.project_id = tk.project_id
                  WHERE TO_CHAR(pj.project_number) = l_num) t
        ON t.task_number = b.task_number
     WHERE b.budget_year = l_year AND b.project_number = l_num
     GROUP BY b.task_number
     ORDER BY SUM(b.budget_annual) DESC NULLS LAST) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('taskNumber', NVL(r.task_number,' '));
    APEX_JSON.write('taskName', NVL(r.task_name,' '));
    APEX_JSON.write('organization', NVL(r.task_org,' '));
    APEX_JSON.write('workType', NVL(r.work_type,' '));
    APEX_JSON.write('chargeable', NVL(r.chargeable,' '));
    APEX_JSON.write('plannedStart', TO_CHAR(r.pstart,'YYYY-MM-DD'));
    APEX_JSON.write('plannedFinish', TO_CHAR(r.pfinish,'YYYY-MM-DD'));
    APEX_JSON.write('plannedFinishPast',
      CASE WHEN r.pfinish IS NOT NULL AND r.pfinish < TRUNC(SYSDATE) THEN 'Y' ELSE 'N' END);
    APEX_JSON.write('budget', NVL(r.budget,0));
    APEX_JSON.write('budgetAnnual', NVL(r.budget_annual,0));
    APEX_JSON.write('actualAp', NVL(r.actual_ap,0));
    APEX_JSON.write('actualGrn', NVL(r.actual_grn,0));
    APEX_JSON.write('commitmentPr', NVL(r.commitment_pr,0));
    APEX_JSON.write('obligationPo', NVL(r.obligation_po,0));
    APEX_JSON.write('fundAvailable', NVL(r.fund_available,0));
    APEX_JSON.write('etypes', NVL(r.etypes,0));
    APEX_JSON.close_object;
    l_n := l_n + 1;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('count', l_n);
  APEX_JSON.close_object;
  dct_gl_class_pkg.clear_butil_end; dct_gl_class_pkg.clear_butil_ovr;
EXCEPTION WHEN OTHERS THEN
  dct_gl_class_pkg.clear_butil_end; dct_gl_class_pkg.clear_butil_ovr;
  dct_rest.err(500, SQLERRM);
END;
!');

    ----------------------------------------------------------------------------
    -- 6. projects/:num/revenue -- AR billed, with the receipts DATA GAP
    ----------------------------------------------------------------------------
    def_template('projects/[COLON]num/revenue');
    def_handler('projects/[COLON]num/revenue', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_num  VARCHAR2(60)  := [COLON]num;
  l_year NUMBER := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_n NUMBER := 0;
  t_billed NUMBER; t_trx NUMBER; t_cust NUMBER; t_lines NUMBER; t_ent NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  IF l_num IS NULL OR NOT REGEXP_LIKE(l_num,'^[A-Za-z0-9._-]{1,30}$') THEN
    dct_rest.err(400,'invalid project number'); RETURN; END IF;
  SELECT NVL(MAX(billed_revenue_aed),0), NVL(MAX(transaction_count),0),
         NVL(MAX(customer_count),0), NVL(MAX(line_count),0), NVL(MAX(fx_entered_lines),0)
    INTO t_billed, t_trx, t_cust, t_lines, t_ent
    FROM prod.dct_project_ar_rev_v WHERE budget_year = l_year AND project_number = l_num;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('projectNumber', l_num); APEX_JSON.write('year', l_year);
  APEX_JSON.open_object('summary');
  APEX_JSON.write('billed', t_billed);   APEX_JSON.write('transactions', t_trx);
  APEX_JSON.write('customers', t_cust);  APEX_JSON.write('lines', t_lines);
  APEX_JSON.write('enteredFxLines', t_ent);
  APEX_JSON.close_object;
  APEX_JSON.open_object('receipts');
  APEX_JSON.write('status','DATA_GAP');
  APEX_JSON.write('reason','Billed revenue only. No AR receipts extract exists on the platform, so collections, outstanding receivable and DSO are not shown rather than estimated.');
  APEX_JSON.write('requiredSource','Fusion Receivables receipts and applications');
  APEX_JSON.close_object;
  APEX_JSON.write('reconcilesToButil','N');
  APEX_JSON.open_array('byCustomer');
  FOR r IN (SELECT bill_to_customer_name nm, bill_to_customer_number num,
                   SUM(line_amount_aed) amt, COUNT(DISTINCT transaction_id) trx
              FROM prod.dct_project_ar_lines_v
             WHERE budget_year = l_year AND project_number = l_num
             GROUP BY bill_to_customer_name, bill_to_customer_number
             ORDER BY 3 DESC) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('customer', NVL(r.nm,' '));
    APEX_JSON.write('customerNumber', NVL(TO_CHAR(r.num),' '));
    APEX_JSON.write('amount', NVL(r.amt,0));
    APEX_JSON.write('transactions', NVL(r.trx,0));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT transaction_number, transaction_type_name, transaction_date, due_date,
                   bill_to_customer_name, line_description, line_amount_aed, fx_basis,
                   status, transaction_line_number
              FROM prod.dct_project_ar_lines_v
             WHERE budget_year = l_year AND project_number = l_num
             ORDER BY transaction_date DESC, transaction_number, transaction_line_number
             FETCH FIRST 500 ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('transactionNumber', NVL(r.transaction_number,' '));
    APEX_JSON.write('type', NVL(r.transaction_type_name,' '));
    APEX_JSON.write('transactionDate', TO_CHAR(r.transaction_date,'YYYY-MM-DD'));
    APEX_JSON.write('dueDate', TO_CHAR(r.due_date,'YYYY-MM-DD'));
    APEX_JSON.write('customer', NVL(r.bill_to_customer_name,' '));
    APEX_JSON.write('lineNumber', NVL(r.transaction_line_number,0));
    APEX_JSON.write('description', NVL(r.line_description,' '));
    APEX_JSON.write('amount', NVL(r.line_amount_aed,0));
    APEX_JSON.write('fxBasis', NVL(r.fx_basis,' '));
    APEX_JSON.write('status', NVL(r.status,' '));
    APEX_JSON.close_object;
    l_n := l_n + 1;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('count', l_n);
  APEX_JSON.write('capped', CASE WHEN l_n >= 500 THEN 'Y' ELSE 'N' END);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    ----------------------------------------------------------------------------
    -- 7. projects/:num/cashflow -- the uploaded plan, by period
    -- No plan vs actual curve in v1: butil has no period grain actual, and the
    -- Fusion budget is not cashflow phased, so an invented curve would not
    -- reconcile to anything. sparse=Y tells the page to show its empty state.
    ----------------------------------------------------------------------------
    def_template('projects/[COLON]num/cashflow');
    def_handler('projects/[COLON]num/cashflow', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_num  VARCHAR2(60)  := [COLON]num;
  l_year NUMBER := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_n NUMBER := 0; l_nz NUMBER := 0; t_plan NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  IF l_num IS NULL OR NOT REGEXP_LIKE(l_num,'^[A-Za-z0-9._-]{1,30}$') THEN
    dct_rest.err(400,'invalid project number'); RETURN; END IF;
  SELECT NVL(SUM(cf_amount),0), COUNT(DISTINCT CASE WHEN cf_amount <> 0 THEN accounting_period END)
    INTO t_plan, l_nz
    FROM prod.dct_project_cashflow WHERE project_number = l_num AND budget_year = l_year;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('projectNumber', l_num); APEX_JSON.write('year', l_year);
  APEX_JSON.write('planTotal', t_plan);
  APEX_JSON.open_array('periods');
  FOR r IN (SELECT accounting_period, MAX(period_date) pd, cf_type,
                   SUM(cf_amount) amt
              FROM prod.dct_project_cashflow
             WHERE project_number = l_num AND budget_year = l_year
             GROUP BY accounting_period, cf_type
             ORDER BY MAX(period_date), accounting_period) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('period', r.accounting_period);
    APEX_JSON.write('periodDate', TO_CHAR(r.pd,'YYYY-MM-DD'));
    APEX_JSON.write('cfType', NVL(r.cf_type,' '));
    APEX_JSON.write('planned', NVL(r.amt,0));
    APEX_JSON.close_object;
    l_n := l_n + 1;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('count', l_n);
  APEX_JSON.write('sparse', CASE WHEN l_nz < 3 THEN 'Y' ELSE 'N' END);
  APEX_JSON.write('note','Cashflow plan is uploaded on the GL Cashflow tab. The Fusion budget is not cashflow phased, so it cannot substitute for a missing plan.');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

END setup_gl_proj4_ords_tmp;
/

BEGIN setup_gl_proj4_ords_tmp; COMMIT; END;
/

DROP PROCEDURE setup_gl_proj4_ords_tmp;

PROMPT GL 22 part 4 (tasks, revenue, cashflow) : done

CREATE OR REPLACE PROCEDURE setup_gl_proj5_ords_tmp AS
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

    ----------------------------------------------------------------------------
    -- 8. projects/:num/pipeline
    -- Open PR, open PO, uninvoiced GRN and pending approvals in ONE call, all
    -- from the EXISTING db/v2/39 and db/v2/52 views. Those views already carry
    -- butil key definitions and BUTIL_END windows, so each array sums to the
    -- matching funnel stage without a second definition of the figure.
    ----------------------------------------------------------------------------
    def_template('projects/[COLON]num/pipeline');
    def_handler('projects/[COLON]num/pipeline', 'GET', TO_CLOB(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_num  VARCHAR2(60)  := [COLON]num;
  l_year NUMBER := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_period VARCHAR2(10) := [COLON]period;
  l_end DATE;
  n1 NUMBER := 0; n2 NUMBER := 0; n3 NUMBER := 0; n4 NUMBER := 0;
  t1 NUMBER; t2 NUMBER; t3 NUMBER; t4 NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  IF l_num IS NULL OR NOT REGEXP_LIKE(l_num,'^[A-Za-z0-9._-]{1,30}$') THEN
    dct_rest.err(400,'invalid project number'); RETURN; END IF;
  IF l_period = '' THEN l_period := NULL; END IF;
  IF l_period IS NOT NULL THEN
    IF NOT REGEXP_LIKE(l_period,'^(0[1-9]|1[0-2])-[0-9]{4}$')
       OR TO_NUMBER(SUBSTR(l_period,4)) <> l_year THEN
      dct_rest.err(400,'period must be MM-YYYY within the selected year'); RETURN; END IF;
    l_end := LAST_DAY(TO_DATE('01-'||l_period,'DD-MM-YYYY'));
  END IF;
  IF l_end IS NOT NULL THEN dct_gl_class_pkg.set_butil_end(l_end);
  ELSE dct_gl_class_pkg.clear_butil_end; END IF;

  SELECT NVL(SUM(amount_aed),0) INTO t1 FROM prod.dct_reserved_pr_lines_v
   WHERE budget_year = l_year AND project_number = l_num;
  SELECT NVL(SUM(open_aed),0) INTO t2 FROM prod.dct_open_po_lines_v
   WHERE budget_year = l_year AND project_number = l_num;
  SELECT NVL(SUM(uninvoiced_aed),0) INTO t3 FROM prod.dct_uninvoiced_grn_v
   WHERE budget_year = l_year AND project_number = l_num;
  SELECT NVL(SUM(line_aed),0) INTO t4 FROM prod.dct_pr_po_pending_v
   WHERE budget_year = l_year AND project_number = l_num AND ABS(NVL(line_aed,0)) > 0.005;

  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('projectNumber', l_num); APEX_JSON.write('year', l_year);
  IF l_period IS NOT NULL THEN APEX_JSON.write('period', l_period); END IF;
  APEX_JSON.open_object('totals');
  APEX_JSON.write('openPr', t1); APEX_JSON.write('openPo', t2);
  APEX_JSON.write('uninvoicedGrn', t3); APEX_JSON.write('pending', t4);
  APEX_JSON.close_object;

  APEX_JSON.open_array('openPr');
  FOR r IN (SELECT pr_number, task_number, expenditure_type, description, budget_date,
                   currency_code, amount_aed, funds_status
              FROM prod.dct_reserved_pr_lines_v
             WHERE budget_year = l_year AND project_number = l_num
             ORDER BY amount_aed DESC FETCH FIRST 500 ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('prNumber', NVL(TO_CHAR(r.pr_number),' '));
    APEX_JSON.write('taskNumber', NVL(r.task_number,' '));
    APEX_JSON.write('expenditureType', NVL(r.expenditure_type,' '));
    APEX_JSON.write('description', NVL(r.description,' '));
    APEX_JSON.write('budgetDate', TO_CHAR(r.budget_date,'YYYY-MM-DD'));
    APEX_JSON.write('currency', NVL(r.currency_code,' '));
    APEX_JSON.write('amount', NVL(r.amount_aed,0));
    APEX_JSON.write('fundsStatus', NVL(r.funds_status,' '));
    APEX_JSON.close_object; n1 := n1 + 1;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('openPo');
  FOR r IN (SELECT po_number, po_line, task_number, expenditure_type, supplier_name,
                   budget_date, funds_status, line_aed, received_aed, open_aed
              FROM prod.dct_open_po_lines_v
             WHERE budget_year = l_year AND project_number = l_num
             ORDER BY open_aed DESC FETCH FIRST 500 ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('poNumber', NVL(TO_CHAR(r.po_number),' '));
    APEX_JSON.write('poLine', NVL(TO_CHAR(r.po_line),' '));
    APEX_JSON.write('taskNumber', NVL(r.task_number,' '));
    APEX_JSON.write('expenditureType', NVL(r.expenditure_type,' '));
    APEX_JSON.write('supplier', NVL(r.supplier_name,' '));
    APEX_JSON.write('budgetDate', TO_CHAR(r.budget_date,'YYYY-MM-DD'));
    APEX_JSON.write('fundsStatus', NVL(r.funds_status,' '));
    APEX_JSON.write('ordered', NVL(r.line_aed,0));
    APEX_JSON.write('received', NVL(r.received_aed,0));
    APEX_JSON.write('open', NVL(r.open_aed,0));
    APEX_JSON.close_object; n2 := n2 + 1;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('uninvoicedGrn');
  FOR r IN (SELECT po_number, po_line, task_number, expenditure_type, supplier_name,
                   last_receipt_date, receipt_lines, received_aed, invoiced_aed, uninvoiced_aed
              FROM prod.dct_uninvoiced_grn_v
             WHERE budget_year = l_year AND project_number = l_num
             ORDER BY uninvoiced_aed DESC FETCH FIRST 500 ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('poNumber', NVL(TO_CHAR(r.po_number),' '));
    APEX_JSON.write('poLine', NVL(TO_CHAR(r.po_line),' '));
    APEX_JSON.write('taskNumber', NVL(r.task_number,' '));
    APEX_JSON.write('expenditureType', NVL(r.expenditure_type,' '));
    APEX_JSON.write('supplier', NVL(r.supplier_name,' '));
    APEX_JSON.write('lastReceiptDate', TO_CHAR(r.last_receipt_date,'YYYY-MM-DD'));
    APEX_JSON.write('receiptLines', NVL(r.receipt_lines,0));
    APEX_JSON.write('received', NVL(r.received_aed,0));
    APEX_JSON.write('invoiced', NVL(r.invoiced_aed,0));
    APEX_JSON.write('uninvoiced', NVL(r.uninvoiced_aed,0));
    APEX_JSON.close_object; n3 := n3 + 1;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('pending');
  FOR r IN (SELECT source, doc_number, doc_line, descr, preparer_buyer, submitted_date,
                   pending_with, pending_days, funds_status, line_aed, task_number, expenditure_type
              FROM prod.dct_pr_po_pending_v
             WHERE budget_year = l_year AND project_number = l_num
               AND ABS(NVL(line_aed,0)) > 0.005
             ORDER BY pending_days DESC NULLS LAST FETCH FIRST 500 ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('source', NVL(r.source,' '));
    APEX_JSON.write('docNumber', NVL(TO_CHAR(r.doc_number),' '));
    APEX_JSON.write('docLine', NVL(TO_CHAR(r.doc_line),' '));
    APEX_JSON.write('description', NVL(r.descr,' '));
    APEX_JSON.write('preparer', NVL(r.preparer_buyer,' '));
    APEX_JSON.write('submittedDate', TO_CHAR(r.submitted_date,'YYYY-MM-DD'));
    APEX_JSON.write('pendingWith', NVL(r.pending_with,' '));
    APEX_JSON.write('pendingDays', NVL(r.pending_days,0));
    APEX_JSON.write('fundsStatus', NVL(r.funds_status,' '));
    APEX_JSON.write('taskNumber', NVL(r.task_number,' '));
    APEX_JSON.write('expenditureType', NVL(r.expenditure_type,' '));
    APEX_JSON.write('amount', NVL(r.line_aed,0));
    APEX_JSON.close_object; n4 := n4 + 1;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_object('counts');
  APEX_JSON.write('openPr', n1); APEX_JSON.write('openPo', n2);
  APEX_JSON.write('uninvoicedGrn', n3); APEX_JSON.write('pending', n4);
  APEX_JSON.close_object;
  APEX_JSON.close_object;
  dct_gl_class_pkg.clear_butil_end;
EXCEPTION WHEN OTHERS THEN
  dct_gl_class_pkg.clear_butil_end;
  dct_rest.err(500, SQLERRM);
END;
!'));

    ----------------------------------------------------------------------------
    -- 9. projects/:num/invoices -- AP invoices with the derived paid ratio
    ----------------------------------------------------------------------------
    def_template('projects/[COLON]num/invoices');
    def_handler('projects/[COLON]num/invoices', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_num  VARCHAR2(60)  := [COLON]num;
  l_year NUMBER := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_stat VARCHAR2(60) := [COLON]status;
  l_period VARCHAR2(10) := [COLON]period;
  l_end DATE; l_n NUMBER := 0; t_amt NUMBER; t_bal NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  IF l_num IS NULL OR NOT REGEXP_LIKE(l_num,'^[A-Za-z0-9._-]{1,30}$') THEN
    dct_rest.err(400,'invalid project number'); RETURN; END IF;
  IF l_period = '' THEN l_period := NULL; END IF;
  IF l_period IS NOT NULL THEN
    IF NOT REGEXP_LIKE(l_period,'^(0[1-9]|1[0-2])-[0-9]{4}$')
       OR TO_NUMBER(SUBSTR(l_period,4)) <> l_year THEN
      dct_rest.err(400,'period must be MM-YYYY within the selected year'); RETURN; END IF;
    l_end := LAST_DAY(TO_DATE('01-'||l_period,'DD-MM-YYYY'));
  END IF;
  IF l_end IS NOT NULL THEN dct_gl_class_pkg.set_butil_end(l_end);
  ELSE dct_gl_class_pkg.clear_butil_end; END IF;
  SELECT NVL(SUM(matched_aed),0), NVL(SUM(balance_due),0) INTO t_amt, t_bal
    FROM prod.dct_unpaid_invoices_v
   WHERE budget_year = l_year AND project_number = l_num
     AND (l_stat IS NULL OR payment_status = l_stat);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('projectNumber', l_num); APEX_JSON.write('year', l_year);
  APEX_JSON.write('matchedTotal', t_amt); APEX_JSON.write('balanceTotal', t_bal);
  APEX_JSON.write('note','Balance due is invoice currency as loaded; matched AED is the project share of the invoice.');
  APEX_JSON.open_array('items');
  FOR r IN (SELECT invoice_number, invoice_date, supplier_name, task_number, expenditure_type,
                   invoice_currency, invoice_amount, invoice_amount_paid, balance_due,
                   matched_aed, validation_status, payment_status, has_po
              FROM prod.dct_unpaid_invoices_v
             WHERE budget_year = l_year AND project_number = l_num
               AND (l_stat IS NULL OR payment_status = l_stat)
             ORDER BY invoice_date DESC NULLS LAST, invoice_number
             FETCH FIRST 500 ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('invoiceNumber', NVL(r.invoice_number,' '));
    APEX_JSON.write('invoiceDate', TO_CHAR(r.invoice_date,'YYYY-MM-DD'));
    APEX_JSON.write('supplier', NVL(r.supplier_name,' '));
    APEX_JSON.write('taskNumber', NVL(r.task_number,' '));
    APEX_JSON.write('expenditureType', NVL(r.expenditure_type,' '));
    APEX_JSON.write('currency', NVL(r.invoice_currency,' '));
    APEX_JSON.write('invoiceAmount', NVL(r.invoice_amount,0));
    APEX_JSON.write('amountPaid', NVL(r.invoice_amount_paid,0));
    APEX_JSON.write('balanceDue', NVL(r.balance_due,0));
    APEX_JSON.write('matchedAed', NVL(r.matched_aed,0));
    APEX_JSON.write('validationStatus', NVL(r.validation_status,' '));
    APEX_JSON.write('paymentStatus', NVL(r.payment_status,' '));
    APEX_JSON.write('hasPo', NVL(r.has_po,' '));
    APEX_JSON.close_object; l_n := l_n + 1;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('count', l_n);
  APEX_JSON.write('capped', CASE WHEN l_n >= 500 THEN 'Y' ELSE 'N' END);
  APEX_JSON.close_object;
  dct_gl_class_pkg.clear_butil_end;
EXCEPTION WHEN OTHERS THEN
  dct_gl_class_pkg.clear_butil_end;
  dct_rest.err(500, SQLERRM);
END;
!');

    ----------------------------------------------------------------------------
    -- 10. projects/:num/trx -- budget transactions touching the project
    -- PERF LAW: the line key set MUST be a materialized CTE probed by EXISTS.
    -- A correlated EXISTS, or even an uncorrelated IN with UNNEST, lets the
    -- optimizer pick VIEW PUSHED PREDICATE and rebuild the 3 table union per
    -- header row (39s per execution, page never returns).
    ----------------------------------------------------------------------------
    def_template('projects/[COLON]num/trx');
    def_handler('projects/[COLON]num/trx', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_num  VARCHAR2(60)  := [COLON]num;
  l_year NUMBER := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_n NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  IF l_num IS NULL OR NOT REGEXP_LIKE(l_num,'^[A-Za-z0-9._-]{1,30}$') THEN
    dct_rest.err(400,'invalid project number'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('projectNumber', l_num); APEX_JSON.write('year', l_year);
  APEX_JSON.open_array('items');
  FOR r IN (
    WITH lf AS (SELECT /*+ MATERIALIZE */ DISTINCT transaction_num tn, trx_type tt,
                       COUNT(*) OVER (PARTITION BY transaction_num) lines
                  FROM prod.v_pa_budget_trx_line
                 WHERE project_num = l_num)
    SELECT h.transaction_num, h.transaction_type, h.transaction_date, h.status,
           h.business_unit, h.decree_no, h.dept_1st_level_approver, h.organization,
           h.project_approved_cost, h.project_total_cost, lf.lines
      FROM prod.pa_budget_trx_headers h
      JOIN lf ON lf.tn = h.transaction_num
     WHERE (l_year IS NULL OR EXTRACT(YEAR FROM h.transaction_date) = l_year)
     ORDER BY h.transaction_date DESC NULLS LAST, h.transaction_num
     FETCH FIRST 300 ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('transactionNum', NVL(r.transaction_num,' '));
    APEX_JSON.write('transactionType', NVL(r.transaction_type,' '));
    APEX_JSON.write('transactionDate', NVL(TO_CHAR(r.transaction_date),' '));
    APEX_JSON.write('status', NVL(r.status,' '));
    APEX_JSON.write('businessUnit', NVL(r.business_unit,' '));
    APEX_JSON.write('decreeNo', NVL(r.decree_no,' '));
    APEX_JSON.write('approver', NVL(r.dept_1st_level_approver,' '));
    APEX_JSON.write('organization', NVL(r.organization,' '));
    APEX_JSON.write('approvedCost', NVL(r.project_approved_cost,0));
    APEX_JSON.write('totalCost', NVL(r.project_total_cost,0));
    APEX_JSON.write('lines', NVL(r.lines,0));
    APEX_JSON.close_object; l_n := l_n + 1;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('count', l_n);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

END setup_gl_proj5_ords_tmp;
/

BEGIN setup_gl_proj5_ords_tmp; COMMIT; END;
/

DROP PROCEDURE setup_gl_proj5_ords_tmp;

PROMPT GL 22 part 5 (pipeline, invoices, trx) : done
