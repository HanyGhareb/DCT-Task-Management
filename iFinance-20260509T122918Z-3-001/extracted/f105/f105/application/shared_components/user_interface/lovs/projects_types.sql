prompt --application/shared_components/user_interface/lovs/projects_types
begin
--   Manifest
--     PROJECTS TYPES
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
 p_id=>wwv_flow_api.id(39212809831376117)
,p_lov_name=>'PROJECTS TYPES'
,p_lov_query=>'.'||wwv_flow_api.id(39212809831376117)||'.'
,p_location=>'STATIC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(39212496491376108)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Operational'
,p_lov_return_value=>'O'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(39212169367376098)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'External'
,p_lov_return_value=>'E'
);
wwv_flow_api.component_end;
end;
/
