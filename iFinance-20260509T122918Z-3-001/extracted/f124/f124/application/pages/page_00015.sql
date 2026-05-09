prompt --application/pages/page_00015
begin
--   Manifest
--     PAGE: 00015
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
 p_id=>15
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'DP Item Category Role Details'
,p_alias=>'DP-ITEM-CATEGORY-ROLE-DETAILS'
,p_page_mode=>'MODAL'
,p_step_title=>'DP Item Category Role Details'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231210182607'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(128831158980256832)
,p_plug_name=>'Button'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noBorder'
,p_plug_template=>wwv_flow_api.id(127777381735449810)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(128904304684873085)
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
 p_id=>wwv_flow_api.id(128832767982256848)
,p_plug_name=>'Audit'
,p_parent_plug_id=>wwv_flow_api.id(128904304684873085)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P15_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(128832244157256843)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(128831158980256832)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(128831212926256833)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(128831158980256832)
,p_button_name=>'Create'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_button_condition=>'P15_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_icon_css_classes=>'fa-save'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(128831438568256835)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(128831158980256832)
,p_button_name=>'Save'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Save'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P15_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-save-as'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(128832035395256841)
,p_branch_name=>'Go to 5'
,p_branch_action=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:5:P5_CATEGORY_ID:&P15_CATEGORY_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128830578234256826)
,p_name=>'P15_CATEGORY_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(128904304684873085)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128830648729256827)
,p_name=>'P15_ROLE_ID'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(128904304684873085)
,p_prompt=>'Role'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'DP ITEM CATEGORY ROLES'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 50 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10)',
'Union ALL',
'select ''Procurement Business Partner''  value , 108 value_id from dual',
';'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128830768696256828)
,p_name=>'P15_STATUS'
,p_is_required=>true
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(128904304684873085)
,p_item_default=>'A'
,p_prompt=>'Status'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'STATUS LOV'
,p_lov=>'.'||wwv_flow_api.id(128342850308489799)||'.'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128830831906256829)
,p_name=>'P15_START_DATE'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(128904304684873085)
,p_item_default=>'select sysdate from dual;'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Start Date'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128830928144256830)
,p_name=>'P15_END_DATE'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(128904304684873085)
,p_prompt=>'End Date'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_02=>'&P15_START_DATE.'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128831059973256831)
,p_name=>'P15_NOTES'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(128904304684873085)
,p_prompt=>'Notes'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>2
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128831307893256834)
,p_name=>'P15_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(128904304684873085)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128832150476256842)
,p_name=>'P15_PERSON_ID'
,p_is_required=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(128904304684873085)
,p_prompt=>'Employee'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e',
'where person_id > 10'))
,p_lov_display_null=>'YES'
,p_cSize=>50
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_07=>'Select Employee'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128832811231256849)
,p_name=>'P15_CREATED_BY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(128832767982256848)
,p_prompt=>'Created By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e',
'where person_id > 10'))
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128832939323256850)
,p_name=>'P15_UPDATED_BY'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(128832767982256848)
,p_prompt=>'Updated By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e',
'where person_id > 10'))
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128919076696697301)
,p_name=>'P15_CREATED_ON'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(128832767982256848)
,p_prompt=>'Created On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128919171275697302)
,p_name=>'P15_UPDATED_ON'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(128832767982256848)
,p_prompt=>'Updated On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128919292568697303)
,p_name=>'P15_APPLY_FOR_CHILD'
,p_is_required=>true
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(128904304684873085)
,p_item_default=>'N'
,p_prompt=>'Apply For All Sub-Category '
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(128345817677489797)||'.'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128919372680697304)
,p_name=>'P15_PARENT_YN'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(128904304684873085)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129036243290007645)
,p_name=>'P15_APPROVAL_YN'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(128904304684873085)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129036345298007646)
,p_name=>'P15_ROLE_TYPE'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(128904304684873085)
,p_item_default=>'PBP'
,p_prompt=>'Role Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'ITEM CATEGORY ROLETYPE'
,p_lov=>'.'||wwv_flow_api.id(129227054013271903)||'.'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(128832317141256844)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(128832244157256843)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128832492405256845)
,p_event_id=>wwv_flow_api.id(128832317141256844)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(128919499651697305)
,p_name=>'Parent Y DA'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P15_PARENT_YN'
,p_condition_element=>'P15_PARENT_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128919571744697306)
,p_event_id=>wwv_flow_api.id(128919499651697305)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P15_APPLY_FOR_CHILD'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128919610655697307)
,p_event_id=>wwv_flow_api.id(128919499651697305)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P15_APPLY_FOR_CHILD'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(128831961097256840)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialize Item Category Role Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    id,',
'    category_id,',
'    role_id,',
'    PERSON_ID,',
'    status,',
'    start_date,',
'    end_date,',
'    notes,',
'    created_by,',
'    created_on,',
'    updated_by,',
'    updated_on,',
'    APPLY_FOR_CHILD,',
'    APPROVAL_YN,',
'    ROLE_TYPE',
'into',
'    :P15_id,',
'    :P15_category_id,',
'    :P15_role_id,',
'    :P15_PERSON_ID,',
'    :P15_status,',
'    :P15_start_date,',
'    :P15_end_date,',
'    :P15_notes,',
'    :P15_created_by,',
'    :P15_created_on,',
'    :P15_updated_by,',
'    :P15_updated_on,',
'    :P15_APPLY_FOR_CHILD,',
'    :P15_APPROVAL_YN,',
'    :P15_ROLE_TYPE',
'FROM',
'    dp_item_category_roles',
'where id = :P15_ID;',
'exception',
'    when others then null;  '))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P15_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(128831614014256837)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Insert Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'INSERT INTO dp_item_category_roles (',
'    category_id,',
'    role_id,',
'    PERSON_ID,',
'    status,',
'    start_date,',
'    end_date,',
'    notes,',
'    APPLY_FOR_CHILD,',
'    APPROVAL_YN,',
'    ROLE_TYPE',
') VALUES (',
'    :P15_CATEGORY_ID,',
'    :P15_ROLE_ID,',
'    :P15_PERSON_ID,',
'    :P15_STATUS,',
'    :P15_START_DATE,',
'    :P15_END_DATE,',
'    :P15_NOTES,',
'    :P15_APPLY_FOR_CHILD,',
'    :P15_APPROVAL_YN,',
'    :P15_ROLE_TYPE',
');',
''))
,p_process_error_message=>'Role Not Added, Contact the system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(128831212926256833)
,p_process_success_message=>'Role Added successfully'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(128831719718256838)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update dp_item_category_roles ',
'set',
'    category_id = :P15_CATEGORY_ID,',
'    role_id = :P15_ROLE_ID,',
'    PERSON_ID = :P15_PERSON_ID,',
'    status = :P15_STATUS,',
'    start_date = :P15_START_DATE,',
'    end_date = :P15_END_DATE,',
'    notes = :P15_NOTES,',
'    APPLY_FOR_CHILD = :P15_APPLY_FOR_CHILD,',
'    APPROVAL_YN = :P15_APPROVAL_YN,',
'    ROLE_TYPE = :P15_ROLE_TYPE',
' where id = :P15_ID   ;',
''))
,p_process_error_message=>'Not Updated, Contact the system admin'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(128831438568256835)
,p_process_success_message=>'Updated'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(128919965379697310)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Merge Child Category roles '
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if (:P15_APPLY_FOR_CHILD = ''Y'')',
'    Then',
'    merge into dp_item_category_roles target_t',
'using ( ',
'  SELECT s.category_id , d.role_id, d.person_id, d.APPROVAL_YN , d.ROLE_TYPE',
'    FROM   dp_item_categories s , dp_item_category_roles d',
'    where s.parent_category_id = :P15_CATEGORY_ID',
'    and s.parent_category_id = d.category_id',
') sourec_t',
'on    ( target_t.category_id = sourec_t.category_id )',
'when not matched then',
'  insert ( category_id,',
'            role_id,',
'            status,',
'            start_date,',
'            notes,',
'            person_id,',
'            apply_for_child,',
'            APPROVAL_YN,',
'            ROLE_TYPE)',
'  values ( sourec_t.category_id ,',
'            sourec_t.role_id,',
'            ''A'',',
'            sysdate,',
'            ''Auto added From Main Category'',',
'            sourec_t.person_id,',
'            ''N'',',
'           sourec_t.APPROVAL_YN,',
'           sourec_t.ROLE_TYPE)',
'when matched then',
'  update set role_id = sourec_t.role_id,',
'            status = ''A'',',
'            notes = ''Auto Updated From Main Category'',',
'            person_id =sourec_t.person_id,',
'            APPROVAL_YN = sourec_t.APPROVAL_YN,',
'            ROLE_TYPE = sourec_t.ROLE_TYPE;',
'    end if;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P15_APPLY_FOR_CHILD'
,p_process_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_process_when2=>'Y'
,p_process_success_message=>'SSS'
);
wwv_flow_api.component_end;
end;
/
