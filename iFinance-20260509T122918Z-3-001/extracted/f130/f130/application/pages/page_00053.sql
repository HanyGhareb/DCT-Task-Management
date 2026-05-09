prompt --application/pages/page_00053
begin
--   Manifest
--     PAGE: 00053
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>53
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'Send Pending Reminder'
,p_alias=>'SEND-PENDING-REMINDER'
,p_page_mode=>'MODAL'
,p_step_title=>'Send Pending Reminder'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220210075851'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(14091629700170741)
,p_plug_name=>'New'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>'you are going to send email reminder to: <b><span style="font-style: bold;font-size: 16px;">&P53_EMPLOYEE_NAME.</span></b> Are you sure?'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(14092506950170750)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(14091629700170741)
,p_button_name=>'No'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'No, Don''t Send'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-remove'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(14092090855170746)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(14091629700170741)
,p_button_name=>'Yes'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'Yes, Send'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(14091693235170742)
,p_name=>'P53_P_PAYMENT_RECOMMENDATION_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(14091629700170741)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(14091776770170743)
,p_name=>'P53_P_PERSON_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(14091629700170741)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(14091917028170744)
,p_name=>'P53_P_PERSON_TYPE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(14091629700170741)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(14092034963170745)
,p_name=>'P53_P_HISTORY_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(14091629700170741)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(14092846915170753)
,p_name=>'P53_EMPLOYEE_NAME'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(14091629700170741)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(14092217435170747)
,p_name=>'Send Reminder DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(14092090855170746)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(14092928393170754)
,p_event_id=>wwv_flow_api.id(14092217435170747)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'cwip_rec_payment_emails.Remider_email(:P53_P_PAYMENT_RECOMMENDATION_ID, :P53_P_PERSON_ID,:P53_P_PERSON_TYPE, :P53_P_HISTORY_ID);',
'',
'INSERT INTO cwip_payment_rec_reminders (',
'    payment_recommendation_id,',
'    reminder_type,',
'    HISTORY_ID,',
'    PERSON_ID',
'--    comments,',
'--    updated_by,',
'--    updated_on',
'            ) VALUES (:P53_P_PAYMENT_RECOMMENDATION_ID,',
'                     ''S'',',
'                      :P53_P_HISTORY_ID,',
'                      :P53_P_PERSON_ID',
'            );',
''))
,p_attribute_02=>'P53_P_PAYMENT_RECOMMENDATION_ID,P53_P_PERSON_ID,P53_P_PERSON_TYPE,P53_P_HISTORY_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(14092361934170749)
,p_event_id=>wwv_flow_api.id(14092217435170747)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(14092578468170751)
,p_name=>'Close DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(14092506950170750)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(14092711738170752)
,p_event_id=>wwv_flow_api.id(14092578468170751)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.component_end;
end;
/
