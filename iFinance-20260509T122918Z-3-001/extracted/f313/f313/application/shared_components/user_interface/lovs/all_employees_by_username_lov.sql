prompt --application/shared_components/user_interface/lovs/all_employees_by_username_lov
begin
--   Manifest
--     ALL EMPLOYEES BY USERNAME LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>120
,p_default_id_offset=>145171879539529295
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(85693101902892527)
,p_lov_name=>'ALL EMPLOYEES BY USERNAME LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select e.full_name_en , e.user_name , e.employee_num , person_id',
'from employees_v e    ',
'where current_flag = ''Y'' '))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'USER_NAME'
,p_display_column_name=>'FULL_NAME_EN'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'FULL_NAME_EN'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(85693517366892526)
,p_query_column_name=>'EMPLOYEE_NUM'
,p_heading=>'Employee Num'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(85693863048892526)
,p_query_column_name=>'USER_NAME'
,p_heading=>'User Name'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(85694285736892525)
,p_query_column_name=>'PERSON_ID'
,p_heading=>'Person Id'
,p_display_sequence=>10
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(85694648110892525)
,p_query_column_name=>'FULL_NAME_EN'
,p_heading=>'Name'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
