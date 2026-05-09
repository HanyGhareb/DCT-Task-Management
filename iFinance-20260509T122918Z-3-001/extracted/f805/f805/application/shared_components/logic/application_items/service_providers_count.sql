prompt --application/shared_components/logic/application_items/service_providers_count
begin
--   Manifest
--     APPLICATION ITEM: SERVICE_PROVIDERS_COUNT
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>805
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_item(
 p_id=>wwv_flow_api.id(36805786119760033)
,p_name=>'SERVICE_PROVIDERS_COUNT'
,p_protection_level=>'I'
);
wwv_flow_api.component_end;
end;
/
