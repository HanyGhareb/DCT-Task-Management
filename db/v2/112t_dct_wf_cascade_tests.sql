SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED
-- db/v2/112t_dct_wf_cascade_tests.sql
-- Tests for the configurable level-priority cascade (112 + 63 + 95 re-runs).
-- Self-cleaning: every block ends with ROLLBACK.

PROMPT === part 1: set_priority + matrix_apply (package) ===

DECLARE
    v_lvls VARCHAR2(400);
    v_id   NUMBER;
    v_res  VARCHAR2(20);
    v_cc   VARCHAR2(100);
    u1 NUMBER; u2 NUMBER;
    pass NUMBER := 0; fail NUMBER := 0;
    PROCEDURE ck (b BOOLEAN, m VARCHAR2) IS
    BEGIN
        IF b THEN pass := pass + 1; DBMS_OUTPUT.PUT_LINE('  pass  ' || m);
        ELSE fail := fail + 1; DBMS_OUTPUT.PUT_LINE('  FAIL  ' || m); END IF;
    END;
    FUNCTION cur_levels (p_role VARCHAR2) RETURN VARCHAR2 IS
        v VARCHAR2(400);
    BEGIN
        SELECT LISTAGG(object_type_code, ',') WITHIN GROUP (ORDER BY seq)
          INTO v FROM prod.dct_wf_cascade_level
         WHERE NVL(role_code, '#') = NVL(p_role, '#') AND is_active = 'Y';
        RETURN v;
    END;
BEGIN
    SELECT MIN(user_id) INTO u1 FROM prod.dct_users WHERE is_active = 'Y';
    SELECT MIN(user_id) INTO u2 FROM prod.dct_users WHERE is_active = 'Y' AND user_id > u1;
    SELECT MIN(cost_center_code) INTO v_cc FROM prod.v_dct_wf_obj_cost_center;

    -- seeded default
    ck(cur_levels(NULL) = 'TASK,PROJECT,COST_CENTER,SECTOR',
       'seeded default order Task>Project>CC>Sector');

    -- per-role override create + read back + remove
    prod.dct_wf_assign.set_priority('TEST', 'WF_DIRECTOR', 'COST_CENTER,SECTOR');
    ck(cur_levels('WF_DIRECTOR') = 'COST_CENTER,SECTOR', 'role override saved');
    prod.dct_wf_assign.set_priority('TEST', 'WF_DIRECTOR', NULL);
    ck(cur_levels('WF_DIRECTOR') IS NULL, 'empty list removes the override');

    -- validations
    BEGIN
        prod.dct_wf_assign.set_priority('TEST', NULL, NULL);
        ck(FALSE, 'default cannot be emptied');
    EXCEPTION WHEN OTHERS THEN
        ck(SQLCODE = -20001, 'default cannot be emptied (' || SQLCODE || ')');
    END;
    BEGIN
        prod.dct_wf_assign.set_priority('TEST', NULL, 'TASK,NO_SUCH_TYPE');
        ck(FALSE, 'unknown level rejected');
    EXCEPTION WHEN OTHERS THEN
        ck(SQLCODE = -20001, 'unknown level rejected (' || SQLCODE || ')');
    END;
    BEGIN
        prod.dct_wf_assign.set_priority('TEST', NULL, 'TASK,TASK');
        ck(FALSE, 'duplicate level rejected');
    EXCEPTION WHEN OTHERS THEN
        ck(SQLCODE = -20001, 'duplicate level rejected (' || SQLCODE || ')');
    END;
    BEGIN
        prod.dct_wf_assign.set_priority('TEST', 'NO_SUCH_ROLE', 'TASK');
        ck(FALSE, 'unknown role rejected');
    EXCEPTION WHEN OTHERS THEN
        ck(SQLCODE = -20404, 'unknown role rejected (' || SQLCODE || ')');
    END;
    -- validation happens BEFORE any change
    ck(cur_levels(NULL) = 'TASK,PROJECT,COST_CENTER,SECTOR', 'default untouched by failed saves');

    -- matrix_apply lifecycle: create -> skip -> replace
    v_res := prod.dct_wf_assign.matrix_apply('TEST', v_cc, 'WF_FBP_UH', u1, TRUNC(SYSDATE));
    ck(v_res = 'CREATED', 'matrix_apply creates (' || v_res || ')');
    v_res := prod.dct_wf_assign.matrix_apply('TEST', v_cc, 'WF_FBP_UH', u1, TRUNC(SYSDATE));
    ck(v_res = 'SKIPPED', 'same person again skips (' || v_res || ')');
    v_res := prod.dct_wf_assign.matrix_apply('TEST', v_cc, 'WF_FBP_UH', u2, TRUNC(SYSDATE));
    ck(v_res = 'REPLACED', 'different person replaces (' || v_res || ')');
    SELECT COUNT(*) INTO v_id FROM prod.dct_wf_role_assignment
     WHERE object_type_code = 'COST_CENTER'
       AND object_key = prod.dct_wf_assign.canon('COST_CENTER', v_cc)
       AND role_code = 'WF_FBP_UH' AND user_id = u2 AND is_active = 'Y'
       AND (end_date IS NULL OR end_date >= TRUNC(SYSDATE));
    ck(v_id = 1, 'replacement is the active holder');

    DBMS_OUTPUT.PUT_LINE('PART1 ' || pass || ' pass / ' || fail || ' fail');
    ROLLBACK;
END;
/

PROMPT === part 2: engine E2E, ONE cascade rule, config-driven priority ===

DECLARE
    u1 NUMBER; u2 NUMBER;
    v_proj VARCHAR2(100); v_task VARCHAR2(100); v_cc VARCHAR2(100); v_sect VARCHAR2(100);
    v_sch NUMBER; v_pid NUMBER; v_ver NUMBER; v_step NUMBER; v_id NUMBER;
    v_res CLOB; v_facts CLOB;
    o JSON_OBJECT_T; steps JSON_ARRAY_T; s0 JSON_OBJECT_T; appr JSON_ARRAY_T;
    n1 VARCHAR2(200); n2 VARCHAR2(200);
    v_note VARCHAR2(500);
    pass NUMBER := 0; fail NUMBER := 0;
    PROCEDURE ck (b BOOLEAN, m VARCHAR2) IS
    BEGIN
        IF b THEN pass := pass + 1; DBMS_OUTPUT.PUT_LINE('  pass  ' || m);
        ELSE fail := fail + 1; DBMS_OUTPUT.PUT_LINE('  FAIL  ' || m); END IF;
    END;
    FUNCTION sim_who RETURN VARCHAR2 IS
    BEGIN
        v_res := prod.dct_wf_engine.simulate('CASC_PRIO_T', v_facts);
        o     := JSON_OBJECT_T.parse(v_res);
        steps := o.get_array('steps');
        s0    := JSON_OBJECT_T(steps.get(0));
        v_note := s0.get_string('resolution');
        appr  := s0.get_array('approvers');
        IF appr IS NULL OR appr.get_size = 0 THEN RETURN NULL; END IF;
        RETURN appr.get_string(0);
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
        VALUES ('CASC_PRIO_SCH', 'cascade prio test', 'DUAL', 'X') RETURNING schema_id INTO v_sch;
    INSERT INTO prod.dct_wf_process(process_code, source_module, name_en, schema_id,
        requires_final_callback, is_active)
        VALUES ('CASC_PRIO_T', 'DEMO', 'cascade prio test', v_sch, 'N', 'N')
        RETURNING process_id INTO v_pid;
    INSERT INTO prod.dct_wf_process_version(process_id, version_no, status)
        VALUES (v_pid, 1, 'PUBLISHED') RETURNING version_id INTO v_ver;
    INSERT INTO prod.dct_wf_step(version_id, step_key, step_seq, name_en)
        VALUES (v_ver, 'FBP', 10, 'FBP endorsement') RETURNING step_id INTO v_step;

    -- the WHOLE cascade is ONE rule now -- levels come from the config
    INSERT INTO prod.dct_wf_participant_rule
        (step_id, rule_seq, resolver_type, role_code,
         resolution_mode, fallback_rule, exclude_initiator)
    VALUES (v_step, 10, 'ASSIGNED_ROLE_CASCADE', 'WF_FBP',
         'FIRST_MATCH', 'NONE', 'N');

    v_facts := '{"projectNumber":"' || v_proj || '","taskNumber":"' || v_task
            || '","costCenter":"' || v_cc || '","sector":"' || v_sect || '"}';

    ck(sim_who() IS NULL, 'no assignments anywhere: nobody resolves');

    v_id := prod.dct_wf_assign.create_assignment('TEST', 'SECTOR', v_sect, NULL,
                'WF_FBP', u1, TRUNC(SYSDATE) - 10, NULL, NULL);
    ck(INSTR(sim_who(), n1) > 0, 'one rule cascades down to the SECTOR FBP');
    ck(v_note LIKE 'cascade: WF_FBP resolved at SECTOR%'
       AND INSTR(v_note, 'TASK') > 0 AND INSTR(v_note, 'COST_CENTER') > 0,
       'resolution note names the level + the empty ones tried: ' || v_note);

    v_id := prod.dct_wf_assign.create_assignment('TEST', 'COST_CENTER', v_cc, NULL,
                'WF_FBP', u2, TRUNC(SYSDATE) - 5, NULL, NULL);
    ck(INSTR(sim_who(), n2) > 0, 'COST_CENTER beats SECTOR under the default order');
    ck(v_note LIKE 'cascade: WF_FBP resolved at COST_CENTER%', 'note: ' || v_note);

    v_id := prod.dct_wf_assign.create_assignment('TEST', 'TASK', v_proj, v_task,
                'WF_FBP', u1, TRUNC(SYSDATE) - 2, NULL, NULL);
    ck(INSTR(sim_who(), n1) > 0, 'TASK level wins over everything');

    -- CONFIGURABLE priority: flip WF_FBP to check SECTOR FIRST
    prod.dct_wf_assign.set_priority('TEST', 'WF_FBP', 'SECTOR,COST_CENTER,PROJECT,TASK');
    ck(INSTR(sim_who(), n1) > 0 AND v_note LIKE 'cascade: WF_FBP resolved at SECTOR%',
       'per-role priority flip: SECTOR now wins (' || v_note || ')');

    -- remove the override: default (most-specific-first) is back
    prod.dct_wf_assign.set_priority('TEST', 'WF_FBP', NULL);
    ck(INSTR(sim_who(), n1) > 0 AND v_note LIKE 'cascade: WF_FBP resolved at TASK%',
       'override removed: TASK wins again (' || v_note || ')');

    -- FBP is a GROUP role now (user rule): a second sector FBP joins the
    -- same level -- both principals resolve when sector is the winning level
    prod.dct_wf_assign.set_priority('TEST', 'WF_FBP', 'SECTOR');
    v_id := prod.dct_wf_assign.create_assignment('TEST', 'SECTOR', v_sect, NULL,
                'WF_FBP', u2, TRUNC(SYSDATE) - 1, NULL, NULL);
    v_res := prod.dct_wf_engine.simulate('CASC_PRIO_T', v_facts);
    o := JSON_OBJECT_T.parse(v_res);
    s0 := JSON_OBJECT_T(o.get_array('steps').get(0));
    ck(s0.get_array('approvers').get_size = 2,
       'group role: BOTH sector FBPs resolve at the winning level');

    -- a fact with NO keys at all: every level skips with [no key]
    prod.dct_wf_assign.set_priority('TEST', 'WF_FBP', NULL);
    v_facts := '{"amount": 5}';
    ck(sim_who() IS NULL AND v_note IS NULL, 'no keys in facts: nobody, no false hit');

    DBMS_OUTPUT.PUT_LINE('PART2 ' || pass || ' pass / ' || fail || ' fail');
    ROLLBACK;
END;
/

EXIT
