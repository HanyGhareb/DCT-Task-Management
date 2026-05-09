prompt --application/shared_components/logic/application_items/current_year
begin
--   Manifest
--     APPLICATION ITEM: CURRENT_YEAR
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_item(
 p_id=>wwv_flow_api.id(128382937437111776)
,p_name=>'CURRENT_YEAR'
,p_protection_level=>'I'
);
wwv_flow_api.component_end;
end;
/
