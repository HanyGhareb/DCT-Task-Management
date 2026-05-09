prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
--   Manifest
--     MENU: Breadcrumb
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>805
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_menu(
 p_id=>wwv_flow_api.id(35977418184523185)
,p_name=>'Breadcrumb'
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(35977650458523185)
,p_short_name=>'Home'
,p_link=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.'
,p_page_id=>1
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(36271618282522700)
,p_short_name=>'Administration'
,p_link=>'f?p=&APP_ID.:10000:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>10000
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(36321413978151575)
,p_parent_id=>wwv_flow_api.id(35977650458523185)
,p_short_name=>'Registrations Requests'
,p_link=>'f?p=&APP_ID.:2:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>2
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(36322657412151573)
,p_parent_id=>wwv_flow_api.id(36321413978151575)
,p_short_name=>'Registration Request Details'
,p_link=>'f?p=&APP_ID.:3:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>3
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(36357402377215728)
,p_parent_id=>wwv_flow_api.id(35977650458523185)
,p_short_name=>'Registration Request Details'
,p_link=>'f?p=&APP_ID.:4:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>4
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(36574635769372080)
,p_parent_id=>wwv_flow_api.id(35977650458523185)
,p_short_name=>'Service Providers'
,p_link=>'f?p=&APP_ID.:5:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>5
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(36575894889372077)
,p_parent_id=>wwv_flow_api.id(36574635769372080)
,p_short_name=>'Service Provider Details'
,p_link=>'f?p=&APP_ID.:6:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>6
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(36935364168332120)
,p_parent_id=>wwv_flow_api.id(35977650458523185)
,p_short_name=>'Service Agreements'
,p_link=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:::'
,p_page_id=>9
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(36936518058332117)
,p_parent_id=>wwv_flow_api.id(36935364168332120)
,p_short_name=>'Service Agreement Details'
,p_link=>'f?p=&APP_ID.:10:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>10
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(37144542824181388)
,p_parent_id=>wwv_flow_api.id(36936518058332117)
,p_short_name=>'Payment request Details'
,p_link=>'f?p=&APP_ID.:12:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>12
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(179699427007192072)
,p_parent_id=>wwv_flow_api.id(35977650458523185)
,p_short_name=>'Freelancers Conversion Lookup'
,p_link=>'f?p=&APP_ID.:13:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>13
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(179700641739192075)
,p_parent_id=>wwv_flow_api.id(179699427007192072)
,p_short_name=>'Conversion Lookup Details'
,p_link=>'f?p=&APP_ID.:14:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>14
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(179730151077286564)
,p_parent_id=>wwv_flow_api.id(35977650458523185)
,p_short_name=>'Freelancers Locations Lookup'
,p_link=>'f?p=&APP_ID.:15:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>15
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(179731320450286566)
,p_parent_id=>wwv_flow_api.id(179730151077286564)
,p_short_name=>'Location Lookup Details'
,p_link=>'f?p=&APP_ID.:16:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>16
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(179759856417356515)
,p_parent_id=>wwv_flow_api.id(35977650458523185)
,p_short_name=>'Freelancers Payment Cycle Lookup'
,p_link=>'f?p=&APP_ID.:17:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>17
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(179761081472356515)
,p_parent_id=>wwv_flow_api.id(179759856417356515)
,p_short_name=>'Payment cycle Details'
,p_link=>'f?p=&APP_ID.:18:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>18
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(179805012514543908)
,p_parent_id=>wwv_flow_api.id(35977650458523185)
,p_short_name=>'Freelancers Contract Duration Lookup'
,p_link=>'f?p=&APP_ID.:19:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>19
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(179806260542543909)
,p_parent_id=>wwv_flow_api.id(179805012514543908)
,p_short_name=>'Contract Duration Lookup Details'
,p_link=>'f?p=&APP_ID.:20:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>20
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(179839878857626119)
,p_short_name=>'Freelancers Technology Required Lookup'
,p_link=>'f?p=&APP_ID.:21:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>21
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(179841056770626120)
,p_parent_id=>wwv_flow_api.id(179839878857626119)
,p_short_name=>'Technology Required Lookup Details'
,p_link=>'f?p=&APP_ID.:22:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>22
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(179965416377126733)
,p_parent_id=>wwv_flow_api.id(35977650458523185)
,p_short_name=>'Manage Lookups'
,p_link=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.:::'
,p_page_id=>23
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(181720308239785639)
,p_parent_id=>wwv_flow_api.id(35977650458523185)
,p_short_name=>'Freelancer Details'
,p_link=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.:::'
,p_page_id=>30
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(193291600140894377)
,p_parent_id=>wwv_flow_api.id(181720308239785639)
,p_short_name=>'Freelancer Request Document'
,p_link=>'f?p=&APP_ID.:24:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>24
);
wwv_flow_api.component_end;
end;
/
