-- =============================================================================
-- Petty Cash Module — PL/SQL Package
-- File    : 04_pc_pkg.sql
-- Schema  : PROD
-- Run     : After 03_pc_seed.sql and 05_pc_alter.sql
-- Provides:
--   DCT_PC_PKG  — core automation procedures
--   PC_OVERDUE_ALERTS_JOB     — daily 07:00; alerts PC_ADMIN on overdue TEMPORARY advances
--   PC_DUE_DATE_REMINDERS_JOB — daily 07:00; reminds employees of approaching due dates
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED

-- =============================================================================
-- PACKAGE SPEC
-- =============================================================================
CREATE OR REPLACE PACKAGE prod.dct_pc_pkg AS

    -- Read a single module setting value for PETTY_CASH; returns NULL if missing.
    FUNCTION  get_setting (p_key IN VARCHAR2) RETURN VARCHAR2;

    -- Alert PC_ADMIN users about TEMPORARY advances that are overdue
    -- (fiscal_year < current fiscal year and still ACTIVE).
    -- Called by PC_OVERDUE_ALERTS_JOB daily at 07:00.
    PROCEDURE send_overdue_alerts;

    -- Remind employees of advances whose due_date falls within
    -- DUE_DATE_REMINDER_DAYS from today.
    -- Called by PC_DUE_DATE_REMINDERS_JOB daily at 07:00.
    PROCEDURE send_due_date_reminders;

END dct_pc_pkg;
/

-- =============================================================================
-- PACKAGE BODY
-- =============================================================================
CREATE OR REPLACE PACKAGE BODY prod.dct_pc_pkg AS

    -- -------------------------------------------------------------------------
    -- get_setting
    -- -------------------------------------------------------------------------
    FUNCTION get_setting (p_key IN VARCHAR2) RETURN VARCHAR2 IS
        v_val prod.dct_module_settings.setting_value%TYPE;
    BEGIN
        SELECT ms.setting_value
        INTO   v_val
        FROM   prod.dct_module_settings ms
        JOIN   prod.dct_modules m ON m.module_id = ms.module_id
        WHERE  m.module_code = 'PETTY_CASH'
        AND    ms.setting_key = p_key;
        RETURN v_val;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN NULL;
    END get_setting;

    -- -------------------------------------------------------------------------
    -- send_overdue_alerts
    --
    -- Finds every TEMPORARY petty cash advance where:
    --   status = 'ACTIVE'
    --   fiscal_year < current fiscal year
    --
    -- Current fiscal year is derived from FISCAL_YEAR_START_MONTH:
    --   if today >= YYYY-<start_month>-01 → current FY = YYYY
    --   else                               → current FY = YYYY-1
    --
    -- For each overdue advance, notifies:
    --   - the employee (pc.user_id)
    --   - every user holding the AP_PETTY_CASH_ADMIN role (active assignments)
    --
    -- Duplicate suppression: skips if an ALERT audit log entry with
    -- object_ref = 'OVERDUE' was already logged today for the same pc_id.
    -- -------------------------------------------------------------------------
    PROCEDURE send_overdue_alerts IS
        v_start_month  NUMBER;
        v_current_fy   NUMBER;
        v_today        DATE := TRUNC(SYSDATE);

        CURSOR c_overdue IS
            SELECT pc.pc_id, pc.pc_number, pc.user_id, pc.amount, pc.fiscal_year
            FROM   prod.dct_petty_cash pc
            WHERE  pc.pc_type = 'TEMPORARY'
            AND    pc.status  = 'ACTIVE'
            AND    pc.fiscal_year < v_current_fy
            AND    NOT EXISTS (
                SELECT 1
                FROM   prod.dct_audit_log al
                WHERE  al.object_type = 'DCT_PETTY_CASH'
                AND    al.object_id   = TO_CHAR(pc.pc_id)
                AND    al.object_ref  = 'OVERDUE'
                AND    al.action      = 'ALERT_SENT'
                AND    TRUNC(al.logged_at) = v_today
            );

        v_sent  NUMBER := 0;
    BEGIN
        -- Determine current fiscal year
        v_start_month := NVL(TO_NUMBER(get_setting('FISCAL_YEAR_START_MONTH')), 1);
        IF EXTRACT(MONTH FROM SYSDATE) >= v_start_month THEN
            v_current_fy := EXTRACT(YEAR FROM SYSDATE);
        ELSE
            v_current_fy := EXTRACT(YEAR FROM SYSDATE) - 1;
        END IF;

        FOR r IN c_overdue LOOP
            -- Notify the employee
            prod.dct_notify.send(
                p_recipient_user_id => r.user_id,
                p_notification_type => 'ALERT',
                p_title_en          => 'Overdue Petty Cash: ' || r.pc_number,
                p_body_en           => 'Your petty cash advance ' || r.pc_number
                                       || ' (FY ' || r.fiscal_year
                                       || ', AED ' || TO_CHAR(r.amount,'FM999,999,990.00')
                                       || ') is overdue and has not been cleared. '
                                       || 'Please submit a clearing request immediately.',
                p_module_code       => 'PETTY_CASH'
            );

            -- Notify all active AP_PETTY_CASH_ADMIN users
            FOR admin IN (
                SELECT ur.user_id
                FROM   prod.dct_user_roles  ur
                JOIN   prod.dct_roles       ro ON ro.role_id   = ur.role_id
                WHERE  ro.role_code   = 'AP_PETTY_CASH_ADMIN'
                AND    ur.is_active   = 'Y'
                AND    (ur.end_date IS NULL OR ur.end_date >= SYSDATE)
                AND    ur.user_id    <> r.user_id
            ) LOOP
                prod.dct_notify.send(
                    p_recipient_user_id => admin.user_id,
                    p_notification_type => 'ALERT',
                    p_title_en          => 'Overdue Petty Cash Alert: ' || r.pc_number,
                    p_body_en           => 'Petty cash ' || r.pc_number
                                          || ' (FY ' || r.fiscal_year
                                          || ', AED ' || TO_CHAR(r.amount,'FM999,999,990.00')
                                          || ') is overdue. Employee has been notified.',
                    p_module_code       => 'PETTY_CASH'
                );
            END LOOP;

            -- Audit stamp so we don't re-alert the same day
            prod.dct_audit.log(
                p_action      => 'ALERT_SENT',
                p_object_type => 'DCT_PETTY_CASH',
                p_object_id   => TO_CHAR(r.pc_id),
                p_object_ref  => 'OVERDUE',
                p_module_code => 'PETTY_CASH'
            );

            v_sent := v_sent + 1;
        END LOOP;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('send_overdue_alerts: ' || v_sent || ' alert(s) sent.');
    END send_overdue_alerts;

    -- -------------------------------------------------------------------------
    -- send_due_date_reminders
    --
    -- Finds every ACTIVE advance where:
    --   due_date IS NOT NULL
    --   due_date BETWEEN tomorrow and (today + DUE_DATE_REMINDER_DAYS)
    --   (due_date > today so we don't remind on already-overdue advances)
    --
    -- Notifies the employee once per day (same audit stamp guard as above).
    -- -------------------------------------------------------------------------
    PROCEDURE send_due_date_reminders IS
        v_reminder_days NUMBER;
        v_today         DATE := TRUNC(SYSDATE);

        CURSOR c_due IS
            SELECT pc.pc_id, pc.pc_number, pc.user_id, pc.amount, pc.due_date
            FROM   prod.dct_petty_cash pc
            WHERE  pc.status   = 'ACTIVE'
            AND    pc.due_date IS NOT NULL
            AND    pc.due_date >  v_today
            AND    pc.due_date <= v_today + v_reminder_days
            AND    NOT EXISTS (
                SELECT 1
                FROM   prod.dct_audit_log al
                WHERE  al.object_type = 'DCT_PETTY_CASH'
                AND    al.object_id   = TO_CHAR(pc.pc_id)
                AND    al.object_ref  = 'DUE_REMINDER'
                AND    al.action      = 'ALERT_SENT'
                AND    TRUNC(al.logged_at) = v_today
            );

        v_sent  NUMBER := 0;
        v_days_left NUMBER;
    BEGIN
        v_reminder_days := NVL(TO_NUMBER(get_setting('DUE_DATE_REMINDER_DAYS')), 7);

        IF v_reminder_days <= 0 THEN
            DBMS_OUTPUT.PUT_LINE('send_due_date_reminders: DUE_DATE_REMINDER_DAYS=0 — skipped.');
            RETURN;
        END IF;

        FOR r IN c_due LOOP
            v_days_left := TRUNC(r.due_date) - v_today;

            prod.dct_notify.send(
                p_recipient_user_id => r.user_id,
                p_notification_type => 'REMINDER',
                p_title_en          => 'Petty Cash Due in ' || v_days_left || ' Day(s): ' || r.pc_number,
                p_body_en           => 'Your petty cash advance ' || r.pc_number
                                       || ' (AED ' || TO_CHAR(r.amount,'FM999,999,990.00')
                                       || ') is due on ' || TO_CHAR(r.due_date,'DD-Mon-YYYY')
                                       || '. Please submit a clearing or reimbursement request.',
                p_module_code       => 'PETTY_CASH'
            );

            prod.dct_audit.log(
                p_action      => 'ALERT_SENT',
                p_object_type => 'DCT_PETTY_CASH',
                p_object_id   => TO_CHAR(r.pc_id),
                p_object_ref  => 'DUE_REMINDER',
                p_module_code => 'PETTY_CASH'
            );

            v_sent := v_sent + 1;
        END LOOP;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('send_due_date_reminders: ' || v_sent || ' reminder(s) sent.');
    END send_due_date_reminders;

END dct_pc_pkg;
/

-- =============================================================================
-- DBMS_SCHEDULER JOBS
-- =============================================================================
BEGIN
    -- Drop existing jobs before recreating (safe re-run)
    FOR j IN (
        SELECT job_name FROM all_scheduler_jobs
        WHERE  owner = 'PROD'
        AND    job_name IN ('PC_OVERDUE_ALERTS_JOB','PC_DUE_DATE_REMINDERS_JOB')
    ) LOOP
        DBMS_SCHEDULER.DROP_JOB(
            job_name => 'PROD.' || j.job_name,
            force    => TRUE
        );
    END LOOP;

    -- Daily overdue alert — runs at 07:00
    DBMS_SCHEDULER.CREATE_JOB(
        job_name        => 'PROD.PC_OVERDUE_ALERTS_JOB',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN prod.dct_pc_pkg.send_overdue_alerts; END;',
        repeat_interval => 'FREQ=DAILY;BYHOUR=7;BYMINUTE=0;BYSECOND=0',
        start_date      => SYSTIMESTAMP AT TIME ZONE 'Asia/Dubai',
        enabled         => TRUE,
        comments        => 'Alerts PC_ADMIN and employees about overdue TEMPORARY petty cash advances'
    );

    -- Daily due-date reminder — runs at 07:00
    DBMS_SCHEDULER.CREATE_JOB(
        job_name        => 'PROD.PC_DUE_DATE_REMINDERS_JOB',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN prod.dct_pc_pkg.send_due_date_reminders; END;',
        repeat_interval => 'FREQ=DAILY;BYHOUR=7;BYMINUTE=0;BYSECOND=0',
        start_date      => SYSTIMESTAMP AT TIME ZONE 'Asia/Dubai',
        enabled         => TRUE,
        comments        => 'Reminds employees of petty cash advances approaching their due date'
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Scheduler jobs created: PC_OVERDUE_ALERTS_JOB, PC_DUE_DATE_REMINDERS_JOB');
END;
/

PROMPT
PROMPT === 04_pc_pkg.sql complete ===
PROMPT Package : PROD.DCT_PC_PKG (spec + body)
PROMPT Jobs    : PROD.PC_OVERDUE_ALERTS_JOB, PROD.PC_DUE_DATE_REMINDERS_JOB (daily 07:00)
