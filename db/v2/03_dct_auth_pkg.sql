-- =============================================================================
-- i-Finance V2 — Authentication & Authorization Package
-- File    : 03_dct_auth_pkg.sql
-- Schema  : PROD
-- Sprint  : 1 — Foundation
-- =============================================================================
-- Prerequisite: GRANT EXECUTE ON DBMS_CRYPTO TO PROD;
--
-- APEX Configuration (App 200):
--   Authentication Scheme Type : Custom
--   Authentication Function    : dct_auth.authenticate
--   Post-Authentication Proc   : dct_auth.post_login
--
-- Adding a new auth scheme later (e.g. OCI IAM):
--   1. Add new APEX authentication scheme in App 200
--   2. That scheme handles credential validation externally
--   3. post_login still fires — no changes needed to this package
--   4. Update DCT_SYSTEM_SETTINGS key DEFAULT_AUTH_METHOD to 'OCI_IAM'
-- =============================================================================

-- =============================================================================
-- PACKAGE SPEC
-- =============================================================================
CREATE OR REPLACE PACKAGE dct_auth AS

    -- -------------------------------------------------------------------------
    -- APEX Custom Authentication entry point.
    -- Called by APEX when authentication scheme = Custom.
    -- Returns TRUE  → APEX creates the session.
    -- Returns FALSE → Login page re-rendered with error.
    -- -------------------------------------------------------------------------
    FUNCTION authenticate (
        p_username IN VARCHAR2,
        p_password IN VARCHAR2
    ) RETURN BOOLEAN;

    -- -------------------------------------------------------------------------
    -- Post-authentication initialisation.
    -- Called as APEX Post-Authentication Procedure immediately after login.
    -- Loads role/permission/org data into APEX application items.
    -- Also called manually after any mid-session role change.
    -- -------------------------------------------------------------------------
    PROCEDURE post_login (
        p_username IN VARCHAR2 DEFAULT NULL  -- defaults to V('APP_USER')
    );

    -- -------------------------------------------------------------------------
    -- Permission & role checks — called from APEX Authorization Schemes.
    -- -------------------------------------------------------------------------
    FUNCTION has_permission (
        p_username        IN VARCHAR2,
        p_permission_code IN VARCHAR2
    ) RETURN BOOLEAN;

    FUNCTION has_role (
        p_username  IN VARCHAR2,
        p_role_code IN VARCHAR2
    ) RETURN BOOLEAN;

    FUNCTION has_module_access (
        p_username    IN VARCHAR2,
        p_module_code IN VARCHAR2
    ) RETURN BOOLEAN;

    -- -------------------------------------------------------------------------
    -- Utility — used by domain apps and APEX computations.
    -- -------------------------------------------------------------------------
    FUNCTION get_user_id (
        p_username IN VARCHAR2
    ) RETURN NUMBER;

    FUNCTION get_user_roles (
        p_username IN VARCHAR2
    ) RETURN VARCHAR2;  -- Comma-separated role_code list

    FUNCTION get_user_org_ids (
        p_username IN VARCHAR2
    ) RETURN VARCHAR2;  -- Comma-separated org_id list

    -- -------------------------------------------------------------------------
    -- Delegation resolver.
    -- Returns p_username unchanged unless the user is acting as a delegate;
    -- in that case returns the delegator's username so permission checks
    -- reflect the delegated authority.
    -- -------------------------------------------------------------------------
    FUNCTION get_effective_user (
        p_username IN VARCHAR2
    ) RETURN VARCHAR2;

    -- -------------------------------------------------------------------------
    -- Password management (DB auth method only).
    -- -------------------------------------------------------------------------
    FUNCTION hash_password (
        p_plain_text IN VARCHAR2
    ) RETURN VARCHAR2;

    PROCEDURE set_password (
        p_username  IN VARCHAR2,
        p_password  IN VARCHAR2
    );

    -- -------------------------------------------------------------------------
    -- Session management.
    -- -------------------------------------------------------------------------
    PROCEDURE open_session (
        p_username   IN VARCHAR2,
        p_session_id IN VARCHAR2,
        p_ip         IN VARCHAR2 DEFAULT NULL,
        p_agent      IN VARCHAR2 DEFAULT NULL,
        p_auth_method IN VARCHAR2 DEFAULT 'DB'
    );

    PROCEDURE close_session (
        p_session_id IN VARCHAR2
    );

    PROCEDURE touch_session (
        p_session_id IN VARCHAR2
    );

END dct_auth;
/

-- =============================================================================
-- PACKAGE BODY
-- =============================================================================
CREATE OR REPLACE PACKAGE BODY dct_auth AS

    -- -------------------------------------------------------------------------
    -- PRIVATE: Hash a plain-text password with SHA-512.
    -- -------------------------------------------------------------------------
    FUNCTION hash_password (p_plain_text IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN RAWTOHEX(
            DBMS_CRYPTO.HASH(
                UTL_I18N.STRING_TO_RAW(p_plain_text, 'AL32UTF8'),
                DBMS_CRYPTO.HASH_SH512
            )
        );
    END hash_password;

    -- -------------------------------------------------------------------------
    -- PRIVATE: Write to audit log — suppresses exceptions so auth is never
    -- blocked by a logging failure.
    -- -------------------------------------------------------------------------
    PROCEDURE p_log (
        p_username    IN VARCHAR2,
        p_action      IN VARCHAR2,
        p_status      IN VARCHAR2 DEFAULT 'SUCCESS',
        p_object_type IN VARCHAR2 DEFAULT NULL,
        p_object_id   IN VARCHAR2 DEFAULT NULL,
        p_error       IN VARCHAR2 DEFAULT NULL
    ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        l_user_id dct_users.user_id%TYPE;
    BEGIN
        BEGIN
            SELECT user_id INTO l_user_id
            FROM   dct_users
            WHERE  UPPER(username) = UPPER(p_username)
            AND    ROWNUM = 1;
        EXCEPTION WHEN NO_DATA_FOUND THEN l_user_id := NULL;
        END;

        INSERT INTO dct_audit_log (
            username, user_id, apex_session_id,
            action, object_type, object_id,
            status, error_message
        ) VALUES (
            p_username, l_user_id,
            SYS_CONTEXT('APEX$SESSION','APP_SESSION'),
            p_action, p_object_type, p_object_id,
            p_status, p_error
        );
        COMMIT;
    EXCEPTION WHEN OTHERS THEN NULL;
    END p_log;

    -- -------------------------------------------------------------------------
    -- get_user_id
    -- -------------------------------------------------------------------------
    FUNCTION get_user_id (p_username IN VARCHAR2) RETURN NUMBER IS
        l_id dct_users.user_id%TYPE;
    BEGIN
        SELECT user_id INTO l_id
        FROM   dct_users
        WHERE  UPPER(username) = UPPER(p_username)
          AND  is_active = 'Y'
          AND  ROWNUM = 1;
        RETURN l_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
    END get_user_id;

    -- -------------------------------------------------------------------------
    -- get_user_roles — returns comma-delimited active role_code list
    -- -------------------------------------------------------------------------
    FUNCTION get_user_roles (p_username IN VARCHAR2) RETURN VARCHAR2 IS
        l_roles VARCHAR2(4000);
    BEGIN
        SELECT LISTAGG(r.role_code, ',') WITHIN GROUP (ORDER BY r.role_code)
        INTO   l_roles
        FROM   v_dct_user_active_roles r
        WHERE  UPPER(r.username) = UPPER(p_username);
        RETURN l_roles;
    EXCEPTION WHEN OTHERS THEN RETURN NULL;
    END get_user_roles;

    -- -------------------------------------------------------------------------
    -- get_user_org_ids — returns comma-delimited org_id list
    -- -------------------------------------------------------------------------
    FUNCTION get_user_org_ids (p_username IN VARCHAR2) RETURN VARCHAR2 IS
        l_orgs VARCHAR2(4000);
    BEGIN
        SELECT LISTAGG(uo.org_id, ',') WITHIN GROUP (ORDER BY uo.org_id)
        INTO   l_orgs
        FROM   dct_user_orgs uo
        JOIN   dct_users     u  ON uo.user_id = u.user_id
        WHERE  UPPER(u.username) = UPPER(p_username)
          AND  TRUNC(SYSDATE) >= TRUNC(uo.start_date)
          AND  (uo.end_date IS NULL OR TRUNC(SYSDATE) <= TRUNC(uo.end_date));
        RETURN l_orgs;
    EXCEPTION WHEN OTHERS THEN RETURN NULL;
    END get_user_org_ids;

    -- -------------------------------------------------------------------------
    -- get_effective_user
    -- Returns the username whose permissions should apply.
    -- If user B is actively delegating for user A, returns A's username
    -- so has_role / has_permission checks honour the delegated authority.
    -- -------------------------------------------------------------------------
    FUNCTION get_effective_user (p_username IN VARCHAR2) RETURN VARCHAR2 IS
        l_delegator VARCHAR2(100);
    BEGIN
        -- Check if this user is currently acting as a delegate for someone
        SELECT u_from.username
        INTO   l_delegator
        FROM   v_dct_active_delegations d
        JOIN   dct_users u_from ON d.delegator_id = u_from.user_id
        WHERE  UPPER(d.delegate_username) = UPPER(p_username)
          AND  ROWNUM = 1;
        RETURN l_delegator;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN p_username;
        WHEN OTHERS         THEN RETURN p_username;
    END get_effective_user;

    -- -------------------------------------------------------------------------
    -- has_role
    -- -------------------------------------------------------------------------
    FUNCTION has_role (p_username IN VARCHAR2, p_role_code IN VARCHAR2)
        RETURN BOOLEAN
    IS
        l_count NUMBER;
        l_eff   VARCHAR2(100);
    BEGIN
        l_eff := get_effective_user(p_username);
        SELECT COUNT(*)
        INTO   l_count
        FROM   v_dct_user_active_roles
        WHERE  UPPER(username)  = UPPER(l_eff)
          AND  UPPER(role_code) = UPPER(p_role_code);
        RETURN l_count > 0;
    EXCEPTION WHEN OTHERS THEN RETURN FALSE;
    END has_role;

    -- -------------------------------------------------------------------------
    -- has_permission
    -- -------------------------------------------------------------------------
    FUNCTION has_permission (p_username IN VARCHAR2, p_permission_code IN VARCHAR2)
        RETURN BOOLEAN
    IS
        l_count NUMBER;
        l_eff   VARCHAR2(100);
    BEGIN
        l_eff := get_effective_user(p_username);
        SELECT COUNT(*)
        INTO   l_count
        FROM   v_dct_user_permissions
        WHERE  UPPER(username)        = UPPER(l_eff)
          AND  UPPER(permission_code) = UPPER(p_permission_code);
        RETURN l_count > 0;
    EXCEPTION WHEN OTHERS THEN RETURN FALSE;
    END has_permission;

    -- -------------------------------------------------------------------------
    -- has_module_access
    -- -------------------------------------------------------------------------
    FUNCTION has_module_access (p_username IN VARCHAR2, p_module_code IN VARCHAR2)
        RETURN BOOLEAN
    IS
        l_count NUMBER;
        l_eff   VARCHAR2(100);
    BEGIN
        l_eff := get_effective_user(p_username);
        SELECT COUNT(*)
        INTO   l_count
        FROM   v_dct_module_access
        WHERE  UPPER(username)    = UPPER(l_eff)
          AND  UPPER(module_code) = UPPER(p_module_code);
        RETURN l_count > 0;
    EXCEPTION WHEN OTHERS THEN RETURN FALSE;
    END has_module_access;

    -- -------------------------------------------------------------------------
    -- authenticate
    -- APEX Custom Authentication entry point.
    -- Extensibility: to add LDAP or OCI IAM, configure a second APEX auth
    -- scheme — this function only handles auth_method = 'DB'.
    -- -------------------------------------------------------------------------
    FUNCTION authenticate (p_username IN VARCHAR2, p_password IN VARCHAR2)
        RETURN BOOLEAN
    IS
        l_hash     dct_users.password_hash%TYPE;
        l_method   dct_users.auth_method%TYPE;
        l_active   dct_users.is_active%TYPE;
        l_result   BOOLEAN := FALSE;
    BEGIN
        -- Fetch user record
        BEGIN
            SELECT password_hash, auth_method, is_active
            INTO   l_hash, l_method, l_active
            FROM   dct_users
            WHERE  UPPER(username) = UPPER(p_username)
              AND  ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_log(p_username, 'LOGIN', 'FAILURE', 'DCT_USERS', p_username,
                      'User not found');
                RETURN FALSE;
        END;

        -- Inactive account check
        IF l_active != 'Y' THEN
            p_log(p_username, 'LOGIN', 'FAILURE', 'DCT_USERS', p_username,
                  'Account is inactive');
            RETURN FALSE;
        END IF;

        -- Auth method dispatch
        CASE l_method
            WHEN 'DB' THEN
                -- Validate SHA-512 hash
                IF l_hash IS NULL THEN
                    p_log(p_username, 'LOGIN', 'FAILURE', 'DCT_USERS', p_username,
                          'No password set for DB auth user');
                    RETURN FALSE;
                END IF;
                l_result := (l_hash = hash_password(p_password));

            WHEN 'LDAP' THEN
                -- Placeholder: LDAP validation handled by APEX built-in scheme.
                -- If this function is called for an LDAP user, allow through
                -- (credential was already validated by the LDAP scheme).
                l_result := TRUE;

            WHEN 'OCI_IAM' THEN
                -- Placeholder: OCI IAM handled by APEX SAML/OIDC scheme.
                l_result := TRUE;

            WHEN 'SAML' THEN
                -- Placeholder: SAML handled by APEX SAML scheme.
                l_result := TRUE;

            ELSE
                p_log(p_username, 'LOGIN', 'FAILURE', 'DCT_USERS', p_username,
                      'Unknown auth_method: ' || l_method);
                RETURN FALSE;
        END CASE;

        -- Log result
        IF l_result THEN
            p_log(p_username, 'LOGIN', 'SUCCESS');
        ELSE
            p_log(p_username, 'LOGIN', 'FAILURE', 'DCT_USERS', p_username,
                  'Invalid credentials');
        END IF;

        RETURN l_result;

    EXCEPTION
        WHEN OTHERS THEN
            p_log(p_username, 'LOGIN', 'FAILURE', NULL, NULL, SQLERRM);
            RETURN FALSE;
    END authenticate;

    -- -------------------------------------------------------------------------
    -- post_login
    -- Fires after APEX session is created.
    -- Loads user context into APEX application items so every page can read
    -- them via :USER_ID, :USER_ROLES, :IS_ADMIN etc without re-querying.
    -- -------------------------------------------------------------------------
    PROCEDURE post_login (p_username IN VARCHAR2 DEFAULT NULL) IS
        l_username       VARCHAR2(100);
        l_user           dct_users%ROWTYPE;
        l_roles          VARCHAR2(4000);
        l_org_ids        VARCHAR2(4000);
        l_is_admin       VARCHAR2(1) := 'N';
        l_unread         NUMBER      := 0;
        l_delegate_for   VARCHAR2(100);
        l_perm_json      CLOB;

    BEGIN
        l_username := NVL(p_username, V('APP_USER'));

        -- Load user record
        BEGIN
            SELECT * INTO l_user
            FROM   dct_users
            WHERE  UPPER(username) = UPPER(l_username)
              AND  is_active = 'Y';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- Unknown user — deny access gracefully
                APEX_UTIL.SET_SESSION_STATE('USER_ID',           NULL);
                APEX_UTIL.SET_SESSION_STATE('USER_DISPLAY_NAME', l_username);
                APEX_UTIL.SET_SESSION_STATE('USER_ROLES',        NULL);
                APEX_UTIL.SET_SESSION_STATE('IS_ADMIN',          'N');
                RETURN;
        END;

        -- Roles (comma-delimited role_code)
        l_roles   := get_user_roles(l_username);

        -- Org IDs
        l_org_ids := get_user_org_ids(l_username);

        -- Admin flag — SYS_ADMIN role means IS_ADMIN = Y
        IF has_role(l_username, 'SYS_ADMIN') THEN
            l_is_admin := 'Y';
        END IF;

        -- Unread notification count
        SELECT COUNT(*) INTO l_unread
        FROM   dct_notifications
        WHERE  recipient_user_id = l_user.user_id
          AND  is_read = 'N'
          AND  (expires_at IS NULL OR expires_at > SYSTIMESTAMP);

        -- Active delegation: is this user currently delegating FOR someone?
        BEGIN
            SELECT delegator_username INTO l_delegate_for
            FROM   v_dct_active_delegations
            WHERE  UPPER(delegate_username) = UPPER(l_username)
              AND  ROWNUM = 1;
        EXCEPTION WHEN NO_DATA_FOUND THEN l_delegate_for := NULL;
        END;

        -- Populate APEX session state items
        -- These must be defined as Application Items in APEX App 200
        APEX_UTIL.SET_SESSION_STATE('USER_ID',              TO_CHAR(l_user.user_id));
        APEX_UTIL.SET_SESSION_STATE('USER_DISPLAY_NAME',    l_user.display_name);
        APEX_UTIL.SET_SESSION_STATE('USER_DISPLAY_NAME_AR', NVL(l_user.display_name_ar, l_user.display_name));
        APEX_UTIL.SET_SESSION_STATE('USER_EMAIL',           l_user.email);
        APEX_UTIL.SET_SESSION_STATE('USER_LANGUAGE',        l_user.language_pref);
        APEX_UTIL.SET_SESSION_STATE('USER_COLOR',           l_user.color_hex);
        APEX_UTIL.SET_SESSION_STATE('USER_PHOTO_URL',       l_user.photo_url);
        APEX_UTIL.SET_SESSION_STATE('USER_ORG_ID',          TO_CHAR(l_user.org_id));
        APEX_UTIL.SET_SESSION_STATE('USER_ORG_IDS',         l_org_ids);
        APEX_UTIL.SET_SESSION_STATE('USER_ROLES',           l_roles);
        APEX_UTIL.SET_SESSION_STATE('IS_ADMIN',             l_is_admin);
        APEX_UTIL.SET_SESSION_STATE('IS_EXTERNAL',          l_user.is_external);
        APEX_UTIL.SET_SESSION_STATE('UNREAD_NOTIFICATIONS', TO_CHAR(l_unread));
        APEX_UTIL.SET_SESSION_STATE('ACTIVE_DELEGATION_FOR', l_delegate_for);

        -- Update last login timestamp
        UPDATE dct_users
        SET    last_login_at = SYSTIMESTAMP,
               updated_by   = l_username
        WHERE  user_id = l_user.user_id;

        -- Register/refresh session record
        open_session(
            p_username    => l_username,
            p_session_id  => V('APP_SESSION'),
            p_auth_method => l_user.auth_method
        );

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            p_log(l_username, 'POST_LOGIN', 'FAILURE', NULL, NULL, SQLERRM);
    END post_login;

    -- -------------------------------------------------------------------------
    -- set_password  (DB auth method only)
    -- -------------------------------------------------------------------------
    PROCEDURE set_password (p_username IN VARCHAR2, p_password IN VARCHAR2) IS
    BEGIN
        UPDATE dct_users
        SET    password_hash = hash_password(p_password),
               auth_method   = 'DB',
               updated_by    = SYS_CONTEXT('APEX$SESSION','APP_USER'),
               updated_at    = SYSTIMESTAMP
        WHERE  UPPER(username) = UPPER(p_username);

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'User not found: ' || p_username);
        END IF;

        p_log(p_username, 'UPDATE', 'SUCCESS', 'DCT_USERS', p_username,
              'Password changed');
        COMMIT;
    END set_password;

    -- -------------------------------------------------------------------------
    -- open_session
    -- -------------------------------------------------------------------------
    PROCEDURE open_session (
        p_username    IN VARCHAR2,
        p_session_id  IN VARCHAR2,
        p_ip          IN VARCHAR2 DEFAULT NULL,
        p_agent       IN VARCHAR2 DEFAULT NULL,
        p_auth_method IN VARCHAR2 DEFAULT 'DB'
    ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        l_user_id dct_users.user_id%TYPE;
    BEGIN
        l_user_id := get_user_id(p_username);

        MERGE INTO dct_sessions s
        USING (SELECT p_session_id AS session_id FROM DUAL) src
        ON    (s.session_id = src.session_id)
        WHEN MATCHED THEN
            UPDATE SET last_activity_at = SYSTIMESTAMP, is_active = 'Y'
        WHEN NOT MATCHED THEN
            INSERT (session_id, user_id, username, login_at, last_activity_at,
                    ip_address, user_agent, auth_method, is_active)
            VALUES (p_session_id, l_user_id, p_username, SYSTIMESTAMP,
                    SYSTIMESTAMP, p_ip, p_agent, p_auth_method, 'Y');
        COMMIT;
    EXCEPTION WHEN OTHERS THEN NULL;
    END open_session;

    -- -------------------------------------------------------------------------
    -- close_session  (called from logout page process)
    -- -------------------------------------------------------------------------
    PROCEDURE close_session (p_session_id IN VARCHAR2) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        l_username VARCHAR2(100);
    BEGIN
        UPDATE dct_sessions
        SET    logout_at       = SYSTIMESTAMP,
               is_active       = 'N'
        WHERE  session_id      = p_session_id
        RETURNING username INTO l_username;

        COMMIT;
        p_log(l_username, 'LOGOUT', 'SUCCESS');
    EXCEPTION WHEN OTHERS THEN NULL;
    END close_session;

    -- -------------------------------------------------------------------------
    -- touch_session  (call from application process on each page load)
    -- -------------------------------------------------------------------------
    PROCEDURE touch_session (p_session_id IN VARCHAR2) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        UPDATE dct_sessions
        SET    last_activity_at = SYSTIMESTAMP
        WHERE  session_id       = p_session_id
          AND  is_active        = 'Y';
        COMMIT;
    EXCEPTION WHEN OTHERS THEN NULL;
    END touch_session;

END dct_auth;
/

-- =============================================================================
-- SYNONYM for convenience (optional — lets domain apps call dct_auth without
-- schema prefix if they are in the same schema)
-- =============================================================================
-- CREATE OR REPLACE PUBLIC SYNONYM dct_auth FOR prod.dct_auth;
-- GRANT EXECUTE ON dct_auth TO PUBLIC;  -- restrict to app schema only in prod

SHOW ERRORS PACKAGE BODY dct_auth;
-- End of 03_dct_auth_pkg.sql
