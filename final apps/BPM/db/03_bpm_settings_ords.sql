SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON

PROMPT === 03_bpm_settings_ords.sql - ADDITIVE bpm/settings routes on dct.admin ===
PROMPT === Run as ADMIN (sql -name prod_mcp) in a FRESH session.                 ===
PROMPT === ADDITIVE: db/v2/11 re-runs DELETE_MODULE dct.admin - RE-RUN 03 AFTER ANY 11 RE-RUN ===

CREATE OR REPLACE PROCEDURE setup_bpm_settings_ords_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'dct.admin';

    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58))
        );
    END;

    PROCEDURE def_handler(
        p_pattern VARCHAR2,
        p_method  VARCHAR2,
        p_source  CLOB
    ) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => p_method,
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58))
        );
    END;

BEGIN

    def_template('bpm/settings');
    def_handler('bpm/settings', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT ms.setting_id, ms.setting_key, ms.setting_value, ms.setting_label,
           ms.setting_description, ms.value_type, ms.allowed_values, ms.default_value
    FROM   dct_module_settings ms
    JOIN   dct_modules m ON m.module_id = ms.module_id
    WHERE  m.module_code = 'BPM'
    ORDER BY ms.setting_key
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('settingId',    r.setting_id);
    APEX_JSON.write('key',          r.setting_key);
    APEX_JSON.write('value',        r.setting_value);
    APEX_JSON.write('label',        NVL(r.setting_label, r.setting_key));
    APEX_JSON.write('description',  NVL(r.setting_description, ''));
    APEX_JSON.write('type',         NVL(r.value_type, 'TEXT'));
    APEX_JSON.write('allowed',      NVL(r.allowed_values, ''));
    APEX_JSON.write('defaultValue', NVL(r.default_value, ''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('bpm/settings/[COLON]id');
    def_handler('bpm/settings/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_val  VARCHAR2(500);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'WF_ADMIN') AND NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only a workflow administrator can change BPM settings'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_val := APEX_JSON.get_varchar2(p_path => 'value');
  UPDATE dct_module_settings ms SET
    ms.setting_value = l_val,
    ms.updated_by    = l_user,
    ms.updated_at    = SYSTIMESTAMP
  WHERE ms.setting_id = [COLON]id
    AND ms.module_id  = (SELECT module_id FROM dct_modules WHERE module_code = 'BPM');
  IF SQL%ROWCOUNT = 0 THEN ROLLBACK; dct_rest.err(404,'Setting not found'); RETURN; END IF;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

END setup_bpm_settings_ords_tmp;
/

EXECUTE setup_bpm_settings_ords_tmp

DROP PROCEDURE setup_bpm_settings_ords_tmp;

PROMPT === Verify templates ===
SELECT uri_template
  FROM user_ords_templates
 WHERE module_id = (SELECT id FROM user_ords_modules WHERE name = 'dct.admin')
   AND uri_template LIKE 'bpm/%';

EXIT
