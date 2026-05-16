-- =============================================================================
-- i-Finance V2 -- ORDS REST API Definition
-- File    : 11_dct_ords.sql
-- Schema  : PROD
-- Run as  : PROD schema owner (sql -name prod_mcp)
-- Base URL: /ords/prod/dct/
-- =============================================================================
-- Prerequisites:
--   ORDS must be installed and schema REST-enabled.
--   GRANT EXECUTE ON APEX_JSON TO PROD;
--   GRANT EXECUTE ON OWA_UTIL  TO PROD;
-- =============================================================================
-- Run standalone (not part of main install.sql â€” ORDS is configured separately):
--   sql -name prod_mcp @11_dct_ords.sql
-- =============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF

-- =============================================================================
-- 1. REST-enable the PROD schema (idempotent)
-- =============================================================================
BEGIN
    ORDS.ENABLE_SCHEMA(
        p_enabled             => TRUE,
        p_schema              => 'PROD',
        p_url_mapping_type    => 'BASE_PATH',
        p_url_mapping_pattern => 'prod',
        p_auto_rest_auth      => FALSE
    );
    COMMIT;
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ENABLE_SCHEMA: ' || SQLERRM);
END;
/

-- =============================================================================
-- 2. DCT_REST â€” helper package (session validation + response helpers)
-- =============================================================================
CREATE OR REPLACE PACKAGE prod.dct_rest AS

    -- Reads Bearer token from Authorization header, validates against
    -- DCT_SESSIONS + DCT_USERS.  Returns username on success, NULL on failure.
    FUNCTION  validate_session RETURN VARCHAR2;

    -- Write CORS + JSON content-type headers (200 OK implied)
    PROCEDURE json_header;

    -- Write error JSON with given HTTP status
    PROCEDURE err(p_status PLS_INTEGER, p_msg VARCHAR2);

    -- Parse BLOB body â†’ APEX_JSON (call before get_varchar2/get_number)
    PROCEDURE parse_body(p_body IN BLOB);

END dct_rest;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_rest AS

    FUNCTION validate_session RETURN VARCHAR2 IS
        l_hdr     VARCHAR2(4000);
        l_token    VARCHAR2(200);
        l_username VARCHAR2(100);
    BEGIN
        l_hdr := OWA_UTIL.get_cgi_env('HTTP_AUTHORIZATION');
        IF l_hdr LIKE 'Bearer %' THEN
            l_token := TRIM(SUBSTR(l_hdr, 8));
        END IF;
        IF l_token IS NULL THEN RETURN NULL; END IF;

        SELECT s.username INTO l_username
        FROM   dct_sessions s
        JOIN   dct_users    u ON s.user_id = u.user_id
        WHERE  s.session_id = l_token
          AND  s.is_active  = 'Y'
          AND  u.is_active  = 'Y'
          AND  ROWNUM = 1;

        dct_auth.touch_session(l_token);
        RETURN l_username;
    EXCEPTION WHEN OTHERS THEN RETURN NULL;
    END validate_session;

    PROCEDURE json_header IS
        c_col CONSTANT VARCHAR2(1) := CHR(58);
    BEGIN
        OWA_UTIL.mime_header('application/json', FALSE);
        HTP.p('Access-Control-Allow-Origin'  || c_col || ' *');
        HTP.p('Access-Control-Allow-Headers' || c_col || ' Authorization, Content-Type');
        HTP.p('Access-Control-Allow-Methods' || c_col || ' GET, POST, PUT, DELETE, OPTIONS');
        OWA_UTIL.http_header_close;
    END json_header;

    PROCEDURE err(p_status PLS_INTEGER, p_msg VARCHAR2) IS
    BEGIN
        OWA_UTIL.status_line(p_status, NULL, FALSE);
        json_header;
        APEX_JSON.initialize_output;
        APEX_JSON.open_object;
        APEX_JSON.write('error', p_msg);
        APEX_JSON.close_object;
    END err;

    PROCEDURE parse_body(p_body IN BLOB) IS
        l_raw  RAW(32767);
        l_body VARCHAR2(32767);
    BEGIN
        l_raw  := DBMS_LOB.SUBSTR(p_body, 32767, 1);
        l_body := UTL_RAW.CAST_TO_VARCHAR2(l_raw);
        APEX_JSON.parse(l_body);
    EXCEPTION WHEN OTHERS THEN
        APEX_JSON.parse('{}');
    END parse_body;

END dct_rest;
/

-- =============================================================================
-- 3. ADMIN synonyms -> PROD DCT objects
--    ORDS handlers run as ADMIN parsing schema; synonyms let unqualified
--    names (dct_users, dct_rest, etc.) resolve to PROD objects.
--    Drop any stale ADMIN-schema packages that would block synonym creation.
-- =============================================================================
BEGIN
    FOR obj IN (SELECT object_name, object_type
                FROM   user_objects
                WHERE  object_name IN ('DCT_REST','DCT_NOTIFY')
                  AND  object_type IN ('PACKAGE BODY','PACKAGE')
                ORDER BY CASE object_type WHEN 'PACKAGE BODY' THEN 1 ELSE 2 END)
    LOOP
        EXECUTE IMMEDIATE 'DROP ' || obj.object_type || ' ' || obj.object_name;
    END LOOP;
END;
/

CREATE OR REPLACE SYNONYM dct_rest              FOR prod.dct_rest;
CREATE OR REPLACE SYNONYM dct_auth              FOR prod.dct_auth;
CREATE OR REPLACE SYNONYM dct_sessions          FOR prod.dct_sessions;
CREATE OR REPLACE SYNONYM dct_users             FOR prod.dct_users;
CREATE OR REPLACE SYNONYM dct_organizations     FOR prod.dct_organizations;
CREATE OR REPLACE SYNONYM dct_roles             FOR prod.dct_roles;
CREATE OR REPLACE SYNONYM dct_user_roles        FOR prod.dct_user_roles;
CREATE OR REPLACE SYNONYM dct_role_permissions  FOR prod.dct_role_permissions;
CREATE OR REPLACE SYNONYM dct_permissions       FOR prod.dct_permissions;
CREATE OR REPLACE SYNONYM dct_modules           FOR prod.dct_modules;
CREATE OR REPLACE SYNONYM dct_lookup_categories FOR prod.dct_lookup_categories;
CREATE OR REPLACE SYNONYM dct_lookup_values     FOR prod.dct_lookup_values;
CREATE OR REPLACE SYNONYM dct_system_settings   FOR prod.dct_system_settings;
CREATE OR REPLACE SYNONYM dct_notifications     FOR prod.dct_notifications;
CREATE OR REPLACE SYNONYM dct_audit_log         FOR prod.dct_audit_log;

-- =============================================================================
-- 4. Define ORDS module + all templates + handlers
-- =============================================================================
-- Procedure in ADMIN schema (no prod. prefix) so SESSION_USER = ADMIN when
-- ORDS.DEFINE_MODULE runs, registering the module under ADMIN which is the
-- only REST-enabled schema routable in Oracle ADB managed ORDS.
-- Wrapped in DDL so SQLcl skips bind-variable scanning of handler source strings.
-- =============================================================================
CREATE OR REPLACE PROCEDURE setup_dct_ords_tmp AS

    c_mod         CONSTANT VARCHAR2(30)  := 'dct.admin';
    -- [COLON] in pattern/source strings is replaced with CHR(58) at runtime
    -- so that the DDL text never contains a literal colon+word sequence.
    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58))
        );
    END;

    PROCEDURE def_handler(
        p_pattern  VARCHAR2,
        p_method   VARCHAR2,
        p_source   CLOB
    ) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name    => c_mod,
            p_pattern        => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method         => p_method,
            p_source_type    => ORDS.source_type_plsql,
            p_source         => REPLACE(p_source, '[COLON]', CHR(58))
        );
    END;

BEGIN

    -- =========================================================================
    -- DROP + RECREATE module (idempotent)
    -- =========================================================================
    BEGIN
        ORDS.DELETE_MODULE(p_module_name => c_mod);
    EXCEPTION WHEN OTHERS THEN NULL;
    END;

    ORDS.DEFINE_MODULE(
        p_module_name    => c_mod,
        p_base_path      => '/dct/',
        p_items_per_page => 100,
        p_status         => 'PUBLISHED',
        p_comments       => 'i-Finance V2 â€” DCT Admin REST API'
    );

    -- =========================================================================
    -- AUTH â€” no token required
    -- =========================================================================
    def_template('auth/login');
    def_handler('auth/login', 'POST', q'!
DECLARE
  l_uname  VARCHAR2(100);
  l_pass   VARCHAR2(500);
  l_ok     BOOLEAN;
  l_sid    VARCHAR2(100);
  l_user   dct_users%ROWTYPE;
  l_roles  VARCHAR2(4000);
  l_org_nm dct_organizations.org_name_en%TYPE;
BEGIN
  dct_rest.parse_body([COLON]body);
  l_uname := UPPER(TRIM(APEX_JSON.get_varchar2(p_path => 'username')));
  l_pass  := APEX_JSON.get_varchar2(p_path => 'password');

  l_ok := dct_auth.authenticate(l_uname, l_pass);
  IF NOT l_ok THEN
    dct_rest.err(401, 'Invalid credentials or account inactive');
    RETURN;
  END IF;

  l_sid := RAWTOHEX(SYS_GUID());
  dct_auth.open_session(
    p_username    => l_uname,
    p_session_id  => l_sid,
    p_ip          => OWA_UTIL.get_cgi_env('REMOTE_ADDR'),
    p_agent       => OWA_UTIL.get_cgi_env('HTTP_USER_AGENT')
  );

  SELECT * INTO l_user FROM dct_users WHERE UPPER(username) = l_uname;
  BEGIN
    SELECT org_name_en INTO l_org_nm FROM dct_organizations WHERE org_id = l_user.org_id;
  EXCEPTION WHEN NO_DATA_FOUND THEN l_org_nm := NULL;
  END;

  l_roles := dct_auth.get_user_roles(l_uname);

  UPDATE dct_users SET last_login_at = SYSTIMESTAMP WHERE user_id = l_user.user_id;
  COMMIT;

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('sessionId',    l_sid);
  APEX_JSON.write('userId',       l_user.user_id);
  APEX_JSON.write('username',     l_user.username);
  APEX_JSON.write('displayName',  l_user.display_name);
  APEX_JSON.write('displayNameAr',l_user.display_name_ar);
  APEX_JSON.write('email',        l_user.email);
  APEX_JSON.write('phone',        l_user.mobile);
  APEX_JSON.write('orgId',        l_user.org_id);
  APEX_JSON.write('orgName',      l_org_nm);
  APEX_JSON.write('color',        l_user.color_hex);
  APEX_JSON.write('isExternal',   l_user.is_external);
  APEX_JSON.write('rolesCsv',     l_roles);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  dct_rest.err(500, SQLERRM);
END;
!');

    -- -------------------------------------------------------------------------
    def_template('auth/logout');
    def_handler('auth/logout', 'POST', q'!
DECLARE
  l_hdr VARCHAR2(4000);
  l_sid  VARCHAR2(200);
BEGIN
  l_hdr := OWA_UTIL.get_cgi_env('HTTP_AUTHORIZATION');
  IF l_hdr LIKE 'Bearer %' THEN
    l_sid := TRIM(SUBSTR(l_hdr, 8));
    dct_auth.close_session(l_sid);
    COMMIT;
  END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
END;
!');

    -- =========================================================================
    -- USERS
    -- =========================================================================
    def_template('users/');
    def_handler('users/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT u.user_id, u.username, u.display_name, u.display_name_ar,
           u.email, u.mobile, u.employee_number, u.org_id,
           o.org_name_en AS org_name, u.color_hex, u.is_active,
           u.is_external, u.auth_method, u.last_login_at,
           u.created_at,
           dct_auth.get_user_roles(u.username) AS roles_csv
    FROM   dct_users u
    LEFT JOIN dct_organizations o ON u.org_id = o.org_id
    ORDER BY u.display_name
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('userId',         r.user_id);
    APEX_JSON.write('username',       r.username);
    APEX_JSON.write('displayName',    r.display_name);
    APEX_JSON.write('displayNameAr',  r.display_name_ar);
    APEX_JSON.write('email',          r.email);
    APEX_JSON.write('phone',          r.mobile);
    APEX_JSON.write('employeeNumber', r.employee_number);
    APEX_JSON.write('orgId',          r.org_id);
    APEX_JSON.write('orgName',        r.org_name);
    APEX_JSON.write('color',          r.color_hex);
    APEX_JSON.write('isActive',       r.is_active);
    APEX_JSON.write('isExternal',     r.is_external);
    APEX_JSON.write('authMethod',     r.auth_method);
    APEX_JSON.write('rolesCsv',       r.roles_csv);
    APEX_JSON.write('lastLoginAt',    TO_CHAR(r.last_login_at,'YYYY-MM-DD"T"HH24":"MI":"SS'));
    APEX_JSON.write('createdAt',      TO_CHAR(r.created_at,'YYYY-MM-DD'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('users/', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_uid    NUMBER;
  l_uname  VARCHAR2(100);
  l_pass   VARCHAR2(500);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_uname := UPPER(TRIM(APEX_JSON.get_varchar2(p_path => 'username')));
  l_pass  := APEX_JSON.get_varchar2(p_path => 'password');

  INSERT INTO dct_users (
    username, display_name, display_name_ar, email, mobile,
    employee_number, org_id, color_hex, is_active, is_external,
    password_hash, auth_method, created_by
  ) VALUES (
    l_uname,
    APEX_JSON.get_varchar2(p_path => 'displayName'),
    APEX_JSON.get_varchar2(p_path => 'displayNameAr'),
    LOWER(TRIM(APEX_JSON.get_varchar2(p_path => 'email'))),
    APEX_JSON.get_varchar2(p_path => 'phone'),
    APEX_JSON.get_varchar2(p_path => 'employeeNumber'),
    APEX_JSON.get_number(p_path   => 'orgId'),
    NVL(APEX_JSON.get_varchar2(p_path => 'color'), '#0076CE'),
    NVL(APEX_JSON.get_varchar2(p_path => 'isActive'), 'Y'),
    NVL(APEX_JSON.get_varchar2(p_path => 'isExternal'), 'N'),
    CASE WHEN l_pass IS NOT NULL THEN dct_auth.hash_password(l_pass) END,
    CASE WHEN l_pass IS NOT NULL THEN 'DB' ELSE 'LDAP' END,
    l_user
  ) RETURNING user_id INTO l_uid;

  -- Assign roles
  FOR i IN 1 .. APEX_JSON.get_count(p_path => 'roles') LOOP
    INSERT INTO dct_user_roles (user_id, role_id, assigned_by, created_by)
    SELECT l_uid, r.role_id, l_user, l_user
    FROM   dct_roles r
    WHERE  r.role_code = APEX_JSON.get_varchar2(p_path => 'roles[%d]', p0 => i)
      AND  NOT EXISTS (SELECT 1 FROM dct_user_roles x
                       WHERE x.user_id = l_uid AND x.role_id = r.role_id);
  END LOOP;
  COMMIT;

  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('userId', l_uid);
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- -------------------------------------------------------------------------
    def_template('users/[COLON]id');
    def_handler('users/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_rec  dct_users%ROWTYPE;
  l_org  dct_organizations.org_name_en%TYPE;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  BEGIN
    SELECT * INTO l_rec FROM dct_users WHERE user_id = [COLON]id;
    BEGIN
      SELECT org_name_en INTO l_org FROM dct_organizations WHERE org_id = l_rec.org_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN l_org := NULL;
    END;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'User not found'); RETURN;
  END;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('userId',         l_rec.user_id);
  APEX_JSON.write('username',       l_rec.username);
  APEX_JSON.write('displayName',    l_rec.display_name);
  APEX_JSON.write('displayNameAr',  l_rec.display_name_ar);
  APEX_JSON.write('email',          l_rec.email);
  APEX_JSON.write('phone',          l_rec.mobile);
  APEX_JSON.write('employeeNumber', l_rec.employee_number);
  APEX_JSON.write('orgId',          l_rec.org_id);
  APEX_JSON.write('orgName',        l_org);
  APEX_JSON.write('color',          l_rec.color_hex);
  APEX_JSON.write('isActive',       l_rec.is_active);
  APEX_JSON.write('isExternal',     l_rec.is_external);
  APEX_JSON.write('authMethod',     l_rec.auth_method);
  APEX_JSON.write('rolesCsv',       dct_auth.get_user_roles(l_rec.username));
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('users/[COLON]id', 'PUT', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_uid   NUMBER        := [COLON]id;
  l_uname VARCHAR2(100);
  l_pass  VARCHAR2(500);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_pass := APEX_JSON.get_varchar2(p_path => 'password');

  SELECT username INTO l_uname FROM dct_users WHERE user_id = l_uid;

  UPDATE dct_users SET
    display_name     = NVL(APEX_JSON.get_varchar2(p_path => 'displayName'),   display_name),
    display_name_ar  = APEX_JSON.get_varchar2(p_path => 'displayNameAr'),
    email            = NVL(LOWER(TRIM(APEX_JSON.get_varchar2(p_path => 'email'))), email),
    mobile           = APEX_JSON.get_varchar2(p_path => 'phone'),
    employee_number  = APEX_JSON.get_varchar2(p_path => 'employeeNumber'),
    org_id           = NVL(APEX_JSON.get_number(p_path => 'orgId'), org_id),
    color_hex        = NVL(APEX_JSON.get_varchar2(p_path => 'color'), color_hex),
    is_active        = NVL(APEX_JSON.get_varchar2(p_path => 'isActive'), is_active),
    is_external      = NVL(APEX_JSON.get_varchar2(p_path => 'isExternal'), is_external),
    deactivated_at   = CASE WHEN APEX_JSON.get_varchar2(p_path => 'isActive') = 'N'
                            THEN SYSTIMESTAMP ELSE deactivated_at END,
    password_hash    = CASE WHEN l_pass IS NOT NULL
                            THEN dct_auth.hash_password(l_pass) ELSE password_hash END,
    updated_by       = l_user,
    updated_at       = SYSTIMESTAMP
  WHERE user_id = l_uid;

  -- Sync role assignments: remove all, re-insert selected
  IF APEX_JSON.get_count(p_path => 'roles') >= 0 THEN
    UPDATE dct_user_roles SET is_active = 'N', end_date = TRUNC(SYSDATE)
    WHERE  user_id = l_uid AND is_active = 'Y';

    FOR i IN 1 .. APEX_JSON.get_count(p_path => 'roles') LOOP
      MERGE INTO dct_user_roles t
      USING (SELECT role_id FROM dct_roles
             WHERE role_code = APEX_JSON.get_varchar2(p_path => 'roles[%d]', p0 => i)) s
      ON (t.user_id = l_uid AND t.role_id = s.role_id)
      WHEN MATCHED THEN
        UPDATE SET is_active = 'Y', end_date = NULL, updated_by = l_user, updated_at = SYSTIMESTAMP
      WHEN NOT MATCHED THEN
        INSERT (user_id, role_id, assigned_by, created_by)
        VALUES (l_uid, s.role_id, l_user, l_user);
    END LOOP;
  END IF;
  COMMIT;

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('users/[COLON]id', 'DELETE', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  UPDATE dct_users SET is_active = 'N', deactivated_at = SYSTIMESTAMP, updated_by = l_user
  WHERE  user_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- ROLES
    -- =========================================================================
    def_template('roles/');
    def_handler('roles/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT r.role_id, r.role_code, r.role_name_en AS role_name,
           r.description_en AS description, r.role_type, r.is_active,
           r.is_system_role,
           (SELECT COUNT(*) FROM dct_user_roles ur
            WHERE ur.role_id = r.role_id AND ur.is_active = 'Y') AS member_count
    FROM   dct_roles r ORDER BY r.display_order, r.role_name_en
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('roleId',       r.role_id);
    APEX_JSON.write('roleCode',     r.role_code);
    APEX_JSON.write('roleName',     r.role_name);
    APEX_JSON.write('description',  r.description);
    APEX_JSON.write('roleType',     r.role_type);
    APEX_JSON.write('isActive',     r.is_active);
    APEX_JSON.write('isSystemRole', r.is_system_role);
    APEX_JSON.write('memberCount',  r.member_count);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('roles/', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_rid  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  INSERT INTO dct_roles (role_code, role_name_en, description_en, role_type, is_active, created_by)
  VALUES (
    UPPER(TRIM(APEX_JSON.get_varchar2(p_path => 'roleCode'))),
    APEX_JSON.get_varchar2(p_path => 'roleName'),
    APEX_JSON.get_varchar2(p_path => 'description'),
    NVL(APEX_JSON.get_varchar2(p_path => 'roleType'), 'MODULE'),
    NVL(APEX_JSON.get_varchar2(p_path => 'isActive'), 'Y'),
    l_user
  ) RETURNING role_id INTO l_rid;

  -- Set permissions
  FOR i IN 1 .. NVL(APEX_JSON.get_count(p_path => 'permIds'), 0) LOOP
    INSERT INTO dct_role_permissions (role_id, permission_id, granted_by)
    VALUES (l_rid, APEX_JSON.get_number(p_path => 'permIds[%d]', p0 => i), l_user);
  END LOOP;
  COMMIT;

  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('roleId', l_rid);
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('roles/[COLON]id');
    def_handler('roles/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_rec  dct_roles%ROWTYPE;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  BEGIN
    SELECT * INTO l_rec FROM dct_roles WHERE role_id = [COLON]id;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Role not found'); RETURN;
  END;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('roleId',      l_rec.role_id);
  APEX_JSON.write('roleCode',    l_rec.role_code);
  APEX_JSON.write('roleName',    l_rec.role_name_en);
  APEX_JSON.write('description', l_rec.description_en);
  APEX_JSON.write('isActive',    l_rec.is_active);
  APEX_JSON.write('isSystemRole',l_rec.is_system_role);
  -- Permission IDs assigned to this role
  APEX_JSON.open_array('permIds');
  FOR p IN (SELECT permission_id FROM dct_role_permissions WHERE role_id = [COLON]id) LOOP
    APEX_JSON.write(p.permission_id);
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('roles/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_rid  NUMBER        := [COLON]id;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE dct_roles SET
    role_name_en   = NVL(APEX_JSON.get_varchar2(p_path => 'roleName'),   role_name_en),
    description_en = APEX_JSON.get_varchar2(p_path => 'description'),
    is_active      = NVL(APEX_JSON.get_varchar2(p_path => 'isActive'),   is_active),
    updated_by     = l_user,
    updated_at     = SYSTIMESTAMP
  WHERE role_id = l_rid;

  -- Sync permissions
  DELETE FROM dct_role_permissions WHERE role_id = l_rid;
  FOR i IN 1 .. NVL(APEX_JSON.get_count(p_path => 'permIds'), 0) LOOP
    INSERT INTO dct_role_permissions (role_id, permission_id, granted_by)
    VALUES (l_rid, APEX_JSON.get_number(p_path => 'permIds[%d]', p0 => i), l_user);
  END LOOP;
  COMMIT;

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('roles/[COLON]id', 'DELETE', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_sys   VARCHAR2(1);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT is_system_role INTO l_sys FROM dct_roles WHERE role_id = [COLON]id;
  IF l_sys = 'Y' THEN dct_rest.err(400,'System roles cannot be deleted'); RETURN; END IF;
  UPDATE dct_roles SET is_active = 'N', updated_by = l_user WHERE role_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- PERMISSIONS (read-only)
    -- =========================================================================
    def_template('permissions/');
    def_handler('permissions/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT p.permission_id, p.permission_code, p.permission_name AS perm_name,
           p.action_type, p.is_active,
           m.module_name_en AS module_name, m.module_code
    FROM   dct_permissions p
    LEFT JOIN dct_modules m ON p.module_id = m.module_id
    ORDER BY m.module_name_en, p.action_type, p.permission_name
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('permId',     r.permission_id);
    APEX_JSON.write('permCode',   r.permission_code);
    APEX_JSON.write('permName',   r.perm_name);
    APEX_JSON.write('actionType', r.action_type);
    APEX_JSON.write('isActive',   r.is_active);
    APEX_JSON.write('module',     NVL(r.module_name, 'Platform'));
    APEX_JSON.write('moduleCode', r.module_code);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- MODULES
    -- =========================================================================
    def_template('modules/');
    def_handler('modules/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT module_id, module_code, module_name_en, module_name_ar,
           module_type, apex_app_id, apex_page_id, app_url,
           icon_class, icon_color, bg_color, category,
           description_en, is_active, is_admin_only, display_order
    FROM   dct_modules
    ORDER BY display_order, module_name_en
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('moduleId',    r.module_id);
    APEX_JSON.write('moduleCode',  r.module_code);
    APEX_JSON.write('nameEn',      r.module_name_en);
    APEX_JSON.write('nameAr',      r.module_name_ar);
    APEX_JSON.write('moduleType',  r.module_type);
    APEX_JSON.write('apexAppId',   r.apex_app_id);
    APEX_JSON.write('apexPageId',  r.apex_page_id);
    APEX_JSON.write('appUrl',      r.app_url);
    APEX_JSON.write('iconClass',   r.icon_class);
    APEX_JSON.write('color',       r.icon_color);
    APEX_JSON.write('bg',          r.bg_color);
    APEX_JSON.write('category',    r.category);
    APEX_JSON.write('description', r.description_en);
    APEX_JSON.write('isActive',    r.is_active);
    APEX_JSON.write('isAdminOnly', r.is_admin_only);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('modules/[COLON]id');
    def_handler('modules/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE dct_modules SET
    module_name_en = NVL(APEX_JSON.get_varchar2(p_path => 'nameEn'), module_name_en),
    module_name_ar = APEX_JSON.get_varchar2(p_path => 'nameAr'),
    is_active      = NVL(APEX_JSON.get_varchar2(p_path => 'isActive'), is_active),
    display_order  = NVL(APEX_JSON.get_number(p_path  => 'displayOrder'), display_order),
    updated_by     = l_user, updated_at = SYSTIMESTAMP
  WHERE module_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- ORGS (read-only tree)
    -- =========================================================================
    def_template('orgs/');
    def_handler('orgs/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT o.org_id, o.org_code, o.org_name_en, o.org_name_ar,
           o.org_type, o.parent_org_id, o.level_no, o.full_path,
           o.is_active, o.display_order,
           u.display_name AS head_name
    FROM   dct_organizations o
    LEFT JOIN dct_users u ON o.head_user_id = u.user_id
    ORDER BY o.level_no, o.display_order, o.org_name_en
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('orgId',       r.org_id);
    APEX_JSON.write('orgCode',     r.org_code);
    APEX_JSON.write('nameEn',      r.org_name_en);
    APEX_JSON.write('nameAr',      r.org_name_ar);
    APEX_JSON.write('orgType',     r.org_type);
    APEX_JSON.write('parentOrgId', r.parent_org_id);
    APEX_JSON.write('levelNo',     r.level_no);
    APEX_JSON.write('fullPath',    r.full_path);
    APEX_JSON.write('isActive',    r.is_active);
    APEX_JSON.write('headName',    r.head_name);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- LOOKUPS
    -- =========================================================================
    def_template('lookups/');
    def_handler('lookups/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR c IN (SELECT category_id, category_code, name_en, name_ar, is_active
            FROM dct_lookup_categories ORDER BY name_en) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('categoryId',   c.category_id);
    APEX_JSON.write('categoryCode', c.category_code);
    APEX_JSON.write('nameEn',       c.name_en);
    APEX_JSON.write('nameAr',       c.name_ar);
    APEX_JSON.write('isActive',     c.is_active);
    APEX_JSON.open_array('values');
    FOR v IN (SELECT value_id, lookup_code, display_value_en, display_value_ar,
                     sort_order, is_active
              FROM dct_lookup_values
              WHERE category_id = c.category_id ORDER BY sort_order, display_value_en) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('valueId',      v.value_id);
      APEX_JSON.write('lookupCode',   v.lookup_code);
      APEX_JSON.write('displayValue', v.display_value_en);
      APEX_JSON.write('displayAr',    v.display_value_ar);
      APEX_JSON.write('sortOrder',    v.sort_order);
      APEX_JSON.write('isActive',     v.is_active);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('lookups/values/[COLON]id');
    def_handler('lookups/values/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE dct_lookup_values SET
    display_value_en = NVL(APEX_JSON.get_varchar2(p_path => 'displayValue'), display_value_en),
    display_value_ar = APEX_JSON.get_varchar2(p_path => 'displayAr'),
    sort_order       = NVL(APEX_JSON.get_number(p_path  => 'sortOrder'), sort_order),
    is_active        = NVL(APEX_JSON.get_varchar2(p_path => 'isActive'), is_active),
    updated_at       = SYSTIMESTAMP
  WHERE value_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- SYSTEM SETTINGS
    -- =========================================================================
    def_template('settings/');
    def_handler('settings/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT setting_key, setting_value, setting_type, description_en,
                   is_editable, display_order
            FROM dct_system_settings ORDER BY display_order, setting_key) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('key',         r.setting_key);
    APEX_JSON.write('value',       r.setting_value);
    APEX_JSON.write('type',        r.setting_type);
    APEX_JSON.write('description', r.description_en);
    APEX_JSON.write('isEditable',  r.is_editable);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('settings/[COLON]key');
    def_handler('settings/[COLON]key', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_edit VARCHAR2(1);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT is_editable INTO l_edit FROM dct_system_settings WHERE setting_key = [COLON]key;
  IF l_edit = 'N' THEN dct_rest.err(403,'Setting is read-only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE dct_system_settings
  SET    setting_value = APEX_JSON.get_varchar2(p_path => 'value'),
         updated_at    = SYSTIMESTAMP
  WHERE  setting_key = [COLON]key;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- NOTIFICATIONS
    -- =========================================================================
    def_template('notifications/');
    def_handler('notifications/', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_uid    NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT notification_id, title, body, notification_type,
           is_read, created_at
    FROM   dct_notifications
    WHERE  recipient_user_id = l_uid
      AND  (expires_at IS NULL OR expires_at > SYSTIMESTAMP)
    ORDER BY created_at DESC
    FETCH FIRST 50 ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('notifId',   r.notification_id);
    APEX_JSON.write('title',     r.title);
    APEX_JSON.write('body',      r.body);
    APEX_JSON.write('type',      r.notification_type);
    APEX_JSON.write('isRead',    r.is_read);
    APEX_JSON.write('createdAt', TO_CHAR(r.created_at,'YYYY-MM-DD"T"HH24":"MI":"SS'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('notifications/[COLON]id/read');
    def_handler('notifications/[COLON]id/read', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  UPDATE dct_notifications SET is_read = 'Y' WHERE notification_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- AUDIT LOG (read-only)
    -- =========================================================================
    def_template('audit/');
    def_handler('audit/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT log_id, username, action, object_type, object_id,
           status, error_message, logged_at
    FROM   dct_audit_log
    ORDER BY logged_at DESC
    FETCH FIRST 200 ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('logId',       r.log_id);
    APEX_JSON.write('username',    r.username);
    APEX_JSON.write('action',      r.action);
    APEX_JSON.write('objectType',  r.object_type);
    APEX_JSON.write('objectId',    r.object_id);
    APEX_JSON.write('status',      r.status);
    APEX_JSON.write('error',       r.error_message);
    APEX_JSON.write('loggedAt',    TO_CHAR(r.logged_at,'YYYY-MM-DD"T"HH24":"MI":"SS'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('ORDS module dct.admin published successfully.');

END setup_dct_ords_tmp;
/

-- Call the setup procedure (separate block so its locks are fully released before DROP)
BEGIN
    setup_dct_ords_tmp;
END;
/

-- Drop the setup helper in a fresh block (avoids ORA-04020 deadlock)
BEGIN
    EXECUTE IMMEDIATE 'DROP PROCEDURE setup_dct_ords_tmp';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

PROMPT ============================================================
PROMPT  11_dct_ords.sql complete.
PROMPT  Base URL: /ords/admin/dct/
PROMPT  Endpoints: auth/login, auth/logout, users/, users/:id,
PROMPT             roles/, roles/:id, permissions/, modules/,
PROMPT             orgs/, lookups/, settings/, notifications/,
PROMPT             audit/
PROMPT ============================================================
