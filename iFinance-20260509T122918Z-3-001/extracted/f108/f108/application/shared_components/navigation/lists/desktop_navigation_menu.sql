prompt --application/shared_components/navigation/lists/desktop_navigation_menu
begin
--   Manifest
--     LIST: Desktop Navigation Menu
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>500
,p_default_id_offset=>354480484490134169
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(19141048772383304)
,p_name=>'Desktop Navigation Menu'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(19289090797383471)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Home'
,p_list_item_link_target=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:'
,p_list_item_icon=>'fa-home'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(22692026652572673)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'MPR Admin'
,p_list_item_icon=>'fa-user-wrench'
,p_list_item_disp_cond_type=>'EXISTS'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1',
'from DCT_DATA_ACCESS_ASSIGNMENT',
'where entity_id in (36)    -- (36 MPR Admin, 32 Budget Planning, 30 Sourcing Manager, 31 Supply Management Unit Heads)',
'and person_id = :PERSON_ID',
'and status = ''A''',
'and sysdate between start_date and nvl(end_date , sysdate+ 100);'))
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(19527735195708967)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Procurement Methods'
,p_list_item_link_target=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-universal-access'
,p_list_item_disp_cond_type=>'EXISTS'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1',
'from DCT_DATA_ACCESS_ASSIGNMENT',
'where entity_id in (36)    -- (36 MPR Admin, 32 Budget Planning, 30 Sourcing Manager, 31 Supply Management Unit Heads)',
'and person_id = :PERSON_ID',
'and status = ''A''',
'and sysdate between start_date and nvl(end_date , sysdate+ 100);'))
,p_parent_list_item_id=>wwv_flow_api.id(22692026652572673)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'3'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(22694652528598560)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Manage PBP'
,p_list_item_link_target=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-unlock'
,p_parent_list_item_id=>wwv_flow_api.id(22692026652572673)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'8'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(22711400712692130)
,p_list_item_display_sequence=>50
,p_list_item_link_text=>'DTBP By Cost Center'
,p_list_item_link_target=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-user-headset'
,p_parent_list_item_id=>wwv_flow_api.id(22692026652572673)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'9'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(22749713872954719)
,p_list_item_display_sequence=>60
,p_list_item_link_text=>'MPR Invitation'
,p_list_item_link_target=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-comments-o fa-anim-flash'
,p_parent_list_item_id=>wwv_flow_api.id(22692026652572673)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'10'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(26090477297987704)
,p_list_item_display_sequence=>110
,p_list_item_link_text=>'MPR Delegation Requests'
,p_list_item_link_target=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.:13:::'
,p_parent_list_item_id=>wwv_flow_api.id(22692026652572673)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'13'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(4795045407002901)
,p_list_item_display_sequence=>130
,p_list_item_link_text=>'Pending PRs Reminder'
,p_list_item_link_target=>'f?p=&APP_ID.:16:&SESSION.::&DEBUG.:16:::'
,p_list_item_icon=>'fa-send-o'
,p_parent_list_item_id=>wwv_flow_api.id(22692026652572673)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'16'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(4415651626696748)
,p_list_item_display_sequence=>140
,p_list_item_link_text=>'Pending POs Reminder'
,p_list_item_link_target=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-rss-square'
,p_parent_list_item_id=>wwv_flow_api.id(22692026652572673)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'21'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2261193051834788)
,p_list_item_display_sequence=>150
,p_list_item_link_text=>'Pending AP GRN'
,p_list_item_link_target=>'f?p=&APP_ID.:26:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-calendar-minus-o'
,p_parent_list_item_id=>wwv_flow_api.id(22692026652572673)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'26,27'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(56716188421755118)
,p_list_item_display_sequence=>160
,p_list_item_link_text=>'Employees Messages'
,p_list_item_link_target=>'f?p=&APP_ID.:36:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_api.id(22692026652572673)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'36'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(23012010643270756)
,p_list_item_display_sequence=>70
,p_list_item_link_text=>'FBP Admin (Admin)'
,p_list_item_icon=>'fa-desktop'
,p_list_item_disp_cond_type=>'EXISTS'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select *',
'from DCT_DATA_ACCESS_ASSIGNMENT',
'where entity_id in (36,38)    -- (38 MPR FBP Admin)',
'and person_id = :PERSON_ID',
'and status = ''A''',
'and sysdate between start_date and nvl(end_date , sysdate+ 100);'))
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(23012589218252958)
,p_list_item_display_sequence=>80
,p_list_item_link_text=>'MPR Invitations'
,p_list_item_link_target=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-comments-o fa-anim-flash'
,p_parent_list_item_id=>wwv_flow_api.id(23012010643270756)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'10'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(23014161137231525)
,p_list_item_display_sequence=>90
,p_list_item_link_text=>'FBP By Cost Centers'
,p_list_item_link_target=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-user-headset'
,p_parent_list_item_id=>wwv_flow_api.id(23012010643270756)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'12'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(26109927524822424)
,p_list_item_display_sequence=>120
,p_list_item_link_text=>'MPR Delegation Requests-FBP'
,p_list_item_link_target=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.:13:::'
,p_parent_list_item_id=>wwv_flow_api.id(23012010643270756)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'13'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(23176085742799830)
,p_list_item_display_sequence=>100
,p_list_item_link_text=>'MPR Invitation - FBP'
,p_list_item_link_target=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-comments-o fa-anim-flash'
,p_list_item_disp_cond_type=>'EXISTS'
,p_list_item_disp_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select *',
'from cost_centers_fbp c',
'where c.bp_type = ''FBP''',
'and c.status = ''A''',
'and sysdate BETWEEN c.start_date and nvl(c.end_date,sysdate+1)',
'and c.person_id = :PERSON_ID;'))
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'10'
);
wwv_flow_api.component_end;
end;
/
