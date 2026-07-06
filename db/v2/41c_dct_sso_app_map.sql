-- =============================================================================
-- 41c_dct_sso_app_map.sql  --  JET-app to APEX-app SSO mapping
--
-- The JET->APEX hand-off now lands in the APEX app that CORRESPONDS to the
-- JET module the user clicked from (PC 201 -> APEX 201, DT 204 -> APEX 204...)
-- instead of always App 200. App numbering is shared platform-wide, so the
-- mapping is identity, gated by an allowlist:
--
--   APEX_SSO_URL   value becomes a template with a %APP% placeholder
--   APEX_SSO_APPS  CSV allowlist of APEX app ids whose login page has the
--                  SSO item + process wired (per Admin/docs/apex-sso-setup.md).
--                  Requested apps not on the list fall back to 200.
--
-- When a module's APEX app is built later: wire its login page (9999) exactly
-- like App 200's, then just append the app id to APEX_SSO_APPS - no code change.
--
-- ADDITIVE handler replace on the EXISTING sso/code template: DEFINE_HANDLER
-- only - never DEFINE_TEMPLATE on an existing template (it drops handlers).
-- Source mirrored into 11_dct_ords.sql. Run as ADMIN in a fresh SQLcl session.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

PROMPT === 1. Settings: URL template + allowlist ===

UPDATE prod.dct_system_settings
SET    setting_value = REPLACE(setting_value, 'f?p=200:', 'f?p=%APP%:')
WHERE  setting_key   = 'APEX_SSO_URL'
AND    setting_value LIKE '%f?p=200:%';

INSERT INTO prod.dct_system_settings (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
SELECT 'APEX_SSO_APPS', '200', 'STRING', 'SECURITY',
       'CSV allowlist of APEX app ids whose login page is SSO-wired (P9999_SSO_CODE + SSO_AUTO_LOGIN). JET apps map to their own app id when listed; otherwise fall back to 200.',
       'Y', 'SYSTEM'
FROM dual WHERE NOT EXISTS
  (SELECT 1 FROM prod.dct_system_settings WHERE setting_key = 'APEX_SSO_APPS');

COMMIT;

PROMPT === 2. Replace POST sso/code handler (app-aware) ===

CREATE OR REPLACE PROCEDURE setup_dct_sso_map_tmp AS
BEGIN
    ORDS.DEFINE_HANDLER(
        p_module_name => 'dct.admin',
        p_pattern     => 'sso/code',
        p_method      => 'POST',
        p_source_type => ORDS.source_type_plsql,
        p_source      => REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_code VARCHAR2(64);
  l_ttl  NUMBER;
  l_url  VARCHAR2(500);
  l_app  VARCHAR2(10);
  l_list VARCHAR2(400);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;

  -- optional target app (the calling JET module's app number)
  BEGIN
    dct_rest.parse_body([COLON]body);
    l_app := REGEXP_SUBSTR(APEX_JSON.get_varchar2(p_path => 'app'), '^\d{1,6}$');
  EXCEPTION WHEN OTHERS THEN l_app := NULL;
  END;

  -- only apps whose APEX login page is SSO-wired may be targeted
  BEGIN
    SELECT setting_value INTO l_list
    FROM   dct_system_settings WHERE setting_key = 'APEX_SSO_APPS';
  EXCEPTION WHEN NO_DATA_FOUND THEN l_list := '200';
  END;
  IF l_app IS NULL
     OR INSTR(',' || REPLACE(l_list, ' ', '') || ',', ',' || l_app || ',') = 0 THEN
    l_app := '200';
  END IF;

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
  l_url := REPLACE(l_url, '%APP%', l_app);

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
  APEX_JSON.write('targetApp',     l_app);
  APEX_JSON.close_object;
EXCEPTION
  WHEN OTHERS THEN
    IF    SQLCODE = -20403 THEN dct_rest.err(403, 'SSO hand-off is disabled');
    ELSIF SQLCODE = -20404 THEN dct_rest.err(404, 'User not found or inactive');
    ELSE  dct_rest.err(500, SQLERRM);
    END IF;
END;
!', '[COLON]', CHR(58)));
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('sso/code handler replaced (app-aware).');
END setup_dct_sso_map_tmp;
/

BEGIN
    setup_dct_sso_map_tmp;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP PROCEDURE setup_dct_sso_map_tmp';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

PROMPT === 3. Verify ===

SELECT setting_key, setting_value
FROM   prod.dct_system_settings
WHERE  setting_key IN ('APEX_SSO_URL', 'APEX_SSO_APPS')
ORDER  BY setting_key;

PROMPT === 41c_dct_sso_app_map.sql complete ===
