-- =============================================================================
-- Freelancers Module (App 203) — Seed Data
-- File    : 03_fl_seed.sql
-- Schema  : PROD
-- Run     : After 01_fl_ddl.sql and 02_fl_views.sql
-- Safe    : Idempotent — uses MERGE INTO throughout
-- Depends : db/v2/04_dct_seed.sql (platform roles MANAGER, ADMIN must exist)
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- 1. DCT_NATIONALITY — Common nationalities (UAE context)
-- =============================================================================
DECLARE
    TYPE t_nat IS RECORD (
        code VARCHAR2(3),
        en   VARCHAR2(100),
        ar   VARCHAR2(100),
        seq  NUMBER
    );
    TYPE t_nat_list IS TABLE OF t_nat;
    v_nats t_nat_list := t_nat_list(
        t_nat('AE', 'Emirati',        'إماراتي',       1),
        t_nat('SA', 'Saudi Arabian',   'سعودي',         2),
        t_nat('EG', 'Egyptian',        'مصري',          3),
        t_nat('JO', 'Jordanian',       'أردني',         4),
        t_nat('LB', 'Lebanese',        'لبناني',        5),
        t_nat('SY', 'Syrian',          'سوري',          6),
        t_nat('IN', 'Indian',          'هندي',          7),
        t_nat('PK', 'Pakistani',       'باكستاني',      8),
        t_nat('PH', 'Filipino',        'فلبيني',        9),
        t_nat('BD', 'Bangladeshi',     'بنغلاديشي',     10),
        t_nat('NP', 'Nepali',          'نيبالي',        11),
        t_nat('LK', 'Sri Lankan',      'سريلانكي',      12),
        t_nat('GB', 'British',         'بريطاني',       13),
        t_nat('US', 'American',        'أمريكي',        14),
        t_nat('FR', 'French',          'فرنسي',         15),
        t_nat('DE', 'German',          'ألماني',        16),
        t_nat('CN', 'Chinese',         'صيني',          17),
        t_nat('MY', 'Malaysian',       'ماليزي',        18),
        t_nat('SD', 'Sudanese',        'سوداني',        19),
        t_nat('YE', 'Yemeni',          'يمني',          20),
        t_nat('OM', 'Omani',           'عُماني',        21),
        t_nat('BH', 'Bahraini',        'بحريني',        22),
        t_nat('KW', 'Kuwaiti',         'كويتي',         23),
        t_nat('QA', 'Qatari',          'قطري',          24),
        t_nat('ET', 'Ethiopian',       'إثيوبي',        25),
        t_nat('ER', 'Eritrean',        'إريتري',        26),
        t_nat('TZ', 'Tanzanian',       'تنزاني',        27),
        t_nat('KE', 'Kenyan',          'كيني',          28),
        t_nat('GH', 'Ghanaian',        'غاني',          29),
        t_nat('NG', 'Nigerian',        'نيجيري',        30),
        t_nat('OT', 'Other',           'أخرى',          99)
    );
BEGIN
    FOR i IN 1 .. v_nats.COUNT LOOP
        MERGE INTO prod.dct_nationality tgt
        USING (SELECT v_nats(i).code AS nationality_code FROM dual) src
        ON    (tgt.nationality_code = src.nationality_code)
        WHEN NOT MATCHED THEN
            INSERT (nationality_code, nationality_name_en, nationality_name_ar, is_active, display_seq)
            VALUES (v_nats(i).code, v_nats(i).en, v_nats(i).ar, 'Y', v_nats(i).seq)
        WHEN MATCHED THEN
            UPDATE SET nationality_name_en = v_nats(i).en,
                       nationality_name_ar = v_nats(i).ar,
                       display_seq         = v_nats(i).seq;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('DCT_NATIONALITY seeded: ' || v_nats.COUNT || ' nationalities');
END;
/

-- =============================================================================
-- 2. MODULE REGISTRATION — DCT_MODULES
-- =============================================================================
MERGE INTO dct_modules tgt
USING (
    SELECT
        'FREELANCERS'        AS module_code,
        'Freelancers'        AS module_name_en,
        'المتعاقدون'          AS module_name_ar,
        'APEX_APP'           AS module_type,
        203                  AS apex_app_id,
        1                    AS apex_page_id,
        'fa-user-tie'        AS icon_class,
        '#1A6B3C'            AS icon_color,
        '#EAF7EF'            AS bg_color,
        'End-to-end freelancer lifecycle management — registration, contracts, payment vouchers, deliverable tracking, document expiry, and self-service portal.' AS description_en,
        'إدارة دورة حياة المتعاقدين — التسجيل والعقود وقسائم الدفع وتتبع المخرجات وانتهاء الوثائق والبوابة الذاتية.' AS description_ar,
        'FINANCE'            AS category,
        30                   AS display_order,
        'Y'                  AS is_active,
        'N'                  AS is_new_tab,
        'N'                  AS is_admin_only
    FROM dual
) src ON (tgt.module_code = src.module_code)
WHEN NOT MATCHED THEN
    INSERT (module_code, module_name_en, module_name_ar, module_type, apex_app_id,
            apex_page_id, icon_class, icon_color, bg_color,
            description_en, description_ar, category, display_order,
            is_active, is_new_tab, is_admin_only)
    VALUES (src.module_code, src.module_name_en, src.module_name_ar, src.module_type,
            src.apex_app_id, src.apex_page_id, src.icon_class, src.icon_color, src.bg_color,
            src.description_en, src.description_ar, src.category, src.display_order,
            src.is_active, src.is_new_tab, src.is_admin_only)
WHEN MATCHED THEN
    UPDATE SET module_name_en = src.module_name_en,
               apex_app_id   = src.apex_app_id,
               icon_class    = src.icon_class,
               category      = src.category,
               is_active     = src.is_active;

COMMIT;
PROMPT Module registered: FREELANCERS (App 203)

-- =============================================================================
-- 3. ROLES
-- =============================================================================
DECLARE
    v_module_id dct_modules.module_id%TYPE;

    PROCEDURE upsert_role (
        p_code  VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, p_type VARCHAR2,
        p_desc  VARCHAR2, p_sys VARCHAR2, p_ord NUMBER
    ) IS
    BEGIN
        MERGE INTO dct_roles tgt
        USING (SELECT p_code AS role_code FROM dual) src
        ON    (tgt.role_code = src.role_code)
        WHEN NOT MATCHED THEN
            INSERT (role_code, role_name_en, role_name_ar, role_type, module_id,
                    description_en, is_active, is_system_role, display_order)
            VALUES (p_code, p_en, p_ar, p_type, v_module_id,
                    p_desc, 'Y', p_sys, p_ord)
        WHEN MATCHED THEN
            UPDATE SET role_name_en = p_en, display_order = p_ord;
    END;
BEGIN
    SELECT module_id INTO v_module_id FROM dct_modules WHERE module_code = 'FREELANCERS';

    upsert_role('FL_ADMIN',      'Freelancer Admin',    'مدير المتعاقدين',
                'MODULE', 'Full access to all freelancer records, contracts, vouchers, and approvals.', 'N', 10);

    upsert_role('FL_MANAGER',    'Freelancer Manager',  'مشرف المتعاقدين',
                'MODULE', 'Approves registrations, contracts, amendments, vouchers and renewals.', 'N', 20);

    upsert_role('FL_USER',       'Freelancer User',     'مستخدم المتعاقدين',
                'MODULE', 'Staff who can submit registrations and contracts on behalf of a freelancer.', 'N', 30);

    upsert_role('FL_FREELANCER', 'Freelancer Portal',   'بوابة المتعاقد',
                'MODULE', 'Freelancer self-service portal — view own contracts, vouchers, deliverables and documents.', 'N', 40);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Roles seeded: FL_ADMIN, FL_MANAGER, FL_USER, FL_FREELANCER');
END;
/

-- =============================================================================
-- 4. PERMISSIONS
-- =============================================================================
DECLARE
    v_module_id dct_modules.module_id%TYPE;

    PROCEDURE upsert_perm (
        p_code VARCHAR2, p_action VARCHAR2, p_en VARCHAR2, p_desc VARCHAR2
    ) IS
    BEGIN
        MERGE INTO dct_permissions tgt
        USING (SELECT p_code AS permission_code FROM dual) src
        ON    (tgt.permission_code = src.permission_code)
        WHEN NOT MATCHED THEN
            INSERT (permission_code, action_type, permission_name, description_en, module_id, is_active)
            VALUES (p_code, p_action, p_en, p_desc, v_module_id, 'Y')
        WHEN MATCHED THEN
            UPDATE SET permission_name = p_en, action_type = p_action;
    END;
BEGIN
    SELECT module_id INTO v_module_id FROM dct_modules WHERE module_code = 'FREELANCERS';

    upsert_perm('FL.VIEW_FREELANCERS',    'VIEW',      'View Freelancers',      'View all freelancer profiles');
    upsert_perm('FL.MANAGE_FREELANCERS',  'ADMIN',     'Manage Freelancers',    'Create, edit and deactivate freelancer profiles');
    upsert_perm('FL.VIEW_REGISTRATIONS',  'VIEW',      'View Registrations',    'View registration requests');
    upsert_perm('FL.MANAGE_REGISTRATIONS','EDIT',      'Manage Registrations',  'Process and approve registration requests');
    upsert_perm('FL.VIEW_CONTRACTS',      'VIEW',      'View Contracts',        'View all contracts');
    upsert_perm('FL.MANAGE_CONTRACTS',    'EDIT',      'Manage Contracts',      'Create and edit contracts');
    upsert_perm('FL.APPROVE_CONTRACTS',   'APPROVE',   'Approve Contracts',     'Approve/reject contract requests');
    upsert_perm('FL.VIEW_VOUCHERS',       'VIEW',      'View Vouchers',         'View all payment vouchers');
    upsert_perm('FL.MANAGE_VOUCHERS',     'EDIT',      'Manage Vouchers',       'Create and edit payment vouchers');
    upsert_perm('FL.APPROVE_VOUCHERS',    'APPROVE',   'Approve Vouchers',      'Approve/reject voucher requests');
    upsert_perm('FL.VIEW_DELIVERABLES',   'VIEW',      'View Deliverables',     'View deliverables');
    upsert_perm('FL.ACCEPT_DELIVERABLES', 'APPROVE',   'Accept Deliverables',   'Accept or reject deliverable submissions');
    upsert_perm('FL.VIEW_DOCUMENTS',      'VIEW',      'View Documents',        'View all freelancer documents');
    upsert_perm('FL.MANAGE_DOCUMENTS',    'EDIT',      'Manage Documents',      'Upload and manage documents');
    upsert_perm('FL.EXPORT',              'EXPORT',    'Export Data',           'Export freelancer and contract data');
    upsert_perm('FL.CONFIGURE',           'CONFIGURE', 'Configure Module',      'Manage module settings and approval rules');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Permissions seeded: 16 FL permissions');
END;
/

-- =============================================================================
-- 5. MODULE SETTINGS
-- =============================================================================
DECLARE
    v_module_id dct_modules.module_id%TYPE;

    TYPE t_setting IS RECORD (
        s_key   VARCHAR2(100), s_val   VARCHAR2(1000),
        s_label VARCHAR2(200), s_desc  VARCHAR2(1000),
        s_type  VARCHAR2(20),  s_allow VARCHAR2(200),
        s_def   VARCHAR2(1000)
    );
    TYPE t_setting_list IS TABLE OF t_setting;

    v_settings t_setting_list := t_setting_list(
        -- Function 1 — Registration
        t_setting('ALLOW_SELF_REGISTRATION', 'Y',
            'Allow Self Registration',
            'Y = enable public self-registration page (P9998) for freelancers.',
            'BOOLEAN', 'Y|N', 'Y'),
        t_setting('NATIONAL_ID_REQUIRED_FOR_AE', 'Y',
            'Emirates ID Required for UAE Nationals',
            'Y = national_id is mandatory when nationality_code = AE.',
            'BOOLEAN', 'Y|N', 'Y'),
        t_setting('PHOTO_REQUIRED', 'Y',
            'Photo Required on Registration',
            'Y = freelancer photo is mandatory before registration can be submitted.',
            'BOOLEAN', 'Y|N', 'Y'),
        t_setting('AUTO_GENERATE_VENDOR_NUM', 'Y',
            'Auto-Generate Vendor Number',
            'Y = vendor number is auto-generated from sequence on freelancer profile creation.',
            'BOOLEAN', 'Y|N', 'Y'),
        -- Function 2 — Contracts
        t_setting('AUTO_GENERATE_PAYMENT_SCHEDULE', 'Y',
            'Auto-Generate Payment Schedule',
            'Y = payment schedule is generated automatically when a contract is approved.',
            'BOOLEAN', 'Y|N', 'Y'),
        t_setting('ALLOW_DIRECT_CONTRACT_EDIT', 'N',
            'Allow Direct Contract Edit',
            'Y = admin can edit contract directly (version increments); N = formal amendment required.',
            'BOOLEAN', 'Y|N', 'N'),
        t_setting('CONTRACT_DIRECTOR_APPROVAL_THRESHOLD', '50000',
            'Director Approval Threshold (AED)',
            'Contracts and vouchers at or above this AED amount require Finance Director approval.',
            'NUMBER', NULL, '50000'),
        -- Function 3 — Vouchers
        t_setting('ALLOW_BULK_VOUCHER_GENERATION', 'N',
            'Allow Bulk Voucher Generation',
            'Y = admin can generate vouchers for all PENDING schedule rows of a contract at once.',
            'BOOLEAN', 'Y|N', 'N'),
        t_setting('VOUCHER_REQUIRE_INVOICE', 'Y',
            'Require Invoice on Voucher',
            'Y = invoice_number and invoice_date are mandatory before a voucher can be submitted.',
            'BOOLEAN', 'Y|N', 'Y'),
        t_setting('ALLOW_VOUCHER_AMOUNT_OVERRIDE', 'N',
            'Allow Voucher Amount Override',
            'Y = admin can change the voucher amount from the scheduled amount.',
            'BOOLEAN', 'Y|N', 'N'),
        t_setting('DEFAULT_PAYMENT_METHOD', 'BANK_TRANSFER',
            'Default Payment Method',
            'Default value for payment_method on new vouchers. Must match FL_PAYMENT_METHOD lookup codes.',
            'SELECT', 'BANK_TRANSFER|CHEQUE|CASH', 'BANK_TRANSFER'),
        t_setting('DEFAULT_PAY_GROUP', 'FREELANCER',
            'Default Pay Group',
            'Default value for pay_group on new vouchers. Must match FL_PAY_GROUP lookup codes.',
            'SELECT', 'FREELANCER|CONTRACTOR|VENDOR', 'FREELANCER'),
        t_setting('VOUCHER_DEFAULT_DESCRIPTION', 'Freelancer Payment - {CONTRACT_NUMBER} - {PERIOD_LABEL}',
            'Voucher Default Description',
            'Default description for new vouchers. Tokens {CONTRACT_NUMBER} and {PERIOD_LABEL} are substituted on generation.',
            'TEXT', NULL, 'Freelancer Payment - {CONTRACT_NUMBER} - {PERIOD_LABEL}'),
        -- Function 4 — Deliverables
        t_setting('VOUCHER_REQUIRE_ACCEPTED_DELIVERABLE', 'N',
            'Require Accepted Deliverable for Voucher',
            'Y = an ACCEPTED deliverable linked to the schedule row must exist before a voucher can be submitted.',
            'BOOLEAN', 'Y|N', 'N'),
        -- Function 5 — Document Expiry
        t_setting('DOC_EXPIRY_ALERT_DAYS', '30',
            'Document Expiry Alert Days',
            'Default days before document expiry to trigger an alert. Also set as alert_days_before on new document records.',
            'NUMBER', NULL, '30'),
        t_setting('BLOCK_CONTRACT_ON_EXPIRED_DOC', 'Y',
            'Block Contract on Expired Document',
            'Y = prevent new contract submission if the freelancer has any expired required documents.',
            'BOOLEAN', 'Y|N', 'Y'),
        t_setting('BLOCK_VOUCHER_ON_EXPIRED_DOC', 'N',
            'Block Voucher on Expired Document',
            'Y = prevent voucher submission if the freelancer has any expired required documents.',
            'BOOLEAN', 'Y|N', 'N'),
        -- Function 7 — Self-Service Portal
        t_setting('ALLOW_PROFILE_CHANGE_REQUEST', 'Y',
            'Allow Profile Change Requests',
            'Y = freelancers can submit profile update requests (bank account, email, phone) via the self-service portal.',
            'BOOLEAN', 'Y|N', 'Y')
    );
BEGIN
    SELECT module_id INTO v_module_id FROM dct_modules WHERE module_code = 'FREELANCERS';

    FOR i IN 1 .. v_settings.COUNT LOOP
        MERGE INTO dct_module_settings s
        USING (SELECT v_module_id          AS module_id,
                      v_settings(i).s_key  AS setting_key FROM dual) src
        ON    (s.module_id = src.module_id AND s.setting_key = src.setting_key)
        WHEN NOT MATCHED THEN
            INSERT (module_id, setting_key, setting_value, setting_label,
                    setting_description, value_type, allowed_values, default_value,
                    effective_date)
            VALUES (v_module_id, v_settings(i).s_key, v_settings(i).s_val,
                    v_settings(i).s_label, v_settings(i).s_desc,
                    v_settings(i).s_type,  v_settings(i).s_allow, v_settings(i).s_def,
                    SYSDATE)
        WHEN MATCHED THEN
            UPDATE SET setting_label       = v_settings(i).s_label,
                       setting_description = v_settings(i).s_desc,
                       value_type          = v_settings(i).s_type,
                       allowed_values      = v_settings(i).s_allow,
                       default_value       = v_settings(i).s_def;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Module settings seeded: ' || v_settings.COUNT || ' FREELANCERS settings');
END;
/

-- =============================================================================
-- 6. LOOKUP CATEGORIES AND VALUES
-- =============================================================================
DECLARE
    v_module_id     dct_modules.module_id%TYPE;
    v_cat_billing   dct_lookup_categories.category_id%TYPE;
    v_cat_paymethod dct_lookup_categories.category_id%TYPE;
    v_cat_paygroup  dct_lookup_categories.category_id%TYPE;
    v_cat_doctype   dct_lookup_categories.category_id%TYPE;

    PROCEDURE upsert_category (
        p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2,
        p_mod  NUMBER,   p_id OUT NUMBER
    ) IS
    BEGIN
        MERGE INTO dct_lookup_categories tgt
        USING (SELECT p_code AS category_code FROM dual) src
        ON    (tgt.category_code = src.category_code)
        WHEN NOT MATCHED THEN
            INSERT (category_code, category_name_en, category_name_ar,
                    module_id, is_system, is_active)
            VALUES (p_code, p_en, p_ar, p_mod, 'N', 'Y')
        WHEN MATCHED THEN
            UPDATE SET category_name_en = p_en;
        SELECT category_id INTO p_id FROM dct_lookup_categories WHERE category_code = p_code;
    END;

    PROCEDURE upsert_value (
        p_cat_id NUMBER, p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2,
        p_ord NUMBER, p_default VARCHAR2 DEFAULT 'N'
    ) IS
    BEGIN
        MERGE INTO dct_lookup_values tgt
        USING (SELECT p_cat_id AS category_id, p_code AS value_code FROM dual) src
        ON    (tgt.category_id = src.category_id AND tgt.value_code = src.value_code)
        WHEN NOT MATCHED THEN
            INSERT (category_id, value_code, value_name_en, value_name_ar,
                    display_order, is_default, is_active)
            VALUES (p_cat_id, p_code, p_en, p_ar, p_ord, p_default, 'Y')
        WHEN MATCHED THEN
            UPDATE SET value_name_en  = p_en,
                       value_name_ar  = p_ar,
                       display_order  = p_ord;
    END;
BEGIN
    SELECT module_id INTO v_module_id FROM dct_modules WHERE module_code = 'FREELANCERS';

    -- Billing Units
    upsert_category('FL_BILLING_UNIT', 'Freelancer Billing Units', 'وحدات إصدار الفواتير',
                    v_module_id, v_cat_billing);
    upsert_value(v_cat_billing, 'REPORT',      'Per Report',       'لكل تقرير',       10);
    upsert_value(v_cat_billing, 'VISIT',        'Per Visit',        'لكل زيارة',       20);
    upsert_value(v_cat_billing, 'DELIVERABLE', 'Per Deliverable',  'لكل مخرج',        30);
    upsert_value(v_cat_billing, 'HOUR',         'Per Hour',         'لكل ساعة',        40);
    upsert_value(v_cat_billing, 'UNIT',         'Per Unit',         'لكل وحدة',        50);

    -- Payment Methods
    upsert_category('FL_PAYMENT_METHOD', 'Freelancer Payment Methods', 'طرق الدفع',
                    v_module_id, v_cat_paymethod);
    upsert_value(v_cat_paymethod, 'BANK_TRANSFER', 'Bank Transfer', 'تحويل بنكي', 10, 'Y');
    upsert_value(v_cat_paymethod, 'CHEQUE',        'Cheque',        'شيك',         20);
    upsert_value(v_cat_paymethod, 'CASH',          'Cash',          'نقد',         30);

    -- Pay Groups
    upsert_category('FL_PAY_GROUP', 'Freelancer Pay Groups', 'مجموعات الدفع',
                    v_module_id, v_cat_paygroup);
    upsert_value(v_cat_paygroup, 'FREELANCER',  'Freelancer',  'متعاقد مستقل', 10, 'Y');
    upsert_value(v_cat_paygroup, 'CONTRACTOR',  'Contractor',  'مقاول',         20);
    upsert_value(v_cat_paygroup, 'VENDOR',      'Vendor',      'مورد',          30);

    -- Document Types
    upsert_category('FL_DOCUMENT_TYPE', 'Freelancer Document Types', 'أنواع وثائق المتعاقدين',
                    v_module_id, v_cat_doctype);
    upsert_value(v_cat_doctype, 'EMIRATES_ID',    'Emirates ID',                 'الهوية الإماراتية',     10);
    upsert_value(v_cat_doctype, 'PASSPORT',        'Passport',                    'جواز السفر',            20);
    upsert_value(v_cat_doctype, 'VISA',            'Visa / Residency',            'تأشيرة / إقامة',       30);
    upsert_value(v_cat_doctype, 'TRADE_LICENSE',  'Trade License',               'رخصة تجارية',           40);
    upsert_value(v_cat_doctype, 'QUALIFICATION',  'Qualification Certificate',   'شهادة مؤهل',            50);
    upsert_value(v_cat_doctype, 'CONTRACT_COPY',  'Contract Copy',               'نسخة العقد',            60);
    upsert_value(v_cat_doctype, 'INVOICE',         'Invoice',                     'فاتورة',                70);
    upsert_value(v_cat_doctype, 'DELIVERABLE_DOC','Deliverable Document',        'وثيقة المخرج',          80);
    upsert_value(v_cat_doctype, 'OTHER',           'Other',                       'أخرى',                  99);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Lookup categories and values seeded: FL_BILLING_UNIT, FL_PAYMENT_METHOD, FL_PAY_GROUP, FL_DOCUMENT_TYPE');
END;
/

-- =============================================================================
-- 7. APPROVAL WORKFLOWS
--   FL_REGISTRATION_APPROVAL  — Step 1: FL_MANAGER, Step 2: FL_ADMIN
--   FL_CONTRACT_APPROVAL      — Step 1: FL_MANAGER, Step 2: FL_ADMIN (amount >= threshold)
--   FL_AMENDMENT_APPROVAL     — Step 1: FL_MANAGER, Step 2: FL_ADMIN (amount >= threshold)
--   FL_VOUCHER_APPROVAL       — Step 1: FL_MANAGER, Step 2: FL_ADMIN (amount >= threshold)
--   FL_RENEWAL_APPROVAL       — Step 1: FL_MANAGER, Step 2: FL_ADMIN (amount >= threshold)
--   FL_PROFILE_CHANGE_APPROVAL — Step 1: FL_ADMIN
-- =============================================================================
DECLARE
    v_module_id   dct_modules.module_id%TYPE;
    v_fl_admin_id dct_roles.role_id%TYPE;
    v_fl_mgr_id   dct_roles.role_id%TYPE;

    v_tmpl_reg_id dct_approval_templates.template_id%TYPE;
    v_tmpl_con_id dct_approval_templates.template_id%TYPE;
    v_tmpl_amd_id dct_approval_templates.template_id%TYPE;
    v_tmpl_vch_id dct_approval_templates.template_id%TYPE;
    v_tmpl_rnl_id dct_approval_templates.template_id%TYPE;
    v_tmpl_pcr_id dct_approval_templates.template_id%TYPE;

    PROCEDURE upsert_template (
        p_code         IN VARCHAR2,
        p_name         IN VARCHAR2,
        p_module_id    IN NUMBER,
        p_request_type IN VARCHAR2,
        p_desc         IN VARCHAR2,
        p_id           OUT NUMBER
    ) IS
    BEGIN
        MERGE INTO dct_approval_templates t
        USING (SELECT p_code AS template_code FROM dual) src
        ON    (t.template_code = src.template_code)
        WHEN NOT MATCHED THEN
            INSERT (template_code, template_name, module_id, request_type,
                    description_en, is_sequential, auto_approve_days, is_active)
            VALUES (p_code, p_name, p_module_id, p_request_type,
                    p_desc, 'Y', 0, 'Y')
        WHEN MATCHED THEN
            UPDATE SET template_name  = p_name,
                       request_type   = p_request_type,
                       is_active      = 'Y';
        SELECT template_id INTO p_id
        FROM   dct_approval_templates WHERE template_code = p_code;
    END;

    PROCEDURE upsert_step (
        p_template_id   IN NUMBER,
        p_seq           IN NUMBER,
        p_name          IN VARCHAR2,
        p_role_id       IN NUMBER,
        p_cond_type     IN VARCHAR2,
        p_amount_op     IN VARCHAR2 DEFAULT NULL,
        p_amount_thresh IN NUMBER   DEFAULT NULL,
        p_custom        IN VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        MERGE INTO dct_approval_steps s
        USING (SELECT p_template_id AS template_id,
                      p_seq         AS step_seq FROM dual) src
        ON    (s.template_id = src.template_id AND s.step_seq = src.step_seq)
        WHEN NOT MATCHED THEN
            INSERT (template_id, step_seq, step_name, step_type, required_role_id,
                    escalation_days, is_mandatory, allow_skip,
                    condition_type, amount_operator, amount_threshold, custom_condition)
            VALUES (p_template_id, p_seq, p_name, 'ROLE_BASED', p_role_id,
                    3, 'Y', 'N',
                    p_cond_type, p_amount_op, p_amount_thresh, p_custom)
        WHEN MATCHED THEN
            UPDATE SET step_name         = p_name,
                       required_role_id  = p_role_id,
                       condition_type    = p_cond_type,
                       amount_operator   = p_amount_op,
                       amount_threshold  = p_amount_thresh,
                       custom_condition  = p_custom;
    END;
BEGIN
    SELECT module_id INTO v_module_id  FROM dct_modules WHERE module_code  = 'FREELANCERS';
    SELECT role_id   INTO v_fl_admin_id FROM dct_roles  WHERE role_code    = 'FL_ADMIN';
    SELECT role_id   INTO v_fl_mgr_id  FROM dct_roles   WHERE role_code    = 'FL_MANAGER';

    -- Registration
    upsert_template('FL_REGISTRATION_APPROVAL', 'Freelancer Registration Approval',
        v_module_id, 'REGISTRATION',
        'Two-step approval for new freelancer registrations.',
        v_tmpl_reg_id);
    upsert_step(v_tmpl_reg_id, 10, 'FL Manager Review',  v_fl_mgr_id,   'ALWAYS');
    upsert_step(v_tmpl_reg_id, 20, 'FL Admin Approval',  v_fl_admin_id, 'ALWAYS');

    -- Contract
    upsert_template('FL_CONTRACT_APPROVAL', 'Freelancer Contract Approval',
        v_module_id, 'CONTRACT',
        'Contract approval — Director step fires when amount meets threshold.',
        v_tmpl_con_id);
    upsert_step(v_tmpl_con_id, 10, 'FL Manager Review',   v_fl_mgr_id,   'ALWAYS');
    upsert_step(v_tmpl_con_id, 20, 'FL Admin Approval',   v_fl_admin_id, 'AMOUNT',
                p_amount_op => '>=', p_amount_thresh => 50000);

    -- Amendment
    upsert_template('FL_AMENDMENT_APPROVAL', 'Contract Amendment Approval',
        v_module_id, 'AMENDMENT',
        'Contract amendment approval — same threshold rule as contracts.',
        v_tmpl_amd_id);
    upsert_step(v_tmpl_amd_id, 10, 'FL Manager Review',   v_fl_mgr_id,   'ALWAYS');
    upsert_step(v_tmpl_amd_id, 20, 'FL Admin Approval',   v_fl_admin_id, 'AMOUNT',
                p_amount_op => '>=', p_amount_thresh => 50000);

    -- Voucher
    upsert_template('FL_VOUCHER_APPROVAL', 'Payment Voucher Approval',
        v_module_id, 'VOUCHER',
        'Payment voucher approval — Director step fires when amount meets threshold.',
        v_tmpl_vch_id);
    upsert_step(v_tmpl_vch_id, 10, 'FL Manager Review',   v_fl_mgr_id,   'ALWAYS');
    upsert_step(v_tmpl_vch_id, 20, 'FL Admin Approval',   v_fl_admin_id, 'AMOUNT',
                p_amount_op => '>=', p_amount_thresh => 50000);

    -- Renewal
    upsert_template('FL_RENEWAL_APPROVAL', 'Contract Renewal Approval',
        v_module_id, 'RENEWAL',
        'Contract renewal approval — same threshold rule as contracts.',
        v_tmpl_rnl_id);
    upsert_step(v_tmpl_rnl_id, 10, 'FL Manager Review',   v_fl_mgr_id,   'ALWAYS');
    upsert_step(v_tmpl_rnl_id, 20, 'FL Admin Approval',   v_fl_admin_id, 'AMOUNT',
                p_amount_op => '>=', p_amount_thresh => 50000);

    -- Profile Change
    upsert_template('FL_PROFILE_CHANGE_APPROVAL', 'Freelancer Profile Change Approval',
        v_module_id, 'PROFILE_CHANGE',
        'Single-step approval for freelancer-initiated profile update requests.',
        v_tmpl_pcr_id);
    upsert_step(v_tmpl_pcr_id, 10, 'FL Admin Approval', v_fl_admin_id, 'ALWAYS');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Approval templates seeded: 6 templates, 11 steps');
END;
/

COMMIT;

PROMPT
PROMPT === 03_fl_seed.sql complete ===
PROMPT Seeded: DCT_NATIONALITY (31 nationalities)
PROMPT         FREELANCERS module registration
PROMPT         4 roles: FL_ADMIN, FL_MANAGER, FL_USER, FL_FREELANCER
PROMPT         16 permissions
PROMPT         18 module settings
PROMPT         4 lookup categories: FL_BILLING_UNIT, FL_PAYMENT_METHOD, FL_PAY_GROUP, FL_DOCUMENT_TYPE
PROMPT         6 approval templates with 11 steps
