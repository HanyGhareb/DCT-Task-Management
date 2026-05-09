prompt --application/shared_components/user_interface/lovs/employees_details_return_personid_popup
begin
--   Manifest
--     EMPLOYEES DETAILS  RETURN PERSONID- POPUP
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>805
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(181755193271897536)
,p_lov_name=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'PERSON_ID'
,p_display_column_name=>'FULL_NAME_EN'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'FULL_NAME_EN'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(181755451034897537)
,p_query_column_name=>'PERSON_ID'
,p_display_sequence=>10
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(181755838664897537)
,p_query_column_name=>'FULL_NAME_EN'
,p_heading=>'Name'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(181756285935897537)
,p_query_column_name=>'EMPLOYEE_NUM'
,p_heading=>'Employee No'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(181756678807897537)
,p_query_column_name=>'EMAIL'
,p_heading=>'Email'
,p_display_sequence=>40
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(181757058473897537)
,p_query_column_name=>'DEPARTMENT_NAME'
,p_heading=>'Department'
,p_display_sequence=>50
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
