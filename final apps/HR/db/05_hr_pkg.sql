-- =============================================================================
-- i-Finance V2 — HR Module: PL/SQL Package
-- File    : 05_hr_pkg.sql
-- Schema  : PROD
-- Package : DCT_HR
-- =============================================================================
-- Procedures / Functions:
--   assign_employee       — create a new assignment, close the previous primary
--   transfer_employee     — move employee to a new org/position (wraps assign)
--   end_assignment        — close an assignment with a reason
--   update_salary         — insert a salary history row with auto-calculated delta
--   get_org_tree          — return org hierarchy as a ref cursor
--   get_headcount_summary — return filled / vacant counts for an org
--   alert_expiring_docs   — return employees with docs expiring within N days
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- PACKAGE SPEC
-- =============================================================================
CREATE OR REPLACE PACKAGE prod.dct_hr AS

    -- -------------------------------------------------------------------------
    -- assign_employee
    --   Creates a new HR_EMPLOYEE_ASSIGNMENTS row.
    --   If is_primary = 'Y', automatically ends any currently active primary
    --   assignment for the same person before inserting the new one.
    --   Also updates DCT_EMPLOYEES.org_id, grade_code, and position_id to
    --   reflect the new assignment.
    -- -------------------------------------------------------------------------
    PROCEDURE assign_employee (
        p_person_id         IN NUMBER,
        p_position_id       IN NUMBER   DEFAULT NULL,
        p_job_id            IN NUMBER   DEFAULT NULL,
        p_org_id            IN NUMBER,
        p_grade_code        IN VARCHAR2 DEFAULT NULL,
        p_location_id       IN NUMBER   DEFAULT NULL,
        p_assignment_type_id IN NUMBER  DEFAULT NULL,
        p_start_date        IN DATE     DEFAULT TRUNC(SYSDATE),
        p_probation_months  IN NUMBER   DEFAULT NULL,
        p_manager_person_id IN NUMBER   DEFAULT NULL,
        p_is_primary        IN VARCHAR2 DEFAULT 'Y',
        p_remarks           IN VARCHAR2 DEFAULT NULL,
        p_assignment_id     OUT NUMBER
    );

    -- -------------------------------------------------------------------------
    -- transfer_employee
    --   Convenience wrapper for a position/org transfer.
    --   Ends current primary assignment with reason TRANSFER and calls
    --   assign_employee for the new position.
    -- -------------------------------------------------------------------------
    PROCEDURE transfer_employee (
        p_person_id          IN NUMBER,
        p_new_org_id         IN NUMBER,
        p_new_position_id    IN NUMBER   DEFAULT NULL,
        p_new_job_id         IN NUMBER   DEFAULT NULL,
        p_new_grade_code     IN VARCHAR2 DEFAULT NULL,
        p_new_location_id    IN NUMBER   DEFAULT NULL,
        p_transfer_date      IN DATE     DEFAULT TRUNC(SYSDATE),
        p_new_manager_id     IN NUMBER   DEFAULT NULL,
        p_remarks            IN VARCHAR2 DEFAULT NULL,
        p_new_assignment_id  OUT NUMBER
    );

    -- -------------------------------------------------------------------------
    -- end_assignment
    --   Closes an assignment by setting end_date and assignment_status = ENDED.
    -- -------------------------------------------------------------------------
    PROCEDURE end_assignment (
        p_assignment_id  IN NUMBER,
        p_end_date       IN DATE     DEFAULT TRUNC(SYSDATE),
        p_end_reason_id  IN NUMBER   DEFAULT NULL,
        p_remarks        IN VARCHAR2 DEFAULT NULL
    );

    -- -------------------------------------------------------------------------
    -- update_salary
    --   Inserts a new HR_SALARY_HISTORY row.
    --   Automatically calculates previous_basic and change_percentage from
    --   the most recent existing row for this person.
    -- -------------------------------------------------------------------------
    PROCEDURE update_salary (
        p_person_id        IN NUMBER,
        p_basic_salary     IN NUMBER,
        p_effective_date   IN DATE     DEFAULT TRUNC(SYSDATE),
        p_currency_code    IN VARCHAR2 DEFAULT 'AED',
        p_change_reason_id IN NUMBER   DEFAULT NULL,
        p_approved_by      IN NUMBER   DEFAULT NULL,
        p_remarks          IN VARCHAR2 DEFAULT NULL,
        p_salary_id        OUT NUMBER
    );

    -- -------------------------------------------------------------------------
    -- get_org_tree
    --   Returns a SYS_REFCURSOR of the full org hierarchy starting from
    --   p_root_org_id (NULL = entire tree).
    -- -------------------------------------------------------------------------
    FUNCTION get_org_tree (
        p_root_org_id  IN NUMBER DEFAULT NULL
    ) RETURN SYS_REFCURSOR;

    -- -------------------------------------------------------------------------
    -- get_headcount_summary
    --   Returns a SYS_REFCURSOR of headcount and vacancy totals for a given
    --   org and all its descendants.
    -- -------------------------------------------------------------------------
    FUNCTION get_headcount_summary (
        p_org_id  IN NUMBER DEFAULT NULL
    ) RETURN SYS_REFCURSOR;

    -- -------------------------------------------------------------------------
    -- alert_expiring_docs
    --   Returns a SYS_REFCURSOR of employee documents expiring within
    --   p_days_ahead days, ordered by expiry_date ASC.
    -- -------------------------------------------------------------------------
    FUNCTION alert_expiring_docs (
        p_days_ahead  IN NUMBER DEFAULT 90
    ) RETURN SYS_REFCURSOR;

END dct_hr;
/

-- =============================================================================
-- PACKAGE BODY
-- =============================================================================
CREATE OR REPLACE PACKAGE BODY prod.dct_hr AS

    -- -------------------------------------------------------------------------
    -- Private helper: generate a unique assignment number ASGN-YYYY-NNNNN
    -- -------------------------------------------------------------------------
    FUNCTION gen_assignment_number RETURN VARCHAR2 IS
        v_seq NUMBER;
        v_num VARCHAR2(30);
    BEGIN
        SELECT NVL(MAX(TO_NUMBER(REGEXP_SUBSTR(assignment_number, '\d+$'))), 0) + 1
        INTO   v_seq
        FROM   hr_employee_assignments;

        v_num := 'ASGN-' || TO_CHAR(SYSDATE, 'YYYY') || '-' || LPAD(v_seq, 5, '0');
        RETURN v_num;
    END;

    -- -------------------------------------------------------------------------
    -- assign_employee
    -- -------------------------------------------------------------------------
    PROCEDURE assign_employee (
        p_person_id          IN NUMBER,
        p_position_id        IN NUMBER   DEFAULT NULL,
        p_job_id             IN NUMBER   DEFAULT NULL,
        p_org_id             IN NUMBER,
        p_grade_code         IN VARCHAR2 DEFAULT NULL,
        p_location_id        IN NUMBER   DEFAULT NULL,
        p_assignment_type_id IN NUMBER   DEFAULT NULL,
        p_start_date         IN DATE     DEFAULT TRUNC(SYSDATE),
        p_probation_months   IN NUMBER   DEFAULT NULL,
        p_manager_person_id  IN NUMBER   DEFAULT NULL,
        p_is_primary         IN VARCHAR2 DEFAULT 'Y',
        p_remarks            IN VARCHAR2 DEFAULT NULL,
        p_assignment_id      OUT NUMBER
    ) IS
        v_end_reason_id   NUMBER;
        v_resolved_job_id NUMBER := p_job_id;
        v_asgn_num        VARCHAR2(30);
    BEGIN
        -- If job_id not supplied, derive from position
        IF v_resolved_job_id IS NULL AND p_position_id IS NOT NULL THEN
            SELECT job_id INTO v_resolved_job_id
            FROM   hr_positions
            WHERE  position_id = p_position_id;
        END IF;

        -- If this is a primary assignment, close the existing one first
        IF p_is_primary = 'Y' THEN
            SELECT value_id INTO v_end_reason_id
            FROM   dct_lookup_values lv
            JOIN   dct_lookup_categories lc ON lc.category_id = lv.category_id
            WHERE  lc.category_code = 'HR_END_REASON'
            AND    lv.value_code    = 'TRANSFER'
            AND    ROWNUM           = 1;

            UPDATE hr_employee_assignments
            SET    assignment_status = 'ENDED',
                   end_date          = p_start_date - 1,
                   end_reason_id     = v_end_reason_id,
                   updated_by        = NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),
                                           SYS_CONTEXT('USERENV','SESSION_USER'))
            WHERE  person_id         = p_person_id
            AND    assignment_status = 'ACTIVE'
            AND    is_primary        = 'Y'
            AND    end_date          IS NULL;
        END IF;

        -- Private function cannot be called in SQL VALUES clause; resolve first
        v_asgn_num := gen_assignment_number();

        -- Insert new assignment
        INSERT INTO hr_employee_assignments (
            assignment_number, person_id, position_id, job_id, org_id,
            grade_code, location_id, assignment_type_id,
            assignment_status, start_date, end_date, is_primary,
            probation_end_date, manager_person_id, remarks,
            created_by
        ) VALUES (
            v_asgn_num,
            p_person_id, p_position_id, v_resolved_job_id, p_org_id,
            p_grade_code, p_location_id, p_assignment_type_id,
            'ACTIVE', p_start_date, NULL, p_is_primary,
            CASE WHEN p_probation_months IS NOT NULL
                 THEN ADD_MONTHS(p_start_date, p_probation_months)
                 ELSE NULL END,
            p_manager_person_id, p_remarks,
            NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'))
        ) RETURNING assignment_id INTO p_assignment_id;

        -- Sync key fields back to DCT_EMPLOYEES if this is the primary
        IF p_is_primary = 'Y' THEN
            UPDATE dct_employees
            SET    org_id      = p_org_id,
                   grade_code  = NVL(p_grade_code, grade_code),
                   position_id = p_position_id,
                   location_id = NVL(p_location_id, location_id),
                   manager_person_id = NVL(p_manager_person_id, manager_person_id),
                   updated_by  = NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),
                                     SYS_CONTEXT('USERENV','SESSION_USER'))
            WHERE  person_id = p_person_id;
        END IF;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END assign_employee;

    -- -------------------------------------------------------------------------
    -- transfer_employee
    -- -------------------------------------------------------------------------
    PROCEDURE transfer_employee (
        p_person_id         IN NUMBER,
        p_new_org_id        IN NUMBER,
        p_new_position_id   IN NUMBER   DEFAULT NULL,
        p_new_job_id        IN NUMBER   DEFAULT NULL,
        p_new_grade_code    IN VARCHAR2 DEFAULT NULL,
        p_new_location_id   IN NUMBER   DEFAULT NULL,
        p_transfer_date     IN DATE     DEFAULT TRUNC(SYSDATE),
        p_new_manager_id    IN NUMBER   DEFAULT NULL,
        p_remarks           IN VARCHAR2 DEFAULT NULL,
        p_new_assignment_id OUT NUMBER
    ) IS
    BEGIN
        assign_employee(
            p_person_id          => p_person_id,
            p_position_id        => p_new_position_id,
            p_job_id             => p_new_job_id,
            p_org_id             => p_new_org_id,
            p_grade_code         => p_new_grade_code,
            p_location_id        => p_new_location_id,
            p_start_date         => p_transfer_date,
            p_manager_person_id  => p_new_manager_id,
            p_is_primary         => 'Y',
            p_remarks            => p_remarks,
            p_assignment_id      => p_new_assignment_id
        );
    END transfer_employee;

    -- -------------------------------------------------------------------------
    -- end_assignment
    -- -------------------------------------------------------------------------
    PROCEDURE end_assignment (
        p_assignment_id  IN NUMBER,
        p_end_date       IN DATE     DEFAULT TRUNC(SYSDATE),
        p_end_reason_id  IN NUMBER   DEFAULT NULL,
        p_remarks        IN VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        UPDATE hr_employee_assignments
        SET    assignment_status = 'ENDED',
               end_date          = p_end_date,
               end_reason_id     = p_end_reason_id,
               remarks           = NVL(p_remarks, remarks),
               updated_by        = NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),
                                       SYS_CONTEXT('USERENV','SESSION_USER'))
        WHERE  assignment_id = p_assignment_id;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20101, 'Assignment ID ' || p_assignment_id || ' not found.');
        END IF;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END end_assignment;

    -- -------------------------------------------------------------------------
    -- update_salary
    -- -------------------------------------------------------------------------
    PROCEDURE update_salary (
        p_person_id        IN NUMBER,
        p_basic_salary     IN NUMBER,
        p_effective_date   IN DATE     DEFAULT TRUNC(SYSDATE),
        p_currency_code    IN VARCHAR2 DEFAULT 'AED',
        p_change_reason_id IN NUMBER   DEFAULT NULL,
        p_approved_by      IN NUMBER   DEFAULT NULL,
        p_remarks          IN VARCHAR2 DEFAULT NULL,
        p_salary_id        OUT NUMBER
    ) IS
        v_prev_basic      NUMBER;
        v_change_pct      NUMBER;
    BEGIN
        -- Fetch most recent basic salary for delta calculation
        BEGIN
            SELECT basic_salary
            INTO   v_prev_basic
            FROM   hr_salary_history
            WHERE  person_id = p_person_id
            ORDER  BY effective_date DESC, salary_id DESC
            FETCH  FIRST 1 ROW ONLY;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_prev_basic := NULL;
        END;

        IF v_prev_basic IS NOT NULL AND v_prev_basic != 0 THEN
            v_change_pct := ROUND(((p_basic_salary - v_prev_basic) / v_prev_basic) * 100, 2);
        END IF;

        INSERT INTO hr_salary_history (
            person_id, effective_date, basic_salary, currency_code,
            change_reason_id, previous_basic, change_percentage,
            approved_by, remarks, created_by
        ) VALUES (
            p_person_id, p_effective_date, p_basic_salary, p_currency_code,
            p_change_reason_id, v_prev_basic, v_change_pct,
            p_approved_by, p_remarks,
            NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'))
        ) RETURNING salary_id INTO p_salary_id;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END update_salary;

    -- -------------------------------------------------------------------------
    -- get_org_tree
    -- -------------------------------------------------------------------------
    FUNCTION get_org_tree (
        p_root_org_id IN NUMBER DEFAULT NULL
    ) RETURN SYS_REFCURSOR IS
        v_cur SYS_REFCURSOR;
    BEGIN
        IF p_root_org_id IS NULL THEN
            OPEN v_cur FOR
                SELECT org_id, org_code, org_name_en, org_name_ar,
                       org_type_label, parent_org_id, level_no, full_path,
                       is_active, headcount_ceiling, location_id, location_name_en,
                       cost_center_code, is_leaf
                FROM   v_hr_org_tree
                ORDER  BY full_path;
        ELSE
            OPEN v_cur FOR
                SELECT org_id, org_code, org_name_en, org_name_ar,
                       org_type_label, parent_org_id, level_no, full_path,
                       is_active, headcount_ceiling, location_id, location_name_en,
                       cost_center_code, is_leaf
                FROM   v_hr_org_tree
                START WITH org_id = p_root_org_id
                CONNECT BY PRIOR org_id = parent_org_id
                ORDER  BY full_path;
        END IF;

        RETURN v_cur;
    END get_org_tree;

    -- -------------------------------------------------------------------------
    -- get_headcount_summary
    -- -------------------------------------------------------------------------
    FUNCTION get_headcount_summary (
        p_org_id IN NUMBER DEFAULT NULL
    ) RETURN SYS_REFCURSOR IS
        v_cur SYS_REFCURSOR;
    BEGIN
        OPEN v_cur FOR
            SELECT
                org_id,
                org_name_en,
                SUM(approved_headcount)  AS total_approved,
                SUM(filled_count)        AS total_filled,
                SUM(vacancy_count)       AS total_vacancies
            FROM v_hr_headcount
            WHERE (p_org_id IS NULL OR org_id = p_org_id
                   OR org_id IN (
                       SELECT org_id FROM dct_organizations
                       START WITH org_id = p_org_id
                       CONNECT BY PRIOR org_id = parent_org_id
                   ))
            GROUP BY org_id, org_name_en
            ORDER BY org_name_en;

        RETURN v_cur;
    END get_headcount_summary;

    -- -------------------------------------------------------------------------
    -- alert_expiring_docs
    -- -------------------------------------------------------------------------
    FUNCTION alert_expiring_docs (
        p_days_ahead IN NUMBER DEFAULT 90
    ) RETURN SYS_REFCURSOR IS
        v_cur SYS_REFCURSOR;
    BEGIN
        OPEN v_cur FOR
            SELECT *
            FROM   v_hr_expiring_docs
            WHERE  days_until_expiry <= p_days_ahead
            ORDER  BY days_until_expiry ASC, full_name_en;

        RETURN v_cur;
    END alert_expiring_docs;

END dct_hr;
/

COMMIT;
PROMPT DCT_HR package compiled (spec + body).
