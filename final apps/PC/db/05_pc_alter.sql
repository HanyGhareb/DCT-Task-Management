-- =============================================================================
-- Petty Cash Module — Schema and seed additions
-- File    : 05_pc_alter.sql
-- Schema  : PROD
-- Run     : After 03_pc_seed.sql (one-time; idempotent — safe to re-run)
-- Changes :
--   1. ADD disbursed_by VARCHAR2(100) to DCT_PETTY_CASH
--   2. MERGE two new module settings: OVERDUE_ALERT_DAYS, DUE_DATE_REMINDER_DAYS
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF

-- -----------------------------------------------------------------------------
-- 1. Add disbursed_by column
--    DDL block is standalone so it auto-commits before the DML block runs.
-- -----------------------------------------------------------------------------
DECLARE
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_exists
    FROM   all_tab_columns
    WHERE  owner = 'PROD'
    AND    table_name  = 'DCT_PETTY_CASH'
    AND    column_name = 'DISBURSED_BY';

    IF v_exists = 0 THEN
        EXECUTE IMMEDIATE
            'ALTER TABLE prod.dct_petty_cash ADD (disbursed_by VARCHAR2(100))';
        DBMS_OUTPUT.PUT_LINE('disbursed_by column added.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('disbursed_by already exists — skip.');
    END IF;
END;
/

-- -----------------------------------------------------------------------------
-- 2. New module settings (MERGE — idempotent)
-- -----------------------------------------------------------------------------
DECLARE
    v_module_id NUMBER;
BEGIN
    SELECT module_id INTO v_module_id
    FROM   prod.dct_modules
    WHERE  module_code = 'PETTY_CASH';

    -- Days after fiscal year end before alerting PC_ADMIN (0 = alert immediately)
    MERGE INTO prod.dct_module_settings tgt
    USING (SELECT v_module_id       AS module_id,
                  'OVERDUE_ALERT_DAYS' AS setting_key FROM dual) src
    ON    (tgt.module_id = src.module_id AND tgt.setting_key = src.setting_key)
    WHEN NOT MATCHED THEN
        INSERT (module_id, setting_key, setting_value, setting_label,
                value_type, default_value, updated_by)
        VALUES (v_module_id, 'OVERDUE_ALERT_DAYS', '0',
                'Overdue Alert — Days After FY End',
                'NUMBER', '0', 'SYSTEM');

    -- Days before due_date to send reminder to employee
    MERGE INTO prod.dct_module_settings tgt
    USING (SELECT v_module_id            AS module_id,
                  'DUE_DATE_REMINDER_DAYS' AS setting_key FROM dual) src
    ON    (tgt.module_id = src.module_id AND tgt.setting_key = src.setting_key)
    WHEN NOT MATCHED THEN
        INSERT (module_id, setting_key, setting_value, setting_label,
                value_type, default_value, updated_by)
        VALUES (v_module_id, 'DUE_DATE_REMINDER_DAYS', '7',
                'Due Date Reminder Days',
                'NUMBER', '7', 'SYSTEM');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Module settings seeded: OVERDUE_ALERT_DAYS, DUE_DATE_REMINDER_DAYS.');
END;
/

PROMPT === 05_pc_alter.sql complete ===
