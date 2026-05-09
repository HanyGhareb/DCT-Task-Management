prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
--   Manifest
--     MENU: Breadcrumb
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>219773596381898043
,p_default_owner=>'PROD'
);
wwv_flow_api.create_menu(
 p_id=>wwv_flow_api.id(23782494216372596)
,p_name=>'Breadcrumb'
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(116736406581270515)
,p_parent_id=>wwv_flow_api.id(21046882507637658)
,p_short_name=>'Gift Card Request Lines'
,p_link=>'f?p=&APP_ID.:28:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>28
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(116714411919255001)
,p_parent_id=>wwv_flow_api.id(21048095913637658)
,p_short_name=>'Gift Cards Settings'
,p_link=>'f?p=&APP_ID.:29:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>29
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(116713295103255001)
,p_parent_id=>wwv_flow_api.id(116714411919255001)
,p_short_name=>'Gift Cards Setting Details'
,p_link=>'f?p=&APP_ID.:30:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>30
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(116699744166993086)
,p_parent_id=>wwv_flow_api.id(21048095913637658)
,p_short_name=>'Gift Cards Categories'
,p_link=>'f?p=&APP_ID.:31:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>31
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(115505434731974048)
,p_parent_id=>wwv_flow_api.id(21046882507637658)
,p_short_name=>'Gift Card request Line Details'
,p_link=>'f?p=&APP_ID.:33:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>33
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(114908163841406703)
,p_parent_id=>wwv_flow_api.id(23782693341372596)
,p_short_name=>'Gift Cards request Approve &#x2F; Reject'
,p_link=>'f?p=&APP_ID.:36:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>36
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(97270263665989462)
,p_short_name=>'Gift Card Dcouments'
,p_link=>'f?p=&APP_ID.:37:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>37
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(76138327242832654)
,p_short_name=>'Delegation'
,p_link=>'f?p=&APP_ID.:17:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>17
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(24713436112849191)
,p_parent_id=>wwv_flow_api.id(23782693341372596)
,p_short_name=>'View Credit Card'
,p_link=>'f?p=&APP_ID.:21:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>21
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(21106724055630743)
,p_short_name=>'Gift Cards Home'
,p_link=>'f?p=&APP_ID.:24:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>24
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(21048095913637658)
,p_parent_id=>wwv_flow_api.id(23782693341372596)
,p_short_name=>'Gift Cards Home'
,p_link=>'f?p=&APP_ID.:25:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>25
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(21046882507637658)
,p_parent_id=>wwv_flow_api.id(21048095913637658)
,p_short_name=>'Gift Card details'
,p_link=>'f?p=&APP_ID.:26:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>26
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(55336838289038)
,p_short_name=>'Administration'
,p_link=>'f?p=&APP_ID.:10000:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>10000
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(23782693341372596)
,p_parent_id=>0
,p_short_name=>'Home'
,p_link=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:11::'
,p_page_id=>1
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(24098808685338825)
,p_parent_id=>wwv_flow_api.id(23782693341372596)
,p_short_name=>'Credit Card Details'
,p_link=>'f?p=&APP_ID.:2:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>2
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(24307889775501071)
,p_parent_id=>wwv_flow_api.id(23782693341372596)
,p_short_name=>'Manage Documents Required'
,p_link=>'f?p=&APP_ID.:3:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>3
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(24375542707741137)
,p_parent_id=>wwv_flow_api.id(24098808685338825)
,p_short_name=>'Document'
,p_link=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:::'
,p_page_id=>4
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(33631440490218473)
,p_parent_id=>wwv_flow_api.id(23782693341372596)
,p_short_name=>'Credit Card Approve | Reject'
,p_link=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:::'
,p_page_id=>6
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(33821311978383168)
,p_parent_id=>wwv_flow_api.id(23782693341372596)
,p_short_name=>'Credit Cards Management Invitation'
,p_link=>'f?p=&APP_ID.:9:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>9
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(34743250136783155)
,p_parent_id=>wwv_flow_api.id(23782693341372596)
,p_short_name=>'Credit Cards Requests - Drilldown'
,p_link=>'f?p=&APP_ID.:11:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>11
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(34939590358716786)
,p_parent_id=>wwv_flow_api.id(23782693341372596)
,p_short_name=>'Credit Card Notification'
,p_link=>'f?p=&APP_ID.:12:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>12
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(34962216409234948)
,p_parent_id=>wwv_flow_api.id(23782693341372596)
,p_short_name=>'My Notification History'
,p_link=>'f?p=&APP_ID.:13:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>13
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(38632845400927612)
,p_short_name=>'Credit Cards Dashboard'
,p_link=>'f?p=&APP_ID.:15:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>15
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(38656386379271547)
,p_parent_id=>wwv_flow_api.id(23782693341372596)
,p_short_name=>'Treasury Admin  \ Reports Center'
,p_link=>'f?p=&APP_ID.:16:&SESSION.::&DEBUG.:::'
,p_page_id=>16
);
wwv_flow_api.component_end;
end;
/
