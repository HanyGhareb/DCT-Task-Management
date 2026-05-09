prompt --application/pages/page_00009
begin
--   Manifest
--     PAGE: 00009
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>116806299474925354
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>9
,p_user_interface_id=>wwv_flow_api.id(23921013981372477)
,p_name=>'Invitation - Credit Cards'
,p_alias=>'INVITATION-CREDIT-CARDS'
,p_step_title=>'Invitation - Credit Cards'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9007'
,p_last_upd_yyyymmddhh24miss=>'20210826111143'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(111423120749157562)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23845862961372548)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(23782494216372596)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(23899958141372507)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(111423730172157562)
,p_plug_name=>'Invitation - Credit Cards'
,p_region_name=>'USERS'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23834504913372554)
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
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Invitation - Credit Cards'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(111423902670157562)
,p_name=>'Invitation - Petty Cash '
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_computation=>'N'
,p_show_aggregate=>'N'
,p_show_chart=>'N'
,p_show_group_by=>'N'
,p_show_pivot=>'N'
,p_show_flashback=>'N'
,p_show_reset=>'N'
,p_show_help=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>111423902670157562
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33816512880383175)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Employee No'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33816949614383175)
,p_db_column_name=>'TITLE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Title'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33817376928383175)
,p_db_column_name=>'FULL_NAME_AR'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Full Name Ar'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33817760967383174)
,p_db_column_name=>'MANAGER_FLAG'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Manager Flag'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33818121517383174)
,p_db_column_name=>'SUPERVISOR_NUM'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Supervisor Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33815368651383178)
,p_db_column_name=>'EMAIL'
,p_display_order=>17
,p_column_identifier=>'H'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33815769841383176)
,p_db_column_name=>'EMP_NAME'
,p_display_order=>27
,p_column_identifier=>'I'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33816171515383176)
,p_db_column_name=>'USER_NAME'
,p_display_order=>37
,p_column_identifier=>'J'
,p_column_label=>'User Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33818557483383174)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>47
,p_column_identifier=>'L'
,p_column_label=>'Organization'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33818974152383174)
,p_db_column_name=>'ORG_ID'
,p_display_order=>57
,p_column_identifier=>'M'
,p_column_label=>'Org Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(111428086226185998)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'338193'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'EMPLOYEE_NUM:TITLE:EMP_NAME:USER_NAME:SUPERVISOR_NUM:EMAIL:ORG_NAME:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(33820571676383169)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(111423730172157562)
,p_button_name=>'Send_Email'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Send Email'
,p_button_position=>'TOP'
,p_button_redirect_url=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.::P10_RESET_PW:N'
,p_icon_css_classes=>'fa-envelope-plus'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(33821550904383166)
,p_name=>'Send'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(33820571676383169)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
,p_display_when_type=>'NEVER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33822086055383165)
,p_event_id=>wwv_flow_api.id(33821550904383166)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure to send Invitation email to all these employees ?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33822520213383164)
,p_event_id=>wwv_flow_api.id(33821550904383166)
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
 p_id=>wwv_flow_api.id(33823031888383164)
,p_event_id=>wwv_flow_api.id(33821550904383166)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Invitation emails sent successfully.'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(33823475385383164)
,p_name=>'Send Invitation mail'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(33820571676383169)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33823960558383164)
,p_event_id=>wwv_flow_api.id(33823475385383164)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.message.showPageSuccess( "Invitation Emails Sent Successfully." );'
);
wwv_flow_api.component_end;
end;
/
