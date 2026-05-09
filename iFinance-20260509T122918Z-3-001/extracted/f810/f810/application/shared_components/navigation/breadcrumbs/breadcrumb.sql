prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
--   Manifest
--     MENU: Breadcrumb
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_menu(
 p_id=>wwv_flow_api.id(12844716791762062)
,p_name=>'Breadcrumb'
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(546947417477722)
,p_parent_id=>wwv_flow_api.id(12844980245762063)
,p_short_name=>'Missions Exception'
,p_link=>'f?p=&APP_ID.:24:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>24
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(548168790477720)
,p_parent_id=>wwv_flow_api.id(546947417477722)
,p_short_name=>'Exception Detail'
,p_link=>'f?p=&APP_ID.:25:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>25
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(1292729562674865)
,p_parent_id=>wwv_flow_api.id(12844980245762063)
,p_short_name=>'Default Options'
,p_link=>'f?p=&APP_ID.:26:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>26
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(1293929143674864)
,p_parent_id=>wwv_flow_api.id(1292729562674865)
,p_short_name=>'Default Options Details'
,p_link=>'f?p=&APP_ID.:27:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>27
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(2865936391672719)
,p_parent_id=>wwv_flow_api.id(12844980245762063)
,p_short_name=>'Payroll Vednors'
,p_link=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.:::'
,p_page_id=>21
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(2867142403672718)
,p_parent_id=>wwv_flow_api.id(2865936391672719)
,p_short_name=>'Employee Vendor Number'
,p_link=>'f?p=&APP_ID.:29:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>29
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(3203684420379291)
,p_parent_id=>wwv_flow_api.id(12844980245762063)
,p_short_name=>'SAP Employees Data Loading'
,p_link=>'f?p=&APP_ID.:30:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>30
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(3222901359379275)
,p_parent_id=>wwv_flow_api.id(12844980245762063)
,p_short_name=>'SAP Employees Data Loading'
,p_link=>'f?p=&APP_ID.:31:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>31
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(3227119434379254)
,p_parent_id=>wwv_flow_api.id(12844980245762063)
,p_short_name=>'SAP Employees Data Loading'
,p_link=>'f?p=&APP_ID.:32:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>32
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(3249927885379239)
,p_parent_id=>wwv_flow_api.id(12844980245762063)
,p_short_name=>'SAP Employees Data Loading'
,p_link=>'f?p=&APP_ID.:33:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>33
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(3295833567335891)
,p_parent_id=>wwv_flow_api.id(12844980245762063)
,p_short_name=>'SAP Employees Data'
,p_link=>'f?p=&APP_ID.:34:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>34
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(4948396173918193)
,p_parent_id=>wwv_flow_api.id(12844980245762063)
,p_short_name=>'Freelancers'
,p_link=>'f?p=&APP_ID.:35:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>35
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(4949546089918191)
,p_parent_id=>wwv_flow_api.id(4948396173918193)
,p_short_name=>'Freelancer Details'
,p_link=>'f?p=&APP_ID.:36:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>36
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(12844980245762063)
,p_parent_id=>0
,p_short_name=>'Apply for your mission or training'
,p_link=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::'
,p_page_id=>1
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(12997371951767878)
,p_short_name=>'Insurance Statement'
,p_link=>'f?p=&APP_ID.:2:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>2
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(47933266998875887)
,p_parent_id=>wwv_flow_api.id(12844980245762063)
,p_short_name=>'Upload Payroll Elements'
,p_link=>'f?p=&APP_ID.:7:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>7
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(47945109985917083)
,p_parent_id=>wwv_flow_api.id(47933266998875887)
,p_short_name=>'Upload Payroll elements'
,p_link=>'f?p=&APP_ID.:8:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>8
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(47978874398917099)
,p_parent_id=>wwv_flow_api.id(47933266998875887)
,p_short_name=>'Upload Payroll elements'
,p_link=>'f?p=&APP_ID.:9:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>9
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(47983002519917101)
,p_parent_id=>wwv_flow_api.id(47933266998875887)
,p_short_name=>'Upload Payroll elements'
,p_link=>'f?p=&APP_ID.:10:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>10
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(48005928285917114)
,p_parent_id=>wwv_flow_api.id(47933266998875887)
,p_short_name=>'Upload Payroll elements'
,p_link=>'f?p=&APP_ID.:11:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>11
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(78635684838882036)
,p_short_name=>'Duty Travel Declaration'
,p_link=>'f?p=&APP_ID.:39:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>39
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(78760211121613059)
,p_parent_id=>wwv_flow_api.id(12844980245762063)
,p_short_name=>'Payroll Areas'
,p_link=>'f?p=&APP_ID.:40:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>40
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(78761420425613061)
,p_parent_id=>wwv_flow_api.id(78760211121613059)
,p_short_name=>'Payroll Area Details'
,p_link=>'f?p=&APP_ID.:41:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>41
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(79018043132738870)
,p_parent_id=>wwv_flow_api.id(12844980245762063)
,p_short_name=>'Employees'
,p_link=>'f?p=&APP_ID.:42:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>42
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(79027632206799408)
,p_parent_id=>wwv_flow_api.id(79018043132738870)
,p_short_name=>'Employee Details'
,p_link=>'f?p=&APP_ID.:43:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>43
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(83992197477044323)
,p_short_name=>'Data Loading'
,p_link=>'f?p=&APP_ID.:45:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>45
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(84011271474044367)
,p_short_name=>'Data Loading'
,p_link=>'f?p=&APP_ID.:46:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>46
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(84015493158044373)
,p_short_name=>'Data Loading'
,p_link=>'f?p=&APP_ID.:47:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>47
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(84038394505044398)
,p_short_name=>'Data Loading'
,p_link=>'f?p=&APP_ID.:48:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>48
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(86612389946595581)
,p_parent_id=>wwv_flow_api.id(109803859664053796)
,p_short_name=>'Delegation Management'
,p_link=>'f?p=&APP_ID.:49:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>49
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(89053001741863344)
,p_short_name=>'Duty Travel View'
,p_link=>'f?p=&APP_ID.:51:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>51
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(91204541315343197)
,p_short_name=>'Dashboard'
,p_link=>'f?p=&APP_ID.:52:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>52
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(91819174941775143)
,p_short_name=>'Payroll Dashboard - Drilldown'
,p_link=>'f?p=&APP_ID.:54:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>54
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(92513170575434227)
,p_short_name=>'Cost centers By FBP'
,p_link=>'f?p=&APP_ID.:57:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>57
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(92705562745951096)
,p_short_name=>'Duty Hub Invitation'
,p_link=>'f?p=&APP_ID.:59:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>59
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(93472995669431675)
,p_short_name=>'My Worklist'
,p_link=>'f?p=&APP_ID.:61:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>61
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(96254685192027293)
,p_short_name=>'Projects - Duty Travel Dashboard'
,p_link=>'f?p=&APP_ID.:65:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>65
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(109803859664053796)
,p_parent_id=>0
,p_short_name=>'&P3_TYPE. Requests Home'
,p_link=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:::'
,p_page_id=>3
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(109804964652051049)
,p_short_name=>'Housing Home'
,p_link=>'f?p=&APP_ID.:4:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>4
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(109956118281257484)
,p_parent_id=>wwv_flow_api.id(12844980245762063)
,p_short_name=>'Mission Rates'
,p_link=>'f?p=&APP_ID.:5:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>5
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(109957370109257483)
,p_parent_id=>wwv_flow_api.id(109956118281257484)
,p_short_name=>'Mission Rate Details'
,p_link=>'f?p=&APP_ID.:6:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>6
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(110051813854053601)
,p_short_name=>'Mission Details'
,p_link=>'f?p=&APP_ID.:13:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>13
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(110311073189539765)
,p_short_name=>'Mission Documents'
,p_link=>'f?p=&APP_ID.:15:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>15
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(110549977351728964)
,p_parent_id=>wwv_flow_api.id(12844980245762063)
,p_short_name=>'Mission Approve&#x2F;Reject'
,p_link=>'f?p=&APP_ID.:20:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>20
);
wwv_flow_api.component_end;
end;
/
