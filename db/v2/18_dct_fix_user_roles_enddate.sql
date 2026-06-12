-- =============================================================================
-- 18_dct_fix_user_roles_enddate.sql
-- Fix: PUT /dct/users/:id role sync set end_date = TRUNC(SYSDATE) when
-- deactivating current roles. start_date defaults to SYSDATE (with time),
-- so any role assigned the same day violated chk_dct_ur_dates
-- (end_date >= start_date) -> ORA-02290, rolling back the whole PUT
-- (including org/profile field updates).
-- Redefines only the users/:id PUT handler with
-- end_date = GREATEST(SYSDATE, start_date).
--
-- Run as ADMIN in a fresh SQLcl session (module lives under ADMIN):
--   sql -name prod_mcp @db/v2/18_dct_fix_user_roles_enddate.sql
-- =============================================================================
SET DEFINE OFF

CREATE OR REPLACE PROCEDURE fix_dct_user_put_tmp AS
BEGIN
    ORDS.DEFINE_HANDLER(
        p_module_name => 'dct.admin',
        p_pattern     => REPLACE('users/[COLON]id', '[COLON]', CHR(58)),
        p_method      => 'PUT',
        p_source_type => ORDS.source_type_plsql,
        p_source      => REPLACE(q'!
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
!', '[COLON]', CHR(58))
    );
    COMMIT;
END;
/

EXEC fix_dct_user_put_tmp;
DROP PROCEDURE fix_dct_user_put_tmp;

PROMPT == users/:id PUT handler redefined (end_date = GREATEST(SYSDATE, start_date)) ==
