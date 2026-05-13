prompt --application/shared_components/user_interface/lovs/employees_by_username
begin
--   Manifest
--     EMPLOYEES BY USERNAME
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
 p_id=>wwv_flow_api.id(553707760878860)
,p_lov_name=>'EMPLOYEES BY USERNAME'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select user_name ,full_name_en     EMP_NAME, ',
'        employee_num ',
'from dct_bi_employees_v',
'where current_flag = ''Yes'''))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'USER_NAME'
,p_display_column_name=>'EMP_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'EMP_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(553314514880591)
,p_query_column_name=>'USER_NAME'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(552945520880592)
,p_query_column_name=>'EMP_NAME'
,p_heading=>'Emp Name'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(552585694880592)
,p_query_column_name=>'EMPLOYEE_NUM'
,p_heading=>'Employee Num'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
