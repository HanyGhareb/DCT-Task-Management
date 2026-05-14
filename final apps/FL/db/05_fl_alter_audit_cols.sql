-- =============================================================================
-- Freelancers Module — Alter audit columns: NUMBER → VARCHAR2(100)
-- File    : 05_fl_alter_audit_cols.sql
-- Schema  : PROD
-- Run     : After 01_fl_ddl.sql (one-time migration; idempotent — safe to re-run)
-- Why     : created_by/updated_by were originally NUMBER NULL with FK refs to
--           dct_users(user_id). The V2 platform pattern stores the APEX session
--           username (APP_USER) as VARCHAR2(100) NULL — no FK.
-- Technique: drop FK → relax NOT NULL → add temp VARCHAR2 col → copy data →
--            drop old col → rename temp. Works with or without existing rows.
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
    PROCEDURE drop_fk (p_table VARCHAR2, p_constraint VARCHAR2) IS
    BEGIN
        EXECUTE IMMEDIATE 'ALTER TABLE prod.' || p_table
                       || ' DROP CONSTRAINT ' || p_constraint;
        DBMS_OUTPUT.PUT_LINE('  dropped constraint ' || p_constraint);
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE IN (-2443, -2441) THEN
            DBMS_OUTPUT.PUT_LINE('  ' || p_constraint || ' already gone — skip');
        ELSE RAISE;
        END IF;
    END;

    PROCEDURE migrate_col (p_table VARCHAR2, p_col VARCHAR2) IS
        v_type VARCHAR2(30);
        v_tmp  VARCHAR2(50) := p_col || '_V_';
    BEGIN
        SELECT data_type INTO v_type
        FROM   all_tab_columns
        WHERE  owner = 'PROD' AND table_name = p_table AND column_name = p_col;

        IF v_type = 'VARCHAR2' THEN
            DBMS_OUTPUT.PUT_LINE('  ' || p_table || '.' || p_col
                                 || ' already VARCHAR2 — skip');
            RETURN;
        END IF;

        BEGIN
            EXECUTE IMMEDIATE 'ALTER TABLE prod.' || p_table
                           || ' MODIFY (' || p_col || ' NULL)';
        EXCEPTION WHEN OTHERS THEN
            IF SQLCODE = -1451 THEN NULL; -- already NULL — ok
            ELSE RAISE;
            END IF;
        END;

        EXECUTE IMMEDIATE 'ALTER TABLE prod.' || p_table
                       || ' ADD (' || v_tmp || ' VARCHAR2(100))';

        EXECUTE IMMEDIATE 'UPDATE prod.' || p_table
                       || ' SET ' || v_tmp || ' = TO_CHAR(' || p_col || ')'
                       || ' WHERE ' || p_col || ' IS NOT NULL';

        EXECUTE IMMEDIATE 'ALTER TABLE prod.' || p_table
                       || ' DROP COLUMN ' || p_col;

        EXECUTE IMMEDIATE 'ALTER TABLE prod.' || p_table
                       || ' RENAME COLUMN ' || v_tmp || ' TO ' || p_col;

        DBMS_OUTPUT.PUT_LINE('  ' || p_table || '.' || p_col
                             || ' migrated to VARCHAR2(100)');
    EXCEPTION WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('  ' || p_table || '.' || p_col || ' not found — skip');
    END;

    PROCEDURE fix_table (
        p_table  VARCHAR2,
        p_fk_cby VARCHAR2,
        p_fk_uby VARCHAR2
    ) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- ' || p_table || ' ---');
        drop_fk(p_table, p_fk_cby);
        drop_fk(p_table, p_fk_uby);
        migrate_col(p_table, 'CREATED_BY');
        migrate_col(p_table, 'UPDATED_BY');
    END;
BEGIN
    fix_table('DCT_FL_REGISTRATIONS',          'FK_DCT_FL_REG_CBY',   'FK_DCT_FL_REG_UBY');
    fix_table('DCT_FL_FREELANCERS',            'FK_DCT_FL_FRL_CBY',   'FK_DCT_FL_FRL_UBY');
    fix_table('DCT_FL_BANK_ACCOUNTS',          'FK_DCT_FL_BA_CBY',    'FK_DCT_FL_BA_UBY');
    fix_table('DCT_FL_DOCUMENTS',              'FK_DCT_FL_DOC_CBY',   'FK_DCT_FL_DOC_UBY');
    fix_table('DCT_FL_CONTRACTS',              'FK_DCT_FL_CON_CBY',   'FK_DCT_FL_CON_UBY');
    fix_table('DCT_FL_CONTRACT_AMENDMENTS',    'FK_DCT_FL_AMEND_CBY', 'FK_DCT_FL_AMEND_UBY');
    fix_table('DCT_FL_PAYMENT_VOUCHERS',       'FK_DCT_FL_VCHR_CBY',  'FK_DCT_FL_VCHR_UBY');
    fix_table('DCT_FL_DELIVERABLES',           'FK_DCT_FL_DELIV_CBY', 'FK_DCT_FL_DELIV_UBY');
    fix_table('DCT_FL_CONTRACT_RENEWALS',      'FK_DCT_FL_RNL_CBY',   'FK_DCT_FL_RNL_UBY');
    fix_table('DCT_FL_PROFILE_CHANGE_REQUESTS','FK_DCT_FL_PCR_CBY',   'FK_DCT_FL_PCR_UBY');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('FL audit columns migration complete — 10 tables.');
END;
/

PROMPT === 05_fl_alter_audit_cols.sql complete ===
