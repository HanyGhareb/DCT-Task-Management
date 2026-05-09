prompt --application/pages/page_00017
begin
--   Manifest
--     PAGE: 00017
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>102
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>17
,p_user_interface_id=>wwv_flow_api.id(3440093928015830)
,p_name=>'Change Password'
,p_alias=>'CHANGE-PASSWORD'
,p_page_mode=>'MODAL'
,p_step_title=>'Change Password'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230610190137'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(142984972228914203)
,p_plug_name=>'Change'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(3355416515015745)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(142407442103823836)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(142984972228914203)
,p_button_name=>'Change'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(3417666671015793)
,p_button_image_alt=>'Change'
,p_button_position=>'BELOW_BOX'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(142407542268823837)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(142984972228914203)
,p_button_name=>'Cancel'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(3417666671015793)
,p_button_image_alt=>'Cancel'
,p_button_position=>'BELOW_BOX'
,p_button_alignment=>'LEFT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(142408131759823843)
,p_branch_name=>'Go To 13'
,p_branch_action=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.:17:P13_PERSON_ID:&P17_PERSON_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(142407063596823832)
,p_name=>'P17_PERSON_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(142984972228914203)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(142407156839823833)
,p_name=>'P17_EMP_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(142984972228914203)
,p_prompt=>'Emp Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(142407220247823834)
,p_name=>'P17_NEW'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(142984972228914203)
,p_prompt=>'New Password'
,p_display_as=>'NATIVE_PASSWORD'
,p_cSize=>30
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(3416586982015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(142407334720823835)
,p_name=>'P17_NEW_1'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(142984972228914203)
,p_prompt=>'Confirm Password'
,p_display_as=>'NATIVE_PASSWORD'
,p_cSize=>30
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(3416586982015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(142407683721823838)
,p_name=>'Cancel DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(142407542268823837)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(142407713800823839)
,p_event_id=>wwv_flow_api.id(142407683721823838)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(142408014038823842)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Change Password Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P17_NEW = :P17_NEW_1',
'    Then',
'        update dct_employees_list2 ',
'        set password = :P17_NEW, PASSWORD_LAST_CHANGED = systimestamp',
'        where person_id = :P17_PERSON_ID;',
'',
' End if;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(142407442103823836)
,p_process_success_message=>'Password Changed,'
);
wwv_flow_api.component_end;
end;
/
