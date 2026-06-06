-- =============================================================================
-- i-Finance V2 — HR Module: ORDS REST API
-- File    : 06_hr_ords.sql
-- Run as  : ADMIN schema (sql -name prod_mcp)
-- Base URL: /ords/admin/hr/
-- Pattern : Matches DT/PC/FL — own module 'hr.rest', synonyms in ADMIN
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = ADMIN;
SET DEFINE OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- 1. ADMIN synonyms — HR tables + views (ORDS runs as ADMIN, objects live in PROD)
-- =============================================================================
CREATE OR REPLACE SYNONYM hr_locations              FOR prod.hr_locations;
CREATE OR REPLACE SYNONYM hr_job_families           FOR prod.hr_job_families;
CREATE OR REPLACE SYNONYM hr_jobs                   FOR prod.hr_jobs;
CREATE OR REPLACE SYNONYM hr_positions              FOR prod.hr_positions;
CREATE OR REPLACE SYNONYM hr_employee_assignments   FOR prod.hr_employee_assignments;
CREATE OR REPLACE SYNONYM hr_employment_contracts   FOR prod.hr_employment_contracts;
CREATE OR REPLACE SYNONYM hr_salary_history         FOR prod.hr_salary_history;
CREATE OR REPLACE SYNONYM hr_employee_documents     FOR prod.hr_employee_documents;

CREATE OR REPLACE SYNONYM v_hr_org_tree             FOR prod.v_hr_org_tree;
CREATE OR REPLACE SYNONYM v_hr_headcount            FOR prod.v_hr_headcount;
CREATE OR REPLACE SYNONYM v_hr_employee_full        FOR prod.v_hr_employee_full;
CREATE OR REPLACE SYNONYM v_hr_expiring_docs        FOR prod.v_hr_expiring_docs;
CREATE OR REPLACE SYNONYM v_hr_active_contracts     FOR prod.v_hr_active_contracts;
CREATE OR REPLACE SYNONYM v_hr_salary_current       FOR prod.v_hr_salary_current;

-- Platform objects used by HR endpoints
CREATE OR REPLACE SYNONYM dct_employees             FOR prod.dct_employees;
CREATE OR REPLACE SYNONYM dct_organizations         FOR prod.dct_organizations;
CREATE OR REPLACE SYNONYM dct_employee_grades       FOR prod.dct_employee_grades;
CREATE OR REPLACE SYNONYM dct_lookup_values         FOR prod.dct_lookup_values;
CREATE OR REPLACE SYNONYM dct_lookup_categories     FOR prod.dct_lookup_categories;
CREATE OR REPLACE SYNONYM dct_document_types        FOR prod.dct_document_types;
CREATE OR REPLACE SYNONYM dct_countries             FOR prod.dct_countries;
CREATE OR REPLACE SYNONYM dct_users                 FOR prod.dct_users;
CREATE OR REPLACE SYNONYM dct_hr                    FOR prod.dct_hr;

-- =============================================================================
-- 2. Define ORDS module + all templates + handlers
-- =============================================================================
CREATE OR REPLACE PROCEDURE setup_hr_ords_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'hr.rest';

    PROCEDURE def_tpl (p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(
            p_module_name => c_mod,
            p_pattern     => p_pattern
        );
    END;

    PROCEDURE def_get (p_pattern VARCHAR2, p_source CLOB, p_one_row BOOLEAN DEFAULT FALSE) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name   => c_mod,
            p_pattern       => p_pattern,
            p_method        => 'GET',
            p_source_type   => CASE WHEN p_one_row
                                    THEN ORDS.source_type_query_one_row
                                    ELSE ORDS.source_type_query END,
            p_source        => p_source
        );
    END;

    PROCEDURE def_plsql (p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name   => c_mod,
            p_pattern       => p_pattern,
            p_method        => p_method,
            p_source_type   => ORDS.source_type_plsql,
            p_source        => p_source
        );
    END;

BEGIN
    -- Drop and recreate cleanly
    BEGIN ORDS.DELETE_MODULE(p_module_name => c_mod); EXCEPTION WHEN OTHERS THEN NULL; END;

    ORDS.DEFINE_MODULE(
        p_module_name    => c_mod,
        p_base_path      => '/hr/',
        p_items_per_page => 50,
        p_status         => 'PUBLISHED',
        p_comments       => 'HR Module REST API — employees, orgs, positions, jobs, contracts, salary, documents'
    );

    -- =========================================================================
    -- EMPLOYEES
    -- =========================================================================
    def_tpl('employees/');
    def_get('employees/', q'[
        SELECT e.person_id, e.employee_number,
               e.full_name_en, e.full_name_ar,
               e.email, e.mobile, e.gender, e.hire_date, e.is_active,
               e.grade_code, g.grade_name_en,
               e.org_id, o.org_name_en,
               e.job_title_en, e.photo_url,
               a.position_id, pos.position_name_en,
               j.job_name_en, l.location_name_en
        FROM   dct_employees e
        LEFT JOIN dct_employee_grades    g   ON g.grade_code  = e.grade_code
        LEFT JOIN dct_organizations      o   ON o.org_id      = e.org_id
        LEFT JOIN hr_employee_assignments a
               ON a.person_id = e.person_id AND a.assignment_status = 'ACTIVE'
              AND a.is_primary = 'Y' AND a.end_date IS NULL
        LEFT JOIN hr_positions   pos ON pos.position_id = a.position_id
        LEFT JOIN hr_jobs        j   ON j.job_id        = a.job_id
        LEFT JOIN hr_locations   l   ON l.location_id   = a.location_id
        WHERE (:org_id  IS NULL OR e.org_id     = :org_id)
          AND (:grade   IS NULL OR e.grade_code = :grade)
          AND (:active  IS NULL OR e.is_active  = :active)
          AND (:q IS NULL
               OR UPPER(e.full_name_en)   LIKE '%'||UPPER(:q)||'%'
               OR UPPER(e.employee_number) LIKE '%'||UPPER(:q)||'%'
               OR UPPER(e.email)           LIKE '%'||UPPER(:q)||'%')
        ORDER BY e.full_name_en
    ]');

    def_tpl('employees/:id');
    def_get('employees/:id', 'SELECT * FROM v_hr_employee_full WHERE person_id = :id', TRUE);

    def_plsql('employees/', 'POST', q'[
        DECLARE v_id NUMBER;
        BEGIN
            INSERT INTO dct_employees (
                employee_number, first_name_en, last_name_en,
                first_name_ar, last_name_ar, email, mobile, gender,
                nationality_code, national_id, passport_number,
                grade_code, job_title_en, job_title_ar, org_id,
                hire_date, is_active, sync_source,
                personal_email, work_phone, photo_url, marital_status_id,
                created_by
            ) VALUES (
                :employee_number, :first_name_en, :last_name_en,
                :first_name_ar, :last_name_ar, :email, :mobile, :gender,
                :nationality_code, :national_id, :passport_number,
                :grade_code, :job_title_en, :job_title_ar, :org_id,
                TO_DATE(:hire_date,'YYYY-MM-DD'), NVL(:is_active,'Y'), 'MANUAL',
                :personal_email, :work_phone, :photo_url, :marital_status_id,
                NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),SYS_CONTEXT('USERENV','SESSION_USER'))
            ) RETURNING person_id INTO v_id;
            :status_code      := 201;
            :forward_location := 'employees/' || v_id;
            COMMIT;
        END;
    ]');

    def_plsql('employees/:id', 'PUT', q'[
        BEGIN
            UPDATE dct_employees SET
                first_name_en     = NVL(:first_name_en,     first_name_en),
                last_name_en      = NVL(:last_name_en,      last_name_en),
                first_name_ar     = NVL(:first_name_ar,     first_name_ar),
                last_name_ar      = NVL(:last_name_ar,      last_name_ar),
                mobile            = NVL(:mobile,             mobile),
                personal_email    = NVL(:personal_email,     personal_email),
                work_phone        = NVL(:work_phone,         work_phone),
                gender            = NVL(:gender,             gender),
                nationality_code  = NVL(:nationality_code,   nationality_code),
                national_id       = NVL(:national_id,        national_id),
                passport_number   = NVL(:passport_number,    passport_number),
                grade_code        = NVL(:grade_code,         grade_code),
                job_title_en      = NVL(:job_title_en,       job_title_en),
                job_title_ar      = NVL(:job_title_ar,       job_title_ar),
                org_id            = NVL(:org_id,             org_id),
                marital_status_id = NVL(:marital_status_id,  marital_status_id),
                photo_url         = NVL(:photo_url,           photo_url),
                is_active         = NVL(:is_active,           is_active)
            WHERE person_id = :id;
            :status_code := 200;
            COMMIT;
        END;
    ]');

    -- =========================================================================
    -- ORGANISATIONS
    -- =========================================================================
    def_tpl('orgs/');
    def_get('orgs/', q'[
        SELECT o.org_id, o.org_code, o.org_name_en, o.org_name_ar,
               o.org_type, lv.value_name_en AS org_type_label,
               o.parent_org_id, o.level_no, o.full_path,
               o.headcount_ceiling, o.cost_center_code,
               o.effective_from, o.effective_to, o.is_active,
               l.location_name_en
        FROM   dct_organizations o
        LEFT JOIN dct_lookup_values lv ON lv.value_id    = o.org_type_id
        LEFT JOIN hr_locations      l  ON l.location_id  = o.location_id
        WHERE (:is_active IS NULL OR o.is_active = :is_active)
        ORDER BY o.full_path
    ]');

    def_tpl('orgs/tree/');
    def_get('orgs/tree/', q'[
        SELECT org_id, org_code, org_name_en, org_name_ar,
               org_type_label, parent_org_id, level_no, full_path,
               is_active, headcount_ceiling, location_name_en,
               cost_center_code, is_leaf
        FROM   v_hr_org_tree
        ORDER  BY full_path
    ]');

    def_tpl('orgs/:id/positions/');
    def_get('orgs/:id/positions/', q'[
        SELECT * FROM v_hr_headcount WHERE org_id = :id ORDER BY position_name_en
    ]');

    -- =========================================================================
    -- POSITIONS + JOBS
    -- =========================================================================
    def_tpl('positions/');
    def_get('positions/', q'[
        SELECT * FROM v_hr_headcount
        WHERE (:org_id IS NULL OR org_id = :org_id)
        ORDER BY org_name_en, position_name_en
    ]');

    def_tpl('positions/:id');
    def_get('positions/:id', 'SELECT * FROM v_hr_headcount WHERE position_id = :id', TRUE);

    def_tpl('jobs/');
    def_get('jobs/', q'[
        SELECT j.job_id, j.job_code, j.job_name_en, j.job_name_ar,
               j.job_family_id, f.family_name_en AS job_family,
               j.min_grade_code, j.max_grade_code,
               j.min_experience_years, j.description_en,
               j.is_active, j.effective_from, j.effective_to
        FROM   hr_jobs j
        LEFT JOIN hr_job_families f ON f.job_family_id = j.job_family_id
        WHERE  (:family_id IS NULL OR j.job_family_id = :family_id)
          AND  j.is_active = NVL(:is_active,'Y')
        ORDER  BY f.family_name_en, j.job_name_en
    ]');

    def_tpl('job-families/');
    def_get('job-families/', q'[
        SELECT job_family_id, family_code, family_name_en, family_name_ar,
               description_en, is_active, display_order
        FROM   hr_job_families
        WHERE  is_active = NVL(:is_active,'Y')
        ORDER  BY display_order, family_name_en
    ]');

    -- =========================================================================
    -- LOCATIONS
    -- =========================================================================
    def_tpl('locations/');
    def_get('locations/', q'[
        SELECT l.location_id, l.location_code, l.location_name_en, l.location_name_ar,
               lt.value_name_en AS location_type,
               l.org_id, o.org_name_en,
               l.country_code, c.country_name_en,
               l.emirate, l.city, l.area, l.building_name, l.floor_no,
               l.is_active, l.display_order
        FROM   hr_locations l
        LEFT JOIN dct_lookup_values  lt ON lt.value_id    = l.location_type_id
        LEFT JOIN dct_organizations  o  ON o.org_id       = l.org_id
        LEFT JOIN dct_countries      c  ON c.country_code = l.country_code
        WHERE  l.is_active = NVL(:is_active,'Y')
        ORDER  BY l.display_order, l.location_name_en
    ]');

    -- =========================================================================
    -- ASSIGNMENTS
    -- =========================================================================
    def_tpl('assignments/:person_id');
    def_get('assignments/:person_id', q'[
        SELECT a.assignment_id, a.assignment_number,
               a.position_id, p.position_name_en,
               a.job_id, j.job_name_en,
               a.org_id, o.org_name_en,
               a.grade_code, g.grade_name_en,
               at_lv.value_name_en AS assignment_type,
               a.assignment_status, a.is_primary,
               a.start_date, a.end_date,
               er.value_name_en AS end_reason,
               a.probation_end_date, l.location_name_en,
               mgr.full_name_en AS manager_name, a.remarks
        FROM   hr_employee_assignments a
        LEFT JOIN hr_positions          p    ON p.position_id   = a.position_id
        LEFT JOIN hr_jobs               j    ON j.job_id        = a.job_id
        LEFT JOIN dct_organizations     o    ON o.org_id        = a.org_id
        LEFT JOIN dct_employee_grades   g    ON g.grade_code    = a.grade_code
        LEFT JOIN dct_lookup_values     at_lv ON at_lv.value_id = a.assignment_type_id
        LEFT JOIN dct_lookup_values     er   ON er.value_id     = a.end_reason_id
        LEFT JOIN hr_locations          l    ON l.location_id   = a.location_id
        LEFT JOIN dct_employees         mgr  ON mgr.person_id   = a.manager_person_id
        WHERE  a.person_id = :person_id
        ORDER  BY a.start_date DESC
    ]');

    def_tpl('assignments/');
    def_plsql('assignments/', 'POST', q'[
        DECLARE v_id NUMBER;
        BEGIN
            dct_hr.assign_employee(
                p_person_id          => :person_id,
                p_position_id        => :position_id,
                p_job_id             => :job_id,
                p_org_id             => :org_id,
                p_grade_code         => :grade_code,
                p_location_id        => :location_id,
                p_assignment_type_id => :assignment_type_id,
                p_start_date         => TO_DATE(NVL(:start_date,TO_CHAR(SYSDATE,'YYYY-MM-DD')),'YYYY-MM-DD'),
                p_probation_months   => :probation_months,
                p_manager_person_id  => :manager_person_id,
                p_is_primary         => NVL(:is_primary,'Y'),
                p_remarks            => :remarks,
                p_assignment_id      => v_id
            );
            :status_code := 201;
        END;
    ]');

    def_tpl('assignments/:id/end/');
    def_plsql('assignments/:id/end/', 'PUT', q'[
        BEGIN
            dct_hr.end_assignment(
                p_assignment_id => :id,
                p_end_date      => TO_DATE(NVL(:end_date,TO_CHAR(SYSDATE,'YYYY-MM-DD')),'YYYY-MM-DD'),
                p_end_reason_id => :end_reason_id,
                p_remarks       => :remarks
            );
            :status_code := 200;
        END;
    ]');

    -- =========================================================================
    -- CONTRACTS + SALARY
    -- =========================================================================
    def_tpl('contracts/:person_id');
    def_get('contracts/:person_id', q'[
        SELECT * FROM v_hr_active_contracts WHERE person_id = :person_id ORDER BY start_date DESC
    ]');

    def_tpl('salary/:person_id');
    def_get('salary/:person_id', q'[
        SELECT s.salary_id, s.effective_date, s.basic_salary, s.currency_code,
               sr.value_name_en AS change_reason,
               s.previous_basic, s.change_percentage,
               u.display_name AS approved_by, s.remarks
        FROM   hr_salary_history s
        LEFT JOIN dct_lookup_values sr ON sr.value_id = s.change_reason_id
        LEFT JOIN dct_users         u  ON u.user_id   = s.approved_by
        WHERE  s.person_id = :person_id
        ORDER  BY s.effective_date DESC
    ]');

    -- =========================================================================
    -- DOCUMENTS
    -- =========================================================================
    def_tpl('documents/:person_id');
    def_get('documents/:person_id', q'[
        SELECT d.doc_id, d.person_id,
               dt.doc_type_name_en, dt.doc_category,
               d.doc_number, d.issue_date, d.expiry_date,
               TRUNC(d.expiry_date) - TRUNC(SYSDATE) AS days_until_expiry,
               d.issuing_authority,
               c.country_name_en AS issuing_country,
               ds.value_name_en AS doc_status,
               d.file_name, d.file_mime_type, d.notes
        FROM   hr_employee_documents d
        JOIN   dct_document_types    dt ON dt.doc_type_id   = d.doc_type_id
        LEFT JOIN dct_countries      c  ON c.country_code   = d.issuing_country_code
        LEFT JOIN dct_lookup_values  ds ON ds.value_id      = d.doc_status_id
        WHERE  d.person_id = :person_id
        ORDER  BY dt.doc_category, d.expiry_date ASC NULLS LAST
    ]');

    def_tpl('documents/');
    def_plsql('documents/', 'POST', q'[
        DECLARE v_id NUMBER; v_status_id NUMBER;
        BEGIN
            SELECT value_id INTO v_status_id
            FROM   dct_lookup_values lv
            JOIN   dct_lookup_categories lc ON lc.category_id = lv.category_id
            WHERE  lc.category_code = 'HR_DOC_STATUS' AND lv.value_code = 'VALID' AND ROWNUM = 1;

            INSERT INTO hr_employee_documents (
                person_id, doc_type_id, doc_number,
                issue_date, expiry_date, issuing_authority,
                issuing_country_code, doc_status_id,
                file_name, file_mime_type, notes, created_by
            ) VALUES (
                :person_id, :doc_type_id, :doc_number,
                TO_DATE(:issue_date,'YYYY-MM-DD'),
                TO_DATE(:expiry_date,'YYYY-MM-DD'),
                :issuing_authority, :issuing_country_code,
                NVL(:doc_status_id, v_status_id),
                :file_name, :file_mime_type, :notes,
                NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),SYS_CONTEXT('USERENV','SESSION_USER'))
            ) RETURNING doc_id INTO v_id;
            :status_code := 201;
            COMMIT;
        END;
    ]');

    -- =========================================================================
    -- REPORTS
    -- =========================================================================
    def_tpl('reports/headcount/');
    def_get('reports/headcount/', q'[
        SELECT org_id, org_name_en,
               SUM(approved_headcount) AS total_approved,
               SUM(filled_count)       AS total_filled,
               SUM(vacancy_count)      AS total_vacancies,
               ROUND(SUM(filled_count)/NULLIF(SUM(approved_headcount),0)*100,1) AS fill_rate_pct
        FROM   v_hr_headcount
        WHERE  (:org_id IS NULL OR org_id = :org_id)
        GROUP  BY org_id, org_name_en
        ORDER  BY org_name_en
    ]');

    def_tpl('reports/expiry-alerts/');
    def_get('reports/expiry-alerts/', q'[
        SELECT * FROM v_hr_expiring_docs
        WHERE  days_until_expiry <= NVL(:days, 90)
        ORDER  BY days_until_expiry ASC, full_name_en
    ]');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('HR ORDS module hr.rest published at /ords/admin/hr/');
END;
/

BEGIN
    setup_hr_ords_tmp;
END;
/

DROP PROCEDURE setup_hr_ords_tmp;

COMMIT;
PROMPT HR ORDS endpoints published under /ords/admin/hr/
