-- 19_dct_delegation_announcement_seed.sql
-- Phase 4 platform seed: THEME_BRAND_COLOR for the FL and CC module apps.
-- Usage: sql -name prod_mcp @19_dct_delegation_announcement_seed.sql

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
    PROCEDURE seed_brand (p_module_code VARCHAR2, p_hex VARCHAR2) IS
        v_module_id NUMBER;
    BEGIN
        SELECT module_id INTO v_module_id
        FROM   prod.dct_modules WHERE module_code = p_module_code;

        MERGE INTO prod.dct_module_settings t
        USING (SELECT v_module_id AS module_id, 'THEME_BRAND_COLOR' AS setting_key FROM dual) s
        ON (t.module_id = s.module_id AND t.setting_key = s.setting_key)
        WHEN NOT MATCHED THEN
            INSERT (module_id, setting_key, setting_value, setting_label,
                    setting_description, value_type, default_value, updated_by)
            VALUES (v_module_id, 'THEME_BRAND_COLOR', p_hex, 'Brand Color',
                    'Hex color applied to the app chrome at boot (shared shell).',
                    'TEXT', p_hex, 'PHASE4')
        WHEN MATCHED THEN
            UPDATE SET t.setting_value = p_hex, t.updated_by = 'PHASE4',
                       t.updated_at = SYSTIMESTAMP;
        DBMS_OUTPUT.PUT_LINE(p_module_code || ' THEME_BRAND_COLOR = ' || p_hex);
    END;
BEGIN
    seed_brand('FREELANCERS',  '#7C4DBE');
    seed_brand('CREDIT_CARDS', '#B0721E');
    COMMIT;
END;
/

PROMPT seed 19 complete
