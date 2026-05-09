prompt --application/pages/page_00900
begin
--   Manifest
--     PAGE: 00900
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>100
,p_default_id_offset=>40620729557075005
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>900
,p_user_interface_id=>wwv_flow_api.id(1686359760302353)
,p_name=>'Test Mail'
,p_alias=>'TEST-MAIL'
,p_step_title=>'Test Mail'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'ADMIN'
,p_last_upd_yyyymmddhh24miss=>'20200628163339'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1755850927576608)
,p_plug_name=>'New apex mail'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(1601776079302283)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1755913584576609)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(1755850927576608)
,p_button_name=>'Send'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(1663835798302321)
,p_button_image_alt=>'Send'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1780975173643356)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(1755850927576608)
,p_button_name=>'RESET'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(1663835798302321)
,p_button_image_alt=>'Reset'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1756049923576610)
,p_name=>'New'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(1755913584576609)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1756132700576611)
,p_event_id=>wwv_flow_api.id(1756049923576610)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'apex_mail.send(',
'p_to => ''HGhareb@dctabudhabi.ae'',',
'p_from => ''HGhareb@dctabudhabi.ae'', p_subj => ''Hany'',',
'p_body => ''Hany Ghareb Body'');',
'',
'apex_mail.push_queue;',
'',
'end;'))
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1756699183576616)
,p_name=>'New_1'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(1780975173643356)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1756742895576617)
,p_event_id=>wwv_flow_api.id(1756699183576616)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'--ifinance_users.reset_user_password(''9051'' , ''hghareb@dctabudhabi.ae'');',
'ifinance_users.RESET_USER_PASSWORD(''9051'' , ''hghareb@dctabudhabi.ae'');',
'end;',
''))
,p_wait_for_result=>'Y'
);
wwv_flow_api.component_end;
end;
/
