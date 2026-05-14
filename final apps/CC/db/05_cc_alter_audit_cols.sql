-- =============================================================================
-- Credit Cards Module — Alter audit columns: NUMBER → VARCHAR2(100)
-- File    : 05_cc_alter_audit_cols.sql
-- Schema  : PROD
-- Run     : After 01_cc_ddl.sql (one-time migration; idempotent — safe to re-run)
-- Why     : created_by/updated_by were originally NUMBER NOT NULL with FK refs to
--           dct_users(user_id). The V2 platform pattern stores the APEX session
--           username (APP_USER) as VARCHAR2(100) NULL — no FK, no NOT NULL.
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

        -- Relax NOT NULL (safe even if already NULL; no-op if nullable)
        BEGIN
            EXECUTE IMMEDIATE 'ALTER TABLE prod.' || p_table
                           || ' MODIFY (' || p_col || ' NULL)';
        EXCEPTION WHEN OTHERS THEN
            IF SQLCODE = -1451 THEN NULL; -- already NULL — ok
            ELSE RAISE;
            END IF;
        END;

        -- Add temp VARCHAR2 column
        EXECUTE IMMEDIATE 'ALTER TABLE prod.' || p_table
                       || ' ADD (' || v_tmp || ' VARCHAR2(100))';

        -- Copy numeric value as string (typically user_id; will be NULL for
        -- new rows once APEX starts writing APP_USER strings instead)
        EXECUTE IMMEDIATE 'UPDATE prod.' || p_table
                       || ' SET ' || v_tmp || ' = TO_CHAR(' || p_col || ')'
                       || ' WHERE ' || p_col || ' IS NOT NULL';

        -- Drop old NUMBER column
        EXECUTE IMMEDIATE 'ALTER TABLE prod.' || p_table
                       || ' DROP COLUMN ' || p_col;

        -- Rename temp to canonical name
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
    fix_table('DCT_CREDIT_CARDS',        'FK_DCT_CC_CREATED_BY',   'FK_DCT_CC_UPDATED_BY');
    fix_table('DCT_CC_REQUESTS',         'FK_DCT_CCR_CREATED_BY',  'FK_DCT_CCR_UPDATED_BY');
    fix_table('DCT_CC_DOC_REQUIREMENTS', 'FK_DCT_DOCREQ_CREATED',  'FK_DCT_DOCREQ_UPDATED');
    fix_table('DCT_CC_DELEGATION',       'FK_DCT_CCDEL_CREATED',   'FK_DCT_CCDEL_UPDATED');
    fix_table('DCT_CC_REPLENISHMENTS',   'FK_DCT_CCREIMB_CREATED', 'FK_DCT_CCREIMB_UPDATED');
    fix_table('DCT_CC_PROXIES',          'FK_DCT_CCPRX_CREATED',   'FK_DCT_CCPRX_UPDATED');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('CC audit columns migration complete — 6 tables.');
END;
/

PROMPT === 05_cc_alter_audit_cols.sql complete ===
