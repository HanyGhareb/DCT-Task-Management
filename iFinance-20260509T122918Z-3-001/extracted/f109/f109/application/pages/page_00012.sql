prompt --application/pages/page_00012
begin
--   Manifest
--     PAGE: 00012
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>666
,p_default_id_offset=>90826491306730853
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>12
,p_user_interface_id=>wwv_flow_api.id(11217697745956116)
,p_name=>'Contract Drill-down'
,p_alias=>'CONTRACT-DRILL-DOWN'
,p_step_title=>'Contract Drill-down'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210828180551'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(21630898492212700)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(11142414762956053)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(11079053308956006)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(11196517955956091)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(21631400474212701)
,p_plug_name=>'Invoices of Contract &P12_CONTRACT_NUMBER. '
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(11133056164956048)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select INVOICE_NUMBER,',
'       VOUCHER_NUMBER,',
'       CONTRACT_NUMBER,',
'       DESCRIPTION,',
'       INVOICE_DATE,',
'       INVOICE_RECEIVED_DATE,',
'       APPROVAL_STATUS,',
'       INVOICE_VALIDATION,',
'       INVOICE_TYPE,',
'       PAYMENT_METHOD,',
'       SOURCE,',
'       PAYMENT_STATUS,',
'       CURRENCY_CODE,',
'       CREATION_DATE,',
'       CREATED_BY,',
'       VALIDATION_DATE,',
'       VALIDATED_BY,',
'       VALIDATED_USER,',
'       FINAL_APPROVAL_DATE,',
'       APPROVED_BY,',
'       EXCHANGE_RATE,',
'       EXCHANGE_DATE,',
'       PAYMENT_DATE,',
'       INVOICE_AMOUNT,',
'       FUNCTIONAL_AMOUNT',
'  from CWIP_CONTRACT_INVOICES',
' where CONTRACT_NUMBER = :P12_CONTRACT_NUMBER',
' and approval_status != ''CANCELLED'''))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P12_CONTRACT_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P12_SHOW_REPORT'
,p_plug_display_when_cond2=>'Invoices'
,p_prn_document_header=>'SERVER'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A3'
,p_prn_width=>420
,p_prn_height=>297
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Invoices of Contract &P12_CONTRACT_NUMBER.'
,p_prn_page_header_font_color=>'#175C30'
,p_prn_page_header_font_family=>'Courier'
,p_prn_page_header_font_weight=>'bold'
,p_prn_page_header_font_size=>'14'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#175C30'
,p_prn_header_font_color=>'#FFFFFF'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'12'
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
 p_id=>wwv_flow_api.id(21631526970212701)
,p_name=>'Contract Drill-down'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>21631526970212701
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21631935567212705)
,p_db_column_name=>'INVOICE_NUMBER'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Invoice Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21632373915212706)
,p_db_column_name=>'VOUCHER_NUMBER'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Voucher Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21632786194212706)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21633161525212706)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21633534402212707)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21633992573212707)
,p_db_column_name=>'INVOICE_RECEIVED_DATE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Invoice Received Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21634360095212707)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21634767088212707)
,p_db_column_name=>'INVOICE_VALIDATION'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Invoice Validation'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21635124282212708)
,p_db_column_name=>'INVOICE_TYPE'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Invoice Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21635561910212708)
,p_db_column_name=>'PAYMENT_METHOD'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Payment Method'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21635945809212708)
,p_db_column_name=>'SOURCE'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Source'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21636394660212708)
,p_db_column_name=>'PAYMENT_STATUS'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Payment Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(11414111784180670)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21636785383212709)
,p_db_column_name=>'CURRENCY_CODE'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21637125359212709)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21637520317212709)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21637908530212709)
,p_db_column_name=>'VALIDATION_DATE'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Validation Date'
,p_column_type=>'STRING'
,p_format_mask=>'DD-MON-YYYY'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21638361680212710)
,p_db_column_name=>'VALIDATED_BY'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Validated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21638740313212710)
,p_db_column_name=>'VALIDATED_USER'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Validated User'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21639150191212710)
,p_db_column_name=>'FINAL_APPROVAL_DATE'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Final Approval Date'
,p_column_type=>'STRING'
,p_format_mask=>'DD-MON-YYYY'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21639585299212710)
,p_db_column_name=>'APPROVED_BY'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Approved By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21639942427212711)
,p_db_column_name=>'EXCHANGE_RATE'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Exchange Rate'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DD-MON-YYYY'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21640346864212711)
,p_db_column_name=>'EXCHANGE_DATE'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Exchange Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21640764068212711)
,p_db_column_name=>'PAYMENT_DATE'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Payment Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21641119335212711)
,p_db_column_name=>'INVOICE_AMOUNT'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21641571434212712)
,p_db_column_name=>'FUNCTIONAL_AMOUNT'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'Functional Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(21642920796224002)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'216430'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'INVOICE_NUMBER:INVOICE_AMOUNT:CURRENCY_CODE:DESCRIPTION:INVOICE_DATE:APPROVAL_STATUS:PAYMENT_METHOD:PAYMENT_STATUS:PAYMENT_DATE'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(22342517233366313)
,p_plug_name=>'Payments Recommendations of Contract &P12_CONTRACT_NUMBER. '
,p_icon_css_classes=>'fa-money'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--noBorder:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(11133056164956048)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    reference_number,',
'    date_prepared,',
'    project_name,',
'    effective_date,',
'    contracting_party,',
'    agreement_period,',
'    contract_title,',
'    original_agreement_fee,',
'    agreement_ref,',
'    approved_variation,',
'    revised_agreement_fee,',
'    payment_type,',
'    invoice_num,',
'    invoice_date,',
'    total_invoice_amount,',
'    current_valuation_amount,',
'    period,',
'    deductions,',
'    previous_payments,',
'    net_amount_payable,',
'    approval_status',
'FROM',
'    cwip_bi_recommendation_payments_v ',
'where contract_number = :P12_CONTRACT_NUMBER',
'order by reference_number'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P12_CONTRACT_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P12_SHOW_REPORT'
,p_plug_display_when_cond2=>'REC'
,p_prn_document_header=>'SERVER'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A3'
,p_prn_width=>420
,p_prn_height=>297
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Payments Recommendations of Contract &P12_CONTRACT_NUMBER. '
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
 p_id=>wwv_flow_api.id(22342643429366314)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>22342643429366314
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22342735882366315)
,p_db_column_name=>'REFERENCE_NUMBER'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Reference Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22342816132366316)
,p_db_column_name=>'DATE_PREPARED'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Date Prepared'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22342954197366317)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22343052150366318)
,p_db_column_name=>'EFFECTIVE_DATE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Effective Date'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22343132205366319)
,p_db_column_name=>'CONTRACTING_PARTY'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Contracting Party'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22343278156366320)
,p_db_column_name=>'AGREEMENT_PERIOD'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Agreement Period'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22343332091366321)
,p_db_column_name=>'CONTRACT_TITLE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Contract Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22343430782366322)
,p_db_column_name=>'ORIGINAL_AGREEMENT_FEE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Original Agreement Fee'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22343579119366323)
,p_db_column_name=>'AGREEMENT_REF'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Agreement Ref'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22343613077366324)
,p_db_column_name=>'APPROVED_VARIATION'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Approved Variation'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22343741865366325)
,p_db_column_name=>'REVISED_AGREEMENT_FEE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Revised Agreement Fee'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22343804469366326)
,p_db_column_name=>'PAYMENT_TYPE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Payment Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22343923132366327)
,p_db_column_name=>'INVOICE_NUM'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Invoice Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22344009647366328)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Invoice Date'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22344193968366329)
,p_db_column_name=>'TOTAL_INVOICE_AMOUNT'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Total Invoice Amount'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22344215153366330)
,p_db_column_name=>'CURRENT_VALUATION_AMOUNT'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Current Valuation Amount'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22344389759366331)
,p_db_column_name=>'PERIOD'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Period'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22344445276366332)
,p_db_column_name=>'DEDUCTIONS'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Deductions'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22344520791366333)
,p_db_column_name=>'PREVIOUS_PAYMENTS'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Previous Payments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22344624172366334)
,p_db_column_name=>'NET_AMOUNT_PAYABLE'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Net Amount Payable'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22344732074366335)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(22485904789904885)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'224860'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REFERENCE_NUMBER:DATE_PREPARED:PROJECT_NAME:CONTRACTING_PARTY:CONTRACT_TITLE:ORIGINAL_AGREEMENT_FEE:AGREEMENT_REF:PAYMENT_TYPE:TOTAL_INVOICE_AMOUNT:DEDUCTIONS:NET_AMOUNT_PAYABLE:APPROVAL_STATUS'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(22342328972366311)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(21630898492212700)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(11195252240956089)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21268910993381915)
,p_name=>'P12_CONTRACT_NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(21630898492212700)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(22342403661366312)
,p_name=>'P12_SHOW_REPORT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(21630898492212700)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.component_end;
end;
/
