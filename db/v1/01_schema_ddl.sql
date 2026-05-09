/* ================================================================
   i-Finance Task Management Module
   Database Schema — Oracle 23ai
   Script : 01_schema_ddl.sql
   Purpose: Create all tables, constraints, indexes, triggers, views
   Run as : IFINANCE schema owner (or DBA with grants)
   ================================================================ */

/* ----------------------------------------------------------------
   IMPORTANT: Run as IFINANCE schema owner.
   Tables use GENERATED ALWAYS AS IDENTITY (Oracle 12c+/23ai).
   Audit columns on every table:
     CREATED_BY  VARCHAR2(200) — set by calling application
     CREATED_AT  TIMESTAMP     — set by DEFAULT SYSTIMESTAMP
     UPDATED_BY  VARCHAR2(200) — set by calling application
     UPDATED_AT  TIMESTAMP     — auto-maintained by trigger
   ---------------------------------------------------------------- */

-- ================================================================
-- 1. ROLES
--    Reusable roles across multiple application modules.
--    Each role belongs to a MODULE_CODE so the same table
--    can serve TASK_MGMT, BUDGETING, HR, etc.
-- ================================================================
CREATE TABLE roles (
    role_id         NUMBER              GENERATED ALWAYS AS IDENTITY
                                        CONSTRAINT pk_roles PRIMARY KEY,
    role_code       VARCHAR2(50)        NOT NULL,
    role_name       VARCHAR2(100)       NOT NULL,
    description     VARCHAR2(500),
    module_code     VARCHAR2(50)        DEFAULT 'TASK_MGMT'
                                        NOT NULL,
    display_order   NUMBER(3)           DEFAULT 999,
    is_active       CHAR(1)             DEFAULT 'Y'
                                        NOT NULL
                                        CONSTRAINT chk_roles_active
                                            CHECK (is_active IN ('Y','N')),
    -- Audit columns
    created_by      VARCHAR2(200)       NOT NULL,
    created_at      TIMESTAMP           DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by      VARCHAR2(200)       NOT NULL,
    updated_at      TIMESTAMP           DEFAULT SYSTIMESTAMP NOT NULL,
    -- A role code must be unique within a module
    CONSTRAINT uq_roles_code_module     UNIQUE (role_code, module_code)
);

COMMENT ON TABLE  roles                IS 'Application roles — scoped by module for multi-module reuse';
COMMENT ON COLUMN roles.role_code      IS 'Short uppercase key e.g. DIRECTOR, MANAGER, VIEWER';
COMMENT ON COLUMN roles.module_code    IS 'Application module owning this role e.g. TASK_MGMT, BUDGETING';
COMMENT ON COLUMN roles.display_order  IS 'UI sort order within module';


-- ================================================================
-- 2. USERS
--    Application users — synced from OCI IAM on first login.
--    Passwords are NOT stored here; authentication is via IAM.
-- ================================================================
CREATE TABLE users (
    user_id         NUMBER              GENERATED ALWAYS AS IDENTITY
                                        CONSTRAINT pk_users PRIMARY KEY,
    username        VARCHAR2(100)       NOT NULL,   -- OCI IAM username
    email           VARCHAR2(200)       NOT NULL,
    display_name    VARCHAR2(200)       NOT NULL,
    initials        VARCHAR2(10),
    job_title       VARCHAR2(200),
    section         VARCHAR2(200),
    color_hex       VARCHAR2(20),       -- e.g. #2563eb
    color_gradient  VARCHAR2(300),      -- CSS gradient string
    is_active       CHAR(1)             DEFAULT 'Y'
                                        NOT NULL
                                        CONSTRAINT chk_users_active
                                            CHECK (is_active IN ('Y','N')),
    last_login_at   TIMESTAMP,
    -- Audit columns
    created_by      VARCHAR2(200)       NOT NULL,
    created_at      TIMESTAMP           DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by      VARCHAR2(200)       NOT NULL,
    updated_at      TIMESTAMP           DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT uq_users_email           UNIQUE (email),
    CONSTRAINT uq_users_username        UNIQUE (username)
);

COMMENT ON TABLE  users                IS 'Application users — identity managed by OCI IAM';
COMMENT ON COLUMN users.username       IS 'Matches OCI IAM username / subject claim in JWT';
COMMENT ON COLUMN users.color_hex      IS 'Avatar accent color hex code';
COMMENT ON COLUMN users.color_gradient IS 'CSS linear-gradient for avatar background';
COMMENT ON COLUMN users.last_login_at  IS 'Timestamp of most recent successful login';


-- ================================================================
-- 3. USER_ROLES
--    Many-to-many: a user can hold multiple roles
--    (e.g. DIRECTOR + BUDGET_APPROVER across modules).
--    VALID_FROM / VALID_TO support time-bounded role assignments.
-- ================================================================
CREATE TABLE user_roles (
    user_role_id    NUMBER              GENERATED ALWAYS AS IDENTITY
                                        CONSTRAINT pk_user_roles PRIMARY KEY,
    user_id         NUMBER              NOT NULL
                                        CONSTRAINT fk_ur_user
                                            REFERENCES users (user_id)
                                            ON DELETE CASCADE,
    role_id         NUMBER              NOT NULL
                                        CONSTRAINT fk_ur_role
                                            REFERENCES roles (role_id)
                                            ON DELETE CASCADE,
    valid_from      DATE                DEFAULT SYSDATE NOT NULL,
    valid_to        DATE,               -- NULL = role does not expire
    -- Audit columns
    created_by      VARCHAR2(200)       NOT NULL,
    created_at      TIMESTAMP           DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by      VARCHAR2(200)       NOT NULL,
    updated_at      TIMESTAMP           DEFAULT SYSTIMESTAMP NOT NULL,
    -- A user may hold each role only once at a time
    CONSTRAINT uq_user_roles            UNIQUE (user_id, role_id),
    CONSTRAINT chk_ur_dates             CHECK  (valid_to IS NULL OR valid_to > valid_from)
);

COMMENT ON TABLE  user_roles           IS 'User-to-role assignments; supports time-bounded roles';
COMMENT ON COLUMN user_roles.valid_from IS 'Date from which the role assignment is effective';
COMMENT ON COLUMN user_roles.valid_to   IS 'Expiry date; NULL means the role does not expire';


-- ================================================================
-- 4. TASKS
-- ================================================================
CREATE TABLE tasks (
    task_id             NUMBER          GENERATED ALWAYS AS IDENTITY
                                        CONSTRAINT pk_tasks PRIMARY KEY,
    title               VARCHAR2(500)   NOT NULL,
    description         CLOB,
    status              VARCHAR2(20)    DEFAULT 'NOT_STARTED'
                                        NOT NULL
                                        CONSTRAINT chk_tasks_status
                                            CHECK (status IN (
                                                'NOT_STARTED','IN_PROGRESS',
                                                'COMPLETED','DELAYED','BLOCKED')),
    priority            VARCHAR2(10)    DEFAULT 'MEDIUM'
                                        NOT NULL
                                        CONSTRAINT chk_tasks_priority
                                            CHECK (priority IN ('HIGH','MEDIUM','LOW')),
    category            VARCHAR2(100),
    start_date          DATE,
    due_date            DATE,
    completion_pct      NUMBER(3,0)     DEFAULT 0
                                        NOT NULL
                                        CONSTRAINT chk_tasks_pct
                                            CHECK (completion_pct BETWEEN 0 AND 100),
    next_action         CLOB,
    next_action_date    DATE,
    notes               CLOB,
    assigned_to         NUMBER          NOT NULL
                                        CONSTRAINT fk_tasks_user
                                            REFERENCES users (user_id),
    week_number         NUMBER(2,0)     NOT NULL
                                        CONSTRAINT chk_tasks_week
                                            CHECK (week_number BETWEEN 1 AND 53),
    year                NUMBER(4,0)     NOT NULL
                                        CONSTRAINT chk_tasks_year
                                            CHECK (year >= 2020),
    -- Audit columns
    created_by          VARCHAR2(200)   NOT NULL,
    created_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by          VARCHAR2(200)   NOT NULL,
    updated_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT chk_tasks_dates          CHECK (
        due_date IS NULL OR start_date IS NULL OR due_date >= start_date
    )
);

COMMENT ON TABLE  tasks                IS 'Weekly tasks assigned to section managers';
COMMENT ON COLUMN tasks.completion_pct IS '0–100 completion percentage';
COMMENT ON COLUMN tasks.week_number    IS 'ISO week number (1–53)';
COMMENT ON COLUMN tasks.assigned_to    IS 'FK to USERS — the manager who owns this task';


-- ================================================================
-- 5. TASK_ATTACHMENTS
-- ================================================================
CREATE TABLE task_attachments (
    attach_id       NUMBER              GENERATED ALWAYS AS IDENTITY
                                        CONSTRAINT pk_task_attachments PRIMARY KEY,
    task_id         NUMBER              NOT NULL
                                        CONSTRAINT fk_att_task
                                            REFERENCES tasks (task_id)
                                            ON DELETE CASCADE,
    file_name       VARCHAR2(500)       NOT NULL,
    mime_type       VARCHAR2(200),
    file_size_bytes NUMBER(15,0),
    file_content    BLOB,
    -- Audit columns
    created_by      VARCHAR2(200)       NOT NULL,
    created_at      TIMESTAMP           DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by      VARCHAR2(200)       NOT NULL,
    updated_at      TIMESTAMP           DEFAULT SYSTIMESTAMP NOT NULL
);

COMMENT ON TABLE  task_attachments              IS 'File attachments stored as BLOB per task';
COMMENT ON COLUMN task_attachments.file_content IS 'Binary file content; max size governed by DB storage';

-- Disable BLOB logging for performance (large BLOBs)
ALTER TABLE task_attachments MODIFY LOB (file_content) (NOCACHE NOLOGGING);


-- ================================================================
-- 6. TASK_TAGS
-- ================================================================
CREATE TABLE task_tags (
    tag_id          NUMBER              GENERATED ALWAYS AS IDENTITY
                                        CONSTRAINT pk_task_tags PRIMARY KEY,
    task_id         NUMBER              NOT NULL
                                        CONSTRAINT fk_tag_task
                                            REFERENCES tasks (task_id)
                                            ON DELETE CASCADE,
    tag_name        VARCHAR2(100)       NOT NULL,
    -- Audit columns
    created_by      VARCHAR2(200)       NOT NULL,
    created_at      TIMESTAMP           DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by      VARCHAR2(200)       NOT NULL,
    updated_at      TIMESTAMP           DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT uq_task_tags             UNIQUE (task_id, tag_name)
);

COMMENT ON TABLE task_tags IS 'Free-form tags attached to tasks';


-- ================================================================
-- INDEXES
-- ================================================================

-- Users
CREATE INDEX idx_users_email       ON users       (email);
CREATE INDEX idx_users_is_active   ON users       (is_active);

-- Roles
CREATE INDEX idx_roles_module      ON roles       (module_code, is_active);

-- User roles — support "what roles does user X have?" and "who has role Y?"
CREATE INDEX idx_ur_user_id        ON user_roles  (user_id);
CREATE INDEX idx_ur_role_id        ON user_roles  (role_id);
CREATE INDEX idx_ur_valid          ON user_roles  (user_id, valid_from, valid_to);

-- Tasks — most common query patterns
CREATE INDEX idx_tasks_assigned_wk ON tasks       (assigned_to, week_number, year);
CREATE INDEX idx_tasks_week_year   ON tasks       (week_number, year);
CREATE INDEX idx_tasks_status      ON tasks       (status);
CREATE INDEX idx_tasks_due_date    ON tasks       (due_date);

-- Attachments
CREATE INDEX idx_att_task_id       ON task_attachments (task_id);

-- Tags
CREATE INDEX idx_tags_task_id      ON task_tags   (task_id);


-- ================================================================
-- TRIGGERS — auto-maintain UPDATED_AT on every table
--   UPDATED_BY must be set explicitly by the calling application
--   (APEX: V('APP_USER'), PL/SQL packages: p_updated_by param)
-- ================================================================

CREATE OR REPLACE TRIGGER trg_roles_upd
    BEFORE UPDATE ON roles
    FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
END;
/

CREATE OR REPLACE TRIGGER trg_users_upd
    BEFORE UPDATE ON users
    FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
END;
/

CREATE OR REPLACE TRIGGER trg_user_roles_upd
    BEFORE UPDATE ON user_roles
    FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
END;
/

CREATE OR REPLACE TRIGGER trg_tasks_upd
    BEFORE UPDATE ON tasks
    FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    -- Auto-sync completion percentage and status
    IF :NEW.completion_pct = 100 AND :OLD.status != 'COMPLETED' THEN
        :NEW.status := 'COMPLETED';
    END IF;
    IF :NEW.completion_pct = 0 AND :OLD.status = 'COMPLETED' THEN
        :NEW.status := 'NOT_STARTED';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_task_attachments_upd
    BEFORE UPDATE ON task_attachments
    FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
END;
/

CREATE OR REPLACE TRIGGER trg_task_tags_upd
    BEFORE UPDATE ON task_tags
    FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
END;
/


-- ================================================================
-- VIEWS
-- ================================================================

-- Active role assignments for today (excludes expired roles)
CREATE OR REPLACE VIEW v_user_active_roles AS
SELECT
    ur.user_role_id,
    u.user_id,
    u.username,
    u.display_name,
    u.email,
    u.section,
    u.is_active         AS user_active,
    r.role_id,
    r.role_code,
    r.role_name,
    r.module_code,
    ur.valid_from,
    ur.valid_to
FROM
    user_roles  ur
    JOIN users  u ON u.user_id  = ur.user_id
    JOIN roles  r ON r.role_id  = ur.role_id
WHERE
    u.is_active   = 'Y'
    AND r.is_active = 'Y'
    AND ur.valid_from <= SYSDATE
    AND (ur.valid_to IS NULL OR ur.valid_to > SYSDATE);

COMMENT ON VIEW v_user_active_roles IS 'Currently active role assignments — excludes expired and inactive records';


-- Weekly task statistics per user per week
CREATE OR REPLACE VIEW v_task_weekly_stats AS
SELECT
    t.assigned_to,
    u.display_name,
    u.section,
    u.color_hex,
    u.color_gradient,
    u.initials,
    t.week_number,
    t.year,
    COUNT(*)                                                        AS total_tasks,
    SUM(CASE WHEN t.status = 'COMPLETED'   THEN 1 ELSE 0 END)      AS completed,
    SUM(CASE WHEN t.status = 'IN_PROGRESS' THEN 1 ELSE 0 END)      AS in_progress,
    SUM(CASE WHEN t.status = 'NOT_STARTED' THEN 1 ELSE 0 END)      AS not_started,
    SUM(CASE WHEN t.status = 'DELAYED'     THEN 1 ELSE 0 END)      AS delayed,
    SUM(CASE WHEN t.status = 'BLOCKED'     THEN 1 ELSE 0 END)      AS blocked,
    SUM(CASE WHEN t.status IN ('DELAYED','BLOCKED') THEN 1 ELSE 0 END) AS at_risk,
    ROUND(
        SUM(CASE WHEN t.status = 'COMPLETED' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0) * 100
    , 1)                                                            AS completion_rate,
    ROUND(AVG(t.completion_pct), 1)                                 AS avg_completion_pct
FROM
    tasks t
    JOIN users u ON u.user_id = t.assigned_to
GROUP BY
    t.assigned_to, u.display_name, u.section,
    u.color_hex, u.color_gradient, u.initials,
    t.week_number, t.year;

COMMENT ON VIEW v_task_weekly_stats IS 'Aggregated task counts and completion rate per user per ISO week';


-- Director overview — current active managers for a given week
-- Usage: SELECT * FROM v_manager_overview WHERE week_number = :wk AND year = :yr
CREATE OR REPLACE VIEW v_manager_overview AS
SELECT
    u.user_id,
    u.display_name,
    u.email,
    u.section,
    u.job_title,
    u.initials,
    u.color_hex,
    u.color_gradient,
    u.is_active,
    s.week_number,
    s.year,
    NVL(s.total_tasks,     0)   AS total_tasks,
    NVL(s.completed,       0)   AS completed,
    NVL(s.in_progress,     0)   AS in_progress,
    NVL(s.not_started,     0)   AS not_started,
    NVL(s.delayed,         0)   AS delayed,
    NVL(s.blocked,         0)   AS blocked,
    NVL(s.at_risk,         0)   AS at_risk,
    NVL(s.completion_rate, 0)   AS completion_rate,
    NVL(s.avg_completion_pct, 0) AS avg_completion_pct,
    CASE WHEN NVL(s.completion_rate, 0) >= 60 THEN 'Y' ELSE 'N' END AS on_track
FROM
    v_user_active_roles  r
    JOIN users           u  ON u.user_id = r.user_id
    LEFT JOIN v_task_weekly_stats s
                            ON  s.assigned_to  = u.user_id
WHERE
    r.role_code   = 'MANAGER'
    AND r.module_code = 'TASK_MGMT'
    AND u.is_active   = 'Y';

COMMENT ON VIEW v_manager_overview IS 'Director-facing summary of all active managers — join with week/year filter';


-- ================================================================
-- SEED DATA — Roles
-- ================================================================

INSERT INTO roles (role_code, role_name, description, module_code, display_order, is_active, created_by, updated_by)
VALUES ('DIRECTOR', 'Finance Director', 'Full visibility across all sections; can manage users and view all tasks', 'TASK_MGMT', 1, 'SYSTEM', 'SYSTEM');

INSERT INTO roles (role_code, role_name, description, module_code, display_order, is_active, created_by, updated_by)
VALUES ('MANAGER', 'Section Manager', 'Can manage own weekly tasks; view own section dashboard', 'TASK_MGMT', 2, 'SYSTEM', 'SYSTEM');

INSERT INTO roles (role_code, role_name, description, module_code, display_order, is_active, created_by, updated_by)
VALUES ('VIEWER', 'Read-Only Viewer', 'Can view all tasks and reports but cannot create or edit', 'TASK_MGMT', 3, 'SYSTEM', 'SYSTEM');

-- Placeholder roles for future modules (demonstrates multi-module design)
INSERT INTO roles (role_code, role_name, description, module_code, display_order, is_active, created_by, updated_by)
VALUES ('BUDGET_OWNER',    'Budget Owner',    'Owns and approves budget lines',     'BUDGETING', 1, 'SYSTEM', 'SYSTEM');

INSERT INTO roles (role_code, role_name, description, module_code, display_order, is_active, created_by, updated_by)
VALUES ('BUDGET_REVIEWER', 'Budget Reviewer', 'Reviews and comments on budget lines','BUDGETING', 2, 'SYSTEM', 'SYSTEM');

COMMIT;


-- ================================================================
-- SEED DATA — Users
-- ================================================================

INSERT INTO users (username, email, display_name, initials, job_title, section, color_hex, color_gradient, is_active, created_by, updated_by)
VALUES ('hashem.alkabbi', 'hashem@finance.ae', 'Hashem Al Kabbi', 'HK', 'Finance Manager',
        'Finance Division', '#1e3a5f', 'linear-gradient(135deg,#0f2040,#1e3a5f)', 'Y', 'SYSTEM', 'SYSTEM');

INSERT INTO users (username, email, display_name, initials, job_title, section, color_hex, color_gradient, is_active, created_by, updated_by)
VALUES ('naser.alkhaja', 'naser@finance.ae', 'Naser Mohamed Al Khaja', 'NK', 'Finance Operations Manager',
        'Finance Operations', '#7c3aed', 'linear-gradient(135deg,#5b21b6,#7c3aed)', 'Y', 'SYSTEM', 'SYSTEM');

INSERT INTO users (username, email, display_name, initials, job_title, section, color_hex, color_gradient, is_active, created_by, updated_by)
VALUES ('ayesha.ameri', 'ayesha@finance.ae', 'Ayesha Abdul Kareem Ameri', 'AA', 'Payables Operations Manager',
        'Payables Operations', '#2563eb', 'linear-gradient(135deg,#1d4ed8,#2563eb)', 'Y', 'SYSTEM', 'SYSTEM');

INSERT INTO users (username, email, display_name, initials, job_title, section, color_hex, color_gradient, is_active, created_by, updated_by)
VALUES ('shaikha.alameri', 'shaikha.g@finance.ae', 'Shaikha Ghanem Al Ameri', 'SGA', 'Financial Planning & Budgeting Manager',
        'Financial Planning & Budgeting', '#059669', 'linear-gradient(135deg,#065f46,#059669)', 'Y', 'SYSTEM', 'SYSTEM');

INSERT INTO users (username, email, display_name, initials, job_title, section, color_hex, color_gradient, is_active, created_by, updated_by)
VALUES ('shaikha.alsuwaidi', 'shaikha.a@finance.ae', 'Shaikha Ahmed Al Suwaidi', 'SA', 'Revenue Assurance Manager',
        'Revenue Assurance', '#d97706', 'linear-gradient(135deg,#92400e,#d97706)', 'Y', 'SYSTEM', 'SYSTEM');

INSERT INTO users (username, email, display_name, initials, job_title, section, color_hex, color_gradient, is_active, created_by, updated_by)
VALUES ('noora.alali', 'noora@finance.ae', 'Noora Saeed Al Ali', 'NS', 'Receivables Operations Manager',
        'Receivables Operations', '#dc2626', 'linear-gradient(135deg,#991b1b,#dc2626)', 'Y', 'SYSTEM', 'SYSTEM');

COMMIT;


-- ================================================================
-- SEED DATA — User Role Assignments
-- ================================================================
-- Assign Director role to Hashem Al Kabbi
INSERT INTO user_roles (user_id, role_id, valid_from, created_by, updated_by)
SELECT u.user_id, r.role_id, SYSDATE, 'SYSTEM', 'SYSTEM'
FROM   users u, roles r
WHERE  u.username  = 'hashem.alkabbi'
AND    r.role_code = 'DIRECTOR'
AND    r.module_code = 'TASK_MGMT';

-- Assign Manager role to all section managers
INSERT INTO user_roles (user_id, role_id, valid_from, created_by, updated_by)
SELECT u.user_id, r.role_id, SYSDATE, 'SYSTEM', 'SYSTEM'
FROM   users u, roles r
WHERE  u.username IN ('naser.alkhaja','ayesha.ameri','shaikha.alameri','shaikha.alsuwaidi','noora.alali')
AND    r.role_code   = 'MANAGER'
AND    r.module_code = 'TASK_MGMT';

COMMIT;


-- ================================================================
-- VERIFICATION QUERIES (run after seeding to confirm)
-- ================================================================
/*
-- Check all tables were created
SELECT table_name FROM user_tables ORDER BY table_name;

-- Check users and their active roles
SELECT u.display_name, u.section, r.role_code, r.module_code, ur.valid_from
FROM   v_user_active_roles ur
JOIN   users u ON u.user_id = ur.user_id
JOIN   roles r ON r.role_id = ur.role_id
ORDER  BY r.module_code, r.role_code, u.display_name;

-- Check row counts
SELECT 'ROLES'            AS tbl, COUNT(*) AS cnt FROM roles
UNION ALL
SELECT 'USERS',                   COUNT(*)         FROM users
UNION ALL
SELECT 'USER_ROLES',              COUNT(*)         FROM user_roles;
*/
