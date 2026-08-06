-- PAY Phase 1.1 governance enhancements (additive; never drops business data)
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

ALTER SESSION SET CURRENT_SCHEMA = PROD;

DECLARE
  PROCEDURE add_col(p_table VARCHAR2, p_col VARCHAR2, p_ddl VARCHAR2) IS l_n NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_n FROM all_tab_columns
     WHERE owner='PROD' AND table_name=UPPER(p_table) AND column_name=UPPER(p_col);
    IF l_n=0 THEN EXECUTE IMMEDIATE 'ALTER TABLE '||p_table||' ADD ('||p_ddl||')'; END IF;
  END;
BEGIN
  add_col('DCT_PAY_COMPANY','CONTRACT_OWNER_USER_ID','contract_owner_user_id NUMBER');
  add_col('DCT_PAY_COMPANY','BUSINESS_OWNER_USER_ID','business_owner_user_id NUMBER');
  add_col('DCT_PAY_COMPANY','PAYROLL_OWNER_USER_ID','payroll_owner_user_id NUMBER');
  add_col('DCT_PAY_COMPANY','FINANCE_OWNER_USER_ID','finance_owner_user_id NUMBER');
  add_col('DCT_PAY_COMPANY','BACKUP_OWNER_USER_ID','backup_owner_user_id NUMBER');
  add_col('DCT_PAY_COMPANY','COUNTRY_CODE','country_code VARCHAR2(3)');
  add_col('DCT_PAY_COMPANY','RISK_RATING','risk_rating VARCHAR2(20)');
  add_col('DCT_PAY_COMPANY','ROW_VERSION','row_version NUMBER DEFAULT 1 NOT NULL');

  add_col('DCT_PAY_COMPANY_SUPPLIER','FUSION_SITE_ID','fusion_site_id NUMBER');
  add_col('DCT_PAY_COMPANY_SUPPLIER','FUSION_BANK_ACCOUNT_ID','fusion_bank_account_id NUMBER');
  add_col('DCT_PAY_COMPANY_SUPPLIER','EFFECTIVE_FROM','effective_from DATE DEFAULT TRUNC(SYSDATE) NOT NULL');
  add_col('DCT_PAY_COMPANY_SUPPLIER','EFFECTIVE_TO','effective_to DATE');
  add_col('DCT_PAY_COMPANY_SUPPLIER','SYNC_STATUS','sync_status VARCHAR2(20) DEFAULT ''VALID'' NOT NULL');
  add_col('DCT_PAY_COMPANY_SUPPLIER','LAST_SYNC_CHECKED_AT','last_sync_checked_at TIMESTAMP');
  add_col('DCT_PAY_COMPANY_SUPPLIER','ROW_VERSION','row_version NUMBER DEFAULT 1 NOT NULL');

  add_col('DCT_PAY_CONTRACT','CONTRACT_VALUE','contract_value NUMBER');
  add_col('DCT_PAY_CONTRACT','ANNUAL_VALUE','annual_value NUMBER');
  add_col('DCT_PAY_CONTRACT','APPROVED_HEADCOUNT','approved_headcount NUMBER');
  add_col('DCT_PAY_CONTRACT','MIN_HEADCOUNT','min_headcount NUMBER');
  add_col('DCT_PAY_CONTRACT','MAX_HEADCOUNT','max_headcount NUMBER');
  add_col('DCT_PAY_CONTRACT','PO_NUMBER','po_number VARCHAR2(60)');
  add_col('DCT_PAY_CONTRACT','CONTRACT_OWNER_USER_ID','contract_owner_user_id NUMBER');
  add_col('DCT_PAY_CONTRACT','RENEWAL_STATUS','renewal_status VARCHAR2(30) DEFAULT ''NOT_STARTED''');
  add_col('DCT_PAY_CONTRACT','RENEWAL_DUE_DATE','renewal_due_date DATE');
  add_col('DCT_PAY_CONTRACT','ROW_VERSION','row_version NUMBER DEFAULT 1 NOT NULL');
END;
/

DECLARE
  PROCEDURE mk(p_name VARCHAR2,p_sql CLOB) IS l_n NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_n FROM all_tables WHERE owner='PROD' AND table_name=UPPER(p_name);
    IF l_n=0 THEN EXECUTE IMMEDIATE p_sql; END IF;
  END;
BEGIN
  mk('DCT_PAY_COMPANY_CONTACT', q'[
    CREATE TABLE dct_pay_company_contact(
      contact_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      company_id NUMBER NOT NULL REFERENCES dct_pay_company(company_id),
      contact_type VARCHAR2(30) NOT NULL, contact_name VARCHAR2(200) NOT NULL,
      job_title VARCHAR2(200), email VARCHAR2(200), phone VARCHAR2(40),
      effective_from DATE DEFAULT TRUNC(SYSDATE) NOT NULL, effective_to DATE,
      is_primary VARCHAR2(1) DEFAULT 'N' NOT NULL CHECK(is_primary IN('Y','N')),
      is_active VARCHAR2(1) DEFAULT 'Y' NOT NULL CHECK(is_active IN('Y','N')),
      row_version NUMBER DEFAULT 1 NOT NULL, created_by VARCHAR2(100),
      created_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL, updated_by VARCHAR2(100), updated_at TIMESTAMP,
      CHECK(effective_to IS NULL OR effective_to>=effective_from))]');
  mk('DCT_PAY_COMPLIANCE_ITEM', q'[
    CREATE TABLE dct_pay_compliance_item(
      compliance_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      company_id NUMBER NOT NULL REFERENCES dct_pay_company(company_id),
      compliance_type VARCHAR2(40) NOT NULL, reference_no VARCHAR2(100),
      issue_date DATE, expiry_date DATE, alert_days NUMBER DEFAULT 60,
      status VARCHAR2(20) DEFAULT 'VALID' NOT NULL, blocking_flag VARCHAR2(1) DEFAULT 'N' NOT NULL CHECK(blocking_flag IN('Y','N')),
      doc_id NUMBER, notes VARCHAR2(1000), is_active VARCHAR2(1) DEFAULT 'Y' NOT NULL CHECK(is_active IN('Y','N')),
      row_version NUMBER DEFAULT 1 NOT NULL, created_by VARCHAR2(100), created_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
      updated_by VARCHAR2(100), updated_at TIMESTAMP)]');
  mk('DCT_PAY_FEE_RULE', q'[
    CREATE TABLE dct_pay_fee_rule(
      fee_rule_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      contract_id NUMBER NOT NULL REFERENCES dct_pay_contract(contract_id),
      fee_type VARCHAR2(30) NOT NULL, method VARCHAR2(30) NOT NULL, rate_value NUMBER NOT NULL,
      payment_scope VARCHAR2(30) DEFAULT 'ALL' NOT NULL, effective_from DATE NOT NULL, effective_to DATE,
      min_amount NUMBER, max_amount NUMBER, vat_applicable VARCHAR2(1) DEFAULT 'Y' NOT NULL CHECK(vat_applicable IN('Y','N')),
      is_active VARCHAR2(1) DEFAULT 'Y' NOT NULL CHECK(is_active IN('Y','N')), notes VARCHAR2(1000),
      row_version NUMBER DEFAULT 1 NOT NULL, created_by VARCHAR2(100), created_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
      updated_by VARCHAR2(100), updated_at TIMESTAMP,
      CHECK(effective_to IS NULL OR effective_to>=effective_from), CHECK(rate_value>=0))]');
  mk('DCT_PAY_CONTRACT_CHANGE', q'[
    CREATE TABLE dct_pay_contract_change(
      change_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      old_contract_id NUMBER NOT NULL REFERENCES dct_pay_contract(contract_id),
      new_contract_id NUMBER NOT NULL REFERENCES dct_pay_contract(contract_id),
      amendment_type VARCHAR2(30), reason VARCHAR2(1000) NOT NULL, effective_date DATE NOT NULL,
      change_json CLOB CHECK(change_json IS JSON), document_id NUMBER,
      created_by VARCHAR2(100) NOT NULL, created_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
      UNIQUE(new_contract_id))]');
  mk('DCT_PAY_RENEWAL_ACTION', q'[
    CREATE TABLE dct_pay_renewal_action(
      renewal_action_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      contract_id NUMBER NOT NULL REFERENCES dct_pay_contract(contract_id),
      action_code VARCHAR2(30) NOT NULL, action_status VARCHAR2(30) DEFAULT 'OPEN' NOT NULL,
      owner_user_id NUMBER, target_date DATE, completed_at TIMESTAMP, notes VARCHAR2(1000),
      created_by VARCHAR2(100), created_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
      updated_by VARCHAR2(100), updated_at TIMESTAMP)]');
  mk('DCT_PAY_COMPANY_SCORE', q'[
    CREATE TABLE dct_pay_company_score(
      score_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      company_id NUMBER NOT NULL REFERENCES dct_pay_company(company_id),
      period_from DATE NOT NULL, period_to DATE NOT NULL,
      payroll_timeliness NUMBER, invoice_accuracy NUMBER, compliance_score NUMBER,
      complaint_score NUMBER, sla_score NUMBER, overall_score NUMBER,
      risk_rating VARCHAR2(20), notes VARCHAR2(1000), created_by VARCHAR2(100),
      created_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
      CHECK(period_to>=period_from))]');
END;
/

DECLARE
  PROCEDURE mk_idx(p_name VARCHAR2,p_sql VARCHAR2) IS l_n NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_n FROM all_indexes WHERE owner='PROD' AND index_name=UPPER(p_name);
    IF l_n=0 THEN EXECUTE IMMEDIATE p_sql; END IF;
  END;
BEGIN
  mk_idx('IX_PAY_CONTACT_COMPANY','CREATE INDEX ix_pay_contact_company ON dct_pay_company_contact(company_id)');
  mk_idx('IX_PAY_COMPLIANCE_COMPANY','CREATE INDEX ix_pay_compliance_company ON dct_pay_compliance_item(company_id,expiry_date)');
  mk_idx('IX_PAY_FEE_CONTRACT','CREATE INDEX ix_pay_fee_contract ON dct_pay_fee_rule(contract_id,effective_from)');
  mk_idx('IX_PAY_RENEW_CONTRACT','CREATE INDEX ix_pay_renew_contract ON dct_pay_renewal_action(contract_id,action_status)');
END;
/

CREATE OR REPLACE VIEW dct_pay_data_quality_v AS
SELECT c.company_id, c.company_code, c.name_en,
       CASE WHEN NOT EXISTS(SELECT 1 FROM dct_pay_company_contact x WHERE x.company_id=c.company_id AND x.is_active='Y') THEN 1 ELSE 0 END missing_contact,
       CASE WHEN NOT EXISTS(SELECT 1 FROM dct_pay_company_supplier s WHERE s.company_id=c.company_id AND s.is_active='Y' AND s.sync_status='VALID') THEN 1 ELSE 0 END missing_valid_supplier,
       (SELECT COUNT(*) FROM dct_pay_compliance_item q WHERE q.company_id=c.company_id AND q.is_active='Y' AND q.expiry_date<TRUNC(SYSDATE)) expired_compliance,
       (SELECT COUNT(*) FROM dct_pay_contract t WHERE t.company_id=c.company_id AND t.status='ACTIVE' AND NOT EXISTS(SELECT 1 FROM dct_pay_margin_rule m WHERE m.contract_id=t.contract_id AND m.is_active='Y')) contracts_without_margin,
       CASE WHEN c.contract_owner_user_id IS NULL THEN 1 ELSE 0 END missing_owner
FROM dct_pay_company c WHERE c.is_active='Y';

PROMPT === PAY Phase 1.1 additive DDL complete ===
