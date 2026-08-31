-- =============================================================================
-- Budget Utilization -- FUND MOVEMENT columns (ADDITIVE)
-- File    : 34_butil_fundmove_ords.sql   App 210 / GL        2026-08-30
-- Adds to : gl.rest -- TWO new templates:
--             butil/fundmove        (per-key aggregates for the page columns)
--             butil/lines/fundmove  (drill rows -- the Fund Movement sheet set)
-- Run     : sql -name prod_mcp @34_butil_fundmove_ords.sql  (fresh session)
-- IMPORTANT: 05_gl_ords.sql rebuilds gl.rest from scratch -- the GL post-05
--            re-run list is now 07..34.
--
-- WHY: the user wants two columns on EVERY Budget Utilization tab (Budget
-- Line / Department / Sector) -- Fund Movement Count and Fund Movement Amount
-- (net, signed) -- with a green/red additions-vs-deductions breakdown popover
-- and a drilldown listing the transfer transactions with the SAME columns as
-- the BUDGET_UTIL_REGISTER "Fund Movement" sheet (reporting/db/25).
--
-- SOURCE + RULES (mirrors the register sheet, 2026-08-30 user decisions):
--   * pa_additional_fund_lines JOIN pa_budget_trx_headers type 'Additional',
--     trx_year = the budget year, transaction_date cut at the selected
--     accounting period (YTD).
--   * 2026-08-31 (user): APPROVED transactions ONLY -- latest
--     pa_budget_trx_approvals assignment_state = 'Approved' (sheet parity:
--     the register Fund Movement sheet carries the same rule; Rejected /
--     Withdraw / no-trail transactions are excluded from counts, amounts
--     AND the drill). Was: all statuses (the original 2026-08-30 pick).
--   * count basis = transfer LINES (a cell count always equals its drill
--     row count); zero-amount lines are excluded from count AND drill
--     (22 of 4,561 live lines) -- they are neither addition nor deduction.
--   * amount = NET signed sum (additions minus deductions).
--   * level=line groups by the EXACT butil key project/task/etype (the page
--     merges by key, so only exact matches land on a row -- user pick);
--     level=dept|sector attributes by the transfer's OWN cost centre /
--     sector (segment 3 of the combination, else the trailing digits of the
--     organization text; sector via the COA snap) so nothing is dropped --
--     the register sheet's rule.
--   * page filters bind on the dept/sector aggregates and on the drill's
--     group mode with the transfer's OWN attributes (register semantics);
--     appropriation/program match the segment as a leading token so both
--     bare codes and 'CODE - Description' composites work. level=line
--     ignores the page filters (the row key IS the filter).
-- The drill takes sort=default (project/task/etype/trx date) or sort=date
-- (trx date first) -- the two orders the user specified. The drill response
-- also ships a `combos` side-object (2026-08-30 round 2): each DISTINCT
-- code_combination resolved against DCT_GL_COA_SNAP to the 10 segment
-- code+description pairs, feeding the client's styled combination popover
-- on the Code Combination column (same comboRows shape as the Actuals grid).
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_fundmove1_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'gl.rest';

BEGIN

    ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => 'butil/fundmove');
    ORDS.DEFINE_HANDLER(
        p_module_name => c_mod,
        p_pattern     => 'butil/fundmove',
        p_method      => 'GET',
        p_source_type => ORDS.source_type_plsql,
        p_source      => REPLACE(q'!
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_uid     NUMBER;
  l_secok   NUMBER;
  l_year    NUMBER        := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_level   VARCHAR2(10)  := LOWER(NVL([COLON]level,'line'));
  l_period  VARCHAR2(10)  := [COLON]period;
  l_ptype   VARCHAR2(1000) := [COLON]projecttype;
  l_sector  VARCHAR2(200) := [COLON]sector;
  l_chapter VARCHAR2(2000) := [COLON]chapter;
  l_cc      VARCHAR2(2000) := [COLON]costcenter;
  l_proj    VARCHAR2(2000) := [COLON]project;
  l_task    VARCHAR2(200) := [COLON]task;
  l_etype   VARCHAR2(255) := [COLON]etype;
  l_bu      VARCHAR2(2000) := [COLON]bu;
  l_approp  VARCHAR2(2000) := [COLON]appropriation;
  l_program VARCHAR2(2000) := [COLON]program;
  l_search  VARCHAR2(200) := [COLON]search;
  l_end     DATE;
  t_cnt NUMBER := 0; t_amt NUMBER := 0; t_pc NUMBER := 0; t_pa NUMBER := 0;
  t_nc NUMBER := 0; t_na NUMBER := 0;
  PROCEDURE agg(p_cnt NUMBER, p_amt NUMBER, p_pc NUMBER, p_pa NUMBER, p_nc NUMBER, p_na NUMBER) IS
  BEGIN
    APEX_JSON.write('cnt', p_cnt);      APEX_JSON.write('amt', NVL(p_amt,0));
    APEX_JSON.write('posCnt', p_pc);    APEX_JSON.write('posAmt', NVL(p_pa,0));
    APEX_JSON.write('negCnt', p_nc);    APEX_JSON.write('negAmt', NVL(p_na,0));
    t_cnt := t_cnt + p_cnt; t_amt := t_amt + NVL(p_amt,0);
    t_pc := t_pc + p_pc; t_pa := t_pa + NVL(p_pa,0);
    t_nc := t_nc + p_nc; t_na := t_na + NVL(p_na,0);
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  IF l_level NOT IN ('line','dept','sector') THEN
    dct_rest.err(400,'level must be line, dept or sector'); RETURN;
  END IF;
  l_uid := dct_auth.get_user_id(l_user);
  l_secok := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  IF l_period = '' THEN l_period := NULL; END IF;
  IF l_period IS NOT NULL THEN
    IF NOT REGEXP_LIKE(l_period, '^(0[1-9]|1[0-2])-[0-9]{4}$')
       OR TO_NUMBER(SUBSTR(l_period, 4)) <> l_year THEN
      dct_rest.err(400,'period must be MM-YYYY within the selected year'); RETURN;
    END IF;
    l_end := LAST_DAY(TO_DATE('01-'||l_period, 'DD-MM-YYYY'));
  END IF;
  IF l_ptype = '' THEN l_ptype := NULL; END IF;
  IF l_sector = '' THEN l_sector := NULL; END IF;
  IF l_chapter = '' THEN l_chapter := NULL; END IF;
  IF l_cc = '' THEN l_cc := NULL; END IF;
  IF l_proj = '' THEN l_proj := NULL; END IF;
  IF l_task = '' THEN l_task := NULL; END IF;
  IF l_etype = '' THEN l_etype := NULL; END IF;
  IF l_bu = '' THEN l_bu := NULL; END IF;
  IF l_approp = '' THEN l_approp := NULL; END IF;
  IF l_program = '' THEN l_program := NULL; END IF;
  IF l_search = '' THEN l_search := NULL; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('level', l_level);
  APEX_JSON.open_array('items');
  IF l_level = 'line' THEN
    FOR r IN (
      SELECT l.project_num, l.task_num, l.expenditure_type,
             COUNT(*) cnt, SUM(l.additional_amount) amt,
             SUM(CASE WHEN l.additional_amount > 0 THEN 1 ELSE 0 END) pc,
             SUM(CASE WHEN l.additional_amount > 0 THEN l.additional_amount ELSE 0 END) pa,
             SUM(CASE WHEN l.additional_amount < 0 THEN 1 ELSE 0 END) nc,
             SUM(CASE WHEN l.additional_amount < 0 THEN l.additional_amount ELSE 0 END) na
      FROM prod.pa_additional_fund_lines l
      JOIN prod.pa_budget_trx_headers h
        ON h.transaction_num = l.transaction_num AND h.transaction_type = 'Additional'
      JOIN (SELECT transaction_num,
                   MAX(assignment_state) KEEP (DENSE_RANK LAST ORDER BY seq_no) st
            FROM prod.pa_budget_trx_approvals WHERE trx_type = 'Additional'
            GROUP BY transaction_num) a
        ON a.transaction_num = l.transaction_num AND a.st = 'Approved'
      WHERE h.trx_year = TO_CHAR(l_year)
        AND (l_end IS NULL OR h.transaction_date < l_end + 1)
        AND NVL(l.additional_amount,0) <> 0
      GROUP BY l.project_num, l.task_num, l.expenditure_type
    ) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('project', NVL(r.project_num,''));
      APEX_JSON.write('task', NVL(r.task_num,''));
      APEX_JSON.write('etype', NVL(r.expenditure_type,''));
      agg(r.cnt, r.amt, r.pc, r.pa, r.nc, r.na);
      APEX_JSON.close_object;
    END LOOP;
  ELSE
    FOR r IN (
      SELECT CASE WHEN l_level = 'dept' THEN x.cc_code ELSE cs.sector_name END grp,
             MAX(cs.cost_center_desc) dept,
             COUNT(*) cnt, SUM(x.amount) amt,
             SUM(CASE WHEN x.amount > 0 THEN 1 ELSE 0 END) pc,
             SUM(CASE WHEN x.amount > 0 THEN x.amount ELSE 0 END) pa,
             SUM(CASE WHEN x.amount < 0 THEN 1 ELSE 0 END) nc,
             SUM(CASE WHEN x.amount < 0 THEN x.amount ELSE 0 END) na
      FROM (SELECT h.transaction_num, h.decree_no, h.project_type, h.business_unit,
                   l.project_num, l.project_name, l.task_num, l.expenditure_type,
                   l.additional_amount amount,
                   COALESCE(REGEXP_SUBSTR(l.code_combination,'[^.]+',1,3),
                            REGEXP_SUBSTR(l.cost_center,'[0-9]+$')) cc_code,
                   REGEXP_SUBSTR(l.code_combination,'[^.]+',1,7) appr_code,
                   REGEXP_SUBSTR(l.code_combination,'[^.]+',1,2) prog_code
            FROM prod.pa_additional_fund_lines l
            JOIN prod.pa_budget_trx_headers h
              ON h.transaction_num = l.transaction_num AND h.transaction_type = 'Additional'
            JOIN (SELECT transaction_num,
                         MAX(assignment_state) KEEP (DENSE_RANK LAST ORDER BY seq_no) st
                  FROM prod.pa_budget_trx_approvals WHERE trx_type = 'Additional'
                  GROUP BY transaction_num) a
              ON a.transaction_num = l.transaction_num AND a.st = 'Approved'
            WHERE h.trx_year = TO_CHAR(l_year)
              AND (l_end IS NULL OR h.transaction_date < l_end + 1)
              AND NVL(l.additional_amount,0) <> 0) x
      LEFT JOIN (SELECT cost_center_code, MAX(cost_center_desc) cost_center_desc,
                        MAX(sector_name) sector_name
                 FROM prod.dct_gl_coa_snap WHERE cost_center_code IS NOT NULL
                 GROUP BY cost_center_code) cs ON cs.cost_center_code = x.cc_code
      LEFT JOIN (SELECT appropriation_code, MAX(chapter_name) chapter_name
                 FROM prod.dct_gl_coa_snap WHERE appropriation_code IS NOT NULL
                 GROUP BY appropriation_code) ap ON ap.appropriation_code = x.appr_code
      WHERE (l_sector IS NULL OR cs.sector_name = l_sector)
        AND (l_secok = 1 OR cs.sector_name IN (SELECT cv.name_en FROM prod.dct_gl_class_value cv JOIN prod.v_dct_sec_user_scope sc ON sc.object_key = cv.value_code AND sc.object_type_code = 'SECTOR' AND sc.user_id = l_uid WHERE cv.class_type_code = 'SECTOR'))
        AND (l_chapter IS NULL OR INSTR('|'||l_chapter||'|', '|'||ap.chapter_name||'|') > 0)
        AND (l_cc IS NULL OR (INSTR(l_cc,'|') = 0 AND x.cc_code LIKE '%'||l_cc||'%')
                          OR INSTR('|'||l_cc||'|', '|'||x.cc_code||'|') > 0)
        AND (l_ptype IS NULL OR INSTR('|'||l_ptype||'|', '|'||x.project_type||'|') > 0)
        AND (l_proj IS NULL OR (INSTR(l_proj,'|') = 0 AND UPPER(x.project_num||' '||x.project_name) LIKE '%'||UPPER(l_proj)||'%')
                            OR INSTR('|'||l_proj||'|', '|'||x.project_num||'|') > 0)
        AND (l_task IS NULL OR UPPER(x.task_num) LIKE '%'||UPPER(l_task)||'%')
        AND (l_etype IS NULL OR UPPER(x.expenditure_type) LIKE '%'||UPPER(l_etype)||'%')
        AND (l_bu IS NULL OR INSTR('|'||l_bu||'|', '|'||x.business_unit||'|') > 0)
        AND (l_approp IS NULL OR INSTR('|'||l_approp, '|'||x.appr_code) > 0 OR l_approp LIKE x.appr_code||'%')
        AND (l_program IS NULL OR INSTR('|'||l_program, '|'||x.prog_code) > 0 OR l_program LIKE x.prog_code||'%')
        AND (l_search IS NULL OR UPPER(x.transaction_num||' '||x.decree_no||' '||x.project_num||' '||x.project_name||' '||x.task_num||' '||x.expenditure_type) LIKE '%'||UPPER(l_search)||'%')
      GROUP BY CASE WHEN l_level = 'dept' THEN x.cc_code ELSE cs.sector_name END
    ) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('key', NVL(r.grp,''));
      IF l_level = 'dept' THEN APEX_JSON.write('department', NVL(r.dept,'')); END IF;
      agg(r.cnt, r.amt, r.pc, r.pa, r.nc, r.na);
      APEX_JSON.close_object;
    END LOOP;
  END IF;
  APEX_JSON.close_array;
  APEX_JSON.open_object('totals');
  APEX_JSON.write('cnt', t_cnt);   APEX_JSON.write('amt', t_amt);
  APEX_JSON.write('posCnt', t_pc); APEX_JSON.write('posAmt', t_pa);
  APEX_JSON.write('negCnt', t_nc); APEX_JSON.write('negAmt', t_na);
  APEX_JSON.close_object;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!', '[COLON]', CHR(58)));

END;
/

BEGIN
    setup_gl_fundmove1_tmp;
    COMMIT;
END;
/
DROP PROCEDURE setup_gl_fundmove1_tmp;

CREATE OR REPLACE PROCEDURE setup_gl_fundmove2_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'gl.rest';

BEGIN

    ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => 'butil/lines/fundmove');
    ORDS.DEFINE_HANDLER(
        p_module_name => c_mod,
        p_pattern     => 'butil/lines/fundmove',
        p_method      => 'GET',
        p_source_type => ORDS.source_type_plsql,
        p_source      => REPLACE(q'!
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_uid     NUMBER;
  l_secok   NUMBER;
  l_year    NUMBER        := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_sort    VARCHAR2(10)  := LOWER(NVL([COLON]sort,'default'));
  l_project VARCHAR2(120) := [COLON]project;
  l_task    VARCHAR2(120) := [COLON]task;
  l_etype   VARCHAR2(255) := [COLON]etype;
  l_ptype   VARCHAR2(1000) := [COLON]projecttype;
  l_sector  VARCHAR2(200) := [COLON]sector;
  l_chapter VARCHAR2(2000) := [COLON]chapter;
  l_cc      VARCHAR2(2000) := [COLON]costcenter;
  l_fproj   VARCHAR2(2000) := [COLON]fproject;
  l_ftask   VARCHAR2(200) := [COLON]ftask;
  l_fetype  VARCHAR2(255) := [COLON]fetype;
  l_bu      VARCHAR2(2000) := [COLON]bu;
  l_approp  VARCHAR2(2000) := [COLON]appropriation;
  l_program VARCHAR2(2000) := [COLON]program;
  l_search  VARCHAR2(200) := [COLON]search;
  l_period  VARCHAR2(10)  := [COLON]period;
  l_end     DATE;
  l_total   NUMBER := 0;
  l_count   NUMBER := 0;
  l_combos  apex_t_varchar2 := apex_t_varchar2();
  TYPE t_seen IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(200);
  l_seen    t_seen;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  IF l_sort NOT IN ('default','date') THEN
    dct_rest.err(400,'sort must be default or date'); RETURN;
  END IF;
  l_uid := dct_auth.get_user_id(l_user);
  l_secok := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  IF l_project = '' THEN l_project := NULL; END IF;
  IF l_task = '' THEN l_task := NULL; END IF;
  IF l_etype = '' THEN l_etype := NULL; END IF;
  IF l_ptype = '' THEN l_ptype := NULL; END IF;
  IF l_sector = '' THEN l_sector := NULL; END IF;
  IF l_chapter = '' THEN l_chapter := NULL; END IF;
  IF l_cc = '' THEN l_cc := NULL; END IF;
  IF l_fproj = '' THEN l_fproj := NULL; END IF;
  IF l_ftask = '' THEN l_ftask := NULL; END IF;
  IF l_fetype = '' THEN l_fetype := NULL; END IF;
  IF l_bu = '' THEN l_bu := NULL; END IF;
  IF l_approp = '' THEN l_approp := NULL; END IF;
  IF l_program = '' THEN l_program := NULL; END IF;
  IF l_search = '' THEN l_search := NULL; END IF;
  IF l_period = '' THEN l_period := NULL; END IF;
  IF l_period IS NOT NULL THEN
    IF NOT REGEXP_LIKE(l_period, '^(0[1-9]|1[0-2])-[0-9]{4}$')
       OR TO_NUMBER(SUBSTR(l_period, 4)) <> l_year THEN
      dct_rest.err(400,'period must be MM-YYYY within the selected year'); RETURN;
    END IF;
    l_end := LAST_DAY(TO_DATE('01-'||l_period, 'DD-MM-YYYY'));
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('sort', l_sort);
  APEX_JSON.open_array('rows');
  FOR r IN (
    SELECT x.*, cs.cost_center_desc department, cs.sector_name sector,
           ap.chapter_name chapter,
           apr.submitted_by, apr.assignee approved_by, apr.approval_state, apr.approval_date,
           COUNT(*) OVER () full_n, SUM(x.amount) OVER () full_tot
    FROM (SELECT h.transaction_num, h.decree_no,
                 TO_CHAR(h.transaction_date,'YYYY-MM-DD') trx_date, h.transaction_date trx_dt,
                 h.trx_year, h.business_unit, h.project_type, h.status trx_status,
                 l.project_num, l.project_name, l.task_num, l.expenditure_type,
                 l.code_combination, l.additional_amount amount, l.commitments commitment,
                 l.total_annual_budget, l.fund_available, l.total_actual,
                 l.cost_center organization, l.line_status, l.baseline_status,
                 l.jv_status journal_status, l.notes, l.identifier,
                 COALESCE(REGEXP_SUBSTR(l.code_combination,'[^.]+',1,3),
                          REGEXP_SUBSTR(l.cost_center,'[0-9]+$')) cc_code,
                 REGEXP_SUBSTR(l.code_combination,'[^.]+',1,7) appr_code,
                 REGEXP_SUBSTR(l.code_combination,'[^.]+',1,2) prog_code
          FROM prod.pa_additional_fund_lines l
          JOIN prod.pa_budget_trx_headers h
            ON h.transaction_num = l.transaction_num AND h.transaction_type = 'Additional'
          WHERE h.trx_year = TO_CHAR(l_year)
            AND (l_end IS NULL OR h.transaction_date < l_end + 1)
            AND NVL(l.additional_amount,0) <> 0) x
    LEFT JOIN (SELECT cost_center_code, MAX(cost_center_desc) cost_center_desc,
                      MAX(sector_name) sector_name
               FROM prod.dct_gl_coa_snap WHERE cost_center_code IS NOT NULL
               GROUP BY cost_center_code) cs ON cs.cost_center_code = x.cc_code
    LEFT JOIN (SELECT appropriation_code, MAX(chapter_name) chapter_name
               FROM prod.dct_gl_coa_snap WHERE appropriation_code IS NOT NULL
               GROUP BY appropriation_code) ap ON ap.appropriation_code = x.appr_code
    LEFT JOIN (SELECT transaction_num,
                      MAX(submitter_name) KEEP (DENSE_RANK FIRST ORDER BY seq_no) submitted_by,
                      LISTAGG(DISTINCT assignee_username, ', ' ON OVERFLOW TRUNCATE) WITHIN GROUP (ORDER BY assignee_username) assignee,
                      MAX(assignment_state) KEEP (DENSE_RANK LAST ORDER BY seq_no) approval_state,
                      TO_CHAR(prod.dct_to_local(MAX(creation_date)),'YYYY-MM-DD HH24'||CHR(58)||'MI') approval_date
               FROM prod.pa_budget_trx_approvals WHERE trx_type = 'Additional'
               GROUP BY transaction_num) apr ON apr.transaction_num = x.transaction_num
    WHERE apr.approval_state = 'Approved'
      AND (l_project IS NULL OR (x.project_num = l_project
             AND NVL(x.task_num,'~') = NVL(l_task,'~')
             AND NVL(x.expenditure_type,'~') = NVL(l_etype,'~')))
      AND (l_project IS NOT NULL OR (
            (l_sector IS NULL OR cs.sector_name = l_sector)
        AND (l_secok = 1 OR cs.sector_name IN (SELECT cv.name_en FROM prod.dct_gl_class_value cv JOIN prod.v_dct_sec_user_scope sc ON sc.object_key = cv.value_code AND sc.object_type_code = 'SECTOR' AND sc.user_id = l_uid WHERE cv.class_type_code = 'SECTOR'))
        AND (l_chapter IS NULL OR INSTR('|'||l_chapter||'|', '|'||ap.chapter_name||'|') > 0)
        AND (l_cc IS NULL OR (INSTR(l_cc,'|') = 0 AND x.cc_code LIKE '%'||l_cc||'%')
                          OR INSTR('|'||l_cc||'|', '|'||x.cc_code||'|') > 0)
        AND (l_ptype IS NULL OR INSTR('|'||l_ptype||'|', '|'||x.project_type||'|') > 0)
        AND (l_fproj IS NULL OR (INSTR(l_fproj,'|') = 0 AND UPPER(x.project_num||' '||x.project_name) LIKE '%'||UPPER(l_fproj)||'%')
                             OR INSTR('|'||l_fproj||'|', '|'||x.project_num||'|') > 0)
        AND (l_ftask IS NULL OR UPPER(x.task_num) LIKE '%'||UPPER(l_ftask)||'%')
        AND (l_fetype IS NULL OR UPPER(x.expenditure_type) LIKE '%'||UPPER(l_fetype)||'%')
        AND (l_bu IS NULL OR INSTR('|'||l_bu||'|', '|'||x.business_unit||'|') > 0)
        AND (l_approp IS NULL OR INSTR('|'||l_approp, '|'||x.appr_code) > 0 OR l_approp LIKE x.appr_code||'%')
        AND (l_program IS NULL OR INSTR('|'||l_program, '|'||x.prog_code) > 0 OR l_program LIKE x.prog_code||'%')
        AND (l_search IS NULL OR UPPER(x.transaction_num||' '||x.decree_no||' '||x.project_num||' '||x.project_name||' '||x.task_num||' '||x.expenditure_type) LIKE '%'||UPPER(l_search)||'%')))
    ORDER BY CASE WHEN l_sort = 'date' THEN x.trx_dt END,
             x.project_num, x.task_num, x.expenditure_type,
             CASE WHEN l_sort = 'default' THEN x.trx_dt END,
             x.transaction_num, x.identifier
    FETCH FIRST 1000 ROWS ONLY
  ) LOOP
    l_count := r.full_n; l_total := r.full_tot;
    APEX_JSON.open_object;
    APEX_JSON.write('project', NVL(r.project_num,''));
    APEX_JSON.write('projectName', NVL(r.project_name,''));
    APEX_JSON.write('task', NVL(r.task_num,''));
    APEX_JSON.write('etype', NVL(r.expenditure_type,''));
    APEX_JSON.write('combination', NVL(r.code_combination,''));
    APEX_JSON.write('amount', r.amount);
    APEX_JSON.write('commitment', r.commitment);
    APEX_JSON.write('annualBudget', r.total_annual_budget);
    APEX_JSON.write('fundAvailable', r.fund_available);
    APEX_JSON.write('totalActual', r.total_actual);
    APEX_JSON.write('costCentre', NVL(r.cc_code,''));
    APEX_JSON.write('department', NVL(r.department,''));
    APEX_JSON.write('organization', NVL(r.organization,''));
    APEX_JSON.write('sector', NVL(r.sector,''));
    APEX_JSON.write('trxNum', NVL(r.transaction_num,''));
    APEX_JSON.write('decreeNo', NVL(r.decree_no,''));
    APEX_JSON.write('trxDate', NVL(r.trx_date,''));
    APEX_JSON.write('trxYear', NVL(r.trx_year,''));
    APEX_JSON.write('businessUnit', NVL(r.business_unit,''));
    APEX_JSON.write('trxStatus', NVL(r.trx_status,''));
    APEX_JSON.write('lineStatus', NVL(r.line_status,''));
    APEX_JSON.write('baselineStatus', NVL(r.baseline_status,''));
    APEX_JSON.write('journalStatus', NVL(r.journal_status,''));
    APEX_JSON.write('submittedBy', NVL(r.submitted_by,''));
    APEX_JSON.write('approvedBy', NVL(r.approved_by,''));
    APEX_JSON.write('approvalState', NVL(r.approval_state,''));
    APEX_JSON.write('approvalDate', NVL(r.approval_date,''));
    APEX_JSON.write('notes', NVL(r.notes,''));
    APEX_JSON.close_object;
    IF r.code_combination IS NOT NULL AND NOT l_seen.EXISTS(r.code_combination) THEN
      l_seen(r.code_combination) := 1;
      l_combos.EXTEND; l_combos(l_combos.COUNT) := r.code_combination;
    END IF;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_object('combos');
  FOR c IN (SELECT * FROM prod.dct_gl_coa_snap
            WHERE cc_string IN (SELECT column_value FROM TABLE(l_combos))) LOOP
    APEX_JSON.open_object(c.cc_string);
    APEX_JSON.write('entityCode', c.entity_code);
    APEX_JSON.write('entityDesc', NVL(c.entity_desc,''));
    APEX_JSON.write('costCenterCode', c.cost_center_code);
    APEX_JSON.write('costCenterDesc', NVL(c.cost_center_desc,''));
    APEX_JSON.write('accountCode', c.account_code);
    APEX_JSON.write('accountDesc', NVL(c.account_desc,''));
    APEX_JSON.write('appropriationCode', c.appropriation_code);
    APEX_JSON.write('appropriationDesc', NVL(c.appropriation_desc,''));
    APEX_JSON.write('budgetGroupCode', c.budget_group_code);
    APEX_JSON.write('budgetGroupDesc', NVL(c.budget_group_desc,''));
    APEX_JSON.write('entitySpecificCode', c.entity_specific_code);
    APEX_JSON.write('entitySpecificDesc', NVL(c.entity_specific_desc,''));
    APEX_JSON.write('future1Code', c.future1_code);
    APEX_JSON.write('future1Desc', NVL(c.future1_desc,''));
    APEX_JSON.write('future2Code', c.future2_code);
    APEX_JSON.write('future2Desc', NVL(c.future2_desc,''));
    APEX_JSON.write('intercompanyCode', c.intercompany_code);
    APEX_JSON.write('intercompanyDesc', NVL(c.intercompany_desc,''));
    APEX_JSON.write('programCode', c.program_code);
    APEX_JSON.write('programDesc', NVL(c.program_desc,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_object;
  APEX_JSON.write('total', l_total);
  APEX_JSON.write('count', l_count);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!', '[COLON]', CHR(58)));

END;
/

BEGIN
    setup_gl_fundmove2_tmp;
    COMMIT;
END;
/
DROP PROCEDURE setup_gl_fundmove2_tmp;

PROMPT === verify ===
SELECT t.uri_template, h.method, LENGTH(h.source) src_len
FROM user_ords_handlers h
JOIN user_ords_templates t ON t.id = h.template_id
JOIN user_ords_modules m  ON m.id = t.module_id
WHERE m.name = 'gl.rest' AND t.uri_template IN ('butil/fundmove','butil/lines/fundmove')
ORDER BY t.uri_template;

PROMPT gl.rest butil/fundmove + butil/lines/fundmove published (Fund Movement columns).
