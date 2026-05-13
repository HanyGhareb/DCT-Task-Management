prompt --application/pages/page_00052
begin
--   Manifest
--     PAGE: 00052
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
 p_id=>52
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Employee Invoices drilldown'
,p_alias=>'EMPLOYEE-INVOICES-DRILLDOWN'
,p_page_mode=>'MODAL'
,p_step_title=>'Employee Invoices drilldown'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210517100937'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(311754418829522)
,p_plug_name=>'Employee Invoices for &EMPLOYEE_NAME.'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8055912915175506)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>'select * from employees_invoices where vendor_num = :P52_VENDOR_NUM and vendor_site_code = :P52_VENDOR_SITE_CODE'
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P52_VENDOR_NUM,P52_VENDOR_SITE_CODE'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Employee Invoices for &EMPLOYEE_NAME.'
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
 p_id=>wwv_flow_api.id(311620405829522)
,p_name=>'Employee Invoices drilldown'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>32380477830632992
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(311198316829526)
,p_db_column_name=>'VENDOR_NUM'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Vendor Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(310882363829527)
,p_db_column_name=>'VENDOR_SITE_CODE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Vendor Site Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(310467873829527)
,p_db_column_name=>'BATCH_NAME'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Batch Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(310073842829528)
,p_db_column_name=>'VOUCHER_NUM'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Voucher Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(309625996829528)
,p_db_column_name=>'INVOICE_NUM'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Invoice Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(309221229829528)
,p_db_column_name=>'AMOUNT_PAID'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Amount Paid'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(308822627829528)
,p_db_column_name=>'INVOICE_AMOUNT'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Invoice Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(308471015829529)
,p_db_column_name=>'PAY_GROUP'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Pay Group'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(308077213829529)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Description'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(307679420829529)
,p_db_column_name=>'INVOICE_TYPE'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Invoice Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(307292643829530)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(306830108829530)
,p_db_column_name=>'GL_DATE'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Gl Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(306495125829530)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(306042599829530)
,p_db_column_name=>'INVOICE_VALIDATION'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Invoice Validation'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(305600658829531)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(305288046829531)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(304841024829531)
,p_db_column_name=>'LAST_UPDATED_BY'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Last Updated By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(304436741829532)
,p_db_column_name=>'LAST_UPDATE_DATE'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Last Update Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(304029481829532)
,p_db_column_name=>'PAYMENT_BY'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Payment By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(303655164829532)
,p_db_column_name=>'PAYMENT_DATE'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Payment Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(303217080829532)
,p_db_column_name=>'CHECK_NUMBER'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Check Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(301694219842071)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'323905'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'VOUCHER_NUM:INVOICE_NUM:AMOUNT_PAID:INVOICE_AMOUNT:DESCRIPTION:INVOICE_DATE:APPROVAL_STATUS:INVOICE_VALIDATION:PAYMENT_DATE:CHECK_NUMBER:'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(518725174973695)
,p_name=>'P52_VENDOR_NUM'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(311754418829522)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(518614932973694)
,p_name=>'P52_VENDOR_SITE_CODE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(311754418829522)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(518413286973692)
,p_name=>'EMPLOYEE_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(311754418829522)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.component_end;
end;
/
