prompt --application/pages/page_00019
begin
--   Manifest
--     PAGE: 00019
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>219773596381898043
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>19
,p_user_interface_id=>wwv_flow_api.id(23921013981372477)
,p_name=>'Delegation Admin - Details'
,p_alias=>'DELEGATION-ADMIN-DETAILS'
,p_step_title=>'Delegation Admin - Details'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220216061954'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(8693661102966082)
,p_plug_name=>'Delegate to:'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--noUI:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>8
,p_plug_display_column=>2
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(76096456619666388)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_api.id(8693661102966082)
,p_button_name=>'AddAttachment'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(23897848603372510)
,p_button_image_alt=>'Add Attachment'
,p_button_position=>'BODY'
,p_button_redirect_url=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.::P4_PETTY_CASH_ID,P4_PETTY_CASH_NO,P4_ALLOW_INSERT,P4_FROM_PAGE:&P19_PETTY_CASH_ID_H.,&P19_PETTY_CASH_NUMBER.,Y,48'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-file-plus'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(76096086531666388)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(8693661102966082)
,p_button_name=>'Submit'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(23898584035372508)
,p_button_image_alt=>'Submit'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(76095671119666388)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(8693661102966082)
,p_button_name=>'Cancel'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:17:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(76086278843666383)
,p_branch_name=>'Go to 17'
,p_branch_action=>'f?p=&APP_ID.:17:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'BEFORE_COMPUTATION'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76112261845012550)
,p_name=>'P19_CREDIT_CARD_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(8693661102966082)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76112105487012549)
,p_name=>'P19_DELEGATE_FROM'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(8693661102966082)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76099131024666389)
,p_name=>'P19_HISTORY_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(8693661102966082)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76095215660666387)
,p_name=>'P19_DELEGATE_FROM_NAME'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(8693661102966082)
,p_prompt=>'Delegate From:'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT FULL_NAME_EN',
'FROM EMPLOYEES_V',
'WHERE PERSON_ID = :P19_DELEGATE_FROM'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--xlarge'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76094832652666387)
,p_name=>'P19_DELEGATE_TO'
,p_is_required=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(8693661102966082)
,p_prompt=>'Delegate To:'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'PERSON DETAILS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select e.employee_num || ''-'' || e.full_name_en  emp_name , e.person_id , e.org_id, e.department_name',
'        , e.sector ',
'        , e.department_id',
'        , e.sector_id',
'        , (select s.short_name_en',
'            from dct_hr_organizations s',
'            where s.org_id = e.sector_id) sector_code',
'        , cost_center_code    ',
'        , e.email',
'        , e.mobile',
'        , e.position',
'        , e.position_id',
'        , e.employee_num',
'        ,e.nationality_id',
'from employees_v e',
'where current_flag = ''Y'' ',
'ORDER BY employee_num;    '))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--xlarge'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(22956720005919223)
,p_name=>'P19_APPROVAL_TYPE_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(8693661102966082)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(76090109977666384)
,p_name=>'Delegation DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(76096086531666388)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76089653892666384)
,p_event_id=>wwv_flow_api.id(76090109977666384)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure that you want to delegate this Credit card Request approval ?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76089149936666384)
,p_event_id=>wwv_flow_api.id(76090109977666384)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'--petty_cash_WORKFLOW.delegate_petty_cash(:P19_PETTY_CASH_ID_H ,:P19_FROM_USER, :P19_DELEGATE_TO);',
'credit_cards_workflow.delegate(:P19_CREDIT_CARD_ID, :P19_DELEGATE_FROM , :P19_DELEGATE_TO, :P19_APPROVAL_TYPE_ID);',
'End;'))
,p_attribute_02=>'P19_DELEGATE_TO,P19_CREDIT_CARD_ID,P19_APPROVAL_TYPE_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76088599919666383)
,p_event_id=>wwv_flow_api.id(76090109977666384)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.component_end;
end;
/
