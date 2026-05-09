prompt --application/pages/page_00048
begin
--   Manifest
--     PAGE: 00048
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
 p_id=>48
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'Send Individual Stakeholder Invitation Email'
,p_alias=>'SEND-INDIVIDUAL-STAKEHOLDER-INVITATION-EMAIL'
,p_page_mode=>'MODAL'
,p_step_title=>'Send Individual Stakeholder Invitation Email'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210903125414'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(192534788742204020)
,p_plug_name=>'Send Initiation EMail'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10217787920597763)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(40009233636270622)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_api.id(192534788742204020)
,p_button_name=>'Send_EMails'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight:t-Button--stretch'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Send'
,p_button_position=>'BODY'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'N'
,p_grid_new_column=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(39724531247361316)
,p_name=>'P48_EMAIL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(192534788742204020)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(39724680820361317)
,p_name=>'P48_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(192534788742204020)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(39724790372361318)
,p_name=>'P48_USER_NAME'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(192534788742204020)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(39724830876361319)
,p_name=>'P48_TITLE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(192534788742204020)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(39724941485361320)
,p_name=>'P48_USER_ID'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(192534788742204020)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(40009692065270621)
,p_name=>'P48_NOTES'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(192534788742204020)
,p_prompt=>'<b style="color:red; font-size:18px;">Special Notes from CWIP Payment Admin (If Any)</b>'
,p_display_as=>'NATIVE_RICH_TEXT_EDITOR'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>wwv_flow_api.id(10306172661597823)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_02=>'Intermediate'
,p_attribute_03=>'Y'
,p_attribute_04=>'moonocolor'
,p_attribute_05=>'top'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(40010048139270620)
,p_name=>'Send EmailOnClick'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(40009233636270622)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(40011007802270619)
,p_event_id=>wwv_flow_api.id(40010048139270620)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure to send Invitation email to all Selected employees ?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(40011551594270619)
,p_event_id=>wwv_flow_api.id(40010048139270620)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare ',
'',
'    l_temp_password    varchar2(20);',
'begin',
'    ',
'    -- Reset User Password',
'    l_temp_password := DBMS_RANDOM.string(''x'',5); ',
'    ',
'        update dct_ext_users e',
'        set e.password = l_temp_password , e.change_password = ''Y''',
'        where e.user_id = :P48_USER_ID;   ',
'    ',
'    ',
'        apex_mail.send (',
'        p_from               => ''ifinance@dctabudhabi.ae'' ,   ',
'        p_to                 =>     :P48_EMAIL,',
'        p_template_static_id => ''CWIP_PAYMENT_EXTERNAL_INVITATION'',',
'        p_placeholders       => ''{'' ||',
'        ''    "TITLE":''            || apex_json.stringify( :P48_TITLE) ||    ',
'        ''   , "EMP_NAME":''            || apex_json.stringify( :P48_NAME) ||',
'        ''   , "USER_NAME":''            || apex_json.stringify( :P48_USER_NAME) ||',
'        ''   , "PASSWORD":''            ||  apex_json.stringify( l_temp_password ) ||    ',
'        ''   ,"NOTES":''               || apex_json.stringify( :P48_NOTES ) ||    ',
'        ''   , "MY_APPLICATION_LINK":'' || apex_json.stringify(''https://ifinance.dct.gov.ae:8004/dct/f?p=109:1'') ||    ',
'        ''}'' );',
'        ',
'',
'     apex_mail.push_queue;',
'exception',
'     when others then',
'        null;',
'     raise; ',
'end;'))
,p_attribute_02=>'P48_NOTES'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(40010513881270619)
,p_event_id=>wwv_flow_api.id(40010048139270620)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(39725053688361321)
,p_event_id=>wwv_flow_api.id(40010048139270620)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'DOne '
);
wwv_flow_api.component_end;
end;
/
