prompt --application/pages/page_00013
begin
--   Manifest
--     PAGE: 00013
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>118
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>13
,p_user_interface_id=>wwv_flow_api.id(122997627648781606)
,p_name=>'Send Customer outstanding Reminder'
,p_alias=>'SEND-CUSTOMER-OUTSTANDING-REMINDER'
,p_page_mode=>'MODAL'
,p_step_title=>'Send Customer outstanding Reminder'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230331051233'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(154993185902789342)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noBorder'
,p_plug_template=>wwv_flow_api.id(122886614827781681)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(156937583384515279)
,p_plug_name=>'Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(122913064144781666)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(154993370532789344)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(154993185902789342)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(122975280422781629)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(154993272148789343)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(154993185902789342)
,p_button_name=>'Send'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(122975280422781629)
,p_button_image_alt=>'Send'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-envelope-open-o'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(154992826166789339)
,p_name=>'P13_ADD_CC'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(156937583384515279)
,p_prompt=>'Add Cc'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMP BY EMAILS POPUP'
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
,p_field_template=>wwv_flow_api.id(122973838585781631)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'Y'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_11=>','
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(154992962332789340)
,p_name=>'P13_ADD_BCC'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(156937583384515279)
,p_prompt=>'Add Bcc'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMP BY EMAILS POPUP'
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
,p_field_template=>wwv_flow_api.id(122973838585781631)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'Y'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_11=>','
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(154993049568789341)
,p_name=>'P13_COMMENT'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(156937583384515279)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>2
,p_field_template=>wwv_flow_api.id(122973838585781631)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(156780517890174441)
,p_name=>'Send DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(154993272148789343)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(156780642924174442)
,p_event_id=>wwv_flow_api.id(156780517890174441)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'You are going to send emails to all customers in the table, are you sure?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(156780725656174443)
,p_event_id=>wwv_flow_api.id(156780517890174441)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare ',
'    l_context          apex_exec.t_context;    ',
'    l_account_num      pls_integer;',
'    l_namesids         pls_integer;',
'    l_users            pls_integer;',
'    l_titles           pls_integer;',
'    l_region_id        number;',
'    l_temp_password    varchar2(20);',
'begin',
'    -- Get the region id for the CUSTOMERS IR region',
'    select region_id',
'      into l_region_id',
'      from apex_application_page_regions',
'     where application_id = :APP_ID',
'       and page_id        = 11',
'       and static_id      = ''USERS'';',
' ',
'    -- Get the query context for the CUSTOMERS IR Region',
'    -- Documentation: https://docs.oracle.com/en/database/oracle/application-express/19.2/aeapi/OPEN_QUERY_CONTEXT-Function.html',
'    l_context := apex_region.open_query_context (',
'                        p_page_id => 11,',
'                        p_region_id => l_region_id );',
'    -- Get the column positions for EMAIL and NAME columns',
'    l_account_num := apex_exec.get_column_position( l_context, ''ACCOUNT_NUM'' );',
'    ',
'    -- Loop throught the query of the context',
'    while apex_exec.next_row( l_context ) loop  ',
'    ',
'                        ar_reminders.send_hotel_outstanding(apex_exec.get_varchar2( l_context, l_account_num ),',
'                                                            :P13_ADD_CC,',
'                                                            :P13_ADD_BCC,',
'                                                            :P13_COMMENT);    ',
'     end loop;',
' ',
'     apex_exec.close( l_context );',
'exception',
'     when others then',
'         apex_exec.close( l_context );',
'     raise; ',
'end;'))
,p_attribute_02=>'P13_ADD_CC,P13_ADD_BCC,P13_COMMENT'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(157190885964961612)
,p_event_id=>wwv_flow_api.id(156780517890174441)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(156780933261174445)
,p_name=>'Close DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(154993370532789344)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(156781058536174446)
,p_event_id=>wwv_flow_api.id(156780933261174445)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.component_end;
end;
/
