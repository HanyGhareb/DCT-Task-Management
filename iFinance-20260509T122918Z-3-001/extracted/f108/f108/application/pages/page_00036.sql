prompt --application/pages/page_00036
begin
--   Manifest
--     PAGE: 00036
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>500
,p_default_id_offset=>354480484490134169
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>36
,p_user_interface_id=>wwv_flow_api.id(19279151117383422)
,p_name=>'Employees Messages'
,p_alias=>'EMPLOYEES-MESSAGES'
,p_step_title=>'Employees Messages'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220602065913'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(97052865550732134)
,p_plug_name=>'Note'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(19194535783383347)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(106759714860642916)
,p_plug_name=>'Employees - Report'
,p_region_name=>'USERS'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders'
,p_plug_template=>wwv_flow_api.id(19192662303383345)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select EMP_NAME,',
'       EMAIL,',
'       STATUS',
'  from EMPLOYEES_MESSAGES'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P36_NOTE'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Employees - Report'
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
 p_id=>wwv_flow_api.id(106760193492642917)
,p_name=>'Report 1'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:37:&SESSION.::&DEBUG.:RP,:P37_EMAIL:#EMAIL##ID#\'
,p_detail_link_text=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_owner=>'TCA9051'
,p_internal_uid=>159072514991365507
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54974162891006350)
,p_db_column_name=>'EMP_NAME'
,p_display_order=>10
,p_column_identifier=>'R'
,p_column_label=>'Emp Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54974264477006351)
,p_db_column_name=>'EMAIL'
,p_display_order=>20
,p_column_identifier=>'S'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(56766011001399711)
,p_db_column_name=>'STATUS'
,p_display_order=>30
,p_column_identifier=>'T'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(106773141200660924)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1090367'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'VENDOR_:EMP_NAME:EMAIL:STATUS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(106768907611642927)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(19203962458383352)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(19140599913383303)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(19258056279383396)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(56725517398755099)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(106768907611642927)
,p_button_name=>'Validate'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(19256715332383394)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Validate'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition_type=>'NEVER'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(56725953341755099)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(106768907611642927)
,p_button_name=>'Send_Reminder'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--success:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(19256715332383394)
,p_button_image_alt=>'Send Reminder'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(54974661602006355)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(106768907611642927)
,p_button_name=>'Get_Data'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--success:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(19256715332383394)
,p_button_image_alt=>'Get Data'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-calendar-arrow-down'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(56726366688755099)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(106768907611642927)
,p_button_name=>'Upload'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(19256715332383394)
,p_button_image_alt=>'Upload'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:28:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-upload'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(56726745612755099)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(106768907611642927)
,p_button_name=>'Clear'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(19256715332383394)
,p_button_image_alt=>'Clear'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-remove'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(56727084955755098)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(106768907611642927)
,p_button_name=>'DOCUMENT'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(19256715332383394)
,p_button_image_alt=>'Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:32:&SESSION.::&DEBUG.::P32_TYPE:REC'
,p_icon_css_classes=>'fa-file-powerpoint-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(56724827920755100)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(106759714860642916)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(19256621748383394)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:27:&SESSION.::&DEBUG.:27'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(56716916260755111)
,p_name=>'P36_NOTE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(97052865550732134)
,p_prompt=>'Note'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>150
,p_cHeight=>3
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(56730191141755095)
,p_name=>'Edit Report - Dialog Closed'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(106759714860642916)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(56730747558755094)
,p_event_id=>wwv_flow_api.id(56730191141755095)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(106759714860642916)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(56731092856755094)
,p_name=>'Validate DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(56725517398755099)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(56731651920755094)
,p_event_id=>wwv_flow_api.id(56731092856755094)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'getting available vendors mails?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(56732171537755094)
,p_event_id=>wwv_flow_api.id(56731092856755094)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update scm_pending_grn grn',
'set grn.status = ''New''',
', grn.REQUESTER_EMAIL = (select e.email from employees_v e where e.full_name_en = grn.requester)',
', grn.vendor_email = (select vc.EMAIL_ADDRESS ',
'                        from vendor_contacts vc',
'                        where vc.VENDOR_NUMBER = (select v.VENDOR_NUMBER',
'                                                    from vendors v',
'                                                    where v.ENABLED_FLAG = ''Y''',
'                                                    and v.VENDOR_SITE_STATUS = ''Active''',
'                                                    and v.VENDOR_NAME = grn.VENDOR',
'                                                    and rownum = 1)',
'                        and vc.VENDOR_SITE_STATUS = ''Active''',
'                        and vc.EMAIL_ADDRESS is not null',
'                        and rownum = 1);'))
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(56732629070755094)
,p_event_id=>wwv_flow_api.id(56731092856755094)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Fetched Successfully.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(56733168207755093)
,p_event_id=>wwv_flow_api.id(56731092856755094)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(106759714860642916)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(56733522117755093)
,p_name=>'Remider DA'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(56725953341755099)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(56734075406755093)
,p_event_id=>wwv_flow_api.id(56733522117755093)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'you are going to send reminder email for all available Vendores in this table?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(56734533078755093)
,p_event_id=>wwv_flow_api.id(56733522117755093)
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
'    l_pos               pls_integer;',
'    l_po_date          pls_integer;',
'    l_Amount           pls_integer;',
'    l_desc             pls_integer;',
'    l_region_id        number;',
'    l_vendor       pls_integer;',
'    ',
'    l_email_id          Number;',
'    l_emp_name          pls_integer;',
'',
'begin',
'    -- Get the region id for the CUSTOMERS IR region',
'    select region_id',
'      into l_region_id',
'      from apex_application_page_regions',
'     where application_id = :APP_ID',
'       and page_id        = 36',
'       and static_id      = ''USERS'';',
' ',
'    -- Get the query context for the CUSTOMERS IR Region',
'    -- Documentation: https://docs.oracle.com/en/database/oracle/application-express/19.2/aeapi/OPEN_QUERY_CONTEXT-Function.html',
'    l_context := apex_region.open_query_context (',
'                        p_page_id => 36,',
'                        p_region_id => l_region_id );',
'    -- Get the column positions for EMAIL and NAME columns',
'--    l_id        := apex_exec.get_column_position( l_context, ''ID'' );',
'',
'    l_emp_name := apex_exec.get_column_position( l_context, ''EMP_NAME'' );',
' --   l_vendor   := apex_exec.get_column_position( l_context, ''VENDOR'' );',
'    l_emailsidx := apex_exec.get_column_position( l_context, ''EMAIL'' );',
'    ',
'    -- Loop throught the query of the context',
'    while apex_exec.next_row( l_context ) loop  ',
'    ',
'    ',
'       l_email_id := apex_mail.send (',
'        p_from               => ''ifinance@dctabudhabi.ae'' ,   ',
'        p_to                 => apex_exec.get_varchar2( l_context, l_emailsidx ),',
' --       p_to                 => ''hghareb@dctabudhabi.ae'',',
' --       p_cc                 => ''APInquiry@dctabudhabi.ae'',',
' --       p_cc                 => ''ifinance@dctabudhabi.ae,hghareb@dctabudhabi.ae'',         ',
'        p_template_static_id => ''EMPLOYEES_MESSAGES'',',
'        p_placeholders       => ''{'' ||',
'        ''    "EMP_NAME":''            || apex_json.stringify( apex_exec.get_varchar2( l_context, l_emp_name )) ||    ',
'        ''}'' );',
'  --***************      ',
'        FOR c1 IN (SELECT FILENAME, FILE_BLOB, FILE_MIMETYPE ',
'                    FROM SCM_PENDING_GRN_DOCUMENTS',
'                    WHERE type = ''REC''',
'                   ) LOOP',
'            ',
'                    APEX_MAIL.ADD_ATTACHMENT(',
'                        p_mail_id    => l_email_id,',
'                        p_attachment => c1.FILE_BLOB,',
'                        p_filename   => c1.FILENAME,',
'                        p_mime_type  => c1.FILE_MIMETYPE);',
'                    END LOOP;',
'    COMMIT;',
'        ',
' --*****************       ',
'        update employees_messages grn',
'        set grn.status = ''Sent''',
'        where EMP_NAME = apex_json.stringify(apex_exec.get_varchar2( l_context, l_emp_name ));',
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
 p_id=>wwv_flow_api.id(56734981357755092)
,p_event_id=>wwv_flow_api.id(56733522117755093)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(106759714860642916)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(56735550818755092)
,p_event_id=>wwv_flow_api.id(56733522117755093)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Sent Successfully'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(56727849518755096)
,p_name=>'Clear DA'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(56726745612755099)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(56728824022755095)
,p_event_id=>wwv_flow_api.id(56727849518755096)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Delete all records?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(56728343100755096)
,p_event_id=>wwv_flow_api.id(56727849518755096)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'delete from EMPLOYEES_MESSAGES;',
'end;'))
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(56729325732755095)
,p_event_id=>wwv_flow_api.id(56727849518755096)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'All record deleted Successfully.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(56729867550755095)
,p_event_id=>wwv_flow_api.id(56727849518755096)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(106759714860642916)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(54974716009006356)
,p_name=>'Get Data DA'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(54974661602006355)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54974814124006357)
,p_event_id=>wwv_flow_api.id(54974716009006356)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'you are going refresh the data for all employees?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54974938906006358)
,p_event_id=>wwv_flow_api.id(54974716009006356)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'delete from EMPLOYEES_MESSAGES;',
'',
'insert into employees_messages (EMP_NAME , email)',
'select TITLE || '' '' || FULL_NAME_EN emp_name, EMAIL',
'from employees_v',
'where CURRENT_FLAG = ''Y''',
'and employee_num not in (318,',
'1111,',
'23,',
'902,',
'7005,',
'1269,',
'8,',
'--1577,',
'1353,',
'57,',
'1140,',
'427,',
'17,',
'1583,',
'--229,',
'1452,',
'1263,',
'1039)',
'--and rownum < 4',
';'))
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54975053310006359)
,p_event_id=>wwv_flow_api.id(54974716009006356)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(106759714860642916)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54975130626006360)
,p_event_id=>wwv_flow_api.id(54974716009006356)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Refresh Successfully.'
);
wwv_flow_api.component_end;
end;
/
