-- =================================================================
-- Phase 2a: Schema additions + Package Spec
-- =================================================================
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK;

-- SOURCE_FILE column (already applied via DDL auto-commit — skip if exists)
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE PROD.DCT_PC_CLEAR_BUDGET_LINES ADD (SOURCE_FILE VARCHAR2(500))';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE PROD.DCT_PC_REIMB_BUDGET_LINES ADD (SOURCE_FILE VARCHAR2(500))';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- API key placeholder in module settings (value_type must be TEXT)
MERGE INTO prod.dct_module_settings ms
USING (SELECT module_id FROM prod.dct_modules WHERE module_code = 'PETTY_CASH') m
ON (ms.module_id = m.module_id AND ms.setting_key = 'ANTHROPIC_API_KEY')
WHEN NOT MATCHED THEN INSERT (
    module_id, setting_key, setting_value, setting_label, value_type, updated_by, updated_at
) VALUES (
    m.module_id, 'ANTHROPIC_API_KEY', 'REPLACE_WITH_REAL_KEY',
    'Anthropic API Key (AI Expense Extraction)', 'TEXT', 'SYSTEM', SYSTIMESTAMP
);

GRANT EXECUTE ON DBMS_CLOUD TO PROD;

COMMIT;

-- -----------------------------------------------------------------
-- Package Spec
-- -----------------------------------------------------------------
CREATE OR REPLACE PACKAGE prod.dct_pc_ai_pkg AS

    -- Extract expense lines from an uploaded file via Claude AI.
    -- Inserts lines into the appropriate budget lines table and logs.
    -- Call validate_lines() after this.
    PROCEDURE extract_from_file (
        p_file_blob    IN BLOB,
        p_mime_type    IN VARCHAR2,   -- 'application/pdf' | 'text/csv' | 'text/plain'
        p_file_name    IN VARCHAR2,
        p_request_type IN VARCHAR2,   -- 'CLEARING' | 'REIMB'
        p_request_id   IN NUMBER
    );

    -- Run both validation rules on all AI-extracted lines for a request.
    -- Updates VALIDATION_STATUS + VALIDATION_ERRORS on each line.
    -- Updates AI_TOTAL_LINES / AI_VALID_LINES on the parent header.
    PROCEDURE validate_lines (
        p_request_type IN VARCHAR2,
        p_request_id   IN NUMBER
    );

    -- Remove an AI-extracted line from a DRAFT request.
    PROCEDURE delete_line (
        p_line_id      IN NUMBER,
        p_request_type IN VARCHAR2
    );

    -- Register all VALID+IS_INCLUDED='Y' reference numbers into
    -- DCT_PC_USED_REFERENCES. Call once when request is submitted.
    PROCEDURE register_references (
        p_request_type IN VARCHAR2,
        p_request_id   IN NUMBER,
        p_employee_num IN VARCHAR2
    );

    -- Return all AI-extracted lines as a JSON array (for ORDS GET handler).
    FUNCTION get_lines_json (
        p_request_type IN VARCHAR2,
        p_request_id   IN NUMBER
    ) RETURN CLOB;

END dct_pc_ai_pkg;
/

PROMPT Phase 2a complete.
