-- =============================================================================
-- KPI Module (App 213) -- PL/SQL unit smoke test (standalone assert harness)
-- Run  : sql -name prod_mcp @test/kpi_smoke_test.sql
-- Safe : read-mostly; creates one throwaway DRAFT result in a synthetic period
--        year (2098) and rolls everything back at the end.
-- =============================================================================
ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

DECLARE
    v_pass   NUMBER := 0;
    v_fail   NUMBER := 0;
    v_rev    NUMBER;
    v_cash   NUMBER;
    v_opt    NUMBER;
    v_comp   NUMBER;
    v_uid    NUMBER;
    v_per    NUMBER;
    v_res    NUMBER;
    v_n      NUMBER;
    v_pct    NUMBER;
    v_sc     NUMBER;
    v_err    VARCHAR2(400);

    PROCEDURE t (p_name VARCHAR2, p_ok BOOLEAN) IS
    BEGIN
        IF p_ok THEN
            v_pass := v_pass + 1;
            DBMS_OUTPUT.PUT_LINE('PASS  ' || p_name);
        ELSE
            v_fail := v_fail + 1;
            DBMS_OUTPUT.PUT_LINE('FAIL  ' || p_name);
        END IF;
    END;
BEGIN
    SELECT kpi_id INTO v_rev  FROM prod.dct_kpi_definitions WHERE kpi_code = 'REV_GROWTH';
    SELECT kpi_id INTO v_cash FROM prod.dct_kpi_definitions WHERE kpi_code = 'CASH_MGMT';
    SELECT kpi_id INTO v_opt  FROM prod.dct_kpi_definitions WHERE kpi_code = 'OPT_PLAN';
    SELECT kpi_id INTO v_comp FROM prod.dct_kpi_definitions WHERE kpi_code = 'FIN_LAW_COMP';
    SELECT MIN(user_id) INTO v_uid FROM prod.dct_users WHERE is_active = 'Y';

    -- ---------------------------------------------------------------- score_of
    -- ascending overlapping bands (REV_GROWTH: 1 <90 | 2 >=90 | 3 =100 | 4 >100 | 5 >=108)
    t('rev 89.9 -> 1',  prod.dct_kpi_pkg.score_of(v_rev, 89.9)  = 1);
    t('rev 90 -> 2',    prod.dct_kpi_pkg.score_of(v_rev, 90)    = 2);
    t('rev 99.9 -> 2',  prod.dct_kpi_pkg.score_of(v_rev, 99.9)  = 2);
    t('rev 100 -> 3',   prod.dct_kpi_pkg.score_of(v_rev, 100)   = 3);
    t('rev 100.1 -> 4', prod.dct_kpi_pkg.score_of(v_rev, 100.1) = 4);
    t('rev 107.9 -> 4', prod.dct_kpi_pkg.score_of(v_rev, 107.9) = 4);
    t('rev 108 -> 5',   prod.dct_kpi_pkg.score_of(v_rev, 108)   = 5);
    t('rev 150 -> 5',   prod.dct_kpi_pkg.score_of(v_rev, 150)   = 5);
    t('rev NULL -> NULL', prod.dct_kpi_pkg.score_of(v_rev, NULL) IS NULL);
    -- descending variance bands (CASH: 5 <=5 | 4 <=7.5 | 3 <=10 | 2 <=12.5 | 1 >12.5)
    t('cash 0 -> 5',    prod.dct_kpi_pkg.score_of(v_cash, 0)    = 5);
    t('cash 5 -> 5',    prod.dct_kpi_pkg.score_of(v_cash, 5)    = 5);
    t('cash 7.5 -> 4',  prod.dct_kpi_pkg.score_of(v_cash, 7.5)  = 4);
    t('cash 10 -> 3',   prod.dct_kpi_pkg.score_of(v_cash, 10)   = 3);
    t('cash 12.5 -> 2', prod.dct_kpi_pkg.score_of(v_cash, 12.5) = 2);
    t('cash 12.6 -> 1', prod.dct_kpi_pkg.score_of(v_cash, 12.6) = 1);
    t('cash 30 -> 1',   prod.dct_kpi_pkg.score_of(v_cash, 30)   = 1);
    -- weighted bands (OPT: 1 >0 | 2 >=20 ... 5 >=80); 0 matches no band
    t('opt 0 -> NULL',  prod.dct_kpi_pkg.score_of(v_opt, 0) IS NULL);
    t('opt 19 -> 1',    prod.dct_kpi_pkg.score_of(v_opt, 19)  = 1);
    t('opt 80 -> 5',    prod.dct_kpi_pkg.score_of(v_opt, 80)  = 5);
    t('comp 59.9 -> 1', prod.dct_kpi_pkg.score_of(v_comp, 59.9) = 1);
    t('comp 90 -> 5',   prod.dct_kpi_pkg.score_of(v_comp, 90)   = 5);

    -- ------------------------------------------------------- criteria weights
    BEGIN
        prod.dct_kpi_pkg.validate_criteria(v_opt);
        t('opt weights = 100 valid', TRUE);
    EXCEPTION WHEN OTHERS THEN t('opt weights = 100 valid', FALSE);
    END;

    -- --------------------------------------------- periods + result lifecycle
    prod.dct_kpi_pkg.ensure_periods(2098);
    SELECT COUNT(*) INTO v_n FROM prod.dct_kpi_periods WHERE period_year = 2098;
    t('ensure_periods creates 5 rows', v_n = 5);
    prod.dct_kpi_pkg.ensure_periods(2098);
    SELECT COUNT(*) INTO v_n FROM prod.dct_kpi_periods WHERE period_year = 2098;
    t('ensure_periods idempotent', v_n = 5);

    SELECT period_id INTO v_per FROM prod.dct_kpi_periods
     WHERE period_year = 2098 AND period_type = 'ANNUAL';

    -- frequency mismatch: quarterly KPI on annual period must fail
    BEGIN
        v_res := prod.dct_kpi_pkg.init_result(v_cash, v_per, v_uid);
        t('freq mismatch rejected', FALSE);
    EXCEPTION WHEN OTHERS THEN
        t('freq mismatch rejected', SQLCODE = -20001);
    END;

    v_res := prod.dct_kpi_pkg.init_result(v_rev, v_per, v_uid);
    t('init_result returns id', v_res IS NOT NULL);
    v_n := prod.dct_kpi_pkg.init_result(v_rev, v_per, v_uid);
    t('init_result idempotent', v_n = v_res);

    -- ratio compute + score
    prod.dct_kpi_pkg.save_result(v_res, v_uid, 108, 100, NULL);
    SELECT result_pct, score INTO v_pct, v_sc FROM prod.dct_kpi_results WHERE result_id = v_res;
    t('ratio 108/100 = 108', v_pct = 108);
    t('ratio score = 5', v_sc = 5);

    -- submit blocked: missing figure
    prod.dct_kpi_pkg.save_result(v_res, v_uid, NULL, 100, NULL);
    BEGIN
        prod.dct_kpi_pkg.submit_result(v_res, v_uid);
        t('submit without figures rejected', FALSE);
    EXCEPTION WHEN OTHERS THEN
        t('submit without figures rejected', SQLCODE = -20001);
    END;

    -- zero denominator rejected at submit
    prod.dct_kpi_pkg.save_result(v_res, v_uid, 100, 0, NULL);
    BEGIN
        prod.dct_kpi_pkg.submit_result(v_res, v_uid);
        t('zero denominator rejected', FALSE);
    EXCEPTION WHEN OTHERS THEN
        t('zero denominator rejected', SQLCODE = -20001);
    END;

    -- weighted KPI: skeleton rows + partial entry keeps score NULL
    v_res := prod.dct_kpi_pkg.init_result(v_opt, v_per, v_uid);
    SELECT COUNT(*) INTO v_n FROM prod.dct_kpi_result_criteria WHERE result_id = v_res;
    t('opt skeleton = 4 criteria', v_n = 4);
    FOR c IN (SELECT criterion_id, criterion_code FROM prod.dct_kpi_criteria
               WHERE kpi_id = v_opt AND criterion_code IN ('DATA_QUALITY')) LOOP
        prod.dct_kpi_pkg.save_result_criterion(v_res, c.criterion_id, v_uid, 5, NULL, NULL);
    END LOOP;
    SELECT score INTO v_sc FROM prod.dct_kpi_results WHERE result_id = v_res;
    t('partial rubric -> no score yet', v_sc IS NULL);
    -- complete the rubric at level 4 everywhere else: 20*1 + (10+20+50)*0.8 = 84 -> band 5
    FOR c IN (SELECT criterion_id FROM prod.dct_kpi_criteria
               WHERE kpi_id = v_opt AND criterion_code != 'DATA_QUALITY') LOOP
        prod.dct_kpi_pkg.save_result_criterion(v_res, c.criterion_id, v_uid, 4, NULL, NULL);
    END LOOP;
    SELECT result_pct, score INTO v_pct, v_sc FROM prod.dct_kpi_results WHERE result_id = v_res;
    t('rubric 84 pct', v_pct = 84);
    t('rubric score = 5', v_sc = 5);

    -- evidence gate: OPT_PLAN requires evidence -> submit without docs rejected
    BEGIN
        prod.dct_kpi_pkg.submit_result(v_res, v_uid);
        t('evidence gate enforced', FALSE);
    EXCEPTION WHEN OTHERS THEN
        v_err := SQLERRM;
        t('evidence gate enforced', SQLCODE = -20001 AND INSTR(v_err, 'evidence') > 0);
    END;

    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    DBMS_OUTPUT.PUT_LINE('PASS=' || v_pass || '  FAIL=' || v_fail);
    ROLLBACK;
END;
/
