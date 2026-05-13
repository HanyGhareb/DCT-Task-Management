prompt --application/shared_components/user_interface/lovs/copy_of_departments_system_lov
begin
--   Manifest
--     COPY OF DEPARTMENTS - SYSTEM LOV
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
 p_id=>wwv_flow_api.id(692497406219908)
,p_lov_name=>'COPY OF DEPARTMENTS - SYSTEM LOV'
,p_reference_id=>2484439130285402
,p_lov_query=>'Select department_id , department_name ,sector_id , sector_name from dct_hr_departments_v;'
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'DEPARTMENT_ID'
,p_display_column_name=>'DEPARTMENT_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'DEPARTMENT_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(695086666219917)
,p_query_column_name=>'DEPARTMENT_ID'
,p_display_sequence=>10
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(695535254219918)
,p_query_column_name=>'DEPARTMENT_NAME'
,p_heading=>'Department Name'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(695915117219918)
,p_query_column_name=>'SECTOR_NAME'
,p_heading=>'Sector Name'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
