-- =============================================================================
-- FMR sector current-COA performance
-- Replaces only GET /gl/fmr/sector. Financial measures remain live; the hourly
-- refreshed COA snapshot is used only to resolve current segment attributes.
-- Re-run after 37_gl_fmr_ords.sql. Deploy as ADMIN.
-- =============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

CREATE OR REPLACE PROCEDURE setup_gl_fmr_sector_perf_tmp AS
BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'gl.rest',p_pattern=>'fmr/sector');
  ORDS.DEFINE_HANDLER(
    p_module_name=>'gl.rest',p_pattern=>'fmr/sector',p_method=>'GET',
    p_source_type=>ORDS.source_type_plsql,
    p_source=>REPLACE(q'!
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
      SELECT NVL(p.sector_code,'UNCLASSIFIED') sector_code,
             MAX(NVL(p.sector_name,'Unclassified')) sector_name,
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
  APEX_JSON.close_array; APEX_JSON.close_object;
  prod.dct_gl_class_pkg.clear_butil_end;
EXCEPTION WHEN OTHERS THEN
  prod.dct_gl_class_pkg.clear_butil_end;
  dct_rest.err(500, SQLERRM);
END;
!','[COLON]',CHR(58)));
END;
/
SHOW ERRORS
BEGIN setup_gl_fmr_sector_perf_tmp; COMMIT; END;
/
DROP PROCEDURE setup_gl_fmr_sector_perf_tmp;

SELECT t.uri_template,h.method,LENGTH(h.source) source_length
  FROM user_ords_templates t JOIN user_ords_handlers h ON h.template_id=t.id
 WHERE t.uri_template='fmr/sector' AND h.method='GET';
PROMPT GL/db/45 FMR sector performance complete.
EXIT
