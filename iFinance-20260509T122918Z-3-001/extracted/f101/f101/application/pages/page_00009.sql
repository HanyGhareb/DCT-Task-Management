prompt --application/pages/page_00009
begin
--   Manifest
--     PAGE: 00009
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
 p_id=>9
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Invitation - Petty Cash '
,p_alias=>'INVITATION-PETTY-CASH'
,p_step_title=>'Invitation - Petty Cash '
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231019103755'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(557269329033298)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8067277693175509)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(8003821207175482)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(8121335853175533)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(557878752033298)
,p_plug_name=>'Invitation - Petty Cash '
,p_region_name=>'USERS'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8055912915175506)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select employee_num ,',
'        title ,',
'        full_name_en     EMP_NAME,',
'        full_name_ar ,',
'        manager_flag ,',
'        supervisor_num ,',
'        org_name,',
'        org_id,',
'        Email    Email,',
'        User_Name',
'from employees_v',
'where current_flag = ''Y'''))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Invitation - Petty Cash '
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(558051250033298)
,p_name=>'Invitation - Petty Cash '
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>2548089577097062
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(558379086033302)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(558799880033303)
,p_db_column_name=>'TITLE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Title'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(559624744033303)
,p_db_column_name=>'FULL_NAME_AR'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Full Name Ar'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(559971910033303)
,p_db_column_name=>'MANAGER_FLAG'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Manager Flag'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(560444606033304)
,p_db_column_name=>'SUPERVISOR_NUM'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Supervisor Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(534431062427140)
,p_db_column_name=>'EMAIL'
,p_display_order=>17
,p_column_identifier=>'H'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(534685333427143)
,p_db_column_name=>'EMP_NAME'
,p_display_order=>27
,p_column_identifier=>'I'
,p_column_label=>'Emp Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(534815847427144)
,p_db_column_name=>'USER_NAME'
,p_display_order=>37
,p_column_identifier=>'J'
,p_column_label=>'User Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6651217955135460)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>47
,p_column_identifier=>'L'
,p_column_label=>'Org Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6651289789135461)
,p_db_column_name=>'ORG_ID'
,p_display_order=>57
,p_column_identifier=>'M'
,p_column_label=>'Org Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(562234806061734)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'25523'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'EMPLOYEE_NUM:TITLE:EMP_NAME:USER_NAME:SUPERVISOR_NUM:EMAIL:ORG_NAME:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(6653645276135484)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(557878752033298)
,p_button_name=>'Remider'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_image_alt=>'Remider Petty Cash'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'EMP_NUM'
,p_button_condition2=>'9051'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4673546642660471)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(557878752033298)
,p_button_name=>'Remider_EXPENSE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_image_alt=>'Remider Expense Report'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'EMP_NUM'
,p_button_condition2=>'9051'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(22228898264428974)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(557878752033298)
,p_button_name=>'Send_Approve_Email'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_image_alt=>'Send Approve Email'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'EMP_NUM'
,p_button_condition2=>'9051'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(534294182427139)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(557878752033298)
,p_button_name=>'Send_Email'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Send Email'
,p_button_position=>'TOP'
,p_button_redirect_url=>'f?p=&APP_ID.:18:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-envelope-plus'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(534548916427141)
,p_name=>'Send'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(534294182427139)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
,p_display_when_type=>'NEVER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(537219114427168)
,p_event_id=>wwv_flow_api.id(534548916427141)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure to send Invitation email to all these employees ?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(534619763427142)
,p_event_id=>wwv_flow_api.id(534548916427141)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare ',
'    l_context apex_exec.t_context;    ',
'    l_emailsidx  pls_integer;',
'    l_namesids    pls_integer;',
'    l_users    pls_integer;',
'    l_titles    pls_integer;',
'    l_region_id number;',
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
'    while apex_exec.next_row( l_context ) loop        ',
'        apex_mail.send (',
'        p_from               => ''hghareb@dctabudhabi.ae'' ,   ',
'        p_to                 => apex_exec.get_varchar2( l_context, l_emailsidx ),',
'        p_template_static_id => ''PETTY_CASH_INVITATION'',',
'        p_placeholders       => ''{'' ||',
'        ''    "TITLE":''            || apex_json.stringify( apex_exec.get_varchar2( l_context, l_titles )) ||    ',
'        ''   , "EMP_NAME":''            || apex_json.stringify( apex_exec.get_varchar2( l_context, l_namesids )) ||',
'        ''   , "USER_NAME":''            || apex_json.stringify( apex_exec.get_varchar2( l_context, l_users )) ||',
'        ''   , "MY_APPLICATION_LINK":'' || apex_json.stringify(''https://ifinance.dct.gov.ae:8004/dct/f?p=100:1'') ||    ',
'        ''}'' );',
'     end loop;',
' ',
'     apex_exec.close( l_context );',
'     apex_mail.push_queue;',
'exception',
'     when others then',
'         apex_exec.close( l_context );',
'     raise; ',
'end;',
''))
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(537306563427169)
,p_event_id=>wwv_flow_api.id(534548916427141)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Invitation emails sent successfully.'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4586337003120875)
,p_name=>'Send Invitation mail'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(534294182427139)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4586458508120876)
,p_event_id=>wwv_flow_api.id(4586337003120875)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.message.showPageSuccess( "Invitation Emails Sent Successfully." );'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6653737961135485)
,p_name=>'New'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(6653645276135484)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6653781325135486)
,p_event_id=>wwv_flow_api.id(6653737961135485)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'l_count                     NUMBER;',
'l_petty_cash_request_id     hrss_approval_history.request_id%TYPE;',
'l_emp_num                   hrss_approval_history.employee_num%TYPE;',
'BEGIN',
'  ',
'  -- check if there are any pending petty cash requests',
'  select count(*)',
'  into l_count',
'  from hrss_approval_history',
'  where status = ''Pending'';',
'  ',
'  ',
'  if l_count > 0 Then ',
'        ',
'        for pending_list IN  (select request_id , employee_num',
'                              from hrss_approval_history',
'                              where status = ''Pending''',
'                              and EMPLOYEE_NUM = 9038',
'                        --      and request_id = 74',
'                             )',
'            Loop',
'                    petty_cash_emails.approve_reject_remider_send_email(pending_list.request_id , pending_list.employee_num);',
'        ',
'            End Loop;',
'    End if;    ',
'  ',
'END;'))
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4673622914660472)
,p_name=>'New_1'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(4673546642660471)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4673696855660473)
,p_event_id=>wwv_flow_api.id(4673622914660472)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'l_count                     NUMBER;',
'l_expense_report_id         expense_reports_all_v.expense_report_id%TYPE;',
'l_emp_num                   expense_reports_all_v.employee_num%type;',
'BEGIN',
'  ',
'  -- check if there are any pending petty cash requests',
'  select count(*)',
'  into l_count',
'  from hrss_expense_report_approval_history',
'  where status = ''Pending'';',
'  ',
'  ',
'  if l_count > 0 Then ',
'        ',
'        for pending_list IN  (select request_id , employee_num',
'                              from hrss_expense_report_approval_history',
'                              where status = ''Pending'')',
'            Loop',
'                    expense_report_emails.approve_reject_remider_send_email(pending_list.request_id , pending_list.employee_num);',
'        ',
'            End Loop;',
'    End if;    ',
'  ',
'END;'))
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(22228984831428975)
,p_name=>'New_2'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(22228898264428974)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(22229091897428976)
,p_event_id=>wwv_flow_api.id(22228984831428975)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'--null;',
'petty_cash_emails.Approve_reject_send_email(43,44);',
'',
'End;'))
,p_wait_for_result=>'Y'
);
wwv_flow_api.component_end;
end;
/
