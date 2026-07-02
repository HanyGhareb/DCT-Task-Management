-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 08b params-aware run handler (ADMIN)
-- File   : reporting/db/08b_rpt_butil_run_handler.sql (invoked by 08_rpt_butil_sector.sql)
-- Zero blank lines inside statements -- see 08a header.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 2. Run handler upgrade: POST /rpt/reports/:code/run accepts a params body ===
BEGIN
  ORDS.DEFINE_HANDLER(
    p_module_name => 'rpt.rest',
    p_pattern     => 'reports/' || CHR(58) || 'code/run',
    p_method      => 'POST',
    p_source_type => ORDS.source_type_plsql,
    p_source      => REPLACE(q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_body   BLOB := [COLON]body;
  l_fmt    VARCHAR2(40) := [COLON]formats;
  l_params CLOB;
  l_ok     NUMBER;
  l_run    NUMBER;
  l_doff   INTEGER := 1; l_soff INTEGER := 1; l_lang INTEGER := 0; l_warn INTEGER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  IF l_body IS NOT NULL AND DBMS_LOB.GETLENGTH(l_body) > 2 THEN
    DBMS_LOB.CREATETEMPORARY(l_params, TRUE);
    DBMS_LOB.CONVERTTOCLOB(l_params, l_body, DBMS_LOB.LOBMAXSIZE, l_doff, l_soff,
                           DBMS_LOB.DEFAULT_CSID, l_lang, l_warn);
    SELECT COUNT(*) INTO l_ok FROM dual WHERE l_params IS JSON;
    IF l_ok = 0 THEN dct_rest.err(400,'Body must be a JSON object of run parameters'); RETURN; END IF;
  END IF;
  l_run := dct_rpt_pkg.enqueue(
             p_report_code  => [COLON]code,
             p_params       => l_params,
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
!', '[COLON]', CHR(58)));
  COMMIT;
END;
/

PROMPT 08b_rpt_butil_run_handler.sql complete.
