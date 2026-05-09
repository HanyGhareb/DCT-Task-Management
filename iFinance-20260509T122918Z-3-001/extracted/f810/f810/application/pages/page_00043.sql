prompt --application/pages/page_00043
begin
--   Manifest
--     PAGE: 00043
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>43
,p_user_interface_id=>wwv_flow_api.id(12983317716762193)
,p_name=>'Employee Details'
,p_alias=>'EMPLOYEE-DETAILS'
,p_step_title=>'Employee Details'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240219135927'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(79027318412799407)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12908155528762118)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(12844716791762062)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(12962203224762162)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(79027864816799553)
,p_plug_name=>'Employee Details'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'DCT_EMPLOYEES_LIST2'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(78651833070820743)
,p_plug_name=>'System'
,p_parent_plug_id=>wwv_flow_api.id(79027864816799553)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(78651938490820744)
,p_plug_name=>'User'
,p_parent_plug_id=>wwv_flow_api.id(79027864816799553)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(79092751721799596)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(79027864816799553)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12960857103762161)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_button_condition=>'P43_PERSON_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(79091578614799593)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(79027864816799553)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12960857103762161)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(79093130179799596)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(79027864816799553)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12960857103762161)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_button_condition=>'P43_PERSON_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(79092376141799596)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(79027864816799553)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12960857103762161)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition_type=>'NEVER'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(79093453197799596)
,p_branch_action=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(79028216539799554)
,p_name=>'P43_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(79027864816799553)
,p_item_source_plug_id=>wwv_flow_api.id(79027864816799553)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Person Id'
,p_source=>'PERSON_ID'
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
 p_id=>wwv_flow_api.id(79028854044799559)
,p_name=>'P43_EMPLOYEE_NUM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(78651833070820743)
,p_item_source_plug_id=>wwv_flow_api.id(79027864816799553)
,p_prompt=>'Employee Num'
,p_source=>'EMPLOYEE_NUM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(79032874818799561)
,p_name=>'P43_FULL_NAME_EN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(78651833070820743)
,p_item_source_plug_id=>wwv_flow_api.id(79027864816799553)
,p_prompt=>'Name'
,p_source=>'FULL_NAME_EN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(79034502700799561)
,p_name=>'P43_SUPERVISOR_NUM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(78651833070820743)
,p_item_source_plug_id=>wwv_flow_api.id(79027864816799553)
,p_prompt=>'Supervisor Num'
,p_source=>'SUPERVISOR_NUM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(79036108868799562)
,p_name=>'P43_GRADE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(78651833070820743)
,p_item_source_plug_id=>wwv_flow_api.id(79027864816799553)
,p_prompt=>'Grade'
,p_source=>'GRADE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'GRADS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DESC_E , CODE',
'from dct_employees_lookups',
'where lookup_name = ''Grades Codes'';'))
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(79039226676799564)
,p_name=>'P43_EMAIL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(78651833070820743)
,p_item_source_plug_id=>wwv_flow_api.id(79027864816799553)
,p_prompt=>'Email'
,p_source=>'EMAIL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(79040116094799564)
,p_name=>'P43_LOCATION_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_api.id(78651833070820743)
,p_item_source_plug_id=>wwv_flow_api.id(79027864816799553)
,p_prompt=>'Location'
,p_source=>'LOCATION_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'LOCATION LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DESC_E , CODE',
'from dct_employees_lookups',
'where LOOKUP_NUMBER = 15'))
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(79042042428799565)
,p_name=>'P43_ASSIGNMENT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>360
,p_item_plug_id=>wwv_flow_api.id(78651833070820743)
,p_item_source_plug_id=>wwv_flow_api.id(79027864816799553)
,p_prompt=>'Assignment Number'
,p_source=>'ASSIGNMENT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(79044036569799566)
,p_name=>'P43_USER_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>410
,p_item_plug_id=>wwv_flow_api.id(78651833070820743)
,p_item_source_plug_id=>wwv_flow_api.id(79027864816799553)
,p_prompt=>'User Name'
,p_source=>'USER_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(79050501057799574)
,p_name=>'P43_SUPERVISOR_NUM_USER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>550
,p_item_plug_id=>wwv_flow_api.id(78651938490820744)
,p_item_source_plug_id=>wwv_flow_api.id(79027864816799553)
,p_prompt=>'Supervisor Num User'
,p_source=>'SUPERVISOR_NUM_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN EMPNO- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.email,e.employee_num ',
'FROM employees_v e',
'where CURRENT_FLAG = ''Y'''))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_cMaxlength=>20
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(79050831334799574)
,p_name=>'P43_EMAIL_USER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>570
,p_item_plug_id=>wwv_flow_api.id(78651938490820744)
,p_item_source_plug_id=>wwv_flow_api.id(79027864816799553)
,p_prompt=>'Email User'
,p_source=>'EMAIL_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>128
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'EMAIL'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(79052907226799575)
,p_name=>'P43_COST_CENTER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>610
,p_item_plug_id=>wwv_flow_api.id(78651833070820743)
,p_item_source_plug_id=>wwv_flow_api.id(79027864816799553)
,p_prompt=>'Cost Center'
,p_source=>'COST_CENTER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(79053318684799575)
,p_name=>'P43_COST_CENTER_USER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>580
,p_item_plug_id=>wwv_flow_api.id(78651938490820744)
,p_item_source_plug_id=>wwv_flow_api.id(79027864816799553)
,p_prompt=>'Cost Center User'
,p_source=>'COST_CENTER_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'COST CENTERS WITH NAMES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''('' || COST_CENTER_CODE || '') '' || COST_CENTER_DESCRIPTION Name, COST_CENTER_CODE',
'from(',
'select distinct  COST_CENTER_DESCRIPTION, COST_CENTER_CODE',
'from dct_gl_code_combinations_all',
'order by COST_CENTER_CODE)'))
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(79055226284799576)
,p_name=>'P43_DIRECTOR_PERSON_ID_USER'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>590
,p_item_plug_id=>wwv_flow_api.id(78651938490820744)
,p_item_source_plug_id=>wwv_flow_api.id(79027864816799553)
,p_prompt=>'Director (User)'
,p_source=>'DIRECTOR_PERSON_ID_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMPLOYEES ALL LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select full_name_en  , ',
'        person_id ',
'from employees_v;'))
,p_lov_display_null=>'YES'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(79055648002799576)
,p_name=>'P43_EXECUTIVE_DIR_PERSON_ID_USER'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>600
,p_item_plug_id=>wwv_flow_api.id(78651938490820744)
,p_item_source_plug_id=>wwv_flow_api.id(79027864816799553)
,p_prompt=>'Executive Director (User)'
,p_source=>'EXECUTIVE_DIR_PERSON_ID_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMPLOYEES ALL LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select full_name_en  , ',
'        person_id ',
'from employees_v;'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(79057682582799577)
,p_name=>'P43_LOCATION_ID_USER'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>610
,p_item_plug_id=>wwv_flow_api.id(78651938490820744)
,p_item_source_plug_id=>wwv_flow_api.id(79027864816799553)
,p_prompt=>'Location (User)'
,p_source=>'LOCATION_ID_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'LOCATION LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DESC_E , CODE',
'from dct_employees_lookups',
'where LOOKUP_NUMBER = 15'))
,p_lov_display_null=>'YES'
,p_cSize=>50
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(79064504032799581)
,p_name=>'P43_PAYROLL_AREA_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>620
,p_item_plug_id=>wwv_flow_api.id(78651938490820744)
,p_item_source_plug_id=>wwv_flow_api.id(79027864816799553)
,p_prompt=>'Payroll Area'
,p_source=>'PAYROLL_AREA_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'PAYROLL AREAS LOV2'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PAYROLL_AREA , PAYROLL_AREA_ID',
'from payroll_areas',
'where status = ''A''',
'and sysdate between nvl(start_date ,  sysdate - 10) ',
'        and nvl(end_date , sysdate + 10)'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(82671475974866456)
,p_name=>'P43_GRADE_ID_USER'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>560
,p_item_plug_id=>wwv_flow_api.id(78651938490820744)
,p_item_source_plug_id=>wwv_flow_api.id(79027864816799553)
,p_prompt=>'Grade (User)'
,p_source=>'GRADE_ID_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'GRADS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DESC_E , CODE',
'from dct_employees_lookups',
'where lookup_name = ''Grades Codes'';'))
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(79094375345799597)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(79027864816799553)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Employee Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(79093934873799597)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(79027864816799553)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Employee Details'
);
wwv_flow_api.component_end;
end;
/
