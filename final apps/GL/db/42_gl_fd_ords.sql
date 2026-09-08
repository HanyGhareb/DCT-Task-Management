-- =============================================================================
-- General Ledger (App 210) -- FD Dashboard / Budget Status
-- File    : 42_gl_fd_ords.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp @42_gl_fd_ords.sql  (fresh session, ADMIN)
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            the GL post-05 re-run list is now 07..42.
-- Purpose : the executive "Budget status" page (user sketch, mockup A "Ring
--           Bands" picked 2026-09-03): Budget / Actual / Encumbrance / Fund
--           Available per CHAPTER across every business unit, with a Sectors
--           card strip that filters the chapters (one or more sectors).
--
-- Basis (user decision 2026-09-03): the GL-balances basis of the Financial
-- Performance report (GL/db/37) -- NOT the project Budget Utilization view --
-- so this page and the FMR tab always agree:
--   * prod.dct_budget_actual_period_v at the requested period (YTD columns)
--   * Budget Group = 1 only: REGEXP_SUBSTR(cc_string,'[^.]+',1,4) = '1'
--     (position 4 of the canonical entity.program.cc.BG.account.es.appr...)
--   * Chapters 1/2/3 (Payroll / Opex / Capex) on Budget Group 1 -- the FMR basis --
--     PLUS (v1.112.0, user 2026-09-04) Chapter 4 (Subsidy) and Chapter 5 (Aids &
--     Grants), which live ONLY in budget groups 3 and 5 (live 2026: CH4 = 5 combos
--     / 341.3M on bg 3, CH5 = 27.9M on bg 5, NOTHING on bg 1). Band rule =
--     chapter x budget-group PAIRS: CH1-3 -> bg 1, CH4 -> bg 3, CH5 -> bg 5 (the
--     bg-3/5 rows with NO chapter are the 3xxxxx budgetary-control offsets and
--     stay out). `excluded{}` keeps its meaning = the Budget Group 1 remainder
--     (no chapter / Chapter 6), reported as a footnote rather than dropped.
--     2026-09-06 PLATFORM RULE (user): the funding side is never budget -- the
--     3270xx Treasury-contribution offsets are dropped at GL_BALANCES_CC
--     (db/v2/32) and DCT_BUDGET_ACTUAL_PERIOD_V is expense-only (db/v2/34), so
--     excluded{} now = EXPENSE budget with no chapter classification (a data
--     gap to fix in Settings > Chart of Accounts), never revenue/funding rows.
--   * Entity ("business unit") from the entity-specific segment (position 6):
--     ENTITY = the data-driven classification (GL/db/47: rules on any GL segment,
--     read from DCT_BUDGET_ACTUAL_PERIOD_V.entity_class_code; NULL = Unclassified);
--     appropriation 301439 (FA1439 art-collectibles fund) -> MASTERPIECES,
--     carved out first. Identical CASE to GL/db/37.
--   * Encumbrance = encumbrance_ytd (the GL encumbrance balance) and Fund
--     Available = funds_available_ytd -- verified on live 09-2026 data that
--     budget - actual - encumbrance = funds_available at every grain, so the
--     four figures a band shows always reconcile with each other.
--
-- ONE round trip: the handler returns the whole cube at
-- (sector x cost centre x entity x chapter) grain (a few hundred rows, tiny)
-- and the page aggregates client-side, so clicking a sector card, a
-- department (cost centre) card or the business-unit toggle never waits on
-- the server. v2 2026-09-03 (user): grain went from sector to sector x cost
-- centre + a costCenters[] LOV so the page can show a "Departments (Cost
-- Centres)" card region filtered by the picked sectors.
--
-- Endpoint:
--   GET /gl/fd/status?period=MM-YYYY
--       -> { period, year, scope{basis,budgetGroup,chapters},
--            entities[{code,name}], chapters[{code,name,nameAr?,alt}],
--            sectors[{code,name,nameAr?,budget,actual,encumbrance,fundsAvailable}],
--            costCenters[{code,name,sector,sectorName,budget}],
--            rows[{sector,sectorName,costCenter,costCenterName,entity,chapter,
--                  budget,actual,encumbrance,fundsAvailable,combinations}],
--            excluded{budget,actual,encumbrance,fundsAvailable,combinations},
--            thresholds{near,over}   (v1.105.0: BUD_UTIL_NEAR_PCT / BUD_UTIL_OVER_PCT GL settings,
--                                    defaults 90/100 - the page's state pills + map heat)
--            series[{s,c,e,ch,m{MM:[budget,actual,encumbrance,fund,combinations]}}]  (v1.107.0:
--                                    the same cube for EVERY loaded period of the year - approach A),
--            periods[MM-YYYY asc], excludedByPeriod{MM:{...}},
--            totals{budget,actual,encumbrance,fundsAvailable} }
-- Gate: any valid session (matches GET /gl/fmr/entity, the page this extends).
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_fd_ords_tmp AS
    c_mod CONSTANT VARCHAR2(30) := 'gl.rest';
    PROCEDURE dt(p VARCHAR2) IS BEGIN ORDS.DEFINE_TEMPLATE(p_module_name=>c_mod, p_pattern=>p); END;
    PROCEDURE dh(p VARCHAR2, m VARCHAR2, s CLOB) IS BEGIN ORDS.DEFINE_HANDLER(p_module_name=>c_mod, p_pattern=>p, p_method=>m,
        p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(s,'[COLON]',CHR(58))); END;
BEGIN

  dt('fd/status');
  dh('fd/status','GET',q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_period VARCHAR2(7)   := [COLON]period;
  l_has_uncl BOOLEAN := FALSE;
  l_year   NUMBER;
  l_amm    VARCHAR2(2);
  t_bud NUMBER := 0; t_act NUMBER := 0; t_enc NUMBER := 0; t_fun NUMBER := 0;
  -- vs-Budget thresholds (GL module settings, same keys as GL/db/35) echoed for the
  -- page's state pills / map heat (v1.105.0) - defaults 90 / 100 when unset
  l_tbn NUMBER := 90; l_tbo NUMBER := 100;
  -- v1.107.0 (approach A, user): ONE scan of the period view for the WHOLE year.
  -- series[] streams straight from the cursor (one compact object per cube key,
  -- m = {MM:[budget,actual,encumbrance,fund,combinations]}); the anchor period's
  -- rows[], sectors[], costCenters[], excluded{} and totals{} are collected from
  -- the SAME pass and written afterwards (JSON key order is free). Before: four
  -- single-period scans + the year scan = 6.6 s; now = the year scan alone.
  TYPE t_x IS RECORD (b NUMBER, a NUMBER, e NUMBER, f NUMBER, n NUMBER);
  TYPE t_xmap IS TABLE OF t_x INDEX BY VARCHAR2(2);
  TYPE t_mmap IS TABLE OF VARCHAR2(2) INDEX BY VARCHAR2(2);
  TYPE t_row IS RECORD (s VARCHAR2(200), sn VARCHAR2(500), c VARCHAR2(200), cn VARCHAR2(500), ent VARCHAR2(20), ch VARCHAR2(10),
                        b NUMBER, a NUMBER, en NUMBER, f NUMBER, n NUMBER);
  TYPE t_rows IS TABLE OF t_row INDEX BY PLS_INTEGER;
  TYPE t_agg IS RECORD (name VARCHAR2(500), b NUMBER, a NUMBER, en NUMBER, f NUMBER, best_b NUMBER, best_s VARCHAR2(200), best_sn VARCHAR2(500));
  TYPE t_aggmap IS TABLE OF t_agg INDEX BY VARCHAR2(200);
  TYPE t_keys IS TABLE OF VARCHAR2(200) INDEX BY PLS_INTEGER;
  TYPE t_armap IS TABLE OF VARCHAR2(500) INDEX BY VARCHAR2(200);
  x_by t_xmap; l_mm t_mmap; l_i VARCHAR2(2);
  l_rows t_rows; l_sec t_aggmap; l_cc t_aggmap; l_ord t_keys; l_ar t_armap;
  l_key VARCHAR2(400); l_open BOOLEAN := FALSE; l_k VARCHAR2(200);
  -- budget-desc, code-asc order of a map's keys (<= ~100 keys: insertion sort)
  PROCEDURE sort_keys(p_map IN t_aggmap, p_ord IN OUT NOCOPY t_keys) IS
    l_t VARCHAR2(200); l_j PLS_INTEGER;
    FUNCTION before(x VARCHAR2, y VARCHAR2) RETURN BOOLEAN IS
    BEGIN
      RETURN NVL(p_map(x).b,0) > NVL(p_map(y).b,0) OR (NVL(p_map(x).b,0) = NVL(p_map(y).b,0) AND x < y);
    END;
  BEGIN
    FOR i IN 2..p_ord.COUNT LOOP
      l_t := p_ord(i); l_j := i - 1;
      WHILE l_j >= 1 AND before(l_t, p_ord(l_j)) LOOP p_ord(l_j + 1) := p_ord(l_j); l_j := l_j - 1; END LOOP;
      p_ord(l_j + 1) := l_t;
    END LOOP;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_period IS NULL THEN dct_rest.err(400,'period is required'); RETURN; END IF;
  IF NOT REGEXP_LIKE(l_period,'^(0[1-9]|1[0-2])-[0-9]{4}$') THEN dct_rest.err(400,'period must be MM-YYYY'); RETURN; END IF;
  l_year := TO_NUMBER(SUBSTR(l_period,4,4)); l_amm := SUBSTR(l_period,1,2);

  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('period', l_period); APEX_JSON.write('year', l_year);
  APEX_JSON.open_object('scope');
  APEX_JSON.write('basis', 'GL'); APEX_JSON.write('budgetGroup', '1|3|5'); APEX_JSON.write('chapters', 'CH1|CH2|CH3|CH4|CH5');
  APEX_JSON.write('budgetGroupByChapter', 'CH1:1|CH2:1|CH3:1|CH4:3|CH5:5');
  APEX_JSON.close_object;
  FOR s IN (SELECT setting_key, setting_value FROM prod.dct_module_settings
             WHERE module_id = (SELECT module_id FROM prod.dct_modules WHERE module_code = 'GL')
               AND setting_key IN ('BUD_UTIL_NEAR_PCT','BUD_UTIL_OVER_PCT')) LOOP
    IF s.setting_key = 'BUD_UTIL_NEAR_PCT' THEN l_tbn := NVL(TO_NUMBER(s.setting_value DEFAULT NULL ON CONVERSION ERROR), l_tbn);
    ELSE l_tbo := NVL(TO_NUMBER(s.setting_value DEFAULT NULL ON CONVERSION ERROR), l_tbo); END IF;
  END LOOP;
  APEX_JSON.open_object('thresholds');
  APEX_JSON.write('near', l_tbn); APEX_JSON.write('over', l_tbo);
  APEX_JSON.close_object;


  APEX_JSON.open_array('chapters');
  FOR c IN (SELECT v.value_code code, v.name_en name, v.name_ar name_ar, v.alt_name1 alt
              FROM prod.dct_gl_class_value v
             WHERE v.class_type_code = 'CHAPTER' AND v.value_code IN ('CH1','CH2','CH3','CH4','CH5')
             ORDER BY v.display_order, v.value_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', c.code); APEX_JSON.write('name', c.name);
    IF c.name_ar IS NOT NULL THEN APEX_JSON.write('nameAr', c.name_ar); END IF;
    APEX_JSON.write('alt', NVL(c.alt, c.code));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  FOR v IN (SELECT value_code, name_ar FROM prod.dct_gl_class_value WHERE class_type_code = 'SECTOR' AND name_ar IS NOT NULL) LOOP
    l_ar(v.value_code) := v.name_ar;
  END LOOP;

  -- THE scan: the cube (sector x cost centre x entity x chapter, Budget Group 1) for
  -- every loaded period of the year; in_band='N' rows (bg-1 rows with no chapter / Chapter 6)
  -- collapse to one row per period = that period's excluded slice
  APEX_JSON.open_array('series');
  FOR r IN (
    SELECT x.in_band, x.sector_code, MAX(x.sector_name) sector_name, x.cc_code, MAX(x.cc_name) cc_name,
           x.entity, x.chapter_code, x.mm,
           SUM(x.budget_ytd) budget, SUM(x.gl_actual_ytd) actual,
           SUM(x.encumbrance_ytd) enc, SUM(x.funds_available_ytd) fund, COUNT(*) n
      FROM (SELECT CASE WHEN (p.chapter_code IN ('CH1','CH2','CH3') AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '1' OR p.chapter_code = 'CH4' AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '3' OR p.chapter_code = 'CH5' AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '5') THEN 'Y' ELSE 'N' END in_band,
                   CASE WHEN (p.chapter_code IN ('CH1','CH2','CH3') AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '1' OR p.chapter_code = 'CH4' AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '3' OR p.chapter_code = 'CH5' AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '5') THEN NVL(p.sector_code,'UNCLASSIFIED') ELSE '-' END sector_code,
                   CASE WHEN (p.chapter_code IN ('CH1','CH2','CH3') AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '1' OR p.chapter_code = 'CH4' AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '3' OR p.chapter_code = 'CH5' AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '5') THEN NVL(p.sector_name,'Unclassified') ELSE '-' END sector_name,
                   CASE WHEN (p.chapter_code IN ('CH1','CH2','CH3') AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '1' OR p.chapter_code = 'CH4' AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '3' OR p.chapter_code = 'CH5' AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '5') THEN NVL(p.cost_center_code,'UNKNOWN') ELSE '-' END cc_code,
                   CASE WHEN (p.chapter_code IN ('CH1','CH2','CH3') AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '1' OR p.chapter_code = 'CH4' AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '3' OR p.chapter_code = 'CH5' AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '5') THEN NVL(p.cost_center_desc, NVL(p.cost_center_code,'Unknown')) ELSE '-' END cc_name,
                   CASE WHEN NOT (p.chapter_code IN ('CH1','CH2','CH3') AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '1' OR p.chapter_code = 'CH4' AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '3' OR p.chapter_code = 'CH5' AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '5') THEN '-'
                        ELSE NVL(p.entity_class_code,'UNCLASSIFIED') END entity,
                   CASE WHEN (p.chapter_code IN ('CH1','CH2','CH3') AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '1' OR p.chapter_code = 'CH4' AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '3' OR p.chapter_code = 'CH5' AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '5') THEN p.chapter_code ELSE '-' END chapter_code,
                   SUBSTR(p.period_name,1,2) mm,
                   p.budget_ytd, p.gl_actual_ytd, p.encumbrance_ytd, p.funds_available_ytd
              FROM prod.dct_budget_actual_period_v p
             WHERE p.period_name LIKE '%-' || l_year
               AND (REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '1'
                    OR p.chapter_code = 'CH4' AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '3'
                    OR p.chapter_code = 'CH5' AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '5')) x
     GROUP BY x.in_band, x.sector_code, x.cc_code, x.entity, x.chapter_code, x.mm
     ORDER BY x.in_band DESC, x.sector_code, x.cc_code, x.entity, x.chapter_code, x.mm) LOOP
    l_mm(r.mm) := r.mm;
    IF r.in_band = 'N' THEN
      IF NOT x_by.EXISTS(r.mm) THEN x_by(r.mm).b := 0; x_by(r.mm).a := 0; x_by(r.mm).e := 0; x_by(r.mm).f := 0; x_by(r.mm).n := 0; END IF;
      x_by(r.mm).b := x_by(r.mm).b + NVL(r.budget,0); x_by(r.mm).a := x_by(r.mm).a + NVL(r.actual,0);
      x_by(r.mm).e := x_by(r.mm).e + NVL(r.enc,0);    x_by(r.mm).f := x_by(r.mm).f + NVL(r.fund,0);
      x_by(r.mm).n := x_by(r.mm).n + r.n;
    ELSE
      IF r.entity = 'UNCLASSIFIED' THEN l_has_uncl := TRUE; END IF;
      IF l_key IS NULL OR l_key <> r.sector_code||'|'||r.cc_code||'|'||r.entity||'|'||r.chapter_code THEN
        IF l_open THEN APEX_JSON.close_object; APEX_JSON.close_object; END IF;
        APEX_JSON.open_object;
        APEX_JSON.write('s', r.sector_code); APEX_JSON.write('c', r.cc_code);
        APEX_JSON.write('e', r.entity);      APEX_JSON.write('ch', r.chapter_code);
        APEX_JSON.open_object('m');
        l_open := TRUE; l_key := r.sector_code||'|'||r.cc_code||'|'||r.entity||'|'||r.chapter_code;
      END IF;
      APEX_JSON.open_array(r.mm);
      APEX_JSON.write(NVL(r.budget,0)); APEX_JSON.write(NVL(r.actual,0));
      APEX_JSON.write(NVL(r.enc,0));    APEX_JSON.write(NVL(r.fund,0)); APEX_JSON.write(r.n);
      APEX_JSON.close_array;
      IF r.mm = l_amm THEN
        -- the anchor period: cube row + sector / cost-centre aggregates + totals
        l_rows(l_rows.COUNT + 1).s := r.sector_code; l_rows(l_rows.COUNT).sn := r.sector_name;
        l_rows(l_rows.COUNT).c := r.cc_code; l_rows(l_rows.COUNT).cn := r.cc_name;
        l_rows(l_rows.COUNT).ent := r.entity; l_rows(l_rows.COUNT).ch := r.chapter_code;
        l_rows(l_rows.COUNT).b := NVL(r.budget,0); l_rows(l_rows.COUNT).a := NVL(r.actual,0);
        l_rows(l_rows.COUNT).en := NVL(r.enc,0); l_rows(l_rows.COUNT).f := NVL(r.fund,0); l_rows(l_rows.COUNT).n := r.n;
        t_bud := t_bud + NVL(r.budget,0); t_act := t_act + NVL(r.actual,0);
        t_enc := t_enc + NVL(r.enc,0);    t_fun := t_fun + NVL(r.fund,0);
        IF NOT l_sec.EXISTS(r.sector_code) THEN
          l_sec(r.sector_code).name := r.sector_name; l_sec(r.sector_code).b := 0; l_sec(r.sector_code).a := 0;
          l_sec(r.sector_code).en := 0; l_sec(r.sector_code).f := 0;
        END IF;
        l_sec(r.sector_code).b := l_sec(r.sector_code).b + NVL(r.budget,0); l_sec(r.sector_code).a := l_sec(r.sector_code).a + NVL(r.actual,0);
        l_sec(r.sector_code).en := l_sec(r.sector_code).en + NVL(r.enc,0);  l_sec(r.sector_code).f := l_sec(r.sector_code).f + NVL(r.fund,0);
        IF NOT l_cc.EXISTS(r.cc_code) THEN
          l_cc(r.cc_code).name := r.cc_name; l_cc(r.cc_code).b := 0; l_cc(r.cc_code).best_b := NULL;
        END IF;
        l_cc(r.cc_code).b := l_cc(r.cc_code).b + NVL(r.budget,0);
        -- sector attribution = the sector of the largest budget row (ties: the later code)
        IF l_cc(r.cc_code).best_b IS NULL OR NVL(r.budget,0) > l_cc(r.cc_code).best_b
           OR (NVL(r.budget,0) = l_cc(r.cc_code).best_b AND r.sector_code > l_cc(r.cc_code).best_s) THEN
          l_cc(r.cc_code).best_b := NVL(r.budget,0); l_cc(r.cc_code).best_s := r.sector_code; l_cc(r.cc_code).best_sn := r.sector_name;
        END IF;
      END IF;
    END IF;
  END LOOP;
  IF l_open THEN APEX_JSON.close_object; APEX_JSON.close_object; END IF;
  APEX_JSON.close_array;
  -- entities[] = the ENTITY classification values (Chart of Accounts, GL/db/47) + an
  -- Unclassified bucket only when an in-band row of the year has no rule/default
  APEX_JSON.open_array('entities');
  FOR e IN (SELECT v.value_code code, v.name_en name, v.name_ar name_ar, v.is_default, v.display_order ord
              FROM prod.dct_gl_class_value v WHERE v.class_type_code = 'ENTITY' AND v.is_active = 'Y'
             ORDER BY v.display_order, v.name_en) LOOP
    APEX_JSON.open_object; APEX_JSON.write('code', e.code); APEX_JSON.write('name', e.name);
    APEX_JSON.write('nameAr', NVL(e.name_ar,'')); APEX_JSON.write('isDefault', e.is_default); APEX_JSON.close_object;
  END LOOP;
  IF l_has_uncl THEN
    APEX_JSON.open_object; APEX_JSON.write('code', 'UNCLASSIFIED'); APEX_JSON.write('name', 'Unclassified');
    APEX_JSON.write('nameAr', 'غير مصنف'); APEX_JSON.write('isDefault', 'N'); APEX_JSON.close_object;
  END IF;
  APEX_JSON.close_array;

  APEX_JSON.open_array('periods');
  FOR i IN 1..12 LOOP
    l_i := LPAD(i,2,'0');
    IF l_mm.EXISTS(l_i) THEN APEX_JSON.write(l_i||'-'||l_year); END IF;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_object('excludedByPeriod');
  FOR i IN 1..12 LOOP
    l_i := LPAD(i,2,'0');
    IF x_by.EXISTS(l_i) THEN
      APEX_JSON.open_object(l_i);
      APEX_JSON.write('budget', x_by(l_i).b); APEX_JSON.write('actual', x_by(l_i).a);
      APEX_JSON.write('encumbrance', x_by(l_i).e); APEX_JSON.write('fundsAvailable', x_by(l_i).f);
      APEX_JSON.write('combinations', x_by(l_i).n);
      APEX_JSON.close_object;
    END IF;
  END LOOP;
  APEX_JSON.close_object;

  -- the anchor period, collected above: rows[] (cursor order = sector, cc, entity, chapter)
  APEX_JSON.open_array('rows');
  FOR i IN 1..l_rows.COUNT LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('sector', l_rows(i).s); APEX_JSON.write('sectorName', l_rows(i).sn);
    APEX_JSON.write('costCenter', l_rows(i).c); APEX_JSON.write('costCenterName', l_rows(i).cn);
    APEX_JSON.write('entity', l_rows(i).ent); APEX_JSON.write('chapter', l_rows(i).ch);
    APEX_JSON.write('budget', l_rows(i).b); APEX_JSON.write('actual', l_rows(i).a);
    APEX_JSON.write('encumbrance', l_rows(i).en); APEX_JSON.write('fundsAvailable', l_rows(i).f);
    APEX_JSON.write('combinations', l_rows(i).n);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  -- sector LOV (budget-desc; Arabic name when the class value has one)
  l_ord.DELETE; l_k := l_sec.FIRST;
  WHILE l_k IS NOT NULL LOOP l_ord(l_ord.COUNT + 1) := l_k; l_k := l_sec.NEXT(l_k); END LOOP;
  sort_keys(l_sec, l_ord);
  APEX_JSON.open_array('sectors');
  FOR i IN 1..l_ord.COUNT LOOP
    l_k := l_ord(i);
    APEX_JSON.open_object;
    APEX_JSON.write('code', l_k); APEX_JSON.write('name', l_sec(l_k).name);
    IF l_ar.EXISTS(l_k) THEN APEX_JSON.write('nameAr', l_ar(l_k)); END IF;
    APEX_JSON.write('budget', l_sec(l_k).b); APEX_JSON.write('actual', l_sec(l_k).a);
    APEX_JSON.write('encumbrance', l_sec(l_k).en); APEX_JSON.write('fundsAvailable', l_sec(l_k).f);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  -- department (cost centre) LOV with its sector attribution (budget-desc) --
  -- figures per business-unit scope are recomputed client-side from rows[]
  l_ord.DELETE; l_k := l_cc.FIRST;
  WHILE l_k IS NOT NULL LOOP l_ord(l_ord.COUNT + 1) := l_k; l_k := l_cc.NEXT(l_k); END LOOP;
  sort_keys(l_cc, l_ord);
  APEX_JSON.open_array('costCenters');
  FOR i IN 1..l_ord.COUNT LOOP
    l_k := l_ord(i);
    APEX_JSON.open_object;
    APEX_JSON.write('code', l_k); APEX_JSON.write('name', l_cc(l_k).name);
    APEX_JSON.write('sector', l_cc(l_k).best_s); APEX_JSON.write('sectorName', l_cc(l_k).best_sn);
    APEX_JSON.write('budget', l_cc(l_k).b);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  -- what the bands leave out at the anchor period (Budget Group 1 rows with no chapter or Chapter 6)
  APEX_JSON.open_object('excluded');
  IF x_by.EXISTS(l_amm) THEN
    APEX_JSON.write('budget', x_by(l_amm).b); APEX_JSON.write('actual', x_by(l_amm).a);
    APEX_JSON.write('encumbrance', x_by(l_amm).e); APEX_JSON.write('fundsAvailable', x_by(l_amm).f);
    APEX_JSON.write('combinations', x_by(l_amm).n);
  ELSE
    APEX_JSON.write('budget', 0); APEX_JSON.write('actual', 0);
    APEX_JSON.write('encumbrance', 0); APEX_JSON.write('fundsAvailable', 0); APEX_JSON.write('combinations', 0);
  END IF;
  APEX_JSON.close_object;

  APEX_JSON.open_object('totals');
  APEX_JSON.write('budget', t_bud); APEX_JSON.write('actual', t_act);
  APEX_JSON.write('encumbrance', t_enc); APEX_JSON.write('fundsAvailable', t_fun);
  APEX_JSON.close_object;

  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  dct_rest.err(500, SQLERRM);
END;
!');

  COMMIT;
END setup_gl_fd_ords_tmp;
/

BEGIN setup_gl_fd_ords_tmp; END;
/
DROP PROCEDURE setup_gl_fd_ords_tmp;

PROMPT == GL/db/42 fd/status handler ==
SELECT h.method, t.uri_template, LENGTH(h.source) src_len
  FROM user_ords_handlers h JOIN user_ords_templates t ON t.id = h.template_id
 WHERE t.uri_template = 'fd/status';
