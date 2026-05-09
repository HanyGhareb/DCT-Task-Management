prompt --application/shared_components/navigation/lists/desktop_navigation_menu
begin
--   Manifest
--     LIST: Desktop Navigation Menu
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(1548225055302243)
,p_name=>'Desktop Navigation Menu'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(1696246910302395)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Home'
,p_list_item_link_target=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:'
,p_list_item_icon=>'fa-home'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2293525526303939)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Petty Cash'
,p_list_item_link_target=>'f?p=101:1:&APP_SESSION.:::'
,p_list_item_icon=>'fa-money'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(23386483263495631)
,p_list_item_display_sequence=>21
,p_list_item_link_text=>'Manual PR'
,p_list_item_link_target=>'f?p=108:1:&APP_SESSION.:::'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(3486065556129133)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'HR'
,p_list_item_link_target=>'f?p=102:1:&APP_SESSION.:::'
,p_list_item_icon=>'fa-database-user'
,p_list_item_disp_cond_type=>'EXISTS'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT *',
'FROM DCT_DATA_ACCESS_ASSIGNMENT',
'where user_id = :APP_USER',
'    and entity_type_id = ''ROLE''',
'    and dct_data_access_assignment.entity_id = 17  '))
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(1736394319438065)
,p_list_item_display_sequence=>10000
,p_list_item_link_text=>'Administration'
,p_list_item_link_target=>'f?p=&APP_ID.:10000:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-user-wrench'
,p_security_scheme=>wwv_flow_api.id(1688862454302373)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'10000,3,5,8,8,9,12,14,5,15,18,20,21,22,22,24,26,29,31'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(4866851832440751)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Access Control'
,p_list_item_icon=>'fa-lock-password'
,p_parent_list_item_id=>wwv_flow_api.id(1736394319438065)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(4991519762341334)
,p_list_item_display_sequence=>980
,p_list_item_link_text=>'Menus'
,p_list_item_link_target=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-align-justify'
,p_parent_list_item_id=>wwv_flow_api.id(4866851832440751)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'5'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(4363283290947973)
,p_list_item_display_sequence=>930
,p_list_item_link_text=>'Instance Settings'
,p_list_item_link_target=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::P8_ID:0:'
,p_list_item_icon=>'fa-gear'
,p_parent_list_item_id=>wwv_flow_api.id(1736394319438065)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'8'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(4414165912094032)
,p_list_item_display_sequence=>940
,p_list_item_link_text=>'Manage Lookup'
,p_list_item_link_target=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-list-alt'
,p_parent_list_item_id=>wwv_flow_api.id(1736394319438065)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'9'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(42069405452645919)
,p_list_item_display_sequence=>1060
,p_list_item_link_text=>'Finance Templates Report'
,p_list_item_link_target=>'f?p=&APP_ID.:24:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(1736394319438065)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'24,25'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(42769321344468491)
,p_list_item_display_sequence=>1070
,p_list_item_link_text=>'External Menus'
,p_list_item_link_target=>'f?p=&APP_ID.:26:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(1736394319438065)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'26'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(1830425197736529)
,p_list_item_display_sequence=>10010
,p_list_item_link_text=>'User Preferences'
,p_list_item_icon=>'fa-user-circle'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(1830891712751968)
,p_list_item_display_sequence=>900
,p_list_item_link_text=>'Change My Password'
,p_list_item_link_target=>'f?p=&APP_ID.:9997:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-key fa-rotate-180'
,p_parent_list_item_id=>wwv_flow_api.id(1830425197736529)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'9997'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(5633939916220354)
,p_list_item_display_sequence=>990
,p_list_item_link_text=>'My Roles & Groups'
,p_list_item_link_target=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-calendar-user'
,p_parent_list_item_id=>wwv_flow_api.id(1830425197736529)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'7'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(5802989039484585)
,p_list_item_display_sequence=>1010
,p_list_item_link_text=>'My Delegations'
,p_list_item_link_target=>'f?p=&APP_ID.:16:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-mail-forward'
,p_parent_list_item_id=>wwv_flow_api.id(1830425197736529)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'16,17'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(47120480461757479)
,p_list_item_display_sequence=>1080
,p_list_item_link_text=>'My ADERP Account'
,p_list_item_link_target=>'f?p=&APP_ID.:28:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-user'
,p_parent_list_item_id=>wwv_flow_api.id(1830425197736529)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'28'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(93307522021351187)
,p_list_item_display_sequence=>1120
,p_list_item_link_text=>'My Signature'
,p_list_item_link_target=>'f?p=&APP_ID.:34:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-edit'
,p_parent_list_item_id=>wwv_flow_api.id(1830425197736529)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'34'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(92450520414958340)
,p_list_item_display_sequence=>10163
,p_list_item_link_text=>'User Management'
,p_list_item_link_target=>'#'
,p_list_item_icon=>'fa-user-ban'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':EMP_NUM = 9051'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(4479730588439800)
,p_list_item_display_sequence=>100
,p_list_item_link_text=>'Manage Roles'
,p_list_item_link_target=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-user-secret'
,p_parent_list_item_id=>wwv_flow_api.id(92450520414958340)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'12'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(4832423923243403)
,p_list_item_display_sequence=>970
,p_list_item_link_text=>'Role Users'
,p_list_item_link_target=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-user-wrench'
,p_parent_list_item_id=>wwv_flow_api.id(92450520414958340)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'14'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(5831343894771135)
,p_list_item_display_sequence=>1020
,p_list_item_link_text=>'Delegation Management'
,p_list_item_link_target=>'f?p=&APP_ID.:18:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-users-chat'
,p_parent_list_item_id=>wwv_flow_api.id(92450520414958340)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'18,19'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(9664749915184191)
,p_list_item_display_sequence=>1030
,p_list_item_link_text=>'Reset Users Password'
,p_list_item_link_target=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.::::'
,p_parent_list_item_id=>wwv_flow_api.id(92450520414958340)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'20'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(20231201253007736)
,p_list_item_display_sequence=>1040
,p_list_item_link_text=>'FBP By Cost Center'
,p_list_item_link_target=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.::::'
,p_parent_list_item_id=>wwv_flow_api.id(92450520414958340)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'21'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(105844990320659091)
,p_list_item_display_sequence=>1180
,p_list_item_link_text=>'Cost Centers Directors'
,p_list_item_link_target=>'f?p=&APP_ID.:60:&SESSION.::&DEBUG.::::'
,p_parent_list_item_id=>wwv_flow_api.id(92450520414958340)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'60'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(105881643892515482)
,p_list_item_display_sequence=>1190
,p_list_item_link_text=>'Cost Centers Exec Directors'
,p_list_item_link_target=>'f?p=&APP_ID.:61:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(92450520414958340)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'61'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(92575567083395570)
,p_list_item_display_sequence=>10183
,p_list_item_link_text=>'Others'
,p_list_item_link_target=>'#'
,p_list_item_icon=>'fa-bolt'
,p_parent_list_item_id=>wwv_flow_api.id(92450520414958340)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2431167723556878)
,p_list_item_display_sequence=>910
,p_list_item_link_text=>'User Organizations'
,p_list_item_link_target=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-user-check'
,p_parent_list_item_id=>wwv_flow_api.id(92575567083395570)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'3'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(5648112734265336)
,p_list_item_display_sequence=>1000
,p_list_item_link_text=>'Users Roles & Groups'
,p_list_item_link_target=>'f?p=&APP_ID.:15:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-users'
,p_parent_list_item_id=>wwv_flow_api.id(92575567083395570)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'15'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(47169725789861262)
,p_list_item_display_sequence=>1090
,p_list_item_link_text=>'ADERP Users'
,p_list_item_link_target=>'f?p=&APP_ID.:29:&SESSION.::&DEBUG.:29:::'
,p_parent_list_item_id=>wwv_flow_api.id(92575567083395570)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'29'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(92451815381969353)
,p_list_item_display_sequence=>1110
,p_list_item_link_text=>'Login History'
,p_list_item_link_target=>'f?p=&APP_ID.:33:&SESSION.::&DEBUG.::::'
,p_parent_list_item_id=>wwv_flow_api.id(92575567083395570)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'33'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(92571532241240064)
,p_list_item_display_sequence=>10173
,p_list_item_link_text=>'ifinance Services'
,p_list_item_link_target=>'#'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':EMP_NUM = 9051'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2314848730419070)
,p_list_item_display_sequence=>10040
,p_list_item_link_text=>'SOA Management'
,p_list_item_icon=>'fa-bolt'
,p_parent_list_item_id=>wwv_flow_api.id(92571532241240064)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2314250361407094)
,p_list_item_display_sequence=>10020
,p_list_item_link_text=>'Enterprise Manager'
,p_list_item_link_target=>'http://ifinance.dct.gov.ae:7001/em'
,p_parent_list_item_id=>wwv_flow_api.id(2314848730419070)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2314590325411040)
,p_list_item_display_sequence=>10030
,p_list_item_link_text=>'Console'
,p_list_item_link_target=>'http://ifinance.dct.gov.ae:7001/console'
,p_parent_list_item_id=>wwv_flow_api.id(2314848730419070)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2315587087430262)
,p_list_item_display_sequence=>10050
,p_list_item_link_text=>'Apex Management'
,p_list_item_icon=>'fa-apex'
,p_parent_list_item_id=>wwv_flow_api.id(92571532241240064)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2317192064462435)
,p_list_item_display_sequence=>10060
,p_list_item_link_text=>'Enterprise Manager (Secure)'
,p_list_item_link_target=>'https://ifinance.dct.gov.ae:8002/em'
,p_list_item_icon=>'fa-lock-password'
,p_parent_list_item_id=>wwv_flow_api.id(2315587087430262)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2315854904436713)
,p_list_item_display_sequence=>10061
,p_list_item_link_text=>'Enterprise Manager'
,p_list_item_link_target=>'http://ifinance.dct.gov.ae:8001/em'
,p_list_item_icon=>'fa-button-group'
,p_parent_list_item_id=>wwv_flow_api.id(2315587087430262)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2316833908452571)
,p_list_item_display_sequence=>10062
,p_list_item_link_text=>'Console(Secure)'
,p_list_item_link_target=>'https://ifinance.dct.gov.ae:8002/console'
,p_list_item_icon=>'fa-lock-password'
,p_parent_list_item_id=>wwv_flow_api.id(2315587087430262)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2316531234445023)
,p_list_item_display_sequence=>10063
,p_list_item_link_text=>'Console'
,p_list_item_link_target=>'http://ifinance.dct.gov.ae:8001/console'
,p_list_item_icon=>'fa-braille'
,p_parent_list_item_id=>wwv_flow_api.id(2315587087430262)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2318568977492321)
,p_list_item_display_sequence=>10073
,p_list_item_link_text=>'Analytics'
,p_list_item_icon=>'fa-combo-chart'
,p_parent_list_item_id=>wwv_flow_api.id(92571532241240064)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2319856465522637)
,p_list_item_display_sequence=>10103
,p_list_item_link_text=>'Visualization (Secure)'
,p_list_item_link_target=>'https://ifinance.dct.gov.ae:9603/dv'
,p_list_item_icon=>'fa-dial-gauge-chart'
,p_parent_list_item_id=>wwv_flow_api.id(2318568977492321)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2321678713575834)
,p_list_item_display_sequence=>10143
,p_list_item_link_text=>'Reports & Analytics'
,p_list_item_link_target=>'https://ifinance.dct.gov.ae:9603/analytics'
,p_list_item_icon=>'fa-dashboard'
,p_parent_list_item_id=>wwv_flow_api.id(2318568977492321)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(8914819691564452)
,p_list_item_display_sequence=>10153
,p_list_item_link_text=>'BI Publisher'
,p_list_item_link_target=>'https://ifinance.dct.gov.ae:9603/xmlpserver'
,p_list_item_icon=>'fa-notebook'
,p_parent_list_item_id=>wwv_flow_api.id(2318568977492321)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2320309003532405)
,p_list_item_display_sequence=>10113
,p_list_item_link_text=>'Analytics Management'
,p_list_item_icon=>'fa-calendar-chart'
,p_parent_list_item_id=>wwv_flow_api.id(92571532241240064)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2318824252499638)
,p_list_item_display_sequence=>10083
,p_list_item_link_text=>'Console'
,p_list_item_link_target=>'http://ifinance.dct.gov.ae:9600/console'
,p_list_item_icon=>'fa-feed'
,p_parent_list_item_id=>wwv_flow_api.id(2320309003532405)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2319521732510949)
,p_list_item_display_sequence=>10093
,p_list_item_link_text=>'Console (secure)'
,p_list_item_link_target=>'https://ifinance.dct.gov.ae:9601/console'
,p_list_item_icon=>'fa-lock-password'
,p_parent_list_item_id=>wwv_flow_api.id(2320309003532405)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2321034682555477)
,p_list_item_display_sequence=>10123
,p_list_item_link_text=>'Enterprise Manager (secure)'
,p_list_item_link_target=>'https://ifinance.dct.gov.ae:9601/em'
,p_list_item_icon=>'fa-hospital-o'
,p_parent_list_item_id=>wwv_flow_api.id(2320309003532405)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2321355642560894)
,p_list_item_display_sequence=>10133
,p_list_item_link_text=>'Enterprise Manager'
,p_list_item_link_target=>'http://ifinance.dct.gov.ae:9600/em'
,p_list_item_icon=>'fa-braille'
,p_parent_list_item_id=>wwv_flow_api.id(2320309003532405)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(93460050448150285)
,p_list_item_display_sequence=>10193
,p_list_item_link_text=>'Master Data'
,p_list_item_link_target=>'#'
,p_list_item_icon=>'fa-server'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':PERSON_ID = 680461'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(93486868349162659)
,p_list_item_display_sequence=>1130
,p_list_item_link_text=>'Vendors'
,p_list_item_link_target=>'f?p=&APP_ID.:37:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(93460050448150285)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'37,38'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(100337908595181570)
,p_list_item_display_sequence=>1150
,p_list_item_link_text=>'Vendor Bank Accounts'
,p_list_item_link_target=>'f?p=&APP_ID.:46:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(93460050448150285)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'46'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(100404685269597111)
,p_list_item_display_sequence=>1160
,p_list_item_link_text=>'Receiving'
,p_list_item_link_target=>'f?p=&APP_ID.:48:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(93460050448150285)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'48,49'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(100732439987203758)
,p_list_item_display_sequence=>1170
,p_list_item_link_text=>'AP Invoices'
,p_list_item_link_target=>'f?p=&APP_ID.:54:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(93460050448150285)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'54,55'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(108092140545425307)
,p_list_item_display_sequence=>10203
,p_list_item_link_text=>'Workflow'
,p_list_item_link_target=>'#'
,p_list_item_icon=>'fa-bolt'
,p_security_scheme=>wwv_flow_api.id(1688862454302373)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(38862947196600575)
,p_list_item_display_sequence=>1050
,p_list_item_link_text=>'Emails Control'
,p_list_item_link_target=>'f?p=&APP_ID.:22:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-comment-o'
,p_parent_list_item_id=>wwv_flow_api.id(108092140545425307)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'22,23'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(92069598843555992)
,p_list_item_display_sequence=>1100
,p_list_item_link_text=>'Approval Types'
,p_list_item_link_target=>'f?p=&APP_ID.:31:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-align-justify'
,p_parent_list_item_id=>wwv_flow_api.id(108092140545425307)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'31,32'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(108116169677365154)
,p_list_item_display_sequence=>1200
,p_list_item_link_text=>'Email Approval Records'
,p_list_item_link_target=>'f?p=&APP_ID.:62:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(108092140545425307)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'62,63'
);
wwv_flow_api.component_end;
end;
/
