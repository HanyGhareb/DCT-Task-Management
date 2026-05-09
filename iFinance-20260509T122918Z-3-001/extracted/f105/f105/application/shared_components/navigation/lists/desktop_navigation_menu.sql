prompt --application/shared_components/navigation/lists/desktop_navigation_menu
begin
--   Manifest
--     LIST: Desktop Navigation Menu
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(99703918296410717)
,p_name=>'Desktop Navigation Menu'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(99854908013410835)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Home'
,p_list_item_link_target=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:'
,p_list_item_icon=>'fa-home'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(38106248784502)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Project access Requests'
,p_list_item_link_target=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-key'
,p_parent_list_item_id=>wwv_flow_api.id(99854908013410835)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'2'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(205141906680114)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Budget Transfer requests'
,p_list_item_link_target=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-arrows-h'
,p_parent_list_item_id=>wwv_flow_api.id(99854908013410835)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'6'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(775557070099478)
,p_list_item_display_sequence=>200
,p_list_item_link_text=>'Strategy Planning'
,p_list_item_icon=>'fa-apex'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':IS_BUDGET_PLANNING_YN = ''Y'' or :IS_IFINANCE_ADMIN = ''Y'' or :IS_FBP_EMP = ''Y'' OR :IS_BTF_QUERY_YN = ''Y'''
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(815484714211910)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Objectives'
,p_list_item_link_target=>'f?p=&APP_ID.:16:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-circle-arrow-in-ne'
,p_parent_list_item_id=>wwv_flow_api.id(775557070099478)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'16,17'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(49959139386921154)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Programs'
,p_list_item_link_target=>'f?p=&APP_ID.:91:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-mobile'
,p_parent_list_item_id=>wwv_flow_api.id(775557070099478)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'91,92'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(771236814088065)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Initiatives'
,p_list_item_link_target=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-flashlight'
,p_parent_list_item_id=>wwv_flow_api.id(775557070099478)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'14,15'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(1162622255265090)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Projects'
,p_list_item_link_target=>'f?p=&APP_ID.:19:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-server-file'
,p_parent_list_item_id=>wwv_flow_api.id(775557070099478)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'19'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(55324480496058593)
,p_list_item_display_sequence=>205
,p_list_item_link_text=>'Budget Proposal'
,p_list_item_link_target=>'#'
,p_list_item_icon=>'fa-line-chart'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(54294061546658905)
,p_list_item_display_sequence=>990
,p_list_item_link_text=>'Budget Proposal Plans'
,p_list_item_link_target=>'f?p=&APP_ID.:84:&SESSION.::&DEBUG.::::'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_IFINANCE_ADMIN = ''Y''',
'OR :IS_BUDGET_PLANNING_YN = ''Y'''))
,p_parent_list_item_id=>wwv_flow_api.id(55324480496058593)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'84'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(49722265549526590)
,p_list_item_display_sequence=>1020
,p_list_item_link_text=>'Sector Planner'
,p_list_item_link_target=>'f?p=&APP_ID.:95:&SESSION.::&DEBUG.::::'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_IFINANCE_ADMIN = ''Y''',
'OR :IS_BUDGET_PLANNING_YN = ''Y''',
'OR :IS_SECTOR_PLANNER_YN = ''Y'''))
,p_parent_list_item_id=>wwv_flow_api.id(55324480496058593)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'95'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(49706763519512178)
,p_list_item_display_sequence=>1030
,p_list_item_link_text=>'Cost Center Planner'
,p_list_item_link_target=>'f?p=&APP_ID.:96:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(55324480496058593)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'96'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(70966855918707148)
,p_list_item_display_sequence=>210
,p_list_item_link_text=>'Budget Allocation'
,p_list_item_link_target=>'#'
,p_list_item_icon=>'fa-braille'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':PERSON_ID = 680461'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(70937438802791707)
,p_list_item_display_sequence=>910
,p_list_item_link_text=>'Budget Allocation Plans'
,p_list_item_link_target=>'f?p=&APP_ID.:58:&SESSION.::&DEBUG.:84,85,92,97,96,105:::'
,p_parent_list_item_id=>wwv_flow_api.id(70966855918707148)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'58,59'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(64835429254013123)
,p_list_item_display_sequence=>930
,p_list_item_link_text=>'Sector Planners'
,p_list_item_link_target=>'f?p=&APP_ID.:63:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(70966855918707148)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'63'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(64675463395592913)
,p_list_item_display_sequence=>940
,p_list_item_link_text=>'Cost Centers Planners'
,p_list_item_link_target=>'f?p=&APP_ID.:66:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(70966855918707148)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'66'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(63638707741251636)
,p_list_item_display_sequence=>950
,p_list_item_link_text=>'Projects Planners'
,p_list_item_link_target=>'f?p=&APP_ID.:73:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(70966855918707148)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'73'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(64423723626911852)
,p_list_item_display_sequence=>220
,p_list_item_link_text=>'Cashflow'
,p_list_item_link_target=>'f?p=&APP_ID.:68:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-table-chart'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':PERSON_ID in (680461, ',
'               1635329, --nupur',
'               655299,  -- Mariam Awad',
'               726423,   -- Saleh',
'               128067,  -- Mai',
'               276890,   -- Mariam Alhosani',
'128114',
'               )  ',
' OR',
':IS_BUDGET_PLANNING_YN = ''Y'' OR',
':IS_FBP_EMP = ''Y'' OR',
':IS_IFINANCE_ADMIN = ''Y'''))
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'68,86'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(59069599281790224)
,p_list_item_display_sequence=>221
,p_list_item_link_text=>'Overall'
,p_list_item_link_target=>'f?p=&APP_ID.:68:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-sitemap'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':PERSON_ID = 680461 OR',
':IS_BUDGET_PLANNING_YN = ''Y'' OR',
':IS_FBP_EMP = ''Y'' OR',
':IS_IFINANCE_ADMIN = ''Y'''))
,p_parent_list_item_id=>wwv_flow_api.id(64423723626911852)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(59069323362784104)
,p_list_item_display_sequence=>222
,p_list_item_link_text=>'Sectors'
,p_list_item_icon=>'fa-industry'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':PERSON_ID = 680461 OR',
':IS_BUDGET_PLANNING_YN = ''Y'' OR',
':IS_FBP_EMP = ''Y'' OR',
':IS_IFINANCE_ADMIN = ''Y'' OR',
':IS_SECTOR_PLANNER_YN = ''Y'''))
,p_parent_list_item_id=>wwv_flow_api.id(64423723626911852)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(59069031214776253)
,p_list_item_display_sequence=>223
,p_list_item_link_text=>'Department'
,p_list_item_icon=>'fa-window'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':PERSON_ID = 680461 OR',
':IS_BUDGET_PLANNING_YN = ''Y'' OR',
':IS_COST_CENTER_PLANNER_YN = ''Y'' OR',
':IS_FBP_EMP = ''Y'' OR',
':IS_IFINANCE_ADMIN = ''Y'''))
,p_parent_list_item_id=>wwv_flow_api.id(64423723626911852)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(59068644514769388)
,p_list_item_display_sequence=>224
,p_list_item_link_text=>'Project'
,p_list_item_icon=>'fa-rocket'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':PERSON_ID = 680461 OR',
':IS_BUDGET_PLANNING_YN = ''Y'' OR',
':IS_FBP_EMP = ''Y'' OR',
':IS_IFINANCE_ADMIN = ''Y'' OR',
':IS_PROJECT_PLANNER_YN = ''Y'''))
,p_parent_list_item_id=>wwv_flow_api.id(64423723626911852)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(51819615710925802)
,p_list_item_display_sequence=>1000
,p_list_item_link_text=>'GL Cashflow'
,p_list_item_link_target=>'f?p=&APP_ID.:86:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(64423723626911852)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'86'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(1995975192457855)
,p_list_item_display_sequence=>300
,p_list_item_link_text=>'FBP Admin'
,p_list_item_link_target=>'#'
,p_list_item_icon=>'fa-user-lock'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':IS_BUDGET_PLANNING_YN = ''Y'' or :IS_IFINANCE_ADMIN = ''Y'' or :IS_FBP_EMP = ''Y'' OR :IS_BTF_QUERY_YN = ''Y'' or :PERSON_ID = 661109'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(1997874133433018)
,p_list_item_display_sequence=>50
,p_list_item_link_text=>'FBP By Cost Centers'
,p_list_item_link_target=>'f?p=&APP_ID.:22:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(1995975192457855)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'22'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2008313328424373)
,p_list_item_display_sequence=>60
,p_list_item_link_text=>'Cost Centers Directors'
,p_list_item_link_target=>'f?p=&APP_ID.:23:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(1995975192457855)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'23'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2020578831418796)
,p_list_item_display_sequence=>70
,p_list_item_link_text=>'Cost Centers Exec Directors'
,p_list_item_link_target=>'f?p=&APP_ID.:24:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(1995975192457855)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'24'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(105315404129748263)
,p_list_item_display_sequence=>80
,p_list_item_link_text=>'Manage Projects Access'
,p_list_item_link_target=>'f?p=&APP_ID.:26:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(1995975192457855)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'26,27'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(104973211550139196)
,p_list_item_display_sequence=>90
,p_list_item_link_text=>'Tasks Approvers'
,p_list_item_link_target=>'f?p=&APP_ID.:28:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(1995975192457855)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'28,29'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(104399931594195022)
,p_list_item_display_sequence=>100
,p_list_item_link_text=>'Delegation Management'
,p_list_item_link_target=>'f?p=&APP_ID.:30:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(1995975192457855)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'30'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(100749084975135489)
,p_list_item_display_sequence=>110
,p_list_item_link_text=>'Projects Approvers'
,p_list_item_link_target=>'f?p=&APP_ID.:32:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(1995975192457855)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'32'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(95251609204426823)
,p_list_item_display_sequence=>130
,p_list_item_link_text=>'Projects Balances'
,p_list_item_link_target=>'f?p=&APP_ID.:41:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(1995975192457855)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'41'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(82747921233219924)
,p_list_item_display_sequence=>150
,p_list_item_link_text=>'BTF Setting'
,p_list_item_link_target=>'f?p=&APP_ID.:51:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(1995975192457855)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'51,52'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(68220817232187218)
,p_list_item_display_sequence=>920
,p_list_item_link_text=>'Set Accounting Year'
,p_list_item_link_target=>'f?p=&APP_ID.:62:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(1995975192457855)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'62'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(10291711422719820)
,p_list_item_display_sequence=>1110
,p_list_item_link_text=>'Manage Cost Centers Ceiling'
,p_list_item_link_target=>'f?p=&APP_ID.:125:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(1995975192457855)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'125,126'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(44126714761358441)
,p_list_item_display_sequence=>10020
,p_list_item_link_text=>'Cost Centers Planners'
,p_list_item_link_target=>'f?p=&APP_ID.:77:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-cc'
,p_parent_list_item_id=>wwv_flow_api.id(1995975192457855)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(44125652898351283)
,p_list_item_display_sequence=>10030
,p_list_item_link_text=>'SPM Planners'
,p_list_item_link_target=>'f?p=&APP_ID.:94:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-layout-nav-left-header-cards'
,p_parent_list_item_id=>wwv_flow_api.id(1995975192457855)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(99870721074882872)
,p_list_item_display_sequence=>400
,p_list_item_link_text=>'Reports'
,p_list_item_link_target=>'#'
,p_list_item_icon=>'fa-combo-chart'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':PERSON_ID in (680461,942974,726423, 585407, 127595, 747343) or :IS_BUDGET_PLANNING_YN = ''Y'' or :IS_FBP_EMP = ''Y'' or :IS_BTF_QUERY_YN	= ''Y'''
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(99870310412894353)
,p_list_item_display_sequence=>120
,p_list_item_link_text=>'Budget Transfers Requests'
,p_list_item_link_target=>'f?p=&APP_ID.:34:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-random'
,p_parent_list_item_id=>wwv_flow_api.id(99870721074882872)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'34'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(88297779829047864)
,p_list_item_display_sequence=>140
,p_list_item_link_text=>'Initiatives With Projects'
,p_list_item_link_target=>'f?p=&APP_ID.:45:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-train'
,p_parent_list_item_id=>wwv_flow_api.id(99870721074882872)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'45'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(38456288105166150)
,p_list_item_display_sequence=>1060
,p_list_item_link_text=>'Budget Proposal Line Details'
,p_list_item_link_target=>'f?p=&APP_ID.:121:&SESSION.::&DEBUG.:121:::'
,p_parent_list_item_id=>wwv_flow_api.id(99870721074882872)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'121'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(38386993006743507)
,p_list_item_display_sequence=>1070
,p_list_item_link_text=>'Budget Proposal Plan By Cost Center'
,p_list_item_link_target=>'f?p=&APP_ID.:122:&SESSION.::&DEBUG.:122:::'
,p_parent_list_item_id=>wwv_flow_api.id(99870721074882872)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'122'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(37680556623248288)
,p_list_item_display_sequence=>1080
,p_list_item_link_text=>'Budget Proposal Plan Documents'
,p_list_item_link_target=>'f?p=&APP_ID.:117:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-file-pdf-o'
,p_parent_list_item_id=>wwv_flow_api.id(99870721074882872)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'117'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(71115095662150793)
,p_list_item_display_sequence=>900
,p_list_item_link_text=>'System Admin'
,p_list_item_link_target=>'#'
,p_list_item_icon=>'fa-gears'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':PERSON_ID in ( 680461, 1637996,1641990 , 726423)'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(71095379983163598)
,p_list_item_display_sequence=>160
,p_list_item_link_text=>'Budget Allocation Roles'
,p_list_item_link_target=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-angle-double-right'
,p_parent_list_item_id=>wwv_flow_api.id(71115095662150793)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'54,55'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(63370761202055681)
,p_list_item_display_sequence=>960
,p_list_item_link_text=>'Sectors Planners'
,p_list_item_link_target=>'f?p=&APP_ID.:75:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-number-1-o'
,p_parent_list_item_id=>wwv_flow_api.id(71095379983163598)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'75,76'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(63349739265501933)
,p_list_item_display_sequence=>970
,p_list_item_link_text=>'Cost Centers Planners'
,p_list_item_link_target=>'f?p=&APP_ID.:77:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-number-2-o'
,p_parent_list_item_id=>wwv_flow_api.id(71095379983163598)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'77'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(63325459610493123)
,p_list_item_display_sequence=>980
,p_list_item_link_text=>'Projects Planners'
,p_list_item_link_target=>'f?p=&APP_ID.:79:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-number-3-o'
,p_parent_list_item_id=>wwv_flow_api.id(71095379983163598)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'79'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(48507905967360713)
,p_list_item_display_sequence=>1050
,p_list_item_link_text=>'Strategy Planning Approvers'
,p_list_item_link_target=>'f?p=&APP_ID.:94:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-number-4-o'
,p_parent_list_item_id=>wwv_flow_api.id(71095379983163598)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'94'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(71070710625421847)
,p_list_item_display_sequence=>170
,p_list_item_link_text=>'GL Chart of Accounts'
,p_list_item_link_target=>'f?p=&APP_ID.:56:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-tree-org'
,p_parent_list_item_id=>wwv_flow_api.id(71115095662150793)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'56'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(99996899337411051)
,p_list_item_display_sequence=>10000
,p_list_item_link_text=>'Administration'
,p_list_item_link_target=>'f?p=&APP_ID.:10000:&APP_SESSION.::&DEBUG.:'
,p_list_item_icon=>'fa-user-wrench'
,p_security_scheme=>wwv_flow_api.id(99846241914410815)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(51648378979746548)
,p_list_item_display_sequence=>10010
,p_list_item_link_text=>'Chart of Account'
,p_list_item_link_target=>'#'
,p_list_item_icon=>'fa-tree'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':PERSON_ID = 680461'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(51648000049727590)
,p_list_item_display_sequence=>1010
,p_list_item_link_text=>'Chart of Accounts'
,p_list_item_link_target=>'f?p=&APP_ID.:87:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(51648378979746548)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'87'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(15939249155522517)
,p_list_item_display_sequence=>1090
,p_list_item_link_text=>'Manage Cost Centers'
,p_list_item_link_target=>'f?p=&APP_ID.:119:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(51648378979746548)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'119,120'
);
wwv_flow_api.component_end;
end;
/
