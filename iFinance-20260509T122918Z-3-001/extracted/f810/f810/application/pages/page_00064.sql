prompt --application/pages/page_00064
begin
--   Manifest
--     PAGE: 00064
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
 p_id=>64
,p_user_interface_id=>wwv_flow_api.id(12983317716762193)
,p_name=>'Update Mission Distribution Line'
,p_alias=>'UPDATE-MISSION-DISTRIBUTION-LINE'
,p_page_mode=>'MODAL'
,p_step_title=>'Update Mission Distribution Line'
,p_allow_duplicate_submissions=>'N'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240305102523'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(94789886403956228)
,p_plug_name=>'Project Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(307367976449771814)
,p_plug_name=>'Select Project, Task and Expenditure type '
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--accent1:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(307624942745815281)
,p_plug_name=>'Select GL Combination'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--accent1:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(94939619978612287)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(307367976449771814)
,p_button_name=>'update_project'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Update'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_icon_css_classes=>'fa-save-as'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(95196455558655753)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(307624942745815281)
,p_button_name=>'Update_GL'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Update'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_icon_css_classes=>'fa-save-as'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(94940007451612288)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(307367976449771814)
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
 p_id=>wwv_flow_api.id(95196043001655753)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(307624942745815281)
,p_button_name=>'Close_gl'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(94792047269956250)
,p_branch_name=>'Go to &PAGE_FROM.'
,p_branch_action=>'f?p=&APP_ID.:&P64_PAGE_FROM.:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(94789999118956229)
,p_name=>'P64_ID'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(94789886403956228)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(94940363679612288)
,p_name=>'P64_PROJECT_NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(307367976449771814)
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
 p_id=>wwv_flow_api.id(94940786750612289)
,p_name=>'P64_TASK_NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(307367976449771814)
,p_prompt=>'Task'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct pb.TASK_NUMBER  d, pb.TASK_NUMBER',
'from project_balances pb',
'where pb.accounting_year = EXTRACT(YEAR from sysdate)',
'and pb.PROJECT_NUMBER = :P64_PROJECT_NUMBER',
'and (pb.expenditure_type like ''4280%'' or pb.expenditure_type like ''415310%'')',
'and pb.fund_available > 0',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P64_PROJECT_NUMBER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(94941206718612289)
,p_name=>'P64_EXPENDITURE_TYPE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(307367976449771814)
,p_prompt=>'Expenditure Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct pb.EXPENDITURE_TYPE d , pb.EXPENDITURE_TYPE',
'from project_balances pb',
'where pb.accounting_year = EXTRACT(YEAR from sysdate)',
'and pb.PROJECT_NUMBER = :P64_PROJECT_NUMBER',
'and pb.task_number = :P64_TASK_NUMBER',
'and (pb.expenditure_type like ''4280%'' or pb.expenditure_type like ''415310%'')',
'and pb.fund_available > 0',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P64_PROJECT_NUMBER,P64_TASK_NUMBER'
,p_ajax_items_to_submit=>'P64_EXPENDITURE_TYPE'
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
 p_id=>wwv_flow_api.id(94941581540612290)
,p_name=>'P64_ALLOCATED_AMOUNT'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(307367976449771814)
,p_item_default=>'MISSION_UTIL.get_mission_amount(:P64_request_id)'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'Allocated Amount'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(94941981425612290)
,p_name=>'P64_LINE_DESCRIPTION'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(307367976449771814)
,p_prompt=>'Comment'
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
 p_id=>wwv_flow_api.id(95194930949653664)
,p_name=>'P64_REQUEST_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(94789886403956228)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95195384358653664)
,p_name=>'P64_PAGE_FROM'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(94789886403956228)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95196842686655753)
,p_name=>'P64_ALLOCATED_AMOUNT_GL'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(307624942745815281)
,p_item_default=>'MISSION_UTIL.get_mission_amount(:P64_request_id)'
,p_item_default_type=>'PLSQL_EXPRESSION'
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
 p_id=>wwv_flow_api.id(95197249499655754)
,p_name=>'P64_ENTITY_CODE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(307624942745815281)
,p_prompt=>'Entity Code'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct ENTITY_CODE d, ENTITY_CODE',
'from dct_gl_code_combinations_all',
'where ENTITY_CODE is not null;'))
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95197665737655754)
,p_name=>'P64_COST_CENTER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(307624942745815281)
,p_prompt=>'Cost Center'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct COST_CENTER_CODE || '' ('' || COST_CENTER_DESCRIPTION ||'')'' d , COST_CENTER_CODE',
'from dct_gl_code_combinations_all',
'where ENTITY_CODE = :P64_ENTITY_CODE',
'and STATUS = ''A''',
'order by 1;'))
,p_lov_cascade_parent_items=>'P64_ENTITY_CODE'
,p_ajax_optimize_refresh=>'Y'
,p_cSize=>30
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
 p_id=>wwv_flow_api.id(95198092933655754)
,p_name=>'P64_BUDGET'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(307624942745815281)
,p_item_default=>'1'
,p_prompt=>'Budget'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct BUDGET_CODE || '' ('' ||  BUDGET_GROUP_DESCRIPTION || '')'' , BUDGET_CODE',
'from dct_gl_code_combinations_all',
'where ENTITY_CODE = :P64_ENTITY_CODE',
'and COST_CENTER_CODE = :P64_COST_CENTER',
'and STATUS = ''A''',
'order by 1'))
,p_lov_cascade_parent_items=>'P64_COST_CENTER'
,p_ajax_items_to_submit=>'P64_ENTITY_CODE,P64_COST_CENTER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95198467703655754)
,p_name=>'P64_ACCOUNT'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(307624942745815281)
,p_prompt=>'Account'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct ACCOUNT_CODE || '' ('' ||  ACCOUNT_DESCRIPTION || '')'' , ACCOUNT_CODE',
'from dct_gl_code_combinations_all',
'where ENTITY_CODE = :P64_ENTITY_CODE',
'and COST_CENTER_CODE = :P64_COST_CENTER',
'and BUDGET_CODE = :P64_BUDGET',
'and STATUS = ''A''',
'and ACCOUNT_TYPE = ''Expense''',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P64_ENTITY_CODE,P64_COST_CENTER,P64_BUDGET'
,p_ajax_optimize_refresh=>'Y'
,p_cSize=>30
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
 p_id=>wwv_flow_api.id(95198858392655755)
,p_name=>'P64_ACTIVITY'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(307624942745815281)
,p_item_default=>'000000'
,p_prompt=>'Activity'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct ACTIVITY_CODE || '' ('' ||  ACTIVITY_DESCRIPTION || '')'' , ACTIVITY_CODE',
'from dct_gl_code_combinations_all',
'where ENTITY_CODE = :P64_ENTITY_CODE',
'and COST_CENTER_CODE = :P64_COST_CENTER',
'and BUDGET_CODE = :P64_BUDGET',
'and ACCOUNT_CODE = :P64_ACCOUNT',
'and STATUS = ''A''',
'order by 1;'))
,p_lov_cascade_parent_items=>'P64_ENTITY_CODE,P64_COST_CENTER,P64_BUDGET,P64_ACCOUNT'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95199251142655755)
,p_name=>'P64_FUTURE1'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(307624942745815281)
,p_item_default=>'451000'
,p_prompt=>'Future1'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct FUTURE1 || '' ('' ||  FUTURE1_DESCRIPTION || '')'' , FUTURE1',
'from dct_gl_code_combinations_all',
'where ENTITY_CODE = :P64_ENTITY_CODE',
'and COST_CENTER_CODE = :P64_COST_CENTER',
'and BUDGET_CODE = :P64_BUDGET',
'and ACCOUNT_CODE = :P64_ACCOUNT',
'and ACTIVITY_CODE = :P64_ACTIVITY',
'and STATUS = ''A''',
'order by 1;'))
,p_lov_cascade_parent_items=>'P64_ENTITY_CODE,P64_COST_CENTER,P64_BUDGET,P64_ACCOUNT,P64_ACTIVITY'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95199679546655755)
,p_name=>'P64_FUTURE2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(307624942745815281)
,p_prompt=>'Future2'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct FUTURE2 || '' ('' ||  FUTURE2_DESCRIPTION || '')'' , FUTURE2',
'from dct_gl_code_combinations_all',
'where ENTITY_CODE = :P64_ENTITY_CODE',
'and COST_CENTER_CODE = :P64_COST_CENTER',
'and BUDGET_CODE = :P64_BUDGET',
'and ACCOUNT_CODE = :P64_ACCOUNT',
'and ACTIVITY_CODE = :P64_ACTIVITY',
'and FUTURE1 = :P64_FUTURE1',
'and STATUS = ''A''',
'order by 1;'))
,p_lov_cascade_parent_items=>'P64_ENTITY_CODE,P64_COST_CENTER,P64_BUDGET,P64_ACCOUNT,P64_ACTIVITY,P64_FUTURE1'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95200069140655755)
,p_name=>'P64_LINE_DESCRIPTION_GL'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(307624942745815281)
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
 p_id=>wwv_flow_api.id(95206800567979345)
,p_name=>'P64_ALLOCATED_BY'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(94789886403956228)
,p_item_default=>'P'
,p_prompt=>'Allocate By'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Project Level;P,GL Level;G'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95212703416031120)
,p_name=>'P64_ELIGIBLE_AMOUNT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(94789886403956228)
,p_prompt=>'Eligible Amount '
,p_source=>'to_char(MISSION_UTIL.get_mission_amount(:P64_request_id) , ''99,999,999,999.99'')'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959735177762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95212958016035640)
,p_name=>'P64_ALLOCATED'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(94789886403956228)
,p_prompt=>'Allocated'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(nvl(Sum(AMOUNT),0) , ''99,999,999,999.99'')) amount',
'from mission_distributions',
'where REQUEST_ID = :P64_REQUEST_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(12959735177762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(94790259226956232)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(94940007451612288)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(94790340965956233)
,p_event_id=>wwv_flow_api.id(94790259226956232)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(94790700138956236)
,p_name=>'Gl Close DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(95196043001655753)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(94790812137956237)
,p_event_id=>wwv_flow_api.id(94790700138956236)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(94790823913956238)
,p_name=>'show allocation DA'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P64_ALLOCATED_BY'
,p_condition_element=>'P64_ALLOCATED_BY'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'P'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(94790950644956239)
,p_event_id=>wwv_flow_api.id(94790823913956238)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(307367976449771814)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(94791230130956242)
,p_event_id=>wwv_flow_api.id(94790823913956238)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(307624942745815281)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(94791037827956240)
,p_event_id=>wwv_flow_api.id(94790823913956238)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(307624942745815281)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(94791187295956241)
,p_event_id=>wwv_flow_api.id(94790823913956238)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(307367976449771814)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(94790155060956231)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get project distribution details'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'       PROJECT_NUMBER,',
'       TASK_NUMBER,',
'       EXPENDITURE_TYPE,',
'       AMOUNT,',
'       COMMENTS',
'into ',
'    :P64_PROJECT_NUMBER,',
'    :P64_TASK_NUMBER,',
'    :P64_EXPENDITURE_TYPE,',
'    :P64_ALLOCATED_AMOUNT,',
'    :P64_LINE_DESCRIPTION',
'  from MISSION_DISTRIBUTIONS',
'  where ID = :P64_ID;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(94790459979956234)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update project distribution'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'IF :P64_PROJECT_NUMBER is null or ',
'	:P64_TASK_NUMBER		is null or ',
'	:P64_EXPENDITURE_TYPE	is null or',
'	:P64_ALLOCATED_AMOUNT 	is null',
'        Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please Select project number, Task Number and expenditure type. ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'		',
'		',
'for rec in (select',
'    t.COST_CENTER, ',
'    t.BUDGET_GROUP_CODE,',
'    e.gl_account, ',
'    t.ACTIVITY, ',
'    t.FUTURE1, ',
'    t.FUTURE2, ',
'    :P22_PROJECT_NUMBER',
'from task t, expenditure e',
'where t.project_number = e.project_number',
'and t.task_number = e.task_number',
'and t.project_number = :P64_PROJECT_NUMBER',
'and t.task_number = :P64_TASK_NUMBER',
'and e.expenditure_type = :P64_EXPENDITURE_TYPE )',
'',
'LOOP',
'update MISSION_DISTRIBUTIONS d',
'set COST_CENTER = rec.COST_CENTER,',
'    BUDGET_GROUP_CODE = rec.BUDGET_GROUP_CODE,',
'    GL_ACCOUNT= rec.gl_account,',
'    ACTIVITY= rec.ACTIVITY,',
'    FUTURE1= rec.FUTURE1,',
'    FUTURE2= rec.FUTURE2,',
'    PROJECT_NUMBER= :P64_PROJECT_NUMBER,',
'    TASK_NUMBER= :P64_TASK_NUMBER,',
'    EXPENDITURE_TYPE= :P64_EXPENDITURE_TYPE,',
'    AMOUNT= :P64_ALLOCATED_AMOUNT,',
'    COMMENTS= :P64_LINE_DESCRIPTION',
'  where ID = :P64_ID;',
'',
'End loop;',
'',
'End if;',
'End;'))
,p_process_error_message=>'Budget Allocated Fail'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(94939619978612287)
,p_process_success_message=>'Budget Allocated Successfully'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(94790526765956235)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update GL distribution'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'IF :P64_COST_CENTER is null or ',
'	:P64_BUDGET		is null or ',
'	:P64_ACCOUNT	is null or',
'	:P64_ACTIVITY	is null or ',
'	:P64_FUTURE1	is null or ',
'	:P64_FUTURE2	is null or ',
'	:P64_ALLOCATED_AMOUNT_GL is null',
'        Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please Select the full GL Account Combination. ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'		',
'		',
'update MISSION_DISTRIBUTIONS d',
'set COST_CENTER = :P64_COST_CENTER,',
'    BUDGET_GROUP_CODE = :P64_BUDGET,',
'    GL_ACCOUNT= :P64_ACCOUNT,',
'    ACTIVITY= :P64_ACTIVITY,',
'    FUTURE1= :P64_FUTURE1,',
'    FUTURE2= :P64_FUTURE2,',
'    PROJECT_NUMBER= NULL,',
'    TASK_NUMBER= NULL,',
'    EXPENDITURE_TYPE= NULL,',
'    AMOUNT= :P64_ALLOCATED_AMOUNT_GL,',
'    COMMENTS= :P64_LINE_DESCRIPTION_GL',
'  where ID = :P64_ID;',
'',
'End if;',
'End;',
''))
,p_process_error_message=>'Budget Allocated Fail'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(95196455558655753)
,p_process_success_message=>'Budget Allocated Successfully'
);
wwv_flow_api.component_end;
end;
/
