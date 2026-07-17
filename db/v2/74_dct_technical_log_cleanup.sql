-- =============================================================================
-- i-Finance — Configurable ATD technical-log retention and cleanup
--
-- Settings (Admin > System Settings > DATA_MAINTENANCE):
--   ATD_SUCCESS_LOG_RETENTION_DAYS  default 90
--   ATD_ISSUE_LOG_RETENTION_DAYS    default 365 (warning/failed/held rows)
--
-- The nightly job runs at 00:15 Asia/Dubai. RUNNING rows are never removed.
-- The ORDS endpoint POST /ords/admin/dct/maintenance/log-cleanup is SYS_ADMIN
-- only and uses the same package/settings as the scheduled job.
-- Additive and rerunnable. Run as ADMIN: sql -name prod_mcp @74_...
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT === 1. Retention settings ===

DECLARE
  PROCEDURE ensure_setting(
    p_key         IN VARCHAR2,
    p_default     IN VARCHAR2,
    p_description IN VARCHAR2
  ) IS
  BEGIN
    UPDATE prod.dct_system_settings
       SET value_type     = 'NUMBER',
           category       = 'DATA_MAINTENANCE',
           description_en = p_description,
           is_system      = 'Y'
     WHERE setting_key = p_key;

    IF SQL%ROWCOUNT = 0 THEN
      INSERT INTO prod.dct_system_settings
        (setting_key, setting_value, value_type, category, description_en,
         is_system, created_by)
      VALUES
        (p_key, p_default, 'NUMBER', 'DATA_MAINTENANCE', p_description,
         'Y', 'SYSTEM');
    END IF;
  END ensure_setting;
BEGIN
  ensure_setting(
    'ATD_SUCCESS_LOG_RETENTION_DAYS', '90',
    'Successful ATD load-run logs are deleted after this many days (minimum 7).');
  ensure_setting(
    'ATD_ISSUE_LOG_RETENTION_DAYS', '365',
    'ATD warning, failed and held load-run logs are deleted after this many days (minimum 30).');
END;
/

COMMIT;

PROMPT === 2. Cleanup package ===

CREATE OR REPLACE PACKAGE prod.dct_log_cleanup_pkg AUTHID DEFINER AS
  PROCEDURE run_cleanup(
    p_success_deleted OUT NUMBER,
    p_issue_deleted   OUT NUMBER
  );
  PROCEDURE run_scheduled;
END dct_log_cleanup_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_log_cleanup_pkg AS
  FUNCTION retention_days(
    p_key     IN VARCHAR2,
    p_default IN NUMBER,
    p_minimum IN NUMBER
  ) RETURN NUMBER IS
    l_days NUMBER;
  BEGIN
    SELECT TO_NUMBER(setting_value DEFAULT NULL ON CONVERSION ERROR)
      INTO l_days
      FROM prod.dct_system_settings
     WHERE setting_key = p_key;

    IF l_days IS NULL OR l_days < p_minimum OR l_days > 3650 OR l_days != TRUNC(l_days) THEN
      RAISE_APPLICATION_ERROR(-20071,
        p_key || ' must be a whole number from ' || p_minimum || ' to 3650');
    END IF;
    RETURN l_days;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN p_default;
  END retention_days;

  PROCEDURE run_cleanup(
    p_success_deleted OUT NUMBER,
    p_issue_deleted   OUT NUMBER
  ) IS
    l_success_days NUMBER := retention_days('ATD_SUCCESS_LOG_RETENTION_DAYS', 90, 7);
    l_issue_days   NUMBER := retention_days('ATD_ISSUE_LOG_RETENTION_DAYS', 365, 30);
  BEGIN
    DELETE FROM prod.atd_load_run_log
     WHERE status = 'SUCCESS'
       AND message IS NULL
       AND started < SYSTIMESTAMP - NUMTODSINTERVAL(l_success_days, 'DAY');
    p_success_deleted := SQL%ROWCOUNT;

    DELETE FROM prod.atd_load_run_log
     WHERE status <> 'RUNNING'
       AND (status <> 'SUCCESS' OR message IS NOT NULL)
       AND started < SYSTIMESTAMP - NUMTODSINTERVAL(l_issue_days, 'DAY');
    p_issue_deleted := SQL%ROWCOUNT;

    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
  END run_cleanup;

  PROCEDURE run_scheduled IS
    l_success NUMBER;
    l_issue   NUMBER;
  BEGIN
    run_cleanup(l_success, l_issue);
  END run_scheduled;
END dct_log_cleanup_pkg;
/

CREATE OR REPLACE SYNONYM dct_log_cleanup_pkg FOR prod.dct_log_cleanup_pkg;

PROMPT === 3. Retention lookup index ===

DECLARE
  l_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_count
    FROM dba_indexes
   WHERE owner = 'PROD' AND index_name = 'IX_ATD_RUN_LOG_RETENTION';
  IF l_count = 0 THEN
    EXECUTE IMMEDIATE
      'CREATE INDEX prod.ix_atd_run_log_retention ON prod.atd_load_run_log(status, started)';
  END IF;
END;
/

PROMPT === 4. Nightly scheduler job ===

DECLARE
  c_job CONSTANT VARCHAR2(30) := 'DCT_LOG_CLEANUP_JOB';
  l_exists NUMBER;
  l_start  TIMESTAMP WITH TIME ZONE;
BEGIN
  l_start := TO_TIMESTAMP_TZ(
    TO_CHAR(SYSTIMESTAMP AT TIME ZONE 'Asia/Dubai' + INTERVAL '1' DAY, 'YYYY-MM-DD') ||
    ' 00:15:00 Asia/Dubai',
    'YYYY-MM-DD HH24:MI:SS TZR');

  SELECT COUNT(*) INTO l_exists
    FROM dba_scheduler_jobs
   WHERE owner = 'PROD' AND job_name = c_job;

  IF l_exists = 0 THEN
    DBMS_SCHEDULER.CREATE_JOB(
      job_name        => 'PROD.' || c_job,
      job_type        => 'STORED_PROCEDURE',
      job_action      => 'PROD.DCT_LOG_CLEANUP_PKG.RUN_SCHEDULED',
      start_date      => l_start,
      repeat_interval => 'FREQ=DAILY;BYHOUR=0;BYMINUTE=15;BYSECOND=0',
      enabled         => FALSE,
      auto_drop       => FALSE,
      comments        => 'Delete expired ATD technical load-run logs using Admin retention settings');
  ELSE
    DBMS_SCHEDULER.DISABLE('PROD.' || c_job, force => TRUE);
    DBMS_SCHEDULER.SET_ATTRIBUTE('PROD.' || c_job, 'job_action',
                                 'PROD.DCT_LOG_CLEANUP_PKG.RUN_SCHEDULED');
    DBMS_SCHEDULER.SET_ATTRIBUTE('PROD.' || c_job, 'start_date', l_start);
    DBMS_SCHEDULER.SET_ATTRIBUTE('PROD.' || c_job, 'repeat_interval',
                                 'FREQ=DAILY;BYHOUR=0;BYMINUTE=15;BYSECOND=0');
  END IF;
  DBMS_SCHEDULER.ENABLE('PROD.' || c_job);
END;
/

PROMPT === 5. SYS_ADMIN manual cleanup endpoint ===

CREATE OR REPLACE PROCEDURE admin.setup_dct_log_cleanup_ords_tmp AS
  c_mod CONSTANT VARCHAR2(30) := 'dct.admin';
BEGIN
  -- Re-define the existing settings PUT so retention values are validated at
  -- save time. The template itself is owned by the base dct.admin module.
  ORDS.DEFINE_HANDLER(
    p_module_name => c_mod,
    p_pattern     => 'settings/:setkey',
    p_method      => 'PUT',
    p_source_type => ORDS.source_type_plsql,
    p_source      => q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_val    VARCHAR2(4000);
  l_num    NUMBER;
  l_secret BOOLEAN := (:setkey LIKE '%API_KEY%' OR :setkey LIKE '%SECRET%'
                       OR :setkey LIKE '%PASSWORD%' OR :setkey LIKE '%TOKEN%');
  l_old    CLOB;
  l_new    CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body(:body);
  l_val := APEX_JSON.get_varchar2(p_path => 'value');
  IF :setkey IN ('ATD_SUCCESS_LOG_RETENTION_DAYS','ATD_ISSUE_LOG_RETENTION_DAYS') THEN
    IF NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
      dct_rest.err(403,'Only SYS_ADMIN may change technical log retention'); RETURN;
    END IF;
    l_num := TO_NUMBER(l_val DEFAULT NULL ON CONVERSION ERROR);
    IF l_num IS NULL OR l_num != TRUNC(l_num)
       OR (:setkey = 'ATD_SUCCESS_LOG_RETENTION_DAYS' AND l_num NOT BETWEEN 7 AND 3650)
       OR (:setkey = 'ATD_ISSUE_LOG_RETENTION_DAYS' AND l_num NOT BETWEEN 30 AND 3650) THEN
      dct_rest.err(400,'Invalid retention days'); RETURN;
    END IF;
  END IF;
  IF l_val = '********' THEN
    dct_rest.json_header;
    APEX_JSON.initialize_output;
    APEX_JSON.open_object;
    APEX_JSON.write('ok', TRUE);
    APEX_JSON.write('skipped', 'masked value');
    APEX_JSON.close_object;
    RETURN;
  END IF;
  IF NOT l_secret THEN
    l_old := dct_audit_pkg.snap('DCT_SYSTEM_SETTINGS','setting_key', :setkey);
  END IF;
  MERGE INTO dct_system_settings t
  USING (SELECT :setkey AS k FROM dual) s
  ON (t.setting_key = s.k)
  WHEN MATCHED THEN UPDATE SET
    t.setting_value = l_val,
    t.updated_by    = l_user,
    t.updated_at    = SYSTIMESTAMP
  WHEN NOT MATCHED THEN INSERT
    (setting_key, setting_value, value_type, category, is_system, created_by)
  VALUES
    (s.k, l_val,
     CASE WHEN s.k LIKE 'FEATURE\_%' ESCAPE '\' THEN 'BOOLEAN' ELSE 'STRING' END,
     CASE WHEN s.k LIKE 'FEATURE\_%' ESCAPE '\' THEN 'FEATURES'
          WHEN s.k LIKE 'LANDING\_%' ESCAPE '\' THEN 'UI'
          ELSE 'GENERAL' END,
     'N', l_user);
  COMMIT;
  IF NOT l_secret THEN
    l_new := dct_audit_pkg.snap('DCT_SYSTEM_SETTINGS','setting_key', :setkey);
  END IF;
  dct_audit_pkg.log(l_user,'UPDATE','DCT_SYSTEM_SETTINGS', :setkey, 'ADMIN',
                    p_old=>l_old, p_new=>l_new);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

  ORDS.DEFINE_TEMPLATE(
    p_module_name => c_mod,
    p_pattern     => 'maintenance/log-cleanup');
  ORDS.DEFINE_HANDLER(
    p_module_name => c_mod,
    p_pattern     => 'maintenance/log-cleanup',
    p_method      => 'POST',
    p_source_type => ORDS.source_type_plsql,
    p_source      => q'!
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_success NUMBER;
  l_issue   NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN may run technical log cleanup'); RETURN;
  END IF;

  dct_log_cleanup_pkg.run_cleanup(l_success, l_issue);
  dct_audit_pkg.log(
    l_user, 'DELETE', 'ATD_LOAD_RUN_LOG', 'RETENTION', 'ADMIN',
    p_object_ref => 'Manual retention cleanup: success=' || l_success ||
                    ', warning/failed=' || l_issue);

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.write('successDeleted', l_success);
  APEX_JSON.write('issueDeleted', l_issue);
  APEX_JSON.write('totalDeleted', l_success + l_issue);
  APEX_JSON.close_object;
EXCEPTION
  WHEN OTHERS THEN
    dct_audit_pkg.log(l_user, 'DELETE', 'ATD_LOAD_RUN_LOG', 'RETENTION', 'ADMIN',
                      p_status => 'FAILED', p_error => SQLERRM);
    IF SQLCODE = -20071 THEN dct_rest.err(400, SQLERRM);
    ELSE dct_rest.err(500, SQLERRM);
    END IF;
END;
!');
END;
/

BEGIN
  admin.setup_dct_log_cleanup_ords_tmp;
  COMMIT;
END;
/

DROP PROCEDURE admin.setup_dct_log_cleanup_ords_tmp;

PROMPT === 6. Verification ===

SELECT setting_key, setting_value, value_type, category
  FROM prod.dct_system_settings
 WHERE setting_key IN
   ('ATD_SUCCESS_LOG_RETENTION_DAYS','ATD_ISSUE_LOG_RETENTION_DAYS')
 ORDER BY setting_key;

SELECT object_name, object_type, status
  FROM dba_objects
 WHERE owner = 'PROD' AND object_name = 'DCT_LOG_CLEANUP_PKG'
 ORDER BY object_type;

SELECT owner, job_name, enabled, state,
       TO_CHAR(next_run_date AT TIME ZONE 'Asia/Dubai',
               'YYYY-MM-DD HH24:MI TZR') next_run_dubai
  FROM dba_scheduler_jobs
 WHERE owner = 'PROD' AND job_name = 'DCT_LOG_CLEANUP_JOB';

PROMPT db/v2/74 configurable technical-log cleanup complete.
EXIT
