prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
--   Manifest
--     MENU: Breadcrumb
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>500
,p_default_id_offset=>354480484490134169
,p_default_owner=>'PROD'
);
wwv_flow_api.create_menu(
 p_id=>wwv_flow_api.id(19140599913383303)
,p_name=>'Breadcrumb'
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(52084764782824373)
,p_parent_id=>wwv_flow_api.id(19140750053383303)
,p_short_name=>'Manual PR Approve &#x2F; Reject'
,p_link=>'f?p=&APP_ID.:39:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>39
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(24299390210022293)
,p_parent_id=>wwv_flow_api.id(19140750053383303)
,p_short_name=>'MPR Dashboard'
,p_link=>'f?p=&APP_ID.:14:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>14
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(4794159427002898)
,p_parent_id=>wwv_flow_api.id(19140750053383303)
,p_short_name=>'Pending PRs Reminder'
,p_link=>'f?p=&APP_ID.:16:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>16
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(4572208744965456)
,p_parent_id=>wwv_flow_api.id(19140750053383303)
,p_short_name=>'Pending PRs Data Loading'
,p_link=>'f?p=&APP_ID.:17:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>17
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(4538479598965442)
,p_parent_id=>wwv_flow_api.id(19140750053383303)
,p_short_name=>'Pending PRs Data Loading'
,p_link=>'f?p=&APP_ID.:18:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>18
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(4534274134965441)
,p_parent_id=>wwv_flow_api.id(19140750053383303)
,p_short_name=>'Pending PRs Data Loading'
,p_link=>'f?p=&APP_ID.:19:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>19
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(4511369810965429)
,p_parent_id=>wwv_flow_api.id(19140750053383303)
,p_short_name=>'Pending PRs Data Loading'
,p_link=>'f?p=&APP_ID.:20:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>20
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(4403569489696728)
,p_parent_id=>wwv_flow_api.id(19140750053383303)
,p_short_name=>'Pending POs Reminder'
,p_link=>'f?p=&APP_ID.:21:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>21
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(3863267897265172)
,p_short_name=>'Pending POs Data Loading'
,p_link=>'f?p=&APP_ID.:22:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>22
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(3844051807265156)
,p_short_name=>'Pending POs Data Loading'
,p_link=>'f?p=&APP_ID.:23:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>23
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(3839836110265154)
,p_short_name=>'Pending POs Data Loading'
,p_link=>'f?p=&APP_ID.:24:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>24
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(3817037023265137)
,p_short_name=>'Pending POs Data Loading'
,p_link=>'f?p=&APP_ID.:25:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>25
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(2259561224834785)
,p_parent_id=>wwv_flow_api.id(19140750053383303)
,p_short_name=>'Pending AP GRN - Report'
,p_link=>'f?p=&APP_ID.:26:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>26
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(2258375874834783)
,p_parent_id=>wwv_flow_api.id(2259561224834785)
,p_short_name=>'Pending AP GRN - Details'
,p_link=>'f?p=&APP_ID.:27:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>27
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(2231608672471760)
,p_parent_id=>wwv_flow_api.id(2259561224834785)
,p_short_name=>'Loading GRN'
,p_link=>'f?p=&APP_ID.:28:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>28
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(2212370798471744)
,p_parent_id=>wwv_flow_api.id(2259561224834785)
,p_short_name=>'Loading GRN'
,p_link=>'f?p=&APP_ID.:29:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>29
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(2208318757471741)
,p_parent_id=>wwv_flow_api.id(2259561224834785)
,p_short_name=>'Loading GRN'
,p_link=>'f?p=&APP_ID.:30:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>30
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(2185355737471726)
,p_parent_id=>wwv_flow_api.id(2259561224834785)
,p_short_name=>'Loading GRN'
,p_link=>'f?p=&APP_ID.:31:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>31
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(2115429791372961)
,p_parent_id=>wwv_flow_api.id(2259561224834785)
,p_short_name=>'Pending GRN Documents'
,p_link=>'f?p=&APP_ID.:32:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>32
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(2114266211372961)
,p_parent_id=>wwv_flow_api.id(2115429791372961)
,p_short_name=>'GRN Document Details'
,p_link=>'f?p=&APP_ID.:33:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>33
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(19140750053383303)
,p_short_name=>'Home'
,p_link=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.'
,p_page_id=>1
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(19307718314473476)
,p_parent_id=>wwv_flow_api.id(19140750053383303)
,p_short_name=>'MPR Details'
,p_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:::'
,p_page_id=>2
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(19528625366708972)
,p_parent_id=>wwv_flow_api.id(19140750053383303)
,p_short_name=>'Procurement Methods'
,p_link=>'f?p=&APP_ID.:3:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>3
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(20154190686679835)
,p_parent_id=>wwv_flow_api.id(19307718314473476)
,p_short_name=>'Manual PR document'
,p_link=>'f?p=&APP_ID.:4:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>4
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(20572237501606514)
,p_parent_id=>wwv_flow_api.id(19140750053383303)
,p_short_name=>'MPR Approve &#x2F; Reject'
,p_link=>'f?p=&APP_ID.:6:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>6
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(22702960144598585)
,p_parent_id=>wwv_flow_api.id(19140750053383303)
,p_short_name=>'Procurement Business Partners'
,p_link=>'f?p=&APP_ID.:8:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>8
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(22719592254692139)
,p_parent_id=>wwv_flow_api.id(19140750053383303)
,p_short_name=>'Digital Transformation Business Partners By Cost Center'
,p_link=>'f?p=&APP_ID.:9:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>9
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(22757158003954731)
,p_parent_id=>wwv_flow_api.id(19140750053383303)
,p_short_name=>'Manual PR Invitation'
,p_link=>'f?p=&APP_ID.:10:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>10
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(23022465141231514)
,p_parent_id=>wwv_flow_api.id(19140750053383303)
,p_short_name=>'Manage Finance Business Partners'
,p_link=>'f?p=&APP_ID.:12:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>12
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(23163175806113670)
,p_short_name=>'Administration'
,p_link=>'f?p=&APP_ID.:10000:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>10000
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(26093627110987684)
,p_short_name=>'MPR Delegation Requests'
,p_link=>'f?p=&APP_ID.:13:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>13
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(56727592936755098)
,p_parent_id=>wwv_flow_api.id(19140750053383303)
,p_short_name=>'Employees Messages'
,p_link=>'f?p=&APP_ID.:36:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>36
);
wwv_flow_api.component_end;
end;
/
