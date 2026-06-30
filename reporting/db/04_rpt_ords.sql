-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 04 ORDS  (control plane over DCT_RPT_*)
-- File    : reporting/db/04_rpt_ords.sql
-- Schema  : registered under ADMIN (the only REST-routable schema on ADB)
-- Base URL: /ords/admin/rpt/
-- Run     : sql -name prod_mcp @04_rpt_ords.sql   (FRESH session -- synonym rule:
--           must NOT follow ALTER SESSION SET CURRENT_SCHEMA=PROD, or synonyms
--           self-reference -> ORA-01471)
-- Admin-only (SYS_ADMIN). Manages definitions / schedules / recipients / config
-- and reads run history. Generation is delegated: PYTHON engine via
-- DCT_RPT_PKG.enqueue (a worker claims it); NATIVE engine arrives in Phase 3.
-- Pagination envelope {items,total,limit,offset}. [COLON] -> ':' at define time.
-- =============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

-- ADMIN synonyms the handlers touch (dct_rest/dct_auth/dct_to_local exist already)
CREATE OR REPLACE SYNONYM dct_rpt_definition   FOR prod.dct_rpt_definition;
CREATE OR REPLACE SYNONYM dct_rpt_schedule     FOR prod.dct_rpt_schedule;
CREATE OR REPLACE SYNONYM dct_rpt_recipient    FOR prod.dct_rpt_recipient;
CREATE OR REPLACE SYNONYM dct_rpt_run          FOR prod.dct_rpt_run;
CREATE OR REPLACE SYNONYM dct_rpt_output       FOR prod.dct_rpt_output;
CREATE OR REPLACE SYNONYM dct_rpt_delivery     FOR prod.dct_rpt_delivery;
CREATE OR REPLACE SYNONYM dct_rpt_config       FOR prod.dct_rpt_config;
CREATE OR REPLACE SYNONYM dct_rpt_pkg          FOR prod.dct_rpt_pkg;
CREATE OR REPLACE SYNONYM dct_rpt_sched_sync   FOR prod.dct_rpt_sched_sync;
CREATE OR REPLACE SYNONYM dct_lookup_values    FOR prod.dct_lookup_values;
CREATE OR REPLACE SYNONYM dct_lookup_categories FOR prod.dct_lookup_categories;

CREATE OR REPLACE PROCEDURE admin.setup_rpt_ords_tmp AS
  c_mod CONSTANT VARCHAR2(30) := 'rpt.rest';
  PROCEDURE def_template(p_pattern VARCHAR2) IS
  BEGIN
    ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => REPLACE(p_pattern,'[COLON]',CHR(58)));
  END;
  PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
  BEGIN
    ORDS.DEFINE_HANDLER(
      p_module_name => c_mod,
      p_pattern     => REPLACE(p_pattern,'[COLON]',CHR(58)),
      p_method      => p_method,
      p_source_type => ORDS.source_type_plsql,
      p_source      => REPLACE(p_source,'[COLON]',CHR(58)));
  END;
BEGIN
  BEGIN ORDS.DELETE_MODULE(p_module_name => c_mod); EXCEPTION WHEN OTHERS THEN NULL; END;
  ORDS.DEFINE_MODULE(
    p_module_name    => c_mod,
    p_base_path      => '/rpt/',
    p_items_per_page => 100,
    p_status         => 'PUBLISHED',
    p_comments       => 'i-Finance -- Reporting Platform control plane');

  -- ===========================================================================
  -- META  (dropdown vocabularies from the RPT_* lookups)
  -- ===========================================================================
  def_template('meta');
  def_handler('meta', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  PROCEDURE arr(p_cat VARCHAR2, p_label VARCHAR2) IS
  BEGIN
    APEX_JSON.open_array(p_label);
    FOR v IN (SELECT lv.value_code, lv.value_name_en
                FROM dct_lookup_values lv JOIN dct_lookup_categories lc ON lc.category_id = lv.category_id
               WHERE lc.category_code = p_cat AND lv.is_active='Y' ORDER BY lv.display_order) LOOP
      APEX_JSON.open_object; APEX_JSON.write('code', v.value_code); APEX_JSON.write('name', v.value_name_en); APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  arr('RPT_ENGINE','engines'); arr('RPT_FORMAT','formats'); arr('RPT_SOURCE_TYPE','sourceTypes');
  arr('RPT_RECIP_TYPE','recipientTypes'); arr('RPT_CHANNEL','channels'); arr('RPT_RUN_STATUS','runStatuses');
  APEX_JSON.open_array('categories');
  FOR c IN (SELECT DISTINCT category v FROM dct_rpt_definition WHERE category IS NOT NULL ORDER BY 1) LOOP
    APEX_JSON.write(c.v); END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

  -- ===========================================================================
  -- DEFINITIONS  list / create
  -- ===========================================================================
  def_template('reports/');
  def_handler('reports/', 'GET', q'[
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit  DEFAULT NULL ON CONVERSION ERROR),100),500);
  l_offset NUMBER := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR),0),0);
  l_q      VARCHAR2(200) := [COLON]search;
  l_eng    VARCHAR2(20)  := [COLON]engine;
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  SELECT COUNT(*) INTO l_total FROM dct_rpt_definition
   WHERE (l_eng IS NULL OR engine = l_eng)
     AND (l_q IS NULL OR UPPER(report_code||' '||name_en||' '||NVL(description,'')||' '||NVL(category,''))
                          LIKE '%'||UPPER(l_q)||'%');
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('total', l_total); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR c IN (
    SELECT * FROM (
      SELECT a.report_code, a.name_en, a.name_ar, a.category, a.engine, a.default_formats,
             a.enabled, a.updated_at,
             (SELECT COUNT(*) FROM dct_rpt_schedule s WHERE s.report_code=a.report_code AND s.enabled='Y') sched_n,
             (SELECT COUNT(*) FROM dct_rpt_recipient r WHERE r.report_code=a.report_code AND r.enabled='Y') recip_n,
             ROW_NUMBER() OVER (ORDER BY a.category, a.name_en) rn
      FROM dct_rpt_definition a
      WHERE (l_eng IS NULL OR a.engine = l_eng)
        AND (l_q IS NULL OR UPPER(a.report_code||' '||a.name_en||' '||NVL(a.description,'')||' '||NVL(a.category,''))
                             LIKE '%'||UPPER(l_q)||'%')
    ) WHERE rn > l_offset AND rn <= l_offset + l_limit
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('reportCode', c.report_code);
    APEX_JSON.write('nameEn', c.name_en);
    APEX_JSON.write('nameAr', NVL(c.name_ar,''));
    APEX_JSON.write('category', NVL(c.category,''));
    APEX_JSON.write('engine', c.engine);
    APEX_JSON.write('formats', c.default_formats);
    APEX_JSON.write('enabled', c.enabled);
    APEX_JSON.write('schedules', c.sched_n);
    APEX_JSON.write('recipients', c.recip_n);
    APEX_JSON.write('updatedAt', TO_CHAR(dct_to_local(c.updated_at),'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

  def_handler('reports/', 'POST', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  INSERT INTO dct_rpt_definition
    (report_code, name_en, name_ar, description, category, source_type, source_ref, engine,
     default_formats, pdf_template, xlsx_template, email_subject_tpl, email_body_tpl, params_json,
     enabled, created_by, updated_by)
  VALUES
    (UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'reportCode'))),
     APEX_JSON.get_varchar2(p_path=>'nameEn'),
     APEX_JSON.get_varchar2(p_path=>'nameAr'),
     APEX_JSON.get_varchar2(p_path=>'description'),
     APEX_JSON.get_varchar2(p_path=>'category'),
     NVL(APEX_JSON.get_varchar2(p_path=>'sourceType'),'VIEW'),
     APEX_JSON.get_clob(p_path=>'sourceRef'),
     NVL(APEX_JSON.get_varchar2(p_path=>'engine'),'PYTHON'),
     NVL(APEX_JSON.get_varchar2(p_path=>'formats'),'PDF,XLSX'),
     APEX_JSON.get_varchar2(p_path=>'pdfTemplate'),
     APEX_JSON.get_varchar2(p_path=>'xlsxTemplate'),
     APEX_JSON.get_varchar2(p_path=>'emailSubjectTpl'),
     APEX_JSON.get_clob(p_path=>'emailBodyTpl'),
     APEX_JSON.get_clob(p_path=>'paramsJson'),
     NVL(APEX_JSON.get_varchar2(p_path=>'enabled'),'Y'),
     l_user, l_user);
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN ROLLBACK; dct_rest.err(400,'A report with that code already exists');
  WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

  -- ===========================================================================
  -- DEFINITION  detail / update / delete
  -- ===========================================================================
  def_template('reports/[COLON]code');
  def_handler('reports/[COLON]code', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  FOR c IN (SELECT * FROM dct_rpt_definition WHERE report_code = [COLON]code) LOOP
    dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
    APEX_JSON.write('reportCode', c.report_code);
    APEX_JSON.write('nameEn', c.name_en);
    APEX_JSON.write('nameAr', NVL(c.name_ar,''));
    APEX_JSON.write('description', NVL(c.description,''));
    APEX_JSON.write('category', NVL(c.category,''));
    APEX_JSON.write('sourceType', c.source_type);
    APEX_JSON.write('sourceRef', c.source_ref);
    APEX_JSON.write('engine', c.engine);
    APEX_JSON.write('formats', c.default_formats);
    APEX_JSON.write('pdfTemplate', NVL(c.pdf_template,''));
    APEX_JSON.write('xlsxTemplate', NVL(c.xlsx_template,''));
    APEX_JSON.write('emailSubjectTpl', NVL(c.email_subject_tpl,''));
    APEX_JSON.write('emailBodyTpl', NVL(c.email_body_tpl,''));
    APEX_JSON.write('paramsJson', NVL(c.params_json,''));
    APEX_JSON.write('enabled', c.enabled);
    APEX_JSON.write('updatedAt', TO_CHAR(dct_to_local(c.updated_at),'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.close_object; RETURN;
  END LOOP;
  dct_rest.err(404,'Report not found');
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

  def_handler('reports/[COLON]code', 'PUT', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n    NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE dct_rpt_definition SET
    name_en           = NVL(APEX_JSON.get_varchar2(p_path=>'nameEn'), name_en),
    name_ar           = APEX_JSON.get_varchar2(p_path=>'nameAr'),
    description       = APEX_JSON.get_varchar2(p_path=>'description'),
    category          = APEX_JSON.get_varchar2(p_path=>'category'),
    source_type       = NVL(APEX_JSON.get_varchar2(p_path=>'sourceType'), source_type),
    source_ref        = NVL(APEX_JSON.get_clob(p_path=>'sourceRef'), source_ref),
    engine            = NVL(APEX_JSON.get_varchar2(p_path=>'engine'), engine),
    default_formats   = NVL(APEX_JSON.get_varchar2(p_path=>'formats'), default_formats),
    pdf_template      = APEX_JSON.get_varchar2(p_path=>'pdfTemplate'),
    xlsx_template     = APEX_JSON.get_varchar2(p_path=>'xlsxTemplate'),
    email_subject_tpl = APEX_JSON.get_varchar2(p_path=>'emailSubjectTpl'),
    email_body_tpl    = APEX_JSON.get_clob(p_path=>'emailBodyTpl'),
    params_json       = APEX_JSON.get_clob(p_path=>'paramsJson'),
    enabled           = NVL(APEX_JSON.get_varchar2(p_path=>'enabled'), enabled),
    updated_by        = l_user,
    updated_at        = SYSTIMESTAMP
  WHERE report_code = [COLON]code;
  l_n := SQL%ROWCOUNT; COMMIT;
  IF l_n = 0 THEN dct_rest.err(404,'Report not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

  def_handler('reports/[COLON]code', 'DELETE', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n    NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  DELETE FROM dct_rpt_definition WHERE report_code = [COLON]code;
  l_n := SQL%ROWCOUNT; COMMIT;
  IF l_n = 0 THEN dct_rest.err(404,'Report not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

  -- ===========================================================================
  -- RUN NOW  (enqueue a QUEUED run; a worker / native engine picks it up)
  -- ===========================================================================
  def_template('reports/[COLON]code/run');
  def_handler('reports/[COLON]code/run', 'POST', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_run  NUMBER;
  l_fmt  VARCHAR2(40) := [COLON]formats;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  l_run := dct_rpt_pkg.enqueue(
             p_report_code  => [COLON]code,
             p_trigger      => 'ONDEMAND',
             p_requested_by => l_user,
             p_formats      => l_fmt);
  COMMIT;
  OWA_UTIL.status_line(202, NULL, FALSE);
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('runId', l_run); APEX_JSON.write('status','QUEUED'); APEX_JSON.close_object;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    IF SQLCODE = -20404 THEN dct_rest.err(404, SQLERRM); ELSE dct_rest.err(500, SQLERRM); END IF;
END;
]');

  -- ===========================================================================
  -- RUNS  list / detail / output download / retry
  -- ===========================================================================
  def_template('runs/');
  def_handler('runs/', 'GET', q'[
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit  DEFAULT NULL ON CONVERSION ERROR),50),500);
  l_offset NUMBER := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR),0),0);
  l_rep    VARCHAR2(60) := [COLON]report;
  l_st     VARCHAR2(20) := [COLON]status;
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  SELECT COUNT(*) INTO l_total FROM dct_rpt_run
   WHERE (l_rep IS NULL OR report_code = l_rep) AND (l_st IS NULL OR status = l_st);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('total', l_total); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR c IN (
    SELECT * FROM (
      SELECT a.run_id, a.report_code, a.trigger_source, a.engine, a.status, a.row_count,
             a.requested_by, a.worker_id, a.attempts, a.created_at, a.started_at, a.finished_at,
             (SELECT COUNT(*) FROM dct_rpt_output o WHERE o.run_id=a.run_id) out_n,
             ROW_NUMBER() OVER (ORDER BY a.run_id DESC) rn
      FROM dct_rpt_run a
      WHERE (l_rep IS NULL OR a.report_code = l_rep) AND (l_st IS NULL OR a.status = l_st)
    ) WHERE rn > l_offset AND rn <= l_offset + l_limit
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('runId', c.run_id);
    APEX_JSON.write('reportCode', c.report_code);
    APEX_JSON.write('trigger', c.trigger_source);
    APEX_JSON.write('engine', c.engine);
    APEX_JSON.write('status', c.status);
    APEX_JSON.write('rowCount', NVL(c.row_count,0));
    APEX_JSON.write('requestedBy', NVL(c.requested_by,''));
    APEX_JSON.write('workerId', NVL(c.worker_id,''));
    APEX_JSON.write('attempts', c.attempts);
    APEX_JSON.write('outputs', c.out_n);
    APEX_JSON.write('createdAt', TO_CHAR(dct_to_local(c.created_at),'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.write('finishedAt', CASE WHEN c.finished_at IS NULL THEN NULL ELSE TO_CHAR(dct_to_local(c.finished_at),'YYYY-MM-DD HH:MI AM') END);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

  def_template('runs/[COLON]id');
  def_handler('runs/[COLON]id', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_ok   NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  FOR c IN (SELECT * FROM dct_rpt_run WHERE run_id = [COLON]id) LOOP
    l_ok := 1;
    dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
    APEX_JSON.write('runId', c.run_id);
    APEX_JSON.write('reportCode', c.report_code);
    APEX_JSON.write('trigger', c.trigger_source);
    APEX_JSON.write('engine', c.engine);
    APEX_JSON.write('status', c.status);
    APEX_JSON.write('rowCount', NVL(c.row_count,0));
    APEX_JSON.write('formats', NVL(c.formats,''));
    APEX_JSON.write('requestedBy', NVL(c.requested_by,''));
    APEX_JSON.write('workerId', NVL(c.worker_id,''));
    APEX_JSON.write('attempts', c.attempts);
    APEX_JSON.write('error', NVL(c.error_msg,''));
    APEX_JSON.write('createdAt', TO_CHAR(dct_to_local(c.created_at),'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.write('startedAt', CASE WHEN c.started_at IS NULL THEN NULL ELSE TO_CHAR(dct_to_local(c.started_at),'YYYY-MM-DD HH:MI AM') END);
    APEX_JSON.write('finishedAt', CASE WHEN c.finished_at IS NULL THEN NULL ELSE TO_CHAR(dct_to_local(c.finished_at),'YYYY-MM-DD HH:MI AM') END);
    APEX_JSON.open_array('outputs');
    FOR o IN (SELECT output_id, format, file_name, file_bytes FROM dct_rpt_output WHERE run_id=c.run_id ORDER BY output_id) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('outputId', o.output_id); APEX_JSON.write('format', o.format);
      APEX_JSON.write('fileName', NVL(o.file_name,'')); APEX_JSON.write('bytes', NVL(o.file_bytes,0));
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.open_array('deliveries');
    FOR d IN (SELECT recipient, channel, status, sent_at, error_msg FROM dct_rpt_delivery WHERE run_id=c.run_id ORDER BY delivery_id) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('recipient', NVL(d.recipient,'')); APEX_JSON.write('channel', d.channel);
      APEX_JSON.write('status', d.status);
      APEX_JSON.write('sentAt', CASE WHEN d.sent_at IS NULL THEN NULL ELSE TO_CHAR(dct_to_local(d.sent_at),'YYYY-MM-DD HH:MI AM') END);
      APEX_JSON.write('error', NVL(d.error_msg,''));
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.close_object;
  END LOOP;
  IF l_ok = 0 THEN dct_rest.err(404,'Run not found'); END IF;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

  -- authed BLOB download of a run's output for a given format
  def_template('runs/[COLON]id/output/[COLON]fmt');
  def_handler('runs/[COLON]id/output/[COLON]fmt', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_blob BLOB; l_mime VARCHAR2(120); l_name VARCHAR2(260);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  BEGIN
    SELECT file_blob, mime_type, file_name INTO l_blob, l_mime, l_name FROM (
      SELECT file_blob, mime_type, file_name FROM dct_rpt_output
       WHERE run_id = [COLON]id AND format = UPPER([COLON]fmt)
       ORDER BY output_id DESC) WHERE ROWNUM = 1;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Output not found'); RETURN; END;
  OWA_UTIL.mime_header(NVL(l_mime,'application/octet-stream'), FALSE);
  HTP.p('Content-Disposition: attachment; filename="'||NVL(l_name,'report')||'"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

  def_template('runs/[COLON]id/retry');
  def_handler('runs/[COLON]id/retry', 'POST', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_code VARCHAR2(60); l_params CLOB; l_fmt VARCHAR2(40); l_run NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  BEGIN
    SELECT report_code, params_json, formats INTO l_code, l_params, l_fmt
      FROM dct_rpt_run WHERE run_id = [COLON]id;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Run not found'); RETURN; END;
  l_run := dct_rpt_pkg.enqueue(p_report_code=>l_code, p_params=>l_params,
                               p_trigger=>'ONDEMAND', p_requested_by=>l_user, p_formats=>l_fmt);
  COMMIT;
  OWA_UTIL.status_line(202, NULL, FALSE);
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('runId', l_run); APEX_JSON.write('status','QUEUED'); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

  -- ===========================================================================
  -- SCHEDULES  list / create / update / delete / sync
  -- ===========================================================================
  def_template('schedules/');
  def_handler('schedules/', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_rep  VARCHAR2(60) := [COLON]report;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR c IN (SELECT * FROM dct_rpt_schedule WHERE (l_rep IS NULL OR report_code=l_rep) ORDER BY report_code, schedule_id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('scheduleId', c.schedule_id);
    APEX_JSON.write('reportCode', c.report_code);
    APEX_JSON.write('scheduleName', NVL(c.schedule_name,''));
    APEX_JSON.write('repeatInterval', c.repeat_interval);
    APEX_JSON.write('timezone', c.timezone);
    APEX_JSON.write('criteriaJson', NVL(c.criteria_json,''));
    APEX_JSON.write('enabled', c.enabled);
    APEX_JSON.write('lastRunAt', CASE WHEN c.last_run_at IS NULL THEN NULL ELSE TO_CHAR(dct_to_local(c.last_run_at),'YYYY-MM-DD HH:MI AM') END);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

  def_handler('schedules/', 'POST', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  INSERT INTO dct_rpt_schedule (report_code, schedule_name, repeat_interval, timezone, criteria_json, enabled, created_by, updated_by)
  VALUES (APEX_JSON.get_varchar2(p_path=>'reportCode'),
          APEX_JSON.get_varchar2(p_path=>'scheduleName'),
          APEX_JSON.get_varchar2(p_path=>'repeatInterval'),
          NVL(APEX_JSON.get_varchar2(p_path=>'timezone'),'Asia/Dubai'),
          APEX_JSON.get_clob(p_path=>'criteriaJson'),
          NVL(APEX_JSON.get_varchar2(p_path=>'enabled'),'Y'), l_user, l_user)
  RETURNING schedule_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('scheduleId', l_id); APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

  def_template('schedules/[COLON]id');
  def_handler('schedules/[COLON]id', 'PUT', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE dct_rpt_schedule SET
    schedule_name   = APEX_JSON.get_varchar2(p_path=>'scheduleName'),
    repeat_interval = NVL(APEX_JSON.get_varchar2(p_path=>'repeatInterval'), repeat_interval),
    timezone        = NVL(APEX_JSON.get_varchar2(p_path=>'timezone'), timezone),
    criteria_json   = APEX_JSON.get_clob(p_path=>'criteriaJson'),
    enabled         = NVL(APEX_JSON.get_varchar2(p_path=>'enabled'), enabled),
    updated_by      = l_user, updated_at = SYSTIMESTAMP
  WHERE schedule_id = [COLON]id;
  l_n := SQL%ROWCOUNT; COMMIT;
  IF l_n = 0 THEN dct_rest.err(404,'Schedule not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

  def_handler('schedules/[COLON]id', 'DELETE', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  DELETE FROM dct_rpt_schedule WHERE schedule_id = [COLON]id;
  l_n := SQL%ROWCOUNT; COMMIT;
  IF l_n = 0 THEN dct_rest.err(404,'Schedule not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

  def_template('schedules/sync');
  def_handler('schedules/sync', 'POST', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rpt_sched_sync;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

  -- ===========================================================================
  -- RECIPIENTS  list / create / update / delete
  -- ===========================================================================
  def_template('recipients/');
  def_handler('recipients/', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_rep  VARCHAR2(60) := [COLON]report;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR c IN (SELECT * FROM dct_rpt_recipient WHERE (l_rep IS NULL OR report_code=l_rep) ORDER BY report_code, recipient_id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('recipientId', c.recipient_id);
    APEX_JSON.write('reportCode', c.report_code);
    APEX_JSON.write('recipientType', c.recipient_type);
    APEX_JSON.write('recipientRef', NVL(c.recipient_ref,''));
    APEX_JSON.write('channel', c.channel);
    APEX_JSON.write('enabled', c.enabled);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

  def_handler('recipients/', 'POST', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  INSERT INTO dct_rpt_recipient (report_code, recipient_type, recipient_ref, channel, enabled, created_by, updated_by)
  VALUES (APEX_JSON.get_varchar2(p_path=>'reportCode'),
          APEX_JSON.get_varchar2(p_path=>'recipientType'),
          APEX_JSON.get_varchar2(p_path=>'recipientRef'),
          NVL(APEX_JSON.get_varchar2(p_path=>'channel'),'EMAIL'),
          NVL(APEX_JSON.get_varchar2(p_path=>'enabled'),'Y'), l_user, l_user)
  RETURNING recipient_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('recipientId', l_id); APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

  def_template('recipients/[COLON]id');
  def_handler('recipients/[COLON]id', 'PUT', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE dct_rpt_recipient SET
    recipient_type = NVL(APEX_JSON.get_varchar2(p_path=>'recipientType'), recipient_type),
    recipient_ref  = APEX_JSON.get_varchar2(p_path=>'recipientRef'),
    channel        = NVL(APEX_JSON.get_varchar2(p_path=>'channel'), channel),
    enabled        = NVL(APEX_JSON.get_varchar2(p_path=>'enabled'), enabled),
    updated_by     = l_user, updated_at = SYSTIMESTAMP
  WHERE recipient_id = [COLON]id;
  l_n := SQL%ROWCOUNT; COMMIT;
  IF l_n = 0 THEN dct_rest.err(404,'Recipient not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

  def_handler('recipients/[COLON]id', 'DELETE', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  DELETE FROM dct_rpt_recipient WHERE recipient_id = [COLON]id;
  l_n := SQL%ROWCOUNT; COMMIT;
  IF l_n = 0 THEN dct_rest.err(404,'Recipient not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

  -- ===========================================================================
  -- CONFIG  (UI runtime / SMTP editor; secret values never returned in clear)
  -- ===========================================================================
  def_template('config');
  def_handler('config', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR c IN (SELECT * FROM dct_rpt_config ORDER BY display_order, config_key) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('key', c.config_key);
    APEX_JSON.write('value', CASE WHEN c.is_secret='Y' THEN '' ELSE NVL(c.config_value,'') END);
    APEX_JSON.write('valueType', c.value_type);
    APEX_JSON.write('isSecret', c.is_secret);
    APEX_JSON.write('enumValues', NVL(c.enum_values,''));
    APEX_JSON.write('description', NVL(c.description,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

  def_handler('config', 'PUT', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_cnt  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_cnt := APEX_JSON.get_count(p_path=>'items');
  IF l_cnt IS NULL THEN dct_rest.err(400,'Body must be {"items":[{"key","value"}...]}'); RETURN; END IF;
  FOR i IN 1 .. l_cnt LOOP
    UPDATE dct_rpt_config
       SET config_value = APEX_JSON.get_varchar2(p_path=>'items[%d].value', p0=>i),
           updated_by   = l_user, updated_at = SYSTIMESTAMP
     WHERE config_key = APEX_JSON.get_varchar2(p_path=>'items[%d].key', p0=>i)
       AND is_secret = 'N';
  END LOOP;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

  COMMIT;
END;
/
SHOW ERRORS PROCEDURE admin.setup_rpt_ords_tmp

BEGIN
  admin.setup_rpt_ords_tmp;
  COMMIT;
END;
/
DROP PROCEDURE admin.setup_rpt_ords_tmp;

PROMPT ============================================================
PROMPT  04_rpt_ords.sql complete -- module rpt.rest at /ords/admin/rpt/
PROMPT  reports* runs* schedules* recipients* config meta
PROMPT ============================================================
