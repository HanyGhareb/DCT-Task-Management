-- 101_dct_sec_ords.sql
-- Security Console, part 3 of 3. Adds sec/ paths to the dct.admin module.
-- Order: 99, 100, then this. RE-RUN THIS AFTER ANY 11 RE-RUN (11 rebuilds
-- dct.admin from scratch and drops these templates).
-- Use a fresh SQLcl connection (this file makes synonyms).
-- The dct segment is exempt from the module gate, so every path here checks
-- SYS_ADMIN itself. Keep each path in its own small block on purpose (this
-- SQLcl truncates one oversized block, and a keyword-heavy banner confuses
-- its parser).
SET DEFINE OFF
SET SQLBLANKLINES ON

CREATE OR REPLACE SYNONYM dct_sec                 FOR prod.dct_sec;
CREATE OR REPLACE SYNONYM dct_sec_data            FOR prod.dct_sec_data;
CREATE OR REPLACE SYNONYM dct_sec_priv_group      FOR prod.dct_sec_priv_group;
CREATE OR REPLACE SYNONYM dct_sec_priv_group_item FOR prod.dct_sec_priv_group_item;
CREATE OR REPLACE SYNONYM dct_sec_role_hierarchy  FOR prod.dct_sec_role_hierarchy;
CREATE OR REPLACE SYNONYM dct_sec_role_priv_group FOR prod.dct_sec_role_priv_group;
CREATE OR REPLACE SYNONYM dct_sec_exclusion       FOR prod.dct_sec_exclusion;
CREATE OR REPLACE SYNONYM dct_sec_profile         FOR prod.dct_sec_profile;
CREATE OR REPLACE SYNONYM dct_sec_profile_scope   FOR prod.dct_sec_profile_scope;
CREATE OR REPLACE SYNONYM dct_sec_user_profile    FOR prod.dct_sec_user_profile;
CREATE OR REPLACE SYNONYM dct_sec_role_priv_flat  FOR prod.dct_sec_role_priv_flat;
CREATE OR REPLACE SYNONYM dct_sec_version         FOR prod.dct_sec_version;
CREATE OR REPLACE SYNONYM dct_sec_page            FOR prod.dct_sec_page;
CREATE OR REPLACE SYNONYM dct_sec_page_artifact   FOR prod.dct_sec_page_artifact;
CREATE OR REPLACE SYNONYM v_dct_user_privs_eff    FOR prod.v_dct_user_privs_eff;
CREATE OR REPLACE SYNONYM v_dct_sec_user_scope    FOR prod.v_dct_sec_user_scope;

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'dct.admin', p_pattern=>'sec/meta');
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin', p_pattern=>'sec/meta',
    p_method=>'GET', p_source_type=>ORDS.source_type_plsql,
    p_items_per_page=>0, p_source=>q'!
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
  APEX_JSON.open_array('verbs');
  FOR r IN (SELECT column_value AS v FROM TABLE(sys.odcivarchar2list(
      'VIEW','CREATE','EDIT','DELETE','APPROVE','RUN','MANAGE','EXPORT',
      'CONFIGURE','SUBMIT','GENERATE','ASSIGN','POST','PRINT'))) LOOP
    APEX_JSON.write(r.v);
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('modules');
  FOR r IN (SELECT module_id, module_code, module_name_en, module_name_ar
              FROM dct_modules WHERE is_active='Y' ORDER BY display_order) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('moduleId', r.module_id);
    APEX_JSON.write('code', r.module_code);
    APEX_JSON.write('nameEn', r.module_name_en);
    APEX_JSON.write('nameAr', r.module_name_ar);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('objectTypes');
  FOR r IN (SELECT object_type_code, name_en, name_ar, hierarchy_kind
              FROM dct_wf_object_type
             WHERE is_active='Y' AND use_in_security='Y'
             ORDER BY display_order) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.object_type_code);
    APEX_JSON.write('nameEn', r.name_en);
    APEX_JSON.write('nameAr', r.name_ar);
    APEX_JSON.write('hierarchy', r.hierarchy_kind);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('privileges');
  FOR r IN (SELECT p.permission_id, p.permission_code, p.permission_name,
                   m.module_code
              FROM dct_permissions p
              LEFT JOIN dct_modules m ON m.module_id = p.module_id
             WHERE p.is_active='Y' ORDER BY m.module_code NULLS FIRST, p.permission_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id', r.permission_id);
    APEX_JSON.write('code', r.permission_code);
    APEX_JSON.write('name', r.permission_name);
    APEX_JSON.write('module', r.module_code);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('groups');
  FOR r IN (SELECT group_id, group_code, name_en FROM dct_sec_priv_group
             WHERE is_active='Y' ORDER BY display_order, group_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id', r.group_id);
    APEX_JSON.write('code', r.group_code);
    APEX_JSON.write('name', r.name_en);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('dutyRoles');
  FOR r IN (SELECT role_id, role_code, role_name_en FROM dct_roles
             WHERE is_active='Y' AND role_category='DUTY' ORDER BY role_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id', r.role_id);
    APEX_JSON.write('code', r.role_code);
    APEX_JSON.write('name', r.role_name_en);
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
  ORDS.DEFINE_TEMPLATE(p_module_name=>'dct.admin', p_pattern=>'sec/privileges');
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin', p_pattern=>'sec/privileges',
    p_method=>'GET', p_source_type=>ORDS.source_type_plsql,
    p_items_per_page=>0, p_source=>q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_lim NUMBER := LEAST(NVL(TO_NUMBER(:limit), 100), 500);
  l_off NUMBER := NVL(TO_NUMBER(:offset), 0);
  l_tot NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
  END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT p.permission_id, p.permission_code, p.permission_name,
           p.permission_name_ar, p.action_type, p.verb, p.is_active,
           p.description_en, m.module_code,
           p.created_by, p.created_at, p.updated_by, p.updated_at,
           (SELECT COUNT(*) FROM dct_sec_priv_group_item gi WHERE gi.permission_id = p.permission_id) AS group_count,
           (SELECT COUNT(*) FROM dct_role_permissions rp WHERE rp.permission_id = p.permission_id) AS role_count,
           COUNT(*) OVER () AS total_rows
      FROM dct_permissions p
      LEFT JOIN dct_modules m ON m.module_id = p.module_id
     WHERE (:search IS NULL OR UPPER(p.permission_code) LIKE '%'||UPPER(:search)||'%'
            OR UPPER(p.permission_name) LIKE '%'||UPPER(:search)||'%')
       AND (:module IS NULL OR m.module_code = UPPER(:module))
       AND (NVL(:inactive,'N') = 'Y' OR p.is_active = 'Y')
     ORDER BY m.module_code NULLS FIRST, p.permission_code
     OFFSET l_off ROWS FETCH NEXT l_lim ROWS ONLY) LOOP
    l_tot := r.total_rows;
    APEX_JSON.open_object;
    APEX_JSON.write('id', r.permission_id);
    APEX_JSON.write('code', r.permission_code);
    APEX_JSON.write('name', r.permission_name);
    APEX_JSON.write('nameAr', r.permission_name_ar);
    APEX_JSON.write('actionType', r.action_type);
    APEX_JSON.write('verb', r.verb);
    APEX_JSON.write('module', r.module_code);
    APEX_JSON.write('description', r.description_en);
    APEX_JSON.write('isActive', r.is_active);
    APEX_JSON.write('groupCount', r.group_count);
    APEX_JSON.write('roleCount', r.role_count);
    APEX_JSON.write('createdBy', r.created_by);
    APEX_JSON.write('createdAt', TO_CHAR(dct_to_local(r.created_at),'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.write('updatedBy', r.updated_by);
    APEX_JSON.write('updatedAt', TO_CHAR(dct_to_local(r.updated_at),'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('total', l_tot);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  dct_rest.err(500, SQLERRM);
END;!');
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin', p_pattern=>'sec/privileges',
    p_method=>'POST', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_raw RAW(32767); l_json VARCHAR2(32767);
  l_name VARCHAR2(200); l_verb VARCHAR2(30); l_id NUMBER; l_mid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
  END IF;
  l_raw  := DBMS_LOB.SUBSTR([COLON]body, 32767, 1);
  l_json := UTL_RAW.CAST_TO_VARCHAR2(l_raw);
  APEX_JSON.parse(l_json);
  l_name := APEX_JSON.get_varchar2(p_path=>'name');
  IF l_name IS NULL OR APEX_JSON.get_varchar2(p_path=>'code') IS NULL THEN
    dct_rest.err(400,'code and name are required'); RETURN;
  END IF;
  l_verb := UPPER(REGEXP_SUBSTR(TRIM(l_name), '^\S+'));
  IF l_verb NOT IN ('VIEW','CREATE','EDIT','DELETE','APPROVE','RUN','MANAGE',
                    'EXPORT','CONFIGURE','SUBMIT','GENERATE','ASSIGN','POST','PRINT') THEN
    dct_rest.err(400,'Privilege name must start with a verb (View, Edit, Delete, Run, Manage...)');
    RETURN;
  END IF;
  IF APEX_JSON.get_varchar2(p_path=>'module') IS NOT NULL THEN
    SELECT MAX(module_id) INTO l_mid FROM dct_modules
     WHERE module_code = UPPER(APEX_JSON.get_varchar2(p_path=>'module'));
  END IF;
  INSERT INTO dct_permissions
      (permission_code, permission_name, permission_name_ar, module_id,
       action_type, verb, description_en, created_by)
  VALUES (UPPER(APEX_JSON.get_varchar2(p_path=>'code')), l_name,
       APEX_JSON.get_varchar2(p_path=>'nameAr'), l_mid,
       NVL(UPPER(APEX_JSON.get_varchar2(p_path=>'actionType')),'VIEW'),
       l_verb, APEX_JSON.get_varchar2(p_path=>'description'), l_user)
  RETURNING permission_id INTO l_id;
  dct_audit_pkg.log(l_user,'CREATE','SEC_PRIVILEGE',TO_CHAR(l_id),'ADMIN',
      UPPER(APEX_JSON.get_varchar2(p_path=>'code')));
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('id', l_id);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE = -1 THEN dct_rest.err(400,'Privilege code already exists');
  ELSIF SQLCODE = -20001 THEN dct_rest.err(400, SQLERRM);
  ELSE dct_rest.err(500, SQLERRM); END IF;
END;!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'dct.admin',
    p_pattern=>REPLACE('sec/privileges/[COLON]id','[COLON]',CHR(58)));
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin',
    p_pattern=>REPLACE('sec/privileges/[COLON]id','[COLON]',CHR(58)),
    p_method=>'PUT', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_raw RAW(32767); l_json VARCHAR2(32767);
  l_name VARCHAR2(200); l_verb VARCHAR2(30); l_mid NUMBER; l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
  END IF;
  SELECT COUNT(*) INTO l_n FROM dct_permissions WHERE permission_id = [COLON]id;
  IF l_n = 0 THEN dct_rest.err(404,'Privilege not found'); RETURN; END IF;
  l_raw  := DBMS_LOB.SUBSTR([COLON]body, 32767, 1);
  l_json := UTL_RAW.CAST_TO_VARCHAR2(l_raw);
  APEX_JSON.parse(l_json);
  l_name := APEX_JSON.get_varchar2(p_path=>'name');
  IF l_name IS NOT NULL THEN
    l_verb := UPPER(REGEXP_SUBSTR(TRIM(l_name), '^\S+'));
    IF l_verb NOT IN ('VIEW','CREATE','EDIT','DELETE','APPROVE','RUN','MANAGE',
                      'EXPORT','CONFIGURE','SUBMIT','GENERATE','ASSIGN','POST','PRINT') THEN
      dct_rest.err(400,'Privilege name must start with a verb (View, Edit, Delete, Run, Manage...)');
      RETURN;
    END IF;
  END IF;
  IF APEX_JSON.does_exist(p_path=>'module') THEN
    SELECT MAX(module_id) INTO l_mid FROM dct_modules
     WHERE module_code = UPPER(APEX_JSON.get_varchar2(p_path=>'module'));
  END IF;
  UPDATE dct_permissions SET
     permission_name    = NVL(l_name, permission_name),
     verb               = NVL(l_verb, verb),
     permission_name_ar = CASE WHEN APEX_JSON.does_exist(p_path=>'nameAr')
                          THEN APEX_JSON.get_varchar2(p_path=>'nameAr') ELSE permission_name_ar END,
     action_type        = NVL(UPPER(APEX_JSON.get_varchar2(p_path=>'actionType')), action_type),
     module_id          = CASE WHEN APEX_JSON.does_exist(p_path=>'module') THEN l_mid ELSE module_id END,
     description_en     = CASE WHEN APEX_JSON.does_exist(p_path=>'description')
                          THEN APEX_JSON.get_varchar2(p_path=>'description') ELSE description_en END,
     is_active          = NVL(UPPER(APEX_JSON.get_varchar2(p_path=>'isActive')), is_active),
     updated_by         = l_user,
     updated_at         = SYSTIMESTAMP
   WHERE permission_id = [COLON]id;
  dct_sec.refresh_flat;
  dct_audit_pkg.log(l_user,'UPDATE','SEC_PRIVILEGE',TO_CHAR([COLON]id),'ADMIN');
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  dct_rest.err(500, SQLERRM);
END;!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin',
    p_pattern=>REPLACE('sec/privileges/[COLON]id','[COLON]',CHR(58)),
    p_method=>'DELETE', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
  END IF;
  UPDATE dct_permissions SET is_active='N', updated_by=l_user, updated_at=SYSTIMESTAMP
   WHERE permission_id = [COLON]id;
  IF SQL%ROWCOUNT = 0 THEN dct_rest.err(404,'Privilege not found'); RETURN; END IF;
  dct_sec.refresh_flat;
  dct_audit_pkg.log(l_user,'DELETE','SEC_PRIVILEGE',TO_CHAR([COLON]id),'ADMIN');
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  dct_rest.err(500, SQLERRM);
END;!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'dct.admin', p_pattern=>'sec/groups');
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin', p_pattern=>'sec/groups',
    p_method=>'GET', p_source_type=>ORDS.source_type_plsql,
    p_items_per_page=>0, p_source=>q'!
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
  FOR r IN (
    SELECT g.group_id, g.group_code, g.name_en, g.name_ar, g.description_en,
           g.is_active, m.module_code,
           g.created_by, g.created_at, g.updated_by, g.updated_at,
           (SELECT COUNT(*) FROM dct_sec_priv_group_item gi WHERE gi.group_id = g.group_id) AS priv_count,
           (SELECT COUNT(*) FROM dct_sec_role_priv_group rg WHERE rg.group_id = g.group_id) AS role_count
      FROM dct_sec_priv_group g
      LEFT JOIN dct_modules m ON m.module_id = g.module_id
     WHERE (:search IS NULL OR UPPER(g.group_code) LIKE '%'||UPPER(:search)||'%'
            OR UPPER(g.name_en) LIKE '%'||UPPER(:search)||'%')
       AND (NVL(:inactive,'N') = 'Y' OR g.is_active = 'Y')
     ORDER BY g.display_order, g.group_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id', r.group_id);
    APEX_JSON.write('code', r.group_code);
    APEX_JSON.write('name', r.name_en);
    APEX_JSON.write('nameAr', r.name_ar);
    APEX_JSON.write('module', r.module_code);
    APEX_JSON.write('description', r.description_en);
    APEX_JSON.write('isActive', r.is_active);
    APEX_JSON.write('privCount', r.priv_count);
    APEX_JSON.write('roleCount', r.role_count);
    APEX_JSON.write('createdBy', r.created_by);
    APEX_JSON.write('createdAt', TO_CHAR(dct_to_local(r.created_at),'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.write('updatedBy', r.updated_by);
    APEX_JSON.write('updatedAt', TO_CHAR(dct_to_local(r.updated_at),'YYYY-MM-DD HH:MI AM'));
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
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin', p_pattern=>'sec/groups',
    p_method=>'POST', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_raw RAW(32767); l_json VARCHAR2(32767);
  l_id NUMBER; l_mid NUMBER; l_cnt NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
  END IF;
  l_raw  := DBMS_LOB.SUBSTR([COLON]body, 32767, 1);
  l_json := UTL_RAW.CAST_TO_VARCHAR2(l_raw);
  APEX_JSON.parse(l_json);
  IF APEX_JSON.get_varchar2(p_path=>'code') IS NULL
     OR APEX_JSON.get_varchar2(p_path=>'name') IS NULL THEN
    dct_rest.err(400,'code and name are required'); RETURN;
  END IF;
  IF APEX_JSON.get_varchar2(p_path=>'module') IS NOT NULL THEN
    SELECT MAX(module_id) INTO l_mid FROM dct_modules
     WHERE module_code = UPPER(APEX_JSON.get_varchar2(p_path=>'module'));
  END IF;
  INSERT INTO dct_sec_priv_group
      (group_code, name_en, name_ar, module_id, description_en, created_by)
  VALUES (UPPER(APEX_JSON.get_varchar2(p_path=>'code')),
       APEX_JSON.get_varchar2(p_path=>'name'),
       APEX_JSON.get_varchar2(p_path=>'nameAr'), l_mid,
       APEX_JSON.get_varchar2(p_path=>'description'), l_user)
  RETURNING group_id INTO l_id;
  l_cnt := APEX_JSON.get_count(p_path=>'permIds');
  IF l_cnt IS NOT NULL THEN
    FOR i IN 1..l_cnt LOOP
      INSERT INTO dct_sec_priv_group_item (group_id, permission_id, added_by)
      VALUES (l_id, APEX_JSON.get_number(p_path=>'permIds[%d]', p0=>i), l_user);
    END LOOP;
  END IF;
  dct_sec.refresh_flat;
  dct_audit_pkg.log(l_user,'CREATE','SEC_PRIV_GROUP',TO_CHAR(l_id),'ADMIN',
      UPPER(APEX_JSON.get_varchar2(p_path=>'code')));
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('id', l_id);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE = -1 THEN dct_rest.err(400,'Group code already exists');
  ELSE dct_rest.err(500, SQLERRM); END IF;
END;!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'dct.admin',
    p_pattern=>REPLACE('sec/groups/[COLON]id','[COLON]',CHR(58)));
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin',
    p_pattern=>REPLACE('sec/groups/[COLON]id','[COLON]',CHR(58)),
    p_method=>'GET', p_source_type=>ORDS.source_type_plsql,
    p_items_per_page=>0, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
  END IF;
  SELECT COUNT(*) INTO l_n FROM dct_sec_priv_group WHERE group_id = [COLON]id;
  IF l_n = 0 THEN dct_rest.err(404,'Group not found'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  FOR r IN (SELECT g.group_id, g.group_code, g.name_en, g.name_ar,
                   g.description_en, g.is_active, m.module_code
              FROM dct_sec_priv_group g
              LEFT JOIN dct_modules m ON m.module_id = g.module_id
             WHERE g.group_id = [COLON]id) LOOP
    APEX_JSON.write('id', r.group_id);
    APEX_JSON.write('code', r.group_code);
    APEX_JSON.write('name', r.name_en);
    APEX_JSON.write('nameAr', r.name_ar);
    APEX_JSON.write('module', r.module_code);
    APEX_JSON.write('description', r.description_en);
    APEX_JSON.write('isActive', r.is_active);
  END LOOP;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT p.permission_id, p.permission_code, p.permission_name, m.module_code
              FROM dct_sec_priv_group_item gi
              JOIN dct_permissions p ON p.permission_id = gi.permission_id
              LEFT JOIN dct_modules m ON m.module_id = p.module_id
             WHERE gi.group_id = [COLON]id
             ORDER BY p.permission_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id', r.permission_id);
    APEX_JSON.write('code', r.permission_code);
    APEX_JSON.write('name', r.permission_name);
    APEX_JSON.write('module', r.module_code);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  dct_rest.err(500, SQLERRM);
END;!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin',
    p_pattern=>REPLACE('sec/groups/[COLON]id','[COLON]',CHR(58)),
    p_method=>'PUT', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_raw RAW(32767); l_json VARCHAR2(32767);
  l_n NUMBER; l_mid NUMBER; l_cnt NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
  END IF;
  SELECT COUNT(*) INTO l_n FROM dct_sec_priv_group WHERE group_id = [COLON]id;
  IF l_n = 0 THEN dct_rest.err(404,'Group not found'); RETURN; END IF;
  l_raw  := DBMS_LOB.SUBSTR([COLON]body, 32767, 1);
  l_json := UTL_RAW.CAST_TO_VARCHAR2(l_raw);
  APEX_JSON.parse(l_json);
  IF APEX_JSON.does_exist(p_path=>'module') THEN
    SELECT MAX(module_id) INTO l_mid FROM dct_modules
     WHERE module_code = UPPER(APEX_JSON.get_varchar2(p_path=>'module'));
  END IF;
  UPDATE dct_sec_priv_group SET
     name_en        = NVL(APEX_JSON.get_varchar2(p_path=>'name'), name_en),
     name_ar        = CASE WHEN APEX_JSON.does_exist(p_path=>'nameAr')
                      THEN APEX_JSON.get_varchar2(p_path=>'nameAr') ELSE name_ar END,
     module_id      = CASE WHEN APEX_JSON.does_exist(p_path=>'module') THEN l_mid ELSE module_id END,
     description_en = CASE WHEN APEX_JSON.does_exist(p_path=>'description')
                      THEN APEX_JSON.get_varchar2(p_path=>'description') ELSE description_en END,
     is_active      = NVL(UPPER(APEX_JSON.get_varchar2(p_path=>'isActive')), is_active),
     updated_by     = l_user,
     updated_at     = SYSTIMESTAMP
   WHERE group_id = [COLON]id;
  IF APEX_JSON.does_exist(p_path=>'permIds') THEN
    DELETE FROM dct_sec_priv_group_item WHERE group_id = [COLON]id;
    l_cnt := APEX_JSON.get_count(p_path=>'permIds');
    IF l_cnt IS NOT NULL THEN
      FOR i IN 1..l_cnt LOOP
        INSERT INTO dct_sec_priv_group_item (group_id, permission_id, added_by)
        VALUES ([COLON]id, APEX_JSON.get_number(p_path=>'permIds[%d]', p0=>i), l_user);
      END LOOP;
    END IF;
  END IF;
  dct_sec.refresh_flat;
  dct_audit_pkg.log(l_user,'UPDATE','SEC_PRIV_GROUP',TO_CHAR([COLON]id),'ADMIN');
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  dct_rest.err(500, SQLERRM);
END;!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin',
    p_pattern=>REPLACE('sec/groups/[COLON]id','[COLON]',CHR(58)),
    p_method=>'DELETE', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
  END IF;
  UPDATE dct_sec_priv_group SET is_active='N', updated_by=l_user, updated_at=SYSTIMESTAMP
   WHERE group_id = [COLON]id;
  IF SQL%ROWCOUNT = 0 THEN dct_rest.err(404,'Group not found'); RETURN; END IF;
  dct_sec.refresh_flat;
  dct_audit_pkg.log(l_user,'DELETE','SEC_PRIV_GROUP',TO_CHAR([COLON]id),'ADMIN');
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  dct_rest.err(500, SQLERRM);
END;!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'dct.admin', p_pattern=>'sec/roles');
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin', p_pattern=>'sec/roles',
    p_method=>'GET', p_source_type=>ORDS.source_type_plsql,
    p_items_per_page=>0, p_source=>q'!
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
  FOR r IN (
    SELECT ro.role_id, ro.role_code, ro.role_name_en, ro.role_name_ar,
           ro.role_category, ro.role_type, ro.is_system_role, ro.is_active,
           ro.description_en, ro.created_from_role_id, m.module_code,
           ro.created_by, ro.created_at, ro.updated_by, ro.updated_at,
           src.role_code AS copied_from,
           (SELECT COUNT(*) FROM dct_user_roles ur
             WHERE ur.role_id = ro.role_id AND ur.is_active='Y') AS member_count,
           (SELECT COUNT(*) FROM dct_sec_role_hierarchy h
             WHERE h.parent_role_id = ro.role_id) AS duty_count,
           (SELECT COUNT(DISTINCT f.permission_id) FROM dct_sec_role_priv_flat f
             WHERE f.role_id = ro.role_id) AS priv_count
      FROM dct_roles ro
      LEFT JOIN dct_modules m ON m.module_id = ro.module_id
      LEFT JOIN dct_roles src ON src.role_id = ro.created_from_role_id
     WHERE (:category IS NULL OR ro.role_category = UPPER(:category))
       AND (:search IS NULL OR UPPER(ro.role_code) LIKE '%'||UPPER(:search)||'%'
            OR UPPER(ro.role_name_en) LIKE '%'||UPPER(:search)||'%')
       AND (NVL(:inactive,'N') = 'Y' OR ro.is_active = 'Y')
       AND ro.role_type <> 'DATA'
     ORDER BY ro.role_category, m.module_code NULLS FIRST, ro.role_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id', r.role_id);
    APEX_JSON.write('code', r.role_code);
    APEX_JSON.write('name', r.role_name_en);
    APEX_JSON.write('nameAr', r.role_name_ar);
    APEX_JSON.write('category', r.role_category);
    APEX_JSON.write('type', r.role_type);
    APEX_JSON.write('module', r.module_code);
    APEX_JSON.write('isSystem', r.is_system_role);
    APEX_JSON.write('isActive', r.is_active);
    APEX_JSON.write('description', r.description_en);
    APEX_JSON.write('copiedFrom', r.copied_from);
    APEX_JSON.write('memberCount', r.member_count);
    APEX_JSON.write('dutyCount', r.duty_count);
    APEX_JSON.write('privCount', r.priv_count);
    APEX_JSON.write('createdBy', r.created_by);
    APEX_JSON.write('createdAt', TO_CHAR(dct_to_local(r.created_at),'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.write('updatedBy', r.updated_by);
    APEX_JSON.write('updatedAt', TO_CHAR(dct_to_local(r.updated_at),'YYYY-MM-DD HH:MI AM'));
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
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin', p_pattern=>'sec/roles',
    p_method=>'POST', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_raw RAW(32767); l_json VARCHAR2(32767);
  l_id NUMBER; l_mid NUMBER; l_cat VARCHAR2(10);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
  END IF;
  l_raw  := DBMS_LOB.SUBSTR([COLON]body, 32767, 1);
  l_json := UTL_RAW.CAST_TO_VARCHAR2(l_raw);
  APEX_JSON.parse(l_json);
  l_cat := UPPER(NVL(APEX_JSON.get_varchar2(p_path=>'category'),'JOB'));
  IF l_cat NOT IN ('ABSTRACT','DUTY','JOB') THEN
    dct_rest.err(400,'category must be ABSTRACT, DUTY or JOB'); RETURN;
  END IF;
  IF APEX_JSON.get_varchar2(p_path=>'code') IS NULL
     OR APEX_JSON.get_varchar2(p_path=>'name') IS NULL THEN
    dct_rest.err(400,'code and name are required'); RETURN;
  END IF;
  IF APEX_JSON.get_varchar2(p_path=>'module') IS NOT NULL THEN
    SELECT MAX(module_id) INTO l_mid FROM dct_modules
     WHERE module_code = UPPER(APEX_JSON.get_varchar2(p_path=>'module'));
  END IF;
  INSERT INTO dct_roles
      (role_code, role_name_en, role_name_ar, role_type, role_category,
       module_id, description_en, created_by)
  VALUES (UPPER(APEX_JSON.get_varchar2(p_path=>'code')),
       APEX_JSON.get_varchar2(p_path=>'name'),
       APEX_JSON.get_varchar2(p_path=>'nameAr'),
       CASE WHEN l_cat = 'ABSTRACT' THEN 'SYSTEM' ELSE 'MODULE' END,
       l_cat, l_mid,
       APEX_JSON.get_varchar2(p_path=>'description'), l_user)
  RETURNING role_id INTO l_id;
  dct_sec.refresh_flat;
  dct_audit_pkg.log(l_user,'CREATE','SEC_ROLE',TO_CHAR(l_id),'ADMIN',
      UPPER(APEX_JSON.get_varchar2(p_path=>'code')));
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('id', l_id);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE = -1 THEN dct_rest.err(400,'Role code already exists');
  ELSE dct_rest.err(500, SQLERRM); END IF;
END;!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'dct.admin',
    p_pattern=>REPLACE('sec/roles/[COLON]id','[COLON]',CHR(58)));
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin',
    p_pattern=>REPLACE('sec/roles/[COLON]id','[COLON]',CHR(58)),
    p_method=>'GET', p_source_type=>ORDS.source_type_plsql,
    p_items_per_page=>0, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
  END IF;
  SELECT COUNT(*) INTO l_n FROM dct_roles WHERE role_id = [COLON]id;
  IF l_n = 0 THEN dct_rest.err(404,'Role not found'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  FOR r IN (SELECT ro.role_id, ro.role_code, ro.role_name_en, ro.role_name_ar,
                   ro.role_category, ro.role_type, ro.is_system_role, ro.is_active,
                   ro.description_en, m.module_code, src.role_code AS copied_from
              FROM dct_roles ro
              LEFT JOIN dct_modules m ON m.module_id = ro.module_id
              LEFT JOIN dct_roles src ON src.role_id = ro.created_from_role_id
             WHERE ro.role_id = [COLON]id) LOOP
    APEX_JSON.write('id', r.role_id);
    APEX_JSON.write('code', r.role_code);
    APEX_JSON.write('name', r.role_name_en);
    APEX_JSON.write('nameAr', r.role_name_ar);
    APEX_JSON.write('category', r.role_category);
    APEX_JSON.write('type', r.role_type);
    APEX_JSON.write('module', r.module_code);
    APEX_JSON.write('isSystem', r.is_system_role);
    APEX_JSON.write('isActive', r.is_active);
    APEX_JSON.write('description', r.description_en);
    APEX_JSON.write('copiedFrom', r.copied_from);
  END LOOP;
  APEX_JSON.open_array('permIds');
  FOR r IN (SELECT permission_id FROM dct_role_permissions WHERE role_id = [COLON]id) LOOP
    APEX_JSON.write(r.permission_id);
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('groupIds');
  FOR r IN (SELECT group_id FROM dct_sec_role_priv_group WHERE role_id = [COLON]id) LOOP
    APEX_JSON.write(r.group_id);
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('duties');
  FOR r IN (SELECT h.child_role_id, ro.role_code, ro.role_name_en
              FROM dct_sec_role_hierarchy h
              JOIN dct_roles ro ON ro.role_id = h.child_role_id
             WHERE h.parent_role_id = [COLON]id ORDER BY ro.role_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id', r.child_role_id);
    APEX_JSON.write('code', r.role_code);
    APEX_JSON.write('name', r.role_name_en);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('parents');
  FOR r IN (SELECT h.parent_role_id, ro.role_code, ro.role_name_en, ro.role_category
              FROM dct_sec_role_hierarchy h
              JOIN dct_roles ro ON ro.role_id = h.parent_role_id
             WHERE h.child_role_id = [COLON]id ORDER BY ro.role_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id', r.parent_role_id);
    APEX_JSON.write('code', r.role_code);
    APEX_JSON.write('name', r.role_name_en);
    APEX_JSON.write('category', r.role_category);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('exclusions');
  FOR r IN (SELECT x.exclusion_id, x.permission_id, p.permission_code,
                   p.permission_name, x.reason
              FROM dct_sec_exclusion x
              JOIN dct_permissions p ON p.permission_id = x.permission_id
             WHERE x.scope_type='ROLE' AND x.role_id = [COLON]id AND x.is_active='Y'
             ORDER BY p.permission_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id', r.exclusion_id);
    APEX_JSON.write('permId', r.permission_id);
    APEX_JSON.write('permCode', r.permission_code);
    APEX_JSON.write('permName', r.permission_name);
    APEX_JSON.write('reason', r.reason);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('effective');
  FOR r IN (SELECT DISTINCT p.permission_id, p.permission_code, p.permission_name,
                   m.module_code
              FROM dct_sec_role_priv_flat f
              JOIN dct_permissions p ON p.permission_id = f.permission_id
              LEFT JOIN dct_modules m ON m.module_id = p.module_id
             WHERE f.role_id = [COLON]id AND p.is_active='Y'
             ORDER BY m.module_code NULLS FIRST, p.permission_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id', r.permission_id);
    APEX_JSON.write('code', r.permission_code);
    APEX_JSON.write('name', r.permission_name);
    APEX_JSON.write('module', r.module_code);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  dct_rest.err(500, SQLERRM);
END;!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin',
    p_pattern=>REPLACE('sec/roles/[COLON]id','[COLON]',CHR(58)),
    p_method=>'PUT', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_raw RAW(32767); l_json VARCHAR2(32767);
  l_n NUMBER; l_cnt NUMBER; l_want NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
  END IF;
  SELECT COUNT(*) INTO l_n FROM dct_roles WHERE role_id = [COLON]id;
  IF l_n = 0 THEN dct_rest.err(404,'Role not found'); RETURN; END IF;
  l_raw  := DBMS_LOB.SUBSTR([COLON]body, 32767, 1);
  l_json := UTL_RAW.CAST_TO_VARCHAR2(l_raw);
  APEX_JSON.parse(l_json);
  UPDATE dct_roles SET
     role_name_en   = NVL(APEX_JSON.get_varchar2(p_path=>'name'), role_name_en),
     role_name_ar   = CASE WHEN APEX_JSON.does_exist(p_path=>'nameAr')
                      THEN APEX_JSON.get_varchar2(p_path=>'nameAr') ELSE role_name_ar END,
     description_en = CASE WHEN APEX_JSON.does_exist(p_path=>'description')
                      THEN APEX_JSON.get_varchar2(p_path=>'description') ELSE description_en END,
     is_active      = NVL(UPPER(APEX_JSON.get_varchar2(p_path=>'isActive')), is_active),
     updated_by     = l_user,
     updated_at     = SYSTIMESTAMP
   WHERE role_id = [COLON]id;
  IF APEX_JSON.does_exist(p_path=>'permIds') THEN
    DELETE FROM dct_role_permissions WHERE role_id = [COLON]id;
    l_cnt := APEX_JSON.get_count(p_path=>'permIds');
    IF l_cnt IS NOT NULL THEN
      FOR i IN 1..l_cnt LOOP
        INSERT INTO dct_role_permissions (role_id, permission_id, granted_by)
        VALUES ([COLON]id, APEX_JSON.get_number(p_path=>'permIds[%d]', p0=>i), l_user);
      END LOOP;
    END IF;
  END IF;
  IF APEX_JSON.does_exist(p_path=>'groupIds') THEN
    DELETE FROM dct_sec_role_priv_group WHERE role_id = [COLON]id;
    l_cnt := APEX_JSON.get_count(p_path=>'groupIds');
    IF l_cnt IS NOT NULL THEN
      FOR i IN 1..l_cnt LOOP
        INSERT INTO dct_sec_role_priv_group (role_id, group_id, granted_by)
        VALUES ([COLON]id, APEX_JSON.get_number(p_path=>'groupIds[%d]', p0=>i), l_user);
      END LOOP;
    END IF;
  END IF;
  IF APEX_JSON.does_exist(p_path=>'dutyIds') THEN
    l_cnt := APEX_JSON.get_count(p_path=>'dutyIds');
    FOR r IN (SELECT child_role_id FROM dct_sec_role_hierarchy
               WHERE parent_role_id = [COLON]id) LOOP
      l_n := 0;
      IF l_cnt IS NOT NULL THEN
        FOR i IN 1..l_cnt LOOP
          IF APEX_JSON.get_number(p_path=>'dutyIds[%d]', p0=>i) = r.child_role_id THEN
            l_n := 1;
          END IF;
        END LOOP;
      END IF;
      IF l_n = 0 THEN
        dct_sec.remove_hierarchy([COLON]id, r.child_role_id);
      END IF;
    END LOOP;
    IF l_cnt IS NOT NULL THEN
      FOR i IN 1..l_cnt LOOP
        l_want := APEX_JSON.get_number(p_path=>'dutyIds[%d]', p0=>i);
        SELECT COUNT(*) INTO l_n FROM dct_sec_role_hierarchy
         WHERE parent_role_id = [COLON]id AND child_role_id = l_want;
        IF l_n = 0 THEN
          dct_sec.add_hierarchy([COLON]id, l_want, l_user);
        END IF;
      END LOOP;
    END IF;
  END IF;
  IF APEX_JSON.does_exist(p_path=>'exclusionPermIds') THEN
    l_cnt := APEX_JSON.get_count(p_path=>'exclusionPermIds');
    UPDATE dct_sec_exclusion SET is_active='N', ended_by=l_user, ended_at=SYSTIMESTAMP
     WHERE scope_type='ROLE' AND role_id = [COLON]id AND is_active='Y';
    IF l_cnt IS NOT NULL THEN
      FOR i IN 1..l_cnt LOOP
        INSERT INTO dct_sec_exclusion (scope_type, role_id, permission_id, reason, created_by)
        VALUES ('ROLE', [COLON]id,
                APEX_JSON.get_number(p_path=>'exclusionPermIds[%d]', p0=>i),
                APEX_JSON.get_varchar2(p_path=>'exclusionReason'), l_user);
      END LOOP;
    END IF;
  END IF;
  dct_sec.refresh_flat;
  dct_audit_pkg.log(l_user,'UPDATE','SEC_ROLE',TO_CHAR([COLON]id),'ADMIN');
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
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

BEGIN
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin',
    p_pattern=>REPLACE('sec/roles/[COLON]id','[COLON]',CHR(58)),
    p_method=>'DELETE', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_sys VARCHAR2(1);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
  END IF;
  BEGIN
    SELECT is_system_role INTO l_sys FROM dct_roles WHERE role_id = [COLON]id;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    dct_rest.err(404,'Role not found'); RETURN;
  END;
  IF l_sys = 'Y' THEN dct_rest.err(400,'System roles cannot be deleted'); RETURN; END IF;
  UPDATE dct_roles SET is_active='N', updated_by=l_user, updated_at=SYSTIMESTAMP
   WHERE role_id = [COLON]id;
  dct_sec.refresh_flat;
  dct_audit_pkg.log(l_user,'DELETE','SEC_ROLE',TO_CHAR([COLON]id),'ADMIN');
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  dct_rest.err(500, SQLERRM);
END;!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'dct.admin',
    p_pattern=>REPLACE('sec/roles/[COLON]id/copy','[COLON]',CHR(58)));
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin',
    p_pattern=>REPLACE('sec/roles/[COLON]id/copy','[COLON]',CHR(58)),
    p_method=>'POST', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_raw RAW(32767); l_json VARCHAR2(32767); l_new NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
  END IF;
  l_raw  := DBMS_LOB.SUBSTR([COLON]body, 32767, 1);
  l_json := UTL_RAW.CAST_TO_VARCHAR2(l_raw);
  APEX_JSON.parse(l_json);
  IF APEX_JSON.get_varchar2(p_path=>'code') IS NULL
     OR APEX_JSON.get_varchar2(p_path=>'name') IS NULL THEN
    dct_rest.err(400,'code and name are required'); RETURN;
  END IF;
  l_new := dct_sec.copy_role([COLON]id,
      APEX_JSON.get_varchar2(p_path=>'code'),
      APEX_JSON.get_varchar2(p_path=>'name'),
      APEX_JSON.get_varchar2(p_path=>'nameAr'), l_user);
  dct_audit_pkg.log(l_user,'CREATE','SEC_ROLE',TO_CHAR(l_new),'ADMIN',
      'copy of role ' || [COLON]id);
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('id', l_new);
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

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'dct.admin', p_pattern=>'sec/profiles');
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin', p_pattern=>'sec/profiles',
    p_method=>'GET', p_source_type=>ORDS.source_type_plsql,
    p_items_per_page=>0, p_source=>q'!
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
  FOR r IN (
    SELECT p.profile_id, p.profile_code, p.name_en, p.name_ar,
           p.description_en, p.is_active,
           p.created_by, p.created_at, p.updated_by, p.updated_at,
           (SELECT COUNT(*) FROM dct_sec_profile_scope s WHERE s.profile_id = p.profile_id) AS scope_count,
           (SELECT COUNT(*) FROM dct_sec_user_profile up
             WHERE up.profile_id = p.profile_id AND up.is_active='Y'
               AND TRUNC(SYSDATE) >= TRUNC(up.start_date)
               AND (up.end_date IS NULL OR TRUNC(SYSDATE) <= TRUNC(up.end_date))) AS user_count
      FROM dct_sec_profile p
     WHERE (:search IS NULL OR UPPER(p.profile_code) LIKE '%'||UPPER(:search)||'%'
            OR UPPER(p.name_en) LIKE '%'||UPPER(:search)||'%')
       AND (NVL(:inactive,'N') = 'Y' OR p.is_active = 'Y')
     ORDER BY p.profile_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id', r.profile_id);
    APEX_JSON.write('code', r.profile_code);
    APEX_JSON.write('name', r.name_en);
    APEX_JSON.write('nameAr', r.name_ar);
    APEX_JSON.write('description', r.description_en);
    APEX_JSON.write('isActive', r.is_active);
    APEX_JSON.write('scopeCount', r.scope_count);
    APEX_JSON.write('userCount', r.user_count);
    APEX_JSON.write('createdBy', r.created_by);
    APEX_JSON.write('createdAt', TO_CHAR(dct_to_local(r.created_at),'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.write('updatedBy', r.updated_by);
    APEX_JSON.write('updatedAt', TO_CHAR(dct_to_local(r.updated_at),'YYYY-MM-DD HH:MI AM'));
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
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin', p_pattern=>'sec/profiles',
    p_method=>'POST', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_raw RAW(32767); l_json VARCHAR2(32767); l_id NUMBER; l_cnt NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
  END IF;
  l_raw  := DBMS_LOB.SUBSTR([COLON]body, 32767, 1);
  l_json := UTL_RAW.CAST_TO_VARCHAR2(l_raw);
  APEX_JSON.parse(l_json);
  IF APEX_JSON.get_varchar2(p_path=>'code') IS NULL
     OR APEX_JSON.get_varchar2(p_path=>'name') IS NULL THEN
    dct_rest.err(400,'code and name are required'); RETURN;
  END IF;
  INSERT INTO dct_sec_profile (profile_code, name_en, name_ar, description_en, created_by)
  VALUES (UPPER(APEX_JSON.get_varchar2(p_path=>'code')),
       APEX_JSON.get_varchar2(p_path=>'name'),
       APEX_JSON.get_varchar2(p_path=>'nameAr'),
       APEX_JSON.get_varchar2(p_path=>'description'), l_user)
  RETURNING profile_id INTO l_id;
  l_cnt := APEX_JSON.get_count(p_path=>'scopes');
  IF l_cnt IS NOT NULL THEN
    FOR i IN 1..l_cnt LOOP
      INSERT INTO dct_sec_profile_scope
          (profile_id, object_type_code, object_key, object_key2,
           object_label, include_children, created_by)
      VALUES (l_id,
           UPPER(APEX_JSON.get_varchar2(p_path=>'scopes[%d].objectType', p0=>i)),
           TRIM(APEX_JSON.get_varchar2(p_path=>'scopes[%d].objectKey', p0=>i)),
           APEX_JSON.get_varchar2(p_path=>'scopes[%d].objectKey2', p0=>i),
           APEX_JSON.get_varchar2(p_path=>'scopes[%d].label', p0=>i),
           NVL(APEX_JSON.get_varchar2(p_path=>'scopes[%d].includeChildren', p0=>i),'N'),
           l_user);
    END LOOP;
  END IF;
  dct_sec.bump_version;
  dct_audit_pkg.log(l_user,'CREATE','SEC_PROFILE',TO_CHAR(l_id),'ADMIN',
      UPPER(APEX_JSON.get_varchar2(p_path=>'code')));
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('id', l_id);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE = -1 THEN dct_rest.err(400,'Profile code already exists');
  ELSIF SQLCODE = -2291 THEN dct_rest.err(400,'Unknown scope dimension');
  ELSE dct_rest.err(500, SQLERRM); END IF;
END;!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'dct.admin',
    p_pattern=>REPLACE('sec/profiles/[COLON]id','[COLON]',CHR(58)));
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin',
    p_pattern=>REPLACE('sec/profiles/[COLON]id','[COLON]',CHR(58)),
    p_method=>'GET', p_source_type=>ORDS.source_type_plsql,
    p_items_per_page=>0, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
  END IF;
  SELECT COUNT(*) INTO l_n FROM dct_sec_profile WHERE profile_id = [COLON]id;
  IF l_n = 0 THEN dct_rest.err(404,'Profile not found'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  FOR r IN (SELECT profile_id, profile_code, name_en, name_ar, description_en, is_active
              FROM dct_sec_profile WHERE profile_id = [COLON]id) LOOP
    APEX_JSON.write('id', r.profile_id);
    APEX_JSON.write('code', r.profile_code);
    APEX_JSON.write('name', r.name_en);
    APEX_JSON.write('nameAr', r.name_ar);
    APEX_JSON.write('description', r.description_en);
    APEX_JSON.write('isActive', r.is_active);
  END LOOP;
  APEX_JSON.open_array('scopes');
  FOR r IN (SELECT s.scope_id, s.object_type_code, ot.name_en AS type_name,
                   s.object_key, s.object_key2, s.object_label, s.include_children
              FROM dct_sec_profile_scope s
              JOIN dct_wf_object_type ot ON ot.object_type_code = s.object_type_code
             WHERE s.profile_id = [COLON]id
             ORDER BY ot.display_order, s.object_key) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id', r.scope_id);
    APEX_JSON.write('objectType', r.object_type_code);
    APEX_JSON.write('typeName', r.type_name);
    APEX_JSON.write('objectKey', r.object_key);
    APEX_JSON.write('objectKey2', r.object_key2);
    APEX_JSON.write('label', r.object_label);
    APEX_JSON.write('includeChildren', r.include_children);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('users');
  FOR r IN (SELECT up.up_id, up.user_id, u.display_name, u.username,
                   TO_CHAR(up.start_date,'YYYY-MM-DD') AS start_str,
                   TO_CHAR(up.end_date,'YYYY-MM-DD') AS end_str, up.is_active
              FROM dct_sec_user_profile up
              JOIN dct_users u ON u.user_id = up.user_id
             WHERE up.profile_id = [COLON]id AND up.is_active='Y'
             ORDER BY u.display_name) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('upId', r.up_id);
    APEX_JSON.write('userId', r.user_id);
    APEX_JSON.write('name', r.display_name);
    APEX_JSON.write('username', r.username);
    APEX_JSON.write('startDate', r.start_str);
    APEX_JSON.write('endDate', r.end_str);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  dct_rest.err(500, SQLERRM);
END;!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin',
    p_pattern=>REPLACE('sec/profiles/[COLON]id','[COLON]',CHR(58)),
    p_method=>'PUT', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_raw RAW(32767); l_json VARCHAR2(32767); l_n NUMBER; l_cnt NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
  END IF;
  SELECT COUNT(*) INTO l_n FROM dct_sec_profile WHERE profile_id = [COLON]id;
  IF l_n = 0 THEN dct_rest.err(404,'Profile not found'); RETURN; END IF;
  l_raw  := DBMS_LOB.SUBSTR([COLON]body, 32767, 1);
  l_json := UTL_RAW.CAST_TO_VARCHAR2(l_raw);
  APEX_JSON.parse(l_json);
  UPDATE dct_sec_profile SET
     name_en        = NVL(APEX_JSON.get_varchar2(p_path=>'name'), name_en),
     name_ar        = CASE WHEN APEX_JSON.does_exist(p_path=>'nameAr')
                      THEN APEX_JSON.get_varchar2(p_path=>'nameAr') ELSE name_ar END,
     description_en = CASE WHEN APEX_JSON.does_exist(p_path=>'description')
                      THEN APEX_JSON.get_varchar2(p_path=>'description') ELSE description_en END,
     is_active      = NVL(UPPER(APEX_JSON.get_varchar2(p_path=>'isActive')), is_active),
     updated_by     = l_user,
     updated_at     = SYSTIMESTAMP
   WHERE profile_id = [COLON]id;
  IF APEX_JSON.does_exist(p_path=>'scopes') THEN
    DELETE FROM dct_sec_profile_scope WHERE profile_id = [COLON]id;
    l_cnt := APEX_JSON.get_count(p_path=>'scopes');
    IF l_cnt IS NOT NULL THEN
      FOR i IN 1..l_cnt LOOP
        INSERT INTO dct_sec_profile_scope
            (profile_id, object_type_code, object_key, object_key2,
             object_label, include_children, created_by)
        VALUES ([COLON]id,
             UPPER(APEX_JSON.get_varchar2(p_path=>'scopes[%d].objectType', p0=>i)),
             TRIM(APEX_JSON.get_varchar2(p_path=>'scopes[%d].objectKey', p0=>i)),
             APEX_JSON.get_varchar2(p_path=>'scopes[%d].objectKey2', p0=>i),
             APEX_JSON.get_varchar2(p_path=>'scopes[%d].label', p0=>i),
             NVL(APEX_JSON.get_varchar2(p_path=>'scopes[%d].includeChildren', p0=>i),'N'),
             l_user);
      END LOOP;
    END IF;
  END IF;
  dct_sec.bump_version;
  dct_audit_pkg.log(l_user,'UPDATE','SEC_PROFILE',TO_CHAR([COLON]id),'ADMIN');
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE = -2291 THEN dct_rest.err(400,'Unknown scope dimension');
  ELSE dct_rest.err(500, SQLERRM); END IF;
END;!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin',
    p_pattern=>REPLACE('sec/profiles/[COLON]id','[COLON]',CHR(58)),
    p_method=>'DELETE', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
  END IF;
  UPDATE dct_sec_profile SET is_active='N', updated_by=l_user, updated_at=SYSTIMESTAMP
   WHERE profile_id = [COLON]id;
  IF SQL%ROWCOUNT = 0 THEN dct_rest.err(404,'Profile not found'); RETURN; END IF;
  dct_sec.bump_version;
  dct_audit_pkg.log(l_user,'DELETE','SEC_PROFILE',TO_CHAR([COLON]id),'ADMIN');
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  dct_rest.err(500, SQLERRM);
END;!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'dct.admin', p_pattern=>'sec/lov');
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin', p_pattern=>'sec/lov',
    p_method=>'GET', p_source_type=>ORDS.source_type_plsql,
    p_items_per_page=>0, p_source=>q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_cur  SYS_REFCURSOR;
  l_k VARCHAR2(200); l_l VARCHAR2(400); l_p VARCHAR2(200); l_x VARCHAR2(100);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
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
  ORDS.DEFINE_TEMPLATE(p_module_name=>'dct.admin',
    p_pattern=>REPLACE('sec/users/[COLON]id/security','[COLON]',CHR(58)));
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin',
    p_pattern=>REPLACE('sec/users/[COLON]id/security','[COLON]',CHR(58)),
    p_method=>'GET', p_source_type=>ORDS.source_type_plsql,
    p_items_per_page=>0, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
  END IF;
  SELECT COUNT(*) INTO l_n FROM dct_users WHERE user_id = [COLON]id;
  IF l_n = 0 THEN dct_rest.err(404,'User not found'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('roles');
  FOR r IN (SELECT ur.user_role_id, ur.role_id, ro.role_code, ro.role_name_en,
                   ro.role_category, m.module_code,
                   TO_CHAR(ur.start_date,'YYYY-MM-DD') AS start_str,
                   TO_CHAR(ur.end_date,'YYYY-MM-DD') AS end_str,
                   ur.reason, ur.assigned_by,
                   CASE WHEN ur.is_active = 'N' THEN 'VOID'
                        WHEN TRUNC(ur.start_date) > TRUNC(SYSDATE) THEN 'FUTURE'
                        WHEN ur.end_date IS NOT NULL AND TRUNC(ur.end_date) < TRUNC(SYSDATE) THEN 'ENDED'
                        ELSE 'ACTIVE' END AS row_status
              FROM dct_user_roles ur
              JOIN dct_roles ro ON ro.role_id = ur.role_id
              LEFT JOIN dct_modules m ON m.module_id = ro.module_id
             WHERE ur.user_id = [COLON]id
             ORDER BY ur.start_date DESC, ro.role_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('urId', r.user_role_id);
    APEX_JSON.write('roleId', r.role_id);
    APEX_JSON.write('code', r.role_code);
    APEX_JSON.write('name', r.role_name_en);
    APEX_JSON.write('category', r.role_category);
    APEX_JSON.write('module', r.module_code);
    APEX_JSON.write('startDate', r.start_str);
    APEX_JSON.write('endDate', r.end_str);
    APEX_JSON.write('status', r.row_status);
    APEX_JSON.write('reason', r.reason);
    APEX_JSON.write('assignedBy', r.assigned_by);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('profiles');
  FOR r IN (SELECT up.up_id, up.profile_id, p.profile_code, p.name_en,
                   TO_CHAR(up.start_date,'YYYY-MM-DD') AS start_str,
                   TO_CHAR(up.end_date,'YYYY-MM-DD') AS end_str,
                   CASE WHEN up.is_active = 'N' THEN 'VOID'
                        WHEN TRUNC(up.start_date) > TRUNC(SYSDATE) THEN 'FUTURE'
                        WHEN up.end_date IS NOT NULL AND TRUNC(up.end_date) < TRUNC(SYSDATE) THEN 'ENDED'
                        ELSE 'ACTIVE' END AS row_status,
                   (SELECT COUNT(*) FROM dct_sec_profile_scope s
                     WHERE s.profile_id = up.profile_id) AS scope_count
              FROM dct_sec_user_profile up
              JOIN dct_sec_profile p ON p.profile_id = up.profile_id
             WHERE up.user_id = [COLON]id
             ORDER BY up.start_date DESC) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('upId', r.up_id);
    APEX_JSON.write('profileId', r.profile_id);
    APEX_JSON.write('code', r.profile_code);
    APEX_JSON.write('name', r.name_en);
    APEX_JSON.write('startDate', r.start_str);
    APEX_JSON.write('endDate', r.end_str);
    APEX_JSON.write('status', r.row_status);
    APEX_JSON.write('scopeCount', r.scope_count);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('exclusions');
  FOR r IN (SELECT x.exclusion_id, x.permission_id, p.permission_code,
                   p.permission_name, x.reason,
                   TO_CHAR(dct_to_local(x.created_at),'YYYY-MM-DD HH:MI AM') AS created_str
              FROM dct_sec_exclusion x
              JOIN dct_permissions p ON p.permission_id = x.permission_id
             WHERE x.scope_type='USER' AND x.user_id = [COLON]id AND x.is_active='Y'
             ORDER BY p.permission_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id', r.exclusion_id);
    APEX_JSON.write('permId', r.permission_id);
    APEX_JSON.write('permCode', r.permission_code);
    APEX_JSON.write('permName', r.permission_name);
    APEX_JSON.write('reason', r.reason);
    APEX_JSON.write('createdAt', r.created_str);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  dct_rest.err(500, SQLERRM);
END;!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'dct.admin',
    p_pattern=>REPLACE('sec/users/[COLON]id/roles','[COLON]',CHR(58)));
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin',
    p_pattern=>REPLACE('sec/users/[COLON]id/roles','[COLON]',CHR(58)),
    p_method=>'POST', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_raw RAW(32767); l_json VARCHAR2(32767);
  l_op VARCHAR2(20); l_id NUMBER; l_start DATE; l_end DATE;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
  END IF;
  l_raw  := DBMS_LOB.SUBSTR([COLON]body, 32767, 1);
  l_json := UTL_RAW.CAST_TO_VARCHAR2(l_raw);
  APEX_JSON.parse(l_json);
  l_op := NVL(APEX_JSON.get_varchar2(p_path=>'op'), 'assign');
  IF l_op = 'end' THEN
    UPDATE dct_user_roles
       SET end_date = GREATEST(SYSDATE, start_date),
           updated_by = l_user, updated_at = SYSTIMESTAMP
     WHERE user_role_id = APEX_JSON.get_number(p_path=>'urId')
       AND user_id = [COLON]id;
    IF SQL%ROWCOUNT = 0 THEN dct_rest.err(404,'Assignment not found'); RETURN; END IF;
    dct_audit_pkg.log(l_user,'ROLE_REVOKE','SEC_USER_ROLE',
        TO_CHAR(APEX_JSON.get_number(p_path=>'urId')),'ADMIN','user '||[COLON]id);
  ELSE
    l_start := CASE WHEN APEX_JSON.get_varchar2(p_path=>'startDate') IS NOT NULL
               THEN TO_DATE(APEX_JSON.get_varchar2(p_path=>'startDate'),'YYYY-MM-DD') END;
    l_end   := CASE WHEN APEX_JSON.get_varchar2(p_path=>'endDate') IS NOT NULL
               THEN TO_DATE(APEX_JSON.get_varchar2(p_path=>'endDate'),'YYYY-MM-DD') END;
    INSERT INTO dct_user_roles (user_id, role_id, start_date, end_date, assigned_by, reason, created_by)
    VALUES ([COLON]id, APEX_JSON.get_number(p_path=>'roleId'),
         NVL(l_start, SYSDATE), l_end, l_user,
         APEX_JSON.get_varchar2(p_path=>'reason'), l_user)
    RETURNING user_role_id INTO l_id;
    dct_audit_pkg.log(l_user,'ROLE_ASSIGN','SEC_USER_ROLE',TO_CHAR(l_id),'ADMIN','user '||[COLON]id);
  END IF;
  dct_sec.bump_version;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE = -20001 THEN dct_rest.err(400, SQLERRM);
  ELSIF SQLCODE = -2291 THEN dct_rest.err(400,'Unknown user or role');
  ELSIF SQLCODE = -2290 THEN dct_rest.err(400,'End date must not be before start date');
  ELSE dct_rest.err(500, SQLERRM); END IF;
END;!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'dct.admin',
    p_pattern=>REPLACE('sec/users/[COLON]id/profiles','[COLON]',CHR(58)));
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin',
    p_pattern=>REPLACE('sec/users/[COLON]id/profiles','[COLON]',CHR(58)),
    p_method=>'POST', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_raw RAW(32767); l_json VARCHAR2(32767);
  l_op VARCHAR2(20); l_start DATE; l_end DATE;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
  END IF;
  l_raw  := DBMS_LOB.SUBSTR([COLON]body, 32767, 1);
  l_json := UTL_RAW.CAST_TO_VARCHAR2(l_raw);
  APEX_JSON.parse(l_json);
  l_op := NVL(APEX_JSON.get_varchar2(p_path=>'op'), 'assign');
  IF l_op = 'end' THEN
    UPDATE dct_sec_user_profile
       SET end_date = GREATEST(TRUNC(SYSDATE), start_date),
           ended_by = l_user, ended_at = SYSTIMESTAMP
     WHERE up_id = APEX_JSON.get_number(p_path=>'upId')
       AND user_id = [COLON]id;
    IF SQL%ROWCOUNT = 0 THEN dct_rest.err(404,'Profile assignment not found'); RETURN; END IF;
  ELSE
    l_start := CASE WHEN APEX_JSON.get_varchar2(p_path=>'startDate') IS NOT NULL
               THEN TO_DATE(APEX_JSON.get_varchar2(p_path=>'startDate'),'YYYY-MM-DD') END;
    l_end   := CASE WHEN APEX_JSON.get_varchar2(p_path=>'endDate') IS NOT NULL
               THEN TO_DATE(APEX_JSON.get_varchar2(p_path=>'endDate'),'YYYY-MM-DD') END;
    INSERT INTO dct_sec_user_profile (user_id, profile_id, start_date, end_date, assigned_by)
    VALUES ([COLON]id, APEX_JSON.get_number(p_path=>'profileId'),
         NVL(l_start, TRUNC(SYSDATE)), l_end, l_user);
  END IF;
  dct_sec.bump_version;
  dct_audit_pkg.log(l_user, CASE WHEN l_op='end' THEN 'UPDATE' ELSE 'CREATE' END,
      'SEC_USER_PROFILE', TO_CHAR([COLON]id), 'ADMIN');
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE = -2291 THEN dct_rest.err(400,'Unknown user or profile');
  ELSIF SQLCODE = -2290 THEN dct_rest.err(400,'End date must not be before start date');
  ELSE dct_rest.err(500, SQLERRM); END IF;
END;!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'dct.admin',
    p_pattern=>REPLACE('sec/users/[COLON]id/exclusions','[COLON]',CHR(58)));
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin',
    p_pattern=>REPLACE('sec/users/[COLON]id/exclusions','[COLON]',CHR(58)),
    p_method=>'POST', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_raw RAW(32767); l_json VARCHAR2(32767);
  l_op VARCHAR2(20); l_id NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
  END IF;
  l_raw  := DBMS_LOB.SUBSTR([COLON]body, 32767, 1);
  l_json := UTL_RAW.CAST_TO_VARCHAR2(l_raw);
  APEX_JSON.parse(l_json);
  l_op := NVL(APEX_JSON.get_varchar2(p_path=>'op'), 'add');
  IF l_op = 'end' THEN
    UPDATE dct_sec_exclusion SET is_active='N', ended_by=l_user, ended_at=SYSTIMESTAMP
     WHERE exclusion_id = APEX_JSON.get_number(p_path=>'exclusionId')
       AND scope_type='USER' AND user_id = [COLON]id;
    IF SQL%ROWCOUNT = 0 THEN dct_rest.err(404,'Exclusion not found'); RETURN; END IF;
  ELSE
    INSERT INTO dct_sec_exclusion (scope_type, user_id, permission_id, reason, created_by)
    VALUES ('USER', [COLON]id, APEX_JSON.get_number(p_path=>'permissionId'),
         APEX_JSON.get_varchar2(p_path=>'reason'), l_user)
    RETURNING exclusion_id INTO l_id;
  END IF;
  dct_sec.bump_version;
  dct_audit_pkg.log(l_user, CASE WHEN l_op='end' THEN 'UPDATE' ELSE 'CREATE' END,
      'SEC_USER_EXCLUSION', TO_CHAR(NVL(l_id, [COLON]id)), 'ADMIN');
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE = -1 THEN dct_rest.err(400,'This privilege is already excluded for the user');
  ELSIF SQLCODE = -2291 THEN dct_rest.err(400,'Unknown user or privilege');
  ELSE dct_rest.err(500, SQLERRM); END IF;
END;!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'dct.admin',
    p_pattern=>REPLACE('sec/users/[COLON]id/effective','[COLON]',CHR(58)));
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin',
    p_pattern=>REPLACE('sec/users/[COLON]id/effective','[COLON]',CHR(58)),
    p_method=>'GET', p_source_type=>ORDS.source_type_plsql,
    p_items_per_page=>0, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
  END IF;
  SELECT COUNT(*) INTO l_n FROM dct_users WHERE user_id = [COLON]id;
  IF l_n = 0 THEN dct_rest.err(404,'User not found'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT e.permission_id, e.permission_code, p.permission_name, p.verb,
           m.module_code, ro.role_code AS via_root, ro.role_name_en AS via_root_name,
           via.role_code AS via_role, g.name_en AS via_group
      FROM v_dct_user_privs_eff e
      JOIN dct_permissions p ON p.permission_id = e.permission_id
      LEFT JOIN dct_modules m ON m.module_id = p.module_id
      JOIN dct_roles ro ON ro.role_id = e.root_role_id
      LEFT JOIN dct_roles via ON via.role_id = e.via_role_id AND via.role_id <> e.root_role_id
      LEFT JOIN dct_sec_priv_group g ON g.group_id = e.via_group_id
     WHERE e.user_id = [COLON]id
     ORDER BY ro.role_code, m.module_code NULLS FIRST, e.permission_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id', r.permission_id);
    APEX_JSON.write('code', r.permission_code);
    APEX_JSON.write('name', r.permission_name);
    APEX_JSON.write('verb', r.verb);
    APEX_JSON.write('module', r.module_code);
    APEX_JSON.write('viaRoot', r.via_root);
    APEX_JSON.write('viaRootName', r.via_root_name);
    APEX_JSON.write('viaRole', r.via_role);
    APEX_JSON.write('viaGroup', r.via_group);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  dct_rest.err(500, SQLERRM);
END;!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'dct.admin', p_pattern=>'sec/pages');
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin', p_pattern=>'sec/pages',
    p_method=>'GET', p_source_type=>ORDS.source_type_plsql,
    p_items_per_page=>0, p_source=>q'!
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
  FOR r IN (
    SELECT pg.page_id, pg.module_code, pg.page_code, pg.name_en, pg.name_ar,
           pg.nav_group, pg.is_active, p.permission_code AS view_priv,
           (SELECT COUNT(*) FROM dct_sec_page_artifact a
             WHERE a.page_id = pg.page_id AND a.is_active='Y') AS artifact_count
      FROM dct_sec_page pg
      LEFT JOIN dct_permissions p ON p.permission_id = pg.view_permission_id
     WHERE (:module IS NULL OR pg.module_code = UPPER(:module))
     ORDER BY pg.module_code, pg.display_order, pg.page_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id', r.page_id);
    APEX_JSON.write('module', r.module_code);
    APEX_JSON.write('page', r.page_code);
    APEX_JSON.write('name', r.name_en);
    APEX_JSON.write('nameAr', r.name_ar);
    APEX_JSON.write('navGroup', r.nav_group);
    APEX_JSON.write('viewPriv', r.view_priv);
    APEX_JSON.write('isActive', r.is_active);
    APEX_JSON.write('artifactCount', r.artifact_count);
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
  ORDS.DEFINE_TEMPLATE(p_module_name=>'dct.admin', p_pattern=>'sec/pageinfo');
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin', p_pattern=>'sec/pageinfo',
    p_method=>'GET', p_source_type=>ORDS.source_type_plsql,
    p_items_per_page=>0, p_source=>q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_pid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
  END IF;
  IF :module IS NULL OR :page IS NULL THEN
    dct_rest.err(400,'module and page are required'); RETURN;
  END IF;
  BEGIN
    SELECT page_id INTO l_pid FROM dct_sec_page
     WHERE module_code = UPPER(:module) AND page_code = :page;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    dct_rest.err(404,'Page is not registered in the security catalog'); RETURN;
  END;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  FOR r IN (SELECT pg.page_id, pg.module_code, pg.page_code, pg.name_en, pg.name_ar,
                   pg.nav_group, pg.description_en,
                   p.permission_code AS view_priv, p.permission_name AS view_priv_name
              FROM dct_sec_page pg
              LEFT JOIN dct_permissions p ON p.permission_id = pg.view_permission_id
             WHERE pg.page_id = l_pid) LOOP
    APEX_JSON.write('id', r.page_id);
    APEX_JSON.write('module', r.module_code);
    APEX_JSON.write('page', r.page_code);
    APEX_JSON.write('name', r.name_en);
    APEX_JSON.write('nameAr', r.name_ar);
    APEX_JSON.write('navGroup', r.nav_group);
    APEX_JSON.write('description', r.description_en);
    APEX_JSON.write('viewPriv', r.view_priv);
    APEX_JSON.write('viewPrivName', r.view_priv_name);
  END LOOP;
  APEX_JSON.open_array('artifacts');
  FOR r IN (SELECT a.artifact_id, a.artifact_type, a.artifact_code,
                   a.label_en, a.label_ar, a.notes,
                   p.permission_id, p.permission_code, p.permission_name
              FROM dct_sec_page_artifact a
              LEFT JOIN dct_permissions p ON p.permission_id = a.permission_id
             WHERE a.page_id = l_pid AND a.is_active='Y'
             ORDER BY a.display_order, a.artifact_type, a.artifact_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id', r.artifact_id);
    APEX_JSON.write('type', r.artifact_type);
    APEX_JSON.write('code', r.artifact_code);
    APEX_JSON.write('label', r.label_en);
    APEX_JSON.write('labelAr', r.label_ar);
    APEX_JSON.write('notes', r.notes);
    APEX_JSON.write('privCode', r.permission_code);
    APEX_JSON.write('privName', r.permission_name);
    APEX_JSON.open_array('grantedTo');
    IF r.permission_id IS NOT NULL THEN
      FOR g IN (SELECT DISTINCT ro.role_code, ro.role_name_en, ro.role_category
                  FROM dct_sec_role_priv_flat f
                  JOIN dct_roles ro ON ro.role_id = f.role_id
                 WHERE f.permission_id = r.permission_id AND ro.is_active='Y'
                 ORDER BY ro.role_category, ro.role_code) LOOP
        APEX_JSON.open_object;
        APEX_JSON.write('code', g.role_code);
        APEX_JSON.write('name', g.role_name_en);
        APEX_JSON.write('category', g.role_category);
        APEX_JSON.close_object;
      END LOOP;
    END IF;
    APEX_JSON.close_array;
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
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin', p_pattern=>'sec/pages',
    p_method=>'POST', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_raw RAW(32767); l_json VARCHAR2(32767);
  l_id NUMBER; l_vp NUMBER; l_cnt NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'SYS_ADMIN required'); RETURN;
  END IF;
  l_raw  := DBMS_LOB.SUBSTR([COLON]body, 32767, 1);
  l_json := UTL_RAW.CAST_TO_VARCHAR2(l_raw);
  APEX_JSON.parse(l_json);
  IF APEX_JSON.get_varchar2(p_path=>'module') IS NULL
     OR APEX_JSON.get_varchar2(p_path=>'page') IS NULL
     OR APEX_JSON.get_varchar2(p_path=>'name') IS NULL THEN
    dct_rest.err(400,'module, page and name are required'); RETURN;
  END IF;
  IF APEX_JSON.get_varchar2(p_path=>'viewPriv') IS NOT NULL THEN
    SELECT MAX(permission_id) INTO l_vp FROM dct_permissions
     WHERE permission_code = UPPER(APEX_JSON.get_varchar2(p_path=>'viewPriv'));
  END IF;
  INSERT INTO dct_sec_page
      (module_code, page_code, name_en, name_ar, view_permission_id,
       nav_group, description_en, created_by)
  VALUES (UPPER(APEX_JSON.get_varchar2(p_path=>'module')),
       APEX_JSON.get_varchar2(p_path=>'page'),
       APEX_JSON.get_varchar2(p_path=>'name'),
       APEX_JSON.get_varchar2(p_path=>'nameAr'), l_vp,
       APEX_JSON.get_varchar2(p_path=>'navGroup'),
       APEX_JSON.get_varchar2(p_path=>'description'), l_user)
  RETURNING page_id INTO l_id;
  l_cnt := APEX_JSON.get_count(p_path=>'artifacts');
  IF l_cnt IS NOT NULL THEN
    FOR i IN 1..l_cnt LOOP
      DECLARE
        l_ap NUMBER;
      BEGIN
        IF APEX_JSON.get_varchar2(p_path=>'artifacts[%d].privCode', p0=>i) IS NOT NULL THEN
          SELECT MAX(permission_id) INTO l_ap FROM dct_permissions
           WHERE permission_code = UPPER(APEX_JSON.get_varchar2(p_path=>'artifacts[%d].privCode', p0=>i));
        END IF;
        INSERT INTO dct_sec_page_artifact
            (page_id, artifact_type, artifact_code, label_en, label_ar,
             permission_id, notes, display_order)
        VALUES (l_id,
             UPPER(APEX_JSON.get_varchar2(p_path=>'artifacts[%d].type', p0=>i)),
             APEX_JSON.get_varchar2(p_path=>'artifacts[%d].code', p0=>i),
             APEX_JSON.get_varchar2(p_path=>'artifacts[%d].label', p0=>i),
             APEX_JSON.get_varchar2(p_path=>'artifacts[%d].labelAr', p0=>i),
             l_ap,
             APEX_JSON.get_varchar2(p_path=>'artifacts[%d].notes', p0=>i),
             i * 10);
      END;
    END LOOP;
  END IF;
  dct_audit_pkg.log(l_user,'CREATE','SEC_PAGE',TO_CHAR(l_id),'ADMIN');
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('id', l_id);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE = -1 THEN dct_rest.err(400,'Page already registered');
  ELSE dct_rest.err(500, SQLERRM); END IF;
END;!','[COLON]',CHR(58)));
  COMMIT;
END;
/

EXIT
