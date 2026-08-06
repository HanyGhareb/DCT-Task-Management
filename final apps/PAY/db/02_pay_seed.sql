-- =============================================================================
-- Outsource Payroll Module (App 215) -- Seed -- Phase 1
-- File    : 02_pay_seed.sql
-- Schema  : PROD (data only)
-- Run     : sql -name prod_mcp @02_pay_seed.sql
-- Notes   : Re-runnable (each block is an in-place refresh, no MERGE so the
--           Linux SQLcl keyword gotcha never applies). Seeds the PAY_* lookup
--           vocabularies, the DCT_MODULES row (App 215), the PAY roles and
--           permissions, the module settings and the PAY document type.
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- 1. LOOKUP CATEGORIES + VALUES  (lookup-first vocabularies)
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
    up_cat('PAY_COMPANY_CATEGORY', 'Outsource Company Category', 'فئة شركة الإسناد الخارجي', v_cat);
    up_val(v_cat, 'MANPOWER',   'Manpower Supply',        'توريد قوى عاملة',      10, 'Y');
    up_val(v_cat, 'IT_SERVICES','IT Services',            'خدمات تقنية المعلومات', 20);
    up_val(v_cat, 'FACILITIES', 'Facilities Management',  'إدارة المرافق',        30);
    up_val(v_cat, 'CONSULTING', 'Consulting Services',    'خدمات استشارية',       40);
    up_val(v_cat, 'OTHER',      'Other',                  'أخرى',                 90);

    up_cat('PAY_COMPANY_STATUS', 'Outsource Company Status', 'حالة شركة الإسناد الخارجي', v_cat);
    up_val(v_cat, 'ACTIVE',    'Active',    'نشطة',    10, 'Y');
    up_val(v_cat, 'SUSPENDED', 'Suspended', 'موقوفة',  20);
    up_val(v_cat, 'INACTIVE',  'Inactive',  'غير نشطة', 30);

    up_cat('PAY_CONTRACT_STATUS', 'Outsource Contract Status', 'حالة عقد الإسناد الخارجي', v_cat);
    up_val(v_cat, 'DRAFT',      'Draft',      'مسودة',   10, 'Y');
    up_val(v_cat, 'ACTIVE',     'Active',     'ساري',    20);
    up_val(v_cat, 'EXPIRED',    'Expired',    'منتهي',   30);
    up_val(v_cat, 'TERMINATED', 'Terminated', 'مفسوخ',   40);
    up_val(v_cat, 'SUPERSEDED', 'Superseded', 'مستبدل',  50);

    up_cat('PAY_SUPPLIER_PURPOSE', 'Supplier Reference Purpose', 'غرض مرجع المورد', v_cat);
    up_val(v_cat, 'ALL',      'All Payments',       'جميع المدفوعات',    10, 'Y');
    up_val(v_cat, 'PAYROLL',  'Monthly Payroll',    'الرواتب الشهرية',   20);
    up_val(v_cat, 'SEPARATE', 'Separate Payments',  'المدفوعات المنفصلة', 30);

    up_cat('PAY_MARGIN_METHOD', 'Margin Calculation Method', 'طريقة احتساب الهامش', v_cat);
    up_val(v_cat, 'PERCENT',      'Percentage of basis',   'نسبة من الأساس',     10, 'Y');
    up_val(v_cat, 'FLAT',         'Flat amount per period', 'مبلغ ثابت للفترة',  20);
    up_val(v_cat, 'PER_EMPLOYEE', 'Amount per employee',   'مبلغ لكل موظف',      30);
    up_val(v_cat, 'PER_ELEMENT',  'Per element class',     'حسب فئة العنصر',     40);

    up_cat('PAY_MARGIN_BASIS', 'Margin Basis', 'أساس الهامش', v_cat);
    up_val(v_cat, 'BASIC',    'Basic salary',       'الراتب الأساسي',    10);
    up_val(v_cat, 'GROSS',    'Gross earnings',     'إجمالي الاستحقاقات', 20, 'Y');
    up_val(v_cat, 'NET',      'Net entitlement',    'صافي الاستحقاق',    30);
    up_val(v_cat, 'SELECTED', 'Selected elements',  'عناصر مختارة',      40);

    up_cat('PAY_PAYMENT_SCOPE', 'Margin Payment Scope', 'نطاق تطبيق الهامش', v_cat);
    up_val(v_cat, 'ALL',      'All payment types',  'جميع أنواع المدفوعات', 10, 'Y');
    up_val(v_cat, 'MONTHLY',  'Monthly payroll',    'الرواتب الشهرية',      20);
    up_val(v_cat, 'SEPARATE', 'Separate payments',  'المدفوعات المنفصلة',   30);

    up_cat('PAY_BU', 'Outsource Business Unit', 'وحدة الأعمال', v_cat);
    up_val(v_cat, 'DCT', 'DCT - Department of Culture and Tourism', 'دائرة الثقافة والسياحة', 10, 'Y');
    up_val(v_cat, 'MSS', 'MSS - Museum Shared Services',            'الخدمات المشتركة للمتاحف', 20);
    up_val(v_cat, 'AFH', 'AFH - Abrahamic Family House',            'بيت العائلة الإبراهيمية',  30);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Lookup sets seeded: 8 PAY_* categories');
END;
/

-- =============================================================================
-- 2. MODULE REGISTRATION -- DCT_MODULES (App 215)
-- =============================================================================
DECLARE
    v_n NUMBER;
BEGIN
    UPDATE prod.dct_modules
       SET module_name_en = 'Outsource Payroll',
           module_name_ar = 'رواتب الإسناد الخارجي',
           apex_app_id    = 215,
           icon_class     = 'fa-money-check-dollar',
           icon_color     = '#14682F',
           bg_color       = '#E8F3EC',
           description_en = 'Manage outsource companies, contracts and margins; outsourced employees; payroll elements, runs, payslips and company payments.',
           description_ar = 'إدارة شركات الإسناد الخارجي والعقود والهوامش؛ وموظفي الإسناد؛ وعناصر الرواتب والمسيرات وقسائم الرواتب ومدفوعات الشركات.',
           category       = 'FINANCE',
           is_active      = 'Y'
     WHERE module_code = 'PAY';
    IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO prod.dct_modules
               (module_code, module_name_en, module_name_ar, module_type, apex_app_id,
                apex_page_id, icon_class, icon_color, bg_color,
                description_en, description_ar, category, display_order,
                is_active, is_new_tab, is_admin_only)
        VALUES ('PAY', 'Outsource Payroll', 'رواتب الإسناد الخارجي', 'APEX_APP', 215,
                1, 'fa-money-check-dollar', '#14682F', '#E8F3EC',
                'Manage outsource companies, contracts and margins; outsourced employees; payroll elements, runs, payslips and company payments.',
                'إدارة شركات الإسناد الخارجي والعقود والهوامش؛ وموظفي الإسناد؛ وعناصر الرواتب والمسيرات وقسائم الرواتب ومدفوعات الشركات.',
                'FINANCE', 76, 'Y', 'N', 'N');
    END IF;
    SELECT COUNT(*) INTO v_n FROM prod.dct_modules WHERE module_code = 'PAY';
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Module registered: PAY (App 215), rows=' || v_n);
END;
/

-- =============================================================================
-- 3. SYSTEM ROLES + PERMISSIONS -- PAY_ADMIN, PAY_USER
-- =============================================================================
DECLARE
    v_module_id  prod.dct_modules.module_id%TYPE;
    v_admin_role NUMBER;
    v_user_role  NUMBER;

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

    up_role('PAY_ADMIN', 'Outsource Payroll Admin', 'مسؤول رواتب الإسناد الخارجي',
            'Manage outsource companies, supplier references, contracts, margin rules and DCT bank accounts.', 10, v_admin_role);
    up_role('PAY_USER', 'Outsource Payroll User', 'مستخدم رواتب الإسناد الخارجي',
            'Access the Outsource Payroll module in view mode.', 20, v_user_role);

    grant_perm(v_admin_role, 'PAY.MANAGE_COMPANIES', 'Manage outsource companies and supplier references', 'CONFIGURE');
    grant_perm(v_admin_role, 'PAY.MANAGE_CONTRACTS', 'Manage outsource contracts and margin rules',        'CONFIGURE');
    grant_perm(v_admin_role, 'PAY.MANAGE_BANKS',     'Manage DCT funding bank accounts',                   'CONFIGURE');
    grant_perm(v_user_role,  'PAY.ACCESS',           'View the Outsource Payroll module',                  'VIEW');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('System roles seeded: PAY_ADMIN, PAY_USER (+4 permissions)');
END;
/

-- =============================================================================
-- 4. MODULE SETTINGS
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

    put_setting('THEME_BRAND_COLOR', '#14682F', 'Brand Color',
        'Primary brand color of the Outsource Payroll app (matches Accounts Payable by design decision).', 'COLOR', NULL, '#14682F');
    put_setting('MAX_UPLOAD_MB', '10', 'Max Document Upload (MB)',
        'Maximum size in megabytes of a single company or contract document upload.', 'NUMBER', NULL, '10');
    put_setting('RENEWAL_ALERT_DAYS', '60', 'Default Renewal Alert (days)',
        'Default lead time in days for contract renewal alerts when a contract does not set its own.', 'NUMBER', NULL, '60');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Module settings seeded');
END;
/

-- =============================================================================
-- 5. DOCUMENT TYPE -- shared DCT_DOCUMENT_TYPES entry for PAY uploads
-- =============================================================================
DECLARE
BEGIN
    UPDATE prod.dct_document_types
       SET applies_to_modules = 'PAY'
     WHERE doc_type_code = 'PAY_DOCUMENT';
    IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO prod.dct_document_types
               (doc_type_code, doc_type_name_en, doc_type_name_ar, doc_category,
                applies_to_modules, has_expiry, expiry_alert_days, display_order)
        VALUES ('PAY_DOCUMENT', 'Outsource Payroll Document', 'مستند رواتب الإسناد الخارجي', 'OTHER',
                'PAY', 'N', 0, 310);
    END IF;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Document type seeded: PAY_DOCUMENT');
END;
/

PROMPT === 02_pay_seed.sql complete: lookups + module (App 215) + roles + settings + doc type ===
