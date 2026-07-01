-- ===========================================================================
-- otbi-atd : 42 Run Logs -- Job Set column + filter (additive on atd.rest)
--   Redefines GET /runs + GET /runs/export to surface the Job Set each run's
--   job belongs to (LEFT JOIN atd_job_set_member -> atd_job_set) and to accept
--   a ?setcode= filter. Additive only (DEFINE_TEMPLATE / DEFINE_HANDLER upsert
--   the two handlers) -> NO DELETE_MODULE, so the rest of atd.rest (job-sets,
--   actions, categories ...) is untouched.
--
--   A job belongs to at most one set (atd_job_set_member PK = job_name), so the
--   LEFT JOIN never fans out run rows. Display times stay dct_to_local (UTC ->
--   Asia/Dubai). Every handler: validate_session + SYS_ADMIN gate.
--
--   Run in a FRESH SQLcl session (must NOT follow ALTER SESSION SET CURRENT_
--   SCHEMA=PROD, or ORA-01471). [COLON] -> ':' at define. Depends on db/40 + 41
--   objects (+ their ADMIN synonyms). Idempotent; safe to re-run.
--
--   NOTE: this REDEFINES two handlers first created by 13_atd_ords.sql. Re-running
--   13 (which DELETE_MODULEs) reverts them to the plain versions, so ALWAYS run 42
--   again after 13 (same rule as 20_atd_action_ords.sql for the Actions handlers).
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED
SET ECHO ON

-- Synonyms the handlers touch (idempotent; also created by db/40/41 and db/13)
CREATE OR REPLACE SYNONYM atd_load_run_log   FOR prod.atd_load_run_log;
CREATE OR REPLACE SYNONYM atd_job_set        FOR prod.atd_job_set;
CREATE OR REPLACE SYNONYM atd_job_set_member FOR prod.atd_job_set_member;

CREATE OR REPLACE PROCEDURE setup_atd_runs_set_ords_tmp AS
    c_mod CONSTANT VARCHAR2(30) := 'atd.rest';

    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;
    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method => p_method, p_source_type => ORDS.source_type_plsql,
            p_source => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN
    -- =========================================================================
    -- GET /runs  -- run log + Job Set column + ?setcode= filter
    -- =========================================================================
    def_template('runs');
    def_handler('runs', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_job    VARCHAR2(80)  := [COLON]job;
  l_status VARCHAR2(20)  := UPPER([COLON]status);
  l_from   VARCHAR2(30)  := [COLON]fromdt;
  l_to     VARCHAR2(30)  := [COLON]todt;
  l_set    VARCHAR2(30)  := [COLON]setcode;
  l_limit  NUMBER        := LEAST(NVL(TO_NUMBER([COLON]limit  DEFAULT NULL ON CONVERSION ERROR), 50), 200);
  l_offset NUMBER        := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  SELECT COUNT(*) INTO l_total
    FROM atd_load_run_log l
    LEFT JOIN atd_job_set_member m ON m.job_name = l.job_name
   WHERE NVL(l.track,'X') <> 'DISCOVER'             -- discovery runs live on the Discovery page
     AND (l_job IS NULL OR l.job_name = l_job)
     AND (l_set IS NULL OR m.set_code = l_set)
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
    SELECT l.run_id, l.job_name, l.track, l.status, l.row_count, NVL(l.host_id,'') AS host_id,
           NVL(DBMS_LOB.SUBSTR(l.message,400,1),'') AS msg,
           CASE WHEN l.status='SUCCESS' AND l.message IS NOT NULL THEN 'Y' ELSE 'N' END AS warn,
           m.set_code AS set_code, s.name_en AS set_name,
           TO_CHAR( dct_to_local(l.started),'YYYY-MM-DD HH:MI AM')  AS started_s,
           TO_CHAR( dct_to_local(l.finished),'YYYY-MM-DD HH:MI AM') AS finished_s,
           CASE WHEN l.started IS NOT NULL AND l.finished IS NOT NULL
                THEN ROUND((CAST(l.finished AS DATE) - CAST(l.started AS DATE)) * 86400)
                ELSE NULL END AS dur_sec
    FROM atd_load_run_log l
    LEFT JOIN atd_job_set_member m ON m.job_name = l.job_name
    LEFT JOIN atd_job_set        s ON s.set_code = m.set_code
    WHERE NVL(l.track,'X') <> 'DISCOVER'
      AND (l_job IS NULL OR l.job_name = l_job)
      AND (l_set IS NULL OR m.set_code = l_set)
      AND (l_status IS NULL
           OR (l_status = 'WARNING' AND l.status = 'SUCCESS' AND l.message IS NOT NULL)
           OR (l_status != 'WARNING' AND l.status = l_status))
      AND (l_from IS NULL OR l.started >= TO_TIMESTAMP(l_from,'YYYY-MM-DD'))
      AND (l_to   IS NULL OR l.started <  TO_TIMESTAMP(l_to,'YYYY-MM-DD') + 1)
    ORDER BY l.run_id DESC
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('runId', r.run_id);     APEX_JSON.write('jobName', r.job_name);
    APEX_JSON.write('host', r.host_id);
    APEX_JSON.write('track', NVL(r.track,'')); APEX_JSON.write('status', r.status);
    APEX_JSON.write('rowCount', NVL(r.row_count,0));
    APEX_JSON.write('warn', r.warn);
    APEX_JSON.write('setCode', NVL(r.set_code,''));
    APEX_JSON.write('setName', NVL(r.set_name,''));
    APEX_JSON.write('message', r.msg);
    APEX_JSON.write('started', NVL(r.started_s,'')); APEX_JSON.write('finished', NVL(r.finished_s,''));
    APEX_JSON.write('durationSec', r.dur_sec);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- GET /runs/export  -- CSV incl. jobSet column + ?setcode= filter
    -- =========================================================================
    def_template('runs/export');
    def_handler('runs/export', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_job    VARCHAR2(80)  := [COLON]job;
  l_status VARCHAR2(20)  := UPPER([COLON]status);
  l_set    VARCHAR2(30)  := [COLON]setcode;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  OWA_UTIL.mime_header('text/csv', FALSE, 'UTF-8');
  HTP.p('Content-Disposition: attachment; filename="atd-runs-'||TO_CHAR(SYSDATE,'YYYYMMDD-HH24MI')||'.csv"');
  OWA_UTIL.http_header_close;
  HTP.prn(UNISTR('\FEFF'));
  HTP.print('runId,jobName,jobSet,track,status,rowCount,started,finished');
  FOR r IN (
    SELECT l.run_id, l.job_name, m.set_code AS set_code, l.track, l.status, l.row_count,
           TO_CHAR( dct_to_local(l.started),'YYYY-MM-DD HH:MI AM')  AS started_s,
           TO_CHAR( dct_to_local(l.finished),'YYYY-MM-DD HH:MI AM') AS finished_s
    FROM atd_load_run_log l
    LEFT JOIN atd_job_set_member m ON m.job_name = l.job_name
    WHERE (l_job IS NULL OR l.job_name = l_job)
      AND (l_set IS NULL OR m.set_code = l_set)
      AND (l_status IS NULL
           OR (l_status = 'WARNING' AND l.status = 'SUCCESS' AND l.message IS NOT NULL)
           OR (l_status != 'WARNING' AND l.status = l_status))
    ORDER BY l.run_id DESC FETCH FIRST 20000 ROWS ONLY
  ) LOOP
    HTP.print(r.run_id||','||r.job_name||','||NVL(r.set_code,'')||','||NVL(r.track,'')||','||r.status||','||
              NVL(r.row_count,0)||','||NVL(r.started_s,'')||','||NVL(r.finished_s,''));
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

END;
/
SHOW ERRORS PROCEDURE setup_atd_runs_set_ords_tmp

BEGIN
    setup_atd_runs_set_ords_tmp;
    COMMIT;
END;
/

DROP PROCEDURE setup_atd_runs_set_ords_tmp;

-- Verify the two handlers are registered on atd.rest
SELECT t.uri_template, h.method
  FROM user_ords_templates t
  JOIN user_ords_handlers  h ON h.template_id = t.id
 WHERE t.uri_template IN ('runs','runs/export')
 ORDER BY t.uri_template, h.method;

PROMPT ATD Run Logs Job-Set column + filter deployed (GET /runs + /runs/export).
