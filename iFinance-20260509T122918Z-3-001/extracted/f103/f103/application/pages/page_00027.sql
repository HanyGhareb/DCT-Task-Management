prompt --application/pages/page_00027
begin
--   Manifest
--     PAGE: 00027
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>116806299474925354
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>27
,p_user_interface_id=>wwv_flow_api.id(23921013981372477)
,p_name=>'Credit Card replacement'
,p_alias=>'CREDIT-CARD-REPLACEMENT'
,p_page_mode=>'MODAL'
,p_step_title=>'Credit Card replacement'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220313103350'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(18100849031298126)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_plug_template=>wwv_flow_api.id(23845862961372548)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(17841300967467544)
,p_plug_name=>'Credit Card Replacement'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(18100651691298124)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(18100849031298126)
,p_button_name=>'Submit'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_image_alt=>'Submit'
,p_button_position=>'BELOW_BOX'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(18100507953298123)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(18100849031298126)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_image_alt=>'Close'
,p_button_position=>'BELOW_BOX'
,p_button_alignment=>'LEFT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18101062549298128)
,p_name=>'P27_CREDIT_CARD_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(17841300967467544)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18100927905298127)
,p_name=>'P27_COMMENTS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(17841300967467544)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>wwv_flow_api.id(23897160841372512)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(18100455880298122)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(18100507953298123)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(18100337143298121)
,p_event_id=>wwv_flow_api.id(18100455880298122)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(18100190307298119)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Submit credit card replacement process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'P_APPROVAL_TYPE_ID    Number    := 21;',
'l_seq                Number;',
'begin',
'INSERT INTO credit_cards (',
'    creator_person_id,',
'    requestor_person_id,',
'    department_id,',
'    sector_id,',
'    cost_center,',
'    purpose,',
'    requested_amount,',
'    employee_number,',
'    email,',
'    mobile_number,',
'    adcb_customer_yn,',
'    adcb_mobile_registered,',
'    adcb_email_registered,',
'    full_name,',
'    employee_id,',
'    approval_type,',
'    created_by_request_id,',
'    notes,',
'    SUBMISSION_DATE',
') SELECT',
'    :PERSON_ID,',
'    cca.holder_person_id,',
'    cca.department_id,  ',
'    cca.sector_id,',
'    cca.cost_center,',
'    ''Replacement request'',',
'    cca.credit_limit,',
'    e.employee_num,',
'    cca.email,',
'    cca.adcb_mobile_registered,',
'    ''Y'',',
'    cca.adcb_mobile_registered,',
'    cca.adcb_email_registered,',
'    cca.holder_name,',
'    e.employee_num,',
'    P_APPROVAL_TYPE_ID,',
'    cca.id,',
'    :P27_COMMENTS,',
'    SYSTIMESTAMP',
'FROM',
'    credit_cards_all cca , employees_v e ',
'where cca.holder_person_id = e.person_id',
'and cca.id = :P27_CREDIT_CARD_ID;',
'',
'',
'-- update current record status',
'update credit_cards_all cca',
'set cca.status = ''Replacement in-progress''',
'where cca.id = :P27_CREDIT_CARD_ID;',
'-- insert Submit user',
'l_seq  := credit_cards_seq.currval;',
'credit_cards_workflow.insert_replace_submit_user(l_seq , P_APPROVAL_TYPE_ID);',
'',
'-- Insert Treasury Reviewer Team',
'credit_cards_workflow.INSERT_TREASURY_ADMIN(l_seq ,''Pending'', P_APPROVAL_TYPE_ID);',
'-- send Email to Treasury and card holder ',
'',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(18100651691298124)
,p_process_success_message=>'Replacement submitted successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(17747123025098039)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Replacement'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(18100651691298124)
);
wwv_flow_api.component_end;
end;
/
