prompt --application/pages/page_00007
begin
--   Manifest
--     PAGE: 00007
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>114
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>7
,p_user_interface_id=>wwv_flow_api.id(52958449993734913)
,p_name=>'Manager Cheque Approve Reject Actions'
,p_alias=>'MANAGER-CHEQUE-APPROVE-REJECT-ACTIONS'
,p_page_mode=>'MODAL'
,p_step_title=>'Manager Cheque Approve Reject Actions'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220118180832'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(53149316516960339)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(52847423684734857)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(53278955486230742)
,p_plug_name=>'Action'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noUI:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(52873880343734866)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(53149253932960338)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(53149316516960339)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large'
,p_button_template_id=>wwv_flow_api.id(52935963508734896)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(53149656261960342)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(53149316516960339)
,p_button_name=>'Approve'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(52936058388734896)
,p_button_image_alt=>'&P6_APPROVE_LABEL.'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P7_ACTION'
,p_button_condition2=>'Approve'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-check-square'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(53149720865960343)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(53149316516960339)
,p_button_name=>'Delegate'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(52936058388734896)
,p_button_image_alt=>'Delegate'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P7_ACTION'
,p_button_condition2=>'Delegate'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-info'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(53149825942960344)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(53149316516960339)
,p_button_name=>'Reject'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--danger:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(52936058388734896)
,p_button_image_alt=>'&P6_REJECT_LABEL.'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P7_ACTION'
,p_button_condition2=>'Reject'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-check-square'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(53298453451558607)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(53149316516960339)
,p_button_name=>'Withdraw'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(52936058388734896)
,p_button_image_alt=>'Withdraw'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P7_ACTION'
,p_button_condition2=>'Withdraw'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(53150014649960346)
,p_branch_name=>'Go To 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:1::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53148862020960334)
,p_name=>'P7_HISTORY_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(53278955486230742)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53148941910960335)
,p_name=>'P7_CHECK_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(53278955486230742)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53149044931960336)
,p_name=>'P7_RECEIVED_ON'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(53278955486230742)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53149109762960337)
,p_name=>'P7_COMMENT'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(53278955486230742)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>5
,p_field_template=>wwv_flow_api.id(52934852790734894)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53149940867960345)
,p_name=>'P7_ACTION'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(53278955486230742)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53150485806960350)
,p_name=>'P7_TO_PERSON_ID'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(53278955486230742)
,p_prompt=>'Delegated To'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'PERSONS ACTIVE'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'    select full_name_en, person_id, email , employee_num',
'    from employees_v',
'     where current_flag = ''Y'''))
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_display_when=>'P7_ACTION'
,p_display_when2=>'Delegate'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(52934951552734894)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53681328909159601)
,p_name=>'P7_RECEIVING_PERSON_NAME'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(53278955486230742)
,p_prompt=>'Receiving Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_display_when=>'P7_ROLE_DESC'
,p_display_when2=>'Treasury'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(52935104739734895)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53681484389159602)
,p_name=>'P7_EMIRATES_ID'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(53278955486230742)
,p_prompt=>'Emirates ID'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_display_when=>'P7_ROLE_DESC'
,p_display_when2=>'Treasury'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(52935104739734895)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53682643901159614)
,p_name=>'P7_ROLE_DESC'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(53278955486230742)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(53149474744960340)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(53149253932960338)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(53149542758960341)
,p_event_id=>wwv_flow_api.id(53149474744960340)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(53150170009960347)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Approve Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'if :P7_ROLE_DESC = ''Treasury'' and (:P7_EMIRATES_ID is null or :P7_RECEIVING_PERSON_NAME is null)',
'    Then ',
'         apex_error.add_error(p_message => ''Please fill in the receiving name and his/her Emirates ID. '',',
'                                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'   else                                     ',
'',
'manager_check_workflow.approve(:P7_CHECK_ID ,  :PERSON_ID, :P7_COMMENT);',
'end if;',
'end;'))
,p_process_error_message=>'you can''t Approve, Contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(53149656261960342)
,p_process_success_message=>'Approved Successfully'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(53150202223960348)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Reject Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'if :P7_COMMENT is null Then ',
'      ',
'                    apex_error.add_error(p_message => ''Please tell us the rejection reason. '',',
'                                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'                ELSe',
'manager_check_workflow.reject(:P7_CHECK_ID ,  :PERSON_ID, :P7_COMMENT);',
'',
'',
'end if;',
'',
'end;'))
,p_process_error_message=>'you can''t reject, Contact System Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(53149825942960344)
,p_process_success_message=>'Rejected'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(53150384590960349)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'DELEGATE Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'if :P7_TO_PERSON_ID is null Then ',
'      ',
'                    apex_error.add_error(p_message => ''Please select the delegated employee.. '',',
'                                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'                ELSe',
'',
'manager_check_workflow.delegate(:P7_CHECK_ID ,  :PERSON_ID, :P7_TO_PERSON_ID,:P7_COMMENT);',
'manager_check_emails.SEND_DELEGATE_EMAIL(:P7_CHECK_ID ,:PERSON_ID, :P7_TO_PERSON_ID,:P7_COMMENT,:P7_HISTORY_ID);',
'',
'end if;',
'',
'end;'))
,p_process_error_message=>'you can''t delegate, Contact System Admin'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(53149720865960343)
,p_process_success_message=>'Delegated Successfully'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(53298510766558608)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Withdraw Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'if :P7_COMMENT is null Then ',
'      ',
'                    apex_error.add_error(p_message => ''Please tell us the Withdraw reason '',',
'                                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'                ELSe',
'',
'manager_check_workflow.Withdraw (:P7_CHECK_ID , :P7_COMMENT);',
'',
'end if;',
'',
'end;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(53298453451558607)
);
wwv_flow_api.component_end;
end;
/
