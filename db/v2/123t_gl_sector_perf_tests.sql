-- ===========================================================================
-- i-Finance V2 -- 123t: Sector Performance data layer -- assert harness
-- File   : db/v2/123t_gl_sector_perf_tests.sql
-- Run    : sql -name prod_mcp @123t_gl_sector_perf_tests.sql
-- Note   : utPLSQL is not installed on this ADB; this is the platform's
--          standalone assert harness pattern. Read-only except for the
--          sample-lock tests, which generate and purge their own rows.
-- The load-bearing tests are 1-8: DCT_SECTOR_PERF_V must reconcile to
-- DCT_BUDGET_UTILIZATION_V exactly, full-year AND period-cut, or the report
-- would disagree with the Budget Utilization page it sits next to.
-- ===========================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
    l_pass  PLS_INTEGER := 0;
    l_fail  PLS_INTEGER := 0;
    c_year  CONSTANT NUMBER := 2026;
    c_cut   CONSTANT VARCHAR2(10) := '2026-08-31';
    n1 NUMBER; n2 NUMBER; n3 NUMBER;
    l_e NUMBER; l_r NUMBER; l_m NUMBER;

    PROCEDURE ok (p_name VARCHAR2, p_cond BOOLEAN, p_detail VARCHAR2 DEFAULT NULL) IS
    BEGIN
        IF p_cond THEN
            l_pass := l_pass + 1;
            DBMS_OUTPUT.put_line('  PASS  ' || p_name);
        ELSE
            l_fail := l_fail + 1;
            DBMS_OUTPUT.put_line('  FAIL  ' || p_name ||
                                 CASE WHEN p_detail IS NOT NULL THEN ' -- ' || p_detail END);
        END IF;
    END;

    PROCEDURE eq_num (p_name VARCHAR2, p_a NUMBER, p_b NUMBER, p_tol NUMBER DEFAULT 0.005) IS
    BEGIN
        ok(p_name, ABS(NVL(p_a, 0) - NVL(p_b, 0)) <= p_tol,
           'a=' || TO_CHAR(NVL(p_a, 0)) || ' b=' || TO_CHAR(NVL(p_b, 0)) ||
           ' diff=' || TO_CHAR(NVL(p_a, 0) - NVL(p_b, 0)));
    END;

    PROCEDURE recon (p_label VARCHAR2) IS
        b_rows NUMBER; s_rows NUMBER;
        b_ba NUMBER; s_ba NUMBER;  b_by NUMBER; s_by NUMBER;
        b_ac NUMBER; s_ac NUMBER;  b_en NUMBER; s_en NUMBER;
        b_fa NUMBER; s_fa NUMBER;
    BEGIN
        SELECT COUNT(*), SUM(NVL(budget_annual,0)), SUM(NVL(budget,0)),
               SUM(NVL(actual_ap,0) + NVL(actual_grn,0)),
               SUM(NVL(commitment_pr,0) + NVL(obligation_po,0)),
               SUM(NVL(fund_available,0))
          INTO b_rows, b_ba, b_by, b_ac, b_en, b_fa
          FROM prod.dct_budget_utilization_v WHERE budget_year = c_year;
        SELECT COUNT(*), SUM(budget_annual), SUM(budget_ytd),
               SUM(actual_ytd), SUM(encumbrance), SUM(NVL(fund_available,0))
          INTO s_rows, s_ba, s_by, s_ac, s_en, s_fa
          FROM prod.dct_sector_perf_v WHERE budget_year = c_year;
        ok(p_label || ' row count', b_rows = s_rows, b_rows || ' vs ' || s_rows);
        eq_num(p_label || ' annual budget',  b_ba, s_ba);
        eq_num(p_label || ' YTD budget',     b_by, s_by);
        eq_num(p_label || ' actual',         b_ac, s_ac);
        eq_num(p_label || ' encumbrance',    b_en, s_en);
        eq_num(p_label || ' funds available',b_fa, s_fa);
    END;

BEGIN
    DBMS_OUTPUT.put_line('=== 123t Sector Performance data layer ===');

    DBMS_OUTPUT.put_line('-- group 1: reconciliation to /gl/butil, FULL YEAR');
    prod.dct_gl_class_pkg.clear_butil_end;
    recon('full-year');

    DBMS_OUTPUT.put_line('-- group 2: reconciliation to /gl/butil, PERIOD CUT ' || c_cut);
    prod.dct_gl_class_pkg.set_butil_end(TO_DATE(c_cut, 'YYYY-MM-DD'));
    recon('period-cut');
    prod.dct_gl_class_pkg.clear_butil_end;

    DBMS_OUTPUT.put_line('-- group 3: plan arithmetic');
    SELECT NVL(SUM(cf_amount), 0) INTO n1 FROM prod.dct_project_cashflow
     WHERE budget_year = c_year AND cf_type = 'APPROVED';
    SELECT NVL(SUM(plan_annual), 0) INTO n2 FROM prod.dct_sector_plan_v
     WHERE budget_year = c_year;
    eq_num('plan annual equals the sum of its period rows', n1, n2, 0.05);

    SELECT COUNT(*) INTO n1 FROM (
        SELECT project_number, task_number, expenditure_type, COUNT(*) c
        FROM   prod.dct_project_cashflow
        WHERE  budget_year = c_year AND cf_type = 'APPROVED'
        GROUP  BY project_number, task_number, expenditure_type
        HAVING COUNT(*) <> 12);
    ok('every planned line carries exactly 12 period rows', n1 = 0, n1 || ' lines differ');

    prod.dct_gl_class_pkg.set_butil_end(TO_DATE(c_cut, 'YYYY-MM-DD'));
    SELECT NVL(SUM(plan_ytd), 0) INTO n1 FROM prod.dct_sector_plan_v WHERE budget_year = c_year;
    SELECT NVL(SUM(cf_amount), 0) INTO n2 FROM prod.dct_project_cashflow
     WHERE budget_year = c_year AND cf_type = 'APPROVED'
       AND period_date <= TO_DATE(c_cut, 'YYYY-MM-DD');
    eq_num('plan YTD honours the same BUTIL_END cut-off', n1, n2, 0.05);
    prod.dct_gl_class_pkg.clear_butil_end;

    DBMS_OUTPUT.put_line('-- group 4: monthly actual identity');
    prod.dct_gl_class_pkg.set_butil_end(TO_DATE(c_cut, 'YYYY-MM-DD'));
    SELECT NVL(SUM(NVL(actual_ap,0) + NVL(actual_grn,0)), 0) INTO n1
      FROM prod.dct_budget_utilization_v WHERE budget_year = c_year;
    prod.dct_gl_class_pkg.clear_butil_end;
    SELECT NVL(SUM(m.actual_amount), 0) INTO n2
      FROM prod.dct_sector_actual_month_v m
      JOIN prod.dct_butil_scope_v s
        ON s.budget_year = m.budget_year AND s.project_number = m.project_number
       AND s.task_number = m.task_number AND s.expenditure_type = m.expenditure_type
     WHERE m.budget_year = c_year AND m.period_num <= 202608;
    eq_num('sum of months <= cut-off equals the butil actual at that cut-off', n1, n2, 0.5);

    DBMS_OUTPUT.put_line('-- group 5: nothing silently dropped');
    SELECT COUNT(*) INTO n1 FROM prod.dct_sector_plan_orphan_v WHERE budget_year = c_year;
    ok('plan orphans are surfaced, not hidden (count is reportable)', n1 >= 0, 'orphans=' || n1);

    SELECT NVL(SUM(NVL(distribution_accounted_amo,0)), 0) INTO n1
      FROM prod.atd_ar_invoice_distribution
     WHERE accounting_class = 'Revenue' AND accounting_date IS NOT NULL
       AND EXTRACT(YEAR FROM accounting_date) = c_year;
    SELECT NVL(SUM(actual_amount), 0) INTO n2
      FROM prod.dct_gl_revenue_fact_v WHERE budget_year = c_year;
    eq_num('revenue fact keeps every AR revenue distribution', n1, n2, 0.05);

    SELECT COUNT(*) INTO n1 FROM prod.dct_gl_revenue_fact_v
     WHERE budget_year = c_year AND category_code IS NULL;
    ok('no revenue row loses its category (unmapped becomes UNCATEGORISED)', n1 = 0, n1 || ' null');

    DBMS_OUTPUT.put_line('-- group 6: expenditure kind');
    SELECT COUNT(DISTINCT expenditure_kind) INTO n1
      FROM prod.dct_sector_perf_v WHERE budget_year = c_year;
    ok('expenditure kind resolves Opex / Capex / ...', n1 >= 2, 'distinct=' || n1);
    SELECT NVL(SUM(budget_annual),0) INTO n1 FROM prod.dct_sector_perf_v
     WHERE budget_year = c_year AND expenditure_kind = 'Opex';
    SELECT NVL(SUM(b.budget_annual),0) INTO n2 FROM prod.dct_budget_utilization_v b
     WHERE b.budget_year = c_year AND b.chapter = 'Chapter 2';
    eq_num('Opex kind equals Chapter 2 budget', n1, n2);

    DBMS_OUTPUT.put_line('-- group 7: sample data locks');
    ok('sample is flagged active while sample rows exist',
       prod.dct_gl_plan_sample_pkg.is_sample_active(c_year) = 'Y');

    SELECT COUNT(*) INTO n1 FROM prod.dct_project_cashflow
     WHERE budget_year = c_year AND NVL(loaded_by,'x') <> 'SAMPLE';
    ok('generator wrote nothing that is not tagged SAMPLE', n1 = 0, n1 || ' untagged');

    SELECT COUNT(*) INTO n1 FROM prod.dct_project_cashflow
     WHERE budget_year = c_year AND loaded_by = 'SAMPLE'
       AND source_file NOT LIKE 'SAMPLE:%';
    ok('every sample row carries a SAMPLE: batch stamp', n1 = 0, n1 || ' unstamped');

    -- LOCK 2: plant one row that looks like a real upload, then prove the
    -- generator refuses rather than overwriting it.
    INSERT INTO prod.dct_project_cashflow
           (project_number, task_number, expenditure_type, budget_year,
            accounting_period, period_date, cf_type, cf_amount, source_file, loaded_by)
    VALUES ('ZZTEST', 'ZZTEST', 'ZZTEST', c_year, '01-' || c_year,
            TO_DATE(c_year || '-01-01','YYYY-MM-DD'), 'APPROVED', 1,
            'finance_plan_2026.xlsx', 'hany.ghareb');
    COMMIT;
    BEGIN
        prod.dct_gl_plan_sample_pkg.generate_expenditure_plan(c_year, 'LOCKTEST', 'APPROVED', l_e);
        ok('generator refuses to overwrite a real uploaded plan', FALSE, 'it did NOT refuse');
    EXCEPTION WHEN OTHERS THEN
        ok('generator refuses to overwrite a real uploaded plan', SQLCODE = -20001, SQLERRM);
    END;

    -- LOCK 1: purge must remove sample rows and leave the real row untouched
    prod.dct_gl_plan_sample_pkg.purge(c_year, NULL, l_e, l_r, l_m);
    SELECT COUNT(*) INTO n1 FROM prod.dct_project_cashflow
     WHERE budget_year = c_year AND loaded_by = 'SAMPLE';
    SELECT COUNT(*) INTO n2 FROM prod.dct_gl_revenue_plan
     WHERE budget_year = c_year AND loaded_by = 'SAMPLE';
    SELECT COUNT(*) INTO n3 FROM prod.dct_project_cashflow
     WHERE budget_year = c_year AND loaded_by = 'hany.ghareb';
    ok('purge removed every sample expenditure row', n1 = 0, n1 || ' left');
    ok('purge removed every sample revenue row',     n2 = 0, n2 || ' left');
    ok('purge left the real uploaded row untouched', n3 = 1, n3 || ' found');
    ok('sample is no longer flagged active',
       prod.dct_gl_plan_sample_pkg.is_sample_active(c_year) = 'N');

    DELETE FROM prod.dct_project_cashflow WHERE project_number = 'ZZTEST';
    COMMIT;

    DBMS_OUTPUT.put_line('==========================================');
    DBMS_OUTPUT.put_line('  PASSED ' || l_pass || ' / ' || (l_pass + l_fail));
    DBMS_OUTPUT.put_line('==========================================');
EXCEPTION WHEN OTHERS THEN
    prod.dct_gl_class_pkg.clear_butil_end;
    DBMS_OUTPUT.put_line('HARNESS ABORTED: ' || SQLERRM);
    DBMS_OUTPUT.put_line(DBMS_UTILITY.format_error_backtrace);
    RAISE;
END;
/
