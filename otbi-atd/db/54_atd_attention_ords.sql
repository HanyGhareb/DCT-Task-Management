-- ===========================================================================
-- otbi-atd : dashboard Needs Attention feed
-- Additive, read-only endpoint. Rerunnable; run after db/13 if that module is rebuilt.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

BEGIN
  ORDS.DEFINE_TEMPLATE(
    p_module_name => 'atd.rest',
    p_pattern     => 'attention');

  ORDS.DEFINE_HANDLER(
    p_module_name => 'atd.rest',
    p_pattern     => 'attention',
    p_method      => 'GET',
    p_source_type => ORDS.source_type_plsql,
    p_source      => q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  PROCEDURE item(
    p_job VARCHAR2, p_reason VARCHAR2, p_severity VARCHAR2, p_route VARCHAR2,
    p_status VARCHAR2 DEFAULT NULL, p_count NUMBER DEFAULT NULL,
    p_age NUMBER DEFAULT NULL, p_freq NUMBER DEFAULT NULL,
    p_when VARCHAR2 DEFAULT NULL, p_run NUMBER DEFAULT NULL) IS
  BEGIN
    APEX_JSON.open_object;
    APEX_JSON.write('jobName',p_job); APEX_JSON.write('reasonCode',p_reason);
    APEX_JSON.write('severity',p_severity); APEX_JSON.write('route',p_route);
    APEX_JSON.write('status',NVL(p_status,''));
    IF p_count IS NOT NULL THEN APEX_JSON.write('count',p_count); END IF;
    IF p_age IS NOT NULL THEN APEX_JSON.write('ageMin',p_age); END IF;
    IF p_freq IS NOT NULL THEN APEX_JSON.write('frequencyMin',p_freq); END IF;
    APEX_JSON.write('occurred',NVL(p_when,''));
    IF p_run IS NOT NULL THEN APEX_JSON.write('runId',p_run); END IF;
    APEX_JSON.close_object;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('items');

  -- Enabled jobs whose latest failure has not yet been followed by a success.
  FOR r IN (
    WITH last_ok AS (SELECT job_name,MAX(run_id) run_id FROM atd_load_run_log
                     WHERE status='SUCCESS' GROUP BY job_name)
    SELECT j.job_name,COUNT(*) fail_count,MAX(l.run_id) run_id,
           TO_CHAR(dct_to_local(MAX(l.started)),'YYYY-MM-DD HH:MI AM') occurred
      FROM atd_otbi_jobs j
      JOIN atd_load_run_log l ON l.job_name=j.job_name AND l.status='FAILED'
      LEFT JOIN last_ok o ON o.job_name=j.job_name
     WHERE j.enabled='Y' AND l.run_id>NVL(o.run_id,0)
     GROUP BY j.job_name
  ) LOOP
    item(r.job_name,'FAILURES','critical','runs','FAILED',r.fail_count,NULL,NULL,r.occurred,r.run_id);
  END LOOP;

  -- Running rows or worker claims that outlive their lease.
  FOR r IN (
    SELECT j.job_name,j.run_status,MAX(l.run_id) run_id,
           TO_CHAR(dct_to_local(COALESCE(MAX(l.started),j.claimed_at)),'YYYY-MM-DD HH:MI AM') occurred
      FROM atd_otbi_jobs j LEFT JOIN atd_load_run_log l
        ON l.job_name=j.job_name AND l.status='RUNNING'
     WHERE j.enabled='Y' AND (l.run_id IS NOT NULL OR
           (j.run_status='CLAIMED' AND NVL(j.lease_expires_at,SYSTIMESTAMP-INTERVAL '1' SECOND)<SYSTIMESTAMP))
     GROUP BY j.job_name,j.run_status,j.claimed_at
  ) LOOP
    item(r.job_name,'STUCK','critical','runs',r.run_status,NULL,NULL,NULL,r.occurred,r.run_id);
  END LOOP;

  -- Freshness uses the effective Job Set frequency, not the job's raw frequency.
  FOR r IN (
    WITH ok AS (SELECT job_name,MAX(finished) finished FROM atd_load_run_log
                WHERE status='SUCCESS' GROUP BY job_name)
    SELECT j.job_name,ROUND((CAST(SYSTIMESTAMP AS DATE)-CAST(o.finished AS DATE))*1440) age_min,
           atd_set_eff_freq(j.job_name,j.frequency_minutes) frequency_min,
           TO_CHAR(dct_to_local(o.finished),'YYYY-MM-DD HH:MI AM') occurred
      FROM atd_otbi_jobs j JOIN ok o ON o.job_name=j.job_name
     WHERE j.enabled='Y'
       AND atd_set_gate_ok(j.job_name)='Y'
       AND ROUND((CAST(SYSTIMESTAMP AS DATE)-CAST(o.finished AS DATE))*1440) >
           2*NVL(atd_set_eff_freq(j.job_name,j.frequency_minutes),15)
       AND NOT EXISTS (SELECT 1 FROM atd_load_run_log x
                        WHERE x.job_name=j.job_name AND x.status IN ('FAILED','RUNNING')
                          AND x.finished>=o.finished)
  ) LOOP
    item(r.job_name,'OVERDUE','warning','jobs',NULL,NULL,r.age_min,r.frequency_min,r.occurred,NULL);
  END LOOP;

  -- Repeated warnings remain actionable only while the latest run is warned.
  FOR r IN (
    SELECT j.job_name,l.run_id,l.warn_count,
           TO_CHAR(dct_to_local(l.started),'YYYY-MM-DD HH:MI AM') occurred
      FROM atd_otbi_jobs j
      CROSS APPLY (
        SELECT z.run_id,z.started,z.message,
               (SELECT COUNT(*) FROM atd_load_run_log w WHERE w.job_name=j.job_name
                 AND w.status='SUCCESS' AND w.message IS NOT NULL
                 AND LOWER(DBMS_LOB.SUBSTR(w.message,100,1)) NOT LIKE 'analysis returned no data this run%'
                 AND w.started>SYSTIMESTAMP-INTERVAL '1' DAY) warn_count
          FROM (SELECT run_id,started,message FROM atd_load_run_log x
                 WHERE x.job_name=j.job_name ORDER BY run_id DESC FETCH FIRST 1 ROW ONLY) z
      ) l
     WHERE j.enabled='Y' AND l.message IS NOT NULL
       AND LOWER(DBMS_LOB.SUBSTR(l.message,100,1)) NOT LIKE 'analysis returned no data this run%'
       AND l.warn_count>=2
  ) LOOP
    item(r.job_name,'WARNING_REPEAT','warning','runs','WARNING',r.warn_count,NULL,NULL,r.occurred,r.run_id);
  END LOOP;

  -- Disabled jobs should never look active in the operational queue.
  FOR r IN (SELECT job_name,run_status,TO_CHAR(dct_to_local(claimed_at),'YYYY-MM-DD HH:MI AM') occurred
              FROM atd_otbi_jobs WHERE enabled='N' AND run_status IN ('READY','CLAIMED','FAILED')) LOOP
    item(r.job_name,'DISABLED_ACTIVE','info','jobs',r.run_status,NULL,NULL,NULL,r.occurred,NULL);
  END LOOP;

  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);
END;!');
  COMMIT;
END;
/

PROMPT otbi-atd 54 attention endpoint : done
WHENEVER SQLERROR CONTINUE
