-- ===========================================================================
-- otbi-atd : 85 Worker Fleet round -- pause/resume, session identity, age
--            auto re-login settings, VM filter support columns.
--
--   * atd_worker_heartbeat gains PAUSED (operator hold: the worker stops
--     claiming work after its current job; heartbeat keeps beating) and
--     SESSION_ACCOUNT (which Fusion account the worker's current session
--     belongs to -- service account, or the personal profile of the running
--     job/action).
--   * POST /atd/workers/:id/pause  + POST /atd/workers/:id/resume ('all' ok).
--   * GET  /atd/workers redefined to also ship paused + sessionAccount.
--     This SUPERSEDES the db/56 version of the handler: after any 13 re-run,
--     run 85 (running 56 after 85 would drop the two new fields).
--   * Runner settings: ATD_AGE_RELOGIN (Y/N, ships N) + ATD_AGE_RELOGIN_HOURS
--     (default 7.5) -- when on, an IDLE worker whose Fusion session age passes
--     the threshold triggers its own re-login (one MFA push to approve)
--     instead of waiting for the operator. Applied at worker start.
--
--   Run in a FRESH SQLcl session as prod_mcp (ADMIN). Rerunnable.
--   Seeds are count-then-insert on purpose (Linux SQLcl swallows script-level
--   MERGE blocks). CRLF / UTF-8 no BOM.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED
SET ECHO ON

BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE prod.atd_worker_heartbeat ADD (paused CHAR(1))';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE prod.atd_worker_heartbeat ADD (session_account VARCHAR2(200))';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;
END;
/

CREATE OR REPLACE SYNONYM atd_worker_heartbeat FOR prod.atd_worker_heartbeat;
CREATE OR REPLACE SYNONYM atd_load_run_log FOR prod.atd_load_run_log;
CREATE OR REPLACE SYNONYM atd_load_run_phase FOR prod.atd_load_run_phase;

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'atd.rest',p_pattern=>'workers/:id/pause');
  ORDS.DEFINE_HANDLER(
    p_module_name=>'atd.rest',p_pattern=>'workers/:id/pause',p_method=>'POST',
    p_source_type=>ORDS.source_type_plsql,p_source=>q'!
DECLARE
  l_user VARCHAR2(100):=dct_rest.validate_session;
  l_id VARCHAR2(120):=:id; l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  IF LOWER(l_id)='all' THEN
    UPDATE atd_worker_heartbeat SET paused='Y';
  ELSE
    UPDATE atd_worker_heartbeat SET paused='Y' WHERE worker_id=l_id;
  END IF;
  l_n:=SQL%ROWCOUNT; COMMIT;
  IF l_n=0 THEN dct_rest.err(404,'Worker not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('ok',TRUE); APEX_JSON.write('requested',l_id); APEX_JSON.write('count',l_n);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500,SQLERRM);
END;!');

  ORDS.DEFINE_TEMPLATE(p_module_name=>'atd.rest',p_pattern=>'workers/:id/resume');
  ORDS.DEFINE_HANDLER(
    p_module_name=>'atd.rest',p_pattern=>'workers/:id/resume',p_method=>'POST',
    p_source_type=>ORDS.source_type_plsql,p_source=>q'!
DECLARE
  l_user VARCHAR2(100):=dct_rest.validate_session;
  l_id VARCHAR2(120):=:id; l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  IF LOWER(l_id)='all' THEN
    UPDATE atd_worker_heartbeat SET paused=NULL;
  ELSE
    UPDATE atd_worker_heartbeat SET paused=NULL WHERE worker_id=l_id;
  END IF;
  l_n:=SQL%ROWCOUNT; COMMIT;
  IF l_n=0 THEN dct_rest.err(404,'Worker not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('ok',TRUE); APEX_JSON.write('requested',l_id); APEX_JSON.write('count',l_n);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500,SQLERRM);
END;!');
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'atd.rest', p_pattern=>'workers');
  ORDS.DEFINE_HANDLER(
    p_module_name=>'atd.rest', p_pattern=>'workers', p_method=>'GET',
    p_source_type=>ORDS.source_type_plsql,
    p_source=>q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (
    WITH last_auth AS (
      SELECT host_id, duration_ms, phase_status,
             ROW_NUMBER() OVER (PARTITION BY host_id ORDER BY started DESC, p.run_id DESC) rn
        FROM atd_load_run_phase p
        JOIN atd_load_run_log l ON l.run_id=p.run_id
       WHERE p.phase_code='AUTHENTICATION'
    ), last_ok AS (
      SELECT host_id, MAX(finished) last_success
        FROM atd_load_run_log WHERE status='SUCCESS' GROUP BY host_id
    )
    SELECT h.worker_id, h.status, h.current_job, NVL(h.paused,'N') AS paused,
           h.session_account,
           TO_CHAR(dct_to_local(h.last_seen),'YYYY-MM-DD HH:MI:SS AM') last_seen_s,
           ROUND((CAST(SYSTIMESTAMP AS DATE)-CAST(h.last_seen AS DATE))*86400) age_sec,
           (SELECT COUNT(*) FROM atd_load_run_log l WHERE l.host_id=h.worker_id
             AND l.started>SYSTIMESTAMP-INTERVAL '1' DAY) runs24h,
           h.mfa_status,
           CASE WHEN h.mfa_status IN ('DETECTED','DELIVERED','FAILED') THEN h.mfa_number END mfa_number,
           h.mfa_env, TO_CHAR(dct_to_local(h.mfa_updated),'YYYY-MM-DD HH:MI:SS AM') mfa_updated_s,
           h.mfa_message_id, h.mfa_error,
           ROUND(a.duration_ms/1000,1) last_login_seconds, a.phase_status last_login_status,
           TO_CHAR(dct_to_local(o.last_success),'YYYY-MM-DD HH:MI:SS AM') last_success_s
      FROM atd_worker_heartbeat h
      LEFT JOIN last_auth a ON a.host_id=h.worker_id AND a.rn=1
      LEFT JOIN last_ok o ON o.host_id=h.worker_id
     ORDER BY h.worker_id
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('workerId',r.worker_id); APEX_JSON.write('status',NVL(r.status,''));
    APEX_JSON.write('currentJob',NVL(r.current_job,'')); APEX_JSON.write('lastSeen',NVL(r.last_seen_s,''));
    APEX_JSON.write('paused',r.paused);
    APEX_JSON.write('sessionAccount',NVL(r.session_account,''));
    APEX_JSON.write('ageSec',r.age_sec); APEX_JSON.write('online',CASE WHEN r.age_sec<=120 THEN 'Y' ELSE 'N' END);
    APEX_JSON.write('runs24h',r.runs24h); APEX_JSON.write('mfaStatus',NVL(r.mfa_status,''));
    APEX_JSON.write('mfaNumber',NVL(r.mfa_number,'')); APEX_JSON.write('mfaEnv',NVL(r.mfa_env,''));
    APEX_JSON.write('mfaUpdated',NVL(r.mfa_updated_s,'')); APEX_JSON.write('mfaMessageId',r.mfa_message_id);
    APEX_JSON.write('mfaError',NVL(r.mfa_error,''));
    IF r.last_login_seconds IS NULL THEN APEX_JSON.write('lastLoginSeconds','');
    ELSE APEX_JSON.write('lastLoginSeconds',r.last_login_seconds); END IF;
    APEX_JSON.write('lastLoginStatus',NVL(r.last_login_status,''));
    APEX_JSON.write('lastSuccess',NVL(r.last_success_s,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);
END;!');
  COMMIT;
END;
/

DECLARE
  l_n NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_n FROM prod.atd_runner_config
   WHERE config_key = 'ATD_AGE_RELOGIN';
  IF l_n = 0 THEN
    INSERT INTO prod.atd_runner_config
      (config_key, config_value, value_type, enum_values, description, display_order)
    VALUES
      ('ATD_AGE_RELOGIN', 'N', 'ENUM', 'Y,N',
       'Age-based auto re-login: when Y, an IDLE worker whose Fusion session is older than ' ||
       'ATD_AGE_RELOGIN_HOURS starts a fresh login by itself (approve the one MFA push when it ' ||
       'arrives) instead of waiting for an operator. Applied at worker start.',
       203);
  END IF;
END;
/

DECLARE
  l_n NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_n FROM prod.atd_runner_config
   WHERE config_key = 'ATD_AGE_RELOGIN_HOURS';
  IF l_n = 0 THEN
    INSERT INTO prod.atd_runner_config
      (config_key, config_value, value_type, enum_values, description, display_order)
    VALUES
      ('ATD_AGE_RELOGIN_HOURS', '7.5', 'NUMBER', NULL,
       'Session age (hours) that triggers the age-based auto re-login when ATD_AGE_RELOGIN=Y. ' ||
       'The Entra session lives ~8h; 7.5 renews it just before it dies. One attempt per session.',
       204);
  END IF;
END;
/

COMMIT;

SELECT t.uri_template, h.method
  FROM user_ords_templates t
  JOIN user_ords_handlers  h ON h.template_id = t.id
 WHERE t.uri_template IN ('workers','workers/:id/pause','workers/:id/resume')
 ORDER BY t.uri_template, h.method;

SELECT config_key, config_value FROM prod.atd_runner_config
 WHERE config_key IN ('ATD_AGE_RELOGIN','ATD_AGE_RELOGIN_HOURS');

PROMPT otbi-atd 85 worker pause + identity : done
