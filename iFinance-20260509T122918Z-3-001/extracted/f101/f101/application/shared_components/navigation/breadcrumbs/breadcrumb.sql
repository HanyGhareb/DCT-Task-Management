prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
--   Manifest
--     MENU: Breadcrumb
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_menu(
 p_id=>wwv_flow_api.id(8003821207175482)
,p_name=>'Breadcrumb'
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(25686961573395931)
,p_parent_id=>wwv_flow_api.id(8004008253175482)
,p_short_name=>'Petty Cash - Change Type'
,p_link=>'f?p=&APP_ID.:56:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>56
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(16124135457102823)
,p_short_name=>'Control System Access'
,p_link=>'f?p=&APP_ID.:62:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>62
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(1812000072731754)
,p_short_name=>'Petty cash Tracking Status'
,p_link=>'f?p=&APP_ID.:41:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>41
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(1767333618854452)
,p_parent_id=>wwv_flow_api.id(1812000072731754)
,p_short_name=>'Petty cash tracking details'
,p_link=>'f?p=&APP_ID.:42:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>42
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(1448210630683772)
,p_short_name=>'Expense Report AP Tracking'
,p_link=>'f?p=&APP_ID.:44:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>44
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(1367559514468362)
,p_parent_id=>wwv_flow_api.id(8004008253175482)
,p_short_name=>'Petty Cash Vouchers'
,p_link=>'f?p=&APP_ID.:46:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>46
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(595184908533099)
,p_parent_id=>wwv_flow_api.id(8004008253175482)
,p_short_name=>'Petty Cash Delegation - Admin'
,p_link=>'f?p=&APP_ID.:47:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>47
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(579127251701959)
,p_parent_id=>wwv_flow_api.id(595184908533099)
,p_short_name=>'Petty Cash Delegation Admin - Details'
,p_link=>'f?p=&APP_ID.:48:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>48
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(378788535786931)
,p_parent_id=>wwv_flow_api.id(8004008253175482)
,p_short_name=>'FAB DEBIT CARD Vendors'
,p_link=>'f?p=&APP_ID.:49:&SESSION.::&DEBUG.:::'
,p_page_id=>49
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(377554356786934)
,p_parent_id=>wwv_flow_api.id(378788535786931)
,p_short_name=>'FAB DEBIT CARD Details'
,p_link=>'f?p=&APP_ID.:50:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>50
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(324561718970648)
,p_parent_id=>wwv_flow_api.id(8004008253175482)
,p_short_name=>'DCT IMPREST Accounts'
,p_link=>'f?p=&APP_ID.:51:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>51
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(245170879419009)
,p_parent_id=>wwv_flow_api.id(8004008253175482)
,p_short_name=>'Approval Monitoring - Admin'
,p_link=>'f?p=&APP_ID.:53:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>53
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(557675864033298)
,p_short_name=>'Invitation - Petty Cash '
,p_link=>'f?p=&APP_ID.:9:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>9
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(654498438051179)
,p_short_name=>'Administration'
,p_link=>'f?p=&APP_ID.:10000:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>10000
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(2523350857060663)
,p_parent_id=>wwv_flow_api.id(8004008253175482)
,p_short_name=>'Petty cash Tracking Report'
,p_link=>'f?p=&APP_ID.:57:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>57
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(2547637095479912)
,p_parent_id=>wwv_flow_api.id(8004008253175482)
,p_short_name=>'Expense Reports Tracking Report'
,p_link=>'f?p=&APP_ID.:58:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>58
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(3688488182353044)
,p_parent_id=>wwv_flow_api.id(8004008253175482)
,p_short_name=>'Petty Cash Management Configurations'
,p_link=>'f?p=&APP_ID.:11:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>11
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(4037159476982529)
,p_parent_id=>wwv_flow_api.id(29103014368117398)
,p_short_name=>'Petty Cash Approval Delegation'
,p_link=>'f?p=&APP_ID.:27:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>27
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(4254956736172414)
,p_parent_id=>wwv_flow_api.id(8004008253175482)
,p_short_name=>'Petty Cash Dashboard'
,p_link=>'f?p=&APP_ID.:25:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>25
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(4341499144442411)
,p_parent_id=>wwv_flow_api.id(29413264803052439)
,p_short_name=>'All Petty Cash - Details '
,p_link=>'f?p=&APP_ID.:28:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>28
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(4419091949953342)
,p_parent_id=>wwv_flow_api.id(8228487207448903)
,p_short_name=>'Petty Cash (&P29_PETTY_CASH_NO.) - Expenses Reports'
,p_link=>'f?p=&APP_ID.:29:&SESSION.::&DEBUG.:::'
,p_page_id=>29
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(4465639269254656)
,p_parent_id=>wwv_flow_api.id(8228487207448903)
,p_short_name=>'Petty Cash - Expense Reports for (&P30_PETTY_CASH_NO.) '
,p_link=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.:::'
,p_page_id=>30
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(4466832062254658)
,p_parent_id=>wwv_flow_api.id(4465639269254656)
,p_short_name=>'Petty Cash - Expenses Report Details'
,p_link=>'f?p=&APP_ID.:31:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>31
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(4654834802566150)
,p_parent_id=>wwv_flow_api.id(8004008253175482)
,p_short_name=>'Expense Report Approve &#x2F; Rejects'
,p_link=>'f?p=&APP_ID.:32:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>32
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(5882310529168203)
,p_parent_id=>wwv_flow_api.id(8004008253175482)
,p_short_name=>'Expense Report Page'
,p_link=>'f?p=&APP_ID.:35:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>35
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(6178043822764875)
,p_parent_id=>wwv_flow_api.id(8004008253175482)
,p_short_name=>'Expense Report 3'
,p_link=>'f?p=&APP_ID.:40:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>40
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(6645927024053975)
,p_parent_id=>wwv_flow_api.id(8004008253175482)
,p_short_name=>'All Petty Cash - Directors and ED'
,p_link=>'f?p=&APP_ID.:36:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>36
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(6744801101326444)
,p_parent_id=>wwv_flow_api.id(8004008253175482)
,p_short_name=>'All Petty Cash - Directors and ED -Details'
,p_link=>'f?p=&APP_ID.:37:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>37
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(7227737983130809)
,p_parent_id=>wwv_flow_api.id(8004008253175482)
,p_short_name=>'Expense Report Details - Notifications'
,p_link=>'f?p=&APP_ID.:38:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>38
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(8004008253175482)
,p_short_name=>'Home'
,p_link=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.'
,p_page_id=>1
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(8157353690189480)
,p_short_name=>'Petty Cash Requests'
,p_link=>'f?p=&APP_ID.:2:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>2
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(8228487207448903)
,p_parent_id=>wwv_flow_api.id(8157353690189480)
,p_short_name=>'Petty Cash Details &P3_PETTY_CASH_NO.'
,p_link=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:::'
,p_page_id=>3
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(8356301521155984)
,p_parent_id=>0
,p_short_name=>'Petty Cash Requests \ Petty Cash# (&P4_PETTY_CASH_NO.) Details \ Documents'
,p_link=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:::'
,p_page_id=>4
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(18033230453946560)
,p_short_name=>'Manual Petty Cash Details'
,p_link=>'f?p=&APP_ID.:90:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>90
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(29103014368117398)
,p_short_name=>'Petty Cash Approve /Reject'
,p_link=>'f?p=&APP_ID.:6:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>6
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(29413264803052439)
,p_parent_id=>wwv_flow_api.id(8004008253175482)
,p_short_name=>'All  Petty Cash'
,p_link=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:::'
,p_page_id=>8
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(29694740706734872)
,p_parent_id=>wwv_flow_api.id(8228487207448903)
,p_short_name=>'Expense Reports'
,p_link=>'f?p=&APP_ID.:17:&SESSION.::&DEBUG.:::'
,p_page_id=>17
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(30052860923085333)
,p_parent_id=>wwv_flow_api.id(8004008253175482)
,p_short_name=>'Petty Cash Details '
,p_link=>'f?p=&APP_ID.:23:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>23
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(30588467564921364)
,p_parent_id=>wwv_flow_api.id(8004008253175482)
,p_short_name=>'Treasury - &P26_TYPE_B.   &P26_DISPLAY_B. Tasks'
,p_link=>'f?p=&APP_ID.:26:&SESSION.::&DEBUG.:::'
,p_page_id=>26
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(30851451499415228)
,p_parent_id=>wwv_flow_api.id(8004008253175482)
,p_short_name=>'Accounts Payable -&P15_PENDING_WITH_AP_DISPLAY. &P15_TYPE_B.'
,p_link=>'f?p=&APP_ID.:15:&SESSION.::&DEBUG.:::'
,p_page_id=>15
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(31590121939637435)
,p_parent_id=>wwv_flow_api.id(8004008253175482)
,p_short_name=>'Petty Cash Approval Changes - Admin'
,p_link=>'f?p=&APP_ID.:63:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>63
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(46345343305972790)
,p_parent_id=>wwv_flow_api.id(8004008253175482)
,p_short_name=>'Expense Reports for: &EMP_NAME. '
,p_link=>'f?p=&APP_ID.:16:&SESSION.::&DEBUG.:::'
,p_page_id=>16
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(46609907664233264)
,p_parent_id=>wwv_flow_api.id(8004008253175482)
,p_short_name=>'All Expense Reports - Petty Cash Admin'
,p_link=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:::'
,p_page_id=>7
);
wwv_flow_api.component_end;
end;
/
