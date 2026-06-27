-- =============================================================================
-- Freelancers Module (App 203) -- Phase 1 -- Gemini -> Claude AI fallback toggle
-- File    : 22_fl_ai_fallback.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @22_fl_ai_fallback.sql  (any session)
-- Purpose : Seed setting AI_FALLBACK_CLAUDE (BOOLEAN, default Y). When the active
--           AI_PROVIDER is GEMINI and a request fails (free-tier 429 / throttle /
--           outage), DCT_FL_AI_PKG.call_ai transparently re-runs the SAME document
--           through Claude (ANTHROPIC) so extraction stays reliable. N disables the
--           fallback (Gemini failures surface to the user as before).
--           Visible in Admin > Freelancers > Module Settings (Document AI group).
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
    USING (SELECT v_module_id AS module_id, 'AI_FALLBACK_CLAUDE' AS setting_key FROM dual) src
    ON    (s.module_id = src.module_id AND s.setting_key = src.setting_key)
    WHEN NOT MATCHED THEN
        INSERT (module_id, setting_key, setting_value, setting_label,
                setting_description, value_type, allowed_values, default_value, effective_date)
        VALUES (v_module_id, 'AI_FALLBACK_CLAUDE', 'Y', 'AI Fallback to Claude',
                'When AI Provider = GEMINI and a read fails (e.g. free-tier rate limit / 429), automatically re-read the document with Claude so extraction still succeeds. Requires an active ANTHROPIC provider key.',
                'BOOLEAN', 'Y|N', 'Y', SYSDATE);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('AI_FALLBACK_CLAUDE seeded (default Y).');
END;
/

PROMPT === 22_fl_ai_fallback.sql complete ===
