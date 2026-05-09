prompt --application/pages/page_09996
begin
--   Manifest
--     PAGE: 09996
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>9996
,p_user_interface_id=>wwv_flow_api.id(1686359760302353)
,p_name=>'Change My Password'
,p_alias=>'CHANGE-MY-PASSWORD'
,p_step_title=>'Change My Password'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_overwrite_navigation_list=>'Y'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230623043803'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(10102328838600262)
,p_plug_name=>'Change My Password'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(1574322396302267)
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
 p_id=>wwv_flow_api.id(8345167068023642)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(10102328838600262)
,p_button_name=>'Submit'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(1663977999302321)
,p_button_image_alt=>'Submit'
,p_button_position=>'BOTTOM'
,p_icon_css_classes=>'fa-send'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(7950636530144841)
,p_branch_name=>'Go To Home'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:1::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8345986232023646)
,p_name=>'P9996_NEW_PASSWORD'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(10102328838600262)
,p_prompt=>'New Password'
,p_display_as=>'NATIVE_PASSWORD'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(1663065957302319)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8346344673023647)
,p_name=>'P9996_CONFIRM_PASSWORD'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(10102328838600262)
,p_prompt=>'Confirm Password'
,p_display_as=>'NATIVE_PASSWORD'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(1663065957302319)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8346725299023647)
,p_name=>'P9996_CONFIRM'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(10102328838600262)
,p_prompt=>'Matched'
,p_source=>'Password Doesn''t match !!'
,p_source_type=>'STATIC'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(1662433208302318)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(8351028208059756)
,p_name=>'Disable Submit on load'
,p_event_sequence=>20
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(8351473542059758)
,p_event_id=>wwv_flow_api.id(8351028208059756)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(8345167068023642)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(8351990212059758)
,p_event_id=>wwv_flow_api.id(8351028208059756)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P9996_CONFIRM'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(8352340953065509)
,p_name=>'Confirm Password'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P9996_CONFIRM_PASSWORD'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'$v(P9996_NEW_PASSWORD) != $v(P9996_CONFIRM_PASSWORD)'
,p_bind_type=>'live'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(8352795203065510)
,p_event_id=>wwv_flow_api.id(8352340953065509)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(8345167068023642)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(8354212229065510)
,p_event_id=>wwv_flow_api.id(8352340953065509)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P9996_CONFIRM'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(8353229412065510)
,p_event_id=>wwv_flow_api.id(8352340953065509)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(8345167068023642)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(8353791813065510)
,p_event_id=>wwv_flow_api.id(8352340953065509)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P9996_CONFIRM'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(169813378398839021)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'New'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'    update dct_employees_list2',
'    set password = :P9996_NEW_PASSWORD',
'    , change_password = ''N''',
'    , PASSWORD_LAST_CHANGED = systimestamp',
'    where user_name = :APP_USER;',
'end;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
