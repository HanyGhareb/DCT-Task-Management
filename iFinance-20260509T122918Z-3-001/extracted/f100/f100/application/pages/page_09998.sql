prompt --application/pages/page_09998
begin
--   Manifest
--     PAGE: 09998
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
 p_id=>9998
,p_user_interface_id=>wwv_flow_api.id(1686359760302353)
,p_name=>'User - Reset Password'
,p_alias=>'USER-RESET-PASSWORD'
,p_step_title=>'User - Reset Password'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_api.id(1689433895302375)
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.reset-header{',
'    height: 150px;',
'}',
'',
'.test{',
'    background-image: url("#WORKSPACE_IMAGES#Zayed-banner.png");',
'    background-repeat: no-repeat;',
'    background-size: cover;',
'     height: 400px;',
'    width   :500px;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_overwrite_navigation_list=>'Y'
,p_page_is_public_y_n=>'Y'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210305113742'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1757038103576620)
,p_plug_name=>'Header'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(1574322396302267)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_css_classes=>'reset-header'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<marquee width="90%" direction="left" height="100px" scrollamount="6">',
'To Reset your <i><b style="color:#217247;">i-finance </i></b> account, Please enter your <b><i style="color:red;">employee number</i></b> OR  <b><i style="color:red;">user name</i></b> OR <b><i style="color:red;">registered email</i></b>.',
'you will receive email with <b><i style="color:#217247;">user name</i></b> and <b><i style="color:#217247;">temporary password</i><b> only if you have account.',
'</marquee>'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1757359180576623)
,p_plug_name=>'New'
,p_region_css_classes=>'test'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(1574322396302267)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_source=>'<div style="background-image: url(''#WORKSPACE_IMAGES#Zayed-banner.png'');"> '
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1762251790717587)
,p_plug_name=>'Enter your Account Details'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(1601776079302283)
,p_plug_display_sequence=>20
,p_plug_grid_column_span=>4
,p_plug_display_column=>3
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'NEVER'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(20784304369193935)
,p_plug_name=>'Enter your Employee Number or User name or Email '
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(1601776079302283)
,p_plug_display_sequence=>30
,p_plug_grid_column_span=>4
,p_plug_display_column=>3
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(20784667283193938)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(20784304369193935)
,p_button_name=>'RESET_1'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(1663835798302321)
,p_button_image_alt=>'Reset'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(20784794290193939)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(20784304369193935)
,p_button_name=>'CLEAR_1'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(1663835798302321)
,p_button_image_alt=>'Clear'
,p_button_position=>'BELOW_BOX'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1755505904576605)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(1762251790717587)
,p_button_name=>'RESET'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(1663835798302321)
,p_button_image_alt=>'Reset'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1755654993576606)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(1762251790717587)
,p_button_name=>'CLEAR'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(1663835798302321)
,p_button_image_alt=>'Clear'
,p_button_position=>'BELOW_BOX'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(1756829922576618)
,p_branch_name=>'Go to Login'
,p_branch_action=>'f?p=&APP_ID.:9999:&SESSION.::&DEBUG.:RP,9999::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1755323694576603)
,p_name=>'P9998_EMPLOYEE_NUM'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(1762251790717587)
,p_prompt=>'Employee Num'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(1663065957302319)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1755443449576604)
,p_name=>'P9998_EMAIL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(1762251790717587)
,p_prompt=>'Email'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(1663065957302319)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20784455934193936)
,p_name=>'P9998_ACCOUNT'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(20784304369193935)
,p_prompt=>'Employee num or username or email'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(1663065957302319)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1756267701576612)
,p_name=>'Reset DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(1755505904576605)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1756376728576613)
,p_event_id=>wwv_flow_api.id(1756267701576612)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'you are going to reset your ifinance account, you will receive Email with your user name and Temporary password on your registered Email.',
'Are you sure ? '))
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1756478033576614)
,p_event_id=>wwv_flow_api.id(1756267701576612)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'--  ifinance_users.run_reset_pwd_job(''TCA9051'');',
'  ifinance_users.RESET_USER_PASSWORD2(:P9998_EMPLOYEE_NUM , :P9998_EMAIL);',
'--ifinance_users.INSERT_RESET_REQUEST(''9051'' , ''hghareb@dctabudhabi.ae'');',
'-- ifinance_users.RESET_USER_PASSWORD(''9051'' , ''hghareb@dctabudhabi.ae'');',
'end;'))
,p_attribute_02=>'P9998_EMPLOYEE_NUM,P9998_EMAIL'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1756589985576615)
,p_event_id=>wwv_flow_api.id(1756267701576612)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Email has been sent successfully. Please check your registered mail.',
''))
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1756914521576619)
,p_event_id=>wwv_flow_api.id(1756267701576612)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(20784895418193940)
,p_name=>'Reset DA3'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(20784667283193938)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(20784984873193941)
,p_event_id=>wwv_flow_api.id(20784895418193940)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'you are going to reset your ifinance account, you will receive Email with your user name and Temporary password on your registered Email.',
'Are you sure ? '))
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(20785070980193942)
,p_event_id=>wwv_flow_api.id(20784895418193940)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'  ifinance_users.RESET_USER_PASSWORD3(:P9998_ACCOUNT);',
'end;'))
,p_attribute_02=>'P9998_ACCOUNT'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(20785151102193943)
,p_event_id=>wwv_flow_api.id(20784895418193940)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Please check your registered mail.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(20785281784193944)
,p_event_id=>wwv_flow_api.id(20784895418193940)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.component_end;
end;
/
