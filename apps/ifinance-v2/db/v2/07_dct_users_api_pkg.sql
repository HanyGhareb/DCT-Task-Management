-- =============================================================================
-- i-Finance V2 — User & Role Management Package
-- File    : 07_dct_users_api_pkg.sql
-- Schema  : PROD
-- Sprint  : 2 — User & Role Management
-- =============================================================================
-- Prerequisite: 01_dct_ddl.sql, 03_dct_auth_pkg.sql
-- =============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF

-- =============================================================================
-- PACKAGE SPEC
-- =============================================================================
CREATE OR REPLACE PACKAGE prod.dct_users_api AS

    -- -------------------------------------------------------------------------
    -- User lifecycle
    -- -------------------------------------------------------------------------

    FUNCTION create_user (
        p_username        IN VARCHAR2,
        p_email           IN VARCHAR2,
        p_display_name    IN VARCHAR2,
        p_display_name_ar IN VARCHAR2  DEFAULT NULL,
        p_first_name      IN VARCHAR2  DEFAULT NULL,
        p_last_name       IN VARCHAR2  DEFAULT NULL,
        p_job_title_en    IN VARCHAR2  DEFAULT NULL,
        p_job_title_ar    IN VARCHAR2  DEFAULT NULL,
        p_employee_number IN VARCHAR2  DEFAULT NULL,
        p_person_id       IN NUMBER    DEFAULT NULL,
        p_mobile          IN VARCHAR2  DEFAULT NULL,
        p_photo_url       IN VARCHAR2  DEFAULT NULL,
        p_color_hex       IN VARCHAR2  DEFAULT '#003366',
        p_language_pref   IN VARCHAR2  DEFAULT 'EN',
        p_org_id          IN NUMBER    DEFAULT NULL,
        p_auth_method     IN VARCHAR2  DEFAULT 'DB',
        p_password        IN VARCHAR2  DEFAULT NULL,  -- plain text; hashed internally
        p_is_external     IN VARCHAR2  DEFAULT 'N'
    ) RETURN NUMBER;  -- returns user_id

    PROCEDURE update_user (
        p_user_id         IN NUMBER,
        p_email           IN VARCHAR2  DEFAULT NULL,
        p_display_name    IN VARCHAR2  DEFAULT NULL,
        p_display_name_ar IN VARCHAR2  DEFAULT NULL,
        p_first_name      IN VARCHAR2  DEFAULT NULL,
        p_last_name       IN VARCHAR2  DEFAULT NULL,
        p_job_title_en    IN VARCHAR2  DEFAULT NULL,
        p_job_title_ar    IN VARCHAR2  DEFAULT NULL,
        p_mobile          IN VARCHAR2  DEFAULT NULL,
        p_photo_url       IN VARCHAR2  DEFAULT NULL,
        p_color_hex       IN VARCHAR2  DEFAULT NULL,
        p_language_pref   IN VARCHAR2  DEFAULT NULL,
        p_org_id          IN NUMBER    DEFAULT NULL,
        p_is_external     IN VARCHAR2  DEFAULT NULL
    );

    PROCEDURE deactivate_user (
        p_user_id IN NUMBER,
        p_reason  IN VARCHAR2 DEFAULT NULL
    );

    PROCEDURE reactivate_user (
        p_user_id IN NUMBER
    );

    -- -------------------------------------------------------------------------
    -- Role assignment
    -- -------------------------------------------------------------------------

    PROCEDURE assign_role (
        p_user_id      IN NUMBER,
        p_role_id      IN NUMBER,
        p_start_date   IN DATE    DEFAULT SYSDATE,
        p_end_date     IN DATE    DEFAULT NULL,
        p_org_scope_id IN NUMBER  DEFAULT NULL,
        p_reason       IN VARCHAR2 DEFAULT NULL
    );

    PROCEDURE revoke_role (
        p_user_id  IN NUMBER,
        p_role_id  IN NUMBER,
        p_reason   IN VARCHAR2 DEFAULT NULL
    );

    -- -------------------------------------------------------------------------
    -- Organisation assignment
    -- -------------------------------------------------------------------------

    PROCEDURE assign_org (
        p_user_id         IN NUMBER,
        p_org_id          IN NUMBER,
        p_assignment_type IN VARCHAR2 DEFAULT 'SECONDARY',  -- PRIMARY | SECONDARY | ACTING
        p_start_date      IN DATE     DEFAULT SYSDATE,
        p_end_date        IN DATE     DEFAULT NULL
    );

    PROCEDURE remove_org (
        p_user_id IN NUMBER,
        p_org_id  IN NUMBER
    );

    -- -------------------------------------------------------------------------
    -- HR sync (stub — wire to dct_employees when HR schema is available)
    -- -------------------------------------------------------------------------

    PROCEDURE sync_from_hr (
        p_employee_number IN VARCHAR2
    );

    -- -------------------------------------------------------------------------
    -- Helpers
    -- -------------------------------------------------------------------------

    FUNCTION get_user_id (
        p_username IN VARCHAR2
    ) RETURN NUMBER;

    FUNCTION username_exists (
        p_username IN VARCHAR2
    ) RETURN BOOLEAN;

    FUNCTION email_exists (
        p_email   IN VARCHAR2,
        p_exclude_user_id IN NUMBER DEFAULT NULL
    ) RETURN BOOLEAN;

END dct_users_api;
/

-- =============================================================================
-- PACKAGE BODY
-- =============================================================================
CREATE OR REPLACE PACKAGE BODY prod.dct_users_api AS

    -- -------------------------------------------------------------------------
    -- PRIVATE: audit log (autonomous — never breaks caller)
    -- -------------------------------------------------------------------------
    PROCEDURE p_log (
        p_action      IN VARCHAR2,
        p_object_type IN VARCHAR2 DEFAULT 'DCT_USERS',
        p_object_id   IN VARCHAR2 DEFAULT NULL,
        p_old_values  IN VARCHAR2 DEFAULT NULL,
        p_new_values  IN VARCHAR2 DEFAULT NULL,
        p_status      IN VARCHAR2 DEFAULT 'SUCCESS',
        p_error       IN VARCHAR2 DEFAULT NULL
    ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        l_username  VARCHAR2(100);
        l_user_id   NUMBER;
    BEGIN
        l_username := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),
                          SYS_CONTEXT('USERENV','SESSION_USER'));
        BEGIN
            SELECT user_id INTO l_user_id
            FROM   dct_users
            WHERE  UPPER(username) = UPPER(l_username)
            AND    ROWNUM = 1;
        EXCEPTION WHEN NO_DATA_FOUND THEN l_user_id := NULL;
        END;

        INSERT INTO dct_audit_log (
            username, user_id, apex_session_id,
            action, object_type, object_id,
            old_values, new_values,
            status, error_message
        ) VALUES (
            l_username, l_user_id,
            SYS_CONTEXT('APEX$SESSION','APP_SESSION'),
            p_action, p_object_type, p_object_id,
            p_old_values, p_new_values,
            p_status, p_error
        );
        COMMIT;
    EXCEPTION WHEN OTHERS THEN NULL;
    END p_log;

    -- -------------------------------------------------------------------------
    -- PRIVATE: validate username/email uniqueness
    -- -------------------------------------------------------------------------
    PROCEDURE p_validate_new_user (
        p_username IN VARCHAR2,
        p_email    IN VARCHAR2
    ) IS
        l_count NUMBER;
    BEGIN
        IF p_username IS NULL THEN
            RAISE_APPLICATION_ERROR(-20010, 'Username is required.');
        END IF;
        IF p_email IS NULL THEN
            RAISE_APPLICATION_ERROR(-20011, 'Email is required.');
        END IF;

        SELECT COUNT(*) INTO l_count FROM dct_users
        WHERE UPPER(username) = UPPER(p_username);
        IF l_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20012, 'Username already exists: ' || p_username);
        END IF;

        SELECT COUNT(*) INTO l_count FROM dct_users
        WHERE UPPER(email) = UPPER(p_email);
        IF l_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20013, 'Email already registered: ' || p_email);
        END IF;
    END p_validate_new_user;

    -- -------------------------------------------------------------------------
    -- get_user_id
    -- -------------------------------------------------------------------------
    FUNCTION get_user_id (p_username IN VARCHAR2) RETURN NUMBER IS
        l_id NUMBER;
    BEGIN
        SELECT user_id INTO l_id FROM dct_users
        WHERE  UPPER(username) = UPPER(p_username) AND ROWNUM = 1;
        RETURN l_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END get_user_id;

    -- -------------------------------------------------------------------------
    -- username_exists
    -- -------------------------------------------------------------------------
    FUNCTION username_exists (p_username IN VARCHAR2) RETURN BOOLEAN IS
        l_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO l_count FROM dct_users
        WHERE UPPER(username) = UPPER(p_username);
        RETURN l_count > 0;
    END username_exists;

    -- -------------------------------------------------------------------------
    -- email_exists
    -- -------------------------------------------------------------------------
    FUNCTION email_exists (
        p_email           IN VARCHAR2,
        p_exclude_user_id IN NUMBER DEFAULT NULL
    ) RETURN BOOLEAN IS
        l_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO l_count FROM dct_users
        WHERE  UPPER(email) = UPPER(p_email)
          AND  (p_exclude_user_id IS NULL OR user_id != p_exclude_user_id);
        RETURN l_count > 0;
    END email_exists;

    -- -------------------------------------------------------------------------
    -- create_user
    -- -------------------------------------------------------------------------
    FUNCTION create_user (
        p_username        IN VARCHAR2,
        p_email           IN VARCHAR2,
        p_display_name    IN VARCHAR2,
        p_display_name_ar IN VARCHAR2  DEFAULT NULL,
        p_first_name      IN VARCHAR2  DEFAULT NULL,
        p_last_name       IN VARCHAR2  DEFAULT NULL,
        p_job_title_en    IN VARCHAR2  DEFAULT NULL,
        p_job_title_ar    IN VARCHAR2  DEFAULT NULL,
        p_employee_number IN VARCHAR2  DEFAULT NULL,
        p_person_id       IN NUMBER    DEFAULT NULL,
        p_mobile          IN VARCHAR2  DEFAULT NULL,
        p_photo_url       IN VARCHAR2  DEFAULT NULL,
        p_color_hex       IN VARCHAR2  DEFAULT '#003366',
        p_language_pref   IN VARCHAR2  DEFAULT 'EN',
        p_org_id          IN NUMBER    DEFAULT NULL,
        p_auth_method     IN VARCHAR2  DEFAULT 'DB',
        p_password        IN VARCHAR2  DEFAULT NULL,
        p_is_external     IN VARCHAR2  DEFAULT 'N'
    ) RETURN NUMBER IS
        l_user_id     NUMBER;
        l_hash        VARCHAR2(200);
        l_created_by  VARCHAR2(100);
    BEGIN
        p_validate_new_user(p_username, p_email);

        IF p_display_name IS NULL THEN
            RAISE_APPLICATION_ERROR(-20014, 'Display name is required.');
        END IF;

        IF p_auth_method = 'DB' AND p_password IS NOT NULL THEN
            l_hash := dct_auth.hash_password(p_password);
        END IF;

        l_created_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),
                            SYS_CONTEXT('USERENV','SESSION_USER'));

        INSERT INTO dct_users (
            username, email, display_name, display_name_ar,
            first_name, last_name, job_title_en, job_title_ar,
            employee_number, person_id, mobile, photo_url,
            color_hex, language_pref, org_id,
            password_hash, auth_method, is_external,
            is_active, created_by
        ) VALUES (
            UPPER(p_username), LOWER(p_email), p_display_name, p_display_name_ar,
            p_first_name, p_last_name, p_job_title_en, p_job_title_ar,
            p_employee_number, p_person_id, p_mobile, p_photo_url,
            NVL(p_color_hex, '#003366'), NVL(p_language_pref, 'EN'), p_org_id,
            l_hash, NVL(p_auth_method, 'DB'), NVL(p_is_external, 'N'),
            'Y', l_created_by
        )
        RETURNING user_id INTO l_user_id;

        -- Every new user gets the base PLATFORM_USER role
        BEGIN
            INSERT INTO dct_user_roles (
                user_id, role_id, start_date, assigned_by, created_by
            )
            SELECT l_user_id, role_id, SYSDATE, l_created_by, l_created_by
            FROM   dct_roles
            WHERE  role_code = 'PLATFORM_USER'
              AND  is_active = 'Y'
              AND  ROWNUM = 1;
        EXCEPTION WHEN OTHERS THEN NULL;  -- role may not exist in test env
        END;

        p_log('CREATE', 'DCT_USERS', TO_CHAR(l_user_id),
              NULL, 'username=' || p_username || '; email=' || p_email);

        RETURN l_user_id;

    EXCEPTION
        WHEN OTHERS THEN
            p_log('CREATE', 'DCT_USERS', NULL, NULL, NULL, 'FAILURE', SQLERRM);
            RAISE;
    END create_user;

    -- -------------------------------------------------------------------------
    -- update_user
    -- -------------------------------------------------------------------------
    PROCEDURE update_user (
        p_user_id         IN NUMBER,
        p_email           IN VARCHAR2  DEFAULT NULL,
        p_display_name    IN VARCHAR2  DEFAULT NULL,
        p_display_name_ar IN VARCHAR2  DEFAULT NULL,
        p_first_name      IN VARCHAR2  DEFAULT NULL,
        p_last_name       IN VARCHAR2  DEFAULT NULL,
        p_job_title_en    IN VARCHAR2  DEFAULT NULL,
        p_job_title_ar    IN VARCHAR2  DEFAULT NULL,
        p_mobile          IN VARCHAR2  DEFAULT NULL,
        p_photo_url       IN VARCHAR2  DEFAULT NULL,
        p_color_hex       IN VARCHAR2  DEFAULT NULL,
        p_language_pref   IN VARCHAR2  DEFAULT NULL,
        p_org_id          IN NUMBER    DEFAULT NULL,
        p_is_external     IN VARCHAR2  DEFAULT NULL
    ) IS
        l_actor VARCHAR2(100);
    BEGIN
        -- Email uniqueness check (excluding this user)
        IF p_email IS NOT NULL AND email_exists(p_email, p_user_id) THEN
            RAISE_APPLICATION_ERROR(-20013, 'Email already registered: ' || p_email);
        END IF;

        l_actor := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),
                       SYS_CONTEXT('USERENV','SESSION_USER'));

        UPDATE dct_users SET
            email           = NVL(LOWER(p_email),        email),
            display_name    = NVL(p_display_name,        display_name),
            display_name_ar = NVL(p_display_name_ar,     display_name_ar),
            first_name      = NVL(p_first_name,          first_name),
            last_name       = NVL(p_last_name,           last_name),
            job_title_en    = NVL(p_job_title_en,        job_title_en),
            job_title_ar    = NVL(p_job_title_ar,        job_title_ar),
            mobile          = NVL(p_mobile,              mobile),
            photo_url       = NVL(p_photo_url,           photo_url),
            color_hex       = NVL(p_color_hex,           color_hex),
            language_pref   = NVL(p_language_pref,       language_pref),
            org_id          = NVL(p_org_id,              org_id),
            is_external     = NVL(p_is_external,         is_external),
            updated_by      = l_actor,
            updated_at      = SYSTIMESTAMP
        WHERE user_id = p_user_id;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20015, 'User not found: ' || p_user_id);
        END IF;

        p_log('UPDATE', 'DCT_USERS', TO_CHAR(p_user_id));

    EXCEPTION
        WHEN OTHERS THEN
            p_log('UPDATE', 'DCT_USERS', TO_CHAR(p_user_id), NULL, NULL, 'FAILURE', SQLERRM);
            RAISE;
    END update_user;

    -- -------------------------------------------------------------------------
    -- deactivate_user
    -- -------------------------------------------------------------------------
    PROCEDURE deactivate_user (
        p_user_id IN NUMBER,
        p_reason  IN VARCHAR2 DEFAULT NULL
    ) IS
        l_actor   VARCHAR2(100);
        l_username VARCHAR2(100);
    BEGIN
        -- Prevent deactivating the last SYS_ADMIN
        DECLARE
            l_admin_count NUMBER;
        BEGIN
            SELECT COUNT(*) INTO l_admin_count
            FROM   dct_user_roles ur
            JOIN   dct_roles r ON ur.role_id = r.role_id
            WHERE  r.role_code  = 'SYS_ADMIN'
              AND  ur.is_active = 'Y'
              AND  (ur.end_date IS NULL OR ur.end_date >= SYSDATE)
              AND  ur.user_id  != p_user_id;

            IF l_admin_count = 0 THEN
                -- Check if the user being deactivated IS a SYS_ADMIN
                SELECT COUNT(*) INTO l_admin_count
                FROM   dct_user_roles ur
                JOIN   dct_roles r ON ur.role_id = r.role_id
                WHERE  r.role_code  = 'SYS_ADMIN'
                  AND  ur.is_active = 'Y'
                  AND  ur.user_id   = p_user_id;

                IF l_admin_count > 0 THEN
                    RAISE_APPLICATION_ERROR(-20020,
                        'Cannot deactivate the last System Administrator.');
                END IF;
            END IF;
        END;

        l_actor := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),
                       SYS_CONTEXT('USERENV','SESSION_USER'));

        SELECT username INTO l_username FROM dct_users WHERE user_id = p_user_id;

        UPDATE dct_users
        SET    is_active           = 'N',
               deactivated_at      = SYSTIMESTAMP,
               deactivation_reason = p_reason,
               updated_by          = l_actor,
               updated_at          = SYSTIMESTAMP
        WHERE  user_id = p_user_id;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20015, 'User not found: ' || p_user_id);
        END IF;

        -- Expire all active sessions for this user
        UPDATE dct_sessions
        SET    is_active  = 'N',
               logout_at  = SYSTIMESTAMP
        WHERE  username   = l_username
          AND  is_active  = 'Y';

        p_log('DEACTIVATE', 'DCT_USERS', TO_CHAR(p_user_id),
              NULL, 'reason=' || p_reason);

    EXCEPTION
        WHEN OTHERS THEN
            p_log('DEACTIVATE', 'DCT_USERS', TO_CHAR(p_user_id),
                  NULL, NULL, 'FAILURE', SQLERRM);
            RAISE;
    END deactivate_user;

    -- -------------------------------------------------------------------------
    -- reactivate_user
    -- -------------------------------------------------------------------------
    PROCEDURE reactivate_user (p_user_id IN NUMBER) IS
        l_actor VARCHAR2(100);
    BEGIN
        l_actor := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),
                       SYS_CONTEXT('USERENV','SESSION_USER'));

        UPDATE dct_users
        SET    is_active           = 'Y',
               deactivated_at      = NULL,
               deactivation_reason = NULL,
               updated_by          = l_actor,
               updated_at          = SYSTIMESTAMP
        WHERE  user_id = p_user_id;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20015, 'User not found: ' || p_user_id);
        END IF;

        p_log('REACTIVATE', 'DCT_USERS', TO_CHAR(p_user_id));

    EXCEPTION
        WHEN OTHERS THEN
            p_log('REACTIVATE', 'DCT_USERS', TO_CHAR(p_user_id),
                  NULL, NULL, 'FAILURE', SQLERRM);
            RAISE;
    END reactivate_user;

    -- -------------------------------------------------------------------------
    -- assign_role
    -- -------------------------------------------------------------------------
    PROCEDURE assign_role (
        p_user_id      IN NUMBER,
        p_role_id      IN NUMBER,
        p_start_date   IN DATE    DEFAULT SYSDATE,
        p_end_date     IN DATE    DEFAULT NULL,
        p_org_scope_id IN NUMBER  DEFAULT NULL,
        p_reason       IN VARCHAR2 DEFAULT NULL
    ) IS
        l_actor   VARCHAR2(100);
        l_count   NUMBER;
    BEGIN
        -- Check for existing active assignment
        SELECT COUNT(*) INTO l_count
        FROM   dct_user_roles
        WHERE  user_id   = p_user_id
          AND  role_id   = p_role_id
          AND  is_active = 'Y'
          AND  (end_date IS NULL OR end_date >= SYSDATE);

        IF l_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20030,
                'Role is already actively assigned to this user.');
        END IF;

        l_actor := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),
                       SYS_CONTEXT('USERENV','SESSION_USER'));

        INSERT INTO dct_user_roles (
            user_id, role_id, org_scope_id,
            start_date, end_date,
            assigned_by, reason, is_active,
            created_by
        ) VALUES (
            p_user_id, p_role_id, p_org_scope_id,
            NVL(p_start_date, SYSDATE), p_end_date,
            l_actor, p_reason, 'Y',
            l_actor
        );

        p_log('ROLE_ASSIGN', 'DCT_USER_ROLES',
              'user=' || p_user_id || ';role=' || p_role_id,
              NULL, 'start=' || TO_CHAR(p_start_date, 'YYYY-MM-DD'));

    EXCEPTION
        WHEN OTHERS THEN
            p_log('ROLE_ASSIGN', 'DCT_USER_ROLES',
                  'user=' || p_user_id || ';role=' || p_role_id,
                  NULL, NULL, 'FAILURE', SQLERRM);
            RAISE;
    END assign_role;

    -- -------------------------------------------------------------------------
    -- revoke_role
    -- -------------------------------------------------------------------------
    PROCEDURE revoke_role (
        p_user_id IN NUMBER,
        p_role_id IN NUMBER,
        p_reason  IN VARCHAR2 DEFAULT NULL
    ) IS
        l_actor VARCHAR2(100);
    BEGIN
        l_actor := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),
                       SYS_CONTEXT('USERENV','SESSION_USER'));

        UPDATE dct_user_roles
        SET    end_date   = SYSDATE,
               is_active  = 'N',
               reason     = NVL(p_reason, reason),
               updated_by = l_actor,
               updated_at = SYSTIMESTAMP
        WHERE  user_id   = p_user_id
          AND  role_id   = p_role_id
          AND  is_active = 'Y';

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20031,
                'No active role assignment found for this user/role combination.');
        END IF;

        p_log('ROLE_REVOKE', 'DCT_USER_ROLES',
              'user=' || p_user_id || ';role=' || p_role_id,
              'reason=' || p_reason);

    EXCEPTION
        WHEN OTHERS THEN
            p_log('ROLE_REVOKE', 'DCT_USER_ROLES',
                  'user=' || p_user_id || ';role=' || p_role_id,
                  NULL, NULL, 'FAILURE', SQLERRM);
            RAISE;
    END revoke_role;

    -- -------------------------------------------------------------------------
    -- assign_org
    -- -------------------------------------------------------------------------
    PROCEDURE assign_org (
        p_user_id         IN NUMBER,
        p_org_id          IN NUMBER,
        p_assignment_type IN VARCHAR2 DEFAULT 'SECONDARY',
        p_start_date      IN DATE     DEFAULT SYSDATE,
        p_end_date        IN DATE     DEFAULT NULL
    ) IS
        l_actor VARCHAR2(100);
    BEGIN
        l_actor := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),
                       SYS_CONTEXT('USERENV','SESSION_USER'));

        -- If setting as PRIMARY, demote any existing primary
        IF UPPER(p_assignment_type) = 'PRIMARY' THEN
            UPDATE dct_user_orgs
            SET    assignment_type = 'SECONDARY',
                   updated_by      = l_actor,
                   updated_at      = SYSTIMESTAMP
            WHERE  user_id          = p_user_id
              AND  assignment_type  = 'PRIMARY';
        END IF;

        MERGE INTO dct_user_orgs t
        USING (SELECT p_user_id AS user_id, p_org_id AS org_id FROM DUAL) s
        ON    (t.user_id = s.user_id AND t.org_id = s.org_id)
        WHEN MATCHED THEN
            UPDATE SET
                assignment_type = UPPER(p_assignment_type),
                start_date      = NVL(p_start_date, SYSDATE),
                end_date        = p_end_date,
                assigned_by     = l_actor,
                updated_by      = l_actor,
                updated_at      = SYSTIMESTAMP
        WHEN NOT MATCHED THEN
            INSERT (user_id, org_id, assignment_type, start_date, end_date,
                    assigned_by, created_by)
            VALUES (p_user_id, p_org_id, UPPER(p_assignment_type),
                    NVL(p_start_date, SYSDATE), p_end_date,
                    l_actor, l_actor);

        p_log('ORG_ASSIGN', 'DCT_USER_ORGS',
              'user=' || p_user_id || ';org=' || p_org_id);

    EXCEPTION
        WHEN OTHERS THEN
            p_log('ORG_ASSIGN', 'DCT_USER_ORGS',
                  'user=' || p_user_id || ';org=' || p_org_id,
                  NULL, NULL, 'FAILURE', SQLERRM);
            RAISE;
    END assign_org;

    -- -------------------------------------------------------------------------
    -- remove_org
    -- -------------------------------------------------------------------------
    PROCEDURE remove_org (
        p_user_id IN NUMBER,
        p_org_id  IN NUMBER
    ) IS
        l_actor VARCHAR2(100);
    BEGIN
        l_actor := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),
                       SYS_CONTEXT('USERENV','SESSION_USER'));

        DELETE FROM dct_user_orgs
        WHERE  user_id = p_user_id
          AND  org_id  = p_org_id;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20040,
                'No org assignment found for this user/org combination.');
        END IF;

        p_log('ORG_REMOVE', 'DCT_USER_ORGS',
              'user=' || p_user_id || ';org=' || p_org_id);

    EXCEPTION
        WHEN OTHERS THEN
            p_log('ORG_REMOVE', 'DCT_USER_ORGS',
                  'user=' || p_user_id || ';org=' || p_org_id,
                  NULL, NULL, 'FAILURE', SQLERRM);
            RAISE;
    END remove_org;

    -- -------------------------------------------------------------------------
    -- sync_from_hr
    -- Wire this to dct_employees once the HR schema is available.
    -- Expected: dct_employees has employee_number, person_id, full_name_en,
    --           full_name_ar, email, job_title, mobile, org_id columns.
    -- -------------------------------------------------------------------------
    PROCEDURE sync_from_hr (p_employee_number IN VARCHAR2) IS
    BEGIN
        RAISE_APPLICATION_ERROR(-20099,
            'sync_from_hr: HR schema (dct_employees) not yet available. ' ||
            'Wire this procedure once the HR table is in place.');
    END sync_from_hr;

END dct_users_api;
/

-- =============================================================================
-- VERIFY
-- =============================================================================
PROMPT
PROMPT Verifying DCT_USERS_API package...

SELECT object_name, object_type, status
FROM   user_objects
WHERE  object_name = 'DCT_USERS_API'
ORDER  BY object_type;

SHOW ERRORS PACKAGE      dct_users_api;
SHOW ERRORS PACKAGE BODY dct_users_api;

PROMPT ============================================================
PROMPT  Done. DCT_USERS_API package created.
PROMPT
PROMPT  Key procedures:
PROMPT    create_user(...)      RETURN NUMBER (user_id)
PROMPT    update_user(p_user_id, ...)
PROMPT    deactivate_user(p_user_id, p_reason)
PROMPT    reactivate_user(p_user_id)
PROMPT    assign_role(p_user_id, p_role_id, p_start, p_end)
PROMPT    revoke_role(p_user_id, p_role_id)
PROMPT    assign_org(p_user_id, p_org_id, p_type)
PROMPT    remove_org(p_user_id, p_org_id)
PROMPT    sync_from_hr(p_employee_number)  -- stub
PROMPT ============================================================
