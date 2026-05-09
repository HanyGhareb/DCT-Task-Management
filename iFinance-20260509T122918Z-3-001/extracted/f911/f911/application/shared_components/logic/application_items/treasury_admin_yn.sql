prompt --application/shared_components/logic/application_items/treasury_admin_yn
begin
--   Manifest
--     APPLICATION ITEM: TREASURY_ADMIN_YN
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>219773596381898043
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_item(
 p_id=>wwv_flow_api.id(34826894531091427)
,p_name=>'TREASURY_ADMIN_YN'
,p_protection_level=>'I'
,p_item_comment=>'if Y, Then logged-in user is Treasury Admin'
);
wwv_flow_api.component_end;
end;
/
