-- =============================================================================
-- Outsource Payroll Module (App 215) -- ORDS REST API (pay.rest) -- Phase 1
-- File    : 04_pay_ords.sql
-- Schema  : registered under ADMIN (the only REST-routable schema on ADB)
-- Base URL: /ords/admin/pay/
-- Run     : sql -name prod_mcp @04_pay_ords.sql   (FRESH session -- synonym rule:
--           do NOT run after ALTER SESSION SET CURRENT_SCHEMA=PROD or the ADMIN
--           synonyms self-reference, ORA-01471)
-- Notes   : Thin handlers over DCT_PAY_PKG. validate_session on every route
--           (the db/v2/50 gate maps segment pay -> PAY).
--           Envelope {items,total,limit,offset}. Error mapping:
--           -20401->401 -20403->403 -20404->404 -20001/-20090->400 else 500.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

-- =============================================================================
-- 1. ADMIN synonyms for every PROD object the handlers touch
-- =============================================================================
CREATE OR REPLACE SYNONYM dct_pay_pkg              FOR prod.dct_pay_pkg;
CREATE OR REPLACE SYNONYM dct_pay_company          FOR prod.dct_pay_company;
CREATE OR REPLACE SYNONYM dct_pay_company_supplier FOR prod.dct_pay_company_supplier;
CREATE OR REPLACE SYNONYM dct_pay_contract         FOR prod.dct_pay_contract;
CREATE OR REPLACE SYNONYM dct_pay_margin_rule      FOR prod.dct_pay_margin_rule;
CREATE OR REPLACE SYNONYM dct_pay_dct_bank         FOR prod.dct_pay_dct_bank;
CREATE OR REPLACE SYNONYM dct_pay_gov_pkg          FOR prod.dct_pay_gov_pkg;
CREATE OR REPLACE SYNONYM atd_suppliers            FOR prod.atd_suppliers;
CREATE OR REPLACE SYNONYM atd_supplier_bank_accounts FOR prod.atd_supplier_bank_accounts;
-- shared objects (dct_rest, dct_auth, dct_users, dct_documents,
-- dct_document_types, dct_lookup_categories/values, dct_modules,
-- dct_module_settings, dct_to_local) already have ADMIN synonyms.

-- =============================================================================
-- 2. Module + handlers (wrapped in DDL so SQLcl skips bind scanning)
-- =============================================================================
CREATE OR REPLACE PROCEDURE setup_pay_ords_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'pay.rest';

    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;

    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => p_method,
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;

    PROCEDURE def_media(p_pattern VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => 'GET',
            p_source_type => ORDS.source_type_media,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;

BEGIN

    BEGIN
        ORDS.DELETE_MODULE(p_module_name => c_mod);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    ORDS.DEFINE_MODULE(
        p_module_name    => c_mod,
        p_base_path      => '/pay/',
        p_items_per_page => 100,
        p_status         => 'PUBLISHED',
        p_comments       => 'i-Finance -- Outsource Payroll REST API (App 215)');

    -- =========================================================================
    -- BOOT -- identity flags + lookups + banks for the UI
    -- =========================================================================
    def_template('boot');
    def_handler('boot', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
  l_max  NUMBER;
  l_admin BOOLEAN;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_admin := dct_auth.has_role(l_user,'PAY_ADMIN') OR dct_auth.has_role(l_user,'SYS_ADMIN');
  l_uid := dct_auth.get_user_id(l_user);
  BEGIN
    SELECT TO_NUMBER(ms.setting_value DEFAULT NULL ON CONVERSION ERROR) INTO l_max
    FROM dct_module_settings ms JOIN dct_modules m ON m.module_id = ms.module_id
    WHERE m.module_code='PAY' AND ms.setting_key='MAX_UPLOAD_MB';
  EXCEPTION WHEN NO_DATA_FOUND THEN l_max := NULL; END;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('userId', l_uid);
  APEX_JSON.write('isPayAdmin', dct_auth.has_role(l_user,'PAY_ADMIN') OR dct_auth.has_role(l_user,'SYS_ADMIN'));
  APEX_JSON.write('maxUploadMb', NVL(l_max,10));
  APEX_JSON.open_array('lookups');
  FOR r IN (
    SELECT c.category_code, v.value_code, v.value_name_en, v.value_name_ar, v.display_order
    FROM dct_lookup_values v JOIN dct_lookup_categories c ON c.category_id = v.category_id
    WHERE c.category_code LIKE 'PAY\_%' ESCAPE '\' AND v.is_active = 'Y'
    ORDER BY c.category_code, v.display_order
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('category', r.category_code);
    APEX_JSON.write('code',     r.value_code);
    APEX_JSON.write('nameEn',   r.value_name_en);
    APEX_JSON.write('nameAr',   NVL(r.value_name_ar,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('banks');
  FOR r IN (SELECT bank_id, bank_code, bank_name_en, bank_name_ar, iban, currency_code, is_active
            FROM dct_pay_dct_bank ORDER BY bank_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('bankId', r.bank_id);
    APEX_JSON.write('code', r.bank_code);
    APEX_JSON.write('nameEn', r.bank_name_en);
    APEX_JSON.write('nameAr', NVL(r.bank_name_ar,''));
    APEX_JSON.write('iban', CASE WHEN l_admin THEN NVL(r.iban,'') ELSE NVL(dct_pay_gov_pkg.mask_bank(r.iban),'') END);
    APEX_JSON.write('currency', r.currency_code);
    APEX_JSON.write('isActive', r.is_active);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- STATS -- overview dashboard figures + expiring contracts list
    -- =========================================================================
    def_template('stats');
    def_handler('stats', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_companies NUMBER; l_suppliers NUMBER; l_contracts NUMBER;
  l_expiring NUMBER; l_banks NUMBER; l_drafts NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT COUNT(*) INTO l_companies FROM dct_pay_company WHERE is_active='Y' AND status='ACTIVE';
  SELECT COUNT(*) INTO l_suppliers FROM dct_pay_company_supplier WHERE is_active='Y';
  SELECT COUNT(*) INTO l_contracts FROM dct_pay_contract WHERE is_active='Y' AND status='ACTIVE';
  SELECT COUNT(*) INTO l_drafts    FROM dct_pay_contract WHERE is_active='Y' AND status='DRAFT';
  SELECT COUNT(*) INTO l_expiring  FROM dct_pay_contract
   WHERE is_active='Y' AND status='ACTIVE' AND date_to IS NOT NULL
     AND TRUNC(date_to) - TRUNC(SYSDATE) BETWEEN 0 AND NVL(renewal_alert_days,60);
  SELECT COUNT(*) INTO l_banks FROM dct_pay_dct_bank WHERE is_active='Y';
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('companies', l_companies);
  APEX_JSON.write('supplierRefs', l_suppliers);
  APEX_JSON.write('activeContracts', l_contracts);
  APEX_JSON.write('draftContracts', l_drafts);
  APEX_JSON.write('expiringContracts', l_expiring);
  APEX_JSON.write('banks', l_banks);
  APEX_JSON.open_array('expiring');
  FOR r IN (
    SELECT ct.contract_id, ct.contract_no, ct.date_to, ct.status,
           co.name_en AS company_name,
           TRUNC(ct.date_to) - TRUNC(SYSDATE) AS days_left
    FROM dct_pay_contract ct
    JOIN dct_pay_company co ON co.company_id = ct.company_id
    WHERE ct.is_active='Y' AND ct.status='ACTIVE' AND ct.date_to IS NOT NULL
      AND TRUNC(ct.date_to) - TRUNC(SYSDATE) BETWEEN 0 AND NVL(ct.renewal_alert_days,60)
    ORDER BY ct.date_to
    FETCH FIRST 10 ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('contractId', r.contract_id);
    APEX_JSON.write('contractNo', r.contract_no);
    APEX_JSON.write('company', r.company_name);
    APEX_JSON.write('dateTo', TO_CHAR(r.date_to,'YYYY-MM-DD'));
    APEX_JSON.write('daysLeft', r.days_left);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- COMPANIES -- list + create
    -- =========================================================================
    def_template('companies');
    def_handler('companies', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit  DEFAULT NULL ON CONVERSION ERROR), 50), 200);
  l_offset NUMBER := NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0);
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT COUNT(*) INTO l_total
  FROM dct_pay_company c
  WHERE ([COLON]search IS NULL OR UPPER(c.name_en) LIKE '%'||UPPER([COLON]search)||'%'
         OR UPPER(NVL(c.name_ar,'~')) LIKE '%'||UPPER([COLON]search)||'%'
         OR UPPER(c.company_code) LIKE '%'||UPPER([COLON]search)||'%')
    AND ([COLON]status IS NULL OR c.status = [COLON]status)
    AND ([COLON]cat IS NULL OR c.category = [COLON]cat);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('total', l_total);
  APEX_JSON.write('limit', l_limit);
  APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT c.company_id, c.company_code, c.name_en, c.name_ar, c.category, c.status,
           c.trn, c.contact_name, c.contact_email, c.contact_phone, c.is_active,
           (SELECT COUNT(*) FROM dct_pay_company_supplier s
             WHERE s.company_id = c.company_id AND s.is_active='Y') AS supplier_refs,
           (SELECT COUNT(*) FROM dct_pay_contract ct
             WHERE ct.company_id = c.company_id AND ct.is_active='Y'
               AND ct.status='ACTIVE') AS active_contracts,
           (SELECT lv.value_name_en FROM dct_lookup_values lv
             JOIN dct_lookup_categories lc ON lc.category_id = lv.category_id
            WHERE lc.category_code='PAY_COMPANY_CATEGORY' AND lv.value_code=c.category) AS category_name
    FROM dct_pay_company c
    WHERE ([COLON]search IS NULL OR UPPER(c.name_en) LIKE '%'||UPPER([COLON]search)||'%'
           OR UPPER(NVL(c.name_ar,'~')) LIKE '%'||UPPER([COLON]search)||'%'
           OR UPPER(c.company_code) LIKE '%'||UPPER([COLON]search)||'%')
      AND ([COLON]status IS NULL OR c.status = [COLON]status)
      AND ([COLON]cat IS NULL OR c.category = [COLON]cat)
    ORDER BY c.name_en
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('companyId', r.company_id);
    APEX_JSON.write('code', r.company_code);
    APEX_JSON.write('nameEn', r.name_en);
    APEX_JSON.write('nameAr', NVL(r.name_ar,''));
    APEX_JSON.write('category', r.category);
    APEX_JSON.write('categoryName', NVL(r.category_name, r.category));
    APEX_JSON.write('status', r.status);
    APEX_JSON.write('trn', NVL(r.trn,''));
    APEX_JSON.write('contactName', NVL(r.contact_name,''));
    APEX_JSON.write('contactEmail', NVL(r.contact_email,''));
    APEX_JSON.write('contactPhone', NVL(r.contact_phone,''));
    APEX_JSON.write('supplierRefs', r.supplier_refs);
    APEX_JSON.write('activeContracts', r.active_contracts);
    APEX_JSON.write('isActive', r.is_active);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('companies', 'POST', q'!
DECLARE
  l_user VARCHAR2(100);
  l_id   NUMBER;
BEGIN
  dct_rest.parse_body([COLON]body);
  l_user := dct_rest.validate_session;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_pay_pkg.save_company(
    p_user          => l_user,
    p_company_id    => NULL,
    p_company_code  => APEX_JSON.get_varchar2(p_path=>'code'),
    p_name_en       => APEX_JSON.get_varchar2(p_path=>'nameEn'),
    p_name_ar       => APEX_JSON.get_varchar2(p_path=>'nameAr'),
    p_category      => APEX_JSON.get_varchar2(p_path=>'category'),
    p_status        => APEX_JSON.get_varchar2(p_path=>'status'),
    p_trn           => APEX_JSON.get_varchar2(p_path=>'trn'),
    p_license_no    => APEX_JSON.get_varchar2(p_path=>'licenseNo'),
    p_phone         => APEX_JSON.get_varchar2(p_path=>'phone'),
    p_email         => APEX_JSON.get_varchar2(p_path=>'email'),
    p_website       => APEX_JSON.get_varchar2(p_path=>'website'),
    p_address_en    => APEX_JSON.get_varchar2(p_path=>'addressEn'),
    p_address_ar    => APEX_JSON.get_varchar2(p_path=>'addressAr'),
    p_contact_name  => APEX_JSON.get_varchar2(p_path=>'contactName'),
    p_contact_email => APEX_JSON.get_varchar2(p_path=>'contactEmail'),
    p_contact_phone => APEX_JSON.get_varchar2(p_path=>'contactPhone'),
    p_notes         => APEX_JSON.get_varchar2(p_path=>'notes'),
    p_is_active     => NVL(APEX_JSON.get_varchar2(p_path=>'isActive'),'Y'),
    o_company_id    => l_id);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('companyId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    -- =========================================================================
    -- COMPANY detail -- header + supplier refs + contracts summary
    -- =========================================================================
    def_template('companies/[COLON]id');
    def_handler('companies/[COLON]id', 'GET', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_found BOOLEAN := FALSE;
  l_admin BOOLEAN;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_admin := dct_auth.has_role(l_user,'PAY_ADMIN') OR dct_auth.has_role(l_user,'SYS_ADMIN');
  FOR c IN (SELECT * FROM dct_pay_company WHERE company_id = TO_NUMBER([COLON]id)) LOOP
    l_found := TRUE;
    dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
    APEX_JSON.write('companyId', c.company_id);
    APEX_JSON.write('code', c.company_code);
    APEX_JSON.write('nameEn', c.name_en);
    APEX_JSON.write('nameAr', NVL(c.name_ar,''));
    APEX_JSON.write('category', c.category);
    APEX_JSON.write('status', c.status);
    APEX_JSON.write('trn', NVL(c.trn,''));
    APEX_JSON.write('licenseNo', NVL(c.license_no,''));
    APEX_JSON.write('phone', NVL(c.phone,''));
    APEX_JSON.write('email', NVL(c.email,''));
    APEX_JSON.write('website', NVL(c.website,''));
    APEX_JSON.write('addressEn', NVL(c.address_en,''));
    APEX_JSON.write('addressAr', NVL(c.address_ar,''));
    APEX_JSON.write('contactName', NVL(c.contact_name,''));
    APEX_JSON.write('contactEmail', NVL(c.contact_email,''));
    APEX_JSON.write('contactPhone', NVL(c.contact_phone,''));
    APEX_JSON.write('notes', NVL(c.notes,''));
    APEX_JSON.write('isActive', c.is_active);
    APEX_JSON.write('rowVersion', c.row_version);
    APEX_JSON.write('createdBy', NVL(c.created_by,''));
    APEX_JSON.write('createdAt', TO_CHAR(dct_to_local(CAST(c.created_at AS TIMESTAMP)),'YYYY-MM-DD HH[COLON]MI AM'));
    APEX_JSON.write('updatedBy', NVL(c.updated_by,''));
    APEX_JSON.write('updatedAt', TO_CHAR(dct_to_local(CAST(c.updated_at AS TIMESTAMP)),'YYYY-MM-DD HH[COLON]MI AM'));
    APEX_JSON.open_array('suppliers');
    FOR s IN (SELECT * FROM dct_pay_company_supplier
              WHERE company_id = c.company_id ORDER BY purpose, is_default DESC, supplier_number) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('supplierRefId', s.supplier_ref_id);
      APEX_JSON.write('supplierNumber', s.supplier_number);
      APEX_JSON.write('supplierName', NVL(s.supplier_name,''));
      APEX_JSON.write('supplierSite', NVL(s.supplier_site,''));
      APEX_JSON.write('purpose', s.purpose);
      APEX_JSON.write('bankName', NVL(s.bank_name,''));
      APEX_JSON.write('iban', CASE WHEN l_admin THEN NVL(s.iban,'') ELSE NVL(dct_pay_gov_pkg.mask_bank(s.iban),'') END);
      APEX_JSON.write('bankAccountNo', CASE WHEN l_admin THEN NVL(s.bank_account_no,'') ELSE NVL(dct_pay_gov_pkg.mask_bank(s.bank_account_no),'') END);
      APEX_JSON.write('currency', s.currency_code);
      APEX_JSON.write('paymentMethod', NVL(s.payment_method,''));
      APEX_JSON.write('payGroup', NVL(s.pay_group,''));
      APEX_JSON.write('paymentTerms', NVL(s.payment_terms,''));
      APEX_JSON.write('isDefault', s.is_default);
      APEX_JSON.write('isActive', s.is_active);
      APEX_JSON.write('effectiveFrom', TO_CHAR(s.effective_from,'YYYY-MM-DD'));
      APEX_JSON.write('effectiveTo', NVL(TO_CHAR(s.effective_to,'YYYY-MM-DD'),''));
      APEX_JSON.write('syncStatus', s.sync_status);
      APEX_JSON.write('registryId', s.fusion_registry_id);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.open_array('contracts');
    FOR t IN (SELECT ct.contract_id, ct.contract_no, ct.title_en, ct.status,
                     ct.date_from, ct.date_to, ct.bu_code, ct.version_no
              FROM dct_pay_contract ct
              WHERE ct.company_id = c.company_id
              ORDER BY ct.date_from DESC, ct.contract_id DESC) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('contractId', t.contract_id);
      APEX_JSON.write('contractNo', t.contract_no);
      APEX_JSON.write('titleEn', NVL(t.title_en,''));
      APEX_JSON.write('status', t.status);
      APEX_JSON.write('dateFrom', TO_CHAR(t.date_from,'YYYY-MM-DD'));
      APEX_JSON.write('dateTo', NVL(TO_CHAR(t.date_to,'YYYY-MM-DD'),''));
      APEX_JSON.write('buCode', NVL(t.bu_code,''));
      APEX_JSON.write('versionNo', t.version_no);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.close_object;
  END LOOP;
  IF NOT l_found THEN dct_rest.err(404,'Company not found'); END IF;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('companies/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100);
  l_id   NUMBER;
BEGIN
  dct_rest.parse_body([COLON]body);
  l_user := dct_rest.validate_session;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_pay_pkg.save_company(
    p_user          => l_user,
    p_company_id    => TO_NUMBER([COLON]id),
    p_company_code  => APEX_JSON.get_varchar2(p_path=>'code'),
    p_name_en       => APEX_JSON.get_varchar2(p_path=>'nameEn'),
    p_name_ar       => APEX_JSON.get_varchar2(p_path=>'nameAr'),
    p_category      => APEX_JSON.get_varchar2(p_path=>'category'),
    p_status        => APEX_JSON.get_varchar2(p_path=>'status'),
    p_trn           => APEX_JSON.get_varchar2(p_path=>'trn'),
    p_license_no    => APEX_JSON.get_varchar2(p_path=>'licenseNo'),
    p_phone         => APEX_JSON.get_varchar2(p_path=>'phone'),
    p_email         => APEX_JSON.get_varchar2(p_path=>'email'),
    p_website       => APEX_JSON.get_varchar2(p_path=>'website'),
    p_address_en    => APEX_JSON.get_varchar2(p_path=>'addressEn'),
    p_address_ar    => APEX_JSON.get_varchar2(p_path=>'addressAr'),
    p_contact_name  => APEX_JSON.get_varchar2(p_path=>'contactName'),
    p_contact_email => APEX_JSON.get_varchar2(p_path=>'contactEmail'),
    p_contact_phone => APEX_JSON.get_varchar2(p_path=>'contactPhone'),
    p_notes         => APEX_JSON.get_varchar2(p_path=>'notes'),
    p_is_active     => NVL(APEX_JSON.get_varchar2(p_path=>'isActive'),'Y'),
    o_company_id    => l_id);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('companyId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    -- =========================================================================
    -- SUPPLIER REFERENCES -- add under a company, update by id
    -- =========================================================================
    def_template('companies/[COLON]id/suppliers');
    def_handler('companies/[COLON]id/suppliers', 'POST', q'!
DECLARE
  l_user VARCHAR2(100);
  l_id   NUMBER;
BEGIN
  dct_rest.parse_body([COLON]body);
  l_user := dct_rest.validate_session;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_pay_pkg.save_supplier_ref(
    p_user            => l_user,
    p_supplier_ref_id => NULL,
    p_company_id      => TO_NUMBER([COLON]id),
    p_supplier_number => APEX_JSON.get_varchar2(p_path=>'supplierNumber'),
    p_supplier_name   => APEX_JSON.get_varchar2(p_path=>'supplierName'),
    p_supplier_site   => APEX_JSON.get_varchar2(p_path=>'supplierSite'),
    p_purpose         => APEX_JSON.get_varchar2(p_path=>'purpose'),
    p_bank_name       => APEX_JSON.get_varchar2(p_path=>'bankName'),
    p_iban            => APEX_JSON.get_varchar2(p_path=>'iban'),
    p_bank_account_no => APEX_JSON.get_varchar2(p_path=>'bankAccountNo'),
    p_currency_code   => APEX_JSON.get_varchar2(p_path=>'currency'),
    p_payment_method  => APEX_JSON.get_varchar2(p_path=>'paymentMethod'),
    p_pay_group       => APEX_JSON.get_varchar2(p_path=>'payGroup'),
    p_payment_terms   => APEX_JSON.get_varchar2(p_path=>'paymentTerms'),
    p_is_default      => NVL(APEX_JSON.get_varchar2(p_path=>'isDefault'),'N'),
    p_is_active       => NVL(APEX_JSON.get_varchar2(p_path=>'isActive'),'Y'),
    o_supplier_ref_id => l_id);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('supplierRefId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('suppliers/[COLON]sid');
    def_handler('suppliers/[COLON]sid', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100);
  l_id   NUMBER;
BEGIN
  dct_rest.parse_body([COLON]body);
  l_user := dct_rest.validate_session;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_pay_pkg.save_supplier_ref(
    p_user            => l_user,
    p_supplier_ref_id => TO_NUMBER([COLON]sid),
    p_company_id      => TO_NUMBER(APEX_JSON.get_varchar2(p_path=>'companyId')),
    p_supplier_number => APEX_JSON.get_varchar2(p_path=>'supplierNumber'),
    p_supplier_name   => APEX_JSON.get_varchar2(p_path=>'supplierName'),
    p_supplier_site   => APEX_JSON.get_varchar2(p_path=>'supplierSite'),
    p_purpose         => APEX_JSON.get_varchar2(p_path=>'purpose'),
    p_bank_name       => APEX_JSON.get_varchar2(p_path=>'bankName'),
    p_iban            => APEX_JSON.get_varchar2(p_path=>'iban'),
    p_bank_account_no => APEX_JSON.get_varchar2(p_path=>'bankAccountNo'),
    p_currency_code   => APEX_JSON.get_varchar2(p_path=>'currency'),
    p_payment_method  => APEX_JSON.get_varchar2(p_path=>'paymentMethod'),
    p_pay_group       => APEX_JSON.get_varchar2(p_path=>'payGroup'),
    p_payment_terms   => APEX_JSON.get_varchar2(p_path=>'paymentTerms'),
    p_is_default      => NVL(APEX_JSON.get_varchar2(p_path=>'isDefault'),'N'),
    p_is_active       => NVL(APEX_JSON.get_varchar2(p_path=>'isActive'),'Y'),
    o_supplier_ref_id => l_id);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('supplierRefId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    -- =========================================================================
    -- CONTRACTS -- list + create
    -- =========================================================================
    def_template('contracts');
    def_handler('contracts', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit  DEFAULT NULL ON CONVERSION ERROR), 50), 200);
  l_offset NUMBER := NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0);
  l_expdays NUMBER := TO_NUMBER([COLON]expiring DEFAULT NULL ON CONVERSION ERROR);
  l_coid   NUMBER := TO_NUMBER([COLON]companyid DEFAULT NULL ON CONVERSION ERROR);
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT COUNT(*) INTO l_total
  FROM dct_pay_contract ct
  JOIN dct_pay_company co ON co.company_id = ct.company_id
  WHERE (l_coid IS NULL OR ct.company_id = l_coid)
    AND ([COLON]status IS NULL OR ct.status = [COLON]status)
    AND ([COLON]bu IS NULL OR ct.bu_code = [COLON]bu)
    AND ([COLON]search IS NULL OR UPPER(ct.contract_no) LIKE '%'||UPPER([COLON]search)||'%'
         OR UPPER(NVL(ct.title_en,'~')) LIKE '%'||UPPER([COLON]search)||'%'
         OR UPPER(co.name_en) LIKE '%'||UPPER([COLON]search)||'%')
    AND (l_expdays IS NULL OR (ct.date_to IS NOT NULL
         AND TRUNC(ct.date_to) - TRUNC(SYSDATE) BETWEEN 0 AND l_expdays));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('total', l_total);
  APEX_JSON.write('limit', l_limit);
  APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT ct.contract_id, ct.contract_no, ct.title_en, ct.status, ct.date_from, ct.date_to,
           ct.bu_code, ct.currency_code, ct.vat_rate, ct.version_no, ct.is_active,
           ct.company_id, co.name_en AS company_name, co.company_code,
           CASE WHEN ct.date_to IS NOT NULL THEN TRUNC(ct.date_to) - TRUNC(SYSDATE) END AS days_left,
           (SELECT COUNT(*) FROM dct_pay_margin_rule mr
             WHERE mr.contract_id = ct.contract_id AND mr.is_active='Y') AS margin_rules
    FROM dct_pay_contract ct
    JOIN dct_pay_company co ON co.company_id = ct.company_id
    WHERE (l_coid IS NULL OR ct.company_id = l_coid)
      AND ([COLON]status IS NULL OR ct.status = [COLON]status)
      AND ([COLON]bu IS NULL OR ct.bu_code = [COLON]bu)
      AND ([COLON]search IS NULL OR UPPER(ct.contract_no) LIKE '%'||UPPER([COLON]search)||'%'
           OR UPPER(NVL(ct.title_en,'~')) LIKE '%'||UPPER([COLON]search)||'%'
           OR UPPER(co.name_en) LIKE '%'||UPPER([COLON]search)||'%')
      AND (l_expdays IS NULL OR (ct.date_to IS NOT NULL
           AND TRUNC(ct.date_to) - TRUNC(SYSDATE) BETWEEN 0 AND l_expdays))
    ORDER BY ct.date_from DESC, ct.contract_id DESC
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('contractId', r.contract_id);
    APEX_JSON.write('contractNo', r.contract_no);
    APEX_JSON.write('titleEn', NVL(r.title_en,''));
    APEX_JSON.write('status', r.status);
    APEX_JSON.write('companyId', r.company_id);
    APEX_JSON.write('company', r.company_name);
    APEX_JSON.write('companyCode', r.company_code);
    APEX_JSON.write('dateFrom', TO_CHAR(r.date_from,'YYYY-MM-DD'));
    APEX_JSON.write('dateTo', NVL(TO_CHAR(r.date_to,'YYYY-MM-DD'),''));
    IF r.days_left IS NOT NULL THEN APEX_JSON.write('daysLeft', r.days_left); END IF;
    APEX_JSON.write('buCode', NVL(r.bu_code,''));
    APEX_JSON.write('currency', r.currency_code);
    APEX_JSON.write('vatRate', NVL(r.vat_rate,0));
    APEX_JSON.write('versionNo', r.version_no);
    APEX_JSON.write('marginRules', r.margin_rules);
    APEX_JSON.write('isActive', r.is_active);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('contracts', 'POST', q'!
DECLARE
  l_user VARCHAR2(100);
  l_id   NUMBER;
BEGIN
  dct_rest.parse_body([COLON]body);
  l_user := dct_rest.validate_session;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_pay_pkg.save_contract(
    p_user               => l_user,
    p_contract_id        => NULL,
    p_company_id         => TO_NUMBER(APEX_JSON.get_varchar2(p_path=>'companyId')),
    p_contract_no        => APEX_JSON.get_varchar2(p_path=>'contractNo'),
    p_title_en           => APEX_JSON.get_varchar2(p_path=>'titleEn'),
    p_title_ar           => APEX_JSON.get_varchar2(p_path=>'titleAr'),
    p_status             => APEX_JSON.get_varchar2(p_path=>'status'),
    p_date_from          => TO_DATE(APEX_JSON.get_varchar2(p_path=>'dateFrom'),'YYYY-MM-DD'),
    p_date_to            => TO_DATE(APEX_JSON.get_varchar2(p_path=>'dateTo'),'YYYY-MM-DD'),
    p_bu_code            => APEX_JSON.get_varchar2(p_path=>'buCode'),
    p_supplier_ref_id    => TO_NUMBER(APEX_JSON.get_varchar2(p_path=>'supplierRefId')),
    p_currency_code      => APEX_JSON.get_varchar2(p_path=>'currency'),
    p_service_fee_amount => TO_NUMBER(APEX_JSON.get_varchar2(p_path=>'serviceFee')),
    p_vat_rate           => TO_NUMBER(APEX_JSON.get_varchar2(p_path=>'vatRate')),
    p_expiry_blocking    => NVL(APEX_JSON.get_varchar2(p_path=>'expiryBlocking'),'N'),
    p_renewal_alert_days => TO_NUMBER(APEX_JSON.get_varchar2(p_path=>'renewalAlertDays')),
    p_notes              => APEX_JSON.get_varchar2(p_path=>'notes'),
    p_is_active          => NVL(APEX_JSON.get_varchar2(p_path=>'isActive'),'Y'),
    o_contract_id        => l_id);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('contractId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    -- =========================================================================
    -- CONTRACT detail -- header + margin rules + amendment chain
    -- =========================================================================
    def_template('contracts/[COLON]id');
    def_handler('contracts/[COLON]id', 'GET', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_found BOOLEAN := FALSE;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  FOR c IN (
    SELECT ct.*, co.name_en AS company_name, co.company_code,
           s.supplier_number AS ref_supplier_number, s.supplier_site AS ref_supplier_site
    FROM dct_pay_contract ct
    JOIN dct_pay_company co ON co.company_id = ct.company_id
    LEFT JOIN dct_pay_company_supplier s ON s.supplier_ref_id = ct.supplier_ref_id
    WHERE ct.contract_id = TO_NUMBER([COLON]id)
  ) LOOP
    l_found := TRUE;
    dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
    APEX_JSON.write('contractId', c.contract_id);
    APEX_JSON.write('contractNo', c.contract_no);
    APEX_JSON.write('titleEn', NVL(c.title_en,''));
    APEX_JSON.write('titleAr', NVL(c.title_ar,''));
    APEX_JSON.write('status', c.status);
    APEX_JSON.write('companyId', c.company_id);
    APEX_JSON.write('company', c.company_name);
    APEX_JSON.write('companyCode', c.company_code);
    APEX_JSON.write('dateFrom', TO_CHAR(c.date_from,'YYYY-MM-DD'));
    APEX_JSON.write('dateTo', NVL(TO_CHAR(c.date_to,'YYYY-MM-DD'),''));
    APEX_JSON.write('buCode', NVL(c.bu_code,''));
    IF c.supplier_ref_id IS NOT NULL THEN
      APEX_JSON.write('supplierRefId', c.supplier_ref_id);
      APEX_JSON.write('refSupplierNumber', NVL(c.ref_supplier_number,''));
      APEX_JSON.write('refSupplierSite', NVL(c.ref_supplier_site,''));
    END IF;
    APEX_JSON.write('currency', c.currency_code);
    APEX_JSON.write('serviceFee', NVL(c.service_fee_amount,0));
    APEX_JSON.write('vatRate', NVL(c.vat_rate,0));
    APEX_JSON.write('expiryBlocking', c.expiry_blocking);
    APEX_JSON.write('renewalAlertDays', NVL(c.renewal_alert_days,60));
    APEX_JSON.write('versionNo', c.version_no);
    IF c.parent_contract_id IS NOT NULL THEN
      APEX_JSON.write('parentContractId', c.parent_contract_id);
    END IF;
    APEX_JSON.write('notes', NVL(c.notes,''));
    APEX_JSON.write('isActive', c.is_active);
    APEX_JSON.write('createdBy', NVL(c.created_by,''));
    APEX_JSON.write('createdAt', TO_CHAR(dct_to_local(CAST(c.created_at AS TIMESTAMP)),'YYYY-MM-DD HH[COLON]MI AM'));
    APEX_JSON.write('updatedBy', NVL(c.updated_by,''));
    APEX_JSON.write('updatedAt', TO_CHAR(dct_to_local(CAST(c.updated_at AS TIMESTAMP)),'YYYY-MM-DD HH[COLON]MI AM'));
    APEX_JSON.open_array('marginRules');
    FOR m IN (SELECT * FROM dct_pay_margin_rule
              WHERE contract_id = c.contract_id
              ORDER BY payment_scope, effective_from) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('ruleId', m.rule_id);
      APEX_JSON.write('effectiveFrom', TO_CHAR(m.effective_from,'YYYY-MM-DD'));
      APEX_JSON.write('effectiveTo', NVL(TO_CHAR(m.effective_to,'YYYY-MM-DD'),''));
      APEX_JSON.write('method', m.method);
      APEX_JSON.write('basis', m.basis);
      APEX_JSON.write('rateValue', m.rate_value);
      APEX_JSON.write('vatApplicable', m.vat_applicable);
      APEX_JSON.write('paymentScope', m.payment_scope);
      APEX_JSON.write('notes', NVL(m.notes,''));
      APEX_JSON.write('isActive', m.is_active);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.open_array('versions');
    FOR v IN (
      SELECT contract_id, contract_no, status, version_no, date_from, date_to
      FROM dct_pay_contract
      START WITH contract_id = (
        SELECT contract_id FROM (
          SELECT contract_id
          FROM dct_pay_contract
          START WITH contract_id = TO_NUMBER([COLON]id)
          CONNECT BY PRIOR parent_contract_id = contract_id
          ORDER BY LEVEL DESC
        ) WHERE ROWNUM = 1)
      CONNECT BY PRIOR contract_id = parent_contract_id
      ORDER BY version_no
    ) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('contractId', v.contract_id);
      APEX_JSON.write('contractNo', v.contract_no);
      APEX_JSON.write('status', v.status);
      APEX_JSON.write('versionNo', v.version_no);
      APEX_JSON.write('dateFrom', TO_CHAR(v.date_from,'YYYY-MM-DD'));
      APEX_JSON.write('dateTo', NVL(TO_CHAR(v.date_to,'YYYY-MM-DD'),''));
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.close_object;
  END LOOP;
  IF NOT l_found THEN dct_rest.err(404,'Contract not found'); END IF;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('contracts/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100);
  l_id   NUMBER;
BEGIN
  dct_rest.parse_body([COLON]body);
  l_user := dct_rest.validate_session;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_pay_pkg.save_contract(
    p_user               => l_user,
    p_contract_id        => TO_NUMBER([COLON]id),
    p_company_id         => TO_NUMBER(APEX_JSON.get_varchar2(p_path=>'companyId')),
    p_contract_no        => APEX_JSON.get_varchar2(p_path=>'contractNo'),
    p_title_en           => APEX_JSON.get_varchar2(p_path=>'titleEn'),
    p_title_ar           => APEX_JSON.get_varchar2(p_path=>'titleAr'),
    p_status             => APEX_JSON.get_varchar2(p_path=>'status'),
    p_date_from          => TO_DATE(APEX_JSON.get_varchar2(p_path=>'dateFrom'),'YYYY-MM-DD'),
    p_date_to            => TO_DATE(APEX_JSON.get_varchar2(p_path=>'dateTo'),'YYYY-MM-DD'),
    p_bu_code            => APEX_JSON.get_varchar2(p_path=>'buCode'),
    p_supplier_ref_id    => TO_NUMBER(APEX_JSON.get_varchar2(p_path=>'supplierRefId')),
    p_currency_code      => APEX_JSON.get_varchar2(p_path=>'currency'),
    p_service_fee_amount => TO_NUMBER(APEX_JSON.get_varchar2(p_path=>'serviceFee')),
    p_vat_rate           => TO_NUMBER(APEX_JSON.get_varchar2(p_path=>'vatRate')),
    p_expiry_blocking    => NVL(APEX_JSON.get_varchar2(p_path=>'expiryBlocking'),'N'),
    p_renewal_alert_days => TO_NUMBER(APEX_JSON.get_varchar2(p_path=>'renewalAlertDays')),
    p_notes              => APEX_JSON.get_varchar2(p_path=>'notes'),
    p_is_active          => NVL(APEX_JSON.get_varchar2(p_path=>'isActive'),'Y'),
    o_contract_id        => l_id);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('contractId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    -- =========================================================================
    -- CONTRACT amendment -- clone as next version
    -- =========================================================================
    def_template('contracts/[COLON]id/amend');
    def_handler('contracts/[COLON]id/amend', 'POST', q'!
DECLARE
  l_user VARCHAR2(100);
  l_id   NUMBER;
BEGIN
  dct_rest.parse_body([COLON]body);
  l_user := dct_rest.validate_session;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_pay_pkg.amend_contract(
    p_user            => l_user,
    p_contract_id     => TO_NUMBER([COLON]id),
    p_new_contract_no => APEX_JSON.get_varchar2(p_path=>'newContractNo'),
    o_new_contract_id => l_id);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('contractId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    -- =========================================================================
    -- MARGIN RULES -- add under a contract, update by id
    -- =========================================================================
    def_template('contracts/[COLON]id/margin-rules');
    def_handler('contracts/[COLON]id/margin-rules', 'POST', q'!
DECLARE
  l_user VARCHAR2(100);
  l_id   NUMBER;
BEGIN
  dct_rest.parse_body([COLON]body);
  l_user := dct_rest.validate_session;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_pay_pkg.save_margin_rule(
    p_user           => l_user,
    p_rule_id        => NULL,
    p_contract_id    => TO_NUMBER([COLON]id),
    p_effective_from => TO_DATE(APEX_JSON.get_varchar2(p_path=>'effectiveFrom'),'YYYY-MM-DD'),
    p_effective_to   => TO_DATE(APEX_JSON.get_varchar2(p_path=>'effectiveTo'),'YYYY-MM-DD'),
    p_method         => APEX_JSON.get_varchar2(p_path=>'method'),
    p_basis          => APEX_JSON.get_varchar2(p_path=>'basis'),
    p_rate_value     => TO_NUMBER(APEX_JSON.get_varchar2(p_path=>'rateValue')),
    p_vat_applicable => NVL(APEX_JSON.get_varchar2(p_path=>'vatApplicable'),'Y'),
    p_payment_scope  => APEX_JSON.get_varchar2(p_path=>'paymentScope'),
    p_notes          => APEX_JSON.get_varchar2(p_path=>'notes'),
    p_is_active      => NVL(APEX_JSON.get_varchar2(p_path=>'isActive'),'Y'),
    o_rule_id        => l_id);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('ruleId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('margin-rules/[COLON]rid');
    def_handler('margin-rules/[COLON]rid', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100);
  l_id   NUMBER;
BEGIN
  dct_rest.parse_body([COLON]body);
  l_user := dct_rest.validate_session;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_pay_pkg.save_margin_rule(
    p_user           => l_user,
    p_rule_id        => TO_NUMBER([COLON]rid),
    p_contract_id    => TO_NUMBER(APEX_JSON.get_varchar2(p_path=>'contractId')),
    p_effective_from => TO_DATE(APEX_JSON.get_varchar2(p_path=>'effectiveFrom'),'YYYY-MM-DD'),
    p_effective_to   => TO_DATE(APEX_JSON.get_varchar2(p_path=>'effectiveTo'),'YYYY-MM-DD'),
    p_method         => APEX_JSON.get_varchar2(p_path=>'method'),
    p_basis          => APEX_JSON.get_varchar2(p_path=>'basis'),
    p_rate_value     => TO_NUMBER(APEX_JSON.get_varchar2(p_path=>'rateValue')),
    p_vat_applicable => NVL(APEX_JSON.get_varchar2(p_path=>'vatApplicable'),'Y'),
    p_payment_scope  => APEX_JSON.get_varchar2(p_path=>'paymentScope'),
    p_notes          => APEX_JSON.get_varchar2(p_path=>'notes'),
    p_is_active      => NVL(APEX_JSON.get_varchar2(p_path=>'isActive'),'Y'),
    o_rule_id        => l_id);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('ruleId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    -- =========================================================================
    -- DCT BANKS -- list + create + update
    -- =========================================================================
    def_template('banks');
    def_handler('banks', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_admin BOOLEAN;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_admin := dct_auth.has_role(l_user,'PAY_ADMIN') OR dct_auth.has_role(l_user,'SYS_ADMIN');
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM dct_pay_dct_bank ORDER BY bank_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('bankId', r.bank_id);
    APEX_JSON.write('code', r.bank_code);
    APEX_JSON.write('nameEn', r.bank_name_en);
    APEX_JSON.write('nameAr', NVL(r.bank_name_ar,''));
    APEX_JSON.write('accountName', NVL(r.account_name,''));
    APEX_JSON.write('accountNumber', CASE WHEN l_admin THEN NVL(r.account_number,'') ELSE NVL(dct_pay_gov_pkg.mask_bank(r.account_number),'') END);
    APEX_JSON.write('iban', CASE WHEN l_admin THEN NVL(r.iban,'') ELSE NVL(dct_pay_gov_pkg.mask_bank(r.iban),'') END);
    APEX_JSON.write('currency', r.currency_code);
    APEX_JSON.write('branch', NVL(r.branch_name,''));
    APEX_JSON.write('notes', CASE WHEN l_admin THEN NVL(r.notes,'') ELSE '' END);
    APEX_JSON.write('isActive', r.is_active);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('banks', 'POST', q'!
DECLARE
  l_user VARCHAR2(100);
  l_id   NUMBER;
BEGIN
  dct_rest.parse_body([COLON]body);
  l_user := dct_rest.validate_session;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_pay_pkg.save_bank(
    p_user           => l_user,
    p_bank_id        => NULL,
    p_bank_code      => APEX_JSON.get_varchar2(p_path=>'code'),
    p_bank_name_en   => APEX_JSON.get_varchar2(p_path=>'nameEn'),
    p_bank_name_ar   => APEX_JSON.get_varchar2(p_path=>'nameAr'),
    p_account_name   => APEX_JSON.get_varchar2(p_path=>'accountName'),
    p_account_number => APEX_JSON.get_varchar2(p_path=>'accountNumber'),
    p_iban           => APEX_JSON.get_varchar2(p_path=>'iban'),
    p_currency_code  => APEX_JSON.get_varchar2(p_path=>'currency'),
    p_branch_name    => APEX_JSON.get_varchar2(p_path=>'branch'),
    p_notes          => APEX_JSON.get_varchar2(p_path=>'notes'),
    p_is_active      => NVL(APEX_JSON.get_varchar2(p_path=>'isActive'),'Y'),
    o_bank_id        => l_id);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('bankId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('banks/[COLON]id');
    def_handler('banks/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100);
  l_id   NUMBER;
BEGIN
  dct_rest.parse_body([COLON]body);
  l_user := dct_rest.validate_session;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_pay_pkg.save_bank(
    p_user           => l_user,
    p_bank_id        => TO_NUMBER([COLON]id),
    p_bank_code      => APEX_JSON.get_varchar2(p_path=>'code'),
    p_bank_name_en   => APEX_JSON.get_varchar2(p_path=>'nameEn'),
    p_bank_name_ar   => APEX_JSON.get_varchar2(p_path=>'nameAr'),
    p_account_name   => APEX_JSON.get_varchar2(p_path=>'accountName'),
    p_account_number => APEX_JSON.get_varchar2(p_path=>'accountNumber'),
    p_iban           => APEX_JSON.get_varchar2(p_path=>'iban'),
    p_currency_code  => APEX_JSON.get_varchar2(p_path=>'currency'),
    p_branch_name    => APEX_JSON.get_varchar2(p_path=>'branch'),
    p_notes          => APEX_JSON.get_varchar2(p_path=>'notes'),
    p_is_active      => NVL(APEX_JSON.get_varchar2(p_path=>'isActive'),'Y'),
    o_bank_id        => l_id);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('bankId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    -- =========================================================================
    -- SUPPLIER LOV -- type-ahead over the Fusion supplier extract
    -- =========================================================================
    def_template('lov/suppliers');
    def_handler('lov/suppliers', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (
    -- 2026-08-06: ATD_SUPPLIERS is the clean supplier master (one row per
    -- registry_id, NO bank columns since the Suppliers-family extract rework) -
    -- bank hints come from the normalized ATD_SUPPLIER_BANK_ACCOUNTS extract:
    -- best account per supplier = primary first, then active, then newest.
    -- currency/site_pay_group are legacy ATD_SUPPLIERS columns kept for the
    -- response contract; they are NULL until re-sourced.
    SELECT TO_CHAR(s.supplier_number) AS supplier_number, s.supplier_name, s.registry_id,
           b.bank_name, b.iban, b.bank_account_number, s.currency, s.site_pay_group
    FROM atd_suppliers s
    LEFT JOIN (
      SELECT registry_id, bank_name, iban, bank_account_number,
             ROW_NUMBER() OVER (PARTITION BY registry_id
                 ORDER BY CASE WHEN primary_flag = 'Y' THEN 0 ELSE 1 END,
                          CASE WHEN assignment_inactive_on IS NULL THEN 0 ELSE 1 END,
                          created DESC NULLS LAST) AS brn
      FROM atd_supplier_bank_accounts
    ) b ON b.registry_id = s.registry_id AND b.brn = 1
    WHERE ([COLON]search IS NULL
           OR UPPER(s.supplier_name) LIKE '%'||UPPER([COLON]search)||'%'
           OR TO_CHAR(s.supplier_number) LIKE [COLON]search||'%')
    ORDER BY s.supplier_name
    FETCH FIRST 30 ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('supplierNumber', r.supplier_number);
    APEX_JSON.write('supplierName', NVL(r.supplier_name,''));
    APEX_JSON.write('registryId', r.registry_id);
    APEX_JSON.write('bankName', NVL(r.bank_name,''));
    APEX_JSON.write('iban', NVL(r.iban,''));
    APEX_JSON.write('bankAccountNo', NVL(r.bank_account_number,''));
    APEX_JSON.write('currency', NVL(r.currency,''));
    APEX_JSON.write('payGroup', NVL(r.site_pay_group,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- DOCUMENTS -- shared DCT_DOCUMENTS, raw binary upload, media download
    -- =========================================================================
    def_template('docs');
    def_handler('docs', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF [COLON]type IS NULL OR [COLON]type NOT IN ('PAY_COMPANY','PAY_CONTRACT') OR [COLON]id IS NULL THEN
    dct_rest.err(400,'type (PAY_COMPANY|PAY_CONTRACT) and id are required'); RETURN;
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT d.doc_id, d.file_name, d.mime_type, d.file_size_bytes, d.created_at,
                   u.display_name AS uploaded_by_name
            FROM dct_documents d
            LEFT JOIN dct_users u ON u.user_id = d.created_by
            WHERE d.source_module='PAY' AND d.source_type=[COLON]type
              AND d.source_id = TO_NUMBER([COLON]id) AND d.is_active='Y'
            ORDER BY d.created_at DESC) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('docId', r.doc_id); APEX_JSON.write('fileName', r.file_name);
    APEX_JSON.write('mimeType', NVL(r.mime_type,'')); APEX_JSON.write('fileSize', NVL(r.file_size_bytes,0));
    APEX_JSON.write('uploadedBy', NVL(r.uploaded_by_name,''));
    APEX_JSON.write('uploadedAt', TO_CHAR(dct_to_local(r.created_at),'YYYY-MM-DD HH[COLON]MI AM'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('docs', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100);
  l_uid  NUMBER;
  v_blob BLOB;
  v_len  NUMBER;
  v_max  NUMBER;
  l_id   NUMBER;
BEGIN
  v_blob := [COLON]body;
  l_user := dct_rest.validate_session;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT (dct_auth.has_role(l_user,'PAY_ADMIN') OR dct_auth.has_role(l_user,'SYS_ADMIN')) THEN
    dct_rest.err(403,'PAY_ADMIN role is required'); RETURN;
  END IF;
  IF [COLON]type IS NULL OR [COLON]type NOT IN ('PAY_COMPANY','PAY_CONTRACT') OR [COLON]id IS NULL THEN
    dct_rest.err(400,'type (PAY_COMPANY|PAY_CONTRACT) and id are required'); RETURN;
  END IF;
  IF v_blob IS NULL OR DBMS_LOB.GETLENGTH(v_blob) = 0 THEN
    dct_rest.err(400,'Request body (file bytes) is required'); RETURN;
  END IF;
  IF [COLON]file_name IS NULL THEN
    dct_rest.err(400,'file_name query parameter is required'); RETURN;
  END IF;
  v_len := DBMS_LOB.GETLENGTH(v_blob);
  BEGIN
    SELECT TO_NUMBER(ms.setting_value DEFAULT NULL ON CONVERSION ERROR) INTO v_max
    FROM dct_module_settings ms JOIN dct_modules m ON m.module_id = ms.module_id
    WHERE m.module_code='PAY' AND ms.setting_key='MAX_UPLOAD_MB';
  EXCEPTION WHEN NO_DATA_FOUND THEN v_max := NULL; END;
  v_max := NVL(v_max, 10);
  IF v_len > v_max * 1024 * 1024 THEN
    dct_rest.err(413,'File exceeds the maximum upload size of '||v_max||' MB'); RETURN;
  END IF;
  l_uid := dct_auth.get_user_id(l_user);
  l_id := dct_pay_pkg.add_doc(
    p_user_id => l_uid, p_source_type => [COLON]type, p_source_id => TO_NUMBER([COLON]id),
    p_file_name => [COLON]file_name, p_mime => NVL([COLON]mime_type,'application/octet-stream'),
    p_blob => v_blob);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('docId', l_id); APEX_JSON.write('fileSize', v_len); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('docs/[COLON]docId');
    def_handler('docs/[COLON]docId', 'DELETE', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_pay_pkg.delete_doc(l_user, TO_NUMBER([COLON]docId));
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('docs/[COLON]docId/file');
    def_handler('docs/[COLON]docId/file', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_blob BLOB; l_mime VARCHAR2(100); l_name VARCHAR2(255);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  BEGIN
    SELECT file_blob, NVL(mime_type,'application/octet-stream'),
           REPLACE(REPLACE(file_name,CHR(13),''),CHR(10),'')
      INTO l_blob,l_mime,l_name
      FROM dct_documents
     WHERE doc_id=TO_NUMBER([COLON]docId) AND source_module='PAY' AND is_active='Y';
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Document not found'); RETURN; END;
  OWA_UTIL.mime_header(l_mime,FALSE);
  HTP.p('Content-Disposition[COLON] attachment; filename="'||REPLACE(l_name,'"','')||'"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);
END;
!');

    COMMIT;
END setup_pay_ords_tmp;
/

BEGIN
    setup_pay_ords_tmp;
END;
/

DROP PROCEDURE setup_pay_ords_tmp;

PROMPT === 04_pay_ords.sql complete: pay.rest published at /ords/admin/pay/ ===
