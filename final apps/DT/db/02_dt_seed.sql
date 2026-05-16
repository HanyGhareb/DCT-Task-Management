-- =============================================================================
-- Duty Travel Module (App 204) — Seed Data
-- File    : 02_dt_seed.sql
-- Schema  : PROD
-- Run     : After 01_dt_ddl.sql
-- Safe    : Idempotent — uses MERGE INTO throughout
-- Depends : db/v2/04_dct_seed.sql (platform roles MANAGER, ADMIN must exist)
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- 1. MODULE REGISTRATION — DCT_MODULES
-- =============================================================================
MERGE INTO dct_modules tgt
USING (
    SELECT
        'DUTY_TRAVEL'         AS module_code,
        'Duty Travel'         AS module_name_en,
        'السفر الوظيفي'       AS module_name_ar,
        'APEX_APP'            AS module_type,
        204                   AS apex_app_id,
        1                     AS apex_page_id,
        'fa-plane-departure'  AS icon_class,
        '#1B4F8A'             AS icon_color,
        '#EBF3FB'             AS bg_color,
        'Manages DCT employee business mission and training travel requests — per diem calculation, advance disbursement, and post-travel settlement.' AS description_en,
        'إدارة طلبات سفر الموظفين للمهام الوظيفية والتدريب — احتساب البدل اليومي وصرف السلفة وتسوية المطالبات.' AS description_ar,
        'HR'                  AS category,
        40                    AS display_order,
        'Y'                   AS is_active,
        'N'                   AS is_new_tab,
        'N'                   AS is_admin_only
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
PROMPT Module registered: DUTY_TRAVEL (App 204)

-- =============================================================================
-- 2. ROLES
-- =============================================================================
DECLARE
    v_module_id dct_modules.module_id%TYPE;

    PROCEDURE upsert_role (
        p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2,
        p_desc VARCHAR2, p_ord NUMBER
    ) IS
    BEGIN
        MERGE INTO dct_roles tgt
        USING (SELECT p_code AS role_code FROM dual) src
        ON    (tgt.role_code = src.role_code)
        WHEN NOT MATCHED THEN
            INSERT (role_code, role_name_en, role_name_ar, role_type, module_id,
                    description_en, is_active, is_system_role, display_order)
            VALUES (p_code, p_en, p_ar, 'MODULE', v_module_id,
                    p_desc, 'Y', 'N', p_ord)
        WHEN MATCHED THEN
            UPDATE SET role_name_en  = p_en,
                       role_name_ar  = p_ar,
                       display_order = p_ord;
    END;
BEGIN
    SELECT module_id INTO v_module_id FROM dct_modules WHERE module_code = 'DUTY_TRAVEL';

    upsert_role(
        'DT_ADMIN', 'Duty Travel Admin', 'مدير السفر الوظيفي',
        'Full access to all travel requests, settlements, per diem rate master, country groups, and module settings.',
        10);

    upsert_role(
        'DT_MANAGER', 'Duty Travel Manager', 'مشرف السفر الوظيفي',
        'Approves travel requests and settlements for employees within their organisational unit.',
        20);

    upsert_role(
        'DT_FINANCE', 'Duty Travel Finance', 'مسؤول مالي - السفر الوظيفي',
        'Finance officer — verifies budget coding, marks advance disbursement, approves settlements, and closes requests.',
        30);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Roles seeded: DT_ADMIN, DT_MANAGER, DT_FINANCE');
END;
/

-- =============================================================================
-- 3. PERMISSIONS + ROLE-PERMISSION MAP
-- =============================================================================
DECLARE
    v_module_id   dct_modules.module_id%TYPE;
    v_admin_rid   dct_roles.role_id%TYPE;
    v_mgr_rid     dct_roles.role_id%TYPE;
    v_finance_rid dct_roles.role_id%TYPE;

    TYPE t_perm IS RECORD (
        code     VARCHAR2(100),
        name     VARCHAR2(200),
        action   VARCHAR2(30),
        admin_yn VARCHAR2(1),
        mgr_yn   VARCHAR2(1),
        fin_yn   VARCHAR2(1)
    );
    TYPE t_perm_list IS TABLE OF t_perm;

    v_perms t_perm_list := t_perm_list(
        t_perm('DT.VIEW_OWN_REQUESTS',   'View own travel requests',            'VIEW',      'Y','Y','Y'),
        t_perm('DT.CREATE_REQUEST',       'Create travel request',               'CREATE',    'Y','Y','Y'),
        t_perm('DT.EDIT_OWN_REQUEST',     'Edit own draft request',              'EDIT',      'Y','Y','Y'),
        t_perm('DT.VIEW_ALL_REQUESTS',    'View all travel requests',            'VIEW',      'Y','N','Y'),
        t_perm('DT.APPROVE_REQUEST',      'Approve or reject travel requests',   'APPROVE',   'Y','Y','N'),
        t_perm('DT.DISBURSE_ADVANCE',     'Mark travel advance as disbursed',    'EDIT',      'Y','N','Y'),
        t_perm('DT.CLOSE_REQUEST',        'Close a travelled request',           'EDIT',      'Y','N','Y'),
        t_perm('DT.VIEW_OWN_SETTLEMENTS', 'View own settlements',                'VIEW',      'Y','Y','Y'),
        t_perm('DT.CREATE_SETTLEMENT',    'Create post-travel settlement',       'CREATE',    'Y','Y','Y'),
        t_perm('DT.VIEW_ALL_SETTLEMENTS', 'View all settlements',                'VIEW',      'Y','N','Y'),
        t_perm('DT.APPROVE_SETTLEMENT',   'Approve or reject settlements',       'APPROVE',   'Y','Y','Y'),
        t_perm('DT.MANAGE_RATES',         'Manage per diem rate master',         'CONFIGURE', 'Y','N','N'),
        t_perm('DT.MANAGE_COUNTRY_GROUPS','Manage country group mappings',       'CONFIGURE', 'Y','N','N'),
        t_perm('DT.MANAGE_DOC_REQS',      'Manage document requirements',        'CONFIGURE', 'Y','N','N'),
        t_perm('DT.EXPORT',               'Export travel and settlement data',   'EXPORT',    'Y','N','Y'),
        t_perm('DT.MODULE_SETTINGS',      'Configure module settings',           'CONFIGURE', 'N','N','N'),
        t_perm('DT.APPROVAL_RULES',       'Configure approval workflows',        'CONFIGURE', 'N','N','N')
    );

    v_perm_id dct_permissions.permission_id%TYPE;

    PROCEDURE grant_to_role(p_perm_id NUMBER, p_role_id NUMBER) IS
    BEGIN
        MERGE INTO dct_role_permissions rp
        USING (SELECT p_role_id AS role_id, p_perm_id AS permission_id FROM dual) src
        ON    (rp.role_id = src.role_id AND rp.permission_id = src.permission_id)
        WHEN NOT MATCHED THEN
            INSERT (role_id, permission_id, granted_by)
            VALUES (p_role_id, p_perm_id, 'archa2');
    END;
BEGIN
    SELECT module_id INTO v_module_id   FROM dct_modules WHERE module_code = 'DUTY_TRAVEL';
    SELECT role_id   INTO v_admin_rid   FROM dct_roles   WHERE role_code   = 'DT_ADMIN';
    SELECT role_id   INTO v_mgr_rid     FROM dct_roles   WHERE role_code   = 'DT_MANAGER';
    SELECT role_id   INTO v_finance_rid FROM dct_roles   WHERE role_code   = 'DT_FINANCE';

    FOR i IN 1 .. v_perms.COUNT LOOP
        MERGE INTO dct_permissions p
        USING (SELECT v_perms(i).code AS permission_code FROM dual) src
        ON    (p.permission_code = src.permission_code)
        WHEN NOT MATCHED THEN
            INSERT (permission_code, permission_name, module_id, action_type, is_active)
            VALUES (v_perms(i).code, v_perms(i).name, v_module_id, v_perms(i).action, 'Y')
        WHEN MATCHED THEN
            UPDATE SET permission_name = v_perms(i).name,
                       action_type     = v_perms(i).action;

        SELECT permission_id INTO v_perm_id
        FROM   dct_permissions WHERE permission_code = v_perms(i).code;

        IF v_perms(i).admin_yn = 'Y' THEN grant_to_role(v_perm_id, v_admin_rid);   END IF;
        IF v_perms(i).mgr_yn   = 'Y' THEN grant_to_role(v_perm_id, v_mgr_rid);     END IF;
        IF v_perms(i).fin_yn   = 'Y' THEN grant_to_role(v_perm_id, v_finance_rid); END IF;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Permissions seeded: ' || v_perms.COUNT || ' DT.* permissions');
END;
/

-- =============================================================================
-- 4. MODULE SETTINGS
-- =============================================================================
DECLARE
    v_module_id dct_modules.module_id%TYPE;

    TYPE t_setting IS RECORD (
        s_key   VARCHAR2(100), s_val   VARCHAR2(1000),
        s_label VARCHAR2(200), s_desc  VARCHAR2(1000),
        s_type  VARCHAR2(20),  s_allow VARCHAR2(500),
        s_def   VARCHAR2(1000)
    );
    TYPE t_setting_list IS TABLE OF t_setting;

    v_settings t_setting_list := t_setting_list(
        -- Function 1 — Request lifecycle
        t_setting('ALLOW_PAST_TRAVEL_REQUEST', 'N',
            'Allow Past Travel Requests',
            'Y = allow submitting a request where departure_date is in the past.',
            'BOOLEAN', 'Y|N', 'N'),
        t_setting('ADVANCE_PAYMENT_REQUIRED', 'Y',
            'Advance Payment Required',
            'Y = Finance must mark the advance as disbursed before the request moves to TRAVELLED status.',
            'BOOLEAN', 'Y|N', 'Y'),
        t_setting('SETTLEMENT_REQUIRED', 'Y',
            'Post-Travel Settlement Required',
            'Y = employee must submit a settlement after returning; N = Finance can close the request directly.',
            'BOOLEAN', 'Y|N', 'Y'),
        t_setting('AUTO_CLOSE_DAYS', '0',
            'Auto-Close Days After Return',
            'Number of days after return_date to auto-close TRAVELLED requests when SETTLEMENT_REQUIRED = N. Set to 0 to disable.',
            'NUMBER', NULL, '0'),
        t_setting('SETTLEMENT_DEADLINE_DAYS', '7',
            'Settlement Submission Deadline (Days)',
            'Days after return_date by which the settlement must be submitted when SETTLEMENT_REQUIRED = Y.',
            'NUMBER', NULL, '7'),
        t_setting('SETTLEMENT_LATE_ALERT_DAYS', '5',
            'Settlement Late Alert (Days)',
            'Alert Finance and DT_ADMIN when a settlement has not been submitted this many days past the deadline.',
            'NUMBER', NULL, '5'),
        -- Allowance toggles
        t_setting('INCLUDE_TICKET_ALLOWANCE', 'Y',
            'Include Ticket Allowance',
            'Y = ticket_amount_aed field is visible and included in the total advance.',
            'BOOLEAN', 'Y|N', 'Y'),
        t_setting('INCLUDE_ACCOMMODATION_ALLOWANCE', 'Y',
            'Include Accommodation Allowance',
            'Y = accommodation_amount_aed field is visible and included in the total advance.',
            'BOOLEAN', 'Y|N', 'Y'),
        t_setting('INCLUDE_VISA_ALLOWANCE', 'Y',
            'Include Visa Fees',
            'Y = visa_fees_aed field is visible and included in the total advance.',
            'BOOLEAN', 'Y|N', 'Y'),
        t_setting('INCLUDE_LOCAL_TRANSPORT_ALLOWANCE', 'N',
            'Include Local Transport Allowance',
            'Y = local_transport_aed field is visible and included in the total advance.',
            'BOOLEAN', 'Y|N', 'N'),
        t_setting('MAX_TICKET_AMOUNT_AED', NULL,
            'Maximum Ticket Amount (AED)',
            'Hard cap on ticket_amount_aed. Leave empty for no cap.',
            'NUMBER', NULL, NULL),
        t_setting('DT_FINANCE_APPROVAL_THRESHOLD_AED', '5000',
            'Finance Approval Threshold (AED)',
            'Travel requests with total_advance_aed >= this value require a DT_FINANCE approval step.',
            'NUMBER', NULL, '5000'),
        -- Function 2 — Per diem calculation
        t_setting('RATE_STRUCTURE', 'PER_COUNTRY',
            'Per Diem Rate Structure',
            'PER_COUNTRY = one rate per ISO country code; TIER_BASED = countries mapped to tier codes; REGION_BASED = countries mapped to region codes.',
            'SELECT', 'PER_COUNTRY|TIER_BASED|REGION_BASED', 'PER_COUNTRY'),
        t_setting('PER_DIEM_HALF_DAY_POLICY', 'NONE',
            'Half-Day Per Diem Policy',
            'NONE = full rate every day; FIRST_LAST = half rate on departure and return days; FIRST_ONLY = half rate on departure day only.',
            'SELECT', 'NONE|FIRST_LAST|FIRST_ONLY', 'NONE'),
        -- Function 4 — Settlement
        t_setting('SETTLEMENT_REQUIRE_RECEIPTS', 'Y',
            'Require Receipts in Settlement',
            'Y = receipt_attached = Y is mandatory for ACCOMMODATION and TICKET expense lines.',
            'BOOLEAN', 'Y|N', 'Y'),
        t_setting('ALLOW_SETTLEMENT_AMOUNT_EXCEED', 'N',
            'Allow Settlement to Exceed Advance',
            'Y = settlement total_actual_aed may exceed advance up to SETTLEMENT_MAX_EXCEED_PCT; N = block if exceeded.',
            'BOOLEAN', 'Y|N', 'N'),
        t_setting('SETTLEMENT_MAX_EXCEED_PCT', '120',
            'Settlement Maximum Exceed Percentage',
            'Maximum percentage of the advance that actual settlement total may reach (applies when ALLOW_SETTLEMENT_AMOUNT_EXCEED = Y).',
            'NUMBER', NULL, '120'),
        -- Number formats
        t_setting('REQUEST_NUMBER_PREFIX', 'DT-REQ',
            'Travel Request Number Prefix',
            'Prefix for auto-generated travel request numbers. Generated format: {PREFIX}-{YYYY}-{00001}.',
            'TEXT', NULL, 'DT-REQ'),
        t_setting('SETTLEMENT_NUMBER_PREFIX', 'DT-STL',
            'Settlement Number Prefix',
            'Prefix for auto-generated settlement numbers. Generated format: {PREFIX}-{YYYY}-{00001}.',
            'TEXT', NULL, 'DT-STL')
    );
BEGIN
    SELECT module_id INTO v_module_id FROM dct_modules WHERE module_code = 'DUTY_TRAVEL';

    FOR i IN 1 .. v_settings.COUNT LOOP
        MERGE INTO dct_module_settings s
        USING (SELECT v_module_id         AS module_id,
                      v_settings(i).s_key AS setting_key FROM dual) src
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
            -- NOTE: setting_value is NOT updated on re-seed to preserve admin changes
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Module settings seeded: ' || v_settings.COUNT || ' DUTY_TRAVEL settings');
END;
/

-- =============================================================================
-- 5. LOOKUP CATEGORIES AND VALUES
-- =============================================================================
DECLARE
    v_module_id  dct_modules.module_id%TYPE;
    v_cat_grade  dct_lookup_categories.category_id%TYPE;
    v_cat_doc    dct_lookup_categories.category_id%TYPE;

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
            UPDATE SET value_name_en = p_en,
                       value_name_ar = p_ar,
                       display_order = p_ord;
    END;
BEGIN
    SELECT module_id INTO v_module_id FROM dct_modules WHERE module_code = 'DUTY_TRAVEL';

    -- Employee Grades
    upsert_category('DT_EMPLOYEE_GRADE', 'Duty Travel Employee Grades',
                    'درجات الموظفين - السفر الوظيفي', v_module_id, v_cat_grade);
    upsert_value(v_cat_grade, 'EXEC',  'Executive / SCS',      'تنفيذي / كبار الخدمة المدنية', 10);
    upsert_value(v_cat_grade, 'PROF',  'Professional / Expert', 'متخصص / خبير',                 20);
    upsert_value(v_cat_grade, 'SPEC',  'Specialist',            'أخصائي',                        30);
    upsert_value(v_cat_grade, 'STAFF', 'Staff / Officer',       'موظف',                          40);
    upsert_value(v_cat_grade, 'ALL',   'All Grades (fallback)', 'جميع الدرجات (احتياطي)',        99);

    -- Document Types
    upsert_category('DT_DOCUMENT_TYPE', 'Duty Travel Document Types',
                    'أنواع وثائق السفر الوظيفي', v_module_id, v_cat_doc);
    upsert_value(v_cat_doc, 'INVITATION',       'Invitation / Approval Letter',     'خطاب الدعوة / الموافقة',      10);
    upsert_value(v_cat_doc, 'FLIGHT_TICKET',    'Flight Ticket / Itinerary',        'تذكرة الطيران / جدول الرحلة', 20);
    upsert_value(v_cat_doc, 'HOTEL_BOOKING',    'Hotel Booking Confirmation',       'تأكيد حجز الفندق',            30);
    upsert_value(v_cat_doc, 'TRAINING_ENROLL',  'Training Enrollment Letter',       'خطاب الالتحاق بالتدريب',      40);
    upsert_value(v_cat_doc, 'CONFERENCE_PROG',  'Conference / Event Programme',     'برنامج المؤتمر / الفعالية',   50);
    upsert_value(v_cat_doc, 'VISA',             'Visa Copy',                        'نسخة التأشيرة',               60);
    upsert_value(v_cat_doc, 'RECEIPT',          'Receipt / Invoice',                'إيصال / فاتورة',              70);
    upsert_value(v_cat_doc, 'OTHER',            'Other',                            'أخرى',                        99);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Lookups seeded: DT_EMPLOYEE_GRADE (5 values), DT_DOCUMENT_TYPE (8 values)');
END;
/

-- =============================================================================
-- 6. APPROVAL WORKFLOWS
--   DT_REQUEST_APPROVAL   — Step 1: DT_MANAGER (ALWAYS)
--                           Step 2: DT_FINANCE  (AMOUNT >= DT_FINANCE_APPROVAL_THRESHOLD_AED)
--   DT_SETTLEMENT_APPROVAL — Step 1: DT_MANAGER (ALWAYS)
--                            Step 2: DT_FINANCE  (ALWAYS)
-- =============================================================================
DECLARE
    v_module_id   dct_modules.module_id%TYPE;
    v_dt_mgr_id   dct_roles.role_id%TYPE;
    v_dt_fin_id   dct_roles.role_id%TYPE;
    v_tmpl_req_id dct_approval_templates.template_id%TYPE;
    v_tmpl_stl_id dct_approval_templates.template_id%TYPE;

    PROCEDURE upsert_template (
        p_code  VARCHAR2, p_name VARCHAR2, p_module_id NUMBER,
        p_rtype VARCHAR2, p_desc VARCHAR2, p_id OUT NUMBER
    ) IS
    BEGIN
        MERGE INTO dct_approval_templates t
        USING (SELECT p_code AS template_code FROM dual) src
        ON    (t.template_code = src.template_code)
        WHEN NOT MATCHED THEN
            INSERT (template_code, template_name, module_id, request_type,
                    description_en, is_sequential, auto_approve_days, is_active)
            VALUES (p_code, p_name, p_module_id, p_rtype, p_desc, 'Y', 0, 'Y')
        WHEN MATCHED THEN
            UPDATE SET template_name = p_name,
                       request_type  = p_rtype,
                       is_active     = 'Y';
        SELECT template_id INTO p_id FROM dct_approval_templates WHERE template_code = p_code;
    END;

    PROCEDURE upsert_step (
        p_template_id   NUMBER,  p_seq          NUMBER,
        p_name          VARCHAR2, p_role_id      NUMBER,
        p_cond_type     VARCHAR2, p_amount_op    VARCHAR2 DEFAULT NULL,
        p_amount_thresh NUMBER   DEFAULT NULL,   p_custom VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        MERGE INTO dct_approval_steps s
        USING (SELECT p_template_id AS template_id, p_seq AS step_seq FROM dual) src
        ON    (s.template_id = src.template_id AND s.step_seq = src.step_seq)
        WHEN NOT MATCHED THEN
            INSERT (template_id, step_seq, step_name, step_type, required_role_id,
                    escalation_days, is_mandatory, allow_skip,
                    condition_type, amount_operator, amount_threshold, custom_condition)
            VALUES (p_template_id, p_seq, p_name, 'ROLE_BASED', p_role_id,
                    3, 'Y', 'N',
                    p_cond_type, p_amount_op, p_amount_thresh, p_custom)
        WHEN MATCHED THEN
            UPDATE SET step_name        = p_name,
                       required_role_id = p_role_id,
                       condition_type   = p_cond_type,
                       amount_operator  = p_amount_op,
                       amount_threshold = p_amount_thresh,
                       custom_condition = p_custom;
    END;
BEGIN
    SELECT module_id INTO v_module_id FROM dct_modules WHERE module_code = 'DUTY_TRAVEL';
    SELECT role_id   INTO v_dt_mgr_id FROM dct_roles   WHERE role_code  = 'DT_MANAGER';
    SELECT role_id   INTO v_dt_fin_id FROM dct_roles   WHERE role_code  = 'DT_FINANCE';

    -- Travel Request Approval
    upsert_template(
        'DT_REQUEST_APPROVAL', 'Duty Travel Request Approval',
        v_module_id, 'TRAVEL_REQUEST',
        'Two-step approval for travel requests. Finance step fires when total advance meets threshold.',
        v_tmpl_req_id);
    upsert_step(v_tmpl_req_id, 10, 'Line Manager Approval', v_dt_mgr_id, 'ALWAYS');
    upsert_step(v_tmpl_req_id, 20, 'Finance Review',        v_dt_fin_id, 'AMOUNT',
                p_amount_op => '>=', p_amount_thresh => 5000);

    -- Settlement Approval
    upsert_template(
        'DT_SETTLEMENT_APPROVAL', 'Post-Travel Settlement Approval',
        v_module_id, 'SETTLEMENT',
        'Two-step approval for post-travel expense settlements.',
        v_tmpl_stl_id);
    upsert_step(v_tmpl_stl_id, 10, 'Line Manager Approval', v_dt_mgr_id, 'ALWAYS');
    upsert_step(v_tmpl_stl_id, 20, 'Finance Review',        v_dt_fin_id, 'ALWAYS');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Approval templates seeded: DT_REQUEST_APPROVAL (2 steps), DT_SETTLEMENT_APPROVAL (2 steps)');
END;
/

-- =============================================================================
-- 7. DEFAULT DOCUMENT REQUIREMENTS — DT_DOC_REQUIREMENTS
-- =============================================================================
DECLARE
    v_invitation_id  dct_lookup_values.value_id%TYPE;
    v_flight_id      dct_lookup_values.value_id%TYPE;
    v_hotel_id       dct_lookup_values.value_id%TYPE;
    v_training_id    dct_lookup_values.value_id%TYPE;
    v_conference_id  dct_lookup_values.value_id%TYPE;
    v_visa_id        dct_lookup_values.value_id%TYPE;
    v_receipt_id     dct_lookup_values.value_id%TYPE;
    v_cat_id         dct_lookup_categories.category_id%TYPE;

    PROCEDURE add_req (
        p_mtype VARCHAR2, p_dir VARCHAR2, p_dtype_id NUMBER,
        p_mand VARCHAR2, p_source VARCHAR2, p_seq NUMBER
    ) IS
    BEGIN
        MERGE INTO dt_doc_requirements t
        USING (SELECT p_mtype     AS mission_type,
                      p_dir       AS trip_type,
                      p_dtype_id  AS document_type_id,
                      p_source    AS applies_to_source FROM dual) s
        ON (t.mission_type      = s.mission_type
        AND t.trip_type    = s.trip_type
        AND t.document_type_id  = s.document_type_id
        AND t.applies_to_source = s.applies_to_source)
        WHEN NOT MATCHED THEN
            INSERT (mission_type, trip_type, document_type_id, is_mandatory,
                    applies_to_source, is_active, display_seq, created_by, updated_by)
            VALUES (p_mtype, p_dir, p_dtype_id, p_mand,
                    p_source, 'Y', p_seq, 'archa2', 'archa2')
        WHEN MATCHED THEN
            UPDATE SET is_mandatory = p_mand,
                       display_seq  = p_seq;
    END;
BEGIN
    SELECT category_id INTO v_cat_id
    FROM   dct_lookup_categories WHERE category_code = 'DT_DOCUMENT_TYPE';

    SELECT value_id INTO v_invitation_id FROM dct_lookup_values
    WHERE  category_id = v_cat_id AND value_code = 'INVITATION';
    SELECT value_id INTO v_flight_id FROM dct_lookup_values
    WHERE  category_id = v_cat_id AND value_code = 'FLIGHT_TICKET';
    SELECT value_id INTO v_hotel_id FROM dct_lookup_values
    WHERE  category_id = v_cat_id AND value_code = 'HOTEL_BOOKING';
    SELECT value_id INTO v_training_id FROM dct_lookup_values
    WHERE  category_id = v_cat_id AND value_code = 'TRAINING_ENROLL';
    SELECT value_id INTO v_conference_id FROM dct_lookup_values
    WHERE  category_id = v_cat_id AND value_code = 'CONFERENCE_PROG';
    SELECT value_id INTO v_visa_id FROM dct_lookup_values
    WHERE  category_id = v_cat_id AND value_code = 'VISA';
    SELECT value_id INTO v_receipt_id FROM dct_lookup_values
    WHERE  category_id = v_cat_id AND value_code = 'RECEIPT';

    -- BUSINESS_MISSION — External
    add_req('BUSINESS_MISSION', 'EXTERNAL', v_invitation_id,  'Y', 'REQUEST', 10);
    add_req('BUSINESS_MISSION', 'EXTERNAL', v_flight_id,       'Y', 'REQUEST', 20);
    add_req('BUSINESS_MISSION', 'EXTERNAL', v_hotel_id,        'Y', 'REQUEST', 30);
    add_req('BUSINESS_MISSION', 'EXTERNAL', v_visa_id,         'Y', 'REQUEST', 40);
    add_req('BUSINESS_MISSION', 'EXTERNAL', v_conference_id,   'N', 'REQUEST', 50);

    -- BUSINESS_MISSION — Internal
    add_req('BUSINESS_MISSION', 'INTERNAL', v_invitation_id,  'Y', 'REQUEST', 10);

    -- TRAINING — External
    add_req('TRAINING', 'EXTERNAL', v_training_id,  'Y', 'REQUEST', 10);
    add_req('TRAINING', 'EXTERNAL', v_flight_id,     'Y', 'REQUEST', 20);
    add_req('TRAINING', 'EXTERNAL', v_hotel_id,      'Y', 'REQUEST', 30);
    add_req('TRAINING', 'EXTERNAL', v_visa_id,        'Y', 'REQUEST', 40);

    -- TRAINING — Internal
    add_req('TRAINING', 'INTERNAL', v_training_id,  'Y', 'REQUEST', 10);

    -- Settlement receipts — all mission types, all directions
    add_req('ALL', 'ALL', v_receipt_id, 'Y', 'SETTLEMENT', 10);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Document requirements seeded: 12 rules across mission types and directions');
END;
/

-- =============================================================================
-- 8. PER DIEM RATES — PER_COUNTRY mode (default)
--    Rates are effective from TRUNC(SYSDATE).
--    Admin should review and adjust amounts before go-live.
-- =============================================================================
DECLARE
    TYPE t_rate IS RECORD (
        rkey  VARCHAR2(20),
        rname VARCHAR2(100),
        grade VARCHAR2(20),
        rate  NUMBER
    );
    TYPE t_rate_list IS TABLE OF t_rate;

    -- Per-country daily rates (AED), by grade
    -- Structure: (country_code, country_name_en, grade_code, daily_aed)
    v_rates t_rate_list := t_rate_list(
        -- UAE INTERNAL
        t_rate('AE','UAE (Internal)','EXEC', 350),
        t_rate('AE','UAE (Internal)','PROF', 280),
        t_rate('AE','UAE (Internal)','SPEC', 220),
        t_rate('AE','UAE (Internal)','STAFF',160),
        -- GCC
        t_rate('SA','Saudi Arabia','EXEC', 400), t_rate('SA','Saudi Arabia','PROF', 320),
        t_rate('SA','Saudi Arabia','SPEC', 260), t_rate('SA','Saudi Arabia','STAFF',200),
        t_rate('KW','Kuwait',      'EXEC', 400), t_rate('KW','Kuwait',      'PROF', 320),
        t_rate('KW','Kuwait',      'SPEC', 260), t_rate('KW','Kuwait',      'STAFF',200),
        t_rate('QA','Qatar',       'EXEC', 400), t_rate('QA','Qatar',       'PROF', 320),
        t_rate('QA','Qatar',       'SPEC', 260), t_rate('QA','Qatar',       'STAFF',200),
        t_rate('BH','Bahrain',     'EXEC', 380), t_rate('BH','Bahrain',     'PROF', 300),
        t_rate('BH','Bahrain',     'SPEC', 245), t_rate('BH','Bahrain',     'STAFF',190),
        t_rate('OM','Oman',        'EXEC', 380), t_rate('OM','Oman',        'PROF', 300),
        t_rate('OM','Oman',        'SPEC', 245), t_rate('OM','Oman',        'STAFF',190),
        -- MENA
        t_rate('EG','Egypt',       'EXEC', 360), t_rate('EG','Egypt',       'PROF', 290),
        t_rate('EG','Egypt',       'SPEC', 235), t_rate('EG','Egypt',       'STAFF',180),
        t_rate('TR','Türkiye',     'EXEC', 370), t_rate('TR','Türkiye',     'PROF', 295),
        t_rate('TR','Türkiye',     'SPEC', 240), t_rate('TR','Türkiye',     'STAFF',185),
        t_rate('JO','Jordan',      'EXEC', 340), t_rate('JO','Jordan',      'PROF', 270),
        t_rate('JO','Jordan',      'SPEC', 220), t_rate('JO','Jordan',      'STAFF',170),
        -- EUROPE
        t_rate('GB','United Kingdom','EXEC', 560), t_rate('GB','United Kingdom','PROF', 450),
        t_rate('GB','United Kingdom','SPEC', 365), t_rate('GB','United Kingdom','STAFF',285),
        t_rate('FR','France',        'EXEC', 540), t_rate('FR','France',        'PROF', 430),
        t_rate('FR','France',        'SPEC', 350), t_rate('FR','France',        'STAFF',275),
        t_rate('DE','Germany',       'EXEC', 530), t_rate('DE','Germany',       'PROF', 425),
        t_rate('DE','Germany',       'SPEC', 345), t_rate('DE','Germany',       'STAFF',270),
        t_rate('CH','Switzerland',   'EXEC', 600), t_rate('CH','Switzerland',   'PROF', 480),
        t_rate('CH','Switzerland',   'SPEC', 390), t_rate('CH','Switzerland',   'STAFF',305),
        -- AMERICAS
        t_rate('US','United States','EXEC', 600), t_rate('US','United States','PROF', 480),
        t_rate('US','United States','SPEC', 390), t_rate('US','United States','STAFF',305),
        t_rate('CA','Canada',       'EXEC', 570), t_rate('CA','Canada',       'PROF', 455),
        t_rate('CA','Canada',       'SPEC', 370), t_rate('CA','Canada',       'STAFF',290),
        -- ASIA PACIFIC
        t_rate('SG','Singapore',   'EXEC', 520), t_rate('SG','Singapore',   'PROF', 415),
        t_rate('SG','Singapore',   'SPEC', 340), t_rate('SG','Singapore',   'STAFF',265),
        t_rate('AU','Australia',   'EXEC', 555), t_rate('AU','Australia',   'PROF', 445),
        t_rate('AU','Australia',   'SPEC', 360), t_rate('AU','Australia',   'STAFF',280),
        t_rate('JP','Japan',       'EXEC', 545), t_rate('JP','Japan',       'PROF', 435),
        t_rate('JP','Japan',       'SPEC', 355), t_rate('JP','Japan',       'STAFF',275),
        t_rate('CN','China',       'EXEC', 420), t_rate('CN','China',       'PROF', 335),
        t_rate('CN','China',       'SPEC', 275), t_rate('CN','China',       'STAFF',215),
        -- SOUTH ASIA
        t_rate('IN','India',       'EXEC', 380), t_rate('IN','India',       'PROF', 300),
        t_rate('IN','India',       'SPEC', 245), t_rate('IN','India',       'STAFF',190),
        t_rate('PK','Pakistan',    'EXEC', 320), t_rate('PK','Pakistan',    'PROF', 255),
        t_rate('PK','Pakistan',    'SPEC', 205), t_rate('PK','Pakistan',    'STAFF',160),
        -- TIER codes — used when RATE_STRUCTURE = TIER_BASED
        t_rate('TIER1','Tier 1 — Western Europe, Americas, Japan, Singapore, Australia','EXEC', 560),
        t_rate('TIER1','Tier 1 — Western Europe, Americas, Japan, Singapore, Australia','PROF', 448),
        t_rate('TIER1','Tier 1 — Western Europe, Americas, Japan, Singapore, Australia','SPEC', 364),
        t_rate('TIER1','Tier 1 — Western Europe, Americas, Japan, Singapore, Australia','STAFF',280),
        t_rate('TIER2','Tier 2 — GCC, Eastern Europe, China, Korea, South America','EXEC', 420),
        t_rate('TIER2','Tier 2 — GCC, Eastern Europe, China, Korea, South America','PROF', 336),
        t_rate('TIER2','Tier 2 — GCC, Eastern Europe, China, Korea, South America','SPEC', 273),
        t_rate('TIER2','Tier 2 — GCC, Eastern Europe, China, Korea, South America','STAFF',210),
        t_rate('TIER3','Tier 3 — South Asia, Africa, Southeast Asia, MENA','EXEC', 320),
        t_rate('TIER3','Tier 3 — South Asia, Africa, Southeast Asia, MENA','PROF', 256),
        t_rate('TIER3','Tier 3 — South Asia, Africa, Southeast Asia, MENA','SPEC', 208),
        t_rate('TIER3','Tier 3 — South Asia, Africa, Southeast Asia, MENA','STAFF',160),
        -- REGION codes — used when RATE_STRUCTURE = REGION_BASED
        t_rate('GCC',     'GCC Countries',          'EXEC', 400), t_rate('GCC',     'GCC Countries',          'PROF', 320),
        t_rate('GCC',     'GCC Countries',          'SPEC', 260), t_rate('GCC',     'GCC Countries',          'STAFF',200),
        t_rate('EUROPE',  'Europe',                 'EXEC', 550), t_rate('EUROPE',  'Europe',                 'PROF', 440),
        t_rate('EUROPE',  'Europe',                 'SPEC', 358), t_rate('EUROPE',  'Europe',                 'STAFF',278),
        t_rate('AMERICAS','Americas',               'EXEC', 585), t_rate('AMERICAS','Americas',               'PROF', 468),
        t_rate('AMERICAS','Americas',               'SPEC', 380), t_rate('AMERICAS','Americas',               'STAFF',298),
        t_rate('ASIA_PAC','Asia Pacific',           'EXEC', 480), t_rate('ASIA_PAC','Asia Pacific',           'PROF', 384),
        t_rate('ASIA_PAC','Asia Pacific',           'SPEC', 312), t_rate('ASIA_PAC','Asia Pacific',           'STAFF',242),
        t_rate('MENA',    'Middle East & N. Africa','EXEC', 360), t_rate('MENA',    'Middle East & N. Africa','PROF', 288),
        t_rate('MENA',    'Middle East & N. Africa','SPEC', 234), t_rate('MENA',    'Middle East & N. Africa','STAFF',182),
        t_rate('AFRICA',  'Africa',                 'EXEC', 290), t_rate('AFRICA',  'Africa',                 'PROF', 232),
        t_rate('AFRICA',  'Africa',                 'SPEC', 188), t_rate('AFRICA',  'Africa',                 'STAFF',146)
    );
BEGIN
    FOR i IN 1 .. v_rates.COUNT LOOP
        MERGE INTO dt_per_diem_rates t
        USING (SELECT v_rates(i).rkey   AS rate_key,
                      v_rates(i).grade  AS grade_code,
                      TRUNC(SYSDATE)    AS effective_from FROM dual) s
        ON (t.rate_key      = s.rate_key
        AND t.grade_code    = s.grade_code
        AND t.effective_from = s.effective_from)
        WHEN NOT MATCHED THEN
            INSERT (rate_key, rate_key_name_en, grade_code, per_diem_daily_aed,
                    effective_from, is_active, created_by, updated_by)
            VALUES (v_rates(i).rkey, v_rates(i).rname, v_rates(i).grade, v_rates(i).rate,
                    TRUNC(SYSDATE), 'Y', 'archa2', 'archa2')
        WHEN MATCHED THEN
            UPDATE SET per_diem_daily_aed = v_rates(i).rate,
                       rate_key_name_en   = v_rates(i).rname;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Per diem rates seeded: ' || v_rates.COUNT || ' rows (country + tier + region rates)');
END;
/

-- =============================================================================
-- 9. COUNTRY GROUPS — for TIER_BASED / REGION_BASED rate structure
--    Pre-loaded for common destinations; admin can extend via Page 41 (APEX).
-- =============================================================================
DECLARE
    TYPE t_cg IS RECORD (
        ccode VARCHAR2(3), cname VARCHAR2(100), grp VARCHAR2(20)
    );
    TYPE t_cg_list IS TABLE OF t_cg;

    v_groups t_cg_list := t_cg_list(
        -- GCC
        t_cg('SA','Saudi Arabia','GCC'), t_cg('KW','Kuwait',      'GCC'),
        t_cg('QA','Qatar',       'GCC'), t_cg('BH','Bahrain',     'GCC'),
        t_cg('OM','Oman',        'GCC'),
        -- EUROPE
        t_cg('GB','United Kingdom','EUROPE'), t_cg('FR','France',     'EUROPE'),
        t_cg('DE','Germany',      'EUROPE'), t_cg('CH','Switzerland', 'EUROPE'),
        t_cg('IT','Italy',        'EUROPE'), t_cg('ES','Spain',       'EUROPE'),
        t_cg('NL','Netherlands',  'EUROPE'), t_cg('BE','Belgium',     'EUROPE'),
        t_cg('AT','Austria',      'EUROPE'), t_cg('SE','Sweden',      'EUROPE'),
        t_cg('NO','Norway',       'EUROPE'), t_cg('DK','Denmark',     'EUROPE'),
        t_cg('PL','Poland',       'EUROPE'), t_cg('PT','Portugal',    'EUROPE'),
        -- AMERICAS
        t_cg('US','United States','AMERICAS'), t_cg('CA','Canada',    'AMERICAS'),
        t_cg('MX','Mexico',       'AMERICAS'), t_cg('BR','Brazil',    'AMERICAS'),
        t_cg('AR','Argentina',    'AMERICAS'),
        -- ASIA PACIFIC
        t_cg('AU','Australia',  'ASIA_PAC'), t_cg('NZ','New Zealand',    'ASIA_PAC'),
        t_cg('JP','Japan',      'ASIA_PAC'), t_cg('SG','Singapore',      'ASIA_PAC'),
        t_cg('KR','South Korea','ASIA_PAC'), t_cg('CN','China',          'ASIA_PAC'),
        t_cg('IN','India',      'ASIA_PAC'), t_cg('TH','Thailand',       'ASIA_PAC'),
        t_cg('ID','Indonesia',  'ASIA_PAC'), t_cg('MY','Malaysia',       'ASIA_PAC'),
        t_cg('PH','Philippines','ASIA_PAC'), t_cg('VN','Vietnam',        'ASIA_PAC'),
        t_cg('PK','Pakistan',   'ASIA_PAC'),
        -- MENA (non-GCC)
        t_cg('EG','Egypt',    'MENA'), t_cg('TR','Türkiye',   'MENA'),
        t_cg('JO','Jordan',   'MENA'), t_cg('LB','Lebanon',   'MENA'),
        t_cg('MA','Morocco',  'MENA'), t_cg('TN','Tunisia',   'MENA'),
        t_cg('LY','Libya',    'MENA'), t_cg('IQ','Iraq',      'MENA'),
        -- AFRICA (sub-Saharan)
        t_cg('ZA','South Africa','AFRICA'), t_cg('KE','Kenya',  'AFRICA'),
        t_cg('NG','Nigeria',     'AFRICA'), t_cg('ET','Ethiopia','AFRICA'),
        t_cg('GH','Ghana',       'AFRICA'), t_cg('TZ','Tanzania','AFRICA')
    );
BEGIN
    FOR i IN 1 .. v_groups.COUNT LOOP
        MERGE INTO dt_country_groups t
        USING (SELECT v_groups(i).ccode AS country_code FROM dual) s
        ON    (t.country_code = s.country_code)
        WHEN NOT MATCHED THEN
            INSERT (country_code, country_name_en, group_code, is_active, created_by, updated_by)
            VALUES (v_groups(i).ccode, v_groups(i).cname, v_groups(i).grp,
                    'Y', 'archa2', 'archa2')
        WHEN MATCHED THEN
            UPDATE SET country_name_en = v_groups(i).cname,
                       group_code      = v_groups(i).grp;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Country groups seeded: ' || v_groups.COUNT || ' countries mapped to GCC/EUROPE/AMERICAS/ASIA_PAC/MENA/AFRICA');
END;
/

COMMIT;

PROMPT
PROMPT === 02_dt_seed.sql complete ===
PROMPT Module     : DUTY_TRAVEL (App 204)
PROMPT Roles      : DT_ADMIN, DT_MANAGER, DT_FINANCE
PROMPT Permissions: 17 DT.* permissions with role-permission grants
PROMPT Settings   : 19 module settings (incl. REQUEST_NUMBER_PREFIX, SETTLEMENT_NUMBER_PREFIX)
PROMPT Lookups    : DT_EMPLOYEE_GRADE (5), DT_DOCUMENT_TYPE (8)
PROMPT Approvals  : DT_REQUEST_APPROVAL (2 steps), DT_SETTLEMENT_APPROVAL (2 steps)
PROMPT Doc Reqs   : 12 default document requirement rules
PROMPT Rates      : Per-country rates (18 countries), tier rates (TIER1-3), region rates (6)
PROMPT Cty Groups : 53 countries mapped to region codes
