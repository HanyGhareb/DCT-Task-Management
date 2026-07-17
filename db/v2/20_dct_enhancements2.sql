-- =============================================================================
-- Enhancement round 2 (post-UAT 13-Jun-2026) -- DB + ORDS
-- File    : 20_dct_enhancements2.sql
-- Schema  : PROD data + ADMIN ORDS additions (module dct.admin)
-- Run     : sql -name prod_mcp @20_dct_enhancements2.sql   (fresh session)
-- =============================================================================
-- 1. Seed: INTEGRATION_API_KEY secret row (masked in GET settings/)
-- 2. settings/:setkey PUT  -> upsert (LANDING_* / FEATURE_* keys can be born
--    from the UI; previously the row had to pre-exist)
-- 3. audit/ GET            -> adds from / to date filters (YYYY-MM-DD)
-- 4. audit/export GET      -> server-built CSV download (same filters)
-- 5. sessions/ GET         -> active sessions (masked ids, within timeout)
--    sessions/revoke POST  -> close all active sessions of one user
-- 6. approval-templates/:id/restore POST -> archived version -> new draft
-- Mirrored in the source of truth db/v2/11_dct_ords.sql.
-- =============================================================================
SET DEFINE OFF

PROMPT === 1. secret setting seed ===
MERGE INTO prod.dct_system_settings t
USING (SELECT 'INTEGRATION_API_KEY' AS k FROM dual) s
ON (t.setting_key = s.k)
WHEN NOT MATCHED THEN INSERT
  (setting_key, setting_value, value_type, category, description_en,
   is_encrypted, is_system, created_by)
VALUES
  ('INTEGRATION_API_KEY', 'rotate-me-before-first-use', 'STRING', 'SECURITY',
   'API key reserved for external integrations. Stored encrypted; the console only ever shows a mask.',
   'Y', 'N', 'SETUP');

COMMIT;

PROMPT === 2-6. ORDS additions (module dct.admin, incremental) ===
CREATE OR REPLACE PROCEDURE setup_dct_enh2_ords_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'dct.admin';

    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58))
        );
    END;

    PROCEDURE def_handler(
        p_pattern  VARCHAR2,
        p_method   VARCHAR2,
        p_source   CLOB
    ) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name    => c_mod,
            p_pattern        => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method         => p_method,
            p_source_type    => ORDS.source_type_plsql,
            p_source         => REPLACE(p_source, '[COLON]', CHR(58))
        );
    END;

BEGIN

    -- -------------------------------------------------------------------------
    -- settings/:setkey PUT -- now an upsert. New keys (LANDING_<ROLE>,
    -- FEATURE_*) are typed/categorised from the key name.
    -- -------------------------------------------------------------------------
    def_handler('settings/[COLON]setkey', 'PUT', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_val  VARCHAR2(4000);
  l_num  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_val := APEX_JSON.get_varchar2(p_path => 'value');
  IF [COLON]setkey IN ('ATD_SUCCESS_LOG_RETENTION_DAYS','ATD_ISSUE_LOG_RETENTION_DAYS') THEN
    IF NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
      dct_rest.err(403,'Only SYS_ADMIN may change technical log retention'); RETURN;
    END IF;
    l_num := TO_NUMBER(l_val DEFAULT NULL ON CONVERSION ERROR);
    IF l_num IS NULL OR l_num != TRUNC(l_num)
       OR ([COLON]setkey = 'ATD_SUCCESS_LOG_RETENTION_DAYS' AND l_num NOT BETWEEN 7 AND 3650)
       OR ([COLON]setkey = 'ATD_ISSUE_LOG_RETENTION_DAYS' AND l_num NOT BETWEEN 30 AND 3650) THEN
      dct_rest.err(400,'Invalid retention days'); RETURN;
    END IF;
  END IF;
  IF l_val = '********' THEN
    dct_rest.json_header;
    APEX_JSON.initialize_output;
    APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.write('skipped', 'masked value'); APEX_JSON.close_object;
    RETURN;
  END IF;
  MERGE INTO dct_system_settings t
  USING (SELECT [COLON]setkey AS k FROM dual) s
  ON (t.setting_key = s.k)
  WHEN MATCHED THEN UPDATE SET
    t.setting_value = l_val,
    t.updated_by    = l_user,
    t.updated_at    = SYSTIMESTAMP
  WHEN NOT MATCHED THEN INSERT
    (setting_key, setting_value, value_type, category, is_system, created_by)
  VALUES
    (s.k, l_val,
     CASE WHEN s.k LIKE 'FEATURE\_%' ESCAPE '\' THEN 'BOOLEAN' ELSE 'STRING' END,
     CASE WHEN s.k LIKE 'FEATURE\_%' ESCAPE '\' THEN 'FEATURES'
          WHEN s.k LIKE 'LANDING\_%' ESCAPE '\' THEN 'UI'
          ELSE 'GENERAL' END,
     'N', l_user);
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    -- -------------------------------------------------------------------------
    -- audit/ GET -- adds from / to (YYYY-MM-DD, inclusive) to the Phase 3
    -- pagination params.
    -- -------------------------------------------------------------------------
    def_handler('audit/', 'GET', q'[
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_limit  NUMBER        := LEAST(NVL(TO_NUMBER([COLON]limit DEFAULT NULL ON CONVERSION ERROR), 50), 200);
  l_offset NUMBER        := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_search VARCHAR2(200) := [COLON]search;
  l_action VARCHAR2(100) := UPPER([COLON]action);
  l_category VARCHAR2(100) := UPPER([COLON]category);
  l_from   DATE          := TO_DATE([COLON]fromdt DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
  l_to     DATE          := TO_DATE([COLON]todt   DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;

  SELECT COUNT(*) INTO l_total
  FROM   dct_audit_log
  WHERE (l_action IS NULL OR action = l_action)
    AND (l_category IS NULL OR NVL(module_code,'UNCATEGORIZED') = l_category)
    AND (l_from   IS NULL OR logged_at >= l_from)
    AND (l_to     IS NULL OR logged_at <  l_to + 1)
    AND (l_search IS NULL OR
         UPPER(NVL(username,'') || ' ' || NVL(module_code,'') || ' ' || NVL(object_type,'') || ' ' || NVL(object_id,''))
         LIKE '%' || UPPER(l_search) || '%');

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total',  l_total);
  APEX_JSON.write('limit',  l_limit);
  APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT log_id, username, module_code, action, object_type, object_id,
           status, error_message, logged_at
    FROM   dct_audit_log
    WHERE (l_action IS NULL OR action = l_action)
      AND (l_category IS NULL OR NVL(module_code,'UNCATEGORIZED') = l_category)
      AND (l_from   IS NULL OR logged_at >= l_from)
      AND (l_to     IS NULL OR logged_at <  l_to + 1)
      AND (l_search IS NULL OR
           UPPER(NVL(username,'') || ' ' || NVL(module_code,'') || ' ' || NVL(object_type,'') || ' ' || NVL(object_id,''))
           LIKE '%' || UPPER(l_search) || '%')
    ORDER BY logged_at DESC
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('logId',       r.log_id);
    APEX_JSON.write('username',    r.username);
    APEX_JSON.write('category',    NVL(r.module_code,'UNCATEGORIZED'));
    APEX_JSON.write('action',      r.action);
    APEX_JSON.write('objectType',  r.object_type);
    APEX_JSON.write('objectId',    r.object_id);
    APEX_JSON.write('status',      r.status);
    APEX_JSON.write('error',       r.error_message);
    APEX_JSON.write('loggedAt',    TO_CHAR(r.logged_at,'YYYY-MM-DD"T"HH24":"MI":"SS'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    -- -------------------------------------------------------------------------
    -- audit/export GET -- server-built CSV (full filtered history, 20k cap,
    -- UTF-8 BOM so Excel renders Arabic). Same filters as audit/ GET.
    -- -------------------------------------------------------------------------
    def_template('audit/export');
    def_handler('audit/export', 'GET', q'[
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_search VARCHAR2(200) := [COLON]search;
  l_action VARCHAR2(100) := UPPER([COLON]action);
  l_from   DATE          := TO_DATE([COLON]fromdt DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
  l_to     DATE          := TO_DATE([COLON]todt   DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
  l_n      NUMBER := 0;
  FUNCTION esc(p VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    IF p IS NULL THEN RETURN NULL; END IF;
    IF INSTR(p, '"') > 0 OR INSTR(p, ',') > 0 OR INSTR(p, CHR(10)) > 0 THEN
      RETURN '"' || REPLACE(p, '"', '""') || '"';
    END IF;
    RETURN p;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN may export the audit log'); RETURN;
  END IF;
  OWA_UTIL.mime_header('text/csv', FALSE, 'UTF-8');
  HTP.p('Content-Disposition: attachment; filename="audit-log-' ||
        TO_CHAR(SYSDATE,'YYYY-MM-DD') || '.csv"');
  OWA_UTIL.http_header_close;
  HTP.prn(UNISTR('\FEFF'));   -- UTF-8 BOM so Excel renders Arabic (CHR bytes raise ORA-29275 in AL32UTF8)
  HTP.print('loggedAt,username,action,objectType,objectId,status,error');
  FOR r IN (
    SELECT log_id, username, action, object_type, object_id,
           status, error_message, logged_at
    FROM   dct_audit_log
    WHERE (l_action IS NULL OR action = l_action)
      AND (l_from   IS NULL OR logged_at >= l_from)
      AND (l_to     IS NULL OR logged_at <  l_to + 1)
      AND (l_search IS NULL OR
           UPPER(NVL(username,'') || ' ' || NVL(object_type,'') || ' ' || NVL(object_id,''))
           LIKE '%' || UPPER(l_search) || '%')
    ORDER BY logged_at DESC
  ) LOOP
    EXIT WHEN l_n >= 20000;
    l_n := l_n + 1;
    HTP.print(
      TO_CHAR(r.logged_at,'YYYY-MM-DD"T"HH24":"MI":"SS') || ',' ||
      esc(r.username)    || ',' || esc(r.action)    || ',' ||
      esc(r.object_type) || ',' || esc(r.object_id) || ',' ||
      esc(r.status)      || ',' || esc(r.error_message));
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    -- -------------------------------------------------------------------------
    -- sessions/ GET -- active sessions within the inactivity window.
    -- session_id is the bearer token: NEVER returned whole. sidTail (last 6)
    -- lets the client highlight "this device".
    -- -------------------------------------------------------------------------
    def_template('sessions/');
    def_handler('sessions/', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_mins NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN may view sessions'); RETURN;
  END IF;
  BEGIN
    SELECT TO_NUMBER(setting_value) INTO l_mins
    FROM dct_system_settings WHERE setting_key = 'SESSION_TIMEOUT_MINS';
  EXCEPTION WHEN OTHERS THEN l_mins := 480;
  END;
  l_mins := NVL(l_mins, 480);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('timeoutMins', l_mins);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT s.session_id, s.username, u.display_name, s.login_at,
           s.last_activity_at, s.ip_address, s.user_agent, s.auth_method
    FROM   dct_sessions s
    LEFT JOIN dct_users u ON u.user_id = s.user_id
    WHERE  s.is_active = 'Y'
      AND  s.logout_at IS NULL
      AND  s.last_activity_at > SYSTIMESTAMP - NUMTODSINTERVAL(l_mins, 'MINUTE')
    ORDER BY s.last_activity_at DESC
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('sidTail',      SUBSTR(r.session_id, -6));
    APEX_JSON.write('username',     r.username);
    APEX_JSON.write('displayName',  r.display_name);
    APEX_JSON.write('loginAt',      TO_CHAR(r.login_at,'YYYY-MM-DD"T"HH24":"MI":"SS'));
    APEX_JSON.write('lastActivity', TO_CHAR(r.last_activity_at,'YYYY-MM-DD"T"HH24":"MI":"SS'));
    APEX_JSON.write('ip',           r.ip_address);
    APEX_JSON.write('userAgent',    SUBSTR(r.user_agent, 1, 120));
    APEX_JSON.write('authMethod',   r.auth_method);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    -- -------------------------------------------------------------------------
    -- sessions/revoke POST {username} -- close ALL active sessions of a user
    -- (revoking by token would mean shipping live tokens to the client).
    -- -------------------------------------------------------------------------
    def_template('sessions/revoke');
    def_handler('sessions/revoke', 'POST', q'[
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_target VARCHAR2(100);
  l_n      NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN may revoke sessions'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_target := UPPER(TRIM(APEX_JSON.get_varchar2(p_path => 'username')));
  IF l_target IS NULL THEN dct_rest.err(400,'username is required'); RETURN; END IF;
  UPDATE dct_sessions
  SET    is_active = 'N', logout_at = SYSTIMESTAMP
  WHERE  UPPER(username) = l_target
    AND  is_active = 'Y'
    AND  logout_at IS NULL;
  l_n := SQL%ROWCOUNT;
  INSERT INTO dct_audit_log (username, action, object_type, object_id, status)
  VALUES (l_user, 'SESSIONS_REVOKED', 'DCT_SESSIONS', l_target, 'SUCCESS');
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.write('revoked', l_n);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    -- -------------------------------------------------------------------------
    -- approval-templates/:id/restore POST -- archived version -> new draft of
    -- the current live template (steps copied from the archive). The draft
    -- then follows the normal edit/activate lifecycle.
    -- -------------------------------------------------------------------------
    def_template('approval-templates/[COLON]id/restore');
    def_handler('approval-templates/[COLON]id/restore', 'POST', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_code VARCHAR2(100);
  l_base VARCHAR2(100);
  l_live NUMBER;
  l_cnt  NUMBER;
  l_new  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN may manage templates'); RETURN;
  END IF;
  SELECT template_code INTO l_code
  FROM dct_approval_templates WHERE template_id = [COLON]id;
  IF INSTR(l_code, CHR(126) || 'V') = 0 THEN
    dct_rest.err(409,'Only archived versions can be restored'); RETURN;
  END IF;
  l_base := SUBSTR(l_code, 1, INSTR(l_code, CHR(126)) - 1);
  BEGIN
    SELECT template_id INTO l_live
    FROM dct_approval_templates
    WHERE template_code = l_base AND is_active = 'Y';
  EXCEPTION WHEN NO_DATA_FOUND THEN
    dct_rest.err(409,'No live template found for ' || l_base); RETURN;
  END;
  SELECT COUNT(*) INTO l_cnt FROM dct_approval_templates
  WHERE template_code = l_base || CHR(126) || 'D';
  IF l_cnt > 0 THEN
    dct_rest.err(409,'A draft already exists for this template'); RETURN;
  END IF;
  INSERT INTO dct_approval_templates (
    template_code, template_name, template_name_ar, module_id, request_type,
    description_en, description_ar, is_sequential, auto_approve_days,
    is_active, parent_template_id, version_no, created_by)
  SELECT l_base || CHR(126) || 'D', template_name, template_name_ar,
         module_id, request_type, description_en, description_ar,
         is_sequential, auto_approve_days,
         'N', l_live, NVL(version_no, 1), l_user
  FROM dct_approval_templates WHERE template_id = [COLON]id;
  SELECT template_id INTO l_new FROM dct_approval_templates
  WHERE template_code = l_base || CHR(126) || 'D';
  INSERT INTO dct_approval_steps (
    template_id, step_seq, step_name, step_name_ar, step_type,
    required_role_id, specific_user_id, escalation_days, escalate_role_id,
    is_mandatory, allow_skip, condition_type, amount_operator,
    amount_threshold, type_filter, custom_condition, created_by)
  SELECT l_new, step_seq, step_name, step_name_ar, step_type,
         required_role_id, specific_user_id, escalation_days, escalate_role_id,
         is_mandatory, allow_skip, condition_type, amount_operator,
         amount_threshold, type_filter, custom_condition, l_user
  FROM dct_approval_steps WHERE template_id = [COLON]id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('templateId', l_new);
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION
  WHEN NO_DATA_FOUND THEN ROLLBACK; dct_rest.err(404,'Template not found');
  WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    COMMIT;
END setup_dct_enh2_ords_tmp;
/

SHOW ERRORS PROCEDURE setup_dct_enh2_ords_tmp

BEGIN
  setup_dct_enh2_ords_tmp;
END;
/

DROP PROCEDURE setup_dct_enh2_ords_tmp;

PROMPT ============================================================
PROMPT  20_dct_enhancements2.sql complete.
PROMPT  settings PUT is an upsert; audit/ takes fromdt/todt;
PROMPT  new: audit/export (CSV), sessions/ + sessions/revoke,
PROMPT  approval-templates/:id/restore.
PROMPT ============================================================
