prompt --application/shared_components/user_interface/lovs/tasks_by_project_number_page11
begin
--   Manifest
--     TASKS BY PROJECT NUMBER PAGE11
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(58424706092454743)
,p_lov_name=>'TASKS BY PROJECT NUMBER PAGE11'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select TASK_NUMBER  Task, TASK_DESCRIPTION, COST_CENTER, FUTURE2',
'from tasks_all_v',
'where project_number = :P11_PROJECT_NUMBER_H ;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'TASK'
,p_display_column_name=>'TASK'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'TASK'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(58424319870454742)
,p_query_column_name=>'TASK'
,p_heading=>'Task'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(58423888772454741)
,p_query_column_name=>'TASK_DESCRIPTION'
,p_heading=>'Task Description'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(58423502774454736)
,p_query_column_name=>'COST_CENTER'
,p_heading=>'Cost Center'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(58423060254454736)
,p_query_column_name=>'FUTURE2'
,p_heading=>'Future2'
,p_display_sequence=>40
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
