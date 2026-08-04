-- Job Set Run Now must queue members without destroying their configured
-- priority/run_order. Deploys only ATD_SET_PKG; no tables, jobs, or handlers.
SET DEFINE OFF
SET SERVEROUTPUT ON

CREATE OR REPLACE PACKAGE BODY prod.atd_set_pkg AS
  FUNCTION run_now (p_set VARCHAR2) RETURN NUMBER IS
    n NUMBER;
  BEGIN
    UPDATE prod.atd_otbi_jobs
       SET run_status='READY',claimed_by=NULL,claimed_at=NULL,updated_at=SYSTIMESTAMP
     WHERE enabled='Y'
       AND job_name IN (SELECT job_name FROM prod.atd_job_set_member
                         WHERE set_code=p_set AND enabled_in_set='Y');
    n:=SQL%ROWCOUNT; COMMIT; RETURN n;
  END run_now;

  PROCEDURE notify_sweep IS
    l_enabled VARCHAR2(20); l_wm NUMBER; l_max NUMBER; l_roleid NUMBER;
    FUNCTION cfg(p_key VARCHAR2,p_def VARCHAR2) RETURN VARCHAR2 IS r VARCHAR2(400);
    BEGIN
      SELECT config_value INTO r FROM prod.atd_runner_config WHERE config_key=p_key;
      RETURN NVL(r,p_def);
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN p_def; END;
  BEGIN
    l_enabled:=cfg('ATD_SET_NOTIFY_ENABLED','N');
    IF UPPER(NVL(l_enabled,'N')) NOT IN ('Y','1','TRUE','ON') THEN RETURN; END IF;
    BEGIN l_wm:=TO_NUMBER(cfg('ATD_SET_NOTIFY_WATERMARK','0'));
    EXCEPTION WHEN OTHERS THEN l_wm:=0; END;
    SELECT NVL(MAX(run_id),l_wm) INTO l_max FROM prod.atd_load_run_log;
    BEGIN SELECT role_id INTO l_roleid FROM prod.dct_roles WHERE role_code='SYS_ADMIN';
    EXCEPTION WHEN OTHERS THEN l_roleid:=NULL; END;
    FOR r IN (
      SELECT l.run_id,l.job_name,s.name_en,NVL(DBMS_LOB.SUBSTR(l.message,300,1),'') msg
        FROM prod.atd_load_run_log l
        JOIN prod.atd_job_set_member m ON m.job_name=l.job_name
        JOIN prod.atd_job_set s ON s.set_code=m.set_code
       WHERE l.run_id>NVL(l_wm,0) AND l.status='FAILED' AND s.notify_on_failure='Y'
       ORDER BY l.run_id
    ) LOOP
      IF l_roleid IS NOT NULL THEN
        FOR u IN (SELECT ur.user_id FROM prod.dct_user_roles ur
                   WHERE ur.role_id=l_roleid AND ur.is_active='Y'
                     AND (ur.end_date IS NULL OR ur.end_date>=SYSDATE)) LOOP
          BEGIN
            prod.dct_notify.send(p_recipient_user_id=>u.user_id,
              p_notification_type=>'ATD_JOB_FAILED',
              p_title_en=>'Job Set "'||r.name_en||'" - job failed',
              p_body_en=>'Job '||r.job_name||' failed. '||r.msg,p_module_code=>'ATD');
          EXCEPTION WHEN OTHERS THEN NULL; END;
        END LOOP;
      END IF;
    END LOOP;
    UPDATE prod.atd_runner_config SET config_value=TO_CHAR(l_max)
     WHERE config_key='ATD_SET_NOTIFY_WATERMARK';
    COMMIT;
  EXCEPTION WHEN OTHERS THEN ROLLBACK;
  END notify_sweep;
END atd_set_pkg;
/
SHOW ERRORS PACKAGE BODY prod.atd_set_pkg
