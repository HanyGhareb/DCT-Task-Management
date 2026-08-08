-- PAY Phase 3 additive Payroll API; re-run after any 04_pay_ords.sql re-run
-- Fresh SQLcl session required (synonym rule: never after CURRENT_SCHEMA=PROD)
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

CREATE OR REPLACE SYNONYM dct_pay_calc_pkg FOR prod.dct_pay_calc_pkg;
CREATE OR REPLACE SYNONYM dct_pay_payroll FOR prod.dct_pay_payroll;
CREATE OR REPLACE SYNONYM dct_pay_period FOR prod.dct_pay_period;
CREATE OR REPLACE SYNONYM dct_pay_element FOR prod.dct_pay_element;
CREATE OR REPLACE SYNONYM dct_pay_element_link FOR prod.dct_pay_element_link;
CREATE OR REPLACE SYNONYM dct_pay_element_entry FOR prod.dct_pay_element_entry;
CREATE OR REPLACE SYNONYM dct_pay_rate_table FOR prod.dct_pay_rate_table;
CREATE OR REPLACE SYNONYM dct_pay_rate_row FOR prod.dct_pay_rate_row;
CREATE OR REPLACE SYNONYM dct_pay_invoice_group FOR prod.dct_pay_invoice_group;
CREATE OR REPLACE SYNONYM dct_pay_invoice_group_sector FOR prod.dct_pay_invoice_group_sector;
CREATE OR REPLACE SYNONYM dct_pay_run FOR prod.dct_pay_run;
CREATE OR REPLACE SYNONYM dct_pay_run_emp FOR prod.dct_pay_run_emp;
CREATE OR REPLACE SYNONYM dct_pay_run_line FOR prod.dct_pay_run_line;
CREATE OR REPLACE SYNONYM dct_pay_run_charge FOR prod.dct_pay_run_charge;

CREATE OR REPLACE PROCEDURE setup_pay_p3_ords_tmp AS
  c_mod CONSTANT VARCHAR2(30):='pay.rest';
  PROCEDURE tpl(p VARCHAR2) IS BEGIN ORDS.DEFINE_TEMPLATE(p_module_name=>c_mod,p_pattern=>REPLACE(p,'[COLON]',CHR(58))); END;
  PROCEDURE h(p VARCHAR2,m VARCHAR2,s CLOB) IS BEGIN
    ORDS.DEFINE_HANDLER(p_module_name=>c_mod,p_pattern=>REPLACE(p,'[COLON]',CHR(58)),p_method=>m,
      p_source_type=>ORDS.source_type_plsql,p_source=>REPLACE(s,'[COLON]',CHR(58)));
  END;
BEGIN

  -- --------------------------------------------------- payroll setup snapshot
  tpl('paysetup/boot');
  h('paysetup/boot','GET',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('canSetup',CASE WHEN dct_pay_calc_pkg.can_setup(l_user) THEN 'Y' ELSE 'N' END);
 APEX_JSON.write('canRun',CASE WHEN dct_pay_calc_pkg.can_run(l_user) THEN 'Y' ELSE 'N' END);
 APEX_JSON.open_array('payrolls');
 FOR r IN(SELECT p.*,c.company_code,c.name_en company_name,
                 (SELECT COUNT(*) FROM dct_pay_period pe WHERE pe.payroll_id=p.payroll_id) period_count,
                 (SELECT COUNT(*) FROM dct_pay_run rr WHERE rr.payroll_id=p.payroll_id) run_count
          FROM dct_pay_payroll p JOIN dct_pay_company c ON c.company_id=p.company_id
          ORDER BY p.payroll_code) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('payrollId',r.payroll_id);APEX_JSON.write('code',r.payroll_code);
  APEX_JSON.write('nameEn',r.name_en);APEX_JSON.write('nameAr',NVL(r.name_ar,''));
  APEX_JSON.write('companyId',r.company_id);APEX_JSON.write('company',r.company_name);
  APEX_JSON.write('companyCode',r.company_code);
  APEX_JSON.write('frequency',r.frequency);APEX_JSON.write('currency',r.currency_code);
  APEX_JSON.write('prorationBasis',r.proration_basis);APEX_JSON.write('prorationDivisor',r.proration_divisor);
  APEX_JSON.write('pensionBase',NVL(r.pension_base,''));
  APEX_JSON.write('cutoffDay',r.cutoff_day);APEX_JSON.write('payDay',r.pay_day);
  APEX_JSON.write('isActive',r.is_active);APEX_JSON.write('periodCount',r.period_count);
  APEX_JSON.write('runCount',r.run_count);
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;
 APEX_JSON.open_array('elements');
 FOR r IN(SELECT e.*,rt.table_code,c.name_en company_name
          FROM dct_pay_element e
          LEFT JOIN dct_pay_rate_table rt ON rt.rate_table_id=e.rate_table_id
          LEFT JOIN dct_pay_company c ON c.company_id=e.company_id
          ORDER BY e.priority,e.element_code) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('elementId',r.element_id);APEX_JSON.write('code',r.element_code);
  APEX_JSON.write('nameEn',r.name_en);APEX_JSON.write('nameAr',NVL(r.name_ar,''));
  APEX_JSON.write('company',NVL(r.company_name,''));APEX_JSON.write('companyId',r.company_id);
  APEX_JSON.write('elementClass',r.element_class);APEX_JSON.write('calcRule',r.calc_rule);
  APEX_JSON.write('calcBase',NVL(r.calc_base,''));APEX_JSON.write('percent',r.percent_value);
  APEX_JSON.write('rateTableId',r.rate_table_id);APEX_JSON.write('rateTable',NVL(r.table_code,''));
  APEX_JSON.write('priority',r.priority);APEX_JSON.write('prorate',r.prorate);
  APEX_JSON.write('recurring',r.recurring);APEX_JSON.write('payslipVisible',r.payslip_visible);
  APEX_JSON.write('isActive',r.is_active);
  APEX_JSON.open_array('links');
  FOR k IN(SELECT * FROM dct_pay_element_link WHERE element_id=r.element_id ORDER BY link_id) LOOP
   APEX_JSON.open_object;
   APEX_JSON.write('linkId',k.link_id);APEX_JSON.write('linkType',k.link_type);
   APEX_JSON.write('linkValue',NVL(k.link_value,''));APEX_JSON.write('isActive',k.is_active);
   APEX_JSON.close_object;
  END LOOP;APEX_JSON.close_array;
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;
 APEX_JSON.open_array('rateTables');
 FOR r IN(SELECT * FROM dct_pay_rate_table ORDER BY table_code) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('rateTableId',r.rate_table_id);APEX_JSON.write('code',r.table_code);
  APEX_JSON.write('nameEn',r.name_en);APEX_JSON.write('nameAr',NVL(r.name_ar,''));
  APEX_JSON.write('keyType',r.key_type);
  APEX_JSON.open_array('rows');
  FOR w IN(SELECT * FROM dct_pay_rate_row WHERE rate_table_id=r.rate_table_id ORDER BY key_value) LOOP
   APEX_JSON.open_object;
   APEX_JSON.write('rowId',w.row_id);APEX_JSON.write('keyValue',w.key_value);
   APEX_JSON.write('eeRate',w.ee_rate);APEX_JSON.write('erRate',w.er_rate);
   APEX_JSON.write('amount',w.amount);APEX_JSON.write('isActive',w.is_active);
   APEX_JSON.close_object;
  END LOOP;APEX_JSON.close_array;
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;
 APEX_JSON.open_array('invoiceGroups');
 FOR r IN(SELECT g.*,c.company_code,c.name_en company_name
          FROM dct_pay_invoice_group g JOIN dct_pay_company c ON c.company_id=g.company_id
          ORDER BY c.company_code,g.display_order) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('groupId',r.group_id);APEX_JSON.write('companyId',r.company_id);
  APEX_JSON.write('company',r.company_name);APEX_JSON.write('companyCode',r.company_code);
  APEX_JSON.write('code',r.group_code);APEX_JSON.write('nameEn',r.name_en);
  APEX_JSON.write('nameAr',NVL(r.name_ar,''));APEX_JSON.write('displayOrder',r.display_order);
  APEX_JSON.write('isDefault',r.is_default);APEX_JSON.write('isActive',r.is_active);
  APEX_JSON.open_array('sectors');
  FOR s IN(SELECT sector_name FROM dct_pay_invoice_group_sector WHERE group_id=r.group_id ORDER BY sector_name) LOOP
   APEX_JSON.write(s.sector_name);
  END LOOP;APEX_JSON.close_array;
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;
 APEX_JSON.open_object('lookups');
 FOR c IN(SELECT category_code FROM dct_lookup_categories
          WHERE category_code IN('PAY_ELEMENT_CLASS','PAY_CALC_RULE','PAY_CALC_BASE',
                'PAY_PRORATION_BASIS','PAY_LINK_TYPE','PAY_ENTRY_TYPE','PAY_RUN_STATUS')) LOOP
  APEX_JSON.open_array(c.category_code);
  FOR v IN(SELECT v.value_code,v.value_name_en,v.value_name_ar
           FROM dct_lookup_values v JOIN dct_lookup_categories k ON k.category_id=v.category_id
           WHERE k.category_code=c.category_code AND v.is_active='Y' ORDER BY v.display_order) LOOP
   APEX_JSON.open_object;
   APEX_JSON.write('code',v.value_code);APEX_JSON.write('nameEn',v.value_name_en);
   APEX_JSON.write('nameAr',NVL(v.value_name_ar,''));
   APEX_JSON.close_object;
  END LOOP;APEX_JSON.close_array;
 END LOOP;
 APEX_JSON.close_object;
 APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');

  -- --------------------------------------------------------------- payrolls
  tpl('paysetup/payrolls');
  h('paysetup/payrolls','POST',q'!
DECLARE l_user VARCHAR2(100);l_id NUMBER;
BEGIN
 dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 l_id:=NULL;
 dct_pay_calc_pkg.save_payroll(l_id,APEX_JSON.get_varchar2('code'),
   APEX_JSON.get_varchar2('nameEn'),APEX_JSON.get_varchar2('nameAr'),
   APEX_JSON.get_number('companyId'),APEX_JSON.get_varchar2('prorationBasis'),
   APEX_JSON.get_number('prorationDivisor'),APEX_JSON.get_varchar2('pensionBase'),
   APEX_JSON.get_number('cutoffDay'),APEX_JSON.get_number('payDay'),
   APEX_JSON.get_varchar2('isActive'),APEX_JSON.get_varchar2('notes'),l_user);
 COMMIT;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('payrollId',l_id);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
 ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  tpl('paysetup/payrolls/:id');
  h('paysetup/payrolls/:id','PUT',q'!
DECLARE l_user VARCHAR2(100);l_id NUMBER:=TO_NUMBER([COLON]id);
BEGIN
 dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_calc_pkg.save_payroll(l_id,NULL,
   APEX_JSON.get_varchar2('nameEn'),APEX_JSON.get_varchar2('nameAr'),
   NULL,APEX_JSON.get_varchar2('prorationBasis'),
   APEX_JSON.get_number('prorationDivisor'),APEX_JSON.get_varchar2('pensionBase'),
   APEX_JSON.get_number('cutoffDay'),APEX_JSON.get_number('payDay'),
   APEX_JSON.get_varchar2('isActive'),APEX_JSON.get_varchar2('notes'),l_user);
 COMMIT;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('ok',TRUE);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
 ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  tpl('paysetup/payrolls/:id/periods');
  h('paysetup/payrolls/:id/periods','GET',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.open_array('items');
 FOR r IN(SELECT pe.*,r2.run_id,r2.status run_status
          FROM dct_pay_period pe
          LEFT JOIN dct_pay_run r2 ON r2.period_id=pe.period_id AND r2.run_type='REGULAR'
          WHERE pe.payroll_id=TO_NUMBER([COLON]id)
          ORDER BY pe.date_from DESC) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('periodId',r.period_id);APEX_JSON.write('period',r.period_code);
  APEX_JSON.write('dateFrom',TO_CHAR(r.date_from,'YYYY-MM-DD'));
  APEX_JSON.write('dateTo',TO_CHAR(r.date_to,'YYYY-MM-DD'));
  APEX_JSON.write('status',r.status);
  APEX_JSON.write('runId',r.run_id);APEX_JSON.write('runStatus',NVL(r.run_status,''));
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');

  h('paysetup/payrolls/:id/periods','POST',q'!
DECLARE l_user VARCHAR2(100);
BEGIN
 dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_calc_pkg.gen_periods(TO_NUMBER([COLON]id),APEX_JSON.get_number('year'),l_user);
 COMMIT;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('ok',TRUE);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
 ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  -- --------------------------------------------------------------- elements
  tpl('paysetup/elements');
  h('paysetup/elements','POST',q'!
DECLARE l_user VARCHAR2(100);l_id NUMBER;
BEGIN
 dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 l_id:=NULL;
 dct_pay_calc_pkg.save_element(l_id,APEX_JSON.get_varchar2('code'),
   APEX_JSON.get_varchar2('nameEn'),APEX_JSON.get_varchar2('nameAr'),
   APEX_JSON.get_number('companyId'),APEX_JSON.get_varchar2('elementClass'),
   APEX_JSON.get_varchar2('calcRule'),APEX_JSON.get_varchar2('calcBase'),
   APEX_JSON.get_number('percent'),APEX_JSON.get_number('rateTableId'),
   APEX_JSON.get_number('priority'),APEX_JSON.get_varchar2('prorate'),
   APEX_JSON.get_varchar2('recurring'),APEX_JSON.get_varchar2('payslipVisible'),
   APEX_JSON.get_varchar2('isActive'),APEX_JSON.get_varchar2('notes'),l_user);
 COMMIT;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('elementId',l_id);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
 ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  tpl('paysetup/elements/:id');
  h('paysetup/elements/:id','PUT',q'!
DECLARE l_user VARCHAR2(100);l_id NUMBER:=TO_NUMBER([COLON]id);
BEGIN
 dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_calc_pkg.save_element(l_id,NULL,
   APEX_JSON.get_varchar2('nameEn'),APEX_JSON.get_varchar2('nameAr'),
   NULL,APEX_JSON.get_varchar2('elementClass'),
   APEX_JSON.get_varchar2('calcRule'),APEX_JSON.get_varchar2('calcBase'),
   APEX_JSON.get_number('percent'),APEX_JSON.get_number('rateTableId'),
   APEX_JSON.get_number('priority'),APEX_JSON.get_varchar2('prorate'),
   APEX_JSON.get_varchar2('recurring'),APEX_JSON.get_varchar2('payslipVisible'),
   APEX_JSON.get_varchar2('isActive'),APEX_JSON.get_varchar2('notes'),l_user);
 COMMIT;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('ok',TRUE);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
 ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  tpl('paysetup/elements/:id/links');
  h('paysetup/elements/:id/links','POST',q'!
DECLARE l_user VARCHAR2(100);l_id NUMBER;
BEGIN
 dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 l_id:=NULL;
 dct_pay_calc_pkg.save_link(l_id,TO_NUMBER([COLON]id),
   APEX_JSON.get_varchar2('linkType'),APEX_JSON.get_varchar2('linkValue'),NULL,l_user);
 COMMIT;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('linkId',l_id);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
 ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  tpl('paysetup/links/:id');
  h('paysetup/links/:id','PUT',q'!
DECLARE l_user VARCHAR2(100);l_id NUMBER:=TO_NUMBER([COLON]id);
BEGIN
 dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_calc_pkg.save_link(l_id,NULL,
   APEX_JSON.get_varchar2('linkType'),APEX_JSON.get_varchar2('linkValue'),
   APEX_JSON.get_varchar2('isActive'),l_user);
 COMMIT;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('ok',TRUE);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
 ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  -- -------------------------------------------------------------- rate rows
  tpl('paysetup/rate-rows');
  h('paysetup/rate-rows','POST',q'!
DECLARE l_user VARCHAR2(100);l_id NUMBER;
BEGIN
 dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 l_id:=NULL;
 dct_pay_calc_pkg.save_rate_row(l_id,APEX_JSON.get_number('rateTableId'),
   APEX_JSON.get_varchar2('keyValue'),APEX_JSON.get_number('eeRate'),
   APEX_JSON.get_number('erRate'),APEX_JSON.get_number('amount'),NULL,l_user);
 COMMIT;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('rowId',l_id);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
 ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  tpl('paysetup/rate-rows/:id');
  h('paysetup/rate-rows/:id','PUT',q'!
DECLARE l_user VARCHAR2(100);l_id NUMBER:=TO_NUMBER([COLON]id);
BEGIN
 dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_calc_pkg.save_rate_row(l_id,NULL,NULL,
   APEX_JSON.get_number('eeRate'),APEX_JSON.get_number('erRate'),
   APEX_JSON.get_number('amount'),APEX_JSON.get_varchar2('isActive'),l_user);
 COMMIT;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('ok',TRUE);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
 ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  -- ---------------------------------------------------------- invoice groups
  tpl('paysetup/invoice-groups');
  h('paysetup/invoice-groups','POST',q'!
DECLARE l_user VARCHAR2(100);l_id NUMBER;
BEGIN
 dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 l_id:=NULL;
 dct_pay_calc_pkg.save_invoice_group(l_id,APEX_JSON.get_number('companyId'),
   APEX_JSON.get_varchar2('code'),APEX_JSON.get_varchar2('nameEn'),
   APEX_JSON.get_varchar2('nameAr'),APEX_JSON.get_number('displayOrder'),
   APEX_JSON.get_varchar2('isDefault'),NULL,APEX_JSON.get_varchar2('sectors'),l_user);
 COMMIT;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('groupId',l_id);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
 ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  tpl('paysetup/invoice-groups/:id');
  h('paysetup/invoice-groups/:id','PUT',q'!
DECLARE l_user VARCHAR2(100);l_id NUMBER:=TO_NUMBER([COLON]id);
BEGIN
 dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_calc_pkg.save_invoice_group(l_id,NULL,NULL,
   APEX_JSON.get_varchar2('nameEn'),APEX_JSON.get_varchar2('nameAr'),
   APEX_JSON.get_number('displayOrder'),APEX_JSON.get_varchar2('isDefault'),
   APEX_JSON.get_varchar2('isActive'),APEX_JSON.get_varchar2('sectors'),l_user);
 COMMIT;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('ok',TRUE);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
 ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  -- ---------------------------------------------------------------- entries
  tpl('entries');
  h('entries','GET',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 IF [COLON]personid IS NULL THEN dct_rest.err(400,'personid is required');RETURN;END IF;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.open_array('items');
 FOR r IN(SELECT en.*,el.element_code,el.name_en el_name,el.element_class
          FROM dct_pay_element_entry en
          JOIN dct_pay_element el ON el.element_id=en.element_id
          WHERE en.person_id=TO_NUMBER([COLON]personid)
          ORDER BY el.priority,en.effective_from DESC) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('entryId',r.entry_id);APEX_JSON.write('elementId',r.element_id);
  APEX_JSON.write('element',r.element_code);APEX_JSON.write('elementName',r.el_name);
  APEX_JSON.write('elementClass',r.element_class);
  APEX_JSON.write('entryType',r.entry_type);APEX_JSON.write('amount',r.amount);
  APEX_JSON.write('qty',r.qty);APEX_JSON.write('rate',r.rate);
  APEX_JSON.write('effectiveFrom',TO_CHAR(r.effective_from,'YYYY-MM-DD'));
  APEX_JSON.write('effectiveTo',NVL(TO_CHAR(r.effective_to,'YYYY-MM-DD'),''));
  APEX_JSON.write('isActive',r.is_active);APEX_JSON.write('notes',NVL(r.notes,''));
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');

  h('entries','POST',q'!
DECLARE l_user VARCHAR2(100);l_id NUMBER;
BEGIN
 dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 l_id:=NULL;
 dct_pay_calc_pkg.save_entry(l_id,APEX_JSON.get_number('elementId'),
   APEX_JSON.get_number('personId'),APEX_JSON.get_number('assignmentId'),
   APEX_JSON.get_varchar2('entryType'),APEX_JSON.get_number('amount'),
   APEX_JSON.get_number('qty'),APEX_JSON.get_number('rate'),
   TO_DATE(APEX_JSON.get_varchar2('effectiveFrom'),'YYYY-MM-DD'),
   TO_DATE(APEX_JSON.get_varchar2('effectiveTo'),'YYYY-MM-DD'),
   APEX_JSON.get_varchar2('notes'),NULL,l_user);
 COMMIT;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('entryId',l_id);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
 ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  tpl('entries/:id');
  h('entries/:id','PUT',q'!
DECLARE l_user VARCHAR2(100);l_id NUMBER:=TO_NUMBER([COLON]id);
BEGIN
 dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_calc_pkg.save_entry(l_id,NULL,NULL,NULL,NULL,
   APEX_JSON.get_number('amount'),APEX_JSON.get_number('qty'),APEX_JSON.get_number('rate'),
   TO_DATE(APEX_JSON.get_varchar2('effectiveFrom'),'YYYY-MM-DD'),
   TO_DATE(APEX_JSON.get_varchar2('effectiveTo'),'YYYY-MM-DD'),
   APEX_JSON.get_varchar2('notes'),APEX_JSON.get_varchar2('isActive'),l_user);
 COMMIT;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('ok',TRUE);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
 ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  -- ------------------------------------------------------------------- runs
  tpl('runs');
  h('runs','GET',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.open_array('items');
 FOR r IN(SELECT r.*,p.payroll_code,p.name_en payroll_name,pe.period_code,c.name_en company_name
          FROM dct_pay_run r
          JOIN dct_pay_payroll p ON p.payroll_id=r.payroll_id
          JOIN dct_pay_period pe ON pe.period_id=r.period_id
          JOIN dct_pay_company c ON c.company_id=p.company_id
          WHERE ([COLON]payrollid IS NULL OR r.payroll_id=TO_NUMBER([COLON]payrollid))
            AND ([COLON]status IS NULL OR r.status=[COLON]status)
          ORDER BY pe.date_from DESC,p.payroll_code) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('runId',r.run_id);APEX_JSON.write('payrollId',r.payroll_id);
  APEX_JSON.write('payroll',r.payroll_code);APEX_JSON.write('payrollName',r.payroll_name);
  APEX_JSON.write('company',r.company_name);APEX_JSON.write('period',r.period_code);
  APEX_JSON.write('runType',r.run_type);APEX_JSON.write('status',r.status);
  APEX_JSON.write('empCount',r.emp_count);APEX_JSON.write('exceptionCount',r.exception_count);
  APEX_JSON.write('gross',r.total_gross);APEX_JSON.write('net',r.total_net);
  APEX_JSON.write('charges',r.total_charges);
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');

  h('runs','POST',q'!
DECLARE l_user VARCHAR2(100);l_id NUMBER;
BEGIN
 dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_calc_pkg.create_run(APEX_JSON.get_number('payrollId'),
   APEX_JSON.get_varchar2('period'),APEX_JSON.get_varchar2('runType'),l_user,l_id);
 COMMIT;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('runId',l_id);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
 ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  tpl('runs/:id');
  h('runs/:id','GET',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;
 l_run dct_pay_run%ROWTYPE;
 l_prior_run NUMBER;
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 BEGIN
  SELECT * INTO l_run FROM dct_pay_run WHERE run_id=TO_NUMBER([COLON]id);
 EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Run not found');RETURN;END;
 BEGIN
  SELECT r2.run_id INTO l_prior_run
  FROM dct_pay_run r2
  JOIN dct_pay_period pe2 ON pe2.period_id=r2.period_id
  WHERE r2.payroll_id=l_run.payroll_id AND r2.run_type='REGULAR'
    AND pe2.date_from=(SELECT ADD_MONTHS(pe.date_from,-1) FROM dct_pay_period pe
                       WHERE pe.period_id=l_run.period_id)
    AND r2.status IN('CALCULATED','REVIEWED');
 EXCEPTION WHEN NO_DATA_FOUND THEN l_prior_run:=NULL;END;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 FOR r IN(SELECT r.*,p.payroll_code,p.name_en payroll_name,p.proration_basis,pe.period_code,
                 pe.date_from,pe.date_to,c.name_en company_name,c.company_code
          FROM dct_pay_run r
          JOIN dct_pay_payroll p ON p.payroll_id=r.payroll_id
          JOIN dct_pay_period pe ON pe.period_id=r.period_id
          JOIN dct_pay_company c ON c.company_id=p.company_id
          WHERE r.run_id=l_run.run_id) LOOP
  APEX_JSON.write('runId',r.run_id);APEX_JSON.write('payrollId',r.payroll_id);
  APEX_JSON.write('payroll',r.payroll_code);APEX_JSON.write('payrollName',r.payroll_name);
  APEX_JSON.write('company',r.company_name);APEX_JSON.write('companyCode',r.company_code);
  APEX_JSON.write('period',r.period_code);APEX_JSON.write('prorationBasis',r.proration_basis);
  APEX_JSON.write('dateFrom',TO_CHAR(r.date_from,'YYYY-MM-DD'));
  APEX_JSON.write('dateTo',TO_CHAR(r.date_to,'YYYY-MM-DD'));
  APEX_JSON.write('runType',r.run_type);APEX_JSON.write('status',r.status);
  APEX_JSON.write('empCount',r.emp_count);APEX_JSON.write('exceptionCount',r.exception_count);
  APEX_JSON.write('gross',r.total_gross);APEX_JSON.write('deductions',r.total_deductions);
  APEX_JSON.write('net',r.total_net);APEX_JSON.write('employerCost',r.total_employer_cost);
  APEX_JSON.write('totalCharges',r.total_charges);
  APEX_JSON.write('loadedAt',NVL(TO_CHAR(dct_to_local(r.loaded_at),'YYYY-MM-DD HH[COLON]MI AM'),''));
  APEX_JSON.write('loadedBy',NVL(r.loaded_by,''));
  APEX_JSON.write('validatedAt',NVL(TO_CHAR(dct_to_local(r.validated_at),'YYYY-MM-DD HH[COLON]MI AM'),''));
  APEX_JSON.write('validatedBy',NVL(r.validated_by,''));
  APEX_JSON.write('calculatedAt',NVL(TO_CHAR(dct_to_local(r.calculated_at),'YYYY-MM-DD HH[COLON]MI AM'),''));
  APEX_JSON.write('calculatedBy',NVL(r.calculated_by,''));
  APEX_JSON.write('reviewedAt',NVL(TO_CHAR(dct_to_local(r.reviewed_at),'YYYY-MM-DD HH[COLON]MI AM'),''));
  APEX_JSON.write('reviewedBy',NVL(r.reviewed_by,''));
 END LOOP;
 APEX_JSON.open_array('groups');
 FOR g IN(SELECT re.invoice_group_code grp,COUNT(*) cnt,ROUND(SUM(re.gross),2) gross,
                 ROUND(SUM(re.deductions),2) ded,ROUND(SUM(re.net),2) net,
                 ROUND(SUM(re.employer_cost),2) er
          FROM dct_pay_run_emp re WHERE re.run_id=l_run.run_id
          GROUP BY re.invoice_group_code ORDER BY 1) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('group',NVL(g.grp,''));APEX_JSON.write('empCount',g.cnt);
  APEX_JSON.write('gross',g.gross);APEX_JSON.write('deductions',g.ded);
  APEX_JSON.write('net',g.net);APEX_JSON.write('employerCost',g.er);
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;
 APEX_JSON.open_array('charges');
 FOR c IN(SELECT * FROM dct_pay_run_charge WHERE run_id=l_run.run_id
          ORDER BY invoice_group_code NULLS LAST,charge_type) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('group',NVL(c.invoice_group_code,''));APEX_JSON.write('chargeType',c.charge_type);
  APEX_JSON.write('description',NVL(c.description,''));APEX_JSON.write('empCount',c.emp_count);
  APEX_JSON.write('amount',c.amount);
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;
 APEX_JSON.open_array('exceptions');
 FOR e IN(SELECT * FROM dct_pay_run_emp
          WHERE run_id=l_run.run_id AND exceptions IS NOT NULL
          ORDER BY status DESC,employee_number FETCH FIRST 100 ROWS ONLY) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('employeeNumber',NVL(e.employee_number,''));
  APEX_JSON.write('name',NVL(e.full_name,''));APEX_JSON.write('status',e.status);
  APEX_JSON.write('flags',e.exceptions);
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;
 APEX_JSON.open_object('variance');
 IF l_prior_run IS NULL THEN
  APEX_JSON.write('hasPrior',FALSE);
 ELSE
  APEX_JSON.write('hasPrior',TRUE);
  FOR v IN(SELECT
             SUM(CASE WHEN p.person_id IS NULL THEN 1 ELSE 0 END) new_cnt,
             SUM(CASE WHEN c.person_id IS NULL THEN 1 ELSE 0 END) left_cnt,
             SUM(CASE WHEN p.person_id IS NOT NULL AND c.person_id IS NOT NULL
                       AND ABS(NVL(c.net,0)-NVL(p.net,0))>0.005 THEN 1 ELSE 0 END) chg_cnt,
             ROUND(NVL(SUM(NVL(c.net,0)),0)-NVL(SUM(NVL(p.net,0)),0),2) net_delta
           FROM (SELECT person_id,net FROM dct_pay_run_emp WHERE run_id=l_run.run_id) c
           FULL OUTER JOIN (SELECT person_id,net FROM dct_pay_run_emp WHERE run_id=l_prior_run) p
             ON p.person_id=c.person_id) LOOP
   APEX_JSON.write('newCount',v.new_cnt);APEX_JSON.write('leftCount',v.left_cnt);
   APEX_JSON.write('changedCount',v.chg_cnt);APEX_JSON.write('netDelta',v.net_delta);
  END LOOP;
  APEX_JSON.open_array('items');
  FOR v IN(SELECT NVL(c.employee_number,p.employee_number) emp_no,
                  NVL(c.full_name,p.full_name) full_name,
                  CASE WHEN p.person_id IS NULL THEN 'NEW'
                       WHEN c.person_id IS NULL THEN 'LEFT' ELSE 'CHANGED' END kind,
                  NVL(p.net,0) prior_net,NVL(c.net,0) cur_net,
                  ROUND(NVL(c.net,0)-NVL(p.net,0),2) delta
           FROM (SELECT person_id,employee_number,full_name,net
                 FROM dct_pay_run_emp WHERE run_id=l_run.run_id) c
           FULL OUTER JOIN (SELECT person_id,employee_number,full_name,net
                 FROM dct_pay_run_emp WHERE run_id=l_prior_run) p
             ON p.person_id=c.person_id
           WHERE p.person_id IS NULL OR c.person_id IS NULL
              OR ABS(NVL(c.net,0)-NVL(p.net,0))>0.005
           ORDER BY ABS(NVL(c.net,0)-NVL(p.net,0)) DESC
           FETCH FIRST 100 ROWS ONLY) LOOP
   APEX_JSON.open_object;
   APEX_JSON.write('employeeNumber',NVL(v.emp_no,''));APEX_JSON.write('name',NVL(v.full_name,''));
   APEX_JSON.write('kind',v.kind);APEX_JSON.write('priorNet',v.prior_net);
   APEX_JSON.write('curNet',v.cur_net);APEX_JSON.write('delta',v.delta);
   APEX_JSON.close_object;
  END LOOP;APEX_JSON.close_array;
 END IF;
 APEX_JSON.close_object;
 APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');

  tpl('runs/:id/action');
  h('runs/:id/action','POST',q'!
DECLARE l_user VARCHAR2(100);
BEGIN
 dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_calc_pkg.act(TO_NUMBER([COLON]id),UPPER(APEX_JSON.get_varchar2('action')),l_user);
 COMMIT;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('ok',TRUE);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
 ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  tpl('runs/:id/emps');
  h('runs/:id/emps','GET',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;
 l_lim NUMBER:=LEAST(NVL(TO_NUMBER([COLON]limit DEFAULT NULL ON CONVERSION ERROR),50),1000);
 l_off NUMBER:=NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR),0);
 l_tot NUMBER;
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 SELECT COUNT(*) INTO l_tot FROM dct_pay_run_emp re
 WHERE re.run_id=TO_NUMBER([COLON]id)
   AND ([COLON]search IS NULL OR UPPER(re.full_name) LIKE '%'||UPPER([COLON]search)||'%'
        OR UPPER(NVL(re.employee_number,'~')) LIKE '%'||UPPER([COLON]search)||'%'
        OR UPPER(NVL(re.company_ref,'~')) LIKE '%'||UPPER([COLON]search)||'%')
   AND ([COLON]grp IS NULL OR re.invoice_group_code=[COLON]grp)
   AND ([COLON]status IS NULL OR re.status=[COLON]status);
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('total',l_tot);
 APEX_JSON.open_array('items');
 FOR r IN(SELECT re.* FROM dct_pay_run_emp re
          WHERE re.run_id=TO_NUMBER([COLON]id)
            AND ([COLON]search IS NULL OR UPPER(re.full_name) LIKE '%'||UPPER([COLON]search)||'%'
                 OR UPPER(NVL(re.employee_number,'~')) LIKE '%'||UPPER([COLON]search)||'%'
                 OR UPPER(NVL(re.company_ref,'~')) LIKE '%'||UPPER([COLON]search)||'%')
            AND ([COLON]grp IS NULL OR re.invoice_group_code=[COLON]grp)
            AND ([COLON]status IS NULL OR re.status=[COLON]status)
          ORDER BY re.employee_number
          OFFSET l_off ROWS FETCH NEXT l_lim ROWS ONLY) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('runEmpId',r.run_emp_id);APEX_JSON.write('personId',r.person_id);
  APEX_JSON.write('employeeNumber',NVL(r.employee_number,''));
  APEX_JSON.write('name',NVL(r.full_name,''));
  APEX_JSON.write('companyRef',NVL(r.company_ref,''));
  APEX_JSON.write('sector',NVL(r.sector_name,''));
  APEX_JSON.write('department',NVL(r.department_name,''));
  APEX_JSON.write('gradeCode',NVL(r.grade_code,''));
  APEX_JSON.write('costCenter',NVL(r.cost_center_code,''));
  APEX_JSON.write('group',NVL(r.invoice_group_code,''));
  APEX_JSON.write('factor',r.days_factor);
  APEX_JSON.write('gross',r.gross);APEX_JSON.write('deductions',r.deductions);
  APEX_JSON.write('net',r.net);APEX_JSON.write('employerCost',r.employer_cost);
  APEX_JSON.write('status',r.status);APEX_JSON.write('flags',NVL(r.exceptions,''));
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');

  tpl('runs/:id/emps/:reid');
  h('runs/:id/emps/:reid','GET',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.open_array('lines');
 FOR r IN(SELECT * FROM dct_pay_run_line
          WHERE run_emp_id=TO_NUMBER([COLON]reid)
          ORDER BY CASE element_class WHEN 'EARNING' THEN 1 WHEN 'DEDUCTION' THEN 2
                        WHEN 'EMPLOYER_COST' THEN 3 ELSE 4 END,element_code) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('element',r.element_code);APEX_JSON.write('elementClass',r.element_class);
  APEX_JSON.write('base',r.base_amount);APEX_JSON.write('rate',r.rate_used);
  APEX_JSON.write('prorated',NVL(r.prorated,''));APEX_JSON.write('amount',r.amount);
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');

  tpl('runs/:id/export');
  h('runs/:id/export','GET',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;
 l_period VARCHAR2(7);l_code VARCHAR2(30);
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 BEGIN
  SELECT pe.period_code,p.payroll_code INTO l_period,l_code
  FROM dct_pay_run r JOIN dct_pay_period pe ON pe.period_id=r.period_id
  JOIN dct_pay_payroll p ON p.payroll_id=r.payroll_id
  WHERE r.run_id=TO_NUMBER([COLON]id);
 EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Run not found');RETURN;END;
 OWA_UTIL.mime_header('text/csv',FALSE);
 HTP.p('Content-Disposition[COLON] attachment; filename="payroll-register-'||l_code||'-'||l_period||'.csv"');
 OWA_UTIL.http_header_close;
 HTP.prn(CHR(65279));
 HTP.prn('Employee No,Name,Company Ref,Sector,Department,Grade,Cost Center,Invoice Group,Factor,Gross,Deductions,Net,Employer Cost,Status,Flags'||CHR(13)||CHR(10));
 FOR r IN(SELECT * FROM dct_pay_run_emp WHERE run_id=TO_NUMBER([COLON]id) ORDER BY employee_number) LOOP
  HTP.prn('"'||NVL(r.employee_number,'')||'","'||REPLACE(NVL(r.full_name,''),'"','''')||'","'||
          NVL(r.company_ref,'')||'","'||REPLACE(NVL(r.sector_name,''),'"','''')||'","'||
          REPLACE(NVL(r.department_name,''),'"','''')||'","'||NVL(r.grade_code,'')||'","'||
          NVL(r.cost_center_code,'')||'","'||NVL(r.invoice_group_code,'')||'",'||
          NVL(TO_CHAR(r.days_factor),'')||','||NVL(TO_CHAR(r.gross),'0')||','||
          NVL(TO_CHAR(r.deductions),'0')||','||NVL(TO_CHAR(r.net),'0')||','||
          NVL(TO_CHAR(r.employer_cost),'0')||',"'||r.status||'","'||NVL(r.exceptions,'')||'"'||
          CHR(13)||CHR(10));
 END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');

  COMMIT;
END setup_pay_p3_ords_tmp;
/
BEGIN setup_pay_p3_ords_tmp;END;
/
DROP PROCEDURE setup_pay_p3_ords_tmp;
PROMPT === PAY Phase 3 Payroll ORDS complete ===
