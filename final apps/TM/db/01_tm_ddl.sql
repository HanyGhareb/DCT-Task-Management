-- =============================================================================
-- Task Management Module (App 207) -- DDL
-- File    : 01_tm_ddl.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @01_tm_ddl.sql   (connects as ADMIN)
-- Requires: V2 shared framework (db/v2/install.sql) -- DCT_USERS, DCT_ORGANIZATIONS,
--           DCT_DOCUMENTS, DCT_REQUEST_STATUS_HISTORY, DCT_LOOKUP_PKG already present.
-- Notes   : Lookup-first -- NO status CHECK constraints on these tables; status/type
--           families live in DCT_LOOKUP_VALUES and are validated by DCT_TM_PKG via
--           DCT_LOOKUP_PKG.validate_lookup. Y/N flag CHECKs are kept (booleans).
--           TM uses surrogate-key DCT_TM_TASKS -- distinct from the natural-key
--           project-costing DCT_TASKS master.
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- DROP (reverse dependency order) -- safe re-run
-- =============================================================================
DECLARE
    PROCEDURE drop_table (p_name VARCHAR2) IS
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE prod.' || p_name || ' CASCADE CONSTRAINTS PURGE';
        DBMS_OUTPUT.PUT_LINE('Dropped: ' || p_name);
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE != -942 THEN RAISE; END IF;     -- ignore "table does not exist"
    END;
BEGIN
    drop_table('DCT_TM_REMINDER_PREFS');
    drop_table('DCT_TM_MEETINGS');
    drop_table('DCT_TM_MILESTONES');
    drop_table('DCT_TM_LOG_ITEMS');
    drop_table('DCT_TM_TASK_UPDATES');
    drop_table('DCT_TM_TASK_ASSIGNEES');
    drop_table('DCT_TM_DELIVERABLES');
    drop_table('DCT_TM_TASKS');
    drop_table('DCT_TM_OBJECTIVES');
    drop_table('DCT_TM_MEMBERS');
    drop_table('DCT_TM_ROLE_PERMS');
    drop_table('DCT_TM_ROLES');
    drop_table('DCT_TM_TEAMS');
END;
/

-- =============================================================================
-- 1. DCT_TM_TEAMS -- Team registry / team definition
-- =============================================================================
CREATE TABLE prod.dct_tm_teams (
  team_id          NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  team_code        VARCHAR2(30)    NOT NULL,
  team_name_en     VARCHAR2(200)   NOT NULL,
  team_name_ar     VARCHAR2(200),
  objective        VARCHAR2(2000),                       -- team's overall objective / charter
  purpose          VARCHAR2(2000),
  team_type        VARCHAR2(30)    NOT NULL,             -- lookup TM_TEAM_TYPE  (Internal/External)
  team_class       VARCHAR2(30)    NOT NULL,             -- lookup TM_TEAM_CLASS (Strategic/Operational/Management)
  team_category    VARCHAR2(50),                         -- lookup TM_TEAM_CATEGORY (open, admin-managed)
  leader_user_id   NUMBER          NOT NULL,
  org_id           NUMBER,
  start_date       DATE,
  end_date         DATE,
  status           VARCHAR2(30)    DEFAULT 'ACTIVE' NOT NULL,  -- lookup TM_TEAM_STATUS
  health_rag       VARCHAR2(10),                         -- lookup TM_RAG (auto-computed: GREEN/AMBER/RED)
  is_active        VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
  created_by       VARCHAR2(100),
  created_at       DATE            DEFAULT SYSDATE NOT NULL,
  updated_by       VARCHAR2(100),
  updated_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT uq_dct_tm_team_code  UNIQUE (team_code),
  CONSTRAINT chk_dct_tm_team_act  CHECK  (is_active IN ('Y','N')),
  CONSTRAINT chk_dct_tm_team_dts  CHECK  (end_date IS NULL OR end_date >= start_date),
  CONSTRAINT fk_dct_tm_team_lead  FOREIGN KEY (leader_user_id) REFERENCES prod.dct_users(user_id),
  CONSTRAINT fk_dct_tm_team_org   FOREIGN KEY (org_id)         REFERENCES prod.dct_organizations(org_id)
);
CREATE INDEX prod.ix_dct_tm_team_lead   ON prod.dct_tm_teams(leader_user_id);
CREATE INDEX prod.ix_dct_tm_team_org    ON prod.dct_tm_teams(org_id);
CREATE INDEX prod.ix_dct_tm_team_status ON prod.dct_tm_teams(status, is_active);
CREATE INDEX prod.ix_dct_tm_team_class  ON prod.dct_tm_teams(team_type, team_class, team_category);

COMMENT ON TABLE  prod.dct_tm_teams              IS 'Task-Management team registry / team definition (App 207).';
COMMENT ON COLUMN prod.dct_tm_teams.team_code    IS 'App-generated team reference: TM-YYYY-NNNNN.';
COMMENT ON COLUMN prod.dct_tm_teams.team_type    IS 'Lookup TM_TEAM_TYPE: INTERNAL / EXTERNAL.';
COMMENT ON COLUMN prod.dct_tm_teams.team_class   IS 'Lookup TM_TEAM_CLASS: STRATEGIC / OPERATIONAL / MANAGEMENT.';
COMMENT ON COLUMN prod.dct_tm_teams.team_category IS 'Lookup TM_TEAM_CATEGORY -- open, admin-managed set.';
COMMENT ON COLUMN prod.dct_tm_teams.health_rag   IS 'Auto-computed RAG health (lookup TM_RAG): from overdue tasks + objective progress.';

-- =============================================================================
-- 2. DCT_TM_ROLES -- Team-role templates (Leader, Supervisor, Member, ...)
-- =============================================================================
CREATE TABLE prod.dct_tm_roles (
  tm_role_id       NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  role_code        VARCHAR2(30)    NOT NULL,
  role_name_en     VARCHAR2(120)   NOT NULL,
  role_name_ar     VARCHAR2(120),
  description_en   VARCHAR2(500),
  is_system        VARCHAR2(1)     DEFAULT 'N' NOT NULL,  -- Y = seeded template, cannot delete
  is_leader_role   VARCHAR2(1)     DEFAULT 'N' NOT NULL,  -- Y = treated as team leader for escalations
  display_order    NUMBER          DEFAULT 100 NOT NULL,
  is_active        VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
  created_by       VARCHAR2(100),
  created_at       DATE            DEFAULT SYSDATE NOT NULL,
  updated_by       VARCHAR2(100),
  updated_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT uq_dct_tm_role_code  UNIQUE (role_code),
  CONSTRAINT chk_dct_tm_role_sys  CHECK  (is_system IN ('Y','N')),
  CONSTRAINT chk_dct_tm_role_lead CHECK  (is_leader_role IN ('Y','N')),
  CONSTRAINT chk_dct_tm_role_act  CHECK  (is_active IN ('Y','N'))
);
COMMENT ON TABLE prod.dct_tm_roles IS 'Team-scoped role templates carrying the artifact CRUD matrix; assigned per member per team.';

-- =============================================================================
-- 3. DCT_TM_ROLE_PERMS -- artifact CRUD matrix (template default + per-team override)
-- =============================================================================
CREATE TABLE prod.dct_tm_role_perms (
  perm_id          NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  tm_role_id       NUMBER          NOT NULL,
  team_id          NUMBER,                               -- NULL = template default; set = per-team override
  artifact_type    VARCHAR2(30)    NOT NULL,             -- lookup TM_ARTIFACT_TYPE
  can_create       VARCHAR2(1)     DEFAULT 'N' NOT NULL,
  can_read         VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
  can_update       VARCHAR2(1)     DEFAULT 'N' NOT NULL,
  can_delete       VARCHAR2(1)     DEFAULT 'N' NOT NULL,
  created_by       VARCHAR2(100),
  created_at       DATE            DEFAULT SYSDATE NOT NULL,
  updated_by       VARCHAR2(100),
  updated_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT chk_dct_tm_rp_c      CHECK (can_create IN ('Y','N')),
  CONSTRAINT chk_dct_tm_rp_r      CHECK (can_read   IN ('Y','N')),
  CONSTRAINT chk_dct_tm_rp_u      CHECK (can_update IN ('Y','N')),
  CONSTRAINT chk_dct_tm_rp_d      CHECK (can_delete IN ('Y','N')),
  CONSTRAINT fk_dct_tm_rp_role    FOREIGN KEY (tm_role_id) REFERENCES prod.dct_tm_roles(tm_role_id) ON DELETE CASCADE,
  CONSTRAINT fk_dct_tm_rp_team    FOREIGN KEY (team_id)    REFERENCES prod.dct_tm_teams(team_id)    ON DELETE CASCADE
);
-- One row per (role, team-or-template, artifact). Oracle has no filtered indexes, so
-- NVL(team_id,-1) folds the template (NULL) and override (>0) cases into one unique key.
-- Identity team_id starts at 1, so -1 can never collide with a real team.
CREATE UNIQUE INDEX prod.uq_dct_tm_rp ON prod.dct_tm_role_perms (tm_role_id, NVL(team_id,-1), artifact_type);
CREATE INDEX prod.ix_dct_tm_rp_team ON prod.dct_tm_role_perms (team_id);

COMMENT ON TABLE  prod.dct_tm_role_perms          IS 'Artifact CRUD matrix per team role. team_id NULL = global template default; team_id set = per-team override.';
COMMENT ON COLUMN prod.dct_tm_role_perms.artifact_type IS 'Lookup TM_ARTIFACT_TYPE: TEAM, MEMBER, ROLE, OBJECTIVE, TASK, DELIVERABLE, MILESTONE, LOG_ITEM, MEETING, DOCUMENT.';

-- =============================================================================
-- 4. DCT_TM_MEMBERS -- team membership (users from DCT_USERS) with a team role
-- =============================================================================
CREATE TABLE prod.dct_tm_members (
  member_id        NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  team_id          NUMBER          NOT NULL,
  user_id          NUMBER          NOT NULL,
  tm_role_id       NUMBER          NOT NULL,
  title            VARCHAR2(120),                        -- free-text position within the team
  join_date        DATE            DEFAULT SYSDATE NOT NULL,
  leave_date       DATE,
  is_active        VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
  created_by       VARCHAR2(100),
  created_at       DATE            DEFAULT SYSDATE NOT NULL,
  updated_by       VARCHAR2(100),
  updated_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT chk_dct_tm_mbr_act   CHECK (is_active IN ('Y','N')),
  CONSTRAINT chk_dct_tm_mbr_dts   CHECK (leave_date IS NULL OR leave_date >= join_date),
  CONSTRAINT fk_dct_tm_mbr_team   FOREIGN KEY (team_id)    REFERENCES prod.dct_tm_teams(team_id) ON DELETE CASCADE,
  CONSTRAINT fk_dct_tm_mbr_user   FOREIGN KEY (user_id)    REFERENCES prod.dct_users(user_id),
  CONSTRAINT fk_dct_tm_mbr_role   FOREIGN KEY (tm_role_id) REFERENCES prod.dct_tm_roles(tm_role_id)
);
-- One ACTIVE membership per (team, user); historical inactive rows allowed.
-- Function-based: inactive rows index to (NULL,NULL) -> not enforced (Oracle skips all-NULL keys).
CREATE UNIQUE INDEX prod.uq_dct_tm_mbr_active ON prod.dct_tm_members
  (CASE WHEN is_active = 'Y' THEN team_id END, CASE WHEN is_active = 'Y' THEN user_id END);
CREATE INDEX prod.ix_dct_tm_mbr_user ON prod.dct_tm_members (user_id, is_active);
CREATE INDEX prod.ix_dct_tm_mbr_team ON prod.dct_tm_members (team_id, is_active);

COMMENT ON TABLE prod.dct_tm_members IS 'Team membership: links DCT_USERS to a team with a team role. Drives cross-team My Work and permissions.';

-- =============================================================================
-- 5. DCT_TM_OBJECTIVES -- team objectives / operations / projects to follow up
-- =============================================================================
CREATE TABLE prod.dct_tm_objectives (
  objective_id     NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  team_id          NUMBER          NOT NULL,
  title_en         VARCHAR2(300)   NOT NULL,
  title_ar         VARCHAR2(300),
  description      VARCHAR2(2000),
  owner_user_id    NUMBER,                               -- member responsible
  weight           NUMBER(5,2)     DEFAULT 1,            -- relative weight for progress roll-up
  progress_pct     NUMBER(5,2)     DEFAULT 0 NOT NULL,
  target_date      DATE,
  status           VARCHAR2(30)    DEFAULT 'NOT_STARTED' NOT NULL,  -- lookup TM_OBJECTIVE_STATUS
  display_order    NUMBER          DEFAULT 100 NOT NULL,
  created_by       VARCHAR2(100),
  created_at       DATE            DEFAULT SYSDATE NOT NULL,
  updated_by       VARCHAR2(100),
  updated_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT chk_dct_tm_obj_pct   CHECK (progress_pct BETWEEN 0 AND 100),
  CONSTRAINT chk_dct_tm_obj_wt    CHECK (weight >= 0),
  CONSTRAINT fk_dct_tm_obj_team   FOREIGN KEY (team_id)       REFERENCES prod.dct_tm_teams(team_id) ON DELETE CASCADE,
  CONSTRAINT fk_dct_tm_obj_owner  FOREIGN KEY (owner_user_id) REFERENCES prod.dct_users(user_id)
);
CREATE INDEX prod.ix_dct_tm_obj_team ON prod.dct_tm_objectives (team_id, status);

COMMENT ON TABLE prod.dct_tm_objectives IS 'Team objectives / operations / projects; tasks and deliverables roll up here.';

-- =============================================================================
-- 6. DCT_TM_TASKS -- work items (supports subtasks via parent_task_id)
-- =============================================================================
CREATE TABLE prod.dct_tm_tasks (
  task_id          NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  task_code        VARCHAR2(30)    NOT NULL,
  team_id          NUMBER          NOT NULL,
  objective_id     NUMBER,
  parent_task_id   NUMBER,
  title            VARCHAR2(300)   NOT NULL,
  description      VARCHAR2(4000),
  priority         VARCHAR2(20)    DEFAULT 'MEDIUM' NOT NULL,    -- lookup TM_TASK_PRIORITY
  status           VARCHAR2(20)    DEFAULT 'TODO' NOT NULL,      -- lookup TM_TASK_STATUS
  progress_pct     NUMBER(5,2)     DEFAULT 0 NOT NULL,
  start_date       DATE,
  due_date         DATE,
  completed_date   DATE,
  est_hours        NUMBER(8,2),
  actual_hours     NUMBER(8,2),
  is_recurring     VARCHAR2(1)     DEFAULT 'N' NOT NULL,
  recurrence_rule  VARCHAR2(200),                        -- simple RRULE-ish text (DAILY/WEEKLY/MONTHLY:n)
  created_by       VARCHAR2(100),
  created_at       DATE            DEFAULT SYSDATE NOT NULL,
  updated_by       VARCHAR2(100),
  updated_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT uq_dct_tm_task_code  UNIQUE (task_code),
  CONSTRAINT chk_dct_tm_task_pct  CHECK (progress_pct BETWEEN 0 AND 100),
  CONSTRAINT chk_dct_tm_task_rec  CHECK (is_recurring IN ('Y','N')),
  CONSTRAINT chk_dct_tm_task_dts  CHECK (due_date IS NULL OR start_date IS NULL OR due_date >= start_date),
  CONSTRAINT fk_dct_tm_task_team  FOREIGN KEY (team_id)       REFERENCES prod.dct_tm_teams(team_id) ON DELETE CASCADE,
  CONSTRAINT fk_dct_tm_task_obj   FOREIGN KEY (objective_id)  REFERENCES prod.dct_tm_objectives(objective_id),
  CONSTRAINT fk_dct_tm_task_par   FOREIGN KEY (parent_task_id) REFERENCES prod.dct_tm_tasks(task_id)
);
CREATE INDEX prod.ix_dct_tm_task_team   ON prod.dct_tm_tasks (team_id, status);
CREATE INDEX prod.ix_dct_tm_task_obj    ON prod.dct_tm_tasks (objective_id);
CREATE INDEX prod.ix_dct_tm_task_due    ON prod.dct_tm_tasks (due_date, status);
CREATE INDEX prod.ix_dct_tm_task_parent ON prod.dct_tm_tasks (parent_task_id);

COMMENT ON TABLE  prod.dct_tm_tasks           IS 'Task-Management work items (surrogate key) -- distinct from natural-key project-costing DCT_TASKS.';
COMMENT ON COLUMN prod.dct_tm_tasks.task_code IS 'App-generated: TSK-YYYY-NNNNN.';

-- =============================================================================
-- 7. DCT_TM_TASK_ASSIGNEES -- task <-> member (m:n) for cross-team My Work
-- =============================================================================
CREATE TABLE prod.dct_tm_task_assignees (
  assignee_id      NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  task_id          NUMBER          NOT NULL,
  user_id          NUMBER          NOT NULL,
  is_primary       VARCHAR2(1)     DEFAULT 'N' NOT NULL,  -- Y = primary owner of the task
  assigned_by      VARCHAR2(100),
  assigned_at      DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT uq_dct_tm_asg         UNIQUE (task_id, user_id),
  CONSTRAINT chk_dct_tm_asg_prim   CHECK (is_primary IN ('Y','N')),
  CONSTRAINT fk_dct_tm_asg_task    FOREIGN KEY (task_id) REFERENCES prod.dct_tm_tasks(task_id) ON DELETE CASCADE,
  CONSTRAINT fk_dct_tm_asg_user    FOREIGN KEY (user_id) REFERENCES prod.dct_users(user_id)
);
CREATE INDEX prod.ix_dct_tm_asg_user ON prod.dct_tm_task_assignees (user_id);

COMMENT ON TABLE prod.dct_tm_task_assignees IS 'Many-to-many task assignment. A member sees all assigned tasks across every team in My Work.';

-- =============================================================================
-- 8. DCT_TM_TASK_UPDATES -- progress notes / comments / activity feed (@mentions)
-- =============================================================================
CREATE TABLE prod.dct_tm_task_updates (
  update_id        NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  task_id          NUMBER          NOT NULL,
  update_type      VARCHAR2(20)    DEFAULT 'COMMENT' NOT NULL,   -- COMMENT / PROGRESS / STATUS / SYSTEM
  body             VARCHAR2(4000),
  old_status       VARCHAR2(20),
  new_status       VARCHAR2(20),
  progress_pct     NUMBER(5,2),
  mentions         VARCHAR2(1000),                       -- comma-separated user_ids parsed from @mentions
  created_by       VARCHAR2(100),
  created_by_id    NUMBER,
  created_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT fk_dct_tm_upd_task FOREIGN KEY (task_id)      REFERENCES prod.dct_tm_tasks(task_id) ON DELETE CASCADE,
  CONSTRAINT fk_dct_tm_upd_user FOREIGN KEY (created_by_id) REFERENCES prod.dct_users(user_id)
);
CREATE INDEX prod.ix_dct_tm_upd_task ON prod.dct_tm_task_updates (task_id, created_at);

COMMENT ON TABLE prod.dct_tm_task_updates IS 'Task activity feed: comments, progress/status changes, @mention notifications.';

-- =============================================================================
-- 9. DCT_TM_DELIVERABLES -- team deliverables / outputs
-- =============================================================================
CREATE TABLE prod.dct_tm_deliverables (
  deliverable_id   NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  deliverable_code VARCHAR2(30)    NOT NULL,
  team_id          NUMBER          NOT NULL,
  objective_id     NUMBER,
  milestone_id     NUMBER,
  title_en         VARCHAR2(300)   NOT NULL,
  title_ar         VARCHAR2(300),
  description      VARCHAR2(2000),
  owner_user_id    NUMBER,
  deliverable_type VARCHAR2(30),                         -- lookup TM_DELIVERABLE_TYPE
  status           VARCHAR2(30)    DEFAULT 'NOT_STARTED' NOT NULL,  -- lookup TM_DELIVERABLE_STATUS
  progress_pct     NUMBER(5,2)     DEFAULT 0 NOT NULL,
  due_date         DATE,
  submitted_date   DATE,
  accepted_date    DATE,
  acceptance_criteria VARCHAR2(2000),
  rejection_reason VARCHAR2(1000),
  created_by       VARCHAR2(100),
  created_at       DATE            DEFAULT SYSDATE NOT NULL,
  updated_by       VARCHAR2(100),
  updated_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT uq_dct_tm_del_code   UNIQUE (deliverable_code),
  CONSTRAINT chk_dct_tm_del_pct   CHECK (progress_pct BETWEEN 0 AND 100),
  CONSTRAINT fk_dct_tm_del_team   FOREIGN KEY (team_id)       REFERENCES prod.dct_tm_teams(team_id) ON DELETE CASCADE,
  CONSTRAINT fk_dct_tm_del_obj    FOREIGN KEY (objective_id)  REFERENCES prod.dct_tm_objectives(objective_id),
  CONSTRAINT fk_dct_tm_del_owner  FOREIGN KEY (owner_user_id) REFERENCES prod.dct_users(user_id)
  -- milestone_id FK added after DCT_TM_MILESTONES is created (below)
);
CREATE INDEX prod.ix_dct_tm_del_team ON prod.dct_tm_deliverables (team_id, status);
CREATE INDEX prod.ix_dct_tm_del_due  ON prod.dct_tm_deliverables (due_date, status);

COMMENT ON TABLE  prod.dct_tm_deliverables           IS 'Team deliverables / outputs; evidence files attach via unified DCT_DOCUMENTS (source_type=DELIVERABLE).';
COMMENT ON COLUMN prod.dct_tm_deliverables.deliverable_code IS 'App-generated: DLV-YYYY-NNNNN.';

-- =============================================================================
-- 10. DCT_TM_MILESTONES -- key dates per team / objective
-- =============================================================================
CREATE TABLE prod.dct_tm_milestones (
  milestone_id     NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  team_id          NUMBER          NOT NULL,
  objective_id     NUMBER,
  title_en         VARCHAR2(300)   NOT NULL,
  title_ar         VARCHAR2(300),
  description      VARCHAR2(1000),
  due_date         DATE            NOT NULL,
  achieved_date    DATE,
  status           VARCHAR2(30)    DEFAULT 'PENDING' NOT NULL,   -- lookup TM_OBJECTIVE_STATUS (reused)
  display_order    NUMBER          DEFAULT 100 NOT NULL,
  created_by       VARCHAR2(100),
  created_at       DATE            DEFAULT SYSDATE NOT NULL,
  updated_by       VARCHAR2(100),
  updated_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT fk_dct_tm_ms_team FOREIGN KEY (team_id)      REFERENCES prod.dct_tm_teams(team_id) ON DELETE CASCADE,
  CONSTRAINT fk_dct_tm_ms_obj  FOREIGN KEY (objective_id) REFERENCES prod.dct_tm_objectives(objective_id)
);
CREATE INDEX prod.ix_dct_tm_ms_team ON prod.dct_tm_milestones (team_id, due_date);

COMMENT ON TABLE prod.dct_tm_milestones IS 'Milestones / key dates for the Gantt and dashboards.';

-- Deferred FK: deliverable -> milestone
ALTER TABLE prod.dct_tm_deliverables ADD CONSTRAINT fk_dct_tm_del_ms
  FOREIGN KEY (milestone_id) REFERENCES prod.dct_tm_milestones(milestone_id);

-- =============================================================================
-- 11. DCT_TM_LOG_ITEMS -- unified RAID register (issues/challenges/risks/...)
-- =============================================================================
CREATE TABLE prod.dct_tm_log_items (
  log_id           NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  log_code         VARCHAR2(30)    NOT NULL,
  team_id          NUMBER          NOT NULL,
  objective_id     NUMBER,
  task_id          NUMBER,
  item_type        VARCHAR2(20)    NOT NULL,             -- lookup TM_LOG_ITEM_TYPE
  title            VARCHAR2(300)   NOT NULL,
  description      VARCHAR2(4000),
  owner_user_id    NUMBER,
  severity         VARCHAR2(20),                         -- lookup TM_LOG_SEVERITY (risks/issues)
  likelihood       VARCHAR2(20),                         -- lookup TM_LOG_SEVERITY (risks)
  impact           VARCHAR2(20),                         -- lookup TM_LOG_SEVERITY (risks)
  status           VARCHAR2(20)    DEFAULT 'OPEN' NOT NULL,      -- lookup TM_LOG_STATUS
  mitigation       VARCHAR2(2000),
  due_date         DATE,
  resolved_date    DATE,
  created_by       VARCHAR2(100),
  created_at       DATE            DEFAULT SYSDATE NOT NULL,
  updated_by       VARCHAR2(100),
  updated_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT uq_dct_tm_log_code   UNIQUE (log_code),
  CONSTRAINT fk_dct_tm_log_team   FOREIGN KEY (team_id)       REFERENCES prod.dct_tm_teams(team_id) ON DELETE CASCADE,
  CONSTRAINT fk_dct_tm_log_obj    FOREIGN KEY (objective_id)  REFERENCES prod.dct_tm_objectives(objective_id),
  CONSTRAINT fk_dct_tm_log_task   FOREIGN KEY (task_id)       REFERENCES prod.dct_tm_tasks(task_id),
  CONSTRAINT fk_dct_tm_log_owner  FOREIGN KEY (owner_user_id) REFERENCES prod.dct_users(user_id)
);
CREATE INDEX prod.ix_dct_tm_log_team ON prod.dct_tm_log_items (team_id, item_type, status);
CREATE INDEX prod.ix_dct_tm_log_due  ON prod.dct_tm_log_items (due_date, status);

COMMENT ON TABLE  prod.dct_tm_log_items        IS 'Unified RAID register: issues, challenges, risks, achievements, decisions, dependencies, lessons.';
COMMENT ON COLUMN prod.dct_tm_log_items.item_type IS 'Lookup TM_LOG_ITEM_TYPE: ISSUE/CHALLENGE/RISK/ACHIEVEMENT/DECISION/DEPENDENCY/LESSON.';

-- =============================================================================
-- 12. DCT_TM_MEETINGS -- meetings + minutes (action items promotable to tasks)
-- =============================================================================
CREATE TABLE prod.dct_tm_meetings (
  meeting_id       NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  meeting_code     VARCHAR2(30)    NOT NULL,
  team_id          NUMBER          NOT NULL,
  title            VARCHAR2(300)   NOT NULL,
  meeting_date     DATE            NOT NULL,
  location         VARCHAR2(300),
  agenda           VARCHAR2(4000),
  minutes          VARCHAR2(4000),
  attendees        VARCHAR2(2000),                       -- comma-separated user_ids
  status           VARCHAR2(20)    DEFAULT 'PLANNED' NOT NULL,   -- lookup TM_LOG_STATUS (reused: PLANNED/HELD/CANCELLED)
  created_by       VARCHAR2(100),
  created_at       DATE            DEFAULT SYSDATE NOT NULL,
  updated_by       VARCHAR2(100),
  updated_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT uq_dct_tm_mtg_code UNIQUE (meeting_code),
  CONSTRAINT fk_dct_tm_mtg_team FOREIGN KEY (team_id) REFERENCES prod.dct_tm_teams(team_id) ON DELETE CASCADE
);
CREATE INDEX prod.ix_dct_tm_mtg_team ON prod.dct_tm_meetings (team_id, meeting_date);

COMMENT ON TABLE prod.dct_tm_meetings IS 'Team meetings + minutes; action items can be promoted to DCT_TM_TASKS.';

-- =============================================================================
-- 13. DCT_TM_REMINDER_PREFS -- per-user reminder preference (pre-reminder N days)
-- =============================================================================
CREATE TABLE prod.dct_tm_reminder_prefs (
  pref_id          NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id          NUMBER          NOT NULL,
  lead_days        NUMBER          DEFAULT 2 NOT NULL,   -- remind N days before a task's due date
  remind_overdue   VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
  channel_inapp    VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
  channel_email    VARCHAR2(1)     DEFAULT 'N' NOT NULL,
  daily_digest     VARCHAR2(1)     DEFAULT 'N' NOT NULL,
  digest_hour      NUMBER          DEFAULT 7,            -- 0-23 local hour for the daily digest
  created_at       DATE            DEFAULT SYSDATE NOT NULL,
  updated_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT uq_dct_tm_rpf_user   UNIQUE (user_id),
  CONSTRAINT chk_dct_tm_rpf_lead  CHECK (lead_days BETWEEN 0 AND 365),
  CONSTRAINT chk_dct_tm_rpf_ovd   CHECK (remind_overdue IN ('Y','N')),
  CONSTRAINT chk_dct_tm_rpf_ina   CHECK (channel_inapp IN ('Y','N')),
  CONSTRAINT chk_dct_tm_rpf_eml   CHECK (channel_email IN ('Y','N')),
  CONSTRAINT chk_dct_tm_rpf_dig   CHECK (daily_digest IN ('Y','N')),
  CONSTRAINT chk_dct_tm_rpf_hr    CHECK (digest_hour BETWEEN 0 AND 23),
  CONSTRAINT fk_dct_tm_rpf_user   FOREIGN KEY (user_id) REFERENCES prod.dct_users(user_id)
);
COMMENT ON TABLE  prod.dct_tm_reminder_prefs        IS 'Per-user task-reminder preferences. lead_days = pre-reminder window before due date.';
COMMENT ON COLUMN prod.dct_tm_reminder_prefs.lead_days IS 'Remind N days before a task is due (0-365). Boundary-tested.';

-- =============================================================================
-- UPDATED_AT TRIGGERS
-- =============================================================================
CREATE OR REPLACE TRIGGER prod.trg_dct_tm_teams_upd        BEFORE UPDATE ON prod.dct_tm_teams        FOR EACH ROW BEGIN :NEW.updated_at := SYSDATE; END;
/
CREATE OR REPLACE TRIGGER prod.trg_dct_tm_roles_upd        BEFORE UPDATE ON prod.dct_tm_roles        FOR EACH ROW BEGIN :NEW.updated_at := SYSDATE; END;
/
CREATE OR REPLACE TRIGGER prod.trg_dct_tm_role_perms_upd   BEFORE UPDATE ON prod.dct_tm_role_perms   FOR EACH ROW BEGIN :NEW.updated_at := SYSDATE; END;
/
CREATE OR REPLACE TRIGGER prod.trg_dct_tm_members_upd      BEFORE UPDATE ON prod.dct_tm_members      FOR EACH ROW BEGIN :NEW.updated_at := SYSDATE; END;
/
CREATE OR REPLACE TRIGGER prod.trg_dct_tm_objectives_upd   BEFORE UPDATE ON prod.dct_tm_objectives   FOR EACH ROW BEGIN :NEW.updated_at := SYSDATE; END;
/
CREATE OR REPLACE TRIGGER prod.trg_dct_tm_tasks_upd        BEFORE UPDATE ON prod.dct_tm_tasks        FOR EACH ROW BEGIN :NEW.updated_at := SYSDATE; END;
/
CREATE OR REPLACE TRIGGER prod.trg_dct_tm_deliverables_upd BEFORE UPDATE ON prod.dct_tm_deliverables FOR EACH ROW BEGIN :NEW.updated_at := SYSDATE; END;
/
CREATE OR REPLACE TRIGGER prod.trg_dct_tm_milestones_upd   BEFORE UPDATE ON prod.dct_tm_milestones   FOR EACH ROW BEGIN :NEW.updated_at := SYSDATE; END;
/
CREATE OR REPLACE TRIGGER prod.trg_dct_tm_log_items_upd    BEFORE UPDATE ON prod.dct_tm_log_items    FOR EACH ROW BEGIN :NEW.updated_at := SYSDATE; END;
/
CREATE OR REPLACE TRIGGER prod.trg_dct_tm_meetings_upd     BEFORE UPDATE ON prod.dct_tm_meetings     FOR EACH ROW BEGIN :NEW.updated_at := SYSDATE; END;
/
CREATE OR REPLACE TRIGGER prod.trg_dct_tm_rem_prefs_upd    BEFORE UPDATE ON prod.dct_tm_reminder_prefs FOR EACH ROW BEGIN :NEW.updated_at := SYSDATE; END;
/

COMMIT;

PROMPT
PROMPT === 01_tm_ddl.sql complete ===
PROMPT Tables: DCT_TM_TEAMS, DCT_TM_ROLES, DCT_TM_ROLE_PERMS, DCT_TM_MEMBERS,
PROMPT         DCT_TM_OBJECTIVES, DCT_TM_TASKS, DCT_TM_TASK_ASSIGNEES, DCT_TM_TASK_UPDATES,
PROMPT         DCT_TM_DELIVERABLES, DCT_TM_MILESTONES, DCT_TM_LOG_ITEMS, DCT_TM_MEETINGS,
PROMPT         DCT_TM_REMINDER_PREFS
PROMPT Documents reuse unified DCT_DOCUMENTS (source_module=TASK_MGMT).
