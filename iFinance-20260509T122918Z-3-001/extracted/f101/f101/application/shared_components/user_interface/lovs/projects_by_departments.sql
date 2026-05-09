prompt --application/shared_components/user_interface/lovs/projects_by_departments
begin
--   Manifest
--     PROJECTS BY DEPARTMENTS
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
 p_id=>wwv_flow_api.id(8263424342632679)
,p_lov_name=>'PROJECTS BY DEPARTMENTS'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct p.PROJECT_NUMBER as PROJECT_NUMBER,',
'PROJECTS_UTIL.project_name(PROJECT_NUMBER) project_name',
'--    p.PROJECT_NUMBER as PROJECT_NUM',
'--    p.  as PROJECT_NAME    ',
'   -- F_PROJECTBUDGET.DEPARTMENT as DEPARTMENT,',
'--    F_PROJECTBUDGET.TCA_SECTOR as      SECTOR ',
'--    ,F_PROJECTBUDGET.DEPARTMENT as DEPARTMENT_d',
' from project_balances_v p  '))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'PROJECT_NUMBER'
,p_display_column_name=>'PROJECT_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'PROJECT_NUMBER'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(8263868920636593)
,p_query_column_name=>'PROJECT_NUMBER'
,p_heading=>'Project Number'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(8276337808690555)
,p_query_column_name=>'PROJECT_NAME'
,p_heading=>'Project Name'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
