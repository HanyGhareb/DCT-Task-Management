-- =============================================================================
-- Credit Cards Module (App 202) — Seed Data
-- File    : 03_cc_seed.sql
-- Schema  : PROD
-- Run     : After 01_cc_ddl.sql and 02_cc_views.sql
-- Safe    : Idempotent — uses MERGE INTO throughout
-- Depends : db/v2/04_dct_seed.sql (platform roles MANAGER, ADMIN must exist)
--           01_cc_ddl.sql
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- 1. MODULE REGISTRATION — DCT_MODULES
-- =============================================================================
MERGE INTO dct_modules tgt
USING (
    SELECT
        'CREDIT_CARDS'   AS module_code,
        'Credit Cards'   AS module_name_en,
        'بطاقات الائتمان' AS module_name_ar,
        'APEX_APP'       AS module_type,
        202              AS apex_app_id,
        1                AS apex_page_id,
        'fa-credit-card' AS icon_class,
        '#0A558C'        AS icon_color,
        '#EBF5FB'        AS bg_color,
        'Corporate credit card lifecycle management — issuance, limit changes, replacement, closure, and monthly replenishment.' AS description_en,
        'إدارة دورة حياة بطاقات الائتمان المؤسسية' AS description_ar,
        'FINANCE'        AS category,
        20               AS display_order,
        'Y'              AS is_active,
        'N'              AS is_new_tab,
        'N'              AS is_admin_only
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
PROMPT Module registered: CREDIT_CARDS (App 202)

-- =============================================================================
-- 2. ROLE — CC_ADMIN
-- =============================================================================
MERGE INTO dct_roles tgt
USING (
    SELECT
        'CC_ADMIN'          AS role_code,
        'Credit Card Admin' AS role_name_en,
        'مدير بطاقات الائتمان' AS role_name_ar,
        'MODULE'            AS role_type,
        (SELECT module_id FROM dct_modules WHERE module_code = 'CREDIT_CARDS') AS module_id,
        'Full access to all credit card records across all organizations; manages proxies, document requirements, and approval rules.' AS description_en,
        'Y'                 AS is_active,
        'N'                 AS is_system_role,
        10                  AS display_order
    FROM dual
) src ON (tgt.role_code = src.role_code)
WHEN NOT MATCHED THEN
    INSERT (role_code, role_name_en, role_name_ar, role_type, module_id,
            description_en, is_active, is_system_role, display_order)
    VALUES (src.role_code, src.role_name_en, src.role_name_ar, src.role_type, src.module_id,
            src.description_en, src.is_active, src.is_system_role, src.display_order)
WHEN MATCHED THEN
    UPDATE SET role_name_en = src.role_name_en,
               is_active    = src.is_active;

COMMIT;
PROMPT Role seeded: CC_ADMIN

-- =============================================================================
-- 3. PERMISSIONS + ROLE-PERMISSION MAP
-- =============================================================================
DECLARE
    v_module_id  dct_modules.module_id%TYPE;
    v_cc_role_id dct_roles.role_id%TYPE;

    TYPE t_perm IS RECORD (
        perm_code   dct_permissions.permission_code%TYPE,
        perm_name   dct_permissions.permission_name%TYPE,
        action_type dct_permissions.action_type%TYPE
    );
    TYPE t_perm_list IS TABLE OF t_perm;

    v_perms t_perm_list := t_perm_list(
        t_perm('CC.VIEW_OWN',             'View own credit card',                  'VIEW'),
        t_perm('CC.REQUEST_NEW',          'Request new credit card',               'CREATE'),
        t_perm('CC.REQUEST_CHANGE',       'Request card change (limit/replace/close)', 'EDIT'),
        t_perm('CC.VIEW_ALL',             'View all cards (admin)',                 'VIEW'),
        t_perm('CC.APPROVE',              'Approve or reject card requests',        'APPROVE'),
        t_perm('CC.MANAGE_DOC_REQ',       'Manage required documents per type',     'CONFIGURE'),
        t_perm('CC.MANAGE_PROXIES',       'Assign and revoke proxy submitters',     'CONFIGURE'),
        t_perm('CC.REPLENISHMENT_SUBMIT', 'Submit monthly replenishment',           'CREATE'),
        t_perm('CC.REPLENISHMENT_VIEW',   'View all replenishments (admin)',        'VIEW'),
        t_perm('CC.APPROVE_REPLENISHMENT','Approve or reject replenishments',       'APPROVE'),
        t_perm('CC.MODULE_SETTINGS',      'Configure credit card module settings',  'CONFIGURE'),
        t_perm('CC.APPROVAL_RULES',       'Configure approval workflows',           'CONFIGURE')
    );

    v_perm_id dct_permissions.permission_id%TYPE;
BEGIN
    SELECT module_id INTO v_module_id  FROM dct_modules WHERE module_code = 'CREDIT_CARDS';
    SELECT role_id   INTO v_cc_role_id FROM dct_roles   WHERE role_code   = 'CC_ADMIN';

    FOR i IN 1 .. v_perms.COUNT LOOP
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

        SELECT permission_id INTO v_perm_id
        FROM   dct_permissions WHERE permission_code = v_perms(i).perm_code;

        MERGE INTO dct_role_permissions rp
        USING (SELECT v_cc_role_id AS role_id, v_perm_id AS permission_id FROM dual) src
        ON    (rp.role_id = src.role_id AND rp.permission_id = src.permission_id)
        WHEN NOT MATCHED THEN
            INSERT (role_id, permission_id, granted_by)
            VALUES (v_cc_role_id, v_perm_id, 'SEED');
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Permissions seeded: ' || v_perms.COUNT || ' CC.* permissions granted to CC_ADMIN');
END;
/

-- =============================================================================
-- 4. MODULE SETTINGS
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
            'BANK_NAME', 'ADCB',
            'Bank Name',
            'Name of the issuing bank displayed on credit card records.',
            'TEXT', NULL, 'ADCB'
        ),
        t_setting(
            'BANK_APPROVAL_REQUIRED', 'Y',
            'Bank Approval Required',
            'Y = bank approval step fires in card request workflows. Change to N to skip the bank step.',
            'BOOLEAN', 'Y|N', 'Y'
        ),
        t_setting(
            'MAX_CARD_LIMIT_AED', NULL,
            'Maximum Card Limit (AED)',
            'Hard ceiling on the credit limit employees can request. Leave empty for no cap.',
            'NUMBER', NULL, NULL
        ),
        t_setting(
            'ALLOW_SELF_SERVICE_REQUEST', 'Y',
            'Allow Self-Service Requests',
            'Y = employees may raise their own new card and change requests. N = admin-only.',
            'BOOLEAN', 'Y|N', 'Y'
        ),
        t_setting(
            'REPLENISHMENT_DUE_DAY', '5',
            'Replenishment Due Day',
            'Day of the month by which the monthly credit card replenishment must be submitted (1–28).',
            'NUMBER', NULL, '5'
        ),
        t_setting(
            'REPLENISHMENT_GRACE_DAYS', '3',
            'Replenishment Grace Days',
            'Number of days after the due day before the replenishment is flagged as late.',
            'NUMBER', NULL, '3'
        ),
        t_setting(
            'REPLENISHMENT_LINES_REQUIRED', 'Y',
            'Require Expense Lines',
            'Y = replenishment must contain at least one expense line before it can be submitted.',
            'BOOLEAN', 'Y|N', 'Y'
        )
    );
BEGIN
    SELECT module_id INTO v_module_id FROM dct_modules WHERE module_code = 'CREDIT_CARDS';

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
            -- NOTE: setting_value is NOT updated on re-seed to preserve admin changes
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Module settings seeded: ' || v_settings.COUNT || ' CREDIT_CARDS settings');
END;
/

-- =============================================================================
-- 5. APPROVAL WORKFLOWS (DCT_APPROVAL_TEMPLATES + DCT_APPROVAL_STEPS)
--
--   Template A — CC_NEW_CARD_APPROVAL    (NEW_CARD)
--     Step 1: Manager         ALWAYS
--     Step 2: CC_ADMIN        ALWAYS
--     Step 3: CC_ADMIN (bank) CUSTOM — fires when BANK_APPROVAL_REQUIRED = Y
--
--   Template B — CC_CHANGE_APPROVAL      (INCREASE_LIMIT / DECREASE_LIMIT / REPLACEMENT)
--     Step 1: CC_ADMIN        ALWAYS
--     Step 2: CC_ADMIN (bank) CUSTOM — fires when BANK_APPROVAL_REQUIRED = Y
--
--   Template C — CC_CLOSE_APPROVAL       (CLOSE_CARD)
--     Step 1: CC_ADMIN        ALWAYS
--
--   Template D — CC_REPLENISHMENT_APPROVAL (REPLENISHMENT)
--     Step 1: CC_ADMIN        ALWAYS
-- =============================================================================
DECLARE
    v_module_id    dct_modules.module_id%TYPE;
    v_cc_role_id   dct_roles.role_id%TYPE;
    v_mgr_role_id  dct_roles.role_id%TYPE;

    v_tmpl_new_id   dct_approval_templates.template_id%TYPE;
    v_tmpl_chg_id   dct_approval_templates.template_id%TYPE;
    v_tmpl_cls_id   dct_approval_templates.template_id%TYPE;
    v_tmpl_rmb_id   dct_approval_templates.template_id%TYPE;

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
        p_amount_op     IN VARCHAR2  DEFAULT NULL,
        p_amount_thresh IN NUMBER    DEFAULT NULL,
        p_type_filter   IN VARCHAR2  DEFAULT NULL,
        p_custom        IN VARCHAR2  DEFAULT NULL
    ) IS
    BEGIN
        MERGE INTO dct_approval_steps s
        USING (SELECT p_template_id AS template_id,
                      p_seq         AS step_seq FROM dual) src
        ON    (s.template_id = src.template_id AND s.step_seq = src.step_seq)
        WHEN NOT MATCHED THEN
            INSERT (template_id, step_seq, step_name, step_type, required_role_id,
                    escalation_days, is_mandatory, allow_skip,
                    condition_type, amount_operator, amount_threshold,
                    type_filter, custom_condition)
            VALUES (p_template_id, p_seq, p_name, 'ROLE_BASED', p_role_id,
                    3, 'Y', 'N',
                    p_cond_type, p_amount_op, p_amount_thresh,
                    p_type_filter, p_custom)
        WHEN MATCHED THEN
            UPDATE SET step_name         = p_name,
                       required_role_id  = p_role_id,
                       condition_type    = p_cond_type,
                       amount_operator   = p_amount_op,
                       amount_threshold  = p_amount_thresh,
                       type_filter       = p_type_filter,
                       custom_condition  = p_custom;
    END;

BEGIN
    SELECT module_id INTO v_module_id  FROM dct_modules WHERE module_code = 'CREDIT_CARDS';
    SELECT role_id   INTO v_cc_role_id FROM dct_roles   WHERE role_code   = 'CC_ADMIN';

    BEGIN
        SELECT role_id INTO v_mgr_role_id FROM dct_roles WHERE role_code = 'MANAGER';
    EXCEPTION WHEN NO_DATA_FOUND THEN
        v_mgr_role_id := v_cc_role_id; -- fallback if platform seed not yet run
    END;

    -- ------------------------------------------------------------------
    -- Template A: New Card
    -- ------------------------------------------------------------------
    upsert_template(
        p_code         => 'CC_NEW_CARD_APPROVAL',
        p_name         => 'New Credit Card Approval',
        p_module_id    => v_module_id,
        p_request_type => 'NEW_CARD',
        p_desc         => 'Approval workflow for new credit card issuance requests.',
        p_id           => v_tmpl_new_id
    );

    upsert_step(v_tmpl_new_id, 10, 'Line Manager Approval',
                v_mgr_role_id, 'ALWAYS');

    upsert_step(v_tmpl_new_id, 20, 'CC Admin Review',
                v_cc_role_id, 'ALWAYS');

    upsert_step(v_tmpl_new_id, 30, 'Bank Approval',
                v_cc_role_id, 'CUSTOM',
                p_custom => 'BANK_APPROVAL_REQUIRED=Y');

    -- ------------------------------------------------------------------
    -- Template B: Card Changes (Limit change / Replacement)
    -- ------------------------------------------------------------------
    upsert_template(
        p_code         => 'CC_CHANGE_APPROVAL',
        p_name         => 'Credit Card Change Approval',
        p_module_id    => v_module_id,
        p_request_type => 'INCREASE_LIMIT,DECREASE_LIMIT,REPLACEMENT',
        p_desc         => 'Approval workflow for credit limit changes and card replacement requests.',
        p_id           => v_tmpl_chg_id
    );

    upsert_step(v_tmpl_chg_id, 10, 'CC Admin Review',
                v_cc_role_id, 'ALWAYS');

    upsert_step(v_tmpl_chg_id, 20, 'Bank Approval',
                v_cc_role_id, 'CUSTOM',
                p_custom => 'BANK_APPROVAL_REQUIRED=Y');

    -- ------------------------------------------------------------------
    -- Template C: Card Closure
    -- ------------------------------------------------------------------
    upsert_template(
        p_code         => 'CC_CLOSE_APPROVAL',
        p_name         => 'Credit Card Closure Approval',
        p_module_id    => v_module_id,
        p_request_type => 'CLOSE_CARD',
        p_desc         => 'Approval workflow for credit card closure requests.',
        p_id           => v_tmpl_cls_id
    );

    upsert_step(v_tmpl_cls_id, 10, 'CC Admin Review',
                v_cc_role_id, 'ALWAYS');

    -- ------------------------------------------------------------------
    -- Template D: Monthly Replenishment
    -- ------------------------------------------------------------------
    upsert_template(
        p_code         => 'CC_REPLENISHMENT_APPROVAL',
        p_name         => 'Monthly Replenishment Approval',
        p_module_id    => v_module_id,
        p_request_type => 'REPLENISHMENT',
        p_desc         => 'Approval workflow for monthly credit card expense replenishment submissions.',
        p_id           => v_tmpl_rmb_id
    );

    upsert_step(v_tmpl_rmb_id, 10, 'CC Admin Review',
                v_cc_role_id, 'ALWAYS');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Approval workflows seeded: 4 templates, 9 steps');
END;
/

-- =============================================================================
-- 6. DEFAULT DOCUMENT REQUIREMENTS
-- =============================================================================
DECLARE
    v_admin_id NUMBER;

    PROCEDURE add_doc_req(
        p_type VARCHAR2, p_name VARCHAR2, p_mand CHAR, p_seq NUMBER
    ) IS
    BEGIN
        MERGE INTO dct_cc_doc_requirements t
        USING (SELECT p_type AS request_type, p_name AS document_name FROM dual) s
        ON (t.request_type = s.request_type AND t.document_name = s.document_name)
        WHEN NOT MATCHED THEN
            INSERT (request_type, document_name, is_mandatory, is_active, display_seq,
                    created_by, updated_by)
            VALUES (p_type, p_name, p_mand, 'Y', p_seq, v_admin_id, v_admin_id);
    END;

BEGIN
    BEGIN
        SELECT user_id INTO v_admin_id FROM dct_users WHERE username = 'ADMIN' AND ROWNUM = 1;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        SELECT user_id INTO v_admin_id FROM dct_users WHERE ROWNUM = 1;
    END;

    add_doc_req('NEW_CARD',       'Emirates ID Copy',         'Y', 10);
    add_doc_req('NEW_CARD',       'Passport Copy',            'Y', 20);
    add_doc_req('NEW_CARD',       'HR Authorisation Letter',  'Y', 30);
    add_doc_req('NEW_CARD',       'Bank Account Details',     'N', 40);

    add_doc_req('INCREASE_LIMIT', 'Justification Letter',     'Y', 10);
    add_doc_req('INCREASE_LIMIT', 'Manager Approval Email',   'Y', 20);

    add_doc_req('DECREASE_LIMIT', 'Justification Letter',     'N', 10);

    add_doc_req('CLOSE_CARD',     'Clearance Letter',         'Y', 10);
    add_doc_req('CLOSE_CARD',     'Final Statement Copy',     'Y', 20);

    add_doc_req('REPLACEMENT',    'Lost Card Police Report',  'N', 10);
    add_doc_req('REPLACEMENT',    'Damaged Card (physical)',  'N', 20);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Document requirements seeded: 11 entries across 5 request types');
END;
/

PROMPT
PROMPT === 03_cc_seed.sql complete ===
PROMPT Module, role, permissions, settings, approval templates, document requirements seeded.
