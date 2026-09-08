-- =============================================================================
-- General Ledger (App 210) -- FD Dashboard / Budget Status -- figure DRILL
-- File    : 43_gl_fd_drill_ords.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp @43_gl_fd_drill_ords.sql  (fresh session, ADMIN)
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            the GL post-05 re-run list is now 07..43.
-- Purpose : every figure on a Budget Status chapter band (Budget / Actual /
--           Encumbrance / Fund Available) drills into the shared drill drawer
--           at FULL 10-segment GL code-combination grain (user request
--           2026-09-03), under the SAME scope the band shows: period (YTD),
--           Budget Group 1, that chapter, the picked business unit and the
--           picked sectors (any-of). The drill total therefore reconciles to
--           the ring/square figure it was opened from, to the cent.
--
-- Rows come from prod.dct_budget_actual_period_v exactly like GL/db/42's cube
-- (same bg / chapter / entity / sector predicates -- keep them in LOCK-STEP),
-- v1.112.0: band rule = chapter x budget-group PAIRS (CH1-3 -> bg 1, CH4 -> bg 3,
-- CH5 -> bg 5) exactly as db/42; no chapter = all five together (the Total band).
-- one row per combination, ALL FOUR measures on every row (the drilled one is
-- the total), zero rows of the drilled measure suppressed (butil convention --
-- totals still reconcile; "zero" = ROUNDS TO 0 at the drawer's whole-AED
-- display precision, i.e. ABS < 0.5 -- user report 2026-09-03: Fund Available
-- rows showing "0" were 0.10 / 0.25 AED remainders (budget 145,210.00 vs
-- actual 145,209.90), 88 such rows live, which a bare `<> 0` let through;
-- the suppressed fractions still count in `total`), sorted chapter ->
-- account -> cost centre (the
-- user's "sort by chapter then GL segment" rule from the FMR drill, 2026-09-01),
-- capped 5,000.
--
-- `combos{}` side-map = the styled 10-segment (code + description) popover the
-- Budget Utilization drills show on hover -- every distinct combination seen is
-- resolved in ONE pass against prod.dct_gl_coa_snap (GL/db/34 + 37 pattern);
-- the frontend feeds it to the shared drillGridOver/drillComboRow delegate.
--
-- Endpoint:
--   GET /gl/fd/lines?period=MM-YYYY&metric=budget|actual|encumbrance|fundsavailable
--                    [&chapter=CH1|CH2|CH3|CH4|CH5][&entity=DCT|MUSEUMS|ALC|MASTERPIECES]
--                    [&sector=CODE|CODE...][&costcenter=CC|CC...]
--       -> { period, chapter?, entity?, sector?, costcenter?, metric, total, count,
--            columns[{key,label,type,pn?}], rows[...], combos{cc_string:{...}} }
-- Gate: any valid session (matches GET /gl/fd/status).
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_fd_drill_ords_tmp AS
    c_mod CONSTANT VARCHAR2(30) := 'gl.rest';
    PROCEDURE dt(p VARCHAR2) IS BEGIN ORDS.DEFINE_TEMPLATE(p_module_name=>c_mod, p_pattern=>p); END;
    PROCEDURE dh(p VARCHAR2, m VARCHAR2, s CLOB) IS BEGIN ORDS.DEFINE_HANDLER(p_module_name=>c_mod, p_pattern=>p, p_method=>m,
        p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(s,'[COLON]',CHR(58))); END;
BEGIN

  dt('fd/lines');
  dh('fd/lines','GET',q'!
DECLARE
  l_user    VARCHAR2(100)  := dct_rest.validate_session;
  l_period  VARCHAR2(7)    := [COLON]period;
  l_chapter VARCHAR2(10)   := UPPER([COLON]chapter);
  l_entity  VARCHAR2(20)   := UPPER([COLON]entity);
  l_sector  VARCHAR2(2000) := [COLON]sector;
  l_cc      VARCHAR2(4000) := [COLON]costcenter;
  l_metric  VARCHAR2(20)   := LOWER([COLON]metric);
  l_total   NUMBER := 0;
  l_n       NUMBER := 0;
  l_count   NUMBER := 0;
  TYPE t_seen IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(320);
  l_combos  apex_t_varchar2 := apex_t_varchar2();
  l_seen    t_seen;
  PROCEDURE col(p_key VARCHAR2, p_label VARCHAR2, p_type VARCHAR2, p_pn BOOLEAN DEFAULT FALSE) IS
  BEGIN
    APEX_JSON.open_object;
    APEX_JSON.write('key',p_key); APEX_JSON.write('label',p_label); APEX_JSON.write('type',p_type);
    IF p_pn THEN APEX_JSON.write('pn', TRUE); END IF;
    APEX_JSON.close_object;
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
  IF l_period IS NULL OR l_metric IS NULL THEN dct_rest.err(400,'period and metric are required'); RETURN; END IF;
  IF NOT REGEXP_LIKE(l_period,'^(0[1-9]|1[0-2])-[0-9]{4}$') THEN dct_rest.err(400,'period must be MM-YYYY'); RETURN; END IF;
  IF l_chapter IS NOT NULL AND l_chapter NOT IN ('CH1','CH2','CH3','CH4','CH5') THEN
    dct_rest.err(400,'chapter must be CH1, CH2, CH3, CH4 or CH5'); RETURN;
  END IF;
  IF l_entity IS NOT NULL AND l_entity <> 'UNCLASSIFIED' THEN
    SELECT COUNT(*) INTO l_n FROM prod.dct_gl_class_value WHERE class_type_code = 'ENTITY' AND value_code = l_entity;
    IF l_n = 0 THEN dct_rest.err(400,'unknown entity ' || l_entity); RETURN; END IF;
  END IF;
  IF l_metric NOT IN ('budget','actual','encumbrance','fundsavailable') THEN
    dct_rest.err(400,'metric must be budget, actual, encumbrance or fundsavailable'); RETURN;
  END IF;

  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('period', l_period);
  IF l_chapter IS NOT NULL THEN APEX_JSON.write('chapter', l_chapter); END IF;
  IF l_entity  IS NOT NULL THEN APEX_JSON.write('entity', l_entity); END IF;
  IF l_sector  IS NOT NULL THEN APEX_JSON.write('sector', l_sector); END IF;
  IF l_cc      IS NOT NULL THEN APEX_JSON.write('costcenter', l_cc); END IF;
  APEX_JSON.write('metric', l_metric);

  -- total over the WHOLE scoped set (zero rows included -- they add nothing)
  SELECT NVL(SUM(CASE l_metric WHEN 'budget' THEN p.budget_ytd WHEN 'actual' THEN p.gl_actual_ytd
                                WHEN 'encumbrance' THEN p.encumbrance_ytd ELSE p.funds_available_ytd END),0),
         COUNT(CASE WHEN ROUND(NVL(CASE l_metric WHEN 'budget' THEN p.budget_ytd WHEN 'actual' THEN p.gl_actual_ytd
                                                  WHEN 'encumbrance' THEN p.encumbrance_ytd ELSE p.funds_available_ytd END,0),0) <> 0 THEN 1 END)
    INTO l_total, l_count
    FROM prod.dct_budget_actual_period_v p
   WHERE p.period_name = l_period
     AND (p.chapter_code IN ('CH1','CH2','CH3') AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '1' OR p.chapter_code = 'CH4' AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '3' OR p.chapter_code = 'CH5' AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '5')
     AND (l_chapter IS NULL OR p.chapter_code = l_chapter)
     AND (l_entity IS NULL OR (NVL(p.entity_class_code,'UNCLASSIFIED')) = l_entity)
     AND (l_sector IS NULL OR INSTR('|'||l_sector||'|', '|'||NVL(p.sector_code,'UNCLASSIFIED')||'|') > 0)
     AND (l_cc IS NULL OR INSTR('|'||l_cc||'|', '|'||NVL(p.cost_center_code,'UNKNOWN')||'|') > 0);
  APEX_JSON.write('total', l_total); APEX_JSON.write('count', l_count);

  APEX_JSON.open_array('columns');
  col('combination','Combination','text'); col('chapter','Chapter','text');
  col('costCenter','Cost Centre','text'); col('account','Account','text');
  col('sector','Sector','text'); col('appropriation','Appropriation','text');
  col('budget','Budget','money'); col('actual','Actual','money');
  col('encumbrance','Encumbrance','money'); col('fundsAvailable','Fund Available','money', TRUE);
  APEX_JSON.close_array;

  APEX_JSON.open_array('rows');
  FOR r IN (
    SELECT p.cc_string combo, NVL(p.chapter_name,'—') chname,
           p.cost_center_code||NVL2(p.cost_center_desc,' - '||p.cost_center_desc,'') cc,
           p.account_code||NVL2(p.account_desc,' - '||p.account_desc,'') acct,
           NVL(p.sector_name,'Unclassified') sector, NVL(p.appropriation_desc, p.appropriation_code) appr,
           NVL(p.budget_ytd,0) budget, NVL(p.gl_actual_ytd,0) actual,
           NVL(p.encumbrance_ytd,0) enc, NVL(p.funds_available_ytd,0) fund
      FROM prod.dct_budget_actual_period_v p
     WHERE p.period_name = l_period
       AND (p.chapter_code IN ('CH1','CH2','CH3') AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '1' OR p.chapter_code = 'CH4' AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '3' OR p.chapter_code = 'CH5' AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '5')
       AND (l_chapter IS NULL OR p.chapter_code = l_chapter)
       AND (l_entity IS NULL OR (NVL(p.entity_class_code,'UNCLASSIFIED')) = l_entity)
       AND (l_sector IS NULL OR INSTR('|'||l_sector||'|', '|'||NVL(p.sector_code,'UNCLASSIFIED')||'|') > 0)
       AND (l_cc IS NULL OR INSTR('|'||l_cc||'|', '|'||NVL(p.cost_center_code,'UNKNOWN')||'|') > 0)
       AND ROUND(NVL(CASE l_metric WHEN 'budget' THEN p.budget_ytd WHEN 'actual' THEN p.gl_actual_ytd
                                   WHEN 'encumbrance' THEN p.encumbrance_ytd ELSE p.funds_available_ytd END,0),0) <> 0
     ORDER BY p.chapter_code, p.account_code, p.cost_center_code, p.cc_string
     FETCH FIRST 5000 ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('combination', r.combo); APEX_JSON.write('chapter', r.chname);
    APEX_JSON.write('costCenter', r.cc); APEX_JSON.write('account', r.acct);
    APEX_JSON.write('sector', r.sector); APEX_JSON.write('appropriation', r.appr);
    APEX_JSON.write('budget', r.budget); APEX_JSON.write('actual', r.actual);
    APEX_JSON.write('encumbrance', r.enc); APEX_JSON.write('fundsAvailable', r.fund);
    APEX_JSON.close_object;
    track_combo(r.combo);
  END LOOP;
  APEX_JSON.close_array;
  write_combos;

  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  dct_rest.err(500, SQLERRM);
END;
!');

  COMMIT;
END setup_gl_fd_drill_ords_tmp;
/

BEGIN setup_gl_fd_drill_ords_tmp; END;
/
DROP PROCEDURE setup_gl_fd_drill_ords_tmp;

PROMPT == GL/db/43 fd/lines handler ==
SELECT h.method, t.uri_template, LENGTH(h.source) src_len
  FROM user_ords_handlers h JOIN user_ords_templates t ON t.id = h.template_id
 WHERE t.uri_template IN ('fd/status','fd/lines') ORDER BY 2;
