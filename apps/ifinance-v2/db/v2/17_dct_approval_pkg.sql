-- =============================================================================
-- Sprint 4 — DCT_APPROVAL Package
-- Approval engine: submit / approve / reject / return / cancel / query
-- =============================================================================
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback

-- Drop any stray copies created in wrong schema during development
BEGIN
    EXECUTE IMMEDIATE 'DROP PACKAGE ADMIN.dct_approval';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

prompt ============================================================
prompt  DCT_APPROVAL — Spec
prompt ============================================================

CREATE OR REPLACE PACKAGE prod.dct_approval AS

    -- Submit a new approval request; returns the new instance_id
    FUNCTION submit (
        p_template_code  IN VARCHAR2,
        p_module         IN VARCHAR2,
        p_record_id      IN NUMBER,
        p_ref            IN VARCHAR2 DEFAULT NULL,
        p_submitted_by   IN NUMBER   DEFAULT NULL  -- NULL = derive from apex_application.g_user
    ) RETURN NUMBER;

    -- Approve the current step; advances chain or marks APPROVED if last step
    PROCEDURE approve (
        p_instance_id  IN NUMBER,
        p_user_id      IN NUMBER,
        p_comments     IN VARCHAR2 DEFAULT NULL
    );

    -- Reject the instance (terminal)
    PROCEDURE reject (
        p_instance_id  IN NUMBER,
        p_user_id      IN NUMBER,
        p_comments     IN VARCHAR2 DEFAULT NULL
    );

    -- Return for revision (terminal; submitter must resubmit)
    PROCEDURE return_for_revision (
        p_instance_id  IN NUMBER,
        p_user_id      IN NUMBER,
        p_comments     IN VARCHAR2 DEFAULT NULL
    );

    -- Cancel an instance (submitter or SYS_ADMIN only)
    PROCEDURE cancel (
        p_instance_id  IN NUMBER,
        p_user_id      IN NUMBER
    );

    -- Returns all PENDING instances where the user is the current approver
    FUNCTION get_pending_actions (
        p_user_id  IN NUMBER
    ) RETURN SYS_REFCURSOR;

    -- Returns TRUE if the user can act on this instance at its current step
    FUNCTION is_current_approver (
        p_instance_id  IN NUMBER,
        p_user_id      IN NUMBER
    ) RETURN BOOLEAN;

END dct_approval;
/

prompt ============================================================
prompt  DCT_APPROVAL — Body
prompt ============================================================

CREATE OR REPLACE PACKAGE BODY prod.dct_approval AS

    -- ── Resolve dct_users.user_id from APEX username ──────────────────────────
    FUNCTION resolve_user_id (p_username IN VARCHAR2) RETURN NUMBER IS
        l_id  NUMBER;
    BEGIN
        SELECT user_id INTO l_id
        FROM   dct_users
        WHERE  UPPER(username) = UPPER(p_username)
          AND  is_active = 'Y';
        RETURN l_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN NULL;
    END resolve_user_id;

    -- ── Internal: check if user can act at the instance's current step ────────
    FUNCTION priv_is_approver (
        p_instance_id  IN NUMBER,
        p_user_id      IN NUMBER
    ) RETURN BOOLEAN IS
        l_step_type  dct_approval_steps.step_type%TYPE;
        l_role_id    dct_approval_steps.required_role_id%TYPE;
        l_spec_user  dct_approval_steps.specific_user_id%TYPE;
        l_n          NUMBER;
    BEGIN
        BEGIN
            SELECT s.step_type, s.required_role_id, s.specific_user_id
            INTO   l_step_type, l_role_id, l_spec_user
            FROM   dct_approval_instances i
            JOIN   dct_approval_steps s
                ON s.template_id = i.template_id
               AND s.step_seq    = i.current_step_seq
            WHERE  i.instance_id   = p_instance_id
              AND  i.overall_status = 'PENDING';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN RETURN FALSE;
        END;

        -- USER_SPECIFIC: direct match
        IF l_step_type = 'USER_SPECIFIC' AND l_spec_user = p_user_id THEN
            RETURN TRUE;
        END IF;

        -- ROLE_BASED: user holds the required role
        IF l_step_type = 'ROLE_BASED' THEN
            SELECT COUNT(*) INTO l_n
            FROM   dct_user_roles
            WHERE  user_id   = p_user_id
              AND  role_id   = l_role_id
              AND  is_active = 'Y'
              AND  (start_date IS NULL OR start_date <= TRUNC(SYSDATE))
              AND  (end_date   IS NULL OR end_date   >= TRUNC(SYSDATE));
            IF l_n > 0 THEN RETURN TRUE; END IF;
        END IF;

        -- Delegation check: someone who IS the approver has delegated to this user
        SELECT COUNT(*) INTO l_n
        FROM   dct_delegations d
        WHERE  d.delegate_id = p_user_id
          AND  d.status      = 'ACTIVE'
          AND  TRUNC(SYSDATE) BETWEEN d.start_date AND d.end_date
          AND  (d.scope = 'ALL_ROLES'
                OR (d.scope = 'SPECIFIC_ROLE' AND d.role_id = l_role_id))
          AND  (
                    -- Delegator holds the role
                    (l_step_type = 'ROLE_BASED' AND EXISTS (
                        SELECT 1 FROM dct_user_roles ur
                        WHERE  ur.user_id = d.delegator_id
                          AND  ur.role_id = l_role_id
                          AND  ur.is_active = 'Y'
                          AND  (ur.start_date IS NULL OR ur.start_date <= TRUNC(SYSDATE))
                          AND  (ur.end_date   IS NULL OR ur.end_date   >= TRUNC(SYSDATE))
                    ))
                    OR
                    -- Delegator is the specific user
                    (l_step_type = 'USER_SPECIFIC' AND d.delegator_id = l_spec_user)
              );
        RETURN (l_n > 0);
    END priv_is_approver;

    -- ── Internal: send notifications to all eligible approvers for a step ─────
    PROCEDURE notify_step_approvers (
        p_instance_id  IN NUMBER,
        p_step_id      IN NUMBER
    ) IS
        l_ref       dct_approval_instances.source_record_ref%TYPE;
        l_link      VARCHAR2(500);
        l_step_type dct_approval_steps.step_type%TYPE;
        l_role_id   dct_approval_steps.required_role_id%TYPE;
        l_spec_user dct_approval_steps.specific_user_id%TYPE;
        l_step_name dct_approval_steps.step_name%TYPE;
    BEGIN
        SELECT i.source_record_ref,
               s.step_type, s.required_role_id, s.specific_user_id, s.step_name
        INTO   l_ref, l_step_type, l_role_id, l_spec_user, l_step_name
        FROM   dct_approval_instances i
        JOIN   dct_approval_steps s ON s.step_id = p_step_id
        WHERE  i.instance_id = p_instance_id;

        l_link := 'f?p=200:6:::NO::P6_INSTANCE_ID:' || p_instance_id;

        IF l_step_type = 'USER_SPECIFIC' THEN
            dct_notify.send(
                p_recipient_user_id => l_spec_user,
                p_notification_type => 'APPROVAL',
                p_title_en          => 'Approval Required: ' || l_step_name,
                p_body_en           => 'A request (ref: ' || l_ref || ') is awaiting your approval.',
                p_module_code       => 'APPROVAL',
                p_link_url          => l_link
            );
        ELSIF l_step_type = 'ROLE_BASED' THEN
            FOR r IN (
                SELECT DISTINCT ur.user_id
                FROM   dct_user_roles ur
                WHERE  ur.role_id   = l_role_id
                  AND  ur.is_active = 'Y'
                  AND  (ur.start_date IS NULL OR ur.start_date <= TRUNC(SYSDATE))
                  AND  (ur.end_date   IS NULL OR ur.end_date   >= TRUNC(SYSDATE))
            ) LOOP
                dct_notify.send(
                    p_recipient_user_id => r.user_id,
                    p_notification_type => 'APPROVAL',
                    p_title_en          => 'Approval Required: ' || l_step_name,
                    p_body_en           => 'A request (ref: ' || l_ref || ') is awaiting your approval.',
                    p_module_code       => 'APPROVAL',
                    p_link_url          => l_link
                );
            END LOOP;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN NULL;  -- notifications are best-effort; don't block the workflow
    END notify_step_approvers;

    -- ── SUBMIT ────────────────────────────────────────────────────────────────
    FUNCTION submit (
        p_template_code  IN VARCHAR2,
        p_module         IN VARCHAR2,
        p_record_id      IN NUMBER,
        p_ref            IN VARCHAR2 DEFAULT NULL,
        p_submitted_by   IN NUMBER   DEFAULT NULL
    ) RETURN NUMBER IS
        l_template_id  dct_approval_templates.template_id%TYPE;
        l_instance_id  dct_approval_instances.instance_id%TYPE;
        l_user_id      NUMBER := p_submitted_by;
        l_first_step   dct_approval_steps.step_id%TYPE;
    BEGIN
        IF l_user_id IS NULL THEN
            l_user_id := resolve_user_id(apex_application.g_user);
        END IF;

        SELECT template_id INTO l_template_id
        FROM   dct_approval_templates
        WHERE  template_code = p_template_code
          AND  is_active     = 'Y';

        SELECT step_id INTO l_first_step
        FROM   dct_approval_steps
        WHERE  template_id = l_template_id
          AND  step_seq    = 1;

        INSERT INTO dct_approval_instances (
            template_id, source_module, source_record_id, source_record_ref,
            current_step_seq, overall_status, submitted_by, submitted_at,
            created_by, created_at, updated_by, updated_at
        ) VALUES (
            l_template_id, p_module, p_record_id, p_ref,
            1, 'PENDING', l_user_id, SYSTIMESTAMP,
            apex_application.g_user, SYSTIMESTAMP,
            apex_application.g_user, SYSTIMESTAMP
        )
        RETURNING instance_id INTO l_instance_id;

        notify_step_approvers(l_instance_id, l_first_step);

        RETURN l_instance_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            raise_application_error(-20100,
                'Approval template not found or inactive: ' || p_template_code);
    END submit;

    -- ── APPROVE ───────────────────────────────────────────────────────────────
    PROCEDURE approve (
        p_instance_id  IN NUMBER,
        p_user_id      IN NUMBER,
        p_comments     IN VARCHAR2 DEFAULT NULL
    ) IS
        l_step_id      dct_approval_steps.step_id%TYPE;
        l_template_id  dct_approval_instances.template_id%TYPE;
        l_cur_seq      dct_approval_instances.current_step_seq%TYPE;
        l_submitter    dct_approval_instances.submitted_by%TYPE;
        l_ref          dct_approval_instances.source_record_ref%TYPE;
        l_next_seq     dct_approval_steps.step_seq%TYPE;
        l_next_step_id dct_approval_steps.step_id%TYPE;
    BEGIN
        IF NOT priv_is_approver(p_instance_id, p_user_id) THEN
            raise_application_error(-20101,
                'User is not the current approver for this instance.');
        END IF;

        SELECT s.step_id, i.template_id, i.current_step_seq,
               i.submitted_by, i.source_record_ref
        INTO   l_step_id, l_template_id, l_cur_seq, l_submitter, l_ref
        FROM   dct_approval_instances i
        JOIN   dct_approval_steps s
            ON s.template_id = i.template_id
           AND s.step_seq    = i.current_step_seq
        WHERE  i.instance_id = p_instance_id;

        INSERT INTO dct_approval_actions (
            instance_id, step_id, actioned_by, actioned_at,
            action, comments, is_escalation
        ) VALUES (
            p_instance_id, l_step_id, p_user_id, SYSTIMESTAMP,
            'APPROVED', p_comments, 'N'
        );

        -- Find next step
        BEGIN
            SELECT step_seq, step_id
            INTO   l_next_seq, l_next_step_id
            FROM   dct_approval_steps
            WHERE  template_id = l_template_id
              AND  step_seq    > l_cur_seq
            ORDER BY step_seq
            FETCH FIRST 1 ROWS ONLY;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN l_next_seq := NULL;
        END;

        IF l_next_seq IS NULL THEN
            -- All steps complete
            UPDATE dct_approval_instances
            SET    overall_status  = 'APPROVED',
                   completed_at   = SYSTIMESTAMP,
                   last_action_at = SYSTIMESTAMP,
                   updated_by     = apex_application.g_user,
                   updated_at     = SYSTIMESTAMP
            WHERE  instance_id    = p_instance_id;

            dct_notify.send(
                p_recipient_user_id => l_submitter,
                p_notification_type => 'APPROVAL',
                p_title_en          => 'Request Approved',
                p_body_en           => 'Your request (ref: ' || l_ref || ') has been fully approved.',
                p_module_code       => 'APPROVAL',
                p_link_url          => 'f?p=200:56:::NO::P56_INSTANCE_ID:' || p_instance_id
            );
        ELSE
            -- Advance to next step
            UPDATE dct_approval_instances
            SET    current_step_seq = l_next_seq,
                   last_action_at  = SYSTIMESTAMP,
                   updated_by      = apex_application.g_user,
                   updated_at      = SYSTIMESTAMP
            WHERE  instance_id     = p_instance_id;

            notify_step_approvers(p_instance_id, l_next_step_id);
        END IF;
    END approve;

    -- ── REJECT ────────────────────────────────────────────────────────────────
    PROCEDURE reject (
        p_instance_id  IN NUMBER,
        p_user_id      IN NUMBER,
        p_comments     IN VARCHAR2 DEFAULT NULL
    ) IS
        l_step_id   dct_approval_steps.step_id%TYPE;
        l_submitter dct_approval_instances.submitted_by%TYPE;
        l_ref       dct_approval_instances.source_record_ref%TYPE;
    BEGIN
        IF NOT priv_is_approver(p_instance_id, p_user_id) THEN
            raise_application_error(-20101,
                'User is not the current approver for this instance.');
        END IF;

        SELECT s.step_id, i.submitted_by, i.source_record_ref
        INTO   l_step_id, l_submitter, l_ref
        FROM   dct_approval_instances i
        JOIN   dct_approval_steps s
            ON s.template_id = i.template_id
           AND s.step_seq    = i.current_step_seq
        WHERE  i.instance_id = p_instance_id;

        INSERT INTO dct_approval_actions (
            instance_id, step_id, actioned_by, actioned_at,
            action, comments, is_escalation
        ) VALUES (
            p_instance_id, l_step_id, p_user_id, SYSTIMESTAMP,
            'REJECTED', p_comments, 'N'
        );

        UPDATE dct_approval_instances
        SET    overall_status  = 'REJECTED',
               completed_at   = SYSTIMESTAMP,
               last_action_at = SYSTIMESTAMP,
               updated_by     = apex_application.g_user,
               updated_at     = SYSTIMESTAMP
        WHERE  instance_id    = p_instance_id;

        dct_notify.send(
            p_recipient_user_id => l_submitter,
            p_notification_type => 'APPROVAL',
            p_title_en          => 'Request Rejected',
            p_body_en           => 'Your request (ref: ' || l_ref || ') has been rejected.'
                                   || CASE WHEN p_comments IS NOT NULL
                                           THEN ' Comments: ' || p_comments END,
            p_module_code       => 'APPROVAL',
            p_link_url          => 'f?p=200:56:::NO::P56_INSTANCE_ID:' || p_instance_id
        );
    END reject;

    -- ── RETURN FOR REVISION ───────────────────────────────────────────────────
    PROCEDURE return_for_revision (
        p_instance_id  IN NUMBER,
        p_user_id      IN NUMBER,
        p_comments     IN VARCHAR2 DEFAULT NULL
    ) IS
        l_step_id   dct_approval_steps.step_id%TYPE;
        l_submitter dct_approval_instances.submitted_by%TYPE;
        l_ref       dct_approval_instances.source_record_ref%TYPE;
    BEGIN
        IF NOT priv_is_approver(p_instance_id, p_user_id) THEN
            raise_application_error(-20101,
                'User is not the current approver for this instance.');
        END IF;

        SELECT s.step_id, i.submitted_by, i.source_record_ref
        INTO   l_step_id, l_submitter, l_ref
        FROM   dct_approval_instances i
        JOIN   dct_approval_steps s
            ON s.template_id = i.template_id
           AND s.step_seq    = i.current_step_seq
        WHERE  i.instance_id = p_instance_id;

        INSERT INTO dct_approval_actions (
            instance_id, step_id, actioned_by, actioned_at,
            action, comments, is_escalation
        ) VALUES (
            p_instance_id, l_step_id, p_user_id, SYSTIMESTAMP,
            'RETURNED', p_comments, 'N'
        );

        UPDATE dct_approval_instances
        SET    overall_status  = 'RETURNED',
               completed_at   = SYSTIMESTAMP,
               last_action_at = SYSTIMESTAMP,
               updated_by     = apex_application.g_user,
               updated_at     = SYSTIMESTAMP
        WHERE  instance_id    = p_instance_id;

        dct_notify.send(
            p_recipient_user_id => l_submitter,
            p_notification_type => 'APPROVAL',
            p_title_en          => 'Request Returned for Revision',
            p_body_en           => 'Your request (ref: ' || l_ref || ') has been returned for revision.'
                                   || CASE WHEN p_comments IS NOT NULL
                                           THEN ' Comments: ' || p_comments END,
            p_module_code       => 'APPROVAL',
            p_link_url          => 'f?p=200:56:::NO::P56_INSTANCE_ID:' || p_instance_id
        );
    END return_for_revision;

    -- ── CANCEL ────────────────────────────────────────────────────────────────
    PROCEDURE cancel (
        p_instance_id  IN NUMBER,
        p_user_id      IN NUMBER
    ) IS
        l_submitter  dct_approval_instances.submitted_by%TYPE;
        l_status     dct_approval_instances.overall_status%TYPE;
        l_username   dct_users.username%TYPE;
    BEGIN
        SELECT submitted_by, overall_status
        INTO   l_submitter, l_status
        FROM   dct_approval_instances
        WHERE  instance_id = p_instance_id;

        IF l_status != 'PENDING' THEN
            raise_application_error(-20102,
                'Only PENDING instances can be cancelled.');
        END IF;

        IF l_submitter != p_user_id THEN
            SELECT username INTO l_username
            FROM   dct_users
            WHERE  user_id = p_user_id;

            IF NOT dct_auth.has_role(l_username, 'SYS_ADMIN') THEN
                raise_application_error(-20103,
                    'Only the submitter or a SYS_ADMIN can cancel this request.');
            END IF;
        END IF;

        UPDATE dct_approval_instances
        SET    overall_status  = 'CANCELLED',
               completed_at   = SYSTIMESTAMP,
               last_action_at = SYSTIMESTAMP,
               updated_by     = apex_application.g_user,
               updated_at     = SYSTIMESTAMP
        WHERE  instance_id    = p_instance_id;
    END cancel;

    -- ── GET PENDING ACTIONS ───────────────────────────────────────────────────
    FUNCTION get_pending_actions (
        p_user_id  IN NUMBER
    ) RETURN SYS_REFCURSOR IS
        l_cur  SYS_REFCURSOR;
    BEGIN
        OPEN l_cur FOR
            SELECT i.instance_id,
                   i.source_module,
                   i.source_record_id,
                   i.source_record_ref,
                   t.template_name,
                   i.current_step_seq,
                   s.step_name,
                   s.step_type,
                   i.submitted_at,
                   i.last_action_at,
                   u.display_name AS submitted_by_name
            FROM   dct_approval_instances i
            JOIN   dct_approval_templates t
                ON t.template_id = i.template_id
            JOIN   dct_approval_steps s
                ON s.template_id = i.template_id
               AND s.step_seq    = i.current_step_seq
            LEFT JOIN dct_users u
                ON u.user_id = i.submitted_by
            WHERE  i.overall_status = 'PENDING'
              AND  (
                    -- ROLE_BASED: user holds the required role
                    (s.step_type = 'ROLE_BASED' AND EXISTS (
                        SELECT 1 FROM dct_user_roles ur
                        WHERE  ur.user_id = p_user_id
                          AND  ur.role_id = s.required_role_id
                          AND  ur.is_active = 'Y'
                          AND  (ur.start_date IS NULL OR ur.start_date <= TRUNC(SYSDATE))
                          AND  (ur.end_date   IS NULL OR ur.end_date   >= TRUNC(SYSDATE))
                    ))
                    OR
                    -- USER_SPECIFIC: exact user
                    (s.step_type = 'USER_SPECIFIC' AND s.specific_user_id = p_user_id)
                    OR
                    -- Active delegation covering this step
                    EXISTS (
                        SELECT 1 FROM dct_delegations d
                        WHERE  d.delegate_id = p_user_id
                          AND  d.status      = 'ACTIVE'
                          AND  TRUNC(SYSDATE) BETWEEN d.start_date AND d.end_date
                          AND  (d.scope = 'ALL_ROLES'
                                OR (d.scope = 'SPECIFIC_ROLE' AND d.role_id = s.required_role_id))
                    )
              )
            ORDER BY i.submitted_at;
        RETURN l_cur;
    END get_pending_actions;

    -- ── IS_CURRENT_APPROVER (public wrapper) ──────────────────────────────────
    FUNCTION is_current_approver (
        p_instance_id  IN NUMBER,
        p_user_id      IN NUMBER
    ) RETURN BOOLEAN IS
    BEGIN
        RETURN priv_is_approver(p_instance_id, p_user_id);
    END is_current_approver;

END dct_approval;
/

prompt ============================================================
prompt  Verifying package status
prompt ============================================================
SELECT object_name, object_type, status
FROM   all_objects
WHERE  object_name = 'DCT_APPROVAL'
  AND  owner       = 'PROD'
ORDER BY object_type;

prompt  DCT_APPROVAL package deployed.

set define on verify on feedback on
