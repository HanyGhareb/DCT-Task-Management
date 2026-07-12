-- =============================================================================
-- i-Finance V2 -- AR Customer -- ORDS endpoints (ADDITIVE to ar.rest)
-- File    : 10_ar_customer_ords.sql
-- Run as  : ADMIN schema (sql -name prod_mcp) -- FRESH SESSION
--           (never after ALTER SESSION SET CURRENT_SCHEMA = PROD -> ORA-01471)
-- Depends : 05_ar_ords.sql (module ar.rest), 08 + 09 (table + package)
-- NOTE    : 05 rebuilds ar.rest with DELETE_MODULE -- RE-RUN THIS SCRIPT (10)
--           after any re-run of 05. Templates here are NEW patterns only, so
--           running 10 never disturbs the handlers defined in 05.
-- =============================================================================
-- Endpoints (base /ords/admin/ar/):
--   GET    customers/            list submissions (paged; status/search filters)
--   POST   customers/            create draft (body = full WS attribute object)
--   GET    customers/:id         single row incl. payload + ws request/response
--   PUT    customers/:id         update DRAFT/ERROR row
--   DELETE customers/:id         soft-delete DRAFT row
--   POST   customers/:id/submit  send to Fusion gateway (or mock)
--   POST   customers/:id/sync    poll Fusion for PROCESSED + capture code
--   GET    customers/wssearch    live gateway customer query (dup check)
--   GET    customers/lovs        all AR_CUST_* value sets + countries + ws flags
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = ADMIN;
SET DEFINE OFF
SET SQLBLANKLINES ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- 1. Synonyms (new objects; platform ones exist from 05)
-- =============================================================================
CREATE OR REPLACE SYNONYM dct_ar_customers FOR prod.dct_ar_customers;
CREATE OR REPLACE SYNONYM dct_ar_ws_pkg    FOR prod.dct_ar_ws_pkg;
CREATE OR REPLACE SYNONYM dct_countries    FOR prod.dct_countries;

-- =============================================================================
-- 2. Templates + handlers (additive)
-- =============================================================================
CREATE OR REPLACE PROCEDURE setup_ar_cust_ords_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'ar.rest';

    PROCEDURE def_tpl (p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => p_pattern);
    END;

    PROCEDURE def_plsql (p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => p_pattern,
            p_method      => p_method,
            p_source_type => ORDS.source_type_plsql,
            p_source      => p_source
        );
    END;

BEGIN

    -- =========================================================================
    -- CUSTOMERS -- list / create draft
    -- =========================================================================
    def_tpl('customers/');
    def_plsql('customers/', 'GET', q'[
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER(:limit DEFAULT NULL ON CONVERSION ERROR), 25), 200);
  l_offset NUMBER := GREATEST(NVL(TO_NUMBER(:offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;

  SELECT COUNT(*) INTO l_total
  FROM   dct_ar_customers c
  WHERE  c.is_active = 'Y'
  AND    (:status IS NULL OR c.ws_status = :status)
  AND    (:search IS NULL OR UPPER(c.customer_name || ' ' || NVL(c.customer_name_ar,'') || ' ' ||
                                   NVL(c.legacy_customer_number,'') || ' ' ||
                                   NVL(c.trade_license_num,'') || ' ' ||
                                   NVL(c.fusion_customer_code,'') || ' ' || NVL(c.vat_number,''))
                             LIKE '%' || UPPER(:search) || '%');

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total',  l_total);
  APEX_JSON.write('limit',  l_limit);
  APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT c.customer_id, c.trx_oper, c.customer_type, c.customer_name, c.customer_name_ar,
           c.customer_class_name, c.emirate, c.city, c.site_code, c.trade_license_num,
           c.legacy_customer_number, c.vat_number, c.ws_status, c.ws_env,
           c.fusion_customer_code, c.fusion_site_number, c.error_message,
           TO_CHAR(dct_to_local(c.submitted_at), 'YYYY-MM-DD HH:MI AM') AS submitted_disp,
           TO_CHAR(dct_to_local(c.processed_at), 'YYYY-MM-DD HH:MI AM') AS processed_disp,
           TO_CHAR(dct_to_local(c.created_at),   'YYYY-MM-DD HH:MI AM') AS created_disp,
           c.created_by
    FROM   dct_ar_customers c
    WHERE  c.is_active = 'Y'
    AND    (:status IS NULL OR c.ws_status = :status)
    AND    (:search IS NULL OR UPPER(c.customer_name || ' ' || NVL(c.customer_name_ar,'') || ' ' ||
                                     NVL(c.legacy_customer_number,'') || ' ' ||
                                     NVL(c.trade_license_num,'') || ' ' ||
                                     NVL(c.fusion_customer_code,'') || ' ' || NVL(c.vat_number,''))
                               LIKE '%' || UPPER(:search) || '%')
    ORDER  BY c.customer_id DESC
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id',            r.customer_id);
    APEX_JSON.write('trxOper',       r.trx_oper);
    APEX_JSON.write('customerType',  r.customer_type);
    APEX_JSON.write('name',          r.customer_name);
    APEX_JSON.write('nameAr',        r.customer_name_ar);
    APEX_JSON.write('className',     r.customer_class_name);
    APEX_JSON.write('emirate',       r.emirate);
    APEX_JSON.write('city',          r.city);
    APEX_JSON.write('siteCode',      r.site_code);
    APEX_JSON.write('tradeLicense',  r.trade_license_num);
    APEX_JSON.write('legacyNumber',  r.legacy_customer_number);
    APEX_JSON.write('vatNumber',     r.vat_number);
    APEX_JSON.write('status',        r.ws_status);
    APEX_JSON.write('wsEnv',         r.ws_env);
    APEX_JSON.write('fusionCode',    r.fusion_customer_code);
    APEX_JSON.write('fusionSite',    r.fusion_site_number);
    APEX_JSON.write('errorMessage',  r.error_message);
    APEX_JSON.write('submittedAt',   r.submitted_disp);
    APEX_JSON.write('processedAt',   r.processed_disp);
    APEX_JSON.write('createdAt',     r.created_disp);
    APEX_JSON.write('createdBy',     r.created_by);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION
  WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    def_plsql('customers/', 'POST', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_blob BLOB := :body;   -- deref :body exactly ONCE (binds as BLOB on this ORDS)
  l_body CLOB;
  l_id   NUMBER;
  l_uid  NUMBER;
  l_new  CLOB;
  l_oper VARCHAR2(40);
  l_type VARCHAR2(30);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_blob IS NULL OR dbms_lob.getlength(l_blob) = 0 THEN
    dct_rest.err(400, 'Body required'); RETURN;
  END IF;
  DECLARE
    l_doff INTEGER := 1; l_soff INTEGER := 1;
    l_ctx  INTEGER := dbms_lob.default_lang_ctx; l_warn INTEGER;
  BEGIN
    dbms_lob.createtemporary(l_body, TRUE);
    dbms_lob.converttoclob(l_body, l_blob, dbms_lob.lobmaxsize,
                           l_doff, l_soff, dbms_lob.default_csid, l_ctx, l_warn);
  END;
  APEX_JSON.parse(l_body);

  IF APEX_JSON.get_varchar2(p_path => 'CUSTOMER_NAME') IS NULL THEN
    dct_rest.err(400, 'CUSTOMER_NAME is required'); RETURN;
  END IF;
  l_oper := NVL(APEX_JSON.get_varchar2(p_path => 'TRX_OPER'), 'CREATE');
  l_type := NVL(APEX_JSON.get_varchar2(p_path => 'CUSTOMER_TYPE'), 'ORGANIZATION');
  dct_lookup_pkg.validate_lookup('AR_CUST_TRX_OPER', l_oper);
  dct_lookup_pkg.validate_lookup('AR_CUST_TYPE',     l_type);

  INSERT INTO dct_ar_customers (
    trx_oper, customer_type, customer_name, customer_name_ar,
    customer_class_name, customer_category_name, country_code, emirate, city,
    site_name, site_code, trade_license_num, legacy_customer_number,
    legacy_site_number, contact_person, contact_number, email_address,
    vat_number, payload_json, created_by
  ) VALUES (
    l_oper, l_type,
    APEX_JSON.get_varchar2(p_path => 'CUSTOMER_NAME'),
    APEX_JSON.get_varchar2(p_path => 'CUSTOMER_NAME_AR'),
    APEX_JSON.get_varchar2(p_path => 'CUSTOMER_CLASS_NAME'),
    APEX_JSON.get_varchar2(p_path => 'CUSTOMER_CATEGORY_NAME'),
    APEX_JSON.get_varchar2(p_path => 'COUNTRY_CODE'),
    APEX_JSON.get_varchar2(p_path => 'EMIRATE'),
    APEX_JSON.get_varchar2(p_path => 'CITY'),
    APEX_JSON.get_varchar2(p_path => 'SITE_NAME'),
    APEX_JSON.get_varchar2(p_path => 'SITE_CODE'),
    APEX_JSON.get_varchar2(p_path => 'TRADE_LICENSE_NUM'),
    APEX_JSON.get_varchar2(p_path => 'LEGACY_CUSTOMER_NUMBER'),
    APEX_JSON.get_varchar2(p_path => 'LEGACY_CUSTOMER_SITE_NUMBER'),
    APEX_JSON.get_varchar2(p_path => 'CONTACT_PERSON'),
    APEX_JSON.get_varchar2(p_path => 'CONTACT_NUMBER'),
    APEX_JSON.get_varchar2(p_path => 'EMAIL_ADDRESS'),
    APEX_JSON.get_varchar2(p_path => 'VAT_NUMBER'),
    l_body, l_user
  ) RETURNING customer_id INTO l_id;

  SELECT user_id INTO l_uid FROM dct_users WHERE UPPER(username) = UPPER(l_user);
  INSERT INTO dct_request_status_history
    (source_module, source_type, source_id, old_status, new_status, changed_by, comments)
  VALUES ('AR', 'CUSTOMER', l_id, NULL, 'DRAFT', l_uid, 'Customer submission drafted');
  COMMIT;

  l_new := dct_audit_pkg.snap('DCT_AR_CUSTOMERS','customer_id', TO_CHAR(l_id));
  dct_audit_pkg.log(l_user,'CREATE','DCT_AR_CUSTOMERS', TO_CHAR(l_id), 'AR',
                    p_object_ref => APEX_JSON.get_varchar2(p_path => 'CUSTOMER_NAME'),
                    p_new => l_new);
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('id', l_id);
  APEX_JSON.write('status', 'DRAFT');
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    IF SQLCODE IN (-20001, -20090) THEN dct_rest.err(400, SQLERRM);
    ELSE dct_rest.err(500, SQLERRM); END IF;
END;
]');

    -- =========================================================================
    -- CUSTOMERS -- single: get / update / delete
    -- =========================================================================
    def_tpl('customers/:id');
    def_plsql('customers/:id', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  r      dct_ar_customers%ROWTYPE;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT * INTO r FROM dct_ar_customers WHERE customer_id = :id AND is_active = 'Y';

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('id',            r.customer_id);
  APEX_JSON.write('trxOper',       r.trx_oper);
  APEX_JSON.write('customerType',  r.customer_type);
  APEX_JSON.write('name',          r.customer_name);
  APEX_JSON.write('nameAr',        r.customer_name_ar);
  APEX_JSON.write('status',        r.ws_status);
  APEX_JSON.write('wsEnv',         r.ws_env);
  APEX_JSON.write('fusionCode',    r.fusion_customer_code);
  APEX_JSON.write('fusionSite',    r.fusion_site_number);
  APEX_JSON.write('errorMessage',  r.error_message);
  APEX_JSON.write('submittedAt',   TO_CHAR(dct_to_local(r.submitted_at), 'YYYY-MM-DD HH:MI AM'));
  APEX_JSON.write('processedAt',   TO_CHAR(dct_to_local(r.processed_at), 'YYYY-MM-DD HH:MI AM'));
  APEX_JSON.write('createdAt',     TO_CHAR(dct_to_local(r.created_at),   'YYYY-MM-DD HH:MI AM'));
  APEX_JSON.write('createdBy',     r.created_by);
  APEX_JSON.write('payloadJson',   r.payload_json);
  APEX_JSON.write('requestXml',    NVL(r.ws_request_xml,  TO_CLOB('')));
  APEX_JSON.write('responseXml',   NVL(r.ws_response_xml, TO_CLOB('')));
  APEX_JSON.close_object;
EXCEPTION
  WHEN NO_DATA_FOUND THEN dct_rest.err(404, 'Customer submission not found');
  WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    def_plsql('customers/:id', 'PUT', q'[
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_blob   BLOB := :body;   -- deref :body exactly ONCE (binds as BLOB on this ORDS)
  l_body   CLOB;
  l_status VARCHAR2(20);
  l_old    CLOB;
  l_new    CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_blob IS NULL OR dbms_lob.getlength(l_blob) = 0 THEN
    dct_rest.err(400, 'Body required'); RETURN;
  END IF;
  DECLARE
    l_doff INTEGER := 1; l_soff INTEGER := 1;
    l_ctx  INTEGER := dbms_lob.default_lang_ctx; l_warn INTEGER;
  BEGIN
    dbms_lob.createtemporary(l_body, TRUE);
    dbms_lob.converttoclob(l_body, l_blob, dbms_lob.lobmaxsize,
                           l_doff, l_soff, dbms_lob.default_csid, l_ctx, l_warn);
  END;

  BEGIN
    SELECT ws_status INTO l_status FROM dct_ar_customers
    WHERE  customer_id = :id AND is_active = 'Y';
  EXCEPTION WHEN NO_DATA_FOUND THEN
    dct_rest.err(404, 'Customer submission not found'); RETURN;
  END;
  IF l_status NOT IN ('DRAFT','ERROR') THEN
    dct_rest.err(400, 'Only DRAFT or ERROR submissions can be edited'); RETURN;
  END IF;

  APEX_JSON.parse(l_body);
  IF APEX_JSON.get_varchar2(p_path => 'CUSTOMER_NAME') IS NULL THEN
    dct_rest.err(400, 'CUSTOMER_NAME is required'); RETURN;
  END IF;

  l_old := dct_audit_pkg.snap('DCT_AR_CUSTOMERS','customer_id', TO_CHAR(:id));

  UPDATE dct_ar_customers SET
    trx_oper               = NVL(APEX_JSON.get_varchar2(p_path => 'TRX_OPER'), 'CREATE'),
    customer_type          = NVL(APEX_JSON.get_varchar2(p_path => 'CUSTOMER_TYPE'), 'ORGANIZATION'),
    customer_name          = APEX_JSON.get_varchar2(p_path => 'CUSTOMER_NAME'),
    customer_name_ar       = APEX_JSON.get_varchar2(p_path => 'CUSTOMER_NAME_AR'),
    customer_class_name    = APEX_JSON.get_varchar2(p_path => 'CUSTOMER_CLASS_NAME'),
    customer_category_name = APEX_JSON.get_varchar2(p_path => 'CUSTOMER_CATEGORY_NAME'),
    country_code           = APEX_JSON.get_varchar2(p_path => 'COUNTRY_CODE'),
    emirate                = APEX_JSON.get_varchar2(p_path => 'EMIRATE'),
    city                   = APEX_JSON.get_varchar2(p_path => 'CITY'),
    site_name              = APEX_JSON.get_varchar2(p_path => 'SITE_NAME'),
    site_code              = APEX_JSON.get_varchar2(p_path => 'SITE_CODE'),
    trade_license_num      = APEX_JSON.get_varchar2(p_path => 'TRADE_LICENSE_NUM'),
    legacy_customer_number = APEX_JSON.get_varchar2(p_path => 'LEGACY_CUSTOMER_NUMBER'),
    legacy_site_number     = APEX_JSON.get_varchar2(p_path => 'LEGACY_CUSTOMER_SITE_NUMBER'),
    contact_person         = APEX_JSON.get_varchar2(p_path => 'CONTACT_PERSON'),
    contact_number         = APEX_JSON.get_varchar2(p_path => 'CONTACT_NUMBER'),
    email_address          = APEX_JSON.get_varchar2(p_path => 'EMAIL_ADDRESS'),
    vat_number             = APEX_JSON.get_varchar2(p_path => 'VAT_NUMBER'),
    payload_json           = l_body,
    updated_by             = l_user,
    updated_at             = SYSTIMESTAMP
  WHERE customer_id = :id;
  COMMIT;

  l_new := dct_audit_pkg.snap('DCT_AR_CUSTOMERS','customer_id', TO_CHAR(:id));
  dct_audit_pkg.log(l_user,'UPDATE','DCT_AR_CUSTOMERS', TO_CHAR(:id), 'AR',
                    p_object_ref => APEX_JSON.get_varchar2(p_path => 'CUSTOMER_NAME'),
                    p_old => l_old, p_new => l_new);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    IF SQLCODE IN (-20001, -20090) THEN dct_rest.err(400, SQLERRM);
    ELSE dct_rest.err(500, SQLERRM); END IF;
END;
]');

    def_plsql('customers/:id', 'DELETE', q'[
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_status VARCHAR2(20);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  BEGIN
    SELECT ws_status INTO l_status FROM dct_ar_customers
    WHERE  customer_id = :id AND is_active = 'Y';
  EXCEPTION WHEN NO_DATA_FOUND THEN
    dct_rest.err(404, 'Customer submission not found'); RETURN;
  END;
  IF l_status <> 'DRAFT' THEN
    dct_rest.err(400, 'Only DRAFT submissions can be deleted'); RETURN;
  END IF;
  UPDATE dct_ar_customers
  SET    is_active = 'N', updated_by = l_user, updated_at = SYSTIMESTAMP
  WHERE  customer_id = :id;
  COMMIT;
  dct_audit_pkg.log(l_user,'DELETE','DCT_AR_CUSTOMERS', TO_CHAR(:id), 'AR');
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION
  WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    -- =========================================================================
    -- CUSTOMERS -- submit to gateway
    -- =========================================================================
    def_tpl('customers/:id/submit');
    def_plsql('customers/:id/submit', 'POST', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_old  VARCHAR2(20);
  l_uid  NUMBER;
  r      dct_ar_customers%ROWTYPE;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  BEGIN
    SELECT ws_status INTO l_old FROM dct_ar_customers
    WHERE  customer_id = :id AND is_active = 'Y';
  EXCEPTION WHEN NO_DATA_FOUND THEN
    dct_rest.err(404, 'Customer submission not found'); RETURN;
  END;

  dct_ar_ws_pkg.submit_customer(:id, l_user);

  SELECT * INTO r FROM dct_ar_customers WHERE customer_id = :id;
  SELECT user_id INTO l_uid FROM dct_users WHERE UPPER(username) = UPPER(l_user);
  INSERT INTO dct_request_status_history
    (source_module, source_type, source_id, old_status, new_status, changed_by, comments)
  VALUES ('AR', 'CUSTOMER', :id, l_old, r.ws_status, l_uid,
          'Submitted to Fusion (' || NVL(r.ws_env,'-') || ')');
  COMMIT;
  dct_audit_pkg.log(l_user,'SUBMIT','DCT_AR_CUSTOMERS', TO_CHAR(:id), 'AR',
                    p_object_ref => r.customer_name);

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('id',           r.customer_id);
  APEX_JSON.write('status',       r.ws_status);
  APEX_JSON.write('wsEnv',        r.ws_env);
  APEX_JSON.write('errorMessage', r.error_message);
  APEX_JSON.write('ok',           r.ws_status = 'SENT');
  APEX_JSON.close_object;
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE = -20404 THEN dct_rest.err(404, SQLERRM);
    ELSIF SQLCODE IN (-20001, -20090) THEN dct_rest.err(400, SQLERRM);
    ELSE dct_rest.err(500, SQLERRM); END IF;
END;
]');

    -- =========================================================================
    -- CUSTOMERS -- poll processed status
    -- =========================================================================
    def_tpl('customers/:id/sync');
    def_plsql('customers/:id/sync', 'POST', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_old  VARCHAR2(20);
  l_uid  NUMBER;
  r      dct_ar_customers%ROWTYPE;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  BEGIN
    SELECT ws_status INTO l_old FROM dct_ar_customers
    WHERE  customer_id = :id AND is_active = 'Y';
  EXCEPTION WHEN NO_DATA_FOUND THEN
    dct_rest.err(404, 'Customer submission not found'); RETURN;
  END;

  dct_ar_ws_pkg.sync_status(:id, l_user);

  SELECT * INTO r FROM dct_ar_customers WHERE customer_id = :id;
  IF r.ws_status <> l_old THEN
    SELECT user_id INTO l_uid FROM dct_users WHERE UPPER(username) = UPPER(l_user);
    INSERT INTO dct_request_status_history
      (source_module, source_type, source_id, old_status, new_status, changed_by, comments)
    VALUES ('AR', 'CUSTOMER', :id, l_old, r.ws_status, l_uid,
            'Fusion processed - customer code ' || NVL(r.fusion_customer_code,'-'));
    COMMIT;
  END IF;

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('id',         r.customer_id);
  APEX_JSON.write('status',     r.ws_status);
  APEX_JSON.write('fusionCode', r.fusion_customer_code);
  APEX_JSON.write('fusionSite', r.fusion_site_number);
  APEX_JSON.write('processed',  r.ws_status = 'PROCESSED');
  APEX_JSON.close_object;
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE = -20404 THEN dct_rest.err(404, SQLERRM);
    ELSIF SQLCODE IN (-20001, -20090) THEN dct_rest.err(400, SQLERRM);
    ELSE dct_rest.err(500, SQLERRM); END IF;
END;
]');

    -- =========================================================================
    -- CUSTOMERS -- live gateway search (dup check / lookup)
    -- =========================================================================
    def_tpl('customers/wssearch');
    def_plsql('customers/wssearch', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_resp CLOB;
  l_json CLOB;
  l_len  NUMBER;
  l_pos  NUMBER := 1;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF COALESCE(:name, :code, :vat, :iden, :cr, :fromdt) IS NULL THEN
    dct_rest.err(400, 'Provide at least one search filter'); RETURN;
  END IF;

  l_resp := dct_ar_ws_pkg.ws_query(
      p_customer_code => :code,
      p_cust_name     => :name,
      p_vat_number    => :vat,
      p_iden_num      => :iden,
      p_cr_number     => :cr,
      p_from_date     => :fromdt,
      p_to_date       => :todt,
      p_status        => :wstatus,
      p_page_no       => TO_NUMBER(:page DEFAULT NULL ON CONVERSION ERROR));
  l_json := dct_ar_ws_pkg.response_rows_json(l_resp);

  dct_rest.json_header;
  l_len := NVL(dbms_lob.getlength(l_json), 0);
  WHILE l_pos <= l_len LOOP
    htp.prn(dbms_lob.substr(l_json, 8000, l_pos));
    l_pos := l_pos + 8000;
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE = -20001 THEN dct_rest.err(400, SQLERRM);
    ELSE dct_rest.err(500, SQLERRM); END IF;
END;
]');

    -- =========================================================================
    -- CUSTOMERS -- form LOVs (lookup sets + countries + ws mode flags)
    -- =========================================================================
    def_tpl('customers/lovs');
    def_plsql('customers/lovs', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;

  APEX_JSON.open_object('lookups');
  FOR c IN (
    SELECT category_code FROM dct_lookup_categories
    WHERE  category_code IN (
      'AR_CUST_WS_STATUS','AR_CUST_TRX_OPER','AR_CUST_TYPE','AR_CUST_CLASS',
      'AR_CUST_CATEGORY','AR_CUST_SITE_PURPOSE','AR_PERSON_IDEN_TYPE',
      'AR_VAT_REG_TYPE','AR_TAX_REGIME','AR_TAX_REG_REASON','AR_CUST_PAYMENT_TERMS',
      'AR_DELIVERY_METHOD','AR_STATEMENT_CYCLE','AR_COLLECTOR','AR_CUST_PROFILE',
      'AR_ACCT_RESP_TYPE','AR_EMIRATE')
    ORDER BY category_code
  ) LOOP
    APEX_JSON.open_array(c.category_code);
    FOR v IN (
      SELECT lv.value_code, lv.value_name_en, lv.value_name_ar, lv.is_default
      FROM   dct_lookup_values lv
      JOIN   dct_lookup_categories lc ON lc.category_id = lv.category_id
      WHERE  lc.category_code = c.category_code AND lv.is_active = 'Y'
      ORDER  BY lv.display_order
    ) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('code',      v.value_code);
      APEX_JSON.write('nameEn',    v.value_name_en);
      APEX_JSON.write('nameAr',    v.value_name_ar);
      APEX_JSON.write('isDefault', v.is_default = 'Y');
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
  END LOOP;
  APEX_JSON.close_object;

  APEX_JSON.open_array('countries');
  FOR c IN (
    SELECT country_code, country_name_en, country_name_ar
    FROM   dct_countries
    ORDER  BY CASE WHEN country_code = 'AE' THEN 0 ELSE 1 END, country_name_en
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code',   c.country_code);
    APEX_JSON.write('nameEn', c.country_name_en);
    APEX_JSON.write('nameAr', c.country_name_ar);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.write('wsLive', NVL(dct_ar_ws_pkg.get_ws_setting('AR_WS_LIVE'), 'N') = 'Y');
  APEX_JSON.write('wsEnv',  NVL(dct_ar_ws_pkg.get_ws_setting('AR_WS_ENV'), 'STAGE'));
  APEX_JSON.close_object;
EXCEPTION
  WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

END setup_ar_cust_ords_tmp;
/

SHOW ERRORS PROCEDURE setup_ar_cust_ords_tmp

BEGIN
    setup_ar_cust_ords_tmp;
    COMMIT;
END;
/

DROP PROCEDURE setup_ar_cust_ords_tmp;

-- =============================================================================
-- Verification
-- =============================================================================
SELECT uri_template, method
FROM   user_ords_templates t
JOIN   user_ords_handlers h ON h.template_id = t.id
JOIN   user_ords_modules m  ON m.id = t.module_id
WHERE  m.name = 'ar.rest' AND t.uri_template LIKE 'customers%'
ORDER  BY 1, 2;

PROMPT 10_ar_customer_ords.sql complete
EXIT
