prompt --application/pages/page_00039
begin
--   Manifest
--     PAGE: 00039
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>39
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'Express Approval By OTP'
,p_alias=>'EXPRESS-APPROVAL-BY-OTP'
,p_page_mode=>'MODAL'
,p_step_title=>'Express Approval By OTP'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_page_is_public_y_n=>'Y'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210902061818'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(79405467992047947)
,p_plug_name=>'Approve  Using OTP'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noUI:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(39821268561104335)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(79405467992047947)
,p_button_name=>'Approve'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'Approve'
,p_button_position=>'BELOW_BOX'
,p_button_condition=>'P39_ACTION'
,p_button_condition2=>'A'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-thumbs-o-up'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(39821665438104334)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(79405467992047947)
,p_button_name=>'Reject'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'Reject'
,p_button_position=>'BELOW_BOX'
,p_button_condition=>'P39_ACTION'
,p_button_condition2=>'R'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-thumbs-o-down'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(39822074107104334)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(79405467992047947)
,p_button_name=>'New_OTP'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--link:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'Get New OTP'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(39829922026104328)
,p_branch_name=>'Go to 40'
,p_branch_action=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.:40:P40_ACTION:&P39_ACTION.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'REQUEST_NOT_EQUAL_CONDITION'
,p_branch_condition=>'New_OTP'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(39822438493104334)
,p_name=>'P39_HASH'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(79405467992047947)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(39822854861104334)
,p_name=>'P39_HISTORY_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(79405467992047947)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(39823251469104333)
,p_name=>'P39_PAYMENT_RECOMMENDATION_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(79405467992047947)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(39823677299104333)
,p_name=>'P39_PERSON_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(79405467992047947)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(39824037071104333)
,p_name=>'P39_ACTION'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(79405467992047947)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(39824405017104333)
,p_name=>'P39_OTP'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(79405467992047947)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(39824899125104333)
,p_name=>'P39_PERSON_TYPE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(79405467992047947)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(39825210439104332)
,p_name=>'P39_EMAIL'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(79405467992047947)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(39825606956104332)
,p_name=>'P39_OTP_USER'
,p_is_required=>true
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(79405467992047947)
,p_prompt=>'Enter received OTP :'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>10
,p_field_template=>wwv_flow_api.id(10306487466597823)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(39826055544104332)
,p_name=>'P39_COMMENT'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(79405467992047947)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>wwv_flow_api.id(10306172661597823)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(39826516288104331)
,p_validation_name=>'Validate OTP process'
,p_validation_sequence=>10
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare ',
'l_res        varchar2(2);',
'begin',
'',
'select cwip_rec_payment_ext_app.Validate_request(:P39_HISTORY_ID , :P39_OTP_USER)',
'into l_res',
' from cwip_payment_rec_approval_history h',
'    where h.id = :P39_HISTORY_ID;',
'    ',
'  if l_res = ''N1''',
'        Then ',
'                return ''Invalid OTP'';',
'      elsif l_res = ''N2''',
'             Then',
'                 return ''Expired OTP'';',
'  end if;',
'end;'))
,p_validation_type=>'FUNC_BODY_RETURNING_ERR_TEXT'
,p_when_button_pressed=>wwv_flow_api.id(39821268561104335)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(39828432061104330)
,p_name=>'New OTP DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(39822074107104334)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(39828961641104329)
,p_event_id=>wwv_flow_api.id(39828432061104330)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_otp            varchar2(20);',
'l_send_to_email    varchar2(220);',
'    l_body      CLOB;',
'    l_body_html CLOB;',
'    l_id NUMBER;',
'begin',
'l_otp := dct_util.GENERATE_OTP();',
'',
':P39_OTP := l_otp;',
'',
'update cwip_payment_rec_approval_history',
'set OTP = l_otp , OTP_TIME = systimestamp , OTP_COUNT = nvl(OTP_COUNT,0) + 1',
'where id = :P39_HISTORY_ID;',
'',
'',
'--Send Mail',
'    l_body := ''Please do not share this OTP with anyone.',
'			The one Time Password (OTP) for iFinance is P39_OTP. and is valid for the next 5 minutes only.''||utl_tcp.crlf;',
'',
'    l_body_html := ''<html>',
'        <head>',
'            <style type="text/css">',
'                body{font-family: Arial, Helvetica, sans-serif;',
'                    font-size:10pt;',
'                    margin:30px;',
'                    background-color:#ffffff;}',
'',
'                span.sig{font-style:italic;',
'                    font-weight:bold;',
'                    color:#811919;}',
'             </style>',
'         </head>',
'         <body>''||utl_tcp.crlf;',
'    l_body_html := l_body_html ||''<p>Please do not share this OTP with anyone.<br></p>''||utl_tcp.crlf;',
'    l_body_html := l_body_html ||''  The one Time Password (OTP) for iFinance is <b style="color:red">'' ||utl_tcp.crlf;',
'    l_body_html := l_body_html ||:P39_OTP ||utl_tcp.crlf;',
'    l_body_html := l_body_html ||''</b> and is valid for the next 5 minutes only.<br />''||utl_tcp.crlf;',
'    l_body_html := l_body_html ||''</body></html>''; ',
'    l_id        := apex_mail.send(',
'        p_to        => :P39_EMAIL,',
'        p_from      => ''ifinance@dctabudhabi.ae'',',
'        p_body      => l_body,',
'        p_body_html => l_body_html,',
'        p_subj      => ''OTP iFInance'');',
'',
'apex_mail.push_queue();',
'  ',
'end;'))
,p_attribute_02=>'P39_HISTORY_ID,P39_OTP'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(39723829390361309)
,p_event_id=>wwv_flow_api.id(39828432061104330)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P39_OTP_USER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(39724295427361313)
,p_event_id=>wwv_flow_api.id(39828432061104330)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'New OTP Email Sent.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(39826892475104331)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'generate OTP'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_otp            varchar2(20);',
'l_send_to_email    varchar2(220);',
'begin',
'l_otp := dct_util.GENERATE_OTP();',
'',
':P39_OTP := l_otp;',
'',
'update cwip_payment_rec_approval_history',
'set OTP = l_otp , OTP_TIME = systimestamp , OTP_COUNT = nvl(OTP_COUNT,0) + 1',
'where id = :P39_HISTORY_ID;',
'',
'--get email',
'if :P39_PERSON_TYPE = ''INT''',
'            then ',
'                select email into l_send_to_email',
'                from employees_v',
'                where person_id = :P39_PERSON_ID;',
'         elsif  ',
'             :P39_PERSON_TYPE = ''EXT''',
'             then',
'                 select email into l_send_to_email',
'                 from dct_ext_users',
'                 where user_id = :P39_PERSON_ID;',
'End if;',
'',
'   Select decode(dct_util.get_send_test_email_by_app(NV(''APP_ID'')) , ',
'                            ''Y'' , dct_util.get_test_email_by_app(NV(''APP_ID'')) , ',
'                            ''N'' , l_send_to_email)',
'    into :P39_EMAIL ',
'    from dual;',
'--// TODO ',
'-- Send OTP Mail',
'',
'end;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(39827299665104331)
,p_process_sequence=>20
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_SEND_EMAIL'
,p_process_name=>'Send OTP Mail'
,p_attribute_01=>'ifinance@dctabudhabi.ae'
,p_attribute_02=>'&P39_EMAIL.'
,p_attribute_06=>'OTP iFInance'
,p_attribute_07=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Please do not share this OTP with anyone.',
'The one Time Password (OTP) for iFinance is &P39_OTP. and is valid for the next 5 minutes only.'))
,p_attribute_08=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Please do not share this OTP with anyone.<br>',
'The one Time Password (OTP) for iFinance is <b style="color:red">&P39_OTP.</b> and is valid for the next 5 minutes only.',
''))
,p_attribute_10=>'N'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(39827664866104330)
,p_process_sequence=>30
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'push mail'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'begin',
'apex_mail.push_queue();',
'end;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(39828097321104330)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Action Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P39_ACTION = ''A''',
'    Then',
'insert into test values (''Hiba: '' ||  :P39_OTP_USER || '' - Approved'' );',
'cwip_rec_payment_workflow.APPROVE(:P39_PAYMENT_RECOMMENDATION_ID,:P39_PERSON_ID, :P39_COMMENT);',
'',
'elsif :P39_ACTION = ''R''',
'    then',
'',
'',
'cwip_rec_payment_workflow.REJECTED(:P39_PAYMENT_RECOMMENDATION_ID,:P39_PERSON_ID, :P39_COMMENT);',
'',
'End if;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'New_OTP'
,p_process_when_type=>'REQUEST_NOT_IN_CONDITION'
);
wwv_flow_api.component_end;
end;
/
