-- =============================================================================
-- DCT_APPROVAL_PKG — approval engine sweep (escalation + auto-approve)
-- File    : 14_dct_approval_pkg.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @14_dct_approval_pkg.sql
-- =============================================================================
-- Activates two dormant capabilities of the approval engine (assessment-3
-- finding: escalation_days / escalate_role_id / auto_approve_days are seeded
-- by every module but nothing evaluated them):
--
--   ESCALATE — when a PENDING instance has sat on its current step longer than
--     the step's escalation_days, notify all holders of escalate_role_id and
--     record an ESCALATED action row (once per instance+step; the
--     is_escalation flag prevents repeats).
--
--   AUTO-APPROVE — when the template's auto_approve_days > 0 and the instance
--     has been idle longer than that, approve the current step on behalf of
--     the system user, advance to the next applicable step or complete the
--     instance, and apply the per-module source-record status effect.
--
-- Scheduled daily at 07:10 as JOB_DCT_APPROVAL_SWEEP (after the module jobs).
-- =============================================================================
SET DEFINE OFF

ALTER SESSION SET CURRENT_SCHEMA = PROD;

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

CREATE OR REPLACE PACKAGE prod.dct_approval_pkg AS

    -- Run both sweeps; intended for the daily scheduler job.
    PROCEDURE sweep;

    -- Individual sweeps (callable separately for testing)
    PROCEDURE sweep_escalations;
    PROCEDURE sweep_auto_approvals;

END dct_approval_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_approval_pkg AS

    -- -------------------------------------------------------------------------
    -- System actor for auto actions: the ADMIN platform user, falling back to
    -- the instance submitter when no ADMIN account exists.
    -- -------------------------------------------------------------------------
    FUNCTION system_user_id (p_fallback IN NUMBER) RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        SELECT user_id INTO v_id
        FROM   prod.dct_users
        WHERE  username = 'ADMIN' AND is_active = 'Y' AND ROWNUM = 1;
        RETURN v_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN p_fallback;
    END system_user_id;

    PROCEDURE notify_role_users (
        p_role_id IN NUMBER,
        p_type    IN VARCHAR2,
        p_title   IN VARCHAR2,
        p_body    IN VARCHAR2,
        p_module  IN VARCHAR2
    ) IS
    BEGIN
        FOR usr IN (
            SELECT ur.user_id
            FROM   prod.dct_user_roles ur
            WHERE  ur.role_id   = p_role_id
            AND    ur.is_active = 'Y'
            AND   (ur.end_date IS NULL OR ur.end_date >= SYSDATE)
        ) LOOP
            BEGIN
                prod.dct_notify.send(
                    p_recipient_user_id => usr.user_id,
                    p_notification_type => p_type,
                    p_title_en          => p_title,
                    p_body_en           => p_body,
                    p_module_code       => p_module);
            EXCEPTION WHEN OTHERS THEN NULL;
            END;
        END LOOP;
    END notify_role_users;

    -- -------------------------------------------------------------------------
    -- Apply the per-module source-record effect of a FINAL auto-approval.
    -- Mirrors the module ORDS approve handlers; new modules must be added here.
    -- -------------------------------------------------------------------------
    PROCEDURE apply_final_approval (
        p_source_module IN VARCHAR2,
        p_source_id     IN NUMBER,
        p_actor_id      IN NUMBER
    ) IS
    BEGIN
        IF p_source_module = 'PETTY_CASH' THEN
            -- PC advances await Finance disbursement (status stays PENDING_APPROVAL)
            UPDATE prod.dct_petty_cash SET status = 'PENDING_APPROVAL'
            WHERE  pc_id = p_source_id AND status = 'SUBMITTED';
        ELSIF p_source_module = 'REIMBURSEMENT' THEN
            UPDATE prod.dct_pc_reimbursements SET status = 'APPROVED'
            WHERE  reimb_id = p_source_id;
        ELSIF p_source_module = 'CLEARING' THEN
            UPDATE prod.dct_pc_clearing SET status = 'APPROVED'
            WHERE  clearing_id = p_source_id;
            UPDATE prod.dct_petty_cash SET status = 'CLOSED', closed_date = SYSDATE
            WHERE  pc_id = (SELECT pc_id FROM prod.dct_pc_clearing WHERE clearing_id = p_source_id);
        ELSIF p_source_module = 'TRAVEL_REQUEST' THEN
            UPDATE prod.dt_requests SET status = 'APPROVED'
            WHERE  request_id = p_source_id;
        ELSIF p_source_module = 'SETTLEMENT' THEN
            UPDATE prod.dt_settlement SET status = 'APPROVED'
            WHERE  settlement_id = p_source_id;
        ELSIF p_source_module = 'CC_REQUEST' THEN
            UPDATE prod.dct_cc_requests SET status = 'APPROVED'
            WHERE  request_id = p_source_id;
            prod.dct_cc_pkg.apply_approved_request(p_source_id, p_actor_id);
        ELSIF p_source_module = 'CC_REPLENISHMENT' THEN
            UPDATE prod.dct_cc_replenishments SET status = 'APPROVED'
            WHERE  replenishment_id = p_source_id;
        END IF;
        -- Unknown source modules: instance is completed, source untouched —
        -- the owning module must register its effect above.
    END apply_final_approval;

    -- =========================================================================
    -- SWEEP_ESCALATIONS
    -- =========================================================================
    PROCEDURE sweep_escalations IS
        v_count NUMBER := 0;
        v_actor NUMBER;
    BEGIN
        FOR r IN (
            SELECT ai.instance_id, ai.source_record_ref, ai.submitted_by,
                   ast.step_id, ast.step_name, ast.escalate_role_id,
                   m.module_code,
                   TRUNC(SYSDATE) - TRUNC(CAST(NVL(ai.last_action_at, ai.submitted_at) AS DATE)) AS idle_days,
                   ast.escalation_days
            FROM   prod.dct_approval_instances ai
            JOIN   prod.dct_approval_steps     ast ON ast.template_id = ai.template_id
                                                  AND ast.step_seq    = ai.current_step_seq
            JOIN   prod.dct_approval_templates at  ON at.template_id  = ai.template_id
            JOIN   prod.dct_modules            m   ON m.module_id     = at.module_id
            WHERE  ai.overall_status = 'PENDING'
            AND    NVL(ast.escalation_days, 0) > 0
            AND    ast.escalate_role_id IS NOT NULL
            AND    TRUNC(SYSDATE) - TRUNC(CAST(NVL(ai.last_action_at, ai.submitted_at) AS DATE))
                       >= ast.escalation_days
            AND    NOT EXISTS (
                       SELECT 1 FROM prod.dct_approval_actions aa
                       WHERE  aa.instance_id   = ai.instance_id
                       AND    aa.step_id       = ast.step_id
                       AND    aa.is_escalation = 'Y')
        ) LOOP
            v_actor := system_user_id(r.submitted_by);

            INSERT INTO prod.dct_approval_actions
                (instance_id, step_id, actioned_by, action, comments, is_escalation)
            VALUES
                (r.instance_id, r.step_id, v_actor, 'ESCALATED',
                 'Auto-escalated by sweep: idle ' || r.idle_days || ' day(s) on step "'
                 || r.step_name || '" (threshold ' || r.escalation_days || ').', 'Y');

            notify_role_users(
                r.escalate_role_id, 'APPROVAL_REQUEST',
                'Escalated Approval — ' || r.source_record_ref,
                'Request ' || r.source_record_ref || ' has waited ' || r.idle_days ||
                ' day(s) on step "' || r.step_name || '" and requires attention.',
                r.module_code);

            v_count := v_count + 1;
        END LOOP;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('sweep_escalations: ' || v_count || ' instance(s) escalated');
    END sweep_escalations;

    -- =========================================================================
    -- SWEEP_AUTO_APPROVALS
    -- =========================================================================
    PROCEDURE sweep_auto_approvals IS
        v_count NUMBER := 0;
        v_next  NUMBER;
        v_actor NUMBER;
    BEGIN
        FOR r IN (
            SELECT ai.instance_id, ai.template_id, ai.current_step_seq,
                   ai.source_module, ai.source_record_id, ai.source_record_ref,
                   ai.submitted_by, ast.step_id, at.auto_approve_days,
                   TRUNC(SYSDATE) - TRUNC(CAST(NVL(ai.last_action_at, ai.submitted_at) AS DATE)) AS idle_days
            FROM   prod.dct_approval_instances ai
            JOIN   prod.dct_approval_templates at  ON at.template_id  = ai.template_id
            JOIN   prod.dct_approval_steps     ast ON ast.template_id = ai.template_id
                                                  AND ast.step_seq    = ai.current_step_seq
            WHERE  ai.overall_status = 'PENDING'
            AND    NVL(at.auto_approve_days, 0) > 0
            AND    TRUNC(SYSDATE) - TRUNC(CAST(NVL(ai.last_action_at, ai.submitted_at) AS DATE))
                       >= at.auto_approve_days
        ) LOOP
            v_actor := system_user_id(r.submitted_by);

            INSERT INTO prod.dct_approval_actions
                (instance_id, step_id, actioned_by, action, comments)
            VALUES
                (r.instance_id, r.step_id, v_actor, 'APPROVED',
                 'Auto-approved by sweep after ' || r.idle_days ||
                 ' idle day(s) (template auto_approve_days = ' || r.auto_approve_days || ').');

            -- Next unconditional/qualifying step (ALWAYS only — conditional
            -- AMOUNT/CUSTOM steps are module-context dependent and are skipped
            -- conservatively by auto-approval; they still fire on manual approval)
            v_next := NULL;
            FOR nxt IN (
                SELECT step_seq FROM prod.dct_approval_steps
                WHERE  template_id    = r.template_id
                AND    step_seq       > r.current_step_seq
                AND    condition_type = 'ALWAYS'
                ORDER  BY step_seq FETCH FIRST 1 ROW ONLY
            ) LOOP
                v_next := nxt.step_seq;
            END LOOP;

            IF v_next IS NOT NULL THEN
                UPDATE prod.dct_approval_instances SET
                    current_step_seq = v_next,
                    last_action_at   = SYSTIMESTAMP,
                    updated_at       = SYSTIMESTAMP
                WHERE instance_id = r.instance_id;
            ELSE
                UPDATE prod.dct_approval_instances SET
                    overall_status   = 'APPROVED',
                    current_step_seq = NULL,
                    completed_at     = SYSTIMESTAMP,
                    last_action_at   = SYSTIMESTAMP,
                    updated_at       = SYSTIMESTAMP
                WHERE instance_id = r.instance_id;

                apply_final_approval(r.source_module, r.source_record_id, v_actor);

                BEGIN
                    prod.dct_notify.send(
                        p_recipient_user_id => r.submitted_by,
                        p_notification_type => 'STATUS_UPDATE',
                        p_title_en          => 'Request Auto-Approved',
                        p_body_en           => 'Request ' || r.source_record_ref ||
                                               ' was auto-approved after the configured waiting period.');
                EXCEPTION WHEN OTHERS THEN NULL;
                END;
            END IF;

            v_count := v_count + 1;
        END LOOP;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('sweep_auto_approvals: ' || v_count || ' step(s) auto-approved');
    END sweep_auto_approvals;

    -- =========================================================================
    -- SWEEP
    -- =========================================================================
    PROCEDURE sweep IS
    BEGIN
        sweep_escalations;
        sweep_auto_approvals;
    END sweep;

END dct_approval_pkg;
/

SHOW ERRORS PACKAGE prod.dct_approval_pkg
SHOW ERRORS PACKAGE BODY prod.dct_approval_pkg

-- =============================================================================
-- DAILY SCHEDULER JOB — 07:10 (module alert jobs run at 07:00)
-- =============================================================================
DECLARE
    v_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt
    FROM   all_scheduler_jobs
    WHERE  owner = 'PROD' AND job_name = 'JOB_DCT_APPROVAL_SWEEP';

    IF v_cnt > 0 THEN
        DBMS_SCHEDULER.DROP_JOB(job_name => 'PROD.JOB_DCT_APPROVAL_SWEEP', force => TRUE);
    END IF;

    DBMS_SCHEDULER.CREATE_JOB(
        job_name        => 'PROD.JOB_DCT_APPROVAL_SWEEP',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN prod.dct_approval_pkg.sweep; END;',
        start_date      => SYSTIMESTAMP,
        repeat_interval => 'FREQ=DAILY;BYHOUR=7;BYMINUTE=10',
        enabled         => TRUE,
        comments        => 'Daily approval sweep: escalation notifications + auto-approvals');
END;
/

PROMPT
PROMPT === 14_dct_approval_pkg.sql complete ===
PROMPT Package DCT_APPROVAL_PKG created + JOB_DCT_APPROVAL_SWEEP scheduled daily 07:10
