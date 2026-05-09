prompt --application/pages/page_00030
begin
--   Manifest
--     PAGE: 00030
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>142
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>30
,p_user_interface_id=>wwv_flow_api.id(159947477385220145)
,p_name=>'Request Approve/Reject Action'
,p_alias=>'REQUEST-APPROVE-REJECT-ACTION'
,p_page_mode=>'MODAL'
,p_step_title=>'Request Approve/Reject Action'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231221095011'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(211589393154224117)
,p_plug_name=>'Hidden'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(159862875324220071)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(211589770802224117)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noBorder'
,p_plug_template=>wwv_flow_api.id(159836481875220060)
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(211494349297005115)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_api.id(211589770802224117)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(159925091859220123)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(211493778636005109)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(211589770802224117)
,p_button_name=>'Approve'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(159925091859220123)
,p_button_image_alt=>'Approve'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P30_ACTION'
,p_button_condition2=>'Approve'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-thumbs-o-up'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(211493900618005111)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(211589770802224117)
,p_button_name=>'Reject'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--danger:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(159925091859220123)
,p_button_image_alt=>'Reject'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P30_ACTION'
,p_button_condition2=>'Reject'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-thumbs-o-down'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(211494081845005112)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(211589770802224117)
,p_button_name=>'Withdraw'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(159925091859220123)
,p_button_image_alt=>'Withdraw'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P30_ACTION'
,p_button_condition2=>'Withdraw'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-undo'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(214662023198567245)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(211589770802224117)
,p_button_name=>'Cancel'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(159925091859220123)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P30_ACTION'
,p_button_condition2=>'Cancel'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-undo'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(211494125831005113)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(211589770802224117)
,p_button_name=>'Delegate'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(159925091859220123)
,p_button_image_alt=>'Delegate'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P30_ACTION'
,p_button_condition2=>'Delegate'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-sign-language'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(211494262438005114)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(211589770802224117)
,p_button_name=>'Return'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(159925091859220123)
,p_button_image_alt=>'Return'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P30_ACTION'
,p_button_condition2=>'Return'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(211495807127005130)
,p_branch_name=>'Go to Home 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211493431860005106)
,p_name=>'P30_REQUEST_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(211589393154224117)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211493524386005107)
,p_name=>'P30_REQUEST_NO'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(211589393154224117)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211493605454005108)
,p_name=>'P30_COMMENT'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(211589393154224117)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>2
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211493841749005110)
,p_name=>'P30_ACTION'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(211589393154224117)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211494664522005118)
,p_name=>'P30_TO_PERSON_ID'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(211589393154224117)
,p_prompt=>'Delegate To'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_display_when=>'P30_ACTION'
,p_display_when2=>'Delegate'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211494774338005119)
,p_name=>'P30_REQUEST_TYPE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(211589393154224117)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
,p_item_comment=>'VR - BM - PACOF - VO'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211494903629005121)
,p_name=>'P30_HISTORY_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(211589393154224117)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(211494444528005116)
,p_name=>'Cancel DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(211494349297005115)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(211494507623005117)
,p_event_id=>wwv_flow_api.id(211494444528005116)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(211495379168005125)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Approve Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'case :P30_REQUEST_TYPE ',
'    when ''VR'' then',
'                    VR_WORKFLOW2.APPROVE(:P30_REQUEST_ID, :PERSON_ID, :P30_COMMENT, ''S'');',
'                    ',
'   when ''BM'' then',
'                    BM_WORKFLOW.APPROVE(:P30_REQUEST_ID, :PERSON_ID, :P30_COMMENT, ''S'');',
'   when ''BACOF'' then',
'                    BACOF_WORKFLOW.APPROVE(:P30_REQUEST_ID, :PERSON_ID, :P30_COMMENT, ''S'');',
'    when ''VO'' then',
'                    VO_WORKFLOW.APPROVE(:P30_REQUEST_ID, :PERSON_ID, :P30_COMMENT, ''S'');',
'                  ',
'   end case;',
'        '))
,p_process_error_message=>'Not Approved.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(211493778636005109)
,p_process_success_message=>'Approved Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(211495470213005126)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Reject Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'IF :P30_COMMENT  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please specify rejection justification ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'                    else',
'',
'                      case :P30_REQUEST_TYPE ',
'                                when ''VR'' then',
'                                            VR_WORKFLOW2.REJECT(:P30_REQUEST_ID, :PERSON_ID, :P30_COMMENT, ''S'');',
'                                when ''BM'' then',
'                                            BM_WORKFLOW.REJECT(:P30_REQUEST_ID, :PERSON_ID, :P30_COMMENT, ''S'');',
'                                            ',
'                               when ''BACOF'' then',
'                                            BACOF_WORKFLOW.REJECT(:P30_REQUEST_ID, :PERSON_ID, :P30_COMMENT, ''S'');',
'                                when ''VO'' then',
'                                            VO_WORKFLOW.REJECT(:P30_REQUEST_ID, :PERSON_ID, :P30_COMMENT, ''S'');',
'                     ',
'                     end case;',
'end if;',
''))
,p_process_error_message=>'Not Rejected .'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(211493900618005111)
,p_process_success_message=>'Rejected.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(211495524126005127)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delegated Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'IF :P30_TO_PERSON_ID  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please select the employee. ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'                    else',
'',
'                      case :P30_REQUEST_TYPE ',
'                                when ''VR'' then',
'                                            VR_WORKFLOW2.DELEGATE(:P30_REQUEST_ID, :PERSON_ID, :P30_TO_PERSON_ID, :P30_COMMENT, ''S'');',
'                                when ''BM'' then',
'                                            BM_WORKFLOW.DELEGATE(:P30_REQUEST_ID, :PERSON_ID, :P30_TO_PERSON_ID, :P30_COMMENT, ''S'');',
'                               when ''BACOF'' then',
'                                            BACOF_WORKFLOW.DELEGATE(:P30_REQUEST_ID, :PERSON_ID, :P30_TO_PERSON_ID, :P30_COMMENT, ''S'');',
'                                when ''VO'' then',
'                                            VO_WORKFLOW.DELEGATE(:P30_REQUEST_ID, :PERSON_ID, :P30_TO_PERSON_ID, :P30_COMMENT, ''S'');',
'                     ',
'                     end case;',
'end if;'))
,p_process_error_message=>'Not Delegated.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(211494125831005113)
,p_process_success_message=>'Delegated Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(211495672566005128)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Return Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'IF :P30_COMMENT  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please specify return justification ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'                    else',
'',
'                      case :P30_REQUEST_TYPE ',
'                                when ''VR'' then',
'                                            VR_WORKFLOW2.RETURN(:P30_REQUEST_ID, :PERSON_ID, :P30_COMMENT, ''S'');',
'                                when ''BM'' then',
'                                            BM_WORKFLOW.RETURN(:P30_REQUEST_ID, :PERSON_ID, :P30_COMMENT, ''S'');',
'                               when ''BACOF'' then',
'                                            BACOF_WORKFLOW.RETURN(:P30_REQUEST_ID, :PERSON_ID, :P30_COMMENT, ''S'');',
'                                when ''VO'' then',
'                                            VO_WORKFLOW.RETURN(:P30_REQUEST_ID, :PERSON_ID, :P30_COMMENT, ''S'');',
'                     ',
'                     end case;',
'end if;'))
,p_process_error_message=>'Not Returned.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(211494262438005114)
,p_process_success_message=>'Returned Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(211495704056005129)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Withdraw Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'IF :P30_COMMENT  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please specify withdraw justification ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'                    else',
'',
'                      case :P30_REQUEST_TYPE ',
'                                when ''VR'' then',
'                                            VR_WORKFLOW2.STOP(:P30_REQUEST_ID, :PERSON_ID, :P30_COMMENT, ''S'');',
'                                when ''BM'' then',
'                                            BM_WORKFLOW.STOP(:P30_REQUEST_ID, :PERSON_ID, :P30_COMMENT, ''S'');',
'                               when ''BACOF'' then',
'                                            BACOF_WORKFLOW.STOP(:P30_REQUEST_ID, :PERSON_ID, :P30_COMMENT, ''S'');',
'                                when ''VO'' then',
'                                            VO_WORKFLOW.STOP(:P30_REQUEST_ID, :PERSON_ID, :P30_COMMENT, ''S'');',
'                     ',
'                     end case;',
'end if;',
'        '))
,p_process_error_message=>'Not Withdraw .'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(211494081845005112)
,p_process_success_message=>'Withdraw Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(214661928771567244)
,p_process_sequence=>60
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Cancel Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'IF :P30_COMMENT  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please specify withdraw justification ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'                    else',
'',
'                      case :P30_REQUEST_TYPE ',
'                                when ''VR'' then',
'                                            VR_WORKFLOW2.Cancel(:P30_REQUEST_ID, :PERSON_ID, :P30_COMMENT, ''S'');',
'                                when ''BM'' then',
'                                            BM_WORKFLOW.Cancel(:P30_REQUEST_ID, :PERSON_ID, :P30_COMMENT, ''S'');',
'                               when ''BACOF'' then',
'                                            BACOF_WORKFLOW.Cancel(:P30_REQUEST_ID, :PERSON_ID, :P30_COMMENT, ''S'');',
'                                when ''VO'' then',
'                                            VO_WORKFLOW.Cancel(:P30_REQUEST_ID, :PERSON_ID, :P30_COMMENT, ''S'');',
'                     ',
'                     end case;',
'end if;',
'        '))
,p_process_error_message=>'Not Cancelled.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(214662023198567245)
,p_process_success_message=>'Cancelled Successfully.'
);
wwv_flow_api.component_end;
end;
/
