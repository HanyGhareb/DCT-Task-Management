prompt --application/shared_components/logic/application_items/user_groups
begin
--   Manifest
--     APPLICATION ITEM: USER_GROUPS
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_item(
 p_id=>wwv_flow_api.id(5633428877177698)
,p_name=>'USER_GROUPS'
,p_scope=>'GLOBAL'
,p_protection_level=>'I'
);
wwv_flow_api.component_end;
end;
/
