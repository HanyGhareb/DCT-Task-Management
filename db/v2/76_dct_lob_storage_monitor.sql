-- =============================================================================
-- i-Finance — Generated-report retention + PROD LOB storage monitoring
--
-- 1. Restores DCT_RPT_MAINT_JOB when missing. The existing DCT_RPT_MAINT
--    procedure deletes only expired DCT_RPT_OUTPUT rows using the Reporting UI
--    setting OUTPUT_RETAIN_DAYS. DCT_DOCUMENTS is never touched.
-- 2. Alerts active SYS_ADMIN users once when total PROD LOB segments reach the
--    configurable Admin setting LOB_STORAGE_ALERT_MB (default 1024 MB).
-- Additive and rerunnable. Run as ADMIN via sql -name prod_mcp.
-- =============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. Storage alert setting and state ===

BEGIN
  UPDATE prod.dct_system_settings
     SET value_type='NUMBER', category='DATA_MAINTENANCE', is_system='Y',
         description_en='Warn SYS_ADMIN when total PROD LOB storage reaches this size in MB (minimum 100).'
   WHERE setting_key='LOB_STORAGE_ALERT_MB';
  IF SQL%ROWCOUNT=0 THEN
    INSERT INTO prod.dct_system_settings
      (setting_key,setting_value,value_type,category,description_en,is_system,created_by)
    VALUES
      ('LOB_STORAGE_ALERT_MB','1024','NUMBER','DATA_MAINTENANCE',
       'Warn SYS_ADMIN when total PROD LOB storage reaches this size in MB (minimum 100).',
       'Y','SYSTEM');
  END IF;

  COMMIT;
END;
/

DECLARE
  l_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_count FROM dba_tables
   WHERE owner='PROD' AND table_name='DCT_STORAGE_ALERT_STATE';
  IF l_count=0 THEN
    EXECUTE IMMEDIATE
      'CREATE TABLE prod.dct_storage_alert_state (' ||
      'state_id NUMBER PRIMARY KEY,' ||
      'alert_active VARCHAR2(1) DEFAULT ''N'' NOT NULL,' ||
      'last_size_mb NUMBER,' ||
      'last_alert_at TIMESTAMP,' ||
      'updated_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,' ||
      'CONSTRAINT ck_dct_storage_alert_active CHECK (alert_active IN (''Y'',''N'')))';
  END IF;
END;
/

PROMPT === 2. LOB storage monitor package ===

CREATE OR REPLACE PACKAGE prod.dct_storage_health_pkg AUTHID DEFINER AS
  PROCEDURE check_storage;
END dct_storage_health_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_storage_health_pkg AS
  PROCEDURE check_storage IS
    l_size_mb   NUMBER;
    l_threshold NUMBER;
    l_active    VARCHAR2(1) := 'N';
  BEGIN
    SELECT ROUND(NVL(SUM(s.bytes),0)/1024/1024,1)
      INTO l_size_mb
      FROM user_segments s
      JOIN (
        SELECT segment_name FROM user_lobs
        UNION ALL
        SELECT index_name FROM user_lobs
      ) l ON l.segment_name=s.segment_name;

    BEGIN
      SELECT TO_NUMBER(setting_value DEFAULT 1024 ON CONVERSION ERROR)
        INTO l_threshold
        FROM prod.dct_system_settings
       WHERE setting_key='LOB_STORAGE_ALERT_MB';
    EXCEPTION WHEN NO_DATA_FOUND THEN l_threshold := 1024;
    END;
    l_threshold := GREATEST(100,NVL(l_threshold,1024));

    BEGIN
      SELECT alert_active INTO l_active
        FROM prod.dct_storage_alert_state WHERE state_id=1;
    EXCEPTION WHEN NO_DATA_FOUND THEN l_active := 'N';
    END;

    IF l_size_mb >= l_threshold AND l_active='N' THEN
      FOR u IN (
        SELECT DISTINCT usr.user_id
          FROM prod.dct_users usr
          JOIN prod.dct_user_roles ur ON ur.user_id=usr.user_id
          JOIN prod.dct_roles r ON r.role_id=ur.role_id
         WHERE r.role_code='SYS_ADMIN'
           AND r.is_active='Y' AND usr.is_active='Y' AND ur.is_active='Y'
           AND TRUNC(SYSDATE)>=TRUNC(ur.start_date)
           AND (ur.end_date IS NULL OR TRUNC(SYSDATE)<=TRUNC(ur.end_date))
      ) LOOP
        prod.dct_notify.send(
          u.user_id,'WARNING','Database file storage warning',
          'PROD LOB storage is '||l_size_mb||' MB and reached the configured '||
          l_threshold||' MB warning level. Review generated reports and document growth.',
          NULL,NULL,'ADMIN','/Admin/Jet/index.html#systemSettings');
      END LOOP;

      MERGE INTO prod.dct_storage_alert_state s
      USING (SELECT 1 state_id FROM dual) x ON (s.state_id=x.state_id)
      WHEN MATCHED THEN UPDATE SET
        s.alert_active='Y',s.last_size_mb=l_size_mb,
        s.last_alert_at=SYSTIMESTAMP,s.updated_at=SYSTIMESTAMP
      WHEN NOT MATCHED THEN INSERT
        (state_id,alert_active,last_size_mb,last_alert_at,updated_at)
        VALUES (1,'Y',l_size_mb,SYSTIMESTAMP,SYSTIMESTAMP);
    ELSIF l_size_mb < l_threshold*0.9 AND l_active='Y' THEN
      UPDATE prod.dct_storage_alert_state
         SET alert_active='N',last_size_mb=l_size_mb,updated_at=SYSTIMESTAMP
       WHERE state_id=1;
    ELSE
      MERGE INTO prod.dct_storage_alert_state s
      USING (SELECT 1 state_id FROM dual) x ON (s.state_id=x.state_id)
      WHEN MATCHED THEN UPDATE SET s.last_size_mb=l_size_mb,s.updated_at=SYSTIMESTAMP
      WHEN NOT MATCHED THEN INSERT
        (state_id,alert_active,last_size_mb,updated_at)
        VALUES (1,'N',l_size_mb,SYSTIMESTAMP);
    END IF;
    COMMIT;
  END check_storage;
END dct_storage_health_pkg;
/

PROMPT === 3. Restore generated-report maintenance job ===

DECLARE
  l_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_exists FROM dba_scheduler_jobs
   WHERE owner='PROD' AND job_name='DCT_RPT_MAINT_JOB';
  IF l_exists=0 THEN
    DBMS_SCHEDULER.CREATE_JOB(
      job_name=>'PROD.DCT_RPT_MAINT_JOB',
      job_type=>'STORED_PROCEDURE',
      job_action=>'PROD.DCT_RPT_MAINT',
      start_date=>SYSTIMESTAMP,
      repeat_interval=>'FREQ=MINUTELY;INTERVAL=15',
      enabled=>FALSE,auto_drop=>FALSE,
      comments=>'Reclaim stuck report runs and purge expired generated output BLOBs');
  ELSE
    DBMS_SCHEDULER.DISABLE('PROD.DCT_RPT_MAINT_JOB',force=>TRUE);
    DBMS_SCHEDULER.SET_ATTRIBUTE('PROD.DCT_RPT_MAINT_JOB','job_action','PROD.DCT_RPT_MAINT');
    DBMS_SCHEDULER.SET_ATTRIBUTE('PROD.DCT_RPT_MAINT_JOB','repeat_interval','FREQ=MINUTELY;INTERVAL=15');
  END IF;
  DBMS_SCHEDULER.ENABLE('PROD.DCT_RPT_MAINT_JOB');
END;
/

PROMPT === 4. Daily storage monitor job (00:30 Dubai) ===

DECLARE
  l_exists NUMBER;
  l_start TIMESTAMP WITH TIME ZONE;
BEGIN
  l_start:=TO_TIMESTAMP_TZ(
    TO_CHAR(SYSTIMESTAMP AT TIME ZONE 'Asia/Dubai'+INTERVAL '1' DAY,'YYYY-MM-DD')||
    ' 00:30:00 Asia/Dubai','YYYY-MM-DD HH24:MI:SS TZR');
  SELECT COUNT(*) INTO l_exists FROM dba_scheduler_jobs
   WHERE owner='PROD' AND job_name='DCT_STORAGE_HEALTH_JOB';
  IF l_exists=0 THEN
    DBMS_SCHEDULER.CREATE_JOB(
      job_name=>'PROD.DCT_STORAGE_HEALTH_JOB',job_type=>'STORED_PROCEDURE',
      job_action=>'PROD.DCT_STORAGE_HEALTH_PKG.CHECK_STORAGE',
      start_date=>l_start,repeat_interval=>'FREQ=DAILY;BYHOUR=0;BYMINUTE=30;BYSECOND=0',
      enabled=>FALSE,auto_drop=>FALSE,
      comments=>'Daily PROD LOB storage threshold check and SYS_ADMIN warning');
  ELSE
    DBMS_SCHEDULER.DISABLE('PROD.DCT_STORAGE_HEALTH_JOB',force=>TRUE);
    DBMS_SCHEDULER.SET_ATTRIBUTE('PROD.DCT_STORAGE_HEALTH_JOB','job_action',
                                 'PROD.DCT_STORAGE_HEALTH_PKG.CHECK_STORAGE');
    DBMS_SCHEDULER.SET_ATTRIBUTE('PROD.DCT_STORAGE_HEALTH_JOB','start_date',l_start);
    DBMS_SCHEDULER.SET_ATTRIBUTE('PROD.DCT_STORAGE_HEALTH_JOB','repeat_interval',
                                 'FREQ=DAILY;BYHOUR=0;BYMINUTE=30;BYSECOND=0');
  END IF;
  DBMS_SCHEDULER.ENABLE('PROD.DCT_STORAGE_HEALTH_JOB');
END;
/

PROMPT === 5. Live storage endpoint ===

CREATE OR REPLACE PROCEDURE admin.setup_dct_storage_health_ords_tmp AS
BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'dct.admin',p_pattern=>'maintenance/storage-health');
  ORDS.DEFINE_HANDLER(
    p_module_name=>'dct.admin',p_pattern=>'maintenance/storage-health',p_method=>'GET',
    p_source_type=>ORDS.source_type_plsql,
    p_source=>q'!
DECLARE
  l_user       VARCHAR2(100):=dct_rest.validate_session;
  l_total_mb   NUMBER;
  l_docs_mb    NUMBER;
  l_reports_mb NUMBER;
  l_threshold  NUMBER;
  l_percent    NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN may view database storage health'); RETURN;
  END IF;

  SELECT ROUND(NVL(SUM(s.bytes),0)/1024/1024,1),
         ROUND(NVL(SUM(CASE WHEN l.table_name='DCT_DOCUMENTS' THEN s.bytes ELSE 0 END),0)/1024/1024,1),
         ROUND(NVL(SUM(CASE WHEN l.table_name='DCT_RPT_OUTPUT' THEN s.bytes ELSE 0 END),0)/1024/1024,1)
    INTO l_total_mb,l_docs_mb,l_reports_mb
    FROM dba_segments s
    JOIN (
      SELECT table_name,segment_name FROM dba_lobs WHERE owner='PROD'
      UNION ALL
      SELECT table_name,index_name FROM dba_lobs WHERE owner='PROD'
    ) l ON l.segment_name=s.segment_name
   WHERE s.owner='PROD';
  BEGIN
    SELECT GREATEST(100,TO_NUMBER(setting_value DEFAULT 1024 ON CONVERSION ERROR))
      INTO l_threshold FROM dct_system_settings WHERE setting_key='LOB_STORAGE_ALERT_MB';
  EXCEPTION WHEN NO_DATA_FOUND THEN l_threshold:=1024;
  END;
  l_percent:=ROUND(l_total_mb/l_threshold*100,1);

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('currentMb',l_total_mb);
  APEX_JSON.write('thresholdMb',l_threshold);
  APEX_JSON.write('percent',l_percent);
  APEX_JSON.write('documentsMb',l_docs_mb);
  APEX_JSON.write('reportsMb',l_reports_mb);
  APEX_JSON.write('status',CASE WHEN l_total_mb>=l_threshold THEN 'WARNING' ELSE 'HEALTHY' END);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);
END;
!');
END;
/

BEGIN
  admin.setup_dct_storage_health_ords_tmp;
  COMMIT;
END;
/
DROP PROCEDURE admin.setup_dct_storage_health_ords_tmp;

PROMPT === 6. Verification ===
SELECT setting_key,setting_value,value_type,category FROM prod.dct_system_settings
 WHERE setting_key='LOB_STORAGE_ALERT_MB';
SELECT object_name,object_type,status FROM dba_objects
 WHERE owner='PROD' AND object_name='DCT_STORAGE_HEALTH_PKG' ORDER BY object_type;
SELECT owner,job_name,enabled,state,repeat_interval FROM dba_scheduler_jobs
 WHERE owner='PROD' AND job_name IN ('DCT_RPT_MAINT_JOB','DCT_STORAGE_HEALTH_JOB')
 ORDER BY job_name;

PROMPT db/v2/76 report retention and LOB storage monitor complete.
EXIT
