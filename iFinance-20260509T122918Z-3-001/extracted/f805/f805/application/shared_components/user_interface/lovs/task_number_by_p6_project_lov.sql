prompt --application/shared_components/user_interface/lovs/task_number_by_p6_project_lov
begin
--   Manifest
--     TASK NUMBER BY P6_PROJECT LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>805
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(36886693387559890)
,p_lov_name=>'TASK NUMBER BY P6_PROJECT LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select task_number Task_number,',
'        task_number r',
'from task',
'WHERE project_number = nvl(:P6_PROJECT_NUMBER , :P10_PROJECT_NUMBER)'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'R'
,p_display_column_name=>'TASK_NUMBER'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'TASK_NUMBER'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
