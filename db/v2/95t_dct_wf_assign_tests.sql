SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON
-- 95t: DCT_WF_ASSIGN + ASSIGNED_ROLE resolver tests. Self-cleaning: every
-- block ROLLBACKs (audit rows are autonomous and orphaned, invisible to the
-- audit view). Uses real master rows read-only; writes only assignment rows.

PROMPT === part 1: pkg CRUD, canon, dates, policy, org walk ===

DECLARE
    u1 NUMBER; u2 NUMBER; u3 NUMBER;
    v_proj VARCHAR2(100); v_sect VARCHAR2(100);
    v_child NUMBER; v_parent NUMBER;
    v_id NUMBER; v_id2 NUMBER; v_new NUMBER; n NUMBER;
    v_lst sys.odcinumberlist;
    pass NUMBER := 0; fail NUMBER := 0;
    PROCEDURE ck (b BOOLEAN, m VARCHAR2) IS
    BEGIN
        IF b THEN pass := pass + 1; DBMS_OUTPUT.PUT_LINE('  pass  ' || m);
        ELSE fail := fail + 1; DBMS_OUTPUT.PUT_LINE('  FAIL  ' || m); END IF;
    END;
    FUNCTION has_user (l sys.odcinumberlist, u NUMBER) RETURN BOOLEAN IS
    BEGIN
        FOR i IN 1 .. l.COUNT LOOP
            IF l(i) = u THEN RETURN TRUE; END IF;
        END LOOP;
        RETURN FALSE;
    END;
BEGIN
    SELECT MIN(user_id) INTO u1 FROM prod.dct_users WHERE is_active = 'Y';
    SELECT MIN(user_id) INTO u2 FROM prod.dct_users WHERE is_active = 'Y' AND user_id > u1;
    SELECT MIN(user_id) INTO u3 FROM prod.dct_users WHERE is_active = 'Y' AND user_id > u2;
    SELECT MIN(project_number) INTO v_proj FROM prod.v_dct_wf_obj_project;
    SELECT MIN(value_code) INTO v_sect FROM prod.v_dct_wf_obj_sector;
    SELECT MIN(org_id) INTO v_child FROM prod.dct_organizations WHERE parent_org_id IS NOT NULL;
    SELECT parent_org_id INTO v_parent FROM prod.dct_organizations WHERE org_id = v_child;

    ck(prod.dct_wf_assign.canon('DEPARTMENT', '007') = '7', 'canon strips zeros on numeric type');
    ck(prod.dct_wf_assign.canon('COST_CENTER', ' 0410 ') = '0410', 'canon preserves string-key zeros, trims');

    BEGIN
        v_id := prod.dct_wf_assign.create_assignment('TEST', 'PROJECT', 'NO_SUCH_PROJ_X',
                    NULL, 'WF_FBP', u1, TRUNC(SYSDATE), NULL, NULL);
        ck(FALSE, 'nonexistent object rejected');
    EXCEPTION WHEN OTHERS THEN
        ck(SQLCODE = -20001, 'nonexistent object rejected (' || SQLCODE || ')');
    END;

    v_id := prod.dct_wf_assign.create_assignment('TEST', 'PROJECT', v_proj, NULL,
                'WF_FBP', u1, TRUNC(SYSDATE) - 30, NULL, 'test fbp');
    ck(v_id IS NOT NULL, 'FBP created on project ' || v_proj);
    SELECT COUNT(*) INTO n FROM prod.dct_wf_role_assignment
     WHERE assignment_id = v_id AND object_label IS NOT NULL;
    ck(n = 1, 'object label snapshotted');

    BEGIN
        v_id2 := prod.dct_wf_assign.create_assignment('TEST', 'PROJECT', v_proj, NULL,
                     'WF_FBP', u2, TRUNC(SYSDATE), NULL, NULL);
        ck(FALSE, 'single-assignee overlap rejected');
    EXCEPTION WHEN OTHERS THEN
        ck(SQLCODE = -20001 AND INSTR(SQLERRM, 'single-assignee') > 0,
           'single-assignee overlap rejected');
    END;

    v_id2 := prod.dct_wf_assign.create_assignment('TEST', 'PROJECT', v_proj, NULL,
                 'WF_FYI_GROUP', u1, TRUNC(SYSDATE), NULL, NULL);
    v_id2 := prod.dct_wf_assign.create_assignment('TEST', 'PROJECT', v_proj, NULL,
                 'WF_FYI_GROUP', u2, TRUNC(SYSDATE), NULL, NULL);
    v_lst := prod.dct_wf_assign.resolve_preview('PROJECT', v_proj, NULL, 'WF_FYI_GROUP');
    ck(v_lst.COUNT = 2, 'group role holds two assignees (' || v_lst.COUNT || ')');

    v_lst := prod.dct_wf_assign.resolve_preview('PROJECT', v_proj, NULL, 'WF_FBP',
                 TRUNC(SYSDATE) - 30);
    ck(has_user(v_lst, u1), 'as-of start date inclusive');
    v_lst := prod.dct_wf_assign.resolve_preview('PROJECT', v_proj, NULL, 'WF_FBP',
                 TRUNC(SYSDATE) - 31);
    ck(v_lst.COUNT = 0, 'day before start excluded');

    prod.dct_wf_assign.end_assignment('TEST', v_id, TRUNC(SYSDATE) - 1, NULL);
    v_lst := prod.dct_wf_assign.resolve_preview('PROJECT', v_proj, NULL, 'WF_FBP',
                 TRUNC(SYSDATE) - 1);
    ck(has_user(v_lst, u1), 'as-of end date inclusive');
    v_lst := prod.dct_wf_assign.resolve_preview('PROJECT', v_proj, NULL, 'WF_FBP');
    ck(v_lst.COUNT = 0, 'ended yesterday excluded today');

    BEGIN
        prod.dct_wf_assign.end_assignment('TEST', v_id, TRUNC(SYSDATE), NULL);
        ck(FALSE, 'double end rejected');
    EXCEPTION WHEN OTHERS THEN
        ck(SQLCODE = -20001, 'double end rejected');
    END;

    v_id := prod.dct_wf_assign.create_assignment('TEST', 'PROJECT', v_proj, NULL,
                'WF_PBP', u1, TRUNC(SYSDATE) - 10, NULL, NULL);
    v_new := prod.dct_wf_assign.replace_assignment('TEST', v_id, u2, TRUNC(SYSDATE));
    SELECT COUNT(*) INTO n FROM prod.dct_wf_role_assignment
     WHERE assignment_id = v_id AND end_date = TRUNC(SYSDATE) - 1 AND replaced_by_id = v_new;
    ck(n = 1, 'replace end-dates old at eff-1 and links chain');
    v_lst := prod.dct_wf_assign.resolve_preview('PROJECT', v_proj, NULL, 'WF_PBP');
    ck(v_lst.COUNT = 1 AND has_user(v_lst, u2), 'replacement holds the role today');
    v_lst := prod.dct_wf_assign.resolve_preview('PROJECT', v_proj, NULL, 'WF_PBP',
                 TRUNC(SYSDATE) - 5);
    ck(v_lst.COUNT = 1 AND has_user(v_lst, u1), 'history: old holder resolves for a past date');

    BEGIN
        UPDATE prod.dct_wf_role_assignment SET user_id = u3 WHERE assignment_id = v_new;
        ck(FALSE, 'identity update blocked by trigger');
    EXCEPTION WHEN OTHERS THEN
        ck(SQLCODE = -20001, 'identity update blocked by trigger');
    END;

    v_id := prod.dct_wf_assign.create_assignment('TEST', 'DEPARTMENT', TO_CHAR(v_parent),
                NULL, 'WF_PLANNER', u3, TRUNC(SYSDATE) - 5, NULL, NULL);
    v_lst := prod.dct_wf_assign.resolve_preview('DEPARTMENT', TO_CHAR(v_child), NULL,
                 'WF_PLANNER');
    ck(v_lst.COUNT = 1 AND has_user(v_lst, u3),
       'org walk: child org falls back to parent assignment');
    v_id2 := prod.dct_wf_assign.create_assignment('TEST', 'DEPARTMENT', TO_CHAR(v_child),
                 NULL, 'WF_PLANNER', u1, TRUNC(SYSDATE) - 2, NULL, NULL);
    v_lst := prod.dct_wf_assign.resolve_preview('DEPARTMENT', TO_CHAR(v_child), NULL,
                 'WF_PLANNER');
    ck(v_lst.COUNT = 1 AND has_user(v_lst, u1),
       'org walk: nearest level wins over ancestor');

    v_lst := prod.dct_wf_assign.resolve_preview('SECTOR', v_sect, NULL, 'WF_APPROVER');
    ck(v_lst.COUNT = 0, 'no assignment resolves nobody');

    prod.dct_wf_assign.void_assignment('ADMIN', v_id2, 'test void');
    v_lst := prod.dct_wf_assign.resolve_preview('DEPARTMENT', TO_CHAR(v_child), NULL,
                 'WF_PLANNER');
    ck(v_lst.COUNT = 1 AND has_user(v_lst, u3), 'voided row excluded, ancestor resolves again');
    BEGIN
        prod.dct_wf_assign.void_assignment('TEST', v_id, 'x');
        ck(FALSE, 'void needs SYS_ADMIN');
    EXCEPTION WHEN OTHERS THEN
        ck(SQLCODE = -20403, 'void needs SYS_ADMIN (' || SQLCODE || ')');
    END;

    DBMS_OUTPUT.PUT_LINE('PART1 ' || pass || ' pass / ' || fail || ' fail');
    ROLLBACK;
END;
/

PROMPT === part 2: engine E2E, hierarchy fallback cascade, as-of submission ===

DECLARE
    u1 NUMBER; u2 NUMBER;
    v_proj VARCHAR2(100); v_task VARCHAR2(100); v_cc VARCHAR2(100); v_sect VARCHAR2(100);
    v_sch NUMBER; v_pid NUMBER; v_ver NUMBER; v_step NUMBER; v_id NUMBER;
    v_res CLOB; v_facts CLOB;
    o JSON_OBJECT_T; steps JSON_ARRAY_T; s0 JSON_OBJECT_T; appr JSON_ARRAY_T;
    n1 VARCHAR2(200); n2 VARCHAR2(200);
    pass NUMBER := 0; fail NUMBER := 0;
    PROCEDURE ck (b BOOLEAN, m VARCHAR2) IS
    BEGIN
        IF b THEN pass := pass + 1; DBMS_OUTPUT.PUT_LINE('  pass  ' || m);
        ELSE fail := fail + 1; DBMS_OUTPUT.PUT_LINE('  FAIL  ' || m); END IF;
    END;
    FUNCTION sim_who RETURN VARCHAR2 IS
    BEGIN
        v_res := prod.dct_wf_engine.simulate('OBJ_CASCADE_T', v_facts);
        o     := JSON_OBJECT_T.parse(v_res);
        steps := o.get_array('steps');
        s0    := JSON_OBJECT_T(steps.get(0));
        appr  := s0.get_array('approvers');
        IF appr IS NULL OR appr.get_size = 0 THEN RETURN NULL; END IF;
        RETURN appr.get_string(0);
    END;
    PROCEDURE add_rule (p_seq NUMBER, p_type VARCHAR2, p_fp VARCHAR2, p_fp2 VARCHAR2) IS
    BEGIN
        INSERT INTO prod.dct_wf_participant_rule
            (step_id, rule_seq, resolver_type, role_code, object_type_code,
             fact_path, key2_fact_path, resolution_mode, fallback_rule, exclude_initiator)
        VALUES (v_step, p_seq, 'ASSIGNED_ROLE', 'WF_FBP', p_type,
             p_fp, p_fp2, 'FIRST_MATCH', 'NONE', 'N');
    END;
BEGIN
    SELECT MIN(user_id) INTO u1 FROM prod.dct_users WHERE is_active = 'Y';
    SELECT MIN(user_id) INTO u2 FROM prod.dct_users WHERE is_active = 'Y' AND user_id > u1;
    SELECT display_name INTO n1 FROM prod.dct_users WHERE user_id = u1;
    SELECT display_name INTO n2 FROM prod.dct_users WHERE user_id = u2;
    SELECT MIN(project_number) INTO v_proj FROM prod.v_dct_wf_obj_task;
    SELECT MIN(task_number) INTO v_task FROM prod.v_dct_wf_obj_task WHERE project_number = v_proj;
    SELECT MIN(cost_center_code) INTO v_cc FROM prod.v_dct_wf_obj_cost_center;
    SELECT MIN(value_code) INTO v_sect FROM prod.v_dct_wf_obj_sector;

    INSERT INTO prod.dct_wf_fact_schema(schema_code, name_en, source_view, source_key_column)
        VALUES ('OBJ_CASC_SCH', 'cascade test', 'DUAL', 'X') RETURNING schema_id INTO v_sch;
    INSERT INTO prod.dct_wf_process(process_code, source_module, name_en, schema_id,
        requires_final_callback, is_active)
        VALUES ('OBJ_CASCADE_T', 'DEMO', 'cascade test', v_sch, 'N', 'N')
        RETURNING process_id INTO v_pid;
    INSERT INTO prod.dct_wf_process_version(process_id, version_no, status)
        VALUES (v_pid, 1, 'PUBLISHED') RETURNING version_id INTO v_ver;
    INSERT INTO prod.dct_wf_step(version_id, step_key, step_seq, name_en)
        VALUES (v_ver, 'FBP', 10, 'FBP endorsement') RETURNING step_id INTO v_step;

    -- the dimension cascade, most specific first, FIRST_MATCH
    add_rule(10, 'TASK',        '$.projectNumber', '$.taskNumber');
    add_rule(20, 'PROJECT',     '$.projectNumber', NULL);
    add_rule(30, 'COST_CENTER', '$.costCenter',    NULL);
    add_rule(40, 'SECTOR',      '$.sector',        NULL);

    v_facts := '{"projectNumber":"' || v_proj || '","taskNumber":"' || v_task
            || '","costCenter":"' || v_cc || '","sector":"' || v_sect || '"}';

    ck(sim_who() IS NULL, 'no assignments anywhere: nobody resolves');

    -- sector-level FBP only: the lowest levels find nobody, sector answers
    v_id := prod.dct_wf_assign.create_assignment('TEST', 'SECTOR', v_sect, NULL,
                'WF_FBP', u1, TRUNC(SYSDATE) - 10, NULL, NULL);
    ck(INSTR(sim_who(), n1) > 0, 'cascade falls through to the SECTOR FBP');

    -- now a cost-center FBP appears: more specific level wins
    v_id := prod.dct_wf_assign.create_assignment('TEST', 'COST_CENTER', v_cc, NULL,
                'WF_FBP', u2, TRUNC(SYSDATE) - 5, NULL, NULL);
    ck(INSTR(sim_who(), n2) > 0, 'COST_CENTER FBP beats the sector one (FIRST_MATCH)');

    -- most specific of all: the task itself
    v_id := prod.dct_wf_assign.create_assignment('TEST', 'TASK', v_proj, v_task,
                'WF_FBP', u1, TRUNC(SYSDATE) - 2, NULL, NULL);
    ck(INSTR(sim_who(), n1) > 0, 'TASK-level FBP wins over everything');

    -- wrong task: two-part key must not match
    v_facts := REPLACE(v_facts, '"' || v_task || '"', '"__NO_SUCH_TASK__"');
    ck(INSTR(sim_who(), n2) > 0, 'different task falls back to the COST_CENTER FBP');

    DBMS_OUTPUT.PUT_LINE('PART2 ' || pass || ' pass / ' || fail || ' fail');
    ROLLBACK;
END;
/

EXIT
