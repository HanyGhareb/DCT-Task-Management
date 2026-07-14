-- =============================================================================
-- Freelancers Module (App 203) -- Contract Termsheet PDF bridge (ADDITIVE)
-- File    : 29_fl_termsheet_bridge.sql
-- Adds to : fl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp @29_fl_termsheet_bridge.sql (fresh session).
--           Re-run after any 08_fl_ords.sql re-run. Requires reporting/db/22
--           (FL_CONTRACT_TERMSHEET definition) + the fl_contract_termsheet.docx
--           template in DCT_RPT_TEMPLATE.
-- Purpose : runs the Legal Affairs termsheet PDF for a contract straight from
--           the FL app (the /rpt/ admin endpoints are SYS_ADMIN gated, so the
--           FL app talks to these thin FL-authed bridges instead; the run is
--           rendered by the PYTHON worker fleet). D3: the produced PDF can be
--           filed on the contract as a document (attach endpoint) -- i-Finance
--           is the system of record, no Mersal upload.
-- Endpoints:
--   POST /fl/contracts/:id/termsheet-pdf                -> {runId}
--   GET  /fl/contracts/:id/termsheet-pdf/:runId         -> {status, hasPdf,...}
--   GET  /fl/contracts/:id/termsheet-pdf/:runId/pdf     -> PDF download
--   POST /fl/contracts/:id/termsheet-pdf/:runId/attach  -> files the PDF into
--        dct_documents (source CONTRACT, doc type TERMSHEET) -- idempotent per run
-- Also seeds document type TERMSHEET (idempotent).
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === [1/2] TERMSHEET document type ===

DECLARE
    v_n NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_n FROM prod.dct_document_types WHERE doc_type_code = 'TERMSHEET';
    IF v_n = 0 THEN
        INSERT INTO prod.dct_document_types
            (doc_type_code, doc_type_name_en, doc_type_name_ar, doc_category,
             applies_to_modules, has_expiry, expiry_alert_days, display_order)
        VALUES
            ('TERMSHEET', 'Contract Termsheet (generated)',
             UNISTR('\0645\0644\062E\0635 \0627\0644\0639\0642\062F'),
             'LEGAL', 'FL', 'N', 30, 250);
        DBMS_OUTPUT.PUT_LINE('  added TERMSHEET doc type');
    ELSE
        DBMS_OUTPUT.PUT_LINE('  exists TERMSHEET doc type');
    END IF;
    COMMIT;
END;
/

PROMPT === [2/2] fl.rest termsheet bridge handlers ===

DECLARE
    c_mod CONSTANT VARCHAR2(30) := 'fl.rest';

    PROCEDURE deft(p_pattern VARCHAR2) IS
        v_n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_n
        FROM   user_ords_templates t
        JOIN   user_ords_modules  m ON m.id = t.module_id
        WHERE  m.name = c_mod
        AND    t.uri_template = REPLACE(p_pattern, '[COLON]', CHR(58));
        IF v_n = 0 THEN
            ORDS.DEFINE_TEMPLATE(p_module_name => c_mod,
                p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
        END IF;
    END;

    PROCEDURE defh(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method => p_method, p_source_type => ORDS.source_type_plsql,
            p_source => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN
    deft('contracts/[COLON]id/termsheet-pdf');
    defh('contracts/[COLON]id/termsheet-pdf', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n    NUMBER;
  l_run  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT COUNT(*) INTO l_n FROM dct_fl_contracts WHERE contract_id = [COLON]id;
  IF l_n = 0 THEN dct_rest.err(404,'Contract not found'); RETURN; END IF;
  l_run := dct_rpt_pkg.enqueue(p_report_code  => 'FL_CONTRACT_TERMSHEET',
                               p_params       => '{"contract_id":' || TO_NUMBER([COLON]id) || '}',
                               p_trigger      => 'ONDEMAND',
                               p_requested_by => l_user,
                               p_formats      => 'PDF');
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('runId', l_run);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE = -20404 THEN dct_rest.err(404, SQLERRM);
  ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!');

    deft('contracts/[COLON]id/termsheet-pdf/[COLON]runId');
    defh('contracts/[COLON]id/termsheet-pdf/[COLON]runId', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_pdf  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  FOR c IN (SELECT run_id, status, error_msg
              FROM dct_rpt_run
             WHERE run_id = [COLON]runId
               AND report_code = 'FL_CONTRACT_TERMSHEET') LOOP
    SELECT COUNT(*) INTO l_pdf
      FROM dct_rpt_output WHERE run_id = c.run_id AND format = 'PDF';
    dct_rest.json_header; APEX_JSON.initialize_output;
    APEX_JSON.open_object;
    APEX_JSON.write('runId', c.run_id);
    APEX_JSON.write('status', c.status);
    APEX_JSON.write('error', NVL(DBMS_LOB.SUBSTR(c.error_msg, 500, 1), ''));
    APEX_JSON.write('hasPdf', l_pdf > 0);
    APEX_JSON.close_object;
    RETURN;
  END LOOP;
  dct_rest.err(404,'Run not found');
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    deft('contracts/[COLON]id/termsheet-pdf/[COLON]runId/pdf');
    defh('contracts/[COLON]id/termsheet-pdf/[COLON]runId/pdf', 'GET', q'!
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
       WHERE o.run_id = [COLON]runId AND o.format = 'PDF'
         AND r.report_code = 'FL_CONTRACT_TERMSHEET'
       ORDER BY o.output_id DESC) o WHERE ROWNUM = 1;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'PDF not found'); RETURN; END;
  OWA_UTIL.mime_header('application/pdf', FALSE);
  HTP.p('Content-Disposition[COLON] attachment; filename="'||NVL(l_name,'termsheet.pdf')||'"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    deft('contracts/[COLON]id/termsheet-pdf/[COLON]runId/attach');
    defh('contracts/[COLON]id/termsheet-pdf/[COLON]runId/attach', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
  l_frl  NUMBER;
  l_blob BLOB; l_name VARCHAR2(260);
  l_type NUMBER;
  l_doc  NUMBER;
  l_mark VARCHAR2(100);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  BEGIN
    SELECT freelancer_id INTO l_frl FROM dct_fl_contracts WHERE contract_id = [COLON]id;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Contract not found'); RETURN; END;
  BEGIN
    SELECT o.file_blob, o.file_name INTO l_blob, l_name FROM (
      SELECT o.file_blob, o.file_name
        FROM dct_rpt_output o
        JOIN dct_rpt_run r ON r.run_id = o.run_id
       WHERE o.run_id = [COLON]runId AND o.format = 'PDF'
         AND r.report_code = 'FL_CONTRACT_TERMSHEET'
       ORDER BY o.output_id DESC) o WHERE ROWNUM = 1;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'PDF not found'); RETURN; END;
  SELECT doc_type_id INTO l_type FROM dct_document_types WHERE doc_type_code = 'TERMSHEET';
  l_mark := 'termsheet-run-' || [COLON]runId;
  SELECT MAX(doc_id) INTO l_doc FROM dct_documents
   WHERE source_module = 'FL' AND source_type = 'CONTRACT'
     AND source_id = [COLON]id AND notes = l_mark;
  IF l_doc IS NULL THEN
    INSERT INTO dct_documents (
      source_module, source_type, source_id, reference_id, doc_type_id,
      file_name, mime_type, file_size_bytes, file_blob,
      status, is_required, notes, is_active, created_by)
    VALUES (
      'FL', 'CONTRACT', [COLON]id, l_frl, l_type,
      NVL(l_name,'termsheet.pdf'), 'application/pdf', DBMS_LOB.getlength(l_blob), l_blob,
      'ACTIVE', 'N', l_mark, 'Y', l_uid)
    RETURNING doc_id INTO l_doc;
    COMMIT;
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('documentId', l_doc);
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('fl.rest termsheet bridge published (enqueue/status/pdf/attach).');
END;
/

PROMPT === 29_fl_termsheet_bridge.sql complete ===
