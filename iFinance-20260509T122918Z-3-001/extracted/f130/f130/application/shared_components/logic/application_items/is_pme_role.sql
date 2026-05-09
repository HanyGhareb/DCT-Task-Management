prompt --application/shared_components/logic/application_items/is_pme_role
begin
--   Manifest
--     APPLICATION ITEM: IS_PME_ROLE
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_item(
 p_id=>wwv_flow_api.id(99760076678828734)
,p_name=>'IS_PME_ROLE'
,p_protection_level=>'I'
);
wwv_flow_api.component_end;
end;
/
