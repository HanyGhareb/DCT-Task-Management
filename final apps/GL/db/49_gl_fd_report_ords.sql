-- Budget Status PDF/PPT bridge. Deploy only after review; fresh ADMIN SQLcl session.
-- Uses the same report privilege and queue as Projects Budget Utilization.
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_fd_rpt_tmp AS
    c_mod CONSTANT VARCHAR2(30) := 'gl.rest';
    PROCEDURE dt(p VARCHAR2) IS BEGIN ORDS.DEFINE_TEMPLATE(p_module_name=>c_mod, p_pattern=>REPLACE(p,'[COLON]',CHR(58))); END;
    PROCEDURE dh(p VARCHAR2, m VARCHAR2, s CLOB) IS BEGIN ORDS.DEFINE_HANDLER(p_module_name=>c_mod, p_pattern=>REPLACE(p,'[COLON]',CHR(58)), p_method=>m,
        p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(s,'[COLON]',CHR(58))); END;
BEGIN

  dt('fd/report');
  dh('fd/report','POST',q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_period VARCHAR2(10);
  l_format VARCHAR2(10);
  l_entity VARCHAR2(200);
  l_entity_count NUMBER;
  l_value VARCHAR2(4000);
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
  IF l_format NOT IN ('PDF','PPTX') THEN
    dct_rest.err(400,'format must be PDF or PPTX'); RETURN;
  END IF;
  l_entity := NVL(APEX_JSON.get_varchar2(p_path=>'entity'),'ALL');
  IF l_entity NOT IN ('ALL','UNCLASSIFIED') THEN
    SELECT COUNT(*) INTO l_entity_count FROM prod.dct_gl_class_value
     WHERE class_type_code='ENTITY' AND is_active='Y' AND value_code=l_entity;
    IF l_entity_count=0 THEN dct_rest.err(400,'Invalid entity'); RETURN; END IF;
  END IF;
  FOR k IN (SELECT 'presentation' key, '^(tiles|rows|map)$' pat FROM dual UNION ALL
            SELECT 'unit','^(auto|X|K|M|B)$' FROM dual UNION ALL
            SELECT 'lang','^(en|ar)$' FROM dual UNION ALL
            SELECT 'sector_sort','^(budget|used|free|name)$' FROM dual UNION ALL
            SELECT 'department_sort','^(budget|used|free|name)$' FROM dual UNION ALL
            SELECT 'sectors','^[A-Za-z0-9_|-]+$' FROM dual UNION ALL
            SELECT 'departments','^[A-Za-z0-9_|-]+$' FROM dual) LOOP
    l_value := APEX_JSON.get_varchar2(p_path=>k.key);
    IF l_value IS NOT NULL AND NOT REGEXP_LIKE(l_value,k.pat,'c') THEN
      dct_rest.err(400,'Invalid '||k.key); RETURN;
    END IF;
  END LOOP;
  IF LENGTH(APEX_JSON.get_varchar2(p_path=>'department_search')) > 200 THEN
    dct_rest.err(400,'Department search is too long'); RETURN;
  END IF;
  APEX_JSON.initialize_clob_output;
  APEX_JSON.open_object;
  APEX_JSON.write('period', l_period);
  IF l_entity IS NOT NULL THEN APEX_JSON.write('entity', l_entity); END IF;
  FOR k IN (SELECT 'presentation' key FROM dual UNION ALL SELECT 'unit' FROM dual
            UNION ALL SELECT 'lang' FROM dual UNION ALL SELECT 'sectors' FROM dual
            UNION ALL SELECT 'departments' FROM dual UNION ALL SELECT 'sector_sort' FROM dual
            UNION ALL SELECT 'department_sort' FROM dual UNION ALL SELECT 'department_search' FROM dual) LOOP
    APEX_JSON.write(k.key, APEX_JSON.get_varchar2(p_path=>k.key));
  END LOOP;
  APEX_JSON.close_object;
  l_params := APEX_JSON.get_clob_output;
  APEX_JSON.free_output;
  l_run := dct_rpt_pkg.enqueue(p_report_code  => 'GL_BUDGET_STATUS',
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

  dt('fd/report/[COLON]id');
  dh('fd/report/[COLON]id','GET',q'!
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
             WHERE run_id = [COLON]id AND report_code = 'GL_BUDGET_STATUS' AND UPPER(requested_by) = UPPER(l_user)) LOOP
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

  dt('fd/report/[COLON]id/file');
  dh('fd/report/[COLON]id/file','GET',q'!
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
         AND r.report_code = 'GL_BUDGET_STATUS' AND UPPER(r.requested_by) = UPPER(l_user)
       ORDER BY o.output_id DESC) o WHERE ROWNUM = 1;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'File not found'); RETURN; END;
  OWA_UTIL.mime_header(NVL(l_mime,'application/octet-stream'), FALSE);
  HTP.p('Content-Disposition[COLON] attachment; filename="'||NVL(l_name,'budget_status')||'"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

END setup_gl_fd_rpt_tmp;
/

BEGIN
  setup_gl_fd_rpt_tmp;
  COMMIT;
END;
/

DROP PROCEDURE setup_gl_fd_rpt_tmp;

PROMPT === verification ===
SELECT uri_template, method
  FROM user_ords_handlers h
  JOIN user_ords_templates t ON t.id = h.template_id
  JOIN user_ords_modules m ON m.id = t.module_id
 WHERE m.name = 'gl.rest' AND t.uri_template LIKE 'fd/report%'
 ORDER BY 1, 2;

PROMPT ============================================================
PROMPT  49_gl_fd_report_ords.sql complete (fd/report bridge).
PROMPT ============================================================
