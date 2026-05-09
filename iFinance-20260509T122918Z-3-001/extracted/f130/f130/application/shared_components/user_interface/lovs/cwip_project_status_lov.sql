prompt --application/shared_components/user_interface/lovs/cwip_project_status_lov
begin
--   Manifest
--     CWIP PROJECT STATUS LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(84325464982007247)
,p_lov_name=>'CWIP PROJECT STATUS LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CWIP_PROJECT_STATUS_LOOKUP.CWIP_PROJECT_STATUS as CWIP_PROJECT_STATUS,',
'    CWIP_PROJECT_STATUS_LOOKUP.CWIP_PROJECT_STATUS_ID as CWIP_PROJECT_STATUS_ID ',
' from CWIP_PROJECT_STATUS_LOOKUP CWIP_PROJECT_STATUS_LOOKUP'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'CWIP_PROJECT_STATUS_ID'
,p_display_column_name=>'CWIP_PROJECT_STATUS'
,p_default_sort_column_name=>'CWIP_PROJECT_STATUS'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
