prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
--   Manifest
--     MENU: Breadcrumb
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>110
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_menu(
 p_id=>wwv_flow_api.id(13188546909480758)
,p_name=>'Breadcrumb'
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(13188746768480758)
,p_short_name=>'Home'
,p_link=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.'
,p_page_id=>1
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(13379820443973169)
,p_short_name=>'Budget 1'
,p_link=>'f?p=&APP_ID.:2:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>2
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(13470429940104050)
,p_short_name=>'Budget 2'
,p_link=>'f?p=&APP_ID.:3:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>3
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(13531692165566025)
,p_short_name=>'Budget 4'
,p_link=>'f?p=&APP_ID.:4:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>4
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(13618848013425373)
,p_short_name=>'Budget IG 7'
,p_link=>'f?p=&APP_ID.:7:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>7
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(13667379365499646)
,p_short_name=>'Budget IG 8'
,p_link=>'f?p=&APP_ID.:8:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>8
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(18139075462848379)
,p_parent_id=>0
,p_short_name=>'Home'
,p_link=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.:::'
,p_page_id=>10
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(18157655874127031)
,p_parent_id=>wwv_flow_api.id(18139075462848379)
,p_short_name=>'Sector: &P11_SECTOR. - Budget By Departments'
,p_link=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.:::'
,p_page_id=>11
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(18204935859537474)
,p_parent_id=>wwv_flow_api.id(18157655874127031)
,p_short_name=>'Department: &P12_DEPARTMENT_NAME. Projects Budget'
,p_link=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:::'
,p_page_id=>12
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(18289092142607712)
,p_parent_id=>wwv_flow_api.id(18157655874127031)
,p_short_name=>'Cost Center: &P13_COST_CENTER.: Budget By  Projects'
,p_link=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.:::'
,p_page_id=>13
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(18417597125212856)
,p_short_name=>'Approved Budget'
,p_link=>'f?p=&APP_ID.:20:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>20
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(18424981955226744)
,p_parent_id=>wwv_flow_api.id(18417597125212856)
,p_short_name=>'Approved Budget Details'
,p_link=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.:::'
,p_page_id=>21
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(18454591538871324)
,p_parent_id=>wwv_flow_api.id(18417597125212856)
,p_short_name=>'&P22_BUDGET_YEAR. - Version (&P22_VERSION.) Approved Budget Details'
,p_link=>'f?p=&APP_ID.:22:&SESSION.::&DEBUG.:::'
,p_page_id=>22
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(18539995257687494)
,p_parent_id=>wwv_flow_api.id(18454591538871324)
,p_short_name=>'Sector: &P23_SECTOR. Approved Budget By  Departments'
,p_link=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.:::'
,p_page_id=>23
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(18614497249507357)
,p_parent_id=>wwv_flow_api.id(18539995257687494)
,p_short_name=>'Department: &P24_DEPARTMENT_NAME. Approved Budget By Projects'
,p_link=>'f?p=&APP_ID.:24:&SESSION.::&DEBUG.:::'
,p_page_id=>24
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(18688957034614478)
,p_parent_id=>wwv_flow_api.id(13188746768480758)
,p_short_name=>'Budget Planners'
,p_link=>'f?p=&APP_ID.:25:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>25
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(18978665511545797)
,p_parent_id=>wwv_flow_api.id(13188746768480758)
,p_short_name=>'Notification - Approved Budget Publish Request'
,p_link=>'f?p=&APP_ID.:5:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>5
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(134414718742545827)
,p_parent_id=>wwv_flow_api.id(18417597125212856)
,p_short_name=>'Approved Budget Allocation Scenarios'
,p_link=>'f?p=&APP_ID.:9:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>9
);
wwv_flow_api.component_end;
end;
/
