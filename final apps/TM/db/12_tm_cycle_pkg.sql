-- =============================================================================
-- Task Management Module (App 207) -- Reporting-Cycle engine DCT_TM_CYCLE_PKG
-- File    : 12_tm_cycle_pkg.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @12_tm_cycle_pkg.sql   (after 09/10/11 + 04 core pkg)
-- Purpose : Periodic check-in engine -- per-team cadence, generated reporting periods,
--           per-member progress submissions (with auto-pulled metrics), leader sign-off,
--           and a daily sweep that opens periods, reminds non-submitters, escalates and
--           auto-closes (writing an immutable executive snapshot).
-- Errors  : -20401 not authenticated, -20403 permission denied, -20404 not found,
--           -20001 validation, -20090 invalid lookup. (HTTP mapping in the ORDS layer.)
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PACKAGE prod.dct_tm_cycle_pkg AS

    -- ---- configuration ----
    PROCEDURE save_cycle_config (
        p_actor_id        NUMBER,
        p_team_id         NUMBER,
        p_cadence         VARCHAR2,
        p_custom_days     NUMBER   DEFAULT NULL,
        p_anchor          DATE     DEFAULT NULL,
        p_lead_days       NUMBER   DEFAULT 3,
        p_deadline_offset NUMBER   DEFAULT 0,
        p_reminder_days   VARCHAR2 DEFAULT '3,1',
        p_escalate_after  NUMBER   DEFAULT 1,
        p_submitter_scope VARCHAR2 DEFAULT 'ALL_MEMBERS',
        p_auto_close      VARCHAR2 DEFAULT 'Y'
    );

    -- ---- period generation + lifecycle ----
    FUNCTION  generate_periods (p_team_id NUMBER, p_through DATE DEFAULT NULL) RETURN NUMBER;
    PROCEDURE open_period   (p_period_id NUMBER);
    PROCEDURE close_period  (p_actor_id NUMBER, p_period_id NUMBER);
    PROCEDURE lock_period   (p_actor_id NUMBER, p_period_id NUMBER);
    PROCEDURE leader_signoff(p_actor_id NUMBER, p_period_id NUMBER, p_summary VARCHAR2, p_team_rag VARCHAR2);

    -- ---- member submissions ----
    PROCEDURE build_submission_skeleton (p_period_id NUMBER, p_user_id NUMBER);
    FUNCTION  save_submission (
        p_actor_id        NUMBER,
        p_period_id       NUMBER,
        p_accomplishments VARCHAR2 DEFAULT NULL,
        p_in_progress     VARCHAR2 DEFAULT NULL,
        p_pending         VARCHAR2 DEFAULT NULL,
        p_blockers        VARCHAR2 DEFAULT NULL,
        p_highlights      VARCHAR2 DEFAULT NULL
    ) RETURN NUMBER;
    PROCEDURE submit_submission (p_actor_id NUMBER, p_period_id NUMBER);

    -- ---- scheduler entry points ----
    PROCEDURE run_cycle_sweep (p_as_of DATE DEFAULT TRUNC(SYSDATE));
    PROCEDURE run_job;

END dct_tm_cycle_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_tm_cycle_pkg AS

    -- =========================================================================
    -- helpers
    -- =========================================================================
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

    PROCEDURE notify (p_user_id NUMBER, p_type VARCHAR2, p_title VARCHAR2, p_body VARCHAR2, p_link VARCHAR2) IS
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
    END notify;

    PROCEDURE log_status (p_source_type VARCHAR2, p_source_id NUMBER, p_old VARCHAR2, p_new VARCHAR2, p_actor_id NUMBER, p_comment VARCHAR2) IS
    BEGIN
        -- changed_by is NOT NULL; system/sweep-driven transitions (NULL actor) are not
        -- user-attributable, so skip the history row rather than violating the constraint.
        IF p_actor_id IS NULL THEN RETURN; END IF;
        INSERT INTO prod.dct_request_status_history
            (source_module, source_type, source_id, old_status, new_status, changed_by, comments)
        VALUES ('TM', p_source_type, p_source_id, p_old, p_new, p_actor_id, p_comment);
    END log_status;

    -- period length in days for fixed-width cadences (NULL for calendar cadences)
    FUNCTION fixed_len (p_cadence VARCHAR2, p_custom NUMBER) RETURN NUMBER IS
    BEGIN
        RETURN CASE p_cadence
                 WHEN 'WEEKLY'   THEN 7
                 WHEN 'BIWEEKLY' THEN 14
                 WHEN 'CUSTOM'   THEN NVL(p_custom, 7)
                 ELSE NULL
               END;
    END fixed_len;

    FUNCTION period_label (p_cadence VARCHAR2, p_start DATE) RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE p_cadence
                 WHEN 'MONTHLY'   THEN TO_CHAR(p_start, 'YYYY-MM')
                 WHEN 'QUARTERLY' THEN TO_CHAR(p_start, 'YYYY') || '-Q' || TO_CHAR(p_start, 'Q')
                 WHEN 'WEEKLY'    THEN TO_CHAR(p_start, 'IYYY') || '-W' || TO_CHAR(p_start, 'IW')
                 WHEN 'BIWEEKLY'  THEN TO_CHAR(p_start, 'IYYY') || '-W' || TO_CHAR(p_start, 'IW')
                 ELSE TO_CHAR(p_start, 'YYYY-MM-DD')
               END;
    END period_label;

    -- =========================================================================
    -- configuration
    -- =========================================================================
    PROCEDURE save_cycle_config (
        p_actor_id        NUMBER,
        p_team_id         NUMBER,
        p_cadence         VARCHAR2,
        p_custom_days     NUMBER   DEFAULT NULL,
        p_anchor          DATE     DEFAULT NULL,
        p_lead_days       NUMBER   DEFAULT 3,
        p_deadline_offset NUMBER   DEFAULT 0,
        p_reminder_days   VARCHAR2 DEFAULT '3,1',
        p_escalate_after  NUMBER   DEFAULT 1,
        p_submitter_scope VARCHAR2 DEFAULT 'ALL_MEMBERS',
        p_auto_close      VARCHAR2 DEFAULT 'Y'
    ) IS
        v_name VARCHAR2(200);
    BEGIN
        prod.dct_tm_pkg.require_perm(p_actor_id, p_team_id, 'CYCLE', 'UPDATE');
        prod.dct_lookup_pkg.validate_lookup('TM_CADENCE',         p_cadence);
        prod.dct_lookup_pkg.validate_lookup('TM_SUBMITTER_SCOPE', p_submitter_scope);
        IF p_cadence = 'CUSTOM' AND (p_custom_days IS NULL OR p_custom_days < 1) THEN
            RAISE_APPLICATION_ERROR(-20001, 'Custom cadence requires a positive number of days.');
        END IF;
        v_name := prod.dct_tm_pkg.actor_name(p_actor_id);

        -- one ACTIVE config per team: retire any existing, then insert fresh
        UPDATE prod.dct_tm_cycle_config SET is_active = 'N', updated_by = v_name
        WHERE  team_id = p_team_id AND is_active = 'Y';

        INSERT INTO prod.dct_tm_cycle_config
            (team_id, cadence, custom_days, anchor_date, submission_lead_days,
             deadline_offset_days, reminder_days_before, escalate_after_days,
             submitter_scope, auto_close, is_active, created_by)
        VALUES
            (p_team_id, p_cadence, p_custom_days, NVL(p_anchor, TRUNC(SYSDATE)), NVL(p_lead_days, 3),
             NVL(p_deadline_offset, 0), NVL(p_reminder_days, '3,1'), NVL(p_escalate_after, 1),
             p_submitter_scope, NVL(p_auto_close, 'Y'), 'Y', v_name);
    END save_cycle_config;

    -- =========================================================================
    -- period generation
    -- =========================================================================
    PROCEDURE insert_period (p_team_id NUMBER, p_cfg_id NUMBER, p_cadence VARCHAR2,
                             p_start DATE, p_end DATE, p_lead NUMBER, p_offset NUMBER,
                             p_count IN OUT NUMBER) IS
        v_exists NUMBER;
        v_open   DATE;
        v_due    DATE;
        v_label  VARCHAR2(60);
    BEGIN
        SELECT COUNT(*) INTO v_exists FROM prod.dct_tm_periods
        WHERE  team_id = p_team_id AND period_start = p_start AND period_end = p_end;
        IF v_exists > 0 THEN RETURN; END IF;

        v_open  := GREATEST(p_end - NVL(p_lead, 3), p_start);
        v_due   := p_end + NVL(p_offset, 0);
        v_label := period_label(p_cadence, p_start);
        INSERT INTO prod.dct_tm_periods
            (team_id, cycle_config_id, period_label, period_start, period_end,
             open_date, due_date, status, created_by)
        VALUES
            (p_team_id, p_cfg_id, v_label, p_start, p_end,
             v_open, v_due, 'PENDING', 'SWEEP');
        p_count := p_count + 1;
    END insert_period;

    FUNCTION generate_periods (p_team_id NUMBER, p_through DATE DEFAULT NULL) RETURN NUMBER IS
        v_cfg     prod.dct_tm_cycle_config%ROWTYPE;
        v_through DATE := NVL(p_through, TRUNC(SYSDATE) + 45);
        v_len     NUMBER;
        v_start   DATE;
        v_end     DATE;
        v_n       NUMBER := 0;
        v_guard   PLS_INTEGER := 0;
    BEGIN
        BEGIN
            SELECT * INTO v_cfg FROM prod.dct_tm_cycle_config
            WHERE team_id = p_team_id AND is_active = 'Y';
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RETURN 0;   -- no active cadence -> nothing to generate
        END;

        v_len := fixed_len(v_cfg.cadence, v_cfg.custom_days);

        IF v_len IS NOT NULL THEN
            -- fixed-width windows aligned to the anchor; start at the window covering today
            v_start := v_cfg.anchor_date
                     + v_len * GREATEST(FLOOR((TRUNC(SYSDATE) - v_cfg.anchor_date) / v_len), 0);
            WHILE v_start <= v_through AND v_guard < 500 LOOP
                v_end := v_start + v_len - 1;
                insert_period(p_team_id, v_cfg.cycle_config_id, v_cfg.cadence, v_start, v_end,
                              v_cfg.submission_lead_days, v_cfg.deadline_offset_days, v_n);
                v_start := v_start + v_len;
                v_guard := v_guard + 1;
            END LOOP;
        ELSIF v_cfg.cadence = 'MONTHLY' THEN
            v_start := TRUNC(SYSDATE, 'MM');
            WHILE v_start <= v_through AND v_guard < 120 LOOP
                v_end := LAST_DAY(v_start);
                insert_period(p_team_id, v_cfg.cycle_config_id, v_cfg.cadence, v_start, v_end,
                              v_cfg.submission_lead_days, v_cfg.deadline_offset_days, v_n);
                v_start := ADD_MONTHS(v_start, 1);
                v_guard := v_guard + 1;
            END LOOP;
        ELSIF v_cfg.cadence = 'QUARTERLY' THEN
            v_start := TRUNC(SYSDATE, 'Q');
            WHILE v_start <= v_through AND v_guard < 60 LOOP
                v_end := ADD_MONTHS(v_start, 3) - 1;
                insert_period(p_team_id, v_cfg.cycle_config_id, v_cfg.cadence, v_start, v_end,
                              v_cfg.submission_lead_days, v_cfg.deadline_offset_days, v_n);
                v_start := ADD_MONTHS(v_start, 3);
                v_guard := v_guard + 1;
            END LOOP;
        END IF;

        RETURN v_n;
    END generate_periods;

    -- =========================================================================
    -- metrics auto-pull for a member submission
    -- =========================================================================
    PROCEDURE refresh_metrics (p_submission_id NUMBER) IS
        v_team   NUMBER;
        v_user   NUMBER;
        v_pstart DATE;
        v_pend   DATE;
        v_today  DATE := TRUNC(SYSDATE);
    BEGIN
        SELECT s.team_id, s.user_id, p.period_start, p.period_end
        INTO   v_team, v_user, v_pstart, v_pend
        FROM   prod.dct_tm_submissions s
        JOIN   prod.dct_tm_periods p ON p.period_id = s.period_id
        WHERE  s.submission_id = p_submission_id;

        UPDATE prod.dct_tm_submissions s SET
          tasks_done = (
              SELECT COUNT(*) FROM prod.dct_tm_task_assignees a JOIN prod.dct_tm_tasks t ON t.task_id = a.task_id
              WHERE a.user_id = v_user AND t.team_id = v_team AND t.status = 'DONE'
              AND   t.completed_date >= v_pstart AND t.completed_date < v_pend + 1),
          tasks_late = (
              SELECT COUNT(*) FROM prod.dct_tm_task_assignees a JOIN prod.dct_tm_tasks t ON t.task_id = a.task_id
              WHERE a.user_id = v_user AND t.team_id = v_team AND t.status = 'DONE'
              AND   t.completed_date >= v_pstart AND t.completed_date < v_pend + 1
              AND   t.due_date IS NOT NULL AND TRUNC(t.completed_date) > TRUNC(t.due_date)),
          tasks_overdue = (
              SELECT COUNT(*) FROM prod.dct_tm_task_assignees a JOIN prod.dct_tm_tasks t ON t.task_id = a.task_id
              WHERE a.user_id = v_user AND t.team_id = v_team AND t.status NOT IN ('DONE','CANCELLED')
              AND   t.due_date IS NOT NULL AND t.due_date < v_today),
          tasks_on_track = (
              SELECT COUNT(*) FROM prod.dct_tm_task_assignees a JOIN prod.dct_tm_tasks t ON t.task_id = a.task_id
              WHERE a.user_id = v_user AND t.team_id = v_team AND t.status NOT IN ('DONE','CANCELLED')
              AND   (t.due_date IS NULL OR t.due_date >= v_today)),
          tasks_open = (
              SELECT COUNT(*) FROM prod.dct_tm_task_assignees a JOIN prod.dct_tm_tasks t ON t.task_id = a.task_id
              WHERE a.user_id = v_user AND t.team_id = v_team AND t.status NOT IN ('DONE','CANCELLED')),
          deliverables_done = (
              SELECT COUNT(*) FROM prod.dct_tm_deliverables d
              WHERE d.team_id = v_team AND d.owner_user_id = v_user AND d.status = 'ACCEPTED'
              AND   d.accepted_date >= v_pstart AND d.accepted_date < v_pend + 1),
          objective_progress = (
              SELECT ROUND(AVG(o.progress_pct), 2) FROM prod.dct_tm_objectives o
              WHERE o.team_id = v_team AND o.owner_user_id = v_user),
          new_raid_count = (
              SELECT COUNT(*) FROM prod.dct_tm_log_items l
              WHERE l.team_id = v_team AND l.owner_user_id = v_user
              AND   l.created_at >= v_pstart AND l.created_at < v_pend + 1)
        WHERE s.submission_id = p_submission_id;
    END refresh_metrics;

    PROCEDURE build_submission_skeleton (p_period_id NUMBER, p_user_id NUMBER) IS
        v_team NUMBER;
        v_id   NUMBER;
        v_n    NUMBER;
    BEGIN
        SELECT team_id INTO v_team FROM prod.dct_tm_periods WHERE period_id = p_period_id;
        SELECT COUNT(*) INTO v_n FROM prod.dct_tm_submissions
        WHERE period_id = p_period_id AND user_id = p_user_id;
        IF v_n > 0 THEN RETURN; END IF;

        INSERT INTO prod.dct_tm_submissions (period_id, team_id, user_id, status, created_by)
        VALUES (p_period_id, v_team, p_user_id, 'NOT_STARTED', 'SWEEP')
        RETURNING submission_id INTO v_id;
        refresh_metrics(v_id);
    END build_submission_skeleton;

    -- members who must submit for a team's cadence
    PROCEDURE seed_submitters (p_period_id NUMBER, p_team_id NUMBER, p_scope VARCHAR2, p_cfg_id NUMBER) IS
    BEGIN
        IF p_scope = 'SELECTED' THEN
            FOR u IN (SELECT user_id FROM prod.dct_tm_cycle_submitters WHERE cycle_config_id = p_cfg_id) LOOP
                build_submission_skeleton(p_period_id, u.user_id);
            END LOOP;
        ELSIF p_scope = 'LEADS_ONLY' THEN
            FOR u IN (
                SELECT DISTINCT m.user_id
                FROM   prod.dct_tm_members m JOIN prod.dct_tm_roles r ON r.tm_role_id = m.tm_role_id
                WHERE  m.team_id = p_team_id AND m.is_active = 'Y' AND r.is_leader_role = 'Y'
            ) LOOP
                build_submission_skeleton(p_period_id, u.user_id);
            END LOOP;
        ELSE   -- ALL_MEMBERS
            FOR u IN (SELECT user_id FROM prod.dct_tm_members
                      WHERE team_id = p_team_id AND is_active = 'Y') LOOP
                build_submission_skeleton(p_period_id, u.user_id);
            END LOOP;
        END IF;
    END seed_submitters;

    PROCEDURE open_period (p_period_id NUMBER) IS
        v_team  NUMBER;
        v_cfg   NUMBER;
        v_scope VARCHAR2(20);
        v_label VARCHAR2(60);
        v_due   DATE;
        v_st    VARCHAR2(20);
    BEGIN
        SELECT p.team_id, p.cycle_config_id, p.period_label, p.due_date, p.status
        INTO   v_team, v_cfg, v_label, v_due, v_st
        FROM   prod.dct_tm_periods p WHERE p.period_id = p_period_id;
        IF v_st <> 'PENDING' THEN RETURN; END IF;

        BEGIN
            SELECT submitter_scope INTO v_scope FROM prod.dct_tm_cycle_config WHERE cycle_config_id = v_cfg;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_scope := 'ALL_MEMBERS'; END;

        seed_submitters(p_period_id, v_team, v_scope, v_cfg);

        UPDATE prod.dct_tm_periods SET status = 'OPEN' WHERE period_id = p_period_id;
        log_status('PERIOD', p_period_id, 'PENDING', 'OPEN', NULL, 'Period opened for submissions');

        -- notify each submitter that their check-in window is open
        FOR s IN (SELECT user_id FROM prod.dct_tm_submissions WHERE period_id = p_period_id) LOOP
            notify(s.user_id, 'TM_CYCLE_OPEN',
                   'Progress update due: ' || v_label,
                   'Please submit your progress update by ' || TO_CHAR(v_due, 'DD Mon YYYY') || '.',
                   '#myUpdates');
        END LOOP;
    END open_period;

    -- =========================================================================
    -- member submissions
    -- =========================================================================
    FUNCTION save_submission (
        p_actor_id        NUMBER,
        p_period_id       NUMBER,
        p_accomplishments VARCHAR2 DEFAULT NULL,
        p_in_progress     VARCHAR2 DEFAULT NULL,
        p_pending         VARCHAR2 DEFAULT NULL,
        p_blockers        VARCHAR2 DEFAULT NULL,
        p_highlights      VARCHAR2 DEFAULT NULL
    ) RETURN NUMBER IS
        v_team   NUMBER;
        v_pstat  VARCHAR2(20);
        v_id     NUMBER;
        v_sstat  VARCHAR2(20);
    BEGIN
        IF p_actor_id IS NULL THEN RAISE_APPLICATION_ERROR(-20401, 'Not authenticated.'); END IF;
        SELECT team_id, status INTO v_team, v_pstat FROM prod.dct_tm_periods WHERE period_id = p_period_id;
        IF v_pstat IN ('CLOSED','LOCKED') THEN
            RAISE_APPLICATION_ERROR(-20001, 'This reporting period is closed; submissions can no longer be edited.');
        END IF;
        prod.dct_tm_pkg.require_perm(p_actor_id, v_team, 'SUBMISSION', 'UPDATE');

        -- ensure a row exists for this user (a member may open before the sweep seeds them)
        build_submission_skeleton(p_period_id, p_actor_id);
        SELECT submission_id, status INTO v_id, v_sstat
        FROM   prod.dct_tm_submissions WHERE period_id = p_period_id AND user_id = p_actor_id;

        UPDATE prod.dct_tm_submissions SET
            accomplishments = p_accomplishments,
            in_progress     = p_in_progress,
            pending         = p_pending,
            blockers        = p_blockers,
            highlights      = p_highlights,
            status          = CASE WHEN status = 'NOT_STARTED' THEN 'DRAFT' ELSE status END,
            updated_by      = prod.dct_tm_pkg.actor_name(p_actor_id)
        WHERE submission_id = v_id;

        refresh_metrics(v_id);
        RETURN v_id;
    END save_submission;

    PROCEDURE submit_submission (p_actor_id NUMBER, p_period_id NUMBER) IS
        v_team   NUMBER;
        v_pstat  VARCHAR2(20);
        v_due    DATE;
        v_id     NUMBER;
        v_old    VARCHAR2(20);
        v_new    VARCHAR2(20);
        v_leader NUMBER;
        v_label  VARCHAR2(60);
    BEGIN
        IF p_actor_id IS NULL THEN RAISE_APPLICATION_ERROR(-20401, 'Not authenticated.'); END IF;
        SELECT p.team_id, p.status, p.due_date, p.period_label, te.leader_user_id
        INTO   v_team, v_pstat, v_due, v_label, v_leader
        FROM   prod.dct_tm_periods p JOIN prod.dct_tm_teams te ON te.team_id = p.team_id
        WHERE  p.period_id = p_period_id;
        IF v_pstat IN ('CLOSED','LOCKED') THEN
            RAISE_APPLICATION_ERROR(-20001, 'This reporting period is closed.');
        END IF;
        prod.dct_tm_pkg.require_perm(p_actor_id, v_team, 'SUBMISSION', 'UPDATE');

        build_submission_skeleton(p_period_id, p_actor_id);
        SELECT submission_id, status INTO v_id, v_old
        FROM   prod.dct_tm_submissions WHERE period_id = p_period_id AND user_id = p_actor_id;

        refresh_metrics(v_id);
        v_new := CASE WHEN TRUNC(SYSDATE) > v_due THEN 'LATE' ELSE 'SUBMITTED' END;
        UPDATE prod.dct_tm_submissions
        SET    status = v_new, submitted_at = SYSDATE, updated_by = prod.dct_tm_pkg.actor_name(p_actor_id)
        WHERE  submission_id = v_id;
        log_status('SUBMISSION', v_id, v_old, v_new, p_actor_id, 'Progress update submitted');

        notify(v_leader, 'TM_CYCLE_SUBMITTED',
               'Update submitted: ' || v_label,
               prod.dct_tm_pkg.actor_name(p_actor_id) || ' submitted their progress update.',
               '#teams');
    END submit_submission;

    -- =========================================================================
    -- close / snapshot / lock / sign-off
    -- =========================================================================
    PROCEDURE write_snapshot (p_period_id NUMBER) IS
        v_clob CLOB;
    BEGIN
        apex_json.initialize_clob_output;
        apex_json.open_object;
        FOR p IN (
            SELECT p.period_id, p.team_id, p.period_label, p.period_start, p.period_end, p.due_date,
                   t.team_name_en, t.team_code, t.health_rag
            FROM   prod.dct_tm_periods p JOIN prod.dct_tm_teams t ON t.team_id = p.team_id
            WHERE  p.period_id = p_period_id
        ) LOOP
            apex_json.write('periodId',    p.period_id);
            apex_json.write('teamId',      p.team_id);
            apex_json.write('teamCode',    p.team_code);
            apex_json.write('teamName',    p.team_name_en);
            apex_json.write('periodLabel', p.period_label);
            apex_json.write('periodStart', TO_CHAR(p.period_start, 'YYYY-MM-DD'));
            apex_json.write('periodEnd',   TO_CHAR(p.period_end, 'YYYY-MM-DD'));
            apex_json.write('dueDate',     TO_CHAR(p.due_date, 'YYYY-MM-DD'));
            apex_json.write('healthRag',   NVL(p.health_rag, 'GREEN'));
            apex_json.write('takenAt',     TO_CHAR(SYSDATE, 'YYYY-MM-DD"T"HH24:MI:SS'));
        END LOOP;

        -- per-member submissions
        apex_json.open_array('submissions');
        FOR s IN (
            SELECT s.user_id, u.display_name, s.status,
                   s.accomplishments, s.in_progress, s.pending, s.blockers, s.highlights,
                   s.tasks_done, s.tasks_on_track, s.tasks_late, s.tasks_open, s.tasks_overdue,
                   s.objective_progress, s.deliverables_done, s.new_raid_count,
                   TO_CHAR(s.submitted_at, 'YYYY-MM-DD HH24:MI') AS submitted_at
            FROM   prod.dct_tm_submissions s JOIN prod.dct_users u ON u.user_id = s.user_id
            WHERE  s.period_id = p_period_id
            ORDER  BY u.display_name
        ) LOOP
            apex_json.open_object;
            apex_json.write('userId',        s.user_id);
            apex_json.write('name',          s.display_name);
            apex_json.write('status',        s.status);
            apex_json.write('accomplishments', NVL(s.accomplishments, ''));
            apex_json.write('inProgress',    NVL(s.in_progress, ''));
            apex_json.write('pending',       NVL(s.pending, ''));
            apex_json.write('blockers',      NVL(s.blockers, ''));
            apex_json.write('highlights',    NVL(s.highlights, ''));
            apex_json.write('tasksDone',     NVL(s.tasks_done, 0));
            apex_json.write('tasksOnTrack',  NVL(s.tasks_on_track, 0));
            apex_json.write('tasksLate',     NVL(s.tasks_late, 0));
            apex_json.write('tasksOpen',     NVL(s.tasks_open, 0));
            apex_json.write('tasksOverdue',  NVL(s.tasks_overdue, 0));
            apex_json.write('objectiveProgress', NVL(s.objective_progress, 0));
            apex_json.write('deliverablesDone',  NVL(s.deliverables_done, 0));
            apex_json.write('newRaid',       NVL(s.new_raid_count, 0));
            apex_json.write('submittedAt',   NVL(s.submitted_at, ''));
            apex_json.close_object;
        END LOOP;
        apex_json.close_array;

        -- leader sign-off (if present)
        FOR g IN (SELECT summary, team_rag, TO_CHAR(signed_at,'YYYY-MM-DD HH24:MI') sgn,
                         leader_user_id
                  FROM prod.dct_tm_period_signoff WHERE period_id = p_period_id) LOOP
            apex_json.open_object('signoff');
            apex_json.write('summary', NVL(g.summary, ''));
            apex_json.write('teamRag', NVL(g.team_rag, ''));
            apex_json.write('signedAt', NVL(g.sgn, ''));
            apex_json.close_object;
        END LOOP;

        apex_json.close_object;
        v_clob := apex_json.get_clob_output;
        apex_json.free_output;

        UPDATE prod.dct_tm_periods SET snapshot_json = v_clob WHERE period_id = p_period_id;
    END write_snapshot;

    PROCEDURE close_period (p_actor_id NUMBER, p_period_id NUMBER) IS
        v_team NUMBER;
        v_old  VARCHAR2(20);
        v_label VARCHAR2(60);
    BEGIN
        SELECT team_id, status, period_label INTO v_team, v_old, v_label
        FROM   prod.dct_tm_periods WHERE period_id = p_period_id;
        IF p_actor_id IS NOT NULL THEN
            prod.dct_tm_pkg.require_perm(p_actor_id, v_team, 'PERIOD', 'UPDATE');
        END IF;
        IF v_old = 'LOCKED' THEN
            RAISE_APPLICATION_ERROR(-20001, 'This period is locked.');
        END IF;

        write_snapshot(p_period_id);
        UPDATE prod.dct_tm_periods
        SET    status = 'CLOSED', closed_by = p_actor_id, closed_at = SYSDATE
        WHERE  period_id = p_period_id;
        log_status('PERIOD', p_period_id, v_old, 'CLOSED', p_actor_id, 'Period closed; snapshot captured');

        -- notify members the period is closed
        FOR s IN (SELECT user_id FROM prod.dct_tm_submissions WHERE period_id = p_period_id) LOOP
            notify(s.user_id, 'TM_PERIOD_CLOSED',
                   'Reporting period closed: ' || v_label,
                   'The team status for ' || v_label || ' has been consolidated.',
                   '#teams');
        END LOOP;
    END close_period;

    PROCEDURE lock_period (p_actor_id NUMBER, p_period_id NUMBER) IS
        v_team NUMBER;
        v_old  VARCHAR2(20);
    BEGIN
        SELECT team_id, status INTO v_team, v_old FROM prod.dct_tm_periods WHERE period_id = p_period_id;
        prod.dct_tm_pkg.require_perm(p_actor_id, v_team, 'PERIOD', 'UPDATE');
        IF v_old <> 'CLOSED' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Only a closed period can be locked.');
        END IF;
        UPDATE prod.dct_tm_periods SET status = 'LOCKED' WHERE period_id = p_period_id;
        log_status('PERIOD', p_period_id, v_old, 'LOCKED', p_actor_id, 'Period locked (immutable)');
    END lock_period;

    PROCEDURE leader_signoff (p_actor_id NUMBER, p_period_id NUMBER, p_summary VARCHAR2, p_team_rag VARCHAR2) IS
        v_team NUMBER;
        v_n    NUMBER;
    BEGIN
        SELECT team_id INTO v_team FROM prod.dct_tm_periods WHERE period_id = p_period_id;
        prod.dct_tm_pkg.require_perm(p_actor_id, v_team, 'PERIOD', 'UPDATE');
        IF p_team_rag IS NOT NULL THEN
            prod.dct_lookup_pkg.validate_lookup('TM_RAG', p_team_rag);
        END IF;

        MERGE INTO prod.dct_tm_period_signoff t
        USING (SELECT p_period_id AS pid FROM dual) s
        ON (t.period_id = s.pid)
        WHEN MATCHED THEN
            UPDATE SET summary = p_summary, team_rag = p_team_rag,
                       leader_user_id = p_actor_id, signed_at = SYSDATE
        WHEN NOT MATCHED THEN
            INSERT (period_id, leader_user_id, summary, team_rag)
            VALUES (p_period_id, p_actor_id, p_summary, p_team_rag);

        -- refresh snapshot if the period is already closed so the sign-off is captured
        SELECT COUNT(*) INTO v_n FROM prod.dct_tm_periods
        WHERE period_id = p_period_id AND status IN ('CLOSED','LOCKED');
        IF v_n > 0 THEN write_snapshot(p_period_id); END IF;
    END leader_signoff;

    -- =========================================================================
    -- daily sweep
    -- =========================================================================
    FUNCTION on_offset (p_csv VARCHAR2, p_days NUMBER) RETURN BOOLEAN IS
    BEGIN
        RETURN ',' || REPLACE(p_csv, ' ') || ',' LIKE '%,' || TO_CHAR(p_days) || ',%';
    END on_offset;

    PROCEDURE run_cycle_sweep (p_as_of DATE DEFAULT TRUNC(SYSDATE)) IS
        v_horizon NUMBER := TO_NUMBER(get_setting('CYCLE_HORIZON_DAYS', '45'));
        v_dummy   NUMBER;
    BEGIN
        IF get_setting('CYCLE_ENABLED', 'Y') <> 'Y' THEN
            DBMS_OUTPUT.PUT_LINE('TM cycle sweep skipped (CYCLE_ENABLED=N)');
            RETURN;
        END IF;

        -- 1. generate upcoming periods for every active cadence
        FOR c IN (SELECT team_id FROM prod.dct_tm_cycle_config WHERE is_active = 'Y') LOOP
            v_dummy := generate_periods(c.team_id, p_as_of + v_horizon);
        END LOOP;

        -- 2. open periods whose window has started
        FOR p IN (SELECT period_id FROM prod.dct_tm_periods
                  WHERE status = 'PENDING' AND open_date <= p_as_of) LOOP
            open_period(p.period_id);
        END LOOP;

        -- 3. pre-deadline reminders to non-submitters on each configured offset day
        FOR p IN (
            SELECT p.period_id, p.period_label, p.due_date, NVL(cf.reminder_days_before, '3,1') AS rem
            FROM   prod.dct_tm_periods p
            JOIN   prod.dct_tm_cycle_config cf ON cf.cycle_config_id = p.cycle_config_id
            WHERE  p.status = 'OPEN' AND p.due_date >= p_as_of
        ) LOOP
            IF on_offset(p.rem, p.due_date - p_as_of) THEN
                FOR s IN (SELECT user_id FROM prod.dct_tm_submissions
                          WHERE period_id = p.period_id AND status IN ('NOT_STARTED','DRAFT')) LOOP
                    notify(s.user_id, 'TM_CYCLE_REMINDER',
                           'Reminder: progress update due ' || TO_CHAR(p.due_date, 'DD Mon'),
                           'Your update for ' || p.period_label || ' is due in '
                             || (p.due_date - p_as_of) || ' day(s).',
                           '#myUpdates');
                END LOOP;
            END IF;
        END LOOP;

        -- 4. mark overdue periods DUE + remind stragglers on the due date
        FOR p IN (SELECT period_id, period_label FROM prod.dct_tm_periods
                  WHERE status = 'OPEN' AND due_date < p_as_of) LOOP
            UPDATE prod.dct_tm_periods SET status = 'DUE' WHERE period_id = p.period_id;
            log_status('PERIOD', p.period_id, 'OPEN', 'DUE', NULL, 'Submission deadline passed');
            FOR s IN (SELECT user_id FROM prod.dct_tm_submissions
                      WHERE period_id = p.period_id AND status IN ('NOT_STARTED','DRAFT')) LOOP
                notify(s.user_id, 'TM_CYCLE_OVERDUE',
                       'Overdue: progress update for ' || p.period_label,
                       'Your progress update is overdue. Please submit it as soon as possible.',
                       '#myUpdates');
            END LOOP;
        END LOOP;

        -- 5. escalate non-submitters to the team leader on the escalation day
        FOR e IN (
            SELECT p.period_id, p.period_label, te.leader_user_id,
                   (p_as_of - p.due_date) AS days_over, cf.escalate_after_days, cf.auto_close
            FROM   prod.dct_tm_periods p
            JOIN   prod.dct_tm_teams te ON te.team_id = p.team_id
            JOIN   prod.dct_tm_cycle_config cf ON cf.cycle_config_id = p.cycle_config_id
            WHERE  p.status = 'DUE' AND te.leader_user_id IS NOT NULL
        ) LOOP
            IF e.days_over = e.escalate_after_days THEN
                FOR cnt IN (SELECT COUNT(*) n FROM prod.dct_tm_submissions
                            WHERE period_id = e.period_id AND status IN ('NOT_STARTED','DRAFT')) LOOP
                    IF cnt.n > 0 THEN
                        notify(e.leader_user_id, 'TM_CYCLE_ESCALATION',
                               'Missing updates: ' || e.period_label,
                               cnt.n || ' team member(s) have not submitted their progress update for '
                                 || e.period_label || '.',
                               '#teams');
                    END IF;
                END LOOP;
            END IF;
            -- 6. auto-close after a one-week grace beyond the deadline
            IF e.auto_close = 'Y' AND e.days_over >= 7 THEN
                close_period(NULL, e.period_id);
            END IF;
        END LOOP;

        -- 7. weekly leader digest (UAE work week starts Sunday) -- one summary per
        --    team leader of their team's current open/due reporting period + overdue
        --    tasks. Auto-fans to the mobile app via the DCT_NOTIFICATIONS push trigger.
        IF get_setting('CYCLE_WEEKLY_DIGEST', 'Y') = 'Y'
           AND TO_CHAR(p_as_of, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') = 'SUN' THEN
            FOR d IN (
                SELECT te.leader_user_id, te.team_name_en, p.period_label, p.due_date,
                       (SELECT COUNT(*) FROM prod.dct_tm_submissions s WHERE s.period_id = p.period_id
                               AND s.status IN ('SUBMITTED','LATE')) AS submitted,
                       (SELECT COUNT(*) FROM prod.dct_tm_submissions s WHERE s.period_id = p.period_id) AS total,
                       (SELECT COUNT(*) FROM prod.dct_tm_tasks tk WHERE tk.team_id = te.team_id
                               AND tk.due_date < p_as_of AND tk.status NOT IN ('DONE','CANCELLED')) AS overdue
                FROM   prod.dct_tm_periods p
                JOIN   prod.dct_tm_teams te ON te.team_id = p.team_id
                WHERE  p.status IN ('OPEN','DUE') AND te.leader_user_id IS NOT NULL
            ) LOOP
                notify(d.leader_user_id, 'TM_WEEKLY_DIGEST',
                       'Weekly team digest: ' || d.team_name_en,
                       d.period_label || ' — ' || d.submitted || '/' || d.total
                         || ' updates submitted, ' || d.overdue || ' overdue task(s). Due '
                         || TO_CHAR(d.due_date, 'DD Mon') || '.',
                       '#teams');
            END LOOP;
        END IF;
    END run_cycle_sweep;

    PROCEDURE run_job IS
    BEGIN
        run_cycle_sweep;
    END run_job;

END dct_tm_cycle_pkg;
/

SHOW ERRORS PACKAGE prod.dct_tm_cycle_pkg
SHOW ERRORS PACKAGE BODY prod.dct_tm_cycle_pkg

PROMPT
PROMPT === 12_tm_cycle_pkg.sql complete ===
