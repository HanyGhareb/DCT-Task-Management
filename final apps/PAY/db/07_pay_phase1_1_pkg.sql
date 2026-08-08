-- PAY Phase 1.1 governance business rules
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

CREATE OR REPLACE PACKAGE prod.dct_pay_gov_pkg AS
  PROCEDURE save_company_governance(p_user VARCHAR2,p_company_id NUMBER,p_contract_owner NUMBER,
    p_business_owner NUMBER,p_payroll_owner NUMBER,p_finance_owner NUMBER,p_backup_owner NUMBER,
    p_country VARCHAR2,p_row_version NUMBER,o_version OUT NUMBER);
  PROCEDURE save_contract_controls(p_user VARCHAR2,p_contract_id NUMBER,p_contract_value NUMBER,
    p_annual_value NUMBER,p_approved_headcount NUMBER,p_min_headcount NUMBER,p_max_headcount NUMBER,
    p_po_number VARCHAR2,p_owner NUMBER,p_renewal_status VARCHAR2,p_renewal_due DATE,
    p_row_version NUMBER,o_version OUT NUMBER);
  PROCEDURE save_contact(p_user VARCHAR2,p_contact_id NUMBER,p_company_id NUMBER,p_type VARCHAR2,
    p_name VARCHAR2,p_title VARCHAR2,p_email VARCHAR2,p_phone VARCHAR2,p_from DATE,p_to DATE,
    p_primary VARCHAR2,p_active VARCHAR2,p_row_version NUMBER,o_id OUT NUMBER,o_version OUT NUMBER);
  PROCEDURE save_compliance(p_user VARCHAR2,p_id NUMBER,p_company_id NUMBER,p_type VARCHAR2,
    p_reference VARCHAR2,p_issue DATE,p_expiry DATE,p_alert_days NUMBER,p_blocking VARCHAR2,
    p_doc_id NUMBER,p_notes VARCHAR2,p_active VARCHAR2,p_row_version NUMBER,o_id OUT NUMBER,o_version OUT NUMBER);
  PROCEDURE save_fee(p_user VARCHAR2,p_id NUMBER,p_contract_id NUMBER,p_type VARCHAR2,p_method VARCHAR2,
    p_value NUMBER,p_scope VARCHAR2,p_from DATE,p_to DATE,p_min NUMBER,p_max NUMBER,p_vat VARCHAR2,
    p_notes VARCHAR2,p_active VARCHAR2,p_row_version NUMBER,o_id OUT NUMBER,o_version OUT NUMBER);
  PROCEDURE save_renewal_action(p_user VARCHAR2,p_id NUMBER,p_contract_id NUMBER,p_action VARCHAR2,
    p_status VARCHAR2,p_owner NUMBER,p_target DATE,p_notes VARCHAR2,o_id OUT NUMBER);
  PROCEDURE save_score(p_user VARCHAR2,p_company_id NUMBER,p_from DATE,p_to DATE,
    p_timeliness NUMBER,p_accuracy NUMBER,p_compliance NUMBER,p_complaints NUMBER,p_sla NUMBER,
    p_notes VARCHAR2,o_id OUT NUMBER);
  PROCEDURE amend_contract(p_user VARCHAR2,p_contract_id NUMBER,p_new_no VARCHAR2,p_type VARCHAR2,
    p_reason VARCHAR2,p_effective DATE,p_document_id NUMBER,o_new_id OUT NUMBER);
  PROCEDURE validate_supplier_ref(p_supplier_number VARCHAR2,p_site VARCHAR2,p_iban VARCHAR2,
    p_account_no VARCHAR2,o_registry_id OUT NUMBER,o_status OUT VARCHAR2,o_message OUT VARCHAR2);
  PROCEDURE refresh_supplier_status(p_supplier_ref_id NUMBER DEFAULT NULL);
  FUNCTION mask_bank(p_value VARCHAR2) RETURN VARCHAR2 DETERMINISTIC;
END dct_pay_gov_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_pay_gov_pkg AS
  PROCEDURE req(p_ok BOOLEAN,p_msg VARCHAR2) IS BEGIN IF NOT p_ok THEN RAISE_APPLICATION_ERROR(-20001,p_msg); END IF; END;
  PROCEDURE admin(p_user VARCHAR2) IS BEGIN prod.dct_pay_pkg.assert_admin(p_user); END;
  PROCEDURE yn(p_v VARCHAR2,p_name VARCHAR2) IS BEGIN req(NVL(p_v,'N') IN('Y','N'),p_name||' must be Y or N'); END;
  PROCEDURE score(p_v NUMBER,p_name VARCHAR2) IS BEGIN req(p_v IS NULL OR p_v BETWEEN 0 AND 100,p_name||' must be between 0 and 100'); END;

  FUNCTION mask_bank(p_value VARCHAR2) RETURN VARCHAR2 DETERMINISTIC IS
  BEGIN
    IF p_value IS NULL THEN RETURN NULL; END IF;
    RETURN CASE WHEN LENGTH(p_value)<=4 THEN LPAD(SUBSTR(p_value,-2),LENGTH(p_value),'*')
                ELSE RPAD('*',LENGTH(p_value)-4,'*')||SUBSTR(p_value,-4) END;
  END;

  PROCEDURE save_company_governance(p_user VARCHAR2,p_company_id NUMBER,p_contract_owner NUMBER,
    p_business_owner NUMBER,p_payroll_owner NUMBER,p_finance_owner NUMBER,p_backup_owner NUMBER,
    p_country VARCHAR2,p_row_version NUMBER,o_version OUT NUMBER) IS
  BEGIN
    admin(p_user);
    UPDATE prod.dct_pay_company SET contract_owner_user_id=p_contract_owner,business_owner_user_id=p_business_owner,
      payroll_owner_user_id=p_payroll_owner,finance_owner_user_id=p_finance_owner,backup_owner_user_id=p_backup_owner,
      country_code=UPPER(p_country),updated_by=p_user,updated_at=SYSDATE,row_version=row_version+1
    WHERE company_id=p_company_id AND row_version=p_row_version RETURNING row_version INTO o_version;
    req(SQL%ROWCOUNT=1,'Company changed by another user; reload and retry');
  END;

  PROCEDURE save_contract_controls(p_user VARCHAR2,p_contract_id NUMBER,p_contract_value NUMBER,
    p_annual_value NUMBER,p_approved_headcount NUMBER,p_min_headcount NUMBER,p_max_headcount NUMBER,
    p_po_number VARCHAR2,p_owner NUMBER,p_renewal_status VARCHAR2,p_renewal_due DATE,
    p_row_version NUMBER,o_version OUT NUMBER) IS
  BEGIN
    admin(p_user); prod.dct_lookup_pkg.validate_lookup('PAY_RENEWAL_STATUS',NVL(p_renewal_status,'NOT_STARTED'));
    req(p_contract_value IS NULL OR p_contract_value>=0,'Contract value cannot be negative');
    req(p_annual_value IS NULL OR p_annual_value>=0,'Annual value cannot be negative');
    req(p_min_headcount IS NULL OR p_max_headcount IS NULL OR p_max_headcount>=p_min_headcount,'Maximum headcount must be at least minimum');
    req(p_approved_headcount IS NULL OR p_min_headcount IS NULL OR p_approved_headcount>=p_min_headcount,'Approved headcount is below minimum');
    req(p_approved_headcount IS NULL OR p_max_headcount IS NULL OR p_approved_headcount<=p_max_headcount,'Approved headcount exceeds maximum');
    UPDATE prod.dct_pay_contract SET contract_value=p_contract_value,annual_value=p_annual_value,
      approved_headcount=p_approved_headcount,min_headcount=p_min_headcount,max_headcount=p_max_headcount,
      po_number=p_po_number,contract_owner_user_id=p_owner,renewal_status=NVL(p_renewal_status,'NOT_STARTED'),
      renewal_due_date=p_renewal_due,updated_by=p_user,updated_at=SYSDATE,row_version=row_version+1
    WHERE contract_id=p_contract_id AND row_version=p_row_version RETURNING row_version INTO o_version;
    req(SQL%ROWCOUNT=1,'Contract changed by another user; reload and retry');
  END;

  PROCEDURE save_contact(p_user VARCHAR2,p_contact_id NUMBER,p_company_id NUMBER,p_type VARCHAR2,
    p_name VARCHAR2,p_title VARCHAR2,p_email VARCHAR2,p_phone VARCHAR2,p_from DATE,p_to DATE,
    p_primary VARCHAR2,p_active VARCHAR2,p_row_version NUMBER,o_id OUT NUMBER,o_version OUT NUMBER) IS l_n NUMBER;
  BEGIN
    admin(p_user); req(p_company_id IS NOT NULL,'Company is required'); req(TRIM(p_name) IS NOT NULL,'Contact name is required');
    prod.dct_lookup_pkg.validate_lookup('PAY_CONTACT_TYPE',p_type); yn(p_primary,'Primary flag'); yn(p_active,'Active flag');
    req(p_to IS NULL OR p_to>=NVL(p_from,TRUNC(SYSDATE)),'Contact effective dates are invalid');
    SELECT COUNT(*) INTO l_n FROM prod.dct_pay_company WHERE company_id=p_company_id; req(l_n=1,'Company not found');
    IF NVL(p_primary,'N')='Y' THEN UPDATE prod.dct_pay_company_contact SET is_primary='N',updated_by=p_user,updated_at=SYSTIMESTAMP,row_version=row_version+1
      WHERE company_id=p_company_id AND contact_type=p_type AND is_primary='Y' AND is_active='Y' AND (p_contact_id IS NULL OR contact_id<>p_contact_id); END IF;
    IF p_contact_id IS NULL THEN
      INSERT INTO prod.dct_pay_company_contact(company_id,contact_type,contact_name,job_title,email,phone,effective_from,effective_to,is_primary,is_active,created_by)
      VALUES(p_company_id,p_type,TRIM(p_name),p_title,p_email,p_phone,NVL(p_from,TRUNC(SYSDATE)),p_to,NVL(p_primary,'N'),NVL(p_active,'Y'),p_user)
      RETURNING contact_id,row_version INTO o_id,o_version;
    ELSE
      UPDATE prod.dct_pay_company_contact SET contact_type=p_type,contact_name=TRIM(p_name),job_title=p_title,email=p_email,phone=p_phone,
        effective_from=NVL(p_from,effective_from),effective_to=p_to,is_primary=NVL(p_primary,'N'),is_active=NVL(p_active,'Y'),updated_by=p_user,updated_at=SYSTIMESTAMP,row_version=row_version+1
      WHERE contact_id=p_contact_id AND company_id=p_company_id AND row_version=p_row_version RETURNING row_version INTO o_version;
      req(SQL%ROWCOUNT=1,'Contact changed by another user; reload and retry'); o_id:=p_contact_id;
    END IF;
  END;

  PROCEDURE save_compliance(p_user VARCHAR2,p_id NUMBER,p_company_id NUMBER,p_type VARCHAR2,
    p_reference VARCHAR2,p_issue DATE,p_expiry DATE,p_alert_days NUMBER,p_blocking VARCHAR2,
    p_doc_id NUMBER,p_notes VARCHAR2,p_active VARCHAR2,p_row_version NUMBER,o_id OUT NUMBER,o_version OUT NUMBER) IS l_n NUMBER;l_status VARCHAR2(20);
  BEGIN
    admin(p_user); prod.dct_lookup_pkg.validate_lookup('PAY_COMPLIANCE_TYPE',p_type); yn(p_blocking,'Blocking flag'); yn(p_active,'Active flag');
    req(p_expiry IS NULL OR p_issue IS NULL OR p_expiry>=p_issue,'Compliance dates are invalid'); req(NVL(p_alert_days,60)>=0,'Alert days cannot be negative');
    SELECT COUNT(*) INTO l_n FROM prod.dct_pay_company WHERE company_id=p_company_id; req(l_n=1,'Company not found');
    IF p_doc_id IS NOT NULL THEN SELECT COUNT(*) INTO l_n FROM prod.dct_documents WHERE doc_id=p_doc_id AND source_module='PAY' AND source_type='PAY_COMPANY' AND source_id=p_company_id AND is_active='Y'; req(l_n=1,'Document does not belong to this company'); END IF;
    l_status:=CASE WHEN p_expiry<TRUNC(SYSDATE) THEN 'EXPIRED' WHEN p_expiry<=TRUNC(SYSDATE)+NVL(p_alert_days,60) THEN 'EXPIRING' ELSE 'VALID' END;
    IF p_id IS NULL THEN INSERT INTO prod.dct_pay_compliance_item(company_id,compliance_type,reference_no,issue_date,expiry_date,alert_days,status,blocking_flag,doc_id,notes,is_active,created_by)
      VALUES(p_company_id,p_type,p_reference,p_issue,p_expiry,NVL(p_alert_days,60),l_status,NVL(p_blocking,'N'),p_doc_id,p_notes,NVL(p_active,'Y'),p_user)
      RETURNING compliance_id,row_version INTO o_id,o_version;
    ELSE UPDATE prod.dct_pay_compliance_item SET compliance_type=p_type,reference_no=p_reference,issue_date=p_issue,expiry_date=p_expiry,alert_days=NVL(p_alert_days,60),status=l_status,
      blocking_flag=NVL(p_blocking,'N'),doc_id=p_doc_id,notes=p_notes,is_active=NVL(p_active,'Y'),updated_by=p_user,updated_at=SYSTIMESTAMP,row_version=row_version+1
      WHERE compliance_id=p_id AND company_id=p_company_id AND row_version=p_row_version RETURNING row_version INTO o_version;
      req(SQL%ROWCOUNT=1,'Compliance item changed by another user; reload and retry');o_id:=p_id; END IF;
  END;

  PROCEDURE save_fee(p_user VARCHAR2,p_id NUMBER,p_contract_id NUMBER,p_type VARCHAR2,p_method VARCHAR2,
    p_value NUMBER,p_scope VARCHAR2,p_from DATE,p_to DATE,p_min NUMBER,p_max NUMBER,p_vat VARCHAR2,
    p_notes VARCHAR2,p_active VARCHAR2,p_row_version NUMBER,o_id OUT NUMBER,o_version OUT NUMBER) IS l_n NUMBER;l_status VARCHAR2(30);l_cf DATE;l_ct DATE;
  BEGIN
    admin(p_user); prod.dct_lookup_pkg.validate_lookup('PAY_FEE_TYPE',p_type);prod.dct_lookup_pkg.validate_lookup('PAY_FEE_METHOD',p_method);prod.dct_lookup_pkg.validate_lookup('PAY_PAYMENT_SCOPE',p_scope);
    yn(p_vat,'VAT flag');yn(p_active,'Active flag');req(p_value>=0,'Fee value cannot be negative');req(p_to IS NULL OR p_to>=p_from,'Fee dates are invalid');req(p_max IS NULL OR p_min IS NULL OR p_max>=p_min,'Maximum must be at least minimum');
    BEGIN SELECT status,date_from,date_to INTO l_status,l_cf,l_ct FROM prod.dct_pay_contract WHERE contract_id=p_contract_id;EXCEPTION WHEN NO_DATA_FOUND THEN RAISE_APPLICATION_ERROR(-20404,'Contract not found');END;
    req(l_status<>'SUPERSEDED','Superseded contract versions are immutable');req(p_from>=l_cf AND (l_ct IS NULL OR NVL(p_to,p_from)<=l_ct),'Fee dates must fall within contract dates');
    SELECT COUNT(*) INTO l_n FROM prod.dct_pay_fee_rule WHERE contract_id=p_contract_id AND fee_type=p_type AND payment_scope=p_scope AND is_active='Y' AND (p_id IS NULL OR fee_rule_id<>p_id)
      AND NVL(effective_to,DATE'4712-12-31')>=p_from AND effective_from<=NVL(p_to,DATE'4712-12-31');req(l_n=0,'An active fee rule overlaps this period');
    IF p_id IS NULL THEN INSERT INTO prod.dct_pay_fee_rule(contract_id,fee_type,method,rate_value,payment_scope,effective_from,effective_to,min_amount,max_amount,vat_applicable,notes,is_active,created_by)
      VALUES(p_contract_id,p_type,p_method,p_value,p_scope,p_from,p_to,p_min,p_max,NVL(p_vat,'Y'),p_notes,NVL(p_active,'Y'),p_user) RETURNING fee_rule_id,row_version INTO o_id,o_version;
    ELSE UPDATE prod.dct_pay_fee_rule SET fee_type=p_type,method=p_method,rate_value=p_value,payment_scope=p_scope,effective_from=p_from,effective_to=p_to,min_amount=p_min,max_amount=p_max,vat_applicable=NVL(p_vat,'Y'),notes=p_notes,is_active=NVL(p_active,'Y'),updated_by=p_user,updated_at=SYSTIMESTAMP,row_version=row_version+1
      WHERE fee_rule_id=p_id AND contract_id=p_contract_id AND row_version=p_row_version RETURNING row_version INTO o_version;req(SQL%ROWCOUNT=1,'Fee rule changed by another user; reload and retry');o_id:=p_id;END IF;
  END;

  PROCEDURE save_renewal_action(p_user VARCHAR2,p_id NUMBER,p_contract_id NUMBER,p_action VARCHAR2,
    p_status VARCHAR2,p_owner NUMBER,p_target DATE,p_notes VARCHAR2,o_id OUT NUMBER) IS l_n NUMBER;
  BEGIN admin(p_user);prod.dct_lookup_pkg.validate_lookup('PAY_RENEWAL_ACTION',p_action);prod.dct_lookup_pkg.validate_lookup('PAY_RENEWAL_STATUS',p_status);
    SELECT COUNT(*) INTO l_n FROM prod.dct_pay_contract WHERE contract_id=p_contract_id;req(l_n=1,'Contract not found');
    IF p_id IS NULL THEN INSERT INTO prod.dct_pay_renewal_action(contract_id,action_code,action_status,owner_user_id,target_date,notes,created_by) VALUES(p_contract_id,p_action,p_status,p_owner,p_target,p_notes,p_user) RETURNING renewal_action_id INTO o_id;
    ELSE UPDATE prod.dct_pay_renewal_action SET action_code=p_action,action_status=p_status,owner_user_id=p_owner,target_date=p_target,notes=p_notes,completed_at=CASE WHEN p_status IN('RENEWED','TERMINATED','NOT_RENEWING') THEN SYSTIMESTAMP END,updated_by=p_user,updated_at=SYSTIMESTAMP WHERE renewal_action_id=p_id AND contract_id=p_contract_id;req(SQL%ROWCOUNT=1,'Renewal action not found');o_id:=p_id;END IF;
  END;

  PROCEDURE save_score(p_user VARCHAR2,p_company_id NUMBER,p_from DATE,p_to DATE,p_timeliness NUMBER,p_accuracy NUMBER,p_compliance NUMBER,p_complaints NUMBER,p_sla NUMBER,p_notes VARCHAR2,o_id OUT NUMBER) IS l_overall NUMBER;l_risk VARCHAR2(20);
  BEGIN admin(p_user);req(p_to>=p_from,'Score period is invalid');score(p_timeliness,'Timeliness');score(p_accuracy,'Invoice accuracy');score(p_compliance,'Compliance');score(p_complaints,'Complaints');score(p_sla,'SLA');
    l_overall:=ROUND((NVL(p_timeliness,0)+NVL(p_accuracy,0)+NVL(p_compliance,0)+NVL(p_complaints,0)+NVL(p_sla,0))/5,2);
    l_risk:=CASE WHEN l_overall>=85 THEN 'LOW' WHEN l_overall>=70 THEN 'MEDIUM' WHEN l_overall>=50 THEN 'HIGH' ELSE 'CRITICAL' END;
    INSERT INTO prod.dct_pay_company_score(company_id,period_from,period_to,payroll_timeliness,invoice_accuracy,compliance_score,complaint_score,sla_score,overall_score,risk_rating,notes,created_by)
    VALUES(p_company_id,p_from,p_to,p_timeliness,p_accuracy,p_compliance,p_complaints,p_sla,l_overall,l_risk,p_notes,p_user) RETURNING score_id INTO o_id;
    UPDATE prod.dct_pay_company SET risk_rating=l_risk,updated_by=p_user,updated_at=SYSDATE,row_version=row_version+1 WHERE company_id=p_company_id;
  END;

  PROCEDURE amend_contract(p_user VARCHAR2,p_contract_id NUMBER,p_new_no VARCHAR2,p_type VARCHAR2,p_reason VARCHAR2,p_effective DATE,p_document_id NUMBER,o_new_id OUT NUMBER) IS l_json CLOB;
  BEGIN admin(p_user);prod.dct_lookup_pkg.validate_lookup('PAY_AMENDMENT_TYPE',p_type);req(TRIM(p_reason) IS NOT NULL,'Amendment reason is required');req(p_effective IS NOT NULL,'Amendment effective date is required');
    prod.dct_pay_pkg.amend_contract(p_user,p_contract_id,p_new_no,o_new_id);
    SELECT JSON_OBJECT('oldContractId' VALUE p_contract_id,'newContractId' VALUE o_new_id,'amendmentType' VALUE p_type,'effectiveDate' VALUE TO_CHAR(p_effective,'YYYY-MM-DD') RETURNING CLOB) INTO l_json FROM dual;
    INSERT INTO prod.dct_pay_contract_change(old_contract_id,new_contract_id,amendment_type,reason,effective_date,change_json,document_id,created_by) VALUES(p_contract_id,o_new_id,p_type,p_reason,p_effective,l_json,p_document_id,p_user);
  END;

  PROCEDURE validate_supplier_ref(p_supplier_number VARCHAR2,p_site VARCHAR2,p_iban VARCHAR2,p_account_no VARCHAR2,o_registry_id OUT NUMBER,o_status OUT VARCHAR2,o_message OUT VARCHAR2) IS l_n NUMBER;l_site NUMBER;l_bank NUMBER;
  BEGIN
    SELECT COUNT(DISTINCT registry_id),MIN(registry_id) INTO l_n,o_registry_id FROM prod.atd_suppliers WHERE TO_CHAR(supplier_number)=TRIM(p_supplier_number) AND UPPER(NVL(status,'ACTIVE'))<>'INACTIVE';
    IF l_n=0 THEN o_status:='MISSING';o_message:='Supplier is missing or inactive in Fusion extract';RETURN;END IF;
    SELECT COUNT(*) INTO l_site FROM prod.atd_supplier_sites WHERE registry_id=o_registry_id AND site=p_site AND NVL(inactive_date,DATE'4712-12-31')>=TRUNC(SYSDATE) AND UPPER(NVL(pay_flag,'YES')) IN('Y','YES');
    SELECT COUNT(*) INTO l_bank FROM prod.atd_supplier_bank_accounts WHERE registry_id=o_registry_id AND (iban=p_iban OR bank_account_number=p_account_no) AND NVL(assignment_inactive_on,DATE'4712-12-31')>=TRUNC(SYSDATE);
    IF l_site=0 THEN o_status:='SITE_DISABLED';o_message:='Supplier site is missing, inactive, or not payment-enabled';
    ELSIF l_bank=0 THEN o_status:='BANK_CHANGED';o_message:='Bank account no longer matches the Fusion supplier registry';
    ELSE o_status:='VALID';o_message:='Supplier, site, and bank validated against Fusion';END IF;
  END;

  PROCEDURE refresh_supplier_status(p_supplier_ref_id NUMBER DEFAULT NULL) IS l_reg NUMBER;l_st VARCHAR2(20);l_msg VARCHAR2(1000);
  BEGIN FOR r IN(SELECT * FROM prod.dct_pay_company_supplier WHERE p_supplier_ref_id IS NULL OR supplier_ref_id=p_supplier_ref_id) LOOP
    validate_supplier_ref(r.supplier_number,r.supplier_site,r.iban,r.bank_account_no,l_reg,l_st,l_msg);
    UPDATE prod.dct_pay_company_supplier SET fusion_registry_id=l_reg,sync_status=l_st,last_sync_checked_at=SYSTIMESTAMP,updated_at=SYSDATE,row_version=row_version+1 WHERE supplier_ref_id=r.supplier_ref_id;
  END LOOP;END;
END dct_pay_gov_pkg;
/
SHOW ERRORS PACKAGE prod.dct_pay_gov_pkg
SHOW ERRORS PACKAGE BODY prod.dct_pay_gov_pkg

CREATE OR REPLACE TRIGGER prod.trg_pay_contract_immutable
BEFORE UPDATE OR DELETE ON prod.dct_pay_contract FOR EACH ROW
BEGIN
  IF :OLD.status='SUPERSEDED' THEN RAISE_APPLICATION_ERROR(-20001,'Superseded contract versions are immutable'); END IF;
END;
/

CREATE OR REPLACE TRIGGER prod.trg_pay_margin_immutable
BEFORE INSERT OR UPDATE OR DELETE ON prod.dct_pay_margin_rule FOR EACH ROW
DECLARE l_status VARCHAR2(30);l_contract NUMBER:=NVL(:NEW.contract_id,:OLD.contract_id);
BEGIN
  SELECT status INTO l_status FROM prod.dct_pay_contract WHERE contract_id=l_contract;
  IF l_status='SUPERSEDED' THEN RAISE_APPLICATION_ERROR(-20001,'Rules of superseded contracts are immutable'); END IF;
END;
/

CREATE OR REPLACE TRIGGER prod.trg_pay_supplier_validate
BEFORE INSERT OR UPDATE OF supplier_number,supplier_site,iban,bank_account_no ON prod.dct_pay_company_supplier
FOR EACH ROW
DECLARE l_registry NUMBER;l_status VARCHAR2(20);l_message VARCHAR2(1000);
BEGIN
  prod.dct_pay_gov_pkg.validate_supplier_ref(:NEW.supplier_number,:NEW.supplier_site,:NEW.iban,:NEW.bank_account_no,l_registry,l_status,l_message);
  IF l_status<>'VALID' THEN RAISE_APPLICATION_ERROR(-20001,l_message); END IF;
  :NEW.fusion_registry_id:=l_registry;:NEW.sync_status:=l_status;:NEW.last_sync_checked_at:=SYSTIMESTAMP;
END;
/

PROMPT === PAY Phase 1.1 governance package complete ===
