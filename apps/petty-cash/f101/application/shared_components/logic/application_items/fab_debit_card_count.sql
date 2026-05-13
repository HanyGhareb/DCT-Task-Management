prompt --application/shared_components/logic/application_items/fab_debit_card_count
begin
--   Manifest
--     APPLICATION ITEM: FAB_DEBIT_CARD_COUNT
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_item(
 p_id=>wwv_flow_api.id(335533005914941)
,p_name=>'FAB_DEBIT_CARD_COUNT'
,p_protection_level=>'I'
,p_item_comment=>'FAB DEBIT CARD Vendors Count'
);
wwv_flow_api.component_end;
end;
/
