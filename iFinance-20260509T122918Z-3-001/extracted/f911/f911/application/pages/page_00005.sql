prompt --application/pages/page_00005
begin
--   Manifest
--     PAGE: 00005
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>219773596381898043
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>5
,p_user_interface_id=>wwv_flow_api.id(23921013981372477)
,p_name=>'Submit Credit Card Confirmation'
,p_alias=>'SUBMIT-CREDIT-CARD-CONFIRMATION'
,p_page_mode=>'MODAL'
,p_step_title=>'Submit Credit Card Confirmation'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220313130238'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(33462843965009027)
,p_plug_name=>'Declaration'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<table style="font-family: arial, sans-serif; border-collapse: collapse;  width: 100%;font-size:18px;">',
'  <tr>',
'    <td style="font-family: arial, sans-serif;border-collapse: collapse;width: 100%;border: 1px solid #dddddd;text-align: left;padding: 8px; background-color: #dddddd;color: red;width:50%;">Declaration by Cardholder</td>',
unistr('    <td style="font-family: arial, sans-serif;border-collapse: collapse;width: 100%;border: 1px solid #dddddd;text-align: right;padding: 8px; background-color: #dddddd;color: red;width:50%;">\0625\0642\0631\0627\0631 \0645\0646 \062D\0627\0645\0644 \0627\0644\0628\0637\0627\0642\0629</td>'),
'  </tr>',
'  <tr>',
'    <td style="text-align: left;vertical-align: text-top;width:50%">I request the issue of an ADCB Commercial Card under the agreement between ADCB and the',
'Company named above. I understand that ADCB can decline this application without assigning',
'any reason whatsoever and the application and supporting documents will become part of',
unistr('ADCB\2019s records and will not be returned to me. I certify that all information given is true and'),
'correct and agree to be bound by the Commercial Card Terms and Conditions. The ADCB',
'Commercial Credit Card Terms and Conditions and the Service and Price Guide will be made',
'available to me in any form including but not limited to in either printed or digital form along',
'with the Credit Card and my acknowledgement of the card confirms that I have received, read',
'and agreed to the conditions mentioned therein. I further agree that the contents of the ADCB',
'Commercial Credit Card Terms and Conditions and the Service and Price Guide including',
'amendments, which ADCB may make from time to time, will be binding upon me. ',
'<br>',
'<br>',
'I hereby irrevocably undertake to inform ADCB of any changes to my personal information',
'including contact and passport details. You may send any information as requested by the',
'Company regarding my statements and transactions to them.',
'<br>',
'<br>',
'I have read, understood, acknowledge and agree that the Bank may refer my name and/or any',
'data required to any credit bureau or reference agency(ies) and/or make such references and',
'enquiries as the Bank may consider necessary.</td>',
unistr('    <td style="text-align: right;vertical-align: text-top;width:50%">\0623\062A\0642\062F\0645 \0628\0637\0644\0628 \0625\0635\062F\0627\0631 \0627\0644\0628\0637\0627\0642\0629 \0627\0644\062A\062C\0627\0631\064A\0629 \0644\0649 \0645\0646 \0628\0646\0643 \0623\0628\0648\0638\0628\0649 \0627\0644\062A\062C\0627\0631\0649 \0628\0645\0648\062C\0628 \0627\0644\0625\062A\0641\0627\0642\064A\0629 \0645\0627 \0628\064A\0646 \0628\0646\0643 \0623\0628\0648\0638\0628\0649 \0627\0644\062A\062C\0627\0631\064A \0648\0627\0644\0634\0631\0643\0629 \0627\0644\0645\0630\0643\0648\0631\0629 \0623\0639\0644\0627\0647. \0623\0646\0627 \0623\062F\0631\0643 \0628\0623\0646 \0628\0646\0643 \0623\0628\0648\0638\0628\0649 \0627\0644\062A\062C\0627\0631\0649 \064A\0645\0643\0646\0647 \0631\0641\0636 \0647\0630\0627 \0627\0644\0637\0644\0628 \062F\0648\0646 ')
||unistr('\0625\0628\062F\0627\0621 \0627\0644\0623\0633\0628\0627\0628 \0623\064A\0627 \0643\0627\0646\062A \0648\0633\064A\0635\0628\062D \0627\0644\0637\0644\0628 \0648\0627\0644\0648\062B\0627\0626\0642 \0627\0644\0645\0624\064A\062F\0629 \062C\0632\0621 \0645\0646 \0633\062C\0644\0627\062A \0628\0646\0643 \0623\0628\0648\0638\0628\0649 \0627\0644\062A\062C\0627\0631\0649 \0648\0644\0646 \064A\062A\0645 \0625\0639\0627\062F\062A\0647\0627 \0644\0649. \0623\0634\0647\062F \0628\0625\0646 \062C\0645\064A\0639 \0627\0644\0645\0639\0644\0648\0645\0627\062A \0627\0644\0645\0642\062F\0645\0629 \0635\062D\064A\062D\0629 \0648\062D\0642\064A\0642\064A\0629, \0648\0623\0648\0627\0641\0642 \0639\0644\0649 \0627\0644\0627\0644\062A\0632\0627\0645 \0628\0643\0627\0641\0629 \0623\062D\0643\0627\0645 \0648\0634\0631\0648\0637 \0627\0644\0628\0637\0627\0642\0629 \0627\0644\062A\062C\0627\0631\064A\0629. \0633\064A\062A\0645 \062A\0642\062F\064A\0645 \0623\062D\0643\0627\0645 \0648\0634\0631\0648\0643 \0627\0644\0628\0637\0627\0642\0629 \0627\0644\062A\062C\0627\0631\064A\0629 \0645\0646')
||unistr(' \0628\0646\0643 \0623\0628\0648\0638\0628\0649 \0627\0644\062A\062C\0627\0631\0649 \0648\062F\0644\064A\0644 \0644\062E\062F\0645\0627\062A \0648\0627\0644\0631\0633\0648\0645 \0644\0649 \0639\0644\0649 \0623\0649 \0634\0643\0644 \0643\0627\0646. \0628\0645\0627 \0641\0649 \0630\0644\0643 \0639\0644\0649 \0633\0628\064A\0644 \0627\0644\0645\062B\0627\0644 \0644\0627 \0627\0644\062D\0635\0631, \0625\0645\0627 \0645\0637\0628\0648\0639\0629 \0623\0648 \0639\0644\0649 \0646\0645\0648\0630\062C \0631\0642\0645\0649 \0645\0639 \0628\0643\0627\0642\0629 \0627\0644\0627\0626\062A\0645\0627\0646 \0648\0623\0624\0643\062F \0628\0625\0646\0646\0649 \0642\062F \0625\0633\062A\0644\0645\062A \0648\0642\0631\0623\062A \0648\0648\0627\0641\0642\062A \0639\0644\0649 \0627\0644\0623\062D\0643\0627\0645 \0648\0627\0644\0634\0631\0648\0637 \0648\062C\062F\0648\0644 \0631\0633\0648\0645 \0627\0644\062E\062F\0645\0627\062A \0648\0623\0649 \062A\0639\062F\064A\0644 \064A\062C\0631\064A\0647 \0627\0644\0628\0646\0643 \0645\0646 \0648\0642\062A\0644\0622\062E\0631')
||unistr(', \062C\0645\064A\0639\0647\0627 \0645\0644\062A\0632\0645\0629 \0644\0649.'),
' <br>',
' <br>',
' ',
unistr('\0623\0648\0627\0641\0642 \0623\064A\0636\0627 \0639\0644\0649 \0623\0646 \062A\0643\0648\0646 \0645\062D\062A\0648\064A\0627\062A \0628\0637\0627\0642\0629 \0627\0644\0627\0626\062A\0645\0627\0646 \0627\0644\062A\062C\0627\0631\064A\0629 \0645\0646 \0628\0646\0643 \0623\0628\0648\0638\0628\0649 \0627\0644\062A\062C\0627\0631\0649 \0648\0627\0644\0623\062D\0643\0627\0645 \0648\0627\0644\0634\0631\0648\0637 \0648\062F\0644\064A\0644 \0627\0644\062E\062F\0645\0627\062A \0648\0627\0644\0631\0633\0648\0645, \0628\0645\0627 \0641\0649 \0630\0644\0643 \0627\0644\062A\0639\062F\064A\0644\0627\062A \0627\0644\062A\0649 \064A\062F\062E\0644\0647\0627 \0628\0646\0643 \0623\0628\0648\0638\0628\0649 \0627\0644\062A\062C\0627\0631\0649 \0645\0646 \0648\0642\062A \0644\0622\062E\0631, \0645\0644\0632\0645\0629 \0644\0649. '),
' <br>',
' <br>',
unistr(' \0623\062A\0639\0647\062F \0628\0645\0648\062C\0628\0647 \0648\0628\0635\0648\0631\0629 \0646\0647\0627\0626\064A\0629 \0644\0627 \0631\062C\0639\0629 \0639\0646\0647\0627 \0628\0625\0628\0644\0627\063A \0628\0646\0643 \0623\0628\0648\0638\0628\0649 \0627\0644\062A\062C\0627\0631\0649 \0628\0627\0649 \062A\063A\064A\064A\0631\0627\062A \0641\0649 \0623\0649 \0645\0646 \0628\064A\0627\0646\0627\062A\0649 \0627\0644\0634\062E\0635\064A\0629 \0628\0645\0627 \0641\0649 \0630\0644\0643 \0639\0646\0648\0627\0646 \0627\0644\0627\062A\0635\0627\0644 \0648\0628\064A\0627\0646\0627\062A \062C\0648\0627\0632 \0627\0644\0633\0641\0631. \0648\064A\062C\0648\0632 \0644\0643\0645 \0625\0631\0633\0627\0644 \0623\0649 \0645\0639\0644\0648\0645\0627\062A \062D\0633\0628 \0637\0644\0628 \0627\0644\0634\0631\0643\0629 \062E\0627\0635\0629 \0628\0643\0634\0648\0641\0627\062A \062D\0633\0627\0628\0649 \0648\0645\0639\0627\0645\0644\0627\062A\0649 \0627\0644\064A\0647\0645.'),
' ',
' <br>',
unistr(' \0644\0642\062F \0642\0631\0623\062A \0648\0641\0647\0645\062A \0648\0623\0642\0631 \0648\0627\0648\0627\0641\0642 \0639\0644\0649 \0623\0646\0647 \064A\062C\0648\0632 \0644\0644\0628\0646\0643 \0623\0646 \064A\062D\064A\0644 \0625\0633\0645\0649 \0648/\0623\0648 \0623\0649 \0628\064A\0627\0646\0627\062A \0644\0627\0632\0645\0629 \0644\0623\0649 \0645\0643\062A\0628 \0627\0626\062A\0645\0627\0646 \0623\0648 \0648\0643\0627\0644\0627\062A \0645\0631\062C\0639\064A\0629 \0648/\0623\0648 \0623\0646 \064A\0642\0648\0645 \0628\0639\0645\0644 \0623\0649 \0645\0631\062C\0639\064A\0627\062A \0648\0627\0633\062A\0641\0633\0627\0631\0627\062A \062D\0633\0628 \0645\0627\064A\0631\0627\0647\0627 \0627\0644\0628\0646\0643 \0636\0631\0648\0631\064A\0627\064B.'),
' </td>',
'  </tr>',
'</table>'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'FUNCTION_BODY'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'l_nationality_id         varchar2(20);',
'l_req_doc_count          number;',
'l_attached_doc           number;',
'BEGIN',
'',
'select nationality_id',
'into l_nationality_id',
'from employees_v',
'where person_id = :P5_PERSON_ID; ',
'--where person_id = :P2_REQUESTOR_PERSON_ID;  -- 205    P2_NEW',
'',
'select count(*)',
'into l_req_doc_count',
'from credit_card_doc_required',
'where LOCAL_EXPAT in (''B'' , decode(l_nationality_id , 101, ''L'' , ''E'')) ;',
'',
'select count(*)',
'into l_attached_doc',
'from credit_cards_documents d , credit_card_doc_required cr',
'where d.doc_required_id = cr.id',
'and d.credit_card_id = :P5_ID',
'and nvl(sys.dbms_lob.getlength(d.file_blob), 0) > 0 ;',
'',
'if l_attached_doc >= l_req_doc_count    Then',
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
 p_id=>wwv_flow_api.id(34279982009651510)
,p_plug_name=>'New'
,p_parent_plug_id=>wwv_flow_api.id(33462843965009027)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody:t-Form--xlarge:t-Form--labelsAbove'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(34056887293009622)
,p_plug_name=>'Missing Documents'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p style="color:red ; font-size:20px ">To submit your request, Please attach all the required documents.</p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'FUNCTION_BODY'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'l_nationality_id         varchar2(20);',
'l_req_doc_count          number;',
'l_attached_doc           number;',
'BEGIN',
'',
'select nationality_id',
'into l_nationality_id',
'from employees_v',
'where person_id = :P5_PERSON_ID; ',
'--where person_id = :P2_REQUESTOR_PERSON_ID;  -- 205    P2_NEW',
'',
'select count(*)',
'into l_req_doc_count',
'from credit_card_doc_required',
'where LOCAL_EXPAT in (''B'' , decode(l_nationality_id , 101, ''L'' , ''E'')) ;',
'',
'select count(*)',
'into l_attached_doc',
'from credit_cards_documents d , credit_card_doc_required cr',
'where d.doc_required_id = cr.id',
'and d.credit_card_id = :P5_ID',
'and nvl(sys.dbms_lob.getlength(d.file_blob), 0) > 0 ;',
'',
'if l_attached_doc >= l_req_doc_count    Then',
'          return false ;',
'          else ',
'          return true ;',
'',
'End if;  ',
'END;'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(33462933884009028)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(34279982009651510)
,p_button_name=>'Submit'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(23898584035372508)
,p_button_image_alt=>'Submit'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(33463096129009029)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(34279982009651510)
,p_button_name=>'Cancel'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(23898584035372508)
,p_button_image_alt=>'Cancel'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24321269270099907)
,p_name=>'P5_PERSON_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(33462843965009027)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24321160501099906)
,p_name=>'P5_APPROVAL_TYPE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(33462843965009027)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(33463653494009035)
,p_name=>'P5_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(33462843965009027)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34056605481009620)
,p_name=>'P5_DOC'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(33462843965009027)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34279868016651509)
,p_name=>'P5_AGREE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(34279982009651510)
,p_item_default=>'N'
,p_prompt=>unistr('Agree / \0623\0648\0627\0641\0642')
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>unistr('STATIC:Agree / \0623\0648\0627\0641\0642;Y')
,p_grid_column=>1
,p_field_template=>wwv_flow_api.id(23897353981372511)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'1'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(33463118478009030)
,p_name=>'Submit DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(33462933884009028)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33463205871009031)
,p_event_id=>wwv_flow_api.id(33463118478009030)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'-- 2 for "New Credit Cards" approval type',
' credit_cards_workflow.Submit(:P5_ID , 2);',
'END;'))
,p_attribute_02=>'P5_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33463393259009032)
,p_event_id=>wwv_flow_api.id(33463118478009030)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(33463474272009033)
,p_name=>'Close Dialog- Cancel'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(33463096129009029)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33463518209009034)
,p_event_id=>wwv_flow_api.id(33463474272009033)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(34280286351651513)
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
 p_id=>wwv_flow_api.id(34280339808651514)
,p_event_id=>wwv_flow_api.id(34280286351651513)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(33462933884009028)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(34280434461651515)
,p_event_id=>wwv_flow_api.id(34280286351651513)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(33462933884009028)
);
wwv_flow_api.component_end;
end;
/
