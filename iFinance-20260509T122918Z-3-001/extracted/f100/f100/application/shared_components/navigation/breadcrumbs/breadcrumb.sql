prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
--   Manifest
--     MENU: Breadcrumb
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_menu(
 p_id=>wwv_flow_api.id(1547752126302241)
,p_name=>'Breadcrumb'
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'Home'
,p_link=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.'
,p_page_id=>1
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(1737201160438067)
,p_short_name=>'Administration'
,p_link=>'f?p=&APP_ID.:10000:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>10000
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(2432386537556883)
,p_parent_id=>wwv_flow_api.id(1737201160438067)
,p_short_name=>'User Organizations Access'
,p_link=>'f?p=&APP_ID.:3:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>3
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(2439198763630628)
,p_parent_id=>wwv_flow_api.id(2432386537556883)
,p_short_name=>'User Organizations Access Details for: <b> &P4_USER_NAME. </b>'
,p_link=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:::'
,p_page_id=>4
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(4364494600947974)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'Instance Settings'
,p_link=>'f?p=&APP_ID.:8:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>8
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(4431048671094053)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'Lookup Management'
,p_link=>'f?p=&APP_ID.:9:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>9
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(4480985911439801)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'Manage Roles'
,p_link=>'f?p=&APP_ID.:12:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>12
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(4732766897491722)
,p_short_name=>'Tree Page'
,p_link=>'f?p=&APP_ID.:13:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>13
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(4845721298243449)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'Role Users Management'
,p_link=>'f?p=&APP_ID.:14:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>14
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(4992717523341336)
,p_parent_id=>wwv_flow_api.id(1737201160438067)
,p_short_name=>'Menus'
,p_link=>'f?p=&APP_ID.:5:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>5
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(5002971672358196)
,p_parent_id=>wwv_flow_api.id(4992717523341336)
,p_short_name=>'Menu Details'
,p_link=>'f?p=&APP_ID.:6:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>6
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(5643279377220365)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'My Roles & Groups'
,p_link=>'f?p=&APP_ID.:7:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>7
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(5653080356265348)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'Users Roles &amp; Groups'
,p_link=>'f?p=&APP_ID.:15:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>15
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(5803605921484588)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'My Delegations'
,p_link=>'f?p=&APP_ID.:16:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>16
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(5804869524484590)
,p_parent_id=>wwv_flow_api.id(5803605921484588)
,p_short_name=>'Delegation Details'
,p_link=>'f?p=&APP_ID.:17:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>17
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(5832366259771136)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'Delegation Management'
,p_link=>'f?p=&APP_ID.:18:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>18
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(5833508265771137)
,p_parent_id=>wwv_flow_api.id(5832366259771136)
,p_short_name=>'Delegation Management Details'
,p_link=>'f?p=&APP_ID.:19:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>19
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(9665975717184199)
,p_short_name=>'Reset Users Password'
,p_link=>'f?p=&APP_ID.:20:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>20
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(20232472152007741)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'Employees Business Partners Roles By Cost Center'
,p_link=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.:::'
,p_page_id=>21
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(38864840187600574)
,p_parent_id=>wwv_flow_api.id(1737201160438067)
,p_short_name=>'Emails Control '
,p_link=>'f?p=&APP_ID.:22:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>22
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(38866024087600572)
,p_parent_id=>wwv_flow_api.id(38864840187600574)
,p_short_name=>'Emails Control - Details'
,p_link=>'f?p=&APP_ID.:23:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>23
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(42070491240645920)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'Finance Templates'
,p_link=>'f?p=&APP_ID.:24:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>24
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(42071698864645921)
,p_parent_id=>wwv_flow_api.id(42070491240645920)
,p_short_name=>'Finance Template Details'
,p_link=>'f?p=&APP_ID.:25:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>25
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(42770508954468493)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'External Menus'
,p_link=>'f?p=&APP_ID.:26:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>26
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(42781194071491495)
,p_parent_id=>wwv_flow_api.id(42770508954468493)
,p_short_name=>'External Menu Details'
,p_link=>'f?p=&APP_ID.:27:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>27
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(47127818106757490)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'My ADERP Account'
,p_link=>'f?p=&APP_ID.:28:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>28
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(47170918497861263)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'All ADERP Users Accounts'
,p_link=>'f?p=&APP_ID.:29:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>29
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(92070548426555996)
,p_parent_id=>0
,p_short_name=>'Workflow \ Approval Types'
,p_link=>'f?p=&APP_ID.:31:&SESSION.::&DEBUG.:::'
,p_page_id=>31
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(92071744347555998)
,p_parent_id=>wwv_flow_api.id(92070548426555996)
,p_short_name=>'Approval Type Details'
,p_link=>'f?p=&APP_ID.:32:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>32
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(92452775088969354)
,p_short_name=>'Login History'
,p_link=>'f?p=&APP_ID.:33:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>33
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(93314513644351207)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'User Preferences \ My Signature'
,p_link=>'f?p=&APP_ID.:34:&SESSION.::&DEBUG.:::'
,p_page_id=>34
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(93319072696361729)
,p_parent_id=>wwv_flow_api.id(93314513644351207)
,p_short_name=>'Add My Signature'
,p_link=>'f?p=&APP_ID.:35:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>35
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(93488457028162661)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'Master Data \ Vendors'
,p_link=>'f?p=&APP_ID.:37:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>37
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(93489604223162662)
,p_parent_id=>wwv_flow_api.id(93488457028162661)
,p_short_name=>'Vendor Details'
,p_link=>'f?p=&APP_ID.:38:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>38
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(93500532961374716)
,p_parent_id=>wwv_flow_api.id(93488457028162661)
,p_short_name=>'Vendors Data Loading'
,p_link=>'f?p=&APP_ID.:39:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>39
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(93534156784374748)
,p_parent_id=>wwv_flow_api.id(93488457028162661)
,p_short_name=>'Vendors Data Loading'
,p_link=>'f?p=&APP_ID.:40:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>40
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(93538396757374750)
,p_parent_id=>wwv_flow_api.id(93488457028162661)
,p_short_name=>'Vendors Data Loading'
,p_link=>'f?p=&APP_ID.:41:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>41
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(93561298432374770)
,p_parent_id=>wwv_flow_api.id(93488457028162661)
,p_short_name=>'Vendors Data Loading'
,p_link=>'f?p=&APP_ID.:42:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>42
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(100246552523075425)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'Vendor Bank Accounts Data Loading'
,p_link=>'f?p=&APP_ID.:36:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>36
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(100265785161075437)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'Vendor Bank Accounts Data Loading'
,p_link=>'f?p=&APP_ID.:43:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>43
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(100269992661075439)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'Vendor Bank Accounts Data Loading'
,p_link=>'f?p=&APP_ID.:44:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>44
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(100292817859075453)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'Vendor Bank Accounts Data Loading'
,p_link=>'f?p=&APP_ID.:45:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>45
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(100338807842181571)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'Vendor Bank Accounts'
,p_link=>'f?p=&APP_ID.:46:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>46
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(100348130124265171)
,p_parent_id=>wwv_flow_api.id(100338807842181571)
,p_short_name=>'Vendor Bank Account Details'
,p_link=>'f?p=&APP_ID.:47:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>47
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(100405353632597112)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'Receiving'
,p_link=>'f?p=&APP_ID.:48:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>48
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(100406508707597113)
,p_parent_id=>wwv_flow_api.id(100405353632597112)
,p_short_name=>'Receiving Details'
,p_link=>'f?p=&APP_ID.:49:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>49
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(100410522526617900)
,p_parent_id=>wwv_flow_api.id(100405353632597112)
,p_short_name=>'Receiving  Data Loading'
,p_link=>'f?p=&APP_ID.:50:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>50
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(100429780424617908)
,p_parent_id=>wwv_flow_api.id(100405353632597112)
,p_short_name=>'Receiving  Data Loading'
,p_link=>'f?p=&APP_ID.:51:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>51
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(100433953426617910)
,p_parent_id=>wwv_flow_api.id(100405353632597112)
,p_short_name=>'Receiving  Data Loading'
,p_link=>'f?p=&APP_ID.:52:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>52
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(100456817138617921)
,p_parent_id=>wwv_flow_api.id(100405353632597112)
,p_short_name=>'Receiving  Data Loading'
,p_link=>'f?p=&APP_ID.:53:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>53
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(100733199842203760)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'AP Invoices'
,p_link=>'f?p=&APP_ID.:54:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>54
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(100734317483203761)
,p_parent_id=>wwv_flow_api.id(100733199842203760)
,p_short_name=>'AP Invoice Details'
,p_link=>'f?p=&APP_ID.:55:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>55
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(100741519903231641)
,p_parent_id=>wwv_flow_api.id(100733199842203760)
,p_short_name=>'AP Invoices All  Data Loading'
,p_link=>'f?p=&APP_ID.:56:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>56
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(100760738767231651)
,p_parent_id=>wwv_flow_api.id(100733199842203760)
,p_short_name=>'AP Invoices All  Data Loading'
,p_link=>'f?p=&APP_ID.:57:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>57
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(100764925627231653)
,p_parent_id=>wwv_flow_api.id(100733199842203760)
,p_short_name=>'AP Invoices All  Data Loading'
,p_link=>'f?p=&APP_ID.:58:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>58
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(100787890580231664)
,p_parent_id=>wwv_flow_api.id(100733199842203760)
,p_short_name=>'AP Invoices All  Data Loading'
,p_link=>'f?p=&APP_ID.:59:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>59
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(105852983348659112)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'Cost Centers Directors'
,p_link=>'f?p=&APP_ID.:60:&SESSION.::&DEBUG.:::'
,p_page_id=>60
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(105889791958515492)
,p_parent_id=>wwv_flow_api.id(1547993336302242)
,p_short_name=>'Cost Centers Exec Directors'
,p_link=>'f?p=&APP_ID.:61:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>61
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(108117778163365153)
,p_short_name=>'Workflow \ Email Approval Records'
,p_link=>'f?p=&APP_ID.:62:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>62
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(108118922823365151)
,p_parent_id=>wwv_flow_api.id(108117778163365153)
,p_short_name=>'Email Approval Record Details'
,p_link=>'f?p=&APP_ID.:63:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>63
);
wwv_flow_api.component_end;
end;
/
