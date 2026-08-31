-- MFA delivery fallback on the existing Worker Fleet dashboard.
-- Rerunnable: adds status columns, then replaces only GET /atd/workers.
SET DEFINE OFF
SET SERVEROUTPUT ON

CREATE OR REPLACE SYNONYM atd_load_run_log FOR prod.atd_load_run_log;
CREATE OR REPLACE SYNONYM atd_load_run_phase FOR prod.atd_load_run_phase;

BEGIN
  FOR c IN (
    SELECT 'MFA_STATUS' n, 'VARCHAR2(20)' d FROM dual UNION ALL
    SELECT 'MFA_NUMBER', 'VARCHAR2(10)' FROM dual UNION ALL
    SELECT 'MFA_ENV', 'VARCHAR2(100)' FROM dual UNION ALL
    SELECT 'MFA_DETECTED', 'TIMESTAMP' FROM dual UNION ALL
    SELECT 'MFA_DELIVERED', 'TIMESTAMP' FROM dual UNION ALL
    SELECT 'MFA_MESSAGE_ID', 'NUMBER' FROM dual UNION ALL
    SELECT 'MFA_ERROR', 'VARCHAR2(1000)' FROM dual UNION ALL
    SELECT 'MFA_UPDATED', 'TIMESTAMP' FROM dual
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'ALTER TABLE prod.atd_worker_heartbeat ADD ('||c.n||' '||c.d||')';
    EXCEPTION WHEN OTHERS THEN
      IF SQLCODE != -1430 THEN RAISE; END IF;
    END;
  END LOOP;
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
      SELECT l.host_id, p.duration_ms, p.phase_status,
             ROW_NUMBER() OVER (PARTITION BY l.host_id ORDER BY l.started DESC, p.run_id DESC) rn
        FROM atd_load_run_phase p JOIN atd_load_run_log l ON l.run_id=p.run_id
       WHERE p.phase_code='AUTHENTICATION'
    ), last_ok AS (
      SELECT host_id, MAX(finished) last_success
        FROM atd_load_run_log WHERE status='SUCCESS' GROUP BY host_id
    )
    SELECT h.worker_id, h.status, h.current_job,
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
