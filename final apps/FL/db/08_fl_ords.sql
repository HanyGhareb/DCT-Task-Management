-- =============================================================================
-- Freelancers Module (App 203) -- ORDS REST API
-- File    : 08_fl_ords.sql
-- Schema  : registered under ADMIN (the only REST-routable schema on ADB)
-- Base URL: /ords/admin/fl/
-- Run     : sql -name prod_mcp @08_fl_ords.sql  (fresh session - synonym rule)
-- =============================================================================
-- Workflow endpoints delegate to prod.dct_fl_pkg (07_fl_pkg_workflow.sql).
-- GET handlers read the dct_fl_*_v views. Pagination envelope:
-- {items,total,limit,offset}. Audit fields rendered in Asia/Dubai local time.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

-- =============================================================================
-- 1. ADMIN synonyms for every PROD object the handlers touch
-- =============================================================================
CREATE OR REPLACE SYNONYM dct_fl_registrations          FOR prod.dct_fl_registrations;
CREATE OR REPLACE SYNONYM dct_fl_freelancers            FOR prod.dct_fl_freelancers;
CREATE OR REPLACE SYNONYM dct_fl_bank_accounts          FOR prod.dct_fl_bank_accounts;
CREATE OR REPLACE SYNONYM dct_fl_contracts              FOR prod.dct_fl_contracts;
CREATE OR REPLACE SYNONYM dct_fl_contract_amendments    FOR prod.dct_fl_contract_amendments;
CREATE OR REPLACE SYNONYM dct_fl_payment_schedule       FOR prod.dct_fl_payment_schedule;
CREATE OR REPLACE SYNONYM dct_fl_payment_vouchers       FOR prod.dct_fl_payment_vouchers;
CREATE OR REPLACE SYNONYM dct_fl_deliverables           FOR prod.dct_fl_deliverables;
CREATE OR REPLACE SYNONYM dct_fl_contract_renewals      FOR prod.dct_fl_contract_renewals;
CREATE OR REPLACE SYNONYM dct_fl_profile_change_requests FOR prod.dct_fl_profile_change_requests;
CREATE OR REPLACE SYNONYM dct_fl_registration_v         FOR prod.dct_fl_registration_v;
CREATE OR REPLACE SYNONYM dct_fl_freelancer_v           FOR prod.dct_fl_freelancer_v;
CREATE OR REPLACE SYNONYM dct_fl_contract_v             FOR prod.dct_fl_contract_v;
CREATE OR REPLACE SYNONYM dct_fl_payment_schedule_v     FOR prod.dct_fl_payment_schedule_v;
CREATE OR REPLACE SYNONYM dct_fl_voucher_v              FOR prod.dct_fl_voucher_v;
CREATE OR REPLACE SYNONYM dct_fl_document_v             FOR prod.dct_fl_document_v;
CREATE OR REPLACE SYNONYM dct_fl_deliverable_v          FOR prod.dct_fl_deliverable_v;
CREATE OR REPLACE SYNONYM dct_fl_pkg                    FOR prod.dct_fl_pkg;
CREATE OR REPLACE SYNONYM seq_fl_reg_number             FOR prod.seq_fl_reg_number;
CREATE OR REPLACE SYNONYM seq_fl_contract_number        FOR prod.seq_fl_contract_number;
CREATE OR REPLACE SYNONYM seq_fl_voucher_number         FOR prod.seq_fl_voucher_number;
CREATE OR REPLACE SYNONYM seq_fl_renewal_number         FOR prod.seq_fl_renewal_number;
CREATE OR REPLACE SYNONYM dct_document_types            FOR prod.dct_document_types;
CREATE OR REPLACE SYNONYM dct_nationality               FOR prod.dct_nationality;
CREATE OR REPLACE SYNONYM dct_delegations               FOR prod.dct_delegations;
-- shared objects (dct_rest, dct_auth, dct_users, dct_documents, dct_modules,
-- dct_module_settings, dct_approval_*, dct_notifications, dct_lookup_*,
-- dct_organizations, dct_gl_code_combinations, dct_notify,
-- dct_request_status_history) already have ADMIN synonyms from earlier phases.

-- =============================================================================
-- 2. Module + handlers (wrapped in DDL so SQLcl skips bind scanning)
-- =============================================================================
CREATE OR REPLACE PROCEDURE setup_fl_ords_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'fl.rest';

    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;

    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name    => c_mod,
            p_pattern        => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method         => p_method,
            p_source_type    => ORDS.source_type_plsql,
            p_source         => REPLACE(p_source, '[COLON]', CHR(58)));
    END;

    PROCEDURE def_media(p_pattern VARCHAR2, p_source VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name  => c_mod,
            p_pattern      => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method       => 'GET',
            p_source_type  => ORDS.SOURCE_TYPE_MEDIA,
            p_source       => REPLACE(p_source, '[COLON]', CHR(58)));
    END;

BEGIN

    BEGIN
        ORDS.DELETE_MODULE(p_module_name => c_mod);
    EXCEPTION WHEN OTHERS THEN NULL;
    END;

    ORDS.DEFINE_MODULE(
        p_module_name    => c_mod,
        p_base_path      => '/fl/',
        p_items_per_page => 100,
        p_status         => 'PUBLISHED',
        p_comments       => 'i-Finance -- Freelancers REST API (App 203)');

    -- =========================================================================
    -- DASHBOARD
    -- =========================================================================
    def_template('dashboard/stats');
    def_handler('dashboard/stats', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_active_fl   NUMBER; l_active_con NUMBER; l_con_total NUMBER;
  l_vch_pend    NUMBER; l_vch_pend_amt NUMBER;
  l_paid_amt    NUMBER; l_docs_exp NUMBER; l_reg_pending NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT COUNT(*) INTO l_active_fl FROM dct_fl_freelancers WHERE status = 'ACTIVE';
  SELECT COUNT(*), NVL(SUM(total_amount),0) INTO l_active_con, l_con_total
  FROM dct_fl_contracts WHERE status = 'ACTIVE';
  SELECT COUNT(*), NVL(SUM(amount),0) INTO l_vch_pend, l_vch_pend_amt
  FROM dct_fl_payment_vouchers WHERE status = 'SUBMITTED';
  SELECT NVL(SUM(amount),0) INTO l_paid_amt
  FROM dct_fl_payment_vouchers WHERE payment_status = 'PAID';
  SELECT COUNT(*) INTO l_docs_exp
  FROM dct_fl_document_v WHERE expiry_status IN ('EXPIRED','EXPIRING_SOON');
  SELECT COUNT(*) INTO l_reg_pending
  FROM dct_fl_registrations WHERE status = 'SUBMITTED';
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('activeFreelancers',   l_active_fl);
  APEX_JSON.write('activeContracts',     l_active_con);
  APEX_JSON.write('contractsTotal',      l_con_total);
  APEX_JSON.write('vouchersPending',     l_vch_pend);
  APEX_JSON.write('vouchersPendingAmt',  l_vch_pend_amt);
  APEX_JSON.write('paidTotal',           l_paid_amt);
  APEX_JSON.write('docsExpiring',        l_docs_exp);
  APEX_JSON.write('registrationsPending',l_reg_pending);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('dashboard/charts');
    def_handler('dashboard/charts', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  -- committed vs paid by organisation (active + completed contracts)
  APEX_JSON.open_array('spendByOrg');
  FOR r IN (
    SELECT o.org_name_en, NVL(SUM(c.total_amount),0) AS committed,
           NVL(SUM(c.paid_total),0) AS paid
    FROM   dct_fl_contract_v c
    JOIN   dct_organizations o ON o.org_id = c.org_id
    WHERE  c.status IN ('ACTIVE','COMPLETED')
    GROUP BY o.org_name_en
    ORDER BY 2 DESC FETCH FIRST 8 ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('org',       r.org_name_en);
    APEX_JSON.write('committed', r.committed);
    APEX_JSON.write('paid',      r.paid);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  -- document expiry horizon buckets
  APEX_JSON.open_array('docExpiry');
  FOR r IN (
    SELECT bucket, COUNT(*) AS n FROM (
      SELECT CASE
               WHEN days_to_expiry < 0   THEN 'EXPIRED'
               WHEN days_to_expiry <= 30 THEN 'LE30'
               WHEN days_to_expiry <= 60 THEN 'LE60'
               WHEN days_to_expiry <= 90 THEN 'LE90'
               ELSE 'GT90' END AS bucket
      FROM dct_fl_document_v
      WHERE status = 'ACTIVE' AND expiry_date IS NOT NULL)
    GROUP BY bucket
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('bucket', r.bucket);
    APEX_JSON.write('count',  r.n);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- REGISTRATIONS
    -- =========================================================================
    def_template('registrations/');
    def_handler('registrations/', 'GET', q'!
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
    APEX_JSON.write('createdAt',        TO_CHAR(r.created_at, 'YYYY-MM-DD'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('registrations/', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
  l_id   NUMBER;
  l_num  VARCHAR2(50);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);
  l_num := 'FL-REG-' || TO_CHAR(seq_fl_reg_number.NEXTVAL, 'FM000000');
  INSERT INTO dct_fl_registrations (
    registration_number, first_name_en, last_name_en, first_name_ar, last_name_ar,
    date_of_birth, nationality_code, national_id, passport_number,
    email, mobile, specialization, first_deal_with_dct,
    submitted_by, submitted_by_user_id, status, notes, created_by, updated_by
  ) VALUES (
    l_num,
    APEX_JSON.get_varchar2(p_path => 'firstNameEn'),
    APEX_JSON.get_varchar2(p_path => 'lastNameEn'),
    APEX_JSON.get_varchar2(p_path => 'firstNameAr'),
    APEX_JSON.get_varchar2(p_path => 'lastNameAr'),
    TO_DATE(APEX_JSON.get_varchar2(p_path => 'dateOfBirth'), 'YYYY-MM-DD'),
    APEX_JSON.get_varchar2(p_path => 'nationalityCode'),
    APEX_JSON.get_varchar2(p_path => 'nationalId'),
    APEX_JSON.get_varchar2(p_path => 'passportNumber'),
    LOWER(TRIM(APEX_JSON.get_varchar2(p_path => 'email'))),
    APEX_JSON.get_varchar2(p_path => 'mobile'),
    APEX_JSON.get_varchar2(p_path => 'specialization'),
    NVL(APEX_JSON.get_varchar2(p_path => 'firstDealWithDct'), 'Y'),
    'STAFF', l_uid, 'DRAFT',
    APEX_JSON.get_varchar2(p_path => 'notes'),
    l_user, l_user
  ) RETURNING registration_id INTO l_id;
  COMMIT;
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
!');

    def_template('registrations/[COLON]id');
    def_handler('registrations/[COLON]id', 'GET', q'!
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
    APEX_JSON.write('firstNameEn',  r.first_name_en);
    APEX_JSON.write('lastNameEn',   r.last_name_en);
    APEX_JSON.write('firstNameAr',  NVL(r.first_name_ar, ''));
    APEX_JSON.write('lastNameAr',   NVL(r.last_name_ar, ''));
    APEX_JSON.write('dateOfBirth',  TO_CHAR(r.date_of_birth, 'YYYY-MM-DD'));
    APEX_JSON.write('nationalityCode', r.nationality_code);
    APEX_JSON.write('nationality',  NVL(r.nationality_name, '-'));
    APEX_JSON.write('nationalId',   NVL(r.national_id, ''));
    APEX_JSON.write('passportNumber', NVL(r.passport_number, ''));
    APEX_JSON.write('email',        r.email);
    APEX_JSON.write('mobile',       NVL(r.mobile, ''));
    APEX_JSON.write('specialization', NVL(r.specialization, ''));
    APEX_JSON.write('status',       r.status);
    APEX_JSON.write('approvalInstanceId', r.approval_instance_id);
    APEX_JSON.write('notes',        NVL(r.notes, ''));
    APEX_JSON.write('createdBy',    r.created_by);
    APEX_JSON.write('createdAt',    TO_CHAR(FROM_TZ(r.created_at, 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.write('updatedBy',    r.updated_by);
    APEX_JSON.write('updatedAt',    TO_CHAR(FROM_TZ(r.updated_at, 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.close_object;
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('registrations/[COLON]id', 'PUT', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_status VARCHAR2(20);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT status INTO l_status FROM dct_fl_registrations WHERE registration_id = [COLON]id;
  IF l_status NOT IN ('DRAFT','RETURNED') THEN
    dct_rest.err(400,'Registration can only be edited in DRAFT or RETURNED status'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE dct_fl_registrations SET
    first_name_en   = NVL(APEX_JSON.get_varchar2(p_path => 'firstNameEn'), first_name_en),
    last_name_en    = NVL(APEX_JSON.get_varchar2(p_path => 'lastNameEn'),  last_name_en),
    first_name_ar   = CASE WHEN APEX_JSON.does_exist(p_path => 'firstNameAr')
                           THEN APEX_JSON.get_varchar2(p_path => 'firstNameAr') ELSE first_name_ar END,
    last_name_ar    = CASE WHEN APEX_JSON.does_exist(p_path => 'lastNameAr')
                           THEN APEX_JSON.get_varchar2(p_path => 'lastNameAr') ELSE last_name_ar END,
    date_of_birth   = NVL(TO_DATE(APEX_JSON.get_varchar2(p_path => 'dateOfBirth'),'YYYY-MM-DD'), date_of_birth),
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
    updated_by      = l_user, updated_at = SYSTIMESTAMP
  WHERE registration_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('registrations/[COLON]id/submit');
    def_handler('registrations/[COLON]id/submit', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_fl_pkg.submit_registration([COLON]id, dct_auth.get_user_id(l_user));
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE); APEX_JSON.write('status', 'SUBMITTED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('registrations/[COLON]id/photo');
    def_handler('registrations/[COLON]id/photo', 'PUT', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  v_blob  BLOB;
  v_raw   RAW(32767);
  v_b64   VARCHAR2(32767) := [COLON]photo_data_b64;
  v_len   NUMBER; v_pos NUMBER := 1; v_chunk NUMBER := 32764;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF v_b64 IS NULL THEN dct_rest.err(400,'photo_data_b64 is required'); RETURN; END IF;
  DBMS_LOB.CREATETEMPORARY(v_blob, TRUE);
  v_len := LENGTH(v_b64);
  WHILE v_pos <= v_len LOOP
    v_raw := UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(SUBSTR(v_b64, v_pos, v_chunk)));
    DBMS_LOB.WRITEAPPEND(v_blob, UTL_RAW.LENGTH(v_raw), v_raw);
    v_pos := v_pos + v_chunk;
  END LOOP;
  UPDATE dct_fl_registrations SET
    photo_blob = v_blob,
    photo_mime_type = NVL([COLON]mime_type, 'image/jpeg'),
    photo_filename  = NVL([COLON]file_name, 'photo.jpg'),
    updated_by = l_user, updated_at = SYSTIMESTAMP
  WHERE registration_id = [COLON]id;
  COMMIT;
  DBMS_LOB.FREETEMPORARY(v_blob);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');
    def_media('registrations/[COLON]id/photo',
      q'!SELECT photo_mime_type, photo_blob FROM dct_fl_registrations WHERE registration_id = [COLON]id!');

    -- =========================================================================
    -- FREELANCERS
    -- =========================================================================
    def_template('freelancers/');
    def_handler('freelancers/', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_limit  NUMBER        := LEAST(NVL(TO_NUMBER([COLON]limit DEFAULT NULL ON CONVERSION ERROR), 50), 200);
  l_offset NUMBER        := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_search VARCHAR2(200) := [COLON]search;
  l_status VARCHAR2(20)  := UPPER([COLON]status);
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT COUNT(*) INTO l_total FROM dct_fl_freelancer_v f
  WHERE (l_status IS NULL OR f.status = l_status)
    AND (l_search IS NULL OR UPPER(NVL(f.vendor_number,'') || ' ' || f.full_name_en || ' ' || f.email)
         LIKE '%' || UPPER(l_search) || '%');
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total', l_total); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT * FROM dct_fl_freelancer_v f
    WHERE (l_status IS NULL OR f.status = l_status)
      AND (l_search IS NULL OR UPPER(NVL(f.vendor_number,'') || ' ' || f.full_name_en || ' ' || f.email)
           LIKE '%' || UPPER(l_search) || '%')
    ORDER BY f.full_name_en
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('freelancerId',  r.freelancer_id);
    APEX_JSON.write('vendorNumber',  NVL(r.vendor_number, '-'));
    APEX_JSON.write('fullNameEn',    r.full_name_en);
    APEX_JSON.write('nationality',   NVL(r.nationality_name, '-'));
    APEX_JSON.write('email',         r.email);
    APEX_JSON.write('mobile',        NVL(r.mobile, ''));
    APEX_JSON.write('specialization',NVL(r.specialization, ''));
    APEX_JSON.write('status',        r.status);
    APEX_JSON.write('activeContracts', r.active_contract_count);
    APEX_JSON.write('expiredDocs',   r.expired_doc_count);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('freelancers/[COLON]id');
    def_handler('freelancers/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  FOR r IN (SELECT * FROM dct_fl_freelancer_v WHERE freelancer_id = [COLON]id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('freelancerId',   r.freelancer_id);
    APEX_JSON.write('registrationId', r.registration_id);
    APEX_JSON.write('vendorNumber',   NVL(r.vendor_number, '-'));
    APEX_JSON.write('firstNameEn',    r.first_name_en);
    APEX_JSON.write('lastNameEn',     r.last_name_en);
    APEX_JSON.write('fullNameEn',     r.full_name_en);
    APEX_JSON.write('firstNameAr',    NVL(r.first_name_ar, ''));
    APEX_JSON.write('lastNameAr',     NVL(r.last_name_ar, ''));
    APEX_JSON.write('dateOfBirth',    TO_CHAR(r.date_of_birth, 'YYYY-MM-DD'));
    APEX_JSON.write('nationalityCode',r.nationality_code);
    APEX_JSON.write('nationality',    NVL(r.nationality_name, '-'));
    APEX_JSON.write('nationalId',     NVL(r.national_id, ''));
    APEX_JSON.write('passportNumber', NVL(r.passport_number, ''));
    APEX_JSON.write('email',          r.email);
    APEX_JSON.write('mobile',         NVL(r.mobile, ''));
    APEX_JSON.write('specialization', NVL(r.specialization, ''));
    APEX_JSON.write('status',         r.status);
    APEX_JSON.write('blacklistReason',NVL(r.blacklist_reason, ''));
    APEX_JSON.write('notes',          NVL(r.notes, ''));
    APEX_JSON.write('activeContracts', r.active_contract_count);
    APEX_JSON.write('expiredDocs',    r.expired_doc_count);
    APEX_JSON.write('createdAt',      TO_CHAR(FROM_TZ(r.created_at, 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.write('updatedAt',      TO_CHAR(FROM_TZ(r.updated_at, 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.open_array('bankAccounts');
    FOR b IN (SELECT * FROM dct_fl_bank_accounts
              WHERE freelancer_id = [COLON]id ORDER BY is_primary DESC, bank_account_id) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('bankAccountId', b.bank_account_id);
      APEX_JSON.write('bankName',      b.bank_name);
      APEX_JSON.write('accountNumber', b.account_number);
      APEX_JSON.write('iban',          NVL(b.iban, ''));
      APEX_JSON.write('accountName',   b.account_name);
      APEX_JSON.write('currencyCode',  b.currency_code);
      APEX_JSON.write('isPrimary',     b.is_primary);
      APEX_JSON.write('isActive',      b.is_active);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.open_array('contracts');
    FOR c IN (SELECT * FROM dct_fl_contract_v
              WHERE freelancer_id = [COLON]id ORDER BY contract_id DESC) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('contractId',     c.contract_id);
      APEX_JSON.write('contractNumber', c.contract_number);
      APEX_JSON.write('title',          c.title);
      APEX_JSON.write('totalAmount',    c.total_amount);
      APEX_JSON.write('status',         c.status);
      APEX_JSON.write('billStatus',     c.contract_bill_status);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.close_object;
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('freelancers/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE dct_fl_freelancers SET
    status = NVL(APEX_JSON.get_varchar2(p_path => 'status'), status),
    blacklist_reason = CASE WHEN APEX_JSON.does_exist(p_path => 'blacklistReason')
                            THEN APEX_JSON.get_varchar2(p_path => 'blacklistReason') ELSE blacklist_reason END,
    mobile = CASE WHEN APEX_JSON.does_exist(p_path => 'mobile')
                  THEN APEX_JSON.get_varchar2(p_path => 'mobile') ELSE mobile END,
    specialization = CASE WHEN APEX_JSON.does_exist(p_path => 'specialization')
                          THEN APEX_JSON.get_varchar2(p_path => 'specialization') ELSE specialization END,
    notes  = CASE WHEN APEX_JSON.does_exist(p_path => 'notes')
                  THEN APEX_JSON.get_varchar2(p_path => 'notes') ELSE notes END,
    updated_by = l_user, updated_at = SYSTIMESTAMP
  WHERE freelancer_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('freelancers/[COLON]id/photo');
    def_handler('freelancers/[COLON]id/photo', 'PUT', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  v_blob  BLOB;
  v_raw   RAW(32767);
  v_b64   VARCHAR2(32767) := [COLON]photo_data_b64;
  v_len   NUMBER; v_pos NUMBER := 1; v_chunk NUMBER := 32764;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF v_b64 IS NULL THEN dct_rest.err(400,'photo_data_b64 is required'); RETURN; END IF;
  DBMS_LOB.CREATETEMPORARY(v_blob, TRUE);
  v_len := LENGTH(v_b64);
  WHILE v_pos <= v_len LOOP
    v_raw := UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(SUBSTR(v_b64, v_pos, v_chunk)));
    DBMS_LOB.WRITEAPPEND(v_blob, UTL_RAW.LENGTH(v_raw), v_raw);
    v_pos := v_pos + v_chunk;
  END LOOP;
  UPDATE dct_fl_freelancers SET
    photo_blob = v_blob,
    photo_mime_type = NVL([COLON]mime_type, 'image/jpeg'),
    photo_filename  = NVL([COLON]file_name, 'photo.jpg'),
    updated_by = l_user, updated_at = SYSTIMESTAMP
  WHERE freelancer_id = [COLON]id;
  COMMIT;
  DBMS_LOB.FREETEMPORARY(v_blob);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');
    def_media('freelancers/[COLON]id/photo',
      q'!SELECT photo_mime_type, photo_blob FROM dct_fl_freelancers WHERE freelancer_id = [COLON]id!');

    def_template('freelancers/[COLON]id/bank-accounts');
    def_handler('freelancers/[COLON]id/bank-accounts', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER;
  l_primary VARCHAR2(1);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_primary := NVL(APEX_JSON.get_varchar2(p_path => 'isPrimary'), 'N');
  IF l_primary = 'Y' THEN
    UPDATE dct_fl_bank_accounts SET is_primary = 'N', updated_by = l_user, updated_at = SYSTIMESTAMP
    WHERE freelancer_id = [COLON]id AND is_primary = 'Y';
  END IF;
  INSERT INTO dct_fl_bank_accounts (
    freelancer_id, bank_name, account_number, iban, account_name,
    currency_code, is_primary, is_active, notes, created_by, updated_by
  ) VALUES (
    [COLON]id,
    APEX_JSON.get_varchar2(p_path => 'bankName'),
    APEX_JSON.get_varchar2(p_path => 'accountNumber'),
    APEX_JSON.get_varchar2(p_path => 'iban'),
    APEX_JSON.get_varchar2(p_path => 'accountName'),
    NVL(APEX_JSON.get_varchar2(p_path => 'currencyCode'), 'AED'),
    l_primary, 'Y',
    APEX_JSON.get_varchar2(p_path => 'notes'),
    l_user, l_user
  ) RETURNING bank_account_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('bankAccountId', l_id); APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('bank-accounts/[COLON]id');
    def_handler('bank-accounts/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_frl  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  SELECT freelancer_id INTO l_frl FROM dct_fl_bank_accounts WHERE bank_account_id = [COLON]id;
  IF NVL(APEX_JSON.get_varchar2(p_path => 'isPrimary'), 'N') = 'Y' THEN
    UPDATE dct_fl_bank_accounts SET is_primary = 'N', updated_by = l_user, updated_at = SYSTIMESTAMP
    WHERE freelancer_id = l_frl AND is_primary = 'Y';
  END IF;
  UPDATE dct_fl_bank_accounts SET
    bank_name      = NVL(APEX_JSON.get_varchar2(p_path => 'bankName'), bank_name),
    account_number = NVL(APEX_JSON.get_varchar2(p_path => 'accountNumber'), account_number),
    iban           = CASE WHEN APEX_JSON.does_exist(p_path => 'iban')
                          THEN APEX_JSON.get_varchar2(p_path => 'iban') ELSE iban END,
    account_name   = NVL(APEX_JSON.get_varchar2(p_path => 'accountName'), account_name),
    is_primary     = NVL(APEX_JSON.get_varchar2(p_path => 'isPrimary'), is_primary),
    is_active      = NVL(APEX_JSON.get_varchar2(p_path => 'isActive'), is_active),
    updated_by     = l_user, updated_at = SYSTIMESTAMP
  WHERE bank_account_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- CONTRACTS
    -- =========================================================================
    def_template('contracts/');
    def_handler('contracts/', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_limit  NUMBER        := LEAST(NVL(TO_NUMBER([COLON]limit DEFAULT NULL ON CONVERSION ERROR), 50), 200);
  l_offset NUMBER        := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_search VARCHAR2(200) := [COLON]search;
  l_status VARCHAR2(20)  := UPPER([COLON]status);
  l_frl    NUMBER        := TO_NUMBER([COLON]freelancerId DEFAULT NULL ON CONVERSION ERROR);
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT COUNT(*) INTO l_total FROM dct_fl_contract_v c
  WHERE (l_status IS NULL OR c.status = l_status)
    AND (l_frl IS NULL OR c.freelancer_id = l_frl)
    AND (l_search IS NULL OR UPPER(c.contract_number || ' ' || c.title || ' ' || c.freelancer_name)
         LIKE '%' || UPPER(l_search) || '%');
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total', l_total); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT * FROM dct_fl_contract_v c
    WHERE (l_status IS NULL OR c.status = l_status)
      AND (l_frl IS NULL OR c.freelancer_id = l_frl)
      AND (l_search IS NULL OR UPPER(c.contract_number || ' ' || c.title || ' ' || c.freelancer_name)
           LIKE '%' || UPPER(l_search) || '%')
    ORDER BY c.contract_id DESC
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('contractId',     r.contract_id);
    APEX_JSON.write('contractNumber', r.contract_number);
    APEX_JSON.write('freelancerId',   r.freelancer_id);
    APEX_JSON.write('freelancerName', r.freelancer_name);
    APEX_JSON.write('title',          r.title);
    APEX_JSON.write('startDate',      TO_CHAR(r.start_date, 'YYYY-MM-DD'));
    APEX_JSON.write('endDate',        TO_CHAR(r.end_date, 'YYYY-MM-DD'));
    APEX_JSON.write('totalAmount',    r.total_amount);
    APEX_JSON.write('billingMethod',  r.billing_method);
    APEX_JSON.write('orgName',        r.org_name);
    APEX_JSON.write('status',         r.status);
    APEX_JSON.write('billStatus',     r.contract_bill_status);
    APEX_JSON.write('paidTotal',      r.paid_total);
    APEX_JSON.write('approvalInstanceId', r.approval_instance_id);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('contracts/', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER;
  l_num  VARCHAR2(50);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_num := 'FL-CON-' || TO_CHAR(seq_fl_contract_number.NEXTVAL, 'FM000000');
  INSERT INTO dct_fl_contracts (
    contract_number, freelancer_id, title, start_date, end_date,
    total_amount, currency_code, billing_method, billing_unit_id, billing_unit_amount,
    org_id, coding_type, cc_id_gl, project_number, task_number, expenditure_type,
    status, notes, created_by, updated_by
  ) VALUES (
    l_num,
    APEX_JSON.get_number(p_path   => 'freelancerId'),
    APEX_JSON.get_varchar2(p_path => 'title'),
    TO_DATE(APEX_JSON.get_varchar2(p_path => 'startDate'), 'YYYY-MM-DD'),
    TO_DATE(APEX_JSON.get_varchar2(p_path => 'endDate'),   'YYYY-MM-DD'),
    APEX_JSON.get_number(p_path   => 'totalAmount'),
    NVL(APEX_JSON.get_varchar2(p_path => 'currencyCode'), 'AED'),
    APEX_JSON.get_varchar2(p_path => 'billingMethod'),
    APEX_JSON.get_number(p_path   => 'billingUnitId'),
    APEX_JSON.get_number(p_path   => 'billingUnitAmount'),
    APEX_JSON.get_number(p_path   => 'orgId'),
    NVL(APEX_JSON.get_varchar2(p_path => 'codingType'), 'GL'),
    APEX_JSON.get_number(p_path   => 'ccIdGl'),
    APEX_JSON.get_varchar2(p_path => 'projectNumber'),
    APEX_JSON.get_varchar2(p_path => 'taskNumber'),
    APEX_JSON.get_varchar2(p_path => 'expenditureType'),
    'DRAFT',
    APEX_JSON.get_varchar2(p_path => 'notes'),
    l_user, l_user
  ) RETURNING contract_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('contractId', l_id);
  APEX_JSON.write('contractNumber', l_num);
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('contracts/[COLON]id');
    def_handler('contracts/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  FOR r IN (SELECT * FROM dct_fl_contract_v WHERE contract_id = [COLON]id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('contractId',     r.contract_id);
    APEX_JSON.write('contractNumber', r.contract_number);
    APEX_JSON.write('versionNumber',  r.version_number);
    APEX_JSON.write('freelancerId',   r.freelancer_id);
    APEX_JSON.write('freelancerName', r.freelancer_name);
    APEX_JSON.write('vendorNumber',   NVL(r.vendor_number, '-'));
    APEX_JSON.write('renewedFromId',  r.renewed_from_contract_id);
    APEX_JSON.write('title',          r.title);
    APEX_JSON.write('startDate',      TO_CHAR(r.start_date, 'YYYY-MM-DD'));
    APEX_JSON.write('endDate',        TO_CHAR(r.end_date, 'YYYY-MM-DD'));
    APEX_JSON.write('totalAmount',    r.total_amount);
    APEX_JSON.write('currencyCode',   r.currency_code);
    APEX_JSON.write('billingMethod',  r.billing_method);
    APEX_JSON.write('billingUnitId',  r.billing_unit_id);
    APEX_JSON.write('billingUnitName',NVL(r.billing_unit_name, ''));
    APEX_JSON.write('billingUnitAmount', r.billing_unit_amount);
    APEX_JSON.write('orgId',          r.org_id);
    APEX_JSON.write('orgName',        r.org_name);
    APEX_JSON.write('codingType',     r.coding_type);
    APEX_JSON.write('ccIdGl',         r.cc_id_gl);
    APEX_JSON.write('projectNumber',  NVL(r.project_number, ''));
    APEX_JSON.write('taskNumber',     NVL(r.task_number, ''));
    APEX_JSON.write('expenditureType',NVL(r.expenditure_type, ''));
    APEX_JSON.write('status',         r.status);
    APEX_JSON.write('billStatus',     r.contract_bill_status);
    APEX_JSON.write('scheduledTotal', r.scheduled_total);
    APEX_JSON.write('paidTotal',      r.paid_total);
    APEX_JSON.write('approvalInstanceId', r.approval_instance_id);
    APEX_JSON.write('notes',          NVL(r.notes, ''));
    APEX_JSON.write('createdBy',      r.created_by);
    APEX_JSON.write('createdAt',      TO_CHAR(FROM_TZ(r.created_at, 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.write('updatedAt',      TO_CHAR(FROM_TZ(r.updated_at, 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.close_object;
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('contracts/[COLON]id', 'PUT', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_status VARCHAR2(20);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT status INTO l_status FROM dct_fl_contracts WHERE contract_id = [COLON]id;
  IF l_status != 'DRAFT' THEN
    dct_rest.err(400,'Contract can only be edited in DRAFT status (use an amendment after approval)'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE dct_fl_contracts SET
    title          = NVL(APEX_JSON.get_varchar2(p_path => 'title'), title),
    start_date     = NVL(TO_DATE(APEX_JSON.get_varchar2(p_path => 'startDate'),'YYYY-MM-DD'), start_date),
    end_date       = CASE WHEN APEX_JSON.does_exist(p_path => 'endDate')
                          THEN TO_DATE(APEX_JSON.get_varchar2(p_path => 'endDate'),'YYYY-MM-DD') ELSE end_date END,
    total_amount   = NVL(APEX_JSON.get_number(p_path => 'totalAmount'), total_amount),
    billing_method = NVL(APEX_JSON.get_varchar2(p_path => 'billingMethod'), billing_method),
    billing_unit_id     = CASE WHEN APEX_JSON.does_exist(p_path => 'billingUnitId')
                               THEN APEX_JSON.get_number(p_path => 'billingUnitId') ELSE billing_unit_id END,
    billing_unit_amount = CASE WHEN APEX_JSON.does_exist(p_path => 'billingUnitAmount')
                               THEN APEX_JSON.get_number(p_path => 'billingUnitAmount') ELSE billing_unit_amount END,
    org_id         = NVL(APEX_JSON.get_number(p_path => 'orgId'), org_id),
    coding_type    = NVL(APEX_JSON.get_varchar2(p_path => 'codingType'), coding_type),
    cc_id_gl       = CASE WHEN APEX_JSON.does_exist(p_path => 'ccIdGl')
                          THEN APEX_JSON.get_number(p_path => 'ccIdGl') ELSE cc_id_gl END,
    project_number = CASE WHEN APEX_JSON.does_exist(p_path => 'projectNumber')
                          THEN APEX_JSON.get_varchar2(p_path => 'projectNumber') ELSE project_number END,
    task_number    = CASE WHEN APEX_JSON.does_exist(p_path => 'taskNumber')
                          THEN APEX_JSON.get_varchar2(p_path => 'taskNumber') ELSE task_number END,
    expenditure_type = CASE WHEN APEX_JSON.does_exist(p_path => 'expenditureType')
                            THEN APEX_JSON.get_varchar2(p_path => 'expenditureType') ELSE expenditure_type END,
    notes          = CASE WHEN APEX_JSON.does_exist(p_path => 'notes')
                          THEN APEX_JSON.get_varchar2(p_path => 'notes') ELSE notes END,
    updated_by     = l_user, updated_at = SYSTIMESTAMP
  WHERE contract_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('contracts/[COLON]id/submit');
    def_handler('contracts/[COLON]id/submit', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_fl_pkg.submit_contract([COLON]id, dct_auth.get_user_id(l_user));
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE); APEX_JSON.write('status', 'SUBMITTED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('contracts/[COLON]id/schedule');
    def_handler('contracts/[COLON]id/schedule', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM dct_fl_payment_schedule_v
            WHERE contract_id = [COLON]id ORDER BY due_date) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('scheduleId',    r.schedule_id);
    APEX_JSON.write('periodLabel',   r.period_label);
    APEX_JSON.write('dueDate',       TO_CHAR(r.due_date, 'YYYY-MM-DD'));
    APEX_JSON.write('amount',        r.amount);
    APEX_JSON.write('voucherId',     r.voucher_id);
    APEX_JSON.write('voucherNumber', NVL(r.voucher_number, ''));
    APEX_JSON.write('status',        r.status);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- AMENDMENTS
    -- =========================================================================
    def_template('contracts/[COLON]id/amendments');
    def_handler('contracts/[COLON]id/amendments', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM dct_fl_contract_amendments
            WHERE contract_id = [COLON]id ORDER BY amendment_number DESC) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('amendmentId',     r.amendment_id);
    APEX_JSON.write('amendmentNumber', r.amendment_number);
    APEX_JSON.write('reason',          r.reason);
    APEX_JSON.write('changeSummary',   NVL(r.change_summary, ''));
    APEX_JSON.write('newTotalAmount',  r.new_total_amount);
    APEX_JSON.write('newStartDate',    TO_CHAR(r.new_start_date, 'YYYY-MM-DD'));
    APEX_JSON.write('newEndDate',      TO_CHAR(r.new_end_date, 'YYYY-MM-DD'));
    APEX_JSON.write('newBillingMethod',NVL(r.new_billing_method, ''));
    APEX_JSON.write('status',          r.status);
    APEX_JSON.write('approvalInstanceId', r.approval_instance_id);
    APEX_JSON.write('createdBy',       r.created_by);
    APEX_JSON.write('createdAt',       TO_CHAR(FROM_TZ(r.created_at, 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('contracts/[COLON]id/amendments', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER;
  l_next NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  SELECT NVL(MAX(amendment_number),0) + 1 INTO l_next
  FROM dct_fl_contract_amendments WHERE contract_id = [COLON]id;
  INSERT INTO dct_fl_contract_amendments (
    contract_id, amendment_number, reason, change_summary,
    new_total_amount, new_start_date, new_end_date, new_billing_method,
    status, created_by, updated_by
  ) VALUES (
    [COLON]id, l_next,
    APEX_JSON.get_varchar2(p_path => 'reason'),
    APEX_JSON.get_varchar2(p_path => 'changeSummary'),
    APEX_JSON.get_number(p_path   => 'newTotalAmount'),
    TO_DATE(APEX_JSON.get_varchar2(p_path => 'newStartDate'), 'YYYY-MM-DD'),
    TO_DATE(APEX_JSON.get_varchar2(p_path => 'newEndDate'),   'YYYY-MM-DD'),
    APEX_JSON.get_varchar2(p_path => 'newBillingMethod'),
    'DRAFT', l_user, l_user
  ) RETURNING amendment_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('amendmentId', l_id);
  APEX_JSON.write('amendmentNumber', l_next);
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('amendments/[COLON]id/submit');
    def_handler('amendments/[COLON]id/submit', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_fl_pkg.submit_amendment([COLON]id, dct_auth.get_user_id(l_user));
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE); APEX_JSON.write('status', 'SUBMITTED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- RENEWALS
    -- =========================================================================
    def_template('renewals/');
    def_handler('renewals/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_con  NUMBER := TO_NUMBER([COLON]contractId DEFAULT NULL ON CONVERSION ERROR);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT rn.*, c.contract_number AS original_contract_number
            FROM dct_fl_contract_renewals rn
            JOIN dct_fl_contracts c ON c.contract_id = rn.original_contract_id
            WHERE (l_con IS NULL OR rn.original_contract_id = l_con)
            ORDER BY rn.renewal_id DESC FETCH FIRST 200 ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('renewalId',       r.renewal_id);
    APEX_JSON.write('renewalNumber',   r.renewal_number);
    APEX_JSON.write('originalContractId', r.original_contract_id);
    APEX_JSON.write('originalContractNumber', r.original_contract_number);
    APEX_JSON.write('newContractId',   r.new_contract_id);
    APEX_JSON.write('newStartDate',    TO_CHAR(r.new_start_date, 'YYYY-MM-DD'));
    APEX_JSON.write('newEndDate',      TO_CHAR(r.new_end_date, 'YYYY-MM-DD'));
    APEX_JSON.write('newTotalAmount',  r.new_total_amount);
    APEX_JSON.write('reason',          r.reason);
    APEX_JSON.write('status',          r.status);
    APEX_JSON.write('approvalInstanceId', r.approval_instance_id);
    APEX_JSON.write('createdAt',       TO_CHAR(FROM_TZ(r.created_at, 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('renewals/', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER;
  l_num  VARCHAR2(50);
  l_con  dct_fl_contracts%ROWTYPE;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  SELECT * INTO l_con FROM dct_fl_contracts
  WHERE contract_id = APEX_JSON.get_number(p_path => 'originalContractId');
  l_num := 'FL-RNW-' || TO_CHAR(seq_fl_renewal_number.NEXTVAL, 'FM000000');
  INSERT INTO dct_fl_contract_renewals (
    original_contract_id, renewal_number,
    new_start_date, new_end_date, new_total_amount,
    new_billing_method, new_billing_unit_id, new_billing_unit_amount,
    coding_type, cc_id_gl, project_number, task_number, expenditure_type,
    reason, status, created_by, updated_by
  ) VALUES (
    l_con.contract_id, l_num,
    TO_DATE(APEX_JSON.get_varchar2(p_path => 'newStartDate'), 'YYYY-MM-DD'),
    TO_DATE(APEX_JSON.get_varchar2(p_path => 'newEndDate'),   'YYYY-MM-DD'),
    APEX_JSON.get_number(p_path   => 'newTotalAmount'),
    APEX_JSON.get_varchar2(p_path => 'newBillingMethod'),
    APEX_JSON.get_number(p_path   => 'newBillingUnitId'),
    APEX_JSON.get_number(p_path   => 'newBillingUnitAmount'),
    NVL(APEX_JSON.get_varchar2(p_path => 'codingType'), l_con.coding_type),
    NVL(APEX_JSON.get_number(p_path => 'ccIdGl'), l_con.cc_id_gl),
    NVL(APEX_JSON.get_varchar2(p_path => 'projectNumber'), l_con.project_number),
    NVL(APEX_JSON.get_varchar2(p_path => 'taskNumber'), l_con.task_number),
    NVL(APEX_JSON.get_varchar2(p_path => 'expenditureType'), l_con.expenditure_type),
    APEX_JSON.get_varchar2(p_path => 'reason'),
    'DRAFT', l_user, l_user
  ) RETURNING renewal_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('renewalId', l_id);
  APEX_JSON.write('renewalNumber', l_num);
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('renewals/[COLON]id/submit');
    def_handler('renewals/[COLON]id/submit', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_fl_pkg.submit_renewal([COLON]id, dct_auth.get_user_id(l_user));
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE); APEX_JSON.write('status', 'SUBMITTED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- PAYMENT SCHEDULE (global due worklist)
    -- =========================================================================
    def_template('schedule/');
    def_handler('schedule/', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_limit  NUMBER        := LEAST(NVL(TO_NUMBER([COLON]limit DEFAULT NULL ON CONVERSION ERROR), 50), 200);
  l_offset NUMBER        := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_status VARCHAR2(30)  := UPPER([COLON]status);
  l_due    DATE          := TO_DATE([COLON]dueBefore DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT COUNT(*) INTO l_total FROM dct_fl_payment_schedule_v s
  WHERE (l_status IS NULL OR s.status = l_status)
    AND (l_due IS NULL OR s.due_date <= l_due);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total', l_total); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT * FROM dct_fl_payment_schedule_v s
    WHERE (l_status IS NULL OR s.status = l_status)
      AND (l_due IS NULL OR s.due_date <= l_due)
    ORDER BY s.due_date
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('scheduleId',     r.schedule_id);
    APEX_JSON.write('contractId',     r.contract_id);
    APEX_JSON.write('contractNumber', r.contract_number);
    APEX_JSON.write('freelancerName', r.freelancer_name);
    APEX_JSON.write('periodLabel',    r.period_label);
    APEX_JSON.write('dueDate',        TO_CHAR(r.due_date, 'YYYY-MM-DD'));
    APEX_JSON.write('amount',         r.amount);
    APEX_JSON.write('voucherNumber',  NVL(r.voucher_number, ''));
    APEX_JSON.write('status',         r.status);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('schedule/bulk-generate');
    def_handler('schedule/bulk-generate', 'POST', q'!
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_dstr    VARCHAR2(20);
  l_due     DATE;
  l_tpl     VARCHAR2(1000);
  l_desc    VARCHAR2(1000);
  l_pay     VARCHAR2(30);
  l_grp     VARCHAR2(30);
  l_num     VARCHAR2(50);
  l_id      NUMBER;
  l_ids     APEX_T_NUMBER   := APEX_T_NUMBER();
  l_nums    APEX_T_VARCHAR2 := APEX_T_VARCHAR2();
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NVL(dct_fl_pkg.get_setting('ALLOW_BULK_VOUCHER_GENERATION'),'N') != 'Y' THEN
    dct_rest.err(403,'Bulk voucher generation is disabled (ALLOW_BULK_VOUCHER_GENERATION)'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_dstr := APEX_JSON.get_varchar2(p_path => 'dueBefore');
  IF l_dstr IS NOT NULL THEN
    l_due := TO_DATE(l_dstr DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
  END IF;
  l_tpl := NVL(dct_fl_pkg.get_setting('VOUCHER_DEFAULT_DESCRIPTION'),
               'Freelancer Payment - {CONTRACT_NUMBER} - {PERIOD_LABEL}');
  l_pay := NVL(dct_fl_pkg.get_setting('DEFAULT_PAYMENT_METHOD'), 'BANK_TRANSFER');
  l_grp := NVL(dct_fl_pkg.get_setting('DEFAULT_PAY_GROUP'), 'FREELANCER');
  FOR s IN (
    SELECT s.schedule_id, s.contract_id, s.period_label, s.due_date, s.amount,
           c.contract_number, c.freelancer_id,
           c.coding_type, c.cc_id_gl, c.project_number, c.task_number, c.expenditure_type
    FROM dct_fl_payment_schedule s
    JOIN dct_fl_contracts c ON c.contract_id = s.contract_id
    WHERE s.status = 'PENDING'
      AND (l_due IS NULL OR s.due_date <= l_due)
      AND NOT EXISTS (SELECT 1 FROM dct_fl_payment_vouchers v
                      WHERE v.schedule_id = s.schedule_id
                        AND v.status NOT IN ('REJECTED','CANCELLED'))
    ORDER BY s.due_date
    FETCH FIRST 100 ROWS ONLY
  ) LOOP
    l_num  := 'FL-VCH-' || TO_CHAR(seq_fl_voucher_number.NEXTVAL, 'FM000000');
    l_desc := REPLACE(REPLACE(l_tpl, '{CONTRACT_NUMBER}', s.contract_number),
                      '{PERIOD_LABEL}', s.period_label);
    INSERT INTO dct_fl_payment_vouchers (
      voucher_number, contract_id, freelancer_id, schedule_id,
      period_label, due_date, amount,
      payment_method, pay_group, description,
      coding_type, cc_id_gl, project_number, task_number, expenditure_type,
      post_to_fusion, status, payment_status, created_by, updated_by
    ) VALUES (
      l_num, s.contract_id, s.freelancer_id, s.schedule_id,
      s.period_label, s.due_date, s.amount,
      l_pay, l_grp, l_desc,
      s.coding_type, s.cc_id_gl, s.project_number, s.task_number, s.expenditure_type,
      'N', 'DRAFT', 'PENDING', l_user, l_user
    ) RETURNING voucher_id INTO l_id;
    l_ids.EXTEND;  l_ids(l_ids.COUNT)   := l_id;
    l_nums.EXTEND; l_nums(l_nums.COUNT) := l_num;
  END LOOP;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.write('created', l_ids.COUNT);
  APEX_JSON.open_array('vouchers');
  FOR i IN 1 .. l_ids.COUNT LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('voucherId',     l_ids(i));
    APEX_JSON.write('voucherNumber', l_nums(i));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- VOUCHERS
    -- =========================================================================
    def_template('vouchers/');
    def_handler('vouchers/', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_limit  NUMBER        := LEAST(NVL(TO_NUMBER([COLON]limit DEFAULT NULL ON CONVERSION ERROR), 50), 200);
  l_offset NUMBER        := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_status VARCHAR2(20)  := UPPER([COLON]status);
  l_pstat  VARCHAR2(20)  := UPPER([COLON]paymentStatus);
  l_frl    NUMBER        := TO_NUMBER([COLON]freelancerId DEFAULT NULL ON CONVERSION ERROR);
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT COUNT(*) INTO l_total FROM dct_fl_voucher_v v
  WHERE (l_status IS NULL OR v.status = l_status)
    AND (l_pstat IS NULL OR v.payment_status = l_pstat)
    AND (l_frl IS NULL OR v.freelancer_id = l_frl);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total', l_total); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT * FROM dct_fl_voucher_v v
    WHERE (l_status IS NULL OR v.status = l_status)
      AND (l_pstat IS NULL OR v.payment_status = l_pstat)
      AND (l_frl IS NULL OR v.freelancer_id = l_frl)
    ORDER BY v.voucher_id DESC
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('voucherId',      r.voucher_id);
    APEX_JSON.write('voucherNumber',  r.voucher_number);
    APEX_JSON.write('contractNumber', r.contract_number);
    APEX_JSON.write('freelancerName', r.freelancer_name);
    APEX_JSON.write('periodLabel',    NVL(r.period_label, ''));
    APEX_JSON.write('dueDate',        TO_CHAR(r.due_date, 'YYYY-MM-DD'));
    APEX_JSON.write('amount',         r.amount);
    APEX_JSON.write('status',         r.status);
    APEX_JSON.write('paymentStatus',  r.payment_status);
    APEX_JSON.write('approvalInstanceId', r.approval_instance_id);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('vouchers/', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_id     NUMBER;
  l_num    VARCHAR2(50);
  l_sched  NUMBER;
  l_s      dct_fl_payment_schedule%ROWTYPE;
  l_con    dct_fl_contracts%ROWTYPE;
  l_open   NUMBER;
  l_desc   VARCHAR2(1000);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_sched := APEX_JSON.get_number(p_path => 'scheduleId');
  IF l_sched IS NULL THEN
    dct_rest.err(400,'scheduleId is required (vouchers are generated from payment schedule rows)'); RETURN;
  END IF;
  SELECT * INTO l_s FROM dct_fl_payment_schedule WHERE schedule_id = l_sched;
  IF l_s.status != 'PENDING' THEN
    dct_rest.err(400,'Schedule row is not PENDING (status: ' || l_s.status || ')'); RETURN;
  END IF;
  SELECT COUNT(*) INTO l_open FROM dct_fl_payment_vouchers
  WHERE schedule_id = l_sched AND status NOT IN ('REJECTED','CANCELLED');
  IF l_open > 0 THEN
    dct_rest.err(400,'A voucher already exists for this payment period'); RETURN;
  END IF;
  SELECT * INTO l_con FROM dct_fl_contracts WHERE contract_id = l_s.contract_id;
  l_num  := 'FL-VCH-' || TO_CHAR(seq_fl_voucher_number.NEXTVAL, 'FM000000');
  l_desc := NVL(dct_fl_pkg.get_setting('VOUCHER_DEFAULT_DESCRIPTION'),
                'Freelancer Payment - {CONTRACT_NUMBER} - {PERIOD_LABEL}');
  l_desc := REPLACE(REPLACE(l_desc, '{CONTRACT_NUMBER}', l_con.contract_number),
                    '{PERIOD_LABEL}', l_s.period_label);
  INSERT INTO dct_fl_payment_vouchers (
    voucher_number, contract_id, freelancer_id, schedule_id,
    period_label, due_date, amount,
    invoice_number, invoice_date,
    payment_method, pay_group, description,
    coding_type, cc_id_gl, project_number, task_number, expenditure_type,
    post_to_fusion, status, payment_status, created_by, updated_by
  ) VALUES (
    l_num, l_con.contract_id, l_con.freelancer_id, l_sched,
    l_s.period_label, l_s.due_date, l_s.amount,
    APEX_JSON.get_varchar2(p_path => 'invoiceNumber'),
    TO_DATE(APEX_JSON.get_varchar2(p_path => 'invoiceDate'), 'YYYY-MM-DD'),
    NVL(APEX_JSON.get_varchar2(p_path => 'paymentMethod'),
        NVL(dct_fl_pkg.get_setting('DEFAULT_PAYMENT_METHOD'), 'BANK_TRANSFER')),
    NVL(APEX_JSON.get_varchar2(p_path => 'payGroup'),
        NVL(dct_fl_pkg.get_setting('DEFAULT_PAY_GROUP'), 'FREELANCER')),
    l_desc,
    l_con.coding_type, l_con.cc_id_gl, l_con.project_number, l_con.task_number, l_con.expenditure_type,
    'N', 'DRAFT', 'PENDING', l_user, l_user
  ) RETURNING voucher_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('voucherId', l_id);
  APEX_JSON.write('voucherNumber', l_num);
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('vouchers/[COLON]id');
    def_handler('vouchers/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  FOR r IN (SELECT * FROM dct_fl_voucher_v WHERE voucher_id = [COLON]id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('voucherId',      r.voucher_id);
    APEX_JSON.write('voucherNumber',  r.voucher_number);
    APEX_JSON.write('contractId',     r.contract_id);
    APEX_JSON.write('contractNumber', r.contract_number);
    APEX_JSON.write('freelancerId',   r.freelancer_id);
    APEX_JSON.write('freelancerName', r.freelancer_name);
    APEX_JSON.write('scheduleId',     r.schedule_id);
    APEX_JSON.write('periodLabel',    NVL(r.period_label, ''));
    APEX_JSON.write('dueDate',        TO_CHAR(r.due_date, 'YYYY-MM-DD'));
    APEX_JSON.write('amount',         r.amount);
    APEX_JSON.write('invoiceNumber',  NVL(r.invoice_number, ''));
    APEX_JSON.write('invoiceDate',    TO_CHAR(r.invoice_date, 'YYYY-MM-DD'));
    APEX_JSON.write('paymentMethod',  r.payment_method);
    APEX_JSON.write('payGroup',       r.pay_group);
    APEX_JSON.write('description',    NVL(r.description, ''));
    APEX_JSON.write('codingType',     r.coding_type);
    APEX_JSON.write('ccIdGl',         r.cc_id_gl);
    APEX_JSON.write('projectNumber',  NVL(r.project_number, ''));
    APEX_JSON.write('taskNumber',     NVL(r.task_number, ''));
    APEX_JSON.write('expenditureType',NVL(r.expenditure_type, ''));
    APEX_JSON.write('postToFusion',   r.post_to_fusion);
    APEX_JSON.write('status',         r.status);
    APEX_JSON.write('paymentStatus',  r.payment_status);
    APEX_JSON.write('paymentDate',    TO_CHAR(r.payment_date, 'YYYY-MM-DD'));
    APEX_JSON.write('paymentReference', NVL(r.payment_reference, ''));
    APEX_JSON.write('approvalInstanceId', r.approval_instance_id);
    APEX_JSON.write('notes',          NVL(r.notes, ''));
    APEX_JSON.write('createdBy',      r.created_by);
    APEX_JSON.write('createdAt',      TO_CHAR(FROM_TZ(r.created_at, 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.write('updatedAt',      TO_CHAR(FROM_TZ(r.updated_at, 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.close_object;
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('vouchers/[COLON]id', 'PUT', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_status VARCHAR2(20);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT status INTO l_status FROM dct_fl_payment_vouchers WHERE voucher_id = [COLON]id;
  IF l_status != 'DRAFT' THEN
    dct_rest.err(400,'Voucher can only be edited in DRAFT status'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE dct_fl_payment_vouchers SET
    invoice_number = CASE WHEN APEX_JSON.does_exist(p_path => 'invoiceNumber')
                          THEN APEX_JSON.get_varchar2(p_path => 'invoiceNumber') ELSE invoice_number END,
    invoice_date   = CASE WHEN APEX_JSON.does_exist(p_path => 'invoiceDate')
                          THEN TO_DATE(APEX_JSON.get_varchar2(p_path => 'invoiceDate'),'YYYY-MM-DD') ELSE invoice_date END,
    payment_method = NVL(APEX_JSON.get_varchar2(p_path => 'paymentMethod'), payment_method),
    pay_group      = NVL(APEX_JSON.get_varchar2(p_path => 'payGroup'), pay_group),
    description    = CASE WHEN APEX_JSON.does_exist(p_path => 'description')
                          THEN APEX_JSON.get_varchar2(p_path => 'description') ELSE description END,
    post_to_fusion = NVL(APEX_JSON.get_varchar2(p_path => 'postToFusion'), post_to_fusion),
    notes          = CASE WHEN APEX_JSON.does_exist(p_path => 'notes')
                          THEN APEX_JSON.get_varchar2(p_path => 'notes') ELSE notes END,
    updated_by     = l_user, updated_at = SYSTIMESTAMP
  WHERE voucher_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('vouchers/[COLON]id/submit');
    def_handler('vouchers/[COLON]id/submit', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_fl_pkg.submit_voucher([COLON]id, dct_auth.get_user_id(l_user));
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE); APEX_JSON.write('status', 'SUBMITTED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('vouchers/[COLON]id/mark-paid');
    def_handler('vouchers/[COLON]id/mark-paid', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_status VARCHAR2(20);
  l_ref    VARCHAR2(100);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'FL_ADMIN') AND NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only FL Admin can confirm payments'); RETURN;
  END IF;
  SELECT status INTO l_status FROM dct_fl_payment_vouchers WHERE voucher_id = [COLON]id;
  IF l_status != 'APPROVED' THEN
    dct_rest.err(400,'Voucher must be APPROVED before it can be marked paid'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_ref := NVL(APEX_JSON.get_varchar2(p_path => 'paymentReference'), 'MANUAL-' || TO_CHAR(SYSDATE,'YYYYMMDD'));
  dct_fl_pkg.receive_fusion_callback(
    p_voucher_id        => [COLON]id,
    p_payment_date      => NVL(TO_DATE(APEX_JSON.get_varchar2(p_path => 'paymentDate'),'YYYY-MM-DD'), SYSDATE),
    p_payment_reference => l_ref);
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE); APEX_JSON.write('paymentStatus', 'PAID');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- DELIVERABLES
    -- =========================================================================
    def_template('deliverables/');
    def_handler('deliverables/', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_con    NUMBER       := TO_NUMBER([COLON]contractId DEFAULT NULL ON CONVERSION ERROR);
  l_status VARCHAR2(20) := UPPER([COLON]status);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM dct_fl_deliverable_v
            WHERE (l_con IS NULL OR contract_id = l_con)
              AND (l_status IS NULL OR status = l_status)
            ORDER BY deliverable_id DESC FETCH FIRST 200 ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('deliverableId',  r.deliverable_id);
    APEX_JSON.write('contractId',     r.contract_id);
    APEX_JSON.write('contractNumber', r.contract_number);
    APEX_JSON.write('freelancerName', r.freelancer_name);
    APEX_JSON.write('scheduleId',     r.schedule_id);
    APEX_JSON.write('periodLabel',    NVL(r.period_label, ''));
    APEX_JSON.write('title',          r.title);
    APEX_JSON.write('description',    NVL(r.description, ''));
    APEX_JSON.write('deliverableDate',TO_CHAR(r.deliverable_date, 'YYYY-MM-DD'));
    APEX_JSON.write('quantity',       r.quantity);
    APEX_JSON.write('unitName',       NVL(r.unit_name, ''));
    APEX_JSON.write('acceptedByName', NVL(r.accepted_by_name, ''));
    APEX_JSON.write('acceptedDate',   TO_CHAR(r.accepted_date, 'YYYY-MM-DD'));
    APEX_JSON.write('status',         r.status);
    APEX_JSON.write('rejectionReason',NVL(r.rejection_reason, ''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('deliverables/', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  INSERT INTO dct_fl_deliverables (
    contract_id, schedule_id, title, description, deliverable_date,
    quantity, unit_id, status, notes, created_by, updated_by
  ) VALUES (
    APEX_JSON.get_number(p_path   => 'contractId'),
    APEX_JSON.get_number(p_path   => 'scheduleId'),
    APEX_JSON.get_varchar2(p_path => 'title'),
    APEX_JSON.get_varchar2(p_path => 'description'),
    NVL(TO_DATE(APEX_JSON.get_varchar2(p_path => 'deliverableDate'),'YYYY-MM-DD'), SYSDATE),
    NVL(APEX_JSON.get_number(p_path => 'quantity'), 1),
    APEX_JSON.get_number(p_path   => 'unitId'),
    'SUBMITTED',
    APEX_JSON.get_varchar2(p_path => 'notes'),
    l_user, l_user
  ) RETURNING deliverable_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('deliverableId', l_id); APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('deliverables/[COLON]id/accept');
    def_handler('deliverables/[COLON]id/accept', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  UPDATE dct_fl_deliverables SET
    status = 'ACCEPTED', accepted_by = l_uid, accepted_date = SYSDATE,
    updated_by = l_user, updated_at = SYSTIMESTAMP
  WHERE deliverable_id = [COLON]id AND status = 'SUBMITTED';
  IF SQL%ROWCOUNT = 0 THEN
    dct_rest.err(400,'Deliverable is not in SUBMITTED status'); RETURN;
  END IF;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE); APEX_JSON.write('status', 'ACCEPTED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('deliverables/[COLON]id/reject');
    def_handler('deliverables/[COLON]id/reject', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_why  VARCHAR2(1000);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_why := APEX_JSON.get_varchar2(p_path => 'reason');
  IF l_why IS NULL THEN dct_rest.err(400,'A rejection reason is required'); RETURN; END IF;
  UPDATE dct_fl_deliverables SET
    status = 'REJECTED', rejection_reason = l_why,
    updated_by = l_user, updated_at = SYSTIMESTAMP
  WHERE deliverable_id = [COLON]id AND status = 'SUBMITTED';
  IF SQL%ROWCOUNT = 0 THEN
    dct_rest.err(400,'Deliverable is not in SUBMITTED status'); RETURN;
  END IF;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE); APEX_JSON.write('status', 'REJECTED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- DOCUMENTS (unified dct_documents; reference_id = freelancer_id)
    -- =========================================================================
    def_template('documents/');
    def_handler('documents/', 'GET', q'!
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
    APEX_JSON.write('expiryDate',    TO_CHAR(r.expiry_date, 'YYYY-MM-DD'));
    APEX_JSON.write('expiryStatus',  r.expiry_status);
    APEX_JSON.write('daysToExpiry',  r.days_to_expiry);
    APEX_JSON.write('isRequired',    r.is_required);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('documents/', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
  l_id   NUMBER;
  l_alert NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);
  l_alert := NVL(TO_NUMBER(dct_fl_pkg.get_setting('DOC_EXPIRY_ALERT_DAYS') DEFAULT NULL ON CONVERSION ERROR), 30);
  INSERT INTO dct_documents (
    source_module, source_type, source_id, reference_id, doc_type_id,
    file_name, mime_type, expiry_date, alert_days_before,
    status, is_required, notes, is_active, created_by
  ) VALUES (
    'FL',
    NVL(APEX_JSON.get_varchar2(p_path => 'sourceType'), 'FREELANCER'),
    NVL(APEX_JSON.get_number(p_path => 'sourceId'),
        APEX_JSON.get_number(p_path => 'freelancerId')),
    APEX_JSON.get_number(p_path   => 'freelancerId'),
    APEX_JSON.get_number(p_path   => 'docTypeId'),
    NVL(APEX_JSON.get_varchar2(p_path => 'documentName'), 'document'),
    APEX_JSON.get_varchar2(p_path => 'mimeType'),
    TO_DATE(APEX_JSON.get_varchar2(p_path => 'expiryDate'), 'YYYY-MM-DD'),
    l_alert,
    'ACTIVE',
    NVL(APEX_JSON.get_varchar2(p_path => 'isRequired'), 'N'),
    APEX_JSON.get_varchar2(p_path => 'notes'),
    'Y', l_uid
  ) RETURNING doc_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('documentId', l_id); APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('documents/[COLON]id/file');
    def_handler('documents/[COLON]id/file', 'PUT', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_uid   NUMBER;
  v_blob  BLOB;
  v_raw   RAW(32767);
  v_b64   VARCHAR2(32767) := [COLON]file_data_b64;
  v_len   NUMBER; v_pos NUMBER := 1; v_chunk NUMBER := 32764;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF v_b64 IS NULL THEN dct_rest.err(400,'file_data_b64 is required'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  DBMS_LOB.CREATETEMPORARY(v_blob, TRUE);
  v_len := LENGTH(v_b64);
  WHILE v_pos <= v_len LOOP
    v_raw := UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(SUBSTR(v_b64, v_pos, v_chunk)));
    DBMS_LOB.WRITEAPPEND(v_blob, UTL_RAW.LENGTH(v_raw), v_raw);
    v_pos := v_pos + v_chunk;
  END LOOP;
  UPDATE dct_documents SET
    file_blob = v_blob,
    mime_type = NVL([COLON]mime_type, mime_type),
    file_size_bytes = DBMS_LOB.GETLENGTH(v_blob),
    updated_by = l_uid, updated_at = SYSTIMESTAMP
  WHERE doc_id = [COLON]id AND source_module = 'FL';
  COMMIT;
  DBMS_LOB.FREETEMPORARY(v_blob);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');
    def_media('documents/[COLON]id/file',
      q'!SELECT mime_type, file_blob FROM dct_documents WHERE doc_id = [COLON]id AND source_module = 'FL'!');

    -- =========================================================================
    -- PROFILE CHANGE REQUESTS
    -- =========================================================================
    def_template('profile-changes/');
    def_handler('profile-changes/', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_frl    NUMBER       := TO_NUMBER([COLON]freelancerId DEFAULT NULL ON CONVERSION ERROR);
  l_status VARCHAR2(20) := UPPER([COLON]status);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT pcr.*, f.first_name_en || ' ' || f.last_name_en AS freelancer_name
            FROM dct_fl_profile_change_requests pcr
            JOIN dct_fl_freelancers f ON f.freelancer_id = pcr.freelancer_id
            WHERE (l_frl IS NULL OR pcr.freelancer_id = l_frl)
              AND (l_status IS NULL OR pcr.status = l_status)
            ORDER BY pcr.change_request_id DESC FETCH FIRST 200 ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('changeRequestId', r.change_request_id);
    APEX_JSON.write('freelancerId',    r.freelancer_id);
    APEX_JSON.write('freelancerName',  r.freelancer_name);
    APEX_JSON.write('changeType',      r.change_type);
    APEX_JSON.write('currentValue',    NVL(r.current_value, ''));
    APEX_JSON.write('requestedValue',  NVL(r.requested_value, ''));
    APEX_JSON.write('reason',          NVL(r.reason, ''));
    APEX_JSON.write('status',          r.status);
    APEX_JSON.write('approvalInstanceId', r.approval_instance_id);
    APEX_JSON.write('createdAt',       TO_CHAR(FROM_TZ(r.created_at, 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('profile-changes/', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  INSERT INTO dct_fl_profile_change_requests (
    freelancer_id, change_type, current_value, requested_value, reason,
    status, created_by, updated_by
  ) VALUES (
    APEX_JSON.get_number(p_path   => 'freelancerId'),
    APEX_JSON.get_varchar2(p_path => 'changeType'),
    APEX_JSON.get_varchar2(p_path => 'currentValue'),
    APEX_JSON.get_varchar2(p_path => 'requestedValue'),
    APEX_JSON.get_varchar2(p_path => 'reason'),
    'DRAFT', l_user, l_user
  ) RETURNING change_request_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('changeRequestId', l_id); APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('profile-changes/[COLON]id/submit');
    def_handler('profile-changes/[COLON]id/submit', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_fl_pkg.submit_profile_change([COLON]id, dct_auth.get_user_id(l_user));
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE); APEX_JSON.write('status', 'SUBMITTED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- APPROVALS (FL scope; delegation-aware)
    -- =========================================================================
    def_template('approvals/pending');
    def_handler('approvals/pending', 'GET', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_uid   NUMBER;
  l_roles VARCHAR2(4000);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid   := dct_auth.get_user_id(l_user);
  l_roles := ',' || dct_auth.get_user_roles(l_user) || ',';
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT ai.instance_id, ai.source_module, ai.source_record_ref,
           ai.submitted_at, t.template_name, ast.step_name,
           rol.role_code AS required_role,
           sub.display_name AS submitted_by_name,
           (SELECT COUNT(*) FROM dct_approval_steps s2 WHERE s2.template_id = ai.template_id) AS total_steps,
           (SELECT COUNT(*) FROM dct_approval_steps s3 WHERE s3.template_id = ai.template_id
             AND s3.step_seq <= ai.current_step_seq) AS current_step,
           NVL(CASE ai.source_module
             WHEN 'FL_CONTRACT'  THEN (SELECT total_amount     FROM dct_fl_contracts            WHERE contract_id      = ai.source_record_id)
             WHEN 'FL_AMENDMENT' THEN (SELECT new_total_amount FROM dct_fl_contract_amendments  WHERE amendment_id     = ai.source_record_id)
             WHEN 'FL_VOUCHER'   THEN (SELECT amount           FROM dct_fl_payment_vouchers     WHERE voucher_id       = ai.source_record_id)
             WHEN 'FL_RENEWAL'   THEN (SELECT new_total_amount FROM dct_fl_contract_renewals    WHERE renewal_id       = ai.source_record_id)
           END, 0) AS amount,
           CASE WHEN INSTR(l_roles, ',' || rol.role_code || ',') > 0
                  OR INSTR(l_roles, ',SYS_ADMIN,') > 0
                THEN NULL
                ELSE (SELECT MAX(du.display_name)
                      FROM dct_delegations dg
                      JOIN dct_user_roles ur2 ON ur2.user_id = dg.delegator_id
                                             AND ur2.role_id = rol.role_id AND ur2.is_active = 'Y'
                      JOIN dct_users du ON du.user_id = dg.delegator_id
                      WHERE dg.delegate_id = l_uid AND dg.status = 'ACTIVE'
                        AND TRUNC(SYSDATE) BETWEEN dg.start_date AND dg.end_date
                        AND (dg.scope = 'ALL_ROLES'
                             OR (dg.scope = 'SPECIFIC_ROLE' AND dg.role_id = rol.role_id)
                             OR (dg.scope = 'MODULE' AND dg.module_id = t.module_id)))
           END AS acting_for
    FROM   dct_approval_instances ai
    JOIN   dct_approval_templates t   ON t.template_id   = ai.template_id
    JOIN   dct_approval_steps     ast ON ast.template_id = ai.template_id
                                     AND ast.step_seq    = ai.current_step_seq
    JOIN   dct_roles              rol ON rol.role_id     = ast.required_role_id
    JOIN   dct_users              sub ON sub.user_id     = ai.submitted_by
    WHERE  ai.overall_status = 'PENDING'
      AND  ai.source_module IN ('FL_REGISTRATION','FL_CONTRACT','FL_AMENDMENT',
                                'FL_VOUCHER','FL_RENEWAL','FL_PROFILE_CHANGE')
      AND (INSTR(l_roles, ',' || rol.role_code || ',') > 0
           OR INSTR(l_roles, ',SYS_ADMIN,') > 0
           OR EXISTS (
                SELECT 1 FROM dct_delegations dg
                JOIN dct_user_roles ur2 ON ur2.user_id = dg.delegator_id
                                       AND ur2.role_id = rol.role_id AND ur2.is_active = 'Y'
                WHERE dg.delegate_id = l_uid AND dg.status = 'ACTIVE'
                  AND TRUNC(SYSDATE) BETWEEN dg.start_date AND dg.end_date
                  AND (dg.scope = 'ALL_ROLES'
                       OR (dg.scope = 'SPECIFIC_ROLE' AND dg.role_id = rol.role_id)
                       OR (dg.scope = 'MODULE' AND dg.module_id = t.module_id))))
    ORDER BY ai.submitted_at
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('instanceId',      r.instance_id);
    APEX_JSON.write('requestRef',      NVL(r.source_record_ref, '-'));
    APEX_JSON.write('module',          r.source_module);
    APEX_JSON.write('templateName',    NVL(r.template_name, '-'));
    APEX_JSON.write('requestedBy',     NVL(r.submitted_by_name, '-'));
    APEX_JSON.write('requestedAt',     TO_CHAR(r.submitted_at,'YYYY-MM-DD HH24:MI'));
    APEX_JSON.write('amount',          r.amount);
    APEX_JSON.write('currentStep',     NVL(r.current_step, 1));
    APEX_JSON.write('totalSteps',      NVL(r.total_steps, 1));
    APEX_JSON.write('currentStepName', NVL(r.step_name, '-'));
    APEX_JSON.write('actingFor',       r.acting_for);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('approvals/[COLON]id/action');
    def_handler('approvals/[COLON]id/action', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  dct_fl_pkg.act_on_approval(
    p_instance_id => [COLON]id,
    p_user_id     => dct_auth.get_user_id(l_user),
    p_action      => APEX_JSON.get_varchar2(p_path => 'action'),
    p_comments    => APEX_JSON.get_varchar2(p_path => 'comments'));
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- LOOKUPS (combined reference data for the FL UI)
    -- =========================================================================
    def_template('lookups');
    def_handler('lookups', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  PROCEDURE emit_cat(p_json IN VARCHAR2, p_cat IN VARCHAR2) IS
  BEGIN
    APEX_JSON.open_array(p_json);
    FOR r IN (SELECT lv.value_id, lv.value_code, lv.value_name_en
              FROM dct_lookup_values lv
              JOIN dct_lookup_categories lc ON lc.category_id = lv.category_id
              WHERE lc.category_code = p_cat AND lv.is_active = 'Y'
              ORDER BY lv.display_order, lv.value_name_en) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('valueId', r.value_id);
      APEX_JSON.write('code',    r.value_code);
      APEX_JSON.write('name',    r.value_name_en);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  emit_cat('billingUnits',   'FL_BILLING_UNIT');
  emit_cat('paymentMethods', 'FL_PAYMENT_METHOD');
  emit_cat('payGroups',      'FL_PAY_GROUP');
  APEX_JSON.open_array('nationalities');
  FOR r IN (SELECT nationality_code, nationality_en FROM dct_nationality ORDER BY nationality_en) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.nationality_code);
    APEX_JSON.write('name', r.nationality_en);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('orgs');
  FOR r IN (SELECT org_id, org_name_en FROM dct_organizations
            WHERE is_active = 'Y' ORDER BY org_name_en) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('orgId', r.org_id);
    APEX_JSON.write('name',  r.org_name_en);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('docTypes');
  FOR r IN (SELECT doc_type_id, doc_type_code, doc_type_name_en FROM dct_document_types
            ORDER BY doc_type_name_en) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('docTypeId', r.doc_type_id);
    APEX_JSON.write('code',      r.doc_type_code);
    APEX_JSON.write('name',      r.doc_type_name_en);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- GL CODES (same raw-array shape as the PC module)
    -- =========================================================================
    def_template('gl-codes');
    def_handler('gl-codes', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_array;
  FOR r IN (SELECT cc_id, cc_code, is_active FROM dct_gl_code_combinations ORDER BY cc_id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('ccId',     r.cc_id);
    APEX_JSON.write('ccCode',   r.cc_code);
    APEX_JSON.write('isActive', r.is_active);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- MODULE SETTINGS
    -- =========================================================================
    def_template('settings');
    def_handler('settings', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT ms.setting_id, ms.setting_key, ms.setting_value, ms.setting_label,
           ms.setting_description, ms.value_type, ms.allowed_values, ms.default_value
    FROM   dct_module_settings ms
    JOIN   dct_modules m ON m.module_id = ms.module_id
    WHERE  m.module_code = 'FREELANCERS'
    ORDER BY ms.setting_key
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('settingId',   r.setting_id);
    APEX_JSON.write('key',         r.setting_key);
    APEX_JSON.write('value',       r.setting_value);
    APEX_JSON.write('label',       NVL(r.setting_label, r.setting_key));
    APEX_JSON.write('description', NVL(r.setting_description, ''));
    APEX_JSON.write('type',        NVL(r.value_type, 'TEXT'));
    APEX_JSON.write('allowed',     NVL(r.allowed_values, ''));
    APEX_JSON.write('defaultValue',NVL(r.default_value, ''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('settings/[COLON]id');
    def_handler('settings/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'FL_ADMIN') AND NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only FL Admin can change module settings'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE dct_module_settings SET
    setting_value = APEX_JSON.get_varchar2(p_path => 'value'),
    updated_at    = SYSTIMESTAMP
  WHERE setting_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- NOTIFICATIONS (per-user; same shape as the PC module)
    -- =========================================================================
    def_template('notifications/');
    def_handler('notifications/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT notification_id, title_en, body_en, notification_type, is_read, created_at
    FROM   dct_notifications
    WHERE  recipient_user_id = l_uid
      AND  (expires_at IS NULL OR expires_at > SYSTIMESTAMP)
    ORDER BY created_at DESC FETCH FIRST 50 ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('notifId',   r.notification_id);
    APEX_JSON.write('title',     r.title_en);
    APEX_JSON.write('body',      r.body_en);
    APEX_JSON.write('type',      r.notification_type);
    APEX_JSON.write('isRead',    r.is_read);
    APEX_JSON.write('createdAt', TO_CHAR(r.created_at,'YYYY-MM-DD"T"HH24":"MI":"SS'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('notifications/[COLON]id/read');
    def_handler('notifications/[COLON]id/read', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  UPDATE dct_notifications SET is_read = 'Y' WHERE notification_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('notifications/mark-all-read');
    def_handler('notifications/mark-all-read', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  UPDATE dct_notifications SET is_read = 'Y'
  WHERE recipient_user_id = l_uid AND is_read = 'N';
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- PORTAL (freelancer self-service, Phase 1)
    -- Portal sessions live in dct_fl_portal_sessions, NOT dct_sessions -- an
    -- external freelancer can never hold a staff session. Every protected
    -- portal handler resolves freelancer_id from dct_fl_portal_pkg, never
    -- from the client.
    -- =========================================================================

    def_template('portal/auth/login');
    def_handler('portal/auth/login', 'POST', q'!
DECLARE
  l_email VARCHAR2(200);
  l_pwd   VARCHAR2(200);
  l_token VARCHAR2(64);
BEGIN
  IF NVL(dct_fl_pkg.get_setting('FEATURE_FL_PORTAL'),'N') != 'Y' THEN
    dct_rest.err(503,'The freelancer portal is not enabled'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_email := APEX_JSON.get_varchar2(p_path => 'email');
  l_pwd   := APEX_JSON.get_varchar2(p_path => 'password');
  l_token := dct_fl_portal_pkg.login(l_email, l_pwd);
  IF l_token IS NULL THEN
    dct_rest.err(401,'Invalid e-mail or password'); RETURN;
  END IF;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('token', l_token);
  FOR r IN (SELECT first_name_en || ' ' || last_name_en AS dn, vendor_number, email
            FROM dct_fl_freelancers
            WHERE LOWER(email) = LOWER(TRIM(l_email)) AND ROWNUM = 1) LOOP
    APEX_JSON.write('displayName',  r.dn);
    APEX_JSON.write('vendorNumber', NVL(r.vendor_number, ''));
    APEX_JSON.write('email',        r.email);
  END LOOP;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('portal/auth/set-password');
    def_handler('portal/auth/set-password', 'POST', q'!
DECLARE
  l_token VARCHAR2(64);
  l_pwd   VARCHAR2(200);
BEGIN
  IF NVL(dct_fl_pkg.get_setting('FEATURE_FL_PORTAL'),'N') != 'Y' THEN
    dct_rest.err(503,'The freelancer portal is not enabled'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_token := APEX_JSON.get_varchar2(p_path => 'token');
  l_pwd   := APEX_JSON.get_varchar2(p_path => 'password');
  dct_fl_portal_pkg.set_password(l_token, l_pwd);
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  dct_rest.err(400, REGEXP_REPLACE(SQLERRM, '^ORA-[0-9]+: ', ''));
END;
!');

    def_template('portal/auth/logout');
    def_handler('portal/auth/logout', 'POST', q'!
DECLARE
  l_hdr VARCHAR2(4000);
BEGIN
  l_hdr := OWA_UTIL.get_cgi_env('AUTHORIZATION');
  IF l_hdr IS NULL THEN l_hdr := OWA_UTIL.get_cgi_env('HTTP_AUTHORIZATION'); END IF;
  IF l_hdr LIKE 'Bearer %' THEN
    dct_fl_portal_pkg.logout(TRIM(SUBSTR(l_hdr, 8)));
    COMMIT;
  END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('portal/me');
    def_handler('portal/me', 'GET', q'!
DECLARE
  l_frl NUMBER := dct_fl_portal_pkg.validate_bearer;
BEGIN
  IF l_frl IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  FOR r IN (SELECT first_name_en, last_name_en, first_name_ar, last_name_ar,
                   vendor_number, email, mobile, specialization
            FROM dct_fl_freelancers WHERE freelancer_id = l_frl) LOOP
    APEX_JSON.write('displayName',    r.first_name_en || ' ' || r.last_name_en);
    APEX_JSON.write('displayNameAr',  NVL(r.first_name_ar || ' ' || r.last_name_ar, ''));
    APEX_JSON.write('vendorNumber',   NVL(r.vendor_number, ''));
    APEX_JSON.write('email',          r.email);
    APEX_JSON.write('mobile',         NVL(r.mobile, ''));
    APEX_JSON.write('specialization', NVL(r.specialization, ''));
  END LOOP;
  FOR r IN (SELECT bank_name, account_number, iban
            FROM dct_fl_bank_accounts
            WHERE freelancer_id = l_frl AND is_primary = 'Y' AND ROWNUM = 1) LOOP
    APEX_JSON.write('bankName', r.bank_name);
    APEX_JSON.write('ibanTail', SUBSTR(NVL(r.iban, r.account_number), -4));
  END LOOP;
  FOR r IN (SELECT COUNT(*) AS n,
                   NVL(SUM(CASE WHEN status = 'ACTIVE' THEN 1 ELSE 0 END), 0) AS act
            FROM dct_fl_contracts WHERE freelancer_id = l_frl) LOOP
    APEX_JSON.write('contracts',       r.n);
    APEX_JSON.write('activeContracts', r.act);
  END LOOP;
  FOR r IN (
    SELECT s.period_label, s.due_date, s.amount, s.status,
           c.contract_number, NVL(v.status, ' ') AS voucher_status
    FROM dct_fl_payment_schedule s
    JOIN dct_fl_contracts c ON c.contract_id = s.contract_id
    LEFT JOIN dct_fl_payment_vouchers v ON v.voucher_id = s.voucher_id
    WHERE c.freelancer_id = l_frl
      AND s.status IN ('PENDING','VOUCHER_GENERATED')
    ORDER BY s.due_date
    FETCH FIRST 1 ROWS ONLY
  ) LOOP
    APEX_JSON.open_object('nextPayment');
    APEX_JSON.write('periodLabel',    r.period_label);
    APEX_JSON.write('dueDate',        TO_CHAR(r.due_date, 'YYYY-MM-DD'));
    APEX_JSON.write('amount',         r.amount);
    APEX_JSON.write('status',         r.status);
    APEX_JSON.write('voucherStatus',  TRIM(r.voucher_status));
    APEX_JSON.write('contractNumber', r.contract_number);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('portal/contracts');
    def_handler('portal/contracts', 'GET', q'!
DECLARE
  l_frl NUMBER := dct_fl_portal_pkg.validate_bearer;
BEGIN
  IF l_frl IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT contract_number, title, status, start_date, end_date,
           total_amount, currency_code, billing_method,
           scheduled_total, paid_total
    FROM dct_fl_contract_v
    WHERE freelancer_id = l_frl
    ORDER BY start_date DESC, contract_id DESC
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('contractNumber', r.contract_number);
    APEX_JSON.write('title',          r.title);
    APEX_JSON.write('status',         r.status);
    APEX_JSON.write('startDate',      TO_CHAR(r.start_date, 'YYYY-MM-DD'));
    APEX_JSON.write('endDate',        TO_CHAR(r.end_date,   'YYYY-MM-DD'));
    APEX_JSON.write('totalAmount',    r.total_amount);
    APEX_JSON.write('currency',       NVL(r.currency_code, 'AED'));
    APEX_JSON.write('billingMethod',  NVL(r.billing_method, ' '));
    APEX_JSON.write('scheduledTotal', r.scheduled_total);
    APEX_JSON.write('paidTotal',      r.paid_total);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('portal/schedule');
    def_handler('portal/schedule', 'GET', q'!
DECLARE
  l_frl NUMBER := dct_fl_portal_pkg.validate_bearer;
  l_con VARCHAR2(50) := [COLON]contractNumber;
BEGIN
  IF l_frl IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT s.period_label, s.due_date, s.amount, s.status,
           s.contract_number, NVL(v.status, ' ') AS voucher_status,
           NVL(v.payment_status, ' ') AS payment_status
    FROM dct_fl_payment_schedule_v s
    LEFT JOIN dct_fl_payment_vouchers v ON v.voucher_id = s.voucher_id
    WHERE s.freelancer_id = l_frl
      AND (l_con IS NULL OR s.contract_number = l_con)
    ORDER BY s.due_date
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('periodLabel',    r.period_label);
    APEX_JSON.write('dueDate',        TO_CHAR(r.due_date, 'YYYY-MM-DD'));
    APEX_JSON.write('amount',         r.amount);
    APEX_JSON.write('status',         r.status);
    APEX_JSON.write('voucherStatus',  TRIM(r.voucher_status));
    APEX_JSON.write('paymentStatus',  TRIM(r.payment_status));
    APEX_JSON.write('contractNumber', r.contract_number);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('portal/vouchers');
    def_handler('portal/vouchers', 'GET', q'!
DECLARE
  l_frl NUMBER := dct_fl_portal_pkg.validate_bearer;
BEGIN
  IF l_frl IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT voucher_number, period_label, due_date, amount,
           status, payment_status, contract_number
    FROM dct_fl_voucher_v
    WHERE freelancer_id = l_frl
    ORDER BY voucher_id DESC
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('voucherNumber',  r.voucher_number);
    APEX_JSON.write('periodLabel',    NVL(r.period_label, ' '));
    APEX_JSON.write('dueDate',        TO_CHAR(r.due_date, 'YYYY-MM-DD'));
    APEX_JSON.write('amount',         r.amount);
    APEX_JSON.write('status',         r.status);
    APEX_JSON.write('paymentStatus',  r.payment_status);
    APEX_JSON.write('contractNumber', r.contract_number);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- staff side: FL_ADMIN invites a freelancer to the portal
    def_template('freelancers/[COLON]id/portal-invite');
    def_handler('freelancers/[COLON]id/portal-invite', 'POST', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_token VARCHAR2(64);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT (dct_auth.has_role(l_user, 'FL_ADMIN') OR dct_auth.has_role(l_user, 'SYS_ADMIN')) THEN
    dct_rest.err(403,'FL_ADMIN role required'); RETURN;
  END IF;
  l_token := dct_fl_portal_pkg.create_invite([COLON]id, l_user);
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.write('token', l_token);
  APEX_JSON.write('setPasswordPath', '/FL/Portal/index.html#set-password=' || l_token);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  dct_rest.err(400, REGEXP_REPLACE(SQLERRM, '^ORA-[0-9]+: ', ''));
END;
!');

    COMMIT;
END setup_fl_ords_tmp;
/

BEGIN
    setup_fl_ords_tmp;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP PROCEDURE setup_fl_ords_tmp';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

PROMPT ============================================================
PROMPT  08_fl_ords.sql complete.
PROMPT  Base URL: /ords/admin/fl/
PROMPT  Endpoints: dashboard, registrations, freelancers, bank-accounts,
PROMPT             contracts, amendments, renewals, schedule, vouchers,
PROMPT             deliverables, documents, profile-changes, approvals,
PROMPT             lookups, gl-codes, settings, notifications
PROMPT ============================================================
