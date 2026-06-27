-- =============================================================================
-- Freelancers Module (App 203) -- Phase 1 -- AI Document Extraction
-- File    : 12_fl_ai_pkg.sql
-- Schema  : PROD
-- Run     : After 11_fl_reg_phase1_ddl.sql. Own SQLcl session.
-- Purpose : DCT_FL_AI_PKG -- vision extraction of Passport / Emirates ID /
--           Bank Letter via Anthropic (DBMS_CLOUD). Reuses the AR ANTHROPIC
--           provider key (prod.dct_ar_ai_providers). Model from FL setting
--           AI_MODEL (default claude-sonnet-4-6). Gated by AI_FEATURES_ENABLED.
--           Writes an audit row to DCT_FL_DOC_EXTRACTS and returns a suggested
--           field map {fields, confidence, warnings}. Never auto-commits the
--           applicant's data -- the caller reviews and applies.
--           Professional checks: UAE IBAN mod-97, Emirates ID Luhn, auto-expiry
--           capture into DCT_DOCUMENTS, cross-document name consistency.
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON

-- DBMS_CLOUD must be granted directly to PROD (definer-rights packages ignore
-- role grants). Without this, every *_AI_PKG body compiles INVALID (PLS-00201).
BEGIN
    EXECUTE IMMEDIATE 'GRANT EXECUTE ON DBMS_CLOUD TO PROD';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- Network ACL for the AI hosts (idempotent; Anthropic already granted for AR/TM/ATD,
-- Gemini host added for the configurable provider switch).
BEGIN
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => 'api.anthropic.com',
        ace  => xs$ace_type(
                  privilege_list => xs$name_list('connect','resolve'),
                  principal_name => 'PROD',
                  principal_type => xs_acl.ptype_db));
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => 'generativelanguage.googleapis.com',
        ace  => xs$ace_type(
                  privilege_list => xs$name_list('connect','resolve'),
                  principal_name => 'PROD',
                  principal_type => xs_acl.ptype_db));
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

CREATE OR REPLACE PACKAGE prod.dct_fl_ai_pkg AS
    -- Run AI extraction on one uploaded registration document.
    -- Returns a JSON envelope: {"docType","fields":{...},"confidence",
    -- "warnings":[...],"extractId"}. Raises -20001 when AI is disabled,
    -- -20004 when the document has no readable bytes, -20002 on API error.
    FUNCTION extract_document (
        p_registration_id IN NUMBER,
        p_doc_id          IN NUMBER,
        p_user_id         IN NUMBER DEFAULT NULL
    ) RETURN CLOB;
END dct_fl_ai_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_fl_ai_pkg AS

    c_api_url   CONSTANT VARCHAR2(100) := 'https://api.anthropic.com/v1/messages';
    c_max_bytes CONSTANT NUMBER        := 20 * 1024 * 1024;   -- Anthropic vision cap

    -- Which provider/model actually served the last call_ai (may differ from the
    -- configured one when the Gemini->Claude auto-fallback fires). Read by
    -- extract_document for the audit row + envelope note.
    g_used_provider VARCHAR2(40);
    g_used_model    VARCHAR2(200);
    g_fellback      BOOLEAN := FALSE;

    -- ------------------------------------------------------------------ helpers
    -- Active provider = AI_PROVIDER setting (ANTHROPIC | GEMINI), resolved against
    -- the shared dct_ar_ai_providers registry. Switch providers from Admin >
    -- Freelancers > Module Settings (AI_PROVIDER) -- no code change needed.
    FUNCTION active_code RETURN VARCHAR2 IS
    BEGIN
        RETURN UPPER(NVL(prod.dct_fl_pkg.get_setting('AI_PROVIDER'), 'ANTHROPIC'));
    END active_code;

    PROCEDURE get_provider (o_format OUT VARCHAR2, o_base OUT VARCHAR2,
                            o_model OUT VARCHAR2, o_key OUT VARCHAR2) IS
        v_code VARCHAR2(40) := active_code;   -- local: pkg fn not usable in SQL
    BEGIN
        SELECT api_format, base_url, model_id, api_key
        INTO   o_format, o_base, o_model, o_key
        FROM   prod.dct_ar_ai_providers
        WHERE  UPPER(provider_code) = v_code AND is_active = 'Y'
        FETCH FIRST 1 ROW ONLY;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        BEGIN
            SELECT api_format, base_url, model_id, api_key
            INTO   o_format, o_base, o_model, o_key
            FROM   prod.dct_ar_ai_providers
            WHERE  is_active = 'Y'
            FETCH FIRST 1 ROW ONLY;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            o_format := NULL; o_base := NULL; o_model := NULL; o_key := NULL;
        END;
    END get_provider;

    -- Fetch a SPECIFIC provider row by code (used by the Gemini->Claude fallback).
    PROCEDURE get_provider_by (p_code IN VARCHAR2, o_format OUT VARCHAR2,
                               o_base OUT VARCHAR2, o_model OUT VARCHAR2, o_key OUT VARCHAR2) IS
    BEGIN
        SELECT api_format, base_url, model_id, api_key
        INTO   o_format, o_base, o_model, o_key
        FROM   prod.dct_ar_ai_providers
        WHERE  UPPER(provider_code) = UPPER(p_code) AND is_active = 'Y'
        FETCH FIRST 1 ROW ONLY;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        o_format := NULL; o_base := NULL; o_model := NULL; o_key := NULL;
    END get_provider_by;

    -- Model = the AI_MODEL setting when it is compatible with the active provider
    -- (gemini* with GEMINI, claude* with ANTHROPIC); otherwise the provider row's
    -- model_id. The compatibility guard prevents a cross-provider mismatch when
    -- the user flips AI_PROVIDER without changing AI_MODEL.
    FUNCTION get_model RETURN VARCHAR2 IS
        f VARCHAR2(40); b VARCHAR2(400); m VARCHAR2(200); k VARCHAR2(400);
        s VARCHAR2(200) := TRIM(prod.dct_fl_pkg.get_setting('AI_MODEL'));
    BEGIN
        get_provider(f, b, m, k);
        f := UPPER(NVL(f, 'ANTHROPIC'));
        IF s IS NOT NULL THEN
            IF (f = 'GEMINI'    AND LOWER(s) LIKE 'gemini%')
            OR (f = 'ANTHROPIC' AND LOWER(s) LIKE 'claude%') THEN
                RETURN s;
            END IF;
        END IF;
        RETURN NVL(m, 'claude-sonnet-4-6');
    END get_model;

    FUNCTION get_max_tokens RETURN NUMBER IS
    BEGIN
        RETURN NVL(TO_NUMBER(prod.dct_fl_pkg.get_setting('AI_MAX_TOKENS')
                             DEFAULT NULL ON CONVERSION ERROR), 1500);
    END get_max_tokens;

    PROCEDURE clob_append (p_clob IN OUT NOCOPY CLOB, p_text IN VARCHAR2) IS
    BEGIN
        IF p_text IS NOT NULL THEN
            DBMS_LOB.WRITEAPPEND(p_clob, LENGTH(p_text), p_text);
        END IF;
    END clob_append;

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

    -- Per-document-type instruction. Always asks for STRICT JSON only.
    FUNCTION prompt_for (p_code IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        -- Every prompt also asks for document_kind = what the document ACTUALLY is
        -- (PASSPORT | EMIRATES_ID | BANK_LETTER | OTHER), regardless of what was
        -- requested, so the caller can detect a wrong file uploaded into a slot.
        IF p_code = 'PASSPORT' THEN
            RETURN 'You are a passport data extractor. Read the attached passport '
                || 'and return STRICT JSON only (no prose, no markdown) with keys: '
                || 'surname, given_names, passport_number, nationality (ISO-3166 alpha-3 '
                || 'if visible else as printed), date_of_birth (YYYY-MM-DD), sex (M/F), '
                || 'expiry_date (YYYY-MM-DD), mrz (the two MRZ lines joined by a newline), '
                || 'document_kind (one of PASSPORT, EMIRATES_ID, BANK_LETTER, OTHER -- '
                || 'classify what this document ACTUALLY is, even if it is not a passport), '
                || 'confidence (0.0-1.0 overall). Use null for any field you cannot read.';
        ELSIF p_code IN ('EMIRATES_ID','NATIONAL_ID') THEN
            RETURN 'You are an Emirates ID extractor. Read the attached Emirates ID '
                || '(both sides if present) and return STRICT JSON only with keys: '
                || 'name_en, name_ar, emirates_id (the 784-XXXX-XXXXXXX-X number, digits '
                || 'with or without dashes), nationality, date_of_birth (YYYY-MM-DD), '
                || 'sex (M/F), card_expiry (YYYY-MM-DD), '
                || 'document_kind (one of PASSPORT, EMIRATES_ID, BANK_LETTER, OTHER -- '
                || 'classify what this document ACTUALLY is, even if it is not an Emirates ID), '
                || 'confidence (0.0-1.0). Use null for any field you cannot read.';
        ELSIF p_code IN ('BANK_LETTER','BANK') THEN
            RETURN 'You are a bank letter / IBAN certificate extractor. Read the attached '
                || 'document and return STRICT JSON only with keys: account_holder_name, '
                || 'bank_name, iban (no spaces), account_number, swift, currency '
                || '(ISO-4217 code), '
                || 'document_kind (one of PASSPORT, EMIRATES_ID, BANK_LETTER, OTHER -- '
                || 'classify what this document ACTUALLY is, even if it is not a bank letter), '
                || 'confidence (0.0-1.0). Use null for fields you cannot read.';
        ELSE
            RETURN 'Read the attached identity/financial document and return STRICT JSON '
                || 'only with the key/value pairs you can confidently read, plus a '
                || 'document_kind (one of PASSPORT, EMIRATES_ID, BANK_LETTER, OTHER) and a '
                || 'confidence (0.0-1.0) key. Use null for anything unreadable.';
        END IF;
    END prompt_for;

    -- POST a vision payload (document/image base64 + text) to the active provider
    -- (Anthropic messages API or Google Gemini generateContent). Returns the
    -- model's text (expected to be the STRICT-JSON answer).
    FUNCTION call_ai (
        p_blob   IN BLOB,
        p_mime   IN VARCHAR2,
        p_prompt IN VARCHAR2,
        p_raw    OUT CLOB
    ) RETURN CLOB IS
        v_b64       CLOB;
        v_mt        VARCHAR2(100);
        v_is_pdf    BOOLEAN := (p_mime = 'application/pdf');
        v_format    VARCHAR2(40);
        v_base      VARCHAR2(400);
        v_model     VARCHAR2(200);
        v_key       VARCHAR2(400);
        v_res       CLOB;
        v_fb        BOOLEAN := NVL(prod.dct_fl_pkg.get_setting('AI_FALLBACK_CLAUDE'),'Y') = 'Y';
        f2 VARCHAR2(40); b2 VARCHAR2(400); m2 VARCHAR2(200); k2 VARCHAR2(400);

        -- Build the provider-specific vision payload (Anthropic messages API or
        -- Google Gemini generateContent), POST it with backoff retries, and return
        -- the model's text answer. RAISES -20002 on any non-200 / quota / network
        -- failure (DBMS_CLOUD surfaces the HTTP code in the message). Reads the
        -- shared base64 (v_b64) / mime (v_mt) / prompt from the enclosing scope.
        FUNCTION do_call (p_format IN VARCHAR2, p_base IN VARCHAR2,
                          p_model IN VARCHAR2, p_key IN VARCHAR2) RETURN CLOB IS
            v_payload   CLOB;
            v_body_blob BLOB;
            v_doff      INTEGER := 1;
            v_soff      INTEGER := 1;
            v_lang      INTEGER := DBMS_LOB.DEFAULT_LANG_CTX;
            v_warn      INTEGER;
            v_resp      DBMS_CLOUD_TYPES.resp;
            v_status    NUMBER := 0;
            v_errm      VARCHAR2(600);
            v_url       VARCHAR2(600);
            v_headers   VARCHAR2(1000);
        BEGIN
            DBMS_LOB.CREATETEMPORARY(v_payload, TRUE);
            IF p_format = 'GEMINI' THEN
                clob_append(v_payload,
                    '{"contents":[{"parts":[{"inline_data":{"mime_type":"'||v_mt||'","data":"');
                DBMS_LOB.APPEND(v_payload, v_b64);
                clob_append(v_payload, '"}},{"text":' || APEX_JSON.STRINGIFY(p_prompt)
                    || '}]}],"generationConfig":{"maxOutputTokens":' || get_max_tokens
                    || ',"temperature":0,"response_mime_type":"application/json"}}');
                v_url := NVL(p_base, 'https://generativelanguage.googleapis.com/v1beta/models/')
                         || p_model || ':generateContent';
                v_headers := '{"content-type":"application/json","x-goog-api-key":"'||p_key||'"}';
            ELSE   -- ANTHROPIC
                clob_append(v_payload, '{"model":"'||p_model||'","max_tokens":'||get_max_tokens
                    ||',"messages":[{"role":"user","content":[');
                IF v_is_pdf THEN
                    clob_append(v_payload, '{"type":"document","source":{"type":"base64","media_type":"application/pdf","data":"');
                ELSE
                    clob_append(v_payload, '{"type":"image","source":{"type":"base64","media_type":"'||v_mt||'","data":"');
                END IF;
                DBMS_LOB.APPEND(v_payload, v_b64);
                clob_append(v_payload, '"}},');
                clob_append(v_payload, '{"type":"text","text":'||APEX_JSON.STRINGIFY(p_prompt)||'}]}]}');
                v_url := NVL(p_base, 'https://api.anthropic.com/v1/messages');
                v_headers := '{"anthropic-version":"2023-06-01","x-api-key":"'||p_key||'","content-type":"application/json"}';
            END IF;

            DBMS_LOB.CREATETEMPORARY(v_body_blob, TRUE);
            DBMS_LOB.CONVERTTOBLOB(v_body_blob, v_payload,
                DBMS_LOB.GETLENGTH(v_payload), v_doff, v_soff,
                NLS_CHARSET_ID('AL32UTF8'), v_lang, v_warn);
            DBMS_LOB.FREETEMPORARY(v_payload);

            FOR v_try IN 1 .. 4 LOOP
                BEGIN
                    v_resp   := DBMS_CLOUD.SEND_REQUEST(uri=>v_url, method=>'POST',
                                  headers=>v_headers, body=>v_body_blob);
                    v_status := DBMS_CLOUD.GET_RESPONSE_STATUS_CODE(v_resp);
                    p_raw    := DBMS_CLOUD.GET_RESPONSE_TEXT(v_resp);
                    EXIT WHEN v_status = 200;
                    IF v_status IN (429, 500, 502, 503, 529) AND v_try < 4 THEN
                        DBMS_SESSION.SLEEP(v_try * 3);
                    ELSE
                        EXIT;
                    END IF;
                EXCEPTION WHEN OTHERS THEN
                    -- Only 429/5xx are transient; a 4xx (bad model/key/request)
                    -- never recovers by retrying.
                    v_errm := SQLERRM;
                    IF v_try < 4 AND (v_errm LIKE '%HTTP 429%' OR v_errm LIKE '%HTTP 500%'
                           OR v_errm LIKE '%HTTP 502%' OR v_errm LIKE '%HTTP 503%'
                           OR v_errm LIKE '%HTTP 529%') THEN
                        DBMS_SESSION.SLEEP(v_try * 3);
                    ELSE
                        DBMS_LOB.FREETEMPORARY(v_body_blob);
                        RAISE_APPLICATION_ERROR(-20002,
                            'AI provider (' || p_format || ', model ' || p_model
                            || ') request failed: ' || SUBSTR(v_errm, 1, 220));
                    END IF;
                END;
            END LOOP;
            DBMS_LOB.FREETEMPORARY(v_body_blob);

            IF v_status != 200 THEN
                RAISE_APPLICATION_ERROR(-20002,
                    'AI provider (' || p_format || ', model ' || p_model || ') HTTP '
                    || v_status || ': ' || SUBSTR(p_raw, 1, 200));
            END IF;

            -- JSON_VALUE must read a local CLOB, not the OUT param, in PL/SQL context.
            DECLARE v_loc CLOB := p_raw;
            BEGIN
                IF p_format = 'GEMINI' THEN
                    RETURN JSON_VALUE(v_loc, '$.candidates[0].content.parts[0].text' RETURNING CLOB);
                ELSE
                    RETURN JSON_VALUE(v_loc, '$.content[0].text' RETURNING CLOB);
                END IF;
            END;
        END do_call;
    BEGIN
        get_provider(v_format, v_base, v_model, v_key);
        v_format := UPPER(NVL(v_format, 'ANTHROPIC'));
        v_model  := get_model;   -- honour the AI_MODEL setting (provider-compatible)
        IF v_key IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001,
                'No API key configured for AI provider ' || active_code
                || ' (Admin > AR > Manage Providers).');
        END IF;
        IF NVL(DBMS_LOB.GETLENGTH(p_blob),0) > c_max_bytes THEN
            RAISE_APPLICATION_ERROR(-20003,
                'Document too large for AI processing (max 20 MB). Upload a smaller scan.');
        END IF;

        v_mt  := CASE WHEN v_is_pdf THEN 'application/pdf' ELSE NVL(p_mime,'image/jpeg') END;
        v_b64 := blob_to_base64(p_blob);

        g_used_provider := v_format;
        g_used_model    := v_model;
        g_fellback      := FALSE;
        BEGIN
            v_res := do_call(v_format, v_base, v_model, v_key);
        EXCEPTION WHEN OTHERS THEN
            -- AUTOMATIC FALLBACK: if the active provider is GEMINI and it failed
            -- (free-tier 429 / throttle / outage), transparently re-run the SAME
            -- document through Claude so extraction stays reliable. Gated by the
            -- AI_FALLBACK_CLAUDE setting (default Y) and an Anthropic key existing.
            IF v_format = 'GEMINI' AND v_fb THEN
                get_provider_by('ANTHROPIC', f2, b2, m2, k2);
                IF k2 IS NOT NULL THEN
                    g_used_provider := 'ANTHROPIC';
                    g_used_model    := NVL(m2, 'claude-sonnet-4-6');
                    g_fellback      := TRUE;
                    BEGIN
                        v_res := do_call('ANTHROPIC', b2, g_used_model, k2);
                    EXCEPTION WHEN OTHERS THEN
                        DBMS_LOB.FREETEMPORARY(v_b64); RAISE;
                    END;
                ELSE
                    DBMS_LOB.FREETEMPORARY(v_b64); RAISE;
                END IF;
            ELSE
                DBMS_LOB.FREETEMPORARY(v_b64); RAISE;
            END IF;
        END;
        DBMS_LOB.FREETEMPORARY(v_b64);
        RETURN v_res;
    END call_ai;

    -- Trim model output to the outermost { } object.
    FUNCTION json_only (p_in IN CLOB) RETURN CLOB IS
        v_s NUMBER;
        v_e NUMBER;
    BEGIN
        IF p_in IS NULL THEN RETURN NULL; END IF;
        v_s := INSTR(p_in, '{');
        v_e := INSTR(p_in, '}', -1);
        IF v_s > 0 AND v_e > v_s THEN
            RETURN DBMS_LOB.SUBSTR(p_in, v_e - v_s + 1, v_s);
        END IF;
        RETURN p_in;
    END json_only;

    FUNCTION norm_name (p_in IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN REGEXP_REPLACE(UPPER(NVL(p_in,' ')), '[^A-Z]', '');
    END norm_name;

    -- UAE IBAN mod-97 check (returns TRUE when valid).
    FUNCTION iban_ok (p_iban IN VARCHAR2) RETURN BOOLEAN IS
        v   VARCHAR2(40) := UPPER(REGEXP_REPLACE(NVL(p_iban,''), '[^A-Z0-9]', ''));
        v_r VARCHAR2(80);
        v_c CHAR(1);
        v_mod NUMBER := 0;
    BEGIN
        IF v IS NULL OR LENGTH(v) < 15 OR LENGTH(v) > 34 THEN RETURN FALSE; END IF;
        v := SUBSTR(v, 5) || SUBSTR(v, 1, 4);             -- move first 4 to end
        FOR i IN 1 .. LENGTH(v) LOOP
            v_c := SUBSTR(v, i, 1);
            IF v_c BETWEEN 'A' AND 'Z' THEN
                v_r := v_r || TO_CHAR(ASCII(v_c) - 55);    -- A=10 .. Z=35
            ELSE
                v_r := v_r || v_c;
            END IF;
        END LOOP;
        -- piecewise mod-97 to avoid overflow
        FOR i IN 1 .. LENGTH(v_r) LOOP
            v_mod := MOD(v_mod * 10 + TO_NUMBER(SUBSTR(v_r, i, 1)), 97);
        END LOOP;
        RETURN (v_mod = 1);
    EXCEPTION WHEN OTHERS THEN RETURN FALSE;
    END iban_ok;

    -- Emirates ID Luhn check on the 15 digits.
    FUNCTION eid_ok (p_eid IN VARCHAR2) RETURN BOOLEAN IS
        v    VARCHAR2(20) := REGEXP_REPLACE(NVL(p_eid,''), '[^0-9]', '');
        v_sum NUMBER := 0;
        v_d   NUMBER;
        v_alt BOOLEAN := FALSE;
    BEGIN
        IF LENGTH(v) != 15 OR SUBSTR(v,1,3) != '784' THEN RETURN FALSE; END IF;
        FOR i IN REVERSE 1 .. 15 LOOP
            v_d := TO_NUMBER(SUBSTR(v, i, 1));
            IF v_alt THEN
                v_d := v_d * 2;
                IF v_d > 9 THEN v_d := v_d - 9; END IF;
            END IF;
            v_sum := v_sum + v_d;
            v_alt := NOT v_alt;
        END LOOP;
        RETURN (MOD(v_sum, 10) = 0);
    EXCEPTION WHEN OTHERS THEN RETURN FALSE;
    END eid_ok;

    PROCEDURE add_warn (p_arr IN OUT VARCHAR2, p_msg IN VARCHAR2) IS
    BEGIN
        p_arr := p_arr || CASE WHEN p_arr IS NULL THEN NULL ELSE ',' END
                 || APEX_JSON.STRINGIFY(p_msg);
    END add_warn;

    -- Pure-PL/SQL JSON scalar readers (JSON_VALUE on a CLOB misbehaves in the
    -- PL/SQL expression context on this DB -> use JSON_OBJECT_T).
    FUNCTION jget (p_json IN CLOB, p_key IN VARCHAR2) RETURN VARCHAR2 IS
        v_o JSON_OBJECT_T;
    BEGIN
        v_o := JSON_OBJECT_T.parse(p_json);
        IF v_o.has(p_key) THEN
            RETURN v_o.get_string(p_key);
        END IF;
        RETURN NULL;
    EXCEPTION WHEN OTHERS THEN RETURN NULL;
    END jget;

    FUNCTION jget_num (p_json IN CLOB, p_key IN VARCHAR2) RETURN NUMBER IS
        v_o JSON_OBJECT_T;
    BEGIN
        v_o := JSON_OBJECT_T.parse(p_json);
        IF v_o.has(p_key) THEN
            RETURN v_o.get_number(p_key);
        END IF;
        RETURN NULL;
    EXCEPTION WHEN OTHERS THEN RETURN NULL;
    END jget_num;

    -- Human name (keeps word boundaries) from a stored extract JSON, by doc type.
    FUNCTION raw_name (p_json IN CLOB, p_code IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        IF p_code = 'PASSPORT' THEN
            RETURN jget(p_json,'given_names') || ' ' || jget(p_json,'surname');
        ELSIF p_code IN ('EMIRATES_ID','NATIONAL_ID') THEN
            RETURN jget(p_json,'name_en');
        ELSIF p_code IN ('BANK_LETTER','BANK') THEN
            RETURN jget(p_json,'account_holder_name');
        END IF;
        RETURN NULL;
    END raw_name;

    -- "|HANY|GHAREB|ABDELAAL|" : pipe-wrapped set of the >=3-letter name tokens.
    FUNCTION name_key (p_in IN VARCHAR2) RETURN VARCHAR2 IS
        v VARCHAR2(1000) := '|';
        s VARCHAR2(2000) := REGEXP_REPLACE(UPPER(NVL(p_in,' ')), '[^A-Z]', ' ');
        w VARCHAR2(200);
    BEGIN
        FOR i IN 1 .. REGEXP_COUNT(s, '[A-Z]+') LOOP
            w := REGEXP_SUBSTR(s, '[A-Z]+', 1, i);
            IF LENGTH(w) >= 3 AND INSTR(v, '|'||w||'|') = 0 THEN
                v := v || w || '|';
            END IF;
        END LOOP;
        RETURN v;
    END name_key;

    -- TRUE when two name-keys share at least one token (so likely same person).
    -- FALSE = no shared name part => probably DIFFERENT people.
    FUNCTION shares_token (p_a IN VARCHAR2, p_b IN VARCHAR2) RETURN BOOLEAN IS
        w VARCHAR2(200);
    BEGIN
        FOR i IN 1 .. REGEXP_COUNT(p_a, '[A-Z]+') LOOP
            w := REGEXP_SUBSTR(p_a, '[A-Z]+', 1, i);
            IF INSTR(p_b, '|'||w||'|') > 0 THEN RETURN TRUE; END IF;
        END LOOP;
        RETURN FALSE;
    END shares_token;

    -- ------------------------------------------------------------ main entry
    FUNCTION extract_document (
        p_registration_id IN NUMBER,
        p_doc_id          IN NUMBER,
        p_user_id         IN NUMBER DEFAULT NULL
    ) RETURN CLOB IS
        v_blob    BLOB;
        v_mime    VARCHAR2(100);
        v_code    VARCHAR2(100);
        v_raw     CLOB;
        v_fields  CLOB;
        v_text    CLOB;
        v_conf    NUMBER;
        v_warn    VARCHAR2(4000);
        v_out     CLOB;
        v_extract_id NUMBER;
        v_model   VARCHAR2(100) := get_model;
        v_expiry  VARCHAR2(20);
        v_iban    VARCHAR2(40);
        v_eid     VARCHAR2(30);
        v_myname  VARCHAR2(400);
        v_kind     VARCHAR2(40);
        v_expected VARCHAR2(20);
        v_mismatch BOOLEAN := FALSE;
        v_mykey    VARCHAR2(1000);
        v_namemis  BOOLEAN := FALSE;
    BEGIN
        IF NVL(prod.dct_fl_pkg.get_setting('AI_FEATURES_ENABLED'),'N') != 'Y' THEN
            RAISE_APPLICATION_ERROR(-20001, 'AI document extraction is disabled.');
        END IF;

        SELECT d.file_blob, d.mime_type, dt.doc_type_code
        INTO   v_blob, v_mime, v_code
        FROM   prod.dct_documents d
        JOIN   prod.dct_document_types dt ON dt.doc_type_id = d.doc_type_id
        WHERE  d.doc_id = p_doc_id AND d.source_module = 'FL';

        IF v_blob IS NULL OR DBMS_LOB.GETLENGTH(v_blob) = 0 THEN
            RAISE_APPLICATION_ERROR(-20004, 'Document has no uploaded file to read.');
        END IF;

        BEGIN
            v_text   := call_ai(v_blob, v_mime, prompt_for(v_code), v_raw);
            v_fields := json_only(v_text);
            v_model  := NVL(g_used_model, v_model);   -- record the model that actually served it
        EXCEPTION WHEN OTHERS THEN
            DECLARE v_err VARCHAR2(4000) := SUBSTR(SQLERRM, 1, 4000);
            BEGIN
                INSERT INTO prod.dct_fl_doc_extracts (registration_id, doc_id, doc_type_code,
                    model, status, error_msg, created_by)
                VALUES (p_registration_id, p_doc_id, v_code, v_model, 'FAILED',
                    v_err, p_user_id);
                COMMIT;
            END;
            RAISE;
        END;

        -- Canonicalise to GUARANTEED-valid compact JSON so the browser can always
        -- parse the envelope (raw model output can carry stray/invalid characters).
        BEGIN
            v_fields := JSON_OBJECT_T.parse(v_fields).to_clob;
        EXCEPTION WHEN OTHERS THEN
            v_fields := TO_CLOB('{}');
            add_warn(v_warn, 'The AI response could not be parsed; please re-try or enter the fields manually.');
        END;

        v_conf := jget_num(v_fields, 'confidence');

        -- ---- document-type mismatch (wrong file uploaded into the slot) ------
        v_kind := UPPER(TRIM(jget(v_fields, 'document_kind')));
        v_expected := CASE
            WHEN v_code = 'PASSPORT'                    THEN 'PASSPORT'
            WHEN v_code IN ('EMIRATES_ID','NATIONAL_ID') THEN 'EMIRATES_ID'
            WHEN v_code IN ('BANK_LETTER','BANK')        THEN 'BANK_LETTER'
            ELSE NULL END;
        IF v_expected IS NOT NULL AND v_kind IS NOT NULL AND v_kind != v_expected THEN
            v_mismatch := TRUE;
            add_warn(v_warn, 'This file looks like a ' || v_kind
                     || ', not the expected ' || REPLACE(v_expected,'_',' ')
                     || '. Please upload the correct document.');
        END IF;

        -- ---- professional validation warnings -------------------------------
        IF v_code IN ('EMIRATES_ID','NATIONAL_ID') THEN
            v_eid := jget(v_fields, 'emirates_id');
            IF v_eid IS NOT NULL AND NOT eid_ok(v_eid) THEN
                add_warn(v_warn, 'Emirates ID number failed the 784/checksum validation - verify it.');
            END IF;
            v_expiry := jget(v_fields, 'card_expiry');
        ELSIF v_code IN ('BANK_LETTER','BANK') THEN
            v_iban := jget(v_fields, 'iban');
            IF v_iban IS NOT NULL AND NOT iban_ok(v_iban) THEN
                add_warn(v_warn, 'IBAN failed the mod-97 checksum - verify it.');
            END IF;
        ELSIF v_code = 'PASSPORT' THEN
            v_expiry := jget(v_fields, 'expiry_date');
        END IF;

        -- expired document warning
        IF v_expiry IS NOT NULL THEN
            BEGIN
                IF TO_DATE(v_expiry, 'YYYY-MM-DD') < TRUNC(SYSDATE) THEN
                    add_warn(v_warn, 'This document appears to be EXPIRED ('||v_expiry||').');
                END IF;
            EXCEPTION WHEN OTHERS THEN NULL; END;
        END IF;

        -- ---- cross-document name consistency (catch DIFFERENT people) --------
        -- Gated by AI_NAME_MATCH_CHECK (Y/N, default Y).
        v_mykey := name_key(raw_name(v_fields, v_code));
        IF NVL(prod.dct_fl_pkg.get_setting('AI_NAME_MATCH_CHECK'),'Y') = 'Y'
           AND v_mykey != '|' AND p_registration_id IS NOT NULL THEN
            FOR r IN (
                SELECT extracted_json, doc_type_code FROM prod.dct_fl_doc_extracts
                WHERE  registration_id = p_registration_id AND status = 'DONE'
                AND    doc_id != p_doc_id
            ) LOOP
                DECLARE v_ok VARCHAR2(1000) := name_key(raw_name(r.extracted_json, r.doc_type_code));
                BEGIN
                    IF v_ok != '|' AND NOT shares_token(v_mykey, v_ok) THEN
                        v_namemis := TRUE;
                        add_warn(v_warn, 'The name on this document does not match the '
                                 || REPLACE(r.doc_type_code,'_',' ')
                                 || ' you uploaded - they may belong to different people.');
                    END IF;
                END;
            END LOOP;
        END IF;

        -- note the transparent provider fallback (Gemini busy -> read with Claude)
        IF g_fellback THEN
            add_warn(v_warn, 'The selected AI provider was unavailable, so this document '
                     || 'was read with Claude instead.');
        END IF;

        -- ---- persist the extract audit row ----------------------------------
        INSERT INTO prod.dct_fl_doc_extracts (registration_id, doc_id, doc_type_code,
            model, status, confidence, extracted_json, raw_response, created_by)
        VALUES (p_registration_id, p_doc_id, v_code, v_model, 'DONE',
            v_conf, v_fields, v_raw, p_user_id)
        RETURNING extract_id INTO v_extract_id;

        -- ---- auto-capture expiry into the document (feeds expiry alerts) -----
        IF v_expiry IS NOT NULL THEN
            BEGIN
                UPDATE prod.dct_documents
                SET    expiry_date = TO_DATE(v_expiry, 'YYYY-MM-DD'),
                       updated_at  = SYSTIMESTAMP
                WHERE  doc_id = p_doc_id AND source_module = 'FL';
            EXCEPTION WHEN OTHERS THEN NULL; END;
        END IF;
        COMMIT;

        -- ---- return suggestion envelope -------------------------------------
        DBMS_LOB.CREATETEMPORARY(v_out, TRUE);
        clob_append(v_out, '{"extractId":' || v_extract_id
            || ',"provider":' || NVL(APEX_JSON.STRINGIFY(g_used_provider), 'null')
            || ',"fellback":' || CASE WHEN g_fellback THEN 'true' ELSE 'false' END
            || ',"docType":' || APEX_JSON.STRINGIFY(v_code)
            || ',"detectedKind":' || NVL(APEX_JSON.STRINGIFY(v_kind), 'null')
            || ',"typeMismatch":' || CASE WHEN v_mismatch THEN 'true' ELSE 'false' END
            || ',"nameMismatch":' || CASE WHEN v_namemis THEN 'true' ELSE 'false' END
            -- TO_CHAR(0.98) yields ".98" (no leading zero) which is INVALID JSON and
            -- makes the browser drop the whole envelope -> force a valid JSON number.
            || ',"confidence":' || CASE WHEN v_conf IS NULL THEN 'null'
                   ELSE TO_CHAR(ROUND(v_conf,4),'FM9999990.0000',
                                'NLS_NUMERIC_CHARACTERS=''.,''') END
            || ',"warnings":[' || NVL(v_warn,'') || ']'
            || ',"fields":');
        DBMS_LOB.APPEND(v_out, NVL(v_fields, TO_CLOB('{}')));
        clob_append(v_out, '}');
        RETURN v_out;
    END extract_document;

END dct_fl_ai_pkg;
/

SHOW ERRORS PACKAGE prod.dct_fl_ai_pkg
SHOW ERRORS PACKAGE BODY prod.dct_fl_ai_pkg

PROMPT === 12_fl_ai_pkg.sql complete ===
