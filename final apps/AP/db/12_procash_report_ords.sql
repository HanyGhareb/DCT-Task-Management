-- =============================================================================
-- Procash Transactions -- Reporting Platform bridge (ADDITIVE)
-- File    : 12_procash_report_ords.sql       App 212 / AP        2026-08-17
-- Adds to : ap.rest (does NOT delete or redefine the module)
-- Run     : sql -name prod_mcp @12_procash_report_ords.sql   (fresh session)
-- IMPORTANT: 03_ap_ords.sql rebuilds ap.rest from scratch -- whenever 03 is
--           re-run, re-run 04, 06, 07, 10 and THIS script right after it.
--
-- Runs the Reporting-Platform definition PROCASH_REGISTER (reporting/db/37) as
-- the calling user, with the page's own filters, so the book scope IS the page
-- scope. /rpt/ itself stays SYS_ADMIN-only; this bridge is the AP-side door.
--
--   POST   procash/meta/report            enqueue {format: PDF|XLSX, filters}
--   GET    procash/meta/report/[COLON]runid     run status
--   GET    procash/meta/report/[COLON]runid/file  download the output
--
-- The routes sit under the meta segment for the same reason every other procash
-- lookup does: a third segment that no [COLON]id route uses can never collide
-- with a numeric transaction id.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE SYNONYM dct_rpt_pkg    FOR prod.dct_rpt_pkg;
CREATE OR REPLACE SYNONYM dct_rpt_run    FOR prod.dct_rpt_run;
CREATE OR REPLACE SYNONYM dct_rpt_output FOR prod.dct_rpt_output;

CREATE OR REPLACE PROCEDURE setup_procash_rpt_ords AS
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

    def_template('procash/meta/report');
    def_handler('procash/meta/report', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_format VARCHAR2(10);
  l_params CLOB;
  l_run    NUMBER;
  FUNCTION j(p_key VARCHAR2) RETURN VARCHAR2 IS
    v VARCHAR2(4000) := APEX_JSON.get_varchar2(p_path => p_key);
  BEGIN
    IF TRIM(v) IS NULL THEN RETURN NULL; END IF;
    RETURN '"' || p_key || '"[COLON]"' || REPLACE(v, '"', '') || '",';
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401, 'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_format := UPPER(NVL(APEX_JSON.get_varchar2(p_path => 'format'), 'XLSX'));
  IF l_format NOT IN ('PDF', 'XLSX') THEN
    dct_rest.err(400, 'format must be PDF or XLSX'); RETURN;
  END IF;
  l_params := '{' || j('status') || j('bu') || j('datefrom') || j('dateto') || j('search');
  l_params := RTRIM(l_params, ',') || '}';
  l_run := dct_rpt_pkg.enqueue(p_report_code  => 'PROCASH_REGISTER',
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

    def_template('procash/meta/report/[COLON]runid');
    def_handler('procash/meta/report/[COLON]runid', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_file   NUMBER;
  l_format VARCHAR2(10);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401, 'Unauthorized'); RETURN; END IF;
  FOR c IN (SELECT run_id, status, row_count, error_msg, started_at, finished_at, formats
              FROM dct_rpt_run
             WHERE run_id = [COLON]runid AND report_code = 'PROCASH_REGISTER') LOOP
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

    def_template('procash/meta/report/[COLON]runid/file');
    def_handler('procash/meta/report/[COLON]runid/file', 'GET', q'!
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
       WHERE o.run_id = [COLON]runid
         AND r.report_code = 'PROCASH_REGISTER'
       ORDER BY o.output_id DESC) o WHERE ROWNUM = 1;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404, 'File not found'); RETURN; END;
  OWA_UTIL.mime_header(NVL(l_mime, 'application/octet-stream'), FALSE);
  HTP.p('Content-Disposition[COLON] attachment; filename="' || NVL(l_name, 'procash_register') || '"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END setup_procash_rpt_ords;
/

BEGIN setup_procash_rpt_ords; END;
/
DROP PROCEDURE setup_procash_rpt_ords;

PROMPT === verification -- procash report routes on ap.rest ===
SELECT t.uri_template, LISTAGG(h.method, ' ') WITHIN GROUP (ORDER BY h.method) AS methods
  FROM user_ords_templates t
  JOIN user_ords_modules m ON m.id = t.module_id
  LEFT JOIN user_ords_handlers h ON h.template_id = t.id
 WHERE m.name = 'ap.rest' AND t.uri_template LIKE 'procash/meta/report%'
 GROUP BY t.uri_template ORDER BY t.uri_template;
