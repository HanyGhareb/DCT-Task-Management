-- Read-only BI storage overview; SYS_ADMIN only. Requires 43. Re-run after 04.
SET DEFINE OFF
SET SQLBLANKLINES ON
WHENEVER SQLERROR EXIT FAILURE ROLLBACK
BEGIN
 ORDS.DEFINE_TEMPLATE(p_module_name=>'rpt.rest',p_pattern=>'storage');
 ORDS.DEFINE_HANDLER(p_module_name=>'rpt.rest',p_pattern=>'storage',p_method=>'GET',
  p_source_type=>ORDS.source_type_plsql,p_source=>q'!
DECLARE
 l_user VARCHAR2(100) := dct_rest.validate_session;
 l_retain NUMBER; l_count NUMBER; l_bytes NUMBER; l_exp_count NUMBER; l_exp_bytes NUMBER;
 l_week NUMBER; l_month NUMBER; l_alloc NUMBER; l_cutoff TIMESTAMP;
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
 IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
 l_retain := TO_NUMBER(prod.dct_rpt_pkg.cfg('OUTPUT_RETAIN_DAYS','90'));
 l_cutoff := CASE WHEN l_retain>0 THEN SYSTIMESTAMP-NUMTODSINTERVAL(l_retain,'DAY') END;
 SELECT COUNT(*),NVL(SUM(file_bytes),0),
   COUNT(CASE WHEN created_at<l_cutoff THEN 1 END),
   NVL(SUM(CASE WHEN created_at<l_cutoff THEN file_bytes END),0),
   NVL(SUM(CASE WHEN created_at>=SYSTIMESTAMP-INTERVAL '7' DAY THEN file_bytes END),0),
   NVL(SUM(CASE WHEN created_at>=SYSTIMESTAMP-INTERVAL '30' DAY THEN file_bytes END),0)
 INTO l_count,l_bytes,l_exp_count,l_exp_bytes,l_week,l_month FROM prod.dct_rpt_output;
 BEGIN
  SELECT SUM(bytes) INTO l_alloc FROM dba_segments WHERE owner='PROD' AND (
   segment_name='DCT_RPT_OUTPUT' OR
   segment_name IN (SELECT segment_name FROM all_lobs WHERE owner='PROD' AND table_name='DCT_RPT_OUTPUT') OR
   segment_name IN (SELECT index_name FROM all_lobs WHERE owner='PROD' AND table_name='DCT_RPT_OUTPUT') OR
   segment_name IN (SELECT index_name FROM all_indexes WHERE owner='PROD' AND table_name='DCT_RPT_OUTPUT'));
 EXCEPTION WHEN OTHERS THEN l_alloc:=NULL;
 END;
 dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
 APEX_JSON.write('asOf',TO_CHAR(SYSTIMESTAMP AT TIME ZONE 'Asia/Dubai','YYYY-MM-DD HH:MI AM'));
 APEX_JSON.write('retentionDays',l_retain); APEX_JSON.write('fileCount',l_count);
 APEX_JSON.write('fileBytes',l_bytes); APEX_JSON.write('allocatedBytes',l_alloc,TRUE);
 APEX_JSON.write('expiredCount',l_exp_count); APEX_JSON.write('expiredBytes',l_exp_bytes);
 APEX_JSON.write('added7DaysBytes',l_week); APEX_JSON.write('added30DaysBytes',l_month);
 APEX_JSON.open_array('reports');
 FOR r IN (SELECT r.report_code,NVL(MAX(d.name_en),r.report_code) name_en,MAX(d.name_ar) name_ar,
   COUNT(*) file_count,NVL(SUM(o.file_bytes),0) file_bytes,MIN(o.created_at) oldest
   FROM prod.dct_rpt_output o JOIN prod.dct_rpt_run r ON r.run_id=o.run_id
   LEFT JOIN prod.dct_rpt_definition d ON d.report_code=r.report_code
   GROUP BY r.report_code ORDER BY file_bytes DESC,r.report_code FETCH FIRST 10 ROWS ONLY) LOOP
  APEX_JSON.open_object; APEX_JSON.write('reportCode',r.report_code);
  APEX_JSON.write('name',r.name_en); APEX_JSON.write('nameAr',NVL(r.name_ar,r.name_en));
  APEX_JSON.write('fileCount',r.file_count); APEX_JSON.write('fileBytes',r.file_bytes);
  APEX_JSON.write('oldestAt',TO_CHAR(prod.dct_to_local(r.oldest),'YYYY-MM-DD'));
  APEX_JSON.close_object;
 END LOOP;
 APEX_JSON.close_array;
 APEX_JSON.open_array('cleanup');
 FOR c IN (SELECT * FROM prod.dct_rpt_cleanup_log ORDER BY cleanup_id DESC FETCH FIRST 20 ROWS ONLY) LOOP
  APEX_JSON.open_object; APEX_JSON.write('cleanupId',c.cleanup_id);
  APEX_JSON.write('startedAt',TO_CHAR(prod.dct_to_local(c.started_at),'YYYY-MM-DD HH:MI AM'));
  APEX_JSON.write('finishedAt',NVL(TO_CHAR(prod.dct_to_local(c.finished_at),'YYYY-MM-DD HH:MI AM'),''));
  APEX_JSON.write('status',c.status); APEX_JSON.write('retentionDays',c.retention_days,TRUE);
  APEX_JSON.write('filesDeleted',c.files_deleted); APEX_JSON.write('bytesDeleted',c.bytes_deleted);
  APEX_JSON.write('durationSeconds',CASE WHEN c.finished_at IS NOT NULL THEN ROUND((CAST(c.finished_at AS DATE)-CAST(c.started_at AS DATE))*86400,2) END,TRUE);
  APEX_JSON.write('error',NVL(c.error_message,'')); APEX_JSON.close_object;
 END LOOP;
 APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);
END;
!');
 COMMIT;
END;
/
PROMPT Read-only report storage endpoint installed.
