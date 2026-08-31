-- =============================================================================
-- Outsource Payroll Module (App 215) -- DDL -- Phase 1: Companies and Contracts
-- File    : 01_pay_ddl.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @01_pay_ddl.sql   (connects as ADMIN)
-- Requires: V2 shared framework -- DCT_USERS, DCT_DOCUMENTS, DCT_LOOKUP_PKG,
--           DCT_NOTIFY, ATD_SUPPLIERS already present.
-- Notes   : Lookup-first -- NO status CHECK constraints on these tables; the
--           status/type families live in DCT_LOOKUP_VALUES and are validated
--           by DCT_PAY_PKG via DCT_LOOKUP_PKG.validate_lookup.
--           Y/N flag CHECKs are kept (booleans).
--           A company may carry ONE OR MORE supplier / site / bank references
--           (child DCT_PAY_COMPANY_SUPPLIER, checked against ATD_SUPPLIERS).
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- Cleanup of prior objects (reverse dependency order) -- safe re-run
-- =============================================================================
DECLARE
    PROCEDURE drop_table (p_name VARCHAR2) IS
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE prod.' || p_name || ' CASCADE CONSTRAINTS PURGE';
        DBMS_OUTPUT.PUT_LINE('Dropped: ' || p_name);
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE != -942 THEN RAISE; END IF;
    END;
BEGIN
    drop_table('DCT_PAY_MARGIN_RULE');
    drop_table('DCT_PAY_CONTRACT');
    drop_table('DCT_PAY_COMPANY_SUPPLIER');
    drop_table('DCT_PAY_COMPANY');
    drop_table('DCT_PAY_DCT_BANK');
END;
/

-- =============================================================================
-- 1. DCT_PAY_DCT_BANK -- DCT funding bank accounts (paying side)
-- =============================================================================
CREATE TABLE prod.dct_pay_dct_bank (
  bank_id          NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  bank_code        VARCHAR2(30)    NOT NULL,
  bank_name_en     VARCHAR2(200)   NOT NULL,
  bank_name_ar     VARCHAR2(200),
  account_name     VARCHAR2(200),
  account_number   VARCHAR2(40),
  iban             VARCHAR2(40),
  currency_code    VARCHAR2(3)     DEFAULT 'AED' NOT NULL,
  branch_name      VARCHAR2(200),
  notes            VARCHAR2(1000),
  is_active        VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
  created_by       VARCHAR2(100),
  created_at       DATE            DEFAULT SYSDATE NOT NULL,
  updated_by       VARCHAR2(100),
  updated_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT uq_dct_paybank_code UNIQUE (bank_code),
  CONSTRAINT chk_dct_paybank_act CHECK (is_active IN ('Y','N'))
);
COMMENT ON TABLE prod.dct_pay_dct_bank IS 'Outsource Payroll (App 215): DCT own funding bank accounts a payroll is paid from.';

-- =============================================================================
-- 2. DCT_PAY_COMPANY -- outsource company master
-- =============================================================================
CREATE TABLE prod.dct_pay_company (
  company_id       NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  company_code     VARCHAR2(30)    NOT NULL,
  name_en          VARCHAR2(200)   NOT NULL,
  name_ar          VARCHAR2(200),
  category         VARCHAR2(30)    DEFAULT 'MANPOWER' NOT NULL,   -- lookup PAY_COMPANY_CATEGORY
  status           VARCHAR2(30)    DEFAULT 'ACTIVE' NOT NULL,     -- lookup PAY_COMPANY_STATUS
  trn              VARCHAR2(30),                                  -- tax registration number
  license_no       VARCHAR2(60),
  phone            VARCHAR2(40),
  email            VARCHAR2(200),
  website          VARCHAR2(200),
  address_en       VARCHAR2(500),
  address_ar       VARCHAR2(500),
  contact_name     VARCHAR2(200),                                 -- primary contact person
  contact_email    VARCHAR2(200),
  contact_phone    VARCHAR2(40),
  notes            VARCHAR2(2000),
  is_active        VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
  created_by       VARCHAR2(100),
  created_at       DATE            DEFAULT SYSDATE NOT NULL,
  updated_by       VARCHAR2(100),
  updated_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT uq_dct_payco_code  UNIQUE (company_code),
  CONSTRAINT chk_dct_payco_act  CHECK (is_active IN ('Y','N'))
);
COMMENT ON TABLE prod.dct_pay_company IS 'Outsource Payroll (App 215): outsource company master. Category/status are lookup-first (PAY_COMPANY_CATEGORY / PAY_COMPANY_STATUS).';

-- =============================================================================
-- 3. DCT_PAY_COMPANY_SUPPLIER -- 1..N Fusion supplier / site / bank references
-- =============================================================================
CREATE TABLE prod.dct_pay_company_supplier (
  supplier_ref_id  NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  company_id       NUMBER          NOT NULL,
  supplier_number  VARCHAR2(40)    NOT NULL,                      -- Fusion supplier (ATD_SUPPLIERS)
  supplier_name    VARCHAR2(360),
  supplier_site    VARCHAR2(120),
  purpose          VARCHAR2(30)    DEFAULT 'ALL' NOT NULL,        -- lookup PAY_SUPPLIER_PURPOSE
  bank_name        VARCHAR2(200),
  iban             VARCHAR2(40),
  bank_account_no  VARCHAR2(40),
  currency_code    VARCHAR2(3)     DEFAULT 'AED' NOT NULL,
  payment_method   VARCHAR2(60),
  pay_group        VARCHAR2(60),
  payment_terms    VARCHAR2(60),
  is_default       VARCHAR2(1)     DEFAULT 'N' NOT NULL,          -- one default per purpose
  is_active        VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
  created_by       VARCHAR2(100),
  created_at       DATE            DEFAULT SYSDATE NOT NULL,
  updated_by       VARCHAR2(100),
  updated_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT fk_dct_paycs_company FOREIGN KEY (company_id) REFERENCES prod.dct_pay_company (company_id),
  CONSTRAINT chk_dct_paycs_def    CHECK (is_default IN ('Y','N')),
  CONSTRAINT chk_dct_paycs_act    CHECK (is_active IN ('Y','N'))
);
CREATE INDEX prod.ix_dct_paycs_company ON prod.dct_pay_company_supplier (company_id);
COMMENT ON TABLE prod.dct_pay_company_supplier IS 'Outsource Payroll (App 215): a company holds one or more Fusion supplier/site/bank references; one default per purpose. Values checked against ATD_SUPPLIERS on save.';

-- =============================================================================
-- 4. DCT_PAY_CONTRACT -- effective-dated company contracts + amendments
-- =============================================================================
CREATE TABLE prod.dct_pay_contract (
  contract_id        NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  company_id         NUMBER        NOT NULL,
  contract_no        VARCHAR2(60)  NOT NULL,
  title_en           VARCHAR2(300),
  title_ar           VARCHAR2(300),
  status             VARCHAR2(30)  DEFAULT 'DRAFT' NOT NULL,      -- lookup PAY_CONTRACT_STATUS
  date_from          DATE          NOT NULL,
  date_to            DATE,
  bu_code            VARCHAR2(10),                                -- lookup PAY_BU (DCT / MSS / AFH)
  supplier_ref_id    NUMBER,                                      -- supplier-site scope of the contract
  currency_code      VARCHAR2(3)   DEFAULT 'AED' NOT NULL,
  service_fee_amount NUMBER,
  vat_rate           NUMBER        DEFAULT 5,
  expiry_blocking    VARCHAR2(1)   DEFAULT 'N' NOT NULL,          -- block processing after expiry
  renewal_alert_days NUMBER        DEFAULT 60,
  last_renewal_notified_at DATE,
  parent_contract_id NUMBER,                                      -- amendment chain
  version_no         NUMBER        DEFAULT 1 NOT NULL,
  notes              VARCHAR2(2000),
  is_active          VARCHAR2(1)   DEFAULT 'Y' NOT NULL,
  created_by         VARCHAR2(100),
  created_at         DATE          DEFAULT SYSDATE NOT NULL,
  updated_by         VARCHAR2(100),
  updated_at         DATE          DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT uq_dct_payct_no      UNIQUE (contract_no),
  CONSTRAINT fk_dct_payct_company FOREIGN KEY (company_id)         REFERENCES prod.dct_pay_company (company_id),
  CONSTRAINT fk_dct_payct_supref  FOREIGN KEY (supplier_ref_id)    REFERENCES prod.dct_pay_company_supplier (supplier_ref_id),
  CONSTRAINT fk_dct_payct_parent  FOREIGN KEY (parent_contract_id) REFERENCES prod.dct_pay_contract (contract_id),
  CONSTRAINT chk_dct_payct_dates  CHECK (date_to IS NULL OR date_to >= date_from),
  CONSTRAINT chk_dct_payct_blk    CHECK (expiry_blocking IN ('Y','N')),
  CONSTRAINT chk_dct_payct_act    CHECK (is_active IN ('Y','N'))
);
CREATE INDEX prod.ix_dct_payct_company ON prod.dct_pay_contract (company_id);
CREATE INDEX prod.ix_dct_payct_dates   ON prod.dct_pay_contract (date_to);
COMMENT ON TABLE prod.dct_pay_contract IS 'Outsource Payroll (App 215): effective-dated company contracts; amendments chain via parent_contract_id + version_no (old version flips to SUPERSEDED).';

-- =============================================================================
-- 5. DCT_PAY_MARGIN_RULE -- effective-dated margin rules per contract
-- =============================================================================
CREATE TABLE prod.dct_pay_margin_rule (
  rule_id          NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  contract_id      NUMBER          NOT NULL,
  effective_from   DATE            NOT NULL,
  effective_to     DATE,
  method           VARCHAR2(30)    NOT NULL,                      -- lookup PAY_MARGIN_METHOD
  basis            VARCHAR2(30)    DEFAULT 'GROSS' NOT NULL,      -- lookup PAY_MARGIN_BASIS
  rate_value       NUMBER          NOT NULL,                      -- pct for PERCENT, amount otherwise
  vat_applicable   VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
  payment_scope    VARCHAR2(30)    DEFAULT 'ALL' NOT NULL,        -- lookup PAY_PAYMENT_SCOPE
  notes            VARCHAR2(1000),
  is_active        VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
  created_by       VARCHAR2(100),
  created_at       DATE            DEFAULT SYSDATE NOT NULL,
  updated_by       VARCHAR2(100),
  updated_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT fk_dct_paymr_contract FOREIGN KEY (contract_id) REFERENCES prod.dct_pay_contract (contract_id),
  CONSTRAINT chk_dct_paymr_dates   CHECK (effective_to IS NULL OR effective_to >= effective_from),
  CONSTRAINT chk_dct_paymr_vat     CHECK (vat_applicable IN ('Y','N')),
  CONSTRAINT chk_dct_paymr_act     CHECK (is_active IN ('Y','N'))
);
CREATE INDEX prod.ix_dct_paymr_contract ON prod.dct_pay_margin_rule (contract_id);
COMMENT ON TABLE prod.dct_pay_margin_rule IS 'Outsource Payroll (App 215): effective-dated margin rules per contract (method PERCENT/FLAT/PER_EMPLOYEE/PER_ELEMENT, basis BASIC/GROSS/NET/SELECTED, scope ALL/MONTHLY/SEPARATE).';

PROMPT === 01_pay_ddl.sql complete: 5 DCT_PAY_* tables in PROD ===
