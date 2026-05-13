prompt --application/shared_components/user_interface/lovs/employees_all_lov
begin
--   Manifest
--     EMPLOYEES ALL LOV
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
 p_id=>wwv_flow_api.id(689921966178335)
,p_lov_name=>'EMPLOYEES ALL LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select full_name_en     EMP_NAME, ',
'        employee_num ',
'from dct_bi_employees_v',
'where current_flag = ''Yes'''))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'EMPLOYEE_NUM'
,p_display_column_name=>'EMP_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'EMP_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(4039495443997221)
,p_query_column_name=>'EMPLOYEE_NUM'
,p_heading=>'Employee Number'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(4039877146997222)
,p_query_column_name=>'EMP_NAME'
,p_heading=>'Emp Name'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
