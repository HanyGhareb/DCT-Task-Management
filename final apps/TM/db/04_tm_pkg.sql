-- =============================================================================
-- Task Management Module (App 207) -- Core package DCT_TM_PKG
-- File    : 04_tm_pkg.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @04_tm_pkg.sql   (after 01_tm_ddl.sql, 03_tm_seed.sql)
-- Notes   : Lookup-first validation via DCT_LOOKUP_PKG; status transitions written
--           to DCT_REQUEST_STATUS_HISTORY (source_module='TM'); notifications via
--           DCT_NOTIFY. Permission engine = tm_can()/require_perm() over the
--           team-role CRUD matrix (template default + per-team override).
-- Errors  : -20090 invalid lookup (raised by DCT_LOOKUP_PKG)
--           -20401 not authenticated / unknown actor
--           -20403 permission denied (team-role matrix)
--           -20001 validation (boundary / length / range)
--           -20404 not found
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

-- Sequences for human-readable artifact codes (create-if-absent, re-run safe)
DECLARE
    PROCEDURE mkseq (p_name VARCHAR2) IS
    BEGIN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE prod.' || p_name || ' START WITH 1 NOCACHE';
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE != -955 THEN RAISE; END IF;   -- -955 = name already used
    END;
BEGIN
    mkseq('dct_tm_team_seq');
    mkseq('dct_tm_task_seq');
    mkseq('dct_tm_deliv_seq');
    mkseq('dct_tm_log_seq');
    mkseq('dct_tm_ms_seq');
    mkseq('dct_tm_mtg_seq');
END;
/

CREATE OR REPLACE PACKAGE prod.dct_tm_pkg AS

    -- ---- utilities (published so they are callable from SQL DML inside the body) ----
    FUNCTION actor_name (p_user_id NUMBER) RETURN VARCHAR2;
    FUNCTION gen_code   (p_prefix VARCHAR2, p_seq_val NUMBER) RETURN VARCHAR2;
    FUNCTION role_id_of (p_role_code VARCHAR2) RETURN NUMBER;

    -- ---- permission engine ----
    FUNCTION  is_tm_admin  (p_user_id NUMBER) RETURN VARCHAR2;
    FUNCTION  tm_can       (p_user_id NUMBER, p_team_id NUMBER, p_artifact VARCHAR2, p_action VARCHAR2) RETURN VARCHAR2;
    PROCEDURE require_perm (p_user_id NUMBER, p_team_id NUMBER, p_artifact VARCHAR2, p_action VARCHAR2);

    -- ---- teams ----
    FUNCTION  create_team (
        p_actor_id   NUMBER,
        p_name_en    VARCHAR2,
        p_type       VARCHAR2,
        p_class      VARCHAR2,
        p_leader_id  NUMBER,
        p_category   VARCHAR2 DEFAULT NULL,
        p_name_ar    VARCHAR2 DEFAULT NULL,
        p_objective  VARCHAR2 DEFAULT NULL,
        p_purpose    VARCHAR2 DEFAULT NULL,
        p_org_id     NUMBER   DEFAULT NULL,
        p_start      DATE     DEFAULT NULL,
        p_end        DATE     DEFAULT NULL
    ) RETURN NUMBER;

    PROCEDURE update_team (
        p_actor_id   NUMBER,
        p_team_id    NUMBER,
        p_name_en    VARCHAR2 DEFAULT NULL,
        p_name_ar    VARCHAR2 DEFAULT NULL,
        p_type       VARCHAR2 DEFAULT NULL,
        p_class      VARCHAR2 DEFAULT NULL,
        p_category   VARCHAR2 DEFAULT NULL,
        p_objective  VARCHAR2 DEFAULT NULL,
        p_purpose    VARCHAR2 DEFAULT NULL,
        p_status     VARCHAR2 DEFAULT NULL,
        p_leader_id  NUMBER   DEFAULT NULL,
        p_org_id     NUMBER   DEFAULT NULL,
        p_start      DATE     DEFAULT NULL,
        p_end        DATE     DEFAULT NULL
    );

    -- ---- members ----
    PROCEDURE add_member     (p_actor_id NUMBER, p_team_id NUMBER, p_user_id NUMBER, p_role_code VARCHAR2, p_title VARCHAR2 DEFAULT NULL);
    PROCEDURE set_member_role(p_actor_id NUMBER, p_team_id NUMBER, p_user_id NUMBER, p_role_code VARCHAR2);
    PROCEDURE update_member  (p_actor_id NUMBER, p_team_id NUMBER, p_user_id NUMBER, p_role_code VARCHAR2, p_title VARCHAR2 DEFAULT NULL);
    PROCEDURE remove_member  (p_actor_id NUMBER, p_team_id NUMBER, p_user_id NUMBER);

    -- ---- team-role permission override ----
    PROCEDURE set_team_role_perm (
        p_actor_id NUMBER, p_team_id NUMBER, p_role_code VARCHAR2, p_artifact VARCHAR2,
        p_create VARCHAR2, p_read VARCHAR2, p_update VARCHAR2, p_delete VARCHAR2
    );

    -- ---- objectives ----
    FUNCTION upsert_objective (
        p_actor_id NUMBER, p_team_id NUMBER, p_title_en VARCHAR2,
        p_objective_id NUMBER DEFAULT NULL, p_title_ar VARCHAR2 DEFAULT NULL,
        p_description VARCHAR2 DEFAULT NULL, p_owner_id NUMBER DEFAULT NULL,
        p_weight NUMBER DEFAULT 1, p_progress NUMBER DEFAULT NULL,
        p_target DATE DEFAULT NULL, p_status VARCHAR2 DEFAULT 'NOT_STARTED',
        p_progress_mode VARCHAR2 DEFAULT NULL
    ) RETURN NUMBER;

    PROCEDURE delete_objective (p_actor_id NUMBER, p_objective_id NUMBER);

    -- ---- key results (measurable targets per objective) ----
    FUNCTION upsert_key_result (
        p_actor_id NUMBER, p_objective_id NUMBER, p_title_en VARCHAR2,
        p_kr_id NUMBER DEFAULT NULL, p_title_ar VARCHAR2 DEFAULT NULL,
        p_unit VARCHAR2 DEFAULT NULL, p_direction VARCHAR2 DEFAULT 'INCREASE',
        p_baseline NUMBER DEFAULT NULL, p_target NUMBER DEFAULT NULL, p_current NUMBER DEFAULT NULL,
        p_weight NUMBER DEFAULT 1, p_target_date DATE DEFAULT NULL, p_status VARCHAR2 DEFAULT 'NOT_STARTED'
    ) RETURN NUMBER;

    PROCEDURE record_kr_value (p_actor_id NUMBER, p_kr_id NUMBER, p_current NUMBER);
    PROCEDURE delete_key_result (p_actor_id NUMBER, p_kr_id NUMBER);

    -- ---- tasks ----
    FUNCTION upsert_task (
        p_actor_id NUMBER, p_team_id NUMBER, p_title VARCHAR2,
        p_task_id NUMBER DEFAULT NULL, p_objective_id NUMBER DEFAULT NULL,
        p_parent_id NUMBER DEFAULT NULL, p_description VARCHAR2 DEFAULT NULL,
        p_priority VARCHAR2 DEFAULT 'MEDIUM', p_status VARCHAR2 DEFAULT 'TODO',
        p_progress NUMBER DEFAULT NULL, p_start DATE DEFAULT NULL, p_due DATE DEFAULT NULL,
        p_est_hours NUMBER DEFAULT NULL
    ) RETURN NUMBER;

    PROCEDURE assign_task   (p_actor_id NUMBER, p_task_id NUMBER, p_user_id NUMBER, p_primary VARCHAR2 DEFAULT 'N');
    PROCEDURE unassign_task (p_actor_id NUMBER, p_task_id NUMBER, p_user_id NUMBER);
    PROCEDURE set_task_status (p_actor_id NUMBER, p_task_id NUMBER, p_new_status VARCHAR2, p_progress NUMBER DEFAULT NULL, p_comment VARCHAR2 DEFAULT NULL);
    FUNCTION  add_task_update (p_actor_id NUMBER, p_task_id NUMBER, p_body VARCHAR2, p_type VARCHAR2 DEFAULT 'COMMENT', p_mentions VARCHAR2 DEFAULT NULL) RETURN NUMBER;

    -- ---- deliverables ----
    FUNCTION upsert_deliverable (
        p_actor_id NUMBER, p_team_id NUMBER, p_title_en VARCHAR2,
        p_deliverable_id NUMBER DEFAULT NULL, p_title_ar VARCHAR2 DEFAULT NULL,
        p_objective_id NUMBER DEFAULT NULL, p_milestone_id NUMBER DEFAULT NULL,
        p_description VARCHAR2 DEFAULT NULL, p_owner_id NUMBER DEFAULT NULL,
        p_type VARCHAR2 DEFAULT NULL, p_status VARCHAR2 DEFAULT 'NOT_STARTED',
        p_progress NUMBER DEFAULT NULL, p_due DATE DEFAULT NULL, p_criteria VARCHAR2 DEFAULT NULL
    ) RETURN NUMBER;

    PROCEDURE set_deliverable_status (p_actor_id NUMBER, p_deliverable_id NUMBER, p_status VARCHAR2, p_reason VARCHAR2 DEFAULT NULL);

    -- ---- RAID / milestones / meetings ----
    FUNCTION upsert_log_item (
        p_actor_id NUMBER, p_team_id NUMBER, p_item_type VARCHAR2, p_title VARCHAR2,
        p_log_id NUMBER DEFAULT NULL, p_description VARCHAR2 DEFAULT NULL,
        p_objective_id NUMBER DEFAULT NULL, p_task_id NUMBER DEFAULT NULL,
        p_owner_id NUMBER DEFAULT NULL, p_severity VARCHAR2 DEFAULT NULL,
        p_likelihood VARCHAR2 DEFAULT NULL, p_impact VARCHAR2 DEFAULT NULL,
        p_status VARCHAR2 DEFAULT 'OPEN', p_mitigation VARCHAR2 DEFAULT NULL, p_due DATE DEFAULT NULL
    ) RETURN NUMBER;

    FUNCTION upsert_milestone (
        p_actor_id NUMBER, p_team_id NUMBER, p_title_en VARCHAR2, p_due DATE,
        p_milestone_id NUMBER DEFAULT NULL, p_title_ar VARCHAR2 DEFAULT NULL,
        p_objective_id NUMBER DEFAULT NULL, p_description VARCHAR2 DEFAULT NULL,
        p_status VARCHAR2 DEFAULT 'PENDING'
    ) RETURN NUMBER;

    FUNCTION upsert_meeting (
        p_actor_id NUMBER, p_team_id NUMBER, p_title VARCHAR2, p_meeting_date DATE,
        p_meeting_id NUMBER DEFAULT NULL, p_location VARCHAR2 DEFAULT NULL,
        p_agenda VARCHAR2 DEFAULT NULL, p_minutes VARCHAR2 DEFAULT NULL,
        p_attendees VARCHAR2 DEFAULT NULL, p_status VARCHAR2 DEFAULT 'PLANNED'
    ) RETURN NUMBER;

    -- ---- documents ----
    FUNCTION add_document (
        p_actor_id      NUMBER,
        p_team_id       NUMBER,
        p_source_type   VARCHAR2,
        p_source_id     NUMBER,
        p_file_name     VARCHAR2,
        p_doc_type_code VARCHAR2 DEFAULT 'OTHER',
        p_mime          VARCHAR2 DEFAULT NULL,
        p_size          NUMBER   DEFAULT NULL,
        p_blob          BLOB     DEFAULT NULL,
        p_notes         VARCHAR2 DEFAULT NULL,
        p_expiry        DATE     DEFAULT NULL
    ) RETURN NUMBER;

    PROCEDURE update_document (
        p_actor_id      NUMBER,
        p_doc_id        NUMBER,
        p_file_name     VARCHAR2,
        p_doc_type_code VARCHAR2 DEFAULT NULL,
        p_notes         VARCHAR2 DEFAULT NULL
    );

    -- ---- health + prefs ----
    PROCEDURE recompute_team_health (p_team_id NUMBER);

    PROCEDURE save_reminder_pref (
        p_user_id NUMBER, p_lead_days NUMBER DEFAULT NULL, p_remind_overdue VARCHAR2 DEFAULT NULL,
        p_inapp VARCHAR2 DEFAULT NULL, p_email VARCHAR2 DEFAULT NULL,
        p_digest VARCHAR2 DEFAULT NULL, p_digest_hour NUMBER DEFAULT NULL
    );

END dct_tm_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_tm_pkg AS

    -- =========================================================================
    -- internal helpers
    -- =========================================================================
    FUNCTION actor_name (p_user_id NUMBER) RETURN VARCHAR2 IS
        v VARCHAR2(200);
    BEGIN
        SELECT username INTO v FROM prod.dct_users WHERE user_id = p_user_id;
        RETURN v;
    EXCEPTION WHEN OTHERS THEN
        RETURN TO_CHAR(p_user_id);
    END actor_name;

    FUNCTION get_setting (p_key VARCHAR2, p_default VARCHAR2) RETURN VARCHAR2 IS
        v VARCHAR2(4000);
    BEGIN
        SELECT s.setting_value INTO v
        FROM   prod.dct_module_settings s
        JOIN   prod.dct_modules m ON m.module_id = s.module_id
        WHERE  m.module_code = 'TASK_MGMT' AND s.setting_key = p_key;
        RETURN NVL(v, p_default);
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RETURN p_default;
    END get_setting;

    FUNCTION gen_code (p_prefix VARCHAR2, p_seq_val NUMBER) RETURN VARCHAR2 IS
    BEGIN
        RETURN p_prefix || '-' || TO_CHAR(SYSDATE, 'YYYY') || '-' || LPAD(p_seq_val, 5, '0');
    END gen_code;

    FUNCTION role_id_of (p_role_code VARCHAR2) RETURN NUMBER IS
        v NUMBER;
    BEGIN
        SELECT tm_role_id INTO v FROM prod.dct_tm_roles WHERE role_code = p_role_code;
        RETURN v;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20404, 'Team role "' || p_role_code || '" not found.');
    END role_id_of;

    PROCEDURE log_status (p_source_type VARCHAR2, p_source_id NUMBER, p_old VARCHAR2, p_new VARCHAR2, p_actor_id NUMBER, p_comment VARCHAR2) IS
    BEGIN
        INSERT INTO prod.dct_request_status_history
            (source_module, source_type, source_id, old_status, new_status, changed_by, comments)
        VALUES ('TM', p_source_type, p_source_id, p_old, p_new, p_actor_id, p_comment);
    END log_status;

    PROCEDURE notify_user (p_user_id NUMBER, p_type VARCHAR2, p_title VARCHAR2, p_body VARCHAR2, p_link VARCHAR2) IS
    BEGIN
        IF p_user_id IS NULL THEN RETURN; END IF;
        prod.dct_notify.send(
            p_recipient_user_id => p_user_id,
            p_notification_type => p_type,
            p_title_en          => p_title,
            p_body_en           => p_body,
            p_module_code       => 'TASK_MGMT',
            p_link_url          => p_link);
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- a notification failure must never roll back the business transaction
    END notify_user;

    -- =========================================================================
    -- permission engine
    -- =========================================================================
    FUNCTION is_tm_admin (p_user_id NUMBER) RETURN VARCHAR2 IS
        v_n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_n
        FROM   prod.dct_user_roles ur
        JOIN   prod.dct_roles r ON r.role_id = ur.role_id
        WHERE  ur.user_id = p_user_id
        AND    r.role_code IN ('TM_ADMIN','SYS_ADMIN')
        AND    ur.is_active = 'Y'
        AND    ur.start_date <= SYSDATE
        AND    (ur.end_date IS NULL OR ur.end_date >= SYSDATE);
        RETURN CASE WHEN v_n > 0 THEN 'Y' ELSE 'N' END;
    END is_tm_admin;

    FUNCTION tm_can (p_user_id NUMBER, p_team_id NUMBER, p_artifact VARCHAR2, p_action VARCHAR2) RETURN VARCHAR2 IS
        v_role_id NUMBER;
        v_flag    VARCHAR2(1);
    BEGIN
        IF p_user_id IS NULL THEN
            RETURN 'N';
        END IF;
        -- system admin bypasses the team matrix
        IF is_tm_admin(p_user_id) = 'Y' THEN
            RETURN 'Y';
        END IF;
        -- active membership in this team determines the team role
        BEGIN
            SELECT tm_role_id INTO v_role_id
            FROM   prod.dct_tm_members
            WHERE  team_id = p_team_id AND user_id = p_user_id AND is_active = 'Y';
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RETURN 'N';
        WHEN TOO_MANY_ROWS THEN
            SELECT MAX(tm_role_id) INTO v_role_id
            FROM   prod.dct_tm_members
            WHERE  team_id = p_team_id AND user_id = p_user_id AND is_active = 'Y';
        END;
        -- per-team override (team_id = p_team_id) wins over template default (team_id NULL)
        BEGIN
            SELECT CASE p_action
                     WHEN 'CREATE' THEN can_create
                     WHEN 'READ'   THEN can_read
                     WHEN 'UPDATE' THEN can_update
                     WHEN 'DELETE' THEN can_delete
                   END
            INTO   v_flag
            FROM   prod.dct_tm_role_perms
            WHERE  tm_role_id = v_role_id
            AND    artifact_type = p_artifact
            AND    NVL(team_id, -1) = (
                       SELECT MAX(NVL(team_id, -1))
                       FROM   prod.dct_tm_role_perms
                       WHERE  tm_role_id = v_role_id
                       AND    artifact_type = p_artifact
                       AND    NVL(team_id, -1) IN (-1, p_team_id));
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RETURN 'N';
        END;
        RETURN NVL(v_flag, 'N');
    END tm_can;

    PROCEDURE require_perm (p_user_id NUMBER, p_team_id NUMBER, p_artifact VARCHAR2, p_action VARCHAR2) IS
    BEGIN
        IF p_user_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20401, 'Not authenticated.');
        END IF;
        IF tm_can(p_user_id, p_team_id, p_artifact, p_action) <> 'Y' THEN
            RAISE_APPLICATION_ERROR(-20403,
                'Permission denied: ' || p_action || ' on ' || p_artifact || ' for this team.');
        END IF;
    END require_perm;

    -- =========================================================================
    -- teams
    -- =========================================================================
    FUNCTION create_team (
        p_actor_id   NUMBER,
        p_name_en    VARCHAR2,
        p_type       VARCHAR2,
        p_class      VARCHAR2,
        p_leader_id  NUMBER,
        p_category   VARCHAR2 DEFAULT NULL,
        p_name_ar    VARCHAR2 DEFAULT NULL,
        p_objective  VARCHAR2 DEFAULT NULL,
        p_purpose    VARCHAR2 DEFAULT NULL,
        p_org_id     NUMBER   DEFAULT NULL,
        p_start      DATE     DEFAULT NULL,
        p_end        DATE     DEFAULT NULL
    ) RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        IF p_actor_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20401, 'Not authenticated.');
        END IF;
        IF p_name_en IS NULL OR LENGTH(TRIM(p_name_en)) = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Team name (EN) is required.');
        END IF;
        IF LENGTH(p_name_en) > 200 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Team name (EN) exceeds 200 characters.');
        END IF;
        IF p_leader_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'Team leader is required.');
        END IF;
        prod.dct_lookup_pkg.validate_lookup('TM_TEAM_TYPE',  p_type);
        prod.dct_lookup_pkg.validate_lookup('TM_TEAM_CLASS', p_class);
        prod.dct_lookup_pkg.validate_lookup('TM_TEAM_CATEGORY', p_category);

        INSERT INTO prod.dct_tm_teams
            (team_code, team_name_en, team_name_ar, objective, purpose,
             team_type, team_class, team_category, leader_user_id, org_id,
             start_date, end_date, status, health_rag, created_by)
        VALUES
            (gen_code('TM', dct_tm_team_seq.NEXTVAL), p_name_en, p_name_ar, p_objective, p_purpose,
             p_type, p_class, p_category, p_leader_id, p_org_id,
             p_start, p_end, 'ACTIVE', 'GREEN', actor_name(p_actor_id))
        RETURNING team_id INTO v_id;

        -- auto-enrol the leader as a LEADER member
        INSERT INTO prod.dct_tm_members (team_id, user_id, tm_role_id, is_active, created_by)
        VALUES (v_id, p_leader_id, role_id_of('LEADER'), 'Y', actor_name(p_actor_id));

        log_status('TEAM', v_id, NULL, 'ACTIVE', p_actor_id, 'Team created');
        RETURN v_id;
    END create_team;

    PROCEDURE update_team (
        p_actor_id   NUMBER,
        p_team_id    NUMBER,
        p_name_en    VARCHAR2 DEFAULT NULL,
        p_name_ar    VARCHAR2 DEFAULT NULL,
        p_type       VARCHAR2 DEFAULT NULL,
        p_class      VARCHAR2 DEFAULT NULL,
        p_category   VARCHAR2 DEFAULT NULL,
        p_objective  VARCHAR2 DEFAULT NULL,
        p_purpose    VARCHAR2 DEFAULT NULL,
        p_status     VARCHAR2 DEFAULT NULL,
        p_leader_id  NUMBER   DEFAULT NULL,
        p_org_id     NUMBER   DEFAULT NULL,
        p_start      DATE     DEFAULT NULL,
        p_end        DATE     DEFAULT NULL
    ) IS
        v_old_status VARCHAR2(30);
    BEGIN
        require_perm(p_actor_id, p_team_id, 'TEAM', 'UPDATE');
        IF p_name_en IS NOT NULL AND LENGTH(p_name_en) > 200 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Team name (EN) exceeds 200 characters.');
        END IF;
        prod.dct_lookup_pkg.validate_lookup('TM_TEAM_TYPE',     p_type);
        prod.dct_lookup_pkg.validate_lookup('TM_TEAM_CLASS',    p_class);
        prod.dct_lookup_pkg.validate_lookup('TM_TEAM_CATEGORY', p_category);
        prod.dct_lookup_pkg.validate_lookup('TM_TEAM_STATUS',   p_status);

        SELECT status INTO v_old_status FROM prod.dct_tm_teams WHERE team_id = p_team_id FOR UPDATE;

        UPDATE prod.dct_tm_teams
        SET    team_name_en  = NVL(p_name_en, team_name_en),
               team_name_ar  = NVL(p_name_ar, team_name_ar),
               objective     = NVL(p_objective, objective),
               purpose       = NVL(p_purpose, purpose),
               team_type     = NVL(p_type, team_type),
               team_class    = NVL(p_class, team_class),
               team_category = NVL(p_category, team_category),
               status        = NVL(p_status, status),
               leader_user_id = NVL(p_leader_id, leader_user_id),
               org_id        = NVL(p_org_id, org_id),
               start_date    = NVL(p_start, start_date),
               end_date      = NVL(p_end, end_date),
               updated_by    = actor_name(p_actor_id)
        WHERE  team_id = p_team_id;

        IF p_status IS NOT NULL AND p_status <> v_old_status THEN
            log_status('TEAM', p_team_id, v_old_status, p_status, p_actor_id, 'Team status changed');
        END IF;
    END update_team;

    -- =========================================================================
    -- members
    -- =========================================================================
    PROCEDURE add_member (p_actor_id NUMBER, p_team_id NUMBER, p_user_id NUMBER, p_role_code VARCHAR2, p_title VARCHAR2 DEFAULT NULL) IS
        v_exists NUMBER;
    BEGIN
        require_perm(p_actor_id, p_team_id, 'MEMBER', 'CREATE');
        BEGIN
            SELECT user_id INTO v_exists FROM prod.dct_users WHERE user_id = p_user_id AND ROWNUM = 1;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20404, 'User ' || p_user_id || ' does not exist.');
        END;
        SELECT COUNT(*) INTO v_exists
        FROM   prod.dct_tm_members WHERE team_id = p_team_id AND user_id = p_user_id AND is_active = 'Y';
        IF v_exists > 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'User is already an active member of this team.');
        END IF;
        INSERT INTO prod.dct_tm_members (team_id, user_id, tm_role_id, title, is_active, created_by)
        VALUES (p_team_id, p_user_id, role_id_of(p_role_code), p_title, 'Y', actor_name(p_actor_id));
        notify_user(p_user_id, 'TM_TEAM_ADDED', 'Added to a team',
                    'You have been added to a Task Management team.', '#teams');
    END add_member;

    PROCEDURE set_member_role (p_actor_id NUMBER, p_team_id NUMBER, p_user_id NUMBER, p_role_code VARCHAR2) IS
    BEGIN
        require_perm(p_actor_id, p_team_id, 'ROLE', 'UPDATE');
        UPDATE prod.dct_tm_members
        SET    tm_role_id = role_id_of(p_role_code), updated_by = actor_name(p_actor_id)
        WHERE  team_id = p_team_id AND user_id = p_user_id AND is_active = 'Y';
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20404, 'Active membership not found for this user/team.');
        END IF;
    END set_member_role;

    PROCEDURE update_member (p_actor_id NUMBER, p_team_id NUMBER, p_user_id NUMBER, p_role_code VARCHAR2, p_title VARCHAR2 DEFAULT NULL) IS
    BEGIN
        require_perm(p_actor_id, p_team_id, 'MEMBER', 'UPDATE');
        UPDATE prod.dct_tm_members
        SET    tm_role_id = role_id_of(p_role_code), title = p_title, updated_by = actor_name(p_actor_id)
        WHERE  team_id = p_team_id AND user_id = p_user_id AND is_active = 'Y';
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20404, 'Active membership not found for this user/team.');
        END IF;
    END update_member;

    PROCEDURE remove_member (p_actor_id NUMBER, p_team_id NUMBER, p_user_id NUMBER) IS
    BEGIN
        require_perm(p_actor_id, p_team_id, 'MEMBER', 'DELETE');
        UPDATE prod.dct_tm_members
        SET    is_active = 'N', leave_date = SYSDATE, updated_by = actor_name(p_actor_id)
        WHERE  team_id = p_team_id AND user_id = p_user_id AND is_active = 'Y';
    END remove_member;

    -- =========================================================================
    -- team-role permission override
    -- =========================================================================
    PROCEDURE set_team_role_perm (
        p_actor_id NUMBER, p_team_id NUMBER, p_role_code VARCHAR2, p_artifact VARCHAR2,
        p_create VARCHAR2, p_read VARCHAR2, p_update VARCHAR2, p_delete VARCHAR2
    ) IS
        v_role_id NUMBER := role_id_of(p_role_code);
    BEGIN
        require_perm(p_actor_id, p_team_id, 'ROLE', 'UPDATE');
        prod.dct_lookup_pkg.validate_lookup('TM_ARTIFACT_TYPE', p_artifact);
        UPDATE prod.dct_tm_role_perms
        SET    can_create = p_create, can_read = p_read, can_update = p_update, can_delete = p_delete,
               updated_by = actor_name(p_actor_id)
        WHERE  tm_role_id = v_role_id AND team_id = p_team_id AND artifact_type = p_artifact;
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO prod.dct_tm_role_perms
                (tm_role_id, team_id, artifact_type, can_create, can_read, can_update, can_delete, created_by)
            VALUES (v_role_id, p_team_id, p_artifact, p_create, p_read, p_update, p_delete, actor_name(p_actor_id));
        END IF;
    END set_team_role_perm;

    -- =========================================================================
    -- objectives
    -- =========================================================================
    -- Roll the objective's progress_pct up from its key results (weighted), but
    -- only when the objective is in AUTO mode. MANUAL objectives keep their value.
    PROCEDURE recompute_objective_progress (p_objective_id NUMBER) IS
        v_mode VARCHAR2(10);
        v_pct  NUMBER;
    BEGIN
        SELECT progress_mode INTO v_mode FROM prod.dct_tm_objectives WHERE objective_id = p_objective_id;
        IF v_mode <> 'AUTO' THEN RETURN; END IF;
        SELECT ROUND(SUM(kr.progress_pct * NVL(kr.weight,1)) / NULLIF(SUM(NVL(kr.weight,1)), 0), 1)
        INTO   v_pct
        FROM   prod.dct_tm_key_result_v kr
        WHERE  kr.objective_id = p_objective_id;
        UPDATE prod.dct_tm_objectives
        SET    progress_pct = NVL(v_pct, 0)
        WHERE  objective_id = p_objective_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END recompute_objective_progress;

    FUNCTION upsert_objective (
        p_actor_id NUMBER, p_team_id NUMBER, p_title_en VARCHAR2,
        p_objective_id NUMBER DEFAULT NULL, p_title_ar VARCHAR2 DEFAULT NULL,
        p_description VARCHAR2 DEFAULT NULL, p_owner_id NUMBER DEFAULT NULL,
        p_weight NUMBER DEFAULT 1, p_progress NUMBER DEFAULT NULL,
        p_target DATE DEFAULT NULL, p_status VARCHAR2 DEFAULT 'NOT_STARTED',
        p_progress_mode VARCHAR2 DEFAULT NULL
    ) RETURN NUMBER IS
        v_id NUMBER := p_objective_id;
    BEGIN
        prod.dct_lookup_pkg.validate_lookup('TM_OBJECTIVE_STATUS', p_status);
        IF p_progress IS NOT NULL AND (p_progress < 0 OR p_progress > 100) THEN
            RAISE_APPLICATION_ERROR(-20001, 'progress_pct must be between 0 and 100.');
        END IF;
        IF p_progress_mode IS NOT NULL AND p_progress_mode NOT IN ('AUTO','MANUAL') THEN
            RAISE_APPLICATION_ERROR(-20001, 'progress_mode must be AUTO or MANUAL.');
        END IF;
        IF v_id IS NULL THEN
            require_perm(p_actor_id, p_team_id, 'OBJECTIVE', 'CREATE');
            INSERT INTO prod.dct_tm_objectives
                (team_id, title_en, title_ar, description, owner_user_id, weight, progress_pct, target_date, status, progress_mode, created_by)
            VALUES (p_team_id, p_title_en, p_title_ar, p_description, p_owner_id, NVL(p_weight,1),
                    NVL(p_progress,0), p_target, p_status, NVL(p_progress_mode,'AUTO'), actor_name(p_actor_id))
            RETURNING objective_id INTO v_id;
        ELSE
            require_perm(p_actor_id, p_team_id, 'OBJECTIVE', 'UPDATE');
            UPDATE prod.dct_tm_objectives
            SET    title_en = p_title_en, title_ar = NVL(p_title_ar, title_ar),
                   description = NVL(p_description, description), owner_user_id = NVL(p_owner_id, owner_user_id),
                   weight = NVL(p_weight, weight), progress_pct = NVL(p_progress, progress_pct),
                   target_date = NVL(p_target, target_date), status = p_status,
                   progress_mode = NVL(p_progress_mode, progress_mode), updated_by = actor_name(p_actor_id)
            WHERE  objective_id = v_id;
            -- if it was switched (back) to AUTO, refresh the roll-up immediately
            recompute_objective_progress(v_id);
        END IF;
        RETURN v_id;
    END upsert_objective;

    PROCEDURE delete_objective (p_actor_id NUMBER, p_objective_id NUMBER) IS
        v_team NUMBER;
    BEGIN
        SELECT team_id INTO v_team FROM prod.dct_tm_objectives WHERE objective_id = p_objective_id;
        require_perm(p_actor_id, v_team, 'OBJECTIVE', 'DELETE');
        DELETE FROM prod.dct_tm_objectives WHERE objective_id = p_objective_id;  -- key results cascade
        recompute_team_health(v_team);
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20404, 'Objective not found.');
    END delete_objective;

    -- =========================================================================
    -- key results (measurable targets per objective)
    -- =========================================================================
    FUNCTION kr_team (p_objective_id NUMBER) RETURN NUMBER IS
        v_team NUMBER;
    BEGIN
        SELECT team_id INTO v_team FROM prod.dct_tm_objectives WHERE objective_id = p_objective_id;
        RETURN v_team;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20404, 'Objective not found.');
    END kr_team;

    FUNCTION upsert_key_result (
        p_actor_id NUMBER, p_objective_id NUMBER, p_title_en VARCHAR2,
        p_kr_id NUMBER DEFAULT NULL, p_title_ar VARCHAR2 DEFAULT NULL,
        p_unit VARCHAR2 DEFAULT NULL, p_direction VARCHAR2 DEFAULT 'INCREASE',
        p_baseline NUMBER DEFAULT NULL, p_target NUMBER DEFAULT NULL, p_current NUMBER DEFAULT NULL,
        p_weight NUMBER DEFAULT 1, p_target_date DATE DEFAULT NULL, p_status VARCHAR2 DEFAULT 'NOT_STARTED'
    ) RETURN NUMBER IS
        v_id   NUMBER := p_kr_id;
        v_obj  NUMBER := p_objective_id;
        v_team NUMBER;
    BEGIN
        IF p_title_en IS NULL OR LENGTH(TRIM(p_title_en)) = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Key result title is required.');
        END IF;
        prod.dct_lookup_pkg.validate_lookup('TM_KR_DIRECTION',     p_direction);
        prod.dct_lookup_pkg.validate_lookup('TM_OBJECTIVE_STATUS', p_status);
        IF v_id IS NULL THEN
            IF p_target IS NULL THEN
                RAISE_APPLICATION_ERROR(-20001, 'Key result target value is required.');
            END IF;
            v_team := kr_team(v_obj);
            require_perm(p_actor_id, v_team, 'OBJECTIVE', 'CREATE');
            INSERT INTO prod.dct_tm_key_results
                (objective_id, title_en, title_ar, unit, direction, baseline_value, target_value,
                 current_value, weight, target_date, status, created_by)
            VALUES (v_obj, p_title_en, p_title_ar, p_unit, NVL(p_direction,'INCREASE'), p_baseline, p_target,
                    NVL(p_current, p_baseline), NVL(p_weight,1), p_target_date, p_status, actor_name(p_actor_id))
            RETURNING kr_id INTO v_id;
        ELSE
            SELECT objective_id INTO v_obj FROM prod.dct_tm_key_results WHERE kr_id = v_id;
            v_team := kr_team(v_obj);
            require_perm(p_actor_id, v_team, 'OBJECTIVE', 'UPDATE');
            UPDATE prod.dct_tm_key_results
            SET    title_en = p_title_en, title_ar = NVL(p_title_ar, title_ar),
                   unit = p_unit, direction = NVL(p_direction, direction),
                   baseline_value = p_baseline, target_value = NVL(p_target, target_value),
                   current_value = p_current, weight = NVL(p_weight, weight),
                   target_date = p_target_date, status = p_status, updated_by = actor_name(p_actor_id)
            WHERE  kr_id = v_id;
        END IF;
        recompute_objective_progress(v_obj);
        RETURN v_id;
    END upsert_key_result;

    PROCEDURE record_kr_value (p_actor_id NUMBER, p_kr_id NUMBER, p_current NUMBER) IS
        v_obj  NUMBER;
        v_team NUMBER;
    BEGIN
        SELECT objective_id INTO v_obj FROM prod.dct_tm_key_results WHERE kr_id = p_kr_id;
        v_team := kr_team(v_obj);
        require_perm(p_actor_id, v_team, 'OBJECTIVE', 'UPDATE');
        UPDATE prod.dct_tm_key_results
        SET    current_value = p_current, updated_by = actor_name(p_actor_id)
        WHERE  kr_id = p_kr_id;
        recompute_objective_progress(v_obj);
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20404, 'Key result not found.');
    END record_kr_value;

    PROCEDURE delete_key_result (p_actor_id NUMBER, p_kr_id NUMBER) IS
        v_obj  NUMBER;
        v_team NUMBER;
    BEGIN
        SELECT objective_id INTO v_obj FROM prod.dct_tm_key_results WHERE kr_id = p_kr_id;
        v_team := kr_team(v_obj);
        require_perm(p_actor_id, v_team, 'OBJECTIVE', 'UPDATE');
        DELETE FROM prod.dct_tm_key_results WHERE kr_id = p_kr_id;
        recompute_objective_progress(v_obj);
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20404, 'Key result not found.');
    END delete_key_result;

    -- =========================================================================
    -- tasks
    -- =========================================================================
    FUNCTION upsert_task (
        p_actor_id NUMBER, p_team_id NUMBER, p_title VARCHAR2,
        p_task_id NUMBER DEFAULT NULL, p_objective_id NUMBER DEFAULT NULL,
        p_parent_id NUMBER DEFAULT NULL, p_description VARCHAR2 DEFAULT NULL,
        p_priority VARCHAR2 DEFAULT 'MEDIUM', p_status VARCHAR2 DEFAULT 'TODO',
        p_progress NUMBER DEFAULT NULL, p_start DATE DEFAULT NULL, p_due DATE DEFAULT NULL,
        p_est_hours NUMBER DEFAULT NULL
    ) RETURN NUMBER IS
        v_id NUMBER := p_task_id;
    BEGIN
        IF p_title IS NULL OR LENGTH(TRIM(p_title)) = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Task title is required.');
        END IF;
        prod.dct_lookup_pkg.validate_lookup('TM_TASK_PRIORITY', p_priority);
        prod.dct_lookup_pkg.validate_lookup('TM_TASK_STATUS',   p_status);
        IF p_progress IS NOT NULL AND (p_progress < 0 OR p_progress > 100) THEN
            RAISE_APPLICATION_ERROR(-20001, 'progress_pct must be between 0 and 100.');
        END IF;
        IF v_id IS NULL THEN
            require_perm(p_actor_id, p_team_id, 'TASK', 'CREATE');
            INSERT INTO prod.dct_tm_tasks
                (task_code, team_id, objective_id, parent_task_id, title, description,
                 priority, status, progress_pct, start_date, due_date, est_hours, created_by)
            VALUES (gen_code('TSK', dct_tm_task_seq.NEXTVAL), p_team_id, p_objective_id, p_parent_id, p_title, p_description,
                    p_priority, p_status, NVL(p_progress,0), p_start, p_due, p_est_hours, actor_name(p_actor_id))
            RETURNING task_id INTO v_id;
        ELSE
            require_perm(p_actor_id, p_team_id, 'TASK', 'UPDATE');
            UPDATE prod.dct_tm_tasks
            SET    objective_id = p_objective_id, parent_task_id = p_parent_id, title = p_title,
                   description = NVL(p_description, description), priority = p_priority, status = p_status,
                   progress_pct = NVL(p_progress, progress_pct),
                   completed_date = CASE WHEN p_status = 'DONE' THEN NVL(completed_date, SYSDATE) ELSE NULL END,
                   start_date = NVL(p_start, start_date), due_date = NVL(p_due, due_date),
                   est_hours = NVL(p_est_hours, est_hours), updated_by = actor_name(p_actor_id)
            WHERE  task_id = v_id;
        END IF;
        recompute_team_health(p_team_id);
        RETURN v_id;
    END upsert_task;

    PROCEDURE assign_task (p_actor_id NUMBER, p_task_id NUMBER, p_user_id NUMBER, p_primary VARCHAR2 DEFAULT 'N') IS
        v_team        NUMBER;
        v_already     NUMBER := 0;
        v_old_primary NUMBER;
        v_msg         VARCHAR2(400);
    BEGIN
        SELECT team_id INTO v_team FROM prod.dct_tm_tasks WHERE task_id = p_task_id;
        require_perm(p_actor_id, v_team, 'TASK', 'UPDATE');

        SELECT COUNT(*) INTO v_already FROM prod.dct_tm_task_assignees
        WHERE task_id = p_task_id AND user_id = p_user_id;

        -- promoting to primary: demote the current primary and record the swap
        v_old_primary := NULL;
        IF NVL(p_primary,'N') = 'Y' THEN
            BEGIN
                SELECT user_id INTO v_old_primary FROM prod.dct_tm_task_assignees
                WHERE task_id = p_task_id AND is_primary = 'Y' AND user_id <> p_user_id AND ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN v_old_primary := NULL;
            END;
            UPDATE prod.dct_tm_task_assignees SET is_primary = 'N'
            WHERE task_id = p_task_id AND is_primary = 'Y' AND user_id <> p_user_id;
        END IF;

        MERGE INTO prod.dct_tm_task_assignees t
        USING (SELECT p_task_id AS task_id, p_user_id AS user_id FROM dual) s
        ON (t.task_id = s.task_id AND t.user_id = s.user_id)
        WHEN NOT MATCHED THEN
            INSERT (task_id, user_id, is_primary, assigned_by)
            VALUES (p_task_id, p_user_id, NVL(p_primary,'N'), actor_name(p_actor_id))
        WHEN MATCHED THEN
            UPDATE SET is_primary = NVL(p_primary, is_primary);

        -- activity-feed entry (assignment / reassignment audit trail)
        IF v_old_primary IS NOT NULL THEN
            v_msg := 'Primary assignee reassigned from ' || actor_name(v_old_primary)
                     || ' to ' || actor_name(p_user_id);
        ELSIF v_already > 0 THEN
            v_msg := actor_name(p_user_id)
                     || CASE WHEN NVL(p_primary,'N')='Y' THEN ' set as primary assignee' ELSE ' assignment updated' END;
        ELSE
            v_msg := 'Assigned to ' || actor_name(p_user_id)
                     || CASE WHEN NVL(p_primary,'N')='Y' THEN ' (primary)' END;
        END IF;
        INSERT INTO prod.dct_tm_task_updates (task_id, update_type, body, created_by, created_by_id)
        VALUES (p_task_id, 'ASSIGN', v_msg, actor_name(p_actor_id), p_actor_id);

        notify_user(p_user_id, 'TM_TASK_ASSIGNED', 'New task assigned',
                    'A task has been assigned to you.', '#myWork');
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20404, 'Task ' || p_task_id || ' not found.');
    END assign_task;

    PROCEDURE unassign_task (p_actor_id NUMBER, p_task_id NUMBER, p_user_id NUMBER) IS
        v_team NUMBER;
    BEGIN
        SELECT team_id INTO v_team FROM prod.dct_tm_tasks WHERE task_id = p_task_id;
        require_perm(p_actor_id, v_team, 'TASK', 'UPDATE');
        DELETE FROM prod.dct_tm_task_assignees WHERE task_id = p_task_id AND user_id = p_user_id;
        IF SQL%ROWCOUNT > 0 THEN
            INSERT INTO prod.dct_tm_task_updates (task_id, update_type, body, created_by, created_by_id)
            VALUES (p_task_id, 'ASSIGN', 'Unassigned ' || actor_name(p_user_id), actor_name(p_actor_id), p_actor_id);
        END IF;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20404, 'Task ' || p_task_id || ' not found.');
    END unassign_task;

    PROCEDURE set_task_status (p_actor_id NUMBER, p_task_id NUMBER, p_new_status VARCHAR2, p_progress NUMBER DEFAULT NULL, p_comment VARCHAR2 DEFAULT NULL) IS
        v_team NUMBER;
        v_old  VARCHAR2(20);
    BEGIN
        SELECT team_id, status INTO v_team, v_old FROM prod.dct_tm_tasks WHERE task_id = p_task_id FOR UPDATE;
        require_perm(p_actor_id, v_team, 'TASK', 'UPDATE');
        prod.dct_lookup_pkg.validate_lookup('TM_TASK_STATUS', p_new_status);
        IF p_progress IS NOT NULL AND (p_progress < 0 OR p_progress > 100) THEN
            RAISE_APPLICATION_ERROR(-20001, 'progress_pct must be between 0 and 100.');
        END IF;
        UPDATE prod.dct_tm_tasks
        SET    status = p_new_status,
               progress_pct = CASE WHEN p_new_status = 'DONE' THEN 100 ELSE NVL(p_progress, progress_pct) END,
               completed_date = CASE WHEN p_new_status = 'DONE' THEN SYSDATE ELSE NULL END,
               updated_by = actor_name(p_actor_id)
        WHERE  task_id = p_task_id;
        log_status('TASK', p_task_id, v_old, p_new_status, p_actor_id, p_comment);
        INSERT INTO prod.dct_tm_task_updates
            (task_id, update_type, body, old_status, new_status, progress_pct, created_by, created_by_id)
        VALUES (p_task_id, 'STATUS', p_comment, v_old, p_new_status, p_progress, actor_name(p_actor_id), p_actor_id);
        recompute_team_health(v_team);
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20404, 'Task ' || p_task_id || ' not found.');
    END set_task_status;

    FUNCTION add_task_update (p_actor_id NUMBER, p_task_id NUMBER, p_body VARCHAR2, p_type VARCHAR2 DEFAULT 'COMMENT', p_mentions VARCHAR2 DEFAULT NULL) RETURN NUMBER IS
        v_team NUMBER;
        v_id   NUMBER;
    BEGIN
        SELECT team_id INTO v_team FROM prod.dct_tm_tasks WHERE task_id = p_task_id;
        require_perm(p_actor_id, v_team, 'TASK', 'READ');
        INSERT INTO prod.dct_tm_task_updates (task_id, update_type, body, mentions, created_by, created_by_id)
        VALUES (p_task_id, NVL(p_type,'COMMENT'), p_body, p_mentions, actor_name(p_actor_id), p_actor_id)
        RETURNING update_id INTO v_id;
        RETURN v_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20404, 'Task ' || p_task_id || ' not found.');
    END add_task_update;

    -- =========================================================================
    -- deliverables
    -- =========================================================================
    FUNCTION upsert_deliverable (
        p_actor_id NUMBER, p_team_id NUMBER, p_title_en VARCHAR2,
        p_deliverable_id NUMBER DEFAULT NULL, p_title_ar VARCHAR2 DEFAULT NULL,
        p_objective_id NUMBER DEFAULT NULL, p_milestone_id NUMBER DEFAULT NULL,
        p_description VARCHAR2 DEFAULT NULL, p_owner_id NUMBER DEFAULT NULL,
        p_type VARCHAR2 DEFAULT NULL, p_status VARCHAR2 DEFAULT 'NOT_STARTED',
        p_progress NUMBER DEFAULT NULL, p_due DATE DEFAULT NULL, p_criteria VARCHAR2 DEFAULT NULL
    ) RETURN NUMBER IS
        v_id NUMBER := p_deliverable_id;
    BEGIN
        prod.dct_lookup_pkg.validate_lookup('TM_DELIVERABLE_TYPE',   p_type);
        prod.dct_lookup_pkg.validate_lookup('TM_DELIVERABLE_STATUS', p_status);
        IF p_progress IS NOT NULL AND (p_progress < 0 OR p_progress > 100) THEN
            RAISE_APPLICATION_ERROR(-20001, 'progress_pct must be between 0 and 100.');
        END IF;
        IF v_id IS NULL THEN
            require_perm(p_actor_id, p_team_id, 'DELIVERABLE', 'CREATE');
            INSERT INTO prod.dct_tm_deliverables
                (deliverable_code, team_id, objective_id, milestone_id, title_en, title_ar, description,
                 owner_user_id, deliverable_type, status, progress_pct, due_date, acceptance_criteria, created_by)
            VALUES (gen_code('DLV', dct_tm_deliv_seq.NEXTVAL), p_team_id, p_objective_id, p_milestone_id, p_title_en, p_title_ar, p_description,
                    p_owner_id, p_type, p_status, NVL(p_progress,0), p_due, p_criteria, actor_name(p_actor_id))
            RETURNING deliverable_id INTO v_id;
        ELSE
            require_perm(p_actor_id, p_team_id, 'DELIVERABLE', 'UPDATE');
            UPDATE prod.dct_tm_deliverables
            SET    title_en = p_title_en, title_ar = NVL(p_title_ar, title_ar),
                   objective_id = p_objective_id, milestone_id = p_milestone_id,
                   description = NVL(p_description, description), owner_user_id = NVL(p_owner_id, owner_user_id),
                   deliverable_type = NVL(p_type, deliverable_type), status = p_status,
                   progress_pct = NVL(p_progress, progress_pct), due_date = NVL(p_due, due_date),
                   acceptance_criteria = NVL(p_criteria, acceptance_criteria), updated_by = actor_name(p_actor_id)
            WHERE  deliverable_id = v_id;
        END IF;
        RETURN v_id;
    END upsert_deliverable;

    PROCEDURE set_deliverable_status (p_actor_id NUMBER, p_deliverable_id NUMBER, p_status VARCHAR2, p_reason VARCHAR2 DEFAULT NULL) IS
        v_team NUMBER;
        v_old  VARCHAR2(30);
    BEGIN
        SELECT team_id, status INTO v_team, v_old FROM prod.dct_tm_deliverables WHERE deliverable_id = p_deliverable_id FOR UPDATE;
        require_perm(p_actor_id, v_team, 'DELIVERABLE', 'UPDATE');
        prod.dct_lookup_pkg.validate_lookup('TM_DELIVERABLE_STATUS', p_status);
        IF p_status = 'REJECTED' AND (p_reason IS NULL OR LENGTH(TRIM(p_reason)) = 0) THEN
            RAISE_APPLICATION_ERROR(-20001, 'A rejection reason is required.');
        END IF;
        UPDATE prod.dct_tm_deliverables
        SET    status = p_status,
               submitted_date = CASE WHEN p_status = 'SUBMITTED' THEN SYSDATE ELSE submitted_date END,
               accepted_date  = CASE WHEN p_status = 'ACCEPTED'  THEN SYSDATE ELSE accepted_date END,
               progress_pct   = CASE WHEN p_status = 'ACCEPTED'  THEN 100 ELSE progress_pct END,
               rejection_reason = CASE WHEN p_status = 'REJECTED' THEN p_reason ELSE rejection_reason END,
               updated_by = actor_name(p_actor_id)
        WHERE  deliverable_id = p_deliverable_id;
        log_status('DELIVERABLE', p_deliverable_id, v_old, p_status, p_actor_id, p_reason);
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20404, 'Deliverable ' || p_deliverable_id || ' not found.');
    END set_deliverable_status;

    -- =========================================================================
    -- RAID / milestones / meetings
    -- =========================================================================
    FUNCTION upsert_log_item (
        p_actor_id NUMBER, p_team_id NUMBER, p_item_type VARCHAR2, p_title VARCHAR2,
        p_log_id NUMBER DEFAULT NULL, p_description VARCHAR2 DEFAULT NULL,
        p_objective_id NUMBER DEFAULT NULL, p_task_id NUMBER DEFAULT NULL,
        p_owner_id NUMBER DEFAULT NULL, p_severity VARCHAR2 DEFAULT NULL,
        p_likelihood VARCHAR2 DEFAULT NULL, p_impact VARCHAR2 DEFAULT NULL,
        p_status VARCHAR2 DEFAULT 'OPEN', p_mitigation VARCHAR2 DEFAULT NULL, p_due DATE DEFAULT NULL
    ) RETURN NUMBER IS
        v_id NUMBER := p_log_id;
    BEGIN
        prod.dct_lookup_pkg.validate_lookup('TM_LOG_ITEM_TYPE', p_item_type);
        prod.dct_lookup_pkg.validate_lookup('TM_LOG_STATUS',    p_status);
        prod.dct_lookup_pkg.validate_lookup('TM_LOG_SEVERITY',  p_severity);
        prod.dct_lookup_pkg.validate_lookup('TM_LOG_SEVERITY',  p_likelihood);
        prod.dct_lookup_pkg.validate_lookup('TM_LOG_SEVERITY',  p_impact);
        IF v_id IS NULL THEN
            require_perm(p_actor_id, p_team_id, 'LOG_ITEM', 'CREATE');
            INSERT INTO prod.dct_tm_log_items
                (log_code, team_id, objective_id, task_id, item_type, title, description, owner_user_id,
                 severity, likelihood, impact, status, mitigation, due_date, created_by)
            VALUES (gen_code('RAID', dct_tm_log_seq.NEXTVAL), p_team_id, p_objective_id, p_task_id, p_item_type, p_title, p_description, p_owner_id,
                    p_severity, p_likelihood, p_impact, p_status, p_mitigation, p_due, actor_name(p_actor_id))
            RETURNING log_id INTO v_id;
        ELSE
            require_perm(p_actor_id, p_team_id, 'LOG_ITEM', 'UPDATE');
            UPDATE prod.dct_tm_log_items
            SET    item_type = p_item_type, title = p_title, description = NVL(p_description, description),
                   objective_id = p_objective_id, task_id = p_task_id, owner_user_id = NVL(p_owner_id, owner_user_id),
                   severity = p_severity, likelihood = p_likelihood, impact = p_impact, status = p_status,
                   mitigation = NVL(p_mitigation, mitigation), due_date = NVL(p_due, due_date),
                   resolved_date = CASE WHEN p_status IN ('CLOSED','MITIGATED') THEN NVL(resolved_date, SYSDATE) ELSE NULL END,
                   updated_by = actor_name(p_actor_id)
            WHERE  log_id = v_id;
        END IF;
        RETURN v_id;
    END upsert_log_item;

    FUNCTION upsert_milestone (
        p_actor_id NUMBER, p_team_id NUMBER, p_title_en VARCHAR2, p_due DATE,
        p_milestone_id NUMBER DEFAULT NULL, p_title_ar VARCHAR2 DEFAULT NULL,
        p_objective_id NUMBER DEFAULT NULL, p_description VARCHAR2 DEFAULT NULL,
        p_status VARCHAR2 DEFAULT 'PENDING'
    ) RETURN NUMBER IS
        v_id NUMBER := p_milestone_id;
    BEGIN
        prod.dct_lookup_pkg.validate_lookup('TM_OBJECTIVE_STATUS', p_status);
        IF v_id IS NULL THEN
            require_perm(p_actor_id, p_team_id, 'MILESTONE', 'CREATE');
            INSERT INTO prod.dct_tm_milestones
                (team_id, objective_id, title_en, title_ar, description, due_date, status, created_by)
            VALUES (p_team_id, p_objective_id, p_title_en, p_title_ar, p_description, p_due, p_status, actor_name(p_actor_id))
            RETURNING milestone_id INTO v_id;
        ELSE
            require_perm(p_actor_id, p_team_id, 'MILESTONE', 'UPDATE');
            UPDATE prod.dct_tm_milestones
            SET    title_en = p_title_en, title_ar = NVL(p_title_ar, title_ar),
                   objective_id = p_objective_id, description = NVL(p_description, description),
                   due_date = NVL(p_due, due_date), status = p_status,
                   achieved_date = CASE WHEN p_status = 'ACHIEVED' THEN NVL(achieved_date, SYSDATE) ELSE NULL END,
                   updated_by = actor_name(p_actor_id)
            WHERE  milestone_id = v_id;
        END IF;
        RETURN v_id;
    END upsert_milestone;

    FUNCTION upsert_meeting (
        p_actor_id NUMBER, p_team_id NUMBER, p_title VARCHAR2, p_meeting_date DATE,
        p_meeting_id NUMBER DEFAULT NULL, p_location VARCHAR2 DEFAULT NULL,
        p_agenda VARCHAR2 DEFAULT NULL, p_minutes VARCHAR2 DEFAULT NULL,
        p_attendees VARCHAR2 DEFAULT NULL, p_status VARCHAR2 DEFAULT 'PLANNED'
    ) RETURN NUMBER IS
        v_id NUMBER := p_meeting_id;
    BEGIN
        prod.dct_lookup_pkg.validate_lookup('TM_LOG_STATUS', p_status);
        IF v_id IS NULL THEN
            require_perm(p_actor_id, p_team_id, 'MEETING', 'CREATE');
            INSERT INTO prod.dct_tm_meetings
                (meeting_code, team_id, title, meeting_date, location, agenda, minutes, attendees, status, created_by)
            VALUES (gen_code('MTG', dct_tm_mtg_seq.NEXTVAL), p_team_id, p_title, p_meeting_date, p_location, p_agenda, p_minutes, p_attendees, p_status, actor_name(p_actor_id))
            RETURNING meeting_id INTO v_id;
        ELSE
            require_perm(p_actor_id, p_team_id, 'MEETING', 'UPDATE');
            UPDATE prod.dct_tm_meetings
            SET    title = p_title, meeting_date = p_meeting_date, location = NVL(p_location, location),
                   agenda = NVL(p_agenda, agenda), minutes = NVL(p_minutes, minutes),
                   attendees = NVL(p_attendees, attendees), status = p_status, updated_by = actor_name(p_actor_id)
            WHERE  meeting_id = v_id;
        END IF;
        RETURN v_id;
    END upsert_meeting;

    -- =========================================================================
    -- health + prefs
    -- =========================================================================
    PROCEDURE recompute_team_health (p_team_id NUMBER) IS
        v_total   NUMBER;
        v_overdue NUMBER;
        v_pct     NUMBER;
        v_amber   NUMBER := TO_NUMBER(get_setting('RAG_AMBER_OVERDUE_PCT', '10'));
        v_red     NUMBER := TO_NUMBER(get_setting('RAG_RED_OVERDUE_PCT', '25'));
        v_rag     VARCHAR2(10);
    BEGIN
        SELECT COUNT(*),
               COUNT(CASE WHEN due_date < TRUNC(SYSDATE) AND status NOT IN ('DONE','CANCELLED') THEN 1 END)
        INTO   v_total, v_overdue
        FROM   prod.dct_tm_tasks WHERE team_id = p_team_id;
        v_pct := CASE WHEN v_total = 0 THEN 0 ELSE ROUND(v_overdue * 100 / v_total) END;
        v_rag := CASE WHEN v_pct >= v_red THEN 'RED' WHEN v_pct >= v_amber THEN 'AMBER' ELSE 'GREEN' END;
        UPDATE prod.dct_tm_teams SET health_rag = v_rag WHERE team_id = p_team_id;
    END recompute_team_health;

    PROCEDURE save_reminder_pref (
        p_user_id NUMBER, p_lead_days NUMBER DEFAULT NULL, p_remind_overdue VARCHAR2 DEFAULT NULL,
        p_inapp VARCHAR2 DEFAULT NULL, p_email VARCHAR2 DEFAULT NULL,
        p_digest VARCHAR2 DEFAULT NULL, p_digest_hour NUMBER DEFAULT NULL
    ) IS
    BEGIN
        IF p_lead_days IS NOT NULL AND (p_lead_days < 0 OR p_lead_days > 365) THEN
            RAISE_APPLICATION_ERROR(-20001, 'lead_days must be between 0 and 365.');
        END IF;
        IF p_digest_hour IS NOT NULL AND (p_digest_hour < 0 OR p_digest_hour > 23) THEN
            RAISE_APPLICATION_ERROR(-20001, 'digest_hour must be between 0 and 23.');
        END IF;
        MERGE INTO prod.dct_tm_reminder_prefs t
        USING (SELECT p_user_id AS user_id FROM dual) s
        ON (t.user_id = s.user_id)
        WHEN NOT MATCHED THEN
            INSERT (user_id, lead_days, remind_overdue, channel_inapp, channel_email, daily_digest, digest_hour)
            VALUES (p_user_id, NVL(p_lead_days, 2), NVL(p_remind_overdue,'Y'), NVL(p_inapp,'Y'),
                    NVL(p_email,'N'), NVL(p_digest,'N'), NVL(p_digest_hour, 7))
        WHEN MATCHED THEN
            UPDATE SET lead_days = NVL(p_lead_days, lead_days), remind_overdue = NVL(p_remind_overdue, remind_overdue),
                       channel_inapp = NVL(p_inapp, channel_inapp), channel_email = NVL(p_email, channel_email),
                       daily_digest = NVL(p_digest, daily_digest), digest_hour = NVL(p_digest_hour, digest_hour);
    END save_reminder_pref;

    -- =========================================================================
    -- documents (unified DCT_DOCUMENTS, source_module = 'TM')
    -- =========================================================================
    FUNCTION add_document (
        p_actor_id      NUMBER,
        p_team_id       NUMBER,
        p_source_type   VARCHAR2,
        p_source_id     NUMBER,
        p_file_name     VARCHAR2,
        p_doc_type_code VARCHAR2 DEFAULT 'OTHER',
        p_mime          VARCHAR2 DEFAULT NULL,
        p_size          NUMBER   DEFAULT NULL,
        p_blob          BLOB     DEFAULT NULL,
        p_notes         VARCHAR2 DEFAULT NULL,
        p_expiry        DATE     DEFAULT NULL
    ) RETURN NUMBER IS
        v_doc_type NUMBER;
        v_id       NUMBER;
    BEGIN
        require_perm(p_actor_id, p_team_id, 'DOCUMENT', 'CREATE');
        IF p_file_name IS NULL OR LENGTH(TRIM(p_file_name)) = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'File name is required.');
        END IF;
        BEGIN
            SELECT doc_type_id INTO v_doc_type FROM prod.dct_document_types
            WHERE doc_type_code = NVL(p_doc_type_code, 'OTHER') AND is_active = 'Y';
        EXCEPTION WHEN NO_DATA_FOUND THEN
            SELECT doc_type_id INTO v_doc_type FROM prod.dct_document_types WHERE doc_type_code = 'OTHER';
        END;
        INSERT INTO prod.dct_documents
            (source_module, source_type, source_id, reference_id, doc_type_id,
             file_name, mime_type, file_size_bytes, file_blob, expiry_date,
             status, notes, created_by)
        VALUES
            ('TM', UPPER(p_source_type), p_source_id, p_team_id, v_doc_type,
             p_file_name, p_mime, p_size, p_blob, p_expiry,
             'ACTIVE', p_notes, p_actor_id)
        RETURNING doc_id INTO v_id;
        RETURN v_id;
    END add_document;

    PROCEDURE update_document (
        p_actor_id NUMBER, p_doc_id NUMBER, p_file_name VARCHAR2,
        p_doc_type_code VARCHAR2 DEFAULT NULL, p_notes VARCHAR2 DEFAULT NULL
    ) IS
        v_team     NUMBER;
        v_doc_type NUMBER;
    BEGIN
        BEGIN
            SELECT reference_id INTO v_team FROM prod.dct_documents
            WHERE doc_id = p_doc_id AND source_module = 'TM' AND is_active = 'Y';
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20404, 'Document ' || p_doc_id || ' not found.');
        END;
        require_perm(p_actor_id, v_team, 'DOCUMENT', 'UPDATE');
        IF p_file_name IS NULL OR LENGTH(TRIM(p_file_name)) = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'File name is required.');
        END IF;
        BEGIN
            SELECT doc_type_id INTO v_doc_type FROM prod.dct_document_types
            WHERE doc_type_code = NVL(p_doc_type_code, 'OTHER') AND is_active = 'Y';
        EXCEPTION WHEN NO_DATA_FOUND THEN
            v_doc_type := NULL;
        END;
        UPDATE prod.dct_documents
        SET    file_name   = p_file_name,
               doc_type_id = NVL(v_doc_type, doc_type_id),
               notes       = p_notes,
               updated_by  = p_actor_id
        WHERE  doc_id = p_doc_id;
    END update_document;

END dct_tm_pkg;
/

SHOW ERRORS PACKAGE prod.dct_tm_pkg
SHOW ERRORS PACKAGE BODY prod.dct_tm_pkg

PROMPT
PROMPT === 04_tm_pkg.sql complete ===
