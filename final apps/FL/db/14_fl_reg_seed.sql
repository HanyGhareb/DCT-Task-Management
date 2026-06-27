-- =============================================================================
-- Freelancers Module (App 203) -- Phase 1 -- Registration approval step seed
-- File    : 14_fl_reg_seed.sql
-- Schema  : PROD
-- Run     : After 13_fl_reg_pkg.sql. Idempotent (MERGE). Own SQLcl session.
-- Purpose : Prepend a USER_SPECIFIC "Line Manager Endorsement" step (seq 5) to
--           FL_REGISTRATION_APPROVAL so the named line manager is the FIRST
--           approver, ahead of the configurable FL_MANAGER -> FL_ADMIN steps.
--           specific_user_id stays NULL: the approver is resolved per-instance
--           from dct_approval_instances.dynamic_approver_user_id (set by
--           DCT_FL_PKG.submit_registration). The chain remains fully editable in
--           the Admin Approval-Templates page.
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON

DECLARE
    v_tmpl_id NUMBER;
BEGIN
    SELECT template_id INTO v_tmpl_id
    FROM   prod.dct_approval_templates
    WHERE  template_code = 'FL_REGISTRATION_APPROVAL';

    MERGE INTO prod.dct_approval_steps s
    USING (SELECT v_tmpl_id AS template_id, 5 AS step_seq FROM dual) src
    ON    (s.template_id = src.template_id AND s.step_seq = src.step_seq)
    WHEN NOT MATCHED THEN
        INSERT (template_id, step_seq, step_name, step_name_ar, step_type,
                required_role_id, specific_user_id, escalation_days,
                is_mandatory, allow_skip, condition_type)
        VALUES (v_tmpl_id, 5, 'Line Manager Endorsement', 'Ø§Ø¹ØªÙ…Ø§Ø¯ Ø§Ù„Ù…Ø¯ÙŠØ± Ø§Ù„Ù…Ø¨Ø§Ø´Ø±',
                'USER_SPECIFIC', NULL, NULL, 3, 'Y', 'N', 'ALWAYS')
    WHEN MATCHED THEN
        UPDATE SET step_name    = 'Line Manager Endorsement',
                   step_name_ar = 'Ø§Ø¹ØªÙ…Ø§Ø¯ Ø§Ù„Ù…Ø¯ÙŠØ± Ø§Ù„Ù…Ø¨Ø§Ø´Ø±',
                   step_type    = 'USER_SPECIFIC',
                   required_role_id = NULL,
                   condition_type   = 'ALWAYS',
                   is_mandatory = 'Y', allow_skip = 'N';

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('FL_REGISTRATION_APPROVAL: line-manager step (seq 5) merged.');
END;
/

PROMPT === 14_fl_reg_seed.sql complete ===
