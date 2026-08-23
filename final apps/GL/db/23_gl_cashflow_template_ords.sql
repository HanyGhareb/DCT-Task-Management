-- =============================================================================
-- General Ledger (App 210) -- Projects Cashflow upload TEMPLATE feed (ADDITIVE)
-- File    : 23_gl_cashflow_template_ords.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp (fresh session, ADMIN) or python-oracledb
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            re-run 07..22 + THIS script (post-05 list is now 07..23).
-- Purpose : the Cashflow page's "Download template" for PROJECTS cashflow used
--           to ship a single sample row, so an end user had to hand-build every
--           project / task / expenditure-type line. This feeds the template with
--           EVERY budget line of the chosen year (DCT_BUDGET_UTILIZATION_V) plus
--           its full 10-segment GL combination and classification attributes,
--           and pre-fills any cashflow amounts ALREADY saved for that year, so
--           the download is a round-trip editor: fill the month cells, upload.
-- Endpoint:
--   GET /gl/cashflow/projects/template?year=&meta=
--       meta=Y  -> years[] only (feeds the page's Budget Year picker, fast)
--       else    -> years[] + periods[] + one line per project/task/etype with
--                  a01..a12 (APPROVED) / r01..r12 (REVISED) saved amounts
-- Gate    : GL_MANAGE_CASHFLOW (legacy role SYS_ADMIN) -- same as the upload it
--           serves, so a user who cannot upload cannot pull the sheet either.
-- Notes   : lines are the budget view's grain (year x project x task x etype);
--           cashflow keys with NO budget line are still emitted (inBudget='N')
--           so an existing plan row can never disappear from the sheet. The
--           saved-amount pivot keys on SUBSTR(accounting_period,1,2) -- the
--           period is stored MM-YYYY and budget_year already scopes the year.
--           Every derived value is computed IN the cursor (a scalar subquery
--           passed to APEX_JSON.write = uncatchable ORDS 555).
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_cf_template_ords AS

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

    def_template('cashflow/projects/template');
    def_handler('cashflow/projects/template', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_year NUMBER;
  l_meta VARCHAR2(5) := UPPER(SUBSTR(NVL([COLON]meta,'N'),1,5));
  l_max  CONSTANT NUMBER := 20000;
  l_n    NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_MANAGE_CASHFLOW', 'SYS_ADMIN', 'GL') = FALSE THEN
    dct_rest.err(403,'GL_MANAGE_CASHFLOW required'); RETURN;
  END IF;
  l_year := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  IF l_year IS NOT NULL AND (l_year < 1990 OR l_year > 2100) THEN
    dct_rest.err(400,'year must be a 4-digit budget year'); RETURN;
  END IF;
  IF l_year IS NULL THEN
    SELECT NVL(MAX(CASE WHEN budget_year = EXTRACT(YEAR FROM SYSDATE)
                        THEN budget_year END), MAX(budget_year))
      INTO l_year FROM prod.dct_budget_utilization_v;
  END IF;

  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('years');
  FOR r IN (SELECT y FROM (
              SELECT DISTINCT budget_year y FROM prod.dct_budget_utilization_v
               WHERE budget_year IS NOT NULL
              UNION
              SELECT DISTINCT budget_year FROM prod.dct_project_cashflow
               WHERE budget_year IS NOT NULL)
             ORDER BY y DESC) LOOP
    APEX_JSON.write(r.y);
  END LOOP;
  APEX_JSON.close_array;

  IF l_meta IN ('Y','YES','1','TRUE') THEN
    APEX_JSON.write('year', l_year);
    APEX_JSON.close_object;
    RETURN;
  END IF;

  APEX_JSON.write('year', l_year);
  APEX_JSON.open_array('periods');
  FOR i IN 1 .. 12 LOOP
    APEX_JSON.write(LPAD(TO_CHAR(i),2,'0')||'-'||TO_CHAR(l_year));
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('lines');
  FOR r IN (
    WITH bl AS (
      SELECT project_number, task_number, expenditure_type,
             MAX(project_name)       project_name,
             MAX(budget_combination) budget_combination,
             MAX(sector)             sector,
             MAX(department)         department,
             MAX(cost_centre)        cost_centre,
             MAX(gl_account)         gl_account,
             MAX(appropriation)      appropriation,
             MAX(chapter)            chapter,
             MAX(program)            program,
             MAX(business_unit)      business_unit,
             MAX(project_type)       project_type,
             SUM(budget_annual)      budget_annual
        FROM prod.dct_budget_utilization_v
       WHERE budget_year = l_year
       GROUP BY project_number, task_number, expenditure_type),
    cf AS (
      SELECT project_number, task_number, expenditure_type,
             SUBSTR(accounting_period,1,2) mm, cf_type, SUM(cf_amount) amt
        FROM prod.dct_project_cashflow
       WHERE budget_year = l_year
       GROUP BY project_number, task_number, expenditure_type,
                SUBSTR(accounting_period,1,2), cf_type),
    cfp AS (
      SELECT project_number, task_number, expenditure_type,
             MAX(CASE WHEN cf_type='APPROVED' AND mm='01' THEN amt END) a01,
             MAX(CASE WHEN cf_type='APPROVED' AND mm='02' THEN amt END) a02,
             MAX(CASE WHEN cf_type='APPROVED' AND mm='03' THEN amt END) a03,
             MAX(CASE WHEN cf_type='APPROVED' AND mm='04' THEN amt END) a04,
             MAX(CASE WHEN cf_type='APPROVED' AND mm='05' THEN amt END) a05,
             MAX(CASE WHEN cf_type='APPROVED' AND mm='06' THEN amt END) a06,
             MAX(CASE WHEN cf_type='APPROVED' AND mm='07' THEN amt END) a07,
             MAX(CASE WHEN cf_type='APPROVED' AND mm='08' THEN amt END) a08,
             MAX(CASE WHEN cf_type='APPROVED' AND mm='09' THEN amt END) a09,
             MAX(CASE WHEN cf_type='APPROVED' AND mm='10' THEN amt END) a10,
             MAX(CASE WHEN cf_type='APPROVED' AND mm='11' THEN amt END) a11,
             MAX(CASE WHEN cf_type='APPROVED' AND mm='12' THEN amt END) a12,
             MAX(CASE WHEN cf_type='REVISED'  AND mm='01' THEN amt END) r01,
             MAX(CASE WHEN cf_type='REVISED'  AND mm='02' THEN amt END) r02,
             MAX(CASE WHEN cf_type='REVISED'  AND mm='03' THEN amt END) r03,
             MAX(CASE WHEN cf_type='REVISED'  AND mm='04' THEN amt END) r04,
             MAX(CASE WHEN cf_type='REVISED'  AND mm='05' THEN amt END) r05,
             MAX(CASE WHEN cf_type='REVISED'  AND mm='06' THEN amt END) r06,
             MAX(CASE WHEN cf_type='REVISED'  AND mm='07' THEN amt END) r07,
             MAX(CASE WHEN cf_type='REVISED'  AND mm='08' THEN amt END) r08,
             MAX(CASE WHEN cf_type='REVISED'  AND mm='09' THEN amt END) r09,
             MAX(CASE WHEN cf_type='REVISED'  AND mm='10' THEN amt END) r10,
             MAX(CASE WHEN cf_type='REVISED'  AND mm='11' THEN amt END) r11,
             MAX(CASE WHEN cf_type='REVISED'  AND mm='12' THEN amt END) r12
        FROM cf
       GROUP BY project_number, task_number, expenditure_type),
    keys AS (
      SELECT project_number, task_number, expenditure_type FROM bl
      UNION
      SELECT project_number, task_number, expenditure_type FROM cfp)
    SELECT k.project_number, k.task_number, k.expenditure_type,
           b.project_name, b.budget_combination, b.sector, b.department,
           b.cost_centre, b.gl_account, b.appropriation, b.chapter, b.program,
           b.business_unit, b.project_type, NVL(b.budget_annual,0) budget_annual,
           CASE WHEN b.project_number IS NULL THEN 'N' ELSE 'Y' END in_budget,
           p.a01,p.a02,p.a03,p.a04,p.a05,p.a06,p.a07,p.a08,p.a09,p.a10,p.a11,p.a12,
           p.r01,p.r02,p.r03,p.r04,p.r05,p.r06,p.r07,p.r08,p.r09,p.r10,p.r11,p.r12,
           CASE WHEN p.project_number IS NULL THEN 'N' ELSE 'Y' END has_plan
      FROM keys k
      LEFT JOIN bl  b ON b.project_number = k.project_number
                     AND b.task_number = k.task_number
                     AND b.expenditure_type = k.expenditure_type
      LEFT JOIN cfp p ON p.project_number = k.project_number
                     AND p.task_number = k.task_number
                     AND p.expenditure_type = k.expenditure_type
     ORDER BY k.project_number, k.task_number, k.expenditure_type
     FETCH FIRST 20000 ROWS ONLY) LOOP
    l_n := l_n + 1;
    APEX_JSON.open_object;
    APEX_JSON.write('project',        r.project_number);
    APEX_JSON.write('projectName',    NVL(r.project_name,' '));
    APEX_JSON.write('task',           r.task_number);
    APEX_JSON.write('etype',          r.expenditure_type);
    APEX_JSON.write('glCombination',  NVL(r.budget_combination,' '));
    APEX_JSON.write('sector',         NVL(r.sector,' '));
    APEX_JSON.write('department',     NVL(r.department,' '));
    APEX_JSON.write('costCenter',     NVL(r.cost_centre,' '));
    APEX_JSON.write('glAccount',      NVL(r.gl_account,' '));
    APEX_JSON.write('appropriation',  NVL(r.appropriation,' '));
    APEX_JSON.write('chapter',        NVL(r.chapter,' '));
    APEX_JSON.write('program',        NVL(r.program,' '));
    APEX_JSON.write('businessUnit',   NVL(r.business_unit,' '));
    APEX_JSON.write('projectType',    NVL(r.project_type,' '));
    APEX_JSON.write('budgetAnnual',   r.budget_annual);
    APEX_JSON.write('inBudget',       r.in_budget);
    APEX_JSON.write('hasPlan',        r.has_plan);
    APEX_JSON.write('a01', NVL(r.a01,0)); APEX_JSON.write('a02', NVL(r.a02,0));
    APEX_JSON.write('a03', NVL(r.a03,0)); APEX_JSON.write('a04', NVL(r.a04,0));
    APEX_JSON.write('a05', NVL(r.a05,0)); APEX_JSON.write('a06', NVL(r.a06,0));
    APEX_JSON.write('a07', NVL(r.a07,0)); APEX_JSON.write('a08', NVL(r.a08,0));
    APEX_JSON.write('a09', NVL(r.a09,0)); APEX_JSON.write('a10', NVL(r.a10,0));
    APEX_JSON.write('a11', NVL(r.a11,0)); APEX_JSON.write('a12', NVL(r.a12,0));
    APEX_JSON.write('r01', NVL(r.r01,0)); APEX_JSON.write('r02', NVL(r.r02,0));
    APEX_JSON.write('r03', NVL(r.r03,0)); APEX_JSON.write('r04', NVL(r.r04,0));
    APEX_JSON.write('r05', NVL(r.r05,0)); APEX_JSON.write('r06', NVL(r.r06,0));
    APEX_JSON.write('r07', NVL(r.r07,0)); APEX_JSON.write('r08', NVL(r.r08,0));
    APEX_JSON.write('r09', NVL(r.r09,0)); APEX_JSON.write('r10', NVL(r.r10,0));
    APEX_JSON.write('r11', NVL(r.r11,0)); APEX_JSON.write('r12', NVL(r.r12,0));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('count', l_n);
  APEX_JSON.write('truncated', CASE WHEN l_n >= l_max THEN 'Y' ELSE 'N' END);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END setup_gl_cf_template_ords;
/

SHOW ERRORS

EXECUTE setup_gl_cf_template_ords
DROP PROCEDURE setup_gl_cf_template_ords;

PROMPT gl.rest projects-cashflow template endpoint published (GET /gl/cashflow/projects/template).
