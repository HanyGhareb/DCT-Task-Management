prompt --application/pages/page_00008
begin
--   Manifest
--     PAGE: 00008
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>116
,p_default_id_offset=>100034894930602818
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>8
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Allocate Payment Request'
,p_alias=>'ALLOCATE-PAYMENT-REQUEST'
,p_page_mode=>'MODAL'
,p_step_title=>'Allocate Payment Request'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220409184225'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1640759781685102)
,p_plug_name=>'Param'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1649742346714278)
,p_plug_name=>'Select Project, Task and Expenditure type '
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P8_ALLOCATE_BY'
,p_plug_display_when_cond2=>'P'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1650180740714278)
,p_plug_name=>'Select GL Combination'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P8_ALLOCATE_BY'
,p_plug_display_when_cond2=>'G'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1642149023685116)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(1650180740714278)
,p_button_name=>'Insert_GL'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Add'
,p_button_position=>'BELOW_BOX'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1641565470685110)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(1649742346714278)
,p_button_name=>'Insert_project'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1641651404685111)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(1649742346714278)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1643578350685130)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(1650180740714278)
,p_button_name=>'Close_gl'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(1706589023397883)
,p_branch_name=>'Bank to 7'
,p_branch_action=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.::P7_ALLOCATE_BY:&P8_ALLOCATE_BY.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1640854534685103)
,p_name=>'P8_ALLOCATE_BY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(1640759781685102)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1641103483685105)
,p_name=>'P8_PROJECT_NUMBER'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(1649742346714278)
,p_prompt=>'Project'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct PROJECT_NUMBER || '' ('' ||  PROJECT_NAME || '')'' , PROJECT_NUMBER',
'from project',
'where PROJECT_TYPE in (''Operational'' , ''Non GL Integrated'') ',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1641279461685107)
,p_name=>'P8_TASK_NUMBER'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(1649742346714278)
,p_prompt=>'Task'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct TASK_NUMBER d , TASK_NUMBER',
'from expenditure',
'where PROJECT_NUMBER = :P8_PROJECT_NUMBER',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P8_PROJECT_NUMBER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1641358765685108)
,p_name=>'P8_EXPENDITURE_TYPE'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(1649742346714278)
,p_prompt=>'Expenditure Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct EXPENDITURE_TYPE d , EXPENDITURE_TYPE',
'from expenditure',
'where PROJECT_NUMBER = :P8_PROJECT_NUMBER',
'and task_number = :P8_TASK_NUMBER',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P8_PROJECT_NUMBER,P8_TASK_NUMBER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1641497880685109)
,p_name=>'P8_ALLOCATED_AMOUNT'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(1649742346714278)
,p_prompt=>'Allocated Amount'
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
 p_id=>wwv_flow_api.id(1642490798685119)
,p_name=>'P8_PAYMENT_REQUEST_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(1640759781685102)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1642515095685120)
,p_name=>'P8_LINE_DESCRIPTION'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(1649742346714278)
,p_prompt=>'Line Description'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1642644132685121)
,p_name=>'P8_ENTITY_CODE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(1650180740714278)
,p_prompt=>'Entity Code'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct ENTITY_CODE d, ENTITY_CODE',
'from dct_gl_code_combinations_all'))
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1642764385685122)
,p_name=>'P8_COST_CENTER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(1650180740714278)
,p_prompt=>'Cost Center'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct COST_CENTER_CODE || '' ('' || COST_CENTER_DESCRIPTION ||'')'' d , COST_CENTER_CODE',
'from dct_gl_code_combinations_all',
'where ENTITY_CODE = :P8_ENTITY_CODE',
'and STATUS = ''A''',
'order by 1;'))
,p_lov_cascade_parent_items=>'P8_ENTITY_CODE'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1642891310685123)
,p_name=>'P8_BUDGET'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(1650180740714278)
,p_item_default=>'1'
,p_prompt=>'Budget'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct BUDGET_CODE || '' ('' ||  BUDGET_GROUP_DESCRIPTION || '')'' , BUDGET_CODE',
'from dct_gl_code_combinations_all',
'where ENTITY_CODE = :P8_ENTITY_CODE',
'and COST_CENTER_CODE = :P8_COST_CENTER',
'and STATUS = ''A''',
'order by 1'))
,p_lov_cascade_parent_items=>'P8_COST_CENTER'
,p_ajax_items_to_submit=>'P8_ENTITY_CODE,P8_COST_CENTER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1642982416685124)
,p_name=>'P8_ACCOUNT'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(1650180740714278)
,p_prompt=>'Account'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct ACCOUNT_CODE || '' ('' ||  ACCOUNT_DESCRIPTION || '')'' , ACCOUNT_CODE',
'from dct_gl_code_combinations_all',
'where ENTITY_CODE = :P8_ENTITY_CODE',
'and COST_CENTER_CODE = :P8_COST_CENTER',
'and BUDGET_CODE = :P8_BUDGET',
'and STATUS = ''A''',
'and ACCOUNT_TYPE = ''Expense''',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P8_ENTITY_CODE,P8_COST_CENTER,P8_BUDGET'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1643103592685125)
,p_name=>'P8_ACTIVITY'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(1650180740714278)
,p_item_default=>'000000'
,p_prompt=>'Activity'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct ACTIVITY_CODE || '' ('' ||  ACTIVITY_DESCRIPTION || '')'' , ACTIVITY_CODE',
'from dct_gl_code_combinations_all',
'where ENTITY_CODE = :P8_ENTITY_CODE',
'and COST_CENTER_CODE = :P8_COST_CENTER',
'and BUDGET_CODE = :P8_BUDGET',
'and ACCOUNT_CODE = :P8_ACCOUNT',
'and STATUS = ''A''',
'order by 1;'))
,p_lov_cascade_parent_items=>'P8_ENTITY_CODE,P8_COST_CENTER,P8_BUDGET,P8_ACCOUNT'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1643188458685126)
,p_name=>'P8_FUTURE1'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(1650180740714278)
,p_item_default=>'451000'
,p_prompt=>'Future1'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct FUTURE1 || '' ('' ||  FUTURE1_DESCRIPTION || '')'' , FUTURE1',
'from dct_gl_code_combinations_all',
'where ENTITY_CODE = :P8_ENTITY_CODE',
'and COST_CENTER_CODE = :P8_COST_CENTER',
'and BUDGET_CODE = :P8_BUDGET',
'and ACCOUNT_CODE = :P8_ACCOUNT',
'and ACTIVITY_CODE = :P8_ACTIVITY',
'and STATUS = ''A''',
'order by 1;'))
,p_lov_cascade_parent_items=>'P8_ENTITY_CODE,P8_COST_CENTER,P8_BUDGET,P8_ACCOUNT,P8_ACTIVITY'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1643237458685127)
,p_name=>'P8_FUTURE2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(1650180740714278)
,p_prompt=>'Future2'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct FUTURE2 || '' ('' ||  FUTURE2_DESCRIPTION || '')'' , FUTURE2',
'from dct_gl_code_combinations_all',
'where ENTITY_CODE = :P8_ENTITY_CODE',
'and COST_CENTER_CODE = :P8_COST_CENTER',
'and BUDGET_CODE = :P8_BUDGET',
'and ACCOUNT_CODE = :P8_ACCOUNT',
'and ACTIVITY_CODE = :P8_ACTIVITY',
'and FUTURE1 = :P8_FUTURE1',
'and STATUS = ''A''',
'order by 1;'))
,p_lov_cascade_parent_items=>'P8_ENTITY_CODE,P8_COST_CENTER,P8_BUDGET,P8_ACCOUNT,P8_ACTIVITY,P8_FUTURE1'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1643309296685128)
,p_name=>'P8_ALLOCATED_AMOUNT_GL'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(1650180740714278)
,p_prompt=>'Allocated Amount'
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
 p_id=>wwv_flow_api.id(1643455777685129)
,p_name=>'P8_LINE_DESCRIPTION_GL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(1650180740714278)
,p_prompt=>'Line Description'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1641727505685112)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(1641651404685111)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1641814662685113)
,p_event_id=>wwv_flow_api.id(1641727505685112)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1643639838685131)
,p_name=>'Close_gl DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(1643578350685130)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1643779808685132)
,p_event_id=>wwv_flow_api.id(1643639838685131)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1641965453685114)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Insert Project details'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'INSERT INTO payment_request_lines (',
'    payment_request_id,',
'    po_available_yn,',
'    amount,',
'    line_description,',
'    entity_code,',
'    cost_center,',
'    budget_group_code,',
'    gl_account,',
'    activity,',
'    future1,',
'    future2,',
'    project_number,',
'    task_number,',
'    expenditure_type',
') select',
'    :P8_PAYMENT_REQUEST_ID,',
'    ''N'',',
'    :P8_ALLOCATED_AMOUNT,',
'    :P8_LINE_DESCRIPTION,',
'    ''451'',',
'    t.COST_CENTER, ',
'    t.BUDGET_GROUP_CODE,',
'    e.gl_account, ',
'    t.ACTIVITY, ',
'    t.FUTURE1, ',
'    t.FUTURE2, ',
'    :P8_PROJECT_NUMBER,',
'    :P8_TASK_NUMBER,',
'    :P8_EXPENDITURE_TYPE',
'from task t, expenditure e',
'where t.project_number = e.project_number',
'and t.task_number = e.task_number',
'and t.project_number = :P8_PROJECT_NUMBER',
'and t.task_number = :P8_TASK_NUMBER',
'and e.expenditure_type = :P8_EXPENDITURE_TYPE ;    '))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(1641565470685110)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1642063096685115)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Insert Gl Details'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'INSERT INTO payment_request_lines (',
'    payment_request_id,',
'    po_available_yn,',
'    amount,',
'    line_description,',
'    entity_code,',
'    cost_center,',
'    budget_group_code,',
'    gl_account,',
'    activity,',
'    future1,',
'    future2',
') VALUES',
'    (',
'    :P8_PAYMENT_REQUEST_ID,',
'    ''N'',',
'    :P8_ALLOCATED_AMOUNT_GL,',
'    :P8_LINE_DESCRIPTION_GL,',
'    :P8_ENTITY_CODE,',
'    :P8_COST_CENTER, ',
'    :P8_BUDGET,',
'    :P8_ACCOUNT, ',
'    :P8_ACTIVITY, ',
'    :P8_FUTURE1, ',
'    :P8_FUTURE2',
');    ',
'    '))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(1642149023685116)
);
wwv_flow_api.component_end;
end;
/
