-- ===========================================================================
-- otbi-atd : 31 dashboard observability  (additive ORDS GET /atd/jobs/health)
--   One read for the dashboard's "is the fleet healthy?" panel:
--     * break    -> the Break window config + whether it is active right now
--     * workers  -> per-VM Fusion session age (session_started, db/27) so an
--                   aging session is visible before it expires
--     * jobs     -> per ENABLED job: last SUCCESS + minutes-since, consecutive
--                   fails since that success, any stuck RUNNING, alert flag
-- Additive only (DEFINE_TEMPLATE/DEFINE_HANDLER on the live atd.rest) -> no
-- DELETE_MODULE, so actions (db/20) + refresh (db/26) stay registered. Run in a
-- FRESH session (synonym rule: must NOT follow ALTER SESSION SET CURRENT_SCHEMA=PROD).
-- Rerunnable. Schema-qualified PROD. CRLF / UTF-8 no BOM. [COLON] -> ':' at define.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED
SET ECHO ON

-- ADMIN synonyms for objects the handler touches (idempotent)
CREATE OR REPLACE SYNONYM atd_otbi_jobs        FOR prod.atd_otbi_jobs;
CREATE OR REPLACE SYNONYM atd_load_run_log     FOR prod.atd_load_run_log;
CREATE OR REPLACE SYNONYM atd_worker_heartbeat FOR prod.atd_worker_heartbeat;
CREATE OR REPLACE SYNONYM atd_runner_config    FOR prod.atd_runner_config;
CREATE OR REPLACE SYNONYM atd_in_break         FOR prod.atd_in_break;

CREATE OR REPLACE PROCEDURE setup_atd_jobhealth_ords_tmp AS
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

    -- =========================================================================
    -- GET /jobs/health  -- break window + worker session age + per-job freshness
    -- =========================================================================
    def_template('jobs/health');
    def_handler('jobs/health', 'GET', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_cf    NUMBER;
  l_stuck NUMBER;
  l_enb   VARCHAR2(20);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;

  -- ---- Break window ----
  BEGIN
    SELECT config_value INTO l_enb FROM atd_runner_config WHERE config_key='ATD_BREAK_ENABLED';
  EXCEPTION WHEN NO_DATA_FOUND THEN l_enb := 'N';
  END;
  APEX_JSON.open_object('break');
  APEX_JSON.write('enabled', UPPER(NVL(l_enb,'N')));
  APEX_JSON.write('active',  atd_in_break);
  FOR b IN (SELECT
              MAX(CASE WHEN config_key='ATD_BREAK_START' THEN config_value END) AS st,
              MAX(CASE WHEN config_key='ATD_BREAK_END'   THEN config_value END) AS en
            FROM atd_runner_config
            WHERE config_key IN ('ATD_BREAK_START','ATD_BREAK_END')) LOOP
    APEX_JSON.write('start', NVL(b.st,'20:00'));
    APEX_JSON.write('end',   NVL(b.en,'06:00'));
  END LOOP;
  APEX_JSON.close_object;

  -- ---- Worker session age ----
  APEX_JSON.open_array('workers');
  FOR w IN (
    SELECT worker_id,
           TO_CHAR( dct_to_local(session_started),'YYYY-MM-DD HH:MI AM') AS ss,
           CASE WHEN session_started IS NULL THEN NULL
                ELSE ROUND((CAST(SYSTIMESTAMP AS DATE) - CAST(session_started AS DATE)) * 1440) END AS age_min
    FROM atd_worker_heartbeat ORDER BY worker_id
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('workerId', w.worker_id);
    APEX_JSON.write('sessionStarted', NVL(w.ss,''));
    IF w.age_min IS NULL THEN APEX_JSON.write('sessionAgeMin', '');
    ELSE APEX_JSON.write('sessionAgeMin', w.age_min); END IF;
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  -- ---- Per-job freshness (enabled jobs) ----
  APEX_JSON.open_array('jobs');
  FOR j IN (
    WITH ok AS (
      SELECT job_name,
             MAX(run_id)                                   AS last_ok_run,
             MAX(finished) KEEP (DENSE_RANK LAST ORDER BY run_id) AS last_ok_fin
      FROM atd_load_run_log WHERE status='SUCCESS' GROUP BY job_name
    )
    SELECT g.job_name, NVL(g.fail_alert_sent,'N') AS fail_alert_sent,
           g.frequency_minutes,
           ok.last_ok_run,
           TO_CHAR( dct_to_local(ok.last_ok_fin),'YYYY-MM-DD HH:MI AM') AS last_ok_s,
           CASE WHEN ok.last_ok_fin IS NULL THEN NULL
                ELSE ROUND((CAST(SYSTIMESTAMP AS DATE) - CAST(ok.last_ok_fin AS DATE)) * 1440) END AS since_min
      FROM atd_otbi_jobs g
      LEFT JOIN ok ON ok.job_name = g.job_name
     WHERE g.enabled = 'Y'
     ORDER BY g.job_name
  ) LOOP
    SELECT COUNT(*) INTO l_cf FROM atd_load_run_log
      WHERE job_name = j.job_name AND status='FAILED'
        AND run_id > NVL(j.last_ok_run, 0);
    SELECT COUNT(*) INTO l_stuck FROM atd_load_run_log
      WHERE job_name = j.job_name AND status='RUNNING';
    APEX_JSON.open_object;
    APEX_JSON.write('jobName', j.job_name);
    APEX_JSON.write('lastSuccess', NVL(j.last_ok_s,''));
    IF j.since_min IS NULL THEN APEX_JSON.write('sinceMin', '');
    ELSE APEX_JSON.write('sinceMin', j.since_min); END IF;
    APEX_JSON.write('consecutiveFails', l_cf);
    APEX_JSON.write('stuckRunning', CASE WHEN l_stuck > 0 THEN 'Y' ELSE 'N' END);
    APEX_JSON.write('alertSent', j.fail_alert_sent);
    IF j.frequency_minutes IS NULL THEN APEX_JSON.write('frequencyMin', '');
    ELSE APEX_JSON.write('frequencyMin', j.frequency_minutes); END IF;
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

END setup_atd_jobhealth_ords_tmp;
/

BEGIN
  setup_atd_jobhealth_ords_tmp;
  COMMIT;
END;
/
DROP PROCEDURE setup_atd_jobhealth_ords_tmp;

SET ECHO OFF
PROMPT otbi-atd 31 job health : done
