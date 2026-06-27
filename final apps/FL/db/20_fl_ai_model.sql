-- =============================================================================
-- Freelancers Module (App 203) -- Phase 1 -- Selectable AI model
-- File    : 20_fl_ai_model.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @20_fl_ai_model.sql  (any session)
-- Purpose : Turn the existing AI_MODEL setting into a dropdown so an end user can
--           switch the extraction model from Admin > Freelancers > Module
--           Settings. DCT_FL_AI_PKG.get_model uses this value when it is
--           compatible with the active AI_PROVIDER (gemini* with GEMINI, claude*
--           with ANTHROPIC); otherwise it falls back to the provider's model.
--           Sets the current value to gemini-2.0-flash.
-- Idempotent (MERGE then normalise).
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON

DECLARE
    v_module_id dct_modules.module_id%TYPE;
    c_allowed CONSTANT VARCHAR2(300) :=
        'gemini-2.0-flash|gemini-2.5-flash|gemini-flash-latest|gemini-1.5-flash|claude-sonnet-4-6|claude-haiku-4-5-20251001';
BEGIN
    SELECT module_id INTO v_module_id FROM prod.dct_modules WHERE module_code = 'FREELANCERS';

    -- AI_MODEL already seeded by db/11 (value_type TEXT) -> create if missing.
    MERGE INTO prod.dct_module_settings s
    USING (SELECT v_module_id AS module_id, 'AI_MODEL' AS setting_key FROM dual) src
    ON    (s.module_id = src.module_id AND s.setting_key = src.setting_key)
    WHEN NOT MATCHED THEN
        INSERT (module_id, setting_key, setting_value, setting_label,
                setting_description, value_type, allowed_values, default_value, effective_date)
        VALUES (v_module_id, 'AI_MODEL', 'gemini-2.0-flash', 'AI Extraction Model',
                'Vision model used for document extraction. Pick a gemini-* model when AI Provider = GEMINI, or a claude-* model when AI Provider = ANTHROPIC; an incompatible choice falls back to the provider default.',
                'SELECT', c_allowed, 'gemini-2.0-flash', SYSDATE);

    -- Convert the existing row to a dropdown and select gemini-2.0-flash.
    UPDATE prod.dct_module_settings
       SET value_type     = 'SELECT',
           allowed_values = c_allowed,
           setting_value  = 'gemini-2.0-flash',
           default_value  = 'gemini-2.0-flash',
           setting_label  = 'AI Extraction Model',
           setting_description =
                'Vision model used for document extraction. Pick a gemini-* model when AI Provider = GEMINI, or a claude-* model when AI Provider = ANTHROPIC; an incompatible choice falls back to the provider default.'
     WHERE module_id = v_module_id AND setting_key = 'AI_MODEL';

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('AI_MODEL is now a dropdown, set to gemini-2.0-flash.');
END;
/

PROMPT === 20_fl_ai_model.sql complete ===
