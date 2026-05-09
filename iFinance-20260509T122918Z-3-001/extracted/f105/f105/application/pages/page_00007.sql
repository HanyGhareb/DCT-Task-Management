prompt --application/pages/page_00007
begin
--   Manifest
--     PAGE: 00007
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
 p_id=>7
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'End User - Transfer Request'
,p_alias=>'END-USER-TRANSFER-REQUEST'
,p_page_mode=>'MODAL'
,p_step_title=>'End User - Budget Transfer Request'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230919035845'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(88816598822932)
,p_plug_name=>'Button'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noBorder'
,p_plug_template=>wwv_flow_api.id(99731046805410735)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(222036394753298)
,p_plug_name=>'Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(24020276339356902)
,p_plug_name=>'Details-L'
,p_parent_plug_id=>wwv_flow_api.id(222036394753298)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(24020102850356900)
,p_plug_name=>'Details-R'
,p_parent_plug_id=>wwv_flow_api.id(222036394753298)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(24019921841356898)
,p_plug_name=>'Details-Justification'
,p_parent_plug_id=>wwv_flow_api.id(222036394753298)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(88204171822926)
,p_plug_name=>'Audit Info'
,p_parent_plug_id=>wwv_flow_api.id(222036394753298)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P7_REQUEST_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(88283091822927)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(88816598822932)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Create'
,p_button_position=>'BELOW_BOX'
,p_button_condition=>'P7_REQUEST_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_icon_css_classes=>'fa-save'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(88402708822928)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(88816598822932)
,p_button_name=>'Cancel'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Cancel'
,p_button_position=>'BELOW_BOX'
,p_button_alignment=>'LEFT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(251498525473827)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(88816598822932)
,p_button_name=>'UPDATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P7_REQUEST_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-save-as'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(89034013822934)
,p_branch_name=>'GoTo 8'
,p_branch_action=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::P8_REQUEST_ID:&P7_REQUEST_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(100819352953881289)
,p_name=>'P7_TYPE_CHANGED'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(222036394753298)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24019757820356897)
,p_name=>'P7_APPROVAL_CASE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(24020102850356900)
,p_prompt=>'Approval Case'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'APPROVAL CASES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    value,',
'    value_id',
'FROM',
'    dct_lookup_values',
'WHERE',
'        lookup_id = (',
'            SELECT',
'                l.lookup_id',
'            FROM',
'                dct_lookups l',
'            WHERE',
'                l.lookup_code = ''APPROVAL_CASES''',
'        )',
'    AND status = ''A''',
'    AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_display_when=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_IFINANCE_ADMIN = ''Y'' or ',
':IS_BUDGET_PLANNING_YN = ''Y'' or',
':IS_FBP_EMP = ''Y'''))
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86629794822910)
,p_name=>'P7_REQUEST_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(222036394753298)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86753755822911)
,p_name=>'P7_REQUEST_NO'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(24020276339356902)
,p_prompt=>'Request No'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P7_REQUEST_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86789216822912)
,p_name=>'P7_REQUEST_TYPE'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(24020276339356902)
,p_item_default=>'S'
,p_prompt=>'Request Type'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'EU REQUEST TYPES'
,p_lov=>'.'||wwv_flow_api.id(203139147648731)||'.'
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p><strong>Standard:</strong> to create a standard budget transfer request for Non-Strategic projects, you will prompt to choose the source project/Tasks and destination project/tasks. you should have access to these projects.</p>',
'<p><strong>Change Request:</strong> to create budget transfer request for Strategic projects.</p>',
'<p><strong>Additional Funding:</strong> to create additional funding request to Non-Strategic projects. you will prompt to choose the project/task. you should have access to this project.</p>',
'<p><strong>Budget Reduction:</strong> to create budget reduction request to Non-Strategic projects. you will prompt to choose the project/task. you should have access to this project.</p>'))
,p_attribute_01=>'1'
,p_attribute_02=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86960923822913)
,p_name=>'P7_REQUEST_DATE'
,p_is_required=>true
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(24020102850356900)
,p_item_default=>'select sysdate from dual'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>10
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86999565822914)
,p_name=>'P7_PRIORITY'
,p_is_required=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(24020102850356900)
,p_prompt=>'Priority'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'PRIORITY LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id',
'from dct_lookup_values',
'where lookup_id = (Select x.lookup_id',
'                    from dct_lookups x',
'                    where x.LOOKUP_CODE = ''PRIORITY'');'))
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(87148708822915)
,p_name=>'P7_REQUIRED_DATE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(24020276339356902)
,p_item_default=>'select sysdate + 5 from dual'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Due Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>10
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(87213210822916)
,p_name=>'P7_REQUEST_STATUS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(24020102850356900)
,p_item_default=>'Draft'
,p_prompt=>'Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(87328325822917)
,p_name=>'P7_JUSTIFICATION'
,p_is_required=>true
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(24019921841356898)
,p_prompt=>'Justification'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>150
,p_cHeight=>2
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(87387620822918)
,p_name=>'P7_SPM_PROJECT_NAME'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(24020276339356902)
,p_prompt=>'Strategic Project Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(87829614822922)
,p_name=>'P7_CREATED_BY_PERSON_ID'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(88204171822926)
,p_prompt=>'Created By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_display_when=>'P7_REQUEST_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(87903765822923)
,p_name=>'P7_UPDATED_BY_PERSON_ID'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(88204171822926)
,p_prompt=>'Updated By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_display_when=>'P7_REQUEST_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(88018998822924)
,p_name=>'P7_CREATION_DATE'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(88204171822926)
,p_prompt=>'Created On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_display_when=>'P7_REQUEST_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(88108225822925)
,p_name=>'P7_UPDATED_DATE'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(88204171822926)
,p_prompt=>'Updated On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_display_when=>'P7_REQUEST_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(87476393822919)
,p_name=>'Request Type DA'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P7_REQUEST_TYPE'
,p_condition_element=>'P7_REQUEST_TYPE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'C'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(87659159822920)
,p_event_id=>wwv_flow_api.id(87476393822919)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P7_SPM_PROJECT_NAME'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(87715774822921)
,p_event_id=>wwv_flow_api.id(87476393822919)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P7_SPM_PROJECT_NAME'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(88571366822930)
,p_name=>'Cancel DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(88402708822928)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(88748630822931)
,p_event_id=>wwv_flow_api.id(88571366822930)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(100819272520881288)
,p_name=>'Change Type Done DA'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P7_REQUEST_TYPE'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(100819174266881287)
,p_event_id=>wwv_flow_api.id(100819272520881288)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P7_TYPE_CHANGED'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(251403894473826)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialize'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    request_id,',
'    request_no,',
'    to_char(request_date,''DD-MON-YYYY'') request_date,',
'    to_char(required_date,''DD-MON-YYYY'') required_date,',
'    request_status,',
'    justification,',
'--    year,',
'    priority,',
'--    to_char(submitted_on,''DD-MON-YYYY HH:MIPM'')    submitted_on,       ',
'--    submitted_by,',
'--    seq,',
'--    to_char(final_approve_on,''DD-MON-YYYY HH:MIPM'') final_approve_on,',
'--    created_by_person_id,',
'--    updated_by_person_id,',
'--    to_char(creation_date,''DD-MON-YYYY HH:MIPM'')    creation_date,',
'--    to_char(updated_date,''DD-MON-YYYY HH:MIPM'')    updated_date,',
'    spm_project_name,',
'--    spm_project_id,',
'    request_type',
'INTO',
'    :P7_REQUEST_ID,',
'    :P7_REQUEST_NO,',
'    :P7_REQUEST_DATE,',
'    :P7_REQUIRED_DATE,',
'    :P7_REQUEST_STATUS,',
'    :P7_JUSTIFICATION,',
'--    :P8_YEAR,',
'    :P7_PRIORITY,',
'--    :P8_SUBMITTED_ON,',
'--    :P8_SUBMITTED_BY,',
'--    :P8_SEQ,',
'--    :P8_FINAL_APPROVE_ON,',
'--    :P8_CREATED_BY_PERSON_ID,',
'--    :P8_UPDATED_BY_PERSON_ID,',
'--    :P8_CREATION_DATE,',
'--    :P8_UPDATED_DATE,',
'    :P7_SPM_PROJECT_NAME,',
'    :P7_REQUEST_TYPE',
'FROM',
'    btf_end_users_header',
'WHERE request_id = :P7_REQUEST_ID  ;',
'exception',
'    when others then null;     '))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P7_REQUEST_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(88535324822929)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Insert New EU Header'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'declare',
'l_total_count               number;',
'l_request_no        varchar2(50);',
'BEGIN',
'    -- get total Count By Year',
'        select nvl(max(SEQ),0) + 1',
'        into l_total_count',
'        from btf_end_users_header',
'        where year = EXTRACT(year from sysdate)',
'        and REQUEST_TYPE = :P7_REQUEST_TYPE;',
'        ',
'l_request_no := ''BTF'' || to_char(sysdate, ''yyyymmdd'') || ''/'' ',
'                   || :APP_USER                     || ''/''   ',
'                   || :P7_REQUEST_TYPE              ||',
'                   to_char(l_total_count);',
'                   ',
' SELECT BTF_END_USERS_REQ_SEQ.nextval',
'into :P7_REQUEST_ID',
'FROM all_sequences',
' WHERE sequence_owner = ''PROD''',
'   AND sequence_name = ''BTF_END_USERS_REQ_SEQ'';',
'   ',
'   INSERT INTO btf_end_users_header (',
'    request_id,',
'    request_no,',
'    request_date,',
'    required_date,',
'    request_status,',
'    justification,',
'    year,',
'    priority,',
'    seq,',
'    request_type,',
'    SPM_PROJECT_NAME, ',
'    APPROVAL_CASE_ID',
') VALUES (',
'    :P7_REQUEST_ID,',
'    l_request_no,',
'    to_date(:P7_REQUEST_DATE , ''DD-MON-YYYY''),',
'    to_date(:P7_REQUIRED_DATE , ''DD-MON-YYYY''),',
'    :P7_REQUEST_STATUS,',
'    :P7_JUSTIFICATION,',
'    EXTRACT(year from sysdate),',
'    :P7_PRIORITY,',
'    l_total_count,',
'    :P7_REQUEST_TYPE,',
'    :P7_SPM_PROJECT_NAME,',
'    :P7_APPROVAL_CASE',
');',
'',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(88283091822927)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(251628868473828)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update EU Header'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_total_count               number;',
'l_request_no        varchar2(50);',
'begin',
'',
'if :P7_TYPE_CHANGED = ''Y''',
'Then',
'    -- get total Count By Year',
'        select nvl(max(SEQ),0) + 1',
'        into l_total_count',
'        from btf_end_users_header',
'        where year = EXTRACT(year from sysdate)',
'        and REQUEST_TYPE = :P7_REQUEST_TYPE;',
'        ',
'        ',
'l_request_no := ''BTF'' || to_char(sysdate, ''yyyymmdd'') || ''/'' ',
'                   || :APP_USER                     || ''/''   ',
'                   || :P7_REQUEST_TYPE              ||',
'                   to_char(l_total_count);',
'                   ',
'    else',
'    l_request_no := :P7_REQUEST_NO ;',
'End If;',
'',
'Update btf_end_users_header ',
'Set request_date =to_date(:P7_REQUEST_DATE , ''DD-MON-YYYY''),',
'    required_date = to_date(:P7_REQUIRED_DATE , ''DD-MON-YYYY''),',
'    justification = :P7_JUSTIFICATION,',
'    priority = :P7_PRIORITY,',
'    request_type = :P7_REQUEST_TYPE,',
'    SPM_PROJECT_NAME = :P7_SPM_PROJECT_NAME,',
'    request_no =l_request_no,',
'    APPROVAL_CASE_ID = :P7_APPROVAL_CASE',
'where request_id = :P7_REQUEST_ID;',
'',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(251498525473827)
,p_process_success_message=>'Updated Successfully'
);
wwv_flow_api.component_end;
end;
/
