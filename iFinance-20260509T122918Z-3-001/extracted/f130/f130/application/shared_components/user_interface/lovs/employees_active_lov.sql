prompt --application/shared_components/user_interface/lovs/employees_active_lov
begin
--   Manifest
--     EMPLOYEES ACTIVE - LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(14140835870477700)
,p_lov_name=>'EMPLOYEES ACTIVE - LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select e.full_name_en , e.email , e.employee_num, e.person_id',
'from employees_v e',
'where e.current_flag = ''Y''',
'and e.person_id > 10;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'PERSON_ID'
,p_display_column_name=>'FULL_NAME_EN'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'FULL_NAME_EN'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(14141177176492588)
,p_query_column_name=>'FULL_NAME_EN'
,p_heading=>'Full Name En'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(14141623119492589)
,p_query_column_name=>'EMAIL'
,p_heading=>'Email'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(14142020108492589)
,p_query_column_name=>'EMPLOYEE_NUM'
,p_heading=>'Employee Num'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(14142407934492589)
,p_query_column_name=>'PERSON_ID'
,p_display_sequence=>40
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.component_end;
end;
/
