prompt --application/shared_components/user_interface/lovs/projects_numbers_with_name_lov
begin
--   Manifest
--     PROJECTS NUMBERS WITH NAME LOV
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
 p_id=>wwv_flow_api.id(96270869864081844)
,p_lov_name=>'PROJECTS NUMBERS WITH NAME LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''('' || PROJECT_NUMBER || '') '' || PROJECT_CODE Name, PROJECT_NUMBER',
'from(',
'select distinct  PROJECT_CODE, PROJECT_NUMBER',
'from project',
'order by PROJECT_NUMBER);'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'PROJECT_NUMBER'
,p_display_column_name=>'NAME'
,p_default_sort_column_name=>'NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
