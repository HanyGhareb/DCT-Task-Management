-- =============================================================================
-- General Ledger (App 210) -- Budget Utilization ORDS endpoints (ADDITIVE)
-- File    : 07_gl_budget_util_ords.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp @07_gl_budget_util_ords.sql  (fresh session)
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            re-run THIS script right after it (same rule as ATD db/42).
-- Endpoints:
--   GET /gl/butil/filters  -> years (default = latest) + project types + sectors
--   GET /gl/butil?year=    -> {total, totals{...}, items[...]} -- year REQUIRED,
--       optional projecttype / sector / search / limit / offset.
-- Source  : prod.dct_budget_utilization_v (db/v2/37).
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
  l_year NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
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
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- BUDGET UTILIZATION -- one row per project x task x expenditure type.
    --   GET /gl/butil?year=&projecttype=&sector=&search=&limit=&offset=
    --   year is REQUIRED (400 otherwise). Returns {total, totals{...}, items[...]}.
    -- =========================================================================
    def_template('butil');
    def_handler('butil', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_year   NUMBER        := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_ptype  VARCHAR2(100) := [COLON]projecttype;
  l_sector VARCHAR2(200) := [COLON]sector;
  l_search VARCHAR2(200) := [COLON]search;
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit  DEFAULT NULL ON CONVERSION ERROR), 100), 5000);
  l_offset NUMBER := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_total  NUMBER;
  t_bud NUMBER; t_ap NUMBER; t_grn NUMBER; t_pr NUMBER; t_po NUMBER; t_fund NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  SELECT COUNT(*), NVL(SUM(budget),0), NVL(SUM(actual_ap),0), NVL(SUM(actual_grn),0),
         NVL(SUM(commitment_pr),0), NVL(SUM(obligation_po),0), NVL(SUM(fund_available),0)
    INTO l_total, t_bud, t_ap, t_grn, t_pr, t_po, t_fund
    FROM prod.dct_budget_utilization_v v
   WHERE v.budget_year = l_year
     AND (l_ptype  IS NULL OR v.project_type = l_ptype)
     AND (l_sector IS NULL OR v.sector = l_sector)
     AND (l_search IS NULL OR UPPER(v.project_number||' '||v.project_name||' '||v.task_number||' '
                                   ||v.department||' '||v.cost_centre||' '||v.expenditure_type) LIKE '%'||UPPER(l_search)||'%');
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('total', l_total); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.write('year', l_year);
  APEX_JSON.open_object('totals');
  APEX_JSON.write('budget', t_bud); APEX_JSON.write('actualAp', t_ap); APEX_JSON.write('actualGrn', t_grn);
  APEX_JSON.write('commitmentPr', t_pr); APEX_JSON.write('obligationPo', t_po); APEX_JSON.write('fundAvailable', t_fund);
  APEX_JSON.close_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT v.* FROM prod.dct_budget_utilization_v v
    WHERE v.budget_year = l_year
      AND (l_ptype  IS NULL OR v.project_type = l_ptype)
      AND (l_sector IS NULL OR v.sector = l_sector)
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
    APEX_JSON.write('actualAp', r.actual_ap);
    APEX_JSON.write('actualGrn', r.actual_grn);
    APEX_JSON.write('commitmentPr', r.commitment_pr);
    APEX_JSON.write('obligationPo', r.obligation_po);
    APEX_JSON.write('fundAvailable', r.fund_available);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END setup_gl_butil_ords_tmp;
/

SHOW ERRORS

EXECUTE setup_gl_butil_ords_tmp
DROP PROCEDURE setup_gl_butil_ords_tmp;

PROMPT gl.rest Budget Utilization endpoints published (/gl/butil + /gl/butil/filters).
EXIT
