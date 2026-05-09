prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
--   Manifest
--     MENU: Breadcrumb
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>123
,p_default_id_offset=>6039605030667831
,p_default_owner=>'DEV'
);
wwv_flow_api.create_menu(
 p_id=>wwv_flow_api.id(8003821207175482)
,p_name=>'Breadcrumb'
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
,p_short_name=>'Petty Cash# (&P3_PETTY_CASH_NO. &P17_PETTY_CASH_NO.) Details'
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
 p_id=>wwv_flow_api.id(29103014368117398)
,p_short_name=>'Petty Cash Approve /Reject'
,p_link=>'f?p=&APP_ID.:6:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>6
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(29413264803052439)
,p_short_name=>'All  Petty Cash'
,p_link=>'f?p=&APP_ID.:8:&APP_SESSION.::&DEBUG.:::'
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
,p_short_name=>'Accounts Payable - &P15_DISPLAY_B. &P15_TYPE_B.'
,p_link=>'f?p=&APP_ID.:15:&SESSION.::&DEBUG.:::'
,p_page_id=>15
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
,p_short_name=>'All Expense Reports - AP'
,p_link=>'f?p=&APP_ID.:7:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>7
);
wwv_flow_api.component_end;
end;
/
