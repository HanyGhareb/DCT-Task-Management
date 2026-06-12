-- =============================================================================
-- Wave enhancements (post-UAT 12-Jun-2026) — DB + ORDS
-- File    : 19_dct_wave_enhancements.sql
-- Schema  : PROD objects + ADMIN ORDS additions
-- Run     : sql -name prod_mcp @19_dct_wave_enhancements.sql
--           (fresh session — this script creates ADMIN synonym-free ORDS
--            handlers; do NOT run after ALTER SESSION SET CURRENT_SCHEMA)
-- =============================================================================
-- 1. dct_approval_templates: parent_template_id + version_no (draft lifecycle)
-- 2. Seeds: FEATURE_* flags + LANDING_* landing-page keys
-- 3. dct_rest.validate_session: enforce SESSION_TIMEOUT_MINS inactivity cutoff
-- 4. ORDS (module dct.admin, incremental upserts):
--      GET  boot                              one-call shell bootstrap
--      GET  notifications/count               cheap unread badge poll
--      GET  audit/:id                         before/after JSON snapshots
--      POST approval-templates/:id/clone      live -> draft copy (steps too)
--      POST approval-templates/:id/activate   archive live, promote draft
--      PUT  approval-templates/:id/steps      draft-only step reorder/rename
--      GET  approval-templates/ , /:id        + parentTemplateId/versionNo/stepId
-- Mirrored in the source of truth db/v2/11_dct_ords.sql.
-- =============================================================================
SET DEFINE OFF

PROMPT === 1. dct_approval_templates draft/version columns ===
DECLARE
  e_exists EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_exists, -1430);   -- column being added already exists
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_approval_templates ADD (parent_template_id NUMBER, version_no NUMBER DEFAULT 1)';
EXCEPTION WHEN e_exists THEN NULL;
END;
/

PROMPT === 2. Feature flags + landing-page setting seeds ===
MERGE INTO prod.dct_system_settings t
USING (
  SELECT 'FEATURE_COMMAND_PALETTE' AS k, 'Y' AS v, 'BOOLEAN' AS vt, 'FEATURES' AS cat,
         'Ctrl+K command palette in the JET apps (Y/N)' AS descr FROM dual
  UNION ALL SELECT 'FEATURE_BULK_USER_ACTIONS', 'Y', 'BOOLEAN', 'FEATURES',
         'Multi-select bulk actions on the Admin users list (Y/N)' FROM dual
  UNION ALL SELECT 'FEATURE_IDLE_WARNING', 'Y', 'BOOLEAN', 'FEATURES',
         'Pre-timeout idle session warning dialog (Y/N)' FROM dual
  UNION ALL SELECT 'LANDING_MANAGER', 'dashboard', 'STRING', 'UI',
         'Post-login landing route for MANAGER role (e.g. pendingApprovals)' FROM dual
  UNION ALL SELECT 'LANDING_TASK_DIRECTOR', 'dashboard', 'STRING', 'UI',
         'Post-login landing route for TASK_DIRECTOR role' FROM dual
) s ON (t.setting_key = s.k)
WHEN NOT MATCHED THEN INSERT
  (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
  VALUES (s.k, s.v, s.vt, s.cat, s.descr, 'N', 'SYSTEM');

COMMIT;

PROMPT === 3. dct_rest.validate_session — inactivity timeout ===
CREATE OR REPLACE PACKAGE BODY prod.dct_rest AS

    FUNCTION validate_session RETURN VARCHAR2 IS
        l_hdr      VARCHAR2(4000);
        l_token    VARCHAR2(200);
        l_username VARCHAR2(100);
    BEGIN
        -- ADB managed ORDS uses 'AUTHORIZATION' (no HTTP_ prefix); fall back to HTTP_ for on-prem
        l_hdr := OWA_UTIL.get_cgi_env('AUTHORIZATION');
        IF l_hdr IS NULL THEN
            l_hdr := OWA_UTIL.get_cgi_env('HTTP_AUTHORIZATION');
        END IF;
        IF l_hdr LIKE 'Bearer %' THEN
            l_token := TRIM(SUBSTR(l_hdr, 8));
        END IF;
        IF l_token IS NULL THEN RETURN NULL; END IF;

        -- Wave 3 (4.6): sessions now expire after SESSION_TIMEOUT_MINS of
        -- inactivity (default 480). validate_session touches last_activity_at
        -- on success, so any API traffic keeps the session alive.
        SELECT s.username INTO l_username
        FROM   dct_sessions s
        JOIN   dct_users    u ON s.user_id = u.user_id
        WHERE  s.session_id = l_token
          AND  s.is_active  = 'Y'
          AND  u.is_active  = 'Y'
          AND  s.last_activity_at > SYSTIMESTAMP - NUMTODSINTERVAL(
                 NVL((SELECT TO_NUMBER(setting_value)
                      FROM dct_system_settings
                      WHERE setting_key = 'SESSION_TIMEOUT_MINS'), 480), 'MINUTE')
          AND  ROWNUM = 1;

        dct_auth.touch_session(l_token);
        RETURN l_username;
    EXCEPTION WHEN OTHERS THEN RETURN NULL;
    END validate_session;

    PROCEDURE json_header IS
        c_col CONSTANT VARCHAR2(1) := CHR(58);
    BEGIN
        OWA_UTIL.mime_header('application/json', FALSE);
        HTP.p('Access-Control-Allow-Origin'  || c_col || ' *');
        HTP.p('Access-Control-Allow-Headers' || c_col || ' Authorization, Content-Type');
        HTP.p('Access-Control-Allow-Methods' || c_col || ' GET, POST, PUT, DELETE, OPTIONS');
        OWA_UTIL.http_header_close;
    END json_header;

    PROCEDURE err(p_status PLS_INTEGER, p_msg VARCHAR2) IS
        c_col CONSTANT VARCHAR2(1) := CHR(58);
    BEGIN
        -- No APEX_JSON here: initialize_output resets the HTP buffer and
        -- wipes the status line (the original bug fixed in db/v2/13).
        OWA_UTIL.status_line(p_status, NULL, FALSE);
        OWA_UTIL.mime_header('application/json', FALSE);
        HTP.p('Access-Control-Allow-Origin'  || c_col || ' *');
        HTP.p('Access-Control-Allow-Headers' || c_col || ' Authorization, Content-Type');
        HTP.p('Access-Control-Allow-Methods' || c_col || ' GET, POST, PUT, DELETE, OPTIONS');
        OWA_UTIL.http_header_close;
        HTP.p('{"error"' || c_col || ' "' ||
              REPLACE(REPLACE(p_msg, '\', '\\'), '"', '\"') || '"}');
    END err;

    PROCEDURE parse_body(p_body IN BLOB) IS
        l_raw  RAW(32767);
        l_body VARCHAR2(32767);
    BEGIN
        l_raw  := DBMS_LOB.SUBSTR(p_body, 32767, 1);
        l_body := UTL_RAW.CAST_TO_VARCHAR2(l_raw);
        APEX_JSON.parse(l_body);
    EXCEPTION WHEN OTHERS THEN
        APEX_JSON.parse('{}');
    END parse_body;

END dct_rest;
/

SHOW ERRORS PACKAGE BODY prod.dct_rest

PROMPT === 4. ORDS additions (module dct.admin, incremental) ===
CREATE OR REPLACE PROCEDURE setup_dct_wave_ords_tmp AS

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
    -- GET boot — one-call shell bootstrap (Wave 3 / 3.3)
    -- { unreadCount, prefs:{KEY:value}, settings:[{key,value}] }
    -- settings = the safe, all-users subset (flags, landing routes, theme)
    -- -------------------------------------------------------------------------
    def_template('boot');
    def_handler('boot', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
  l_cnt  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  SELECT COUNT(*) INTO l_cnt
  FROM   dct_notifications
  WHERE  recipient_user_id = l_uid AND is_read = 'N'
    AND  (expires_at IS NULL OR expires_at > SYSTIMESTAMP);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('unreadCount', l_cnt);
  APEX_JSON.open_object('prefs');
  FOR p IN (SELECT pref_key, pref_value FROM dct_user_preferences WHERE user_id = l_uid) LOOP
    APEX_JSON.write(p.pref_key, p.pref_value);
  END LOOP;
  APEX_JSON.close_object;
  APEX_JSON.open_array('settings');
  FOR s IN (SELECT setting_key, setting_value
            FROM   dct_system_settings
            WHERE  setting_key LIKE 'FEATURE\_%' ESCAPE '\'
               OR  setting_key LIKE 'LANDING\_%' ESCAPE '\'
               OR  setting_key IN ('THEME_BRAND_COLOR','SESSION_TIMEOUT_MINS','APP_THEME')) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('key',   s.setting_key);
    APEX_JSON.write('value', s.setting_value);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- -------------------------------------------------------------------------
    -- GET notifications/count — cheap unread badge poll (Wave 1 / 1.5)
    -- -------------------------------------------------------------------------
    def_template('notifications/count');
    def_handler('notifications/count', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
  l_cnt  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  SELECT COUNT(*) INTO l_cnt
  FROM   dct_notifications
  WHERE  recipient_user_id = l_uid AND is_read = 'N'
    AND  (expires_at IS NULL OR expires_at > SYSTIMESTAMP);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('count', l_cnt);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- -------------------------------------------------------------------------
    -- GET audit/:id — before/after JSON snapshots for the diff viewer (Wave 3)
    -- -------------------------------------------------------------------------
    def_template('audit/[COLON]id');
    def_handler('audit/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  FOR r IN (SELECT log_id, old_values, new_values
            FROM dct_audit_log WHERE log_id = [COLON]id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('logId',     r.log_id);
    APEX_JSON.write('oldValues', r.old_values);
    APEX_JSON.write('newValues', r.new_values);
    APEX_JSON.close_object;
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- -------------------------------------------------------------------------
    -- Approval template draft lifecycle (Wave 4 / 1.4)
    -- Drafts: template_code = live code || '~D', is_active = 'N',
    --         parent_template_id = live template. Activation archives the
    --         live row (code || '~V<version>') and promotes the draft.
    -- Engines pick templates by exact code + is_active='Y', so drafts and
    -- archived versions are invisible to them.
    -- -------------------------------------------------------------------------
    def_template('approval-templates/[COLON]id/clone');
    def_handler('approval-templates/[COLON]id/clone', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_code VARCHAR2(100);
  l_cnt  NUMBER;
  l_new  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN may manage templates'); RETURN;
  END IF;
  SELECT template_code INTO l_code
  FROM dct_approval_templates WHERE template_id = [COLON]id;
  IF INSTR(l_code, CHR(126)) > 0 THEN
    dct_rest.err(409,'Only live templates can be cloned'); RETURN;
  END IF;
  SELECT COUNT(*) INTO l_cnt FROM dct_approval_templates
  WHERE template_code = l_code || CHR(126) || 'D';
  IF l_cnt > 0 THEN
    dct_rest.err(409,'A draft already exists for this template'); RETURN;
  END IF;
  INSERT INTO dct_approval_templates (
    template_code, template_name, template_name_ar, module_id, request_type,
    description_en, description_ar, is_sequential, auto_approve_days,
    is_active, parent_template_id, version_no, created_by)
  SELECT template_code || CHR(126) || 'D', template_name, template_name_ar,
         module_id, request_type, description_en, description_ar,
         is_sequential, auto_approve_days,
         'N', template_id, NVL(version_no, 1), l_user
  FROM dct_approval_templates WHERE template_id = [COLON]id;
  SELECT template_id INTO l_new FROM dct_approval_templates
  WHERE template_code = l_code || CHR(126) || 'D';
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
!');

    def_template('approval-templates/[COLON]id/activate');
    def_handler('approval-templates/[COLON]id/activate', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_parent NUMBER;
  l_code   VARCHAR2(100);
  l_ver    NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN may manage templates'); RETURN;
  END IF;
  SELECT parent_template_id INTO l_parent
  FROM dct_approval_templates WHERE template_id = [COLON]id;
  IF l_parent IS NULL THEN
    dct_rest.err(409,'Only drafts can be activated'); RETURN;
  END IF;
  SELECT template_code, NVL(version_no, 1) INTO l_code, l_ver
  FROM dct_approval_templates WHERE template_id = l_parent;
  UPDATE dct_approval_templates
  SET    template_code = template_code || CHR(126) || 'V' || l_ver,
         is_active = 'N', updated_by = l_user, updated_at = SYSTIMESTAMP
  WHERE  template_id = l_parent;
  UPDATE dct_approval_templates
  SET    template_code = l_code, is_active = 'Y',
         version_no = l_ver + 1, parent_template_id = NULL,
         updated_by = l_user, updated_at = SYSTIMESTAMP
  WHERE  template_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION
  WHEN NO_DATA_FOUND THEN ROLLBACK; dct_rest.err(404,'Template not found');
  WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- steps: [{ stepId, seq, label, slaHours }] — drafts only.
    -- Two-pass seq update avoids any (template_id, step_seq) uniqueness clash.
    def_template('approval-templates/[COLON]id/steps');
    def_handler('approval-templates/[COLON]id/steps', 'PUT', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_parent NUMBER;
  l_n      NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN may manage templates'); RETURN;
  END IF;
  SELECT parent_template_id INTO l_parent
  FROM dct_approval_templates WHERE template_id = [COLON]id;
  IF l_parent IS NULL THEN
    dct_rest.err(409,'Steps can only be edited on drafts'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_n := NVL(APEX_JSON.get_count(p_path => 'steps'), 0);
  FOR i IN 1 .. l_n LOOP
    UPDATE dct_approval_steps
    SET    step_seq = 1000 + APEX_JSON.get_number(p_path => 'steps[%d].seq', p0 => i)
    WHERE  step_id     = APEX_JSON.get_number(p_path => 'steps[%d].stepId', p0 => i)
      AND  template_id = [COLON]id;
  END LOOP;
  FOR i IN 1 .. l_n LOOP
    UPDATE dct_approval_steps
    SET    step_seq        = APEX_JSON.get_number(p_path => 'steps[%d].seq', p0 => i),
           step_name       = NVL(APEX_JSON.get_varchar2(p_path => 'steps[%d].label', p0 => i), step_name),
           escalation_days = NVL(APEX_JSON.get_number(p_path => 'steps[%d].slaHours', p0 => i) / 24, escalation_days),
           updated_by      = l_user, updated_at = SYSTIMESTAMP
    WHERE  step_id     = APEX_JSON.get_number(p_path => 'steps[%d].stepId', p0 => i)
      AND  template_id = [COLON]id;
  END LOOP;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION
  WHEN NO_DATA_FOUND THEN ROLLBACK; dct_rest.err(404,'Template not found');
  WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- -------------------------------------------------------------------------
    -- Redefine template list/detail to expose the draft lifecycle fields
    -- (same handlers as 11_dct_ords.sql + parentTemplateId/versionNo/stepId)
    -- -------------------------------------------------------------------------
    def_handler('approval-templates/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT t.template_id, t.template_code, t.template_name, t.request_type,
           t.is_active, t.parent_template_id, NVL(t.version_no, 1) AS version_no,
           m.module_code,
           (SELECT COUNT(*) FROM dct_approval_steps s WHERE s.template_id = t.template_id) AS step_count
    FROM   dct_approval_templates t
    LEFT JOIN dct_modules m ON m.module_id = t.module_id
    ORDER BY m.module_code, t.template_name, t.version_no
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('templateId',   r.template_id);
    APEX_JSON.write('templateCode', NVL(r.template_code, '-'));
    APEX_JSON.write('templateName', NVL(r.template_name, '-'));
    APEX_JSON.write('module',       NVL(r.module_code, '-'));
    APEX_JSON.write('requestType',  NVL(r.request_type, '-'));
    APEX_JSON.write('stepCount',    NVL(r.step_count, 0));
    APEX_JSON.write('isActive',     r.is_active);
    APEX_JSON.write('versionNo',    r.version_no);
    IF r.parent_template_id IS NOT NULL THEN
      APEX_JSON.write('parentTemplateId', r.parent_template_id);
    END IF;
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('approval-templates/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_seq  NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  FOR t IN (
    SELECT t.template_id, t.template_code, t.template_name, t.request_type,
           t.is_active, t.parent_template_id, NVL(t.version_no, 1) AS version_no,
           m.module_code,
           t.created_by, t.created_at, t.updated_by, t.updated_at
    FROM   dct_approval_templates t
    LEFT JOIN dct_modules m ON m.module_id = t.module_id
    WHERE  t.template_id = [COLON]id
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('templateId',   t.template_id);
    APEX_JSON.write('templateCode', NVL(t.template_code, '-'));
    APEX_JSON.write('templateName', NVL(t.template_name, '-'));
    APEX_JSON.write('module',       NVL(t.module_code, '-'));
    APEX_JSON.write('requestType',  NVL(t.request_type, '-'));
    APEX_JSON.write('isActive',     t.is_active);
    APEX_JSON.write('versionNo',    t.version_no);
    IF t.parent_template_id IS NOT NULL THEN
      APEX_JSON.write('parentTemplateId', t.parent_template_id);
    END IF;
    APEX_JSON.write('createdBy',    t.created_by);
    APEX_JSON.write('createdAt', TO_CHAR(FROM_TZ(t.created_at, 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.write('updatedBy',    t.updated_by);
    APEX_JSON.write('updatedAt', TO_CHAR(FROM_TZ(t.updated_at, 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.open_array('steps');
    FOR s IN (
      SELECT s.step_id, s.step_seq, s.step_name, s.escalation_days, r.role_code
      FROM   dct_approval_steps s
      LEFT JOIN dct_roles r ON r.role_id = s.required_role_id
      WHERE  s.template_id = t.template_id
      ORDER BY s.step_seq
    ) LOOP
      l_seq := l_seq + 1;
      APEX_JSON.open_object;
      APEX_JSON.write('stepId',   s.step_id);
      APEX_JSON.write('seq',      l_seq);
      APEX_JSON.write('label',    NVL(s.step_name, 'Step ' || l_seq));
      APEX_JSON.write('roleCode', NVL(s.role_code, '-'));
      APEX_JSON.write('slaHours', NVL(s.escalation_days, 0) * 24);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.close_object;
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END setup_dct_wave_ords_tmp;
/

SHOW ERRORS PROCEDURE setup_dct_wave_ords_tmp

BEGIN
  setup_dct_wave_ords_tmp;
END;
/

DROP PROCEDURE setup_dct_wave_ords_tmp;

PROMPT ============================================================
PROMPT  19_dct_wave_enhancements.sql complete.
PROMPT  New endpoints: boot, notifications/count, audit/:id,
PROMPT    approval-templates/:id/clone | /activate | /steps
PROMPT  dct_rest.validate_session now enforces SESSION_TIMEOUT_MINS.
PROMPT ============================================================
