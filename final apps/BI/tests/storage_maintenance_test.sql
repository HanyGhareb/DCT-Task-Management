-- Synthetic expired/fresh outputs; never delete or alter real report content.
SET DEFINE OFF
SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT FAILURE ROLLBACK
DECLARE
 l_run NUMBER; l_before NUMBER; l_after NUMBER; l_id NUMBER; l_n NUMBER; l_bytes NUMBER;
 l_status VARCHAR2(16); l_error VARCHAR2(2000); l_blob BLOB;
 PROCEDURE check_it(p_name VARCHAR2,p_ok BOOLEAN) IS
 BEGIN
  IF p_ok THEN DBMS_OUTPUT.PUT_LINE('PASS '||p_name);
  ELSE RAISE_APPLICATION_ERROR(-20001,'FAIL '||p_name); END IF;
 END;
BEGIN
 check_it('Retention unchanged at 90',prod.dct_rpt_pkg.cfg('OUTPUT_RETAIN_DAYS')='90');
 SELECT COUNT(*) INTO l_n FROM prod.dct_rpt_output WHERE created_at<SYSTIMESTAMP-INTERVAL '90' DAY;
 check_it('No real outputs eligible before fixture',l_n=0);
 SELECT COUNT(*) INTO l_before FROM prod.dct_rpt_output;
 INSERT INTO prod.dct_rpt_run(report_code,engine,status,requested_by,formats)
 VALUES('UAT_STORAGE_MAINT','PYTHON','SUCCESS','UAT_STORAGE_MAINT','PDF') RETURNING run_id INTO l_run;
 l_blob:=TO_BLOB(UTL_RAW.CAST_TO_RAW('synthetic output'));
 INSERT INTO prod.dct_rpt_output(run_id,format,file_name,file_blob,file_bytes,created_at)
 VALUES(l_run,'PDF','UAT_expired.pdf',l_blob,DBMS_LOB.GETLENGTH(l_blob),SYSTIMESTAMP-INTERVAL '91' DAY);
 INSERT INTO prod.dct_rpt_output(run_id,format,file_name,file_blob,file_bytes,created_at)
 VALUES(l_run,'PDF','UAT_fresh.pdf',l_blob,DBMS_LOB.GETLENGTH(l_blob),SYSTIMESTAMP);
 COMMIT;
 prod.dct_rpt_maint;
 SELECT COUNT(*) INTO l_n FROM prod.dct_rpt_output WHERE run_id=l_run;
 check_it('Only expired fixture removed',l_n=1);
 SELECT COUNT(*) INTO l_n FROM prod.dct_rpt_run WHERE run_id=l_run;
 check_it('Run history preserved',l_n=1);
 SELECT cleanup_id,status,files_deleted,bytes_deleted INTO l_id,l_status,l_n,l_bytes
 FROM prod.dct_rpt_cleanup_log ORDER BY cleanup_id DESC FETCH FIRST 1 ROW ONLY;
 check_it('Audit records success and exact file count',l_status='SUCCESS' AND l_n=1);
 check_it('Audit records exact bytes',l_bytes=DBMS_LOB.GETLENGTH(l_blob));
 SELECT COUNT(*) INTO l_n FROM prod.dct_rpt_cleanup_log WHERE cleanup_id=l_id
 AND finished_at>=started_at AND retention_days=90 AND cutoff_at IS NOT NULL;
 check_it('Audit records timing and policy',l_n=1);
 SELECT COUNT(*) INTO l_after FROM prod.dct_rpt_output WHERE run_id<>l_run;
 check_it('All real outputs preserved',l_after>=l_before);
 DELETE FROM prod.dct_rpt_run WHERE run_id=l_run; COMMIT;
 prod.dct_rpt_maint;
 SELECT files_deleted INTO l_n FROM prod.dct_rpt_cleanup_log ORDER BY cleanup_id DESC FETCH FIRST 1 ROW ONLY;
 check_it('Repeated cleanup safely records zero deletions',l_n=0);
 SELECT COUNT(*) INTO l_n FROM all_scheduler_jobs WHERE job_name='DCT_RPT_MAINT_JOB' AND enabled='TRUE';
 check_it('Exactly one enabled maintenance schedule',l_n=1);
 SELECT COUNT(*) INTO l_n FROM user_scheduler_jobs WHERE job_name='DCT_RPT_MAINT_JOB' AND enabled='TRUE';
 check_it('BI-managed ADMIN schedule retained',l_n=1);
EXCEPTION WHEN OTHERS THEN
 l_error:=SQLERRM; ROLLBACK;
 IF l_run IS NOT NULL THEN DELETE FROM prod.dct_rpt_run WHERE run_id=l_run; COMMIT; END IF;
 RAISE_APPLICATION_ERROR(-20002,l_error);
END;
/
exit
