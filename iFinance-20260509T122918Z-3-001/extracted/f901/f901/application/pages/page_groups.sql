prompt --application/pages/page_groups
begin
--   Manifest
--     PAGE GROUPS: 901
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>123
,p_default_id_offset=>6039605030667831
,p_default_owner=>'DEV'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(8145639022175568)
,p_group_name=>'Administration'
);
wwv_flow_api.component_end;
end;
/
