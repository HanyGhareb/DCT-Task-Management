prompt --application/pages/page_00013
begin
--   Manifest
--     PAGE: 00013
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
 p_id=>13
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'BTF End User Transfer Approve/Reject Action'
,p_alias=>'BTF-END-USER-TRANSFER-APPROVE-REJECT-ACTION'
,p_page_mode=>'MODAL'
,p_step_title=>'BTF End User Transfer Approve/Reject Action'
,p_allow_duplicate_submissions=>'N'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231212083421'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(661699913463591)
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
 p_id=>wwv_flow_api.id(667269569550289)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99731046805410735)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(667338632550290)
,p_button_sequence=>80
,p_button_plug_id=>wwv_flow_api.id(667269569550289)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(453702257133433)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(667269569550289)
,p_button_name=>'Approve'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Approve'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P13_ACTION'
,p_button_condition2=>'Approve'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-thumbs-o-up'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(453847032133434)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(667269569550289)
,p_button_name=>'Reject'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--danger:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Reject'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P13_ACTION'
,p_button_condition2=>'Reject'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-thumbs-o-down'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(453927877133435)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(667269569550289)
,p_button_name=>'Delegate'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Delegate'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P13_ACTION'
,p_button_condition2=>'Delegate'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-sign-language'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(454125303133437)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(667269569550289)
,p_button_name=>'Return'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Return'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P13_ACTION'
,p_button_condition2=>'Return'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1359212923464782)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(667269569550289)
,p_button_name=>'Return_After'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Return To'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P13_ACTION'
,p_button_condition2=>'ReturnAfter'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(668544222550302)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(667269569550289)
,p_button_name=>'Cancel'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P13_ACTION'
,p_button_condition2=>'CANCEL'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(668839855550305)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_api.id(667269569550289)
,p_button_name=>'Withdraw'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Withdraw'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P13_ACTION'
,p_button_condition2=>'Withdraw'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-undo'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(1349283380912396)
,p_branch_name=>'Go To Page 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1359304287464783)
,p_name=>'P13_SELECTED_ROLE_ID'
,p_is_required=>true
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(661699913463591)
,p_prompt=>'Role'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ROLE_NAME , ROLE_ID ',
'FROM ROLES',
'WHERE ROLE_ID IN (SELECT DISTINCT ROLE_ID ',
'                    FROM btf_end_users_req_approval_history',
'                    WHERE 1=1',
'                    and ROLE_ID IN (76 , 81 ,82 , 110, 112, 73)',
'                    )',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_display_when=>'P13_ACTION'
,p_display_when2=>'ReturnAfter'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(453176808133428)
,p_name=>'P13_REQUEST_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(661699913463591)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(453359221133429)
,p_name=>'P13_HISTORY_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(661699913463591)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(453373458133430)
,p_name=>'P13_PERSON_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(661699913463591)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(453522634133431)
,p_name=>'P13_ROLE_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(661699913463591)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(453651276133432)
,p_name=>'P13_COMMENT'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(661699913463591)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(454011201133436)
,p_name=>'P13_ACTION'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(661699913463591)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(669321907550310)
,p_name=>'P13_TO_PERSON_ID'
,p_is_required=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(661699913463591)
,p_prompt=>'Name'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_display_when=>':P13_ACTION in (''Delegate'' , ''ReturnAfter'')'
,p_display_when_type=>'PLSQL_EXPRESSION'
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
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(667389653550291)
,p_name=>'Cancel DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(667338632550290)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(667542384550292)
,p_event_id=>wwv_flow_api.id(667389653550291)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(667651492550293)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Approve Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'BTF_EU_WORKFLOW.APPROVE(:P13_REQUEST_ID , :PERSON_ID, :P13_COMMENT , ''S'');',
'/*',
'if :P22_ROLE_ID = 150 Then ',
'    ',
'        IF :P22_AMOUNT  = :P22_AMOUNT_H2  Then ',
'    ',
'                    BTF_WORKFLOW.APPROVE(:P22_REQUEST_ID , :PERSON_ID, :P22_COMMENTS);',
'        else',
'                    apex_error.add_error (  p_message          => ''Please Allocate the whole requested amount '' || to_char(:P22_REQUIRED_AMOUNT , ''99,999,999,999.99'') ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'         End if;',
'   Else',
'   ',
'     BTF_WORKFLOW.APPROVE(:P22_REQUEST_ID , :PERSON_ID, :P22_COMMENTS);',
'     ',
'',
'End IF;',
'*/',
'',
'END;'))
,p_process_error_message=>'Not Approved, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(453702257133433)
,p_process_success_message=>'Approved Successfully'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(667728152550294)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Reject Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'IF :P13_COMMENT  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please tell us why you want to Reject this request. ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'            BTF_EU_WORKFLOW.REJECT(:P13_REQUEST_ID , :PERSON_ID, :P13_COMMENT , ''S'');',
' End If;           ',
'',
'END;'))
,p_process_error_message=>'Not Rejected, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(453847032133434)
,p_process_success_message=>'Rejected.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(667776751550295)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delegated Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'BTF_EU_WORKFLOW.DELEGATE(:P13_REQUEST_ID ,',
'                         :PERSON_ID,',
'                         :P13_TO_PERSON_ID,',
'                         :P13_COMMENT , ',
'                         ''S'');',
'',
'',
'END;'))
,p_process_error_message=>'Not Delegated, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(453927877133435)
,p_process_success_message=>'Delegated Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(667935205550296)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Return Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'IF :P13_COMMENT  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please tell us why you want to Return this request. ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'            BTF_EU_WORKFLOW.RETURN(:P13_REQUEST_ID , :PERSON_ID, :P13_COMMENT , ''S'');',
' End If;           ',
'',
'END;'))
,p_process_error_message=>'Not Returned, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(454125303133437)
,p_process_success_message=>'Returned Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1373584989382569)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Return After Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'IF :P13_COMMENT  is  null  Then ',
'                    apex_error.add_error (  p_message   => ''Please tell us why you want to Return this request. ''  ,',
'                                                          p_display_location =>  apex_error.c_inline_with_field_and_notif);',
'        else',
'            BTF_EU_WORKFLOW.RETURN_AFTER(:P13_REQUEST_ID , :P13_TO_PERSON_ID, :P13_COMMENT , ''S'', :P13_SELECTED_ROLE_ID);',
' End If;           ',
'',
'END;'))
,p_process_error_message=>'Not Returned, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(1359212923464782)
,p_process_success_message=>'Returned Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(668644196550303)
,p_process_sequence=>60
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Cancel Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'    ',
'        IF :P13_COMMENT  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please tell us why you want to cancel this request. ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'            update btf_end_users_header',
'            set CANCEL_ON = SYSTIMESTAMP ,',
'            CANCELLED_BY = :PERSON_ID,',
'            CANCEL_REASON = :P13_COMMENT,',
'            REQUEST_STATUS = ''Cancel''',
'            where REQUEST_ID = :P13_REQUEST_ID;',
'            ',
'            delete from btf_end_users_req_approval_history',
'            where request_id = :P13_REQUEST_ID',
'            and ACTION_DATE is null;',
'            ',
'            ',
'             -- INSERT NORMAL RECORD            ',
'    INSERT INTO btf_end_users_req_approval_history (',
'                                            request_id,',
'                                            step_no,',
'                                            person_id,',
'--                                            role_desc,',
'--                                            role_id,',
'--                                            action_required,',
'                                            recevied_date,',
'                                            status,',
'                                            action_date,',
'                                            approval_type_id,',
'                                            app_id,',
'                                            approval_type_code,',
'--                                            email,',
'                                            n_status',
'                                        ) VALUES (',
'                                            :P13_REQUEST_ID,',
'                                            BTF_EU_WORKFLOW.get_max_step(:P13_REQUEST_ID) + 1,',
'                                            :PERSON_ID,',
'--                                            ''Finance Director'',',
'--                                            79,     -- roleId for Finance Director',
'--                                            ''Approve/Reject'',',
'                                            systimestamp,',
'                                            ''Cancel'',',
'                                            systimestamp,',
'                                            82,',
'                                            nv(''APP_ID''),',
'                                            ''BTEU'',',
'--                                            user_details.get_finance_director_email(),',
'                                            null                 ',
'                                        );',
'            ',
'',
'         End if;',
'',
'',
'END;'))
,p_process_error_message=>'Not Cancelled, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(668544222550302)
,p_process_success_message=>'Cancelled Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(668955934550306)
,p_process_sequence=>70
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Withdraw Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'    ',
'        IF :P13_COMMENT  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please tell us why you want to Withdraw this request. ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'            BTF_EU_WORKFLOW.STOP(:P13_REQUEST_ID,:PERSON_ID,:P13_COMMENT, ''S'');',
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
,p_process_when_button_id=>wwv_flow_api.id(668839855550305)
,p_process_success_message=>'Withdraw Successfully.'
);
wwv_flow_api.component_end;
end;
/
