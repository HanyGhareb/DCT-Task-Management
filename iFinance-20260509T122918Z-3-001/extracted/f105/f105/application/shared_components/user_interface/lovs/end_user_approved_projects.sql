prompt --application/shared_components/user_interface/lovs/end_user_approved_projects
begin
--   Manifest
--     END USER APPROVED PROJECTS
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
 p_id=>wwv_flow_api.id(295953409998957)
,p_lov_name=>'END USER APPROVED PROJECTS'
,p_reference_id=>94588348589832218
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
' select ENTITY_NAME ||',
'        '' - ''       ||',
'        (Select project_name',
'        from project',
'        where project.project_number = ENTITY_NAME) as project,',
'        ENTITY_NAME r',
' from BTF_DATA_ACCESS_REQUESTS',
' where REQUEST_STATUS in (''Auto-Approved'' , ''Approved'' )',
' and ENTITY_TYPE = ''PROJECT''',
' and person_id = :PERSON_ID;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'R'
,p_display_column_name=>'PROJECT'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'R'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
