-- =============================================================================
-- DCT Admin ORDS -- surgical patch: per-step NAMED approvers (FL Contract
-- Phase 2). The personal inbox routes a USER_SPECIFIC step to the user stamped
-- in DCT_FL_INSTANCE_APPROVERS for that instance+step (line manager, scoped
-- Finance Business Partner); the step role's holders see it ONLY when no
-- stamped row exists (fail-open), and the legacy instance-level dynamic
-- approver clause is likewise scoped to unstamped steps so the line manager
-- no longer matches every USER_SPECIFIC step of the chain. The action POST
-- maps -20147 (named-approver guard) to 403 and the -20160..-20131
-- validation band to 400.
-- File   : 11c_dct_inbox_step_approvers.sql
-- Schema : ADMIN (ORDS metadata). Own SQLcl session. Re-definable/idempotent.
-- Run    : AFTER FL/db/25 (table) -- creates the ADMIN synonym itself.
-- Note   : canonical source 11_dct_ords.sql patched in the same change; re-run
--          this file after any 11 re-run (11 rebuilds dct.admin handlers).
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON

CREATE OR REPLACE SYNONYM dct_fl_instance_approvers FOR prod.dct_fl_instance_approvers;

CREATE OR REPLACE SYNONYM dct_fl_approver_map FOR prod.dct_fl_approver_map;

BEGIN
    ORDS.DEFINE_HANDLER(
        p_module_name => 'dct.admin',
        p_pattern     => 'approvals/pending',
        p_method      => 'GET',
        p_source_type => ORDS.source_type_plsql,
        p_source      => REPLACE(q'[
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_uid   NUMBER;
  l_roles VARCHAR2(4000);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid   := dct_auth.get_user_id(l_user);
  l_roles := ',' || dct_auth.get_user_roles(l_user) || ',';
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT ai.instance_id, ai.source_module, ai.source_record_ref,
           ai.submitted_at, t.template_name,
           ast.step_name, sub.display_name AS submitted_by_name,
           (SELECT COUNT(*) FROM dct_approval_steps s2 WHERE s2.template_id = ai.template_id) AS total_steps,
           (SELECT COUNT(*) FROM dct_approval_steps s3 WHERE s3.template_id = ai.template_id
             AND s3.step_seq <= ai.current_step_seq) AS current_step,
           NVL(CASE ai.source_module
             WHEN 'PETTY_CASH'     THEN (SELECT amount       FROM dct_petty_cash       WHERE pc_id        = ai.source_record_id)
             WHEN 'REIMBURSEMENT'  THEN (SELECT amount       FROM dct_pc_reimbursements WHERE reimb_id    = ai.source_record_id)
             WHEN 'CLEARING'       THEN (SELECT amount_spent FROM dct_pc_clearing       WHERE clearing_id = ai.source_record_id)
             WHEN 'TRAVEL_REQUEST' THEN (SELECT total_advance_aed FROM dt_requests      WHERE request_id  = ai.source_record_id)
             WHEN 'SETTLEMENT'     THEN (SELECT total_actual_aed  FROM dt_settlement    WHERE settlement_id = ai.source_record_id)
             WHEN 'FL_CONTRACT'       THEN (SELECT total_amount     FROM dct_fl_contracts           WHERE contract_id      = ai.source_record_id)
             WHEN 'FL_AMENDMENT'      THEN (SELECT new_total_amount FROM dct_fl_contract_amendments WHERE amendment_id     = ai.source_record_id)
             WHEN 'FL_VOUCHER'        THEN (SELECT amount           FROM dct_fl_payment_vouchers    WHERE voucher_id       = ai.source_record_id)
             WHEN 'FL_RENEWAL'        THEN (SELECT new_total_amount FROM dct_fl_contract_renewals   WHERE renewal_id       = ai.source_record_id)
             WHEN 'CC_REQUEST'        THEN (SELECT requested_limit  FROM dct_cc_requests            WHERE request_id       = ai.source_record_id)
             WHEN 'CC_REPLENISHMENT'  THEN (SELECT total_amount     FROM dct_cc_replenishments      WHERE replenishment_id = ai.source_record_id)
           END, 0) AS amount,
           CASE WHEN INSTR(l_roles, ',' || rol.role_code || ',') > 0
                  OR INSTR(l_roles, ',SYS_ADMIN,') > 0
                THEN NULL
                ELSE (SELECT MAX(du.display_name)
                      FROM dct_delegations dg
                      JOIN dct_user_roles ur2 ON ur2.user_id = dg.delegator_id
                                             AND ur2.role_id = rol.role_id AND ur2.is_active = 'Y'
                      JOIN dct_users du ON du.user_id = dg.delegator_id
                      WHERE dg.delegate_id = l_uid AND dg.status = 'ACTIVE'
                        AND TRUNC(SYSDATE) BETWEEN dg.start_date AND dg.end_date
                        AND (dg.scope = 'ALL_ROLES'
                             OR (dg.scope = 'SPECIFIC_ROLE' AND dg.role_id = rol.role_id)
                             OR (dg.scope = 'MODULE' AND dg.module_id = t.module_id)))
           END AS acting_for
    FROM   dct_approval_instances ai
    JOIN   dct_approval_templates t   ON t.template_id  = ai.template_id
    JOIN   dct_approval_steps     ast ON ast.template_id = ai.template_id
                                     AND ast.step_seq    = ai.current_step_seq
    LEFT JOIN dct_roles           rol ON rol.role_id     = ast.required_role_id
    JOIN   dct_users              sub ON sub.user_id     = ai.submitted_by
    WHERE  ai.overall_status = 'PENDING'
      AND ((INSTR(l_roles, ',' || rol.role_code || ',') > 0
            AND (ast.step_type != 'USER_SPECIFIC'
                 OR NOT EXISTS (SELECT 1 FROM dct_fl_instance_approvers fx
                                WHERE fx.instance_id = ai.instance_id
                                  AND fx.step_seq    = ai.current_step_seq)))
           OR INSTR(l_roles, ',SYS_ADMIN,') > 0
           OR (ast.step_type = 'USER_SPECIFIC' AND ai.dynamic_approver_user_id = l_uid
               AND NOT EXISTS (SELECT 1 FROM dct_fl_instance_approvers fx2
                               WHERE fx2.instance_id = ai.instance_id
                                 AND fx2.step_seq    = ai.current_step_seq))
           OR (ast.step_type = 'USER_SPECIFIC' AND EXISTS (
                 SELECT 1 FROM dct_fl_instance_approvers fia
                 WHERE fia.instance_id = ai.instance_id
                   AND fia.step_seq    = ai.current_step_seq
                   AND fia.user_id     = l_uid))
           OR EXISTS (
                SELECT 1 FROM dct_delegations dg
                JOIN dct_user_roles ur2 ON ur2.user_id = dg.delegator_id
                                       AND ur2.role_id = rol.role_id AND ur2.is_active = 'Y'
                WHERE dg.delegate_id = l_uid AND dg.status = 'ACTIVE'
                  AND TRUNC(SYSDATE) BETWEEN dg.start_date AND dg.end_date
                  AND (dg.scope = 'ALL_ROLES'
                       OR (dg.scope = 'SPECIFIC_ROLE' AND dg.role_id = rol.role_id)
                       OR (dg.scope = 'MODULE' AND dg.module_id = t.module_id))))
    ORDER BY ai.submitted_at
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('instanceId',      r.instance_id);
    APEX_JSON.write('requestRef',      NVL(r.source_record_ref, '-'));
    APEX_JSON.write('module',          r.source_module);
    APEX_JSON.write('templateName',    NVL(r.template_name, '-'));
    APEX_JSON.write('requestedBy',     NVL(r.submitted_by_name, '-'));
    APEX_JSON.write('requestedAt',     TO_CHAR( dct_to_local(r.submitted_at),'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.write('amount',          r.amount);
    APEX_JSON.write('currentStep',     NVL(r.current_step, 1));
    APEX_JSON.write('totalSteps',      NVL(r.total_steps, 1));
    APEX_JSON.write('currentStepName', NVL(r.step_name, '-'));
    APEX_JSON.write('actingFor',       r.acting_for);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]', '[COLON]', CHR(58))
    );
    ORDS.DEFINE_HANDLER(
        p_module_name => 'dct.admin',
        p_pattern     => REPLACE('approvals/[COLON]id/action', '[COLON]', CHR(58)),
        p_method      => 'POST',
        p_source_type => ORDS.source_type_plsql,
        p_source      => REPLACE(q'[
DECLARE
  l_user     VARCHAR2(100) := dct_rest.validate_session;
  l_iid      NUMBER        := [COLON]id;
  l_uid      NUMBER;
  l_action   VARCHAR2(20);
  l_comments VARCHAR2(4000);
  l_inst     dct_approval_instances%ROWTYPE;
  l_step_id  NUMBER;
  l_amount   NUMBER := 0;
  l_next     NUMBER := NULL;
  l_owner    NUMBER := NULL;

  PROCEDURE hist(p_type VARCHAR2, p_old VARCHAR2, p_new VARCHAR2, p_cmt VARCHAR2) IS
  BEGIN
    INSERT INTO dct_request_status_history (
      source_module, source_type, source_id, old_status, new_status, changed_by, comments)
    VALUES (CASE WHEN l_inst.source_module IN ('TRAVEL_REQUEST','SETTLEMENT') THEN 'DT' ELSE 'PC' END,
            p_type, l_inst.source_record_id, p_old, p_new, l_uid, p_cmt);
  EXCEPTION WHEN OTHERS THEN NULL;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);
  l_action   := UPPER(APEX_JSON.get_varchar2(p_path => 'action'));
  l_comments := APEX_JSON.get_varchar2(p_path => 'comments');

  IF l_action NOT IN ('APPROVED','REJECTED','RETURNED') THEN
    dct_rest.err(400,'Invalid action. Use APPROVED, REJECTED, or RETURNED'); RETURN;
  END IF;
  IF l_comments IS NULL THEN dct_rest.err(400,'Comments are required'); RETURN; END IF;

  SELECT * INTO l_inst FROM dct_approval_instances WHERE instance_id = l_iid;
  IF l_inst.overall_status != 'PENDING' THEN
    dct_rest.err(400,'Approval instance is not PENDING'); RETURN;
  END IF;

  -- FL and CC instances are acted on by their packages (step conditions,
  -- final-approval callbacks, notifications and history live there)
  IF l_inst.source_module LIKE 'FL_%' THEN
    dct_fl_pkg.act_on_approval(l_iid, l_uid, l_action, l_comments);
    dct_rest.json_header;
    APEX_JSON.initialize_output;
    APEX_JSON.open_object;
    APEX_JSON.write('ok', TRUE); APEX_JSON.write('action', l_action);
    APEX_JSON.close_object;
    RETURN;
  ELSIF l_inst.source_module LIKE 'CC_%' THEN
    dct_cc_pkg.act_on_approval(l_iid, l_uid, l_action, l_comments);
    dct_rest.json_header;
    APEX_JSON.initialize_output;
    APEX_JSON.open_object;
    APEX_JSON.write('ok', TRUE); APEX_JSON.write('action', l_action);
    APEX_JSON.close_object;
    RETURN;
  END IF;

  SELECT step_id INTO l_step_id
  FROM dct_approval_steps
  WHERE template_id = l_inst.template_id AND step_seq = l_inst.current_step_seq;

  INSERT INTO dct_approval_actions (instance_id, step_id, actioned_by, action, comments)
  VALUES (l_iid, l_step_id, l_uid, l_action, l_comments);

  -- requester (for notification)
  BEGIN
    SELECT submitted_by INTO l_owner FROM dct_approval_instances WHERE instance_id = l_iid;
  EXCEPTION WHEN OTHERS THEN NULL;
  END;

  IF l_action = 'APPROVED' THEN
    BEGIN
      IF    l_inst.source_module = 'PETTY_CASH'     THEN SELECT amount       INTO l_amount FROM dct_petty_cash        WHERE pc_id         = l_inst.source_record_id;
      ELSIF l_inst.source_module = 'REIMBURSEMENT'  THEN SELECT amount       INTO l_amount FROM dct_pc_reimbursements WHERE reimb_id      = l_inst.source_record_id;
      ELSIF l_inst.source_module = 'CLEARING'       THEN SELECT amount_spent INTO l_amount FROM dct_pc_clearing       WHERE clearing_id   = l_inst.source_record_id;
      ELSIF l_inst.source_module = 'TRAVEL_REQUEST' THEN SELECT total_advance_aed INTO l_amount FROM dt_requests      WHERE request_id    = l_inst.source_record_id;
      ELSIF l_inst.source_module = 'SETTLEMENT'     THEN SELECT total_actual_aed  INTO l_amount FROM dt_settlement    WHERE settlement_id = l_inst.source_record_id;
      END IF;
    EXCEPTION WHEN OTHERS THEN l_amount := 0; END;

    FOR nxt IN (
      SELECT step_seq FROM dct_approval_steps
      WHERE template_id    = l_inst.template_id
        AND step_seq       > l_inst.current_step_seq
        AND (condition_type = 'ALWAYS'
             OR (condition_type = 'AMOUNT' AND amount_operator = '>='  AND l_amount >= amount_threshold)
             OR (condition_type = 'AMOUNT' AND amount_operator = '>'   AND l_amount >  amount_threshold)
             OR (condition_type = 'AMOUNT' AND amount_operator = '<='  AND l_amount <= amount_threshold)
             OR (condition_type = 'AMOUNT' AND amount_operator = '<'   AND l_amount <  amount_threshold))
      ORDER BY step_seq FETCH FIRST 1 ROW ONLY
    ) LOOP
      l_next := nxt.step_seq;
    END LOOP;

    IF l_next IS NOT NULL THEN
      UPDATE dct_approval_instances SET
        current_step_seq = l_next, last_action_at = SYSTIMESTAMP,
        updated_by = l_user, updated_at = SYSTIMESTAMP
      WHERE instance_id = l_iid;
      IF l_inst.source_module = 'PETTY_CASH' THEN
        UPDATE dct_petty_cash SET status = 'PENDING_APPROVAL', updated_by = l_user
        WHERE pc_id = l_inst.source_record_id AND status = 'SUBMITTED';
        hist('PC','SUBMITTED','PENDING_APPROVAL','Step approved (Admin inbox): ' || l_comments);
      ELSIF l_inst.source_module = 'REIMBURSEMENT' THEN
        UPDATE dct_pc_reimbursements SET status = 'PENDING_APPROVAL', updated_by = l_user
        WHERE reimb_id = l_inst.source_record_id AND status = 'SUBMITTED';
      ELSIF l_inst.source_module = 'CLEARING' THEN
        UPDATE dct_pc_clearing SET status = 'PENDING_APPROVAL', updated_by = l_user
        WHERE clearing_id = l_inst.source_record_id AND status = 'SUBMITTED';
      END IF;
    ELSE
      UPDATE dct_approval_instances SET
        overall_status = 'APPROVED', current_step_seq = NULL,
        completed_at = SYSTIMESTAMP, last_action_at = SYSTIMESTAMP,
        updated_by = l_user, updated_at = SYSTIMESTAMP
      WHERE instance_id = l_iid;

      IF l_inst.source_module = 'PETTY_CASH' THEN
        -- stays PENDING_APPROVAL until Finance disburses (-> ACTIVE)
        UPDATE dct_petty_cash SET status = 'PENDING_APPROVAL', updated_by = l_user
        WHERE pc_id = l_inst.source_record_id;
        hist('PC', NULL, 'PENDING_APPROVAL', 'Fully approved - awaiting disbursement: ' || l_comments);
      ELSIF l_inst.source_module = 'REIMBURSEMENT' THEN
        UPDATE dct_pc_reimbursements SET status = 'APPROVED', updated_by = l_user
        WHERE reimb_id = l_inst.source_record_id;
        hist('PC_REIMB', NULL, 'APPROVED', 'Final approval: ' || l_comments);
      ELSIF l_inst.source_module = 'CLEARING' THEN
        UPDATE dct_pc_clearing SET status = 'APPROVED', updated_by = l_user
        WHERE clearing_id = l_inst.source_record_id;
        hist('PC_CLEAR', NULL, 'APPROVED', 'Final approval: ' || l_comments);
        DECLARE
          l_pcid NUMBER;
        BEGIN
          SELECT pc_id INTO l_pcid FROM dct_pc_clearing WHERE clearing_id = l_inst.source_record_id;
          UPDATE dct_petty_cash SET status = 'CLOSED', closed_date = SYSDATE, updated_by = l_user
          WHERE pc_id = l_pcid;
          INSERT INTO dct_request_status_history (
            source_module, source_type, source_id, old_status, new_status, changed_by, comments)
          VALUES ('PC','PC', l_pcid, NULL, 'CLOSED', l_uid,
                  'Closed by approved clearing ' || l_inst.source_record_ref);
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
      ELSIF l_inst.source_module = 'TRAVEL_REQUEST' THEN
        UPDATE dt_requests SET status = 'APPROVED', updated_by = l_user, updated_at = SYSTIMESTAMP
        WHERE request_id = l_inst.source_record_id;
      ELSIF l_inst.source_module = 'SETTLEMENT' THEN
        UPDATE dt_settlement SET status = 'APPROVED', updated_by = l_user, updated_at = SYSTIMESTAMP
        WHERE settlement_id = l_inst.source_record_id;
      END IF;

      BEGIN
        dct_notify.send(l_owner, 'STATUS_UPDATE', 'Request Approved',
          'Your request ' || l_inst.source_record_ref || ' has been fully approved.',
          p_module_code => CASE WHEN l_inst.source_module IN ('TRAVEL_REQUEST','SETTLEMENT')
                                THEN 'DUTY_TRAVEL' ELSE 'PETTY_CASH' END);
      EXCEPTION WHEN OTHERS THEN NULL; END;
    END IF;

  ELSE
    -- REJECTED or RETURNED
    UPDATE dct_approval_instances SET
      overall_status = l_action, current_step_seq = NULL,
      completed_at = SYSTIMESTAMP, last_action_at = SYSTIMESTAMP,
      updated_by = l_user, updated_at = SYSTIMESTAMP
    WHERE instance_id = l_iid;

    IF l_inst.source_module = 'PETTY_CASH' THEN
      UPDATE dct_petty_cash SET status = l_action, updated_by = l_user
      WHERE pc_id = l_inst.source_record_id;
      hist('PC', NULL, l_action, l_action || ' (Admin inbox): ' || l_comments);
    ELSIF l_inst.source_module = 'REIMBURSEMENT' THEN
      UPDATE dct_pc_reimbursements SET status = l_action, updated_by = l_user
      WHERE reimb_id = l_inst.source_record_id;
      hist('PC_REIMB', NULL, l_action, l_action || ': ' || l_comments);
    ELSIF l_inst.source_module = 'CLEARING' THEN
      UPDATE dct_pc_clearing SET status = l_action, updated_by = l_user
      WHERE clearing_id = l_inst.source_record_id;
      hist('PC_CLEAR', NULL, l_action, l_action || ': ' || l_comments);
    ELSIF l_inst.source_module = 'TRAVEL_REQUEST' THEN
      UPDATE dt_requests SET status = l_action, updated_by = l_user, updated_at = SYSTIMESTAMP
      WHERE request_id = l_inst.source_record_id;
    ELSIF l_inst.source_module = 'SETTLEMENT' THEN
      UPDATE dt_settlement SET status = l_action, updated_by = l_user, updated_at = SYSTIMESTAMP
      WHERE settlement_id = l_inst.source_record_id;
    END IF;

    BEGIN
      dct_notify.send(l_owner, 'STATUS_UPDATE', 'Request ' || INITCAP(l_action),
        'Your request ' || l_inst.source_record_ref || ' was ' || LOWER(l_action) || ': ' || l_comments,
        p_module_code => CASE WHEN l_inst.source_module IN ('TRAVEL_REQUEST','SETTLEMENT')
                              THEN 'DUTY_TRAVEL' ELSE 'PETTY_CASH' END);
    EXCEPTION WHEN OTHERS THEN NULL; END;
  END IF;

  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.write('action', l_action);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE = -20147 THEN dct_rest.err(403, SQLERRM);
  ELSIF SQLCODE IN (-20001, -20090) OR SQLCODE BETWEEN -20160 AND -20131 THEN dct_rest.err(400, SQLERRM);
  ELSE dct_rest.err(500, SQLERRM);
  END IF;
END;
]', '[COLON]', CHR(58))
    );
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('approvals/pending + approvals/:id/action re-defined (per-step named approvers).');
END;
/

PROMPT === 11c_dct_inbox_step_approvers.sql complete ===
