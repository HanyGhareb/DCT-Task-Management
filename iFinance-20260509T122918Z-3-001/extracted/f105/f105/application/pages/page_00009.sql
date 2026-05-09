prompt --application/pages/page_00009
begin
--   Manifest
--     PAGE: 00009
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
 p_id=>9
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'BTF End User Line'
,p_alias=>'BTF-END-USER-LINE'
,p_step_title=>'BTF End User Line'
,p_autocomplete_on_off=>'OFF'
,p_css_file_urls=>'#WORKSPACE_IMAGES#main.css'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230424053111'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(291726310940410)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99766883142410755)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(99703488427410717)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(99820961719410781)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(449312921133389)
,p_plug_name=>'Line &P9_FROM_TO. Details'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(105998325706455699)
,p_plug_name=>'Notes'
,p_parent_plug_id=>wwv_flow_api.id(449312921133389)
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--info:t-Alert--removeHeading'
,p_plug_template=>wwv_flow_api.id(99726350799410732)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p><span style="color: #ff0000;"><span style="color: #0000ff;"><strong>Note:</strong> if you don''t see your project/task, Kindly contact your <span style="text-decoration: underline;"><strong>Finance Business Partner</strong></span> or you can reques'
||'t access from <span style="text-decoration: underline;"><strong>Home Page --&gt; Request Project access</strong></span>.</span></span></p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(292333496940411)
,p_plug_name=>'Details'
,p_parent_plug_id=>wwv_flow_api.id(449312921133389)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_grid_column_span=>7
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(288912967931115)
,p_plug_name=>'Audit Info'
,p_parent_plug_id=>wwv_flow_api.id(292333496940411)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P9_LINE_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(449250368133388)
,p_plug_name=>'Notes'
,p_parent_plug_id=>wwv_flow_api.id(449312921133389)
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--warning:t-Alert--removeHeading'
,p_plug_template=>wwv_flow_api.id(99726350799410732)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p><span style="color: #ff0000;"><strong>Note:</strong> you can select from tasks having fund available only.</span></p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P9_FROM_TO'
,p_plug_display_when_cond2=>'FROM'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(449433470133390)
,p_plug_name=>'Balances'
,p_parent_plug_id=>wwv_flow_api.id(449312921133389)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent1:t-Region--stacked:t-Region--hiddenOverflow:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>40
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(288996423931116)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(291726310940410)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:&P9_PAGE_FROM.:&SESSION.::&DEBUG.:9:P8_REQUEST_ID:&P9_REQUEST_ID.'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(289875776931125)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(291726310940410)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Save'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P9_LINE_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_icon_css_classes=>'fa-save'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(290004810931126)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(291726310940410)
,p_button_name=>'UPDATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Update'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P9_LINE_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-save-as'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(852569390863122)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(291726310940410)
,p_button_name=>'Delete'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P9_LINE_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-trash-o'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(290355968931129)
,p_branch_name=>'GoTo  &P9_PAGE_FROM.'
,p_branch_action=>'f?p=&APP_ID.:&P9_PAGE_FROM.:&SESSION.::&DEBUG.:&P9_PAGE_FROM.:P8_REQUEST_ID:&P9_REQUEST_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(97676571217767310)
,p_name=>'P9_IN_PROCESS'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(449433470133390)
,p_prompt=>'In Process'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(97676451389767309)
,p_name=>'P9_IN_PROCESS_H'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(449433470133390)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(90872425826956625)
,p_name=>'P9_SHOW_END_USER_YN'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(292333496940411)
,p_item_default=>'Y'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(286312745931089)
,p_name=>'P9_PAGE_FROM'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(291726310940410)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(286400504931090)
,p_name=>'P9_REQUEST_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(291726310940410)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(286525280931091)
,p_name=>'P9_REQUEST_STATUS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(291726310940410)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(286666049931092)
,p_name=>'P9_REQUEST_TYPE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(291726310940410)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(286742002931093)
,p_name=>'P9_FROM_TO'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(291726310940410)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(286849817931094)
,p_name=>'P9_PROJECT_NUMBER'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(292333496940411)
,p_prompt=>'Project'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'END USER APPROVED PROJECTS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
' select ENTITY_NAME ||',
'        '' - ''       ||',
'        (Select project_name',
'        from project',
'        where project.project_number = ENTITY_NAME) as project,',
'        ENTITY_NAME r',
' from BTF_DATA_ACCESS_REQUESTS',
' where REQUEST_STATUS in (''Auto-Approved'' , ''Approved'' )',
' and ENTITY_TYPE = ''PROJECT''',
' and person_id = :PERSON_ID;'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(286885331931095)
,p_name=>'P9_TASK_NUMBER'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(292333496940411)
,p_prompt=>'Task'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct t.TASK_NUMBER d, TASK_NUMBER r',
'from project_balances t',
'where PROJECT_NUMBER = :P9_PROJECT_NUMBER',
'and t.accounting_year = :CURRENT_YEAR',
'and (CASE WHEN :P9_FROM_TO = ''FROM'' THEN FUND_AVAILABLE ',
'END > 0 OR ',
'CASE WHEN :P9_FROM_TO = ''TO'' THEN PROJECT_NUMBER ',
'END = PROJECT_NUMBER)',
'order by 1'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P9_PROJECT_NUMBER'
,p_ajax_items_to_submit=>'P9_PROJECT_NUMBER,P9_FROM_TO'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(287062911931096)
,p_name=>'P9_EXPENDITURE_TYPE'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(292333496940411)
,p_prompt=>'Expenditure Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct EXPENDITURE_TYPE d, EXPENDITURE_TYPE',
'from project_balances',
'where project_number = :P9_PROJECT_NUMBER',
'and task_number = :P9_TASK_NUMBER',
'and accounting_year = :CURRENT_YEAR',
'and (CASE WHEN :P9_FROM_TO = ''FROM'' THEN FUND_AVAILABLE END > 0',
'    OR ',
'CASE WHEN :P9_FROM_TO = ''TO'' THEN PROJECT_NUMBER ',
'END = PROJECT_NUMBER);'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P9_PROJECT_NUMBER,P9_TASK_NUMBER'
,p_ajax_items_to_submit=>'P9_FROM_TO'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(287106967931097)
,p_name=>'P9_JUSTIFICATION'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(292333496940411)
,p_prompt=>'Justification'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>2
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(287252211931098)
,p_name=>'P9_COST_CENTER'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(292333496940411)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(287295159931099)
,p_name=>'P9_GL_ACCOUNT'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(292333496940411)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(287423553931100)
,p_name=>'P9_BUDGET_GROUP_CODE'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(292333496940411)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(287540961931101)
,p_name=>'P9_ACTIVITY'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(292333496940411)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(287605061931102)
,p_name=>'P9_FUTURE1'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(292333496940411)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(287737358931103)
,p_name=>'P9_FUTURE2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(292333496940411)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(287800206931104)
,p_name=>'P9_BUDGET'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(449433470133390)
,p_prompt=>'Budget'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(287897049931105)
,p_name=>'P9_ENCUMBRANCES'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(449433470133390)
,p_prompt=>'Encumberance'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(288049105931106)
,p_name=>'P9_ACTUAL'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(449433470133390)
,p_prompt=>'Actual'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(288088938931107)
,p_name=>'P9_REQUESTED_AMOUNT'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(292333496940411)
,p_prompt=>'Requested Amount'
,p_post_element_text=>'AED'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(288204319931108)
,p_name=>'P9_FUND_AVAILABLE'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(449433470133390)
,p_prompt=>'Fund Available'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(288315118931109)
,p_name=>'P9_CREATED_BY_PERSON_ID'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(288912967931115)
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
 p_id=>wwv_flow_api.id(288438869931110)
,p_name=>'P9_UPDATED_BY_PERSON_ID'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(288912967931115)
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
 p_id=>wwv_flow_api.id(288474770931111)
,p_name=>'P9_CREATION_DATE'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(288912967931115)
,p_prompt=>'Creation Date'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(288631351931112)
,p_name=>'P9_UPDATED_DATE'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(288912967931115)
,p_prompt=>'Update Date'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(288734918931113)
,p_name=>'P9_LINE_ID'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(291726310940410)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(288835003931114)
,p_name=>'P9_LINE_NO'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(292333496940411)
,p_prompt=>'Line No'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P9_LINE_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(289113889931117)
,p_name=>'P9_BUDGET_H'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(449433470133390)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(289216164931118)
,p_name=>'P9_ENCUMBRANCES_H'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(449433470133390)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(289328967931119)
,p_name=>'P9_ACTUAL_H'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(449433470133390)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(289420695931120)
,p_name=>'P9_FUND_AVAILABLE_H'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(449433470133390)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(289566544931121)
,p_name=>'Task Changes DA'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P9_TASK_NUMBER'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(289577003931122)
,p_event_id=>wwv_flow_api.id(289566544931121)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P9_COST_CENTER,P9_BUDGET_GROUP_CODE,P9_ACTIVITY,P9_FUTURE1,P9_FUTURE2,P9_SHOW_END_USER_YN'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select COST_CENTER, BUDGET_GROUP_CODE, ACTIVITY, FUTURE1, FUTURE2, SHOW_END_USER_YN',
'from task',
'where project_number = :P9_PROJECT_NUMBER',
'and task_number = :P9_TASK_NUMBER;'))
,p_attribute_07=>'P9_PROJECT_NUMBER,P9_TASK_NUMBER'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(289713733931123)
,p_name=>'Expenditure Type Changes DA'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P9_EXPENDITURE_TYPE'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(289816149931124)
,p_event_id=>wwv_flow_api.id(289713733931123)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P9_BUDGET,P9_BUDGET_H,P9_ACTUAL,P9_ACTUAL_H,P9_ENCUMBRANCES,P9_ENCUMBRANCES_H,P9_FUND_AVAILABLE,P9_FUND_AVAILABLE_H,P9_GL_ACCOUNT,P9_IN_PROCESS_H,P9_IN_PROCESS'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(BUDGET,''99,999,999,999.99'')) budget, ',
'        BUDGET  BUDGET_H,',
'        trim(to_char(ACTUAL,''99,999,999,999.99'')) actual,',
'        ACTUAL  ACTUAL_H,',
'        trim(to_char(ENCUMBERANCE,''99,999,999,999.99'')) ENCUMBERANCE, ',
'        ENCUMBERANCE    ENCUMBERANCE_H,',
'--        trim(to_char(FUND_AVAILABLE,''99,999,999,999.99'')) FUND_AVAILABLE, ',
'        ',
'        trim(to_char(case :P9_FROM_TO when ''FROM'' ',
'                                    Then ',
'                                        FUND_AVAILABLE - BTF_EU_UTIL.get_pending_balance(:P9_FROM_TO , :P9_PROJECT_NUMBER , :P9_TASK_NUMBER	, :P9_EXPENDITURE_TYPE	, SUBSTR(expenditure_type,1,6) )',
'                         when ''TO''  Then',
'                                        FUND_AVAILABLE + BTF_EU_UTIL.get_pending_balance(:P9_FROM_TO , :P9_PROJECT_NUMBER , :P9_TASK_NUMBER	, :P9_EXPENDITURE_TYPE	, SUBSTR(expenditure_type,1,6) )',
'           end, ''99,999,999,999.99''))                         FUND_AVAILABLE,',
'        ',
'        ',
'        ',
'        case :P9_FROM_TO when ''FROM'' ',
'                                    Then ',
'                                        FUND_AVAILABLE - BTF_EU_UTIL.get_pending_balance(:P9_FROM_TO , :P9_PROJECT_NUMBER , :P9_TASK_NUMBER	, :P9_EXPENDITURE_TYPE	, SUBSTR(expenditure_type,1,6) )',
'                         when ''TO''  Then',
'                                        FUND_AVAILABLE + BTF_EU_UTIL.get_pending_balance(:P9_FROM_TO , :P9_PROJECT_NUMBER , :P9_TASK_NUMBER	, :P9_EXPENDITURE_TYPE	, SUBSTR(expenditure_type,1,6) )',
'           end                         FUND_AVAILABLE_H,',
'        SUBSTR(expenditure_type,1,6) gl,',
'        BTF_EU_UTIL.get_pending_balance(:P9_FROM_TO , :P9_PROJECT_NUMBER , :P9_TASK_NUMBER	, :P9_EXPENDITURE_TYPE	, SUBSTR(expenditure_type,1,6) ) in_process_h,',
'        trim(to_char(BTF_EU_UTIL.get_pending_balance(:P9_FROM_TO , :P9_PROJECT_NUMBER , :P9_TASK_NUMBER	, :P9_EXPENDITURE_TYPE	, SUBSTR(expenditure_type,1,6) ), ''99,999,999,999.99'')) in_process',
'from project_balances',
'where project_number = :P9_PROJECT_NUMBER',
'and task_number = :P9_TASK_NUMBER',
'and Expenditure_type = :P9_EXPENDITURE_TYPE',
'and accounting_year = :CURRENT_YEAR',
'and rownum =1;'))
,p_attribute_07=>'P9_PROJECT_NUMBER,P9_TASK_NUMBER,P9_EXPENDITURE_TYPE'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(449518487133391)
,p_name=>'Check Requested amount for deduction DA'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P9_REQUESTED_AMOUNT'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'(Number(apex.item(''P9_REQUESTED_AMOUNT'').getValue()) > Number(apex.item(''P9_FUND_AVAILABLE_H'').getValue())) && (apex.item(''P9_FROM_TO'').getValue() == ''FROM'')'
,p_bind_type=>'bind'
,p_bind_event_type=>'focusout'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(449572764133392)
,p_event_id=>wwv_flow_api.id(449518487133391)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'you have exceeded the fund available.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(449699213133393)
,p_event_id=>wwv_flow_api.id(449518487133391)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P9_REQUESTED_AMOUNT'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(852694439863124)
,p_name=>'Delete DA'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(852569390863122)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(852836258863125)
,p_event_id=>wwv_flow_api.id(852694439863124)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure to delete this line?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(852945743863126)
,p_event_id=>wwv_flow_api.id(852694439863124)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'delete from btf_end_users_lines ',
'where LINE_ID = :P9_LINE_ID;'))
,p_attribute_02=>'P9_LINE_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(852985638863127)
,p_event_id=>wwv_flow_api.id(852694439863124)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Deleted'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(853096357863128)
,p_event_id=>wwv_flow_api.id(852694439863124)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(90872290692956624)
,p_name=>'SHOW_END_USER_YN DA'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P9_SHOW_END_USER_YN'
,p_condition_element=>'P9_SHOW_END_USER_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'live'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(90872142425956623)
,p_event_id=>wwv_flow_api.id(90872290692956624)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(449433470133390)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(90872063195956622)
,p_event_id=>wwv_flow_api.id(90872290692956624)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(449433470133390)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(349442411380094)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialize '
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    line_id,',
'    request_id,',
'    line_no,',
'    justification,',
'    project_number,',
'    task_number,',
'    expenditure_type,',
'    cost_center,',
'    gl_account,',
'    budget_group_code,',
'    activity,',
'    future1,',
'    future2,',
'    budget,',
'    encumbrances,',
'    actual,',
'    fund_available,',
'    requested_amount,',
'    FROM_TO,',
'    CREATED_BY_PERSON_ID,',
'    UPDATED_BY_PERSON_ID,',
'    to_char(CREATION_DATE,''DD-MON-YYYY HH:MIPM'')    CREATION_DATE,',
'    to_char(UPDATED_DATE,''DD-MON-YYYY HH:MIPM'') UPDATED_DATE',
'INTO ',
'    :P9_LINE_ID,',
'    :P9_REQUEST_ID,',
'    :P9_LINE_NO,',
'    :P9_JUSTIFICATION,',
'    :P9_PROJECT_NUMBER,',
'    :P9_TASK_NUMBER,',
'    :P9_EXPENDITURE_TYPE,',
'    :P9_COST_CENTER,',
'    :P9_GL_ACCOUNT,',
'    :P9_BUDGET_GROUP_CODE,',
'    :P9_ACTIVITY,',
'    :P9_FUTURE1,',
'    :P9_FUTURE2,',
'    :P9_BUDGET_H,',
'    :P9_ENCUMBRANCES_H,',
'    :P9_ACTUAL_H,',
'    :P9_FUND_AVAILABLE_H,',
'    :P9_REQUESTED_AMOUNT,',
'    :P9_FROM_TO,',
'    :P9_CREATED_BY_PERSON_ID,',
'    :P9_UPDATED_BY_PERSON_ID,',
'    :P9_CREATION_DATE,',
'    :P9_UPDATED_DATE',
'FROM',
'    btf_end_users_lines',
'where line_id = :P9_LINE_ID    ;',
' exception',
'    when others then null;  '))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P9_LINE_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(290089549931127)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Insert Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'l_line_count    Number;',
'',
'Begin',
'SELECT BTF_END_USERS_LINES_SEQ.nextval',
'into :P9_LINE_ID',
'FROM all_sequences',
' WHERE sequence_owner = ''PROD''',
'   AND sequence_name = ''BTF_END_USERS_LINES_SEQ'';',
'',
'Select nvl(count(*),0) + 1',
'into l_line_count',
'from btf_end_users_lines',
'where request_id = :P9_REQUEST_ID',
'and FROM_TO = :P9_FROM_TO;',
'   ',
'INSERT INTO btf_end_users_lines (',
'    line_id,',
'    request_id,',
'    line_no,',
'    justification,',
'    from_to,',
'    project_number,',
'    task_number,',
'    expenditure_type,',
'    cost_center,',
'    gl_account,',
'    budget_group_code,',
'    activity,',
'    future1,',
'    future2,',
'    budget,',
'    encumbrances,',
'    actual,',
'    fund_available,',
'    requested_amount',
') VALUES (',
'    nvl(:P9_LINE_ID,1),',
'    :P9_REQUEST_ID,',
'    to_number(l_line_count),',
'    :P9_JUSTIFICATION,',
'    :P9_FROM_TO,',
'    :P9_PROJECT_NUMBER,',
'    :P9_TASK_NUMBER,',
'    :P9_EXPENDITURE_TYPE,',
'    :P9_COST_CENTER,',
'    :P9_GL_ACCOUNT,',
'    :P9_BUDGET_GROUP_CODE,',
'    :P9_ACTIVITY,',
'    :P9_FUTURE1,',
'    :P9_FUTURE2,',
'    :P9_BUDGET_H,',
'    :P9_ENCUMBRANCES_H,',
'    :P9_ACTUAL_H,',
'    :P9_FUND_AVAILABLE_H,',
'    to_number(:P9_REQUESTED_AMOUNT)',
');',
'',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(289875776931125)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(290199255931128)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Update btf_end_users_lines ',
'Set justification  = :P9_JUSTIFICATION,',
'    project_number = :P9_PROJECT_NUMBER,',
'    task_number = :P9_TASK_NUMBER,',
'    expenditure_type = :P9_EXPENDITURE_TYPE,',
'    cost_center = :P9_COST_CENTER,',
'    gl_account =  :P9_GL_ACCOUNT,',
'    budget_group_code = :P9_BUDGET_GROUP_CODE,',
'    activity = :P9_ACTIVITY,',
'    future1 = :P9_FUTURE1,',
'    future2 = :P9_FUTURE2,',
'    budget = :P9_BUDGET_H,',
'    encumbrances = :P9_ENCUMBRANCES_H,',
'    actual = :P9_ACTUAL_H,',
'    fund_available = :P9_FUND_AVAILABLE_H,',
'    requested_amount = :P9_REQUESTED_AMOUNT',
'where LINE_ID = :P9_LINE_ID;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(290004810931126)
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(853212457863129)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update Strategic YN '
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count    Number;',
'begin',
'',
'select nvl(count(*) , 0)',
'into l_count',
'from btf_end_users_lines l',
'where l.request_id = :P9_REQUEST_ID ',
'and (l.project_number , l.task_number) in (select ti.PROJECT_NUMBER, ti.TASK_NUMBER',
'                                           from task_initiatives ti',
'                                           where ti.initiative_id in (select si.INITIATIVE_ID',
'                                                                        from strategic_initiatives si',
'                                                                        where si.INITIATIVE_TYPE = ''S''',
'                                                                        and si.status = ''A''',
'                                                                        and sysdate between nvl(start_date, sysdate - 10)',
'                                                                                    and nvl(end_date , sysdate + 10)));',
'if  l_count > 0 ',
'then ',
'    update btf_end_users_header set STRATEGIC_YN = ''Y'' where request_id = :P9_REQUEST_ID;',
'else',
'    update btf_end_users_header set STRATEGIC_YN = ''N'' where request_id = :P9_REQUEST_ID;',
'    ',
'End If;',
'',
'End ;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
null;
wwv_flow_api.component_end;
end;
/
