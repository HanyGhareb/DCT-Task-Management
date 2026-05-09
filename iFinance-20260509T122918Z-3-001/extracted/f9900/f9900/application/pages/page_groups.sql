prompt --application/pages/page_groups
begin
--   Manifest
--     PAGE GROUPS: 9900
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>910
,p_default_id_offset=>82649548957193263
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(1689433895302375)
,p_group_name=>'Administration'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(3091245270719055)
,p_group_name=>'BT Approver'
,p_group_desc=>'Budget Transfer Approver'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(3091473366725475)
,p_group_name=>'BT Budget Planning'
,p_group_desc=>'Budget Transfer - Budget Planning'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(3091348302722427)
,p_group_name=>'BT FBP'
,p_group_desc=>'Budget Transfer - Finance Business Partners'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(3091168335716303)
,p_group_name=>'BT Users'
,p_group_desc=>'Budget Transfer Users'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(3090719986707564)
,p_group_name=>'Credit Cards Admin'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(3090835047709124)
,p_group_name=>'Credit Cards Approvers'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(3090621198705779)
,p_group_name=>'Credit Cards User'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(3090094324697197)
,p_group_name=>'HR '
,p_group_desc=>'All Pages related to HR data'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(3090420345702575)
,p_group_name=>'Petty Cash AP'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(3090108641699026)
,p_group_name=>'Petty Cash Admin'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(3090325865701608)
,p_group_name=>'Petty Cash Approver'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(3090511315703811)
,p_group_name=>'Petty Cash Treasury'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(3090217992700238)
,p_group_name=>'Petty Cash User'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(3091049876711989)
,p_group_name=>'Prepaid Card Admin'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(3090923642710763)
,p_group_name=>'Prepaid Card User'
);
wwv_flow_api.component_end;
end;
/
