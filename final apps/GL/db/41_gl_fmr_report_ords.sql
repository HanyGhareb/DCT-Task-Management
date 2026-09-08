-- =============================================================================
-- General Ledger (App 210) -- FMR page "Generate Report" bridge
-- File    : 41_gl_fmr_report_ords.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp @41_gl_fmr_report_ords.sql  (fresh session, ADMIN)
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            the GL post-05 re-run list is now 07..41.
-- Purpose : runs the Reporting-Platform definition GL_FMR_REPORT
--           (reporting/db/40) from the GL app's Financial Performance Report
--           page -- ONE definition, the format picked per run (the butil
--           pattern, GL/db/11, but a single route set: the definition renders
--           whichever single format the POST asks for).
--   POST /gl/fmr/report          body {period MM-YYYY req, format PDF|XLSX|PPTX
--                                (default PDF), entity optional} -> {runId}
--   GET  /gl/fmr/report/:id      -> {runId, status, rowCount, error, format, hasFile}
--   GET  /gl/fmr/report/:id/file -> authed download of the finished run's file
-- Gate    : GL_RUN_BRIEFING_BOOK (same as every other GL report bridge).
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_fmr_rpt_tmp AS
    c_mod CONSTANT VARCHAR2(30) := 'gl.rest';
    PROCEDURE dt(p VARCHAR2) IS BEGIN ORDS.DEFINE_TEMPLATE(p_module_name=>c_mod, p_pattern=>REPLACE(p,'[COLON]',CHR(58))); END;
    PROCEDURE dh(p VARCHAR2, m VARCHAR2, s CLOB) IS BEGIN ORDS.DEFINE_HANDLER(p_module_name=>c_mod, p_pattern=>REPLACE(p,'[COLON]',CHR(58)), p_method=>m,
        p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(s,'[COLON]',CHR(58))); END;
BEGIN

  dt('fmr/report');
  dh('fmr/report','POST',q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_period VARCHAR2(10);
  l_format VARCHAR2(10);
  l_entity VARCHAR2(200);
  l_params CLOB;
  l_run    NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_RUN_BRIEFING_BOOK', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_RUN_BRIEFING_BOOK required'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_period := APEX_JSON.get_varchar2(p_path=>'period');
  IF l_period IS NULL OR NOT REGEXP_LIKE(l_period, '^(0[1-9]|1[0-2])-[0-9]{4}$') THEN
    dct_rest.err(400,'period is required as MM-YYYY'); RETURN;
  END IF;
  l_format := UPPER(NVL(APEX_JSON.get_varchar2(p_path=>'format'),'PDF'));
  IF l_format NOT IN ('PDF','XLSX','PPTX') THEN
    dct_rest.err(400,'format must be PDF, XLSX or PPTX'); RETURN;
  END IF;
  l_entity := APEX_JSON.get_varchar2(p_path=>'entity');
  APEX_JSON.initialize_clob_output;
  APEX_JSON.open_object;
  APEX_JSON.write('period', l_period);
  IF l_entity IS NOT NULL THEN APEX_JSON.write('entity', l_entity); END IF;
  APEX_JSON.close_object;
  l_params := APEX_JSON.get_clob_output;
  APEX_JSON.free_output;
  l_run := dct_rpt_pkg.enqueue(p_report_code  => 'GL_FMR_REPORT',
                               p_params       => l_params,
                               p_trigger      => 'ONDEMAND',
                               p_requested_by => l_user,
                               p_formats      => l_format);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('runId', l_run);
  APEX_JSON.write('format', l_format);
  APEX_JSON.close_object;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    IF SQLCODE = -20404 THEN dct_rest.err(404, SQLERRM);
    ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!');

  dt('fmr/report/[COLON]id');
  dh('fmr/report/[COLON]id','GET',q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n    NUMBER;
  l_fmt  VARCHAR2(10);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_RUN_BRIEFING_BOOK', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_RUN_BRIEFING_BOOK required'); RETURN;
  END IF;
  FOR c IN (SELECT run_id, status, row_count, error_msg, started_at, finished_at
              FROM dct_rpt_run
             WHERE run_id = [COLON]id AND report_code = 'GL_FMR_REPORT') LOOP
    SELECT COUNT(*), MAX(format) INTO l_n, l_fmt
      FROM dct_rpt_output WHERE run_id = c.run_id;
    dct_rest.json_header; APEX_JSON.initialize_output;
    APEX_JSON.open_object;
    APEX_JSON.write('runId', c.run_id);
    APEX_JSON.write('status', c.status);
    APEX_JSON.write('rowCount', c.row_count);
    APEX_JSON.write('error', NVL(DBMS_LOB.SUBSTR(c.error_msg, 500, 1), ''));
    APEX_JSON.write('format', NVL(l_fmt,''));
    APEX_JSON.write('startedAt', NVL(TO_CHAR(dct_to_local(c.started_at),'YYYY-MM-DD HH[COLON]MI AM'),''));
    APEX_JSON.write('finishedAt', NVL(TO_CHAR(dct_to_local(c.finished_at),'YYYY-MM-DD HH[COLON]MI AM'),''));
    APEX_JSON.write('hasFile', l_n > 0);
    APEX_JSON.close_object;
    RETURN;
  END LOOP;
  dct_rest.err(404,'Run not found');
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

  dt('fmr/report/[COLON]id/file');
  dh('fmr/report/[COLON]id/file','GET',q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_blob BLOB; l_name VARCHAR2(260); l_mime VARCHAR2(200);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_RUN_BRIEFING_BOOK', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_RUN_BRIEFING_BOOK required'); RETURN;
  END IF;
  BEGIN
    SELECT o.file_blob, o.file_name, o.mime_type INTO l_blob, l_name, l_mime FROM (
      SELECT o.file_blob, o.file_name, o.mime_type
        FROM dct_rpt_output o
        JOIN dct_rpt_run r ON r.run_id = o.run_id
       WHERE o.run_id = [COLON]id
         AND r.report_code = 'GL_FMR_REPORT'
       ORDER BY o.output_id DESC) o WHERE ROWNUM = 1;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'File not found'); RETURN; END;
  OWA_UTIL.mime_header(NVL(l_mime,'application/octet-stream'), FALSE);
  HTP.p('Content-Disposition[COLON] attachment; filename="'||NVL(l_name,'gl_fmr_report')||'"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

END setup_gl_fmr_rpt_tmp;
/

BEGIN
  setup_gl_fmr_rpt_tmp;
  COMMIT;
END;
/

DROP PROCEDURE setup_gl_fmr_rpt_tmp;

PROMPT === verification ===
SELECT uri_template, method
  FROM user_ords_handlers h
  JOIN user_ords_templates t ON t.id = h.template_id
  JOIN user_ords_modules m ON m.id = t.module_id
 WHERE m.name = 'gl.rest' AND t.uri_template LIKE 'fmr/report%'
 ORDER BY 1, 2;

PROMPT ============================================================
PROMPT  41_gl_fmr_report_ords.sql complete (fmr/report bridge).
PROMPT ============================================================
