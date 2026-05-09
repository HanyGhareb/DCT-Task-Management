prompt --application/shared_components/navigation/lists/feedback
begin
--   Manifest
--     LIST: Feedback
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>805
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(36276601356522696)
,p_name=>'Feedback'
,p_list_status=>'PUBLIC'
,p_required_patch=>wwv_flow_api.id(36117728715523052)
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(36277074819522696)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Feedback Settings'
,p_list_item_link_target=>'f?p=&APP_ID.:10052:&SESSION.::&DEBUG.:10052:::'
,p_list_item_icon=>'fa-envelope-user'
,p_list_text_01=>'Manage if attachments should be allowed.'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(36277400795522696)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'User Feedback'
,p_list_item_link_target=>'f?p=&APP_ID.:10053:&SESSION.::&DEBUG.:10053:::'
,p_list_item_icon=>'fa-comment-o'
,p_list_text_01=>'Report of all feedback submitted by application users'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.component_end;
end;
/
