-- =============================================================================
-- 24_dct_audit_pkg.sql  --  Audit before/after snapshots + global on/off switch
--
-- Adds PROD.DCT_AUDIT_PKG: a reusable helper every module ORDS handler calls to
-- capture a JSON before/after snapshot of a changed row into
-- DCT_AUDIT_LOG.old_values / .new_values, gated by a single system setting
-- FEATURE_AUDIT_SNAPSHOTS (default 'N' = off; capturing is opt-in).
--
--   snapshots_on -> TRUE only when FEATURE_AUDIT_SNAPSHOTS = 'Y'
--   snap(table, pk_col, pk_val) -> CLOB JSON of the row (NULL when off / on error)
--   log(...)     -> autonomous-transaction audit row; stores old/new only when on
--
-- All module ORDS handlers run as ADMIN under /ords/admin/..., so the single
-- ADMIN synonym created here makes the package callable from every module.
--
-- Rerunnable. Run as ADMIN in a FRESH SQLcl session (synonym rule, ORA-01471).
-- Do NOT set CURRENT_SCHEMA = PROD in this session.
-- =============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. Package spec PROD.DCT_AUDIT_PKG ===

CREATE OR REPLACE PACKAGE prod.dct_audit_pkg AS

    -- "Any scope on" — TRUE when FEATURE_AUDIT_SNAPSHOTS or any per-module
    -- FEATURE_AUDIT_SNAPSHOTS_<CODE> = 'Y'. Used by snap() to skip work when
    -- snapshots are off everywhere.
    FUNCTION snapshots_on RETURN BOOLEAN;

    -- Per-module effective state: the module override
    -- FEATURE_AUDIT_SNAPSHOTS_<UPPER(p_module_code)> when set to Y/N, else the
    -- global FEATURE_AUDIT_SNAPSHOTS default (else off). p_module_code is the
    -- short audit code (ADMIN/PC/DT/HR/FL/CC/AR).
    FUNCTION snapshots_on (p_module_code IN VARCHAR2) RETURN BOOLEAN;

    -- JSON snapshot of one row of prod.<p_table> identified by a single-column
    -- PK. Returns NULL when snapshots are off, the row is absent, or any error
    -- occurs (auditing must never break the underlying write). Binary/large
    -- columns and PASSWORD_HASH are excluded.
    FUNCTION snap (
        p_table  IN VARCHAR2,
        p_pk_col IN VARCHAR2,
        p_pk_val IN VARCHAR2
    ) RETURN CLOB;

    -- Write one audit row (autonomous transaction; never raises). old/new are
    -- persisted only when snapshots_on is TRUE.
    PROCEDURE log (
        p_username    IN VARCHAR2,
        p_action      IN VARCHAR2,
        p_object_type IN VARCHAR2,
        p_object_id   IN VARCHAR2,
        p_module_code IN VARCHAR2 DEFAULT 'ADMIN',
        p_object_ref  IN VARCHAR2 DEFAULT NULL,
        p_old         IN CLOB     DEFAULT NULL,
        p_new         IN CLOB     DEFAULT NULL,
        p_status      IN VARCHAR2 DEFAULT 'SUCCESS',
        p_error       IN VARCHAR2 DEFAULT NULL
    );

END dct_audit_pkg;
/

PROMPT === 2. Package body ===

CREATE OR REPLACE PACKAGE BODY prod.dct_audit_pkg AS

    c_q CONSTANT VARCHAR2(1) := '''';   -- single-quote character

    FUNCTION snapshots_on RETURN BOOLEAN IS
        l_n NUMBER;
    BEGIN
        -- TRUE if the global default or ANY per-module key is 'Y'.
        SELECT COUNT(*) INTO l_n
        FROM   dct_system_settings
        WHERE  setting_key LIKE 'FEATURE_AUDIT_SNAPSHOTS%'
          AND  UPPER(setting_value) = 'Y';
        RETURN (l_n > 0);
    EXCEPTION WHEN OTHERS THEN RETURN FALSE;
    END snapshots_on;

    FUNCTION snapshots_on (p_module_code IN VARCHAR2) RETURN BOOLEAN IS
        l_v VARCHAR2(50);
    BEGIN
        -- Per-module override (Y/N) wins when present.
        IF p_module_code IS NOT NULL THEN
            BEGIN
                SELECT setting_value INTO l_v
                FROM   dct_system_settings
                WHERE  setting_key = 'FEATURE_AUDIT_SNAPSHOTS_' || UPPER(p_module_code)
                  AND  ROWNUM = 1;
                IF UPPER(l_v) IN ('Y','N') THEN
                    RETURN (UPPER(l_v) = 'Y');
                END IF;
            EXCEPTION WHEN NO_DATA_FOUND THEN NULL;   -- inherit the global default
            END;
        END IF;
        -- Inherit the global default.
        SELECT setting_value INTO l_v
        FROM   dct_system_settings
        WHERE  setting_key = 'FEATURE_AUDIT_SNAPSHOTS'
          AND  ROWNUM = 1;
        RETURN (UPPER(NVL(l_v, 'N')) = 'Y');
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN FALSE;
    END snapshots_on;

    FUNCTION snap (
        p_table  IN VARCHAR2,
        p_pk_col IN VARCHAR2,
        p_pk_val IN VARCHAR2
    ) RETURN CLOB IS
        l_cols VARCHAR2(32767);
        l_sql  VARCHAR2(32767);
        l_out  CLOB;
    BEGIN
        IF p_pk_val IS NULL OR NOT snapshots_on THEN
            RETURN NULL;
        END IF;

        -- Build  'COL' VALUE "COL", 'COL2' VALUE "COL2", ...  excluding binaries
        -- and the password hash. (Caught by WHEN OTHERS if the list overflows.)
        SELECT LISTAGG(c_q || column_name || c_q
                       || ' VALUE ' || CHR(34) || column_name || CHR(34), ', ')
                   WITHIN GROUP (ORDER BY column_id)
        INTO   l_cols
        FROM   all_tab_columns
        WHERE  owner = 'PROD'
          AND  table_name = UPPER(p_table)
          AND  data_type NOT IN ('BLOB','CLOB','NCLOB','LONG','LONG RAW','BFILE','RAW')
          AND  column_name <> 'PASSWORD_HASH';

        IF l_cols IS NULL THEN RETURN NULL; END IF;

        l_sql := 'SELECT JSON_OBJECT(' || l_cols || ' RETURNING CLOB)'
              || ' FROM prod.' || p_table
              || ' WHERE ' || p_pk_col || ' = :1 AND ROWNUM = 1';

        EXECUTE IMMEDIATE l_sql INTO l_out USING p_pk_val;
        RETURN l_out;
    EXCEPTION WHEN OTHERS THEN RETURN NULL;
    END snap;

    PROCEDURE log (
        p_username    IN VARCHAR2,
        p_action      IN VARCHAR2,
        p_object_type IN VARCHAR2,
        p_object_id   IN VARCHAR2,
        p_module_code IN VARCHAR2 DEFAULT 'ADMIN',
        p_object_ref  IN VARCHAR2 DEFAULT NULL,
        p_old         IN CLOB     DEFAULT NULL,
        p_new         IN CLOB     DEFAULT NULL,
        p_status      IN VARCHAR2 DEFAULT 'SUCCESS',
        p_error       IN VARCHAR2 DEFAULT NULL
    ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        l_uid dct_users.user_id%TYPE;
        l_on  BOOLEAN := snapshots_on(p_module_code);
    BEGIN
        BEGIN
            SELECT user_id INTO l_uid
            FROM   dct_users
            WHERE  UPPER(username) = UPPER(p_username)
              AND  ROWNUM = 1;
        EXCEPTION WHEN NO_DATA_FOUND THEN l_uid := NULL;
        END;

        INSERT INTO dct_audit_log (
            username, user_id, apex_session_id, module_code,
            action, object_type, object_id, object_ref,
            old_values, new_values, status, error_message
        ) VALUES (
            p_username, l_uid, SYS_CONTEXT('APEX$SESSION','APP_SESSION'), p_module_code,
            p_action, p_object_type, p_object_id, p_object_ref,
            CASE WHEN l_on THEN p_old END,
            CASE WHEN l_on THEN p_new END,
            p_status, p_error
        );
        COMMIT;
    EXCEPTION WHEN OTHERS THEN ROLLBACK;   -- never block the caller's write
    END log;

END dct_audit_pkg;
/

PROMPT === 3. ADMIN synonym (callable from every module's ORDS handlers) ===

CREATE OR REPLACE SYNONYM dct_audit_pkg FOR prod.dct_audit_pkg;

PROMPT === 4. Seed the global default + per-module switches (default N = off) ===

-- Global default (applies to any module without its own switch).
INSERT INTO prod.dct_system_settings
    (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
SELECT 'FEATURE_AUDIT_SNAPSHOTS', 'N', 'BOOLEAN', 'FEATURES',
       'Default audit-snapshot capture (Y/N) for modules without their own switch. Powers the audit-diff modal; off by default.',
       'N', 'SYSTEM'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM prod.dct_system_settings
                  WHERE setting_key = 'FEATURE_AUDIT_SNAPSHOTS');

-- Per-module switches. Key suffix = the audit module code (ADMIN/PC/DT/HR/FL/CC/AR).
-- Y/N here overrides the global default for that module's writes.
INSERT INTO prod.dct_system_settings
    (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
SELECT 'FEATURE_AUDIT_SNAPSHOTS_' || code, 'N', 'BOOLEAN', 'FEATURES',
       'Capture before/after audit snapshots for ' || label || ' writes (Y/N).',
       'N', 'SYSTEM'
FROM (
        SELECT 'ADMIN' AS code, 'Admin'        AS label FROM dual
  UNION ALL SELECT 'PC',    'Petty Cash'             FROM dual
  UNION ALL SELECT 'DT',    'Duty Travel'            FROM dual
  UNION ALL SELECT 'HR',    'HR'                     FROM dual
  UNION ALL SELECT 'FL',    'Freelancers'            FROM dual
  UNION ALL SELECT 'CC',    'Credit Cards'           FROM dual
  UNION ALL SELECT 'AR',    'Accounts Receivable'    FROM dual
) m
WHERE NOT EXISTS (SELECT 1 FROM prod.dct_system_settings
                  WHERE setting_key = 'FEATURE_AUDIT_SNAPSHOTS_' || m.code);

COMMIT;

PROMPT === 5. Verify ===

SELECT object_name, object_type, status
FROM   all_objects
WHERE  owner = 'PROD' AND object_name = 'DCT_AUDIT_PKG'
ORDER  BY object_type;

SELECT setting_key, setting_value, value_type, category
FROM   prod.dct_system_settings
WHERE  setting_key LIKE 'FEATURE_AUDIT_SNAPSHOTS%'
ORDER  BY setting_key;

PROMPT === 24_dct_audit_pkg.sql complete ===
