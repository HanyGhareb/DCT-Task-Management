prompt --application/pages/page_00006
begin
--   Manifest
--     PAGE: 00006
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>666
,p_default_id_offset=>90826491306730853
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>6
,p_user_interface_id=>wwv_flow_api.id(11217697745956116)
,p_name=>'Payment Recommendation Comments'
,p_alias=>'PAYMENT-RECOMMENDATION-COMMENTS'
,p_page_mode=>'MODAL'
,p_step_title=>'Message'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210905100249'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11575605740237346)
,p_plug_name=>'Payment Recommendation Comments'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(11105666197956032)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'CWIP_PAYMENT_RECOMMENDATION_COMMENTS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11582408880237351)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(11106628574956033)
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_03'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11582858525237351)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(11582408880237351)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(11195131831956089)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11584499285237352)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(11582408880237351)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(11195131831956089)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition=>'P6_COMMENT_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11584845729237352)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(11582408880237351)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(11195131831956089)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P6_COMMENT_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11585221191237353)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(11582408880237351)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(11195131831956089)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P6_COMMENT_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11576099414237346)
,p_name=>'P6_COMMENT_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(11575605740237346)
,p_item_source_plug_id=>wwv_flow_api.id(11575605740237346)
,p_source=>'COMMENT_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11576488151237347)
,p_name=>'P6_PAYMENT_RECOMMENDATION_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(11575605740237346)
,p_item_source_plug_id=>wwv_flow_api.id(11575605740237346)
,p_source=>'PAYMENT_RECOMMENDATION_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11576819068237347)
,p_name=>'P6_COMMENT_TEXT'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(11575605740237346)
,p_item_source_plug_id=>wwv_flow_api.id(11575605740237346)
,p_prompt=>'Text'
,p_source=>'COMMENT_TEXT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>4000
,p_cHeight=>4
,p_read_only_when=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    if (:P6_CREATED_BY != :APP_USER )',
'        then',
'        return true;',
'    else',
'        return false;',
'    end if;',
'end;'))
,p_read_only_when_type=>'FUNCTION_BODY'
,p_field_template=>wwv_flow_api.id(11194148454956088)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11577227820237347)
,p_name=>'P6_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(11575605740237346)
,p_item_source_plug_id=>wwv_flow_api.id(11575605740237346)
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11577651803237348)
,p_name=>'P6_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(11575605740237346)
,p_item_source_plug_id=>wwv_flow_api.id(11575605740237346)
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11578043947237348)
,p_name=>'P6_CREATION_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(11575605740237346)
,p_item_source_plug_id=>wwv_flow_api.id(11575605740237346)
,p_source=>'CREATION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11578832014237349)
,p_name=>'P6_UPDATED_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(11575605740237346)
,p_item_source_plug_id=>wwv_flow_api.id(11575605740237346)
,p_source=>'UPDATED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11579688360237349)
,p_name=>'P6_ACTION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(11575605740237346)
,p_item_source_plug_id=>wwv_flow_api.id(11575605740237346)
,p_source=>'ACTION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(40072638418098348)
,p_name=>'P6_TO'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(11575605740237346)
,p_item_source_plug_id=>wwv_flow_api.id(11575605740237346)
,p_prompt=>'To'
,p_source=>'COMMENT_TO_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  NAME ,  PERSON_ID',
'From ',
'(select distinct person_id, case person_type',
'    When ''INT''',
'    Then (select full_name_en ',
'            from employees_v ',
'            where employees_v.person_id = cwip_payment_rec_approval_history.person_id',
'             and employees_v.person_id  != :PERSON_ID',
'             ) ',
'    When ''EXT''',
'        Then ',
'            (Select full_name_en ',
'            from dct_ext_users',
'            where user_id =  cwip_payment_rec_approval_history.person_id',
'            and user_id != :PERSON_ID',
'            )',
'    End name ',
'    , person_type',
'from cwip_payment_rec_approval_history ',
'where payment_recommendation_id = :P6_PAYMENT_RECOMMENDATION_ID)',
'where name is not null',
'order by 1;',
''))
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(40202560122767422)
,p_name=>'P6_SEND_TO_ALL'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(11575605740237346)
,p_item_source_plug_id=>wwv_flow_api.id(11575605740237346)
,p_item_default=>'Y'
,p_prompt=>'Send To All ?'
,p_source=>'SEND_TO_ALL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(11194148454956088)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(40205036499767447)
,p_name=>'P6_FILENAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(11575605740237346)
,p_item_source_plug_id=>wwv_flow_api.id(11575605740237346)
,p_source=>'FILENAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(40205178333767448)
,p_name=>'P6_FILE_MIMETYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(11575605740237346)
,p_item_source_plug_id=>wwv_flow_api.id(11575605740237346)
,p_source=>'FILE_MIMETYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(40205298925767449)
,p_name=>'P6_FILE_CHARSET'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(11575605740237346)
,p_item_source_plug_id=>wwv_flow_api.id(11575605740237346)
,p_source=>'FILE_CHARSET'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(40205373111767450)
,p_name=>'P6_FILE_BLOB'
,p_source_data_type=>'BLOB'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(11575605740237346)
,p_item_source_plug_id=>wwv_flow_api.id(11575605740237346)
,p_prompt=>'Brows'
,p_source=>'FILE_BLOB'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_FILE'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'DB_COLUMN'
,p_attribute_02=>'FILE_MIMETYPE'
,p_attribute_03=>'FILENAME'
,p_attribute_04=>'FILE_CHARSET'
,p_attribute_05=>'UPDATED_DATE'
,p_attribute_06=>'Y'
,p_attribute_08=>'attachment'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(40303081705167701)
,p_name=>'P6_SEND_MAIL_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(11575605740237346)
,p_item_source_plug_id=>wwv_flow_api.id(11575605740237346)
,p_item_default=>'Y'
,p_prompt=>'Send Mail ?'
,p_source=>'SEND_MAIL_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(11194148454956088)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(11578536250237348)
,p_validation_name=>'P6_CREATION_DATE must be timestamp'
,p_validation_sequence=>50
,p_validation=>'P6_CREATION_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(11578043947237348)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(11579340109237349)
,p_validation_name=>'P6_UPDATED_DATE must be timestamp'
,p_validation_sequence=>60
,p_validation=>'P6_UPDATED_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(11578832014237349)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(11582982742237351)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(11582858525237351)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(11583731589237352)
,p_event_id=>wwv_flow_api.id(11582982742237351)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(40202618983767423)
,p_name=>'Send to All DA'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P6_SEND_TO_ALL'
,p_condition_element=>'P6_SEND_TO_ALL'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(40203696292767433)
,p_event_id=>wwv_flow_api.id(40202618983767423)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P6_TO'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(40204756623767444)
,p_event_id=>wwv_flow_api.id(40202618983767423)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P6_TO'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(40202736317767424)
,p_event_id=>wwv_flow_api.id(40202618983767423)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P6_TO'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(40204826529767445)
,p_event_id=>wwv_flow_api.id(40202618983767423)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P6_TO_EXT'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(11586083166237353)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(11575605740237346)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Payment Recommendation Comments'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(40204941906767446)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Set Person Type'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P6_SEND_TO_ALL = ''N'' Then',
'update cwip_payment_recommendation_comments',
'set comment_to_person_type = (Select PERSON_TYPE',
'                                from cwip_payment_rec_approval_history h',
'                                where h.payment_recommendation_id = :P6_PAYMENT_RECOMMENDATION_ID',
'                                and PERSON_ID = :P6_TO',
'                                and rownum = 1)',
'where comment_id =:P6_COMMENT_ID;',
'',
'    else',
'        update cwip_payment_recommendation_comments',
'            set comment_to_person_type = null, comment_to_person_id = null',
'            where comment_id =:P6_COMMENT_ID;',
'end if;',
'',
'-- Send Email if Enabled',
'if :P6_SEND_MAIL_YN = ''Y''',
'    Then',
'    for emp in (select  PERSON_ID , person_type',
'                    From ',
'                    (select distinct person_id, case person_type',
'                        When ''INT''',
'                        Then (select full_name_en ',
'                                from employees_v ',
'                                where employees_v.person_id = cwip_payment_rec_approval_history.person_id',
'                                 and employees_v.person_id  != :PERSON_ID',
'                                 ) ',
'                        When ''EXT''',
'                            Then ',
'                                (Select full_name_en ',
'                                from dct_ext_users',
'                                where user_id =  cwip_payment_rec_approval_history.person_id',
'                                and user_id != :PERSON_ID',
'                                )',
'                        End name ',
'                        , person_type',
'                    from cwip_payment_rec_approval_history ',
'                    where payment_recommendation_id = :P6_PAYMENT_RECOMMENDATION_ID)',
'                    where name is not null)',
'    Loop',
'        cwip_rec_payment_emails.SEND_COMMENT_EMAIL(:P6_PAYMENT_RECOMMENDATION_ID,',
'                                                    :PERSON_ID,',
'                                                    :PERSON_TYPE,',
'                                                    emp.person_id,',
'                                                    emp.person_type,',
'                                                    :P6_COMMENT_TEXT);',
'    End Loop;',
'End If;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(11586434766237353)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(11585606680237353)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(11575605740237346)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Payment Recommendation Comments'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
