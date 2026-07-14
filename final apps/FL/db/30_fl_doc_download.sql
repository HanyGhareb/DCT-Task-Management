-- =============================================================================
-- Freelancers Module (App 203) -- Document list: expose the file attributes
-- File    : 30_fl_doc_download.sql
-- Schema  : registered under ADMIN. Base /ords/admin/fl/.
-- Run     : sql -name prod_mcp @30_fl_doc_download.sql   (ANY session -- this
--           REDEFINES one existing handler on fl.rest via DEFINE_HANDLER; it
--           creates no synonyms and does not rebuild the module, so it is safe
--           to run standalone and safe to re-run. Re-run after any
--           08_fl_ords.sql re-run, which rebuilds the base module.)
-- Purpose : GET /fl/documents/  now returns fileSize + hasFile per row, so the
--           UI can offer View / Download only for rows that actually carry
--           bytes. The file itself already streams from the existing media
--           handler GET /fl/documents/:id/file (defined in 08) -- unchanged.
--           Same contract the registration-documents list has used since 08.
-- Source  : synced into 08_fl_ords.sql (def_handler 'documents/', GET).
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

BEGIN
  ORDS.DEFINE_HANDLER(
    p_module_name => 'fl.rest',
    p_pattern     => 'documents/',
    p_method      => 'GET',
    p_source_type => ORDS.source_type_plsql,
    p_source      => REPLACE(q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_limit  NUMBER        := LEAST(NVL(TO_NUMBER([COLON]limit DEFAULT NULL ON CONVERSION ERROR), 50), 200);
  l_offset NUMBER        := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_frl    NUMBER        := TO_NUMBER([COLON]freelancerId DEFAULT NULL ON CONVERSION ERROR);
  l_exp    VARCHAR2(20)  := UPPER([COLON]expiryStatus);
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT COUNT(*) INTO l_total FROM dct_fl_document_v d
  WHERE d.status = 'ACTIVE'
    AND (l_frl IS NULL OR d.freelancer_id = l_frl)
    AND (l_exp IS NULL OR d.expiry_status = l_exp);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total', l_total); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT * FROM dct_fl_document_v d
    WHERE d.status = 'ACTIVE'
      AND (l_frl IS NULL OR d.freelancer_id = l_frl)
      AND (l_exp IS NULL OR d.expiry_status = l_exp)
    ORDER BY NVL(d.expiry_date, DATE '9999-12-31'), d.document_id
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('documentId',    r.document_id);
    APEX_JSON.write('freelancerId',  r.freelancer_id);
    APEX_JSON.write('freelancerName',NVL(r.freelancer_name, '-'));
    APEX_JSON.write('sourceType',    r.source_type);
    APEX_JSON.write('docTypeId',     r.document_type_id);
    APEX_JSON.write('docTypeName',   NVL(r.document_type_name, '-'));
    APEX_JSON.write('documentName',  r.document_name);
    APEX_JSON.write('mimeType',      NVL(r.file_mime_type, ''));
    APEX_JSON.write('fileSize',      NVL(r.file_size, 0));
    APEX_JSON.write('hasFile',       CASE WHEN NVL(r.file_size, 0) > 0 THEN 'Y' ELSE 'N' END);
    APEX_JSON.write('expiryDate',    TO_CHAR( dct_to_local(r.expiry_date), 'YYYY-MM-DD'));
    APEX_JSON.write('expiryStatus',  r.expiry_status);
    APEX_JSON.write('daysToExpiry',  r.days_to_expiry);
    APEX_JSON.write('isRequired',    r.is_required);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!', '[COLON]', CHR(58)));
  COMMIT;
END;
/

PROMPT === 30_fl_doc_download.sql complete ===
