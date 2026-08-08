-- PAY Phase 2 Workforce DDL (additive; never drops business data)
-- App 215 - outsourced employees on the shared employee master + assignments/banks/events
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

ALTER SESSION SET CURRENT_SCHEMA = PROD;

PROMPT --- [1/5] additive columns on the shared employee master ---

DECLARE
  PROCEDURE add_col(p_table VARCHAR2, p_col VARCHAR2, p_ddl VARCHAR2) IS l_n NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_n FROM all_tab_columns
     WHERE owner='PROD' AND table_name=UPPER(p_table) AND column_name=UPPER(p_col);
    IF l_n=0 THEN EXECUTE IMMEDIATE 'ALTER TABLE '||p_table||' ADD ('||p_ddl||')'; END IF;
  END;
BEGIN
  -- employee_type: lookup EMPLOYEE_TYPE (INTERNAL / OUTSOURCE) - lookup-first, no CHECK
  add_col('DCT_EMPLOYEES','EMPLOYEE_TYPE','employee_type VARCHAR2(20) DEFAULT ''INTERNAL'' NOT NULL');
  -- cross-reference for outsourced staff that also exist in Fusion HCM (unique when set)
  add_col('DCT_EMPLOYEES','FUSION_PERSON_NUMBER','fusion_person_number VARCHAR2(30)');
END;
/

DECLARE
  l_n NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_n FROM all_indexes
   WHERE owner='PROD' AND index_name='UX_DCT_EMP_FUSION_PN';
  IF l_n=0 THEN
    -- an all-NULL key is not indexed, so a plain unique index = unique-when-set
    EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ux_dct_emp_fusion_pn ON dct_employees(fusion_person_number)';
  END IF;
END;
/

PROMPT --- [2/5] new tables ---

DECLARE
  PROCEDURE mk(p_name VARCHAR2,p_sql CLOB) IS l_n NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_n FROM all_tables WHERE owner='PROD' AND table_name=UPPER(p_name);
    IF l_n=0 THEN EXECUTE IMMEDIATE p_sql; END IF;
  END;
BEGIN
  mk('DCT_PAY_ASSIGNMENT', q'[
    CREATE TABLE dct_pay_assignment(
      assignment_id     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      person_id         NUMBER NOT NULL REFERENCES dct_employees(person_id),
      company_id        NUMBER NOT NULL REFERENCES dct_pay_company(company_id),
      contract_id       NUMBER REFERENCES dct_pay_contract(contract_id),
      bu_code           VARCHAR2(20),
      org_id            NUMBER REFERENCES dct_organizations(org_id),
      job_id            NUMBER REFERENCES hr_jobs(job_id),
      grade_code        VARCHAR2(20) REFERENCES dct_employee_grades(grade_code),
      position_id       NUMBER REFERENCES hr_positions(position_id),
      location_id       NUMBER REFERENCES hr_locations(location_id),
      manager_person_id NUMBER REFERENCES dct_employees(person_id),
      people_group      VARCHAR2(30),
      assignment_type   VARCHAR2(20) DEFAULT 'PRIMARY' NOT NULL,
      status            VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,
      effective_from    DATE NOT NULL,
      effective_to      DATE,
      payroll_code      VARCHAR2(40),
      notes             VARCHAR2(1000),
      row_version       NUMBER DEFAULT 1 NOT NULL,
      created_by        VARCHAR2(100),
      created_at        TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
      updated_by        VARCHAR2(100),
      updated_at        TIMESTAMP,
      CHECK(effective_to IS NULL OR effective_to>=effective_from))]');

  mk('DCT_PAY_EMP_BANK', q'[
    CREATE TABLE dct_pay_emp_bank(
      emp_bank_id     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      person_id       NUMBER NOT NULL REFERENCES dct_employees(person_id),
      bank_name       VARCHAR2(200) NOT NULL,
      iban            VARCHAR2(50),
      account_number  VARCHAR2(60),
      branch_name     VARCHAR2(200),
      currency_code   VARCHAR2(3) DEFAULT 'AED' NOT NULL,
      is_primary      VARCHAR2(1) DEFAULT 'N' NOT NULL CHECK(is_primary IN('Y','N')),
      effective_from  DATE DEFAULT TRUNC(SYSDATE) NOT NULL,
      effective_to    DATE,
      is_active       VARCHAR2(1) DEFAULT 'Y' NOT NULL CHECK(is_active IN('Y','N')),
      row_version     NUMBER DEFAULT 1 NOT NULL,
      created_by      VARCHAR2(100),
      created_at      TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
      updated_by      VARCHAR2(100),
      updated_at      TIMESTAMP,
      CHECK(effective_to IS NULL OR effective_to>=effective_from))]');

  mk('DCT_PAY_EMP_EVENT', q'[
    CREATE TABLE dct_pay_emp_event(
      event_id           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      person_id          NUMBER NOT NULL REFERENCES dct_employees(person_id),
      event_type         VARCHAR2(20) NOT NULL,
      effective_date     DATE NOT NULL,
      reason_code        VARCHAR2(30),
      from_assignment_id NUMBER REFERENCES dct_pay_assignment(assignment_id),
      to_assignment_id   NUMBER REFERENCES dct_pay_assignment(assignment_id),
      notes              VARCHAR2(1000),
      created_by         VARCHAR2(100),
      created_at         TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL)]');
END;
/

PROMPT --- [3/5] indexes ---

DECLARE
  PROCEDURE mkix(p_name VARCHAR2,p_sql VARCHAR2) IS l_n NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_n FROM all_indexes WHERE owner='PROD' AND index_name=UPPER(p_name);
    IF l_n=0 THEN EXECUTE IMMEDIATE p_sql; END IF;
  END;
BEGIN
  mkix('IX_DCT_PAYA_PERSON', 'CREATE INDEX ix_dct_paya_person  ON dct_pay_assignment(person_id)');
  mkix('IX_DCT_PAYA_COMPANY','CREATE INDEX ix_dct_paya_company ON dct_pay_assignment(company_id)');
  mkix('IX_DCT_PAYEB_PERSON','CREATE INDEX ix_dct_payeb_person ON dct_pay_emp_bank(person_id)');
  mkix('IX_DCT_PAYEV_PERSON','CREATE INDEX ix_dct_payev_person ON dct_pay_emp_event(person_id)');
END;
/

PROMPT --- [4/5] table remarks ---

COMMENT ON TABLE prod.dct_pay_assignment IS 'Outsource Payroll (App 215) Phase 2: effective-dated employee assignments to outsource companies; one ACTIVE PRIMARY per person per window (package-enforced); attributes FK the shared DCT/HR masters; payroll_code is a Phase 3 placeholder.';
COMMENT ON TABLE prod.dct_pay_emp_bank IS 'Outsource Payroll (App 215) Phase 2: employee bank accounts; writes restricted to PAY_PAYROLL_ENTRY / PAY_ADMIN; one is_primary per person (package-enforced).';
COMMENT ON TABLE prod.dct_pay_emp_event IS 'Outsource Payroll (App 215) Phase 2: immutable lifecycle trail (HIRE/TRANSFER/SUSPEND/RESUME/TERMINATE/REHIRE); every lifecycle mutation writes exactly one row.';
COMMENT ON COLUMN prod.dct_employees.employee_type IS 'Lookup EMPLOYEE_TYPE: INTERNAL (default) / OUTSOURCE (paid through an outsource company - App 215).';
COMMENT ON COLUMN prod.dct_employees.fusion_person_number IS 'Fusion HCM person number cross-reference; some outsourced staff also have a Fusion HR record. Unique when set.';

PROMPT --- [5/5] recompile what the ALTER just invalidated ---

DECLARE
  v_before NUMBER;
  v_after  NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_before FROM all_objects
   WHERE owner='PROD' AND status='INVALID';

  FOR o IN (SELECT object_name, object_type FROM all_objects
             WHERE owner='PROD' AND status='INVALID'
             ORDER BY DECODE(object_type,'VIEW',1,2), object_name)
  LOOP
    BEGIN
      IF o.object_type = 'VIEW' THEN
        EXECUTE IMMEDIATE 'ALTER VIEW prod.'||o.object_name||' COMPILE';
      ELSIF o.object_type = 'PACKAGE BODY' THEN
        EXECUTE IMMEDIATE 'ALTER PACKAGE prod.'||o.object_name||' COMPILE BODY';
      ELSIF o.object_type IN ('PACKAGE','PROCEDURE','FUNCTION','TRIGGER') THEN
        EXECUTE IMMEDIATE 'ALTER '||o.object_type||' prod.'||o.object_name||' COMPILE';
      END IF;
    EXCEPTION WHEN OTHERS THEN NULL;
    END;
  END LOOP;

  SELECT COUNT(*) INTO v_after FROM all_objects
   WHERE owner='PROD' AND status='INVALID';
  DBMS_OUTPUT.put_line('invalid before='||v_before||' after='||v_after);
END;
/

PROMPT --- done: PAY Phase 2 DDL ---
