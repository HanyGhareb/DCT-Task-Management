-- =============================================================================
-- Budget Utilization -- expenditure-PLAN drill rows (ADDITIVE)
-- File    : 30_gl_plan_drill_ords.sql      App 210 / GL        2026-08-26
-- Adds to : gl.rest -- ONE new template butil/lines/plan (3 segments, so it
--           can never collide with butil/lines)
-- Run     : sql -name prod_mcp @30_gl_plan_drill_ords.sql  (fresh session)
-- IMPORTANT: 05_gl_ords.sql rebuilds gl.rest from scratch -- the GL post-05
--            re-run list is now 07..30.
--
-- WHY: /gl/butil ships the uploaded expenditure plan as Annual / YTD balances
-- per line (db/v2/126 + GL/db/21, 2026-08-26). Every figure on the page
-- drills; this route serves the monthly DCT_PROJECT_CASHFLOW rows behind a
-- plan cell (row mode) or a Plan KPI tile (aggregate mode over the butil
-- filter scope), so the drawer total always ties back to the on-screen
-- balance.
--
-- WHAT: GET /gl/butil/lines/plan
--   type=APPROVED (default) | REVISED  -- which plan column pair
--   period=MM-YYYY                     -- YTD cut: months on/before it (the
--                                         Annual cell simply omits period)
--   project/task/etype                 -- row mode (one butil line)
--   fproject/ftask/fetype + the butil filter set -- aggregate mode via the
--   SAME kys CTE as butil/lines (db/v2/120 key cache incl. SECTOR data scope)
-- Rows: period, amount, cfType, loadedBy, loaded, file (+ project/task/etype
-- identity in aggregate mode); total/count over the FULL set, rows capped
-- 1000 with chronological order.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_plandrill_ords_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'gl.rest';

BEGIN

    ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => 'butil/lines/plan');
    ORDS.DEFINE_HANDLER(
        p_module_name => c_mod,
        p_pattern     => 'butil/lines/plan',
        p_method      => 'GET',
        p_source_type => ORDS.source_type_plsql,
        p_source      => REPLACE(q'!
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_uid     NUMBER := dct_auth.get_user_id(l_user);
  l_secok   NUMBER := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  l_year    NUMBER        := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_type    VARCHAR2(20)  := UPPER(NVL([COLON]type,'APPROVED'));
  l_project VARCHAR2(120) := [COLON]project;
  l_task    VARCHAR2(120) := [COLON]task;
  l_etype   VARCHAR2(255) := [COLON]etype;
  l_ptype   VARCHAR2(1000) := [COLON]projecttype;
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
  l_total   NUMBER := 0;
  l_count   NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  IF l_type NOT IN ('APPROVED','REVISED') THEN
    dct_rest.err(400,'type must be APPROVED or REVISED'); RETURN;
  END IF;
  IF l_project = '' THEN l_project := NULL; END IF;
  IF l_task    = '' THEN l_task    := NULL; END IF;
  IF l_etype   = '' THEN l_etype   := NULL; END IF;
  IF l_ptype   = '' THEN l_ptype   := NULL; END IF;
  IF l_sector  = '' THEN l_sector  := NULL; END IF;
  IF l_chapter = '' THEN l_chapter := NULL; END IF;
  IF l_bu      = '' THEN l_bu      := NULL; END IF;
  IF l_approp  = '' THEN l_approp  := NULL; END IF;
  IF l_program = '' THEN l_program := NULL; END IF;
  IF l_cc      = '' THEN l_cc      := NULL; END IF;
  IF l_fproj   = '' THEN l_fproj   := NULL; END IF;
  IF l_ftask   = '' THEN l_ftask   := NULL; END IF;
  IF l_fetype  = '' THEN l_fetype  := NULL; END IF;
  IF l_search  = '' THEN l_search  := NULL; END IF;
  IF l_period  = '' THEN l_period  := NULL; END IF;
  IF l_period IS NOT NULL THEN
    IF NOT REGEXP_LIKE(l_period, '^(0[1-9]|1[0-2])-[0-9]{4}$')
       OR TO_NUMBER(SUBSTR(l_period, 4)) <> l_year THEN
      dct_rest.err(400,'period must be MM-YYYY within the selected year'); RETURN;
    END IF;
    l_end := LAST_DAY(TO_DATE('01-'||l_period, 'DD-MM-YYYY'));
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('type', l_type);
  IF l_period IS NOT NULL THEN APEX_JSON.write('period', l_period); END IF;
  APEX_JSON.open_array('rows');
  FOR r IN (
    WITH kys AS (
           SELECT CAST(l_project AS VARCHAR2(120)) pk, NVL(l_task,'~') tk, NVL(l_etype,'~') et FROM dual WHERE l_project IS NOT NULL
           UNION ALL
           SELECT v.project_number, NVL(v.task_number,'~'), NVL(v.expenditure_type,'~') FROM prod.dct_butil_key_cache v
           WHERE l_project IS NULL AND v.budget_year = l_year
             AND (l_ptype  IS NULL OR INSTR('|'||l_ptype||'|', '|'||v.project_type||'|') > 0)
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
             AND (l_search IS NULL OR UPPER(v.project_number||' '||v.project_name||' '||v.task_number||' '||v.department||' '||v.cost_centre||' '||v.expenditure_type) LIKE '%'||UPPER(l_search)||'%'))
    SELECT f.project_number, f.task_number, f.expenditure_type,
           f.accounting_period, f.cf_type, f.cf_amount,
           f.loaded_by, f.source_file,
           TO_CHAR(dct_to_local(f.loaded_at),'YYYY-MM-DD') loaded,
           COUNT(*) OVER () full_n,
           SUM(f.cf_amount) OVER () full_tot
    FROM prod.dct_project_cashflow f
    WHERE f.budget_year = l_year
      AND f.cf_type = l_type
      AND (f.project_number, NVL(f.task_number,'~'), NVL(f.expenditure_type,'~'))
          IN (SELECT pk, tk, et FROM kys)
      AND (l_end IS NULL
           OR NVL(f.period_date, TO_DATE('01-'||f.accounting_period, 'DD-MM-YYYY')) <= l_end)
      AND f.cf_amount <> 0
    ORDER BY NVL(f.period_date, TO_DATE('01-'||f.accounting_period, 'DD-MM-YYYY')),
             f.project_number, f.task_number, f.expenditure_type
    FETCH FIRST 1000 ROWS ONLY
  ) LOOP
    l_count := r.full_n; l_total := r.full_tot;
    APEX_JSON.open_object;
    APEX_JSON.write('project', NVL(r.project_number,''));
    APEX_JSON.write('task', NVL(r.task_number,''));
    APEX_JSON.write('etype', NVL(r.expenditure_type,''));
    APEX_JSON.write('period', NVL(r.accounting_period,''));
    APEX_JSON.write('cfType', NVL(r.cf_type,''));
    APEX_JSON.write('amount', r.cf_amount);
    APEX_JSON.write('loadedBy', NVL(r.loaded_by,''));
    APEX_JSON.write('loaded', NVL(r.loaded,''));
    APEX_JSON.write('file', NVL(r.source_file,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('total', l_total);
  APEX_JSON.write('count', l_count);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!', '[COLON]', CHR(58)));

END;
/

BEGIN
    setup_gl_plandrill_ords_tmp;
    COMMIT;
END;
/
DROP PROCEDURE setup_gl_plandrill_ords_tmp;

PROMPT === verify ===
SELECT t.uri_template, h.method, LENGTH(h.source) src_len
FROM user_ords_handlers h
JOIN user_ords_templates t ON t.id = h.template_id
JOIN user_ords_modules m  ON m.id = t.module_id
WHERE m.name = 'gl.rest' AND t.uri_template = 'butil/lines/plan';

PROMPT gl.rest butil/lines/plan published (expenditure-plan drill rows).
