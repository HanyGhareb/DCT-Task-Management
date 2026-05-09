prompt --application/pages/page_00042
begin
--   Manifest
--     PAGE: 00042
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>42
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Petty cash tracking details'
,p_alias=>'PETTY-CASH-TRACKING-DETAILS'
,p_step_title=>'Petty cash tracking details'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210628125038'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1767723569854451)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8067277693175509)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(8003821207175482)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(8121335853175533)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1767120772854699)
,p_plug_name=>'Petty cash tracking details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'HRSS_PETTY_CASH_TRACKING'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1756430745854714)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(1767120772854699)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_button_condition=>'P42_TRACK_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1757619700854713)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(1767120772854699)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:41:&SESSION.::&DEBUG.::P41_PETTY_CASH_ID:&P42_PETTY_CASH_ID.'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1756042895854715)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(1767120772854699)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_button_condition=>'P42_TRACK_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1756873909854714)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(1767120772854699)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition=>'P42_TRACK_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(1755718352854715)
,p_branch_name=>'Go To Page 41'
,p_branch_action=>'f?p=&APP_ID.:41:&SESSION.::&DEBUG.::P41_PETTY_CASH_ID:&P42_PETTY_CASH_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1766861260854700)
,p_name=>'P42_TRACK_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(1767120772854699)
,p_item_source_plug_id=>wwv_flow_api.id(1767120772854699)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Track Id'
,p_source=>'TRACK_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_label_alignment=>'RIGHT'
,p_field_template=>wwv_flow_api.id(8118554792175530)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1766445061854703)
,p_name=>'P42_PETTY_CASH_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(1767120772854699)
,p_item_source_plug_id=>wwv_flow_api.id(1767120772854699)
,p_source=>'PETTY_CASH_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1766091561854705)
,p_name=>'P42_COMMENT_TEXT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(1767120772854699)
,p_item_source_plug_id=>wwv_flow_api.id(1767120772854699)
,p_prompt=>'Comment / Tracking Details'
,p_source=>'COMMENT_TEXT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>2000
,p_cHeight=>4
,p_field_template=>wwv_flow_api.id(8118975198175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1765604824854705)
,p_name=>'P42_ACTION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(1767120772854699)
,p_item_source_plug_id=>wwv_flow_api.id(1767120772854699)
,p_source=>'ACTION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1765210691854706)
,p_name=>'P42_FILENAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(1767120772854699)
,p_item_source_plug_id=>wwv_flow_api.id(1767120772854699)
,p_source=>'FILENAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1764857682854706)
,p_name=>'P42_FILE_MIMETYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(1767120772854699)
,p_item_source_plug_id=>wwv_flow_api.id(1767120772854699)
,p_source=>'FILE_MIMETYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1764450584854706)
,p_name=>'P42_FILE_CHARSET'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(1767120772854699)
,p_item_source_plug_id=>wwv_flow_api.id(1767120772854699)
,p_source=>'FILE_CHARSET'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1764085365854707)
,p_name=>'P42_FILE_BLOB'
,p_source_data_type=>'BLOB'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(1767120772854699)
,p_item_source_plug_id=>wwv_flow_api.id(1767120772854699)
,p_prompt=>'File Blob'
,p_source=>'FILE_BLOB'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_FILE'
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(8118975198175531)
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
 p_id=>wwv_flow_api.id(1763600651854707)
,p_name=>'P42_CREATED_BY_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(1767120772854699)
,p_item_source_plug_id=>wwv_flow_api.id(1767120772854699)
,p_prompt=>'Created By'
,p_source=>'CREATED_BY_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEE NAME BY PERSONID LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en , person_id',
'from dct_employees_list2'))
,p_display_when=>'P42_TRACK_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1763295591854707)
,p_name=>'P42_UPDATED_BY_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(1767120772854699)
,p_item_source_plug_id=>wwv_flow_api.id(1767120772854699)
,p_prompt=>'Updated By'
,p_source=>'UPDATED_BY_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEE NAME BY PERSONID LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en , person_id',
'from dct_employees_list2'))
,p_begin_on_new_line=>'N'
,p_display_when=>'P42_TRACK_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1762872010854708)
,p_name=>'P42_CREATION_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(1767120772854699)
,p_item_source_plug_id=>wwv_flow_api.id(1767120772854699)
,p_prompt=>'Creation Date'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CREATION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P42_TRACK_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1762072631854709)
,p_name=>'P42_UPDATED_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(1767120772854699)
,p_item_source_plug_id=>wwv_flow_api.id(1767120772854699)
,p_prompt=>'Updated Date'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'UPDATED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>'P42_TRACK_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(1762389011854708)
,p_validation_name=>'P42_CREATION_DATE must be timestamp'
,p_validation_sequence=>100
,p_validation=>'P42_CREATION_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(1762872010854708)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(1761542188854709)
,p_validation_name=>'P42_UPDATED_DATE must be timestamp'
,p_validation_sequence=>110
,p_validation=>'P42_UPDATED_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(1762072631854709)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1754861307854715)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(1767120772854699)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Petty cash tracking details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(2353850591472809)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'update Current Track'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update hrss_petty_cash_tracking',
'set last_track = (select max(nvl(l.last_track , 0)) + 1',
'                    from hrss_petty_cash_tracking l',
'                  where l.PETTY_CASH_ID = :P42_PETTY_CASH_ID)',
'where track_id = :P42_TRACK_ID;',
'',
'EXCEPTION WHEN OTHERS Then',
'    null;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(1756042895854715)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1755216219854715)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(1767120772854699)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Petty cash tracking details'
);
wwv_flow_api.component_end;
end;
/
