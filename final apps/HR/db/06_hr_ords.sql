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
-- Module-settings endpoints (Region Appearance + future HR settings)
CREATE OR REPLACE SYNONYM dct_module_settings       FOR prod.dct_module_settings;
CREATE OR REPLACE SYNONYM dct_modules               FOR prod.dct_modules;
CREATE OR REPLACE SYNONYM dct_rest                  FOR prod.dct_rest;
CREATE OR REPLACE SYNONYM dct_auth                  FOR prod.dct_auth;

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
          AND (:search IS NULL
               OR UPPER(e.full_name_en)    LIKE '%'||UPPER(:search)||'%'
               OR UPPER(e.employee_number) LIKE '%'||UPPER(:search)||'%'
               OR UPPER(e.email)           LIKE '%'||UPPER(:search)||'%')
        ORDER BY e.full_name_en
    ]');

    def_tpl('employees/:id');
    def_get('employees/:id', q'[
        SELECT f.*, e.created_by, e.created_at, e.updated_by, e.updated_at
        FROM   v_hr_employee_full f
        JOIN   dct_employees      e ON e.person_id = f.person_id
        WHERE  f.person_id = :id
    ]', TRUE);

    -- Photo upload (PUT base64 JSON) and download (GET media)
    def_tpl('employees/:id/photo');
    def_plsql('employees/:id/photo', 'PUT', q'[
        DECLARE
            v_blob  BLOB;
            v_raw   RAW(32767);
            v_b64   VARCHAR2(32767) := :photo_data_b64;
            v_len   NUMBER;
            v_pos   NUMBER := 1;
            v_chunk NUMBER := 32764;
        BEGIN
            DBMS_LOB.CREATETEMPORARY(v_blob, TRUE);
            v_len := LENGTH(v_b64);
            WHILE v_pos <= v_len LOOP
                v_raw := UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(SUBSTR(v_b64, v_pos, v_chunk)));
                DBMS_LOB.WRITEAPPEND(v_blob, UTL_RAW.LENGTH(v_raw), v_raw);
                v_pos := v_pos + v_chunk;
            END LOOP;
            UPDATE dct_employees SET
                photo_blob      = v_blob,
                photo_mime_type = NVL(:mime_type, 'image/jpeg'),
                photo_url       = '/ords/admin/hr/employees/' || :id || '/photo'
            WHERE person_id = :id;
            :status_code := 200;
            COMMIT;
            DBMS_LOB.FREETEMPORARY(v_blob);
        END;
    ]');
    ORDS.DEFINE_HANDLER(
        p_module_name  => c_mod,
        p_pattern      => 'employees/:id/photo',
        p_method       => 'GET',
        p_source_type  => ORDS.SOURCE_TYPE_MEDIA,
        p_source       => q'[SELECT photo_mime_type, photo_blob FROM dct_employees WHERE person_id = :id]'
    );

    def_plsql('employees/', 'POST', q'[
        DECLARE
          v_id NUMBER;
          l_actor VARCHAR2(100) := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),SYS_CONTEXT('USERENV','SESSION_USER'));
          l_new CLOB;
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
            :status_code := 201;
            COMMIT;
            l_new := dct_audit_pkg.snap('DCT_EMPLOYEES','person_id', TO_CHAR(v_id));
            dct_audit_pkg.log(l_actor,'CREATE','DCT_EMPLOYEES', TO_CHAR(v_id), 'HR', p_new=>l_new);
        END;
    ]');

    def_plsql('employees/:id', 'PUT', q'[
        DECLARE
          l_actor VARCHAR2(100) := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),SYS_CONTEXT('USERENV','SESSION_USER'));
          l_old CLOB;
          l_new CLOB;
        BEGIN
            l_old := dct_audit_pkg.snap('DCT_EMPLOYEES','person_id', TO_CHAR(:id));
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
                position_id       = NVL(:position_id,        position_id),
                job_title_en      = NVL(:job_title_en,       job_title_en),
                job_title_ar      = NVL(:job_title_ar,       job_title_ar),
                org_id            = NVL(:org_id,             org_id),
                marital_status_id = NVL(:marital_status_id,  marital_status_id),
                photo_url         = NVL(:photo_url,           photo_url),
                is_active         = NVL(:is_active,           is_active)
            WHERE person_id = :id;
            :status_code := 200;
            COMMIT;
            l_new := dct_audit_pkg.snap('DCT_EMPLOYEES','person_id', TO_CHAR(:id));
            dct_audit_pkg.log(l_actor,'UPDATE','DCT_EMPLOYEES', TO_CHAR(:id), 'HR', p_old=>l_old, p_new=>l_new);
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
    def_plsql('orgs/', 'POST', q'[
        DECLARE v_id NUMBER;
        BEGIN
            INSERT INTO dct_organizations (
                org_code, org_name_en, org_name_ar, org_type_id,
                parent_org_id, headcount_ceiling, cost_center_code, is_active,
                created_by
            ) VALUES (
                :org_code, :org_name_en, :org_name_ar,
                (SELECT value_id FROM dct_lookup_values lv
                 JOIN dct_lookup_categories lc ON lc.category_id = lv.category_id
                 WHERE lc.category_code = 'HR_ORG_TYPE' AND lv.value_code = :org_type AND ROWNUM = 1),
                :parent_org_id, :headcount_ceiling, :cost_center_code,
                NVL(:is_active,'Y'),
                NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),SYS_CONTEXT('USERENV','SESSION_USER'))
            ) RETURNING org_id INTO v_id;
            :status_code      := 201;
            :forward_location := 'orgs/' || v_id;
            COMMIT;
        END;
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

    def_tpl('orgs/:id');
    def_plsql('orgs/:id', 'PUT', q'[
        BEGIN
            UPDATE dct_organizations SET
                org_name_en       = NVL(:org_name_en,      org_name_en),
                org_name_ar       = NVL(:org_name_ar,      org_name_ar),
                org_type_id       = NVL((SELECT value_id FROM dct_lookup_values lv
                                         JOIN dct_lookup_categories lc ON lc.category_id = lv.category_id
                                         WHERE lc.category_code = 'HR_ORG_TYPE' AND lv.value_code = :org_type AND ROWNUM = 1), org_type_id),
                parent_org_id     = NVL(:parent_org_id,    parent_org_id),
                headcount_ceiling = NVL(:headcount_ceiling, headcount_ceiling),
                cost_center_code  = NVL(:cost_center_code,  cost_center_code),
                is_active         = NVL(:is_active,          is_active)
            WHERE org_id = :id;
            :status_code := 200;
            COMMIT;
        END;
    ]');

    def_tpl('orgs/:id/positions/');
    def_get('orgs/:id/positions/', q'[
        SELECT * FROM v_hr_headcount WHERE org_id = :id ORDER BY position_name_en
    ]');

    -- =========================================================================
    -- LOOKUPS
    -- =========================================================================
    def_tpl('lookups/');
    def_get('lookups/', q'[
        SELECT lc.category_id, lc.category_code, lc.category_name_en, lc.category_name_ar,
               lc.is_system, lc.is_active,
               lc.created_by, lc.created_at, lc.updated_by, lc.updated_at,
               (SELECT COUNT(*) FROM dct_lookup_values lv WHERE lv.category_id = lc.category_id AND lv.is_active = 'Y') AS value_count
        FROM   dct_lookup_categories lc
        WHERE  lc.is_active = NVL(:is_active,'Y')
        ORDER  BY lc.category_name_en
    ]');
    def_plsql('lookups/', 'POST', q'[
        DECLARE v_id NUMBER; v_cat_id NUMBER;
        BEGIN
            SELECT category_id INTO v_cat_id
            FROM   dct_lookup_categories
            WHERE  category_code = :category_code AND ROWNUM = 1;

            INSERT INTO dct_lookup_values (
                category_id, value_code, value_name_en, value_name_ar,
                display_order, is_active, created_by
            ) VALUES (
                v_cat_id, :value_code, :value_name_en, :value_name_ar,
                NVL(:display_order, 99), NVL(:is_active,'Y'),
                NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),SYS_CONTEXT('USERENV','SESSION_USER'))
            ) RETURNING value_id INTO v_id;
            :status_code := 201;
            COMMIT;
        END;
    ]');

    def_tpl('lookups/category/');
    def_plsql('lookups/category/', 'POST', q'[
        DECLARE v_id NUMBER;
        BEGIN
            INSERT INTO dct_lookup_categories (
                category_code, category_name_en, category_name_ar,
                module_id, is_system, is_active, created_by
            ) VALUES (
                UPPER(:category_code), :category_name_en, :category_name_ar,
                :module_id, 'N', NVL(:is_active,'Y'),
                NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),SYS_CONTEXT('USERENV','SESSION_USER'))
            ) RETURNING category_id INTO v_id;
            :status_code := 201;
            COMMIT;
        END;
    ]');

    def_tpl('lookups/category/:id');
    def_plsql('lookups/category/:id', 'PUT', q'[
        BEGIN
            UPDATE dct_lookup_categories SET
                category_name_en = NVL(:category_name_en, category_name_en),
                category_name_ar = NVL(:category_name_ar, category_name_ar),
                is_active        = NVL(:is_active,         is_active),
                updated_by       = NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),SYS_CONTEXT('USERENV','SESSION_USER'))
            WHERE category_id = :id;
            :status_code := 200;
            COMMIT;
        END;
    ]');

    def_tpl('lookups/:category_code');
    def_get('lookups/:category_code', q'[
        SELECT lv.value_id, lv.value_code, lv.value_name_en, lv.value_name_ar,
               lv.display_order, lv.is_active,
               lc.category_code, lc.category_name_en,
               lv.created_by, lv.created_at, lv.updated_by, lv.updated_at
        FROM   dct_lookup_values    lv
        JOIN   dct_lookup_categories lc ON lc.category_id = lv.category_id
        WHERE  lc.category_code = :category_code
          AND  lv.is_active = NVL(:is_active,'Y')
        ORDER  BY lv.display_order, lv.value_name_en
    ]');

    def_tpl('lookups/value/:id');
    def_plsql('lookups/value/:id', 'PUT', q'[
        BEGIN
            UPDATE dct_lookup_values SET
                value_name_en = NVL(:value_name_en, value_name_en),
                value_name_ar = NVL(:value_name_ar, value_name_ar),
                display_order = NVL(:display_order,  display_order),
                is_active     = NVL(:is_active,       is_active)
            WHERE value_id = :id;
            :status_code := 200;
            COMMIT;
        END;
    ]');

    -- =========================================================================
    -- POSITIONS + JOBS
    -- =========================================================================
    def_tpl('positions/');
    def_get('positions/', q'[
        SELECT hc.*, p.created_by, p.created_at, p.updated_by, p.updated_at
        FROM   v_hr_headcount hc
        JOIN   hr_positions   p ON p.position_id = hc.position_id
        WHERE  (:org_id IS NULL OR hc.org_id = :org_id)
        ORDER  BY hc.org_name_en, hc.position_name_en
    ]');
    def_plsql('positions/', 'POST', q'[
        DECLARE v_id NUMBER;
        BEGIN
            INSERT INTO hr_positions (
                position_code, position_name_en, position_name_ar,
                job_id, org_id, grade_code, location_id,
                approved_headcount, effective_from, is_active, created_by
            ) VALUES (
                :position_code, :position_name_en, :position_name_ar,
                :job_id, :org_id, :grade_code, :location_id,
                NVL(:approved_headcount, 1),
                TO_DATE(NVL(:effective_from, TO_CHAR(SYSDATE,'YYYY-MM-DD')),'YYYY-MM-DD'),
                NVL(:is_active,'Y'),
                NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),SYS_CONTEXT('USERENV','SESSION_USER'))
            ) RETURNING position_id INTO v_id;
            :status_code := 201;
            COMMIT;
        END;
    ]');

    def_tpl('positions/:id');
    def_get('positions/:id', q'[
        SELECT hc.*, p.created_by, p.created_at, p.updated_by, p.updated_at
        FROM   v_hr_headcount hc
        JOIN   hr_positions   p ON p.position_id = hc.position_id
        WHERE  hc.position_id = :id
    ]', TRUE);
    def_plsql('positions/:id', 'PUT', q'[
        BEGIN
            UPDATE hr_positions SET
                position_name_en   = NVL(:position_name_en,   position_name_en),
                position_name_ar   = NVL(:position_name_ar,   position_name_ar),
                job_id             = NVL(:job_id,             job_id),
                org_id             = NVL(:org_id,             org_id),
                grade_code         = NVL(:grade_code,         grade_code),
                location_id        = NVL(:location_id,        location_id),
                approved_headcount = NVL(:approved_headcount, approved_headcount),
                is_active          = NVL(:is_active,          is_active)
            WHERE position_id = :id;
            :status_code := 200;
            COMMIT;
        END;
    ]');

    def_tpl('jobs/');
    def_get('jobs/', q'[
        SELECT j.job_id, j.job_code, j.job_name_en, j.job_name_ar,
               j.job_family_id, f.family_name_en AS job_family,
               j.min_grade_code, j.max_grade_code,
               j.min_experience_years, j.description_en,
               j.is_active, j.effective_from, j.effective_to,
               j.created_by, j.created_at, j.updated_by, j.updated_at
        FROM   hr_jobs j
        LEFT JOIN hr_job_families f ON f.job_family_id = j.job_family_id
        WHERE  (:family_id IS NULL OR j.job_family_id = :family_id)
          AND  j.is_active = NVL(:is_active,'Y')
        ORDER  BY f.family_name_en, j.job_name_en
    ]');
    def_plsql('jobs/', 'POST', q'[
        DECLARE v_id NUMBER;
        BEGIN
            INSERT INTO hr_jobs (
                job_code, job_name_en, job_name_ar, job_family_id,
                min_grade_code, max_grade_code, min_experience_years,
                description_en, is_active, created_by
            ) VALUES (
                :job_code, :job_name_en, :job_name_ar,
                :job_family_id,
                :min_grade_code, :max_grade_code, :min_experience_years,
                :description_en, NVL(:is_active,'Y'),
                NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),SYS_CONTEXT('USERENV','SESSION_USER'))
            ) RETURNING job_id INTO v_id;
            :status_code := 201;
            COMMIT;
        END;
    ]');

    def_tpl('jobs/:id');
    def_plsql('jobs/:id', 'PUT', q'[
        BEGIN
            UPDATE hr_jobs SET
                job_name_en          = NVL(:job_name_en,          job_name_en),
                job_name_ar          = NVL(:job_name_ar,          job_name_ar),
                job_family_id        = NVL(:job_family_id,        job_family_id),
                min_grade_code       = NVL(:min_grade_code,       min_grade_code),
                max_grade_code       = NVL(:max_grade_code,       max_grade_code),
                min_experience_years = NVL(:min_experience_years, min_experience_years),
                description_en       = NVL(:description_en,       description_en),
                is_active            = NVL(:is_active,            is_active)
            WHERE job_id = :id;
            :status_code := 200;
            COMMIT;
        END;
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
    -- GRADES
    -- =========================================================================
    def_tpl('grades/');
    def_get('grades/', q'[
        SELECT g.grade_code, g.grade_name_en, g.grade_name_ar, g.grade_level,
               g.grade_category, g.salary_band_min, g.salary_band_max,
               g.display_order, g.is_active,
               g.created_by, g.created_at, g.updated_by, g.updated_at,
               (SELECT COUNT(*) FROM dct_employees e
                WHERE e.grade_code = g.grade_code AND e.is_active = 'Y') AS headcount
        FROM   dct_employee_grades g
        WHERE  (:is_active IS NULL OR g.is_active = :is_active)
        ORDER  BY g.grade_level, g.grade_code
    ]');
    def_plsql('grades/', 'POST', q'[
        BEGIN
            INSERT INTO dct_employee_grades (
                grade_code, grade_name_en, grade_name_ar, grade_level,
                grade_category, salary_band_min, salary_band_max,
                display_order, is_active, created_by
            ) VALUES (
                :grade_code, :grade_name_en, :grade_name_ar,
                NVL(:grade_level, 1), NVL(:grade_category,'GENERAL'),
                :salary_band_min, :salary_band_max,
                :display_order, NVL(:is_active,'Y'),
                NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),SYS_CONTEXT('USERENV','SESSION_USER'))
            );
            :status_code := 201;
            COMMIT;
        END;
    ]');

    def_tpl('grades/:code');
    def_plsql('grades/:code', 'PUT', q'[
        BEGIN
            UPDATE dct_employee_grades SET
                grade_name_en   = NVL(:grade_name_en,   grade_name_en),
                grade_name_ar   = NVL(:grade_name_ar,   grade_name_ar),
                grade_level     = NVL(:grade_level,     grade_level),
                grade_category  = NVL(:grade_category,  grade_category),
                salary_band_min = :salary_band_min,
                salary_band_max = :salary_band_max,
                display_order   = NVL(:display_order,   display_order),
                is_active       = NVL(:is_active,       is_active)
            WHERE grade_code = :code;
            :status_code := 200;
            COMMIT;
        END;
    ]');

    -- =========================================================================
    -- DOCUMENT TYPES
    -- =========================================================================
    def_tpl('doc-types/');
    def_get('doc-types/', q'[
        SELECT doc_type_id, doc_type_code, doc_type_name_en, doc_type_name_ar,
               doc_category, has_expiry, expiry_alert_days, is_active, display_order
        FROM   dct_document_types
        WHERE  is_active = NVL(:is_active,'Y')
        ORDER  BY doc_category, display_order, doc_type_name_en
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
               l.is_active, l.display_order,
               l.created_by, l.created_at,
               l.updated_by, l.updated_at
        FROM   hr_locations l
        LEFT JOIN dct_lookup_values  lt ON lt.value_id    = l.location_type_id
        LEFT JOIN dct_organizations  o  ON o.org_id       = l.org_id
        LEFT JOIN dct_countries      c  ON c.country_code = l.country_code
        WHERE  l.is_active = NVL(:is_active,'Y')
        ORDER  BY l.display_order, l.location_name_en
    ]');
    def_plsql('locations/', 'POST', q'[
        DECLARE v_id NUMBER;
        BEGIN
            INSERT INTO hr_locations (
                location_code, location_name_en, location_name_ar,
                emirate, city, area, building_name, floor_no,
                country_code, is_active, created_by
            ) VALUES (
                :location_code, :location_name_en, :location_name_ar,
                :emirate, :city, :area, :building_name, :floor_no,
                NVL(:country_code,'AE'), NVL(:is_active,'Y'),
                NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),SYS_CONTEXT('USERENV','SESSION_USER'))
            ) RETURNING location_id INTO v_id;
            :status_code := 201;
            COMMIT;
        END;
    ]');

    def_tpl('locations/:id');
    def_plsql('locations/:id', 'PUT', q'[
        BEGIN
            UPDATE hr_locations SET
                location_name_en = NVL(:location_name_en, location_name_en),
                location_name_ar = NVL(:location_name_ar, location_name_ar),
                emirate          = NVL(:emirate,          emirate),
                city             = NVL(:city,             city),
                area             = NVL(:area,             area),
                building_name    = NVL(:building_name,    building_name),
                floor_no         = NVL(:floor_no,         floor_no),
                country_code     = NVL(:country_code,     country_code),
                is_active        = NVL(:is_active,        is_active)
            WHERE location_id = :id;
            :status_code := 200;
            COMMIT;
        END;
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

    def_tpl('contracts/');
    def_plsql('contracts/', 'POST', q'[
        DECLARE
          v_id NUMBER; v_status_id NUMBER;
          l_actor VARCHAR2(100) := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),SYS_CONTEXT('USERENV','SESSION_USER'));
          l_new CLOB;
        BEGIN
            SELECT value_id INTO v_status_id
            FROM   dct_lookup_values lv
            JOIN   dct_lookup_categories lc ON lc.category_id = lv.category_id
            WHERE  lc.category_code = 'HR_CONTRACT_STATUS' AND lv.value_code = 'ACTIVE' AND ROWNUM = 1;

            INSERT INTO hr_employment_contracts (
                contract_number, person_id, contract_type_id,
                start_date, end_date,
                probation_months, probation_end_date,
                notice_period_days, contract_status_id,
                signed_date, remarks, created_by
            ) VALUES (
                :contract_number,
                :person_id,
                :contract_type_id,
                TO_DATE(:start_date, 'YYYY-MM-DD'),
                CASE WHEN :end_date IS NOT NULL THEN TO_DATE(:end_date, 'YYYY-MM-DD') ELSE NULL END,
                NVL(:probation_months, 3),
                ADD_MONTHS(TO_DATE(:start_date, 'YYYY-MM-DD'), NVL(:probation_months, 3)),
                NVL(:notice_period_days, 30),
                v_status_id,
                CASE WHEN :signed_date IS NOT NULL THEN TO_DATE(:signed_date, 'YYYY-MM-DD') ELSE NULL END,
                :remarks,
                NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'))
            ) RETURNING contract_id INTO v_id;
            :status_code := 201;
            COMMIT;
            l_new := dct_audit_pkg.snap('HR_EMPLOYMENT_CONTRACTS','contract_id', TO_CHAR(v_id));
            dct_audit_pkg.log(l_actor,'CREATE','HR_EMPLOYMENT_CONTRACTS', TO_CHAR(v_id), 'HR', p_new=>l_new);
        END;
    ]');

    def_tpl('contracts/update/:id');
    def_plsql('contracts/update/:id', 'PUT', q'[
        DECLARE
          l_actor VARCHAR2(100) := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),SYS_CONTEXT('USERENV','SESSION_USER'));
          l_old CLOB;
          l_new CLOB;
        BEGIN
            l_old := dct_audit_pkg.snap('HR_EMPLOYMENT_CONTRACTS','contract_id', TO_CHAR(:id));
            UPDATE hr_employment_contracts SET
                contract_type_id   = NVL(:contract_type_id,   contract_type_id),
                start_date         = NVL(TO_DATE(:start_date,  'YYYY-MM-DD'), start_date),
                end_date           = CASE WHEN :end_date   IS NOT NULL THEN TO_DATE(:end_date,   'YYYY-MM-DD') ELSE end_date   END,
                probation_months   = NVL(:probation_months,   probation_months),
                notice_period_days = NVL(:notice_period_days, notice_period_days),
                signed_date        = CASE WHEN :signed_date IS NOT NULL THEN TO_DATE(:signed_date,'YYYY-MM-DD') ELSE signed_date END,
                remarks            = NVL(:remarks,             remarks),
                updated_by         = NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'))
            WHERE contract_id = :id;
            :status_code := 200;
            COMMIT;
            l_new := dct_audit_pkg.snap('HR_EMPLOYMENT_CONTRACTS','contract_id', TO_CHAR(:id));
            dct_audit_pkg.log(l_actor,'UPDATE','HR_EMPLOYMENT_CONTRACTS', TO_CHAR(:id), 'HR', p_old=>l_old, p_new=>l_new);
        END;
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

    def_tpl('salary/');
    def_plsql('salary/', 'POST', q'[
        DECLARE
          v_id NUMBER;
          l_actor VARCHAR2(100) := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),SYS_CONTEXT('USERENV','SESSION_USER'));
          l_new CLOB;
        BEGIN
            dct_hr.update_salary(
                p_person_id        => :person_id,
                p_basic_salary     => :basic_salary,
                p_effective_date   => TO_DATE(NVL(:effective_date, TO_CHAR(SYSDATE,'YYYY-MM-DD')), 'YYYY-MM-DD'),
                p_currency_code    => NVL(:currency_code, 'AED'),
                p_change_reason_id => :change_reason_id,
                p_approved_by      => NULL,
                p_remarks          => :remarks,
                p_salary_id        => v_id
            );
            :status_code := 201;
            l_new := dct_audit_pkg.snap('HR_SALARY_HISTORY','salary_id', TO_CHAR(v_id));
            dct_audit_pkg.log(l_actor,'CREATE','HR_SALARY_HISTORY', TO_CHAR(v_id), 'HR',
                              p_object_ref=>'person '||:person_id, p_new=>l_new);
        END;
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

    def_tpl('documents/update/:id');
    def_plsql('documents/update/:id', 'PUT', q'[
        BEGIN
            UPDATE hr_employee_documents SET
                doc_number         = NVL(:doc_number,         doc_number),
                issue_date         = NVL(TO_DATE(:issue_date,'YYYY-MM-DD'), issue_date),
                expiry_date        = NVL(TO_DATE(:expiry_date,'YYYY-MM-DD'), expiry_date),
                issuing_authority  = NVL(:issuing_authority,  issuing_authority),
                notes              = NVL(:notes,              notes)
            WHERE doc_id = :id;
            :status_code := 200;
            COMMIT;
        END;
    ]');

    -- =========================================================================
    -- DOCUMENT FILE UPLOAD / DOWNLOAD
    -- =========================================================================
    def_tpl('documents/file/:id');
    -- PUT  — receive raw binary body, store as BLOB. Use :body (deref ONCE) not
    -- :body_blob, which binds as VARCHAR2 on this ORDS version (PLS-00382).
    -- No base64, no ~32 KB cap; size guarded by MAX_UPLOAD_MB (default 10).
    def_plsql('documents/file/:id', 'PUT', q'[
        DECLARE
            l_blob BLOB;
            l_len  NUMBER;
            l_max  NUMBER;
        BEGIN
            l_blob := :body;
            IF l_blob IS NULL OR DBMS_LOB.GETLENGTH(l_blob) = 0 THEN
                :status_code := 400; RETURN;
            END IF;
            l_len := DBMS_LOB.GETLENGTH(l_blob);
            BEGIN
                SELECT TO_NUMBER(ms.setting_value DEFAULT NULL ON CONVERSION ERROR)
                INTO   l_max
                FROM   dct_module_settings ms JOIN dct_modules m ON m.module_id = ms.module_id
                WHERE  m.module_code = 'HR' AND ms.setting_key = 'MAX_UPLOAD_MB';
            EXCEPTION WHEN NO_DATA_FOUND THEN l_max := NULL; END;
            l_max := NVL(l_max, 10);
            IF l_len > l_max * 1024 * 1024 THEN :status_code := 413; RETURN; END IF;
            UPDATE hr_employee_documents SET
                file_blob      = l_blob,
                file_name      = NVL(:file_name,      file_name),
                file_mime_type = NVL(:file_mime_type,  file_mime_type),
                updated_by     = NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),SYS_CONTEXT('USERENV','SESSION_USER'))
            WHERE doc_id = :id;
            IF SQL%ROWCOUNT = 0 THEN :status_code := 404; RETURN; END IF;
            :status_code := 200;
            COMMIT;
        END;
    ]');
    -- GET  — stream the stored BLOB back with its original MIME type
    ORDS.DEFINE_HANDLER(
        p_module_name  => c_mod,
        p_pattern      => 'documents/file/:id',
        p_method       => 'GET',
        p_source_type  => ORDS.SOURCE_TYPE_MEDIA,
        p_source       => q'[SELECT file_mime_type, file_blob FROM hr_employee_documents WHERE doc_id = :id]'
    );

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

    -- =========================================================================
    -- MODULE SETTINGS (Region Appearance + any future HR module settings)
    -- Mirrors the CC/FL/PC/DT settings endpoints: reads DCT_MODULE_SETTINGS for
    -- module_code 'HR'; PUT is HR_ADMIN/SYS_ADMIN only. THEME_REGION_* rows are
    -- seeded for every module by db/v2/22_region_theme.sql.
    -- =========================================================================
    def_tpl('settings');
    def_plsql('settings', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT ms.setting_id, ms.setting_key, ms.setting_value, ms.setting_label,
           ms.setting_description, ms.value_type, ms.allowed_values, ms.default_value
    FROM   dct_module_settings ms
    JOIN   dct_modules m ON m.module_id = ms.module_id
    WHERE  m.module_code = 'HR'
    ORDER BY ms.setting_key
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('settingId',    r.setting_id);
    APEX_JSON.write('key',          r.setting_key);
    APEX_JSON.write('value',        r.setting_value);
    APEX_JSON.write('label',        NVL(r.setting_label, r.setting_key));
    APEX_JSON.write('description',  NVL(r.setting_description, ''));
    APEX_JSON.write('type',         NVL(r.value_type, 'TEXT'));
    APEX_JSON.write('allowed',      NVL(r.allowed_values, ''));
    APEX_JSON.write('defaultValue', NVL(r.default_value, ''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    def_tpl('settings/:id');
    def_plsql('settings/:id', 'PUT', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'HR_ADMIN') AND NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only HR Admin can change module settings'); RETURN;
  END IF;
  dct_rest.parse_body(:body);
  UPDATE dct_module_settings SET
    setting_value = APEX_JSON.get_varchar2(p_path => 'value'),
    updated_at    = SYSTIMESTAMP
  WHERE setting_id = :id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
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
