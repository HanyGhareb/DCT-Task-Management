prompt --application/shared_components/user_interface/lovs/expenditure_by_p6_project_and_p6_task_lov
begin
--   Manifest
--     EXPENDITURE BY P6_PROJECT AND P6_TASK LOV
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
 p_id=>wwv_flow_api.id(36887070048531481)
,p_lov_name=>'EXPENDITURE BY P6_PROJECT AND P6_TASK LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select description , ',
'        description d,',
'        gl_account,',
'        GL_ACCOUNT_DESCRIPTION',
'from expenditure',
'where project_number = nvl(:P6_PROJECT_NUMBER , :P10_PROJECT_NUMBER)',
'and task_number = nvl(:P6_TASK_NUMBER , :P10_TASK_NUMBER)',
'order by 1'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'D'
,p_display_column_name=>'DESCRIPTION'
,p_group_sort_direction=>'ASC'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(36887492215529227)
,p_query_column_name=>'D'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(36887842458529226)
,p_query_column_name=>'DESCRIPTION'
,p_heading=>'Description'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(36888224975529226)
,p_query_column_name=>'GL_ACCOUNT'
,p_heading=>'Gl Account'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(36888614006529226)
,p_query_column_name=>'GL_ACCOUNT_DESCRIPTION'
,p_heading=>'Gl Account Description'
,p_display_sequence=>40
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
