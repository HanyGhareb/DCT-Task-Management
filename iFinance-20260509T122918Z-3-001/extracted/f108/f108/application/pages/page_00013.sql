prompt --application/pages/page_00013
begin
--   Manifest
--     PAGE: 00013
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>500
,p_default_id_offset=>354480484490134169
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>13
,p_user_interface_id=>wwv_flow_api.id(19279151117383422)
,p_name=>'MPR Delegation Requests'
,p_alias=>'MPR-DELEGATION-REQUESTS'
,p_step_title=>'MPR Delegation Requests'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240118121304'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(26561192956474144)
,p_plug_name=>'Select the employee -  Admin'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(19194535783383347)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':EMP_NUM in (9050,9051, 351, 9307,690 )'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(26093255755987685)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(19203962458383352)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(19140599913383303)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(19258056279383396)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(52747584401237399)
,p_plug_name=>'Select the employee'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(19194535783383347)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':EMP_NUM not in (9050)'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(26560756729474140)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(26561192956474144)
,p_button_name=>'Delegate_1'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(19256715332383394)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Delegate'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(26091168188987696)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(52747584401237399)
,p_button_name=>'Delegate'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(19256715332383394)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Delegate'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(26074619251476589)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(26561192956474144)
,p_button_name=>'Cancel_1'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(19256621748383394)
,p_button_image_alt=>'Cancel'
,p_button_position=>'BELOW_BOX'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:1::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(26091584894987696)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(52747584401237399)
,p_button_name=>'Cancel'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(19256621748383394)
,p_button_image_alt=>'Cancel'
,p_button_position=>'BELOW_BOX'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:1::'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(26095802836987679)
,p_branch_name=>'Go To 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(26561031503474143)
,p_name=>'P13_ID_1'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(26561192956474144)
,p_prompt=>'MPR#'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'MPR DELEGATIONS LOV - ALL'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select m.id , m.request_number || ''-'' || e.full_name_en || '' ('' ',
'        || trim(to_char(m.requested_amount , ''99,999,999,999.99''))',
'        || '' '' || m.currency || '')''  MPR_NUMBER ',
'    , (select h.person_id',
'        from mpr_approval_history h',
'        where h.mpr_id =  m.id',
'        and h.status = ''Pending''',
'        and rownum = 1)requestor_id',
'from mpr m, employees_v e',
'where m.requestor_person_id = e.person_id'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(19255616347383393)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_10=>'REQUESTOR_ID:P13_FROM_PERSON_ID_1'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(26560987634474142)
,p_name=>'P13_FROM_PERSON_ID_1'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(26561192956474144)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(26560862798474141)
,p_name=>'P13_TO_PERSON_ID_1'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(26561192956474144)
,p_prompt=>'Delegated To'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e',
'where  person_id > 10'))
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(19255616347383393)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(26091999235987692)
,p_name=>'P13_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(52747584401237399)
,p_prompt=>'MPR#'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'MPR DELEGATIONS LOV BY COST CENTER'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select m.id , m.request_number || ''-'' || e.full_name_en || '' ('' ',
'        || trim(to_char(m.requested_amount , ''99,999,999,999.99''))',
'        || '' '' || m.currency || '')''  MPR_NUMBER ',
'    , (select h.person_id',
'        from mpr_approval_history h',
'        where h.mpr_id =  m.id',
'        and h.status = ''Pending''',
'        and rownum = 1)requestor_id',
'from mpr m, employees_v e',
'where m.requestor_person_id = e.person_id',
'and m.cost_center in (select cost_center',
'from cost_centers_fbp',
'where person_id = :PERSON_ID',
'and status = ''A'')    '))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(19255616347383393)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_10=>'REQUESTOR_ID:P13_FROM_PERSON_ID'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(26092395228987690)
,p_name=>'P13_FROM_PERSON_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(52747584401237399)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(26092765522987690)
,p_name=>'P13_TO_PERSON_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(52747584401237399)
,p_prompt=>'Delegated To'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e',
'where  person_id > 10'))
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(19255616347383393)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(26093825176987682)
,p_name=>'Delegation DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(26091168188987696)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(26094364503987681)
,p_event_id=>wwv_flow_api.id(26093825176987682)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure that you want to delegate this approval for this Manual PR ?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(26094847766987681)
,p_event_id=>wwv_flow_api.id(26093825176987682)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'mpr_workflow.DELEGATE(:P13_ID ,:P13_FROM_PERSON_ID, :P13_TO_PERSON_ID);',
'',
'end;'))
,p_attribute_02=>'P13_ID,P13_TO_PERSON_ID,P13_FROM_PERSON_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(26095310598987680)
,p_event_id=>wwv_flow_api.id(26093825176987682)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(26074065907476584)
,p_name=>'Delegation All DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(26560756729474140)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(26073971372476583)
,p_event_id=>wwv_flow_api.id(26074065907476584)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure that you want to delegate this approval for this Manual PR ?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(26073840498476582)
,p_event_id=>wwv_flow_api.id(26074065907476584)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'mpr_workflow.DELEGATE(:P13_ID_1 ,:P13_FROM_PERSON_ID_1, :P13_TO_PERSON_ID_1);',
'',
'end;'))
,p_attribute_02=>'P13_ID_1,P13_FROM_PERSON_ID_1,P13_TO_PERSON_ID_1'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(26073751861476581)
,p_event_id=>wwv_flow_api.id(26074065907476584)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.component_end;
end;
/
