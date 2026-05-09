prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
--   Manifest
--     MENU: Breadcrumb
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>114
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_menu(
 p_id=>wwv_flow_api.id(52819862093734839)
,p_name=>'Breadcrumb'
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(52820017569734839)
,p_short_name=>'Home'
,p_link=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.'
,p_page_id=>1
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(52988867779862557)
,p_parent_id=>wwv_flow_api.id(52820017569734839)
,p_short_name=>'Check Details'
,p_link=>'f?p=&APP_ID.:2:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>2
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(53070463944393703)
,p_parent_id=>wwv_flow_api.id(52988867779862557)
,p_short_name=>'Check documents'
,p_link=>'f?p=&APP_ID.:3:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>3
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(53270654622191712)
,p_parent_id=>wwv_flow_api.id(52820017569734839)
,p_short_name=>'Manager Cheque Approve &#x2F; Reject'
,p_link=>'f?p=&APP_ID.:6:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>6
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(53830596071675879)
,p_parent_id=>wwv_flow_api.id(52820017569734839)
,p_short_name=>'Managers Cheque List - Drilldown'
,p_link=>'f?p=&APP_ID.:9:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>9
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(53907198785354343)
,p_parent_id=>wwv_flow_api.id(52820017569734839)
,p_short_name=>'Managers Cheque Data Loading'
,p_link=>'f?p=&APP_ID.:10:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>10
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(53940712123354380)
,p_parent_id=>wwv_flow_api.id(52820017569734839)
,p_short_name=>'Managers Cheque Data Loading'
,p_link=>'f?p=&APP_ID.:11:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>11
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(53944981485354382)
,p_parent_id=>wwv_flow_api.id(52820017569734839)
,p_short_name=>'Managers Cheque Data Loading'
,p_link=>'f?p=&APP_ID.:12:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>12
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(53968146881354397)
,p_parent_id=>wwv_flow_api.id(52820017569734839)
,p_short_name=>'Managers Cheque Data Loading'
,p_link=>'f?p=&APP_ID.:13:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>13
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(55823721319843956)
,p_parent_id=>wwv_flow_api.id(52820017569734839)
,p_short_name=>'Contracts'
,p_link=>'f?p=&APP_ID.:15:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>15
);
wwv_flow_api.component_end;
end;
/
