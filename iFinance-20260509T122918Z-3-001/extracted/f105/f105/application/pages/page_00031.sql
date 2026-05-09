prompt --application/pages/page_00031
begin
--   Manifest
--     PAGE: 00031
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
 p_id=>31
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Delegation Managment Action'
,p_alias=>'DELEGATION-MANAGMENT-ACTION'
,p_page_mode=>'MODAL'
,p_step_title=>'Delegation Managment Action'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230523195318'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(104389009354222851)
,p_plug_name=>'New'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(113980471262498817)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(104389009354222851)
,p_button_name=>'No'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'No'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-remove'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(113980394170498816)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(104389009354222851)
,p_button_name=>'Yes'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Yes'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113980844462498821)
,p_name=>'P31_REQUEST_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(104389009354222851)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113980735507498820)
,p_name=>'P31_PERSON_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(104389009354222851)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113980646682498819)
,p_name=>'P31_EMPLOYEE_NAME'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(104389009354222851)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113980615846498818)
,p_name=>'P31_TYPE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(104389009354222851)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113980041250498813)
,p_name=>'P31_DELEGATE_TO'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(104389009354222851)
,p_prompt=>'Delegate To'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_display_when=>':P31_TYPE in (''D'', ''DBP'')'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(105997821746455694)
,p_name=>'P31_HISTORY_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(104389009354222851)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(105997687085455693)
,p_name=>'P31_COMMENTS'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(104389009354222851)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>2
,p_display_when=>':P31_TYPE in (''D'', ''DBP'')'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(113980297471498815)
,p_name=>'Execute Action DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(113980394170498816)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(113980213903498814)
,p_event_id=>wwv_flow_api.id(113980297471498815)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P31_TYPE = ''R''',
'    Then ',
'        BTF_EU_EMAIL.ACTION_REQUIRED_BTF_END_USER_EMAIL(:P31_REQUEST_ID , :P31_PERSON_ID, ''REMINDER_BTF_ACTION_REQUIRED'', :P31_HISTORY_ID, null, ''Y'');',
'        apex_mail.push_queue();',
'   elsif ',
'       :P31_TYPE = ''D''',
'           Then',
'                BTF_EU_WORKFLOW.DELEGATE(:P31_REQUEST_ID , :P31_PERSON_ID, :P31_DELEGATE_TO , :P31_COMMENTS, ''S'');',
'',
'      -- For Budget Proposal',
'      elsif ',
'       :P31_TYPE = ''RBP''        --Reminder Budget Proposal (Cost Center Plan)',
'           Then',
'                BUDGET_PROPOSAL_EMAIL.ACTION_REQUIRED_CC_PLAN_EMAIL(:P31_REQUEST_ID , :P31_PERSON_ID, ''ACTION_REQUIRED_BUDGET_PROPOSAL_CC_APPROVE_REJECT'', :P31_HISTORY_ID, null, ''Y'');',
'       elsif ',
'       :P31_TYPE = ''DBP''    --Delegate Budget Proposal (Cost Center Plan)',
'           Then',
'                BUDGET_PROPOSAL_WORKFLOW.DELEGATE(:P31_REQUEST_ID , :P31_PERSON_ID, :P31_DELEGATE_TO , :P31_COMMENTS, ''S'');',
'',
'End if;',
''))
,p_attribute_02=>'P31_REQUEST_ID,P31_PERSON_ID,P31_HISTORY_ID,P31_TYPE,P31_DELEGATE_TO,P31_COMMENTS'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(113979740178498810)
,p_event_id=>wwv_flow_api.id(113980297471498815)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(113979991386498812)
,p_name=>'Close'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(113980471262498817)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(113979836389498811)
,p_event_id=>wwv_flow_api.id(113979991386498812)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.component_end;
end;
/
