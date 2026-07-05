-- =============================================================================
-- Freelancers Module (App 203) -- Registration Approval History + Force Approval
-- File    : 24_fl_reg_approval_history.sql
-- Schema  : registered under ADMIN. Base /ords/admin/fl/.
-- Run     : sql -name prod_mcp @24_fl_reg_approval_history.sql  (ANY session --
--           adds two NEW templates/handlers to fl.rest; creates NO synonyms and
--           does NOT rebuild the module, so it is safe to run standalone and
--           safe to re-run. Re-run after any 08_fl_ords.sql re-run, which
--           rebuilds the base module.)
-- Purpose : Two additive, registration-scoped endpoints on fl.rest:
--             GET  registrations/:id/approval-history
--                  -> the approval trail for a submitted registration: who
--                     submitted + when, every route step (approver, status,
--                     received-on, acted-on, comments), and who it is pending
--                     with now. Read-only; any authenticated FL user.
--             POST registrations/:id/force-approve   {comments}
--                  -> FL_ADMIN / SYS_ADMIN only. Drives the shared approval
--                     engine (DCT_FL_PKG.ACT_ON_APPROVAL) to completion, so every
--                     remaining step is recorded as a '[FORCE APPROVAL]' action in
--                     DCT_APPROVAL_ACTIONS (visible in the history), and the final
--                     step runs the normal callback (creates the freelancer +
--                     portal user). Only valid while the registration is SUBMITTED.
--           Only NEW templates are defined (guarded DEFINE_TEMPLATE); existing
--           handlers on fl.rest are untouched.
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

CREATE OR REPLACE PROCEDURE setup_fl_reg_apphist_tmp AS
    c_mod CONSTANT VARCHAR2(30) := 'fl.rest';

    PROCEDURE deft(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    EXCEPTION WHEN OTHERS THEN NULL;  -- template may already exist
    END;

    PROCEDURE defh(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method => p_method, p_source_type => ORDS.source_type_plsql,
            p_source => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN
    -- ===================== AUTH: registration approval history ===============
    deft('registrations/[COLON]id/approval-history');
    defh('registrations/[COLON]id/approval-history', 'GET', q'[
DECLARE
  l_user      VARCHAR2(100) := dct_rest.validate_session;
  l_inst      NUMBER;
  l_tmpl      NUMBER;
  l_cur       NUMBER;
  l_overall   VARCHAR2(30);
  l_sub_at    TIMESTAMP;
  l_sub_by    VARCHAR2(200);
  l_dyn       NUMBER;
  l_dyn_name  VARCHAR2(200);
  l_completed TIMESTAMP;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;

  BEGIN
    SELECT ai.instance_id, ai.template_id, ai.current_step_seq, ai.overall_status,
           ai.submitted_at, su.display_name, ai.dynamic_approver_user_id, ai.completed_at
      INTO l_inst, l_tmpl, l_cur, l_overall, l_sub_at, l_sub_by, l_dyn, l_completed
    FROM   prod.dct_approval_instances ai
    LEFT JOIN prod.dct_users su ON su.user_id = ai.submitted_by
    WHERE  ai.source_module = 'FL_REGISTRATION'
    AND    ai.source_record_id = [COLON]id;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    -- Not yet submitted (DRAFT/RETURNED) -> no instance -> empty history.
    dct_rest.json_header; APEX_JSON.initialize_output;
    APEX_JSON.open_object;
    APEX_JSON.write('hasInstance', FALSE);
    APEX_JSON.open_array('steps'); APEX_JSON.close_array;
    APEX_JSON.close_object;
    RETURN;
  END;

  IF l_dyn IS NOT NULL THEN
    BEGIN
      SELECT display_name INTO l_dyn_name FROM prod.dct_users WHERE user_id = l_dyn;
    EXCEPTION WHEN NO_DATA_FOUND THEN l_dyn_name := NULL; END;
  END IF;

  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('hasInstance',     TRUE);
  APEX_JSON.write('instanceId',      l_inst);
  APEX_JSON.write('overallStatus',   l_overall);
  APEX_JSON.write('submittedByName', NVL(l_sub_by, '-'));
  APEX_JSON.write('submittedAt',     TO_CHAR(dct_to_local(l_sub_at), 'YYYY-MM-DD HH:MI AM'));
  IF l_completed IS NOT NULL THEN
    APEX_JSON.write('completedAt', TO_CHAR(dct_to_local(l_completed), 'YYYY-MM-DD HH:MI AM'));
  END IF;

  APEX_JSON.open_array('steps');
  FOR s IN (
    SELECT st.step_seq, st.step_name, st.step_type,
           ro.role_name_en                       AS role_name,
           a.action, a.comments, a.actioned_at,
           ua.display_name                       AS actioned_by_name,
           ROW_NUMBER() OVER (ORDER BY st.step_seq)       AS rn,
           LAG(a.actioned_at) OVER (ORDER BY st.step_seq) AS prev_actioned_at
    FROM   prod.dct_approval_steps st
    LEFT JOIN prod.dct_roles ro ON ro.role_id = st.required_role_id
    LEFT JOIN (
        SELECT aa.step_id, aa.action, aa.comments, aa.actioned_at, aa.actioned_by,
               ROW_NUMBER() OVER (PARTITION BY aa.step_id
                                  ORDER BY aa.actioned_at DESC, aa.action_id DESC) rn
        FROM   prod.dct_approval_actions aa
        WHERE  aa.instance_id = l_inst
    ) a ON a.step_id = st.step_id AND a.rn = 1
    LEFT JOIN prod.dct_users ua ON ua.user_id = a.actioned_by
    WHERE  st.template_id = l_tmpl
    ORDER BY st.step_seq
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('seq',      s.step_seq);
    APEX_JSON.write('stepName', NVL(s.step_name, 'Step ' || s.step_seq));
    APEX_JSON.write('approver',
      CASE WHEN s.step_type = 'USER_SPECIFIC' THEN NVL(l_dyn_name, 'Line Manager')
           ELSE NVL(s.role_name, '-') END);
    APEX_JSON.write('status',
      CASE WHEN s.action IS NOT NULL                                     THEN s.action
           WHEN l_overall = 'PENDING' AND s.step_seq = l_cur             THEN 'PENDING'
           WHEN l_overall = 'PENDING' AND s.step_seq > l_cur             THEN 'WAITING'
           WHEN l_overall IN ('REJECTED','RETURNED')
                AND s.step_seq >= NVL(l_cur, 0)                          THEN 'WAITING'
           ELSE 'DONE' END);
    APEX_JSON.write('isCurrent',
      CASE WHEN l_overall = 'PENDING' AND s.step_seq = l_cur THEN 'Y' ELSE 'N' END);
    -- received-on: when this step became active (step 1 = submission; later = the
    -- previous step's action time). Only shown once the step has been reached.
    IF s.rn = 1 THEN
      APEX_JSON.write('receivedAt', TO_CHAR(dct_to_local(l_sub_at), 'YYYY-MM-DD HH:MI AM'));
    ELSIF s.prev_actioned_at IS NOT NULL THEN
      APEX_JSON.write('receivedAt', TO_CHAR(dct_to_local(s.prev_actioned_at), 'YYYY-MM-DD HH:MI AM'));
    END IF;
    IF s.actioned_by_name IS NOT NULL THEN
      APEX_JSON.write('actionedBy', s.actioned_by_name);
    END IF;
    IF s.actioned_at IS NOT NULL THEN
      APEX_JSON.write('actionedAt', TO_CHAR(dct_to_local(s.actioned_at), 'YYYY-MM-DD HH:MI AM'));
    END IF;
    IF s.comments IS NOT NULL THEN
      APEX_JSON.write('comments', s.comments);
    END IF;
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    -- ===================== AUTH: FL_ADMIN force-approve =====================
    deft('registrations/[COLON]id/force-approve');
    defh('registrations/[COLON]id/force-approve', 'POST', q'[
DECLARE
  l_user       VARCHAR2(100) := dct_rest.validate_session;
  l_uid        NUMBER;
  l_inst       NUMBER;
  l_reg_status VARCHAR2(30);
  l_overall    VARCHAR2(30);
  l_note       VARCHAR2(2000);
  l_guard      NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'FL_ADMIN')
     AND NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403, 'Only an FL Administrator can force an approval.'); RETURN;
  END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);
  l_note := '[FORCE APPROVAL] '
            || NVL(APEX_JSON.get_varchar2(p_path => 'comments'),
                   'Approved by FL Administrator (approval workflow overridden).');

  BEGIN
    SELECT approval_instance_id, status INTO l_inst, l_reg_status
    FROM   prod.dct_fl_registrations WHERE registration_id = [COLON]id;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    dct_rest.err(404, 'Registration not found.'); RETURN;
  END;

  IF l_inst IS NULL THEN
    dct_rest.err(400, 'This registration has no approval in progress to force.'); RETURN;
  END IF;
  IF l_reg_status != 'SUBMITTED' THEN
    dct_rest.err(400, 'Only a submitted registration can be force-approved (current status: '
                       || l_reg_status || ').'); RETURN;
  END IF;

  -- Drive the shared engine to completion; each remaining step is recorded as a
  -- forced action, and the final step fires the normal create-freelancer callback.
  LOOP
    SELECT overall_status INTO l_overall
    FROM   prod.dct_approval_instances WHERE instance_id = l_inst;
    EXIT WHEN l_overall != 'PENDING';
    dct_fl_pkg.act_on_approval(l_inst, l_uid, 'APPROVED', l_note);
    l_guard := l_guard + 1;
    EXIT WHEN l_guard > 25;   -- safety valve; FL routes are <= a few steps
  END LOOP;

  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.write('overallStatus', l_overall);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  dct_rest.err(CASE SQLCODE WHEN -20401 THEN 401 WHEN -20403 THEN 403
    WHEN -20404 THEN 404 WHEN -20001 THEN 400 ELSE 500 END, SQLERRM);
END;
]');

END setup_fl_reg_apphist_tmp;
/

BEGIN
    setup_fl_reg_apphist_tmp;
    COMMIT;
END;
/

DROP PROCEDURE setup_fl_reg_apphist_tmp;

PROMPT === 24_fl_reg_approval_history.sql complete ===
