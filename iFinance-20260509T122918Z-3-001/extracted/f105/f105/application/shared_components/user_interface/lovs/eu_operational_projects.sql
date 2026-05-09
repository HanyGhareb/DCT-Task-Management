prompt --application/shared_components/user_interface/lovs/eu_operational_projects
begin
--   Manifest
--     EU OPERATIONAL PROJECTS
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
 p_id=>wwv_flow_api.id(95352355845856)
,p_lov_name=>'EU OPERATIONAL PROJECTS'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select p.PROJECT_NUMBER || '' - '' || p.PROJECT_NAME  PROJECT_NAME , p.project_number ',
'from project p',
'where 1=1',
'--and p.PROJECT_TYPE = ''Operational''',
'and p.project_number not in (select bt.ENTITY_NAME from BTF_DATA_ACCESS_REQUESTS bt where bt.ENTITY_TYPE = ''PROJECT'' and bt.PERSON_ID = :PERSON_ID and bt.REQUEST_STATUS = ''in-Progress'')'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'PROJECT_NUMBER'
,p_display_column_name=>'PROJECT_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'PROJECT_NUMBER'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
