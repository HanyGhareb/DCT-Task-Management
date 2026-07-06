-- =============================================================================
-- 41b_dct_sso_ords.sql  --  ORDS endpoints for the cross-UI SSO hand-off
--
-- ADDITIVE patch to the existing dct.admin module (/ords/admin/dct/):
--   POST sso/code   (bearer-protected)  issue a JET2APEX one-time code
--                                       -> { code, expiresInSecs, apexUrl }
--   POST auth/sso   (public)            redeem an APEX2JET code
--                                       -> same payload as auth/login
--
-- Both templates are NEW: DEFINE_TEMPLATE here is safe. Never re-define an
-- existing template in a patch script (it silently drops its handlers).
-- Handler sources are mirrored in 11_dct_ords.sql (source of truth).
--
-- Prerequisite: 41_dct_sso.sql (dct_sso_pkg + settings + dct_auth body).
-- Run as ADMIN in a FRESH SQLcl session (creates an ADMIN synonym; must not
-- follow any CURRENT_SCHEMA switch).
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

PROMPT === 1. ADMIN synonym ===

CREATE OR REPLACE SYNONYM dct_sso_pkg FOR prod.dct_sso_pkg;

PROMPT === 2. ORDS templates + handlers (additive) ===

CREATE OR REPLACE PROCEDURE setup_dct_sso_ords_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'dct.admin';

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
    -- POST sso/code — issue a one-time JET-to-APEX hand-off code
    -- =========================================================================
    def_template('sso/code');
    def_handler('sso/code', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_code VARCHAR2(64);
  l_ttl  NUMBER;
  l_url  VARCHAR2(500);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_code := dct_sso_pkg.issue_code(
      p_username  => l_user,
      p_direction => 'JET2APEX',
      p_ip        => OWA_UTIL.get_cgi_env('REMOTE_ADDR'),
      p_agent     => OWA_UTIL.get_cgi_env('HTTP_USER_AGENT'));
  BEGIN
    SELECT setting_value INTO l_url
    FROM   dct_system_settings WHERE setting_key = 'APEX_SSO_URL';
  EXCEPTION WHEN NO_DATA_FOUND THEN l_url := NULL;
  END;
  BEGIN
    SELECT GREATEST(10, LEAST(600, TO_NUMBER(setting_value))) INTO l_ttl
    FROM   dct_system_settings WHERE setting_key = 'SSO_CODE_TTL_SECS';
  EXCEPTION WHEN OTHERS THEN l_ttl := 60;
  END;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('code',          l_code);
  APEX_JSON.write('expiresInSecs', l_ttl);
  APEX_JSON.write('apexUrl',       l_url);
  APEX_JSON.close_object;
EXCEPTION
  WHEN OTHERS THEN
    IF    SQLCODE = -20403 THEN dct_rest.err(403, 'SSO hand-off is disabled');
    ELSIF SQLCODE = -20404 THEN dct_rest.err(404, 'User not found or inactive');
    ELSE  dct_rest.err(500, SQLERRM);
    END IF;
END;
!');

    -- =========================================================================
    -- POST auth/sso — redeem an APEX-to-JET code for a bearer session.
    -- Public (like auth/login); the one-time code IS the credential.
    -- Response payload mirrors auth/login exactly.
    -- =========================================================================
    def_template('auth/sso');
    def_handler('auth/sso', 'POST', q'!
DECLARE
  l_code   VARCHAR2(200);
  l_uname  VARCHAR2(100);
  l_sid    VARCHAR2(100);
  l_user   dct_users%ROWTYPE;
  l_roles  VARCHAR2(4000);
  l_org_nm dct_organizations.org_name_en%TYPE;
BEGIN
  dct_rest.parse_body([COLON]body);
  l_code := APEX_JSON.get_varchar2(p_path => 'code');
  IF l_code IS NULL THEN
    dct_rest.err(400, 'code is required');
    RETURN;
  END IF;

  l_uname := dct_sso_pkg.redeem_code(l_code, 'APEX2JET');

  l_sid := RAWTOHEX(SYS_GUID());
  dct_auth.open_session(
    p_username    => l_uname,
    p_session_id  => l_sid,
    p_ip          => OWA_UTIL.get_cgi_env('REMOTE_ADDR'),
    p_agent       => OWA_UTIL.get_cgi_env('HTTP_USER_AGENT'),
    p_auth_method => 'SSO'
  );

  SELECT * INTO l_user FROM dct_users WHERE UPPER(username) = UPPER(l_uname) AND ROWNUM = 1;
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
EXCEPTION
  WHEN OTHERS THEN
    IF    SQLCODE = -20401 THEN dct_rest.err(401, 'Invalid or expired SSO code');
    ELSIF SQLCODE = -20403 THEN dct_rest.err(403, 'SSO hand-off is disabled');
    ELSE  dct_rest.err(500, SQLERRM);
    END IF;
END;
!');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('SSO endpoints published on dct.admin.');

END setup_dct_sso_ords_tmp;
/

-- Call the setup procedure (separate block so its locks are fully released before DROP)
BEGIN
    setup_dct_sso_ords_tmp;
END;
/

-- Drop the setup helper in a fresh block (avoids ORA-04020 deadlock)
BEGIN
    EXECUTE IMMEDIATE 'DROP PROCEDURE setup_dct_sso_ords_tmp';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

PROMPT === 3. Verify ===

SELECT uri_template, method
FROM   user_ords_handlers h
JOIN   user_ords_templates t ON t.id = h.template_id
WHERE  t.uri_template IN ('sso/code', 'auth/sso')
ORDER  BY uri_template;

PROMPT ============================================================
PROMPT  41b_dct_sso_ords.sql complete.
PROMPT  New endpoints: POST /dct/sso/code (bearer), POST /dct/auth/sso (public)
PROMPT ============================================================
