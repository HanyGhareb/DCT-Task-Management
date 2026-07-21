-- =============================================================================
-- General Ledger (App 210) -- Budget Utilization ORDS endpoints (ADDITIVE)
-- File    : 07_gl_budget_util_ords.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp @07_gl_budget_util_ords.sql  (fresh session)
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            re-run THIS script right after it (same rule as ATD db/42).
-- Endpoints:
--   GET /gl/butil/filters  -> years (default = latest) + project types + sectors
--   GET /gl/butil/lov?year= -> autocomplete LOVs for the filter bar: cost
--       centres (code + department), projects (number + name), tasks,
--       expenditure types -- distinct values of the given budget year.
--   GET /gl/butil?year=    -> {total, totals{...}, items[...]} -- year REQUIRED,
--       optional projecttype / sector / chapter / costcenter / project / task / etype
--       (contains-match, fed by the LOVs) / search / limit / offset.
--       MULTI-SELECT (2026-07-14): chapter / costcenter / project accept a
--       pipe-delimited value list (a|b|c). A pipe-list matches EXACT values
--       (chapter text, cost-centre code, project number); a single pipe-less
--       value keeps the original semantics (chapter exact, costcenter/project
--       contains-match) so free-typed filters still work. Same params on
--       /gl/butil/lines (costcenter/fproject) and the /gl/butil/book bridge, and
--       period=MM-YYYY (must belong to the year) -> YTD THROUGH that period:
--       sets SYS_CONTEXT('GL_CTX','BUTIL_END') via dct_gl_class_pkg.set_butil_end
--       so the view's fact CTEs stop at the period end (budget stays annual);
--       always cleared after the queries (and on error) -- pooled sessions.
--   GET /gl/butil/lines?year=&project=&task=&etype=&metric=  -> a single figure
--       (metric ap|grn|pr|po|budget|budgetannual) drilled to its supporting lines
--       {metric, total, columns[], rows[]}; totals reconcile to the row figure.
--       Every drawer identifies rows by document number + line number (AP
--       invoice #/line, GRN #/line, PR #/line, PO #/line) and suppresses
--       zero-amount lines (zeros add nothing, so totals still reconcile).
--       Accepts the same period=MM-YYYY (YTD) -- applied as inline date bounds
--       on the fact queries (incl. the PO GRN-netting) so drill totals keep
--       reconciling to the period-filtered figures. GRN dates use
--       NVL(ACCOUNTED_DATE, TRANSACTION_DATE) (accounting-period basis).
-- Source  : prod.dct_budget_utilization_v (db/v2/37) + the same base facts.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_butil_ords_tmp AS

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
    -- FILTERS -- budget years (mandatory pick) + LOVs
    -- =========================================================================
    def_template('butil/filters');
    def_handler('butil/filters', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid NUMBER := dct_auth.get_user_id(l_user);
  l_secok NUMBER := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  l_year NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  SELECT MAX(budget_year) INTO l_year FROM prod.dct_budget_utilization_v;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('defaultYear', l_year);
  APEX_JSON.open_array('years');
  FOR r IN (SELECT DISTINCT budget_year y FROM prod.dct_budget_utilization_v ORDER BY budget_year DESC) LOOP
    APEX_JSON.write(r.y);
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('projectTypes');
  FOR r IN (SELECT DISTINCT project_type pt FROM prod.dct_budget_utilization_v ORDER BY project_type) LOOP
    APEX_JSON.write(r.pt);
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('sectors');
  FOR r IN (SELECT DISTINCT sector s FROM prod.dct_budget_utilization_v WHERE sector IS NOT NULL ORDER BY sector) LOOP
    APEX_JSON.write(r.s);
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('chapters');
  FOR r IN (SELECT DISTINCT chapter ch FROM prod.dct_budget_utilization_v WHERE chapter IS NOT NULL ORDER BY chapter) LOOP
    APEX_JSON.write(r.ch);
  END LOOP;
  APEX_JSON.close_array;
  -- Business Units of the budget lines (project attribution via the projects
  -- master); grows automatically when the extracts carry more BUs
  APEX_JSON.open_array('businessUnits');
  FOR r IN (SELECT DISTINCT business_unit b FROM prod.dct_budget_utilization_v WHERE business_unit IS NOT NULL ORDER BY business_unit) LOOP
    APEX_JSON.write(r.b);
  END LOOP;
  APEX_JSON.close_array;
  -- Appropriation + DCT Program classification dimensions (exact-match LOVs)
  APEX_JSON.open_array('appropriations');
  FOR r IN (SELECT DISTINCT appropriation a FROM prod.dct_budget_utilization_v WHERE appropriation IS NOT NULL ORDER BY appropriation) LOOP
    APEX_JSON.write(r.a);
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('programs');
  FOR r IN (SELECT DISTINCT program pg FROM prod.dct_budget_utilization_v WHERE program IS NOT NULL ORDER BY program) LOOP
    APEX_JSON.write(r.pg);
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- FILTER LOVs -- autocomplete lists for the search bar, per budget year.
    --   GET /gl/butil/lov?year=  (year optional -> all years)
    --   -> {costCenters[{cc,dept}], projects[{p,n}], tasks[], etypes[]}
    -- =========================================================================
    def_template('butil/lov');
    def_handler('butil/lov', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid NUMBER := dct_auth.get_user_id(l_user);
  l_secok NUMBER := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  l_year NUMBER := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  APEX_JSON.open_array('costCenters');
  FOR r IN (SELECT cost_centre cc, MAX(department) dept FROM prod.dct_budget_utilization_v
            WHERE cost_centre IS NOT NULL AND (l_year IS NULL OR budget_year = l_year)
            GROUP BY cost_centre ORDER BY cost_centre) LOOP
    APEX_JSON.open_object; APEX_JSON.write('cc', r.cc); APEX_JSON.write('dept', NVL(r.dept,'')); APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('projects');
  FOR r IN (SELECT project_number p, MAX(project_name) n FROM prod.dct_budget_utilization_v
            WHERE project_number IS NOT NULL AND project_number NOT LIKE '#%' AND (l_year IS NULL OR budget_year = l_year)
            GROUP BY project_number ORDER BY project_number) LOOP
    APEX_JSON.open_object; APEX_JSON.write('p', r.p); APEX_JSON.write('n', NVL(r.n,'')); APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('tasks');
  FOR r IN (SELECT DISTINCT task_number t FROM prod.dct_budget_utilization_v
            WHERE task_number IS NOT NULL AND task_number NOT LIKE '#%' AND (l_year IS NULL OR budget_year = l_year)
            ORDER BY task_number) LOOP
    APEX_JSON.write(r.t);
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('etypes');
  FOR r IN (SELECT DISTINCT expenditure_type et FROM prod.dct_budget_utilization_v
            WHERE expenditure_type IS NOT NULL AND (l_year IS NULL OR budget_year = l_year)
            ORDER BY expenditure_type) LOOP
    APEX_JSON.write(r.et);
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- BUDGET UTILIZATION -- one row per project x task x expenditure type.
    --   GET /gl/butil?year=&projecttype=&sector=&costcenter=&project=&task=
    --                 &etype=&search=&limit=&offset=
    --   year is REQUIRED (400 otherwise). costcenter/project/task/etype are
    --   contains-match filters fed by /gl/butil/lov (project matches number
    --   OR name). Returns {total, totals{...}, items[...]}.
    -- =========================================================================
    def_template('butil');
    def_handler('butil', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_uid NUMBER := dct_auth.get_user_id(l_user);
  l_secok NUMBER := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  l_year   NUMBER        := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_ptype  VARCHAR2(100) := [COLON]projecttype;
  l_sector VARCHAR2(200) := [COLON]sector;
  l_chapter VARCHAR2(2000) := [COLON]chapter;
  l_bu      VARCHAR2(2000) := [COLON]bu;
  l_approp  VARCHAR2(2000) := [COLON]appropriation;
  l_program VARCHAR2(2000) := [COLON]program;
  l_cc     VARCHAR2(2000) := [COLON]costcenter;
  l_proj   VARCHAR2(2000) := [COLON]project;
  l_task   VARCHAR2(200) := [COLON]task;
  l_etype  VARCHAR2(255) := [COLON]etype;
  l_search VARCHAR2(200) := [COLON]search;
  l_period VARCHAR2(10)  := [COLON]period;
  l_end    DATE;
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit  DEFAULT NULL ON CONVERSION ERROR), 100), 5000);
  l_offset NUMBER := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_total  NUMBER;
  t_bud NUMBER; t_buda NUMBER; t_ap NUMBER; t_grn NUMBER; t_pr NUMBER; t_po NUMBER; t_fund NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  IF l_period = '' THEN l_period := NULL; END IF;
  IF l_period IS NOT NULL THEN
    IF NOT REGEXP_LIKE(l_period, '^(0[1-9]|1[0-2])-[0-9]{4}$')
       OR TO_NUMBER(SUBSTR(l_period, 4)) <> l_year THEN
      dct_rest.err(400,'period must be MM-YYYY within the selected year'); RETURN;
    END IF;
    l_end := LAST_DAY(TO_DATE('01-'||l_period, 'DD-MM-YYYY'));
  END IF;
  -- YTD window: view fact CTEs read GL_CTX.BUTIL_END; always cleared below
  IF l_end IS NOT NULL THEN dct_gl_class_pkg.set_butil_end(l_end);
  ELSE dct_gl_class_pkg.clear_butil_end; END IF;
  SELECT COUNT(*), NVL(SUM(budget),0), NVL(SUM(budget_annual),0), NVL(SUM(actual_ap),0), NVL(SUM(actual_grn),0),
         NVL(SUM(commitment_pr),0), NVL(SUM(obligation_po),0), NVL(SUM(fund_available),0)
    INTO l_total, t_bud, t_buda, t_ap, t_grn, t_pr, t_po, t_fund
    FROM prod.dct_budget_utilization_v v
   WHERE v.budget_year = l_year
     AND (l_ptype  IS NULL OR v.project_type = l_ptype)
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
     AND (l_task   IS NULL OR UPPER(v.task_number) LIKE '%'||UPPER(l_task)||'%')
     AND (l_etype  IS NULL OR UPPER(v.expenditure_type) LIKE '%'||UPPER(l_etype)||'%')
     AND (l_search IS NULL OR UPPER(v.project_number||' '||v.project_name||' '||v.task_number||' '
                                   ||v.department||' '||v.cost_centre||' '||v.expenditure_type) LIKE '%'||UPPER(l_search)||'%');
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('total', l_total); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.write('year', l_year);
  IF l_period IS NOT NULL THEN APEX_JSON.write('period', l_period); END IF;
  APEX_JSON.open_object('totals');
  APEX_JSON.write('budget', t_bud); APEX_JSON.write('budgetAnnual', t_buda);
  APEX_JSON.write('actualAp', t_ap); APEX_JSON.write('actualGrn', t_grn);
  APEX_JSON.write('commitmentPr', t_pr); APEX_JSON.write('obligationPo', t_po); APEX_JSON.write('fundAvailable', t_fund);
  APEX_JSON.close_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT v.* FROM prod.dct_budget_utilization_v v
    WHERE v.budget_year = l_year
      AND (l_ptype  IS NULL OR v.project_type = l_ptype)
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
      AND (l_task   IS NULL OR UPPER(v.task_number) LIKE '%'||UPPER(l_task)||'%')
      AND (l_etype  IS NULL OR UPPER(v.expenditure_type) LIKE '%'||UPPER(l_etype)||'%')
      AND (l_search IS NULL OR UPPER(v.project_number||' '||v.project_name||' '||v.task_number||' '
                                    ||v.department||' '||v.cost_centre||' '||v.expenditure_type) LIKE '%'||UPPER(l_search)||'%')
    ORDER BY v.project_type, v.project_number, v.task_number, v.expenditure_type
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('projectType', NVL(r.project_type,''));
    APEX_JSON.write('sector', NVL(r.sector,''));
    APEX_JSON.write('department', NVL(r.department,''));
    APEX_JSON.write('costCentre', NVL(r.cost_centre,''));
    APEX_JSON.write('projectNumber', NVL(r.project_number,''));
    APEX_JSON.write('projectName', NVL(r.project_name,''));
    APEX_JSON.write('taskNumber', NVL(r.task_number,''));
    APEX_JSON.write('glAccount', NVL(r.gl_account,''));
    APEX_JSON.write('appropriation', NVL(r.appropriation,''));
    APEX_JSON.write('chapter', NVL(r.chapter,''));
    APEX_JSON.write('program', NVL(r.program,''));
    APEX_JSON.write('expenditureType', NVL(r.expenditure_type,''));
    APEX_JSON.write('budget', r.budget);
    APEX_JSON.write('budgetAnnual', r.budget_annual);
    APEX_JSON.write('actualAp', r.actual_ap);
    APEX_JSON.write('actualGrn', r.actual_grn);
    APEX_JSON.write('commitmentPr', r.commitment_pr);
    APEX_JSON.write('obligationPo', r.obligation_po);
    APEX_JSON.write('fundAvailable', r.fund_available);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
  dct_gl_class_pkg.clear_butil_end;
EXCEPTION WHEN OTHERS THEN dct_gl_class_pkg.clear_butil_end; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- BUDGET UTILIZATION DRILL-DOWN -- a figure -> its supporting lines.
    --   GET /gl/butil/lines?year=&metric=[&project=&task=&etype=]
    --                       [&projecttype=&sector=&search=]
    --                       [&costcenter=&fproject=&ftask=&fetype=]
    --                       [&period=MM-YYYY]  (YTD through the period)
    --   metric in ap | grn | pr | po | budget | budgetannual (Actual AP /
    --     Actual GRN / Commitment PR / Obligation PO / YTD Budget periods /
    --     Annual Budget periods). Two modes off ONE query (a `kys` key-set CTE):
    --     * ROW drill  (project [+task+etype] supplied) -> that one budget line.
    --     * CARD drill (project omitted) -> aggregate across every budget line
    --       matching the /gl/butil filters (projecttype/sector/search) -- the
    --       KPI-card totals; adds Project/Task columns.
    --   Filters + amounts mirror prod.dct_budget_utilization_v (db/v2/37) so the
    --   drill total always reconciles to the on-screen figure. Rows capped at
    --   10000 (top by amount; was 1000 -- the aggregate KPI-card drill spans the
    --   whole filtered set (~3k AP lines) so a 1000-row cap truncated the small
    --   lines out of the visible list even though `total`/`count` counted them:
    --   the header showed the full figure, the body only the 1000 largest);
    --   `total`+`count` are the FULL windowed aggregates.
    --   Returns {metric, aggregate, total, count, columns[{key,label,type}], rows[]}.
    -- =========================================================================
    def_template('butil/lines');
    def_handler('butil/lines', 'GET', q'!
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_uid NUMBER := dct_auth.get_user_id(l_user);
  l_secok NUMBER := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  l_year    NUMBER        := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_project VARCHAR2(120) := [COLON]project;
  l_task    VARCHAR2(120) := [COLON]task;
  l_etype   VARCHAR2(255) := [COLON]etype;
  l_metric  VARCHAR2(20)  := LOWER([COLON]metric);   -- fits 'budgetannual' (12); a DECLARE-section VALUE_ERROR = uncatchable 555
  l_ptype   VARCHAR2(100) := [COLON]projecttype;
  l_sector  VARCHAR2(200) := [COLON]sector;
  l_chapter VARCHAR2(2000) := [COLON]chapter;
  l_bu      VARCHAR2(2000) := [COLON]bu;
  l_approp  VARCHAR2(2000) := [COLON]appropriation;
  l_program VARCHAR2(2000) := [COLON]program;
  l_cc      VARCHAR2(2000) := [COLON]costcenter;
  l_fproj   VARCHAR2(2000) := [COLON]fproject;
  l_ftask   VARCHAR2(200) := [COLON]ftask;
  l_fetype  VARCHAR2(255) := [COLON]fetype;
  l_search  VARCHAR2(200) := [COLON]search;
  l_period  VARCHAR2(10)  := [COLON]period;
  l_end     DATE;
  l_agg     BOOLEAN;
  l_total   NUMBER := 0;
  l_count   NUMBER := 0;
  PROCEDURE col(p_key VARCHAR2, p_label VARCHAR2, p_type VARCHAR2) IS
  BEGIN
    APEX_JSON.open_object; APEX_JSON.write('key',p_key); APEX_JSON.write('label',p_label); APEX_JSON.write('type',p_type); APEX_JSON.close_object;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  IF l_year IS NULL OR l_metric IS NULL THEN dct_rest.err(400,'year and metric are required'); RETURN; END IF;
  -- project/task/etype set -> single row drill; project omitted -> aggregate
  -- drill (KPI card) filtered like /gl/butil: projecttype/sector/search plus
  -- the LOV filters costcenter/fproject/ftask/fetype (f-prefixed so they do
  -- not collide with the row-drill key params project/task/etype).
  IF l_project = '' THEN l_project := NULL; END IF;
  IF l_task    = '' THEN l_task    := NULL; END IF;
  IF l_etype   = '' THEN l_etype   := NULL; END IF;
  IF l_ptype   = '' THEN l_ptype   := NULL; END IF;
  IF l_sector  = '' THEN l_sector  := NULL; END IF;
  IF l_chapter = '' THEN l_chapter := NULL; END IF;
  IF l_bu = '' THEN l_bu := NULL; END IF;
  IF l_cc      = '' THEN l_cc      := NULL; END IF;
  IF l_fproj   = '' THEN l_fproj   := NULL; END IF;
  IF l_ftask   = '' THEN l_ftask   := NULL; END IF;
  IF l_fetype  = '' THEN l_fetype  := NULL; END IF;
  IF l_search  = '' THEN l_search  := NULL; END IF;
  IF l_period  = '' THEN l_period  := NULL; END IF;
  -- YTD period end (MM-YYYY within the year) -- inline date bound on the fact
  -- queries below, mirroring the view's GL_CTX.BUTIL_END window exactly.
  IF l_period IS NOT NULL THEN
    IF NOT REGEXP_LIKE(l_period, '^(0[1-9]|1[0-2])-[0-9]{4}$')
       OR TO_NUMBER(SUBSTR(l_period, 4)) <> l_year THEN
      dct_rest.err(400,'period must be MM-YYYY within the selected year'); RETURN;
    END IF;
    l_end := LAST_DAY(TO_DATE('01-'||l_period, 'DD-MM-YYYY'));
  END IF;
  l_agg := (l_project IS NULL);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('metric', l_metric);
  APEX_JSON.write('aggregate', CASE WHEN l_agg THEN 'Y' ELSE 'N' END);

  IF l_metric = 'ap' THEN
    APEX_JSON.open_array('columns');
    IF l_agg THEN col('project','Project','text'); col('task','Task','text'); END IF;
    col('invoice','Invoice #','text'); col('line','Line','text'); col('date','Invoice date','date'); col('vendor','Vendor','text');
    col('currency','Cur','text'); col('invAmount','Invoice amount','money'); col('amount','Distribution (AED)','money');
    col('validation','Validation','text'); col('payment','Payment','text'); col('description','Description','text');
    APEX_JSON.close_array;
    APEX_JSON.open_array('rows');
    FOR r IN (
      WITH kys AS (
             SELECT CAST(l_project AS VARCHAR2(120)) pk, NVL(l_task,'~') tk, NVL(l_etype,'~') et FROM dual WHERE l_project IS NOT NULL
             UNION ALL
             SELECT v.project_number, NVL(v.task_number,'~'), NVL(v.expenditure_type,'~') FROM prod.dct_budget_utilization_v v
             WHERE l_project IS NULL AND v.budget_year = l_year
               AND (l_ptype  IS NULL OR v.project_type = l_ptype)
               AND (l_sector IS NULL OR v.sector = l_sector)
     AND (l_secok = 1 OR v.sector IN (SELECT cv.name_en FROM prod.dct_gl_class_value cv JOIN prod.v_dct_sec_user_scope sc ON sc.object_key = cv.value_code AND sc.object_type_code = 'SECTOR' AND sc.user_id = l_uid WHERE cv.class_type_code = 'SECTOR'))
               AND (l_chapter IS NULL OR INSTR('|'||l_chapter||'|', '|'||v.chapter||'|') > 0)
               AND (l_bu IS NULL OR INSTR('|'||l_bu||'|', '|'||v.business_unit||'|') > 0)
               AND (l_approp  IS NULL OR INSTR('|'||l_approp||'|', '|'||v.appropriation||'|') > 0)
               AND (l_program IS NULL OR INSTR('|'||l_program||'|', '|'||v.program||'|') > 0)
               AND (l_cc     IS NULL OR (INSTR(l_cc,'|') = 0 AND v.cost_centre LIKE '%'||l_cc||'%')
                                     OR INSTR('|'||l_cc||'|', '|'||v.cost_centre||'|') > 0)
               AND (l_fproj  IS NULL OR (INSTR(l_fproj,'|') = 0 AND UPPER(v.project_number||' '||v.project_name) LIKE '%'||UPPER(l_fproj)||'%')
                                     OR INSTR('|'||l_fproj||'|', '|'||v.project_number||'|') > 0)
               AND (l_ftask  IS NULL OR UPPER(v.task_number) LIKE '%'||UPPER(l_ftask)||'%')
               AND (l_fetype IS NULL OR UPPER(v.expenditure_type) LIKE '%'||UPPER(l_fetype)||'%')
               AND (l_search IS NULL OR UPPER(v.project_number||' '||v.project_name||' '||v.task_number||' '||v.department||' '||v.cost_centre||' '||v.expenditure_type) LIKE '%'||UPPER(l_search)||'%')),
           proj AS (SELECT project_id, MAX(project_number) project_number FROM prod.projects GROUP BY project_id),
           tsk  AS (SELECT task_id, MAX(task_number) task_number FROM prod.tasks GROUP BY task_id)
      SELECT COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(d.project_id)) pkey,
             COALESCE(tk.task_number, CASE WHEN d.task_id IS NOT NULL THEN '#'||TO_CHAR(d.task_id) END) tkey,
             i.invoice_id, i.invoice_number, d.line_number line_no, TO_CHAR(i.invoice_date,'YYYY-MM-DD') idate, se.supplier_name,
             NVL(i.invoice_currency,'AED') cur, i.invoice_amount inv_amt,
             NVL(d.distribution_amount_functi, d.distribution_amount) amt_aed,
             i.validation_status, d.distribution_description descr,
             CASE WHEN NVL(i.invoice_amount,0) = 0 THEN ''
                  WHEN ABS(NVL(i.invoice_amount_paid,0)) >= ABS(NVL(i.invoice_amount,0)) - 0.005 THEN 'Paid'
                  WHEN NVL(i.invoice_amount_paid,0) <> 0 THEN 'Partially Paid'
                  ELSE 'Unpaid' END pay_status,
             COUNT(*) OVER () full_n, SUM(NVL(d.distribution_amount_functi, d.distribution_amount)) OVER () full_tot
      FROM prod.ap_invoice_distributions d
      JOIN prod.ap_invoices i     ON i.invoice_id = d.invoice_id
      LEFT JOIN prod.dct_ap_supplier_eff_v se ON se.invoice_id = d.invoice_id
      JOIN prod.dct_gl_coa_snap cid ON cid.cc_id = d.cc_id
      LEFT JOIN proj pj ON pj.project_id = d.project_id
      LEFT JOIN tsk  tk ON tk.task_id    = d.task_id
      WHERE d.po_number IS NULL AND NVL(d.reversal_indicator,'N') <> 'Y' AND d.project_id IS NOT NULL
        AND i.validation_status IN ('Validated','Unpaid','Available')
        AND NVL(NVL(d.distribution_amount_functi, d.distribution_amount),0) <> 0
        AND EXTRACT(YEAR FROM d.accounting_date) = l_year
        AND (l_end IS NULL OR d.accounting_date < l_end + 1)
        AND (COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(d.project_id)),
             NVL(COALESCE(tk.task_number, CASE WHEN d.task_id IS NOT NULL THEN '#'||TO_CHAR(d.task_id) END),'~'),
             NVL(d.expenditure_type,'~')) IN (SELECT pk,tk,et FROM kys)
      ORDER BY amt_aed DESC NULLS LAST FETCH FIRST 10000 ROWS ONLY
    ) LOOP
      l_count := r.full_n; l_total := r.full_tot;
      APEX_JSON.open_object;
      IF l_agg THEN APEX_JSON.write('project', NVL(r.pkey,'')); APEX_JSON.write('task', NVL(r.tkey,'')); END IF;
      APEX_JSON.write('invoice', NVL(r.invoice_number,'')); APEX_JSON.write('invoiceId', r.invoice_id);
      APEX_JSON.write('line', NVL(TO_CHAR(r.line_no),''));
      APEX_JSON.write('date', NVL(r.idate,''));
      APEX_JSON.write('vendor', NVL(r.supplier_name,'')); APEX_JSON.write('currency', NVL(r.cur,''));
      APEX_JSON.write('invAmount', r.inv_amt); APEX_JSON.write('amount', r.amt_aed);
      APEX_JSON.write('validation', NVL(r.validation_status,'')); APEX_JSON.write('payment', NVL(r.pay_status,''));
      APEX_JSON.write('description', NVL(r.descr,''));
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;

  ELSIF l_metric = 'grn' THEN
    APEX_JSON.open_array('columns');
    IF l_agg THEN col('project','Project','text'); col('task','Task','text'); END IF;
    col('receipt','GRN #','text'); col('line','Line','text'); col('date','Date','date');
    col('po','PO #','text'); col('poLine','PO Line','text'); col('supplier','Supplier','text'); col('currency','Cur','text');
    col('rate','Rate','num'); col('amount','Amount (AED)','money');
    APEX_JSON.close_array;
    APEX_JSON.open_array('rows');
    FOR r IN (
      WITH kys AS (
             SELECT CAST(l_project AS VARCHAR2(120)) pk, NVL(l_task,'~') tk, NVL(l_etype,'~') et FROM dual WHERE l_project IS NOT NULL
             UNION ALL
             SELECT v.project_number, NVL(v.task_number,'~'), NVL(v.expenditure_type,'~') FROM prod.dct_budget_utilization_v v
             WHERE l_project IS NULL AND v.budget_year = l_year
               AND (l_ptype  IS NULL OR v.project_type = l_ptype)
               AND (l_sector IS NULL OR v.sector = l_sector)
     AND (l_secok = 1 OR v.sector IN (SELECT cv.name_en FROM prod.dct_gl_class_value cv JOIN prod.v_dct_sec_user_scope sc ON sc.object_key = cv.value_code AND sc.object_type_code = 'SECTOR' AND sc.user_id = l_uid WHERE cv.class_type_code = 'SECTOR'))
               AND (l_chapter IS NULL OR INSTR('|'||l_chapter||'|', '|'||v.chapter||'|') > 0)
               AND (l_bu IS NULL OR INSTR('|'||l_bu||'|', '|'||v.business_unit||'|') > 0)
               AND (l_approp  IS NULL OR INSTR('|'||l_approp||'|', '|'||v.appropriation||'|') > 0)
               AND (l_program IS NULL OR INSTR('|'||l_program||'|', '|'||v.program||'|') > 0)
               AND (l_cc     IS NULL OR (INSTR(l_cc,'|') = 0 AND v.cost_centre LIKE '%'||l_cc||'%')
                                     OR INSTR('|'||l_cc||'|', '|'||v.cost_centre||'|') > 0)
               AND (l_fproj  IS NULL OR (INSTR(l_fproj,'|') = 0 AND UPPER(v.project_number||' '||v.project_name) LIKE '%'||UPPER(l_fproj)||'%')
                                     OR INSTR('|'||l_fproj||'|', '|'||v.project_number||'|') > 0)
               AND (l_ftask  IS NULL OR UPPER(v.task_number) LIKE '%'||UPPER(l_ftask)||'%')
               AND (l_fetype IS NULL OR UPPER(v.expenditure_type) LIKE '%'||UPPER(l_fetype)||'%')
               AND (l_search IS NULL OR UPPER(v.project_number||' '||v.project_name||' '||v.task_number||' '||v.department||' '||v.cost_centre||' '||v.expenditure_type) LIKE '%'||UPPER(l_search)||'%')),
           proj AS (SELECT project_id, MAX(project_number) project_number FROM prod.projects GROUP BY project_id),
           tsk  AS (SELECT task_id, MAX(task_number) task_number FROM prod.tasks GROUP BY task_id),
           po_dist AS (SELECT po_distribution_id, MAX(charge_account) charge_account FROM prod.po_distributions GROUP BY po_distribution_id),
           poh AS (SELECT po_header_id, MAX(order_number) order_number, MAX(supplier_name) supplier_name FROM prod.po_headers GROUP BY po_header_id),
           pol AS (SELECT po_header_id, po_line_id, MAX(line) line FROM prod.po_lines GROUP BY po_header_id, po_line_id)
      SELECT * FROM (
      SELECT COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(g.project_id)) pkey,
             COALESCE(tk.task_number, CASE WHEN g.task_id IS NOT NULL THEN '#'||TO_CHAR(g.task_id) END) tkey,
             g.receipt_number, g.receipt_line_number line_no,
             TO_CHAR(NVL(g.accounted_date, g.transaction_date),'YYYY-MM-DD') td, g.currency_code,
             ph.order_number po_number, pl.line po_line, ph.supplier_name, g.po_header_id,
             g.conversion_rate, g.ledger_amount amt_aed,
             COUNT(*) OVER () full_n, SUM(g.ledger_amount) OVER () full_tot
      FROM prod.grn_all_v2 g
      JOIN po_dist pod ON pod.po_distribution_id = g.po_distribution_id
      LEFT JOIN poh ph ON ph.po_header_id = g.po_header_id
      LEFT JOIN pol pl ON pl.po_header_id = g.po_header_id AND pl.po_line_id = g.po_line_id
      LEFT JOIN proj pj ON pj.project_id = g.project_id
      LEFT JOIN tsk  tk ON tk.task_id    = g.task_id
      WHERE g.project_id IS NOT NULL AND pod.charge_account IS NOT NULL
        AND NVL(g.ledger_amount,0) <> 0
        AND EXTRACT(YEAR FROM NVL(g.accounted_date, g.transaction_date)) = l_year
        AND (l_end IS NULL OR NVL(g.accounted_date, g.transaction_date) < l_end + 1)
        AND (COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(g.project_id)),
             NVL(COALESCE(tk.task_number, CASE WHEN g.task_id IS NOT NULL THEN '#'||TO_CHAR(g.task_id) END),'~'),
             NVL(g.expenditure_type,'~')) IN (SELECT pk,tk,et FROM kys)
      ORDER BY amt_aed DESC NULLS LAST FETCH FIRST 10000 ROWS ONLY
      ) ORDER BY receipt_number, line_no
    ) LOOP
      l_count := r.full_n; l_total := r.full_tot;
      APEX_JSON.open_object;
      IF l_agg THEN APEX_JSON.write('project', NVL(r.pkey,'')); APEX_JSON.write('task', NVL(r.tkey,'')); END IF;
      APEX_JSON.write('receipt', NVL(TO_CHAR(r.receipt_number),'')); APEX_JSON.write('line', NVL(TO_CHAR(r.line_no),''));
      APEX_JSON.write('date', NVL(r.td,''));
      APEX_JSON.write('po', NVL(TO_CHAR(r.po_number),'')); APEX_JSON.write('poHeaderId', r.po_header_id);
      APEX_JSON.write('poLine', NVL(TO_CHAR(r.po_line),''));
      APEX_JSON.write('supplier', NVL(r.supplier_name,''));
      APEX_JSON.write('currency', NVL(r.currency_code,'AED')); APEX_JSON.write('rate', NVL(r.conversion_rate,1));
      APEX_JSON.write('amount', r.amt_aed);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;

  ELSIF l_metric = 'pr' THEN
    APEX_JSON.open_array('columns');
    IF l_agg THEN col('project','Project','text'); col('task','Task','text'); END IF;
    col('pr','PR #','text'); col('line','Line','text'); col('description','Description','text'); col('date','Budget date','date');
    col('currency','Cur','text'); col('amount','Line amount (AED)','money');
    APEX_JSON.close_array;
    APEX_JSON.open_array('rows');
    FOR r IN (
      WITH kys AS (
             SELECT CAST(l_project AS VARCHAR2(120)) pk, NVL(l_task,'~') tk, NVL(l_etype,'~') et FROM dual WHERE l_project IS NOT NULL
             UNION ALL
             SELECT v.project_number, NVL(v.task_number,'~'), NVL(v.expenditure_type,'~') FROM prod.dct_budget_utilization_v v
             WHERE l_project IS NULL AND v.budget_year = l_year
               AND (l_ptype  IS NULL OR v.project_type = l_ptype)
               AND (l_sector IS NULL OR v.sector = l_sector)
     AND (l_secok = 1 OR v.sector IN (SELECT cv.name_en FROM prod.dct_gl_class_value cv JOIN prod.v_dct_sec_user_scope sc ON sc.object_key = cv.value_code AND sc.object_type_code = 'SECTOR' AND sc.user_id = l_uid WHERE cv.class_type_code = 'SECTOR'))
               AND (l_chapter IS NULL OR INSTR('|'||l_chapter||'|', '|'||v.chapter||'|') > 0)
               AND (l_bu IS NULL OR INSTR('|'||l_bu||'|', '|'||v.business_unit||'|') > 0)
               AND (l_approp  IS NULL OR INSTR('|'||l_approp||'|', '|'||v.appropriation||'|') > 0)
               AND (l_program IS NULL OR INSTR('|'||l_program||'|', '|'||v.program||'|') > 0)
               AND (l_cc     IS NULL OR (INSTR(l_cc,'|') = 0 AND v.cost_centre LIKE '%'||l_cc||'%')
                                     OR INSTR('|'||l_cc||'|', '|'||v.cost_centre||'|') > 0)
               AND (l_fproj  IS NULL OR (INSTR(l_fproj,'|') = 0 AND UPPER(v.project_number||' '||v.project_name) LIKE '%'||UPPER(l_fproj)||'%')
                                     OR INSTR('|'||l_fproj||'|', '|'||v.project_number||'|') > 0)
               AND (l_ftask  IS NULL OR UPPER(v.task_number) LIKE '%'||UPPER(l_ftask)||'%')
               AND (l_fetype IS NULL OR UPPER(v.expenditure_type) LIKE '%'||UPPER(l_fetype)||'%')
               AND (l_search IS NULL OR UPPER(v.project_number||' '||v.project_name||' '||v.task_number||' '||v.department||' '||v.cost_centre||' '||v.expenditure_type) LIKE '%'||UPPER(l_search)||'%')),
           proj AS (SELECT project_id, MAX(project_number) project_number FROM prod.projects GROUP BY project_id),
           tsk  AS (SELECT task_id, MAX(task_number) task_number FROM prod.tasks GROUP BY task_id),
           prl  AS (SELECT pr_line_id, MAX(pr_line) pr_line FROM prod.pr_lines GROUP BY pr_line_id)
      SELECT COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(d.project_id)) pkey,
             COALESCE(tk.task_number, CASE WHEN d.task_id IS NOT NULL THEN '#'||TO_CHAR(d.task_id) END) tkey,
             d.requisition pr_number, d.pr_header_id, pl.pr_line line_no, h.description, TO_CHAR(d.budget_date,'YYYY-MM-DD') bd,
             d.currency_code, d.distribution_amount * NVL(cc.exchange_rate_to_aed,1) amt_aed,
             COUNT(*) OVER () full_n, SUM(d.distribution_amount * NVL(cc.exchange_rate_to_aed,1)) OVER () full_tot
      FROM prod.pr_distributions d
      LEFT JOIN (SELECT pr_header_id, MAX(description) description FROM prod.pr_headers GROUP BY pr_header_id) h
             ON h.pr_header_id = d.pr_header_id
      LEFT JOIN prod.dct_currency_codes cc ON cc.currency_code = d.currency_code
      LEFT JOIN prl pl ON pl.pr_line_id = d.pr_line_id
      LEFT JOIN proj pj ON pj.project_id = d.project_id
      LEFT JOIN tsk  tk ON tk.task_id    = d.task_id
      WHERE d.funds_status = 'Reserved' AND d.project_id IS NOT NULL AND d.charge_account IS NOT NULL
        AND NVL(d.distribution_amount * NVL(cc.exchange_rate_to_aed,1),0) <> 0
        AND EXTRACT(YEAR FROM d.budget_date) = l_year
        AND (l_end IS NULL OR d.budget_date < l_end + 1)
        AND (COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(d.project_id)),
             NVL(COALESCE(tk.task_number, CASE WHEN d.task_id IS NOT NULL THEN '#'||TO_CHAR(d.task_id) END),'~'),
             NVL(d.expenditure_type,'~')) IN (SELECT pk,tk,et FROM kys)
      ORDER BY amt_aed DESC NULLS LAST FETCH FIRST 10000 ROWS ONLY
    ) LOOP
      l_count := r.full_n; l_total := r.full_tot;
      APEX_JSON.open_object;
      IF l_agg THEN APEX_JSON.write('project', NVL(r.pkey,'')); APEX_JSON.write('task', NVL(r.tkey,'')); END IF;
      APEX_JSON.write('pr', NVL(TO_CHAR(r.pr_number),'')); APEX_JSON.write('prHeaderId', r.pr_header_id);
      APEX_JSON.write('line', NVL(TO_CHAR(r.line_no),''));
      APEX_JSON.write('description', NVL(r.description,''));
      APEX_JSON.write('date', NVL(r.bd,'')); APEX_JSON.write('currency', NVL(r.currency_code,'AED'));
      APEX_JSON.write('amount', r.amt_aed);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;

  ELSIF l_metric = 'po' THEN
    APEX_JSON.open_array('columns');
    IF l_agg THEN col('project','Project','text'); col('task','Task','text'); END IF;
    col('po','PO #','text'); col('line','Line','text'); col('date','Budget date','date'); col('vendor','Vendor','text');
    col('status','Funds status','text'); col('poAmount','PO amount','money'); col('lineAmount','Line amount (AED)','money');
    col('amount','Open (AED)','money');
    APEX_JSON.close_array;
    APEX_JSON.open_array('rows');
    FOR r IN (
      WITH kys AS (
             SELECT CAST(l_project AS VARCHAR2(120)) pk, NVL(l_task,'~') tk, NVL(l_etype,'~') et FROM dual WHERE l_project IS NOT NULL
             UNION ALL
             SELECT v.project_number, NVL(v.task_number,'~'), NVL(v.expenditure_type,'~') FROM prod.dct_budget_utilization_v v
             WHERE l_project IS NULL AND v.budget_year = l_year
               AND (l_ptype  IS NULL OR v.project_type = l_ptype)
               AND (l_sector IS NULL OR v.sector = l_sector)
     AND (l_secok = 1 OR v.sector IN (SELECT cv.name_en FROM prod.dct_gl_class_value cv JOIN prod.v_dct_sec_user_scope sc ON sc.object_key = cv.value_code AND sc.object_type_code = 'SECTOR' AND sc.user_id = l_uid WHERE cv.class_type_code = 'SECTOR'))
               AND (l_chapter IS NULL OR INSTR('|'||l_chapter||'|', '|'||v.chapter||'|') > 0)
               AND (l_bu IS NULL OR INSTR('|'||l_bu||'|', '|'||v.business_unit||'|') > 0)
               AND (l_approp  IS NULL OR INSTR('|'||l_approp||'|', '|'||v.appropriation||'|') > 0)
               AND (l_program IS NULL OR INSTR('|'||l_program||'|', '|'||v.program||'|') > 0)
               AND (l_cc     IS NULL OR (INSTR(l_cc,'|') = 0 AND v.cost_centre LIKE '%'||l_cc||'%')
                                     OR INSTR('|'||l_cc||'|', '|'||v.cost_centre||'|') > 0)
               AND (l_fproj  IS NULL OR (INSTR(l_fproj,'|') = 0 AND UPPER(v.project_number||' '||v.project_name) LIKE '%'||UPPER(l_fproj)||'%')
                                     OR INSTR('|'||l_fproj||'|', '|'||v.project_number||'|') > 0)
               AND (l_ftask  IS NULL OR UPPER(v.task_number) LIKE '%'||UPPER(l_ftask)||'%')
               AND (l_fetype IS NULL OR UPPER(v.expenditure_type) LIKE '%'||UPPER(l_fetype)||'%')
               AND (l_search IS NULL OR UPPER(v.project_number||' '||v.project_name||' '||v.task_number||' '||v.department||' '||v.cost_centre||' '||v.expenditure_type) LIKE '%'||UPPER(l_search)||'%')),
           proj AS (SELECT project_id, MAX(project_number) project_number FROM prod.projects GROUP BY project_id),
           tsk  AS (SELECT task_id, MAX(task_number) task_number FROM prod.tasks GROUP BY task_id),
           po_dist AS (SELECT po_distribution_id, MAX(charge_account) charge_account, MAX(project_id) project_id, MAX(task_id) task_id,
                              MAX(expenditure_type_name) expenditure_type, MAX(budget_date) budget_date, MAX(po_header_id) po_header_id,
                              MAX(po_line_id) po_line_id, MAX(distribution_amount * NVL(rate,1)) amt_aed, MAX(funds_status) funds_status
                       FROM prod.po_distributions GROUP BY po_distribution_id),
           grn_per_dist AS (SELECT po_distribution_id, SUM(ledger_amount) grn_aed FROM prod.grn_all_v2
                            WHERE (l_end IS NULL OR NVL(accounted_date, transaction_date) < l_end + 1)
                            GROUP BY po_distribution_id)
      SELECT COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(b.project_id)) pkey,
             COALESCE(tk.task_number, CASE WHEN b.task_id IS NOT NULL THEN '#'||TO_CHAR(b.task_id) END) tkey,
             h.order_number, b.po_header_id, pl.line po_line, TO_CHAR(b.budget_date,'YYYY-MM-DD') bd, h.supplier_name, b.funds_status,
             TO_NUMBER(REGEXP_REPLACE(h.ordered_amount,'[^0-9.-]','') DEFAULT NULL ON CONVERSION ERROR) po_amt,
             b.amt_aed line_aed, GREATEST(b.amt_aed - NVL(g.grn_aed,0),0) open_aed,
             COUNT(*) OVER () full_n, SUM(GREATEST(b.amt_aed - NVL(g.grn_aed,0),0)) OVER () full_tot
      FROM po_dist b
      LEFT JOIN grn_per_dist g ON g.po_distribution_id = b.po_distribution_id
      LEFT JOIN (SELECT po_header_id, MAX(order_number) order_number, MAX(supplier_name) supplier_name,
                        MAX(ordered_amount) ordered_amount, MAX(status) po_status
                 FROM prod.po_headers GROUP BY po_header_id) h
             ON h.po_header_id = b.po_header_id
      LEFT JOIN (SELECT po_header_id, po_line_id, MAX(line) line FROM prod.po_lines GROUP BY po_header_id, po_line_id) pl
             ON pl.po_header_id = b.po_header_id AND pl.po_line_id = b.po_line_id
      LEFT JOIN proj pj ON pj.project_id = b.project_id
      LEFT JOIN tsk  tk ON tk.task_id    = b.task_id
      WHERE b.funds_status IN ('Reserved','Partially Liquidated') AND b.project_id IS NOT NULL AND b.charge_account IS NOT NULL
        AND NVL(h.po_status,'x') <> 'Finally Closed'
        AND NVL(GREATEST(b.amt_aed - NVL(g.grn_aed,0),0),0) > 0
        AND EXTRACT(YEAR FROM b.budget_date) = l_year
        AND (l_end IS NULL OR b.budget_date < l_end + 1)
        AND (COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(b.project_id)),
             NVL(COALESCE(tk.task_number, CASE WHEN b.task_id IS NOT NULL THEN '#'||TO_CHAR(b.task_id) END),'~'),
             NVL(b.expenditure_type,'~')) IN (SELECT pk,tk,et FROM kys)
      ORDER BY open_aed DESC NULLS LAST FETCH FIRST 10000 ROWS ONLY
    ) LOOP
      l_count := r.full_n; l_total := r.full_tot;
      APEX_JSON.open_object;
      IF l_agg THEN APEX_JSON.write('project', NVL(r.pkey,'')); APEX_JSON.write('task', NVL(r.tkey,'')); END IF;
      APEX_JSON.write('po', NVL(TO_CHAR(r.order_number),'')); APEX_JSON.write('poHeaderId', r.po_header_id);
      APEX_JSON.write('line', NVL(TO_CHAR(r.po_line),''));
      APEX_JSON.write('date', NVL(r.bd,'')); APEX_JSON.write('vendor', NVL(r.supplier_name,''));
      APEX_JSON.write('status', NVL(r.funds_status,'')); APEX_JSON.write('poAmount', r.po_amt);
      APEX_JSON.write('lineAmount', r.line_aed); APEX_JSON.write('amount', r.open_aed);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;

  ELSIF l_metric IN ('budget','budgetannual') THEN
    -- budget drill (2026-07-21): the line's ACCOUNTING_PERIOD (MM-YYYY) rows
    -- from prod.projects_budget. metric=budget -> YTD (periods on/before the
    -- period end; a NULL/unparseable period counts as annual = always
    -- included, mirroring the view's pb CTE); budgetannual -> ALL periods.
    APEX_JSON.open_array('columns');
    IF l_agg THEN col('project','Project','text'); col('task','Task','text'); col('etype','Expenditure type','text'); END IF;
    col('period','Accounting period','text'); col('amount','Budget (AED)','money');
    col('updatedBy','Updated by','text'); col('updated','Updated on','date');
    APEX_JSON.close_array;
    APEX_JSON.open_array('rows');
    FOR r IN (
      WITH kys AS (
             SELECT CAST(l_project AS VARCHAR2(120)) pk, NVL(l_task,'~') tk, NVL(l_etype,'~') et FROM dual WHERE l_project IS NOT NULL
             UNION ALL
             SELECT v.project_number, NVL(v.task_number,'~'), NVL(v.expenditure_type,'~') FROM prod.dct_budget_utilization_v v
             WHERE l_project IS NULL AND v.budget_year = l_year
               AND (l_ptype  IS NULL OR v.project_type = l_ptype)
               AND (l_sector IS NULL OR v.sector = l_sector)
     AND (l_secok = 1 OR v.sector IN (SELECT cv.name_en FROM prod.dct_gl_class_value cv JOIN prod.v_dct_sec_user_scope sc ON sc.object_key = cv.value_code AND sc.object_type_code = 'SECTOR' AND sc.user_id = l_uid WHERE cv.class_type_code = 'SECTOR'))
               AND (l_chapter IS NULL OR INSTR('|'||l_chapter||'|', '|'||v.chapter||'|') > 0)
               AND (l_bu IS NULL OR INSTR('|'||l_bu||'|', '|'||v.business_unit||'|') > 0)
               AND (l_approp  IS NULL OR INSTR('|'||l_approp||'|', '|'||v.appropriation||'|') > 0)
               AND (l_program IS NULL OR INSTR('|'||l_program||'|', '|'||v.program||'|') > 0)
               AND (l_cc     IS NULL OR (INSTR(l_cc,'|') = 0 AND v.cost_centre LIKE '%'||l_cc||'%')
                                     OR INSTR('|'||l_cc||'|', '|'||v.cost_centre||'|') > 0)
               AND (l_fproj  IS NULL OR (INSTR(l_fproj,'|') = 0 AND UPPER(v.project_number||' '||v.project_name) LIKE '%'||UPPER(l_fproj)||'%')
                                     OR INSTR('|'||l_fproj||'|', '|'||v.project_number||'|') > 0)
               AND (l_ftask  IS NULL OR UPPER(v.task_number) LIKE '%'||UPPER(l_ftask)||'%')
               AND (l_fetype IS NULL OR UPPER(v.expenditure_type) LIKE '%'||UPPER(l_fetype)||'%')
               AND (l_search IS NULL OR UPPER(v.project_number||' '||v.project_name||' '||v.task_number||' '||v.department||' '||v.cost_centre||' '||v.expenditure_type) LIKE '%'||UPPER(l_search)||'%')),
           proj AS (SELECT project_id, MAX(project_number) project_number FROM prod.projects GROUP BY project_id),
           tsk  AS (SELECT task_id, MAX(task_number) task_number FROM prod.tasks GROUP BY task_id)
      SELECT COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(b.project_id)) pkey,
             COALESCE(tk.task_number, CASE WHEN b.task_id IS NOT NULL THEN '#'||TO_CHAR(b.task_id) END) tkey,
             b.expenditure_type et, b.accounting_period, b.budget amt,
             b.updated_by, TO_CHAR(b.update_date,'YYYY-MM-DD') upd,
             COUNT(*) OVER () full_n, SUM(b.budget) OVER () full_tot
      FROM prod.projects_budget b
      LEFT JOIN proj pj ON pj.project_id = b.project_id
      LEFT JOIN tsk  tk ON tk.task_id    = b.task_id
      WHERE b.budget_year = l_year
        AND NVL(b.budget,0) <> 0
        AND (l_metric = 'budgetannual' OR l_end IS NULL
             OR NVL(TO_DATE(b.accounting_period DEFAULT NULL ON CONVERSION ERROR,'MM-YYYY'),
                    DATE '1900-01-01') < l_end + 1)
        AND (COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(b.project_id)),
             NVL(COALESCE(tk.task_number, CASE WHEN b.task_id IS NOT NULL THEN '#'||TO_CHAR(b.task_id) END),'~'),
             NVL(b.expenditure_type,'~')) IN (SELECT pk,tk,et FROM kys)
      ORDER BY NVL(TO_DATE(b.accounting_period DEFAULT NULL ON CONVERSION ERROR,'MM-YYYY'), DATE '1900-01-01'),
               pkey, tkey FETCH FIRST 10000 ROWS ONLY
    ) LOOP
      l_count := r.full_n; l_total := r.full_tot;
      APEX_JSON.open_object;
      IF l_agg THEN APEX_JSON.write('project', NVL(r.pkey,'')); APEX_JSON.write('task', NVL(r.tkey,'')); APEX_JSON.write('etype', NVL(r.et,'')); END IF;
      APEX_JSON.write('period', NVL(r.accounting_period,'(annual)'));
      APEX_JSON.write('amount', r.amt);
      APEX_JSON.write('updatedBy', NVL(r.updated_by,''));
      APEX_JSON.write('updated', NVL(r.upd,''));
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;

  ELSE
    dct_rest.err(400,'Unknown metric'); RETURN;
  END IF;

  APEX_JSON.write('total', l_total);
  APEX_JSON.write('count', l_count);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END setup_gl_butil_ords_tmp;
/

SHOW ERRORS

EXECUTE setup_gl_butil_ords_tmp
DROP PROCEDURE setup_gl_butil_ords_tmp;

PROMPT gl.rest Budget Utilization endpoints published (/gl/butil + filters + lov + lines).
EXIT
