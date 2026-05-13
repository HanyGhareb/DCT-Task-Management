prompt --application/pages/page_00059
begin
--   Manifest
--     PAGE: 00059
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>59
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Copy Page'
,p_alias=>'COPY-PAGE'
,p_page_mode=>'MODAL'
,p_step_title=>'Copy'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210628212640'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(2354644475472817)
,p_plug_name=>'Copy'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>'you will copy request# <b>&P59_REQUEST_NUM.</b>, Are you sure?'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(2354970979472820)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(2354644475472817)
,p_button_name=>'Copy'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_image_alt=>'Copy'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(2355047753472821)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(2354644475472817)
,p_button_name=>'Cancel'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_image_alt=>'Cancel'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2354768124472818)
,p_name=>'P59_TRX'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(2354644475472817)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2354806740472819)
,p_name=>'P59_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(2354644475472817)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2355131497472822)
,p_name=>'P59_PAGE_FROM'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(2354644475472817)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2356198152472832)
,p_name=>'P59_REQUEST_NUM'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(2354644475472817)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(2355232279472823)
,p_name=>'Copy DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(2354970979472820)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(2355303446472824)
,p_event_id=>wwv_flow_api.id(2355232279472823)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare ',
'l_seq Number := PETTY_CASH_NO_SEQ.nextval;',
'',
'begin',
'if :P59_TRX = ''PC'' Then',
'INSERT INTO hrss_petty_cash (',
'    petty_cash_no,',
'    petty_cash_date,',
'    due_date,',
'    petty_cash_type,',
'    employee_num,',
'    project_number,',
'    task,',
'    amount,',
'    purpose,',
'    closing_date,',
'    approval_status,',
'    status,',
'    priority,',
'    year,',
'    gl_account,',
'    justification,',
'    emp_org_id',
')select ',
'    (select :APP_USER ||',
'        ''/''      ||',
'        Extract(YEAR from sysdate)',
'        ||',
'        ''/''',
'        ||',
'        petty_cash_type',
'        ||',
'        lpad(l_seq,4,0)',
'        from dual),',
'    sysdate,',
'    sysdate + 7,',
'    petty_cash_type,',
'    employee_num,',
'    project_number,',
'    task,',
'    amount,',
'    purpose,',
'    closing_date,',
'    ''Draft'',',
'    status,',
'    priority,',
'    year,',
'    gl_account,',
'    justification,',
'    emp_org_id',
'From hrss_petty_cash',
'where petty_cash_id = :P59_ID;',
'',
'Elsif :P59_TRX = ''ER'' Then',
'INSERT INTO hrss_expense_reports (',
'    expense_report_id,',
'    petty_cash_id,',
'    expense_report_date,',
'    purpose,',
'    approval_status,',
'    invoicing_yn,',
'    priority,',
'    justification,',
'    comment_to_approver,',
'    year,',
'    expense_report_num,',
'    paid_yn,',
'    type,',
'    emp_org_id,',
'    employee_num,',
'    pending_with_ap',
') Select HRSS_EXPENSE_REPORT_LINES_SEQ.NextVAL,',
'    petty_cash_id,',
'    sysdate,',
'    ev.EXPENSE_REPORT_PURPOSE,',
'    ''Draft'',',
'    ''N'',',
'    ev.EXPENSE_REPORT_PRIORITY,',
'    ev.EXPENSE_REPORT_JUSTIFICATION,',
'    ev.EXPENSE_REPORT_COMMENT,',
'    Extract(YEAR from sysdate),',
'    (SELECT ev.petty_cash_no	 ||',
'        ''/IE''                 ||',
'        (select count(*)+ 1',
'        from hrss_expense_reports e',
'        where e.petty_cash_id =  ev.petty_cash_id ) exp',
'        from dual),',
'    ''N'',',
'    substr(ev.expense_report_type,1,1),',
'    ev.expense_report_org_id,',
'    ev.expense_report_emp_num',
'    ,''N''',
'From expense_reports_all_v ev',
'where expense_report_id = :P59_ID;',
'',
'INSERT INTO hrss_expense_report_lines (',
'    expense_report_id,',
'    expense_date,',
'    receipt_amount,',
'    expense_type,',
'    justification,',
'    comment_to_approver',
') select    HRSS_EXPENSE_REPORT_LINES_SEQ.CURRVAL,',
'    expense_date,',
'    receipt_amount,',
'    expense_type,',
'    justification,',
'    comment_to_approver',
'from hrss_expense_report_lines',
'where expense_report_id = :P59_ID;',
'',
'End IF;',
'End;'))
,p_attribute_02=>'P59_TRX,P59_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(2355620050472827)
,p_event_id=>wwv_flow_api.id(2355232279472823)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(2355732737472828)
,p_name=>'Cancel DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(2355047753472821)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(2355839104472829)
,p_event_id=>wwv_flow_api.id(2355732737472828)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.component_end;
end;
/
