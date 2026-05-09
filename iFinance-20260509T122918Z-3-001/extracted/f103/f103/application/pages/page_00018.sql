prompt --application/pages/page_00018
begin
--   Manifest
--     PAGE: 00018
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>116806299474925354
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>18
,p_user_interface_id=>wwv_flow_api.id(23921013981372477)
,p_name=>'Send Pending Reminder'
,p_alias=>'SEND-PENDING-REMINDER'
,p_page_mode=>'MODAL'
,p_step_title=>'Send Pending Reminder'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210912103116'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(5782026727210581)
,p_plug_name=>'New'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--stacked:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>'you are going to send reminder email to: <b><span style="font-style: bold;font-size: 16px;">&P18_EMPLOYEE_NAME.</span></b> Are you sure?'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(76119380526085641)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(5782026727210581)
,p_button_name=>'No'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_image_alt=>'No, Don''t Send'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-remove'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(76118915311085640)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(5782026727210581)
,p_button_name=>'Yes'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Yes, Send'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76118595346085638)
,p_name=>'P18_REQUEST_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(5782026727210581)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76118130294085637)
,p_name=>'P18_EMPLOYEE_NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(5782026727210581)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76117769935085637)
,p_name=>'P18_EMPLOYEE_NAME'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(5782026727210581)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76117370748085637)
,p_name=>'P18_TYPE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(5782026727210581)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76112415735012552)
,p_name=>'P18_PERSON_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(5782026727210581)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(76116961678085633)
,p_name=>'Close'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(76119380526085641)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76116460887085632)
,p_event_id=>wwv_flow_api.id(76116961678085633)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(76116073185085632)
,p_name=>'Send Reminder'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(76118915311085640)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76115549603085632)
,p_event_id=>wwv_flow_api.id(76116073185085632)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P18_TYPE = ''CCR''',
'    Then ',
'        credit_cards_emails.send_Remider_email(:P18_REQUEST_ID , :P18_PERSON_ID);',
'        apex_mail.push_queue();',
'--    elsif :P55_TYPE = ''E''',
'--        Then',
'--            expense_report_emails.approve_reject_remider_send_email(:P55_REQUEST_ID ,:P55_EMPLOYEE_NUMBER);',
'End if;',
''))
,p_attribute_02=>'P18_TYPE,P18_REQUEST_ID,P18_PERSON_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76115079430085632)
,p_event_id=>wwv_flow_api.id(76116073185085632)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.component_end;
end;
/
