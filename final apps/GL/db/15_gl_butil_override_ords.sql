-- =============================================================================
-- General Ledger (App 210) -- Budget Change drawer endpoints (ADDITIVE)
-- File    : 15_gl_butil_override_ords.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp @15_gl_butil_override_ords.sql  (fresh session)
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            re-run 07 .. 20 including THIS script.
-- Purpose : feeds the Budget Utilization page's "Budget Change" KPI drawer:
--           every SIGNED budget change (PROD.DCT_PROJECT_BUDGET_USER, db/v2/106
--           - entered from the Excel VB workbook or here), scoped to the page's
--           butil filters, with the line's annual + YTD Fusion budget and the
--           adjusted figures, and in-place editing (same core save logic as the
--           Excel PUT - prod.dct_xl_pkg.save_item).
--
-- v2 (2026-08-17): the stored figure is a CHANGE that is ADDED to the budget
--           (negative subtracts), not a replacement. Two consequences here:
--             * the join to prod.projects_budget is a LEFT JOIN on the LINE
--               (not an inner join on the exact period row): the Fusion budget
--               is un-phased, so a change booked at 08-2026 usually has no
--               budget row of its own and an inner join would hide it;
--             * the budget year of a change comes from its own MM-YYYY period.
--
-- Endpoints:
--   GET  /gl/butil/override/lines?year(req)=&period=&projecttype=&sector=
--        &chapter=&bu=&appropriation=&program=&costcenter=&project=&task=
--        &etype=&search=
--        -> { total, totals{change,fusionAnnual,fusionYtd}, reasons[],
--             items[{id, projectNumber, projectName, taskNumber, taskName,
--             expenditureType, accountingPeriod, fusionAnnual, fusionYtd,
--             changeAmount, lineChangeTotal, adjustedAnnual, adjustedYtd,
--             reasonCategory, comments, updatedBy, updatedAt}] }
--        (id = the opaque xl row key, so Excel and the drawer share identity)
--   POST /gl/butil/override   body {id, budget_change}  (null or 0 = clear)
--        -> the updated line JSON (dct_xl_pkg item shape)
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
  l_ptype  VARCHAR2(1000) := [COLON]projecttype;
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
  l_total  NUMBER := 0; l_chg NUMBER := 0; l_fann NUMBER := 0; l_fytd NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  IF l_period = '' THEN l_period := NULL; END IF;
  l_end := CASE WHEN l_period IS NULL THEN DATE '9999-12-31'
                ELSE LAST_DAY(TO_DATE('01-'||l_period,'DD-MM-YYYY')) END;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  APEX_JSON.open_array('reasons');
  FOR r IN (SELECT lv.value_code, lv.value_name_en, lv.value_name_ar
            FROM prod.dct_lookup_values lv
            JOIN prod.dct_lookup_categories lc ON lc.category_id = lv.category_id
            WHERE lc.category_code = 'XL_OVERRIDE_REASON' AND lv.is_active = 'Y'
            ORDER BY lv.display_order) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code',   r.value_code);
    APEX_JSON.write('name',   r.value_name_en);
    APEX_JSON.write('nameAr', r.value_name_ar, p_write_null => TRUE);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('items');
  FOR r IN (
    WITH kys AS (
      SELECT DISTINCT v.project_number pk, NVL(v.task_number,'~') tk, NVL(v.expenditure_type,'~') et
      FROM prod.dct_budget_utilization_v v
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
        AND (l_task   IS NULL OR UPPER(v.task_number) LIKE '%'||UPPER(l_task)||'%')
        AND (l_etype  IS NULL OR UPPER(v.expenditure_type) LIKE '%'||UPPER(l_etype)||'%')
        AND (l_search IS NULL OR UPPER(v.project_number||' '||v.project_name||' '||v.task_number||' '
                                      ||v.department||' '||v.cost_centre||' '||v.expenditure_type) LIKE '%'||UPPER(l_search)||'%')
    ),
    proj AS (SELECT project_id, MAX(project_number) project_number, MAX(project_name) project_name
             FROM prod.projects GROUP BY project_id),
    tsk  AS (SELECT task_id, MAX(task_number) task_number, MAX(task_name) task_name
             FROM prod.tasks GROUP BY task_id),
    -- the LINE's Fusion budget: annual (all periods) and YTD (periods on or
    -- before the page period). Joined per LINE, never per period row.
    bl AS (SELECT b.project_id, b.task_id, b.expenditure_type,
                  SUM(b.budget) annual,
                  SUM(CASE WHEN NVL(TO_DATE(b.accounting_period DEFAULT NULL ON CONVERSION ERROR,'MM-YYYY'),
                                    DATE '1900-01-01') <= l_end THEN b.budget END) ytd
           FROM prod.projects_budget b
           WHERE b.budget_year = l_year
           GROUP BY b.project_id, b.task_id, b.expenditure_type),
    lch AS (SELECT u.project_id, u.task_id, u.expenditure_type,
                   SUM(u.budget_change) line_total,
                   SUM(CASE WHEN NVL(TO_DATE(u.accounting_period DEFAULT NULL ON CONVERSION ERROR,'MM-YYYY'),
                                     DATE '1900-01-01') <= l_end THEN u.budget_change END) ytd_total
            FROM prod.dct_project_budget_user u
            WHERE TO_NUMBER(SUBSTR(u.accounting_period,4,4) DEFAULT NULL ON CONVERSION ERROR) = l_year
            GROUP BY u.project_id, u.task_id, u.expenditure_type)
    SELECT x.*,
           COUNT(*) OVER ()                                        full_n,
           SUM(x.chg) OVER ()                                      full_chg,
           SUM(CASE WHEN x.rn_line = 1 THEN x.f_ann END) OVER ()   full_fann,
           SUM(CASE WHEN x.rn_line = 1 THEN x.f_ytd END) OVER ()   full_fytd
    FROM (
      SELECT prod.dct_xl_pkg.encode_id(u.project_id, u.task_id, u.accounting_period, u.expenditure_type) rid,
             TO_CHAR(pj.project_number) pnum, pj.project_name pname,
             tk.task_number tnum, tk.task_name tname,
             u.expenditure_type et, u.accounting_period per,
             NVL(bl.annual,0) f_ann, NVL(bl.ytd,0) f_ytd,
             u.budget_change chg,
             NVL(lch.line_total,0) line_chg,
             NVL(bl.annual,0) + NVL(lch.line_total,0) adj_ann,
             NVL(bl.ytd,0)    + NVL(lch.ytd_total,0) adj_ytd,
             u.reason_category rsn, u.comments cmts,
             u.updated_by uby,
             TO_CHAR(prod.dct_to_local(u.updated_at),'YYYY-MM-DD HH[COLON]MI AM') uat,
             ROW_NUMBER() OVER (PARTITION BY u.project_id, u.task_id, u.expenditure_type
                                ORDER BY u.accounting_period) rn_line
      FROM prod.dct_project_budget_user u
      LEFT JOIN bl ON  bl.project_id = u.project_id AND bl.task_id = u.task_id
                   AND bl.expenditure_type = u.expenditure_type
      LEFT JOIN lch ON lch.project_id = u.project_id AND lch.task_id = u.task_id
                   AND lch.expenditure_type = u.expenditure_type
      LEFT JOIN proj pj ON pj.project_id = u.project_id
      LEFT JOIN tsk  tk ON tk.task_id    = u.task_id
      WHERE TO_NUMBER(SUBSTR(u.accounting_period,4,4) DEFAULT NULL ON CONVERSION ERROR) = l_year
        -- YTD semantics matching the page: the page period is a through-period
        -- filter, so show every change on or before it
        AND NVL(TO_DATE(u.accounting_period DEFAULT NULL ON CONVERSION ERROR,'MM-YYYY'),
                DATE '1900-01-01') <= l_end
        AND (TO_CHAR(pj.project_number), NVL(tk.task_number,'~'), NVL(u.expenditure_type,'~'))
            IN (SELECT pk, tk, et FROM kys)
    ) x
    ORDER BY x.pnum, x.tnum, x.et, x.per
    FETCH FIRST 5000 ROWS ONLY
  ) LOOP
    l_total := r.full_n; l_chg := r.full_chg; l_fann := r.full_fann; l_fytd := r.full_fytd;
    APEX_JSON.open_object;
    APEX_JSON.write('id',               r.rid);
    APEX_JSON.write('projectNumber',    NVL(r.pnum,''));
    APEX_JSON.write('projectName',      NVL(r.pname,''));
    APEX_JSON.write('taskNumber',       NVL(r.tnum,''));
    APEX_JSON.write('taskName',         NVL(r.tname,''));
    APEX_JSON.write('expenditureType',  NVL(r.et,''));
    APEX_JSON.write('accountingPeriod', NVL(r.per,''));
    APEX_JSON.write('fusionAnnual',     r.f_ann);
    APEX_JSON.write('fusionYtd',        r.f_ytd);
    APEX_JSON.write('changeAmount',     r.chg);
    APEX_JSON.write('lineChangeTotal',  r.line_chg);
    APEX_JSON.write('adjustedAnnual',   r.adj_ann);
    APEX_JSON.write('adjustedYtd',      r.adj_ytd);
    APEX_JSON.write('reasonCategory',   r.rsn,  p_write_null => TRUE);
    APEX_JSON.write('comments',         r.cmts, p_write_null => TRUE);
    APEX_JSON.write('updatedBy',        NVL(r.uby,''));
    APEX_JSON.write('updatedAt',        NVL(r.uat,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('total', l_total);
  APEX_JSON.open_object('totals');
  APEX_JSON.write('change',       NVL(l_chg,0));
  APEX_JSON.write('fusionAnnual', NVL(l_fann,0));
  APEX_JSON.write('fusionYtd',    NVL(l_fytd,0));
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
  -- body carries budget_change (signed; null or 0 clears) + optional
  -- reason_category / comments - validated inside the shared save
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

PROMPT gl.rest Budget Change endpoints published (/gl/butil/override + /lines).
