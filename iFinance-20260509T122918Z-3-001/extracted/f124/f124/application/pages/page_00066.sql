prompt --application/pages/page_00066
begin
--   Manifest
--     PAGE: 00066
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
 p_id=>66
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'Scoping document Action'
,p_alias=>'SCOPING-DOCUMENT-ACTION'
,p_page_mode=>'MODAL'
,p_step_title=>'Scoping document Action'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231210182426'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3918806922208459)
,p_plug_name=>'New'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(286449142691829236)
,p_plug_name=>'Timelines'
,p_parent_plug_id=>wwv_flow_api.id(3918806922208459)
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent5:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P66_ROLE_ID = 108 and :P66_ACTION = ''Approve'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3919674931208468)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127777381735449810)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3980902970351088)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_api.id(3919674931208468)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3979058094344356)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(3919674931208468)
,p_button_name=>'Approve'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Approve'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P66_ACTION'
,p_button_condition2=>'Approve'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-thumbs-o-up'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3979402849346786)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(3919674931208468)
,p_button_name=>'Reject'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--danger:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Reject'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P66_ACTION'
,p_button_condition2=>'Reject'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-thumbs-o-down'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3979656095347661)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(3919674931208468)
,p_button_name=>'Delegate'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Delegate'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P66_ACTION'
,p_button_condition2=>'Delegate'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-sign-language'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3979941623348496)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(3919674931208468)
,p_button_name=>'Return'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Return'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P66_ACTION'
,p_button_condition2=>'Return'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3980231734349334)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(3919674931208468)
,p_button_name=>'Cancel'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P66_ACTION'
,p_button_condition2=>'CANCEL'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3980611583350323)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(3919674931208468)
,p_button_name=>'Withdraw'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Withdraw'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P66_ACTION'
,p_button_condition2=>'Withdraw'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-undo'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(3920427046208475)
,p_branch_name=>'Go To Home'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3918861237208460)
,p_name=>'P66_ACTION'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(3918806922208459)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3918992895208461)
,p_name=>'P66_ROLE_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(3918806922208459)
,p_use_cache_before_default=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ROLE_ID ',
'from dp_scoping_approval_history',
'where id = :P66_HISTORY_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3919069872208462)
,p_name=>'P66_TO_PERSON_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(3918806922208459)
,p_prompt=>'Delegate To'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e',
'where person_id > 10'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_display_when=>'P66_ACTION'
,p_display_when2=>'Delegate'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3919151789208463)
,p_name=>'P66_COMMENT'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(3918806922208459)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3919329424208464)
,p_name=>'P66_REQUEST_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(3918806922208459)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3919363046208465)
,p_name=>'P66_HISTORY_ID'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(3918806922208459)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3991457908494053)
,p_name=>'P66_EXPECTED_START_DATE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(286449142691829236)
,p_prompt=>'Expected Contract Start Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_02=>'+1d'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3991885487494053)
,p_name=>'P66_EXPECTED_END_DATE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(286449142691829236)
,p_prompt=>'Expected Contract End Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_02=>'+1d'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3992253702494053)
,p_name=>'P66_TENDER_START_DATE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(286449142691829236)
,p_prompt=>'Expected Tender start Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_02=>'+1d'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3992656457494053)
,p_name=>'P66_TENDER_END_DATE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(286449142691829236)
,p_prompt=>'Expected Tender End Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_02=>'+1d'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3993101057494053)
,p_name=>'P66_EXPECTED_CONTRACT_START_DATE'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(286449142691829236)
,p_prompt=>'Expected Contract Start Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3993482346494054)
,p_name=>'P66_EXPECTED_CONTRACT_END_DATE'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(286449142691829236)
,p_prompt=>'Expected Contract End Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_begin_on_new_line=>'N'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3919510378208466)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(3980902970351088)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3919576180208467)
,p_event_id=>wwv_flow_api.id(3919510378208466)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(3919813028208469)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Approved Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'if :P66_ROLE_ID = 108 ',
'    Then',
'     --   IF  (:P66_EXPECTED_START_DATE            is null  OR',
'    --        :P66_EXPECTED_END_DATE              is null  OR',
'    --        :P66_TENDER_START_DATE              is null  OR',
'    --        :P66_TENDER_END_DATE                is null  OR',
'   --         :P66_EXPECTED_CONTRACT_START_DATE   is null  OR',
'   --         :P66_EXPECTED_CONTRACT_END_DATE     is null  )',
'   --             Then',
'     --               apex_error.add_error (  p_message  => ''Please Enter  all required details''  ,',
'    --                                      p_display_location =>  apex_error.c_inline_with_field_and_notif',
'    --                                    );',
'    ',
'    --    else  ',
'              ',
'',
'            DP_SCOPING_WORKFLOW.APPROVE(:P66_REQUEST_ID , :PERSON_ID, :P66_COMMENT , ''S'');',
'            update dp_scoping_a',
'            set EXPECTED_START_DATE = :P66_EXPECTED_START_DATE,',
'                EXPECTED_END_DATE   = :P66_EXPECTED_END_DATE,',
'                TENDER_START_DATE   = :P66_TENDER_START_DATE,',
'                TENDER_END_DATE     =  :P66_TENDER_END_DATE,',
'                EXPECTED_CONTRACT_START_DATE = :P66_EXPECTED_CONTRACT_START_DATE,',
'                EXPECTED_CONTRACT_END_DATE  =  :P66_EXPECTED_CONTRACT_END_DATE',
'          where SCOPE_ID = :P66_REQUEST_ID;',
'            ',
'     --   End IF;  ',
'    else',
'         DP_SCOPING_WORKFLOW.APPROVE(:P66_REQUEST_ID , :PERSON_ID, :P66_COMMENT , ''S'');',
'End if;',
'END;'))
,p_process_error_message=>'Not Approved'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(3979058094344356)
,p_process_success_message=>'Approved Successfully'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(3919846720208470)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Reject Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'IF :P66_COMMENT  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please tell us why you want to Reject this request. ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'            DP_SCOPING_WORKFLOW.REJECT(:P66_REQUEST_ID , :PERSON_ID, :P66_COMMENT , ''S'');',
' End If;           ',
'',
'END;'))
,p_process_error_message=>'Not Rejected, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(3979402849346786)
,p_process_success_message=>'Rejected.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(3919968209208471)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delegated Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'DP_SCOPING_WORKFLOW.DELEGATE(:P66_REQUEST_ID ,',
'                         :PERSON_ID,',
'                         :P66_TO_PERSON_ID,',
'                         :P66_COMMENT , ',
'                         ''S'');',
'',
'',
'END;'))
,p_process_error_message=>'Not Delegated, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(3979656095347661)
,p_process_success_message=>'Delegated Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(3920034639208472)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Return Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'IF :P66_COMMENT  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please tell us why you want to Return this request. ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'            DP_SCOPING_WORKFLOW.RETURN_review(:P66_REQUEST_ID , :PERSON_ID, :P66_COMMENT , ''S'');',
' End If;           ',
'',
'END;'))
,p_process_error_message=>'Not Returned, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(3979941623348496)
,p_process_success_message=>'Returned Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(3920209844208473)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Cancel Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'    ',
'        IF :P66_COMMENT  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please tell us why you want to cancel this request. ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'            update dp_scoping_a',
'            set CANCEL_ON = SYSTIMESTAMP ,',
'            CANCELLED_BY = :PERSON_ID,',
'            CANCEL_REASON = :P12_COMMENT,',
'            REVIEW_STATUS = ''Cancel''',
'            where SCOPE_ID = :P66_REQUEST_ID;',
'            ',
'            delete from dp_scoping_approval_history',
'            where request_id = :P66_REQUEST_ID',
'            and ACTION_DATE is null;',
'',
'         End if;',
'',
'',
'END;'))
,p_process_error_message=>'Not Cancelled, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(3980231734349334)
,p_process_success_message=>'Cancelled Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(3920293313208474)
,p_process_sequence=>60
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Withdraw Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'    ',
'        IF :P66_COMMENT  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please tell us why you want to Withdraw this request. ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'            DP_SCOPING_WORKFLOW.STOP(:P66_REQUEST_ID,:PERSON_ID,:P66_COMMENT, ''S'');',
'         End if;',
'',
'',
'END;'))
,p_process_error_message=>'Not Withdrawal, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(3980611583350323)
,p_process_success_message=>'Withdraw Successfully.'
);
wwv_flow_api.component_end;
end;
/
