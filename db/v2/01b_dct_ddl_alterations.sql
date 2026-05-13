-- =============================================================================
-- i-Finance V2 — Shared DDL Alterations (Sprint 2 additions)
-- File    : 01b_dct_ddl_alterations.sql
-- Schema  : PROD
-- DB      : Oracle 23ai
-- =============================================================================
-- Adds to the existing Sprint 1 shared framework:
--   1. DCT_APPROVAL_TEMPLATES  — new REQUEST_TYPE column + active unique index
--   2. DCT_APPROVAL_STEPS      — new condition columns (CONDITION_TYPE, etc.)
--   3. DCT_MODULE_SETTINGS     — new table (per-module admin-configurable settings)
-- =============================================================================
-- Safe to re-run: each ALTER uses exception handlers to skip if already done.
-- =============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED

ALTER SESSION SET CURRENT_SCHEMA = PROD;

-- =============================================================================
-- 1. DCT_APPROVAL_TEMPLATES — add REQUEST_TYPE
-- =============================================================================
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE dct_approval_templates
        ADD request_type VARCHAR2(50)
    ';
    DBMS_OUTPUT.PUT_LINE('OK  dct_approval_templates.request_type added');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1430 THEN  -- column already exists
            DBMS_OUTPUT.PUT_LINE('OK  dct_approval_templates.request_type already exists — skipped');
        ELSE RAISE;
        END IF;
END;
/

-- Unique index: one active template per module + request_type
DECLARE
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_exists
    FROM   user_indexes
    WHERE  index_name = 'UIX_DCT_TMPL_ACTIVE';

    IF v_exists = 0 THEN
        EXECUTE IMMEDIATE '
            CREATE UNIQUE INDEX uix_dct_tmpl_active
            ON dct_approval_templates (
                CASE WHEN is_active = ''Y'' THEN module_id    END,
                CASE WHEN is_active = ''Y'' THEN request_type END
            )
        ';
        DBMS_OUTPUT.PUT_LINE('OK  uix_dct_tmpl_active created');
    ELSE
        DBMS_OUTPUT.PUT_LINE('OK  uix_dct_tmpl_active already exists — skipped');
    END IF;
END;
/

COMMENT ON COLUMN dct_approval_templates.request_type IS
    'Module-specific request type this workflow applies to (e.g. PETTY_CASH, REIMBURSEMENT, CLEARING, PAYMENT_REQUEST)';

-- =============================================================================
-- 2. DCT_APPROVAL_STEPS — add condition columns
-- =============================================================================
DECLARE
    PROCEDURE add_col (p_col IN VARCHAR2, p_def IN VARCHAR2) IS
    BEGIN
        EXECUTE IMMEDIATE 'ALTER TABLE dct_approval_steps ADD ' || p_col || ' ' || p_def;
        DBMS_OUTPUT.PUT_LINE('OK  dct_approval_steps.' || p_col || ' added');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -1430 THEN
                DBMS_OUTPUT.PUT_LINE('OK  dct_approval_steps.' || p_col || ' already exists — skipped');
            ELSE RAISE;
            END IF;
    END;
BEGIN
    add_col('condition_type',   'VARCHAR2(20) DEFAULT ''ALWAYS'' NOT NULL');
    add_col('amount_operator',  'VARCHAR2(5)');
    add_col('amount_threshold', 'NUMBER');
    add_col('type_filter',      'VARCHAR2(50)');
    add_col('custom_condition', 'VARCHAR2(500)');
END;
/

-- CHECK constraints for new columns
DECLARE
    PROCEDURE add_check (p_constraint IN VARCHAR2, p_definition IN VARCHAR2) IS
    BEGIN
        EXECUTE IMMEDIATE 'ALTER TABLE dct_approval_steps ADD CONSTRAINT ' || p_constraint || ' ' || p_definition;
        DBMS_OUTPUT.PUT_LINE('OK  constraint ' || p_constraint || ' added');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -2264 THEN  -- constraint already exists
                DBMS_OUTPUT.PUT_LINE('OK  constraint ' || p_constraint || ' already exists — skipped');
            ELSE RAISE;
            END IF;
    END;
BEGIN
    add_check('chk_dct_step_cond', 'CHECK (condition_type IN (''ALWAYS'',''AMOUNT'',''TYPE_FILTER'',''COMBINED'',''CUSTOM''))');
    add_check('chk_dct_step_op',   'CHECK (amount_operator IN (''>'',''>='',''<'',''<='',''='') OR amount_operator IS NULL)');
END;
/

COMMENT ON COLUMN dct_approval_steps.condition_type    IS 'ALWAYS=always fires | AMOUNT=amount threshold | TYPE_FILTER=request type value | COMBINED=amount+type | CUSTOM=PL/SQL function';
COMMENT ON COLUMN dct_approval_steps.amount_operator   IS '>|>=|<|<=|= — comparison operator for amount-based conditions';
COMMENT ON COLUMN dct_approval_steps.amount_threshold  IS 'AED threshold for amount-based conditions';
COMMENT ON COLUMN dct_approval_steps.type_filter       IS 'Generic type value to match (e.g. PERMANENT, TEMPORARY, URGENT)';
COMMENT ON COLUMN dct_approval_steps.custom_condition  IS 'Name of a PL/SQL boolean function(p_instance_id IN NUMBER) RETURN BOOLEAN for module-specific conditions';

-- =============================================================================
-- 3. DCT_MODULE_SETTINGS — new table
-- =============================================================================
DECLARE
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_exists
    FROM   user_tables
    WHERE  table_name = 'DCT_MODULE_SETTINGS';

    IF v_exists = 0 THEN
        EXECUTE IMMEDIATE '
            CREATE TABLE dct_module_settings (
                setting_id          NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                module_id           NUMBER         NOT NULL,
                setting_key         VARCHAR2(100)  NOT NULL,
                setting_value       VARCHAR2(500),
                setting_label       VARCHAR2(200)  NOT NULL,
                setting_description VARCHAR2(1000),
                value_type          VARCHAR2(20)   DEFAULT ''TEXT'' NOT NULL,
                allowed_values      VARCHAR2(500),
                default_value       VARCHAR2(500),
                effective_date      DATE           DEFAULT SYSDATE,
                updated_by          VARCHAR2(100),
                updated_at          TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
                CONSTRAINT uq_dct_modsetting      UNIQUE      (module_id, setting_key),
                CONSTRAINT chk_dct_modset_valtype CHECK       (value_type IN (''BOOLEAN'',''NUMBER'',''TEXT'',''SELECT'')),
                CONSTRAINT fk_dct_modset_module   FOREIGN KEY (module_id) REFERENCES dct_modules(module_id)
            )
        ';
        DBMS_OUTPUT.PUT_LINE('OK  dct_module_settings created');

        EXECUTE IMMEDIATE 'CREATE INDEX ix_dct_modset_module ON dct_module_settings(module_id)';
        DBMS_OUTPUT.PUT_LINE('OK  ix_dct_modset_module created');

        EXECUTE IMMEDIATE '
            CREATE OR REPLACE TRIGGER trg_dct_modset_upd
                BEFORE UPDATE ON dct_module_settings FOR EACH ROW
            BEGIN
                :NEW.updated_at := SYSTIMESTAMP;
                :NEW.updated_by := NVL(SYS_CONTEXT(''APEX$SESSION'',''APP_USER''), SYS_CONTEXT(''USERENV'',''SESSION_USER''));
            END;
        ';
        DBMS_OUTPUT.PUT_LINE('OK  trg_dct_modset_upd created');
    ELSE
        DBMS_OUTPUT.PUT_LINE('OK  dct_module_settings already exists — skipped');
    END IF;
END;
/

COMMENT ON TABLE  dct_module_settings IS 'i-Finance V2: Per-module admin-configurable settings. Each module seeds its own keys; Admin edits values at runtime. Different from DCT_SYSTEM_SETTINGS which holds platform-wide config.';
COMMENT ON COLUMN dct_module_settings.value_type      IS 'BOOLEAN=Y/N | NUMBER=numeric | TEXT=free text | SELECT=one of allowed_values';
COMMENT ON COLUMN dct_module_settings.allowed_values  IS 'Pipe-separated valid options for SELECT type (e.g. HARD|SOFT)';
COMMENT ON COLUMN dct_module_settings.effective_date  IS 'Setting applies to new records created on or after this date; does not retroactively affect in-progress records';

COMMIT;

PROMPT ============================================================
PROMPT  01b_dct_ddl_alterations.sql complete.
PROMPT ============================================================
