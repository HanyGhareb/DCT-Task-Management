-- =============================================================================
-- SUPERSEDED 2026-06-13 by 07_ar_ai_providers.sql — provider/model/key rows
-- now live in DCT_AR_AI_PROVIDERS. Do not re-run this patch after 07.
-- =============================================================================
-- AR Module patch — Gemini AI provider settings (2026-06-12)
-- Adds AI_PROVIDER / GEMINI_API_KEY / GEMINI_MODEL module settings and
-- relabels AI_MODEL as the Anthropic-specific model setting.
-- (02_ar_seed.sql carries the same rows for fresh installs.)
-- Run via SQLcl: sql -name prod_mcp   then  @06_ar_patch_gemini.sql
-- Then redeploy 03_ar_ai_pkg.sql and 05_ar_ords.sql (fresh session for 05).
-- =============================================================================
SET DEFINE OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

DECLARE
    v_module_id prod.dct_modules.module_id%TYPE;

    TYPE t_setting IS RECORD (
        s_key   VARCHAR2(100), s_val   VARCHAR2(1000),
        s_label VARCHAR2(200), s_desc  VARCHAR2(1000),
        s_type  VARCHAR2(20),  s_allow VARCHAR2(500),
        s_def   VARCHAR2(1000)
    );
    TYPE t_setting_list IS TABLE OF t_setting;

    v_settings t_setting_list := t_setting_list(
        t_setting('AI_PROVIDER', 'ANTHROPIC',
            'AI Provider',
            'ANTHROPIC = Claude (paid, highest accuracy). GEMINI = Google Gemini (free tier available via Google AI Studio - approx 10-15 requests/min, 1,500/day). Each provider needs its own API key setting.',
            'SELECT', 'ANTHROPIC|GEMINI', 'ANTHROPIC'),
        t_setting('GEMINI_API_KEY', NULL,
            'Google Gemini API Key',
            'Free API key from Google AI Studio (aistudio.google.com/apikey) - only an API key is required, no credit card or username. Used when AI Provider = GEMINI. Never stored in source control.',
            'TEXT', NULL, NULL),
        t_setting('GEMINI_MODEL', 'gemini-flash-latest',
            'Gemini Model',
            'Gemini model used when AI Provider = GEMINI. gemini-flash-latest always points to the newest free-tier Flash model; a pinned ID (e.g. gemini-2.5-flash) may also be used.',
            'TEXT', NULL, 'gemini-flash-latest')
    );
BEGIN
    SELECT module_id INTO v_module_id
    FROM   prod.dct_modules WHERE module_code = 'ACCOUNTS_RECEIVABLE';

    FOR i IN 1 .. v_settings.COUNT LOOP
        MERGE INTO prod.dct_module_settings s
        USING (SELECT v_module_id         AS module_id,
                      v_settings(i).s_key AS setting_key FROM dual) src
        ON    (s.module_id = src.module_id AND s.setting_key = src.setting_key)
        WHEN NOT MATCHED THEN
            INSERT (module_id, setting_key, setting_value, setting_label,
                    setting_description, value_type, allowed_values, default_value,
                    effective_date)
            VALUES (v_module_id, v_settings(i).s_key, v_settings(i).s_val,
                    v_settings(i).s_label, v_settings(i).s_desc,
                    v_settings(i).s_type,  v_settings(i).s_allow, v_settings(i).s_def,
                    SYSDATE);
    END LOOP;

    UPDATE prod.dct_module_settings
    SET    setting_label       = 'Anthropic Model',
           setting_description = 'Claude model used when AI Provider = ANTHROPIC. Switch to a Sonnet model for higher accuracy at higher cost.'
    WHERE  module_id  = v_module_id
    AND    setting_key = 'AI_MODEL';

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('AR Gemini settings patch applied.');
END;
/

SELECT setting_key, setting_value, value_type, allowed_values
FROM   prod.dct_module_settings
WHERE  module_id = (SELECT module_id FROM prod.dct_modules
                    WHERE module_code = 'ACCOUNTS_RECEIVABLE')
AND    setting_key IN ('AI_PROVIDER','GEMINI_API_KEY','GEMINI_MODEL','AI_MODEL')
ORDER  BY setting_key;

PROMPT === AR Gemini patch complete ===
