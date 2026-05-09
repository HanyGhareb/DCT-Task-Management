prompt --application/pages/page_00047
begin
--   Manifest
--     PAGE: 00047
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>47
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'Send Stakeholders Invitation Email'
,p_alias=>'SEND-STAKEHOLDERS-INVITATION-EMAIL'
,p_page_mode=>'MODAL'
,p_step_title=>'Send Stakeholders Invitation Email'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230427044004'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(152526106830933397)
,p_plug_name=>'Send Initiation EMail'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10217787920597763)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(39988681427598949)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(152526106830933397)
,p_button_name=>'Send_EMails'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight:t-Button--stretch'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Send Emails'
,p_button_position=>'BODY'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'N'
,p_grid_new_column=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(39989037269598948)
,p_name=>'P47_NOTES'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(152526106830933397)
,p_prompt=>'<b style="color:red; font-size:18px;">Special Notes from CWIP Payment Admin (If Any)</b>'
,p_display_as=>'NATIVE_RICH_TEXT_EDITOR'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>wwv_flow_api.id(10306172661597823)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_02=>'Intermediate'
,p_attribute_03=>'Y'
,p_attribute_04=>'moonocolor'
,p_attribute_05=>'top'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(39989348252598948)
,p_name=>'Send EmailOnClick'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(39988681427598949)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(39990399260598947)
,p_event_id=>wwv_flow_api.id(39989348252598948)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure to send Invitation email to all Selected employees ?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(39990843396598946)
,p_event_id=>wwv_flow_api.id(39989348252598948)
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
'       and page_id        = 46',
'       and static_id      = ''USERS'';',
' ',
'    -- Get the query context for the CUSTOMERS IR Region',
'    -- Documentation: https://docs.oracle.com/en/database/oracle/application-express/19.2/aeapi/OPEN_QUERY_CONTEXT-Function.html',
'    l_context := apex_region.open_query_context (',
'                        p_page_id => 46,',
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
'    l_temp_password := DBMS_RANDOM.string(''x'',5); ',
'    ',
'        update dct_ext_users e',
'        set e.password = l_temp_password , e.change_password = ''Y''',
'        where e.user_name =  apex_exec.get_varchar2( l_context, l_users );   ',
'    ',
'    ',
'        apex_mail.send (',
'        p_from               => ''ifinance@dctabudhabi.ae'' ,   ',
'        p_to                 => apex_exec.get_varchar2( l_context, l_emailsidx ),',
'        p_template_static_id => ''CWIP_PAYMENT_EXTERNAL_INVITATION'',',
'        p_placeholders       => ''{'' ||',
'        ''    "TITLE":''            || apex_json.stringify( apex_exec.get_varchar2( l_context, l_titles )) ||    ',
'        ''   , "EMP_NAME":''            || apex_json.stringify( apex_exec.get_varchar2( l_context, l_namesids )) ||',
'        ''   , "USER_NAME":''            || apex_json.stringify( apex_exec.get_varchar2( l_context, l_users )) ||',
'        ''   , "PASSWORD":''            ||  apex_json.stringify( l_temp_password ) ||    ',
'        ''   ,"NOTES":''               || apex_json.stringify( :P47_NOTES ) ||    ',
'        ''   , "MY_APPLICATION_LINK":'' || apex_json.stringify(''https://ifinance.dct.gov.ae:8004/dct/prod/r/i-finance-ext/login'') ||    ',
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
,p_attribute_02=>'P47_NOTES'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(39989860706598948)
,p_event_id=>wwv_flow_api.id(39989348252598948)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.component_end;
end;
/
