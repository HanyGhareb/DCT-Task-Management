prompt --application/pages/page_00116
begin
--   Manifest
--     PAGE: 00116
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>116
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Budget Proposal Comment Details'
,p_alias=>'BUDGET-PROPOSAL-COMMENT-DETAILS'
,p_page_mode=>'MODAL'
,p_step_title=>'Budget Proposal Comment Details'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230620053541'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(38566175218699970)
,p_plug_name=>'Budget Proposal Comment Details'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99730028608410735)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'BUDGET_PROPOSAL_PLAN_COMMENTS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(38560174563699967)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99731046805410735)
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_03'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(38559787860699967)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(38560174563699967)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(38558178206699966)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(38560174563699967)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    if :P116_CREATED_BY = :PERSON_ID and :P116_COMMENT_ID is not null ',
'    then',
'        return true;',
'    else',
'        return false;',
'    end if;',
'end;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(38557770774699966)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(38560174563699967)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Post Changes'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    if :P116_CREATED_BY = :PERSON_ID and :P116_COMMENT_ID is not null ',
'    then',
'        return true;',
'    else',
'        return false;',
'    end if;',
'end;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(38557339131699966)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(38560174563699967)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Post'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P116_COMMENT_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38619062595086599)
,p_name=>'P116_CREATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(38566175218699970)
,p_item_source_plug_id=>wwv_flow_api.id(38566175218699970)
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38618929812086597)
,p_name=>'P116_PROJECT_PLAN_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(38566175218699970)
,p_item_source_plug_id=>wwv_flow_api.id(38566175218699970)
,p_source=>'PROJECT_PLAN_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38618740133086596)
,p_name=>'P116_UPDATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(38566175218699970)
,p_item_source_plug_id=>wwv_flow_api.id(38566175218699970)
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38565807921699970)
,p_name=>'P116_COMMENT_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(38566175218699970)
,p_item_source_plug_id=>wwv_flow_api.id(38566175218699970)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Comment Id'
,p_source=>'COMMENT_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_label_alignment=>'RIGHT'
,p_field_template=>wwv_flow_api.id(99818469241410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38565373414699969)
,p_name=>'P116_PLAN_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(38566175218699970)
,p_item_source_plug_id=>wwv_flow_api.id(38566175218699970)
,p_source=>'PLAN_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38564963224699969)
,p_name=>'P116_SECTOR_PLAN_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(38566175218699970)
,p_item_source_plug_id=>wwv_flow_api.id(38566175218699970)
,p_source=>'SECTOR_PLAN_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38564604719699969)
,p_name=>'P116_CC_PLAN_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(38566175218699970)
,p_item_source_plug_id=>wwv_flow_api.id(38566175218699970)
,p_source=>'CC_PLAN_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38564210577699969)
,p_name=>'P116_PROJECT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(38566175218699970)
,p_item_source_plug_id=>wwv_flow_api.id(38566175218699970)
,p_source=>'PROJECT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38563812255699969)
,p_name=>'P116_TASK_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(38566175218699970)
,p_item_source_plug_id=>wwv_flow_api.id(38566175218699970)
,p_source=>'TASK_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38563429978699969)
,p_name=>'P116_COMMENT_TEXT'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(38566175218699970)
,p_item_source_plug_id=>wwv_flow_api.id(38566175218699970)
,p_prompt=>'Comment Text'
,p_source=>'COMMENT_TEXT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>4000
,p_cHeight=>4
,p_read_only_when=>':P116_UPDATED_BY != :PERSON_ID'
,p_read_only_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818469241410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38562972500699968)
,p_name=>'P116_COST_CENTER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(38566175218699970)
,p_item_source_plug_id=>wwv_flow_api.id(38566175218699970)
,p_source=>'COST_CENTER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(38559684263699967)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(38559787860699967)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(38558888852699967)
,p_event_id=>wwv_flow_api.id(38559684263699967)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(38556624599699966)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(38566175218699970)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Budget Proposal Comment Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(38618935826086598)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update FBP Comment'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update budget_proposal_projects_plans',
'set fbp_comment = :P116_COMMENT_TEXT , FBP_COMMENT_BY = :PERSON_ID, FBP_COMMENY_ON = systimestamp',
'where id = :P116_PROJECT_PLAN_ID;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>':IS_FBP_EMP = ''Y'''
,p_process_when_type=>'PLSQL_EXPRESSION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(38618720431086595)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update BP Comment'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update budget_proposal_projects_plans',
'set PB_COMMENT = :P116_COMMENT_TEXT , PB_COMMENT_BY = :PERSON_ID, PB_COMMENT_ON = systimestamp',
'where id = :P116_PROJECT_PLAN_ID;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>':IS_BUDGET_PLANNING_YN	= ''Y'''
,p_process_when_type=>'PLSQL_EXPRESSION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(38556183103699965)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(38556941781699966)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(38566175218699970)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Budget Proposal Comment Details'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
