prompt --application/pages/page_09997
begin
--   Manifest
--     PAGE: 09997
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>9997
,p_user_interface_id=>wwv_flow_api.id(1686359760302353)
,p_name=>'Reset Current User'
,p_alias=>'RESET-CURRENT-USER'
,p_page_mode=>'MODAL'
,p_step_title=>'Change My Password'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230622111009'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1757432063576624)
,p_plug_name=>'Change My Password'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(1574322396302267)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1840409893558710)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(1757432063576624)
,p_button_name=>'Cancel'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(1663835798302321)
,p_button_image_alt=>'Cancel'
,p_button_position=>'BOTTOM'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:RP,::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1757723147576627)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(1757432063576624)
,p_button_name=>'Submit'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(1663977999302321)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Submit'
,p_button_position=>'BOTTOM'
,p_icon_css_classes=>'fa-send'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(1839894374558704)
,p_branch_name=>'go to home'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:RP,1::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1757514679576625)
,p_name=>'P9997_NEW_PASSWORD'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(1757432063576624)
,p_prompt=>'New Password'
,p_display_as=>'NATIVE_PASSWORD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(1662779496302319)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1757655012576626)
,p_name=>'P9997_CONFIRM_PASSWORD'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(1757432063576624)
,p_prompt=>'Confirm Password'
,p_display_as=>'NATIVE_PASSWORD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(1662779496302319)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1840792042558713)
,p_name=>'P9997_CONFIRM'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(1757432063576624)
,p_prompt=>'Matched'
,p_source=>'Password Doesn''t match !!'
,p_source_type=>'STATIC'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(1662433208302318)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1839906413558705)
,p_name=>'Confirm Password'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P9997_CONFIRM_PASSWORD'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'$v(P9997_NEW_PASSWORD) != $v(P9997_CONFIRM_PASSWORD)'
,p_bind_type=>'live'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1840018088558706)
,p_event_id=>wwv_flow_api.id(1839906413558705)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(1757723147576627)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1841069880558716)
,p_event_id=>wwv_flow_api.id(1839906413558705)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P9997_CONFIRM'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1840135272558707)
,p_event_id=>wwv_flow_api.id(1839906413558705)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(1757723147576627)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1840909078558715)
,p_event_id=>wwv_flow_api.id(1839906413558705)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P9997_CONFIRM'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1840238707558708)
,p_name=>'Disable Submit on load'
,p_event_sequence=>20
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1840300456558709)
,p_event_id=>wwv_flow_api.id(1840238707558708)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(1757723147576627)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1840886291558714)
,p_event_id=>wwv_flow_api.id(1840238707558708)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P9997_CONFIRM'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1839633605558702)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Chang My Password'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'  --  APEX_UTIL.CHANGE_CURRENT_USER_PW (:P9997_NEW_PASSWORD);',
'  ',
'  update dct_employees_list2',
'  set password = :P9997_NEW_PASSWORD , PASSWORD_LAST_CHANGED = systimestamp',
'  where person_id = :PERSON_ID;',
'END;'))
,p_process_error_message=>'Error, Please Contact system administrator.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(1757723147576627)
,p_process_success_message=>'Password Changed Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(169813199700839019)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update APex Users for specific users'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'l_count         number;',
'    l_user_id                       NUMBER;',
'    l_workspace                     VARCHAR2(255);',
'    l_user_name                     VARCHAR2(100);',
'    l_first_name                    VARCHAR2(255);',
'    l_last_name                     VARCHAR2(255);',
'    l_web_password                  VARCHAR2(255);',
'    l_email_address                 VARCHAR2(240);',
'    l_start_date                    DATE;',
'    l_end_date                      DATE;',
'    l_employee_id                   NUMBER(15,0);',
'    l_allow_access_to_schemas       VARCHAR2(4000);',
'    l_person_type                   VARCHAR2(1);',
'    l_default_schema                VARCHAR2(30);',
'    l_groups                        VARCHAR2(1000);',
'    l_developer_role                VARCHAR2(60);',
'    l_description                   VARCHAR2(240);',
'    l_account_expiry                DATE;',
'    l_account_locked                VARCHAR2(1);',
'    l_failed_access_attempts        NUMBER;',
'    l_change_password_on_first_use  VARCHAR2(1);',
'    l_first_password_use_occurred   VARCHAR2(1);',
'BEGIN',
'l_count := 0;',
'',
'for   c_emp in  (select user_name',
'        from APEX_WORKSPACE_APEX_USERS',
'        where workspace_name = ''PROD''',
'        and account_locked = ''No''',
'        and lower(user_name) = :APP_USER)',
'    Loop',
'        ',
'        ',
'    l_user_id := ''ENTERPRISEBI@DCTABUDHABI.AE'';',
'    l_count := l_count + 1 ;',
'APEX_UTIL.FETCH_USER(',
'    p_user_id                       => l_user_id,',
'    p_workspace                     => l_workspace,',
'    p_user_name                     => l_user_name,',
'    p_first_name                    => l_first_name,',
'    p_last_name                     => l_last_name,',
'    p_web_password                  => l_web_password,',
'    p_email_address                 => l_email_address,',
'    p_start_date                    => l_start_date,',
'    p_end_date                      => l_end_date,',
'    p_employee_id                   => l_employee_id,',
'    p_allow_access_to_schemas       => l_allow_access_to_schemas,',
'    p_person_type                   => l_person_type,',
'    p_default_schema                => l_default_schema,',
'    p_groups                        => l_groups,',
'    p_developer_role                => l_developer_role,',
'    p_description                   => l_description,',
'    p_account_expiry                => l_account_expiry,',
'    p_account_locked                => l_account_locked,',
'    p_failed_access_attempts        => l_failed_access_attempts,',
'    p_change_password_on_first_use  => l_change_password_on_first_use,',
'    p_first_password_use_occurred   => l_first_password_use_occurred);',
'    ',
'    ',
'    DBMS_OUTPUT.PUT(''Count:''  || l_count);',
'    ',
'    ',
'    ',
'APEX_UTIL.EDIT_USER (',
'    p_user_id                       => l_user_id,',
'    p_user_name                     => l_user_name,',
'    p_first_name                    => l_first_name,',
'    p_last_name                     => l_last_name,',
'    p_web_password                  => :P9997_NEW_PASSWORD,',
'    p_new_password                  => :P9997_NEW_PASSWORD,',
'    p_email_address                 => l_email_address,',
'    p_start_date                    => l_start_date,',
'    p_end_date                      => l_end_date,',
'    p_employee_id                   => l_employee_id,',
'    p_allow_access_to_schemas       => l_allow_access_to_schemas,',
'    p_person_type                   => l_person_type,',
'    p_default_schema                => l_default_schema,',
'    p_group_ids                     => l_groups,',
'    p_developer_roles               => l_developer_role,',
'    p_description                   => l_description,',
'    p_account_expiry                => l_account_expiry,',
'    p_account_locked                => l_account_locked,',
'    p_failed_access_attempts        => l_failed_access_attempts,',
'    p_change_password_on_first_use  => l_change_password_on_first_use,',
'    p_first_password_use_occurred   => l_first_password_use_occurred);',
'',
'',
'    update dct_employees_list2',
'    set password = :P9996_NEW_PASSWORD',
'    , change_password = ''N''',
'    , PASSWORD_LAST_CHANGED = systimestamp',
'    where user_name = :APP_USER;',
'    ',
'    ',
' end LOOP ;   ',
'END;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'lower(:APP_USER) in ( ''enterprisebi@dctabudhabi.ae'' , ''test'')'
,p_process_when_type=>'PLSQL_EXPRESSION'
);
wwv_flow_api.component_end;
end;
/
