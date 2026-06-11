-- Phase 2.5 CC package write-exercise (user pre-approved).
-- All test rows labelled 'PHASE2 TEST'; left in terminal statuses
-- (requests REJECTED/APPROVED, card CLOSED so no replenishment reminders fire).
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET PAGESIZE 100
SET LINESIZE 180

DECLARE
    v_admin_id  NUMBER;
    v_org_id    NUMBER;
    v_req_id    NUMBER;
    v_req_num   VARCHAR2(30);
    v_close1    NUMBER;
    v_close2    NUMBER;
    v_cc_id     NUMBER;
    v_status    VARCHAR2(30);
    v_inst      NUMBER;
    v_n         NUMBER;
    v_iter      NUMBER;

    PROCEDURE say (m VARCHAR2) IS BEGIN DBMS_OUTPUT.PUT_LINE(m); END;

    PROCEDURE attach_docs (p_req_id NUMBER, p_context VARCHAR2) IS
    BEGIN
        FOR r IN (SELECT doc_req_id, doc_type_id FROM prod.dct_doc_requirements
                  WHERE source_module = 'CC' AND context_code = p_context
                  AND is_mandatory = 'Y' AND is_active = 'Y') LOOP
            INSERT INTO prod.dct_documents (
                source_module, source_type, source_id, doc_type_id, doc_req_id,
                file_name, mime_type, notes, created_by)
            VALUES ('CC', 'REQUEST', p_req_id, r.doc_type_id, r.doc_req_id,
                    'phase2-test-doc.pdf', 'application/pdf', 'PHASE2 TEST', v_admin_id);
        END LOOP;
        COMMIT;
    END;

    PROCEDURE approve_until_done (p_req_id NUMBER) IS
    BEGIN
        FOR i IN 1 .. 6 LOOP
            SELECT status, approval_instance_id INTO v_status, v_inst
            FROM prod.dct_cc_requests WHERE request_id = p_req_id;
            EXIT WHEN v_status NOT IN ('SUBMITTED','UNDER_REVIEW');
            prod.dct_cc_pkg.act_on_approval(v_inst, v_admin_id, 'APPROVED', 'PHASE2 TEST step approval');
        END LOOP;
    END;
BEGIN
    SELECT user_id, org_id INTO v_admin_id, v_org_id
    FROM prod.dct_users WHERE username = 'ADMIN' AND ROWNUM = 1;

    -- ============ T1: NEW_CARD lifecycle ============
    v_req_num := prod.dct_cc_pkg.gen_request_number;
    INSERT INTO prod.dct_cc_requests (request_number, request_type, requested_limit, reason, status, created_by, updated_by)
    VALUES (v_req_num, 'NEW_CARD', 5000, 'PHASE2 TEST new card', 'DRAFT', 'ADMIN', 'ADMIN')
    RETURNING request_id INTO v_req_id;
    COMMIT;
    say('T1a created DRAFT NEW_CARD ' || v_req_num);

    BEGIN
        prod.dct_cc_pkg.submit_request(v_req_id, v_admin_id);
        say('T1b FAIL: submit succeeded without mandatory documents');
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE = -20101 THEN say('T1b PASS: doc validation blocked submit (' || SUBSTR(SQLERRM, 12, 80) || ')');
        ELSE say('T1b UNEXPECTED: ' || SQLERRM); END IF;
    END;

    attach_docs(v_req_id, 'NEW_CARD');
    say('T1c attached mandatory NEW_CARD documents (unified dct_documents)');

    prod.dct_cc_pkg.submit_request(v_req_id, v_admin_id);
    SELECT status INTO v_status FROM prod.dct_cc_requests WHERE request_id = v_req_id;
    say('T1d submit OK, status=' || v_status);

    approve_until_done(v_req_id);
    SELECT status INTO v_status FROM prod.dct_cc_requests WHERE request_id = v_req_id;
    say('T1e approval chain complete, status=' || v_status);

    prod.dct_cc_pkg.register_card(
        p_request_id => v_req_id, p_holder_user_id => v_admin_id,
        p_mother_name => 'PHASE2 TEST MOTHER', p_nationality => 'UAE',
        p_credit_limit => 5000, p_expiry_date => ADD_MONTHS(SYSDATE, 36),
        p_email => 'phase2test@example.com', p_org_id => v_org_id,
        p_user_id => v_admin_id, p_cc_id => v_cc_id);
    SELECT status INTO v_status FROM prod.dct_credit_cards WHERE cc_id = v_cc_id;
    say('T1f card registered cc_id=' || v_cc_id || ' status=' || v_status);

    SELECT COUNT(*) INTO v_n FROM prod.dct_cc_card_limit_history WHERE cc_id = v_cc_id AND change_type = 'INITIAL';
    say('T1g INITIAL limit history rows=' || v_n || ' (expect 1)');

    -- ============ T2: CLOSE_CARD rejected -> card untouched ============
    v_req_num := prod.dct_cc_pkg.gen_request_number;
    INSERT INTO prod.dct_cc_requests (request_number, cc_id, request_type, reason, status, created_by, updated_by)
    VALUES (v_req_num, v_cc_id, 'CLOSE_CARD', 'PHASE2 TEST close (to be rejected)', 'DRAFT', 'ADMIN', 'ADMIN')
    RETURNING request_id INTO v_close1;
    COMMIT;
    attach_docs(v_close1, 'CLOSE_CARD');
    prod.dct_cc_pkg.submit_request(v_close1, v_admin_id);
    SELECT approval_instance_id INTO v_inst FROM prod.dct_cc_requests WHERE request_id = v_close1;
    prod.dct_cc_pkg.act_on_approval(v_inst, v_admin_id, 'REJECTED', 'PHASE2 TEST rejection');
    SELECT status INTO v_status FROM prod.dct_cc_requests WHERE request_id = v_close1;
    say('T2a close request rejected, status=' || v_status || ' (expect REJECTED)');
    SELECT status INTO v_status FROM prod.dct_credit_cards WHERE cc_id = v_cc_id;
    say('T2b card after rejection status=' || v_status || ' (expect ACTIVE - no in-progress statuses anymore)');

    -- ============ T3: CLOSE_CARD approved -> card CLOSED ============
    v_req_num := prod.dct_cc_pkg.gen_request_number;
    INSERT INTO prod.dct_cc_requests (request_number, cc_id, request_type, reason, status, created_by, updated_by)
    VALUES (v_req_num, v_cc_id, 'CLOSE_CARD', 'PHASE2 TEST close (approve)', 'DRAFT', 'ADMIN', 'ADMIN')
    RETURNING request_id INTO v_close2;
    COMMIT;
    attach_docs(v_close2, 'CLOSE_CARD');
    prod.dct_cc_pkg.submit_request(v_close2, v_admin_id);
    approve_until_done(v_close2);
    SELECT status INTO v_status FROM prod.dct_credit_cards WHERE cc_id = v_cc_id;
    say('T3a card after approved closure status=' || v_status || ' (expect CLOSED - terminal, no reminder noise)');

    -- ============ T4: lookup validation guard ============
    BEGIN
        prod.dct_lookup_pkg.validate_lookup('CC_REQUEST_TYPE', 'NOT_A_TYPE');
        say('T4 FAIL: bogus lookup value accepted');
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE = -20090 THEN say('T4 PASS: validate_lookup rejected bogus value');
        ELSE say('T4 UNEXPECTED: ' || SQLERRM); END IF;
    END;

    say('=== CC EXERCISE DONE: requests ' || v_req_id || ',' || v_close1 || ',' || v_close2 || ' card ' || v_cc_id);
END;
/

PROMPT === Status-history rows written by the exercise (CC) ===
SELECT source_type, source_id, old_status, new_status,
       TO_CHAR(changed_at,'HH24:MI:SS') t, SUBSTR(comments,1,60) cmt
FROM   prod.dct_request_status_history WHERE source_module = 'CC' ORDER BY hist_id;

PROMPT === Status-history rows from the PC write smoke (PC) ===
SELECT source_type, source_id, old_status, new_status,
       TO_CHAR(changed_at,'HH24:MI:SS') t, SUBSTR(comments,1,60) cmt
FROM   prod.dct_request_status_history WHERE source_module = 'PC' ORDER BY hist_id;

PROMPT === Test artifacts (terminal statuses) ===
SELECT request_number, request_type, status FROM prod.dct_cc_requests WHERE reason LIKE 'PHASE2 TEST%' ORDER BY request_id;
SELECT cc_number, status, credit_limit FROM prod.dct_credit_cards WHERE mother_name = 'PHASE2 TEST MOTHER';
SELECT pc_number, status, purpose FROM prod.dct_petty_cash WHERE purpose LIKE 'PHASE2 SMOKE TEST%';
exit
