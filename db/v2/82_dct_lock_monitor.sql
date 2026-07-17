-- =============================================================================
-- i-Finance — PROD blocking-session monitor
-- Uses live GV$SESSION data only (no AWR), stores the current blocking state,
-- warns SYS_ADMIN after a configurable wait, and never terminates sessions.
-- =============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SELECT 1 FROM dual;
SELECT 1 FROM dual;

PROMPT === 1. Setting and narrow ADMIN blocking-session view ===

BEGIN
  MERGE INTO prod.dct_system_settings s
  USING (SELECT 'DB_LOCK_ALERT_SECONDS' k,'120' v,
                'Warn SYS_ADMIN when a PROD database session is blocked for this many seconds (minimum 30).' d
           FROM dual) x ON (s.setting_key=x.k)
  WHEN MATCHED THEN UPDATE SET s.value_type='NUMBER',s.category='DATA_MAINTENANCE',
    s.is_system='Y',s.description_en=x.d
  WHEN NOT MATCHED THEN INSERT
    (setting_key,setting_value,value_type,category,description_en,is_system,created_by)
    VALUES(x.k,x.v,'NUMBER','DATA_MAINTENANCE',x.d,'Y','SYSTEM');
  COMMIT;
END;
/

CREATE OR REPLACE VIEW admin.dct_prod_blocking_session_v AS
SELECT w.inst_id waiting_instance,w.sid waiting_sid,w.serial# waiting_serial,
       w.sql_id waiting_sql_id,NVL(w.module,'Unknown') waiting_module,
       w.event wait_event,w.seconds_in_wait wait_seconds,
       NVL(w.blocking_instance,w.inst_id) blocker_instance,w.blocking_session blocker_sid,
       b.serial# blocker_serial,b.sql_id blocker_sql_id,NVL(b.module,'Unknown') blocker_module,
       NVL(o.object_name,'Unknown') object_name,NVL(o.object_type,'Unknown') object_type
  FROM gv$session w
  LEFT JOIN gv$session b ON b.inst_id=NVL(w.blocking_instance,w.inst_id)
                         AND b.sid=w.blocking_session
  LEFT JOIN dba_objects o ON o.owner='PROD' AND o.object_id=w.row_wait_obj#
 WHERE w.blocking_session IS NOT NULL
   AND w.wait_class<>'Idle'
   AND (w.username='PROD' OR b.username='PROD');

GRANT SELECT ON admin.dct_prod_blocking_session_v TO prod;

PROMPT === 2. Current lock state ===

DECLARE l_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_count FROM dba_tables WHERE owner='PROD' AND table_name='DCT_LOCK_CURRENT';
  IF l_count=0 THEN
    EXECUTE IMMEDIATE q'[
      CREATE TABLE prod.dct_lock_current (
        waiting_instance NUMBER NOT NULL, waiting_sid NUMBER NOT NULL, waiting_serial NUMBER NOT NULL,
        waiting_sql_id VARCHAR2(13), waiting_module VARCHAR2(100), wait_event VARCHAR2(200),
        wait_seconds NUMBER NOT NULL, blocker_instance NUMBER, blocker_sid NUMBER,
        blocker_serial NUMBER, blocker_sql_id VARCHAR2(13), blocker_module VARCHAR2(100),
        object_name VARCHAR2(128), object_type VARCHAR2(30), captured_at TIMESTAMP WITH TIME ZONE NOT NULL,
        CONSTRAINT pk_dct_lock_current PRIMARY KEY(waiting_instance,waiting_sid,waiting_serial)
      )]';
  END IF;
END;
/

DECLARE l_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_count FROM dba_tables WHERE owner='PROD' AND table_name='DCT_LOCK_STATE';
  IF l_count=0 THEN
    EXECUTE IMMEDIATE q'[
      CREATE TABLE prod.dct_lock_state (
        state_id NUMBER NOT NULL,checked_at TIMESTAMP WITH TIME ZONE NOT NULL,
        checked_by VARCHAR2(100) NOT NULL,lock_status VARCHAR2(10) NOT NULL,
        blocked_count NUMBER DEFAULT 0 NOT NULL,longest_wait_seconds NUMBER DEFAULT 0 NOT NULL,
        alert_seconds NUMBER NOT NULL,issue_signature VARCHAR2(200),alerted_signature VARCHAR2(200),
        last_alert_at TIMESTAMP WITH TIME ZONE,
        CONSTRAINT pk_dct_lock_state PRIMARY KEY(state_id),
        CONSTRAINT ck_dct_lock_status CHECK(lock_status IN('HEALTHY','WARNING'))
      )]';
  END IF;
END;
/

PROMPT === 3. Read-only capture package ===

CREATE OR REPLACE PACKAGE prod.dct_lock_monitor_pkg AUTHID DEFINER AS
  PROCEDURE capture;
  PROCEDURE run_capture(p_checked_by VARCHAR2);
END dct_lock_monitor_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_lock_monitor_pkg AS
  PROCEDURE perform_capture(p_checked_by VARCHAR2) IS
    l_alert NUMBER:=120;l_count NUMBER:=0;l_longest NUMBER:=0;l_over NUMBER:=0;
    l_sig VARCHAR2(200);l_prev VARCHAR2(200);l_status VARCHAR2(10);
  BEGIN
    BEGIN
      SELECT GREATEST(30,TO_NUMBER(setting_value DEFAULT 120 ON CONVERSION ERROR)) INTO l_alert
        FROM prod.dct_system_settings WHERE setting_key='DB_LOCK_ALERT_SECONDS';
    EXCEPTION WHEN NO_DATA_FOUND THEN l_alert:=120; END;
    DELETE FROM prod.dct_lock_current;
    INSERT INTO prod.dct_lock_current
      (waiting_instance,waiting_sid,waiting_serial,waiting_sql_id,waiting_module,wait_event,
       wait_seconds,blocker_instance,blocker_sid,blocker_serial,blocker_sql_id,blocker_module,
       object_name,object_type,captured_at)
    SELECT waiting_instance,waiting_sid,waiting_serial,waiting_sql_id,waiting_module,wait_event,
           wait_seconds,blocker_instance,blocker_sid,blocker_serial,blocker_sql_id,blocker_module,
           object_name,object_type,SYSTIMESTAMP
      FROM admin.dct_prod_blocking_session_v;
    SELECT COUNT(*),NVL(MAX(wait_seconds),0) INTO l_count,l_longest FROM prod.dct_lock_current;
    SELECT COUNT(*),l_count||':'||NVL(SUM(ORA_HASH(waiting_instance||':'||waiting_sid||':'||blocker_sid)),0)
      INTO l_over,l_sig FROM prod.dct_lock_current WHERE wait_seconds>=l_alert;
    l_status:=CASE WHEN l_over>0 THEN 'WARNING' ELSE 'HEALTHY' END;
    BEGIN SELECT alerted_signature INTO l_prev FROM prod.dct_lock_state WHERE state_id=1;
    EXCEPTION WHEN NO_DATA_FOUND THEN l_prev:=NULL; END;
    IF l_status='WARNING' AND NVL(l_prev,'-')<>l_sig THEN
      FOR u IN (
        SELECT DISTINCT usr.user_id FROM prod.dct_users usr
          JOIN prod.dct_user_roles ur ON ur.user_id=usr.user_id
          JOIN prod.dct_roles ro ON ro.role_id=ur.role_id
         WHERE ro.role_code='SYS_ADMIN' AND ro.is_active='Y' AND usr.is_active='Y' AND ur.is_active='Y'
           AND TRUNC(SYSDATE)>=TRUNC(ur.start_date)
           AND (ur.end_date IS NULL OR TRUNC(SYSDATE)<=TRUNC(ur.end_date))
      ) LOOP
        prod.dct_notify.send(u.user_id,'WARNING','Database session blocked',
          l_count||' session(s) are blocked. Longest current wait: '||l_longest||
          ' seconds. No session was terminated automatically.',
          NULL,NULL,'ADMIN','/Admin/Jet/index.html#systemSettings');
      END LOOP;
    END IF;
    MERGE INTO prod.dct_lock_state s USING(SELECT 1 state_id FROM dual)x ON(s.state_id=x.state_id)
    WHEN MATCHED THEN UPDATE SET s.checked_at=SYSTIMESTAMP,s.checked_by=SUBSTR(NVL(p_checked_by,'SYSTEM'),1,100),
      s.lock_status=l_status,s.blocked_count=l_count,s.longest_wait_seconds=l_longest,
      s.alert_seconds=l_alert,s.issue_signature=l_sig,
      s.alerted_signature=CASE WHEN l_status='WARNING' THEN l_sig ELSE NULL END,
      s.last_alert_at=CASE WHEN l_status='WARNING' AND NVL(l_prev,'-')<>l_sig THEN SYSTIMESTAMP ELSE s.last_alert_at END
    WHEN NOT MATCHED THEN INSERT
      (state_id,checked_at,checked_by,lock_status,blocked_count,longest_wait_seconds,alert_seconds,
       issue_signature,alerted_signature,last_alert_at)
    VALUES(1,SYSTIMESTAMP,SUBSTR(NVL(p_checked_by,'SYSTEM'),1,100),l_status,l_count,l_longest,l_alert,
      l_sig,CASE WHEN l_status='WARNING' THEN l_sig END,CASE WHEN l_status='WARNING' THEN SYSTIMESTAMP END);
    COMMIT;
  EXCEPTION WHEN OTHERS THEN ROLLBACK;RAISE;
  END;
  PROCEDURE capture IS BEGIN perform_capture('SCHEDULER');END;
  PROCEDURE run_capture(p_checked_by VARCHAR2) IS BEGIN perform_capture(p_checked_by);END;
END dct_lock_monitor_pkg;
/

CREATE OR REPLACE PROCEDURE prod.grant_dct_lock_monitor_tmp AUTHID DEFINER AS
BEGIN
  EXECUTE IMMEDIATE 'GRANT SELECT ON prod.dct_lock_current TO admin';
  EXECUTE IMMEDIATE 'GRANT SELECT ON prod.dct_lock_state TO admin';
  EXECUTE IMMEDIATE 'GRANT EXECUTE ON prod.dct_lock_monitor_pkg TO admin';
END;
/
BEGIN prod.grant_dct_lock_monitor_tmp;END;
/
DROP PROCEDURE prod.grant_dct_lock_monitor_tmp;

PROMPT === 4. One-minute monitor job ===

DECLARE l_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_exists FROM dba_scheduler_jobs WHERE owner='PROD' AND job_name='DCT_LOCK_MONITOR_JOB';
  IF l_exists=0 THEN
    DBMS_SCHEDULER.CREATE_JOB(job_name=>'PROD.DCT_LOCK_MONITOR_JOB',job_type=>'STORED_PROCEDURE',
      job_action=>'PROD.DCT_LOCK_MONITOR_PKG.CAPTURE',start_date=>SYSTIMESTAMP,
      repeat_interval=>'FREQ=MINUTELY;INTERVAL=1',enabled=>FALSE,auto_drop=>FALSE,
      comments=>'Read-only PROD blocking-session monitor and SYS_ADMIN warning');
  ELSE
    DBMS_SCHEDULER.DISABLE('PROD.DCT_LOCK_MONITOR_JOB',force=>TRUE);
    DBMS_SCHEDULER.SET_ATTRIBUTE('PROD.DCT_LOCK_MONITOR_JOB','job_action','PROD.DCT_LOCK_MONITOR_PKG.CAPTURE');
    DBMS_SCHEDULER.SET_ATTRIBUTE('PROD.DCT_LOCK_MONITOR_JOB','repeat_interval','FREQ=MINUTELY;INTERVAL=1');
  END IF;
  DBMS_SCHEDULER.ENABLE('PROD.DCT_LOCK_MONITOR_JOB');
END;
/
BEGIN prod.dct_lock_monitor_pkg.capture;END;
/

PROMPT === 5. SYS_ADMIN lock endpoints ===

CREATE OR REPLACE PROCEDURE admin.setup_dct_lock_monitor_ords_tmp AS
BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'dct.admin',p_pattern=>'maintenance/database-locks');
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin',p_pattern=>'maintenance/database-locks',p_method=>'GET',
    p_source_type=>ORDS.source_type_plsql,p_source=>q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;l_state prod.dct_lock_state%ROWTYPE;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Only SYS_ADMIN may view database locks');RETURN;END IF;
  SELECT * INTO l_state FROM prod.dct_lock_state WHERE state_id=1;
  dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
  APEX_JSON.write('status',l_state.lock_status);APEX_JSON.write('blockedCount',l_state.blocked_count);
  APEX_JSON.write('longestWaitSeconds',l_state.longest_wait_seconds);APEX_JSON.write('alertSeconds',l_state.alert_seconds);
  APEX_JSON.write('checkedAt',TO_CHAR(l_state.checked_at AT TIME ZONE 'Asia/Dubai','YYYY-MM-DD HH24:MI:SS'));
  APEX_JSON.open_array('items');
  FOR r IN(SELECT * FROM prod.dct_lock_current ORDER BY wait_seconds DESC)LOOP
    APEX_JSON.open_object;APEX_JSON.write('waitingSession',r.waiting_instance||':'||r.waiting_sid||','||r.waiting_serial);
    APEX_JSON.write('waitingSqlId',r.waiting_sql_id);APEX_JSON.write('waitingModule',r.waiting_module);
    APEX_JSON.write('blockerSession',r.blocker_instance||':'||r.blocker_sid||','||r.blocker_serial);
    APEX_JSON.write('blockerInstance',r.blocker_instance);APEX_JSON.write('blockerSid',r.blocker_sid);
    APEX_JSON.write('blockerSerial',r.blocker_serial);
    APEX_JSON.write('blockerSqlId',r.blocker_sql_id);APEX_JSON.write('blockerModule',r.blocker_module);
    APEX_JSON.write('objectName',r.object_name);APEX_JSON.write('objectType',r.object_type);
    APEX_JSON.write('waitEvent',r.wait_event);APEX_JSON.write('waitSeconds',r.wait_seconds);APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;
!');
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin',p_pattern=>'maintenance/database-locks',p_method=>'POST',
    p_source_type=>ORDS.source_type_plsql,p_source=>q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;l_state prod.dct_lock_state%ROWTYPE;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Only SYS_ADMIN may refresh database locks');RETURN;END IF;
  prod.dct_lock_monitor_pkg.run_capture(l_user);SELECT * INTO l_state FROM prod.dct_lock_state WHERE state_id=1;
  dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
  APEX_JSON.write('status',l_state.lock_status);APEX_JSON.write('blockedCount',l_state.blocked_count);
  APEX_JSON.write('checkedAt',TO_CHAR(l_state.checked_at AT TIME ZONE 'Asia/Dubai','YYYY-MM-DD HH24:MI:SS'));
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;
!');

  ORDS.DEFINE_TEMPLATE(p_module_name=>'dct.admin',p_pattern=>'maintenance/database-locks/terminate');
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin',p_pattern=>'maintenance/database-locks/terminate',p_method=>'POST',
    p_source_type=>ORDS.source_type_plsql,p_source=>q'!
DECLARE
  l_user VARCHAR2(100):=dct_rest.validate_session;
  l_instance NUMBER;l_sid NUMBER;l_serial NUMBER;l_count NUMBER;l_reason VARCHAR2(500);
  l_ref VARCHAR2(500);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Only SYS_ADMIN may terminate a blocking session');RETURN;END IF;
  dct_rest.parse_body(:body);
  l_instance:=APEX_JSON.get_number(p_path=>'instanceId');
  l_sid:=APEX_JSON.get_number(p_path=>'sid');
  l_serial:=APEX_JSON.get_number(p_path=>'serial');
  l_reason:=TRIM(APEX_JSON.get_varchar2(p_path=>'reason'));
  IF l_instance IS NULL OR l_sid IS NULL OR l_serial IS NULL THEN
    dct_rest.err(400,'The blocker instance, SID and serial are required');RETURN;
  END IF;
  IF l_reason IS NULL OR LENGTH(l_reason)<10 THEN
    dct_rest.err(400,'A termination reason of at least 10 characters is required');RETURN;
  END IF;
  SELECT COUNT(*) INTO l_count FROM admin.dct_prod_blocking_session_v
   WHERE blocker_instance=l_instance AND blocker_sid=l_sid AND blocker_serial=l_serial;
  IF l_count=0 THEN
    dct_rest.err(409,'The session is no longer an active blocker. Refresh lock status.');RETURN;
  END IF;
  l_ref:='Blocker '||l_instance||':'||l_sid||','||l_serial||' — '||SUBSTR(l_reason,1,400);
  EXECUTE IMMEDIATE 'ALTER SYSTEM KILL SESSION '''||TO_CHAR(l_sid)||','||TO_CHAR(l_serial)||',@'||TO_CHAR(l_instance)||''' IMMEDIATE';
  prod.dct_audit_pkg.log(l_user,'TERMINATE','DATABASE_SESSION',
    l_instance||':'||l_sid||','||l_serial,'ADMIN',l_ref,NULL,NULL,'SUCCESS',NULL);
  BEGIN prod.dct_lock_monitor_pkg.run_capture(l_user);EXCEPTION WHEN OTHERS THEN NULL;END;
  dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
  APEX_JSON.write('terminated',TRUE);APEX_JSON.write('session',l_instance||':'||l_sid||','||l_serial);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  prod.dct_audit_pkg.log(l_user,'TERMINATE','DATABASE_SESSION',
    NVL(TO_CHAR(l_instance),'?')||':'||NVL(TO_CHAR(l_sid),'?')||','||NVL(TO_CHAR(l_serial),'?'),
    'ADMIN',l_ref,NULL,NULL,'FAILURE',SQLERRM);
  dct_rest.err(500,SQLERRM);
END;
!');
END;
/
BEGIN admin.setup_dct_lock_monitor_ords_tmp;COMMIT;END;
/
DROP PROCEDURE admin.setup_dct_lock_monitor_ords_tmp;

PROMPT === 6. Verification ===
SELECT lock_status,blocked_count,longest_wait_seconds,alert_seconds FROM prod.dct_lock_state;
SELECT object_name,object_type,status FROM dba_objects WHERE owner='PROD' AND object_name='DCT_LOCK_MONITOR_PKG';
SELECT owner,job_name,enabled,state,repeat_interval,next_run_date FROM dba_scheduler_jobs
 WHERE owner='PROD' AND job_name='DCT_LOCK_MONITOR_JOB';
PROMPT db/v2/82 blocking-session monitor complete.
EXIT
