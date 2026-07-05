-- =============================================================================
-- Freelancers Module (App 203) -- Phase 1 -- Staff registration handler fix
-- File    : 23_fl_reg_staff_handlers.sql
-- Schema  : registered under ADMIN. Base /ords/admin/fl/.
-- Run     : sql -name prod_mcp @23_fl_reg_staff_handlers.sql  (any session --
--           redefines two existing handlers on fl.rest; no synonyms created,
--           no module rebuild).
-- Purpose : The staff registration create (POST registrations/) and update
--           (PUT registrations/:id) handlers in 08_fl_ords.sql predate the
--           Phase-1 fields, so they:
--             (a) did NOT persist requestor / line_manager / bank columns -- a
--                 staff-created registration lost its line manager, so
--                 SUBMIT_REGISTRATION later raised -20141 (no first approver);
--             (b) ran TO_DATE('') on an empty date_of_birth -> ORA-01841 -> 500,
--                 which blocked auto-saving a blank DRAFT (needed so a document
--                 or photo can be attached before the details are typed -- the
--                 documents-first / AI-first flow, matching the public Portal).
--           This redefines BOTH handlers to persist every Phase-1 field and to
--           tolerate blank identity fields on a DRAFT (guarded date parse; email
--           relaxed to NULL below). Required-field enforcement is unchanged:
--           SUBMIT_REGISTRATION still rejects an incomplete row.
--           Re-run after any 08_fl_ords.sql re-run (08 rebuilds the base module).
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

-- 1. Allow a DRAFT to be created before an email is entered (documents-first).
--    Idempotent -- only relaxes the column if it is still NOT NULL. SUBMIT still
--    requires a valid email (it becomes the freelancer's portal username).
DECLARE
    v_nullable VARCHAR2(1);
BEGIN
    SELECT nullable INTO v_nullable
    FROM   all_tab_columns
    WHERE  owner = 'PROD' AND table_name = 'DCT_FL_REGISTRATIONS'
    AND    column_name = 'EMAIL';
    IF v_nullable = 'N' THEN
        EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_fl_registrations MODIFY (email NULL)';
        DBMS_OUTPUT.PUT_LINE('EMAIL -> NULL');
    ELSE
        DBMS_OUTPUT.PUT_LINE('EMAIL already nullable');
    END IF;
END;
/

-- 2. Registration view -- expose the Phase-1 columns (requestor / line manager /
--    bank / dup_status) so the staff GET returns them, and LEFT JOIN nationality
--    so a documents-first DRAFT (no nationality yet) still appears in GET + list.
CREATE OR REPLACE VIEW prod.dct_fl_registration_v AS
SELECT
  r.registration_id,
  r.registration_number,
  r.first_name_en,
  r.last_name_en,
  r.first_name_en || ' ' || r.last_name_en    AS full_name_en,
  r.first_name_ar,
  r.last_name_ar,
  r.date_of_birth,
  r.nationality_code,
  n.nationality_en                             AS nationality_name,
  r.national_id,
  r.passport_number,
  r.email,
  r.mobile,
  r.specialization,
  r.first_deal_with_dct,
  r.requestor_email,
  r.requestor_name,
  r.line_manager_email,
  r.line_manager_name,
  r.bank_name,
  r.bank_iban,
  r.bank_account_name,
  r.bank_account_number,
  r.bank_swift,
  r.bank_currency_code,
  r.dup_status,
  r.submitted_by,
  r.submitted_by_user_id,
  su.display_name                              AS submitted_by_name,
  r.status,
  r.approval_instance_id,
  r.notes,
  r.created_by,
  cb.display_name                              AS created_by_name,
  r.created_at,
  r.updated_by,
  r.updated_at
FROM prod.dct_fl_registrations  r
LEFT JOIN prod.dct_nationality   n   ON n.nationality_code = r.nationality_code
LEFT JOIN prod.dct_users         su  ON su.user_id = r.submitted_by_user_id
LEFT JOIN prod.dct_users         cb  ON cb.username = r.created_by;

-- 3. Redefine the staff handlers -----------------------------------------------
CREATE OR REPLACE PROCEDURE setup_fl_reg_staff_tmp AS
    c_mod CONSTANT VARCHAR2(30) := 'fl.rest';

    -- IMPORTANT: this script deliberately does NOT call ORDS.DEFINE_TEMPLATE.
    -- On this ADB, DEFINE_TEMPLATE on an EXISTING template recreates it and DROPS
    -- the template's other handlers (it does not raise, so a guarded call is no
    -- protection). Both templates here (registrations/ and registrations/:id)
    -- already exist from 08_fl_ords.sql, so we only DEFINE_HANDLER, which replaces
    -- a single method and leaves the template + its sibling handlers intact.
    PROCEDURE defh(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method => p_method, p_source_type => ORDS.source_type_plsql,
            p_source => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN
    -- ===================== STAFF: list registrations ========================
    -- Restored verbatim from 08 (an earlier DEFINE_TEMPLATE call had dropped it).
    defh('registrations/', 'GET', q'[
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_limit  NUMBER        := LEAST(NVL(TO_NUMBER([COLON]limit DEFAULT NULL ON CONVERSION ERROR), 50), 200);
  l_offset NUMBER        := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_search VARCHAR2(200) := [COLON]search;
  l_status VARCHAR2(20)  := UPPER([COLON]status);
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT COUNT(*) INTO l_total FROM dct_fl_registration_v r
  WHERE (l_status IS NULL OR r.status = l_status)
    AND (l_search IS NULL OR UPPER(r.registration_number || ' ' || r.full_name_en || ' ' || r.email)
         LIKE '%' || UPPER(l_search) || '%');
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total', l_total); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT * FROM dct_fl_registration_v r
    WHERE (l_status IS NULL OR r.status = l_status)
      AND (l_search IS NULL OR UPPER(r.registration_number || ' ' || r.full_name_en || ' ' || r.email)
           LIKE '%' || UPPER(l_search) || '%')
    ORDER BY r.registration_id DESC
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('registrationId',   r.registration_id);
    APEX_JSON.write('registrationNumber', r.registration_number);
    APEX_JSON.write('fullNameEn',       r.full_name_en);
    APEX_JSON.write('nationality',      NVL(r.nationality_name, '-'));
    APEX_JSON.write('email',            r.email);
    APEX_JSON.write('mobile',           NVL(r.mobile, ''));
    APEX_JSON.write('specialization',   NVL(r.specialization, ''));
    APEX_JSON.write('status',           r.status);
    APEX_JSON.write('approvalInstanceId', r.approval_instance_id);
    APEX_JSON.write('createdAt',        TO_CHAR( dct_to_local(r.created_at), 'YYYY-MM-DD'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    -- ===================== STAFF: get one registration ======================
    defh('registrations/[COLON]id', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  FOR r IN (SELECT * FROM dct_fl_registration_v WHERE registration_id = [COLON]id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('registrationId',     r.registration_id);
    APEX_JSON.write('registrationNumber', r.registration_number);
    APEX_JSON.write('firstNameEn',  NVL(r.first_name_en, ''));
    APEX_JSON.write('lastNameEn',   NVL(r.last_name_en, ''));
    APEX_JSON.write('firstNameAr',  NVL(r.first_name_ar, ''));
    APEX_JSON.write('lastNameAr',   NVL(r.last_name_ar, ''));
    APEX_JSON.write('dateOfBirth',  TO_CHAR(r.date_of_birth, 'YYYY-MM-DD'));
    APEX_JSON.write('nationalityCode', NVL(r.nationality_code, ''));
    APEX_JSON.write('nationality',  NVL(r.nationality_name, '-'));
    APEX_JSON.write('nationalId',   NVL(r.national_id, ''));
    APEX_JSON.write('passportNumber', NVL(r.passport_number, ''));
    APEX_JSON.write('email',        NVL(r.email, ''));
    APEX_JSON.write('mobile',       NVL(r.mobile, ''));
    APEX_JSON.write('specialization', NVL(r.specialization, ''));
    APEX_JSON.write('requestorEmail',   NVL(r.requestor_email, ''));
    APEX_JSON.write('requestorName',    NVL(r.requestor_name, ''));
    APEX_JSON.write('lineManagerEmail', NVL(r.line_manager_email, ''));
    APEX_JSON.write('lineManagerName',  NVL(r.line_manager_name, ''));
    APEX_JSON.write('bankName',         NVL(r.bank_name, ''));
    APEX_JSON.write('bankIban',         NVL(r.bank_iban, ''));
    APEX_JSON.write('bankAccountName',  NVL(r.bank_account_name, ''));
    APEX_JSON.write('bankAccountNumber',NVL(r.bank_account_number, ''));
    APEX_JSON.write('bankSwift',        NVL(r.bank_swift, ''));
    APEX_JSON.write('bankCurrencyCode', NVL(r.bank_currency_code, 'AED'));
    APEX_JSON.write('dupStatus',        NVL(r.dup_status, 'NONE'));
    APEX_JSON.write('status',       r.status);
    APEX_JSON.write('approvalInstanceId', r.approval_instance_id);
    APEX_JSON.write('notes',        NVL(r.notes, ''));
    APEX_JSON.write('createdBy',    r.created_by);
    APEX_JSON.write('createdAt',    TO_CHAR( dct_to_local(r.created_at),'DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.write('updatedBy',    r.updated_by);
    APEX_JSON.write('updatedAt',    TO_CHAR( dct_to_local(r.updated_at),'DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.close_object;
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    -- ===================== STAFF: create registration (DRAFT) ================
    defh('registrations/', 'POST', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
  l_id   NUMBER;
  l_num  VARCHAR2(50);
  l_new  CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);
  l_num := 'FL-REG-' || TO_CHAR(seq_fl_reg_number.NEXTVAL, 'FM000000');
  INSERT INTO dct_fl_registrations (
    registration_number, first_name_en, last_name_en, first_name_ar, last_name_ar,
    date_of_birth, nationality_code, national_id, passport_number,
    email, mobile, specialization, first_deal_with_dct,
    requestor_email, requestor_name, line_manager_email, line_manager_name,
    bank_name, bank_iban, bank_account_name, bank_account_number, bank_swift, bank_currency_code,
    submitted_by, submitted_by_user_id, status, notes, created_by, updated_by
  ) VALUES (
    l_num,
    APEX_JSON.get_varchar2(p_path => 'firstNameEn'),
    APEX_JSON.get_varchar2(p_path => 'lastNameEn'),
    APEX_JSON.get_varchar2(p_path => 'firstNameAr'),
    APEX_JSON.get_varchar2(p_path => 'lastNameAr'),
    TO_DATE(NULLIF(APEX_JSON.get_varchar2(p_path => 'dateOfBirth'), ''), 'YYYY-MM-DD'),
    APEX_JSON.get_varchar2(p_path => 'nationalityCode'),
    APEX_JSON.get_varchar2(p_path => 'nationalId'),
    APEX_JSON.get_varchar2(p_path => 'passportNumber'),
    LOWER(TRIM(APEX_JSON.get_varchar2(p_path => 'email'))),
    APEX_JSON.get_varchar2(p_path => 'mobile'),
    APEX_JSON.get_varchar2(p_path => 'specialization'),
    NVL(APEX_JSON.get_varchar2(p_path => 'firstDealWithDct'), 'Y'),
    APEX_JSON.get_varchar2(p_path => 'requestorEmail'),
    APEX_JSON.get_varchar2(p_path => 'requestorName'),
    APEX_JSON.get_varchar2(p_path => 'lineManagerEmail'),
    APEX_JSON.get_varchar2(p_path => 'lineManagerName'),
    APEX_JSON.get_varchar2(p_path => 'bankName'),
    APEX_JSON.get_varchar2(p_path => 'bankIban'),
    APEX_JSON.get_varchar2(p_path => 'bankAccountName'),
    APEX_JSON.get_varchar2(p_path => 'bankAccountNumber'),
    APEX_JSON.get_varchar2(p_path => 'bankSwift'),
    NVL(APEX_JSON.get_varchar2(p_path => 'bankCurrencyCode'), 'AED'),
    'STAFF', l_uid, 'DRAFT',
    APEX_JSON.get_varchar2(p_path => 'notes'),
    l_user, l_user
  ) RETURNING registration_id INTO l_id;
  COMMIT;
  l_new := dct_audit_pkg.snap('DCT_FL_REGISTRATIONS','registration_id', TO_CHAR(l_id));
  dct_audit_pkg.log(l_user,'CREATE','DCT_FL_REGISTRATIONS', TO_CHAR(l_id), 'FL',
                    p_object_ref=>l_num, p_new=>l_new);
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('registrationId', l_id);
  APEX_JSON.write('registrationNumber', l_num);
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    -- ===================== STAFF: update registration (DRAFT/RETURNED) =======
    defh('registrations/[COLON]id', 'PUT', q'[
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_status VARCHAR2(20);
  l_old    CLOB;
  l_new    CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT status INTO l_status FROM dct_fl_registrations WHERE registration_id = [COLON]id;
  IF l_status NOT IN ('DRAFT','RETURNED') THEN
    dct_rest.err(400,'Registration can only be edited in DRAFT or RETURNED status'); RETURN;
  END IF;
  l_old := dct_audit_pkg.snap('DCT_FL_REGISTRATIONS','registration_id', TO_CHAR([COLON]id));
  dct_rest.parse_body([COLON]body);
  UPDATE dct_fl_registrations SET
    first_name_en   = NVL(APEX_JSON.get_varchar2(p_path => 'firstNameEn'), first_name_en),
    last_name_en    = NVL(APEX_JSON.get_varchar2(p_path => 'lastNameEn'),  last_name_en),
    first_name_ar   = CASE WHEN APEX_JSON.does_exist(p_path => 'firstNameAr')
                           THEN APEX_JSON.get_varchar2(p_path => 'firstNameAr') ELSE first_name_ar END,
    last_name_ar    = CASE WHEN APEX_JSON.does_exist(p_path => 'lastNameAr')
                           THEN APEX_JSON.get_varchar2(p_path => 'lastNameAr') ELSE last_name_ar END,
    date_of_birth   = NVL(TO_DATE(NULLIF(APEX_JSON.get_varchar2(p_path => 'dateOfBirth'),''),'YYYY-MM-DD'), date_of_birth),
    nationality_code= NVL(APEX_JSON.get_varchar2(p_path => 'nationalityCode'), nationality_code),
    national_id     = CASE WHEN APEX_JSON.does_exist(p_path => 'nationalId')
                           THEN APEX_JSON.get_varchar2(p_path => 'nationalId') ELSE national_id END,
    passport_number = CASE WHEN APEX_JSON.does_exist(p_path => 'passportNumber')
                           THEN APEX_JSON.get_varchar2(p_path => 'passportNumber') ELSE passport_number END,
    email           = NVL(LOWER(TRIM(APEX_JSON.get_varchar2(p_path => 'email'))), email),
    mobile          = CASE WHEN APEX_JSON.does_exist(p_path => 'mobile')
                           THEN APEX_JSON.get_varchar2(p_path => 'mobile') ELSE mobile END,
    specialization  = CASE WHEN APEX_JSON.does_exist(p_path => 'specialization')
                           THEN APEX_JSON.get_varchar2(p_path => 'specialization') ELSE specialization END,
    notes           = CASE WHEN APEX_JSON.does_exist(p_path => 'notes')
                           THEN APEX_JSON.get_varchar2(p_path => 'notes') ELSE notes END,
    requestor_email = CASE WHEN APEX_JSON.does_exist(p_path => 'requestorEmail')
                           THEN APEX_JSON.get_varchar2(p_path => 'requestorEmail') ELSE requestor_email END,
    requestor_name  = CASE WHEN APEX_JSON.does_exist(p_path => 'requestorName')
                           THEN APEX_JSON.get_varchar2(p_path => 'requestorName') ELSE requestor_name END,
    line_manager_email = CASE WHEN APEX_JSON.does_exist(p_path => 'lineManagerEmail')
                           THEN APEX_JSON.get_varchar2(p_path => 'lineManagerEmail') ELSE line_manager_email END,
    line_manager_name  = CASE WHEN APEX_JSON.does_exist(p_path => 'lineManagerName')
                           THEN APEX_JSON.get_varchar2(p_path => 'lineManagerName') ELSE line_manager_name END,
    bank_name          = CASE WHEN APEX_JSON.does_exist(p_path => 'bankName')
                           THEN APEX_JSON.get_varchar2(p_path => 'bankName') ELSE bank_name END,
    bank_iban          = CASE WHEN APEX_JSON.does_exist(p_path => 'bankIban')
                           THEN APEX_JSON.get_varchar2(p_path => 'bankIban') ELSE bank_iban END,
    bank_account_name  = CASE WHEN APEX_JSON.does_exist(p_path => 'bankAccountName')
                           THEN APEX_JSON.get_varchar2(p_path => 'bankAccountName') ELSE bank_account_name END,
    bank_account_number= CASE WHEN APEX_JSON.does_exist(p_path => 'bankAccountNumber')
                           THEN APEX_JSON.get_varchar2(p_path => 'bankAccountNumber') ELSE bank_account_number END,
    bank_swift         = CASE WHEN APEX_JSON.does_exist(p_path => 'bankSwift')
                           THEN APEX_JSON.get_varchar2(p_path => 'bankSwift') ELSE bank_swift END,
    bank_currency_code = CASE WHEN APEX_JSON.does_exist(p_path => 'bankCurrencyCode')
                           THEN APEX_JSON.get_varchar2(p_path => 'bankCurrencyCode') ELSE bank_currency_code END,
    updated_by      = l_user, updated_at = SYSTIMESTAMP
  WHERE registration_id = [COLON]id;
  COMMIT;
  l_new := dct_audit_pkg.snap('DCT_FL_REGISTRATIONS','registration_id', TO_CHAR([COLON]id));
  dct_audit_pkg.log(l_user,'UPDATE','DCT_FL_REGISTRATIONS', TO_CHAR([COLON]id), 'FL',
                    p_old=>l_old, p_new=>l_new);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');
END;
/

BEGIN
    setup_fl_reg_staff_tmp;
END;
/

DROP PROCEDURE setup_fl_reg_staff_tmp;

PROMPT === 23_fl_reg_staff_handlers.sql complete ===
