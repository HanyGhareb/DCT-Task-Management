prompt --application/pages/page_00044
begin
--   Manifest
--     PAGE: 00044
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
 p_id=>44
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'Invitations'
,p_alias=>'INVITATIONS'
,p_step_title=>'Invitations'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220930053054'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(108490915349275665)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10254567086597785)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(10191147067597728)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(10308621936597827)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(108491524772275665)
,p_plug_name=>'Invitation - Petty Cash '
,p_region_name=>'USERS'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10243288598597779)
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
 p_id=>wwv_flow_api.id(108491697270275665)
,p_name=>'Invitation - Petty Cash '
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_control_break=>'N'
,p_show_computation=>'N'
,p_show_aggregate=>'N'
,p_show_chart=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>108491697270275665
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39950655068840092)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Employee No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39951032240840092)
,p_db_column_name=>'TITLE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39951499253840092)
,p_db_column_name=>'FULL_NAME_AR'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Name (AR)'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39951804239840092)
,p_db_column_name=>'MANAGER_FLAG'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Manager ?'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39952247752840091)
,p_db_column_name=>'SUPERVISOR_NUM'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Line Manager No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39949457752840093)
,p_db_column_name=>'EMAIL'
,p_display_order=>17
,p_column_identifier=>'H'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39949855549840093)
,p_db_column_name=>'EMP_NAME'
,p_display_order=>27
,p_column_identifier=>'I'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39950270598840093)
,p_db_column_name=>'USER_NAME'
,p_display_order=>37
,p_column_identifier=>'J'
,p_column_label=>'User Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39952653826840091)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>47
,p_column_identifier=>'L'
,p_column_label=>'Organization'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39953071327840091)
,p_db_column_name=>'ORG_ID'
,p_display_order=>57
,p_column_identifier=>'M'
,p_column_label=>'Org ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(108495880826304101)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'399534'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'EMPLOYEE_NUM:TITLE:EMP_NAME:USER_NAME:EMAIL:ORG_NAME:'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(76524098230021941)
,p_application_user=>'TCA9051'
,p_name=>'New Users - PMs '
,p_report_seq=>10
,p_display_rows=>20
,p_report_columns=>'EMPLOYEE_NUM:TITLE:EMP_NAME:USER_NAME:EMAIL:ORG_NAME:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(76524247063021941)
,p_report_id=>wwv_flow_api.id(76524098230021941)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'EMPLOYEE_NUM'
,p_operator=>'in'
,p_expr=>'1278,846,1199,60017,1394,1505,1289,1208,2000430,1399,9091,1291'
,p_condition_sql=>'"EMPLOYEE_NUM" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#, #APXWS_EXPR_VAL3#, #APXWS_EXPR_VAL4#, #APXWS_EXPR_VAL5#, #APXWS_EXPR_VAL6#, #APXWS_EXPR_VAL7#, #APXWS_EXPR_VAL8#, #APXWS_EXPR_VAL9#, #APXWS_EXPR_VAL10#, #APXWS_EXPR_VAL11#, #APXWS_EXPR_VAL12#)'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''1278, 846, 1199, 60017, 1394, 1505, 1289, 1208, 2000430, 1399, 9091, 1291''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(76524340597021941)
,p_report_id=>wwv_flow_api.id(76524098230021941)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'EMP_NAME'
,p_operator=>'is not null'
,p_condition_sql=>'"EMP_NAME" is not null'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(39955411031840089)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(108491524772275665)
,p_button_name=>'Send_Email'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Send Email'
,p_button_position=>'TOP'
,p_button_redirect_url=>'f?p=&APP_ID.:45:&SESSION.::&DEBUG.:45::'
,p_icon_css_classes=>'fa-envelope-plus'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(39956442343840086)
,p_name=>'Send'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(39955411031840089)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
,p_display_when_type=>'NEVER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(39957970628840085)
,p_event_id=>wwv_flow_api.id(39956442343840086)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure to send Invitation email to all these employees ?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(39956973615840086)
,p_event_id=>wwv_flow_api.id(39956442343840086)
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
 p_id=>wwv_flow_api.id(39957458821840086)
,p_event_id=>wwv_flow_api.id(39956442343840086)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Invitation emails sent successfully.'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(39958349027840085)
,p_name=>'Send Invitation mail'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(39955411031840089)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(39958858296840085)
,p_event_id=>wwv_flow_api.id(39958349027840085)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.message.showPageSuccess( "Invitation Sent Successfully." );'
);
wwv_flow_api.component_end;
end;
/
