prompt --application/shared_components/navigation/lists/desktop_navigation_menu
begin
--   Manifest
--     LIST: Desktop Navigation Menu
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>114
,p_default_id_offset=>9604171250607172
,p_default_owner=>'DEV'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(65495005612255669)
,p_name=>'Desktop Navigation Menu'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(65640022747255905)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Home'
,p_list_item_link_target=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:'
,p_list_item_icon=>'fa-home'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(65641464284255907)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Budget Transfer Requests'
,p_list_item_link_target=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:20:::'
,p_list_item_icon=>'fa-map-signs'
,p_list_item_disp_cond_type=>'NEVER'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(66120608725477610)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Projects Data [&PROJECTS_USER.]'
,p_list_item_link_target=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-database-bookmark fam-check fam-is-success'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'7'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(66163233685197810)
,p_list_item_display_sequence=>110
,p_list_item_link_text=>'Approvers Management'
,p_list_item_link_target=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-database-user'
,p_security_scheme=>wwv_flow_api.id(70305549671149387)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'8'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(66687324382436753)
,p_list_item_display_sequence=>120
,p_list_item_link_text=>'Budget Transfer Requests'
,p_list_item_link_target=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-money fam-plus fam-is-success'
,p_security_scheme=>wwv_flow_api.id(70305549671149387)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'11'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(66899000394442564)
,p_list_item_display_sequence=>130
,p_list_item_link_text=>'Available to Oracle'
,p_list_item_link_target=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.::::'
,p_security_scheme=>wwv_flow_api.id(70397243083858530)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'13'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(65880922339256293)
,p_list_item_display_sequence=>1000
,p_list_item_link_text=>'Administration'
,p_list_item_link_target=>'f?p=&APP_ID.:10000:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-user-wrench'
,p_security_scheme=>wwv_flow_api.id(65627625489255849)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(77292029152609444)
,p_list_item_display_sequence=>1070
,p_list_item_link_text=>'Manage Lookups'
,p_list_item_link_target=>'f?p=&APP_ID.:35:&SESSION.::&DEBUG.::::'
,p_parent_list_item_id=>wwv_flow_api.id(65880922339256293)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'35'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(66942214988289180)
,p_list_item_display_sequence=>1010
,p_list_item_link_text=>'Test Mail'
,p_list_item_link_target=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.::::'
,p_security_scheme=>wwv_flow_api.id(65627625489255849)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'14'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(70035729244033779)
,p_list_item_display_sequence=>1020
,p_list_item_link_text=>'User Access'
,p_list_item_link_target=>'f?p=&APP_ID.:15:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-address-card-o'
,p_security_scheme=>wwv_flow_api.id(70397243083858530)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'15'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(70591401440977727)
,p_list_item_display_sequence=>1030
,p_list_item_link_text=>'End User - Home'
,p_list_item_link_target=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.::::'
,p_list_item_disp_cond_type=>'NEVER'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'20'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(75607409068000418)
,p_list_item_display_sequence=>1040
,p_list_item_link_text=>'Projects Users - Home'
,p_list_item_link_target=>'f?p=&APP_ID.:22:&SESSION.::&DEBUG.::::'
,p_list_item_disp_cond_type=>'NEVER'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'22,23'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(77139856554920488)
,p_list_item_display_sequence=>1050
,p_list_item_link_text=>'Reports'
,p_list_item_link_target=>'f?p=&APP_ID.:34:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-bar-chart fam-clock fam-is-success'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'34,38'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(77204183615037664)
,p_list_item_display_sequence=>1060
,p_list_item_link_text=>'End User - Transfer Requests'
,p_list_item_link_target=>'f?p=&APP_ID.:33:&SESSION.::&DEBUG.:33:::'
,p_list_item_icon=>'fa-envelope-user fam-information fam-is-success'
,p_parent_list_item_id=>wwv_flow_api.id(77139856554920488)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2073669390854144)
,p_list_item_display_sequence=>1080
,p_list_item_link_text=>'Documents Library'
,p_list_item_link_target=>'f?p=&APP_ID.:38:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-files-o fam-check fam-is-success'
,p_parent_list_item_id=>wwv_flow_api.id(77139856554920488)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'38'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(7348807630259262)
,p_list_item_display_sequence=>1090
,p_list_item_link_text=>'Analysis Criteria'
,p_list_item_link_target=>'f?p=&APP_ID.:35:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-list fam-plus fam-is-success'
,p_parent_list_item_id=>wwv_flow_api.id(77139856554920488)
,p_security_scheme=>wwv_flow_api.id(70305549671149387)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.component_end;
end;
/
