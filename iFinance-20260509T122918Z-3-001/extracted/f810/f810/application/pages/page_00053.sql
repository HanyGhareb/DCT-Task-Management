prompt --application/pages/page_00053
begin
--   Manifest
--     PAGE: 00053
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>53
,p_user_interface_id=>wwv_flow_api.id(12983317716762193)
,p_name=>'DT Execution Confirmation'
,p_alias=>'DT-EXECUTION-CONFIRMATION'
,p_page_mode=>'MODAL'
,p_step_title=>'DT Execution Confirmation'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231121221254'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(204160056611738221)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12872392429762094)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(204161162391738232)
,p_plug_name=>'Already Executed'
,p_region_template_options=>'#DEFAULT#:t-Alert--wizard:t-Alert--defaultIcons:t-Alert--success'
,p_plug_template=>wwv_flow_api.id(12867655137762088)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_source=>'Invoice# &P53_REQUEST_NUMBER. already process successfully.'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P53_REQUEST_STATUS'
,p_plug_display_when_cond2=>'Y'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(95287577365365063)
,p_plug_name=>'New'
,p_parent_plug_id=>wwv_flow_api.id(204161162391738232)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(204161508481738236)
,p_plug_name=>'New'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(204323127819659055)
,p_plug_name=>'Confirm'
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--wizard:t-Alert--defaultIcons:t-Alert--info'
,p_plug_template=>wwv_flow_api.id(12867655137762088)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_source=>'Are you Sure that &P53_REQUEST_NUMBER. invoice has been initiated successfully ? '
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P53_REQUEST_STATUS'
,p_plug_display_when_cond2=>'NA'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(95287388663365061)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(95287577365365063)
,p_button_name=>'Cancel_Invoice'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--danger:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Cancel Invoice'
,p_button_position=>'BELOW_BOX'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(91700658169434914)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(204160056611738221)
,p_button_name=>'No'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(91700317799434913)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(204160056611738221)
,p_button_name=>'Yes'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Yes'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P53_REQUEST_STATUS'
,p_button_condition2=>'NA'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-check'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(91702843884434920)
,p_branch_name=>'Go to 52'
,p_branch_action=>'f?p=&APP_ID.:52:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(91698508530434910)
,p_name=>'P53_REQUEST_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(204161508481738236)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(91698896538434912)
,p_name=>'P53_REQUEST_NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(204161508481738236)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(91699259933434912)
,p_name=>'P53_REQUEST_STATUS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(204161508481738236)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95287484738365062)
,p_name=>'P53_CANCEL_COMMENT'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(95287577365365063)
,p_prompt=>'Cancel Reason'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>wwv_flow_api.id(12959735177762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(91701901348434918)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(91700658169434914)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(91702376398434919)
,p_event_id=>wwv_flow_api.id(91701901348434918)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(91701083837434917)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Yes Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update MISSION_HEADER',
'set EXECUTED_Status = ''Y'' , EXECUTED_BY = :PERSON_ID, EXECUTED_ON = systimestamp',
'where request_id = :P53_REQUEST_ID;'))
,p_process_error_message=>'Not Processed'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(91700317799434913)
,p_process_success_message=>'Duty Travel request Processed Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(91701432598434917)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Send Email'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'for emp in (select DISTINCT PERSON_ID',
'            from btf_end_users_req_approval_history',
'            where request_id = :P53_REQUEST_ID',
'            and ROLE_ID in (76 , 73)',
'            and STATUS in (''Submitted'' , ''Approved''))',
'Loop',
'',
'    BTF_EU_EMAIL.ACTION_REQUIRED_BTF_END_USER_EMAIL(:P53_REQUEST_ID , emp.person_id , ''FYI_END_USER_BUDGET_TRANSFER_PROCESS_SUCCESSFULLY'' , null,null,''N'');',
'End loop;    '))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_type=>'NEVER'
,p_process_success_message=>'Email Sent.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(95287678511365064)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Cancel Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'IF :P53_CANCEL_COMMENT is null',
'        Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please enter the cancel reason . ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'        ',
'update MISSION_HEADER',
'set EXECUTED_Status = '''' , EXECUTED_BY = '''', EXECUTED_ON = '''' , PV_NUMBER = ''''',
'where request_id = :P53_REQUEST_ID;',
'',
'insert into MISSION_ACTIONS (REQUEST_ID , ACTION , COMMENTS) ',
'        values(:P53_REQUEST_ID , ''Cancel Invoice'' , :P53_CANCEL_COMMENT);',
'        ',
'End if;',
'End;',
'',
'',
''))
,p_process_error_message=>'No Cancel'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(95287388663365061)
,p_process_success_message=>'Cancelled.'
);
wwv_flow_api.component_end;
end;
/
