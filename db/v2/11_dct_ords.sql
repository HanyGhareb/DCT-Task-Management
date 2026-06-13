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
    FUNCTION  validate_session RETURN VARCHAR2;  -- checks AUTHORIZATION CGI env (ADB ORDS uses no HTTP_ prefix)

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
        -- ADB managed ORDS uses 'AUTHORIZATION' (no HTTP_ prefix); fall back to HTTP_ for on-prem
        l_hdr := OWA_UTIL.get_cgi_env('AUTHORIZATION');
        IF l_hdr IS NULL THEN
            l_hdr := OWA_UTIL.get_cgi_env('HTTP_AUTHORIZATION');
        END IF;
        IF l_hdr LIKE 'Bearer %' THEN
            l_token := TRIM(SUBSTR(l_hdr, 8));
        END IF;
        IF l_token IS NULL THEN RETURN NULL; END IF;

        -- Wave 3 (db/v2/19): sessions expire after SESSION_TIMEOUT_MINS of
        -- inactivity (default 480); successful calls touch last_activity_at.
        SELECT s.username INTO l_username
        FROM   dct_sessions s
        JOIN   dct_users    u ON s.user_id = u.user_id
        WHERE  s.session_id = l_token
          AND  s.is_active  = 'Y'
          AND  u.is_active  = 'Y'
          AND  s.last_activity_at > SYSTIMESTAMP - NUMTODSINTERVAL(
                 NVL((SELECT TO_NUMBER(setting_value)
                      FROM dct_system_settings
                      WHERE setting_key = 'SESSION_TIMEOUT_MINS'), 480), 'MINUTE')
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
        c_col CONSTANT VARCHAR2(1) := CHR(58);
    BEGIN
        -- Do NOT use APEX_JSON here: initialize_output resets the HTP buffer
        -- and silently wipes the status line (every error returned HTTP 200
        -- until this was fixed — discovered in the Phase 1 smoke test).
        OWA_UTIL.status_line(p_status, NULL, FALSE);
        OWA_UTIL.mime_header('application/json', FALSE);
        HTP.p('Access-Control-Allow-Origin'  || c_col || ' *');
        HTP.p('Access-Control-Allow-Headers' || c_col || ' Authorization, Content-Type');
        HTP.p('Access-Control-Allow-Methods' || c_col || ' GET, POST, PUT, DELETE, OPTIONS');
        OWA_UTIL.http_header_close;
        HTP.p('{"error"' || c_col || ' "' ||
              REPLACE(REPLACE(p_msg, '\', '\\'), '"', '\"') || '"}');
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
CREATE OR REPLACE SYNONYM dct_user_preferences  FOR prod.dct_user_preferences;
CREATE OR REPLACE SYNONYM dct_approval_instances FOR prod.dct_approval_instances;
CREATE OR REPLACE SYNONYM dct_approval_templates FOR prod.dct_approval_templates;
CREATE OR REPLACE SYNONYM dct_approval_steps     FOR prod.dct_approval_steps;
CREATE OR REPLACE SYNONYM dct_approval_actions   FOR prod.dct_approval_actions;
-- Unified approvals inbox reads/updates PC + DT sources (UAT 2026-06-11)
CREATE OR REPLACE SYNONYM dct_petty_cash            FOR prod.dct_petty_cash;
CREATE OR REPLACE SYNONYM dct_pc_reimbursements     FOR prod.dct_pc_reimbursements;
CREATE OR REPLACE SYNONYM dct_pc_clearing           FOR prod.dct_pc_clearing;
CREATE OR REPLACE SYNONYM dt_requests               FOR prod.dt_requests;
CREATE OR REPLACE SYNONYM dt_settlement             FOR prod.dt_settlement;
CREATE OR REPLACE SYNONYM dct_request_status_history FOR prod.dct_request_status_history;
CREATE OR REPLACE SYNONYM dct_notify                FOR prod.dct_notify;
-- Phase 4: unified inbox covers FL + CC; delegations + announcements endpoints
-- (dct_fl_* / dct_cc_* synonyms are created by the FL/CC ORDS scripts; the
--  ones below are the Admin-only additions)
CREATE OR REPLACE SYNONYM dct_delegations           FOR prod.dct_delegations;
CREATE OR REPLACE SYNONYM dct_announcements         FOR prod.dct_announcements;

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
  APEX_JSON.write('photoUrl',     l_user.photo_url);
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
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  -- Phase 3 server-side pagination: ?limit=&offset=&search=&status=
  l_limit  NUMBER        := LEAST(NVL(TO_NUMBER([COLON]limit DEFAULT NULL ON CONVERSION ERROR), 50), 200);
  l_offset NUMBER        := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_search VARCHAR2(200) := [COLON]search;
  l_status VARCHAR2(1)   := UPPER(SUBSTR([COLON]status, 1, 1));
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;

  SELECT COUNT(*) INTO l_total
  FROM   dct_users u
  LEFT JOIN dct_organizations o ON u.org_id = o.org_id
  WHERE (l_status IS NULL OR u.is_active = l_status)
    AND (l_search IS NULL OR
         UPPER(u.username || ' ' || u.display_name || ' ' || NVL(u.email, '') || ' ' ||
               NVL(u.employee_number, '') || ' ' || NVL(o.org_name_en, ''))
         LIKE '%' || UPPER(l_search) || '%');

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total',  l_total);
  APEX_JSON.write('limit',  l_limit);
  APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT u.user_id, u.username, u.display_name, u.display_name_ar,
           u.email, u.mobile, u.employee_number, u.org_id,
           o.org_name_en AS org_name, u.color_hex, u.is_active,
           u.is_external, u.auth_method, u.last_login_at,
           u.created_at,
           dct_auth.get_user_roles(u.username) AS roles_csv,
           (SELECT LISTAGG(r2.role_name_en, ',') WITHIN GROUP (ORDER BY r2.role_name_en)
            FROM   dct_user_roles ur2
            JOIN   dct_roles r2 ON r2.role_id = ur2.role_id
            WHERE  ur2.user_id = u.user_id AND ur2.is_active = 'Y'
              AND (ur2.end_date IS NULL OR ur2.end_date >= SYSDATE)) AS role_names_csv
    FROM   dct_users u
    LEFT JOIN dct_organizations o ON u.org_id = o.org_id
    WHERE (l_status IS NULL OR u.is_active = l_status)
      AND (l_search IS NULL OR
           UPPER(u.username || ' ' || u.display_name || ' ' || NVL(u.email, '') || ' ' ||
                 NVL(u.employee_number, '') || ' ' || NVL(o.org_name_en, ''))
           LIKE '%' || UPPER(l_search) || '%')
    ORDER BY u.display_name
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
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
    APEX_JSON.write('roleNamesCsv',   r.role_names_csv);
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

  IF l_pass IS NOT NULL AND LENGTH(l_pass) < 8 THEN
    dct_rest.err(400,'Password must be at least 8 characters'); RETURN;
  END IF;

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
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    ROLLBACK; dct_rest.err(409, 'Username or email already exists');
  WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
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
  APEX_JSON.write('photoUrl',       l_rec.photo_url);
  APEX_JSON.write('isActive',       l_rec.is_active);
  APEX_JSON.write('isExternal',     l_rec.is_external);
  APEX_JSON.write('authMethod',     l_rec.auth_method);
  APEX_JSON.write('rolesCsv',       dct_auth.get_user_roles(l_rec.username));
  APEX_JSON.write('createdBy',      l_rec.created_by);
  APEX_JSON.write('createdAt', TO_CHAR(FROM_TZ(l_rec.created_at, 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
  APEX_JSON.write('updatedBy',      l_rec.updated_by);
  APEX_JSON.write('updatedAt', TO_CHAR(FROM_TZ(l_rec.updated_at, 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
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

  -- Fields a caller may legitimately clear use a does_exist guard: present in
  -- the body (even empty) = update, absent = keep. Prevents partial-form
  -- callers (e.g. My Profile) from wiping fields they never sent.
  UPDATE dct_users SET
    display_name     = NVL(APEX_JSON.get_varchar2(p_path => 'displayName'),   display_name),
    display_name_ar  = CASE WHEN APEX_JSON.does_exist(p_path => 'displayNameAr')
                            THEN APEX_JSON.get_varchar2(p_path => 'displayNameAr')
                            ELSE display_name_ar END,
    email            = NVL(LOWER(TRIM(APEX_JSON.get_varchar2(p_path => 'email'))), email),
    mobile           = CASE WHEN APEX_JSON.does_exist(p_path => 'phone')
                            THEN APEX_JSON.get_varchar2(p_path => 'phone')
                            ELSE mobile END,
    employee_number  = CASE WHEN APEX_JSON.does_exist(p_path => 'employeeNumber')
                            THEN APEX_JSON.get_varchar2(p_path => 'employeeNumber')
                            ELSE employee_number END,
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
    -- GREATEST keeps end_date >= start_date (chk_dct_ur_dates): start_date
    -- defaults to SYSDATE with time, so a midnight end_date violates it for
    -- roles assigned the same day.
    UPDATE dct_user_roles SET is_active = 'N', end_date = GREATEST(SYSDATE, start_date)
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

    -- -------------------------------------------------------------------------
    -- User photo — PUT base64 JSON ({photo_data_b64, mime_type}), GET media.
    -- Mirrors the HR employees/:id/photo pattern (final apps/HR/db/06_hr_ords.sql).
    -- Client must keep base64 under 32k (canvas-resized thumbnail).
    -- GET is unauthenticated media (img tags cannot send Authorization), same
    -- trade-off as HR photos.
    -- -------------------------------------------------------------------------
    def_template('users/[COLON]id/photo');
    def_handler('users/[COLON]id/photo', 'PUT', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  v_blob  BLOB;
  v_raw   RAW(32767);
  v_b64   VARCHAR2(32767) := [COLON]photo_data_b64;
  v_len   NUMBER;
  v_pos   NUMBER := 1;
  v_chunk NUMBER := 32764;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF v_b64 IS NULL THEN dct_rest.err(400,'photo_data_b64 is required'); RETURN; END IF;
  DBMS_LOB.CREATETEMPORARY(v_blob, TRUE);
  v_len := LENGTH(v_b64);
  WHILE v_pos <= v_len LOOP
    v_raw := UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(SUBSTR(v_b64, v_pos, v_chunk)));
    DBMS_LOB.WRITEAPPEND(v_blob, UTL_RAW.LENGTH(v_raw), v_raw);
    v_pos := v_pos + v_chunk;
  END LOOP;
  UPDATE dct_users SET
    photo_blob      = v_blob,
    photo_mime_type = NVL([COLON]mime_type, 'image/jpeg'),
    photo_url       = '/ords/admin/dct/users/' || [COLON]id || '/photo',
    updated_by      = l_user,
    updated_at      = SYSTIMESTAMP
  WHERE user_id = [COLON]id;
  COMMIT;
  DBMS_LOB.FREETEMPORARY(v_blob);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.write('photoUrl', '/ords/admin/dct/users/' || [COLON]id || '/photo');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');
    ORDS.DEFINE_HANDLER(
        p_module_name  => c_mod,
        p_pattern      => REPLACE('users/[COLON]id/photo', '[COLON]', CHR(58)),
        p_method       => 'GET',
        p_source_type  => ORDS.SOURCE_TYPE_MEDIA,
        p_source       => REPLACE(
            q'!SELECT photo_mime_type, photo_blob FROM dct_users WHERE user_id = [COLON]id!',
            '[COLON]', CHR(58))
    );

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
  APEX_JSON.write('createdBy',   l_rec.created_by);
  APEX_JSON.write('createdAt', TO_CHAR(FROM_TZ(l_rec.created_at, 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
  APEX_JSON.write('updatedBy',   l_rec.updated_by);
  APEX_JSON.write('updatedAt', TO_CHAR(FROM_TZ(l_rec.updated_at, 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
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
           description_en, is_active, is_admin_only, display_order,
           created_by, created_at, updated_by, updated_at
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
    APEX_JSON.write('createdBy',   r.created_by);
    APEX_JSON.write('createdAt', TO_CHAR(FROM_TZ(r.created_at, 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.write('updatedBy',   r.updated_by);
    APEX_JSON.write('updatedAt', TO_CHAR(FROM_TZ(r.updated_at, 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
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
           o.created_by, o.created_at, o.updated_by, o.updated_at,
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
    APEX_JSON.write('createdBy',   r.created_by);
    APEX_JSON.write('createdAt', TO_CHAR(FROM_TZ(r.created_at, 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.write('updatedBy',   r.updated_by);
    APEX_JSON.write('updatedAt', TO_CHAR(FROM_TZ(r.updated_at, 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('orgs/', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_parent NUMBER;
  l_level  NUMBER := 1;
  l_path   VARCHAR2(900);
  l_name   VARCHAR2(200);
  l_id     NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_parent := APEX_JSON.get_number(p_path => 'parentOrgId');
  l_name   := APEX_JSON.get_varchar2(p_path => 'nameEn');
  IF l_name IS NULL THEN dct_rest.err(400,'nameEn is required'); RETURN; END IF;
  IF l_parent IS NOT NULL THEN
    SELECT level_no + 1, full_path || ' > ' || l_name
    INTO   l_level, l_path
    FROM   dct_organizations WHERE org_id = l_parent;
  ELSE
    l_path := l_name;
  END IF;
  INSERT INTO dct_organizations (
    org_code, org_name_en, org_name_ar, org_type, parent_org_id,
    level_no, full_path, is_active, created_by)
  VALUES (
    UPPER(TRIM(APEX_JSON.get_varchar2(p_path => 'orgCode'))),
    l_name,
    APEX_JSON.get_varchar2(p_path => 'nameAr'),
    NVL(APEX_JSON.get_varchar2(p_path => 'orgType'), 'SECTION'),
    l_parent, l_level, l_path,
    NVL(APEX_JSON.get_varchar2(p_path => 'isActive'), 'Y'),
    l_user
  ) RETURNING org_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('orgId', l_id);
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN ROLLBACK; dct_rest.err(409,'Organisation code already exists');
  WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('orgs/[COLON]id');
    def_handler('orgs/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE dct_organizations SET
    org_name_en   = NVL(APEX_JSON.get_varchar2(p_path => 'nameEn'), org_name_en),
    org_name_ar   = CASE WHEN APEX_JSON.does_exist(p_path => 'nameAr')
                         THEN APEX_JSON.get_varchar2(p_path => 'nameAr')
                         ELSE org_name_ar END,
    org_type      = NVL(APEX_JSON.get_varchar2(p_path => 'orgType'), org_type),
    parent_org_id = CASE WHEN APEX_JSON.does_exist(p_path => 'parentOrgId')
                         THEN APEX_JSON.get_number(p_path => 'parentOrgId')
                         ELSE parent_org_id END,
    is_active     = NVL(APEX_JSON.get_varchar2(p_path => 'isActive'), is_active),
    updated_by    = l_user, updated_at = SYSTIMESTAMP
  WHERE org_id = [COLON]id;
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
    -- LOOKUPS
    -- =========================================================================
    def_template('lookups/');
    -- Columns fixed post-UAT 2026-06-11: real tables use category_name_en /
    -- value_code / value_name_en / display_order (the old name_en /
    -- lookup_code / display_value_en / sort_order never existed -> HTTP 555)
    def_handler('lookups/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR c IN (SELECT category_id, category_code, category_name_en, category_name_ar, is_active
            FROM dct_lookup_categories ORDER BY category_name_en) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('categoryId',   c.category_id);
    APEX_JSON.write('categoryCode', c.category_code);
    APEX_JSON.write('nameEn',       c.category_name_en);
    APEX_JSON.write('nameAr',       c.category_name_ar);
    APEX_JSON.write('isActive',     c.is_active);
    APEX_JSON.open_array('values');
    FOR v IN (SELECT value_id, value_code, value_name_en, value_name_ar,
                     display_order, is_active,
                     created_by, created_at, updated_by, updated_at
              FROM dct_lookup_values
              WHERE category_id = c.category_id ORDER BY display_order, value_name_en) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('valueId',      v.value_id);
      APEX_JSON.write('lookupCode',   v.value_code);
      APEX_JSON.write('displayValue', v.value_name_en);
      APEX_JSON.write('displayAr',    v.value_name_ar);
      APEX_JSON.write('sortOrder',    v.display_order);
      APEX_JSON.write('isActive',     v.is_active);
      APEX_JSON.write('createdBy',    v.created_by);
      APEX_JSON.write('createdAt', TO_CHAR(FROM_TZ(v.created_at, 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
      APEX_JSON.write('updatedBy',    v.updated_by);
      APEX_JSON.write('updatedAt', TO_CHAR(FROM_TZ(v.updated_at, 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
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

    def_template('lookups/values');
    def_handler('lookups/values', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  INSERT INTO dct_lookup_values (
    category_id, value_code, value_name_en, value_name_ar, display_order, is_active, created_by)
  VALUES (
    APEX_JSON.get_number(p_path   => 'categoryId'),
    UPPER(TRIM(APEX_JSON.get_varchar2(p_path => 'lookupCode'))),
    APEX_JSON.get_varchar2(p_path => 'displayValue'),
    APEX_JSON.get_varchar2(p_path => 'displayAr'),
    NVL(APEX_JSON.get_number(p_path => 'sortOrder'),
        (SELECT NVL(MAX(display_order),0)+10 FROM dct_lookup_values
         WHERE category_id = APEX_JSON.get_number(p_path => 'categoryId'))),
    'Y', l_user
  ) RETURNING value_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('valueId', l_id);
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN ROLLBACK; dct_rest.err(409,'Value code already exists in this category');
  WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
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
    value_name_en = NVL(APEX_JSON.get_varchar2(p_path => 'displayValue'), value_name_en),
    value_name_ar = CASE WHEN APEX_JSON.does_exist(p_path => 'displayAr')
                         THEN APEX_JSON.get_varchar2(p_path => 'displayAr')
                         ELSE value_name_ar END,
    display_order = NVL(APEX_JSON.get_number(p_path  => 'sortOrder'), display_order),
    is_active     = NVL(APEX_JSON.get_varchar2(p_path => 'isActive'), is_active),
    updated_at    = SYSTIMESTAMP,
    updated_by    = l_user
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
    -- Public branding endpoint - the login page renders BEFORE any session
    -- exists, so it cannot call the authenticated settings/ handler. Exposes
    -- ONLY the whitelisted UI display keys; never add secrets here.
    def_template('branding');
    def_handler('branding', 'GET', q'!
BEGIN
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  FOR r IN (SELECT setting_key, setting_value FROM dct_system_settings
            WHERE setting_key IN ('APP_NAME','APP_NAME_AR','APP_TAGLINE','APP_TAGLINE_AR')) LOOP
    APEX_JSON.write(CASE r.setting_key
                      WHEN 'APP_NAME'       THEN 'appName'
                      WHEN 'APP_NAME_AR'    THEN 'appNameAr'
                      WHEN 'APP_TAGLINE'    THEN 'tagline'
                      WHEN 'APP_TAGLINE_AR' THEN 'taglineAr'
                    END, r.setting_value);
  END LOOP;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

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
  -- Columns fixed 2026-06-11: real table has value_type/category/is_system
  -- (handler previously referenced setting_type/is_editable/display_order
  --  which never existed -> the block failed to compile -> HTTP 555)
  FOR r IN (SELECT setting_key, setting_value, value_type, category,
                   description_en, is_system, is_encrypted,
                   created_by, created_at, updated_by, updated_at
            FROM dct_system_settings ORDER BY category, setting_key) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('key',         r.setting_key);
    APEX_JSON.write('value',       CASE
                                     WHEN r.is_encrypted = 'Y'
                                       OR r.setting_key LIKE '%API_KEY%'
                                       OR r.setting_key LIKE '%SECRET%'
                                       OR r.setting_key LIKE '%PASSWORD%'
                                       OR r.setting_key LIKE '%TOKEN%'
                                     THEN CASE WHEN r.setting_value IS NULL THEN NULL ELSE '********' END
                                     ELSE r.setting_value
                                   END);
    APEX_JSON.write('type',        r.value_type);
    APEX_JSON.write('category',    r.category);
    APEX_JSON.write('description', r.description_en);
    -- UAT 2026-06-11: the Admin console may edit every setting (incl. APP_NAME,
    -- which is is_system='Y'); secrets stay masked and refuse the mask on PUT.
    APEX_JSON.write('isEditable',  'Y');
    APEX_JSON.write('isSystem',    r.is_system);
    APEX_JSON.write('createdBy',   r.created_by);
    APEX_JSON.write('createdAt', TO_CHAR(FROM_TZ(r.created_at, 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.write('updatedBy',   r.updated_by);
    APEX_JSON.write('updatedAt', TO_CHAR(FROM_TZ(r.updated_at, 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('settings/[COLON]setkey');
    def_handler('settings/[COLON]setkey', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_val  VARCHAR2(4000);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_val := APEX_JSON.get_varchar2(p_path => 'value');
  IF l_val = '********' THEN
    dct_rest.json_header;
    APEX_JSON.initialize_output;
    APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.write('skipped', 'masked value'); APEX_JSON.close_object;
    RETURN;
  END IF;
  MERGE INTO dct_system_settings t
  USING (SELECT [COLON]setkey AS k FROM dual) s
  ON (t.setting_key = s.k)
  WHEN MATCHED THEN UPDATE SET
    t.setting_value = l_val,
    t.updated_by    = l_user,
    t.updated_at    = SYSTIMESTAMP
  WHEN NOT MATCHED THEN INSERT
    (setting_key, setting_value, value_type, category, is_system, created_by)
  VALUES
    (s.k, l_val,
     CASE WHEN s.k LIKE 'FEATURE\_%' ESCAPE '\' THEN 'BOOLEAN' ELSE 'STRING' END,
     CASE WHEN s.k LIKE 'FEATURE\_%' ESCAPE '\' THEN 'FEATURES'
          WHEN s.k LIKE 'LANDING\_%' ESCAPE '\' THEN 'UI'
          ELSE 'GENERAL' END,
     'N', l_user);
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
  -- Columns fixed 2026-06-11: real table is bilingual (title_en/body_en);
  -- the old title/body references never compiled -> HTTP 555
  FOR r IN (
    SELECT notification_id, title_en, body_en, notification_type,
           is_read, created_at
    FROM   dct_notifications
    WHERE  recipient_user_id = l_uid
      AND  (expires_at IS NULL OR expires_at > SYSTIMESTAMP)
    ORDER BY created_at DESC
    FETCH FIRST 50 ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('notifId',   r.notification_id);
    APEX_JSON.write('title',     r.title_en);
    APEX_JSON.write('body',      r.body_en);
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
    -- APPROVALS — unified cross-module queue + monitor + templates (UAT 2026-06-11)
    -- Source modules: PETTY_CASH / REIMBURSEMENT / CLEARING (PC) and
    -- TRAVEL_REQUEST / SETTLEMENT (DT). Reads need the PC/DT ADMIN synonyms
    -- (dct_petty_cash, dt_requests, ... — created by the module ORDS scripts).
    -- =========================================================================
    def_template('approvals/pending');
    def_handler('approvals/pending', 'GET', q'!
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
    JOIN   dct_roles              rol ON rol.role_id     = ast.required_role_id
    JOIN   dct_users              sub ON sub.user_id     = ai.submitted_by
    WHERE  ai.overall_status = 'PENDING'
      AND (INSTR(l_roles, ',' || rol.role_code || ',') > 0
           OR INSTR(l_roles, ',SYS_ADMIN,') > 0
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
    APEX_JSON.write('requestedAt',     TO_CHAR(r.submitted_at,'YYYY-MM-DD HH24:MI'));
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
!');

    def_template('approvals/');
    def_handler('approvals/', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_status VARCHAR2(20)  := UPPER([COLON]status);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT ai.instance_id, ai.source_module, ai.source_record_ref,
           ai.overall_status, ai.submitted_at, t.template_name,
           sub.display_name AS submitted_by_name,
           TRUNC(SYSDATE - CAST(ai.submitted_at AS DATE)) AS days_old,
           (SELECT COUNT(*) FROM dct_approval_steps s2 WHERE s2.template_id = ai.template_id) AS total_steps,
           NVL((SELECT COUNT(*) FROM dct_approval_steps s3 WHERE s3.template_id = ai.template_id
             AND s3.step_seq <= ai.current_step_seq), 0) AS current_step,
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
           END, 0) AS amount
    FROM   dct_approval_instances ai
    JOIN   dct_approval_templates t  ON t.template_id = ai.template_id
    JOIN   dct_users              sub ON sub.user_id  = ai.submitted_by
    WHERE (l_status IS NULL OR ai.overall_status = l_status)
    ORDER BY ai.submitted_at DESC
    FETCH FIRST 200 ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('instanceId',    r.instance_id);
    APEX_JSON.write('requestRef',    NVL(r.source_record_ref, '-'));
    APEX_JSON.write('module',        r.source_module);
    APEX_JSON.write('templateName',  NVL(r.template_name, '-'));
    APEX_JSON.write('requestedBy',   NVL(r.submitted_by_name, '-'));
    APEX_JSON.write('requestedAt',   TO_CHAR(r.submitted_at,'YYYY-MM-DD HH24:MI'));
    APEX_JSON.write('amount',        r.amount);
    APEX_JSON.write('currentStep',   r.current_step);
    APEX_JSON.write('totalSteps',    NVL(r.total_steps, 1));
    APEX_JSON.write('overallStatus', r.overall_status);
    APEX_JSON.write('daysOld',       NVL(r.days_old, 0));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('approvals/[COLON]id/action');
    def_handler('approvals/[COLON]id/action', 'POST', q'!
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
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('approval-templates/');
    def_handler('approval-templates/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT t.template_id, t.template_code, t.template_name, t.request_type,
           t.is_active, t.parent_template_id, NVL(t.version_no, 1) AS version_no,
           m.module_code,
           (SELECT COUNT(*) FROM dct_approval_steps s WHERE s.template_id = t.template_id) AS step_count
    FROM   dct_approval_templates t
    LEFT JOIN dct_modules m ON m.module_id = t.module_id
    ORDER BY m.module_code, t.template_name, t.version_no
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('templateId',   r.template_id);
    APEX_JSON.write('templateCode', NVL(r.template_code, '-'));
    APEX_JSON.write('templateName', NVL(r.template_name, '-'));
    APEX_JSON.write('module',       NVL(r.module_code, '-'));
    APEX_JSON.write('requestType',  NVL(r.request_type, '-'));
    APEX_JSON.write('stepCount',    NVL(r.step_count, 0));
    APEX_JSON.write('isActive',     r.is_active);
    APEX_JSON.write('versionNo',    r.version_no);
    IF r.parent_template_id IS NOT NULL THEN
      APEX_JSON.write('parentTemplateId', r.parent_template_id);
    END IF;
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('approval-templates/[COLON]id');
    def_handler('approval-templates/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_seq  NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  FOR t IN (
    SELECT t.template_id, t.template_code, t.template_name, t.request_type,
           t.is_active, t.parent_template_id, NVL(t.version_no, 1) AS version_no,
           m.module_code,
           t.created_by, t.created_at, t.updated_by, t.updated_at
    FROM   dct_approval_templates t
    LEFT JOIN dct_modules m ON m.module_id = t.module_id
    WHERE  t.template_id = [COLON]id
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('templateId',   t.template_id);
    APEX_JSON.write('templateCode', NVL(t.template_code, '-'));
    APEX_JSON.write('templateName', NVL(t.template_name, '-'));
    APEX_JSON.write('module',       NVL(t.module_code, '-'));
    APEX_JSON.write('requestType',  NVL(t.request_type, '-'));
    APEX_JSON.write('isActive',     t.is_active);
    APEX_JSON.write('versionNo',    t.version_no);
    IF t.parent_template_id IS NOT NULL THEN
      APEX_JSON.write('parentTemplateId', t.parent_template_id);
    END IF;
    APEX_JSON.write('createdBy',    t.created_by);
    APEX_JSON.write('createdAt', TO_CHAR(FROM_TZ(t.created_at, 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.write('updatedBy',    t.updated_by);
    APEX_JSON.write('updatedAt', TO_CHAR(FROM_TZ(t.updated_at, 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.open_array('steps');
    FOR s IN (
      SELECT s.step_id, s.step_seq, s.step_name, s.escalation_days, r.role_code
      FROM   dct_approval_steps s
      LEFT JOIN dct_roles r ON r.role_id = s.required_role_id
      WHERE  s.template_id = t.template_id
      ORDER BY s.step_seq
    ) LOOP
      l_seq := l_seq + 1;
      APEX_JSON.open_object;
      APEX_JSON.write('stepId',   s.step_id);
      APEX_JSON.write('seq',      l_seq);
      APEX_JSON.write('label',    NVL(s.step_name, 'Step ' || l_seq));
      APEX_JSON.write('roleCode', NVL(s.role_code, '-'));
      APEX_JSON.write('slaHours', NVL(s.escalation_days, 0) * 24);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.close_object;
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('approval-templates/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE dct_approval_templates SET
    template_name = NVL(APEX_JSON.get_varchar2(p_path => 'templateName'), template_name),
    is_active     = NVL(APEX_JSON.get_varchar2(p_path => 'isActive'), is_active),
    updated_by    = l_user, updated_at = SYSTIMESTAMP
  WHERE template_id = [COLON]id;
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
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_limit  NUMBER        := LEAST(NVL(TO_NUMBER([COLON]limit DEFAULT NULL ON CONVERSION ERROR), 50), 200);
  l_offset NUMBER        := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_search VARCHAR2(200) := [COLON]search;
  l_action VARCHAR2(100) := UPPER([COLON]action);
  l_from   DATE          := TO_DATE([COLON]fromdt DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
  l_to     DATE          := TO_DATE([COLON]todt   DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;

  SELECT COUNT(*) INTO l_total
  FROM   dct_audit_log
  WHERE (l_action IS NULL OR action = l_action)
    AND (l_from   IS NULL OR logged_at >= l_from)
    AND (l_to     IS NULL OR logged_at <  l_to + 1)
    AND (l_search IS NULL OR
         UPPER(NVL(username,'') || ' ' || NVL(object_type,'') || ' ' || NVL(object_id,''))
         LIKE '%' || UPPER(l_search) || '%');

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total',  l_total);
  APEX_JSON.write('limit',  l_limit);
  APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT log_id, username, action, object_type, object_id,
           status, error_message, logged_at
    FROM   dct_audit_log
    WHERE (l_action IS NULL OR action = l_action)
      AND (l_from   IS NULL OR logged_at >= l_from)
      AND (l_to     IS NULL OR logged_at <  l_to + 1)
      AND (l_search IS NULL OR
           UPPER(NVL(username,'') || ' ' || NVL(object_type,'') || ' ' || NVL(object_id,''))
           LIKE '%' || UPPER(l_search) || '%')
    ORDER BY logged_at DESC
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
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

    -- =========================================================================
    -- STATS (Phase 3 — Admin dashboard charts)
    -- =========================================================================
    def_template('stats/');
    def_handler('stats/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;

  -- Headline counts
  FOR c IN (
    SELECT (SELECT COUNT(*) FROM dct_users WHERE is_active = 'Y')           AS active_users,
           (SELECT COUNT(*) FROM dct_modules WHERE is_active = 'Y')         AS active_modules,
           (SELECT COUNT(*) FROM dct_roles)                                  AS roles_defined,
           (SELECT COUNT(*) FROM dct_approval_instances
             WHERE overall_status = 'PENDING')                               AS pending_approvals,
           (SELECT COUNT(*) FROM dct_sessions
             WHERE is_active = 'Y' AND logout_at IS NULL
               AND last_activity_at > SYSTIMESTAMP - INTERVAL '8' HOUR)      AS active_sessions
    FROM dual
  ) LOOP
    APEX_JSON.write('activeUsers',      c.active_users);
    APEX_JSON.write('activeModules',    c.active_modules);
    APEX_JSON.write('rolesDefined',     c.roles_defined);
    APEX_JSON.write('pendingApprovals', c.pending_approvals);
    APEX_JSON.write('activeSessions',   c.active_sessions);
  END LOOP;

  -- Chart 1: approval cycle time per module (completed, last 90 days)
  APEX_JSON.open_array('approvalCycle');
  FOR r IN (
    SELECT m.module_code,
           ROUND(AVG(CAST(ai.completed_at AS DATE) - CAST(ai.created_at AS DATE)), 1) AS avg_days,
           COUNT(*) AS n
    FROM   dct_approval_instances ai
    JOIN   dct_approval_templates t ON t.template_id = ai.template_id
    JOIN   dct_modules            m ON m.module_id   = t.module_id
    WHERE  ai.completed_at IS NOT NULL
    AND    ai.created_at  >= SYSDATE - 90
    GROUP  BY m.module_code
    ORDER  BY m.module_code
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('module',  r.module_code);
    APEX_JSON.write('avgDays', NVL(r.avg_days, 0));
    APEX_JSON.write('count',   r.n);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  -- Chart 2: platform activity by day (last 30 days, logins vs other actions)
  APEX_JSON.open_array('activity');
  FOR r IN (
    SELECT TRUNC(logged_at) AS d,
           SUM(CASE WHEN action = 'LOGIN' THEN 1 ELSE 0 END)  AS logins,
           SUM(CASE WHEN action != 'LOGIN' THEN 1 ELSE 0 END) AS actions
    FROM   dct_audit_log
    WHERE  logged_at >= TRUNC(SYSDATE) - 29
    GROUP  BY TRUNC(logged_at)
    ORDER  BY 1
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('day',     TO_CHAR(r.d, 'YYYY-MM-DD'));
    APEX_JSON.write('logins',  r.logins);
    APEX_JSON.write('actions', r.actions);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- USER PREFERENCES (Phase 3 — language etc., DCT_USER_PREFERENCES)
    -- =========================================================================
    def_template('prefs/');
    def_handler('prefs/', 'GET', q'!
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
    SELECT pref_key, pref_value FROM dct_user_preferences
    WHERE  user_id = l_uid ORDER BY pref_key
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('key',   r.pref_key);
    APEX_JSON.write('value', r.pref_value);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('prefs/[COLON]prefkey');
    def_handler('prefs/[COLON]prefkey', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
  l_val  VARCHAR2(4000);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);
  l_val := APEX_JSON.get_varchar2(p_path => 'value');

  MERGE INTO dct_user_preferences t
  USING (SELECT l_uid AS user_id, [COLON]prefkey AS pref_key FROM dual) s
  ON (t.user_id = s.user_id AND t.pref_key = s.pref_key)
  WHEN NOT MATCHED THEN
    INSERT (user_id, pref_key, pref_value) VALUES (l_uid, [COLON]prefkey, l_val)
  WHEN MATCHED THEN
    UPDATE SET t.pref_value = l_val, t.updated_at = SYSTIMESTAMP;
  COMMIT;

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- DELEGATIONS (Phase 4 — absence cover; lazy expiry on every list call)
    -- =========================================================================
    def_template('delegations/');
    def_handler('delegations/', 'GET', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_uid   NUMBER;
  l_mine  VARCHAR2(1) := UPPER([COLON]mine);
  l_admin BOOLEAN;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid   := dct_auth.get_user_id(l_user);
  l_admin := dct_auth.has_role(l_user, 'SYS_ADMIN');
  UPDATE dct_delegations SET status = 'EXPIRED', updated_at = SYSTIMESTAMP
  WHERE status = 'ACTIVE' AND end_date < TRUNC(SYSDATE);
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT d.delegation_id, d.delegator_id, fr.display_name AS delegator_name,
           d.delegate_id, de.display_name AS delegate_name,
           d.scope, d.role_id, rl.role_code, rl.role_name_en,
           d.module_id, m.module_code, m.module_name_en,
           d.start_date, d.end_date, d.reason, d.status, d.created_at
    FROM   dct_delegations d
    JOIN   dct_users fr ON fr.user_id = d.delegator_id
    JOIN   dct_users de ON de.user_id = d.delegate_id
    LEFT JOIN dct_roles   rl ON rl.role_id   = d.role_id
    LEFT JOIN dct_modules m  ON m.module_id  = d.module_id
    WHERE ( (l_mine = 'Y' OR NOT l_admin)
            AND (d.delegator_id = l_uid OR d.delegate_id = l_uid) )
       OR ( l_admin AND NVL(l_mine,'N') != 'Y' )
    ORDER BY d.status, d.end_date DESC, d.delegation_id DESC
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('delegationId',  r.delegation_id);
    APEX_JSON.write('delegatorId',   r.delegator_id);
    APEX_JSON.write('delegatorName', r.delegator_name);
    APEX_JSON.write('delegateId',    r.delegate_id);
    APEX_JSON.write('delegateName',  r.delegate_name);
    APEX_JSON.write('scope',         r.scope);
    APEX_JSON.write('roleId',        r.role_id);
    APEX_JSON.write('roleCode',      NVL(r.role_code, ''));
    APEX_JSON.write('roleName',      NVL(r.role_name_en, ''));
    APEX_JSON.write('moduleCode',    NVL(r.module_code, ''));
    APEX_JSON.write('moduleName',    NVL(r.module_name_en, ''));
    APEX_JSON.write('startDate',     TO_CHAR(r.start_date, 'YYYY-MM-DD'));
    APEX_JSON.write('endDate',       TO_CHAR(r.end_date, 'YYYY-MM-DD'));
    APEX_JSON.write('reason',        NVL(r.reason, ''));
    APEX_JSON.write('status',        r.status);
    APEX_JSON.write('createdAt',     TO_CHAR(r.created_at AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('delegations/', 'POST', q'!
DECLARE
  l_user      VARCHAR2(100) := dct_rest.validate_session;
  l_uid       NUMBER;
  l_delegator NUMBER;
  l_module_id NUMBER := NULL;
  l_mod_code  VARCHAR2(50);
  l_id        NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);
  l_delegator := NVL(APEX_JSON.get_number(p_path => 'delegatorId'), l_uid);
  IF l_delegator != l_uid AND NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN may create delegations for other users'); RETURN;
  END IF;
  l_mod_code := APEX_JSON.get_varchar2(p_path => 'moduleCode');
  IF l_mod_code IS NOT NULL THEN
    SELECT module_id INTO l_module_id FROM dct_modules WHERE module_code = l_mod_code;
  END IF;
  INSERT INTO dct_delegations (
    delegator_id, delegate_id, scope, role_id, module_id,
    start_date, end_date, reason, status, created_by, updated_by
  ) VALUES (
    l_delegator,
    APEX_JSON.get_number(p_path => 'delegateId'),
    NVL(UPPER(APEX_JSON.get_varchar2(p_path => 'scope')), 'ALL_ROLES'),
    APEX_JSON.get_number(p_path => 'roleId'),
    l_module_id,
    NVL(TO_DATE(APEX_JSON.get_varchar2(p_path => 'startDate'), 'YYYY-MM-DD'), TRUNC(SYSDATE)),
    TO_DATE(APEX_JSON.get_varchar2(p_path => 'endDate'), 'YYYY-MM-DD'),
    APEX_JSON.get_varchar2(p_path => 'reason'),
    'ACTIVE', l_user, l_user
  ) RETURNING delegation_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('delegationId', l_id); APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('delegations/[COLON]id/cancel');
    def_handler('delegations/[COLON]id/cancel', 'POST', q'!
DECLARE
  l_user      VARCHAR2(100) := dct_rest.validate_session;
  l_uid       NUMBER;
  l_delegator NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  SELECT delegator_id INTO l_delegator FROM dct_delegations WHERE delegation_id = [COLON]id;
  IF l_delegator != l_uid AND NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only the delegator or SYS_ADMIN may cancel a delegation'); RETURN;
  END IF;
  UPDATE dct_delegations SET
    status = 'CANCELLED', updated_by = l_user, updated_at = SYSTIMESTAMP
  WHERE delegation_id = [COLON]id AND status = 'ACTIVE';
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- ANNOUNCEMENTS (Phase 4 — platform banner + Admin management)
    -- =========================================================================
    def_template('announcements/');
    def_handler('announcements/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT a.announcement_id, a.title_en, a.title_ar, a.body_en, a.body_ar,
           a.severity, a.target_audience, a.target_role_id, rl.role_name_en,
           a.target_module_id, m.module_code, m.module_name_en,
           a.published_at, a.expires_at, a.is_active, a.created_by, a.created_at
    FROM   dct_announcements a
    LEFT JOIN dct_roles   rl ON rl.role_id  = a.target_role_id
    LEFT JOIN dct_modules m  ON m.module_id = a.target_module_id
    ORDER BY a.announcement_id DESC
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('announcementId', r.announcement_id);
    APEX_JSON.write('titleEn',     r.title_en);
    APEX_JSON.write('titleAr',     NVL(r.title_ar, ''));
    APEX_JSON.write('bodyEn',      NVL(DBMS_LOB.SUBSTR(r.body_en, 3000, 1), ''));
    APEX_JSON.write('bodyAr',      NVL(DBMS_LOB.SUBSTR(r.body_ar, 3000, 1), ''));
    APEX_JSON.write('severity',    r.severity);
    APEX_JSON.write('audience',    r.target_audience);
    APEX_JSON.write('roleId',      r.target_role_id);
    APEX_JSON.write('roleName',    NVL(r.role_name_en, ''));
    APEX_JSON.write('moduleCode',  NVL(r.module_code, ''));
    APEX_JSON.write('moduleName',  NVL(r.module_name_en, ''));
    APEX_JSON.write('publishedAt', TO_CHAR(r.published_at AT TIME ZONE 'Asia/Dubai','YYYY-MM-DD HH24:MI'));
    APEX_JSON.write('expiresAt',   TO_CHAR(r.expires_at AT TIME ZONE 'Asia/Dubai','YYYY-MM-DD HH24:MI'));
    APEX_JSON.write('isActive',    r.is_active);
    APEX_JSON.write('createdBy',   NVL(r.created_by, ''));
    APEX_JSON.write('createdAt',   TO_CHAR(r.created_at AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('announcements/', 'POST', q'!
DECLARE
  l_user      VARCHAR2(100) := dct_rest.validate_session;
  l_module_id NUMBER := NULL;
  l_mod_code  VARCHAR2(50);
  l_id        NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN can manage announcements'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_mod_code := APEX_JSON.get_varchar2(p_path => 'moduleCode');
  IF l_mod_code IS NOT NULL THEN
    SELECT module_id INTO l_module_id FROM dct_modules WHERE module_code = l_mod_code;
  END IF;
  INSERT INTO dct_announcements (
    title_en, title_ar, body_en, body_ar, severity,
    target_audience, target_role_id, target_module_id,
    published_at, expires_at, is_active, created_by, updated_by
  ) VALUES (
    APEX_JSON.get_varchar2(p_path => 'titleEn'),
    APEX_JSON.get_varchar2(p_path => 'titleAr'),
    APEX_JSON.get_varchar2(p_path => 'bodyEn'),
    APEX_JSON.get_varchar2(p_path => 'bodyAr'),
    NVL(UPPER(APEX_JSON.get_varchar2(p_path => 'severity')), 'INFO'),
    NVL(UPPER(APEX_JSON.get_varchar2(p_path => 'audience')), 'ALL'),
    APEX_JSON.get_number(p_path => 'roleId'),
    l_module_id,
    NVL(TO_TIMESTAMP(APEX_JSON.get_varchar2(p_path => 'publishedAt'), 'YYYY-MM-DD"T"HH24:MI'), SYSTIMESTAMP),
    TO_TIMESTAMP(APEX_JSON.get_varchar2(p_path => 'expiresAt'), 'YYYY-MM-DD"T"HH24:MI'),
    NVL(UPPER(APEX_JSON.get_varchar2(p_path => 'isActive')), 'Y'),
    l_user, l_user
  ) RETURNING announcement_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('announcementId', l_id); APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('announcements/[COLON]id');
    def_handler('announcements/[COLON]id', 'PUT', q'!
DECLARE
  l_user      VARCHAR2(100) := dct_rest.validate_session;
  l_module_id NUMBER := NULL;
  l_mod_code  VARCHAR2(50);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN can manage announcements'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_mod_code := APEX_JSON.get_varchar2(p_path => 'moduleCode');
  IF l_mod_code IS NOT NULL THEN
    SELECT module_id INTO l_module_id FROM dct_modules WHERE module_code = l_mod_code;
  END IF;
  UPDATE dct_announcements SET
    title_en  = NVL(APEX_JSON.get_varchar2(p_path => 'titleEn'), title_en),
    title_ar  = CASE WHEN APEX_JSON.does_exist(p_path => 'titleAr')
                     THEN APEX_JSON.get_varchar2(p_path => 'titleAr') ELSE title_ar END,
    body_en   = CASE WHEN APEX_JSON.does_exist(p_path => 'bodyEn')
                     THEN TO_CLOB(APEX_JSON.get_varchar2(p_path => 'bodyEn')) ELSE body_en END,
    body_ar   = CASE WHEN APEX_JSON.does_exist(p_path => 'bodyAr')
                     THEN TO_CLOB(APEX_JSON.get_varchar2(p_path => 'bodyAr')) ELSE body_ar END,
    severity  = NVL(UPPER(APEX_JSON.get_varchar2(p_path => 'severity')), severity),
    target_audience = NVL(UPPER(APEX_JSON.get_varchar2(p_path => 'audience')), target_audience),
    target_role_id  = CASE WHEN APEX_JSON.does_exist(p_path => 'roleId')
                           THEN APEX_JSON.get_number(p_path => 'roleId') ELSE target_role_id END,
    target_module_id = CASE WHEN APEX_JSON.does_exist(p_path => 'moduleCode')
                            THEN l_module_id ELSE target_module_id END,
    published_at = CASE WHEN APEX_JSON.does_exist(p_path => 'publishedAt')
                        THEN TO_TIMESTAMP(APEX_JSON.get_varchar2(p_path => 'publishedAt'), 'YYYY-MM-DD"T"HH24:MI')
                        ELSE published_at END,
    expires_at   = CASE WHEN APEX_JSON.does_exist(p_path => 'expiresAt')
                        THEN TO_TIMESTAMP(APEX_JSON.get_varchar2(p_path => 'expiresAt'), 'YYYY-MM-DD"T"HH24:MI')
                        ELSE expires_at END,
    is_active = NVL(UPPER(APEX_JSON.get_varchar2(p_path => 'isActive')), is_active),
    updated_by = l_user, updated_at = SYSTIMESTAMP
  WHERE announcement_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('announcements/active');
    def_handler('announcements/active', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_uid    NUMBER;
  l_module VARCHAR2(50) := UPPER([COLON]module);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT a.announcement_id, a.title_en, a.title_ar, a.body_en, a.body_ar, a.severity
    FROM   dct_announcements a
    LEFT JOIN dct_modules m ON m.module_id = a.target_module_id
    WHERE  a.is_active = 'Y'
      AND  a.published_at <= SYSTIMESTAMP
      AND (a.expires_at IS NULL OR a.expires_at > SYSTIMESTAMP)
      AND ( a.target_audience = 'ALL'
            OR (a.target_audience = 'MODULE' AND l_module IS NOT NULL AND m.module_code = l_module)
            OR (a.target_audience = 'ROLE' AND EXISTS (
                  SELECT 1 FROM dct_user_roles ur
                  WHERE ur.user_id = l_uid AND ur.role_id = a.target_role_id
                    AND ur.is_active = 'Y'
                    AND (ur.end_date IS NULL OR ur.end_date >= SYSDATE))) )
    ORDER BY CASE a.severity WHEN 'CRITICAL' THEN 1 WHEN 'WARNING' THEN 2 ELSE 3 END,
             a.published_at DESC
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('announcementId', r.announcement_id);
    APEX_JSON.write('titleEn',  r.title_en);
    APEX_JSON.write('titleAr',  NVL(r.title_ar, ''));
    APEX_JSON.write('bodyEn',   NVL(DBMS_LOB.SUBSTR(r.body_en, 3000, 1), ''));
    APEX_JSON.write('bodyAr',   NVL(DBMS_LOB.SUBSTR(r.body_ar, 3000, 1), ''));
    APEX_JSON.write('severity', r.severity);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- WAVE ENHANCEMENTS (db/v2/19, post-UAT 12-Jun-2026)
    -- boot (one-call shell bootstrap), notifications/count (badge poll),
    -- audit/:id (diff snapshots), approval-template draft lifecycle.
    -- =========================================================================
    def_template('boot');
    def_handler('boot', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
  l_cnt  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  SELECT COUNT(*) INTO l_cnt
  FROM   dct_notifications
  WHERE  recipient_user_id = l_uid AND is_read = 'N'
    AND  (expires_at IS NULL OR expires_at > SYSTIMESTAMP);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('unreadCount', l_cnt);
  APEX_JSON.open_object('prefs');
  FOR p IN (SELECT pref_key, pref_value FROM dct_user_preferences WHERE user_id = l_uid) LOOP
    APEX_JSON.write(p.pref_key, p.pref_value);
  END LOOP;
  APEX_JSON.close_object;
  APEX_JSON.open_array('settings');
  FOR s IN (SELECT setting_key, setting_value
            FROM   dct_system_settings
            WHERE  setting_key LIKE 'FEATURE\_%' ESCAPE '\'
               OR  setting_key LIKE 'LANDING\_%' ESCAPE '\'
               OR  setting_key IN ('THEME_BRAND_COLOR','SESSION_TIMEOUT_MINS','APP_THEME')) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('key',   s.setting_key);
    APEX_JSON.write('value', s.setting_value);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('notifications/count');
    def_handler('notifications/count', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
  l_cnt  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  SELECT COUNT(*) INTO l_cnt
  FROM   dct_notifications
  WHERE  recipient_user_id = l_uid AND is_read = 'N'
    AND  (expires_at IS NULL OR expires_at > SYSTIMESTAMP);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('count', l_cnt);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('audit/[COLON]id');
    def_handler('audit/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  FOR r IN (SELECT log_id, old_values, new_values
            FROM dct_audit_log WHERE log_id = [COLON]id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('logId',     r.log_id);
    APEX_JSON.write('oldValues', r.old_values);
    APEX_JSON.write('newValues', r.new_values);
    APEX_JSON.close_object;
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('approval-templates/[COLON]id/clone');
    def_handler('approval-templates/[COLON]id/clone', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_code VARCHAR2(100);
  l_cnt  NUMBER;
  l_new  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN may manage templates'); RETURN;
  END IF;
  SELECT template_code INTO l_code
  FROM dct_approval_templates WHERE template_id = [COLON]id;
  IF INSTR(l_code, CHR(126)) > 0 THEN
    dct_rest.err(409,'Only live templates can be cloned'); RETURN;
  END IF;
  SELECT COUNT(*) INTO l_cnt FROM dct_approval_templates
  WHERE template_code = l_code || CHR(126) || 'D';
  IF l_cnt > 0 THEN
    dct_rest.err(409,'A draft already exists for this template'); RETURN;
  END IF;
  INSERT INTO dct_approval_templates (
    template_code, template_name, template_name_ar, module_id, request_type,
    description_en, description_ar, is_sequential, auto_approve_days,
    is_active, parent_template_id, version_no, created_by)
  SELECT template_code || CHR(126) || 'D', template_name, template_name_ar,
         module_id, request_type, description_en, description_ar,
         is_sequential, auto_approve_days,
         'N', template_id, NVL(version_no, 1), l_user
  FROM dct_approval_templates WHERE template_id = [COLON]id;
  SELECT template_id INTO l_new FROM dct_approval_templates
  WHERE template_code = l_code || CHR(126) || 'D';
  INSERT INTO dct_approval_steps (
    template_id, step_seq, step_name, step_name_ar, step_type,
    required_role_id, specific_user_id, escalation_days, escalate_role_id,
    is_mandatory, allow_skip, condition_type, amount_operator,
    amount_threshold, type_filter, custom_condition, created_by)
  SELECT l_new, step_seq, step_name, step_name_ar, step_type,
         required_role_id, specific_user_id, escalation_days, escalate_role_id,
         is_mandatory, allow_skip, condition_type, amount_operator,
         amount_threshold, type_filter, custom_condition, l_user
  FROM dct_approval_steps WHERE template_id = [COLON]id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('templateId', l_new);
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION
  WHEN NO_DATA_FOUND THEN ROLLBACK; dct_rest.err(404,'Template not found');
  WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('approval-templates/[COLON]id/activate');
    def_handler('approval-templates/[COLON]id/activate', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_parent NUMBER;
  l_code   VARCHAR2(100);
  l_ver    NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN may manage templates'); RETURN;
  END IF;
  SELECT parent_template_id INTO l_parent
  FROM dct_approval_templates WHERE template_id = [COLON]id;
  IF l_parent IS NULL THEN
    dct_rest.err(409,'Only drafts can be activated'); RETURN;
  END IF;
  SELECT template_code, NVL(version_no, 1) INTO l_code, l_ver
  FROM dct_approval_templates WHERE template_id = l_parent;
  UPDATE dct_approval_templates
  SET    template_code = template_code || CHR(126) || 'V' || l_ver,
         is_active = 'N', updated_by = l_user, updated_at = SYSTIMESTAMP
  WHERE  template_id = l_parent;
  UPDATE dct_approval_templates
  SET    template_code = l_code, is_active = 'Y',
         version_no = l_ver + 1, parent_template_id = NULL,
         updated_by = l_user, updated_at = SYSTIMESTAMP
  WHERE  template_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION
  WHEN NO_DATA_FOUND THEN ROLLBACK; dct_rest.err(404,'Template not found');
  WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('approval-templates/[COLON]id/steps');
    def_handler('approval-templates/[COLON]id/steps', 'PUT', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_parent NUMBER;
  l_n      NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN may manage templates'); RETURN;
  END IF;
  SELECT parent_template_id INTO l_parent
  FROM dct_approval_templates WHERE template_id = [COLON]id;
  IF l_parent IS NULL THEN
    dct_rest.err(409,'Steps can only be edited on drafts'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_n := NVL(APEX_JSON.get_count(p_path => 'steps'), 0);
  FOR i IN 1 .. l_n LOOP
    UPDATE dct_approval_steps
    SET    step_seq = 1000 + APEX_JSON.get_number(p_path => 'steps[%d].seq', p0 => i)
    WHERE  step_id     = APEX_JSON.get_number(p_path => 'steps[%d].stepId', p0 => i)
      AND  template_id = [COLON]id;
  END LOOP;
  FOR i IN 1 .. l_n LOOP
    UPDATE dct_approval_steps
    SET    step_seq        = APEX_JSON.get_number(p_path => 'steps[%d].seq', p0 => i),
           step_name       = NVL(APEX_JSON.get_varchar2(p_path => 'steps[%d].label', p0 => i), step_name),
           escalation_days = NVL(APEX_JSON.get_number(p_path => 'steps[%d].slaHours', p0 => i) / 24, escalation_days),
           updated_by      = l_user, updated_at = SYSTIMESTAMP
    WHERE  step_id     = APEX_JSON.get_number(p_path => 'steps[%d].stepId', p0 => i)
      AND  template_id = [COLON]id;
  END LOOP;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION
  WHEN NO_DATA_FOUND THEN ROLLBACK; dct_rest.err(404,'Template not found');
  WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- ENHANCEMENT ROUND 2 (db/v2/20, post-UAT 13-Jun-2026)
    -- audit/export CSV, sessions list + revoke, archived-version restore.
    -- settings PUT (upsert) and audit/ GET (date filters) updated in place.
    -- =========================================================================
    -- -------------------------------------------------------------------------
    -- audit/export GET -- server-built CSV (full filtered history, 20k cap,
    -- UTF-8 BOM so Excel renders Arabic). Same filters as audit/ GET.
    -- -------------------------------------------------------------------------
    def_template('audit/export');
    def_handler('audit/export', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_search VARCHAR2(200) := [COLON]search;
  l_action VARCHAR2(100) := UPPER([COLON]action);
  l_from   DATE          := TO_DATE([COLON]fromdt DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
  l_to     DATE          := TO_DATE([COLON]todt   DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
  l_n      NUMBER := 0;
  FUNCTION esc(p VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    IF p IS NULL THEN RETURN NULL; END IF;
    IF INSTR(p, '"') > 0 OR INSTR(p, ',') > 0 OR INSTR(p, CHR(10)) > 0 THEN
      RETURN '"' || REPLACE(p, '"', '""') || '"';
    END IF;
    RETURN p;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN may export the audit log'); RETURN;
  END IF;
  OWA_UTIL.mime_header('text/csv', FALSE, 'UTF-8');
  HTP.p('Content-Disposition: attachment; filename="audit-log-' ||
        TO_CHAR(SYSDATE,'YYYY-MM-DD') || '.csv"');
  OWA_UTIL.http_header_close;
  HTP.prn(UNISTR('\FEFF'));   -- UTF-8 BOM so Excel renders Arabic (CHR bytes raise ORA-29275 in AL32UTF8)
  HTP.print('loggedAt,username,action,objectType,objectId,status,error');
  FOR r IN (
    SELECT log_id, username, action, object_type, object_id,
           status, error_message, logged_at
    FROM   dct_audit_log
    WHERE (l_action IS NULL OR action = l_action)
      AND (l_from   IS NULL OR logged_at >= l_from)
      AND (l_to     IS NULL OR logged_at <  l_to + 1)
      AND (l_search IS NULL OR
           UPPER(NVL(username,'') || ' ' || NVL(object_type,'') || ' ' || NVL(object_id,''))
           LIKE '%' || UPPER(l_search) || '%')
    ORDER BY logged_at DESC
  ) LOOP
    EXIT WHEN l_n >= 20000;
    l_n := l_n + 1;
    HTP.print(
      TO_CHAR(r.logged_at,'YYYY-MM-DD"T"HH24":"MI":"SS') || ',' ||
      esc(r.username)    || ',' || esc(r.action)    || ',' ||
      esc(r.object_type) || ',' || esc(r.object_id) || ',' ||
      esc(r.status)      || ',' || esc(r.error_message));
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- -------------------------------------------------------------------------
    -- sessions/ GET -- active sessions within the inactivity window.
    -- session_id is the bearer token: NEVER returned whole. sidTail (last 6)
    -- lets the client highlight "this device".
    -- -------------------------------------------------------------------------
    def_template('sessions/');
    def_handler('sessions/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_mins NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN may view sessions'); RETURN;
  END IF;
  BEGIN
    SELECT TO_NUMBER(setting_value) INTO l_mins
    FROM dct_system_settings WHERE setting_key = 'SESSION_TIMEOUT_MINS';
  EXCEPTION WHEN OTHERS THEN l_mins := 480;
  END;
  l_mins := NVL(l_mins, 480);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('timeoutMins', l_mins);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT s.session_id, s.username, u.display_name, s.login_at,
           s.last_activity_at, s.ip_address, s.user_agent, s.auth_method
    FROM   dct_sessions s
    LEFT JOIN dct_users u ON u.user_id = s.user_id
    WHERE  s.is_active = 'Y'
      AND  s.logout_at IS NULL
      AND  s.last_activity_at > SYSTIMESTAMP - NUMTODSINTERVAL(l_mins, 'MINUTE')
    ORDER BY s.last_activity_at DESC
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('sidTail',      SUBSTR(r.session_id, -6));
    APEX_JSON.write('username',     r.username);
    APEX_JSON.write('displayName',  r.display_name);
    APEX_JSON.write('loginAt',      TO_CHAR(r.login_at,'YYYY-MM-DD"T"HH24":"MI":"SS'));
    APEX_JSON.write('lastActivity', TO_CHAR(r.last_activity_at,'YYYY-MM-DD"T"HH24":"MI":"SS'));
    APEX_JSON.write('ip',           r.ip_address);
    APEX_JSON.write('userAgent',    SUBSTR(r.user_agent, 1, 120));
    APEX_JSON.write('authMethod',   r.auth_method);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- -------------------------------------------------------------------------
    -- sessions/revoke POST {username} -- close ALL active sessions of a user
    -- (revoking by token would mean shipping live tokens to the client).
    -- -------------------------------------------------------------------------
    def_template('sessions/revoke');
    def_handler('sessions/revoke', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_target VARCHAR2(100);
  l_n      NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN may revoke sessions'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_target := UPPER(TRIM(APEX_JSON.get_varchar2(p_path => 'username')));
  IF l_target IS NULL THEN dct_rest.err(400,'username is required'); RETURN; END IF;
  UPDATE dct_sessions
  SET    is_active = 'N', logout_at = SYSTIMESTAMP
  WHERE  UPPER(username) = l_target
    AND  is_active = 'Y'
    AND  logout_at IS NULL;
  l_n := SQL%ROWCOUNT;
  INSERT INTO dct_audit_log (username, action, object_type, object_id, status)
  VALUES (l_user, 'SESSIONS_REVOKED', 'DCT_SESSIONS', l_target, 'SUCCESS');
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.write('revoked', l_n);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- -------------------------------------------------------------------------
    -- approval-templates/:id/restore POST -- archived version -> new draft of
    -- the current live template (steps copied from the archive). The draft
    -- then follows the normal edit/activate lifecycle.
    -- -------------------------------------------------------------------------
    def_template('approval-templates/[COLON]id/restore');
    def_handler('approval-templates/[COLON]id/restore', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_code VARCHAR2(100);
  l_base VARCHAR2(100);
  l_live NUMBER;
  l_cnt  NUMBER;
  l_new  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN may manage templates'); RETURN;
  END IF;
  SELECT template_code INTO l_code
  FROM dct_approval_templates WHERE template_id = [COLON]id;
  IF INSTR(l_code, CHR(126) || 'V') = 0 THEN
    dct_rest.err(409,'Only archived versions can be restored'); RETURN;
  END IF;
  l_base := SUBSTR(l_code, 1, INSTR(l_code, CHR(126)) - 1);
  BEGIN
    SELECT template_id INTO l_live
    FROM dct_approval_templates
    WHERE template_code = l_base AND is_active = 'Y';
  EXCEPTION WHEN NO_DATA_FOUND THEN
    dct_rest.err(409,'No live template found for ' || l_base); RETURN;
  END;
  SELECT COUNT(*) INTO l_cnt FROM dct_approval_templates
  WHERE template_code = l_base || CHR(126) || 'D';
  IF l_cnt > 0 THEN
    dct_rest.err(409,'A draft already exists for this template'); RETURN;
  END IF;
  INSERT INTO dct_approval_templates (
    template_code, template_name, template_name_ar, module_id, request_type,
    description_en, description_ar, is_sequential, auto_approve_days,
    is_active, parent_template_id, version_no, created_by)
  SELECT l_base || CHR(126) || 'D', template_name, template_name_ar,
         module_id, request_type, description_en, description_ar,
         is_sequential, auto_approve_days,
         'N', l_live, NVL(version_no, 1), l_user
  FROM dct_approval_templates WHERE template_id = [COLON]id;
  SELECT template_id INTO l_new FROM dct_approval_templates
  WHERE template_code = l_base || CHR(126) || 'D';
  INSERT INTO dct_approval_steps (
    template_id, step_seq, step_name, step_name_ar, step_type,
    required_role_id, specific_user_id, escalation_days, escalate_role_id,
    is_mandatory, allow_skip, condition_type, amount_operator,
    amount_threshold, type_filter, custom_condition, created_by)
  SELECT l_new, step_seq, step_name, step_name_ar, step_type,
         required_role_id, specific_user_id, escalation_days, escalate_role_id,
         is_mandatory, allow_skip, condition_type, amount_operator,
         amount_threshold, type_filter, custom_condition, l_user
  FROM dct_approval_steps WHERE template_id = [COLON]id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('templateId', l_new);
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION
  WHEN NO_DATA_FOUND THEN ROLLBACK; dct_rest.err(404,'Template not found');
  WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
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
PROMPT             audit/, stats/, prefs/, prefs/:key
PROMPT  Phase 3: users/ + audit/ paginated ({items,total,limit,offset};
PROMPT           ?limit=&offset=&search=&status=/&action=)
PROMPT ============================================================
