SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON
-- db/v2/102_dct_sec_seed_gl.sql
-- Security Console seeds, round 1: GL module (first adopter) plus the Admin
-- Security Console pages themselves. Verb-first privileges, privilege groups,
-- duty roles nested in job roles, the page and artifact registry that feeds
-- the Security Info drawer, and the FEATURE_SEC_ENFORCE_GL switch (N = the
-- grandfather path stays on; GL endpoints keep their historical any-valid-
-- session behaviour until the flag flips).
-- Idempotent. Order: 99, 100, 101, then this. Companion: GL/db/07/09/11/12/13
-- re-run (they now call dct_sec.has_priv_or_role + the SECTOR scope).

PROMPT --- GL privileges ---

DECLARE
    l_gl NUMBER;
    PROCEDURE ins_priv (p_code VARCHAR2, p_name VARCHAR2, p_ar VARCHAR2,
                        p_action VARCHAR2, p_mid NUMBER) IS
        v NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v FROM prod.dct_permissions WHERE permission_code = p_code;
        IF v = 0 THEN
            INSERT INTO prod.dct_permissions
                (permission_code, permission_name, permission_name_ar,
                 module_id, action_type, verb, created_by)
            VALUES (p_code, p_name, p_ar, p_mid, p_action,
                 UPPER(REGEXP_SUBSTR(p_name, '^\S+')), 'SEED');
        END IF;
    END;
BEGIN
    SELECT MAX(module_id) INTO l_gl FROM prod.dct_modules WHERE module_code = 'GL';

    ins_priv('GL_VIEW_OVERVIEW',           'View GL Overview',            UNISTR('\0639\0631\0636 \0646\0638\0631\0629 \0639\0627\0645\0629'), 'VIEW', l_gl);
    ins_priv('GL_VIEW_ACTUALS',            'View Actuals',                UNISTR('\0639\0631\0636 \0627\0644\0641\0639\0644\064a\0627\062a'), 'VIEW', l_gl);
    ins_priv('GL_VIEW_DASHBOARD',          'View GL Dashboard',           UNISTR('\0639\0631\0636 \0644\0648\062d\0629 \0627\0644\0645\0624\0634\0631\0627\062a'), 'VIEW', l_gl);
    ins_priv('GL_VIEW_BUDGET_UTILIZATION', 'View Budget Utilization',     UNISTR('\0639\0631\0636 \0627\0633\062a\062e\062f\0627\0645 \0627\0644\0645\064a\0632\0627\0646\064a\0629'), 'VIEW', l_gl);
    ins_priv('GL_VIEW_ENCUMBRANCES',       'View Projects Encumbrances',  UNISTR('\0639\0631\0636 \0627\0631\062a\0628\0627\0637\0627\062a \0627\0644\0645\0634\0627\0631\064a\0639'), 'VIEW', l_gl);
    ins_priv('GL_VIEW_PENDING_APPROVALS',  'View Pending Approvals',      UNISTR('\0639\0631\0636 \0627\0644\0645\0639\0627\0645\0644\0627\062a \0642\064a\062f \0627\0644\0627\0639\062a\0645\0627\062f'), 'VIEW', l_gl);
    ins_priv('GL_VIEW_CLASSIFICATIONS',    'View Classifications',        UNISTR('\0639\0631\0636 \0627\0644\062a\0635\0646\064a\0641\0627\062a'), 'VIEW', l_gl);
    ins_priv('GL_MANAGE_CLASSIFICATIONS',  'Manage Classifications',      UNISTR('\0625\062f\0627\0631\0629 \0627\0644\062a\0635\0646\064a\0641\0627\062a'), 'CONFIGURE', l_gl);
    ins_priv('GL_VIEW_MAPPING',            'View Segment Mapping',        UNISTR('\0639\0631\0636 \0631\0628\0637 \0627\0644\0642\0637\0627\0639\0627\062a'), 'VIEW', l_gl);
    ins_priv('GL_VIEW_EXPLORER',           'View COA Explorer',           UNISTR('\0639\0631\0636 \0645\0633\062a\0643\0634\0641 \0627\0644\062d\0633\0627\0628\0627\062a'), 'VIEW', l_gl);
    ins_priv('GL_RUN_ACTUALS_REFRESH',     'Run Actuals Refresh',         UNISTR('\062a\0634\063a\064a\0644 \062a\062d\062f\064a\062b \0627\0644\0641\0639\0644\064a\0627\062a'), 'CONFIGURE', l_gl);
    ins_priv('GL_RUN_VIEWS_REBUILD',       'Run Views Rebuild',           UNISTR('\062a\0634\063a\064a\0644 \0625\0639\0627\062f\0629 \0628\0646\0627\0621 \0627\0644\0639\0631\0648\0636'), 'CONFIGURE', l_gl);
    ins_priv('GL_RUN_BRIEFING_BOOK',       'Run Briefing Book',           UNISTR('\062a\0634\063a\064a\0644 \0643\062a\0627\0628 \0627\0644\0625\062d\0627\0637\0629'), 'EXPORT', l_gl);
    ins_priv('GL_EXPORT_REGISTERS',        'Export Registers',            UNISTR('\062a\0635\062f\064a\0631 \0627\0644\0633\062c\0644\0627\062a'), 'EXPORT', l_gl);
    ins_priv('ADMIN_MANAGE_SECURITY',      'Manage Security Console',     UNISTR('\0625\062f\0627\0631\0629 \0648\062d\062f\0629 \0627\0644\062a\062d\0643\0645 \0627\0644\0623\0645\0646\064a'), 'ADMIN', NULL);
    COMMIT;
END;
/

PROMPT --- GL privilege groups ---

DECLARE
    l_gl NUMBER;
    PROCEDURE ins_grp (p_code VARCHAR2, p_name VARCHAR2, p_ar VARCHAR2, p_mid NUMBER) IS
        v NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v FROM prod.dct_sec_priv_group WHERE group_code = p_code;
        IF v = 0 THEN
            INSERT INTO prod.dct_sec_priv_group
                (group_code, name_en, name_ar, module_id, created_by)
            VALUES (p_code, p_name, p_ar, p_mid, 'SEED');
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
    SELECT MAX(module_id) INTO l_gl FROM prod.dct_modules WHERE module_code = 'GL';

    ins_grp('GL_FIN_PLANNING_REPORTING', 'Financial Planning and Reporting',
        UNISTR('\0627\0644\062a\062e\0637\064a\0637 \0648\0627\0644\062a\0642\0627\0631\064a\0631 \0627\0644\0645\0627\0644\064a\0629'), l_gl);
    ins_grp('GL_ADMINISTRATION', 'GL Administration',
        UNISTR('\0625\062f\0627\0631\0629 \0627\0644\0623\0633\062a\0627\0630 \0627\0644\0639\0627\0645'), l_gl);

    ins_item('GL_FIN_PLANNING_REPORTING', 'GL_VIEW_OVERVIEW');
    ins_item('GL_FIN_PLANNING_REPORTING', 'GL_VIEW_ACTUALS');
    ins_item('GL_FIN_PLANNING_REPORTING', 'GL_VIEW_DASHBOARD');
    ins_item('GL_FIN_PLANNING_REPORTING', 'GL_VIEW_BUDGET_UTILIZATION');
    ins_item('GL_FIN_PLANNING_REPORTING', 'GL_VIEW_ENCUMBRANCES');
    ins_item('GL_FIN_PLANNING_REPORTING', 'GL_VIEW_PENDING_APPROVALS');
    ins_item('GL_FIN_PLANNING_REPORTING', 'GL_RUN_BRIEFING_BOOK');
    ins_item('GL_FIN_PLANNING_REPORTING', 'GL_EXPORT_REGISTERS');

    FOR r IN (SELECT permission_code FROM prod.dct_permissions
               WHERE permission_code LIKE 'GL[_]%' ESCAPE '[') LOOP
        ins_item('GL_ADMINISTRATION', r.permission_code);
    END LOOP;
    COMMIT;
END;
/

PROMPT --- GL duty and job roles ---

DECLARE
    l_gl NUMBER;
    PROCEDURE ins_role (p_code VARCHAR2, p_name VARCHAR2, p_ar VARCHAR2,
                        p_cat VARCHAR2, p_mid NUMBER) IS
        v NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v FROM prod.dct_roles WHERE role_code = p_code;
        IF v = 0 THEN
            INSERT INTO prod.dct_roles
                (role_code, role_name_en, role_name_ar, role_type, role_category,
                 module_id, created_by)
            VALUES (p_code, p_name, p_ar, 'MODULE', p_cat, p_mid, 'SEED');
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
    SELECT MAX(module_id) INTO l_gl FROM prod.dct_modules WHERE module_code = 'GL';

    ins_role('GL_DUTY_FIN_REPORTING', 'View Financial Planning Reports',
        UNISTR('\0639\0631\0636 \062a\0642\0627\0631\064a\0631 \0627\0644\062a\062e\0637\064a\0637 \0627\0644\0645\0627\0644\064a'), 'DUTY', l_gl);
    ins_role('GL_DUTY_CLASSIFICATION', 'Manage GL Classifications',
        UNISTR('\0625\062f\0627\0631\0629 \062a\0635\0646\064a\0641\0627\062a \0627\0644\0623\0633\062a\0627\0630 \0627\0644\0639\0627\0645'), 'DUTY', l_gl);
    ins_role('GL_DUTY_DATA_OPS', 'Run GL Data Operations',
        UNISTR('\062a\0634\063a\064a\0644 \0639\0645\0644\064a\0627\062a \0628\064a\0627\0646\0627\062a \0627\0644\0623\0633\062a\0627\0630 \0627\0644\0639\0627\0645'), 'DUTY', l_gl);
    ins_role('GL_ANALYST', 'GL Analyst',
        UNISTR('\0645\062d\0644\0644 \0627\0644\0623\0633\062a\0627\0630 \0627\0644\0639\0627\0645'), 'JOB', l_gl);
    ins_role('GL_ACCOUNTANT', 'General Ledger Accountant',
        UNISTR('\0645\062d\0627\0633\0628 \0627\0644\0623\0633\062a\0627\0630 \0627\0644\0639\0627\0645'), 'JOB', l_gl);

    ins_rgrp('GL_DUTY_FIN_REPORTING', 'GL_FIN_PLANNING_REPORTING');
    ins_rpriv('GL_DUTY_CLASSIFICATION', 'GL_VIEW_CLASSIFICATIONS');
    ins_rpriv('GL_DUTY_CLASSIFICATION', 'GL_MANAGE_CLASSIFICATIONS');
    ins_rpriv('GL_DUTY_CLASSIFICATION', 'GL_VIEW_MAPPING');
    ins_rpriv('GL_DUTY_CLASSIFICATION', 'GL_VIEW_EXPLORER');
    ins_rpriv('GL_DUTY_DATA_OPS', 'GL_RUN_ACTUALS_REFRESH');
    ins_rpriv('GL_DUTY_DATA_OPS', 'GL_RUN_VIEWS_REBUILD');

    ins_link('GL_ANALYST', 'GL_DUTY_FIN_REPORTING');
    ins_link('GL_ACCOUNTANT', 'GL_DUTY_FIN_REPORTING');
    ins_link('GL_ACCOUNTANT', 'GL_DUTY_CLASSIFICATION');
    ins_link('GL_ACCOUNTANT', 'GL_DUTY_DATA_OPS');

    prod.dct_sec.refresh_flat;
    COMMIT;
END;
/

PROMPT --- page registry: GL portal tabs plus Admin Security Console ---

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
    ins_page('GL', 'overview',        'GL Overview',                    'GL_VIEW_OVERVIEW', 10);
    ins_page('GL', 'actuals',         'Actuals',                        'GL_VIEW_ACTUALS', 20);
    ins_page('GL', 'dashboard',       'GL Dashboard',                   'GL_VIEW_DASHBOARD', 30);
    ins_page('GL', 'butil',           'Budget Utilization',             'GL_VIEW_BUDGET_UTILIZATION', 40);
    ins_page('GL', 'encumbrances',    'Open Projects Encumbrance Follow-up', 'GL_VIEW_ENCUMBRANCES', 50);
    ins_page('GL', 'pending',         'Encumbrances - Pending Approval', 'GL_VIEW_PENDING_APPROVALS', 60);
    ins_page('GL', 'classifications', 'Classifications',                'GL_VIEW_CLASSIFICATIONS', 70);
    ins_page('GL', 'mapping',         'Segment Mapping',                'GL_VIEW_MAPPING', 80);
    ins_page('GL', 'explorer',        'COA Explorer',                   'GL_VIEW_EXPLORER', 90);

    ins_art('GL', 'butil', 'BUTTON', 'generateReport', 'Generate Report (Briefing Book / Excel / PowerPoint)', 'GL_RUN_BRIEFING_BOOK');
    ins_art('GL', 'butil', 'BUTTON', 'exportCsv',      'Export CSV',            'GL_EXPORT_REGISTERS');
    ins_art('GL', 'butil', 'ENDPOINT', 'GET /gl/butil', 'Budget Utilization report', 'GL_VIEW_BUDGET_UTILIZATION');
    ins_art('GL', 'butil', 'ENDPOINT', 'GET /gl/butil/lines', 'Figure drill-down lines', 'GL_VIEW_BUDGET_UTILIZATION');
    ins_art('GL', 'overview', 'BUTTON', 'refreshActuals', 'Refresh Actuals',     'GL_RUN_ACTUALS_REFRESH');
    ins_art('GL', 'overview', 'BUTTON', 'rebuildViews',   'Rebuild Views',       'GL_RUN_VIEWS_REBUILD');
    ins_art('GL', 'pending', 'BUTTON', 'briefingBook', 'Briefing Book',          'GL_RUN_BRIEFING_BOOK');
    ins_art('GL', 'pending', 'BUTTON', 'exportExcel',  'Export Excel',           'GL_EXPORT_REGISTERS');
    ins_art('GL', 'pending', 'ENDPOINT', 'GET /gl/pending', 'Pending approvals register', 'GL_VIEW_PENDING_APPROVALS');
    ins_art('GL', 'encumbrances', 'ENDPOINT', 'GET /gl/encumbrances', 'Open encumbrance lines', 'GL_VIEW_ENCUMBRANCES');
    ins_art('GL', 'classifications', 'ACTION', 'editAssignments', 'Edit classification assignments', 'GL_MANAGE_CLASSIFICATIONS');

    ins_page('ADMIN', 'privileges',      'Privileges',        'ADMIN_MANAGE_SECURITY', 110);
    ins_page('ADMIN', 'privilegeGroups', 'Privilege Groups',  'ADMIN_MANAGE_SECURITY', 120);
    ins_page('ADMIN', 'abstractRoles',   'Abstract Roles',    'ADMIN_MANAGE_SECURITY', 130);
    ins_page('ADMIN', 'dutyRoles',       'Duty Roles',        'ADMIN_MANAGE_SECURITY', 140);
    ins_page('ADMIN', 'jobRoles',        'Job Roles',         'ADMIN_MANAGE_SECURITY', 150);
    ins_page('ADMIN', 'secProfiles',     'Security Profiles', 'ADMIN_MANAGE_SECURITY', 160);
    ins_page('ADMIN', 'userManagement',  'User Management',   'ADMIN_MANAGE_SECURITY', 170);

    ins_art('ADMIN', 'privileges',      'BUTTON', 'newPrivilege', 'New Privilege',  'ADMIN_MANAGE_SECURITY');
    ins_art('ADMIN', 'privilegeGroups', 'BUTTON', 'newGroup',     'New Group',      'ADMIN_MANAGE_SECURITY');
    ins_art('ADMIN', 'jobRoles',        'BUTTON', 'copyRole',     'Copy Role',      'ADMIN_MANAGE_SECURITY');
    ins_art('ADMIN', 'userManagement',  'TAB',    'roles',        'Role Assignments',    'ADMIN_MANAGE_SECURITY');
    ins_art('ADMIN', 'userManagement',  'TAB',    'profiles',     'Security Profile',    'ADMIN_MANAGE_SECURITY');
    ins_art('ADMIN', 'userManagement',  'TAB',    'exclusions',   'Exclusions',          'ADMIN_MANAGE_SECURITY');
    ins_art('ADMIN', 'userManagement',  'TAB',    'effective',    'Effective Privileges','ADMIN_MANAGE_SECURITY');
    COMMIT;
END;
/

PROMPT --- enforcement switch (OFF) ---

DECLARE
    v NUMBER;
BEGIN
    SELECT COUNT(*) INTO v FROM prod.dct_system_settings
     WHERE setting_key = 'FEATURE_SEC_ENFORCE_GL';
    IF v = 0 THEN
        INSERT INTO prod.dct_system_settings
            (setting_key, setting_value, value_type, category,
             description_en, is_system, created_by)
        VALUES ('FEATURE_SEC_ENFORCE_GL', 'N', 'BOOLEAN', 'SECURITY',
             'Y = GL endpoints require Security Console privileges (has_priv only). N = grandfather path: any valid session keeps working as before.',
             'Y', 'SEED');
    END IF;
    COMMIT;
END;
/

SELECT COUNT(*) AS gl_privs FROM prod.dct_permissions WHERE permission_code LIKE 'GL\_%' ESCAPE '\';
SELECT COUNT(*) AS pages FROM prod.dct_sec_page;

EXIT
