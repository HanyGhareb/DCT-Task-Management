prompt --application/pages/page_00108
begin
--   Manifest
--     PAGE: 00108
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
 p_id=>108
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Add Project / Task to Cost Center Plan'
,p_alias=>'ADD-PROJECT-TASK-TO-COST-CENTER-PLAN'
,p_page_mode=>'MODAL'
,p_step_title=>'Add Project / Task to Cost Center Plan'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230613111300'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(44493418403918127)
,p_plug_name=>'Hidden'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(44492983908918127)
,p_plug_name=>'Select Project, Task and Expenditure Type to Add'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(44491464127903325)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noBorder'
,p_plug_template=>wwv_flow_api.id(99731046805410735)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(44491428769903324)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(44491464127903325)
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
 p_id=>wwv_flow_api.id(44491330802903323)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(44491464127903325)
,p_button_name=>'Add'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_icon_css_classes=>'fa-save'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(45323309368071984)
,p_name=>'P108_PLAN_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(44493418403918127)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(45323212314071983)
,p_name=>'P108_PROPOSAL_YEAR'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(44493418403918127)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(44492032537903331)
,p_name=>'P108_PROJECT'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(44492983908918127)
,p_prompt=>'Project Number'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct PROJECT_D, PROJECT_R',
' from(',
'  select PROJECT_NUMBER                             ||',
'         '' (''                                       ||',
'         PROJECTS_UTIL.project_name(PROJECT_NUMBER) ||',
'         '')''                        project_d                ',
'         , PROJECT_NUMBER project_r',
'  from task',
'  where cost_center = :P108_COST_CENTER)',
'  ORDER BY 2'))
,p_lov_display_null=>'YES'
,p_cSize=>100
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(44491957323903330)
,p_name=>'P108_TASK'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(44492983908918127)
,p_prompt=>'Task Number'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'  select   TASK_NUMBER          ||',
'            '' (Future2: ''       || ',
'--            COST_CENTER         ||',
'--            ''-''                 ||',
'            FUTURE2             ||',
'            '')''            task_number ',
'    , task_number task_number_r',
'  from task',
'  where cost_center = :P108_COST_CENTER',
'  and project_number = :P108_PROJECT',
'  ORDER BY 1;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P108_PROJECT'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(44491919792903329)
,p_name=>'P108_COST_CENTER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(44493418403918127)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(44491543309903326)
,p_name=>'P108_EXPENDITURE_TYPE_A'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(44492983908918127)
,p_prompt=>'Expenditure Type (All)'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct EXPENDITURE_TYPE  , EXPENDITURE_TYPE d',
'  from expenditure',
'  order by 1 desc'))
,p_lov_display_null=>'YES'
,p_cSize=>200
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(44491006440903320)
,p_name=>'P108_EXPENDITURE_TYPE_P'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(44492983908918127)
,p_prompt=>'Expenditure Type (Project)'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select EXPENDITURE_TYPE , EXPENDITURE_TYPE D',
'  from expenditures_v',
'  where project_number = :P108_PROJECT',
'  and task_number = :P108_TASK'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P108_PROJECT,P108_TASK'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38089395437487396)
,p_name=>'P108_CC_PLAN_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(44493418403918127)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(44491197512903322)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(44491428769903324)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(44491085921903321)
,p_event_id=>wwv_flow_api.id(44491197512903322)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(45323050434071982)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get Plan Details'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select BUDGET_PROPOSAL_PKG.PROPOSAL_YEAR(:P108_PLAN_ID)',
'into :P108_PROPOSAL_YEAR',
'from dual;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(44490906907903319)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Insert Project and Task to Cost Center Plan'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'INSERT INTO budget_proposal_projects_plans (',
'    plan_id,',
'    sector_id,',
'    project_number,',
'    task_number,',
'    expenditure_type,',
'    entity_code,',
'    cost_center,',
'    budget_groub_code,',
'    gl_account,',
'    activity,',
'    future1,',
'    future2,',
'',
'    status,',
'    plan_version,',
'    PROPOSAL_YEAR,',
'    ACTUAL_Y1,',
'    ACTUAL_Y2,',
'    ACTUAL_Y3,',
'    ACTUAL_Y4,',
'    ACTUAL_Y5,',
'    new_line,',
'    CC_PLAN_ID',
') ',
'    values(',
'    :P108_PLAN_ID,',
'    :P97_SECTOR_ID,',
'    :P108_PROJECT,',
'    :P108_TASK,',
'    nvl(:P108_EXPENDITURE_TYPE_P,:P108_EXPENDITURE_TYPE_A),',
'    ''451'',',
'    PROJECTS_UTIL.task_cost_center(:P108_PROJECT ,:P108_TASK ),',
'    PROJECTS_UTIL.task_budget_code(:P108_PROJECT ,:P108_TASK ),',
'    PROJECTS_UTIL.expenditure_type_gl_account(:P108_PROJECT ,:P108_TASK,nvl(:P108_EXPENDITURE_TYPE_P,:P108_EXPENDITURE_TYPE_A) ),',
'    PROJECTS_UTIL.task_activity(:P108_PROJECT ,:P108_TASK ),',
'    PROJECTS_UTIL.task_future1(:P108_PROJECT ,:P108_TASK ),',
'    PROJECTS_UTIL.task_future2(:P108_PROJECT ,:P108_TASK ),',
'   ''Available'',',
'   BUDGET_PROPOSAL_PKG.plan_version(:P108_PLAN_ID),',
'   BUDGET_PROPOSAL_PKG.PROPOSAL_YEAR(:P97_PLAN_ID),',
'   projects_util.EXPENDITURE_BALANCE(:P108_PROJECT ,:P108_TASK,nvl(:P108_EXPENDITURE_TYPE_P,:P108_EXPENDITURE_TYPE_A), :P108_PROPOSAL_YEAR - 1 , ''A''),      -- current_budget year',
'   projects_util.EXPENDITURE_BALANCE(:P108_PROJECT ,:P108_TASK,nvl(:P108_EXPENDITURE_TYPE_P,:P108_EXPENDITURE_TYPE_A), :P108_PROPOSAL_YEAR - 2 , ''A''),',
'   projects_util.EXPENDITURE_BALANCE(:P108_PROJECT ,:P108_TASK,nvl(:P108_EXPENDITURE_TYPE_P,:P108_EXPENDITURE_TYPE_A), :P108_PROPOSAL_YEAR - 3 , ''A''),',
'   projects_util.EXPENDITURE_BALANCE(:P108_PROJECT ,:P108_TASK,nvl(:P108_EXPENDITURE_TYPE_P,:P108_EXPENDITURE_TYPE_A), :P108_PROPOSAL_YEAR - 4 , ''A''),',
'   projects_util.EXPENDITURE_BALANCE(:P108_PROJECT ,:P108_TASK,nvl(:P108_EXPENDITURE_TYPE_P,:P108_EXPENDITURE_TYPE_A), :P108_PROPOSAL_YEAR - 5 , ''A''),',
'   case NVL(projects_util.EXPENDITURE_BALANCE(:P108_PROJECT ,:P108_TASK,nvl(:P108_EXPENDITURE_TYPE_P,:P108_EXPENDITURE_TYPE_A), :P108_PROPOSAL_YEAR - 1 , ''A''),0)',
'        ',
'          when 0 then ''Y''',
'        else ''N''',
'        end ,',
'        :P108_CC_PLAN_ID',
' );'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(44490811289903318)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Add project and Task '
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
