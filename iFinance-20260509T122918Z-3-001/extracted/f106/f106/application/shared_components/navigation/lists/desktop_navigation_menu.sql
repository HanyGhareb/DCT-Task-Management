prompt --application/shared_components/navigation/lists/desktop_navigation_menu
begin
--   Manifest
--     LIST: Desktop Navigation Menu
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>227103249168277234
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(12845212793762064)
,p_name=>'Desktop Navigation Menu'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(12993350098762246)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Home'
,p_list_item_link_target=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:'
,p_list_item_icon=>'fa-home'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(109801822096079659)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Duty Hub'
,p_list_item_link_target=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-plane'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(109934443460265884)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Duty Hub Admin'
,p_list_item_icon=>'fa-lock-user'
,p_parent_list_item_id=>wwv_flow_api.id(109801822096079659)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(109954503612257486)
,p_list_item_display_sequence=>80
,p_list_item_link_text=>'Manage Rates'
,p_list_item_link_target=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-layout-3row'
,p_parent_list_item_id=>wwv_flow_api.id(109934443460265884)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'5,6'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(110362000917277685)
,p_list_item_display_sequence=>90
,p_list_item_link_text=>'Countries'
,p_list_item_link_target=>'f?p=&APP_ID.:16:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-flag-o'
,p_parent_list_item_id=>wwv_flow_api.id(109934443460265884)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'16,17'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(545346244477724)
,p_list_item_display_sequence=>100
,p_list_item_link_text=>'Exceptions'
,p_list_item_link_target=>'f?p=&APP_ID.:24:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-exception'
,p_parent_list_item_id=>wwv_flow_api.id(109934443460265884)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'24,25'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(1292050150674867)
,p_list_item_display_sequence=>110
,p_list_item_link_text=>'Default Options'
,p_list_item_link_target=>'f?p=&APP_ID.:26:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-shield'
,p_parent_list_item_id=>wwv_flow_api.id(109934443460265884)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'26,27'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2864411566672720)
,p_list_item_display_sequence=>120
,p_list_item_link_text=>'Manage Vendors'
,p_list_item_link_target=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-file-user'
,p_parent_list_item_id=>wwv_flow_api.id(109934443460265884)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'21,29'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(3294930109335891)
,p_list_item_display_sequence=>140
,p_list_item_link_text=>'SAP Employees Data'
,p_list_item_link_target=>'f?p=&APP_ID.:34:&SESSION.::&DEBUG.::::'
,p_list_item_disp_cond_type=>'NEVER'
,p_parent_list_item_id=>wwv_flow_api.id(109934443460265884)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'34'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(4947664311918196)
,p_list_item_display_sequence=>150
,p_list_item_link_text=>'Freelancers'
,p_list_item_link_target=>'f?p=&APP_ID.:35:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-users'
,p_parent_list_item_id=>wwv_flow_api.id(109934443460265884)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'35,36'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(109802267440078088)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Housing'
,p_list_item_link_target=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-hospital-o'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':person_id = 680461'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(12996454684767876)
,p_list_item_display_sequence=>60
,p_list_item_link_text=>'Insurance Statement'
,p_list_item_link_target=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:RP,2:::'
,p_list_item_icon=>'fa-align-justify'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':PERSON_ID = 680461'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'2'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(47932345248875886)
,p_list_item_display_sequence=>70
,p_list_item_link_text=>'Upload Payroll Elements'
,p_list_item_link_target=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.::::'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':PERSON_ID = 680461'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'7'
);
wwv_flow_api.component_end;
end;
/
