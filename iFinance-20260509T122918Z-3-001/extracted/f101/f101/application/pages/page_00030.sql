prompt --application/pages/page_00030
begin
--   Manifest
--     PAGE: 00030
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
 p_id=>30
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Petty Cash - Expenses Reports'
,p_alias=>'PETTY-CASH-EXPENSES-REPORTS'
,p_step_title=>'Petty Cash - Expenses Reports'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200913062939'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(4458306487254651)
,p_plug_name=>'Expense Reports Report '
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8055912915175506)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select er.EXPENSE_REPORT_ID,',
'       er.PETTY_CASH_ID,',
'       er.EXPENSE_REPORT_DATE,',
'       er.PURPOSE,',
'       er.APPROVAL_STATUS,',
'       er.INVOICING_YN,',
'       decode(er.PRIORITY , ''L'' , ''Low'' , ''M'' , ''Medium'' , ''H'' , ''High'') PRIORITY,',
'       er.JUSTIFICATION,',
'       er.COMMENT_TO_APPROVER,',
'       er.CREATION_DATE,',
'       er.CREATED_BY,',
'       er.UPDATED_BY,',
'       er.UPDATED_DATE,',
'       er.YEAR,',
'       er.EXPENSE_REPORT_NUM,',
'       er.PAID_YN,',
'       decode(er.TYPE, ''C'' , ''Clearing'' , ''R'' , ''Reimb'') TYPE,',
'       pc.amount    petty_cash_amount',
'    ,  pc.petty_cash_type ',
'    , (select nvl(sum(l.RECEIPT_AMOUNT), 0) from HRSS_EXPENSE_REPORT_LINES l where l.EXPENSE_REPORT_ID = er.EXPENSE_REPORT_ID) Report_amount',
'  from HRSS_EXPENSE_REPORTS er , hrss_petty_cash pc',
'  where er.petty_cash_id = pc.petty_cash_id',
'  and er.petty_cash_id = :P30_PETTY_CASH_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P30_PETTY_CASH_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Expense Reports Report '
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
 p_id=>wwv_flow_api.id(4458694737254651)
,p_name=>'Report 1'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:31:&SESSION.::&DEBUG.:RP,:P31_EXPENSE_REPORT_ID,P31_FROM_PAGE:\#EXPENSE_REPORT_ID#\,30'
,p_detail_link_text=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_owner=>'TCA9051'
,p_internal_uid=>6448733064318415
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4458845238254652)
,p_db_column_name=>'EXPENSE_REPORT_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Expense Report Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4459247620254652)
,p_db_column_name=>'PETTY_CASH_ID'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Petty Cash Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4459596366254653)
,p_db_column_name=>'EXPENSE_REPORT_DATE'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Expense Report Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4459993166254653)
,p_db_column_name=>'PURPOSE'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Purpose'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4460408452254653)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4460857389254653)
,p_db_column_name=>'INVOICING_YN'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Invoiced ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4461212822254654)
,p_db_column_name=>'PRIORITY'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4461592590254654)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4462016886254654)
,p_db_column_name=>'COMMENT_TO_APPROVER'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Comment To Approver'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4462459286254654)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4462779568254655)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4463197818254655)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4463616147254655)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4463987751254655)
,p_db_column_name=>'YEAR'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4464450972254656)
,p_db_column_name=>'EXPENSE_REPORT_NUM'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Expense Report Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4464835934254656)
,p_db_column_name=>'PAID_YN'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Paid ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4465215400254656)
,p_db_column_name=>'TYPE'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4398949786542085)
,p_db_column_name=>'PETTY_CASH_AMOUNT'
,p_display_order=>27
,p_column_identifier=>'R'
,p_column_label=>'Petty Cash Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4398987347542086)
,p_db_column_name=>'PETTY_CASH_TYPE'
,p_display_order=>37
,p_column_identifier=>'S'
,p_column_label=>'Petty Cash Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8333351243197780)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4525495552154937)
,p_db_column_name=>'REPORT_AMOUNT'
,p_display_order=>47
,p_column_identifier=>'T'
,p_column_label=>'Report Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(4468304686262411)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'64584'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'EXPENSE_REPORT_NUM:TYPE:APPROVAL_STATUS:EXPENSE_REPORT_DATE:REPORT_AMOUNT:PRIORITY:JUSTIFICATION:COMMENT_TO_APPROVER:INVOICING_YN:PAID_YN:PETTY_CASH_AMOUNT:PETTY_CASH_TYPE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(4465803820254657)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8067277693175509)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(8003821207175482)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(8121335853175533)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4467042560254658)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(4458306487254651)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Expense Report'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:31:&SESSION.::&DEBUG.:31:P31_PETTY_CASH_ID,P31_PETTY_CASH_NO,P31_PETTY_CASH_AMOUNT,P31_PETTY_CASH_TYPE:&P30_PETTY_CASH_ID.,&P30_PETTY_CASH_NO.,&P30_PETTY_CASH_AMOUNT.,&P30_PETTY_CASH_TYPE.'
,p_icon_css_classes=>'fa-plus-circle-o'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4397613396542072)
,p_name=>'P30_PETTY_CASH_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(4465803820254657)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4397707503542073)
,p_name=>'P30_PETTY_CASH_NO'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(4465803820254657)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4397853072542074)
,p_name=>'P30_PETTY_CASH_TYPE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(4465803820254657)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4525704565154939)
,p_name=>'P30_PETTY_CASH_AMOUNT'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(4465803820254657)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.component_end;
end;
/
