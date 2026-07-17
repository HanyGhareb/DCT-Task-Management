-- 69_dct_wf_designer_api.sql
-- DWP process designer write API. Adds paths to wf.rest.
-- Order  run 67, then 68, then this. Re-run this whenever 67 is re-run.
-- Use a fresh SQLcl connection (this file makes synonyms).
-- Keep each path in its own small block on purpose (this SQLcl truncates one
-- oversized block, and a keyword-heavy banner confuses its parser).
SET DEFINE OFF
SET SQLBLANKLINES ON

CREATE OR REPLACE SYNONYM dct_wf_designer FOR prod.dct_wf_designer;
CREATE OR REPLACE SYNONYM dct_roles       FOR prod.dct_roles;

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>REPLACE('versions/[COLON]id/design','[COLON]',CHR(58)));
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>REPLACE('versions/[COLON]id/design','[COLON]',CHR(58)),
    p_method=>'GET', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_wf_designer.can_edit_version(l_user, [COLON]id) <> 'Y' THEN
    dct_rest.err(403,'WF_ADMIN required'); RETURN;
  END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  FOR v IN (SELECT pv.version_id, pv.version_no, pv.status, pv.notes,
                   p.process_code, p.source_module, p.name_en, p.name_ar, p.schema_id
              FROM dct_wf_process_version pv JOIN dct_wf_process p ON p.process_id = pv.process_id
             WHERE pv.version_id = [COLON]id) LOOP
    APEX_JSON.write('versionId', v.version_id);
    APEX_JSON.write('versionNo', v.version_no);
    APEX_JSON.write('status', v.status);
    APEX_JSON.write('editable', CASE WHEN v.status = 'DRAFT' THEN 'Y' ELSE 'N' END);
    APEX_JSON.write('processCode', v.process_code);
    APEX_JSON.write('sourceModule', v.source_module);
    APEX_JSON.write('processNameEn', v.name_en);
    APEX_JSON.write('processNameAr', v.name_ar);
    APEX_JSON.write('schemaId', v.schema_id);
  END LOOP;
  APEX_JSON.open_array('steps');
  FOR s IN (SELECT s.step_id, s.step_key, s.step_seq, s.name_en, s.name_ar, s.step_kind,
                   s.parallel_group, s.quorum_type, s.quorum_n, s.veto_on_reject,
                   s.sla_hours, s.sla_calendar, s.reminder_offsets, s.escalate_after_hours,
                   s.auto_action_outcome, s.auto_action_after_hours, s.allow_claim, s.allow_delegate,
                   s.allow_request_info, s.allow_reassign, s.allow_attachment, s.comment_required,
                   s.system_action_code, s.is_final_gate, s.display_order,
                   os.set_code AS outcome_set_code, c.condition_key, er.role_code AS esc_role_code
              FROM dct_wf_step s
              LEFT JOIN dct_wf_outcome_set os ON os.set_id = s.outcome_set_id
              LEFT JOIN dct_wf_condition   c  ON c.condition_id = s.condition_id
              LEFT JOIN dct_roles          er ON er.role_id = s.escalate_role_id
             WHERE s.version_id = [COLON]id ORDER BY s.step_seq) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('stepId', s.step_id);
    APEX_JSON.write('stepKey', s.step_key);
    APEX_JSON.write('stepSeq', s.step_seq);
    APEX_JSON.write('nameEn', s.name_en);
    APEX_JSON.write('nameAr', s.name_ar);
    APEX_JSON.write('stepKind', s.step_kind);
    APEX_JSON.write('parallelGroup', s.parallel_group);
    APEX_JSON.write('quorumType', s.quorum_type);
    APEX_JSON.write('quorumN', s.quorum_n);
    APEX_JSON.write('vetoOnReject', s.veto_on_reject);
    APEX_JSON.write('conditionKey', s.condition_key);
    APEX_JSON.write('outcomeSetCode', s.outcome_set_code);
    APEX_JSON.write('slaHours', s.sla_hours);
    APEX_JSON.write('slaCalendar', s.sla_calendar);
    APEX_JSON.write('reminderOffsets', s.reminder_offsets);
    APEX_JSON.write('escalateRoleCode', s.esc_role_code);
    APEX_JSON.write('escalateAfterHours', s.escalate_after_hours);
    APEX_JSON.write('autoActionOutcome', s.auto_action_outcome);
    APEX_JSON.write('autoActionAfterHours', s.auto_action_after_hours);
    APEX_JSON.write('allowClaim', s.allow_claim);
    APEX_JSON.write('allowDelegate', s.allow_delegate);
    APEX_JSON.write('allowRequestInfo', s.allow_request_info);
    APEX_JSON.write('allowReassign', s.allow_reassign);
    APEX_JSON.write('allowAttachment', s.allow_attachment);
    APEX_JSON.write('commentRequired', s.comment_required);
    APEX_JSON.write('systemActionCode', s.system_action_code);
    APEX_JSON.write('isFinalGate', s.is_final_gate);
    APEX_JSON.write('displayOrder', s.display_order);
    APEX_JSON.open_array('participants');
    FOR r IN (SELECT rule_id, rule_seq, participant_type, resolver_type, role_code, org_scope,
                     org_fact_path, static_org_id, static_user_id, fact_path, ref_step_key,
                     levels_up, resolution_mode, fallback_rule, min_resolved, include_delegates,
                     exclude_initiator
                FROM dct_wf_participant_rule WHERE step_id = s.step_id ORDER BY rule_seq) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('ruleId', r.rule_id);
      APEX_JSON.write('ruleSeq', r.rule_seq);
      APEX_JSON.write('participantType', r.participant_type);
      APEX_JSON.write('resolverType', r.resolver_type);
      APEX_JSON.write('roleCode', r.role_code);
      APEX_JSON.write('orgScope', r.org_scope);
      APEX_JSON.write('orgFactPath', r.org_fact_path);
      APEX_JSON.write('staticOrgId', r.static_org_id);
      APEX_JSON.write('staticUserId', r.static_user_id);
      APEX_JSON.write('factPath', r.fact_path);
      APEX_JSON.write('refStepKey', r.ref_step_key);
      APEX_JSON.write('levelsUp', r.levels_up);
      APEX_JSON.write('resolutionMode', r.resolution_mode);
      APEX_JSON.write('fallbackRule', r.fallback_rule);
      APEX_JSON.write('minResolved', r.min_resolved);
      APEX_JSON.write('includeDelegates', r.include_delegates);
      APEX_JSON.write('excludeInitiator', r.exclude_initiator);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('conditions');
  FOR c IN (SELECT condition_key, name_en, name_ar, expr_text, is_valid, compile_error
              FROM dct_wf_condition WHERE version_id = [COLON]id ORDER BY condition_key) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('conditionKey', c.condition_key);
    APEX_JSON.write('nameEn', c.name_en);
    APEX_JSON.write('nameAr', c.name_ar);
    APEX_JSON.write('expr', c.expr_text);
    APEX_JSON.write('isValid', c.is_valid);
    APEX_JSON.write('error', c.compile_error);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>REPLACE('schemas/[COLON]id/fields','[COLON]',CHR(58)));
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>REPLACE('schemas/[COLON]id/fields','[COLON]',CHR(58)),
    p_method=>'GET', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'WF_ADMIN') = FALSE AND dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'WF_ADMIN required'); RETURN;
  END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('fields');
  FOR f IN (SELECT field_key, label_en, label_ar, data_type, lov_category
              FROM dct_wf_fact_field WHERE schema_id = [COLON]id ORDER BY display_order) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('fieldKey', f.field_key);
    APEX_JSON.write('labelEn', f.label_en);
    APEX_JSON.write('labelAr', f.label_ar);
    APEX_JSON.write('dataType', f.data_type);
    APEX_JSON.write('lovCategory', f.lov_category);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>REPLACE('processes/[COLON]code/draft','[COLON]',CHR(58)));
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>REPLACE('processes/[COLON]code/draft','[COLON]',CHR(58)),
    p_method=>'POST', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_vid NUMBER; l_no NUMBER; l_st VARCHAR2(12);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_wf_designer.can_edit_process(l_user, [COLON]code) <> 'Y' THEN
    dct_rest.err(403,'Not permitted to edit this process'); RETURN;
  END IF;
  l_vid := dct_wf_designer.clone_to_draft([COLON]code, l_user);
  COMMIT;
  SELECT version_no, status INTO l_no, l_st FROM dct_wf_process_version WHERE version_id = l_vid;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('versionId', l_vid);
  APEX_JSON.write('versionNo', l_no);
  APEX_JSON.write('status', l_st);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -20404 THEN dct_rest.err(404, SQLERRM);
  ELSIF SQLCODE = -20001 THEN dct_rest.err(400, SQLERRM);
  ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>REPLACE('versions/[COLON]id/step','[COLON]',CHR(58)));
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>REPLACE('versions/[COLON]id/step','[COLON]',CHR(58)),
    p_method=>'PUT', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_raw RAW(32767); l_json VARCHAR2(32767); l_sid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_wf_designer.can_edit_version(l_user, [COLON]id) <> 'Y' THEN
    dct_rest.err(403,'Not permitted'); RETURN;
  END IF;
  l_raw  := DBMS_LOB.SUBSTR([COLON]body, 32767, 1);
  l_json := UTL_RAW.CAST_TO_VARCHAR2(l_raw);
  dct_wf_designer.save_step([COLON]id, l_json, l_user, l_sid);
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('stepId', l_sid);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -20404 THEN dct_rest.err(404, SQLERRM);
  ELSIF SQLCODE = -20001 THEN dct_rest.err(400, SQLERRM);
  ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>REPLACE('versions/[COLON]id/step/[COLON]key','[COLON]',CHR(58)));
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>REPLACE('versions/[COLON]id/step/[COLON]key','[COLON]',CHR(58)),
    p_method=>'DELETE', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_wf_designer.can_edit_version(l_user, [COLON]id) <> 'Y' THEN
    dct_rest.err(403,'Not permitted'); RETURN;
  END IF;
  dct_wf_designer.delete_step([COLON]id, [COLON]key);
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('deleted', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -20001 THEN dct_rest.err(400, SQLERRM); ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>REPLACE('versions/[COLON]id/condition','[COLON]',CHR(58)));
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>REPLACE('versions/[COLON]id/condition','[COLON]',CHR(58)),
    p_method=>'PUT', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_valid VARCHAR2(1); l_err VARCHAR2(1000);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_wf_designer.can_edit_version(l_user, [COLON]id) <> 'Y' THEN
    dct_rest.err(403,'Not permitted'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  dct_wf_designer.save_condition([COLON]id,
    APEX_JSON.get_varchar2(p_path => 'conditionKey'),
    APEX_JSON.get_varchar2(p_path => 'expr'),
    APEX_JSON.get_varchar2(p_path => 'nameEn'),
    APEX_JSON.get_varchar2(p_path => 'nameAr'),
    l_user, l_valid, l_err);
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('valid', l_valid);
  APEX_JSON.write('error', l_err);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -20001 THEN dct_rest.err(400, SQLERRM); ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>REPLACE('versions/[COLON]id/condition/[COLON]key','[COLON]',CHR(58)));
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>REPLACE('versions/[COLON]id/condition/[COLON]key','[COLON]',CHR(58)),
    p_method=>'DELETE', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_wf_designer.can_edit_version(l_user, [COLON]id) <> 'Y' THEN
    dct_rest.err(403,'Not permitted'); RETURN;
  END IF;
  dct_wf_designer.delete_condition([COLON]id, [COLON]key);
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('deleted', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -20001 THEN dct_rest.err(400, SQLERRM); ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>REPLACE('versions/[COLON]id/participant','[COLON]',CHR(58)));
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>REPLACE('versions/[COLON]id/participant','[COLON]',CHR(58)),
    p_method=>'PUT', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_raw RAW(32767); l_json VARCHAR2(32767); l_rid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_wf_designer.can_edit_version(l_user, [COLON]id) <> 'Y' THEN
    dct_rest.err(403,'Not permitted'); RETURN;
  END IF;
  l_raw  := DBMS_LOB.SUBSTR([COLON]body, 32767, 1);
  l_json := UTL_RAW.CAST_TO_VARCHAR2(l_raw);
  dct_wf_designer.save_participant_rule([COLON]id, l_json, l_rid);
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ruleId', l_rid);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -20404 THEN dct_rest.err(404, SQLERRM);
  ELSIF SQLCODE = -20001 THEN dct_rest.err(400, SQLERRM);
  ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>REPLACE('versions/[COLON]id/participant/[COLON]rid','[COLON]',CHR(58)));
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>REPLACE('versions/[COLON]id/participant/[COLON]rid','[COLON]',CHR(58)),
    p_method=>'DELETE', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_wf_designer.can_edit_version(l_user, [COLON]id) <> 'Y' THEN
    dct_rest.err(403,'Not permitted'); RETURN;
  END IF;
  dct_wf_designer.delete_participant_rule([COLON]id, [COLON]rid);
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('deleted', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -20001 THEN dct_rest.err(400, SQLERRM); ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>REPLACE('versions/[COLON]id/validate','[COLON]',CHR(58)));
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>REPLACE('versions/[COLON]id/validate','[COLON]',CHR(58)),
    p_method=>'POST', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_probs VARCHAR2(4000);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_wf_designer.can_edit_version(l_user, [COLON]id) <> 'Y' THEN
    dct_rest.err(403,'Not permitted'); RETURN;
  END IF;
  l_probs := dct_wf_designer.validate_version([COLON]id);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('clean', l_probs IS NULL);
  APEX_JSON.write('problems', l_probs);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>REPLACE('versions/[COLON]id/publish','[COLON]',CHR(58)));
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>REPLACE('versions/[COLON]id/publish','[COLON]',CHR(58)),
    p_method=>'POST', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_wf_designer.can_edit_version(l_user, [COLON]id) <> 'Y' THEN
    dct_rest.err(403,'Not permitted'); RETURN;
  END IF;
  dct_wf_designer.publish([COLON]id, l_user);
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('published', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -20404 THEN dct_rest.err(404, SQLERRM);
  ELSIF SQLCODE = -20001 THEN dct_rest.err(400, SQLERRM);
  ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>REPLACE('versions/[COLON]id','[COLON]',CHR(58)));
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>REPLACE('versions/[COLON]id','[COLON]',CHR(58)),
    p_method=>'DELETE', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_wf_designer.can_edit_version(l_user, [COLON]id) <> 'Y' THEN
    dct_rest.err(403,'Not permitted'); RETURN;
  END IF;
  dct_wf_designer.discard_draft([COLON]id);
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('discarded', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -20001 THEN dct_rest.err(400, SQLERRM); ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!','[COLON]',CHR(58)));
  COMMIT;
END;
/

SELECT t.uri_template, h.method
  FROM user_ords_modules m
  JOIN user_ords_templates t ON t.module_id = m.id
  JOIN user_ords_handlers  h ON h.template_id = t.id
 WHERE m.name = 'wf.rest'
   AND (t.uri_template LIKE '%design%' OR t.uri_template LIKE '%/step%'
        OR t.uri_template LIKE '%/condition%' OR t.uri_template LIKE '%/participant%'
        OR t.uri_template LIKE '%/publish' OR t.uri_template LIKE '%/validate'
        OR t.uri_template LIKE '%/draft' OR t.uri_template LIKE '%fields'
        OR t.uri_template = 'versions/:id')
 ORDER BY t.uri_template, h.method;

