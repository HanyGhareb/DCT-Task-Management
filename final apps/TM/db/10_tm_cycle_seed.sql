-- =============================================================================
-- Task Management Module (App 207) -- Reporting-Cycle / Visibility Seed Data
-- File    : 10_tm_cycle_seed.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @10_tm_cycle_seed.sql   (after 09_tm_cycle_ddl.sql)
-- Safe    : Idempotent (upsert pattern); admin-changed setting_value preserved.
-- Seeds   : new lookup sets (cadence/period/submission/visibility/relations),
--           3 new artifact types (CYCLE/PERIOD/SUBMISSION) + their default CRUD
--           matrix on the 6 team roles, and 2 module settings.
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- 1. NEW LOOKUP CATEGORIES + VALUES
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
    -- Reporting cadence
    upsert_category('TM_CADENCE', 'TM Reporting Cadence', 'دورية التقارير', v_cat);
    upsert_value(v_cat, 'WEEKLY',    'Weekly',      'أسبوعي',    10);
    upsert_value(v_cat, 'BIWEEKLY',  'Bi-Weekly',   'كل أسبوعين', 20);
    upsert_value(v_cat, 'MONTHLY',   'Monthly',     'شهري',      30, 'Y');
    upsert_value(v_cat, 'QUARTERLY', 'Quarterly',   'ربع سنوي',  40);
    upsert_value(v_cat, 'CUSTOM',    'Custom (days)', 'مخصص (أيام)', 50);

    -- Who must submit a period update
    upsert_category('TM_SUBMITTER_SCOPE', 'TM Submitter Scope', 'نطاق المُحدِّثين', v_cat);
    upsert_value(v_cat, 'ALL_MEMBERS', 'All Members',       'كل الأعضاء',   10, 'Y');
    upsert_value(v_cat, 'LEADS_ONLY',  'Leads Only',        'القادة فقط',   20);
    upsert_value(v_cat, 'SELECTED',    'Selected Members',  'أعضاء محددون', 30);

    -- Reporting-period status
    upsert_category('TM_PERIOD_STATUS', 'TM Period Status', 'حالة الفترة', v_cat);
    upsert_value(v_cat, 'PENDING', 'Pending', 'قيد الانتظار', 10, 'Y');
    upsert_value(v_cat, 'OPEN',    'Open',    'مفتوحة',       20);
    upsert_value(v_cat, 'DUE',     'Due',     'مستحقة',       30);
    upsert_value(v_cat, 'CLOSED',  'Closed',  'مغلقة',        40);
    upsert_value(v_cat, 'LOCKED',  'Locked',  'مقفلة',        50);

    -- Member submission status
    upsert_category('TM_SUBMISSION_STATUS', 'TM Submission Status', 'حالة التحديث', v_cat);
    upsert_value(v_cat, 'NOT_STARTED', 'Not Started', 'لم يبدأ',  10, 'Y');
    upsert_value(v_cat, 'DRAFT',       'Draft',       'مسودة',    20);
    upsert_value(v_cat, 'SUBMITTED',   'Submitted',   'مقدم',     30);
    upsert_value(v_cat, 'LATE',        'Submitted Late', 'مقدم متأخراً', 40);

    -- Visibility-grant scope
    upsert_category('TM_VIS_SCOPE', 'TM Visibility Scope', 'نطاق الاطلاع', v_cat);
    upsert_value(v_cat, 'TEAM',      'Single Team',         'فريق واحد',          10, 'Y');
    upsert_value(v_cat, 'TEAM_TREE', 'Team + Sub-teams',    'فريق وفرقه الفرعية', 20);
    upsert_value(v_cat, 'ORG',       'Org Unit (sector/dept)', 'وحدة تنظيمية',    30);
    upsert_value(v_cat, 'ALL',       'All Teams',           'كل الفرق',           40);

    -- Visibility access level
    upsert_category('TM_VIS_LEVEL', 'TM Visibility Level', 'مستوى الاطلاع', v_cat);
    upsert_value(v_cat, 'VIEWER',   'Viewer (read-only)',     'مطّلع (قراءة)',  10, 'Y');
    upsert_value(v_cat, 'REPORTER', 'Reporter (feeds roll-ups)', 'مُقرِّر',      20);

    -- Visibility-grant status
    upsert_category('TM_GRANT_STATUS', 'TM Grant Status', 'حالة المنح', v_cat);
    upsert_value(v_cat, 'ACTIVE',  'Active',  'نشط',   10, 'Y');
    upsert_value(v_cat, 'REVOKED', 'Revoked', 'ملغى',  20);

    -- Team relationship type (non-hierarchical links)
    upsert_category('TM_TEAM_RELATION', 'TM Team Relation', 'علاقة الفريق', v_cat);
    upsert_value(v_cat, 'PEER',     'Peer',           'نظير',   10, 'Y');
    upsert_value(v_cat, 'SUPPORTS', 'Supports',       'يدعم',   20);
    upsert_value(v_cat, 'BLOCKS',   'Blocks',         'يعيق',   30);
    upsert_value(v_cat, 'PROGRAM',  'Program / Parent', 'برنامج', 40);

    -- 3 new artifact types appended to the permission matrix vocabulary
    SELECT category_id INTO v_cat FROM prod.dct_lookup_categories WHERE category_code = 'TM_ARTIFACT_TYPE';
    upsert_value(v_cat, 'CYCLE',      'Reporting Cycle',  'دورة التقارير', 110);
    upsert_value(v_cat, 'PERIOD',     'Reporting Period', 'فترة التقرير',  120);
    upsert_value(v_cat, 'SUBMISSION', 'Progress Update',  'تحديث التقدم',  130);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Lookup sets seeded: 7 new categories + 3 artifact types');
END;
/

-- =============================================================================
-- 2. DEFAULT CRUD MATRIX for the new artifact types (template defaults, team_id NULL)
-- =============================================================================
DECLARE
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
    EXCEPTION WHEN NO_DATA_FOUND THEN
        NULL;   -- role not present (e.g. custom-only deployment) -> skip
    END;
BEGIN
    -- CYCLE config: leaders own it; supervisors may tune; everyone reads
    set_perm('LEADER',     'CYCLE', 'Y','Y','Y','Y');
    set_perm('SUPERVISOR', 'CYCLE', 'N','Y','Y','N');
    set_perm('COORDINATOR','CYCLE', 'N','Y','N','N');
    set_perm('MEMBER',     'CYCLE', 'N','Y','N','N');
    set_perm('QUALITY',    'CYCLE', 'N','Y','N','N');
    set_perm('OBSERVER',   'CYCLE', 'N','Y','N','N');

    -- PERIOD lifecycle (generate/close/lock/signoff = create/update): leaders + supervisors
    set_perm('LEADER',     'PERIOD', 'Y','Y','Y','Y');
    set_perm('SUPERVISOR', 'PERIOD', 'Y','Y','Y','N');
    set_perm('COORDINATOR','PERIOD', 'N','Y','N','N');
    set_perm('MEMBER',     'PERIOD', 'N','Y','N','N');
    set_perm('QUALITY',    'PERIOD', 'N','Y','N','N');
    set_perm('OBSERVER',   'PERIOD', 'N','Y','N','N');

    -- SUBMISSION: every working role can create/read/update (own enforced in package);
    -- leaders can read all; observers read-only
    set_perm('LEADER',     'SUBMISSION', 'Y','Y','Y','Y');
    set_perm('SUPERVISOR', 'SUBMISSION', 'Y','Y','Y','N');
    set_perm('COORDINATOR','SUBMISSION', 'Y','Y','Y','N');
    set_perm('MEMBER',     'SUBMISSION', 'Y','Y','Y','N');
    set_perm('QUALITY',    'SUBMISSION', 'Y','Y','Y','N');
    set_perm('OBSERVER',   'SUBMISSION', 'N','Y','N','N');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Default CRUD matrix seeded for CYCLE/PERIOD/SUBMISSION');
END;
/

-- =============================================================================
-- 3. MODULE SETTINGS
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
    END;
BEGIN
    SELECT module_id INTO v_module_id FROM prod.dct_modules WHERE module_code = 'TASK_MGMT';

    put_setting('CYCLE_ENABLED', 'Y', 'Enable Reporting Cycles',
        'Y = the periodic check-in engine generates periods, opens submissions and sends reminders.', 'BOOLEAN', 'Y|N', 'Y');
    put_setting('CYCLE_HORIZON_DAYS', '45', 'Cycle Generation Horizon (days)',
        'How far ahead the daily sweep pre-generates reporting periods for active team cadences.', 'NUMBER', NULL, '45');
    put_setting('CYCLE_WEEKLY_DIGEST', 'Y', 'Weekly Leader Digest',
        'Y = team leaders get a weekly (Sunday) in-app + mobile-push digest of their open period status and overdue tasks.', 'BOOLEAN', 'Y|N', 'Y');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Module settings seeded: CYCLE_ENABLED, CYCLE_HORIZON_DAYS, CYCLE_WEEKLY_DIGEST');
END;
/

PROMPT
PROMPT === 10_tm_cycle_seed.sql complete ===
PROMPT Lookups: TM_CADENCE, TM_SUBMITTER_SCOPE, TM_PERIOD_STATUS, TM_SUBMISSION_STATUS,
PROMPT          TM_VIS_SCOPE, TM_VIS_LEVEL, TM_GRANT_STATUS, TM_TEAM_RELATION
PROMPT Artifacts: CYCLE, PERIOD, SUBMISSION (+ default CRUD matrix on 6 roles)
PROMPT Settings : CYCLE_ENABLED, CYCLE_HORIZON_DAYS
