-- =============================================================================
-- i-Finance — Database Scheduler health monitoring
-- Alerts active SYS_ADMIN users when the same enabled PROD job fails twice in
-- succession. Runs every 15 minutes. Also exposes SYS_ADMIN-only job health at
-- GET /ords/admin/dct/scheduler/jobs for the Admin Automation Registry.
-- Additive and rerunnable. Run as ADMIN via sql -name prod_mcp.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. Alert state ===

CREATE TABLE IF NOT EXISTS prod.dct_scheduler_alert_state (
  job_name          VARCHAR2(128) PRIMARY KEY,
  last_alert_log_id NUMBER,
  alerted_at        TIMESTAMP,
  recovered_at      TIMESTAMP,
  updated_at        TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL
);

PROMPT === 2. Monitor package ===

CREATE OR REPLACE PACKAGE prod.dct_scheduler_health_pkg AUTHID DEFINER AS
  PROCEDURE check_jobs;
END dct_scheduler_health_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_scheduler_health_pkg AS
  PROCEDURE check_jobs IS
    l_latest_id     NUMBER;
    l_latest_status VARCHAR2(30);
    l_previous_stat VARCHAR2(30);
    l_info          VARCHAR2(4000);
    l_alerted_id    NUMBER;
  BEGIN
    FOR j IN (
      SELECT job_name
        FROM all_scheduler_jobs
       WHERE owner='PROD'
         AND enabled='TRUE'
         AND job_name <> 'DCT_SCHEDULER_HEALTH_JOB'
    ) LOOP
      BEGIN
        SELECT MAX(CASE WHEN rn=1 THEN log_id END),
               MAX(CASE WHEN rn=1 THEN status END),
               MAX(CASE WHEN rn=2 THEN status END),
               MAX(CASE WHEN rn=1 THEN additional_info END)
          INTO l_latest_id, l_latest_status, l_previous_stat, l_info
          FROM (
            SELECT log_id, status, additional_info,
                   ROW_NUMBER() OVER (ORDER BY log_date DESC, log_id DESC) rn
              FROM all_scheduler_job_run_details
             WHERE owner='PROD' AND job_name=j.job_name
          )
         WHERE rn <= 2;

        IF l_latest_status = 'FAILED' AND l_previous_stat = 'FAILED' THEN
          BEGIN
            SELECT last_alert_log_id INTO l_alerted_id
              FROM prod.dct_scheduler_alert_state
             WHERE job_name=j.job_name;
          EXCEPTION WHEN NO_DATA_FOUND THEN l_alerted_id := NULL;
          END;

          IF l_alerted_id IS NULL OR l_alerted_id <> l_latest_id THEN
            FOR u IN (
              SELECT DISTINCT usr.user_id
                FROM prod.dct_users usr
                JOIN prod.dct_user_roles ur ON ur.user_id=usr.user_id
                JOIN prod.dct_roles r ON r.role_id=ur.role_id
               WHERE r.role_code='SYS_ADMIN'
                 AND r.is_active='Y' AND usr.is_active='Y' AND ur.is_active='Y'
                 AND TRUNC(SYSDATE) >= TRUNC(ur.start_date)
                 AND (ur.end_date IS NULL OR TRUNC(SYSDATE) <= TRUNC(ur.end_date))
            ) LOOP
              prod.dct_notify.send(
                u.user_id, 'WARNING',
                'Database job failed twice: ' || j.job_name,
                'The job failed in its last two runs. Last error: ' ||
                  SUBSTR(NVL(l_info,'No error details supplied by Oracle.'),1,3500),
                NULL, NULL, 'ADMIN', '/Admin/Jet/index.html#runners');
            END LOOP;

            MERGE INTO prod.dct_scheduler_alert_state s
            USING (SELECT j.job_name job_name FROM dual) x
               ON (s.job_name=x.job_name)
            WHEN MATCHED THEN UPDATE SET
              s.last_alert_log_id=l_latest_id, s.alerted_at=SYSTIMESTAMP,
              s.recovered_at=NULL, s.updated_at=SYSTIMESTAMP
            WHEN NOT MATCHED THEN INSERT
              (job_name,last_alert_log_id,alerted_at,updated_at)
              VALUES (j.job_name,l_latest_id,SYSTIMESTAMP,SYSTIMESTAMP);
          END IF;
        ELSIF l_latest_status = 'SUCCEEDED' THEN
          UPDATE prod.dct_scheduler_alert_state
             SET last_alert_log_id=NULL, recovered_at=SYSTIMESTAMP,
                 updated_at=SYSTIMESTAMP
           WHERE job_name=j.job_name AND last_alert_log_id IS NOT NULL;
        END IF;
      EXCEPTION WHEN OTHERS THEN
        NULL; -- one malformed/missing job history must not stop the full sweep
      END;
    END LOOP;
    COMMIT;
  END check_jobs;
END dct_scheduler_health_pkg;
/

PROMPT === 3. Monitor job ===

DECLARE
  c_job CONSTANT VARCHAR2(30) := 'DCT_SCHEDULER_HEALTH_JOB';
  l_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_exists FROM dba_scheduler_jobs
   WHERE owner='PROD' AND job_name=c_job;
  IF l_exists=0 THEN
    DBMS_SCHEDULER.CREATE_JOB(
      job_name=>'PROD.'||c_job,
      job_type=>'STORED_PROCEDURE',
      job_action=>'PROD.DCT_SCHEDULER_HEALTH_PKG.CHECK_JOBS',
      start_date=>SYSTIMESTAMP,
      repeat_interval=>'FREQ=MINUTELY;INTERVAL=15',
      enabled=>FALSE, auto_drop=>FALSE,
      comments=>'Alert SYS_ADMIN after two consecutive failures of a PROD scheduler job');
  ELSE
    DBMS_SCHEDULER.DISABLE('PROD.'||c_job, force=>TRUE);
    DBMS_SCHEDULER.SET_ATTRIBUTE('PROD.'||c_job,'job_action',
                                 'PROD.DCT_SCHEDULER_HEALTH_PKG.CHECK_JOBS');
    DBMS_SCHEDULER.SET_ATTRIBUTE('PROD.'||c_job,'repeat_interval',
                                 'FREQ=MINUTELY;INTERVAL=15');
  END IF;
  DBMS_SCHEDULER.ENABLE('PROD.'||c_job);
END;
/

PROMPT === 4. SYS_ADMIN job-health endpoint ===

CREATE OR REPLACE PROCEDURE admin.setup_dct_scheduler_health_ords_tmp AS
BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'dct.admin', p_pattern=>'scheduler/jobs');
  ORDS.DEFINE_HANDLER(
    p_module_name=>'dct.admin', p_pattern=>'scheduler/jobs', p_method=>'GET',
    p_source_type=>ORDS.source_type_plsql,
    p_source=>q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN may view database job health'); RETURN;
  END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT j.job_name, j.enabled, j.state, j.failure_count,
           TO_CHAR(j.last_start_date AT TIME ZONE 'Asia/Dubai','YYYY-MM-DD HH24:MI') last_run,
           TO_CHAR(j.next_run_date AT TIME ZONE 'Asia/Dubai','YYYY-MM-DD HH24:MI') next_run,
           NVL(rd.status,'NEVER_RUN') last_status,
           NVL(SUBSTR(rd.additional_info,1,1000),'') error_info
      FROM dba_scheduler_jobs j
      OUTER APPLY (
        SELECT status, additional_info
          FROM dba_scheduler_job_run_details d
         WHERE d.owner=j.owner AND d.job_name=j.job_name
         ORDER BY log_date DESC, log_id DESC FETCH FIRST 1 ROW ONLY
      ) rd
     WHERE j.owner='PROD'
     ORDER BY j.job_name
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('jobName',r.job_name);
    APEX_JSON.write('enabled',CASE WHEN r.enabled='TRUE' THEN 'Y' ELSE 'N' END);
    APEX_JSON.write('state',r.state);
    APEX_JSON.write('lastStatus',r.last_status);
    APEX_JSON.write('failureCount',r.failure_count);
    APEX_JSON.write('lastRun',NVL(r.last_run,''));
    APEX_JSON.write('nextRun',NVL(r.next_run,''));
    APEX_JSON.write('error',r.error_info);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);
END;
!');
END;
/

BEGIN
  admin.setup_dct_scheduler_health_ords_tmp;
  COMMIT;
END;
/
DROP PROCEDURE admin.setup_dct_scheduler_health_ords_tmp;

PROMPT === 5. Verification ===
SELECT object_name,object_type,status FROM dba_objects
 WHERE owner='PROD' AND object_name='DCT_SCHEDULER_HEALTH_PKG'
 ORDER BY object_type;
SELECT owner,job_name,enabled,state,repeat_interval FROM dba_scheduler_jobs
 WHERE owner='PROD' AND job_name='DCT_SCHEDULER_HEALTH_JOB';

PROMPT db/v2/75 scheduler health monitoring complete.
EXIT
