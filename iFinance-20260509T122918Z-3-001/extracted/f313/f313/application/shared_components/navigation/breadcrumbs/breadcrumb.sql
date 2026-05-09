prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
--   Manifest
--     MENU: Breadcrumb
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>120
,p_default_id_offset=>145171879539529295
,p_default_owner=>'PROD'
);
wwv_flow_api.create_menu(
 p_id=>wwv_flow_api.id(24493261337319361)
,p_name=>'Breadcrumb'
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(176360644538471)
,p_parent_id=>wwv_flow_api.id(24493428350319361)
,p_short_name=>'PC Meetings Calendar'
,p_link=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.:::'
,p_page_id=>21
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(12868236011021893)
,p_parent_id=>wwv_flow_api.id(24493428350319361)
,p_short_name=>'SMD Forms Recommendations'
,p_link=>'f?p=&APP_ID.:24:&SESSION.::&DEBUG.:::'
,p_page_id=>24
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(12897100349854335)
,p_parent_id=>wwv_flow_api.id(24493428350319361)
,p_short_name=>'SMD Form Documents Instructions Settings'
,p_link=>'f?p=&APP_ID.:25:&SESSION.::&DEBUG.:::'
,p_page_id=>25
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(23699200452401092)
,p_short_name=>'SMD Form Settings'
,p_link=>'f?p=&APP_ID.:14:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>14
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(24493428350319361)
,p_parent_id=>0
,p_short_name=>'Single Source Requests Home'
,p_link=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::'
,p_page_id=>1
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(24927852874318644)
,p_short_name=>'Administration'
,p_link=>'f?p=&APP_ID.:10000:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>10000
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(25286482785469568)
,p_parent_id=>wwv_flow_api.id(24493428350319361)
,p_short_name=>'Single Source Request Details'
,p_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:::'
,p_page_id=>2
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(25507009941790332)
,p_parent_id=>wwv_flow_api.id(24493428350319361)
,p_short_name=>'Manage Exemption Types'
,p_link=>'f?p=&APP_ID.:4:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>4
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(25555208268633294)
,p_parent_id=>wwv_flow_api.id(25286482785469568)
,p_short_name=>'Single Source Document '
,p_link=>'f?p=&APP_ID.:5:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>5
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(25721565372033399)
,p_short_name=>'Single Source Approve &#x2F; Reject'
,p_link=>'f?p=&APP_ID.:6:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>6
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(26500364972088931)
,p_parent_id=>0
,p_short_name=>'Procurement Committees'
,p_link=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:::'
,p_page_id=>8
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(26501561077088928)
,p_parent_id=>wwv_flow_api.id(26500364972088931)
,p_short_name=>'TAC Committee Details'
,p_link=>'f?p=&APP_ID.:9:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>9
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(26770424970744341)
,p_parent_id=>wwv_flow_api.id(25721565372033399)
,p_short_name=>'Delegate to '
,p_link=>'f?p=&APP_ID.:10:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>10
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(26861689213092157)
,p_parent_id=>wwv_flow_api.id(24493428350319361)
,p_short_name=>'PC Form Requests'
,p_link=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.:::'
,p_page_id=>11
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(26862851490092156)
,p_parent_id=>wwv_flow_api.id(26861689213092157)
,p_short_name=>'PC Form Details: &P12_FORM_NUMBER_H. &P13_FORM_NUMBER.'
,p_link=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:::'
,p_page_id=>12
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(27053893601914493)
,p_parent_id=>wwv_flow_api.id(26862851490092156)
,p_short_name=>'TAC Form Document '
,p_link=>'f?p=&APP_ID.:16:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>16
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(28434425639219766)
,p_parent_id=>wwv_flow_api.id(24493428350319361)
,p_short_name=>'TAC Form Approve &#x2F; Reject'
,p_link=>'f?p=&APP_ID.:15:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>15
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(28561715846639737)
,p_parent_id=>wwv_flow_api.id(26862851490092156)
,p_short_name=>'Select Committee Members for &P13_FORM_NUMBER.'
,p_link=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.:::'
,p_page_id=>13
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(28824857857827696)
,p_parent_id=>0
,p_short_name=>'Single Source Requests: &P20_STATUS.'
,p_link=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.:::'
,p_page_id=>20
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(85690736889892534)
,p_parent_id=>wwv_flow_api.id(26861689213092157)
,p_short_name=>'User Management'
,p_link=>'f?p=&APP_ID.:28:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>28
);
wwv_flow_api.component_end;
end;
/
