prompt --application/pages/page_00018
begin
--   Manifest
--     PAGE: 00018
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
 p_id=>18
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'Payment Recommendation Comments'
,p_alias=>'PAYMENT-RECOMMENDATION-COMMENTS'
,p_page_mode=>'MODAL'
,p_step_title=>'Payment Recommendation Comments'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210905102103'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(32407373325029322)
,p_plug_name=>'Payment Recommendation Comments'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10217787920597763)
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
 p_id=>wwv_flow_api.id(32414176465029327)
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
 p_id=>wwv_flow_api.id(20836628447791981)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(32414176465029327)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10307273349597826)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(20837047197791981)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(32414176465029327)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10307273349597826)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    if :P18_CREATED_BY = :APP_USER and :P18_COMMENT_ID is not null ',
'    OR :P18_CREATED_BY_PERSON_ID = :PERSON_ID then',
'        return true;',
'    else',
'        return false;',
'    end if;',
'end;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(20837441921791982)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(32414176465029327)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10307273349597826)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    if :P18_CREATED_BY = :APP_USER and :P18_COMMENT_ID is not null ',
'    OR :P18_CREATED_BY_PERSON_ID = :PERSON_ID then',
'        return true;',
'    else',
'        return false;',
'    end if;',
'end;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(20837897652791982)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(32414176465029327)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10307273349597826)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Post'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P18_COMMENT_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20832326090791977)
,p_name=>'P18_COMMENT_TEXT'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(32407373325029322)
,p_item_source_plug_id=>wwv_flow_api.id(32407373325029322)
,p_prompt=>'Message'
,p_source=>'COMMENT_TEXT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>4000
,p_cHeight=>4
,p_read_only_when=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    if (:P18_CREATED_BY != :APP_USER )',
'        then',
'        return true;',
'    else',
'        return false;',
'    end if;',
'end;'))
,p_read_only_when_type=>'FUNCTION_BODY'
,p_field_template=>wwv_flow_api.id(10306252784597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20832796612791978)
,p_name=>'P18_COMMENT_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(32407373325029322)
,p_item_source_plug_id=>wwv_flow_api.id(32407373325029322)
,p_source=>'COMMENT_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20833184805791979)
,p_name=>'P18_PAYMENT_RECOMMENDATION_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(32407373325029322)
,p_item_source_plug_id=>wwv_flow_api.id(32407373325029322)
,p_source=>'PAYMENT_RECOMMENDATION_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20833529537791979)
,p_name=>'P18_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(32407373325029322)
,p_item_source_plug_id=>wwv_flow_api.id(32407373325029322)
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20833929564791979)
,p_name=>'P18_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(32407373325029322)
,p_item_source_plug_id=>wwv_flow_api.id(32407373325029322)
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20834381098791980)
,p_name=>'P18_CREATION_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(32407373325029322)
,p_item_source_plug_id=>wwv_flow_api.id(32407373325029322)
,p_source=>'CREATION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20834785670791980)
,p_name=>'P18_UPDATED_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(32407373325029322)
,p_item_source_plug_id=>wwv_flow_api.id(32407373325029322)
,p_source=>'UPDATED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20835188855791980)
,p_name=>'P18_ACTION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(32407373325029322)
,p_item_source_plug_id=>wwv_flow_api.id(32407373325029322)
,p_source=>'ACTION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(31143487484213438)
,p_name=>'P18_SEND_TO_ALL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(32407373325029322)
,p_item_source_plug_id=>wwv_flow_api.id(32407373325029322)
,p_prompt=>'Send To All ?'
,p_source=>'SEND_TO_ALL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_read_only_when=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    if (:P18_CREATED_BY != :APP_USER ) or :P18_CREATED_BY_PERSON_ID != :PERSON_ID',
'        then',
'        return true;',
'    else',
'        return false;',
'    end if;',
'end;'))
,p_read_only_when_type=>'FUNCTION_BODY'
,p_field_template=>wwv_flow_api.id(10306252784597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(31143580617213439)
,p_name=>'P18_TO'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(32407373325029322)
,p_item_source_plug_id=>wwv_flow_api.id(32407373325029322)
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
'where payment_recommendation_id = :P18_PAYMENT_RECOMMENDATION_ID)',
'where name is not null',
'order by 1;',
''))
,p_cHeight=>1
,p_read_only_when=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    if (:P18_CREATED_BY != :APP_USER ) or :P18_CREATED_BY_PERSON_ID != :PERSON_ID',
'        then',
'        return true;',
'    else',
'        return false;',
'    end if;',
'end;'))
,p_read_only_when_type=>'FUNCTION_BODY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(31143601639213440)
,p_name=>'P18_FILENAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(32407373325029322)
,p_item_source_plug_id=>wwv_flow_api.id(32407373325029322)
,p_source=>'FILENAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(31143759921213441)
,p_name=>'P18_FILE_MIMETYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(32407373325029322)
,p_item_source_plug_id=>wwv_flow_api.id(32407373325029322)
,p_source=>'FILE_MIMETYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(31143854774213442)
,p_name=>'P18_FILE_CHARSET'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(32407373325029322)
,p_item_source_plug_id=>wwv_flow_api.id(32407373325029322)
,p_source=>'FILE_CHARSET'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(31143945092213443)
,p_name=>'P18_FILE_BLOB'
,p_source_data_type=>'BLOB'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(32407373325029322)
,p_item_source_plug_id=>wwv_flow_api.id(32407373325029322)
,p_prompt=>'Brows'
,p_source=>'FILE_BLOB'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_FILE'
,p_cSize=>30
,p_read_only_when=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    if (:P18_CREATED_BY != :APP_USER ) or :P18_CREATED_BY_PERSON_ID != :PERSON_ID',
'        then',
'        return true;',
'    else',
'        return false;',
'    end if;',
'end;'))
,p_read_only_when_type=>'FUNCTION_BODY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
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
 p_id=>wwv_flow_api.id(31144054017213444)
,p_name=>'P18_SEND_MAIL_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(32407373325029322)
,p_item_source_plug_id=>wwv_flow_api.id(32407373325029322)
,p_item_default=>'Y'
,p_prompt=>'Send Mail ?'
,p_source=>'SEND_MAIL_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_read_only_when=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    if (:P18_CREATED_BY != :APP_USER ) or :P18_CREATED_BY_PERSON_ID != :PERSON_ID',
'        then',
'        return true;',
'    else',
'        return false;',
'    end if;',
'end;'))
,p_read_only_when_type=>'FUNCTION_BODY'
,p_field_template=>wwv_flow_api.id(10306252784597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'NO'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(31144290790213446)
,p_name=>'P18_CREATED_BY_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(32407373325029322)
,p_item_source_plug_id=>wwv_flow_api.id(32407373325029322)
,p_source=>'CREATED_BY_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(20840755945791984)
,p_validation_name=>'P18_CREATION_DATE must be timestamp'
,p_validation_sequence=>50
,p_validation=>'P18_CREATION_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(20834381098791980)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(20841154446791984)
,p_validation_name=>'P18_UPDATED_DATE must be timestamp'
,p_validation_sequence=>60
,p_validation=>'P18_UPDATED_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(20834785670791980)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(20841809006791985)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(20836628447791981)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(20842327866791985)
,p_event_id=>wwv_flow_api.id(20841809006791985)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(20835949617791981)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(32407373325029322)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Payment Recommendation Comments'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(31144169169213445)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Set Person Type and Send Email'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P18_SEND_TO_ALL = ''N'' Then',
'update cwip_payment_recommendation_comments',
'set comment_to_person_type = (Select PERSON_TYPE',
'                                from cwip_payment_rec_approval_history h',
'                                where h.payment_recommendation_id = :P18_PAYMENT_RECOMMENDATION_ID',
'                                and PERSON_ID = :P18_TO',
'                                and rownum = 1)',
'where comment_id =:P18_COMMENT_ID;',
'',
'    else',
'        update cwip_payment_recommendation_comments',
'            set comment_to_person_type = null, comment_to_person_id = null',
'            where comment_id =:P18_COMMENT_ID;',
'end if;',
'',
'-- Send Email if Enabled',
'if :P18_SEND_MAIL_YN = ''Y''',
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
'                    where payment_recommendation_id = :P18_PAYMENT_RECOMMENDATION_ID)',
'                    where name is not null)',
'    Loop',
'        cwip_rec_payment_emails.SEND_COMMENT_EMAIL(:P18_PAYMENT_RECOMMENDATION_ID,',
'                                                    :PERSON_ID,',
'                                                    :PERSON_TYPE,',
'                                                    emp.person_id,',
'                                                    emp.person_type,',
'                                                    :P18_COMMENT_TEXT);',
'    End Loop;',
'End If;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(20841491988791984)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(20835569175791980)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(32407373325029322)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Payment Recommendation Comments'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
