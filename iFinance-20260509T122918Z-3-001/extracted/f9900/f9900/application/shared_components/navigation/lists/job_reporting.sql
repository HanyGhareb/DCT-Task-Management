prompt --application/shared_components/navigation/lists/job_reporting
begin
--   Manifest
--     LIST: Job Reporting
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>910
,p_default_id_offset=>82649548957193263
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(31718802724441027)
,p_name=>'Job Reporting'
,p_list_status=>'PUBLIC'
,p_required_patch=>wwv_flow_api.id(31679425692441216)
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(31719214659441026)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Job Reporting'
,p_list_item_link_target=>'f?p=&APP_ID.:10030:&SESSION.::&DEBUG.:10030:::'
,p_list_item_icon=>'fa-user-chart'
,p_list_text_01=>'View status and run details of jobs supporting this application'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.component_end;
end;
/
