-- =============================================================================
-- Budget Utilization -- LEVEL AGGREGATION (Results-region tabs, ADDITIVE)
-- File    : 33_butil_agg_ords.sql   App 210 / GL              2026-08-29
--           (+ vs Budget verdict per group 2026-08-31, v1.96.0 -- budUtilPct/
--           budVariance/budState vs the ADJUSTED ANNUAL budget, thresholds
--           BUD_UTIL_NEAR_PCT/OVER_PCT seeded by GL/db/35)
-- Adds to : gl.rest -- NEW template butil/agg (GET). Nothing existing is
--           touched; the live GET butil owner stays GL/db/32.
-- Run     : sql -name prod_mcp @33_butil_agg_ords.sql  (fresh session, ADMIN)
-- Needs   : db/v2/120 (dct_butil_key_cache) + db/v2/126 (plan view) deployed.
--           GL post-05 re-run list is now 07..33.
--
-- WHAT: GET /gl/butil/agg?level=dept|sector -- the Department / Sector tabs of
-- the Budget Utilization Results region (user request 2026-08-29, layout B).
-- Same butil-view join + predicate set as GET /gl/butil (GL/db/32), GROUPed to
-- cost-centre or sector grain, with the SAME costadj / procash / ovr folding,
-- so every tab figure reconciles to the Budget Line tab and the KPI band.
-- A second UNION ALL leg adds the uploaded expenditure plan rows that have NO
-- matching budget line (the /gl/butil planUnmatched amount): attributed to a
-- cost centre / sector through dct_butil_key_cache -- task match first, then
-- the project's attributes -- and folded into the group plan figures, so a
-- department's plan total finally matches the Cashflow upload. A group with
-- plan but no lines ships planOnly=Y. Group verdicts (vs Plan / Coverage) use
-- the same thresholds and expressions as the line grain. cmtCount per group
-- counts COST_CENTER / SECTOR level comments (db/v2/125) for the period, and
-- commentsText (2026-08-29 feedback) ships the recorded comment text of the
-- department / sector at the selected accounting period (newline-joined,
-- newest first; full year = the whole year's comments).
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_butil_agg AS
    c_mod CONSTANT VARCHAR2(30) := 'gl.rest';
BEGIN
    ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => 'butil/agg');
    ORDS.DEFINE_HANDLER(
        p_module_name => c_mod,
        p_pattern     => 'butil/agg',
        p_method      => 'GET',
        p_source_type => ORDS.source_type_plsql,
        p_source      => REPLACE(q'!DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_uid    NUMBER := dct_auth.get_user_id(l_user);
  l_secok  NUMBER := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  l_level  VARCHAR2(10)  := LOWER([COLON]level);
  l_year   NUMBER        := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_ptype  VARCHAR2(1000) := [COLON]projecttype;
  l_sector VARCHAR2(200)  := [COLON]sector;
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
  l_ovr    VARCHAR2(4)   := UPPER(NVL([COLON]ovr,'N'));
  l_pcash  VARCHAR2(4)   := UPPER(NVL([COLON]procash,'N'));
  l_cadj   VARCHAR2(4)   := UPPER(NVL([COLON]costadj,'Y'));
  l_thx1 NUMBER := 90; l_thx2 NUMBER := 110; l_thc1 NUMBER := 95; l_thc2 NUMBER := 105;
  l_tbn NUMBER := 90; l_tbo NUMBER := 100;
  l_end    DATE;
  l_cmtn   NUMBER;
  l_cmtt   VARCHAR2(32767);
  l_act    NUMBER;
  n NUMBER := 0;
  t_ln NUMBER := 0; t_bud NUMBER := 0; t_buda NUMBER := 0; t_ap NUMBER := 0; t_grn NUMBER := 0;
  t_pc NUMBER := 0; t_pr NUMBER := 0; t_po NUMBER := 0; t_fund NUMBER := 0;
  t_pfa NUMBER := 0; t_pfay NUMBER := 0; t_pfr NUMBER := 0; t_pfry NUMBER := 0;
  t_pfey NUMBER := 0; t_pfea NUMBER := 0; t_px NUMBER := 0; t_ponly NUMBER := 0;
  t_cadj NUMBER := 0; t_cmt NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  IF l_level IS NULL OR l_level NOT IN ('dept','sector') THEN dct_rest.err(400,'level must be dept or sector'); RETURN; END IF;
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
  FOR s IN (SELECT setting_key, setting_value FROM prod.dct_module_settings
             WHERE module_id = (SELECT module_id FROM prod.dct_modules WHERE module_code = 'GL')
               AND setting_key IN ('PLAN_EXEC_TOL_LOW','PLAN_EXEC_TOL_HIGH','PLAN_COV_LOW','PLAN_COV_HIGH',
                                   'BUD_UTIL_NEAR_PCT','BUD_UTIL_OVER_PCT')) LOOP
    CASE s.setting_key
      WHEN 'PLAN_EXEC_TOL_LOW'  THEN l_thx1 := NVL(TO_NUMBER(s.setting_value DEFAULT NULL ON CONVERSION ERROR), l_thx1);
      WHEN 'PLAN_EXEC_TOL_HIGH' THEN l_thx2 := NVL(TO_NUMBER(s.setting_value DEFAULT NULL ON CONVERSION ERROR), l_thx2);
      WHEN 'PLAN_COV_LOW'       THEN l_thc1 := NVL(TO_NUMBER(s.setting_value DEFAULT NULL ON CONVERSION ERROR), l_thc1);
      WHEN 'PLAN_COV_HIGH'      THEN l_thc2 := NVL(TO_NUMBER(s.setting_value DEFAULT NULL ON CONVERSION ERROR), l_thc2);
      WHEN 'BUD_UTIL_NEAR_PCT'  THEN l_tbn := NVL(TO_NUMBER(s.setting_value DEFAULT NULL ON CONVERSION ERROR), l_tbn);
      WHEN 'BUD_UTIL_OVER_PCT'  THEN l_tbo := NVL(TO_NUMBER(s.setting_value DEFAULT NULL ON CONVERSION ERROR), l_tbo);
      ELSE NULL;
    END CASE;
  END LOOP;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('level', UPPER(l_level));
  APEX_JSON.write('year', l_year);
  IF l_period IS NOT NULL THEN APEX_JSON.write('period', l_period); END IF;
  APEX_JSON.write('considerOverride', l_ovr);
  APEX_JSON.write('includeProcash', l_pcash);
  APEX_JSON.write('includeCostAdj', l_cadj);
  APEX_JSON.open_object('planThresholds');
  APEX_JSON.write('execLow', l_thx1); APEX_JSON.write('execHigh', l_thx2);
  APEX_JSON.write('covLow', l_thc1); APEX_JSON.write('covHigh', l_thc2);
  APEX_JSON.close_object;
  APEX_JSON.open_object('budgetThresholds');
  APEX_JSON.write('near', l_tbn); APEX_JSON.write('over', l_tbo);
  APEX_JSON.close_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT g.gsec, g.gcc, MAX(g.gdept) gdept, SUM(g.lines) lines,
           SUM(g.bud) bud, SUM(g.buda) buda, SUM(g.ap) ap, SUM(g.grn) grn, SUM(g.pcash) pcash,
           SUM(g.pr) pr, SUM(g.po) po, SUM(g.fund) fund,
           SUM(g.cadj) cadj, SUM(g.cadj_n) cadj_n,
           SUM(g.ovr_b) ovr_b, SUM(g.ovr_ba) ovr_ba, SUM(g.ovr_n) ovr_n,
           SUM(g.pfa) pfa, SUM(g.pfay) pfay, SUM(g.pfr) pfr, SUM(g.pfry) pfry,
           SUM(g.pfe_y) pfe_y, SUM(g.pfe_a) pfe_a, SUM(g.plan_extra) plan_extra
    FROM (
      SELECT v.sector AS gsec,
             CASE WHEN l_level = 'dept' THEN v.cost_centre END AS gcc,
             CASE WHEN l_level = 'dept' THEN v.department END AS gdept,
             1 AS lines,
             v.budget + CASE WHEN l_cadj='Y' THEN NVL(ca.budget_ovr_aed,0) ELSE 0 END AS bud,
             v.budget_annual + CASE WHEN l_cadj='Y' THEN NVL(ca.budget_ovr_annual,0) ELSE 0 END AS buda,
             v.actual_ap + CASE WHEN l_cadj='Y' THEN NVL(ca.cost_adj_aed,0) ELSE 0 END AS ap,
             v.actual_grn AS grn, NVL(pc.procash_aed,0) AS pcash,
             v.commitment_pr AS pr, v.obligation_po AS po,
             v.fund_available - CASE WHEN l_pcash='Y' THEN NVL(pc.procash_aed,0) ELSE 0 END
                              + CASE WHEN l_cadj='Y' THEN NVL(ca.budget_ovr_aed,0) - NVL(ca.cost_adj_aed,0) ELSE 0 END AS fund,
             NVL(ca.cost_adj_aed,0) AS cadj, NVL(ca.adj_count,0) AS cadj_n,
             NVL(v.override_budget,0) AS ovr_b, NVL(v.override_budget_annual,0) AS ovr_ba, NVL(v.override_lines,0) AS ovr_n,
             NVL(pf.plan_appr_annual,0) AS pfa, NVL(pf.plan_appr_ytd,0) AS pfay,
             NVL(pf.plan_rev_annual,0) AS pfr, NVL(pf.plan_rev_ytd,0) AS pfry,
             CASE WHEN NVL(pf.plan_rev_annual,0)<>0 THEN NVL(pf.plan_rev_ytd,0) ELSE NVL(pf.plan_appr_ytd,0) END AS pfe_y,
             CASE WHEN NVL(pf.plan_rev_annual,0)<>0 THEN NVL(pf.plan_rev_annual,0) ELSE NVL(pf.plan_appr_annual,0) END AS pfe_a,
             0 AS plan_extra
        FROM prod.dct_budget_utilization_v v
        LEFT JOIN prod.dct_ap_procash_butil_v pc
               ON pc.budget_year = v.budget_year AND pc.project_number = v.project_number
              AND pc.task_number = v.task_number AND pc.expenditure_type = v.expenditure_type
        LEFT JOIN prod.dct_pa_cost_adj_butil_v ca
               ON ca.budget_year = v.budget_year AND ca.project_number = v.project_number
              AND ca.task_number = v.task_number AND ca.expenditure_type = v.expenditure_type
        LEFT JOIN prod.dct_project_cf_butil_v pf
               ON pf.budget_year = v.budget_year AND pf.project_number = v.project_number
              AND pf.task_number = v.task_number AND pf.expenditure_type = v.expenditure_type
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
      UNION ALL
      SELECT COALESCE(kt.sec, kp.sec) AS gsec,
             CASE WHEN l_level = 'dept' THEN COALESCE(kt.cc, kp.cc) END AS gcc,
             CASE WHEN l_level = 'dept' THEN COALESCE(kt.dep, kp.dep) END AS gdept,
             0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
             NVL(f.plan_appr_annual,0), NVL(f.plan_appr_ytd,0),
             NVL(f.plan_rev_annual,0), NVL(f.plan_rev_ytd,0),
             CASE WHEN NVL(f.plan_rev_annual,0)<>0 THEN NVL(f.plan_rev_ytd,0) ELSE NVL(f.plan_appr_ytd,0) END,
             CASE WHEN NVL(f.plan_rev_annual,0)<>0 THEN NVL(f.plan_rev_annual,0) ELSE NVL(f.plan_appr_annual,0) END,
             NVL(f.plan_appr_annual,0) + NVL(f.plan_rev_annual,0)
        FROM prod.dct_project_cf_butil_v f
        LEFT JOIN (SELECT budget_year ky, project_number kpr, task_number ktk,
                          MAX(sector) sec, MAX(cost_centre) cc, MAX(department) dep,
                          MAX(project_type) pt, MAX(business_unit) bun, MAX(project_name) pn,
                          MAX(chapter) chp, MAX(appropriation) app, MAX(program) prg
                     FROM prod.dct_butil_key_cache
                    GROUP BY budget_year, project_number, task_number) kt
               ON kt.ky = f.budget_year AND kt.kpr = f.project_number AND kt.ktk = f.task_number
        LEFT JOIN (SELECT budget_year ky, project_number kpr,
                          MAX(sector) sec, MAX(cost_centre) cc, MAX(department) dep,
                          MAX(project_type) pt, MAX(business_unit) bun, MAX(project_name) pn
                     FROM prod.dct_butil_key_cache
                    GROUP BY budget_year, project_number) kp
               ON kp.ky = f.budget_year AND kp.kpr = f.project_number
       WHERE f.budget_year = l_year
         AND NOT EXISTS (SELECT 1 FROM prod.dct_butil_key_cache k
                          WHERE k.budget_year = f.budget_year AND k.project_number = f.project_number
                            AND k.task_number = f.task_number AND k.expenditure_type = f.expenditure_type)
         AND (l_ptype  IS NULL OR INSTR('|'||l_ptype||'|', '|'||COALESCE(kt.pt, kp.pt)||'|') > 0)
         AND (l_sector IS NULL OR COALESCE(kt.sec, kp.sec) = l_sector)
         AND (l_secok = 1 OR COALESCE(kt.sec, kp.sec) IN (SELECT cv.name_en FROM prod.dct_gl_class_value cv JOIN prod.v_dct_sec_user_scope sc ON sc.object_key = cv.value_code AND sc.object_type_code = 'SECTOR' AND sc.user_id = l_uid WHERE cv.class_type_code = 'SECTOR'))
         AND (l_chapter IS NULL OR INSTR('|'||l_chapter||'|', '|'||kt.chp||'|') > 0)
         AND (l_bu IS NULL OR INSTR('|'||l_bu||'|', '|'||COALESCE(kt.bun, kp.bun)||'|') > 0)
         AND (l_approp  IS NULL OR INSTR('|'||l_approp||'|', '|'||kt.app||'|') > 0)
         AND (l_program IS NULL OR INSTR('|'||l_program||'|', '|'||kt.prg||'|') > 0)
         AND (l_cc     IS NULL OR (INSTR(l_cc,'|') = 0 AND COALESCE(kt.cc, kp.cc) LIKE '%'||l_cc||'%')
                               OR INSTR('|'||l_cc||'|', '|'||COALESCE(kt.cc, kp.cc)||'|') > 0)
         AND (l_proj   IS NULL OR (INSTR(l_proj,'|') = 0 AND UPPER(f.project_number||' '||COALESCE(kt.pn, kp.pn)) LIKE '%'||UPPER(l_proj)||'%')
                               OR INSTR('|'||l_proj||'|', '|'||f.project_number||'|') > 0)
         AND (l_task   IS NULL OR UPPER(f.task_number) LIKE '%'||UPPER(l_task)||'%')
         AND (l_etype  IS NULL OR UPPER(f.expenditure_type) LIKE '%'||UPPER(l_etype)||'%')
         AND (l_search IS NULL OR UPPER(f.project_number||' '||COALESCE(kt.pn, kp.pn)||' '||f.task_number||' '
                                       ||COALESCE(kt.dep, kp.dep)||' '||COALESCE(kt.cc, kp.cc)||' '||f.expenditure_type) LIKE '%'||UPPER(l_search)||'%')
    ) g
    GROUP BY g.gsec, g.gcc
    ORDER BY g.gsec NULLS LAST, g.gcc NULLS LAST
  ) LOOP
    n := n + 1;
    SELECT COUNT(*),
           LISTAGG('['||c.accounting_period||'] '||c.created_by||': '||c.comment_text,
                   CHR(10) ON OVERFLOW TRUNCATE)
             WITHIN GROUP (ORDER BY c.created_at DESC)
      INTO l_cmtn, l_cmtt
      FROM prod.dct_gl_butil_comment c
     WHERE c.status = 'ACTIVE' AND c.budget_year = l_year
       AND c.entity_level = CASE WHEN l_level = 'dept' THEN 'COST_CENTER' ELSE 'SECTOR' END
       AND c.entity_key = CASE WHEN l_level = 'dept' THEN r.gcc ELSE r.gsec END
       AND (l_period IS NULL OR c.accounting_period = l_period);
    l_act := r.ap + r.grn + CASE WHEN l_pcash = 'Y' THEN r.pcash ELSE 0 END;
    APEX_JSON.open_object;
    APEX_JSON.write('sector', NVL(r.gsec,''));
    IF l_level = 'dept' THEN
      APEX_JSON.write('costCentre', NVL(r.gcc,''));
      APEX_JSON.write('department', NVL(r.gdept,''));
    END IF;
    APEX_JSON.write('lines', r.lines);
    APEX_JSON.write('budget', r.bud);
    APEX_JSON.write('budgetAnnual', r.buda);
    -- vs Budget (v1.96.0): group Total Actual vs the group ADJUSTED ANNUAL
    -- budget (user rule 2026-08-31: Annual always) -- same bands as the line grain
    IF ABS(r.buda) > 0.005 THEN
      APEX_JSON.write('budUtilPct', ROUND(100*l_act/r.buda,1));
      APEX_JSON.write('budVariance', ROUND(l_act - r.buda,2));
      APEX_JSON.write('budState',
        CASE WHEN 100*l_act/r.buda > l_tbo THEN 'OVER'
             WHEN 100*l_act/r.buda >= l_tbn THEN 'NEAR' ELSE 'OK' END);
    ELSE
      APEX_JSON.write('budState', CASE WHEN l_act > 0.005 THEN 'OVER' ELSE 'NOBUDGET' END);
    END IF;
    APEX_JSON.write('actualAp', r.ap);
    APEX_JSON.write('actualGrn', r.grn);
    APEX_JSON.write('procash', r.pcash);
    APEX_JSON.write('commitmentPr', r.pr);
    APEX_JSON.write('obligationPo', r.po);
    APEX_JSON.write('fundAvailable', r.fund);
    APEX_JSON.write('planApprovedAnnual', r.pfa);
    APEX_JSON.write('planApprovedYtd', r.pfay);
    APEX_JSON.write('planRevisedAnnual', r.pfr);
    APEX_JSON.write('planRevisedYtd', r.pfry);
    APEX_JSON.write('planEffYtd', r.pfe_y);
    APEX_JSON.write('planEffAnnual', r.pfe_a);
    APEX_JSON.write('planExtra', r.plan_extra);
    APEX_JSON.write('planOnly', CASE WHEN r.lines = 0 THEN 'Y' ELSE 'N' END);
    IF r.pfe_y > 0.005 THEN
      APEX_JSON.write('planExecPct', ROUND(100*l_act/r.pfe_y,1));
      APEX_JSON.write('planVariance', ROUND(l_act - r.pfe_y,2));
      APEX_JSON.write('planExecState',
        CASE WHEN 100*l_act/r.pfe_y < l_thx1 THEN 'BELOW'
             WHEN 100*l_act/r.pfe_y > l_thx2 THEN 'AHEAD' ELSE 'WITHIN' END);
    ELSE
      APEX_JSON.write('planExecState', 'NOPLAN');
    END IF;
    IF r.pfe_a > 0.005 THEN
      IF ABS(r.buda) > 0.005 THEN
        APEX_JSON.write('planCovPct', ROUND(100*r.pfe_a/r.buda,1));
        APEX_JSON.write('planCovState',
          CASE WHEN 100*r.pfe_a/r.buda < l_thc1 THEN 'UNDER'
               WHEN 100*r.pfe_a/r.buda > l_thc2 THEN 'OVER' ELSE 'FULL' END);
      ELSE
        APEX_JSON.write('planCovState', 'OVER');
      END IF;
    ELSE
      APEX_JSON.write('planCovState', 'NONE');
    END IF;
    APEX_JSON.write('costAdj', r.cadj);
    APEX_JSON.write('hasAdj', CASE WHEN r.cadj_n > 0 THEN 'Y' ELSE 'N' END);
    APEX_JSON.write('overrideBudget', r.ovr_b);
    APEX_JSON.write('overrideBudgetAnnual', r.ovr_ba);
    APEX_JSON.write('overrideLines', r.ovr_n);
    APEX_JSON.write('cmtCount', l_cmtn);
    APEX_JSON.write('hasCmt', CASE WHEN l_cmtn > 0 THEN 'Y' ELSE 'N' END);
    IF l_cmtn > 0 THEN APEX_JSON.write('commentsText', l_cmtt); END IF;
    APEX_JSON.close_object;
    t_ln := t_ln + r.lines; t_bud := t_bud + r.bud; t_buda := t_buda + r.buda;
    t_ap := t_ap + r.ap; t_grn := t_grn + r.grn; t_pc := t_pc + r.pcash;
    t_pr := t_pr + r.pr; t_po := t_po + r.po; t_fund := t_fund + r.fund;
    t_pfa := t_pfa + r.pfa; t_pfay := t_pfay + r.pfay; t_pfr := t_pfr + r.pfr; t_pfry := t_pfry + r.pfry;
    t_pfey := t_pfey + r.pfe_y; t_pfea := t_pfea + r.pfe_a; t_px := t_px + r.plan_extra;
    t_cadj := t_cadj + r.cadj; t_cmt := t_cmt + l_cmtn;
    IF r.lines = 0 THEN t_ponly := t_ponly + 1; END IF;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_object('totals');
  APEX_JSON.write('groups', n);
  APEX_JSON.write('lines', t_ln);
  APEX_JSON.write('budget', t_bud);
  APEX_JSON.write('budgetAnnual', t_buda);
  APEX_JSON.write('actualAp', t_ap);
  APEX_JSON.write('actualGrn', t_grn);
  APEX_JSON.write('procash', t_pc);
  APEX_JSON.write('commitmentPr', t_pr);
  APEX_JSON.write('obligationPo', t_po);
  APEX_JSON.write('fundAvailable', t_fund);
  APEX_JSON.write('planApprovedAnnual', t_pfa);
  APEX_JSON.write('planApprovedYtd', t_pfay);
  APEX_JSON.write('planRevisedAnnual', t_pfr);
  APEX_JSON.write('planRevisedYtd', t_pfry);
  APEX_JSON.write('planEffYtd', t_pfey);
  APEX_JSON.write('planEffAnnual', t_pfea);
  APEX_JSON.write('planExtra', t_px);
  APEX_JSON.write('planOnlyGroups', t_ponly);
  APEX_JSON.write('costAdj', t_cadj);
  APEX_JSON.write('cmtCount', t_cmt);
  APEX_JSON.close_object;
  APEX_JSON.close_object;
  dct_gl_class_pkg.clear_butil_end;
  dct_gl_class_pkg.clear_butil_ovr;
EXCEPTION WHEN OTHERS THEN
  dct_gl_class_pkg.clear_butil_end; dct_gl_class_pkg.clear_butil_ovr;
  dct_rest.err(500, SQLERRM);
END;!', '[COLON]', CHR(58)));
    COMMIT;
END setup_gl_butil_agg;
/

BEGIN setup_gl_butil_agg; END;
/
DROP PROCEDURE setup_gl_butil_agg;

PROMPT === verification ===
SELECT LENGTH(h.source) AS handler_chars,
       CASE WHEN INSTR(h.source, 'dct_butil_key_cache') > 0 THEN 'PLAN LEG WIRED' ELSE 'MISSING' END AS s1,
       CASE WHEN INSTR(h.source, 'planOnly') > 0 THEN 'PLANONLY WIRED' ELSE 'MISSING' END AS s2,
       CASE WHEN INSTR(h.source, 'budUtilPct') > 0 THEN 'VSBUDGET WIRED' ELSE 'MISSING' END AS s4,
       CASE WHEN INSTR(h.source, 'l_secok') > 0 THEN 'SECSCOPE KEPT' ELSE 'MISSING' END AS s3
  FROM user_ords_handlers h
  JOIN user_ords_templates t ON t.id = h.template_id
  JOIN user_ords_modules m ON m.id = t.module_id
 WHERE m.name = 'gl.rest' AND t.uri_template = 'butil/agg' AND h.method = 'GET';
