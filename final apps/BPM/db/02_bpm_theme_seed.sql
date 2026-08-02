SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON

PROMPT === 02_bpm_theme_seed.sql - THEME_SKIN module setting for Fusion BPM ===
PROMPT === Rerunnable count-then-act. Values NIGHT / REDWOOD / DIWAN, default NIGHT ===

DECLARE
    l_module_id NUMBER;
    l_cnt       NUMBER;
BEGIN
    SELECT module_id INTO l_module_id
      FROM prod.dct_modules
     WHERE module_code = 'BPM';

    SELECT COUNT(*) INTO l_cnt
      FROM prod.dct_module_settings
     WHERE module_id = l_module_id
       AND setting_key = 'THEME_SKIN';

    IF l_cnt = 0 THEN
        INSERT INTO prod.dct_module_settings
            (module_id, setting_key, setting_value, setting_label,
             setting_description, value_type, allowed_values, default_value)
        VALUES
            (l_module_id, 'THEME_SKIN', 'NIGHT',
             'App theme',
             'Fusion BPM look and feel, applied to every BPM user. NIGHT = dark console (default), REDWOOD = Oracle Fusion Redwood, DIWAN = executive burgundy and gold. Managed from BPM - Appearance.',
             'SELECT', 'NIGHT|REDWOOD|DIWAN', 'NIGHT');
        DBMS_OUTPUT.put_line('THEME_SKIN row created for module_id ' || l_module_id);
    ELSE
        DBMS_OUTPUT.put_line('THEME_SKIN row already present - value preserved');
    END IF;

    COMMIT;
END;
/

PROMPT === Verify ===
SELECT ms.setting_id, ms.setting_key, ms.setting_value, ms.allowed_values
  FROM prod.dct_module_settings ms
  JOIN prod.dct_modules m ON m.module_id = ms.module_id
 WHERE m.module_code = 'BPM'
 ORDER BY ms.setting_key;

EXIT
