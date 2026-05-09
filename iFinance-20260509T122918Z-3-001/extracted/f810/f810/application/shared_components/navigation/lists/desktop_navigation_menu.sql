prompt --application/shared_components/navigation/lists/desktop_navigation_menu
begin
--   Manifest
--     LIST: Desktop Navigation Menu
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(12845212793762064)
,p_name=>'Desktop Navigation Menu'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(12993350098762246)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Home'
,p_list_item_link_target=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:'
,p_list_item_icon=>'fa-home'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(109801822096079659)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Missions'
,p_list_item_link_target=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-plane'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(109802267440078088)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Housing'
,p_list_item_link_target=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-hospital-o'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':PERSON_ID = 680461'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(5896597381189073)
,p_list_item_display_sequence=>160
,p_list_item_link_text=>'P&P Admin'
,p_list_item_link_target=>'f?p=&APP_ID.:37:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-users'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':IS_HR_ADMIN = ''Y'' or :PERSON_ID = 680461'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(545346244477724)
,p_list_item_display_sequence=>5
,p_list_item_link_text=>'Missions Exception'
,p_list_item_link_target=>'f?p=&APP_ID.:24:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-calendar-check-o'
,p_parent_list_item_id=>wwv_flow_api.id(5896597381189073)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'24,25'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(109954503612257486)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Mission Rates'
,p_list_item_link_target=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-money'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':IS_COMPENSATION_BENIFIT_YN = ''Y'' or :PERSON_ID = 680461'
,p_parent_list_item_id=>wwv_flow_api.id(5896597381189073)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'5,6'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(3294930109335891)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'SF Employees Data'
,p_list_item_link_target=>'f?p=&APP_ID.:34:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-user-circle'
,p_list_item_disp_cond_type=>'NEVER'
,p_parent_list_item_id=>wwv_flow_api.id(5896597381189073)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'34'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(4947664311918196)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Freelancers'
,p_list_item_link_target=>'f?p=&APP_ID.:35:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-address-book-o'
,p_list_item_disp_cond_type=>'NEVER'
,p_parent_list_item_id=>wwv_flow_api.id(5896597381189073)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'35,36'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(110362000917277685)
,p_list_item_display_sequence=>90
,p_list_item_link_text=>'Countries'
,p_list_item_link_target=>'f?p=&APP_ID.:16:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-bars'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':IS_COMPENSATION_BENIFIT_YN = ''Y'' or :PERSON_ID = 680461'
,p_parent_list_item_id=>wwv_flow_api.id(5896597381189073)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'16,17'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(78634764342882031)
,p_list_item_display_sequence=>190
,p_list_item_link_text=>'Declaration'
,p_list_item_link_target=>'f?p=&APP_ID.:39:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-bullhorn'
,p_parent_list_item_id=>wwv_flow_api.id(5896597381189073)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'39'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(78676291996947249)
,p_list_item_display_sequence=>200
,p_list_item_link_text=>'Payroll Vendors'
,p_list_item_link_target=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-envelope-check'
,p_parent_list_item_id=>wwv_flow_api.id(5896597381189073)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(78758692566613051)
,p_list_item_display_sequence=>210
,p_list_item_link_text=>'Payroll Areas'
,p_list_item_link_target=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-archive'
,p_parent_list_item_id=>wwv_flow_api.id(5896597381189073)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'40,41'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(79017204485738863)
,p_list_item_display_sequence=>220
,p_list_item_link_text=>'Employees'
,p_list_item_link_target=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:::'
,p_list_item_icon=>'fa-users'
,p_parent_list_item_id=>wwv_flow_api.id(5896597381189073)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'42'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(88765271606549530)
,p_list_item_display_sequence=>240
,p_list_item_link_text=>'Delegation Management'
,p_list_item_link_target=>'f?p=&APP_ID.:49:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-user-play'
,p_parent_list_item_id=>wwv_flow_api.id(5896597381189073)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(92505525739434201)
,p_list_item_display_sequence=>260
,p_list_item_link_text=>'Cost Centers By FBP'
,p_list_item_link_target=>'f?p=&APP_ID.:57:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-align-justify'
,p_parent_list_item_id=>wwv_flow_api.id(5896597381189073)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'57'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(92698209894951085)
,p_list_item_display_sequence=>280
,p_list_item_link_text=>'Invitation'
,p_list_item_link_target=>'f?p=&APP_ID.:59:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-comments-o'
,p_parent_list_item_id=>wwv_flow_api.id(5896597381189073)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'59'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(5896885986183774)
,p_list_item_display_sequence=>170
,p_list_item_link_text=>'Payroll Admin'
,p_list_item_link_target=>'f?p=&APP_ID.:38:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-user-check'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':IS_PAYROLL_ADMIN = ''Y'' or :PERSON_ID = 680461'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2864411566672720)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Payroll Vendors'
,p_list_item_link_target=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-user-man'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':IS_PAYROLL_ADMIN = ''Y'' or :PERSON_ID = 680461'
,p_parent_list_item_id=>wwv_flow_api.id(5896885986183774)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'21,29'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(86596995107595533)
,p_list_item_display_sequence=>230
,p_list_item_link_text=>'Delegation Management'
,p_list_item_link_target=>'f?p=&APP_ID.:49:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-user-play'
,p_parent_list_item_id=>wwv_flow_api.id(5896885986183774)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'49'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(91203688654343180)
,p_list_item_display_sequence=>250
,p_list_item_link_text=>'Payroll Dashboard'
,p_list_item_link_target=>'f?p=&APP_ID.:52:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-combo-chart'
,p_parent_list_item_id=>wwv_flow_api.id(5896885986183774)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'52'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(92534152220455517)
,p_list_item_display_sequence=>270
,p_list_item_link_text=>'Cost Center By FBP'
,p_list_item_link_target=>'f?p=&APP_ID.:57:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-align-justify'
,p_parent_list_item_id=>wwv_flow_api.id(5896885986183774)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(92725782886058885)
,p_list_item_display_sequence=>290
,p_list_item_link_text=>'Invitations'
,p_list_item_link_target=>'f?p=&APP_ID.:59:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-comments-o'
,p_parent_list_item_id=>wwv_flow_api.id(5896885986183774)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(96253749640027285)
,p_list_item_display_sequence=>300
,p_list_item_link_text=>'Projects Dashboard'
,p_list_item_link_target=>'f?p=&APP_ID.:65:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(5896885986183774)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'65'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(5901321627087039)
,p_list_item_display_sequence=>180
,p_list_item_link_text=>'System Admin'
,p_list_item_link_target=>'#'
,p_list_item_icon=>'fa-lock-user'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':PERSON_ID = 680461'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(12996454684767876)
,p_list_item_display_sequence=>60
,p_list_item_link_text=>'Insurance Statement'
,p_list_item_link_target=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:RP,2:::'
,p_list_item_icon=>'fa-align-justify'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':PERSON_ID = 680461'
,p_parent_list_item_id=>wwv_flow_api.id(5901321627087039)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'2'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(47932345248875886)
,p_list_item_display_sequence=>70
,p_list_item_link_text=>'Upload Payroll Elements'
,p_list_item_link_target=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.::::'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':PERSON_ID = 680461'
,p_parent_list_item_id=>wwv_flow_api.id(5901321627087039)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'7'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(1292050150674867)
,p_list_item_display_sequence=>110
,p_list_item_link_text=>'Default Options'
,p_list_item_link_target=>'f?p=&APP_ID.:26:&SESSION.::&DEBUG.::::'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':PERSON_ID = 680461'
,p_parent_list_item_id=>wwv_flow_api.id(5901321627087039)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'26,27'
);
wwv_flow_api.component_end;
end;
/
