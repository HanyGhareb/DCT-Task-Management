-- =============================================================================
-- General Ledger (App 210) -- MSS Projects Budget Utilization bridge (ADDITIVE)
-- File    : 53_gl_mss_register_ords.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp @53_gl_mss_register_ords.sql  (fresh session)
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            re-run 07..52 + THIS script right after it.
-- Purpose : runs MSS_BUTIL_REGISTER (reporting/db/46 -- the MSS distribution
--           copy of BUDGET_UTIL_REGISTER: FIXED 26-column sheet 1 (Task
--           Number kept + Task Name added), Requester on sheets 2-6 (AP =
--           matched PO line's requester, GRN/PO = PO distribution requestor,
--           PR = requisition requester, Pending = per document) and Task Name
--           on sheets 4-5) straight from the GL Budget Utilization page's
--           Generate Report menu. Same filter set as /gl/butil/xlsx;
--           deliberately NO sheetcols forwarding -- the layout is baked into
--           the definition and the page's Manage-Columns view must never
--           affect it.
-- Endpoints:
--   POST /gl/butil/mssxlsx          {year, period?, sector?, chapter?,
--                                    projecttype?, costcenter?, project?,
--                                    task?, etype?, search?, bu?, ovr?,
--                                    cmtmode?} -> {runId}
--   GET  /gl/butil/mssxlsx/:id      -> {runId, status, rowCount, error, hasFile}
--   GET  /gl/butil/mssxlsx/:id/file -> authed XLSX download of a finished run
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_mssreg_ords_tmp AS

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

    def_template('butil/mssxlsx');
    def_handler('butil/mssxlsx', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_year   NUMBER;
  l_period VARCHAR2(10);
  l_params CLOB;
  l_run    NUMBER;
  PROCEDURE put(p_key VARCHAR2) IS
    l_val VARCHAR2(2000) := APEX_JSON.get_varchar2(p_path => p_key);
  BEGIN
    IF l_val IS NOT NULL THEN APEX_JSON.write(p_key, l_val); END IF;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_RUN_BRIEFING_BOOK', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_RUN_BRIEFING_BOOK required'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_year := APEX_JSON.get_number(p_path=>'year');
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  l_period := APEX_JSON.get_varchar2(p_path=>'period');
  IF l_period IS NOT NULL THEN
    IF NOT REGEXP_LIKE(l_period, '^(0[1-9]|1[0-2])-[0-9]{4}$')
       OR TO_NUMBER(SUBSTR(l_period, 4)) <> l_year THEN
      dct_rest.err(400,'period must be MM-YYYY within the selected year'); RETURN;
    END IF;
  END IF;
  APEX_JSON.initialize_clob_output;
  APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  IF l_period IS NOT NULL THEN APEX_JSON.write('period', l_period); END IF;
  put('sector'); put('chapter'); put('projecttype'); put('costcenter');
  put('project'); put('task'); put('etype'); put('search'); put('bu');
  put('ovr');
  -- cmtmode is bound by the copied comments SQLs, so the key must ALWAYS
  -- ride the run params (a bind absent from the payload = datasource error).
  -- Deliberately NO sheetcols: the MSS sheet-1 layout is FIXED in the
  -- definition (reporting/db/46) and Manage Columns must never change it.
  APEX_JSON.write('cmtmode', NVL(UPPER(APEX_JSON.get_varchar2(p_path=>'cmtmode')),'NONE'));
  APEX_JSON.close_object;
  l_params := APEX_JSON.get_clob_output;
  APEX_JSON.free_output;
  l_run := dct_rpt_pkg.enqueue(p_report_code  => 'MSS_BUTIL_REGISTER',
                               p_params       => l_params,
                               p_trigger      => 'ONDEMAND',
                               p_requested_by => l_user,
                               p_formats      => 'XLSX');
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

    def_template('butil/mssxlsx/[COLON]id');
    def_handler('butil/mssxlsx/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_xls  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_RUN_BRIEFING_BOOK', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_RUN_BRIEFING_BOOK required'); RETURN;
  END IF;
  FOR c IN (SELECT run_id, status, row_count, error_msg, started_at, finished_at
              FROM dct_rpt_run
             WHERE run_id = [COLON]id AND report_code = 'MSS_BUTIL_REGISTER') LOOP
    SELECT COUNT(*) INTO l_xls
      FROM dct_rpt_output WHERE run_id = c.run_id AND format = 'XLSX';
    dct_rest.json_header; APEX_JSON.initialize_output;
    APEX_JSON.open_object;
    APEX_JSON.write('runId', c.run_id);
    APEX_JSON.write('status', c.status);
    APEX_JSON.write('rowCount', c.row_count);
    APEX_JSON.write('error', NVL(DBMS_LOB.SUBSTR(c.error_msg, 500, 1), ''));
    APEX_JSON.write('startedAt', NVL(TO_CHAR(dct_to_local(c.started_at),'YYYY-MM-DD HH[COLON]MI AM'),''));
    APEX_JSON.write('finishedAt', NVL(TO_CHAR(dct_to_local(c.finished_at),'YYYY-MM-DD HH[COLON]MI AM'),''));
    APEX_JSON.write('hasFile', l_xls > 0);
    APEX_JSON.close_object;
    RETURN;
  END LOOP;
  dct_rest.err(404,'Run not found');
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('butil/mssxlsx/[COLON]id/file');
    def_handler('butil/mssxlsx/[COLON]id/file', 'GET', q'!
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
       WHERE o.run_id = [COLON]id AND o.format = 'XLSX'
         AND r.report_code = 'MSS_BUTIL_REGISTER'
       ORDER BY o.output_id DESC) o WHERE ROWNUM = 1;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'File not found'); RETURN; END;
  OWA_UTIL.mime_header(NVL(l_mime,'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'), FALSE);
  HTP.p('Content-Disposition[COLON] attachment; filename="'||NVL(l_name,'mss_projects_budget_utilization.xlsx')||'"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

END;
/

BEGIN
    setup_gl_mssreg_ords_tmp;
    COMMIT;
END;
/
DROP PROCEDURE setup_gl_mssreg_ords_tmp;

PROMPT === verify ===
SELECT t.uri_template, h.method
FROM user_ords_handlers h
JOIN user_ords_templates t ON t.id = h.template_id
JOIN user_ords_modules m  ON m.id = t.module_id
WHERE m.name = 'gl.rest'
  AND t.uri_template LIKE 'butil/mssxlsx%'
ORDER BY t.uri_template, h.method;

PROMPT gl.rest MSS register bridge published (/gl/butil/mssxlsx + /:id + /:id/file).
