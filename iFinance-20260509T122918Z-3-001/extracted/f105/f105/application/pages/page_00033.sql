prompt --application/pages/page_00033
begin
--   Manifest
--     PAGE: 00033
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
 p_id=>33
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'BTF Execution Confirmation'
,p_alias=>'BTF-EXECUTION-CONFIRMATION'
,p_page_mode=>'MODAL'
,p_step_title=>'BTF Execution Confirmation'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20221012050312'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(100821583675881311)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99731046805410735)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(100820477895881300)
,p_plug_name=>'Already Executed'
,p_region_template_options=>'#DEFAULT#:t-Alert--wizard:t-Alert--defaultIcons:t-Alert--success'
,p_plug_template=>wwv_flow_api.id(99726350799410732)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_source=>'Request# &P33_REQUEST_NUMBER. already process successfully.'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P33_REQUEST_STATUS'
,p_plug_display_when_cond2=>'Executed'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(100820131805881296)
,p_plug_name=>'New'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(100658512467960477)
,p_plug_name=>'Confirm'
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--wizard:t-Alert--defaultIcons:t-Alert--info'
,p_plug_template=>wwv_flow_api.id(99726350799410732)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_source=>'Are you Sure that &P33_REQUEST_NUMBER. Process successfully ? '
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P33_REQUEST_STATUS'
,p_plug_display_when_cond2=>'NA'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(100821365200881309)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(100821583675881311)
,p_button_name=>'No'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(100821438384881310)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(100821583675881311)
,p_button_name=>'Yes'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Yes'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P33_REQUEST_STATUS'
,p_button_condition2=>'NA'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-check'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(100820973650881305)
,p_branch_name=>'Go to 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(100821902232881314)
,p_name=>'P33_REQUEST_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(100820131805881296)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(100821637951881312)
,p_name=>'P33_REQUEST_NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(100820131805881296)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(100820808515881303)
,p_name=>'P33_REQUEST_STATUS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(100820131805881296)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(100821303552881308)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(100821365200881309)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(100821190474881307)
,p_event_id=>wwv_flow_api.id(100821303552881308)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(100821101041881306)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Yes Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update btf_end_users_header',
'set EXECUTED_YN = ''Y'' , EXECUTED_BY = :PERSON_ID, EXECUTED_ON = systimestamp',
'where request_id = :P33_REQUEST_ID;'))
,p_process_error_message=>'Not Processed'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(100821438384881310)
,p_process_success_message=>'Budget Transfer request Processed Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(100820005827881295)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Send Email'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'for emp in (select DISTINCT PERSON_ID',
'            from btf_end_users_req_approval_history',
'            where request_id = :P33_REQUEST_ID',
'            and ROLE_ID in (76 , 73)',
'            and STATUS in (''Submitted'' , ''Approved''))',
'Loop',
'',
'    BTF_EU_EMAIL.ACTION_REQUIRED_BTF_END_USER_EMAIL(:P33_REQUEST_ID , emp.person_id , ''FYI_END_USER_BUDGET_TRANSFER_PROCESS_SUCCESSFULLY'' , null,null,''N'');',
'End loop;    '))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(100821438384881310)
,p_process_success_message=>'Email Sent.'
);
wwv_flow_api.component_end;
end;
/
