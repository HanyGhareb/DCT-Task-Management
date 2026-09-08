-- =============================================================================
-- General Ledger (App 210) -- Financial Performance Report / Budget Overview
-- File    : 37_gl_fmr_ords.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp @37_gl_fmr_ords.sql  (fresh session, ADMIN)
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            the GL post-05 re-run list is now 07..37.
-- Purpose : replicates the corporate FMR_Dashboard.pdf "Budget Overview"
--           pages (Entity Level + Sector Level) as a live GL page, sourced
--           from the same data the "Budget vs Actual" page already uses
--           (prod.dct_budget_actual_period_v) plus TWO plan sources.
--
-- v2 2026-09-01 (user feedback after go-live):
--  (1) Budget AND Actual must be BUDGET GROUP = 1 ONLY, platform-wide rule
--      ("Budget Group defaults to '1' everywhere", db/v2 GL notes). Group 8
--      is 0 in this data so it wasn't the visible symptom, but groups 3/5
--      (~738M, chapters 4/5 Subsidy/Aids) were being summed in unfiltered --
--      fixed via REGEXP_SUBSTR(cc_string,'[^.]+',1,4)='1' (position 4 of the
--      canonical entity.program.cc.BG.account.es.appr.ic.f1.f2 string).
--  (2) Same regex trick REPLACES the dct_gl_coa_snap LEFT JOIN for entity
--      classification (position 6 = entity_specific_code): the v1 join
--      produced a spurious ~9.18bn "UNCLASSIFIED" entity bucket that was
--      really just BG=1/appropriation='000000' DCT budget with no row in
--      the transaction-derived snapshot yet -- extracting the segment
--      straight from cc_string (always present, no coverage gap) resolves
--      every row to DCT/ALC/Museums/Masterpieces, so the UNCLASSIFIED
--      ENTITY bucket is retired. The UNCLASSIFIED **type/trend** bucket
--      stays -- appropriation='000000' genuinely has no chapter, that is a
--      real (if unfortunate) data gap, not a join artifact.
--  (3) Plan now has TWO sources, matching the user's instruction "chapter 2
--      and 3 plan should come from project cashflow": Payroll (Chapter 1)
--      keeps reading prod.dct_gl_budget_cashflow (the Payroll Plan 2026
--      upload); Opex (Chapter 2) and Capex (Chapter 3) now read the SAME
--      already-populated project-grain plan the Budget Utilization page
--      uses -- prod.dct_budget_utilization_v (BUDGET_COMBINATION carries the
--      entity segment; CHAPTER is text 'Chapter 2'/'Chapter 3', a DIFFERENT
--      vocabulary from dct_budget_actual_period_v's CH2/CH3 codes) JOINed to
--      prod.dct_project_cf_butil_v (db/v2/126, PLAN_APPR_ANNUAL/YTD). YTD
--      requires prod.dct_gl_class_pkg.set_butil_end(<end of period>) first
--      (cleared before every return path) -- unset it defaults to full-year
--      (verified: without it PLAN_APPR_YTD = PLAN_APPR_ANNUAL). Entity split
--      on this leg comes from BUDGET_COMBINATION via the same regex (that
--      column is always Budget-Group '1' by construction, per its own
--      derivation rule -- no extra BG filter needed there). Sector split
--      joins dct_gl_class_value (class_type_code='SECTOR') on name_en =
--      dct_budget_utilization_v.sector (verified 0 unmatched names).
--      CWIP/Subsidy/Aids/Unclassified still have no plan source at all --
--      hasPlan='N', never fabricated.
--
-- Endpoints:
--   GET /gl/fmr/entity?period=MM-YYYY
--       -> { period, year, overall{...}, entities[DCT|ALC|MUSEUMS|MASTERPIECES],
--            trend[PAYROLL|OPEX|CAPEX] }
--   v3 2026-09-01 (user): scope narrowed to Chapters 1/2/3 ONLY, everywhere --
--   `p.chapter_code IN ('CH1','CH2','CH3')` added to overall/entities/sector
--   (bg=1 filter already handled CH4/5/6/NULL leakage into the totals, but
--   the user wants those chapters OUT of the dashboard entirely, not just
--   reported separately). trend[] dropped CWIP/Other/Unclassified (were
--   always 0 or out-of-scope anyway) -- 3 rows now, not 6.
--   GET /gl/fmr/sector?period=MM-YYYY&entity=DCT|ALC|...  (entity optional, pipe any-of)
--       -> { period, year, sectors[...] } sorted by actual-vs-plan% desc
--   GET /gl/fmr/notes?period=MM-YYYY
--       -> { period, items[{noteType,text,updatedBy,updatedAt}] }
--   PUT /gl/fmr/notes   body {period, noteType: CURRENT_VARIANCE|EXPECTED_VARIANCE, text}
-- Gates: reads = any valid session (matches GET /gl/actuals, which this page
--        extends); notes write = GL_MANAGE_DOF_NOTES (legacy role SYS_ADMIN,
--        the same privilege the DOF Reasons/Remarks notes already use).
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

DECLARE
  PROCEDURE ddl(p_sql CLOB, p_ign NUMBER DEFAULT NULL) IS
  BEGIN EXECUTE IMMEDIATE p_sql;
  EXCEPTION WHEN OTHERS THEN IF p_ign IS NULL OR SQLCODE <> p_ign THEN RAISE; END IF;
  END;
BEGIN
  ddl(q'~CREATE TABLE prod.dct_gl_fmr_note (
    note_id           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    budget_year       NUMBER NOT NULL,
    accounting_period VARCHAR2(7) NOT NULL,
    note_type         VARCHAR2(30) NOT NULL,
    note_text         VARCHAR2(2000),
    updated_by        VARCHAR2(100),
    updated_at        TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT ck_gl_fmrnote_type CHECK (note_type IN ('CURRENT_VARIANCE','EXPECTED_VARIANCE')),
    CONSTRAINT uq_gl_fmrnote UNIQUE (accounting_period, note_type)
  )~', -955);
END;
/

CREATE OR REPLACE PROCEDURE setup_gl_fmr_ords_tmp AS
    c_mod CONSTANT VARCHAR2(30) := 'gl.rest';
    PROCEDURE dt(p VARCHAR2) IS BEGIN ORDS.DEFINE_TEMPLATE(p_module_name=>c_mod, p_pattern=>REPLACE(p,'[COLON]',CHR(58))); END;
    PROCEDURE dh(p VARCHAR2, m VARCHAR2, s CLOB) IS BEGIN ORDS.DEFINE_HANDLER(p_module_name=>c_mod, p_pattern=>REPLACE(p,'[COLON]',CHR(58)), p_method=>m,
        p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(s,'[COLON]',CHR(58))); END;
BEGIN

  dt('fmr/entity');
  dh('fmr/entity','GET',q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_period VARCHAR2(7)   := [COLON]period;
  l_year   NUMBER;
  l_end    DATE;
  FUNCTION pct(p_num NUMBER, p_den NUMBER) RETURN NUMBER IS
  BEGIN
    IF p_den IS NULL OR p_den = 0 THEN RETURN NULL; END IF;
    RETURN ROUND(p_num * 1000 / p_den) / 10;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_period IS NULL THEN dct_rest.err(400,'period is required'); RETURN; END IF;
  l_year := TO_NUMBER(SUBSTR(l_period,4,4) DEFAULT NULL ON CONVERSION ERROR);
  IF l_year IS NULL THEN dct_rest.err(400,'period must be MM-YYYY'); RETURN; END IF;
  l_end := LAST_DAY(TO_DATE('01-'||l_period,'DD-MM-YYYY'));
  prod.dct_gl_class_pkg.set_butil_end(l_end);

  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('period', l_period); APEX_JSON.write('year', l_year);

  <<overall>>
  DECLARE
    t_bud NUMBER; t_act NUMBER; t_fun NUMBER;
    t_pay NUMBER; t_proj NUMBER; t_plan NUMBER; l_has_plan VARCHAR2(1);
  BEGIN
    SELECT NVL(SUM(p.budget_ytd),0), NVL(SUM(p.gl_actual_ytd),0), NVL(SUM(p.funds_available_ytd),0)
      INTO t_bud, t_act, t_fun
      FROM prod.dct_budget_actual_period_v p
     WHERE p.period_name = l_period AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '1'
       AND p.chapter_code IN ('CH1','CH2','CH3');
    SELECT SUM(c.cf_amount) INTO t_pay
      FROM prod.dct_gl_budget_cashflow c
     WHERE c.cf_type = 'APPROVED' AND c.budget_year = l_year AND c.budget_group_code = '1'
       AND TO_DATE(c.accounting_period,'MM-YYYY') <= TO_DATE(l_period,'MM-YYYY');
    SELECT SUM(p.plan_appr_ytd) INTO t_proj
      FROM prod.dct_budget_utilization_v b LEFT JOIN prod.dct_gl_coa_snap csb ON csb.cc_string = b.budget_combination
      JOIN prod.dct_project_cf_butil_v p
        ON p.budget_year = b.budget_year AND p.project_number = b.project_number
       AND p.task_number = b.task_number AND p.expenditure_type = b.expenditure_type
     WHERE b.budget_year = l_year AND b.chapter IN ('Chapter 2','Chapter 3');
    l_has_plan := CASE WHEN t_pay IS NOT NULL OR t_proj IS NOT NULL THEN 'Y' ELSE 'N' END;
    t_plan := NVL(t_pay,0) + NVL(t_proj,0);
    APEX_JSON.open_object('overall');
    APEX_JSON.write('budget', t_bud); APEX_JSON.write('actual', t_act);
    APEX_JSON.write('plan', t_plan);  APEX_JSON.write('hasPlan', l_has_plan);
    APEX_JSON.write('fundsAvailable', t_fun);
    IF pct(t_act,t_bud) IS NOT NULL THEN APEX_JSON.write('actualVsBudgetPct', pct(t_act,t_bud)); END IF;
    IF l_has_plan = 'Y' AND pct(t_act,t_plan) IS NOT NULL THEN APEX_JSON.write('actualVsPlanPct', pct(t_act,t_plan)); END IF;
    IF l_has_plan = 'Y' AND pct(t_plan,t_bud) IS NOT NULL THEN APEX_JSON.write('planVsBudgetPct', pct(t_plan,t_bud)); END IF;
    APEX_JSON.close_object;
  END overall;

  APEX_JSON.open_array('entities');
  FOR e IN (SELECT code, name FROM (
              SELECT v.value_code code, v.name_en name, v.display_order ord
                FROM prod.dct_gl_class_value v WHERE v.class_type_code = 'ENTITY' AND v.is_active = 'Y'
              UNION ALL
              SELECT 'UNCLASSIFIED', 'Unclassified', 9999 FROM dual
               WHERE EXISTS (SELECT 1 FROM prod.dct_budget_actual_period_v p
                              WHERE p.period_name = l_period AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '1'
                                AND p.chapter_code IN ('CH1','CH2','CH3') AND p.entity_class_code IS NULL
                                AND (p.budget_ytd <> 0 OR p.gl_actual_ytd <> 0)))
            ORDER BY ord) LOOP
    DECLARE
      t_bud NUMBER := 0; t_act NUMBER := 0; t_fun NUMBER := 0;
      t_pay NUMBER; t_proj NUMBER; t_plan NUMBER; l_has_plan VARCHAR2(1);
    BEGIN
      SELECT NVL(SUM(p.budget_ytd),0), NVL(SUM(p.gl_actual_ytd),0), NVL(SUM(p.funds_available_ytd),0)
        INTO t_bud, t_act, t_fun
        FROM prod.dct_budget_actual_period_v p
       WHERE p.period_name = l_period
         AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '1'
         AND p.chapter_code IN ('CH1','CH2','CH3')
         AND (NVL(p.entity_class_code,'UNCLASSIFIED')) = e.code;
      SELECT SUM(c.cf_amount) INTO t_pay
        FROM prod.dct_gl_budget_cashflow c
       WHERE c.cf_type = 'APPROVED' AND c.budget_year = l_year AND c.budget_group_code = '1'
         AND TO_DATE(c.accounting_period,'MM-YYYY') <= TO_DATE(l_period,'MM-YYYY')
         AND (NVL(prod.dct_gl_class_pkg.entity_of(c.cc_string, TRUNC(SYSDATE)),'UNCLASSIFIED')) = e.code;
      SELECT SUM(p.plan_appr_ytd) INTO t_proj
        FROM prod.dct_budget_utilization_v b LEFT JOIN prod.dct_gl_coa_snap csb ON csb.cc_string = b.budget_combination
        JOIN prod.dct_project_cf_butil_v p
          ON p.budget_year = b.budget_year AND p.project_number = b.project_number
         AND p.task_number = b.task_number AND p.expenditure_type = b.expenditure_type
       WHERE b.budget_year = l_year AND b.chapter IN ('Chapter 2','Chapter 3')
         AND (NVL(csb.entity_class_code,'UNCLASSIFIED')) = e.code;
      l_has_plan := CASE WHEN t_pay IS NOT NULL OR t_proj IS NOT NULL THEN 'Y' ELSE 'N' END;
      t_plan := NVL(t_pay,0) + NVL(t_proj,0);
      APEX_JSON.open_object;
      APEX_JSON.write('code', e.code); APEX_JSON.write('name', e.name);
      APEX_JSON.write('budget', t_bud); APEX_JSON.write('actual', t_act);
      APEX_JSON.write('plan', t_plan);  APEX_JSON.write('hasPlan', l_has_plan);
      APEX_JSON.write('fundsAvailable', t_fun);
      IF pct(t_act,t_bud) IS NOT NULL THEN APEX_JSON.write('actualVsBudgetPct', pct(t_act,t_bud)); END IF;
      IF l_has_plan = 'Y' AND pct(t_act,t_plan) IS NOT NULL THEN APEX_JSON.write('actualVsPlanPct', pct(t_act,t_plan)); END IF;
      APEX_JSON.close_object;
    END;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('trend');
  FOR y IN (SELECT 'PAYROLL' code, 'Payroll' name, 'CH1' chcode, CAST(NULL AS VARCHAR2(20)) chname FROM dual UNION ALL
            SELECT 'OPEX', 'Opex', 'CH2', 'Chapter 2' FROM dual UNION ALL
            SELECT 'CAPEX', 'Capex', 'CH3', 'Chapter 3' FROM dual) LOOP
    DECLARE
      t_bud NUMBER := 0; t_act NUMBER := 0;
      t_pay NUMBER; t_proj NUMBER; t_plan NUMBER; l_has_plan VARCHAR2(1);
    BEGIN
      SELECT NVL(SUM(p.budget_ytd),0), NVL(SUM(p.gl_actual_ytd),0)
        INTO t_bud, t_act
        FROM prod.dct_budget_actual_period_v p
       WHERE p.period_name = l_period
         AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '1'
         AND p.chapter_code = y.chcode;
      -- GL-cashflow plan leg applies to EVERY chapter now (Payroll upload +
      -- the MSS GL Plan 2026 upload, which carries BOTH Chapter 2 and
      -- Chapter 3 rows) -- filtered by this type's chapter via the view's
      -- chapter_code (the raw table has no chapter column).
      SELECT SUM(c.cf_amount) INTO t_pay
        FROM prod.dct_gl_cashflow_v c
       WHERE c.cf_type = 'APPROVED' AND c.budget_year = l_year AND c.budget_group_code = '1'
         AND TO_DATE(c.accounting_period,'MM-YYYY') <= TO_DATE(l_period,'MM-YYYY')
         AND c.chapter_code = y.chcode;
      IF y.chname IS NOT NULL THEN
        SELECT SUM(p.plan_appr_ytd) INTO t_proj
          FROM prod.dct_budget_utilization_v b LEFT JOIN prod.dct_gl_coa_snap csb ON csb.cc_string = b.budget_combination
          JOIN prod.dct_project_cf_butil_v p
            ON p.budget_year = b.budget_year AND p.project_number = b.project_number
           AND p.task_number = b.task_number AND p.expenditure_type = b.expenditure_type
         WHERE b.budget_year = l_year AND b.chapter = y.chname;
      END IF;
      l_has_plan := CASE WHEN t_pay IS NOT NULL OR t_proj IS NOT NULL THEN 'Y' ELSE 'N' END;
      t_plan := NVL(t_pay,0) + NVL(t_proj,0);
      APEX_JSON.open_object;
      APEX_JSON.write('type', y.code); APEX_JSON.write('name', y.name);
      APEX_JSON.write('budget', t_bud); APEX_JSON.write('actual', t_act);
      APEX_JSON.write('plan', t_plan);  APEX_JSON.write('hasPlan', l_has_plan);
      APEX_JSON.close_object;
    END;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.close_object;
  prod.dct_gl_class_pkg.clear_butil_end;
EXCEPTION WHEN OTHERS THEN
  prod.dct_gl_class_pkg.clear_butil_end;
  dct_rest.err(500, SQLERRM);
END;
!');

  dt('fmr/sector');
  dh('fmr/sector','GET',q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_period VARCHAR2(7)   := [COLON]period;
  l_entity VARCHAR2(400) := [COLON]entity;
  l_year   NUMBER;
  l_end    DATE;
  FUNCTION pct(p_num NUMBER, p_den NUMBER) RETURN NUMBER IS
  BEGIN
    IF p_den IS NULL OR p_den = 0 THEN RETURN NULL; END IF;
    RETURN ROUND(p_num * 1000 / p_den) / 10;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_period IS NULL THEN dct_rest.err(400,'period is required'); RETURN; END IF;
  l_year := TO_NUMBER(SUBSTR(l_period,4,4) DEFAULT NULL ON CONVERSION ERROR);
  IF l_year IS NULL THEN dct_rest.err(400,'period must be MM-YYYY'); RETURN; END IF;
  l_end := LAST_DAY(TO_DATE('01-'||l_period,'DD-MM-YYYY'));
  prod.dct_gl_class_pkg.set_butil_end(l_end);

  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('period', l_period); APEX_JSON.write('year', l_year);
  APEX_JSON.open_array('sectors');
  FOR r IN (
    WITH act AS (
      SELECT NVL(p.sector_code,'UNCLASSIFIED') sector_code, MAX(NVL(p.sector_name,'Unclassified')) sector_name,
             SUM(p.budget_ytd) budget, SUM(p.gl_actual_ytd) actual
        FROM prod.dct_budget_actual_period_v p
        JOIN prod.dct_gl_coa_snap ac ON ac.cc_id = p.cc_id
       WHERE p.period_name = l_period
         AND ac.budget_group_code = '1'
         AND p.chapter_code IN ('CH1','CH2','CH3')
         AND (l_entity IS NULL OR INSTR('|'||l_entity||'|', '|'||
              (NVL(ac.entity_class_code,'UNCLASSIFIED'))||'|') > 0)
       GROUP BY NVL(p.sector_code,'UNCLASSIFIED')
    ),
    ccsec AS (SELECT DISTINCT cost_center_code, sector_code FROM prod.dct_gl_coa_snap WHERE sector_code IS NOT NULL),
    plan_pay AS (
      SELECT NVL(m.sector_code,'UNCLASSIFIED') sector_code, SUM(c.cf_amount) plan_amt
        FROM prod.dct_gl_budget_cashflow c
        LEFT JOIN ccsec m ON m.cost_center_code = c.cost_center_code
       WHERE c.cf_type = 'APPROVED' AND c.budget_year = l_year AND c.budget_group_code = '1'
         AND TO_DATE(c.accounting_period,'MM-YYYY') <= TO_DATE(l_period,'MM-YYYY')
         AND (l_entity IS NULL OR INSTR('|'||l_entity||'|', '|'||
              (NVL(prod.dct_gl_class_pkg.entity_of(c.cc_string, TRUNC(SYSDATE)),'UNCLASSIFIED'))||'|') > 0)
       GROUP BY NVL(m.sector_code,'UNCLASSIFIED')
    ),
    secname AS (SELECT value_code, name_en FROM prod.dct_gl_class_value WHERE class_type_code = 'SECTOR'),
    plan_proj AS (
      SELECT NVL(sn.value_code,'UNCLASSIFIED') sector_code, SUM(p.plan_appr_ytd) plan_amt
        FROM prod.dct_budget_utilization_v b LEFT JOIN prod.dct_gl_coa_snap csb ON csb.cc_string = b.budget_combination
        JOIN prod.dct_project_cf_butil_v p
          ON p.budget_year = b.budget_year AND p.project_number = b.project_number
         AND p.task_number = b.task_number AND p.expenditure_type = b.expenditure_type
        LEFT JOIN secname sn ON sn.name_en = b.sector
       WHERE b.budget_year = l_year AND b.chapter IN ('Chapter 2','Chapter 3')
         AND (l_entity IS NULL OR INSTR('|'||l_entity||'|', '|'||
              (NVL(csb.entity_class_code,'UNCLASSIFIED'))||'|') > 0)
       GROUP BY NVL(sn.value_code,'UNCLASSIFIED')
    ),
    plan AS (
      SELECT sector_code, SUM(plan_amt) plan_amt, MAX('Y') has_plan FROM (
        SELECT sector_code, plan_amt FROM plan_pay
        UNION ALL
        SELECT sector_code, plan_amt FROM plan_proj
      ) GROUP BY sector_code
    )
    SELECT a.sector_code, a.sector_name, a.budget, a.actual, pl.plan_amt, pl.has_plan
      FROM act a LEFT JOIN plan pl ON pl.sector_code = a.sector_code
     ORDER BY CASE WHEN pl.plan_amt IS NOT NULL AND pl.plan_amt <> 0
                    THEN ROUND(a.actual*1000/pl.plan_amt)/10 END DESC NULLS LAST,
              a.actual DESC
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.sector_code); APEX_JSON.write('name', r.sector_name);
    APEX_JSON.write('budget', NVL(r.budget,0)); APEX_JSON.write('actual', NVL(r.actual,0));
    APEX_JSON.write('plan', NVL(r.plan_amt,0)); APEX_JSON.write('hasPlan', NVL(r.has_plan,'N'));
    IF pct(r.actual,r.budget) IS NOT NULL THEN APEX_JSON.write('actualVsBudgetPct', pct(r.actual,r.budget)); END IF;
    IF r.plan_amt IS NOT NULL AND pct(r.actual,r.plan_amt) IS NOT NULL THEN APEX_JSON.write('actualVsPlanPct', pct(r.actual,r.plan_amt)); END IF;
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
  prod.dct_gl_class_pkg.clear_butil_end;
EXCEPTION WHEN OTHERS THEN
  prod.dct_gl_class_pkg.clear_butil_end;
  dct_rest.err(500, SQLERRM);
END;
!');

  -- =========================================================================
  -- YTD TREND drill -- a Budget/Actual/Plan bar on the Entity-Level trend
  -- chart -> its supporting lines, in the SAME generic {columns,rows,total,
  -- count} shape every other GL drill drawer already returns (db/07's `col()`
  -- pattern) so the frontend reuses the shared drillCols/drillRows/fillDrill
  -- drawer verbatim -- no new UI, per the user's "use the drawer page".
  --   GET /gl/fmr/trend/lines?period=MM-YYYY&chapter=CH1|CH2|CH3&metric=budget|actual|plan|fundsavailable&entity=DCT|ALC|MUSEUMS|MASTERPIECES
  -- chapter and entity are BOTH optional and orthogonal (2026-09-01, KPI-tile
  -- drilldowns): omit chapter to span all three FMR chapters at once (the
  -- KPI band's "whole entity level" scope, same CH1+CH2+CH3 union the
  -- overall/entities totals already use); omit entity for the grand total
  -- across all four entities. Every row carries its own resolved chapter and
  -- the set always sorts chapter-then-account ("sort by chapter then GL
  -- segment", user 2026-09-01) -- unifies the single-chapter trend-bar drill
  -- and the all-chapter KPI-tile drill behind the one query shape.
  -- budget/actual/fundsavailable: dct_budget_actual_period_v rows (bg=1).
  -- plan: UNION of the GL-cashflow leg (Payroll/MSS upload, cc+account grain)
  -- and the project-cashflow leg (Opex/Capex only, project+task+etype grain,
  -- YTD -- matches the trend chart's own YTD Plan figure).
  -- =========================================================================
  dt('fmr/trend/lines');
  dh('fmr/trend/lines','GET',q'!
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_period  VARCHAR2(7)   := [COLON]period;
  l_chapter VARCHAR2(10)  := [COLON]chapter;
  l_entity  VARCHAR2(20)  := UPPER([COLON]entity);
  l_metric  VARCHAR2(15)  := LOWER([COLON]metric);
  l_year    NUMBER;
  l_end     DATE;
  l_total   NUMBER := 0;
  l_count   NUMBER := 0;
  -- combination popover side-map (same pattern as GL/db/34's Fund Movement
  -- drill): dedupe every cc_string/budget_combination seen across the rows,
  -- then resolve them all in one pass against dct_gl_coa_snap so the shared
  -- drill drawer's drillGridOver/drillComboRow shows the styled 10-segment
  -- popover on the Combination column for free (frontend adds fmrComboMap
  -- alongside the existing acRowMap/fmComboMap check -- no other UI change).
  TYPE t_seen IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(320);
  l_combos  apex_t_varchar2 := apex_t_varchar2();
  l_seen    t_seen;
  l_n       NUMBER := 0;
  PROCEDURE col(p_key VARCHAR2, p_label VARCHAR2, p_type VARCHAR2) IS
  BEGIN
    APEX_JSON.open_object; APEX_JSON.write('key',p_key); APEX_JSON.write('label',p_label); APEX_JSON.write('type',p_type); APEX_JSON.close_object;
  END;
  PROCEDURE track_combo(p_combo VARCHAR2) IS
  BEGIN
    IF p_combo IS NOT NULL AND NOT l_seen.EXISTS(p_combo) THEN
      l_seen(p_combo) := 1;
      l_combos.EXTEND; l_combos(l_combos.COUNT) := p_combo;
    END IF;
  END;
  PROCEDURE write_combos IS
  BEGIN
    APEX_JSON.open_object('combos');
    FOR c IN (SELECT * FROM prod.dct_gl_coa_snap WHERE cc_string IN (SELECT column_value FROM TABLE(l_combos))) LOOP
      APEX_JSON.open_object(c.cc_string);
      APEX_JSON.write('entityCode', c.entity_code); APEX_JSON.write('entityDesc', NVL(c.entity_desc,''));
      APEX_JSON.write('costCenterCode', c.cost_center_code); APEX_JSON.write('costCenterDesc', NVL(c.cost_center_desc,''));
      APEX_JSON.write('accountCode', c.account_code); APEX_JSON.write('accountDesc', NVL(c.account_desc,''));
      APEX_JSON.write('appropriationCode', c.appropriation_code); APEX_JSON.write('appropriationDesc', NVL(c.appropriation_desc,''));
      APEX_JSON.write('budgetGroupCode', c.budget_group_code); APEX_JSON.write('budgetGroupDesc', NVL(c.budget_group_desc,''));
      APEX_JSON.write('entitySpecificCode', c.entity_specific_code); APEX_JSON.write('entitySpecificDesc', NVL(c.entity_specific_desc,''));
      APEX_JSON.write('future1Code', c.future1_code); APEX_JSON.write('future1Desc', NVL(c.future1_desc,''));
      APEX_JSON.write('future2Code', c.future2_code); APEX_JSON.write('future2Desc', NVL(c.future2_desc,''));
      APEX_JSON.write('intercompanyCode', c.intercompany_code); APEX_JSON.write('intercompanyDesc', NVL(c.intercompany_desc,''));
      APEX_JSON.write('programCode', c.program_code); APEX_JSON.write('programDesc', NVL(c.program_desc,''));
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_object;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_period IS NULL OR l_metric IS NULL THEN
    dct_rest.err(400,'period and metric are required'); RETURN;
  END IF;
  IF l_chapter IS NOT NULL AND l_chapter NOT IN ('CH1','CH2','CH3') THEN
    dct_rest.err(400,'chapter must be CH1, CH2 or CH3'); RETURN;
  END IF;
  IF l_entity IS NOT NULL AND l_entity <> 'UNCLASSIFIED' THEN
    SELECT COUNT(*) INTO l_n FROM prod.dct_gl_class_value WHERE class_type_code = 'ENTITY' AND value_code = l_entity;
    IF l_n = 0 THEN dct_rest.err(400,'unknown entity ' || l_entity); RETURN; END IF;
  END IF;
  IF l_metric NOT IN ('budget','actual','plan','fundsavailable') THEN
    dct_rest.err(400,'metric must be budget, actual, plan or fundsavailable'); RETURN;
  END IF;
  l_year := TO_NUMBER(SUBSTR(l_period,4,4) DEFAULT NULL ON CONVERSION ERROR);
  IF l_year IS NULL THEN dct_rest.err(400,'period must be MM-YYYY'); RETURN; END IF;
  -- plan_appr_ytd defaults to full-YEAR when GL_CTX.BUTIL_END is unset --
  -- must set it here too, or this drill's plan total won't reconcile to the
  -- trend chart's own YTD Plan figure (caught live: 4,414M drill vs 2,766M
  -- trend for the same Opex/08-2026 combination before this was added).
  l_end := LAST_DAY(TO_DATE('01-'||l_period,'DD-MM-YYYY'));
  prod.dct_gl_class_pkg.set_butil_end(l_end);

  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('period', l_period);
  IF l_chapter IS NOT NULL THEN APEX_JSON.write('chapter', l_chapter); END IF;
  IF l_entity  IS NOT NULL THEN APEX_JSON.write('entity', l_entity); END IF;
  APEX_JSON.write('metric', l_metric);

  IF l_metric IN ('budget','actual','fundsavailable') THEN
    SELECT NVL(SUM(CASE l_metric WHEN 'budget' THEN p.budget_ytd WHEN 'actual' THEN p.gl_actual_ytd
                                  ELSE p.funds_available_ytd END),0), COUNT(*)
      INTO l_total, l_count
      FROM prod.dct_budget_actual_period_v p
     WHERE p.period_name = l_period AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '1'
       AND p.chapter_code IN ('CH1','CH2','CH3')
       AND (l_chapter IS NULL OR p.chapter_code = l_chapter)
       AND (l_entity IS NULL OR (NVL(p.entity_class_code,'UNCLASSIFIED')) = l_entity);
    APEX_JSON.write('total', l_total); APEX_JSON.write('count', l_count);
    APEX_JSON.open_array('columns');
    col('combination','Combination','text'); col('chapter','Chapter','text');
    col('costCenter','Cost Centre','text'); col('account','Account','text');
    col('sector','Sector','text'); col('appropriation','Appropriation','text');
    col('budget','Budget','money'); col('actual','Actual','money');
    IF l_metric = 'fundsavailable' THEN col('fundsAvailable','Funds Available','money'); END IF;
    APEX_JSON.close_array;
    APEX_JSON.open_array('rows');
    FOR r IN (
      SELECT p.cc_string combo, NVL(p.chapter_name,'—') chname,
             p.cost_center_code||NVL2(p.cost_center_desc,' - '||p.cost_center_desc,'') cc,
             p.account_code||NVL2(p.account_desc,' - '||p.account_desc,'') acct,
             NVL(p.sector_name,'—') sector, NVL(p.appropriation_desc, p.appropriation_code) appr,
             p.budget_ytd budget, p.gl_actual_ytd actual, p.funds_available_ytd fundsavail
        FROM prod.dct_budget_actual_period_v p
       WHERE p.period_name = l_period AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '1'
         AND p.chapter_code IN ('CH1','CH2','CH3')
         AND (l_chapter IS NULL OR p.chapter_code = l_chapter)
         AND (l_entity IS NULL OR (NVL(p.entity_class_code,'UNCLASSIFIED')) = l_entity)
       ORDER BY p.chapter_code NULLS LAST, p.account_code
       FETCH FIRST 5000 ROWS ONLY
    ) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('combination', r.combo); APEX_JSON.write('chapter', r.chname);
      APEX_JSON.write('costCenter', r.cc); APEX_JSON.write('account', r.acct);
      APEX_JSON.write('sector', r.sector); APEX_JSON.write('appropriation', r.appr);
      APEX_JSON.write('budget', r.budget); APEX_JSON.write('actual', r.actual);
      IF l_metric = 'fundsavailable' THEN APEX_JSON.write('fundsAvailable', r.fundsavail); END IF;
      APEX_JSON.close_object;
      track_combo(r.combo);
    END LOOP;
    APEX_JSON.close_array;
    write_combos;
  ELSE
    <<plan_total>>
    DECLARE t_pay NUMBER; t_proj NUMBER; BEGIN
      SELECT SUM(c.cf_amount) INTO t_pay
        FROM prod.dct_gl_cashflow_v c
       WHERE c.cf_type = 'APPROVED' AND c.budget_year = l_year AND c.budget_group_code = '1'
         AND TO_DATE(c.accounting_period,'MM-YYYY') <= TO_DATE(l_period,'MM-YYYY')
         AND c.chapter_code IN ('CH1','CH2','CH3')
         AND (l_chapter IS NULL OR c.chapter_code = l_chapter)
         AND (l_entity IS NULL OR (NVL(prod.dct_gl_class_pkg.entity_of(c.cc_string, TRUNC(SYSDATE)),'UNCLASSIFIED')) = l_entity);
      SELECT SUM(p.plan_appr_ytd) INTO t_proj
        FROM prod.dct_budget_utilization_v b LEFT JOIN prod.dct_gl_coa_snap csb ON csb.cc_string = b.budget_combination
        JOIN prod.dct_project_cf_butil_v p
          ON p.budget_year = b.budget_year AND p.project_number = b.project_number
         AND p.task_number = b.task_number AND p.expenditure_type = b.expenditure_type
       WHERE b.budget_year = l_year
         AND ( (l_chapter IS NULL AND b.chapter IN ('Chapter 2','Chapter 3'))
            OR (l_chapter = 'CH2' AND b.chapter = 'Chapter 2')
            OR (l_chapter = 'CH3' AND b.chapter = 'Chapter 3') )
         AND (l_entity IS NULL OR (NVL(csb.entity_class_code,'UNCLASSIFIED')) = l_entity);
      l_total := NVL(t_pay,0) + NVL(t_proj,0);
    END plan_total;
    SELECT COUNT(*) INTO l_count FROM (
      SELECT 1 FROM prod.dct_gl_cashflow_v c
       WHERE c.cf_type = 'APPROVED' AND c.budget_year = l_year AND c.budget_group_code = '1'
         AND TO_DATE(c.accounting_period,'MM-YYYY') <= TO_DATE(l_period,'MM-YYYY')
         AND c.chapter_code IN ('CH1','CH2','CH3')
         AND (l_chapter IS NULL OR c.chapter_code = l_chapter)
         AND (l_entity IS NULL OR (NVL(prod.dct_gl_class_pkg.entity_of(c.cc_string, TRUNC(SYSDATE)),'UNCLASSIFIED')) = l_entity)
         AND c.cf_amount <> 0
      UNION ALL
      SELECT 1 FROM prod.dct_budget_utilization_v b LEFT JOIN prod.dct_gl_coa_snap csb ON csb.cc_string = b.budget_combination
        JOIN prod.dct_project_cf_butil_v p
          ON p.budget_year = b.budget_year AND p.project_number = b.project_number
         AND p.task_number = b.task_number AND p.expenditure_type = b.expenditure_type
       WHERE b.budget_year = l_year
         AND ( (l_chapter IS NULL AND b.chapter IN ('Chapter 2','Chapter 3'))
            OR (l_chapter = 'CH2' AND b.chapter = 'Chapter 2')
            OR (l_chapter = 'CH3' AND b.chapter = 'Chapter 3') )
         AND (l_entity IS NULL OR (NVL(csb.entity_class_code,'UNCLASSIFIED')) = l_entity)
         AND NVL(p.plan_appr_ytd,0) <> 0
    );
    APEX_JSON.write('total', l_total); APEX_JSON.write('count', l_count);
    APEX_JSON.open_array('columns');
    col('combination','Combination','text'); col('chapter','Chapter','text');
    col('source','Source','text'); col('identifier','Project / Cost Centre','text');
    col('detail','Task / Account','text'); col('period','Period','text'); col('amount','Plan Amount','money');
    APEX_JSON.close_array;
    APEX_JSON.open_array('rows');
    FOR r IN (
      SELECT * FROM (
        SELECT c.cc_string combo,
               CASE c.chapter_code WHEN 'CH1' THEN 'Chapter 1' WHEN 'CH2' THEN 'Chapter 2' WHEN 'CH3' THEN 'Chapter 3' END chname,
               'GL Cashflow' src, c.cost_center_code identifier,
               c.account_code||NVL2(c.account_desc,' - '||c.account_desc,'') detail,
               c.accounting_period period, c.cf_amount amount
          FROM prod.dct_gl_cashflow_v c
         WHERE c.cf_type = 'APPROVED' AND c.budget_year = l_year AND c.budget_group_code = '1'
           AND TO_DATE(c.accounting_period,'MM-YYYY') <= TO_DATE(l_period,'MM-YYYY')
           AND c.chapter_code IN ('CH1','CH2','CH3')
           AND (l_chapter IS NULL OR c.chapter_code = l_chapter)
           AND (l_entity IS NULL OR (NVL(prod.dct_gl_class_pkg.entity_of(c.cc_string, TRUNC(SYSDATE)),'UNCLASSIFIED')) = l_entity)
           AND c.cf_amount <> 0
        UNION ALL
        SELECT b.budget_combination combo,
               b.chapter chname,
               'Project Plan' src, b.project_number||NVL2(b.project_name,' - '||b.project_name,'') identifier,
               b.task_number||' / '||b.expenditure_type detail,
               'YTD' period, p.plan_appr_ytd amount
          FROM prod.dct_budget_utilization_v b LEFT JOIN prod.dct_gl_coa_snap csb ON csb.cc_string = b.budget_combination
          JOIN prod.dct_project_cf_butil_v p
            ON p.budget_year = b.budget_year AND p.project_number = b.project_number
           AND p.task_number = b.task_number AND p.expenditure_type = b.expenditure_type
         WHERE b.budget_year = l_year
           AND ( (l_chapter IS NULL AND b.chapter IN ('Chapter 2','Chapter 3'))
              OR (l_chapter = 'CH2' AND b.chapter = 'Chapter 2')
              OR (l_chapter = 'CH3' AND b.chapter = 'Chapter 3') )
           AND (l_entity IS NULL OR (NVL(csb.entity_class_code,'UNCLASSIFIED')) = l_entity)
           AND NVL(p.plan_appr_ytd,0) <> 0
      )
      ORDER BY CASE chname WHEN 'Chapter 1' THEN 1 WHEN 'Chapter 2' THEN 2 WHEN 'Chapter 3' THEN 3 END NULLS LAST,
               REGEXP_SUBSTR(combo,'[^.]+',1,5) NULLS LAST
      FETCH FIRST 5000 ROWS ONLY
    ) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('combination', r.combo); APEX_JSON.write('chapter', NVL(r.chname,'—'));
      APEX_JSON.write('source', r.src); APEX_JSON.write('identifier', r.identifier);
      APEX_JSON.write('detail', r.detail); APEX_JSON.write('period', r.period); APEX_JSON.write('amount', r.amount);
      APEX_JSON.close_object;
      track_combo(r.combo);
    END LOOP;
    APEX_JSON.close_array;
    write_combos;
  END IF;

  APEX_JSON.close_object;
  prod.dct_gl_class_pkg.clear_butil_end;
EXCEPTION WHEN OTHERS THEN
  prod.dct_gl_class_pkg.clear_butil_end;
  dct_rest.err(500, SQLERRM);
END;
!');

  dt('fmr/notes');
  dh('fmr/notes','GET',q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_period VARCHAR2(7)   := [COLON]period;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_period IS NULL THEN dct_rest.err(400,'period is required'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('period', l_period);
  APEX_JSON.open_array('items');
  FOR r IN (SELECT note_type, note_text, updated_by,
                   TO_CHAR(dct_to_local(updated_at),'YYYY-MM-DD HH[COLON]MI AM') upd_at
              FROM prod.dct_gl_fmr_note WHERE accounting_period = l_period) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('noteType', r.note_type); APEX_JSON.write('text', NVL(r.note_text,''));
    APEX_JSON.write('updatedBy', NVL(r.updated_by,'')); APEX_JSON.write('updatedAt', NVL(r.upd_at,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');
  dh('fmr/notes','PUT',q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_period VARCHAR2(7); l_typ VARCHAR2(30); l_txt VARCHAR2(2000); l_year NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_MANAGE_DOF_NOTES', 'SYS_ADMIN', 'GL') = FALSE THEN
    dct_rest.err(403,'GL_MANAGE_DOF_NOTES required'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_period := TRIM(APEX_JSON.get_varchar2(p_path=>'period'));
  l_typ    := UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'noteType')));
  l_txt    := SUBSTR(APEX_JSON.get_varchar2(p_path=>'text'),1,2000);
  IF l_period IS NULL OR l_typ IS NULL THEN dct_rest.err(400,'period and noteType are required'); RETURN; END IF;
  IF l_typ NOT IN ('CURRENT_VARIANCE','EXPECTED_VARIANCE') THEN
    dct_rest.err(400,'noteType must be CURRENT_VARIANCE or EXPECTED_VARIANCE'); RETURN;
  END IF;
  l_year := TO_NUMBER(SUBSTR(l_period,4,4) DEFAULT NULL ON CONVERSION ERROR);
  IF l_year IS NULL THEN dct_rest.err(400,'period must be MM-YYYY'); RETURN; END IF;
  IF l_txt IS NULL THEN
    DELETE FROM prod.dct_gl_fmr_note WHERE accounting_period = l_period AND note_type = l_typ;
  ELSE
    UPDATE prod.dct_gl_fmr_note SET note_text = l_txt, updated_by = l_user, updated_at = SYSTIMESTAMP
     WHERE accounting_period = l_period AND note_type = l_typ;
    IF SQL%ROWCOUNT = 0 THEN
      INSERT INTO prod.dct_gl_fmr_note (budget_year, accounting_period, note_type, note_text, updated_by)
      VALUES (l_year, l_period, l_typ, l_txt, l_user);
    END IF;
  END IF;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

  COMMIT;
END;
/
BEGIN setup_gl_fmr_ords_tmp; END;
/
DROP PROCEDURE setup_gl_fmr_ords_tmp;

PROMPT === FMR endpoints verification ===
SELECT table_name FROM all_tables WHERE owner='PROD' AND table_name = 'DCT_GL_FMR_NOTE';
SELECT t.uri_template, h.method FROM user_ords_handlers h JOIN user_ords_templates t ON t.id=h.template_id
 JOIN user_ords_modules m ON m.id=t.module_id WHERE m.name='gl.rest' AND t.uri_template LIKE 'fmr%' ORDER BY 1,2;
