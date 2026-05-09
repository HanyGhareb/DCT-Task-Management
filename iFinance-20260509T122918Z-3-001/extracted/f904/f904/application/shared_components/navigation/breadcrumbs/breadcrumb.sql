prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
--   Manifest
--     MENU: Breadcrumb
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_menu(
 p_id=>wwv_flow_api.id(10191147067597728)
,p_name=>'Breadcrumb'
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(10191357073597728)
,p_short_name=>'Home'
,p_link=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.'
,p_page_id=>1
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(10508974303641126)
,p_parent_id=>wwv_flow_api.id(10191357073597728)
,p_short_name=>'Project Roles Categories'
,p_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:::'
,p_page_id=>2
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(10527258727814695)
,p_parent_id=>wwv_flow_api.id(10191357073597728)
,p_short_name=>'Projects Roles'
,p_link=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:::'
,p_page_id=>3
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(10552384521007758)
,p_parent_id=>wwv_flow_api.id(10191357073597728)
,p_short_name=>'Project Team'
,p_link=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:::'
,p_page_id=>4
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(10634241028166228)
,p_parent_id=>wwv_flow_api.id(10191357073597728)
,p_short_name=>'Manage External Users '
,p_link=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:::'
,p_page_id=>5
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(10635450359166229)
,p_parent_id=>wwv_flow_api.id(10634241028166228)
,p_short_name=>'External User Details'
,p_link=>'f?p=&APP_ID.:6:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>6
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(10810004855788279)
,p_parent_id=>wwv_flow_api.id(10191357073597728)
,p_short_name=>'CWIP Lookups'
,p_link=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:::'
,p_page_id=>7
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(10962676640768580)
,p_parent_id=>wwv_flow_api.id(10635450359166229)
,p_short_name=>'&P10_FULL_NAME. Projects Access'
,p_link=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.:::'
,p_page_id=>10
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(10983724853871395)
,p_parent_id=>wwv_flow_api.id(10962676640768580)
,p_short_name=>'Details'
,p_link=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.:::'
,p_page_id=>11
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(11007737416025390)
,p_parent_id=>wwv_flow_api.id(10635450359166229)
,p_short_name=>'Contracts Access for: &P12_FULL_NAME.'
,p_link=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:::'
,p_page_id=>12
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(11021194430067962)
,p_parent_id=>wwv_flow_api.id(11007737416025390)
,p_short_name=>'Contract Details'
,p_link=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.:::'
,p_page_id=>13
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(11623060125977321)
,p_parent_id=>wwv_flow_api.id(10191357073597728)
,p_short_name=>'Projects'
,p_link=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.:::'
,p_page_id=>20
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(11652454463014520)
,p_parent_id=>wwv_flow_api.id(11623060125977321)
,p_short_name=>'Project Details'
,p_link=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.:::'
,p_page_id=>21
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(11734584716371464)
,p_parent_id=>wwv_flow_api.id(11652454463014520)
,p_short_name=>'Internal Project Team'
,p_link=>'f?p=&APP_ID.:22:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>22
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(11813653885895088)
,p_parent_id=>wwv_flow_api.id(11652454463014520)
,p_short_name=>'External Project Team'
,p_link=>'f?p=&APP_ID.:23:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>23
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(11965994128103245)
,p_parent_id=>wwv_flow_api.id(10191357073597728)
,p_short_name=>'CWIP Payment Recommendations  Configuration'
,p_link=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.:::'
,p_page_id=>14
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(12088932755523728)
,p_parent_id=>wwv_flow_api.id(10191357073597728)
,p_short_name=>'Approve / Reject'
,p_link=>'f?p=&APP_ID.:15:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>15
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(12203731098870627)
,p_parent_id=>wwv_flow_api.id(11652454463014520)
,p_short_name=>'Contract# &P24_CONTRACT_NUMBER.  &P49_CONTRACT_NUMBER. Details'
,p_link=>'f?p=&APP_ID.:24:&SESSION.::&DEBUG.:::'
,p_page_id=>24
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(12536796043366125)
,p_parent_id=>wwv_flow_api.id(11652454463014520)
,p_short_name=>'Document of Project# &P16_PROJECT_NUMBER.'
,p_link=>'f?p=&APP_ID.:16:&SESSION.::&DEBUG.:::'
,p_page_id=>16
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(21085364324738311)
,p_parent_id=>wwv_flow_api.id(10191357073597728)
,p_short_name=>'More Info Updates - CWIP Payment Recommendation'
,p_link=>'f?p=&APP_ID.:28:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>28
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(21347755454406609)
,p_short_name=>'Administration'
,p_link=>'f?p=&APP_ID.:10000:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>10000
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(22056943803622299)
,p_parent_id=>wwv_flow_api.id(11652454463014520)
,p_short_name=>'Payment Recommendation Preview'
,p_link=>'f?p=&APP_ID.:29:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>29
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(22097380579414298)
,p_parent_id=>wwv_flow_api.id(10191357073597728)
,p_short_name=>'Payments Recommendations'
,p_link=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.:::'
,p_page_id=>30
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(22123342142573527)
,p_parent_id=>wwv_flow_api.id(10191357073597728)
,p_short_name=>'Documents Library'
,p_link=>'f?p=&APP_ID.:31:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>31
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(22150528578726497)
,p_parent_id=>wwv_flow_api.id(10191357073597728)
,p_short_name=>'Notifications History'
,p_link=>'f?p=&APP_ID.:32:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>32
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(31371641275440266)
,p_parent_id=>wwv_flow_api.id(10191357073597728)
,p_short_name=>'Manage Contractual Securities'
,p_link=>'f?p=&APP_ID.:33:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>33
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(31535032640738540)
,p_parent_id=>wwv_flow_api.id(10191357073597728)
,p_short_name=>'Contracts'
,p_link=>'f?p=&APP_ID.:35:&SESSION.::&DEBUG.:::'
,p_page_id=>35
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(32800691753543133)
,p_short_name=>'My Signature'
,p_link=>'f?p=&APP_ID.:36:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>36
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(39956210679840087)
,p_parent_id=>wwv_flow_api.id(10191357073597728)
,p_short_name=>'Admin \ Invitation'
,p_link=>'f?p=&APP_ID.:44:&SESSION.::&DEBUG.:::'
,p_page_id=>44
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(39984744229603612)
,p_short_name=>'Invitations (Stakeholders)'
,p_link=>'f?p=&APP_ID.:46:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>46
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(40017925271937609)
,p_parent_id=>wwv_flow_api.id(12203731098870627)
,p_short_name=>'CWIP Contract Documents'
,p_link=>'f?p=&APP_ID.:49:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>49
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(40090960476018471)
,p_parent_id=>wwv_flow_api.id(11652454463014520)
,p_short_name=>'Project Document'
,p_link=>'f?p=&APP_ID.:50:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>50
);
wwv_flow_api.component_end;
end;
/
