prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
--   Manifest
--     MENU: Breadcrumb
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_menu(
 p_id=>wwv_flow_api.id(127749711524449850)
,p_name=>'Breadcrumb'
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(517496691970343324)
,p_parent_id=>wwv_flow_api.id(127749924599449850)
,p_short_name=>'Demand Plan Item Details'
,p_link=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.:::'
,p_page_id=>10
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(138345829275572713)
,p_parent_id=>wwv_flow_api.id(129655618524783317)
,p_short_name=>'User Roles'
,p_link=>'f?p=&APP_ID.:79:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>79
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(138344709218572712)
,p_parent_id=>wwv_flow_api.id(138345829275572713)
,p_short_name=>'User Role Details'
,p_link=>'f?p=&APP_ID.:80:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>80
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(122809797757653593)
,p_parent_id=>wwv_flow_api.id(127749924599449850)
,p_short_name=>'DP Items Status'
,p_link=>'f?p=&APP_ID.:82:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>82
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(122808538145653590)
,p_parent_id=>wwv_flow_api.id(122809797757653593)
,p_short_name=>'DP Item Status Details'
,p_link=>'f?p=&APP_ID.:83:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>83
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(112466605181793790)
,p_parent_id=>wwv_flow_api.id(127919581134449620)
,p_short_name=>'Delegation Management'
,p_link=>'f?p=&APP_ID.:88:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>88
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(111704676728878050)
,p_parent_id=>wwv_flow_api.id(112466605181793790)
,p_short_name=>'Configure Workflow'
,p_link=>'f?p=&APP_ID.:87:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>87
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(1757456319987443)
,p_parent_id=>wwv_flow_api.id(136825595101989436)
,p_short_name=>'Scoping document Attachment Template '
,p_link=>'f?p=&APP_ID.:60:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>60
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(1870057497684166)
,p_parent_id=>wwv_flow_api.id(127749924599449850)
,p_short_name=>'DP Procurement Methods'
,p_link=>'f?p=&APP_ID.:61:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>61
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(1871312385684167)
,p_parent_id=>wwv_flow_api.id(1870057497684166)
,p_short_name=>'DP Procurement Methods Details'
,p_link=>'f?p=&APP_ID.:62:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>62
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(1884782163788308)
,p_parent_id=>wwv_flow_api.id(1757456319987443)
,p_short_name=>'Procurement Method: (&P63_TYPE_NAME.) Amounts Range '
,p_link=>'f?p=&APP_ID.:63:&SESSION.::&DEBUG.:::'
,p_page_id=>63
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(2310853783580413)
,p_parent_id=>wwv_flow_api.id(127749924599449850)
,p_short_name=>'DP Scoping Documents Home Page '
,p_link=>'f?p=&APP_ID.:64:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>64
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(3558774793947857)
,p_parent_id=>wwv_flow_api.id(127749924599449850)
,p_short_name=>'Scoping Document Approve Reject'
,p_link=>'f?p=&APP_ID.:65:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>65
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(7335453441705133)
,p_parent_id=>wwv_flow_api.id(129655618524783317)
,p_short_name=>'Demand Planning SLA (Amount Based)'
,p_link=>'f?p=&APP_ID.:72:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>72
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(7336680220705136)
,p_parent_id=>wwv_flow_api.id(7335453441705133)
,p_short_name=>'Demand Planning SLA (Amount Based) Details'
,p_link=>'f?p=&APP_ID.:73:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>73
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(8318305704981151)
,p_short_name=>'DP Item Cashflow Details'
,p_link=>'f?p=&APP_ID.:74:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>74
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(11643112517478281)
,p_parent_id=>wwv_flow_api.id(127749924599449850)
,p_short_name=>'Demand Planning Dashboard'
,p_link=>'f?p=&APP_ID.:76:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>76
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(11678136012441308)
,p_parent_id=>wwv_flow_api.id(127749924599449850)
,p_short_name=>'Drilldown - Demand Planning Dashboard'
,p_link=>'f?p=&APP_ID.:77:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>77
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(127749924599449850)
,p_short_name=>'Home'
,p_link=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.'
,p_page_id=>1
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(127919581134449620)
,p_short_name=>'System Settings'
,p_link=>'f?p=&APP_ID.:2:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>2
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(127945913207449463)
,p_short_name=>'Item Categories'
,p_link=>'f?p=&APP_ID.:4:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>4
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(127974049883449416)
,p_short_name=>'Budget Brackets'
,p_link=>'f?p=&APP_ID.:6:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>6
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(127991906155449390)
,p_short_name=>'Manage Lookups'
,p_link=>'f?p=&APP_ID.:8:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>8
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(128012644035449373)
,p_parent_id=>wwv_flow_api.id(127749924599449850)
,p_short_name=>'Demand Planning Items'
,p_link=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:::'
,p_page_id=>9
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(128274924444449039)
,p_short_name=>'Administration'
,p_link=>'f?p=&APP_ID.:10000:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>10000
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(128642464379672039)
,p_parent_id=>wwv_flow_api.id(127749924599449850)
,p_short_name=>'Demand Planning Item Details'
,p_link=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.:::'
,p_page_id=>11
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(128918952792708957)
,p_parent_id=>wwv_flow_api.id(127945913207449463)
,p_short_name=>'Category Role details'
,p_link=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:::'
,p_page_id=>5
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(128940749163756451)
,p_parent_id=>wwv_flow_api.id(127749924599449850)
,p_short_name=>'Item Categories & Roles'
,p_link=>'f?p=&APP_ID.:16:&SESSION.::&DEBUG.:::'
,p_page_id=>16
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(129170453570330338)
,p_parent_id=>wwv_flow_api.id(127749924599449850)
,p_short_name=>'DP Item Approve&#x2F;Reject'
,p_link=>'f?p=&APP_ID.:18:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>18
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(129655618524783317)
,p_short_name=>'System Admin'
,p_link=>'f?p=&APP_ID.:20:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>20
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(136714826264082646)
,p_parent_id=>wwv_flow_api.id(129655618524783317)
,p_short_name=>'Scoping Appendixes'
,p_link=>'f?p=&APP_ID.:21:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>21
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(136716075037082643)
,p_parent_id=>wwv_flow_api.id(136714826264082646)
,p_short_name=>'Scoping Appendix Details'
,p_link=>'f?p=&APP_ID.:22:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>22
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(136745567224994934)
,p_parent_id=>wwv_flow_api.id(129655618524783317)
,p_short_name=>'Appendix Components'
,p_link=>'f?p=&APP_ID.:23:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>23
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(136746748207994933)
,p_parent_id=>wwv_flow_api.id(136745567224994934)
,p_short_name=>'Appendix Component Details'
,p_link=>'f?p=&APP_ID.:24:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>24
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(136824383850989437)
,p_parent_id=>wwv_flow_api.id(129655618524783317)
,p_short_name=>'Scoping Templates'
,p_link=>'f?p=&APP_ID.:25:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>25
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(136825595101989436)
,p_parent_id=>wwv_flow_api.id(136824383850989437)
,p_short_name=>'Scoping Template Details'
,p_link=>'f?p=&APP_ID.:26:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>26
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(139620313445195948)
,p_parent_id=>wwv_flow_api.id(127919581134449620)
,p_short_name=>'Data Points All'
,p_link=>'f?p=&APP_ID.:40:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>40
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(139621505945195946)
,p_parent_id=>wwv_flow_api.id(139620313445195948)
,p_short_name=>'Data Point Details'
,p_link=>'f?p=&APP_ID.:41:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>41
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(139753971006756112)
,p_parent_id=>wwv_flow_api.id(136825595101989436)
,p_short_name=>'Template Data Point Details'
,p_link=>'f?p=&APP_ID.:43:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>43
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(140437713076497665)
,p_parent_id=>wwv_flow_api.id(127749924599449850)
,p_short_name=>'KPI Templates'
,p_link=>'f?p=&APP_ID.:45:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>45
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(140438932111497664)
,p_parent_id=>wwv_flow_api.id(140437713076497665)
,p_short_name=>'Template KPI Details'
,p_link=>'f?p=&APP_ID.:46:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>46
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(140498566613640110)
,p_parent_id=>wwv_flow_api.id(136825595101989436)
,p_short_name=>'Template Component Form Details'
,p_link=>'f?p=&APP_ID.:49:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>49
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(140531621559505676)
,p_parent_id=>wwv_flow_api.id(136825595101989436)
,p_short_name=>'Template Item Category Details'
,p_link=>'f?p=&APP_ID.:50:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>50
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(141003762795115598)
,p_short_name=>'Appendix B - Technical Evaluation Criterion Details'
,p_link=>'f?p=&APP_ID.:47:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>47
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(141432603538967022)
,p_parent_id=>wwv_flow_api.id(136746748207994933)
,p_short_name=>'Component Sample'
,p_link=>'f?p=&APP_ID.:51:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>51
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(141557469739384989)
,p_parent_id=>wwv_flow_api.id(136825595101989436)
,p_short_name=>'DP Scoping Default - Template'
,p_link=>'f?p=&APP_ID.:53:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>53
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(144028986160115920)
,p_parent_id=>wwv_flow_api.id(129655618524783317)
,p_short_name=>'DP Scoping Appending &P56_SCOPING_APPENDIX. Documents'
,p_link=>'f?p=&APP_ID.:56:&SESSION.::&DEBUG.:::'
,p_page_id=>56
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(144146781609074542)
,p_short_name=>'Appendix C - Commercial Evaluation Criteria Details '
,p_link=>'f?p=&APP_ID.:57:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>57
);
wwv_flow_api.component_end;
end;
/
