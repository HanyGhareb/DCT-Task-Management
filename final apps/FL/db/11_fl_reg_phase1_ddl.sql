-- =============================================================================
-- Freelancers Module (App 203) -- Phase 1 Registration Revamp -- DDL
-- File    : 11_fl_reg_phase1_ddl.sql
-- Schema  : PROD
-- Run     : After 10_fl_reg_documents.sql. Idempotent (column-add guarded,
--           tables created if absent, settings + lookups MERGEd). Own SQLcl
--           session. NOT an ORDS/synonym script (ALTER SESSION is safe here).
-- Purpose : 1) New columns on DCT_FL_REGISTRATIONS: requestor + line-manager
--              identity, email_verified, registration bank capture, dedup state.
--           2) DCT_FL_DOC_EXTRACTS  -- AI document-extraction audit.
--           3) DCT_FL_REG_OTP       -- public self-registration email OTP.
--           4) dct_approval_instances.dynamic_approver_user_id (shared, additive)
--              -- per-instance named approver (line manager as first approver).
--           5) Module settings (AI gate/model, OTP policy, dedup policy).
--           6) Lookup sets FL_DUP_STATUS / FL_EXTRACT_STATUS / FL_OTP_STATUS.
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON

ALTER SESSION SET CURRENT_SCHEMA = PROD;

-- ----------------------------------------------------------------------------
-- 1. DCT_FL_REGISTRATIONS -- new columns (guarded add, rerunnable)
-- ----------------------------------------------------------------------------
DECLARE
    PROCEDURE add_col (p_col VARCHAR2, p_ddl VARCHAR2) IS
        v_cnt NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_cnt FROM all_tab_cols
        WHERE  owner = 'PROD' AND table_name = 'DCT_FL_REGISTRATIONS' AND column_name = p_col;
        IF v_cnt = 0 THEN
            EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_fl_registrations ADD ' || p_ddl;
            DBMS_OUTPUT.PUT_LINE('Added DCT_FL_REGISTRATIONS.' || p_col);
        END IF;
    END;
BEGIN
    -- Requestor / line-manager identity (emails captured; user ids resolved when internal)
    add_col('REQUESTOR_EMAIL',       'requestor_email VARCHAR2(200)');
    add_col('REQUESTOR_NAME',        'requestor_name VARCHAR2(200)');
    add_col('REQUESTOR_USER_ID',     'requestor_user_id NUMBER');
    add_col('LINE_MANAGER_EMAIL',    'line_manager_email VARCHAR2(200)');
    add_col('LINE_MANAGER_NAME',     'line_manager_name VARCHAR2(200)');
    add_col('LINE_MANAGER_USER_ID',  'line_manager_user_id NUMBER');
    -- Public self-registration verification
    add_col('EMAIL_VERIFIED',        'email_verified VARCHAR2(1) DEFAULT ''N''');
    -- Bank capture at registration (flows to DCT_FL_BANK_ACCOUNTS on approval; AI-fillable)
    add_col('BANK_NAME',             'bank_name VARCHAR2(100)');
    add_col('BANK_IBAN',             'bank_iban VARCHAR2(34)');
    add_col('BANK_ACCOUNT_NAME',     'bank_account_name VARCHAR2(200)');
    add_col('BANK_ACCOUNT_NUMBER',   'bank_account_number VARCHAR2(50)');
    add_col('BANK_SWIFT',            'bank_swift VARCHAR2(20)');
    add_col('BANK_CURRENCY_CODE',    'bank_currency_code VARCHAR2(3)');
    -- Duplicate-detection state (lookup FL_DUP_STATUS: NONE|REVIEW|OVERRIDDEN)
    add_col('DUP_STATUS',            'dup_status VARCHAR2(20) DEFAULT ''NONE''');
    add_col('DUP_MATCH_JSON',        'dup_match_json CLOB');
    add_col('DUP_OVERRIDDEN_BY',     'dup_overridden_by NUMBER');
    add_col('DUP_OVERRIDDEN_AT',     'dup_overridden_at TIMESTAMP');
END;
/

-- FKs for the resolved internal users (added once, guarded)
DECLARE
    v_cnt NUMBER;
    PROCEDURE add_fk (p_name VARCHAR2, p_ddl VARCHAR2) IS
    BEGIN
        SELECT COUNT(*) INTO v_cnt FROM all_constraints
        WHERE owner = 'PROD' AND constraint_name = p_name;
        IF v_cnt = 0 THEN
            EXECUTE IMMEDIATE p_ddl;
            DBMS_OUTPUT.PUT_LINE('Added constraint ' || p_name);
        END IF;
    END;
BEGIN
    add_fk('FK_DCT_FL_REG_REQUSER',
        'ALTER TABLE prod.dct_fl_registrations ADD CONSTRAINT fk_dct_fl_reg_requser '
        || 'FOREIGN KEY (requestor_user_id) REFERENCES prod.dct_users(user_id)');
    add_fk('FK_DCT_FL_REG_LMUSER',
        'ALTER TABLE prod.dct_fl_registrations ADD CONSTRAINT fk_dct_fl_reg_lmuser '
        || 'FOREIGN KEY (line_manager_user_id) REFERENCES prod.dct_users(user_id)');
END;
/

-- ----------------------------------------------------------------------------
-- 2. DCT_FL_DOC_EXTRACTS -- AI extraction audit (one row per AI run on a doc)
-- ----------------------------------------------------------------------------
DECLARE
    v_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt FROM all_tables WHERE owner = 'PROD' AND table_name = 'DCT_FL_DOC_EXTRACTS';
    IF v_cnt = 0 THEN
        EXECUTE IMMEDIATE q'[
            CREATE TABLE prod.dct_fl_doc_extracts (
                extract_id      NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                registration_id NUMBER,
                doc_id          NUMBER        NOT NULL,
                doc_type_code   VARCHAR2(100),
                model           VARCHAR2(100),
                status          VARCHAR2(20)  DEFAULT 'PENDING' NOT NULL,
                confidence      NUMBER,
                extracted_json  CLOB,
                raw_response    CLOB,
                error_msg       VARCHAR2(4000),
                created_by      NUMBER,
                created_at      TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL
            )
        ]';
        EXECUTE IMMEDIATE 'CREATE INDEX prod.ix_dct_fl_ext_reg ON prod.dct_fl_doc_extracts(registration_id)';
        EXECUTE IMMEDIATE 'CREATE INDEX prod.ix_dct_fl_ext_doc ON prod.dct_fl_doc_extracts(doc_id)';
        DBMS_OUTPUT.PUT_LINE('Created DCT_FL_DOC_EXTRACTS.');
    END IF;
END;
/

-- ----------------------------------------------------------------------------
-- 3. DCT_FL_REG_OTP -- public self-registration email verification (OTP)
--    intake_token is the short-lived credential the unauthenticated portal
--    uses for /reg/public/:token after the email is verified.
-- ----------------------------------------------------------------------------
DECLARE
    v_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt FROM all_tables WHERE owner = 'PROD' AND table_name = 'DCT_FL_REG_OTP';
    IF v_cnt = 0 THEN
        EXECUTE IMMEDIATE q'[
            CREATE TABLE prod.dct_fl_reg_otp (
                otp_id          NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                email           VARCHAR2(200) NOT NULL,
                code_hash       VARCHAR2(128) NOT NULL,
                intake_token    VARCHAR2(64),
                registration_id NUMBER,
                status          VARCHAR2(20)  DEFAULT 'PENDING' NOT NULL,
                attempts        NUMBER        DEFAULT 0 NOT NULL,
                expires_at      TIMESTAMP     NOT NULL,
                verified_at     TIMESTAMP,
                created_at      TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL
            )
        ]';
        EXECUTE IMMEDIATE 'CREATE INDEX prod.ix_dct_fl_otp_email  ON prod.dct_fl_reg_otp(email)';
        EXECUTE IMMEDIATE 'CREATE INDEX prod.ix_dct_fl_otp_token  ON prod.dct_fl_reg_otp(intake_token)';
        DBMS_OUTPUT.PUT_LINE('Created DCT_FL_REG_OTP.');
    END IF;
END;
/

-- ----------------------------------------------------------------------------
-- 4. DCT_APPROVAL_INSTANCES.dynamic_approver_user_id  (SHARED, additive)
--    Per-instance named approver. NULL for all existing/role-based instances,
--    so role routing for every other module is unaffected. FL sets it to the
--    line manager for the USER_SPECIFIC first step.
-- ----------------------------------------------------------------------------
DECLARE
    v_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt FROM all_tab_cols
    WHERE  owner = 'PROD' AND table_name = 'DCT_APPROVAL_INSTANCES' AND column_name = 'DYNAMIC_APPROVER_USER_ID';
    IF v_cnt = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_approval_instances ADD '
            || 'dynamic_approver_user_id NUMBER';
        EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_approval_instances ADD CONSTRAINT '
            || 'fk_dct_inst_dynuser FOREIGN KEY (dynamic_approver_user_id) '
            || 'REFERENCES prod.dct_users(user_id)';
        DBMS_OUTPUT.PUT_LINE('Added DCT_APPROVAL_INSTANCES.DYNAMIC_APPROVER_USER_ID.');
    END IF;
END;
/

-- ----------------------------------------------------------------------------
-- 5. Module settings (FREELANCERS) -- AI, OTP, dedup policy
-- ----------------------------------------------------------------------------
DECLARE
    v_module_id dct_modules.module_id%TYPE;
    TYPE t_s IS RECORD (k VARCHAR2(50), v VARCHAR2(200), lbl VARCHAR2(200),
                        dsc VARCHAR2(1000), typ VARCHAR2(20), allow VARCHAR2(50), def VARCHAR2(200));
    TYPE t_sl IS TABLE OF t_s;
    v_s t_sl := t_sl(
        t_s('AI_FEATURES_ENABLED','N','Enable AI Document Extraction',
            'Y = applicants/staff can run AI extraction on uploaded Passport, Emirates ID and Bank Letter to auto-fill the registration form. Requires an active ANTHROPIC provider key.',
            'BOOLEAN','Y|N','N'),
        t_s('AI_MODEL','claude-sonnet-4-6','AI Extraction Model',
            'Anthropic model id used for document data extraction (vision). Default claude-sonnet-4-6.',
            'TEXT',NULL,'claude-sonnet-4-6'),
        t_s('AI_MAX_TOKENS','1500','AI Max Tokens',
            'Maximum output tokens for the extraction response.',
            'NUMBER',NULL,'1500'),
        t_s('REG_OTP_EXPIRY_MIN','15','Self-Registration OTP Expiry (minutes)',
            'How long a public self-registration email verification code stays valid.',
            'NUMBER',NULL,'15'),
        t_s('REG_OTP_MAX_ATTEMPTS','5','Self-Registration OTP Max Attempts',
            'Maximum wrong-code attempts before a verification code is locked.',
            'NUMBER',NULL,'5'),
        t_s('DUP_BLOCK_ON_EXACT','Y','Block Duplicate on Exact Match',
            'Y = block submission when the Emirates ID, passport, IBAN or email exactly matches an existing registration or freelancer. Fuzzy (name+DOB) matches are always flagged for review, never auto-blocked.',
            'BOOLEAN','Y|N','Y')
    );
BEGIN
    SELECT module_id INTO v_module_id FROM dct_modules WHERE module_code = 'FREELANCERS';
    FOR i IN 1 .. v_s.COUNT LOOP
        MERGE INTO dct_module_settings s
        USING (SELECT v_module_id AS module_id, v_s(i).k AS setting_key FROM dual) src
        ON    (s.module_id = src.module_id AND s.setting_key = src.setting_key)
        WHEN NOT MATCHED THEN
            INSERT (module_id, setting_key, setting_value, setting_label,
                    setting_description, value_type, allowed_values, default_value, effective_date)
            VALUES (v_module_id, v_s(i).k, v_s(i).v, v_s(i).lbl,
                    v_s(i).dsc, v_s(i).typ, v_s(i).allow, v_s(i).def, SYSDATE)
        WHEN MATCHED THEN
            UPDATE SET setting_label = v_s(i).lbl, setting_description = v_s(i).dsc,
                       value_type = v_s(i).typ, allowed_values = v_s(i).allow,
                       default_value = v_s(i).def;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Settings merged: ' || v_s.COUNT || ' FREELANCERS settings.');
END;
/

-- ----------------------------------------------------------------------------
-- 6. Lookup sets (lookup-first; no CHECK constraints on the new columns)
-- ----------------------------------------------------------------------------
DECLARE
    v_module_id dct_modules.module_id%TYPE;
    v_cat       dct_lookup_categories.category_id%TYPE;

    PROCEDURE upsert_category (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2,
                               p_mod NUMBER, p_id OUT NUMBER) IS
    BEGIN
        MERGE INTO dct_lookup_categories tgt
        USING (SELECT p_code AS category_code FROM dual) src
        ON    (tgt.category_code = src.category_code)
        WHEN NOT MATCHED THEN
            INSERT (category_code, category_name_en, category_name_ar, module_id, is_system, is_active)
            VALUES (p_code, p_en, p_ar, p_mod, 'N', 'Y')
        WHEN MATCHED THEN
            UPDATE SET category_name_en = p_en;
        SELECT category_id INTO p_id FROM dct_lookup_categories WHERE category_code = p_code;
    END;

    PROCEDURE upsert_value (p_cat NUMBER, p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2,
                            p_ord NUMBER, p_def VARCHAR2 DEFAULT 'N') IS
    BEGIN
        MERGE INTO dct_lookup_values tgt
        USING (SELECT p_cat AS category_id, p_code AS value_code FROM dual) src
        ON    (tgt.category_id = src.category_id AND tgt.value_code = src.value_code)
        WHEN NOT MATCHED THEN
            INSERT (category_id, value_code, value_name_en, value_name_ar, display_order, is_default, is_active)
            VALUES (p_cat, p_code, p_en, p_ar, p_ord, p_def, 'Y')
        WHEN MATCHED THEN
            UPDATE SET value_name_en = p_en, value_name_ar = p_ar, display_order = p_ord;
    END;
BEGIN
    SELECT module_id INTO v_module_id FROM dct_modules WHERE module_code = 'FREELANCERS';

    upsert_category('FL_DUP_STATUS', 'Freelancer Duplicate Status', 'ÃƒËœÃ‚Â­ÃƒËœÃ‚Â§Ãƒâ„¢Ã¢â‚¬Å¾ÃƒËœÃ‚Â© ÃƒËœÃ‚Â§Ãƒâ„¢Ã¢â‚¬Å¾ÃƒËœÃ‚ÂªÃƒâ„¢Ã†â€™ÃƒËœÃ‚Â±ÃƒËœÃ‚Â§ÃƒËœÃ‚Â±', v_module_id, v_cat);
    upsert_value(v_cat, 'NONE',       'No Duplicate',       'Ãƒâ„¢Ã¢â‚¬Å¾ÃƒËœÃ‚Â§ Ãƒâ„¢Ã…Â Ãƒâ„¢Ã‹â€ ÃƒËœÃ‚Â¬ÃƒËœÃ‚Â¯ ÃƒËœÃ‚ÂªÃƒâ„¢Ã†â€™ÃƒËœÃ‚Â±ÃƒËœÃ‚Â§ÃƒËœÃ‚Â±', 10, 'Y');
    upsert_value(v_cat, 'REVIEW',     'Needs Review',       'ÃƒËœÃ‚Â¨ÃƒËœÃ‚Â­ÃƒËœÃ‚Â§ÃƒËœÃ‚Â¬ÃƒËœÃ‚Â© Ãƒâ„¢Ã¢â‚¬Å¾Ãƒâ„¢Ã¢â‚¬Â¦ÃƒËœÃ‚Â±ÃƒËœÃ‚Â§ÃƒËœÃ‚Â¬ÃƒËœÃ‚Â¹ÃƒËœÃ‚Â©', 20);
    upsert_value(v_cat, 'OVERRIDDEN', 'Override Approved',  'ÃƒËœÃ‚ÂªÃƒâ„¢Ã¢â‚¬Â¦ ÃƒËœÃ‚Â§Ãƒâ„¢Ã¢â‚¬Å¾ÃƒËœÃ‚ÂªÃƒËœÃ‚Â¬ÃƒËœÃ‚Â§Ãƒâ„¢Ã‹â€ ÃƒËœÃ‚Â²',    30);

    upsert_category('FL_EXTRACT_STATUS', 'Freelancer AI Extract Status', 'ÃƒËœÃ‚Â­ÃƒËœÃ‚Â§Ãƒâ„¢Ã¢â‚¬Å¾ÃƒËœÃ‚Â© ÃƒËœÃ‚Â§Ãƒâ„¢Ã¢â‚¬Å¾ÃƒËœÃ‚Â§ÃƒËœÃ‚Â³ÃƒËœÃ‚ÂªÃƒËœÃ‚Â®ÃƒËœÃ‚Â±ÃƒËœÃ‚Â§ÃƒËœÃ‚Â¬', v_module_id, v_cat);
    upsert_value(v_cat, 'PENDING', 'Pending', 'Ãƒâ„¢Ã¢â‚¬Å¡Ãƒâ„¢Ã…Â ÃƒËœÃ‚Â¯ ÃƒËœÃ‚Â§Ãƒâ„¢Ã¢â‚¬Å¾ÃƒËœÃ‚Â§Ãƒâ„¢Ã¢â‚¬Â ÃƒËœÃ‚ÂªÃƒËœÃ‚Â¸ÃƒËœÃ‚Â§ÃƒËœÃ‚Â±', 10, 'Y');
    upsert_value(v_cat, 'DONE',    'Done',    'ÃƒËœÃ‚ÂªÃƒâ„¢Ã¢â‚¬Â¦',           20);
    upsert_value(v_cat, 'FAILED',  'Failed',  'Ãƒâ„¢Ã‚ÂÃƒËœÃ‚Â´Ãƒâ„¢Ã¢â‚¬Å¾',          30);
    upsert_value(v_cat, 'APPLIED', 'Applied', 'ÃƒËœÃ‚ÂªÃƒâ„¢Ã¢â‚¬Â¦ ÃƒËœÃ‚Â§Ãƒâ„¢Ã¢â‚¬Å¾ÃƒËœÃ‚ÂªÃƒËœÃ‚Â·ÃƒËœÃ‚Â¨Ãƒâ„¢Ã…Â Ãƒâ„¢Ã¢â‚¬Å¡',   40);

    upsert_category('FL_OTP_STATUS', 'Freelancer Registration OTP Status', 'ÃƒËœÃ‚Â­ÃƒËœÃ‚Â§Ãƒâ„¢Ã¢â‚¬Å¾ÃƒËœÃ‚Â© ÃƒËœÃ‚Â±Ãƒâ„¢Ã¢â‚¬Â¦ÃƒËœÃ‚Â² ÃƒËœÃ‚Â§Ãƒâ„¢Ã¢â‚¬Å¾ÃƒËœÃ‚ÂªÃƒËœÃ‚Â­Ãƒâ„¢Ã¢â‚¬Å¡Ãƒâ„¢Ã¢â‚¬Å¡', v_module_id, v_cat);
    upsert_value(v_cat, 'PENDING',  'Pending',  'Ãƒâ„¢Ã¢â‚¬Å¡Ãƒâ„¢Ã…Â ÃƒËœÃ‚Â¯ ÃƒËœÃ‚Â§Ãƒâ„¢Ã¢â‚¬Å¾ÃƒËœÃ‚Â§Ãƒâ„¢Ã¢â‚¬Â ÃƒËœÃ‚ÂªÃƒËœÃ‚Â¸ÃƒËœÃ‚Â§ÃƒËœÃ‚Â±', 10, 'Y');
    upsert_value(v_cat, 'VERIFIED', 'Verified', 'ÃƒËœÃ‚ÂªÃƒâ„¢Ã¢â‚¬Â¦ ÃƒËœÃ‚Â§Ãƒâ„¢Ã¢â‚¬Å¾ÃƒËœÃ‚ÂªÃƒËœÃ‚Â­Ãƒâ„¢Ã¢â‚¬Å¡Ãƒâ„¢Ã¢â‚¬Å¡',    20);
    upsert_value(v_cat, 'EXPIRED',  'Expired',  'Ãƒâ„¢Ã¢â‚¬Â¦Ãƒâ„¢Ã¢â‚¬Â ÃƒËœÃ‚ÂªÃƒâ„¢Ã¢â‚¬Â¡Ãƒâ„¢Ã…Â ',        30);
    upsert_value(v_cat, 'LOCKED',   'Locked',   'Ãƒâ„¢Ã¢â‚¬Â¦Ãƒâ„¢Ã¢â‚¬Å¡Ãƒâ„¢Ã‚ÂÃƒâ„¢Ã¢â‚¬Å¾',         40);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Lookup sets merged: FL_DUP_STATUS, FL_EXTRACT_STATUS, FL_OTP_STATUS.');
END;
/

PROMPT === 11_fl_reg_phase1_ddl.sql complete ===
