prompt --application/pages/page_00010
begin
--   Manifest
--     PAGE: 00010
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>10
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'DP Item request'
,p_alias=>'DP-ITEM-REQUEST'
,p_step_title=>'DP Item request'
,p_autocomplete_on_off=>'OFF'
,p_css_file_urls=>'#WORKSPACE_IMAGES#main.css'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.t-Form-label {',
'    	color: #368ed2;',
'	font-weight: bold;',
'	font-size:12px;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240228222233'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(299642458662655630)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127813188296449776)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(127749711524449850)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(127867332295449731)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(128511483858293033)
,p_plug_name=>'Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(305591717016649410)
,p_plug_name=>'Budget Details'
,p_parent_plug_id=>wwv_flow_api.id(128511483858293033)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(305591577527649409)
,p_plug_name=>'Details L2'
,p_parent_plug_id=>wwv_flow_api.id(305591717016649410)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(305591539739649408)
,p_plug_name=>'Details R2'
,p_parent_plug_id=>wwv_flow_api.id(305591717016649410)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(299641241307655618)
,p_plug_name=>'Details Notes'
,p_parent_plug_id=>wwv_flow_api.id(305591717016649410)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(305591468115649407)
,p_plug_name=>'Project Details'
,p_parent_plug_id=>wwv_flow_api.id(128511483858293033)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(305591953146649412)
,p_plug_name=>'Details L1'
,p_parent_plug_id=>wwv_flow_api.id(305591468115649407)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(305591853494649411)
,p_plug_name=>'Details R1'
,p_parent_plug_id=>wwv_flow_api.id(305591468115649407)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>40
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(305591349300649406)
,p_plug_name=>'Details L1'
,p_parent_plug_id=>wwv_flow_api.id(305591468115649407)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(305591273506649405)
,p_plug_name=>'Details R1'
,p_parent_plug_id=>wwv_flow_api.id(305591468115649407)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(299643240890655638)
,p_button_sequence=>160
,p_button_plug_id=>wwv_flow_api.id(305591953146649412)
,p_button_name=>'Help'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--link:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help me to get my item category'
,p_button_position=>'BODY'
,p_button_redirect_url=>'f?p=&APP_ID.:90:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-search-plus'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(127514036461599144)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(299642458662655630)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P10_ITEM_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_icon_css_classes=>'fa-save'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(127514160981599145)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(299642458662655630)
,p_button_name=>'UPDATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Apply Change'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P10_ITEM_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-save-as'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(127514290274599146)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(299642458662655630)
,p_button_name=>'Cancel'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.::P11_ITEM_ID:&P10_ITEM_ID.'
,p_button_condition=>'P10_ITEM_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(299641395273655620)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(299642458662655630)
,p_button_name=>'Cancel_1'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::'
,p_button_condition=>'P10_ITEM_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(128518068109121501)
,p_branch_name=>'GoTo 11'
,p_branch_action=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.::P11_ITEM_ID:&P10_ITEM_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(308991829356608112)
,p_name=>'P10_ESTIMATED_DATE_DEFINE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(305591539739649408)
,p_item_default=>'Y'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(308991724336608111)
,p_name=>'P10_ESTIMATED_DATE'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(305591539739649408)
,p_prompt=>'Project Start Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Enter the estimated date when the work must start'
,p_attribute_02=>'+0y+0m+1w'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
,p_attribute_08=>'+00:+05'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(308991645101608110)
,p_name=>'P10_ESTIMATED_QUARTER'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(305591539739649408)
,p_prompt=>'Estimated Quarter'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:1;1,2;2,3;3,4;4'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(308991551969608109)
,p_name=>'P10_ESTIMATED_YEAR'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(305591539739649408)
,p_prompt=>'Estimated Year'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:2024;2024,2025;2025,2026;2026,2027;2027,2028;2028,2029;2029'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(308991460129608108)
,p_name=>'P10_ESTIMATED_BUDGET'
,p_is_required=>true
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(305591539739649408)
,p_prompt=>'Current Year Budget'
,p_post_element_text=>'<p>&nbsp; AED</p>'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Enter project budget in AED for current year'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(308991354224608107)
,p_name=>'P10_ESTIMATED_BUDGET_H'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(305591539739649408)
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'B'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(308990520680608099)
,p_name=>'P10_END_USER_ID_OLD'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(305591853494649411)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(305594042246649433)
,p_name=>'P10_TASK_NEW_YN'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(305591577527649409)
,p_item_default=>'N'
,p_display_as=>'NATIVE_HIDDEN'
,p_display_when=>'P10_PROJECT_NEW_YN'
,p_display_when2=>'N'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(305593961452649432)
,p_name=>'P10_TASK_NUMBER'
,p_is_required=>true
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(305591577527649409)
,p_prompt=>'Task'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'TASKS BY PROJECT NUMBER PAGE10'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select TASK_NUMBER  Task, TASK_DESCRIPTION, COST_CENTER, FUTURE2',
'from tasks_all_v',
'where project_number = :P10_PROJECT_NUMBER;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P10_PROJECT_NUMBER'
,p_ajax_items_to_submit=>'P10_PROJECT_NUMBER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_display_when=>':P10_PROJECT_NEW_YN = ''N'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(305593853288649431)
,p_name=>'P10_TASK_NUMBER_NEW'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(305591577527649409)
,p_prompt=>'New Task'
,p_display_as=>'NATIVE_AUTO_COMPLETE'
,p_named_lov=>'TASKS ALL (SAMPLE)'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct TASK_NUMBER d, TASK_NUMBER R',
'from tasks_all_v',
'where task_number not like ''?%''',
'order by 1;'))
,p_cSize=>30
,p_cMaxlength=>25
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_help_text=>'Max 25 Character.'
,p_attribute_01=>'CONTAINS_IGNORE'
,p_attribute_04=>'Y'
,p_attribute_10=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(305593712160649430)
,p_name=>'P10_EXPENDITURE_TYPE'
,p_is_required=>true
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(305591577527649409)
,p_prompt=>'Expenditure Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'EXPENDITURE TYPES BY PAGE 10'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select EXPENDITURE_TYPE, DESCRIPTION, GL_ACCOUNT, GL_ACCOUNT_NAME',
'from expenditures_v',
'where project_number = :P10_PROJECT_NUMBER',
'and TASK_NUMBER = :P10_TASK_NUMBER ;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P10_TASK_NUMBER'
,p_ajax_items_to_submit=>'P10_TASK_NUMBER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_display_when=>':P10_PROJECT_NEW_YN = ''N'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(305593582489649429)
,p_name=>'P10_EXPENDITURE_TYPE_NEW'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(305591577527649409)
,p_prompt=>'New Expenditure Type'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EXPENDITURES ALL'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct EXPENDITURE_TYPE d, EXPENDITURE_TYPE r',
'from expenditures_v',
'order by 1'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(305592354916649416)
,p_name=>'P10_CC_H'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(305591853494649411)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(305592144579649414)
,p_name=>'P10_CC_NAME_H'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(305591853494649411)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(305591168831649404)
,p_name=>'P10_TOTAL_PROJECT_BUDGET'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(305591539739649408)
,p_prompt=>'Total Project Budget'
,p_post_element_text=>'<p>&nbsp; AED</p>'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Enter project budget in AED'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(305591067158649403)
,p_name=>'P10_TOTAL_PROJECT_BUDGET_H'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(305591539739649408)
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'B'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(299643582828655642)
,p_name=>'P10_ESTIMATED_DATE_DEFINE_OLD'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(305591539739649408)
,p_item_default=>'Y'
,p_prompt=>'Estimated Date Define ?'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(299643490535655641)
,p_name=>'P10_PROJECT_END_DATE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(305591539739649408)
,p_prompt=>'Project End Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Enter the estimated date when the work expected to end'
,p_attribute_02=>'&P10_ESTIMATED_DATE.'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
,p_attribute_08=>'+00:+05'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(299643439550655640)
,p_name=>'P10_PROJECT_TITLE'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(305591349300649406)
,p_prompt=>'Project Title'
,p_display_as=>'NATIVE_AUTO_COMPLETE'
,p_lov=>'select distinct PROJECT_TITLE from dp_items'
,p_cSize=>60
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_help_text=>'Please enter the project name that you wish to use for communication and documents titles through the procurement process.'
,p_attribute_01=>'CONTAINS_IGNORE'
,p_attribute_04=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(299640131082655607)
,p_name=>'P10_NOTES'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(299641241307655618)
,p_prompt=>'Notes'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>2
,p_grid_label_column_span=>2
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(299640070802655606)
,p_name=>'P10_PROJECT_NEW_YN_OLD'
,p_is_required=>true
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(305591577527649409)
,p_item_default=>'N'
,p_prompt=>'New Project ?'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Select if not an existing DCT project listed.'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(299639954395655605)
,p_name=>'P10_TASK_NEW_YN_OLD'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(305591577527649409)
,p_item_default=>'N'
,p_prompt=>'New Task ?'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(677992260236360)
,p_name=>'P10_CONTRACT_NO'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(128511483858293033)
,p_prompt=>'Contract No'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4513825835236146)
,p_name=>'P10_MAIN_CATEGORY_ID_H'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(305591953146649412)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(127512952794599133)
,p_name=>'P10_ITEM_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(128511483858293033)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(127513064509599134)
,p_name=>'P10_INITIATIVE_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(305591349300649406)
,p_prompt=>'Initiative'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'INITIATIVES POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select INITIATIVE_ID, INITIATIVE_CODE, INITIATIVE_NAME, ',
'    decode(INITIATIVE_TYPE, ''S'' , ''Strategic'' , ''N'', ''Non-Strategic'') INITIATIVE_TYPE',
'from strategic_initiatives;'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(127513135094599135)
,p_name=>'P10_PROJECT_NUMBER'
,p_is_required=>true
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(305591577527649409)
,p_prompt=>'Project'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'OPERATIONAL PROJECTS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PROJECT_NUMBER || '' - '' || PROJECT_NAME  PROJECT_NAME , project_number ',
'from project',
'where PROJECT_TYPE = ''Operational'''))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_help_text=>'Select from list of projects.'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(127513289452599136)
,p_name=>'P10_PROJECT_NEW_YN'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(305591577527649409)
,p_item_default=>'N'
,p_display_as=>'NATIVE_HIDDEN'
,p_help_text=>'Select if not an existing DCT project listed.'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(127513351597599137)
,p_name=>'P10_PROJECT_NEW_NAME'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(305591577527649409)
,p_prompt=>'New Project Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Name of project if not already listed'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(127513498154599138)
,p_name=>'P10_PROJECT_DESCRIPTION'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(305591349300649406)
,p_prompt=>'Project Brief'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>3
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_help_text=>'Give a summary in one or two paragraphs including brief statement on: project requirements, supplier key deliverables, location of work and special requirements, that could be used to send to suppliers for an Expression of Interest and other key docu'
||'ments'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(127513529666599139)
,p_name=>'P10_MAIN_CATEGORY_ID'
,p_is_required=>true
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(305591953146649412)
,p_prompt=>'Category Level 1'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'ITEM MAIN CATEGORIES POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  CATEGORY_NAME , CATEGORY_ID , CATEGORY_DESCRIPTION ',
'from dp_item_categories',
'where ORDER_LEVEL = 231 ;'))
,p_colspan=>11
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_help_text=>'Select from list of Level 1 categories depending on service being sourced.'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(127513670007599140)
,p_name=>'P10_SUB_CATEGORY_ID'
,p_is_required=>true
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(305591953146649412)
,p_prompt=>'Category Level 3'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'ITEM SUB_CSTEGORIES POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CATEGORY_ID  , CATEGORY_NAME ,CATEGORY_DESCRIPTION ',
'from dp_item_categories',
'where PARENT_CATEGORY_ID = :P10_CATEGORY_ID',
'and status = ''A''',
'and sysdate between nvl(START_DATE , sysdate - 10 ) and nvl(END_DATE , sysdate + 10)'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P10_CATEGORY_ID'
,p_ajax_items_to_submit=>'P10_CATEGORY_ID'
,p_ajax_optimize_refresh=>'Y'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_help_text=>'Select from list of Level 3 categories depending on service being sourced.'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128518987042121510)
,p_name=>'P10_END_USER_ID'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(305591853494649411)
,p_item_default=>'PERSON_ID'
,p_item_default_type=>'ITEM'
,p_prompt=>'End User'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e',
'where person_id > 10'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128519020545121511)
,p_name=>'P10_SECTOR_ID'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(305591853494649411)
,p_prompt=>'Sector'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ORGANIZATION NAME RETURN ORG_ID'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128519149735121512)
,p_name=>'P10_DEPARTMENT_ID'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(305591853494649411)
,p_prompt=>'Department'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ORGANIZATION NAME RETURN ORG_ID'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128521068419121531)
,p_name=>'P10_COST_CENTER'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(305591853494649411)
,p_item_default=>'user_details.get_cost_center(:P10_END_USER_ID)'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'Cost Center'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'COST CENTERS WITH NAMES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select COST_CENTER_CODE || ''('' || COST_CENTER_DESCRIPTION || '')'' display, COST_CENTER_CODE',
'from( ',
'select DISTINCT COST_CENTER_CODE , COST_CENTER_DESCRIPTION ',
'from dct_gl_code_combinations_all);'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128521218355121533)
,p_name=>'P10_CHANGED'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(128511483858293033)
,p_item_default=>'N'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(134346953454125445)
,p_name=>'P10_INITIATIVE_NEW_YN'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(128511483858293033)
,p_item_default=>'N'
,p_prompt=>'New  Initiative ?'
,p_display_as=>'NATIVE_YES_NO'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Select only if not an existing DCT strategic initiative listed.'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(134347087822125446)
,p_name=>'P10_INITIATIVE_NEW_NAME'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(128511483858293033)
,p_prompt=>'New Initiative Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Name of initiative if not already listed'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(135391172193579766)
,p_name=>'P10_DP_ITEM_TYPE_ID'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(305591273506649405)
,p_prompt=>'Project Item Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'DP ITEM TYPES LOV'
,p_lov=>'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 45 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10)'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p><span style="text-decoration: underline;"><span style="color: #0000ff; text-decoration: underline;">Strategic:</span></span> Projects where a strategy needs to be designed and requires SA support throughout the process.</p>',
'<p><br /><span style="text-decoration: underline;"><span style="color: #0000ff; text-decoration: underline;">Operational:</span></span> Projects that don&rsquo;t directly impact the economy and don&rsquo;t require an approved business case by SPD.</p'
||'>'))
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(135391577052579765)
,p_name=>'P10_RISK_ID'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(305591273506649405)
,p_item_default=>'211'
,p_prompt=>'Risk'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'DP RISK LEVEL LOV'
,p_lov=>'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 46 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10);'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Risk of the project - high, medium, low.',
'<p><span style="color: #0000ff;"><strong>High: </strong></span>Any delays, obstacles, or discrepancies can have a negative impact on the objectives of the project (e.g. financial, revenue, social, reputational).</p>',
'<p><strong><span style="color: #0000ff;">Low:</span> </strong>Possible delays won&rsquo;t have any major impact on the objectives of project.</p>'))
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(135391980802579765)
,p_name=>'P10_PRIORITY_ID'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(305591273506649405)
,p_item_default=>'122'
,p_prompt=>'Priority'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'PRIORITY LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id',
'from dct_lookup_values',
'where lookup_id = (Select x.lookup_id',
'                    from dct_lookups x',
'                    where x.LOOKUP_CODE = ''PRIORITY'');'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Priority of the project - high, medium, low.',
'<p><span style="color: #0000ff;"><strong>High: </strong><span style="color: #000000;">Requires a faster usual turn-around time</span></span></p>',
'<p><strong><span style="color: #0000ff;">Low:</span> </strong>Enough time for the standard procurement timeline to take place.</p>'))
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140457472520095034)
,p_name=>'P10_CATEGORY_ID'
,p_is_required=>true
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(305591953146649412)
,p_prompt=>'Category Level 2'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'ITEM CATEGORIES POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CATEGORY_ID, CATEGORY_NAME , CATEGORY_DESCRIPTION ',
'from dp_item_categories',
'where ORDER_LEVEL = 232 ',
'and parent_category_id = :P10_MAIN_CATEGORY_ID;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P10_MAIN_CATEGORY_ID'
,p_ajax_items_to_submit=>'P10_MAIN_CATEGORY_ID'
,p_ajax_optimize_refresh=>'Y'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'YES'
,p_help_text=>'Select from list of level 2 categories depending on service being sourced.'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(135342506414699607)
,p_validation_name=>'Initiative Required Validation Process'
,p_validation_sequence=>10
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    if (:P10_INITIATIVE_NEW_YN = ''N''  and :P10_INITIATIVE_ID is null ) OR',
'       (:P10_INITIATIVE_NEW_YN = ''Y''  and :P10_INITIATIVE_NEW_NAME is null )',
'        then',
'            return false;',
'    else',
'        return true;',
'    end if;',
'end;'))
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'Please select or enter Initiative.'
,p_validation_condition_type=>'NEVER'
,p_associated_item=>wwv_flow_api.id(134346953454125445)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(305592865885649421)
,p_validation_name=>'check New Task required'
,p_validation_sequence=>20
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(:P10_TASK_NEW_YN = ''Y'' and :P10_TASK_NUMBER_NEW is not Null) or ',
':P10_PROJECT_NEW_YN = ''Y'' or',
':P10_TASK_NEW_YN = ''N'''))
,p_validation_type=>'PLSQL_EXPRESSION'
,p_error_message=>'Please enter the new task'
,p_associated_item=>wwv_flow_api.id(305593853288649431)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(305590892975649402)
,p_validation_name=>'Check Total Project Not Less Than Estimated Budget '
,p_validation_sequence=>30
,p_validation=>'to_number(replace(nvl(:P10_ESTIMATED_BUDGET,0),'','','''')) <= to_number(replace(nvl(:P10_TOTAL_PROJECT_BUDGET,0),'','',''''))'
,p_validation_type=>'PLSQL_EXPRESSION'
,p_error_message=>'Current year budget can''t exceed the Total Project.'
,p_always_execute=>'Y'
,p_associated_item=>wwv_flow_api.id(305591168831649404)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(128518158984121502)
,p_name=>'New Project DA'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_PROJECT_NEW_YN'
,p_condition_element=>'P10_PROJECT_NEW_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'N'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128518620283121507)
,p_event_id=>wwv_flow_api.id(128518158984121502)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_PROJECT_NUMBER,P10_PROJECT_NEW_NAME'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128518796049121508)
,p_event_id=>wwv_flow_api.id(128518158984121502)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_PROJECT_NEW_NAME,P10_PROJECT_NUMBER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128518270862121503)
,p_event_id=>wwv_flow_api.id(128518158984121502)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_PROJECT_NUMBER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128518584626121506)
,p_event_id=>wwv_flow_api.id(128518158984121502)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_PROJECT_NEW_NAME'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128518333268121504)
,p_event_id=>wwv_flow_api.id(128518158984121502)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_PROJECT_NUMBER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128518478151121505)
,p_event_id=>wwv_flow_api.id(128518158984121502)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_PROJECT_NEW_NAME'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(130378993155155405)
,p_event_id=>wwv_flow_api.id(128518158984121502)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_CHANGED'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(135343442650699616)
,p_event_id=>wwv_flow_api.id(128518158984121502)
,p_event_result=>'FALSE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_CHANGED'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(128521346080121534)
,p_name=>'Item Key Changed DA'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_INITIATIVE_ID,P10_PROJECT_NUMBER,P10_PROJECT_NEW_NAME,P10_MAIN_CATEGORY_ID,P10_SUB_CATEGORY_ID'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128521430935121535)
,p_event_id=>wwv_flow_api.id(128521346080121534)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_CHANGED'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(134347102706125447)
,p_name=>'New Initiative DA'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_INITIATIVE_NEW_YN'
,p_condition_element=>'P10_INITIATIVE_NEW_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'N'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
,p_display_when_type=>'NEVER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(134347220257125448)
,p_event_id=>wwv_flow_api.id(134347102706125447)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_INITIATIVE_ID,P10_PROJECT_NUMBER,P10_INITIATIVE_NEW_NAME,P10_PROJECT_NEW_NAME'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(135342014309699602)
,p_event_id=>wwv_flow_api.id(134347102706125447)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_INITIATIVE_NEW_NAME,P10_INITIATIVE_ID,P10_PROJECT_NUMBER,P10_PROJECT_NEW_NAME'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(134347379075125449)
,p_event_id=>wwv_flow_api.id(134347102706125447)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_INITIATIVE_NEW_NAME,P10_INITIATIVE_ID'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(135342140661699603)
,p_event_id=>wwv_flow_api.id(134347102706125447)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_INITIATIVE_NEW_NAME'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(134347439967125450)
,p_event_id=>wwv_flow_api.id(134347102706125447)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_INITIATIVE_NEW_NAME'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(135342208961699604)
,p_event_id=>wwv_flow_api.id(134347102706125447)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_INITIATIVE_ID'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(135341946966699601)
,p_event_id=>wwv_flow_api.id(134347102706125447)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_CHANGED'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(135342396562699605)
,p_event_id=>wwv_flow_api.id(134347102706125447)
,p_event_result=>'FALSE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_CHANGED'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4730588502832580)
,p_name=>'ITEM GETS FOCUS'
,p_event_sequence=>50
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(128511483858293033)
,p_bind_type=>'bind'
,p_bind_event_type=>'focusin'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4730660822832581)
,p_event_id=>wwv_flow_api.id(4730588502832580)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ADD_CLASS'
,p_affected_elements_type=>'EVENT_SOURCE'
,p_attribute_01=>'showfocus'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4730757123832582)
,p_name=>'ITEM LOSES FOCUS'
,p_event_sequence=>60
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(128511483858293033)
,p_bind_type=>'bind'
,p_bind_event_type=>'focusout'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4730868612832583)
,p_event_id=>wwv_flow_api.id(4730757123832582)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_REMOVE_CLASS'
,p_affected_elements_type=>'EVENT_SOURCE'
,p_attribute_01=>'showfocus'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(305593536298649428)
,p_name=>'New Task YN Changes'
,p_event_sequence=>70
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_TASK_NEW_YN'
,p_condition_element=>'P10_TASK_NEW_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(305593383742649427)
,p_event_id=>wwv_flow_api.id(305593536298649428)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_TASK_NUMBER,P10_EXPENDITURE_TYPE'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(305593146287649424)
,p_event_id=>wwv_flow_api.id(305593536298649428)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_TASK_NUMBER_NEW,P10_EXPENDITURE_TYPE_NEW'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(305593329644649426)
,p_event_id=>wwv_flow_api.id(305593536298649428)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_TASK_NUMBER_NEW,P10_EXPENDITURE_TYPE_NEW'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(305592996132649423)
,p_event_id=>wwv_flow_api.id(305593536298649428)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_TASK_NUMBER_NEW,P10_EXPENDITURE_TYPE_NEW'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(305593198747649425)
,p_event_id=>wwv_flow_api.id(305593536298649428)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_TASK_NUMBER,P10_EXPENDITURE_TYPE'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(305592914579649422)
,p_event_id=>wwv_flow_api.id(305593536298649428)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_TASK_NUMBER,P10_EXPENDITURE_TYPE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(305592687461649420)
,p_name=>'Task Number Changed DA'
,p_event_sequence=>80
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_EXPENDITURE_TYPE'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(305592667890649419)
,p_event_id=>wwv_flow_api.id(305592687461649420)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count    number;',
'begin',
'',
'select nvl(count(*),0)',
'into l_count',
'from cashflow_lines',
'where source = ''DP''',
'and request_id = :P10_ITEM_ID;',
'',
'if l_count > 0',
'then',
'        update cashflow_lines',
'        set cost_center = PROJECTS_UTIL.task_cost_center(:P10_PROJECT_NUMBER, :P10_TASK_NUMBER),',
'            BUDGET_GROUB_CODE = PROJECTS_UTIL.task_budget_code(:P10_PROJECT_NUMBER, :P10_TASK_NUMBER),',
'            GL_ACCOUNT = PROJECTS_UTIL.expenditure_type_gl_account(:P10_PROJECT_NUMBER, :P10_TASK_NUMBER, :P10_EXPENDITURE_TYPE),',
'            activity = PROJECTS_UTIL.task_activity(:P10_PROJECT_NUMBER, :P10_TASK_NUMBER),',
'            future1  = PROJECTS_UTIL.task_future1(:P10_PROJECT_NUMBER, :P10_TASK_NUMBER),',
'            future2  = PROJECTS_UTIL.task_future2(:P10_PROJECT_NUMBER, :P10_TASK_NUMBER),',
'            entity_code = ''451'',',
'            task_number = :P10_TASK_NUMBER,',
'            expenditure_type = :P10_EXPENDITURE_TYPE',
'        where source = ''DP''',
'        and request_id = :P10_ITEM_ID;',
'',
'end if;',
'',
'end;'))
,p_attribute_02=>'P10_ITEM_ID,P10_PROJECT_NUMBER,P10_TASK_NUMBER,P10_EXPENDITURE_TYPE'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(305592570330649418)
,p_name=>'get End User Cost Center DA'
,p_event_sequence=>90
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_END_USER_ID'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(305592416090649417)
,p_event_id=>wwv_flow_api.id(305592570330649418)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_CC_H,P10_CC_NAME_H'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select cost_center_code , ''('' || cost_center_code || '')- '' ||user_details.get_cost_center_name(cost_center_code) name',
'from employees_v',
'where person_id = :P10_END_USER_ID'))
,p_attribute_07=>'P10_END_USER_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(305592218923649415)
,p_event_id=>wwv_flow_api.id(305592570330649418)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.item(''P10_COST_CENTER'').setValue($v(''P10_CC_H''),$v(''P10_CC_NAME_H''))'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(308991253227608106)
,p_name=>'ESTIMATED_DATE_DEFINE DA'
,p_event_sequence=>100
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_ESTIMATED_DATE_DEFINE_OLD'
,p_condition_element=>'P10_ESTIMATED_DATE_DEFINE_OLD'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'N'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(308991160581608105)
,p_event_id=>wwv_flow_api.id(308991253227608106)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_ESTIMATED_DATE'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(308990821984608102)
,p_event_id=>wwv_flow_api.id(308991253227608106)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_ESTIMATED_DATE'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(308991066960608104)
,p_event_id=>wwv_flow_api.id(308991253227608106)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_ESTIMATED_DATE'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(308990746477608101)
,p_event_id=>wwv_flow_api.id(308991253227608106)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_ESTIMATED_QUARTER,P10_ESTIMATED_YEAR'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(308990953584608103)
,p_event_id=>wwv_flow_api.id(308991253227608106)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_ESTIMATED_QUARTER,P10_ESTIMATED_YEAR'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(308990658098608100)
,p_event_id=>wwv_flow_api.id(308991253227608106)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_ESTIMATED_QUARTER,P10_ESTIMATED_YEAR'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(305590803586649401)
,p_name=>'ESTIMATED_BUDGET DA'
,p_event_sequence=>110
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_ESTIMATED_BUDGET'
,p_condition_element=>'P10_ESTIMATED_BUDGET'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(305590679588649400)
,p_event_id=>wwv_flow_api.id(305590803586649401)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'delete from CASHFLOW_LINES where SOURCE = ''DP''',
'and REQUEST_ID = :P10_ITEM_ID;'))
,p_attribute_02=>'P10_ITEM_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(305590654434649399)
,p_event_id=>wwv_flow_api.id(305590803586649401)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_ESTIMATED_BUDGET_H'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>'to_number(replace(nvl(:P10_ESTIMATED_BUDGET,0),'','',''''))'
,p_attribute_07=>'P10_ESTIMATED_BUDGET'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(305590536482649398)
,p_name=>'Total Project Budget DA'
,p_event_sequence=>120
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_TOTAL_PROJECT_BUDGET'
,p_bind_type=>'bind'
,p_bind_event_type=>'focusout'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(305590449030649397)
,p_event_id=>wwv_flow_api.id(305590536482649398)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_TOTAL_PROJECT_BUDGET_H'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>'to_number(replace(nvl(:P10_TOTAL_PROJECT_BUDGET,0),'','',''''))'
,p_attribute_07=>'P10_TOTAL_PROJECT_BUDGET'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(128518896508121509)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialize'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    item_id,',
'    INITIATIVE_NEW_YN,',
'    initiative_id,',
'    PROJECT_TITLE,',
'    INITIATIVE_NEW_NAME,',
'    project_number,',
'    project_new_yn,',
'    project_new_name,',
'    TASK_NEW_YN,',
'    TASK_NUMBER,',
'    TASK_NUMBER_NEW,',
'    EXPENDITURE_TYPE,',
'    EXPENDITURE_TYPE_NEW,',
'    project_description,',
'    main_category_id,',
'    category_id,',
'    sub_category_id,',
'    end_user_id,',
'    end_user_id end_user_id_h,',
'    sector_id,',
'    department_id,',
'    cost_center,',
'    cost_center    cost_center_h,',
'    DP_ITEM_TYPE_ID,',
'    CONTRACT_NO,',
'    RISK_ID,',
'    PRIORITY_ID,',
'    --budget',
'    ESTIMATED_DATE_DEFINE,',
'    to_char(ESTIMATED_DATE,''DD-MON-YYYY''),',
'    to_char(PROJECT_END_DATE,''DD-MON-YYYY''),',
'    ESTIMATED_YEAR,',
'    ESTIMATED_QUARTER,',
'    trim(to_char(ESTIMATED_BUDGET,''99,999,999,999.99''))     ESTIMATED_BUDGET,',
'    ESTIMATED_BUDGET,',
'    trim(to_char(TOTAL_PROJECT_BUDGET,''99,999,999,999.99''))     TOTAL_PROJECT_BUDGET,',
'    TOTAL_PROJECT_BUDGET',
'INTO',
'            :P10_ITEM_ID,',
'            :P10_INITIATIVE_NEW_YN,',
'            :P10_INITIATIVE_ID,',
'            :P10_PROJECT_TITLE,',
'            :P10_INITIATIVE_NEW_NAME,',
'            :P10_PROJECT_NUMBER,',
'            :P10_PROJECT_NEW_YN,',
'            :P10_PROJECT_NEW_NAME,',
'            :P10_TASK_NEW_YN,',
'            :P10_TASK_NUMBER,',
'            :P10_TASK_NUMBER_NEW,',
'            :P10_EXPENDITURE_TYPE,',
'            :P10_EXPENDITURE_TYPE_NEW,',
'            :P10_PROJECT_DESCRIPTION,',
'            :P10_MAIN_CATEGORY_ID,',
'            :P10_CATEGORY_ID,',
'            :P10_SUB_CATEGORY_ID,',
'            :P10_END_USER_ID,',
'            :P10_END_USER_ID_OLD,',
'            :P10_SECTOR_ID,',
'            :P10_DEPARTMENT_ID,',
'            :P10_COST_CENTER,',
'            :P10_CC_H,',
'            :P10_DP_ITEM_TYPE_ID,',
'            :P10_CONTRACT_NO,',
'            :P10_RISK_ID,',
'            :P10_PRIORITY_ID,',
'            :P10_ESTIMATED_DATE_DEFINE,',
'            :P10_ESTIMATED_DATE,',
'            :P10_PROJECT_END_DATE,',
'            :P10_ESTIMATED_YEAR,',
'            :P10_ESTIMATED_QUARTER,',
'            :P10_ESTIMATED_BUDGET,',
'            :P10_ESTIMATED_BUDGET_H,',
'            :P10_TOTAL_PROJECT_BUDGET,',
'            :P10_TOTAL_PROJECT_BUDGET_H',
'FROM',
'    dp_items',
'WHERE item_id = :P10_ITEM_ID  ;',
'exception',
'    when others then null; '))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P10_ITEM_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(127514573823599149)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Insert New DP Item Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_total_count             Number;',
'--l_dp_item_name            varchar2(512);',
'l_COUNT_YEAR              Number;',
'l_COUNT_ITEM              Number;',
'L_id                      Number;',
'l_cost_center             varchar2(7);',
'l_project                 varchar2(512);',
'l_initiative              varchar2(512);',
'l_DP_ITEM_CODE            varchar2(255);',
'BEGIN',
'',
'select NVL(Max(COUNT_YEAR),0)+1  ',
'into l_COUNT_YEAR',
'from dp_items',
'where dp_year = DP_ITEMS_UTIL.get_active_year    --NV(''CURRENT_YEAR'')',
';',
'',
'',
'select NVL(Max(COUNT_ITEM),0)+1  ',
'into l_COUNT_ITEM',
'from dp_items',
'where dp_year = DP_ITEMS_UTIL.get_active_year    --NV(''CURRENT_YEAR'')',
'and category_id = :P10_CATEGORY_ID;',
'',
'l_cost_center := :P10_COST_CENTER;',
'',
' SELECT DP_ITEMS_SEQ.nextval',
'into :P10_ITEM_ID',
'FROM all_sequences',
' WHERE sequence_owner = ''PROD''',
'   AND sequence_name = ''DP_ITEMS_SEQ'';',
'',
'select NVL2(:P10_PROJECT_NUMBER,DP_ITEMS_UTIL.get_project_name(:P10_PROJECT_NUMBER),:P10_PROJECT_NEW_NAME)',
'into l_project',
'from dual;',
'',
'--select NVL2(:P10_INITIATIVE_ID,DP_ITEMS_UTIL.get_initative_name(:P10_INITIATIVE_ID),:P10_INITIATIVE_NEW_NAME)',
'--into l_initiative',
'--from dual;',
'',
'-- user_details.get_org_code_by_cc(l_cost_center) || ''-'' || extract(Year from sysdate)  || ''-'' || DP_ITEMS_UTIL.get_item_category_code(:P10_CATEGORY_ID)',
'--l_DP_ITEM_CODE := ''DP-'' || user_details.get_org_code_by_cc(l_cost_center) || ''-'' || extract(Year from sysdate)  || ''-'' || DP_ITEMS_UTIL.get_item_category_code(:P10_CATEGORY_ID);',
'l_DP_ITEM_CODE := ''DP-'' || user_details.get_org_code_by_cc(l_cost_center) || ''-'' || extract(Year from sysdate)  || ''-'' || trim(to_char(l_COUNT_YEAR, ''0009''));',
'',
'--L_DP_ITEM_NAME := l_initiative                                                  || ''/'' ||',
'--                  l_project                                                     || ''/'' ||',
'--                  DP_ITEMS_UTIL.get_item_category_name(:P10_CATEGORY_ID)        || ''/'' ||',
'--                  DP_ITEMS_UTIL.get_item_category_name(:P10_SUB_CATEGORY_ID)    || ''/'' ||  ',
'--                  extract(Year from sysdate)                                    || ''/'' ||',
'--                  l_COUNT_YEAR                                                  || ''/'' ||',
'--                  l_COUNT_ITEM;',
'                  ',
'INSERT INTO dp_items (',
'    DP_ITEM_CODE,    ',
'    item_id,',
'    INITIATIVE_NEW_YN,',
'    initiative_id,',
'    INITIATIVE_NEW_NAME,',
'    project_number,',
'    project_new_yn,',
'    task_new_yn,',
'    project_new_name,',
'    project_description,',
'    main_category_id,',
'    category_id,',
'    sub_category_id,',
'    end_user_id,',
'    sector_id,',
'    department_id,',
'    cutt_off_date,',
'  --  DP_ITEM_NAME,',
'    PLANNING_STATUS, ',
'    REVIEW_STATUS, ',
'    APPROVAL_STATUS,',
'    CREATED_BY, ',
'    CREATED_ON,',
'    COST_CENTER,',
'    COUNT_YEAR,',
'    COUNT_ITEM,',
'    DP_YEAR,',
'    DP_ITEM_TYPE_ID,',
'    CONTRACT_NO,',
'    RISK_ID,',
'    PRIORITY_ID,',
'    template_id,',
'    DP_ITEM_STATUS_ID,',
'    task_number,',
'    EXPENDITURE_TYPE,',
'    PROJECT_TITLE,',
'    PROJECT_END_DATE,',
'    ESTIMATED_DATE,',
'    ESTIMATED_BUDGET,',
'    TOTAL_PROJECT_BUDGET,',
'    NOTES)',
'    ',
'    VALUES( l_DP_ITEM_CODE, --DP_ITEM_CODE',
'            :P10_ITEM_ID,       --item_id',
'            :P10_INITIATIVE_NEW_YN, -- INITIATIVE_NEW_YN',
'            :P10_INITIATIVE_ID,     --initiative_id',
'            :P10_INITIATIVE_NEW_NAME,   --INITIATIVE_NEW_NAME',
'            :P10_PROJECT_NUMBER,        -- project_number',
'            :P10_PROJECT_NEW_YN,        --project_new_yn',
'            decode(:P10_PROJECT_NEW_YN , ''Y'', ''Y'', ''N''),    --task_new_yn',
'            :P10_PROJECT_NEW_NAME,                  --project_new_name',
'            :P10_PROJECT_DESCRIPTION,               --project_description',
'            :P10_MAIN_CATEGORY_ID,              -- main_category_id',
'            :P10_CATEGORY_ID,                   -- category_id',
'            :P10_SUB_CATEGORY_ID,               -- sub_category_id',
'            :P10_END_USER_ID,                   -- end_user_id',
'            user_details.get_emp_sector_id(:P10_END_USER_ID),       -- sector_id',
'            user_details.get_emp_department_id(:P10_END_USER_ID),   -- department_id',
'            dp_items_util.get_current_cuttoff_date(to_number(DP_ITEMS_UTIL.get_active_year)),    --cutt_off_date',
'     --       L_DP_ITEM_NAME,   -- DP_ITEM_NAME',
'            DP_ITEMS_UTIL.GET_ITEM_PLANNING_STATUS(:P10_ITEM_ID , ''I''), -- PLANNING_STATUS',
'            ''Draft'',            -- REVIEW_STATUS',
'            ''Required'',          -- APPROVAL_STATUS',
'            :PERSON_ID,         -- CREATED_BY',
'            systimestamp,       -- CREATED_ON',
'            l_cost_center,      -- COST_CENTER',
'            l_COUNT_YEAR,       -- COUNT_YEAR',
'            l_COUNT_ITEM,       -- COUNT_ITEM',
'            DP_ITEMS_UTIL.get_active_year,    --DP_YEAR',
'            :P10_DP_ITEM_TYPE_ID,               -- DP_ITEM_TYPE_ID',
'            :P10_CONTRACT_NO,                  -- CONTRACT_NO',
'            :P10_RISK_ID,                       -- RISK_ID',
'            :P10_PRIORITY_ID,                   -- PRIORITY_ID',
'           (select TEMPLATE_ID          ',
'            from dp_item_categories',
'            where CATEGORY_ID = :P10_SUB_CATEGORY_ID),      -- template_id',
'           1                    -- DP_ITEM_STATUS_ID',
'           , :P10_TASK_NUMBER        --task_number',
'           , :P10_EXPENDITURE_TYPE      -- EXPENDITURE_TYPE',
'           , :P10_PROJECT_TITLE         -- PROJECT_TITLE',
'           , to_date(:P10_PROJECT_END_DATE,''dd-Mon-YYYY'')      -- PROJECT_END_DATE',
'           , to_date(:P10_ESTIMATED_DATE,''dd-Mon-YYYY'')        -- ESTIMATED_DATE',
'           , :P10_ESTIMATED_BUDGET_H',
'           , to_number(replace(nvl(:P10_TOTAL_PROJECT_BUDGET,0),'','',''''))',
'           , :P10_NOTES',
'        );    ',
'        ',
'-- insert category role',
'if DP_ITEMS_UTIL.PBP_COUNT_BY_DP_CATEGORY_ID(:P10_SUB_CATEGORY_ID) > 0',
'then ',
'INSERT INTO dp_item_roles (item_id, role_id, person_id)',
'select :P10_ITEM_ID ,ROLE_ID, PERSON_ID ',
'from dp_item_category_roles',
'where CATEGORY_ID = :P10_SUB_CATEGORY_ID',
'and status = ''A''',
'and sysdate between nvl(START_DATE, sysdate - 10) and nvl(END_DATE , sysdate + 10) ;',
'',
'else',
'    -- insert PbP from cost center',
'    INSERT INTO dp_item_roles (item_id, role_id, person_id)',
'        select :P10_ITEM_ID ,108, PERSON_ID ',
'        from cost_centers_fbp',
'        where COST_CENTER = l_cost_center',
'        and status = ''A''',
'        and sysdate between nvl(START_DATE, sysdate - 10) and nvl(END_DATE , sysdate + 10) ',
'        and BP_TYPE = ''PBP'';',
'End if;        ',
'',
'-- insert finance BP',
'for emp in (select PERSON_ID ',
'            from cost_centers_fbp',
'            where COST_CENTER = l_cost_center ',
'            and STATUS = ''A''',
'            and sysdate between nvl(START_DATE , sysdate - 10) and nvl(END_DATE , sysdate + 10)',
'            and BP_TYPE = ''FBP'')',
'    loop',
'        INSERT INTO dp_item_roles (item_id, role_id, person_id)',
'        values (:P10_ITEM_ID , 73 , emp.person_id);',
'    end loop;',
'',
'-- Insert Participants',
'INSERT INTO dp_item_participants (item_id, person_id, role_id, status, start_date) ',
'VALUES (:P10_ITEM_ID, :PERSON_ID,',
'    241,    -- ROLE_id FOR OWNER (lOOKUP:DP_ITEM_PARTICIPANT_ROL)',
'    ''A'',sysdate);',
'--Insert Initial Status Record',
'INSERT INTO dp_item_status (dp_item_id, dp_item_status_id, ORDER_NO,from_date) VALUES (:P10_ITEM_ID,1,1, systimestamp);',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(127514036461599144)
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(127514673674599150)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update DP Item Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_total_count               number;',
'l_request_no        varchar2(50);',
'l_COUNT_YEAR              Number;',
'l_COUNT_ITEM              Number;',
'L_DP_ITEM_NAME            VARCHAR2(512);',
'l_cost_center             varchar2(7);',
'l_planning_status        Number;',
'l_project                varchar2(512);',
'l_initiative              varchar2(512);',
'l_DP_ITEM_CODE            varchar2(255);',
'begin',
'',
'',
'if :P10_CHANGED = ''Y''',
'Then',
'                select NVL(Max(COUNT_YEAR),0)+1  ',
'                into l_COUNT_YEAR',
'                from dp_items',
'                where dp_year = DP_ITEMS_UTIL.get_active_year    --NV(''CURRENT_YEAR'')',
'                and ITEM_ID != :P10_ITEM_ID;',
'',
'',
'                select NVL(Max(COUNT_ITEM),0)+1  ',
'                into l_COUNT_ITEM',
'                from dp_items',
'                where dp_year = DP_ITEMS_UTIL.get_active_year    -- NV(''CURRENT_YEAR'')',
'                -- and INITIATIVE_ID = :P10_INITIATIVE_ID',
'                -- and project_number = nvl(:P10_PROJECT_NUMBER ,project_number)',
'                and category_id = :P10_CATEGORY_ID',
'                --and SUB_CATEGORY_ID = :P10_SUB_CATEGORY_ID',
'                and ITEM_ID != :P10_ITEM_ID',
'                ;',
'                ',
'--                select NVL2(:P10_PROJECT_NUMBER,',
'--                                       DP_ITEMS_UTIL.get_project_name(:P10_PROJECT_NUMBER),',
'--                                      :P10_PROJECT_NEW_NAME)',
'--                 into l_project',
'--                 from dual;',
'                                  ',
'                l_cost_center := :P10_CC_H;',
'                l_planning_status := DP_ITEMS_UTIL.GET_ITEM_PLANNING_STATUS(:P10_ITEM_ID , ''U'');',
'                ',
'      l_DP_ITEM_CODE := ''DP-'' || user_details.get_org_code_by_cc(l_cost_center) || ''-'' || extract(Year from sysdate)  || ''-'' || trim(to_char(l_COUNT_YEAR, ''0009''));             ',
'                ',
'        Update dp_items ',
'        Set DP_ITEM_CODE        = l_DP_ITEM_CODE,',
'            PROJECT_TITLE       = :P10_PROJECT_TITLE,',
'            initiative_id       = :P10_INITIATIVE_ID,',
'            INITIATIVE_NEW_YN   = :P10_INITIATIVE_NEW_YN,',
'            INITIATIVE_NEW_NAME = :P10_INITIATIVE_NEW_NAME,',
'            project_number      = decode(:P10_PROJECT_NEW_YN , ''N'',:P10_PROJECT_NUMBER,''Y'' ,null),',
'            project_new_yn      = :P10_PROJECT_NEW_YN,',
'            project_new_name    = :P10_PROJECT_NEW_NAME,',
'            project_description = :P10_PROJECT_DESCRIPTION,',
'            main_category_id    = :P10_MAIN_CATEGORY_ID,',
'            category_id         = :P10_CATEGORY_ID,',
'            sub_category_id     = :P10_SUB_CATEGORY_ID,',
'            COUNT_YEAR          = l_COUNT_YEAR,',
'            COUNT_ITEM          = l_COUNT_ITEM,',
'            DP_YEAR             = DP_ITEMS_UTIL.get_active_year,    --NV(''CURRENT_YEAR''),   ',
'            end_user_id         = :P10_END_USER_ID ,',
'            sector_id           = user_details.get_cc_sector_id(:P10_COST_CENTER),',
'            department_id       = user_details.get_emp_department_id(:PERSON_ID),',
'            cutt_off_date       = dp_items_util.get_current_cuttoff_date(to_number(DP_ITEMS_UTIL.get_active_year)),    --:CURRENT_YEAR)),',
'            PLANNING_STATUS     = l_planning_status,',
'            REVIEW_STATUS       = ''Draft'', ',
'            APPROVAL_STATUS     = ''Draft'',',
'      --      COST_CENTER         = :P10_CC_H,',
'              COST_CENTER         = :P10_COST_CENTER,',
'            DP_ITEM_TYPE_ID     = :P10_DP_ITEM_TYPE_ID,',
'            RISK_ID             = :P10_RISK_ID,',
'            PRIORITY_ID         = :P10_PRIORITY_ID,',
'            template_id = (select TEMPLATE_ID',
'                            from dp_item_categories',
'                            where CATEGORY_ID = :P10_SUB_CATEGORY_ID),',
'                            ',
'            TASK_NEW_YN                 = :P10_TASK_NEW_YN,',
'            TASK_NUMBER                 = :P10_TASK_NUMBER,',
'            TASK_NUMBER_NEW             = :P10_TASK_NUMBER_NEW,',
'            EXPENDITURE_TYPE            = :P10_EXPENDITURE_TYPE,',
'            EXPENDITURE_TYPE_NEW        = :P10_EXPENDITURE_TYPE_NEW,',
'            ',
'            ESTIMATED_DATE_DEFINE       = :P10_ESTIMATED_DATE_DEFINE,',
'            ESTIMATED_DATE              = to_date(:P10_ESTIMATED_DATE,''dd-Mon-YYYY''),',
'            PROJECT_END_DATE            = to_date(:P10_PROJECT_END_DATE,''dd-Mon-YYYY''),',
'            ESTIMATED_QUARTER           = NVL(trim(to_char(to_date(:P10_ESTIMATED_DATE, ''dd-Mon-YYYY'' ) , ''Q'')) , :P10_ESTIMATED_QUARTER),',
'            ESTIMATED_YEAR              = NVL(trim(to_char(to_date(:P10_ESTIMATED_DATE, ''dd-Mon-YYYY'' ) , ''YYYY'')),:P10_ESTIMATED_YEAR),',
'            ESTIMATED_BUDGET_DEFINE     = ''Y'',',
'            TOTAL_PROJECT_BUDGET        = to_number(replace(nvl(:P10_TOTAL_PROJECT_BUDGET,0),'','','''')),',
'            ESTIMATED_BUDGET            = :P10_ESTIMATED_BUDGET_H,',
'            ESTIMATED_BUDGET_BRACKET_ID = (select  BRACKET_ID',
'                                            from dp_budget_brackets',
'                                            where :P10_ESTIMATED_BUDGET_H between MIN_VALUE and  MAX_VALUE),',
'           NOTES = :P10_NOTES',
'        where ITEM_ID = :P10_ITEM_ID;       ',
'        ',
'                -- update category role',
'            delete from dp_item_roles where item_id = :P10_ITEM_ID;',
'            ',
'            if DP_ITEMS_UTIL.PBP_COUNT_BY_DP_CATEGORY_ID(:P10_SUB_CATEGORY_ID) > 0',
'                then ',
'                    INSERT INTO dp_item_roles (item_id, role_id, person_id)',
'                    select :P10_ITEM_ID ,ROLE_ID, PERSON_ID ',
'                    from dp_item_category_roles',
'                    where CATEGORY_ID = :P10_MAIN_CATEGORY_ID',
'                    and status = ''A''',
'                    and sysdate between nvl(START_DATE, sysdate - 10) and nvl(END_DATE , sysdate + 10) ;',
'',
'                else',
'                    -- insert PbP from cost center',
'                    INSERT INTO dp_item_roles (item_id, role_id, person_id)',
'                        select :P10_ITEM_ID ,108, PERSON_ID ',
'                        from cost_centers_fbp',
'                        where COST_CENTER = l_cost_center',
'                        and status = ''A''',
'                        and sysdate between nvl(START_DATE, sysdate - 10) and nvl(END_DATE , sysdate + 10) ',
'                        and BP_TYPE = ''PBP'';',
'                End if;   ',
'            ',
'            -- insert finance BP',
'            for emp in (select PERSON_ID ',
'                        from cost_centers_fbp',
'                        where COST_CENTER = l_cost_center ',
'                        and STATUS = ''A''',
'                        and sysdate between nvl(START_DATE , sysdate - 10) and nvl(END_DATE , sysdate + 10)',
'                        and BP_TYPE = ''FBP'')',
'                loop',
'                    INSERT INTO dp_item_roles (item_id, role_id, person_id)',
'                    values (:P10_ITEM_ID , 73 , emp.person_id);',
'                end loop;    ',
'else',
'    l_cost_center := :P10_CC_H;',
'    l_planning_status := DP_ITEMS_UTIL.GET_ITEM_PLANNING_STATUS(:P10_ITEM_ID , ''U'');',
'    Update dp_items ',
'    Set  project_description = :P10_PROJECT_DESCRIPTION,   ',
'        end_user_id          = :PERSON_ID ,',
'        sector_id            = user_details.get_emp_sector_id(:PERSON_ID),',
'        department_id        = user_details.get_emp_department_id(:PERSON_ID),',
'        cutt_off_date        = dp_items_util.get_current_cuttoff_date(to_number(DP_ITEMS_UTIL.get_active_year)),    --:CURRENT_YEAR)),',
'        PLANNING_STATUS             = l_planning_status,',
'        REVIEW_STATUS               = ''Draft'', ',
'        APPROVAL_STATUS             = ''Draft'',',
'        COST_CENTER                 = l_cost_center,',
'        TASK_NEW_YN                 = :P10_TASK_NEW_YN,',
'        TASK_NUMBER                 = :P10_TASK_NUMBER,',
'        TASK_NUMBER_NEW             = :P10_TASK_NUMBER_NEW,',
'        EXPENDITURE_TYPE            = :P10_EXPENDITURE_TYPE,',
'        EXPENDITURE_TYPE_NEW        = :P10_EXPENDITURE_TYPE_NEW,',
'        ESTIMATED_DATE_DEFINE       = :P10_ESTIMATED_DATE_DEFINE,',
'        ESTIMATED_DATE              = to_date(:P10_ESTIMATED_DATE,''dd-Mon-YYYY''),',
'        ESTIMATED_QUARTER           = NVL(trim(to_char(to_date(:P10_ESTIMATED_DATE, ''dd-Mon-YYYY'' ) , ''Q'')) , :P10_ESTIMATED_QUARTER),',
'        ESTIMATED_YEAR              = NVL(trim(to_char(to_date(:P10_ESTIMATED_DATE, ''dd-Mon-YYYY'' ) , ''YYYY'')),:P10_ESTIMATED_YEAR),',
'        ESTIMATED_BUDGET_DEFINE     = ''Y'',',
'        ESTIMATED_BUDGET            = :P10_ESTIMATED_BUDGET_H,',
'        ESTIMATED_BUDGET_BRACKET_ID = (select  BRACKET_ID',
'                                        from dp_budget_brackets',
'                                        where :P10_ESTIMATED_BUDGET_H between MIN_VALUE and  MAX_VALUE)',
'        ',
'    where ITEM_ID = :P10_ITEM_ID;',
'    ',
'End If;',
'',
'if :P10_END_USER_ID != :P10_END_USER_ID_OLD',
'    Then',
'        -- Insert Participants',
'INSERT INTO dp_item_participants (item_id, person_id, role_id, status, start_date) ',
'VALUES (:P10_ITEM_ID, :P10_END_USER_ID,    241,    -- ROLE_id FOR OWNER (lOOKUP:DP_ITEM_PARTICIPANT_ROL)',
'        ''A'',sysdate);',
'',
'    update dp_item_participants set END_DATE = sysdate , status  = ''I'' where item_id = :P10_ITEM_ID and person_id = :P10_END_USER_ID_OLD;',
'    ',
'end if;',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(127514160981599145)
,p_process_success_message=>'Updated Successfully'
);
null;
wwv_flow_api.component_end;
end;
/
