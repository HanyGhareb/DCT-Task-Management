prompt --application/pages/page_00005
begin
--   Manifest
--     PAGE: 00005
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>116
,p_default_id_offset=>100034894930602818
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>5
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Submit Payment Request Confirmation'
,p_alias=>'SUBMIT-PAYMENT-REQUEST-CONFIRMATION'
,p_page_mode=>'MODAL'
,p_step_title=>'Submit Payment Request Confirmation'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220408135513'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1295661170597662)
,p_plug_name=>'Declaration'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<table style="font-family: arial, sans-serif; border-collapse: collapse; width: 100%; font-size: 18px;">',
'<tbody>',
'<tr>',
'<td style="font-family: arial, sans-serif; border-collapse: collapse; width: 50%; border: 1px solid #dddddd; text-align: left; padding: 8px; background-color: #dddddd; color: red;"><strong>Declaration by Payment Requestor</strong></td>',
unistr('<td style="font-family: arial, sans-serif; border-collapse: collapse; width: 50%; border: 1px solid #dddddd; text-align: right; padding: 8px; background-color: #dddddd; color: red;"><strong>\0625\0642\0631\0627\0631 \0645\0646 \0637\0627\0644\0628 \0627\0644\062F\0641\0639\0629</strong></td>'),
'</tr>',
'<tr>',
'<td style="text-align: left; vertical-align: text-top; width: 50%;">',
'<p>To accelerate the payment process and avoid the reject for the payment request, please make sure you are follow below instructions:</p>',
'<ol>',
'<li>you have attach a clear invoice scan copy.</li>',
'<li>you have attache any supported documents like: delivery note,..etc</li>',
'</ol>',
'</td>',
'<td style="text-align: right; vertical-align: text-top; width: 50%;">',
unistr('<p>\0644\0644\062D\0635\0648\0644 \0639\0644\0649 \062E\062F\0645\0629 \0633\0631\064A\0639\0629 \0648\0644\062A\062C\0646\0628 \0631\0641\0636 \0637\0644\0628 \0627\0644\062F\0641\0639 \064A\0631\062C\0649 \0625\062A\0628\0627\0639 \062A\0639\0644\064A\0645\0627\062A \0627\0644\0633\064A\0627\0633\0629 \0627\0644\0645\0627\0644\064A\0629 \0639\0644\0649 \0627\0644\0646\062D\0648 \0627\0644\062A\0627\0644\0649</p>'),
unistr('<p style="text-align: right;">\0625\0631\0641\0627\0642 \0635\0648\0631\0629 \0648\0627\0636\062D\0629 \0644\0625\0635\0644 \0627\0644\0641\0627\062A\0648\0631\0629</p>'),
unistr('<p style="text-align: right;">\0625\0631\0641\0627\0642 \0627\0644\0645\0633\062A\0646\062F\0627\062A \0627\0644\062F\0627\0639\0645\0629 \0644\0637\0644\0628 \0627\0644\062F\0641\0639 \0645\062B\0644 : \0625\0634\0639\0627\0631 \0627\0644\0625\0633\062A\0644\0627\0645 ...\0625\0644\062E</p>'),
'</td>',
'</tr>',
'</tbody>',
'</table>'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'FUNCTION_BODY'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'l_attached_doc           number;',
'BEGIN',
'',
'select count(*)',
'into l_attached_doc',
'from payment_request_documents prd',
'where prd.payment_request_id = :P5_PAYMENT_REQUEST_ID;',
'',
'if l_attached_doc > 0    Then',
'          return true ;',
'          else ',
'          return false ;',
'',
'End if;  ',
'END;'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1277641396266391)
,p_plug_name=>'New'
,p_parent_plug_id=>wwv_flow_api.id(1295661170597662)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1296007549597663)
,p_plug_name=>'Missing Documents'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p style="color:red ; font-size:20px ">To submit your request, Please attach all the required documents.</p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'FUNCTION_BODY'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'l_attached_doc           number;',
'BEGIN',
'',
'select count(*)',
'into l_attached_doc',
'from payment_request_documents prd',
'where prd.payment_request_id = :P5_PAYMENT_REQUEST_ID;',
'',
'if l_attached_doc > 0    Then',
'          return false  ;',
'          else ',
'          return true ;',
'',
'End if;  ',
'END;'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1277867186266393)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(1277641396266391)
,p_button_name=>'Submit'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Submit'
,p_button_position=>'BELOW_BOX'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1277972347266394)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(1277641396266391)
,p_button_name=>'Cancel'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Cancel'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(1743619743943115)
,p_branch_name=>'Go to Page 2'
,p_branch_action=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.::P2_PAYMENT_REQUEST_ID:&P5_PAYMENT_REQUEST_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1277248442266387)
,p_name=>'P5_PAYMENT_REQUEST_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(1295661170597662)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1277352106266388)
,p_name=>'P5_DOC'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(1295661170597662)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1277466357266389)
,p_name=>'P5_PERSON_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(1295661170597662)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1277527783266390)
,p_name=>'P5_APPROVAL_TYPE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(1295661170597662)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1277766011266392)
,p_name=>'P5_AGREE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(1277641396266391)
,p_prompt=>unistr('Yes, Confirmed/ \0646\0639\0645 \0625\0637\0644\0639\062A')
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>unistr('STATIC(,):Yes, Confirmed/ \0646\0639\0645 \0625\0637\0644\0639\062AY')
,p_field_template=>wwv_flow_api.id(99818110358410778)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'1'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1278087925266395)
,p_name=>'Close Dialog- Cancel'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(1277972347266394)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1278191797266396)
,p_event_id=>wwv_flow_api.id(1278087925266395)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1278835493266403)
,p_name=>'Enable Submit BTN DA'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P5_AGREE'
,p_condition_element=>'P5_AGREE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1278940055266404)
,p_event_id=>wwv_flow_api.id(1278835493266403)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(1277867186266393)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1279061756266405)
,p_event_id=>wwv_flow_api.id(1278835493266403)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(1277867186266393)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1743793051943116)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Submit Payment request process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'-- 2 for "New Credit Cards" approval type',
' payment_request_workflow.Submit(:P5_PAYMENT_REQUEST_ID, :P5_APPROVAL_TYPE);',
'END;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(1277867186266393)
,p_process_success_message=>'your payment request submitted successfully.'
);
wwv_flow_api.component_end;
end;
/
