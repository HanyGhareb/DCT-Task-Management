prompt --application/pages/page_00010
begin
--   Manifest
--     PAGE: 00010
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>219773596381898043
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>10
,p_user_interface_id=>wwv_flow_api.id(23921013981372477)
,p_name=>'Send Invitation mails'
,p_alias=>'SEND-INVITATION-MAILS'
,p_page_mode=>'MODAL'
,p_step_title=>'Send Invitation mails'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210608195028'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(115480946311240022)
,p_plug_name=>'Send Initiation EMail'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23809027085372569)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(33829364666363905)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(115480946311240022)
,p_button_name=>'Send_EMails'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight:t-Button--stretch'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Send Emails'
,p_button_position=>'BODY'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'N'
,p_grid_new_column=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(33829730825363905)
,p_name=>'P10_RESET_PW'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(115480946311240022)
,p_item_default=>'N'
,p_prompt=>'Reset Password ?'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(33830126509363904)
,p_name=>'P10_NOTES'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(115480946311240022)
,p_prompt=>'Special Notes from Treasury Unit:'
,p_display_as=>'NATIVE_RICH_TEXT_EDITOR'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>wwv_flow_api.id(23897160841372512)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--xlarge'
,p_attribute_02=>'Intermediate'
,p_attribute_03=>'Y'
,p_attribute_04=>'moonocolor'
,p_attribute_05=>'top'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(33830598764363902)
,p_name=>'Send EmailOnClick'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(33829364666363905)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33831058908363901)
,p_event_id=>wwv_flow_api.id(33830598764363902)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure to send Invitation email to all Selected employees ?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33831510693363901)
,p_event_id=>wwv_flow_api.id(33830598764363902)
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
'    if :P10_RESET_PW = ''Y''    Then',
'    -- Reset User Password',
'    l_temp_password := DBMS_RANDOM.string(''x'',10); ',
'    ',
'        update dct_employees_list2 e',
'        set e.password = l_temp_password , e.change_password = ''Y''',
'        where e.user_name =  apex_exec.get_varchar2( l_context, l_users );   ',
'    End IF;',
'    ',
'        apex_mail.send (',
'        p_from               => ''ifinance@dctabudhabi.ae'' ,   ',
'        p_to                 => apex_exec.get_varchar2( l_context, l_emailsidx ),',
'        p_template_static_id => ''CREDIT_CARD_INVITATION'',',
'        p_placeholders       => ''{'' ||',
'        ''    "TITLE":''            || apex_json.stringify( apex_exec.get_varchar2( l_context, l_titles )) ||    ',
'        ''   , "EMP_NAME":''            || apex_json.stringify( apex_exec.get_varchar2( l_context, l_namesids )) ||',
'        ''   , "USER_NAME":''            || apex_json.stringify( apex_exec.get_varchar2( l_context, l_users )) ||',
'        ''   , "PASSWORD":''            ||  apex_json.stringify( l_temp_password ) ||    ',
'        ''   ,"NOTES":''               || apex_json.stringify( :P10_NOTES ) ||    ',
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
,p_attribute_02=>'P10_NOTES,P10_RESET_PW'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33832086265363901)
,p_event_id=>wwv_flow_api.id(33830598764363902)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.component_end;
end;
/
