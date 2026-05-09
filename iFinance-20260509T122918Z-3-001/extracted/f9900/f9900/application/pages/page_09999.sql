prompt --application/pages/page_09999
begin
--   Manifest
--     PAGE: 09999
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
 p_id=>9999
,p_user_interface_id=>wwv_flow_api.id(1686359760302353)
,p_name=>'Login Page'
,p_alias=>'LOGIN'
,p_step_title=>'i-finance - Sign In'
,p_warn_on_unsaved_changes=>'N'
,p_first_item=>'AUTO_FIRST_ITEM'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.t-Login-logo.fa {',
'	color: rgb(30, 0, 30);',
'}',
'',
'.t-Login-header {',
'	padding: 0px 0;',
'}',
'',
'.t-Login-region,',
'.t-MediaList {',
'	background: rgba(255, 255, 255, 0.5) !important;',
'}',
'',
'.t-Login-logo {',
'	background-image: url("&APP_IMAGES.contact.jpg");',
'	background-size: cover;',
'	border-radius: 50%;',
'	width: 100px;',
'	height: 100px;',
'	cursor: pointer;',
'}',
'',
'#fabe-img {',
'	width: 100%;',
'	height: 100%;',
'	background-image: url("Abu Dhabi Qasr Al Watan.jpg");',
'	background-position: center;',
'	background-size: contain;',
'	background-repeat: no-repeat;',
'}',
'',
'.t-Login-container{',
'		max-width: 90%;',
'		padding-left: 10%;',
'}',
'',
'.t-Login-containerBody{',
'display: table;',
'}',
'',
'body{',
'  background-image: url(''#WORKSPACE_IMAGES#ifinace_ext.JPG'');',
'  background-position: center;',
'  background-repeat: no-repeat; ',
'  background-size: cover;',
'}'))
,p_step_template=>wwv_flow_api.id(1554403726302253)
,p_page_template_options=>'#DEFAULT#'
,p_page_is_public_y_n=>'Y'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20211003125747'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1690327562302380)
,p_plug_name=>'i-finance'
,p_icon_css_classes=>'app-icon'
,p_region_template_options=>'#DEFAULT#:t-Login-region--headerTitle'
,p_plug_template=>wwv_flow_api.id(1600461131302282)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1695022676302390)
,p_plug_name=>'Language Selector'
,p_parent_plug_id=>wwv_flow_api.id(1690327562302380)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(1574322396302267)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_source=>'apex_lang.emit_language_selector_list;'
,p_plug_source_type=>'NATIVE_PLSQL'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1755245885576602)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(1690327562302380)
,p_button_name=>'reset'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--danger:t-Button--link:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(1663835798302321)
,p_button_image_alt=>'forget your password ?'
,p_button_position=>'BODY'
,p_button_redirect_url=>'f?p=&APP_ID.:9998:&SESSION.::&DEBUG.:RR,9998::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1693160085302389)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(1690327562302380)
,p_button_name=>'LOGIN'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--simple'
,p_button_template_id=>wwv_flow_api.id(1663835798302321)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Sign In'
,p_button_position=>'REGION_TEMPLATE_NEXT'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1690720202302382)
,p_name=>'P9999_USERNAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(1690327562302380)
,p_prompt=>'Username'
,p_placeholder=>'Username'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>40
,p_cMaxlength=>100
,p_field_template=>wwv_flow_api.id(1662433208302318)
,p_item_icon_css_classes=>'fa-user'
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1691127939302383)
,p_name=>'P9999_PASSWORD'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(1690327562302380)
,p_prompt=>'Password'
,p_placeholder=>'Password'
,p_display_as=>'NATIVE_PASSWORD'
,p_cSize=>40
,p_cMaxlength=>100
,p_field_template=>wwv_flow_api.id(1662433208302318)
,p_item_icon_css_classes=>'fa-key'
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1692261466302386)
,p_name=>'P9999_REMEMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(1690327562302380)
,p_prompt=>'Remember username'
,p_display_as=>'NATIVE_CHECKBOX'
,p_named_lov=>'LOGIN_REMEMBER_USERNAME'
,p_lov=>'.'||wwv_flow_api.id(1691451515302383)||'.'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(1662433208302318)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'If you select this checkbox, the application will save your username in a persistent browser cookie named "LOGIN_USERNAME_COOKIE".',
'When you go to the login page the next time,',
'the username field will be automatically populated with this value.',
'</p>',
'<p>',
'If you deselect this checkbox and your username is already saved in the cookie,',
'the application will overwrite it with an empty value.',
'You can also use your browser''s developer tools to completely remove the cookie.',
'</p>'))
,p_attribute_01=>'1'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1842132726558727)
,p_name=>'New'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
,p_display_when_type=>'NEVER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1842260185558728)
,p_event_id=>wwv_flow_api.id(1842132726558727)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'PLUGIN_RW.APEX.VANTA.JS.PLUGIN'
,p_affected_elements_type=>'JQUERY_SELECTOR'
,p_affected_elements=>'body'
,p_attribute_01=>'cells'
,p_attribute_02=>wwv_flow_string.join(wwv_flow_t_varchar2(
'{',
'  "mouseControls": true,',
'  "touchControls": true,',
'  "minHeight": 200.00,',
'  "minWidth": 200.00,',
'  "scale": 1.00,',
'  "scaleMobile": 1.00',
'}'))
,p_attribute_07=>wwv_flow_string.join(wwv_flow_t_varchar2(
'{',
'  "color1": "#ff3399",',
'  "color2": "#66ff66",',
'  "size": 1.5,',
'  "speed": 0.9',
'}'))
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1693989489302389)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Set Username Cookie'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex_authentication.send_login_username_cookie (',
'    p_username => lower(:P9999_USERNAME),',
'    p_consent  => :P9999_REMEMBER = ''Y'' );'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1693549391302389)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Login'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex_authentication.login(',
'    p_username => :P9999_USERNAME,',
'    p_password => :P9999_PASSWORD );'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1694724592302390)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_SESSION_STATE'
,p_process_name=>'Clear Page(s) Cache'
,p_attribute_01=>'CLEAR_CACHE_CURRENT_PAGE'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1694355303302390)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Get Username Cookie'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P9999_USERNAME := apex_authentication.get_login_username_cookie;',
':P9999_REMEMBER := case when :P9999_USERNAME is not null then ''Y'' end;'))
);
wwv_flow_api.component_end;
end;
/
