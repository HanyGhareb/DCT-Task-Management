prompt --application/shared_components/logic/application_items/is_hr_admin
begin
--   Manifest
--     APPLICATION ITEM: IS_HR_ADMIN
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_item(
 p_id=>wwv_flow_api.id(78868927010881237)
,p_name=>'IS_HR_ADMIN'
,p_scope=>'GLOBAL'
,p_protection_level=>'I'
);
wwv_flow_api.component_end;
end;
/
