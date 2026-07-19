-- =============================================================================
-- Accounts Payable (App 212) -- AI beneficiary duplicate detection (ADDITIVE)
-- File    : 06_ap_ai_dupcheck.sql
-- Adds to : ap.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp @06_ap_ai_dupcheck.sql   (fresh session)
-- IMPORTANT: 03_ap_ords.sql rebuilds ap.rest from scratch -- whenever 03 is
--           re-run, re-run 04 AND THIS script right after it.
-- Purpose : "Check duplicate using AI" on the Beneficiaries dashboard --
--           the same real-world beneficiary is often registered several times
--           (extra spaces, different capitalisation, Mohamed/Mohammed
--           transliterations, swapped name order, titles, typos). One AI call
--           clusters the distinct beneficiary names into likely-duplicate
--           groups.
--   POST /ap/benef/dupcheck?suppnum=   -> {analyzed, groupCount, provider,
--        model, fellback, elapsedSecs, groups:[{canonical, confidence, reason,
--        invoices, totalAed, members:[{name, invoices, totalAed, firstInvoice,
--        lastInvoice, site}]}]}
-- AI      : SAME configuration as the FL module (user requirement) --
--           provider registry prod.dct_ar_ai_providers + the FREELANCERS
--           module settings AI_PROVIDER / AI_MODEL / AI_FALLBACK_CLAUDE,
--           DBMS_CLOUD.SEND_REQUEST with 4-try backoff and the automatic
--           GEMINI -> ANTHROPIC fallback, exactly like DCT_FL_AI_PKG.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PACKAGE prod.dct_ap_ai_pkg AS
    -- Cluster the distinct beneficiary names of one generic supplier into
    -- likely-duplicate groups via the configured AI provider. Returns the
    -- drawer-ready JSON envelope as a CLOB.
    FUNCTION benef_dup_check (p_suppnum IN VARCHAR2 DEFAULT '26553') RETURN CLOB;
END dct_ap_ai_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_ap_ai_pkg AS

    -- ------------------------------------------------------------------ config
    -- All AI configuration is read from the FL module (user requirement:
    -- "use the same models configured in FL module").
    FUNCTION fl_setting (p_key IN VARCHAR2) RETURN VARCHAR2 IS
        v VARCHAR2(400);
    BEGIN
        SELECT s.setting_value INTO v
        FROM   prod.dct_module_settings s
        JOIN   prod.dct_modules m ON m.module_id = s.module_id
        WHERE  m.module_code = 'FREELANCERS' AND s.setting_key = p_key
        FETCH FIRST 1 ROW ONLY;
        RETURN v;
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
    END fl_setting;

    FUNCTION active_code RETURN VARCHAR2 IS
    BEGIN
        RETURN UPPER(NVL(fl_setting('AI_PROVIDER'), 'ANTHROPIC'));
    END active_code;

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

    PROCEDURE get_provider (o_format OUT VARCHAR2, o_base OUT VARCHAR2,
                            o_model OUT VARCHAR2, o_key OUT VARCHAR2) IS
        v_code VARCHAR2(40) := active_code;
    BEGIN
        get_provider_by(v_code, o_format, o_base, o_model, o_key);
        IF o_key IS NULL THEN
            BEGIN
                SELECT api_format, base_url, model_id, api_key
                INTO   o_format, o_base, o_model, o_key
                FROM   prod.dct_ar_ai_providers
                WHERE  is_active = 'Y'
                FETCH FIRST 1 ROW ONLY;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                o_format := NULL; o_base := NULL; o_model := NULL; o_key := NULL;
            END;
        END IF;
    END get_provider;

    -- FL rule: honour AI_MODEL when compatible with the active provider,
    -- else the provider row's model_id.
    FUNCTION pick_model (p_format IN VARCHAR2, p_row_model IN VARCHAR2) RETURN VARCHAR2 IS
        s VARCHAR2(200) := TRIM(fl_setting('AI_MODEL'));
    BEGIN
        IF s IS NOT NULL THEN
            IF (UPPER(p_format) = 'GEMINI'    AND LOWER(s) LIKE 'gemini%')
            OR (UPPER(p_format) = 'ANTHROPIC' AND LOWER(s) LIKE 'claude%') THEN
                RETURN s;
            END IF;
        END IF;
        RETURN NVL(p_row_model, 'claude-sonnet-4-6');
    END pick_model;

    PROCEDURE clob_append (p_clob IN OUT NOCOPY CLOB, p_text IN VARCHAR2) IS
    BEGIN
        IF p_text IS NOT NULL THEN
            DBMS_LOB.WRITEAPPEND(p_clob, LENGTH(p_text), p_text);
        END IF;
    END clob_append;

    -- JSON-escape a CLOB (APEX_JSON.STRINGIFY only takes VARCHAR2). Escaping is
    -- per-character, so processing in chunks is safe across chunk boundaries.
    FUNCTION json_escape_clob (p_in IN CLOB) RETURN CLOB IS
        v_out CLOB;
        v_len PLS_INTEGER := NVL(DBMS_LOB.GETLENGTH(p_in), 0);
        v_pos PLS_INTEGER := 1;
        v_chk VARCHAR2(32767);
    BEGIN
        DBMS_LOB.CREATETEMPORARY(v_out, TRUE);
        WHILE v_pos <= v_len LOOP
            v_chk := DBMS_LOB.SUBSTR(p_in, 4000, v_pos);
            v_chk := REPLACE(v_chk, '\',     '\\');
            v_chk := REPLACE(v_chk, '"',     '\"');
            v_chk := REPLACE(v_chk, CHR(13), '\r');
            v_chk := REPLACE(v_chk, CHR(10), '\n');
            v_chk := REPLACE(v_chk, CHR(9),  '\t');
            DBMS_LOB.WRITEAPPEND(v_out, LENGTH(v_chk), v_chk);
            v_pos := v_pos + 4000;
        END LOOP;
        RETURN v_out;
    END json_escape_clob;

    -- --------------------------------------------------------------- AI call
    -- Text-only variant of DCT_FL_AI_PKG.call_ai: same providers, same retry
    -- and backoff, same GEMINI -> ANTHROPIC automatic fallback.
    FUNCTION call_ai_text (p_prompt IN CLOB,
                           o_provider OUT VARCHAR2, o_model OUT VARCHAR2,
                           o_fellback OUT VARCHAR2) RETURN CLOB IS
        v_format VARCHAR2(40); v_base VARCHAR2(400); v_model VARCHAR2(200); v_key VARCHAR2(400);
        f2 VARCHAR2(40); b2 VARCHAR2(400); m2 VARCHAR2(200); k2 VARCHAR2(400);
        v_res        CLOB;
        v_prompt_esc CLOB;
        v_fb   BOOLEAN := NVL(fl_setting('AI_FALLBACK_CLAUDE'), 'Y') = 'Y';
        -- big name lists need a big answer budget (a 1,374-name run truncated
        -- at 8000 and failed to parse; both gemini-2.5-flash and claude-haiku
        -- support 32k+ output)
        c_max_out CONSTANT NUMBER := 32000;

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
            v_raw       CLOB;
        BEGIN
            DBMS_LOB.CREATETEMPORARY(v_payload, TRUE);
            IF UPPER(p_format) = 'GEMINI' THEN
                -- thinkingBudget 0: gemini-2.5-* burn "thinking" tokens out of
                -- maxOutputTokens and truncate the JSON answer on big lists
                clob_append(v_payload, '{"contents":[{"parts":[{"text":"');
                DBMS_LOB.APPEND(v_payload, v_prompt_esc);
                clob_append(v_payload, '"}]}],"generationConfig":{"maxOutputTokens":60000'
                    || ',"temperature":0,"response_mime_type":"application/json"'
                    || ',"thinkingConfig":{"thinkingBudget":0}}}');
                v_url := NVL(p_base, 'https://generativelanguage.googleapis.com/v1beta/models/')
                         || p_model || ':generateContent';
                v_headers := '{"content-type":"application/json","x-goog-api-key":"'||p_key||'"}';
            ELSE
                clob_append(v_payload, '{"model":"'||p_model||'","max_tokens":'||c_max_out
                    ||',"temperature":0,"messages":[{"role":"user","content":"');
                DBMS_LOB.APPEND(v_payload, v_prompt_esc);
                clob_append(v_payload, '"}]}');
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
                    v_raw    := DBMS_CLOUD.GET_RESPONSE_TEXT(v_resp);
                    EXIT WHEN v_status = 200;
                    IF v_status IN (429, 500, 502, 503, 529) AND v_try < 4 THEN
                        DBMS_SESSION.SLEEP(v_try * 3);
                    ELSE
                        EXIT;
                    END IF;
                EXCEPTION WHEN OTHERS THEN
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
                    || v_status || ': ' || SUBSTR(v_raw, 1, 200));
            END IF;

            IF UPPER(p_format) = 'GEMINI' THEN
                RETURN JSON_VALUE(v_raw, '$.candidates[0].content.parts[0].text' RETURNING CLOB);
            ELSE
                RETURN JSON_VALUE(v_raw, '$.content[0].text' RETURNING CLOB);
            END IF;
        END do_call;
    BEGIN
        get_provider(v_format, v_base, v_model, v_key);
        v_format := UPPER(NVL(v_format, 'ANTHROPIC'));
        v_model  := pick_model(v_format, v_model);
        IF v_key IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001,
                'No API key configured for AI provider ' || active_code
                || ' (Admin > AR > Manage Providers).');
        END IF;

        v_prompt_esc := json_escape_clob(p_prompt);
        o_provider := v_format; o_model := v_model; o_fellback := 'N';
        BEGIN
            v_res := do_call(v_format, v_base, v_model, v_key);
        EXCEPTION WHEN OTHERS THEN
            IF v_format = 'GEMINI' AND v_fb THEN
                get_provider_by('ANTHROPIC', f2, b2, m2, k2);
                IF k2 IS NOT NULL THEN
                    o_provider := 'ANTHROPIC';
                    o_model    := NVL(m2, 'claude-sonnet-4-6');
                    o_fellback := 'Y';
                    v_res := do_call('ANTHROPIC', b2, o_model, k2);
                ELSE
                    RAISE;
                END IF;
            ELSE
                RAISE;
            END IF;
        END;
        DBMS_LOB.FREETEMPORARY(v_prompt_esc);
        RETURN v_res;
    END call_ai_text;

    -- Trim model output to the outermost JSON object (models sometimes wrap
    -- the answer in a markdown fence despite the instruction).
    FUNCTION json_only (p_in IN CLOB) RETURN CLOB IS
        v_start PLS_INTEGER;
        v_end   PLS_INTEGER;
    BEGIN
        IF p_in IS NULL THEN RETURN NULL; END IF;
        v_start := DBMS_LOB.INSTR(p_in, '{');
        v_end   := DBMS_LOB.GETLENGTH(p_in);
        WHILE v_end > 0 AND DBMS_LOB.SUBSTR(p_in, 1, v_end) != '}' LOOP
            v_end := v_end - 1;
        END LOOP;
        IF v_start = 0 OR v_end <= v_start THEN RETURN NULL; END IF;
        RETURN DBMS_LOB.SUBSTR(p_in, v_end - v_start + 1, v_start);
    END json_only;

    -- ------------------------------------------------------------- main entry
    FUNCTION benef_dup_check (p_suppnum IN VARCHAR2 DEFAULT '26553') RETURN CLOB IS
        TYPE t_vc   IS TABLE OF VARCHAR2(400) INDEX BY PLS_INTEGER;
        TYPE t_num  IS TABLE OF NUMBER        INDEX BY PLS_INTEGER;
        TYPE t_dt   IS TABLE OF VARCHAR2(10)  INDEX BY PLS_INTEGER;
        v_name  t_vc;  v_site t_vc;
        v_invs  t_num; v_amt  t_num;
        v_first t_dt;  v_last t_dt;
        v_n        PLS_INTEGER := 0;
        v_list     CLOB;
        v_prompt   CLOB;
        v_answer   CLOB;
        v_json     CLOB;
        v_provider VARCHAR2(40);
        v_model    VARCHAR2(200);
        v_fellback VARCHAR2(1);
        v_t0       NUMBER := DBMS_UTILITY.GET_TIME;
        v_groups   PLS_INTEGER := 0;
        v_valid    PLS_INTEGER;
        v_g_invs   NUMBER;
        v_g_amt    NUMBER;
        TYPE t_ids IS TABLE OF NUMBER;
        v_ids      t_ids;
    BEGIN
        -- 1) distinct effective beneficiary names + stats
        FOR r IN (
            SELECT CASE WHEN supplier_name = 'BENEFICIARY' AND beneficiary_name IS NOT NULL
                        THEN beneficiary_name ELSE supplier_name END nm,
                   COUNT(*) invs,
                   ROUND(SUM(NVL(invoice_amount_aed, 0)), 2) amt,
                   TO_CHAR(MIN(invoice_date), 'YYYY-MM-DD') dt_first,
                   TO_CHAR(MAX(invoice_date), 'YYYY-MM-DD') dt_last,
                   MAX(supplier_site) site
            FROM prod.ap_invoices_header_v
            WHERE supplier_number = p_suppnum
            GROUP BY CASE WHEN supplier_name = 'BENEFICIARY' AND beneficiary_name IS NOT NULL
                          THEN beneficiary_name ELSE supplier_name END
            ORDER BY UPPER(CASE WHEN supplier_name = 'BENEFICIARY' AND beneficiary_name IS NOT NULL
                                THEN beneficiary_name ELSE supplier_name END))
        LOOP
            v_n := v_n + 1;
            v_name(v_n)  := SUBSTR(r.nm, 1, 400);
            v_invs(v_n)  := r.invs;
            v_amt(v_n)   := r.amt;
            v_first(v_n) := r.dt_first;
            v_last(v_n)  := r.dt_last;
            v_site(v_n)  := SUBSTR(r.site, 1, 400);
        END LOOP;

        IF v_n = 0 THEN
            RAISE_APPLICATION_ERROR(-20404, 'No beneficiaries found for supplier ' || p_suppnum);
        END IF;

        -- 2) prompt: numbered list, answer references the numbers only
        DBMS_LOB.CREATETEMPORARY(v_list, TRUE);
        FOR i IN 1 .. v_n LOOP
            clob_append(v_list, i || '|' || v_name(i) || CHR(10));
        END LOOP;

        DBMS_LOB.CREATETEMPORARY(v_prompt, TRUE);
        clob_append(v_prompt,
            'You are a data-quality assistant for an accounts-payable system. '
         || 'Below is a numbered list of beneficiary (payee) names. The same real-world '
         || 'person or company may be registered more than once with variations: extra or '
         || 'missing spaces, different capitalisation, spelling/transliteration variants '
         || '(e.g. Mohamed/Mohammed/Muhammad, Abdulla/Abdullah), swapped name order, '
         || 'titles (Mr/Dr/Eng), missing middle names, abbreviations, company-suffix '
         || 'variants (LLC/L.L.C/LLC.), or small typos. '
         || 'Group the entries that are LIKELY the same beneficiary. Rules: only groups of '
         || '2 or more entries; an entry belongs to at most one group; do NOT group names '
         || 'that merely share a first name or a common surname - the FULL identity must '
         || 'plausibly match. Return STRICT JSON only, no prose, no markdown fences: '
         || '{"groups":[{"ids":[<list numbers>],"canonical":"<best full name>",'
         || '"confidence":<0.0-1.0>,"reason":"<short explanation>"}]}. '
         || 'Return MINIFIED JSON on one line - no indentation, no extra whitespace. '
         || 'Keep each reason under 12 words. '
         || 'If there are no likely duplicates return {"groups":[]}. '
         || 'The list (' || v_n || ' names, format id|name):' || CHR(10));
        DBMS_LOB.APPEND(v_prompt, v_list);
        DBMS_LOB.FREETEMPORARY(v_list);

        -- 3) one AI call (FL-configured provider/model, retry + fallback)
        v_answer := call_ai_text(v_prompt, v_provider, v_model, v_fellback);
        DBMS_LOB.FREETEMPORARY(v_prompt);
        v_json := json_only(v_answer);
        DECLARE v_ok NUMBER;
        BEGIN
            SELECT COUNT(*) INTO v_ok FROM dual WHERE v_json IS JSON;
            IF v_json IS NULL OR v_ok = 0 THEN
                RAISE_APPLICATION_ERROR(-20005,
                    'The AI response could not be parsed as JSON (likely truncated) - please retry. '
                    || 'len=' || NVL(DBMS_LOB.GETLENGTH(v_answer), 0)
                    || ' tail: ' || DBMS_LOB.SUBSTR(v_answer, 120,
                         GREATEST(1, NVL(DBMS_LOB.GETLENGTH(v_answer), 1) - 119)));
            END IF;
        END;

        -- 4) assemble the drawer-ready envelope
        APEX_JSON.initialize_clob_output;
        APEX_JSON.open_object;
        APEX_JSON.write('suppnum', p_suppnum);
        APEX_JSON.write('analyzed', v_n);
        APEX_JSON.write('provider', v_provider);
        APEX_JSON.write('model', v_model);
        APEX_JSON.write('fellback', v_fellback);
        APEX_JSON.open_array('groups');

        FOR g IN (
            SELECT jt.g_idx, jt.canonical, jt.confidence, jt.reason
            FROM JSON_TABLE(v_json, '$.groups[*]'
                   COLUMNS (g_idx      FOR ORDINALITY,
                            canonical  VARCHAR2(400) PATH '$.canonical',
                            confidence NUMBER        PATH '$.confidence',
                            reason     VARCHAR2(600) PATH '$.reason')) jt
            ORDER BY jt.g_idx)
        LOOP
            SELECT id_val BULK COLLECT INTO v_ids
            FROM JSON_TABLE(v_json, '$.groups[*]'
                   COLUMNS (g_idx FOR ORDINALITY,
                            NESTED PATH '$.ids[*]' COLUMNS (id_val NUMBER PATH '$')))
            WHERE g_idx = g.g_idx AND id_val BETWEEN 1 AND v_n;

            v_valid := NVL(v_ids.COUNT, 0);
            IF v_valid >= 2 THEN
                v_groups := v_groups + 1;
                v_g_invs := 0; v_g_amt := 0;
                FOR i IN 1 .. v_ids.COUNT LOOP
                    v_g_invs := v_g_invs + v_invs(v_ids(i));
                    v_g_amt  := v_g_amt  + v_amt(v_ids(i));
                END LOOP;
                APEX_JSON.open_object;
                APEX_JSON.write('canonical',  NVL(g.canonical, v_name(v_ids(1))));
                APEX_JSON.write('confidence', NVL(g.confidence, 0));
                APEX_JSON.write('reason',     g.reason);
                APEX_JSON.write('invoices',   v_g_invs);
                APEX_JSON.write('totalAed',   ROUND(v_g_amt, 2));
                APEX_JSON.open_array('members');
                FOR i IN 1 .. v_ids.COUNT LOOP
                    APEX_JSON.open_object;
                    APEX_JSON.write('name',         v_name(v_ids(i)));
                    APEX_JSON.write('invoices',     v_invs(v_ids(i)));
                    APEX_JSON.write('totalAed',     v_amt(v_ids(i)));
                    APEX_JSON.write('firstInvoice', v_first(v_ids(i)));
                    APEX_JSON.write('lastInvoice',  v_last(v_ids(i)));
                    APEX_JSON.write('site',         v_site(v_ids(i)));
                    APEX_JSON.close_object;
                END LOOP;
                APEX_JSON.close_array;
                APEX_JSON.close_object;
            END IF;
        END LOOP;

        APEX_JSON.close_array;
        APEX_JSON.write('groupCount', v_groups);
        APEX_JSON.write('elapsedSecs', ROUND((DBMS_UTILITY.GET_TIME - v_t0) / 100, 1));
        APEX_JSON.close_object;
        RETURN APEX_JSON.get_clob_output;
    END benef_dup_check;

END dct_ap_ai_pkg;
/

SHOW ERRORS

CREATE OR REPLACE PROCEDURE setup_ap_ai_ords AS
    c_mod CONSTANT VARCHAR2(30) := 'ap.rest';
    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;
    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => p_method,
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN
    def_template('benef/dupcheck');
    def_handler('benef/dupcheck', 'POST', q'!
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_suppnum VARCHAR2(40)  := NVL([COLON]suppnum, '26553');
  l_out     CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401, 'Unauthorized'); RETURN; END IF;
  l_out := dct_ap_ai_pkg.benef_dup_check(l_suppnum);
  dct_rest.json_header;
  DECLARE
    l_len PLS_INTEGER := NVL(DBMS_LOB.GETLENGTH(l_out), 0);
    l_pos PLS_INTEGER := 1;
  BEGIN
    WHILE l_pos <= l_len LOOP
      HTP.prn(DBMS_LOB.SUBSTR(l_out, 8000, l_pos));
      l_pos := l_pos + 8000;
    END LOOP;
  END;
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE = -20404 THEN dct_rest.err(404, SQLERRM);
    ELSIF SQLCODE IN (-20001, -20005) THEN dct_rest.err(400, SQLERRM);
    ELSE dct_rest.err(500, SQLERRM);
    END IF;
END;
!');
    COMMIT;
END setup_ap_ai_ords;
/

BEGIN setup_ap_ai_ords; END;
/
DROP PROCEDURE setup_ap_ai_ords;

CREATE OR REPLACE SYNONYM dct_ap_ai_pkg FOR prod.dct_ap_ai_pkg;

PROMPT === verification ===
SELECT object_name, status FROM all_objects
 WHERE owner = 'PROD' AND object_name = 'DCT_AP_AI_PKG';
SELECT COUNT(*) dup_handler FROM user_ords_handlers WHERE source LIKE '%benef_dup_check%';

PROMPT ap.rest AI duplicate-check endpoint published (POST /ap/benef/dupcheck)
