prompt --application/shared_components/user_interface/lovs/manual_employee_num_lov
begin
--   Manifest
--     MANUAL-EMPLOYEE NUM LOV
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
 p_id=>wwv_flow_api.id(18063822912016761)
,p_lov_name=>'MANUAL-EMPLOYEE NUM LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select employee_num d, ',
'        employee_num r,',
'        org_id ,',
'        org_name,',
'        full_name_en',
'from employees_v',
'where current_flag = ''Y''',
'order by 1'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'R'
,p_display_column_name=>'D'
,p_group_sort_direction=>'ASC'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(18064313060019015)
,p_query_column_name=>'R'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(18064706561019015)
,p_query_column_name=>'D'
,p_heading=>'D'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(18065152688019015)
,p_query_column_name=>'ORG_ID'
,p_heading=>'Org Id'
,p_display_sequence=>30
,p_data_type=>'NUMBER'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(18065470047019016)
,p_query_column_name=>'ORG_NAME'
,p_heading=>'Org Name'
,p_display_sequence=>40
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(18065896710019016)
,p_query_column_name=>'FULL_NAME_EN'
,p_heading=>'Full Name En'
,p_display_sequence=>50
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
