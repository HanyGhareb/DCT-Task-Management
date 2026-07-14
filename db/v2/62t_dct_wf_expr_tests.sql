SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

-- =============================================================================
-- 62t_dct_wf_expr_tests.sql
-- Unit harness for prod.dct_wf_expr  (spike item S8)
-- Schema  : PROD (run as ADMIN)
--
-- utPLSQL is NOT installed on this ADB -- this is the standalone assert
-- harness the repo uses instead.
--
-- Read-only against business data. Creates a throwaway fact schema
-- 'WF_TEST_FACTS', runs the suite, then removes it. Safe to re-run.
--
-- The injection cases are the point of this file: every one of them MUST be a
-- COMPILE ERROR, not a successful parse. If any of them compiles, stop and fix
-- the evaluator before another line of the platform is built on it.
-- =============================================================================

PROMPT === condition evaluator -- unit suite ===

DECLARE
    g_pass PLS_INTEGER := 0;
    g_fail PLS_INTEGER := 0;
    v_sid  NUMBER;

    -- a representative fact document
    c_facts CONSTANT CLOB := TO_CLOB(
        '{"amount":120000,"contract_months":8,"contract_type":"CONSULTANT",'
     || '"procurement_involved":"N","is_renewal":false,"line_manager_user_id":42,'
     || '"nothing":null,"roles":["FL_ADMIN","FIN_DIRECTOR"]}');

    PROCEDURE ok (p_what VARCHAR2) IS
    BEGIN
        g_pass := g_pass + 1;
        DBMS_OUTPUT.PUT_LINE('  pass  ' || p_what);
    END;

    PROCEDURE bad (p_what VARCHAR2, p_detail VARCHAR2 DEFAULT NULL) IS
    BEGIN
        g_fail := g_fail + 1;
        DBMS_OUTPUT.PUT_LINE('  FAIL  ' || p_what
                          || CASE WHEN p_detail IS NULL THEN '' ELSE '   [' || p_detail || ']' END);
    END;

    -- assert: expression compiles AND evaluates to p_expect
    PROCEDURE t_eval (p_expr VARCHAR2, p_expect VARCHAR2) IS
        v_ast CLOB;
        v_err VARCHAR2(1000);
        v_tr  CLOB;
        v_res VARCHAR2(5);
    BEGIN
        v_ast := prod.dct_wf_expr.compile(p_expr, v_sid, v_err);
        IF v_ast IS NULL THEN
            bad(p_expr || '  =>  ' || p_expect, 'compile error: ' || v_err);
            RETURN;
        END IF;
        v_res := prod.dct_wf_expr.eval(v_ast, c_facts, v_tr);
        IF v_res = p_expect THEN
            ok(RPAD(p_expr, 52) || ' => ' || v_res);
        ELSE
            bad(p_expr, 'expected ' || p_expect || ' got ' || v_res);
        END IF;
    END;

    -- assert: expression MUST NOT compile
    PROCEDURE t_reject (p_expr VARCHAR2, p_why VARCHAR2) IS
        v_ast CLOB;
        v_err VARCHAR2(1000);
    BEGIN
        v_ast := prod.dct_wf_expr.compile(p_expr, v_sid, v_err);
        IF v_ast IS NULL THEN
            ok('rejected (' || p_why || '): ' || SUBSTR(p_expr, 1, 40)
               || '  -- ' || SUBSTR(v_err, 1, 50));
        ELSE
            bad('SHOULD HAVE BEEN REJECTED (' || p_why || '): ' || p_expr,
                'it compiled -- this is a security defect');
        END IF;
    END;
BEGIN
    -- ------------------------------------------------ throwaway fact schema
    BEGIN
        DELETE FROM prod.dct_wf_fact_field
         WHERE schema_id IN (SELECT schema_id FROM prod.dct_wf_fact_schema
                              WHERE schema_code = 'WF_TEST_FACTS');
        DELETE FROM prod.dct_wf_fact_schema WHERE schema_code = 'WF_TEST_FACTS';
    EXCEPTION WHEN OTHERS THEN NULL;
    END;

    INSERT INTO prod.dct_wf_fact_schema
        (schema_code, name_en, source_view, source_key_column)
    VALUES ('WF_TEST_FACTS', 'Unit test facts', 'DUAL', 'X')
    RETURNING schema_id INTO v_sid;

    INSERT INTO prod.dct_wf_fact_field (schema_id, field_key, label_en, data_type, source_column)
        VALUES (v_sid, 'amount', 'Amount', 'NUMBER', 'AMOUNT');
    INSERT INTO prod.dct_wf_fact_field (schema_id, field_key, label_en, data_type, source_column)
        VALUES (v_sid, 'contract_months', 'Duration in months', 'NUMBER', 'CONTRACT_MONTHS');
    INSERT INTO prod.dct_wf_fact_field (schema_id, field_key, label_en, data_type, source_column)
        VALUES (v_sid, 'contract_type', 'Contract type', 'STRING', 'CONTRACT_TYPE');
    INSERT INTO prod.dct_wf_fact_field (schema_id, field_key, label_en, data_type, source_column)
        VALUES (v_sid, 'procurement_involved', 'Procurement involved', 'STRING', 'PROCUREMENT_INVOLVED');
    INSERT INTO prod.dct_wf_fact_field (schema_id, field_key, label_en, data_type, source_column)
        VALUES (v_sid, 'is_renewal', 'Is renewal', 'BOOLEAN', 'IS_RENEWAL');
    INSERT INTO prod.dct_wf_fact_field (schema_id, field_key, label_en, data_type, source_column)
        VALUES (v_sid, 'nothing', 'Always null', 'NUMBER', 'NOTHING');

    DBMS_OUTPUT.PUT_LINE('--- comparisons ---');
    t_eval('amount > 50000',                         'TRUE');
    t_eval('amount >= 120000',                       'TRUE');
    t_eval('amount < 50000',                         'FALSE');
    t_eval('amount = 120000',                        'TRUE');
    t_eval('amount != 120000',                       'FALSE');
    t_eval('amount <> 1',                            'TRUE');

    DBMS_OUTPUT.PUT_LINE('--- the real FL rule (replaces CUSTOM:FL_DURATION_GE_6M) ---');
    t_eval('contract_months >= 6',                   'TRUE');
    t_eval('contract_months >= 12',                  'FALSE');

    DBMS_OUTPUT.PUT_LINE('--- boolean logic ---');
    t_eval('amount > 50000 AND contract_months >= 6', 'TRUE');
    t_eval('amount > 50000 AND contract_months >= 12','FALSE');
    t_eval('amount < 1 OR contract_months >= 6',      'TRUE');
    t_eval('NOT (amount < 1)',                        'TRUE');

    DBMS_OUTPUT.PUT_LINE('--- text, IN, BETWEEN, LIKE ---');
    t_eval('contract_type = ''CONSULTANT''',                        'TRUE');
    t_eval('contract_type IN (''CONSULTANT'', ''SUPPLIER'')',       'TRUE');
    t_eval('contract_type NOT IN (''SUPPLIER'')',                   'TRUE');
    t_eval('amount BETWEEN 100000 AND 200000',                      'TRUE');
    t_eval('amount NOT BETWEEN 1 AND 2',                            'TRUE');
    t_eval('contract_type LIKE ''CONSULT%''',                       'TRUE');

    DBMS_OUTPUT.PUT_LINE('--- booleans + null semantics (three-valued) ---');
    t_eval('is_renewal',                             'FALSE');
    t_eval('nothing IS NULL',                        'TRUE');
    t_eval('nothing IS NOT NULL',                    'FALSE');
    -- a NULL operand makes the whole condition UNKNOWN, which SKIPS the step.
    -- It must never silently become TRUE.
    t_eval('nothing > 5',                            'NULL');
    t_eval('nothing > 5 AND amount > 1',             'NULL');
    -- but AND with a definite FALSE is still FALSE, even with an unknown
    t_eval('nothing > 5 AND amount > 999999',        'FALSE');
    -- and OR with a definite TRUE is still TRUE
    t_eval('nothing > 5 OR amount > 1',              'TRUE');
    t_eval('NVL(nothing, 0) = 0',                    'TRUE');

    DBMS_OUTPUT.PUT_LINE('--- arithmetic + functions ---');
    t_eval('amount / 2 = 60000',                     'TRUE');
    t_eval('amount / 0 IS NULL',                     'TRUE');
    t_eval('ABS(0 - amount) = 120000',               'TRUE');
    t_eval('UPPER(contract_type) = ''CONSULTANT''',  'TRUE');
    t_eval('LENGTH(contract_type) = 10',             'TRUE');
    t_eval('HAS_ROLE(''FL_ADMIN'')',                 'TRUE');
    t_eval('HAS_ROLE(''NOPE'')',                     'FALSE');

    DBMS_OUTPUT.PUT_LINE('--- INJECTION: every one of these MUST be rejected ---');
    t_reject('amount > 0 OR 1=1--',                       'trailing comment');
    t_reject('amount > 0; DROP TABLE prod.dct_users',     'statement terminator');
    t_reject('''; DROP TABLE prod.dct_users; --',         'quoted injection');
    t_reject('NVL((SELECT 1 FROM dual), 0) = 1',          'subquery');
    t_reject('amount > (SELECT MAX(x) FROM t)',           'subquery');
    t_reject('DBMS_OUTPUT.PUT_LINE(''x'')',               'arbitrary package call');
    t_reject('UTL_HTTP.REQUEST(''http://evil'')',         'network call');
    t_reject('amount > 0 UNION SELECT 1 FROM dual',       'set operator');

    DBMS_OUTPUT.PUT_LINE('--- unknown identifiers + did-you-mean ---');
    t_reject('amont > 5',                                 'typo -> suggestion');
    t_reject('salary > 5',                                'field not in schema');
    t_reject('bogus_function(amount)',                    'function not whitelisted');

    DBMS_OUTPUT.PUT_LINE('--- malformed ---');
    t_reject('amount >',                                  'dangling operator');
    t_reject('(amount > 1',                               'unbalanced paren');
    t_reject('amount > ''unterminated',                   'unterminated literal');
    t_reject('',                                          'empty');

    -- ------------------------------------------------ tidy up
    DELETE FROM prod.dct_wf_fact_field  WHERE schema_id = v_sid;
    DELETE FROM prod.dct_wf_fact_schema WHERE schema_id = v_sid;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=====================================================');
    DBMS_OUTPUT.PUT_LINE('  passed : ' || g_pass);
    DBMS_OUTPUT.PUT_LINE('  failed : ' || g_fail);
    DBMS_OUTPUT.PUT_LINE('=====================================================');
    IF g_fail > 0 THEN
        raise_application_error(-20999, g_fail || ' evaluator test(s) FAILED');
    END IF;
END;
/
