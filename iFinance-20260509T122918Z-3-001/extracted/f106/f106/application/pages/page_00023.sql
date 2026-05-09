prompt --application/pages/page_00023
begin
--   Manifest
--     PAGE: 00023
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>227103249168277234
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>23
,p_user_interface_id=>wwv_flow_api.id(12983317716762193)
,p_name=>'Confirm Mission Submission'
,p_alias=>'CONFIRM-MISSION-SUBMISSION'
,p_page_mode=>'MODAL'
,p_step_title=>'Confirm Mission Submission'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230525193637'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208418669530532)
,p_plug_name=>'BUTTON'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noBorder'
,p_plug_template=>wwv_flow_api.id(12872392429762094)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(246429890595704)
,p_plug_name=>'Confirm'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p style="text-align:left"><span style="color:#0000cc"><span style="font-family:Tahoma,Geneva,sans-serif"><em><span style="font-size:11pt">This is to acknowledge that the mission aligns with my Job responsibilities &amp; objective at the Department o'
||'f Culture &amp; Tourism.</span></em></span></span></p>',
'',
'<p style="text-align:left"><span style="color:#0000cc"><span style="font-family:Tahoma,Geneva,sans-serif"><em><span style="font-size:11pt">And I&#39;m aware that my attendance to the program as per the schedule should be fulfilled.</span></em></span>'
||'</span></p>',
'',
'<p><span style="color:#0000cc"><span style="font-family:Tahoma,Geneva,sans-serif"><em><span style="font-size:12pt"><span style="font-size:10.5pt">Any deviation may result in financial or disciplinary action.</span></span></em></span></span></p>'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P23_CONFIRMED_STATUS'
,p_plug_display_when_cond2=>'Not Confirmed'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(4997139367410351)
,p_plug_name=>'Confirm-Submitted'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_source=>'Request# &P23_REQUEST_NUMBER. is &P23_CONFIRMED_STATUS.'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P23_CONFIRMED_STATUS'
,p_plug_display_when_cond2=>'Confirmed'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(208194842530530)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(208418669530532)
,p_button_name=>'Cancel'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'No, Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(208327696530531)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(208418669530532)
,p_button_name=>'SUBMIT'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Submit'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P23_CONFIRMED_STATUS'
,p_button_condition2=>'Not Confirmed'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(249566179573024)
,p_branch_name=>'Go to 13'
,p_branch_action=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.::REQUEST_ID:&P23_REQUEST_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(208327696530531)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208593547530534)
,p_name=>'P23_REQUEST_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(208418669530532)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4997030088410350)
,p_name=>'P23_CONFIRMED_STATUS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(208418669530532)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4997233325410352)
,p_name=>'P23_REQUEST_NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(208418669530532)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(208079669530529)
,p_name=>'Cancel DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(208194842530530)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(208057072530528)
,p_event_id=>wwv_flow_api.id(208079669530529)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(207886594530527)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Submit Confirm Process'
,p_process_sql_clob=>'MISSION_WORKFLOW.SUBMIT_CONFIRM(:P23_REQUEST_ID , :PERSON_ID);'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(208327696530531)
,p_process_success_message=>'Submitted'
);
wwv_flow_api.component_end;
end;
/
