prompt --application/shared_components/user_interface/lovs/projects_by_departments
begin
--   Manifest
--     PROJECTS BY DEPARTMENTS
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>123
,p_default_id_offset=>6039605030667831
,p_default_owner=>'DEV'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(8263424342632679)
,p_lov_name=>'PROJECTS BY DEPARTMENTS'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct F_PROJECTBUDGET.PROJECT_NUMBER as PROJECT_NUMBER,',
'    F_PROJECTBUDGET.PROJECT_NAME as PROJECT_NAME    ,    ',
'    F_PROJECTBUDGET.DEPARTMENT as DEPARTMENT,',
'    F_PROJECTBUDGET.TCA_SECTOR as      SECTOR ',
'    ,F_PROJECTBUDGET.DEPARTMENT as DEPARTMENT_d',
' from F_PROJECTBUDGET F_PROJECTBUDGET'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'PROJECT_NUMBER'
,p_display_column_name=>'PROJECT_NUMBER'
,p_group_column_name=>'DEPARTMENT_D'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'PROJECT_NUMBER'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(8263868920636593)
,p_query_column_name=>'PROJECT_NUMBER'
,p_heading=>'Project Name'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(8276337808690555)
,p_query_column_name=>'PROJECT_NAME'
,p_heading=>'Project Name'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(8290536531733886)
,p_query_column_name=>'DEPARTMENT_D'
,p_heading=>'Department D'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(8276724921690555)
,p_query_column_name=>'DEPARTMENT'
,p_heading=>'Department'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(8277145711690555)
,p_query_column_name=>'SECTOR'
,p_heading=>'Sector'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
