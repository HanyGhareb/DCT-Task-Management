prompt --application/shared_components/user_interface/lovs/roles_lov
begin
--   Manifest
--     ROLES LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(109816436157935965)
,p_lov_name=>'ROLES LOV'
,p_reference_id=>213865769878889467
,p_lov_query=>'select ROLE_NAME , ROLE_ID from roles ;'
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'ROLE_ID'
,p_display_column_name=>'ROLE_NAME'
,p_default_sort_column_name=>'ROLE_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
