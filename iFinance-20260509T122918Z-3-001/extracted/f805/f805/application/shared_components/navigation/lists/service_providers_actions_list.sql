prompt --application/shared_components/navigation/lists/service_providers_actions_list
begin
--   Manifest
--     LIST: Service Providers Actions List
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>805
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(38429843679545426)
,p_name=>'Service Providers Actions List'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(38430026614545424)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'New Agreement'
,p_list_item_link_target=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.::P10_SERVICE_PROVIDER_ID,P10_ORG_ID,P10_PROJECT_NUMBER,P10_TASK_NUMBER,P10_EXPENDITURE_TYPE,P10_COST_CENTER_CODE,P10_GL_ACCOUNT,P10_GL_ACTIVITY,P10_GL_FUTURE1,P10_GL_FUTURE2:&P6_SERVICE_PROVIDER_ID.,&P6_DEPARTMENT_ID.,&P6_PROJECT_NUMBER.,&P6_TASK_NUMBER.,&P6_EXPENDITURE_TYPE.,&P6_COST_CENTER.,&P6_GL_ACCOUNT.,&P6_GL_ACTIVITY.,&P6_GL_FUTURE1.,&P6_GL_FUTURE2.:'
,p_list_item_icon=>'fa-file-o fam-check fam-is-success'
,p_list_text_01=>'XX'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(38430480572545422)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'New Invoice'
,p_list_item_link_target=>'f?p=&APP_ID.::&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-money'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(38430897087545422)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Send Invitation'
,p_list_item_link_target=>'f?p=&APP_ID.::&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-envelope-o'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.component_end;
end;
/
