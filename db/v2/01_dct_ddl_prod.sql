-- =============================================================================
-- i-Finance V2 — Master Schema DDL
-- File    : 01_dct_ddl.sql
-- Schema  : PROD
-- DB      : Oracle 23ai
-- Prefix  : DCT_ (i-Finance Workspace)
-- Sprint  : 1 — Foundation
-- =============================================================================
-- Prerequisites:
--   GRANT EXECUTE ON DBMS_CRYPTO TO PROD;
--   GRANT CREATE TRIGGER, CREATE TABLE, CREATE VIEW, CREATE SEQUENCE TO PROD;
-- =============================================================================
-- Run order: 01_dct_ddl → 02_dct_views → 03_dct_auth_pkg → 04_dct_seed
-- To reinstall clean: uncomment the DROP section below and run first.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- CLEAN REINSTALL (uncomment to drop all objects before re-creating)
-- -----------------------------------------------------------------------------
/*
DROP TABLE PROD.dct_announcements        CASCADE CONSTRAINTS PURGE;
DROP TABLE PROD.dct_notifications        CASCADE CONSTRAINTS PURGE;
DROP TABLE PROD.dct_sessions             CASCADE CONSTRAINTS PURGE;
DROP TABLE PROD.dct_audit_log            CASCADE CONSTRAINTS PURGE;
DROP TABLE PROD.dct_lookup_values        CASCADE CONSTRAINTS PURGE;
DROP TABLE PROD.dct_lookup_categories    CASCADE CONSTRAINTS PURGE;
DROP TABLE PROD.dct_system_settings      CASCADE CONSTRAINTS PURGE;
DROP TABLE PROD.dct_delegations          CASCADE CONSTRAINTS PURGE;
DROP TABLE PROD.dct_approval_actions     CASCADE CONSTRAINTS PURGE;
DROP TABLE PROD.dct_approval_instances   CASCADE CONSTRAINTS PURGE;
DROP TABLE PROD.dct_approval_steps       CASCADE CONSTRAINTS PURGE;
DROP TABLE PROD.dct_approval_templates   CASCADE CONSTRAINTS PURGE;
DROP TABLE PROD.dct_menu_items           CASCADE CONSTRAINTS PURGE;
DROP TABLE PROD.dct_menus                CASCADE CONSTRAINTS PURGE;
DROP TABLE PROD.dct_module_roles         CASCADE CONSTRAINTS PURGE;
DROP TABLE PROD.dct_user_roles           CASCADE CONSTRAINTS PURGE;
DROP TABLE PROD.dct_role_permissions     CASCADE CONSTRAINTS PURGE;
DROP TABLE PROD.dct_permissions          CASCADE CONSTRAINTS PURGE;
DROP TABLE PROD.dct_roles                CASCADE CONSTRAINTS PURGE;
DROP TABLE PROD.dct_modules              CASCADE CONSTRAINTS PURGE;
DROP TABLE PROD.dct_user_preferences     CASCADE CONSTRAINTS PURGE;
DROP TABLE PROD.dct_user_orgs            CASCADE CONSTRAINTS PURGE;
ALTER TABLE PROD.dct_organizations DROP CONSTRAINT fk_dct_org_head;
DROP TABLE PROD.dct_users                CASCADE CONSTRAINTS PURGE;
DROP TABLE PROD.dct_organizations        CASCADE CONSTRAINTS PURGE;
*/

-- =============================================================================
-- 1. DCT_ORGANIZATIONS
--    Created before DCT_USERS because users reference it.
--    head_user_id FK added after DCT_USERS is created.
-- =============================================================================
CREATE TABLE PROD.dct_organizations (
    org_id          NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    org_code        VARCHAR2(50)   NOT NULL,
    org_name_en     VARCHAR2(200)  NOT NULL,
    org_name_ar     VARCHAR2(200),
    org_type        VARCHAR2(30),                            -- DIVISION | SECTION | UNIT | DEPARTMENT
    parent_org_id   NUMBER,
    head_user_id    NUMBER,                                  -- FK added after PROD.dct_users
    level_no        NUMBER         DEFAULT 1,
    full_path       VARCHAR2(1000),                          -- e.g. Finance > Payables > AR
    is_active       VARCHAR2(1)    DEFAULT 'Y' NOT NULL,
    display_order   NUMBER         DEFAULT 0,
    created_by      VARCHAR2(100),
    created_at      TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by      VARCHAR2(100),
    updated_at      TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_org_code      UNIQUE      (org_code),
    CONSTRAINT chk_dct_org_active   CHECK       (is_active IN ('Y','N')),
    CONSTRAINT chk_dct_org_type     CHECK       (org_type IN ('DIVISION','SECTION','UNIT','DEPARTMENT') OR org_type IS NULL),
    CONSTRAINT fk_dct_org_parent    FOREIGN KEY (parent_org_id) REFERENCES PROD.dct_organizations(org_id)
);

CREATE INDEX ix_dct_org_parent   ON PROD.dct_organizations(parent_org_id);
CREATE INDEX ix_dct_org_active   ON PROD.dct_organizations(is_active);

-- =============================================================================
-- 2. DCT_USERS
-- =============================================================================
CREATE TABLE PROD.dct_users (
    user_id          NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username         VARCHAR2(100)  NOT NULL,
    email            VARCHAR2(255)  NOT NULL,
    display_name     VARCHAR2(200)  NOT NULL,
    display_name_ar  VARCHAR2(200),
    first_name       VARCHAR2(100),
    last_name        VARCHAR2(100),
    job_title_en     VARCHAR2(200),
    job_title_ar     VARCHAR2(200),
    employee_number  VARCHAR2(50),
    person_id        NUMBER,                                 -- Numeric HR key (PROD.dct_employees)
    mobile           VARCHAR2(20),
    photo_url        VARCHAR2(500),
    color_hex        VARCHAR2(7)    DEFAULT '#0076CE',
    language_pref    VARCHAR2(10)   DEFAULT 'EN'   NOT NULL,
    org_id           NUMBER,                                 -- Primary organisation
    password_hash    VARCHAR2(500),                          -- SHA-512 hex; NULL for non-DB auth
    auth_method      VARCHAR2(20)   DEFAULT 'DB'   NOT NULL, -- DB | LDAP | OCI_IAM | SAML
    is_active        VARCHAR2(1)    DEFAULT 'Y'    NOT NULL,
    is_external      VARCHAR2(1)    DEFAULT 'N'    NOT NULL,
    deactivated_at   TIMESTAMP,
    deactivation_reason VARCHAR2(500),
    last_login_at    TIMESTAMP,
    created_by       VARCHAR2(100),
    created_at       TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by       VARCHAR2(100),
    updated_at       TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_user_username  UNIQUE      (username),
    CONSTRAINT uq_dct_user_email     UNIQUE      (email),
    CONSTRAINT chk_dct_user_active   CHECK       (is_active IN ('Y','N')),
    CONSTRAINT chk_dct_user_ext      CHECK       (is_external IN ('Y','N')),
    CONSTRAINT chk_dct_user_lang     CHECK       (language_pref IN ('EN','AR')),
    CONSTRAINT chk_dct_user_auth     CHECK       (auth_method IN ('DB','LDAP','OCI_IAM','SAML')),
    CONSTRAINT fk_dct_user_org       FOREIGN KEY (org_id) REFERENCES PROD.dct_organizations(org_id)
);

-- Deferred FK: org head references user
ALTER TABLE PROD.dct_organizations
    ADD CONSTRAINT fk_dct_org_head FOREIGN KEY (head_user_id) REFERENCES PROD.dct_users(user_id);

CREATE UNIQUE INDEX uix_dct_user_username ON PROD.dct_users(UPPER(username));
CREATE INDEX        ix_dct_user_active    ON PROD.dct_users(is_active);
CREATE INDEX        ix_dct_user_org       ON PROD.dct_users(org_id);
CREATE INDEX        ix_dct_user_person    ON PROD.dct_users(person_id);
CREATE INDEX        ix_dct_user_empno     ON PROD.dct_users(employee_number);

-- =============================================================================
-- 3. DCT_USER_PREFERENCES
-- =============================================================================
CREATE TABLE PROD.dct_user_preferences (
    pref_id     NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id     NUMBER        NOT NULL,
    pref_key    VARCHAR2(100) NOT NULL,
    pref_value  VARCHAR2(4000),
    created_at  TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
    updated_at  TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_pref           UNIQUE      (user_id, pref_key),
    CONSTRAINT fk_dct_pref_user      FOREIGN KEY (user_id) REFERENCES PROD.dct_users(user_id) ON DELETE CASCADE
);

-- =============================================================================
-- 4. DCT_USER_ORGS  (User → Organisation assignments)
-- =============================================================================
CREATE TABLE PROD.dct_user_orgs (
    user_org_id      NUMBER       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id          NUMBER       NOT NULL,
    org_id           NUMBER       NOT NULL,
    assignment_type  VARCHAR2(20) DEFAULT 'SECONDARY' NOT NULL, -- PRIMARY | SECONDARY | ACTING
    start_date       DATE         DEFAULT SYSDATE NOT NULL,
    end_date         DATE,
    assigned_by      VARCHAR2(100),
    created_by       VARCHAR2(100),
    created_at       TIMESTAMP    DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by       VARCHAR2(100),
    updated_at       TIMESTAMP    DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_user_org       UNIQUE      (user_id, org_id, assignment_type),
    CONSTRAINT chk_dct_uorg_type     CHECK       (assignment_type IN ('PRIMARY','SECONDARY','ACTING')),
    CONSTRAINT chk_dct_uorg_dates    CHECK       (end_date IS NULL OR end_date >= start_date),
    CONSTRAINT fk_dct_uorg_user      FOREIGN KEY (user_id) REFERENCES PROD.dct_users(user_id),
    CONSTRAINT fk_dct_uorg_org       FOREIGN KEY (org_id)  REFERENCES PROD.dct_organizations(org_id)
);

CREATE INDEX ix_dct_uorg_user ON PROD.dct_user_orgs(user_id);
CREATE INDEX ix_dct_uorg_org  ON PROD.dct_user_orgs(org_id);

-- =============================================================================
-- 5. DCT_MODULES  (Registered APEX apps and external modules)
-- =============================================================================
CREATE TABLE PROD.dct_modules (
    module_id        NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    module_code      VARCHAR2(100)  NOT NULL,
    module_name_en   VARCHAR2(200)  NOT NULL,
    module_name_ar   VARCHAR2(200),
    module_type      VARCHAR2(30)   DEFAULT 'APEX_APP' NOT NULL, -- APEX_APP | EXTERNAL_URL | INTERNAL
    apex_app_id      NUMBER,
    apex_page_id     NUMBER         DEFAULT 1,
    app_url          VARCHAR2(500),                              -- Override URL
    icon_class       VARCHAR2(100)  DEFAULT 'fa-th-large',
    icon_color       VARCHAR2(7)    DEFAULT '#0076CE',
    bg_color         VARCHAR2(7)    DEFAULT '#F0F4F8',
    description_en   VARCHAR2(1000),
    description_ar   VARCHAR2(1000),
    category         VARCHAR2(50),                              -- HR | BUDGET | CWIP | PROCUREMENT | ADMIN | CORE
    display_order    NUMBER         DEFAULT 0,
    is_active        VARCHAR2(1)    DEFAULT 'Y' NOT NULL,
    is_new_tab       VARCHAR2(1)    DEFAULT 'N' NOT NULL,
    is_admin_only    VARCHAR2(1)    DEFAULT 'N' NOT NULL,
    created_by       VARCHAR2(100),
    created_at       TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by       VARCHAR2(100),
    updated_at       TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_module_code    UNIQUE (module_code),
    CONSTRAINT chk_dct_mod_active    CHECK  (is_active IN ('Y','N')),
    CONSTRAINT chk_dct_mod_newtab    CHECK  (is_new_tab IN ('Y','N')),
    CONSTRAINT chk_dct_mod_admin     CHECK  (is_admin_only IN ('Y','N')),
    CONSTRAINT chk_dct_mod_type      CHECK  (module_type IN ('APEX_APP','EXTERNAL_URL','INTERNAL'))
);

CREATE INDEX ix_dct_module_category ON PROD.dct_modules(category);
CREATE INDEX ix_dct_module_active   ON PROD.dct_modules(is_active);

-- =============================================================================
-- 6. DCT_ROLES
-- =============================================================================
CREATE TABLE PROD.dct_roles (
    role_id          NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    role_code        VARCHAR2(100)  NOT NULL,
    role_name_en     VARCHAR2(200)  NOT NULL,
    role_name_ar     VARCHAR2(200),
    role_type        VARCHAR2(20)   DEFAULT 'MODULE' NOT NULL, -- SYSTEM | MODULE | DATA
    module_id        NUMBER,                                    -- NULL = platform-wide
    description_en   VARCHAR2(1000),
    description_ar   VARCHAR2(1000),
    is_system_role   VARCHAR2(1)    DEFAULT 'N' NOT NULL,      -- System roles cannot be deleted
    is_active        VARCHAR2(1)    DEFAULT 'Y' NOT NULL,
    display_order    NUMBER         DEFAULT 0,
    created_by       VARCHAR2(100),
    created_at       TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by       VARCHAR2(100),
    updated_at       TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_role_code      UNIQUE      (role_code),
    CONSTRAINT chk_dct_role_active   CHECK       (is_active IN ('Y','N')),
    CONSTRAINT chk_dct_role_system   CHECK       (is_system_role IN ('Y','N')),
    CONSTRAINT chk_dct_role_type     CHECK       (role_type IN ('SYSTEM','MODULE','DATA')),
    CONSTRAINT fk_dct_role_module    FOREIGN KEY (module_id) REFERENCES PROD.dct_modules(module_id)
);

CREATE INDEX ix_dct_role_module ON PROD.dct_roles(module_id);
CREATE INDEX ix_dct_role_type   ON PROD.dct_roles(role_type);

-- =============================================================================
-- 7. DCT_PERMISSIONS
-- =============================================================================
CREATE TABLE PROD.dct_permissions (
    permission_id    NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    permission_code  VARCHAR2(200)  NOT NULL,
    permission_name  VARCHAR2(200)  NOT NULL,
    permission_name_ar VARCHAR2(200),
    module_id        NUMBER,
    action_type      VARCHAR2(30)   NOT NULL, -- VIEW|CREATE|EDIT|DELETE|APPROVE|EXPORT|CONFIGURE|ADMIN
    description_en   VARCHAR2(1000),
    description_ar   VARCHAR2(1000),
    is_active        VARCHAR2(1)    DEFAULT 'Y' NOT NULL,
    created_by       VARCHAR2(100),
    created_at       TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by       VARCHAR2(100),
    updated_at       TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_perm_code      UNIQUE (permission_code),
    CONSTRAINT chk_dct_perm_active   CHECK  (is_active IN ('Y','N')),
    CONSTRAINT chk_dct_perm_action   CHECK  (action_type IN ('VIEW','CREATE','EDIT','DELETE','APPROVE','EXPORT','CONFIGURE','ADMIN')),
    CONSTRAINT fk_dct_perm_module    FOREIGN KEY (module_id) REFERENCES PROD.dct_modules(module_id)
);

CREATE INDEX ix_dct_perm_module  ON PROD.dct_permissions(module_id);
CREATE INDEX ix_dct_perm_action  ON PROD.dct_permissions(action_type);

-- =============================================================================
-- 8. DCT_ROLE_PERMISSIONS
-- =============================================================================
CREATE TABLE PROD.dct_role_permissions (
    rp_id            NUMBER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    role_id          NUMBER      NOT NULL,
    permission_id    NUMBER      NOT NULL,
    granted_by       VARCHAR2(100),
    granted_at       TIMESTAMP   DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_rp             UNIQUE      (role_id, permission_id),
    CONSTRAINT fk_dct_rp_role        FOREIGN KEY (role_id)       REFERENCES PROD.dct_roles(role_id),
    CONSTRAINT fk_dct_rp_perm        FOREIGN KEY (permission_id) REFERENCES PROD.dct_permissions(permission_id)
);

CREATE INDEX ix_dct_rp_role ON PROD.dct_role_permissions(role_id);
CREATE INDEX ix_dct_rp_perm ON PROD.dct_role_permissions(permission_id);

-- =============================================================================
-- 9. DCT_USER_ROLES  (Core RBAC assignment table)
-- =============================================================================
CREATE TABLE PROD.dct_user_roles (
    user_role_id     NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id          NUMBER        NOT NULL,
    role_id          NUMBER        NOT NULL,
    org_scope_id     NUMBER,                                     -- NULL = all orgs; set = scoped to one org
    start_date       DATE          DEFAULT SYSDATE NOT NULL,
    end_date         DATE,                                       -- NULL = indefinite
    is_active        VARCHAR2(1)   DEFAULT 'Y' NOT NULL,
    assigned_by      VARCHAR2(100),
    reason           VARCHAR2(500),
    created_by       VARCHAR2(100),
    created_at       TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by       VARCHAR2(100),
    updated_at       TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_dct_ur_active     CHECK       (is_active IN ('Y','N')),
    CONSTRAINT chk_dct_ur_dates      CHECK       (end_date IS NULL OR end_date >= start_date),
    CONSTRAINT fk_dct_ur_user        FOREIGN KEY (user_id)      REFERENCES PROD.dct_users(user_id),
    CONSTRAINT fk_dct_ur_role        FOREIGN KEY (role_id)      REFERENCES PROD.dct_roles(role_id),
    CONSTRAINT fk_dct_ur_org_scope   FOREIGN KEY (org_scope_id) REFERENCES PROD.dct_organizations(org_id)
);

CREATE INDEX ix_dct_ur_user    ON PROD.dct_user_roles(user_id, is_active);
CREATE INDEX ix_dct_ur_role    ON PROD.dct_user_roles(role_id);
CREATE INDEX ix_dct_ur_dates   ON PROD.dct_user_roles(start_date, end_date);

-- =============================================================================
-- 10. DCT_MODULE_ROLES  (Which roles can access which modules)
-- =============================================================================
CREATE TABLE PROD.dct_module_roles (
    mr_id            NUMBER       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    module_id        NUMBER       NOT NULL,
    role_id          NUMBER       NOT NULL,
    access_level     VARCHAR2(20) DEFAULT 'FULL' NOT NULL,  -- FULL | READ_ONLY
    created_by       VARCHAR2(100),
    created_at       TIMESTAMP    DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_mr             UNIQUE      (module_id, role_id),
    CONSTRAINT chk_dct_mr_access     CHECK       (access_level IN ('FULL','READ_ONLY')),
    CONSTRAINT fk_dct_mr_module      FOREIGN KEY (module_id) REFERENCES PROD.dct_modules(module_id),
    CONSTRAINT fk_dct_mr_role        FOREIGN KEY (role_id)   REFERENCES PROD.dct_roles(role_id)
);

-- =============================================================================
-- 11. DCT_MENUS
-- =============================================================================
CREATE TABLE PROD.dct_menus (
    menu_id          NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    module_id        NUMBER,
    menu_code        VARCHAR2(100) NOT NULL,
    menu_name_en     VARCHAR2(200) NOT NULL,
    menu_name_ar     VARCHAR2(200),
    menu_type        VARCHAR2(30)  NOT NULL,  -- APP_LAUNCHER | SIDEBAR | TOPBAR
    is_active        VARCHAR2(1)   DEFAULT 'Y' NOT NULL,
    created_by       VARCHAR2(100),
    created_at       TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by       VARCHAR2(100),
    updated_at       TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_menu_code   UNIQUE (menu_code),
    CONSTRAINT chk_dct_menu_act   CHECK  (is_active IN ('Y','N')),
    CONSTRAINT chk_dct_menu_type  CHECK  (menu_type IN ('APP_LAUNCHER','SIDEBAR','TOPBAR')),
    CONSTRAINT fk_dct_menu_module FOREIGN KEY (module_id) REFERENCES PROD.dct_modules(module_id)
);

-- =============================================================================
-- 12. DCT_MENU_ITEMS
-- =============================================================================
CREATE TABLE PROD.dct_menu_items (
    item_id          NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    menu_id          NUMBER         NOT NULL,
    parent_item_id   NUMBER,
    label_en         VARCHAR2(200)  NOT NULL,
    label_ar         VARCHAR2(200),
    icon_class       VARCHAR2(100),
    target_type      VARCHAR2(20)   NOT NULL,  -- APEX_PAGE | URL | MODULE | SEPARATOR
    apex_app_id      NUMBER,
    apex_page_id     NUMBER,
    target_url       VARCHAR2(500),
    required_perm_code VARCHAR2(200),
    display_order    NUMBER         DEFAULT 0,
    is_active        VARCHAR2(1)    DEFAULT 'Y' NOT NULL,
    created_by       VARCHAR2(100),
    created_at       TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by       VARCHAR2(100),
    updated_at       TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_dct_mitem_active  CHECK       (is_active IN ('Y','N')),
    CONSTRAINT chk_dct_mitem_type    CHECK       (target_type IN ('APEX_PAGE','URL','MODULE','SEPARATOR')),
    CONSTRAINT fk_dct_mitem_menu     FOREIGN KEY (menu_id)        REFERENCES PROD.dct_menus(menu_id),
    CONSTRAINT fk_dct_mitem_parent   FOREIGN KEY (parent_item_id) REFERENCES PROD.dct_menu_items(item_id)
);

CREATE INDEX ix_dct_mitem_menu   ON PROD.dct_menu_items(menu_id, display_order);
CREATE INDEX ix_dct_mitem_parent ON PROD.dct_menu_items(parent_item_id);

-- =============================================================================
-- 13. DCT_APPROVAL_TEMPLATES
-- =============================================================================
CREATE TABLE PROD.dct_approval_templates (
    template_id      NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    template_code    VARCHAR2(100)  NOT NULL,
    template_name    VARCHAR2(200)  NOT NULL,
    template_name_ar VARCHAR2(200),
    module_id        NUMBER,
    description_en   VARCHAR2(1000),
    description_ar   VARCHAR2(1000),
    is_sequential    VARCHAR2(1)    DEFAULT 'Y' NOT NULL,  -- Y=sequential | N=parallel (any approver)
    auto_approve_days NUMBER        DEFAULT 0,             -- 0 = no auto-approve
    is_active        VARCHAR2(1)    DEFAULT 'Y' NOT NULL,
    created_by       VARCHAR2(100),
    created_at       TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by       VARCHAR2(100),
    updated_at       TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_tmpl_code     UNIQUE (template_code),
    CONSTRAINT chk_dct_tmpl_seq     CHECK  (is_sequential IN ('Y','N')),
    CONSTRAINT chk_dct_tmpl_active  CHECK  (is_active IN ('Y','N')),
    CONSTRAINT fk_dct_tmpl_module   FOREIGN KEY (module_id) REFERENCES PROD.dct_modules(module_id)
);

-- =============================================================================
-- 14. DCT_APPROVAL_STEPS
-- =============================================================================
CREATE TABLE PROD.dct_approval_steps (
    step_id          NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    template_id      NUMBER         NOT NULL,
    step_seq         NUMBER         NOT NULL,
    step_name        VARCHAR2(200)  NOT NULL,
    step_name_ar     VARCHAR2(200),
    step_type        VARCHAR2(20)   NOT NULL,  -- ROLE_BASED | USER_SPECIFIC | ORG_HEAD
    required_role_id NUMBER,                   -- For ROLE_BASED
    specific_user_id NUMBER,                   -- For USER_SPECIFIC
    escalation_days  NUMBER         DEFAULT 3,
    escalate_role_id NUMBER,
    is_mandatory     VARCHAR2(1)    DEFAULT 'Y' NOT NULL,
    allow_skip       VARCHAR2(1)    DEFAULT 'N' NOT NULL,
    created_by       VARCHAR2(100),
    created_at       TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by       VARCHAR2(100),
    updated_at       TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_step           UNIQUE      (template_id, step_seq),
    CONSTRAINT chk_dct_step_type     CHECK       (step_type IN ('ROLE_BASED','USER_SPECIFIC','ORG_HEAD')),
    CONSTRAINT chk_dct_step_mand     CHECK       (is_mandatory IN ('Y','N')),
    CONSTRAINT chk_dct_step_skip     CHECK       (allow_skip IN ('Y','N')),
    CONSTRAINT fk_dct_step_tmpl      FOREIGN KEY (template_id)      REFERENCES PROD.dct_approval_templates(template_id),
    CONSTRAINT fk_dct_step_role      FOREIGN KEY (required_role_id) REFERENCES PROD.dct_roles(role_id),
    CONSTRAINT fk_dct_step_user      FOREIGN KEY (specific_user_id) REFERENCES PROD.dct_users(user_id),
    CONSTRAINT fk_dct_step_esc_role  FOREIGN KEY (escalate_role_id) REFERENCES PROD.dct_roles(role_id)
);

CREATE INDEX ix_dct_step_tmpl ON PROD.dct_approval_steps(template_id, step_seq);

-- =============================================================================
-- 15. DCT_APPROVAL_INSTANCES  (One row per submitted request needing approval)
-- =============================================================================
CREATE TABLE PROD.dct_approval_instances (
    instance_id       NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    template_id       NUMBER         NOT NULL,
    source_module     VARCHAR2(100)  NOT NULL,  -- Module code that owns the request
    source_record_id  NUMBER         NOT NULL,  -- PK of the requesting record
    source_record_ref VARCHAR2(200),            -- Human-readable ref e.g. "PRQ-2026-001"
    current_step_seq  NUMBER         DEFAULT 1,
    overall_status    VARCHAR2(20)   DEFAULT 'PENDING' NOT NULL, -- PENDING|APPROVED|REJECTED|CANCELLED|RETURNED
    submitted_by      NUMBER         NOT NULL,
    submitted_at      TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    completed_at      TIMESTAMP,
    last_action_at    TIMESTAMP,
    created_by        VARCHAR2(100),
    created_at        TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by        VARCHAR2(100),
    updated_at        TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_dct_inst_status   CHECK       (overall_status IN ('PENDING','APPROVED','REJECTED','CANCELLED','RETURNED')),
    CONSTRAINT fk_dct_inst_tmpl      FOREIGN KEY (template_id)  REFERENCES PROD.dct_approval_templates(template_id),
    CONSTRAINT fk_dct_inst_user      FOREIGN KEY (submitted_by) REFERENCES PROD.dct_users(user_id)
);

CREATE INDEX ix_dct_inst_module   ON PROD.dct_approval_instances(source_module, source_record_id);
CREATE INDEX ix_dct_inst_status   ON PROD.dct_approval_instances(overall_status);
CREATE INDEX ix_dct_inst_user     ON PROD.dct_approval_instances(submitted_by);
CREATE INDEX ix_dct_inst_step     ON PROD.dct_approval_instances(template_id, current_step_seq);

-- =============================================================================
-- 16. DCT_APPROVAL_ACTIONS  (Audit trail for every approve/reject action)
-- =============================================================================
CREATE TABLE PROD.dct_approval_actions (
    action_id        NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    instance_id      NUMBER         NOT NULL,
    step_id          NUMBER         NOT NULL,
    actioned_by      NUMBER         NOT NULL,
    actioned_at      TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    action           VARCHAR2(20)   NOT NULL,  -- APPROVED | REJECTED | RETURNED | DELEGATED | ESCALATED
    comments         VARCHAR2(4000),
    delegate_to      NUMBER,                   -- If action = DELEGATED
    is_escalation    VARCHAR2(1)    DEFAULT 'N' NOT NULL,
    --
    CONSTRAINT chk_dct_act_action    CHECK       (action IN ('APPROVED','REJECTED','RETURNED','DELEGATED','ESCALATED')),
    CONSTRAINT chk_dct_act_esc       CHECK       (is_escalation IN ('Y','N')),
    CONSTRAINT fk_dct_act_inst       FOREIGN KEY (instance_id)   REFERENCES PROD.dct_approval_instances(instance_id),
    CONSTRAINT fk_dct_act_step       FOREIGN KEY (step_id)       REFERENCES PROD.dct_approval_steps(step_id),
    CONSTRAINT fk_dct_act_user       FOREIGN KEY (actioned_by)   REFERENCES PROD.dct_users(user_id),
    CONSTRAINT fk_dct_act_delegate   FOREIGN KEY (delegate_to)   REFERENCES PROD.dct_users(user_id)
);

CREATE INDEX ix_dct_act_inst ON PROD.dct_approval_actions(instance_id);
CREATE INDEX ix_dct_act_user ON PROD.dct_approval_actions(actioned_by, actioned_at);

-- =============================================================================
-- 17. DCT_DELEGATIONS  (Delegation of authority for absence cover)
-- =============================================================================
CREATE TABLE PROD.dct_delegations (
    delegation_id    NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    delegator_id     NUMBER         NOT NULL,  -- User delegating their authority
    delegate_id      NUMBER         NOT NULL,  -- User receiving authority
    scope            VARCHAR2(20)   DEFAULT 'ALL_ROLES' NOT NULL,  -- ALL_ROLES | SPECIFIC_ROLE | MODULE
    role_id          NUMBER,                   -- If scope = SPECIFIC_ROLE
    module_id        NUMBER,                   -- If scope = MODULE
    start_date       DATE           NOT NULL,
    end_date         DATE           NOT NULL,
    reason           VARCHAR2(500),
    status           VARCHAR2(20)   DEFAULT 'ACTIVE' NOT NULL,  -- ACTIVE | CANCELLED | EXPIRED
    approved_by      VARCHAR2(100),
    approved_at      TIMESTAMP,
    created_by       VARCHAR2(100),
    created_at       TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by       VARCHAR2(100),
    updated_at       TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_dct_del_dates     CHECK       (end_date >= start_date),
    CONSTRAINT chk_dct_del_scope     CHECK       (scope IN ('ALL_ROLES','SPECIFIC_ROLE','MODULE')),
    CONSTRAINT chk_dct_del_status    CHECK       (status IN ('ACTIVE','CANCELLED','EXPIRED')),
    CONSTRAINT chk_dct_del_self      CHECK       (delegator_id != delegate_id),
    CONSTRAINT fk_dct_del_from       FOREIGN KEY (delegator_id) REFERENCES PROD.dct_users(user_id),
    CONSTRAINT fk_dct_del_to         FOREIGN KEY (delegate_id)  REFERENCES PROD.dct_users(user_id),
    CONSTRAINT fk_dct_del_role       FOREIGN KEY (role_id)      REFERENCES PROD.dct_roles(role_id),
    CONSTRAINT fk_dct_del_module     FOREIGN KEY (module_id)    REFERENCES PROD.dct_modules(module_id)
);

CREATE INDEX ix_dct_del_delegator ON PROD.dct_delegations(delegator_id, status);
CREATE INDEX ix_dct_del_delegate  ON PROD.dct_delegations(delegate_id,  status);
CREATE INDEX ix_dct_del_dates     ON PROD.dct_delegations(start_date, end_date);

-- =============================================================================
-- 18. DCT_LOOKUP_CATEGORIES
-- =============================================================================
CREATE TABLE PROD.dct_lookup_categories (
    category_id      NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_code    VARCHAR2(100)  NOT NULL,
    category_name_en VARCHAR2(200)  NOT NULL,
    category_name_ar VARCHAR2(200),
    module_id        NUMBER,                   -- NULL = platform-wide
    is_system        VARCHAR2(1)    DEFAULT 'N' NOT NULL,  -- System lookups are read-only
    is_active        VARCHAR2(1)    DEFAULT 'Y' NOT NULL,
    created_by       VARCHAR2(100),
    created_at       TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by       VARCHAR2(100),
    updated_at       TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_lcat_code     UNIQUE (category_code),
    CONSTRAINT chk_dct_lcat_system  CHECK  (is_system IN ('Y','N')),
    CONSTRAINT chk_dct_lcat_active  CHECK  (is_active IN ('Y','N')),
    CONSTRAINT fk_dct_lcat_module   FOREIGN KEY (module_id) REFERENCES PROD.dct_modules(module_id)
);

-- =============================================================================
-- 19. DCT_LOOKUP_VALUES
-- =============================================================================
CREATE TABLE PROD.dct_lookup_values (
    value_id         NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_id      NUMBER         NOT NULL,
    value_code       VARCHAR2(100)  NOT NULL,
    value_name_en    VARCHAR2(200)  NOT NULL,
    value_name_ar    VARCHAR2(200),
    tag              VARCHAR2(100),
    display_order    NUMBER         DEFAULT 0,
    is_default       VARCHAR2(1)    DEFAULT 'N' NOT NULL,
    is_active        VARCHAR2(1)    DEFAULT 'Y' NOT NULL,
    created_by       VARCHAR2(100),
    created_at       TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by       VARCHAR2(100),
    updated_at       TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_lval          UNIQUE (category_id, value_code),
    CONSTRAINT chk_dct_lval_def     CHECK  (is_default IN ('Y','N')),
    CONSTRAINT chk_dct_lval_active  CHECK  (is_active IN ('Y','N')),
    CONSTRAINT fk_dct_lval_cat      FOREIGN KEY (category_id) REFERENCES PROD.dct_lookup_categories(category_id)
);

CREATE INDEX ix_dct_lval_cat ON PROD.dct_lookup_values(category_id, display_order);

-- =============================================================================
-- 20. DCT_SYSTEM_SETTINGS
-- =============================================================================
CREATE TABLE PROD.dct_system_settings (
    setting_id       NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    setting_key      VARCHAR2(200)  NOT NULL,
    setting_value    VARCHAR2(4000),
    value_type       VARCHAR2(20)   DEFAULT 'STRING' NOT NULL,  -- STRING|NUMBER|BOOLEAN|JSON|DATE
    category         VARCHAR2(100),                              -- SECURITY|NOTIFICATIONS|UI|INTEGRATIONS
    description_en   VARCHAR2(1000),
    description_ar   VARCHAR2(1000),
    is_encrypted     VARCHAR2(1)    DEFAULT 'N' NOT NULL,
    is_system        VARCHAR2(1)    DEFAULT 'N' NOT NULL,        -- System keys cannot be deleted
    created_by       VARCHAR2(100),
    created_at       TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by       VARCHAR2(100),
    updated_at       TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_setting_key    UNIQUE (setting_key),
    CONSTRAINT chk_dct_set_type      CHECK  (value_type IN ('STRING','NUMBER','BOOLEAN','JSON','DATE')),
    CONSTRAINT chk_dct_set_enc       CHECK  (is_encrypted IN ('Y','N')),
    CONSTRAINT chk_dct_set_sys       CHECK  (is_system IN ('Y','N'))
);

-- =============================================================================
-- 21. DCT_AUDIT_LOG  (Centralised, append-only audit trail)
-- =============================================================================
CREATE TABLE PROD.dct_audit_log (
    log_id           NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    logged_at        TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    username         VARCHAR2(100),
    user_id          NUMBER,
    apex_session_id  VARCHAR2(100),
    module_code      VARCHAR2(100),
    action           VARCHAR2(50)   NOT NULL,  -- LOGIN|LOGOUT|CREATE|UPDATE|DELETE|
                                               -- ROLE_ASSIGN|ROLE_REVOKE|APPROVE|REJECT|
                                               -- ACCESS_DENIED|DEACTIVATE
    object_type      VARCHAR2(100),            -- Table/entity affected
    object_id        VARCHAR2(200),            -- PK or natural key of affected record
    object_ref       VARCHAR2(500),            -- Human-readable descriptor
    old_values       CLOB,                     -- JSON snapshot of before-state
    new_values       CLOB,                     -- JSON snapshot of after-state
    ip_address       VARCHAR2(50),
    user_agent       VARCHAR2(500),
    status           VARCHAR2(20)   DEFAULT 'SUCCESS' NOT NULL,  -- SUCCESS | FAILURE
    error_message    VARCHAR2(4000)
)
-- Partition by month for performance on high-volume audit data
PARTITION BY RANGE (logged_at) INTERVAL (NUMTOYMINTERVAL(1,'MONTH'))
(PARTITION p_initial VALUES LESS THAN (TIMESTAMP '2026-01-01 00:00:00'));

CREATE INDEX ix_dct_audit_user    ON PROD.dct_audit_log(user_id,     logged_at);
CREATE INDEX ix_dct_audit_action  ON PROD.dct_audit_log(action,      logged_at);
CREATE INDEX ix_dct_audit_module  ON PROD.dct_audit_log(module_code, logged_at);
CREATE INDEX ix_dct_audit_object  ON PROD.dct_audit_log(object_type, object_id);

-- =============================================================================
-- 22. DCT_SESSIONS
-- =============================================================================
CREATE TABLE PROD.dct_sessions (
    session_id       VARCHAR2(100)  NOT NULL PRIMARY KEY,  -- APEX session ID (v('APP_SESSION'))
    user_id          NUMBER,
    username         VARCHAR2(100)  NOT NULL,
    login_at         TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    last_activity_at TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    logout_at        TIMESTAMP,
    ip_address       VARCHAR2(50),
    user_agent       VARCHAR2(500),
    auth_method      VARCHAR2(20),
    is_active        VARCHAR2(1)    DEFAULT 'Y' NOT NULL,
    --
    CONSTRAINT chk_dct_sess_active  CHECK (is_active IN ('Y','N')),
    CONSTRAINT fk_dct_sess_user     FOREIGN KEY (user_id) REFERENCES PROD.dct_users(user_id)
);

CREATE INDEX ix_dct_sess_user   ON PROD.dct_sessions(user_id,  is_active);
CREATE INDEX ix_dct_sess_active ON PROD.dct_sessions(is_active, last_activity_at);

-- =============================================================================
-- 23. DCT_NOTIFICATIONS
-- =============================================================================
CREATE TABLE PROD.dct_notifications (
    notification_id   NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    recipient_user_id NUMBER         NOT NULL,
    module_code       VARCHAR2(100),
    notification_type VARCHAR2(50)   NOT NULL,  -- APPROVAL_PENDING|APPROVAL_DONE|
                                                -- TASK_DUE|DELEGATION|SYSTEM|REMINDER
    title_en          VARCHAR2(500)  NOT NULL,
    title_ar          VARCHAR2(500),
    body_en           VARCHAR2(4000),
    body_ar           VARCHAR2(4000),
    link_url          VARCHAR2(500),
    is_read           VARCHAR2(1)    DEFAULT 'N' NOT NULL,
    read_at           TIMESTAMP,
    created_at        TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    expires_at        TIMESTAMP,
    --
    CONSTRAINT chk_dct_notif_read  CHECK (is_read IN ('Y','N')),
    CONSTRAINT fk_dct_notif_user   FOREIGN KEY (recipient_user_id) REFERENCES PROD.dct_users(user_id)
);

CREATE INDEX ix_dct_notif_user   ON PROD.dct_notifications(recipient_user_id, is_read);
CREATE INDEX ix_dct_notif_type   ON PROD.dct_notifications(notification_type, created_at);

-- =============================================================================
-- 24. DCT_ANNOUNCEMENTS
-- =============================================================================
CREATE TABLE PROD.dct_announcements (
    announcement_id  NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title_en         VARCHAR2(500)  NOT NULL,
    title_ar         VARCHAR2(500),
    body_en          CLOB,
    body_ar          CLOB,
    severity         VARCHAR2(20)   DEFAULT 'INFO' NOT NULL,  -- INFO | WARNING | CRITICAL
    target_audience  VARCHAR2(20)   DEFAULT 'ALL'  NOT NULL,  -- ALL | ROLE | MODULE
    target_role_id   NUMBER,
    target_module_id NUMBER,
    published_at     TIMESTAMP,
    expires_at       TIMESTAMP,
    is_active        VARCHAR2(1)    DEFAULT 'Y' NOT NULL,
    created_by       VARCHAR2(100),
    created_at       TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by       VARCHAR2(100),
    updated_at       TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_dct_ann_sev     CHECK (severity IN ('INFO','WARNING','CRITICAL')),
    CONSTRAINT chk_dct_ann_aud     CHECK (target_audience IN ('ALL','ROLE','MODULE')),
    CONSTRAINT chk_dct_ann_active  CHECK (is_active IN ('Y','N')),
    CONSTRAINT fk_dct_ann_role     FOREIGN KEY (target_role_id)   REFERENCES PROD.dct_roles(role_id),
    CONSTRAINT fk_dct_ann_module   FOREIGN KEY (target_module_id) REFERENCES PROD.dct_modules(module_id)
);

CREATE INDEX ix_dct_ann_active ON PROD.dct_announcements(is_active, published_at, expires_at);

-- =============================================================================
-- TRIGGERS — Auto-maintain updated_at on all tables
-- =============================================================================

CREATE OR REPLACE TRIGGER PROD.trg_dct_org_upd
    BEFORE UPDATE ON PROD.dct_organizations FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/
CREATE OR REPLACE TRIGGER PROD.trg_dct_usr_upd
    BEFORE UPDATE ON PROD.dct_users FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/
CREATE OR REPLACE TRIGGER PROD.trg_dct_upref_upd
    BEFORE UPDATE ON PROD.dct_user_preferences FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/
CREATE OR REPLACE TRIGGER PROD.trg_dct_uorg_upd
    BEFORE UPDATE ON PROD.dct_user_orgs FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/
CREATE OR REPLACE TRIGGER PROD.trg_dct_mod_upd
    BEFORE UPDATE ON PROD.dct_modules FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/
CREATE OR REPLACE TRIGGER PROD.trg_dct_role_upd
    BEFORE UPDATE ON PROD.dct_roles FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/
CREATE OR REPLACE TRIGGER PROD.trg_dct_perm_upd
    BEFORE UPDATE ON PROD.dct_permissions FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/
CREATE OR REPLACE TRIGGER PROD.trg_dct_ur_upd
    BEFORE UPDATE ON PROD.dct_user_roles FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/
CREATE OR REPLACE TRIGGER PROD.trg_dct_menu_upd
    BEFORE UPDATE ON PROD.dct_menus FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/
CREATE OR REPLACE TRIGGER PROD.trg_dct_mitem_upd
    BEFORE UPDATE ON PROD.dct_menu_items FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/
CREATE OR REPLACE TRIGGER PROD.trg_dct_tmpl_upd
    BEFORE UPDATE ON PROD.dct_approval_templates FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/
CREATE OR REPLACE TRIGGER PROD.trg_dct_step_upd
    BEFORE UPDATE ON PROD.dct_approval_steps FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/
CREATE OR REPLACE TRIGGER PROD.trg_dct_inst_upd
    BEFORE UPDATE ON PROD.dct_approval_instances FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/
CREATE OR REPLACE TRIGGER PROD.trg_dct_del_upd
    BEFORE UPDATE ON PROD.dct_delegations FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/
CREATE OR REPLACE TRIGGER PROD.trg_dct_lcat_upd
    BEFORE UPDATE ON PROD.dct_lookup_categories FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/
CREATE OR REPLACE TRIGGER PROD.trg_dct_lval_upd
    BEFORE UPDATE ON PROD.dct_lookup_values FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/
CREATE OR REPLACE TRIGGER PROD.trg_dct_set_upd
    BEFORE UPDATE ON PROD.dct_system_settings FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/
CREATE OR REPLACE TRIGGER PROD.trg_dct_ann_upd
    BEFORE UPDATE ON PROD.dct_announcements FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/

-- =============================================================================
-- COMMENTS — Table and column documentation
-- =============================================================================
COMMENT ON TABLE PROD.dct_users               IS 'i-Finance V2: Master user directory for all internal and external users';
COMMENT ON TABLE PROD.dct_organizations       IS 'i-Finance V2: Organisation hierarchy (divisions, sections, units)';
COMMENT ON TABLE PROD.dct_roles               IS 'i-Finance V2: Role definitions. SYSTEM roles cannot be deleted.';
COMMENT ON TABLE PROD.dct_permissions         IS 'i-Finance V2: Granular permission library keyed by MODULE.ACTION pattern';
COMMENT ON TABLE PROD.dct_user_roles          IS 'i-Finance V2: Core RBAC — time-bounded user-to-role assignments';
COMMENT ON TABLE PROD.dct_modules             IS 'i-Finance V2: Registry of all APEX apps and external modules in the platform';
COMMENT ON TABLE PROD.dct_approval_templates  IS 'i-Finance V2: Reusable approval chain templates shared across domain apps';
COMMENT ON TABLE PROD.dct_approval_instances  IS 'i-Finance V2: One row per submitted business record requiring approval';
COMMENT ON TABLE PROD.dct_approval_actions    IS 'i-Finance V2: Append-only action log for each approval step taken';
COMMENT ON TABLE PROD.dct_delegations         IS 'i-Finance V2: Delegation of authority for absence/holiday cover';
COMMENT ON TABLE PROD.dct_audit_log           IS 'i-Finance V2: Centralised, partitioned audit trail for all platform events';
COMMENT ON TABLE PROD.dct_system_settings     IS 'i-Finance V2: Key-value configuration store for platform-wide settings';

COMMENT ON COLUMN PROD.dct_users.auth_method  IS 'DB=custom hash | LDAP=directory | OCI_IAM=Oracle Cloud | SAML=federation';
COMMENT ON COLUMN PROD.dct_users.password_hash IS 'SHA-512 hex digest. NULL when auth_method != DB.';
COMMENT ON COLUMN PROD.dct_users.is_external  IS 'Y for freelancers, vendors, CWIP external contractors';
COMMENT ON COLUMN PROD.dct_user_roles.org_scope_id IS 'NULL = role applies across all orgs. Set to restrict role to one org subtree.';
COMMENT ON COLUMN PROD.dct_approval_instances.source_module IS 'Module code of the domain app that owns this request (e.g. CWIP, PAYMENT_REQ)';

COMMIT;
-- End of 01_dct_ddl.sql
