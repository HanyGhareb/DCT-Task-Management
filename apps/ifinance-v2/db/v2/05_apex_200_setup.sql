-- =============================================================================
-- i-Finance V2 — APEX App 200 Setup (APEX 24.2 correct API)
-- File    : 05_apex_200_setup.sql
-- Packages: wwv_flow_imp, wwv_flow_imp_shared, wwv_flow_imp_page
-- Run as  : ADMIN via SQLcl
-- =============================================================================
--
-- APEX 24.2 API notes (learned from constraint violations):
--   p_scheme_type        => 'NATIVE_CUSTOM'  (not 'CUSTOM' — check WWV_FLOW_AUTHENTICATIONS_CK2)
--   p_protection_level   => 'N'=Unrestricted, 'S'=Checksum, 'I'=Restricted  (not 'U')
--   Global App Processes => wwv_flow_imp_shared.create_flow_process  (no p_flow_step_id)
--   Page Processes       => wwv_flow_imp_page.create_page_process    (with p_flow_step_id)
--
-- =============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF

-- =============================================================================
-- 0. WORKSPACE CONTEXT  (required before every wwv_flow_imp call)
-- =============================================================================
BEGIN
    wwv_flow_imp.import_begin(
        p_version_yyyy_mm_dd     => '2024.05.31',
        p_release                => '24.2.15',
        p_default_workspace_id   => 9249752073687531,
        p_default_application_id => 200,
        p_default_id_offset      => 0,
        p_default_owner          => 'PROD'
    );
    DBMS_OUTPUT.PUT_LINE('import_begin OK — workspace PROD');
END;
/

-- =============================================================================
-- 1. CREATE APPLICATION  (App 200)
--    p_authentication_id => 100  references DCT Custom Auth created below
--    p_theme_id          => 42   Universal Theme (Redwood Light)
-- =============================================================================
PROMPT Creating Application 200...
BEGIN
    wwv_flow_imp.create_flow(
        p_id                         => 200,
        p_owner                      => 'PROD',
        p_name                       => 'i-Finance V2',
        p_alias                      => 'I-FINANCE-V2',
        p_flow_language              => 'en',
        p_flow_language_derived_from => 'BROWSER',
        p_direction_right_to_left    => 'N',
        p_flow_image_prefix          => '#APP_IMAGES#',
        p_flow_status                => 'AVAILABLE',
        p_flow_version               => 'V2.0',
        p_theme_id                   => 42,
        p_authentication_id          => 100,
        p_exact_substitutions_only   => 'Y',
        p_deep_linking               => 'N',
        p_page_view_logging          => 'YES',
        p_substitution_string_01     => 'APP_NAME',
        p_substitution_value_01      => 'i-Finance V2',
        p_substitution_string_02     => 'APP_NAME_AR',
        p_substitution_value_02      => 'آي فاينانس V2'
    );
    DBMS_OUTPUT.PUT_LINE('Application 200 created.');
END;
/

-- =============================================================================
-- 2. AUTHENTICATION SCHEME — DCT Custom Auth  (ID 100)
--    p_scheme_type MUST be 'NATIVE_CUSTOM' (constraint WWV_FLOW_AUTHENTICATIONS_CK2
--    requires 'NATIVE_' or 'PLUGIN_' prefix — plain 'CUSTOM' is rejected)
-- =============================================================================
PROMPT Creating Authentication Scheme...
BEGIN
    wwv_flow_imp_shared.create_authentication(
        p_id                   => 100,
        p_flow_id              => 200,
        p_name                 => 'DCT Custom Auth',
        p_scheme_type          => 'NATIVE_CUSTOM',
        p_attribute_01         => 'dct_auth.authenticate',
        p_post_auth_process    => 'dct_auth.post_login',
        p_invalid_session_type => 'LOGIN',
        p_invalid_session_url  => 'f?p=200:9999:0',
        p_logout_url           => 'f?p=200:9998:&APP_SESSION.',
        p_use_secure_cookie_yn => 'N',
        p_ras_mode             => 0
    );
    DBMS_OUTPUT.PUT_LINE('Authentication scheme created.');
END;
/

-- =============================================================================
-- 3. APPLICATION ITEMS  (14 session-state variables)
--    Protection: 'S' = Checksum Required (security-sensitive IDs)
--                'N' = Unrestricted (display/preference values)
--    Note: 'U' is NOT a valid value — constraint VALID_FITEMS_PROTECTION_LEVEL
--          only accepts: N, B, P, S, I
-- =============================================================================
PROMPT Creating Application Items...
BEGIN
    wwv_flow_imp_shared.create_flow_item(p_id=>201, p_flow_id=>200, p_name=>'USER_ID',               p_protection_level=>'S');
    wwv_flow_imp_shared.create_flow_item(p_id=>202, p_flow_id=>200, p_name=>'USER_DISPLAY_NAME',      p_protection_level=>'N');
    wwv_flow_imp_shared.create_flow_item(p_id=>203, p_flow_id=>200, p_name=>'USER_DISPLAY_NAME_AR',   p_protection_level=>'N');
    wwv_flow_imp_shared.create_flow_item(p_id=>204, p_flow_id=>200, p_name=>'USER_EMAIL',             p_protection_level=>'N');
    wwv_flow_imp_shared.create_flow_item(p_id=>205, p_flow_id=>200, p_name=>'USER_LANGUAGE',          p_protection_level=>'N');
    wwv_flow_imp_shared.create_flow_item(p_id=>206, p_flow_id=>200, p_name=>'USER_COLOR',             p_protection_level=>'N');
    wwv_flow_imp_shared.create_flow_item(p_id=>207, p_flow_id=>200, p_name=>'USER_PHOTO_URL',         p_protection_level=>'N');
    wwv_flow_imp_shared.create_flow_item(p_id=>208, p_flow_id=>200, p_name=>'USER_ORG_ID',            p_protection_level=>'S');
    wwv_flow_imp_shared.create_flow_item(p_id=>209, p_flow_id=>200, p_name=>'USER_ORG_IDS',           p_protection_level=>'S');
    wwv_flow_imp_shared.create_flow_item(p_id=>210, p_flow_id=>200, p_name=>'USER_ROLES',             p_protection_level=>'S');
    wwv_flow_imp_shared.create_flow_item(p_id=>211, p_flow_id=>200, p_name=>'IS_ADMIN',               p_protection_level=>'S');
    wwv_flow_imp_shared.create_flow_item(p_id=>212, p_flow_id=>200, p_name=>'IS_EXTERNAL',            p_protection_level=>'S');
    wwv_flow_imp_shared.create_flow_item(p_id=>213, p_flow_id=>200, p_name=>'UNREAD_NOTIFICATIONS',   p_protection_level=>'N');
    wwv_flow_imp_shared.create_flow_item(p_id=>214, p_flow_id=>200, p_name=>'ACTIVE_DELEGATION_FOR',  p_protection_level=>'N');
    DBMS_OUTPUT.PUT_LINE('14 Application Items created.');
END;
/

-- =============================================================================
-- 4. AUTHORIZATION SCHEMES  (7 schemes)
--    Caching: BY_USER_BY_SESSION  = evaluated once per session (cheap, role-based)
--             BY_USER_BY_PAGE_VIEW = evaluated every request (permission can change)
-- =============================================================================
PROMPT Creating Authorization Schemes...
BEGIN
    wwv_flow_imp_shared.create_security_scheme(
        p_id            => 300,
        p_flow_id       => 200,
        p_name          => 'Is Platform User',
        p_scheme_type   => 'NATIVE_PLSQL',
        p_attribute_01  => 'RETURN dct_auth.has_role(:APP_USER, ''PLATFORM_USER'');',
        p_error_message => 'You do not have access to this application.',
        p_caching       => 'BY_USER_BY_SESSION'
    );

    wwv_flow_imp_shared.create_security_scheme(
        p_id            => 301,
        p_flow_id       => 200,
        p_name          => 'Is SYS_ADMIN',
        p_scheme_type   => 'NATIVE_PLSQL',
        p_attribute_01  => 'RETURN dct_auth.has_role(:APP_USER, ''SYS_ADMIN'');',
        p_error_message => 'System Administrator access required.',
        p_caching       => 'BY_USER_BY_SESSION'
    );

    wwv_flow_imp_shared.create_security_scheme(
        p_id            => 302,
        p_flow_id       => 200,
        p_name          => 'Is USER_ADMIN',
        p_scheme_type   => 'NATIVE_PLSQL',
        p_attribute_01  => 'RETURN dct_auth.has_role(:APP_USER, ''USER_ADMIN'') OR dct_auth.has_role(:APP_USER, ''SYS_ADMIN'');',
        p_error_message => 'User Administrator access required.',
        p_caching       => 'BY_USER_BY_SESSION'
    );

    wwv_flow_imp_shared.create_security_scheme(
        p_id            => 303,
        p_flow_id       => 200,
        p_name          => 'Is ORG_ADMIN',
        p_scheme_type   => 'NATIVE_PLSQL',
        p_attribute_01  => 'RETURN dct_auth.has_role(:APP_USER, ''ORG_ADMIN'') OR dct_auth.has_role(:APP_USER, ''SYS_ADMIN'');',
        p_error_message => 'Organisation Administrator access required.',
        p_caching       => 'BY_USER_BY_SESSION'
    );

    wwv_flow_imp_shared.create_security_scheme(
        p_id            => 304,
        p_flow_id       => 200,
        p_name          => 'Is Auditor',
        p_scheme_type   => 'NATIVE_PLSQL',
        p_attribute_01  => 'RETURN dct_auth.has_role(:APP_USER, ''AUDITOR'') OR dct_auth.has_role(:APP_USER, ''SYS_ADMIN'');',
        p_error_message => 'Auditor access required.',
        p_caching       => 'BY_USER_BY_SESSION'
    );

    wwv_flow_imp_shared.create_security_scheme(
        p_id            => 305,
        p_flow_id       => 200,
        p_name          => 'Is Task Director',
        p_scheme_type   => 'NATIVE_PLSQL',
        p_attribute_01  => 'RETURN dct_auth.has_role(:APP_USER, ''TASK_DIRECTOR'');',
        p_error_message => 'Finance Director access required.',
        p_caching       => 'BY_USER_BY_SESSION'
    );

    wwv_flow_imp_shared.create_security_scheme(
        p_id            => 306,
        p_flow_id       => 200,
        p_name          => 'Can Manage Users',
        p_scheme_type   => 'NATIVE_PLSQL',
        p_attribute_01  => 'RETURN dct_auth.has_permission(:APP_USER, ''USERS.EDIT'');',
        p_error_message => 'User management permission required.',
        p_caching       => 'BY_USER_BY_PAGE_VIEW'
    );

    DBMS_OUTPUT.PUT_LINE('7 Authorization Schemes created.');
END;
/

-- =============================================================================
-- 5. PAGE SHELLS
--    Minimal create — UI built in APEX Builder after this script runs.
--    Pages 9999/9998/9997 are public; page 1 requires authentication.
-- =============================================================================
PROMPT Creating page shells...
BEGIN
    wwv_flow_imp_page.create_page(
        p_id         => 9999,
        p_flow_id    => 200,
        p_name       => 'Login',
        p_alias      => 'LOGIN',
        p_step_title => 'Login'
    );

    wwv_flow_imp_page.create_page(
        p_id         => 9998,
        p_flow_id    => 200,
        p_name       => 'Logout',
        p_alias      => 'LOGOUT',
        p_step_title => 'Logout'
    );

    wwv_flow_imp_page.create_page(
        p_id         => 9997,
        p_flow_id    => 200,
        p_name       => 'Unauthorized',
        p_alias      => 'UNAUTHORIZED',
        p_step_title => 'Access Denied'
    );

    wwv_flow_imp_page.create_page(
        p_id         => 1,
        p_flow_id    => 200,
        p_name       => 'Home',
        p_alias      => 'HOME',
        p_step_title => 'Home'
    );

    DBMS_OUTPUT.PUT_LINE('4 page shells created (9999, 9998, 9997, 1).');
END;
/

-- =============================================================================
-- 6. GLOBAL APPLICATION PROCESSES  (run on every page request)
--    Use wwv_flow_imp_SHARED.create_flow_process — NOT wwv_flow_imp_page.
--    wwv_flow_imp_page.create_page_process with p_flow_step_id=>0 fails with
--    ORA-02291 because page 0 has no physical row in wwv_flow_steps.
-- =============================================================================
PROMPT Creating Global Application Processes...
BEGIN
    wwv_flow_imp_shared.create_flow_process(
        p_id                    => 400,
        p_flow_id               => 200,
        p_process_sequence      => 10,
        p_process_point         => 'BEFORE_HEADER',
        p_process_type          => 'NATIVE_PLSQL',
        p_process_name          => 'Touch Session',
        p_process_sql_clob      => 'dct_auth.touch_session(V(''APP_SESSION''));',
        p_process_clob_language => 'PLSQL',
        p_process_error_message => '#SQLERRM#'
    );

    wwv_flow_imp_shared.create_flow_process(
        p_id                    => 401,
        p_flow_id               => 200,
        p_process_sequence      => 20,
        p_process_point         => 'BEFORE_HEADER',
        p_process_type          => 'NATIVE_PLSQL',
        p_process_name          => 'Refresh Notification Count',
        p_process_sql_clob      => 'APEX_UTIL.SET_SESSION_STATE(''UNREAD_NOTIFICATIONS'', dct_notify.get_unread_count(TO_NUMBER(:USER_ID)));',
        p_process_clob_language => 'PLSQL',
        p_process_error_message => '#SQLERRM#'
    );

    DBMS_OUTPUT.PUT_LINE('2 global Application Processes created.');
END;
/

-- =============================================================================
-- 7. PAGE PROCESS — Logout (page 9998 only)
--    This IS a page-level process, so wwv_flow_imp_page is correct here.
-- =============================================================================
PROMPT Creating Logout process on page 9998...
BEGIN
    wwv_flow_imp_page.create_page_process(
        p_id                    => 600,
        p_flow_id               => 200,
        p_flow_step_id          => 9998,
        p_process_sequence      => 10,
        p_process_point         => 'BEFORE_HEADER',
        p_process_type          => 'NATIVE_PLSQL',
        p_process_name          => 'Logout',
        p_process_sql_clob      =>
            'BEGIN'                                           || CHR(10) ||
            '    dct_auth.close_session(:APP_SESSION);'      || CHR(10) ||
            '    APEX_AUTHENTICATION.LOGOUT('                || CHR(10) ||
            '        p_next_app_id  => 200,'                 || CHR(10) ||
            '        p_next_page_id => 9999'                 || CHR(10) ||
            '    );'                                          || CHR(10) ||
            'END;',
        p_process_clob_language => 'PLSQL',
        p_process_error_message => '#SQLERRM#'
    );
    DBMS_OUTPUT.PUT_LINE('Logout process created on page 9998.');
END;
/

-- =============================================================================
-- VERIFY
-- =============================================================================
PROMPT
PROMPT Verifying App 200...

SELECT application_id, application_name, alias
FROM   apex_applications
WHERE  application_id = 200;

SELECT item_name, session_state_protection
FROM   apex_application_items
WHERE  application_id = 200
ORDER  BY item_name;

SELECT authorization_scheme_name, scheme_type
FROM   apex_application_authorization
WHERE  application_id = 200
ORDER  BY authorization_scheme_name;

SELECT page_id, page_name, page_alias
FROM   apex_application_pages
WHERE  application_id = 200
ORDER  BY page_id;

SELECT process_name, process_point, process_sequence
FROM   apex_application_processes
WHERE  application_id = 200
ORDER  BY process_sequence;

PROMPT ============================================================
PROMPT  App 200 shell complete.  Next steps in APEX Builder:
PROMPT
PROMPT  1. Page 9999 (Login)
PROMPT     - Set page template to "Login"
PROMPT     - Add region: Login Form (type: Login)
PROMPT     - Items: P9999_USERNAME, P9999_PASSWORD
PROMPT     - Process: Login (type: Login, auth scheme: DCT Custom Auth)
PROMPT
PROMPT  2. Page 1 (Home)
PROMPT     - Set Authorization Scheme: "Is Platform User"
PROMPT     - Add App Launcher cards region (one card per module)
PROMPT
PROMPT  3. Shared Components > Navigation Menu
PROMPT     - Create "Main Navigation" list
PROMPT     - Top-level: Dashboard, Tasks, Admin (conditional on Is SYS_ADMIN)
PROMPT
PROMPT  4. Global Page (page 0 in Builder)
PROMPT     - Add notification bell item referencing &UNREAD_NOTIFICATIONS.
PROMPT     - Add user avatar using &USER_DISPLAY_NAME. / &USER_PHOTO_URL.
PROMPT     - Add delegation banner (conditional on ACTIVE_DELEGATION_FOR not null)
PROMPT ============================================================
