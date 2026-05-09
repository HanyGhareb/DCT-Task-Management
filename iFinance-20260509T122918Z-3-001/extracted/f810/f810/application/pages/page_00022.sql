prompt --application/pages/page_00022
begin
--   Manifest
--     PAGE: 00022
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
 p_id=>22
,p_user_interface_id=>wwv_flow_api.id(12983317716762193)
,p_name=>'Allocate Payment Request'
,p_alias=>'ALLOCATE-PAYMENT-REQUEST'
,p_page_mode=>'MODAL'
,p_step_title=>'Allocate Payment Request'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240322104315'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(101808868282123376)
,p_plug_name=>'Param'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(101817850847152552)
,p_plug_name=>'Select Project, Task and Expenditure type '
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--accent1:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P22_ALLOCATE_BY'
,p_plug_display_when_cond2=>'P'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(101818289241152552)
,p_plug_name=>'Select GL Combination'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P22_ALLOCATE_BY'
,p_plug_display_when_cond2=>'G'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(133781796835455)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(101817850847152552)
,p_button_name=>'Insert_project'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(134164407835455)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(101817850847152552)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(137313032835453)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(101818289241152552)
,p_button_name=>'Close_gl'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(136892841835453)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(101818289241152552)
,p_button_name=>'Insert_GL'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(145118292835449)
,p_branch_name=>'Bank to 19'
,p_branch_action=>'f?p=&APP_ID.:19:&SESSION.::&DEBUG.::P19_ALLOCATE_BY:&P22_ALLOCATE_BY.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'PLSQL_EXPRESSION'
,p_branch_condition=>':P22_PAGE_FROM in (19 , 13)'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(134615231835455)
,p_name=>'P22_PROJECT_NUMBER'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(101817850847152552)
,p_prompt=>'Project'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct pb.PROJECT_NUMBER || ''('' || p.PROJECT_NAME || '')''  d, pb.PROJECT_NUMBER',
'from project_balances pb, project p',
'where pb.project_number = p.project_number ',
'and pb.accounting_year = EXTRACT(YEAR from sysdate)',
'and (pb.expenditure_type like ''4280%'' or pb.expenditure_type like ''415310%'')',
'and pb.fund_available > 0',
'order by pb.PROJECT_NUMBER;'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(134940692835455)
,p_name=>'P22_TASK_NUMBER'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(101817850847152552)
,p_prompt=>'Task'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct pb.TASK_NUMBER  d, pb.TASK_NUMBER',
'from project_balances pb',
'where pb.accounting_year = EXTRACT(YEAR from sysdate)',
'and pb.PROJECT_NUMBER = :P22_PROJECT_NUMBER',
'and (pb.expenditure_type like ''4280%'' or pb.expenditure_type like ''415310%'')',
'and pb.fund_available > 0',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P22_PROJECT_NUMBER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(135405212835455)
,p_name=>'P22_EXPENDITURE_TYPE'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(101817850847152552)
,p_prompt=>'Expenditure Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct pb.EXPENDITURE_TYPE d , pb.EXPENDITURE_TYPE',
'from project_balances pb',
'where pb.accounting_year = EXTRACT(YEAR from sysdate)',
'and pb.PROJECT_NUMBER = :P22_PROJECT_NUMBER',
'and pb.task_number = :P22_TASK_NUMBER',
'and (pb.expenditure_type like ''4280%'' or pb.expenditure_type like ''415310%'')',
'and pb.fund_available > 0',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P22_PROJECT_NUMBER,P22_TASK_NUMBER'
,p_ajax_items_to_submit=>'P22_EXPENDITURE_TYPE'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(135799869835454)
,p_name=>'P22_ALLOCATED_AMOUNT'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(101817850847152552)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Allocated Amount'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(136210676835454)
,p_name=>'P22_LINE_DESCRIPTION'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(101817850847152552)
,p_prompt=>'Line Description'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(137647611835453)
,p_name=>'P22_ALLOCATED_AMOUNT_GL'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(101818289241152552)
,p_prompt=>'Allocated Amount'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138083637835453)
,p_name=>'P22_LINE_DESCRIPTION_GL'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(101818289241152552)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138423717835452)
,p_name=>'P22_ENTITY_CODE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(101818289241152552)
,p_prompt=>'Entity Code'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct ENTITY_CODE d, ENTITY_CODE',
'from dct_gl_code_combinations_all',
'where ENTITY_CODE is not null;'))
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138906296835452)
,p_name=>'P22_COST_CENTER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(101818289241152552)
,p_prompt=>'Cost Center'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct COST_CENTER_CODE || '' ('' || COST_CENTER_DESCRIPTION ||'')'' d , COST_CENTER_CODE',
'from dct_gl_code_combinations_all',
'where ENTITY_CODE = :P22_ENTITY_CODE',
'--and STATUS = ''A''',
'order by 1;'))
,p_lov_cascade_parent_items=>'P22_ENTITY_CODE'
,p_ajax_optimize_refresh=>'Y'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139243134835452)
,p_name=>'P22_BUDGET'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(101818289241152552)
,p_item_default=>'1'
,p_prompt=>'Budget'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct BUDGET_CODE || '' ('' ||  BUDGET_GROUP_DESCRIPTION || '')'' , BUDGET_CODE',
'from dct_gl_code_combinations_all',
'where ENTITY_CODE = :P22_ENTITY_CODE',
'and COST_CENTER_CODE = :P22_COST_CENTER',
'--and STATUS = ''A''',
'order by 1'))
,p_lov_cascade_parent_items=>'P22_COST_CENTER'
,p_ajax_items_to_submit=>'P22_ENTITY_CODE,P22_COST_CENTER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139672393835452)
,p_name=>'P22_ACCOUNT'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(101818289241152552)
,p_prompt=>'Account'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct ACCOUNT_CODE || '' ('' ||  ACCOUNT_DESCRIPTION || '')'' , ACCOUNT_CODE',
'from dct_gl_code_combinations_all',
'where ENTITY_CODE = :P22_ENTITY_CODE',
'and COST_CENTER_CODE = :P22_COST_CENTER',
'and BUDGET_CODE = :P22_BUDGET',
'--and STATUS = ''A''',
'and ACCOUNT_TYPE = ''Expense''',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P22_ENTITY_CODE,P22_COST_CENTER,P22_BUDGET'
,p_ajax_optimize_refresh=>'Y'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140068380835452)
,p_name=>'P22_ACTIVITY'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(101818289241152552)
,p_item_default=>'000000'
,p_prompt=>'Activity'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct ACTIVITY_CODE || '' ('' ||  ACTIVITY_DESCRIPTION || '')'' , ACTIVITY_CODE',
'from dct_gl_code_combinations_all',
'where ENTITY_CODE = :P22_ENTITY_CODE',
'and COST_CENTER_CODE = :P22_COST_CENTER',
'and BUDGET_CODE = :P22_BUDGET',
'and ACCOUNT_CODE = :P22_ACCOUNT',
'--and STATUS = ''A''',
'order by 1;'))
,p_lov_cascade_parent_items=>'P22_ENTITY_CODE,P22_COST_CENTER,P22_BUDGET,P22_ACCOUNT'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140494349835452)
,p_name=>'P22_FUTURE1'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(101818289241152552)
,p_item_default=>'451000'
,p_prompt=>'Future1'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct FUTURE1 || '' ('' ||  FUTURE1_DESCRIPTION || '')'' , FUTURE1',
'from dct_gl_code_combinations_all',
'where ENTITY_CODE = :P22_ENTITY_CODE',
'and COST_CENTER_CODE = :P22_COST_CENTER',
'and BUDGET_CODE = :P22_BUDGET',
'and ACCOUNT_CODE = :P22_ACCOUNT',
'and ACTIVITY_CODE = :P22_ACTIVITY',
'--and STATUS = ''A''',
'order by 1;'))
,p_lov_cascade_parent_items=>'P22_ENTITY_CODE,P22_COST_CENTER,P22_BUDGET,P22_ACCOUNT,P22_ACTIVITY'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140838237835451)
,p_name=>'P22_FUTURE2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(101818289241152552)
,p_prompt=>'Future2'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct FUTURE2 || '' ('' ||  FUTURE2_DESCRIPTION || '')'' , FUTURE2',
'from dct_gl_code_combinations_all',
'where ENTITY_CODE = :P22_ENTITY_CODE',
'and COST_CENTER_CODE = :P22_COST_CENTER',
'and BUDGET_CODE = :P22_BUDGET',
'and ACCOUNT_CODE = :P22_ACCOUNT',
'and ACTIVITY_CODE = :P22_ACTIVITY',
'and FUTURE1 = :P22_FUTURE1',
'--and STATUS = ''A''',
'order by 1;'))
,p_lov_cascade_parent_items=>'P22_ENTITY_CODE,P22_COST_CENTER,P22_BUDGET,P22_ACCOUNT,P22_ACTIVITY,P22_FUTURE1'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141532498835451)
,p_name=>'P22_ALLOCATE_BY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(101808868282123376)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141981935835451)
,p_name=>'P22_REQUEST_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(101808868282123376)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(93509911361278442)
,p_name=>'P22_PAGE_FROM'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(101808868282123376)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(143141995835450)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(134164407835455)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(143666447835450)
,p_event_id=>wwv_flow_api.id(143141995835450)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(144104558835450)
,p_name=>'Close_gl DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(137313032835453)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144570928835449)
,p_event_id=>wwv_flow_api.id(144104558835450)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(113198199842187627)
,p_process_sequence=>5
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Insert Project'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'INSERT INTO mission_distributions (',
'    request_id,',
'    entity_code,',
'    cost_center,',
'    budget_group_code,',
'    gl_account,',
'    activity,',
'    future1,',
'    future2,',
'    project_number,',
'    task_number,',
'    expenditure_type,',
'    amount',
'--    comments',
') VALUES (',
'    :P22_REQUEST_ID,',
'    ''451'',',
'    PROJECTS_UTIL.task_cost_center(:P22_PROJECT_NUMBER ,:P22_TASK_NUMBER ) ,  -- t.COST_CENTER, ',
'    PROJECTS_UTIL.task_budget_code(:P22_PROJECT_NUMBER ,:P22_TASK_NUMBER ) ,  --t.BUDGET_GROUP_CODE,',
'    PROJECTS_UTIL.expenditure_type_gl_account(:P22_PROJECT_NUMBER ,:P22_TASK_NUMBER , :P22_EXPENDITURE_TYPE) ,  --e.gl_account, ',
'    PROJECTS_UTIL.task_activity(:P22_PROJECT_NUMBER ,:P22_TASK_NUMBER ) ,  --t.ACTIVITY, ',
'    PROJECTS_UTIL.task_future1(:P22_PROJECT_NUMBER ,:P22_TASK_NUMBER ) ,  --t.FUTURE1, ',
'    PROJECTS_UTIL.task_future2(:P22_PROJECT_NUMBER ,:P22_TASK_NUMBER ) ,  --t.FUTURE2, ',
'    :P22_PROJECT_NUMBER,',
'    :P22_TASK_NUMBER,',
'    :P22_EXPENDITURE_TYPE,',
'    :P19_AMOUNT_H    --     :P22_ALLOCATED_AMOUNT,',
'--    :P22_LINE_DESCRIPTION',
') ;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(133781796835455)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(142783365835450)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Insert Gl Details'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'INSERT INTO mission_distributions (',
'    request_id,',
'    entity_code,',
'    cost_center,',
'    budget_group_code,',
'    gl_account,',
'    activity,',
'    future1,',
'    future2,',
'    amount,',
'    comments',
') VALUES',
'    (',
'    :P19_REQUEST_ID,',
'    :P22_ENTITY_CODE,',
'    :P22_COST_CENTER, ',
'    :P22_BUDGET,',
'    :P22_ACCOUNT, ',
'    :P22_ACTIVITY, ',
'    :P22_FUTURE1, ',
'    :P22_FUTURE2,',
'    :P22_ALLOCATED_AMOUNT_GL,',
'    :P22_LINE_DESCRIPTION_GL',
'); '))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(136892841835453)
);
wwv_flow_api.component_end;
end;
/
