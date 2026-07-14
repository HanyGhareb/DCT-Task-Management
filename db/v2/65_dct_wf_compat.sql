SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

-- =============================================================================
-- 65_dct_wf_compat.sql
-- i-Finance Workflow Platform (DWP) -- the compatibility facade
-- Schema  : PROD (run as ADMIN with schema-qualified names)
--
-- WHAT THIS IS: the body of the /dct/approvals/:id/action ORDS handler, LIFTED
-- VERBATIM out of db/v2/11c_dct_inbox_step_approvers.sql into a real package.
-- Reviewing it is a DIFF, not an audit. It is deliberately not improved, not
-- tidied, and not refactored -- every quirk below is today's live behaviour and
-- stays that way until a module is migrated on purpose.
--
-- WHY IT EXISTS: approval logic currently lives inside ORDS handler text. That
-- is why db/v2/11b and 11c exist at all, and why they must be re-run after every
-- 11 re-run -- a deployment coupling that has bitten this repo repeatedly. Once
-- the handler is a three-line facade over this package, that coupling is DEAD:
-- changing approval behaviour becomes CREATE OR REPLACE PACKAGE BODY, with no
-- ORDS churn, no fresh SQLcl session, and no re-run ordering to remember.
--
-- THE ROUTER: act() dispatches on the id alone.
--     id >= 900,000,000  ->  a DCT_WF_TASK      (the new engine)
--     id <  900,000,000  ->  a legacy instance  (dct_approval_instances)
-- The ranges cannot collide -- dct_wf_task.task_id is IDENTITY START WITH
-- 900000000 and dct_approval_instances.instance_id started at 1 and is in the
-- thousands. That single invariant is what lets the RN mobile app (App 209) and
-- every un-migrated module keep calling POST /dct/approvals/:id/action, unchanged,
-- through the entire migration.
--
-- NO COMMIT IN HERE. The caller owns the transaction (the ORDS handler commits,
-- exactly as it does today). A package that commits on your behalf cannot be
-- composed, and start_process/complete_task deliberately join the caller's
-- transaction so a failure after them cannot orphan a workflow.
-- =============================================================================

PROMPT === i-Finance Workflow Platform -- compat facade ===

CREATE OR REPLACE PACKAGE prod.dct_wf_compat AS

    c_task_floor CONSTANT NUMBER := 900000000;

    -- 'WF' when the id is a new-engine task, 'LEGACY' when it is an old instance
    FUNCTION engine_of (p_id IN NUMBER) RETURN VARCHAR2;

    -- may this user act on this id, either engine? 'Y' / 'N'
    FUNCTION can_act (p_id IN NUMBER, p_user_id IN NUMBER) RETURN VARCHAR2;

    -- THE router. Every inbox action in the platform funnels through this.
    PROCEDURE act (p_id       IN NUMBER,
                   p_user_id  IN NUMBER,
                   p_username IN VARCHAR2,
                   p_action   IN VARCHAR2,
                   p_comments IN VARCHAR2);

    -- the legacy engine, lifted verbatim out of the ORDS handler
    PROCEDURE act_on_legacy (p_instance_id IN NUMBER,
                             p_user_id     IN NUMBER,
                             p_username    IN VARCHAR2,
                             p_action      IN VARCHAR2,
                             p_comments    IN VARCHAR2);

END dct_wf_compat;
/

SHOW ERRORS

CREATE OR REPLACE PACKAGE BODY prod.dct_wf_compat AS

    FUNCTION engine_of (p_id IN NUMBER) RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE WHEN p_id >= c_task_floor THEN 'WF' ELSE 'LEGACY' END;
    END;

    FUNCTION can_act (p_id IN NUMBER, p_user_id IN NUMBER) RETURN VARCHAR2 IS
        v NUMBER;
    BEGIN
        IF engine_of(p_id) = 'WF' THEN
            RETURN prod.dct_wf_engine.can_act(p_id, p_user_id);
        END IF;

        -- the legacy answer is exactly "is this request in your inbox", which is
        -- now one indexed lookup instead of the five-way duplicated predicate
        SELECT COUNT(*) INTO v
          FROM prod.dct_wf_inbox_v
         WHERE engine      = 'LEGACY'
           AND instance_id = p_id
           AND user_id     = p_user_id;

        RETURN CASE WHEN v > 0 THEN 'Y' ELSE 'N' END;
    END;

    PROCEDURE act (p_id       IN NUMBER,
                   p_user_id  IN NUMBER,
                   p_username IN VARCHAR2,
                   p_action   IN VARCHAR2,
                   p_comments IN VARCHAR2) IS
    BEGIN
        IF engine_of(p_id) = 'WF' THEN
            -- p_action is an OUTCOME CODE here (APPROVE / ENDORSE / AGREE /
            -- RETURN_FOR_INFO / FYI_ACK / ...). The engine validates it against
            -- the step's own outcome set -- there is no hard-coded verb list.
            prod.dct_wf_engine.complete_task(p_id, p_user_id, p_action, p_comments);
        ELSE
            act_on_legacy(p_id, p_user_id, p_username, p_action, p_comments);
        END IF;
    END;

    -- =====================================================================
    -- VERBATIM LIFT -- db/v2/11c_dct_inbox_step_approvers.sql, POST handler.
    -- Do not "improve" anything below without a decision to change behaviour.
    -- =====================================================================
    PROCEDURE act_on_legacy (p_instance_id IN NUMBER,
                             p_user_id     IN NUMBER,
                             p_username    IN VARCHAR2,
                             p_action      IN VARCHAR2,
                             p_comments    IN VARCHAR2) IS
        l_iid      NUMBER        := p_instance_id;
        l_uid      NUMBER        := p_user_id;
        l_user     VARCHAR2(100) := p_username;
        l_action   VARCHAR2(20)  := UPPER(p_action);
        l_comments VARCHAR2(4000):= p_comments;
        l_inst     prod.dct_approval_instances%ROWTYPE;
        l_step_id  NUMBER;
        l_amount   NUMBER := 0;
        l_next     NUMBER := NULL;
        l_owner    NUMBER := NULL;

        PROCEDURE hist (p_type VARCHAR2, p_old VARCHAR2, p_new VARCHAR2, p_cmt VARCHAR2) IS
        BEGIN
            INSERT INTO prod.dct_request_status_history (
                source_module, source_type, source_id, old_status, new_status,
                changed_by, comments)
            VALUES (CASE WHEN l_inst.source_module IN ('TRAVEL_REQUEST', 'SETTLEMENT')
                         THEN 'DT' ELSE 'PC' END,
                    p_type, l_inst.source_record_id, p_old, p_new, l_uid, p_cmt);
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
    BEGIN
        IF l_action NOT IN ('APPROVED', 'REJECTED', 'RETURNED') THEN
            raise_application_error(-20001,
                'Invalid action. Use APPROVED, REJECTED, or RETURNED');
        END IF;
        IF l_comments IS NULL THEN
            raise_application_error(-20001, 'Comments are required');
        END IF;

        SELECT * INTO l_inst FROM prod.dct_approval_instances WHERE instance_id = l_iid;
        IF l_inst.overall_status != 'PENDING' THEN
            raise_application_error(-20001, 'Approval instance is not PENDING');
        END IF;

        -- FL and CC instances are acted on by their packages (step conditions,
        -- final-approval callbacks, notifications and history live there)
        IF l_inst.source_module LIKE 'FL_%' THEN
            prod.dct_fl_pkg.act_on_approval(l_iid, l_uid, l_action, l_comments);
            RETURN;
        ELSIF l_inst.source_module LIKE 'CC_%' THEN
            prod.dct_cc_pkg.act_on_approval(l_iid, l_uid, l_action, l_comments);
            RETURN;
        END IF;

        SELECT step_id INTO l_step_id
          FROM prod.dct_approval_steps
         WHERE template_id = l_inst.template_id
           AND step_seq    = l_inst.current_step_seq;

        INSERT INTO prod.dct_approval_actions
            (instance_id, step_id, actioned_by, action, comments)
        VALUES (l_iid, l_step_id, l_uid, l_action, l_comments);

        BEGIN
            SELECT submitted_by INTO l_owner
              FROM prod.dct_approval_instances WHERE instance_id = l_iid;
        EXCEPTION WHEN OTHERS THEN NULL;
        END;

        IF l_action = 'APPROVED' THEN
            BEGIN
                IF    l_inst.source_module = 'PETTY_CASH'     THEN SELECT amount            INTO l_amount FROM prod.dct_petty_cash        WHERE pc_id         = l_inst.source_record_id;
                ELSIF l_inst.source_module = 'REIMBURSEMENT'  THEN SELECT amount            INTO l_amount FROM prod.dct_pc_reimbursements WHERE reimb_id      = l_inst.source_record_id;
                ELSIF l_inst.source_module = 'CLEARING'       THEN SELECT amount_spent      INTO l_amount FROM prod.dct_pc_clearing       WHERE clearing_id   = l_inst.source_record_id;
                ELSIF l_inst.source_module = 'TRAVEL_REQUEST' THEN SELECT total_advance_aed INTO l_amount FROM prod.dt_requests           WHERE request_id    = l_inst.source_record_id;
                ELSIF l_inst.source_module = 'SETTLEMENT'     THEN SELECT total_actual_aed  INTO l_amount FROM prod.dt_settlement         WHERE settlement_id = l_inst.source_record_id;
                END IF;
            EXCEPTION WHEN OTHERS THEN l_amount := 0;
            END;

            -- NOTE: this is one of the FOUR divergent condition evaluators the
            -- platform currently carries, and it understands only ALWAYS and
            -- AMOUNT. TYPE_FILTER / COMBINED / ORG_HEAD steps silently never
            -- fire. That is a live defect, faithfully preserved here -- see
            -- PC's TYPE_FILTER step 4, which has never once run in production.
            FOR nxt IN (
                SELECT step_seq FROM prod.dct_approval_steps
                 WHERE template_id = l_inst.template_id
                   AND step_seq    > l_inst.current_step_seq
                   AND (condition_type = 'ALWAYS'
                        OR (condition_type = 'AMOUNT' AND amount_operator = '>=' AND l_amount >= amount_threshold)
                        OR (condition_type = 'AMOUNT' AND amount_operator = '>'  AND l_amount >  amount_threshold)
                        OR (condition_type = 'AMOUNT' AND amount_operator = '<=' AND l_amount <= amount_threshold)
                        OR (condition_type = 'AMOUNT' AND amount_operator = '<'  AND l_amount <  amount_threshold))
                 ORDER BY step_seq FETCH FIRST 1 ROW ONLY)
            LOOP
                l_next := nxt.step_seq;
            END LOOP;

            IF l_next IS NOT NULL THEN
                UPDATE prod.dct_approval_instances
                   SET current_step_seq = l_next,
                       last_action_at   = SYSTIMESTAMP,
                       updated_by       = l_user,
                       updated_at       = SYSTIMESTAMP
                 WHERE instance_id = l_iid;

                IF l_inst.source_module = 'PETTY_CASH' THEN
                    UPDATE prod.dct_petty_cash SET status = 'PENDING_APPROVAL', updated_by = l_user
                     WHERE pc_id = l_inst.source_record_id AND status = 'SUBMITTED';
                    hist('PC', 'SUBMITTED', 'PENDING_APPROVAL',
                         'Step approved (Admin inbox): ' || l_comments);
                ELSIF l_inst.source_module = 'REIMBURSEMENT' THEN
                    UPDATE prod.dct_pc_reimbursements SET status = 'PENDING_APPROVAL', updated_by = l_user
                     WHERE reimb_id = l_inst.source_record_id AND status = 'SUBMITTED';
                ELSIF l_inst.source_module = 'CLEARING' THEN
                    UPDATE prod.dct_pc_clearing SET status = 'PENDING_APPROVAL', updated_by = l_user
                     WHERE clearing_id = l_inst.source_record_id AND status = 'SUBMITTED';
                END IF;
            ELSE
                UPDATE prod.dct_approval_instances
                   SET overall_status   = 'APPROVED',
                       current_step_seq = NULL,
                       completed_at     = SYSTIMESTAMP,
                       last_action_at   = SYSTIMESTAMP,
                       updated_by       = l_user,
                       updated_at       = SYSTIMESTAMP
                 WHERE instance_id = l_iid;

                IF l_inst.source_module = 'PETTY_CASH' THEN
                    -- stays PENDING_APPROVAL until Finance disburses (-> ACTIVE)
                    UPDATE prod.dct_petty_cash SET status = 'PENDING_APPROVAL', updated_by = l_user
                     WHERE pc_id = l_inst.source_record_id;
                    hist('PC', NULL, 'PENDING_APPROVAL',
                         'Fully approved - awaiting disbursement: ' || l_comments);
                ELSIF l_inst.source_module = 'REIMBURSEMENT' THEN
                    UPDATE prod.dct_pc_reimbursements SET status = 'APPROVED', updated_by = l_user
                     WHERE reimb_id = l_inst.source_record_id;
                    hist('PC_REIMB', NULL, 'APPROVED', 'Final approval: ' || l_comments);
                    -- KNOWN DIVERGENCE, preserved deliberately: DCT_APPROVAL_PKG's
                    -- sweep ALSO calls dct_pc_fusion_pkg here, and this path does
                    -- not. So a manually-approved reimbursement has never posted to
                    -- Fusion AP while an auto-approved one has. Fixing it silently
                    -- would change financial postings -- it needs announcing.
                ELSIF l_inst.source_module = 'CLEARING' THEN
                    UPDATE prod.dct_pc_clearing SET status = 'APPROVED', updated_by = l_user
                     WHERE clearing_id = l_inst.source_record_id;
                    hist('PC_CLEAR', NULL, 'APPROVED', 'Final approval: ' || l_comments);
                    DECLARE
                        l_pcid NUMBER;
                    BEGIN
                        SELECT pc_id INTO l_pcid FROM prod.dct_pc_clearing
                         WHERE clearing_id = l_inst.source_record_id;
                        UPDATE prod.dct_petty_cash
                           SET status = 'CLOSED', closed_date = SYSDATE, updated_by = l_user
                         WHERE pc_id = l_pcid;
                        INSERT INTO prod.dct_request_status_history (
                            source_module, source_type, source_id, old_status,
                            new_status, changed_by, comments)
                        VALUES ('PC', 'PC', l_pcid, NULL, 'CLOSED', l_uid,
                                'Closed by approved clearing ' || l_inst.source_record_ref);
                    EXCEPTION WHEN OTHERS THEN NULL;
                    END;
                ELSIF l_inst.source_module = 'TRAVEL_REQUEST' THEN
                    UPDATE prod.dt_requests
                       SET status = 'APPROVED', updated_by = l_user, updated_at = SYSTIMESTAMP
                     WHERE request_id = l_inst.source_record_id;
                ELSIF l_inst.source_module = 'SETTLEMENT' THEN
                    UPDATE prod.dt_settlement
                       SET status = 'APPROVED', updated_by = l_user, updated_at = SYSTIMESTAMP
                     WHERE settlement_id = l_inst.source_record_id;
                END IF;

                BEGIN
                    prod.dct_notify.send(l_owner, 'STATUS_UPDATE', 'Request Approved',
                        'Your request ' || l_inst.source_record_ref
                                        || ' has been fully approved.',
                        p_module_code => CASE WHEN l_inst.source_module
                                                   IN ('TRAVEL_REQUEST', 'SETTLEMENT')
                                              THEN 'DUTY_TRAVEL' ELSE 'PETTY_CASH' END);
                EXCEPTION WHEN OTHERS THEN NULL;
                END;
            END IF;

        ELSE
            -- REJECTED or RETURNED. Both are INSTANCE-TERMINAL in the legacy
            -- engine: current_step_seq goes NULL and the instance dies, so a
            -- resubmission forks a NEW instance and the audit trail splits.
            -- The new engine's RETURN_TO_STEP / RETURN_TO_INITIATOR fix this;
            -- until a module migrates, this is what it gets.
            UPDATE prod.dct_approval_instances
               SET overall_status   = l_action,
                   current_step_seq = NULL,
                   completed_at     = SYSTIMESTAMP,
                   last_action_at   = SYSTIMESTAMP,
                   updated_by       = l_user,
                   updated_at       = SYSTIMESTAMP
             WHERE instance_id = l_iid;

            IF l_inst.source_module = 'PETTY_CASH' THEN
                UPDATE prod.dct_petty_cash SET status = l_action, updated_by = l_user
                 WHERE pc_id = l_inst.source_record_id;
                hist('PC', NULL, l_action, l_action || ' (Admin inbox): ' || l_comments);
            ELSIF l_inst.source_module = 'REIMBURSEMENT' THEN
                UPDATE prod.dct_pc_reimbursements SET status = l_action, updated_by = l_user
                 WHERE reimb_id = l_inst.source_record_id;
                hist('PC_REIMB', NULL, l_action, l_action || ': ' || l_comments);
            ELSIF l_inst.source_module = 'CLEARING' THEN
                UPDATE prod.dct_pc_clearing SET status = l_action, updated_by = l_user
                 WHERE clearing_id = l_inst.source_record_id;
                hist('PC_CLEAR', NULL, l_action, l_action || ': ' || l_comments);
            ELSIF l_inst.source_module = 'TRAVEL_REQUEST' THEN
                UPDATE prod.dt_requests
                   SET status = l_action, updated_by = l_user, updated_at = SYSTIMESTAMP
                 WHERE request_id = l_inst.source_record_id;
            ELSIF l_inst.source_module = 'SETTLEMENT' THEN
                UPDATE prod.dt_settlement
                   SET status = l_action, updated_by = l_user, updated_at = SYSTIMESTAMP
                 WHERE settlement_id = l_inst.source_record_id;
            END IF;

            BEGIN
                prod.dct_notify.send(l_owner, 'STATUS_UPDATE',
                    'Request ' || INITCAP(l_action),
                    'Your request ' || l_inst.source_record_ref || ' was '
                                    || LOWER(l_action) || ': ' || l_comments,
                    p_module_code => CASE WHEN l_inst.source_module
                                               IN ('TRAVEL_REQUEST', 'SETTLEMENT')
                                          THEN 'DUTY_TRAVEL' ELSE 'PETTY_CASH' END);
            EXCEPTION WHEN OTHERS THEN NULL;
            END;
        END IF;
    END act_on_legacy;

END dct_wf_compat;
/

SHOW ERRORS

PROMPT
PROMPT --- synonym (ORDS handlers run as ADMIN) ---

CREATE OR REPLACE SYNONYM dct_wf_compat FOR prod.dct_wf_compat;
CREATE OR REPLACE SYNONYM dct_wf_inbox_v FOR prod.dct_wf_inbox_v;
CREATE OR REPLACE SYNONYM dct_wf_chain_v FOR prod.dct_wf_chain_v;

PROMPT
PROMPT === compat done -- verifying ===

SELECT object_name, object_type, status FROM all_objects
 WHERE owner = 'PROD' AND object_name = 'DCT_WF_COMPAT'
 ORDER BY object_type;

PROMPT
PROMPT --- the router, on the live pending instances (read-only proof) ---

SELECT v.instance_id,
       prod.dct_wf_compat.engine_of(v.id) AS routes_to,
       v.source_module,
       v.request_ref
  FROM prod.dct_wf_inbox_v v
 WHERE v.via = 'SYS_ADMIN'
 ORDER BY v.instance_id;

SELECT COUNT(*) AS invalid_objects FROM all_objects
 WHERE owner = 'PROD' AND status = 'INVALID';
