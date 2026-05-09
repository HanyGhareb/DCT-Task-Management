prompt --application/shared_components/logic/application_items/is_souceing_manager
begin
--   Manifest
--     APPLICATION ITEM: IS_SOUCEING_MANAGER
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>500
,p_default_id_offset=>354480484490134169
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_item(
 p_id=>wwv_flow_api.id(52296108800549142)
,p_name=>'IS_SOUCEING_MANAGER'
,p_protection_level=>'I'
,p_item_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'to identify the logged-in  user having Sourcing manager role DCT_DATA_ACCESS_ASSIGNMENT',
'where entity_id = 30    -- 30 for SOURCING_MANAGER Role'))
);
wwv_flow_api.component_end;
end;
/
