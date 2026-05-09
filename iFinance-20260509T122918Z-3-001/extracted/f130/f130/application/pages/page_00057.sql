prompt --application/pages/page_00057
begin
--   Manifest
--     PAGE: 00057
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>57
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'Express Payment Recommendation Direct Action'
,p_alias=>'EXPRESS-PAYMENT-RECOMMENDATION-DIRECT-ACTION'
,p_step_title=>'Express Payment Recommendation Direct Action'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>wwv_flow_api.id(10209032750597754)
,p_page_template_options=>'#DEFAULT#'
,p_page_is_public_y_n=>'Y'
,p_deep_linking=>'Y'
,p_page_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'This page is used to take action for Payment recommendation request directly without authentication,',
'Required Parameters:',
'    - Hash_code',
'    - Action: (A - for Approve, R - for reject)'))
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220729055115'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(53412617440103852)
,p_plug_name=>'Confirm'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(58884744006309157)
,p_plug_name=>'Approve confirmation'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p><strong>Are you sure to <span style="color: #339966;">approve</span> &P57_REF_NUMBER. ?</strong></p>',
'<p>&nbsp;</p>'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P57_ACTION = ''A'' and :P57_DONE != ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(58884787376309158)
,p_plug_name=>'Reject Confirmation'
,p_region_template_options=>'#DEFAULT#:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p><strong>Are you sure to <span style="color: #ff0000;">Reject</span> &P57_REF_NUMBER. ?</strong></p>',
'<p>&nbsp;</p>'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'SQL_EXPRESSION'
,p_plug_display_when_condition=>':P57_ACTION = ''R'' and :P57_DONE != ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(58884909078309159)
,p_plug_name=>'Action Taken'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p><strong>Action on this notification has already been completed.</strong></p>',
'<p>&nbsp;</p>'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P57_DONE = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(58884982428309160)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(58884744006309157)
,p_button_name=>'Approve'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--success:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'Approve'
,p_button_position=>'BELOW_BOX'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(58885153051309161)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(58884787376309158)
,p_button_name=>'Reject'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'Reject'
,p_button_position=>'BELOW_BOX'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(58885220130309162)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(58884909078309159)
,p_button_name=>'iFinance'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'Go to iFinance'
,p_button_position=>'BELOW_BOX'
,p_button_redirect_url=>'https://ifinance.dct.gov.ae:8004/dct/prod/r/i-finance/login'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(58885646754309166)
,p_branch_name=>'Go to 40'
,p_branch_action=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.:40:P40_ACTION:&P57_ACTION.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53412660578103853)
,p_name=>'P57_HISTORY_ID'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(53412617440103852)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53412813630103854)
,p_name=>'P57_PAYMENT_RECOMMENDATION_ID'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(53412617440103852)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53412869556103855)
,p_name=>'P57_PERSON_ID'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(53412617440103852)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53412983620103856)
,p_name=>'P57_PERSON_TYPE'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(53412617440103852)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53413150429103857)
,p_name=>'P57_ACTION'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(53412617440103852)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53413424901103860)
,p_name=>'P57_HASH'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(53412617440103852)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58884099303309151)
,p_name=>'P57_REF_NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(53412617440103852)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58884182671309152)
,p_name=>'P57_DONE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(53412617440103852)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58884571298309156)
,p_name=>'P57_ACTION_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(53412617440103852)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(58885394766309164)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Action process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P57_ACTION = ''A'' ',
'    Then ',
'        -- approve action',
'        cwip_rec_payment_workflow.APPROVE(:P57_PAYMENT_RECOMMENDATION_ID,:P57_PERSON_ID, null);',
'        cwip_rec_payment_emails.CONFIRM_PAYMENT_APP_ACTION_EMAIL(:P57_PAYMENT_RECOMMENDATION_ID, :P57_PERSON_ID, :P57_PERSON_TYPE, :P57_HISTORY_ID,''A'');',
'        ',
'elsif :P57_ACTION = ''R''',
'    Then',
'       -- approve action',
'      cwip_rec_payment_workflow.REJECTED(:P57_PAYMENT_RECOMMENDATION_ID,:P57_PERSON_ID, null);',
'      cwip_rec_payment_emails.CONFIRM_PAYMENT_APP_ACTION_EMAIL(:P57_PAYMENT_RECOMMENDATION_ID, :P57_PERSON_ID, :P57_PERSON_TYPE, :P57_HISTORY_ID,''R'');',
'End if;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(53412538219103851)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get Hash Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select h.id , h.payment_recommendation_id , h.person_id , h.PERSON_TYPE , cp.reference_number',
'into :P57_HISTORY_ID, :P57_PAYMENT_RECOMMENDATION_ID , :P57_PERSON_ID , :P57_PERSON_TYPE , :P57_REF_NUMBER',
'from CWIP_PAYMENT_REC_APPROVAL_HISTORY h, cwip_payment_recommendation cp',
'where hash_code = :P57_HASH',
'and h.payment_recommendation_id = cp.payment_recommendation_id',
'and h.status = ''Pending'';',
'           ',
'        :P57_DONE := ''N'';   ',
'exception',
'    When',
'     no_data_found then ',
'        :P57_DONE := ''Y'';'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(53413329985103859)
,p_process_sequence=>20
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Take Action Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'--insert into test values (:P57_HISTORY_ID || ''-'' || :P57_ACTION);',
'',
'if :P57_ACTION = ''A'' ',
'    Then ',
'        -- approve action',
'        cwip_rec_payment_workflow.APPROVE(:P57_PAYMENT_RECOMMENDATION_ID,:P57_PERSON_ID, null);',
'        cwip_rec_payment_emails.CONFIRM_PAYMENT_APP_ACTION_EMAIL(:P57_PAYMENT_RECOMMENDATION_ID, :P57_PERSON_ID, :P57_PERSON_TYPE, :P57_HISTORY_ID,''A'');',
'        ',
'elsif :P57_ACTION = ''R''',
'    Then',
'       -- approve action',
'      cwip_rec_payment_workflow.REJECTED(:P57_PAYMENT_RECOMMENDATION_ID,:P57_PERSON_ID, null);',
'      cwip_rec_payment_emails.CONFIRM_PAYMENT_APP_ACTION_EMAIL(:P57_PAYMENT_RECOMMENDATION_ID, :P57_PERSON_ID, :P57_PERSON_TYPE, :P57_HISTORY_ID,''R'');',
'End if;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_type=>'NEVER'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(53413164098103858)
,p_process_sequence=>30
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Process'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_type=>'NEVER'
);
wwv_flow_api.component_end;
end;
/
