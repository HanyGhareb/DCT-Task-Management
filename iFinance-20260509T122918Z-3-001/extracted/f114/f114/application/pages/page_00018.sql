prompt --application/pages/page_00018
begin
--   Manifest
--     PAGE: 00018
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
 p_id=>18
,p_user_interface_id=>wwv_flow_api.id(52958449993734913)
,p_name=>'Void Cheqeue Confirmation'
,p_alias=>'CANCEL-CHEQEUE-CONFIRMATION'
,p_page_mode=>'MODAL'
,p_step_title=>'Force Void Cheqeue Confirmation'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230125045625'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138257998672279242)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noBorder'
,p_plug_template=>wwv_flow_api.id(52847423684734857)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138822196643501110)
,p_plug_name=>'Confirm'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(52873880343734866)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(138258127307279244)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(138257998672279242)
,p_button_name=>'No'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(52936058388734896)
,p_button_image_alt=>'No'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(138258053481279243)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(138257998672279242)
,p_button_name=>'Yes'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(52936058388734896)
,p_button_image_alt=>'Yes'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_icon_css_classes=>'fa-check'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(138258509080279248)
,p_branch_name=>'Go To 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138257686991279239)
,p_name=>'P18_CHECK_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(138822196643501110)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138257759350279240)
,p_name=>'P18_CHECK_NO'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(138822196643501110)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138257858653279241)
,p_name=>'P18_VENDOR'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(138822196643501110)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138258397259279246)
,p_name=>'P18_COMMENT'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(138822196643501110)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>50
,p_cHeight=>5
,p_field_template=>wwv_flow_api.id(52934852790734894)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138258603852279249)
,p_name=>'P18_STATUS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(138822196643501110)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(144111332259970213)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(138258127307279244)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144111441286970214)
,p_event_id=>wwv_flow_api.id(144111332259970213)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(138258400131279247)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Void Check Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_STATUS    varchar2(50);',
'begin',
'',
'select STATUS',
'into l_STATUS',
'from manager_checks',
'where id = :P18_CHECK_ID;',
'',
'if l_STATUS in (''Hold'' , ''Withdraw'' ,''In-Progress'' , ''Voiding'') ',
'    Then   ',
'-- do Withdraw',
'if (l_status not in (''Withdraw'',''Hold'') )Then',
'manager_check_workflow.Withdraw(:P18_CHECK_ID , :P18_COMMENT);',
'End if;',
'    update manager_checks',
'    set ',
' --   cancel_by = :PERSON_ID',
' -- , cancel_on = SYSTIMESTAMP ',
' -- , cancel_reason = :P18_COMMENT',
'          STATUS = ''Void''',
'        , VOID_REASON = :P18_COMMENT',
'        , VOID_BY = :PERSON_ID',
'    where id = :P18_CHECK_ID ;',
'',
'    INSERT INTO manager_checks_approval_history (',
'        check_id,',
'        step_no,',
'        person_id,',
'        role_id,',
'        role_desc,',
'        action_required,',
'        recevied_date,',
'        status,',
'        action_date,',
'        approval_type,',
'        COMMENTS',
'    ) VALUES (',
'        :P18_CHECK_ID,',
'        manager_check_workflow.get_max_step(:P18_CHECK_ID) + 1,',
'        NV(''PERSON_ID''),     -- APPLICATION ITEM',
'        NULL,',
'        Null,       --''Requestor'',  ',
'        Null,   --''Re-submit'',',
'        systimestamp,',
'        ''Void'',',
'        systimestamp,',
'        ''MANAGER_CHECK_APPROVAL'',',
'        :P18_COMMENT',
'    );',
'',
'end if;',
'',
'End;'))
,p_process_error_message=>'Check &P18_CHECK_NO. Not Void.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(138258053481279243)
,p_process_success_message=>'Check &P18_CHECK_NO. Voided Successfully.'
);
wwv_flow_api.component_end;
end;
/
