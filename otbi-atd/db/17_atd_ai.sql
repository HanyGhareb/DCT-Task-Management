-- =============================================================================
-- ATD Loader (App 208) -- AI column suggester
-- File   : 17_atd_ai.sql
-- Schema : PROD
-- Run    : sql -name prod_mcp @17_atd_ai.sql   (own session is fine; no synonyms here)
-- What   : DCT_ATD_AI_PKG.suggest_columns(subject_area, request) -> JSON.
--          Flattens a discovered subject area's cached folder/column tree
--          (ATD_SA_CATALOG.catalog_json) into a NUMBERED list, asks Claude which
--          indices best match the user's free-text request, and maps the returned
--          indices back to {path,column} -- so a suggestion can NEVER be a column
--          that is not in the catalog (no hallucinations).
-- Pattern: outbound call via DBMS_CLOUD.SEND_REQUEST -> api.anthropic.com, mirrored
--          from DCT_AR_AI_PKG.call_anthropic (final apps/AR/db/03_ar_ai_pkg.sql).
-- Config : ATD_RUNNER_CONFIG keys AI_MODEL (default claude-sonnet-4-6),
--          AI_MAX_TOKENS, AI_API_KEY (secret). API key falls back to the active
--          ANTHROPIC row in DCT_AR_AI_PROVIDERS so a key need only be set once.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON
WHENEVER SQLERROR CONTINUE

-- 1. Network ACL: let PROD reach the Anthropic API (rerunnable) -----------------
DECLARE
  l_host VARCHAR2(200) := 'api.anthropic.com';
BEGIN
  DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
    host => l_host,
    ace  => xs$ace_type(
              privilege_list => xs$name_list('connect','resolve'),
              principal_name => 'PROD',
              principal_type => xs_acl.ptype_db));
  DBMS_OUTPUT.PUT_LINE('ACE appended for PROD -> '||l_host);
END;
/

-- 2. Config seed (rerunnable; only inserts missing keys) ------------------------
MERGE INTO prod.atd_runner_config t
USING (SELECT 'AI_MODEL' config_key FROM dual) s ON (t.config_key = s.config_key)
WHEN NOT MATCHED THEN INSERT (config_key, config_value, value_type, description, display_order)
  VALUES ('AI_MODEL', 'claude-sonnet-4-6', 'STRING', 'Anthropic model for the column suggester', 200);
MERGE INTO prod.atd_runner_config t
USING (SELECT 'AI_MAX_TOKENS' config_key FROM dual) s ON (t.config_key = s.config_key)
WHEN NOT MATCHED THEN INSERT (config_key, config_value, value_type, description, display_order)
  VALUES ('AI_MAX_TOKENS', '1500', 'NUMBER', 'Max output tokens for the column suggester', 201);
MERGE INTO prod.atd_runner_config t
USING (SELECT 'AI_API_KEY' config_key FROM dual) s ON (t.config_key = s.config_key)
WHEN NOT MATCHED THEN INSERT (config_key, config_value, value_type, is_secret, description, display_order)
  VALUES ('AI_API_KEY', NULL, 'STRING', 'Y', 'Anthropic API key (blank = reuse the AR ANTHROPIC provider key)', 202);
COMMIT;

-- 3. Package --------------------------------------------------------------------
CREATE OR REPLACE PACKAGE prod.dct_atd_ai_pkg AS
  -- Returns {"items":[{"path":["A","B"],"column":"X"}, ...]} for the columns Claude
  -- judges most relevant to p_request within the discovered catalog of p_subject_area.
  FUNCTION suggest_columns (p_subject_area IN VARCHAR2, p_request IN CLOB) RETURN CLOB;
END dct_atd_ai_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_atd_ai_pkg AS

  c_api_url CONSTANT VARCHAR2(200) := 'https://api.anthropic.com/v1/messages';

  TYPE t_leaf   IS RECORD (path_json VARCHAR2(2000), disp VARCHAR2(2000), col VARCHAR2(400));
  TYPE t_leaves IS TABLE OF t_leaf INDEX BY PLS_INTEGER;
  g_leaves t_leaves;
  g_idx    PLS_INTEGER := 0;

  PROCEDURE clob_append (p_clob IN OUT NOCOPY CLOB, p_text IN VARCHAR2) IS
  BEGIN
    IF p_text IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(p_clob, LENGTH(p_text), p_text); END IF;
  END clob_append;

  -- JSON-escape a VARCHAR2 into a quoted JSON string literal
  FUNCTION q (p_in IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN '"' || REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(p_in,
             '\','\\'), '"','\"'), CHR(13),''), CHR(10),'\n'), CHR(9),'\t') || '"';
  END q;

  -- JSON-escape a CLOB (APEX_JSON.STRINGIFY has no CLOB overload >32k)
  FUNCTION q_clob (p_in IN CLOB) RETURN CLOB IS
    v_out CLOB; v_chunk VARCHAR2(32767); v_pos PLS_INTEGER := 1; v_len PLS_INTEGER;
  BEGIN
    DBMS_LOB.CREATETEMPORARY(v_out, TRUE);
    clob_append(v_out, '"');
    v_len := NVL(DBMS_LOB.GETLENGTH(p_in), 0);
    WHILE v_pos <= v_len LOOP
      v_chunk := DBMS_LOB.SUBSTR(p_in, 8000, v_pos);
      v_chunk := REPLACE(v_chunk, '\', '\\');
      v_chunk := REPLACE(v_chunk, '"', '\"');
      v_chunk := REPLACE(v_chunk, CHR(13), '');
      v_chunk := REPLACE(v_chunk, CHR(10), '\n');
      v_chunk := REPLACE(v_chunk, CHR(9),  '\t');
      v_chunk := REGEXP_REPLACE(v_chunk, '[[:cntrl:]]', ' ');
      clob_append(v_out, v_chunk);
      v_pos := v_pos + 8000;
    END LOOP;
    clob_append(v_out, '"');
    RETURN v_out;
  END q_clob;

  FUNCTION get_cfg (p_key IN VARCHAR2) RETURN VARCHAR2 IS
    v VARCHAR2(2000);
  BEGIN
    SELECT config_value INTO v FROM prod.atd_runner_config WHERE config_key = p_key;
    RETURN v;
  EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
  END get_cfg;

  -- API key: ATD AI_API_KEY config, else the active ANTHROPIC AR provider row
  FUNCTION get_api_key RETURN VARCHAR2 IS
    v VARCHAR2(400) := get_cfg('AI_API_KEY');
  BEGIN
    IF v IS NOT NULL THEN RETURN v; END IF;
    BEGIN
      SELECT api_key INTO v FROM prod.dct_ar_ai_providers
       WHERE UPPER(provider_code) = 'ANTHROPIC' AND is_active = 'Y'
       FETCH FIRST 1 ROW ONLY;
    EXCEPTION WHEN OTHERS THEN v := NULL;
    END;
    RETURN v;
  END get_api_key;

  -- recursively flatten the nested catalog into g_leaves (path_json + display + column)
  PROCEDURE walk (p_folders IN JSON_ARRAY_T, p_path IN JSON_ARRAY_T, p_disp IN VARCHAR2) IS
    v_node JSON_OBJECT_T; v_cols JSON_ARRAY_T; v_subs JSON_ARRAY_T;
    v_path JSON_ARRAY_T;  v_fld VARCHAR2(400); v_disp VARCHAR2(2000);
  BEGIN
    IF p_folders IS NULL THEN RETURN; END IF;
    FOR i IN 0 .. p_folders.get_size - 1 LOOP
      v_node := TREAT(p_folders.get(i) AS JSON_OBJECT_T);
      v_fld  := v_node.get_string('folder');
      v_path := JSON_ARRAY_T.parse(p_path.to_string());   -- clone parent path
      v_path.append(v_fld);
      v_disp := CASE WHEN p_disp IS NULL THEN v_fld ELSE p_disp || ' > ' || v_fld END;
      v_cols := v_node.get_array('columns');
      IF v_cols IS NOT NULL THEN
        FOR j IN 0 .. v_cols.get_size - 1 LOOP
          g_idx := g_idx + 1;
          g_leaves(g_idx).path_json := v_path.to_string();
          g_leaves(g_idx).disp      := v_disp;
          g_leaves(g_idx).col       := v_cols.get_string(j);
        END LOOP;
      END IF;
      v_subs := v_node.get_array('folders');
      IF v_subs IS NOT NULL AND v_subs.get_size > 0 THEN
        walk(v_subs, v_path, v_disp);
      END IF;
    END LOOP;
  END walk;

  FUNCTION call_anthropic (p_prompt IN CLOB) RETURN CLOB IS
    v_key   VARCHAR2(400) := get_api_key;
    v_model VARCHAR2(100) := NVL(get_cfg('AI_MODEL'), 'claude-sonnet-4-6');
    v_max   NUMBER        := NVL(TO_NUMBER(get_cfg('AI_MAX_TOKENS') DEFAULT 1500 ON CONVERSION ERROR), 1500);
    v_body  CLOB; v_blob BLOB; v_warn INTEGER;
    v_dest_off INTEGER := 1; v_src_off INTEGER := 1; v_lang INTEGER := DBMS_LOB.DEFAULT_LANG_CTX;
    v_resp  DBMS_CLOUD_TYPES.resp; v_status NUMBER; v_text CLOB;
  BEGIN
    IF v_key IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'No Anthropic API key — set AI_API_KEY in Runner Settings'
        || ' or configure the AR ANTHROPIC provider');
    END IF;
    DBMS_LOB.CREATETEMPORARY(v_body, TRUE);
    clob_append(v_body, '{"model":"' || v_model || '","max_tokens":' || v_max
      || ',"messages":[{"role":"user","content":[{"type":"text","text":');
    DBMS_LOB.APPEND(v_body, q_clob(p_prompt));
    clob_append(v_body, '}]}]}');
    DBMS_LOB.CREATETEMPORARY(v_blob, TRUE);
    DBMS_LOB.CONVERTTOBLOB(v_blob, v_body, DBMS_LOB.GETLENGTH(v_body), v_dest_off, v_src_off,
      NLS_CHARSET_ID('AL32UTF8'), v_lang, v_warn);
    v_resp := DBMS_CLOUD.SEND_REQUEST(
      uri => c_api_url, method => 'POST', body => v_blob,
      headers => '{"anthropic-version":"2023-06-01","x-api-key":"' || v_key
              || '","content-type":"application/json"}');
    v_status := DBMS_CLOUD.GET_RESPONSE_STATUS_CODE(v_resp);
    v_text   := DBMS_CLOUD.GET_RESPONSE_TEXT(v_resp);
    IF v_status != 200 THEN
      RAISE_APPLICATION_ERROR(-20001, 'Anthropic API ' || v_status || ': ' || SUBSTR(v_text, 1, 400));
    END IF;
    RETURN JSON_VALUE(v_text, '$.content[0].text' RETURNING CLOB);
  END call_anthropic;

  FUNCTION suggest_columns (p_subject_area IN VARCHAR2, p_request IN CLOB) RETURN CLOB IS
    v_cat    CLOB; v_root JSON_OBJECT_T;
    v_prompt CLOB; v_ans CLOB; v_arr_txt VARCHAR2(32767);
    v_idxs   JSON_ARRAY_T; v_res CLOB; v_first BOOLEAN := TRUE; v_n PLS_INTEGER;
  BEGIN
    g_leaves.DELETE; g_idx := 0;
    BEGIN
      SELECT catalog_json INTO v_cat FROM prod.atd_sa_catalog
       WHERE subject_area = p_subject_area;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20404, 'Subject area not discovered: ' || p_subject_area);
    END;
    IF v_cat IS NULL OR DBMS_LOB.GETLENGTH(v_cat) = 0 THEN
      RAISE_APPLICATION_ERROR(-20404, 'Subject area has no scraped catalog yet: ' || p_subject_area);
    END IF;
    IF p_request IS NULL OR DBMS_LOB.GETLENGTH(p_request) = 0 THEN
      RAISE_APPLICATION_ERROR(-20001, 'Describe the data you need first');
    END IF;

    v_root := JSON_OBJECT_T.parse(v_cat);
    walk(v_root.get_array('folders'), JSON_ARRAY_T.parse('[]'), NULL);
    IF g_idx = 0 THEN
      RAISE_APPLICATION_ERROR(-20404, 'No columns in the catalog for ' || p_subject_area);
    END IF;

    -- build the prompt: numbered "index: Folder > Sub :: Column" list
    DBMS_LOB.CREATETEMPORARY(v_prompt, TRUE);
    clob_append(v_prompt,
      'You map a data request to OTBI analysis columns. Below is a numbered list of the '
      || 'available columns for subject area "' || p_subject_area || '" as '
      || '"<index>: <folder path> :: <column>". The user describes the data they need. '
      || 'Return ONLY a compact JSON array of the integer indices of the columns that best '
      || 'satisfy the request (most relevant first, at most 40, no duplicates, no prose, no '
      || 'code fences). Example: [3,17,42]. Pick only indices that appear in the list.' || CHR(10) || CHR(10)
      || 'USER REQUEST:' || CHR(10));
    DBMS_LOB.APPEND(v_prompt, p_request);
    clob_append(v_prompt, CHR(10) || CHR(10) || 'AVAILABLE COLUMNS:' || CHR(10));
    FOR k IN 1 .. g_idx LOOP
      clob_append(v_prompt, TO_CHAR(k - 1) || ': ' || g_leaves(k).disp || ' :: ' || g_leaves(k).col || CHR(10));
    END LOOP;

    v_ans := call_anthropic(v_prompt);

    -- trim model text to the outermost JSON array
    v_arr_txt := DBMS_LOB.SUBSTR(v_ans, 32767, 1);
    v_arr_txt := SUBSTR(v_arr_txt, INSTR(v_arr_txt, '['));
    v_arr_txt := SUBSTR(v_arr_txt, 1, INSTR(v_arr_txt, ']', -1));
    BEGIN
      v_idxs := JSON_ARRAY_T.parse(v_arr_txt);
    EXCEPTION WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20001, 'AI returned no usable selection');
    END;

    DBMS_LOB.CREATETEMPORARY(v_res, TRUE);
    clob_append(v_res, '{"items":[');
    FOR i IN 0 .. v_idxs.get_size - 1 LOOP
      BEGIN
        v_n := v_idxs.get_number(i);          -- 0-based index into g_leaves(1..g_idx)
      EXCEPTION WHEN OTHERS THEN v_n := NULL; END;
      IF v_n IS NOT NULL AND v_n >= 0 AND v_n < g_idx THEN
        IF NOT v_first THEN clob_append(v_res, ','); END IF;
        v_first := FALSE;
        clob_append(v_res, '{"path":' || g_leaves(v_n + 1).path_json
          || ',"column":' || q(g_leaves(v_n + 1).col) || '}');
      END IF;
    END LOOP;
    clob_append(v_res, ']}');
    RETURN v_res;
  END suggest_columns;

END dct_atd_ai_pkg;
/

SHOW ERRORS PACKAGE BODY prod.dct_atd_ai_pkg

PROMPT ATD 17 AI suggester : done
