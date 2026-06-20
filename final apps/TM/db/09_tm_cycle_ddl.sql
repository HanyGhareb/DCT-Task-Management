-- =============================================================================
-- Task Management Module (App 207) -- Reporting-Cycle, Visibility & Team-Tree DDL
-- File    : 09_tm_cycle_ddl.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @09_tm_cycle_ddl.sql   (after 01_tm_ddl.sql)
-- Adds    : team parent-child hierarchy (DCT_TM_TEAMS.parent_team_id + relations),
--           reporting-cycle engine (config/periods/submissions/signoff),
--           cross-team visibility grants, and a schema-level id collection type
--           used by the pipelined visible_teams() function.
-- Notes   : ADDITIVE -- only drops the NEW tables it owns, never the core ones.
--           Lookup-first -- NO status CHECK constraints; status/type families live
--           in DCT_LOOKUP_VALUES (seeded by 10_tm_cycle_seed.sql). Y/N flag CHECKs
--           kept. One structural CHECK on the visibility-grant shape (an invariant).
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- 0. Schema-level collection type for the pipelined visible_teams() function.
--    A package-local type cannot be used in a SQL TABLE() across the
--    ADMIN -> PROD synonym boundary, so the type must be a standalone object.
-- =============================================================================
DECLARE
    e_in_use EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_in_use, -2303);   -- type has dependents -> leave as-is
BEGIN
    EXECUTE IMMEDIATE 'CREATE OR REPLACE TYPE prod.dct_tm_id_tab AS TABLE OF NUMBER';
EXCEPTION WHEN e_in_use THEN
    NULL;
END;
/

-- =============================================================================
-- DROP (reverse dependency order) -- safe re-run of THIS file's own tables only
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
    drop_table('DCT_TM_PERIOD_SIGNOFF');
    drop_table('DCT_TM_SUBMISSIONS');
    drop_table('DCT_TM_PERIODS');
    drop_table('DCT_TM_CYCLE_SUBMITTERS');
    drop_table('DCT_TM_CYCLE_CONFIG');
    drop_table('DCT_TM_VISIBILITY_GRANT');
    drop_table('DCT_TM_TEAM_RELATIONS');
END;
/

-- =============================================================================
-- 1. TEAM HIERARCHY -- parent_team_id on DCT_TM_TEAMS (program -> sub-team)
--    ALTER is guarded so the file is re-runnable.
-- =============================================================================
DECLARE
    e_dup_col EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_dup_col, -1430);   -- column being added already exists
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_tm_teams ADD parent_team_id NUMBER';
    DBMS_OUTPUT.PUT_LINE('Added DCT_TM_TEAMS.parent_team_id');
EXCEPTION WHEN e_dup_col THEN
    DBMS_OUTPUT.PUT_LINE('DCT_TM_TEAMS.parent_team_id already present');
END;
/
DECLARE
    e_exists EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_exists, -2275);   -- such a referential constraint already exists
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_tm_teams ADD CONSTRAINT fk_dct_tm_team_parent '
                   || 'FOREIGN KEY (parent_team_id) REFERENCES prod.dct_tm_teams(team_id)';
EXCEPTION WHEN e_exists THEN NULL;
WHEN OTHERS THEN IF SQLCODE != -2264 AND SQLCODE != -2261 THEN RAISE; END IF;
END;
/
DECLARE
    e_exists EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_exists, -955);    -- name is already used by an existing object
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX prod.ix_dct_tm_team_parent ON prod.dct_tm_teams(parent_team_id)';
EXCEPTION WHEN e_exists THEN NULL;
END;
/
COMMENT ON COLUMN prod.dct_tm_teams.parent_team_id IS
  'Self-ref parent team (program -> sub-team). Drives team-tree visibility + executive roll-ups.';

-- DCT_TM_TEAM_RELATIONS -- optional non-hierarchical links (peer / supports / blocks)
CREATE TABLE prod.dct_tm_team_relations (
  relation_id      NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  team_id          NUMBER          NOT NULL,
  related_team_id  NUMBER          NOT NULL,
  relation_type    VARCHAR2(20)    NOT NULL,             -- lookup TM_TEAM_RELATION
  notes            VARCHAR2(500),
  created_by       VARCHAR2(100),
  created_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT uq_dct_tm_trel        UNIQUE (team_id, related_team_id, relation_type),
  CONSTRAINT chk_dct_tm_trel_self  CHECK  (team_id <> related_team_id),
  CONSTRAINT fk_dct_tm_trel_team   FOREIGN KEY (team_id)         REFERENCES prod.dct_tm_teams(team_id) ON DELETE CASCADE,
  CONSTRAINT fk_dct_tm_trel_rel    FOREIGN KEY (related_team_id) REFERENCES prod.dct_tm_teams(team_id) ON DELETE CASCADE
);
CREATE INDEX prod.ix_dct_tm_trel_team ON prod.dct_tm_team_relations (team_id);
COMMENT ON TABLE prod.dct_tm_team_relations IS 'Non-hierarchical team links (peer/supports/blocks); the single parent lives on DCT_TM_TEAMS.parent_team_id.';

-- =============================================================================
-- 2. DCT_TM_CYCLE_CONFIG -- per-team reporting cadence (one ACTIVE per team)
-- =============================================================================
CREATE TABLE prod.dct_tm_cycle_config (
  cycle_config_id      NUMBER       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  team_id              NUMBER       NOT NULL,
  cadence              VARCHAR2(20) NOT NULL,            -- lookup TM_CADENCE
  custom_days          NUMBER,                           -- only when cadence = CUSTOM
  anchor_date          DATE         DEFAULT TRUNC(SYSDATE) NOT NULL,  -- period phase origin
  submission_lead_days NUMBER       DEFAULT 3 NOT NULL,  -- open submissions N days before period_end
  deadline_offset_days NUMBER       DEFAULT 0 NOT NULL,  -- due_date = period_end + offset
  reminder_days_before VARCHAR2(50) DEFAULT '3,1' NOT NULL, -- CSV of pre-deadline reminder offsets
  escalate_after_days  NUMBER       DEFAULT 1 NOT NULL,  -- days past due before leader escalation
  submitter_scope      VARCHAR2(20) DEFAULT 'ALL_MEMBERS' NOT NULL,  -- lookup TM_SUBMITTER_SCOPE
  auto_close           VARCHAR2(1)  DEFAULT 'Y' NOT NULL,
  is_active            VARCHAR2(1)  DEFAULT 'Y' NOT NULL,
  created_by           VARCHAR2(100),
  created_at           DATE         DEFAULT SYSDATE NOT NULL,
  updated_by           VARCHAR2(100),
  updated_at           DATE         DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT chk_dct_tm_cyc_act   CHECK (is_active IN ('Y','N')),
  CONSTRAINT chk_dct_tm_cyc_auto  CHECK (auto_close IN ('Y','N')),
  CONSTRAINT chk_dct_tm_cyc_lead  CHECK (submission_lead_days BETWEEN 0 AND 365),
  CONSTRAINT chk_dct_tm_cyc_esc   CHECK (escalate_after_days BETWEEN 0 AND 365),
  CONSTRAINT chk_dct_tm_cyc_cust  CHECK (custom_days IS NULL OR custom_days BETWEEN 1 AND 366),
  CONSTRAINT fk_dct_tm_cyc_team   FOREIGN KEY (team_id) REFERENCES prod.dct_tm_teams(team_id) ON DELETE CASCADE
);
-- One ACTIVE config per team (function-based: inactive rows index to NULL -> not enforced)
CREATE UNIQUE INDEX prod.uq_dct_tm_cyc_active ON prod.dct_tm_cycle_config
  (CASE WHEN is_active = 'Y' THEN team_id END);
COMMENT ON TABLE prod.dct_tm_cycle_config IS 'Per-team reporting cadence: how often members must submit a progress update + reminder/escalation timing.';

-- DCT_TM_CYCLE_SUBMITTERS -- explicit submitter list when submitter_scope = SELECTED
CREATE TABLE prod.dct_tm_cycle_submitters (
  cycle_config_id  NUMBER          NOT NULL,
  user_id          NUMBER          NOT NULL,
  CONSTRAINT pk_dct_tm_cyc_sub     PRIMARY KEY (cycle_config_id, user_id),
  CONSTRAINT fk_dct_tm_cyc_sub_cfg FOREIGN KEY (cycle_config_id) REFERENCES prod.dct_tm_cycle_config(cycle_config_id) ON DELETE CASCADE,
  CONSTRAINT fk_dct_tm_cyc_sub_usr FOREIGN KEY (user_id)         REFERENCES prod.dct_users(user_id)
);

-- =============================================================================
-- 3. DCT_TM_PERIODS -- generated reporting windows per team
-- =============================================================================
CREATE TABLE prod.dct_tm_periods (
  period_id        NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  team_id          NUMBER          NOT NULL,
  cycle_config_id  NUMBER,
  period_label     VARCHAR2(60)    NOT NULL,            -- e.g. 2026-W25 / 2026-06 / 2026-Q2
  period_start     DATE            NOT NULL,
  period_end       DATE            NOT NULL,
  open_date        DATE            NOT NULL,            -- submissions open from here
  due_date         DATE            NOT NULL,            -- submission deadline
  status           VARCHAR2(20)    DEFAULT 'PENDING' NOT NULL,  -- lookup TM_PERIOD_STATUS
  snapshot_json    CLOB,                                -- immutable executive snapshot at close
  ai_summary       CLOB,                                -- optional AI-generated narrative (Phase C)
  closed_by        NUMBER,
  closed_at        DATE,
  created_by       VARCHAR2(100),
  created_at       DATE            DEFAULT SYSDATE NOT NULL,
  updated_by       VARCHAR2(100),
  updated_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT uq_dct_tm_per         UNIQUE (team_id, period_start, period_end),
  CONSTRAINT chk_dct_tm_per_dts    CHECK (period_end >= period_start),
  CONSTRAINT chk_dct_tm_per_json   CHECK (snapshot_json IS NULL OR snapshot_json IS JSON),
  CONSTRAINT fk_dct_tm_per_team    FOREIGN KEY (team_id)         REFERENCES prod.dct_tm_teams(team_id) ON DELETE CASCADE,
  CONSTRAINT fk_dct_tm_per_cfg     FOREIGN KEY (cycle_config_id) REFERENCES prod.dct_tm_cycle_config(cycle_config_id),
  CONSTRAINT fk_dct_tm_per_closer  FOREIGN KEY (closed_by)       REFERENCES prod.dct_users(user_id)
);
CREATE INDEX prod.ix_dct_tm_per_team ON prod.dct_tm_periods (team_id, status);
CREATE INDEX prod.ix_dct_tm_per_due  ON prod.dct_tm_periods (due_date, status);
COMMENT ON TABLE  prod.dct_tm_periods               IS 'Generated reporting windows; CLOSED/LOCKED periods carry an immutable snapshot_json for executive reporting.';
COMMENT ON COLUMN prod.dct_tm_periods.snapshot_json IS 'Denormalized team status at close so historical executive reports do not drift as live data keeps changing.';

-- =============================================================================
-- 4. DCT_TM_SUBMISSIONS -- per-member progress check-in for a period
-- =============================================================================
CREATE TABLE prod.dct_tm_submissions (
  submission_id    NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  period_id        NUMBER          NOT NULL,
  team_id          NUMBER          NOT NULL,
  user_id          NUMBER          NOT NULL,
  status           VARCHAR2(20)    DEFAULT 'NOT_STARTED' NOT NULL,  -- lookup TM_SUBMISSION_STATUS
  accomplishments  VARCHAR2(4000),
  in_progress      VARCHAR2(4000),
  pending          VARCHAR2(4000),
  blockers         VARCHAR2(4000),                      -- challenges / blockers
  highlights       VARCHAR2(4000),                      -- risks / highlights for management
  -- auto-pulled metrics (denormalized at skeleton build, refreshed on save)
  tasks_done       NUMBER          DEFAULT 0,
  tasks_on_track   NUMBER          DEFAULT 0,
  tasks_late       NUMBER          DEFAULT 0,
  tasks_open       NUMBER          DEFAULT 0,
  tasks_overdue    NUMBER          DEFAULT 0,
  objective_progress NUMBER(5,2),
  deliverables_done NUMBER         DEFAULT 0,
  new_raid_count   NUMBER          DEFAULT 0,
  submitted_at     DATE,
  created_by       VARCHAR2(100),
  created_at       DATE            DEFAULT SYSDATE NOT NULL,
  updated_by       VARCHAR2(100),
  updated_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT uq_dct_tm_sub         UNIQUE (period_id, user_id),
  CONSTRAINT fk_dct_tm_sub_per     FOREIGN KEY (period_id) REFERENCES prod.dct_tm_periods(period_id) ON DELETE CASCADE,
  CONSTRAINT fk_dct_tm_sub_team    FOREIGN KEY (team_id)   REFERENCES prod.dct_tm_teams(team_id),
  CONSTRAINT fk_dct_tm_sub_user    FOREIGN KEY (user_id)   REFERENCES prod.dct_users(user_id)
);
CREATE INDEX prod.ix_dct_tm_sub_user ON prod.dct_tm_submissions (user_id, status);
CREATE INDEX prod.ix_dct_tm_sub_per  ON prod.dct_tm_submissions (period_id, status);
COMMENT ON TABLE prod.dct_tm_submissions IS 'Per-member progress check-in per reporting period: narrative + auto-pulled metrics.';

-- =============================================================================
-- 5. DCT_TM_PERIOD_SIGNOFF -- leader consolidation / sign-off (one per period)
-- =============================================================================
CREATE TABLE prod.dct_tm_period_signoff (
  signoff_id       NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  period_id        NUMBER          NOT NULL,
  leader_user_id   NUMBER          NOT NULL,
  summary          VARCHAR2(4000),
  team_rag         VARCHAR2(10),                        -- lookup TM_RAG
  signed_at        DATE            DEFAULT SYSDATE NOT NULL,
  created_at       DATE            DEFAULT SYSDATE NOT NULL,
  updated_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT uq_dct_tm_sgn_per     UNIQUE (period_id),
  CONSTRAINT fk_dct_tm_sgn_per     FOREIGN KEY (period_id)      REFERENCES prod.dct_tm_periods(period_id) ON DELETE CASCADE,
  CONSTRAINT fk_dct_tm_sgn_user    FOREIGN KEY (leader_user_id) REFERENCES prod.dct_users(user_id)
);
COMMENT ON TABLE prod.dct_tm_period_signoff IS 'Team-leader consolidation + RAG sign-off for a reporting period.';

-- =============================================================================
-- 6. DCT_TM_VISIBILITY_GRANT -- cross-team read exceptions (executive viewers)
-- =============================================================================
CREATE TABLE prod.dct_tm_visibility_grant (
  grant_id         NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  grantee_user_id  NUMBER          NOT NULL,
  scope            VARCHAR2(10)    NOT NULL,            -- lookup TM_VIS_SCOPE: TEAM/TEAM_TREE/ORG/ALL
  team_id          NUMBER,                              -- when scope = TEAM or TEAM_TREE
  org_id           NUMBER,                              -- when scope = ORG
  access_level     VARCHAR2(10)    DEFAULT 'VIEWER' NOT NULL,  -- lookup TM_VIS_LEVEL: VIEWER/REPORTER
  granted_by       NUMBER,
  start_date       DATE            DEFAULT SYSDATE NOT NULL,
  end_date         DATE,
  status           VARCHAR2(20)    DEFAULT 'ACTIVE' NOT NULL,  -- lookup TM_GRANT_STATUS
  reason           VARCHAR2(500),
  created_by       VARCHAR2(100),
  created_at       DATE            DEFAULT SYSDATE NOT NULL,
  updated_by       VARCHAR2(100),
  updated_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  -- structural invariant (not a status): scope dictates which target column is set
  CONSTRAINT chk_dct_tm_vis_shape  CHECK (
       (scope IN ('TEAM','TEAM_TREE') AND team_id IS NOT NULL AND org_id IS NULL)
    OR (scope = 'ORG'                 AND org_id  IS NOT NULL AND team_id IS NULL)
    OR (scope = 'ALL'                 AND team_id IS NULL     AND org_id IS NULL)),
  CONSTRAINT chk_dct_tm_vis_dts    CHECK (end_date IS NULL OR end_date >= start_date),
  CONSTRAINT fk_dct_tm_vis_user    FOREIGN KEY (grantee_user_id) REFERENCES prod.dct_users(user_id),
  CONSTRAINT fk_dct_tm_vis_team    FOREIGN KEY (team_id)         REFERENCES prod.dct_tm_teams(team_id) ON DELETE CASCADE,
  CONSTRAINT fk_dct_tm_vis_org     FOREIGN KEY (org_id)          REFERENCES prod.dct_organizations(org_id)
);
CREATE INDEX prod.ix_dct_tm_vis_grantee ON prod.dct_tm_visibility_grant (grantee_user_id, status);
CREATE INDEX prod.ix_dct_tm_vis_team    ON prod.dct_tm_visibility_grant (scope, team_id);
CREATE INDEX prod.ix_dct_tm_vis_org     ON prod.dct_tm_visibility_grant (scope, org_id);
COMMENT ON TABLE  prod.dct_tm_visibility_grant IS 'Cross-team read exceptions: grant a user visibility of a team, a team-tree, an org node, or all teams.';
COMMENT ON COLUMN prod.dct_tm_visibility_grant.access_level IS 'VIEWER = read-only cross-team; REPORTER = also feeds executive roll-ups.';

-- =============================================================================
-- UPDATED_AT TRIGGERS
-- =============================================================================
CREATE OR REPLACE TRIGGER prod.trg_dct_tm_cyc_cfg_upd   BEFORE UPDATE ON prod.dct_tm_cycle_config     FOR EACH ROW BEGIN :NEW.updated_at := SYSDATE; END;
/
CREATE OR REPLACE TRIGGER prod.trg_dct_tm_periods_upd   BEFORE UPDATE ON prod.dct_tm_periods          FOR EACH ROW BEGIN :NEW.updated_at := SYSDATE; END;
/
CREATE OR REPLACE TRIGGER prod.trg_dct_tm_subs_upd      BEFORE UPDATE ON prod.dct_tm_submissions      FOR EACH ROW BEGIN :NEW.updated_at := SYSDATE; END;
/
CREATE OR REPLACE TRIGGER prod.trg_dct_tm_signoff_upd   BEFORE UPDATE ON prod.dct_tm_period_signoff   FOR EACH ROW BEGIN :NEW.updated_at := SYSDATE; END;
/
CREATE OR REPLACE TRIGGER prod.trg_dct_tm_vis_upd       BEFORE UPDATE ON prod.dct_tm_visibility_grant FOR EACH ROW BEGIN :NEW.updated_at := SYSDATE; END;
/

COMMIT;

PROMPT
PROMPT === 09_tm_cycle_ddl.sql complete ===
PROMPT Type   : DCT_TM_ID_TAB
PROMPT Teams  : + parent_team_id (hierarchy) + DCT_TM_TEAM_RELATIONS
PROMPT Cycle  : DCT_TM_CYCLE_CONFIG, DCT_TM_CYCLE_SUBMITTERS, DCT_TM_PERIODS,
PROMPT          DCT_TM_SUBMISSIONS, DCT_TM_PERIOD_SIGNOFF
PROMPT Visib. : DCT_TM_VISIBILITY_GRANT
