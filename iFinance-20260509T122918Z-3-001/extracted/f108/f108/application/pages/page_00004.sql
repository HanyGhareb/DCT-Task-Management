prompt --application/pages/page_00004
begin
--   Manifest
--     PAGE: 00004
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>500
,p_default_id_offset=>354480484490134169
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>4
,p_user_interface_id=>wwv_flow_api.id(19279151117383422)
,p_name=>'MPR Documents'
,p_alias=>'MPR-DOCUMENTS'
,p_step_title=>'MPR Documents'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* Scroll Results Only in Side Column */',
'.t-Body-side {',
'    display: flex;',
'    flex-direction: column;',
'    overflow: hidden;',
'}',
'.search-results {',
'    flex: 1;',
'    overflow: auto;',
'}',
'/* Format Search Region */',
'.search-region {',
'    border-bottom: 1px solid rgba(0,0,0,.1);',
'    flex-shrink: 0;',
'}',
'',
'.t-Region-header{',
'background-color:#0e6655;',
'    color:#FFFFFF;',
'}',
'.t-Region-title{',
'    color:#FFFFFF;',
'    font-weighfont-weight: bold;',
'}',
'',
'/* Set Header Panel */',
'.t-Header-branding {',
'    background-color: #0e6655;',
'}',
'',
'',
'/* Set Breadcrumb   */',
'.t-Body-title {',
'',
'    background-color: #EEE;',
'    color:#404040;',
'}',
'',
'/* Add Button - White */',
'.t-Region-header, .t-Region-header .t-Button--link, .t-Region-header .t-Button--noUI {',
'    color:  #FFF;',
'}',
'',
'/* New Plan Button */',
'.a-Button--hot, .t-Button--hot:not(.t-Button--simple), body .ui-button.ui-button--hot, body .ui-state-default.ui-priority-primary {',
'',
'    background-color: #0e6655;',
'    color:#fff;',
'}',
'',
'',
'/*  Table Row Selected */',
'.a-GV-table tr.is-selected .a-GV-cell {',
'    background-color: #CEF6CE;',
'}',
'',
'/* Audit Region */',
'#history    .t-Region-header {',
'     background-color: #f3f0ef;',
'    color:#000;',
'}',
''))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230120055054'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(30485346742899554)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(19203962458383352)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(19140599913383303)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(19258056279383396)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(30485895591899557)
,p_plug_name=>'MPR  Documents'
,p_region_template_options=>'#DEFAULT#:t-Region--hideHeader:t-Region--scrollBody:t-Form--leftLabels'
,p_plug_template=>wwv_flow_api.id(19194535783383347)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'MPR_DOCUMENTS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(20141483182679825)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(30485895591899557)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(19256621748383394)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_button_condition=>'(:P4_ID is not null and :P4_APPROVAL_STATUS in (''Draft'' , ''Stopped''))'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(20141805953679826)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(30485895591899557)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(19256621748383394)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:&P4_FROM_PAGE.:&SESSION.::&DEBUG.::P2_ID:&P4_MPR_ID.'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(20142222273679826)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(30485895591899557)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(19256621748383394)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_button_condition=>'P4_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(20142635075679826)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(30485895591899557)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(19256621748383394)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition=>'(:P4_ID is not null and :P4_APPROVAL_STATUS in (''Draft'' , ''Stopped''))'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(20155652525679840)
,p_branch_name=>'Go To Page 3'
,p_branch_action=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.::P2_ID:&P4_MPR_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
,p_branch_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_branch_condition=>'P4_FROM_PAGE'
,p_branch_condition_text=>'2'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(20155273299679840)
,p_branch_name=>'Go To Page 6'
,p_branch_action=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.::P6_PETTY_CASH_ID:&P4_PETTY_CASH_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>11
,p_branch_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_branch_condition=>'P4_FROM_PAGE'
,p_branch_condition_text=>'6'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20127360576506824)
,p_name=>'P4_MPR_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(30485895591899557)
,p_item_source_plug_id=>wwv_flow_api.id(30485895591899557)
,p_source=>'MPR_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20139952019679821)
,p_name=>'P4_ALLOW_INSERT'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(30485346742899554)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20140318995679822)
,p_name=>'P4_ALLOW_UPDATE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(30485346742899554)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20140746513679823)
,p_name=>'P4_FROM_PAGE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(30485346742899554)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20143093153679827)
,p_name=>'P4_FILE_BLOB'
,p_source_data_type=>'BLOB'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(30485895591899557)
,p_item_source_plug_id=>wwv_flow_api.id(30485895591899557)
,p_prompt=>'File'
,p_source=>'FILE_BLOB'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_FILE'
,p_cSize=>60
,p_cMaxlength=>255
,p_read_only_when=>':P4_APPROVAL_STATUS  in ( ''Approved'' , ''Rejected'' , ''In-Progress'') and :P4_ACTION = ''edit'''
,p_read_only_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(19255616347383393)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'DB_COLUMN'
,p_attribute_02=>'FILE_MIMETYPE'
,p_attribute_03=>'FILENAME'
,p_attribute_04=>'FILE_CHARSET'
,p_attribute_05=>'UPDATED_BY'
,p_attribute_06=>'Y'
,p_attribute_08=>'attachment'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20143426789679827)
,p_name=>'P4_FILE_COMMENTS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(30485895591899557)
,p_item_source_plug_id=>wwv_flow_api.id(30485895591899557)
,p_prompt=>'Comment'
,p_source=>'FILE_COMMENTS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>4000
,p_cHeight=>4
,p_read_only_when=>':P4_APPROVAL_STATUS  in ( ''Approved'' , ''Rejected'' , ''In-Progress'') and :P4_ACTION = ''edit'''
,p_read_only_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20143879037679827)
,p_name=>'P4_TAGS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(30485895591899557)
,p_item_source_plug_id=>wwv_flow_api.id(30485895591899557)
,p_prompt=>'Tag'
,p_source=>'TAGS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>4000
,p_cHeight=>4
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20144228310679827)
,p_name=>'P4_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(30485895591899557)
,p_item_source_plug_id=>wwv_flow_api.id(30485895591899557)
,p_source=>'ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20144606177679828)
,p_name=>'P4_ROW_VERSION_NUMBER'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(30485895591899557)
,p_item_source_plug_id=>wwv_flow_api.id(30485895591899557)
,p_source=>'ROW_VERSION_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20145414277679828)
,p_name=>'P4_FILENAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(30485895591899557)
,p_item_source_plug_id=>wwv_flow_api.id(30485895591899557)
,p_source=>'FILENAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20145885975679828)
,p_name=>'P4_FILE_MIMETYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(30485895591899557)
,p_item_source_plug_id=>wwv_flow_api.id(30485895591899557)
,p_source=>'FILE_MIMETYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20146204381679829)
,p_name=>'P4_FILE_CHARSET'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(30485895591899557)
,p_item_source_plug_id=>wwv_flow_api.id(30485895591899557)
,p_source=>'FILE_CHARSET'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20146629345679829)
,p_name=>'P4_CREATED'
,p_source_data_type=>'TIMESTAMP_LTZ'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(30485895591899557)
,p_item_source_plug_id=>wwv_flow_api.id(30485895591899557)
,p_source=>'CREATED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20147003156679829)
,p_name=>'P4_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(30485895591899557)
,p_item_source_plug_id=>wwv_flow_api.id(30485895591899557)
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20147403666679829)
,p_name=>'P4_UPDATED'
,p_source_data_type=>'TIMESTAMP_LTZ'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(30485895591899557)
,p_item_source_plug_id=>wwv_flow_api.id(30485895591899557)
,p_source=>'UPDATED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20147891309679829)
,p_name=>'P4_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(30485895591899557)
,p_item_source_plug_id=>wwv_flow_api.id(30485895591899557)
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20148214584679830)
,p_name=>'P4_APPROVAL_STATUS'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(30485895591899557)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20148662996679830)
,p_name=>'P4_NO'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(30485895591899557)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(91271627705839819)
,p_name=>'P4_ACTION'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(30485346742899554)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(20154417452679838)
,p_validation_name=>'P4_CREATED must be timestamp'
,p_validation_sequence=>90
,p_validation=>'P4_CREATED'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(20146629345679829)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(20154818017679838)
,p_validation_name=>'P4_UPDATED must be timestamp'
,p_validation_sequence=>110
,p_validation=>'P4_UPDATED'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(20147403666679829)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(20149462349679831)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(30485895591899557)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Petty Cash Documents'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(20149017346679830)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(30485895591899557)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Petty Cash Documents'
);
wwv_flow_api.component_end;
end;
/
