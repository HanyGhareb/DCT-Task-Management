-- =============================================================================
-- i-Finance V2 — App 200 Shared Components (run AFTER wizard creates the app)
-- File    : 05b_apex_200_shared_components.sql
-- Adds    : Auth Scheme, 14 App Items, 7 Authorization Schemes, 2 Global Processes
-- Skips   : create_flow, create_page (wizard already created these)
-- Run as  : ADMIN via SQLcl
-- =============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF

-- =============================================================================
-- 0. WORKSPACE CONTEXT
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
    DBMS_OUTPUT.PUT_LINE('import_begin OK');
END;
/

-- =============================================================================
-- 1. AUTHENTICATION SCHEME — DCT Custom Auth
--    Run this, then go to Shared Components > Authentication Schemes
--    and set "DCT Custom Auth" as the current (active) scheme.
-- =============================================================================
PROMPT Creating DCT Custom Auth scheme...
BEGIN
    wwv_flow_imp_shared.create_authentication(
        p_id                   => 100,
        p_flow_id              => 200,
        p_name                 => 'DCT Custom Auth',
        p_scheme_type          => 'NATIVE_CUSTOM',
        p_attribute_01         => 'dct_auth.authenticate',
        p_post_auth_process    => 'dct_auth.post_login',
        p_invalid_session_type => 'LOGIN',
        p_invalid_session_url  => 'f?p=200:LOGIN',
        p_logout_url           => 'f?p=200:LOGOUT:&APP_SESSION.',
        p_use_secure_cookie_yn => 'N',
        p_ras_mode             => 0
    );
    DBMS_OUTPUT.PUT_LINE('DCT Custom Auth created.');
END;
/

-- =============================================================================
-- 2. APPLICATION ITEMS  (14 session-state variables)
--    'S' = Checksum Required  |  'N' = Unrestricted
-- =============================================================================
PROMPT Creating 14 Application Items...
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
-- 3. AUTHORIZATION SCHEMES  (7 schemes)
-- =============================================================================
PROMPT Creating 7 Authorization Schemes...
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
-- 4. GLOBAL APPLICATION PROCESSES (run on every page)
--    Uses wwv_flow_imp_shared — NOT wwv_flow_imp_page
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

    DBMS_OUTPUT.PUT_LINE('2 Global Application Processes created.');
END;
/

-- =============================================================================
-- VERIFY
-- =============================================================================
PROMPT
PROMPT Verifying shared components...

SELECT item_name, session_state_protection
FROM   apex_application_items
WHERE  application_id = 200
ORDER  BY item_name;

SELECT authorization_scheme_name
FROM   apex_application_authorization
WHERE  application_id = 200
ORDER  BY authorization_scheme_name;

SELECT process_name, process_point
FROM   apex_application_processes
WHERE  application_id = 200
ORDER  BY process_sequence;

PROMPT ============================================================
PROMPT  Done. Manual steps in APEX Builder:
PROMPT
PROMPT  1. Shared Components > Authentication Schemes
PROMPT     Set "DCT Custom Auth" as Current Scheme
PROMPT
PROMPT  2. Logout page: add a process (Before Header, PL/SQL):
PROMPT       dct_auth.close_session(:APP_SESSION);
PROMPT       APEX_AUTHENTICATION.LOGOUT(p_next_app_id=>200,p_next_page_id=>LOGIN);
PROMPT
PROMPT  3. Home page (1): set Authorization Scheme to "Is Platform User"
PROMPT ============================================================
