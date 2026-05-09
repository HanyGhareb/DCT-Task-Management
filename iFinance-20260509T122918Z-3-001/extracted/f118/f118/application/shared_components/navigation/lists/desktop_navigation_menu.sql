prompt --application/shared_components/navigation/lists/desktop_navigation_menu
begin
--   Manifest
--     LIST: Desktop Navigation Menu
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>118
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(122859519449781705)
,p_name=>'Desktop Navigation Menu'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(123012887191781546)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Home'
,p_list_item_link_target=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:'
,p_list_item_icon=>'fa-home'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(123014343270781544)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Customers'
,p_list_item_link_target=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-user-secret'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':PERSON_ID = 680461'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(123039494001781371)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Due Transactions'
,p_list_item_link_target=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-file-text-o'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':PERSON_ID = 680461'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(156914830189059192)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Customer Outstanding'
,p_list_item_link_target=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-credit-card-terminal'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'11,12'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(157184376490949897)
,p_list_item_display_sequence=>50
,p_list_item_link_text=>'Reminders Tracking'
,p_list_item_link_target=>'f?p=&APP_ID.:19:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-alert'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'19'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(169271736858882685)
,p_list_item_display_sequence=>80
,p_list_item_link_text=>'Hotels P&L'
,p_list_item_link_target=>'f?p=&APP_ID.:25:&APP_SESSION.::&DEBUG.:::'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'25'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(123237125610781067)
,p_list_item_display_sequence=>10000
,p_list_item_link_text=>'Administration'
,p_list_item_link_target=>'f?p=&APP_ID.:10000:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-user-wrench'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':PERSON_ID = 680461'
,p_security_scheme=>wwv_flow_api.id(123001858009781584)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(168900983229379248)
,p_list_item_display_sequence=>10010
,p_list_item_link_text=>'System Admin'
,p_list_item_icon=>'fa-lock-user'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':PERSON_ID = 680461'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(168922902127389167)
,p_list_item_display_sequence=>60
,p_list_item_link_text=>'Categories List'
,p_list_item_link_target=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-address-card'
,p_parent_list_item_id=>wwv_flow_api.id(168900983229379248)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'21,22'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(168978484972135831)
,p_list_item_display_sequence=>70
,p_list_item_link_text=>'Memo Lines List'
,p_list_item_link_target=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-align-justify'
,p_parent_list_item_id=>wwv_flow_api.id(168900983229379248)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'23,24'
);
wwv_flow_api.component_end;
end;
/
