prompt --application/pages/page_00064
begin
--   Manifest
--     PAGE: 00064
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
 p_id=>64
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Reminders'
,p_alias=>'REMINDERS'
,p_step_title=>'Reminders'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231207223354'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(140535920859358846)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8067277693175509)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_menu_id=>wwv_flow_api.id(8003821207175482)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(8121335853175533)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(145282642326452871)
,p_plug_name=>'Reminders Report'
,p_region_name=>'USERS'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8055912915175506)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'        type,',
'       EMPLOYEE_NUM,',
'       EMAIL,',
'       EMP_NAME,',
'       STATUS,',
'       SENT_COUNT,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE',
'  from HRSS_PETTY_CASH_REMINDERS'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Reminders Report'
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
 p_id=>wwv_flow_api.id(145283055955452871)
,p_name=>'Report 1'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:65:&SESSION.::&DEBUG.:RP:P65_ID:\#ID#\'
,p_detail_link_text=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_owner=>'TCA9051'
,p_internal_uid=>213268555602855140
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(145283187163452872)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(145283587469452881)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(145283913149452881)
,p_db_column_name=>'EMAIL'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Email'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(145284349149452881)
,p_db_column_name=>'EMP_NAME'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Name'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(145284749050452881)
,p_db_column_name=>'STATUS'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(145285172289452882)
,p_db_column_name=>'SENT_COUNT'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Sent Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(145285505915452882)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1745094403973772)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(145285997586452882)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1745094403973772)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(145286306560452882)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(145286762715452883)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140536713699358854)
,p_db_column_name=>'TYPE'
,p_display_order=>20
,p_column_identifier=>'K'
,p_column_label=>'Type'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(145298994724482996)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'2132845'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'TYPE:EMPLOYEE_NUM:EMAIL:EMP_NAME:SENT_COUNT:STATUS:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(145530462422042714)
,p_report_id=>wwv_flow_api.id(145298994724482996)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Sent'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Sent''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(145288125927452884)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(140535920859358846)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:65:&SESSION.::&DEBUG.:65'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(140536010822358847)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(140535920859358846)
,p_button_name=>'Upload'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_image_alt=>'Upload'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:66:&SESSION.::&DEBUG.:66::'
,p_icon_css_classes=>'fa-cloud-upload'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(140536101495358848)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(140535920859358846)
,p_button_name=>'Validate'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_image_alt=>'Validate'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(140536823516358855)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(140535920859358846)
,p_button_name=>'Send_Reminder'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_image_alt=>'Send Reminder'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-envelope-o'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(145287164962452883)
,p_name=>'Edit Report - Dialog Closed'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(145282642326452871)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(145287638482452884)
,p_event_id=>wwv_flow_api.id(145287164962452883)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(145282642326452871)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(140536247100358849)
,p_name=>'Validate DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(140536101495358848)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(140536383687358850)
,p_event_id=>wwv_flow_api.id(140536247100358849)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'getting Employees Details?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(140536420910358851)
,p_event_id=>wwv_flow_api.id(140536247100358849)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update HRSS_PETTY_CASH_REMINDERS s',
'set s.status = ''New''',
', s.EMAIL = user_details.get_emp_Email(user_details.get_personId_by_empNumber(s.EMPLOYEE_NUM))',
', s.EMP_NAME = user_details.get_full_name(user_details.get_personId_by_empNumber(s.EMPLOYEE_NUM));'))
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(140536525628358852)
,p_event_id=>wwv_flow_api.id(140536247100358849)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Fetched Successfully.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(140536674170358853)
,p_event_id=>wwv_flow_api.id(140536247100358849)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(145282642326452871)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(140536960106358856)
,p_name=>'Remider DA'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(140536823516358855)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(140537077919358857)
,p_event_id=>wwv_flow_api.id(140536960106358856)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'you are going to send reminder email for all available Employees in this table?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(140537143434358858)
,p_event_id=>wwv_flow_api.id(140536960106358856)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare ',
'    l_context          apex_exec.t_context;    ',
'    l_id               pls_integer;',
'    l_emailsidx        pls_integer;',
'    l_namesids         pls_integer;',
'    l_TYPE               pls_integer;',
'    l_EMP_NAME          pls_integer;',
'    l_TYPE_DESC           varchar2(100);',
'    l_desc             pls_integer;',
'    l_region_id        number;',
'    l_vendor       pls_integer;',
'    ',
'    l_email_id          Number;',
'',
'begin',
'    -- Get the region id for the CUSTOMERS IR region',
'    select region_id',
'      into l_region_id',
'      from apex_application_page_regions',
'     where application_id = :APP_ID',
'       and page_id        = 64',
'       and static_id      = ''USERS'';',
' ',
'    -- Get the query context for the CUSTOMERS IR Region',
'    -- Documentation: https://docs.oracle.com/en/database/oracle/application-express/19.2/aeapi/OPEN_QUERY_CONTEXT-Function.html',
'    l_context := apex_region.open_query_context (',
'                        p_page_id => 64 ,',
'                        p_region_id => l_region_id );',
'                        ',
'    -- Get the column positions for EMAIL and NAME columns',
'    l_id        := apex_exec.get_column_position( l_context, ''ID'' );',
'',
'    l_TYPE      := apex_exec.get_column_position( l_context, ''TYPE'' );',
'   ',
'    l_EMP_NAME  := apex_exec.get_column_position( l_context, ''EMP_NAME'' );',
'    l_emailsidx := apex_exec.get_column_position( l_context, ''EMAIL'' );',
'    ',
'    -- Loop throught the query of the context',
'    while apex_exec.next_row( l_context ) loop  ',
'    ',
'        l_TYPE_DESC  := case lower(apex_exec.get_varchar2( l_context, l_TYPE )) when ''permanent'' then ''reimbursement ''',
'                                                                                                         when ''temporary'' then ''clearing''',
'                        end;',
'                        ',
'       l_email_id := apex_mail.send (',
'        p_from               => ''ifinance@dctabudhabi.ae'' ,   ',
'        p_to                 => apex_exec.get_varchar2( l_context, l_emailsidx ),',
'--        p_cc                 => ''APInquiry@dctabudhabi.ae'',',
' --       p_cc                 => ''ifinance@dctabudhabi.ae,hghareb@dctabudhabi.ae'',         ',
'        p_template_static_id => ''TEMP_CLOSEING_REMINDER'',',
'        p_placeholders       => ''{'' ||',
'        ''    "TYPE":''               || apex_json.stringify( apex_exec.get_varchar2( l_context, l_TYPE ))     ||  ',
'        ''   , "TYPE_DESC":''          || apex_json.stringify(l_TYPE_DESC)                                      ||    ',
'        ''   , "EMP_NAME":''          || apex_json.stringify( apex_exec.get_varchar2( l_context, l_EMP_NAME )) ||    ',
'        ''   ,"NOTES":''              || apex_json.stringify( :P64_NOTE )                                      ||    ',
'        ''}'' );',
'  --***************      ',
'--        FOR c1 IN (SELECT FILENAME, FILE_BLOB, FILE_MIMETYPE ',
'--                    FROM SCM_PENDING_GRN_DOCUMENTS',
'--                   ) LOOP',
'--            ',
'--                    APEX_MAIL.ADD_ATTACHMENT(',
'--                        p_mail_id    => l_email_id,',
'--                        p_attachment => c1.FILE_BLOB,',
'--                        p_filename   => c1.FILENAME,',
'--                        p_mime_type  => c1.FILE_MIMETYPE);',
'--                    END LOOP;',
'--    COMMIT;',
'        ',
' --*****************       ',
'        update HRSS_PETTY_CASH_REMINDERS S',
'        set S.status = ''Sent'', s.SENT_COUNT = nvl(s.SENT_COUNT , 0) + 1',
'        where id = apex_json.stringify( apex_exec.get_number( l_context, l_id ));',
'     end loop;',
' ',
'     apex_exec.close( l_context );',
'     apex_mail.push_queue;',
'exception',
'     when others then',
'         apex_exec.close( l_context );',
'     raise; ',
'end;'))
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(140537239566358859)
,p_event_id=>wwv_flow_api.id(140536960106358856)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(145282642326452871)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(140537315449358860)
,p_event_id=>wwv_flow_api.id(140536960106358856)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Sent Successfully'
);
wwv_flow_api.component_end;
end;
/
