prompt --application/shared_components/navigation/lists/external_user_actions
begin
--   Manifest
--     LIST: External User Actions
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>666
,p_default_id_offset=>90826491306730853
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(11449013460431254)
,p_name=>'External User Actions'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(11449244569431255)
,p_list_item_display_sequence=>5
,p_list_item_link_text=>'Payments Recommendation'
,p_list_item_link_target=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.::P4_CONTRACT_NUMBER,P4_FROM_PAGE:&P3_CONTRACT_NUMBER.,3:'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(11449671230431255)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Interim Payment Certificate'
,p_list_item_link_target=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.::P30_CONTRACT_NUMBER:&P3_CONTRACT_NUMBER.:'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(11450056502431255)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Service Request'
,p_list_item_link_target=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.::P10_CONTRACT_NUMBER:&P3_CONTRACT_NUMBER.:'
,p_list_item_icon=>'fa-wrench'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.component_end;
end;
/
