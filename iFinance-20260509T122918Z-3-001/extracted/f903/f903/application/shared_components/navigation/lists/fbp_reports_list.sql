prompt --application/shared_components/navigation/lists/fbp_reports_list
begin
--   Manifest
--     LIST: FBP Reports List
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>114
,p_default_id_offset=>9604171250607172
,p_default_owner=>'DEV'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(77210670508194457)
,p_name=>'FBP Reports List'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(77210887040194458)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Review My System Access'
,p_list_item_link_target=>'f?p=&APP_ID.:28:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-universal-access fa-lg'
,p_list_text_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'All Transfer Requests By Project (Tabular).',
''))
,p_list_text_02=>'chartIcon'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(77211240088194459)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Transfer Requests By Status'
,p_list_item_link_target=>'f?p=&APP_ID.:28:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-sun-o'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(77211673955194459)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Project Analysis'
,p_list_item_link_target=>'f?p=&APP_ID.:28:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-bar-chart fa-anim-flash fam-play fam-is-success'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(77212087293194459)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Transfer By Purpose Analysis'
,p_list_item_link_target=>'f?p=&APP_ID.:28:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-dial-gauge-chart fa-anim-flash'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(77212488054194459)
,p_list_item_display_sequence=>50
,p_list_item_link_text=>'Transfer Requests By Purpose Analysis'
,p_list_item_icon=>'fa-tasks fa-anim-flash'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.component_end;
end;
/
