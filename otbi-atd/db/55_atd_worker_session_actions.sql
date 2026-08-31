-- Separate safe session validation from explicit forced re-login.
-- Rerunnable; additive ORDS handlers only.
SET DEFINE OFF
SET SERVEROUTPUT ON

BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE prod.atd_worker_heartbeat ADD (session_check_req TIMESTAMP)';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;
END;
/

CREATE OR REPLACE SYNONYM atd_worker_heartbeat FOR prod.atd_worker_heartbeat;

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'atd.rest',p_pattern=>'workers/:id/check-session');
  ORDS.DEFINE_HANDLER(
    p_module_name=>'atd.rest',p_pattern=>'workers/:id/check-session',p_method=>'POST',
    p_source_type=>ORDS.source_type_plsql,p_source=>q'!
DECLARE
  l_user VARCHAR2(100):=dct_rest.validate_session;
  l_id VARCHAR2(120):=:id; l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  IF LOWER(l_id)='all' THEN
    UPDATE atd_worker_heartbeat SET session_check_req=SYSTIMESTAMP,
      mfa_status='CHECKING',mfa_number=NULL,mfa_error=NULL,mfa_updated=SYSTIMESTAMP;
  ELSE
    UPDATE atd_worker_heartbeat SET session_check_req=SYSTIMESTAMP,
      mfa_status='CHECKING',mfa_number=NULL,mfa_error=NULL,mfa_updated=SYSTIMESTAMP
      WHERE worker_id=l_id;
  END IF;
  l_n:=SQL%ROWCOUNT; COMMIT;
  IF l_n=0 THEN dct_rest.err(404,'Worker not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('ok',TRUE); APEX_JSON.write('requested',l_id); APEX_JSON.write('count',l_n);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500,SQLERRM);
END;!');

  -- Replace the existing force handler so the UI immediately shows REQUESTED.
  ORDS.DEFINE_TEMPLATE(p_module_name=>'atd.rest',p_pattern=>'workers/:id/refresh');
  ORDS.DEFINE_HANDLER(
    p_module_name=>'atd.rest',p_pattern=>'workers/:id/refresh',p_method=>'POST',
    p_source_type=>ORDS.source_type_plsql,p_source=>q'!
DECLARE
  l_user VARCHAR2(100):=dct_rest.validate_session;
  l_id VARCHAR2(120):=:id; l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  IF LOWER(l_id)='all' THEN
    UPDATE atd_worker_heartbeat SET refresh_req=SYSTIMESTAMP,
      mfa_status='REQUESTED',mfa_number=NULL,mfa_error=NULL,mfa_updated=SYSTIMESTAMP;
  ELSE
    UPDATE atd_worker_heartbeat SET refresh_req=SYSTIMESTAMP,
      mfa_status='REQUESTED',mfa_number=NULL,mfa_error=NULL,mfa_updated=SYSTIMESTAMP
      WHERE worker_id=l_id;
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
