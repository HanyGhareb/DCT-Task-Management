/**
 * mockData.js — shared mock data mirroring DCT_* tables
 * Production: replace service calls with ORDS REST endpoints.
 */
define([], function () {
  'use strict';

  const USERS = [
    { userId: 1, username: 'ADMIN', displayName: 'System Administrator', displayNameAr: 'مدير النظام', email: 'admin@ifinance.gov', phone: '+971-4-100-0001', isActive: 'Y', isExternal: 'N', orgId: 1, orgName: 'Finance Division', employeeNumber: 'ADM001', roles: ['SYS_ADMIN'], color: '#C74634', createdAt: '2025-01-01', password: 'iFinance@2026' },
    { userId: 2, username: 'HASHEM.ALKABBI', displayName: 'Hashem Al Kabbi', displayNameAr: 'هاشم الكعبي', email: 'h.alkabbi@ifinance.gov', phone: '+971-4-100-0002', isActive: 'Y', isExternal: 'N', orgId: 1, orgName: 'Finance Division', employeeNumber: 'EMP001', roles: ['TASK_DIRECTOR', 'PLATFORM_USER'], color: '#0572CE', createdAt: '2025-01-01', password: 'Director@2026' },
    { userId: 3, username: 'NASER.ALKHAJA', displayName: 'Naser Mohamed Al Khaja', displayNameAr: 'ناصر محمد الخاجة', email: 'n.alkhaja@ifinance.gov', phone: '+971-4-100-0003', isActive: 'Y', isExternal: 'N', orgId: 2, orgName: 'Finance Operations', employeeNumber: 'EMP002', roles: ['MANAGER', 'PLATFORM_USER'], color: '#2E7D32', createdAt: '2025-01-01', password: 'Manager@2026' },
    { userId: 4, username: 'AYESHA.AMERI', displayName: 'Ayesha Abdul Kareem Ameri', displayNameAr: 'عائشة عبد الكريم العامري', email: 'a.ameri@ifinance.gov', phone: '+971-4-100-0004', isActive: 'Y', isExternal: 'N', orgId: 3, orgName: 'Payables Operations', employeeNumber: 'EMP003', roles: ['MANAGER', 'PLATFORM_USER'], color: '#8B0000', createdAt: '2025-01-01', password: 'Manager@2026' },
    { userId: 5, username: 'SHAIKHA.GALAMERI', displayName: 'Shaikha Ghanem Al Ameri', displayNameAr: 'شيخة غانم العامري', email: 's.galameri@ifinance.gov', phone: '+971-4-100-0005', isActive: 'Y', isExternal: 'N', orgId: 4, orgName: 'Financial Planning & Budgeting', employeeNumber: 'EMP004', roles: ['MANAGER', 'PLATFORM_USER'], color: '#6A1B9A', createdAt: '2025-01-01', password: 'Manager@2026' },
    { userId: 6, username: 'SHAIKHA.ALSUWAIDI', displayName: 'Shaikha Ahmed Al Suwaidi', displayNameAr: 'شيخة أحمد السويدي', email: 's.alsuwaidi@ifinance.gov', phone: '+971-4-100-0006', isActive: 'Y', isExternal: 'N', orgId: 5, orgName: 'Revenue Assurance', employeeNumber: 'EMP005', roles: ['MANAGER', 'PLATFORM_USER'], color: '#00695C', createdAt: '2025-01-01', password: 'Manager@2026' },
    { userId: 7, username: 'NOORA.ALALI', displayName: 'Noora Saeed Al Ali', displayNameAr: 'نورة سعيد العلي', email: 'n.alali@ifinance.gov', phone: '+971-4-100-0007', isActive: 'Y', isExternal: 'N', orgId: 6, orgName: 'Receivables Operations', employeeNumber: 'EMP006', roles: ['MANAGER', 'PLATFORM_USER'], color: '#E65100', createdAt: '2025-01-01', password: 'Manager@2026' },
  ];

  const ROLES = [
    { roleId: 1, roleCode: 'SYS_ADMIN',      roleName: 'System Administrator',      description: 'Full system access — all modules and settings',   isActive: 'Y', memberCount: 1 },
    { roleId: 2, roleCode: 'USER_ADMIN',      roleName: 'User Administrator',        description: 'Manage users, roles, and access assignments',      isActive: 'Y', memberCount: 0 },
    { roleId: 3, roleCode: 'ORG_ADMIN',       roleName: 'Organisation Administrator',description: 'Manage org hierarchy and department structure',     isActive: 'Y', memberCount: 0 },
    { roleId: 4, roleCode: 'MODULE_ADMIN',    roleName: 'Module Administrator',      description: 'Manage module registry and access permissions',    isActive: 'Y', memberCount: 0 },
    { roleId: 5, roleCode: 'AUDITOR',         roleName: 'Auditor',                  description: 'Read-only access to audit logs and session data',   isActive: 'Y', memberCount: 0 },
    { roleId: 6, roleCode: 'TASK_DIRECTOR',   roleName: 'Task Director',            description: 'Finance Director — full task dashboard overview',   isActive: 'Y', memberCount: 1 },
    { roleId: 7, roleCode: 'MANAGER',         roleName: 'Section Manager',          description: 'Section manager — manage own section tasks',        isActive: 'Y', memberCount: 5 },
    { roleId: 8, roleCode: 'PLATFORM_USER',   roleName: 'Platform User',            description: 'Base role — access to i-Finance hub and modules',   isActive: 'Y', memberCount: 6 },
    { roleId: 9, roleCode: 'EXTERNAL_USER',   roleName: 'External User',            description: 'External contractor with limited access',           isActive: 'N', memberCount: 0 },
  ];

  const PERMISSIONS = [
    { permId:  1, permCode: 'USERS.VIEW',         permName: 'View Users',           module: 'ADMIN' },
    { permId:  2, permCode: 'USERS.CREATE',        permName: 'Create Users',         module: 'ADMIN' },
    { permId:  3, permCode: 'USERS.EDIT',          permName: 'Edit Users',           module: 'ADMIN' },
    { permId:  4, permCode: 'USERS.DELETE',        permName: 'Delete Users',         module: 'ADMIN' },
    { permId:  5, permCode: 'ROLES.VIEW',          permName: 'View Roles',           module: 'ADMIN' },
    { permId:  6, permCode: 'ROLES.EDIT',          permName: 'Edit Roles',           module: 'ADMIN' },
    { permId:  7, permCode: 'PERMS.VIEW',          permName: 'View Permissions',     module: 'ADMIN' },
    { permId:  8, permCode: 'PERMS.EDIT',          permName: 'Edit Permissions',     module: 'ADMIN' },
    { permId:  9, permCode: 'ORG.VIEW',            permName: 'View Org Hierarchy',   module: 'ADMIN' },
    { permId: 10, permCode: 'ORG.EDIT',            permName: 'Edit Org Hierarchy',   module: 'ADMIN' },
    { permId: 11, permCode: 'MODULES.VIEW',        permName: 'View Modules',         module: 'ADMIN' },
    { permId: 12, permCode: 'MODULES.EDIT',        permName: 'Edit Modules',         module: 'ADMIN' },
    { permId: 13, permCode: 'APPROVALS.VIEW',      permName: 'View Approvals',       module: 'ADMIN' },
    { permId: 14, permCode: 'APPROVALS.EDIT',      permName: 'Edit Approvals',       module: 'ADMIN' },
    { permId: 15, permCode: 'LOOKUPS.VIEW',        permName: 'View Lookups',         module: 'ADMIN' },
    { permId: 16, permCode: 'LOOKUPS.EDIT',        permName: 'Edit Lookups',         module: 'ADMIN' },
    { permId: 17, permCode: 'SETTINGS.VIEW',       permName: 'View Settings',        module: 'ADMIN' },
    { permId: 18, permCode: 'SETTINGS.EDIT',       permName: 'Edit Settings',        module: 'ADMIN' },
    { permId: 19, permCode: 'AUDIT.VIEW',          permName: 'View Audit Log',       module: 'ADMIN' },
    { permId: 20, permCode: 'NOTIFY.SEND',         permName: 'Send Notifications',   module: 'ADMIN' },
    { permId: 21, permCode: 'DELEGATE.MANAGE',     permName: 'Manage Delegations',   module: 'ADMIN' },
    { permId: 22, permCode: 'SESSIONS.MANAGE',     permName: 'Manage Sessions',      module: 'ADMIN' },
  ];

  // SYS_ADMIN gets all permissions; USER_ADMIN gets user/role perms
  const ROLE_PERMISSIONS = {
    1: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22],
    2: [1,2,3,4,5,6,7,8],
    3: [9,10],
    4: [11,12],
    5: [19],
    6: [],
    7: [],
    8: [],
    9: [],
  };

  const MODULES = [
    { moduleId:  1, moduleCode: 'IFINANCE_HUB',  nameEn: 'i-Finance Hub',                   nameAr: 'مركز آي فاينانس',             category: 'CORE',     icon: 'oj-ux-ico-home',        color: '#C74634', bg: '#FFF3F0', apexAppId: 100, isNew: false, isActive: 'Y', displayOrder:  1 },
    { moduleId:  2, moduleCode: 'PETTY_CASH',     nameEn: 'Petty Cash',                      nameAr: 'المصروفات النثرية',           category: 'FINANCE',  icon: 'oj-ux-ico-currency',    color: '#2E7D32', bg: '#F0FFF0', apexAppId: 101, isNew: false, isActive: 'Y', displayOrder:  2 },
    { moduleId:  3, moduleCode: 'HR',             nameEn: 'Human Resources',                 nameAr: 'الموارد البشرية',             category: 'HR',       icon: 'oj-ux-ico-people',      color: '#0572CE', bg: '#EFF7FF', apexAppId: 102, isNew: false, isActive: 'Y', displayOrder:  3 },
    { moduleId:  4, moduleCode: 'CREDIT_CARDS',   nameEn: 'Credit Cards',                    nameAr: 'بطاقات الائتمان',            category: 'FINANCE',  icon: 'oj-ux-ico-credit-card', color: '#8B0000', bg: '#FFF0F0', apexAppId: 103, isNew: false, isActive: 'Y', displayOrder:  4 },
    { moduleId:  5, moduleCode: 'PREPAID_CARDS',  nameEn: 'Prepaid Cards',                   nameAr: 'البطاقات المدفوعة مسبقاً',   category: 'FINANCE',  icon: 'oj-ux-ico-credit-card', color: '#6A1B9A', bg: '#F9F0FF', apexAppId: 104, isNew: false, isActive: 'Y', displayOrder:  5 },
    { moduleId:  6, moduleCode: 'FUND_MGMT',      nameEn: 'Fund Management',                 nameAr: 'إدارة الصناديق',             category: 'FINANCE',  icon: 'oj-ux-ico-finance',     color: '#00695C', bg: '#F0FFFC', apexAppId: 105, isNew: false, isActive: 'Y', displayOrder:  6 },
    { moduleId:  7, moduleCode: 'ESS',            nameEn: 'Employee Self Service',           nameAr: 'الخدمة الذاتية للموظفين',    category: 'HR',       icon: 'oj-ux-ico-person',      color: '#E65100', bg: '#FFF8F0', apexAppId: 106, isNew: false, isActive: 'Y', displayOrder:  7 },
    { moduleId:  8, moduleCode: 'BUDGET_ALLOC',   nameEn: 'Budget Allocation',               nameAr: 'توزيع الميزانية',            category: 'BUDGET',   icon: 'oj-ux-ico-chart-bar',   color: '#1565C0', bg: '#EEF5FF', apexAppId: 110, isNew: false, isActive: 'Y', displayOrder:  8 },
    { moduleId:  9, moduleCode: 'PAY_REQUESTS',   nameEn: 'Payment Requests',                nameAr: 'طلبات الدفع',                category: 'PAYMENTS', icon: 'oj-ux-ico-check-circle',color: '#2E7D32', bg: '#F0FFF4', apexAppId: 113, isNew: false, isActive: 'Y', displayOrder:  9 },
    { moduleId: 10, moduleCode: 'BUDGET_PLAN',    nameEn: 'Budget Planning',                 nameAr: 'تخطيط الميزانية',            category: 'BUDGET',   icon: 'oj-ux-ico-chart-line',  color: '#1565C0', bg: '#EEF5FF', apexAppId: 115, isNew: false, isActive: 'Y', displayOrder: 10 },
    { moduleId: 11, moduleCode: 'TASK_MGMT',      nameEn: 'Task Management',                 nameAr: 'إدارة المهام',               category: 'CORE',     icon: 'oj-ux-ico-tasks',       color: '#C74634', bg: '#FFF3F0', apexAppId: 200, isNew: false, isActive: 'Y', displayOrder: 11 },
    { moduleId: 12, moduleCode: 'DUTY_TRAVEL',    nameEn: 'Duty Travel',                     nameAr: 'السفر الوظيفي',              category: 'HR',       icon: 'oj-ux-ico-plane',       color: '#0288D1', bg: '#EFF9FF', apexAppId: 204, isNew: true,  isActive: 'Y', displayOrder: 12 },
  ];

  const NOTIFICATIONS = [
    { notifId: 1, type: 'WARNING', titleEn: 'Scheduled Maintenance', bodyEn: 'System maintenance on Saturday 18 May at 02:00 AM GST. All apps will be unavailable for approx. 2 hours.', isRead: 'N', createdAt: '2026-05-15T08:00:00' },
    { notifId: 2, type: 'INFO',    titleEn: 'Duty Travel Module Live', bodyEn: 'Duty Travel module (App 204) is now available. Grade-based per diem rates have been configured.', isRead: 'N', createdAt: '2026-05-14T10:30:00' },
    { notifId: 3, type: 'APPROVAL',titleEn: 'Approval Required',      bodyEn: 'Credit Card limit change for Naser Al Khaja requires your approval.', isRead: 'N', createdAt: '2026-05-13T14:00:00' },
    { notifId: 4, type: 'INFO',    titleEn: 'Password Policy Updated', bodyEn: 'Minimum password length has been increased to 12 characters. Users will be prompted on next login.', isRead: 'Y', createdAt: '2026-05-10T09:00:00' },
  ];

  const SETTINGS = [
    { settingId:  1, settingKey: 'DEFAULT_AUTH_METHOD',     settingValue: 'DB',                    description: 'Authentication method: DB or OCI_IAM',        category: 'AUTH',     updatedBy: 'ADMIN', updatedAt: '2026-01-01' },
    { settingId:  2, settingKey: 'SESSION_TIMEOUT_MINUTES', settingValue: '480',                   description: 'Session timeout in minutes (480 = 8 hours)',  category: 'AUTH',     updatedBy: 'ADMIN', updatedAt: '2026-01-01' },
    { settingId:  3, settingKey: 'MAX_LOGIN_ATTEMPTS',      settingValue: '5',                     description: 'Failed attempts before lockout',              category: 'AUTH',     updatedBy: 'ADMIN', updatedAt: '2026-01-01' },
    { settingId:  4, settingKey: 'SUPPORT_EMAIL',           settingValue: 'support@ifinance.gov',  description: 'Help desk email shown in error pages',        category: 'GENERAL',  updatedBy: 'ADMIN', updatedAt: '2026-01-01' },
    { settingId:  5, settingKey: 'MAX_ATTACHMENT_MB',       settingValue: '10',                    description: 'Maximum file attachment size in megabytes',   category: 'GENERAL',  updatedBy: 'ADMIN', updatedAt: '2026-01-01' },
    { settingId:  6, settingKey: 'DEFAULT_LANGUAGE',        settingValue: 'en',                    description: 'Default UI language (en / ar)',               category: 'GENERAL',  updatedBy: 'ADMIN', updatedAt: '2026-01-01' },
    { settingId:  7, settingKey: 'ENABLE_NOTIFICATIONS',    settingValue: 'Y',                     description: 'Enable in-app notification system',           category: 'FEATURES', updatedBy: 'ADMIN', updatedAt: '2026-01-01' },
    { settingId:  8, settingKey: 'ENABLE_DELEGATION',       settingValue: 'Y',                     description: 'Allow users to delegate their role',          category: 'FEATURES', updatedBy: 'ADMIN', updatedAt: '2026-01-01' },
    { settingId:  9, settingKey: 'ENABLE_AUDIT_LOG',        settingValue: 'Y',                     description: 'Record all create/update/delete actions',     category: 'FEATURES', updatedBy: 'ADMIN', updatedAt: '2026-01-01' },
    { settingId: 10, settingKey: 'APP_VERSION',             settingValue: 'V2.0',                  description: 'Current application version label',           category: 'GENERAL',    updatedBy: 'ADMIN', updatedAt: '2026-01-01' },
    { settingId: 11, settingKey: 'APP_THEME',               settingValue: 'corporate',             description: 'Platform UI theme: corporate | redwood | midnight', category: 'APPEARANCE', updatedBy: 'ADMIN', updatedAt: '2026-01-01' },
  ];

  const LOOKUPS = [
    { lookupId:  1, lookupType: 'PRIORITY',        lookupCode: 'HIGH',        displayValue: 'High',        sortOrder: 1, isActive: 'Y' },
    { lookupId:  2, lookupType: 'PRIORITY',        lookupCode: 'MEDIUM',      displayValue: 'Medium',      sortOrder: 2, isActive: 'Y' },
    { lookupId:  3, lookupType: 'PRIORITY',        lookupCode: 'LOW',         displayValue: 'Low',         sortOrder: 3, isActive: 'Y' },
    { lookupId:  4, lookupType: 'TASK_STATUS',     lookupCode: 'NOT_STARTED', displayValue: 'Not Started', sortOrder: 1, isActive: 'Y' },
    { lookupId:  5, lookupType: 'TASK_STATUS',     lookupCode: 'IN_PROGRESS', displayValue: 'In Progress', sortOrder: 2, isActive: 'Y' },
    { lookupId:  6, lookupType: 'TASK_STATUS',     lookupCode: 'COMPLETED',   displayValue: 'Completed',   sortOrder: 3, isActive: 'Y' },
    { lookupId:  7, lookupType: 'TASK_STATUS',     lookupCode: 'DELAYED',     displayValue: 'Delayed',     sortOrder: 4, isActive: 'Y' },
    { lookupId:  8, lookupType: 'TASK_STATUS',     lookupCode: 'BLOCKED',     displayValue: 'Blocked',     sortOrder: 5, isActive: 'Y' },
    { lookupId:  9, lookupType: 'ORG_TYPE',        lookupCode: 'DIVISION',    displayValue: 'Division',    sortOrder: 1, isActive: 'Y' },
    { lookupId: 10, lookupType: 'ORG_TYPE',        lookupCode: 'SECTION',     displayValue: 'Section',     sortOrder: 2, isActive: 'Y' },
    { lookupId: 11, lookupType: 'APPROVAL_STATUS', lookupCode: 'PENDING',     displayValue: 'Pending',     sortOrder: 1, isActive: 'Y' },
    { lookupId: 12, lookupType: 'APPROVAL_STATUS', lookupCode: 'APPROVED',    displayValue: 'Approved',    sortOrder: 2, isActive: 'Y' },
    { lookupId: 13, lookupType: 'APPROVAL_STATUS', lookupCode: 'REJECTED',    displayValue: 'Rejected',    sortOrder: 3, isActive: 'Y' },
    { lookupId: 14, lookupType: 'APPROVAL_STATUS', lookupCode: 'CANCELLED',   displayValue: 'Cancelled',   sortOrder: 4, isActive: 'Y' },
  ];

  const ORGS = [
    { orgId: 1, orgCode: 'FIN-DIV',    nameEn: 'Finance Division',                 nameAr: 'الإدارة المالية',              parentOrgId: null, level: 1, orgType: 'DIVISION', isActive: 'Y' },
    { orgId: 2, orgCode: 'FIN-OPS',    nameEn: 'Finance Operations',              nameAr: 'العمليات المالية',              parentOrgId: 1,    level: 2, orgType: 'SECTION',  isActive: 'Y' },
    { orgId: 3, orgCode: 'PAY-OPS',    nameEn: 'Payables Operations',             nameAr: 'عمليات المستحقات',              parentOrgId: 1,    level: 2, orgType: 'SECTION',  isActive: 'Y' },
    { orgId: 4, orgCode: 'FIN-PLAN',   nameEn: 'Financial Planning & Budgeting',  nameAr: 'التخطيط المالي والميزانية',     parentOrgId: 1,    level: 2, orgType: 'SECTION',  isActive: 'Y' },
    { orgId: 5, orgCode: 'REV-ASSUR',  nameEn: 'Revenue Assurance',               nameAr: 'ضمان الإيرادات',               parentOrgId: 1,    level: 2, orgType: 'SECTION',  isActive: 'Y' },
    { orgId: 6, orgCode: 'REC-OPS',    nameEn: 'Receivables Operations',          nameAr: 'عمليات الذمم المدينة',          parentOrgId: 1,    level: 2, orgType: 'SECTION',  isActive: 'Y' },
  ];

  const APPROVAL_TEMPLATES = [
    { templateId: 1, templateCode: 'PC_CASH_REQUEST',  templateName: 'Petty Cash Request',       module: 'PETTY_CASH',    isActive: 'Y', stepCount: 2,
      steps: [{ seq: 1, label: 'Section Manager Review', roleCode: 'MANAGER', slaHours: 24 }, { seq: 2, label: 'Finance Director Approval', roleCode: 'TASK_DIRECTOR', slaHours: 48 }] },
    { templateId: 2, templateCode: 'CC_LIMIT_CHANGE',  templateName: 'Credit Card Limit Change', module: 'CREDIT_CARDS',  isActive: 'Y', stepCount: 3,
      steps: [{ seq: 1, label: 'Manager Review', roleCode: 'MANAGER', slaHours: 24 }, { seq: 2, label: 'Finance Review', roleCode: 'USER_ADMIN', slaHours: 24 }, { seq: 3, label: 'Director Approval', roleCode: 'TASK_DIRECTOR', slaHours: 48 }] },
    { templateId: 3, templateCode: 'DT_TRAVEL_REQ',    templateName: 'Duty Travel Request',      module: 'DUTY_TRAVEL',   isActive: 'Y', stepCount: 2,
      steps: [{ seq: 1, label: 'Manager Approval', roleCode: 'MANAGER', slaHours: 24 }, { seq: 2, label: 'Director Approval', roleCode: 'TASK_DIRECTOR', slaHours: 48 }] },
    { templateId: 4, templateCode: 'BUDGET_TRANSFER',  templateName: 'Budget Transfer',          module: 'BUDGET',        isActive: 'Y', stepCount: 3,
      steps: [{ seq: 1, label: 'Section Review', roleCode: 'MANAGER', slaHours: 48 }, { seq: 2, label: 'Finance Review', roleCode: 'USER_ADMIN', slaHours: 24 }, { seq: 3, label: 'Director Sign-off', roleCode: 'TASK_DIRECTOR', slaHours: 72 }] },
  ];

  const APPROVAL_INSTANCES = [
    { instanceId: 1, templateName: 'Petty Cash Request',       requestedBy: 'Naser Al Khaja',          requestedAt: '2026-05-14', currentStep: 1, totalSteps: 2, overallStatus: 'PENDING',  amount: 'AED 1,250', daysOld: 2 },
    { instanceId: 2, templateName: 'Credit Card Limit Change', requestedBy: 'Ayesha Ameri',            requestedAt: '2026-05-13', currentStep: 2, totalSteps: 3, overallStatus: 'PENDING',  amount: 'AED 50,000', daysOld: 3 },
    { instanceId: 3, templateName: 'Duty Travel Request',      requestedBy: 'Noora Saeed Al Ali',      requestedAt: '2026-05-10', currentStep: 2, totalSteps: 2, overallStatus: 'APPROVED', amount: 'AED 3,400', daysOld: 6 },
    { instanceId: 4, templateName: 'Budget Transfer',          requestedBy: 'Shaikha Ghanem Al Ameri', requestedAt: '2026-05-08', currentStep: 0, totalSteps: 3, overallStatus: 'REJECTED', amount: 'AED 120,000', daysOld: 8 },
    { instanceId: 5, templateName: 'Petty Cash Request',       requestedBy: 'Shaikha Al Suwaidi',      requestedAt: '2026-05-16', currentStep: 1, totalSteps: 2, overallStatus: 'PENDING',  amount: 'AED 850', daysOld: 0 },
  ];

  const AUDIT_LOG = [
    { auditId: 1, actionType: 'LOGIN',  objectType: 'SESSION', objectId: null, actionBy: 'ADMIN',            actionAt: '2026-05-16T08:00:00', ipAddress: '10.0.0.1',   oldValues: null,                     newValues: '{"session":"started"}' },
    { auditId: 2, actionType: 'UPDATE', objectType: 'USER',    objectId: 3,    actionBy: 'ADMIN',            actionAt: '2026-05-15T14:30:00', ipAddress: '10.0.0.1',   oldValues: '{"isActive":"Y"}',       newValues: '{"isActive":"N"}' },
    { auditId: 3, actionType: 'CREATE', objectType: 'USER',    objectId: 7,    actionBy: 'ADMIN',            actionAt: '2026-05-14T09:00:00', ipAddress: '10.0.0.1',   oldValues: null,                     newValues: '{"username":"NOORA.ALALI"}' },
    { auditId: 4, actionType: 'LOGIN',  objectType: 'SESSION', objectId: null, actionBy: 'HASHEM.ALKABBI',   actionAt: '2026-05-16T09:15:00', ipAddress: '10.0.0.5',   oldValues: null,                     newValues: '{"session":"started"}' },
    { auditId: 5, actionType: 'UPDATE', objectType: 'SETTING', objectId: 2,    actionBy: 'ADMIN',            actionAt: '2026-05-12T11:00:00', ipAddress: '10.0.0.1',   oldValues: '{"value":"240"}',        newValues: '{"value":"480"}' },
    { auditId: 6, actionType: 'DELETE', objectType: 'USER',    objectId: 8,    actionBy: 'ADMIN',            actionAt: '2026-05-11T16:45:00', ipAddress: '10.0.0.1',   oldValues: '{"username":"TEST_USER"}',newValues: null },
  ];

  const LOGIN_HISTORY = [
    { histId: 1, username: 'ADMIN',            loginAt: '2026-05-16T08:00:00', logoutAt: null,               ipAddress: '10.0.0.1',    success: 'Y', failReason: null },
    { histId: 2, username: 'HASHEM.ALKABBI',   loginAt: '2026-05-16T09:15:00', logoutAt: null,               ipAddress: '10.0.0.5',    success: 'Y', failReason: null },
    { histId: 3, username: 'NASER.ALKHAJA',    loginAt: '2026-05-15T08:30:00', logoutAt: '2026-05-15T17:00:00', ipAddress: '10.0.0.10', success: 'Y', failReason: null },
    { histId: 4, username: 'NOORA.ALALI',      loginAt: '2026-05-15T09:00:00', logoutAt: '2026-05-15T17:30:00', ipAddress: '10.0.0.20', success: 'Y', failReason: null },
    { histId: 5, username: 'UNKNOWN_USER',     loginAt: '2026-05-14T23:00:00', logoutAt: null,               ipAddress: '192.168.1.100', success: 'N', failReason: 'Invalid credentials' },
    { histId: 6, username: 'UNKNOWN_USER',     loginAt: '2026-05-14T23:01:00', logoutAt: null,               ipAddress: '192.168.1.100', success: 'N', failReason: 'Invalid credentials' },
  ];

  const ACTIVE_SESSIONS = [
    { sessionId: 'S001', username: 'ADMIN',          startedAt: '2026-05-16T08:00:00', lastActivity: '2026-05-16T10:30:00', ipAddress: '10.0.0.1',  browser: 'Chrome 124', status: 'ACTIVE' },
    { sessionId: 'S002', username: 'HASHEM.ALKABBI', startedAt: '2026-05-16T09:15:00', lastActivity: '2026-05-16T10:29:00', ipAddress: '10.0.0.5',  browser: 'Firefox 125', status: 'ACTIVE' },
    { sessionId: 'S003', username: 'NASER.ALKHAJA',  startedAt: '2026-05-16T08:45:00', lastActivity: '2026-05-16T09:00:00', ipAddress: '10.0.0.10', browser: 'Safari 17',  status: 'IDLE' },
  ];

  const DELEGATIONS = [
    { delegId: 1, fromUserId: 2, fromName: 'Hashem Al Kabbi', toUserId: 3, toName: 'Naser Al Khaja', startDate: '2026-05-20', endDate: '2026-05-25', reason: 'Annual leave', isActive: 'N' },
  ];

  return { USERS, ROLES, PERMISSIONS, ROLE_PERMISSIONS, MODULES, NOTIFICATIONS, SETTINGS, LOOKUPS, ORGS, APPROVAL_TEMPLATES, APPROVAL_INSTANCES, AUDIT_LOG, LOGIN_HISTORY, ACTIVE_SESSIONS, DELEGATIONS };
});
