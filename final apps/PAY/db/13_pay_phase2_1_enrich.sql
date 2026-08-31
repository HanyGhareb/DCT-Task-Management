-- PAY Phase 2.1 -- Workforce enrichment from the REAL payroll data
-- (docs/PAYROLL: Al Nahiya / Dayton / Reach monthly rounds Oct-Dec 2025).
-- Additive; never drops business data. Re-runnable.
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

ALTER SESSION SET CURRENT_SCHEMA = PROD;

PROMPT --- [1/4] assignment enrichment columns ---

DECLARE
  PROCEDURE add_col(p_table VARCHAR2, p_col VARCHAR2, p_ddl VARCHAR2) IS l_n NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_n FROM all_tab_columns
     WHERE owner='PROD' AND table_name=UPPER(p_table) AND column_name=UPPER(p_col);
    IF l_n=0 THEN EXECUTE IMMEDIATE 'ALTER TABLE '||p_table||' ADD ('||p_ddl||')'; END IF;
  END;
BEGIN
  -- the outsource company's own employee reference (ANG Reference / Reach ID#)
  add_col('DCT_PAY_ASSIGNMENT','COMPANY_REF','company_ref VARCHAR2(40)');
  -- real-world designation; free text (the HR_JOBS master does not cover the
  -- ~200 outsourced designations in the payroll sheets; job_id stays optional)
  add_col('DCT_PAY_ASSIGNMENT','JOB_TITLE','job_title VARCHAR2(200)');
  -- sector / department names as they appear on the DCT payroll sheets
  add_col('DCT_PAY_ASSIGNMENT','SECTOR_NAME','sector_name VARCHAR2(120)');
  add_col('DCT_PAY_ASSIGNMENT','DEPARTMENT_NAME','department_name VARCHAR2(120)');
  -- DCT cost centre of the assignment (payroll GL coding; Phase 3 uses it)
  add_col('DCT_PAY_ASSIGNMENT','COST_CENTER_CODE','cost_center_code VARCHAR2(10)');
  -- current contractual salary snapshot (monthly AED); Phase 3 elements refine
  add_col('DCT_PAY_ASSIGNMENT','BASIC_SALARY','basic_salary NUMBER');
  add_col('DCT_PAY_ASSIGNMENT','ALLOWANCE_AMOUNT','allowance_amount NUMBER');
  add_col('DCT_PAY_ASSIGNMENT','GROSS_SALARY','gross_salary NUMBER');
END;
/

COMMENT ON COLUMN prod.dct_pay_assignment.company_ref IS 'Outsource company''s own employee reference (e.g. Al Nahiya ANG 02-0288, Reach ID#).';
COMMENT ON COLUMN prod.dct_pay_assignment.gross_salary IS 'Current contractual monthly gross (AED) snapshot from the payroll sheets; Phase 3 element entries supersede.';

PROMPT --- [2/4] real outsource grade ladder in the shared grades master ---

DECLARE
  PROCEDURE up_grade(p_code VARCHAR2, p_lvl NUMBER, p_ord NUMBER) IS l_n NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_n FROM prod.dct_employee_grades WHERE grade_code=p_code;
    IF l_n=0 THEN
      INSERT INTO prod.dct_employee_grades
             (grade_code, grade_name_en, grade_name_ar, grade_category, grade_level,
              is_active, display_order, created_by)
      VALUES (p_code, 'Grade '||p_code, 'الدرجة '||p_code, 'OUTSOURCE', p_lvl,
              'Y', p_ord, 'PAY_P2_1');
    END IF;
  END;
BEGIN
  -- ladder observed in the Al Nahiya / Dayton payroll sheets (1A best known set)
  FOR lvl IN 1..7 LOOP
    up_grade(TO_CHAR(lvl)||'A', lvl, lvl*10+1);
    up_grade(TO_CHAR(lvl)||'B', lvl, lvl*10+2);
    up_grade(TO_CHAR(lvl)||'C', lvl, lvl*10+3);
  END LOOP;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Outsource grade ladder ensured (1A..7C)');
END;
/

PROMPT --- [3/4] outsource companies observed in the payroll rounds ---

DECLARE
  PROCEDURE up_co(p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, p_notes VARCHAR2) IS l_n NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_n FROM prod.dct_pay_company WHERE company_code=p_code;
    IF l_n=0 THEN
      INSERT INTO prod.dct_pay_company
             (company_code, name_en, name_ar, category, status, is_active, notes, created_by, updated_by)
      VALUES (p_code, p_en, p_ar, 'MANPOWER', 'ACTIVE', 'Y', p_notes, 'PAY_P2_1', 'PAY_P2_1');
    END IF;
  END;
BEGIN
  up_co('DAYTON', 'Dayton', 'دايتون',
        'Outsource payroll provider - observed in the Oct-Dec 2025 DCT payroll rounds (docs/PAYROLL). Contract details pending.');
  up_co('REACH', 'Reach Employment Services', 'ريتش لخدمات التوظيف',
        'Outsource payroll provider for the TCA blue-collar payroll - observed in the Oct-Dec 2025 rounds (docs/PAYROLL). Contract details pending.');
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Companies ensured: DAYTON, REACH');
END;
/

PROMPT --- [4/4] Al Nahiya per-employee markup corrected to the observed 795 ---

DECLARE
  l_n NUMBER := 0;
BEGIN
  -- demo seed said 1500/employee; the real Nov+Dec 2025 sheets carry a
  -- Prorated Markup of 795 on every Al Nahiya row
  UPDATE prod.dct_pay_margin_rule mr
     SET mr.rate_value = 795, mr.updated_by = 'PAY_P2_1', mr.updated_at = SYSDATE
   WHERE mr.method = 'PER_EMPLOYEE'
     AND mr.rate_value = 1500
     AND mr.contract_id IN (SELECT ct.contract_id FROM prod.dct_pay_contract ct
                            JOIN prod.dct_pay_company co ON co.company_id = ct.company_id
                            WHERE co.company_code = 'ALN');
  l_n := SQL%ROWCOUNT;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('ALN margin rule rows corrected to 795: '||l_n);
END;
/

PROMPT === 13_pay_phase2_1_enrich.sql complete ===
