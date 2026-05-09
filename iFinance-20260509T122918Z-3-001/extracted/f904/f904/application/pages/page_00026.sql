prompt --application/pages/page_00026
begin
--   Manifest
--     PAGE: 00026
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
 p_id=>26
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'Payment Recommendation More Info'
,p_alias=>'PAYMENT-RECOMMENDATION-MORE-INFO1'
,p_page_mode=>'MODAL'
,p_step_title=>'Payment Recommendation More Info'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_css_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#WORKSPACE_IMAGES#main2.css',
'#WORKSPACE_IMAGES#main.css'))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210829203736'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(20953136434890525)
,p_plug_name=>'Payment Recommendation More Info'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10217787920597763)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'CWIP_PAYMENT_REC_MORE_INFO'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(20964704818890538)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10218704148597764)
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_03'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(20965183065890539)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(20964704818890538)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10307273349597826)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(20966766480890542)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(20964704818890538)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10307273349597826)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition=>'P26_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(20967197117890543)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(20964704818890538)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10307273349597826)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P26_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(20967569643890543)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(20964704818890538)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10307273349597826)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Send'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P26_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20781466180193906)
,p_name=>'P26_TO_ROLE_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(20953136434890525)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ROLE_ID',
'from cwip_payment_rec_approval_history',
'where payment_recommendation_id = :P26_PAYMENT_RECOMMENDATION_ID_H',
'and step_no = (select step_no - 1',
'                from cwip_payment_rec_approval_history',
'                where payment_recommendation_id = :P26_PAYMENT_RECOMMENDATION_ID_H',
'                and status = ''Pending''',
'                and person_id = :PERSON_ID)',
'and status = ''Approved'''))
,p_item_default_type=>'SQL_QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20953490259890525)
,p_name=>'P26_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(20953136434890525)
,p_item_source_plug_id=>wwv_flow_api.id(20953136434890525)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Id'
,p_source=>'ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_label_alignment=>'RIGHT'
,p_field_template=>wwv_flow_api.id(10306172661597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20953815934890529)
,p_name=>'P26_PAYMENT_RECOMMENDATION_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(20953136434890525)
,p_item_source_plug_id=>wwv_flow_api.id(20953136434890525)
,p_source=>'PAYMENT_RECOMMENDATION_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20954260481890530)
,p_name=>'P26_FROM_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(20953136434890525)
,p_item_source_plug_id=>wwv_flow_api.id(20953136434890525)
,p_item_default=>'PERSON_ID'
,p_item_default_type=>'ITEM'
,p_source=>'FROM_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20954655755890530)
,p_name=>'P26_FROM_PERSON_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(20953136434890525)
,p_item_source_plug_id=>wwv_flow_api.id(20953136434890525)
,p_item_default=>'PERSON_TYPE'
,p_item_default_type=>'ITEM'
,p_source=>'FROM_PERSON_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20955029312890531)
,p_name=>'P26_TO_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(20953136434890525)
,p_item_source_plug_id=>wwv_flow_api.id(20953136434890525)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PERSON_ID',
'from cwip_payment_rec_approval_history',
'where payment_recommendation_id = :P26_PAYMENT_RECOMMENDATION_ID_H',
'and step_no = (select step_no - 1',
'                from cwip_payment_rec_approval_history',
'                where payment_recommendation_id = :P26_PAYMENT_RECOMMENDATION_ID_H',
'                and status = ''Pending''',
'                and person_id = :PERSON_ID)',
'and status = ''Approved'''))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'To'
,p_source=>'TO_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'MORE INFO - PERSONS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct h.person_id , case h.PERSON_TYPE when ''INT''  THEN  (select e.full_name_en ',
'                                                 from employees_v e',
'                                                 where e.person_id = h.PERSON_ID)',
'                              else (select u.first_name||'' ''|| u.last_name',
'                                    from DCT_EXT_USERS u',
'                                    where u.user_id = h.PERSON_ID)',
'        End person_name ,',
'        role_id,',
'        h.on_behalf,',
'        (select r.role_name',
'            from project_role r',
'            where r.role_id = h.role_id ) role_name',
'            ,PERSON_TYPE',
'from cwip_payment_rec_approval_history h',
'where payment_recommendation_id = :P26_PAYMENT_RECOMMENDATION_ID_H',
'and status in (''Approved'' , ''Bateen'' , ''Delegated'' , ''Submit'', ''Submitted'')',
'and h.person_id  <> :PERSON_ID;'))
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(10306252784597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_10=>'PERSON_TYPE:P26_TO_PERSON_TYPE,ROLE_ID:P26_TO_ROLE_ID'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20955484615890531)
,p_name=>'P26_TO_PERSON_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(20953136434890525)
,p_item_source_plug_id=>wwv_flow_api.id(20953136434890525)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PERSON_TYPE',
'from cwip_payment_rec_approval_history',
'where payment_recommendation_id = :P26_PAYMENT_RECOMMENDATION_ID_H',
'and step_no = (select step_no - 1',
'                from cwip_payment_rec_approval_history',
'                where payment_recommendation_id = :P26_PAYMENT_RECOMMENDATION_ID_H',
'                and status = ''Pending''',
'                and person_id = :PERSON_ID)',
'and status = ''Approved'''))
,p_item_default_type=>'SQL_QUERY'
,p_source=>'TO_PERSON_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20955889001890531)
,p_name=>'P26_ACTION_REQUIRED'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(20953136434890525)
,p_item_source_plug_id=>wwv_flow_api.id(20953136434890525)
,p_prompt=>'Action Required'
,p_source=>'ACTION_REQUIRED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:More Info;More Info'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20956243180890532)
,p_name=>'P26_PRIORITY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(20953136434890525)
,p_item_source_plug_id=>wwv_flow_api.id(20953136434890525)
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
 p_id=>wwv_flow_api.id(20956669668890532)
,p_name=>'P26_COMMENTS'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(20953136434890525)
,p_item_source_plug_id=>wwv_flow_api.id(20953136434890525)
,p_prompt=>'Message'
,p_source=>'COMMENTS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>1000
,p_cHeight=>4
,p_field_template=>wwv_flow_api.id(10306368563597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20957031889890532)
,p_name=>'P26_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(20953136434890525)
,p_item_source_plug_id=>wwv_flow_api.id(20953136434890525)
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20957860649890533)
,p_name=>'P26_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(20953136434890525)
,p_item_source_plug_id=>wwv_flow_api.id(20953136434890525)
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20958298481890533)
,p_name=>'P26_CREATED_BY_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(20953136434890525)
,p_item_source_plug_id=>wwv_flow_api.id(20953136434890525)
,p_source=>'CREATED_BY_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20958691724890533)
,p_name=>'P26_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(20953136434890525)
,p_item_source_plug_id=>wwv_flow_api.id(20953136434890525)
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20959079631890534)
,p_name=>'P26_UPDATED_BY_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(20953136434890525)
,p_item_source_plug_id=>wwv_flow_api.id(20953136434890525)
,p_source=>'UPDATED_BY_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20959486304890534)
,p_name=>'P26_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(20953136434890525)
,p_item_source_plug_id=>wwv_flow_api.id(20953136434890525)
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20987678781289637)
,p_name=>'P26_PAYMENT_RECOMMENDATION_ID_H'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(20953136434890525)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(20922112832859230)
,p_computation_sequence=>10
,p_computation_item=>'P26_TO_PERSON_ID'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PERSON_ID',
'from cwip_payment_rec_approval_history',
'where payment_recommendation_id = :P26_PAYMENT_RECOMMENDATION_ID',
'and step_no = (select step_no - 1',
'                from cwip_payment_rec_approval_history',
'                where payment_recommendation_id = :P26_PAYMENT_RECOMMENDATION_ID',
'                and status = ''Pending''',
'                and person_id = :PERSON_ID)',
'and status = ''Approved'''))
,p_computation_error_message=>'error - while setting P26_TO_PERSON_ID'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(20922299069859231)
,p_computation_sequence=>20
,p_computation_item=>'P26_TO_PERSON_TYPE'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PERSON_TYPE',
'from cwip_payment_rec_approval_history',
'where payment_recommendation_id = :P26_PAYMENT_RECOMMENDATION_ID',
'and step_no = (select step_no - 1',
'                from cwip_payment_rec_approval_history',
'                where payment_recommendation_id = :P26_PAYMENT_RECOMMENDATION_ID',
'                and status = ''Pending''',
'                and person_id = :PERSON_ID)',
'and status = ''Approved'''))
,p_computation_error_message=>'error - while setting P26_TO_PERSON_TYPE'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(20957557064890533)
,p_validation_name=>'P26_CREATED_ON must be timestamp'
,p_validation_sequence=>90
,p_validation=>'P26_CREATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(20957031889890532)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(20959985190890534)
,p_validation_name=>'P26_UPDATED_ON must be timestamp'
,p_validation_sequence=>140
,p_validation=>'P26_UPDATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(20959486304890534)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(20965220977890539)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(20965183065890539)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(20966074765890541)
,p_event_id=>wwv_flow_api.id(20965220977890539)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(20987722924289638)
,p_name=>'ITEM GETS FOCUS'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(20953136434890525)
,p_bind_type=>'bind'
,p_bind_event_type=>'focusin'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(20987899869289639)
,p_event_id=>wwv_flow_api.id(20987722924289638)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ADD_CLASS'
,p_affected_elements_type=>'EVENT_SOURCE'
,p_attribute_01=>'showfocus'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(20987952747289640)
,p_name=>'ITEM LOSES FOCUS'
,p_event_sequence=>30
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(20953136434890525)
,p_bind_type=>'bind'
,p_bind_event_type=>'focusout'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(20988078585289641)
,p_event_id=>wwv_flow_api.id(20987952747289640)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_REMOVE_CLASS'
,p_affected_elements_type=>'EVENT_SOURCE'
,p_attribute_01=>'showfocus'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(20968350180890544)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(20953136434890525)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Payment Recommendation More Info'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(20988105641289642)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'More Info Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'cwip_rec_payment_workflow.MORE_INFO(:P26_PAYMENT_RECOMMENDATION_ID_H, :PERSON_ID, :P26_TO_PERSON_ID, :P26_TO_PERSON_TYPE, :P26_TO_ROLE_ID,:P26_COMMENTS, V(''PERSON_TYPE''));',
'end;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(20968762947890544)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(20967569643890543)
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(20967969446890543)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(20953136434890525)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Payment Recommendation More Info'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
