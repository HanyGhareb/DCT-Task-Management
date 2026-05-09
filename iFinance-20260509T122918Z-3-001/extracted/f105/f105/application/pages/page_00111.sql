prompt --application/pages/page_00111
begin
--   Manifest
--     PAGE: 00111
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
 p_id=>111
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Budget Proposal Cost Center plan Approve/Reject Action'
,p_alias=>'BUDGET-PROPOSAL-COST-CENTER-PLAN-APPROVE-REJECT-ACTION'
,p_page_mode=>'MODAL'
,p_step_title=>'Budget Proposal Cost Center plan Approve/Reject Action'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230516194538'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(47243554089850623)
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(47023609621309552)
,p_plug_name=>'Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(47242396115850611)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(47243554089850623)
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
 p_id=>wwv_flow_api.id(47243436058850622)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(47243554089850623)
,p_button_name=>'Approve'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Approve'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P111_ACTION'
,p_button_condition2=>'Approve'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-thumbs-o-up'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(47242715354850614)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(47243554089850623)
,p_button_name=>'Reject'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--danger:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Reject'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P111_ACTION'
,p_button_condition2=>'Reject'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-thumbs-o-down'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(47242604121850613)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(47243554089850623)
,p_button_name=>'Delegate'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Delegate'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P111_ACTION'
,p_button_condition2=>'Delegate'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-sign-language'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(47242498482850612)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(47243554089850623)
,p_button_name=>'Return'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Return'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P111_ACTION'
,p_button_condition2=>'Return'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(47240905088850596)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(47243554089850623)
,p_button_name=>'Withdraw'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Withdraw'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P111_ACTION'
,p_button_condition2=>'Withdraw'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-undo'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(47241105105850598)
,p_branch_name=>'Go to 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47243383695850621)
,p_name=>'P111_REQUEST_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(47023609621309552)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47243298935850620)
,p_name=>'P111_ACTION'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(47023609621309552)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47243222060850619)
,p_name=>'P111_HISTORY_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(47023609621309552)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47243113533850618)
,p_name=>'P111_PERSON_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(47023609621309552)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47242970567850617)
,p_name=>'P111_ROLE_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(47023609621309552)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47242857954850616)
,p_name=>'P111_TO_PERSON_ID'
,p_is_required=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(47023609621309552)
,p_prompt=>'Delegate To'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_display_when=>'P111_ACTION'
,p_display_when2=>'Delegate'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47242759486850615)
,p_name=>'P111_COMMENT'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(47023609621309552)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>3
,p_field_template=>wwv_flow_api.id(99818469241410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(47242251007850610)
,p_name=>'Cancel DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(47242396115850611)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(47242139676850609)
,p_event_id=>wwv_flow_api.id(47242251007850610)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(47242042257850608)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Approve Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'BUDGET_PROPOSAL_WORKFLOW.APPROVE(:P111_REQUEST_ID, :PERSON_ID, :P111_COMMENT , ''S'' );',
'',
'End;'))
,p_process_error_message=>'Not Approved, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(47243436058850622)
,p_process_success_message=>'Approved Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(47241978080850607)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Reject Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'IF :P111_COMMENT  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please tell us why you want to Reject this request. ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'            BUDGET_PROPOSAL_WORKFLOW.REJECT(:P111_REQUEST_ID , :PERSON_ID, :P111_COMMENT , ''S'');',
' End If;           ',
'',
'END;'))
,p_process_error_message=>'Not Rejected, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(47242715354850614)
,p_process_success_message=>'Rejected.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(47241869164850606)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delegated Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'BUDGET_PROPOSAL_WORKFLOW.DELEGATE(:P111_REQUEST_ID ,',
'                                 :PERSON_ID,',
'                                 :P111_TO_PERSON_ID,',
'                                 :P111_COMMENT , ',
'                                 ''S'');',
'',
'',
'END;'))
,p_process_error_message=>'Not Delegated, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(47242604121850613)
,p_process_success_message=>'Delegated Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(47241820928850605)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Return Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'IF :P111_COMMENT  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please tell us why you want to Return this request. ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'            BUDGET_PROPOSAL_WORKFLOW.RETURN(:P111_REQUEST_ID , :PERSON_ID, :P111_COMMENT , ''S'');',
' End If;           ',
'',
'END;'))
,p_process_error_message=>'Not Returned, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(47242498482850612)
,p_process_success_message=>'Returned Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(47240761748850595)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Withdraw Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'    ',
'        IF :P111_COMMENT  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please tell us why you want to Withdraw the plan ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'            BUDGET_PROPOSAL_WORKFLOW.STOP(:P111_REQUEST_ID,:PERSON_ID,:P111_COMMENT, ''S'');',
'--            update btf_end_users_header',
'--            set',
'--           REQUEST_STATUS = ''Withdraw''',
'--            where REQUEST_ID = :P13_REQUEST_ID;',
'            ',
'--            update btf_end_users_req_approval_history ',
'--            set comments = :P13_COMMENT',
'--            where ID = :P13_HISTORY_ID;',
'            ',
'--            delete from btf_end_users_req_approval_history',
'--            where request_id = :P13_REQUEST_ID',
'--            and ACTION_DATE is null;',
'',
'         End if;',
'',
'',
'END;'))
,p_process_error_message=>'Not Withdrawal, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(47240905088850596)
,p_process_success_message=>'Withdraw Successfully.'
);
wwv_flow_api.component_end;
end;
/
