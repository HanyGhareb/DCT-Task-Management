prompt --application/shared_components/user_interface/lovs/projects_lov
begin
--   Manifest
--     PROJECTS LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>219773596381898043
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(116781569792801712)
,p_lov_name=>'PROJECTS LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct PROJECT_NUMBER || '' ('' ||  PROJECT_NAME || '')'' project_name , PROJECT_NUMBER',
'from project',
'where PROJECT_TYPE in (''Operational'' , ''Non GL Integrated'') ',
'order by 1;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'PROJECT_NUMBER'
,p_display_column_name=>'PROJECT_NAME'
);
wwv_flow_api.component_end;
end;
/
