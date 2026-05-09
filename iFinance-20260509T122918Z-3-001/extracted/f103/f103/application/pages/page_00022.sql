prompt --application/pages/page_00022
begin
--   Manifest
--     PAGE: 00022
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
 p_id=>22
,p_user_interface_id=>wwv_flow_api.id(23921013981372477)
,p_name=>'Process Credit Card'
,p_alias=>'PROCESS-CREDIT-CARD'
,p_page_mode=>'MODAL'
,p_step_title=>'Process Credit Card'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220131080938'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(25155203285138412)
,p_plug_name=>'Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(25154799414138407)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(25155203285138412)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(23898584035372508)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(25154822746138408)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(25155203285138412)
,p_button_name=>'Process'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Process'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(24678425763466150)
,p_branch_name=>'Go To 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25155103225138411)
,p_name=>'P22_CREDIT_CARD_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(25155203285138412)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25155020267138410)
,p_name=>'P22_EXPIRE_DATE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(25155203285138412)
,p_prompt=>'Expire Date'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25154954594138409)
,p_name=>'P22_CREDIT_CARD_NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(25155203285138412)
,p_prompt=>'Credit Card Num'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(25154539178138405)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(25154799414138407)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(25154419838138404)
,p_event_id=>wwv_flow_api.id(25154539178138405)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(24678535420466151)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Process Action'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update credit_cards_all',
'set status = ''Active'', expired_date = :P22_EXPIRE_DATE',
'where id = :P22_CREDIT_CARD_ID;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Credit card Active Now.'
);
wwv_flow_api.component_end;
end;
/
