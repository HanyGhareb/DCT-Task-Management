SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED
-- db/v2/114t_dct_wf_test_mode.sql
-- E2E proof of DWP testing mode (114 + 63 re-run): with a process's
-- test_mode = Y (or the platform WF_TEST_MODE = Y), the TASK still goes to
-- the real resolved approver, but the NOTIFICATION lands on the WF_TEST_EMAIL
-- account, tagged [TEST] and naming the original recipient.
-- Self-cleaning: ROLLBACK (start_process has no autonomous transactions --
-- by design -- so everything, including notifications, rolls back).

DECLARE
    u_test NUMBER; u_appr NUMBER;
    v_mail VARCHAR2(200);
    v_set  NUMBER; v_sch NUMBER; v_pid NUMBER; v_vid NUMBER; v_step NUMBER;
    v_iid  NUMBER; v_n NUMBER; v_title VARCHAR2(400); v_recip NUMBER;
    v_warn VARCHAR2(400);
    pass NUMBER := 0; fail NUMBER := 0;
    PROCEDURE ck (b BOOLEAN, m VARCHAR2) IS
    BEGIN
        IF b THEN pass := pass + 1; DBMS_OUTPUT.PUT_LINE('  pass  ' || m);
        ELSE fail := fail + 1; DBMS_OUTPUT.PUT_LINE('  FAIL  ' || m); END IF;
    END;
BEGIN
    SELECT MIN(user_id) INTO u_test FROM prod.dct_users
     WHERE is_active = 'Y' AND email LIKE '%@%';
    SELECT LOWER(email) INTO v_mail FROM prod.dct_users WHERE user_id = u_test;
    SELECT MIN(user_id) INTO u_appr FROM prod.dct_users
     WHERE is_active = 'Y' AND user_id <> u_test;

    -- point the redirect at u_test for the duration of this transaction
    UPDATE prod.dct_system_settings SET setting_value = v_mail
     WHERE setting_key = 'WF_TEST_EMAIL';

    SELECT MIN(set_id) INTO v_set FROM prod.dct_wf_outcome_set
     WHERE set_code = 'APPROVE_REJECT';

    INSERT INTO prod.dct_wf_process(process_code, source_module, name_en,
        requires_final_callback, is_active, test_mode)
        VALUES ('TESTMODE_T', 'DEMO', 'test-mode proof', 'N', 'Y', 'Y')
        RETURNING process_id INTO v_pid;
    INSERT INTO prod.dct_wf_process_version(process_id, version_no, status)
        VALUES (v_pid, 1, 'PUBLISHED') RETURNING version_id INTO v_vid;
    INSERT INTO prod.dct_wf_step
        (version_id, step_key, step_seq, name_en, step_kind, quorum_type,
         outcome_set_id, comment_required)
    VALUES (v_vid, 'ONLY', 10, 'Only step', 'HUMAN', 'ANY', v_set, 'ON_NEGATIVE')
        RETURNING step_id INTO v_step;
    INSERT INTO prod.dct_wf_participant_rule
        (step_id, rule_seq, resolver_type, static_user_id,
         resolution_mode, fallback_rule, exclude_initiator)
    VALUES (v_step, 10, 'STATIC_USER', u_appr, 'UNION', 'NONE', 'N');

    v_iid := prod.dct_wf_engine.start_process('TESTMODE_T', 1, NULL, 'TM-0001',
                 TO_CLOB('{"amount": 100}'));

    -- routing untouched: the TASK belongs to the real approver
    SELECT COUNT(*) INTO v_n FROM prod.dct_wf_task
     WHERE instance_id = v_iid AND assignee_user_id = u_appr;
    ck(v_n = 1, 'task still assigned to the REAL approver (routing untouched)');

    -- notification redirected: it landed on the test account, tagged.
    -- (filter on the record ref, NEVER created_at > SYSTIMESTAMP: comparing
    -- the naive TIMESTAMP column to a TZ-aware expression shifts by session
    -- timezone and silently excludes fresh rows)
    SELECT MAX(recipient_user_id), MAX(title_en) INTO v_recip, v_title
      FROM prod.dct_notifications
     WHERE notification_type = 'TASK_ASSIGNED'
       AND title_en LIKE '%TM-0001%';
    ck(v_recip = u_test, 'notification redirected to the WF_TEST_EMAIL account');
    ck(v_title LIKE '[TEST]%' AND INSTR(v_title, 'for:') > 0,
       'subject tagged [TEST] + names the original recipient: ' || SUBSTR(v_title, 1, 80));

    -- the notify log records the redirect
    SELECT COUNT(*) INTO v_n FROM prod.dct_wf_notify_log
     WHERE instance_id = v_iid AND user_id = u_test
       AND warn_msg LIKE 'test-mode: redirected from user%';
    ck(v_n >= 1, 'notify log records the redirect + original user');

    -- no notification reached the real approver
    SELECT COUNT(*) INTO v_n FROM prod.dct_notifications
     WHERE title_en LIKE '%TM-0001%' AND recipient_user_id = u_appr;
    ck(v_n = 0, 'the real approver got NO notification');

    -- flip to PLATFORM-level: process flag off, WF_TEST_MODE=Y -- same result
    UPDATE prod.dct_wf_process SET test_mode = 'N' WHERE process_id = v_pid;
    UPDATE prod.dct_system_settings SET setting_value = 'Y'
     WHERE setting_key = 'WF_TEST_MODE';
    v_iid := prod.dct_wf_engine.start_process('TESTMODE_T', 2, NULL, 'TM-0002',
                 TO_CLOB('{"amount": 100}'));
    SELECT COUNT(*) INTO v_n FROM prod.dct_wf_notify_log
     WHERE instance_id = v_iid AND user_id = u_test
       AND warn_msg LIKE 'test-mode: redirected%';
    ck(v_n >= 1, 'platform-level WF_TEST_MODE=Y redirects too');

    -- both switches OFF: notification goes to the real approver again
    UPDATE prod.dct_system_settings SET setting_value = 'N'
     WHERE setting_key = 'WF_TEST_MODE';
    v_iid := prod.dct_wf_engine.start_process('TESTMODE_T', 3, NULL, 'TM-0003',
                 TO_CLOB('{"amount": 100}'));
    SELECT COUNT(*) INTO v_n FROM prod.dct_notifications
     WHERE title_en LIKE '%TM-0003%' AND recipient_user_id = u_appr;
    ck(v_n = 1, 'switches off: the real approver is notified normally');

    DBMS_OUTPUT.PUT_LINE('TESTMODE ' || pass || ' pass / ' || fail || ' fail');
    ROLLBACK;
END;
/

EXIT
