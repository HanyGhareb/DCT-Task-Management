-- 98_dct_wf_manage_api.sql
-- Additive wf.rest routes for the Role Assignments management drawers +
-- admin task reassignment. Re-run after any 67 re-run, after 96/97.
--   GET  assign/manage/roles           WF_ADMIN   full DATA-role list incl. inactive
--   POST assign/manage/roles           WF_ADMIN   create/update a DATA role + policy
--   GET  assign/manage/object-types    SYS_ADMIN  full registry incl. inactive
--   POST assign/manage/object-types    SYS_ADMIN  create/update a registry row
--   GET  assign/dict?view=[&search=]   SYS_ADMIN  PROD views (search) or columns (view)
--   POST tasks/:id/reassign            WF_ADMIN   engine reassign_task (leaver case)
-- Every route self-gates: the wf segment is EXEMPT from the module gate.
-- Deploy in a FRESH ADMIN SQLcl session (sql -name prod_mcp).
SET DEFINE OFF
SET SQLBLANKLINES ON

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>'assign/manage/roles');
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>'assign/manage/roles',
    p_method=>'GET', p_source_type=>ORDS.source_type_plsql, p_items_per_page=>0, p_source=>q'!
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
  APEX_JSON.open_array('items');
  FOR r IN (SELECT ro.role_code, ro.role_name_en, ro.role_name_ar, ro.is_active,
                   NVL(p.single_assignee,'N') AS single_assignee,
                   (SELECT COUNT(*) FROM dct_wf_role_assignment a
                     WHERE a.role_code = ro.role_code AND a.is_active = 'Y'
                       AND NVL(a.end_date, DATE '9999-12-31') >= TRUNC(SYSDATE)) AS n_active
              FROM dct_roles ro
              LEFT JOIN dct_wf_role_policy p ON p.role_code = ro.role_code
             WHERE ro.role_type = 'DATA'
             ORDER BY ro.is_active DESC, ro.role_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('roleCode', r.role_code);
    APEX_JSON.write('nameEn', r.role_name_en);
    APEX_JSON.write('nameAr', r.role_name_ar);
    APEX_JSON.write('singleAssignee', r.single_assignee);
    APEX_JSON.write('isActive', r.is_active);
    APEX_JSON.write('activeAssignments', r.n_active);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  dct_rest.err(500, SQLERRM);
END;!');
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>'assign/manage/roles',
    p_method=>'POST', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_raw RAW(32767); l_json VARCHAR2(32767); l_inuse NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'WF_ADMIN') = FALSE AND dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'WF_ADMIN required'); RETURN;
  END IF;
  l_raw  := DBMS_LOB.SUBSTR([COLON]body, 32767, 1);
  l_json := UTL_RAW.CAST_TO_VARCHAR2(l_raw);
  APEX_JSON.parse(l_json);
  l_inuse := dct_wf_assign.save_data_role(l_user,
      APEX_JSON.get_varchar2(p_path=>'roleCode'),
      APEX_JSON.get_varchar2(p_path=>'nameEn'),
      APEX_JSON.get_varchar2(p_path=>'nameAr'),
      APEX_JSON.get_varchar2(p_path=>'singleAssignee'),
      APEX_JSON.get_varchar2(p_path=>'isActive'));
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('roleCode', UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'roleCode'))));
  APEX_JSON.write('activeAssignments', l_inuse);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE = -20404 THEN dct_rest.err(404, SQLERRM);
  ELSIF SQLCODE = -20403 THEN dct_rest.err(403, SQLERRM);
  ELSIF SQLCODE = -20001 THEN dct_rest.err(400, SQLERRM);
  ELSE dct_rest.err(500, SQLERRM); END IF;
END;!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>'assign/manage/object-types');
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>'assign/manage/object-types',
    p_method=>'GET', p_source_type=>ORDS.source_type_plsql, p_items_per_page=>0, p_source=>q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
  END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT t.*,
                   (SELECT COUNT(*) FROM dct_wf_role_assignment a
                     WHERE a.object_type_code = t.object_type_code AND a.is_active = 'Y'
                       AND NVL(a.end_date, DATE '9999-12-31') >= TRUNC(SYSDATE)) AS n_active
              FROM dct_wf_object_type t
             ORDER BY t.is_active DESC, t.display_order) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.object_type_code);
    APEX_JSON.write('nameEn', r.name_en);
    APEX_JSON.write('nameAr', r.name_ar);
    APEX_JSON.write('lovView', r.lov_view);
    APEX_JSON.write('keyCol', r.lov_key_col);
    APEX_JSON.write('labelCol', r.lov_label_col);
    APEX_JSON.write('key2Col', r.lov_key2_col);
    APEX_JSON.write('parentCol', r.lov_parent_col);
    APEX_JSON.write('key2LabelEn', r.key2_label_en);
    APEX_JSON.write('key2LabelAr', r.key2_label_ar);
    APEX_JSON.write('keyIsNumeric', r.key_is_numeric);
    APEX_JSON.write('hierarchy', r.hierarchy_kind);
    APEX_JSON.write('validateKey', r.validate_key);
    APEX_JSON.write('isActive', r.is_active);
    APEX_JSON.write('displayOrder', r.display_order);
    APEX_JSON.write('activeAssignments', r.n_active);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  dct_rest.err(500, SQLERRM);
END;!');
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>'assign/manage/object-types',
    p_method=>'POST', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_raw RAW(32767); l_json VARCHAR2(32767); l_inuse NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
  END IF;
  l_raw  := DBMS_LOB.SUBSTR([COLON]body, 32767, 1);
  l_json := UTL_RAW.CAST_TO_VARCHAR2(l_raw);
  APEX_JSON.parse(l_json);
  l_inuse := dct_wf_assign.save_object_type(l_user,
      APEX_JSON.get_varchar2(p_path=>'code'),
      APEX_JSON.get_varchar2(p_path=>'nameEn'),
      APEX_JSON.get_varchar2(p_path=>'nameAr'),
      APEX_JSON.get_varchar2(p_path=>'lovView'),
      APEX_JSON.get_varchar2(p_path=>'keyCol'),
      APEX_JSON.get_varchar2(p_path=>'labelCol'),
      APEX_JSON.get_varchar2(p_path=>'key2Col'),
      APEX_JSON.get_varchar2(p_path=>'parentCol'),
      APEX_JSON.get_varchar2(p_path=>'key2LabelEn'),
      APEX_JSON.get_varchar2(p_path=>'key2LabelAr'),
      APEX_JSON.get_varchar2(p_path=>'keyIsNumeric'),
      APEX_JSON.get_varchar2(p_path=>'hierarchy'),
      APEX_JSON.get_varchar2(p_path=>'validateKey'),
      APEX_JSON.get_varchar2(p_path=>'isActive'),
      APEX_JSON.get_number(p_path=>'displayOrder'));
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('code', UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'code'))));
  APEX_JSON.write('activeAssignments', l_inuse);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE = -20404 THEN dct_rest.err(404, SQLERRM);
  ELSIF SQLCODE = -20403 THEN dct_rest.err(403, SQLERRM);
  ELSIF SQLCODE = -20001 THEN dct_rest.err(400, SQLERRM);
  ELSE dct_rest.err(500, SQLERRM); END IF;
END;!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>'assign/dict');
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>'assign/dict',
    p_method=>'GET', p_source_type=>ORDS.source_type_plsql, p_items_per_page=>0, p_source=>q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_view VARCHAR2(200);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
  END IF;
  -- validate BEFORE json_header: once output starts, an error status cannot
  -- be sent and the 400 would ride inside a 200 body
  IF :view IS NOT NULL THEN
    BEGIN
      l_view := DBMS_ASSERT.simple_sql_name(UPPER(TRIM(:view)));
    EXCEPTION WHEN OTHERS THEN
      dct_rest.err(400, 'Invalid view name'); RETURN;
    END;
  END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  IF l_view IS NOT NULL THEN
    -- columns of ONE view (identifier-guarded above)
    APEX_JSON.open_array('columns');
    FOR r IN (SELECT column_name, data_type FROM all_tab_columns
               WHERE owner = 'PROD' AND table_name = l_view
               ORDER BY column_id) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('name', r.column_name);
      APEX_JSON.write('type', r.data_type);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
  ELSE
    -- candidate PROD views (search by name, cap 50)
    APEX_JSON.open_array('views');
    FOR r IN (SELECT view_name AS obj FROM all_views
               WHERE owner = 'PROD'
                 AND (:search IS NULL OR view_name LIKE '%' || UPPER(:search) || '%')
               ORDER BY view_name
               FETCH FIRST 50 ROWS ONLY) LOOP
      APEX_JSON.write(r.obj);
    END LOOP;
    APEX_JSON.close_array;
  END IF;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -44003 THEN dct_rest.err(400, 'Invalid view name');
  ELSE dct_rest.err(500, SQLERRM); END IF;
END;!');
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>REPLACE('tasks/[COLON]id/reassign','[COLON]',CHR(58)));
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>REPLACE('tasks/[COLON]id/reassign','[COLON]',CHR(58)),
    p_method=>'POST', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
  l_raw RAW(32767); l_json VARCHAR2(32767);
  l_to   NUMBER; l_cnt NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'WF_ADMIN') = FALSE AND dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'WF_ADMIN required'); RETURN;
  END IF;
  l_uid  := dct_auth.get_user_id(l_user);
  l_raw  := DBMS_LOB.SUBSTR([COLON]body, 32767, 1);
  l_json := UTL_RAW.CAST_TO_VARCHAR2(l_raw);
  APEX_JSON.parse(l_json);
  l_to := APEX_JSON.get_number(p_path=>'toUserId');
  IF l_to IS NULL THEN dct_rest.err(400,'toUserId is required'); RETURN; END IF;
  SELECT COUNT(*) INTO l_cnt FROM dct_users
   WHERE user_id = l_to AND is_active = 'Y';
  IF l_cnt = 0 THEN dct_rest.err(400,'Target user is unknown or inactive'); RETURN; END IF;
  SELECT COUNT(*) INTO l_cnt FROM dct_wf_task
   WHERE task_id = TO_NUMBER([COLON]id)
     AND state IN ('UNASSIGNED','ASSIGNED','INFO_REQUESTED');
  IF l_cnt = 0 THEN dct_rest.err(404,'Open task not found'); RETURN; END IF;
  dct_wf_engine.reassign_task(TO_NUMBER([COLON]id), l_uid, l_to,
      APEX_JSON.get_varchar2(p_path=>'reason'));
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('taskId', TO_NUMBER([COLON]id));
  APEX_JSON.write('toUserId', l_to);
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
 WHERE m.name = 'wf.rest'
   AND (t.uri_template LIKE 'assign/manage%' OR t.uri_template LIKE 'assign/dict%'
        OR t.uri_template LIKE 'tasks/%reassign')
 ORDER BY t.uri_template, h.method;

EXIT
