prompt --application/shared_components/logic/application_items/emp_name
begin
--   Manifest
--     APPLICATION ITEM: EMP_NAME
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
 p_id=>wwv_flow_api.id(29266520016267381)
,p_name=>'EMP_NAME'
,p_protection_level=>'I'
);
wwv_flow_api.component_end;
end;
/
