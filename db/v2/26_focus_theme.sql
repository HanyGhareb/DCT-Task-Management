-- =============================================================================
-- 26_focus_theme.sql  —  Configurable field-focus highlight (all apps)
--
-- Adds two APPEARANCE settings and widens the GET /dct/boot whitelist so every
-- app receives them at boot:
--
--   THEME_FOCUS_COLOR        hex color of the focused input field border + ring
--   FEATURE_FOCUS_HIGHLIGHT  Y/N — enable/disable the colored focus highlight
--   THEME_FOCUS_FILL_LEVEL   0-100 — fill intensity (% of the color; higher = darker)
--
-- Applied at boot by shared/js/shell.js (applyRegionTheme) as the CSS vars
--   --focus-color / --focus-ring  (platform.css). When the flag is N the focus
-- falls back to a plain neutral border (no colored ring); the keyboard
-- :focus-visible a11y outline is unaffected.
--
-- One global value (Admin-only) — no per-module override rows.
--
-- Rerunnable. Run as ADMIN in a fresh SQLcl session (touches ORDS metadata).
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

PROMPT === 1. Platform defaults in DCT_SYSTEM_SETTINGS (category APPEARANCE) ===

INSERT INTO prod.dct_system_settings (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
SELECT 'THEME_FOCUS_COLOR', '#F0883E', 'COLOR', 'APPEARANCE',
       'Highlight color for the focused input field (all apps). Border + soft ring.', 'Y', 'SYSTEM'
FROM dual WHERE NOT EXISTS
  (SELECT 1 FROM prod.dct_system_settings WHERE setting_key = 'THEME_FOCUS_COLOR');

INSERT INTO prod.dct_system_settings (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
SELECT 'FEATURE_FOCUS_HIGHLIGHT', 'Y', 'BOOLEAN', 'APPEARANCE',
       'Enable the colored highlight on focused input fields (all apps).', 'Y', 'SYSTEM'
FROM dual WHERE NOT EXISTS
  (SELECT 1 FROM prod.dct_system_settings WHERE setting_key = 'FEATURE_FOCUS_HIGHLIGHT');

INSERT INTO prod.dct_system_settings (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
SELECT 'THEME_FOCUS_FILL_LEVEL', '15', 'NUMBER', 'APPEARANCE',
       'Focus highlight fill intensity 0-100 (percent of the color; higher = darker fill).', 'Y', 'SYSTEM'
FROM dual WHERE NOT EXISTS
  (SELECT 1 FROM prod.dct_system_settings WHERE setting_key = 'THEME_FOCUS_FILL_LEVEL');

COMMIT;

PROMPT === 2. Widen GET /dct/boot whitelist with THEME_FOCUS_COLOR + THEME_FOCUS_FILL_LEVEL ===
-- FEATURE_FOCUS_HIGHLIGHT already ships via the existing FEATURE_ LIKE clause.

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
               OR  setting_key IN ('THEME_BRAND_COLOR','THEME_FOCUS_COLOR','THEME_FOCUS_FILL_LEVEL','SESSION_TIMEOUT_MINS','APP_THEME')) LOOP
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

PROMPT === 3. Verify ===

SELECT setting_key, setting_value, value_type, category
FROM   prod.dct_system_settings
WHERE  setting_key IN ('THEME_FOCUS_COLOR','FEATURE_FOCUS_HIGHLIGHT','THEME_FOCUS_FILL_LEVEL')
ORDER  BY setting_key;

PROMPT === 26_focus_theme.sql complete ===
