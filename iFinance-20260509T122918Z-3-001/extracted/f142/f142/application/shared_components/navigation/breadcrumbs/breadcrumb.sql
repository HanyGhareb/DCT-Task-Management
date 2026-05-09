prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
--   Manifest
--     MENU: Breadcrumb
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>142
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_menu(
 p_id=>wwv_flow_api.id(159808885281220038)
,p_name=>'Breadcrumb'
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(159809041282220038)
,p_short_name=>'Home'
,p_link=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.'
,p_page_id=>1
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(159983254789220221)
,p_parent_id=>wwv_flow_api.id(159809041282220038)
,p_short_name=>'Variation Requests'
,p_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:::'
,p_page_id=>2
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(160225893416220719)
,p_short_name=>'Administration'
,p_link=>'f?p=&APP_ID.:10000:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>10000
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(160296423352094620)
,p_parent_id=>wwv_flow_api.id(159809041282220038)
,p_short_name=>'VR Change Reasons'
,p_link=>'f?p=&APP_ID.:4:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>4
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(160297665312094621)
,p_parent_id=>wwv_flow_api.id(160296423352094620)
,p_short_name=>'VR Change Reason Details'
,p_link=>'f?p=&APP_ID.:5:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>5
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(160358184323609217)
,p_parent_id=>wwv_flow_api.id(159809041282220038)
,p_short_name=>'VR Estimate Basis'
,p_link=>'f?p=&APP_ID.:6:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>6
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(160359322443609219)
,p_parent_id=>wwv_flow_api.id(160358184323609217)
,p_short_name=>'VR Estimate Basis Details'
,p_link=>'f?p=&APP_ID.:7:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>7
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(160400384524975923)
,p_parent_id=>wwv_flow_api.id(159809041282220038)
,p_short_name=>'VR Funding Source'
,p_link=>'f?p=&APP_ID.:8:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>8
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(160401527832975923)
,p_parent_id=>wwv_flow_api.id(160400384524975923)
,p_short_name=>'VR Funding Source Details'
,p_link=>'f?p=&APP_ID.:9:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>9
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(160441500285213587)
,p_parent_id=>wwv_flow_api.id(159983254789220221)
,p_short_name=>'Variation Request Details'
,p_link=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:::'
,p_page_id=>3
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(193988424284269376)
,p_short_name=>'VR Request Document'
,p_link=>'f?p=&APP_ID.:10:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>10
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(194313388393456970)
,p_parent_id=>wwv_flow_api.id(159809041282220038)
,p_short_name=>'BM Evaluation Methods'
,p_link=>'f?p=&APP_ID.:13:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>13
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(194330104158466297)
,p_parent_id=>wwv_flow_api.id(194313388393456970)
,p_short_name=>'BM Evaluation Method Details'
,p_link=>'f?p=&APP_ID.:14:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>14
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(194383373908508614)
,p_parent_id=>wwv_flow_api.id(159809041282220038)
,p_short_name=>'Benchmark Forms'
,p_link=>'f?p=&APP_ID.:15:&SESSION.::&DEBUG.:::'
,p_page_id=>15
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(194384524278508616)
,p_parent_id=>wwv_flow_api.id(194383373908508614)
,p_short_name=>'Benchmark Form Details'
,p_link=>'f?p=&APP_ID.:16:&SESSION.::&DEBUG.:::'
,p_page_id=>16
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(194984306048600770)
,p_short_name=>'BM Document'
,p_link=>'f?p=&APP_ID.:18:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>18
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(208321075671618632)
,p_parent_id=>wwv_flow_api.id(159809041282220038)
,p_short_name=>'PACOF Requests'
,p_link=>'f?p=&APP_ID.:19:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>19
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(208322122111618635)
,p_parent_id=>wwv_flow_api.id(208321075671618632)
,p_short_name=>'PACOF Form Details'
,p_link=>'f?p=&APP_ID.:20:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>20
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(208574412152982279)
,p_parent_id=>wwv_flow_api.id(159809041282220038)
,p_short_name=>'VO Requests'
,p_link=>'f?p=&APP_ID.:23:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>23
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(208575688852982280)
,p_parent_id=>wwv_flow_api.id(208574412152982279)
,p_short_name=>'VO Request Details'
,p_link=>'f?p=&APP_ID.:24:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>24
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(211575986557203439)
,p_short_name=>'VR Approve&#x2F;Reject'
,p_link=>'f?p=&APP_ID.:29:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>29
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(211660265171471618)
,p_parent_id=>wwv_flow_api.id(159809041282220038)
,p_short_name=>'BM Approve&#x2F;Reject'
,p_link=>'f?p=&APP_ID.:31:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>31
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(211739568619616382)
,p_parent_id=>wwv_flow_api.id(159809041282220038)
,p_short_name=>'PACOF Approve&#x2F;Reject'
,p_link=>'f?p=&APP_ID.:32:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>32
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(211808272541653537)
,p_parent_id=>wwv_flow_api.id(159809041282220038)
,p_short_name=>'VO Approve&#x2F;Reject'
,p_link=>'f?p=&APP_ID.:33:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>33
);
wwv_flow_api.component_end;
end;
/
