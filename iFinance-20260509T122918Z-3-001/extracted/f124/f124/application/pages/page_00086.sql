prompt --application/pages/page_00086
begin
--   Manifest
--     PAGE: 00086
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
 p_id=>86
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'Delegation Managment Action'
,p_alias=>'DELEGATION-MANAGMENT-ACTION'
,p_page_mode=>'MODAL'
,p_step_title=>'Delegation Managment Action'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231210182426'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(114257714255497842)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noBorder'
,p_plug_template=>wwv_flow_api.id(127777381735449810)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3553335018477629)
,p_plug_name=>'New'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p><em>you are going to send reminder email to <strong>&P86_EMPLOYEE_NAME.</strong>, Are you sure?</em></p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(112447391140439395)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(114257714255497842)
,p_button_name=>'Yes'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Yes'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-envelope-check'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(112447826420439403)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(114257714255497842)
,p_button_name=>'No'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'No'
,p_button_position=>'BELOW_BOX'
,p_button_alignment=>'LEFT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-remove'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(112447015896439391)
,p_name=>'P86_REQUEST_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(3553335018477629)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(112446616546439385)
,p_name=>'P86_PERSON_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(3553335018477629)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(112446136660439385)
,p_name=>'P86_HISTORY_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(3553335018477629)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(112445786255439385)
,p_name=>'P86_EMPLOYEE_NAME'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(3553335018477629)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(112445382747439385)
,p_name=>'P86_TYPE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(3553335018477629)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(112444991764439385)
,p_name=>'P86_DELEGATE_TO'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(3553335018477629)
,p_prompt=>'Delegate To'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e',
'where person_id > 10'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_display_when=>':P86_TYPE in (''D'', ''DBP'')'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(112444539417439384)
,p_name=>'P86_COMMENTS'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(3553335018477629)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>2
,p_display_when=>':P86_TYPE in (''D'', ''DBP'')'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(111775120558647868)
,p_name=>'P86_ACTION_FOR'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(3553335018477629)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(112444153448439374)
,p_name=>'Execute Action DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(112447391140439395)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(112443674871439373)
,p_event_id=>wwv_flow_api.id(112444153448439374)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'CASE :P86_ACTION_FOR  ',
'    WHEN ''DP'' THEN',
'                if :P86_TYPE = ''R''',
'                    Then ',
'                        DP_ITEMS_EMAIL.REMINDER_EMAIL(:P86_REQUEST_ID , :P86_PERSON_ID, ''REMINDER_DP_ITEM_ACTION_REQUIRED'', :P86_HISTORY_ID, null, ''Y'');',
'                        apex_mail.push_queue();',
'                   elsif ',
'                       :P86_TYPE = ''D''',
'                           Then',
'                                DP_ITEMS_WORKFLOW.DELEGATE(:P86_REQUEST_ID , :P86_PERSON_ID, :P86_DELEGATE_TO , :P86_COMMENTS, ''S'');',
'        ',
'                End if;',
'    WHEN ''SD'' THEN',
'                if :P86_TYPE = ''R''',
'                    Then ',
'                        DP_SCOPING_EMAIL.REMINDER_EMAIL(:P86_REQUEST_ID , :P86_PERSON_ID, ''REMINDER_SD_ACTION_REQUIRED'', :P86_HISTORY_ID, null, ''Y'');',
'                        apex_mail.push_queue();',
'                   elsif ',
'                       :P86_TYPE = ''D''',
'                           Then',
'                                DP_SCOPING_WORKFLOW.DELEGATE(:P86_REQUEST_ID , :P86_PERSON_ID, :P86_DELEGATE_TO , :P86_COMMENTS, ''S'');',
'        ',
'                End if;',
'END CASE;',
'',
''))
,p_attribute_02=>'P86_REQUEST_ID,P86_PERSON_ID,P86_HISTORY_ID,P86_TYPE,P86_DELEGATE_TO,P86_COMMENTS'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(112443143405439372)
,p_event_id=>wwv_flow_api.id(112444153448439374)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(112442796983439372)
,p_name=>'Close'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(112447826420439403)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(112442238383439372)
,p_event_id=>wwv_flow_api.id(112442796983439372)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.component_end;
end;
/
