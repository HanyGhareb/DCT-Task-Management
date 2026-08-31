-- =============================================================================
-- Finance KPIs V2 (App 213) -- Phase 3 Security Console seeds (KPI module)
-- File   : 05_kpi2_security_seed.sql
-- Schema : PROD rows (run as ADMIN with -Dfile.encoding=UTF-8 -- Arabic literals)
-- Seeds  : verb-first KPI privileges (+ descriptions), privilege groups, duty
--          roles nested into the EXISTING job roles (KPI_ADMIN / KPI_USER /
--          KPI_FIN_DIRECTOR), the page + artifact registry for every KPI-V2
--          page (feeds the Security Info drawer), and FEATURE_SEC_ENFORCE_KPI=N.
-- Standing invariant: NOBODY gains or loses access until the enforce flag
--          flips -- module handlers keep their KPI_ADMIN role checks; the
--          privilege model runs in parallel (has_priv_or_role migration path).
-- Rerun  : idempotent (count-guarded inserts). Needs db/v2/99..101 deployed
--          (they are, since 2026-07-19). Ends with dct_sec.refresh_flat.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

PROMPT == 1. KPI privileges ==

DECLARE
    l_mid NUMBER;
    PROCEDURE ins_priv (p_code VARCHAR2, p_name VARCHAR2, p_ar VARCHAR2,
                        p_action VARCHAR2, p_desc VARCHAR2, p_desc_ar VARCHAR2) IS
        v NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v FROM prod.dct_permissions WHERE permission_code = p_code;
        IF v = 0 THEN
            INSERT INTO prod.dct_permissions
                (permission_code, permission_name, permission_name_ar,
                 module_id, action_type, verb, description_en, description_ar, created_by)
            VALUES (p_code, p_name, p_ar, l_mid, p_action,
                 UPPER(REGEXP_SUBSTR(p_name, '^\S+')), p_desc, p_desc_ar, 'SEED');
        END IF;
    END;
BEGIN
    SELECT MAX(module_id) INTO l_mid FROM prod.dct_modules WHERE module_code = 'KPI_MGMT';

    ins_priv('KPI_VIEW_WORKSPACE', 'View KPI Workspace', 'عرض مساحة عمل المؤشرات', 'VIEW',
        'Open the Me tab - the end-user KPI workspace.',
        'فتح تبويب أنا - مساحة عمل المستخدم لمؤشرات الأداء.');
    ins_priv('KPI_VIEW_ADMIN', 'View KPI Administration', 'عرض إدارة المؤشرات', 'VIEW',
        'Open the Admin tab - the plan administrators workspace.',
        'فتح تبويب الإدارة - مساحة عمل مسؤولي الخطط.');
    ins_priv('KPI_VIEW_CONFIGURATIONS', 'View KPI Configurations', 'عرض تهيئة المؤشرات', 'VIEW',
        'Open the Configurations tab of the KPI application.',
        'فتح تبويب التهيئة في تطبيق مؤشرات الأداء.');
    ins_priv('KPI_VIEW_SETTINGS', 'View KPI Settings', 'عرض إعدادات المؤشرات', 'VIEW',
        'Open the Settings tab of the KPI application.',
        'فتح تبويب الإعدادات في تطبيق مؤشرات الأداء.');
    ins_priv('KPI_MANAGE_LOOKUPS', 'Manage KPI Lookups', 'إدارة قوائم المؤشرات', 'CONFIGURE',
        'Create and edit KPI lookup lists and their values (Settings - Manage Lookups).',
        'إنشاء وتعديل قوائم المؤشرات وقيمها (الإعدادات - إدارة القوائم).');
    ins_priv('KPI_MANAGE_DEFINITIONS', 'Manage KPI Definitions', 'إدارة تعريفات المؤشرات', 'CONFIGURE',
        'Create and edit KPI master records including score bands (Settings - Manage KPIs).',
        'إنشاء وتعديل السجلات الرئيسية للمؤشرات بما فيها نطاقات الدرجات (الإعدادات - إدارة المؤشرات).');
    ins_priv('KPI_EXPORT_REGISTERS', 'Export KPI Registers', 'تصدير سجلات المؤشرات', 'EXPORT',
        'Export KPI lookups and KPI definitions to CSV.',
        'تصدير قوائم المؤشرات وتعريفاتها إلى ملفات CSV.');
    COMMIT;
END;
/

PROMPT == 2. KPI privilege groups ==

DECLARE
    l_mid NUMBER;
    PROCEDURE ins_grp (p_code VARCHAR2, p_name VARCHAR2, p_ar VARCHAR2, p_desc VARCHAR2) IS
        v NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v FROM prod.dct_sec_priv_group WHERE group_code = p_code;
        IF v = 0 THEN
            INSERT INTO prod.dct_sec_priv_group
                (group_code, name_en, name_ar, module_id, description_en, created_by)
            VALUES (p_code, p_name, p_ar, l_mid, p_desc, 'SEED');
        END IF;
    END;
    PROCEDURE ins_item (p_grp VARCHAR2, p_priv VARCHAR2) IS
    BEGIN
        INSERT INTO prod.dct_sec_priv_group_item (group_id, permission_id, added_by)
        SELECT g.group_id, p.permission_id, 'SEED'
          FROM prod.dct_sec_priv_group g, prod.dct_permissions p
         WHERE g.group_code = p_grp AND p.permission_code = p_priv
           AND NOT EXISTS (SELECT 1 FROM prod.dct_sec_priv_group_item i
                            WHERE i.group_id = g.group_id
                              AND i.permission_id = p.permission_id);
    END;
BEGIN
    SELECT MAX(module_id) INTO l_mid FROM prod.dct_modules WHERE module_code = 'KPI_MGMT';

    ins_grp('KPI_SETTINGS_MGMT', 'KPI Settings Management', 'إدارة إعدادات المؤشرات',
        'Everything needed to run the KPI Settings tab: lookups, KPI definitions and register exports.');
    ins_grp('KPI_WORKSPACE_ACCESS', 'KPI Workspace Access', 'الوصول إلى مساحة عمل المؤشرات',
        'End-user access to the KPI workspace (Me tab).');

    ins_item('KPI_SETTINGS_MGMT', 'KPI_VIEW_SETTINGS');
    ins_item('KPI_SETTINGS_MGMT', 'KPI_MANAGE_LOOKUPS');
    ins_item('KPI_SETTINGS_MGMT', 'KPI_MANAGE_DEFINITIONS');
    ins_item('KPI_SETTINGS_MGMT', 'KPI_EXPORT_REGISTERS');
    ins_item('KPI_WORKSPACE_ACCESS', 'KPI_VIEW_WORKSPACE');
    COMMIT;
END;
/

PROMPT == 3. KPI duty roles nested into the existing job roles ==

DECLARE
    l_mid NUMBER;
    PROCEDURE ins_role (p_code VARCHAR2, p_name VARCHAR2, p_ar VARCHAR2, p_desc VARCHAR2) IS
        v NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v FROM prod.dct_roles WHERE role_code = p_code;
        IF v = 0 THEN
            INSERT INTO prod.dct_roles
                (role_code, role_name_en, role_name_ar, role_type, role_category,
                 module_id, description_en, created_by)
            VALUES (p_code, p_name, p_ar, 'MODULE', 'DUTY', l_mid, p_desc, 'SEED');
        END IF;
    END;
    PROCEDURE ins_rgrp (p_role VARCHAR2, p_grp VARCHAR2) IS
    BEGIN
        INSERT INTO prod.dct_sec_role_priv_group (role_id, group_id, granted_by)
        SELECT r.role_id, g.group_id, 'SEED'
          FROM prod.dct_roles r, prod.dct_sec_priv_group g
         WHERE r.role_code = p_role AND g.group_code = p_grp
           AND NOT EXISTS (SELECT 1 FROM prod.dct_sec_role_priv_group x
                            WHERE x.role_id = r.role_id AND x.group_id = g.group_id);
    END;
    PROCEDURE ins_rpriv (p_role VARCHAR2, p_priv VARCHAR2) IS
    BEGIN
        INSERT INTO prod.dct_role_permissions (role_id, permission_id, granted_by)
        SELECT r.role_id, p.permission_id, 'SEED'
          FROM prod.dct_roles r, prod.dct_permissions p
         WHERE r.role_code = p_role AND p.permission_code = p_priv
           AND NOT EXISTS (SELECT 1 FROM prod.dct_role_permissions x
                            WHERE x.role_id = r.role_id AND x.permission_id = p.permission_id);
    END;
    PROCEDURE ins_link (p_parent VARCHAR2, p_child VARCHAR2) IS
    BEGIN
        INSERT INTO prod.dct_sec_role_hierarchy (parent_role_id, child_role_id, created_by)
        SELECT pa.role_id, ch.role_id, 'SEED'
          FROM prod.dct_roles pa, prod.dct_roles ch
         WHERE pa.role_code = p_parent AND ch.role_code = p_child
           AND NOT EXISTS (SELECT 1 FROM prod.dct_sec_role_hierarchy h
                            WHERE h.parent_role_id = pa.role_id
                              AND h.child_role_id = ch.role_id);
    END;
BEGIN
    SELECT MAX(module_id) INTO l_mid FROM prod.dct_modules WHERE module_code = 'KPI_MGMT';

    ins_role('KPI_DUTY_SETTINGS', 'Manage KPI Settings', 'إدارة إعدادات المؤشرات',
        'Run the KPI Settings tab: lookups, KPI definitions and exports.');
    ins_role('KPI_DUTY_WORKSPACE', 'View KPI Workspace', 'عرض مساحة عمل المؤشرات',
        'End-user access to the KPI workspace (Me tab).');
    ins_role('KPI_DUTY_ADMINISTRATION', 'Administer KPI Plans', 'إدارة خطط المؤشرات',
        'Plan administration and configuration tabs of the KPI application.');

    ins_rgrp('KPI_DUTY_SETTINGS',  'KPI_SETTINGS_MGMT');
    ins_rgrp('KPI_DUTY_WORKSPACE', 'KPI_WORKSPACE_ACCESS');
    ins_rpriv('KPI_DUTY_ADMINISTRATION', 'KPI_VIEW_ADMIN');
    ins_rpriv('KPI_DUTY_ADMINISTRATION', 'KPI_VIEW_CONFIGURATIONS');

    ins_link('KPI_ADMIN', 'KPI_DUTY_SETTINGS');
    ins_link('KPI_ADMIN', 'KPI_DUTY_WORKSPACE');
    ins_link('KPI_ADMIN', 'KPI_DUTY_ADMINISTRATION');
    ins_link('KPI_USER',  'KPI_DUTY_WORKSPACE');
    ins_link('KPI_FIN_DIRECTOR', 'KPI_DUTY_WORKSPACE');

    prod.dct_sec.refresh_flat;
    COMMIT;
END;
/

PROMPT == 4. page + artifact registry (KPI-V2 pages) ==

DECLARE
    PROCEDURE ins_page (p_mod VARCHAR2, p_page VARCHAR2, p_name VARCHAR2,
                        p_priv VARCHAR2, p_ord NUMBER) IS
        v NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v FROM prod.dct_sec_page
         WHERE module_code = p_mod AND page_code = p_page;
        IF v = 0 THEN
            INSERT INTO prod.dct_sec_page
                (module_code, page_code, name_en, view_permission_id,
                 display_order, created_by)
            SELECT p_mod, p_page, p_name,
                   (SELECT MAX(permission_id) FROM prod.dct_permissions
                     WHERE permission_code = p_priv),
                   p_ord, 'SEED'
              FROM dual;
        END IF;
    END;
    PROCEDURE ins_art (p_mod VARCHAR2, p_page VARCHAR2, p_type VARCHAR2,
                       p_code VARCHAR2, p_label VARCHAR2, p_priv VARCHAR2) IS
    BEGIN
        INSERT INTO prod.dct_sec_page_artifact
            (page_id, artifact_type, artifact_code, label_en, permission_id)
        SELECT pg.page_id, p_type, p_code, p_label,
               (SELECT MAX(permission_id) FROM prod.dct_permissions
                 WHERE permission_code = p_priv)
          FROM prod.dct_sec_page pg
         WHERE pg.module_code = p_mod AND pg.page_code = p_page
           AND NOT EXISTS (SELECT 1 FROM prod.dct_sec_page_artifact a
                            WHERE a.page_id = pg.page_id
                              AND a.artifact_type = p_type
                              AND a.artifact_code = p_code);
    END;
BEGIN
    ins_page('KPI_MGMT', 'me',             'Me - KPI Workspace (V2)',      'KPI_VIEW_WORKSPACE', 10);
    ins_page('KPI_MGMT', 'admin',          'Admin - Plan Administration (V2)', 'KPI_VIEW_ADMIN', 20);
    ins_page('KPI_MGMT', 'configurations', 'Configurations (V2)',          'KPI_VIEW_CONFIGURATIONS', 30);
    ins_page('KPI_MGMT', 'settings',       'Settings (V2)',                'KPI_VIEW_SETTINGS', 40);

    ins_art('KPI_MGMT', 'settings', 'TAB', 'lookups',  'Manage Lookups',  'KPI_MANAGE_LOOKUPS');
    ins_art('KPI_MGMT', 'settings', 'TAB', 'kpis',     'Manage KPIs',     'KPI_MANAGE_DEFINITIONS');
    ins_art('KPI_MGMT', 'settings', 'TAB', 'security', 'Manage Security (forwards to the Admin Security Console)', 'ADMIN_MANAGE_SECURITY');
    ins_art('KPI_MGMT', 'settings', 'BUTTON', 'newLookup', 'New Lookup / New Value', 'KPI_MANAGE_LOOKUPS');
    ins_art('KPI_MGMT', 'settings', 'BUTTON', 'newKpi',    'New KPI',                'KPI_MANAGE_DEFINITIONS');
    ins_art('KPI_MGMT', 'settings', 'BUTTON', 'exportCsv', 'Export CSV (lookups / values / KPIs)', 'KPI_EXPORT_REGISTERS');
    ins_art('KPI_MGMT', 'settings', 'ENDPOINT', 'GET/POST /kpi/v2/lookups',        'Lookup master CRUD',   'KPI_MANAGE_LOOKUPS');
    ins_art('KPI_MGMT', 'settings', 'ENDPOINT', 'GET/POST /kpi/v2/lookups/:id/values', 'Lookup values CRUD', 'KPI_MANAGE_LOOKUPS');
    ins_art('KPI_MGMT', 'settings', 'ENDPOINT', 'PUT /kpi/v2/lookup-values/:id',   'Lookup value update',  'KPI_MANAGE_LOOKUPS');
    ins_art('KPI_MGMT', 'settings', 'ENDPOINT', 'GET/POST /kpi/v2/kpis',           'KPI master CRUD',      'KPI_MANAGE_DEFINITIONS');
    ins_art('KPI_MGMT', 'settings', 'ENDPOINT', 'GET/PUT /kpi/v2/kpis/:id',        'KPI detail / update',  'KPI_MANAGE_DEFINITIONS');
    ins_art('KPI_MGMT', 'settings', 'ENDPOINT', 'GET /kpi/v2/kpi-lovs',            'KPI form lookup values', 'KPI_MANAGE_DEFINITIONS');
    COMMIT;
END;
/

PROMPT == 5. enforcement switch (OFF) ==

DECLARE
    v NUMBER;
BEGIN
    SELECT COUNT(*) INTO v FROM prod.dct_system_settings
     WHERE setting_key = 'FEATURE_SEC_ENFORCE_KPI';
    IF v = 0 THEN
        INSERT INTO prod.dct_system_settings
            (setting_key, setting_value, value_type, category,
             description_en, is_system, created_by)
        VALUES ('FEATURE_SEC_ENFORCE_KPI', 'N', 'BOOLEAN', 'SECURITY',
             'Y = KPI endpoints require Security Console privileges (has_priv only). N = grandfather path: the KPI_ADMIN/KPI_USER role checks keep working as before.',
             'Y', 'SEED');
    END IF;
    COMMIT;
END;
/

PROMPT == verification ==
SELECT COUNT(*) AS kpi_privs FROM prod.dct_permissions WHERE permission_code LIKE 'KPI\_%' ESCAPE '\';
SELECT COUNT(*) AS kpi_pages FROM prod.dct_sec_page WHERE module_code = 'KPI_MGMT';
SELECT role_code, role_category FROM prod.dct_roles WHERE role_code LIKE 'KPI\_DUTY%' ESCAPE '\' ORDER BY 1;
