prompt --application/pages/page_00000
begin
--   Manifest
--     PAGE: 00000
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>910
,p_default_id_offset=>82649548957193263
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>0
,p_user_interface_id=>wwv_flow_api.id(1686359760302353)
,p_name=>'Global Page - Desktop'
,p_step_title=>'Global Page - Desktop'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'D'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20211001105327'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1841113393558717)
,p_name=>'Show Notification and Profile'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
,p_display_when_type=>'CURRENT_PAGE_NOT_IN_CONDITION'
,p_display_when_cond=>'9999,9998'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1841228963558718)
,p_event_id=>wwv_flow_api.id(1841113393558717)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'PLUGIN_APEX.PROFILE.MENU'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'{',
'"buttonPosition": "right",',
'"iconPosition"  : "Left", ',
'"buttonType"    : "success"',
'}'))
,p_attribute_02=>'has-username'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'user_id,',
'first_name || '' '' || last_name  USERNAME,',
'--''http://s1defp1.dev.uae:7001/ords/dev/profile/view/'' || user_name IMAGE, ',
'case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'           when 0  THEN',
'                ''https://ifinance.dct.gov.ae:8004/dct/prod/ExtUser/view/'' || ''U0000''',
'            else  ',
'',
'           ''https://ifinance.dct.gov.ae:8004/dct/prod/ExtUser/view/'' || upper(e.user_name)',
'           end IMAGE  ,',
'--''f?p=&APP_ID.:41:&SESSION.::::'' EDIT_LINK, ',
'apex_util.prepare_url( ''f?p=''||:APP_ID||'':2:''||:APP_SESSION||''::NO::P2_USER_ID:''|| user_ID ) EDIT_LINK,',
'email EMAIL, ',
'MOBILE_SMS          PHONE_NO,',
'DESIGNATION         DESIGNATION,',
'DEPARTMENT          DEPARTMENT,',
'(Select v.vendor_name',
'from vendors v',
'where v.vendor_number = e.vendor_number',
'and v.vendor_site_code = e.vendor_site_code',
'and ROWNUM = 1) COMPANY',
'FROM dct_ext_users e',
'where user_name = :APP_USER;'))
,p_attribute_05=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6574900000184625)
,p_event_id=>wwv_flow_api.id(1841113393558717)
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
'    hrss_petty_cash_notifications',
'UNION All    ',
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
'    expense_reports_notifications_v;'))
,p_attribute_05=>'Y'
);
wwv_flow_api.component_end;
end;
/
