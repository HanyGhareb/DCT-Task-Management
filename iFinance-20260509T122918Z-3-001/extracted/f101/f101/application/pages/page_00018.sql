prompt --application/pages/page_00018
begin
--   Manifest
--     PAGE: 00018
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
 p_id=>18
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Send Initiation EMail'
,p_alias=>'SEND-INITIATION-EMAIL'
,p_page_mode=>'MODAL'
,p_step_title=>'Send Initiation EMail'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220210095031'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(4585619818120868)
,p_plug_name=>'Send Initiation EMail'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8030481219175499)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4585784527120870)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(4585619818120868)
,p_button_name=>'Send_EMails'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight:t-Button--stretch'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Send Emails'
,p_button_position=>'BODY'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'N'
,p_grid_new_column=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4585702884120869)
,p_name=>'P18_NOTES'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(4585619818120868)
,p_prompt=>'Special Notes from Accounts Payable'
,p_display_as=>'NATIVE_RICH_TEXT_EDITOR'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>wwv_flow_api.id(8118554792175530)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_02=>'Intermediate'
,p_attribute_03=>'Y'
,p_attribute_04=>'moonocolor'
,p_attribute_05=>'top'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4585947209120871)
,p_name=>'Send EmailOnClick'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(4585784527120870)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4586030657120872)
,p_event_id=>wwv_flow_api.id(4585947209120871)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure to send Invitation email to all Selected employees ?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4586117563120873)
,p_event_id=>wwv_flow_api.id(4585947209120871)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare ',
'    l_context          apex_exec.t_context;    ',
'    l_emailsidx        pls_integer;',
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
'       and page_id        = 9',
'       and static_id      = ''USERS'';',
' ',
'    -- Get the query context for the CUSTOMERS IR Region',
'    -- Documentation: https://docs.oracle.com/en/database/oracle/application-express/19.2/aeapi/OPEN_QUERY_CONTEXT-Function.html',
'    l_context := apex_region.open_query_context (',
'                        p_page_id => 9,',
'                        p_region_id => l_region_id );',
'    -- Get the column positions for EMAIL and NAME columns',
'    l_emailsidx := apex_exec.get_column_position( l_context, ''EMAIL'' );',
'    l_namesids := apex_exec.get_column_position( l_context, ''EMP_NAME'' );',
'    l_users := apex_exec.get_column_position( l_context, ''USER_NAME'' );',
'    l_titles := apex_exec.get_column_position( l_context, ''TITLE'' );',
'    ',
'    -- Loop throught the query of the context',
'    while apex_exec.next_row( l_context ) loop  ',
'    ',
'    -- Reset User Password',
'    l_temp_password := DBMS_RANDOM.string(''x'',4); ',
'    ',
'        update dct_employees_list2 e',
'        set e.password = l_temp_password , e.change_password = ''Y''',
'        where e.user_name =  apex_exec.get_varchar2( l_context, l_users );   ',
'    ',
'    ',
'        apex_mail.send (',
'        p_from               => ''ifinance@dctabudhabi.ae'' ,   ',
'        p_to                 => apex_exec.get_varchar2( l_context, l_emailsidx ),',
'   --     p_bcc                => ''HSleiman@dctabudhabi.ae,Hghareb@dctabudhabi.ae'',    ',
'        p_template_static_id => ''PETTY_CASH_INVITATION'',',
'        p_placeholders       => ''{'' ||',
'        ''    "TITLE":''            || apex_json.stringify( apex_exec.get_varchar2( l_context, l_titles )) ||    ',
'        ''   , "EMP_NAME":''            || apex_json.stringify( apex_exec.get_varchar2( l_context, l_namesids )) ||',
'        ''   , "USER_NAME":''            || apex_json.stringify( apex_exec.get_varchar2( l_context, l_users )) ||',
'        ''   , "PASSWORD":''            ||  apex_json.stringify( l_temp_password ) ||    ',
'        ''   ,"NOTES":''               || apex_json.stringify( :P18_NOTES ) ||    ',
'        ''   , "MY_APPLICATION_LINK":'' || apex_json.stringify(''https://ifinance.dct.gov.ae:8004/dct/f?p=100:1'') ||    ',
'        ''}'' );',
'        ',
'     end loop;',
' ',
'     apex_exec.close( l_context );',
'     apex_mail.push_queue;',
'exception',
'     when others then',
'         apex_exec.close( l_context );',
'     raise; ',
'end;'))
,p_attribute_02=>'P18_NOTES'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4586252977120874)
,p_event_id=>wwv_flow_api.id(4585947209120871)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.component_end;
end;
/
