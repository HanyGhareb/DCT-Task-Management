-- =============================================================================
-- General Ledger (App 210) -- Budget Override drawer endpoints (ADDITIVE)
-- File    : 15_gl_butil_override_ords.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp @15_gl_butil_override_ords.sql  (fresh session)
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            re-run 07 + 08 + 09 + 10 + 11 + 12 + 13 + 14 + THIS script.
-- Purpose : feeds the Budget Utilization page's "Override Budget" KPI drawer:
--           every project-budget period row carrying an end-user BUDGET_USER
--           override (PROD.DCT_PROJECT_BUDGET_USER, db/v2/106 - entered from
--           the Excel VB template), scoped to the page's butil filters, and
--           lets the user EDIT the override in place (same core save logic as
--           the Excel PUT - prod.dct_xl_pkg.save_item).
-- Endpoints:
--   GET  /gl/butil/override/lines?year(req)=&period=&projecttype=&sector=
--        &chapter=&bu=&appropriation=&program=&costcenter=&project=&task=
--        &etype=&search=
--        -> { total, totals{override,fusion}, items[{id, budgetYear,
--             projectNumber, projectName, taskNumber, taskName,
--             expenditureType, accountingPeriod, fusionBudget, overrideBudget,
--             updatedBy, updatedAt}] }   (id = the opaque xl row key)
--   POST /gl/butil/override   body {id, budget_user}  (null = clear override)
--        -> the updated row JSON (dct_xl_pkg item shape)
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_ovr_ords_tmp AS

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

    def_template('butil/override/lines');
    def_handler('butil/override/lines', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_uid    NUMBER := dct_auth.get_user_id(l_user);
  l_secok  NUMBER := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
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
  l_total  NUMBER := 0; l_ovr NUMBER := 0; l_fus NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  IF l_period = '' THEN l_period := NULL; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  APEX_JSON.open_array('items');
  FOR r IN (
    WITH kys AS (
      SELECT DISTINCT v.project_number pk, NVL(v.task_number,'~') tk, NVL(v.expenditure_type,'~') et
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
                                      ||v.department||' '||v.cost_centre||' '||v.expenditure_type) LIKE '%'||UPPER(l_search)||'%')
    ),
    proj AS (SELECT project_id, MAX(project_number) project_number, MAX(project_name) project_name
             FROM prod.projects GROUP BY project_id),
    tsk  AS (SELECT task_id, MAX(task_number) task_number, MAX(task_name) task_name
             FROM prod.tasks GROUP BY task_id)
    SELECT prod.dct_xl_pkg.encode_id(u.project_id, u.task_id, u.accounting_period, u.expenditure_type) rid,
           TO_CHAR(pj.project_number) pnum, pj.project_name pname,
           tk.task_number tnum, tk.task_name tname,
           u.expenditure_type et, u.accounting_period per,
           b.budget fus, u.budget_user ovr,
           u.updated_by uby,
           TO_CHAR(prod.dct_to_local(u.updated_at),'YYYY-MM-DD HH:MI AM') uat,
           COUNT(*) OVER () full_n, SUM(u.budget_user) OVER () full_ovr, SUM(b.budget) OVER () full_fus
    FROM prod.dct_project_budget_user u
    JOIN prod.projects_budget b
      ON  b.project_id = u.project_id AND b.task_id = u.task_id
      AND b.expenditure_type = u.expenditure_type AND b.accounting_period = u.accounting_period
    LEFT JOIN proj pj ON pj.project_id = u.project_id
    LEFT JOIN tsk  tk ON tk.task_id    = u.task_id
    WHERE b.budget_year = l_year
      AND (l_period IS NULL OR u.accounting_period = l_period)
      AND (TO_CHAR(pj.project_number), NVL(tk.task_number,'~'), NVL(u.expenditure_type,'~'))
          IN (SELECT pk, tk, et FROM kys)
    ORDER BY pj.project_number, tk.task_number, u.expenditure_type, u.accounting_period
    FETCH FIRST 5000 ROWS ONLY
  ) LOOP
    l_total := r.full_n; l_ovr := r.full_ovr; l_fus := r.full_fus;
    APEX_JSON.open_object;
    APEX_JSON.write('id',               r.rid);
    APEX_JSON.write('projectNumber',    NVL(r.pnum,''));
    APEX_JSON.write('projectName',      NVL(r.pname,''));
    APEX_JSON.write('taskNumber',       NVL(r.tnum,''));
    APEX_JSON.write('taskName',         NVL(r.tname,''));
    APEX_JSON.write('expenditureType',  NVL(r.et,''));
    APEX_JSON.write('accountingPeriod', NVL(r.per,''));
    APEX_JSON.write('fusionBudget',     r.fus);
    APEX_JSON.write('overrideBudget',   r.ovr);
    APEX_JSON.write('updatedBy',        NVL(r.uby,''));
    APEX_JSON.write('updatedAt',        NVL(r.uat,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('total', l_total);
  APEX_JSON.open_object('totals');
  APEX_JSON.write('override', NVL(l_ovr,0));
  APEX_JSON.write('fusion',   NVL(l_fus,0));
  APEX_JSON.close_object;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('butil/override');
    def_handler('butil/override', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER := dct_auth.get_user_id(l_user);
  l_blob BLOB := [COLON]body;
  l_id   VARCHAR2(600);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_EDIT_BUDGET_OVERRIDE', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_EDIT_BUDGET_OVERRIDE required'); RETURN;
  END IF;
  dct_rest.parse_body(l_blob);
  l_id := APEX_JSON.get_varchar2('id');
  IF l_id IS NULL THEN dct_rest.err(400,'id is required'); RETURN; END IF;
  prod.dct_xl_pkg.save_item(l_uid, l_id, l_blob);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END setup_gl_ovr_ords_tmp;
/

SHOW ERRORS

EXECUTE setup_gl_ovr_ords_tmp
DROP PROCEDURE setup_gl_ovr_ords_tmp;

PROMPT gl.rest Budget Override endpoints published (/gl/butil/override + /lines).
