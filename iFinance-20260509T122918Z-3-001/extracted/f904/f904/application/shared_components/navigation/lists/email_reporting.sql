prompt --application/shared_components/navigation/lists/email_reporting
begin
--   Manifest
--     LIST: Email Reporting
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(21559168707648976)
,p_name=>'Email Reporting'
,p_list_status=>'PUBLIC'
,p_required_patch=>wwv_flow_api.id(21548070294648944)
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(21559535560648976)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Email Reporting'
,p_list_item_link_target=>'f?p=&APP_ID.:10090:&SESSION.::&DEBUG.:10090:::'
,p_list_item_icon=>'fa-area-chart'
,p_list_text_01=>'Report of all email queued to be sent and those already sent'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.component_end;
end;
/
