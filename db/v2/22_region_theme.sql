-- =============================================================================
-- 22_region_theme.sql  —  Configurable region header colors + region borders
--
-- Adds five THEME_REGION_* settings (platform default in DCT_SYSTEM_SETTINGS,
-- per-module override rows in DCT_MODULE_SETTINGS) and widens the GET /dct/boot
-- whitelist so every app receives the platform defaults at boot.
--
--   THEME_REGION_HEADER_BG     hex fill of region/modal/table headers
--   THEME_REGION_HEADER_FG     hex font color on the header fill
--   THEME_REGION_BORDER_COLOR  hex, or MATCH_HEADER to follow the header fill
--   THEME_REGION_BORDER_WIDTH  1px | 1.5px | 2px | 3px | 0
--   THEME_REGION_BORDER_STYLE  solid | dashed | dotted | double
--
-- Resolution at boot (shared/js/shell.js): module override, then system
-- default, then the CSS fallback baked into shared/css/platform.css.
--
-- Rerunnable. Run as ADMIN in a fresh SQLcl session (touches ORDS metadata).
-- =============================================================================
SET DEFINE OFF

PROMPT === 1. Widen system-settings value types (COLOR + SELECT) ===

ALTER TABLE prod.dct_system_settings DROP CONSTRAINT chk_dct_set_type;
ALTER TABLE prod.dct_system_settings ADD CONSTRAINT chk_dct_set_type
    CHECK (value_type IN ('STRING','NUMBER','BOOLEAN','JSON','DATE','COLOR','SELECT'));

PROMPT === 2. Platform defaults in DCT_SYSTEM_SETTINGS (category APPEARANCE) ===

INSERT INTO prod.dct_system_settings (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
SELECT 'THEME_REGION_HEADER_BG', '#334155', 'COLOR', 'APPEARANCE',
       'Region header fill color (all apps). Module override: same key in module settings.', 'Y', 'SYSTEM'
FROM dual WHERE NOT EXISTS
  (SELECT 1 FROM prod.dct_system_settings WHERE setting_key = 'THEME_REGION_HEADER_BG');

INSERT INTO prod.dct_system_settings (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
SELECT 'THEME_REGION_HEADER_FG', '#FFFFFF', 'COLOR', 'APPEARANCE',
       'Region header font color (all apps). Keep AA contrast (4.5:1) against the fill.', 'Y', 'SYSTEM'
FROM dual WHERE NOT EXISTS
  (SELECT 1 FROM prod.dct_system_settings WHERE setting_key = 'THEME_REGION_HEADER_FG');

INSERT INTO prod.dct_system_settings (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
SELECT 'THEME_REGION_BORDER_COLOR', 'MATCH_HEADER', 'STRING', 'APPEARANCE',
       'Region border color: hex value, or MATCH_HEADER to follow the header fill.', 'Y', 'SYSTEM'
FROM dual WHERE NOT EXISTS
  (SELECT 1 FROM prod.dct_system_settings WHERE setting_key = 'THEME_REGION_BORDER_COLOR');

INSERT INTO prod.dct_system_settings (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
SELECT 'THEME_REGION_BORDER_WIDTH', '1.5px', 'STRING', 'APPEARANCE',
       'Region border thickness: 1px, 1.5px, 2px, 3px or 0 (no border).', 'Y', 'SYSTEM'
FROM dual WHERE NOT EXISTS
  (SELECT 1 FROM prod.dct_system_settings WHERE setting_key = 'THEME_REGION_BORDER_WIDTH');

INSERT INTO prod.dct_system_settings (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
SELECT 'THEME_REGION_BORDER_STYLE', 'solid', 'STRING', 'APPEARANCE',
       'Region border line style: solid, dashed, dotted or double.', 'Y', 'SYSTEM'
FROM dual WHERE NOT EXISTS
  (SELECT 1 FROM prod.dct_system_settings WHERE setting_key = 'THEME_REGION_BORDER_STYLE');

PROMPT === 3. Per-module override rows in DCT_MODULE_SETTINGS (value NULL = inherit) ===

INSERT INTO prod.dct_module_settings (module_id, setting_key, setting_value, setting_label, setting_description, value_type, allowed_values, default_value)
SELECT m.module_id, 'THEME_REGION_HEADER_BG', NULL,
       'Region header fill', 'Hex fill color for region headers in this module. Empty = platform default.',
       'TEXT', NULL, NULL
FROM prod.dct_modules m
WHERE NOT EXISTS (SELECT 1 FROM prod.dct_module_settings s
                  WHERE s.module_id = m.module_id AND s.setting_key = 'THEME_REGION_HEADER_BG');

INSERT INTO prod.dct_module_settings (module_id, setting_key, setting_value, setting_label, setting_description, value_type, allowed_values, default_value)
SELECT m.module_id, 'THEME_REGION_HEADER_FG', NULL,
       'Region header font', 'Hex font color on the region header fill. Empty = platform default.',
       'TEXT', NULL, NULL
FROM prod.dct_modules m
WHERE NOT EXISTS (SELECT 1 FROM prod.dct_module_settings s
                  WHERE s.module_id = m.module_id AND s.setting_key = 'THEME_REGION_HEADER_FG');

INSERT INTO prod.dct_module_settings (module_id, setting_key, setting_value, setting_label, setting_description, value_type, allowed_values, default_value)
SELECT m.module_id, 'THEME_REGION_BORDER_COLOR', NULL,
       'Region border color', 'Hex color, or MATCH_HEADER to follow the header fill. Empty = platform default.',
       'TEXT', NULL, NULL
FROM prod.dct_modules m
WHERE NOT EXISTS (SELECT 1 FROM prod.dct_module_settings s
                  WHERE s.module_id = m.module_id AND s.setting_key = 'THEME_REGION_BORDER_COLOR');

INSERT INTO prod.dct_module_settings (module_id, setting_key, setting_value, setting_label, setting_description, value_type, allowed_values, default_value)
SELECT m.module_id, 'THEME_REGION_BORDER_WIDTH', NULL,
       'Region border thickness', 'Region border thickness. Empty = platform default.',
       'SELECT', '1px|1.5px|2px|3px|0', NULL
FROM prod.dct_modules m
WHERE NOT EXISTS (SELECT 1 FROM prod.dct_module_settings s
                  WHERE s.module_id = m.module_id AND s.setting_key = 'THEME_REGION_BORDER_WIDTH');

INSERT INTO prod.dct_module_settings (module_id, setting_key, setting_value, setting_label, setting_description, value_type, allowed_values, default_value)
SELECT m.module_id, 'THEME_REGION_BORDER_STYLE', NULL,
       'Region border style', 'Region border line style. Empty = platform default.',
       'SELECT', 'solid|dashed|dotted|double', NULL
FROM prod.dct_modules m
WHERE NOT EXISTS (SELECT 1 FROM prod.dct_module_settings s
                  WHERE s.module_id = m.module_id AND s.setting_key = 'THEME_REGION_BORDER_STYLE');

COMMIT;

PROMPT === 4. Widen GET /dct/boot whitelist with THEME_REGION_ keys ===

BEGIN
    ORDS.DEFINE_HANDLER(
        p_module_name => 'dct.admin',
        p_pattern     => 'boot',
        p_method      => 'GET',
        p_source_type => ORDS.source_type_plsql,
        p_source      => q'!
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
               OR  setting_key LIKE 'THEME\_REGION\_%' ESCAPE '\'
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
    COMMIT;
END;
/

PROMPT === 5. Verify ===

SELECT setting_key, setting_value, value_type
FROM   prod.dct_system_settings
WHERE  setting_key LIKE 'THEME_REGION%'
ORDER  BY setting_key;

SELECT m.module_code, COUNT(*) AS region_rows
FROM   prod.dct_module_settings s
JOIN   prod.dct_modules m ON m.module_id = s.module_id
WHERE  s.setting_key LIKE 'THEME_REGION%'
GROUP  BY m.module_code
ORDER  BY m.module_code;

PROMPT === 22_region_theme.sql complete ===
