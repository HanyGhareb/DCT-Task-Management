prompt --application/pages/page_00004
begin
--   Manifest
--     PAGE: 00004
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
 p_id=>4
,p_user_interface_id=>wwv_flow_api.id(52958449993734913)
,p_name=>'Submit Confirmation'
,p_alias=>'SUBMIT-CONFIRMATION'
,p_page_mode=>'MODAL'
,p_step_title=>'Submit Confirmation'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220608083456'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(53144674004952927)
,p_plug_name=>'Declaration'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(52873880343734866)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source=>'you are going to &ACTION. check Number &CHECK_NUM., Are you sure?  '
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(92131968723459245)
,p_plug_name=>'New'
,p_parent_plug_id=>wwv_flow_api.id(53144674004952927)
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noBorder'
,p_plug_template=>wwv_flow_api.id(52847423684734857)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(53061944375300149)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(92131968723459245)
,p_button_name=>'Submit'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(52936058388734896)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'&ACTION.'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(53145560409960301)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(92131968723459245)
,p_button_name=>'Cancel'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(52936058388734896)
,p_button_image_alt=>'Cancel'
,p_button_position=>'BELOW_BOX'
,p_button_alignment=>'LEFT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53062014818300150)
,p_name=>'P4_CHECK_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(53144674004952927)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53145635252960302)
,p_name=>'CHECK_NUM'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(53144674004952927)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53298348152558606)
,p_name=>'ACTION'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(53144674004952927)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(92132065994459246)
,p_name=>'P4_COMMENT'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(53144674004952927)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_display_when=>'ACTION'
,p_display_when2=>'Void'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(52934852790734894)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(53145954099960305)
,p_name=>'Submit DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(53061944375300149)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(53146015297960306)
,p_event_id=>wwv_flow_api.id(53145954099960305)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'if :ACTION = ''Release'' then',
'manager_check_workflow.SUBMIT(:P4_CHECK_ID, null);',
'elsif :ACTION = ''Re-Submit''  then',
'    manager_check_workflow.RESUBMIT(:P4_CHECK_ID, null);',
'    ',
'elsif :ACTION =  ''Void'' then',
'    manager_check_workflow.VOID(:P4_CHECK_ID, :P4_COMMENT);    ',
'    ',
'    end if;',
'end;'))
,p_attribute_02=>'P4_CHECK_ID,ACTION,P4_COMMENT'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(53146117125960307)
,p_event_id=>wwv_flow_api.id(53145954099960305)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(53146216024960308)
,p_name=>'Close Dialog- Cancel'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(53145560409960301)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(53146322000960309)
,p_event_id=>wwv_flow_api.id(53146216024960308)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.component_end;
end;
/
