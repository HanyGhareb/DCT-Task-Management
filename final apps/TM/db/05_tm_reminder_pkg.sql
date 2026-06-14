-- =============================================================================
-- Task Management Module (App 207) -- Reminder engine DCT_TM_REMINDER_PKG
-- File    : 05_tm_reminder_pkg.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @05_tm_reminder_pkg.sql   (after 01/03/04)
-- Notes   : run_due_reminders() is invoked daily by the DBMS_SCHEDULER job
--           (Layer 5, db/07_tm_jobs.sql). Sends in-app notifications via
--           DCT_NOTIFY for tasks due within each assignee's personal lead_days
--           (pre-reminder preference), overdue tasks, and escalates long-overdue
--           tasks to the team leader. Idempotent per daily run (1 send/task/user).
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PACKAGE prod.dct_tm_reminder_pkg AS
    -- Effective pre-reminder window for a user (personal pref, else module default).
    FUNCTION  get_lead_days (p_user_id NUMBER) RETURN NUMBER;
    -- Daily sweep: due-soon + overdue reminders to assignees, escalation to leaders.
    -- Returns the number of notifications sent.
    FUNCTION  run_due_reminders (p_as_of DATE DEFAULT TRUNC(SYSDATE)) RETURN NUMBER;
    -- Procedure wrapper for the scheduler job.
    PROCEDURE run_job;
END dct_tm_reminder_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_tm_reminder_pkg AS

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

    FUNCTION get_lead_days (p_user_id NUMBER) RETURN NUMBER IS
        v NUMBER;
    BEGIN
        SELECT lead_days INTO v FROM prod.dct_tm_reminder_prefs WHERE user_id = p_user_id;
        RETURN v;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RETURN TO_NUMBER(get_setting('DEFAULT_REMINDER_LEAD_DAYS', '2'));
    END get_lead_days;

    FUNCTION run_due_reminders (p_as_of DATE DEFAULT TRUNC(SYSDATE)) RETURN NUMBER IS
        v_lead       NUMBER;
        v_overdue_ok VARCHAR2(1);
        v_inapp      VARCHAR2(1);
        v_esc        NUMBER := TO_NUMBER(get_setting('OVERDUE_ESCALATION_DAYS', '3'));
        v_sent       NUMBER := 0;
        v_days       NUMBER;
    BEGIN
        -- per-assignee due-soon / overdue reminders
        FOR rec IN (
            SELECT a.user_id, t.task_id, t.title, t.due_date, t.team_id
            FROM   prod.dct_tm_task_assignees a
            JOIN   prod.dct_tm_tasks t ON t.task_id = a.task_id
            WHERE  t.due_date IS NOT NULL
            AND    t.status NOT IN ('DONE','CANCELLED')
        ) LOOP
            BEGIN
                SELECT lead_days, remind_overdue, channel_inapp
                INTO   v_lead, v_overdue_ok, v_inapp
                FROM   prod.dct_tm_reminder_prefs WHERE user_id = rec.user_id;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                v_lead := TO_NUMBER(get_setting('DEFAULT_REMINDER_LEAD_DAYS', '2'));
                v_overdue_ok := 'Y';
                v_inapp := 'Y';
            END;

            IF v_inapp = 'Y' THEN
                IF rec.due_date >= p_as_of AND rec.due_date <= p_as_of + v_lead THEN
                    v_days := TRUNC(rec.due_date) - p_as_of;
                    prod.dct_notify.send(
                        p_recipient_user_id => rec.user_id,
                        p_notification_type => 'TM_TASK_DUE',
                        p_title_en          => 'Task due soon: ' || rec.title,
                        p_body_en           => 'Due in ' || v_days || ' day(s).',
                        p_module_code       => 'TASK_MGMT',
                        p_link_url          => '#myWork');
                    v_sent := v_sent + 1;
                ELSIF rec.due_date < p_as_of AND v_overdue_ok = 'Y' THEN
                    prod.dct_notify.send(
                        p_recipient_user_id => rec.user_id,
                        p_notification_type => 'TM_TASK_OVERDUE',
                        p_title_en          => 'Task overdue: ' || rec.title,
                        p_body_en           => 'This task is ' || (p_as_of - TRUNC(rec.due_date)) || ' day(s) overdue.',
                        p_module_code       => 'TASK_MGMT',
                        p_link_url          => '#myWork');
                    v_sent := v_sent + 1;
                END IF;
            END IF;
        END LOOP;

        -- escalation: tasks overdue beyond the threshold -> notify the team leader
        FOR e IN (
            SELECT t.team_id, te.leader_user_id, COUNT(*) AS n
            FROM   prod.dct_tm_tasks t
            JOIN   prod.dct_tm_teams te ON te.team_id = t.team_id
            WHERE  t.due_date < p_as_of - v_esc
            AND    t.status NOT IN ('DONE','CANCELLED')
            AND    te.leader_user_id IS NOT NULL
            GROUP  BY t.team_id, te.leader_user_id
        ) LOOP
            prod.dct_notify.send(
                p_recipient_user_id => e.leader_user_id,
                p_notification_type => 'TM_OVERDUE_ESCALATION',
                p_title_en          => 'Overdue tasks need attention',
                p_body_en           => e.n || ' task(s) in your team are more than ' || v_esc || ' day(s) overdue.',
                p_module_code       => 'TASK_MGMT',
                p_link_url          => '#dashboard');
            v_sent := v_sent + 1;
        END LOOP;

        DBMS_OUTPUT.PUT_LINE('TM reminders sent: ' || v_sent);
        RETURN v_sent;
    END run_due_reminders;

    PROCEDURE run_job IS
        v NUMBER;
    BEGIN
        v := run_due_reminders;
    END run_job;

END dct_tm_reminder_pkg;
/

SHOW ERRORS PACKAGE prod.dct_tm_reminder_pkg
SHOW ERRORS PACKAGE BODY prod.dct_tm_reminder_pkg

PROMPT
PROMPT === 05_tm_reminder_pkg.sql complete ===
