-- =============================================================================
-- Credit Cards Module (App 202) — Business Logic Package
-- File    : 04_cc_pkg.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @04_cc_pkg.sql  (after 03_cc_seed.sql)
-- =============================================================================
-- Procedures (called from ORDS handlers, APEX processes and scheduled jobs):
--
--   SUBMIT_REQUEST            — DRAFT card request → validates type-specific
--                               rules + mandatory docs (unified
--                               dct_doc_requirements / dct_documents), creates
--                               approval instance. Card status is NOT touched:
--                               the open request itself marks the card busy
--                               (pending_operation in DCT_CC_CARD_V).
--   WITHDRAW_REQUEST          — requester pulls back a SUBMITTED/UNDER_REVIEW
--                               request; cancels the approval instance
--   ACT_ON_APPROVAL           — approve / reject / return one approval step;
--                               evaluates ALWAYS / AMOUNT / CUSTOM step
--                               conditions (CUSTOM = 'SETTING_KEY=VALUE' against
--                               CREDIT_CARDS module settings); on completion
--                               applies the business outcome below
--   APPLY_APPROVED_REQUEST    — INCREASE/DECREASE: apply limit + history row;
--                               CLOSE_CARD: card → CLOSED;
--                               REPLACEMENT / NEW_CARD: notify CC_ADMIN
--   REVERT_REQUEST_EFFECTS    — retained for compatibility; card status is no
--                               longer altered by requests, so this is a no-op
--   REGISTER_CARD             — CC Admin records the physical card issued by the
--                               bank against an APPROVED NEW_CARD request;
--                               generates CC-YYYY-NNNNN + INITIAL limit history
--   SUBMIT_REPLENISHMENT      — DRAFT monthly statement → validates lines,
--                               proxy rights, period; creates approval instance
--   RECALC_REPLENISHMENT_TOTAL— re-sums lines into the header total
--   CHECK_REPLENISHMENT_DUE   — daily job: reminds holders/proxies when last
--                               month's replenishment is missing past
--                               REPLENISHMENT_DUE_DAY + GRACE_DAYS
--
-- Approval source_module values used: CC_REQUEST | CC_REPLENISHMENT
--
-- Phase 2.2 (assessment-3/phase2): documents and expense lines live in the
-- unified DCT_DOCUMENTS / DCT_DOC_REQUIREMENTS / DCT_BUDGET_CODING_LINES
-- tables; every status transition is appended to DCT_REQUEST_STATUS_HISTORY;
-- card statuses are ACTIVE | INACTIVE | CLOSED (CC_CARD_STATUS lookup);
-- statuses are validated via DCT_LOOKUP_PKG, not CHECK constraints.
-- =============================================================================
SET DEFINE OFF

ALTER SESSION SET CURRENT_SCHEMA = PROD;

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- SEQUENCES (safe re-run)
-- =============================================================================
DECLARE
  PROCEDURE mk(p_name VARCHAR2) IS
    e_exists EXCEPTION; PRAGMA EXCEPTION_INIT(e_exists, -955);
  BEGIN
    EXECUTE IMMEDIATE 'CREATE SEQUENCE prod.' || p_name || ' START WITH 1 INCREMENT BY 1 NOCACHE';
    DBMS_OUTPUT.PUT_LINE('Sequence created: ' || p_name);
  EXCEPTION WHEN e_exists THEN NULL;
  END;
BEGIN
  mk('seq_cc_request_num');
  mk('seq_cc_card_num');
  mk('seq_cc_reimb_num');
END;
/

-- =============================================================================
-- PACKAGE SPEC
-- =============================================================================
CREATE OR REPLACE PACKAGE prod.dct_cc_pkg AS

    -- Setting resolver (CREDIT_CARDS module)
    FUNCTION get_setting (p_key IN VARCHAR2) RETURN VARCHAR2;

    -- Number generators
    FUNCTION gen_request_number RETURN VARCHAR2;                       -- CCR-YYYY-NNNNN
    FUNCTION gen_card_number    RETURN VARCHAR2;                       -- CC-YYYY-NNNNN
    FUNCTION gen_reimb_number  (p_year IN NUMBER, p_month IN NUMBER)
                                RETURN VARCHAR2;                       -- CCM-YYYY-MM-NNNNN

    -- Card lifecycle requests
    PROCEDURE submit_request   (p_request_id IN NUMBER, p_user_id IN NUMBER);
    PROCEDURE withdraw_request (p_request_id IN NUMBER, p_user_id IN NUMBER);

    -- Generic approval action for CC instances (handles CUSTOM conditions)
    PROCEDURE act_on_approval (
        p_instance_id IN NUMBER,
        p_user_id     IN NUMBER,
        p_action      IN VARCHAR2,         -- APPROVED | REJECTED | RETURNED
        p_comments    IN VARCHAR2
    );

    -- Final-approval business effects (also callable from APEX processes)
    PROCEDURE apply_approved_request (p_request_id IN NUMBER, p_user_id IN NUMBER);
    PROCEDURE revert_request_effects (p_request_id IN NUMBER);

    -- Physical card registration after an approved NEW_CARD request
    PROCEDURE register_card (
        p_request_id     IN NUMBER,
        p_holder_user_id IN NUMBER,
        p_mother_name    IN VARCHAR2,
        p_nationality    IN VARCHAR2,
        p_credit_limit   IN NUMBER,
        p_expiry_date    IN DATE,
        p_email          IN VARCHAR2,
        p_org_id         IN NUMBER,
        p_cost_center    IN VARCHAR2 DEFAULT NULL,
        p_user_id        IN NUMBER,
        p_cc_id          OUT NUMBER
    );

    -- Monthly replenishments
    PROCEDURE submit_replenishment       (p_replenishment_id IN NUMBER, p_user_id IN NUMBER);
    PROCEDURE recalc_replenishment_total (p_replenishment_id IN NUMBER);

    -- Daily scheduled job
    PROCEDURE check_replenishment_due;

END dct_cc_pkg;
/

-- =============================================================================
-- PACKAGE BODY
-- =============================================================================
CREATE OR REPLACE PACKAGE BODY prod.dct_cc_pkg AS

    -- -------------------------------------------------------------------------
    -- Private helpers
    -- -------------------------------------------------------------------------
    FUNCTION username_of (p_user_id IN NUMBER) RETURN VARCHAR2 IS
        v_name prod.dct_users.username%TYPE;
    BEGIN
        SELECT username INTO v_name FROM prod.dct_users WHERE user_id = p_user_id;
        RETURN v_name;
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN TO_CHAR(p_user_id);
    END username_of;

    -- Notify every active holder of a role (non-critical — never raises)
    PROCEDURE notify_role (
        p_role_code IN VARCHAR2,
        p_type      IN VARCHAR2,
        p_title     IN VARCHAR2,
        p_body      IN VARCHAR2
    ) IS
    BEGIN
        FOR usr IN (
            SELECT ur.user_id
            FROM   prod.dct_user_roles ur
            JOIN   prod.dct_roles      r ON r.role_id = ur.role_id
            WHERE  r.role_code  = p_role_code
            AND    ur.is_active = 'Y'
            AND   (ur.end_date IS NULL OR ur.end_date >= SYSDATE)
        ) LOOP
            prod.dct_notify.send(
                p_recipient_user_id => usr.user_id,
                p_notification_type => p_type,
                p_title_en          => p_title,
                p_body_en           => p_body);
        END LOOP;
    EXCEPTION WHEN OTHERS THEN NULL;
    END notify_role;

    PROCEDURE notify_user (
        p_user_id IN NUMBER,
        p_type    IN VARCHAR2,
        p_title   IN VARCHAR2,
        p_body    IN VARCHAR2
    ) IS
    BEGIN
        prod.dct_notify.send(
            p_recipient_user_id => p_user_id,
            p_notification_type => p_type,
            p_title_en          => p_title,
            p_body_en           => p_body);
    EXCEPTION WHEN OTHERS THEN NULL;
    END notify_user;

    -- Append one row to the unified status-transition log (audit requirement —
    -- failures propagate so the business transaction never outruns its audit)
    PROCEDURE log_status (
        p_source_type IN VARCHAR2,            -- REQUEST | REPLENISHMENT | CARD
        p_source_id   IN NUMBER,
        p_old         IN VARCHAR2,
        p_new         IN VARCHAR2,
        p_user_id     IN NUMBER,
        p_comments    IN VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        INSERT INTO prod.dct_request_status_history (
            source_module, source_type, source_id,
            old_status, new_status, changed_by, comments)
        VALUES ('CC', p_source_type, p_source_id,
                p_old, p_new, p_user_id, p_comments);
    END log_status;

    -- 'SETTING_KEY=VALUE' custom step condition against CREDIT_CARDS settings
    FUNCTION eval_custom_condition (p_custom IN VARCHAR2) RETURN BOOLEAN IS
        v_key VARCHAR2(100);
        v_val VARCHAR2(500);
    BEGIN
        IF p_custom IS NULL OR INSTR(p_custom, '=') = 0 THEN
            RETURN TRUE;   -- unparseable condition: fail open (step fires)
        END IF;
        v_key := TRIM(SUBSTR(p_custom, 1, INSTR(p_custom, '=') - 1));
        v_val := TRIM(SUBSTR(p_custom, INSTR(p_custom, '=') + 1));
        RETURN NVL(get_setting(v_key), '~') = v_val;
    END eval_custom_condition;

    -- -------------------------------------------------------------------------
    -- GET_SETTING
    -- -------------------------------------------------------------------------
    FUNCTION get_setting (p_key IN VARCHAR2) RETURN VARCHAR2 IS
        v_val VARCHAR2(500);
    BEGIN
        SELECT ms.setting_value
        INTO   v_val
        FROM   prod.dct_module_settings ms
        JOIN   prod.dct_modules          m ON m.module_id = ms.module_id
        WHERE  m.module_code  = 'CREDIT_CARDS'
        AND    ms.setting_key = p_key;
        RETURN v_val;
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
    END get_setting;

    -- -------------------------------------------------------------------------
    -- NUMBER GENERATORS
    -- -------------------------------------------------------------------------
    FUNCTION gen_request_number RETURN VARCHAR2 IS
    BEGIN
        RETURN 'CCR-' || TO_CHAR(SYSDATE, 'YYYY') || '-'
                      || TO_CHAR(prod.seq_cc_request_num.NEXTVAL, 'FM00000');
    END gen_request_number;

    FUNCTION gen_card_number RETURN VARCHAR2 IS
    BEGIN
        RETURN 'CC-' || TO_CHAR(SYSDATE, 'YYYY') || '-'
                     || TO_CHAR(prod.seq_cc_card_num.NEXTVAL, 'FM00000');
    END gen_card_number;

    FUNCTION gen_reimb_number (p_year IN NUMBER, p_month IN NUMBER) RETURN VARCHAR2 IS
    BEGIN
        RETURN 'CCM-' || TO_CHAR(p_year, 'FM0000') || '-'
                      || TO_CHAR(p_month, 'FM00') || '-'
                      || TO_CHAR(prod.seq_cc_reimb_num.NEXTVAL, 'FM00000');
    END gen_reimb_number;

    -- -------------------------------------------------------------------------
    -- Private: mandatory-document validation for a request
    -- -------------------------------------------------------------------------
    PROCEDURE validate_docs (p_request_id IN NUMBER, p_request_type IN VARCHAR2) IS
        v_missing VARCHAR2(2000);
    BEGIN
        FOR rec IN (
            SELECT dt.doc_type_name_en AS document_name
            FROM   prod.dct_doc_requirements dr
            JOIN   prod.dct_document_types   dt ON dt.doc_type_id = dr.doc_type_id
            WHERE  dr.source_module = 'CC'
            AND    dr.context_code  = p_request_type
            AND    dr.is_mandatory  = 'Y'
            AND    dr.is_active     = 'Y'
            AND    NOT EXISTS (
                       SELECT 1 FROM prod.dct_documents d
                       WHERE  d.source_module = 'CC'
                       AND    d.source_type   = 'REQUEST'
                       AND    d.source_id     = p_request_id
                       AND    d.doc_req_id    = dr.doc_req_id
                       AND    d.is_active     = 'Y'
                       AND    d.status        = 'ACTIVE')
            ORDER BY dr.display_seq
        ) LOOP
            v_missing := v_missing || rec.document_name || ', ';
        END LOOP;

        IF v_missing IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20101,
                'Missing mandatory documents: ' || RTRIM(v_missing, ', '));
        END IF;
    END validate_docs;

    -- -------------------------------------------------------------------------
    -- Private: resolve the active approval template for a CC request type.
    -- Template request_type may be a comma list (e.g. CC_CHANGE_APPROVAL covers
    -- 'INCREASE_LIMIT,DECREASE_LIMIT,REPLACEMENT').
    -- -------------------------------------------------------------------------
    FUNCTION find_template (p_request_type IN VARCHAR2) RETURN NUMBER IS
        v_tmpl_id NUMBER;
    BEGIN
        SELECT at.template_id INTO v_tmpl_id
        FROM   prod.dct_approval_templates at
        JOIN   prod.dct_modules            m ON m.module_id = at.module_id
        WHERE  m.module_code = 'CREDIT_CARDS'
        AND    at.is_active  = 'Y'
        AND    INSTR(',' || at.request_type || ',', ',' || p_request_type || ',') > 0
        FETCH FIRST 1 ROW ONLY;
        RETURN v_tmpl_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20102,
            'No active approval template found for request type ' || p_request_type);
    END find_template;

    -- -------------------------------------------------------------------------
    -- Private: first applicable step of a template (evaluates conditions)
    -- p_after_seq = 0 → first step; returns NULL when no further step applies
    -- -------------------------------------------------------------------------
    FUNCTION next_applicable_step (
        p_template_id IN NUMBER,
        p_after_seq   IN NUMBER,
        p_amount      IN NUMBER
    ) RETURN NUMBER IS
    BEGIN
        FOR s IN (
            SELECT step_seq, condition_type, amount_operator, amount_threshold,
                   custom_condition
            FROM   prod.dct_approval_steps
            WHERE  template_id = p_template_id
            AND    step_seq    > p_after_seq
            ORDER  BY step_seq
        ) LOOP
            IF    s.condition_type = 'ALWAYS' THEN
                RETURN s.step_seq;
            ELSIF s.condition_type = 'AMOUNT' THEN
                IF   (s.amount_operator = '>'  AND p_amount >  s.amount_threshold)
                  OR (s.amount_operator = '>=' AND p_amount >= s.amount_threshold)
                  OR (s.amount_operator = '<'  AND p_amount <  s.amount_threshold)
                  OR (s.amount_operator = '<=' AND p_amount <= s.amount_threshold)
                  OR (s.amount_operator = '='  AND p_amount =  s.amount_threshold) THEN
                    RETURN s.step_seq;
                END IF;
            ELSIF s.condition_type = 'CUSTOM' THEN
                IF eval_custom_condition(s.custom_condition) THEN
                    RETURN s.step_seq;
                END IF;
            ELSE
                RETURN s.step_seq;   -- unknown condition types fail open
            END IF;
        END LOOP;
        RETURN NULL;
    END next_applicable_step;

    -- -------------------------------------------------------------------------
    -- Private: notify the approver role of a step
    -- -------------------------------------------------------------------------
    PROCEDURE notify_step_approvers (
        p_template_id IN NUMBER,
        p_step_seq    IN NUMBER,
        p_title       IN VARCHAR2,
        p_body        IN VARCHAR2
    ) IS
        v_role_code prod.dct_roles.role_code%TYPE;
    BEGIN
        SELECT r.role_code INTO v_role_code
        FROM   prod.dct_approval_steps s
        JOIN   prod.dct_roles          r ON r.role_id = s.required_role_id
        WHERE  s.template_id = p_template_id
        AND    s.step_seq    = p_step_seq;

        notify_role(v_role_code, 'APPROVAL_REQUEST', p_title, p_body);
    EXCEPTION WHEN OTHERS THEN NULL;
    END notify_step_approvers;

    -- =========================================================================
    -- SUBMIT_REQUEST
    -- =========================================================================
    PROCEDURE submit_request (p_request_id IN NUMBER, p_user_id IN NUMBER) IS
        v_req       prod.dct_cc_requests%ROWTYPE;
        v_card      prod.dct_credit_cards%ROWTYPE;
        v_tmpl_id   NUMBER;
        v_first_seq NUMBER;
        v_inst_id   NUMBER;
        v_open_cnt  NUMBER;
        v_max_limit NUMBER := TO_NUMBER(get_setting('MAX_CARD_LIMIT_AED'));
        v_username  VARCHAR2(100) := username_of(p_user_id);
    BEGIN
        SELECT * INTO v_req
        FROM   prod.dct_cc_requests
        WHERE  request_id = p_request_id
        FOR UPDATE NOWAIT;

        IF v_req.status != 'DRAFT' THEN
            RAISE_APPLICATION_ERROR(-20103,
                'Only DRAFT requests can be submitted (current status: ' || v_req.status || ').');
        END IF;

        -- Lookup-first: enum columns validate against Admin-managed lookups
        prod.dct_lookup_pkg.validate_lookup('CC_REQUEST_TYPE',        v_req.request_type);
        prod.dct_lookup_pkg.validate_lookup('CC_REPLACEMENT_REASON',  v_req.replacement_reason);

        -- Type-specific validations -------------------------------------------------
        IF v_req.request_type = 'NEW_CARD' THEN
            IF v_req.cc_id IS NOT NULL THEN
                RAISE_APPLICATION_ERROR(-20104, 'NEW_CARD requests must not reference an existing card.');
            END IF;
            IF v_req.requested_limit IS NULL THEN
                RAISE_APPLICATION_ERROR(-20105, 'NEW_CARD requests require a requested credit limit.');
            END IF;
        ELSE
            IF v_req.cc_id IS NULL THEN
                RAISE_APPLICATION_ERROR(-20106, v_req.request_type || ' requests require a card.');
            END IF;

            SELECT * INTO v_card
            FROM   prod.dct_credit_cards
            WHERE  cc_id = v_req.cc_id
            FOR UPDATE NOWAIT;

            IF v_card.status != 'ACTIVE' THEN
                RAISE_APPLICATION_ERROR(-20107,
                    'Card must be ACTIVE to submit a ' || v_req.request_type ||
                    ' request (current card status: ' || v_card.status || ').');
            END IF;

            -- No other open request on the same card
            SELECT COUNT(*) INTO v_open_cnt
            FROM   prod.dct_cc_requests
            WHERE  cc_id = v_req.cc_id
            AND    request_id != p_request_id
            AND    status IN ('SUBMITTED', 'UNDER_REVIEW');
            IF v_open_cnt > 0 THEN
                RAISE_APPLICATION_ERROR(-20108,
                    'Another request for this card is already in progress.');
            END IF;

            IF v_req.request_type = 'INCREASE_LIMIT' THEN
                IF v_req.requested_limit IS NULL OR v_req.requested_limit <= v_card.credit_limit THEN
                    RAISE_APPLICATION_ERROR(-20109,
                        'Requested limit must exceed the current limit (' || v_card.credit_limit || ').');
                END IF;
            ELSIF v_req.request_type = 'DECREASE_LIMIT' THEN
                IF v_req.requested_limit IS NULL
                   OR v_req.requested_limit >= v_card.credit_limit
                   OR v_req.requested_limit <= 0 THEN
                    RAISE_APPLICATION_ERROR(-20110,
                        'Requested limit must be below the current limit (' || v_card.credit_limit || ') and above zero.');
                END IF;
            ELSIF v_req.request_type = 'REPLACEMENT' THEN
                IF v_req.replacement_reason IS NULL THEN
                    RAISE_APPLICATION_ERROR(-20111, 'Replacement requests require a replacement reason.');
                END IF;
            END IF;
        END IF;

        -- Limit ceiling (applies to NEW_CARD and INCREASE_LIMIT)
        IF v_max_limit IS NOT NULL
           AND v_req.request_type IN ('NEW_CARD', 'INCREASE_LIMIT')
           AND v_req.requested_limit > v_max_limit THEN
            RAISE_APPLICATION_ERROR(-20112,
                'Requested limit exceeds the configured maximum of ' || v_max_limit || ' AED.');
        END IF;

        validate_docs(p_request_id, v_req.request_type);

        -- Approval instance ---------------------------------------------------------
        v_tmpl_id   := find_template(v_req.request_type);
        v_first_seq := next_applicable_step(v_tmpl_id, 0, NVL(v_req.requested_limit, 0));
        IF v_first_seq IS NULL THEN
            RAISE_APPLICATION_ERROR(-20113,
                'Approval template has no applicable steps for this request.');
        END IF;

        INSERT INTO prod.dct_approval_instances (
            template_id, source_module, source_record_id,
            source_record_ref, current_step_seq, overall_status,
            submitted_by, submitted_at, created_by, updated_by)
        VALUES (
            v_tmpl_id, 'CC_REQUEST', p_request_id,
            v_req.request_number, v_first_seq, 'PENDING',
            p_user_id, SYSTIMESTAMP, v_username, v_username)
        RETURNING instance_id INTO v_inst_id;

        UPDATE prod.dct_cc_requests SET
            status               = 'SUBMITTED',
            approval_instance_id = v_inst_id,
            submitted_at         = SYSDATE,
            updated_by           = v_username
        WHERE request_id = p_request_id;

        -- Card status is NOT changed: the "no other open request" guard above is
        -- the exclusivity rule, and DCT_CC_CARD_V derives pending_operation.
        log_status('REQUEST', p_request_id, 'DRAFT', 'SUBMITTED', p_user_id,
                   v_req.request_type || ' request submitted for approval');

        notify_step_approvers(v_tmpl_id, v_first_seq,
            'Credit Card Request Pending Approval',
            'Request ' || v_req.request_number || ' (' || v_req.request_type ||
            ') is awaiting your approval.');

        COMMIT;
    END submit_request;

    -- =========================================================================
    -- REVERT_REQUEST_EFFECTS — retained for API compatibility.
    -- Since Phase 2.2 a request never alters the card status (the
    -- *_IN_PROGRESS pseudo-statuses are retired), so there is nothing to revert.
    -- =========================================================================
    PROCEDURE revert_request_effects (p_request_id IN NUMBER) IS
    BEGIN
        NULL;
    END revert_request_effects;

    -- =========================================================================
    -- WITHDRAW_REQUEST
    -- =========================================================================
    PROCEDURE withdraw_request (p_request_id IN NUMBER, p_user_id IN NUMBER) IS
        v_req      prod.dct_cc_requests%ROWTYPE;
        v_username VARCHAR2(100) := username_of(p_user_id);
    BEGIN
        SELECT * INTO v_req
        FROM   prod.dct_cc_requests
        WHERE  request_id = p_request_id
        FOR UPDATE NOWAIT;

        IF v_req.status NOT IN ('SUBMITTED', 'UNDER_REVIEW', 'RETURNED') THEN
            RAISE_APPLICATION_ERROR(-20114,
                'Only SUBMITTED, UNDER_REVIEW or RETURNED requests can be withdrawn (current: '
                || v_req.status || ').');
        END IF;

        IF v_req.approval_instance_id IS NOT NULL THEN
            UPDATE prod.dct_approval_instances SET
                overall_status   = 'CANCELLED',
                current_step_seq = NULL,
                completed_at     = SYSTIMESTAMP,
                last_action_at   = SYSTIMESTAMP,
                updated_by       = v_username,
                updated_at       = SYSTIMESTAMP
            WHERE instance_id    = v_req.approval_instance_id
            AND   overall_status = 'PENDING';
        END IF;

        UPDATE prod.dct_cc_requests SET
            status     = 'WITHDRAWN',
            updated_by = v_username
        WHERE request_id = p_request_id;

        log_status('REQUEST', p_request_id, v_req.status, 'WITHDRAWN', p_user_id,
                   'Withdrawn by requester');
        COMMIT;
    END withdraw_request;

    -- =========================================================================
    -- APPLY_APPROVED_REQUEST — business effect on final approval
    -- =========================================================================
    PROCEDURE apply_approved_request (p_request_id IN NUMBER, p_user_id IN NUMBER) IS
        v_req      prod.dct_cc_requests%ROWTYPE;
        v_card     prod.dct_credit_cards%ROWTYPE;
        v_username VARCHAR2(100) := username_of(p_user_id);
    BEGIN
        SELECT * INTO v_req
        FROM   prod.dct_cc_requests
        WHERE  request_id = p_request_id
        FOR UPDATE NOWAIT;

        IF v_req.cc_id IS NOT NULL THEN
            SELECT * INTO v_card
            FROM   prod.dct_credit_cards
            WHERE  cc_id = v_req.cc_id
            FOR UPDATE NOWAIT;
        END IF;

        IF v_req.request_type IN ('INCREASE_LIMIT', 'DECREASE_LIMIT') THEN
            INSERT INTO prod.dct_cc_card_limit_history (
                cc_id, old_limit, new_limit, change_type,
                request_id, changed_by, notes)
            VALUES (
                v_req.cc_id, v_card.credit_limit, v_req.requested_limit,
                CASE v_req.request_type WHEN 'INCREASE_LIMIT' THEN 'INCREASE' ELSE 'DECREASE' END,
                p_request_id, v_username, v_req.reason);

            UPDATE prod.dct_credit_cards SET
                credit_limit = v_req.requested_limit,
                updated_by   = v_username
            WHERE cc_id = v_req.cc_id;

        ELSIF v_req.request_type = 'CLOSE_CARD' THEN
            prod.dct_lookup_pkg.validate_lookup('CC_CARD_STATUS', 'CLOSED');
            UPDATE prod.dct_credit_cards SET
                status     = 'CLOSED',
                updated_by = v_username
            WHERE cc_id = v_req.cc_id;

            log_status('CARD', v_req.cc_id, v_card.status, 'CLOSED', p_user_id,
                       'Closed via approved request ' || v_req.request_number);

        ELSIF v_req.request_type = 'REPLACEMENT' THEN
            -- Same logical card record; physical replacement handled with the bank.
            UPDATE prod.dct_credit_cards SET
                notes      = SUBSTR('Replacement approved ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD') ||
                                    ' (' || NVL(v_req.replacement_reason, 'OTHER') || '). ' ||
                                    v_card.notes, 1, 1000),
                updated_by = v_username
            WHERE cc_id = v_req.cc_id;

            notify_role('CC_ADMIN', 'STATUS_UPDATE',
                'Card Replacement Approved',
                'Replacement for request ' || v_req.request_number ||
                ' is approved — order the replacement card from the bank and update the card expiry date.');

        ELSIF v_req.request_type = 'NEW_CARD' THEN
            -- Card cannot be auto-created: bank data (holder, mother name,
            -- nationality, expiry) is not on the request. CC Admin completes
            -- issuance via REGISTER_CARD once the bank issues the card.
            notify_role('CC_ADMIN', 'STATUS_UPDATE',
                'New Card Request Approved',
                'Request ' || v_req.request_number ||
                ' is fully approved — register the card via Register Card once issued by the bank.');
        END IF;

        -- Notify the requester
        BEGIN
            DECLARE v_uid NUMBER;
            BEGIN
                SELECT user_id INTO v_uid FROM prod.dct_users
                WHERE  username = v_req.created_by;
                notify_user(v_uid, 'STATUS_UPDATE',
                    'Credit Card Request Approved',
                    'Your request ' || v_req.request_number || ' (' || v_req.request_type ||
                    ') has been approved.');
            END;
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
    END apply_approved_request;

    -- =========================================================================
    -- ACT_ON_APPROVAL — one approval decision on a CC instance
    -- =========================================================================
    PROCEDURE act_on_approval (
        p_instance_id IN NUMBER,
        p_user_id     IN NUMBER,
        p_action      IN VARCHAR2,
        p_comments    IN VARCHAR2
    ) IS
        v_inst     prod.dct_approval_instances%ROWTYPE;
        v_step_id  NUMBER;
        v_amount   NUMBER := 0;
        v_next     NUMBER;
        v_old      VARCHAR2(30);
        v_src_type VARCHAR2(30);
        v_username VARCHAR2(100) := username_of(p_user_id);
    BEGIN
        IF UPPER(p_action) NOT IN ('APPROVED', 'REJECTED', 'RETURNED') THEN
            RAISE_APPLICATION_ERROR(-20115, 'Invalid action. Use APPROVED, REJECTED, or RETURNED.');
        END IF;
        IF p_comments IS NULL THEN
            RAISE_APPLICATION_ERROR(-20116, 'Comments are required.');
        END IF;

        SELECT * INTO v_inst
        FROM   prod.dct_approval_instances
        WHERE  instance_id = p_instance_id
        FOR UPDATE NOWAIT;

        IF v_inst.overall_status != 'PENDING' THEN
            RAISE_APPLICATION_ERROR(-20117, 'Approval instance is not PENDING.');
        END IF;
        IF v_inst.source_module NOT IN ('CC_REQUEST', 'CC_REPLENISHMENT') THEN
            RAISE_APPLICATION_ERROR(-20118,
                'Instance does not belong to the Credit Cards module.');
        END IF;

        SELECT step_id INTO v_step_id
        FROM   prod.dct_approval_steps
        WHERE  template_id = v_inst.template_id
        AND    step_seq    = v_inst.current_step_seq;

        -- Current source status for the status-history log
        IF v_inst.source_module = 'CC_REQUEST' THEN
            v_src_type := 'REQUEST';
            SELECT status INTO v_old FROM prod.dct_cc_requests
            WHERE  request_id = v_inst.source_record_id;
        ELSE
            v_src_type := 'REPLENISHMENT';
            SELECT status INTO v_old FROM prod.dct_cc_replenishments
            WHERE  replenishment_id = v_inst.source_record_id;
        END IF;

        INSERT INTO prod.dct_approval_actions (instance_id, step_id, actioned_by, action, comments)
        VALUES (p_instance_id, v_step_id, p_user_id, UPPER(p_action), p_comments);

        IF UPPER(p_action) = 'APPROVED' THEN
            -- Amount for conditional steps
            BEGIN
                IF v_inst.source_module = 'CC_REQUEST' THEN
                    SELECT NVL(requested_limit, 0) INTO v_amount
                    FROM prod.dct_cc_requests WHERE request_id = v_inst.source_record_id;
                ELSE
                    SELECT NVL(total_amount, 0) INTO v_amount
                    FROM prod.dct_cc_replenishments WHERE replenishment_id = v_inst.source_record_id;
                END IF;
            EXCEPTION WHEN OTHERS THEN v_amount := 0;
            END;

            v_next := next_applicable_step(v_inst.template_id, v_inst.current_step_seq, v_amount);

            IF v_next IS NOT NULL THEN
                UPDATE prod.dct_approval_instances SET
                    current_step_seq = v_next,
                    last_action_at   = SYSTIMESTAMP,
                    updated_by       = v_username,
                    updated_at       = SYSTIMESTAMP
                WHERE instance_id = p_instance_id;

                IF v_inst.source_module = 'CC_REQUEST' THEN
                    UPDATE prod.dct_cc_requests SET status = 'UNDER_REVIEW', updated_by = v_username
                    WHERE  request_id = v_inst.source_record_id AND status = 'SUBMITTED';
                ELSE
                    UPDATE prod.dct_cc_replenishments SET status = 'UNDER_REVIEW', updated_by = v_username
                    WHERE  replenishment_id = v_inst.source_record_id AND status = 'SUBMITTED';
                END IF;
                IF SQL%ROWCOUNT > 0 THEN
                    log_status(v_src_type, v_inst.source_record_id, v_old, 'UNDER_REVIEW',
                               p_user_id, 'Step approved; moved to next approval step');
                END IF;

                notify_step_approvers(v_inst.template_id, v_next,
                    'Credit Card Approval Pending',
                    v_inst.source_record_ref || ' is awaiting your approval (next step).');
            ELSE
                -- Final approval
                UPDATE prod.dct_approval_instances SET
                    overall_status   = 'APPROVED',
                    current_step_seq = NULL,
                    completed_at     = SYSTIMESTAMP,
                    last_action_at   = SYSTIMESTAMP,
                    updated_by       = v_username,
                    updated_at       = SYSTIMESTAMP
                WHERE instance_id = p_instance_id;

                IF v_inst.source_module = 'CC_REQUEST' THEN
                    UPDATE prod.dct_cc_requests SET status = 'APPROVED', updated_by = v_username
                    WHERE  request_id = v_inst.source_record_id;
                    log_status(v_src_type, v_inst.source_record_id, v_old, 'APPROVED',
                               p_user_id, p_comments);
                    apply_approved_request(v_inst.source_record_id, p_user_id);
                ELSE
                    UPDATE prod.dct_cc_replenishments SET status = 'APPROVED', updated_by = v_username
                    WHERE  replenishment_id = v_inst.source_record_id;
                    log_status(v_src_type, v_inst.source_record_id, v_old, 'APPROVED',
                               p_user_id, p_comments);

                    BEGIN
                        DECLARE v_owner NUMBER; v_ref VARCHAR2(50);
                        BEGIN
                            SELECT on_behalf_of_user_id, reimb_number INTO v_owner, v_ref
                            FROM   prod.dct_cc_replenishments
                            WHERE  replenishment_id = v_inst.source_record_id;
                            notify_user(v_owner, 'STATUS_UPDATE',
                                'Replenishment Approved',
                                'Monthly replenishment ' || v_ref || ' has been approved.');
                        END;
                    EXCEPTION WHEN OTHERS THEN NULL;
                    END;
                END IF;
            END IF;

        ELSE
            -- REJECTED or RETURNED
            UPDATE prod.dct_approval_instances SET
                overall_status   = UPPER(p_action),
                current_step_seq = NULL,
                completed_at     = SYSTIMESTAMP,
                last_action_at   = SYSTIMESTAMP,
                updated_by       = v_username,
                updated_at       = SYSTIMESTAMP
            WHERE instance_id = p_instance_id;

            IF v_inst.source_module = 'CC_REQUEST' THEN
                UPDATE prod.dct_cc_requests SET status = UPPER(p_action), updated_by = v_username
                WHERE  request_id = v_inst.source_record_id;
            ELSE
                UPDATE prod.dct_cc_replenishments SET status = UPPER(p_action), updated_by = v_username
                WHERE  replenishment_id = v_inst.source_record_id;
            END IF;
            log_status(v_src_type, v_inst.source_record_id, v_old, UPPER(p_action),
                       p_user_id, p_comments);
        END IF;

        COMMIT;
    END act_on_approval;

    -- =========================================================================
    -- REGISTER_CARD — physical card issuance after approved NEW_CARD request
    -- =========================================================================
    PROCEDURE register_card (
        p_request_id     IN NUMBER,
        p_holder_user_id IN NUMBER,
        p_mother_name    IN VARCHAR2,
        p_nationality    IN VARCHAR2,
        p_credit_limit   IN NUMBER,
        p_expiry_date    IN DATE,
        p_email          IN VARCHAR2,
        p_org_id         IN NUMBER,
        p_cost_center    IN VARCHAR2 DEFAULT NULL,
        p_user_id        IN NUMBER,
        p_cc_id          OUT NUMBER
    ) IS
        v_req      prod.dct_cc_requests%ROWTYPE;
        v_number   VARCHAR2(30);
        v_username VARCHAR2(100) := username_of(p_user_id);
    BEGIN
        SELECT * INTO v_req
        FROM   prod.dct_cc_requests
        WHERE  request_id = p_request_id
        FOR UPDATE NOWAIT;

        IF v_req.request_type != 'NEW_CARD' OR v_req.status != 'APPROVED' THEN
            RAISE_APPLICATION_ERROR(-20119,
                'Card can only be registered against an APPROVED NEW_CARD request.');
        END IF;
        IF v_req.cc_id IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20120,
                'A card has already been registered for this request.');
        END IF;

        v_number := gen_card_number;

        INSERT INTO prod.dct_credit_cards (
            cc_number, holder_user_id, mother_name, nationality,
            credit_limit, expiry_date, email, org_id, cost_center,
            bank_name, status, approval_instance_id,
            created_by, updated_by)
        VALUES (
            v_number, p_holder_user_id, p_mother_name, p_nationality,
            p_credit_limit, p_expiry_date, p_email, p_org_id, p_cost_center,
            get_setting('BANK_NAME'), 'ACTIVE', v_req.approval_instance_id,
            v_username, v_username)
        RETURNING cc_id INTO p_cc_id;

        INSERT INTO prod.dct_cc_card_limit_history (
            cc_id, old_limit, new_limit, change_type, request_id, changed_by, notes)
        VALUES (
            p_cc_id, 0, p_credit_limit, 'INITIAL', p_request_id, v_username,
            'Initial limit on card issuance (' || v_number || ').');

        UPDATE prod.dct_cc_requests SET
            cc_id      = p_cc_id,
            updated_by = v_username
        WHERE request_id = p_request_id;

        log_status('CARD', p_cc_id, NULL, 'ACTIVE', p_user_id,
                   'Card ' || v_number || ' registered against request ' || v_req.request_number);

        notify_user(p_holder_user_id, 'STATUS_UPDATE',
            'Credit Card Issued',
            'Your corporate credit card ' || v_number || ' has been issued with a limit of '
            || p_credit_limit || ' AED.');

        COMMIT;
    END register_card;

    -- =========================================================================
    -- RECALC_REPLENISHMENT_TOTAL
    -- =========================================================================
    PROCEDURE recalc_replenishment_total (p_replenishment_id IN NUMBER) IS
    BEGIN
        UPDATE prod.dct_cc_replenishments h SET
            total_amount = NVL((SELECT SUM(l.amount)
                                FROM   prod.dct_budget_coding_lines l
                                WHERE  l.source_module = 'CC'
                                AND    l.source_type   = 'CC_REPL'
                                AND    l.source_id     = p_replenishment_id), 0)
        WHERE h.replenishment_id = p_replenishment_id;
    END recalc_replenishment_total;

    -- =========================================================================
    -- SUBMIT_REPLENISHMENT
    -- =========================================================================
    PROCEDURE submit_replenishment (p_replenishment_id IN NUMBER, p_user_id IN NUMBER) IS
        v_rep        prod.dct_cc_replenishments%ROWTYPE;
        v_card       prod.dct_credit_cards%ROWTYPE;
        v_line_cnt   NUMBER;
        v_is_proxy   NUMBER;
        v_tmpl_id    NUMBER;
        v_first_seq  NUMBER;
        v_inst_id    NUMBER;
        v_username   VARCHAR2(100) := username_of(p_user_id);
        v_lines_req  VARCHAR2(1)   := NVL(get_setting('REPLENISHMENT_LINES_REQUIRED'), 'Y');
    BEGIN
        SELECT * INTO v_rep
        FROM   prod.dct_cc_replenishments
        WHERE  replenishment_id = p_replenishment_id
        FOR UPDATE NOWAIT;

        IF v_rep.status NOT IN ('DRAFT', 'RETURNED') THEN
            RAISE_APPLICATION_ERROR(-20121,
                'Only DRAFT or RETURNED replenishments can be submitted (current: ' || v_rep.status || ').');
        END IF;

        SELECT * INTO v_card
        FROM   prod.dct_credit_cards
        WHERE  cc_id = v_rep.cc_id;

        IF v_card.status != 'ACTIVE' THEN
            RAISE_APPLICATION_ERROR(-20122,
                'Replenishments cannot be submitted for a ' || v_card.status || ' card.');
        END IF;

        -- Submitter must be the card holder or an active proxy
        IF p_user_id != v_card.holder_user_id THEN
            SELECT COUNT(*) INTO v_is_proxy
            FROM   prod.dct_cc_proxies
            WHERE  cc_id         = v_rep.cc_id
            AND    proxy_user_id = p_user_id
            AND    is_active     = 'Y'
            AND    start_date   <= SYSDATE
            AND   (end_date IS NULL OR end_date >= SYSDATE);
            IF v_is_proxy = 0 THEN
                RAISE_APPLICATION_ERROR(-20123,
                    'Only the card holder or an active proxy may submit this replenishment.');
            END IF;
        END IF;

        -- Period sanity: not in the future
        IF (v_rep.period_year * 100 + v_rep.period_month) >
           TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMM')) THEN
            RAISE_APPLICATION_ERROR(-20124, 'Replenishment period cannot be in the future.');
        END IF;

        -- Lines (unified dct_budget_coding_lines; the table's GL/PROJECT
        -- exclusivity constraint guarantees every line carries a valid coding)
        SELECT COUNT(*) INTO v_line_cnt
        FROM   prod.dct_budget_coding_lines
        WHERE  source_module = 'CC'
        AND    source_type   = 'CC_REPL'
        AND    source_id     = p_replenishment_id;

        IF v_lines_req = 'Y' AND v_line_cnt = 0 THEN
            RAISE_APPLICATION_ERROR(-20125,
                'At least one expense line is required before submission.');
        END IF;

        recalc_replenishment_total(p_replenishment_id);

        -- Approval instance
        v_tmpl_id   := find_template('REPLENISHMENT');
        v_first_seq := next_applicable_step(v_tmpl_id, 0, NVL(v_rep.total_amount, 0));
        IF v_first_seq IS NULL THEN
            RAISE_APPLICATION_ERROR(-20127,
                'Approval template has no applicable steps for this replenishment.');
        END IF;

        INSERT INTO prod.dct_approval_instances (
            template_id, source_module, source_record_id,
            source_record_ref, current_step_seq, overall_status,
            submitted_by, submitted_at, created_by, updated_by)
        VALUES (
            v_tmpl_id, 'CC_REPLENISHMENT', p_replenishment_id,
            v_rep.reimb_number, v_first_seq, 'PENDING',
            p_user_id, SYSTIMESTAMP, v_username, v_username)
        RETURNING instance_id INTO v_inst_id;

        UPDATE prod.dct_cc_replenishments SET
            status               = 'SUBMITTED',
            approval_instance_id = v_inst_id,
            submitted_at         = SYSDATE,
            updated_by           = v_username
        WHERE replenishment_id = p_replenishment_id;

        log_status('REPLENISHMENT', p_replenishment_id, v_rep.status, 'SUBMITTED', p_user_id,
                   'Replenishment ' || TO_CHAR(v_rep.period_month, 'FM00') || '/' ||
                   v_rep.period_year || ' submitted for approval');

        notify_step_approvers(v_tmpl_id, v_first_seq,
            'Replenishment Pending Approval',
            'Monthly replenishment ' || v_rep.reimb_number || ' ('
            || TO_CHAR(v_rep.period_month, 'FM00') || '/' || v_rep.period_year
            || ') is awaiting your approval.');

        COMMIT;
    END submit_replenishment;

    -- =========================================================================
    -- CHECK_REPLENISHMENT_DUE — daily scheduled job
    -- Reminds holder + proxies when last month's statement is missing once
    -- REPLENISHMENT_DUE_DAY + REPLENISHMENT_GRACE_DAYS has passed.
    -- =========================================================================
    PROCEDURE check_replenishment_due IS
        v_due_day   NUMBER := NVL(TO_NUMBER(get_setting('REPLENISHMENT_DUE_DAY')), 5);
        v_grace     NUMBER := NVL(TO_NUMBER(get_setting('REPLENISHMENT_GRACE_DAYS')), 3);
        v_prev      DATE   := TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM');
        v_p_month   NUMBER := EXTRACT(MONTH FROM v_prev);
        v_p_year    NUMBER := EXTRACT(YEAR  FROM v_prev);
    BEGIN
        IF EXTRACT(DAY FROM SYSDATE) <= v_due_day + v_grace THEN
            RETURN;   -- still within due window
        END IF;

        FOR c IN (
            SELECT cc.cc_id, cc.cc_number, cc.holder_user_id
            FROM   prod.dct_credit_cards cc
            WHERE  cc.status = 'ACTIVE'
            AND    NOT EXISTS (
                       SELECT 1 FROM prod.dct_cc_replenishments r
                       WHERE  r.cc_id        = cc.cc_id
                       AND    r.period_month = v_p_month
                       AND    r.period_year  = v_p_year)
        ) LOOP
            notify_user(c.holder_user_id, 'REMINDER',
                'Monthly Replenishment Overdue',
                'The ' || TO_CHAR(v_prev, 'Month YYYY') || ' replenishment for card '
                || c.cc_number || ' has not been submitted and is past its due date.');

            FOR p IN (
                SELECT proxy_user_id
                FROM   prod.dct_cc_proxies
                WHERE  cc_id     = c.cc_id
                AND    is_active = 'Y'
                AND    start_date <= SYSDATE
                AND   (end_date IS NULL OR end_date >= SYSDATE)
            ) LOOP
                notify_user(p.proxy_user_id, 'REMINDER',
                    'Monthly Replenishment Overdue (Proxy)',
                    'The ' || TO_CHAR(v_prev, 'Month YYYY') || ' replenishment for card '
                    || c.cc_number || ' has not been submitted and is past its due date.');
            END LOOP;
        END LOOP;
    END check_replenishment_due;

END dct_cc_pkg;
/

SHOW ERRORS PACKAGE prod.dct_cc_pkg
SHOW ERRORS PACKAGE BODY prod.dct_cc_pkg

-- =============================================================================
-- DAILY SCHEDULER JOB — replenishment overdue reminders (07:00, like DT jobs)
-- =============================================================================
DECLARE
    v_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt
    FROM   all_scheduler_jobs
    WHERE  owner = 'PROD' AND job_name = 'JOB_CC_REPL_REMINDER';

    IF v_cnt > 0 THEN
        DBMS_SCHEDULER.DROP_JOB(job_name => 'PROD.JOB_CC_REPL_REMINDER', force => TRUE);
    END IF;

    DBMS_SCHEDULER.CREATE_JOB(
        job_name        => 'PROD.JOB_CC_REPL_REMINDER',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN prod.dct_cc_pkg.check_replenishment_due; END;',
        start_date      => SYSTIMESTAMP,
        repeat_interval => 'FREQ=DAILY;BYHOUR=7;BYMINUTE=0',
        enabled         => TRUE,
        comments        => 'Daily reminder for overdue monthly credit card replenishments');
END;
/

PROMPT
PROMPT === 04_cc_pkg.sql complete ===
PROMPT Package DCT_CC_PKG created (spec + body) + 3 sequences + JOB_CC_REPL_REMINDER
