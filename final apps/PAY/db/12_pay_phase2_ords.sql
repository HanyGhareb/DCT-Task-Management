-- PAY Phase 2 additive Workforce API; re-run after any 04_pay_ords.sql re-run
-- Fresh SQLcl session required (synonym rule: never after CURRENT_SCHEMA=PROD)
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

CREATE OR REPLACE SYNONYM dct_pay_emp_pkg FOR prod.dct_pay_emp_pkg;
CREATE OR REPLACE SYNONYM dct_pay_assignment FOR prod.dct_pay_assignment;
CREATE OR REPLACE SYNONYM dct_pay_emp_bank FOR prod.dct_pay_emp_bank;
CREATE OR REPLACE SYNONYM dct_pay_emp_event FOR prod.dct_pay_emp_event;
CREATE OR REPLACE SYNONYM dct_employees FOR prod.dct_employees;
CREATE OR REPLACE SYNONYM dct_organizations FOR prod.dct_organizations;
CREATE OR REPLACE SYNONYM hr_jobs FOR prod.hr_jobs;
CREATE OR REPLACE SYNONYM hr_positions FOR prod.hr_positions;
CREATE OR REPLACE SYNONYM hr_locations FOR prod.hr_locations;
CREATE OR REPLACE SYNONYM dct_employee_grades FOR prod.dct_employee_grades;
CREATE OR REPLACE SYNONYM dct_nationality FOR prod.dct_nationality;
CREATE OR REPLACE SYNONYM dct_doc_requirements FOR prod.dct_doc_requirements;

CREATE OR REPLACE PROCEDURE setup_pay_p2_ords_tmp AS
  c_mod CONSTANT VARCHAR2(30):='pay.rest';
  PROCEDURE tpl(p VARCHAR2) IS BEGIN ORDS.DEFINE_TEMPLATE(p_module_name=>c_mod,p_pattern=>REPLACE(p,'[COLON]',CHR(58))); END;
  PROCEDURE h(p VARCHAR2,m VARCHAR2,s CLOB) IS BEGIN
    ORDS.DEFINE_HANDLER(p_module_name=>c_mod,p_pattern=>REPLACE(p,'[COLON]',CHR(58)),p_method=>m,
      p_source_type=>ORDS.source_type_plsql,p_source=>REPLACE(s,'[COLON]',CHR(58)));
  END;
BEGIN

  -- ------------------------------------------------------- employee register
  tpl('employees');
  h('employees','GET',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;
 l_lim NUMBER:=LEAST(NVL(TO_NUMBER([COLON]limit DEFAULT NULL ON CONVERSION ERROR),25),200);
 l_off NUMBER:=NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR),0);
 l_tot NUMBER;
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 SELECT COUNT(*) INTO l_tot
 FROM dct_employees e
 LEFT JOIN dct_pay_assignment a ON a.person_id=e.person_id AND a.assignment_type='PRIMARY' AND a.status!='ENDED'
 WHERE e.employee_type='OUTSOURCE'
   AND ([COLON]search IS NULL OR UPPER(e.full_name_en) LIKE '%'||UPPER([COLON]search)||'%'
        OR UPPER(NVL(e.full_name_ar,'~')) LIKE '%'||UPPER([COLON]search)||'%'
        OR UPPER(e.employee_number) LIKE '%'||UPPER([COLON]search)||'%'
        OR UPPER(e.email) LIKE '%'||UPPER([COLON]search)||'%'
        OR UPPER(NVL(e.national_id,'~')) LIKE '%'||UPPER([COLON]search)||'%'
        OR UPPER(NVL(e.fusion_person_number,'~')) LIKE '%'||UPPER([COLON]search)||'%')
   AND ([COLON]companyid IS NULL OR a.company_id=TO_NUMBER([COLON]companyid))
   AND ([COLON]bu IS NULL OR a.bu_code=[COLON]bu)
   AND ([COLON]active IS NULL OR e.is_active=[COLON]active);
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('total',l_tot);APEX_JSON.write('limit',l_lim);APEX_JSON.write('offset',l_off);
 APEX_JSON.open_array('items');
 FOR r IN(
  SELECT e.person_id,e.employee_number,e.full_name_en,e.full_name_ar,e.email,e.mobile,
         e.fusion_person_number,e.is_active,e.hire_date,e.end_date,e.national_id,
         a.assignment_id,a.company_id,c.name_en company_name,a.bu_code,a.status asg_status,
         o.org_name_en,j.job_name_en,a.grade_code,
         a.job_title,a.sector_name,a.department_name,a.cost_center_code
  FROM dct_employees e
  LEFT JOIN dct_pay_assignment a ON a.person_id=e.person_id AND a.assignment_type='PRIMARY' AND a.status!='ENDED'
  LEFT JOIN dct_pay_company c ON c.company_id=a.company_id
  LEFT JOIN dct_organizations o ON o.org_id=a.org_id
  LEFT JOIN hr_jobs j ON j.job_id=a.job_id
  WHERE e.employee_type='OUTSOURCE'
    AND ([COLON]search IS NULL OR UPPER(e.full_name_en) LIKE '%'||UPPER([COLON]search)||'%'
         OR UPPER(NVL(e.full_name_ar,'~')) LIKE '%'||UPPER([COLON]search)||'%'
         OR UPPER(e.employee_number) LIKE '%'||UPPER([COLON]search)||'%'
         OR UPPER(e.email) LIKE '%'||UPPER([COLON]search)||'%'
         OR UPPER(NVL(e.national_id,'~')) LIKE '%'||UPPER([COLON]search)||'%'
         OR UPPER(NVL(e.fusion_person_number,'~')) LIKE '%'||UPPER([COLON]search)||'%')
    AND ([COLON]companyid IS NULL OR a.company_id=TO_NUMBER([COLON]companyid))
    AND ([COLON]bu IS NULL OR a.bu_code=[COLON]bu)
    AND ([COLON]active IS NULL OR e.is_active=[COLON]active)
  ORDER BY e.employee_number
  OFFSET l_off ROWS FETCH NEXT l_lim ROWS ONLY
 ) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('personId',r.person_id);APEX_JSON.write('employeeNumber',r.employee_number);
  APEX_JSON.write('nameEn',NVL(r.full_name_en,''));APEX_JSON.write('nameAr',NVL(r.full_name_ar,''));
  APEX_JSON.write('email',r.email);APEX_JSON.write('mobile',NVL(r.mobile,''));
  APEX_JSON.write('emiratesId',NVL(r.national_id,''));
  APEX_JSON.write('fusionPersonNumber',NVL(r.fusion_person_number,''));
  APEX_JSON.write('isActive',r.is_active);
  APEX_JSON.write('hireDate',NVL(TO_CHAR(r.hire_date,'YYYY-MM-DD'),''));
  APEX_JSON.write('endDate',NVL(TO_CHAR(r.end_date,'YYYY-MM-DD'),''));
  APEX_JSON.write('assignmentId',r.assignment_id);APEX_JSON.write('companyId',r.company_id);
  APEX_JSON.write('company',NVL(r.company_name,''));APEX_JSON.write('buCode',NVL(r.bu_code,''));
  APEX_JSON.write('assignmentStatus',NVL(r.asg_status,'UNASSIGNED'));
  APEX_JSON.write('department',NVL(r.department_name,NVL(r.org_name_en,'')));
  APEX_JSON.write('sector',NVL(r.sector_name,''));
  APEX_JSON.write('job',NVL(r.job_title,NVL(r.job_name_en,'')));
  APEX_JSON.write('gradeCode',NVL(r.grade_code,''));
  APEX_JSON.write('costCenter',NVL(r.cost_center_code,''));
  APEX_JSON.close_object;
 END LOOP;
 APEX_JSON.close_array;APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');

  h('employees','POST',q'!
DECLARE l_user VARCHAR2(100);l_pid NUMBER;l_no VARCHAR2(50);
BEGIN
 dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_emp_pkg.save_employee(l_user,NULL,
   APEX_JSON.get_varchar2('firstNameEn'),APEX_JSON.get_varchar2('lastNameEn'),
   APEX_JSON.get_varchar2('firstNameAr'),APEX_JSON.get_varchar2('lastNameAr'),
   TO_DATE(APEX_JSON.get_varchar2('dateOfBirth'),'YYYY-MM-DD'),
   APEX_JSON.get_varchar2('gender'),APEX_JSON.get_varchar2('nationalityCode'),
   APEX_JSON.get_varchar2('emiratesId'),APEX_JSON.get_varchar2('passportNumber'),
   APEX_JSON.get_varchar2('email'),APEX_JSON.get_varchar2('mobile'),
   APEX_JSON.get_varchar2('fusionPersonNumber'),
   TO_DATE(APEX_JSON.get_varchar2('hireDate'),'YYYY-MM-DD'),
   l_pid,l_no);
 COMMIT;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('personId',l_pid);APEX_JSON.write('employeeNumber',l_no);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM);ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
 ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);
 ELSE dct_rest.err(500,SQLERRM);END IF;
END;!');

  -- ------------------------------------------------------- employee profile
  tpl('employees/[COLON]id');
  h('employees/[COLON]id','GET',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;l_found BOOLEAN:=FALSE;l_canpay BOOLEAN;
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 l_canpay:=dct_pay_emp_pkg.can_payroll(l_user);
 FOR e IN(SELECT * FROM dct_employees WHERE person_id=TO_NUMBER([COLON]id) AND employee_type='OUTSOURCE') LOOP
  l_found:=TRUE;
  dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
  APEX_JSON.write('personId',e.person_id);APEX_JSON.write('employeeNumber',e.employee_number);
  APEX_JSON.write('firstNameEn',e.first_name_en);APEX_JSON.write('lastNameEn',e.last_name_en);
  APEX_JSON.write('firstNameAr',NVL(e.first_name_ar,''));APEX_JSON.write('lastNameAr',NVL(e.last_name_ar,''));
  APEX_JSON.write('nameEn',NVL(e.full_name_en,''));APEX_JSON.write('nameAr',NVL(e.full_name_ar,''));
  APEX_JSON.write('dateOfBirth',NVL(TO_CHAR(e.date_of_birth,'YYYY-MM-DD'),''));
  APEX_JSON.write('gender',NVL(e.gender,''));APEX_JSON.write('nationalityCode',NVL(e.nationality_code,''));
  APEX_JSON.write('emiratesId',NVL(e.national_id,''));APEX_JSON.write('passportNumber',NVL(e.passport_number,''));
  APEX_JSON.write('email',e.email);APEX_JSON.write('mobile',NVL(e.mobile,''));
  APEX_JSON.write('fusionPersonNumber',NVL(e.fusion_person_number,''));
  APEX_JSON.write('hireDate',NVL(TO_CHAR(e.hire_date,'YYYY-MM-DD'),''));
  APEX_JSON.write('endDate',NVL(TO_CHAR(e.end_date,'YYYY-MM-DD'),''));
  APEX_JSON.write('isActive',e.is_active);
  APEX_JSON.write('canPayroll',l_canpay);
  APEX_JSON.write('canHr',dct_pay_emp_pkg.can_hr(l_user));
  APEX_JSON.open_array('assignments');
  FOR a IN(SELECT a.*,c.name_en company_name,c.company_code,ct.contract_no,
                  o.org_name_en,j.job_name_en,p.position_name_en,lo.location_name_en,
                  m.full_name_en manager_name
           FROM dct_pay_assignment a
           JOIN dct_pay_company c ON c.company_id=a.company_id
           LEFT JOIN dct_pay_contract ct ON ct.contract_id=a.contract_id
           LEFT JOIN dct_organizations o ON o.org_id=a.org_id
           LEFT JOIN hr_jobs j ON j.job_id=a.job_id
           LEFT JOIN hr_positions p ON p.position_id=a.position_id
           LEFT JOIN hr_locations lo ON lo.location_id=a.location_id
           LEFT JOIN dct_employees m ON m.person_id=a.manager_person_id
           WHERE a.person_id=e.person_id
           ORDER BY a.effective_from DESC,a.assignment_id DESC) LOOP
   APEX_JSON.open_object;
   APEX_JSON.write('assignmentId',a.assignment_id);APEX_JSON.write('companyId',a.company_id);
   APEX_JSON.write('company',a.company_name);APEX_JSON.write('companyCode',a.company_code);
   APEX_JSON.write('contractId',a.contract_id);APEX_JSON.write('contractNo',NVL(a.contract_no,''));
   APEX_JSON.write('buCode',NVL(a.bu_code,''));
   APEX_JSON.write('orgId',a.org_id);APEX_JSON.write('department',NVL(a.org_name_en,''));
   APEX_JSON.write('jobId',a.job_id);APEX_JSON.write('job',NVL(a.job_name_en,''));
   APEX_JSON.write('gradeCode',NVL(a.grade_code,''));
   APEX_JSON.write('positionId',a.position_id);APEX_JSON.write('position',NVL(a.position_name_en,''));
   APEX_JSON.write('locationId',a.location_id);APEX_JSON.write('location',NVL(a.location_name_en,''));
   APEX_JSON.write('managerPersonId',a.manager_person_id);APEX_JSON.write('manager',NVL(a.manager_name,''));
   APEX_JSON.write('peopleGroup',NVL(a.people_group,''));
   APEX_JSON.write('assignmentType',a.assignment_type);APEX_JSON.write('status',a.status);
   APEX_JSON.write('effectiveFrom',TO_CHAR(a.effective_from,'YYYY-MM-DD'));
   APEX_JSON.write('effectiveTo',NVL(TO_CHAR(a.effective_to,'YYYY-MM-DD'),''));
   APEX_JSON.write('notes',NVL(a.notes,''));APEX_JSON.write('rowVersion',a.row_version);
   APEX_JSON.write('companyRef',NVL(a.company_ref,''));
   APEX_JSON.write('jobTitle',NVL(a.job_title,''));
   APEX_JSON.write('sector',NVL(a.sector_name,''));
   APEX_JSON.write('departmentName',NVL(a.department_name,''));
   APEX_JSON.write('costCenter',NVL(a.cost_center_code,''));
   APEX_JSON.write('basicSalary',a.basic_salary);
   APEX_JSON.write('allowance',a.allowance_amount);
   APEX_JSON.write('grossSalary',a.gross_salary);
   APEX_JSON.close_object;
  END LOOP;APEX_JSON.close_array;
  APEX_JSON.open_array('banks');
  FOR b IN(SELECT * FROM dct_pay_emp_bank WHERE person_id=e.person_id ORDER BY is_primary DESC,emp_bank_id) LOOP
   APEX_JSON.open_object;
   APEX_JSON.write('empBankId',b.emp_bank_id);APEX_JSON.write('bankName',b.bank_name);
   APEX_JSON.write('iban',CASE WHEN l_canpay THEN NVL(b.iban,'') ELSE NVL(dct_pay_gov_pkg.mask_bank(b.iban),'') END);
   APEX_JSON.write('accountNumber',CASE WHEN l_canpay THEN NVL(b.account_number,'') ELSE NVL(dct_pay_gov_pkg.mask_bank(b.account_number),'') END);
   APEX_JSON.write('branch',NVL(b.branch_name,''));APEX_JSON.write('currency',b.currency_code);
   APEX_JSON.write('isPrimary',b.is_primary);APEX_JSON.write('isActive',b.is_active);
   APEX_JSON.write('effectiveFrom',TO_CHAR(b.effective_from,'YYYY-MM-DD'));
   APEX_JSON.write('effectiveTo',NVL(TO_CHAR(b.effective_to,'YYYY-MM-DD'),''));
   APEX_JSON.write('rowVersion',b.row_version);
   APEX_JSON.close_object;
  END LOOP;APEX_JSON.close_array;
  APEX_JSON.open_array('events');
  FOR v IN(SELECT v.*,lv.value_name_en reason_name
           FROM dct_pay_emp_event v
           LEFT JOIN dct_lookup_categories lc ON lc.category_code='PAY_EVENT_REASON'
           LEFT JOIN dct_lookup_values lv ON lv.category_id=lc.category_id AND lv.value_code=v.reason_code
           WHERE v.person_id=e.person_id ORDER BY v.event_id DESC) LOOP
   APEX_JSON.open_object;
   APEX_JSON.write('eventId',v.event_id);APEX_JSON.write('type',v.event_type);
   APEX_JSON.write('effectiveDate',TO_CHAR(v.effective_date,'YYYY-MM-DD'));
   APEX_JSON.write('reason',NVL(v.reason_code,''));APEX_JSON.write('reasonName',NVL(v.reason_name,''));
   APEX_JSON.write('notes',NVL(v.notes,''));APEX_JSON.write('by',NVL(v.created_by,''));
   APEX_JSON.write('at',TO_CHAR(dct_to_local(v.created_at),'YYYY-MM-DD HH:MI AM'));
   APEX_JSON.close_object;
  END LOOP;APEX_JSON.close_array;
  APEX_JSON.close_object;
 END LOOP;
 IF NOT l_found THEN dct_rest.err(404,'Employee not found');END IF;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');

  h('employees/[COLON]id','PUT',q'!
DECLARE l_user VARCHAR2(100);l_pid NUMBER;l_no VARCHAR2(50);
BEGIN
 dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_emp_pkg.save_employee(l_user,TO_NUMBER([COLON]id),
   APEX_JSON.get_varchar2('firstNameEn'),APEX_JSON.get_varchar2('lastNameEn'),
   APEX_JSON.get_varchar2('firstNameAr'),APEX_JSON.get_varchar2('lastNameAr'),
   TO_DATE(APEX_JSON.get_varchar2('dateOfBirth'),'YYYY-MM-DD'),
   APEX_JSON.get_varchar2('gender'),APEX_JSON.get_varchar2('nationalityCode'),
   APEX_JSON.get_varchar2('emiratesId'),APEX_JSON.get_varchar2('passportNumber'),
   APEX_JSON.get_varchar2('email'),APEX_JSON.get_varchar2('mobile'),
   APEX_JSON.get_varchar2('fusionPersonNumber'),
   TO_DATE(APEX_JSON.get_varchar2('hireDate'),'YYYY-MM-DD'),
   l_pid,l_no);
 COMMIT;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('personId',l_pid);APEX_JSON.write('employeeNumber',l_no);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM);ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
 ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);
 ELSE dct_rest.err(500,SQLERRM);END IF;
END;!');

  -- ------------------------------------------------------------ assignments
  tpl('employees/[COLON]id/assignments');
  h('employees/[COLON]id/assignments','POST',q'!
DECLARE l_user VARCHAR2(100);l_aid NUMBER;
BEGIN
 dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_emp_pkg.save_assignment(l_user,NULL,TO_NUMBER([COLON]id),
   APEX_JSON.get_number('companyId'),APEX_JSON.get_number('contractId'),
   APEX_JSON.get_varchar2('buCode'),APEX_JSON.get_number('orgId'),
   APEX_JSON.get_number('jobId'),APEX_JSON.get_varchar2('gradeCode'),
   APEX_JSON.get_number('positionId'),APEX_JSON.get_number('locationId'),
   APEX_JSON.get_number('managerPersonId'),APEX_JSON.get_varchar2('peopleGroup'),
   APEX_JSON.get_varchar2('assignmentType'),APEX_JSON.get_varchar2('status'),
   TO_DATE(APEX_JSON.get_varchar2('effectiveFrom'),'YYYY-MM-DD'),
   TO_DATE(APEX_JSON.get_varchar2('effectiveTo'),'YYYY-MM-DD'),
   APEX_JSON.get_varchar2('notes'),l_aid,
   APEX_JSON.get_varchar2('companyRef'),APEX_JSON.get_varchar2('jobTitle'),
   APEX_JSON.get_varchar2('sector'),APEX_JSON.get_varchar2('departmentName'),
   APEX_JSON.get_varchar2('costCenter'),APEX_JSON.get_number('basicSalary'),
   APEX_JSON.get_number('allowance'),APEX_JSON.get_number('grossSalary'));
 COMMIT;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('assignmentId',l_aid);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM);ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
 ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);
 ELSE dct_rest.err(500,SQLERRM);END IF;
END;!');

  tpl('assignments/[COLON]aid');
  h('assignments/[COLON]aid','PUT',q'!
DECLARE l_user VARCHAR2(100);l_aid NUMBER;l_pid NUMBER;
BEGIN
 dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 BEGIN SELECT person_id INTO l_pid FROM dct_pay_assignment WHERE assignment_id=TO_NUMBER([COLON]aid);
 EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Assignment not found');RETURN;END;
 dct_pay_emp_pkg.save_assignment(l_user,TO_NUMBER([COLON]aid),l_pid,
   APEX_JSON.get_number('companyId'),APEX_JSON.get_number('contractId'),
   APEX_JSON.get_varchar2('buCode'),APEX_JSON.get_number('orgId'),
   APEX_JSON.get_number('jobId'),APEX_JSON.get_varchar2('gradeCode'),
   APEX_JSON.get_number('positionId'),APEX_JSON.get_number('locationId'),
   APEX_JSON.get_number('managerPersonId'),APEX_JSON.get_varchar2('peopleGroup'),
   APEX_JSON.get_varchar2('assignmentType'),APEX_JSON.get_varchar2('status'),
   TO_DATE(APEX_JSON.get_varchar2('effectiveFrom'),'YYYY-MM-DD'),
   TO_DATE(APEX_JSON.get_varchar2('effectiveTo'),'YYYY-MM-DD'),
   APEX_JSON.get_varchar2('notes'),l_aid,
   APEX_JSON.get_varchar2('companyRef'),APEX_JSON.get_varchar2('jobTitle'),
   APEX_JSON.get_varchar2('sector'),APEX_JSON.get_varchar2('departmentName'),
   APEX_JSON.get_varchar2('costCenter'),APEX_JSON.get_number('basicSalary'),
   APEX_JSON.get_number('allowance'),APEX_JSON.get_number('grossSalary'));
 COMMIT;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('assignmentId',l_aid);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM);ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
 ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);
 ELSE dct_rest.err(500,SQLERRM);END IF;
END;!');

  -- --------------------------------------------------------------- lifecycle
  tpl('employees/[COLON]id/lifecycle');
  h('employees/[COLON]id/lifecycle','POST',q'!
DECLARE l_user VARCHAR2(100);l_evt NUMBER;
BEGIN
 dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_emp_pkg.lifecycle(l_user,TO_NUMBER([COLON]id),
   UPPER(APEX_JSON.get_varchar2('action')),
   TO_DATE(APEX_JSON.get_varchar2('effectiveDate'),'YYYY-MM-DD'),
   APEX_JSON.get_varchar2('reason'),APEX_JSON.get_varchar2('notes'),
   APEX_JSON.get_number('companyId'),APEX_JSON.get_number('contractId'),
   APEX_JSON.get_varchar2('buCode'),APEX_JSON.get_number('orgId'),
   APEX_JSON.get_number('jobId'),APEX_JSON.get_varchar2('gradeCode'),
   APEX_JSON.get_number('positionId'),APEX_JSON.get_number('locationId'),
   APEX_JSON.get_number('managerPersonId'),APEX_JSON.get_varchar2('peopleGroup'),
   l_evt);
 COMMIT;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('eventId',l_evt);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM);ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
 ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);
 ELSE dct_rest.err(500,SQLERRM);END IF;
END;!');

  -- -------------------------------------------------------------- bank data
  tpl('employees/[COLON]id/banks');
  h('employees/[COLON]id/banks','POST',q'!
DECLARE l_user VARCHAR2(100);l_bid NUMBER;
BEGIN
 dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_emp_pkg.save_bank(l_user,NULL,TO_NUMBER([COLON]id),
   APEX_JSON.get_varchar2('bankName'),APEX_JSON.get_varchar2('iban'),
   APEX_JSON.get_varchar2('accountNumber'),APEX_JSON.get_varchar2('branch'),
   APEX_JSON.get_varchar2('currency'),APEX_JSON.get_varchar2('isPrimary'),
   TO_DATE(APEX_JSON.get_varchar2('effectiveFrom'),'YYYY-MM-DD'),
   TO_DATE(APEX_JSON.get_varchar2('effectiveTo'),'YYYY-MM-DD'),
   APEX_JSON.get_varchar2('isActive'),l_bid);
 COMMIT;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('empBankId',l_bid);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM);ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
 ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);
 ELSE dct_rest.err(500,SQLERRM);END IF;
END;!');

  tpl('emp-banks/[COLON]bid');
  h('emp-banks/[COLON]bid','PUT',q'!
DECLARE l_user VARCHAR2(100);l_bid NUMBER;l_pid NUMBER;
BEGIN
 dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 BEGIN SELECT person_id INTO l_pid FROM dct_pay_emp_bank WHERE emp_bank_id=TO_NUMBER([COLON]bid);
 EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Bank record not found');RETURN;END;
 dct_pay_emp_pkg.save_bank(l_user,TO_NUMBER([COLON]bid),l_pid,
   APEX_JSON.get_varchar2('bankName'),APEX_JSON.get_varchar2('iban'),
   APEX_JSON.get_varchar2('accountNumber'),APEX_JSON.get_varchar2('branch'),
   APEX_JSON.get_varchar2('currency'),APEX_JSON.get_varchar2('isPrimary'),
   TO_DATE(APEX_JSON.get_varchar2('effectiveFrom'),'YYYY-MM-DD'),
   TO_DATE(APEX_JSON.get_varchar2('effectiveTo'),'YYYY-MM-DD'),
   APEX_JSON.get_varchar2('isActive'),l_bid);
 COMMIT;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('empBankId',l_bid);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM);ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
 ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);
 ELSE dct_rest.err(500,SQLERRM);END IF;
END;!');

  -- -------------------------------------------------------------- documents
  tpl('employees/[COLON]id/docs');
  h('employees/[COLON]id/docs','GET',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.open_array('items');
 FOR d IN(SELECT d.doc_id,d.file_name,d.mime_type,d.file_size_bytes,d.expiry_date,
                 dt.doc_type_code,dt.doc_type_name_en,dt.doc_type_name_ar,
                 d.created_at,
                 CASE WHEN d.file_blob IS NOT NULL THEN 'Y' ELSE 'N' END has_file
          FROM dct_documents d
          JOIN dct_document_types dt ON dt.doc_type_id=d.doc_type_id
          WHERE d.source_module='PAY' AND d.source_type='PAY_EMPLOYEE'
            AND d.reference_id=TO_NUMBER([COLON]id) AND d.is_active='Y'
          ORDER BY d.doc_id DESC) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('docId',d.doc_id);APEX_JSON.write('fileName',d.file_name);
  APEX_JSON.write('mime',NVL(d.mime_type,''));APEX_JSON.write('fileSize',d.file_size_bytes);
  APEX_JSON.write('docType',d.doc_type_code);APEX_JSON.write('docTypeEn',d.doc_type_name_en);
  APEX_JSON.write('docTypeAr',NVL(d.doc_type_name_ar,''));
  APEX_JSON.write('expiryDate',NVL(TO_CHAR(d.expiry_date,'YYYY-MM-DD'),''));
  APEX_JSON.write('daysLeft',CASE WHEN d.expiry_date IS NOT NULL THEN TRUNC(d.expiry_date)-TRUNC(SYSDATE) END);
  APEX_JSON.write('hasFile',d.has_file);
  APEX_JSON.write('uploadedAt',TO_CHAR(dct_to_local(d.created_at),'YYYY-MM-DD HH:MI AM'));
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;
 APEX_JSON.open_array('checklist');
 FOR c IN(SELECT dt.doc_type_code,dt.doc_type_name_en,dt.doc_type_name_ar,dt.has_expiry,
                 rq.is_mandatory,rq.display_seq,
                 (SELECT COUNT(*) FROM dct_documents d
                   WHERE d.source_module='PAY' AND d.source_type='PAY_EMPLOYEE'
                     AND d.reference_id=TO_NUMBER([COLON]id) AND d.is_active='Y'
                     AND d.doc_type_id=dt.doc_type_id) cnt,
                 (SELECT MAX(d.expiry_date) FROM dct_documents d
                   WHERE d.source_module='PAY' AND d.source_type='PAY_EMPLOYEE'
                     AND d.reference_id=TO_NUMBER([COLON]id) AND d.is_active='Y'
                     AND d.doc_type_id=dt.doc_type_id) max_expiry
          FROM dct_doc_requirements rq
          JOIN dct_document_types dt ON dt.doc_type_id=rq.doc_type_id
          WHERE rq.source_module='PAY' AND rq.context_code='PAY_EMPLOYEE' AND rq.is_active='Y'
          ORDER BY rq.display_seq) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('docType',c.doc_type_code);APEX_JSON.write('nameEn',c.doc_type_name_en);
  APEX_JSON.write('nameAr',NVL(c.doc_type_name_ar,''));APEX_JSON.write('mandatory',c.is_mandatory);
  APEX_JSON.write('hasExpiry',c.has_expiry);APEX_JSON.write('uploaded',CASE WHEN c.cnt>0 THEN 'Y' ELSE 'N' END);
  APEX_JSON.write('expiryDate',NVL(TO_CHAR(c.max_expiry,'YYYY-MM-DD'),''));
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;
 APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');

  h('employees/[COLON]id/docs','PUT',q'!
DECLARE l_user VARCHAR2(100);l_uid NUMBER;v_blob BLOB;v_len NUMBER;v_max NUMBER;l_id NUMBER;
BEGIN
 v_blob:=[COLON]body;
 l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 IF v_blob IS NULL OR DBMS_LOB.GETLENGTH(v_blob)=0 THEN dct_rest.err(400,'Request body (file bytes) is required');RETURN;END IF;
 IF [COLON]file_name IS NULL THEN dct_rest.err(400,'file_name query parameter is required');RETURN;END IF;
 v_len:=DBMS_LOB.GETLENGTH(v_blob);
 BEGIN
  SELECT TO_NUMBER(ms.setting_value DEFAULT NULL ON CONVERSION ERROR) INTO v_max
  FROM dct_module_settings ms JOIN dct_modules m ON m.module_id=ms.module_id
  WHERE m.module_code='PAY' AND ms.setting_key='MAX_UPLOAD_MB';
 EXCEPTION WHEN NO_DATA_FOUND THEN v_max:=NULL;END;
 v_max:=NVL(v_max,10);
 IF v_len>v_max*1024*1024 THEN dct_rest.err(413,'File exceeds the maximum upload size of '||v_max||' MB');RETURN;END IF;
 l_uid:=dct_auth.get_user_id(l_user);
 l_id:=dct_pay_emp_pkg.add_emp_doc(
   p_user=>l_user,p_user_id=>l_uid,p_person_id=>TO_NUMBER([COLON]id),
   p_doc_type_code=>[COLON]doctype,p_file_name=>[COLON]file_name,
   p_mime=>NVL([COLON]mime_type,'application/octet-stream'),
   p_expiry_date=>TO_DATE([COLON]expiry DEFAULT NULL ON CONVERSION ERROR,'YYYY-MM-DD'),
   p_blob=>v_blob);
 COMMIT;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('docId',l_id);APEX_JSON.write('fileSize',v_len);APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM);ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
 ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);
 ELSE dct_rest.err(500,SQLERRM);END IF;
END;!');

  -- ------------------------------------------------------------ bulk upsert
  tpl('employees/bulk');
  h('employees/bulk','POST',q'!
DECLARE
 l_user VARCHAR2(100);v_blob BLOB;l_json CLOB;l_out CLOB;
 l_do NUMBER:=1;l_so NUMBER:=1;l_lc NUMBER:=DBMS_LOB.DEFAULT_LANG_CTX;l_w NUMBER;
 l_len NUMBER;l_pos NUMBER:=1;
BEGIN
 v_blob:=[COLON]body;
 l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 IF v_blob IS NULL OR DBMS_LOB.GETLENGTH(v_blob)=0 THEN dct_rest.err(400,'Request body is required');RETURN;END IF;
 DBMS_LOB.CREATETEMPORARY(l_json,TRUE);
 DBMS_LOB.CONVERTTOCLOB(l_json,v_blob,DBMS_LOB.LOBMAXSIZE,l_do,l_so,DBMS_LOB.DEFAULT_CSID,l_lc,l_w);
 dct_pay_emp_pkg.bulk_upsert(l_user,l_json,l_out);
 dct_rest.json_header;
 l_len:=DBMS_LOB.GETLENGTH(l_out);
 WHILE l_pos<=l_len LOOP HTP.prn(DBMS_LOB.SUBSTR(l_out,8000,l_pos));l_pos:=l_pos+8000;END LOOP;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM);ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
 ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);
 ELSE dct_rest.err(500,SQLERRM);END IF;
END;!');

  -- ------------------------------------------------------------------- LOVs
  tpl('lov/masters');
  h('lov/masters','GET',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('canHr',dct_pay_emp_pkg.can_hr(l_user));
 APEX_JSON.write('canPayroll',dct_pay_emp_pkg.can_payroll(l_user));
 APEX_JSON.open_array('companies');
 FOR r IN(SELECT company_id,company_code,name_en FROM dct_pay_company WHERE is_active='Y' ORDER BY company_code) LOOP
  APEX_JSON.open_object;APEX_JSON.write('id',r.company_id);APEX_JSON.write('code',r.company_code);APEX_JSON.write('name',r.name_en);APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;
 APEX_JSON.open_array('contracts');
 FOR r IN(SELECT contract_id,contract_no,company_id FROM dct_pay_contract WHERE status='ACTIVE' AND is_active='Y' ORDER BY contract_no) LOOP
  APEX_JSON.open_object;APEX_JSON.write('id',r.contract_id);APEX_JSON.write('no',r.contract_no);APEX_JSON.write('companyId',r.company_id);APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;
 APEX_JSON.open_array('departments');
 FOR r IN(SELECT org_id,org_code,org_name_en,org_name_ar FROM dct_organizations WHERE is_active='Y' ORDER BY org_name_en) LOOP
  APEX_JSON.open_object;APEX_JSON.write('id',r.org_id);APEX_JSON.write('code',NVL(r.org_code,''));APEX_JSON.write('name',r.org_name_en);APEX_JSON.write('nameAr',NVL(r.org_name_ar,''));APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;
 APEX_JSON.open_array('jobs');
 FOR r IN(SELECT job_id,job_code,job_name_en,job_name_ar FROM hr_jobs WHERE is_active='Y' ORDER BY job_name_en) LOOP
  APEX_JSON.open_object;APEX_JSON.write('id',r.job_id);APEX_JSON.write('code',NVL(r.job_code,''));APEX_JSON.write('name',r.job_name_en);APEX_JSON.write('nameAr',NVL(r.job_name_ar,''));APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;
 APEX_JSON.open_array('grades');
 FOR r IN(SELECT grade_code,grade_name_en,grade_name_ar FROM dct_employee_grades WHERE is_active='Y' ORDER BY display_order) LOOP
  APEX_JSON.open_object;APEX_JSON.write('code',r.grade_code);APEX_JSON.write('name',r.grade_name_en);APEX_JSON.write('nameAr',NVL(r.grade_name_ar,''));APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;
 APEX_JSON.open_array('positions');
 FOR r IN(SELECT position_id,position_code,position_name_en FROM hr_positions WHERE is_active='Y' ORDER BY position_name_en) LOOP
  APEX_JSON.open_object;APEX_JSON.write('id',r.position_id);APEX_JSON.write('code',NVL(r.position_code,''));APEX_JSON.write('name',r.position_name_en);APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;
 APEX_JSON.open_array('locations');
 FOR r IN(SELECT location_id,location_code,location_name_en FROM hr_locations WHERE is_active='Y' ORDER BY location_name_en) LOOP
  APEX_JSON.open_object;APEX_JSON.write('id',r.location_id);APEX_JSON.write('code',NVL(r.location_code,''));APEX_JSON.write('name',r.location_name_en);APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;
 APEX_JSON.open_array('nationalities');
 FOR r IN(SELECT nationality_code,nationality_en,nationality_ar FROM dct_nationality WHERE is_active='Y' ORDER BY display_order,nationality_en) LOOP
  APEX_JSON.open_object;APEX_JSON.write('code',r.nationality_code);APEX_JSON.write('name',r.nationality_en);APEX_JSON.write('nameAr',NVL(r.nationality_ar,''));APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;
 APEX_JSON.open_array('docTypes');
 FOR r IN(SELECT doc_type_code,doc_type_name_en,doc_type_name_ar,has_expiry FROM dct_document_types
          WHERE INSTR('|'||applies_to_modules||'|','|PAY|')>0 ORDER BY display_order) LOOP
  APEX_JSON.open_object;APEX_JSON.write('code',r.doc_type_code);APEX_JSON.write('name',r.doc_type_name_en);APEX_JSON.write('nameAr',NVL(r.doc_type_name_ar,''));APEX_JSON.write('hasExpiry',r.has_expiry);APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;
 APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');

  tpl('lov/employees');
  h('lov/employees','GET',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;APEX_JSON.open_array('items');
 FOR r IN(SELECT person_id,employee_number,full_name_en,employee_type FROM dct_employees
          WHERE is_active='Y'
            AND ([COLON]search IS NULL OR UPPER(full_name_en) LIKE '%'||UPPER([COLON]search)||'%'
                 OR UPPER(employee_number) LIKE '%'||UPPER([COLON]search)||'%')
          ORDER BY full_name_en FETCH FIRST 20 ROWS ONLY) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('personId',r.person_id);APEX_JSON.write('employeeNumber',r.employee_number);
  APEX_JSON.write('name',NVL(r.full_name_en,''));APEX_JSON.write('type',r.employee_type);
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');

  -- ---------------------------------------------------------- expiring docs
  tpl('employees/expiring-docs');
  h('employees/expiring-docs','GET',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;
 l_days NUMBER:=NVL(TO_NUMBER([COLON]days DEFAULT NULL ON CONVERSION ERROR),30);
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;APEX_JSON.open_array('items');
 FOR r IN(SELECT d.doc_id,d.expiry_date,dt.doc_type_name_en,dt.doc_type_name_ar,
                 e.person_id,e.employee_number,e.full_name_en,
                 TRUNC(d.expiry_date)-TRUNC(SYSDATE) days_left
          FROM dct_documents d
          JOIN dct_document_types dt ON dt.doc_type_id=d.doc_type_id
          JOIN dct_employees e ON e.person_id=d.reference_id AND e.is_active='Y'
          WHERE d.source_module='PAY' AND d.source_type='PAY_EMPLOYEE' AND d.is_active='Y'
            AND d.expiry_date IS NOT NULL
            AND TRUNC(d.expiry_date)-TRUNC(SYSDATE)<=l_days
          ORDER BY d.expiry_date FETCH FIRST 100 ROWS ONLY) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('docId',r.doc_id);APEX_JSON.write('personId',r.person_id);
  APEX_JSON.write('employeeNumber',r.employee_number);APEX_JSON.write('name',NVL(r.full_name_en,''));
  APEX_JSON.write('docTypeEn',r.doc_type_name_en);APEX_JSON.write('docTypeAr',NVL(r.doc_type_name_ar,''));
  APEX_JSON.write('expiryDate',TO_CHAR(r.expiry_date,'YYYY-MM-DD'));APEX_JSON.write('daysLeft',r.days_left);
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');

  COMMIT;
END setup_pay_p2_ords_tmp;
/
BEGIN setup_pay_p2_ords_tmp;END;
/
DROP PROCEDURE setup_pay_p2_ords_tmp;
PROMPT === PAY Phase 2 Workforce ORDS complete ===
