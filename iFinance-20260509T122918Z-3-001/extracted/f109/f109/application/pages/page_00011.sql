prompt --application/pages/page_00011
begin
--   Manifest
--     PAGE: 00011
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>666
,p_default_id_offset=>90826491306730853
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>11
,p_user_interface_id=>wwv_flow_api.id(11217697745956116)
,p_name=>'Change My Password'
,p_alias=>'CHANGE-MY-PASSWORD'
,p_step_title=>'Change My Password'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210903122808'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(50100829702097193)
,p_plug_name=>'Change My Password'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(11105666197956032)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_span=>4
,p_plug_display_column=>3
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(39999178185496931)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(50100829702097193)
,p_button_name=>'Submit'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(11195252240956089)
,p_button_image_alt=>'Submit'
,p_button_position=>'BOTTOM'
,p_icon_css_classes=>'fa-send'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(40005570923496925)
,p_branch_name=>'Go To Home'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:1::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'BEFORE_COMPUTATION'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(39999555016496930)
,p_name=>'P11_NEW_PASSWORD'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(50100829702097193)
,p_prompt=>'New Password'
,p_display_as=>'NATIVE_PASSWORD'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(11194304680956088)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(39999973081496930)
,p_name=>'P11_CONFIRM_PASSWORD'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(50100829702097193)
,p_prompt=>'Confirm Password'
,p_display_as=>'NATIVE_PASSWORD'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(11194304680956088)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(40000399491496929)
,p_name=>'P11_CONFIRM'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(50100829702097193)
,p_prompt=>'Matched'
,p_source=>'Password Doesn''t match !!'
,p_source_type=>'STATIC'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(11193774778956086)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(40000746979496928)
,p_name=>'Change My Password'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(39999178185496931)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(40001228187496928)
,p_event_id=>wwv_flow_api.id(40000746979496928)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'    update dct_ext_users',
'    set password = :P11_NEW_PASSWORD',
'    , change_password = ''N''',
'    where user_name = :APP_USER;',
'end;'))
,p_attribute_02=>'P11_NEW_PASSWORD'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(40001686711496928)
,p_name=>'Disable Submit on load'
,p_event_sequence=>20
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(40002168685496927)
,p_event_id=>wwv_flow_api.id(40001686711496928)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(39999178185496931)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(40002645210496927)
,p_event_id=>wwv_flow_api.id(40001686711496928)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_CONFIRM'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(40003073170496926)
,p_name=>'Confirm Password'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P11_CONFIRM_PASSWORD'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'$v(P11_NEW_PASSWORD) != $v(P11_CONFIRM_PASSWORD)'
,p_bind_type=>'live'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(40003592186496926)
,p_event_id=>wwv_flow_api.id(40003073170496926)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(39999178185496931)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(40004032448496926)
,p_event_id=>wwv_flow_api.id(40003073170496926)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_CONFIRM'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(40004517885496926)
,p_event_id=>wwv_flow_api.id(40003073170496926)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(39999178185496931)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(40005070881496925)
,p_event_id=>wwv_flow_api.id(40003073170496926)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_CONFIRM'
);
wwv_flow_api.component_end;
end;
/
