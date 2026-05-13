-- =============================================================================
-- Petty Cash Module — Seed Data
-- File    : 03_pc_seed.sql
-- Schema  : PROD
-- DB      : Oracle 23ai
-- Module  : PETTY_CASH (f101)
-- Depends : db/v2/04_dct_seed.sql (platform roles/modules must exist first)
--           01_pc_ddl.sql
-- =============================================================================
-- Sections:
--   1. Module registration  (DCT_MODULES)
--   2. Role                 (DCT_ROLES)
--   3. Permissions          (DCT_PERMISSIONS + DCT_ROLE_PERMISSIONS)
--   4. Module settings      (DCT_MODULE_SETTINGS)
--   5. Approval workflows   (DCT_APPROVAL_TEMPLATES + DCT_APPROVAL_STEPS)
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

-- =============================================================================
-- 1. MODULE REGISTRATION
--    Upsert so the script is idempotent.
-- =============================================================================
MERGE INTO dct_modules tgt
USING (
    SELECT
        'PETTY_CASH'                       AS module_code,
        'Petty Cash'                       AS module_name_en,
        'السلف النقدية'                    AS module_name_ar,
        'APEX_APP'                         AS module_type,
        101                                AS apex_app_id,
        1                                  AS apex_page_id,
        'fa-money'                         AS icon_class,
        '#1A7F5A'                          AS icon_color,
        '#F0FBF6'                          AS bg_color,
        'Manages petty cash advance payments, reimbursements, and clearings for all DCT employees.' AS description_en,
        'إدارة السلف النقدية والمصروفات والتسويات لجميع موظفي هيئة الثقافة والسياحة'              AS description_ar,
        'HR'                               AS category,
        20                                 AS display_order,
        'Y'                                AS is_active,
        'N'                                AS is_new_tab,
        'N'                                AS is_admin_only
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
    UPDATE SET
        module_name_en = src.module_name_en,
        module_name_ar = src.module_name_ar,
        apex_app_id    = src.apex_app_id,
        icon_class     = src.icon_class,
        category       = src.category,
        is_active      = src.is_active;

-- =============================================================================
-- 2. ROLES
-- =============================================================================
MERGE INTO dct_roles tgt
USING (
    SELECT 'AP_PETTY_CASH_ADMIN' AS role_code,
           'AP Petty Cash Admin'  AS role_name_en,
           'مدير السلف النقدية'   AS role_name_ar,
           'MODULE'               AS role_type,
           (SELECT module_id FROM dct_modules WHERE module_code = 'PETTY_CASH') AS module_id,
           'Full org-wide access to all petty cash, reimbursement, and clearing records. Processes disbursements and reconciliations.' AS description_en,
           'Y'                    AS is_active,
           'N'                    AS is_system_role,
           10                     AS display_order
    FROM dual
) src ON (tgt.role_code = src.role_code)
WHEN NOT MATCHED THEN
    INSERT (role_code, role_name_en, role_name_ar, role_type, module_id,
            description_en, is_active, is_system_role, display_order)
    VALUES (src.role_code, src.role_name_en, src.role_name_ar, src.role_type, src.module_id,
            src.description_en, src.is_active, src.is_system_role, src.display_order)
WHEN MATCHED THEN
    UPDATE SET role_name_en = src.role_name_en,
               role_name_ar = src.role_name_ar,
               is_active    = src.is_active;

-- =============================================================================
-- 3. PERMISSIONS
-- =============================================================================
DECLARE
    v_module_id   dct_modules.module_id%TYPE;
    v_ap_role_id  dct_roles.role_id%TYPE;

    TYPE t_perm IS RECORD (
        perm_code    dct_permissions.permission_code%TYPE,
        perm_name    dct_permissions.permission_name%TYPE,
        action_type  dct_permissions.action_type%TYPE
    );
    TYPE t_perm_list IS TABLE OF t_perm;

    v_perms t_perm_list := t_perm_list(
        t_perm('PETTY_CASH.VIEW',            'View own petty cash',                 'VIEW'),
        t_perm('PETTY_CASH.CREATE',          'Submit petty cash request',           'CREATE'),
        t_perm('PETTY_CASH.EDIT',            'Edit own draft petty cash',           'EDIT'),
        t_perm('PETTY_CASH.APPROVE',         'Approve / reject petty cash',         'APPROVE'),
        t_perm('PETTY_CASH.VIEW_ALL',        'View all org petty cash (admin)',     'VIEW'),
        t_perm('PETTY_CASH.ADMIN',           'Full admin access to petty cash',     'ADMIN'),
        t_perm('REIMBURSEMENT.VIEW',         'View own reimbursements',             'VIEW'),
        t_perm('REIMBURSEMENT.CREATE',       'Submit reimbursement request',        'CREATE'),
        t_perm('REIMBURSEMENT.APPROVE',      'Approve / reject reimbursements',     'APPROVE'),
        t_perm('REIMBURSEMENT.VIEW_ALL',     'View all org reimbursements (admin)', 'VIEW'),
        t_perm('CLEARING.VIEW',              'View own clearing requests',          'VIEW'),
        t_perm('CLEARING.CREATE',            'Submit clearing request',             'CREATE'),
        t_perm('CLEARING.APPROVE',           'Approve / reject clearings',          'APPROVE'),
        t_perm('CLEARING.VIEW_ALL',          'View all org clearings (admin)',      'VIEW'),
        t_perm('GL_CODE_COMBINATIONS.VIEW',  'View GL code combinations',          'VIEW'),
        t_perm('GL_CODE_COMBINATIONS.ADMIN', 'Manage GL code combinations',        'ADMIN'),
        t_perm('PC_MODULE_SETTINGS.VIEW',    'View petty cash module settings',    'VIEW'),
        t_perm('PC_MODULE_SETTINGS.CONFIGURE','Configure petty cash settings',     'CONFIGURE'),
        t_perm('PC_APPROVAL_RULES.CONFIGURE','Configure approval workflows',       'CONFIGURE')
    );

    v_perm_id dct_permissions.permission_id%TYPE;
BEGIN
    SELECT module_id INTO v_module_id FROM dct_modules WHERE module_code = 'PETTY_CASH';
    SELECT role_id   INTO v_ap_role_id FROM dct_roles   WHERE role_code  = 'AP_PETTY_CASH_ADMIN';

    FOR i IN 1 .. v_perms.COUNT LOOP
        -- Upsert permission
        MERGE INTO dct_permissions p
        USING (SELECT v_perms(i).perm_code AS permission_code FROM dual) src
        ON    (p.permission_code = src.permission_code)
        WHEN NOT MATCHED THEN
            INSERT (permission_code, permission_name, module_id, action_type, is_active)
            VALUES (v_perms(i).perm_code, v_perms(i).perm_name, v_module_id,
                    v_perms(i).action_type, 'Y')
        WHEN MATCHED THEN
            UPDATE SET permission_name = v_perms(i).perm_name,
                       action_type     = v_perms(i).action_type;

        -- Grant all petty cash permissions to AP_PETTY_CASH_ADMIN
        SELECT permission_id INTO v_perm_id
        FROM   dct_permissions
        WHERE  permission_code = v_perms(i).perm_code;

        MERGE INTO dct_role_permissions rp
        USING (SELECT v_ap_role_id AS role_id, v_perm_id AS permission_id FROM dual) src
        ON    (rp.role_id = src.role_id AND rp.permission_id = src.permission_id)
        WHEN NOT MATCHED THEN
            INSERT (role_id, permission_id, granted_by)
            VALUES (v_ap_role_id, v_perm_id, 'SEED');
    END LOOP;
END;
/

-- =============================================================================
-- 4. MODULE SETTINGS (defaults)
--    Values reflect the locked BRD v1.0 defaults.
--    Admin can update SETTING_VALUE at runtime via the Module Settings page.
-- =============================================================================
DECLARE
    v_module_id dct_modules.module_id%TYPE;

    TYPE t_setting IS RECORD (
        s_key   dct_module_settings.setting_key%TYPE,
        s_val   dct_module_settings.setting_value%TYPE,
        s_label dct_module_settings.setting_label%TYPE,
        s_desc  dct_module_settings.setting_description%TYPE,
        s_type  dct_module_settings.value_type%TYPE,
        s_allow dct_module_settings.allowed_values%TYPE,
        s_def   dct_module_settings.default_value%TYPE
    );
    TYPE t_setting_list IS TABLE OF t_setting;

    v_settings t_setting_list := t_setting_list(
        t_setting(
            'BUDGET_VALIDATION_MODE',
            'SOFT',
            'Budget Validation Mode',
            'HARD = block submission if line amount exceeds FUND_AVAILABLE. SOFT = show warning only.',
            'SELECT', 'HARD|SOFT', 'SOFT'
        ),
        t_setting(
            'ALLOW_MULTIPLE_PC',
            'N',
            'Allow Multiple Active Petty Cash',
            'Y = employee may hold more than one active petty cash simultaneously.',
            'BOOLEAN', 'Y|N', 'N'
        ),
        t_setting(
            'MAX_PC_PER_EMPLOYEE',
            '1',
            'Max Active Petty Cash per Employee',
            'Maximum number of active petty cash advances an employee may hold at one time. Applies only when ALLOW_MULTIPLE_PC = Y.',
            'NUMBER', NULL, '1'
        ),
        t_setting(
            'MAX_PC_AMOUNT',
            NULL,
            'Max Petty Cash Amount (AED)',
            'Maximum advance amount allowed per petty cash request. Leave empty for no limit.',
            'NUMBER', NULL, NULL
        ),
        t_setting(
            'FISCAL_YEAR_START_MONTH',
            '1',
            'Fiscal Year Start Month',
            'Month number when the DCT fiscal year begins (1=January, 4=April, etc.).',
            'NUMBER', NULL, '1'
        ),
        t_setting(
            'SHOW_CLOSING_BANNER',
            'Y',
            'Show Closing Deadline Banner',
            'Y = display the deadline reminder banner on the home dashboard for employees with Temporary petty cash.',
            'BOOLEAN', 'Y|N', 'Y'
        ),
        t_setting(
            'TEMP_PC_CLOSING_DEADLINE_MSG',
            NULL,
            'Temporary PC Closing Message',
            'Banner text displayed to employees with an active Temporary petty cash near fiscal year-end. Leave empty to hide the banner.',
            'TEXT', NULL, NULL
        )
    );
BEGIN
    SELECT module_id INTO v_module_id FROM dct_modules WHERE module_code = 'PETTY_CASH';

    FOR i IN 1 .. v_settings.COUNT LOOP
        MERGE INTO dct_module_settings s
        USING (SELECT v_module_id AS module_id,
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
END;
/

-- =============================================================================
-- 5. APPROVAL WORKFLOWS  (DCT_APPROVAL_TEMPLATES + DCT_APPROVAL_STEPS)
--    Three workflows — one per request type.
--    These are EXAMPLE configurations; Admin can modify steps at runtime.
--
--    Workflow A — PETTY_CASH advance:
--      Step 1: Line Manager         (ALWAYS)
--      Step 2: AP_PETTY_CASH_ADMIN  (amount >= 5,000 AED)
--      Step 3: Finance Director     (amount >= 20,000 AED)
--      Step 4: AP_PETTY_CASH_ADMIN  (PC_TYPE = PERMANENT)
--
--    Workflow B — REIMBURSEMENT:
--      Step 1: Line Manager         (ALWAYS)
--      Step 2: AP_PETTY_CASH_ADMIN  (ALWAYS)
--
--    Workflow C — CLEARING:
--      Step 1: Line Manager         (ALWAYS)
--      Step 2: AP_PETTY_CASH_ADMIN  (ALWAYS)
-- =============================================================================
DECLARE
    v_module_id        dct_modules.module_id%TYPE;
    v_mgr_role_id      dct_roles.role_id%TYPE;
    v_ap_role_id       dct_roles.role_id%TYPE;
    v_dir_role_id      dct_roles.role_id%TYPE;

    v_tmpl_pc_id       dct_approval_templates.template_id%TYPE;
    v_tmpl_reimb_id    dct_approval_templates.template_id%TYPE;
    v_tmpl_clr_id      dct_approval_templates.template_id%TYPE;

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
            UPDATE SET template_name = p_name,
                       request_type  = p_request_type,
                       is_active     = 'Y';

        SELECT template_id INTO p_id
        FROM   dct_approval_templates
        WHERE  template_code = p_code;
    END;

    PROCEDURE upsert_step (
        p_template_id    IN NUMBER,
        p_seq            IN NUMBER,
        p_name           IN VARCHAR2,
        p_role_id        IN NUMBER,
        p_cond_type      IN VARCHAR2,
        p_amount_op      IN VARCHAR2  DEFAULT NULL,
        p_amount_thresh  IN NUMBER    DEFAULT NULL,
        p_type_filter    IN VARCHAR2  DEFAULT NULL
    ) IS
    BEGIN
        MERGE INTO dct_approval_steps s
        USING (SELECT p_template_id AS template_id,
                      p_seq         AS step_seq FROM dual) src
        ON    (s.template_id = src.template_id AND s.step_seq = src.step_seq)
        WHEN NOT MATCHED THEN
            INSERT (template_id, step_seq, step_name, step_type, required_role_id,
                    escalation_days, is_mandatory, allow_skip,
                    condition_type, amount_operator, amount_threshold, type_filter)
            VALUES (p_template_id, p_seq, p_name, 'ROLE_BASED', p_role_id,
                    3, 'Y', 'N',
                    p_cond_type, p_amount_op, p_amount_thresh, p_type_filter)
        WHEN MATCHED THEN
            UPDATE SET step_name        = p_name,
                       required_role_id = p_role_id,
                       condition_type   = p_cond_type,
                       amount_operator  = p_amount_op,
                       amount_threshold = p_amount_thresh,
                       type_filter      = p_type_filter;
    END;

BEGIN
    SELECT module_id INTO v_module_id   FROM dct_modules WHERE module_code = 'PETTY_CASH';
    SELECT role_id   INTO v_ap_role_id  FROM dct_roles   WHERE role_code   = 'AP_PETTY_CASH_ADMIN';

    -- MANAGER role is a platform role seeded in 04_dct_seed.sql
    BEGIN
        SELECT role_id INTO v_mgr_role_id FROM dct_roles WHERE role_code = 'MANAGER';
    EXCEPTION WHEN NO_DATA_FOUND THEN
        v_mgr_role_id := v_ap_role_id;  -- fallback if platform seed not yet run
    END;

    -- FINANCE_DIRECTOR role is a platform role seeded in 04_dct_seed.sql
    BEGIN
        SELECT role_id INTO v_dir_role_id FROM dct_roles WHERE role_code = 'FINANCE_DIRECTOR';
    EXCEPTION WHEN NO_DATA_FOUND THEN
        v_dir_role_id := v_ap_role_id;  -- fallback
    END;

    -- -------------------------------------------------------------------------
    -- Workflow A: Petty Cash Advance
    -- -------------------------------------------------------------------------
    upsert_template(
        p_code         => 'PC_ADVANCE_APPROVAL',
        p_name         => 'Petty Cash Advance Approval',
        p_module_id    => v_module_id,
        p_request_type => 'PETTY_CASH',
        p_desc         => 'Standard approval workflow for new petty cash advance requests. Steps 2-4 fire conditionally based on amount and type.',
        p_id           => v_tmpl_pc_id
    );

    upsert_step(v_tmpl_pc_id, 1, 'Line Manager Approval',
                v_mgr_role_id, 'ALWAYS');

    upsert_step(v_tmpl_pc_id, 2, 'AP Admin Review (amount >= 5,000 AED)',
                v_ap_role_id, 'AMOUNT', '>=', 5000);

    upsert_step(v_tmpl_pc_id, 3, 'Finance Director Approval (amount >= 20,000 AED)',
                v_dir_role_id, 'AMOUNT', '>=', 20000);

    upsert_step(v_tmpl_pc_id, 4, 'AP Admin — Permanent Petty Cash',
                v_ap_role_id, 'TYPE_FILTER',
                p_type_filter => 'PERMANENT');

    -- -------------------------------------------------------------------------
    -- Workflow B: Reimbursement
    -- -------------------------------------------------------------------------
    upsert_template(
        p_code         => 'PC_REIMBURSEMENT_APPROVAL',
        p_name         => 'Petty Cash Reimbursement Approval',
        p_module_id    => v_module_id,
        p_request_type => 'REIMBURSEMENT',
        p_desc         => 'Approval workflow for petty cash reimbursement requests.',
        p_id           => v_tmpl_reimb_id
    );

    upsert_step(v_tmpl_reimb_id, 1, 'Line Manager Approval',
                v_mgr_role_id, 'ALWAYS');

    upsert_step(v_tmpl_reimb_id, 2, 'AP Admin Review',
                v_ap_role_id, 'ALWAYS');

    -- -------------------------------------------------------------------------
    -- Workflow C: Clearing
    -- -------------------------------------------------------------------------
    upsert_template(
        p_code         => 'PC_CLEARING_APPROVAL',
        p_name         => 'Petty Cash Clearing Approval',
        p_module_id    => v_module_id,
        p_request_type => 'CLEARING',
        p_desc         => 'Approval workflow for petty cash clearing (advance settlement) requests.',
        p_id           => v_tmpl_clr_id
    );

    upsert_step(v_tmpl_clr_id, 1, 'Line Manager Approval',
                v_mgr_role_id, 'ALWAYS');

    upsert_step(v_tmpl_clr_id, 2, 'AP Admin Reconciliation',
                v_ap_role_id, 'ALWAYS');

END;
/

COMMIT;
-- End of 03_pc_seed.sql
