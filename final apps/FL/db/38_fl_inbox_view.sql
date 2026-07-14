SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON

-- =============================================================================
-- 38_fl_inbox_view.sql
-- FL: serve the approvals inbox from the SHARED worklist view.
-- Schema : ADMIN (ORDS metadata). Own SQLcl session.
-- Run    : AFTER db/v2/64 (views), db/v2/65 (compat) and db/v2/66 (synonyms).
--
-- FIXES A LIVE BUG. FL's own /fl/approvals/pending inner-joined dct_roles on
-- ast.required_role_id, so any USER_SPECIFIC step with a NULL role -- which is
-- exactly the line-manager step and the scoped Finance-Business-Partner step of
-- the 7-step contract chain -- was silently DROPPED from the FL app's inbox. It
-- also carried no named-approver clause at all. FL line managers and named
-- approvers could therefore only find their own tasks in the ADMIN app.
--
-- Both handlers now read PROD.DCT_WF_INBOX_V, the same view the Admin inbox
-- reads, so the eligibility rules are defined ONCE for the whole platform.
--
-- ADDITIVE -- DEFINE_HANDLER only, no DEFINE_TEMPLATE (which would drop the
-- template's other handlers). The same facade text is already patched into
-- 08_fl_ords.sql, so a re-run of 08 reproduces this rather than reverting it.
-- =============================================================================

PROMPT === FL: approvals inbox -> DCT_WF_INBOX_V ===

BEGIN
    ORDS.DEFINE_HANDLER(
        p_module_name => 'fl.rest',
        p_pattern     => 'approvals/pending',
        p_method      => 'GET',
        p_source_type => ORDS.source_type_plsql,
        p_source      => REPLACE(q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT id, engine, request_ref, source_module, template_name, requested_by,
           submitted_at, amount, current_step, total_steps, current_step_name,
           acting_for, due_at, outcome_set_code
    FROM   dct_wf_inbox_v
    WHERE  user_id = l_uid
      AND  source_module IN ('FL_REGISTRATION','FL_CONTRACT','FL_AMENDMENT',
                             'FL_VOUCHER','FL_RENEWAL','FL_PROFILE_CHANGE')
    ORDER BY submitted_at
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('instanceId',      r.id);
    APEX_JSON.write('requestRef',      r.request_ref);
    APEX_JSON.write('module',          r.source_module);
    APEX_JSON.write('templateName',    r.template_name);
    APEX_JSON.write('requestedBy',     r.requested_by);
    APEX_JSON.write('requestedAt',     TO_CHAR(dct_to_local(r.submitted_at),'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.write('amount',          r.amount);
    APEX_JSON.write('currentStep',     r.current_step);
    APEX_JSON.write('totalSteps',      r.total_steps);
    APEX_JSON.write('currentStepName', r.current_step_name);
    APEX_JSON.write('actingFor',       r.acting_for);
    APEX_JSON.write('engine',          r.engine);
    IF r.due_at IS NOT NULL THEN
      APEX_JSON.write('dueAt', TO_CHAR(dct_to_local(r.due_at),'YYYY-MM-DD HH:MI AM'));
    END IF;
    IF r.outcome_set_code IS NOT NULL THEN
      APEX_JSON.open_array('outcomes');
      FOR o IN (SELECT o.outcome_code, o.label_en, o.label_ar, o.semantic,
                       o.is_positive, o.requires_comment, o.color
                FROM   dct_wf_outcome o
                JOIN   dct_wf_outcome_set s ON s.set_id = o.set_id
                WHERE  s.set_code = r.outcome_set_code
                ORDER BY o.display_order) LOOP
        APEX_JSON.open_object;
        APEX_JSON.write('code',            o.outcome_code);
        APEX_JSON.write('labelEn',         o.label_en);
        APEX_JSON.write('labelAr',         o.label_ar);
        APEX_JSON.write('semantic',        o.semantic);
        APEX_JSON.write('isPositive',      o.is_positive);
        APEX_JSON.write('requiresComment', o.requires_comment);
        APEX_JSON.write('color',           o.color);
        APEX_JSON.close_object;
      END LOOP;
      APEX_JSON.close_array;
    END IF;
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]', '[COLON]', CHR(58))
    );

    ORDS.DEFINE_HANDLER(
        p_module_name => 'fl.rest',
        p_pattern     => REPLACE('approvals/[COLON]id/action', '[COLON]', CHR(58)),
        p_method      => 'POST',
        p_source_type => ORDS.source_type_plsql,
        p_source      => REPLACE(q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER        := [COLON]id;
  l_uid  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);

  IF l_id >= 900000000 THEN
    dct_wf_engine.complete_task(l_id, l_uid,
      UPPER(APEX_JSON.get_varchar2(p_path => 'action')),
      APEX_JSON.get_varchar2(p_path => 'comments'));
  ELSE
    dct_fl_pkg.act_on_approval(
      p_instance_id => l_id,
      p_user_id     => l_uid,
      p_action      => APEX_JSON.get_varchar2(p_path => 'action'),
      p_comments    => APEX_JSON.get_varchar2(p_path => 'comments'));
  END IF;

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE IN (-20147, -20303) THEN dct_rest.err(403, SQLERRM);
  ELSIF SQLCODE IN (-20001, -20090, -20304, -20305, -20307, -20308, -20309)
     OR SQLCODE BETWEEN -20160 AND -20131 THEN dct_rest.err(400, SQLERRM);
  ELSE dct_rest.err(500, SQLERRM);
  END IF;
END;
]', '[COLON]', CHR(58))
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('fl.rest approvals now read the shared inbox view.');
    DBMS_OUTPUT.PUT_LINE('FL line managers / named approvers can now see their own tasks in FL.');
END;
/

PROMPT === 38_fl_inbox_view.sql complete ===
