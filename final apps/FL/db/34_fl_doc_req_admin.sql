-- =============================================================================
-- Freelancers Module (App 203) -- Document requirements: full FL_ADMIN control
-- File    : 34_fl_doc_req_admin.sql
-- Schema  : registered under ADMIN. Base /ords/admin/fl/.
-- Run     : sql -name prod_mcp @34_fl_doc_req_admin.sql   (ANY session -- adds
--           NEW templates and REDEFINES two handlers on fl.rest; no synonyms, no
--           module rebuild. Safe to re-run. Re-run after any 08 or 15 re-run.)
-- Purpose : The document checklists (registration + contract) are data, not code:
--           DCT_DOC_REQUIREMENTS holds one row per (context, document type) with
--             is_mandatory  Y = required   / N = optional
--             is_active     Y = shown on the checklist / N = hidden entirely
--           Until now FL_ADMIN could only flip is_mandatory, and only for the
--           REGISTRATION context (Module Settings). This exposes BOTH switches for
--           BOTH contexts, plus add / remove of a document type:
--             GET    doc-requirements/?context=&all=Y   (all=Y -> include hidden)
--             PUT    doc-requirements/:id   {isMandatory?, isActive?, displaySeq?}
--                    partial PUT: only the keys present are written (the standard
--                    "guard clearable columns with does_exist" rule)
--             POST   doc-requirements/     {contextCode, docTypeId, isMandatory?,
--                                           displaySeq?}  -> add, or REACTIVATE a
--                    previously hidden row (uq_dct_doc_req = module+context+type)
--             GET    doc-types/            catalogue for the "add document" picker
--           FL_ADMIN or SYS_ADMIN for every write.
-- Source  : GET/PUT doc-requirements synced into 08_fl_ords.sql / 15_fl_reg_ords.sql.
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

CREATE OR REPLACE PROCEDURE setup_fl_docreq_admin_tmp AS
    c_mod CONSTANT VARCHAR2(30) := 'fl.rest';

    PROCEDURE deft(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    EXCEPTION WHEN OTHERS THEN NULL;   -- template may already exist
    END;

    PROCEDURE defh(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method => p_method, p_source_type => ORDS.source_type_plsql,
            p_source => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN
    -- ---------- list requirements (optionally including hidden ones) --------
    deft('doc-requirements/');
    defh('doc-requirements/', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_ctx  VARCHAR2(50)  := UPPER([COLON]context);
  l_all  VARCHAR2(1)   := UPPER(NVL([COLON]all, 'N'));
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT dr.doc_req_id, dr.doc_type_id, dr.context_code, dr.is_mandatory,
           dr.is_active, dr.display_seq,
           dt.doc_type_code, dt.doc_type_name_en, dt.doc_type_name_ar
    FROM   dct_doc_requirements dr
    JOIN   dct_document_types   dt ON dt.doc_type_id = dr.doc_type_id
    WHERE  dr.source_module = 'FL'
    AND    (l_all = 'Y' OR dr.is_active = 'Y')
    AND    (l_ctx IS NULL OR dr.context_code = l_ctx)
    ORDER BY dr.context_code, dr.display_seq
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('docReqId',      r.doc_req_id);
    APEX_JSON.write('docTypeId',     r.doc_type_id);
    APEX_JSON.write('contextCode',   r.context_code);
    APEX_JSON.write('docTypeCode',   r.doc_type_code);
    APEX_JSON.write('docTypeName',   r.doc_type_name_en);
    APEX_JSON.write('docTypeNameAr', NVL(r.doc_type_name_ar, r.doc_type_name_en));
    APEX_JSON.write('isMandatory',   r.is_mandatory);
    APEX_JSON.write('isActive',      r.is_active);
    APEX_JSON.write('displaySeq',    NVL(r.display_seq, 0));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    -- ---------- partial update: required / visible / order -------------------
    defh('doc-requirements/[COLON]id', 'PUT', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
  l_mand VARCHAR2(1);
  l_act  VARCHAR2(1);
  l_seq  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'FL_ADMIN') AND NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN
    dct_rest.err(403,'Only FL Admin can change document requirements'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);

  -- partial PUT: a key that is absent must not overwrite the stored value
  IF APEX_JSON.does_exist(p_path => 'isMandatory') THEN
    l_mand := UPPER(APEX_JSON.get_varchar2(p_path=>'isMandatory'));
    IF l_mand NOT IN ('Y','N') THEN dct_rest.err(400,'isMandatory must be Y or N'); RETURN; END IF;
  END IF;
  IF APEX_JSON.does_exist(p_path => 'isActive') THEN
    l_act := UPPER(APEX_JSON.get_varchar2(p_path=>'isActive'));
    IF l_act NOT IN ('Y','N') THEN dct_rest.err(400,'isActive must be Y or N'); RETURN; END IF;
  END IF;
  IF APEX_JSON.does_exist(p_path => 'displaySeq') THEN
    l_seq := APEX_JSON.get_number(p_path=>'displaySeq');
  END IF;

  UPDATE dct_doc_requirements
  SET    is_mandatory = NVL(l_mand, is_mandatory),
         is_active    = NVL(l_act,  is_active),
         display_seq  = NVL(l_seq,  display_seq),
         updated_by   = l_uid,
         updated_at   = SYSTIMESTAMP
  WHERE  doc_req_id = [COLON]id AND source_module = 'FL';
  IF SQL%ROWCOUNT = 0 THEN ROLLBACK; dct_rest.err(404,'Requirement not found'); RETURN; END IF;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    -- ---------- add a document type to a context (or un-hide it) -------------
    defh('doc-requirements/', 'POST', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
  l_ctx  VARCHAR2(50);
  l_dt   NUMBER;
  l_mand VARCHAR2(1);
  l_seq  NUMBER;
  l_id   NUMBER;
  l_cnt  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'FL_ADMIN') AND NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN
    dct_rest.err(403,'Only FL Admin can change document requirements'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);
  l_ctx  := UPPER(APEX_JSON.get_varchar2(p_path => 'contextCode'));
  l_dt   := APEX_JSON.get_number(p_path   => 'docTypeId');
  l_mand := UPPER(NVL(APEX_JSON.get_varchar2(p_path => 'isMandatory'), 'Y'));
  l_seq  := APEX_JSON.get_number(p_path   => 'displaySeq');

  IF l_ctx NOT IN ('REGISTRATION','CONTRACT') THEN
    dct_rest.err(400,'contextCode must be REGISTRATION or CONTRACT'); RETURN; END IF;
  IF l_dt IS NULL THEN dct_rest.err(400,'docTypeId is required'); RETURN; END IF;
  IF l_mand NOT IN ('Y','N') THEN dct_rest.err(400,'isMandatory must be Y or N'); RETURN; END IF;
  SELECT COUNT(*) INTO l_cnt FROM dct_document_types WHERE doc_type_id = l_dt;
  IF l_cnt = 0 THEN dct_rest.err(404,'Document type not found'); RETURN; END IF;

  IF l_seq IS NULL THEN
    SELECT NVL(MAX(display_seq), 0) + 10 INTO l_seq
    FROM   dct_doc_requirements
    WHERE  source_module = 'FL' AND context_code = l_ctx;
  END IF;

  -- uq_dct_doc_req (source_module, context_code, doc_type_id): a type that was
  -- hidden earlier is re-activated rather than duplicated.
  BEGIN
    SELECT doc_req_id INTO l_id FROM dct_doc_requirements
    WHERE  source_module = 'FL' AND context_code = l_ctx AND doc_type_id = l_dt;
    UPDATE dct_doc_requirements
    SET    is_active = 'Y', is_mandatory = l_mand, display_seq = l_seq,
           updated_by = l_uid, updated_at = SYSTIMESTAMP
    WHERE  doc_req_id = l_id;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    INSERT INTO dct_doc_requirements (
      source_module, context_code, doc_type_id, is_mandatory, display_seq,
      is_active, created_by, created_at)
    VALUES ('FL', l_ctx, l_dt, l_mand, l_seq, 'Y', l_uid, SYSTIMESTAMP)
    RETURNING doc_req_id INTO l_id;
  END;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('docReqId', l_id); APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    -- ---------- document-type catalogue (for the add picker) ----------------
    deft('doc-types/');
    defh('doc-types/', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT doc_type_id, doc_type_code, doc_type_name_en, doc_type_name_ar
            FROM   dct_document_types
            ORDER BY doc_type_name_en) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('docTypeId',     r.doc_type_id);
    APEX_JSON.write('code',          r.doc_type_code);
    APEX_JSON.write('name',          r.doc_type_name_en);
    APEX_JSON.write('nameAr',        NVL(r.doc_type_name_ar, r.doc_type_name_en));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

END setup_fl_docreq_admin_tmp;
/

BEGIN
    setup_fl_docreq_admin_tmp;
    COMMIT;
END;
/

DROP PROCEDURE setup_fl_docreq_admin_tmp;

PROMPT === 34_fl_doc_req_admin.sql complete ===
