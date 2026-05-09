prompt --application/shared_components/user_interface/lovs/expenditure_types_by_page_18
begin
--   Manifest
--     EXPENDITURE TYPES BY PAGE 18
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(9936274696072813)
,p_lov_name=>'EXPENDITURE TYPES BY PAGE 18'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select EXPENDITURE_TYPE, DESCRIPTION, GL_ACCOUNT, GL_ACCOUNT_NAME',
'from expenditures_v',
'where project_number = :P18_PROJECT_NUMBER',
'and TASK_NUMBER = :P12_TASK_NUMBER_B ;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'EXPENDITURE_TYPE'
,p_display_column_name=>'EXPENDITURE_TYPE'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'EXPENDITURE_TYPE'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(9936586323072816)
,p_query_column_name=>'EXPENDITURE_TYPE'
,p_heading=>'Expenditure Type'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(9936943365072816)
,p_query_column_name=>'DESCRIPTION'
,p_heading=>'Description'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(9937384213072816)
,p_query_column_name=>'GL_ACCOUNT'
,p_heading=>'GL Account'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(9937811309072816)
,p_query_column_name=>'GL_ACCOUNT_NAME'
,p_heading=>'GL Account Name'
,p_display_sequence=>40
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
