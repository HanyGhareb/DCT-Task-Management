-- =============================================================================
-- General Ledger (App 210) -- Projects Data refresh bridge (ADDITIVE)
-- File    : 19_gl_projects_data_ords.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp @19_gl_projects_data_ords.sql  (fresh session)
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            re-run 07..18 + THIS script right after it.
-- Purpose : lets the Project Budget Utilization page trigger a FULL source-data
--           re-extract from Fusion and poll it to completion, without visiting
--           the ATD app. Scope (user request 2026-08-22) = the ATD job set
--           PROJECTS_DATA (otbi-atd/db/67: Projects Full + Tasks Full +
--           Projects Budget Full - V2) PLUS the 12 transaction FULL jobs the
--           butil figures read: AP Invoices/Lines/Distributions Full,
--           PO Headers/Lines/Schedules/Distributions Full,
--           PR Headers Full / PR Lines All / PR Distributions Full,
--           GRN Temporary Job + GRN Gap. The extra jobs are queued exactly the
--           way atd_set_pkg.run_now queues set members (run_status='READY';
--           the worker fleet drains them on its idle cycle) -- EXCEPT that a
--           CLAIMED (in-flight) job is left alone instead of being re-queued.
--           ~316s of extracts serial, ~2-4 min wall on the 3-VM fleet.
--           NOTE: the GRN gap injections re-derive within 15 min of the GRN
--           extracts landing (ATD_GRN_GAP_MERGE_JOB, otbi-atd/db/84).
-- Endpoints:
--   POST /gl/butil/refreshdata        -> { queued: n }   (run_now + READY update)
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
  -- the 12 transaction FULL jobs behind the butil figures (user request
  -- 2026-08-22): queued like run_now does, but an in-flight CLAIMED job is
  -- left alone (re-queueing it would double-run the extract)
  UPDATE prod.atd_otbi_jobs
     SET run_status = 'READY', claimed_by = NULL, claimed_at = NULL,
         updated_at = SYSTIMESTAMP
   WHERE enabled = 'Y'
     AND NVL(run_status,'IDLE') <> 'CLAIMED'
     AND job_name IN ('AP Invoices Full','AP Invoice Lines Full','AP Distributions Full',
                      'PO Headers Full','PO Lines Full','PO Schedules Full','PO Distributions Full',
                      'PR Headers Full','PR Lines All','PR Distributions Full',
                      'GRN Temporary Job','GRN Gap');
  l_n := l_n + SQL%ROWCOUNT;
  COMMIT;
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
                  WHERE job_name IN ('Projects Full','Tasks Full','Projects Budget Full - V2',
                                     'AP Invoices Full','AP Invoice Lines Full','AP Distributions Full',
                                     'PO Headers Full','PO Lines Full','PO Schedules Full','PO Distributions Full',
                                     'PR Headers Full','PR Lines All','PR Distributions Full',
                                     'GRN Temporary Job','GRN Gap')
                    AND NVL(track,'BROWSER') <> 'DISCOVER') l
        ON l.job_name = j.job_name AND l.rn = 1
     WHERE j.job_name IN ('Projects Full','Tasks Full','Projects Budget Full - V2',
                          'AP Invoices Full','AP Invoice Lines Full','AP Distributions Full',
                          'PO Headers Full','PO Lines Full','PO Schedules Full','PO Distributions Full',
                          'PR Headers Full','PR Lines All','PR Distributions Full',
                          'GRN Temporary Job','GRN Gap')
     ORDER BY CASE j.job_name
                WHEN 'Projects Full'             THEN 1
                WHEN 'Tasks Full'                THEN 2
                WHEN 'Projects Budget Full - V2' THEN 3
                WHEN 'AP Invoices Full'          THEN 4
                WHEN 'AP Invoice Lines Full'     THEN 5
                WHEN 'AP Distributions Full'     THEN 6
                WHEN 'PO Headers Full'           THEN 7
                WHEN 'PO Lines Full'             THEN 8
                WHEN 'PO Schedules Full'         THEN 9
                WHEN 'PO Distributions Full'     THEN 10
                WHEN 'PR Headers Full'           THEN 11
                WHEN 'PR Lines All'              THEN 12
                WHEN 'PR Distributions Full'     THEN 13
                WHEN 'GRN Temporary Job'         THEN 14
                ELSE 15 END)
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
