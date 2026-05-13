prompt --application/shared_components/navigation/lists/desktop_navigation_menu
begin
--   Manifest
--     LIST: Desktop Navigation Menu
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(8004392989175483)
,p_name=>'Desktop Navigation Menu'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(8152446854175585)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Home'
,p_list_item_link_target=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:'
,p_list_item_icon=>'fa-home'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(8156473111189479)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'My Petty Cash [&P2_PETTY_CASH_COUNT.]'
,p_list_item_link_target=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:::'
,p_list_item_icon=>'fa-file-archive-o'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'2'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(46344417545972788)
,p_list_item_display_sequence=>50
,p_list_item_link_text=>'My Expense Reports [&P16_ER_COUNT.]'
,p_list_item_link_target=>'f?p=&APP_ID.:16:&SESSION.::&DEBUG.:16:::'
,p_list_item_icon=>'fa-money'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'16'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(3687650862353043)
,p_list_item_display_sequence=>90
,p_list_item_link_text=>'Configurations'
,p_list_item_link_target=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.::P11_ID:1:'
,p_list_item_icon=>'fa-gear'
,p_list_item_disp_cond_type=>'EXISTS'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT *',
'FROM DCT_DATA_ACCESS_ASSIGNMENT',
'where user_id = :APP_USER',
'    and entity_type_id = ''ROLE''',
'    and dct_data_access_assignment.entity_id = 24  '))
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'11'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(4803573664815742)
,p_list_item_display_sequence=>110
,p_list_item_link_text=>'Petty Cash Admin'
,p_list_item_icon=>'fa-lock-user'
,p_list_item_disp_cond_type=>'EXISTS'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT *',
'FROM DCT_DATA_ACCESS_ASSIGNMENT',
'where user_id = :APP_USER',
'    and entity_type_id = ''ROLE''',
'    and dct_data_access_assignment.entity_id = 11',
'    and status = ''A'' ',
'    and sysdate between nvl(start_date , sysdate - 10) ',
'        and nvl(end_date , sysdate + 10);'))
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(29397719130052414)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'All Petty Cash'
,p_list_item_link_target=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:8:::'
,p_list_item_icon=>'fa-money'
,p_parent_list_item_id=>wwv_flow_api.id(4803573664815742)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'8'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(46594998345233252)
,p_list_item_display_sequence=>70
,p_list_item_link_text=>'Expense Reports - AP'
,p_list_item_link_target=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:7:::'
,p_list_item_icon=>'fa-file-excel-o'
,p_parent_list_item_id=>wwv_flow_api.id(4803573664815742)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'7'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(556823943033296)
,p_list_item_display_sequence=>80
,p_list_item_link_text=>'Invitation - Petty Cash'
,p_list_item_link_target=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-comment-o'
,p_parent_list_item_id=>wwv_flow_api.id(4803573664815742)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'9'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(4254052398172409)
,p_list_item_display_sequence=>100
,p_list_item_link_text=>'Petty Cash Dashboard'
,p_list_item_link_target=>'f?p=&APP_ID.:25:&SESSION.::&DEBUG.:25:::'
,p_list_item_icon=>'fa-dial-gauge-chart'
,p_list_item_disp_cond_type=>'NEVER'
,p_parent_list_item_id=>wwv_flow_api.id(4803573664815742)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'25'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(596049134533092)
,p_list_item_display_sequence=>160
,p_list_item_link_text=>'Petty Cash Delegation - Admin'
,p_list_item_link_target=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-user-graduate'
,p_parent_list_item_id=>wwv_flow_api.id(4803573664815742)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'47'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(1368478573468359)
,p_list_item_display_sequence=>165
,p_list_item_link_text=>'Petty Cash Vouchers'
,p_list_item_link_target=>'f?p=&APP_ID.:46:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-file-text-o'
,p_parent_list_item_id=>wwv_flow_api.id(4803573664815742)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'46'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(379405501786928)
,p_list_item_display_sequence=>170
,p_list_item_link_text=>'FAB DEBIT CARD Accounts [&FAB_DEBIT_CARD_COUNT.]'
,p_list_item_link_target=>'f?p=&APP_ID.:49:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-file-o'
,p_parent_list_item_id=>wwv_flow_api.id(4803573664815742)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'49,50'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(332454038970626)
,p_list_item_display_sequence=>180
,p_list_item_link_text=>'DCT IMPREST Accounts [&DCT_IMPREST_COUNT.]'
,p_list_item_link_target=>'f?p=&APP_ID.:51:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-file-code-o'
,p_parent_list_item_id=>wwv_flow_api.id(4803573664815742)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'51'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(246041785419003)
,p_list_item_display_sequence=>190
,p_list_item_link_text=>'Approval Monitoring - Admin'
,p_list_item_link_target=>'f?p=&APP_ID.:53:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-check-square-o'
,p_parent_list_item_id=>wwv_flow_api.id(4803573664815742)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'53'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2522490473060665)
,p_list_item_display_sequence=>210
,p_list_item_link_text=>'Petty cash Tracking'
,p_list_item_link_target=>'f?p=&APP_ID.:57:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-calendar-search'
,p_parent_list_item_id=>wwv_flow_api.id(4803573664815742)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'57'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2546723822479913)
,p_list_item_display_sequence=>220
,p_list_item_link_text=>'Expense Reports Tracking'
,p_list_item_link_target=>'f?p=&APP_ID.:58:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-check-square'
,p_parent_list_item_id=>wwv_flow_api.id(4803573664815742)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'58'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(25707135628395962)
,p_list_item_display_sequence=>230
,p_list_item_link_text=>'Petty Cash - Change Type'
,p_list_item_link_target=>'f?p=&APP_ID.:56:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-exchange'
,p_parent_list_item_id=>wwv_flow_api.id(4803573664815742)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'56'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(16125048653102827)
,p_list_item_display_sequence=>240
,p_list_item_link_text=>'Control System Access'
,p_list_item_link_target=>'f?p=&APP_ID.:62:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-key'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':PERSON_ID in ( 680461, 585407)'
,p_parent_list_item_id=>wwv_flow_api.id(4803573664815742)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'62'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(31589271946637432)
,p_list_item_display_sequence=>250
,p_list_item_link_text=>'Petty Cash Approval Changes - Admin'
,p_list_item_link_target=>'f?p=&APP_ID.:63:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(4803573664815742)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'63'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(6627075256053926)
,p_list_item_display_sequence=>120
,p_list_item_link_text=>'All Petty Cash (Directors)'
,p_list_item_link_target=>'f?p=&APP_ID.:36:&SESSION.::&DEBUG.::::'
,p_list_item_disp_cond_type=>'FUNCTION_BODY'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Declare',
'l_count number;',
'begin',
'',
'select count(DISTINCT director_num) ',
'into l_count',
'from employees_v',
'where director_num = :EMP_NUM',
'and current_flag = ''Y'';',
'',
' ',
'         if l_count > 0 then ',
'                     return true;',
'                  else',
'                      return false;',
'            end if;',
'end;'))
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'36'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(6973319543476132)
,p_list_item_display_sequence=>130
,p_list_item_link_text=>'Petty Cashes (Exec-Directors)'
,p_list_item_link_target=>'f?p=&APP_ID.:36:&SESSION.::&DEBUG.::::'
,p_list_item_disp_cond_type=>'FUNCTION_BODY'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Declare',
'l_count number;',
'begin',
'',
'select count(DISTINCT director_num) ',
'into l_count',
'from employees_v',
'where executive_director_num = :EMP_NUM',
'and current_flag = ''Y'';',
'',
' ',
'         if l_count > 0 then ',
'                     return true;',
'                  else',
'                      return false;',
'            end if;',
'end;',
''))
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(17975188822946497)
,p_list_item_display_sequence=>140
,p_list_item_link_text=>'Manual Petty Cash Details'
,p_list_item_link_target=>'f?p=&APP_ID.:90:&SESSION.::&DEBUG.::::'
,p_list_item_disp_cond_type=>'EXISTS'
,p_list_item_disp_condition=>'select 1 from employees_v where employee_num = :EMP_NUM and employee_num = 9051'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'90'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(1637543834090375)
,p_list_item_display_sequence=>200
,p_list_item_link_text=>'XX-RPA'
,p_list_item_link_target=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::::'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':PERSON_ID = 680461'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'54'
);
wwv_flow_api.component_end;
end;
/
