prompt --application/shared_components/user_interface/lovs/employees_list
begin
--   Manifest
--     EMPLOYEES LIST
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>118
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(157182907217903192)
,p_lov_name=>'EMPLOYEES LIST'
,p_lov_query=>'select Full_name_en , person_id from employees_v'
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'PERSON_ID'
,p_display_column_name=>'FULL_NAME_EN'
,p_default_sort_column_name=>'FULL_NAME_EN'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
