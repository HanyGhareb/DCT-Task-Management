prompt --application/shared_components/navigation/lists/desktop_navigation_menu
begin
--   Manifest
--     LIST: Desktop Navigation Menu
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>116806299474925354
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(23782992033372595)
,p_name=>'Desktop Navigation Menu'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(23933813250372427)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Home'
,p_list_item_link_target=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:'
,p_list_item_icon=>'fa-home'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(24714301499849194)
,p_list_item_display_sequence=>80
,p_list_item_link_text=>'Credit Card View'
,p_list_item_link_target=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.::::'
,p_list_item_disp_cond_type=>'NEVER'
,p_parent_list_item_id=>wwv_flow_api.id(23933813250372427)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'21'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(34961371063234952)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'My Notification History'
,p_list_item_link_target=>'f?p=&APP_ID.:13:&APP_SESSION.::&DEBUG.:::'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'13'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(33836271580223471)
,p_list_item_display_sequence=>10010
,p_list_item_link_text=>'Treasury Admin'
,p_list_item_link_target=>'#'
,p_list_item_icon=>'fa-user-headset'
,p_list_item_disp_cond_type=>'EXISTS'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select d.person_id ',
' from DCT_DATA_ACCESS_ASSIGNMENT d',
'where entity_id =  52    -- Tresury Admin',
'and status = ''A''',
'and sysdate between start_date and nvl(end_date , sysdate+ 100)',
'and person_id = :PERSON_ID',
'UNION all',
'select 1',
'from dual',
'where :PERSON_ID = 680461;'))
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(24306985999501071)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Manage Documents Required'
,p_list_item_link_target=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-address-book-o'
,p_parent_list_item_id=>wwv_flow_api.id(33836271580223471)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'3'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(33814307664383189)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Invitation'
,p_list_item_link_target=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:9:::'
,p_list_item_icon=>'fa-envelope-user'
,p_parent_list_item_id=>wwv_flow_api.id(33836271580223471)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'9'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(38631921521927615)
,p_list_item_display_sequence=>50
,p_list_item_link_text=>'Credit Cards Dashboard'
,p_list_item_link_target=>'f?p=&APP_ID.:15:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-dashboard'
,p_parent_list_item_id=>wwv_flow_api.id(33836271580223471)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'15'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(38655534423271548)
,p_list_item_display_sequence=>60
,p_list_item_link_text=>'Reports Center'
,p_list_item_link_target=>'f?p=&APP_ID.:16:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-cloud-chart'
,p_parent_list_item_id=>wwv_flow_api.id(33836271580223471)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'16'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(76139226138832656)
,p_list_item_display_sequence=>70
,p_list_item_link_text=>'Delegation'
,p_list_item_link_target=>'f?p=&APP_ID.:17:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(33836271580223471)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'17'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(9377029161074255)
,p_list_item_display_sequence=>100
,p_list_item_link_text=>'Credit Cards Bank Approvers Report'
,p_list_item_link_target=>'f?p=&APP_ID.:28:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(33836271580223471)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'28,29'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(76069745210578839)
,p_list_item_display_sequence=>10030
,p_list_item_link_text=>'Delegation'
,p_list_item_link_target=>'f?p=&APP_ID.:17:&SESSION.:17:&DEBUG.::::'
,p_list_item_icon=>'fa fa-mail-forward fa-1x fam-information fam-is-success'
,p_parent_list_item_id=>wwv_flow_api.id(33836271580223471)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(54426009289040)
,p_list_item_display_sequence=>10020
,p_list_item_link_text=>'Administration'
,p_list_item_link_target=>'f?p=&APP_ID.:10000:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-user-wrench'
,p_list_item_disp_cond_type=>'NEVER'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'10000'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(22644650199818589)
,p_list_item_display_sequence=>10040
,p_list_item_link_text=>'Monitoring'
,p_list_item_link_target=>'f?p=&APP_ID.:17:&SESSION.::&DEBUG.:RP:::'
,p_list_item_icon=>'fa-gears'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':PERSON_ID in (680461 , 128357 , 1535161)'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(21108716993647777)
,p_list_item_display_sequence=>10050
,p_list_item_link_text=>'Gift Cards'
,p_list_item_link_target=>'f?p=&APP_ID.:24:&SESSION.::&DEBUG.:RP:::'
,p_list_item_icon=>'fa-gift'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':PERSON_ID = 680461'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(21048794423637659)
,p_list_item_display_sequence=>90
,p_list_item_link_text=>'Gift Cards Home'
,p_list_item_link_target=>'f?p=&APP_ID.:25:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(21108716993647777)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'25,26'
);
wwv_flow_api.component_end;
end;
/
