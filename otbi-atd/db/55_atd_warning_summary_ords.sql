-- ===========================================================================
-- otbi-atd : deduplicated warning summary for Run Logs
-- Additive, read-only endpoint. Rerunnable; run after db/13 and db/49.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'atd.rest',p_pattern=>'warnings/summary');
  ORDS.DEFINE_HANDLER(
    p_module_name=>'atd.rest',p_pattern=>'warnings/summary',p_method=>'GET',
    p_source_type=>ORDS.source_type_plsql,
    p_source=>q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_days NUMBER := LEAST(GREATEST(NVL(TO_NUMBER(:days DEFAULT NULL ON CONVERSION ERROR),30),1),365);
  l_limit NUMBER := LEAST(GREATEST(NVL(TO_NUMBER(:limit DEFAULT NULL ON CONVERSION ERROR),25),1),100);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    WITH latest AS (
      SELECT job_name,MAX(run_id) run_id FROM atd_load_run_log GROUP BY job_name
    ), issues AS (
      -- Precise data-quality issues: one group per job, column and warning code.
      SELECT l.job_name,w.warning_code issue_code,w.column_name,
             MAX(NVL(w.message,w.warning_code)) KEEP (DENSE_RANK LAST ORDER BY l.run_id) issue,
             MIN(l.started) first_seen,MAX(l.started) last_seen,
             COUNT(DISTINCT l.run_id) affected_runs,MAX(l.run_id) latest_run_id
        FROM atd_load_row_warning w JOIN atd_load_run_log l ON l.run_id=w.run_id
       WHERE l.started>SYSTIMESTAMP-NUMTODSINTERVAL(l_days,'DAY')
       GROUP BY l.job_name,w.warning_code,w.column_name
      UNION ALL
      -- Schema/drift messages: group by the first semicolon-delimited issue.
      SELECT l.job_name,'RUN_MESSAGE',CAST(NULL AS VARCHAR2(128)),
             REGEXP_SUBSTR(DBMS_LOB.SUBSTR(l.message,1000,1),'^[^;]+') issue,
             MIN(l.started),MAX(l.started),COUNT(*),MAX(l.run_id)
        FROM atd_load_run_log l
       WHERE l.status='SUCCESS' AND l.message IS NOT NULL
         AND LOWER(DBMS_LOB.SUBSTR(l.message,100,1)) NOT LIKE 'analysis returned no data this run%'
         AND l.started>SYSTIMESTAMP-NUMTODSINTERVAL(l_days,'DAY')
         AND UPPER(DBMS_LOB.SUBSTR(l.message,20,1)) NOT LIKE 'WARNING:%'
       GROUP BY l.job_name,REGEXP_SUBSTR(DBMS_LOB.SUBSTR(l.message,1000,1),'^[^;]+')
    )
    SELECT * FROM (
      SELECT i.*,CASE WHEN i.latest_run_id=x.run_id THEN 'Y' ELSE 'N' END active
        FROM issues i JOIN latest x ON x.job_name=i.job_name
       ORDER BY CASE WHEN i.latest_run_id=x.run_id THEN 0 ELSE 1 END,i.last_seen DESC
    ) WHERE ROWNUM<=l_limit
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('jobName',r.job_name); APEX_JSON.write('issueCode',r.issue_code);
    APEX_JSON.write('columnName',NVL(r.column_name,'')); APEX_JSON.write('issue',r.issue);
    APEX_JSON.write('firstSeen',TO_CHAR(dct_to_local(r.first_seen),'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.write('lastSeen',TO_CHAR(dct_to_local(r.last_seen),'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.write('affectedRuns',r.affected_runs); APEX_JSON.write('latestRunId',r.latest_run_id);
    APEX_JSON.write('active',r.active); APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);
END;!');
  COMMIT;
END;
/
PROMPT otbi-atd 55 warning summary endpoint : done
WHENEVER SQLERROR CONTINUE
