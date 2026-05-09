prompt --application/pages/page_00000
begin
--   Manifest
--     PAGE: 00000
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>116
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>0
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Global Page - Desktop'
,p_step_title=>'Global Page - Desktop'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'D'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220316184505'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(99608331711293904)
,p_name=>'Show Notification DA'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
,p_display_when_type=>'CURRENT_PAGE_NOT_EQUAL_CONDITION'
,p_display_when_cond=>'9999'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(99608410896293905)
,p_event_id=>wwv_flow_api.id(99608331711293904)
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
'SELECT /* sets the icon of the list item */',
'    ''fa-exclamation-triangle'' AS NOTE_ICON, ',
'    /* sets the color of the list icon */',
'    ''rgb(192,0,15)'' AS NOTE_ICON_COLOR, ',
'    /* sets the title of the list item (html possible) */',
'    ''Alarm occurred'' AS NOTE_HEADER,',
'    /* sets the text of the list item (html possible */',
'    ''There''''s an alarm in <b>Station 3</b>. Error code is <b style="color:rgba(192,0,15);">#304-AD. </b>'' AS NOTE_TEXT, ',
'    /* set the link when click on list item */',
'    ''javascript:alert("Click on Notification Entry");void(0);'' AS NOTE_LINK, ',
'    /* sets the color of the left box shadow */',
'    ''rgb(192,0,15)'' AS NOTE_COLOR,',
'    /* Link or js that is executed when press accept link (if left or null not accept is shown */ ',
'    ''javascript:alert("Accepted");void(0);'' AS NOTE_ACCEPT,',
'    /* Link or js that is executed when press decline link (if left or null not decline is shown */ ',
'    ''javascript:alert("Declined");void(0);'' AS NOTE_DECLINE,',
'    /* When enable Browser Notifications in ConfigJSON then you can select which notifications should not be fire browser not. */',
'    0 AS NO_BROWSER_NOTIFICATION',
'FROM',
'    DUAL',
'UNION ALL',
'SELECT',
'    ''fa-wrench'' AS NOTE_ICON,',
'    ''#3e6ebc'' AS NOTE_ICON_COLOR,',
'    ''System maintenance'' AS NOTE_HEADER,',
'    ''In the time between <b>08:30</b> and <b>11:00</b> a system maintenance takes place. The systems can only be used in read-only mode and are limited in use'' AS NOTE_TEXT,',
'    ''https://apex.world'' AS NOTE_LINK,',
'    ''#3e6ebc'' AS NOTE_COLOR,',
'    NULL AS NOTE_ACCEPT,',
'    ''javascript:alert("Declined");void(0);'' AS NOTE_DECLINE,',
'    /* When enable Browser Notifications in ConfigJSON then you can select which notifications should not be fire browser not. */',
'    0 AS NO_BROWSER_NOTIFICATION',
'FROM',
'    DUAL',
'WHERE',
'    2 = ROUND(',
'        DBMS_RANDOM.VALUE(',
'            1,',
'            2',
'        )',
'    )'))
,p_attribute_05=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(99608541024293906)
,p_event_id=>wwv_flow_api.id(99608331711293904)
,p_event_result=>'TRUE'
,p_action_sequence=>20
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
'first_name || '' '' || last_name  USERNAME,',
'case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'           when 0  THEN',
'                ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'            else  ',
'',
'           ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'           end IMAGE  ,',
'''#'' EDIT_LINK, ',
'--apex_util.prepare_url( ''f?p=''||:APP_ID||'':22:''||:APP_SESSION||''::NO::P22_USER_NAME:''|| user_name ) EDIT_LINK,',
'email EMAIL, ',
'mobile_sms PHONE_NO,',
'(select desc_e',
'        from dct_employees_lookups',
'        where lookup_name = ''Positions Codes''',
'        and code = to_char(e.position_id)) DESIGNATION,',
'(select org.org_name_en ',
'    from dct_hr_organizations org',
'    where org.org_id =  organization_id) DEPARTMENT,',
'''Department Culture and Tourism AD'' COMPANY',
'FROM dct_employees_list2 e',
'where user_name = :APP_USER;'))
,p_attribute_05=>'Y'
);
wwv_flow_api.component_end;
end;
/
