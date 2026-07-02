-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 09a workers ORDS endpoints (ADDITIVE)
-- File   : reporting/db/09a_rpt_workers_ords.sql
-- Adds to: rpt.rest (does NOT delete/redefine the module)
-- Run as : sql -name prod_mcp   (fresh session). If 04_rpt_ords.sql is ever
--          re-run, re-run THIS script after it (04 DELETE_MODULEs rpt.rest).
-- Endpoints (SYS_ADMIN only):
--   GET    workers/               workers + derived health + queue stats +
--                                 scheduler jobs (native sweep + maintenance)
--   POST   workers/command        {workerId, command: PAUSE|RESUME|STOP|CLEAR}
--   POST   workers/remove         {workerId}  (delete a dead/stopped row)
--   POST   workers/reclaim        requeue stuck RUNNING runs (reclaim_stuck)
--   POST   workers/job            {jobName, enabled: Y|N} for the two
--                                 DCT_RPT_* DBMS_SCHEDULER jobs
-- Health: ONLINE hb < 90s, STALE < 10min, else OFFLINE.
-- Zero blank lines inside statements; each statement kept small.
-- CRLF + UTF-8 no BOM.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. GET workers/ ===
BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name => 'rpt.rest', p_pattern => 'workers/');
  ORDS.DEFINE_HANDLER(
    p_module_name => 'rpt.rest', p_pattern => 'workers/', p_method => 'GET',
    p_source_type => ORDS.source_type_plsql,
    p_source      => REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_q NUMBER; l_r NUMBER; l_f NUMBER; l_s NUMBER; l_old NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('workers');
  FOR c IN (
    SELECT w.*,
           ROUND((CAST(SYSTIMESTAMP AS DATE) - CAST(w.last_heartbeat AS DATE)) * 86400) AS hb_ago,
           CASE
             WHEN w.status = 'STOPPED' THEN 'OFFLINE'
             WHEN w.last_heartbeat IS NULL THEN 'OFFLINE'
             WHEN (CAST(SYSTIMESTAMP AS DATE) - CAST(w.last_heartbeat AS DATE)) * 86400 < 90 THEN 'ONLINE'
             WHEN (CAST(SYSTIMESTAMP AS DATE) - CAST(w.last_heartbeat AS DATE)) * 86400 < 600 THEN 'STALE'
             ELSE 'OFFLINE'
           END AS health
    FROM dct_rpt_worker w
    ORDER BY w.last_heartbeat DESC NULLS LAST
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('workerId', c.worker_id);
    APEX_JSON.write('engine', c.engine);
    APEX_JSON.write('hostname', NVL(c.hostname,''));
    APEX_JSON.write('pid', c.pid);
    APEX_JSON.write('status', c.status);
    APEX_JSON.write('health', c.health);
    APEX_JSON.write('command', NVL(c.command,''));
    APEX_JSON.write('currentRunId', c.current_run_id);
    APEX_JSON.write('runsDone', c.runs_done);
    APEX_JSON.write('runsFailed', c.runs_failed);
    APEX_JSON.write('startedAt', NVL(TO_CHAR(dct_to_local(c.started_at),'YYYY-MM-DD HH:MI AM'),''));
    APEX_JSON.write('lastHeartbeat', NVL(TO_CHAR(dct_to_local(c.last_heartbeat),'YYYY-MM-DD HH:MI AM'),''));
    APEX_JSON.write('heartbeatAgoSec', c.hb_ago);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  SELECT COUNT(CASE WHEN status='QUEUED' THEN 1 END),
         COUNT(CASE WHEN status='RUNNING' THEN 1 END),
         COUNT(CASE WHEN status='FAILED'  AND created_at >= TRUNC(SYSDATE) THEN 1 END),
         COUNT(CASE WHEN status='SUCCESS' AND created_at >= TRUNC(SYSDATE) THEN 1 END),
         NVL(MAX(CASE WHEN status='QUEUED' THEN ROUND((CAST(SYSTIMESTAMP AS DATE) - CAST(created_at AS DATE)) * 1440) END), 0)
    INTO l_q, l_r, l_f, l_s, l_old
    FROM dct_rpt_run;
  APEX_JSON.open_object('queue');
  APEX_JSON.write('queued', l_q); APEX_JSON.write('running', l_r);
  APEX_JSON.write('failedToday', l_f); APEX_JSON.write('successToday', l_s);
  APEX_JSON.write('oldestQueuedMin', l_old);
  APEX_JSON.close_object;
  APEX_JSON.open_array('jobs');
  FOR j IN (
    SELECT job_name, enabled, state,
           TO_CHAR(last_start_date AT TIME ZONE 'Asia/Dubai','YYYY-MM-DD HH:MI AM') AS last_run,
           TO_CHAR(next_run_date AT TIME ZONE 'Asia/Dubai','YYYY-MM-DD HH:MI AM') AS next_run
    FROM user_scheduler_jobs
    WHERE job_name IN ('DCT_RPT_NATIVE_JOB','DCT_RPT_MAINT_JOB')
    ORDER BY job_name
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('jobName', j.job_name);
    APEX_JSON.write('enabled', j.enabled);
    APEX_JSON.write('state', NVL(j.state,''));
    APEX_JSON.write('lastRun', NVL(j.last_run,''));
    APEX_JSON.write('nextRun', NVL(j.next_run,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!', '[COLON]', CHR(58)));
  COMMIT;
END;
/

PROMPT === 2. POST workers/command ===
BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name => 'rpt.rest', p_pattern => 'workers/command');
  ORDS.DEFINE_HANDLER(
    p_module_name => 'rpt.rest', p_pattern => 'workers/command', p_method => 'POST',
    p_source_type => ORDS.source_type_plsql,
    p_source      => REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   VARCHAR2(120);
  l_cmd  VARCHAR2(20);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_id  := APEX_JSON.get_varchar2(p_path=>'workerId');
  l_cmd := UPPER(APEX_JSON.get_varchar2(p_path=>'command'));
  IF l_id IS NULL OR l_cmd NOT IN ('PAUSE','RESUME','STOP','CLEAR') THEN
    dct_rest.err(400,'workerId and command (PAUSE|RESUME|STOP|CLEAR) are required'); RETURN;
  END IF;
  UPDATE dct_rpt_worker
     SET command = CASE WHEN l_cmd = 'CLEAR' THEN NULL ELSE l_cmd END
   WHERE worker_id = l_id;
  IF SQL%ROWCOUNT = 0 THEN dct_rest.err(404,'Worker not found'); RETURN; END IF;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!', '[COLON]', CHR(58)));
  COMMIT;
END;
/

PROMPT === 3. POST workers/remove ===
BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name => 'rpt.rest', p_pattern => 'workers/remove');
  ORDS.DEFINE_HANDLER(
    p_module_name => 'rpt.rest', p_pattern => 'workers/remove', p_method => 'POST',
    p_source_type => ORDS.source_type_plsql,
    p_source      => REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   VARCHAR2(120);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_id := APEX_JSON.get_varchar2(p_path=>'workerId');
  IF l_id IS NULL THEN dct_rest.err(400,'workerId is required'); RETURN; END IF;
  DELETE FROM dct_rpt_worker WHERE worker_id = l_id;
  IF SQL%ROWCOUNT = 0 THEN dct_rest.err(404,'Worker not found'); RETURN; END IF;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!', '[COLON]', CHR(58)));
  COMMIT;
END;
/

PROMPT === 4. POST workers/reclaim ===
BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name => 'rpt.rest', p_pattern => 'workers/reclaim');
  ORDS.DEFINE_HANDLER(
    p_module_name => 'rpt.rest', p_pattern => 'workers/reclaim', p_method => 'POST',
    p_source_type => ORDS.source_type_plsql,
    p_source      => REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rpt_pkg.reclaim_stuck;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!', '[COLON]', CHR(58)));
  COMMIT;
END;
/

PROMPT === 5. POST workers/job ===
BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name => 'rpt.rest', p_pattern => 'workers/job');
  ORDS.DEFINE_HANDLER(
    p_module_name => 'rpt.rest', p_pattern => 'workers/job', p_method => 'POST',
    p_source_type => ORDS.source_type_plsql,
    p_source      => REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_job  VARCHAR2(60);
  l_en   VARCHAR2(1);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_job := UPPER(APEX_JSON.get_varchar2(p_path=>'jobName'));
  l_en  := UPPER(APEX_JSON.get_varchar2(p_path=>'enabled'));
  IF l_job NOT IN ('DCT_RPT_NATIVE_JOB','DCT_RPT_MAINT_JOB') OR l_en NOT IN ('Y','N') THEN
    dct_rest.err(400,'jobName (DCT_RPT_NATIVE_JOB|DCT_RPT_MAINT_JOB) and enabled (Y|N) are required'); RETURN;
  END IF;
  IF l_en = 'Y' THEN DBMS_SCHEDULER.ENABLE(l_job); ELSE DBMS_SCHEDULER.DISABLE(l_job, force => TRUE); END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!', '[COLON]', CHR(58)));
  COMMIT;
END;
/

PROMPT ============================================================
PROMPT  09a_rpt_workers_ords.sql complete (5 workers endpoints).
PROMPT ============================================================
