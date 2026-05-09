prompt --application/shared_components/logic/application_items/get_id
begin
--   Manifest
--     APPLICATION ITEM: GET_ID
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>123
,p_default_id_offset=>6039605030667831
,p_default_owner=>'DEV'
);
wwv_flow_api.create_flow_item(
 p_id=>wwv_flow_api.id(27976118268850135)
,p_name=>'GET_ID'
,p_protection_level=>'N'
);
wwv_flow_api.component_end;
end;
/
