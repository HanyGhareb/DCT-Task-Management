-- =================================================================
-- Phase 2b: Package Body — PROD.DCT_PC_AI_PKG
-- =================================================================
SET DEFINE OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK;

CREATE OR REPLACE PACKAGE BODY prod.dct_pc_ai_pkg AS

    c_model      CONSTANT VARCHAR2(100) := 'claude-haiku-4-5-20251001';
    c_api_url    CONSTANT VARCHAR2(200) := 'https://api.anthropic.com/v1/messages';
    c_module     CONSTANT VARCHAR2(50)  := 'PETTY_CASH';
    c_max_tokens CONSTANT NUMBER        := 4096;

    -- ----------------------------------------------------------------
    -- Private: read Anthropic API key from module settings
    -- ----------------------------------------------------------------
    FUNCTION get_api_key RETURN VARCHAR2 IS
        v_key prod.dct_module_settings.setting_value%TYPE;
    BEGIN
        SELECT ms.setting_value
        INTO   v_key
        FROM   prod.dct_module_settings ms
        JOIN   prod.dct_modules m ON m.module_id = ms.module_id
        WHERE  m.module_code  = c_module
        AND    ms.setting_key = 'ANTHROPIC_API_KEY';
        RETURN v_key;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN NULL;
    END get_api_key;

    -- ----------------------------------------------------------------
    -- Private: BLOB → base64 CLOB (strips line breaks, 23814-byte chunks)
    -- 23814 is divisible by 3 → no padding issues across chunk boundaries
    -- ----------------------------------------------------------------
    FUNCTION blob_to_base64 (p_blob IN BLOB) RETURN CLOB IS
        v_result CLOB;
        v_raw    RAW(23814);
        v_b64    VARCHAR2(32767);
        v_pos    PLS_INTEGER := 1;
        v_len    PLS_INTEGER;
        c_chunk  CONSTANT PLS_INTEGER := 23814;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(v_result, TRUE);
        v_len := DBMS_LOB.GETLENGTH(p_blob);
        IF v_len IS NULL OR v_len = 0 THEN RETURN v_result; END IF;
        WHILE v_pos <= v_len LOOP
            v_raw := DBMS_LOB.SUBSTR(p_blob, LEAST(c_chunk, v_len - v_pos + 1), v_pos);
            v_b64 := UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(v_raw));
            v_b64 := REPLACE(REPLACE(v_b64, CHR(13), ''), CHR(10), '');
            DBMS_LOB.WRITEAPPEND(v_result, LENGTH(v_b64), v_b64);
            v_pos := v_pos + c_chunk;
        END LOOP;
        RETURN v_result;
    END blob_to_base64;

    -- ----------------------------------------------------------------
    -- Private: append a VARCHAR2 literal to a CLOB
    -- ----------------------------------------------------------------
    PROCEDURE clob_append (p_clob IN OUT NOCOPY CLOB, p_text IN VARCHAR2) IS
    BEGIN
        DBMS_LOB.WRITEAPPEND(p_clob, LENGTH(p_text), p_text);
    END clob_append;

    -- ----------------------------------------------------------------
    -- Private: build Anthropic messages API payload CLOB
    -- ----------------------------------------------------------------
    FUNCTION build_payload (
        p_file_blob IN BLOB,
        p_mime_type IN VARCHAR2
    ) RETURN CLOB IS
        v_payload CLOB;
        v_b64     CLOB;
        v_prompt  VARCHAR2(2000) :=
            'You are a financial document parser. Extract ALL expense line items.'
         || CHR(10) || 'Return ONLY a valid JSON array — no explanation, no markdown.'
         || CHR(10) || 'Each object must have exactly: item_name, category, expense_date (YYYY-MM-DD or null),'
         || CHR(10) || 'amount (number or null), currency (ISO 4217, default AED),'
         || CHR(10) || 'vendor_name, reference_number (invoice/order/barcode or null).'
         || CHR(10) || 'Categories: Meals & Entertainment, Transport & Travel, Accommodation,'
         || CHR(10) || 'Office Supplies, IT Equipment, Communication, Maintenance & Repair,'
         || CHR(10) || 'Training & Development, Medical, Utilities, Postage & Courier,'
         || CHR(10) || 'Marketing, Professional Services, Other.'
         || CHR(10) || 'Use null for unreadable fields. Never invent data.';
    BEGIN
        DBMS_LOB.CREATETEMPORARY(v_payload, TRUE);
        clob_append(v_payload, '{"model":"' || c_model || '"');
        clob_append(v_payload, ',"max_tokens":' || c_max_tokens);
        clob_append(v_payload, ',"messages":[{"role":"user","content":[');

        IF p_mime_type = 'application/pdf' THEN
            v_b64 := blob_to_base64(p_file_blob);
            clob_append(v_payload, '{"type":"document","source":{"type":"base64"');
            clob_append(v_payload, ',"media_type":"application/pdf","data":"');
            DBMS_LOB.APPEND(v_payload, v_b64);
            DBMS_LOB.FREETEMPORARY(v_b64);
            clob_append(v_payload, '"}},');
        ELSE
            -- CSV / plain text: convert BLOB to CLOB and send as text block
            DECLARE
                v_text     CLOB;
                v_doffset  INTEGER := 1;
                v_soffset  INTEGER := 1;
                v_langctx  INTEGER := DBMS_LOB.DEFAULT_LANG_CTX;
                v_warning  INTEGER;
            BEGIN
                DBMS_LOB.CREATETEMPORARY(v_text, TRUE);
                DBMS_LOB.CONVERTTOCLOB(v_text, p_file_blob,
                    DBMS_LOB.GETLENGTH(p_file_blob), v_doffset, v_soffset,
                    DBMS_LOB.DEFAULT_CSID, v_langctx, v_warning);
                clob_append(v_payload, '{"type":"text","text":');
                DBMS_LOB.APPEND(v_payload, APEX_JSON.STRINGIFY(v_text));
                DBMS_LOB.FREETEMPORARY(v_text);
            END;
            clob_append(v_payload, '},');
        END IF;

        clob_append(v_payload, '{"type":"text","text":' || APEX_JSON.STRINGIFY(v_prompt) || '}');
        clob_append(v_payload, ']}]}');
        RETURN v_payload;
    END build_payload;

    -- ----------------------------------------------------------------
    -- Private: POST CLOB payload to Anthropic via DBMS_CLOUD
    -- ----------------------------------------------------------------
    FUNCTION call_anthropic (p_payload IN CLOB) RETURN CLOB IS
        v_resp      DBMS_CLOUD_TYPES.resp;
        v_body_blob BLOB;
        v_doffset   INTEGER := 1;
        v_soffset   INTEGER := 1;
        v_langctx   INTEGER := DBMS_LOB.DEFAULT_LANG_CTX;
        v_warning   INTEGER;
        v_api_key   VARCHAR2(200) := get_api_key();
        v_headers   VARCHAR2(500);
        v_status    NUMBER;
        v_response  CLOB;
    BEGIN
        IF v_api_key IS NULL OR v_api_key = 'REPLACE_WITH_REAL_KEY' THEN
            RAISE_APPLICATION_ERROR(-20001,
                'ANTHROPIC_API_KEY not configured in dct_module_settings for PETTY_CASH');
        END IF;

        -- Convert CLOB payload to BLOB (UTF-8)
        DBMS_LOB.CREATETEMPORARY(v_body_blob, TRUE);
        DBMS_LOB.CONVERTTOBLOB(
            dest_lob     => v_body_blob,
            src_clob     => p_payload,
            amount       => DBMS_LOB.GETLENGTH(p_payload),
            dest_offset  => v_doffset,
            src_offset   => v_soffset,
            blob_csid    => NLS_CHARSET_ID('AL32UTF8'),
            lang_context => v_langctx,
            warning      => v_warning
        );

        v_headers := '{"anthropic-version":"2023-06-01"'
                  || ',"x-api-key":"' || v_api_key || '"'
                  || ',"content-type":"application/json"}';

        v_resp := DBMS_CLOUD.SEND_REQUEST(
            uri     => c_api_url,
            method  => 'POST',
            headers => v_headers,
            body    => v_body_blob
        );
        DBMS_LOB.FREETEMPORARY(v_body_blob);

        v_status   := DBMS_CLOUD.GET_RESPONSE_STATUS_CODE(v_resp);
        v_response := DBMS_CLOUD.GET_RESPONSE_TEXT(v_resp);

        IF v_status != 200 THEN
            RAISE_APPLICATION_ERROR(-20002,
                'Anthropic API error ' || v_status || ': ' || SUBSTR(v_response, 1, 500));
        END IF;

        RETURN v_response;
    EXCEPTION
        WHEN OTHERS THEN
            BEGIN DBMS_LOB.FREETEMPORARY(v_body_blob); EXCEPTION WHEN OTHERS THEN NULL; END;
            RAISE;
    END call_anthropic;

    -- ----------------------------------------------------------------
    -- Private: parse JSON array and insert lines into budget table
    -- ----------------------------------------------------------------
    PROCEDURE parse_and_insert_lines (
        p_json_array   IN CLOB,
        p_request_type IN VARCHAR2,
        p_request_id   IN NUMBER,
        p_file_name    IN VARCHAR2,
        p_count        OUT NUMBER
    ) IS
        v_total    PLS_INTEGER;
        v_max_ln   NUMBER := 0;
        v_item_name   VARCHAR2(500);
        v_category    VARCHAR2(100);
        v_exp_date    DATE;
        v_amount      NUMBER;
        v_currency    VARCHAR2(10);
        v_vendor      VARCHAR2(500);
        v_ref_num     VARCHAR2(200);
        v_confidence  NUMBER;
    BEGIN
        APEX_JSON.PARSE(p_json_array);
        v_total := APEX_JSON.GET_COUNT('.');

        IF p_request_type = 'CLEARING' THEN
            SELECT NVL(MAX(line_num), 0) INTO v_max_ln
            FROM prod.dct_pc_clear_budget_lines WHERE clearing_id = p_request_id;
        ELSE
            SELECT NVL(MAX(line_num), 0) INTO v_max_ln
            FROM prod.dct_pc_reimb_budget_lines WHERE reimb_id = p_request_id;
        END IF;

        FOR i IN 1..v_total LOOP
            v_item_name := APEX_JSON.GET_VARCHAR2('[%d].item_name', i);
            v_category  := APEX_JSON.GET_VARCHAR2('[%d].category', i);
            v_currency  := NVL(APEX_JSON.GET_VARCHAR2('[%d].currency', i), 'AED');
            v_vendor    := APEX_JSON.GET_VARCHAR2('[%d].vendor_name', i);
            v_ref_num   := APEX_JSON.GET_VARCHAR2('[%d].reference_number', i);

            BEGIN
                v_exp_date := TO_DATE(APEX_JSON.GET_VARCHAR2('[%d].expense_date', i), 'YYYY-MM-DD');
            EXCEPTION WHEN OTHERS THEN v_exp_date := NULL; END;

            BEGIN
                v_amount := APEX_JSON.GET_NUMBER('[%d].amount', i);
            EXCEPTION WHEN OTHERS THEN v_amount := 0; END;

            -- Confidence: penalise null key fields
            v_confidence := 100;
            IF v_exp_date IS NULL THEN v_confidence := v_confidence - 20; END IF;
            IF v_ref_num  IS NULL THEN v_confidence := v_confidence - 15; END IF;
            IF NVL(v_amount, 0) = 0 THEN v_confidence := v_confidence - 15; END IF;
            IF v_vendor   IS NULL THEN v_confidence := v_confidence - 10; END IF;

            v_max_ln := v_max_ln + 1;

            IF p_request_type = 'CLEARING' THEN
                INSERT INTO prod.dct_pc_clear_budget_lines (
                    clearing_id, line_num, amount, description,
                    item_name, category, expense_date, vendor_name,
                    reference_number, currency, source_file,
                    validation_status, is_ai_extracted, is_included, ai_confidence,
                    created_by, created_at, updated_by, updated_at
                ) VALUES (
                    p_request_id, v_max_ln, NVL(v_amount, 0), v_item_name,
                    v_item_name, v_category, v_exp_date, v_vendor,
                    v_ref_num, v_currency, p_file_name,
                    'PENDING', 'Y', 'Y', v_confidence,
                    SYS_CONTEXT('USERENV','SESSION_USER'), SYSTIMESTAMP,
                    SYS_CONTEXT('USERENV','SESSION_USER'), SYSTIMESTAMP
                );
            ELSE
                INSERT INTO prod.dct_pc_reimb_budget_lines (
                    reimb_id, line_num, amount, description,
                    item_name, category, expense_date, vendor_name,
                    reference_number, currency, source_file,
                    validation_status, is_ai_extracted, is_included, ai_confidence,
                    created_by, created_at, updated_by, updated_at
                ) VALUES (
                    p_request_id, v_max_ln, NVL(v_amount, 0), v_item_name,
                    v_item_name, v_category, v_exp_date, v_vendor,
                    v_ref_num, v_currency, p_file_name,
                    'PENDING', 'Y', 'Y', v_confidence,
                    SYS_CONTEXT('USERENV','SESSION_USER'), SYSTIMESTAMP,
                    SYS_CONTEXT('USERENV','SESSION_USER'), SYSTIMESTAMP
                );
            END IF;
        END LOOP;

        p_count := v_total;
    END parse_and_insert_lines;

    -- ================================================================
    -- Public: extract_from_file
    -- ================================================================
    PROCEDURE extract_from_file (
        p_file_blob    IN BLOB,
        p_mime_type    IN VARCHAR2,
        p_file_name    IN VARCHAR2,
        p_request_type IN VARCHAR2,
        p_request_id   IN NUMBER
    ) IS
        v_payload     CLOB;
        v_response    CLOB;
        v_items_json  CLOB;
        v_lines_count NUMBER := 0;
        v_error_msg   VARCHAR2(4000);
        v_sqlerrm     VARCHAR2(4000);
    BEGIN
        v_payload  := build_payload(p_file_blob, p_mime_type);
        v_response := call_anthropic(v_payload);
        DBMS_LOB.FREETEMPORARY(v_payload);

        -- Extract items array from Anthropic response: $.content[0].text
        BEGIN
            SELECT JSON_VALUE(v_response, '$.content[0].text' RETURNING CLOB)
            INTO   v_items_json
            FROM   DUAL;
        EXCEPTION
            WHEN OTHERS THEN
                v_error_msg  := 'Response parse failed: ' || SQLERRM;
                v_items_json := NULL;
        END;

        -- Trim any accidental prose before/after the JSON array
        IF v_items_json IS NOT NULL THEN
            v_items_json := SUBSTR(v_items_json,
                                   INSTR(v_items_json, '['),
                                   INSTR(v_items_json, ']', -1) - INSTR(v_items_json, '[') + 1);
        END IF;

        IF v_items_json IS NOT NULL AND DBMS_LOB.GETLENGTH(v_items_json) > 2 THEN
            parse_and_insert_lines(v_items_json, p_request_type, p_request_id,
                                   p_file_name, v_lines_count);
        END IF;

        -- Audit log
        INSERT INTO prod.dct_pc_ai_extract_log (
            request_type, request_id, file_name, mime_type,
            lines_extracted, ai_model, ai_raw_response,
            error_message, extracted_by, extracted_at
        ) VALUES (
            p_request_type, p_request_id, p_file_name, p_mime_type,
            v_lines_count, c_model, v_response,
            v_error_msg,
            SYS_CONTEXT('USERENV','SESSION_USER'), SYSTIMESTAMP
        );

        -- Refresh header summary
        IF p_request_type = 'CLEARING' THEN
            UPDATE prod.dct_pc_clearing
            SET    ai_last_extracted_at = SYSTIMESTAMP,
                   ai_total_lines       = ai_total_lines + v_lines_count,
                   updated_by = SYS_CONTEXT('USERENV','SESSION_USER'),
                   updated_at = SYSTIMESTAMP
            WHERE  clearing_id = p_request_id;
        ELSE
            UPDATE prod.dct_pc_reimbursements
            SET    ai_last_extracted_at = SYSTIMESTAMP,
                   ai_total_lines       = ai_total_lines + v_lines_count,
                   updated_by = SYS_CONTEXT('USERENV','SESSION_USER'),
                   updated_at = SYSTIMESTAMP
            WHERE  reimb_id = p_request_id;
        END IF;

        COMMIT;

        prod.dct_audit.log(
            p_action      => 'AI_EXTRACT',
            p_object_type => 'DCT_PC_' || p_request_type,
            p_object_id   => TO_CHAR(p_request_id),
            p_object_ref  => p_file_name,
            p_new_values  => TO_CLOB('{"lines_extracted":' || v_lines_count || '}'),
            p_module_code => c_module
        );

    EXCEPTION
        WHEN OTHERS THEN
            v_sqlerrm := SUBSTR(SQLERRM, 1, 4000);
            BEGIN DBMS_LOB.FREETEMPORARY(v_payload); EXCEPTION WHEN OTHERS THEN NULL; END;
            INSERT INTO prod.dct_pc_ai_extract_log (
                request_type, request_id, file_name, mime_type,
                lines_extracted, ai_model, error_message, extracted_by, extracted_at
            ) VALUES (
                p_request_type, p_request_id, p_file_name, p_mime_type,
                0, c_model, v_sqlerrm,
                SYS_CONTEXT('USERENV','SESSION_USER'), SYSTIMESTAMP
            );
            COMMIT;
            RAISE;
    END extract_from_file;

    -- ================================================================
    -- Public: validate_lines
    -- Rule 1 — (reference_number, vendor_name) not in DCT_PC_USED_REFERENCES
    --           and not duplicated within same request batch
    -- Rule 2 — expense_date within last 3 months and not in the future
    -- ================================================================
    PROCEDURE validate_lines (
        p_request_type IN VARCHAR2,
        p_request_id   IN NUMBER
    ) IS
        v_dup      NUMBER;
        v_status   VARCHAR2(20);
        v_errs     VARCHAR2(1000);
        v_valid    NUMBER := 0;
        v_total    NUMBER := 0;

        PROCEDURE check_one (
            p_line_id  IN NUMBER,
            p_ref_num  IN VARCHAR2,
            p_vendor   IN VARCHAR2,
            p_expdate  IN DATE
        ) IS
        BEGIN
            v_total  := v_total + 1;
            v_status := 'VALID';
            v_errs   := '';

            -- Rule 1a: duplicate within same batch
            IF p_ref_num IS NULL THEN
                v_errs   := v_errs || '"REF_MISSING",';
                v_status := 'NEEDS_REVIEW';
            ELSE
                IF p_request_type = 'CLEARING' THEN
                    SELECT COUNT(*) INTO v_dup FROM prod.dct_pc_clear_budget_lines
                    WHERE clearing_id = p_request_id AND line_id != p_line_id
                    AND   is_ai_extracted = 'Y'
                    AND   reference_number = p_ref_num
                    AND   NVL(vendor_name,'~~') = NVL(p_vendor,'~~');
                ELSE
                    SELECT COUNT(*) INTO v_dup FROM prod.dct_pc_reimb_budget_lines
                    WHERE reimb_id = p_request_id AND line_id != p_line_id
                    AND   is_ai_extracted = 'Y'
                    AND   reference_number = p_ref_num
                    AND   NVL(vendor_name,'~~') = NVL(p_vendor,'~~');
                END IF;

                IF v_dup > 0 THEN
                    v_errs := v_errs || '"DUPLICATE_IN_BATCH",'; v_status := 'INVALID';
                ELSE
                    -- Rule 1b: company-wide registry
                    SELECT COUNT(*) INTO v_dup FROM prod.dct_pc_used_references
                    WHERE reference_number = p_ref_num
                    AND   NVL(vendor_name,'~~') = NVL(p_vendor,'~~');
                    IF v_dup > 0 THEN
                        v_errs := v_errs || '"DUPLICATE_REF",'; v_status := 'INVALID';
                    END IF;
                END IF;
            END IF;

            -- Rule 2: expense date
            IF p_expdate IS NULL THEN
                v_errs := v_errs || '"DATE_MISSING",';
                IF v_status = 'VALID' THEN v_status := 'NEEDS_REVIEW'; END IF;
            ELSIF p_expdate < ADD_MONTHS(TRUNC(SYSDATE), -3) THEN
                v_errs := v_errs || '"DATE_TOO_OLD",'; v_status := 'INVALID';
            ELSIF p_expdate > TRUNC(SYSDATE) THEN
                v_errs := v_errs || '"DATE_FUTURE",'; v_status := 'INVALID';
            END IF;

            IF v_errs IS NOT NULL THEN
                v_errs := '[' || RTRIM(v_errs, ',') || ']';
            END IF;

            IF p_request_type = 'CLEARING' THEN
                UPDATE prod.dct_pc_clear_budget_lines
                SET validation_status = v_status, validation_errors = v_errs
                WHERE line_id = p_line_id;
            ELSE
                UPDATE prod.dct_pc_reimb_budget_lines
                SET validation_status = v_status, validation_errors = v_errs
                WHERE line_id = p_line_id;
            END IF;

            IF v_status = 'VALID' THEN v_valid := v_valid + 1; END IF;
        END check_one;

    BEGIN
        IF p_request_type = 'CLEARING' THEN
            FOR r IN (SELECT line_id, reference_number, vendor_name, expense_date
                      FROM prod.dct_pc_clear_budget_lines
                      WHERE clearing_id = p_request_id AND is_ai_extracted = 'Y') LOOP
                check_one(r.line_id, r.reference_number, r.vendor_name, r.expense_date);
            END LOOP;
            UPDATE prod.dct_pc_clearing
            SET ai_total_lines = v_total, ai_valid_lines = v_valid,
                updated_by = SYS_CONTEXT('USERENV','SESSION_USER'), updated_at = SYSTIMESTAMP
            WHERE clearing_id = p_request_id;
        ELSE
            FOR r IN (SELECT line_id, reference_number, vendor_name, expense_date
                      FROM prod.dct_pc_reimb_budget_lines
                      WHERE reimb_id = p_request_id AND is_ai_extracted = 'Y') LOOP
                check_one(r.line_id, r.reference_number, r.vendor_name, r.expense_date);
            END LOOP;
            UPDATE prod.dct_pc_reimbursements
            SET ai_total_lines = v_total, ai_valid_lines = v_valid,
                updated_by = SYS_CONTEXT('USERENV','SESSION_USER'), updated_at = SYSTIMESTAMP
            WHERE reimb_id = p_request_id;
        END IF;
        COMMIT;
    END validate_lines;

    -- ================================================================
    -- Public: delete_line
    -- ================================================================
    PROCEDURE delete_line (
        p_line_id      IN NUMBER,
        p_request_type IN VARCHAR2
    ) IS
    BEGIN
        IF p_request_type = 'CLEARING' THEN
            DELETE FROM prod.dct_pc_clear_budget_lines
            WHERE line_id = p_line_id AND is_ai_extracted = 'Y';
        ELSE
            DELETE FROM prod.dct_pc_reimb_budget_lines
            WHERE line_id = p_line_id AND is_ai_extracted = 'Y';
        END IF;
        COMMIT;
    END delete_line;

    -- ================================================================
    -- Public: register_references — called on request submit
    -- ================================================================
    PROCEDURE register_references (
        p_request_type IN VARCHAR2,
        p_request_id   IN NUMBER,
        p_employee_num IN VARCHAR2
    ) IS
    BEGIN
        IF p_request_type = 'CLEARING' THEN
            INSERT INTO prod.dct_pc_used_references
                (reference_number, vendor_name, request_type, request_id, line_id, employee_num)
            SELECT reference_number, vendor_name, 'CLEARING', clearing_id, line_id, p_employee_num
            FROM   prod.dct_pc_clear_budget_lines
            WHERE  clearing_id = p_request_id AND validation_status = 'VALID'
            AND    is_included = 'Y' AND reference_number IS NOT NULL;
        ELSE
            INSERT INTO prod.dct_pc_used_references
                (reference_number, vendor_name, request_type, request_id, line_id, employee_num)
            SELECT reference_number, vendor_name, 'REIMB', reimb_id, line_id, p_employee_num
            FROM   prod.dct_pc_reimb_budget_lines
            WHERE  reimb_id = p_request_id AND validation_status = 'VALID'
            AND    is_included = 'Y' AND reference_number IS NOT NULL;
        END IF;
        COMMIT;
    END register_references;

    -- ================================================================
    -- Public: get_lines_json
    -- ================================================================
    FUNCTION get_lines_json (
        p_request_type IN VARCHAR2,
        p_request_id   IN NUMBER
    ) RETURN CLOB IS
        v_result CLOB;
    BEGIN
        IF p_request_type = 'CLEARING' THEN
            SELECT JSON_ARRAYAGG(
                JSON_OBJECT(
                    'line_id'           VALUE line_id,
                    'line_num'          VALUE line_num,
                    'item_name'         VALUE item_name,
                    'category'          VALUE category,
                    'expense_date'      VALUE TO_CHAR(expense_date, 'YYYY-MM-DD'),
                    'amount'            VALUE amount,
                    'currency'          VALUE currency,
                    'vendor_name'       VALUE vendor_name,
                    'reference_number'  VALUE reference_number,
                    'validation_status' VALUE validation_status,
                    'validation_errors' VALUE JSON_QUERY(validation_errors, '$' NULL ON ERROR),
                    'is_included'       VALUE is_included,
                    'ai_confidence'     VALUE ai_confidence,
                    'source_file'       VALUE source_file
                    ABSENT ON NULL
                ) ORDER BY line_num
            ) INTO v_result
            FROM prod.dct_pc_clear_budget_lines
            WHERE clearing_id = p_request_id AND is_ai_extracted = 'Y';
        ELSE
            SELECT JSON_ARRAYAGG(
                JSON_OBJECT(
                    'line_id'           VALUE line_id,
                    'line_num'          VALUE line_num,
                    'item_name'         VALUE item_name,
                    'category'          VALUE category,
                    'expense_date'      VALUE TO_CHAR(expense_date, 'YYYY-MM-DD'),
                    'amount'            VALUE amount,
                    'currency'          VALUE currency,
                    'vendor_name'       VALUE vendor_name,
                    'reference_number'  VALUE reference_number,
                    'validation_status' VALUE validation_status,
                    'validation_errors' VALUE JSON_QUERY(validation_errors, '$' NULL ON ERROR),
                    'is_included'       VALUE is_included,
                    'ai_confidence'     VALUE ai_confidence,
                    'source_file'       VALUE source_file
                    ABSENT ON NULL
                ) ORDER BY line_num
            ) INTO v_result
            FROM prod.dct_pc_reimb_budget_lines
            WHERE reimb_id = p_request_id AND is_ai_extracted = 'Y';
        END IF;
        RETURN NVL(v_result, '[]');
    END get_lines_json;

END dct_pc_ai_pkg;
/

PROMPT Phase 2b complete.
