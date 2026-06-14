-- =============================================================================
-- Task Management Module (App 207) -- Seed Data
-- File    : 03_tm_seed.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @03_tm_seed.sql   (after 01_tm_ddl.sql)
-- Safe    : Idempotent (upsert pattern); admin-changed setting_value preserved.
-- Seeds   : lookup sets, module registration, system roles TM_ADMIN/TM_USER +
--           permissions, module settings, team-role templates + default CRUD matrix.
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- 1. LOOKUP CATEGORIES + VALUES  (lookup-first vocabularies)
-- =============================================================================
DECLARE
    v_cat NUMBER;

    PROCEDURE upsert_category (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, o_id OUT NUMBER) IS
    BEGIN
        MERGE INTO prod.dct_lookup_categories t
        USING (SELECT p_code AS category_code FROM dual) s
        ON (t.category_code = s.category_code)
        WHEN NOT MATCHED THEN
            INSERT (category_code, category_name_en, category_name_ar, module_id, is_system, is_active)
            VALUES (p_code, p_en, p_ar, NULL, 'Y', 'Y')
        WHEN MATCHED THEN
            UPDATE SET category_name_en = p_en, category_name_ar = p_ar;
        SELECT category_id INTO o_id FROM prod.dct_lookup_categories WHERE category_code = p_code;
    END;

    PROCEDURE upsert_value (p_cat NUMBER, p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, p_ord NUMBER, p_default VARCHAR2 DEFAULT 'N') IS
    BEGIN
        MERGE INTO prod.dct_lookup_values t
        USING (SELECT p_cat AS category_id, p_code AS value_code FROM dual) s
        ON (t.category_id = s.category_id AND t.value_code = s.value_code)
        WHEN NOT MATCHED THEN
            INSERT (category_id, value_code, value_name_en, value_name_ar, display_order, is_default, is_active)
            VALUES (p_cat, p_code, p_en, p_ar, p_ord, p_default, 'Y')
        WHEN MATCHED THEN
            UPDATE SET value_name_en = p_en, value_name_ar = p_ar, display_order = p_ord;
    END;
BEGIN
    -- Team type
    upsert_category('TM_TEAM_TYPE', 'TM Team Type', 'نوع الفريق', v_cat);
    upsert_value(v_cat, 'INTERNAL', 'Internal', 'داخلي', 10, 'Y');
    upsert_value(v_cat, 'EXTERNAL', 'External', 'خارجي', 20);

    -- Team class
    upsert_category('TM_TEAM_CLASS', 'TM Team Class', 'تصنيف الفريق', v_cat);
    upsert_value(v_cat, 'STRATEGIC',   'Strategic',   'استراتيجي', 10);
    upsert_value(v_cat, 'OPERATIONAL', 'Operational', 'تشغيلي',    20, 'Y');
    upsert_value(v_cat, 'MANAGEMENT',  'Management',  'إداري',     30);

    -- Team category (open / admin-managed; seed a few starters)
    upsert_category('TM_TEAM_CATEGORY', 'TM Team Category', 'فئة الفريق', v_cat);
    upsert_value(v_cat, 'PROJECT',    'Project Team',    'فريق مشروع',  10);
    upsert_value(v_cat, 'PROCESS',    'Process Team',    'فريق عملية',  20);
    upsert_value(v_cat, 'COMMITTEE',  'Committee',       'لجنة',        30);
    upsert_value(v_cat, 'TASKFORCE',  'Task Force',      'فريق مهام',   40);
    upsert_value(v_cat, 'STANDING',   'Standing Team',   'فريق دائم',   50);

    -- Team status
    upsert_category('TM_TEAM_STATUS', 'TM Team Status', 'حالة الفريق', v_cat);
    upsert_value(v_cat, 'ACTIVE',    'Active',    'نشط',   10, 'Y');
    upsert_value(v_cat, 'ON_HOLD',   'On Hold',   'معلق',  20);
    upsert_value(v_cat, 'COMPLETED', 'Completed', 'مكتمل', 30);
    upsert_value(v_cat, 'ARCHIVED',  'Archived',  'مؤرشف', 40);

    -- Task status
    upsert_category('TM_TASK_STATUS', 'TM Task Status', 'حالة المهمة', v_cat);
    upsert_value(v_cat, 'TODO',        'To Do',       'للتنفيذ',     10, 'Y');
    upsert_value(v_cat, 'IN_PROGRESS', 'In Progress', 'قيد التنفيذ', 20);
    upsert_value(v_cat, 'BLOCKED',     'Blocked',     'معطل',        30);
    upsert_value(v_cat, 'REVIEW',      'In Review',   'قيد المراجعة', 40);
    upsert_value(v_cat, 'DONE',        'Done',        'منجز',        50);
    upsert_value(v_cat, 'CANCELLED',   'Cancelled',   'ملغى',        60);

    -- Task priority
    upsert_category('TM_TASK_PRIORITY', 'TM Task Priority', 'أولوية المهمة', v_cat);
    upsert_value(v_cat, 'LOW',      'Low',      'منخفضة', 10);
    upsert_value(v_cat, 'MEDIUM',   'Medium',   'متوسطة', 20, 'Y');
    upsert_value(v_cat, 'HIGH',     'High',     'عالية',  30);
    upsert_value(v_cat, 'CRITICAL', 'Critical', 'حرجة',   40);

    -- Objective / milestone status
    upsert_category('TM_OBJECTIVE_STATUS', 'TM Objective Status', 'حالة الهدف', v_cat);
    upsert_value(v_cat, 'NOT_STARTED', 'Not Started', 'لم يبدأ',    10, 'Y');
    upsert_value(v_cat, 'IN_PROGRESS', 'In Progress', 'قيد التنفيذ', 20);
    upsert_value(v_cat, 'AT_RISK',     'At Risk',     'في خطر',     30);
    upsert_value(v_cat, 'ACHIEVED',    'Achieved',    'تحقق',       40);
    upsert_value(v_cat, 'PENDING',     'Pending',     'معلق',       50);
    upsert_value(v_cat, 'MISSED',      'Missed',      'فائت',       60);

    -- Deliverable type
    upsert_category('TM_DELIVERABLE_TYPE', 'TM Deliverable Type', 'نوع المخرج', v_cat);
    upsert_value(v_cat, 'DOCUMENT',     'Document',      'وثيقة',  10);
    upsert_value(v_cat, 'REPORT',       'Report',        'تقرير',  20);
    upsert_value(v_cat, 'SYSTEM',       'System / Tool', 'نظام',   30);
    upsert_value(v_cat, 'SERVICE',      'Service',       'خدمة',   40);
    upsert_value(v_cat, 'PRESENTATION', 'Presentation',  'عرض',    50);
    upsert_value(v_cat, 'OTHER',        'Other',         'أخرى',   90);

    -- Deliverable status
    upsert_category('TM_DELIVERABLE_STATUS', 'TM Deliverable Status', 'حالة المخرج', v_cat);
    upsert_value(v_cat, 'NOT_STARTED', 'Not Started', 'لم يبدأ',     10, 'Y');
    upsert_value(v_cat, 'IN_PROGRESS', 'In Progress', 'قيد التنفيذ',  20);
    upsert_value(v_cat, 'SUBMITTED',   'Submitted',   'مقدم',        30);
    upsert_value(v_cat, 'ACCEPTED',    'Accepted',    'مقبول',       40);
    upsert_value(v_cat, 'REJECTED',    'Rejected',    'مرفوض',       50);

    -- RAID item type
    upsert_category('TM_LOG_ITEM_TYPE', 'TM Log Item Type', 'نوع السجل', v_cat);
    upsert_value(v_cat, 'ISSUE',       'Issue',       'مشكلة',    10);
    upsert_value(v_cat, 'CHALLENGE',   'Challenge',   'تحدٍ',     20);
    upsert_value(v_cat, 'RISK',        'Risk',        'مخاطرة',   30);
    upsert_value(v_cat, 'ACHIEVEMENT', 'Achievement', 'إنجاز',    40);
    upsert_value(v_cat, 'DECISION',    'Decision',    'قرار',     50);
    upsert_value(v_cat, 'DEPENDENCY',  'Dependency',  'اعتمادية', 60);
    upsert_value(v_cat, 'LESSON',      'Lesson Learned', 'درس مستفاد', 70);

    -- RAID severity (also used for likelihood/impact)
    upsert_category('TM_LOG_SEVERITY', 'TM Log Severity', 'شدة السجل', v_cat);
    upsert_value(v_cat, 'LOW',      'Low',      'منخفضة', 10);
    upsert_value(v_cat, 'MEDIUM',   'Medium',   'متوسطة', 20, 'Y');
    upsert_value(v_cat, 'HIGH',     'High',     'عالية',  30);
    upsert_value(v_cat, 'CRITICAL', 'Critical', 'حرجة',   40);

    -- RAID / meeting status
    upsert_category('TM_LOG_STATUS', 'TM Log Status', 'حالة السجل', v_cat);
    upsert_value(v_cat, 'OPEN',        'Open',        'مفتوح',     10, 'Y');
    upsert_value(v_cat, 'IN_PROGRESS', 'In Progress', 'قيد المعالجة', 20);
    upsert_value(v_cat, 'MITIGATED',   'Mitigated',   'تم تخفيفه', 30);
    upsert_value(v_cat, 'CLOSED',      'Closed',      'مغلق',      40);
    upsert_value(v_cat, 'PLANNED',     'Planned',     'مخطط',      50);
    upsert_value(v_cat, 'HELD',        'Held',        'منعقد',     60);
    upsert_value(v_cat, 'CANCELLED',   'Cancelled',   'ملغى',      70);

    -- Artifact types (for the permission matrix)
    upsert_category('TM_ARTIFACT_TYPE', 'TM Artifact Type', 'نوع العنصر', v_cat);
    upsert_value(v_cat, 'TEAM',        'Team Definition', 'تعريف الفريق', 10);
    upsert_value(v_cat, 'MEMBER',      'Members',         'الأعضاء',      20);
    upsert_value(v_cat, 'ROLE',        'Team Roles',      'أدوار الفريق', 30);
    upsert_value(v_cat, 'OBJECTIVE',   'Objectives',      'الأهداف',      40);
    upsert_value(v_cat, 'TASK',        'Tasks',           'المهام',       50);
    upsert_value(v_cat, 'DELIVERABLE', 'Deliverables',    'المخرجات',     60);
    upsert_value(v_cat, 'MILESTONE',   'Milestones',      'المعالم',      70);
    upsert_value(v_cat, 'LOG_ITEM',    'RAID Log',        'سجل المخاطر',  80);
    upsert_value(v_cat, 'MEETING',     'Meetings',        'الاجتماعات',   90);
    upsert_value(v_cat, 'DOCUMENT',    'Documents',       'المستندات',    100);

    -- RAG health
    upsert_category('TM_RAG', 'TM RAG Health', 'مؤشر الحالة', v_cat);
    upsert_value(v_cat, 'GREEN', 'On Track',     'على المسار', 10);
    upsert_value(v_cat, 'AMBER', 'Needs Attention', 'يحتاج انتباه', 20);
    upsert_value(v_cat, 'RED',   'Off Track',    'خارج المسار', 30);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Lookup sets seeded: 14 TM_* categories');
END;
/

-- =============================================================================
-- 2. MODULE REGISTRATION -- DCT_MODULES
-- =============================================================================
MERGE INTO prod.dct_modules tgt
USING (
    SELECT 'TASK_MGMT'        AS module_code,
           'Task Management'  AS module_name_en,
           'إدارة المهام'      AS module_name_ar,
           'APEX_APP'         AS module_type,
           207                AS apex_app_id,
           1                  AS apex_page_id,
           'fa-list-check'    AS icon_class,
           '#0E8A8A'          AS icon_color,
           '#E6F4F4'          AS bg_color,
           'Manage teams and their objectives, tasks, deliverables, RAID log, documents, dashboards and reminders.' AS description_en,
           'إدارة الفرق وأهدافها ومهامها ومخرجاتها وسجل المخاطر والمستندات واللوحات والتذكيرات.' AS description_ar,
           'OPERATIONS'       AS category,
           70                 AS display_order,
           'Y'                AS is_active,
           'N'                AS is_new_tab,
           'N'                AS is_admin_only
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
               module_name_ar = src.module_name_ar,
               apex_app_id    = src.apex_app_id,
               icon_class     = src.icon_class,
               icon_color     = src.icon_color,
               category       = src.category,
               is_active      = src.is_active;
COMMIT;
PROMPT Module registered: TASK_MGMT (App 207)

-- =============================================================================
-- 3. SYSTEM ROLES (DCT_ROLES) -- TM_ADMIN, TM_USER  + permissions
-- =============================================================================
DECLARE
    v_module_id  prod.dct_modules.module_id%TYPE;
    v_admin_role prod.dct_roles.role_id%TYPE;
    v_user_role  prod.dct_roles.role_id%TYPE;
    v_perm_id    prod.dct_permissions.permission_id%TYPE;

    PROCEDURE upsert_role (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, p_desc VARCHAR2, p_ord NUMBER, o_id OUT NUMBER) IS
    BEGIN
        MERGE INTO prod.dct_roles t
        USING (SELECT p_code AS role_code FROM dual) s
        ON (t.role_code = s.role_code)
        WHEN NOT MATCHED THEN
            INSERT (role_code, role_name_en, role_name_ar, role_type, module_id,
                    description_en, is_active, is_system_role, display_order)
            VALUES (p_code, p_en, p_ar, 'MODULE', v_module_id, p_desc, 'Y', 'N', p_ord)
        WHEN MATCHED THEN
            UPDATE SET role_name_en = p_en, role_name_ar = p_ar, is_active = 'Y';
        SELECT role_id INTO o_id FROM prod.dct_roles WHERE role_code = p_code;
    END;

    PROCEDURE grant_perm (p_role_id NUMBER, p_code VARCHAR2, p_name VARCHAR2, p_action VARCHAR2) IS
        l_perm_id NUMBER;
    BEGIN
        MERGE INTO prod.dct_permissions p
        USING (SELECT p_code AS permission_code FROM dual) s
        ON (p.permission_code = s.permission_code)
        WHEN NOT MATCHED THEN
            INSERT (permission_code, permission_name, module_id, action_type, is_active)
            VALUES (p_code, p_name, v_module_id, p_action, 'Y')
        WHEN MATCHED THEN
            UPDATE SET permission_name = p_name, action_type = p_action;
        SELECT permission_id INTO l_perm_id FROM prod.dct_permissions WHERE permission_code = p_code;
        MERGE INTO prod.dct_role_permissions rp
        USING (SELECT p_role_id AS role_id, l_perm_id AS permission_id FROM dual) s
        ON (rp.role_id = s.role_id AND rp.permission_id = s.permission_id)
        WHEN NOT MATCHED THEN INSERT (role_id, permission_id, granted_by) VALUES (p_role_id, l_perm_id, 'SEED');
    END;
BEGIN
    SELECT module_id INTO v_module_id FROM prod.dct_modules WHERE module_code = 'TASK_MGMT';

    upsert_role('TM_ADMIN', 'Task Management Admin', 'مدير إدارة المهام',
                'Full platform-wide access: configure teams, team roles, settings, and view all dashboards.', 10, v_admin_role);
    upsert_role('TM_USER',  'Task Management User',  'مستخدم إدارة المهام',
                'Access the Task Management module; capabilities within a team are governed by the team role.', 20, v_user_role);

    -- Admin permissions
    grant_perm(v_admin_role, 'TM.VIEW_ALL',        'View all teams and dashboards',      'VIEW');
    grant_perm(v_admin_role, 'TM.MANAGE_TEAMS',    'Create and manage all teams',        'CONFIGURE');
    grant_perm(v_admin_role, 'TM.MANAGE_ROLES',    'Manage team-role templates + perms', 'CONFIGURE');
    grant_perm(v_admin_role, 'TM.MODULE_SETTINGS', 'Configure module settings',          'CONFIGURE');
    grant_perm(v_admin_role, 'TM.REPORTS',         'Run all management reports',         'VIEW');

    -- User permissions
    grant_perm(v_user_role,  'TM.ACCESS',          'Access the Task Management module',  'VIEW');
    grant_perm(v_user_role,  'TM.MY_WORK',         'View own assigned tasks',            'VIEW');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('System roles seeded: TM_ADMIN, TM_USER (+7 permissions)');
END;
/

-- =============================================================================
-- 4. MODULE SETTINGS (DCT_MODULE_SETTINGS)
-- =============================================================================
DECLARE
    v_module_id prod.dct_modules.module_id%TYPE;

    PROCEDURE put_setting (p_key VARCHAR2, p_val VARCHAR2, p_label VARCHAR2, p_desc VARCHAR2, p_type VARCHAR2, p_allow VARCHAR2, p_def VARCHAR2) IS
    BEGIN
        MERGE INTO prod.dct_module_settings s
        USING (SELECT v_module_id AS module_id, p_key AS setting_key FROM dual) src
        ON (s.module_id = src.module_id AND s.setting_key = src.setting_key)
        WHEN NOT MATCHED THEN
            INSERT (module_id, setting_key, setting_value, setting_label, setting_description,
                    value_type, allowed_values, default_value, effective_date)
            VALUES (v_module_id, p_key, p_val, p_label, p_desc, p_type, p_allow, p_def, SYSDATE)
        WHEN MATCHED THEN
            UPDATE SET setting_label = p_label, setting_description = p_desc,
                       value_type = p_type, allowed_values = p_allow, default_value = p_def;
            -- setting_value intentionally NOT updated on re-seed (preserve admin changes)
    END;
BEGIN
    SELECT module_id INTO v_module_id FROM prod.dct_modules WHERE module_code = 'TASK_MGMT';

    put_setting('DEFAULT_REMINDER_LEAD_DAYS', '2', 'Default Reminder Lead Days',
        'Days before a task due date to remind assignees who have not set a personal preference.', 'NUMBER', NULL, '2');
    put_setting('OVERDUE_ESCALATION_DAYS', '3', 'Overdue Escalation Days',
        'Days a task may stay overdue before the team supervisor/leader is notified.', 'NUMBER', NULL, '3');
    put_setting('ALLOW_SELF_TASK_CREATE', 'Y', 'Allow Members to Create Tasks',
        'Y = members may create their own tasks (subject to team-role permissions).', 'BOOLEAN', 'Y|N', 'Y');
    put_setting('AI_FEATURES_ENABLED', 'N', 'Enable AI Assist',
        'Y = AI weekly status summaries, risk detection and minutes drafting are available.', 'BOOLEAN', 'Y|N', 'N');
    put_setting('DIGEST_DEFAULT_HOUR', '7', 'Daily Digest Hour',
        'Local hour (0-23) the daily "My Day" digest is sent for users who opt in.', 'NUMBER', NULL, '7');
    put_setting('RAG_AMBER_OVERDUE_PCT', '10', 'RAG Amber Threshold (% overdue)',
        'Team health turns AMBER when this percentage of tasks is overdue.', 'NUMBER', NULL, '10');
    put_setting('RAG_RED_OVERDUE_PCT', '25', 'RAG Red Threshold (% overdue)',
        'Team health turns RED when this percentage of tasks is overdue.', 'NUMBER', NULL, '25');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Module settings seeded: 7 TASK_MGMT settings');
END;
/

-- =============================================================================
-- 5. TEAM-ROLE TEMPLATES (DCT_TM_ROLES) + default CRUD matrix (DCT_TM_ROLE_PERMS)
--    team_id NULL = global template default; per-team overrides added at runtime.
-- =============================================================================
DECLARE
    TYPE t_codes IS TABLE OF VARCHAR2(30);
    v_artifacts t_codes := t_codes('TEAM','MEMBER','ROLE','OBJECTIVE','TASK',
                                   'DELIVERABLE','MILESTONE','LOG_ITEM','MEETING','DOCUMENT');

    PROCEDURE upsert_role (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, p_desc VARCHAR2, p_leader VARCHAR2, p_ord NUMBER) IS
    BEGIN
        MERGE INTO prod.dct_tm_roles t
        USING (SELECT p_code AS role_code FROM dual) s
        ON (t.role_code = s.role_code)
        WHEN NOT MATCHED THEN
            INSERT (role_code, role_name_en, role_name_ar, description_en, is_system, is_leader_role, display_order, created_by)
            VALUES (p_code, p_en, p_ar, p_desc, 'Y', p_leader, p_ord, 'SEED')
        WHEN MATCHED THEN
            UPDATE SET role_name_en = p_en, role_name_ar = p_ar, description_en = p_desc, is_leader_role = p_leader;
    END;

    -- Set a template default permission row for (role, artifact)
    PROCEDURE set_perm (p_role VARCHAR2, p_art VARCHAR2, c VARCHAR2, r VARCHAR2, u VARCHAR2, d VARCHAR2) IS
        v_role_id NUMBER;
    BEGIN
        SELECT tm_role_id INTO v_role_id FROM prod.dct_tm_roles WHERE role_code = p_role;
        MERGE INTO prod.dct_tm_role_perms t
        USING (SELECT v_role_id AS rid, p_art AS art FROM dual) s
        ON (t.tm_role_id = s.rid AND NVL(t.team_id,-1) = -1 AND t.artifact_type = s.art)
        WHEN NOT MATCHED THEN
            INSERT (tm_role_id, team_id, artifact_type, can_create, can_read, can_update, can_delete, created_by)
            VALUES (v_role_id, NULL, p_art, c, r, u, d, 'SEED')
        WHEN MATCHED THEN
            UPDATE SET can_create = c, can_read = r, can_update = u, can_delete = d;
    END;

    -- Grant the same CRUD across ALL artifacts (used for LEADER)
    PROCEDURE set_all (p_role VARCHAR2, c VARCHAR2, r VARCHAR2, u VARCHAR2, d VARCHAR2) IS
    BEGIN
        FOR i IN 1 .. v_artifacts.COUNT LOOP
            set_perm(p_role, v_artifacts(i), c, r, u, d);
        END LOOP;
    END;
BEGIN
    upsert_role('LEADER',     'Team Leader',          'قائد الفريق',     'Full control of the team and all artifacts, including members and roles.', 'Y', 10);
    upsert_role('SUPERVISOR', 'Team Supervisor',      'مشرف الفريق',     'Manage work artifacts (objectives, tasks, deliverables, RAID, meetings); cannot administer members/roles.', 'N', 20);
    upsert_role('COORDINATOR','Coordinator / Secretary','منسق الفريق',   'Manage documents, meetings/minutes and RAID; update tasks and deliverables.', 'N', 30);
    upsert_role('MEMBER',     'Member',               'عضو',             'Create and update own tasks and updates; raise issues/risks; read team artifacts.', 'N', 40);
    upsert_role('QUALITY',    'Quality / Risk Owner', 'مسؤول الجودة والمخاطر', 'Own the RAID register; read all artifacts; contribute documents.', 'N', 50);
    upsert_role('OBSERVER',   'Sponsor / Observer',   'راعٍ / مراقب',     'Read-only executive view of the team and its dashboards.', 'N', 60);

    -- LEADER: full CRUD everywhere
    set_all('LEADER', 'Y','Y','Y','Y');

    -- SUPERVISOR: read all; CRUD work artifacts; update team def; no member/role admin
    set_all('SUPERVISOR', 'N','Y','N','N');
    set_perm('SUPERVISOR','TEAM',        'N','Y','Y','N');
    set_perm('SUPERVISOR','OBJECTIVE',   'Y','Y','Y','Y');
    set_perm('SUPERVISOR','TASK',        'Y','Y','Y','Y');
    set_perm('SUPERVISOR','DELIVERABLE', 'Y','Y','Y','Y');
    set_perm('SUPERVISOR','MILESTONE',   'Y','Y','Y','Y');
    set_perm('SUPERVISOR','LOG_ITEM',    'Y','Y','Y','Y');
    set_perm('SUPERVISOR','MEETING',     'Y','Y','Y','Y');
    set_perm('SUPERVISOR','DOCUMENT',    'Y','Y','Y','Y');

    -- COORDINATOR: read all; manage docs/meetings/RAID; update tasks/deliverables
    set_all('COORDINATOR', 'N','Y','N','N');
    set_perm('COORDINATOR','DOCUMENT',   'Y','Y','Y','Y');
    set_perm('COORDINATOR','MEETING',    'Y','Y','Y','Y');
    set_perm('COORDINATOR','LOG_ITEM',   'Y','Y','Y','N');
    set_perm('COORDINATOR','TASK',       'N','Y','Y','N');
    set_perm('COORDINATOR','DELIVERABLE','N','Y','Y','N');
    set_perm('COORDINATOR','MILESTONE',  'N','Y','Y','N');

    -- MEMBER: read all; create tasks/log items/documents; update tasks/deliverables
    set_all('MEMBER', 'N','Y','N','N');
    set_perm('MEMBER','TASK',        'Y','Y','Y','N');
    set_perm('MEMBER','DELIVERABLE', 'N','Y','Y','N');
    set_perm('MEMBER','LOG_ITEM',    'Y','Y','Y','N');
    set_perm('MEMBER','DOCUMENT',    'Y','Y','N','N');

    -- QUALITY: read all; own RAID; contribute documents
    set_all('QUALITY', 'N','Y','N','N');
    set_perm('QUALITY','LOG_ITEM', 'Y','Y','Y','Y');
    set_perm('QUALITY','DOCUMENT', 'Y','Y','Y','N');

    -- OBSERVER: read-only everywhere (already default from set defaults below)
    set_all('OBSERVER', 'N','Y','N','N');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Team-role templates seeded: 6 roles with default CRUD matrix');
END;
/

PROMPT
PROMPT === 03_tm_seed.sql complete ===
PROMPT Lookups (14 sets), module TASK_MGMT, system roles TM_ADMIN/TM_USER,
PROMPT module settings (7), team-role templates (6) + default permission matrix.
