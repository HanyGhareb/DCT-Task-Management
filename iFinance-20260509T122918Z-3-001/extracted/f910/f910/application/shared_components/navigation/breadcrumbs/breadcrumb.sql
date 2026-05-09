prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
--   Manifest
--     MENU: Breadcrumb
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>100
,p_default_id_offset=>40620729557075005
,p_default_owner=>'PROD'
);
wwv_flow_api.create_menu(
 p_id=>wwv_flow_api.id(1547752126302241)
,p_name=>'Breadcrumb'
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'Home'
,p_link=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.'
,p_page_id=>1
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(1737201160438067)
,p_short_name=>'Administration'
,p_link=>'f?p=&APP_ID.:10000:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>10000
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(2432386537556883)
,p_parent_id=>wwv_flow_api.id(1737201160438067)
,p_short_name=>'User Organizations Access'
,p_link=>'f?p=&APP_ID.:3:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>3
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(2439198763630628)
,p_parent_id=>wwv_flow_api.id(2432386537556883)
,p_short_name=>'User Organizations Access Details for: <b> &P4_USER_NAME. </b>'
,p_link=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:::'
,p_page_id=>4
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(4364494600947974)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'Instance Settings'
,p_link=>'f?p=&APP_ID.:8:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>8
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(4431048671094053)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'Lookup Management'
,p_link=>'f?p=&APP_ID.:9:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>9
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(4480985911439801)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'Manage Roles'
,p_link=>'f?p=&APP_ID.:12:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>12
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(4732766897491722)
,p_short_name=>'Tree Page'
,p_link=>'f?p=&APP_ID.:13:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>13
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(4845721298243449)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'Role Users Management'
,p_link=>'f?p=&APP_ID.:14:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>14
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(4992717523341336)
,p_parent_id=>wwv_flow_api.id(1737201160438067)
,p_short_name=>'Menus'
,p_link=>'f?p=&APP_ID.:5:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>5
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(5002971672358196)
,p_parent_id=>wwv_flow_api.id(4992717523341336)
,p_short_name=>'Menu Details'
,p_link=>'f?p=&APP_ID.:6:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>6
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(5643279377220365)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'My Roles & Groups'
,p_link=>'f?p=&APP_ID.:7:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>7
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(5653080356265348)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'Users Roles &amp; Groups'
,p_link=>'f?p=&APP_ID.:15:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>15
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(5803605921484588)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'My Delegations'
,p_link=>'f?p=&APP_ID.:16:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>16
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(5804869524484590)
,p_parent_id=>wwv_flow_api.id(5803605921484588)
,p_short_name=>'Delegation Details'
,p_link=>'f?p=&APP_ID.:17:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>17
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(5832366259771136)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'Delegation Management'
,p_link=>'f?p=&APP_ID.:18:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>18
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(5833508265771137)
,p_parent_id=>wwv_flow_api.id(5832366259771136)
,p_short_name=>'Delegation Management Details'
,p_link=>'f?p=&APP_ID.:19:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>19
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(9665975717184199)
,p_short_name=>'Reset Users Password'
,p_link=>'f?p=&APP_ID.:20:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>20
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(20232472152007741)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'Employees Business Partners Roles By Cost Center'
,p_link=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.:::'
,p_page_id=>21
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(38864840187600574)
,p_parent_id=>wwv_flow_api.id(1737201160438067)
,p_short_name=>'Emails Control '
,p_link=>'f?p=&APP_ID.:22:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>22
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(38866024087600572)
,p_parent_id=>wwv_flow_api.id(38864840187600574)
,p_short_name=>'Emails Control - Details'
,p_link=>'f?p=&APP_ID.:23:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>23
);
wwv_flow_api.component_end;
end;
/
