-- =============================================================================
-- i-Finance — PROD schema storage growth history
-- Daily full-schema and per-table snapshots, one-year retention, unusual-growth
-- warning, and SYS_ADMIN ORDS summary. Additive and rerunnable.
-- Run as ADMIN via: sql -name prod_mcp @db/v2/78_dct_storage_growth_history.sql
-- =============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

-- SQLcl named connections can consume the first executable statement; keep
-- this harmless query first so the settings MERGE below always runs.
SELECT 1 FROM dual;
SELECT 1 FROM dual;

PROMPT === 1. Configurable history and alert settings ===

BEGIN
  MERGE INTO prod.dct_system_settings s
  USING (
    SELECT 'STORAGE_HISTORY_RETENTION_DAYS' setting_key, '365' setting_value,
           'Keep daily database storage history for this many days (minimum 30).' description_en
      FROM dual
    UNION ALL
    SELECT 'STORAGE_DAILY_GROWTH_ALERT_MB', '100',
           'Warn SYS_ADMIN when the PROD schema grows by this many MB in one day (minimum 10).'
      FROM dual
  ) x ON (s.setting_key=x.setting_key)
  WHEN MATCHED THEN UPDATE SET
    s.value_type='NUMBER',s.category='DATA_MAINTENANCE',s.is_system='Y',
    s.description_en=x.description_en
  WHEN NOT MATCHED THEN INSERT
    (setting_key,setting_value,value_type,category,description_en,is_system,created_by)
  VALUES (x.setting_key,x.setting_value,'NUMBER','DATA_MAINTENANCE',x.description_en,'Y','SYSTEM');
  COMMIT;
END;
/

PROMPT === 2. Snapshot tables ===

DECLARE
  l_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_count FROM dba_tables
   WHERE owner='PROD' AND table_name='DCT_STORAGE_SNAPSHOT';
  IF l_count=0 THEN
    EXECUTE IMMEDIATE q'[
      CREATE TABLE prod.dct_storage_snapshot (
        snapshot_date   DATE NOT NULL,
        total_schema_mb NUMBER(18,2) NOT NULL,
        total_lob_mb    NUMBER(18,2) NOT NULL,
        created_at      TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
        CONSTRAINT pk_dct_storage_snapshot PRIMARY KEY (snapshot_date)
      )]';
  END IF;
END;
/

DECLARE
  l_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_count FROM dba_tables
   WHERE owner='PROD' AND table_name='DCT_STORAGE_OBJECT_SNAPSHOT';
  IF l_count=0 THEN
    EXECUTE IMMEDIATE q'[
      CREATE TABLE prod.dct_storage_object_snapshot (
        snapshot_date DATE NOT NULL,
        table_name    VARCHAR2(128) NOT NULL,
        size_mb       NUMBER(18,2) NOT NULL,
        created_at    TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
        CONSTRAINT pk_dct_storage_object_snapshot PRIMARY KEY (snapshot_date,table_name),
        CONSTRAINT fk_dct_storage_object_snapshot FOREIGN KEY (snapshot_date)
          REFERENCES prod.dct_storage_snapshot(snapshot_date) ON DELETE CASCADE
      )]';
  END IF;
END;
/

CREATE OR REPLACE PROCEDURE prod.grant_dct_storage_history_tmp AUTHID DEFINER AS
BEGIN
  EXECUTE IMMEDIATE 'GRANT SELECT ON prod.dct_storage_snapshot TO admin';
  EXECUTE IMMEDIATE 'GRANT SELECT ON prod.dct_storage_object_snapshot TO admin';
END;
/
BEGIN prod.grant_dct_storage_history_tmp; END;
/
DROP PROCEDURE prod.grant_dct_storage_history_tmp;

PROMPT === 3. Daily capture package ===

CREATE OR REPLACE PACKAGE prod.dct_storage_history_pkg AUTHID DEFINER AS
  PROCEDURE capture_snapshot;
END dct_storage_history_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_storage_history_pkg AS
  FUNCTION setting_number(p_key VARCHAR2,p_default NUMBER,p_min NUMBER) RETURN NUMBER IS
    l_value NUMBER;
  BEGIN
    SELECT TO_NUMBER(setting_value DEFAULT p_default ON CONVERSION ERROR)
      INTO l_value FROM prod.dct_system_settings WHERE setting_key=p_key;
    RETURN GREATEST(p_min,NVL(l_value,p_default));
  EXCEPTION WHEN NO_DATA_FOUND THEN RETURN p_default;
  END;

  PROCEDURE capture_snapshot IS
    l_day          DATE:=TRUNC(CAST(SYSTIMESTAMP AT TIME ZONE 'Asia/Dubai' AS DATE));
    l_total_mb     NUMBER;
    l_lob_mb       NUMBER;
    l_previous_mb  NUMBER;
    l_growth_mb    NUMBER;
    l_alert_mb     NUMBER;
    l_retention    NUMBER;
    l_is_new       NUMBER:=0;
  BEGIN
    SELECT ROUND(NVL(SUM(bytes),0)/1024/1024,2)
      INTO l_total_mb FROM user_segments;
    SELECT ROUND(NVL(SUM(s.bytes),0)/1024/1024,2)
      INTO l_lob_mb
      FROM user_segments s
      JOIN (
        SELECT segment_name FROM user_lobs
        UNION ALL
        SELECT index_name FROM user_lobs
      ) l ON l.segment_name=s.segment_name;

    BEGIN
      SELECT total_schema_mb INTO l_previous_mb
        FROM prod.dct_storage_snapshot
       WHERE snapshot_date=(SELECT MAX(snapshot_date) FROM prod.dct_storage_snapshot WHERE snapshot_date<l_day);
    EXCEPTION WHEN NO_DATA_FOUND THEN l_previous_mb:=NULL;
    END;

    SELECT CASE WHEN COUNT(*)=0 THEN 1 ELSE 0 END INTO l_is_new
      FROM prod.dct_storage_snapshot WHERE snapshot_date=l_day;

    MERGE INTO prod.dct_storage_snapshot s
    USING (SELECT l_day snapshot_date,l_total_mb total_schema_mb,l_lob_mb total_lob_mb FROM dual) x
       ON (s.snapshot_date=x.snapshot_date)
    WHEN MATCHED THEN UPDATE SET s.total_schema_mb=x.total_schema_mb,s.total_lob_mb=x.total_lob_mb,
                                 s.created_at=SYSTIMESTAMP
    WHEN NOT MATCHED THEN INSERT (snapshot_date,total_schema_mb,total_lob_mb,created_at)
      VALUES (x.snapshot_date,x.total_schema_mb,x.total_lob_mb,SYSTIMESTAMP);

    DELETE FROM prod.dct_storage_object_snapshot WHERE snapshot_date=l_day;
    INSERT INTO prod.dct_storage_object_snapshot(snapshot_date,table_name,size_mb)
    SELECT l_day,m.table_name,ROUND(SUM(s.bytes)/1024/1024,2)
      FROM user_segments s
      JOIN (
        SELECT table_name,table_name segment_name,NULL partition_name,'TABLE' segment_type
          FROM user_tables WHERE partitioned='NO'
        UNION ALL
        SELECT table_name,index_name,NULL,'INDEX'
          FROM user_indexes WHERE partitioned='NO' AND index_type<>'LOB'
        UNION ALL
        SELECT table_name,segment_name,NULL,'LOBSEGMENT' FROM user_lobs
        UNION ALL
        SELECT table_name,index_name,NULL,'LOBINDEX' FROM user_lobs
        UNION ALL
        SELECT table_name,table_name,partition_name,'TABLE PARTITION' FROM user_tab_partitions
        UNION ALL
        SELECT i.table_name,p.index_name,p.partition_name,'INDEX PARTITION'
          FROM user_ind_partitions p JOIN user_indexes i ON i.index_name=p.index_name
      ) m ON m.segment_name=s.segment_name
          AND m.segment_type=s.segment_type
          AND (m.partition_name=s.partition_name OR (m.partition_name IS NULL AND s.partition_name IS NULL))
     GROUP BY table_name;

    l_retention:=setting_number('STORAGE_HISTORY_RETENTION_DAYS',365,30);
    DELETE FROM prod.dct_storage_snapshot WHERE snapshot_date<l_day-l_retention;

    l_growth_mb:=ROUND(l_total_mb-l_previous_mb,2);
    l_alert_mb:=setting_number('STORAGE_DAILY_GROWTH_ALERT_MB',100,10);
    IF l_is_new=1 AND l_previous_mb IS NOT NULL AND l_growth_mb>=l_alert_mb THEN
      FOR u IN (
        SELECT DISTINCT usr.user_id
          FROM prod.dct_users usr
          JOIN prod.dct_user_roles ur ON ur.user_id=usr.user_id
          JOIN prod.dct_roles r ON r.role_id=ur.role_id
         WHERE r.role_code='SYS_ADMIN' AND r.is_active='Y' AND usr.is_active='Y' AND ur.is_active='Y'
           AND TRUNC(SYSDATE)>=TRUNC(ur.start_date)
           AND (ur.end_date IS NULL OR TRUNC(SYSDATE)<=TRUNC(ur.end_date))
      ) LOOP
        prod.dct_notify.send(u.user_id,'WARNING','Unusual database growth',
          'The PROD schema grew by '||TO_CHAR(l_growth_mb)||' MB since the previous daily snapshot. '||
          'The configured warning level is '||TO_CHAR(l_alert_mb)||' MB.',
          NULL,NULL,'ADMIN','/Admin/Jet/index.html#systemSettings');
      END LOOP;
    END IF;
    COMMIT;
  END capture_snapshot;
END dct_storage_history_pkg;
/

PROMPT === 4. Daily 00:45 Dubai scheduler job ===

DECLARE
  l_exists NUMBER;
  l_start TIMESTAMP WITH TIME ZONE;
BEGIN
  l_start:=TO_TIMESTAMP_TZ(
    TO_CHAR(SYSTIMESTAMP AT TIME ZONE 'Asia/Dubai'+INTERVAL '1' DAY,'YYYY-MM-DD')||
    ' 00:45:00 Asia/Dubai','YYYY-MM-DD HH24:MI:SS TZR');
  SELECT COUNT(*) INTO l_exists FROM dba_scheduler_jobs
   WHERE owner='PROD' AND job_name='DCT_STORAGE_HISTORY_JOB';
  IF l_exists=0 THEN
    DBMS_SCHEDULER.CREATE_JOB(
      job_name=>'PROD.DCT_STORAGE_HISTORY_JOB',job_type=>'STORED_PROCEDURE',
      job_action=>'PROD.DCT_STORAGE_HISTORY_PKG.CAPTURE_SNAPSHOT',
      start_date=>l_start,repeat_interval=>'FREQ=DAILY;BYHOUR=0;BYMINUTE=45;BYSECOND=0',
      enabled=>FALSE,auto_drop=>FALSE,
      comments=>'Daily PROD schema/table storage snapshot, retention and unusual-growth alert');
  ELSE
    DBMS_SCHEDULER.DISABLE('PROD.DCT_STORAGE_HISTORY_JOB',force=>TRUE);
    DBMS_SCHEDULER.SET_ATTRIBUTE('PROD.DCT_STORAGE_HISTORY_JOB','job_action',
                                 'PROD.DCT_STORAGE_HISTORY_PKG.CAPTURE_SNAPSHOT');
    DBMS_SCHEDULER.SET_ATTRIBUTE('PROD.DCT_STORAGE_HISTORY_JOB','start_date',l_start);
    DBMS_SCHEDULER.SET_ATTRIBUTE('PROD.DCT_STORAGE_HISTORY_JOB','repeat_interval',
                                 'FREQ=DAILY;BYHOUR=0;BYMINUTE=45;BYSECOND=0');
  END IF;
  DBMS_SCHEDULER.ENABLE('PROD.DCT_STORAGE_HISTORY_JOB');
END;
/

BEGIN
  prod.dct_storage_history_pkg.capture_snapshot;
END;
/

PROMPT === 5. SYS_ADMIN storage-history endpoint ===

CREATE OR REPLACE PROCEDURE admin.setup_dct_storage_history_ords_tmp AS
BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'dct.admin',p_pattern=>'maintenance/storage-history');
  ORDS.DEFINE_HANDLER(
    p_module_name=>'dct.admin',p_pattern=>'maintenance/storage-history',p_method=>'GET',
    p_source_type=>ORDS.source_type_plsql,
    p_source=>q'!
DECLARE
  l_user        VARCHAR2(100):=dct_rest.validate_session;
  l_latest_date DATE;
  l_latest_mb   NUMBER:=0;
  l_count       NUMBER:=0;
  l_growth7     NUMBER:=0;
  l_growth30    NUMBER:=0;
  l_growth90    NUMBER:=0;

  FUNCTION growth_for_days(p_days NUMBER) RETURN NUMBER IS
    l_base NUMBER;
  BEGIN
    SELECT total_schema_mb INTO l_base
      FROM prod.dct_storage_snapshot
     WHERE snapshot_date=(SELECT MAX(snapshot_date) FROM prod.dct_storage_snapshot
                           WHERE snapshot_date<=l_latest_date-p_days);
    RETURN ROUND(l_latest_mb-l_base,2);
  EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN may view database storage history'); RETURN;
  END IF;

  SELECT COUNT(*),MAX(snapshot_date) INTO l_count,l_latest_date FROM prod.dct_storage_snapshot;
  IF l_latest_date IS NOT NULL THEN
    SELECT total_schema_mb INTO l_latest_mb FROM prod.dct_storage_snapshot WHERE snapshot_date=l_latest_date;
    l_growth7:=growth_for_days(7); l_growth30:=growth_for_days(30); l_growth90:=growth_for_days(90);
  END IF;

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('snapshotCount',l_count);
  APEX_JSON.write('latestDate',CASE WHEN l_latest_date IS NULL THEN NULL ELSE TO_CHAR(l_latest_date,'YYYY-MM-DD') END);
  APEX_JSON.write('schemaMb',l_latest_mb);
  APEX_JSON.write('growth7',l_growth7);
  APEX_JSON.write('growth30',l_growth30);
  APEX_JSON.write('growth90',l_growth90);
  APEX_JSON.open_array('topGrowth');
  IF l_count>1 THEN
    FOR r IN (
      SELECT table_name,current_mb,previous_mb,growth_mb
        FROM (
          SELECT cur.table_name,cur.size_mb current_mb,NVL(prev.size_mb,0) previous_mb,
                 ROUND(cur.size_mb-NVL(prev.size_mb,0),2) growth_mb
            FROM prod.dct_storage_object_snapshot cur
            LEFT JOIN prod.dct_storage_object_snapshot prev
              ON prev.table_name=cur.table_name
             AND prev.snapshot_date=(SELECT MAX(snapshot_date) FROM prod.dct_storage_snapshot
                                      WHERE snapshot_date<l_latest_date)
           WHERE cur.snapshot_date=l_latest_date
           ORDER BY growth_mb DESC,cur.table_name
        ) WHERE growth_mb>0 AND ROWNUM<=5
    ) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('tableName',r.table_name);
      APEX_JSON.write('currentMb',r.current_mb);
      APEX_JSON.write('previousMb',r.previous_mb);
      APEX_JSON.write('growthMb',r.growth_mb);
      APEX_JSON.close_object;
    END LOOP;
  END IF;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);
END;
!');
END;
/

BEGIN
  admin.setup_dct_storage_history_ords_tmp;
  COMMIT;
END;
/
DROP PROCEDURE admin.setup_dct_storage_history_ords_tmp;

PROMPT === 6. Verification ===
SELECT snapshot_date,total_schema_mb,total_lob_mb,created_at FROM prod.dct_storage_snapshot ORDER BY snapshot_date DESC;
SELECT owner,job_name,enabled,state,repeat_interval,next_run_date FROM dba_scheduler_jobs
 WHERE owner='PROD' AND job_name='DCT_STORAGE_HISTORY_JOB';
SELECT object_name,object_type,status FROM dba_objects
 WHERE owner='PROD' AND object_name LIKE 'DCT_STORAGE%SNAPSHOT' OR
       (owner='PROD' AND object_name='DCT_STORAGE_HISTORY_PKG')
 ORDER BY object_name,object_type;

PROMPT db/v2/78 storage growth history complete.
EXIT
