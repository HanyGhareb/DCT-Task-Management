-- =============================================================================
-- i-Finance V2 — APEX App 200 Navigation
-- File    : 10_apex_navigation.sql
-- Creates : Breadcrumb menu (ID 9281295074536978 — referenced by pages 10 & 20)
--           Desktop Navigation Menu (left sidebar, full hierarchy)
-- Run as  : ADMIN via SQLcl — after 05_apex_200_setup.sql and all page files
-- =============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF

-- =============================================================================
-- 0. WORKSPACE CONTEXT
-- =============================================================================
BEGIN
    wwv_flow_imp.import_begin(
        p_version_yyyy_mm_dd     => '2024.11.30',
        p_release                => '24.2.15',
        p_default_workspace_id   => 9249752073687531,
        p_default_application_id => 200,
        p_default_id_offset      => 0,
        p_default_owner          => 'PROD'
    );
END;
/

BEGIN
    wwv_flow_imp.g_mode := 'REPLACE';
END;
/

-- =============================================================================
-- SECTION A: BREADCRUMB MENU
-- ID 9281295074536978 — matches p_menu_id referenced in pages 10 and 20
-- Note: create_menu_option has no p_flow_id parameter
-- =============================================================================
PROMPT Creating Breadcrumb menu...
BEGIN
    wwv_flow_imp_shared.create_menu(
        p_id      => wwv_flow_imp.id(9281295074536978),
        p_flow_id => 200,
        p_name    => 'Breadcrumb'
    );
    DBMS_OUTPUT.PUT_LINE('Breadcrumb menu created.');
END;
/

BEGIN
    -- Root entry: Home
    wwv_flow_imp_shared.create_menu_option(
        p_id              => wwv_flow_imp.id(9461000002432070),
        p_menu_id         => wwv_flow_imp.id(9281295074536978),
        p_parent_id       => null,
        p_option_sequence => 10,
        p_short_name      => 'Home',
        p_link            => 'f?p=&APP_ID.:1:&APP_SESSION.',
        p_page_id         => 1
    );
    -- Users (Page 10)
    wwv_flow_imp_shared.create_menu_option(
        p_id              => wwv_flow_imp.id(9461000003432070),
        p_menu_id         => wwv_flow_imp.id(9281295074536978),
        p_parent_id       => wwv_flow_imp.id(9461000002432070),
        p_option_sequence => 20,
        p_short_name      => 'Users',
        p_link            => 'f?p=&APP_ID.:10:&APP_SESSION.',
        p_page_id         => 10
    );
    -- Roles (Page 20)
    wwv_flow_imp_shared.create_menu_option(
        p_id              => wwv_flow_imp.id(9461000004432070),
        p_menu_id         => wwv_flow_imp.id(9281295074536978),
        p_parent_id       => wwv_flow_imp.id(9461000002432070),
        p_option_sequence => 30,
        p_short_name      => 'Roles',
        p_link            => 'f?p=&APP_ID.:20:&APP_SESSION.',
        p_page_id         => 20
    );
    DBMS_OUTPUT.PUT_LINE('3 breadcrumb entries created (Home, Users, Roles).');
END;
/

-- =============================================================================
-- SECTION B: DESKTOP NAVIGATION MENU (left sidebar)
-- Correct params: p_list_item_link_text (label), p_list_item_link_target (URL),
--                 p_list_item_display_sequence (order), p_parent_list_item_id
-- =============================================================================
PROMPT Creating Desktop Navigation Menu list (REPLACE clears existing items)...
BEGIN
    wwv_flow_imp_shared.create_list(
        p_id      => wwv_flow_imp.id(9461000001432070),
        p_flow_id => 200,
        p_name    => 'Desktop Navigation Menu'
    );
    DBMS_OUTPUT.PUT_LINE('Navigation list created.');
END;
/

PROMPT Adding navigation menu items (p_security_scheme uses numeric auth scheme IDs)...
BEGIN
    -- Auth scheme IDs: 300=Platform User  301=SYS_ADMIN  302=USER_ADMIN
    --                  303=ORG_ADMIN       304=Auditor
    -- NOTE: pass numeric ID via wwv_flow_imp.id() — NOT the scheme name string.
    --       Passing the name causes ORA-06502 in WWV_FLOW_AUTHORIZATION at runtime.

    -- 1. Home  (Page 1)
    wwv_flow_imp_shared.create_list_item(
        p_id                         => wwv_flow_imp.id(9461000010432070),
        p_list_id                    => wwv_flow_imp.id(9461000001432070),
        p_parent_list_item_id        => null,
        p_list_item_display_sequence => 10,
        p_list_item_link_text        => 'Home',
        p_list_item_link_target      => 'f?p=&APP_ID.:1:&APP_SESSION.',
        p_list_item_icon             => 'fa-home',
        p_security_scheme            => wwv_flow_imp.id(300)
    );

    -- 2. User Management  (section header)
    wwv_flow_imp_shared.create_list_item(
        p_id                         => wwv_flow_imp.id(9461000011432070),
        p_list_id                    => wwv_flow_imp.id(9461000001432070),
        p_parent_list_item_id        => null,
        p_list_item_display_sequence => 20,
        p_list_item_link_text        => 'User Management',
        p_list_item_link_target      => '#',
        p_list_item_icon             => 'fa-users-cog',
        p_security_scheme            => wwv_flow_imp.id(302)
    );
    -- 2.1 Users  (Page 10)
    wwv_flow_imp_shared.create_list_item(
        p_id                         => wwv_flow_imp.id(9461000012432070),
        p_list_id                    => wwv_flow_imp.id(9461000001432070),
        p_parent_list_item_id        => wwv_flow_imp.id(9461000011432070),
        p_list_item_display_sequence => 21,
        p_list_item_link_text        => 'Users',
        p_list_item_link_target      => 'f?p=&APP_ID.:10:&APP_SESSION.',
        p_list_item_icon             => 'fa-user',
        p_security_scheme            => wwv_flow_imp.id(302)
    );
    -- 2.2 Roles  (Page 20)
    wwv_flow_imp_shared.create_list_item(
        p_id                         => wwv_flow_imp.id(9461000013432070),
        p_list_id                    => wwv_flow_imp.id(9461000001432070),
        p_parent_list_item_id        => wwv_flow_imp.id(9461000011432070),
        p_list_item_display_sequence => 22,
        p_list_item_link_text        => 'Roles',
        p_list_item_link_target      => 'f?p=&APP_ID.:20:&APP_SESSION.',
        p_list_item_icon             => 'fa-shield-alt',
        p_security_scheme            => wwv_flow_imp.id(301)
    );
    -- 2.3 Permissions  (Page 24 — future)
    wwv_flow_imp_shared.create_list_item(
        p_id                         => wwv_flow_imp.id(9461000014432070),
        p_list_id                    => wwv_flow_imp.id(9461000001432070),
        p_parent_list_item_id        => wwv_flow_imp.id(9461000011432070),
        p_list_item_display_sequence => 23,
        p_list_item_link_text        => 'Permissions',
        p_list_item_link_target      => 'f?p=&APP_ID.:24:&APP_SESSION.',
        p_list_item_icon             => 'fa-key',
        p_security_scheme            => wwv_flow_imp.id(301)
    );

    -- 3. Organisation  (section header)
    wwv_flow_imp_shared.create_list_item(
        p_id                         => wwv_flow_imp.id(9461000015432070),
        p_list_id                    => wwv_flow_imp.id(9461000001432070),
        p_parent_list_item_id        => null,
        p_list_item_display_sequence => 30,
        p_list_item_link_text        => 'Organisation',
        p_list_item_link_target      => '#',
        p_list_item_icon             => 'fa-sitemap',
        p_security_scheme            => wwv_flow_imp.id(303)
    );
    -- 3.1 Org Hierarchy  (Page 30 — future)
    wwv_flow_imp_shared.create_list_item(
        p_id                         => wwv_flow_imp.id(9461000016432070),
        p_list_id                    => wwv_flow_imp.id(9461000001432070),
        p_parent_list_item_id        => wwv_flow_imp.id(9461000015432070),
        p_list_item_display_sequence => 31,
        p_list_item_link_text        => 'Org Hierarchy',
        p_list_item_link_target      => 'f?p=&APP_ID.:30:&APP_SESSION.',
        p_list_item_icon             => 'fa-project-diagram',
        p_security_scheme            => wwv_flow_imp.id(303)
    );

    -- 4. Modules  (section header)
    wwv_flow_imp_shared.create_list_item(
        p_id                         => wwv_flow_imp.id(9461000017432070),
        p_list_id                    => wwv_flow_imp.id(9461000001432070),
        p_parent_list_item_id        => null,
        p_list_item_display_sequence => 40,
        p_list_item_link_text        => 'Modules',
        p_list_item_link_target      => '#',
        p_list_item_icon             => 'fa-th-large',
        p_security_scheme            => wwv_flow_imp.id(301)
    );
    -- 4.1 Module Registry  (Page 40 — future)
    wwv_flow_imp_shared.create_list_item(
        p_id                         => wwv_flow_imp.id(9461000018432070),
        p_list_id                    => wwv_flow_imp.id(9461000001432070),
        p_parent_list_item_id        => wwv_flow_imp.id(9461000017432070),
        p_list_item_display_sequence => 41,
        p_list_item_link_text        => 'Module Registry',
        p_list_item_link_target      => 'f?p=&APP_ID.:40:&APP_SESSION.',
        p_list_item_icon             => 'fa-th-large',
        p_security_scheme            => wwv_flow_imp.id(301)
    );

    -- 5. Approvals  (section header)
    wwv_flow_imp_shared.create_list_item(
        p_id                         => wwv_flow_imp.id(9461000019432070),
        p_list_id                    => wwv_flow_imp.id(9461000001432070),
        p_parent_list_item_id        => null,
        p_list_item_display_sequence => 50,
        p_list_item_link_text        => 'Approvals',
        p_list_item_link_target      => '#',
        p_list_item_icon             => 'fa-check-circle',
        p_security_scheme            => wwv_flow_imp.id(301)
    );
    -- 5.1 Templates  (Page 50 — future)
    wwv_flow_imp_shared.create_list_item(
        p_id                         => wwv_flow_imp.id(9461000020432070),
        p_list_id                    => wwv_flow_imp.id(9461000001432070),
        p_parent_list_item_id        => wwv_flow_imp.id(9461000019432070),
        p_list_item_display_sequence => 51,
        p_list_item_link_text        => 'Templates',
        p_list_item_link_target      => 'f?p=&APP_ID.:50:&APP_SESSION.',
        p_list_item_icon             => 'fa-list-alt',
        p_security_scheme            => wwv_flow_imp.id(301)
    );
    -- 5.2 Monitor  (Page 55 — future)
    wwv_flow_imp_shared.create_list_item(
        p_id                         => wwv_flow_imp.id(9461000021432070),
        p_list_id                    => wwv_flow_imp.id(9461000001432070),
        p_parent_list_item_id        => wwv_flow_imp.id(9461000019432070),
        p_list_item_display_sequence => 52,
        p_list_item_link_text        => 'Monitor',
        p_list_item_link_target      => 'f?p=&APP_ID.:55:&APP_SESSION.',
        p_list_item_icon             => 'fa-eye',
        p_security_scheme            => wwv_flow_imp.id(301)
    );

    -- 6. Configuration  (section header)
    wwv_flow_imp_shared.create_list_item(
        p_id                         => wwv_flow_imp.id(9461000022432070),
        p_list_id                    => wwv_flow_imp.id(9461000001432070),
        p_parent_list_item_id        => null,
        p_list_item_display_sequence => 60,
        p_list_item_link_text        => 'Configuration',
        p_list_item_link_target      => '#',
        p_list_item_icon             => 'fa-cogs',
        p_security_scheme            => wwv_flow_imp.id(301)
    );
    -- 6.1 Lookups  (Page 60 — future)
    wwv_flow_imp_shared.create_list_item(
        p_id                         => wwv_flow_imp.id(9461000023432070),
        p_list_id                    => wwv_flow_imp.id(9461000001432070),
        p_parent_list_item_id        => wwv_flow_imp.id(9461000022432070),
        p_list_item_display_sequence => 61,
        p_list_item_link_text        => 'Lookups',
        p_list_item_link_target      => 'f?p=&APP_ID.:60:&APP_SESSION.',
        p_list_item_icon             => 'fa-list',
        p_security_scheme            => wwv_flow_imp.id(301)
    );
    -- 6.2 System Settings  (Page 70 — future)
    wwv_flow_imp_shared.create_list_item(
        p_id                         => wwv_flow_imp.id(9461000024432070),
        p_list_id                    => wwv_flow_imp.id(9461000001432070),
        p_parent_list_item_id        => wwv_flow_imp.id(9461000022432070),
        p_list_item_display_sequence => 62,
        p_list_item_link_text        => 'System Settings',
        p_list_item_link_target      => 'f?p=&APP_ID.:70:&APP_SESSION.',
        p_list_item_icon             => 'fa-sliders-h',
        p_security_scheme            => wwv_flow_imp.id(301)
    );

    -- 7. Audit  (section header)
    wwv_flow_imp_shared.create_list_item(
        p_id                         => wwv_flow_imp.id(9461000025432070),
        p_list_id                    => wwv_flow_imp.id(9461000001432070),
        p_parent_list_item_id        => null,
        p_list_item_display_sequence => 70,
        p_list_item_link_text        => 'Audit',
        p_list_item_link_target      => '#',
        p_list_item_icon             => 'fa-clipboard-list',
        p_security_scheme            => wwv_flow_imp.id(304)
    );
    -- 7.1 Audit Log  (Page 80 — future)
    wwv_flow_imp_shared.create_list_item(
        p_id                         => wwv_flow_imp.id(9461000026432070),
        p_list_id                    => wwv_flow_imp.id(9461000001432070),
        p_parent_list_item_id        => wwv_flow_imp.id(9461000025432070),
        p_list_item_display_sequence => 71,
        p_list_item_link_text        => 'Audit Log',
        p_list_item_link_target      => 'f?p=&APP_ID.:80:&APP_SESSION.',
        p_list_item_icon             => 'fa-history',
        p_security_scheme            => wwv_flow_imp.id(304)
    );
    -- 7.2 Login History  (Page 81 — future)
    wwv_flow_imp_shared.create_list_item(
        p_id                         => wwv_flow_imp.id(9461000027432070),
        p_list_id                    => wwv_flow_imp.id(9461000001432070),
        p_parent_list_item_id        => wwv_flow_imp.id(9461000025432070),
        p_list_item_display_sequence => 72,
        p_list_item_link_text        => 'Login History',
        p_list_item_link_target      => 'f?p=&APP_ID.:81:&APP_SESSION.',
        p_list_item_icon             => 'fa-sign-in-alt',
        p_security_scheme            => wwv_flow_imp.id(304)
    );
    -- 7.3 Active Sessions  (Page 83 — future)
    wwv_flow_imp_shared.create_list_item(
        p_id                         => wwv_flow_imp.id(9461000028432070),
        p_list_id                    => wwv_flow_imp.id(9461000001432070),
        p_parent_list_item_id        => wwv_flow_imp.id(9461000025432070),
        p_list_item_display_sequence => 73,
        p_list_item_link_text        => 'Active Sessions',
        p_list_item_link_target      => 'f?p=&APP_ID.:83:&APP_SESSION.',
        p_list_item_icon             => 'fa-desktop',
        p_security_scheme            => wwv_flow_imp.id(301)
    );

    DBMS_OUTPUT.PUT_LINE('19 navigation menu items created.');
END;
/

COMMIT;

-- =============================================================================
-- VERIFY
-- =============================================================================
PROMPT
PROMPT Verifying navigation objects...

SELECT list_name
FROM   apex_application_lists
WHERE  application_id = 200
ORDER  BY list_name;

SELECT display_sequence, list_item_name, entry_target
FROM   apex_application_list_entries
WHERE  application_id = 200
  AND  list_name      = 'Desktop Navigation Menu'
ORDER  BY display_sequence;

PROMPT ============================================================
PROMPT  Navigation setup complete.
PROMPT
PROMPT  NEXT STEP in APEX Builder:
PROMPT  Shared Components > User Interface Attributes > Navigation Menu
PROMPT  Set "Desktop Navigation Menu" = "Desktop Navigation Menu"
PROMPT ============================================================
