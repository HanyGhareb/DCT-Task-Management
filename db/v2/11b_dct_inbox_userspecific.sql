-- =============================================================================
-- DCT Admin ORDS -- surgical patch: personal approvals inbox surfaces
-- USER_SPECIFIC steps to their per-instance dynamic approver (FL line manager).
-- File   : 11b_dct_inbox_userspecific.sql
-- Schema : ADMIN (ORDS metadata). Own SQLcl session. Re-definable / idempotent.
-- Note   : The canonical source of this handler is 11_dct_ords.sql
--          (approvals/pending GET) -- this patch keeps the live handler in sync
--          without rebuilding the whole dct.admin module. Change = LEFT JOIN
--          dct_roles + OR (step_type='USER_SPECIFIC' AND dynamic_approver=me).
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON

BEGIN
    ORDS.DEFINE_HANDLER(
        p_module_name => 'dct.admin',
        p_pattern     => 'approvals/pending',
        p_method      => 'GET',
        p_source_type => ORDS.source_type_plsql,
        p_source      => q'[
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
      AND (INSTR(l_roles, ',' || rol.role_code || ',') > 0
           OR INSTR(l_roles, ',SYS_ADMIN,') > 0
           OR (ast.step_type = 'USER_SPECIFIC' AND ai.dynamic_approver_user_id = l_uid)
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
]'
    );
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('approvals/pending GET handler re-defined (USER_SPECIFIC dynamic approver).');
END;
/

PROMPT === 11b_dct_inbox_userspecific.sql complete ===
