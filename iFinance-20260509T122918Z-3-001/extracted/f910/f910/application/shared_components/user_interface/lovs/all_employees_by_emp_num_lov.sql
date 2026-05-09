prompt --application/shared_components/user_interface/lovs/all_employees_by_emp_num_lov
begin
--   Manifest
--     ALL EMPLOYEES BY EMP NUM LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>100
,p_default_id_offset=>40620729557075005
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(3135783254658317)
,p_lov_name=>'ALL EMPLOYEES BY EMP NUM LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en ',
'    , employee_num',
'from dct_employees_list2'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'EMPLOYEE_NUM'
,p_display_column_name=>'FULL_NAME_EN'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'FULL_NAME_EN'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(3137434877674103)
,p_query_column_name=>'EMPLOYEE_NUM'
,p_heading=>'Employee Num'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(3137860020674103)
,p_query_column_name=>'FULL_NAME_EN'
,p_heading=>'Name'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
