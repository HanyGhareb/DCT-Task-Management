-- =============================================================================
-- ATD Loader (App 208) -- ORDS REST API   (control plane over the ATD tables)
-- File    : 13_atd_ords.sql
-- Schema  : registered under ADMIN (the only REST-routable schema on ADB)
-- Base URL: /ords/admin/atd/
-- Run     : sql -name prod_mcp @13_atd_ords.sql   (FRESH session - synonym rule:
--           must NOT follow ALTER SESSION SET CURRENT_SCHEMA=PROD, or synonyms
--           self-reference -> ORA-01471)
-- =============================================================================
-- Admin-only (SYS_ADMIN). Manages ATD_OTBI_ENV / ATD_TARGET_DB / ATD_OTBI_JOBS
-- and reads ATD_LOAD_RUN_LOG. Queue ops delegate to PROD.ATD_QUEUE_PKG (enqueue
-- / reap_stale). Auth + helpers reuse the shared DCT_REST / DCT_AUTH packages.
-- Pagination envelope: {items,total,limit,offset}. [COLON] -> ':' at define time.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

-- =============================================================================
-- 1. ADMIN synonyms for every PROD object the handlers touch
--    (dct_rest, dct_auth already have ADMIN synonyms from earlier phases)
-- =============================================================================
CREATE OR REPLACE SYNONYM atd_otbi_env     FOR prod.atd_otbi_env;
CREATE OR REPLACE SYNONYM atd_target_db    FOR prod.atd_target_db;
CREATE OR REPLACE SYNONYM atd_otbi_jobs    FOR prod.atd_otbi_jobs;
CREATE OR REPLACE SYNONYM atd_load_run_log FOR prod.atd_load_run_log;
CREATE OR REPLACE SYNONYM atd_queue_pkg    FOR prod.atd_queue_pkg;
CREATE OR REPLACE SYNONYM atd_runner_config FOR prod.atd_runner_config;
CREATE OR REPLACE SYNONYM atd_analysis_request FOR prod.atd_analysis_request;
CREATE OR REPLACE SYNONYM atd_sa_catalog     FOR prod.atd_sa_catalog;
CREATE OR REPLACE SYNONYM atd_worker_heartbeat FOR prod.atd_worker_heartbeat;
CREATE OR REPLACE SYNONYM dct_atd_ai_pkg     FOR prod.dct_atd_ai_pkg;

-- =============================================================================
-- 2. Module + handlers (wrapped in a temp procedure so SQLcl skips bind scanning)
-- =============================================================================
CREATE OR REPLACE PROCEDURE setup_atd_ords_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'atd.rest';

    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;

    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => p_method,
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;

BEGIN

    BEGIN
        ORDS.DELETE_MODULE(p_module_name => c_mod);
    EXCEPTION WHEN OTHERS THEN NULL;
    END;

    ORDS.DEFINE_MODULE(
        p_module_name    => c_mod,
        p_base_path      => '/atd/',
        p_items_per_page => 100,
        p_status         => 'PUBLISHED',
        p_comments       => 'i-Finance -- ATD Loader control plane (App 208)');

    -- =========================================================================
    -- DASHBOARD
    -- =========================================================================
    def_template('dashboard');
    def_handler('dashboard', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_jobs NUMBER; l_enabled NUMBER;
  l_ready NUMBER; l_claimed NUMBER; l_done NUMBER; l_failed NUMBER;
  l_runs NUMBER; l_ok NUMBER; l_lastfin VARCHAR2(40);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  SELECT COUNT(*), COUNT(CASE WHEN enabled='Y' THEN 1 END) INTO l_jobs, l_enabled FROM atd_otbi_jobs;
  SELECT COUNT(CASE WHEN run_status='READY'   THEN 1 END),
         COUNT(CASE WHEN run_status='CLAIMED' THEN 1 END),
         COUNT(CASE WHEN run_status='DONE'    THEN 1 END),
         COUNT(CASE WHEN run_status='FAILED'  THEN 1 END)
    INTO l_ready, l_claimed, l_done, l_failed FROM atd_otbi_jobs;
  SELECT COUNT(*), COUNT(CASE WHEN status='SUCCESS' THEN 1 END)
    INTO l_runs, l_ok FROM atd_load_run_log WHERE started > SYSTIMESTAMP - INTERVAL '1' DAY;
  SELECT TO_CHAR(MAX(finished),'YYYY-MM-DD HH24:MI') INTO l_lastfin FROM atd_load_run_log;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('jobs', l_jobs);
  APEX_JSON.write('enabledJobs', l_enabled);
  APEX_JSON.open_object('queue');
  APEX_JSON.write('ready', l_ready);   APEX_JSON.write('claimed', l_claimed);
  APEX_JSON.write('done', l_done);     APEX_JSON.write('failed', l_failed);
  APEX_JSON.close_object;
  APEX_JSON.write('runs24h', l_runs);
  APEX_JSON.write('success24h', l_ok);
  APEX_JSON.write('successRate', CASE WHEN l_runs > 0 THEN ROUND(l_ok/l_runs*100) ELSE NULL END);
  APEX_JSON.write('lastFinished', NVL(l_lastfin,''));
  APEX_JSON.open_array('recent');
  FOR r IN (SELECT * FROM (
              SELECT run_id, job_name, status, row_count,
                     TO_CHAR(started,'YYYY-MM-DD HH24:MI')  AS started_s,
                     TO_CHAR(finished,'YYYY-MM-DD HH24:MI') AS finished_s
              FROM atd_load_run_log ORDER BY run_id DESC) WHERE ROWNUM <= 10) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('runId', r.run_id);
    APEX_JSON.write('jobName', r.job_name);
    APEX_JSON.write('status', r.status);
    APEX_JSON.write('rowCount', NVL(r.row_count,0));
    APEX_JSON.write('started', NVL(r.started_s,''));
    APEX_JSON.write('finished', NVL(r.finished_s,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('alerts');
  FOR r IN (SELECT * FROM (
              SELECT run_id, job_name, status, row_count,
                     NVL(DBMS_LOB.SUBSTR(message,300,1),'') AS msg,
                     CASE WHEN status='FAILED' THEN 'FAILED' ELSE 'WARNING' END AS kind,
                     TO_CHAR(started,'YYYY-MM-DD HH24:MI') AS started_s
              FROM atd_load_run_log
              WHERE status='FAILED' OR message IS NOT NULL
              ORDER BY run_id DESC) WHERE ROWNUM <= 10) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('runId', r.run_id);
    APEX_JSON.write('jobName', r.job_name);
    APEX_JSON.write('status', r.status);
    APEX_JSON.write('kind', r.kind);
    APEX_JSON.write('message', r.msg);
    APEX_JSON.write('started', NVL(r.started_s,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- LOOKUPS (envs + targets for form pickers)
    -- =========================================================================
    def_template('lookups');
    def_handler('lookups', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('envs');
  FOR r IN (SELECT env_name, enabled FROM atd_otbi_env ORDER BY env_name) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('envName', r.env_name); APEX_JSON.write('enabled', r.enabled);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('targets');
  FOR r IN (SELECT target_name, enabled FROM atd_target_db ORDER BY target_name) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('targetName', r.target_name); APEX_JSON.write('enabled', r.enabled);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- JOBS
    -- =========================================================================
    def_template('jobs');
    def_handler('jobs', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_status VARCHAR2(20)  := UPPER([COLON]status);
  l_search VARCHAR2(200) := [COLON]search;
  l_limit  NUMBER        := LEAST(NVL(TO_NUMBER([COLON]limit  DEFAULT NULL ON CONVERSION ERROR), 100), 500);
  l_offset NUMBER        := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  SELECT COUNT(*) INTO l_total FROM atd_otbi_jobs j
   WHERE (l_status IS NULL OR j.run_status = l_status)
     AND (l_search IS NULL OR UPPER(j.job_name||' '||j.source_ref||' '||j.stage_table)
          LIKE '%'||UPPER(l_search)||'%');
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total', l_total); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT j.job_name, j.env_name, j.target_name, j.source_ref, j.stage_table,
           j.final_table, j.load_mode, j.priority, j.run_order, j.enabled,
           j.run_status, j.claimed_by, j.claimed_at,
           CASE WHEN j.column_map_json IS NOT NULL THEN 'Y' ELSE 'N' END AS prepared,
           lr.run_id AS last_run_id2, lr.status AS last_status,
           TO_CHAR(lr.finished,'YYYY-MM-DD HH24:MI') AS last_finished,
           CASE WHEN lr.started IS NOT NULL AND lr.finished IS NOT NULL
                THEN ROUND((CAST(lr.finished AS DATE) - CAST(lr.started AS DATE)) * 86400)
                ELSE NULL END AS last_dur_sec
    FROM atd_otbi_jobs j
    OUTER APPLY (
      SELECT run_id, status, started, finished FROM (
        SELECT run_id, status, started, finished FROM atd_load_run_log l
        WHERE l.job_name = j.job_name ORDER BY run_id DESC
      ) WHERE ROWNUM = 1) lr
    WHERE (l_status IS NULL OR j.run_status = l_status)
      AND (l_search IS NULL OR UPPER(j.job_name||' '||j.source_ref||' '||j.stage_table)
           LIKE '%'||UPPER(l_search)||'%')
    ORDER BY j.priority, j.run_order, j.job_name
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('jobName', r.job_name);
    APEX_JSON.write('envName', r.env_name);
    APEX_JSON.write('targetName', r.target_name);
    APEX_JSON.write('sourceRef', r.source_ref);
    APEX_JSON.write('stageTable', r.stage_table);
    APEX_JSON.write('finalTable', NVL(r.final_table,''));
    APEX_JSON.write('loadMode', r.load_mode);
    APEX_JSON.write('priority', r.priority);
    APEX_JSON.write('runOrder', r.run_order);
    APEX_JSON.write('enabled', r.enabled);
    APEX_JSON.write('prepared', r.prepared);
    APEX_JSON.write('runStatus', r.run_status);
    APEX_JSON.write('claimedBy', NVL(r.claimed_by,''));
    APEX_JSON.write('claimedAt', TO_CHAR(r.claimed_at,'YYYY-MM-DD HH24:MI'));
    APEX_JSON.write('lastRunId', r.last_run_id2);
    APEX_JSON.write('lastRunStatus', NVL(r.last_status,''));
    APEX_JSON.write('lastFinished', NVL(r.last_finished,''));
    APEX_JSON.write('lastDurationSec', r.last_dur_sec);   -- omitted when never run
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('jobs', 'POST', q'!
DECLARE
  -- Minimal create: an analysis path is the ONLY required input. The job name,
  -- environment, target DB, staging table and column map are all auto-derived
  -- here when omitted; the column map + final table sizing are PREPARED BY THE
  -- RUNNER on first run (it profiles the live CSV). See otbi-atd/runner/prepare.py.
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_name  VARCHAR2(80);
  l_src   VARCHAR2(400);
  l_slug  VARCHAR2(40);
  l_env   VARCHAR2(80);
  l_tgt   VARCHAR2(80);
  l_stage VARCHAR2(128);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);

  l_src := APEX_JSON.get_varchar2(p_path => 'sourceRef');
  IF l_src IS NULL THEN dct_rest.err(400,'Analysis path (sourceRef) is required'); RETURN; END IF;

  -- slug = upper, non-alnum -> _, trimmed, <=26 chars (matches prepare.slug())
  l_slug := SUBSTR(TRIM('_' FROM REGEXP_REPLACE(
              UPPER(REGEXP_REPLACE(l_src, '^.*/', '')), '[^A-Za-z0-9]+', '_')), 1, 26);
  IF l_slug IS NULL THEN dct_rest.err(400,'Could not derive a name from the analysis path'); RETURN; END IF;

  l_name := NVL(APEX_JSON.get_varchar2(p_path => 'jobName'), l_slug);

  l_env := APEX_JSON.get_varchar2(p_path => 'envName');
  IF l_env IS NULL THEN
    BEGIN
      SELECT env_name INTO l_env FROM (
        SELECT env_name FROM atd_otbi_env
         WHERE enabled='Y' AND extract_track='BROWSER' ORDER BY env_name)
       WHERE ROWNUM = 1;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      dct_rest.err(400,'No enabled environment - create one first'); RETURN;
    END;
  END IF;

  l_tgt := APEX_JSON.get_varchar2(p_path => 'targetName');
  IF l_tgt IS NULL THEN
    BEGIN
      SELECT target_name INTO l_tgt FROM (
        SELECT target_name FROM atd_target_db WHERE enabled='Y' ORDER BY target_name)
       WHERE ROWNUM = 1;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      dct_rest.err(400,'No enabled target database - create one first'); RETURN;
    END;
  END IF;

  -- "Target table" is optional; default PROD.ATD_<slug> (created on first run)
  l_stage := NVL(APEX_JSON.get_varchar2(p_path => 'stageTable'),
                 NVL(APEX_JSON.get_varchar2(p_path => 'finalTable'), 'PROD.ATD_'||l_slug));

  INSERT INTO atd_otbi_jobs (
    job_name, env_name, target_name, source_ref, output_format, params_json,
    stage_table, final_table, load_mode, key_columns, column_map_json, schedule,
    enabled, priority, run_order, run_status)
  VALUES (
    l_name, l_env, l_tgt, l_src,
    NVL(APEX_JSON.get_varchar2(p_path => 'outputFormat'),'csv'),
    APEX_JSON.get_varchar2(p_path => 'paramsJson'),
    l_stage,
    APEX_JSON.get_varchar2(p_path => 'finalTable'),
    NVL(UPPER(APEX_JSON.get_varchar2(p_path => 'loadMode')),'TRUNCATE_INSERT'),
    APEX_JSON.get_varchar2(p_path => 'keyColumns'),
    APEX_JSON.get_varchar2(p_path => 'columnMapJson'),   -- usually NULL -> prepared on first run
    APEX_JSON.get_varchar2(p_path => 'schedule'),
    NVL(UPPER(APEX_JSON.get_varchar2(p_path => 'enabled')),'Y'),
    NVL(APEX_JSON.get_number(p_path => 'priority'),5),
    NVL(APEX_JSON.get_number(p_path => 'runOrder'),100),
    'READY');
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.write('jobName', l_name);
  APEX_JSON.write('stageTable', l_stage);
  APEX_JSON.write('prepared', 'N');
  APEX_JSON.close_object;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN ROLLBACK; dct_rest.err(400,'A job with that name already exists');
  WHEN OTHERS THEN ROLLBACK;
    IF SQLCODE = -2291 THEN dct_rest.err(400,'Unknown env or target'); ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!');

    -- =========================================================================
    -- ANALYSES  (build a NEW OTBI analysis from a spec; runner --build drains these)
    -- =========================================================================
    def_template('analyses');
    def_handler('analyses', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM (
              SELECT req_id, analysis_name, save_folder, status, job_name,
                     NVL(SUBSTR(message,1,300),'') AS msg, requested_by,
                     TO_CHAR(created,'YYYY-MM-DD HH24:MI')  AS created_s,
                     TO_CHAR(finished,'YYYY-MM-DD HH24:MI') AS finished_s
              FROM atd_analysis_request ORDER BY req_id DESC) WHERE ROWNUM <= 50) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('reqId', r.req_id);
    APEX_JSON.write('analysisName', NVL(r.analysis_name,''));
    APEX_JSON.write('saveFolder', NVL(r.save_folder,''));
    APEX_JSON.write('status', r.status);
    APEX_JSON.write('jobName', NVL(r.job_name,''));
    APEX_JSON.write('message', r.msg);
    APEX_JSON.write('requestedBy', NVL(r.requested_by,''));
    APEX_JSON.write('created', NVL(r.created_s,''));
    APEX_JSON.write('finished', NVL(r.finished_s,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
END;
!');
    def_handler('analyses', 'POST', q'!
DECLARE
  -- Queue a "build a new OTBI analysis" request. The whole create_analysis spec
  -- is passed as a JSON STRING in `specJson` and stored verbatim; the runner
  -- (python runner.py --build) builds it in OTBI then registers it as a job.
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_spec CLOB;
  l_name VARCHAR2(256);
  l_fldr VARCHAR2(512);
  l_id   NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_spec := APEX_JSON.get_clob(p_path => 'specJson');
  IF l_spec IS NULL OR DBMS_LOB.GETLENGTH(l_spec) = 0 THEN
    dct_rest.err(400,'specJson is required'); RETURN;
  END IF;
  l_name := APEX_JSON.get_varchar2(p_path => 'name');
  l_fldr := APEX_JSON.get_varchar2(p_path => 'saveFolder');
  INSERT INTO atd_analysis_request (spec_json, analysis_name, save_folder, requested_by, status)
  VALUES (l_spec, l_name, l_fldr, l_user, 'QUEUED')
  RETURNING req_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.write('reqId', l_id);
  APEX_JSON.write('status', 'QUEUED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- SUBJECT-AREA CATALOG  (column picker for "Add New OTBI Analysis")
    --   GET  subject-areas          -> discovered subject areas + status
    --   GET  subject-areas/columns  -> one READY subject area's folder/column tree
    --   POST subject-areas/discover -> queue a (re)scrape (runner --discover drains)
    -- =========================================================================
    def_template('subject-areas');
    def_handler('subject-areas', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT subject_area, status, folder_count, column_count,
                   NVL(SUBSTR(message,1,300),'') AS msg,
                   TO_CHAR(scraped_at,'YYYY-MM-DD HH24:MI') AS scraped_s
              FROM atd_sa_catalog ORDER BY subject_area) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('subjectArea', r.subject_area);
    APEX_JSON.write('status', r.status);
    APEX_JSON.write('folderCount', NVL(r.folder_count,0));
    APEX_JSON.write('columnCount', NVL(r.column_count,0));
    APEX_JSON.write('message', r.msg);
    APEX_JSON.write('scrapedAt', NVL(r.scraped_s,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
END;
!');

    def_template('subject-areas/columns');
    def_handler('subject-areas/columns', 'GET', q'!
DECLARE
  -- Returns the cached folder/column tree (catalog_json) for one subject area,
  -- selected via ?sa=<name>. Whenever a catalog exists it is streamed as-is (the
  -- raw catalog JSON is {subject_area,folders,scraped_at}) -- even when the row was
  -- re-queued for a re-scrape (status QUEUED), so the previously-scraped columns
  -- stay usable. Only a never-scraped row falls back to the {status,folders:[]} stub.
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_sa     VARCHAR2(256) := [COLON]sa;
  l_status VARCHAR2(20);
  l_cat    CLOB;
  l_off    NUMBER := 1;
  l_amt    CONSTANT NUMBER := 8000;
  l_len    NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  IF l_sa IS NULL THEN dct_rest.err(400,'sa query parameter is required'); RETURN; END IF;
  BEGIN
    SELECT status, catalog_json INTO l_status, l_cat
      FROM atd_sa_catalog WHERE subject_area = l_sa;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    dct_rest.err(404,'Subject area not discovered'); RETURN;
  END;
  dct_rest.json_header;
  IF l_cat IS NOT NULL AND DBMS_LOB.GETLENGTH(l_cat) > 0 THEN
    l_len := DBMS_LOB.GETLENGTH(l_cat);
    WHILE l_off <= l_len LOOP
      HTP.PRN(DBMS_LOB.SUBSTR(l_cat, l_amt, l_off));
      l_off := l_off + l_amt;
    END LOOP;
  ELSE
    APEX_JSON.initialize_output;
    APEX_JSON.open_object;
    APEX_JSON.write('subjectArea', l_sa);
    APEX_JSON.write('status', l_status);
    APEX_JSON.open_array('folders'); APEX_JSON.close_array;
    APEX_JSON.close_object;
  END IF;
END;
!');

    def_template('subject-areas/discover');
    def_handler('subject-areas/discover', 'POST', q'!
DECLARE
  -- Queue a subject area for (re)discovery. runner.py --discover drains QUEUED
  -- rows, scrapes the OTBI Answers tree, and caches the columns for the picker.
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_sa   VARCHAR2(256);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_sa := APEX_JSON.get_varchar2(p_path => 'subjectArea');
  IF l_sa IS NULL THEN dct_rest.err(400,'subjectArea is required'); RETURN; END IF;
  MERGE INTO atd_sa_catalog t USING (SELECT l_sa AS sa FROM dual) s
    ON (t.subject_area = s.sa)
  WHEN MATCHED THEN UPDATE SET status='QUEUED', message=NULL,
    requested_by=l_user, requested_at=systimestamp
  WHEN NOT MATCHED THEN INSERT (subject_area, status, requested_by)
    VALUES (l_sa, 'QUEUED', l_user);
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.write('subjectArea', l_sa);
  APEX_JSON.write('status', 'QUEUED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- discovery run history (the "Run Logs"-style table on the OTBI Discovery page).
    -- Each --discover scrape writes an atd_load_run_log row with track='DISCOVER';
    -- job_name carries the subject area, row_count carries the column count.
    def_template('subject-areas/runs');
    def_handler('subject-areas/runs', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit  DEFAULT NULL ON CONVERSION ERROR), 50), 200);
  l_offset NUMBER := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  SELECT COUNT(*) INTO l_total FROM atd_load_run_log WHERE track = 'DISCOVER';
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total', l_total); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT run_id, job_name, status, row_count,
           NVL(DBMS_LOB.SUBSTR(message,400,1),'') AS msg,
           TO_CHAR(started,'YYYY-MM-DD HH24:MI')  AS started_s,
           TO_CHAR(finished,'YYYY-MM-DD HH24:MI') AS finished_s,
           CASE WHEN started IS NOT NULL AND finished IS NOT NULL
                THEN ROUND((CAST(finished AS DATE) - CAST(started AS DATE)) * 86400)
                ELSE NULL END AS dur_sec
    FROM atd_load_run_log
    WHERE track = 'DISCOVER'
    ORDER BY run_id DESC
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('runId', r.run_id);
    APEX_JSON.write('subjectArea', r.job_name);
    APEX_JSON.write('status', r.status);
    APEX_JSON.write('columnCount', NVL(r.row_count,0));
    APEX_JSON.write('message', r.msg);
    APEX_JSON.write('started', NVL(r.started_s,''));
    APEX_JSON.write('finished', NVL(r.finished_s,''));
    APEX_JSON.write('durationSec', r.dur_sec);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- AI column suggester: free-text request -> {items:[{path,column}]} chosen from
    -- the discovered catalog (DCT_ATD_AI_PKG -> Anthropic). Body {sa, request}.
    def_template('subject-areas/suggest');
    def_handler('subject-areas/suggest', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_sa   VARCHAR2(256);
  l_req  CLOB;
  l_out  CLOB;
  l_off  NUMBER := 1;
  l_amt  CONSTANT NUMBER := 8000;
  l_len  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_sa  := APEX_JSON.get_varchar2(p_path => 'sa');
  l_req := APEX_JSON.get_varchar2(p_path => 'request');
  IF l_sa IS NULL THEN dct_rest.err(400,'sa is required'); RETURN; END IF;
  l_out := dct_atd_ai_pkg.suggest_columns(l_sa, l_req);
  dct_rest.json_header;
  l_len := DBMS_LOB.GETLENGTH(l_out);
  WHILE l_off <= l_len LOOP
    HTP.PRN(DBMS_LOB.SUBSTR(l_out, l_amt, l_off));
    l_off := l_off + l_amt;
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    CASE SQLCODE
      WHEN -20404 THEN dct_rest.err(404, SQLERRM);
      WHEN -20403 THEN dct_rest.err(403, SQLERRM);
      WHEN -20401 THEN dct_rest.err(401, SQLERRM);
      WHEN -20001 THEN dct_rest.err(400, SQLERRM);
      WHEN -20090 THEN dct_rest.err(400, SQLERRM);
      ELSE dct_rest.err(500, SQLERRM);
    END CASE;
END;
!');

    def_template('jobs/[COLON]name');
    def_handler('jobs/[COLON]name', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_found NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  SELECT COUNT(*) INTO l_found FROM atd_otbi_jobs WHERE job_name = [COLON]name;
  IF l_found = 0 THEN dct_rest.err(404,'Job not found'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  FOR r IN (SELECT * FROM atd_otbi_jobs WHERE job_name = [COLON]name) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('jobName', r.job_name);
    APEX_JSON.write('envName', r.env_name);
    APEX_JSON.write('targetName', r.target_name);
    APEX_JSON.write('sourceRef', r.source_ref);
    APEX_JSON.write('outputFormat', NVL(r.output_format,'csv'));
    APEX_JSON.write('paramsJson', NVL(DBMS_LOB.SUBSTR(r.params_json,32000,1),''));
    APEX_JSON.write('stageTable', r.stage_table);
    APEX_JSON.write('finalTable', NVL(r.final_table,''));
    APEX_JSON.write('loadMode', r.load_mode);
    APEX_JSON.write('keyColumns', NVL(r.key_columns,''));
    APEX_JSON.write('columnMapJson', NVL(DBMS_LOB.SUBSTR(r.column_map_json,32000,1),''));
    APEX_JSON.write('prepared', CASE WHEN r.column_map_json IS NOT NULL THEN 'Y' ELSE 'N' END);
    APEX_JSON.write('schedule', NVL(r.schedule,''));
    APEX_JSON.write('enabled', r.enabled);
    APEX_JSON.write('priority', r.priority);
    APEX_JSON.write('runOrder', r.run_order);
    APEX_JSON.write('runStatus', r.run_status);
    APEX_JSON.write('claimedBy', NVL(r.claimed_by,''));
    APEX_JSON.write('claimedAt', TO_CHAR(r.claimed_at,'YYYY-MM-DD HH24:MI'));
    APEX_JSON.open_array('history');
    FOR h IN (SELECT * FROM (
                SELECT run_id, status, row_count,
                       TO_CHAR(started,'YYYY-MM-DD HH24:MI')  AS started_s,
                       TO_CHAR(finished,'YYYY-MM-DD HH24:MI') AS finished_s,
                       CASE WHEN started IS NOT NULL AND finished IS NOT NULL
                            THEN ROUND((CAST(finished AS DATE) - CAST(started AS DATE)) * 86400)
                            ELSE NULL END AS dur_sec,
                       SUBSTR(csv_checksum,1,12) AS ck
                FROM atd_load_run_log WHERE job_name = [COLON]name
                ORDER BY run_id DESC) WHERE ROWNUM <= 20) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('runId', h.run_id);   APEX_JSON.write('status', h.status);
      APEX_JSON.write('rowCount', NVL(h.row_count,0));
      APEX_JSON.write('started', NVL(h.started_s,''));   APEX_JSON.write('finished', NVL(h.finished_s,''));
      APEX_JSON.write('durationSec', h.dur_sec);
      APEX_JSON.write('checksum', NVL(h.ck,''));
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.close_object;
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('jobs/[COLON]name', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE atd_otbi_jobs SET
    env_name        = CASE WHEN APEX_JSON.does_exist(p_path=>'envName')       THEN APEX_JSON.get_varchar2(p_path=>'envName')       ELSE env_name END,
    target_name     = CASE WHEN APEX_JSON.does_exist(p_path=>'targetName')    THEN APEX_JSON.get_varchar2(p_path=>'targetName')    ELSE target_name END,
    source_ref      = CASE WHEN APEX_JSON.does_exist(p_path=>'sourceRef')     THEN APEX_JSON.get_varchar2(p_path=>'sourceRef')     ELSE source_ref END,
    output_format   = CASE WHEN APEX_JSON.does_exist(p_path=>'outputFormat')  THEN APEX_JSON.get_varchar2(p_path=>'outputFormat')  ELSE output_format END,
    params_json     = CASE WHEN APEX_JSON.does_exist(p_path=>'paramsJson')    THEN TO_CLOB(APEX_JSON.get_varchar2(p_path=>'paramsJson'))    ELSE params_json END,
    stage_table     = CASE WHEN APEX_JSON.does_exist(p_path=>'stageTable')    THEN APEX_JSON.get_varchar2(p_path=>'stageTable')    ELSE stage_table END,
    final_table     = CASE WHEN APEX_JSON.does_exist(p_path=>'finalTable')    THEN APEX_JSON.get_varchar2(p_path=>'finalTable')    ELSE final_table END,
    load_mode       = CASE WHEN APEX_JSON.does_exist(p_path=>'loadMode')      THEN UPPER(APEX_JSON.get_varchar2(p_path=>'loadMode')) ELSE load_mode END,
    key_columns     = CASE WHEN APEX_JSON.does_exist(p_path=>'keyColumns')    THEN APEX_JSON.get_varchar2(p_path=>'keyColumns')    ELSE key_columns END,
    column_map_json = CASE WHEN APEX_JSON.does_exist(p_path=>'columnMapJson') THEN TO_CLOB(APEX_JSON.get_varchar2(p_path=>'columnMapJson')) ELSE column_map_json END,
    schedule        = CASE WHEN APEX_JSON.does_exist(p_path=>'schedule')      THEN APEX_JSON.get_varchar2(p_path=>'schedule')      ELSE schedule END,
    enabled         = CASE WHEN APEX_JSON.does_exist(p_path=>'enabled')       THEN UPPER(APEX_JSON.get_varchar2(p_path=>'enabled')) ELSE enabled END,
    priority        = CASE WHEN APEX_JSON.does_exist(p_path=>'priority')      THEN APEX_JSON.get_number(p_path=>'priority')        ELSE priority END,
    run_order       = CASE WHEN APEX_JSON.does_exist(p_path=>'runOrder')      THEN APEX_JSON.get_number(p_path=>'runOrder')        ELSE run_order END,
    updated_at      = SYSTIMESTAMP
  WHERE job_name = [COLON]name;
  l_n := SQL%ROWCOUNT;
  COMMIT;
  IF l_n = 0 THEN dct_rest.err(404,'Job not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE = -2291 THEN dct_rest.err(400,'Unknown env or target'); ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!');

    def_handler('jobs/[COLON]name', 'DELETE', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  DELETE FROM atd_otbi_jobs WHERE job_name = [COLON]name;
  l_n := SQL%ROWCOUNT;
  COMMIT;
  IF l_n = 0 THEN dct_rest.err(404,'Job not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('jobs/[COLON]name/enqueue');
    def_handler('jobs/[COLON]name/enqueue', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  l_n := atd_queue_pkg.enqueue([COLON]name);
  IF l_n = 0 THEN dct_rest.err(404,'Job not found or disabled'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.write('queued', l_n); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('jobs/[COLON]name/reset');
    def_handler('jobs/[COLON]name/reset', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  l_n := atd_queue_pkg.enqueue([COLON]name);   -- reset = mark READY, clear claim
  IF l_n = 0 THEN dct_rest.err(404,'Job not found or disabled'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- run now = top-priority enqueue (bump to front + mark READY). The runner is
    -- a scheduled batch worker, so "immediate" means it is the next job claimed.
    def_template('jobs/[COLON]name/run');
    def_handler('jobs/[COLON]name/run', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  UPDATE atd_otbi_jobs
     SET priority = 1, run_order = 0,
         run_status = 'READY', claimed_by = NULL, claimed_at = NULL,
         updated_at = SYSTIMESTAMP
   WHERE job_name = [COLON]name AND enabled = 'Y';
  l_n := SQL%ROWCOUNT; COMMIT;
  IF l_n = 0 THEN dct_rest.err(404,'Job not found or disabled'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- re-prepare = recover a job whose stored column map / table no longer fits the
    -- live analysis. Clears column_map_json so the next run re-profiles the CSV and
    -- re-derives the map. With {"rebuild":"Y"} it also DROPs the stage (and final)
    -- table so the next run recreates it fresh from the live data -- the way to accept
    -- an INCOMPATIBLE column change (a NUMBER/DATE column the analysis now sends as
    -- text), which cannot be ALTERed in place while the column holds data.
    def_template('jobs/[COLON]name/reprepare');
    def_handler('jobs/[COLON]name/reprepare', 'POST', q'!
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_rebuild VARCHAR2(5);
  l_stage   VARCHAR2(128);
  l_final   VARCHAR2(128);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_rebuild := NVL(UPPER(APEX_JSON.get_varchar2(p_path => 'rebuild')),'N');

  BEGIN
    SELECT stage_table, final_table INTO l_stage, l_final
      FROM atd_otbi_jobs WHERE job_name = [COLON]name;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Job not found'); RETURN; END;

  -- clear the column map -> next run re-profiles the live CSV and re-derives it
  UPDATE atd_otbi_jobs SET column_map_json = NULL, updated_at = SYSTIMESTAMP
   WHERE job_name = [COLON]name;

  -- rebuild: drop the managed tables so they are recreated from the live data
  -- (DDL auto-commits the UPDATE above). Best-effort: a missing table is fine.
  IF l_rebuild = 'Y' THEN
    IF l_stage IS NOT NULL THEN
      BEGIN EXECUTE IMMEDIATE 'DROP TABLE '||l_stage||' PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
    END IF;
    IF l_final IS NOT NULL THEN
      BEGIN EXECUTE IMMEDIATE 'DROP TABLE '||l_final||' PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
    END IF;
  END IF;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.write('rebuilt', l_rebuild);
  APEX_JSON.write('prepared', 'N');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- queue-wide ops
    def_template('enqueue');
    def_handler('enqueue', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  l_n := atd_queue_pkg.enqueue(NULL);
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.write('queued', l_n); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('reap');
    def_handler('reap', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_lease NUMBER; l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_lease := NVL(APEX_JSON.get_number(p_path=>'leaseMinutes'), 30);
  l_n := atd_queue_pkg.reap_stale(l_lease);
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.write('reaped', l_n); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- ENVIRONMENTS
    -- =========================================================================
    def_template('envs');
    def_handler('envs', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM atd_otbi_env ORDER BY env_name) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('envName', r.env_name);
    APEX_JSON.write('description', NVL(r.description,''));
    APEX_JSON.write('analyticsBaseUrl', NVL(r.analytics_base_url,''));
    APEX_JSON.write('xmlpserverBaseUrl', NVL(r.xmlpserver_base_url,''));
    APEX_JSON.write('authType', r.auth_type);
    APEX_JSON.write('credentialRef', NVL(r.credential_ref,''));
    APEX_JSON.write('extractTrack', r.extract_track);
    APEX_JSON.write('enabled', r.enabled);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('envs', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_name VARCHAR2(60);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_name := APEX_JSON.get_varchar2(p_path=>'envName');
  IF l_name IS NULL THEN dct_rest.err(400,'envName is required'); RETURN; END IF;
  INSERT INTO atd_otbi_env (env_name, description, analytics_base_url, xmlpserver_base_url,
                            auth_type, credential_ref, extract_track, enabled)
  VALUES (l_name,
    APEX_JSON.get_varchar2(p_path=>'description'),
    APEX_JSON.get_varchar2(p_path=>'analyticsBaseUrl'),
    APEX_JSON.get_varchar2(p_path=>'xmlpserverBaseUrl'),
    NVL(UPPER(APEX_JSON.get_varchar2(p_path=>'authType')),'SESSION'),
    APEX_JSON.get_varchar2(p_path=>'credentialRef'),
    NVL(UPPER(APEX_JSON.get_varchar2(p_path=>'extractTrack')),'BROWSER'),
    NVL(UPPER(APEX_JSON.get_varchar2(p_path=>'enabled')),'Y'));
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN DUP_VAL_ON_INDEX THEN ROLLBACK; dct_rest.err(400,'Env already exists');
  WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('envs/[COLON]name');
    def_handler('envs/[COLON]name', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE atd_otbi_env SET
    description        = CASE WHEN APEX_JSON.does_exist(p_path=>'description')       THEN APEX_JSON.get_varchar2(p_path=>'description')       ELSE description END,
    analytics_base_url = CASE WHEN APEX_JSON.does_exist(p_path=>'analyticsBaseUrl')  THEN APEX_JSON.get_varchar2(p_path=>'analyticsBaseUrl')  ELSE analytics_base_url END,
    xmlpserver_base_url= CASE WHEN APEX_JSON.does_exist(p_path=>'xmlpserverBaseUrl') THEN APEX_JSON.get_varchar2(p_path=>'xmlpserverBaseUrl') ELSE xmlpserver_base_url END,
    auth_type          = CASE WHEN APEX_JSON.does_exist(p_path=>'authType')          THEN UPPER(APEX_JSON.get_varchar2(p_path=>'authType'))   ELSE auth_type END,
    credential_ref     = CASE WHEN APEX_JSON.does_exist(p_path=>'credentialRef')     THEN APEX_JSON.get_varchar2(p_path=>'credentialRef')     ELSE credential_ref END,
    extract_track      = CASE WHEN APEX_JSON.does_exist(p_path=>'extractTrack')      THEN UPPER(APEX_JSON.get_varchar2(p_path=>'extractTrack')) ELSE extract_track END,
    enabled            = CASE WHEN APEX_JSON.does_exist(p_path=>'enabled')           THEN UPPER(APEX_JSON.get_varchar2(p_path=>'enabled'))    ELSE enabled END,
    updated_at         = SYSTIMESTAMP
  WHERE env_name = [COLON]name;
  l_n := SQL%ROWCOUNT; COMMIT;
  IF l_n = 0 THEN dct_rest.err(404,'Env not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('envs/[COLON]name', 'DELETE', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  DELETE FROM atd_otbi_env WHERE env_name = [COLON]name;
  l_n := SQL%ROWCOUNT; COMMIT;
  IF l_n = 0 THEN dct_rest.err(404,'Env not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE = -2292 THEN dct_rest.err(400,'Env is still used by a job'); ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!');

    -- =========================================================================
    -- TARGETS
    -- =========================================================================
    def_template('targets');
    def_handler('targets', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM atd_target_db ORDER BY target_name) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('targetName', r.target_name);
    APEX_JSON.write('description', NVL(r.description,''));
    APEX_JSON.write('dbKind', r.db_kind);
    APEX_JSON.write('dbLink', NVL(r.db_link,''));
    APEX_JSON.write('schemaName', NVL(r.schema_name,''));
    APEX_JSON.write('tnsAlias', NVL(r.tns_alias,''));
    APEX_JSON.write('enabled', r.enabled);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('targets', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_name VARCHAR2(60);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_name := APEX_JSON.get_varchar2(p_path=>'targetName');
  IF l_name IS NULL THEN dct_rest.err(400,'targetName is required'); RETURN; END IF;
  INSERT INTO atd_target_db (target_name, description, db_kind, db_link, schema_name, tns_alias, enabled)
  VALUES (l_name,
    APEX_JSON.get_varchar2(p_path=>'description'),
    NVL(UPPER(APEX_JSON.get_varchar2(p_path=>'dbKind')),'LOCAL_ATP'),
    APEX_JSON.get_varchar2(p_path=>'dbLink'),
    APEX_JSON.get_varchar2(p_path=>'schemaName'),
    APEX_JSON.get_varchar2(p_path=>'tnsAlias'),
    NVL(UPPER(APEX_JSON.get_varchar2(p_path=>'enabled')),'Y'));
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN DUP_VAL_ON_INDEX THEN ROLLBACK; dct_rest.err(400,'Target already exists');
  WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('targets/[COLON]name');
    def_handler('targets/[COLON]name', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE atd_target_db SET
    description = CASE WHEN APEX_JSON.does_exist(p_path=>'description') THEN APEX_JSON.get_varchar2(p_path=>'description') ELSE description END,
    db_kind     = CASE WHEN APEX_JSON.does_exist(p_path=>'dbKind')      THEN UPPER(APEX_JSON.get_varchar2(p_path=>'dbKind')) ELSE db_kind END,
    db_link     = CASE WHEN APEX_JSON.does_exist(p_path=>'dbLink')      THEN APEX_JSON.get_varchar2(p_path=>'dbLink')      ELSE db_link END,
    schema_name = CASE WHEN APEX_JSON.does_exist(p_path=>'schemaName')  THEN APEX_JSON.get_varchar2(p_path=>'schemaName')  ELSE schema_name END,
    tns_alias   = CASE WHEN APEX_JSON.does_exist(p_path=>'tnsAlias')    THEN APEX_JSON.get_varchar2(p_path=>'tnsAlias')    ELSE tns_alias END,
    enabled     = CASE WHEN APEX_JSON.does_exist(p_path=>'enabled')     THEN UPPER(APEX_JSON.get_varchar2(p_path=>'enabled')) ELSE enabled END,
    updated_at  = SYSTIMESTAMP
  WHERE target_name = [COLON]name;
  l_n := SQL%ROWCOUNT; COMMIT;
  IF l_n = 0 THEN dct_rest.err(404,'Target not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('targets/[COLON]name', 'DELETE', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  DELETE FROM atd_target_db WHERE target_name = [COLON]name;
  l_n := SQL%ROWCOUNT; COMMIT;
  IF l_n = 0 THEN dct_rest.err(404,'Target not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE = -2292 THEN dct_rest.err(400,'Target is still used by a job'); ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!');

    -- =========================================================================
    -- RUN LOGS
    -- =========================================================================
    def_template('runs');
    def_handler('runs', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_job    VARCHAR2(80)  := [COLON]job;
  l_status VARCHAR2(20)  := UPPER([COLON]status);
  l_from   VARCHAR2(30)  := [COLON]fromdt;
  l_to     VARCHAR2(30)  := [COLON]todt;
  l_limit  NUMBER        := LEAST(NVL(TO_NUMBER([COLON]limit  DEFAULT NULL ON CONVERSION ERROR), 50), 200);
  l_offset NUMBER        := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  SELECT COUNT(*) INTO l_total FROM atd_load_run_log l
   WHERE NVL(l.track,'X') <> 'DISCOVER'             -- discovery runs live on the Discovery page
     AND (l_job IS NULL OR l.job_name = l_job)
     AND (l_status IS NULL
          OR (l_status = 'WARNING' AND l.status = 'SUCCESS' AND l.message IS NOT NULL)
          OR (l_status != 'WARNING' AND l.status = l_status))
     AND (l_from IS NULL OR l.started >= TO_TIMESTAMP(l_from,'YYYY-MM-DD'))
     AND (l_to   IS NULL OR l.started <  TO_TIMESTAMP(l_to,'YYYY-MM-DD') + 1);
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total', l_total); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT run_id, job_name, track, status, row_count, NVL(host_id,'') AS host_id,
           NVL(DBMS_LOB.SUBSTR(message,400,1),'') AS msg,
           CASE WHEN status='SUCCESS' AND message IS NOT NULL THEN 'Y' ELSE 'N' END AS warn,
           TO_CHAR(started,'YYYY-MM-DD HH24:MI')  AS started_s,
           TO_CHAR(finished,'YYYY-MM-DD HH24:MI') AS finished_s,
           CASE WHEN started IS NOT NULL AND finished IS NOT NULL
                THEN ROUND((CAST(finished AS DATE) - CAST(started AS DATE)) * 86400)
                ELSE NULL END AS dur_sec
    FROM atd_load_run_log l
    WHERE NVL(l.track,'X') <> 'DISCOVER'
      AND (l_job IS NULL OR l.job_name = l_job)
      AND (l_status IS NULL
           OR (l_status = 'WARNING' AND l.status = 'SUCCESS' AND l.message IS NOT NULL)
           OR (l_status != 'WARNING' AND l.status = l_status))
      AND (l_from IS NULL OR l.started >= TO_TIMESTAMP(l_from,'YYYY-MM-DD'))
      AND (l_to   IS NULL OR l.started <  TO_TIMESTAMP(l_to,'YYYY-MM-DD') + 1)
    ORDER BY run_id DESC
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('runId', r.run_id);     APEX_JSON.write('jobName', r.job_name);
    APEX_JSON.write('host', r.host_id);
    APEX_JSON.write('track', NVL(r.track,'')); APEX_JSON.write('status', r.status);
    APEX_JSON.write('rowCount', NVL(r.row_count,0));
    APEX_JSON.write('warn', r.warn);
    APEX_JSON.write('message', r.msg);
    APEX_JSON.write('started', NVL(r.started_s,'')); APEX_JSON.write('finished', NVL(r.finished_s,''));
    APEX_JSON.write('durationSec', r.dur_sec);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('runs/[COLON]id');
    def_handler('runs/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_found NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  SELECT COUNT(*) INTO l_found FROM atd_load_run_log WHERE run_id = TO_NUMBER([COLON]id DEFAULT NULL ON CONVERSION ERROR);
  IF l_found = 0 THEN dct_rest.err(404,'Run not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  FOR r IN (SELECT * FROM atd_load_run_log WHERE run_id = TO_NUMBER([COLON]id DEFAULT NULL ON CONVERSION ERROR)) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('runId', r.run_id);     APEX_JSON.write('jobName', r.job_name);
    APEX_JSON.write('track', NVL(r.track,'')); APEX_JSON.write('status', r.status);
    APEX_JSON.write('rowCount', NVL(r.row_count,0));
    APEX_JSON.write('csvChecksum', NVL(r.csv_checksum,''));
    APEX_JSON.write('started',  TO_CHAR(r.started,'YYYY-MM-DD HH24:MI'));
    APEX_JSON.write('finished', TO_CHAR(r.finished,'YYYY-MM-DD HH24:MI'));
    APEX_JSON.write('durationSec',
      CASE WHEN r.started IS NOT NULL AND r.finished IS NOT NULL
           THEN ROUND((CAST(r.finished AS DATE) - CAST(r.started AS DATE)) * 86400)
           ELSE NULL END);
    APEX_JSON.write('message', NVL(DBMS_LOB.SUBSTR(r.message,32000,1),''));
    APEX_JSON.close_object;
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('runs/export');
    def_handler('runs/export', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_job    VARCHAR2(80)  := [COLON]job;
  l_status VARCHAR2(20)  := UPPER([COLON]status);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  OWA_UTIL.mime_header('text/csv', FALSE, 'UTF-8');
  HTP.p('Content-Disposition: attachment; filename="atd-runs-'||TO_CHAR(SYSDATE,'YYYYMMDD-HH24MI')||'.csv"');
  OWA_UTIL.http_header_close;
  HTP.prn(UNISTR('\FEFF'));
  HTP.print('runId,jobName,track,status,rowCount,started,finished');
  FOR r IN (
    SELECT run_id, job_name, track, status, row_count,
           TO_CHAR(started,'YYYY-MM-DD HH24:MI')  AS started_s,
           TO_CHAR(finished,'YYYY-MM-DD HH24:MI') AS finished_s
    FROM atd_load_run_log l
    WHERE (l_job IS NULL OR l.job_name = l_job)
      AND (l_status IS NULL
           OR (l_status = 'WARNING' AND l.status = 'SUCCESS' AND l.message IS NOT NULL)
           OR (l_status != 'WARNING' AND l.status = l_status))
    ORDER BY run_id DESC FETCH FIRST 20000 ROWS ONLY
  ) LOOP
    HTP.print(r.run_id||','||r.job_name||','||NVL(r.track,'')||','||r.status||','||
              NVL(r.row_count,0)||','||NVL(r.started_s,'')||','||NVL(r.finished_s,''));
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- WORKERS : live per-VM health (ATD_WORKER_HEARTBEAT) for the dashboard panel
    -- =========================================================================
    def_template('workers');
    def_handler('workers', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (
    SELECT h.worker_id, h.status, h.current_job,
           TO_CHAR(h.last_seen,'YYYY-MM-DD HH24:MI:SS') AS last_seen_s,
           ROUND((CAST(SYSTIMESTAMP AS DATE) - CAST(h.last_seen AS DATE)) * 86400) AS age_sec,
           (SELECT COUNT(*) FROM atd_load_run_log l
             WHERE l.host_id = h.worker_id
               AND l.started > SYSTIMESTAMP - INTERVAL '1' DAY) AS runs24h
    FROM atd_worker_heartbeat h ORDER BY h.worker_id
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('workerId',   r.worker_id);
    APEX_JSON.write('status',     NVL(r.status,''));
    APEX_JSON.write('currentJob', NVL(r.current_job,''));
    APEX_JSON.write('lastSeen',   NVL(r.last_seen_s,''));
    APEX_JSON.write('ageSec',     r.age_sec);
    APEX_JSON.write('online',     CASE WHEN r.age_sec <= 120 THEN 'Y' ELSE 'N' END);
    APEX_JSON.write('runs24h',    r.runs24h);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- RUNNER CONFIG (UI-managed non-secret operational settings)
    -- =========================================================================
    def_template('config');
    def_handler('config', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM atd_runner_config ORDER BY display_order, config_key) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('key', r.config_key);
    -- never return a secret value in clear; expose only whether it is set
    APEX_JSON.write('value', CASE WHEN r.is_secret='Y' THEN '' ELSE NVL(r.config_value,'') END);
    APEX_JSON.write('isSecret', r.is_secret);
    APEX_JSON.write('secretSet', CASE WHEN r.is_secret='Y' AND r.config_value IS NOT NULL THEN 'Y' ELSE 'N' END);
    APEX_JSON.write('valueType', r.value_type);
    APEX_JSON.write('enumValues', NVL(r.enum_values,''));
    APEX_JSON.write('description', NVL(r.description,''));
    APEX_JSON.write('updatedBy', NVL(r.updated_by,''));
    APEX_JSON.write('updatedAt', TO_CHAR(r.updated_at,'YYYY-MM-DD HH24:MI'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('config', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_cnt  NUMBER; l_key VARCHAR2(60); l_val VARCHAR2(2000); l_n NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_cnt := NVL(APEX_JSON.get_count(p_path => 'items'), 0);
  FOR i IN 1 .. l_cnt LOOP
    l_key := APEX_JSON.get_varchar2(p_path => 'items['||i||'].key');
    l_val := APEX_JSON.get_varchar2(p_path => 'items['||i||'].value');
    -- only UPDATE known keys (never create arbitrary rows from the client)
    UPDATE atd_runner_config
       SET config_value = l_val, updated_by = l_user, updated_at = SYSTIMESTAMP
     WHERE config_key = l_key;
    l_n := l_n + SQL%ROWCOUNT;
  END LOOP;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.write('updated', l_n); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END setup_atd_ords_tmp;
/

BEGIN
    setup_atd_ords_tmp;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP PROCEDURE setup_atd_ords_tmp';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

PROMPT ============================================================
PROMPT  13_atd_ords.sql complete.
PROMPT  Base URL: /ords/admin/atd/
PROMPT  Endpoints: dashboard, lookups, jobs (+/:name, /enqueue, /reset, /run, /reprepare),
PROMPT             analyses (build new), subject-areas (+/columns, /discover, /runs),
PROMPT             enqueue, reap, envs, targets, runs (+/:id, /export)
PROMPT ============================================================
