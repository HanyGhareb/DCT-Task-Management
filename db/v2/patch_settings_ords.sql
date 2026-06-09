-- =============================================================================
-- patch_settings_ords.sql
-- Fix ORDS settings handlers to use actual DCT_SYSTEM_SETTINGS column names.
-- Actual columns: SETTING_KEY, SETTING_VALUE, VALUE_TYPE, CATEGORY,
--                 DESCRIPTION_EN, IS_ENCRYPTED, IS_SYSTEM
-- Also inserts APP_THEME setting row.
-- Run as ADMIN: sql -name prod_mcp @patch_settings_ords.sql
-- =============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON

-- ── 1. Insert APP_THEME setting (idempotent) ──────────────────────────────────
MERGE INTO prod.dct_system_settings t
USING (SELECT 'APP_THEME' AS k FROM dual) s
ON (t.setting_key = s.k)
WHEN NOT MATCHED THEN
  INSERT (setting_key, setting_value, value_type, category, description_en,
          is_encrypted, is_system, created_by)
  VALUES ('APP_THEME', 'corporate', 'STRING', 'UI',
          'Platform UI theme for the Admin SPA: corporate | redwood | midnight',
          'N', 'N', 'ADMIN');

COMMIT;

-- ── 2. Patch ORDS settings handlers ──────────────────────────────────────────
CREATE OR REPLACE PROCEDURE patch_settings_ords_tmp AS

  c_mod  CONSTANT VARCHAR2(30) := 'dct.admin';

  PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
  BEGIN
    ORDS.DEFINE_HANDLER(
      p_module_name => c_mod,
      p_pattern     => REPLACE(p_pattern, '[C]', CHR(58)),
      p_method      => p_method,
      p_source_type => ORDS.source_type_plsql,
      p_source      => REPLACE(p_source,  '[C]', CHR(58))
    );
  END;

BEGIN

  -- GET /settings/
  def_handler('settings/', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401, 'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT setting_key, setting_value, value_type, category, description_en,
           CASE WHEN is_system = 'Y' THEN 'N' ELSE 'Y' END AS is_editable
    FROM   dct_system_settings
    ORDER  BY category, setting_key
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('key',         r.setting_key);
    APEX_JSON.write('value',       r.setting_value);
    APEX_JSON.write('type',        r.value_type);
    APEX_JSON.write('category',    r.category);
    APEX_JSON.write('description', r.description_en);
    APEX_JSON.write('isEditable',  r.is_editable);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

  -- PUT /settings/:key
  def_handler('settings/[C]key', 'PUT', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_sys  VARCHAR2(1);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401, 'Unauthorized'); RETURN; END IF;
  BEGIN
    SELECT is_system INTO l_sys
    FROM   dct_system_settings
    WHERE  setting_key = :key;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    dct_rest.err(404, 'Setting not found'); RETURN;
  END;
  IF l_sys = 'Y' THEN
    dct_rest.err(403, 'System setting is read-only'); RETURN;
  END IF;
  dct_rest.parse_body(:body);
  UPDATE dct_system_settings
  SET    setting_value = APEX_JSON.get_varchar2(p_path => 'value'),
         updated_by    = l_user,
         updated_at    = SYSTIMESTAMP
  WHERE  setting_key   = :key;
  IF SQL%ROWCOUNT = 0 THEN
    dct_rest.err(404, 'Setting not found'); RETURN;
  END IF;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Settings ORDS handlers patched successfully.');
END patch_settings_ords_tmp;
/

BEGIN patch_settings_ords_tmp; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP PROCEDURE patch_settings_ords_tmp'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

PROMPT patch_settings_ords.sql complete.
