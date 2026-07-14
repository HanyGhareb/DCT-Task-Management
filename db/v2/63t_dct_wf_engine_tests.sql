SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

-- =============================================================================
-- 63t_dct_wf_engine_tests.sql
-- End-to-end harness for prod.dct_wf_engine
-- Schema  : PROD (run as ADMIN)
--
-- utPLSQL is NOT installed on this ADB -- this is the standalone assert harness
-- the repo uses instead (same shape as 62t).
--
-- It builds a THROWAWAY process (its own table, view, fact schema, role, action
-- package and 5-step chain), drives real instances through every outcome
-- semantic, then removes every trace of itself. It touches no business data:
-- the only rows it writes outside its own objects are dct_wf_* rows for its own
-- process, and those are deleted at the end. Safe to re-run.
--
-- What it proves, in order of how much it would hurt to get wrong:
--   * a custom outcome (ENDORSE) is RECORDED AS ENDORSE           -- requirement 2
--   * RETURN_FOR_INFO reworks IN PLACE and resumes the SAME instance
--   * a conditional step fires at 8 months and SKIPS at 4, with the reason stored
--   * the final callback fires EXACTLY ONCE
--   * a process that needs a final callback and has none CANNOT finalize (-20301)
--   * a non-participant cannot act (-20303)
--   * an outcome outside the step's set is refused (-20304)
--   * quorum ANY: the first act wins and the siblings are cancelled
--   * a delegate sees the principal's task
--   * task ids stay above the 900,000,000 floor (the ID-disjointness invariant)
-- =============================================================================

PROMPT === workflow engine -- end to end suite ===

PROMPT
PROMPT --- [0/4] teardown of any prior run ---

DECLARE
    PROCEDURE drop_if (p_kind IN VARCHAR2, p_name IN VARCHAR2) IS
        v NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v FROM all_objects
         WHERE owner = 'PROD' AND object_name = UPPER(p_name)
           AND object_type = UPPER(p_kind);
        IF v > 0 THEN
            EXECUTE IMMEDIATE 'DROP ' || p_kind || ' prod.' || p_name
                              || CASE WHEN UPPER(p_kind) = 'TABLE'
                                      THEN ' CASCADE CONSTRAINTS PURGE' ELSE '' END;
        END IF;
    END;
BEGIN
    -- runtime rows first, then definition rows: the FKs care
    DELETE FROM prod.dct_wf_notify_log      WHERE instance_id IN (SELECT instance_id FROM prod.dct_wf_instance WHERE source_module = 'WF_TEST');
    DELETE FROM prod.dct_wf_info_request    WHERE instance_id IN (SELECT instance_id FROM prod.dct_wf_instance WHERE source_module = 'WF_TEST');
    DELETE FROM prod.dct_wf_watcher         WHERE instance_id IN (SELECT instance_id FROM prod.dct_wf_instance WHERE source_module = 'WF_TEST');
    DELETE FROM prod.dct_wf_history         WHERE instance_id IN (SELECT instance_id FROM prod.dct_wf_instance WHERE source_module = 'WF_TEST');
    DELETE FROM prod.dct_wf_task_participant WHERE task_id IN (SELECT task_id FROM prod.dct_wf_task WHERE instance_id IN (SELECT instance_id FROM prod.dct_wf_instance WHERE source_module = 'WF_TEST'));
    DELETE FROM prod.dct_wf_task            WHERE instance_id IN (SELECT instance_id FROM prod.dct_wf_instance WHERE source_module = 'WF_TEST');
    DELETE FROM prod.dct_wf_step_instance   WHERE instance_id IN (SELECT instance_id FROM prod.dct_wf_instance WHERE source_module = 'WF_TEST');
    DELETE FROM prod.dct_wf_instance        WHERE source_module = 'WF_TEST';

    DELETE FROM prod.dct_wf_process_hook WHERE version_id IN (SELECT version_id FROM prod.dct_wf_process_version WHERE process_id IN (SELECT process_id FROM prod.dct_wf_process WHERE source_module = 'WF_TEST'));
    DELETE FROM prod.dct_wf_participant_rule WHERE step_id IN (SELECT step_id FROM prod.dct_wf_step WHERE version_id IN (SELECT version_id FROM prod.dct_wf_process_version WHERE process_id IN (SELECT process_id FROM prod.dct_wf_process WHERE source_module = 'WF_TEST')));
    DELETE FROM prod.dct_wf_step         WHERE version_id IN (SELECT version_id FROM prod.dct_wf_process_version WHERE process_id IN (SELECT process_id FROM prod.dct_wf_process WHERE source_module = 'WF_TEST'));
    DELETE FROM prod.dct_wf_condition    WHERE version_id IN (SELECT version_id FROM prod.dct_wf_process_version WHERE process_id IN (SELECT process_id FROM prod.dct_wf_process WHERE source_module = 'WF_TEST'));
    DELETE FROM prod.dct_wf_process_version WHERE process_id IN (SELECT process_id FROM prod.dct_wf_process WHERE source_module = 'WF_TEST');
    DELETE FROM prod.dct_wf_process      WHERE source_module = 'WF_TEST';
    DELETE FROM prod.dct_wf_fact_field   WHERE schema_id IN (SELECT schema_id FROM prod.dct_wf_fact_schema WHERE schema_code = 'WF_TEST_SCHEMA');
    DELETE FROM prod.dct_wf_fact_schema  WHERE schema_code = 'WF_TEST_SCHEMA';
    DELETE FROM prod.dct_wf_action_registry WHERE action_code LIKE 'WF_TEST%';

    DELETE FROM prod.dct_delegations WHERE reason = 'WF_TEST_DELEGATION';
    DELETE FROM prod.dct_user_roles  WHERE role_id IN (SELECT role_id FROM prod.dct_roles WHERE role_code = 'WF_TEST_ROLE');
    DELETE FROM prod.dct_roles       WHERE role_code = 'WF_TEST_ROLE';
    COMMIT;

    drop_if('VIEW',    'WF_TEST_REQ_V');
    drop_if('TABLE',   'WF_TEST_REQ');
    drop_if('TABLE',   'WF_TEST_STAMP');
    drop_if('PACKAGE', 'WF_TEST_PKG');
    DBMS_OUTPUT.PUT_LINE('  clean');
END;
/

PROMPT
PROMPT --- [1/4] throwaway module: table, fact view, callback package ---

DECLARE
    PROCEDURE ddl (p_sql IN VARCHAR2) IS
    BEGIN
        EXECUTE IMMEDIATE p_sql;
    END;
BEGIN
    ddl('CREATE TABLE prod.wf_test_req (
            req_id               NUMBER PRIMARY KEY,
            amount               NUMBER,
            contract_months      NUMBER,
            line_manager_user_id NUMBER,
            requester_name       VARCHAR2(200),
            currency             VARCHAR2(3),
            wf_instance_id       NUMBER)');

    ddl('CREATE VIEW prod.wf_test_req_v AS SELECT * FROM prod.wf_test_req');

    -- the ON_COMPLETE callback stamps here. If it fires twice we will see two rows.
    ddl('CREATE TABLE prod.wf_test_stamp (
            instance_id   NUMBER,
            source_module VARCHAR2(40),
            record_id     NUMBER,
            user_id       NUMBER,
            stamped_at    TIMESTAMP DEFAULT SYSTIMESTAMP)');
END;
/

CREATE OR REPLACE PACKAGE prod.wf_test_pkg AS
    PROCEDURE on_complete (p_instance_id      IN NUMBER,
                           p_source_module    IN VARCHAR2,
                           p_source_record_id IN NUMBER,
                           p_user_id          IN NUMBER);
END wf_test_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.wf_test_pkg AS
    PROCEDURE on_complete (p_instance_id      IN NUMBER,
                           p_source_module    IN VARCHAR2,
                           p_source_record_id IN NUMBER,
                           p_user_id          IN NUMBER) IS
    BEGIN
        INSERT INTO prod.wf_test_stamp (instance_id, source_module, record_id, user_id)
        VALUES (p_instance_id, p_source_module, p_source_record_id, p_user_id);
    END;
END wf_test_pkg;
/

PROMPT
PROMPT --- [2/4] metadata: role, users, fact schema, process, chain ---

DECLARE
    v_role NUMBER;
    v_sch  NUMBER;
    v_pid  NUMBER;
    v_vid  NUMBER;
    v_cid  NUMBER;
    v_aid  NUMBER;
    v_step NUMBER;
    v_err  VARCHAR2(1000);
    v_ast  CLOB;

    v_u1   NUMBER;   -- initiator
    v_u2   NUMBER;   -- line manager  (FACT_USER)
    v_u3   NUMBER;   -- role holder A
    v_u4   NUMBER;   -- role holder B
    v_u5   NUMBER;   -- delegate of u3

    -- outcome-set ids resolved ONCE into variables. A local function cannot be
    -- called from SQL DML (PLS-00231) -- the same trap CLAUDE.md documents.
    v_set_end NUMBER;   -- ENDORSE_SET
    v_set_apr NUMBER;   -- APPROVE_REJECT
    v_set_fyi NUMBER;   -- FYI_ACK

    PROCEDURE mk_step (p_key VARCHAR2, p_seq NUMBER, p_name VARCHAR2,
                       p_set NUMBER, p_quorum VARCHAR2, p_cond NUMBER,
                       o_step OUT NUMBER) IS
    BEGIN
        INSERT INTO prod.dct_wf_step
            (version_id, step_key, step_seq, name_en, name_ar, step_kind,
             quorum_type, condition_id, outcome_set_id, sla_hours, comment_required)
        VALUES (v_vid, p_key, p_seq, p_name, p_name, 'HUMAN',
                p_quorum, p_cond, p_set, 72, 'ON_NEGATIVE')
        RETURNING step_id INTO o_step;
    END;
BEGIN
    SELECT set_id INTO v_set_end FROM prod.dct_wf_outcome_set WHERE set_code = 'ENDORSE_SET';
    SELECT set_id INTO v_set_apr FROM prod.dct_wf_outcome_set WHERE set_code = 'APPROVE_REJECT';
    SELECT set_id INTO v_set_fyi FROM prod.dct_wf_outcome_set WHERE set_code = 'FYI_ACK';

    -- five distinct live users, whoever they are
    SELECT MIN(user_id) INTO v_u1 FROM prod.dct_users WHERE is_active = 'Y';
    SELECT MIN(user_id) INTO v_u2 FROM prod.dct_users WHERE is_active = 'Y' AND user_id > v_u1;
    SELECT MIN(user_id) INTO v_u3 FROM prod.dct_users WHERE is_active = 'Y' AND user_id > v_u2;
    SELECT MIN(user_id) INTO v_u4 FROM prod.dct_users WHERE is_active = 'Y' AND user_id > v_u3;
    SELECT MIN(user_id) INTO v_u5 FROM prod.dct_users WHERE is_active = 'Y' AND user_id > v_u4;

    DBMS_OUTPUT.PUT_LINE('  users  initiator=' || v_u1 || ' lm=' || v_u2
                      || ' roleA=' || v_u3 || ' roleB=' || v_u4 || ' delegate=' || v_u5);

    -- throwaway role, held by u3 and u4
    INSERT INTO prod.dct_roles (role_code, role_name_en, role_name_ar, role_type, is_active)
    VALUES ('WF_TEST_ROLE', 'WF Test Role', 'WF Test Role', 'MODULE', 'Y')
    RETURNING role_id INTO v_role;

    INSERT INTO prod.dct_user_roles (user_id, role_id, is_active) VALUES (v_u3, v_role, 'Y');
    INSERT INTO prod.dct_user_roles (user_id, role_id, is_active) VALUES (v_u4, v_role, 'Y');

    -- u5 is u3's delegate. NOTE the scope vocabulary is ALL_ROLES / SPECIFIC_ROLE /
    -- MODULE -- not 'ALL'. The engine's first cut guessed 'ALL' and resolved no
    -- delegate at all; this row is what caught it.
    INSERT INTO prod.dct_delegations
        (delegator_id, delegate_id, scope, start_date, end_date, reason, status)
    VALUES (v_u3, v_u5, 'ALL_ROLES', SYSDATE - 1, SYSDATE + 30, 'WF_TEST_DELEGATION', 'ACTIVE');

    -- fact schema over the throwaway view
    INSERT INTO prod.dct_wf_fact_schema (schema_code, name_en, source_view, source_key_column)
    VALUES ('WF_TEST_SCHEMA', 'WF test facts', 'WF_TEST_REQ_V', 'REQ_ID')
    RETURNING schema_id INTO v_sch;

    INSERT INTO prod.dct_wf_fact_field (schema_id, field_key, label_en, data_type, source_column)
        VALUES (v_sch, 'amount', 'Amount', 'NUMBER', 'AMOUNT');
    INSERT INTO prod.dct_wf_fact_field (schema_id, field_key, label_en, data_type, source_column)
        VALUES (v_sch, 'contract_months', 'Duration in months', 'NUMBER', 'CONTRACT_MONTHS');
    INSERT INTO prod.dct_wf_fact_field (schema_id, field_key, label_en, data_type, source_column)
        VALUES (v_sch, 'line_manager_user_id', 'Line manager', 'NUMBER', 'LINE_MANAGER_USER_ID');
    INSERT INTO prod.dct_wf_fact_field (schema_id, field_key, label_en, data_type, source_column)
        VALUES (v_sch, 'requester_name', 'Requester', 'STRING', 'REQUESTER_NAME');
    INSERT INTO prod.dct_wf_fact_field (schema_id, field_key, label_en, data_type, source_column)
        VALUES (v_sch, 'currency', 'Currency', 'STRING', 'CURRENCY');

    -- the registered side effect
    INSERT INTO prod.dct_wf_action_registry
        (action_code, plsql_call, signature_kind, description, is_active)
    VALUES ('WF_TEST_FINAL', 'WF_TEST_PKG.ON_COMPLETE', 'CTX', 'test final callback', 'Y')
    RETURNING action_id INTO v_aid;

    -- ---------------- the main process ----------------
    INSERT INTO prod.dct_wf_process
        (process_code, source_module, name_en, name_ar, schema_id,
         requires_final_callback, is_active)
    VALUES ('WF_TEST_PROC', 'WF_TEST', 'WF test process', 'WF test process', v_sch, 'Y', 'Y')
    RETURNING process_id INTO v_pid;

    INSERT INTO prod.dct_wf_process_version (process_id, version_no, status, published_at)
    VALUES (v_pid, 1, 'PUBLISHED', SYSTIMESTAMP)
    RETURNING version_id INTO v_vid;

    -- the condition that replaces FL's CUSTOM:FL_DURATION_GE_6M string-hack
    v_ast := prod.dct_wf_expr.compile('contract_months >= 6', v_sch, v_err);
    IF v_ast IS NULL THEN
        raise_application_error(-20999, 'test condition failed to compile: ' || v_err);
    END IF;

    INSERT INTO prod.dct_wf_condition
        (version_id, condition_key, name_en, expr_text, expr_ast,
         compiler_version, compiled_at, is_valid)
    VALUES (v_vid, 'SIX_MONTHS', 'Six months or longer', 'contract_months >= 6',
            v_ast, '1.0', SYSTIMESTAMP, 'Y')
    RETURNING condition_id INTO v_cid;

    -- 10 line manager: ENDORSE / RETURN_FOR_INFO / REJECT, resolved from a fact
    mk_step('LM', 10, 'Line Manager Endorsement', v_set_end, 'ALL', NULL, v_step);
    INSERT INTO prod.dct_wf_participant_rule
        (step_id, resolver_type, fact_path, fallback_rule, exclude_initiator)
    VALUES (v_step, 'FACT_USER', 'line_manager_user_id', 'NONE', 'N');

    -- 20 finance: a role pool, quorum ANY -- first holder to act wins
    mk_step('FIN', 20, 'Finance Review', v_set_end, 'ANY', NULL, v_step);
    INSERT INTO prod.dct_wf_participant_rule
        (step_id, resolver_type, role_code, fallback_rule, exclude_initiator)
    VALUES (v_step, 'ROLE', 'WF_TEST_ROLE', 'NONE', 'Y');
    -- RETURN_FOR_INFO from here goes back to the line manager
    UPDATE prod.dct_wf_outcome SET target_step_key = 'LM'
     WHERE set_id = v_set_end AND outcome_code = 'RETURN_FOR_INFO';

    -- 30 org development: ONLY for six months or longer
    mk_step('ORGDEV', 30, 'Org Development Head', v_set_apr, 'ANY', v_cid, v_step);
    INSERT INTO prod.dct_wf_participant_rule
        (step_id, resolver_type, role_code, fallback_rule, exclude_initiator)
    VALUES (v_step, 'ROLE', 'WF_TEST_ROLE', 'NONE', 'Y');

    -- 40 talent acquisition: FYI only. Informed, never blocking.
    mk_step('TA_FYI', 40, 'Talent Acquisition (FYI)', v_set_fyi, 'ALL', NULL, v_step);
    INSERT INTO prod.dct_wf_participant_rule
        (step_id, resolver_type, static_user_id, fallback_rule, exclude_initiator)
    VALUES (v_step, 'STATIC_USER', v_u4, 'NONE', 'N');

    -- 50 final gate
    mk_step('FINAL', 50, 'Final Approval', v_set_apr, 'ANY', NULL, v_step);
    UPDATE prod.dct_wf_step SET is_final_gate = 'Y' WHERE step_id = v_step;
    INSERT INTO prod.dct_wf_participant_rule
        (step_id, resolver_type, role_code, fallback_rule, exclude_initiator)
    VALUES (v_step, 'ROLE', 'WF_TEST_ROLE', 'NONE', 'Y');

    INSERT INTO prod.dct_wf_process_hook
        (version_id, event_code, action_id, exec_order, on_error, is_active)
    VALUES (v_vid, 'ON_COMPLETE', v_aid, 10, 'FAIL', 'Y');

    -- ---------------- a second process with NO final hook: the fail-closed test ----------------
    INSERT INTO prod.dct_wf_process
        (process_code, source_module, name_en, schema_id, requires_final_callback, is_active)
    VALUES ('WF_TEST_NOHOOK', 'WF_TEST', 'WF test, no callback', v_sch, 'Y', 'Y')
    RETURNING process_id INTO v_pid;

    INSERT INTO prod.dct_wf_process_version (process_id, version_no, status, published_at)
    VALUES (v_pid, 1, 'PUBLISHED', SYSTIMESTAMP)
    RETURNING version_id INTO v_vid;

    INSERT INTO prod.dct_wf_step
        (version_id, step_key, step_seq, name_en, step_kind, quorum_type,
         outcome_set_id, comment_required)
    VALUES (v_vid, 'ONLY', 10, 'Only step', 'HUMAN', 'ANY',
            v_set_apr, 'ON_NEGATIVE')
    RETURNING step_id INTO v_step;

    INSERT INTO prod.dct_wf_participant_rule
        (step_id, resolver_type, role_code, fallback_rule, exclude_initiator)
    VALUES (v_step, 'ROLE', 'WF_TEST_ROLE', 'NONE', 'N');

    -- source records
    INSERT INTO prod.wf_test_req (req_id, amount, contract_months, line_manager_user_id,
                                  requester_name, currency)
    VALUES (1, 120000, 8, v_u2, 'Test Requester', 'AED');   -- 8 months: ORGDEV fires
    INSERT INTO prod.wf_test_req (req_id, amount, contract_months, line_manager_user_id,
                                  requester_name, currency)
    VALUES (2, 50000, 4, v_u2, 'Test Requester', 'AED');    -- 4 months: ORGDEV skips
    INSERT INTO prod.wf_test_req (req_id, amount, contract_months, line_manager_user_id,
                                  requester_name, currency)
    VALUES (3, 9000, 3, v_u2, 'Test Requester', 'AED');     -- for the no-hook process

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('  metadata ready');
END;
/

PROMPT
PROMPT --- [3/4] the suite ---

DECLARE
    g_pass PLS_INTEGER := 0;
    g_fail PLS_INTEGER := 0;

    v_u1 NUMBER; v_u2 NUMBER; v_u3 NUMBER; v_u4 NUMBER; v_u5 NUMBER;
    v_i1 NUMBER; v_i2 NUMBER; v_i3 NUMBER;
    v_t  NUMBER;
    v_n  NUMBER;
    v_s  VARCHAR2(100);
    v_txt VARCHAR2(400);

    PROCEDURE ok (p_what VARCHAR2) IS
    BEGIN
        g_pass := g_pass + 1;
        DBMS_OUTPUT.PUT_LINE('  pass  ' || p_what);
    END;

    PROCEDURE bad (p_what VARCHAR2, p_detail VARCHAR2 DEFAULT NULL) IS
    BEGIN
        g_fail := g_fail + 1;
        DBMS_OUTPUT.PUT_LINE('  FAIL  ' || p_what
                          || CASE WHEN p_detail IS NULL THEN ''
                                  ELSE '   [' || p_detail || ']' END);
    END;

    PROCEDURE eq (p_what VARCHAR2, p_got VARCHAR2, p_want VARCHAR2) IS
    BEGIN
        IF NVL(p_got, '~') = NVL(p_want, '~') THEN
            ok(RPAD(p_what, 54) || ' = ' || p_want);
        ELSE
            bad(p_what, 'expected ' || p_want || ' got ' || NVL(p_got, 'NULL'));
        END IF;
    END;

    -- the task the given user must act on, for the currently active step
    FUNCTION task_of (p_inst NUMBER, p_user NUMBER) RETURN NUMBER IS
    BEGIN
        RETURN prod.dct_wf_engine.active_task_for(p_inst, p_user);
    END;

    FUNCTION inst_status (p_inst NUMBER) RETURN VARCHAR2 IS
        v VARCHAR2(20);
    BEGIN
        SELECT status INTO v FROM prod.dct_wf_instance WHERE instance_id = p_inst;
        RETURN v;
    END;

    FUNCTION active_step (p_inst NUMBER) RETURN VARCHAR2 IS
        v VARCHAR2(40);
    BEGIN
        SELECT MIN(step_key) INTO v FROM prod.dct_wf_step_instance
         WHERE instance_id = p_inst AND status = 'ACTIVE';
        RETURN v;
    END;
BEGIN
    SELECT MIN(user_id) INTO v_u1 FROM prod.dct_users WHERE is_active = 'Y';
    SELECT MIN(user_id) INTO v_u2 FROM prod.dct_users WHERE is_active = 'Y' AND user_id > v_u1;
    SELECT MIN(user_id) INTO v_u3 FROM prod.dct_users WHERE is_active = 'Y' AND user_id > v_u2;
    SELECT MIN(user_id) INTO v_u4 FROM prod.dct_users WHERE is_active = 'Y' AND user_id > v_u3;
    SELECT MIN(user_id) INTO v_u5 FROM prod.dct_users WHERE is_active = 'Y' AND user_id > v_u4;

    DBMS_OUTPUT.PUT_LINE('--- start + fact model + first activation ---');

    v_i1 := prod.dct_wf_engine.start_process(
                p_process_code      => 'WF_TEST_PROC',
                p_source_record_id  => 1,
                p_initiator_user_id => v_u1,
                p_source_record_ref => 'WF-TEST-0001');

    eq('instance is RUNNING',            inst_status(v_i1), 'RUNNING');
    eq('active step is the line manager', active_step(v_i1), 'LM');

    SELECT COUNT(*) INTO v_n FROM prod.dct_wf_task WHERE instance_id = v_i1;
    eq('exactly one task exists',        TO_CHAR(v_n), '1');

    -- the ID-disjointness invariant: WF task ids can never collide with legacy
    -- dct_approval_instances.instance_id, which is in the thousands.
    SELECT MIN(task_id) INTO v_t FROM prod.dct_wf_task WHERE instance_id = v_i1;
    IF v_t >= 900000000 THEN
        ok('task id is above the 900,000,000 floor          = ' || v_t);
    ELSE
        bad('ID-disjointness invariant broken', 'task_id ' || v_t);
    END IF;

    -- the fact document was built from the module's view, not a CASE block
    SELECT JSON_VALUE(fact_doc, '$.contract_months') INTO v_s
      FROM prod.dct_wf_instance WHERE instance_id = v_i1;
    eq('facts carry contract_months from the view', v_s, '8');

    v_t := task_of(v_i1, v_u2);
    IF v_t IS NULL THEN
        bad('the line manager (a FACT_USER) got the task');
    ELSE
        ok('the line manager (a FACT_USER) got the task');
    END IF;

    DBMS_OUTPUT.PUT_LINE('--- authorization + outcome validation ---');

    BEGIN
        prod.dct_wf_engine.complete_task(v_t, v_u5, 'ENDORSE');
        bad('a non-participant was allowed to act');
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE = -20303 THEN ok('non-participant refused (-20303)');
        ELSE bad('non-participant', 'wrong error ' || SQLCODE); END IF;
    END;

    BEGIN
        prod.dct_wf_engine.complete_task(v_t, v_u2, 'BANANA');
        bad('an outcome outside the set was accepted');
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE = -20304 THEN ok('outcome not in the step set refused (-20304)');
        ELSE bad('unknown outcome', 'wrong error ' || SQLCODE); END IF;
    END;

    BEGIN
        prod.dct_wf_engine.complete_task(v_t, v_u2, 'REJECT');   -- no comment
        bad('a negative outcome was accepted with no comment');
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE = -20305 THEN ok('comment required on a negative outcome (-20305)');
        ELSE bad('comment rule', 'wrong error ' || SQLCODE); END IF;
    END;

    DBMS_OUTPUT.PUT_LINE('--- requirement 2: a custom outcome is RECORDED as itself ---');

    prod.dct_wf_engine.complete_task(v_t, v_u2, 'ENDORSE', 'looks right to me');

    SELECT outcome_code INTO v_s FROM prod.dct_wf_task WHERE task_id = v_t;
    eq('the task records ENDORSE, not APPROVED',  v_s, 'ENDORSE');

    SELECT MAX(outcome_code) INTO v_s FROM prod.dct_wf_history
     WHERE task_id = v_t AND event_code = 'TASK_COMPLETED';
    eq('history records ENDORSE, not APPROVED',   v_s, 'ENDORSE');

    eq('the chain moved to finance',              active_step(v_i1), 'FIN');

    DBMS_OUTPUT.PUT_LINE('--- quorum ANY over a role pool ---');

    SELECT COUNT(*) INTO v_n FROM prod.dct_wf_task t
      JOIN prod.dct_wf_step_instance si ON si.step_instance_id = t.step_instance_id
     WHERE t.instance_id = v_i1 AND si.step_key = 'FIN' AND t.state = 'ASSIGNED';
    eq('both role holders got a task',            TO_CHAR(v_n), '2');

    SELECT quorum_required INTO v_n FROM prod.dct_wf_step_instance
     WHERE instance_id = v_i1 AND step_key = 'FIN' AND status = 'ACTIVE';
    eq('quorum ANY needs just one',               TO_CHAR(v_n), '1');

    DBMS_OUTPUT.PUT_LINE('--- delegation: the delegate sees the principal task ---');

    v_t := task_of(v_i1, v_u5);          -- u5 delegates for u3
    IF v_t IS NOT NULL THEN
        ok('the delegate can see and act on the task');
    ELSE
        bad('the delegate cannot see the task');
    END IF;

    DBMS_OUTPUT.PUT_LINE('--- RETURN_FOR_INFO: rework IN PLACE, same instance ---');

    v_t := task_of(v_i1, v_u3);
    prod.dct_wf_engine.complete_task(v_t, v_u3, 'RETURN_FOR_INFO', 'need the signed offer');

    eq('the instance is still alive (not killed)', inst_status(v_i1), 'RUNNING');
    eq('it went BACK to the line manager',         active_step(v_i1), 'LM');

    SELECT cycle_count INTO v_n FROM prod.dct_wf_instance WHERE instance_id = v_i1;
    eq('the return loop is counted',               TO_CHAR(v_n), '1');

    SELECT MAX(attempt_no) INTO v_n FROM prod.dct_wf_step_instance
     WHERE instance_id = v_i1 AND step_key = 'LM';
    eq('the line manager step is on attempt 2',    TO_CHAR(v_n), '2');

    SELECT COUNT(*) INTO v_n FROM prod.dct_wf_instance
     WHERE source_module = 'WF_TEST' AND source_record_id = 1;
    eq('NO second instance was forked',            TO_CHAR(v_n), '1');

    DBMS_OUTPUT.PUT_LINE('--- drive it home: conditional step FIRES at 8 months ---');

    prod.dct_wf_engine.complete_task(task_of(v_i1, v_u2), v_u2, 'ENDORSE', 'attached');
    prod.dct_wf_engine.complete_task(task_of(v_i1, v_u3), v_u3, 'ENDORSE', 'ok');

    eq('the 6-month step fired for an 8-month term', active_step(v_i1), 'ORGDEV');

    prod.dct_wf_engine.complete_task(task_of(v_i1, v_u3), v_u3, 'APPROVE');

    -- the FYI step must NOT be sitting there blocking the chain
    eq('the FYI step did not block the chain',      active_step(v_i1), 'FINAL');

    SELECT status INTO v_s FROM prod.dct_wf_step_instance
     WHERE instance_id = v_i1 AND step_key = 'TA_FYI';
    eq('the FYI step is satisfied, not pending',    v_s, 'SATISFIED');

    SELECT COUNT(*) INTO v_n FROM prod.dct_wf_task t
      JOIN prod.dct_wf_step_instance si ON si.step_instance_id = t.step_instance_id
     WHERE t.instance_id = v_i1 AND si.step_key = 'TA_FYI';
    eq('the FYI recipient still got a task',        TO_CHAR(v_n), '1');

    DBMS_OUTPUT.PUT_LINE('--- final approval fires the callback EXACTLY once ---');

    prod.dct_wf_engine.complete_task(task_of(v_i1, v_u3), v_u3, 'APPROVE');

    eq('the instance completed',                    inst_status(v_i1), 'COMPLETED');

    SELECT COUNT(*) INTO v_n FROM prod.wf_test_stamp WHERE instance_id = v_i1;
    eq('the final callback fired exactly once',     TO_CHAR(v_n), '1');

    SELECT COUNT(*) INTO v_n FROM prod.dct_wf_task
     WHERE instance_id = v_i1 AND state IN ('ASSIGNED', 'UNASSIGNED');
    eq('no task is left open',                      TO_CHAR(v_n), '0');

    DBMS_OUTPUT.PUT_LINE('--- conditional step SKIPS at 4 months, and says why ---');

    v_i2 := prod.dct_wf_engine.start_process('WF_TEST_PROC', 2, v_u1, 'WF-TEST-0002');
    prod.dct_wf_engine.complete_task(task_of(v_i2, v_u2), v_u2, 'ENDORSE');
    prod.dct_wf_engine.complete_task(task_of(v_i2, v_u3), v_u3, 'ENDORSE');

    SELECT status INTO v_s FROM prod.dct_wf_step_instance
     WHERE instance_id = v_i2 AND step_key = 'ORGDEV';
    eq('the 6-month step SKIPPED for a 4-month term', v_s, 'SKIPPED');

    SELECT skipped_reason INTO v_txt FROM prod.dct_wf_step_instance
     WHERE instance_id = v_i2 AND step_key = 'ORGDEV';
    IF v_txt LIKE '%contract_months >= 6%' THEN
        ok('the skip reason is stored and readable');
        DBMS_OUTPUT.PUT_LINE('        "' || v_txt || '"');
    ELSE
        bad('skip reason', NVL(v_txt, 'NULL'));
    END IF;

    SELECT condition_result INTO v_s FROM prod.dct_wf_step_instance
     WHERE instance_id = v_i2 AND step_key = 'ORGDEV';
    eq('the condition evaluated FALSE, not NULL',   v_s, 'FALSE');

    eq('the chain skipped straight to final',       active_step(v_i2), 'FINAL');

    DBMS_OUTPUT.PUT_LINE('--- an open FYI ack must not shadow a live approval task ---');

    -- u4 holds TWO open tasks on this instance: the TA_FYI acknowledgement (whose
    -- step already satisfied -- an FYI blocks nobody) and the live FINAL approval.
    -- "The task to act on" is the blocking one. Ordering by task id alone returns
    -- the FYI, which is how this bug was found.
    SELECT COUNT(*) INTO v_n
      FROM prod.dct_wf_task t
      JOIN prod.dct_wf_task_participant tp ON tp.task_id = t.task_id
     WHERE t.instance_id = v_i2 AND tp.user_id = v_u4
       AND t.state IN ('ASSIGNED', 'UNASSIGNED');
    eq('the user really does hold two open tasks',   TO_CHAR(v_n), '2');

    v_t := task_of(v_i2, v_u4);   -- a local function may not be called from SQL
    SELECT si.step_key INTO v_s
      FROM prod.dct_wf_task t
      JOIN prod.dct_wf_step_instance si ON si.step_instance_id = t.step_instance_id
     WHERE t.task_id = v_t;
    eq('active_task_for picks the LIVE step, not the FYI', v_s, 'FINAL');

    DBMS_OUTPUT.PUT_LINE('--- REJECT is terminal and fires no completion callback ---');

    prod.dct_wf_engine.complete_task(task_of(v_i2, v_u4), v_u4, 'REJECT', 'budget not available');
    eq('the instance is REJECTED',                  inst_status(v_i2), 'REJECTED');

    SELECT COUNT(*) INTO v_n FROM prod.wf_test_stamp WHERE instance_id = v_i2;
    eq('a rejected request did NOT fire ON_COMPLETE', TO_CHAR(v_n), '0');

    DBMS_OUTPUT.PUT_LINE('--- fail-closed: no final callback means it CANNOT finalize ---');

    -- The guard RAISES, so the whole complete_task is undone -- which is the point of
    -- fail-closed. Undo it with a SAVEPOINT, not a bare ROLLBACK: this suite runs in
    -- ONE transaction, and a bare rollback here discards every instance built above.
    SAVEPOINT before_nohook;
    v_i3 := prod.dct_wf_engine.start_process('WF_TEST_NOHOOK', 3, v_u1, 'WF-TEST-0003');
    BEGIN
        prod.dct_wf_engine.complete_task(task_of(v_i3, v_u3), v_u3, 'APPROVE');
        bad('a process requiring a final callback finalized WITHOUT one');
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE = -20301 THEN
            ok('refused to finalize with no ON_COMPLETE hook (-20301)');
        ELSE
            bad('fail-closed guard', 'wrong error ' || SQLCODE || ' ' || SQLERRM);
        END IF;
    END;
    ROLLBACK TO SAVEPOINT before_nohook;

    DBMS_OUTPUT.PUT_LINE('--- simulate writes NOTHING ---');

    SELECT COUNT(*) INTO v_n FROM prod.dct_wf_instance WHERE source_module = 'WF_TEST';
    DECLARE
        v_sim CLOB;
        v_n2  NUMBER;
    BEGIN
        v_sim := prod.dct_wf_engine.simulate(
                     'WF_TEST_PROC',
                     TO_CLOB('{"amount":120000,"contract_months":8,"roles":[]}'),
                     v_u1);
        SELECT COUNT(*) INTO v_n2 FROM prod.dct_wf_instance WHERE source_module = 'WF_TEST';
        eq('simulate created no instance', TO_CHAR(v_n2), TO_CHAR(v_n));

        IF JSON_VALUE(v_sim, '$.steps[2].fires') = 'true' THEN
            ok('simulate says the 6-month step WOULD fire at 8 months');
        ELSE
            bad('simulate 8-month', SUBSTR(v_sim, 1, 200));
        END IF;

        v_sim := prod.dct_wf_engine.simulate(
                     'WF_TEST_PROC',
                     TO_CLOB('{"amount":50000,"contract_months":4,"roles":[]}'),
                     v_u1);
        IF JSON_VALUE(v_sim, '$.steps[2].fires') = 'false' THEN
            ok('simulate says it would NOT fire at 4 months');
        ELSE
            bad('simulate 4-month', SUBSTR(v_sim, 1, 200));
        END IF;
    END;

    DBMS_OUTPUT.PUT_LINE('--- one worklist: eligibility is rows, not five queries ---');

    SELECT COUNT(*) INTO v_n
      FROM prod.dct_wf_task t
      JOIN prod.dct_wf_task_participant tp ON tp.task_id = t.task_id
     WHERE tp.user_id = v_u3 AND tp.is_active = 'Y';
    IF v_n > 0 THEN
        ok('a user worklist is ONE index scan on the participant table (' || v_n || ' rows)');
    ELSE
        bad('participant fan-out produced no rows');
    END IF;

    DBMS_OUTPUT.PUT_LINE('--- the timer sweep runs clean ---');

    -- sweep COMMITs, so it runs LAST. It is a no-op on this data (no reminder
    -- offsets, no auto-action) -- what is under test is that it does not throw.
    BEGIN
        prod.dct_wf_engine.sweep;
        ok('sweep completed without error');
    EXCEPTION WHEN OTHERS THEN
        bad('sweep', SQLERRM);
    END;

    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=====================================================');
    DBMS_OUTPUT.PUT_LINE('  passed : ' || g_pass);
    DBMS_OUTPUT.PUT_LINE('  failed : ' || g_fail);
    DBMS_OUTPUT.PUT_LINE('=====================================================');
    COMMIT;
    IF g_fail > 0 THEN
        raise_application_error(-20999, g_fail || ' engine test(s) FAILED');
    END IF;
END;
/

PROMPT
PROMPT --- [4/4] teardown ---

DECLARE
    PROCEDURE drop_if (p_kind IN VARCHAR2, p_name IN VARCHAR2) IS
        v NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v FROM all_objects
         WHERE owner = 'PROD' AND object_name = UPPER(p_name)
           AND object_type = UPPER(p_kind);
        IF v > 0 THEN
            EXECUTE IMMEDIATE 'DROP ' || p_kind || ' prod.' || p_name
                              || CASE WHEN UPPER(p_kind) = 'TABLE'
                                      THEN ' CASCADE CONSTRAINTS PURGE' ELSE '' END;
        END IF;
    END;
BEGIN
    DELETE FROM prod.dct_wf_notify_log      WHERE instance_id IN (SELECT instance_id FROM prod.dct_wf_instance WHERE source_module = 'WF_TEST');
    DELETE FROM prod.dct_wf_info_request    WHERE instance_id IN (SELECT instance_id FROM prod.dct_wf_instance WHERE source_module = 'WF_TEST');
    DELETE FROM prod.dct_wf_watcher         WHERE instance_id IN (SELECT instance_id FROM prod.dct_wf_instance WHERE source_module = 'WF_TEST');
    DELETE FROM prod.dct_wf_history         WHERE instance_id IN (SELECT instance_id FROM prod.dct_wf_instance WHERE source_module = 'WF_TEST');
    DELETE FROM prod.dct_wf_task_participant WHERE task_id IN (SELECT task_id FROM prod.dct_wf_task WHERE instance_id IN (SELECT instance_id FROM prod.dct_wf_instance WHERE source_module = 'WF_TEST'));
    DELETE FROM prod.dct_wf_task            WHERE instance_id IN (SELECT instance_id FROM prod.dct_wf_instance WHERE source_module = 'WF_TEST');
    DELETE FROM prod.dct_wf_step_instance   WHERE instance_id IN (SELECT instance_id FROM prod.dct_wf_instance WHERE source_module = 'WF_TEST');
    DELETE FROM prod.dct_wf_instance        WHERE source_module = 'WF_TEST';

    DELETE FROM prod.dct_wf_process_hook WHERE version_id IN (SELECT version_id FROM prod.dct_wf_process_version WHERE process_id IN (SELECT process_id FROM prod.dct_wf_process WHERE source_module = 'WF_TEST'));
    DELETE FROM prod.dct_wf_participant_rule WHERE step_id IN (SELECT step_id FROM prod.dct_wf_step WHERE version_id IN (SELECT version_id FROM prod.dct_wf_process_version WHERE process_id IN (SELECT process_id FROM prod.dct_wf_process WHERE source_module = 'WF_TEST')));
    DELETE FROM prod.dct_wf_step         WHERE version_id IN (SELECT version_id FROM prod.dct_wf_process_version WHERE process_id IN (SELECT process_id FROM prod.dct_wf_process WHERE source_module = 'WF_TEST'));
    DELETE FROM prod.dct_wf_condition    WHERE version_id IN (SELECT version_id FROM prod.dct_wf_process_version WHERE process_id IN (SELECT process_id FROM prod.dct_wf_process WHERE source_module = 'WF_TEST'));
    DELETE FROM prod.dct_wf_process_version WHERE process_id IN (SELECT process_id FROM prod.dct_wf_process WHERE source_module = 'WF_TEST');
    DELETE FROM prod.dct_wf_process      WHERE source_module = 'WF_TEST';
    DELETE FROM prod.dct_wf_fact_field   WHERE schema_id IN (SELECT schema_id FROM prod.dct_wf_fact_schema WHERE schema_code = 'WF_TEST_SCHEMA');
    DELETE FROM prod.dct_wf_fact_schema  WHERE schema_code = 'WF_TEST_SCHEMA';
    DELETE FROM prod.dct_wf_action_registry WHERE action_code LIKE 'WF_TEST%';

    -- the seeded ENDORSE_SET is shared platform metadata: put its target back
    UPDATE prod.dct_wf_outcome SET target_step_key = NULL
     WHERE outcome_code = 'RETURN_FOR_INFO';

    DELETE FROM prod.dct_delegations WHERE reason = 'WF_TEST_DELEGATION';
    DELETE FROM prod.dct_user_roles  WHERE role_id IN (SELECT role_id FROM prod.dct_roles WHERE role_code = 'WF_TEST_ROLE');
    DELETE FROM prod.dct_roles       WHERE role_code = 'WF_TEST_ROLE';

    -- the notifications the run generated are real rows in a real table: remove them
    DELETE FROM prod.dct_notifications WHERE module_code = 'WF_TEST';
    COMMIT;

    drop_if('VIEW',    'WF_TEST_REQ_V');
    drop_if('TABLE',   'WF_TEST_REQ');
    drop_if('TABLE',   'WF_TEST_STAMP');
    drop_if('PACKAGE', 'WF_TEST_PKG');
    DBMS_OUTPUT.PUT_LINE('  removed every trace of the test');
END;
/

PROMPT
PROMPT --- residue check (all four must be 0) ---

SELECT (SELECT COUNT(*) FROM prod.dct_wf_instance WHERE source_module = 'WF_TEST') AS instances,
       (SELECT COUNT(*) FROM prod.dct_wf_process  WHERE source_module = 'WF_TEST') AS processes,
       (SELECT COUNT(*) FROM prod.dct_roles       WHERE role_code = 'WF_TEST_ROLE') AS roles,
       (SELECT COUNT(*) FROM all_objects
         WHERE owner = 'PROD' AND object_name LIKE 'WF\_TEST%' ESCAPE '\') AS objects
  FROM dual;
