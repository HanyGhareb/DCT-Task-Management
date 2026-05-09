prompt --application/shared_components/navigation/lists/sshr_list
begin
--   Manifest
--     LIST: SSHR List
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(5905716519981988)
,p_name=>'SSHR List'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(5905917877981988)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Missions'
,p_list_item_link_target=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::P3_TYPE_CODE:M:'
,p_list_item_icon=>'fa-plane'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(6830529166426696)
,p_list_item_display_sequence=>15
,p_list_item_link_text=>'Training'
,p_list_item_link_target=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::P3_TYPE_CODE:T:'
,p_list_item_icon=>'fa-industry'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(5906224196981987)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Housing '
,p_list_item_link_target=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-home'
,p_list_item_disp_cond_type=>'NEVER'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(5909554482936435)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'P&P Admin'
,p_list_item_link_target=>'f?p=&APP_ID.:37:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-users'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':IS_COMPENSATION_BENIFIT_YN = ''Y'' or :PERSON_ID = 680461 or :IS_HR_ADMIN = ''Y'''
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(6283950500050830)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Payroll Admin'
,p_list_item_link_target=>'f?p=&APP_ID.:38:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-user'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':IS_PAYROLL_ADMIN = ''Y'' or :PERSON_ID = 680461 or :VIEW_ALL_DUTY_YN = ''Y'''
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.component_end;
end;
/
