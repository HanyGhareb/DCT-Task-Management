-- =============================================================================
-- Freelancers Module (App 203) -- Phase 1 -- Configurable AI provider
-- File    : 19_fl_ai_provider.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @19_fl_ai_provider.sql  (any session)
-- Purpose : Adds the AI_PROVIDER setting so document extraction can switch
--           between the paid Anthropic (Claude) and the free Google Gemini
--           provider WITHOUT a code change. The active provider's format / model
--           / key are read from the shared dct_ar_ai_providers registry by
--           DCT_FL_AI_PKG. Toggle in Admin > Freelancers > Module Settings.
--           Sets the current value to GEMINI for this round.
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
    USING (SELECT v_module_id AS module_id, 'AI_PROVIDER' AS setting_key FROM dual) src
    ON    (s.module_id = src.module_id AND s.setting_key = src.setting_key)
    WHEN NOT MATCHED THEN
        INSERT (module_id, setting_key, setting_value, setting_label,
                setting_description, value_type, allowed_values, default_value, effective_date)
        VALUES (v_module_id, 'AI_PROVIDER', 'ANTHROPIC',
                'AI Provider for Document Extraction',
                'Which AI vision provider reads uploaded documents. ANTHROPIC = Claude (paid); GEMINI = Google Gemini (free tier). The active provider''s model and API key come from the shared AI Providers registry (Admin > AR > Manage Providers).',
                'SELECT', 'ANTHROPIC|GEMINI', 'ANTHROPIC', SYSDATE);

    -- Use the free Gemini provider for the current round.
    UPDATE prod.dct_module_settings
       SET setting_value = 'GEMINI'
     WHERE module_id = v_module_id AND setting_key = 'AI_PROVIDER';

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('AI_PROVIDER set to GEMINI.');
END;
/

PROMPT === 19_fl_ai_provider.sql complete ===
