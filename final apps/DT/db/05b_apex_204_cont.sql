-- =============================================================================
-- Duty Travel Module (App 204) — Setup Continuation
-- File    : 05b_apex_204_cont.sql
-- Run     : After 05_apex_204_setup.sql (which stopped at computations)
-- Creates : Computations, Auth Schemes, LOVs, Page Shells, Global Processes
-- =============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- 0.  WORKSPACE CONTEXT  (required before every wwv_flow_imp call)
-- =============================================================================
BEGIN
    wwv_flow_imp.import_begin(
        p_version_yyyy_mm_dd     => '2024.05.31',
        p_release                => '24.2.15',
        p_default_workspace_id   => 9249752073687531,
        p_default_application_id => 204,
        p_default_id_offset      => 0,
        p_default_owner          => 'PROD'
    );
    DBMS_OUTPUT.PUT_LINE('import_begin OK — App 204 continuation');
END;
/

-- =============================================================================
-- 1.  APPLICATION COMPUTATIONS — On New Session
--     Corrected param: p_computation_item (not p_flow_item_name)
-- =============================================================================
PROMPT Creating Application Computations...
BEGIN
    wwv_flow_imp_shared.create_flow_computation(
        p_id                   => 20431,
        p_flow_id              => 204,
        p_computation_sequence => 10,
        p_computation_item     => 'APP_IS_DT_ADMIN',
        p_computation_point    => 'ON_NEW_INSTANCE',
        p_computation_type     => 'FUNCTION_BODY',
        p_computation          =>
            'IF prod.dct_auth.has_role(:APP_USER, ''DT_ADMIN'') THEN' || CHR(10) ||
            '    RETURN ''Y'';'                                         || CHR(10) ||
            'ELSE'                                                       || CHR(10) ||
            '    RETURN ''N'';'                                         || CHR(10) ||
            'END IF;'
    );

    wwv_flow_imp_shared.create_flow_computation(
        p_id                   => 20432,
        p_flow_id              => 204,
        p_computation_sequence => 20,
        p_computation_item     => 'APP_IS_DT_FINANCE',
        p_computation_point    => 'ON_NEW_INSTANCE',
        p_computation_type     => 'FUNCTION_BODY',
        p_computation          =>
            'IF prod.dct_auth.has_role(:APP_USER, ''DT_FINANCE'') THEN' || CHR(10) ||
            '    RETURN ''Y'';'                                           || CHR(10) ||
            'ELSE'                                                         || CHR(10) ||
            '    RETURN ''N'';'                                           || CHR(10) ||
            'END IF;'
    );

    wwv_flow_imp_shared.create_flow_computation(
        p_id                   => 20433,
        p_flow_id              => 204,
        p_computation_sequence => 30,
        p_computation_item     => 'APP_IS_DT_MANAGER',
        p_computation_point    => 'ON_NEW_INSTANCE',
        p_computation_type     => 'FUNCTION_BODY',
        p_computation          =>
            'IF prod.dct_auth.has_role(:APP_USER, ''DT_MANAGER'') THEN' || CHR(10) ||
            '    RETURN ''Y'';'                                           || CHR(10) ||
            'ELSE'                                                         || CHR(10) ||
            '    RETURN ''N'';'                                           || CHR(10) ||
            'END IF;'
    );
    DBMS_OUTPUT.PUT_LINE('3 App Computations created.');
END;
/

-- =============================================================================
-- 2.  AUTHORIZATION SCHEMES  (5 DT-specific)
-- =============================================================================
PROMPT Creating Authorization Schemes...
BEGIN
    wwv_flow_imp_shared.create_security_scheme(
        p_id            => 20441,
        p_flow_id       => 204,
        p_name          => 'IS_DT_ADMIN',
        p_scheme_type   => 'NATIVE_FUNCTION_BODY',
        p_attribute_01  => 'RETURN :APP_IS_DT_ADMIN = ''Y'';',
        p_error_message => 'Duty Travel Admin access required.',
        p_caching       => 'BY_USER_BY_SESSION'
    );

    wwv_flow_imp_shared.create_security_scheme(
        p_id            => 20442,
        p_flow_id       => 204,
        p_name          => 'IS_DT_FINANCE',
        p_scheme_type   => 'NATIVE_FUNCTION_BODY',
        p_attribute_01  => 'RETURN :APP_IS_DT_FINANCE = ''Y'';',
        p_error_message => 'Duty Travel Finance access required.',
        p_caching       => 'BY_USER_BY_SESSION'
    );

    wwv_flow_imp_shared.create_security_scheme(
        p_id            => 20443,
        p_flow_id       => 204,
        p_name          => 'IS_DT_MANAGER',
        p_scheme_type   => 'NATIVE_FUNCTION_BODY',
        p_attribute_01  => 'RETURN :APP_IS_DT_MANAGER = ''Y'';',
        p_error_message => 'Duty Travel Manager access required.',
        p_caching       => 'BY_USER_BY_SESSION'
    );

    wwv_flow_imp_shared.create_security_scheme(
        p_id            => 20444,
        p_flow_id       => 204,
        p_name          => 'IS_DT_ADMIN_OR_FINANCE',
        p_scheme_type   => 'NATIVE_FUNCTION_BODY',
        p_attribute_01  => 'RETURN :APP_IS_DT_ADMIN = ''Y'' OR :APP_IS_DT_FINANCE = ''Y'';',
        p_error_message => 'Duty Travel Admin or Finance access required.',
        p_caching       => 'BY_USER_BY_SESSION'
    );

    wwv_flow_imp_shared.create_security_scheme(
        p_id            => 20445,
        p_flow_id       => 204,
        p_name          => 'IS_DT_ADMIN_OR_MANAGER',
        p_scheme_type   => 'NATIVE_FUNCTION_BODY',
        p_attribute_01  => 'RETURN :APP_IS_DT_ADMIN = ''Y'' OR :APP_IS_DT_MANAGER = ''Y'';',
        p_error_message => 'Duty Travel Admin or Manager access required.',
        p_caching       => 'BY_USER_BY_SESSION'
    );

    DBMS_OUTPUT.PUT_LINE('5 Authorization Schemes created.');
END;
/

-- =============================================================================
-- 3.  SHARED LOVs  (10 LOVs)
--     Corrected params: p_lov_name / p_lov_query (not p_name / p_query)
-- =============================================================================
PROMPT Creating Shared LOVs...
BEGIN
    wwv_flow_imp_shared.create_list_of_values(
        p_id       => 20461,
        p_flow_id  => 204,
        p_lov_name => 'LOV_DT_MISSION_TYPE',
        p_lov_query =>
            'SELECT ''Business Mission'' d, ''BUSINESS_MISSION'' r FROM dual ' ||
            'UNION ALL SELECT ''Training'', ''TRAINING'' FROM dual'
    );

    wwv_flow_imp_shared.create_list_of_values(
        p_id       => 20462,
        p_flow_id  => 204,
        p_lov_name => 'LOV_DT_TRIP_TYPE',
        p_lov_query =>
            'SELECT ''Internal (UAE)'' d, ''INTERNAL'' r FROM dual ' ||
            'UNION ALL SELECT ''External (International)'', ''EXTERNAL'' FROM dual'
    );

    wwv_flow_imp_shared.create_list_of_values(
        p_id       => 20463,
        p_flow_id  => 204,
        p_lov_name => 'LOV_DT_STATUS',
        p_lov_query =>
            'SELECT d, r FROM (' ||
            '  SELECT ''Draft'' d, ''DRAFT'' r, 1 s FROM dual UNION ALL ' ||
            '  SELECT ''Submitted'', ''SUBMITTED'', 2 FROM dual UNION ALL ' ||
            '  SELECT ''Approved'', ''APPROVED'', 3 FROM dual UNION ALL ' ||
            '  SELECT ''Advance Paid'', ''ADVANCE_PAID'', 4 FROM dual UNION ALL ' ||
            '  SELECT ''Travelled'', ''TRAVELLED'', 5 FROM dual UNION ALL ' ||
            '  SELECT ''Closed'', ''CLOSED'', 6 FROM dual UNION ALL ' ||
            '  SELECT ''Rejected'', ''REJECTED'', 7 FROM dual UNION ALL ' ||
            '  SELECT ''Returned'', ''RETURNED'', 8 FROM dual UNION ALL ' ||
            '  SELECT ''Cancelled'', ''CANCELLED'', 9 FROM dual' ||
            ') ORDER BY s'
    );

    wwv_flow_imp_shared.create_list_of_values(
        p_id       => 20464,
        p_flow_id  => 204,
        p_lov_name => 'LOV_DT_EMPLOYEE_GRADE',
        p_lov_query =>
            'SELECT lv.value_name_en d, lv.value_code r ' ||
            'FROM prod.dct_lookup_values lv ' ||
            'JOIN prod.dct_lookup_categories lc ON lc.category_id = lv.category_id ' ||
            'WHERE lc.category_code = ''DT_EMPLOYEE_GRADE'' ' ||
            'ORDER BY lv.display_order'
    );

    wwv_flow_imp_shared.create_list_of_values(
        p_id       => 20465,
        p_flow_id  => 204,
        p_lov_name => 'LOV_DT_DOCUMENT_TYPE',
        p_lov_query =>
            'SELECT lv.value_name_en d, lv.value_code r ' ||
            'FROM prod.dct_lookup_values lv ' ||
            'JOIN prod.dct_lookup_categories lc ON lc.category_id = lv.category_id ' ||
            'WHERE lc.category_code = ''DT_DOCUMENT_TYPE'' ' ||
            'ORDER BY lv.display_order'
    );

    wwv_flow_imp_shared.create_list_of_values(
        p_id       => 20466,
        p_flow_id  => 204,
        p_lov_name => 'LOV_DT_EXPENSE_CATEGORY',
        p_lov_query =>
            'SELECT d, r FROM (' ||
            '  SELECT ''Per Diem'' d, ''PER_DIEM'' r, 1 s FROM dual UNION ALL ' ||
            '  SELECT ''Accommodation'', ''ACCOMMODATION'', 2 FROM dual UNION ALL ' ||
            '  SELECT ''Ticket'', ''TICKET'', 3 FROM dual UNION ALL ' ||
            '  SELECT ''Visa'', ''VISA'', 4 FROM dual UNION ALL ' ||
            '  SELECT ''Local Transport'', ''LOCAL_TRANSPORT'', 5 FROM dual UNION ALL ' ||
            '  SELECT ''Other'', ''OTHER'', 6 FROM dual' ||
            ') ORDER BY s'
    );

    wwv_flow_imp_shared.create_list_of_values(
        p_id       => 20467,
        p_flow_id  => 204,
        p_lov_name => 'LOV_DT_BUDGET_TYPE',
        p_lov_query =>
            'SELECT ''GL / Cost Centre'' d, ''GL'' r FROM dual ' ||
            'UNION ALL SELECT ''Project'', ''PROJECT'' FROM dual'
    );

    wwv_flow_imp_shared.create_list_of_values(
        p_id       => 20468,
        p_flow_id  => 204,
        p_lov_name => 'LOV_DT_RATE_STRUCTURE',
        p_lov_query =>
            'SELECT ''Per Country'' d, ''PER_COUNTRY'' r FROM dual ' ||
            'UNION ALL SELECT ''Tier-Based'', ''TIER_BASED'' FROM dual ' ||
            'UNION ALL SELECT ''Region-Based'', ''REGION_BASED'' FROM dual'
    );

    wwv_flow_imp_shared.create_list_of_values(
        p_id       => 20469,
        p_flow_id  => 204,
        p_lov_name => 'LOV_DT_HALF_DAY_POLICY',
        p_lov_query =>
            'SELECT ''None (full rate every day)'' d, ''NONE'' r FROM dual ' ||
            'UNION ALL SELECT ''First & Last day half'', ''FIRST_LAST'' FROM dual ' ||
            'UNION ALL SELECT ''First day only half'', ''FIRST_ONLY'' FROM dual'
    );

    wwv_flow_imp_shared.create_list_of_values(
        p_id       => 20470,
        p_flow_id  => 204,
        p_lov_name => 'LOV_DT_COUNTRIES',
        p_lov_query =>
            'SELECT country_name_en d, country_code r ' ||
            'FROM prod.dt_country_groups ' ||
            'WHERE is_active = ''Y'' ' ||
            'ORDER BY country_name_en'
    );

    DBMS_OUTPUT.PUT_LINE('10 Shared LOVs created.');
END;
/

-- =============================================================================
-- 4.  PAGE SHELLS  (18 pages)
-- =============================================================================
PROMPT Creating page shells...
BEGIN
    wwv_flow_imp_page.create_page(p_id=>9999, p_flow_id=>204,
        p_name=>'Login',            p_alias=>'LOGIN',             p_step_title=>'Duty Travel — Login');
    wwv_flow_imp_page.create_page(p_id=>1,    p_flow_id=>204,
        p_name=>'Dashboard',        p_alias=>'DASHBOARD',         p_step_title=>'Duty Travel Dashboard');
    wwv_flow_imp_page.create_page(p_id=>10,   p_flow_id=>204,
        p_name=>'My Requests',      p_alias=>'MY-REQUESTS',       p_step_title=>'My Travel Requests');
    wwv_flow_imp_page.create_page(p_id=>11,   p_flow_id=>204,
        p_name=>'New/Edit Request', p_alias=>'NEW-REQUEST',       p_step_title=>'Travel Request');
    wwv_flow_imp_page.create_page(p_id=>12,   p_flow_id=>204,
        p_name=>'View Request',     p_alias=>'VIEW-REQUEST',      p_step_title=>'Request Detail');
    wwv_flow_imp_page.create_page(p_id=>13,   p_flow_id=>204,
        p_name=>'Edit Request',     p_alias=>'EDIT-REQUEST',      p_step_title=>'Edit Travel Request');
    wwv_flow_imp_page.create_page(p_id=>14,   p_flow_id=>204,
        p_name=>'Destinations',     p_alias=>'DESTINATIONS',      p_step_title=>'Destination Legs');
    wwv_flow_imp_page.create_page(p_id=>20,   p_flow_id=>204,
        p_name=>'Pending Approvals',p_alias=>'PENDING-APPROVALS', p_step_title=>'Pending Approvals');
    wwv_flow_imp_page.create_page(p_id=>21,   p_flow_id=>204,
        p_name=>'Review & Approve', p_alias=>'REVIEW-APPROVE',    p_step_title=>'Review & Approve Request');
    wwv_flow_imp_page.create_page(p_id=>30,   p_flow_id=>204,
        p_name=>'Settlement',       p_alias=>'SETTLEMENT',        p_step_title=>'Travel Settlement');
    wwv_flow_imp_page.create_page(p_id=>40,   p_flow_id=>204,
        p_name=>'Rate Master',      p_alias=>'RATE-MASTER',       p_step_title=>'Per Diem Rate Master');
    wwv_flow_imp_page.create_page(p_id=>41,   p_flow_id=>204,
        p_name=>'Rate Edit',        p_alias=>'RATE-EDIT',         p_step_title=>'Edit Per Diem Rate');
    wwv_flow_imp_page.create_page(p_id=>42,   p_flow_id=>204,
        p_name=>'Country Groups',   p_alias=>'COUNTRY-GROUPS',    p_step_title=>'Country & Region Groups');
    wwv_flow_imp_page.create_page(p_id=>50,   p_flow_id=>204,
        p_name=>'Advance Payment',  p_alias=>'ADVANCE-PAYMENT',   p_step_title=>'Advance Payment Queue');
    wwv_flow_imp_page.create_page(p_id=>60,   p_flow_id=>204,
        p_name=>'Closure Queue',    p_alias=>'CLOSURE-QUEUE',     p_step_title=>'Request Closure Queue');
    wwv_flow_imp_page.create_page(p_id=>70,   p_flow_id=>204,
        p_name=>'Module Config',    p_alias=>'CONFIG',            p_step_title=>'Duty Travel Configuration');
    wwv_flow_imp_page.create_page(p_id=>71,   p_flow_id=>204,
        p_name=>'Doc Requirements', p_alias=>'DOC-REQUIREMENTS',  p_step_title=>'Document Requirements');
    wwv_flow_imp_page.create_page(p_id=>80,   p_flow_id=>204,
        p_name=>'Audit Log',        p_alias=>'AUDIT-LOG',         p_step_title=>'Audit Log');
    DBMS_OUTPUT.PUT_LINE('18 page shells created.');
END;
/

-- =============================================================================
-- 5.  GLOBAL APPLICATION PROCESSES
-- =============================================================================
PROMPT Creating Global Application Processes...
BEGIN
    wwv_flow_imp_shared.create_flow_process(
        p_id                    => 20451,
        p_flow_id               => 204,
        p_process_sequence      => 10,
        p_process_point         => 'BEFORE_HEADER',
        p_process_type          => 'NATIVE_PLSQL',
        p_process_name          => 'Touch Session',
        p_process_sql_clob      => 'dct_auth.touch_session(V(''APP_SESSION''));',
        p_process_clob_language => 'PLSQL',
        p_process_error_message => '#SQLERRM#'
    );

    wwv_flow_imp_shared.create_flow_process(
        p_id                    => 20452,
        p_flow_id               => 204,
        p_process_sequence      => 20,
        p_process_point         => 'BEFORE_HEADER',
        p_process_type          => 'NATIVE_PLSQL',
        p_process_name          => 'Refresh Notification Count',
        p_process_sql_clob      => 'APEX_UTIL.SET_SESSION_STATE(''UNREAD_NOTIFICATIONS'', dct_notify.get_unread_count(TO_NUMBER(NVL(:USER_ID,0))));',
        p_process_clob_language => 'PLSQL',
        p_process_error_message => '#SQLERRM#'
    );

    DBMS_OUTPUT.PUT_LINE('2 Global Application Processes created.');
END;
/

-- =============================================================================
-- 6.  LOGOUT PROCESS ON PAGE 9999
-- =============================================================================
PROMPT Creating Logout process on page 9999...
BEGIN
    wwv_flow_imp_page.create_page_process(
        p_id                    => 20453,
        p_flow_id               => 204,
        p_flow_step_id          => 9999,
        p_process_sequence      => 999,
        p_process_point         => 'BEFORE_HEADER',
        p_process_type          => 'NATIVE_PLSQL',
        p_process_name          => 'Close Session on Logout',
        p_process_sql_clob      =>
            'BEGIN' || CHR(10) ||
            '    IF :REQUEST = ''LOGOUT'' THEN' || CHR(10) ||
            '        dct_auth.close_session(:APP_SESSION);' || CHR(10) ||
            '        APEX_AUTHENTICATION.LOGOUT(' || CHR(10) ||
            '            p_next_app_id  => 204,' || CHR(10) ||
            '            p_next_page_id => 9999' || CHR(10) ||
            '        );' || CHR(10) ||
            '    END IF;' || CHR(10) ||
            'END;',
        p_process_clob_language => 'PLSQL',
        p_process_error_message => '#SQLERRM#'
    );
    DBMS_OUTPUT.PUT_LINE('Logout process created.');
END;
/

-- =============================================================================
-- VERIFY
-- =============================================================================
PROMPT
PROMPT Verifying App 204 components...

SELECT application_id, application_name, alias
FROM   apex_applications WHERE application_id = 204;

SELECT item_name FROM apex_application_items
WHERE  application_id = 204 ORDER BY item_name;

SELECT computation_item, computation_point
FROM   apex_application_computations
WHERE  application_id = 204 ORDER BY computation_sequence;

SELECT authorization_scheme_name
FROM   apex_application_authorization
WHERE  application_id = 204 ORDER BY authorization_scheme_name;

SELECT lov_name FROM apex_application_lovs
WHERE  application_id = 204 ORDER BY lov_name;

SELECT page_id, page_name FROM apex_application_pages
WHERE  application_id = 204 ORDER BY page_id;

SELECT process_name, process_point
FROM   apex_application_processes
WHERE  application_id = 204 ORDER BY process_sequence;

PROMPT
PROMPT ============================================================
PROMPT  App 204 setup complete.
PROMPT  Next: open APEX Builder, navigate to App 204, then:
PROMPT    1. Shared Components > Auth Schemes > set DCT Custom Auth as Current
PROMPT    2. Build pages per final apps/DT/docs/APEX_PAGE_PLAN.md
PROMPT ============================================================
