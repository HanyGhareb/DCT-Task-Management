prompt --application/pages/page_00019
begin
--   Manifest
--     PAGE: 00019
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
 p_id=>19
,p_user_interface_id=>wwv_flow_api.id(52958449993734913)
,p_name=>'Manager Check Reminder'
,p_alias=>'MANAGER-CHECK-REMINDER'
,p_page_mode=>'MODAL'
,p_step_title=>'Manager Check Reminder'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230331064859'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(155987376490902414)
,p_plug_name=>'New'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(52873880343734866)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(156778604364174422)
,p_plug_name=>'Button'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noBorder'
,p_plug_template=>wwv_flow_api.id(52847423684734857)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(155987633501902417)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(156778604364174422)
,p_button_name=>'Yes'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(52936058388734896)
,p_button_image_alt=>'Yes, Send'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(155987405357902415)
,p_name=>'P19_COMMENT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(155987376490902414)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>2
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(156778573168174421)
,p_name=>'P19_DUE_DATE'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(155987376490902414)
,p_item_default=>'select sysdate + 7 from dual;'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Due Date'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(52934951552734894)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(156778727818174423)
,p_name=>'P19_LINE_MANAGER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(155987376490902414)
,p_item_default=>'Y'
,p_prompt=>'Add Line Manager in Cc ?'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'no'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(156778818100174424)
,p_name=>'P19_FBP'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(155987376490902414)
,p_item_default=>'Y'
,p_prompt=>'Add Related FBP in Cc ?'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'no'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(156778983408174425)
,p_name=>'P19_ADDITIONAL_CC'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(155987376490902414)
,p_item_default=>'N'
,p_prompt=>'Add in Cc ?'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'no'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(156779148049174427)
,p_name=>'P19_ADD_CC'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(155987376490902414)
,p_prompt=>'Add Cc'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMP BY EMAILO POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en     || ',
'        ''(''             ||',
'        employee_num    ||',
'        ''-''             ||',
'        email           ||',
'        '')''                         as full_name_en',
'        , email',
'from employees_v',
'where current_flag = ''Y''',
'order by employee_num'))
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'Y'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_11=>','
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(156779271856174428)
,p_name=>'P19_ADD_BCC'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(155987376490902414)
,p_prompt=>'Add in BCc'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMP BY EMAILO POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en     || ',
'        ''(''             ||',
'        employee_num    ||',
'        ''-''             ||',
'        email           ||',
'        '')''                         as full_name_en',
'        , email',
'from employees_v',
'where current_flag = ''Y''',
'order by employee_num'))
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'Y'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_11=>','
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(156779303246174429)
,p_name=>'P19_ADDITIONAL_BCC'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(155987376490902414)
,p_item_default=>'N'
,p_prompt=>'Add in Bcc ? '
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'no'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(155987786695902418)
,p_name=>'Send Reminder DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(155987633501902417)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(155987841264902419)
,p_event_id=>wwv_flow_api.id(155987786695902418)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare ',
'    l_region_id        number;  ',
'    l_context          apex_exec.t_context;    ',
'    l_check_num        pls_integer; ',
'    ',
'begin',
'    -- Get the region id for the CUSTOMERS IR region',
'    select region_id',
'      into l_region_id',
'      from apex_application_page_regions',
'     where application_id = :APP_ID',
'       and page_id        = 1',
'       and static_id      = ''USERS'';',
'',
'    l_context := apex_region.open_query_context (',
'                        p_page_id => 1,',
'                        p_region_id => l_region_id );',
'',
'    l_check_num := apex_exec.get_column_position( l_context, ''CHECK_NUM'' );',
'',
'    ',
'    -- Loop throught the query of the context',
'    while apex_exec.next_row( l_context ) loop  ',
'    ',
'        manager_check_emails.Remider_HOLD_email( apex_exec.get_varchar2( l_context,  l_check_num ),',
'                                                :P19_COMMENT,',
'                                                to_char(:P19_DUE_DATE),',
'                                                :P19_LINE_MANAGER,',
'                                                :P19_FBP,',
'                                                :P19_ADD_CC,',
'                                                :P19_ADD_BCC',
'                                               );',
'',
'  ',
'     end loop;',
' ',
'     apex_exec.close( l_context );',
'',
'exception',
'     when others then',
'         apex_exec.close( l_context );',
'     raise; ',
'end;'))
,p_attribute_02=>'P19_COMMENT,P19_DUE_DATE,P19_LINE_MANAGER,P19_FBP,P19_ADD_CC,P19_ADD_BCC'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(155987966424902420)
,p_event_id=>wwv_flow_api.id(155987786695902418)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(156779416033174430)
,p_name=>'Add CC DA'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P19_ADDITIONAL_CC'
,p_condition_element=>'P19_ADDITIONAL_CC'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(156779507656174431)
,p_event_id=>wwv_flow_api.id(156779416033174430)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P19_ADD_CC'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(156780128392174437)
,p_event_id=>wwv_flow_api.id(156779416033174430)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P19_ADD_CC'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(156779626190174432)
,p_event_id=>wwv_flow_api.id(156779416033174430)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P19_ADD_CC'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(156779736807174433)
,p_name=>'Add Bcc DA'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P19_ADDITIONAL_BCC'
,p_condition_element=>'P19_ADDITIONAL_BCC'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(156779890108174434)
,p_event_id=>wwv_flow_api.id(156779736807174433)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P19_ADD_BCC'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(156780043408174436)
,p_event_id=>wwv_flow_api.id(156779736807174433)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P19_ADD_BCC'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(156780218316174438)
,p_event_id=>wwv_flow_api.id(156779736807174433)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P19_ADD_BCC'
);
wwv_flow_api.component_end;
end;
/
