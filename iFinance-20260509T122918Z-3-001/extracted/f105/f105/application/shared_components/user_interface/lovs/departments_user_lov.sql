prompt --application/shared_components/user_interface/lovs/departments_user_lov
begin
--   Manifest
--     DEPARTMENTS - USER LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(2018187183424363)
,p_lov_name=>'DEPARTMENTS - USER LOV'
,p_lov_query=>'Select department_id , department_name_user ,sector_id , sector_name_user from dct_hr_departments_v;'
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'DEPARTMENT_ID'
,p_display_column_name=>'DEPARTMENT_NAME_USER'
,p_default_sort_column_name=>'DEPARTMENT_NAME_USER'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
