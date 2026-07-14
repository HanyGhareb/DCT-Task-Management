-- =============================================================================
-- General Ledger (App 210) -- Budget Utilization Briefing Book bridge (ADDITIVE)
-- File    : 11_gl_butil_book_ords.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp @11_gl_butil_book_ords.sql  (fresh session)
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            re-run 07 + 08 + 09 + 10 + THIS script right after it.
-- Purpose : lets any GL-authorized user run the BUDGET_UTIL_BOOK report
--           (Reporting Platform, reporting/db/21) straight from the GL app's
--           Budget Utilization page. The /rpt/ admin endpoints are SYS_ADMIN
--           gated, so the GL app talks to these thin GL-gated bridges instead;
--           the run itself is processed by the normal PYTHON worker fleet.
-- Endpoints:
--   POST /gl/butil/book          {year, sector?, projecttype?, costcenter?}
--                                -> {runId}; enqueues BUDGET_UTIL_BOOK (PDF)
--   GET  /gl/butil/book/:id      -> {runId, status, rowCount, error, hasPdf}
--                                   (BUDGET_UTIL_BOOK runs only)
--   GET  /gl/butil/book/:id/pdf  -> authed PDF download of a finished run
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_bubook_ords_tmp AS

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

    def_template('butil/book');
    def_handler('butil/book', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_year   NUMBER;
  l_params CLOB;
  l_run    NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_year := APEX_JSON.get_number(p_path=>'year');
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  APEX_JSON.initialize_clob_output;
  APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  IF APEX_JSON.get_varchar2(p_path=>'sector') IS NOT NULL THEN
    APEX_JSON.write('sector', APEX_JSON.get_varchar2(p_path=>'sector'));
  END IF;
  IF APEX_JSON.get_varchar2(p_path=>'projecttype') IS NOT NULL THEN
    APEX_JSON.write('projecttype', APEX_JSON.get_varchar2(p_path=>'projecttype'));
  END IF;
  IF APEX_JSON.get_varchar2(p_path=>'costcenter') IS NOT NULL THEN
    APEX_JSON.write('costcenter', APEX_JSON.get_varchar2(p_path=>'costcenter'));
  END IF;
  APEX_JSON.close_object;
  l_params := APEX_JSON.get_clob_output;
  APEX_JSON.free_output;
  l_run := dct_rpt_pkg.enqueue(p_report_code  => 'BUDGET_UTIL_BOOK',
                               p_params       => l_params,
                               p_trigger      => 'ONDEMAND',
                               p_requested_by => l_user,
                               p_formats      => 'PDF');
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('runId', l_run);
  APEX_JSON.close_object;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    IF SQLCODE = -20404 THEN dct_rest.err(404, SQLERRM);
    ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!');

    def_template('butil/book/[COLON]id');
    def_handler('butil/book/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_pdf  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  FOR c IN (SELECT run_id, status, row_count, error_msg, started_at, finished_at
              FROM dct_rpt_run
             WHERE run_id = [COLON]id AND report_code = 'BUDGET_UTIL_BOOK') LOOP
    SELECT COUNT(*) INTO l_pdf
      FROM dct_rpt_output WHERE run_id = c.run_id AND format = 'PDF';
    dct_rest.json_header; APEX_JSON.initialize_output;
    APEX_JSON.open_object;
    APEX_JSON.write('runId', c.run_id);
    APEX_JSON.write('status', c.status);
    APEX_JSON.write('rowCount', c.row_count);
    APEX_JSON.write('error', NVL(DBMS_LOB.SUBSTR(c.error_msg, 500, 1), ''));
    APEX_JSON.write('startedAt', NVL(TO_CHAR(dct_to_local(c.started_at),'YYYY-MM-DD HH[COLON]MI AM'),''));
    APEX_JSON.write('finishedAt', NVL(TO_CHAR(dct_to_local(c.finished_at),'YYYY-MM-DD HH[COLON]MI AM'),''));
    APEX_JSON.write('hasPdf', l_pdf > 0);
    APEX_JSON.close_object;
    RETURN;
  END LOOP;
  dct_rest.err(404,'Run not found');
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('butil/book/[COLON]id/pdf');
    def_handler('butil/book/[COLON]id/pdf', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_blob BLOB; l_name VARCHAR2(260);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  BEGIN
    SELECT o.file_blob, o.file_name INTO l_blob, l_name FROM (
      SELECT o.file_blob, o.file_name
        FROM dct_rpt_output o
        JOIN dct_rpt_run r ON r.run_id = o.run_id
       WHERE o.run_id = [COLON]id AND o.format = 'PDF'
         AND r.report_code = 'BUDGET_UTIL_BOOK'
       ORDER BY o.output_id DESC) o WHERE ROWNUM = 1;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'PDF not found'); RETURN; END;
  OWA_UTIL.mime_header('application/pdf', FALSE);
  HTP.p('Content-Disposition[COLON] attachment; filename="'||NVL(l_name,'briefing_book.pdf')||'"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

END;
/

BEGIN
    setup_gl_bubook_ords_tmp;
    COMMIT;
END;
/
DROP PROCEDURE setup_gl_bubook_ords_tmp;

PROMPT === verify ===
SELECT t.uri_template, h.method
FROM user_ords_handlers h
JOIN user_ords_templates t ON t.id = h.template_id
JOIN user_ords_modules m  ON m.id = t.module_id
WHERE m.name = 'gl.rest' AND t.uri_template LIKE 'butil/book%'
ORDER BY t.uri_template, h.method;

PROMPT gl.rest Briefing Book bridge published (/gl/butil/book + status + pdf).
