prompt --application/shared_components/user_interface/lovs/service_agreement_number_by_id_lov
begin
--   Manifest
--     SERVICE AGREEMENT NUMBER BY ID LOV
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
 p_id=>wwv_flow_api.id(37176643717106828)
,p_lov_name=>'SERVICE AGREEMENT NUMBER BY ID LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select SERVICE_PROVIDERS_AGREEMENTS.SERVICE_AGREEMENT_NUM as SERVICE_AGREEMENT_NUM,',
'    SERVICE_PROVIDERS_AGREEMENTS.SERVICE_AGREEMENT_ID as SERVICE_AGREEMENT_ID ',
' from SERVICE_PROVIDERS_AGREEMENTS SERVICE_PROVIDERS_AGREEMENTS'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'SERVICE_AGREEMENT_ID'
,p_display_column_name=>'SERVICE_AGREEMENT_NUM'
,p_default_sort_column_name=>'SERVICE_AGREEMENT_NUM'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
