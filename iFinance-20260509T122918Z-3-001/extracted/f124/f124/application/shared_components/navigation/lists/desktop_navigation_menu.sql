prompt --application/shared_components/navigation/lists/desktop_navigation_menu
begin
--   Manifest
--     LIST: Desktop Navigation Menu
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(127750204363449849)
,p_name=>'Desktop Navigation Menu'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(127910407170449635)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Home'
,p_list_item_link_target=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:'
,p_list_item_icon=>'fa-home'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(11642207938478276)
,p_list_item_display_sequence=>280
,p_list_item_link_text=>'Demand Planning Dashboard'
,p_list_item_link_target=>'f?p=&APP_ID.:76:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-line-area-chart'
,p_list_item_disp_cond_type=>'FUNCTION_BODY'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :IS_IFINANCE_ADMIN = ''Y''  OR :IS_VIEW_ALL_DP_ITEMS > ''Y''',
'then return true;',
'else return false;',
'end if;',
''))
,p_parent_list_item_id=>wwv_flow_api.id(127910407170449635)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'76'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(127992338674449390)
,p_list_item_display_sequence=>60
,p_list_item_link_text=>'Demand Planning Items'
,p_list_item_link_target=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-dial-gauge-chart'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(138430800905940727)
,p_list_item_display_sequence=>70
,p_list_item_link_text=>'Scoping documents'
,p_list_item_link_target=>'f?p=&APP_ID.:64:&SESSION.::&DEBUG.:RP:::'
,p_list_item_icon=>'fa-clipboard-chart '
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(129653302962798930)
,p_list_item_display_sequence=>80
,p_list_item_link_text=>'System Admin'
,p_list_item_link_target=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-gears'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':IS_DP_ADMIN = ''Y'' or :IS_IFINANCE_ADMIN = ''Y'''
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(127911920872449633)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'System Settings'
,p_list_item_link_target=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-gear'
,p_parent_list_item_id=>wwv_flow_api.id(129653302962798930)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(127966860646449422)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Budget Brackets'
,p_list_item_link_target=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-table-ban'
,p_parent_list_item_id=>wwv_flow_api.id(129653302962798930)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(127936709566449469)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Item Categories'
,p_list_item_link_target=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-clipboard-list'
,p_parent_list_item_id=>wwv_flow_api.id(129653302962798930)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(112467511593793793)
,p_list_item_display_sequence=>35
,p_list_item_link_text=>'Delegation Management'
,p_list_item_link_target=>'f?p=&APP_ID.:88:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-bullhorn'
,p_parent_list_item_id=>wwv_flow_api.id(129653302962798930)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'88'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(128939869201756453)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Item Categories & Roles'
,p_list_item_link_target=>'f?p=&APP_ID.:16:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-lock-user'
,p_list_item_disp_cond_type=>'NEVER'
,p_parent_list_item_id=>wwv_flow_api.id(129653302962798930)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'16'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(127990724490449391)
,p_list_item_display_sequence=>50
,p_list_item_link_text=>'Manage Lookups'
,p_list_item_link_target=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-align-justify'
,p_list_item_disp_cond_type=>'NEVER'
,p_parent_list_item_id=>wwv_flow_api.id(129653302962798930)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(7333904136705130)
,p_list_item_display_sequence=>120
,p_list_item_link_text=>'Demand Planning SLA (Amount)'
,p_list_item_link_target=>'f?p=&APP_ID.:72:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-medkit'
,p_parent_list_item_id=>wwv_flow_api.id(129653302962798930)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'72,73'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(136695609304098290)
,p_list_item_display_sequence=>200
,p_list_item_link_text=>'Scoping Admin'
,p_list_item_icon=>'fa-keyboard-o'
,p_parent_list_item_id=>wwv_flow_api.id(129653302962798930)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(136713223161082648)
,p_list_item_display_sequence=>210
,p_list_item_link_text=>'Appendixes'
,p_list_item_link_target=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-align-justify'
,p_parent_list_item_id=>wwv_flow_api.id(136695609304098290)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'21,22'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(136744861901994935)
,p_list_item_display_sequence=>220
,p_list_item_link_text=>'Appendix Components'
,p_list_item_link_target=>'f?p=&APP_ID.:23:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(136695609304098290)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'23,24'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(136822753911989438)
,p_list_item_display_sequence=>230
,p_list_item_link_text=>'Scoping Templates'
,p_list_item_link_target=>'f?p=&APP_ID.:25:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(136695609304098290)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'25,26'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(139619634743195950)
,p_list_item_display_sequence=>240
,p_list_item_link_text=>'Data Points All'
,p_list_item_link_target=>'f?p=&APP_ID.:40:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(136695609304098290)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'40,41'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(140437011272497667)
,p_list_item_display_sequence=>250
,p_list_item_link_text=>'KPIs Templates'
,p_list_item_link_target=>'f?p=&APP_ID.:45:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(136695609304098290)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'45,46'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(1868490113684164)
,p_list_item_display_sequence=>260
,p_list_item_link_text=>'Procurement Methods'
,p_list_item_link_target=>'f?p=&APP_ID.:61:&SESSION.::&DEBUG.::::'
,p_parent_list_item_id=>wwv_flow_api.id(136695609304098290)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'61,62'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(138347508904572715)
,p_list_item_display_sequence=>290
,p_list_item_link_text=>'Manage User Roles'
,p_list_item_link_target=>'f?p=&APP_ID.:79:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-user-edit'
,p_parent_list_item_id=>wwv_flow_api.id(129653302962798930)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'79,80'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(122811350854653600)
,p_list_item_display_sequence=>300
,p_list_item_link_text=>'Project Status Definitions'
,p_list_item_link_target=>'f?p=&APP_ID.:82:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-info-square-o'
,p_parent_list_item_id=>wwv_flow_api.id(129653302962798930)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'82,83'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(128274012594449039)
,p_list_item_display_sequence=>10000
,p_list_item_link_text=>'Administration'
,p_list_item_link_target=>'f?p=&APP_ID.:10000:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-user-wrench'
,p_list_item_disp_cond_type=>'PLSQL_EXPRESSION'
,p_list_item_disp_condition=>':PERSON_ID = 680461'
,p_security_scheme=>wwv_flow_api.id(127892615645449686)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.component_end;
end;
/
