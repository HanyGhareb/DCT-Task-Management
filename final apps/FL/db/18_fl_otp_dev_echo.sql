-- =============================================================================
-- Freelancers Module (App 203) -- Phase 1 -- DEV OTP echo switch
-- File    : 18_fl_otp_dev_echo.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @18_fl_otp_dev_echo.sql  (any session)
-- Purpose : Adds the gated DEV-only setting REG_OTP_DEV_ECHO. When 'Y', the
--           public  POST /reg/public/start  response includes "devCode" (the
--           plaintext 6-digit OTP) so testing can proceed WITHOUT a live SMTP
--           relay. DEFAULT 'N' -> never echoed.
--           !!! MUST stay 'N' in production -- it exposes verification codes. !!!
--           Toggle in Admin > Freelancers > Module Settings, or by UPDATE here.
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
    USING (SELECT v_module_id AS module_id, 'REG_OTP_DEV_ECHO' AS setting_key FROM dual) src
    ON    (s.module_id = src.module_id AND s.setting_key = src.setting_key)
    WHEN NOT MATCHED THEN
        INSERT (module_id, setting_key, setting_value, setting_label,
                setting_description, value_type, allowed_values, default_value, effective_date)
        VALUES (v_module_id, 'REG_OTP_DEV_ECHO', 'N',
                'DEV: Echo OTP code in response',
                'TESTING ONLY. Y = the public self-registration start response returns the plaintext verification code (no email needed). MUST be N in production.',
                'BOOLEAN', 'Y|N', 'N', SYSDATE);

    -- Enable now for the current testing round (set back to N before go-live).
    UPDATE prod.dct_module_settings
       SET setting_value = 'Y'
     WHERE module_id = v_module_id AND setting_key = 'REG_OTP_DEV_ECHO';

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('REG_OTP_DEV_ECHO set to Y (DEV).');
END;
/

PROMPT === 18_fl_otp_dev_echo.sql complete ===
