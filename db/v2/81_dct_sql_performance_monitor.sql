-- =============================================================================
-- i-Finance — live SQL performance monitor (no AWR/Diagnostic Pack)
-- Captures summarized V$SQLAREA statistics for PROD, alerts SYS_ADMIN when a
-- repeatedly executed statement exceeds the configured average time, and
-- exposes protected Admin endpoints. No SQL bind values are stored.
-- =============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SELECT 1 FROM dual;
SELECT 1 FROM dual;

PROMPT === 1. Settings and narrow ADMIN live-statistics view ===

BEGIN
  MERGE INTO prod.dct_system_settings s
  USING (
    SELECT 'SQL_PERF_ALERT_SECONDS' k,'3' v,
           'Warn when a PROD SQL statement averages at least this many seconds (minimum 0.5).' d FROM dual
    UNION ALL SELECT 'SQL_PERF_MIN_EXECUTIONS','2',
           'Minimum live executions before a SQL statement can trigger a performance warning.' FROM dual
  ) x ON (s.setting_key=x.k)
  WHEN MATCHED THEN UPDATE SET s.value_type='NUMBER',s.category='DATA_MAINTENANCE',
    s.is_system='Y',s.description_en=x.d
  WHEN NOT MATCHED THEN INSERT
    (setting_key,setting_value,value_type,category,description_en,is_system,created_by)
    VALUES(x.k,x.v,'NUMBER','DATA_MAINTENANCE',x.d,'Y','SYSTEM');
  COMMIT;
END;
/

CREATE OR REPLACE VIEW admin.dct_prod_sql_stats_v AS
SELECT sql_id,plan_hash_value,command_type,executions,elapsed_time,cpu_time,
       buffer_gets,disk_reads,rows_processed,last_active_time,
       SUBSTR(REGEXP_REPLACE(sql_text,'''([^'']|'''')*''','''?'''),1,500) sql_preview
  FROM v$sqlarea
 WHERE parsing_schema_name='PROD'
   AND executions>0
   AND command_type IN (2,3,6,7,47,189)
   AND UPPER(sql_text) NOT LIKE '%DCT_SQL_PERF%';

GRANT SELECT ON admin.dct_prod_sql_stats_v TO prod;

PROMPT === 2. Current performance snapshot ===

DECLARE
  l_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_count FROM dba_tables
   WHERE owner='PROD' AND table_name='DCT_SQL_PERF_CURRENT';
  IF l_count=0 THEN
    EXECUTE IMMEDIATE q'[
      CREATE TABLE prod.dct_sql_perf_current (
        sql_id          VARCHAR2(13) NOT NULL,
        plan_hash_value NUMBER,
        module_code     VARCHAR2(20) NOT NULL,
        statement_type  VARCHAR2(20) NOT NULL,
        executions      NUMBER NOT NULL,
        avg_seconds     NUMBER(18,3) NOT NULL,
        total_seconds   NUMBER(18,2) NOT NULL,
        cpu_seconds     NUMBER(18,2) NOT NULL,
        buffer_gets     NUMBER NOT NULL,
        disk_reads      NUMBER NOT NULL,
        rows_processed  NUMBER NOT NULL,
        last_active_at  TIMESTAMP,
        sql_preview     VARCHAR2(500),
        captured_at     TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
        CONSTRAINT pk_dct_sql_perf_current PRIMARY KEY (sql_id,plan_hash_value)
      )]';
  END IF;
END;
/

DECLARE
  l_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_count FROM dba_tables
   WHERE owner='PROD' AND table_name='DCT_SQL_PERF_STATE';
  IF l_count=0 THEN
    EXECUTE IMMEDIATE q'[
      CREATE TABLE prod.dct_sql_perf_state (
        state_id          NUMBER NOT NULL,
        checked_at        TIMESTAMP WITH TIME ZONE NOT NULL,
        checked_by        VARCHAR2(100) NOT NULL,
        performance_status VARCHAR2(10) NOT NULL,
        tracked_count     NUMBER DEFAULT 0 NOT NULL,
        slow_count        NUMBER DEFAULT 0 NOT NULL,
        top_avg_seconds   NUMBER(18,3) DEFAULT 0 NOT NULL,
        alert_seconds     NUMBER(18,3) NOT NULL,
        min_executions    NUMBER NOT NULL,
        issue_signature   VARCHAR2(200),
        alerted_signature VARCHAR2(200),
        last_alert_at     TIMESTAMP WITH TIME ZONE,
        CONSTRAINT pk_dct_sql_perf_state PRIMARY KEY (state_id),
        CONSTRAINT ck_dct_sql_perf_status CHECK (performance_status IN ('HEALTHY','WARNING'))
      )]';
  END IF;
END;
/

PROMPT === 3. Capture package ===

CREATE OR REPLACE PACKAGE prod.dct_sql_perf_pkg AUTHID DEFINER AS
  PROCEDURE capture;
  PROCEDURE run_capture(p_checked_by VARCHAR2);
END dct_sql_perf_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_sql_perf_pkg AS
  FUNCTION setting_num(p_key VARCHAR2,p_default NUMBER,p_min NUMBER) RETURN NUMBER IS
    l_value NUMBER;
  BEGIN
    SELECT TO_NUMBER(setting_value DEFAULT p_default ON CONVERSION ERROR)
      INTO l_value FROM prod.dct_system_settings WHERE setting_key=p_key;
    RETURN GREATEST(p_min,NVL(l_value,p_default));
  EXCEPTION WHEN NO_DATA_FOUND THEN RETURN p_default;
  END;

  FUNCTION module_for_sql(p_sql VARCHAR2) RETURN VARCHAR2 IS l_sql VARCHAR2(500):=UPPER(p_sql);
  BEGIN
    IF l_sql LIKE '%DCT_FL_%' THEN RETURN 'FL';
    ELSIF l_sql LIKE '%DT_%' THEN RETURN 'DT';
    ELSIF l_sql LIKE '%DCT_GL_%' OR l_sql LIKE '%DCT_ACTUAL%' THEN RETURN 'GL';
    ELSIF l_sql LIKE '%DCT_CC_%' THEN RETURN 'CC';
    ELSIF l_sql LIKE '%DCT_PC_%' THEN RETURN 'PC';
    ELSIF l_sql LIKE '%DCT_HR_%' THEN RETURN 'HR';
    ELSIF l_sql LIKE '%DCT_RPT_%' THEN RETURN 'RPT';
    ELSE RETURN 'ADMIN'; END IF;
  END;

  PROCEDURE perform_capture(p_checked_by VARCHAR2) IS
    l_alert NUMBER:=setting_num('SQL_PERF_ALERT_SECONDS',3,0.5);
    l_min   NUMBER:=setting_num('SQL_PERF_MIN_EXECUTIONS',2,1);
    l_count NUMBER:=0; l_slow NUMBER:=0; l_top NUMBER:=0;
    l_sig VARCHAR2(200); l_prev VARCHAR2(200); l_status VARCHAR2(10);
    l_module VARCHAR2(20);
  BEGIN
    DELETE FROM prod.dct_sql_perf_current;
    FOR r IN (
      SELECT * FROM (
        SELECT sql_id,plan_hash_value,command_type,executions,
               ROUND(elapsed_time/executions/1000000,3) avg_seconds,
               ROUND(elapsed_time/1000000,2) total_seconds,
               ROUND(cpu_time/1000000,2) cpu_seconds,buffer_gets,disk_reads,
               rows_processed,last_active_time,sql_preview
          FROM admin.dct_prod_sql_stats_v
         WHERE executions>=l_min
         ORDER BY elapsed_time/executions DESC
      ) WHERE ROWNUM<=20
    ) LOOP
      l_module:=module_for_sql(r.sql_preview);
      INSERT INTO prod.dct_sql_perf_current
        (sql_id,plan_hash_value,module_code,statement_type,executions,avg_seconds,
         total_seconds,cpu_seconds,buffer_gets,disk_reads,rows_processed,last_active_at,sql_preview)
      VALUES
        (r.sql_id,r.plan_hash_value,l_module,
         CASE r.command_type WHEN 2 THEN 'INSERT' WHEN 3 THEN 'SELECT' WHEN 6 THEN 'UPDATE'
              WHEN 7 THEN 'DELETE' WHEN 47 THEN 'PLSQL' WHEN 189 THEN 'MERGE' ELSE 'OTHER' END,
         r.executions,r.avg_seconds,r.total_seconds,r.cpu_seconds,r.buffer_gets,r.disk_reads,
         r.rows_processed,r.last_active_time,r.sql_preview);
    END LOOP;

    SELECT COUNT(*),NVL(SUM(CASE WHEN avg_seconds>=l_alert THEN 1 ELSE 0 END),0),
           NVL(MAX(avg_seconds),0)
      INTO l_count,l_slow,l_top FROM prod.dct_sql_perf_current;
    SELECT l_slow||':'||NVL(SUM(ORA_HASH(sql_id||':'||plan_hash_value)),0)
      INTO l_sig FROM prod.dct_sql_perf_current WHERE avg_seconds>=l_alert;
    l_status:=CASE WHEN l_slow>0 THEN 'WARNING' ELSE 'HEALTHY' END;
    BEGIN SELECT alerted_signature INTO l_prev FROM prod.dct_sql_perf_state WHERE state_id=1;
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
        prod.dct_notify.send(u.user_id,'WARNING','Slow database SQL detected',
          l_slow||' PROD SQL statement(s) average at least '||l_alert||
          ' seconds after '||l_min||' executions. Slowest average: '||l_top||' seconds.',
          NULL,NULL,'ADMIN','/Admin/Jet/index.html#systemSettings');
      END LOOP;
    END IF;

    MERGE INTO prod.dct_sql_perf_state s USING (SELECT 1 state_id FROM dual) x ON (s.state_id=x.state_id)
    WHEN MATCHED THEN UPDATE SET s.checked_at=SYSTIMESTAMP,s.checked_by=SUBSTR(NVL(p_checked_by,'SYSTEM'),1,100),
      s.performance_status=l_status,s.tracked_count=l_count,s.slow_count=l_slow,s.top_avg_seconds=l_top,
      s.alert_seconds=l_alert,s.min_executions=l_min,s.issue_signature=l_sig,
      s.alerted_signature=CASE WHEN l_status='WARNING' THEN l_sig ELSE NULL END,
      s.last_alert_at=CASE WHEN l_status='WARNING' AND NVL(l_prev,'-')<>l_sig THEN SYSTIMESTAMP ELSE s.last_alert_at END
    WHEN NOT MATCHED THEN INSERT
      (state_id,checked_at,checked_by,performance_status,tracked_count,slow_count,top_avg_seconds,
       alert_seconds,min_executions,issue_signature,alerted_signature,last_alert_at)
    VALUES (1,SYSTIMESTAMP,SUBSTR(NVL(p_checked_by,'SYSTEM'),1,100),l_status,l_count,l_slow,l_top,
      l_alert,l_min,l_sig,CASE WHEN l_status='WARNING' THEN l_sig END,
      CASE WHEN l_status='WARNING' THEN SYSTIMESTAMP END);
    COMMIT;
  EXCEPTION WHEN OTHERS THEN ROLLBACK; RAISE;
  END;

  PROCEDURE capture IS BEGIN perform_capture('SCHEDULER'); END;
  PROCEDURE run_capture(p_checked_by VARCHAR2) IS BEGIN perform_capture(p_checked_by); END;
END dct_sql_perf_pkg;
/

CREATE OR REPLACE PROCEDURE prod.grant_dct_sql_perf_tmp AUTHID DEFINER AS
BEGIN
  EXECUTE IMMEDIATE 'GRANT SELECT ON prod.dct_sql_perf_current TO admin';
  EXECUTE IMMEDIATE 'GRANT SELECT ON prod.dct_sql_perf_state TO admin';
  EXECUTE IMMEDIATE 'GRANT EXECUTE ON prod.dct_sql_perf_pkg TO admin';
END;
/
BEGIN prod.grant_dct_sql_perf_tmp; END;
/
DROP PROCEDURE prod.grant_dct_sql_perf_tmp;

PROMPT === 4. Thirty-minute scheduler job and initial capture ===

DECLARE
  l_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_exists FROM dba_scheduler_jobs
   WHERE owner='PROD' AND job_name='DCT_SQL_PERF_JOB';
  IF l_exists=0 THEN
    DBMS_SCHEDULER.CREATE_JOB(job_name=>'PROD.DCT_SQL_PERF_JOB',job_type=>'STORED_PROCEDURE',
      job_action=>'PROD.DCT_SQL_PERF_PKG.CAPTURE',start_date=>SYSTIMESTAMP,
      repeat_interval=>'FREQ=MINUTELY;INTERVAL=30',enabled=>FALSE,auto_drop=>FALSE,
      comments=>'Capture live PROD SQL performance summaries and warn SYS_ADMIN');
  ELSE
    DBMS_SCHEDULER.DISABLE('PROD.DCT_SQL_PERF_JOB',force=>TRUE);
    DBMS_SCHEDULER.SET_ATTRIBUTE('PROD.DCT_SQL_PERF_JOB','job_action','PROD.DCT_SQL_PERF_PKG.CAPTURE');
    DBMS_SCHEDULER.SET_ATTRIBUTE('PROD.DCT_SQL_PERF_JOB','repeat_interval','FREQ=MINUTELY;INTERVAL=30');
  END IF;
  DBMS_SCHEDULER.ENABLE('PROD.DCT_SQL_PERF_JOB');
END;
/
BEGIN prod.dct_sql_perf_pkg.capture; END;
/

PROMPT === 5. SYS_ADMIN performance endpoints ===

CREATE OR REPLACE PROCEDURE admin.setup_dct_sql_perf_ords_tmp AS
BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'dct.admin',p_pattern=>'maintenance/sql-performance');
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin',p_pattern=>'maintenance/sql-performance',p_method=>'GET',
    p_source_type=>ORDS.source_type_plsql,p_source=>q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session; l_state prod.dct_sql_perf_state%ROWTYPE;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Only SYS_ADMIN may view SQL performance'); RETURN; END IF;
  SELECT * INTO l_state FROM prod.dct_sql_perf_state WHERE state_id=1;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('status',l_state.performance_status); APEX_JSON.write('trackedCount',l_state.tracked_count);
  APEX_JSON.write('slowCount',l_state.slow_count); APEX_JSON.write('topAvgSeconds',l_state.top_avg_seconds);
  APEX_JSON.write('alertSeconds',l_state.alert_seconds); APEX_JSON.write('minExecutions',l_state.min_executions);
  APEX_JSON.write('checkedAt',TO_CHAR(l_state.checked_at AT TIME ZONE 'Asia/Dubai','YYYY-MM-DD HH24:MI'));
  APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM prod.dct_sql_perf_current ORDER BY avg_seconds DESC) LOOP
    APEX_JSON.open_object; APEX_JSON.write('sqlId',r.sql_id); APEX_JSON.write('moduleCode',r.module_code);
    APEX_JSON.write('statementType',r.statement_type); APEX_JSON.write('executions',r.executions);
    APEX_JSON.write('avgSeconds',r.avg_seconds); APEX_JSON.write('totalSeconds',r.total_seconds);
    APEX_JSON.write('rowsProcessed',r.rows_processed); APEX_JSON.write('sqlPreview',r.sql_preview);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM); END;
!');
  ORDS.DEFINE_HANDLER(p_module_name=>'dct.admin',p_pattern=>'maintenance/sql-performance',p_method=>'POST',
    p_source_type=>ORDS.source_type_plsql,p_source=>q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session; l_state prod.dct_sql_perf_state%ROWTYPE;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Only SYS_ADMIN may refresh SQL performance'); RETURN; END IF;
  prod.dct_sql_perf_pkg.run_capture(l_user); SELECT * INTO l_state FROM prod.dct_sql_perf_state WHERE state_id=1;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('status',l_state.performance_status); APEX_JSON.write('slowCount',l_state.slow_count);
  APEX_JSON.write('checkedAt',TO_CHAR(l_state.checked_at AT TIME ZONE 'Asia/Dubai','YYYY-MM-DD HH24:MI'));
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM); END;
!');
END;
/
BEGIN admin.setup_dct_sql_perf_ords_tmp; COMMIT; END;
/
DROP PROCEDURE admin.setup_dct_sql_perf_ords_tmp;

PROMPT === 6. Verification ===
SELECT performance_status,tracked_count,slow_count,top_avg_seconds,alert_seconds,min_executions
  FROM prod.dct_sql_perf_state;
SELECT sql_id,module_code,statement_type,executions,avg_seconds,total_seconds
  FROM prod.dct_sql_perf_current ORDER BY avg_seconds DESC FETCH FIRST 10 ROWS ONLY;
SELECT object_name,object_type,status FROM dba_objects
 WHERE owner='PROD' AND object_name='DCT_SQL_PERF_PKG' ORDER BY object_type;
SELECT owner,job_name,enabled,state,repeat_interval,next_run_date FROM dba_scheduler_jobs
 WHERE owner='PROD' AND job_name='DCT_SQL_PERF_JOB';

PROMPT db/v2/81 live SQL performance monitor complete.
EXIT
