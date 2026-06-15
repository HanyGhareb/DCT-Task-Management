-- =============================================================================
-- Platform -- MAX_UPLOAD_MB module setting (binary document upload size cap)
-- File    : db/v2/27_max_upload_mb.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @27_max_upload_mb.sql   (own session; data-only,
--           idempotent MERGE -- safe to re-run).
-- Purpose : Seeds the per-module MAX_UPLOAD_MB setting (in MB, default 10) read
--           by each module's binary documents file-upload handler to reject
--           oversized files with HTTP 413. The handlers also default to 10 when
--           the row is absent; this row makes the cap configurable in each
--           module's Settings page. FL already seeds its own row in
--           final apps/FL/db/10_fl_reg_documents.sql (re-merged here harmlessly).
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON

DECLARE
    TYPE t_codes IS TABLE OF VARCHAR2(30);
    v_codes t_codes := t_codes('FREELANCERS', 'CREDIT_CARDS', 'TASK_MGMT', 'HR');
    v_module_id dct_modules.module_id%TYPE;
BEGIN
    FOR i IN 1 .. v_codes.COUNT LOOP
        BEGIN
            SELECT module_id INTO v_module_id FROM dct_modules WHERE module_code = v_codes(i);
        EXCEPTION WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('SKIP: module ' || v_codes(i) || ' not found.');
            CONTINUE;
        END;

        MERGE INTO dct_module_settings s
        USING (SELECT v_module_id AS module_id, 'MAX_UPLOAD_MB' AS setting_key FROM dual) src
        ON    (s.module_id = src.module_id AND s.setting_key = src.setting_key)
        WHEN NOT MATCHED THEN
            INSERT (module_id, setting_key, setting_value, setting_label,
                    setting_description, value_type, allowed_values, default_value, effective_date)
            VALUES (v_module_id, 'MAX_UPLOAD_MB', '10',
                    'Maximum Document Upload Size (MB)',
                    'Largest single document file that can be uploaded. Files are sent as raw bytes; the server rejects anything above this with HTTP 413.',
                    'NUMBER', NULL, '10', SYSDATE)
        WHEN MATCHED THEN
            UPDATE SET setting_label      = 'Maximum Document Upload Size (MB)',
                       setting_description = 'Largest single document file that can be uploaded. Files are sent as raw bytes; the server rejects anything above this with HTTP 413.',
                       value_type          = 'NUMBER',
                       default_value        = '10';
        DBMS_OUTPUT.PUT_LINE('MAX_UPLOAD_MB merged for ' || v_codes(i));
    END LOOP;
    COMMIT;
END;
/

PROMPT === 27_max_upload_mb.sql complete ===
