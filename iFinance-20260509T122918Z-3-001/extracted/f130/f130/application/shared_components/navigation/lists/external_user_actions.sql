prompt --application/shared_components/navigation/lists/external_user_actions
begin
--   Manifest
--     LIST: External User Actions
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(10744838479091923)
,p_name=>'External User Actions'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(10745074089091924)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Projects Access'
,p_list_item_link_target=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.::P10_PERSON_ID,P10_FULL_NAME:&P6_USER_ID.,&P6_FULL_NAME_EN.:'
,p_list_item_icon=>'fa-bars'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(10745479520091925)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Contracts Access'
,p_list_item_link_target=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.::P12_PERSON_ID,P12_FULL_NAME:&P6_USER_ID.,&P6_FULL_NAME_EN.:'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(10745851555091925)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Send Invitation'
,p_list_item_link_target=>'f?p=&APP_ID.:48:&SESSION.::&DEBUG.:48:P48_EMAIL,P48_NAME,P48_TITLE,P48_USER_ID,P48_USER_NAME:&P6_EMAIL.,&P6_FULL_NAME_EN.,&P6_TITLE.,&P6_USER_ID.,&P6_USER_NAME.:'
,p_list_item_icon=>'fa-send-o'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(10746234619091925)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Recommendations'
,p_list_item_link_target=>'f?p=&APP_ID.::&APP_SESSION.::&DEBUG.:::'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.component_end;
end;
/
