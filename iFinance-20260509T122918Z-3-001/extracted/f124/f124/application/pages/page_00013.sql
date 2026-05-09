prompt --application/pages/page_00013
begin
--   Manifest
--     PAGE: 00013
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
 p_id=>13
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'DP Item Submit Confirmation'
,p_alias=>'DP-ITEM-SUBMIT-CONFIRMATION'
,p_page_mode=>'MODAL'
,p_step_title=>'DP Item Submit Confirmation'
,p_allow_duplicate_submissions=>'N'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231209141858'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(128745028131293292)
,p_plug_name=>'Declaration'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p>Please note that as per Supply chain management SLA, you have <strong><span style="color: #0000ff;">&P11_SLA_DAYS. <span style="color: #000000;">days </span></span></strong><span style="color: #0000ff;"><span style="color: #000000;">to complete th'
||'e scope of work document</span></span>, Make sure to submit the Scoping document by: <strong><span style="color: #0000ff;">&P11_SLA_DATE.</span></strong></p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(128745489497293291)
,p_plug_name=>'Mission Supporting docuements'
,p_parent_plug_id=>wwv_flow_api.id(128745028131293292)
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--danger'
,p_plug_template=>wwv_flow_api.id(127772628480449819)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_source=>'Please attach the supporting documents.'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':L_DOC_COUNT = 0'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(128680509412987450)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(128745028131293292)
,p_button_name=>'Submit'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Yes, Submit'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_button_condition=>':L_DOC_COUNT != 0'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(128680290900987447)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(128745028131293292)
,p_button_name=>'Cancel'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(129032001158007603)
,p_branch_name=>'Stay in 11'
,p_branch_action=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.::P11_ITEM_ID:&P11_ITEM_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(128680509412987450)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128679931353987444)
,p_name=>'P13_REQUEST_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(128745028131293292)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128680059520987445)
,p_name=>'P13_ITEM_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(128745028131293292)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128680172105987446)
,p_name=>'L_DOC_COUNT'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(128745028131293292)
,p_use_cache_before_default=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count number;',
'begin',
'if DP_ITEMS_UTIL.ATTACHMENT_REQ_YN(:CURRENT_YEAR) = ''Y''',
'    Then ',
'        select nvl(count(*),0)',
'        into l_count',
'        from DP_ITEMS_documents',
'        where DP_ITEMS_ID = :P13_REQUEST_ID;',
'        ',
'else',
'    l_count := 1;',
'end if;',
'',
'return l_count;',
'end;'))
,p_source_type=>'FUNCTION_BODY'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129036508162007648)
,p_name=>'P13_REVIEW_STATUS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(128745028131293292)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129036664450007649)
,p_name=>'P13_COMMENT'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(128745028131293292)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>50
,p_cHeight=>2
,p_display_when=>'P13_REVIEW_STATUS'
,p_display_when2=>'Return'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(128680338532987448)
,p_name=>'Cancel DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(128680290900987447)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128680443507987449)
,p_event_id=>wwv_flow_api.id(128680338532987448)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(129031935169007602)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Submit Process'
,p_process_sql_clob=>'dp_items_workflow_2.submit_review(:P11_ITEM_ID, :PERSON_ID , :P13_COMMENT);'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(128680509412987450)
);
wwv_flow_api.component_end;
end;
/
