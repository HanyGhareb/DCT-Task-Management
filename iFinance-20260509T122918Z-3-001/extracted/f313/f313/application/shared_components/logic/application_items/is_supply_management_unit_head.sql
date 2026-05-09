prompt --application/shared_components/logic/application_items/is_supply_management_unit_head
begin
--   Manifest
--     APPLICATION ITEM: IS_SUPPLY_MANAGEMENT_UNIT_HEAD
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>120
,p_default_id_offset=>145171879539529295
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_item(
 p_id=>wwv_flow_api.id(2587316980072257)
,p_name=>'IS_SUPPLY_MANAGEMENT_UNIT_HEAD'
,p_protection_level=>'I'
,p_item_comment=>'to identify the user has Supply Management Unit Heads Role (Role_ID = 31) '
);
wwv_flow_api.component_end;
end;
/
