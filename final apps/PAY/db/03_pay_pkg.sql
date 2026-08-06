-- =============================================================================
-- Outsource Payroll Module (App 215) -- Business Logic -- Phase 1
-- File    : 03_pay_pkg.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @03_pay_pkg.sql
-- Notes   : DCT_PAY_PKG -- validated writes for companies, supplier references,
--           contracts, margin rules, DCT banks and documents, plus the daily
--           contract renewal sweep (DCT_PAY_RENEWAL_JOB).
--           Error contract: -20401 auth, -20403 forbidden, -20404 not found,
--           -20001 validation (plus -20090 from DCT_LOOKUP_PKG).
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

CREATE OR REPLACE PACKAGE prod.dct_pay_pkg AS

    FUNCTION  is_admin (p_user VARCHAR2) RETURN BOOLEAN;
    PROCEDURE assert_admin (p_user VARCHAR2);

    PROCEDURE save_company (
        p_user          IN VARCHAR2,
        p_company_id    IN NUMBER,          -- NULL = new
        p_company_code  IN VARCHAR2,
        p_name_en       IN VARCHAR2,
        p_name_ar       IN VARCHAR2,
        p_category      IN VARCHAR2,
        p_status        IN VARCHAR2,
        p_trn           IN VARCHAR2,
        p_license_no    IN VARCHAR2,
        p_phone         IN VARCHAR2,
        p_email         IN VARCHAR2,
        p_website       IN VARCHAR2,
        p_address_en    IN VARCHAR2,
        p_address_ar    IN VARCHAR2,
        p_contact_name  IN VARCHAR2,
        p_contact_email IN VARCHAR2,
        p_contact_phone IN VARCHAR2,
        p_notes         IN VARCHAR2,
        p_is_active     IN VARCHAR2,
        o_company_id    OUT NUMBER);

    PROCEDURE save_supplier_ref (
        p_user            IN VARCHAR2,
        p_supplier_ref_id IN NUMBER,        -- NULL = new
        p_company_id      IN NUMBER,
        p_supplier_number IN VARCHAR2,
        p_supplier_name   IN VARCHAR2,
        p_supplier_site   IN VARCHAR2,
        p_purpose         IN VARCHAR2,
        p_bank_name       IN VARCHAR2,
        p_iban            IN VARCHAR2,
        p_bank_account_no IN VARCHAR2,
        p_currency_code   IN VARCHAR2,
        p_payment_method  IN VARCHAR2,
        p_pay_group       IN VARCHAR2,
        p_payment_terms   IN VARCHAR2,
        p_is_default      IN VARCHAR2,
        p_is_active       IN VARCHAR2,
        o_supplier_ref_id OUT NUMBER);

    PROCEDURE save_contract (
        p_user               IN VARCHAR2,
        p_contract_id        IN NUMBER,     -- NULL = new
        p_company_id         IN NUMBER,
        p_contract_no        IN VARCHAR2,
        p_title_en           IN VARCHAR2,
        p_title_ar           IN VARCHAR2,
        p_status             IN VARCHAR2,
        p_date_from          IN DATE,
        p_date_to            IN DATE,
        p_bu_code            IN VARCHAR2,
        p_supplier_ref_id    IN NUMBER,
        p_currency_code      IN VARCHAR2,
        p_service_fee_amount IN NUMBER,
        p_vat_rate           IN NUMBER,
        p_expiry_blocking    IN VARCHAR2,
        p_renewal_alert_days IN NUMBER,
        p_notes              IN VARCHAR2,
        p_is_active          IN VARCHAR2,
        o_contract_id        OUT NUMBER);

    PROCEDURE amend_contract (
        p_user            IN VARCHAR2,
        p_contract_id     IN NUMBER,
        p_new_contract_no IN VARCHAR2,
        o_new_contract_id OUT NUMBER);

    PROCEDURE save_margin_rule (
        p_user           IN VARCHAR2,
        p_rule_id        IN NUMBER,         -- NULL = new
        p_contract_id    IN NUMBER,
        p_effective_from IN DATE,
        p_effective_to   IN DATE,
        p_method         IN VARCHAR2,
        p_basis          IN VARCHAR2,
        p_rate_value     IN NUMBER,
        p_vat_applicable IN VARCHAR2,
        p_payment_scope  IN VARCHAR2,
        p_notes          IN VARCHAR2,
        p_is_active      IN VARCHAR2,
        o_rule_id        OUT NUMBER);

    PROCEDURE save_bank (
        p_user           IN VARCHAR2,
        p_bank_id        IN NUMBER,         -- NULL = new
        p_bank_code      IN VARCHAR2,
        p_bank_name_en   IN VARCHAR2,
        p_bank_name_ar   IN VARCHAR2,
        p_account_name   IN VARCHAR2,
        p_account_number IN VARCHAR2,
        p_iban           IN VARCHAR2,
        p_currency_code  IN VARCHAR2,
        p_branch_name    IN VARCHAR2,
        p_notes          IN VARCHAR2,
        p_is_active      IN VARCHAR2,
        o_bank_id        OUT NUMBER);

    FUNCTION add_doc (
        p_user_id     IN NUMBER,
        p_source_type IN VARCHAR2,          -- PAY_COMPANY | PAY_CONTRACT
        p_source_id   IN NUMBER,
        p_file_name   IN VARCHAR2,
        p_mime        IN VARCHAR2,
        p_blob        IN BLOB) RETURN NUMBER;

    PROCEDURE delete_doc (p_user IN VARCHAR2, p_doc_id IN NUMBER);

    PROCEDURE sweep_renewals;

END dct_pay_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_pay_pkg AS

    -- ------------------------------------------------------------------ auth
    FUNCTION is_admin (p_user VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        RETURN prod.dct_auth.has_role(p_user, 'PAY_ADMIN')
            OR prod.dct_auth.has_role(p_user, 'SYS_ADMIN');
    END is_admin;

    PROCEDURE assert_admin (p_user VARCHAR2) IS
    BEGIN
        IF p_user IS NULL THEN
            RAISE_APPLICATION_ERROR(-20401, 'Unauthorized');
        END IF;
        IF NOT is_admin(p_user) THEN
            RAISE_APPLICATION_ERROR(-20403, 'PAY_ADMIN role is required for this action');
        END IF;
    END assert_admin;

    PROCEDURE require (p_ok BOOLEAN, p_msg VARCHAR2) IS
    BEGIN
        IF NOT p_ok THEN
            RAISE_APPLICATION_ERROR(-20001, p_msg);
        END IF;
    END require;

    -- --------------------------------------------------------------- company
    PROCEDURE save_company (
        p_user          IN VARCHAR2,
        p_company_id    IN NUMBER,
        p_company_code  IN VARCHAR2,
        p_name_en       IN VARCHAR2,
        p_name_ar       IN VARCHAR2,
        p_category      IN VARCHAR2,
        p_status        IN VARCHAR2,
        p_trn           IN VARCHAR2,
        p_license_no    IN VARCHAR2,
        p_phone         IN VARCHAR2,
        p_email         IN VARCHAR2,
        p_website       IN VARCHAR2,
        p_address_en    IN VARCHAR2,
        p_address_ar    IN VARCHAR2,
        p_contact_name  IN VARCHAR2,
        p_contact_email IN VARCHAR2,
        p_contact_phone IN VARCHAR2,
        p_notes         IN VARCHAR2,
        p_is_active     IN VARCHAR2,
        o_company_id    OUT NUMBER) IS
        l_cat    VARCHAR2(30) := NVL(p_category, 'MANPOWER');
        l_status VARCHAR2(30) := NVL(p_status, 'ACTIVE');
        l_dup    NUMBER;
    BEGIN
        assert_admin(p_user);
        require(TRIM(p_company_code) IS NOT NULL, 'Company code is required');
        require(TRIM(p_name_en) IS NOT NULL, 'Company name (English) is required');
        prod.dct_lookup_pkg.validate_lookup('PAY_COMPANY_CATEGORY', l_cat);
        prod.dct_lookup_pkg.validate_lookup('PAY_COMPANY_STATUS', l_status);

        SELECT COUNT(*) INTO l_dup
        FROM prod.dct_pay_company
        WHERE UPPER(company_code) = UPPER(TRIM(p_company_code))
          AND (p_company_id IS NULL OR company_id != p_company_id);
        require(l_dup = 0, 'Company code already exists: ' || p_company_code);

        IF p_company_id IS NULL THEN
            INSERT INTO prod.dct_pay_company
                   (company_code, name_en, name_ar, category, status, trn, license_no,
                    phone, email, website, address_en, address_ar,
                    contact_name, contact_email, contact_phone, notes, is_active,
                    created_by, updated_by)
            VALUES (UPPER(TRIM(p_company_code)), TRIM(p_name_en), p_name_ar, l_cat, l_status,
                    p_trn, p_license_no, p_phone, p_email, p_website, p_address_en, p_address_ar,
                    p_contact_name, p_contact_email, p_contact_phone, p_notes, NVL(p_is_active,'Y'),
                    p_user, p_user)
            RETURNING company_id INTO o_company_id;
        ELSE
            UPDATE prod.dct_pay_company
               SET company_code  = UPPER(TRIM(p_company_code)),
                   name_en       = TRIM(p_name_en),
                   name_ar       = p_name_ar,
                   category      = l_cat,
                   status        = l_status,
                   trn           = p_trn,
                   license_no    = p_license_no,
                   phone         = p_phone,
                   email         = p_email,
                   website       = p_website,
                   address_en    = p_address_en,
                   address_ar    = p_address_ar,
                   contact_name  = p_contact_name,
                   contact_email = p_contact_email,
                   contact_phone = p_contact_phone,
                   notes         = p_notes,
                   is_active     = NVL(p_is_active, 'Y'),
                   updated_by    = p_user,
                   updated_at    = SYSDATE
             WHERE company_id = p_company_id;
            require(SQL%ROWCOUNT = 1, 'Company not found: ' || p_company_id);
            o_company_id := p_company_id;
        END IF;
    END save_company;

    -- ---------------------------------------------------- supplier reference
    PROCEDURE save_supplier_ref (
        p_user            IN VARCHAR2,
        p_supplier_ref_id IN NUMBER,
        p_company_id      IN NUMBER,
        p_supplier_number IN VARCHAR2,
        p_supplier_name   IN VARCHAR2,
        p_supplier_site   IN VARCHAR2,
        p_purpose         IN VARCHAR2,
        p_bank_name       IN VARCHAR2,
        p_iban            IN VARCHAR2,
        p_bank_account_no IN VARCHAR2,
        p_currency_code   IN VARCHAR2,
        p_payment_method  IN VARCHAR2,
        p_pay_group       IN VARCHAR2,
        p_payment_terms   IN VARCHAR2,
        p_is_default      IN VARCHAR2,
        p_is_active       IN VARCHAR2,
        o_supplier_ref_id OUT NUMBER) IS
        l_purpose VARCHAR2(30) := NVL(p_purpose, 'ALL');
        l_n NUMBER;
    BEGIN
        assert_admin(p_user);
        require(p_company_id IS NOT NULL, 'Company is required');
        require(TRIM(p_supplier_number) IS NOT NULL, 'Fusion supplier number is required');
        prod.dct_lookup_pkg.validate_lookup('PAY_SUPPLIER_PURPOSE', l_purpose);

        SELECT COUNT(*) INTO l_n FROM prod.dct_pay_company WHERE company_id = p_company_id;
        IF l_n = 0 THEN
            RAISE_APPLICATION_ERROR(-20404, 'Company not found: ' || p_company_id);
        END IF;

        SELECT COUNT(*) INTO l_n
        FROM prod.atd_suppliers
        WHERE TO_CHAR(supplier_number) = TRIM(p_supplier_number);
        require(l_n > 0, 'Supplier number ' || p_supplier_number ||
                         ' was not found in the Fusion supplier extract (ATD_SUPPLIERS)');

        IF NVL(p_is_default, 'N') = 'Y' THEN
            UPDATE prod.dct_pay_company_supplier
               SET is_default = 'N', updated_by = p_user, updated_at = SYSDATE
             WHERE company_id = p_company_id
               AND purpose = l_purpose
               AND is_default = 'Y'
               AND (p_supplier_ref_id IS NULL OR supplier_ref_id != p_supplier_ref_id);
        END IF;

        IF p_supplier_ref_id IS NULL THEN
            INSERT INTO prod.dct_pay_company_supplier
                   (company_id, supplier_number, supplier_name, supplier_site, purpose,
                    bank_name, iban, bank_account_no, currency_code,
                    payment_method, pay_group, payment_terms, is_default, is_active,
                    created_by, updated_by)
            VALUES (p_company_id, TRIM(p_supplier_number), p_supplier_name, p_supplier_site, l_purpose,
                    p_bank_name, p_iban, p_bank_account_no, NVL(p_currency_code,'AED'),
                    p_payment_method, p_pay_group, p_payment_terms,
                    NVL(p_is_default,'N'), NVL(p_is_active,'Y'),
                    p_user, p_user)
            RETURNING supplier_ref_id INTO o_supplier_ref_id;
        ELSE
            UPDATE prod.dct_pay_company_supplier
               SET supplier_number = TRIM(p_supplier_number),
                   supplier_name   = p_supplier_name,
                   supplier_site   = p_supplier_site,
                   purpose         = l_purpose,
                   bank_name       = p_bank_name,
                   iban            = p_iban,
                   bank_account_no = p_bank_account_no,
                   currency_code   = NVL(p_currency_code, 'AED'),
                   payment_method  = p_payment_method,
                   pay_group       = p_pay_group,
                   payment_terms   = p_payment_terms,
                   is_default      = NVL(p_is_default, 'N'),
                   is_active       = NVL(p_is_active, 'Y'),
                   updated_by      = p_user,
                   updated_at      = SYSDATE
             WHERE supplier_ref_id = p_supplier_ref_id
               AND company_id = p_company_id;
            require(SQL%ROWCOUNT = 1, 'Supplier reference not found: ' || p_supplier_ref_id);
            o_supplier_ref_id := p_supplier_ref_id;
        END IF;
    END save_supplier_ref;

    -- -------------------------------------------------------------- contract
    PROCEDURE save_contract (
        p_user               IN VARCHAR2,
        p_contract_id        IN NUMBER,
        p_company_id         IN NUMBER,
        p_contract_no        IN VARCHAR2,
        p_title_en           IN VARCHAR2,
        p_title_ar           IN VARCHAR2,
        p_status             IN VARCHAR2,
        p_date_from          IN DATE,
        p_date_to            IN DATE,
        p_bu_code            IN VARCHAR2,
        p_supplier_ref_id    IN NUMBER,
        p_currency_code      IN VARCHAR2,
        p_service_fee_amount IN NUMBER,
        p_vat_rate           IN NUMBER,
        p_expiry_blocking    IN VARCHAR2,
        p_renewal_alert_days IN NUMBER,
        p_notes              IN VARCHAR2,
        p_is_active          IN VARCHAR2,
        o_contract_id        OUT NUMBER) IS
        l_status VARCHAR2(30) := NVL(p_status, 'DRAFT');
        l_n   NUMBER;
        l_dup NUMBER;
    BEGIN
        assert_admin(p_user);
        require(p_company_id IS NOT NULL, 'Company is required');
        require(TRIM(p_contract_no) IS NOT NULL, 'Contract number is required');
        require(p_date_from IS NOT NULL, 'Contract start date is required');
        require(p_date_to IS NULL OR p_date_to >= p_date_from,
                'Contract end date must be on or after the start date');
        prod.dct_lookup_pkg.validate_lookup('PAY_CONTRACT_STATUS', l_status);
        IF p_bu_code IS NOT NULL THEN
            prod.dct_lookup_pkg.validate_lookup('PAY_BU', p_bu_code);
        END IF;

        SELECT COUNT(*) INTO l_n FROM prod.dct_pay_company WHERE company_id = p_company_id;
        IF l_n = 0 THEN
            RAISE_APPLICATION_ERROR(-20404, 'Company not found: ' || p_company_id);
        END IF;

        IF p_supplier_ref_id IS NOT NULL THEN
            SELECT COUNT(*) INTO l_n
            FROM prod.dct_pay_company_supplier
            WHERE supplier_ref_id = p_supplier_ref_id AND company_id = p_company_id;
            require(l_n = 1, 'The supplier reference does not belong to the selected company');
        END IF;

        SELECT COUNT(*) INTO l_dup
        FROM prod.dct_pay_contract
        WHERE UPPER(contract_no) = UPPER(TRIM(p_contract_no))
          AND (p_contract_id IS NULL OR contract_id != p_contract_id);
        require(l_dup = 0, 'Contract number already exists: ' || p_contract_no);

        IF p_contract_id IS NULL THEN
            INSERT INTO prod.dct_pay_contract
                   (company_id, contract_no, title_en, title_ar, status, date_from, date_to,
                    bu_code, supplier_ref_id, currency_code, service_fee_amount, vat_rate,
                    expiry_blocking, renewal_alert_days, notes, is_active,
                    created_by, updated_by)
            VALUES (p_company_id, UPPER(TRIM(p_contract_no)), p_title_en, p_title_ar, l_status,
                    p_date_from, p_date_to, p_bu_code, p_supplier_ref_id,
                    NVL(p_currency_code,'AED'), p_service_fee_amount, NVL(p_vat_rate, 5),
                    NVL(p_expiry_blocking,'N'), NVL(p_renewal_alert_days, 60),
                    p_notes, NVL(p_is_active,'Y'), p_user, p_user)
            RETURNING contract_id INTO o_contract_id;
        ELSE
            UPDATE prod.dct_pay_contract
               SET company_id         = p_company_id,
                   contract_no        = UPPER(TRIM(p_contract_no)),
                   title_en           = p_title_en,
                   title_ar           = p_title_ar,
                   status             = l_status,
                   date_from          = p_date_from,
                   date_to            = p_date_to,
                   bu_code            = p_bu_code,
                   supplier_ref_id    = p_supplier_ref_id,
                   currency_code      = NVL(p_currency_code, 'AED'),
                   service_fee_amount = p_service_fee_amount,
                   vat_rate           = NVL(p_vat_rate, 5),
                   expiry_blocking    = NVL(p_expiry_blocking, 'N'),
                   renewal_alert_days = NVL(p_renewal_alert_days, 60),
                   notes              = p_notes,
                   is_active          = NVL(p_is_active, 'Y'),
                   updated_by         = p_user,
                   updated_at         = SYSDATE
             WHERE contract_id = p_contract_id;
            require(SQL%ROWCOUNT = 1, 'Contract not found: ' || p_contract_id);
            o_contract_id := p_contract_id;
        END IF;
    END save_contract;

    PROCEDURE amend_contract (
        p_user            IN VARCHAR2,
        p_contract_id     IN NUMBER,
        p_new_contract_no IN VARCHAR2,
        o_new_contract_id OUT NUMBER) IS
        l_old prod.dct_pay_contract%ROWTYPE;
        l_dup NUMBER;
    BEGIN
        assert_admin(p_user);
        require(TRIM(p_new_contract_no) IS NOT NULL, 'The new (amendment) contract number is required');
        BEGIN
            SELECT * INTO l_old FROM prod.dct_pay_contract WHERE contract_id = p_contract_id;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20404, 'Contract not found: ' || p_contract_id);
        END;
        require(l_old.status != 'SUPERSEDED', 'This contract version is already superseded');

        SELECT COUNT(*) INTO l_dup
        FROM prod.dct_pay_contract
        WHERE UPPER(contract_no) = UPPER(TRIM(p_new_contract_no));
        require(l_dup = 0, 'Contract number already exists: ' || p_new_contract_no);

        INSERT INTO prod.dct_pay_contract
               (company_id, contract_no, title_en, title_ar, status, date_from, date_to,
                bu_code, supplier_ref_id, currency_code, service_fee_amount, vat_rate,
                expiry_blocking, renewal_alert_days, parent_contract_id, version_no,
                notes, is_active, created_by, updated_by)
        VALUES (l_old.company_id, UPPER(TRIM(p_new_contract_no)), l_old.title_en, l_old.title_ar,
                'DRAFT', l_old.date_from, l_old.date_to, l_old.bu_code, l_old.supplier_ref_id,
                l_old.currency_code, l_old.service_fee_amount, l_old.vat_rate,
                l_old.expiry_blocking, l_old.renewal_alert_days, l_old.contract_id,
                l_old.version_no + 1, l_old.notes, 'Y', p_user, p_user)
        RETURNING contract_id INTO o_new_contract_id;

        INSERT INTO prod.dct_pay_margin_rule
               (contract_id, effective_from, effective_to, method, basis, rate_value,
                vat_applicable, payment_scope, notes, is_active, created_by, updated_by)
        SELECT o_new_contract_id, effective_from, effective_to, method, basis, rate_value,
               vat_applicable, payment_scope, notes, is_active, p_user, p_user
        FROM prod.dct_pay_margin_rule
        WHERE contract_id = p_contract_id AND is_active = 'Y';

        UPDATE prod.dct_pay_contract
           SET status = 'SUPERSEDED', updated_by = p_user, updated_at = SYSDATE
         WHERE contract_id = p_contract_id;
    END amend_contract;

    -- ----------------------------------------------------------- margin rule
    PROCEDURE save_margin_rule (
        p_user           IN VARCHAR2,
        p_rule_id        IN NUMBER,
        p_contract_id    IN NUMBER,
        p_effective_from IN DATE,
        p_effective_to   IN DATE,
        p_method         IN VARCHAR2,
        p_basis          IN VARCHAR2,
        p_rate_value     IN NUMBER,
        p_vat_applicable IN VARCHAR2,
        p_payment_scope  IN VARCHAR2,
        p_notes          IN VARCHAR2,
        p_is_active      IN VARCHAR2,
        o_rule_id        OUT NUMBER) IS
        l_basis VARCHAR2(30) := NVL(p_basis, 'GROSS');
        l_scope VARCHAR2(30) := NVL(p_payment_scope, 'ALL');
        l_n NUMBER;
    BEGIN
        assert_admin(p_user);
        require(p_contract_id IS NOT NULL, 'Contract is required');
        require(p_effective_from IS NOT NULL, 'Effective start date is required');
        require(p_effective_to IS NULL OR p_effective_to >= p_effective_from,
                'Effective end date must be on or after the start date');
        require(p_method IS NOT NULL, 'Margin method is required');
        require(p_rate_value IS NOT NULL, 'Margin rate or amount is required');
        require(p_rate_value >= 0, 'Margin rate or amount cannot be negative');
        prod.dct_lookup_pkg.validate_lookup('PAY_MARGIN_METHOD', p_method);
        prod.dct_lookup_pkg.validate_lookup('PAY_MARGIN_BASIS', l_basis);
        prod.dct_lookup_pkg.validate_lookup('PAY_PAYMENT_SCOPE', l_scope);

        SELECT COUNT(*) INTO l_n FROM prod.dct_pay_contract WHERE contract_id = p_contract_id;
        IF l_n = 0 THEN
            RAISE_APPLICATION_ERROR(-20404, 'Contract not found: ' || p_contract_id);
        END IF;

        IF NVL(p_is_active, 'Y') = 'Y' THEN
            SELECT COUNT(*) INTO l_n
            FROM prod.dct_pay_margin_rule r
            WHERE r.contract_id = p_contract_id
              AND r.is_active = 'Y'
              AND r.payment_scope = l_scope
              AND (p_rule_id IS NULL OR r.rule_id != p_rule_id)
              AND NVL(r.effective_to, DATE '4712-12-31') >= p_effective_from
              AND r.effective_from <= NVL(p_effective_to, DATE '4712-12-31');
            require(l_n = 0,
                'An active margin rule for the same payment scope already overlaps this effective period');
        END IF;

        IF p_rule_id IS NULL THEN
            INSERT INTO prod.dct_pay_margin_rule
                   (contract_id, effective_from, effective_to, method, basis, rate_value,
                    vat_applicable, payment_scope, notes, is_active, created_by, updated_by)
            VALUES (p_contract_id, p_effective_from, p_effective_to, p_method, l_basis, p_rate_value,
                    NVL(p_vat_applicable,'Y'), l_scope, p_notes, NVL(p_is_active,'Y'), p_user, p_user)
            RETURNING rule_id INTO o_rule_id;
        ELSE
            UPDATE prod.dct_pay_margin_rule
               SET effective_from = p_effective_from,
                   effective_to   = p_effective_to,
                   method         = p_method,
                   basis          = l_basis,
                   rate_value     = p_rate_value,
                   vat_applicable = NVL(p_vat_applicable, 'Y'),
                   payment_scope  = l_scope,
                   notes          = p_notes,
                   is_active      = NVL(p_is_active, 'Y'),
                   updated_by     = p_user,
                   updated_at     = SYSDATE
             WHERE rule_id = p_rule_id AND contract_id = p_contract_id;
            require(SQL%ROWCOUNT = 1, 'Margin rule not found: ' || p_rule_id);
            o_rule_id := p_rule_id;
        END IF;
    END save_margin_rule;

    -- -------------------------------------------------------------- DCT bank
    PROCEDURE save_bank (
        p_user           IN VARCHAR2,
        p_bank_id        IN NUMBER,
        p_bank_code      IN VARCHAR2,
        p_bank_name_en   IN VARCHAR2,
        p_bank_name_ar   IN VARCHAR2,
        p_account_name   IN VARCHAR2,
        p_account_number IN VARCHAR2,
        p_iban           IN VARCHAR2,
        p_currency_code  IN VARCHAR2,
        p_branch_name    IN VARCHAR2,
        p_notes          IN VARCHAR2,
        p_is_active      IN VARCHAR2,
        o_bank_id        OUT NUMBER) IS
        l_dup NUMBER;
    BEGIN
        assert_admin(p_user);
        require(TRIM(p_bank_code) IS NOT NULL, 'Bank code is required');
        require(TRIM(p_bank_name_en) IS NOT NULL, 'Bank name (English) is required');

        SELECT COUNT(*) INTO l_dup
        FROM prod.dct_pay_dct_bank
        WHERE UPPER(bank_code) = UPPER(TRIM(p_bank_code))
          AND (p_bank_id IS NULL OR bank_id != p_bank_id);
        require(l_dup = 0, 'Bank code already exists: ' || p_bank_code);

        IF p_bank_id IS NULL THEN
            INSERT INTO prod.dct_pay_dct_bank
                   (bank_code, bank_name_en, bank_name_ar, account_name, account_number,
                    iban, currency_code, branch_name, notes, is_active, created_by, updated_by)
            VALUES (UPPER(TRIM(p_bank_code)), TRIM(p_bank_name_en), p_bank_name_ar, p_account_name,
                    p_account_number, p_iban, NVL(p_currency_code,'AED'), p_branch_name,
                    p_notes, NVL(p_is_active,'Y'), p_user, p_user)
            RETURNING bank_id INTO o_bank_id;
        ELSE
            UPDATE prod.dct_pay_dct_bank
               SET bank_code      = UPPER(TRIM(p_bank_code)),
                   bank_name_en   = TRIM(p_bank_name_en),
                   bank_name_ar   = p_bank_name_ar,
                   account_name   = p_account_name,
                   account_number = p_account_number,
                   iban           = p_iban,
                   currency_code  = NVL(p_currency_code, 'AED'),
                   branch_name    = p_branch_name,
                   notes          = p_notes,
                   is_active      = NVL(p_is_active, 'Y'),
                   updated_by     = p_user,
                   updated_at     = SYSDATE
             WHERE bank_id = p_bank_id;
            require(SQL%ROWCOUNT = 1, 'Bank not found: ' || p_bank_id);
            o_bank_id := p_bank_id;
        END IF;
    END save_bank;

    -- ------------------------------------------------------------- documents
    FUNCTION add_doc (
        p_user_id     IN NUMBER,
        p_source_type IN VARCHAR2,
        p_source_id   IN NUMBER,
        p_file_name   IN VARCHAR2,
        p_mime        IN VARCHAR2,
        p_blob        IN BLOB) RETURN NUMBER IS
        l_type_id NUMBER;
        l_doc_id  NUMBER;
        l_n       NUMBER;
    BEGIN
        require(p_source_type IN ('PAY_COMPANY', 'PAY_CONTRACT'),
                'Unsupported document source type: ' || p_source_type);
        IF p_source_type = 'PAY_COMPANY' THEN
            SELECT COUNT(*) INTO l_n FROM prod.dct_pay_company WHERE company_id = p_source_id;
        ELSE
            SELECT COUNT(*) INTO l_n FROM prod.dct_pay_contract WHERE contract_id = p_source_id;
        END IF;
        IF l_n = 0 THEN
            RAISE_APPLICATION_ERROR(-20404, 'Document parent record not found: ' || p_source_id);
        END IF;

        SELECT doc_type_id INTO l_type_id
        FROM prod.dct_document_types
        WHERE doc_type_code = 'PAY_DOCUMENT';

        INSERT INTO prod.dct_documents
               (source_module, source_type, source_id, doc_type_id,
                file_name, mime_type, file_size_bytes, file_blob, status, created_by)
        VALUES ('PAY', p_source_type, p_source_id, l_type_id,
                p_file_name, p_mime, DBMS_LOB.GETLENGTH(p_blob), p_blob, 'ACTIVE', p_user_id)
        RETURNING doc_id INTO l_doc_id;
        RETURN l_doc_id;
    END add_doc;

    PROCEDURE delete_doc (p_user IN VARCHAR2, p_doc_id IN NUMBER) IS
    BEGIN
        assert_admin(p_user);
        UPDATE prod.dct_documents
           SET is_active = 'N', updated_at = SYSTIMESTAMP
         WHERE doc_id = p_doc_id AND source_module = 'PAY';
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20404, 'Document not found: ' || p_doc_id);
        END IF;
    END delete_doc;

    -- ------------------------------------------------- contract renewal sweep
    PROCEDURE sweep_renewals IS
        l_sent NUMBER := 0;
    BEGIN
        FOR c IN (
            SELECT ct.contract_id, ct.contract_no, ct.date_to, co.name_en AS company_name,
                   TRUNC(ct.date_to) - TRUNC(SYSDATE) AS days_left
            FROM prod.dct_pay_contract ct
            JOIN prod.dct_pay_company co ON co.company_id = ct.company_id
            WHERE ct.status = 'ACTIVE'
              AND ct.is_active = 'Y'
              AND ct.date_to IS NOT NULL
              AND TRUNC(ct.date_to) - TRUNC(SYSDATE) BETWEEN 0 AND NVL(ct.renewal_alert_days, 60)
              AND (ct.last_renewal_notified_at IS NULL
                   OR ct.last_renewal_notified_at < SYSDATE - 7)
        ) LOOP
            FOR u IN (
                SELECT DISTINCT ur.user_id
                FROM prod.dct_user_roles ur
                JOIN prod.dct_roles r ON r.role_id = ur.role_id
                WHERE r.role_code = 'PAY_ADMIN'
                  AND (ur.end_date IS NULL OR ur.end_date >= SYSDATE)
            ) LOOP
                prod.dct_notify.send(
                    p_recipient_user_id => u.user_id,
                    p_notification_type => 'PAY_CONTRACT_RENEWAL',
                    p_title_en          => 'Outsource contract expiring soon',
                    p_body_en           => 'Contract ' || c.contract_no || ' (' || c.company_name ||
                                           ') expires in ' || c.days_left || ' day(s) on ' ||
                                           TO_CHAR(c.date_to, 'YYYY-MM-DD') || '.',
                    p_title_ar          => 'عقد إسناد خارجي يوشك على الانتهاء',
                    p_body_ar           => 'العقد ' || c.contract_no || ' (' || c.company_name ||
                                           ') ينتهي خلال ' || c.days_left || ' يوم بتاريخ ' ||
                                           TO_CHAR(c.date_to, 'YYYY-MM-DD') || '.',
                    p_module_code       => 'PAY',
                    p_link_url          => '#contracts');
            END LOOP;
            UPDATE prod.dct_pay_contract
               SET last_renewal_notified_at = SYSDATE
             WHERE contract_id = c.contract_id;
            l_sent := l_sent + 1;
        END LOOP;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('sweep_renewals: alerts sent for ' || l_sent || ' contract(s)');
    END sweep_renewals;

END dct_pay_pkg;
/

SHOW ERRORS PACKAGE prod.dct_pay_pkg
SHOW ERRORS PACKAGE BODY prod.dct_pay_pkg

-- =============================================================================
-- Daily renewal-alert job (0720 UTC, after the platform approval sweep)
-- =============================================================================
DECLARE
    l_n NUMBER;
BEGIN
    SELECT COUNT(*) INTO l_n FROM all_scheduler_jobs
    WHERE owner = 'PROD' AND job_name = 'DCT_PAY_RENEWAL_JOB';
    IF l_n > 0 THEN
        DBMS_SCHEDULER.DROP_JOB('PROD.DCT_PAY_RENEWAL_JOB', force => TRUE);
    END IF;
    DBMS_SCHEDULER.CREATE_JOB(
        job_name        => 'PROD.DCT_PAY_RENEWAL_JOB',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN prod.dct_pay_pkg.sweep_renewals; END;',
        start_date      => SYSTIMESTAMP,
        repeat_interval => 'FREQ=DAILY;BYHOUR=7;BYMINUTE=20',
        enabled         => TRUE,
        comments        => 'Outsource Payroll (App 215): daily contract renewal alerts to PAY_ADMIN users');
    DBMS_OUTPUT.PUT_LINE('Job scheduled: DCT_PAY_RENEWAL_JOB (daily 07:20 UTC)');
END;
/

PROMPT === 03_pay_pkg.sql complete: DCT_PAY_PKG + DCT_PAY_RENEWAL_JOB ===
