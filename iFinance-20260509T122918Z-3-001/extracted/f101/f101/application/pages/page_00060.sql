prompt --application/pages/page_00060
begin
--   Manifest
--     PAGE: 00060
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>60
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Petty Cash - Change Type Action'
,p_alias=>'PETTY-CASH-CHANGE-TYPE-ACTION'
,p_page_mode=>'MODAL'
,p_step_title=>'Petty Cash - Change Type Action'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210930063436'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(25849549249265848)
,p_plug_name=>'New'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>'you are going to change the petty cash type for <b> &P60_NAME. </b> are you sure?'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(25849057381265843)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(25849549249265848)
,p_button_name=>'Change'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_image_alt=>'Yes, Change'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-exchange'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(25848977728265842)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(25849549249265848)
,p_button_name=>'Cancel'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25849476974265847)
,p_name=>'P60_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(25849549249265848)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25849360491265846)
,p_name=>'P60_TYPE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(25849549249265848)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25849161155265844)
,p_name=>'P60_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(25849549249265848)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(25848898452265841)
,p_name=>'Cancel DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(25848977728265842)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(25848774914265840)
,p_event_id=>wwv_flow_api.id(25848898452265841)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(25848643979265839)
,p_name=>'Change DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(25849057381265843)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(25848547386265838)
,p_event_id=>wwv_flow_api.id(25848643979265839)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_type        varchar2(20);',
'l_new_type    varchar2(20);',
'',
'begin',
'',
'select PETTY_CASH_TYPE',
'into l_type',
'from hrss_petty_cash',
'where PETTY_CASH_ID = :P60_ID;',
'',
'l_new_type := case l_type when ''P'' Then ''T''',
'                          when ''T'' Then ''P''',
'              End  ;',
'              ',
'update hrss_petty_cash',
'set PETTY_CASH_TYPE = l_new_type',
'where PETTY_CASH_ID = :P60_ID;',
'',
'End ;'))
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(25848484762265837)
,p_event_id=>wwv_flow_api.id(25848643979265839)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.component_end;
end;
/
