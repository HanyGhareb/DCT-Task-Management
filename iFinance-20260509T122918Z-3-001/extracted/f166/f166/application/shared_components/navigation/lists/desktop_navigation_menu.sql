prompt --application/shared_components/navigation/lists/desktop_navigation_menu
begin
--   Manifest
--     LIST: Desktop Navigation Menu
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>120
,p_default_id_offset=>143576171933264960
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(24493709663319360)
,p_name=>'Desktop Navigation Menu'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(24649226896319187)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Single Source Requests [&SINGLE_SOURCE_REQUEST_COUNT.]'
,p_list_item_link_target=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-list'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(26860975688092159)
,p_list_item_display_sequence=>50
,p_list_item_link_text=>'PC Form Requests [&TAC_FORM_COUNT.]'
,p_list_item_link_target=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-address-card-o'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
' :IS_SINGLE_SOURCE_ADMIN = ''Y'' or ',
':IS_SUPPLY_MANAGEMENT_UNIT_HEAD > 0 or',
':IS_BUYER   > 0 or',
':IS_COMMITTEE_SECRETARY > 0 or',
':IS_SOUCEING_MANAGER > 0 or ',
':PERSON_ID = 680461'))
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'11,12'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(175484743538476)
,p_list_item_display_sequence=>70
,p_list_item_link_text=>'Meetings Calendar'
,p_list_item_link_target=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-calendar-clock'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'    :IS_SINGLE_SOURCE_ADMIN = ''Y'' or ',
':IS_SUPPLY_MANAGEMENT_UNIT_HEAD > 0 or',
':IS_BUYER   > 0 or',
':IS_COMMITTEE_SECRETARY > 0 or',
':IS_SOUCEING_MANAGER > 0 or',
':PERSON_ID = 680461'))
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'21'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(24926918516318645)
,p_list_item_display_sequence=>10000
,p_list_item_link_text=>'Administration'
,p_list_item_link_target=>'f?p=&APP_ID.:10000:&APP_SESSION.::&DEBUG.:'
,p_list_item_icon=>'fa-user-wrench'
,p_security_scheme=>wwv_flow_api.id(24635939460319229)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(1496825832047956)
,p_list_item_display_sequence=>10010
,p_list_item_link_text=>'Admin'
,p_list_item_icon=>'fa-gears'
,p_list_item_disp_cond_type=>'EXISTS'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    person_id',
'FROM',
'    dct_data_access_assignment',
'WHERE',
'        entity_type_id = ''ROLE''',
'    AND entity_id = 67  -- Single Source Admin Role',
'    AND status = ''A''',
'    AND sysdate BETWEEN start_date AND nvl(end_date, sysdate + 10)',
'   AND person_id = :PERSON_ID;'))
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(25506156743790337)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Exemption Types'
,p_list_item_link_target=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.::::'
,p_parent_list_item_id=>wwv_flow_api.id(1496825832047956)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'4'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(26499660130088935)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'PC Committees'
,p_list_item_link_target=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::::'
,p_parent_list_item_id=>wwv_flow_api.id(1496825832047956)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'8,9'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(12867277049021890)
,p_list_item_display_sequence=>80
,p_list_item_link_text=>'PC Forms Recommendations'
,p_list_item_link_target=>'f?p=&APP_ID.:24:&SESSION.::&DEBUG.::::'
,p_parent_list_item_id=>wwv_flow_api.id(1496825832047956)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'24'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(12890155280854320)
,p_list_item_display_sequence=>90
,p_list_item_link_text=>'PC Form Documents Instructions Settings'
,p_list_item_link_target=>'f?p=&APP_ID.:25:&SESSION.::&DEBUG.::::'
,p_parent_list_item_id=>wwv_flow_api.id(1496825832047956)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'25'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(23698255647401090)
,p_list_item_display_sequence=>100
,p_list_item_link_text=>'SMD Form Settings'
,p_list_item_link_target=>'f?p=&APP_ID.:14:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(1496825832047956)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'14'
);
wwv_flow_api.component_end;
end;
/
