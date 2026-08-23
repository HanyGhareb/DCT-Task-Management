-- =============================================================================
-- i-Finance — SQL performance monitor accuracy upgrade
-- Application SQL uses interval deltas; background/maintenance work is excluded
-- from alerts and exposed separately through scheduler health metadata.
-- Additive and rerunnable. Supersedes the capture/view/GET handler in db/v2/81.
-- =============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

BEGIN
  MERGE INTO prod.dct_system_settings s
  USING (
    SELECT 'SQL_PERF_SINGLE_ALERT_SECONDS' k,'5' v,
           'Warn on one interactive/application SQL execution taking at least this many seconds.' d FROM dual
    UNION ALL SELECT 'SQL_PERF_ALERT_SECONDS','3',
           'Warn when repeated interactive/application SQL averages at least this many seconds.' FROM dual
    UNION ALL SELECT 'SQL_PERF_MIN_EXECUTIONS','2',
           'Executions required for the repeated-SQL threshold; the single-execution threshold remains independent.' FROM dual
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
SELECT sql_id, plan_hash_value, command_type, executions, elapsed_time, cpu_time,
       buffer_gets, disk_reads, rows_processed, last_active_time,
       NVL(module, '-') module_name, NVL(action, '-') action_name,
       CAST(sql_text AS VARCHAR2(1000)) sql_text_raw
  FROM v$sqlarea
 WHERE parsing_schema_name = 'PROD'
   AND executions > 0
   AND command_type IN (2,3,6,7,47,189);

GRANT SELECT ON admin.dct_prod_sql_stats_v TO prod;

DECLARE
  l_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_count
    FROM dba_tables
   WHERE owner = 'PROD' AND table_name = 'DCT_SQL_PERF_BASELINE';
  IF l_count = 0 THEN
    EXECUTE IMMEDIATE q'[
      CREATE TABLE prod.dct_sql_perf_baseline (
        sql_id          VARCHAR2(13) NOT NULL,
        plan_hash_value NUMBER NOT NULL,
        executions      NUMBER NOT NULL,
        elapsed_time    NUMBER NOT NULL,
        cpu_time        NUMBER NOT NULL,
        buffer_gets     NUMBER NOT NULL,
        disk_reads      NUMBER NOT NULL,
        rows_processed  NUMBER NOT NULL,
        captured_at     TIMESTAMP WITH TIME ZONE NOT NULL,
        CONSTRAINT pk_dct_sql_perf_baseline PRIMARY KEY (sql_id, plan_hash_value)
      )]';
  END IF;
END;
/

DECLARE
  PROCEDURE add_column(p_column VARCHAR2,p_ddl VARCHAR2) IS l_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_count FROM dba_tab_columns
     WHERE owner='PROD' AND table_name='DCT_SQL_PERF_CURRENT' AND column_name=p_column;
    IF l_count=0 THEN EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_sql_perf_current ADD ('||p_ddl||')'; END IF;
  END;
BEGIN
  add_column('SOURCE_MODULE','source_module VARCHAR2(128)');
  add_column('SOURCE_ACTION','source_action VARCHAR2(128)');
  add_column('WORKLOAD_CLASS','workload_class VARCHAR2(20) DEFAULT ''APPLICATION'' NOT NULL');
  add_column('IS_SLOW','is_slow CHAR(1) DEFAULT ''N'' NOT NULL');
END;
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
    l_single NUMBER:=setting_num('SQL_PERF_SINGLE_ALERT_SECONDS',5,0.5);
    l_min   NUMBER:=setting_num('SQL_PERF_MIN_EXECUTIONS',2,1);
    l_count NUMBER:=0; l_slow NUMBER:=0; l_top NUMBER:=0;
    l_sig VARCHAR2(200); l_prev VARCHAR2(200); l_status VARCHAR2(10);
  BEGIN
    DELETE FROM prod.dct_sql_perf_current;

    INSERT INTO prod.dct_sql_perf_current
      (sql_id,plan_hash_value,module_code,statement_type,executions,avg_seconds,
       total_seconds,cpu_seconds,buffer_gets,disk_reads,rows_processed,last_active_at,sql_preview,
       source_module,source_action,workload_class,is_slow)
    SELECT sql_id,plan_hash_value,
           CASE WHEN UPPER(sql_text_raw) LIKE '%DCT_FL_%' THEN 'FL'
                WHEN UPPER(sql_text_raw) LIKE '%DT_%' THEN 'DT'
                WHEN UPPER(sql_text_raw) LIKE '%DCT_GL_%' OR UPPER(sql_text_raw) LIKE '%DCT_ACTUAL%' THEN 'GL'
                WHEN UPPER(sql_text_raw) LIKE '%DCT_CC_%' THEN 'CC'
                WHEN UPPER(sql_text_raw) LIKE '%DCT_PC_%' THEN 'PC'
                WHEN UPPER(sql_text_raw) LIKE '%DCT_HR_%' THEN 'HR'
                WHEN UPPER(sql_text_raw) LIKE '%DCT_RPT_%' THEN 'RPT'
                ELSE 'ADMIN' END,
           CASE command_type WHEN 2 THEN 'INSERT' WHEN 3 THEN 'SELECT' WHEN 6 THEN 'UPDATE'
                WHEN 7 THEN 'DELETE' WHEN 47 THEN 'PLSQL' WHEN 189 THEN 'MERGE' ELSE 'OTHER' END,
           delta_executions,ROUND(delta_elapsed/delta_executions/1000000,3),
           ROUND(delta_elapsed/1000000,2),ROUND(delta_cpu/1000000,2),
           delta_buffer_gets,delta_disk_reads,delta_rows,last_active_time,
           SUBSTR(REGEXP_REPLACE(sql_text_raw,'''([^'']|'''')*''','''?'''),1,500),
           SUBSTR(module_name,1,128),SUBSTR(action_name,1,128),
           CASE WHEN module_name LIKE 'DCT_RPT:%' OR module_name='/usr/bin/python3' THEN 'REPORT'
                WHEN module_name LIKE '/%' THEN 'INTERACTIVE'
                ELSE 'APPLICATION' END,
           CASE WHEN (module_name LIKE 'DCT_RPT:%' OR module_name='/usr/bin/python3') THEN 'N'
                WHEN delta_elapsed/delta_executions/1000000>=l_single THEN 'Y'
                WHEN delta_executions>=l_min AND delta_elapsed/delta_executions/1000000>=l_alert THEN 'Y'
                ELSE 'N' END
      FROM (
        SELECT q.*,
               q.executions-b.executions delta_executions,
               q.elapsed_time-b.elapsed_time delta_elapsed,
               q.cpu_time-b.cpu_time delta_cpu,
               q.buffer_gets-b.buffer_gets delta_buffer_gets,
               q.disk_reads-b.disk_reads delta_disk_reads,
               q.rows_processed-b.rows_processed delta_rows,
               ROW_NUMBER() OVER (
                 PARTITION BY CASE WHEN q.module_name LIKE 'DCT_RPT:%' OR q.module_name='/usr/bin/python3'
                                   THEN 'REPORT' ELSE 'APPLICATION' END
                 ORDER BY (q.elapsed_time-b.elapsed_time)/NULLIF(q.executions-b.executions,0) DESC
               ) rn
          FROM admin.dct_prod_sql_stats_v q
          JOIN prod.dct_sql_perf_baseline b
            ON b.sql_id=q.sql_id AND b.plan_hash_value=q.plan_hash_value
         WHERE q.executions-b.executions >= 1
           AND q.elapsed_time >= b.elapsed_time
           AND q.module_name NOT IN ('DBMS_SCHEDULER','SQLcle')
           AND q.module_name NOT LIKE 'dbms_stats:%'
           AND q.module_name NOT LIKE 'Oracle SQL Developer%'
           AND q.sql_text_raw NOT LIKE '%DCT_SQL_PERF%'
      )
     WHERE rn <= 20;

    MERGE INTO prod.dct_sql_perf_baseline b
    USING (
      SELECT sql_id,plan_hash_value,executions,elapsed_time,cpu_time,buffer_gets,
             disk_reads,rows_processed
        FROM admin.dct_prod_sql_stats_v
    ) q ON (b.sql_id=q.sql_id AND b.plan_hash_value=q.plan_hash_value)
    WHEN MATCHED THEN UPDATE SET
      b.executions=q.executions,b.elapsed_time=q.elapsed_time,b.cpu_time=q.cpu_time,
      b.buffer_gets=q.buffer_gets,b.disk_reads=q.disk_reads,b.rows_processed=q.rows_processed,
      b.captured_at=SYSTIMESTAMP
    WHEN NOT MATCHED THEN INSERT
      (sql_id,plan_hash_value,executions,elapsed_time,cpu_time,buffer_gets,disk_reads,
       rows_processed,captured_at)
    VALUES
      (q.sql_id,q.plan_hash_value,q.executions,q.elapsed_time,q.cpu_time,q.buffer_gets,
       q.disk_reads,q.rows_processed,SYSTIMESTAMP);

    DELETE FROM prod.dct_sql_perf_baseline b
     WHERE b.captured_at < SYSTIMESTAMP-INTERVAL '7' DAY;

    SELECT COUNT(*),NVL(SUM(CASE WHEN is_slow='Y' THEN 1 ELSE 0 END),0),NVL(MAX(avg_seconds),0)
      INTO l_count,l_slow,l_top FROM prod.dct_sql_perf_current;
    SELECT l_slow||':'||NVL(SUM(ORA_HASH(sql_id||':'||plan_hash_value)),0)
      INTO l_sig FROM prod.dct_sql_perf_current WHERE is_slow='Y';
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
        prod.dct_notify.send(u.user_id,'WARNING','Slow application SQL detected',
          l_slow||' interactive/application SQL statement(s) breached the threshold: one execution at least '||
          l_single||' seconds, or at least '||l_min||' executions averaging '||l_alert||
          ' seconds. Slowest observed average: '||l_top||' seconds. Background reports are excluded.',
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

CREATE OR REPLACE PROCEDURE admin.setup_dct_sql_perf_delta_tmp AS
BEGIN
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
  FOR r IN (SELECT * FROM prod.dct_sql_perf_current
             ORDER BY CASE is_slow WHEN 'Y' THEN 0 ELSE 1 END,
                      CASE workload_class WHEN 'INTERACTIVE' THEN 0 WHEN 'APPLICATION' THEN 1 ELSE 2 END,
                      avg_seconds DESC) LOOP
    APEX_JSON.open_object; APEX_JSON.write('sqlId',r.sql_id); APEX_JSON.write('moduleCode',r.module_code);
    APEX_JSON.write('statementType',r.statement_type); APEX_JSON.write('executions',r.executions);
    APEX_JSON.write('avgSeconds',r.avg_seconds); APEX_JSON.write('totalSeconds',r.total_seconds);
    APEX_JSON.write('cpuSeconds',r.cpu_seconds); APEX_JSON.write('bufferGets',r.buffer_gets);
    APEX_JSON.write('diskReads',r.disk_reads); APEX_JSON.write('rowsProcessed',r.rows_processed);
    APEX_JSON.write('sourceModule',r.source_module); APEX_JSON.write('sourceAction',r.source_action);
    APEX_JSON.write('workloadClass',r.workload_class); APEX_JSON.write('isSlow',r.is_slow);
    APEX_JSON.write('sqlPreview',r.sql_preview); APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('backgroundJobs');
  FOR j IN (
    SELECT job_name,state,failure_count,
           ROUND(EXTRACT(DAY FROM last_run_duration)*86400+
                 EXTRACT(HOUR FROM last_run_duration)*3600+
                 EXTRACT(MINUTE FROM last_run_duration)*60+
                 EXTRACT(SECOND FROM last_run_duration),3) duration_seconds,
           TO_CHAR(last_start_date AT TIME ZONE 'Asia/Dubai','YYYY-MM-DD HH24:MI') last_started
      FROM dba_scheduler_jobs
     WHERE owner='PROD' AND enabled='TRUE' AND last_start_date IS NOT NULL
     ORDER BY last_start_date DESC FETCH FIRST 10 ROWS ONLY
  ) LOOP
    APEX_JSON.open_object; APEX_JSON.write('jobName',j.job_name); APEX_JSON.write('state',j.state);
    APEX_JSON.write('failureCount',j.failure_count); APEX_JSON.write('durationSeconds',j.duration_seconds);
    APEX_JSON.write('lastStarted',j.last_started); APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM); END;
!');
END;
/
BEGIN admin.setup_dct_sql_perf_delta_tmp; COMMIT; END;
/
DROP PROCEDURE admin.setup_dct_sql_perf_delta_tmp;

BEGIN prod.dct_sql_perf_pkg.run_capture('DEPLOY_116'); END;
/

PROMPT === Verification ===
SELECT performance_status,tracked_count,slow_count,top_avg_seconds,checked_by,checked_at
  FROM prod.dct_sql_perf_state WHERE state_id=1;
SELECT COUNT(*) baseline_rows FROM prod.dct_sql_perf_baseline;
SELECT sql_id,module_code,executions,avg_seconds,total_seconds
  FROM prod.dct_sql_perf_current ORDER BY avg_seconds DESC FETCH FIRST 10 ROWS ONLY;
SELECT status FROM dba_objects WHERE owner='PROD' AND object_name='DCT_SQL_PERF_PKG' AND object_type='PACKAGE BODY';

PROMPT db/v2/116 SQL performance delta monitor complete.
EXIT
