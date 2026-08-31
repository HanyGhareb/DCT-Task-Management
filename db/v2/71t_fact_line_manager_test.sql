SET SERVEROUTPUT ON
SET SQLBLANKLINES ON
SET DEFINE OFF
-- 71t: FACT_LINE_MANAGER resolves the SUBJECT's line manager, not the submitter's.
-- Self-contained: builds a throwaway subject to manager hierarchy on two existing
-- users, simulates an on-behalf request, asserts, and ROLLBACKs. Persists nothing.
DECLARE
    u_sub NUMBER; u_mgr NUMBER; u_init NUMBER; mgr_name VARCHAR2(200);
    p_sub NUMBER; p_mgr NUMBER;
    v_sch NUMBER; v_pid NUMBER; v_ver NUMBER; v_step NUMBER;
    v_res CLOB; v_facts CLOB;
    o JSON_OBJECT_T; steps JSON_ARRAY_T; s0 JSON_OBJECT_T; appr JSON_ARRAY_T;
    found BOOLEAN := FALSE; hit VARCHAR2(400);
    pass NUMBER := 0; fail NUMBER := 0;
    PROCEDURE ck (cond BOOLEAN, msg VARCHAR2) IS
    BEGIN
        IF cond THEN pass := pass + 1; DBMS_OUTPUT.PUT_LINE('  pass  ' || msg);
        ELSE fail := fail + 1; DBMS_OUTPUT.PUT_LINE('  FAIL  ' || msg); END IF;
    END;
BEGIN
    SELECT MIN(user_id) INTO u_mgr FROM prod.dct_users WHERE is_active = 'Y';
    SELECT MIN(user_id) INTO u_sub FROM prod.dct_users WHERE is_active = 'Y' AND user_id > u_mgr;
    SELECT MAX(user_id) INTO u_init FROM prod.dct_users WHERE is_active = 'Y';
    SELECT display_name INTO mgr_name FROM prod.dct_users WHERE user_id = u_mgr;

    -- throwaway hierarchy: subject -> manager (person_id is identity: let it assign)
    INSERT INTO prod.dct_employees(employee_number,first_name_en,last_name_en,email,is_active,created_at,updated_at,manager_person_id)
        VALUES ('E990001','Mgr','Person','mgr@t.local','Y',SYSTIMESTAMP,SYSTIMESTAMP,NULL) RETURNING person_id INTO p_mgr;
    INSERT INTO prod.dct_employees(employee_number,first_name_en,last_name_en,email,is_active,created_at,updated_at,manager_person_id)
        VALUES ('E990002','Sub','Person','sub@t.local','Y',SYSTIMESTAMP,SYSTIMESTAMP,p_mgr) RETURNING person_id INTO p_sub;
    UPDATE prod.dct_users SET person_id = p_mgr WHERE user_id = u_mgr;
    UPDATE prod.dct_users SET person_id = p_sub WHERE user_id = u_sub;

    -- throwaway process with ONE FACT_LINE_MANAGER step on $.onBehalfOfUserId
    INSERT INTO prod.dct_wf_fact_schema(schema_code,name_en,source_view,source_key_column)
        VALUES('OBH_TEST_SCH','obh','DUAL','X') RETURNING schema_id INTO v_sch;
    INSERT INTO prod.dct_wf_process(process_code,source_module,name_en,schema_id,requires_final_callback,is_active)
        VALUES('OBH_TEST','DEMO','on behalf test',v_sch,'N','N') RETURNING process_id INTO v_pid;
    INSERT INTO prod.dct_wf_process_version(process_id,version_no,status)
        VALUES(v_pid,1,'PUBLISHED') RETURNING version_id INTO v_ver;
    INSERT INTO prod.dct_wf_step(version_id,step_key,step_seq,name_en)
        VALUES(v_ver,'OBH',10,'on behalf approver') RETURNING step_id INTO v_step;
    INSERT INTO prod.dct_wf_participant_rule(step_id,resolver_type,fact_path,fallback_rule)
        VALUES(v_step,'FACT_LINE_MANAGER','$.onBehalfOfUserId','FAIL');

    -- simulate: on behalf of the SUBJECT, submitted by a DIFFERENT user
    v_facts := '{"onBehalfOfUserId": ' || u_sub || '}';
    v_res := prod.dct_wf_engine.simulate('OBH_TEST', v_facts, u_init);

    o     := JSON_OBJECT_T.parse(v_res);
    steps := o.get_array('steps');
    s0    := JSON_OBJECT_T(steps.get(0));
    appr  := s0.get_array('approvers');
    FOR i IN 0 .. appr.get_size - 1 LOOP
        IF INSTR(appr.get_string(i), 'FACT_LINE_MANAGER') > 0 THEN
            found := TRUE; hit := appr.get_string(i);
        END IF;
    END LOOP;

    ck(s0.get_boolean('fires'), 'step fires');
    ck(found, 'resolved via FACT_LINE_MANAGER: ' || NVL(hit, '(none)'));
    ck(found AND INSTR(hit, mgr_name) > 0,
       'approver is the SUBJECT''s manager (' || mgr_name || '), not the submitter u#' || u_init);

    DBMS_OUTPUT.PUT_LINE('RESULT ' || pass || ' pass / ' || fail || ' fail');
    ROLLBACK;
END;
/
EXIT
