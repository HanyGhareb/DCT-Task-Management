prompt --application/pages/page_00019
begin
--   Manifest
--     PAGE: 00019
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>19
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'CWIP Payment Recommendation  Approval Delegation'
,p_alias=>'CWIP-PAYMENT-RECOMMENDATION-APPROVAL-DELEGATION'
,p_step_title=>'CWIP Payment Recommendation  Approval Delegation'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210212004116'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(47586355698656213)
,p_plug_name=>'Select the employee'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(20929519566406529)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(47586355698656213)
,p_button_name=>'Delegate'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Delegate'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(20929935703406529)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(47586355698656213)
,p_button_name=>'Cancel'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10307273349597826)
,p_button_image_alt=>'Cancel'
,p_button_position=>'BELOW_BOX'
,p_button_redirect_url=>'f?p=&APP_ID.:15:&SESSION.::&DEBUG.:15:P15_PAYMENT_RECOMMENDATION_ID:&P19_ID.'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(20933549804406535)
,p_branch_name=>'Go To 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20930310557406529)
,p_name=>'P19_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(47586355698656213)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20930799996406531)
,p_name=>'P19_FROM_PERSON_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(47586355698656213)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20931110832406531)
,p_name=>'P19_TO_PERSON_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(47586355698656213)
,p_prompt=>'Delegated To'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'Employees Name By Person IDs  LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en , person_id',
'from dct_employees_list2'))
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(10306252784597823)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21961864523318806)
,p_name=>'P19_COMMENT'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(47586355698656213)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21961985837318807)
,p_name=>'P19_HSITORY_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(47586355698656213)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(20931535876406533)
,p_name=>'Delegation DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(20929519566406529)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(20932003980406534)
,p_event_id=>wwv_flow_api.id(20931535876406533)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure that you want to delegate this approval for this Payment Recommendation ?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(20932593126406534)
,p_event_id=>wwv_flow_api.id(20931535876406533)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'cwip_rec_payment_workflow.DELEGATE(:P19_ID ,:PERSON_ID , :P19_TO_PERSON_ID);',
'',
'end;'))
,p_attribute_02=>'P19_ID,PERSON_ID,P19_TO_PERSON_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(20933003859406534)
,p_event_id=>wwv_flow_api.id(20931535876406533)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(21962125170318809)
,p_name=>'New'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(20929519566406529)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(21962043565318808)
,p_event_id=>wwv_flow_api.id(21962125170318809)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update cwip_payment_rec_approval_history',
'set comments = :P19_COMMENT',
'where id = :P19_HSITORY_ID',
'and status = ''Pending'';',
''))
,p_attribute_02=>'P19_HSITORY_ID,P19_COMMENT'
,p_wait_for_result=>'Y'
);
wwv_flow_api.component_end;
end;
/
