-- =============================================================================
-- General Ledger (App 210) -- DOF reports + budget cashflow endpoints (ADDITIVE)
-- File    : 17_gl_dof_ords.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod (fresh session) or python-oracledb
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            re-run 07..16 + THIS script (post-05 list is now 07..17).
-- Purpose : the DOF submission reports (db/v2/111) -- budget cashflow plan
--           upload (GL + Projects), the three DOF datasets (YoY performance /
--           Budget Utilization / Quarterly performance), the persisted
--           Reasons-for-Variance notes, and the XLSX register bridges.
-- Endpoints:
--   POST /gl/cashflow                  GL cashflow bulk upsert <=500 rows/req
--   POST /gl/cashflow/projects         Projects cashflow bulk upsert <=500
--   GET  /gl/cashflow/summary          per-year/type coverage + unmapped appr
--   GET  /gl/dof/yoy?year=&period=     YoY dataset (account grain + totals)
--   GET  /gl/dof/butil?year=&period=   Budget Utilization dataset (appr grain)
--   GET  /gl/dof/quarterly?year=       Quarterly dataset (appr grain, Q1-Q4)
--   GET  /gl/dof/notes?year=           saved notes for a year
--   PUT  /gl/dof/notes                 upsert one note (natural key in body)
--   POST /gl/dof/register              enqueue DOF_YOY_PERF / DOF_QUARTERLY_PERF
--   GET  /gl/dof/register/[COLON]id[/file]    poll status / download XLSX
-- Gates   : reads  GL_VIEW_DOF_REPORTS  (NULL legacy role = any valid session)
--           cashflow writes GL_MANAGE_CASHFLOW  (legacy role SYS_ADMIN)
--           notes  writes  GL_MANAGE_DOF_NOTES  (legacy role SYS_ADMIN)
-- Notes   : numeric segment values are zero-padded to the canonical Fusion
--           widths at load (Excel drops leading zeros); period params are
--           FX-exact MM-YYYY; every derived value is computed IN the cursor.
--           2026-08-03: the CURRENT-year leg of yoy/butil/quarterly is a
--           Fusion UNION legacy-EBS union (bg-1), so the datasets run for ANY
--           loaded fiscal year (2016-2025 = EBS mapped view, 2026+ = fact
--           view). EBS carries ONE budget measure -> Initial = Revised for
--           prior years. reporting/db/31 sections are kept in LOCK-STEP.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_dof_ords_a AS

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

    def_template('cashflow');
    def_handler('cashflow', 'POST', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_cnt   NUMBER;
  l_src   VARCHAR2(200);
  l_year  NUMBER; l_per VARCHAR2(20); l_typ VARCHAR2(30); l_amt NUMBER;
  l_pd    DATE;
  l_e VARCHAR2(30); l_pg VARCHAR2(30); l_cc VARCHAR2(30); l_bg VARCHAR2(30);
  l_ac VARCHAR2(30); l_es VARCHAR2(30); l_ap VARCHAR2(30); l_ic VARCHAR2(30);
  l_f1 VARCHAR2(30); l_f2 VARCHAR2(30);
  l_ok NUMBER := 0; l_err NUMBER := 0;
  FUNCTION nseg(p VARCHAR2, w NUMBER) RETURN VARCHAR2 IS
  BEGIN
    IF p IS NULL THEN RETURN LPAD('0', w, '0'); END IF;
    IF REGEXP_LIKE(TRIM(p), '^[0-9]+$') AND LENGTH(TRIM(p)) < w THEN
      RETURN LPAD(TRIM(p), w, '0');
    END IF;
    RETURN TRIM(p);
  END;
  FUNCTION parse_period(p VARCHAR2) RETURN DATE IS
    d DATE;
    FUNCTION ok(x DATE) RETURN BOOLEAN IS
    BEGIN RETURN x IS NOT NULL AND EXTRACT(YEAR FROM x) BETWEEN 1990 AND 2100; END;
  BEGIN
    d := TO_DATE(p DEFAULT NULL ON CONVERSION ERROR, 'FXMM-YYYY');
    IF NOT ok(d) THEN d := TO_DATE(p DEFAULT NULL ON CONVERSION ERROR, 'FXMON-YYYY', q'#NLS_DATE_LANGUAGE=ENGLISH#'); END IF;
    IF NOT ok(d) THEN d := TO_DATE(p DEFAULT NULL ON CONVERSION ERROR, 'FXMON-YY',   q'#NLS_DATE_LANGUAGE=ENGLISH#'); END IF;
    IF NOT ok(d) THEN d := TO_DATE(p DEFAULT NULL ON CONVERSION ERROR, 'FXYYYY-MM'); END IF;
    IF NOT ok(d) THEN RETURN NULL; END IF;
    RETURN d;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_MANAGE_CASHFLOW', 'SYS_ADMIN', 'GL') = FALSE THEN
    dct_rest.err(403,'GL_MANAGE_CASHFLOW required'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_cnt := NVL(APEX_JSON.get_count(p_path=>'rows'), 0);
  IF l_cnt = 0 THEN dct_rest.err(400,'rows[] is required'); RETURN; END IF;
  IF l_cnt > 500 THEN dct_rest.err(400,'maximum 500 rows per request'); RETURN; END IF;
  l_src := SUBSTR(APEX_JSON.get_varchar2(p_path=>'sourceFile'),1,200);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('results');
  FOR i IN 1 .. l_cnt LOOP
    BEGIN
      l_e  := nseg(APEX_JSON.get_varchar2(p_path=>'rows[%d].entity',         p0=>i), 3);
      l_pg := nseg(APEX_JSON.get_varchar2(p_path=>'rows[%d].program',        p0=>i), 6);
      l_cc := nseg(APEX_JSON.get_varchar2(p_path=>'rows[%d].costCenter',     p0=>i), 7);
      l_bg := nseg(APEX_JSON.get_varchar2(p_path=>'rows[%d].budgetGroup',    p0=>i), 1);
      l_ac := nseg(APEX_JSON.get_varchar2(p_path=>'rows[%d].account',        p0=>i), 6);
      l_es := nseg(APEX_JSON.get_varchar2(p_path=>'rows[%d].entitySpecific', p0=>i), 7);
      l_ap := nseg(APEX_JSON.get_varchar2(p_path=>'rows[%d].appropriation',  p0=>i), 6);
      l_ic := nseg(APEX_JSON.get_varchar2(p_path=>'rows[%d].intercompany',   p0=>i), 3);
      l_f1 := nseg(APEX_JSON.get_varchar2(p_path=>'rows[%d].future1',        p0=>i), 6);
      l_f2 := nseg(APEX_JSON.get_varchar2(p_path=>'rows[%d].future2',        p0=>i), 6);
      l_per := TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].period', p0=>i));
      l_typ := UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].cfType', p0=>i)));
      l_amt := APEX_JSON.get_number(p_path=>'rows[%d].amount', p0=>i);
      l_year := APEX_JSON.get_number(p_path=>'rows[%d].year', p0=>i);
      IF APEX_JSON.get_varchar2(p_path=>'rows[%d].appropriation', p0=>i) IS NULL
         OR l_per IS NULL OR l_typ IS NULL OR l_amt IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001,'appropriation, period, cfType and amount are required');
      END IF;
      IF l_typ NOT IN ('APPROVED','REVISED') THEN
        RAISE_APPLICATION_ERROR(-20001,'cfType must be APPROVED or REVISED');
      END IF;
      l_pd := parse_period(l_per);
      IF l_pd IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001,'period not recognised (use MM-YYYY)');
      END IF;
      l_per  := TO_CHAR(l_pd,'MM-YYYY');
      l_year := NVL(l_year, EXTRACT(YEAR FROM l_pd));
      UPDATE prod.dct_gl_budget_cashflow
         SET cf_amount = l_amt, period_date = l_pd,
             source_file = NVL(l_src, source_file),
             loaded_by = l_user, loaded_at = SYSTIMESTAMP
       WHERE cc_string = l_e||'.'||l_pg||'.'||l_cc||'.'||l_bg||'.'||l_ac||'.'||l_es||'.'
                         ||l_ap||'.'||l_ic||'.'||l_f1||'.'||l_f2
         AND budget_year = l_year AND accounting_period = l_per AND cf_type = l_typ;
      IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO prod.dct_gl_budget_cashflow
              (entity_code, program_code, cost_center_code, budget_group_code,
               account_code, entity_specific_code, appropriation_code,
               intercompany_code, future1_code, future2_code,
               budget_year, accounting_period, period_date, cf_type, cf_amount,
               source_file, loaded_by)
        VALUES (l_e, l_pg, l_cc, l_bg, l_ac, l_es, l_ap, l_ic, l_f1, l_f2,
                l_year, l_per, l_pd, l_typ, l_amt, l_src, l_user);
      END IF;
      l_ok := l_ok + 1;
      APEX_JSON.open_object;
      APEX_JSON.write('row', i);
      APEX_JSON.write('status', 'OK');
      APEX_JSON.close_object;
    EXCEPTION WHEN OTHERS THEN
      l_err := l_err + 1;
      APEX_JSON.open_object;
      APEX_JSON.write('row', i);
      APEX_JSON.write('status', 'ERROR');
      APEX_JSON.write('error', SUBSTR(SQLERRM,1,300));
      APEX_JSON.close_object;
    END;
  END LOOP;
  COMMIT;
  APEX_JSON.close_array;
  APEX_JSON.write('ok', l_ok);
  APEX_JSON.write('errors', l_err);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('cashflow/projects');
    def_handler('cashflow/projects', 'POST', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_cnt   NUMBER;
  l_src   VARCHAR2(200);
  l_pj    VARCHAR2(30); l_tk VARCHAR2(60); l_et VARCHAR2(255);
  l_year  NUMBER; l_per VARCHAR2(20); l_typ VARCHAR2(30); l_amt NUMBER;
  l_pd    DATE;
  l_ok NUMBER := 0; l_err NUMBER := 0;
  FUNCTION parse_period(p VARCHAR2) RETURN DATE IS
    d DATE;
    FUNCTION ok(x DATE) RETURN BOOLEAN IS
    BEGIN RETURN x IS NOT NULL AND EXTRACT(YEAR FROM x) BETWEEN 1990 AND 2100; END;
  BEGIN
    d := TO_DATE(p DEFAULT NULL ON CONVERSION ERROR, 'FXMM-YYYY');
    IF NOT ok(d) THEN d := TO_DATE(p DEFAULT NULL ON CONVERSION ERROR, 'FXMON-YYYY', q'#NLS_DATE_LANGUAGE=ENGLISH#'); END IF;
    IF NOT ok(d) THEN d := TO_DATE(p DEFAULT NULL ON CONVERSION ERROR, 'FXMON-YY',   q'#NLS_DATE_LANGUAGE=ENGLISH#'); END IF;
    IF NOT ok(d) THEN d := TO_DATE(p DEFAULT NULL ON CONVERSION ERROR, 'FXYYYY-MM'); END IF;
    IF NOT ok(d) THEN RETURN NULL; END IF;
    RETURN d;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_MANAGE_CASHFLOW', 'SYS_ADMIN', 'GL') = FALSE THEN
    dct_rest.err(403,'GL_MANAGE_CASHFLOW required'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_cnt := NVL(APEX_JSON.get_count(p_path=>'rows'), 0);
  IF l_cnt = 0 THEN dct_rest.err(400,'rows[] is required'); RETURN; END IF;
  IF l_cnt > 500 THEN dct_rest.err(400,'maximum 500 rows per request'); RETURN; END IF;
  l_src := SUBSTR(APEX_JSON.get_varchar2(p_path=>'sourceFile'),1,200);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('results');
  FOR i IN 1 .. l_cnt LOOP
    BEGIN
      l_pj  := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].project', p0=>i)),1,30);
      l_tk  := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].task',    p0=>i)),1,60);
      l_et  := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].etype',   p0=>i)),1,255);
      l_per := TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].period', p0=>i));
      l_typ := UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].cfType', p0=>i)));
      l_amt := APEX_JSON.get_number(p_path=>'rows[%d].amount', p0=>i);
      l_year := APEX_JSON.get_number(p_path=>'rows[%d].year', p0=>i);
      IF l_pj IS NULL OR l_tk IS NULL OR l_et IS NULL
         OR l_per IS NULL OR l_typ IS NULL OR l_amt IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001,'project, task, etype, period, cfType and amount are required');
      END IF;
      IF l_typ NOT IN ('APPROVED','REVISED') THEN
        RAISE_APPLICATION_ERROR(-20001,'cfType must be APPROVED or REVISED');
      END IF;
      l_pd := parse_period(l_per);
      IF l_pd IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001,'period not recognised (use MM-YYYY)');
      END IF;
      l_per  := TO_CHAR(l_pd,'MM-YYYY');
      l_year := NVL(l_year, EXTRACT(YEAR FROM l_pd));
      UPDATE prod.dct_project_cashflow
         SET cf_amount = l_amt, period_date = l_pd,
             source_file = NVL(l_src, source_file),
             loaded_by = l_user, loaded_at = SYSTIMESTAMP
       WHERE project_number = l_pj AND task_number = l_tk AND expenditure_type = l_et
         AND budget_year = l_year AND accounting_period = l_per AND cf_type = l_typ;
      IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO prod.dct_project_cashflow
              (project_number, task_number, expenditure_type,
               budget_year, accounting_period, period_date, cf_type, cf_amount,
               source_file, loaded_by)
        VALUES (l_pj, l_tk, l_et, l_year, l_per, l_pd, l_typ, l_amt, l_src, l_user);
      END IF;
      l_ok := l_ok + 1;
      APEX_JSON.open_object;
      APEX_JSON.write('row', i);
      APEX_JSON.write('status', 'OK');
      APEX_JSON.close_object;
    EXCEPTION WHEN OTHERS THEN
      l_err := l_err + 1;
      APEX_JSON.open_object;
      APEX_JSON.write('row', i);
      APEX_JSON.write('status', 'ERROR');
      APEX_JSON.write('error', SUBSTR(SQLERRM,1,300));
      APEX_JSON.close_object;
    END;
  END LOOP;
  COMMIT;
  APEX_JSON.close_array;
  APEX_JSON.write('ok', l_ok);
  APEX_JSON.write('errors', l_err);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('cashflow/summary');
    def_handler('cashflow/summary', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_DOF_REPORTS', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_DOF_REPORTS required'); RETURN;
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('glYears');
  FOR r IN (
    SELECT budget_year, cf_type,
           COUNT(*) AS n_rows,
           COUNT(DISTINCT cc_string) AS n_combos,
           COUNT(DISTINCT accounting_period) AS n_periods,
           SUM(cf_amount) AS total_amt,
           SUM(CASE WHEN chapter_mapped = 'Y' THEN 1 ELSE 0 END) AS ch_mapped
      FROM prod.dct_gl_cashflow_v
     GROUP BY budget_year, cf_type
     ORDER BY budget_year DESC, cf_type) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('year',          r.budget_year);
    APEX_JSON.write('cfType',        r.cf_type);
    APEX_JSON.write('rows',          r.n_rows);
    APEX_JSON.write('combinations',  r.n_combos);
    APEX_JSON.write('periods',       r.n_periods);
    APEX_JSON.write('totalAmount',   NVL(r.total_amt,0));
    APEX_JSON.write('chapterMapped', r.ch_mapped);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('projectYears');
  FOR r IN (
    SELECT budget_year, cf_type,
           COUNT(*) AS n_rows,
           COUNT(DISTINCT project_number) AS n_projects,
           COUNT(DISTINCT accounting_period) AS n_periods,
           SUM(cf_amount) AS total_amt
      FROM prod.dct_project_cashflow
     GROUP BY budget_year, cf_type
     ORDER BY budget_year DESC, cf_type) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('year',        r.budget_year);
    APEX_JSON.write('cfType',      r.cf_type);
    APEX_JSON.write('rows',        r.n_rows);
    APEX_JSON.write('projects',    r.n_projects);
    APEX_JSON.write('periods',     r.n_periods);
    APEX_JSON.write('totalAmount', NVL(r.total_amt,0));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('unmappedAppr');
  FOR r IN (
    SELECT appropriation_code, COUNT(*) AS n, SUM(ABS(cf_amount)) AS amt
      FROM prod.dct_gl_cashflow_v
     WHERE chapter_mapped = 'N'
     GROUP BY appropriation_code ORDER BY SUM(ABS(cf_amount)) DESC
     FETCH FIRST 10 ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('appropriation', r.appropriation_code);
    APEX_JSON.write('rows',          r.n);
    APEX_JSON.write('absAmount',     NVL(r.amt,0));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END setup_gl_dof_ords_a;
/

SHOW ERRORS

EXECUTE setup_gl_dof_ords_a
DROP PROCEDURE setup_gl_dof_ords_a;

PROMPT gl.rest cashflow endpoints published (/gl/cashflow*).

CREATE OR REPLACE PROCEDURE setup_gl_dof_ords_b AS

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

    def_template('dof/yoy');
    def_handler('dof/yoy', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_year NUMBER := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_per  VARCHAR2(10) := [COLON]period;
  l_me   NUMBER;
  l_n    NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_DOF_REPORTS', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_DOF_REPORTS required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  IF l_per IS NOT NULL AND NOT REGEXP_LIKE(l_per, '^(0[1-9]|1[0-2])-[0-9]{4}$') THEN
    dct_rest.err(400,'period must be MM-YYYY'); RETURN;
  END IF;
  IF l_per IS NOT NULL THEN
    l_me := TO_NUMBER(SUBSTR(l_per,1,2));
  ELSE
    SELECT NVL(MAX(period_month),12) INTO l_me
      FROM prod.dct_gl_dof_fact_v WHERE period_year = l_year;
    l_per := LPAD(l_me,2,'0')||'-'||l_year;
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  APEX_JSON.write('period', l_per);
  APEX_JSON.open_array('rows');
  FOR r IN (
    WITH cur AS (
      SELECT entity_code, MAX(entity_desc) AS entity_desc,
             chapter_code, MAX(chapter_name) AS chapter_name,
             ap, MAX(appr_desc) AS appr_desc,
             ac, MAX(account_desc) AS account_desc,
             SUM(rev_budget) AS rev_budget,
             SUM(actual_ytd) AS actual_ytd
        FROM (
        SELECT f.entity_code, f.entity_desc, f.chapter_code, f.chapter_name,
               f.appropriation_code AS ap, f.appropriation_desc AS appr_desc,
               f.account_code AS ac, f.account_desc AS account_desc,
               f.total_budget AS rev_budget,
               CASE WHEN f.period_month <= l_me THEN f.expenditures ELSE 0 END AS actual_ytd
          FROM prod.dct_gl_dof_fact_v f
         WHERE f.period_year = l_year
           AND SUBSTR(f.account_code,1,1) = '4'
        UNION ALL
        -- 2026-08-03: selected year in the legacy EBS era (2016-2025) -- the
        -- report runs against ALL loaded fiscal years. STORED YTD slices
        -- (platform rule: YTD is stored data with opening balances, NEVER
        -- derived from PTD): per combination take the latest period <= cutoff
        -- (13-period sorts after 12). Budget = FY slice, Actual = YTD slice.
        -- bg-1 platform rule; descriptions resolve via apr/acc/chp fallbacks.
        SELECT eb.entity_code, CAST(NULL AS VARCHAR2(240)),
               CAST(NULL AS VARCHAR2(60)), CAST(NULL AS VARCHAR2(240)),
               eb.ap, eb.appr_desc, eb.ac, eb.account_desc,
               NVL(eb.bud,0), NVL(eb.act,0)
          FROM (
            SELECT MAX(e.entity_code) AS entity_code,
                   LPAD(MAX(e.fusion_appropriation),6,'0') AS ap,
                   MAX(e.fusion_appropriation_desc) AS appr_desc,
                   LPAD(MAX(e.fusion_account),6,'0') AS ac,
                   MAX(e.fusion_account_desc) AS account_desc,
                   MAX(e.budget_ytd) KEEP (DENSE_RANK LAST ORDER BY e.period_date) AS bud,
                   MAX(CASE WHEN EXTRACT(MONTH FROM e.period_date) <= l_me THEN e.actual_ytd END)
                     KEEP (DENSE_RANK LAST ORDER BY CASE WHEN EXTRACT(MONTH FROM e.period_date) <= l_me THEN e.period_date ELSE DATE '0001-01-01' END) AS act
              FROM prod.dct_ebs_balance_mapped_v e
             WHERE e.period_year = l_year AND e.fusion_account LIKE '4%'
               AND e.budget_code = '1'
             GROUP BY e.ebs_combination
          ) eb
        )
       GROUP BY entity_code, chapter_code, ap, ac
    ),
    pri AS (
      SELECT ap, ac, SUM(fy) AS prior_fy, SUM(ytd) AS prior_ytd FROM (
        SELECT f.appropriation_code AS ap, f.account_code AS ac,
               f.expenditures AS fy,
               CASE WHEN f.period_month <= l_me THEN f.expenditures ELSE 0 END AS ytd
          FROM prod.dct_gl_dof_fact_v f
         WHERE f.period_year = l_year - 1
           AND SUBSTR(f.account_code,1,1) = '4'
        UNION ALL
        -- 2026-08-03: prior-year EBS leg on STORED YTD slices too (was PTD
        -- sums) so a 2026 run's prior figures MATCH a 2025 run's current
        -- figures byte-for-byte.
        SELECT eb.ap, eb.ac, NVL(eb.fy,0), NVL(eb.ytd,0)
          FROM (
            SELECT LPAD(MAX(e.fusion_appropriation),6,'0') AS ap,
                   LPAD(MAX(e.fusion_account),6,'0') AS ac,
                   MAX(e.actual_ytd) KEEP (DENSE_RANK LAST ORDER BY e.period_date) AS fy,
                   MAX(CASE WHEN EXTRACT(MONTH FROM e.period_date) <= l_me THEN e.actual_ytd END)
                     KEEP (DENSE_RANK LAST ORDER BY CASE WHEN EXTRACT(MONTH FROM e.period_date) <= l_me THEN e.period_date ELSE DATE '0001-01-01' END) AS ytd
              FROM prod.dct_ebs_balance_mapped_v e
             WHERE e.period_year = l_year - 1 AND e.fusion_account LIKE '4%'
               -- PLATFORM RULE 2026-08-02: Budget Group = '1' (Current
               -- operations) in all calc; DOF submissions are bg-1 by
               -- definition (Fusion leg inherits bg=1 from the fact view).
               AND e.budget_code = '1'
             GROUP BY e.ebs_combination
          ) eb
      ) GROUP BY ap, ac
    ),
    e1 AS (
      SELECT MAX(entity_code) AS ec, MAX(entity_desc) AS ed FROM cur
    ),
    apr AS (
      SELECT appropriation_code, MAX(appropriation_desc) AS appropriation_desc
      FROM prod.dct_gl_coa_snap WHERE appropriation_code IS NOT NULL GROUP BY appropriation_code
    ),
    acc AS (
      SELECT account_code, MAX(account_desc) AS account_desc
      FROM prod.dct_gl_coa_snap WHERE account_code IS NOT NULL GROUP BY account_code
    ),
    chp AS (
      SELECT m.segment_value AS ap, MAX(v.value_code) AS chapter_code, MAX(v.name_en) AS chapter_name
      FROM prod.dct_gl_seg_class_map m
      JOIN prod.dct_gl_class_value v ON v.class_value_id = m.class_value_id
      WHERE m.class_type_code = 'CHAPTER'
        AND TRUNC(SYSDATE) BETWEEN m.start_date AND NVL(m.end_date, DATE '9999-12-31')
      GROUP BY m.segment_value
    ),
    d AS (
      SELECT NVL(j.entity_code, e1.ec) AS entity_code,
             NVL(j.entity_desc, e1.ed) AS entity_desc,
             NVL(j.chapter_code, ch.chapter_code) AS chapter_code,
             NVL(j.chapter_name, ch.chapter_name) AS chapter_name,
             j.ap, NVL(j.appr_desc, ap2.appropriation_desc) AS appr_desc,
             j.ac, NVL(j.account_desc, ac2.account_desc) AS account_desc,
             j.rev_budget, j.actual_ytd, j.prior_fy, j.prior_ytd
        FROM (
          SELECT NVL(c.ap, p.ap) AS ap, NVL(c.ac, p.ac) AS ac,
                 c.entity_code, c.entity_desc, c.chapter_code, c.chapter_name,
                 c.appr_desc, c.account_desc,
                 NVL(c.rev_budget,0) AS rev_budget, NVL(c.actual_ytd,0) AS actual_ytd,
                 NVL(p.prior_fy,0) AS prior_fy, NVL(p.prior_ytd,0) AS prior_ytd
            FROM cur c FULL OUTER JOIN pri p
              ON p.ap = c.ap AND p.ac = c.ac
        ) j
        CROSS JOIN e1
        LEFT JOIN apr ap2 ON ap2.appropriation_code = j.ap
        LEFT JOIN acc ac2 ON ac2.account_code = j.ac
        LEFT JOIN chp ch  ON ch.ap = j.ap
       WHERE ABS(j.rev_budget)+ABS(j.actual_ytd)+ABS(j.prior_fy)+ABS(j.prior_ytd) > 0.005
    ),
    ebs AS (
      SELECT fusion_value AS fv,
             LISTAGG(ebs_value, ' / ') WITHIN GROUP (ORDER BY ebs_value) AS codes
      FROM prod.dct_gl_ebs_map WHERE segment_type = 'ACCOUNT' AND is_active = 'Y'
      GROUP BY fusion_value
    ),
    nt AS (
      SELECT appropriation_code AS ap, account_code AS ac, note_text
      FROM prod.dct_gl_dof_note
      WHERE budget_year = l_year AND note_type = 'REASON'
        AND account_code IS NOT NULL AND quarter IS NULL
    )
    SELECT CASE WHEN GROUPING(d.chapter_code) = 1 THEN 'GRAND'
                WHEN GROUPING(d.ap) = 1 THEN 'CHTOTAL'
                ELSE 'DETAIL' END AS row_kind,
           CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.entity_code) END AS entity_code,
           CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.entity_desc) END AS entity_desc,
           d.chapter_code,
           CASE WHEN GROUPING(d.chapter_code) = 1 THEN 'Grand Total'
                WHEN GROUPING(d.ap) = 1 THEN NVL(MAX(d.chapter_name),'Unclassified')||' Total'
                ELSE MAX(d.chapter_name) END AS chapter_label,
           d.ap,
           CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.appr_desc) END AS appr_desc,
           d.ac,
           CASE WHEN GROUPING(d.ac) = 0 THEN MAX(d.account_desc) END AS account_desc,
           CASE WHEN GROUPING(d.ac) = 0 THEN MAX(ebs.codes) END AS ebs_codes,
           SUM(d.prior_fy)   AS prior_fy,
           SUM(d.rev_budget) AS rev_budget,
           SUM(d.actual_ytd) AS actual_ytd,
           SUM(d.prior_ytd)  AS prior_ytd,
           SUM(d.actual_ytd) - SUM(d.prior_ytd) AS variance,
           CASE WHEN GROUPING(d.ac) = 0 THEN MAX(nt.note_text) END AS reason
      FROM d
      LEFT JOIN ebs ON ebs.fv = d.ac
      LEFT JOIN nt  ON nt.ap = d.ap AND nt.ac = d.ac
     GROUP BY GROUPING SETS (
       (d.chapter_code, d.ap, d.ac),
       (d.chapter_code),
       ()
     )
     ORDER BY GROUPING(d.chapter_code), d.chapter_code NULLS LAST,
              GROUPING(d.ap), d.ap, d.ac
  ) LOOP
    l_n := l_n + 1;
    APEX_JSON.open_object;
    APEX_JSON.write('rowType',    r.row_kind);
    APEX_JSON.write('entity',     NVL(r.entity_code,''));
    APEX_JSON.write('entityName', NVL(r.entity_desc,''));
    APEX_JSON.write('chapter',    NVL(r.chapter_label,''));
    APEX_JSON.write('apprCode',   NVL(r.ap,''));
    APEX_JSON.write('apprDesc',   NVL(r.appr_desc,''));
    APEX_JSON.write('ebsAccount', NVL(r.ebs_codes,''));
    APEX_JSON.write('accountCode', NVL(r.ac,''));
    APEX_JSON.write('accountName', NVL(r.account_desc,''));
    APEX_JSON.write('priorFy',    NVL(r.prior_fy,0));
    APEX_JSON.write('revBudget',  NVL(r.rev_budget,0));
    APEX_JSON.write('actualYtd',  NVL(r.actual_ytd,0));
    APEX_JSON.write('priorYtd',   NVL(r.prior_ytd,0));
    APEX_JSON.write('variance',   NVL(r.variance,0));
    APEX_JSON.write('reason',     NVL(r.reason,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('total', l_n);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('dof/butil');
    def_handler('dof/butil', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_year NUMBER := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_per  VARCHAR2(10) := [COLON]period;
  l_me   NUMBER;
  l_n    NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_DOF_REPORTS', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_DOF_REPORTS required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  IF l_per IS NOT NULL AND NOT REGEXP_LIKE(l_per, '^(0[1-9]|1[0-2])-[0-9]{4}$') THEN
    dct_rest.err(400,'period must be MM-YYYY'); RETURN;
  END IF;
  IF l_per IS NOT NULL THEN
    l_me := TO_NUMBER(SUBSTR(l_per,1,2));
  ELSE
    SELECT NVL(MAX(period_month),12) INTO l_me
      FROM prod.dct_gl_dof_fact_v WHERE period_year = l_year;
    l_per := LPAD(l_me,2,'0')||'-'||l_year;
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  APEX_JSON.write('period', l_per);
  APEX_JSON.open_array('rows');
  FOR r IN (
    WITH cur AS (
      SELECT entity_code, MAX(entity_desc) AS entity_desc,
             chapter_code, MAX(chapter_name) AS chapter_name,
             ap, MAX(appr_desc) AS appr_desc,
             SUM(init_budget) AS init_budget,
             SUM(rev_budget)  AS rev_budget,
             SUM(actual_ytd)  AS actual_ytd
        FROM (
        SELECT f.entity_code, f.entity_desc, f.chapter_code, f.chapter_name,
               f.appropriation_code AS ap, f.appropriation_desc AS appr_desc,
               f.initial_budget AS init_budget,
               f.total_budget   AS rev_budget,
               CASE WHEN f.period_month <= l_me THEN f.expenditures ELSE 0 END AS actual_ytd
          FROM prod.dct_gl_dof_fact_v f
         WHERE f.period_year = l_year
           AND SUBSTR(f.account_code,1,1) = '4'
        UNION ALL
        -- 2026-08-03: legacy EBS era (2016-2025) -- STORED YTD slices (never
        -- PTD-derived); EBS carries ONE budget measure, so Initial = Revised
        -- for prior years (FY slice); Actual = latest slice <= cutoff; bg-1.
        SELECT eb.entity_code, CAST(NULL AS VARCHAR2(240)),
               CAST(NULL AS VARCHAR2(60)), CAST(NULL AS VARCHAR2(240)),
               eb.ap, eb.appr_desc,
               NVL(eb.bud,0), NVL(eb.bud,0), NVL(eb.act,0)
          FROM (
            SELECT MAX(e.entity_code) AS entity_code,
                   LPAD(MAX(e.fusion_appropriation),6,'0') AS ap,
                   MAX(e.fusion_appropriation_desc) AS appr_desc,
                   MAX(e.budget_ytd) KEEP (DENSE_RANK LAST ORDER BY e.period_date) AS bud,
                   MAX(CASE WHEN EXTRACT(MONTH FROM e.period_date) <= l_me THEN e.actual_ytd END)
                     KEEP (DENSE_RANK LAST ORDER BY CASE WHEN EXTRACT(MONTH FROM e.period_date) <= l_me THEN e.period_date ELSE DATE '0001-01-01' END) AS act
              FROM prod.dct_ebs_balance_mapped_v e
             WHERE e.period_year = l_year AND e.fusion_account LIKE '4%'
               AND e.budget_code = '1'
             GROUP BY e.ebs_combination
          ) eb
        )
       GROUP BY entity_code, chapter_code, ap
    ),
    cf AS (
      SELECT v.appropriation_norm AS ap,
             SUM(CASE WHEN v.cf_type = 'APPROVED' AND v.period_month <= l_me THEN v.cf_amount ELSE 0 END) AS init_cf_ytd,
             SUM(CASE WHEN v.cf_type = 'REVISED'  AND v.period_month <= l_me THEN v.cf_amount ELSE 0 END) AS rev_cf_ytd,
             SUM(CASE WHEN v.cf_type = 'APPROVED' THEN 1 ELSE 0 END) AS n_app,
             SUM(CASE WHEN v.cf_type = 'REVISED'  THEN 1 ELSE 0 END) AS n_rev
        FROM prod.dct_gl_cashflow_v v
       WHERE v.budget_year = l_year
       GROUP BY v.appropriation_norm
    ),
    e1 AS (
      SELECT MAX(entity_code) AS ec, MAX(entity_desc) AS ed FROM cur
    ),
    apr AS (
      SELECT appropriation_code, MAX(appropriation_desc) AS appropriation_desc
      FROM prod.dct_gl_coa_snap WHERE appropriation_code IS NOT NULL GROUP BY appropriation_code
    ),
    chp AS (
      SELECT m.segment_value AS ap, MAX(v.value_code) AS chapter_code, MAX(v.name_en) AS chapter_name
      FROM prod.dct_gl_seg_class_map m
      JOIN prod.dct_gl_class_value v ON v.class_value_id = m.class_value_id
      WHERE m.class_type_code = 'CHAPTER'
        AND TRUNC(SYSDATE) BETWEEN m.start_date AND NVL(m.end_date, DATE '9999-12-31')
      GROUP BY m.segment_value
    ),
    nt AS (
      SELECT appropriation_code AS ap, note_text
      FROM prod.dct_gl_dof_note
      WHERE budget_year = l_year AND note_type = 'REASON'
        AND account_code IS NULL AND quarter IS NULL
    )
    -- 2026-08-03: chapter sub-total + grand-total rows via GROUPING SETS
    -- (same shape as the yoy dataset -- rowType DETAIL/CHTOTAL/GRAND;
    -- utilization recomputed at each total level, notes on detail only)
    SELECT CASE WHEN GROUPING(d.chapter_code) = 1 THEN 'GRAND'
                WHEN GROUPING(d.ap) = 1 THEN 'CHTOTAL'
                ELSE 'DETAIL' END AS row_kind,
           CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.entity_code) END AS entity_code,
           CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.entity_desc) END AS entity_desc,
           d.chapter_code,
           CASE WHEN GROUPING(d.chapter_code) = 1 THEN 'Grand Total'
                WHEN GROUPING(d.ap) = 1 THEN NVL(MAX(d.chapter_name),'Unclassified')||' Total'
                ELSE MAX(d.chapter_name) END AS chapter_label,
           d.ap,
           CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.appr_desc) END AS appr_desc,
           SUM(d.init_budget) AS init_budget,
           SUM(d.rev_budget)  AS rev_budget,
           SUM(d.init_cf_ytd) AS init_cf_ytd,
           SUM(d.rev_cf_ytd)  AS rev_cf_ytd,
           SUM(d.actual_ytd)  AS actual_ytd,
           SUM(d.rev_cf_ytd) - SUM(d.actual_ytd) AS variance,
           CASE WHEN SUM(d.rev_cf_ytd) <> 0
                THEN ROUND(100 * SUM(d.actual_ytd) / SUM(d.rev_cf_ytd), 1) END AS util_pct,
           CASE WHEN MAX(d.has_cf) = 1 THEN 'Y' ELSE 'N' END AS has_cf,
           CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.note_text) END AS reason
      FROM (
        SELECT NVL(c.entity_code, e1.ec) AS entity_code,
               NVL(c.entity_desc, e1.ed) AS entity_desc,
               NVL(c.chapter_code, ch.chapter_code) AS chapter_code,
               NVL(c.chapter_name, ch.chapter_name) AS chapter_name,
               NVL(c.ap, f.ap) AS ap,
               NVL(c.appr_desc, ap2.appropriation_desc) AS appr_desc,
               NVL(c.init_budget,0) AS init_budget,
               NVL(c.rev_budget,0)  AS rev_budget,
               NVL(f.init_cf_ytd,0) AS init_cf_ytd,
               NVL(f.rev_cf_ytd,0)  AS rev_cf_ytd,
               NVL(c.actual_ytd,0)  AS actual_ytd,
               CASE WHEN NVL(f.n_rev,0) + NVL(f.n_app,0) > 0 THEN 1 ELSE 0 END AS has_cf,
               nt.note_text
          FROM cur c
          FULL OUTER JOIN cf f ON f.ap = c.ap
          CROSS JOIN e1
          LEFT JOIN apr ap2 ON ap2.appropriation_code = NVL(c.ap, f.ap)
          LEFT JOIN chp ch  ON ch.ap = NVL(c.ap, f.ap)
          LEFT JOIN nt      ON nt.ap = NVL(c.ap, f.ap)
      ) d
     GROUP BY GROUPING SETS (
       (d.chapter_code, d.ap),
       (d.chapter_code),
       ()
     )
     ORDER BY GROUPING(d.chapter_code), d.chapter_code NULLS LAST,
              GROUPING(d.ap), d.ap
  ) LOOP
    l_n := l_n + 1;
    APEX_JSON.open_object;
    APEX_JSON.write('rowType',    r.row_kind);
    APEX_JSON.write('entity',     NVL(r.entity_code,''));
    APEX_JSON.write('entityName', NVL(r.entity_desc,''));
    APEX_JSON.write('chapter',    NVL(r.chapter_label,''));
    APEX_JSON.write('apprCode',   NVL(r.ap,''));
    APEX_JSON.write('apprDesc',   NVL(r.appr_desc,''));
    APEX_JSON.write('initBudget', NVL(r.init_budget,0));
    APEX_JSON.write('revBudget',  NVL(r.rev_budget,0));
    APEX_JSON.write('initCfYtd',  NVL(r.init_cf_ytd,0));
    APEX_JSON.write('revCfYtd',   NVL(r.rev_cf_ytd,0));
    APEX_JSON.write('actualYtd',  NVL(r.actual_ytd,0));
    APEX_JSON.write('variance',   NVL(r.variance,0));
    IF r.util_pct IS NOT NULL THEN APEX_JSON.write('utilPct', r.util_pct); END IF;
    APEX_JSON.write('hasCf',      r.has_cf);
    APEX_JSON.write('reason',     NVL(r.reason,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('total', l_n);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('dof/quarterly');
    def_handler('dof/quarterly', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_year NUMBER := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_n    NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_DOF_REPORTS', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_DOF_REPORTS required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  APEX_JSON.open_array('rows');
  FOR r IN (
    WITH cur AS (
      SELECT entity_code, MAX(entity_desc) AS entity_desc,
             chapter_code, MAX(chapter_name) AS chapter_name,
             ap, MAX(appr_desc) AS appr_desc,
             SUM(approved_budget) AS approved_budget,
             SUM(rev_budget_q1) AS rev_budget_q1,
             SUM(rev_budget_q2) AS rev_budget_q2,
             SUM(act1) AS act1, SUM(act2) AS act2,
             SUM(act3) AS act3, SUM(act4) AS act4
        FROM (
        SELECT f.entity_code, f.entity_desc, f.chapter_code, f.chapter_name,
               f.appropriation_code AS ap, f.appropriation_desc AS appr_desc,
               f.initial_budget AS approved_budget,
               CASE WHEN f.period_month <= 3 THEN f.total_budget ELSE 0 END AS rev_budget_q1,
               CASE WHEN f.period_month <= 6 THEN f.total_budget ELSE 0 END AS rev_budget_q2,
               CASE WHEN f.period_quarter = 1 THEN f.expenditures ELSE 0 END AS act1,
               CASE WHEN f.period_quarter = 2 THEN f.expenditures ELSE 0 END AS act2,
               CASE WHEN f.period_quarter = 3 THEN f.expenditures ELSE 0 END AS act3,
               CASE WHEN f.period_quarter = 4 THEN f.expenditures ELSE 0 END AS act4
          FROM prod.dct_gl_dof_fact_v f
         WHERE f.period_year = l_year
           AND SUBSTR(f.account_code,1,1) = '4'
        UNION ALL
        -- 2026-08-03: legacy EBS era (2016-2025) -- STORED YTD slices: the one
        -- EBS budget measure serves as Approved (FY slice) and cumulative
        -- Revised (Q1/Q2 slices); quarterly actuals = YTD slice differences
        -- (Qn end minus Q(n-1) end); bg-1 platform rule.
        SELECT eb.entity_code, CAST(NULL AS VARCHAR2(240)),
               CAST(NULL AS VARCHAR2(60)), CAST(NULL AS VARCHAR2(240)),
               eb.ap, eb.appr_desc,
               NVL(eb.budf,0), NVL(eb.bud3,0), NVL(eb.bud6,0),
               NVL(eb.a3,0),
               NVL(eb.a6,0) - NVL(eb.a3,0),
               NVL(eb.a9,0) - NVL(eb.a6,0),
               NVL(eb.af,0) - NVL(eb.a9,0)
          FROM (
            SELECT MAX(e.entity_code) AS entity_code,
                   LPAD(MAX(e.fusion_appropriation),6,'0') AS ap,
                   MAX(e.fusion_appropriation_desc) AS appr_desc,
                   MAX(e.budget_ytd) KEEP (DENSE_RANK LAST ORDER BY e.period_date) AS budf,
                   MAX(CASE WHEN EXTRACT(MONTH FROM e.period_date) <= 3 THEN e.budget_ytd END)
                     KEEP (DENSE_RANK LAST ORDER BY CASE WHEN EXTRACT(MONTH FROM e.period_date) <= 3 THEN e.period_date ELSE DATE '0001-01-01' END) AS bud3,
                   MAX(CASE WHEN EXTRACT(MONTH FROM e.period_date) <= 6 THEN e.budget_ytd END)
                     KEEP (DENSE_RANK LAST ORDER BY CASE WHEN EXTRACT(MONTH FROM e.period_date) <= 6 THEN e.period_date ELSE DATE '0001-01-01' END) AS bud6,
                   MAX(CASE WHEN EXTRACT(MONTH FROM e.period_date) <= 3 THEN e.actual_ytd END)
                     KEEP (DENSE_RANK LAST ORDER BY CASE WHEN EXTRACT(MONTH FROM e.period_date) <= 3 THEN e.period_date ELSE DATE '0001-01-01' END) AS a3,
                   MAX(CASE WHEN EXTRACT(MONTH FROM e.period_date) <= 6 THEN e.actual_ytd END)
                     KEEP (DENSE_RANK LAST ORDER BY CASE WHEN EXTRACT(MONTH FROM e.period_date) <= 6 THEN e.period_date ELSE DATE '0001-01-01' END) AS a6,
                   MAX(CASE WHEN EXTRACT(MONTH FROM e.period_date) <= 9 THEN e.actual_ytd END)
                     KEEP (DENSE_RANK LAST ORDER BY CASE WHEN EXTRACT(MONTH FROM e.period_date) <= 9 THEN e.period_date ELSE DATE '0001-01-01' END) AS a9,
                   MAX(e.actual_ytd) KEEP (DENSE_RANK LAST ORDER BY e.period_date) AS af
              FROM prod.dct_ebs_balance_mapped_v e
             WHERE e.period_year = l_year AND e.fusion_account LIKE '4%'
               AND e.budget_code = '1'
             GROUP BY e.ebs_combination
          ) eb
        )
       GROUP BY entity_code, chapter_code, ap
    ),
    cf AS (
      SELECT v.appropriation_norm AS ap,
             SUM(CASE WHEN v.cf_type = 'APPROVED' AND v.period_quarter = 1 THEN v.cf_amount ELSE 0 END) AS acf1,
             SUM(CASE WHEN v.cf_type = 'APPROVED' AND v.period_quarter = 2 THEN v.cf_amount ELSE 0 END) AS acf2,
             SUM(CASE WHEN v.cf_type = 'APPROVED' AND v.period_quarter = 3 THEN v.cf_amount ELSE 0 END) AS acf3,
             SUM(CASE WHEN v.cf_type = 'APPROVED' AND v.period_quarter = 4 THEN v.cf_amount ELSE 0 END) AS acf4,
             SUM(CASE WHEN v.cf_type = 'REVISED'  AND v.period_quarter = 1 THEN v.cf_amount ELSE 0 END) AS rcf1,
             SUM(CASE WHEN v.cf_type = 'REVISED'  AND v.period_quarter = 2 THEN v.cf_amount ELSE 0 END) AS rcf2,
             SUM(CASE WHEN v.cf_type = 'REVISED'  AND v.period_quarter = 3 THEN v.cf_amount ELSE 0 END) AS rcf3,
             SUM(CASE WHEN v.cf_type = 'REVISED'  AND v.period_quarter = 4 THEN v.cf_amount ELSE 0 END) AS rcf4
        FROM prod.dct_gl_cashflow_v v
       WHERE v.budget_year = l_year
       GROUP BY v.appropriation_norm
    ),
    e1 AS (
      SELECT MAX(entity_code) AS ec, MAX(entity_desc) AS ed FROM cur
    ),
    apr AS (
      SELECT appropriation_code, MAX(appropriation_desc) AS appropriation_desc
      FROM prod.dct_gl_coa_snap WHERE appropriation_code IS NOT NULL GROUP BY appropriation_code
    ),
    chp AS (
      SELECT m.segment_value AS ap, MAX(v.value_code) AS chapter_code, MAX(v.name_en) AS chapter_name
      FROM prod.dct_gl_seg_class_map m
      JOIN prod.dct_gl_class_value v ON v.class_value_id = m.class_value_id
      WHERE m.class_type_code = 'CHAPTER'
        AND TRUNC(SYSDATE) BETWEEN m.start_date AND NVL(m.end_date, DATE '9999-12-31')
      GROUP BY m.segment_value
    ),
    nt AS (
      SELECT appropriation_code AS ap,
             MAX(CASE WHEN note_type = 'REASON' AND quarter = 1 THEN note_text END) AS rsn1,
             MAX(CASE WHEN note_type = 'REASON' AND quarter = 2 THEN note_text END) AS rsn2,
             MAX(CASE WHEN note_type = 'REASON' AND quarter = 3 THEN note_text END) AS rsn3,
             MAX(CASE WHEN note_type = 'REASON' AND quarter = 4 THEN note_text END) AS rsn4,
             MAX(CASE WHEN note_type = 'REMARK' AND quarter IS NULL THEN note_text END) AS remark
      FROM prod.dct_gl_dof_note
      WHERE budget_year = l_year AND account_code IS NULL
      GROUP BY appropriation_code
    )
    -- 2026-08-03: chapter sub-total + grand-total rows via GROUPING SETS
    -- (rowType DETAIL/CHTOTAL/GRAND; quarter variances/pcts recomputed from
    -- the summed cashflow/actuals; reasons + remarks on detail rows only)
    SELECT CASE WHEN GROUPING(d.chapter_code) = 1 THEN 'GRAND'
                WHEN GROUPING(d.ap) = 1 THEN 'CHTOTAL'
                ELSE 'DETAIL' END AS row_kind,
           CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.entity_code) END AS entity_code,
           CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.entity_desc) END AS entity_desc,
           d.chapter_code,
           CASE WHEN GROUPING(d.chapter_code) = 1 THEN 'Grand Total'
                WHEN GROUPING(d.ap) = 1 THEN NVL(MAX(d.chapter_name),'Unclassified')||' Total'
                ELSE MAX(d.chapter_name) END AS chapter_label,
           d.ap,
           CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.appr_desc) END AS appr_desc,
           SUM(d.approved_budget) AS approved_budget,
           SUM(d.rev_budget_q1) AS rev_budget_q1,
           SUM(d.rev_budget_q2) AS rev_budget_q2,
           SUM(d.acf1) AS acf1, SUM(d.acf2) AS acf2, SUM(d.acf3) AS acf3, SUM(d.acf4) AS acf4,
           SUM(d.rcf1) AS rcf1, SUM(d.rcf2) AS rcf2, SUM(d.rcf3) AS rcf3, SUM(d.rcf4) AS rcf4,
           SUM(d.act1) AS act1, SUM(d.act2) AS act2, SUM(d.act3) AS act3, SUM(d.act4) AS act4,
           SUM(d.rcf1) - SUM(d.act1) AS var1,
           SUM(d.rcf2) - SUM(d.act2) AS var2,
           SUM(d.rcf3) - SUM(d.act3) AS var3,
           SUM(d.rcf4) - SUM(d.act4) AS var4,
           CASE WHEN SUM(d.rcf1) <> 0 THEN ROUND(100*(SUM(d.rcf1)-SUM(d.act1))/SUM(d.rcf1),1) END AS pct1,
           CASE WHEN SUM(d.rcf2) <> 0 THEN ROUND(100*(SUM(d.rcf2)-SUM(d.act2))/SUM(d.rcf2),1) END AS pct2,
           CASE WHEN SUM(d.rcf3) <> 0 THEN ROUND(100*(SUM(d.rcf3)-SUM(d.act3))/SUM(d.rcf3),1) END AS pct3,
           CASE WHEN SUM(d.rcf4) <> 0 THEN ROUND(100*(SUM(d.rcf4)-SUM(d.act4))/SUM(d.rcf4),1) END AS pct4,
           CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.rsn1) END AS rsn1,
           CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.rsn2) END AS rsn2,
           CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.rsn3) END AS rsn3,
           CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.rsn4) END AS rsn4,
           CASE WHEN GROUPING(d.ap) = 0 THEN MAX(d.remark) END AS remark
      FROM (
        SELECT NVL(c.entity_code, e1.ec) AS entity_code,
               NVL(c.entity_desc, e1.ed) AS entity_desc,
               NVL(c.chapter_code, ch.chapter_code) AS chapter_code,
               NVL(c.chapter_name, ch.chapter_name) AS chapter_name,
               NVL(c.ap, f.ap) AS ap,
               NVL(c.appr_desc, ap2.appropriation_desc) AS appr_desc,
               NVL(c.approved_budget,0) AS approved_budget,
               NVL(c.rev_budget_q1,0) AS rev_budget_q1,
               NVL(c.rev_budget_q2,0) AS rev_budget_q2,
               NVL(f.acf1,0) AS acf1, NVL(f.acf2,0) AS acf2, NVL(f.acf3,0) AS acf3, NVL(f.acf4,0) AS acf4,
               NVL(f.rcf1,0) AS rcf1, NVL(f.rcf2,0) AS rcf2, NVL(f.rcf3,0) AS rcf3, NVL(f.rcf4,0) AS rcf4,
               NVL(c.act1,0) AS act1, NVL(c.act2,0) AS act2, NVL(c.act3,0) AS act3, NVL(c.act4,0) AS act4,
               nt.rsn1, nt.rsn2, nt.rsn3, nt.rsn4, nt.remark
          FROM cur c
          FULL OUTER JOIN cf f ON f.ap = c.ap
          CROSS JOIN e1
          LEFT JOIN apr ap2 ON ap2.appropriation_code = NVL(c.ap, f.ap)
          LEFT JOIN chp ch  ON ch.ap = NVL(c.ap, f.ap)
          LEFT JOIN nt      ON nt.ap = NVL(c.ap, f.ap)
      ) d
     GROUP BY GROUPING SETS (
       (d.chapter_code, d.ap),
       (d.chapter_code),
       ()
     )
     ORDER BY GROUPING(d.chapter_code), d.chapter_code NULLS LAST,
              GROUPING(d.ap), d.ap
  ) LOOP
    l_n := l_n + 1;
    APEX_JSON.open_object;
    APEX_JSON.write('rowType',    r.row_kind);
    APEX_JSON.write('entity',     NVL(r.entity_code,''));
    APEX_JSON.write('entityName', NVL(r.entity_desc,''));
    APEX_JSON.write('chapter',    NVL(r.chapter_label,''));
    APEX_JSON.write('apprCode',   NVL(r.ap,''));
    APEX_JSON.write('apprDesc',   NVL(r.appr_desc,''));
    APEX_JSON.write('approvedBudget', NVL(r.approved_budget,0));
    APEX_JSON.write('revBudgetQ1', NVL(r.rev_budget_q1,0));
    APEX_JSON.write('revBudgetQ2', NVL(r.rev_budget_q2,0));
    APEX_JSON.write('acf1', NVL(r.acf1,0)); APEX_JSON.write('acf2', NVL(r.acf2,0));
    APEX_JSON.write('acf3', NVL(r.acf3,0)); APEX_JSON.write('acf4', NVL(r.acf4,0));
    APEX_JSON.write('rcf1', NVL(r.rcf1,0)); APEX_JSON.write('rcf2', NVL(r.rcf2,0));
    APEX_JSON.write('rcf3', NVL(r.rcf3,0)); APEX_JSON.write('rcf4', NVL(r.rcf4,0));
    APEX_JSON.write('act1', NVL(r.act1,0)); APEX_JSON.write('act2', NVL(r.act2,0));
    APEX_JSON.write('act3', NVL(r.act3,0)); APEX_JSON.write('act4', NVL(r.act4,0));
    APEX_JSON.write('var1', NVL(r.var1,0)); APEX_JSON.write('var2', NVL(r.var2,0));
    APEX_JSON.write('var3', NVL(r.var3,0)); APEX_JSON.write('var4', NVL(r.var4,0));
    IF r.pct1 IS NOT NULL THEN APEX_JSON.write('pct1', r.pct1); END IF;
    IF r.pct2 IS NOT NULL THEN APEX_JSON.write('pct2', r.pct2); END IF;
    IF r.pct3 IS NOT NULL THEN APEX_JSON.write('pct3', r.pct3); END IF;
    IF r.pct4 IS NOT NULL THEN APEX_JSON.write('pct4', r.pct4); END IF;
    APEX_JSON.write('rsn1', NVL(r.rsn1,'')); APEX_JSON.write('rsn2', NVL(r.rsn2,''));
    APEX_JSON.write('rsn3', NVL(r.rsn3,'')); APEX_JSON.write('rsn4', NVL(r.rsn4,''));
    APEX_JSON.write('remark', NVL(r.remark,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('total', l_n);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END setup_gl_dof_ords_b;
/

SHOW ERRORS

EXECUTE setup_gl_dof_ords_b
DROP PROCEDURE setup_gl_dof_ords_b;

PROMPT gl.rest DOF dataset endpoints published (/gl/dof/yoy|butil|quarterly).

CREATE OR REPLACE PROCEDURE setup_gl_dof_ords_c AS

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

    def_template('dof/notes');
    def_handler('dof/notes', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_year NUMBER := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_n    NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_DOF_REPORTS', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_DOF_REPORTS required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT note_id, budget_year, entity_code, appropriation_code, account_code,
           quarter, note_type, note_text, updated_by,
           TO_CHAR(dct_to_local(updated_at),'YYYY-MM-DD HH[COLON]MI AM') AS upd_at
      FROM prod.dct_gl_dof_note
     WHERE budget_year = l_year
     ORDER BY appropriation_code, account_code NULLS FIRST, quarter NULLS FIRST) LOOP
    l_n := l_n + 1;
    APEX_JSON.open_object;
    APEX_JSON.write('id',            r.note_id);
    APEX_JSON.write('year',          r.budget_year);
    APEX_JSON.write('entity',        r.entity_code);
    APEX_JSON.write('appropriation', r.appropriation_code);
    APEX_JSON.write('account',       NVL(r.account_code,''));
    IF r.quarter IS NOT NULL THEN APEX_JSON.write('quarter', r.quarter); END IF;
    APEX_JSON.write('noteType',      r.note_type);
    APEX_JSON.write('text',          NVL(r.note_text,''));
    APEX_JSON.write('updatedBy',     NVL(r.updated_by,''));
    APEX_JSON.write('updatedAt',     NVL(r.upd_at,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('total', l_n);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('dof/notes', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_year NUMBER; l_ent VARCHAR2(30); l_ap VARCHAR2(30); l_ac VARCHAR2(30);
  l_q    NUMBER; l_typ VARCHAR2(30); l_txt VARCHAR2(2000);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_MANAGE_DOF_NOTES', 'SYS_ADMIN', 'GL') = FALSE THEN
    dct_rest.err(403,'GL_MANAGE_DOF_NOTES required'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_year := APEX_JSON.get_number(p_path=>'year');
  l_ent  := NVL(TRIM(APEX_JSON.get_varchar2(p_path=>'entity')), '451');
  l_ap   := TRIM(APEX_JSON.get_varchar2(p_path=>'appropriation'));
  l_ac   := TRIM(APEX_JSON.get_varchar2(p_path=>'account'));
  l_q    := APEX_JSON.get_number(p_path=>'quarter');
  l_typ  := NVL(UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'noteType'))), 'REASON');
  l_txt  := SUBSTR(APEX_JSON.get_varchar2(p_path=>'text'),1,2000);
  IF l_year IS NULL OR l_ap IS NULL THEN
    dct_rest.err(400,'year and appropriation are required'); RETURN;
  END IF;
  IF l_typ NOT IN ('REASON','REMARK') THEN
    dct_rest.err(400,'noteType must be REASON or REMARK'); RETURN;
  END IF;
  IF l_q IS NOT NULL AND l_q NOT BETWEEN 1 AND 4 THEN
    dct_rest.err(400,'quarter must be 1..4'); RETURN;
  END IF;
  IF l_txt IS NULL THEN
    DELETE FROM prod.dct_gl_dof_note
     WHERE budget_year = l_year AND entity_code = l_ent
       AND appropriation_code = l_ap
       AND NVL(account_code, CHR(45)) = NVL(l_ac, CHR(45))
       AND NVL(quarter, 0) = NVL(l_q, 0)
       AND note_type = l_typ;
  ELSE
    UPDATE prod.dct_gl_dof_note
       SET note_text = l_txt, updated_by = l_user, updated_at = SYSTIMESTAMP
     WHERE budget_year = l_year AND entity_code = l_ent
       AND appropriation_code = l_ap
       AND NVL(account_code, CHR(45)) = NVL(l_ac, CHR(45))
       AND NVL(quarter, 0) = NVL(l_q, 0)
       AND note_type = l_typ;
    IF SQL%ROWCOUNT = 0 THEN
      INSERT INTO prod.dct_gl_dof_note
            (budget_year, entity_code, appropriation_code, account_code,
             quarter, note_type, note_text, updated_by)
      VALUES (l_year, l_ent, l_ap, l_ac, l_q, l_typ, l_txt, l_user);
    END IF;
  END IF;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('status', CASE WHEN l_txt IS NULL THEN 'DELETED' ELSE 'SAVED' END);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('dof/register');
    def_handler('dof/register', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_report VARCHAR2(30);
  l_code   VARCHAR2(40);
  l_year   NUMBER;
  l_per    VARCHAR2(10);
  l_params CLOB;
  l_run    NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_DOF_REPORTS', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_DOF_REPORTS required'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_report := UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'report')));
  l_year   := APEX_JSON.get_number(p_path=>'year');
  l_per    := TRIM(APEX_JSON.get_varchar2(p_path=>'period'));
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  IF l_report NOT IN ('YOY','QUARTERLY') THEN
    dct_rest.err(400,'report must be YOY or QUARTERLY'); RETURN;
  END IF;
  IF l_per IS NOT NULL AND NOT REGEXP_LIKE(l_per, '^(0[1-9]|1[0-2])-[0-9]{4}$') THEN
    dct_rest.err(400,'period must be MM-YYYY'); RETURN;
  END IF;
  l_code := CASE l_report WHEN 'YOY' THEN 'DOF_YOY_PERF' ELSE 'DOF_QUARTERLY_PERF' END;
  APEX_JSON.initialize_clob_output;
  APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  IF l_per IS NOT NULL AND l_report = 'YOY' THEN
    APEX_JSON.write('period', l_per);
  END IF;
  APEX_JSON.close_object;
  l_params := APEX_JSON.get_clob_output;
  APEX_JSON.free_output;
  l_run := dct_rpt_pkg.enqueue(p_report_code  => l_code,
                               p_params       => l_params,
                               p_trigger      => 'ONDEMAND',
                               p_requested_by => l_user,
                               p_formats      => 'XLSX');
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('runId', l_run);
  APEX_JSON.write('reportCode', l_code);
  APEX_JSON.close_object;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    IF SQLCODE = -20404 THEN dct_rest.err(404, SQLERRM);
    ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!');

    def_template('dof/register/[COLON]id');
    def_handler('dof/register/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_xls  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_DOF_REPORTS', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_DOF_REPORTS required'); RETURN;
  END IF;
  FOR c IN (SELECT run_id, report_code, status, row_count, error_msg, started_at, finished_at
              FROM dct_rpt_run
             WHERE run_id = [COLON]id
               AND report_code IN ('DOF_YOY_PERF','DOF_QUARTERLY_PERF')) LOOP
    SELECT COUNT(*) INTO l_xls
      FROM dct_rpt_output WHERE run_id = c.run_id AND format = 'XLSX';
    dct_rest.json_header; APEX_JSON.initialize_output;
    APEX_JSON.open_object;
    APEX_JSON.write('runId', c.run_id);
    APEX_JSON.write('reportCode', c.report_code);
    APEX_JSON.write('status', c.status);
    APEX_JSON.write('rowCount', c.row_count);
    APEX_JSON.write('error', NVL(DBMS_LOB.SUBSTR(c.error_msg, 500, 1), ''));
    APEX_JSON.write('startedAt', NVL(TO_CHAR(dct_to_local(c.started_at),'YYYY-MM-DD HH[COLON]MI AM'),''));
    APEX_JSON.write('finishedAt', NVL(TO_CHAR(dct_to_local(c.finished_at),'YYYY-MM-DD HH[COLON]MI AM'),''));
    APEX_JSON.write('hasFile', l_xls > 0);
    APEX_JSON.close_object;
    RETURN;
  END LOOP;
  dct_rest.err(404,'Run not found');
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('dof/register/[COLON]id/file');
    def_handler('dof/register/[COLON]id/file', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_blob BLOB; l_name VARCHAR2(260); l_mime VARCHAR2(200);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_DOF_REPORTS', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_DOF_REPORTS required'); RETURN;
  END IF;
  BEGIN
    SELECT o.file_blob, o.file_name, o.mime_type INTO l_blob, l_name, l_mime FROM (
      SELECT o.file_blob, o.file_name, o.mime_type
        FROM dct_rpt_output o
        JOIN dct_rpt_run r ON r.run_id = o.run_id
       WHERE o.run_id = [COLON]id AND o.format = 'XLSX'
         AND r.report_code IN ('DOF_YOY_PERF','DOF_QUARTERLY_PERF')
       ORDER BY o.output_id DESC) o WHERE ROWNUM = 1;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'File not found'); RETURN; END;
  OWA_UTIL.mime_header(NVL(l_mime,'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'), FALSE);
  HTP.p('Content-Disposition[COLON] attachment; filename="'||NVL(l_name,'dof_report.xlsx')||'"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END setup_gl_dof_ords_c;
/

SHOW ERRORS

EXECUTE setup_gl_dof_ords_c
DROP PROCEDURE setup_gl_dof_ords_c;

PROMPT gl.rest DOF notes + register endpoints published (/gl/dof/notes|register*).
