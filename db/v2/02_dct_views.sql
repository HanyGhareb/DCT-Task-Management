-- =============================================================================
-- i-Finance V2 — Views
-- File    : 02_dct_views.sql
-- Schema  : PROD
-- Sprint  : 1 — Foundation
-- =============================================================================
-- Sections:
--   A. Utility views used by V2 APEX pages
--   B. Backward-compatibility views (simulate legacy table structures)
-- =============================================================================

-- =============================================================================
-- A. UTILITY VIEWS
-- =============================================================================

-- ----------------------------------------------------------------------------
-- V_DCT_USER_ACTIVE_ROLES
-- Current, non-expired, active role assignments per user.
-- Use in APEX authorization schemes and post-login computations.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_dct_user_active_roles AS
SELECT
    u.user_id,
    u.username,
    u.display_name,
    u.display_name_ar,
    u.is_external,
    r.role_id,
    r.role_code,
    r.role_name_en,
    r.role_name_ar,
    r.role_type,
    m.module_code,
    ur.org_scope_id,
    ur.start_date,
    ur.end_date,
    ur.user_role_id
FROM  dct_user_roles     ur
JOIN  dct_users          u  ON ur.user_id = u.user_id
JOIN  dct_roles          r  ON ur.role_id = r.role_id
LEFT JOIN dct_modules    m  ON r.module_id = m.module_id
WHERE ur.is_active = 'Y'
  AND u.is_active  = 'Y'
  AND r.is_active  = 'Y'
  AND TRUNC(SYSDATE) >= TRUNC(ur.start_date)
  AND (ur.end_date IS NULL OR TRUNC(SYSDATE) <= TRUNC(ur.end_date));

-- ----------------------------------------------------------------------------
-- V_DCT_USER_PERMISSIONS
-- Flattened permission codes per active user (via roles).
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_dct_user_permissions AS
SELECT DISTINCT
    u.user_id,
    u.username,
    p.permission_code,
    p.action_type,
    m.module_code
FROM  dct_user_roles      ur
JOIN  dct_users           u  ON ur.user_id      = u.user_id
JOIN  dct_roles           r  ON ur.role_id      = r.role_id
JOIN  dct_role_permissions rp ON rp.role_id     = r.role_id
JOIN  dct_permissions     p  ON rp.permission_id = p.permission_id
LEFT JOIN dct_modules     m  ON p.module_id     = m.module_id
WHERE ur.is_active  = 'Y'
  AND u.is_active   = 'Y'
  AND r.is_active   = 'Y'
  AND p.is_active   = 'Y'
  AND TRUNC(SYSDATE) >= TRUNC(ur.start_date)
  AND (ur.end_date IS NULL OR TRUNC(SYSDATE) <= TRUNC(ur.end_date));

-- ----------------------------------------------------------------------------
-- V_DCT_MODULE_ACCESS
-- Modules each active user is authorised to access.
-- Drives the App Launcher cards on the home page.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_dct_module_access AS
SELECT DISTINCT
    u.user_id,
    u.username,
    mo.module_id,
    mo.module_code,
    mo.module_name_en,
    mo.module_name_ar,
    mo.icon_class,
    mo.icon_color,
    mo.bg_color,
    mo.description_en,
    mo.description_ar,
    mo.category,
    mo.apex_app_id,
    mo.apex_page_id,
    mo.app_url,
    mo.is_new_tab,
    mo.display_order,
    mr.access_level
FROM  dct_user_roles    ur
JOIN  dct_users         u  ON ur.user_id   = u.user_id
JOIN  dct_roles         r  ON ur.role_id   = r.role_id
JOIN  dct_module_roles  mr ON mr.role_id   = r.role_id
JOIN  dct_modules       mo ON mr.module_id = mo.module_id
WHERE ur.is_active  = 'Y'
  AND u.is_active   = 'Y'
  AND r.is_active   = 'Y'
  AND mo.is_active  = 'Y'
  AND TRUNC(SYSDATE) >= TRUNC(ur.start_date)
  AND (ur.end_date IS NULL OR TRUNC(SYSDATE) <= TRUNC(ur.end_date));

-- ----------------------------------------------------------------------------
-- V_DCT_PENDING_APPROVALS
-- All approval instances waiting for a specific user's action.
-- Respects delegations: includes requests delegated to the user.
-- Used on "My Pending Approvals" page and notification count.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_dct_pending_approvals AS
SELECT
    ai.instance_id,
    ai.source_module,
    ai.source_record_id,
    ai.source_record_ref,
    ai.overall_status,
    ai.submitted_at,
    ai.current_step_seq,
    aps.step_name,
    aps.step_type,
    aps.escalation_days,
    ai.submitted_at + aps.escalation_days AS escalation_due,
    CASE WHEN SYSDATE > ai.submitted_at + aps.escalation_days THEN 'Y' ELSE 'N' END AS is_overdue,
    u_sub.display_name   AS submitted_by_name,
    u_sub.display_name_ar AS submitted_by_name_ar,
    -- The user who needs to act
    CASE aps.step_type
        WHEN 'USER_SPECIFIC' THEN aps.specific_user_id
        ELSE NULL
    END                  AS required_user_id,
    aps.required_role_id,
    r.role_code          AS required_role_code,
    at2.template_code,
    at2.template_name,
    mo.module_name_en,
    mo.module_name_ar
FROM  dct_approval_instances ai
JOIN  dct_approval_templates at2 ON ai.template_id     = at2.template_id
JOIN  dct_approval_steps     aps ON aps.template_id    = ai.template_id
                                 AND aps.step_seq       = ai.current_step_seq
JOIN  dct_users              u_sub ON ai.submitted_by  = u_sub.user_id
LEFT JOIN dct_roles          r  ON aps.required_role_id = r.role_id
LEFT JOIN dct_modules        mo ON at2.module_id        = mo.module_id
WHERE ai.overall_status = 'PENDING';

-- ----------------------------------------------------------------------------
-- V_DCT_ACTIVE_DELEGATIONS
-- Delegations currently in effect (today falls in the date range).
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_dct_active_delegations AS
SELECT
    d.delegation_id,
    d.delegator_id,
    u_from.username        AS delegator_username,
    u_from.display_name    AS delegator_name,
    d.delegate_id,
    u_to.username          AS delegate_username,
    u_to.display_name      AS delegate_name,
    d.scope,
    d.role_id,
    r.role_code,
    d.module_id,
    m.module_code,
    d.start_date,
    d.end_date,
    d.reason
FROM  dct_delegations  d
JOIN  dct_users        u_from ON d.delegator_id = u_from.user_id
JOIN  dct_users        u_to   ON d.delegate_id  = u_to.user_id
LEFT JOIN dct_roles    r      ON d.role_id      = r.role_id
LEFT JOIN dct_modules  m      ON d.module_id    = m.module_id
WHERE d.status     = 'ACTIVE'
  AND TRUNC(SYSDATE) BETWEEN TRUNC(d.start_date) AND TRUNC(d.end_date);

-- ----------------------------------------------------------------------------
-- V_DCT_USER_DIRECTORY
-- Full user profile view for display in the UI (no sensitive columns).
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_dct_user_directory AS
SELECT
    u.user_id,
    u.username,
    u.email,
    u.display_name,
    u.display_name_ar,
    u.first_name,
    u.last_name,
    u.job_title_en,
    u.job_title_ar,
    u.employee_number,
    u.person_id,
    u.mobile,
    u.photo_url,
    u.color_hex,
    u.language_pref,
    u.auth_method,
    u.is_active,
    u.is_external,
    u.last_login_at,
    u.created_at,
    o.org_name_en   AS org_name,
    o.org_name_ar,
    o.org_code,
    o.org_type
FROM  dct_users         u
LEFT JOIN dct_organizations o ON u.org_id = o.org_id;

-- ----------------------------------------------------------------------------
-- V_DCT_ORG_TREE
-- Hierarchical organisation tree with computed level and breadcrumb path.
-- Use with APEX Tree region or Interactive Report.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_dct_org_tree AS
SELECT
    o.org_id,
    o.org_code,
    o.org_name_en,
    o.org_name_ar,
    o.org_type,
    o.parent_org_id,
    o.level_no,
    o.full_path,
    o.is_active,
    o.display_order,
    p.org_name_en AS parent_name,
    u.display_name AS head_user_name,
    u.email        AS head_user_email,
    (SELECT COUNT(*) FROM dct_users uu WHERE uu.org_id = o.org_id AND uu.is_active = 'Y') AS member_count
FROM  dct_organizations o
LEFT JOIN dct_organizations p ON o.parent_org_id = p.org_id
LEFT JOIN dct_users         u ON o.head_user_id  = u.user_id;

-- =============================================================================
-- B. BACKWARD-COMPATIBILITY VIEWS
-- These simulate legacy table structures so existing domain apps keep working
-- during the phased migration. Remove after all apps are migrated.
-- =============================================================================

-- ----------------------------------------------------------------------------
-- dct_data_access_assignment  (was a table; now a view over DCT_USER_ROLES)
-- Existing apps query: entity_type_id='ROLE', status='A', user_id=:APP_USER
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW dct_data_access_assignment AS
SELECT
    ur.user_role_id                         AS assignment_id,
    u.username                              AS user_id,
    u.person_id,
    'ROLE'                                  AS entity_type_id,
    r.role_id                               AS entity_id,
    r.role_code,
    r.role_name_en                          AS role_name,
    ur.start_date,
    ur.end_date,
    ur.org_scope_id,
    CASE
        WHEN ur.is_active = 'Y'
         AND TRUNC(SYSDATE) >= TRUNC(ur.start_date)
         AND (ur.end_date IS NULL OR TRUNC(SYSDATE) <= TRUNC(ur.end_date))
        THEN 'A'
        ELSE 'I'
    END                                     AS status,
    ur.created_at,
    ur.updated_at
FROM  dct_user_roles  ur
JOIN  dct_users       u ON ur.user_id = u.user_id
JOIN  dct_roles       r ON ur.role_id = r.role_id;

-- ----------------------------------------------------------------------------
-- roles  (was a table in the task-management schema)
-- Existing task management app queries: role_code, module_code, is_active
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW roles AS
SELECT
    r.role_id,
    r.role_code,
    r.role_name_en   AS role_name,
    r.role_name_ar,
    m.module_code,
    r.role_type,
    r.is_system_role,
    r.is_active,
    r.display_order,
    r.description_en AS description,
    r.created_at,
    r.updated_at
FROM  dct_roles       r
LEFT JOIN dct_modules m ON r.module_id = m.module_id;

-- End of 02_dct_views.sql
