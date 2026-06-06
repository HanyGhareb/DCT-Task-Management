-- =============================================================================
-- i-Finance V2 — HR Module: Seed Data
-- File    : 04_hr_seed.sql
-- Schema  : PROD
-- =============================================================================
-- Inserts:
--   A. Lookup categories + values (9 HR_ categories)
--   B. Patch DCT_ORGANIZATIONS.org_type_id from existing org_type varchar
--   C. Sample HR_LOCATIONS (DCT headquarters)
--   D. Sample HR_JOB_FAMILIES + HR_JOBS (Finance Division)
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- A. LOOKUP CATEGORIES
-- =============================================================================
-- Declare the HR module_id variable for category inserts
DECLARE
    v_module_id NUMBER;
BEGIN
    SELECT module_id INTO v_module_id
    FROM   dct_modules
    WHERE  module_code = 'HR';

    -- -------------------------------------------------------------------------
    -- A1. HR_ORG_TYPE — organisation unit type (replaces chk_dct_org_type)
    -- -------------------------------------------------------------------------
    INSERT INTO dct_lookup_categories (category_code, category_name_en, category_name_ar, module_id, is_system, created_by)
    VALUES ('HR_ORG_TYPE', 'Organisation Unit Type', 'نوع الوحدة التنظيمية', v_module_id, 'Y', 'SYSTEM');

    -- -------------------------------------------------------------------------
    -- A2. HR_LOCATION_TYPE — physical location classification
    -- -------------------------------------------------------------------------
    INSERT INTO dct_lookup_categories (category_code, category_name_en, category_name_ar, module_id, is_system, created_by)
    VALUES ('HR_LOCATION_TYPE', 'Location Type', 'نوع الموقع', v_module_id, 'Y', 'SYSTEM');

    -- -------------------------------------------------------------------------
    -- A3. HR_POSITION_TYPE — position budget classification
    -- -------------------------------------------------------------------------
    INSERT INTO dct_lookup_categories (category_code, category_name_en, category_name_ar, module_id, is_system, created_by)
    VALUES ('HR_POSITION_TYPE', 'Position Type', 'نوع المنصب', v_module_id, 'Y', 'SYSTEM');

    -- -------------------------------------------------------------------------
    -- A4. HR_ASSIGNMENT_TYPE — nature of the assignment
    -- -------------------------------------------------------------------------
    INSERT INTO dct_lookup_categories (category_code, category_name_en, category_name_ar, module_id, is_system, created_by)
    VALUES ('HR_ASSIGNMENT_TYPE', 'Assignment Type', 'نوع التكليف', v_module_id, 'Y', 'SYSTEM');

    -- -------------------------------------------------------------------------
    -- A5. HR_END_REASON — why an assignment ended
    -- -------------------------------------------------------------------------
    INSERT INTO dct_lookup_categories (category_code, category_name_en, category_name_ar, module_id, is_system, created_by)
    VALUES ('HR_END_REASON', 'Assignment End Reason', 'سبب انتهاء التكليف', v_module_id, 'Y', 'SYSTEM');

    -- -------------------------------------------------------------------------
    -- A6. HR_CONTRACT_TYPE — employment contract classification
    -- -------------------------------------------------------------------------
    INSERT INTO dct_lookup_categories (category_code, category_name_en, category_name_ar, module_id, is_system, created_by)
    VALUES ('HR_CONTRACT_TYPE', 'Contract Type', 'نوع العقد', v_module_id, 'Y', 'SYSTEM');

    -- -------------------------------------------------------------------------
    -- A7. HR_CONTRACT_STATUS — lifecycle status of a contract
    -- -------------------------------------------------------------------------
    INSERT INTO dct_lookup_categories (category_code, category_name_en, category_name_ar, module_id, is_system, created_by)
    VALUES ('HR_CONTRACT_STATUS', 'Contract Status', 'حالة العقد', v_module_id, 'Y', 'SYSTEM');

    -- -------------------------------------------------------------------------
    -- A8. HR_SALARY_REASON — reason for a salary change event
    -- -------------------------------------------------------------------------
    INSERT INTO dct_lookup_categories (category_code, category_name_en, category_name_ar, module_id, is_system, created_by)
    VALUES ('HR_SALARY_REASON', 'Salary Change Reason', 'سبب تغيير الراتب', v_module_id, 'Y', 'SYSTEM');

    -- -------------------------------------------------------------------------
    -- A9. HR_DOC_STATUS — status of an employee document
    -- -------------------------------------------------------------------------
    INSERT INTO dct_lookup_categories (category_code, category_name_en, category_name_ar, module_id, is_system, created_by)
    VALUES ('HR_DOC_STATUS', 'Document Status', 'حالة الوثيقة', v_module_id, 'Y', 'SYSTEM');

    -- -------------------------------------------------------------------------
    -- A10. HR_MARITAL_STATUS — employee marital status
    -- -------------------------------------------------------------------------
    INSERT INTO dct_lookup_categories (category_code, category_name_en, category_name_ar, module_id, is_system, created_by)
    VALUES ('HR_MARITAL_STATUS', 'Marital Status', 'الحالة الاجتماعية', v_module_id, 'Y', 'SYSTEM');

    COMMIT;
END;
/

-- =============================================================================
-- A. LOOKUP VALUES
-- =============================================================================
DECLARE
    PROCEDURE ins_lv (
        p_cat_code   VARCHAR2,
        p_val_code   VARCHAR2,
        p_name_en    VARCHAR2,
        p_name_ar    VARCHAR2,
        p_order      NUMBER
    ) IS
        v_cat_id NUMBER;
    BEGIN
        SELECT category_id INTO v_cat_id
        FROM   dct_lookup_categories
        WHERE  category_code = p_cat_code;

        INSERT INTO dct_lookup_values (category_id, value_code, value_name_en, value_name_ar, display_order, created_by)
        VALUES (v_cat_id, p_val_code, p_name_en, p_name_ar, p_order, 'SYSTEM');
    END;
BEGIN
    -- HR_ORG_TYPE
    ins_lv('HR_ORG_TYPE', 'AUTHORITY',      'Authority',          'هيئة',                    10);
    ins_lv('HR_ORG_TYPE', 'DIVISION',       'Division',           'دائرة',                   20);
    ins_lv('HR_ORG_TYPE', 'DEPARTMENT',     'Department',         'قسم',                     30);
    ins_lv('HR_ORG_TYPE', 'SECTION',        'Section',            'شعبة',                    40);
    ins_lv('HR_ORG_TYPE', 'UNIT',           'Unit',               'وحدة',                    50);
    ins_lv('HR_ORG_TYPE', 'TEAM',           'Team',               'فريق',                    60);
    ins_lv('HR_ORG_TYPE', 'COMMITTEE',      'Committee',          'لجنة',                    70);
    ins_lv('HR_ORG_TYPE', 'PROJECT_OFFICE', 'Project Office',     'مكتب مشروع',              80);
    ins_lv('HR_ORG_TYPE', 'EXTERNAL',       'External Entity',    'جهة خارجية',              90);

    -- HR_LOCATION_TYPE
    ins_lv('HR_LOCATION_TYPE', 'HQ',          'Headquarters',     'المقر الرئيسي',           10);
    ins_lv('HR_LOCATION_TYPE', 'BRANCH',      'Branch Office',    'مكتب فرعي',               20);
    ins_lv('HR_LOCATION_TYPE', 'REMOTE',      'Remote / Home',    'عمل عن بُعد',             30);
    ins_lv('HR_LOCATION_TYPE', 'FIELD',       'Field Site',       'موقع ميداني',             40);
    ins_lv('HR_LOCATION_TYPE', 'DATA_CENTER', 'Data Center',      'مركز البيانات',           50);

    -- HR_POSITION_TYPE
    ins_lv('HR_POSITION_TYPE', 'PERMANENT',   'Permanent',        'دائم',                    10);
    ins_lv('HR_POSITION_TYPE', 'TEMPORARY',   'Temporary',        'مؤقت',                    20);
    ins_lv('HR_POSITION_TYPE', 'SECONDMENT',  'Secondment',       'إعارة',                   30);

    -- HR_ASSIGNMENT_TYPE
    ins_lv('HR_ASSIGNMENT_TYPE', 'PRIMARY',    'Primary',         'أساسي',                   10);
    ins_lv('HR_ASSIGNMENT_TYPE', 'ACTING',     'Acting',          'بالإنابة',                20);
    ins_lv('HR_ASSIGNMENT_TYPE', 'SECONDMENT', 'Secondment',      'معار',                    30);
    ins_lv('HR_ASSIGNMENT_TYPE', 'DUAL',       'Dual Role',       'دور مزدوج',               40);

    -- HR_END_REASON
    ins_lv('HR_END_REASON', 'TRANSFER',         'Transfer',            'نقل',                10);
    ins_lv('HR_END_REASON', 'PROMOTION',         'Promotion',          'ترقية',               20);
    ins_lv('HR_END_REASON', 'LATERAL_TRANSFER',  'Lateral Transfer',   'نقل أفقي',            30);
    ins_lv('HR_END_REASON', 'RESIGNATION',       'Resignation',        'استقالة',             40);
    ins_lv('HR_END_REASON', 'RETIREMENT',        'Retirement',         'تقاعد',               50);
    ins_lv('HR_END_REASON', 'TERMINATION',       'Termination',        'إنهاء خدمة',          60);
    ins_lv('HR_END_REASON', 'CONTRACT_END',      'Contract End',       'انتهاء العقد',        70);
    ins_lv('HR_END_REASON', 'RESTRUCTURING',     'Restructuring',      'إعادة هيكلة',         80);

    -- HR_CONTRACT_TYPE
    ins_lv('HR_CONTRACT_TYPE', 'PERMANENT',    'Permanent',           'دائم',                 10);
    ins_lv('HR_CONTRACT_TYPE', 'FIXED_TERM',   'Fixed Term',          'محدد المدة',           20);
    ins_lv('HR_CONTRACT_TYPE', 'SECONDMENT',   'Secondment',          'إعارة',                30);
    ins_lv('HR_CONTRACT_TYPE', 'INTERNSHIP',   'Internship',          'تدريب',                40);
    ins_lv('HR_CONTRACT_TYPE', 'CONSULTANT',   'Consultant',          'استشاري',              50);

    -- HR_CONTRACT_STATUS
    ins_lv('HR_CONTRACT_STATUS', 'ACTIVE',     'Active',              'ساري',                 10);
    ins_lv('HR_CONTRACT_STATUS', 'EXPIRED',    'Expired',             'منتهي',                20);
    ins_lv('HR_CONTRACT_STATUS', 'TERMINATED', 'Terminated',          'مُنهى',                30);
    ins_lv('HR_CONTRACT_STATUS', 'CANCELLED',  'Cancelled',           'ملغى',                 40);

    -- HR_SALARY_REASON
    ins_lv('HR_SALARY_REASON', 'HIRE',              'Initial Hire',          'تعيين',          10);
    ins_lv('HR_SALARY_REASON', 'PROMOTION',          'Promotion',            'ترقية',          20);
    ins_lv('HR_SALARY_REASON', 'ANNUAL_INCREMENT',   'Annual Increment',     'زيادة سنوية',    30);
    ins_lv('HR_SALARY_REASON', 'MARKET_ADJUSTMENT',  'Market Adjustment',    'تعديل السوق',    40);
    ins_lv('HR_SALARY_REASON', 'ACTING_ALLOWANCE',   'Acting Allowance',     'بدل إنابة',      50);
    ins_lv('HR_SALARY_REASON', 'DEMOTION',            'Demotion',            'تخفيض الدرجة',   60);
    ins_lv('HR_SALARY_REASON', 'CORRECTION',          'Correction',          'تصحيح',          70);

    -- HR_DOC_STATUS
    ins_lv('HR_DOC_STATUS', 'VALID',               'Valid',                 'ساري',            10);
    ins_lv('HR_DOC_STATUS', 'EXPIRED',             'Expired',               'منتهي',           20);
    ins_lv('HR_DOC_STATUS', 'RENEWAL_IN_PROGRESS', 'Renewal In Progress',   'قيد التجديد',     30);
    ins_lv('HR_DOC_STATUS', 'CANCELLED',           'Cancelled',             'ملغى',            40);

    -- HR_MARITAL_STATUS
    ins_lv('HR_MARITAL_STATUS', 'SINGLE',    'Single',    'أعزب',           10);
    ins_lv('HR_MARITAL_STATUS', 'MARRIED',   'Married',   'متزوج',          20);
    ins_lv('HR_MARITAL_STATUS', 'DIVORCED',  'Divorced',  'مطلق',           30);
    ins_lv('HR_MARITAL_STATUS', 'WIDOWED',   'Widowed',   'أرمل',           40);

    COMMIT;
END;
/

-- =============================================================================
-- B. PATCH DCT_ORGANIZATIONS — populate org_type_id from existing org_type varchar
--    Maps the existing hard-coded values to the new lookup rows.
--    After this patch, new code should write to org_type_id; the varchar
--    org_type column is left in place for backward compatibility.
-- =============================================================================
BEGIN
    FOR rec IN (
        SELECT lv.value_id, lv.value_code
        FROM   dct_lookup_values lv
        JOIN   dct_lookup_categories lc ON lc.category_id = lv.category_id
        WHERE  lc.category_code = 'HR_ORG_TYPE'
    ) LOOP
        UPDATE dct_organizations
        SET    org_type_id = rec.value_id
        WHERE  UPPER(org_type) = rec.value_code;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('DCT_ORGANIZATIONS.org_type_id patched from varchar values.');
END;
/

-- =============================================================================
-- C. SAMPLE HR_LOCATIONS — DCT Abu Dhabi HQ
-- =============================================================================
INSERT INTO hr_locations (
    location_code, location_name_en, location_name_ar,
    location_type_id,
    country_code, emirate, city, area,
    building_name, is_active, display_order, created_by
)
SELECT
    'AUH-HQ',
    'Abu Dhabi Headquarters',
    'المقر الرئيسي - أبوظبي',
    (SELECT value_id FROM dct_lookup_values lv
     JOIN dct_lookup_categories lc ON lc.category_id = lv.category_id
     WHERE lc.category_code = 'HR_LOCATION_TYPE' AND lv.value_code = 'HQ'),
    'AE', 'Abu Dhabi', 'Abu Dhabi', 'Al Bateen',
    'DCT Headquarters Building',
    'Y', 10, 'SYSTEM'
FROM dual;

INSERT INTO hr_locations (
    location_code, location_name_en, location_name_ar,
    location_type_id,
    country_code, emirate, city,
    building_name, is_active, display_order, created_by
)
SELECT
    'AUH-BR1',
    'Abu Dhabi Branch Office 1',
    'مكتب فرعي 1 - أبوظبي',
    (SELECT value_id FROM dct_lookup_values lv
     JOIN dct_lookup_categories lc ON lc.category_id = lv.category_id
     WHERE lc.category_code = 'HR_LOCATION_TYPE' AND lv.value_code = 'BRANCH'),
    'AE', 'Abu Dhabi', 'Abu Dhabi',
    'Al Maryah Island Office',
    'Y', 20, 'SYSTEM'
FROM dual;

COMMIT;

-- =============================================================================
-- D. SAMPLE HR_JOB_FAMILIES
--    Individual INSERTs required — INSERT ALL + GENERATED ALWAYS AS IDENTITY
--    causes ORA-00001 duplicate identity values on Oracle 23ai.
-- =============================================================================
INSERT INTO hr_job_families (family_code, family_name_en, family_name_ar, description_en, is_active, display_order, created_by)
VALUES ('FINANCE',    'Finance',                'المالية',             'Financial management and accounting roles',       'Y', 10, 'SYSTEM');
INSERT INTO hr_job_families (family_code, family_name_en, family_name_ar, description_en, is_active, display_order, created_by)
VALUES ('IT',         'Information Technology', 'تقنية المعلومات',     'Systems, infrastructure, and digital roles',     'Y', 20, 'SYSTEM');
INSERT INTO hr_job_families (family_code, family_name_en, family_name_ar, description_en, is_active, display_order, created_by)
VALUES ('HR_FAM',     'Human Resources',        'الموارد البشرية',     'People management and HR operations',            'Y', 30, 'SYSTEM');
INSERT INTO hr_job_families (family_code, family_name_en, family_name_ar, description_en, is_active, display_order, created_by)
VALUES ('LEGAL',      'Legal',                  'الشؤون القانونية',    'Legal, compliance, and governance roles',        'Y', 40, 'SYSTEM');
INSERT INTO hr_job_families (family_code, family_name_en, family_name_ar, description_en, is_active, display_order, created_by)
VALUES ('OPERATIONS', 'Operations',             'العمليات',            'General operations and administrative roles',    'Y', 50, 'SYSTEM');
INSERT INTO hr_job_families (family_code, family_name_en, family_name_ar, description_en, is_active, display_order, created_by)
VALUES ('STRATEGY',   'Strategy',               'الاستراتيجية',        'Planning, strategy, and performance roles',      'Y', 60, 'SYSTEM');

COMMIT;

-- =============================================================================
-- D. SAMPLE HR_JOBS (Finance Division jobs)
-- =============================================================================
DECLARE
    v_fin   NUMBER;
    v_ops   NUMBER;
    v_hr    NUMBER;
    v_it    NUMBER;
    v_leg   NUMBER;
    v_str   NUMBER;
BEGIN
    SELECT job_family_id INTO v_fin FROM hr_job_families WHERE family_code = 'FINANCE';
    SELECT job_family_id INTO v_ops FROM hr_job_families WHERE family_code = 'OPERATIONS';
    SELECT job_family_id INTO v_hr  FROM hr_job_families WHERE family_code = 'HR_FAM';
    SELECT job_family_id INTO v_it  FROM hr_job_families WHERE family_code = 'IT';
    SELECT job_family_id INTO v_leg FROM hr_job_families WHERE family_code = 'LEGAL';
    SELECT job_family_id INTO v_str FROM hr_job_families WHERE family_code = 'STRATEGY';

    -- Finance Division jobs
    INSERT INTO hr_jobs (job_code, job_name_en, job_name_ar, job_family_id, min_grade_code, max_grade_code, is_active, effective_from, created_by)
    VALUES ('FIN-DIR',    'Finance Director',            'مدير مالي',                    v_fin, 'E2', 'E1', 'Y', DATE '2024-01-01', 'SYSTEM');

    INSERT INTO hr_jobs (job_code, job_name_en, job_name_ar, job_family_id, min_grade_code, max_grade_code, is_active, effective_from, created_by)
    VALUES ('FIN-MGR',    'Finance Manager',             'مدير تمويل',                   v_fin, 'E3', 'E4', 'Y', DATE '2024-01-01', 'SYSTEM');

    INSERT INTO hr_jobs (job_code, job_name_en, job_name_ar, job_family_id, min_grade_code, max_grade_code, min_experience_years, is_active, effective_from, created_by)
    VALUES ('FIN-SR-ANL', 'Senior Financial Analyst',   'محلل مالي أول',                v_fin, 'P1', 'P2', 5, 'Y', DATE '2024-01-01', 'SYSTEM');

    INSERT INTO hr_jobs (job_code, job_name_en, job_name_ar, job_family_id, min_grade_code, max_grade_code, min_experience_years, is_active, effective_from, created_by)
    VALUES ('FIN-ANL',    'Financial Analyst',           'محلل مالي',                    v_fin, 'P2', 'P3', 2, 'Y', DATE '2024-01-01', 'SYSTEM');

    INSERT INTO hr_jobs (job_code, job_name_en, job_name_ar, job_family_id, min_grade_code, max_grade_code, is_active, effective_from, created_by)
    VALUES ('FIN-ACCT',   'Accountant',                 'محاسب',                        v_fin, 'P3', 'T1', 'Y', DATE '2024-01-01', 'SYSTEM');

    INSERT INTO hr_jobs (job_code, job_name_en, job_name_ar, job_family_id, min_grade_code, max_grade_code, is_active, effective_from, created_by)
    VALUES ('FIN-BUDBP',  'Budget Planning Specialist', 'متخصص تخطيط الميزانية',        v_fin, 'P2', 'P1', 'Y', DATE '2024-01-01', 'SYSTEM');

    INSERT INTO hr_jobs (job_code, job_name_en, job_name_ar, job_family_id, min_grade_code, max_grade_code, is_active, effective_from, created_by)
    VALUES ('FIN-TRES',   'Treasury Specialist',        'متخصص الخزينة',                v_fin, 'P2', 'P1', 'Y', DATE '2024-01-01', 'SYSTEM');

    INSERT INTO hr_jobs (job_code, job_name_en, job_name_ar, job_family_id, min_grade_code, max_grade_code, is_active, effective_from, created_by)
    VALUES ('FIN-AUD',    'Internal Auditor',           'مدقق داخلي',                   v_fin, 'P2', 'P1', 'Y', DATE '2024-01-01', 'SYSTEM');

    INSERT INTO hr_jobs (job_code, job_name_en, job_name_ar, job_family_id, min_grade_code, max_grade_code, is_active, effective_from, created_by)
    VALUES ('FIN-PAY',    'Payables Officer',           'موظف المستحقات',               v_fin, 'P3', 'T1', 'Y', DATE '2024-01-01', 'SYSTEM');

    INSERT INTO hr_jobs (job_code, job_name_en, job_name_ar, job_family_id, min_grade_code, max_grade_code, is_active, effective_from, created_by)
    VALUES ('FIN-REC',    'Receivables Officer',        'موظف المطالبات',               v_fin, 'P3', 'T1', 'Y', DATE '2024-01-01', 'SYSTEM');

    -- Operations / Admin
    INSERT INTO hr_jobs (job_code, job_name_en, job_name_ar, job_family_id, min_grade_code, max_grade_code, is_active, effective_from, created_by)
    VALUES ('OPS-ADMIN',  'Administrative Officer',     'موظف إداري',                   v_ops, 'T1', 'S1', 'Y', DATE '2024-01-01', 'SYSTEM');

    INSERT INTO hr_jobs (job_code, job_name_en, job_name_ar, job_family_id, min_grade_code, max_grade_code, is_active, effective_from, created_by)
    VALUES ('OPS-EXEC',   'Executive Secretary',        'سكرتير تنفيذي',                v_ops, 'P3', 'T1', 'Y', DATE '2024-01-01', 'SYSTEM');

    -- IT
    INSERT INTO hr_jobs (job_code, job_name_en, job_name_ar, job_family_id, min_grade_code, max_grade_code, is_active, effective_from, created_by)
    VALUES ('IT-DEV',     'Systems Developer',          'مطور أنظمة',                   v_it,  'P2', 'P1', 'Y', DATE '2024-01-01', 'SYSTEM');

    INSERT INTO hr_jobs (job_code, job_name_en, job_name_ar, job_family_id, min_grade_code, max_grade_code, is_active, effective_from, created_by)
    VALUES ('IT-DBA',     'Database Administrator',     'مسؤول قواعد البيانات',         v_it,  'P1', 'E4', 'Y', DATE '2024-01-01', 'SYSTEM');

    -- HR
    INSERT INTO hr_jobs (job_code, job_name_en, job_name_ar, job_family_id, min_grade_code, max_grade_code, is_active, effective_from, created_by)
    VALUES ('HR-SPEC',    'HR Specialist',              'متخصص موارد بشرية',            v_hr,  'P2', 'P1', 'Y', DATE '2024-01-01', 'SYSTEM');

    -- Legal
    INSERT INTO hr_jobs (job_code, job_name_en, job_name_ar, job_family_id, min_grade_code, max_grade_code, is_active, effective_from, created_by)
    VALUES ('LEG-COMP',   'Compliance Officer',         'موظف الامتثال',                v_leg, 'P2', 'P1', 'Y', DATE '2024-01-01', 'SYSTEM');

    -- Strategy
    INSERT INTO hr_jobs (job_code, job_name_en, job_name_ar, job_family_id, min_grade_code, max_grade_code, is_active, effective_from, created_by)
    VALUES ('STR-PERF',   'Performance Management Specialist', 'متخصص إدارة الأداء',   v_str, 'P2', 'P1', 'Y', DATE '2024-01-01', 'SYSTEM');

    COMMIT;
END;
/

PROMPT HR seed data complete.
PROMPT   - 10 lookup categories + values seeded
PROMPT   - DCT_ORGANIZATIONS.org_type_id patched
PROMPT   - 2 sample locations created
PROMPT   - 6 job families + 17 jobs created
