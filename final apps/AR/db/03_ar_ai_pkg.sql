-- =============================================================================
-- Accounts Receivable Module (App 206) — AI Classification & Extraction Package
-- File    : 03_ar_ai_pkg.sql
-- Schema  : PROD
-- Run     : After 01_ar_ddl.sql + 02_ar_seed.sql
-- Pattern : Cloned from DCT_PC_AI_PKG (DBMS_CLOUD.SEND_REQUEST → AI provider)
-- Provider: registry table DCT_AR_AI_PROVIDERS (07_ar_ai_providers.sql).
--           The AI_PROVIDER module setting holds the selected provider_code;
--           the row carries api_format (ANTHROPIC|GEMINI wire protocol),
--           model_id, api_key and an optional base_url override. Payload +
--           response formats are dispatched on api_format
--           (payload_begin/payload_finish/call_ai/response_json).
-- =============================================================================
-- Public API:
--   classify_file(file_id)            — AI doc-category classification
--   extract_file(file_id)             — AI extraction per category mode flags
--                                       (lines / kpis / findings / event_meta)
--   process_event(event_id, action)   — loop event files (CLASSIFY|EXTRACT|BOTH)
--   process_file(file_id)             — single-file retry (classify if needed,
--                                       then extract); same event-status flow
--   submit_process_job(event_id, action, username)
--                                     — one-off DBMS_SCHEDULER job wrapper
--   apply_alt_file_name(file_id)      — (re)generate alt name per settings
--   confirm_classification(file_id, doc_cat_id, username)
--                                     — user confirm/override; sets extraction
--                                       eligibility and alt name
-- =============================================================================

SET DEFINE OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

CREATE OR REPLACE PACKAGE prod.dct_ar_ai_pkg AS

    PROCEDURE classify_file (p_file_id IN NUMBER);

    PROCEDURE extract_file (p_file_id IN NUMBER);

    PROCEDURE process_event (
        p_event_id IN NUMBER,
        p_action   IN VARCHAR2 DEFAULT 'BOTH'   -- CLASSIFY | EXTRACT | BOTH
    );

    PROCEDURE process_file (p_file_id IN NUMBER);

    PROCEDURE submit_process_job (
        p_event_id IN NUMBER,
        p_action   IN VARCHAR2 DEFAULT 'BOTH',
        p_username IN VARCHAR2 DEFAULT NULL
    );

    PROCEDURE apply_alt_file_name (p_file_id IN NUMBER);

    PROCEDURE confirm_classification (
        p_file_id    IN NUMBER,
        p_doc_cat_id IN NUMBER,
        p_username   IN VARCHAR2 DEFAULT NULL
    );

END dct_ar_ai_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_ar_ai_pkg AS

    c_api_url     CONSTANT VARCHAR2(200) := 'https://api.anthropic.com/v1/messages';
    c_gemini_url  CONSTANT VARCHAR2(200) := 'https://generativelanguage.googleapis.com/v1beta/models/';
    c_module      CONSTANT VARCHAR2(50)  := 'ACCOUNTS_RECEIVABLE';
    c_max_tokens  CONSTANT NUMBER        := 32000;  -- BOQs can carry hundreds of items
    c_max_ai_bytes CONSTANT NUMBER       := 20 * 1024 * 1024;  -- Claude doc API limit guard
    c_max_text    CONSTANT NUMBER        := 180000;            -- content_text char cap

    -- Active provider row shape (registry DCT_AR_AI_PROVIDERS)
    TYPE t_provider IS RECORD (
        provider_code VARCHAR2(30),
        api_format    VARCHAR2(20),
        base_url      VARCHAR2(300),
        model_id      VARCHAR2(100),
        api_key       VARCHAR2(200)
    );

    -- ----------------------------------------------------------------
    -- Private: module setting reader
    -- ----------------------------------------------------------------
    FUNCTION get_setting (p_key IN VARCHAR2) RETURN VARCHAR2 IS
        v_val prod.dct_module_settings.setting_value%TYPE;
    BEGIN
        SELECT ms.setting_value
        INTO   v_val
        FROM   prod.dct_module_settings ms
        JOIN   prod.dct_modules m ON m.module_id = ms.module_id
        WHERE  m.module_code  = c_module
        AND    ms.setting_key = p_key;
        RETURN v_val;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN NULL;
    END get_setting;

    -- ----------------------------------------------------------------
    -- Private: active provider row from DCT_AR_AI_PROVIDERS.
    -- AI_PROVIDER setting = selected provider_code; falls back to the
    -- first active row when the selection is missing or inactive.
    -- ----------------------------------------------------------------
    FUNCTION get_provider_row RETURN t_provider IS
        v_code VARCHAR2(30) := UPPER(TRIM(get_setting('AI_PROVIDER')));
        v_p    t_provider;
    BEGIN
        BEGIN
            SELECT provider_code, UPPER(TRIM(api_format)), base_url, model_id, api_key
            INTO   v_p.provider_code, v_p.api_format, v_p.base_url, v_p.model_id, v_p.api_key
            FROM   prod.dct_ar_ai_providers
            WHERE  UPPER(provider_code) = v_code
            AND    is_active = 'Y';
        EXCEPTION WHEN NO_DATA_FOUND THEN
            BEGIN
                SELECT provider_code, UPPER(TRIM(api_format)), base_url, model_id, api_key
                INTO   v_p.provider_code, v_p.api_format, v_p.base_url, v_p.model_id, v_p.api_key
                FROM   prod.dct_ar_ai_providers
                WHERE  is_active = 'Y'
                ORDER  BY provider_id
                FETCH FIRST 1 ROW ONLY;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20001,
                    'No active AI provider configured for ACCOUNTS_RECEIVABLE'
                 || ' — add one in Module Settings > Manage Providers');
            END;
        END;
        RETURN v_p;
    END get_provider_row;

    -- Wire protocol of the active provider: ANTHROPIC (default) or GEMINI
    FUNCTION get_provider RETURN VARCHAR2 IS
        v_p t_provider := get_provider_row;
    BEGIN
        RETURN CASE WHEN v_p.api_format = 'GEMINI' THEN 'GEMINI' ELSE 'ANTHROPIC' END;
    END get_provider;

    -- Model for the ACTIVE provider (also what log_call records)
    FUNCTION get_model RETURN VARCHAR2 IS
        v_p t_provider := get_provider_row;
    BEGIN
        RETURN v_p.model_id;
    END get_model;

    -- ----------------------------------------------------------------
    -- Private: BLOB → base64 CLOB (23814-byte chunks: divisible by 3)
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

    PROCEDURE clob_append (p_clob IN OUT NOCOPY CLOB, p_text IN VARCHAR2) IS
    BEGIN
        IF p_text IS NOT NULL THEN
            DBMS_LOB.WRITEAPPEND(p_clob, LENGTH(p_text), p_text);
        END IF;
    END clob_append;

    -- ----------------------------------------------------------------
    -- Private: JSON-escape a CLOB into a quoted JSON string literal.
    -- (APEX_JSON.STRINGIFY has no CLOB overload — >32k raises ORA-06502.)
    -- ----------------------------------------------------------------
    FUNCTION json_escape_clob (p_in IN CLOB) RETURN CLOB IS
        v_out   CLOB;
        v_chunk VARCHAR2(32767);
        v_pos   PLS_INTEGER := 1;
        v_len   PLS_INTEGER;
        c_chunk CONSTANT PLS_INTEGER := 8000;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(v_out, TRUE);
        clob_append(v_out, '"');
        v_len := NVL(DBMS_LOB.GETLENGTH(p_in), 0);
        WHILE v_pos <= v_len LOOP
            v_chunk := DBMS_LOB.SUBSTR(p_in, c_chunk, v_pos);
            v_chunk := REPLACE(v_chunk, '\',     '\\');
            v_chunk := REPLACE(v_chunk, '"',     '\"');
            v_chunk := REPLACE(v_chunk, CHR(13), '\r');
            v_chunk := REPLACE(v_chunk, CHR(10), '\n');
            v_chunk := REPLACE(v_chunk, CHR(9),  '\t');
            v_chunk := REGEXP_REPLACE(v_chunk, '[[:cntrl:]]', ' ');
            IF v_chunk IS NOT NULL THEN
                DBMS_LOB.WRITEAPPEND(v_out, LENGTH(v_chunk), v_chunk);
            END IF;
            v_pos := v_pos + c_chunk;
        END LOOP;
        clob_append(v_out, '"');
        RETURN v_out;
    END json_escape_clob;

    -- ----------------------------------------------------------------
    -- Private: build the document content block for a file
    -- PDF / images → base64 document/image input; otherwise content_text.
    -- Raises -20003 (too large) / -20004 (no readable content).
    -- ----------------------------------------------------------------
    PROCEDURE append_content_block (
        p_payload IN OUT NOCOPY CLOB,
        p_file    IN prod.dct_ar_event_files%ROWTYPE
    ) IS
        v_b64    CLOB;
        v_text   CLOB;
        v_gemini BOOLEAN := (get_provider = 'GEMINI');
    BEGIN
        IF p_file.mime_type = 'application/pdf' THEN
            IF NVL(p_file.file_size_bytes, 0) > c_max_ai_bytes THEN
                RAISE_APPLICATION_ERROR(-20003,
                    'File too large for AI processing (' ||
                    ROUND(p_file.file_size_bytes / 1024 / 1024, 1) ||
                    ' MB > 20 MB). Split/compress the PDF or enter data manually.');
            END IF;
            v_b64 := blob_to_base64(p_file.file_blob);
            IF v_gemini THEN
                clob_append(p_payload, '{"inline_data":{"mime_type":"application/pdf","data":"');
            ELSE
                clob_append(p_payload, '{"type":"document","source":{"type":"base64"');
                clob_append(p_payload, ',"media_type":"application/pdf","data":"');
            END IF;
            DBMS_LOB.APPEND(p_payload, v_b64);
            DBMS_LOB.FREETEMPORARY(v_b64);
            clob_append(p_payload, '"}},');   -- same close for both providers

        ELSIF p_file.mime_type IN ('image/png','image/jpeg','image/gif','image/webp') THEN
            IF NVL(p_file.file_size_bytes, 0) > c_max_ai_bytes THEN
                RAISE_APPLICATION_ERROR(-20003, 'Image too large for AI processing.');
            END IF;
            v_b64 := blob_to_base64(p_file.file_blob);
            IF v_gemini THEN
                clob_append(p_payload, '{"inline_data":{"mime_type":"' || p_file.mime_type || '","data":"');
            ELSE
                clob_append(p_payload, '{"type":"image","source":{"type":"base64"');
                clob_append(p_payload, ',"media_type":"' || p_file.mime_type || '","data":"');
            END IF;
            DBMS_LOB.APPEND(p_payload, v_b64);
            DBMS_LOB.FREETEMPORARY(v_b64);
            clob_append(p_payload, '"}},');

        ELSIF p_file.content_text IS NOT NULL
              AND DBMS_LOB.GETLENGTH(p_file.content_text) > 0 THEN
            -- Client-extracted rendition (XLSX/DOCX/EML/MSG/PPTX)
            DBMS_LOB.CREATETEMPORARY(v_text, TRUE);
            IF DBMS_LOB.GETLENGTH(p_file.content_text) > c_max_text THEN
                DBMS_LOB.COPY(v_text, p_file.content_text, c_max_text, 1, 1);
            ELSE
                DBMS_LOB.COPY(v_text, p_file.content_text,
                              DBMS_LOB.GETLENGTH(p_file.content_text), 1, 1);
            END IF;
            clob_append(p_payload, CASE WHEN v_gemini THEN '{"text":'
                                        ELSE '{"type":"text","text":' END);
            DECLARE v_esc CLOB;
            BEGIN
                v_esc := json_escape_clob(v_text);
                DBMS_LOB.APPEND(p_payload, v_esc);
                DBMS_LOB.FREETEMPORARY(v_esc);
            END;
            DBMS_LOB.FREETEMPORARY(v_text);
            clob_append(p_payload, '},');
        ELSE
            RAISE_APPLICATION_ERROR(-20004,
                'No AI-readable content: file is not a PDF/image and has no extracted text rendition (' ||
                NVL(p_file.mime_type, 'unknown type') || ').');
        END IF;
    END append_content_block;

    -- ----------------------------------------------------------------
    -- Private: POST payload to Anthropic via DBMS_CLOUD
    -- ----------------------------------------------------------------
    FUNCTION call_anthropic (p_payload IN CLOB) RETURN CLOB IS
        v_resp      DBMS_CLOUD_TYPES.resp;
        v_body_blob BLOB;
        v_doffset   INTEGER := 1;
        v_soffset   INTEGER := 1;
        v_langctx   INTEGER := DBMS_LOB.DEFAULT_LANG_CTX;
        v_warning   INTEGER;
        v_prov      t_provider := get_provider_row;
        v_api_key   VARCHAR2(200) := v_prov.api_key;
        v_headers   VARCHAR2(500);
        v_status    NUMBER;
        v_response  CLOB;
    BEGIN
        IF v_api_key IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001,
                'No API key configured for AI provider ' || v_prov.provider_code
             || ' — set it in Module Settings > Manage Providers');
        END IF;

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
            uri     => NVL(v_prov.base_url, c_api_url),
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
    -- Private: POST payload to Google Gemini (generateContent) via
    -- DBMS_CLOUD. Auth = x-goog-api-key header only (free key from
    -- Google AI Studio — no username/credential object needed).
    -- ----------------------------------------------------------------
    FUNCTION call_gemini (p_payload IN CLOB) RETURN CLOB IS
        v_resp      DBMS_CLOUD_TYPES.resp;
        v_body_blob BLOB;
        v_doffset   INTEGER := 1;
        v_soffset   INTEGER := 1;
        v_langctx   INTEGER := DBMS_LOB.DEFAULT_LANG_CTX;
        v_warning   INTEGER;
        v_prov      t_provider := get_provider_row;
        v_api_key   VARCHAR2(200) := v_prov.api_key;
        v_headers   VARCHAR2(500);
        v_status    NUMBER;
        v_response  CLOB;
    BEGIN
        IF v_api_key IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001,
                'No API key configured for AI provider ' || v_prov.provider_code
             || ' — set it in Module Settings > Manage Providers'
             || ' (Gemini: free key at aistudio.google.com/apikey)');
        END IF;

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

        v_headers := '{"x-goog-api-key":"' || v_api_key || '"'
                  || ',"content-type":"application/json"}';

        v_resp := DBMS_CLOUD.SEND_REQUEST(
            uri     => NVL(v_prov.base_url, c_gemini_url) || v_prov.model_id || ':generateContent',
            method  => 'POST',
            headers => v_headers,
            body    => v_body_blob
        );
        DBMS_LOB.FREETEMPORARY(v_body_blob);

        v_status   := DBMS_CLOUD.GET_RESPONSE_STATUS_CODE(v_resp);
        v_response := DBMS_CLOUD.GET_RESPONSE_TEXT(v_resp);

        IF v_status != 200 THEN
            RAISE_APPLICATION_ERROR(-20002,
                'Gemini API error ' || v_status || ': ' || SUBSTR(v_response, 1, 500));
        END IF;

        RETURN v_response;
    EXCEPTION
        WHEN OTHERS THEN
            BEGIN DBMS_LOB.FREETEMPORARY(v_body_blob); EXCEPTION WHEN OTHERS THEN NULL; END;
            RAISE;
    END call_gemini;

    -- ----------------------------------------------------------------
    -- Private: dispatch to the active provider. One automatic retry
    -- after 30s on HTTP 429 (rate limit — common on the Gemini free
    -- tier and on busy Anthropic keys).
    -- ----------------------------------------------------------------
    FUNCTION call_ai (p_payload IN CLOB) RETURN CLOB IS
        FUNCTION dispatch RETURN CLOB IS
        BEGIN
            IF get_provider = 'GEMINI' THEN RETURN call_gemini(p_payload); END IF;
            RETURN call_anthropic(p_payload);
        END;
    BEGIN
        RETURN dispatch;
    EXCEPTION
        WHEN OTHERS THEN
            -- DBMS_CLOUD raises ORA-20429 for HTTP 429 itself; our own
            -- wrappers raise -20002 with the status in the message.
            IF SQLCODE = -20429
               OR (SQLCODE = -20002 AND INSTR(SQLERRM, 'error 429') > 0) THEN
                DBMS_SESSION.SLEEP(30);
                RETURN dispatch;
            END IF;
            RAISE;
    END call_ai;

    -- ----------------------------------------------------------------
    -- Private: provider-specific request envelope around the content
    -- blocks written by append_content_block.
    --   Anthropic: {"model","max_tokens","messages":[{role,content:[…]}]}
    --   Gemini   : {"contents":[{"parts":[…]}],"generationConfig":{…}}
    -- ----------------------------------------------------------------
    PROCEDURE payload_begin (
        p_payload    IN OUT NOCOPY CLOB,
        p_max_tokens IN NUMBER
    ) IS
    BEGIN
        IF get_provider = 'GEMINI' THEN
            clob_append(p_payload, '{"contents":[{"parts":[');
        ELSE
            clob_append(p_payload, '{"model":"' || get_model() || '"');
            clob_append(p_payload, ',"max_tokens":' || p_max_tokens);
            clob_append(p_payload, ',"messages":[{"role":"user","content":[');
        END IF;
    END payload_begin;

    PROCEDURE payload_finish (
        p_payload    IN OUT NOCOPY CLOB,
        p_prompt     IN CLOB,
        p_max_tokens IN NUMBER
    ) IS
        v_esc CLOB;
    BEGIN
        v_esc := json_escape_clob(p_prompt);
        IF get_provider = 'GEMINI' THEN
            clob_append(p_payload, '{"text":');
            DBMS_LOB.APPEND(p_payload, v_esc);
            clob_append(p_payload, '}]}],"generationConfig":{"maxOutputTokens":'
                                 || p_max_tokens || ',"temperature":0}}');
        ELSE
            clob_append(p_payload, '{"type":"text","text":');
            DBMS_LOB.APPEND(p_payload, v_esc);
            clob_append(p_payload, '}]}]}');
        END IF;
        DBMS_LOB.FREETEMPORARY(v_esc);
    END payload_finish;

    -- ----------------------------------------------------------------
    -- Private: pull the model's text out of the API response and trim
    -- to the outermost JSON value of the expected kind ('{' or '[').
    -- Anthropic: $.content[0].text
    -- Gemini   : $.candidates[0].content.parts[…].text (the answer is
    --            normally the last part; fall back to the first)
    -- ----------------------------------------------------------------
    FUNCTION response_json (p_response IN CLOB, p_open IN VARCHAR2) RETURN CLOB IS
        v_text  CLOB;
        v_out   CLOB;
        v_close VARCHAR2(1) := CASE p_open WHEN '{' THEN '}' ELSE ']' END;
        v_from  INTEGER;
        v_to    INTEGER := 0;
        v_pos   INTEGER;
        v_n     INTEGER := 1;
    BEGIN
        IF get_provider = 'GEMINI' THEN
            SELECT COALESCE(
                       JSON_VALUE(p_response, '$.candidates[0].content.parts[last].text' RETURNING CLOB),
                       JSON_VALUE(p_response, '$.candidates[0].content.parts[0].text'    RETURNING CLOB))
            INTO   v_text FROM DUAL;
        ELSE
            SELECT JSON_VALUE(p_response, '$.content[0].text' RETURNING CLOB)
            INTO   v_text FROM DUAL;
        END IF;
        IF v_text IS NULL THEN RETURN NULL; END IF;
        v_from := DBMS_LOB.INSTR(v_text, p_open);
        -- last occurrence of the closing brace/bracket
        LOOP
            v_pos := DBMS_LOB.INSTR(v_text, v_close, 1, v_n);
            EXIT WHEN NVL(v_pos, 0) = 0;
            v_to := v_pos;
            v_n  := v_n + 1;
        END LOOP;
        IF NVL(v_from, 0) = 0 OR v_to = 0 OR v_to < v_from THEN RETURN NULL; END IF;
        DBMS_LOB.CREATETEMPORARY(v_out, TRUE);
        DBMS_LOB.COPY(v_out, v_text, v_to - v_from + 1, 1, v_from);
        RETURN v_out;
    EXCEPTION WHEN OTHERS THEN RETURN NULL;
    END response_json;

    -- ----------------------------------------------------------------
    -- Private: repair a max_tokens-truncated JSON document.
    -- Cuts back to the last complete object and closes every container
    -- that is still open at that point. Trailing items are lost but the
    -- rest of the extraction is salvaged.
    -- ----------------------------------------------------------------
    FUNCTION repair_json (p_in IN CLOB) RETURN CLOB IS
        v_out     CLOB;
        v_len     PLS_INTEGER := NVL(DBMS_LOB.GETLENGTH(p_in), 0);
        v_chunk   VARCHAR2(32767);
        v_ch      VARCHAR2(1 CHAR);
        v_pos     PLS_INTEGER := 0;
        v_in_str  BOOLEAN := FALSE;
        v_esc     BOOLEAN := FALSE;
        v_stack   VARCHAR2(400) := '';          -- open brackets, deepest last
        v_cut     PLS_INTEGER := 0;             -- last safe truncation point
        v_cut_stk VARCHAR2(400) := '';          -- stack state at v_cut
        c_sz      CONSTANT PLS_INTEGER := 16000;
        v_coff    PLS_INTEGER := 1;
    BEGIN
        WHILE v_coff <= v_len LOOP
            v_chunk := DBMS_LOB.SUBSTR(p_in, c_sz, v_coff);
            FOR i IN 1 .. LENGTH(v_chunk) LOOP
                v_pos := v_pos + 1;
                v_ch  := SUBSTR(v_chunk, i, 1);
                IF v_esc THEN
                    v_esc := FALSE;
                ELSIF v_in_str THEN
                    IF v_ch = '\' THEN v_esc := TRUE;
                    ELSIF v_ch = '"' THEN v_in_str := FALSE;
                    END IF;
                ELSE
                    CASE v_ch
                        WHEN '"' THEN v_in_str := TRUE;
                        WHEN '{' THEN v_stack := v_stack || '{';
                        WHEN '[' THEN v_stack := v_stack || '[';
                        WHEN '}' THEN
                            IF SUBSTR(v_stack, -1) = '{' THEN
                                v_stack := SUBSTR(v_stack, 1, LENGTH(v_stack) - 1);
                                v_cut := v_pos; v_cut_stk := v_stack;
                            END IF;
                        WHEN ']' THEN
                            IF SUBSTR(v_stack, -1) = '[' THEN
                                v_stack := SUBSTR(v_stack, 1, LENGTH(v_stack) - 1);
                                v_cut := v_pos; v_cut_stk := v_stack;
                            END IF;
                        ELSE NULL;
                    END CASE;
                END IF;
            END LOOP;
            v_coff := v_coff + c_sz;
        END LOOP;

        IF v_cut = 0 THEN RETURN NULL; END IF;

        DBMS_LOB.CREATETEMPORARY(v_out, TRUE);
        DBMS_LOB.COPY(v_out, p_in, v_cut, 1, 1);
        FOR i IN REVERSE 1 .. NVL(LENGTH(v_cut_stk), 0) LOOP
            clob_append(v_out, CASE SUBSTR(v_cut_stk, i, 1) WHEN '{' THEN '}' ELSE ']' END);
        END LOOP;
        RETURN v_out;
    END repair_json;

    -- ----------------------------------------------------------------
    -- Private: AI audit log
    -- ----------------------------------------------------------------
    PROCEDURE log_call (
        p_file_id  IN NUMBER,
        p_action   IN VARCHAR2,
        p_response IN CLOB,
        p_lines    IN NUMBER,
        p_status   IN VARCHAR2,
        p_error    IN VARCHAR2,
        p_start_ts IN TIMESTAMP
    ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        v_model VARCHAR2(100) := get_model();
    BEGIN
        INSERT INTO prod.dct_ar_extract_log (
            file_id, action, ai_model, ai_raw_response, lines_extracted,
            status, error_message, duration_ms, extracted_by
        ) VALUES (
            p_file_id, p_action, v_model, p_response, NVL(p_lines, 0),
            p_status, SUBSTR(p_error, 1, 4000),
            ROUND(( EXTRACT(DAY    FROM (LOCALTIMESTAMP - p_start_ts)) * 86400
                  + EXTRACT(HOUR   FROM (LOCALTIMESTAMP - p_start_ts)) * 3600
                  + EXTRACT(MINUTE FROM (LOCALTIMESTAMP - p_start_ts)) * 60
                  + EXTRACT(SECOND FROM (LOCALTIMESTAMP - p_start_ts)) ) * 1000),
            SYS_CONTEXT('USERENV','SESSION_USER')
        );
        COMMIT;
    EXCEPTION WHEN OTHERS THEN ROLLBACK;
    END log_call;

    -- ----------------------------------------------------------------
    -- Private: map a category_code / raw label to a P&L category_id
    -- ----------------------------------------------------------------
    FUNCTION map_category (
        p_code      IN VARCHAR2,
        p_raw       IN VARCHAR2,
        p_line_type IN VARCHAR2
    ) RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        IF p_code IS NOT NULL THEN
            BEGIN
                SELECT category_id INTO v_id
                FROM   prod.dct_ar_pnl_categories
                WHERE  UPPER(category_code) = UPPER(TRIM(p_code))
                AND    is_active = 'Y';
                RETURN v_id;
            EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
            END;
        END IF;
        IF p_raw IS NOT NULL THEN
            BEGIN
                SELECT category_id INTO v_id
                FROM   prod.dct_ar_category_map
                WHERE  raw_text  = UPPER(TRIM(SUBSTR(p_raw, 1, 500)))
                AND    line_type = p_line_type;
                RETURN v_id;
            EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
            END;
        END IF;
        RETURN NULL;
    END map_category;

    -- ================================================================
    -- Public: apply_alt_file_name
    -- ================================================================
    PROCEDURE apply_alt_file_name (p_file_id IN NUMBER) IS
        v_enabled  VARCHAR2(10) := NVL(get_setting('ENABLE_ALT_FILE_NAME'), 'N');
        v_format   VARCHAR2(500) := NVL(get_setting('ALT_FILE_NAME_FORMAT'),
                                        '{EVENT_NAME}-{CATEGORY}-{ORIGINAL_NAME}');
        v_alt      VARCHAR2(600);
        v_event_nm VARCHAR2(300);
        v_event_cd VARCHAR2(50);
        v_cat_cd   VARCHAR2(50);
        v_orig     VARCHAR2(500);
    BEGIN
        IF v_enabled != 'Y' THEN
            UPDATE prod.dct_ar_event_files SET alt_file_name = NULL WHERE file_id = p_file_id;
            RETURN;
        END IF;

        SELECT e.event_name_en, e.event_code, dc.doc_cat_code, f.original_file_name
        INTO   v_event_nm, v_event_cd, v_cat_cd, v_orig
        FROM   prod.dct_ar_event_files f
        JOIN   prod.dct_ar_events e ON e.event_id = f.event_id
        LEFT   JOIN prod.dct_ar_doc_categories dc ON dc.doc_cat_id = f.doc_cat_id
        WHERE  f.file_id = p_file_id;

        IF v_cat_cd IS NULL THEN RETURN; END IF;  -- no confirmed category yet

        v_alt := v_format;
        v_alt := REPLACE(v_alt, '{EVENT_NAME}',    v_event_nm);
        v_alt := REPLACE(v_alt, '{EVENT_CODE}',    v_event_cd);
        v_alt := REPLACE(v_alt, '{CATEGORY}',      v_cat_cd);
        v_alt := REPLACE(v_alt, '{ORIGINAL_NAME}', v_orig);
        -- strip characters illegal in file names
        v_alt := REGEXP_REPLACE(v_alt, '[\\/:*?"<>|]', '_');

        UPDATE prod.dct_ar_event_files
        SET    alt_file_name = SUBSTR(v_alt, 1, 600)
        WHERE  file_id = p_file_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END apply_alt_file_name;

    -- ----------------------------------------------------------------
    -- Private: after a category is set, derive extraction eligibility
    -- ----------------------------------------------------------------
    PROCEDURE set_extraction_eligibility (p_file_id IN NUMBER) IS
        v_any VARCHAR2(1) := 'N';
    BEGIN
        BEGIN
            SELECT CASE WHEN dc.extract_lines = 'Y' OR dc.extract_kpis = 'Y'
                          OR dc.extract_findings = 'Y' OR dc.extract_event_meta = 'Y'
                        THEN 'Y' ELSE 'N' END
            INTO   v_any
            FROM   prod.dct_ar_event_files f
            JOIN   prod.dct_ar_doc_categories dc ON dc.doc_cat_id = f.doc_cat_id
            WHERE  f.file_id = p_file_id;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_any := 'N';
        END;

        UPDATE prod.dct_ar_event_files
        SET    extraction_status = CASE WHEN v_any = 'Y' THEN 'PENDING' ELSE 'NOT_APPLICABLE' END
        WHERE  file_id = p_file_id
        AND    extraction_status IN ('NOT_APPLICABLE', 'PENDING', 'FAILED');
    END set_extraction_eligibility;

    -- ================================================================
    -- Public: confirm_classification (user confirm / override)
    -- ================================================================
    PROCEDURE confirm_classification (
        p_file_id    IN NUMBER,
        p_doc_cat_id IN NUMBER,
        p_username   IN VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        UPDATE prod.dct_ar_event_files
        SET    doc_cat_id            = p_doc_cat_id,
               classification_status = 'CONFIRMED',
               updated_by            = NVL(p_username, SYS_CONTEXT('USERENV','SESSION_USER'))
        WHERE  file_id = p_file_id;

        set_extraction_eligibility(p_file_id);
        apply_alt_file_name(p_file_id);
        COMMIT;
    END confirm_classification;

    -- ================================================================
    -- Public: classify_file
    -- ================================================================
    PROCEDURE classify_file (p_file_id IN NUMBER) IS
        v_file      prod.dct_ar_event_files%ROWTYPE;
        v_payload   CLOB;
        v_response  CLOB;
        v_json      CLOB;
        v_prompt    CLOB;
        v_cat_code  VARCHAR2(100);
        v_conf      NUMBER;
        v_reason    VARCHAR2(1000);
        v_cat_id    NUMBER;
        v_review    VARCHAR2(10) := NVL(get_setting('REQUIRE_HUMAN_REVIEW'), 'Y');
        v_minconf   NUMBER       := NVL(TO_NUMBER(get_setting('MIN_CONFIDENCE_AUTOCONFIRM')
                                                  DEFAULT NULL ON CONVERSION ERROR), 85);
        v_start     TIMESTAMP := LOCALTIMESTAMP;
        v_err       VARCHAR2(4000);
    BEGIN
        SELECT * INTO v_file FROM prod.dct_ar_event_files WHERE file_id = p_file_id;

        -- Build prompt: active categories with code | name | description
        DBMS_LOB.CREATETEMPORARY(v_prompt, TRUE);
        clob_append(v_prompt,
            'You classify event finance documents for a government Revenue Assurance team.'
         || CHR(10) || 'File name: ' || v_file.original_file_name
         || CHR(10) || 'Classify this document into EXACTLY ONE of these categories:'
         || CHR(10));
        FOR c IN (SELECT doc_cat_code, doc_cat_name_en, description
                  FROM   prod.dct_ar_doc_categories
                  WHERE  is_active = 'Y'
                  ORDER  BY display_order) LOOP
            clob_append(v_prompt, '- ' || c.doc_cat_code || ' (' || c.doc_cat_name_en || '): '
                                || NVL(c.description, '-') || CHR(10));
        END LOOP;
        clob_append(v_prompt,
            CHR(10) || 'Return ONLY a valid JSON object — no explanation, no markdown:'
         || CHR(10) || '{"category_code": "<one code from the list>", "confidence": <0-100 integer>, "reason": "<one short sentence>"}');

        -- Build payload (provider-specific envelope)
        DBMS_LOB.CREATETEMPORARY(v_payload, TRUE);
        payload_begin(v_payload, 1024);
        append_content_block(v_payload, v_file);
        payload_finish(v_payload, v_prompt, 1024);
        DBMS_LOB.FREETEMPORARY(v_prompt);

        v_response := call_ai(v_payload);
        DBMS_LOB.FREETEMPORARY(v_payload);

        v_json := response_json(v_response, '{');
        IF v_json IS NULL THEN
            RAISE_APPLICATION_ERROR(-20005, 'AI response did not contain a JSON object');
        END IF;

        v_cat_code := JSON_VALUE(v_json, '$.category_code');
        v_conf     := NVL(TO_NUMBER(JSON_VALUE(v_json, '$.confidence')
                                    DEFAULT NULL ON CONVERSION ERROR), 0);
        v_reason   := SUBSTR(JSON_VALUE(v_json, '$.reason'), 1, 1000);

        BEGIN
            SELECT doc_cat_id INTO v_cat_id
            FROM   prod.dct_ar_doc_categories
            WHERE  UPPER(doc_cat_code) = UPPER(TRIM(v_cat_code))
            AND    is_active = 'Y';
        EXCEPTION WHEN NO_DATA_FOUND THEN
            SELECT doc_cat_id INTO v_cat_id
            FROM   prod.dct_ar_doc_categories WHERE doc_cat_code = 'OTHER';
            v_conf := LEAST(v_conf, 30);
        END;

        UPDATE prod.dct_ar_event_files
        SET    ai_doc_cat_id = v_cat_id,
               ai_confidence = v_conf,
               ai_reason     = v_reason,
               error_message = NULL,
               classification_status = CASE
                   WHEN v_review = 'N' OR v_conf >= v_minconf THEN 'CONFIRMED'
                   ELSE 'AI_CLASSIFIED'
               END,
               doc_cat_id = CASE
                   WHEN v_review = 'N' OR v_conf >= v_minconf THEN v_cat_id
                   ELSE doc_cat_id
               END
        WHERE  file_id = p_file_id;

        IF v_review = 'N' OR v_conf >= v_minconf THEN
            set_extraction_eligibility(p_file_id);
            apply_alt_file_name(p_file_id);
        END IF;

        COMMIT;
        log_call(p_file_id, 'CLASSIFY', v_response, 0, 'OK', NULL, v_start);

    EXCEPTION
        WHEN OTHERS THEN
            v_err := SUBSTR(SQLERRM, 1, 2000);
            ROLLBACK;
            UPDATE prod.dct_ar_event_files
            SET    classification_status = 'FAILED', error_message = v_err
            WHERE  file_id = p_file_id;
            COMMIT;
            log_call(p_file_id, 'CLASSIFY', v_response, 0, 'ERROR', v_err, v_start);
    END classify_file;

    -- ================================================================
    -- Public: extract_file — prompt assembled from category mode flags
    -- ================================================================
    PROCEDURE extract_file (p_file_id IN NUMBER) IS
        v_file      prod.dct_ar_event_files%ROWTYPE;
        v_cat       prod.dct_ar_doc_categories%ROWTYPE;
        v_payload   CLOB;
        v_response  CLOB;
        v_json      CLOB;
        v_prompt    CLOB;
        v_review    VARCHAR2(10) := NVL(get_setting('REQUIRE_HUMAN_REVIEW'), 'Y');
        v_def_curr  VARCHAR2(3)  := NVL(get_setting('DEFAULT_CURRENCY'), 'AED');
        v_rstatus   VARCHAR2(20);
        v_basis     VARCHAR2(20);
        v_lbasis    VARCHAR2(20);
        v_start     TIMESTAMP := LOCALTIMESTAMP;
        v_err       VARCHAR2(4000);
        v_warn      VARCHAR2(500);
        v_lines     NUMBER := 0;
        v_total     PLS_INTEGER;
        -- line fields
        v_ltype     VARCHAR2(20);
        v_item      VARCHAR2(500);
        v_ccode     VARCHAR2(100);
        v_raw       VARCHAR2(500);
        v_idate     DATE;
        v_qty       NUMBER;
        v_ucost     NUMBER;
        v_amount    NUMBER;
        v_ramount   NUMBER;
        v_curr      VARCHAR2(10);
        v_vendor    VARCHAR2(500);
        v_ref       VARCHAR2(200);
        v_comm      VARCHAR2(1000);
        v_catid     NUMBER;
        v_confd     NUMBER;
        -- kpi fields
        v_kcode     VARCHAR2(100);
        v_kname     VARCHAR2(200);
        v_kval      NUMBER;
        v_kunit     VARCHAR2(30);
        v_ktext     VARCHAR2(500);
        v_kpi_ok    NUMBER;
    BEGIN
        SELECT * INTO v_file FROM prod.dct_ar_event_files WHERE file_id = p_file_id;

        IF v_file.doc_cat_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20006, 'File has no confirmed document category');
        END IF;
        SELECT * INTO v_cat FROM prod.dct_ar_doc_categories WHERE doc_cat_id = v_file.doc_cat_id;

        IF v_cat.extract_lines = 'N' AND v_cat.extract_kpis = 'N'
           AND v_cat.extract_findings = 'N' AND v_cat.extract_event_meta = 'N' THEN
            UPDATE prod.dct_ar_event_files
            SET extraction_status = 'NOT_APPLICABLE' WHERE file_id = p_file_id;
            COMMIT;
            RETURN;
        END IF;

        v_rstatus := CASE WHEN v_review = 'N' THEN 'CONFIRMED' ELSE 'DRAFT' END;
        v_basis   := NVL(v_cat.pnl_basis, 'ACTUAL');

        -- Re-extraction replaces previous AI rows for this file (manual rows kept)
        DELETE FROM prod.dct_ar_pnl_lines
        WHERE  file_id = p_file_id AND is_ai_extracted = 'Y';
        DELETE FROM prod.dct_ar_event_kpis
        WHERE  file_id = p_file_id AND is_ai_extracted = 'Y';
        DELETE FROM prod.dct_ar_event_findings
        WHERE  file_id = p_file_id AND is_ai_extracted = 'Y';

        -- ── Build the extraction prompt ─────────────────────────────────
        DBMS_LOB.CREATETEMPORARY(v_prompt, TRUE);
        clob_append(v_prompt,
            'You are a financial document parser for event P&L analysis (document category: '
         || v_cat.doc_cat_name_en || ').'
         || CHR(10) || 'Return ONLY one valid JSON object — no explanation, no markdown. Use null for unreadable fields. Never invent data.'
         || CHR(10) || 'The JSON object must contain exactly these keys: ');
        clob_append(v_prompt,
            CASE WHEN v_cat.extract_lines      = 'Y' THEN '"lines",'      END
         || CASE WHEN v_cat.extract_kpis       = 'Y' THEN '"kpis",'       END
         || CASE WHEN v_cat.extract_findings   = 'Y' THEN '"findings",'   END
         || CASE WHEN v_cat.extract_event_meta = 'Y' THEN '"event_meta",' END);
        clob_append(v_prompt, ' (omit nothing; use empty arrays / null values when absent).' || CHR(10));

        IF v_cat.extract_lines = 'Y' THEN
            clob_append(v_prompt, CHR(10)
             || '"lines": array of ALL expense and revenue items. Each object: '
             || '{item_type: "EXPENSE"|"REVENUE", item_name, category_code (from the list below), '
             || 'raw_category (the verbatim category/section label in the document), '
             || 'item_date ("YYYY-MM-DD" or null), quantity (number or null), unit_cost (number or null), '
             || 'amount (number; deductions like VAT or fees shown in parentheses are NEGATIVE), '
             || 'reported_amount (number or null — when the document shows two figure columns such as budget vs final or organizer vs auditor, amount = the final/audited figure and reported_amount = the other), '
             || 'currency (ISO 4217, default ' || v_def_curr || '; if both AED and USD are shown use the AED figures), '
             || 'basis ("ACTUAL"|"BUDGET"|"FORECAST" — when the document mixes audited/actual figures with an estimated-budget table, label each line by its source table; default "' || v_basis || '"), '
             || 'vendor_or_payer, reference_number (PO/invoice/receipt or null), comments}.'
             || CHR(10) || 'Do not extract subtotal or grand-total rows as items.'
             || CHR(10) || 'The JSON MUST be complete and parseable. If the document contains more than ~100 detail rows, group minor items by their section so the output stays within limits.'
             || CHR(10) || 'Allowed category_code values:' || CHR(10));
            FOR c IN (SELECT category_code, category_name_en, category_type, description
                      FROM   prod.dct_ar_pnl_categories
                      WHERE  is_active = 'Y' ORDER BY display_order) LOOP
                clob_append(v_prompt, '- ' || c.category_code || ' [' || c.category_type || '] ('
                                    || c.category_name_en || '): ' || NVL(c.description, '-') || CHR(10));
            END LOOP;
        END IF;

        IF v_cat.extract_kpis = 'Y' THEN
            clob_append(v_prompt, CHR(10)
             || '"kpis": array of event performance metrics found in the document. Each object: '
             || '{kpi_code: one of TICKETS_SOLD|COMP_TICKETS|TOTAL_TICKETS_ISSUED|VISITOR_FOOTFALL|ACCREDITED_FOOTFALL|TOTAL_FOOTFALL|GROSS_REVENUE|ORGANIZER_REVENUE_SHARE|INTL_VISITATION_PCT|GUEST_SATISFACTION|SPONSORS_COUNT|VENDORS_COUNT|OTHER, '
             || 'kpi_name (free label, required when kpi_code is OTHER), kpi_value (number or null), '
             || 'kpi_unit (e.g. "AED","persons","%"), kpi_text (string value when not numeric)}.' || CHR(10));
        END IF;

        IF v_cat.extract_findings = 'Y' THEN
            clob_append(v_prompt, CHR(10)
             || '"findings": array of audit observations/review findings. Each object: '
             || '{title, observation (full text), recommendation, potential_loss_amount (number or null)}.' || CHR(10));
        END IF;

        IF v_cat.extract_event_meta = 'Y' THEN
            clob_append(v_prompt, CHR(10)
             || '"event_meta": object {organizer_name, venue, contract_number, '
             || 'start_date ("YYYY-MM-DD" or null), end_date ("YYYY-MM-DD" or null), '
             || 'dct_revenue_share_pct (number 0-100 or null), attendance (total attendance number or null)}.' || CHR(10));
        END IF;

        IF v_cat.extraction_hints IS NOT NULL THEN
            clob_append(v_prompt, CHR(10) || 'Hints for this document category: '
                                || v_cat.extraction_hints || CHR(10));
        END IF;

        -- ── Build payload & call (provider-specific envelope) ───────────
        DBMS_LOB.CREATETEMPORARY(v_payload, TRUE);
        payload_begin(v_payload, c_max_tokens);
        append_content_block(v_payload, v_file);
        payload_finish(v_payload, v_prompt, c_max_tokens);
        DBMS_LOB.FREETEMPORARY(v_prompt);

        v_response := call_ai(v_payload);
        DBMS_LOB.FREETEMPORARY(v_payload);

        v_json := response_json(v_response, '{');
        IF v_json IS NULL THEN
            RAISE_APPLICATION_ERROR(-20005, 'AI response did not contain a JSON object');
        END IF;

        BEGIN
            APEX_JSON.PARSE(v_json);
        EXCEPTION WHEN OTHERS THEN
            -- response likely truncated at max_tokens: salvage what we can
            v_json := repair_json(v_json);
            IF v_json IS NULL THEN
                RAISE_APPLICATION_ERROR(-20007, 'AI response unparseable (truncated beyond repair)');
            END IF;
            APEX_JSON.PARSE(v_json);
            v_warn := 'AI output was truncated — trailing items may be missing; consider splitting the document.';
        END;

        -- ── lines ───────────────────────────────────────────────────────
        IF v_cat.extract_lines = 'Y' THEN
            v_total := NVL(APEX_JSON.GET_COUNT('lines'), 0);
            FOR i IN 1 .. v_total LOOP
                v_ltype  := UPPER(NVL(APEX_JSON.GET_VARCHAR2('lines[%d].item_type', i), 'EXPENSE'));
                IF v_ltype NOT IN ('EXPENSE','REVENUE') THEN v_ltype := 'EXPENSE'; END IF;
                v_lbasis := UPPER(NVL(APEX_JSON.GET_VARCHAR2('lines[%d].basis', i), v_basis));
                IF v_lbasis NOT IN ('ACTUAL','BUDGET','FORECAST') THEN v_lbasis := v_basis; END IF;
                v_item   := SUBSTR(APEX_JSON.GET_VARCHAR2('lines[%d].item_name', i), 1, 500);
                v_ccode  := APEX_JSON.GET_VARCHAR2('lines[%d].category_code', i);
                v_raw    := SUBSTR(APEX_JSON.GET_VARCHAR2('lines[%d].raw_category', i), 1, 500);
                v_qty    := APEX_JSON.GET_NUMBER('lines[%d].quantity', i);
                v_ucost  := APEX_JSON.GET_NUMBER('lines[%d].unit_cost', i);
                v_amount := APEX_JSON.GET_NUMBER('lines[%d].amount', i);
                v_ramount:= APEX_JSON.GET_NUMBER('lines[%d].reported_amount', i);
                v_curr   := NVL(SUBSTR(APEX_JSON.GET_VARCHAR2('lines[%d].currency', i), 1, 3), v_def_curr);
                v_vendor := SUBSTR(APEX_JSON.GET_VARCHAR2('lines[%d].vendor_or_payer', i), 1, 500);
                v_ref    := SUBSTR(APEX_JSON.GET_VARCHAR2('lines[%d].reference_number', i), 1, 200);
                v_comm   := SUBSTR(APEX_JSON.GET_VARCHAR2('lines[%d].comments', i), 1, 1000);
                BEGIN
                    v_idate := TO_DATE(APEX_JSON.GET_VARCHAR2('lines[%d].item_date', i), 'YYYY-MM-DD');
                EXCEPTION WHEN OTHERS THEN v_idate := NULL; END;

                IF v_item IS NULL AND v_amount IS NULL THEN CONTINUE; END IF;

                -- unknown currency → fall back to default (FK safety)
                BEGIN
                    SELECT currency_code INTO v_curr
                    FROM prod.dct_currency_codes WHERE currency_code = UPPER(v_curr);
                EXCEPTION WHEN NO_DATA_FOUND THEN v_curr := v_def_curr; END;

                v_catid := map_category(v_ccode, v_raw, v_ltype);

                v_confd := 100;
                IF v_idate IS NULL          THEN v_confd := v_confd - 15; END IF;
                IF NVL(v_amount, 0) = 0     THEN v_confd := v_confd - 20; END IF;
                IF v_catid IS NULL          THEN v_confd := v_confd - 15; END IF;

                INSERT INTO prod.dct_ar_pnl_lines (
                    event_id, file_id, source_file_name, line_type, basis,
                    item_name, category_id, raw_category, item_date,
                    quantity, unit_cost, amount, reported_amount,
                    currency_code, vendor_or_payer, reference_number, comments,
                    is_ai_extracted, ai_confidence, review_status, is_included,
                    created_by
                ) VALUES (
                    v_file.event_id, p_file_id, v_file.original_file_name, v_ltype, v_lbasis,
                    NVL(v_item, NVL(v_raw, 'Unnamed item')), v_catid, v_raw, v_idate,
                    v_qty, v_ucost, NVL(v_amount, 0), v_ramount,
                    v_curr, v_vendor, v_ref, v_comm,
                    'Y', v_confd, v_rstatus, 'Y',
                    SYS_CONTEXT('USERENV','SESSION_USER')
                );
                v_lines := v_lines + 1;
            END LOOP;
        END IF;

        -- ── kpis ────────────────────────────────────────────────────────
        IF v_cat.extract_kpis = 'Y' THEN
            v_total := NVL(APEX_JSON.GET_COUNT('kpis'), 0);
            FOR i IN 1 .. v_total LOOP
                v_kcode := UPPER(NVL(APEX_JSON.GET_VARCHAR2('kpis[%d].kpi_code', i), 'OTHER'));
                v_kname := SUBSTR(APEX_JSON.GET_VARCHAR2('kpis[%d].kpi_name', i), 1, 200);
                v_kval  := APEX_JSON.GET_NUMBER('kpis[%d].kpi_value', i);
                v_kunit := SUBSTR(APEX_JSON.GET_VARCHAR2('kpis[%d].kpi_unit', i), 1, 30);
                v_ktext := SUBSTR(APEX_JSON.GET_VARCHAR2('kpis[%d].kpi_text', i), 1, 500);

                SELECT COUNT(*) INTO v_kpi_ok
                FROM   prod.dct_lookup_values lv
                JOIN   prod.dct_lookup_categories lc ON lc.category_id = lv.category_id
                WHERE  lc.category_code = 'AR_KPI_CODE' AND lv.value_code = v_kcode
                AND    lv.is_active = 'Y';
                IF v_kpi_ok = 0 THEN
                    v_kname := NVL(v_kname, v_kcode);
                    v_kcode := 'OTHER';
                END IF;

                IF v_kval IS NULL AND v_ktext IS NULL THEN CONTINUE; END IF;

                INSERT INTO prod.dct_ar_event_kpis (
                    event_id, file_id, kpi_code, kpi_name, kpi_value, kpi_unit, kpi_text,
                    is_ai_extracted, review_status, created_by
                ) VALUES (
                    v_file.event_id, p_file_id, v_kcode, v_kname, v_kval, v_kunit, v_ktext,
                    'Y', v_rstatus, SYS_CONTEXT('USERENV','SESSION_USER')
                );
            END LOOP;
        END IF;

        -- ── findings ────────────────────────────────────────────────────
        IF v_cat.extract_findings = 'Y' THEN
            v_total := NVL(APEX_JSON.GET_COUNT('findings'), 0);
            FOR i IN 1 .. v_total LOOP
                v_item := SUBSTR(APEX_JSON.GET_VARCHAR2('findings[%d].title', i), 1, 500);
                IF v_item IS NULL THEN CONTINUE; END IF;
                INSERT INTO prod.dct_ar_event_findings (
                    event_id, file_id, finding_seq, title, observation,
                    recommendation, potential_loss_amount,
                    is_ai_extracted, review_status, created_by
                ) VALUES (
                    v_file.event_id, p_file_id, i, v_item,
                    SUBSTR(APEX_JSON.GET_VARCHAR2('findings[%d].observation', i), 1, 4000),
                    SUBSTR(APEX_JSON.GET_VARCHAR2('findings[%d].recommendation', i), 1, 2000),
                    APEX_JSON.GET_NUMBER('findings[%d].potential_loss_amount', i),
                    'Y', v_rstatus, SYS_CONTEXT('USERENV','SESSION_USER')
                );
            END LOOP;
        END IF;

        -- ── event_meta: prefill EMPTY event header fields only ──────────
        IF v_cat.extract_event_meta = 'Y' THEN
            DECLARE
                v_org   VARCHAR2(300) := SUBSTR(APEX_JSON.GET_VARCHAR2('event_meta.organizer_name'), 1, 300);
                v_ven   VARCHAR2(300) := SUBSTR(APEX_JSON.GET_VARCHAR2('event_meta.venue'), 1, 300);
                v_cno   VARCHAR2(100) := SUBSTR(APEX_JSON.GET_VARCHAR2('event_meta.contract_number'), 1, 100);
                v_pct   NUMBER        := APEX_JSON.GET_NUMBER('event_meta.dct_revenue_share_pct');
                v_att   NUMBER        := APEX_JSON.GET_NUMBER('event_meta.attendance');
                v_sd    DATE; v_ed DATE;
            BEGIN
                BEGIN v_sd := TO_DATE(APEX_JSON.GET_VARCHAR2('event_meta.start_date'), 'YYYY-MM-DD');
                EXCEPTION WHEN OTHERS THEN v_sd := NULL; END;
                BEGIN v_ed := TO_DATE(APEX_JSON.GET_VARCHAR2('event_meta.end_date'), 'YYYY-MM-DD');
                EXCEPTION WHEN OTHERS THEN v_ed := NULL; END;

                UPDATE prod.dct_ar_events
                SET    organizer_name        = NVL(organizer_name, v_org),
                       venue                 = NVL(venue, v_ven),
                       contract_number       = NVL(contract_number, v_cno),
                       start_date            = NVL(start_date, v_sd),
                       end_date              = NVL(end_date, v_ed),
                       dct_revenue_share_pct = NVL(dct_revenue_share_pct,
                                                   CASE WHEN v_pct BETWEEN 0 AND 100 THEN v_pct END),
                       actual_attendance     = NVL(actual_attendance, v_att)
                WHERE  event_id = v_file.event_id;
            END;
        END IF;

        UPDATE prod.dct_ar_event_files
        SET    extraction_status = CASE WHEN v_review = 'N' THEN 'CONFIRMED' ELSE 'EXTRACTED' END,
               lines_extracted   = v_lines,
               error_message     = v_warn
        WHERE  file_id = p_file_id;

        COMMIT;
        log_call(p_file_id, 'EXTRACT', v_response, v_lines,
                 CASE WHEN v_warn IS NULL THEN 'OK' ELSE 'OK_TRUNCATED' END, v_warn, v_start);

    EXCEPTION
        WHEN OTHERS THEN
            v_err := SUBSTR(SQLERRM, 1, 2000);
            ROLLBACK;
            UPDATE prod.dct_ar_event_files
            SET    extraction_status = 'FAILED', error_message = v_err
            WHERE  file_id = p_file_id;
            COMMIT;
            log_call(p_file_id, 'EXTRACT', v_response, 0, 'ERROR', v_err, v_start);
    END extract_file;

    -- ================================================================
    -- Public: process_event — loop pending files
    -- ================================================================
    PROCEDURE process_event (
        p_event_id IN NUMBER,
        p_action   IN VARCHAR2 DEFAULT 'BOTH'
    ) IS
        v_old_status VARCHAR2(30);
        v_owner      NUMBER;
        v_code       VARCHAR2(50);
        v_review     VARCHAR2(10) := NVL(get_setting('REQUIRE_HUMAN_REVIEW'), 'Y');
        v_new_status VARCHAR2(30);
        v_fail       NUMBER := 0;
        v_done       NUMBER := 0;
    BEGIN
        SELECT status, owner_user_id, event_code
        INTO   v_old_status, v_owner, v_code
        FROM   prod.dct_ar_events WHERE event_id = p_event_id;

        UPDATE prod.dct_ar_events SET status = 'AI_PROCESSING' WHERE event_id = p_event_id;
        BEGIN
            INSERT INTO prod.dct_request_status_history
                (source_module, source_type, source_id, old_status, new_status, changed_by, comments)
            VALUES ('AR', 'EVENT', p_event_id, v_old_status, 'AI_PROCESSING', v_owner,
                    'AI processing started (' || p_action || ')');
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
        COMMIT;

        IF p_action IN ('CLASSIFY', 'BOTH') THEN
            FOR f IN (SELECT file_id FROM prod.dct_ar_event_files
                      WHERE event_id = p_event_id AND is_active = 'Y'
                      AND   classification_status IN ('PENDING', 'FAILED')
                      ORDER BY file_id) LOOP
                classify_file(f.file_id);   -- own commit + failure capture
            END LOOP;
        END IF;

        IF p_action IN ('EXTRACT', 'BOTH') THEN
            FOR f IN (SELECT file_id FROM prod.dct_ar_event_files
                      WHERE event_id = p_event_id AND is_active = 'Y'
                      AND   classification_status = 'CONFIRMED'
                      AND   extraction_status IN ('PENDING', 'FAILED')
                      ORDER BY file_id) LOOP
                extract_file(f.file_id);
            END LOOP;
        END IF;

        SELECT SUM(CASE WHEN classification_status = 'FAILED'
                          OR extraction_status     = 'FAILED' THEN 1 ELSE 0 END),
               COUNT(*)
        INTO   v_fail, v_done
        FROM   prod.dct_ar_event_files
        WHERE  event_id = p_event_id AND is_active = 'Y';

        v_new_status := CASE WHEN v_review = 'N' THEN 'CONFIRMED' ELSE 'UNDER_REVIEW' END;

        UPDATE prod.dct_ar_events SET status = v_new_status WHERE event_id = p_event_id;
        BEGIN
            INSERT INTO prod.dct_request_status_history
                (source_module, source_type, source_id, old_status, new_status, changed_by, comments)
            VALUES ('AR', 'EVENT', p_event_id, 'AI_PROCESSING', v_new_status, v_owner,
                    'AI processing finished: ' || v_done || ' file(s), ' || NVL(v_fail,0) || ' failed');
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
        COMMIT;

        IF v_owner IS NOT NULL THEN
            BEGIN
                prod.dct_notify.send(
                    p_recipient_user_id => v_owner,
                    p_notification_type => 'AR_AI_DONE',
                    p_title_en          => 'AI processing finished for event ' || v_code,
                    p_body_en           => v_done || ' file(s) processed, ' || NVL(v_fail, 0)
                                           || ' failed. ' ||
                                           CASE WHEN v_review = 'Y'
                                                THEN 'Results are ready for review.'
                                                ELSE 'Results were auto-confirmed.' END,
                    p_module_code       => c_module
                );
            EXCEPTION WHEN OTHERS THEN NULL;
            END;
        END IF;
    END process_event;

    -- ================================================================
    -- Public: process_file — single-file retry (per-file Retry button).
    -- Classifies if still PENDING/FAILED, then extracts if eligible;
    -- keeps the same event-status flow so the UI progress poll works.
    -- ================================================================
    PROCEDURE process_file (p_file_id IN NUMBER) IS
        v_event_id   NUMBER;
        v_old_status VARCHAR2(30);
        v_owner      NUMBER;
        v_review     VARCHAR2(10) := NVL(get_setting('REQUIRE_HUMAN_REVIEW'), 'Y');
        v_class      VARCHAR2(30);
        v_extract    VARCHAR2(30);
        v_cat_id     NUMBER;
        v_new_status VARCHAR2(30);
    BEGIN
        SELECT f.event_id, e.status, e.owner_user_id
        INTO   v_event_id, v_old_status, v_owner
        FROM   prod.dct_ar_event_files f
        JOIN   prod.dct_ar_events e ON e.event_id = f.event_id
        WHERE  f.file_id = p_file_id;

        UPDATE prod.dct_ar_events SET status = 'AI_PROCESSING'
        WHERE  event_id = v_event_id;
        BEGIN
            INSERT INTO prod.dct_request_status_history
                (source_module, source_type, source_id, old_status, new_status, changed_by, comments)
            VALUES ('AR', 'EVENT', v_event_id, v_old_status, 'AI_PROCESSING', v_owner,
                    'Single-file AI retry (file_id ' || p_file_id || ')');
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
        COMMIT;

        SELECT classification_status INTO v_class
        FROM   prod.dct_ar_event_files WHERE file_id = p_file_id;
        IF v_class IN ('PENDING', 'FAILED') THEN
            classify_file(p_file_id);   -- own commit + failure capture
        END IF;

        SELECT classification_status, extraction_status, doc_cat_id
        INTO   v_class, v_extract, v_cat_id
        FROM   prod.dct_ar_event_files WHERE file_id = p_file_id;
        IF v_class = 'CONFIRMED' AND v_cat_id IS NOT NULL
           AND v_extract IN ('PENDING', 'FAILED') THEN
            extract_file(p_file_id);
        END IF;

        v_new_status := CASE WHEN v_review = 'N' THEN 'CONFIRMED' ELSE 'UNDER_REVIEW' END;
        UPDATE prod.dct_ar_events SET status = v_new_status
        WHERE  event_id = v_event_id;
        BEGIN
            INSERT INTO prod.dct_request_status_history
                (source_module, source_type, source_id, old_status, new_status, changed_by, comments)
            VALUES ('AR', 'EVENT', v_event_id, 'AI_PROCESSING', v_new_status, v_owner,
                    'Single-file AI retry finished (file_id ' || p_file_id || ')');
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
        COMMIT;
    END process_file;

    -- ================================================================
    -- Public: submit_process_job — fire-and-forget scheduler job
    -- ================================================================
    PROCEDURE submit_process_job (
        p_event_id IN NUMBER,
        p_action   IN VARCHAR2 DEFAULT 'BOTH',
        p_username IN VARCHAR2 DEFAULT NULL
    ) IS
        v_job VARCHAR2(100);
        v_act VARCHAR2(10) := UPPER(NVL(p_action, 'BOTH'));
    BEGIN
        IF v_act NOT IN ('CLASSIFY', 'EXTRACT', 'BOTH') THEN v_act := 'BOTH'; END IF;
        v_job := 'AR_PROC_' || p_event_id || '_' ||
                 TO_CHAR(SYSTIMESTAMP, 'HH24MISSFF3');
        DBMS_SCHEDULER.CREATE_JOB(
            job_name   => v_job,
            job_type   => 'PLSQL_BLOCK',
            job_action => 'BEGIN prod.dct_ar_ai_pkg.process_event(' || p_event_id ||
                          ', ''' || v_act || '''); END;',
            start_date => SYSTIMESTAMP,
            enabled    => TRUE,
            auto_drop  => TRUE,
            comments   => 'AR AI processing for event ' || p_event_id ||
                          ' requested by ' || NVL(p_username, 'system')
        );
    END submit_process_job;

END dct_ar_ai_pkg;
/

SHOW ERRORS PACKAGE BODY prod.dct_ar_ai_pkg

PROMPT === AR AI package complete ===
