-- =============================================================================
-- Outsource Payroll Module (App 215) -- Package -- Phase 2 Workforce
-- File    : 11_pay_phase2_pkg.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp (own invocation; CRLF)
-- Notes   : DCT_PAY_EMP_PKG -- outsourced employees on the shared employee
--           master: auto numbering, dedup, effective-dated assignments with
--           one ACTIVE PRIMARY per person per window, lifecycle events,
--           role-gated bank details, employee documents with expiry, Excel
--           full-upsert, and the daily document-expiry sweep + job.
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

CREATE OR REPLACE PACKAGE prod.dct_pay_emp_pkg AS

    FUNCTION  can_hr      (p_user VARCHAR2) RETURN BOOLEAN;
    FUNCTION  can_payroll (p_user VARCHAR2) RETURN BOOLEAN;
    PROCEDURE assert_hr      (p_user VARCHAR2);
    PROCEDURE assert_payroll (p_user VARCHAR2);

    FUNCTION next_emp_number RETURN VARCHAR2;

    PROCEDURE save_employee (
        p_user             IN VARCHAR2,
        p_person_id        IN NUMBER,
        p_first_name_en    IN VARCHAR2,
        p_last_name_en     IN VARCHAR2,
        p_first_name_ar    IN VARCHAR2,
        p_last_name_ar     IN VARCHAR2,
        p_date_of_birth    IN DATE,
        p_gender           IN VARCHAR2,
        p_nationality_code IN VARCHAR2,
        p_emirates_id      IN VARCHAR2,
        p_passport_number  IN VARCHAR2,
        p_email            IN VARCHAR2,
        p_mobile           IN VARCHAR2,
        p_fusion_pn        IN VARCHAR2,
        p_hire_date        IN DATE,
        o_person_id        OUT NUMBER,
        o_emp_number       OUT VARCHAR2);

    PROCEDURE save_assignment (
        p_user              IN VARCHAR2,
        p_assignment_id     IN NUMBER,
        p_person_id         IN NUMBER,
        p_company_id        IN NUMBER,
        p_contract_id       IN NUMBER,
        p_bu_code           IN VARCHAR2,
        p_org_id            IN NUMBER,
        p_job_id            IN NUMBER,
        p_grade_code        IN VARCHAR2,
        p_position_id       IN NUMBER,
        p_location_id       IN NUMBER,
        p_manager_person_id IN NUMBER,
        p_people_group      IN VARCHAR2,
        p_assignment_type   IN VARCHAR2,
        p_status            IN VARCHAR2,
        p_effective_from    IN DATE,
        p_effective_to      IN DATE,
        p_notes             IN VARCHAR2,
        o_assignment_id     OUT NUMBER,
        -- Phase 2.1 enrichment (db/13): real payroll-sheet attributes
        p_company_ref       IN VARCHAR2 DEFAULT NULL,
        p_job_title         IN VARCHAR2 DEFAULT NULL,
        p_sector_name       IN VARCHAR2 DEFAULT NULL,
        p_department_name   IN VARCHAR2 DEFAULT NULL,
        p_cost_center       IN VARCHAR2 DEFAULT NULL,
        p_basic_salary      IN NUMBER   DEFAULT NULL,
        p_allowance_amount  IN NUMBER   DEFAULT NULL,
        p_gross_salary      IN NUMBER   DEFAULT NULL);

    PROCEDURE lifecycle (
        p_user              IN VARCHAR2,
        p_person_id         IN NUMBER,
        p_action            IN VARCHAR2,
        p_effective_date    IN DATE,
        p_reason            IN VARCHAR2,
        p_notes             IN VARCHAR2,
        p_company_id        IN NUMBER,
        p_contract_id       IN NUMBER,
        p_bu_code           IN VARCHAR2,
        p_org_id            IN NUMBER,
        p_job_id            IN NUMBER,
        p_grade_code        IN VARCHAR2,
        p_position_id       IN NUMBER,
        p_location_id       IN NUMBER,
        p_manager_person_id IN NUMBER,
        p_people_group      IN VARCHAR2,
        o_event_id          OUT NUMBER);

    PROCEDURE save_bank (
        p_user           IN VARCHAR2,
        p_emp_bank_id    IN NUMBER,
        p_person_id      IN NUMBER,
        p_bank_name      IN VARCHAR2,
        p_iban           IN VARCHAR2,
        p_account_number IN VARCHAR2,
        p_branch_name    IN VARCHAR2,
        p_currency_code  IN VARCHAR2,
        p_is_primary     IN VARCHAR2,
        p_effective_from IN DATE,
        p_effective_to   IN DATE,
        p_is_active      IN VARCHAR2,
        o_emp_bank_id    OUT NUMBER);

    FUNCTION add_emp_doc (
        p_user          IN VARCHAR2,
        p_user_id       IN NUMBER,
        p_person_id     IN NUMBER,
        p_doc_type_code IN VARCHAR2,
        p_file_name     IN VARCHAR2,
        p_mime          IN VARCHAR2,
        p_expiry_date   IN DATE,
        p_blob          IN BLOB) RETURN NUMBER;

    PROCEDURE bulk_upsert (
        p_user   IN VARCHAR2,
        p_json   IN CLOB,
        o_result OUT CLOB);

    PROCEDURE sweep_expiring_docs;

END dct_pay_emp_pkg;
/

SHOW ERRORS PACKAGE prod.dct_pay_emp_pkg

CREATE OR REPLACE PACKAGE BODY prod.dct_pay_emp_pkg AS

    -- ------------------------------------------------------------------ auth
    FUNCTION can_hr (p_user VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        RETURN prod.dct_auth.has_role(p_user, 'PAY_HR_ENTRY')
            OR prod.dct_auth.has_role(p_user, 'PAY_ADMIN')
            OR prod.dct_auth.has_role(p_user, 'SYS_ADMIN');
    END can_hr;

    FUNCTION can_payroll (p_user VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        RETURN prod.dct_auth.has_role(p_user, 'PAY_PAYROLL_ENTRY')
            OR prod.dct_auth.has_role(p_user, 'PAY_ADMIN')
            OR prod.dct_auth.has_role(p_user, 'SYS_ADMIN');
    END can_payroll;

    PROCEDURE assert_hr (p_user VARCHAR2) IS
    BEGIN
        IF p_user IS NULL THEN
            RAISE_APPLICATION_ERROR(-20401, 'Unauthorized');
        END IF;
        IF NOT can_hr(p_user) THEN
            RAISE_APPLICATION_ERROR(-20403, 'PAY_HR_ENTRY or PAY_ADMIN role is required for this action');
        END IF;
    END assert_hr;

    PROCEDURE assert_payroll (p_user VARCHAR2) IS
    BEGIN
        IF p_user IS NULL THEN
            RAISE_APPLICATION_ERROR(-20401, 'Unauthorized');
        END IF;
        IF NOT can_payroll(p_user) THEN
            RAISE_APPLICATION_ERROR(-20403, 'PAY_PAYROLL_ENTRY or PAY_ADMIN role is required for this action');
        END IF;
    END assert_payroll;

    PROCEDURE require (p_ok BOOLEAN, p_msg VARCHAR2) IS
    BEGIN
        IF NOT p_ok THEN
            RAISE_APPLICATION_ERROR(-20001, p_msg);
        END IF;
    END require;

    -- ------------------------------------------------------------- numbering
    FUNCTION next_emp_number RETURN VARCHAR2 IS
        l_prefix VARCHAR2(20) := 'OS-';
        l_no     VARCHAR2(50);
        l_dup    NUMBER;
    BEGIN
        BEGIN
            SELECT ms.setting_value INTO l_prefix
            FROM prod.dct_module_settings ms
            JOIN prod.dct_modules m ON m.module_id = ms.module_id
            WHERE m.module_code = 'PAY' AND ms.setting_key = 'EMP_NUMBER_PREFIX';
        EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
        END;
        FOR i IN 1 .. 1000 LOOP
            l_no := l_prefix || LPAD(TO_CHAR(prod.dct_pay_emp_num_seq.NEXTVAL), 5, '0');
            SELECT COUNT(*) INTO l_dup FROM prod.dct_employees WHERE employee_number = l_no;
            EXIT WHEN l_dup = 0;
        END LOOP;
        RETURN l_no;
    END next_emp_number;

    -- ------------------------------------------------------- lifecycle event
    FUNCTION write_event (
        p_user      VARCHAR2,
        p_person_id NUMBER,
        p_type      VARCHAR2,
        p_eff       DATE,
        p_reason    VARCHAR2,
        p_notes     VARCHAR2,
        p_from_asg  NUMBER,
        p_to_asg    NUMBER) RETURN NUMBER IS
        l_id NUMBER;
    BEGIN
        INSERT INTO prod.dct_pay_emp_event
               (person_id, event_type, effective_date, reason_code,
                from_assignment_id, to_assignment_id, notes, created_by)
        VALUES (p_person_id, p_type, TRUNC(p_eff), p_reason,
                p_from_asg, p_to_asg, p_notes, p_user)
        RETURNING event_id INTO l_id;
        RETURN l_id;
    END write_event;

    -- ---------------------------------------------------------------- person
    PROCEDURE save_employee (
        p_user             IN VARCHAR2,
        p_person_id        IN NUMBER,
        p_first_name_en    IN VARCHAR2,
        p_last_name_en     IN VARCHAR2,
        p_first_name_ar    IN VARCHAR2,
        p_last_name_ar     IN VARCHAR2,
        p_date_of_birth    IN DATE,
        p_gender           IN VARCHAR2,
        p_nationality_code IN VARCHAR2,
        p_emirates_id      IN VARCHAR2,
        p_passport_number  IN VARCHAR2,
        p_email            IN VARCHAR2,
        p_mobile           IN VARCHAR2,
        p_fusion_pn        IN VARCHAR2,
        p_hire_date        IN DATE,
        o_person_id        OUT NUMBER,
        o_emp_number       OUT VARCHAR2) IS
        l_dup   NUMBER;
        l_type  VARCHAR2(20);
        l_evt   NUMBER;
    BEGIN
        assert_hr(p_user);
        require(TRIM(p_first_name_en) IS NOT NULL, 'First name (English) is required');
        require(TRIM(p_last_name_en)  IS NOT NULL, 'Last name (English) is required');
        require(TRIM(p_email) IS NOT NULL, 'Email is required for every employee');
        require(INSTR(p_email, '@') > 1, 'Email address is not valid: ' || p_email);
        require(p_gender IS NULL OR p_gender IN ('M','F'), 'Gender must be M or F');

        SELECT COUNT(*) INTO l_dup FROM prod.dct_employees
         WHERE UPPER(email) = UPPER(TRIM(p_email))
           AND (p_person_id IS NULL OR person_id != p_person_id);
        require(l_dup = 0, 'Email already belongs to another employee: ' || p_email);

        IF TRIM(p_emirates_id) IS NOT NULL THEN
            SELECT COUNT(*) INTO l_dup FROM prod.dct_employees
             WHERE UPPER(REPLACE(national_id,'-','')) = UPPER(REPLACE(TRIM(p_emirates_id),'-',''))
               AND (p_person_id IS NULL OR person_id != p_person_id);
            require(l_dup = 0, 'Emirates ID already belongs to another employee: ' || p_emirates_id);
        END IF;

        IF TRIM(p_passport_number) IS NOT NULL THEN
            SELECT COUNT(*) INTO l_dup FROM prod.dct_employees
             WHERE UPPER(passport_number) = UPPER(TRIM(p_passport_number))
               AND (p_person_id IS NULL OR person_id != p_person_id);
            require(l_dup = 0, 'Passport number already belongs to another employee: ' || p_passport_number);
        END IF;

        IF TRIM(p_fusion_pn) IS NOT NULL THEN
            SELECT COUNT(*) INTO l_dup FROM prod.dct_employees
             WHERE fusion_person_number = TRIM(p_fusion_pn)
               AND (p_person_id IS NULL OR person_id != p_person_id);
            require(l_dup = 0, 'Fusion person number already belongs to another employee: ' || p_fusion_pn);
        END IF;

        IF p_person_id IS NULL THEN
            o_emp_number := next_emp_number();
            -- full_name_en is a VIRTUAL column (first || ' ' || last) - never insert it
            INSERT INTO prod.dct_employees
                   (employee_number, employee_type, fusion_person_number,
                    first_name_en, last_name_en,
                    first_name_ar, last_name_ar, full_name_ar,
                    date_of_birth, gender, nationality_code,
                    national_id, passport_number, email, mobile,
                    hire_date, is_active, sync_source, created_by, updated_by,
                    created_at, updated_at)
            VALUES (o_emp_number, 'OUTSOURCE', TRIM(p_fusion_pn),
                    TRIM(p_first_name_en), TRIM(p_last_name_en),
                    p_first_name_ar, p_last_name_ar,
                    CASE WHEN p_first_name_ar IS NOT NULL AND p_last_name_ar IS NOT NULL
                         THEN TRIM(p_first_name_ar) || ' ' || TRIM(p_last_name_ar) END,
                    p_date_of_birth, p_gender, p_nationality_code,
                    TRIM(p_emirates_id), TRIM(p_passport_number), TRIM(p_email), p_mobile,
                    NVL(p_hire_date, TRUNC(SYSDATE)), 'Y', 'PAY', p_user, p_user,
                    SYSTIMESTAMP, SYSTIMESTAMP)
            RETURNING person_id INTO o_person_id;

            l_evt := write_event(p_user, o_person_id, 'HIRE',
                                 NVL(p_hire_date, TRUNC(SYSDATE)), 'NEW_HIRE', NULL, NULL, NULL);
        ELSE
            SELECT employee_type INTO l_type FROM prod.dct_employees WHERE person_id = p_person_id;
            require(l_type = 'OUTSOURCE', 'Only outsourced employees can be edited here (person ' || p_person_id || ' is ' || l_type || ')');

            UPDATE prod.dct_employees
               SET first_name_en        = TRIM(p_first_name_en),
                   last_name_en         = TRIM(p_last_name_en),
                   first_name_ar        = p_first_name_ar,
                   last_name_ar         = p_last_name_ar,
                   full_name_ar         = CASE WHEN p_first_name_ar IS NOT NULL AND p_last_name_ar IS NOT NULL
                                               THEN TRIM(p_first_name_ar) || ' ' || TRIM(p_last_name_ar) END,
                   date_of_birth        = p_date_of_birth,
                   gender               = p_gender,
                   nationality_code     = p_nationality_code,
                   national_id          = TRIM(p_emirates_id),
                   passport_number      = TRIM(p_passport_number),
                   email                = TRIM(p_email),
                   mobile               = p_mobile,
                   fusion_person_number = TRIM(p_fusion_pn),
                   hire_date            = NVL(p_hire_date, hire_date),
                   updated_by           = p_user,
                   updated_at           = SYSTIMESTAMP
             WHERE person_id = p_person_id;
            require(SQL%ROWCOUNT = 1, 'Employee not found: ' || p_person_id);
            o_person_id := p_person_id;
            SELECT employee_number INTO o_emp_number FROM prod.dct_employees WHERE person_id = p_person_id;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20404, 'Employee not found: ' || p_person_id);
    END save_employee;

    -- ------------------------------------------------- salary entry seeding
    -- Seeds the missing BASIC + ALLOWANCE (or lump GROSS_SALARY) element
    -- entries when a PRIMARY ACTIVE assignment carries salary figures, so a
    -- new hire calculates without manual setup. An employee who already has
    -- an active entry for the element is left untouched - salary changes are
    -- effective-dated on the employee Salary tab (Phase 3 /pay/entries).
    PROCEDURE ensure_salary_entries (
        p_user      IN VARCHAR2,
        p_person_id IN NUMBER,
        p_asg_id    IN NUMBER,
        p_basic     IN NUMBER,
        p_allow     IN NUMBER,
        p_gross     IN NUMBER,
        p_from      IN DATE) IS
        PROCEDURE ensure_one (p_code VARCHAR2, p_amount NUMBER) IS
            l_el NUMBER;
            l_n  NUMBER;
        BEGIN
            IF NVL(p_amount, 0) <= 0 THEN RETURN; END IF;
            BEGIN
                SELECT element_id INTO l_el FROM prod.dct_pay_element
                 WHERE element_code = p_code AND is_active = 'Y';
            EXCEPTION WHEN NO_DATA_FOUND THEN RETURN;
            END;
            SELECT COUNT(*) INTO l_n FROM prod.dct_pay_element_entry
             WHERE element_id = l_el AND person_id = p_person_id AND is_active = 'Y';
            IF l_n > 0 THEN RETURN; END IF;
            INSERT INTO prod.dct_pay_element_entry
                   (element_id, person_id, assignment_id, entry_type, amount,
                    effective_from, notes, created_by, updated_by)
            VALUES (l_el, p_person_id, p_asg_id, 'RECURRING', p_amount,
                    p_from, 'Auto-created from assignment salary figures', p_user, p_user);
        END;
    BEGIN
        IF NVL(p_basic, 0) > 0 THEN
            ensure_one('BASIC', p_basic);
            ensure_one('ALLOWANCE', p_allow);
        ELSIF NVL(p_gross, 0) > 0 THEN
            ensure_one('GROSS_SALARY', p_gross);
        END IF;
    END ensure_salary_entries;

    -- ------------------------------------------------------------ assignment
    PROCEDURE save_assignment (
        p_user              IN VARCHAR2,
        p_assignment_id     IN NUMBER,
        p_person_id         IN NUMBER,
        p_company_id        IN NUMBER,
        p_contract_id       IN NUMBER,
        p_bu_code           IN VARCHAR2,
        p_org_id            IN NUMBER,
        p_job_id            IN NUMBER,
        p_grade_code        IN VARCHAR2,
        p_position_id       IN NUMBER,
        p_location_id       IN NUMBER,
        p_manager_person_id IN NUMBER,
        p_people_group      IN VARCHAR2,
        p_assignment_type   IN VARCHAR2,
        p_status            IN VARCHAR2,
        p_effective_from    IN DATE,
        p_effective_to      IN DATE,
        p_notes             IN VARCHAR2,
        o_assignment_id     OUT NUMBER,
        p_company_ref       IN VARCHAR2 DEFAULT NULL,
        p_job_title         IN VARCHAR2 DEFAULT NULL,
        p_sector_name       IN VARCHAR2 DEFAULT NULL,
        p_department_name   IN VARCHAR2 DEFAULT NULL,
        p_cost_center       IN VARCHAR2 DEFAULT NULL,
        p_basic_salary      IN NUMBER   DEFAULT NULL,
        p_allowance_amount  IN NUMBER   DEFAULT NULL,
        p_gross_salary      IN NUMBER   DEFAULT NULL) IS
        l_type   VARCHAR2(20) := NVL(p_assignment_type, 'PRIMARY');
        l_status VARCHAR2(20) := NVL(p_status, 'ACTIVE');
        l_from   DATE := TRUNC(NVL(p_effective_from, SYSDATE));
        l_to     DATE := TRUNC(p_effective_to);
        l_n      NUMBER;
        l_etype  VARCHAR2(20);
    BEGIN
        assert_hr(p_user);
        require(p_person_id IS NOT NULL, 'Employee is required');
        require(p_company_id IS NOT NULL, 'Outsource company is required');
        require(l_to IS NULL OR l_to >= l_from, 'Effective-to date must be on or after effective-from');

        prod.dct_lookup_pkg.validate_lookup('PAY_ASSIGNMENT_TYPE', l_type);
        prod.dct_lookup_pkg.validate_lookup('PAY_ASSIGNMENT_STATUS', l_status);
        IF p_bu_code IS NOT NULL THEN
            prod.dct_lookup_pkg.validate_lookup('PAY_BU', p_bu_code);
        END IF;
        IF p_people_group IS NOT NULL THEN
            prod.dct_lookup_pkg.validate_lookup('PAY_PEOPLE_GROUP', p_people_group);
        END IF;

        BEGIN
            SELECT employee_type INTO l_etype FROM prod.dct_employees WHERE person_id = p_person_id;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20404, 'Employee not found: ' || p_person_id);
        END;
        require(l_etype = 'OUTSOURCE', 'Assignments can only be created for outsourced employees');

        SELECT COUNT(*) INTO l_n FROM prod.dct_pay_company
         WHERE company_id = p_company_id AND is_active = 'Y';
        require(l_n = 1, 'Outsource company not found or inactive: ' || p_company_id);

        IF p_contract_id IS NOT NULL THEN
            SELECT COUNT(*) INTO l_n FROM prod.dct_pay_contract
             WHERE contract_id = p_contract_id AND company_id = p_company_id;
            require(l_n = 1, 'Contract ' || p_contract_id || ' does not belong to company ' || p_company_id);
        END IF;
        IF p_org_id IS NOT NULL THEN
            SELECT COUNT(*) INTO l_n FROM prod.dct_organizations WHERE org_id = p_org_id;
            require(l_n = 1, 'Department not found: ' || p_org_id);
        END IF;
        IF p_job_id IS NOT NULL THEN
            SELECT COUNT(*) INTO l_n FROM prod.hr_jobs WHERE job_id = p_job_id;
            require(l_n = 1, 'Job not found: ' || p_job_id);
        END IF;
        IF p_grade_code IS NOT NULL THEN
            SELECT COUNT(*) INTO l_n FROM prod.dct_employee_grades WHERE grade_code = p_grade_code;
            require(l_n = 1, 'Grade not found: ' || p_grade_code);
        END IF;
        IF p_position_id IS NOT NULL THEN
            SELECT COUNT(*) INTO l_n FROM prod.hr_positions WHERE position_id = p_position_id;
            require(l_n = 1, 'Position not found: ' || p_position_id);
        END IF;
        IF p_location_id IS NOT NULL THEN
            SELECT COUNT(*) INTO l_n FROM prod.hr_locations WHERE location_id = p_location_id;
            require(l_n = 1, 'Location not found: ' || p_location_id);
        END IF;
        IF p_manager_person_id IS NOT NULL THEN
            SELECT COUNT(*) INTO l_n FROM prod.dct_employees WHERE person_id = p_manager_person_id;
            require(l_n = 1, 'Manager not found: ' || p_manager_person_id);
        END IF;

        -- one PRIMARY assignment (not ENDED) per person per date window
        IF l_type = 'PRIMARY' AND l_status != 'ENDED' THEN
            SELECT COUNT(*) INTO l_n FROM prod.dct_pay_assignment
             WHERE person_id = p_person_id
               AND assignment_type = 'PRIMARY'
               AND status != 'ENDED'
               AND (p_assignment_id IS NULL OR assignment_id != p_assignment_id)
               AND NVL(effective_to, DATE '9999-12-31') >= l_from
               AND effective_from <= NVL(l_to, DATE '9999-12-31');
            require(l_n = 0, 'The employee already has a primary assignment in this period; end it first or use Transfer');
        END IF;

        IF p_assignment_id IS NULL THEN
            INSERT INTO prod.dct_pay_assignment
                   (person_id, company_id, contract_id, bu_code, org_id, job_id, grade_code,
                    position_id, location_id, manager_person_id, people_group,
                    assignment_type, status, effective_from, effective_to, notes,
                    company_ref, job_title, sector_name, department_name, cost_center_code,
                    basic_salary, allowance_amount, gross_salary,
                    created_by, updated_by)
            VALUES (p_person_id, p_company_id, p_contract_id, p_bu_code, p_org_id, p_job_id, p_grade_code,
                    p_position_id, p_location_id, p_manager_person_id, p_people_group,
                    l_type, l_status, l_from, l_to, p_notes,
                    p_company_ref, p_job_title, p_sector_name, p_department_name, p_cost_center,
                    p_basic_salary, p_allowance_amount, p_gross_salary,
                    p_user, p_user)
            RETURNING assignment_id INTO o_assignment_id;
        ELSE
            UPDATE prod.dct_pay_assignment
               SET company_id        = p_company_id,
                   contract_id       = p_contract_id,
                   bu_code           = p_bu_code,
                   org_id            = p_org_id,
                   job_id            = p_job_id,
                   grade_code        = p_grade_code,
                   position_id       = p_position_id,
                   location_id       = p_location_id,
                   manager_person_id = p_manager_person_id,
                   people_group      = p_people_group,
                   assignment_type   = l_type,
                   status            = l_status,
                   effective_from    = l_from,
                   effective_to      = l_to,
                   notes             = p_notes,
                   company_ref       = p_company_ref,
                   job_title         = p_job_title,
                   sector_name       = p_sector_name,
                   department_name   = p_department_name,
                   cost_center_code  = p_cost_center,
                   basic_salary      = p_basic_salary,
                   allowance_amount  = p_allowance_amount,
                   gross_salary      = p_gross_salary,
                   row_version       = row_version + 1,
                   updated_by        = p_user,
                   updated_at        = SYSTIMESTAMP
             WHERE assignment_id = p_assignment_id;
            require(SQL%ROWCOUNT = 1, 'Assignment not found: ' || p_assignment_id);
            o_assignment_id := p_assignment_id;
        END IF;

        IF l_type = 'PRIMARY' AND l_status = 'ACTIVE' THEN
            ensure_salary_entries(p_user, p_person_id, o_assignment_id,
                                  p_basic_salary, p_allowance_amount, p_gross_salary, l_from);
        END IF;
    END save_assignment;

    -- ------------------------------------------------------------- lifecycle
    PROCEDURE lifecycle (
        p_user              IN VARCHAR2,
        p_person_id         IN NUMBER,
        p_action            IN VARCHAR2,
        p_effective_date    IN DATE,
        p_reason            IN VARCHAR2,
        p_notes             IN VARCHAR2,
        p_company_id        IN NUMBER,
        p_contract_id       IN NUMBER,
        p_bu_code           IN VARCHAR2,
        p_org_id            IN NUMBER,
        p_job_id            IN NUMBER,
        p_grade_code        IN VARCHAR2,
        p_position_id       IN NUMBER,
        p_location_id       IN NUMBER,
        p_manager_person_id IN NUMBER,
        p_people_group      IN VARCHAR2,
        o_event_id          OUT NUMBER) IS
        l_eff     DATE := TRUNC(NVL(p_effective_date, SYSDATE));
        l_cur     prod.dct_pay_assignment%ROWTYPE;
        l_has_cur BOOLEAN := FALSE;
        l_active  VARCHAR2(1);
        l_etype   VARCHAR2(20);
        l_new_asg NUMBER;
    BEGIN
        assert_hr(p_user);
        require(p_action IN ('TRANSFER','SUSPEND','RESUME','TERMINATE','REHIRE'),
                'Unsupported lifecycle action: ' || p_action);
        IF p_reason IS NOT NULL THEN
            prod.dct_lookup_pkg.validate_lookup('PAY_EVENT_REASON', p_reason);
        END IF;

        BEGIN
            SELECT is_active, employee_type INTO l_active, l_etype
            FROM prod.dct_employees WHERE person_id = p_person_id;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20404, 'Employee not found: ' || p_person_id);
        END;
        require(l_etype = 'OUTSOURCE', 'Lifecycle actions apply to outsourced employees only');

        BEGIN
            -- at most one open PRIMARY exists (save_assignment overlap guard)
            SELECT * INTO l_cur FROM prod.dct_pay_assignment
             WHERE person_id = p_person_id
               AND assignment_type = 'PRIMARY'
               AND status != 'ENDED'
               AND ROWNUM = 1;
            l_has_cur := TRUE;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            l_has_cur := FALSE;
        END;

        IF p_action = 'TRANSFER' THEN
            require(l_active = 'Y', 'Employee is not active');
            require(l_has_cur, 'No open primary assignment to transfer from');
            require(p_company_id IS NOT NULL, 'Target outsource company is required for a transfer');

            UPDATE prod.dct_pay_assignment
               SET status = 'ENDED',
                   effective_to = GREATEST(l_eff - 1, effective_from),
                   row_version = row_version + 1,
                   updated_by = p_user, updated_at = SYSTIMESTAMP
             WHERE assignment_id = l_cur.assignment_id;

            save_assignment(p_user, NULL, p_person_id,
                p_company_id,
                p_contract_id,
                NVL(p_bu_code,           l_cur.bu_code),
                NVL(p_org_id,            l_cur.org_id),
                NVL(p_job_id,            l_cur.job_id),
                NVL(p_grade_code,        l_cur.grade_code),
                NVL(p_position_id,       l_cur.position_id),
                NVL(p_location_id,       l_cur.location_id),
                NVL(p_manager_person_id, l_cur.manager_person_id),
                NVL(p_people_group,      l_cur.people_group),
                'PRIMARY', 'ACTIVE', l_eff, NULL, p_notes, l_new_asg,
                -- enrichment attrs travel with the person on a transfer
                p_company_ref      => NULL,   -- new company = new reference
                p_job_title        => l_cur.job_title,
                p_sector_name      => l_cur.sector_name,
                p_department_name  => l_cur.department_name,
                p_cost_center      => l_cur.cost_center_code,
                p_basic_salary     => l_cur.basic_salary,
                p_allowance_amount => l_cur.allowance_amount,
                p_gross_salary     => l_cur.gross_salary);

            o_event_id := write_event(p_user, p_person_id, 'TRANSFER', l_eff,
                                      NVL(p_reason,'CONTRACT_MOVE'), p_notes,
                                      l_cur.assignment_id, l_new_asg);

        ELSIF p_action = 'SUSPEND' THEN
            require(l_has_cur AND l_cur.status = 'ACTIVE', 'No active primary assignment to suspend');
            UPDATE prod.dct_pay_assignment
               SET status = 'SUSPENDED', row_version = row_version + 1,
                   updated_by = p_user, updated_at = SYSTIMESTAMP
             WHERE assignment_id = l_cur.assignment_id;
            o_event_id := write_event(p_user, p_person_id, 'SUSPEND', l_eff,
                                      p_reason, p_notes, l_cur.assignment_id, NULL);

        ELSIF p_action = 'RESUME' THEN
            require(l_has_cur AND l_cur.status = 'SUSPENDED', 'No suspended primary assignment to resume');
            UPDATE prod.dct_pay_assignment
               SET status = 'ACTIVE', row_version = row_version + 1,
                   updated_by = p_user, updated_at = SYSTIMESTAMP
             WHERE assignment_id = l_cur.assignment_id;
            o_event_id := write_event(p_user, p_person_id, 'RESUME', l_eff,
                                      p_reason, p_notes, l_cur.assignment_id, NULL);

        ELSIF p_action = 'TERMINATE' THEN
            require(l_active = 'Y', 'Employee is already inactive');
            UPDATE prod.dct_pay_assignment
               SET status = 'ENDED',
                   effective_to = GREATEST(l_eff, effective_from),
                   row_version = row_version + 1,
                   updated_by = p_user, updated_at = SYSTIMESTAMP
             WHERE person_id = p_person_id AND status != 'ENDED';
            UPDATE prod.dct_employees
               SET is_active = 'N', end_date = l_eff,
                   updated_by = p_user, updated_at = SYSTIMESTAMP
             WHERE person_id = p_person_id;
            o_event_id := write_event(p_user, p_person_id, 'TERMINATE', l_eff,
                                      p_reason, p_notes,
                                      CASE WHEN l_has_cur THEN l_cur.assignment_id END, NULL);

        ELSIF p_action = 'REHIRE' THEN
            require(l_active = 'N', 'Employee is already active');
            require(p_company_id IS NOT NULL, 'Outsource company is required for a rehire');
            UPDATE prod.dct_employees
               SET is_active = 'Y', end_date = NULL, hire_date = l_eff,
                   updated_by = p_user, updated_at = SYSTIMESTAMP
             WHERE person_id = p_person_id;

            save_assignment(p_user, NULL, p_person_id,
                p_company_id, p_contract_id, p_bu_code, p_org_id, p_job_id,
                p_grade_code, p_position_id, p_location_id, p_manager_person_id,
                p_people_group, 'PRIMARY', 'ACTIVE', l_eff, NULL, p_notes, l_new_asg);

            o_event_id := write_event(p_user, p_person_id, 'REHIRE', l_eff,
                                      NVL(p_reason,'RETURN'), p_notes, NULL, l_new_asg);
        END IF;
    END lifecycle;

    -- ------------------------------------------------------------------ bank
    PROCEDURE save_bank (
        p_user           IN VARCHAR2,
        p_emp_bank_id    IN NUMBER,
        p_person_id      IN NUMBER,
        p_bank_name      IN VARCHAR2,
        p_iban           IN VARCHAR2,
        p_account_number IN VARCHAR2,
        p_branch_name    IN VARCHAR2,
        p_currency_code  IN VARCHAR2,
        p_is_primary     IN VARCHAR2,
        p_effective_from IN DATE,
        p_effective_to   IN DATE,
        p_is_active      IN VARCHAR2,
        o_emp_bank_id    OUT NUMBER) IS
        l_n NUMBER;
    BEGIN
        assert_payroll(p_user);
        require(p_person_id IS NOT NULL, 'Employee is required');
        require(TRIM(p_bank_name) IS NOT NULL, 'Bank name is required');
        require(TRIM(p_iban) IS NOT NULL OR TRIM(p_account_number) IS NOT NULL,
                'IBAN or account number is required');

        SELECT COUNT(*) INTO l_n FROM prod.dct_employees WHERE person_id = p_person_id;
        require(l_n = 1, 'Employee not found: ' || p_person_id);

        IF NVL(p_is_primary, 'N') = 'Y' THEN
            UPDATE prod.dct_pay_emp_bank
               SET is_primary = 'N', updated_by = p_user, updated_at = SYSTIMESTAMP
             WHERE person_id = p_person_id AND is_primary = 'Y'
               AND (p_emp_bank_id IS NULL OR emp_bank_id != p_emp_bank_id);
        END IF;

        IF p_emp_bank_id IS NULL THEN
            INSERT INTO prod.dct_pay_emp_bank
                   (person_id, bank_name, iban, account_number, branch_name,
                    currency_code, is_primary, effective_from, effective_to, is_active,
                    created_by, updated_by)
            VALUES (p_person_id, TRIM(p_bank_name), UPPER(REPLACE(TRIM(p_iban),' ','')),
                    TRIM(p_account_number), p_branch_name,
                    NVL(p_currency_code,'AED'), NVL(p_is_primary,'N'),
                    TRUNC(NVL(p_effective_from, SYSDATE)), TRUNC(p_effective_to), NVL(p_is_active,'Y'),
                    p_user, p_user)
            RETURNING emp_bank_id INTO o_emp_bank_id;
        ELSE
            UPDATE prod.dct_pay_emp_bank
               SET bank_name      = TRIM(p_bank_name),
                   iban           = UPPER(REPLACE(TRIM(p_iban),' ','')),
                   account_number = TRIM(p_account_number),
                   branch_name    = p_branch_name,
                   currency_code  = NVL(p_currency_code,'AED'),
                   is_primary     = NVL(p_is_primary,'N'),
                   effective_from = TRUNC(NVL(p_effective_from, effective_from)),
                   effective_to   = TRUNC(p_effective_to),
                   is_active      = NVL(p_is_active,'Y'),
                   row_version    = row_version + 1,
                   updated_by     = p_user,
                   updated_at     = SYSTIMESTAMP
             WHERE emp_bank_id = p_emp_bank_id AND person_id = p_person_id;
            require(SQL%ROWCOUNT = 1, 'Bank record not found: ' || p_emp_bank_id);
            o_emp_bank_id := p_emp_bank_id;
        END IF;
    END save_bank;

    -- ------------------------------------------------------------- documents
    FUNCTION add_emp_doc (
        p_user          IN VARCHAR2,
        p_user_id       IN NUMBER,
        p_person_id     IN NUMBER,
        p_doc_type_code IN VARCHAR2,
        p_file_name     IN VARCHAR2,
        p_mime          IN VARCHAR2,
        p_expiry_date   IN DATE,
        p_blob          IN BLOB) RETURN NUMBER IS
        l_type_id NUMBER;
        l_doc_id  NUMBER;
        l_n       NUMBER;
    BEGIN
        IF p_user IS NULL THEN
            RAISE_APPLICATION_ERROR(-20401, 'Unauthorized');
        END IF;
        IF NOT (can_hr(p_user) OR can_payroll(p_user)) THEN
            RAISE_APPLICATION_ERROR(-20403, 'A PAY entry role is required to upload employee documents');
        END IF;
        require(TRIM(p_file_name) IS NOT NULL, 'file_name is required');

        SELECT COUNT(*) INTO l_n FROM prod.dct_employees
         WHERE person_id = p_person_id AND employee_type = 'OUTSOURCE';
        require(l_n = 1, 'Outsourced employee not found: ' || p_person_id);

        BEGIN
            SELECT doc_type_id INTO l_type_id
            FROM prod.dct_document_types
            WHERE doc_type_code = NVL(p_doc_type_code, 'PAY_DOCUMENT')
              AND INSTR('|' || applies_to_modules || '|', '|PAY|') > 0;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Document type is not available for PAY: ' || p_doc_type_code);
        END;

        INSERT INTO prod.dct_documents
               (source_module, source_type, source_id, reference_id, doc_type_id,
                file_name, mime_type, file_size_bytes, file_blob, expiry_date,
                status, created_by)
        VALUES ('PAY', 'PAY_EMPLOYEE', p_person_id, p_person_id, l_type_id,
                p_file_name, p_mime, DBMS_LOB.GETLENGTH(p_blob), p_blob, TRUNC(p_expiry_date),
                'ACTIVE', p_user_id)
        RETURNING doc_id INTO l_doc_id;
        RETURN l_doc_id;
    END add_emp_doc;

    -- ------------------------------------------------------------ bulk upsert
    PROCEDURE bulk_upsert (
        p_user   IN VARCHAR2,
        p_json   IN CLOB,
        o_result OUT CLOB) IS
        l_vals  apex_json.t_values;
        l_cnt   PLS_INTEGER;
        l_ok    PLS_INTEGER := 0;
        l_err   PLS_INTEGER := 0;

        FUNCTION jv (p_path VARCHAR2, p_i PLS_INTEGER) RETURN VARCHAR2 IS
        BEGIN
            RETURN TRIM(apex_json.get_varchar2(p_path => p_path, p0 => p_i, p_values => l_vals));
        END;

        FUNCTION pd (p_s VARCHAR2, p_what VARCHAR2) RETURN DATE IS
        BEGIN
            IF p_s IS NULL THEN RETURN NULL; END IF;
            BEGIN RETURN TO_DATE(p_s, 'YYYY-MM-DD'); EXCEPTION WHEN OTHERS THEN NULL; END;
            BEGIN RETURN TO_DATE(p_s, 'DD/MM/YYYY'); EXCEPTION WHEN OTHERS THEN NULL; END;
            BEGIN RETURN TO_DATE(p_s, 'DD-MM-YYYY'); EXCEPTION WHEN OTHERS THEN NULL; END;
            RAISE_APPLICATION_ERROR(-20001, p_what || ' is not a valid date (use YYYY-MM-DD): ' || p_s);
        END;

        FUNCTION pn (p_s VARCHAR2, p_what VARCHAR2) RETURN NUMBER IS
        BEGIN
            IF p_s IS NULL THEN RETURN NULL; END IF;
            RETURN TO_NUMBER(REPLACE(p_s, ',', ''));
        EXCEPTION WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, p_what || ' is not a valid number: ' || p_s);
        END;

        FUNCTION res_company (p_code VARCHAR2) RETURN NUMBER IS
            l_id NUMBER;
        BEGIN
            SELECT company_id INTO l_id FROM prod.dct_pay_company
             WHERE UPPER(company_code) = UPPER(p_code) AND is_active = 'Y';
            RETURN l_id;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Outsource company code not found: ' || p_code);
        END;

        -- LENIENT: an unmatched department still loads - the sheet name goes to
        -- department_name and org_id stays NULL (the org master is far smaller
        -- than the real payroll-sheet department list)
        FUNCTION res_org (p_v VARCHAR2) RETURN NUMBER IS
            l_id NUMBER;
        BEGIN
            SELECT MIN(org_id) INTO l_id FROM prod.dct_organizations
             WHERE is_active = 'Y'
               AND (UPPER(org_code) = UPPER(p_v) OR UPPER(org_name_en) = UPPER(p_v));
            RETURN l_id;
        END;

        FUNCTION res_job (p_v VARCHAR2) RETURN NUMBER IS
            l_id NUMBER;
        BEGIN
            SELECT MIN(job_id) INTO l_id FROM prod.hr_jobs
             WHERE is_active = 'Y'
               AND (UPPER(job_code) = UPPER(p_v) OR UPPER(job_name_en) = UPPER(p_v));
            IF l_id IS NULL THEN
                RAISE_APPLICATION_ERROR(-20001, 'Job not found: ' || p_v);
            END IF;
            RETURN l_id;
        END;

        FUNCTION res_position (p_v VARCHAR2) RETURN NUMBER IS
            l_id NUMBER;
        BEGIN
            SELECT MIN(position_id) INTO l_id FROM prod.hr_positions
             WHERE is_active = 'Y'
               AND (UPPER(position_code) = UPPER(p_v) OR UPPER(position_name_en) = UPPER(p_v));
            IF l_id IS NULL THEN
                RAISE_APPLICATION_ERROR(-20001, 'Position not found: ' || p_v);
            END IF;
            RETURN l_id;
        END;

        FUNCTION res_location (p_v VARCHAR2) RETURN NUMBER IS
            l_id NUMBER;
        BEGIN
            SELECT MIN(location_id) INTO l_id FROM prod.hr_locations
             WHERE is_active = 'Y'
               AND (UPPER(location_code) = UPPER(p_v) OR UPPER(location_name_en) = UPPER(p_v));
            IF l_id IS NULL THEN
                RAISE_APPLICATION_ERROR(-20001, 'Location not found: ' || p_v);
            END IF;
            RETURN l_id;
        END;

        -- LENIENT: the real sheets carry stray grade codes ('02', '21') - an
        -- unmatched grade loads the row with grade NULL instead of failing it
        FUNCTION res_grade (p_v VARCHAR2) RETURN VARCHAR2 IS
            l_n NUMBER;
        BEGIN
            SELECT COUNT(*) INTO l_n FROM prod.dct_employee_grades
             WHERE UPPER(grade_code) = UPPER(p_v);
            RETURN CASE WHEN l_n > 0 THEN UPPER(p_v) END;
        END;

        FUNCTION res_manager (p_v VARCHAR2) RETURN NUMBER IS
            l_id NUMBER;
        BEGIN
            SELECT person_id INTO l_id FROM prod.dct_employees
             WHERE UPPER(employee_number) = UPPER(p_v);
            RETURN l_id;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Manager employee number not found: ' || p_v);
        END;
    BEGIN
        assert_hr(p_user);
        apex_json.parse(l_vals, p_json);
        l_cnt := NVL(apex_json.get_count(p_path => 'rows', p_values => l_vals), 0);
        require(l_cnt >= 1, 'No rows supplied');
        require(l_cnt <= 500, 'A maximum of 500 rows per request is allowed (got ' || l_cnt || ')');

        apex_json.initialize_clob_output;
        apex_json.open_object;
        apex_json.open_array('results');

        FOR i IN 1 .. l_cnt LOOP
            DECLARE
                l_emp_no    VARCHAR2(50)  := jv('rows[%d].employeeNumber', i);
                l_fpn       VARCHAR2(30)  := jv('rows[%d].fusionPersonNumber', i);
                l_eid       VARCHAR2(50)  := jv('rows[%d].emiratesId', i);
                l_email     VARCHAR2(200) := jv('rows[%d].email', i);
                l_person_id NUMBER;
                l_new       BOOLEAN := FALSE;
                l_old       prod.dct_employees%ROWTYPE;
                l_out_pid   NUMBER;
                l_out_no    VARCHAR2(50);
                l_comp_code VARCHAR2(30);
                l_comp_id   NUMBER;
                l_asg       prod.dct_pay_assignment%ROWTYPE;
                l_has_asg   BOOLEAN := FALSE;
                l_asg_out   NUMBER;
                l_v         VARCHAR2(400);
            BEGIN
                SAVEPOINT bulk_row;

                -- match: employee number, then Fusion person number, then
                -- Emirates ID, then email
                IF l_emp_no IS NOT NULL THEN
                    BEGIN
                        SELECT person_id INTO l_person_id FROM prod.dct_employees
                         WHERE UPPER(employee_number) = UPPER(l_emp_no);
                    EXCEPTION WHEN NO_DATA_FOUND THEN
                        RAISE_APPLICATION_ERROR(-20001, 'Employee number not found: ' || l_emp_no);
                    END;
                END IF;
                IF l_person_id IS NULL AND l_fpn IS NOT NULL THEN
                    BEGIN
                        SELECT person_id INTO l_person_id FROM prod.dct_employees
                         WHERE fusion_person_number = l_fpn;
                    EXCEPTION WHEN NO_DATA_FOUND THEN l_person_id := NULL;
                    END;
                END IF;
                IF l_person_id IS NULL AND l_eid IS NOT NULL THEN
                    BEGIN
                        SELECT person_id INTO l_person_id FROM prod.dct_employees
                         WHERE UPPER(REPLACE(national_id,'-','')) = UPPER(REPLACE(l_eid,'-',''));
                    EXCEPTION WHEN NO_DATA_FOUND THEN l_person_id := NULL;
                    END;
                END IF;
                IF l_person_id IS NULL AND l_email IS NOT NULL THEN
                    BEGIN
                        SELECT person_id INTO l_person_id FROM prod.dct_employees
                         WHERE UPPER(email) = UPPER(l_email);
                    EXCEPTION WHEN NO_DATA_FOUND THEN l_person_id := NULL;
                    END;
                END IF;
                l_new := l_person_id IS NULL;

                IF NOT l_new THEN
                    SELECT * INTO l_old FROM prod.dct_employees WHERE person_id = l_person_id;
                    IF l_old.employee_type != 'OUTSOURCE' THEN
                        RAISE_APPLICATION_ERROR(-20001,
                            'Employee ' || l_old.employee_number || ' is not an outsourced employee');
                    END IF;
                END IF;

                -- blank cells keep the stored value on updates (full-upsert semantics)
                save_employee(
                    p_user             => p_user,
                    p_person_id        => l_person_id,
                    p_first_name_en    => NVL(jv('rows[%d].firstNameEn', i), CASE WHEN l_new THEN NULL ELSE l_old.first_name_en END),
                    p_last_name_en     => NVL(jv('rows[%d].lastNameEn', i),  CASE WHEN l_new THEN NULL ELSE l_old.last_name_en END),
                    p_first_name_ar    => NVL(jv('rows[%d].firstNameAr', i), CASE WHEN l_new THEN NULL ELSE l_old.first_name_ar END),
                    p_last_name_ar     => NVL(jv('rows[%d].lastNameAr', i),  CASE WHEN l_new THEN NULL ELSE l_old.last_name_ar END),
                    p_date_of_birth    => NVL(pd(jv('rows[%d].dateOfBirth', i), 'Date of birth'), CASE WHEN l_new THEN NULL ELSE l_old.date_of_birth END),
                    p_gender           => NVL(jv('rows[%d].gender', i), CASE WHEN l_new THEN NULL ELSE l_old.gender END),
                    p_nationality_code => NVL(jv('rows[%d].nationalityCode', i), CASE WHEN l_new THEN NULL ELSE l_old.nationality_code END),
                    p_emirates_id      => NVL(l_eid, CASE WHEN l_new THEN NULL ELSE l_old.national_id END),
                    p_passport_number  => NVL(jv('rows[%d].passportNumber', i), CASE WHEN l_new THEN NULL ELSE l_old.passport_number END),
                    p_email            => NVL(l_email, CASE WHEN l_new THEN NULL ELSE l_old.email END),
                    p_mobile           => NVL(jv('rows[%d].mobile', i), CASE WHEN l_new THEN NULL ELSE l_old.mobile END),
                    p_fusion_pn        => NVL(jv('rows[%d].fusionPersonNumber', i), CASE WHEN l_new THEN NULL ELSE l_old.fusion_person_number END),
                    p_hire_date        => NVL(pd(jv('rows[%d].hireDate', i), 'Hire date'), CASE WHEN l_new THEN NULL ELSE l_old.hire_date END),
                    o_person_id        => l_out_pid,
                    o_emp_number       => l_out_no);

                -- optional assignment leg
                l_comp_code := jv('rows[%d].companyCode', i);
                IF l_comp_code IS NOT NULL THEN
                    l_comp_id := res_company(l_comp_code);

                    BEGIN
                        SELECT * INTO l_asg FROM prod.dct_pay_assignment
                         WHERE person_id = l_out_pid
                           AND assignment_type = 'PRIMARY'
                           AND status != 'ENDED'
                           AND ROWNUM = 1;
                        l_has_asg := TRUE;
                    EXCEPTION WHEN NO_DATA_FOUND THEN l_has_asg := FALSE;
                    END;

                    IF l_has_asg AND l_asg.company_id != l_comp_id THEN
                        RAISE_APPLICATION_ERROR(-20001,
                            'Employee already has an open primary assignment with another company; use the Transfer action');
                    END IF;

                    save_assignment(
                        p_user              => p_user,
                        p_assignment_id     => CASE WHEN l_has_asg THEN l_asg.assignment_id END,
                        p_person_id         => l_out_pid,
                        p_company_id        => l_comp_id,
                        p_contract_id       => CASE WHEN l_has_asg THEN l_asg.contract_id END,
                        p_bu_code           => NVL(jv('rows[%d].buCode', i), CASE WHEN l_has_asg THEN l_asg.bu_code END),
                        p_org_id            => NVL(CASE WHEN jv('rows[%d].department', i) IS NOT NULL THEN res_org(jv('rows[%d].department', i)) END,
                                                   CASE WHEN l_has_asg THEN l_asg.org_id END),
                        p_job_id            => NVL(CASE WHEN jv('rows[%d].job', i) IS NOT NULL THEN res_job(jv('rows[%d].job', i)) END,
                                                   CASE WHEN l_has_asg THEN l_asg.job_id END),
                        p_grade_code        => NVL(CASE WHEN jv('rows[%d].gradeCode', i) IS NOT NULL THEN res_grade(jv('rows[%d].gradeCode', i)) END,
                                                   CASE WHEN l_has_asg THEN l_asg.grade_code END),
                        p_position_id       => NVL(CASE WHEN jv('rows[%d].position', i) IS NOT NULL THEN res_position(jv('rows[%d].position', i)) END,
                                                   CASE WHEN l_has_asg THEN l_asg.position_id END),
                        p_location_id       => NVL(CASE WHEN jv('rows[%d].location', i) IS NOT NULL THEN res_location(jv('rows[%d].location', i)) END,
                                                   CASE WHEN l_has_asg THEN l_asg.location_id END),
                        p_manager_person_id => NVL(CASE WHEN jv('rows[%d].managerEmployeeNumber', i) IS NOT NULL THEN res_manager(jv('rows[%d].managerEmployeeNumber', i)) END,
                                                   CASE WHEN l_has_asg THEN l_asg.manager_person_id END),
                        p_people_group      => NVL(jv('rows[%d].peopleGroup', i), CASE WHEN l_has_asg THEN l_asg.people_group END),
                        p_assignment_type   => 'PRIMARY',
                        p_status            => CASE WHEN l_has_asg THEN l_asg.status ELSE 'ACTIVE' END,
                        p_effective_from    => NVL(pd(jv('rows[%d].effectiveFrom', i), 'Effective from'),
                                                   CASE WHEN l_has_asg THEN l_asg.effective_from ELSE TRUNC(SYSDATE) END),
                        p_effective_to      => CASE WHEN l_has_asg THEN l_asg.effective_to END,
                        p_notes             => CASE WHEN l_has_asg THEN l_asg.notes END,
                        o_assignment_id     => l_asg_out,
                        p_company_ref       => NVL(jv('rows[%d].companyRef', i),  CASE WHEN l_has_asg THEN l_asg.company_ref END),
                        p_job_title         => NVL(jv('rows[%d].jobTitle', i),    CASE WHEN l_has_asg THEN l_asg.job_title END),
                        p_sector_name       => NVL(jv('rows[%d].sector', i),      CASE WHEN l_has_asg THEN l_asg.sector_name END),
                        p_department_name   => NVL(jv('rows[%d].department', i),
                                                   CASE WHEN l_has_asg THEN l_asg.department_name END),
                        p_cost_center       => NVL(jv('rows[%d].costCenter', i),  CASE WHEN l_has_asg THEN l_asg.cost_center_code END),
                        p_basic_salary      => NVL(pn(jv('rows[%d].basicSalary', i), 'Basic salary'),
                                                   CASE WHEN l_has_asg THEN l_asg.basic_salary END),
                        p_allowance_amount  => NVL(pn(jv('rows[%d].allowance', i), 'Allowance'),
                                                   CASE WHEN l_has_asg THEN l_asg.allowance_amount END),
                        p_gross_salary      => NVL(pn(jv('rows[%d].grossSalary', i), 'Gross salary'),
                                                   CASE WHEN l_has_asg THEN l_asg.gross_salary END));
                END IF;

                -- optional bank leg (payroll-entry writers only; others: ignored)
                IF can_payroll(p_user)
                   AND (jv('rows[%d].bankName', i) IS NOT NULL OR jv('rows[%d].iban', i) IS NOT NULL) THEN
                    DECLARE
                        l_bank  VARCHAR2(200) := jv('rows[%d].bankName', i);
                        l_iban  VARCHAR2(50)  := UPPER(REPLACE(jv('rows[%d].iban', i), ' ', ''));
                        l_acct  VARCHAR2(60)  := jv('rows[%d].bankAccountNo', i);
                        l_bid   NUMBER;
                        l_exist NUMBER;
                    BEGIN
                        SELECT MIN(emp_bank_id) INTO l_exist FROM prod.dct_pay_emp_bank
                         WHERE person_id = l_out_pid
                           AND (   (l_iban IS NOT NULL AND UPPER(REPLACE(iban,' ','')) = l_iban)
                                OR (l_iban IS NULL AND UPPER(bank_name) = UPPER(l_bank)));
                        save_bank(p_user, l_exist, l_out_pid,
                                  NVL(l_bank, 'UNKNOWN'),
                                  l_iban, l_acct, NULL, 'AED',
                                  'Y', NULL, NULL, 'Y', l_bid);
                    END;
                END IF;

                l_ok := l_ok + 1;
                apex_json.open_object;
                apex_json.write('row', i);
                apex_json.write('status', CASE WHEN l_new THEN 'CREATED' ELSE 'UPDATED' END);
                apex_json.write('personId', l_out_pid);
                apex_json.write('employeeNumber', l_out_no);
                apex_json.close_object;
            EXCEPTION WHEN OTHERS THEN
                ROLLBACK TO bulk_row;
                l_err := l_err + 1;
                l_v := SQLERRM;
                l_v := REGEXP_REPLACE(l_v, '^ORA-\d+:\s*', '');
                l_v := REGEXP_REPLACE(l_v, CHR(10) || '.*$', '');
                apex_json.open_object;
                apex_json.write('row', i);
                apex_json.write('status', 'ERROR');
                apex_json.write('error', l_v);
                apex_json.close_object;
            END;
        END LOOP;

        apex_json.close_array;
        apex_json.write('total', l_cnt);
        apex_json.write('succeeded', l_ok);
        apex_json.write('failed', l_err);
        apex_json.close_object;
        o_result := apex_json.get_clob_output;
        apex_json.free_output;
        COMMIT;
    END bulk_upsert;

    -- --------------------------------------------------- document expiry sweep
    PROCEDURE sweep_expiring_docs IS
        l_default NUMBER := 30;
        l_sent    NUMBER := 0;
    BEGIN
        BEGIN
            SELECT TO_NUMBER(ms.setting_value) INTO l_default
            FROM prod.dct_module_settings ms
            JOIN prod.dct_modules m ON m.module_id = ms.module_id
            WHERE m.module_code = 'PAY' AND ms.setting_key = 'EMP_DOC_ALERT_DAYS';
        EXCEPTION WHEN OTHERS THEN NULL;
        END;

        FOR d IN (
            SELECT doc.doc_id, doc.expiry_date,
                   e.person_id, e.full_name_en, e.employee_number,
                   dt.doc_type_name_en, dt.doc_type_name_ar,
                   TRUNC(doc.expiry_date) - TRUNC(SYSDATE) AS days_left
            FROM prod.dct_documents doc
            JOIN prod.dct_document_types dt ON dt.doc_type_id = doc.doc_type_id
            JOIN prod.dct_employees e ON e.person_id = doc.reference_id AND e.is_active = 'Y'
            WHERE doc.source_module = 'PAY'
              AND doc.source_type = 'PAY_EMPLOYEE'
              AND doc.is_active = 'Y'
              AND doc.expiry_date IS NOT NULL
              AND TRUNC(doc.expiry_date) - TRUNC(SYSDATE)
                  BETWEEN 0 AND NVL(NULLIF(dt.expiry_alert_days, 0), l_default)
              AND NOT EXISTS (
                    SELECT 1 FROM prod.dct_doc_expiry_alerts a
                    WHERE a.doc_id = doc.doc_id AND a.sent_at > SYSDATE - 7)
        ) LOOP
            FOR u IN (
                SELECT DISTINCT ur.user_id
                FROM prod.dct_user_roles ur
                JOIN prod.dct_roles r ON r.role_id = ur.role_id
                WHERE r.role_code IN ('PAY_ADMIN','PAY_HR_ENTRY')
                  AND (ur.end_date IS NULL OR ur.end_date >= SYSDATE)
            ) LOOP
                prod.dct_notify.send(
                    p_recipient_user_id => u.user_id,
                    p_notification_type => 'PAY_EMP_DOC_EXPIRY',
                    p_title_en          => 'Outsourced employee document expiring',
                    p_body_en           => d.doc_type_name_en || ' of ' || d.full_name_en ||
                                           ' (' || d.employee_number || ') expires in ' ||
                                           d.days_left || ' day(s) on ' ||
                                           TO_CHAR(d.expiry_date, 'YYYY-MM-DD') || '.',
                    p_title_ar          => 'مستند موظف إسناد خارجي يوشك على الانتهاء',
                    p_body_ar           => d.doc_type_name_ar || ' للموظف ' || d.full_name_en ||
                                           ' (' || d.employee_number || ') ينتهي خلال ' ||
                                           d.days_left || ' يوم بتاريخ ' ||
                                           TO_CHAR(d.expiry_date, 'YYYY-MM-DD') || '.',
                    p_module_code       => 'PAY',
                    p_link_url          => '#employees');

                INSERT INTO prod.dct_doc_expiry_alerts
                       (doc_id, alert_type, days_remaining, notified_user_id, sent_at)
                VALUES (d.doc_id, 'EXPIRY', d.days_left, u.user_id, SYSTIMESTAMP);
            END LOOP;
            l_sent := l_sent + 1;
        END LOOP;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('sweep_expiring_docs: alerts sent for ' || l_sent || ' document(s)');
    END sweep_expiring_docs;

END dct_pay_emp_pkg;
/

SHOW ERRORS PACKAGE BODY prod.dct_pay_emp_pkg

-- =============================================================================
-- Daily employee document expiry job (0725 UTC, after the renewal sweep)
-- =============================================================================
DECLARE
    l_n NUMBER;
BEGIN
    SELECT COUNT(*) INTO l_n FROM all_scheduler_jobs
    WHERE owner = 'PROD' AND job_name = 'DCT_PAY_EMPDOC_JOB';
    IF l_n > 0 THEN
        DBMS_SCHEDULER.DROP_JOB('PROD.DCT_PAY_EMPDOC_JOB', force => TRUE);
    END IF;
    DBMS_SCHEDULER.CREATE_JOB(
        job_name        => 'PROD.DCT_PAY_EMPDOC_JOB',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN prod.dct_pay_emp_pkg.sweep_expiring_docs; END;',
        start_date      => SYSTIMESTAMP,
        repeat_interval => 'FREQ=DAILY;BYHOUR=7;BYMINUTE=25',
        enabled         => TRUE,
        comments        => 'Outsource Payroll (App 215) Phase 2: daily employee document expiry alerts to PAY_ADMIN + PAY_HR_ENTRY users');
    DBMS_OUTPUT.PUT_LINE('Job scheduled: DCT_PAY_EMPDOC_JOB (daily 07:25 UTC)');
END;
/

PROMPT === 11_pay_phase2_pkg.sql complete: DCT_PAY_EMP_PKG + DCT_PAY_EMPDOC_JOB ===
