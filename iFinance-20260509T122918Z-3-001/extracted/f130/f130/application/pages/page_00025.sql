prompt --application/pages/page_00025
begin
--   Manifest
--     PAGE: 00025
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
 p_id=>25
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'Payment Recommendation More Info'
,p_alias=>'PAYMENT-RECOMMENDATION-MORE-INFO'
,p_page_mode=>'MODAL'
,p_step_title=>'Payment Recommendation More Info'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210208113700'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(20919985011859208)
,p_plug_name=>'New'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'CWIP_PAYMENT_REC_MORE_INFO'
,p_include_rowid_column=>false
,p_is_editable=>false
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(20922011435859229)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(20919985011859208)
,p_button_name=>'Send'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10307273349597826)
,p_button_image_alt=>'Send'
,p_button_position=>'BELOW_BOX'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20920193551859210)
,p_name=>'P25_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(20919985011859208)
,p_item_source_plug_id=>wwv_flow_api.id(20919985011859208)
,p_prompt=>'Id'
,p_source=>'ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(10306172661597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20920272708859211)
,p_name=>'P25_PAYMENT_RECOMMENDATION_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(20919985011859208)
,p_item_source_plug_id=>wwv_flow_api.id(20919985011859208)
,p_prompt=>'Payment Recommendation Id'
,p_source=>'PAYMENT_RECOMMENDATION_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(10306172661597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20920323489859212)
,p_name=>'P25_FROM_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(20919985011859208)
,p_item_source_plug_id=>wwv_flow_api.id(20919985011859208)
,p_item_default=>'PERSON_ID'
,p_item_default_type=>'ITEM'
,p_prompt=>'From Person Id'
,p_source=>'FROM_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(10306172661597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20920487433859213)
,p_name=>'P25_FROM_PERSON_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(20919985011859208)
,p_item_source_plug_id=>wwv_flow_api.id(20919985011859208)
,p_item_default=>'PERSON_TYPE'
,p_item_default_type=>'ITEM'
,p_prompt=>'From Person Type'
,p_source=>'FROM_PERSON_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>20
,p_field_template=>wwv_flow_api.id(10306172661597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20920549285859214)
,p_name=>'P25_TO_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(20919985011859208)
,p_item_source_plug_id=>wwv_flow_api.id(20919985011859208)
,p_prompt=>'To Person Id'
,p_source=>'TO_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(10306172661597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20920670530859215)
,p_name=>'P25_TO_PERSON_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(20919985011859208)
,p_item_source_plug_id=>wwv_flow_api.id(20919985011859208)
,p_prompt=>'To Person Type'
,p_source=>'TO_PERSON_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>20
,p_field_template=>wwv_flow_api.id(10306172661597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20920738502859216)
,p_name=>'P25_ACTION_REQUIRED'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(20919985011859208)
,p_item_source_plug_id=>wwv_flow_api.id(20919985011859208)
,p_prompt=>'Action Required'
,p_source=>'ACTION_REQUIRED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC:More Info;More Info'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20920873819859217)
,p_name=>'P25_PRIORITY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(20919985011859208)
,p_item_source_plug_id=>wwv_flow_api.id(20919985011859208)
,p_item_default=>'L'
,p_prompt=>'Priority'
,p_source=>'PRIORITY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Urgent;Urgent,High;High,Medium;Medium,Low;Low'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20920909977859218)
,p_name=>'P25_COMMENTS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(20919985011859208)
,p_item_source_plug_id=>wwv_flow_api.id(20919985011859208)
,p_prompt=>'Message'
,p_source=>'COMMENTS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>1000
,p_cHeight=>5
,p_field_template=>wwv_flow_api.id(10306172661597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20921057664859219)
,p_name=>'P25_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(20919985011859208)
,p_item_source_plug_id=>wwv_flow_api.id(20919985011859208)
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20921156605859220)
,p_name=>'P25_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(20919985011859208)
,p_item_source_plug_id=>wwv_flow_api.id(20919985011859208)
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20921280687859221)
,p_name=>'P25_CREATED_BY_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(20919985011859208)
,p_item_source_plug_id=>wwv_flow_api.id(20919985011859208)
,p_source=>'CREATED_BY_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20921358348859222)
,p_name=>'P25_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(20919985011859208)
,p_item_source_plug_id=>wwv_flow_api.id(20919985011859208)
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20921402696859223)
,p_name=>'P25_UPDATED_BY_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(20919985011859208)
,p_item_source_plug_id=>wwv_flow_api.id(20919985011859208)
,p_source=>'UPDATED_BY_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20921586117859224)
,p_name=>'P25_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(20919985011859208)
,p_item_source_plug_id=>wwv_flow_api.id(20919985011859208)
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(20921871076859227)
,p_computation_sequence=>10
,p_computation_item=>'P25_TO_PERSON_ID'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PERSON_ID',
'from cwip_payment_rec_approval_history',
'where payment_recommendation_id = :P25_PAYMENT_RECOMMENDATION_ID',
'and step_no = (select step_no - 1',
'                from cwip_payment_rec_approval_history',
'                where payment_recommendation_id = :P25_PAYMENT_RECOMMENDATION_ID',
'                and status = ''Pending''',
'                and person_id = :PERSON_ID)',
'and status = ''Approved'''))
,p_computation_error_message=>'error - while setting P25_TO_PERSON_ID'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(20921966058859228)
,p_computation_sequence=>20
,p_computation_item=>'P25_TO_PERSON_TYPE'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PERSON_TYPE',
'from cwip_payment_rec_approval_history',
'where payment_recommendation_id = :P25_PAYMENT_RECOMMENDATION_ID',
'and step_no = (select step_no - 1',
'                from cwip_payment_rec_approval_history',
'                where payment_recommendation_id = :P25_PAYMENT_RECOMMENDATION_ID',
'                and status = ''Pending''',
'                and person_id = :PERSON_ID)',
'and status = ''Approved'''))
,p_computation_error_message=>'error - while setting P25_TO_PERSON_TYPE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(20920028560859209)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(20919985011859208)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Payment Recommendation More Info'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
