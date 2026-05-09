prompt --application/pages/page_groups
begin
--   Manifest
--     PAGE GROUPS: 109
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>666
,p_default_id_offset=>90826491306730853
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(11220823410956129)
,p_group_name=>'Administration'
);
wwv_flow_api.component_end;
end;
/
