-- =============================================================================
-- Budget Utilization -- Procash + Costing Adjustments (ADDITIVE, DEFINE_HANDLER
-- only)
-- File    : 21_butil_procash.sql       App 210 / GL        2026-08-17 / 2026-08-22
-- Adds to : gl.rest -- redefines ONLY the GET butil handler
-- Run     : sql -name prod_mcp @21_butil_procash.sql   (fresh session, as ADMIN)
-- Needs   : final apps/AP/db/13_procash_butil_view.sql AND db/v2/124 deployed
--           first
-- IMPORTANT: 05_gl_ords.sql rebuilds gl.rest from scratch -- the GL post-05
--           re-run list is now 07..30.
-- Needs   : db/v2/126 (DCT_PROJECT_CF_BUTIL_V) deployed first since 2026-08-26.
--
-- WHY: procash records money that has already left the bank through the bank
-- portal but has NOT reached Fusion as a payable invoice, so no AP, GRN, PR or
-- PO figure sees it. Between the payment and the invoice that spend is
-- invisible on Budget Utilization -- which is exactly the window a budget owner
-- can overspend in.
--
-- NEW PARAMETER procash=Y ("Include Procash", user decision 2026-08-17):
--   off (default) -- the procash figure is REPORTED but changes nothing, so
--                    Fund Available keeps the definition every book, register
--                    and reconciliation already quotes.
--   on            -- Actual counts procash too and Fund Available is reduced
--                    by it (fund - procash).
-- Either way the response carries `procash`, `procashCount`,
-- `fundAvailableExProcash` and `procashUnmapped`, so the page can show the
-- figure and the adjustment side by side.
--
-- procashUnmapped = live procash coded to a GL combination rather than to a
-- project, task and expenditure type. It cannot sit on a budget line, so it is
-- reported separately instead of being silently dropped.
--
-- The reports (BUDGET_UTIL_BOOK / BUDGET_UTIL_REGISTER) are deliberately NOT
-- changed here: their figures stay on the published definition of Fund
-- Available until that change is asked for explicitly.
--
-- NEW PARAMETER costadj (2026-08-22, default Y -- "Include Cost Adjustment"):
-- Projects Costing Adjustments (db/v2/124, DCT_PA_COST_ADJ) are manual signed
-- cost lines (plus/minus AED) on a budget line, optionally re-allocating a
-- mis-coded AP invoice distribution, plus an optional signed BUDGET_OVERRIDE.
-- Only APPROVED rows count (via DCT_PA_COST_ADJ_BUTIL_V, BUTIL_END-aware).
--   on (default) -- rows and totals ship budget / budgetAnnual / actualAp /
--                   fundAvailable ALREADY adjusted (Actual +adj, Budget +ovr,
--                   Fund +ovr-adj), so the KPI band, CSV and negFund band all
--                   follow with no client math.
--   off          -- published figures; the components are still reported.
-- Either way each row carries costAdj / costAdjOvr / costAdjOvrAnnual /
-- hasAdj and totals carry costAdj / costAdjCount / costAdjOvr /
-- costAdjOvrAnnual, so the page can star adjusted lines and show the figure.
--
-- COMMENTS flag (2026-08-23, db/v2/125 + GL/db/26): every row also carries
-- hasCmt Y/N + cmtCount (ACTIVE BUTIL_LINE-level comments on that line for the
-- selected accounting period -- ALL periods of the year when period is empty),
-- totals carry cmtCount, and the response echoes commentsEnabled='Y' so the
-- page only renders the (**) marker / Comments column against a server that
-- ships the flag. The join is an INLINE aggregate (per-period grain) -- a bare
-- view join would fan out rows on a full-year run.
--
-- NEW PARAMETER cmtdisp (2026-08-23 feedback round, default NONE -- the
-- "Display Comments" page LOV): NONE | PERIOD (selected period only) | ALL.
-- When not NONE each row also ships commentsText -- the line's ACTIVE comments
-- (roots + replies) as '[MM-YYYY] user: text' lines, newest first, scoped to
-- the page period (PERIOD) or the whole year (ALL); the response echoes
-- commentsDisplay. LISTAGG ... ON OVERFLOW TRUNCATE guards the 32K cap.
--
-- PLAN BALANCES (2026-08-26, db/v2/126): every row and the totals also carry
-- the user-uploaded expenditure plan (DCT_PROJECT_CASHFLOW, GL Cashflow tab)
-- as planApprovedAnnual / planApprovedYtd / planRevisedAnnual / planRevisedYtd
-- via DCT_PROJECT_CF_BUTIL_V -- line-grain 1:1 join, BUTIL_END-aware YTD
-- (full year => YTD = Annual). Rows add hasPlan Y/N (drill gate); totals add
-- planUnmatched = plan lines with NO butil line (checked against the db/v2/120
-- key cache) so an upload keyed off a dead line is reported, never dropped.
-- Purely additive display -- no parameter, no figure changes.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_butil_procash AS
    c_mod CONSTANT VARCHAR2(30) := 'gl.rest';
BEGIN
    ORDS.DEFINE_HANDLER(
        p_module_name => c_mod,
        p_pattern     => 'butil',
        p_method      => 'GET',
        p_source_type => ORDS.source_type_plsql,
        p_source      => REPLACE(q'!DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_uid NUMBER := dct_auth.get_user_id(l_user);
  l_secok NUMBER := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
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
  -- nocc=Y -> ONLY the data-quality rows: budget lines (annual budget <> 0)
  -- with NO cost centre. Feeds the red alert band's drill drawer.
  l_nocc   VARCHAR2(4)   := [COLON]nocc;
  -- ovr=Y -> "Select to include Budget Override": GL_CTX.BUTIL_OVR makes the
  -- view ADD the signed budget change to the annual AND YTD budget per period
  -- row (db/v2/106 Excel workbook / GL drawer).
  l_ovr    VARCHAR2(4)   := UPPER(NVL([COLON]ovr,'N'));
  -- procash=Y -> "Include Procash": money already pushed through the bank portal
  -- that has NOT reached Fusion as a payable invoice yet. It is always reported
  -- as its own figure; with the flag on it is ADDED to Actual and SUBTRACTED
  -- from Fund Available. A procash transaction leaves the view the moment its
  -- invoice is linked, so it is never counted twice against the AP actual.
  l_pcash  VARCHAR2(4)   := UPPER(NVL([COLON]procash,'N'));
  -- costadj=Y (DEFAULT Y) -> "Include Cost Adjustment": APPROVED Projects
  -- Costing Adjustment rows (db/v2/124) fold into the figures -- Actual
  -- +amount, Budget +override (annual AND YTD), Fund +override-amount.
  l_cadj   VARCHAR2(4)   := UPPER(NVL([COLON]costadj,'Y'));
  -- cmtdisp: NONE (default) / PERIOD / ALL -- "Display Comments" report LOV.
  -- VARCHAR2(20), never (10): an undersized DECLARE = uncatchable 555.
  l_cmtd   VARCHAR2(20)  := UPPER(NVL([COLON]cmtdisp,'NONE'));
  l_end    DATE;
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit  DEFAULT NULL ON CONVERSION ERROR), 100), 5000);
  l_offset NUMBER := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_total  NUMBER;
  l_misscc NUMBER; t_misscc NUMBER;
  l_negcnt NUMBER; t_negfund NUMBER;
  t_bud NUMBER; t_buda NUMBER; t_ap NUMBER; t_grn NUMBER; t_pr NUMBER; t_po NUMBER; t_fund NUMBER;
  t_ovr NUMBER; t_ovra NUMBER; t_ovrn NUMBER;
  t_pcash NUMBER := 0; t_pcnt NUMBER := 0; t_punmap NUMBER := 0;
  t_cadj NUMBER := 0; t_cacnt NUMBER := 0; t_covr NUMBER := 0; t_covra NUMBER := 0;
  t_cmt NUMBER := 0;
  t_pfa NUMBER := 0; t_pfay NUMBER := 0; t_pfr NUMBER := 0; t_pfry NUMBER := 0; t_pfun NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  IF l_cmtd NOT IN ('PERIOD','ALL') THEN l_cmtd := 'NONE'; END IF;
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
  dct_gl_class_pkg.set_butil_ovr(l_ovr);
  SELECT COUNT(*), NVL(SUM(budget),0), NVL(SUM(budget_annual),0), NVL(SUM(actual_ap),0), NVL(SUM(actual_grn),0),
         NVL(SUM(commitment_pr),0), NVL(SUM(obligation_po),0), NVL(SUM(fund_available),0),
         COUNT(CASE WHEN v.cost_centre IS NULL AND NVL(v.budget_annual,0) <> 0 THEN 1 END),
         NVL(SUM(CASE WHEN v.cost_centre IS NULL AND NVL(v.budget_annual,0) <> 0 THEN v.budget_annual END),0),
         NVL(SUM(override_budget),0), NVL(SUM(override_budget_annual),0), NVL(SUM(override_lines),0),
         NVL(SUM(pc.procash_aed),0), NVL(SUM(pc.procash_count),0),
         NVL(SUM(ca.cost_adj_aed),0), NVL(SUM(ca.adj_count),0),
         NVL(SUM(ca.budget_ovr_aed),0), NVL(SUM(ca.budget_ovr_annual),0),
         COUNT(CASE WHEN (v.fund_available - CASE WHEN l_pcash = 'Y' THEN NVL(pc.procash_aed,0) ELSE 0 END
                          + CASE WHEN l_cadj = 'Y' THEN NVL(ca.budget_ovr_aed,0) - NVL(ca.cost_adj_aed,0) ELSE 0 END) < -0.005 THEN 1 END),
         NVL(SUM(CASE WHEN (v.fund_available - CASE WHEN l_pcash = 'Y' THEN NVL(pc.procash_aed,0) ELSE 0 END
                            + CASE WHEN l_cadj = 'Y' THEN NVL(ca.budget_ovr_aed,0) - NVL(ca.cost_adj_aed,0) ELSE 0 END) < -0.005
                      THEN (v.fund_available - CASE WHEN l_pcash = 'Y' THEN NVL(pc.procash_aed,0) ELSE 0 END
                            + CASE WHEN l_cadj = 'Y' THEN NVL(ca.budget_ovr_aed,0) - NVL(ca.cost_adj_aed,0) ELSE 0 END) END),0),
         NVL(SUM(cm.cmt_n),0),
         NVL(SUM(pf.plan_appr_annual),0), NVL(SUM(pf.plan_appr_ytd),0),
         NVL(SUM(pf.plan_rev_annual),0), NVL(SUM(pf.plan_rev_ytd),0)
    INTO l_total, t_bud, t_buda, t_ap, t_grn, t_pr, t_po, t_fund, l_misscc, t_misscc,
         t_ovr, t_ovra, t_ovrn, t_pcash, t_pcnt, t_cadj, t_cacnt, t_covr, t_covra, l_negcnt, t_negfund,
         t_cmt, t_pfa, t_pfay, t_pfr, t_pfry
    FROM prod.dct_budget_utilization_v v
      LEFT JOIN prod.dct_ap_procash_butil_v pc
             ON pc.budget_year      = v.budget_year
            AND pc.project_number   = v.project_number
            AND pc.task_number      = v.task_number
            AND pc.expenditure_type = v.expenditure_type
      LEFT JOIN prod.dct_pa_cost_adj_butil_v ca
             ON ca.budget_year      = v.budget_year
            AND ca.project_number   = v.project_number
            AND ca.task_number      = v.task_number
            AND ca.expenditure_type = v.expenditure_type
      LEFT JOIN (SELECT budget_year, project_number, task_number, expenditure_type,
                        SUM(cmt_count) AS cmt_n
                   FROM prod.dct_gl_butil_cmt_v
                  WHERE (l_period IS NULL OR accounting_period = l_period)
                  GROUP BY budget_year, project_number, task_number, expenditure_type) cm
             ON cm.budget_year      = v.budget_year
            AND cm.project_number   = v.project_number
            AND cm.task_number      = v.task_number
            AND cm.expenditure_type = v.expenditure_type
      LEFT JOIN prod.dct_project_cf_butil_v pf
             ON pf.budget_year      = v.budget_year
            AND pf.project_number   = v.project_number
            AND pf.task_number      = v.task_number
            AND pf.expenditure_type = v.expenditure_type
   WHERE v.budget_year = l_year
     AND (l_nocc IS NULL OR (v.cost_centre IS NULL AND NVL(v.budget_annual,0) <> 0))
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
                                   ||v.department||' '||v.cost_centre||' '||v.expenditure_type) LIKE '%'||UPPER(l_search)||'%');
  SELECT NVL(SUM(u.procash_aed),0) INTO t_punmap
    FROM prod.dct_ap_procash_unmapped_v u
   WHERE u.budget_year = l_year
     AND (l_bu IS NULL OR INSTR('|'||l_bu||'|', '|'||u.business_unit||'|') > 0);
  -- plan uploaded against a line that no longer exists on butil: reported,
  -- never silently dropped (key set = the hourly db/v2/120 cache)
  SELECT NVL(SUM(f.plan_appr_annual + f.plan_rev_annual),0) INTO t_pfun
    FROM prod.dct_project_cf_butil_v f
   WHERE f.budget_year = l_year
     AND NOT EXISTS (SELECT 1 FROM prod.dct_butil_key_cache k
                      WHERE k.budget_year      = f.budget_year
                        AND k.project_number   = f.project_number
                        AND k.task_number      = f.task_number
                        AND k.expenditure_type = f.expenditure_type);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('total', l_total); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.write('year', l_year);
  -- data-quality flag: budget lines (annual budget <> 0) with NO cost centre in
  -- the filtered set -> drives the red alert band on the Budget Utilization page
  APEX_JSON.write('missingCc', l_misscc);
  APEX_JSON.write('missingCcBudget', t_misscc);
  -- over-budget flag: lines whose (effective) Fund Available is NEGATIVE in the
  -- filtered set -> drives the over-budget warning band above the Overview region
  APEX_JSON.write('negFund', l_negcnt);
  APEX_JSON.write('negFundTotal', t_negfund);
  IF l_period IS NOT NULL THEN APEX_JSON.write('period', l_period); END IF;
  APEX_JSON.write('considerOverride', l_ovr);
  APEX_JSON.write('includeProcash', l_pcash);
  APEX_JSON.write('includeCostAdj', l_cadj);
  APEX_JSON.write('commentsEnabled', 'Y');
  APEX_JSON.write('commentsDisplay', l_cmtd);
  APEX_JSON.open_object('totals');
  APEX_JSON.write('budget', CASE WHEN l_cadj = 'Y' THEN t_bud + t_covr ELSE t_bud END);
  APEX_JSON.write('budgetAnnual', CASE WHEN l_cadj = 'Y' THEN t_buda + t_covra ELSE t_buda END);
  APEX_JSON.write('actualAp', CASE WHEN l_cadj = 'Y' THEN t_ap + t_cadj ELSE t_ap END);
  APEX_JSON.write('actualGrn', t_grn);
  APEX_JSON.write('commitmentPr', t_pr); APEX_JSON.write('obligationPo', t_po);
  APEX_JSON.write('fundAvailable',
                  t_fund - CASE WHEN l_pcash = 'Y' THEN t_pcash ELSE 0 END
                         + CASE WHEN l_cadj = 'Y' THEN t_covr - t_cadj ELSE 0 END);
  APEX_JSON.write('fundAvailableExProcash',
                  t_fund + CASE WHEN l_cadj = 'Y' THEN t_covr - t_cadj ELSE 0 END);
  APEX_JSON.write('procash', t_pcash);
  APEX_JSON.write('procashCount', t_pcnt);
  APEX_JSON.write('procashUnmapped', t_punmap);
  APEX_JSON.write('costAdj', t_cadj);
  APEX_JSON.write('costAdjCount', t_cacnt);
  APEX_JSON.write('costAdjOvr', t_covr);
  APEX_JSON.write('costAdjOvrAnnual', t_covra);
  APEX_JSON.write('planApprovedAnnual', t_pfa);
  APEX_JSON.write('planApprovedYtd', t_pfay);
  APEX_JSON.write('planRevisedAnnual', t_pfr);
  APEX_JSON.write('planRevisedYtd', t_pfry);
  APEX_JSON.write('planUnmatched', t_pfun);
  APEX_JSON.write('cmtCount', t_cmt);
  APEX_JSON.write('overrideBudget', t_ovr); APEX_JSON.write('overrideBudgetAnnual', t_ovra);
  APEX_JSON.write('overrideLines', t_ovrn);
  APEX_JSON.close_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT v.*, NVL(pc.procash_aed,0) AS procash,
           NVL(ca.cost_adj_aed,0) AS cost_adj, NVL(ca.budget_ovr_aed,0) AS cadj_ovr,
           NVL(ca.budget_ovr_annual,0) AS cadj_ovr_annual, NVL(ca.adj_count,0) AS cadj_n,
           NVL(cm.cmt_n,0) AS cmt_n, cm.cmt_txt,
           NVL(pf.plan_appr_annual,0) AS plan_appr_annual, NVL(pf.plan_appr_ytd,0) AS plan_appr_ytd,
           NVL(pf.plan_rev_annual,0) AS plan_rev_annual, NVL(pf.plan_rev_ytd,0) AS plan_rev_ytd,
           NVL(pf.cf_rows,0) AS cf_rows
      FROM prod.dct_budget_utilization_v v
      LEFT JOIN prod.dct_ap_procash_butil_v pc
             ON pc.budget_year      = v.budget_year
            AND pc.project_number   = v.project_number
            AND pc.task_number      = v.task_number
            AND pc.expenditure_type = v.expenditure_type
      LEFT JOIN prod.dct_pa_cost_adj_butil_v ca
             ON ca.budget_year      = v.budget_year
            AND ca.project_number   = v.project_number
            AND ca.task_number      = v.task_number
            AND ca.expenditure_type = v.expenditure_type
      LEFT JOIN (SELECT budget_year, project_number, task_number, expenditure_type,
                        COUNT(CASE WHEN (l_period IS NULL OR accounting_period = l_period) THEN 1 END) AS cmt_n,
                        LISTAGG(CASE WHEN l_cmtd = 'ALL'
                                       OR (l_cmtd = 'PERIOD' AND (l_period IS NULL OR accounting_period = l_period))
                                     THEN '[' || accounting_period || '] ' || created_by || ': ' || comment_text END,
                                CHR(10) ON OVERFLOW TRUNCATE)
                          WITHIN GROUP (ORDER BY created_at DESC) AS cmt_txt
                   FROM prod.dct_gl_butil_comment
                  WHERE status = 'ACTIVE' AND entity_level = 'BUTIL_LINE'
                  GROUP BY budget_year, project_number, task_number, expenditure_type) cm
             ON cm.budget_year      = v.budget_year
            AND cm.project_number   = v.project_number
            AND cm.task_number      = v.task_number
            AND cm.expenditure_type = v.expenditure_type
      LEFT JOIN prod.dct_project_cf_butil_v pf
             ON pf.budget_year      = v.budget_year
            AND pf.project_number   = v.project_number
            AND pf.task_number      = v.task_number
            AND pf.expenditure_type = v.expenditure_type
    WHERE v.budget_year = l_year
      AND (l_nocc IS NULL OR (v.cost_centre IS NULL AND NVL(v.budget_annual,0) <> 0))
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
    ORDER BY v.project_type, v.project_number, v.task_number, v.expenditure_type
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('projectType', NVL(r.project_type,''));
    APEX_JSON.write('sector', NVL(r.sector,''));
    APEX_JSON.write('department', NVL(r.department,''));
    APEX_JSON.write('organization', NVL(r.task_organization,''));
    APEX_JSON.write('costCentre', NVL(r.cost_centre,''));
    APEX_JSON.write('projectNumber', NVL(r.project_number,''));
    APEX_JSON.write('projectName', NVL(r.project_name,''));
    APEX_JSON.write('taskNumber', NVL(r.task_number,''));
    APEX_JSON.write('glAccount', NVL(r.gl_account,''));
    APEX_JSON.write('appropriation', NVL(r.appropriation,''));
    APEX_JSON.write('chapter', NVL(r.chapter,''));
    APEX_JSON.write('program', NVL(r.program,''));
    APEX_JSON.write('expenditureType', NVL(r.expenditure_type,''));
    APEX_JSON.write('budget', CASE WHEN l_cadj = 'Y' THEN r.budget + r.cadj_ovr ELSE r.budget END);
    APEX_JSON.write('budgetAnnual', CASE WHEN l_cadj = 'Y' THEN r.budget_annual + r.cadj_ovr_annual ELSE r.budget_annual END);
    APEX_JSON.write('actualAp', CASE WHEN l_cadj = 'Y' THEN r.actual_ap + r.cost_adj ELSE r.actual_ap END);
    APEX_JSON.write('actualGrn', r.actual_grn);
    APEX_JSON.write('commitmentPr', r.commitment_pr);
    APEX_JSON.write('obligationPo', r.obligation_po);
    APEX_JSON.write('fundAvailable',
                    r.fund_available
                    - CASE WHEN l_pcash = 'Y' THEN r.procash ELSE 0 END
                    + CASE WHEN l_cadj = 'Y' THEN r.cadj_ovr - r.cost_adj ELSE 0 END);
    APEX_JSON.write('procash', r.procash);
    APEX_JSON.write('planApprovedAnnual', r.plan_appr_annual);
    APEX_JSON.write('planApprovedYtd', r.plan_appr_ytd);
    APEX_JSON.write('planRevisedAnnual', r.plan_rev_annual);
    APEX_JSON.write('planRevisedYtd', r.plan_rev_ytd);
    APEX_JSON.write('hasPlan', CASE WHEN r.cf_rows > 0 THEN 'Y' ELSE 'N' END);
    APEX_JSON.write('costAdj', r.cost_adj);
    APEX_JSON.write('costAdjOvr', r.cadj_ovr);
    APEX_JSON.write('costAdjOvrAnnual', r.cadj_ovr_annual);
    APEX_JSON.write('hasAdj', CASE WHEN r.cadj_n > 0 THEN 'Y' ELSE 'N' END);
    APEX_JSON.write('cmtCount', r.cmt_n);
    APEX_JSON.write('hasCmt', CASE WHEN r.cmt_n > 0 THEN 'Y' ELSE 'N' END);
    IF l_cmtd <> 'NONE' THEN APEX_JSON.write('commentsText', r.cmt_txt); END IF;
    APEX_JSON.write('overrideBudget', r.override_budget);
    APEX_JSON.write('overrideBudgetAnnual', r.override_budget_annual);
    APEX_JSON.write('overrideLines', r.override_lines);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
  dct_gl_class_pkg.clear_butil_end;
  dct_gl_class_pkg.clear_butil_ovr;
EXCEPTION WHEN OTHERS THEN
  dct_gl_class_pkg.clear_butil_end; dct_gl_class_pkg.clear_butil_ovr;
  dct_rest.err(500, SQLERRM);
END;!', '[COLON]', CHR(58)));
    COMMIT;
END setup_gl_butil_procash;
/

BEGIN setup_gl_butil_procash; END;
/
DROP PROCEDURE setup_gl_butil_procash;

PROMPT === verification ===
SELECT LENGTH(h.source) AS handler_chars,
       CASE WHEN INSTR(h.source, 'dct_ap_procash_butil_v') > 0 THEN 'PROCASH WIRED' ELSE 'MISSING' END AS state,
       CASE WHEN INSTR(h.source, 'dct_pa_cost_adj_butil_v') > 0 THEN 'COSTADJ WIRED' ELSE 'MISSING' END AS state2,
       CASE WHEN INSTR(h.source, 'dct_gl_butil_cmt_v') > 0 THEN 'CMT WIRED' ELSE 'MISSING' END AS state3,
       CASE WHEN INSTR(h.source, 'dct_project_cf_butil_v') > 0 THEN 'PLAN WIRED' ELSE 'MISSING' END AS state4
  FROM user_ords_handlers h
  JOIN user_ords_templates t ON t.id = h.template_id
  JOIN user_ords_modules m ON m.id = t.module_id
 WHERE m.name = 'gl.rest' AND t.uri_template = 'butil' AND h.method = 'GET';
