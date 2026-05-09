prompt --application/pages/page_00058
begin
--   Manifest
--     PAGE: 00058
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
 p_id=>58
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'Express Payment Recommendation Direct Action Backup'
,p_alias=>'EXPRESS-PAYMENT-RECOMMENDATION-DIRECT-ACTION-BACKUP'
,p_step_title=>'Express Payment Recommendation Direct Action Backup'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_page_is_public_y_n=>'Y'
,p_deep_linking=>'Y'
,p_page_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'This page is used to take action for Payment recommendation request directly without authentication,',
'Required Parameters:',
'    - Hash_code',
'    - Action: (A - for Approve, R - for reject)'))
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220314094509'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(152888595797820588)
,p_plug_name=>'Confirm'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p><strong>Are you sure to &P57_ACTION_NAME. Payment# &P57_REF_NUMBER. ?</strong></p>',
'<p>&nbsp;</p>'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58884340531309153)
,p_name=>'P58_ACTION_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(152888595797820588)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(59040514844814478)
,p_name=>'P58_ACTION'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(152888595797820588)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(59040778088814480)
,p_name=>'P58_HASH'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(152888595797820588)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(59041189569814480)
,p_name=>'P58_HISTORY_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(152888595797820588)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(59041564519814480)
,p_name=>'P58_PAYMENT_RECOMMENDATION_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(152888595797820588)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(59042040868814480)
,p_name=>'P58_PERSON_ID'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(152888595797820588)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(59042452478814480)
,p_name=>'P58_PERSON_TYPE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(152888595797820588)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(59042844689814488)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get Hash Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select h.id , h.payment_recommendation_id , person_id , PERSON_TYPE ',
'',
'into :P58_HISTORY_ID, :P58_PAYMENT_RECOMMENDATION_ID , :P58_PERSON_ID , :P58_PERSON_TYPE ',
'from CWIP_PAYMENT_REC_APPROVAL_HISTORY h',
'where hash_code = :P58_HASH',
'and h.status = ''Pending'';',
'exception',
'    When',
'     no_data_found then ',
'        null;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(59043643541814488)
,p_process_sequence=>20
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Take Action Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'--insert into test values (:P58_HISTORY_ID || ''-'' || :P58_ACTION);',
'',
'if :P58_ACTION = ''A'' ',
'    Then ',
'        -- approve action',
'        cwip_rec_payment_workflow.APPROVE(:P58_PAYMENT_RECOMMENDATION_ID,:P58_PERSON_ID, null);',
'        cwip_rec_payment_emails.CONFIRM_PAYMENT_APP_ACTION_EMAIL(:P58_PAYMENT_RECOMMENDATION_ID, :P58_PERSON_ID, :P58_PERSON_TYPE, :P58_HISTORY_ID,''A'');',
'        ',
'elsif :P58_ACTION = ''R''',
'    Then',
'       -- approve action',
'      cwip_rec_payment_workflow.REJECTED(:P58_PAYMENT_RECOMMENDATION_ID,:P58_PERSON_ID, null);',
'      cwip_rec_payment_emails.CONFIRM_PAYMENT_APP_ACTION_EMAIL(:P58_PAYMENT_RECOMMENDATION_ID, :P58_PERSON_ID, :P58_PERSON_TYPE, :P58_HISTORY_ID,''R'');',
'End if;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_type=>'NEVER'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(59043159985814488)
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
