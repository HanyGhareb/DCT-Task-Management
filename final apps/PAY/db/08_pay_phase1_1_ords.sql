-- PAY Phase 1.1 additive governance API; re-run after 04_pay_ords.sql
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

CREATE OR REPLACE SYNONYM dct_pay_gov_pkg FOR prod.dct_pay_gov_pkg;
CREATE OR REPLACE SYNONYM dct_pay_company_contact FOR prod.dct_pay_company_contact;
CREATE OR REPLACE SYNONYM dct_pay_compliance_item FOR prod.dct_pay_compliance_item;
CREATE OR REPLACE SYNONYM dct_pay_fee_rule FOR prod.dct_pay_fee_rule;
CREATE OR REPLACE SYNONYM dct_pay_contract_change FOR prod.dct_pay_contract_change;
CREATE OR REPLACE SYNONYM dct_pay_renewal_action FOR prod.dct_pay_renewal_action;
CREATE OR REPLACE SYNONYM dct_pay_company_score FOR prod.dct_pay_company_score;
CREATE OR REPLACE SYNONYM dct_pay_doc_rule FOR prod.dct_pay_doc_rule;
CREATE OR REPLACE SYNONYM dct_pay_data_quality_v FOR prod.dct_pay_data_quality_v;
CREATE OR REPLACE SYNONYM atd_supplier_sites FOR prod.atd_supplier_sites;
CREATE OR REPLACE SYNONYM atd_supplier_bank_accounts FOR prod.atd_supplier_bank_accounts;
-- company dashboard (2026-08-09) reads Phase 2/3 objects - keep 08 self-contained
CREATE OR REPLACE SYNONYM dct_pay_assignment FOR prod.dct_pay_assignment;
CREATE OR REPLACE SYNONYM dct_employees FOR prod.dct_employees;
CREATE OR REPLACE SYNONYM dct_pay_payroll FOR prod.dct_pay_payroll;
CREATE OR REPLACE SYNONYM dct_pay_period FOR prod.dct_pay_period;
CREATE OR REPLACE SYNONYM dct_pay_run FOR prod.dct_pay_run;
CREATE OR REPLACE SYNONYM dct_pay_run_emp FOR prod.dct_pay_run_emp;
CREATE OR REPLACE SYNONYM dct_pay_margin_rule FOR prod.dct_pay_margin_rule;
CREATE OR REPLACE SYNONYM dct_users FOR prod.dct_users;

CREATE OR REPLACE PROCEDURE setup_pay_p11_ords_tmp AS
  c_mod CONSTANT VARCHAR2(30):='pay.rest';
  PROCEDURE tpl(p VARCHAR2) IS BEGIN ORDS.DEFINE_TEMPLATE(p_module_name=>c_mod,p_pattern=>REPLACE(p,'[COLON]',CHR(58))); END;
  PROCEDURE h(p VARCHAR2,m VARCHAR2,s CLOB) IS BEGIN
    ORDS.DEFINE_HANDLER(p_module_name=>c_mod,p_pattern=>REPLACE(p,'[COLON]',CHR(58)),p_method=>m,
      p_source_type=>ORDS.source_type_plsql,p_source=>REPLACE(s,'[COLON]',CHR(58)));
  END;
BEGIN
  -- Existing handler override: authenticated download; filename is header-sanitised.
  h('docs/[COLON]docId/file','GET',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;l_blob BLOB;l_mime VARCHAR2(100);l_name VARCHAR2(255);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
  BEGIN SELECT file_blob,NVL(mime_type,'application/octet-stream'),REPLACE(REPLACE(file_name,CHR(13),''),CHR(10),'')
    INTO l_blob,l_mime,l_name FROM dct_documents WHERE doc_id=TO_NUMBER([COLON]docId) AND source_module='PAY' AND is_active='Y';
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Document not found');RETURN;END;
  OWA_UTIL.mime_header(l_mime,FALSE);HTP.p('Content-Disposition[COLON] attachment; filename="'||REPLACE(l_name,'"','')||'"');
  OWA_UTIL.http_header_close;WPG_DOCLOAD.download_file(l_blob);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');

  -- Existing handler override: mask DCT bank data unless PAY_ADMIN/SYS_ADMIN.
  h('banks','GET',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;l_admin BOOLEAN;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
  l_admin:=dct_auth.has_role(l_user,'PAY_ADMIN') OR dct_auth.has_role(l_user,'SYS_ADMIN');
  dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;APEX_JSON.open_array('items');
  FOR r IN(SELECT * FROM dct_pay_dct_bank ORDER BY bank_code) LOOP APEX_JSON.open_object;
    APEX_JSON.write('bankId',r.bank_id);APEX_JSON.write('code',r.bank_code);APEX_JSON.write('nameEn',r.bank_name_en);
    APEX_JSON.write('nameAr',NVL(r.bank_name_ar,''));APEX_JSON.write('accountName',NVL(r.account_name,''));
    APEX_JSON.write('accountNumber',CASE WHEN l_admin THEN NVL(r.account_number,'') ELSE NVL(dct_pay_gov_pkg.mask_bank(r.account_number),'') END);
    APEX_JSON.write('iban',CASE WHEN l_admin THEN NVL(r.iban,'') ELSE NVL(dct_pay_gov_pkg.mask_bank(r.iban),'') END);
    APEX_JSON.write('currency',r.currency_code);APEX_JSON.write('branch',NVL(r.branch_name,''));
    APEX_JSON.write('notes',CASE WHEN l_admin THEN NVL(r.notes,'') ELSE '' END);APEX_JSON.write('isActive',r.is_active);APEX_JSON.close_object;
  END LOOP;APEX_JSON.close_array;APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');

  tpl('companies/[COLON]id/governance');
  h('companies/[COLON]id/governance','GET',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;l_found BOOLEAN:=FALSE;
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 FOR c IN(SELECT * FROM dct_pay_company WHERE company_id=TO_NUMBER([COLON]id)) LOOP l_found:=TRUE;
  dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
  APEX_JSON.write('companyId',c.company_id);APEX_JSON.write('rowVersion',c.row_version);APEX_JSON.write('country',NVL(c.country_code,''));
  APEX_JSON.write('contractOwnerId',c.contract_owner_user_id);APEX_JSON.write('businessOwnerId',c.business_owner_user_id);
  APEX_JSON.write('payrollOwnerId',c.payroll_owner_user_id);APEX_JSON.write('financeOwnerId',c.finance_owner_user_id);
  APEX_JSON.write('backupOwnerId',c.backup_owner_user_id);APEX_JSON.write('riskRating',NVL(c.risk_rating,''));
  APEX_JSON.open_array('contacts');FOR x IN(SELECT * FROM dct_pay_company_contact WHERE company_id=c.company_id ORDER BY is_primary DESC,contact_type,contact_name) LOOP APEX_JSON.open_object;
   APEX_JSON.write('contactId',x.contact_id);APEX_JSON.write('type',x.contact_type);APEX_JSON.write('name',x.contact_name);APEX_JSON.write('title',NVL(x.job_title,''));APEX_JSON.write('email',NVL(x.email,''));APEX_JSON.write('phone',NVL(x.phone,''));APEX_JSON.write('effectiveFrom',TO_CHAR(x.effective_from,'YYYY-MM-DD'));APEX_JSON.write('effectiveTo',NVL(TO_CHAR(x.effective_to,'YYYY-MM-DD'),''));APEX_JSON.write('isPrimary',x.is_primary);APEX_JSON.write('isActive',x.is_active);APEX_JSON.write('rowVersion',x.row_version);APEX_JSON.close_object;
  END LOOP;APEX_JSON.close_array;
  APEX_JSON.open_array('compliance');FOR x IN(SELECT * FROM dct_pay_compliance_item WHERE company_id=c.company_id ORDER BY expiry_date NULLS LAST) LOOP APEX_JSON.open_object;
   APEX_JSON.write('complianceId',x.compliance_id);APEX_JSON.write('type',x.compliance_type);APEX_JSON.write('referenceNo',NVL(x.reference_no,''));APEX_JSON.write('issueDate',NVL(TO_CHAR(x.issue_date,'YYYY-MM-DD'),''));APEX_JSON.write('expiryDate',NVL(TO_CHAR(x.expiry_date,'YYYY-MM-DD'),''));APEX_JSON.write('alertDays',x.alert_days);APEX_JSON.write('status',x.status);APEX_JSON.write('blocking',x.blocking_flag);APEX_JSON.write('docId',x.doc_id);APEX_JSON.write('notes',NVL(x.notes,''));APEX_JSON.write('isActive',x.is_active);APEX_JSON.write('rowVersion',x.row_version);APEX_JSON.close_object;
  END LOOP;APEX_JSON.close_array;
  APEX_JSON.open_array('scores');FOR x IN(SELECT * FROM dct_pay_company_score WHERE company_id=c.company_id ORDER BY period_to DESC FETCH FIRST 12 ROWS ONLY) LOOP APEX_JSON.open_object;
   APEX_JSON.write('scoreId',x.score_id);APEX_JSON.write('periodFrom',TO_CHAR(x.period_from,'YYYY-MM-DD'));APEX_JSON.write('periodTo',TO_CHAR(x.period_to,'YYYY-MM-DD'));APEX_JSON.write('timeliness',x.payroll_timeliness);APEX_JSON.write('accuracy',x.invoice_accuracy);APEX_JSON.write('compliance',x.compliance_score);APEX_JSON.write('complaints',x.complaint_score);APEX_JSON.write('sla',x.sla_score);APEX_JSON.write('overall',x.overall_score);APEX_JSON.write('riskRating',x.risk_rating);APEX_JSON.write('notes',NVL(x.notes,''));APEX_JSON.close_object;
  END LOOP;APEX_JSON.close_array;APEX_JSON.close_object;
 END LOOP;IF NOT l_found THEN dct_rest.err(404,'Company not found');END IF;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');
  h('companies/[COLON]id/governance','PUT',q'!
DECLARE l_user VARCHAR2(100);l_ver NUMBER;
BEGIN dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_gov_pkg.save_company_governance(l_user,TO_NUMBER([COLON]id),APEX_JSON.get_number('contractOwnerId'),APEX_JSON.get_number('businessOwnerId'),APEX_JSON.get_number('payrollOwnerId'),APEX_JSON.get_number('financeOwnerId'),APEX_JSON.get_number('backupOwnerId'),APEX_JSON.get_varchar2('country'),APEX_JSON.get_number('rowVersion'),l_ver);
 COMMIT;dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;APEX_JSON.write('rowVersion',l_ver);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  tpl('companies/[COLON]id/contacts');
  h('companies/[COLON]id/contacts','POST',q'!
DECLARE l_user VARCHAR2(100);l_id NUMBER;l_ver NUMBER;
BEGIN dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_gov_pkg.save_contact(l_user,NULL,TO_NUMBER([COLON]id),APEX_JSON.get_varchar2('type'),APEX_JSON.get_varchar2('name'),APEX_JSON.get_varchar2('title'),APEX_JSON.get_varchar2('email'),APEX_JSON.get_varchar2('phone'),TO_DATE(APEX_JSON.get_varchar2('effectiveFrom'),'YYYY-MM-DD'),TO_DATE(APEX_JSON.get_varchar2('effectiveTo'),'YYYY-MM-DD'),NVL(APEX_JSON.get_varchar2('isPrimary'),'N'),NVL(APEX_JSON.get_varchar2('isActive'),'Y'),NULL,l_id,l_ver);
 COMMIT;dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;APEX_JSON.write('contactId',l_id);APEX_JSON.write('rowVersion',l_ver);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');
  tpl('contacts/[COLON]id');
  h('contacts/[COLON]id','PUT',q'!
DECLARE l_user VARCHAR2(100);l_id NUMBER;l_ver NUMBER;
BEGIN dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_gov_pkg.save_contact(l_user,TO_NUMBER([COLON]id),APEX_JSON.get_number('companyId'),APEX_JSON.get_varchar2('type'),APEX_JSON.get_varchar2('name'),APEX_JSON.get_varchar2('title'),APEX_JSON.get_varchar2('email'),APEX_JSON.get_varchar2('phone'),TO_DATE(APEX_JSON.get_varchar2('effectiveFrom'),'YYYY-MM-DD'),TO_DATE(APEX_JSON.get_varchar2('effectiveTo'),'YYYY-MM-DD'),NVL(APEX_JSON.get_varchar2('isPrimary'),'N'),NVL(APEX_JSON.get_varchar2('isActive'),'Y'),APEX_JSON.get_number('rowVersion'),l_id,l_ver);
 COMMIT;dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;APEX_JSON.write('contactId',l_id);APEX_JSON.write('rowVersion',l_ver);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  tpl('companies/[COLON]id/compliance');
  h('companies/[COLON]id/compliance','POST',q'!
DECLARE l_user VARCHAR2(100);l_id NUMBER;l_ver NUMBER;
BEGIN dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_gov_pkg.save_compliance(l_user,NULL,TO_NUMBER([COLON]id),APEX_JSON.get_varchar2('type'),APEX_JSON.get_varchar2('referenceNo'),TO_DATE(APEX_JSON.get_varchar2('issueDate'),'YYYY-MM-DD'),TO_DATE(APEX_JSON.get_varchar2('expiryDate'),'YYYY-MM-DD'),APEX_JSON.get_number('alertDays'),NVL(APEX_JSON.get_varchar2('blocking'),'N'),APEX_JSON.get_number('docId'),APEX_JSON.get_varchar2('notes'),NVL(APEX_JSON.get_varchar2('isActive'),'Y'),NULL,l_id,l_ver);
 COMMIT;dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;APEX_JSON.write('complianceId',l_id);APEX_JSON.write('rowVersion',l_ver);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');
  tpl('compliance/[COLON]id');
  h('compliance/[COLON]id','PUT',q'!
DECLARE l_user VARCHAR2(100);l_id NUMBER;l_ver NUMBER;
BEGIN dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_gov_pkg.save_compliance(l_user,TO_NUMBER([COLON]id),APEX_JSON.get_number('companyId'),APEX_JSON.get_varchar2('type'),APEX_JSON.get_varchar2('referenceNo'),TO_DATE(APEX_JSON.get_varchar2('issueDate'),'YYYY-MM-DD'),TO_DATE(APEX_JSON.get_varchar2('expiryDate'),'YYYY-MM-DD'),APEX_JSON.get_number('alertDays'),NVL(APEX_JSON.get_varchar2('blocking'),'N'),APEX_JSON.get_number('docId'),APEX_JSON.get_varchar2('notes'),NVL(APEX_JSON.get_varchar2('isActive'),'Y'),APEX_JSON.get_number('rowVersion'),l_id,l_ver);
 COMMIT;dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;APEX_JSON.write('complianceId',l_id);APEX_JSON.write('rowVersion',l_ver);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  tpl('companies/[COLON]id/scores');
  h('companies/[COLON]id/scores','POST',q'!
DECLARE l_user VARCHAR2(100);l_id NUMBER;
BEGIN dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_gov_pkg.save_score(l_user,TO_NUMBER([COLON]id),TO_DATE(APEX_JSON.get_varchar2('periodFrom'),'YYYY-MM-DD'),TO_DATE(APEX_JSON.get_varchar2('periodTo'),'YYYY-MM-DD'),APEX_JSON.get_number('timeliness'),APEX_JSON.get_number('accuracy'),APEX_JSON.get_number('compliance'),APEX_JSON.get_number('complaints'),APEX_JSON.get_number('sla'),APEX_JSON.get_varchar2('notes'),l_id);
 COMMIT;dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;APEX_JSON.write('scoreId',l_id);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  tpl('contracts/[COLON]id/governance');
  h('contracts/[COLON]id/governance','GET',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;l_found BOOLEAN:=FALSE;
BEGIN IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 FOR c IN(SELECT * FROM dct_pay_contract WHERE contract_id=TO_NUMBER([COLON]id)) LOOP l_found:=TRUE;dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
  APEX_JSON.write('contractId',c.contract_id);APEX_JSON.write('rowVersion',c.row_version);APEX_JSON.write('contractValue',c.contract_value);APEX_JSON.write('annualValue',c.annual_value);APEX_JSON.write('approvedHeadcount',c.approved_headcount);APEX_JSON.write('minHeadcount',c.min_headcount);APEX_JSON.write('maxHeadcount',c.max_headcount);APEX_JSON.write('poNumber',NVL(c.po_number,''));APEX_JSON.write('ownerId',c.contract_owner_user_id);APEX_JSON.write('renewalStatus',NVL(c.renewal_status,'NOT_STARTED'));APEX_JSON.write('renewalDueDate',NVL(TO_CHAR(c.renewal_due_date,'YYYY-MM-DD'),''));
  APEX_JSON.open_array('feeRules');FOR x IN(SELECT * FROM dct_pay_fee_rule WHERE contract_id=c.contract_id ORDER BY effective_from) LOOP APEX_JSON.open_object;APEX_JSON.write('feeRuleId',x.fee_rule_id);APEX_JSON.write('type',x.fee_type);APEX_JSON.write('method',x.method);APEX_JSON.write('rateValue',x.rate_value);APEX_JSON.write('scope',x.payment_scope);APEX_JSON.write('effectiveFrom',TO_CHAR(x.effective_from,'YYYY-MM-DD'));APEX_JSON.write('effectiveTo',NVL(TO_CHAR(x.effective_to,'YYYY-MM-DD'),''));APEX_JSON.write('minAmount',x.min_amount);APEX_JSON.write('maxAmount',x.max_amount);APEX_JSON.write('vatApplicable',x.vat_applicable);APEX_JSON.write('notes',NVL(x.notes,''));APEX_JSON.write('isActive',x.is_active);APEX_JSON.write('rowVersion',x.row_version);APEX_JSON.close_object;END LOOP;APEX_JSON.close_array;
  APEX_JSON.open_array('changes');FOR x IN(SELECT * FROM dct_pay_contract_change WHERE old_contract_id=c.contract_id OR new_contract_id=c.contract_id ORDER BY created_at DESC) LOOP APEX_JSON.open_object;APEX_JSON.write('changeId',x.change_id);APEX_JSON.write('oldContractId',x.old_contract_id);APEX_JSON.write('newContractId',x.new_contract_id);APEX_JSON.write('type',NVL(x.amendment_type,''));APEX_JSON.write('reason',x.reason);APEX_JSON.write('effectiveDate',TO_CHAR(x.effective_date,'YYYY-MM-DD'));APEX_JSON.write('documentId',x.document_id);APEX_JSON.write('createdBy',x.created_by);APEX_JSON.write('createdAt',TO_CHAR(x.created_at,'YYYY-MM-DD HH[COLON]MI AM'));APEX_JSON.close_object;END LOOP;APEX_JSON.close_array;
  APEX_JSON.open_array('renewalActions');FOR x IN(SELECT * FROM dct_pay_renewal_action WHERE contract_id=c.contract_id ORDER BY created_at DESC) LOOP APEX_JSON.open_object;APEX_JSON.write('renewalActionId',x.renewal_action_id);APEX_JSON.write('action',x.action_code);APEX_JSON.write('status',x.action_status);APEX_JSON.write('ownerId',x.owner_user_id);APEX_JSON.write('targetDate',NVL(TO_CHAR(x.target_date,'YYYY-MM-DD'),''));APEX_JSON.write('notes',NVL(x.notes,''));APEX_JSON.close_object;END LOOP;APEX_JSON.close_array;APEX_JSON.close_object;
 END LOOP;IF NOT l_found THEN dct_rest.err(404,'Contract not found');END IF;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');
  h('contracts/[COLON]id/governance','PUT',q'!
DECLARE l_user VARCHAR2(100);l_ver NUMBER;
BEGIN dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_gov_pkg.save_contract_controls(l_user,TO_NUMBER([COLON]id),APEX_JSON.get_number('contractValue'),APEX_JSON.get_number('annualValue'),APEX_JSON.get_number('approvedHeadcount'),APEX_JSON.get_number('minHeadcount'),APEX_JSON.get_number('maxHeadcount'),APEX_JSON.get_varchar2('poNumber'),APEX_JSON.get_number('ownerId'),APEX_JSON.get_varchar2('renewalStatus'),TO_DATE(APEX_JSON.get_varchar2('renewalDueDate'),'YYYY-MM-DD'),APEX_JSON.get_number('rowVersion'),l_ver);
 COMMIT;dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;APEX_JSON.write('rowVersion',l_ver);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  tpl('contracts/[COLON]id/fee-rules');
  h('contracts/[COLON]id/fee-rules','POST',q'!
DECLARE l_user VARCHAR2(100);l_id NUMBER;l_ver NUMBER;
BEGIN dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_gov_pkg.save_fee(l_user,NULL,TO_NUMBER([COLON]id),APEX_JSON.get_varchar2('type'),APEX_JSON.get_varchar2('method'),APEX_JSON.get_number('rateValue'),APEX_JSON.get_varchar2('scope'),TO_DATE(APEX_JSON.get_varchar2('effectiveFrom'),'YYYY-MM-DD'),TO_DATE(APEX_JSON.get_varchar2('effectiveTo'),'YYYY-MM-DD'),APEX_JSON.get_number('minAmount'),APEX_JSON.get_number('maxAmount'),NVL(APEX_JSON.get_varchar2('vatApplicable'),'Y'),APEX_JSON.get_varchar2('notes'),NVL(APEX_JSON.get_varchar2('isActive'),'Y'),NULL,l_id,l_ver);
 COMMIT;dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;APEX_JSON.write('feeRuleId',l_id);APEX_JSON.write('rowVersion',l_ver);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');
  tpl('fee-rules/[COLON]id');
  h('fee-rules/[COLON]id','PUT',q'!
DECLARE l_user VARCHAR2(100);l_id NUMBER;l_ver NUMBER;
BEGIN dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_gov_pkg.save_fee(l_user,TO_NUMBER([COLON]id),APEX_JSON.get_number('contractId'),APEX_JSON.get_varchar2('type'),APEX_JSON.get_varchar2('method'),APEX_JSON.get_number('rateValue'),APEX_JSON.get_varchar2('scope'),TO_DATE(APEX_JSON.get_varchar2('effectiveFrom'),'YYYY-MM-DD'),TO_DATE(APEX_JSON.get_varchar2('effectiveTo'),'YYYY-MM-DD'),APEX_JSON.get_number('minAmount'),APEX_JSON.get_number('maxAmount'),NVL(APEX_JSON.get_varchar2('vatApplicable'),'Y'),APEX_JSON.get_varchar2('notes'),NVL(APEX_JSON.get_varchar2('isActive'),'Y'),APEX_JSON.get_number('rowVersion'),l_id,l_ver);
 COMMIT;dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;APEX_JSON.write('feeRuleId',l_id);APEX_JSON.write('rowVersion',l_ver);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  tpl('contracts/[COLON]id/amend-governed');
  h('contracts/[COLON]id/amend-governed','POST',q'!
DECLARE l_user VARCHAR2(100);l_id NUMBER;
BEGIN dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_gov_pkg.amend_contract(l_user,TO_NUMBER([COLON]id),APEX_JSON.get_varchar2('newContractNo'),APEX_JSON.get_varchar2('type'),APEX_JSON.get_varchar2('reason'),TO_DATE(APEX_JSON.get_varchar2('effectiveDate'),'YYYY-MM-DD'),APEX_JSON.get_number('documentId'),l_id);
 COMMIT;dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;APEX_JSON.write('contractId',l_id);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  tpl('contracts/[COLON]id/renewal-actions');
  h('contracts/[COLON]id/renewal-actions','POST',q'!
DECLARE l_user VARCHAR2(100);l_id NUMBER;
BEGIN dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_gov_pkg.save_renewal_action(l_user,NULL,TO_NUMBER([COLON]id),APEX_JSON.get_varchar2('action'),APEX_JSON.get_varchar2('status'),APEX_JSON.get_number('ownerId'),TO_DATE(APEX_JSON.get_varchar2('targetDate'),'YYYY-MM-DD'),APEX_JSON.get_varchar2('notes'),l_id);
 COMMIT;dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;APEX_JSON.write('renewalActionId',l_id);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  tpl('suppliers/[COLON]id/refresh');
  h('suppliers/[COLON]id/refresh','POST',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;
BEGIN IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;dct_pay_pkg.assert_admin(l_user);dct_pay_gov_pkg.refresh_supplier_status(TO_NUMBER([COLON]id));COMMIT;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;APEX_JSON.write('ok',TRUE);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  tpl('lov/supplier-sites');
  h('lov/supplier-sites','GET',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;l_reg NUMBER:=TO_NUMBER([COLON]registryid DEFAULT NULL ON CONVERSION ERROR);
BEGIN IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;dct_pay_pkg.assert_admin(l_user);IF l_reg IS NULL THEN dct_rest.err(400,'registryid is required');RETURN;END IF;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;APEX_JSON.open_array('items');
 FOR r IN(SELECT DISTINCT site,business_unit,site_pay_group,primary_pay_flag,pay_flag,inactive_date FROM atd_supplier_sites WHERE registry_id=l_reg ORDER BY primary_pay_flag DESC,site) LOOP APEX_JSON.open_object;APEX_JSON.write('site',r.site);APEX_JSON.write('businessUnit',NVL(r.business_unit,''));APEX_JSON.write('payGroup',NVL(r.site_pay_group,''));APEX_JSON.write('primaryPay',NVL(r.primary_pay_flag,'N'));APEX_JSON.write('payEnabled',NVL(r.pay_flag,'N'));APEX_JSON.write('inactiveDate',NVL(TO_CHAR(r.inactive_date,'YYYY-MM-DD'),''));APEX_JSON.close_object;END LOOP;
 APEX_JSON.close_array;APEX_JSON.close_object;EXCEPTION WHEN OTHERS THEN IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  tpl('lov/supplier-banks');
  h('lov/supplier-banks','GET',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;l_reg NUMBER:=TO_NUMBER([COLON]registryid DEFAULT NULL ON CONVERSION ERROR);
BEGIN IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;dct_pay_pkg.assert_admin(l_user);IF l_reg IS NULL THEN dct_rest.err(400,'registryid is required');RETURN;END IF;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;APEX_JSON.open_array('items');
 FOR r IN(SELECT account_name,bank_name,bank_branch_name,iban,bank_account_number,primary_flag,assignment_inactive_on FROM atd_supplier_bank_accounts WHERE registry_id=l_reg ORDER BY primary_flag DESC,bank_name) LOOP APEX_JSON.open_object;APEX_JSON.write('accountName',NVL(r.account_name,''));APEX_JSON.write('bankName',NVL(r.bank_name,''));APEX_JSON.write('branch',NVL(r.bank_branch_name,''));APEX_JSON.write('iban',NVL(r.iban,''));APEX_JSON.write('bankAccountNo',NVL(r.bank_account_number,''));APEX_JSON.write('primary',NVL(r.primary_flag,'N'));APEX_JSON.write('inactiveDate',NVL(TO_CHAR(r.assignment_inactive_on,'YYYY-MM-DD'),''));APEX_JSON.close_object;END LOOP;
 APEX_JSON.close_array;APEX_JSON.close_object;EXCEPTION WHEN OTHERS THEN IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  tpl('lov/payment');
  h('lov/payment','GET',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;
BEGIN IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.open_array('paymentMethods');
 FOR r IN(SELECT DISTINCT payment_method v FROM prod.atd_ap_invoice_installments WHERE payment_method IS NOT NULL ORDER BY payment_method) LOOP APEX_JSON.write(r.v);END LOOP;
 APEX_JSON.close_array;
 APEX_JSON.open_array('payGroups');
 FOR r IN(SELECT DISTINCT pay_group v FROM prod.atd_ap_invoice_installments WHERE pay_group IS NOT NULL ORDER BY pay_group) LOOP APEX_JSON.write(r.v);END LOOP;
 APEX_JSON.close_array;
 APEX_JSON.open_array('paymentTerms');
 FOR r IN(SELECT DISTINCT payment_terms v FROM prod.atd_ap_invoices WHERE payment_terms IS NOT NULL ORDER BY payment_terms) LOOP APEX_JSON.write(r.v);END LOOP;
 APEX_JSON.close_array;APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');

  tpl('governance/data-quality');
  h('governance/data-quality','GET',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;
BEGIN IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;APEX_JSON.open_array('items');
 FOR r IN(SELECT * FROM dct_pay_data_quality_v WHERE missing_contact+missing_valid_supplier+expired_compliance+contracts_without_margin+missing_owner>0 ORDER BY company_code) LOOP APEX_JSON.open_object;APEX_JSON.write('companyId',r.company_id);APEX_JSON.write('companyCode',r.company_code);APEX_JSON.write('name',r.name_en);APEX_JSON.write('missingContact',r.missing_contact);APEX_JSON.write('missingSupplier',r.missing_valid_supplier);APEX_JSON.write('expiredCompliance',r.expired_compliance);APEX_JSON.write('contractsWithoutMargin',r.contracts_without_margin);APEX_JSON.write('missingOwner',r.missing_owner);APEX_JSON.close_object;END LOOP;
 APEX_JSON.close_array;APEX_JSON.close_object;EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');

  tpl('governance/renewals');
  h('governance/renewals','GET',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;
BEGIN IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;APEX_JSON.open_array('items');
 FOR r IN(SELECT ct.contract_id,ct.contract_no,co.company_code,co.name_en,ct.date_to,ct.renewal_status,ct.contract_owner_user_id,TRUNC(ct.date_to)-TRUNC(SYSDATE) days_left FROM dct_pay_contract ct JOIN dct_pay_company co ON co.company_id=ct.company_id WHERE ct.status='ACTIVE' AND ct.date_to IS NOT NULL AND ct.date_to<=TRUNC(SYSDATE)+180 ORDER BY ct.date_to) LOOP APEX_JSON.open_object;APEX_JSON.write('contractId',r.contract_id);APEX_JSON.write('contractNo',r.contract_no);APEX_JSON.write('companyCode',r.company_code);APEX_JSON.write('company',r.name_en);APEX_JSON.write('dateTo',TO_CHAR(r.date_to,'YYYY-MM-DD'));APEX_JSON.write('daysLeft',r.days_left);APEX_JSON.write('renewalStatus',NVL(r.renewal_status,'NOT_STARTED'));APEX_JSON.write('ownerId',r.contract_owner_user_id);APEX_JSON.close_object;END LOOP;
 APEX_JSON.close_array;APEX_JSON.close_object;EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');

  -- company executive dashboard (2026-08-09): KPIs + employees + contracts +
  -- Fusion AP invoices (via the company supplier references) + paid-by-cost-
  -- center allocation + payroll run history. Every derived value is computed
  -- in a cursor or SELECT INTO (never as an APEX_JSON.write argument).
  tpl('companies/[COLON]id/dashboard');
  h('companies/[COLON]id/dashboard','GET',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;
 l_id NUMBER:=TO_NUMBER([COLON]id);
 l_n NUMBER;l_emp NUMBER;l_ctr NUMBER;l_sup NUMBER;
 l_icnt NUMBER;l_itot NUMBER;l_ipaid NUMBER;l_iytd NUMBER;
 l_comp_open NUMBER;l_last_run NUMBER;
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 SELECT COUNT(*) INTO l_n FROM dct_pay_company WHERE company_id=l_id;
 IF l_n=0 THEN dct_rest.err(404,'Company not found');RETURN;END IF;
 SELECT COUNT(*) INTO l_emp FROM dct_pay_assignment
 WHERE company_id=l_id AND assignment_type='PRIMARY' AND status='ACTIVE';
 SELECT COUNT(*) INTO l_ctr FROM dct_pay_contract
 WHERE company_id=l_id AND status='ACTIVE' AND is_active='Y';
 SELECT COUNT(*) INTO l_sup FROM dct_pay_company_supplier
 WHERE company_id=l_id AND is_active='Y';
 SELECT COUNT(*) INTO l_comp_open FROM dct_pay_compliance_item
 WHERE company_id=l_id AND is_active='Y'
   AND (status NOT IN('VALID','COMPLIANT') OR NVL(expiry_date,DATE '9999-12-31')<TRUNC(SYSDATE)+NVL(alert_days,30));
 SELECT COUNT(*),NVL(SUM(t.aed),0),NVL(SUM(t.paid_aed),0),
        NVL(SUM(CASE WHEN t.invoice_date>=TRUNC(SYSDATE,'YYYY') THEN t.paid_aed END),0)
 INTO l_icnt,l_itot,l_ipaid,l_iytd
 FROM (SELECT h.invoice_date,NVL(h.invoice_amount_aed,0) aed,
              NVL(h.amount_paid,0)*CASE WHEN NVL(h.invoice_amount,0)=0 THEN 0
                   ELSE NVL(h.invoice_amount_aed,0)/h.invoice_amount END paid_aed
       FROM prod.ap_invoices_header_v h
       WHERE h.cancelled_date IS NULL
         AND TO_CHAR(h.supplier_number) IN
             (SELECT TO_CHAR(supplier_number) FROM dct_pay_company_supplier
              WHERE company_id=l_id AND is_active='Y')) t;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 FOR c IN(SELECT c.*,
            (SELECT u.display_name FROM dct_users u WHERE u.user_id=c.contract_owner_user_id) ow_contract,
            (SELECT u.display_name FROM dct_users u WHERE u.user_id=c.business_owner_user_id) ow_business,
            (SELECT u.display_name FROM dct_users u WHERE u.user_id=c.payroll_owner_user_id) ow_payroll,
            (SELECT u.display_name FROM dct_users u WHERE u.user_id=c.finance_owner_user_id) ow_finance
          FROM dct_pay_company c WHERE c.company_id=l_id) LOOP
  APEX_JSON.write('companyId',c.company_id);APEX_JSON.write('code',c.company_code);
  APEX_JSON.write('nameEn',c.name_en);APEX_JSON.write('nameAr',NVL(c.name_ar,''));
  APEX_JSON.write('category',NVL(c.category,''));APEX_JSON.write('status',c.status);
  APEX_JSON.write('trn',NVL(c.trn,''));APEX_JSON.write('riskRating',NVL(c.risk_rating,''));
  APEX_JSON.write('ownerContract',NVL(c.ow_contract,''));
  APEX_JSON.write('ownerBusiness',NVL(c.ow_business,''));
  APEX_JSON.write('ownerPayroll',NVL(c.ow_payroll,''));
  APEX_JSON.write('ownerFinance',NVL(c.ow_finance,''));
 END LOOP;
 APEX_JSON.open_object('kpis');
 APEX_JSON.write('headcount',l_emp);APEX_JSON.write('activeContracts',l_ctr);
 APEX_JSON.write('supplierRefs',l_sup);APEX_JSON.write('complianceAlerts',l_comp_open);
 APEX_JSON.write('invoiceCount',l_icnt);APEX_JSON.write('totalInvoiced',ROUND(l_itot,2));
 APEX_JSON.write('totalPaid',ROUND(l_ipaid,2));
 APEX_JSON.write('outstanding',ROUND(l_itot-l_ipaid,2));
 APEX_JSON.write('paidYtd',ROUND(l_iytd,2));
 APEX_JSON.close_object;
 APEX_JSON.open_object('latestRun');
 FOR r IN(SELECT r.run_id,r.status,pe.period_code,r.emp_count,r.total_gross,r.total_net,
                 r.total_employer_cost,r.total_charges,p.payroll_code
          FROM dct_pay_run r
          JOIN dct_pay_payroll p ON p.payroll_id=r.payroll_id
          JOIN dct_pay_period pe ON pe.period_id=r.period_id
          WHERE p.company_id=l_id AND r.status IN('CALCULATED','REVIEWED')
          ORDER BY pe.date_from DESC FETCH FIRST 1 ROWS ONLY) LOOP
  l_last_run:=r.run_id;
  APEX_JSON.write('period',r.period_code);APEX_JSON.write('payroll',r.payroll_code);
  APEX_JSON.write('status',r.status);APEX_JSON.write('empCount',r.emp_count);
  APEX_JSON.write('gross',r.total_gross);APEX_JSON.write('net',r.total_net);
  APEX_JSON.write('employerCost',r.total_employer_cost);APEX_JSON.write('charges',r.total_charges);
 END LOOP;
 APEX_JSON.close_object;
 APEX_JSON.open_array('contacts');
 FOR r IN(SELECT * FROM dct_pay_company_contact
          WHERE company_id=l_id AND is_active='Y' ORDER BY is_primary DESC,contact_name) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('name',r.contact_name);APEX_JSON.write('type',NVL(r.contact_type,''));
  APEX_JSON.write('jobTitle',NVL(r.job_title,''));APEX_JSON.write('email',NVL(r.email,''));
  APEX_JSON.write('phone',NVL(r.phone,''));APEX_JSON.write('isPrimary',r.is_primary);
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;
 APEX_JSON.open_object('score');
 FOR r IN(SELECT * FROM dct_pay_company_score WHERE company_id=l_id
          ORDER BY period_to DESC NULLS LAST,score_id DESC FETCH FIRST 1 ROWS ONLY) LOOP
  APEX_JSON.write('overall',r.overall_score);APEX_JSON.write('timeliness',r.payroll_timeliness);
  APEX_JSON.write('invoiceAccuracy',r.invoice_accuracy);APEX_JSON.write('compliance',r.compliance_score);
  APEX_JSON.write('sla',r.sla_score);APEX_JSON.write('risk',NVL(r.risk_rating,''));
  APEX_JSON.write('periodTo',NVL(TO_CHAR(r.period_to,'YYYY-MM-DD'),''));
 END LOOP;
 APEX_JSON.close_object;
 APEX_JSON.open_array('contracts');
 FOR r IN(SELECT ct.*,TRUNC(ct.date_to)-TRUNC(SYSDATE) days_left,
                 (SELECT COUNT(*) FROM dct_pay_margin_rule m
                  WHERE m.contract_id=ct.contract_id AND m.is_active='Y') rule_cnt
          FROM dct_pay_contract ct WHERE ct.company_id=l_id
          ORDER BY CASE ct.status WHEN 'ACTIVE' THEN 0 WHEN 'DRAFT' THEN 1 ELSE 2 END,
                   ct.version_no DESC) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('contractId',r.contract_id);APEX_JSON.write('contractNo',r.contract_no);
  APEX_JSON.write('title',NVL(r.title_en,''));APEX_JSON.write('status',r.status);
  APEX_JSON.write('versionNo',r.version_no);
  APEX_JSON.write('dateFrom',NVL(TO_CHAR(r.date_from,'YYYY-MM-DD'),''));
  APEX_JSON.write('dateTo',NVL(TO_CHAR(r.date_to,'YYYY-MM-DD'),''));
  APEX_JSON.write('daysLeft',r.days_left);
  APEX_JSON.write('contractValue',r.contract_value);APEX_JSON.write('annualValue',r.annual_value);
  APEX_JSON.write('approvedHeadcount',r.approved_headcount);
  APEX_JSON.write('marginRules',r.rule_cnt);APEX_JSON.write('vatRate',r.vat_rate);
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;
 APEX_JSON.write('employeesTotal',l_emp);
 APEX_JSON.open_array('employees');
 FOR r IN(SELECT em.employee_number,em.full_name_en,a.job_title,a.sector_name,
                 a.department_name,a.cost_center_code,a.grade_code,
                 NVL(a.gross_salary,NVL(a.basic_salary,0)+NVL(a.allowance_amount,0)) gross
          FROM dct_pay_assignment a
          JOIN dct_employees em ON em.person_id=a.person_id
          WHERE a.company_id=l_id AND a.assignment_type='PRIMARY' AND a.status='ACTIVE'
          ORDER BY em.employee_number FETCH FIRST 200 ROWS ONLY) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('employeeNumber',NVL(r.employee_number,''));
  APEX_JSON.write('name',NVL(r.full_name_en,''));
  APEX_JSON.write('jobTitle',NVL(r.job_title,''));APEX_JSON.write('sector',NVL(r.sector_name,''));
  APEX_JSON.write('costCenter',NVL(r.cost_center_code,''));
  APEX_JSON.write('gradeCode',NVL(r.grade_code,''));APEX_JSON.write('gross',r.gross);
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;
 APEX_JSON.open_array('bySector');
 FOR r IN(SELECT NVL(a.sector_name,'(none)') sec,COUNT(*) cnt,
                 ROUND(SUM(NVL(a.gross_salary,NVL(a.basic_salary,0)+NVL(a.allowance_amount,0))),2) gross
          FROM dct_pay_assignment a
          WHERE a.company_id=l_id AND a.assignment_type='PRIMARY' AND a.status='ACTIVE'
          GROUP BY a.sector_name ORDER BY 2 DESC) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('sector',r.sec);APEX_JSON.write('headcount',r.cnt);APEX_JSON.write('gross',r.gross);
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;
 APEX_JSON.open_array('invoices');
 FOR r IN(SELECT h.invoice_id,h.invoice_number,h.invoice_type,h.invoice_date,h.invoice_status,
                 h.validation_status,h.payment_status,NVL(h.invoice_amount_aed,0) aed,
                 NVL(h.amount_paid,0)*CASE WHEN NVL(h.invoice_amount,0)=0 THEN 0
                      ELSE NVL(h.invoice_amount_aed,0)/h.invoice_amount END paid_aed
          FROM prod.ap_invoices_header_v h
          WHERE h.cancelled_date IS NULL
            AND TO_CHAR(h.supplier_number) IN
                (SELECT TO_CHAR(supplier_number) FROM dct_pay_company_supplier
                 WHERE company_id=l_id AND is_active='Y')
          ORDER BY h.invoice_date DESC,h.invoice_id DESC FETCH FIRST 15 ROWS ONLY) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('invoiceId',r.invoice_id);APEX_JSON.write('invoiceNumber',NVL(r.invoice_number,''));
  APEX_JSON.write('type',NVL(r.invoice_type,''));
  APEX_JSON.write('invoiceDate',NVL(TO_CHAR(r.invoice_date,'YYYY-MM-DD'),''));
  APEX_JSON.write('status',NVL(r.invoice_status,''));
  APEX_JSON.write('validation',NVL(r.validation_status,''));
  APEX_JSON.write('paymentStatus',NVL(r.payment_status,''));
  APEX_JSON.write('amount',ROUND(r.aed,2));APEX_JSON.write('paid',ROUND(r.paid_aed,2));
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;
 APEX_JSON.open_array('paidByCc');
 FOR r IN(SELECT cc,ROUND(SUM(alloc),2) paid,
                 (SELECT MIN(a.sector_name) FROM dct_pay_assignment a
                  WHERE a.cost_center_code=t.cc) lbl
          FROM (SELECT NVL(REGEXP_SUBSTR(prod.dct_cc_canon(d.charge_account),'[^.]+',1,3),'(none)') cc,
                       NVL(d.distribution_amount_aed,0)*
                       CASE WHEN NVL(h.invoice_amount,0)=0 THEN 0
                            ELSE NVL(h.amount_paid,0)/h.invoice_amount END alloc
                FROM prod.ap_invoice_distributions_v d
                JOIN prod.ap_invoices_header_v h ON h.invoice_id=d.invoice_id
                WHERE h.cancelled_date IS NULL
                  AND d.distribution_type NOT IN('Recoverable tax','Nonrecoverable tax')
                  AND TO_CHAR(h.supplier_number) IN
                      (SELECT TO_CHAR(supplier_number) FROM dct_pay_company_supplier
                       WHERE company_id=l_id AND is_active='Y')) t
          GROUP BY cc HAVING ABS(SUM(alloc))>0.005
          ORDER BY 2 DESC FETCH FIRST 15 ROWS ONLY) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('costCenter',r.cc);APEX_JSON.write('label',NVL(r.lbl,''));
  APEX_JSON.write('paid',r.paid);
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;
 APEX_JSON.open_array('apTrend');
 FOR r IN(SELECT TO_CHAR(TRUNC(h.invoice_date,'MM'),'YYYY-MM') mth,
                 ROUND(SUM(NVL(h.invoice_amount_aed,0)),2) invoiced,
                 ROUND(SUM(NVL(h.amount_paid,0)*CASE WHEN NVL(h.invoice_amount,0)=0 THEN 0
                       ELSE NVL(h.invoice_amount_aed,0)/h.invoice_amount END),2) paid
          FROM prod.ap_invoices_header_v h
          WHERE h.cancelled_date IS NULL
            AND h.invoice_date>=ADD_MONTHS(TRUNC(SYSDATE,'MM'),-11)
            AND TO_CHAR(h.supplier_number) IN
                (SELECT TO_CHAR(supplier_number) FROM dct_pay_company_supplier
                 WHERE company_id=l_id AND is_active='Y')
          GROUP BY TRUNC(h.invoice_date,'MM') ORDER BY 1) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('month',r.mth);APEX_JSON.write('invoiced',r.invoiced);APEX_JSON.write('paid',r.paid);
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;
 APEX_JSON.open_array('runs');
 FOR r IN(SELECT pe.period_code,p.payroll_code,r.status,r.emp_count,r.exception_count,
                 r.total_gross,r.total_charges
          FROM dct_pay_run r
          JOIN dct_pay_payroll p ON p.payroll_id=r.payroll_id
          JOIN dct_pay_period pe ON pe.period_id=r.period_id
          WHERE p.company_id=l_id
          ORDER BY pe.date_from DESC FETCH FIRST 12 ROWS ONLY) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('period',r.period_code);APEX_JSON.write('payroll',r.payroll_code);
  APEX_JSON.write('status',r.status);APEX_JSON.write('empCount',r.emp_count);
  APEX_JSON.write('exceptions',r.exception_count);
  APEX_JSON.write('gross',r.total_gross);APEX_JSON.write('charges',r.total_charges);
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;
 APEX_JSON.open_array('costByCc');
 IF l_last_run IS NOT NULL THEN
  FOR r IN(SELECT NVL(re.cost_center_code,'(none)') cc,MIN(re.sector_name) lbl,
                  COUNT(*) cnt,ROUND(SUM(NVL(re.gross,0)),2) gross
           FROM dct_pay_run_emp re WHERE re.run_id=l_last_run
           GROUP BY re.cost_center_code
           ORDER BY 4 DESC FETCH FIRST 15 ROWS ONLY) LOOP
   APEX_JSON.open_object;
   APEX_JSON.write('costCenter',r.cc);APEX_JSON.write('label',NVL(r.lbl,''));
   APEX_JSON.write('headcount',r.cnt);APEX_JSON.write('gross',r.gross);
   APEX_JSON.close_object;
  END LOOP;
 END IF;
 APEX_JSON.close_array;
 APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');
  COMMIT;
END setup_pay_p11_ords_tmp;
/
BEGIN setup_pay_p11_ords_tmp;END;
/
DROP PROCEDURE setup_pay_p11_ords_tmp;
PROMPT === PAY Phase 1.1 governance ORDS complete ===
