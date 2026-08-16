-- =============================================================================
-- General Ledger (App 210) -- Projects Data refresh bridge (ADDITIVE)
-- File    : 19_gl_projects_data_ords.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp @19_gl_projects_data_ords.sql  (fresh session)
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            re-run 07..18 + THIS script right after it.
-- Purpose : lets the Project Budget Utilization page trigger the ATD job set
--           PROJECTS_DATA (otbi-atd/db/67: Projects Full + Tasks Full +
--           Projects Budget Full - V2) and poll it to completion, so the page
--           source data (project/task masters + budget) refreshes on demand
--           (~20s-2min) without visiting the ATD app.
-- Endpoints:
--   POST /gl/butil/refreshdata        -> { queued: n }   (atd_set_pkg.run_now)
--   GET  /gl/butil/refreshdata        -> { busy: Y/N, jobs:[{job, queueStatus,
--                                          lastStatus, lastRows, lastFinished}] }
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_pdata_ords_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'gl.rest';

    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
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

    def_template('butil/refreshdata');

    def_handler('butil/refreshdata', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n    NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  l_n := prod.atd_set_pkg.run_now('PROJECTS_DATA');
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('queued', l_n);
  APEX_JSON.close_object;
EXCEPTION
  WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('butil/refreshdata', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_busy VARCHAR2(1) := 'N';
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('jobs');
  FOR r IN (
    SELECT j.job_name, j.run_status,
           l.status last_status, l.row_count,
           TO_CHAR(prod.dct_to_local(l.finished), 'YYYY-MM-DD HH[COLON]MI AM') fin_local
      FROM prod.atd_otbi_jobs j
      LEFT JOIN (SELECT job_name, status, row_count, finished,
                        ROW_NUMBER() OVER (PARTITION BY job_name ORDER BY run_id DESC) rn
                   FROM prod.atd_load_run_log
                  WHERE job_name IN ('Projects Full','Tasks Full','Projects Budget Full - V2')
                    AND NVL(track,'BROWSER') <> 'DISCOVER') l
        ON l.job_name = j.job_name AND l.rn = 1
     WHERE j.job_name IN ('Projects Full','Tasks Full','Projects Budget Full - V2')
     ORDER BY CASE j.job_name WHEN 'Projects Full' THEN 1
                              WHEN 'Tasks Full' THEN 2 ELSE 3 END)
  LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('job', r.job_name);
    APEX_JSON.write('queueStatus', r.run_status);
    APEX_JSON.write('lastStatus', r.last_status);
    APEX_JSON.write('lastRows', r.row_count);
    APEX_JSON.write('lastFinished', r.fin_local);
    APEX_JSON.close_object;
    IF r.run_status IN ('READY','CLAIMED') THEN l_busy := 'Y'; END IF;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('busy', l_busy);
  APEX_JSON.close_object;
EXCEPTION
  WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

END setup_gl_pdata_ords_tmp;
/

BEGIN
  setup_gl_pdata_ords_tmp;
  COMMIT;
END;
/

DROP PROCEDURE setup_gl_pdata_ords_tmp;

PROMPT Projects Data refresh bridge defined on gl.rest (butil/refreshdata GET+POST)
