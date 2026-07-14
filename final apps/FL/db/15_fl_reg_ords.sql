-- =============================================================================
-- Freelancers Module (App 203) -- Phase 1 -- ORDS endpoints (additive)
-- File    : 15_fl_reg_ords.sql
-- Schema  : registered under ADMIN. Base /ords/admin/fl/.
-- Run     : sql -name prod_mcp @15_fl_reg_ords.sql  (FRESH session -- creates
--           synonyms; must NOT follow an ALTER SESSION SET CURRENT_SCHEMA).
-- Purpose : Adds the Phase-1 registration endpoints to the existing fl.rest
--           module WITHOUT rebuilding it:
--             AUTH (staff):
--               POST registrations/:id/documents/:docId/extract  -> AI extract
--               GET  registrations/:id/duplicates                -> dup matches
--               POST registrations/:id/duplicate-override        -> FL_ADMIN
--               GET  users/lookup?email=                         -> resolve user
--             PUBLIC (token-gated, gate = FEATURE_FL_PORTAL or ALLOW_SELF_REGISTRATION):
--               POST reg/public/start            {email}
--               POST reg/public/verify           {email,code}      -> intakeToken
--               GET  reg/public/:token                              -> draft + email
--               PUT  reg/public/:token           {form fields}      -> create/update draft
--               POST reg/public/:token/documents {docTypeId,...}    -> doc row
--               PUT  reg/public/:token/documents/:docId/file        -> binary upload
--               POST reg/public/:token/documents/:docId/extract     -> AI extract
--               POST reg/public/:token/submit                       -> submit for approval
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

-- 1. Synonyms for the new Phase-1 objects --------------------------------------
CREATE OR REPLACE SYNONYM dct_fl_ai_pkg     FOR prod.dct_fl_ai_pkg;
CREATE OR REPLACE SYNONYM dct_fl_reg_pkg    FOR prod.dct_fl_reg_pkg;
CREATE OR REPLACE SYNONYM dct_fl_doc_extracts FOR prod.dct_fl_doc_extracts;
CREATE OR REPLACE SYNONYM dct_fl_reg_otp    FOR prod.dct_fl_reg_otp;

-- 2. System service user for SELF-channel submissions (instance.submitted_by
--    FK requires a real dct_users row; applicants are not DCT users).
MERGE INTO prod.dct_users u
USING (SELECT 'fl.selfservice' AS username FROM dual) s
ON    (u.username = s.username)
WHEN NOT MATCHED THEN
    INSERT (username, email, display_name, first_name, last_name,
            auth_method, is_active, is_external, created_by, created_at, updated_by, updated_at)
    VALUES ('fl.selfservice', 'no-reply@dct.gov.ae', 'Freelancer Self-Service',
            'Freelancer', 'Self-Service', 'DB', 'Y', 'Y',
            'SYSTEM', SYSTIMESTAMP, 'SYSTEM', SYSTIMESTAMP);

-- 3. Handlers ------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE setup_fl_reg_ords_tmp AS
    c_mod CONSTANT VARCHAR2(30) := 'fl.rest';

    PROCEDURE deft(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    EXCEPTION WHEN OTHERS THEN NULL;  -- template may already exist
    END;

    PROCEDURE defh(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method => p_method, p_source_type => ORDS.source_type_plsql,
            p_source => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN
    -- ===================== AUTH: AI extract on a reg document ================
    deft('registrations/[COLON]id/documents/[COLON]docId/extract');
    defh('registrations/[COLON]id/documents/[COLON]docId/extract', 'POST', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
  l_out  CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  l_out := dct_fl_ai_pkg.extract_document([COLON]id, [COLON]docId, l_uid);
  dct_rest.json_header;
  FOR i IN 0 .. TRUNC((DBMS_LOB.GETLENGTH(l_out)-1)/8000) LOOP
    HTP.PRN(DBMS_LOB.SUBSTR(l_out, 8000, i*8000+1));
  END LOOP;
EXCEPTION WHEN OTHERS THEN
  dct_rest.err(CASE SQLCODE WHEN -20401 THEN 401 WHEN -20403 THEN 403
    WHEN -20404 THEN 404 WHEN -20001 THEN 400 WHEN -20002 THEN 502
    WHEN -20003 THEN 413 WHEN -20004 THEN 400 ELSE 500 END, SQLERRM);
END;
]');

    -- ===================== AUTH: duplicates list ============================
    deft('registrations/[COLON]id/duplicates');
    defh('registrations/[COLON]id/duplicates', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_out  CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_out := dct_fl_reg_pkg.find_duplicates([COLON]id);
  dct_rest.json_header;
  FOR i IN 0 .. TRUNC((DBMS_LOB.GETLENGTH(l_out)-1)/8000) LOOP
    HTP.PRN(DBMS_LOB.SUBSTR(l_out, 8000, i*8000+1));
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    -- ===================== AUTH: FL_ADMIN duplicate override =================
    deft('registrations/[COLON]id/duplicate-override');
    defh('registrations/[COLON]id/duplicate-override', 'POST', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'FL_ADMIN') THEN
    dct_rest.err(403,'Only an FL administrator can override a duplicate.'); RETURN;
  END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_fl_reg_pkg.add_duplicate_override([COLON]id, l_uid);
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  dct_rest.err(CASE SQLCODE WHEN -20404 THEN 404 ELSE 500 END, SQLERRM);
END;
]');

    -- ===================== AUTH: resolve a DCT user by email ================
    deft('users/lookup');
    defh('users/lookup', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER; l_name VARCHAR2(200); l_email VARCHAR2(200);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  BEGIN
    SELECT user_id, display_name, email INTO l_id, l_name, l_email
    FROM dct_users WHERE LOWER(email) = LOWER([COLON]email) AND is_active='Y'
    FETCH FIRST 1 ROW ONLY;
    APEX_JSON.write('found', TRUE);
    APEX_JSON.write('userId', l_id);
    APEX_JSON.write('name', l_name);
    APEX_JSON.write('email', l_email);
  EXCEPTION WHEN NO_DATA_FOUND THEN
    APEX_JSON.write('found', FALSE);
  END;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    -- ===================== PUBLIC: start (send OTP) =========================
    deft('reg/public/start');
    defh('reg/public/start', 'POST', q'[
DECLARE
  l_email VARCHAR2(200);
  l_dev   VARCHAR2(10);
BEGIN
  IF NVL(dct_fl_pkg.get_setting('FEATURE_FL_PORTAL'),'N') != 'Y'
     AND NVL(dct_fl_pkg.get_setting('ALLOW_SELF_REGISTRATION'),'N') != 'Y' THEN
    dct_rest.err(403,'Self-registration is not enabled.'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_email := APEX_JSON.get_varchar2(p_path => 'email');
  dct_fl_reg_pkg.start_public_registration(l_email, l_dev);
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  IF l_dev IS NOT NULL THEN APEX_JSON.write('devCode', l_dev); END IF;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  dct_rest.err(CASE SQLCODE WHEN -20001 THEN 400 ELSE 500 END, SQLERRM);
END;
]');

    -- ===================== PUBLIC: verify OTP -> intake token ===============
    deft('reg/public/verify');
    defh('reg/public/verify', 'POST', q'[
DECLARE
  l_email VARCHAR2(200); l_code VARCHAR2(10); l_token VARCHAR2(64);
BEGIN
  dct_rest.parse_body([COLON]body);
  l_email := APEX_JSON.get_varchar2(p_path => 'email');
  l_code  := APEX_JSON.get_varchar2(p_path => 'code');
  l_token := dct_fl_reg_pkg.verify_public_otp(l_email, l_code);
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('intakeToken', l_token);
  APEX_JSON.write('aiEnabled', NVL(dct_fl_pkg.get_setting('AI_FEATURES_ENABLED'),'N')='Y');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  dct_rest.err(CASE SQLCODE WHEN -20001 THEN 400 ELSE 500 END, SQLERRM);
END;
]');

    -- ===================== PUBLIC: nationality options ======================
    deft('reg/public/nationalities');
    defh('reg/public/nationalities', 'GET', q'[
BEGIN
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT nationality_code code, nationality_en name FROM dct_nationality ORDER BY nationality_en) LOOP
    APEX_JSON.open_object; APEX_JSON.write('code', r.code); APEX_JSON.write('name', r.name); APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    -- ===================== PUBLIC: get draft (by token) =====================
    deft('reg/public/[COLON]token');
    defh('reg/public/[COLON]token', 'GET', q'[
DECLARE
  l_email VARCHAR2(200) := dct_fl_reg_pkg.public_email([COLON]token);
  l_rid   NUMBER;
BEGIN
  IF l_email IS NULL THEN dct_rest.err(401,'Invalid or expired session.'); RETURN; END IF;
  l_rid := dct_fl_reg_pkg.public_registration_id([COLON]token);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('email', l_email);
  APEX_JSON.write('registrationId', l_rid);
  APEX_JSON.write('aiEnabled', NVL(dct_fl_pkg.get_setting('AI_FEATURES_ENABLED'),'N')='Y');
  APEX_JSON.write('photoRequired', NVL(dct_fl_pkg.get_setting('PHOTO_REQUIRED'),'Y')='Y');
  APEX_JSON.write('docsRequiredForSubmit', NVL(dct_fl_pkg.get_setting('DOCS_REQUIRED_FOR_SUBMIT'),'Y')='Y');
  IF l_rid IS NOT NULL THEN
    FOR r IN (SELECT * FROM dct_fl_registrations WHERE registration_id = l_rid) LOOP
      APEX_JSON.write('firstNameEn', r.first_name_en);
      APEX_JSON.write('lastNameEn',  r.last_name_en);
      APEX_JSON.write('status',      r.status);
      APEX_JSON.write('dupStatus',   r.dup_status);
      APEX_JSON.write('hasPhoto',    (r.photo_blob IS NOT NULL));
    END LOOP;
  END IF;
  -- required/optional document checklist (admin-configurable via doc-requirements)
  APEX_JSON.open_array('docRequirements');
  FOR dr IN (
    SELECT dt.doc_type_code, dt.doc_type_name_en, dt.doc_type_name_ar, r2.is_mandatory
    FROM   dct_doc_requirements r2
    JOIN   dct_document_types   dt ON dt.doc_type_id = r2.doc_type_id
    WHERE  r2.source_module='FL' AND r2.context_code='REGISTRATION' AND r2.is_active='Y'
    ORDER BY r2.display_seq
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code',      dr.doc_type_code);
    APEX_JSON.write('name',      dr.doc_type_name_en);
    APEX_JSON.write('nameAr',    NVL(dr.doc_type_name_ar, dr.doc_type_name_en));
    APEX_JSON.write('mandatory', dr.is_mandatory='Y');
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    -- ===================== PUBLIC: create/update draft ======================
    defh('reg/public/[COLON]token', 'PUT', q'[
DECLARE
  l_email VARCHAR2(200) := dct_fl_reg_pkg.public_email([COLON]token);
  l_rid   NUMBER;
  l_sysid NUMBER;
  -- NOTE: a locally-declared function cannot be used inside SQL (PLS-00231);
  -- read every JSON field into a local first, then use the locals in the DML.
  l_fn  VARCHAR2(200); l_ln   VARCHAR2(200); l_fa  VARCHAR2(200); l_la   VARCHAR2(200);
  l_dob VARCHAR2(40);  l_nat  VARCHAR2(40);  l_nid VARCHAR2(100); l_pass VARCHAR2(100);
  l_mob VARCHAR2(60);  l_spec VARCHAR2(400); l_notes VARCHAR2(4000);
  l_bn  VARCHAR2(200); l_iban VARCHAR2(60);  l_ban VARCHAR2(200); l_bacc VARCHAR2(60);
  l_swift VARCHAR2(40); l_curr VARCHAR2(10);
  l_re  VARCHAR2(200); l_rn   VARCHAR2(200); l_lme VARCHAR2(200); l_lmn  VARCHAR2(200);
  FUNCTION g(p VARCHAR2) RETURN VARCHAR2 IS BEGIN RETURN APEX_JSON.get_varchar2(p_path => p); END;
BEGIN
  IF l_email IS NULL THEN dct_rest.err(401,'Invalid or expired session.'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_fn   := g('firstNameEn');  l_ln   := g('lastNameEn');
  l_fa   := g('firstNameAr');  l_la   := g('lastNameAr');
  l_dob  := g('dateOfBirth');  l_nat  := g('nationalityCode');
  l_nid  := g('nationalId');   l_pass := g('passportNumber');
  l_mob  := g('mobile');       l_spec := g('specialization');
  l_notes := g('notes');
  l_bn   := g('bankName');     l_iban := g('bankIban');
  l_ban  := g('bankAccountName'); l_bacc := g('bankAccountNumber');
  l_swift := g('bankSwift');   l_curr := NVL(g('bankCurrencyCode'),'AED');
  -- For self-registration the requestor is the applicant; never let a missing
  -- value wipe what the /draft endpoint seeded.
  l_re   := NVL(g('requestorEmail'), l_email);
  l_rn   := NVL(g('requestorName'), TRIM(l_fn||' '||l_ln));
  l_lme  := g('lineManagerEmail');  l_lmn := g('lineManagerName');
  IF l_fn IS NULL OR l_ln IS NULL OR l_dob IS NULL OR l_nat IS NULL THEN
    dct_rest.err(400,'First name, last name, date of birth and nationality are required.'); RETURN;
  END IF;
  SELECT user_id INTO l_sysid FROM dct_users WHERE username='fl.selfservice';
  l_rid := dct_fl_reg_pkg.public_registration_id([COLON]token);

  IF l_rid IS NULL THEN
    INSERT INTO dct_fl_registrations (
      registration_number, first_name_en, last_name_en, first_name_ar, last_name_ar,
      date_of_birth, nationality_code, national_id, passport_number, email, mobile,
      specialization, notes, bank_name, bank_iban, bank_account_name, bank_account_number,
      bank_swift, bank_currency_code, requestor_email, requestor_name,
      line_manager_email, line_manager_name, email_verified, submitted_by,
      submitted_by_user_id, status, created_by)
    VALUES (
      'FL-REG-' || TO_CHAR(seq_fl_reg_number.NEXTVAL),
      l_fn, l_ln, l_fa, l_la,
      TO_DATE(l_dob,'YYYY-MM-DD'), l_nat, l_nid,
      l_pass, l_email, l_mob, l_spec, l_notes,
      l_bn, l_iban, l_ban, l_bacc,
      l_swift, l_curr,
      l_re, l_rn, l_lme, l_lmn,
      'Y', 'SELF', l_sysid, 'DRAFT', 'fl.selfservice')
    RETURNING registration_id INTO l_rid;
    dct_fl_reg_pkg.set_public_registration([COLON]token, l_rid);
  ELSE
    UPDATE dct_fl_registrations SET
      first_name_en=l_fn, last_name_en=l_ln,
      first_name_ar=l_fa, last_name_ar=l_la,
      date_of_birth=TO_DATE(l_dob,'YYYY-MM-DD'),
      nationality_code=l_nat, national_id=l_nid,
      passport_number=l_pass, mobile=l_mob,
      specialization=l_spec, notes=l_notes, bank_name=l_bn,
      bank_iban=l_iban, bank_account_name=l_ban,
      bank_account_number=l_bacc, bank_swift=l_swift,
      bank_currency_code=l_curr,
      requestor_email=l_re, requestor_name=l_rn,
      line_manager_email=l_lme, line_manager_name=l_lmn,
      updated_by='fl.selfservice', updated_at=SYSTIMESTAMP
    WHERE registration_id=l_rid AND status IN ('DRAFT','RETURNED');
  END IF;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('registrationId', l_rid); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    -- ============ PUBLIC: ensure an empty draft (documents-first) ============
    -- Lets the applicant upload documents (which need a registration_id) right
    -- after OTP, before typing any details. Identity columns are nullable for a
    -- DRAFT (db/17); the detail PUT + submit_registration still enforce them.
    deft('reg/public/[COLON]token/draft');
    defh('reg/public/[COLON]token/draft', 'POST', q'[
DECLARE
  l_email VARCHAR2(200) := dct_fl_reg_pkg.public_email([COLON]token);
  l_rid   NUMBER;
  l_sysid NUMBER;
BEGIN
  IF l_email IS NULL THEN dct_rest.err(401,'Invalid or expired session.'); RETURN; END IF;
  l_rid := dct_fl_reg_pkg.public_registration_id([COLON]token);
  IF l_rid IS NULL THEN
    SELECT user_id INTO l_sysid FROM dct_users WHERE username='fl.selfservice';
    INSERT INTO dct_fl_registrations (
      registration_number, email, requestor_email, email_verified, submitted_by,
      submitted_by_user_id, status, created_by)
    VALUES ('FL-REG-' || TO_CHAR(seq_fl_reg_number.NEXTVAL), l_email, l_email, 'Y', 'SELF',
            l_sysid, 'DRAFT', 'fl.selfservice')
    RETURNING registration_id INTO l_rid;
    dct_fl_reg_pkg.set_public_registration([COLON]token, l_rid);
    COMMIT;
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('registrationId', l_rid); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    -- ===================== PUBLIC: create a document row ====================
    deft('reg/public/[COLON]token/documents');
    defh('reg/public/[COLON]token/documents', 'POST', q'[
DECLARE
  l_email VARCHAR2(200) := dct_fl_reg_pkg.public_email([COLON]token);
  l_rid NUMBER; l_id NUMBER; l_sysid NUMBER; l_dtid NUMBER;
BEGIN
  IF l_email IS NULL THEN dct_rest.err(401,'Invalid or expired session.'); RETURN; END IF;
  l_rid := dct_fl_reg_pkg.public_registration_id([COLON]token);
  IF l_rid IS NULL THEN dct_rest.err(400,'Save your details before uploading documents.'); RETURN; END IF;
  SELECT user_id INTO l_sysid FROM dct_users WHERE username='fl.selfservice';
  dct_rest.parse_body([COLON]body);
  l_dtid := APEX_JSON.get_number(p_path=>'docTypeId');
  IF l_dtid IS NULL AND APEX_JSON.get_varchar2(p_path=>'docTypeCode') IS NOT NULL THEN
    BEGIN SELECT doc_type_id INTO l_dtid FROM dct_document_types
          WHERE doc_type_code = APEX_JSON.get_varchar2(p_path=>'docTypeCode');
    EXCEPTION WHEN NO_DATA_FOUND THEN l_dtid := NULL; END;
  END IF;
  IF l_dtid IS NULL THEN dct_rest.err(400,'Unknown document type.'); RETURN; END IF;
  INSERT INTO dct_documents (source_module, source_type, source_id, reference_id,
    doc_type_id, file_name, mime_type, status, is_required, is_active, created_by)
  VALUES ('FL','REGISTRATION', l_rid, l_rid,
    l_dtid,
    NVL(APEX_JSON.get_varchar2(p_path=>'documentName'),'document'),
    APEX_JSON.get_varchar2(p_path=>'mimeType'),
    'ACTIVE', NVL(APEX_JSON.get_varchar2(p_path=>'isRequired'),'N'), 'Y', l_sysid)
  RETURNING doc_id INTO l_id;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('documentId', l_id); APEX_JSON.write('ok',TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    -- ===================== PUBLIC: upload document bytes ====================
    deft('reg/public/[COLON]token/documents/[COLON]docId/file');
    defh('reg/public/[COLON]token/documents/[COLON]docId/file', 'PUT', q'[
DECLARE
  v_blob BLOB := [COLON]body;     -- deref ONCE
  l_email VARCHAR2(200);
  l_rid NUMBER; v_len NUMBER; v_max NUMBER;
BEGIN
  l_email := dct_fl_reg_pkg.public_email([COLON]token);
  IF l_email IS NULL THEN dct_rest.err(401,'Invalid or expired session.'); RETURN; END IF;
  l_rid := dct_fl_reg_pkg.public_registration_id([COLON]token);
  IF v_blob IS NULL OR DBMS_LOB.GETLENGTH(v_blob)=0 THEN
    dct_rest.err(400,'Request body (file bytes) is required'); RETURN; END IF;
  v_len := DBMS_LOB.GETLENGTH(v_blob);
  v_max := NVL(TO_NUMBER(dct_fl_pkg.get_setting('MAX_UPLOAD_MB') DEFAULT NULL ON CONVERSION ERROR),10);
  IF v_len > v_max*1024*1024 THEN
    dct_rest.err(413,'File exceeds the maximum upload size of '||v_max||' MB'); RETURN; END IF;
  UPDATE dct_documents SET file_blob=v_blob,
    file_name=NVL([COLON]file_name,file_name), mime_type=NVL([COLON]mime_type,mime_type),
    file_size_bytes=v_len, updated_at=SYSTIMESTAMP
  WHERE doc_id=[COLON]docId AND source_module='FL' AND source_id=l_rid;
  IF SQL%ROWCOUNT=0 THEN ROLLBACK; dct_rest.err(404,'Document not found'); RETURN; END IF;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok',TRUE); APEX_JSON.write('fileSize',v_len);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    -- ===================== PUBLIC: AI extract (applicant) ===================
    deft('reg/public/[COLON]token/documents/[COLON]docId/extract');
    defh('reg/public/[COLON]token/documents/[COLON]docId/extract', 'POST', q'[
DECLARE
  l_email VARCHAR2(200) := dct_fl_reg_pkg.public_email([COLON]token);
  l_rid NUMBER; l_out CLOB;
BEGIN
  IF l_email IS NULL THEN dct_rest.err(401,'Invalid or expired session.'); RETURN; END IF;
  l_rid := dct_fl_reg_pkg.public_registration_id([COLON]token);
  l_out := dct_fl_ai_pkg.extract_document(l_rid, [COLON]docId, NULL);
  dct_rest.json_header;
  FOR i IN 0 .. TRUNC((DBMS_LOB.GETLENGTH(l_out)-1)/8000) LOOP
    HTP.PRN(DBMS_LOB.SUBSTR(l_out, 8000, i*8000+1));
  END LOOP;
EXCEPTION WHEN OTHERS THEN
  dct_rest.err(CASE SQLCODE WHEN -20001 THEN 400 WHEN -20002 THEN 502
    WHEN -20003 THEN 413 WHEN -20004 THEN 400 ELSE 500 END, SQLERRM);
END;
]');

    -- ===================== PUBLIC: submit for approval ======================
    deft('reg/public/[COLON]token/submit');
    defh('reg/public/[COLON]token/submit', 'POST', q'[
DECLARE
  l_email VARCHAR2(200) := dct_fl_reg_pkg.public_email([COLON]token);
  l_rid NUMBER; l_sysid NUMBER;
BEGIN
  IF l_email IS NULL THEN dct_rest.err(401,'Invalid or expired session.'); RETURN; END IF;
  l_rid := dct_fl_reg_pkg.public_registration_id([COLON]token);
  IF l_rid IS NULL THEN dct_rest.err(400,'Nothing to submit.'); RETURN; END IF;
  SELECT user_id INTO l_sysid FROM dct_users WHERE username='fl.selfservice';
  dct_fl_pkg.submit_registration(l_rid, l_sysid);
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok',TRUE); APEX_JSON.write('registrationId',l_rid);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  -- -20001 = duplicate block. A public applicant can't do an admin override, so
  -- give them self-service guidance to go back and reset/correct their details.
  IF SQLCODE = -20001 THEN
    dct_rest.err(400, 'These details match a registration that already exists (same Emirates ID, passport, email or IBAN). Please go back and reset or correct your details, then try again. If you have already registered before, you do not need to register again - please contact the Finance team for help.');
  ELSE
    dct_rest.err(CASE SQLCODE WHEN -20130 THEN 400 WHEN -20131 THEN 400
      WHEN -20132 THEN 400 WHEN -20133 THEN 400 WHEN -20134 THEN 400 WHEN -20135 THEN 400
      WHEN -20136 THEN 400 WHEN -20137 THEN 400 WHEN -20138 THEN 400 WHEN -20139 THEN 400
      WHEN -20140 THEN 400 WHEN -20141 THEN 400 WHEN -20142 THEN 400
      WHEN -20148 THEN 400 ELSE 500 END, SQLERRM);
  END IF;
END;
]');

    -- ===================== PUBLIC: upload personal photo ====================
    -- Raw-binary photo -> DCT_FL_REGISTRATIONS.photo_blob (mirrors the staff
    -- registrations/:id/photo, but token-gated for the self-service applicant).
    deft('reg/public/[COLON]token/photo');
    defh('reg/public/[COLON]token/photo', 'PUT', q'[
DECLARE
  v_blob BLOB := [COLON]body;     -- deref ONCE
  l_email VARCHAR2(200);
  l_rid NUMBER; v_len NUMBER; v_max NUMBER;
BEGIN
  l_email := dct_fl_reg_pkg.public_email([COLON]token);
  IF l_email IS NULL THEN dct_rest.err(401,'Invalid or expired session.'); RETURN; END IF;
  l_rid := dct_fl_reg_pkg.public_registration_id([COLON]token);
  IF l_rid IS NULL THEN dct_rest.err(400,'Save your details before uploading a photo.'); RETURN; END IF;
  IF v_blob IS NULL OR DBMS_LOB.GETLENGTH(v_blob)=0 THEN
    dct_rest.err(400,'Request body (photo bytes) is required'); RETURN; END IF;
  v_len := DBMS_LOB.GETLENGTH(v_blob);
  v_max := NVL(TO_NUMBER(dct_fl_pkg.get_setting('MAX_UPLOAD_MB') DEFAULT NULL ON CONVERSION ERROR),10);
  IF v_len > v_max*1024*1024 THEN
    dct_rest.err(413,'Photo exceeds the maximum upload size of '||v_max||' MB'); RETURN; END IF;
  UPDATE dct_fl_registrations SET photo_blob=v_blob,
    photo_mime_type=NVL([COLON]mime_type,'image/jpeg'),
    photo_filename =NVL([COLON]file_name,'photo.jpg'),
    updated_by='fl.selfservice', updated_at=SYSTIMESTAMP
  WHERE registration_id=l_rid AND status IN ('DRAFT','RETURNED');
  IF SQL%ROWCOUNT=0 THEN ROLLBACK; dct_rest.err(404,'Registration not found or not editable'); RETURN; END IF;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok',TRUE); APEX_JSON.write('fileSize',v_len);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    -- =============== AUTH: FL_ADMIN edits a document requirement ============
    -- Toggle a registration document required <-> optional. The submit check in
    -- DCT_FL_PKG.submit_registration is already data-driven on is_mandatory.
    deft('doc-requirements/[COLON]id');
    defh('doc-requirements/[COLON]id', 'PUT', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_mand VARCHAR2(1);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'FL_ADMIN') AND NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN
    dct_rest.err(403,'Only FL Admin can change document requirements'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_mand := UPPER(NVL(APEX_JSON.get_varchar2(p_path=>'isMandatory'),'Y'));
  IF l_mand NOT IN ('Y','N') THEN dct_rest.err(400,'isMandatory must be Y or N'); RETURN; END IF;
  UPDATE dct_doc_requirements SET is_mandatory=l_mand
  WHERE doc_req_id=[COLON]id AND source_module='FL';
  IF SQL%ROWCOUNT=0 THEN ROLLBACK; dct_rest.err(404,'Requirement not found'); RETURN; END IF;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok',TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

END setup_fl_reg_ords_tmp;
/

BEGIN
    setup_fl_reg_ords_tmp;
    COMMIT;
END;
/

DROP PROCEDURE setup_fl_reg_ords_tmp;

PROMPT === 15_fl_reg_ords.sql complete ===
