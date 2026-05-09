prompt --application/pages/page_00043
begin
--   Manifest
--     PAGE: 00043
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
 p_id=>43
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Task Details'
,p_alias=>'TASK-DETAILS'
,p_step_title=>'Task Details'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220813113716'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(95594083074377212)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99766883142410755)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(99703488427410717)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(99820961719410781)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(95591534044377187)
,p_plug_name=>'Audit'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(90887724562838394)
,p_plug_name=>'Details'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(90887305180838396)
,p_plug_name=>'Expenditures Types'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(90886859071838396)
,p_plug_name=>'Finance Details'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(90872847487956630)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(95594083074377212)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:&P43_PAGE_FROM.:&SESSION.::&DEBUG.::P21_PROJECT_NUMBER:&P43_PROJECT_NUMBER.'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(90872801520956629)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(95594083074377212)
,p_button_name=>'Update'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Update'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_icon_css_classes=>'fa-save-as'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(90872612350956627)
,p_branch_name=>'Go to &P43_PAGE_FROM.'
,p_branch_action=>'f?p=&APP_ID.:&P43_PAGE_FROM.:&SESSION.::&DEBUG.::P21_PROJECT_NUMBER:&P43_PROJECT_NUMBER.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95593991917377211)
,p_name=>'P43_PROJECT_NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(90887724562838394)
,p_prompt=>'Project Number'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95593834755377210)
,p_name=>'P43_TASK_NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(90887724562838394)
,p_prompt=>'Task Number'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95593797723377209)
,p_name=>'P43_TASK_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(90887724562838394)
,p_prompt=>'Task Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95593655776377208)
,p_name=>'P43_TASK_DESCRIPTION'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(90887724562838394)
,p_prompt=>'Task Description'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95593625548377207)
,p_name=>'P43_TASK_START_DATE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(90887724562838394)
,p_prompt=>'Start Date'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95593524487377206)
,p_name=>'P43_TASK_END_DATE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(90887724562838394)
,p_prompt=>'End Date'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95593388830377205)
,p_name=>'P43_COST_CENTER'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(90887724562838394)
,p_prompt=>'Cost Center'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95593241929377204)
,p_name=>'P43_BUDGET_GROUP_CODE'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(90887724562838394)
,p_prompt=>'Budget Group Code'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95593211383377203)
,p_name=>'P43_ACTIVITY'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(90887724562838394)
,p_item_default=>'000000'
,p_prompt=>'Activity'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95593068712377202)
,p_name=>'P43_FUTURE1'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(90887724562838394)
,p_item_default=>'451000'
,p_prompt=>'Future1'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95592992448377201)
,p_name=>'P43_FUTURE2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(90887724562838394)
,p_prompt=>'Future2'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95592927514377200)
,p_name=>'P43_DCT_SECTOR_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(90886859071838396)
,p_prompt=>'Sector'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95592754659377199)
,p_name=>'P43_DCT_DEPARTMENT_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(90886859071838396)
,p_prompt=>'Department'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95592717949377198)
,p_name=>'P43_DCT_SECTION_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(90886859071838396)
,p_prompt=>'Section'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95592551111377197)
,p_name=>'P43_DCT_UNIT_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(90886859071838396)
,p_prompt=>'Unit'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95592435042377196)
,p_name=>'P43_DCT_TASK_NAME'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(90886859071838396)
,p_prompt=>'DCT Task Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95592362764377195)
,p_name=>'P43_DCT_SERVICE_PROVIDER'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(90886859071838396)
,p_prompt=>'Service Provider ?'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(782922329120916)||'.'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95592306783377194)
,p_name=>'P43_DCT_MPR_ALLOWED'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(90886859071838396)
,p_prompt=>'Allow MPR ?'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(782922329120916)||'.'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95592185382377193)
,p_name=>'P43_DCT_MPO_ALLOWED'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(90886859071838396)
,p_prompt=>'Allow MPO ?'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(782922329120916)||'.'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95592077537377192)
,p_name=>'P43_DCT_STATUS'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(90886859071838396)
,p_prompt=>'DCT Status'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'STATUS LOV'
,p_lov=>'.'||wwv_flow_api.id(780300318120911)||'.'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95592026950377191)
,p_name=>'P43_DCT_TASK_RATE'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(90886859071838396)
,p_prompt=>'DCT Task Rate'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95591880405377190)
,p_name=>'P43_DIRECTOR_PERSON_ID'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(90886859071838396)
,p_prompt=>'Director'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95591766855377189)
,p_name=>'P43_ED_PERSON_ID'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(90886859071838396)
,p_prompt=>'Executive Director'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95591688978377188)
,p_name=>'P43_SHOW_END_USER_YN'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(90886859071838396)
,p_prompt=>'Display on BTF ?'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(782922329120916)||'.'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95591506247377186)
,p_name=>'P43_CREATED_BY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(95591534044377187)
,p_prompt=>'Created By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95591358925377185)
,p_name=>'P43_UPDATED_BY'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(95591534044377187)
,p_prompt=>'Updated By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95591326324377184)
,p_name=>'P43_CREATED_ON'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(95591534044377187)
,p_prompt=>'Created ON'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95591228708377183)
,p_name=>'P43_UPDATED_ON'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(95591534044377187)
,p_prompt=>'Updated On'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(90872936790956631)
,p_name=>'P43_PAGE_FROM'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(95594083074377212)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(95591089775377182)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'fetch process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    project_number,',
'    task_number,',
'    task_name,',
'    task_description,',
'    task_start_date,',
'    task_end_date,',
'    cost_center,',
'    budget_group_code,',
'    activity,',
'    future1,',
'    future2,',
'    dct_sector_id,',
'    dct_department_id,',
'    dct_section_id,',
'    dct_unit_id,',
'    dct_task_name,',
'    dct_service_provider,',
'    dct_mpr_allowed,',
'    dct_mpo_allowed,',
'    dct_status,',
'    dct_task_rate,',
'    created_by,',
'    created_on,',
'    updated_by,',
'    updated_on,',
'    director_person_id,',
'    ed_person_id,',
'    show_end_user_yn',
'into ',
'    :P43_project_number,',
'    :P43_task_number,',
'    :P43_task_name,',
'    :P43_task_description,',
'    :P43_task_start_date,',
'    :P43_task_end_date,',
'    :P43_cost_center,',
'    :P43_budget_group_code,',
'    :P43_activity,',
'    :P43_future1,',
'    :P43_future2,',
'    :P43_dct_sector_id,',
'    :P43_dct_department_id,',
'    :P43_dct_section_id,',
'    :P43_dct_unit_id,',
'    :P43_dct_task_name,',
'    :P43_dct_service_provider,',
'    :P43_dct_mpr_allowed,',
'    :P43_dct_mpo_allowed,',
'    :P43_dct_status,',
'    :P43_dct_task_rate,',
'    :P43_created_by,',
'    :P43_created_on,',
'    :P43_updated_by,',
'    :P43_updated_on,',
'    :P43_director_person_id,',
'    :P43_ed_person_id,',
'    :P43_show_end_user_yn',
'',
'FROM task',
'where project_number = :P43_project_number',
'and task_number = :P43_task_number;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(90872666276956628)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'UPDATE task',
'SET',
'    dct_task_name = :p43_dct_task_name,',
'    dct_service_provider = :p43_dct_service_provider,',
'    dct_mpr_allowed = :p43_dct_mpr_allowed,',
'    dct_mpo_allowed = :p43_dct_mpo_allowed,',
'    dct_status = :p43_dct_status,',
'    dct_task_rate = :p43_dct_task_rate,',
'    director_person_id = :p43_director_person_id,',
'    ed_person_id = :p43_ed_person_id,',
'    show_end_user_yn = :p43_show_end_user_yn',
'WHERE',
'        project_number = :p43_project_number',
'    AND task_number = :p43_task_number;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(90872801520956629)
,p_process_success_message=>'Updates Successfully.'
);
wwv_flow_api.component_end;
end;
/
