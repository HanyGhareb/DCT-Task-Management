prompt --application/shared_components/user_interface/lovs/persons_details_lov
begin
--   Manifest
--     Persons Details LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(20693921719307411)
,p_lov_name=>'Persons Details LOV'
,p_reference_id=>19655278934130961
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select e.employee_num || ''-'' || e.full_name_en  emp_name , e.person_id , e.org_id, e.department_name',
'        , e.sector , e.position ',
'        , e.department_id',
'        , e.sector_id',
'        , (select s.short_name_en',
'            from dct_hr_organizations s',
'            where s.org_id = e.sector_id) sector_code',
'from employees_v e',
'where current_flag = ''Y'' ',
'ORDER BY employee_num;    '))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'PERSON_ID'
,p_display_column_name=>'EMP_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(20701149200307416)
,p_query_column_name=>'SECTOR_ID'
,p_heading=>'Sector Id'
,p_display_sequence=>10
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(20702370691307417)
,p_query_column_name=>'EMP_NAME'
,p_heading=>'Name'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(20701588940307416)
,p_query_column_name=>'DEPARTMENT_ID'
,p_heading=>'Department Id'
,p_display_sequence=>20
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(20703177021307417)
,p_query_column_name=>'DEPARTMENT_NAME'
,p_heading=>'Department'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(20702722569307417)
,p_query_column_name=>'POSITION'
,p_heading=>'Position'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(20703517751307417)
,p_query_column_name=>'SECTOR'
,p_heading=>'Sector'
,p_display_sequence=>40
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(20703931824307418)
,p_query_column_name=>'SECTOR_CODE'
,p_heading=>'Sector Code'
,p_display_sequence=>50
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(20700799469307416)
,p_query_column_name=>'ORG_ID'
,p_heading=>'Org Id'
,p_display_sequence=>60
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(20701978731307417)
,p_query_column_name=>'PERSON_ID'
,p_display_sequence=>70
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.component_end;
end;
/
