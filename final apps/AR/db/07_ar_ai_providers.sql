-- =============================================================================
-- Accounts Receivable Module (App 206) -- AI Provider Registry
-- File    : 07_ar_ai_providers.sql
-- Schema  : PROD
-- Run     : after 02_ar_seed.sql (+ 06_ar_patch_gemini.sql where applied)
-- Purpose : Module Settings redesign. AI provider/model/key move out of the
--           flat DCT_MODULE_SETTINGS keys into DCT_AR_AI_PROVIDERS, which the
--           Module Settings page manages via the "Manage Providers" popup.
--           Steps:
--             1. registry DCT_AR_AI_PROVIDERS + audit trigger
--             2. lookup AR_API_FORMAT (supported wire protocols)
--             3. data move: ANTHROPIC / GEMINI rows seeded from the current
--                AI_MODEL / ANTHROPIC_API_KEY / GEMINI_MODEL / GEMINI_API_KEY
--                values, then those four key rows are removed
--                (AI_PROVIDER stays -- its value = selected provider_code)
--             4. value-type switchovers so the page renders pick-lists:
--                MIN_CONFIDENCE_AUTOCONFIRM, MAX_FILE_SIZE_MB,
--                DEFAULT_CURRENCY, THEME_BRAND_COLOR
--           Idempotent -- safe to re-run (existing provider rows are kept).
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- 1. DCT_AR_AI_PROVIDERS
--    api_format = wire protocol the AI package speaks (lookup AR_API_FORMAT;
--    lookup-first rule -- no CHECK constraint). base_url NULL = package
--    default endpoint for that format. api_key is write-only through ORDS.
-- =============================================================================
CREATE TABLE IF NOT EXISTS dct_ar_ai_providers (
    provider_id     NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    provider_code   VARCHAR2(30)    NOT NULL,
    provider_name   VARCHAR2(100)   NOT NULL,
    api_format      VARCHAR2(20)    NOT NULL,
    base_url        VARCHAR2(300),
    model_id        VARCHAR2(100)   NOT NULL,
    api_key         VARCHAR2(200),
    is_active       VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    created_by      VARCHAR2(100),
    created_at      TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by      VARCHAR2(100),
    updated_at      TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_arai_code    UNIQUE (provider_code),
    CONSTRAINT chk_dct_arai_active CHECK  (is_active IN ('Y','N'))
);

CREATE OR REPLACE TRIGGER trg_dct_arai_upd
    BEFORE UPDATE ON dct_ar_ai_providers FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/

-- =============================================================================
-- 2. Lookup AR_API_FORMAT
-- =============================================================================
DECLARE
    v_cat NUMBER;
BEGIN
    MERGE INTO dct_lookup_categories t
    USING (SELECT 'AR_API_FORMAT' AS category_code FROM dual) s
    ON (t.category_code = s.category_code)
    WHEN NOT MATCHED THEN
        INSERT (category_code, category_name_en, category_name_ar, module_id, is_system, is_active)
        VALUES ('AR_API_FORMAT', 'AR AI Provider API Format', 'صيغة واجهة مزود الذكاء الاصطناعي', NULL, 'Y', 'Y');
    SELECT category_id INTO v_cat FROM dct_lookup_categories WHERE category_code = 'AR_API_FORMAT';

    MERGE INTO dct_lookup_values t
    USING (SELECT v_cat AS category_id, 'ANTHROPIC' AS value_code FROM dual) s
    ON (t.category_id = s.category_id AND t.value_code = s.value_code)
    WHEN NOT MATCHED THEN
        INSERT (category_id, value_code, value_name_en, value_name_ar, display_order, is_default, is_active)
        VALUES (v_cat, 'ANTHROPIC', 'Anthropic Messages API', 'واجهة أنثروبيك', 10, 'Y', 'Y');

    MERGE INTO dct_lookup_values t
    USING (SELECT v_cat AS category_id, 'GEMINI' AS value_code FROM dual) s
    ON (t.category_id = s.category_id AND t.value_code = s.value_code)
    WHEN NOT MATCHED THEN
        INSERT (category_id, value_code, value_name_en, value_name_ar, display_order, is_default, is_active)
        VALUES (v_cat, 'GEMINI', 'Google Gemini generateContent API', 'واجهة جوجل جيميني', 20, 'N', 'Y');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Lookup seeded: AR_API_FORMAT (ANTHROPIC, GEMINI)');
END;
/

-- =============================================================================
-- 3. Data move: provider rows from existing settings, then remove the four
--    per-provider setting keys. AI_PROVIDER is kept as the selector.
-- =============================================================================
DECLARE
    v_module_id   dct_modules.module_id%TYPE;
    v_n           NUMBER;
    v_model       VARCHAR2(1000);
    v_key         VARCHAR2(1000);

    FUNCTION setting_val (p_key VARCHAR2) RETURN VARCHAR2 IS
        v VARCHAR2(1000);
    BEGIN
        SELECT setting_value INTO v
        FROM   dct_module_settings
        WHERE  module_id = v_module_id AND setting_key = p_key;
        RETURN v;
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
    END;
BEGIN
    SELECT module_id INTO v_module_id
    FROM   dct_modules WHERE module_code = 'ACCOUNTS_RECEIVABLE';

    SELECT COUNT(*) INTO v_n FROM dct_ar_ai_providers WHERE provider_code = 'ANTHROPIC';
    IF v_n = 0 THEN
        v_model := NVL(setting_val('AI_MODEL'), 'claude-haiku-4-5-20251001');
        v_key   := setting_val('ANTHROPIC_API_KEY');
        INSERT INTO dct_ar_ai_providers
            (provider_code, provider_name, api_format, model_id, api_key, is_active, created_by)
        VALUES
            ('ANTHROPIC', 'Anthropic Claude', 'ANTHROPIC',
             v_model, v_key, 'Y', SYS_CONTEXT('USERENV','SESSION_USER'));
        DBMS_OUTPUT.PUT_LINE('Provider migrated: ANTHROPIC');
    END IF;

    SELECT COUNT(*) INTO v_n FROM dct_ar_ai_providers WHERE provider_code = 'GEMINI';
    IF v_n = 0 THEN
        v_model := NVL(setting_val('GEMINI_MODEL'), 'gemini-flash-latest');
        v_key   := setting_val('GEMINI_API_KEY');
        INSERT INTO dct_ar_ai_providers
            (provider_code, provider_name, api_format, model_id, api_key, is_active, created_by)
        VALUES
            ('GEMINI', 'Google Gemini', 'GEMINI',
             v_model, v_key, 'Y', SYS_CONTEXT('USERENV','SESSION_USER'));
        DBMS_OUTPUT.PUT_LINE('Provider migrated: GEMINI');
    END IF;

    DELETE FROM dct_module_settings
    WHERE  module_id = v_module_id
    AND    setting_key IN ('AI_MODEL','ANTHROPIC_API_KEY','GEMINI_MODEL','GEMINI_API_KEY');
    DBMS_OUTPUT.PUT_LINE('Setting rows removed: ' || SQL%ROWCOUNT);

    UPDATE dct_module_settings
    SET    setting_label       = 'AI Provider',
           setting_description = 'The managed AI provider used for document classification and P&L extraction. Providers (model, API key, endpoint) are maintained in Module Settings via Manage Providers.',
           value_type          = 'SELECT',
           allowed_values      = NULL,
           default_value       = 'ANTHROPIC'
    WHERE  module_id = v_module_id AND setting_key = 'AI_PROVIDER';

    COMMIT;
END;
/

-- =============================================================================
-- 4. Value-type switchovers (pick-lists + colour picker)
--    Platform chk_dct_modset_valtype gains the COLOR value first
--    (db/v2/01_dct_ddl.sql carries the same definition for fresh installs).
-- =============================================================================
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE dct_module_settings DROP CONSTRAINT chk_dct_modset_valtype';
    EXECUTE IMMEDIATE q'[ALTER TABLE dct_module_settings ADD CONSTRAINT chk_dct_modset_valtype
        CHECK (value_type IN ('BOOLEAN','NUMBER','TEXT','SELECT','COLOR'))]';
    DBMS_OUTPUT.PUT_LINE('chk_dct_modset_valtype now includes COLOR');
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE = -2443 THEN NULL; ELSE RAISE; END IF;  -- constraint already swapped
END;
/

DECLARE
    v_module_id dct_modules.module_id%TYPE;

    PROCEDURE conv (p_key VARCHAR2, p_type VARCHAR2, p_allow VARCHAR2) IS
    BEGIN
        UPDATE dct_module_settings
        SET    value_type     = p_type,
               allowed_values = p_allow
        WHERE  module_id = v_module_id AND setting_key = p_key;
    END;
BEGIN
    SELECT module_id INTO v_module_id
    FROM   dct_modules WHERE module_code = 'ACCOUNTS_RECEIVABLE';

    conv('MIN_CONFIDENCE_AUTOCONFIRM', 'SELECT', '50|55|60|65|70|75|80|85|90|95|100');
    conv('MAX_FILE_SIZE_MB',           'SELECT', '5|10|15|20|25');
    conv('DEFAULT_CURRENCY',           'SELECT', 'AED|USD|EUR|GBP|SAR|QAR|KWD|BHD|OMR');
    conv('THEME_BRAND_COLOR',          'COLOR',  NULL);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Value types switched: 4 settings');
END;
/

PROMPT === AR AI provider registry complete (DCT_AR_AI_PROVIDERS) ===
