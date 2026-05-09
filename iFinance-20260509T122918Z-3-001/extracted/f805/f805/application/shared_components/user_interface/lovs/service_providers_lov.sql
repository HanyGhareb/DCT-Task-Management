prompt --application/shared_components/user_interface/lovs/service_providers_lov
begin
--   Manifest
--     SERVICE PROVIDERS LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>805
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(36938776442312858)
,p_lov_name=>'SERVICE PROVIDERS LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select SERVICE_PROVIDERS.FULL_NAME_EN as FULL_NAME_EN,',
'    SERVICE_PROVIDERS.SERVICE_PROVIDER_ID as SERVICE_PROVIDER_ID ',
' from SERVICE_PROVIDERS SERVICE_PROVIDERS',
' order by SERVICE_PROVIDERS.FULL_NAME_EN ASC'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'SERVICE_PROVIDER_ID'
,p_display_column_name=>'FULL_NAME_EN'
);
wwv_flow_api.component_end;
end;
/
