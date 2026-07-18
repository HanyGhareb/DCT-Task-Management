-- 97_dct_wf_assign_policy_api.sql
-- One additive path on wf.rest: change a DATA role's assignment cardinality
-- (single assignee vs group). Re-run after any 67 re-run, after 96.
-- Self-gated WF_ADMIN or SYS_ADMIN like every wf path (the wf segment is
-- exempt from the module gate). Response carries overlapGroups so the UI can
-- warn when a flip to single leaves grandfathered overlapping assignments.
SET DEFINE OFF
SET SQLBLANKLINES ON

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>REPLACE('assign/policy/[COLON]role','[COLON]',CHR(58)));
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>REPLACE('assign/policy/[COLON]role','[COLON]',CHR(58)),
    p_method=>'PUT', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_raw RAW(32767); l_json VARCHAR2(32767); l_over NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'WF_ADMIN') = FALSE AND dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'WF_ADMIN required'); RETURN;
  END IF;
  l_raw  := DBMS_LOB.SUBSTR([COLON]body, 32767, 1);
  l_json := UTL_RAW.CAST_TO_VARCHAR2(l_raw);
  APEX_JSON.parse(l_json);
  l_over := dct_wf_assign.set_role_policy(l_user, [COLON]role,
      UPPER(APEX_JSON.get_varchar2(p_path=>'singleAssignee')));
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('roleCode', [COLON]role);
  APEX_JSON.write('overlapGroups', l_over);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE = -20404 THEN dct_rest.err(404, SQLERRM);
  ELSIF SQLCODE = -20001 THEN dct_rest.err(400, SQLERRM);
  ELSE dct_rest.err(500, SQLERRM); END IF;
END;!','[COLON]',CHR(58)));
  COMMIT;
END;
/

SELECT t.uri_template, h.method
  FROM user_ords_templates t
  JOIN user_ords_handlers h ON h.template_id = t.id
  JOIN user_ords_modules m ON m.id = t.module_id
 WHERE m.name = 'wf.rest' AND t.uri_template LIKE 'assign/policy%';

EXIT
