prompt --application/pages/page_00019
begin
--   Manifest
--     PAGE: 00019
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>100
,p_default_id_offset=>40620729557075005
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>19
,p_user_interface_id=>wwv_flow_api.id(1686359760302353)
,p_name=>'Delegation Management Details'
,p_alias=>'DELEGATION-MANAGEMENT-DETAILS'
,p_step_title=>'Delegation Management Details'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210714065311'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(5813345842771125)
,p_plug_name=>'Delegation Management Details'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(1601776079302283)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'DELEGATIONS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(5833186542771136)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(1611180433302287)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(1547752126302241)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(1665264360302322)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5824259381771131)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(5813345842771125)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(1663835798302321)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_button_condition=>'P19_DELEGATION_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5823066534771130)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(5813345842771125)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(1663835798302321)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:18:&SESSION.::&DEBUG.:::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5824643948771131)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(5813345842771125)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(1663835798302321)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_button_condition=>'P19_DELEGATION_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5823854257771131)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(5813345842771125)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(1663835798302321)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition_type=>'NEVER'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(5824953445771131)
,p_branch_action=>'f?p=&APP_ID.:18:&SESSION.::&DEBUG.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5813735713771125)
,p_name=>'P19_DELEGATION_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(5813345842771125)
,p_item_source_plug_id=>wwv_flow_api.id(5813345842771125)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Delegation Id'
,p_source=>'DELEGATION_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_label_alignment=>'RIGHT'
,p_field_template=>wwv_flow_api.id(1662779496302319)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5814113584771125)
,p_name=>'P19_FROM_EMP_NUM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(5813345842771125)
,p_item_source_plug_id=>wwv_flow_api.id(5813345842771125)
,p_prompt=>'Delegate From'
,p_source=>'FROM_EMP_NUM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'ALL EMPLOYEES BY EMP NUM LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en ',
'    , employee_num',
'from dct_employees_list2'))
,p_lov_display_null=>'YES'
,p_cSize=>32
,p_cMaxlength=>10
,p_field_template=>wwv_flow_api.id(1662887660302319)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_07=>'Select Employee'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5814569199771126)
,p_name=>'P19_TO_EMP_NUM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(5813345842771125)
,p_item_source_plug_id=>wwv_flow_api.id(5813345842771125)
,p_prompt=>'Delegate To'
,p_source=>'TO_EMP_NUM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'ALL EMPLOYEES BY EMP NUM LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en ',
'    , employee_num',
'from dct_employees_list2'))
,p_lov_display_null=>'YES'
,p_cSize=>32
,p_cMaxlength=>10
,p_field_template=>wwv_flow_api.id(1662887660302319)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_07=>'Select Employee'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5814972034771126)
,p_name=>'P19_MODULE'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(5813345842771125)
,p_item_source_plug_id=>wwv_flow_api.id(5813345842771125)
,p_item_default=>'All'
,p_prompt=>'Module'
,p_source=>'MODULE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:All;All,Petty Cash Management;Petty Cash Management,Budget Transfer Management;Budget Transfer Management,Credit Cards;Credit Cards,Prepaid Cards;Prepaid Cards'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(1662887660302319)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5815306957771126)
,p_name=>'P19_START_DATE'
,p_source_data_type=>'TIMESTAMP_LTZ'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(5813345842771125)
,p_item_source_plug_id=>wwv_flow_api.id(5813345842771125)
,p_prompt=>'Start Date'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'START_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(1662887660302319)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5816111443771127)
,p_name=>'P19_END_DATE'
,p_source_data_type=>'TIMESTAMP_LTZ'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(5813345842771125)
,p_item_source_plug_id=>wwv_flow_api.id(5813345842771125)
,p_prompt=>'End Date'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'END_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(1662887660302319)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5816913661771127)
,p_name=>'P19_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(5813345842771125)
,p_item_source_plug_id=>wwv_flow_api.id(5813345842771125)
,p_item_default=>'A'
,p_prompt=>'Status'
,p_source=>'STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'STATUS LOV'
,p_lov=>'.'||wwv_flow_api.id(2460154646694716)||'.'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(1662565247302319)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5817367787771127)
,p_name=>'P19_CREATED'
,p_source_data_type=>'TIMESTAMP_LTZ'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(5813345842771125)
,p_item_source_plug_id=>wwv_flow_api.id(5813345842771125)
,p_prompt=>'Created'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CREATED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P19_DELEGATION_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(1662565247302319)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5818148187771128)
,p_name=>'P19_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(5813345842771125)
,p_item_source_plug_id=>wwv_flow_api.id(5813345842771125)
,p_prompt=>'Created By'
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P19_DELEGATION_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(1662565247302319)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5818569778771128)
,p_name=>'P19_UPDATED'
,p_source_data_type=>'TIMESTAMP_LTZ'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(5813345842771125)
,p_item_source_plug_id=>wwv_flow_api.id(5813345842771125)
,p_prompt=>'Updated'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'UPDATED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P19_DELEGATION_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(1662565247302319)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5819368562771128)
,p_name=>'P19_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(5813345842771125)
,p_item_source_plug_id=>wwv_flow_api.id(5813345842771125)
,p_prompt=>'Updated By'
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P19_DELEGATION_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(1662565247302319)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36733714821215636)
,p_name=>'P19_FROM_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(5813345842771125)
,p_item_source_plug_id=>wwv_flow_api.id(5813345842771125)
,p_source=>'FROM_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36733843341215637)
,p_name=>'P19_TO_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(5813345842771125)
,p_item_source_plug_id=>wwv_flow_api.id(5813345842771125)
,p_source=>'TO_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(5815883544771126)
,p_validation_name=>'P19_START_DATE must be timestamp'
,p_validation_sequence=>40
,p_validation=>'P19_START_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(5815306957771126)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(5816642397771127)
,p_validation_name=>'P19_END_DATE must be timestamp'
,p_validation_sequence=>50
,p_validation=>'P19_END_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(5816111443771127)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(5817831722771128)
,p_validation_name=>'P19_CREATED must be timestamp'
,p_validation_sequence=>70
,p_validation=>'P19_CREATED'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(5817367787771127)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(5819096016771128)
,p_validation_name=>'P19_UPDATED must be timestamp'
,p_validation_sequence=>90
,p_validation=>'P19_UPDATED'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(5818569778771128)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(36733972179215638)
,p_name=>'set From Person ID DA'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P19_FROM_EMP_NUM'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(36734011878215639)
,p_event_id=>wwv_flow_api.id(36733972179215638)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P19_FROM_PERSON_ID'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select person_id',
'from dct_employees_list2',
'where employee_num = :P19_FROM_EMP_NUM'))
,p_attribute_07=>'P19_FROM_EMP_NUM'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(36734173151215640)
,p_name=>'Set To_Person_ID DA'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P19_TO_EMP_NUM'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(36734282244215641)
,p_event_id=>wwv_flow_api.id(36734173151215640)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P19_TO_PERSON_ID'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select person_id',
'from dct_employees_list2',
'where employee_num = :P19_TO_EMP_NUM'))
,p_attribute_07=>'P19_TO_EMP_NUM'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(5825873607771132)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(5813345842771125)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Delegation Management Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(5825462095771132)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(5813345842771125)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Delegation Management Details'
);
wwv_flow_api.component_end;
end;
/
