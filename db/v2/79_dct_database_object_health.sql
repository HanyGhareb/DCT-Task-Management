-- =============================================================================
-- i-Finance — PROD database object health check
-- Checks invalid objects and unusable indexes/partitions, stores the latest
-- result, warns SYS_ADMIN only when the issue set changes, and exposes protected
-- GET/run endpoints for Admin > Data Maintenance. Additive and rerunnable.
-- =============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

-- SQLcl named connections can consume the first executable statement.
SELECT 1 FROM dual;
SELECT 1 FROM dual;

PROMPT === 1. Latest health state ===

DECLARE
  l_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_count FROM dba_tables
   WHERE owner='PROD' AND table_name='DCT_DB_HEALTH_STATE';
  IF l_count=0 THEN
    EXECUTE IMMEDIATE q'[
      CREATE TABLE prod.dct_db_health_state (
        state_id               NUMBER NOT NULL,
        checked_at             TIMESTAMP WITH TIME ZONE NOT NULL,
        checked_by             VARCHAR2(100) NOT NULL,
        invalid_object_count   NUMBER DEFAULT 0 NOT NULL,
        unusable_index_count   NUMBER DEFAULT 0 NOT NULL,
        unusable_part_count    NUMBER DEFAULT 0 NOT NULL,
        health_status          VARCHAR2(10) NOT NULL,
        issue_signature        VARCHAR2(200),
        alerted_signature      VARCHAR2(200),
        last_alert_at          TIMESTAMP WITH TIME ZONE,
        CONSTRAINT pk_dct_db_health_state PRIMARY KEY (state_id),
        CONSTRAINT ck_dct_db_health_status CHECK (health_status IN ('HEALTHY','WARNING'))
      )]';
  END IF;
END;
/

PROMPT === 2. Health-check package ===

CREATE OR REPLACE PACKAGE prod.dct_db_health_pkg AUTHID DEFINER AS
  PROCEDURE check_health;
  PROCEDURE run_health_check(p_checked_by VARCHAR2);
END dct_db_health_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_db_health_pkg AS
  PROCEDURE perform_check(p_checked_by VARCHAR2) IS
    l_invalid       NUMBER:=0;
    l_indexes       NUMBER:=0;
    l_parts         NUMBER:=0;
    l_hash_invalid  NUMBER:=0;
    l_hash_indexes  NUMBER:=0;
    l_hash_parts    NUMBER:=0;
    l_signature     VARCHAR2(200);
    l_previous      VARCHAR2(200);
    l_status        VARCHAR2(10);
  BEGIN
    SELECT COUNT(*),NVL(SUM(ORA_HASH(object_name||':'||object_type||':'||status)),0)
      INTO l_invalid,l_hash_invalid
      FROM user_objects
     WHERE status<>'VALID'
       AND object_name NOT LIKE 'BIN$%';

    SELECT COUNT(*),NVL(SUM(ORA_HASH(index_name||':'||status)),0)
      INTO l_indexes,l_hash_indexes
      FROM user_indexes
     WHERE status='UNUSABLE';

    SELECT COUNT(*),NVL(SUM(ORA_HASH(index_name||':'||partition_name||':'||status)),0)
      INTO l_parts,l_hash_parts
      FROM user_ind_partitions
     WHERE status='UNUSABLE';

    l_status:=CASE WHEN l_invalid+l_indexes+l_parts=0 THEN 'HEALTHY' ELSE 'WARNING' END;
    l_signature:=l_invalid||':'||l_hash_invalid||'|'||l_indexes||':'||l_hash_indexes||
                 '|'||l_parts||':'||l_hash_parts;

    BEGIN
      SELECT alerted_signature INTO l_previous
        FROM prod.dct_db_health_state WHERE state_id=1;
    EXCEPTION WHEN NO_DATA_FOUND THEN l_previous:=NULL;
    END;

    IF l_status='WARNING' AND NVL(l_previous,'-')<>l_signature THEN
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
          u.user_id,'WARNING','Database object health warning',
          'PROD has '||l_invalid||' invalid object(s), '||l_indexes||
          ' unusable index(es), and '||l_parts||' unusable index partition(s).',
          NULL,NULL,'ADMIN','/Admin/Jet/index.html#systemSettings');
      END LOOP;
    END IF;

    MERGE INTO prod.dct_db_health_state s
    USING (SELECT 1 state_id FROM dual) x ON (s.state_id=x.state_id)
    WHEN MATCHED THEN UPDATE SET
      s.checked_at=SYSTIMESTAMP,s.checked_by=SUBSTR(NVL(p_checked_by,'SYSTEM'),1,100),
      s.invalid_object_count=l_invalid,s.unusable_index_count=l_indexes,
      s.unusable_part_count=l_parts,s.health_status=l_status,s.issue_signature=l_signature,
      s.alerted_signature=CASE WHEN l_status='WARNING' THEN l_signature ELSE NULL END,
      s.last_alert_at=CASE
        WHEN l_status='WARNING' AND NVL(l_previous,'-')<>l_signature THEN SYSTIMESTAMP
        ELSE s.last_alert_at END
    WHEN NOT MATCHED THEN INSERT
      (state_id,checked_at,checked_by,invalid_object_count,unusable_index_count,
       unusable_part_count,health_status,issue_signature,alerted_signature,last_alert_at)
    VALUES
      (1,SYSTIMESTAMP,SUBSTR(NVL(p_checked_by,'SYSTEM'),1,100),l_invalid,l_indexes,l_parts,
       l_status,l_signature,CASE WHEN l_status='WARNING' THEN l_signature END,
       CASE WHEN l_status='WARNING' THEN SYSTIMESTAMP END);
    COMMIT;
  END perform_check;

  PROCEDURE check_health IS
  BEGIN
    perform_check('SCHEDULER');
  END check_health;

  PROCEDURE run_health_check(p_checked_by VARCHAR2) IS
  BEGIN
    perform_check(p_checked_by);
  END run_health_check;
END dct_db_health_pkg;
/

CREATE OR REPLACE PROCEDURE prod.grant_dct_db_health_tmp AUTHID DEFINER AS
BEGIN
  EXECUTE IMMEDIATE 'GRANT SELECT ON prod.dct_db_health_state TO admin';
  EXECUTE IMMEDIATE 'GRANT EXECUTE ON prod.dct_db_health_pkg TO admin';
END;
/
BEGIN prod.grant_dct_db_health_tmp; END;
/
DROP PROCEDURE prod.grant_dct_db_health_tmp;

PROMPT === 3. Daily 01:00 Dubai scheduler job ===

DECLARE
  l_exists NUMBER;
  l_start TIMESTAMP WITH TIME ZONE;
BEGIN
  l_start:=TO_TIMESTAMP_TZ(
    TO_CHAR(SYSTIMESTAMP AT TIME ZONE 'Asia/Dubai'+INTERVAL '1' DAY,'YYYY-MM-DD')||
    ' 01:00:00 Asia/Dubai','YYYY-MM-DD HH24:MI:SS TZR');
  SELECT COUNT(*) INTO l_exists FROM dba_scheduler_jobs
   WHERE owner='PROD' AND job_name='DCT_DB_HEALTH_JOB';
  IF l_exists=0 THEN
    DBMS_SCHEDULER.CREATE_JOB(
      job_name=>'PROD.DCT_DB_HEALTH_JOB',job_type=>'STORED_PROCEDURE',
      job_action=>'PROD.DCT_DB_HEALTH_PKG.CHECK_HEALTH',start_date=>l_start,
      repeat_interval=>'FREQ=DAILY;BYHOUR=1;BYMINUTE=0;BYSECOND=0',
      enabled=>FALSE,auto_drop=>FALSE,
      comments=>'Daily invalid-object and unusable-index check with SYS_ADMIN warning');
  ELSE
    DBMS_SCHEDULER.DISABLE('PROD.DCT_DB_HEALTH_JOB',force=>TRUE);
    DBMS_SCHEDULER.SET_ATTRIBUTE('PROD.DCT_DB_HEALTH_JOB','job_action',
                                 'PROD.DCT_DB_HEALTH_PKG.CHECK_HEALTH');
    DBMS_SCHEDULER.SET_ATTRIBUTE('PROD.DCT_DB_HEALTH_JOB','start_date',l_start);
    DBMS_SCHEDULER.SET_ATTRIBUTE('PROD.DCT_DB_HEALTH_JOB','repeat_interval',
                                 'FREQ=DAILY;BYHOUR=1;BYMINUTE=0;BYSECOND=0');
  END IF;
  DBMS_SCHEDULER.ENABLE('PROD.DCT_DB_HEALTH_JOB');
END;
/

BEGIN
  prod.dct_db_health_pkg.check_health;
END;
/

PROMPT === 4. SYS_ADMIN health endpoints ===

CREATE OR REPLACE PROCEDURE admin.setup_dct_db_health_ords_tmp AS
BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'dct.admin',p_pattern=>'maintenance/db-health');
  ORDS.DEFINE_HANDLER(
    p_module_name=>'dct.admin',p_pattern=>'maintenance/db-health',p_method=>'GET',
    p_source_type=>ORDS.source_type_plsql,
    p_source=>q'!
DECLARE
  l_user VARCHAR2(100):=dct_rest.validate_session;
  l_state prod.dct_db_health_state%ROWTYPE;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN may view database object health'); RETURN;
  END IF;
  SELECT * INTO l_state FROM prod.dct_db_health_state WHERE state_id=1;

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('status',l_state.health_status);
  APEX_JSON.write('invalidObjects',l_state.invalid_object_count);
  APEX_JSON.write('unusableIndexes',l_state.unusable_index_count);
  APEX_JSON.write('unusablePartitions',l_state.unusable_part_count);
  APEX_JSON.write('checkedAt',TO_CHAR(l_state.checked_at AT TIME ZONE 'Asia/Dubai','YYYY-MM-DD HH24:MI'));
  APEX_JSON.write('checkedBy',l_state.checked_by);
  APEX_JSON.open_array('issues');
  FOR r IN (
    SELECT issue_type,object_name,object_type,status
      FROM (
        SELECT 'INVALID_OBJECT' issue_type,object_name,object_type,status
          FROM dba_objects WHERE owner='PROD' AND status<>'VALID' AND object_name NOT LIKE 'BIN$%'
        UNION ALL
        SELECT 'UNUSABLE_INDEX',index_name,'INDEX',status
          FROM dba_indexes WHERE owner='PROD' AND status='UNUSABLE'
        UNION ALL
        SELECT 'UNUSABLE_PARTITION',index_name||' / '||partition_name,'INDEX PARTITION',status
          FROM dba_ind_partitions WHERE index_owner='PROD' AND status='UNUSABLE'
      ) ORDER BY issue_type,object_name FETCH FIRST 100 ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('issueType',r.issue_type);
    APEX_JSON.write('objectName',r.object_name);
    APEX_JSON.write('objectType',r.object_type);
    APEX_JSON.write('status',r.status);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Database health has not been checked yet');
WHEN OTHERS THEN dct_rest.err(500,SQLERRM);
END;
!');

  ORDS.DEFINE_HANDLER(
    p_module_name=>'dct.admin',p_pattern=>'maintenance/db-health',p_method=>'POST',
    p_source_type=>ORDS.source_type_plsql,
    p_source=>q'!
DECLARE
  l_user VARCHAR2(100):=dct_rest.validate_session;
  l_state prod.dct_db_health_state%ROWTYPE;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN may run database object health checks'); RETURN;
  END IF;
  prod.dct_db_health_pkg.run_health_check(l_user);
  SELECT * INTO l_state FROM prod.dct_db_health_state WHERE state_id=1;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('status',l_state.health_status);
  APEX_JSON.write('invalidObjects',l_state.invalid_object_count);
  APEX_JSON.write('unusableIndexes',l_state.unusable_index_count);
  APEX_JSON.write('unusablePartitions',l_state.unusable_part_count);
  APEX_JSON.write('checkedAt',TO_CHAR(l_state.checked_at AT TIME ZONE 'Asia/Dubai','YYYY-MM-DD HH24:MI'));
  APEX_JSON.write('checkedBy',l_state.checked_by);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);
END;
!');
END;
/

BEGIN
  admin.setup_dct_db_health_ords_tmp;
  COMMIT;
END;
/
DROP PROCEDURE admin.setup_dct_db_health_ords_tmp;

PROMPT === 5. Verification ===
SELECT state_id,checked_at,checked_by,invalid_object_count,unusable_index_count,
       unusable_part_count,health_status FROM prod.dct_db_health_state;
SELECT object_name,object_type,status FROM dba_objects
 WHERE owner='PROD' AND object_name='DCT_DB_HEALTH_PKG' ORDER BY object_type;
SELECT owner,job_name,enabled,state,repeat_interval,next_run_date FROM dba_scheduler_jobs
 WHERE owner='PROD' AND job_name='DCT_DB_HEALTH_JOB';

PROMPT db/v2/79 database object health complete.
EXIT
