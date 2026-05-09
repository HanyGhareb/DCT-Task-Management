prompt --application/pages/page_00000
begin
--   Manifest
--     PAGE: 00000
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>110
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>0
,p_user_interface_id=>wwv_flow_api.id(13327188105480887)
,p_name=>'Global Page - Desktop'
,p_step_title=>'Global Page - Desktop'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'D'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210113062753'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(18933284648243907)
,p_name=>'Show Notification'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
,p_display_when_type=>'CURRENT_PAGE_NOT_EQUAL_CONDITION'
,p_display_when_cond=>'9999'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(18933388953243908)
,p_event_id=>wwv_flow_api.id(18933284648243907)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'PLUGIN_APEX.NOTIFICATION'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'{',
'    "refresh": 0,',
'    "mainIcon": "fa-bell",',
'    "mainIconColor": "white",',
'    "mainIconBackgroundColor": "rgba(70,70,70,0.9)",',
'    "mainIconBlinking": false,',
'    "counterBackgroundColor": "rgb(232, 55, 55 )",',
'    "counterFontColor": "white",',
'    "linkTargetBlank": false,',
'    "showAlways": false,',
'    "browserNotifications": {',
'        "enabled": true,',
'        "cutBodyTextAfter": 100,',
'        "link": false',
'    },',
'    "accept": {',
'        "color": "#44e55c",',
'        "icon": "fa-check"',
'    },',
'    "decline": {',
'        "color": "#b73a21",',
'        "icon": "fa-close"',
'    },',
'    "hideOnRefresh": true',
'}'))
,p_attribute_02=>'notification-menu'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    note_icon,',
'    note_icon_color,',
'    note_header,',
'    note_text,',
'    note_link,',
'    note_color,',
'    note_accept,',
'    note_decline,',
'    no_browser_notification',
'FROM',
'    APPROVED_BUDGET_NOTIFICATIONS_V;'))
,p_attribute_05=>'Y'
);
wwv_flow_api.component_end;
end;
/
