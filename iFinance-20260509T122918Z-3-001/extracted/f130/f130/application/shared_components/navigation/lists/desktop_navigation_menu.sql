prompt --application/shared_components/navigation/lists/desktop_navigation_menu
begin
--   Manifest
--     LIST: Desktop Navigation Menu
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(10191655534597729)
,p_name=>'Desktop Navigation Menu'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(10342530694597916)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Home'
,p_list_item_link_target=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:'
,p_list_item_icon=>'fa-home'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(11622196322977320)
,p_list_item_display_sequence=>70
,p_list_item_link_text=>'Projects'
,p_list_item_link_target=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-tasks'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'20'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(31534113548738541)
,p_list_item_display_sequence=>75
,p_list_item_link_text=>'Contracts'
,p_list_item_link_target=>'f?p=&APP_ID.:35:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-files-o'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'35'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(22096426095414296)
,p_list_item_display_sequence=>80
,p_list_item_link_text=>'Payments Recommendations'
,p_list_item_link_target=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-calendar-check-o'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'30'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(22122457508573525)
,p_list_item_display_sequence=>85
,p_list_item_link_text=>'Documents Library'
,p_list_item_link_target=>'f?p=&APP_ID.:31:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-book'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'31'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(22149696792726496)
,p_list_item_display_sequence=>86
,p_list_item_link_text=>'Notifications History'
,p_list_item_link_target=>'f?p=&APP_ID.:32:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-commenting-o'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'32'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(21285594378183726)
,p_list_item_display_sequence=>100
,p_list_item_link_text=>'CWIP Admin'
,p_list_item_icon=>'fa-gear'
,p_list_item_disp_cond_type=>'EXISTS'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    1',
'FROM',
'    dct_data_access_assignment',
'WHERE',
'        entity_type_id = ''ROLE''',
'    AND entity_id = 55   -- Role: CWIP Payments Admin',
'    AND status = ''A''',
'    AND sysdate BETWEEN start_date AND nvl(end_date, sysdate + 10)',
'    and person_id = :PERSON_ID;'))
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(10508044304641125)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Roles Categories'
,p_list_item_link_target=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-clipboard-check'
,p_list_item_disp_cond_type=>'EXISTS'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    1',
'FROM',
'    dct_data_access_assignment',
'WHERE',
'        entity_type_id = ''ROLE''',
'    AND entity_id = 55   -- Role: CWIP Payments Admin',
'    AND status = ''A''',
'    AND sysdate BETWEEN start_date AND nvl(end_date, sysdate + 10)',
'    and person_id = :PERSON_ID;'))
,p_parent_list_item_id=>wwv_flow_api.id(21285594378183726)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'2'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(10526310741814695)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Project Roles'
,p_list_item_link_target=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-server-user'
,p_list_item_disp_cond_type=>'EXISTS'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    1',
'FROM',
'    dct_data_access_assignment',
'WHERE',
'        entity_type_id = ''ROLE''',
'    AND entity_id = 55   -- Role: CWIP Payments Admin',
'    AND status = ''A''',
'    AND sysdate BETWEEN start_date AND nvl(end_date, sysdate + 10)',
'    and person_id = :PERSON_ID;'))
,p_parent_list_item_id=>wwv_flow_api.id(21285594378183726)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'3'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(10551438508007757)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Project Team'
,p_list_item_link_target=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-user-headset'
,p_list_item_disp_cond_type=>'EXISTS'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    1',
'FROM',
'    dct_data_access_assignment',
'WHERE',
'        entity_type_id = ''ROLE''',
'    AND entity_id = 55   -- Role: CWIP Payments Admin',
'    AND status = ''A''',
'    AND sysdate BETWEEN start_date AND nvl(end_date, sysdate + 10)',
'    and person_id = :PERSON_ID;'))
,p_parent_list_item_id=>wwv_flow_api.id(21285594378183726)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'4'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(10633545819166226)
,p_list_item_display_sequence=>50
,p_list_item_link_text=>'Manage Users'
,p_list_item_link_target=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-users'
,p_list_item_disp_cond_type=>'EXISTS'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    1',
'FROM',
'    dct_data_access_assignment',
'WHERE',
'        entity_type_id = ''ROLE''',
'    AND entity_id = 55   -- Role: CWIP Payments Admin',
'    AND status = ''A''',
'    AND sysdate BETWEEN start_date AND nvl(end_date, sysdate + 10)',
'    and person_id = :PERSON_ID;'))
,p_parent_list_item_id=>wwv_flow_api.id(21285594378183726)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'5,6'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(10809161023788276)
,p_list_item_display_sequence=>60
,p_list_item_link_text=>'CWIP Lookups'
,p_list_item_link_target=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-list-ol'
,p_list_item_disp_cond_type=>'EXISTS'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    1',
'FROM',
'    dct_data_access_assignment',
'WHERE',
'        entity_type_id = ''ROLE''',
'    AND entity_id = 55   -- Role: CWIP Payments Admin',
'    AND status = ''A''',
'    AND sysdate BETWEEN start_date AND nvl(end_date, sysdate + 10)',
'    and person_id = :PERSON_ID;'))
,p_parent_list_item_id=>wwv_flow_api.id(21285594378183726)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'7'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(31370731253440268)
,p_list_item_display_sequence=>110
,p_list_item_link_text=>'Manage Contractual Securities'
,p_list_item_link_target=>'f?p=&APP_ID.:33:&SESSION.::&DEBUG.::::'
,p_list_item_disp_cond_type=>'EXISTS'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    1',
'FROM',
'    dct_data_access_assignment',
'WHERE',
'        entity_type_id = ''ROLE''',
'    AND entity_id = 55   -- Role: CWIP Payments Admin',
'    AND status = ''A''',
'    AND sysdate BETWEEN start_date AND nvl(end_date, sysdate + 10)',
'    and person_id = :PERSON_ID;'))
,p_parent_list_item_id=>wwv_flow_api.id(21285594378183726)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'33'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(32799716441543134)
,p_list_item_display_sequence=>120
,p_list_item_link_text=>'My Signature'
,p_list_item_link_target=>'f?p=&APP_ID.:36:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(21285594378183726)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'36'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(39948443881840097)
,p_list_item_display_sequence=>130
,p_list_item_link_text=>'Invitations'
,p_list_item_disp_cond_type=>'EXISTS'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    1',
'FROM',
'    dct_data_access_assignment',
'WHERE',
'        entity_type_id = ''ROLE''',
'    AND entity_id = 55   -- Role: CWIP Payments Admin',
'    AND status = ''A''',
'    AND sysdate BETWEEN start_date AND nvl(end_date, sysdate + 10)',
'    and person_id = :PERSON_ID;'))
,p_parent_list_item_id=>wwv_flow_api.id(21285594378183726)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'44'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2465372243969954)
,p_list_item_display_sequence=>139
,p_list_item_link_text=>'Invitations (DCT Employees)'
,p_list_item_link_target=>'f?p=&APP_ID.:44:&SESSION.::&DEBUG.:44:::'
,p_list_item_icon=>'fa-send-o'
,p_parent_list_item_id=>wwv_flow_api.id(39948443881840097)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(39978872643603620)
,p_list_item_display_sequence=>140
,p_list_item_link_text=>'Invitations (Stakeholders)'
,p_list_item_link_target=>'f?p=&APP_ID.:46:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-send'
,p_parent_list_item_id=>wwv_flow_api.id(39948443881840097)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'46'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(46857356906447)
,p_list_item_display_sequence=>150
,p_list_item_link_text=>'CWIP Users'
,p_list_item_link_target=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.::::'
,p_list_item_disp_cond_type=>'EXISTS'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    1',
'FROM',
'    dct_data_access_assignment',
'WHERE',
'        entity_type_id = ''ROLE''',
'    AND entity_id = 55   -- Role: CWIP Payments Admin',
'    AND status = ''A''',
'    AND sysdate BETWEEN start_date AND nvl(end_date, sysdate + 10)',
'    and person_id = :PERSON_ID;'))
,p_parent_list_item_id=>wwv_flow_api.id(21285594378183726)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'42'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(14075543494165194)
,p_list_item_display_sequence=>160
,p_list_item_link_text=>'Delegation - Admin'
,p_list_item_link_target=>'f?p=&APP_ID.:51:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(21285594378183726)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'51'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(84282420422133902)
,p_list_item_display_sequence=>200
,p_list_item_link_text=>'Finance Admin'
,p_list_item_link_target=>'#'
,p_list_item_icon=>'fa-key'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':PERSON_ID in (680461,1634810, 661109 )'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(14195451200994082)
,p_list_item_display_sequence=>180
,p_list_item_link_text=>'Delegation - Admin'
,p_list_item_link_target=>'f?p=&APP_ID.:51:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-braille'
,p_parent_list_item_id=>wwv_flow_api.id(84282420422133902)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(84296728379116448)
,p_list_item_display_sequence=>210
,p_list_item_link_text=>'Manage Project Status'
,p_list_item_link_target=>'f?p=&APP_ID.:59:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(84282420422133902)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'59,60'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(86989048075490955)
,p_list_item_display_sequence=>220
,p_list_item_link_text=>'Manage Projects Locations'
,p_list_item_link_target=>'f?p=&APP_ID.:61:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(84282420422133902)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'61,62'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(115047852809384991)
,p_list_item_display_sequence=>310
,p_list_item_link_text=>'Vendors Accounts'
,p_list_item_link_target=>'f?p=&APP_ID.:70:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(84282420422133902)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'70'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(90048140123533591)
,p_list_item_display_sequence=>300
,p_list_item_link_text=>'Invitations - TPC'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':APP_USER in (''TCA9145'', ''TCA9051'')'
,p_list_item_current_type=>'ALWAYS'
,p_list_item_current_for_pages=>'44'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(90048451806532274)
,p_list_item_display_sequence=>10020
,p_list_item_link_text=>'Invitations (DCT Employees) - TPC'
,p_list_item_link_target=>'f?p=&APP_ID.:44:&SESSION.::&DEBUG.:44:::'
,p_list_item_icon=>'fa-send-o'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':APP_USER = ''TCA9145'''
,p_parent_list_item_id=>wwv_flow_api.id(90048140123533591)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(90048728238531268)
,p_list_item_display_sequence=>10030
,p_list_item_link_text=>'Invitations (Stakeholders) - TPC'
,p_list_item_link_target=>'f?p=&APP_ID.:46:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-send'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':APP_USER = ''TCA9145'''
,p_parent_list_item_id=>wwv_flow_api.id(90048140123533591)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'46'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(21346896979406607)
,p_list_item_display_sequence=>10000
,p_list_item_link_text=>'Administration'
,p_list_item_link_target=>'f?p=&APP_ID.:10000:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-user-wrench'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':PERSON_ID = 680461'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'10000'
);
wwv_flow_api.component_end;
end;
/
