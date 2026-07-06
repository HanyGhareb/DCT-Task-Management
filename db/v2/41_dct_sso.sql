-- =============================================================================
-- 41_dct_sso.sql  --  Cross-UI single sign-on hand-off (JET <-> APEX App 200)
--
-- One-time, single-use, hashed hand-off codes bridged over the existing
-- DCT_AUTH / DCT_SESSIONS backbone (authorization-code style):
--
--   JET -> APEX : POST /dct/sso/code issues a JET2APEX code; the APEX login
--                 page (9999) exchanges it via apex_authentication.login with
--                 the sentinel password SSO$<code>, which dct_auth.authenticate
--                 redeems below. Normal APEX login flow then completes.
--   APEX -> JET : an authenticated APEX page issues an APEX2JET code and
--                 redirects to the Admin JET app with #sso=<code>; the app
--                 exchanges it at POST /dct/auth/sso for a bearer session.
--
-- Objects:
--   PROD.DCT_SSO_CODES        one-time codes (hash at rest, TTL, single-use)
--   PROD.DCT_SSO_PKG          issue_code / peek_username / redeem_code
--   PROD.DCT_AUTH             body replaced: authenticate gains the SSO$ branch
--   Lookup category SSO_DIRECTION (JET2APEX / APEX2JET)
--   Settings: FEATURE_SSO_HANDOFF (N), SSO_CODE_TTL_SECS (60),
--             APEX_SSO_URL, JET_SSO_URL           (category SECURITY)
--
-- FEATURE_SSO_HANDOFF ships to every app via GET /dct/boot automatically
-- (the boot handler already whitelists all FEATURE_ keys).
--
-- Rerunnable. Run as ADMIN via SQLcl (all objects prod.-qualified).
-- ORDS endpoints live in 41b_dct_sso_ords.sql (fresh session).
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

PROMPT === 1. Table PROD.DCT_SSO_CODES ===

BEGIN
    EXECUTE IMMEDIATE q'[
CREATE TABLE prod.dct_sso_codes (
    code_hash         VARCHAR2(64)   NOT NULL PRIMARY KEY,
    user_id           NUMBER         NOT NULL,
    username          VARCHAR2(100)  NOT NULL,
    direction         VARCHAR2(20)   NOT NULL,
    issued_session_id VARCHAR2(100),
    ip_address        VARCHAR2(50),
    user_agent        VARCHAR2(500),
    created_at        TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    expires_at        TIMESTAMP      NOT NULL,
    used_at           TIMESTAMP,
    CONSTRAINT fk_dct_ssoc_user FOREIGN KEY (user_id) REFERENCES prod.dct_users(user_id)
)]';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -955 THEN RAISE; END IF;   -- already exists
END;
/

COMMENT ON TABLE prod.dct_sso_codes IS
    'One-time SSO hand-off codes between the JET suite and APEX App 200. Code value is stored hashed; rows are single-use and short-lived.';

PROMPT === 2. Lookup category SSO_DIRECTION ===

DECLARE
    v_cat NUMBER;

    PROCEDURE upsert_category (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, o_id OUT NUMBER) IS
    BEGIN
        MERGE INTO prod.dct_lookup_categories t
        USING (SELECT p_code AS category_code FROM dual) s
        ON (t.category_code = s.category_code)
        WHEN NOT MATCHED THEN
            INSERT (category_code, category_name_en, category_name_ar, module_id, is_system, is_active)
            VALUES (p_code, p_en, p_ar, NULL, 'Y', 'Y')
        WHEN MATCHED THEN
            UPDATE SET t.category_name_en = p_en, t.category_name_ar = p_ar;
        SELECT category_id INTO o_id FROM prod.dct_lookup_categories WHERE category_code = p_code;
    END;

    PROCEDURE upsert_value (p_cat NUMBER, p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, p_ord NUMBER) IS
    BEGIN
        MERGE INTO prod.dct_lookup_values t
        USING (SELECT p_cat AS category_id, p_code AS value_code FROM dual) s
        ON (t.category_id = s.category_id AND t.value_code = s.value_code)
        WHEN NOT MATCHED THEN
            INSERT (category_id, value_code, value_name_en, value_name_ar, display_order, is_default, is_active)
            VALUES (p_cat, p_code, p_en, p_ar, p_ord, 'N', 'Y')
        WHEN MATCHED THEN
            UPDATE SET t.value_name_en = p_en, t.value_name_ar = p_ar, t.display_order = p_ord;
    END;
BEGIN
    upsert_category('SSO_DIRECTION', 'SSO Hand-off Direction', 'اتجاه الدخول الموحد', v_cat);
    upsert_value(v_cat, 'JET2APEX', 'JET to APEX', 'من JET إلى APEX', 10);
    upsert_value(v_cat, 'APEX2JET', 'APEX to JET', 'من APEX إلى JET', 20);
    COMMIT;
END;
/

PROMPT === 3. Package PROD.DCT_SSO_PKG ===

CREATE OR REPLACE PACKAGE prod.dct_sso_pkg AS

    -- Issue a one-time hand-off code for an active user. Returns the clear
    -- code (64 hex chars); only its SHA-256 is stored. Raises:
    --   -20403 when FEATURE_SSO_HANDOFF is not Y
    --   -20404 when the user does not exist or is inactive
    FUNCTION issue_code (
        p_username   IN VARCHAR2,
        p_direction  IN VARCHAR2,               -- JET2APEX / APEX2JET
        p_session_id IN VARCHAR2 DEFAULT NULL,  -- issuing side session reference
        p_ip         IN VARCHAR2 DEFAULT NULL,
        p_agent      IN VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2;

    -- Non-consuming username lookup of a still-valid code. Returns NULL when
    -- the code is unknown / used / expired (the APEX login page falls back to
    -- the normal credential form on NULL).
    FUNCTION peek_username (p_code IN VARCHAR2) RETURN VARCHAR2;

    -- Consume a code exactly once (atomic). Returns the username. Raises:
    --   -20401 when the code is invalid, expired, already used, of the wrong
    --          direction, or the user is no longer active
    --   -20403 when FEATURE_SSO_HANDOFF is not Y
    FUNCTION redeem_code (p_code IN VARCHAR2, p_direction IN VARCHAR2) RETURN VARCHAR2;

END dct_sso_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_sso_pkg AS

    -- -------------------------------------------------------------------------
    -- PRIVATE: SHA-256 of the clear code (64 hex chars). Only hashes at rest.
    -- -------------------------------------------------------------------------
    FUNCTION hash_code (p_code IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        IF p_code IS NULL OR LENGTH(p_code) > 200 THEN
            RETURN NULL;
        END IF;
        RETURN RAWTOHEX(
            DBMS_CRYPTO.HASH(
                UTL_I18N.STRING_TO_RAW(p_code, 'AL32UTF8'),
                DBMS_CRYPTO.HASH_SH256
            )
        );
    END hash_code;

    -- -------------------------------------------------------------------------
    -- PRIVATE: audit trail — never blocks the auth path on a logging failure.
    -- -------------------------------------------------------------------------
    PROCEDURE p_audit (
        p_username IN VARCHAR2,
        p_action   IN VARCHAR2,
        p_status   IN VARCHAR2,
        p_detail   IN VARCHAR2 DEFAULT NULL
    ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        l_user_id prod.dct_users.user_id%TYPE;
    BEGIN
        BEGIN
            SELECT user_id INTO l_user_id
            FROM   prod.dct_users
            WHERE  UPPER(username) = UPPER(p_username)
              AND  ROWNUM = 1;
        EXCEPTION WHEN NO_DATA_FOUND THEN l_user_id := NULL;
        END;

        INSERT INTO prod.dct_audit_log (
            username, user_id, action, object_type, object_id, status, error_message
        ) VALUES (
            p_username, l_user_id, p_action, 'DCT_SSO_CODES', p_username, p_status, p_detail
        );
        COMMIT;
    EXCEPTION WHEN OTHERS THEN NULL;
    END p_audit;

    -- -------------------------------------------------------------------------
    -- PRIVATE: feature gate.
    -- -------------------------------------------------------------------------
    PROCEDURE gate_check IS
        l_val prod.dct_system_settings.setting_value%TYPE;
    BEGIN
        BEGIN
            SELECT setting_value INTO l_val
            FROM   prod.dct_system_settings
            WHERE  setting_key = 'FEATURE_SSO_HANDOFF';
        EXCEPTION WHEN NO_DATA_FOUND THEN l_val := 'N';
        END;
        IF NVL(l_val, 'N') != 'Y' THEN
            RAISE_APPLICATION_ERROR(-20403, 'SSO hand-off is disabled');
        END IF;
    END gate_check;

    -- -------------------------------------------------------------------------
    -- PRIVATE: configured TTL in seconds, bounded 10..600.
    -- -------------------------------------------------------------------------
    FUNCTION code_ttl RETURN NUMBER IS
        l_ttl NUMBER;
    BEGIN
        SELECT TO_NUMBER(setting_value) INTO l_ttl
        FROM   prod.dct_system_settings
        WHERE  setting_key = 'SSO_CODE_TTL_SECS';
        RETURN GREATEST(10, LEAST(600, NVL(l_ttl, 60)));
    EXCEPTION WHEN OTHERS THEN RETURN 60;
    END code_ttl;

    -- -------------------------------------------------------------------------
    -- issue_code
    -- -------------------------------------------------------------------------
    FUNCTION issue_code (
        p_username   IN VARCHAR2,
        p_direction  IN VARCHAR2,
        p_session_id IN VARCHAR2 DEFAULT NULL,
        p_ip         IN VARCHAR2 DEFAULT NULL,
        p_agent      IN VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2 IS
        l_user_id prod.dct_users.user_id%TYPE;
        l_code    VARCHAR2(64);
        l_hash    VARCHAR2(64);   -- body-private fns cannot appear in SQL (PLS-00231):
        l_ttl     NUMBER;         -- assign hash_code/code_ttl to locals before SQL use
    BEGIN
        gate_check;
        prod.dct_lookup_pkg.validate_lookup('SSO_DIRECTION', p_direction);

        BEGIN
            SELECT user_id INTO l_user_id
            FROM   prod.dct_users
            WHERE  UPPER(username) = UPPER(p_username)
              AND  is_active = 'Y'
              AND  ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_audit(p_username, 'SSO_ISSUE', 'FAILURE', 'User not found or inactive');
                RAISE_APPLICATION_ERROR(-20404, 'User not found or inactive');
        END;

        -- Opportunistic housekeeping: expired codes have no forensic value
        -- beyond one hour (issue/redeem outcomes live in dct_audit_log).
        -- expires_at is a plain TIMESTAMP holding UTC; compare via
        -- SYS_EXTRACT_UTC or the session time zone skews the comparison.
        DELETE FROM prod.dct_sso_codes
        WHERE  expires_at < SYS_EXTRACT_UTC(SYSTIMESTAMP) - INTERVAL '1' HOUR;

        l_code := RAWTOHEX(DBMS_CRYPTO.RANDOMBYTES(32));
        l_hash := hash_code(l_code);
        l_ttl  := code_ttl;

        INSERT INTO prod.dct_sso_codes (
            code_hash, user_id, username, direction,
            issued_session_id, ip_address, user_agent, expires_at
        ) VALUES (
            l_hash, l_user_id, UPPER(p_username), p_direction,
            p_session_id, p_ip, SUBSTR(p_agent, 1, 500),
            SYS_EXTRACT_UTC(SYSTIMESTAMP) + NUMTODSINTERVAL(l_ttl, 'SECOND')
        );
        COMMIT;

        p_audit(p_username, 'SSO_ISSUE', 'SUCCESS', p_direction);
        RETURN l_code;
    END issue_code;

    -- -------------------------------------------------------------------------
    -- peek_username
    -- -------------------------------------------------------------------------
    FUNCTION peek_username (p_code IN VARCHAR2) RETURN VARCHAR2 IS
        l_username prod.dct_sso_codes.username%TYPE;
        l_hash     VARCHAR2(64);
    BEGIN
        gate_check;
        l_hash := hash_code(p_code);
        IF l_hash IS NULL THEN
            RETURN NULL;
        END IF;
        SELECT username INTO l_username
        FROM   prod.dct_sso_codes
        WHERE  code_hash  = l_hash
          AND  used_at    IS NULL
          AND  expires_at > SYS_EXTRACT_UTC(SYSTIMESTAMP);
        RETURN l_username;
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
    END peek_username;

    -- -------------------------------------------------------------------------
    -- redeem_code
    -- -------------------------------------------------------------------------
    FUNCTION redeem_code (p_code IN VARCHAR2, p_direction IN VARCHAR2) RETURN VARCHAR2 IS
        l_username prod.dct_sso_codes.username%TYPE;
        l_active   prod.dct_users.is_active%TYPE;
        l_hash     VARCHAR2(64);
    BEGIN
        gate_check;

        l_hash := hash_code(p_code);
        IF l_hash IS NULL THEN
            p_audit('UNKNOWN', 'SSO_REDEEM', 'FAILURE', 'Malformed code (' || p_direction || ')');
            RAISE_APPLICATION_ERROR(-20401, 'Invalid or expired SSO code');
        END IF;

        -- Atomic single-use consumption: only one caller can flip used_at.
        UPDATE prod.dct_sso_codes
        SET    used_at    = SYSTIMESTAMP
        WHERE  code_hash  = l_hash
          AND  used_at    IS NULL
          AND  expires_at > SYS_EXTRACT_UTC(SYSTIMESTAMP)
          AND  direction  = p_direction
        RETURNING username INTO l_username;

        IF SQL%ROWCOUNT = 0 THEN
            COMMIT;
            p_audit('UNKNOWN', 'SSO_REDEEM', 'FAILURE',
                    'Invalid, expired or already-used code (' || p_direction || ')');
            RAISE_APPLICATION_ERROR(-20401, 'Invalid or expired SSO code');
        END IF;
        COMMIT;

        -- The account must still be active at redemption time.
        BEGIN
            SELECT is_active INTO l_active
            FROM   prod.dct_users
            WHERE  UPPER(username) = UPPER(l_username)
              AND  ROWNUM = 1;
        EXCEPTION WHEN NO_DATA_FOUND THEN l_active := 'N';
        END;
        IF l_active != 'Y' THEN
            p_audit(l_username, 'SSO_REDEEM', 'FAILURE', 'Account inactive at redemption');
            RAISE_APPLICATION_ERROR(-20401, 'Invalid or expired SSO code');
        END IF;

        p_audit(l_username, 'SSO_REDEEM', 'SUCCESS', p_direction);
        RETURN l_username;
    END redeem_code;

END dct_sso_pkg;
/

SHOW ERRORS PACKAGE BODY prod.dct_sso_pkg

PROMPT === 4. DCT_AUTH body — authenticate gains the SSO hand-off branch ===
-- Full body replace (spec unchanged). Source of truth 03_dct_auth_pkg.sql
-- carries the same code; the only change vs the previous body is the
-- SSO$ branch inside authenticate.

CREATE OR REPLACE PACKAGE BODY prod.dct_auth AS

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
        -- Own authority always applies; delegation only ADDS the delegator's.
        SELECT COUNT(*)
        INTO   l_count
        FROM   v_dct_user_active_roles
        WHERE  UPPER(username)  = UPPER(p_username)
          AND  UPPER(role_code) = UPPER(p_role_code);
        IF l_count > 0 THEN RETURN TRUE; END IF;
        l_eff := get_effective_user(p_username);
        IF UPPER(l_eff) = UPPER(p_username) THEN RETURN FALSE; END IF;
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
        -- Own authority always applies; delegation only ADDS the delegator's.
        SELECT COUNT(*)
        INTO   l_count
        FROM   v_dct_user_permissions
        WHERE  UPPER(username)        = UPPER(p_username)
          AND  UPPER(permission_code) = UPPER(p_permission_code);
        IF l_count > 0 THEN RETURN TRUE; END IF;
        l_eff := get_effective_user(p_username);
        IF UPPER(l_eff) = UPPER(p_username) THEN RETURN FALSE; END IF;
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
        -- Own authority always applies; delegation only ADDS the delegator's.
        SELECT COUNT(*)
        INTO   l_count
        FROM   v_dct_module_access
        WHERE  UPPER(username)    = UPPER(p_username)
          AND  UPPER(module_code) = UPPER(p_module_code);
        IF l_count > 0 THEN RETURN TRUE; END IF;
        l_eff := get_effective_user(p_username);
        IF UPPER(l_eff) = UPPER(p_username) THEN RETURN FALSE; END IF;
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

        -- Cross-UI single sign-on (41_dct_sso.sql): a password of the form
        -- SSO$<code> is a one-time hand-off code issued by dct_sso_pkg, not a
        -- stored credential. Redeem it (single-use) and match the username.
        IF p_password LIKE 'SSO$%' THEN
            BEGIN
                l_result := (UPPER(dct_sso_pkg.redeem_code(SUBSTR(p_password, 5), 'JET2APEX'))
                             = UPPER(p_username));
            EXCEPTION WHEN OTHERS THEN
                l_result := FALSE;
            END;
            IF l_result THEN
                p_log(p_username, 'LOGIN', 'SUCCESS', 'DCT_USERS', p_username,
                      'SSO hand-off');
            ELSE
                p_log(p_username, 'LOGIN', 'FAILURE', 'DCT_USERS', p_username,
                      'Invalid or expired SSO hand-off code');
            END IF;
            RETURN l_result;
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

SHOW ERRORS PACKAGE BODY prod.dct_auth

PROMPT === 5. System settings (category SECURITY) ===

INSERT INTO prod.dct_system_settings (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
SELECT 'FEATURE_SSO_HANDOFF', 'N', 'BOOLEAN', 'SECURITY',
       'Enable the one-time hand-off single sign-on between the JET suite and APEX App 200.', 'Y', 'SYSTEM'
FROM dual WHERE NOT EXISTS
  (SELECT 1 FROM prod.dct_system_settings WHERE setting_key = 'FEATURE_SSO_HANDOFF');

INSERT INTO prod.dct_system_settings (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
SELECT 'SSO_CODE_TTL_SECS', '60', 'NUMBER', 'SECURITY',
       'Lifetime in seconds of a one-time SSO hand-off code (bounded 10-600).', 'Y', 'SYSTEM'
FROM dual WHERE NOT EXISTS
  (SELECT 1 FROM prod.dct_system_settings WHERE setting_key = 'SSO_CODE_TTL_SECS');

INSERT INTO prod.dct_system_settings (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
SELECT 'APEX_SSO_URL',
       'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/f?p=200:9999:0::::P9999_SSO_CODE:',
       'STRING', 'SECURITY',
       'APEX App 200 login URL prefix for the JET-to-APEX hand-off; the one-time code is appended.', 'Y', 'SYSTEM'
FROM dual WHERE NOT EXISTS
  (SELECT 1 FROM prod.dct_system_settings WHERE setting_key = 'APEX_SSO_URL');

INSERT INTO prod.dct_system_settings (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
SELECT 'JET_SSO_URL', 'http://localhost:8080/index.html', 'STRING', 'SECURITY',
       'Admin JET app URL for the APEX-to-JET hand-off; #sso=<code> is appended. Set to the production host when JET hosting is finalised.', 'Y', 'SYSTEM'
FROM dual WHERE NOT EXISTS
  (SELECT 1 FROM prod.dct_system_settings WHERE setting_key = 'JET_SSO_URL');

COMMIT;

PROMPT === 6. Verify ===

SELECT setting_key, setting_value
FROM   prod.dct_system_settings
WHERE  setting_key IN ('FEATURE_SSO_HANDOFF','SSO_CODE_TTL_SECS','APEX_SSO_URL','JET_SSO_URL')
ORDER  BY setting_key;

SELECT object_name, object_type, status
FROM   dba_objects
WHERE  owner = 'PROD'
AND    object_name IN ('DCT_SSO_CODES','DCT_SSO_PKG','DCT_AUTH')
ORDER  BY object_name, object_type;

PROMPT === 41_dct_sso.sql complete ===
