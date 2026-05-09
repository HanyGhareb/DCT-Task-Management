prompt --application/pages/page_00024
begin
--   Manifest
--     PAGE: 00024
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
 p_id=>24
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Petty Cash Invoice Details'
,p_alias=>'PETTY-CASH-INVOICE-DETAILS'
,p_page_mode=>'MODAL'
,p_step_title=>'Petty Cash Invoice Details'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210422094641'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(30286306968437350)
,p_plug_name=>'Petty Cash Invoice Details'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8030481219175499)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'HRSS_PETTY_CASH'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(30309263801437359)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8031419283175499)
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_03'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(30309613506437359)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(30309263801437359)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(30311219806437360)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(30309263801437359)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition_type=>'NEVER'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(30311629807437360)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(30309263801437359)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P24_PETTY_CASH_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(30312034205437360)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(30309263801437359)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P24_PETTY_CASH_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1930081548356601)
,p_name=>'P24_PENDING_WITH_AP'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_prompt=>'Pending With AP?'
,p_source=>'PENDING_WITH_AP'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30286727169437350)
,p_name=>'P24_PETTY_CASH_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Petty Cash Id'
,p_source=>'PETTY_CASH_ID'
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
 p_id=>wwv_flow_api.id(30287188902437350)
,p_name=>'P24_PETTY_CASH_NO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_prompt=>'Petty Cash No'
,p_source=>'PETTY_CASH_NO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30287557463437350)
,p_name=>'P24_PETTY_CASH_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_source=>'PETTY_CASH_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30287989045437351)
,p_name=>'P24_DUE_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_source=>'DUE_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30288334565437351)
,p_name=>'P24_PETTY_CASH_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_source=>'PETTY_CASH_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30288752624437351)
,p_name=>'P24_EMPLOYEE_NUM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_source=>'EMPLOYEE_NUM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30289169525437351)
,p_name=>'P24_PROJECT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_source=>'PROJECT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30289531396437351)
,p_name=>'P24_TASK'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_source=>'TASK'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30289987500437351)
,p_name=>'P24_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_source=>'AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30290331646437352)
,p_name=>'P24_PURPOSE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_source=>'PURPOSE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30290760306437352)
,p_name=>'P24_CLOSING_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_source=>'CLOSING_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30291173605437352)
,p_name=>'P24_APPROVAL_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_source=>'APPROVAL_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30291520289437352)
,p_name=>'P24_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_source=>'STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30291997273437352)
,p_name=>'P24_RECONCILED_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_source=>'RECONCILED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30292365343437352)
,p_name=>'P24_PRIORITY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_source=>'PRIORITY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30292774325437353)
,p_name=>'P24_CREATION_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_source=>'CREATION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30293551272437353)
,p_name=>'P24_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30293935800437353)
,p_name=>'P24_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30294351457437353)
,p_name=>'P24_UPDATED_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_source=>'UPDATED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30295133776437354)
,p_name=>'P24_YEAR'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_source=>'YEAR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30295523663437354)
,p_name=>'P24_GL_ACCOUNT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_source=>'GL_ACCOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30295913561437354)
,p_name=>'P24_JUSTIFICATION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_source=>'JUSTIFICATION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30296363339437354)
,p_name=>'P24_COMMENT_TO_APPROVER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_source=>'COMMENT_TO_APPROVER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30296768338437354)
,p_name=>'P24_INVOICING_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_prompt=>'Invoicing ?'
,p_source=>'INVOICING_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30297156499437354)
,p_name=>'P24_PAID_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_prompt=>'Paid ?'
,p_source=>'PAID_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(8118975198175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30297508097437355)
,p_name=>'P24_INVOICE_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_prompt=>'Invoice #'
,p_source=>'INVOICE_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>100
,p_field_template=>wwv_flow_api.id(8118975198175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30297912069437355)
,p_name=>'P24_INVOICE_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_prompt=>'Invoice Date'
,p_source=>'INVOICE_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>32
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(8118975198175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30298390158437355)
,p_name=>'P24_PV_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_prompt=>'PV Number'
,p_source=>'PV_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>20
,p_field_template=>wwv_flow_api.id(8118975198175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30298773099437355)
,p_name=>'P24_GL_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_prompt=>'GL Date'
,p_source=>'GL_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>32
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(8118975198175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30299106756437355)
,p_name=>'P24_PAYMENT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_prompt=>'Payment #'
,p_source=>'PAYMENT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>100
,p_field_template=>wwv_flow_api.id(8118975198175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30299520209437355)
,p_name=>'P24_PAYMENT_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>320
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_item_source_plug_id=>wwv_flow_api.id(30286306968437350)
,p_prompt=>'Payment Date'
,p_source=>'PAYMENT_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>32
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(8118975198175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30354759404996017)
,p_name=>'P24_TREASURY'
,p_item_sequence=>330
,p_item_plug_id=>wwv_flow_api.id(30286306968437350)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(30293233763437353)
,p_validation_name=>'P24_CREATION_DATE must be timestamp'
,p_validation_sequence=>150
,p_validation=>'P24_CREATION_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(30292774325437353)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(30294864107437354)
,p_validation_name=>'P24_UPDATED_DATE must be timestamp'
,p_validation_sequence=>180
,p_validation=>'P24_UPDATED_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(30294351457437353)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(30309727366437359)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(30309613506437359)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(30310531240437359)
,p_event_id=>wwv_flow_api.id(30309727366437359)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(30216956374181318)
,p_name=>'Show Invoice Details'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P24_INVOICING_YN'
,p_condition_element=>'P24_INVOICING_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(30217014379181319)
,p_event_id=>wwv_flow_api.id(30216956374181318)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_INVOICE_NUMBER,P24_INVOICE_DATE,P24_PV_NUMBER,P24_GL_DATE,P24_PAID_YN'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(30217191999181320)
,p_event_id=>wwv_flow_api.id(30216956374181318)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_INVOICE_NUMBER,P24_INVOICE_DATE,P24_PV_NUMBER,P24_GL_DATE,P24_PAID_YN'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(30217593489181324)
,p_event_id=>wwv_flow_api.id(30216956374181318)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_INVOICE_NUMBER,P24_INVOICE_DATE,P24_GL_DATE'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select :P24_PETTY_CASH_NO , ',
'        sysdate      inv_date ,',
'        sysdate     gl_date',
'from dual'))
,p_attribute_07=>'P24_PETTY_CASH_NO'
,p_attribute_08=>'N'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(30217218530181321)
,p_name=>'Sow Payment Details'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P24_PAID_YN'
,p_condition_element=>'P24_PAID_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(30217353570181322)
,p_event_id=>wwv_flow_api.id(30217218530181321)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_PAYMENT_NUMBER,P24_PAYMENT_DATE'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(30217421518181323)
,p_event_id=>wwv_flow_api.id(30217218530181321)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_PAYMENT_NUMBER,P24_PAYMENT_DATE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(30312833144437360)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(30286306968437350)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Petty Cash Invoice Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(30217800383181327)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Send  Invoice Notification'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'INSERT INTO all_notifications (',
'                                user_name,',
'                                notification_type,',
'                                request_id,',
'                                action_type,',
'                                acknowledge',
'                    ) VALUES (',
'                                :P24_EMPLOYEE_NUM,',
'                                ''Petty Cash Invoiced'',',
'                                :P24_PETTY_CASH_ID,',
'                                ''FYI'',',
'                                ''N''',
'                    );',
'                                ',
'INSERT INTO petty_cash_all_actions (',
'    request_type,',
'    request_id,',
'    action_type',
') VALUES (',
'    ''PETTY CASH REQUEST'',',
'    :P24_PETTY_CASH_ID,',
'    ''Petty Cash Invoiced''',
');                                ',
'',
'-- notify Treasury users',
'for treasury in (select user_name',
'                 from APEX_APPL_ACL_USERS',
'                 where application_id = 123',
'                 and role_names like ''Treasury''',
'                          ) loop',
'                  INSERT INTO all_notifications (',
'                                                user_name,',
'                                                notification_type,',
'                                                request_id,',
'                                                action_type,',
'                                                acknowledge',
'                                            ) VALUES (',
'                                                        treasury.user_name,',
'                                                        ''Petty Cash Invoiced'',',
'                                                        :P24_PETTY_CASH_ID,',
'                                                        ''FYI'',',
'                                                        ''N''                                                   );',
'                             end loop;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'(:P24_PAID_YN = ''N'' and :P24_INVOICING_YN = ''Y'')'
,p_process_when_type=>'PLSQL_EXPRESSION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(30355008652996020)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Send  Paid Notification'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'INSERT INTO all_notifications (',
'                                user_name,',
'                                notification_type,',
'                                request_id,',
'                                action_type,',
'                                acknowledge',
'                    ) VALUES (',
'                                :P24_EMPLOYEE_NUM,',
'                                ''Petty Cash Paid'',',
'                                :P24_PETTY_CASH_ID,',
'                                ''FYI'',',
'                                ''N'');',
'                        ',
'INSERT INTO petty_cash_all_actions (',
'    request_type,',
'    request_id,',
'    action_type',
') VALUES (',
'    ''PETTY CASH REQUEST'',',
'    :P24_PETTY_CASH_ID,',
'    ''Petty Cash Paid''',
');                                '))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P24_PAID_YN'
,p_process_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_process_when2=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(30313267614437360)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(30312404987437360)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(30286306968437350)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Petty Cash Invoice Details'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
