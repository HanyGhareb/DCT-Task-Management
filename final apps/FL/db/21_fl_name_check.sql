-- =============================================================================
-- Freelancers Module (App 203) -- Phase 1 -- Cross-document name-match toggle
-- File    : 21_fl_name_check.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @21_fl_name_check.sql  (any session)
-- Purpose : Setting AI_NAME_MATCH_CHECK (Y/N, default Y). When Y, AI extraction
--           warns if the name on one uploaded document does not match another
--           (possible different people). When N, the check is skipped entirely
--           (no nameMismatch flag / warning). Toggle in Admin > Freelancers >
--           Module Settings.
-- Idempotent (MERGE).
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON

DECLARE
    v_module_id dct_modules.module_id%TYPE;
BEGIN
    SELECT module_id INTO v_module_id FROM prod.dct_modules WHERE module_code = 'FREELANCERS';

    MERGE INTO prod.dct_module_settings s
    USING (SELECT v_module_id AS module_id, 'AI_NAME_MATCH_CHECK' AS setting_key FROM dual) src
    ON    (s.module_id = src.module_id AND s.setting_key = src.setting_key)
    WHEN NOT MATCHED THEN
        INSERT (module_id, setting_key, setting_value, setting_label,
                setting_description, value_type, allowed_values, default_value, effective_date)
        VALUES (v_module_id, 'AI_NAME_MATCH_CHECK', 'Y',
                'Cross-document name match check',
                'Y = warn when the name on one uploaded document does not match another uploaded document (possible different people). N = skip the check.',
                'BOOLEAN', 'Y|N', 'Y', SYSDATE);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('AI_NAME_MATCH_CHECK ensured (default Y).');
END;
/

PROMPT === 21_fl_name_check.sql complete ===
