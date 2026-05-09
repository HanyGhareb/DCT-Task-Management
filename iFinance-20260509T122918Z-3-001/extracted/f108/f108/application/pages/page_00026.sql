prompt --application/pages/page_00026
begin
--   Manifest
--     PAGE: 00026
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
 p_id=>26
,p_user_interface_id=>wwv_flow_api.id(19279151117383422)
,p_name=>'Pending AP GRN - Report'
,p_alias=>'PENDING-AP-GRN-REPORT'
,p_step_title=>'Pending AP GRN - Report'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20211205063924'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11975367397745577)
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
 p_id=>wwv_flow_api.id(2268518087834795)
,p_plug_name=>'Pending AP GRN - Report'
,p_region_name=>'USERS'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders'
,p_plug_template=>wwv_flow_api.id(19192662303383345)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'SCM_PENDING_GRN'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P26_NOTE'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Pending AP GRN - Report'
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
 p_id=>wwv_flow_api.id(2268039455834794)
,p_name=>'Report 1'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:27:&SESSION.::&DEBUG.:RP:P27_ID:\#ID#\'
,p_detail_link_text=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_owner=>'TCA9051'
,p_internal_uid=>50044282042887796
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2268002676834793)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2267596655834791)
,p_db_column_name=>'PO_NUMBER'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Po Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2267152091834791)
,p_db_column_name=>'RELEASE_NO'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Release No'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2266810200834791)
,p_db_column_name=>'PO_DATE'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Po Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2266410852834791)
,p_db_column_name=>'PO_AMOUNT'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'PO Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2265936346834790)
,p_db_column_name=>'AGE_IN_DAYS'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Age In Days'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2265605394834790)
,p_db_column_name=>'VENDOR'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Vendor'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2265174900834790)
,p_db_column_name=>'VENDOR_EMAIL'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Vendor Mail'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2264762747834790)
,p_db_column_name=>'REQUESTER'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Requester'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2264373802834790)
,p_db_column_name=>'REQUESTER_EMAIL'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Requester Email'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2263941787834790)
,p_db_column_name=>'BUYER'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Buyer'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2263620761834789)
,p_db_column_name=>'BUYER_EMAIL'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Buyer Email'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2263158094834789)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2262750017834789)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2262397252834789)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2261927588834789)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2261543451834789)
,p_db_column_name=>'STATUS'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(2255091747816787)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'500573'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'PO_NUMBER:RELEASE_NO:PO_AMOUNT:AGE_IN_DAYS:VENDOR:VENDOR_EMAIL:STATUS:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(2259325336834784)
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
 p_id=>wwv_flow_api.id(11976486020745588)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(2259325336834784)
,p_button_name=>'Validate'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(19256715332383394)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Validate'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11975847138745582)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(2259325336834784)
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
 p_id=>wwv_flow_api.id(11975138966745575)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(2259325336834784)
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
 p_id=>wwv_flow_api.id(11975055723745574)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(2259325336834784)
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
 p_id=>wwv_flow_api.id(11974281132745566)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(2259325336834784)
,p_button_name=>'DOCUMENT'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(19256715332383394)
,p_button_image_alt=>'Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:32:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-file-powerpoint-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(2258208019834783)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(2268518087834795)
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
 p_id=>wwv_flow_api.id(11975224670745576)
,p_name=>'P26_NOTE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(11975367397745577)
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
 p_id=>wwv_flow_api.id(2260481515834786)
,p_name=>'Edit Report - Dialog Closed'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(2268518087834795)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(2259953061834785)
,p_event_id=>wwv_flow_api.id(2260481515834786)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(2268518087834795)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(11976328922745587)
,p_name=>'Validate DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(11976486020745588)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(11976247667745586)
,p_event_id=>wwv_flow_api.id(11976328922745587)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'getting available vendors mails?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(11976207158745585)
,p_event_id=>wwv_flow_api.id(11976328922745587)
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
 p_id=>wwv_flow_api.id(11976038419745584)
,p_event_id=>wwv_flow_api.id(11976328922745587)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Fetched Successfully.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(11975925187745583)
,p_event_id=>wwv_flow_api.id(11976328922745587)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(2268518087834795)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(11975812555745581)
,p_name=>'Remider DA'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(11975847138745582)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(11975651650745580)
,p_event_id=>wwv_flow_api.id(11975812555745581)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'you are going to send reminder email for all available Vendores in this table?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(11975483286745578)
,p_event_id=>wwv_flow_api.id(11975812555745581)
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
'',
'begin',
'    -- Get the region id for the CUSTOMERS IR region',
'    select region_id',
'      into l_region_id',
'      from apex_application_page_regions',
'     where application_id = :APP_ID',
'       and page_id        = 26',
'       and static_id      = ''USERS'';',
' ',
'    -- Get the query context for the CUSTOMERS IR Region',
'    -- Documentation: https://docs.oracle.com/en/database/oracle/application-express/19.2/aeapi/OPEN_QUERY_CONTEXT-Function.html',
'    l_context := apex_region.open_query_context (',
'                        p_page_id => 26,',
'                        p_region_id => l_region_id );',
'    -- Get the column positions for EMAIL and NAME columns',
'    l_id        := apex_exec.get_column_position( l_context, ''ID'' );',
'',
'    l_pos := apex_exec.get_column_position( l_context, ''PO_NUMBER'' );',
'    l_vendor   := apex_exec.get_column_position( l_context, ''VENDOR'' );',
'    l_emailsidx := apex_exec.get_column_position( l_context, ''VENDOR_EMAIL'' );',
'    ',
'    -- Loop throught the query of the context',
'    while apex_exec.next_row( l_context ) loop  ',
'    ',
'    ',
'       l_email_id := apex_mail.send (',
'        p_from               => ''ifinance@dctabudhabi.ae'' ,   ',
'        p_to                 => apex_exec.get_varchar2( l_context, l_emailsidx ),',
'        p_cc                 => ''APInquiry@dctabudhabi.ae'',',
' --       p_cc                 => ''ifinance@dctabudhabi.ae,hghareb@dctabudhabi.ae'',         ',
'        p_template_static_id => ''PENDING_AP_GRN_REMINDER'',',
'        p_placeholders       => ''{'' ||',
'        ''    "PO_NUMBER":''            || apex_json.stringify( apex_exec.get_varchar2( l_context, l_pos )) ||    ',
'        ''   , "VENDOR":''            || apex_json.stringify( apex_exec.get_varchar2( l_context, l_vendor )) ||    ',
'        ''   ,"NOTES":''               || apex_json.stringify( :P26_NOTE ) ||    ',
'        ''}'' );',
'  --***************      ',
'        FOR c1 IN (SELECT FILENAME, FILE_BLOB, FILE_MIMETYPE ',
'                    FROM SCM_PENDING_GRN_DOCUMENTS',
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
'        update scm_pending_grn grn',
'        set grn.status = ''Sent''',
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
 p_id=>wwv_flow_api.id(11974434494745568)
,p_event_id=>wwv_flow_api.id(11975812555745581)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(2268518087834795)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(11974393492745567)
,p_event_id=>wwv_flow_api.id(11975812555745581)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Sent Successfully'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(11975011140745573)
,p_name=>'Clear DA'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(11975055723745574)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(11974807611745571)
,p_event_id=>wwv_flow_api.id(11975011140745573)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Delete all records?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(11974885887745572)
,p_event_id=>wwv_flow_api.id(11975011140745573)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'delete from scm_pending_grn;',
'end;'))
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(11974626091745570)
,p_event_id=>wwv_flow_api.id(11975011140745573)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'All record deleted Successfully.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(11974585607745569)
,p_event_id=>wwv_flow_api.id(11975011140745573)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(2268518087834795)
);
wwv_flow_api.component_end;
end;
/
