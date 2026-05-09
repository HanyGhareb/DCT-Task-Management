prompt --application/pages/page_00075
begin
--   Manifest
--     PAGE: 00075
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
 p_id=>75
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'Send DP Items SoW Reminder'
,p_alias=>'SEND-DP-ITEMS-SOW-REMINDER'
,p_page_mode=>'MODAL'
,p_step_title=>'Send DP Items SoW Reminder'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230313112923'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11479733982932252)
,p_plug_name=>'Details'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--stacked:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11480750423932262)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(11479733982932252)
,p_button_name=>'No'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'No'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-remove'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11480390872932258)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(11479733982932252)
,p_button_name=>'Yes'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Yes, Send'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_icon_css_classes=>'fa-envelope-check'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(11784195885846440)
,p_branch_name=>'Go to 77'
,p_branch_action=>'f?p=&APP_ID.:77:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(11480390872932258)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11479923476932253)
,p_name=>'P75_ITEM_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(11479733982932252)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11479967395932254)
,p_name=>'P75_CONFIRM'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(11479733982932252)
,p_prompt=>'Confirm'
,p_source=>'you are going to send reminder email to: <b><span style="font-style: bold;font-size: 16px;">&P75_BUSINESS_OWNER.</span></b> Are you sure?'
,p_source_type=>'STATIC'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11480039090932255)
,p_name=>'P75_BUSINESS_OWNER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(11479733982932252)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11480136396932256)
,p_name=>'P75_PERSON_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(11479733982932252)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11480283311932257)
,p_name=>'P75_COMMENT'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(11479733982932252)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>wwv_flow_api.id(127864805862449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(11480480136932259)
,p_name=>'Send Reminder DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(11480390872932258)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(11480547223932260)
,p_event_id=>wwv_flow_api.id(11480480136932259)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DP_ITEMS_EMAIL.REMINDER_EMAIL(:P75_ITEM_ID,:P75_PERSON_ID,''REMINDER_DP_ITEM'',null,:P75_COMMENT , ''N'');',
'',
'INSERT INTO dp_items_reminders (',
'    item_id,',
'    person_id,',
'    reminder_type,',
'    comments',
') VALUES (',
'    :P75_ITEM_ID,',
'    :P75_PERSON_ID,',
'    ''M'',',
'    :P75_COMMENT',
');'))
,p_attribute_02=>'P75_ITEM_ID,P75_PERSON_ID,P75_COMMENT'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(11480853639932263)
,p_name=>'Close DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(11480750423932262)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(11480958056932264)
,p_event_id=>wwv_flow_api.id(11480853639932263)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.component_end;
end;
/
