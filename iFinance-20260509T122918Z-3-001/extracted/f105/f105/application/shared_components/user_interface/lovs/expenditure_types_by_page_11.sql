prompt --application/shared_components/user_interface/lovs/expenditure_types_by_page_11
begin
--   Manifest
--     EXPENDITURE TYPES BY PAGE 11
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
 p_id=>wwv_flow_api.id(58422495198454733)
,p_lov_name=>'EXPENDITURE TYPES BY PAGE 11'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select EXPENDITURE_TYPE, DESCRIPTION, GL_ACCOUNT, GL_ACCOUNT_NAME',
'from expenditures_v',
'where project_number = :P11_PROJECT_NUMBER_H',
'and TASK_NUMBER = :P11_TASK_NUMBER ;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'EXPENDITURE_TYPE'
,p_display_column_name=>'EXPENDITURE_TYPE'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'EXPENDITURE_TYPE'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(58422085106454733)
,p_query_column_name=>'EXPENDITURE_TYPE'
,p_heading=>'Expenditure Type'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(58421666136454732)
,p_query_column_name=>'DESCRIPTION'
,p_heading=>'Description'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(58421243879454732)
,p_query_column_name=>'GL_ACCOUNT'
,p_heading=>'GL Account'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(58420906139454732)
,p_query_column_name=>'GL_ACCOUNT_NAME'
,p_heading=>'GL Account Name'
,p_display_sequence=>40
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
