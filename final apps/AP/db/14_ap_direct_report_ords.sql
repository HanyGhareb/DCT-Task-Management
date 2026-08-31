-- =============================================================================
-- Accounts Payable (App 212) -- Direct AP Briefing Book bridge (ADDITIVE)
-- File    : 14_ap_direct_report_ords.sql
-- Adds to : ap.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp @14_ap_direct_report_ords.sql   (fresh session)
-- IMPORTANT: 03_ap_ords.sql rebuilds ap.rest from scratch -- whenever 03 is
--           re-run, re-run 04, 06, 07, 10, 12 AND THIS script right after it.
-- Purpose : Briefing Book (Excel) button on the AP Direct AP page -- enqueues
--           the Reporting-Platform definition AP_DIRECT_REGISTER
--           (reporting/db/38) as the calling user, same pattern as the AI
--           Duplicate Check bridge (AP/db/07):
--   POST /ap/direct/report            body {format:'XLSX', bu?, supplier?,
--                                     paid?, val?, chapter?, datefrom?,
--                                     dateto?, search?, inclcxl?}
--                                     -> {runId, format}
--                                     (XLSX only -- the definition has no PDF
--                                     template; any other format = 400)
--   GET  /ap/direct/report/:id        -> {runId, status, rowCount, error,
--                                         startedAt, finishedAt, hasFile,
--                                         format}
--   GET  /ap/direct/report/:id/file   -> authed download of the finished
--                                         run's XLSX output
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE SYNONYM dct_rpt_pkg    FOR prod.dct_rpt_pkg;
CREATE OR REPLACE SYNONYM dct_rpt_run    FOR prod.dct_rpt_run;
CREATE OR REPLACE SYNONYM dct_rpt_output FOR prod.dct_rpt_output;

CREATE OR REPLACE PROCEDURE setup_ap_direct_rpt_ords AS
    c_mod CONSTANT VARCHAR2(30) := 'ap.rest';
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

    def_template('direct/report');
    def_handler('direct/report', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_format VARCHAR2(10);
  l_params CLOB;
  l_run    NUMBER;
  PROCEDURE put(p_key VARCHAR2) IS
    -- 2000: bu/supplier/paid/val may carry a pipe-delimited multi-select list
    l_val VARCHAR2(2000) := APEX_JSON.get_varchar2(p_path => p_key);
  BEGIN
    IF l_val IS NOT NULL THEN APEX_JSON.write(p_key, l_val); END IF;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401, 'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_format := UPPER(NVL(APEX_JSON.get_varchar2(p_path => 'format'), 'XLSX'));
  IF l_format <> 'XLSX' THEN
    dct_rest.err(400, 'format must be XLSX'); RETURN;
  END IF;
  APEX_JSON.initialize_clob_output;
  APEX_JSON.open_object;
  put('bu'); put('supplier'); put('paid'); put('val'); put('chapter');
  put('datefrom'); put('dateto'); put('search'); put('inclcxl');
  APEX_JSON.close_object;
  l_params := APEX_JSON.get_clob_output;
  APEX_JSON.free_output;
  l_run := dct_rpt_pkg.enqueue(p_report_code  => 'AP_DIRECT_REGISTER',
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

    def_template('direct/report/[COLON]id');
    def_handler('direct/report/[COLON]id', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_file   NUMBER;
  l_format VARCHAR2(10);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401, 'Unauthorized'); RETURN; END IF;
  FOR c IN (SELECT run_id, status, row_count, error_msg, started_at, finished_at, formats
              FROM dct_rpt_run
             WHERE run_id = [COLON]id AND report_code = 'AP_DIRECT_REGISTER') LOOP
    SELECT COUNT(*), MAX(format) INTO l_file, l_format
      FROM dct_rpt_output WHERE run_id = c.run_id;
    dct_rest.json_header; APEX_JSON.initialize_output;
    APEX_JSON.open_object;
    APEX_JSON.write('runId', c.run_id);
    APEX_JSON.write('status', c.status);
    APEX_JSON.write('rowCount', c.row_count);
    APEX_JSON.write('error', NVL(DBMS_LOB.SUBSTR(c.error_msg, 500, 1), ''));
    APEX_JSON.write('startedAt', NVL(TO_CHAR(dct_to_local(c.started_at),'YYYY-MM-DD HH[COLON]MI AM'),''));
    APEX_JSON.write('finishedAt', NVL(TO_CHAR(dct_to_local(c.finished_at),'YYYY-MM-DD HH[COLON]MI AM'),''));
    APEX_JSON.write('hasFile', l_file > 0);
    APEX_JSON.write('format', NVL(l_format, c.formats));
    APEX_JSON.close_object;
    RETURN;
  END LOOP;
  dct_rest.err(404, 'Run not found');
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('direct/report/[COLON]id/file');
    def_handler('direct/report/[COLON]id/file', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_blob BLOB; l_name VARCHAR2(260); l_mime VARCHAR2(200);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401, 'Unauthorized'); RETURN; END IF;
  BEGIN
    SELECT o.file_blob, o.file_name, o.mime_type INTO l_blob, l_name, l_mime FROM (
      SELECT o.file_blob, o.file_name, o.mime_type
        FROM dct_rpt_output o
        JOIN dct_rpt_run r ON r.run_id = o.run_id
       WHERE o.run_id = [COLON]id
         AND r.report_code = 'AP_DIRECT_REGISTER'
       ORDER BY o.output_id DESC) o WHERE ROWNUM = 1;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404, 'File not found'); RETURN; END;
  OWA_UTIL.mime_header(NVL(l_mime, 'application/octet-stream'), FALSE);
  HTP.p('Content-Disposition[COLON] attachment; filename="' || NVL(l_name, 'ap_direct_register') || '"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END setup_ap_direct_rpt_ords;
/

BEGIN setup_ap_direct_rpt_ords; END;
/
DROP PROCEDURE setup_ap_direct_rpt_ords;

PROMPT === verification ===
SELECT COUNT(*) direct_rpt_handlers FROM user_ords_handlers
 WHERE source LIKE '%AP_DIRECT_REGISTER%';

PROMPT ap.rest Direct-AP report bridge published:
PROMPT   POST /ap/direct/report   GET /ap/direct/report/:id[/file]
