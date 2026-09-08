-- Output maintenance and audit. Fresh ADMIN SQLcl session; no retention changes.
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT FAILURE ROLLBACK
BEGIN
  EXECUTE IMMEDIATE q'[CREATE TABLE prod.dct_rpt_cleanup_log (
    cleanup_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    started_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    finished_at TIMESTAMP,
    retention_days NUMBER,
    cutoff_at TIMESTAMP,
    files_deleted NUMBER DEFAULT 0 NOT NULL,
    bytes_deleted NUMBER DEFAULT 0 NOT NULL,
    status VARCHAR2(16) NOT NULL,
    error_message VARCHAR2(2000),
    CONSTRAINT ck_rpt_cleanup_status CHECK(status IN ('RUNNING','SUCCESS','FAILED'))
  )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF;
END;
/
CREATE OR REPLACE PROCEDURE prod.dct_rpt_maint IS
  l_id NUMBER; l_retain NUMBER; l_cutoff TIMESTAMP;
  l_count NUMBER := 0; l_size NUMBER := 0; l_error VARCHAR2(2000);
  TYPE sizes IS TABLE OF NUMBER;
  l_sizes sizes;
  PROCEDURE begin_log IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    INSERT INTO prod.dct_rpt_cleanup_log(status) VALUES('RUNNING') RETURNING cleanup_id INTO l_id;
    COMMIT;
  END;
BEGIN
  begin_log;
  l_retain := TO_NUMBER(NVL(prod.dct_rpt_pkg.cfg('OUTPUT_RETAIN_DAYS','90'),'90'));
  IF l_retain < 0 OR l_retain != TRUNC(l_retain) THEN
    RAISE_APPLICATION_ERROR(-20001,'OUTPUT_RETAIN_DAYS must be a nonnegative whole number');
  END IF;
  prod.dct_rpt_pkg.reclaim_stuck;
  IF l_retain > 0 THEN
    l_cutoff := SYSTIMESTAMP - NUMTODSINTERVAL(l_retain,'DAY');
    DELETE FROM prod.dct_rpt_output WHERE created_at < l_cutoff
      RETURNING file_bytes BULK COLLECT INTO l_sizes;
    l_count := SQL%ROWCOUNT;
    FOR i IN 1..l_sizes.COUNT LOOP l_size := l_size + NVL(l_sizes(i),0); END LOOP;
  END IF;
  -- Successful audit and deletions commit together. Run history is untouched.
  UPDATE prod.dct_rpt_cleanup_log SET finished_at=SYSTIMESTAMP,retention_days=l_retain,
    cutoff_at=l_cutoff,files_deleted=l_count,bytes_deleted=l_size,status='SUCCESS'
    WHERE cleanup_id=l_id;
  COMMIT;
EXCEPTION WHEN OTHERS THEN
  l_error := SUBSTR(SQLERRM,1,2000);
  ROLLBACK;
  IF l_id IS NOT NULL THEN
    UPDATE prod.dct_rpt_cleanup_log SET finished_at=SYSTIMESTAMP,retention_days=l_retain,
      cutoff_at=l_cutoff,status='FAILED',error_message=l_error WHERE cleanup_id=l_id;
    COMMIT;
  END IF;
  RAISE;
END;
/
SHOW ERRORS PROCEDURE prod.dct_rpt_maint
DECLARE
 l_n NUMBER;
BEGIN
 SELECT COUNT(*) INTO l_n FROM all_objects WHERE owner='PROD' AND object_name='DCT_RPT_MAINT' AND status='INVALID';
 IF l_n > 0 THEN RAISE_APPLICATION_ERROR(-20001,'Maintenance procedure did not compile'); END IF;
 IF USER != 'ADMIN' THEN RAISE_APPLICATION_ERROR(-20001,'Run this script in a fresh ADMIN session'); END IF;
 -- Existing BI Workers controls inspect and manage the ADMIN-owned schedule.
 SELECT COUNT(*) INTO l_n FROM user_scheduler_jobs WHERE job_name='DCT_RPT_MAINT_JOB';
 IF l_n=0 THEN
   DBMS_SCHEDULER.CREATE_JOB(job_name=>'ADMIN.DCT_RPT_MAINT_JOB',job_type=>'PLSQL_BLOCK',
     job_action=>'BEGIN prod.dct_rpt_maint; END;',start_date=>SYSTIMESTAMP,
     repeat_interval=>'FREQ=MINUTELY;INTERVAL=15',enabled=>TRUE,
     comments=>'Reporting cleanup with audit; authoritative schedule managed by BI');
 END IF;
 -- Disable only the verified duplicate; retain its definition for rollback.
 FOR j IN (SELECT job_action FROM all_scheduler_jobs WHERE owner='PROD'
             AND job_name='DCT_RPT_MAINT_JOB' AND enabled='TRUE') LOOP
   IF UPPER(TRIM(j.job_action)) NOT IN ('PROD.DCT_RPT_MAINT','BEGIN PROD.DCT_RPT_MAINT; END;') THEN
     RAISE_APPLICATION_ERROR(-20001,'Unexpected PROD maintenance job action; review required');
   END IF;
   DBMS_SCHEDULER.DISABLE('PROD.DCT_RPT_MAINT_JOB',force=>FALSE);
 END LOOP;
END;
/
PROMPT Output maintenance audit installed; ADMIN schedule retained, duplicate disabled.
