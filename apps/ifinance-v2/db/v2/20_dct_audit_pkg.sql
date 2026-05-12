-- =============================================================================
-- Sprint 5 — DCT_AUDIT Package
-- Centralised, autonomous-transaction audit logging
-- =============================================================================
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback

-- Drop any stray copies created in wrong schema during development
BEGIN
    EXECUTE IMMEDIATE 'DROP PACKAGE ADMIN.dct_audit';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

prompt ============================================================
prompt  DCT_AUDIT — Spec
prompt ============================================================

CREATE OR REPLACE PACKAGE prod.dct_audit AS

    -- Log any application action
    PROCEDURE log (
        p_action       IN VARCHAR2,
        p_object_type  IN VARCHAR2 DEFAULT NULL,
        p_object_id    IN VARCHAR2 DEFAULT NULL,
        p_object_ref   IN VARCHAR2 DEFAULT NULL,
        p_old_values   IN CLOB     DEFAULT NULL,
        p_new_values   IN CLOB     DEFAULT NULL,
        p_module_code  IN VARCHAR2 DEFAULT NULL,
        p_status       IN VARCHAR2 DEFAULT 'SUCCESS',
        p_error_msg    IN VARCHAR2 DEFAULT NULL
    );

    -- Log a login attempt (called from APEX post-auth process)
    PROCEDURE log_login (
        p_username  IN VARCHAR2,
        p_status    IN VARCHAR2 DEFAULT 'SUCCESS'
    );

    -- Log an access-denied event
    PROCEDURE log_access_denied (
        p_username  IN VARCHAR2,
        p_resource  IN VARCHAR2
    );

END dct_audit;
/

prompt ============================================================
prompt  DCT_AUDIT — Body
prompt ============================================================

CREATE OR REPLACE PACKAGE BODY prod.dct_audit AS

    -- ── Autonomous insert so audit survives a caller rollback ─────────────────
    PROCEDURE do_insert (
        p_username      IN VARCHAR2,
        p_action        IN VARCHAR2,
        p_object_type   IN VARCHAR2,
        p_object_id     IN VARCHAR2,
        p_object_ref    IN VARCHAR2,
        p_old_values    IN CLOB,
        p_new_values    IN CLOB,
        p_module_code   IN VARCHAR2,
        p_status        IN VARCHAR2,
        p_error_msg     IN VARCHAR2
    ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        l_user_id  NUMBER;
    BEGIN
        BEGIN
            SELECT user_id INTO l_user_id
            FROM   dct_users
            WHERE  UPPER(username) = UPPER(p_username)
              AND  ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN l_user_id := NULL;
        END;

        INSERT INTO dct_audit_log (
            logged_at, username, user_id, apex_session_id,
            module_code, action,
            object_type, object_id, object_ref,
            old_values, new_values,
            ip_address, status, error_message
        ) VALUES (
            SYSTIMESTAMP,
            p_username,
            l_user_id,
            apex_application.g_instance,
            p_module_code,
            p_action,
            p_object_type,
            p_object_id,
            p_object_ref,
            p_old_values,
            p_new_values,
            SYS_CONTEXT('USERENV', 'IP_ADDRESS'),
            p_status,
            p_error_msg
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;  -- audit failure must never break caller
    END do_insert;

    -- ── LOG ───────────────────────────────────────────────────────────────────
    PROCEDURE log (
        p_action       IN VARCHAR2,
        p_object_type  IN VARCHAR2 DEFAULT NULL,
        p_object_id    IN VARCHAR2 DEFAULT NULL,
        p_object_ref   IN VARCHAR2 DEFAULT NULL,
        p_old_values   IN CLOB     DEFAULT NULL,
        p_new_values   IN CLOB     DEFAULT NULL,
        p_module_code  IN VARCHAR2 DEFAULT NULL,
        p_status       IN VARCHAR2 DEFAULT 'SUCCESS',
        p_error_msg    IN VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        do_insert(
            p_username    => NVL(apex_application.g_user, SYS_CONTEXT('USERENV','SESSION_USER')),
            p_action      => p_action,
            p_object_type => p_object_type,
            p_object_id   => p_object_id,
            p_object_ref  => p_object_ref,
            p_old_values  => p_old_values,
            p_new_values  => p_new_values,
            p_module_code => p_module_code,
            p_status      => p_status,
            p_error_msg   => p_error_msg
        );
    END log;

    -- ── LOG_LOGIN ─────────────────────────────────────────────────────────────
    PROCEDURE log_login (
        p_username  IN VARCHAR2,
        p_status    IN VARCHAR2 DEFAULT 'SUCCESS'
    ) IS
    BEGIN
        do_insert(
            p_username    => p_username,
            p_action      => 'LOGIN',
            p_object_type => 'SESSION',
            p_object_id   => NULL,
            p_object_ref  => p_username,
            p_old_values  => NULL,
            p_new_values  => NULL,
            p_module_code => 'PLATFORM',
            p_status      => p_status,
            p_error_msg   => NULL
        );
    END log_login;

    -- ── LOG_ACCESS_DENIED ─────────────────────────────────────────────────────
    PROCEDURE log_access_denied (
        p_username  IN VARCHAR2,
        p_resource  IN VARCHAR2
    ) IS
    BEGIN
        do_insert(
            p_username    => p_username,
            p_action      => 'ACCESS_DENIED',
            p_object_type => 'PAGE',
            p_object_id   => NULL,
            p_object_ref  => p_resource,
            p_old_values  => NULL,
            p_new_values  => NULL,
            p_module_code => 'PLATFORM',
            p_status      => 'FAILURE',
            p_error_msg   => 'Access denied: ' || p_resource
        );
    END log_access_denied;

END dct_audit;
/

prompt ============================================================
prompt  Verifying package status
prompt ============================================================
SELECT object_name, object_type, status
FROM   all_objects
WHERE  object_name = 'DCT_AUDIT'
  AND  owner       = 'PROD'
ORDER BY object_type;

prompt  DCT_AUDIT package deployed.

set define on verify on feedback on
