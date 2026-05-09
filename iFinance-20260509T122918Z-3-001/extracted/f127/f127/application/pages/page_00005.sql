prompt --application/pages/page_00005
begin
--   Manifest
--     PAGE: 00005
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>116
,p_default_id_offset=>191955104108672310
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>5
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Bank Guarantee Actions'
,p_alias=>'BANK-GUARANTEE-ACTIONS'
,p_page_mode=>'MODAL'
,p_step_title=>'Bank Guarantee Actions'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230930081009'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(743921468082579)
,p_plug_name=>'Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(744354888082579)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noBorder'
,p_plug_template=>wwv_flow_api.id(99731046805410735)
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(747533128105300)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_api.id(744354888082579)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P5_ACTION'
,p_button_condition2=>'Withdraw'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(746655369105291)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(744354888082579)
,p_button_name=>'Approve'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Approve'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P5_ACTION'
,p_button_condition2=>'Approve'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-thumbs-o-up'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(747028485105295)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(744354888082579)
,p_button_name=>'Reject'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--danger:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Reject'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P5_ACTION'
,p_button_condition2=>'Reject'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-thumbs-o-down'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(747156178105296)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(744354888082579)
,p_button_name=>'Delegate'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Delegate'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P5_ACTION'
,p_button_condition2=>'Delegate'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-sign-language'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(747265470105297)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(744354888082579)
,p_button_name=>'Return'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Return'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P5_ACTION'
,p_button_condition2=>'Return'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(747353213105298)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(744354888082579)
,p_button_name=>'Cancel'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P5_ACTION'
,p_button_condition2=>'CANCEL'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(747405300105299)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(744354888082579)
,p_button_name=>'Withdraw'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Withdraw'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P5_ACTION'
,p_button_condition2=>'Withdraw'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-undo'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(748568652105310)
,p_branch_name=>'Go to Main details 2 for Withdraw action'
,p_branch_action=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.::P2_BG_ID:&P5_REQUEST_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(747405300105299)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(749278030105317)
,p_branch_name=>'Go to Main details 2'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(691337347542035)
,p_name=>'P5_REQUEST_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(743921468082579)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(691454836542036)
,p_name=>'P5_ACTION'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(743921468082579)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(691559982542037)
,p_name=>'P5_PERSON_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(743921468082579)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(691680703542038)
,p_name=>'P5_ROLE_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(743921468082579)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(691762714542039)
,p_name=>'P5_TO_PERSON_ID'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(743921468082579)
,p_prompt=>'Delegate To'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_display_when=>'P5_ACTION'
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
,p_attribute_07=>'Delegate To'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(691845471542040)
,p_name=>'P5_COMMENT'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(743921468082579)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>2
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(747635278105301)
,p_name=>'Cancel DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(747533128105300)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(747795392105302)
,p_event_id=>wwv_flow_api.id(747635278105301)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(747989525105304)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Approve Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'BG_WORKFLOW.APPROVE(:P5_REQUEST_ID , :PERSON_ID, :P5_COMMENT , ''S'');',
'',
'',
'END;'))
,p_process_error_message=>'Not Approved, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(746655369105291)
,p_process_success_message=>'Approved Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(748084690105305)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Reject Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'IF :P5_COMMENT  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please tell us why you want to Reject this request. ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'            BG_WORKFLOW.REJECT(:P5_REQUEST_ID , :PERSON_ID, :P5_COMMENT , ''S'');',
' End If;           ',
'',
'END;'))
,p_process_error_message=>'Not Rejected, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(747028485105295)
,p_process_success_message=>'Rejected.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(748151805105306)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delegated Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'BG_WORKFLOW.DELEGATE(:P5_REQUEST_ID ,',
'                         :PERSON_ID,',
'                         :P5_TO_PERSON_ID,',
'                         :P5_COMMENT , ',
'                         ''S'');',
'',
'',
'END;'))
,p_process_error_message=>'Not Delegated, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(747156178105296)
,p_process_success_message=>'Delegated Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(748271586105307)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Return Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'IF :P5_COMMENT  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please tell us why you want to Return this request. ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'            BG_WORKFLOW.RETURN(:P5_REQUEST_ID , :PERSON_ID, :P5_COMMENT , ''S'');',
' End If;           ',
'',
'END;'))
,p_process_error_message=>'Not Returned, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(747265470105297)
,p_process_success_message=>'Returned Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(748363365105308)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Cancel Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'        IF :P5_COMMENT  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please tell us why you want to cancel this request. ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'            update bank_guarantee_all',
'            set CANCEL_ON = SYSTIMESTAMP ,',
'            CANCELLED_BY = :PERSON_ID,',
'            CANCEL_REASON = :P5_COMMENT,',
'            RECEIVING_STATUS = ''Cancel''',
'            where BG_ID = :P5_REQUEST_ID;',
'            ',
'            delete from bank_guarantee_all_approval_history',
'            where request_id = :P5_REQUEST_ID',
'            and ACTION_DATE is null;',
'            ',
'            ',
'             -- INSERT NORMAL RECORD    ',
'             INSERT INTO bank_guarantee_all_approval_history (',
'										request_id,',
'										step_no,',
'										person_id,',
'										role_desc,',
'										role_id,',
'										action_required,',
'										recevied_date,',
'										status,',
'										action_date,',
'										approval_type_id,',
'										app_id,',
'										approval_type_code,',
'										email,',
'										n_status,',
'										comments',
'						) VALUES (',
'									:P13_REQUEST_ID,',
'									 BG_WORKFLOW.get_max_step(:P5_REQUEST_ID) + 1,',
'									:PERSON_ID,',
'									null,',
'									null,',
'									''Cancel'',',
'									systimestamp,',
'									''Cancel'',',
'									systimestamp,',
'									null,  --  P_APPROVAL_TYPE_ID,',
'									nv(''APP_ID''),				-- nv(''APP_ID''),',
'									''BGAP'',	--	''BGAP'',    -- BANK GUARANTEE APPROVAL     ',
'									null,				--  user_details.get_emp_email(P_PERSON_ID),',
'									''Expired'',',
'									:P5_COMMENT',
'								);	',
'',
'         End if;',
'END;'))
,p_process_error_message=>'Not Cancelled, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(747353213105298)
,p_process_success_message=>'Cancelled Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(748470377105309)
,p_process_sequence=>60
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Withdraw Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'        IF :P5_COMMENT  is  null  Then ',
'                    apex_error.add_error ( p_message => ''Please tell us why you want to Withdraw this request. ''  ,',
'                                                     p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'            BG_WORKFLOW.STOP(:P5_REQUEST_ID,:PERSON_ID,:P5_COMMENT, ''S'');',
'         End if;',
'END;'))
,p_process_error_message=>'Not Withdrawal, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(747405300105299)
,p_process_success_message=>'Withdraw Successfully.'
);
wwv_flow_api.component_end;
end;
/
