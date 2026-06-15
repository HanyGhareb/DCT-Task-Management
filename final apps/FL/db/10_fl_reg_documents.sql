-- =============================================================================
-- Freelancers Module (App 203) -- Registration Required Documents
-- File    : 10_fl_reg_documents.sql
-- Schema  : PROD
-- Run     : After 03_fl_seed.sql (needs dct_modules row + dct_document_types).
--           Data-only + idempotent (MERGE) -- safe to re-run. Own SQLcl session.
-- Purpose : 1) DOCS_REQUIRED_FOR_SUBMIT module setting (gates the submit check).
--           2) DCT_DOC_REQUIREMENTS rows for context REGISTRATION (the doc
--              checklist shown on the registration page). Conditional rules
--              (Emirates ID only for AE / ID provided; Residence Visa only for
--              non-AE) are applied in code -- DCT_FL_PKG.submit_registration and
--              the JET registrationEdit checklist -- keyed on doc_type_code.
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON

-- ----------------------------------------------------------------------------
-- 1. Module setting: DOCS_REQUIRED_FOR_SUBMIT (default Y)
-- ----------------------------------------------------------------------------
DECLARE
    v_module_id dct_modules.module_id%TYPE;
BEGIN
    SELECT module_id INTO v_module_id FROM dct_modules WHERE module_code = 'FREELANCERS';

    MERGE INTO dct_module_settings s
    USING (SELECT v_module_id AS module_id, 'DOCS_REQUIRED_FOR_SUBMIT' AS setting_key FROM dual) src
    ON    (s.module_id = src.module_id AND s.setting_key = src.setting_key)
    WHEN NOT MATCHED THEN
        INSERT (module_id, setting_key, setting_value, setting_label,
                setting_description, value_type, allowed_values, default_value, effective_date)
        VALUES (v_module_id, 'DOCS_REQUIRED_FOR_SUBMIT', 'Y',
                'Required Documents Before Submit',
                'Y = mandatory registration documents (passport, Emirates ID, visa, bank letter as applicable) must be attached before a registration can be submitted for approval.',
                'BOOLEAN', 'Y|N', 'Y', SYSDATE)
    WHEN MATCHED THEN
        UPDATE SET setting_label       = 'Required Documents Before Submit',
                   setting_description  = 'Y = mandatory registration documents (passport, Emirates ID, visa, bank letter as applicable) must be attached before a registration can be submitted for approval.',
                   value_type           = 'BOOLEAN',
                   allowed_values       = 'Y|N',
                   default_value        = 'Y';
    DBMS_OUTPUT.PUT_LINE('Setting DOCS_REQUIRED_FOR_SUBMIT merged.');
END;
/

-- ----------------------------------------------------------------------------
-- 2. Document requirements for context REGISTRATION
--    is_mandatory marks the candidate set; conditional applicability is in code.
-- ----------------------------------------------------------------------------
DECLARE
    TYPE t_req IS RECORD (doc_type_code VARCHAR2(100), is_mandatory VARCHAR2(1), display_seq NUMBER);
    TYPE t_req_list IS TABLE OF t_req;
    v_reqs t_req_list := t_req_list(
        t_req('PASSPORT',       'Y', 10),   -- always
        t_req('EMIRATES_ID',    'Y', 20),   -- code-conditional: AE or Emirates ID entered
        t_req('RESIDENCE_VISA', 'Y', 30),   -- code-conditional: non-AE nationals
        t_req('BANK_LETTER',    'Y', 40)    -- always
    );
    v_doc_type_id NUMBER;
BEGIN
    FOR i IN 1 .. v_reqs.COUNT LOOP
        BEGIN
            SELECT doc_type_id INTO v_doc_type_id
            FROM   dct_document_types WHERE doc_type_code = v_reqs(i).doc_type_code;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('SKIP: doc type ' || v_reqs(i).doc_type_code || ' not found.');
            CONTINUE;
        END;

        MERGE INTO dct_doc_requirements r
        USING (SELECT 'FL' AS source_module, 'REGISTRATION' AS context_code,
                      v_doc_type_id AS doc_type_id FROM dual) src
        ON    (r.source_module = src.source_module
               AND r.context_code = src.context_code
               AND r.doc_type_id  = src.doc_type_id)
        WHEN NOT MATCHED THEN
            INSERT (source_module, context_code, doc_type_id, is_mandatory, display_seq, is_active)
            VALUES ('FL', 'REGISTRATION', v_doc_type_id,
                    v_reqs(i).is_mandatory, v_reqs(i).display_seq, 'Y')
        WHEN MATCHED THEN
            UPDATE SET is_mandatory = v_reqs(i).is_mandatory,
                       display_seq  = v_reqs(i).display_seq,
                       is_active    = 'Y';
        DBMS_OUTPUT.PUT_LINE('Requirement merged: ' || v_reqs(i).doc_type_code);
    END LOOP;
    COMMIT;
END;
/

PROMPT === 10_fl_reg_documents.sql complete ===
