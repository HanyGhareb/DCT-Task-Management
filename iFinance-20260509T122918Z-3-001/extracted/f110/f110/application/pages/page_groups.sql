prompt --application/pages/page_groups
begin
--   Manifest
--     PAGE GROUPS: 110
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>110
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(13330337995480915)
,p_group_name=>'Administration'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(18536481291491103)
,p_group_name=>'Budget Team'
,p_group_desc=>'Pages for Budget Team'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(18536567305492883)
,p_group_name=>'FBP Team'
,p_group_desc=>'FBP Team'
);
wwv_flow_api.component_end;
end;
/
