SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

DECLARE
  l_company NUMBER; l_contract NUMBER; l_id NUMBER; l_ver NUMBER; l_new NUMBER;
  l_reg NUMBER; l_status VARCHAR2(30); l_msg VARCHAR2(1000); l_fail NUMBER:=0;
  PROCEDURE pass(p_name VARCHAR2) IS BEGIN DBMS_OUTPUT.PUT_LINE('PASS '||p_name); END;
  PROCEDURE assert_true(p_ok BOOLEAN,p_name VARCHAR2) IS BEGIN IF p_ok THEN pass(p_name); ELSE l_fail:=l_fail+1;DBMS_OUTPUT.PUT_LINE('FAIL '||p_name); END IF; END;
BEGIN
  INSERT INTO prod.dct_pay_company(company_code,name_en,category,status,is_active,created_by)
  VALUES('P11TEST'||TO_CHAR(SYSTIMESTAMP,'FF6'),'Phase 1.1 rollback test','MANPOWER','ACTIVE','Y','ADMIN')
  RETURNING company_id INTO l_company;
  INSERT INTO prod.dct_pay_contract(company_id,contract_no,title_en,status,date_from,date_to,currency_code,expiry_blocking,renewal_alert_days,is_active,created_by)
  VALUES(l_company,'P11CT'||TO_CHAR(SYSTIMESTAMP,'FF6'),'Rollback test','DRAFT',DATE'2026-01-01',DATE'2026-12-31','AED','N',60,'Y','ADMIN')
  RETURNING contract_id INTO l_contract;

  prod.dct_pay_gov_pkg.save_company_governance('ADMIN',l_company,1,1,1,1,1,'AE',1,l_ver);
  assert_true(l_ver=2,'company optimistic update');
  BEGIN prod.dct_pay_gov_pkg.save_company_governance('ADMIN',l_company,1,1,1,1,1,'AE',1,l_ver); l_fail:=l_fail+1; DBMS_OUTPUT.PUT_LINE('FAIL stale company version');
  EXCEPTION WHEN OTHERS THEN assert_true(SQLCODE=-20001,'stale company version rejected'); END;

  prod.dct_pay_gov_pkg.save_contact('ADMIN',NULL,l_company,'CONTRACT_MANAGER','Test Manager',NULL,'test@example.com',NULL,DATE'2026-01-01',NULL,'Y','Y',NULL,l_id,l_ver);
  assert_true(l_id IS NOT NULL AND l_ver=1,'effective-dated contact');
  prod.dct_pay_gov_pkg.save_compliance('ADMIN',NULL,l_company,'TRADE_LICENSE','TL-TEST',DATE'2026-01-01',DATE'2027-01-01',60,'Y',NULL,NULL,'Y',NULL,l_id,l_ver);
  assert_true(l_id IS NOT NULL,'compliance item');
  prod.dct_pay_gov_pkg.save_contract_controls('ADMIN',l_contract,120000,120000,10,5,15,'PO-TEST',1,'UNDER_REVIEW',DATE'2026-10-01',1,l_ver);
  assert_true(l_ver=2,'contract commercial controls');
  prod.dct_pay_gov_pkg.save_fee('ADMIN',NULL,l_contract,'MANAGEMENT','PERCENT',5,'ALL',DATE'2026-01-01',DATE'2026-12-31',NULL,NULL,'Y',NULL,'Y',NULL,l_id,l_ver);
  assert_true(l_id IS NOT NULL,'fee rule');
  BEGIN prod.dct_pay_gov_pkg.save_fee('ADMIN',NULL,l_contract,'MANAGEMENT','PERCENT',6,'ALL',DATE'2026-06-01',DATE'2026-07-01',NULL,NULL,'Y',NULL,'Y',NULL,l_id,l_ver); l_fail:=l_fail+1; DBMS_OUTPUT.PUT_LINE('FAIL overlap rejected');
  EXCEPTION WHEN OTHERS THEN assert_true(SQLCODE=-20001,'overlapping fee rejected'); END;
  prod.dct_pay_gov_pkg.save_renewal_action('ADMIN',NULL,l_contract,'REVIEW','UNDER_REVIEW',1,DATE'2026-09-01','Test',l_id);
  assert_true(l_id IS NOT NULL,'renewal action');
  prod.dct_pay_gov_pkg.save_score('ADMIN',l_company,DATE'2026-01-01',DATE'2026-06-30',90,90,90,90,90,NULL,l_id);
  assert_true(l_id IS NOT NULL,'performance risk scoring');
  prod.dct_pay_gov_pkg.validate_supplier_ref('71991','ABU DHABI','AE220030011230204820001',NULL,l_reg,l_status,l_msg);
  assert_true(l_status='VALID','Fusion supplier/site/bank exact validation');
  prod.dct_pay_gov_pkg.amend_contract('ADMIN',l_contract,'P11AM'||TO_CHAR(SYSTIMESTAMP,'FF6'),'PRICING','Rollback test amendment',DATE'2026-07-01',NULL,l_new);
  assert_true(l_new IS NOT NULL,'governed amendment version');
  BEGIN UPDATE prod.dct_pay_contract SET notes='illegal' WHERE contract_id=l_contract; l_fail:=l_fail+1; DBMS_OUTPUT.PUT_LINE('FAIL superseded immutable');
  EXCEPTION WHEN OTHERS THEN assert_true(SQLCODE=-20001,'superseded immutable'); END;
  ROLLBACK;
  IF l_fail>0 THEN RAISE_APPLICATION_ERROR(-20099,l_fail||' PAY Phase 1.1 tests failed'); END IF;
  DBMS_OUTPUT.PUT_LINE('PAY_PHASE1_1_DB_TEST PASS');
END;
/
EXIT
