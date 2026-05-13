prompt --application/pages/page_00033
begin
--   Manifest
--     PAGE: 00033
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
 p_id=>33
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Expense Report Approval Delegation'
,p_alias=>'EXPENSE-REPORT-APPROVAL-DELEGATION'
,p_step_title=>'Expense Report Approval Delegation'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20201007192059'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(10809506615269011)
,p_plug_name=>'Select the employee'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4783035151222717)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(10809506615269011)
,p_button_name=>'Delegate'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Delegate'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4783388027222718)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(10809506615269011)
,p_button_name=>'Cancel'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_image_alt=>'Cancel'
,p_button_position=>'BELOW_BOX'
,p_button_redirect_url=>'f?p=&APP_ID.:32:&SESSION.::&DEBUG.::P32_EXPENSE_REPORT_ID:&P33_EXPENSE_REPORT_ID.'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(4787322186222730)
,p_branch_name=>'Go To 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4783836886222718)
,p_name=>'P33_EXPENSE_REPORT_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(10809506615269011)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4784187521222719)
,p_name=>'P33_FROM_USER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(10809506615269011)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4784594061222719)
,p_name=>'P33_TO_USER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(10809506615269011)
,p_prompt=>'Delegated To'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMPLOYEES ALL LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select full_name_en     EMP_NAME, ',
'        employee_num ',
'from dct_bi_employees_v',
'where current_flag = ''Yes'''))
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(8118975198175531)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4785272609222728)
,p_name=>'Delegation DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(4783035151222717)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4785829858222729)
,p_event_id=>wwv_flow_api.id(4785272609222728)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure that you want to delegate this Expense report approval ?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4786343338222729)
,p_event_id=>wwv_flow_api.id(4785272609222728)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'EXPENSE_REPORT_WORKFLOW.delegate(:P33_EXPENSE_REPORT_ID ,:APP_USER , :P33_TO_USER);',
'',
'',
'end;'))
,p_attribute_02=>'P33_EXPENSE_REPORT_ID,P33_TO_USER'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4786844789222729)
,p_event_id=>wwv_flow_api.id(4785272609222728)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.component_end;
end;
/
