-- 96_dct_wf_assign_api.sql
-- DWP Dynamic Role Assignments, part 3 of 3. Adds assign paths to wf.rest.
-- Order  94, re-run 63, 95, then this. Re-run this whenever 67 is re-run.
-- Use a fresh SQLcl connection (this file makes synonyms).
-- The wf segment is exempt from the module gate, so every path here checks
-- WF_ADMIN or SYS_ADMIN itself.
-- Keep each path in its own small block on purpose (this SQLcl truncates one
-- oversized block, and a keyword-heavy banner confuses its parser).
SET DEFINE OFF
SET SQLBLANKLINES ON

CREATE OR REPLACE VIEW prod.v_dct_wf_assign_audit AS
SELECT l.log_id, l.logged_at, l.username AS actor, l.action,
       TO_NUMBER(l.object_id) AS assignment_id,
       a.object_type_code, ot.name_en AS object_type_name,
       a.object_key, a.object_key2, a.object_label, a.role_code,
       a.user_id, u.display_name AS assignee_name,
       a.start_date, a.end_date, a.is_active,
       l.old_values, l.new_values
  FROM prod.dct_audit_log l
  JOIN prod.dct_wf_role_assignment a ON a.assignment_id = TO_NUMBER(l.object_id)
  JOIN prod.dct_wf_object_type ot    ON ot.object_type_code = a.object_type_code
  LEFT JOIN prod.dct_users u         ON u.user_id = a.user_id
 WHERE l.object_type = 'WF_ROLE_ASSIGNMENT';

CREATE OR REPLACE SYNONYM dct_wf_assign          FOR prod.dct_wf_assign;
CREATE OR REPLACE SYNONYM dct_wf_object_type     FOR prod.dct_wf_object_type;
CREATE OR REPLACE SYNONYM dct_wf_role_assignment FOR prod.dct_wf_role_assignment;
CREATE OR REPLACE SYNONYM dct_wf_role_policy     FOR prod.dct_wf_role_policy;
CREATE OR REPLACE SYNONYM v_dct_wf_assign_audit  FOR prod.v_dct_wf_assign_audit;

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>'assign/object-types');
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>'assign/object-types',
    p_method=>'GET', p_source_type=>ORDS.source_type_plsql, p_source=>q'!
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
  FOR r IN (SELECT object_type_code, name_en, name_ar, lov_key2_col, lov_parent_col,
                   key2_label_en, key2_label_ar, hierarchy_kind, display_order
              FROM dct_wf_object_type WHERE is_active = 'Y' ORDER BY display_order) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.object_type_code);
    APEX_JSON.write('nameEn', r.name_en);
    APEX_JSON.write('nameAr', r.name_ar);
    APEX_JSON.write('twoPart', CASE WHEN r.lov_key2_col IS NULL THEN 'N' ELSE 'Y' END);
    APEX_JSON.write('key2LabelEn', r.key2_label_en);
    APEX_JSON.write('key2LabelAr', r.key2_label_ar);
    APEX_JSON.write('hierarchy', r.hierarchy_kind);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('roles');
  FOR r IN (SELECT ro.role_code, ro.role_name_en, ro.role_name_ar,
                   NVL(p.single_assignee,'N') AS single_assignee
              FROM dct_roles ro
              LEFT JOIN dct_wf_role_policy p ON p.role_code = ro.role_code
             WHERE ro.role_type = 'DATA' AND ro.is_active = 'Y'
             ORDER BY ro.role_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('roleCode', r.role_code);
    APEX_JSON.write('nameEn', r.role_name_en);
    APEX_JSON.write('nameAr', r.role_name_ar);
    APEX_JSON.write('singleAssignee', r.single_assignee);
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
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>'assign/lov');
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>'assign/lov',
    p_method=>'GET', p_source_type=>ORDS.source_type_plsql,
    p_items_per_page=>0, p_source=>q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_cur  SYS_REFCURSOR;
  l_k VARCHAR2(200); l_l VARCHAR2(400); l_p VARCHAR2(200); l_x VARCHAR2(100);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'WF_ADMIN') = FALSE AND dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'WF_ADMIN required'); RETURN;
  END IF;
  dct_wf_assign.lov(:type, :search, :parent, 200, l_cur);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  LOOP
    FETCH l_cur INTO l_k, l_l, l_p, l_x;
    EXIT WHEN l_cur%NOTFOUND;
    APEX_JSON.open_object;
    APEX_JSON.write('key', l_k);
    APEX_JSON.write('label', l_l);
    APEX_JSON.write('parent', l_p);
    APEX_JSON.write('extra', l_x);
    APEX_JSON.close_object;
  END LOOP;
  CLOSE l_cur;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -20404 THEN dct_rest.err(404, SQLERRM);
  ELSIF SQLCODE = -20001 THEN dct_rest.err(400, SQLERRM);
  ELSE dct_rest.err(500, SQLERRM); END IF;
END;!');
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>'assign/list');
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>'assign/list',
    p_method=>'GET', p_source_type=>ORDS.source_type_plsql,
    p_items_per_page=>0, p_source=>q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_lim NUMBER := LEAST(NVL(TO_NUMBER(:limit), 50), 200);
  l_off NUMBER := NVL(TO_NUMBER(:offset), 0);
  l_on  DATE := CASE WHEN :activeon IS NOT NULL THEN TO_DATE(:activeon,'YYYY-MM-DD') END;
  l_tot NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'WF_ADMIN') = FALSE AND dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'WF_ADMIN required'); RETURN;
  END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT a.assignment_id, a.object_type_code, ot.name_en AS object_type_name,
           ot.name_ar AS object_type_name_ar,
           a.object_key, a.object_key2, a.object_label, a.role_code,
           ro.role_name_en, ro.role_name_ar,
           a.user_id, u.display_name AS assignee_name,
           TO_CHAR(a.start_date,'YYYY-MM-DD') AS start_str,
           TO_CHAR(a.end_date,'YYYY-MM-DD') AS end_str,
           a.notes, a.replaced_by_id, a.created_by,
           TO_CHAR(dct_to_local(a.created_at),'YYYY-MM-DD HH:MI AM') AS created_str,
           CASE WHEN a.is_active = 'N' THEN 'VOID'
                WHEN a.start_date > TRUNC(SYSDATE) THEN 'FUTURE'
                WHEN a.end_date IS NOT NULL AND a.end_date < TRUNC(SYSDATE) THEN 'ENDED'
                ELSE 'ACTIVE' END AS row_status,
           COUNT(*) OVER () AS total_rows
      FROM dct_wf_role_assignment a
      JOIN dct_wf_object_type ot ON ot.object_type_code = a.object_type_code
      LEFT JOIN dct_users u  ON u.user_id = a.user_id
      LEFT JOIN dct_roles ro ON ro.role_code = a.role_code
     WHERE (:type IS NULL OR a.object_type_code = :type)
       AND (:key IS NULL OR UPPER(a.object_key) LIKE '%' || UPPER(:key) || '%'
            OR UPPER(a.object_label) LIKE '%' || UPPER(:key) || '%')
       AND (:role IS NULL OR a.role_code = :role)
       AND (:userid IS NULL OR a.user_id = TO_NUMBER(:userid))
       AND (l_on IS NULL OR (a.is_active = 'Y' AND a.start_date <= l_on
            AND (a.end_date IS NULL OR a.end_date >= l_on)))
       AND (:status IS NULL OR :status =
            CASE WHEN a.is_active = 'N' THEN 'VOID'
                 WHEN a.start_date > TRUNC(SYSDATE) THEN 'FUTURE'
                 WHEN a.end_date IS NOT NULL AND a.end_date < TRUNC(SYSDATE) THEN 'ENDED'
                 ELSE 'ACTIVE' END)
     ORDER BY a.object_type_code, a.object_key, a.role_code, a.start_date DESC
     OFFSET l_off ROWS FETCH NEXT l_lim ROWS ONLY) LOOP
    l_tot := r.total_rows;
    APEX_JSON.open_object;
    APEX_JSON.write('assignmentId', r.assignment_id);
    APEX_JSON.write('objectType', r.object_type_code);
    APEX_JSON.write('objectTypeName', r.object_type_name);
    APEX_JSON.write('objectTypeNameAr', r.object_type_name_ar);
    APEX_JSON.write('objectKey', r.object_key);
    APEX_JSON.write('objectKey2', r.object_key2);
    APEX_JSON.write('objectLabel', r.object_label);
    APEX_JSON.write('roleCode', r.role_code);
    APEX_JSON.write('roleName', r.role_name_en);
    APEX_JSON.write('roleNameAr', r.role_name_ar);
    APEX_JSON.write('userId', r.user_id);
    APEX_JSON.write('assigneeName', r.assignee_name);
    APEX_JSON.write('startDate', r.start_str);
    APEX_JSON.write('endDate', r.end_str);
    APEX_JSON.write('status', r.row_status);
    APEX_JSON.write('notes', r.notes);
    APEX_JSON.write('replacedById', r.replaced_by_id);
    APEX_JSON.write('createdBy', r.created_by);
    APEX_JSON.write('createdAt', r.created_str);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('total', l_tot);
  APEX_JSON.write('limit', l_lim);
  APEX_JSON.write('offset', l_off);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  dct_rest.err(500, SQLERRM);
END;!');
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>'assign/');
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>'assign/',
    p_method=>'POST', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_raw RAW(32767); l_json VARCHAR2(32767); l_id NUMBER;
  l_action VARCHAR2(20);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'WF_ADMIN') = FALSE AND dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'WF_ADMIN required'); RETURN;
  END IF;
  l_raw  := DBMS_LOB.SUBSTR([COLON]body, 32767, 1);
  l_json := UTL_RAW.CAST_TO_VARCHAR2(l_raw);
  APEX_JSON.parse(l_json);
  l_action := NVL(APEX_JSON.get_varchar2(p_path=>'action'), 'create');
  IF l_action = 'replace' THEN
    l_id := dct_wf_assign.replace_assignment(l_user,
        APEX_JSON.get_number(p_path=>'assignmentId'),
        APEX_JSON.get_number(p_path=>'newUserId'),
        CASE WHEN APEX_JSON.get_varchar2(p_path=>'effectiveDate') IS NOT NULL
             THEN TO_DATE(APEX_JSON.get_varchar2(p_path=>'effectiveDate'),'YYYY-MM-DD') END);
  ELSE
    l_id := dct_wf_assign.create_assignment(l_user,
        APEX_JSON.get_varchar2(p_path=>'objectType'),
        APEX_JSON.get_varchar2(p_path=>'objectKey'),
        APEX_JSON.get_varchar2(p_path=>'objectKey2'),
        APEX_JSON.get_varchar2(p_path=>'roleCode'),
        APEX_JSON.get_number(p_path=>'userId'),
        CASE WHEN APEX_JSON.get_varchar2(p_path=>'startDate') IS NOT NULL
             THEN TO_DATE(APEX_JSON.get_varchar2(p_path=>'startDate'),'YYYY-MM-DD') END,
        CASE WHEN APEX_JSON.get_varchar2(p_path=>'endDate') IS NOT NULL
             THEN TO_DATE(APEX_JSON.get_varchar2(p_path=>'endDate'),'YYYY-MM-DD') END,
        APEX_JSON.get_varchar2(p_path=>'notes'));
  END IF;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('assignmentId', l_id);
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
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>REPLACE('assign/[COLON]id','[COLON]',CHR(58)));
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>REPLACE('assign/[COLON]id','[COLON]',CHR(58)),
    p_method=>'PUT', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_raw RAW(32767); l_json VARCHAR2(32767); l_op VARCHAR2(20);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'WF_ADMIN') = FALSE AND dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'WF_ADMIN required'); RETURN;
  END IF;
  l_raw  := DBMS_LOB.SUBSTR([COLON]body, 32767, 1);
  l_json := UTL_RAW.CAST_TO_VARCHAR2(l_raw);
  APEX_JSON.parse(l_json);
  l_op := NVL(APEX_JSON.get_varchar2(p_path=>'op'), 'update');
  IF l_op = 'end' THEN
    dct_wf_assign.end_assignment(l_user, [COLON]id,
        CASE WHEN APEX_JSON.get_varchar2(p_path=>'endDate') IS NOT NULL
             THEN TO_DATE(APEX_JSON.get_varchar2(p_path=>'endDate'),'YYYY-MM-DD') END,
        APEX_JSON.get_varchar2(p_path=>'note'));
  ELSIF l_op = 'void' THEN
    dct_wf_assign.void_assignment(l_user, [COLON]id,
        APEX_JSON.get_varchar2(p_path=>'reason'));
  ELSE
    dct_wf_assign.update_assignment(l_user, [COLON]id,
        APEX_JSON.get_varchar2(p_path=>'notes'),
        CASE WHEN APEX_JSON.get_varchar2(p_path=>'endDate') IS NOT NULL
             THEN TO_DATE(APEX_JSON.get_varchar2(p_path=>'endDate'),'YYYY-MM-DD') END,
        NVL(APEX_JSON.get_varchar2(p_path=>'clearEnd'), 'N'));
  END IF;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
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
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>'assign/timeline');
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>'assign/timeline',
    p_method=>'GET', p_source_type=>ORDS.source_type_plsql,
    p_items_per_page=>0, p_source=>q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'WF_ADMIN') = FALSE AND dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'WF_ADMIN required'); RETURN;
  END IF;
  IF :type IS NULL OR :key IS NULL THEN
    dct_rest.err(400,'type and key are required'); RETURN;
  END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT a.assignment_id, a.role_code, a.object_label,
           u.display_name AS assignee_name,
           TO_CHAR(a.start_date,'YYYY-MM-DD') AS start_str,
           TO_CHAR(a.end_date,'YYYY-MM-DD') AS end_str,
           a.is_active, a.notes, a.replaced_by_id, a.created_by,
           TO_CHAR(dct_to_local(a.created_at),'YYYY-MM-DD HH:MI AM') AS created_str,
           a.ended_by,
           TO_CHAR(dct_to_local(a.ended_at),'YYYY-MM-DD HH:MI AM') AS ended_str
      FROM dct_wf_role_assignment a
      LEFT JOIN dct_users u ON u.user_id = a.user_id
     WHERE a.object_type_code = :type
       AND a.object_key = :key
       AND (:key2 IS NULL OR NVL(a.object_key2,'#') = :key2)
       AND (:role IS NULL OR a.role_code = :role)
     ORDER BY a.role_code, a.start_date, a.assignment_id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('assignmentId', r.assignment_id);
    APEX_JSON.write('roleCode', r.role_code);
    APEX_JSON.write('objectLabel', r.object_label);
    APEX_JSON.write('assigneeName', r.assignee_name);
    APEX_JSON.write('startDate', r.start_str);
    APEX_JSON.write('endDate', r.end_str);
    APEX_JSON.write('isActive', r.is_active);
    APEX_JSON.write('notes', r.notes);
    APEX_JSON.write('replacedById', r.replaced_by_id);
    APEX_JSON.write('createdBy', r.created_by);
    APEX_JSON.write('createdAt', r.created_str);
    APEX_JSON.write('endedBy', r.ended_by);
    APEX_JSON.write('endedAt', r.ended_str);
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
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>'assign/preview');
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>'assign/preview',
    p_method=>'GET', p_source_type=>ORDS.source_type_plsql,
    p_items_per_page=>0, p_source=>q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_lst  sys.odcinumberlist;
  l_nm   VARCHAR2(200);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'WF_ADMIN') = FALSE AND dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'WF_ADMIN required'); RETURN;
  END IF;
  l_lst := dct_wf_assign.resolve_preview(:type, :key, :key2, :role,
      CASE WHEN :asof IS NOT NULL THEN TO_DATE(:asof,'YYYY-MM-DD') END);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('users');
  FOR i IN 1 .. l_lst.COUNT LOOP
    BEGIN
      SELECT display_name INTO l_nm FROM dct_users WHERE user_id = l_lst(i);
    EXCEPTION WHEN OTHERS THEN l_nm := 'user ' || l_lst(i);
    END;
    APEX_JSON.open_object;
    APEX_JSON.write('userId', l_lst(i));
    APEX_JSON.write('name', l_nm);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('count', l_lst.COUNT);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -20404 THEN dct_rest.err(404, SQLERRM);
  ELSIF SQLCODE = -20001 THEN dct_rest.err(400, SQLERRM);
  ELSE dct_rest.err(500, SQLERRM); END IF;
END;!');
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>'assign/audit');
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>'assign/audit',
    p_method=>'GET', p_source_type=>ORDS.source_type_plsql,
    p_items_per_page=>0, p_source=>q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_lim NUMBER := LEAST(NVL(TO_NUMBER(:limit), 50), 200);
  l_off NUMBER := NVL(TO_NUMBER(:offset), 0);
  l_from DATE := CASE WHEN :fromdt IS NOT NULL THEN TO_DATE(:fromdt,'YYYY-MM-DD') END;
  l_to   DATE := CASE WHEN :todt   IS NOT NULL THEN TO_DATE(:todt,'YYYY-MM-DD') END;
  l_tot NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'WF_ADMIN') = FALSE AND dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'WF_ADMIN required'); RETURN;
  END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT v.log_id, TO_CHAR(dct_to_local(v.logged_at),'YYYY-MM-DD HH:MI AM') AS at_str,
           v.actor, v.action, v.assignment_id, v.object_type_code, v.object_type_name,
           v.object_key, v.object_key2, v.object_label, v.role_code,
           v.assignee_name, TO_CHAR(v.start_date,'YYYY-MM-DD') AS start_str,
           TO_CHAR(v.end_date,'YYYY-MM-DD') AS end_str, v.is_active,
           v.old_values, v.new_values,
           COUNT(*) OVER () AS total_rows
      FROM v_dct_wf_assign_audit v
     WHERE (:actor IS NULL OR UPPER(v.actor) LIKE '%' || UPPER(:actor) || '%')
       AND (:type IS NULL OR v.object_type_code = :type)
       AND (:key IS NULL OR UPPER(v.object_key) LIKE '%' || UPPER(:key) || '%'
            OR UPPER(v.object_label) LIKE '%' || UPPER(:key) || '%')
       AND (:role IS NULL OR v.role_code = :role)
       AND (:action IS NULL OR v.action = UPPER(:action))
       AND (l_from IS NULL OR v.logged_at >= l_from)
       AND (l_to IS NULL OR v.logged_at < l_to + 1)
     ORDER BY v.logged_at DESC, v.log_id DESC
     OFFSET l_off ROWS FETCH NEXT l_lim ROWS ONLY) LOOP
    l_tot := r.total_rows;
    APEX_JSON.open_object;
    APEX_JSON.write('logId', r.log_id);
    APEX_JSON.write('at', r.at_str);
    APEX_JSON.write('actor', r.actor);
    APEX_JSON.write('action', r.action);
    APEX_JSON.write('assignmentId', r.assignment_id);
    APEX_JSON.write('objectType', r.object_type_code);
    APEX_JSON.write('objectTypeName', r.object_type_name);
    APEX_JSON.write('objectKey', r.object_key);
    APEX_JSON.write('objectKey2', r.object_key2);
    APEX_JSON.write('objectLabel', r.object_label);
    APEX_JSON.write('roleCode', r.role_code);
    APEX_JSON.write('assigneeName', r.assignee_name);
    APEX_JSON.write('startDate', r.start_str);
    APEX_JSON.write('endDate', r.end_str);
    APEX_JSON.write('isActive', r.is_active);
    APEX_JSON.write('oldValues', r.old_values);
    APEX_JSON.write('newValues', r.new_values);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('total', l_tot);
  APEX_JSON.write('limit', l_lim);
  APEX_JSON.write('offset', l_off);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  dct_rest.err(500, SQLERRM);
END;!');
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>'assign/audit/export');
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>'assign/audit/export',
    p_method=>'GET', p_source_type=>ORDS.source_type_plsql,
    p_items_per_page=>0, p_source=>q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_from DATE := CASE WHEN :fromdt IS NOT NULL THEN TO_DATE(:fromdt,'YYYY-MM-DD') END;
  l_to   DATE := CASE WHEN :todt   IS NOT NULL THEN TO_DATE(:todt,'YYYY-MM-DD') END;
  l_n NUMBER := 0;
  FUNCTION esc (p IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    IF p IS NULL THEN RETURN NULL; END IF;
    IF INSTR(p,'"') > 0 OR INSTR(p,',') > 0 OR INSTR(p, CHR(10)) > 0 THEN
      RETURN '"' || REPLACE(p, '"', '""') || '"';
    END IF;
    RETURN p;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'WF_ADMIN') = FALSE AND dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'WF_ADMIN required'); RETURN;
  END IF;
  OWA_UTIL.mime_header('text/csv', FALSE);
  HTP.p('Content-Disposition: attachment; filename="role-assignments-audit-'
        || TO_CHAR(SYSDATE,'YYYYMMDD') || '.csv"');
  OWA_UTIL.http_header_close;
  HTP.prn(UNISTR('\FEFF'));
  HTP.p('When,Actor,Action,Assignment,Object Type,Object Key,Object Key 2,Object,Role,Assignee,Start,End,Active');
  FOR r IN (
    SELECT TO_CHAR(dct_to_local(v.logged_at),'YYYY-MM-DD HH:MI AM') AS at_str,
           v.actor, v.action, v.assignment_id, v.object_type_name,
           v.object_key, v.object_key2, v.object_label, v.role_code, v.assignee_name,
           TO_CHAR(v.start_date,'YYYY-MM-DD') AS start_str,
           TO_CHAR(v.end_date,'YYYY-MM-DD') AS end_str, v.is_active
      FROM v_dct_wf_assign_audit v
     WHERE (:actor IS NULL OR UPPER(v.actor) LIKE '%' || UPPER(:actor) || '%')
       AND (:type IS NULL OR v.object_type_code = :type)
       AND (:key IS NULL OR UPPER(v.object_key) LIKE '%' || UPPER(:key) || '%'
            OR UPPER(v.object_label) LIKE '%' || UPPER(:key) || '%')
       AND (:role IS NULL OR v.role_code = :role)
       AND (:action IS NULL OR v.action = UPPER(:action))
       AND (l_from IS NULL OR v.logged_at >= l_from)
       AND (l_to IS NULL OR v.logged_at < l_to + 1)
     ORDER BY v.logged_at DESC, v.log_id DESC) LOOP
    EXIT WHEN l_n >= 20000;
    l_n := l_n + 1;
    HTP.p(esc(r.at_str) || ',' || esc(r.actor) || ',' || esc(r.action) || ','
       || r.assignment_id || ',' || esc(r.object_type_name) || ','
       || esc(r.object_key) || ',' || esc(r.object_key2) || ','
       || esc(r.object_label) || ',' || esc(r.role_code) || ','
       || esc(r.assignee_name) || ',' || esc(r.start_str) || ','
       || esc(r.end_str) || ',' || r.is_active);
  END LOOP;
END;!');
  COMMIT;
END;
/

PROMPT --- registered assign paths ---

SELECT t.uri_template, h.method
  FROM user_ords_templates t
  JOIN user_ords_handlers h ON h.template_id = t.id
  JOIN user_ords_modules m ON m.id = t.module_id
 WHERE m.name = 'wf.rest' AND t.uri_template LIKE 'assign%'
 ORDER BY t.uri_template, h.method;

EXIT
