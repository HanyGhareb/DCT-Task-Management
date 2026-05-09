prompt --application/shared_components/logic/application_items/director_num
begin
--   Manifest
--     APPLICATION ITEM: DIRECTOR_NUM
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
 p_id=>wwv_flow_api.id(8965376436876711)
,p_name=>'DIRECTOR_NUM'
,p_scope=>'GLOBAL'
,p_protection_level=>'I'
,p_item_comment=>'Director Number of the logged in user'
);
wwv_flow_api.component_end;
end;
/
