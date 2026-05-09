prompt --application/pages/page_00029
begin
--   Manifest
--     PAGE: 00029
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>227103249168277234
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>29
,p_user_interface_id=>wwv_flow_api.id(12983317716762193)
,p_name=>'Employee Vendor Number'
,p_alias=>'EMPLOYEE-VENDOR-NUMBER'
,p_page_mode=>'MODAL'
,p_step_title=>'Employee Vendor Number'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'document.getElementById("P29_VENDOR_NUMBER").readOnly = true;',
'document.getElementById("P29_VENDOR_SITE_CODE").readOnly = true;',
'document.getElementById("P29_BANK_ACCOUNT_NAME").readOnly = true;',
'document.getElementById("P29_BANK_NAME").readOnly = true;',
'document.getElementById("P29_BANK_ACCOUNT").readOnly = true;',
'document.getElementById("P29_VENDOR_NAME").readOnly = true;'))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220715043805'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(2841715076672744)
,p_plug_name=>'Employee Vendor Number'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12871326925762093)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'PAYROLL_VENDORS_MAPPING'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(2853231376672730)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12872392429762094)
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_03'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(2866808543672718)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12908155528762118)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(12844716791762062)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(12962203224762162)
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(2853718795672730)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(2853231376672730)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12960857103762161)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(2855273459672727)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(2853231376672730)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12960857103762161)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition=>'P29_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(2855704174672727)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(2853231376672730)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12960857103762161)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P29_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(2856119864672727)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(2853231376672730)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12960857103762161)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P29_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1854119052296369)
,p_name=>'P29_VENDOR_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(2841715076672744)
,p_item_source_plug_id=>wwv_flow_api.id(2841715076672744)
,p_prompt=>'Vendor Name'
,p_source=>'VENDOR_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(12959735177762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2841938030672743)
,p_name=>'P29_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(2841715076672744)
,p_item_source_plug_id=>wwv_flow_api.id(2841715076672744)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Id'
,p_source=>'ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_label_alignment=>'RIGHT'
,p_field_template=>wwv_flow_api.id(12959735177762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2842401642672739)
,p_name=>'P29_PAYROLL_AREA'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(2841715076672744)
,p_item_source_plug_id=>wwv_flow_api.id(2841715076672744)
,p_prompt=>'Payroll Area'
,p_source=>'PAYROLL_AREA'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT DISTINCT',
'    payroll_area  d,',
'    payroll_area  r',
'FROM',
'    sf_employees',
'Where  payroll_area not in (''DCT Payroll'',''LAD direct Hires'',''Non-Payroll'')',
'ORDER BY',
'    1'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12959735177762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2842815484672739)
,p_name=>'P29_VENDOR_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(2841715076672744)
,p_item_source_plug_id=>wwv_flow_api.id(2841715076672744)
,p_prompt=>'Vendor'
,p_source=>'VENDOR_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>50
,p_field_template=>wwv_flow_api.id(12960060122762160)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2843140157672739)
,p_name=>'P29_VENDOR_SITE_CODE'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(2841715076672744)
,p_item_source_plug_id=>wwv_flow_api.id(2841715076672744)
,p_prompt=>'Vendor Site Code'
,p_source=>'VENDOR_SITE_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>50
,p_field_template=>wwv_flow_api.id(12960060122762160)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2843553207672738)
,p_name=>'P29_BANK_ACCOUNT_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(2841715076672744)
,p_item_source_plug_id=>wwv_flow_api.id(2841715076672744)
,p_prompt=>'Bank Account Name'
,p_source=>'BANK_ACCOUNT_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(12959735177762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2843968710672738)
,p_name=>'P29_BANK_NAME'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(2841715076672744)
,p_item_source_plug_id=>wwv_flow_api.id(2841715076672744)
,p_prompt=>'Bank Name'
,p_source=>'BANK_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(12960060122762160)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2844340605672738)
,p_name=>'P29_BANK_ACCOUNT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(2841715076672744)
,p_item_source_plug_id=>wwv_flow_api.id(2841715076672744)
,p_prompt=>'Bank Account'
,p_source=>'BANK_ACCOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(12959735177762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2844753886672738)
,p_name=>'P29_IBAN'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(2841715076672744)
,p_item_source_plug_id=>wwv_flow_api.id(2841715076672744)
,p_prompt=>'IBAN'
,p_source=>'IBAN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'VENDORS WITH BANK ACCOUNTS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select v.VENDOR_NAME, ',
'       vba.VENDOR_SITE_CODE, ',
'       vba.VENDOR_NUMBER, ',
'       vba.BANK_ACCOUNT_NAME, ',
'       vba.BANK_NAME, ',
'       vba.BANK_ACCOUNT, ',
'       IBAN',
'from vendors  v, vendors_bank_accounts vba',
'where v.vendor_site_status = ''Active''',
'and v.vendor_number = vba.vendor_number',
'and v.vendor_site_code = vba.vendor_site_code',
'and vba.ACC_END_DATED is null; '))
,p_lov_display_null=>'YES'
,p_cSize=>32
,p_cMaxlength=>50
,p_field_template=>wwv_flow_api.id(12959735177762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_10=>'VENDOR_NUMBER:P29_VENDOR_NUMBER,VENDOR_SITE_CODE:P29_VENDOR_SITE_CODE,BANK_ACCOUNT_NAME:P29_BANK_ACCOUNT_NAME,BANK_NAME:P29_BANK_NAME,BANK_ACCOUNT:P29_BANK_ACCOUNT,VENDOR_NAME:P29_VENDOR_NAME'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2845194139672738)
,p_name=>'P29_START_DATE'
,p_source_data_type=>'DATE'
,p_is_required=>true
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(2841715076672744)
,p_item_source_plug_id=>wwv_flow_api.id(2841715076672744)
,p_prompt=>'Start Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'START_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>10
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(12959735177762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'N'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2845607988672738)
,p_name=>'P29_END_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(2841715076672744)
,p_item_source_plug_id=>wwv_flow_api.id(2841715076672744)
,p_prompt=>'End Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'END_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>10
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(12959735177762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'N'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2845956883672737)
,p_name=>'P29_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(2841715076672744)
,p_item_source_plug_id=>wwv_flow_api.id(2841715076672744)
,p_item_default=>'A'
,p_prompt=>'Status'
,p_source=>'STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'STATUS LOV'
,p_lov=>'.'||wwv_flow_api.id(109817458020935965)||'.'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12959735177762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2846323916672737)
,p_name=>'P29_CREATED_BY_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(2841715076672744)
,p_item_source_plug_id=>wwv_flow_api.id(2841715076672744)
,p_prompt=>'Created By'
,p_source=>'CREATED_BY_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name , user_details.get_emp_emirate(person_id) Emirate',
'FROM employees_v e',
'where CURRENT_FLAG = ''Y'''))
,p_display_when=>'P29_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2846758088672737)
,p_name=>'P29_UPDATED_BY_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(2841715076672744)
,p_item_source_plug_id=>wwv_flow_api.id(2841715076672744)
,p_prompt=>'Updated By'
,p_source=>'UPDATED_BY_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name , user_details.get_emp_emirate(person_id) Emirate',
'FROM employees_v e',
'where CURRENT_FLAG = ''Y'''))
,p_display_when=>'P29_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2847207967672737)
,p_name=>'P29_CREATION_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(2841715076672744)
,p_item_source_plug_id=>wwv_flow_api.id(2841715076672744)
,p_prompt=>'Creation Date'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CREATION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>'P29_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2847979471672733)
,p_name=>'P29_UPDATED_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(2841715076672744)
,p_item_source_plug_id=>wwv_flow_api.id(2841715076672744)
,p_prompt=>'Updated Date'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'UPDATED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>'P29_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(2847672914672736)
,p_validation_name=>'P29_CREATION_DATE must be timestamp'
,p_validation_sequence=>130
,p_validation=>'P29_CREATION_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(2847207967672737)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(2848461504672733)
,p_validation_name=>'P29_UPDATED_DATE must be timestamp'
,p_validation_sequence=>140
,p_validation=>'P29_UPDATED_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(2847979471672733)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(2853724213672730)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(2853718795672730)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(2854559594672729)
,p_event_id=>wwv_flow_api.id(2853724213672730)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(2856866123672727)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(2841715076672744)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Employee Vendor Number'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(2857296862672726)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(2856464721672727)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(2841715076672744)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Employee Vendor Number'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
