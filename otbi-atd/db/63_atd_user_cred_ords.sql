-- =============================================================================
-- ATD Loader (App 208) -- ORDS for per-user OTBI credential profiles (additive)
-- File    : 63_atd_user_cred_ords.sql
-- Base URL: /ords/admin/atd/   (adds to the EXISTING 'atd.rest' module)
-- Run     : sql -name prod_mcp @63_atd_user_cred_ords.sql   (FRESH session -
--           synonym rule: must NOT follow ALTER SESSION SET CURRENT_SCHEMA=PROD)
-- Depends : db/62 (ATD_USER_CREDENTIAL + ATD_CRED_PKG + synonyms)
-- =============================================================================
-- Routes (all SYS_ADMIN, and each operates ONLY on the caller's own row --
-- the username is always l_user, never taken from the payload):
--   GET    my-credential   -> {exists, fusionLogin, tgChatId, isActive,
--                              passwordSet, updatedBy, updatedAt}
--                             The password is NEVER returned, in any form.
--   PUT    my-credential   -> upsert; "password" applied ONLY when the JSON key
--                             is present AND non-empty (write-only secret;
--                             absent/empty = leave stored password unchanged)
--   DELETE my-credential   -> remove the caller's profile
--   GET    credentials     -> admin roster (no secrets, no chat ids)
-- WARNING: 13_atd_ords.sql rebuilds atd.rest from scratch -- after ANY re-run of
-- 13 you must re-run 20, 26, 31, 32, 33, 38, 39, 41, 42, 44, 45, 46, 49, 54, 55
-- AND this 63.
-- [COLON] -> ':' at define time (SQLcl bind-scan guard).
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

CREATE OR REPLACE PROCEDURE setup_atd_user_cred_tmp AS
    c_mod CONSTANT VARCHAR2(30) := 'atd.rest';

    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;

    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => p_method,
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN

    def_template('my-credential');

    -- ------------------------------------------------------------------
    -- GET /atd/my-credential
    -- ------------------------------------------------------------------
    def_handler('my-credential', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  r      atd_user_credential%ROWTYPE;
  l_found BOOLEAN := TRUE;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  BEGIN
    SELECT * INTO r FROM atd_user_credential WHERE username = l_user;
  EXCEPTION WHEN NO_DATA_FOUND THEN l_found := FALSE;
  END;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('exists', l_found);
  IF l_found THEN
    APEX_JSON.write('fusionLogin', r.fusion_login);
    APEX_JSON.write('catalogLogin', NVL(r.catalog_login,''));
    APEX_JSON.write('tgChatId',    NVL(r.tg_chat_id,''));
    APEX_JSON.write('isActive',    r.is_active);
    APEX_JSON.write('passwordSet', atd_cred_pkg.password_set(l_user));
    APEX_JSON.write('updatedBy',   NVL(r.updated_by,''));
    APEX_JSON.write('updatedAt',   TO_CHAR(dct_to_local(r.updated_at),'YYYY-MM-DD HH:MI AM'));
  END IF;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- ------------------------------------------------------------------
    -- PUT /atd/my-credential
    -- body: {fusionLogin, tgChatId?, isActive?, password?}
    -- "password" only applied when present AND non-empty (write-only secret).
    -- ------------------------------------------------------------------
    def_handler('my-credential', 'PUT', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_login  VARCHAR2(200);
  l_cat    VARCHAR2(200);
  l_chat   VARCHAR2(60);
  l_active VARCHAR2(5);
  l_pwd    VARCHAR2(200);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_login  := TRIM(APEX_JSON.get_varchar2(p_path=>'fusionLogin'));
  l_cat    := TRIM(APEX_JSON.get_varchar2(p_path=>'catalogLogin'));
  l_chat   := TRIM(APEX_JSON.get_varchar2(p_path=>'tgChatId'));
  l_active := UPPER(NVL(TRIM(APEX_JSON.get_varchar2(p_path=>'isActive')),'Y'));
  IF l_login IS NULL THEN
    dct_rest.err(400,'fusionLogin is required'); RETURN;
  END IF;
  IF l_active NOT IN ('Y','N') THEN
    dct_rest.err(400,'isActive must be Y or N'); RETURN;
  END IF;
  IF l_chat IS NOT NULL AND NOT REGEXP_LIKE(l_chat, '^-?[0-9]{1,20}$') THEN
    dct_rest.err(400,'tgChatId must be a numeric Telegram chat id'); RETURN;
  END IF;

  UPDATE atd_user_credential
     SET fusion_login  = l_login,
         catalog_login = l_cat,
         tg_chat_id    = l_chat,
         is_active     = l_active,
         updated_by    = l_user,
         updated_at    = SYSTIMESTAMP
   WHERE username = l_user;
  IF SQL%ROWCOUNT = 0 THEN
    INSERT INTO atd_user_credential
      (username, fusion_login, catalog_login, tg_chat_id, is_active, updated_by)
    VALUES (l_user, l_login, l_cat, l_chat, l_active, l_user);
  END IF;

  -- write-only secret: only touch the stored password when the key is present
  -- and non-empty (the UI sends it only when the operator typed a new one)
  IF APEX_JSON.does_exist(p_path=>'password') THEN
    l_pwd := APEX_JSON.get_varchar2(p_path=>'password');
    IF l_pwd IS NOT NULL AND TRIM(l_pwd) IS NOT NULL THEN
      atd_cred_pkg.set_password(l_user, l_pwd);
    END IF;
  END IF;
  COMMIT;

  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.write('passwordSet', atd_cred_pkg.password_set(l_user));
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- ------------------------------------------------------------------
    -- DELETE /atd/my-credential
    -- ------------------------------------------------------------------
    def_handler('my-credential', 'DELETE', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n    NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  DELETE FROM atd_user_credential WHERE username = l_user;
  l_n := SQL%ROWCOUNT; COMMIT;
  IF l_n = 0 THEN dct_rest.err(404,'No credential profile'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- ------------------------------------------------------------------
    -- GET /atd/credentials  -- admin roster: who has a personal OTBI account
    -- (flags only -- no password material, no chat ids)
    -- ------------------------------------------------------------------
    def_template('credentials');
    def_handler('credentials', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT username, fusion_login, catalog_login, is_active,
           CASE WHEN fusion_pwd_enc IS NOT NULL THEN 'Y' ELSE 'N' END pwd_set,
           CASE WHEN tg_chat_id IS NOT NULL THEN 'Y' ELSE 'N' END chat_set,
           updated_at
      FROM atd_user_credential
     ORDER BY username
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('username',    r.username);
    APEX_JSON.write('fusionLogin', r.fusion_login);
    APEX_JSON.write('catalogLogin', NVL(r.catalog_login,''));
    APEX_JSON.write('isActive',    r.is_active);
    APEX_JSON.write('passwordSet', r.pwd_set);
    APEX_JSON.write('tgChatSet',   r.chat_set);
    APEX_JSON.write('updatedAt',   TO_CHAR(dct_to_local(r.updated_at),'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

END setup_atd_user_cred_tmp;
/

BEGIN
  setup_atd_user_cred_tmp;
  COMMIT;
END;
/
DROP PROCEDURE setup_atd_user_cred_tmp;

PROMPT otbi-atd 63 per-user OTBI credential ORDS : done
