-- =============================================================================
-- Outsource Payroll Module (App 215) -- Seed -- Phase 2 Workforce
-- File    : 10_pay_phase2_seed.sql
-- Schema  : PROD (data only)
-- Run     : sql -name prod_mcp (UTF-8: JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8)
-- Notes   : Re-runnable (update-else-insert, no MERGE). Seeds the Phase 2
--           lookup vocabularies, the entry roles PAY_HR_ENTRY and
--           PAY_PAYROLL_ENTRY, the employee module settings and the
--           PAY_EMPLOYEE document checklist on the shared doc tables.
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- 1. LOOKUP CATEGORIES + VALUES
-- =============================================================================
DECLARE
    v_cat NUMBER;

    PROCEDURE up_cat (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, o_id OUT NUMBER) IS
    BEGIN
        UPDATE prod.dct_lookup_categories
           SET category_name_en = p_en, category_name_ar = p_ar
         WHERE category_code = p_code;
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO prod.dct_lookup_categories
                   (category_code, category_name_en, category_name_ar, module_id, is_system, is_active)
            VALUES (p_code, p_en, p_ar, NULL, 'Y', 'Y');
        END IF;
        SELECT category_id INTO o_id FROM prod.dct_lookup_categories WHERE category_code = p_code;
    END;

    PROCEDURE up_val (p_cat NUMBER, p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2,
                      p_ord NUMBER, p_default VARCHAR2 DEFAULT 'N') IS
    BEGIN
        UPDATE prod.dct_lookup_values
           SET value_name_en = p_en, value_name_ar = p_ar, display_order = p_ord
         WHERE category_id = p_cat AND value_code = p_code;
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO prod.dct_lookup_values
                   (category_id, value_code, value_name_en, value_name_ar, display_order, is_default, is_active)
            VALUES (p_cat, p_code, p_en, p_ar, p_ord, p_default, 'Y');
        END IF;
    END;
BEGIN
    up_cat('EMPLOYEE_TYPE', 'Employee Type', 'نوع الموظف', v_cat);
    up_val(v_cat, 'INTERNAL',  'Internal (Direct Hire)', 'داخلي (تعيين مباشر)', 10, 'Y');
    up_val(v_cat, 'OUTSOURCE', 'Outsourced',             'إسناد خارجي',         20);

    up_cat('PAY_ASSIGNMENT_TYPE', 'Assignment Type', 'نوع التكليف', v_cat);
    up_val(v_cat, 'PRIMARY',    'Primary',    'أساسي',   10, 'Y');
    up_val(v_cat, 'CONCURRENT', 'Concurrent', 'متزامن',  20);

    up_cat('PAY_ASSIGNMENT_STATUS', 'Assignment Status', 'حالة التكليف', v_cat);
    up_val(v_cat, 'ACTIVE',    'Active',    'نشط',    10, 'Y');
    up_val(v_cat, 'SUSPENDED', 'Suspended', 'موقوف',  20);
    up_val(v_cat, 'ENDED',     'Ended',     'منتهي',  30);

    up_cat('PAY_PEOPLE_GROUP', 'People Group', 'مجموعة الموظفين', v_cat);
    up_val(v_cat, 'GENERAL',   'General',                'عام',        10, 'Y');
    up_val(v_cat, 'TECHNICAL', 'Technical',              'فني',        20);
    up_val(v_cat, 'SUPPORT',   'Administrative Support', 'دعم إداري',  30);

    up_cat('PAY_EVENT_TYPE', 'Employee Lifecycle Event', 'حدث دورة حياة الموظف', v_cat);
    up_val(v_cat, 'HIRE',      'Hire',      'تعيين',         10, 'Y');
    up_val(v_cat, 'TRANSFER',  'Transfer',  'نقل',           20);
    up_val(v_cat, 'SUSPEND',   'Suspend',   'إيقاف',         30);
    up_val(v_cat, 'RESUME',    'Resume',    'استئناف',       40);
    up_val(v_cat, 'TERMINATE', 'Terminate', 'إنهاء خدمة',    50);
    up_val(v_cat, 'REHIRE',    'Rehire',    'إعادة تعيين',   60);

    up_cat('PAY_EVENT_REASON', 'Lifecycle Event Reason', 'سبب حدث دورة الحياة', v_cat);
    up_val(v_cat, 'NEW_HIRE',        'New hire',                 'تعيين جديد',                 10, 'Y');
    up_val(v_cat, 'CONTRACT_MOVE',   'Contract / company move',  'نقل بين العقود أو الشركات',  20);
    up_val(v_cat, 'DEPT_MOVE',       'Department move',          'نقل بين الإدارات',           30);
    up_val(v_cat, 'UNPAID_LEAVE',    'Unpaid leave',             'إجازة بدون راتب',            40);
    up_val(v_cat, 'DISCIPLINARY',    'Disciplinary action',      'إجراء تأديبي',               50);
    up_val(v_cat, 'RESIGNATION',     'Resignation',              'استقالة',                    60);
    up_val(v_cat, 'END_OF_CONTRACT', 'End of contract',          'انتهاء العقد',               70);
    up_val(v_cat, 'PERFORMANCE',     'Performance',              'الأداء',                     80);
    up_val(v_cat, 'REDUNDANCY',      'Role no longer required',  'إلغاء الوظيفة',              90);
    up_val(v_cat, 'RETURN',          'Return / rehire',          'عودة / إعادة تعيين',        100);
    up_val(v_cat, 'OTHER',           'Other',                    'أخرى',                      900);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Lookup sets seeded: EMPLOYEE_TYPE + 5 PAY_* Phase 2 categories');
END;
/

-- =============================================================================
-- 2. ENTRY ROLES + PERMISSIONS -- PAY_HR_ENTRY, PAY_PAYROLL_ENTRY
-- =============================================================================
DECLARE
    v_module_id   prod.dct_modules.module_id%TYPE;
    v_admin_role  NUMBER;
    v_hr_role     NUMBER;
    v_pr_role     NUMBER;

    PROCEDURE up_role (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, p_desc VARCHAR2,
                       p_ord NUMBER, o_id OUT NUMBER) IS
    BEGIN
        UPDATE prod.dct_roles
           SET role_name_en = p_en, role_name_ar = p_ar,
               description_en = p_desc, is_active = 'Y'
         WHERE role_code = p_code;
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO prod.dct_roles
                   (role_code, role_name_en, role_name_ar, role_type, module_id,
                    description_en, is_active, is_system_role, display_order)
            VALUES (p_code, p_en, p_ar, 'MODULE', v_module_id, p_desc, 'Y', 'N', p_ord);
        END IF;
        SELECT role_id INTO o_id FROM prod.dct_roles WHERE role_code = p_code;
    END;

    PROCEDURE grant_perm (p_role_id NUMBER, p_code VARCHAR2, p_name VARCHAR2, p_action VARCHAR2) IS
        l_perm_id NUMBER;
    BEGIN
        UPDATE prod.dct_permissions
           SET permission_name = p_name, action_type = p_action
         WHERE permission_code = p_code;
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO prod.dct_permissions
                   (permission_code, permission_name, module_id, action_type, is_active)
            VALUES (p_code, p_name, v_module_id, p_action, 'Y');
        END IF;
        SELECT permission_id INTO l_perm_id FROM prod.dct_permissions WHERE permission_code = p_code;
        BEGIN
            INSERT INTO prod.dct_role_permissions (role_id, permission_id, granted_by)
            VALUES (p_role_id, l_perm_id, 'SEED');
        EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
        END;
    END;
BEGIN
    SELECT module_id INTO v_module_id FROM prod.dct_modules WHERE module_code = 'PAY';
    SELECT role_id INTO v_admin_role FROM prod.dct_roles WHERE role_code = 'PAY_ADMIN';

    up_role('PAY_HR_ENTRY', 'Outsource Payroll HR Entry', 'مدخل بيانات الموارد البشرية - الإسناد الخارجي',
            'Maintain outsourced employee personal data, assignments, documents and lifecycle events.', 12, v_hr_role);
    up_role('PAY_PAYROLL_ENTRY', 'Outsource Payroll Entry', 'مدخل بيانات الرواتب - الإسناد الخارجي',
            'Maintain outsourced employee bank details and payroll-side employee data.', 14, v_pr_role);

    grant_perm(v_hr_role,    'PAY.MANAGE_EMPLOYEES', 'Manage outsourced employees, assignments and lifecycle', 'CONFIGURE');
    grant_perm(v_pr_role,    'PAY.MANAGE_EMP_BANKS', 'Manage outsourced employee bank details',                'CONFIGURE');
    grant_perm(v_admin_role, 'PAY.MANAGE_EMPLOYEES', 'Manage outsourced employees, assignments and lifecycle', 'CONFIGURE');
    grant_perm(v_admin_role, 'PAY.MANAGE_EMP_BANKS', 'Manage outsourced employee bank details',                'CONFIGURE');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Entry roles seeded: PAY_HR_ENTRY, PAY_PAYROLL_ENTRY (+2 permissions, PAY_ADMIN granted both)');
END;
/

-- =============================================================================
-- 3. MODULE SETTINGS -- employee numbering + doc alert window
-- =============================================================================
DECLARE
    v_module_id prod.dct_modules.module_id%TYPE;

    PROCEDURE put_setting (p_key VARCHAR2, p_val VARCHAR2, p_label VARCHAR2, p_desc VARCHAR2,
                           p_type VARCHAR2, p_allow VARCHAR2, p_def VARCHAR2) IS
    BEGIN
        UPDATE prod.dct_module_settings
           SET setting_label = p_label, setting_description = p_desc,
               value_type = p_type, allowed_values = p_allow, default_value = p_def
         WHERE module_id = v_module_id AND setting_key = p_key;
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO prod.dct_module_settings
                   (module_id, setting_key, setting_value, setting_label, setting_description,
                    value_type, allowed_values, default_value, effective_date)
            VALUES (v_module_id, p_key, p_val, p_label, p_desc, p_type, p_allow, p_def, SYSDATE);
        END IF;
    END;
BEGIN
    SELECT module_id INTO v_module_id FROM prod.dct_modules WHERE module_code = 'PAY';

    put_setting('EMP_NUMBER_PREFIX', 'OS-', 'Employee Number Prefix',
        'Prefix of auto-generated outsourced employee numbers (sequence-based, e.g. OS-00001).', 'TEXT', NULL, 'OS-');
    put_setting('EMP_DOC_ALERT_DAYS', '30', 'Employee Document Alert (days)',
        'Default lead time in days for outsourced employee document expiry alerts when the document type does not set its own.', 'NUMBER', NULL, '30');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Module settings seeded: EMP_NUMBER_PREFIX, EMP_DOC_ALERT_DAYS');
END;
/

-- =============================================================================
-- 4. EMPLOYEE NUMBER SEQUENCE
-- =============================================================================
DECLARE
    l_n NUMBER;
BEGIN
    SELECT COUNT(*) INTO l_n FROM all_sequences
     WHERE sequence_owner='PROD' AND sequence_name='DCT_PAY_EMP_NUM_SEQ';
    IF l_n=0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE prod.dct_pay_emp_num_seq START WITH 1 INCREMENT BY 1 NOCACHE';
    END IF;
END;
/

-- =============================================================================
-- 5. DOCUMENT TYPES -- shared types extended to PAY + new LABOUR_CARD
-- =============================================================================
DECLARE
    v_n NUMBER := 0;
BEGIN
    FOR r IN (SELECT doc_type_code FROM prod.dct_document_types
               WHERE doc_type_code IN ('PASSPORT','EMIRATES_ID','RESIDENCE_VISA','BANK_LETTER','CONTRACT')
                 AND INSTR('|'||applies_to_modules||'|','|PAY|') = 0)
    LOOP
        UPDATE prod.dct_document_types
           SET applies_to_modules = applies_to_modules || '|PAY'
         WHERE doc_type_code = r.doc_type_code;
        v_n := v_n + 1;
    END LOOP;

    UPDATE prod.dct_document_types
       SET doc_type_name_en = 'Labour Card / Work Permit',
           doc_type_name_ar = 'بطاقة العمل / تصريح العمل',
           has_expiry = 'Y', expiry_alert_days = 60
     WHERE doc_type_code = 'LABOUR_CARD';
    IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO prod.dct_document_types
               (doc_type_code, doc_type_name_en, doc_type_name_ar, doc_category,
                applies_to_modules, has_expiry, expiry_alert_days, display_order)
        VALUES ('LABOUR_CARD', 'Labour Card / Work Permit', 'بطاقة العمل / تصريح العمل', 'IDENTITY',
                'PAY', 'Y', 60, 320);
    END IF;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Document types: '||v_n||' shared types extended to PAY + LABOUR_CARD upserted');
END;
/

-- =============================================================================
-- 6. PAY_EMPLOYEE DOCUMENT CHECKLIST -- shared DCT_DOC_REQUIREMENTS
-- =============================================================================
DECLARE
    PROCEDURE up_req (p_code VARCHAR2, p_mand VARCHAR2, p_seq NUMBER) IS
        l_type_id NUMBER;
    BEGIN
        SELECT doc_type_id INTO l_type_id FROM prod.dct_document_types WHERE doc_type_code = p_code;
        UPDATE prod.dct_doc_requirements
           SET is_mandatory = p_mand, display_seq = p_seq, is_active = 'Y', updated_at = SYSTIMESTAMP
         WHERE source_module = 'PAY' AND context_code = 'PAY_EMPLOYEE' AND doc_type_id = l_type_id;
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO prod.dct_doc_requirements
                   (source_module, context_code, doc_type_id, is_mandatory, display_seq, is_active, created_at)
            VALUES ('PAY', 'PAY_EMPLOYEE', l_type_id, p_mand, p_seq, 'Y', SYSTIMESTAMP);
        END IF;
    END;
BEGIN
    up_req('EMIRATES_ID',    'Y', 10);
    up_req('PASSPORT',       'Y', 20);
    up_req('RESIDENCE_VISA', 'Y', 30);
    up_req('LABOUR_CARD',    'Y', 40);
    up_req('CONTRACT',       'Y', 50);
    up_req('BANK_LETTER',    'N', 60);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('PAY_EMPLOYEE document checklist seeded (6 rows)');
END;
/

PROMPT === 10_pay_phase2_seed.sql complete: lookups + entry roles + settings + sequence + doc checklist ===
