prompt --application/shared_components/user_interface/lovs/task_by_projects_page90
begin
--   Manifest
--     TASK BY PROJECTS PAGE90
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(31500261832431127)
,p_lov_name=>'TASK BY PROJECTS PAGE90'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct  F_PROJECTBUDGET.TASK_NUMBER as TASK_NUMBER',
'    ,F_PROJECTBUDGET.TASK_NUMBER as TASK    ',
' --   F_PROJECTBUDGET.ACCOUNT_NAME as ACCOUNT_NAME,',
' --   F_PROJECTBUDGET.NATURAL_ACCOUNT as NATURAL_ACCOUNT ',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where project_number = :P90_PROJECT_NUMBER'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'TASK'
,p_display_column_name=>'TASK_NUMBER'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'TASK_NUMBER'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(31499935881431131)
,p_query_column_name=>'TASK_NUMBER'
,p_heading=>'Task Number'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(31499585802431131)
,p_query_column_name=>'TASK'
,p_heading=>'Task'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.component_end;
end;
/
