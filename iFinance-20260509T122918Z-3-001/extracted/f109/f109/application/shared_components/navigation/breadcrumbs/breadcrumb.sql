prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
--   Manifest
--     MENU: Breadcrumb
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>666
,p_default_id_offset=>90826491306730853
,p_default_owner=>'PROD'
);
wwv_flow_api.create_menu(
 p_id=>wwv_flow_api.id(11079053308956006)
,p_name=>'Breadcrumb'
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(11079283739956006)
,p_short_name=>'Home'
,p_link=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.'
,p_page_id=>1
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(11260065978956190)
,p_parent_id=>wwv_flow_api.id(11079283739956006)
,p_short_name=>'My Contracts'
,p_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:::'
,p_page_id=>2
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(11307237493042588)
,p_parent_id=>wwv_flow_api.id(11260065978956190)
,p_short_name=>'Contract# <b>&P3_CONTRACT_NUMBER.</b>  Details:'
,p_link=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:::'
,p_page_id=>3
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(11473332572490322)
,p_parent_id=>wwv_flow_api.id(11307237493042588)
,p_short_name=>'Payment Application Details'
,p_link=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.::P4_CONTRACT_NUMBER,P3_CONTRACT_NUMBER:&P3_CONTRACT_NUMBER.,&P4_CONTRACT_NUMBER.'
,p_page_id=>4
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(11528004043821481)
,p_parent_id=>wwv_flow_api.id(11473332572490322)
,p_short_name=>'Attachement'
,p_link=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:::'
,p_page_id=>5
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(11929499679274297)
,p_parent_id=>wwv_flow_api.id(11079283739956006)
,p_short_name=>'My Payments Applications '
,p_link=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:::'
,p_page_id=>7
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(12145412944595419)
,p_parent_id=>wwv_flow_api.id(11079283739956006)
,p_short_name=>'Recommendation for payment review'
,p_link=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:::'
,p_page_id=>8
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(21264603191316816)
,p_parent_id=>wwv_flow_api.id(11307237493042588)
,p_short_name=>'Interim Payment Certificates'
,p_link=>'f?p=&APP_ID.:30:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>30
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(21631298301212700)
,p_parent_id=>wwv_flow_api.id(11079283739956006)
,p_short_name=>'Contract#  &P12_CONTRACT_NUMBER.  Details'
,p_link=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:::'
,p_page_id=>12
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(21683040087251817)
,p_short_name=>'Administration'
,p_link=>'f?p=&APP_ID.:10000:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>10000
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(22493066747048399)
,p_short_name=>'Service Requests'
,p_link=>'f?p=&APP_ID.:10:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>10
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(39274544634490622)
,p_parent_id=>wwv_flow_api.id(11079283739956006)
,p_short_name=>'More Infor Update'
,p_link=>'f?p=&APP_ID.:28:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>28
);
wwv_flow_api.component_end;
end;
/
