SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

-- =============================================================================
-- 68t_dct_wf_designer_test.sql -- DCT_WF_DESIGNER end-to-end unit test
-- Self-cleaning: the whole test runs in ONE transaction (the designer package
-- never commits) and ROLLBACKs at the end, so it leaves no trace in PROD.
-- Run: sql -name prod_mcp @68t_dct_wf_designer_test.sql
-- =============================================================================
PROMPT === DCT_WF_DESIGNER -- E2E test (rolls back) ===

DECLARE
    v_pass NUMBER := 0; v_fail NUMBER := 0;
    v_set  NUMBER; v_pid NUMBER; v_v1 NUMBER; v_v2 NUMBER; v_v2b NUMBER;
    v_s1 NUMBER; v_s2 NUMBER; v_s3 NUMBER; v_r NUMBER;
    v_n NUMBER; v_st VARCHAR2(12); v_no NUMBER; v_valid VARCHAR2(1); v_err VARCHAR2(1000);
    v_probs VARCHAR2(4000); v_active VARCHAR2(1);

    PROCEDURE ck (p_desc VARCHAR2, p_ok BOOLEAN) IS
    BEGIN
        IF p_ok THEN v_pass := v_pass + 1; DBMS_OUTPUT.PUT_LINE('  pass  ' || p_desc);
        ELSE       v_fail := v_fail + 1; DBMS_OUTPUT.PUT_LINE('  FAIL  ' || p_desc); END IF;
    END;
BEGIN
    SELECT set_id INTO v_set FROM prod.dct_wf_outcome_set WHERE set_code = 'APPROVE_REJECT';

    -- ---- setup: a process with a PUBLISHED v1 (2 HUMAN steps + participants) ----
    INSERT INTO prod.dct_wf_process (process_code, source_module, name_en, name_ar,
                                     requires_final_callback, is_active)
    VALUES ('TEST_DZR', 'TEST', 'Designer Test', 'AR name', 'N', 'N')
    RETURNING process_id INTO v_pid;

    INSERT INTO prod.dct_wf_process_version (process_id, version_no, status)
    VALUES (v_pid, 1, 'PUBLISHED') RETURNING version_id INTO v_v1;

    INSERT INTO prod.dct_wf_step (version_id, step_key, step_seq, name_en, name_ar,
                                  outcome_set_id, is_final_gate)
    VALUES (v_v1, 'S1', 10, 'Step 1', 'AR1', v_set, 'N') RETURNING step_id INTO v_s1;
    INSERT INTO prod.dct_wf_participant_rule (step_id, resolver_type, role_code)
    VALUES (v_s1, 'ROLE', 'SYS_ADMIN');

    INSERT INTO prod.dct_wf_step (version_id, step_key, step_seq, name_en, name_ar,
                                  outcome_set_id, is_final_gate)
    VALUES (v_v1, 'S2', 20, 'Step 2', 'AR2', v_set, 'Y') RETURNING step_id INTO v_s2;
    INSERT INTO prod.dct_wf_participant_rule (step_id, resolver_type, role_code)
    VALUES (v_s2, 'ROLE', 'SYS_ADMIN');

    -- ============ 1. clone to draft ============
    v_v2 := prod.dct_wf_designer.clone_to_draft('TEST_DZR', 'tester');
    SELECT status, version_no INTO v_st, v_no FROM prod.dct_wf_process_version WHERE version_id = v_v2;
    ck('clone creates a DRAFT', v_st = 'DRAFT');
    ck('clone bumps version_no to 2', v_no = 2);
    SELECT COUNT(*) INTO v_n FROM prod.dct_wf_step WHERE version_id = v_v2;
    ck('clone deep-copied the 2 steps', v_n = 2);
    SELECT COUNT(*) INTO v_n FROM prod.dct_wf_participant_rule pr
      JOIN prod.dct_wf_step st ON st.step_id = pr.step_id WHERE st.version_id = v_v2;
    ck('clone deep-copied the 2 participant rules', v_n = 2);

    -- ============ 2. one draft at a time (idempotent clone) ============
    v_v2b := prod.dct_wf_designer.clone_to_draft('TEST_DZR', 'tester');
    ck('a 2nd clone returns the SAME open draft', v_v2b = v_v2);

    -- ============ 3. edit the draft ============
    prod.dct_wf_designer.save_step(v_v2,
        '{"stepKey":"S3","nameEn":"Legal review","nameAr":"AR3","outcomeSetCode":"APPROVE_REJECT"}',
        'tester', v_s3);
    SELECT COUNT(*) INTO v_n FROM prod.dct_wf_step WHERE version_id = v_v2;
    ck('save_step added a 3rd step', v_n = 3);

    prod.dct_wf_designer.save_condition(v_v2, 'C_BAD', 'amount >>> 6', 'Bad', 'AR', 'tester', v_valid, v_err);
    ck('an invalid condition is stored is_valid=N', v_valid = 'N');
    SELECT is_valid INTO v_valid FROM prod.dct_wf_condition WHERE version_id = v_v2 AND condition_key = 'C_BAD';
    ck('the invalid condition persisted (draft keeps in-progress text)', v_valid = 'N');

    -- ============ 4. publish is BLOCKED while the draft is not clean ============
    v_probs := prod.dct_wf_designer.validate_version(v_v2);
    ck('validate flags the participant-less step', INSTR(v_probs, 'S3') > 0);
    ck('validate flags the invalid condition', INSTR(v_probs, 'C_BAD') > 0);
    BEGIN
        prod.dct_wf_designer.publish(v_v2, 'tester');
        ck('publish refuses an unclean draft', FALSE);
    EXCEPTION WHEN OTHERS THEN
        ck('publish refuses an unclean draft (-20001)', SQLCODE = -20001);
    END;

    -- ============ 5. clean the draft, then publish ============
    prod.dct_wf_designer.delete_step(v_v2, 'S3');
    prod.dct_wf_designer.delete_condition(v_v2, 'C_BAD');
    v_probs := prod.dct_wf_designer.validate_version(v_v2);
    ck('validate is clean after fixing', v_probs IS NULL);

    prod.dct_wf_designer.publish(v_v2, 'tester');
    SELECT status INTO v_st FROM prod.dct_wf_process_version WHERE version_id = v_v2;
    ck('the draft is now PUBLISHED', v_st = 'PUBLISHED');
    SELECT status INTO v_st FROM prod.dct_wf_process_version WHERE version_id = v_v1;
    ck('the prior version is RETIRED', v_st = 'RETIRED');
    SELECT is_active INTO v_active FROM prod.dct_wf_process WHERE process_id = v_pid;
    ck('the process is now active', v_active = 'Y');

    -- ============ 6. a PUBLISHED version is immutable ============
    BEGIN
        prod.dct_wf_designer.save_step(v_v2, '{"stepKey":"S9","nameEn":"x","nameAr":"y"}', 'tester', v_s3);
        ck('editing a PUBLISHED version is refused', FALSE);
    EXCEPTION WHEN OTHERS THEN
        ck('editing a PUBLISHED version is refused (-20001)', SQLCODE = -20001);
    END;

    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('  ===============================');
    DBMS_OUTPUT.PUT_LINE('  passed : ' || v_pass);
    DBMS_OUTPUT.PUT_LINE('  failed : ' || v_fail);
    DBMS_OUTPUT.PUT_LINE('  ===============================');

    ROLLBACK;   -- erase every trace of the test
    DBMS_OUTPUT.PUT_LINE('  (rolled back -- no trace left in PROD)');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('  TEST ERROR: ' || SQLERRM);
    DBMS_OUTPUT.PUT_LINE(SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500));
    ROLLBACK;
END;
/
EXIT
