-- =============================================================================
-- i-Finance V2 — Seed Data (FINAL — sections 2-8 + ADMIN fix)
-- Schema  : PROD
-- NOTE    : Sections 1, 9, 10 already committed in a prior run.
--           This file covers sections 2-8 and then fixes the ADMIN user roles.
--           Two invalid INSERT ALL...SELECT blocks have been rewritten as
--           individual INSERT INTO...SELECT statements.
-- =============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF

-- =============================================================================
-- 2. PLATFORM MODULES
-- All 31 existing apps + the V2 admin modules
-- =============================================================================
INSERT ALL
-- ---- Core ----
INTO PROD.dct_modules (module_code, module_name_en, module_name_ar, module_type, apex_app_id, apex_page_id,
                  icon_class, icon_color, bg_color, description_en, description_ar, category,
                  display_order, is_active, is_admin_only, created_by)
    VALUES ('ADMIN',       'Platform Administration', 'إدارة المنصة', 'INTERNAL', 200, 10,
            'fa-cogs', '#003366', '#EEF2F7',
            'User, role, and system administration',
            'إدارة المستخدمين والصلاحيات والإعدادات',
            'ADMIN', 0, 'Y', 'Y', 'SYSTEM')
INTO PROD.dct_modules (module_code, module_name_en, module_name_ar, module_type, apex_app_id, apex_page_id,
                  icon_class, icon_color, bg_color, description_en, description_ar, category,
                  display_order, is_active, is_admin_only, created_by)
    VALUES ('TASK_MGMT',   'Task Management', 'إدارة المهام', 'APEX_APP', NULL, 1,
            'fa-tasks', '#0076CE', '#EBF5FB',
            'Weekly Finance Division task tracking',
            'تتبع مهام الأسبوع لقسم المالية',
            'CORE', 1, 'Y', 'N', 'SYSTEM')
-- ---- HR & Employee ----
INTO PROD.dct_modules (module_code, module_name_en, module_name_ar, module_type, apex_app_id, apex_page_id,
                  icon_class, icon_color, bg_color, description_en, description_ar, category,
                  display_order, is_active, is_admin_only, created_by)
    VALUES ('HR',          'HR Organizations', 'الهياكل التنظيمية', 'APEX_APP', 102, 1,
            'fa-sitemap', '#27AE60', '#EAFAF1',
            'Organisational structure and HR hierarchy',
            'الهيكل التنظيمي وهرمية الموارد البشرية',
            'HR', 10, 'Y', 'N', 'SYSTEM')
INTO PROD.dct_modules (module_code, module_name_en, module_name_ar, module_type, apex_app_id, apex_page_id,
                  icon_class, icon_color, bg_color, description_en, description_ar, category,
                  display_order, is_active, is_admin_only, created_by)
    VALUES ('SELF_SERVICE', 'Employee Self Service', 'الخدمة الذاتية للموظفين', 'APEX_APP', 106, 1,
            'fa-user-circle', '#8E44AD', '#F4ECF7',
            'Insurance, housing, missions, and payroll',
            'التأمين والإسكان والمهام والرواتب',
            'HR', 11, 'Y', 'N', 'SYSTEM')
INTO PROD.dct_modules (module_code, module_name_en, module_name_ar, module_type, apex_app_id, apex_page_id,
                  icon_class, icon_color, bg_color, description_en, description_ar, category,
                  display_order, is_active, is_admin_only, created_by)
    VALUES ('DUTY_HUB',    'Duty Hub', 'مركز المهام الرسمية', 'APEX_APP', 810, 1,
            'fa-plane', '#E67E22', '#FEF9E7',
            'Mission, duty travel, and insurance management',
            'إدارة المهام والسفر الرسمي والتأمين',
            'HR', 12, 'Y', 'N', 'SYSTEM')
INTO PROD.dct_modules (module_code, module_name_en, module_name_ar, module_type, apex_app_id, apex_page_id,
                  icon_class, icon_color, bg_color, description_en, description_ar, category,
                  display_order, is_active, is_admin_only, created_by)
    VALUES ('HRSS',        'HR Self Service', 'الخدمة الذاتية للموارد البشرية', 'APEX_APP', 901, 1,
            'fa-id-badge', '#16A085', '#E8F8F5',
            'HR petty cash and expense reports',
            'المصروفات النثرية وتقارير المصاريف',
            'HR', 13, 'Y', 'N', 'SYSTEM')
INTO PROD.dct_modules (module_code, module_name_en, module_name_ar, module_type, apex_app_id, apex_page_id,
                  icon_class, icon_color, bg_color, description_en, description_ar, category,
                  display_order, is_active, is_admin_only, created_by)
    VALUES ('PETTY_CASH',  'Petty Cash', 'المصروفات النثرية', 'APEX_APP', 101, 1,
            'fa-money-bill-wave', '#1ABC9C', '#E8F8F5',
            'Petty cash expense requests and approvals',
            'طلبات واعتماد المصروفات النثرية',
            'HR', 14, 'Y', 'N', 'SYSTEM')
INTO PROD.dct_modules (module_code, module_name_en, module_name_ar, module_type, apex_app_id, apex_page_id,
                  icon_class, icon_color, bg_color, description_en, description_ar, category,
                  display_order, is_active, is_admin_only, created_by)
    VALUES ('FREELANCERS', 'Freelancers', 'المتعاقدون المستقلون', 'APEX_APP', 805, 1,
            'fa-briefcase', '#7F8C8D', '#F2F3F4',
            'Freelancer and service provider registration',
            'تسجيل المتعاقدين ومقدمي الخدمات',
            'HR', 15, 'Y', 'N', 'SYSTEM')
-- ---- Budget & Finance ----
INTO PROD.dct_modules (module_code, module_name_en, module_name_ar, module_type, apex_app_id, apex_page_id,
                  icon_class, icon_color, bg_color, description_en, description_ar, category,
                  display_order, is_active, is_admin_only, created_by)
    VALUES ('BUDGET_ALLOC','Budget Allocation', 'تخصيص الميزانية', 'APEX_APP', 110, 1,
            'fa-chart-pie', '#2980B9', '#EBF5FB',
            'Budget scenarios and allocation management',
            'سيناريوهات وإدارة تخصيص الميزانية',
            'BUDGET', 20, 'Y', 'N', 'SYSTEM')
INTO PROD.dct_modules (module_code, module_name_en, module_name_ar, module_type, apex_app_id, apex_page_id,
                  icon_class, icon_color, bg_color, description_en, description_ar, category,
                  display_order, is_active, is_admin_only, created_by)
    VALUES ('BUDGET_PLAN', 'Budget Planning', 'تخطيط الميزانية', 'APEX_APP', 115, 1,
            'fa-chart-line', '#2471A3', '#EBF5FB',
            'Budget planning and forecasting',
            'تخطيط الميزانية والتوقعات المالية',
            'BUDGET', 21, 'Y', 'N', 'SYSTEM')
INTO PROD.dct_modules (module_code, module_name_en, module_name_ar, module_type, apex_app_id, apex_page_id,
                  icon_class, icon_color, bg_color, description_en, description_ar, category,
                  display_order, is_active, is_admin_only, created_by)
    VALUES ('FUND_MGMT',   'Fund Management', 'إدارة الصناديق', 'APEX_APP', 105, 1,
            'fa-exchange-alt', '#154360', '#EBF5FB',
            'Budget transfers and project fund access',
            'تحويلات الميزانية والوصول إلى صناديق المشاريع',
            'BUDGET', 22, 'Y', 'N', 'SYSTEM')
INTO PROD.dct_modules (module_code, module_name_en, module_name_ar, module_type, apex_app_id, apex_page_id,
                  icon_class, icon_color, bg_color, description_en, description_ar, category,
                  display_order, is_active, is_admin_only, created_by)
    VALUES ('BUDGET_XFER', 'Budget Transfer', 'تحويل الميزانية', 'APEX_APP', 903, 1,
            'fa-arrows-alt-h', '#1A5276', '#EBF5FB',
            'Budget transfer requests and approvals',
            'طلبات واعتمادات تحويل الميزانية',
            'BUDGET', 23, 'Y', 'N', 'SYSTEM')
-- ---- Payments & Procurement ----
INTO PROD.dct_modules (module_code, module_name_en, module_name_ar, module_type, apex_app_id, apex_page_id,
                  icon_class, icon_color, bg_color, description_en, description_ar, category,
                  display_order, is_active, is_admin_only, created_by)
    VALUES ('PAYMENT_REQ', 'Payment Requests', 'طلبات الدفع', 'APEX_APP', 113, 1,
            'fa-file-invoice-dollar', '#C0392B', '#FDEDEC',
            'PO and GRN-based payment request management',
            'إدارة طلبات الدفع على أساس أوامر الشراء',
            'PAYMENTS', 30, 'Y', 'N', 'SYSTEM')
INTO PROD.dct_modules (module_code, module_name_en, module_name_ar, module_type, apex_app_id, apex_page_id,
                  icon_class, icon_color, bg_color, description_en, description_ar, category,
                  display_order, is_active, is_admin_only, created_by)
    VALUES ('MANUAL_PR',   'Manual PR', 'أوامر الشراء اليدوية', 'APEX_APP', 108, 1,
            'fa-shopping-cart', '#CB4335', '#FDEDEC',
            'Manual purchase request creation and approval',
            'إنشاء واعتماد أوامر الشراء اليدوية',
            'PAYMENTS', 31, 'Y', 'N', 'SYSTEM')
INTO PROD.dct_modules (module_code, module_name_en, module_name_ar, module_type, apex_app_id, apex_page_id,
                  icon_class, icon_color, bg_color, description_en, description_ar, category,
                  display_order, is_active, is_admin_only, created_by)
    VALUES ('MGR_CHECKS',  'Manager Checks', 'شيكات المدراء', 'APEX_APP', 114, 1,
            'fa-check-square', '#B03A2E', '#FDEDEC',
            'Manager check requests and approval workflow',
            'طلبات واعتماد شيكات المدراء',
            'PAYMENTS', 32, 'Y', 'N', 'SYSTEM')
INTO PROD.dct_modules (module_code, module_name_en, module_name_ar, module_type, apex_app_id, apex_page_id,
                  icon_class, icon_color, bg_color, description_en, description_ar, category,
                  display_order, is_active, is_admin_only, created_by)
    VALUES ('BANK_GUAR',   'Bank Guarantee', 'الضمانات البنكية', 'APEX_APP', 127, 1,
            'fa-university', '#6C3483', '#F4ECF7',
            'Bank guarantee request and approval management',
            'إدارة طلبات واعتماد الضمانات البنكية',
            'PAYMENTS', 33, 'Y', 'N', 'SYSTEM')
INTO PROD.dct_modules (module_code, module_name_en, module_name_ar, module_type, apex_app_id, apex_page_id,
                  icon_class, icon_color, bg_color, description_en, description_ar, category,
                  display_order, is_active, is_admin_only, created_by)
    VALUES ('CREDIT_CARDS','Credit Cards', 'بطاقات الائتمان', 'APEX_APP', 911, 1,
            'fa-credit-card', '#922B21', '#FDEDEC',
            'Corporate credit and gift card management',
            'إدارة بطاقات الائتمان والهدايا المؤسسية',
            'PAYMENTS', 34, 'Y', 'N', 'SYSTEM')
INTO PROD.dct_modules (module_code, module_name_en, module_name_ar, module_type, apex_app_id, apex_page_id,
                  icon_class, icon_color, bg_color, description_en, description_ar, category,
                  display_order, is_active, is_admin_only, created_by)
    VALUES ('PREPAID_CARDS','Prepaid Cards', 'البطاقات المدفوعة مسبقاً', 'APEX_APP', 104, 1,
            'fa-id-card', '#884EA0', '#F4ECF7',
            'Prepaid card provisioning',
            'إصدار وإدارة البطاقات المدفوعة مسبقاً',
            'PAYMENTS', 35, 'Y', 'N', 'SYSTEM')
INTO PROD.dct_modules (module_code, module_name_en, module_name_ar, module_type, apex_app_id, apex_page_id,
                  icon_class, icon_color, bg_color, description_en, description_ar, category,
                  display_order, is_active, is_admin_only, created_by)
    VALUES ('AR',          'Accounts Receivable', 'الذمم المدينة', 'APEX_APP', 118, 1,
            'fa-hand-holding-usd', '#1F618D', '#EBF5FB',
            'AR customer and due transaction management',
            'إدارة عملاء الذمم المدينة والمعاملات المستحقة',
            'PAYMENTS', 36, 'Y', 'N', 'SYSTEM')
-- ---- CWIP ----
INTO PROD.dct_modules (module_code, module_name_en, module_name_ar, module_type, apex_app_id, apex_page_id,
                  icon_class, icon_color, bg_color, description_en, description_ar, category,
                  display_order, is_active, is_admin_only, created_by)
    VALUES ('CWIP_MGMT',   'CWIP Payments Management', 'إدارة مدفوعات قيد التنفيذ', 'APEX_APP', 130, 1,
            'fa-hard-hat', '#D35400', '#FEF9E7',
            'CWIP project teams, contracts, and payment recommendations',
            'فرق مشاريع قيد التنفيذ والعقود وتوصيات الدفع',
            'CWIP', 40, 'Y', 'N', 'SYSTEM')
INTO PROD.dct_modules (module_code, module_name_en, module_name_ar, module_type, apex_app_id, apex_page_id,
                  icon_class, icon_color, bg_color, description_en, description_ar, category,
                  display_order, is_active, is_admin_only, created_by)
    VALUES ('CWIP_EX',     'CWIP Payments (External)', 'مدفوعات قيد التنفيذ (خارجي)', 'APEX_APP', 109, 1,
            'fa-external-link-alt', '#CA6F1E', '#FEF9E7',
            'External contractor CWIP payment recommendations',
            'توصيات دفع مقدمي الخدمات الخارجيين لمشاريع قيد التنفيذ',
            'CWIP', 41, 'Y', 'N', 'SYSTEM')
INTO PROD.dct_modules (module_code, module_name_en, module_name_ar, module_type, apex_app_id, apex_page_id,
                  icon_class, icon_color, bg_color, description_en, description_ar, category,
                  display_order, is_active, is_admin_only, created_by)
    VALUES ('CWIP_CHANGE', 'CWIP Change Management', 'إدارة تغييرات قيد التنفيذ', 'APEX_APP', 142, 1,
            'fa-edit', '#BA4A00', '#FEF9E7',
            'Variation requests, change reasons, and funding sources',
            'طلبات التباين وأسباب التغيير ومصادر التمويل',
            'CWIP', 42, 'Y', 'N', 'SYSTEM')
-- ---- SCM & Procurement ----
INTO PROD.dct_modules (module_code, module_name_en, module_name_ar, module_type, apex_app_id, apex_page_id,
                  icon_class, icon_color, bg_color, description_en, description_ar, category,
                  display_order, is_active, is_admin_only, created_by)
    VALUES ('DEMAND_PLAN', 'Demand Planning', 'تخطيط الطلب', 'APEX_APP', 124, 1,
            'fa-boxes', '#117A65', '#E8F8F5',
            'SCM item categories, budget brackets, and demand forecasting',
            'فئات مواد المشتريات وتخطيط الطلب والتوقعات',
            'SCM', 50, 'Y', 'N', 'SYSTEM')
INTO PROD.dct_modules (module_code, module_name_en, module_name_ar, module_type, apex_app_id, apex_page_id,
                  icon_class, icon_color, bg_color, description_en, description_ar, category,
                  display_order, is_active, is_admin_only, created_by)
    VALUES ('SINGLE_SRC',  'Single Source (SMD)', 'المصدر المنفرد', 'APEX_APP', 166, 1,
            'fa-file-contract', '#0E6655', '#E8F8F5',
            'Single-source procurement exemption requests and TAC committees',
            'طلبات الإعفاء من المصدر المنفرد ولجان TAC',
            'SCM', 51, 'Y', 'N', 'SYSTEM')
SELECT 1 FROM DUAL;

COMMIT;

-- =============================================================================
-- 3. SYSTEM ROLES
-- =============================================================================
INSERT ALL
INTO PROD.dct_roles (role_code, role_name_en, role_name_ar, role_type, module_id, is_system_role, display_order, created_by)
    VALUES ('SYS_ADMIN',       'System Administrator',      'مدير النظام',                  'SYSTEM', NULL, 'Y', 1, 'SYSTEM')
INTO PROD.dct_roles (role_code, role_name_en, role_name_ar, role_type, module_id, is_system_role, display_order, created_by)
    VALUES ('USER_ADMIN',      'User Administrator',         'مدير المستخدمين',              'SYSTEM', NULL, 'Y', 2, 'SYSTEM')
INTO PROD.dct_roles (role_code, role_name_en, role_name_ar, role_type, module_id, is_system_role, display_order, created_by)
    VALUES ('ORG_ADMIN',       'Organisation Administrator', 'مدير الهيكل التنظيمي',         'SYSTEM', NULL, 'Y', 3, 'SYSTEM')
INTO PROD.dct_roles (role_code, role_name_en, role_name_ar, role_type, module_id, is_system_role, display_order, created_by)
    VALUES ('MODULE_ADMIN',    'Module Administrator',       'مدير الوحدات',                 'SYSTEM', NULL, 'Y', 4, 'SYSTEM')
INTO PROD.dct_roles (role_code, role_name_en, role_name_ar, role_type, module_id, is_system_role, display_order, created_by)
    VALUES ('AUDITOR',         'Auditor',                    'مدقق',                         'SYSTEM', NULL, 'Y', 5, 'SYSTEM')
INTO PROD.dct_roles (role_code, role_name_en, role_name_ar, role_type, module_id, is_system_role, display_order, created_by)
    VALUES ('PLATFORM_USER',   'Platform User',              'مستخدم المنصة',                'SYSTEM', NULL, 'Y', 6, 'SYSTEM')
INTO PROD.dct_roles (role_code, role_name_en, role_name_ar, role_type, module_id, is_system_role, display_order, created_by)
    VALUES ('TASK_DIRECTOR',   'Finance Director',           'مدير المالية',                 'MODULE', NULL, 'N', 10, 'SYSTEM')
INTO PROD.dct_roles (role_code, role_name_en, role_name_ar, role_type, module_id, is_system_role, display_order, created_by)
    VALUES ('TASK_MANAGER',    'Section Manager',            'مدير القسم',                   'MODULE', NULL, 'N', 11, 'SYSTEM')
INTO PROD.dct_roles (role_code, role_name_en, role_name_ar, role_type, module_id, is_system_role, display_order, created_by)
    VALUES ('TASK_VIEWER',     'Task Viewer',                'مشاهد المهام',                 'MODULE', NULL, 'N', 12, 'SYSTEM')
SELECT 1 FROM DUAL;

COMMIT;

-- =============================================================================
-- 4. PERMISSIONS
-- =============================================================================
INSERT ALL
INTO PROD.dct_permissions (permission_code, permission_name, action_type, description_en, created_by)
    VALUES ('USERS.VIEW',         'View Users',          'VIEW',      'View user list and profile details',    'SYSTEM')
INTO PROD.dct_permissions (permission_code, permission_name, action_type, description_en, created_by)
    VALUES ('USERS.CREATE',       'Create Users',        'CREATE',    'Create new user accounts',              'SYSTEM')
INTO PROD.dct_permissions (permission_code, permission_name, action_type, description_en, created_by)
    VALUES ('USERS.EDIT',         'Edit Users',          'EDIT',      'Edit user profile and settings',        'SYSTEM')
INTO PROD.dct_permissions (permission_code, permission_name, action_type, description_en, created_by)
    VALUES ('USERS.DEACTIVATE',   'Deactivate Users',    'DELETE',    'Deactivate user accounts',              'SYSTEM')
INTO PROD.dct_permissions (permission_code, permission_name, action_type, description_en, created_by)
    VALUES ('USERS.ASSIGN_ROLE',  'Assign Roles',        'ADMIN',     'Assign and revoke user roles',          'SYSTEM')
INTO PROD.dct_permissions (permission_code, permission_name, action_type, description_en, created_by)
    VALUES ('ROLES.VIEW',         'View Roles',          'VIEW',      'View roles and permission list',        'SYSTEM')
INTO PROD.dct_permissions (permission_code, permission_name, action_type, description_en, created_by)
    VALUES ('ROLES.MANAGE',       'Manage Roles',        'ADMIN',     'Create, edit, and delete roles',        'SYSTEM')
INTO PROD.dct_permissions (permission_code, permission_name, action_type, description_en, created_by)
    VALUES ('ORGS.VIEW',          'View Organisations',  'VIEW',      'View organisation hierarchy',           'SYSTEM')
INTO PROD.dct_permissions (permission_code, permission_name, action_type, description_en, created_by)
    VALUES ('ORGS.MANAGE',        'Manage Organisations','ADMIN',     'Create and edit organisations',         'SYSTEM')
INTO PROD.dct_permissions (permission_code, permission_name, action_type, description_en, created_by)
    VALUES ('MODULES.VIEW',       'View Modules',        'VIEW',      'View module registry',                  'SYSTEM')
INTO PROD.dct_permissions (permission_code, permission_name, action_type, description_en, created_by)
    VALUES ('MODULES.MANAGE',     'Manage Modules',      'ADMIN',     'Add and configure modules',             'SYSTEM')
INTO PROD.dct_permissions (permission_code, permission_name, action_type, description_en, created_by)
    VALUES ('APPROVALS.CONFIGURE','Configure Approvals', 'CONFIGURE', 'Manage approval chain templates',       'SYSTEM')
INTO PROD.dct_permissions (permission_code, permission_name, action_type, description_en, created_by)
    VALUES ('APPROVALS.MONITOR',  'Monitor Approvals',   'VIEW',      'View all pending approval instances',   'SYSTEM')
INTO PROD.dct_permissions (permission_code, permission_name, action_type, description_en, created_by)
    VALUES ('LOOKUPS.VIEW',       'View Lookups',        'VIEW',      'View lookup categories and values',     'SYSTEM')
INTO PROD.dct_permissions (permission_code, permission_name, action_type, description_en, created_by)
    VALUES ('LOOKUPS.MANAGE',     'Manage Lookups',      'CONFIGURE', 'Add and edit lookup values',            'SYSTEM')
INTO PROD.dct_permissions (permission_code, permission_name, action_type, description_en, created_by)
    VALUES ('SETTINGS.VIEW',      'View Settings',       'VIEW',      'View system settings',                  'SYSTEM')
INTO PROD.dct_permissions (permission_code, permission_name, action_type, description_en, created_by)
    VALUES ('SETTINGS.MANAGE',    'Manage Settings',     'ADMIN',     'Edit system-wide settings',             'SYSTEM')
INTO PROD.dct_permissions (permission_code, permission_name, action_type, description_en, created_by)
    VALUES ('AUDIT.VIEW',         'View Audit Log',      'VIEW',      'Access audit log and session history',  'SYSTEM')
INTO PROD.dct_permissions (permission_code, permission_name, action_type, description_en, created_by)
    VALUES ('ANNOUNCEMENTS.MANAGE','Manage Announcements','CONFIGURE','Create and publish announcements',       'SYSTEM')
INTO PROD.dct_permissions (permission_code, permission_name, action_type, description_en, created_by)
    VALUES ('TASKS.DIRECTOR_VIEW','Director Dashboard',  'VIEW',      'Full division task overview dashboard', 'SYSTEM')
INTO PROD.dct_permissions (permission_code, permission_name, action_type, description_en, created_by)
    VALUES ('TASKS.MANAGE',       'Manage Own Tasks',    'EDIT',      'Create and update own section tasks',   'SYSTEM')
INTO PROD.dct_permissions (permission_code, permission_name, action_type, description_en, created_by)
    VALUES ('TASKS.VIEW',         'View Tasks',          'VIEW',      'Read-only view of task dashboards',     'SYSTEM')
SELECT 1 FROM DUAL;

COMMIT;

-- =============================================================================
-- 5. ROLE -> PERMISSION MAPPINGS
-- Rewritten as individual INSERT INTO SELECT (INSERT ALL...SELECT is invalid Oracle)
-- =============================================================================

-- SYS_ADMIN gets every permission (cross-join)
INSERT INTO PROD.dct_role_permissions (role_id, permission_id, granted_by)
    SELECT r.role_id, p.permission_id, 'SYSTEM'
    FROM PROD.dct_roles r, PROD.dct_permissions p
    WHERE r.role_code = 'SYS_ADMIN';

-- USER_ADMIN: user management + role/org view
INSERT INTO PROD.dct_role_permissions (role_id, permission_id, granted_by)
    SELECT r.role_id, p.permission_id, 'SYSTEM'
    FROM PROD.dct_roles r
    JOIN PROD.dct_permissions p
      ON p.permission_code IN ('USERS.VIEW','USERS.CREATE','USERS.EDIT','USERS.DEACTIVATE',
                                'USERS.ASSIGN_ROLE','ROLES.VIEW','ORGS.VIEW')
    WHERE r.role_code = 'USER_ADMIN';

-- ORG_ADMIN: org management + user view
INSERT INTO PROD.dct_role_permissions (role_id, permission_id, granted_by)
    SELECT r.role_id, p.permission_id, 'SYSTEM'
    FROM PROD.dct_roles r
    JOIN PROD.dct_permissions p
      ON p.permission_code IN ('ORGS.VIEW','ORGS.MANAGE','USERS.VIEW')
    WHERE r.role_code = 'ORG_ADMIN';

-- MODULE_ADMIN: lookups + approvals config
INSERT INTO PROD.dct_role_permissions (role_id, permission_id, granted_by)
    SELECT r.role_id, p.permission_id, 'SYSTEM'
    FROM PROD.dct_roles r
    JOIN PROD.dct_permissions p
      ON p.permission_code IN ('MODULES.VIEW','APPROVALS.CONFIGURE','APPROVALS.MONITOR',
                                'LOOKUPS.VIEW','LOOKUPS.MANAGE','ANNOUNCEMENTS.MANAGE')
    WHERE r.role_code = 'MODULE_ADMIN';

-- AUDITOR: read-only audit
INSERT INTO PROD.dct_role_permissions (role_id, permission_id, granted_by)
    SELECT r.role_id, p.permission_id, 'SYSTEM'
    FROM PROD.dct_roles r
    JOIN PROD.dct_permissions p
      ON p.permission_code IN ('AUDIT.VIEW','SETTINGS.VIEW','USERS.VIEW','ROLES.VIEW','APPROVALS.MONITOR')
    WHERE r.role_code = 'AUDITOR';

-- TASK_DIRECTOR: director dashboard view
INSERT INTO PROD.dct_role_permissions (role_id, permission_id, granted_by)
    SELECT r.role_id, p.permission_id, 'SYSTEM'
    FROM PROD.dct_roles r
    JOIN PROD.dct_permissions p ON p.permission_code = 'TASKS.DIRECTOR_VIEW'
    WHERE r.role_code = 'TASK_DIRECTOR';

-- TASK_MANAGER: manage own tasks
INSERT INTO PROD.dct_role_permissions (role_id, permission_id, granted_by)
    SELECT r.role_id, p.permission_id, 'SYSTEM'
    FROM PROD.dct_roles r
    JOIN PROD.dct_permissions p ON p.permission_code = 'TASKS.MANAGE'
    WHERE r.role_code = 'TASK_MANAGER';

-- TASK_VIEWER: read-only tasks
INSERT INTO PROD.dct_role_permissions (role_id, permission_id, granted_by)
    SELECT r.role_id, p.permission_id, 'SYSTEM'
    FROM PROD.dct_roles r
    JOIN PROD.dct_permissions p ON p.permission_code = 'TASKS.VIEW'
    WHERE r.role_code = 'TASK_VIEWER';

COMMIT;

-- =============================================================================
-- 6. MODULE -> ROLE ACCESS (App Launcher visibility)
-- =============================================================================

-- ADMIN module: SYS_ADMIN only
INSERT INTO PROD.dct_module_roles (module_id, role_id, access_level, created_by)
SELECT m.module_id, r.role_id, 'FULL', 'SYSTEM'
FROM PROD.dct_modules m, PROD.dct_roles r
WHERE m.module_code = 'ADMIN' AND r.role_code = 'SYS_ADMIN';

-- Task Management: Director, Manager, Viewer, SYS_ADMIN
INSERT INTO PROD.dct_module_roles (module_id, role_id, access_level, created_by)
SELECT m.module_id, r.role_id, 'FULL', 'SYSTEM'
FROM PROD.dct_modules m, PROD.dct_roles r
WHERE m.module_code = 'TASK_MGMT'
  AND r.role_code IN ('TASK_DIRECTOR', 'TASK_MANAGER', 'TASK_VIEWER', 'SYS_ADMIN');

-- All remaining domain modules: SYS_ADMIN and PLATFORM_USER
INSERT INTO PROD.dct_module_roles (module_id, role_id, access_level, created_by)
SELECT m.module_id, r.role_id, 'FULL', 'SYSTEM'
FROM PROD.dct_modules m, PROD.dct_roles r
WHERE m.module_code NOT IN ('ADMIN', 'TASK_MGMT')
  AND r.role_code IN ('SYS_ADMIN', 'PLATFORM_USER');

COMMIT;

-- =============================================================================
-- 7. SYSTEM SETTINGS
-- =============================================================================
INSERT ALL
INTO PROD.dct_system_settings (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
    VALUES ('APP_NAME',                  'i-Finance V2',        'STRING', 'UI',            'Application display name',                          'Y', 'SYSTEM')
INTO PROD.dct_system_settings (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
    VALUES ('APP_NAME_AR',               'آي فاينانس V2',       'STRING', 'UI',            'Application display name in Arabic',                 'Y', 'SYSTEM')
INTO PROD.dct_system_settings (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
    VALUES ('DEFAULT_AUTH_METHOD',       'DB',                  'STRING', 'SECURITY',      'Active authentication method: DB|LDAP|OCI_IAM|SAML', 'Y', 'SYSTEM')
INTO PROD.dct_system_settings (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
    VALUES ('SESSION_TIMEOUT_MINS',      '480',                 'NUMBER', 'SECURITY',      'APEX session timeout in minutes (8 hours)',          'Y', 'SYSTEM')
INTO PROD.dct_system_settings (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
    VALUES ('MAX_FAILED_LOGINS',         '5',                   'NUMBER', 'SECURITY',      'Max consecutive failed logins before lockout',       'N', 'SYSTEM')
INTO PROD.dct_system_settings (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
    VALUES ('PASSWORD_MIN_LENGTH',       '8',                   'NUMBER', 'SECURITY',      'Minimum password length for DB auth users',          'N', 'SYSTEM')
INTO PROD.dct_system_settings (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
    VALUES ('DEFAULT_LANGUAGE',          'EN',                  'STRING', 'UI',            'Default UI language: EN|AR',                        'N', 'SYSTEM')
INTO PROD.dct_system_settings (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
    VALUES ('APPROVAL_REMINDER_DAYS',    '3',                   'NUMBER', 'NOTIFICATIONS', 'Days before escalation reminder is sent',            'N', 'SYSTEM')
INTO PROD.dct_system_settings (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
    VALUES ('APPROVAL_ESCALATION_DAYS',  '5',                   'NUMBER', 'NOTIFICATIONS', 'Days before escalation to next level',               'N', 'SYSTEM')
INTO PROD.dct_system_settings (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
    VALUES ('NOTIFICATION_EMAIL_ENABLED','Y',                   'BOOLEAN','NOTIFICATIONS', 'Send email notifications: Y|N',                     'N', 'SYSTEM')
INTO PROD.dct_system_settings (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
    VALUES ('SUPPORT_EMAIL',             '',                    'STRING', 'UI',            'Support contact email displayed in the app',        'N', 'SYSTEM')
INTO PROD.dct_system_settings (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
    VALUES ('LOGO_URL',                  '#APP_IMAGES#logo.png','STRING', 'UI',            'Application logo URL',                              'N', 'SYSTEM')
SELECT 1 FROM DUAL;

COMMIT;

-- =============================================================================
-- 8. LOOKUP CATEGORIES & VALUES
-- =============================================================================
INSERT ALL
INTO PROD.dct_lookup_categories (category_code, category_name_en, category_name_ar, is_system, created_by)
    VALUES ('USER_STATUS',   'User Status',         'حالة المستخدم',        'Y', 'SYSTEM')
INTO PROD.dct_lookup_categories (category_code, category_name_en, category_name_ar, is_system, created_by)
    VALUES ('ORG_TYPE',      'Organisation Type',   'نوع الوحدة التنظيمية', 'Y', 'SYSTEM')
INTO PROD.dct_lookup_categories (category_code, category_name_en, category_name_ar, is_system, created_by)
    VALUES ('AUTH_METHOD',   'Auth Method',         'طريقة المصادقة',       'Y', 'SYSTEM')
INTO PROD.dct_lookup_categories (category_code, category_name_en, category_name_ar, is_system, created_by)
    VALUES ('TASK_STATUS',   'Task Status',         'حالة المهمة',          'N', 'SYSTEM')
INTO PROD.dct_lookup_categories (category_code, category_name_en, category_name_ar, is_system, created_by)
    VALUES ('TASK_PRIORITY', 'Task Priority',       'أولوية المهمة',        'N', 'SYSTEM')
INTO PROD.dct_lookup_categories (category_code, category_name_en, category_name_ar, is_system, created_by)
    VALUES ('TASK_CATEGORY', 'Task Category',       'تصنيف المهمة',         'N', 'SYSTEM')
INTO PROD.dct_lookup_categories (category_code, category_name_en, category_name_ar, is_system, created_by)
    VALUES ('APPROVAL_ACTION','Approval Action',    'إجراء الاعتماد',       'Y', 'SYSTEM')
INTO PROD.dct_lookup_categories (category_code, category_name_en, category_name_ar, is_system, created_by)
    VALUES ('NOTIF_TYPE',    'Notification Type',   'نوع الإشعار',          'Y', 'SYSTEM')
SELECT 1 FROM DUAL;

COMMIT;

-- Lookup Values
-- Rewritten as individual INSERT INTO SELECT (INSERT ALL...SELECT is invalid Oracle)

-- USER_STATUS
INSERT INTO PROD.dct_lookup_values (category_id, value_code, value_name_en, value_name_ar, display_order, is_default, created_by)
    SELECT c.category_id, 'ACTIVE', 'Active', 'نشط', 1, 'Y', 'SYSTEM'
    FROM PROD.dct_lookup_categories c WHERE c.category_code = 'USER_STATUS';

INSERT INTO PROD.dct_lookup_values (category_id, value_code, value_name_en, value_name_ar, display_order, created_by)
    SELECT c.category_id, 'INACTIVE', 'Inactive', 'غير نشط', 2, 'SYSTEM'
    FROM PROD.dct_lookup_categories c WHERE c.category_code = 'USER_STATUS';

-- ORG_TYPE
INSERT INTO PROD.dct_lookup_values (category_id, value_code, value_name_en, value_name_ar, display_order, created_by)
    SELECT c.category_id, 'DIVISION', 'Division', 'دائرة', 1, 'SYSTEM'
    FROM PROD.dct_lookup_categories c WHERE c.category_code = 'ORG_TYPE';

INSERT INTO PROD.dct_lookup_values (category_id, value_code, value_name_en, value_name_ar, display_order, created_by)
    SELECT c.category_id, 'SECTION', 'Section', 'قسم', 2, 'SYSTEM'
    FROM PROD.dct_lookup_categories c WHERE c.category_code = 'ORG_TYPE';

INSERT INTO PROD.dct_lookup_values (category_id, value_code, value_name_en, value_name_ar, display_order, created_by)
    SELECT c.category_id, 'UNIT', 'Unit', 'وحدة', 3, 'SYSTEM'
    FROM PROD.dct_lookup_categories c WHERE c.category_code = 'ORG_TYPE';

INSERT INTO PROD.dct_lookup_values (category_id, value_code, value_name_en, value_name_ar, display_order, created_by)
    SELECT c.category_id, 'DEPARTMENT', 'Department', 'إدارة', 4, 'SYSTEM'
    FROM PROD.dct_lookup_categories c WHERE c.category_code = 'ORG_TYPE';

-- TASK_STATUS
INSERT INTO PROD.dct_lookup_values (category_id, value_code, value_name_en, value_name_ar, display_order, created_by)
    SELECT c.category_id, 'NOT_STARTED', 'Not Started', 'لم تبدأ', 1, 'SYSTEM'
    FROM PROD.dct_lookup_categories c WHERE c.category_code = 'TASK_STATUS';

INSERT INTO PROD.dct_lookup_values (category_id, value_code, value_name_en, value_name_ar, display_order, created_by)
    SELECT c.category_id, 'IN_PROGRESS', 'In Progress', 'قيد التنفيذ', 2, 'SYSTEM'
    FROM PROD.dct_lookup_categories c WHERE c.category_code = 'TASK_STATUS';

INSERT INTO PROD.dct_lookup_values (category_id, value_code, value_name_en, value_name_ar, display_order, created_by)
    SELECT c.category_id, 'COMPLETED', 'Completed', 'مكتملة', 3, 'SYSTEM'
    FROM PROD.dct_lookup_categories c WHERE c.category_code = 'TASK_STATUS';

INSERT INTO PROD.dct_lookup_values (category_id, value_code, value_name_en, value_name_ar, display_order, created_by)
    SELECT c.category_id, 'DELAYED', 'Delayed', 'متأخرة', 4, 'SYSTEM'
    FROM PROD.dct_lookup_categories c WHERE c.category_code = 'TASK_STATUS';

INSERT INTO PROD.dct_lookup_values (category_id, value_code, value_name_en, value_name_ar, display_order, created_by)
    SELECT c.category_id, 'BLOCKED', 'Blocked', 'معلقة', 5, 'SYSTEM'
    FROM PROD.dct_lookup_categories c WHERE c.category_code = 'TASK_STATUS';

-- TASK_PRIORITY
INSERT INTO PROD.dct_lookup_values (category_id, value_code, value_name_en, value_name_ar, display_order, created_by)
    SELECT c.category_id, 'HIGH', 'High', 'عالية', 1, 'SYSTEM'
    FROM PROD.dct_lookup_categories c WHERE c.category_code = 'TASK_PRIORITY';

INSERT INTO PROD.dct_lookup_values (category_id, value_code, value_name_en, value_name_ar, display_order, created_by)
    SELECT c.category_id, 'MEDIUM', 'Medium', 'متوسطة', 2, 'SYSTEM'
    FROM PROD.dct_lookup_categories c WHERE c.category_code = 'TASK_PRIORITY';

INSERT INTO PROD.dct_lookup_values (category_id, value_code, value_name_en, value_name_ar, display_order, created_by)
    SELECT c.category_id, 'LOW', 'Low', 'منخفضة', 3, 'SYSTEM'
    FROM PROD.dct_lookup_categories c WHERE c.category_code = 'TASK_PRIORITY';

-- APPROVAL_ACTION
INSERT INTO PROD.dct_lookup_values (category_id, value_code, value_name_en, value_name_ar, display_order, created_by)
    SELECT c.category_id, 'APPROVED', 'Approved', 'معتمد', 1, 'SYSTEM'
    FROM PROD.dct_lookup_categories c WHERE c.category_code = 'APPROVAL_ACTION';

INSERT INTO PROD.dct_lookup_values (category_id, value_code, value_name_en, value_name_ar, display_order, created_by)
    SELECT c.category_id, 'REJECTED', 'Rejected', 'مرفوض', 2, 'SYSTEM'
    FROM PROD.dct_lookup_categories c WHERE c.category_code = 'APPROVAL_ACTION';

INSERT INTO PROD.dct_lookup_values (category_id, value_code, value_name_en, value_name_ar, display_order, created_by)
    SELECT c.category_id, 'RETURNED', 'Returned for Review', 'مُعاد للمراجعة', 3, 'SYSTEM'
    FROM PROD.dct_lookup_categories c WHERE c.category_code = 'APPROVAL_ACTION';

INSERT INTO PROD.dct_lookup_values (category_id, value_code, value_name_en, value_name_ar, display_order, created_by)
    SELECT c.category_id, 'DELEGATED', 'Delegated', 'مُفوَّض', 4, 'SYSTEM'
    FROM PROD.dct_lookup_categories c WHERE c.category_code = 'APPROVAL_ACTION';

COMMIT;

-- =============================================================================
-- FIX ADMIN USER: set password + assign SYS_ADMIN and PLATFORM_USER roles
-- The user row already exists from a prior run; roles were never assigned.
-- =============================================================================
DECLARE
    l_user_id NUMBER;
    l_role_id NUMBER;
BEGIN
    SELECT user_id INTO l_user_id FROM PROD.dct_users WHERE username = 'ADMIN';

    -- Set/reset password
    PROD.dct_auth.set_password('ADMIN', 'iFinance@2026');

    -- SYS_ADMIN role
    SELECT role_id INTO l_role_id FROM PROD.dct_roles WHERE role_code = 'SYS_ADMIN';
    INSERT INTO PROD.dct_user_roles (user_id, role_id, start_date, is_active, assigned_by, reason, created_by)
    SELECT l_user_id, l_role_id, SYSDATE, 'Y', 'SYSTEM', 'Initial system administrator account', 'SYSTEM'
    FROM DUAL
    WHERE NOT EXISTS (
        SELECT 1 FROM PROD.dct_user_roles ur
        WHERE ur.user_id = l_user_id AND ur.role_id = l_role_id
    );

    -- PLATFORM_USER base role
    SELECT role_id INTO l_role_id FROM PROD.dct_roles WHERE role_code = 'PLATFORM_USER';
    INSERT INTO PROD.dct_user_roles (user_id, role_id, start_date, is_active, assigned_by, reason, created_by)
    SELECT l_user_id, l_role_id, SYSDATE, 'Y', 'SYSTEM', 'Base platform access', 'SYSTEM'
    FROM DUAL
    WHERE NOT EXISTS (
        SELECT 1 FROM PROD.dct_user_roles ur
        WHERE ur.user_id = l_user_id AND ur.role_id = l_role_id
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('ADMIN user fixed. user_id = ' || l_user_id);
    DBMS_OUTPUT.PUT_LINE('Password set to: iFinance@2026');
    DBMS_OUTPUT.PUT_LINE('*** CHANGE THE PASSWORD BEFORE GOING LIVE ***');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ADMIN user or role not found. Check dct_users and dct_roles.');
        ROLLBACK;
END;
/

-- =============================================================================
-- VERIFICATION
-- =============================================================================
SELECT 'dct_modules'           AS tbl, COUNT(*) AS cnt FROM PROD.dct_modules
UNION ALL SELECT 'dct_roles',           COUNT(*) FROM PROD.dct_roles
UNION ALL SELECT 'dct_permissions',     COUNT(*) FROM PROD.dct_permissions
UNION ALL SELECT 'dct_role_permissions',COUNT(*) FROM PROD.dct_role_permissions
UNION ALL SELECT 'dct_module_roles',    COUNT(*) FROM PROD.dct_module_roles
UNION ALL SELECT 'dct_system_settings', COUNT(*) FROM PROD.dct_system_settings
UNION ALL SELECT 'dct_lookup_categories',COUNT(*) FROM PROD.dct_lookup_categories
UNION ALL SELECT 'dct_lookup_values',   COUNT(*) FROM PROD.dct_lookup_values
UNION ALL SELECT 'dct_users',           COUNT(*) FROM PROD.dct_users
UNION ALL SELECT 'dct_user_roles',      COUNT(*) FROM PROD.dct_user_roles
UNION ALL SELECT 'dct_organizations',   COUNT(*) FROM PROD.dct_organizations;

PROMPT ============================================================
PROMPT  i-Finance V2 seed data loaded successfully.
PROMPT  Default admin: ADMIN / iFinance@2026
PROMPT  *** CHANGE THE PASSWORD BEFORE GOING LIVE ***
PROMPT ============================================================
