prompt --application/shared_components/user_interface/lovs/person_details_lov
begin
--   Manifest
--     PERSON DETAILS LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>116806299474925354
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(24146885424244788)
,p_lov_name=>'PERSON DETAILS LOV'
,p_reference_id=>43319714799400179
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select e.employee_num || ''-'' || e.full_name_en  emp_name , e.person_id , e.org_id, e.department_name',
'        , e.sector ',
'        , e.department_id',
'        , e.sector_id',
'        , (select s.short_name_en',
'            from dct_hr_organizations s',
'            where s.org_id = e.sector_id) sector_code',
'        , cost_center_code    ',
'        , e.email',
'        , e.mobile',
'        , e.position',
'        , e.position_id',
'        , e.employee_num',
'        ,e.nationality_id',
'from employees_v e',
'where current_flag = ''Y'' ',
'ORDER BY employee_num;    '))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'PERSON_ID'
,p_display_column_name=>'EMP_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'EMP_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(24602091047971535)
,p_query_column_name=>'NATIONALITY_ID'
,p_heading=>'Nationality Id'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(24200140567609916)
,p_query_column_name=>'PERSON_ID'
,p_display_sequence=>10
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(24249696437321608)
,p_query_column_name=>'EMAIL'
,p_heading=>'Email'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(24264547987089867)
,p_query_column_name=>'EMPLOYEE_NUM'
,p_heading=>'Employee Num'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(24200567445609916)
,p_query_column_name=>'EMP_NAME'
,p_heading=>'Emp Name'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(24250004661321608)
,p_query_column_name=>'MOBILE'
,p_heading=>'Mobile'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(24200937886609915)
,p_query_column_name=>'ORG_ID'
,p_heading=>'Org Id'
,p_display_sequence=>30
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(24250440620321608)
,p_query_column_name=>'POSITION_ID'
,p_heading=>'Position Id'
,p_display_sequence=>30
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(24201343138609915)
,p_query_column_name=>'DEPARTMENT_NAME'
,p_heading=>'Department Name'
,p_display_sequence=>40
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(24201708715609915)
,p_query_column_name=>'SECTOR'
,p_heading=>'Sector'
,p_display_sequence=>50
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(24202136231609915)
,p_query_column_name=>'POSITION'
,p_heading=>'Position'
,p_display_sequence=>60
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(24202535019609915)
,p_query_column_name=>'DEPARTMENT_ID'
,p_heading=>'Department Id'
,p_display_sequence=>70
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(24202993224609914)
,p_query_column_name=>'SECTOR_ID'
,p_heading=>'Sector Id'
,p_display_sequence=>80
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(24203352527609914)
,p_query_column_name=>'SECTOR_CODE'
,p_heading=>'Sector Code'
,p_display_sequence=>90
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(24203728540609914)
,p_query_column_name=>'COST_CENTER_CODE'
,p_heading=>'Cost Center Code'
,p_display_sequence=>100
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
);
wwv_flow_api.component_end;
end;
/
