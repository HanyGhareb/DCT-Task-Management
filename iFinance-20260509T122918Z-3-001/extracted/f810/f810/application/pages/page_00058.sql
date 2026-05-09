prompt --application/pages/page_00058
begin
--   Manifest
--     PAGE: 00058
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>58
,p_user_interface_id=>wwv_flow_api.id(12983317716762193)
,p_name=>'Send Email '
,p_alias=>'SEND-EMAIL'
,p_page_mode=>'MODAL'
,p_step_title=>'Send Email '
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231114135559'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(92627929740569642)
,p_plug_name=>'Email Outsource Company'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(92629217145579825)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noBorder'
,p_plug_template=>wwv_flow_api.id(12872392429762094)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(92629244382579826)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(92627929740569642)
,p_button_name=>'Send'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Send'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_icon_css_classes=>'fa-envelope-play'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(92629387488579827)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(92627929740569642)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(91878783703376471)
,p_name=>'P58_SEND_TO'
,p_is_required=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(92627929740569642)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select EMAIL_TO',
'  from PAYROLL_AREAS',
'where PAYROLL_AREA_ID = :P58_PAYROLL_AREA_ID',
'and status = ''A''',
'and sysdate between nvl(START_DATE , sysdate - 10) ',
'    and nvl(END_DATE , sysdate + 10);'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Send To'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>90
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'you can add multiple emails with comma separated (xx@dct.ae,YY@alc.ae)'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(91878843938376472)
,p_name=>'P58_SEND_CC'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(92627929740569642)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select EMAIL_CC',
'  from PAYROLL_AREAS',
'where PAYROLL_AREA_ID = :P58_PAYROLL_AREA_ID',
'and status = ''A''',
'and sysdate between nvl(START_DATE , sysdate - 10) ',
'    and nvl(END_DATE , sysdate + 10);'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Send Cc'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>90
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(91878997939376473)
,p_name=>'P58_SUBJECT'
,p_is_required=>true
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(92627929740569642)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select SUBJECT',
'  from PAYROLL_AREAS',
'where PAYROLL_AREA_ID = :P58_PAYROLL_AREA_ID',
'and status = ''A''',
'and sysdate between nvl(START_DATE , sysdate - 10) ',
'    and nvl(END_DATE , sysdate + 10);'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Subject'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(92629038861579824)
,p_name=>'P58_MESSAGE'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(92627929740569642)
,p_prompt=>'Message'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>100
,p_cHeight=>5
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(92629667078579830)
,p_name=>'P58_REQUEST_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(92627929740569642)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(92629740126579831)
,p_name=>'P58_VEDNOR_NAME'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(92627929740569642)
,p_prompt=>'Vendor Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(92629831773579832)
,p_name=>'P58_VEDNOR_NUM'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(92627929740569642)
,p_prompt=>'Vendor Num'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(92630041294579834)
,p_name=>'P58_SEND_BCC'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(92627929740569642)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select EMAIL_BCC',
'  from PAYROLL_AREAS',
'where PAYROLL_AREA_ID = :P58_PAYROLL_AREA_ID',
'and status = ''A''',
'and sysdate between nvl(START_DATE , sysdate - 10) ',
'    and nvl(END_DATE , sysdate + 10);'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Send Bcc'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>90
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(92630279358579836)
,p_name=>'P58_PAYROLL_AREA_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(92627929740569642)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(92632688983579860)
,p_name=>'P58_PAGE_FROM'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(92627929740569642)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(92629455296579828)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(92629387488579827)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(92629600657579829)
,p_event_id=>wwv_flow_api.id(92629455296579828)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(92630130369579835)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Send Email Outsource Company Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'MISSION_EMAIL.SEND_OUTSOURCE_COMPANY_EMAIL(:P58_REQUEST_ID, :P58_SEND_TO, ',
'											:P58_SEND_CC, :P58_SEND_BCC,',
'											:P58_SUBJECT, :P58_MESSAGE',
'											,''OUTSOURCE_COMPANY_NOTIFY'');'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(92629956485579833)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Insert Email History Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'INSERT INTO mission_emails (',
'    request_id,',
'    send_to,',
'    send_cc,',
'    send_bcc,',
'    subject,',
'    message_text',
') VALUES (',
'    :P58_REQUEST_ID,',
'    :P58_SEND_TO,',
'    :P58_SEND_CC,',
'    :P58_SEND_BCC,',
'    :P58_SUBJECT,',
'    :P58_MESSAGE);'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
