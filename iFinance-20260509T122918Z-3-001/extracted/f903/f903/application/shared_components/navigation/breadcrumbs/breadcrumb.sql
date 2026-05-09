prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
--   Manifest
--     MENU: Breadcrumb
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>114
,p_default_id_offset=>9604171250607172
,p_default_owner=>'DEV'
);
wwv_flow_api.create_menu(
 p_id=>wwv_flow_api.id(65494572154255667)
,p_name=>'Breadcrumb'
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(2074875040854146)
,p_parent_id=>wwv_flow_api.id(65494715827255668)
,p_short_name=>'Documents Library'
,p_link=>'f?p=&APP_ID.:38:&SESSION.::&DEBUG.:::'
,p_page_id=>38
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(7127860829822525)
,p_parent_id=>wwv_flow_api.id(66844227479645323)
,p_short_name=>'Line Details'
,p_link=>'f?p=&APP_ID.:40:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>40
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(65494715827255668)
,p_short_name=>'Home'
,p_link=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.'
,p_page_id=>1
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(65881858175256295)
,p_short_name=>'Administration'
,p_link=>'f?p=&APP_ID.:10000:&SESSION.'
,p_page_id=>10000
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(66096410705458843)
,p_parent_id=>wwv_flow_api.id(65494715827255668)
,p_short_name=>'Add Supported Documents to (&P6_FORM_NO.)'
,p_link=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:::'
,p_page_id=>6
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(66121511150477613)
,p_short_name=>'Projects Data'
,p_link=>'f?p=&APP_ID.:7:&SESSION.'
,p_page_id=>7
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(66164151385197813)
,p_short_name=>'Approvers Management'
,p_link=>'f?p=&APP_ID.:8:&SESSION.'
,p_page_id=>8
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(66415929948720458)
,p_parent_id=>0
,p_short_name=>'Budget Transfer Request Details - (&P9_FORM_NO.)'
,p_link=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:::'
,p_page_id=>9
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(66688235952436755)
,p_parent_id=>wwv_flow_api.id(65494715827255668)
,p_short_name=>'Budget Transfer requests - &P11_STATUS.'
,p_link=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.:::'
,p_page_id=>11
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(66844227479645323)
,p_parent_id=>0
,p_short_name=>'BTF Approve / Reject'
,p_link=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:::'
,p_page_id=>12
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(66906987470442583)
,p_short_name=>'Available to Oracle'
,p_link=>'f?p=&APP_ID.:13:&SESSION.'
,p_page_id=>13
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(70040343333033763)
,p_short_name=>'Users Access'
,p_link=>'f?p=&APP_ID.:15:&SESSION.'
,p_page_id=>15
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(70062000969020979)
,p_parent_id=>wwv_flow_api.id(70040343333033763)
,p_short_name=>'Details'
,p_link=>'f?p=&APP_ID.:16:&SESSION.'
,p_page_id=>16
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(70209804530719010)
,p_short_name=>'BTF Configurations'
,p_link=>'f?p=&APP_ID.:17:&SESSION.'
,p_page_id=>17
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(70479763488651359)
,p_short_name=>'Approval Transfer '
,p_link=>'f?p=&APP_ID.:18:&SESSION.'
,p_page_id=>18
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(70628285621977672)
,p_short_name=>'End User - Home'
,p_link=>'f?p=&APP_ID.:20:&SESSION.'
,p_page_id=>20
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(70717290237036340)
,p_parent_id=>0
,p_short_name=>'Transfer Request - End User'
,p_long_name=>'Budget Transfer Request Details - End User'
,p_link=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.:::'
,p_page_id=>21
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(75608168396000421)
,p_short_name=>'Projects Users - Home'
,p_link=>'f?p=&APP_ID.:22:&SESSION.'
,p_page_id=>22
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(75671401088570433)
,p_parent_id=>wwv_flow_api.id(75608168396000421)
,p_short_name=>'Transfer Request - End User (&P23_REQUEST_NO_H.)'
,p_link=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.:::'
,p_page_id=>23
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(75849030097059524)
,p_parent_id=>wwv_flow_api.id(65494715827255668)
,p_short_name=>'Transfer Request Details - FBP'
,p_link=>'f?p=&APP_ID.:24:&SESSION.'
,p_page_id=>24
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(75902237270769938)
,p_parent_id=>wwv_flow_api.id(65494715827255668)
,p_short_name=>'Add to Budget Transfer Request'
,p_link=>'f?p=&APP_ID.:25:&SESSION.'
,p_page_id=>25
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(75956606477356848)
,p_parent_id=>wwv_flow_api.id(66415929948720458)
,p_short_name=>'Line No &P4_LINE_NO.'
,p_link=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:::'
,p_page_id=>4
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(76125521038430730)
,p_parent_id=>wwv_flow_api.id(65494715827255668)
,p_short_name=>'Access new project request'
,p_link=>'f?p=&APP_ID.:26:&SESSION.::&DEBUG.:::'
,p_page_id=>26
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(76240460864624054)
,p_parent_id=>wwv_flow_api.id(65494715827255668)
,p_short_name=>'<b>End User - Project Access Request Approve &#x2F; Reject</b>'
,p_link=>'f?p=&APP_ID.:27:&SESSION.::&DEBUG.:::'
,p_page_id=>27
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(76256193799347007)
,p_parent_id=>wwv_flow_api.id(65494715827255668)
,p_short_name=>'End User - Requests List'
,p_link=>'f?p=&APP_ID.:28:&SESSION.'
,p_page_id=>28
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(76750432616214370)
,p_parent_id=>wwv_flow_api.id(65494715827255668)
,p_short_name=>'Budget Transfer Requests - &P29_STATUS.'
,p_link=>'f?p=&APP_ID.:29:&SESSION.'
,p_page_id=>29
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(76804820997528275)
,p_parent_id=>wwv_flow_api.id(66415929948720458)
,p_short_name=>'Line Details'
,p_link=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.:::'
,p_page_id=>30
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(77009362802589473)
,p_parent_id=>wwv_flow_api.id(75671401088570433)
,p_short_name=>'Supporting documents'
,p_link=>'f?p=&APP_ID.:32:&SESSION.'
,p_page_id=>32
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(77099657329206978)
,p_parent_id=>wwv_flow_api.id(65494715827255668)
,p_short_name=>'All End User Transfer Requests'
,p_link=>'f?p=&APP_ID.:33:&SESSION.'
,p_page_id=>33
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(77140768397920490)
,p_parent_id=>wwv_flow_api.id(65494715827255668)
,p_short_name=>'Reports'
,p_link=>'f?p=&APP_ID.:34:&SESSION.'
,p_page_id=>34
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(77307417159609460)
,p_parent_id=>wwv_flow_api.id(65881858175256295)
,p_short_name=>'Manage Lookups'
,p_link=>'f?p=&APP_ID.:35:&SESSION.::&DEBUG.:::'
,p_page_id=>35
);
wwv_flow_api.component_end;
end;
/
