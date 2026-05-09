prompt --application/pages/page_groups
begin
--   Manifest
--     PAGE GROUPS: 903
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>114
,p_default_id_offset=>9604171250607172
,p_default_owner=>'DEV'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(65629592280255855)
,p_group_name=>'Administration'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(77187075407914321)
,p_group_name=>'BTR Approves'
,p_group_desc=>'Budget Transfer Requests for approvers'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(77187205096918219)
,p_group_name=>'Budget Planning'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(77187172611916660)
,p_group_name=>'FBP '
,p_group_desc=>'Finance Business Partners '
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(77187448920924564)
,p_group_name=>'FBP  - Budget Planning'
,p_group_desc=>'Finance Business Partners and Budget Planning'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(77186981718909083)
,p_group_name=>'Projects EU'
,p_group_desc=>'Projects End Users Pages'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(77187657467935694)
,p_group_name=>'Public Not Authorized'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(77187794511938740)
,p_group_name=>'Public without roles'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(77187501740932565)
,p_group_name=>'Shared (Without EU)'
,p_group_desc=>'Shared between all except Project End Users'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(77187365871920160)
,p_group_name=>'Sys Admin'
,p_group_desc=>'SysAdmin'
);
wwv_flow_api.component_end;
end;
/
