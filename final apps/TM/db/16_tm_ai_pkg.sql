-- =============================================================================
-- Task Management Module (App 207) -- AI period summariser DCT_TM_AI_PKG
-- File   : 16_tm_ai_pkg.sql
-- Schema : PROD
-- Run    : sql -name prod_mcp @16_tm_ai_pkg.sql   (own session is fine; no synonyms)
-- What   : summarize_period(actor, period) -> a board-ready executive narrative of a
--          team's reporting period, written into DCT_TM_PERIODS.ai_summary and returned.
--          Built from the period's member submissions + metrics (no hallucinated data:
--          the model only re-words the supplied facts). Gated by the TASK_MGMT module
--          setting AI_FEATURES_ENABLED (default N).
-- Pattern: outbound call via DBMS_CLOUD.SEND_REQUEST -> api.anthropic.com, mirrored
--          from DCT_ATD_AI_PKG / DCT_AR_AI_PKG. API key reused from the active
--          ANTHROPIC row in DCT_AR_AI_PROVIDERS (set once for the platform).
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON
WHENEVER SQLERROR CONTINUE

-- Network ACL: let PROD reach the Anthropic API (rerunnable; no-op if already granted)
DECLARE
  l_host VARCHAR2(200) := 'api.anthropic.com';
BEGIN
  DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
    host => l_host,
    ace  => xs$ace_type(
              privilege_list => xs$name_list('connect','resolve'),
              principal_name => 'PROD',
              principal_type => xs_acl.ptype_db));
  DBMS_OUTPUT.PUT_LINE('ACE ensured for PROD -> '||l_host);
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('ACL note: '||SUBSTR(SQLERRM,1,120));
END;
/

CREATE OR REPLACE PACKAGE prod.dct_tm_ai_pkg AS
  -- Generate (and persist) an executive narrative for a reporting period.
  FUNCTION summarize_period (p_actor_id NUMBER, p_period_id NUMBER) RETURN CLOB;
END dct_tm_ai_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_tm_ai_pkg AS

  c_api_url CONSTANT VARCHAR2(200) := 'https://api.anthropic.com/v1/messages';

  PROCEDURE clob_append (p_clob IN OUT NOCOPY CLOB, p_text IN VARCHAR2) IS
  BEGIN
    IF p_text IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(p_clob, LENGTH(p_text), p_text); END IF;
  END clob_append;

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

  FUNCTION get_setting (p_key VARCHAR2, p_default VARCHAR2) RETURN VARCHAR2 IS
    v VARCHAR2(4000);
  BEGIN
    SELECT s.setting_value INTO v
    FROM   prod.dct_module_settings s JOIN prod.dct_modules m ON m.module_id = s.module_id
    WHERE  m.module_code = 'TASK_MGMT' AND s.setting_key = p_key;
    RETURN NVL(v, p_default);
  EXCEPTION WHEN NO_DATA_FOUND THEN RETURN p_default;
  END get_setting;

  FUNCTION get_api_key RETURN VARCHAR2 IS
    v VARCHAR2(400);
  BEGIN
    BEGIN
      SELECT api_key INTO v FROM prod.dct_ar_ai_providers
       WHERE UPPER(provider_code) = 'ANTHROPIC' AND is_active = 'Y' FETCH FIRST 1 ROW ONLY;
    EXCEPTION WHEN OTHERS THEN v := NULL; END;
    RETURN v;
  END get_api_key;

  FUNCTION call_anthropic (p_prompt IN CLOB) RETURN CLOB IS
    v_key   VARCHAR2(400) := get_api_key;
    v_model VARCHAR2(100) := NVL(get_setting('AI_MODEL', NULL), 'claude-sonnet-4-6');
    v_max   NUMBER        := NVL(TO_NUMBER(get_setting('AI_MAX_TOKENS','700') DEFAULT 700 ON CONVERSION ERROR), 700);
    v_body  CLOB; v_blob BLOB; v_warn INTEGER;
    v_dest_off INTEGER := 1; v_src_off INTEGER := 1; v_lang INTEGER := DBMS_LOB.DEFAULT_LANG_CTX;
    v_resp  DBMS_CLOUD_TYPES.resp; v_status NUMBER; v_text CLOB;
  BEGIN
    IF v_key IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'No Anthropic API key configured (set the AR ANTHROPIC provider).');
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
      RAISE_APPLICATION_ERROR(-20001, 'Anthropic API ' || v_status || ': ' || SUBSTR(v_text, 1, 300));
    END IF;
    RETURN JSON_VALUE(v_text, '$.content[0].text' RETURNING CLOB);
  END call_anthropic;

  FUNCTION summarize_period (p_actor_id NUMBER, p_period_id NUMBER) RETURN CLOB IS
    v_team   NUMBER; v_ctx CLOB; v_prompt CLOB; v_ans CLOB;
    v_label  VARCHAR2(60); v_tname VARCHAR2(200); v_pstat VARCHAR2(20);
    v_sub NUMBER; v_late NUMBER; v_pend NUMBER;
  BEGIN
    IF get_setting('AI_FEATURES_ENABLED','N') <> 'Y' THEN
      RAISE_APPLICATION_ERROR(-20001, 'AI features are disabled. Enable AI_FEATURES_ENABLED in module settings.');
    END IF;
    BEGIN
      SELECT p.team_id, p.period_label, t.team_name_en, p.status
      INTO   v_team, v_label, v_tname, v_pstat
      FROM   prod.dct_tm_periods p JOIN prod.dct_tm_teams t ON t.team_id = p.team_id
      WHERE  p.period_id = p_period_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20404, 'Period not found.');
    END;
    IF prod.dct_tm_vis_pkg.can_view_team(p_actor_id, v_team) <> 'Y' THEN
      RAISE_APPLICATION_ERROR(-20403, 'Not permitted to view this team.');
    END IF;

    SELECT COUNT(CASE WHEN status IN ('SUBMITTED','LATE') THEN 1 END),
           COUNT(CASE WHEN status = 'LATE' THEN 1 END),
           COUNT(CASE WHEN status IN ('NOT_STARTED','DRAFT') THEN 1 END)
    INTO   v_sub, v_late, v_pend
    FROM   prod.dct_tm_submissions WHERE period_id = p_period_id;

    -- assemble a compact factual context (the model only re-words these facts)
    DBMS_LOB.CREATETEMPORARY(v_ctx, TRUE);
    clob_append(v_ctx, 'TEAM: ' || v_tname || ' | PERIOD: ' || v_label || ' (status ' || v_pstat || ')'
      || ' | submitted ' || v_sub || ', late ' || v_late || ', pending ' || v_pend || CHR(10)
      || 'MEMBER UPDATES:' || CHR(10));
    FOR s IN (
      SELECT member_name, status, tasks_done, tasks_on_track, tasks_late, tasks_overdue,
             NVL(objective_progress,0) AS kpi, accomplishments, in_progress, pending, blockers, highlights
      FROM   prod.dct_tm_submission_v WHERE period_id = p_period_id ORDER BY member_name
    ) LOOP
      clob_append(v_ctx, '- ' || s.member_name || ' [' || s.status || ']: done=' || s.tasks_done
        || ' onTrack=' || s.tasks_on_track || ' late=' || s.tasks_late || ' overdue=' || s.tasks_overdue
        || ' kpi=' || s.kpi || '%' || CHR(10));
      IF s.accomplishments IS NOT NULL THEN clob_append(v_ctx, '   accomplishments: ' || SUBSTR(s.accomplishments,1,600) || CHR(10)); END IF;
      IF s.pending        IS NOT NULL THEN clob_append(v_ctx, '   pending: ' || SUBSTR(s.pending,1,400) || CHR(10)); END IF;
      IF s.blockers       IS NOT NULL THEN clob_append(v_ctx, '   blockers: ' || SUBSTR(s.blockers,1,400) || CHR(10)); END IF;
      IF s.highlights     IS NOT NULL THEN clob_append(v_ctx, '   risks/highlights: ' || SUBSTR(s.highlights,1,400) || CHR(10)); END IF;
    END LOOP;

    DBMS_LOB.CREATETEMPORARY(v_prompt, TRUE);
    clob_append(v_prompt,
      'You are writing a concise executive status summary for senior management of a UAE '
      || 'government finance division. Using ONLY the team reporting-period data below, write a '
      || 'single tight, board-ready paragraph (3-6 sentences) in professional English that covers: '
      || 'overall progress and submission discipline, the most significant accomplishments, what is '
      || 'pending or at risk, and any blockers that need management escalation. Use the actual numbers. '
      || 'Do NOT invent facts, do NOT use markdown, bullet points, headings or a preamble — return the '
      || 'paragraph only.' || CHR(10) || CHR(10) || 'PERIOD DATA:' || CHR(10));
    DBMS_LOB.APPEND(v_prompt, v_ctx);

    v_ans := call_anthropic(v_prompt);

    UPDATE prod.dct_tm_periods SET ai_summary = v_ans WHERE period_id = p_period_id;
    RETURN v_ans;
  END summarize_period;

END dct_tm_ai_pkg;
/

SHOW ERRORS PACKAGE prod.dct_tm_ai_pkg
SHOW ERRORS PACKAGE BODY prod.dct_tm_ai_pkg

PROMPT
PROMPT === 16_tm_ai_pkg.sql complete ===
