prompt --application/pages/page_00018
begin
--   Manifest
--     PAGE: 00018
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>120
,p_default_id_offset=>143576171933264960
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>18
,p_user_interface_id=>wwv_flow_api.id(24631887413319249)
,p_name=>'Single Source Comments'
,p_alias=>'SINGLE-SOURCE-COMMENTS'
,p_page_mode=>'MODAL'
,p_step_title=>'Single Source Comments'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220408123839'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(28689808582418054)
,p_plug_name=>'Single Source Comments'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(24519865163319333)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'SCM_SINGL_SOURCE_COMMENTS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(28697139872418042)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(24520872858319332)
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_03'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(28697595016418042)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(28697139872418042)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(24609320066319275)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(28699181930418039)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(28697139872418042)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(24609320066319275)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    if (:P18_CREATED_BY_PERSON_ID != :PERSON_ID and :P18_COMMENT_ID is not null )',
'        then',
'        return false;',
'    else',
'        return true;',
'    end if;',
'end;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(28699578190418039)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(28697139872418042)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(24609320066319275)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Post Changes'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    if (:P18_CREATED_BY_PERSON_ID != :PERSON_ID and :P18_COMMENT_ID is not null )',
'        then',
'        return false;',
'    else',
'        return true;',
'    end if;',
'end;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(28699930437418038)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(28697139872418042)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(24609320066319275)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Post'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P18_COMMENT_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28690176539418053)
,p_name=>'P18_COMMENT_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(28689808582418054)
,p_item_source_plug_id=>wwv_flow_api.id(28689808582418054)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Comment Id'
,p_source=>'COMMENT_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_label_alignment=>'RIGHT'
,p_field_template=>wwv_flow_api.id(24607996412319278)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28690582840418049)
,p_name=>'P18_SINGL_SOURCE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(28689808582418054)
,p_item_source_plug_id=>wwv_flow_api.id(28689808582418054)
,p_source=>'SINGL_SOURCE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28690848828418048)
,p_name=>'P18_TO_PERSONS_IDS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(28689808582418054)
,p_item_source_plug_id=>wwv_flow_api.id(28689808582418054)
,p_source=>'TO_PERSONS_IDS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28691298186418048)
,p_name=>'P18_COMMENT_TEXT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(28689808582418054)
,p_item_source_plug_id=>wwv_flow_api.id(28689808582418054)
,p_prompt=>'Comment Text'
,p_source=>'COMMENT_TEXT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>4000
,p_cHeight=>4
,p_read_only_when=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    if (:P18_CREATED_BY_PERSON_ID != :PERSON_ID )',
'        then',
'        return true;',
'    else',
'        return false;',
'    end if;',
'end;'))
,p_read_only_when_type=>'FUNCTION_BODY'
,p_field_template=>wwv_flow_api.id(24607996412319278)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28691692014418047)
,p_name=>'P18_ACTION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(28689808582418054)
,p_item_source_plug_id=>wwv_flow_api.id(28689808582418054)
,p_source=>'ACTION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28692094592418047)
,p_name=>'P18_CREATED_BY_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(28689808582418054)
,p_item_source_plug_id=>wwv_flow_api.id(28689808582418054)
,p_source=>'CREATED_BY_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28692482541418047)
,p_name=>'P18_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(28689808582418054)
,p_item_source_plug_id=>wwv_flow_api.id(28689808582418054)
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28693271270418046)
,p_name=>'P18_UPDATED_BY_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(28689808582418054)
,p_item_source_plug_id=>wwv_flow_api.id(28689808582418054)
,p_source=>'UPDATED_BY_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28693666025418045)
,p_name=>'P18_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(28689808582418054)
,p_item_source_plug_id=>wwv_flow_api.id(28689808582418054)
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(28692905129418046)
,p_validation_name=>'P18_CREATED_ON must be timestamp'
,p_validation_sequence=>60
,p_validation=>'P18_CREATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(28692482541418047)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(28694118661418045)
,p_validation_name=>'P18_UPDATED_ON must be timestamp'
,p_validation_sequence=>80
,p_validation=>'P18_UPDATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(28693666025418045)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(28697600694418042)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(28697595016418042)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(28698453504418041)
,p_event_id=>wwv_flow_api.id(28697600694418042)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(28700745338418038)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(28689808582418054)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Single Source Comments'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(28701127345418037)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(28700324055418038)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(28689808582418054)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Single Source Comments'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
