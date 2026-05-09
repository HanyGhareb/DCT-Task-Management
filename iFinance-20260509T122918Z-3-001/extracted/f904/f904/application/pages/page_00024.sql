prompt --application/pages/page_00024
begin
--   Manifest
--     PAGE: 00024
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>24
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'Contract Details'
,p_alias=>'CONTRACT-DETAILS'
,p_step_title=>'Contract Details'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210903204745'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11871042496373942)
,p_plug_name=>'TPC Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10228155320597771)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11871840058373950)
,p_plug_name=>'Selector'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_DISPLAY_SELECTOR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'STANDARD'
,p_attribute_02=>'Y'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12203339883870627)
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
 p_id=>wwv_flow_api.id(12203945824870851)
,p_plug_name=>'Contract Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--removeHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'CWIP_CONTRACT'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11871126564373943)
,p_plug_name=>'DOF Details'
,p_parent_plug_id=>wwv_flow_api.id(12203945824870851)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10228155320597771)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11870956278373941)
,p_plug_name=>'Financial Details'
,p_parent_plug_id=>wwv_flow_api.id(11871126564373943)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:is-expanded:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10228155320597771)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(24136575251555674)
,p_plug_name=>'Payment Recommendations'
,p_icon_css_classes=>'fa-box-arrow-out-east'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    payment_recommendation_id,',
'    reference_number,',
'    payment_recommendation_date,',
'    contract_number,',
'    payment_number,',
'    payment_type,',
'    valuation_period,',
'    evaluation_method,',
'    current_valuation_amount,',
'    period,',
'    deductions,',
'    previous_payments,',
'    net_amount_payable,',
'    attachements,',
'    created_by,',
'    created_on,',
'    updated_by,',
'    updated_on,',
'    approval_status',
'from cwip_payment_recommendation p',
'where p.contract_number = :P24_CONTRACT_NUMBER'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P24_CONTRACT_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Payment Recommendations'
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
 p_id=>wwv_flow_api.id(24136706681555675)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Payments Recommendations for This Contract'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>24136706681555675
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12297109005311969)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12297596826311970)
,p_db_column_name=>'REFERENCE_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Reference Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12297976810311970)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_DATE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Payment Recommendation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12298342699311970)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12298782405311970)
,p_db_column_name=>'PAYMENT_NUMBER'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Payment Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12299162723311971)
,p_db_column_name=>'PAYMENT_TYPE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Payment Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(11865753263354609)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12299585244311971)
,p_db_column_name=>'VALUATION_PERIOD'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Valuation Period'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12299959010311971)
,p_db_column_name=>'EVALUATION_METHOD'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Evaluation Method'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(11865220875354600)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12300333744311971)
,p_db_column_name=>'CURRENT_VALUATION_AMOUNT'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Current Valuation Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12300775346311972)
,p_db_column_name=>'PERIOD'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Period'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12301185042311972)
,p_db_column_name=>'DEDUCTIONS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Deductions'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12301525708311972)
,p_db_column_name=>'PREVIOUS_PAYMENTS'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Previous Payments'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12301971888311972)
,p_db_column_name=>'NET_AMOUNT_PAYABLE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Net Amount Payable'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12302397820311973)
,p_db_column_name=>'ATTACHEMENTS'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Attachements'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12302779061311973)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12303185600311973)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12303519982311973)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12303935478311974)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12304378708311974)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(24161116019654624)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'123047'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REFERENCE_NUMBER:CONTRACT_NUMBER:PAYMENT_NUMBER:PAYMENT_TYPE:VALUATION_PERIOD:EVALUATION_METHOD:CURRENT_VALUATION_AMOUNT:PERIOD:DEDUCTIONS:PREVIOUS_PAYMENTS:NET_AMOUNT_PAYABLE:APPROVAL_STATUS:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(24146981088557455)
,p_plug_name=>'Contract Invoices'
,p_icon_css_classes=>'fa-money'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    invoice_number,',
'    voucher_number,',
'    contract_number,',
'    description,',
'    invoice_date,',
'    invoice_received_date,',
'    approval_status,',
'    invoice_validation,',
'    invoice_type,',
'    payment_method,',
'    source,',
'    payment_status,',
'    currency_code,',
'    creation_date,',
'    created_by,',
'    validation_date,',
'    validated_by,',
'    validated_user,',
'    final_approval_date,',
'    approved_by,',
'    exchange_rate,',
'    exchange_date,',
'    payment_date,',
'    invoice_amount,',
'    functional_amount',
'from cwip_contract_invoices inv',
'where inv.contract_number = :P24_CONTRACT_NUMBER',
'and inv.invoice_amount <> 0 '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P24_CONTRACT_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Project Invoices'
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
 p_id=>wwv_flow_api.id(24147093568557456)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Invoices for this Contract'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>24147093568557456
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12305468113313729)
,p_db_column_name=>'INVOICE_NUMBER'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Invoice Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12305809157313729)
,p_db_column_name=>'VOUCHER_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Voucher Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12306261861313730)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12306692405313730)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12307003973313730)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12307497083313731)
,p_db_column_name=>'INVOICE_RECEIVED_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Invoice Received Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12307822632313731)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12308253295313731)
,p_db_column_name=>'INVOICE_VALIDATION'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Invoice Validation'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12308672309313732)
,p_db_column_name=>'INVOICE_TYPE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Invoice Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12309030380313732)
,p_db_column_name=>'PAYMENT_METHOD'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Payment Method'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12309484037313732)
,p_db_column_name=>'SOURCE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Source'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12309839943313733)
,p_db_column_name=>'PAYMENT_STATUS'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Payment Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(10893109140999643)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12310212775313733)
,p_db_column_name=>'CURRENCY_CODE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Currency Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12310672273313733)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12311071944313734)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12311477337313734)
,p_db_column_name=>'VALIDATION_DATE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Validation Date'
,p_column_type=>'STRING'
,p_format_mask=>'DD-MON-YYYY'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12311818980313734)
,p_db_column_name=>'VALIDATED_BY'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Validated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12312277742313735)
,p_db_column_name=>'VALIDATED_USER'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Validated User'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12312628478313735)
,p_db_column_name=>'FINAL_APPROVAL_DATE'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Final Approval Date'
,p_column_type=>'STRING'
,p_format_mask=>'DD-MON-YYYY'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12313048010313735)
,p_db_column_name=>'APPROVED_BY'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Approved By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12313773440313746)
,p_db_column_name=>'EXCHANGE_RATE'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Exchange Rate'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12314182671313746)
,p_db_column_name=>'EXCHANGE_DATE'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Exchange Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12314506460313746)
,p_db_column_name=>'PAYMENT_DATE'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Payment Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12314999285313746)
,p_db_column_name=>'INVOICE_AMOUNT'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Invoice Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12315352938313747)
,p_db_column_name=>'FUNCTIONAL_AMOUNT'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Functional Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(24187407944697350)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'123157'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>20
,p_report_columns=>'INVOICE_NUMBER:CONTRACT_NUMBER:INVOICE_AMOUNT:DESCRIPTION:INVOICE_DATE:PAYMENT_METHOD:PAYMENT_STATUS:PAYMENT_DATE:'
,p_sort_column_1=>'PAYMENT_DATE'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(29920433504177133)
,p_plug_name=>'PME Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10228155320597771)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(31267781561762845)
,p_plug_name=>'Contractual Securities'
,p_icon_css_classes=>'fa-calendar-check-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>90
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID, CONTRACT_NUMBER, CONTRACTUAL_SECURITY_ID, ',
'        CONTRACT_REQUIRED, REFERENCE_NUMBER, AMOUNT, ',
'        VALID_FROM, VALID_TO, Validity, ',
'        DECODE(NVL(Validity, ''N''), ''Y'', ''fa fa-check-circle'', ''fa fa-times-circle'') icon,',
'        DECODE(NVL(Validity, ''N''), ''Y'', ''green'', ''red'') icon_color,',
'        NOTES, FILENAME, FILE_MIMETYPE, FILE_CHARSET, ',
'        FILE_BLOB, CREATED_BY_PERSON_ID, UPDATED_BY_PERSON_ID, ',
'        CREATION_DATE, UPDATED_DATE',
'from',
'(select  ID, CONTRACT_NUMBER, CONTRACTUAL_SECURITY_ID, CONTRACT_REQUIRED, ',
'        REFERENCE_NUMBER, AMOUNT, VALID_FROM, VALID_TO, ',
'        case when sysdate >= valid_from and sysdate <= valid_to Then ''Y''',
'            Else ''N''',
'        End Validity,',
'        NOTES, FILENAME, ',
'        FILE_MIMETYPE, FILE_CHARSET, FILE_BLOB, CREATED_BY_PERSON_ID, ',
'        UPDATED_BY_PERSON_ID, CREATION_DATE, UPDATED_DATE',
'from cwip_contract_contractual_securities)',
' where CONTRACT_NUMBER = :P24_CONTRACT_NUMBER',
' order by ID;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P24_CONTRACT_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Contractual Securities'
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
 p_id=>wwv_flow_api.id(31424507262227435)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:34:&SESSION.::&DEBUG.:34:P34_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>31424507262227435
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31424642671227436)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31424790025227437)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31424835470227438)
,p_db_column_name=>'CONTRACTUAL_SECURITY_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Contractual Security'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(31396667483343774)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31424956207227439)
,p_db_column_name=>'CONTRACT_REQUIRED'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Contract Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(10893109140999643)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31425039881227440)
,p_db_column_name=>'REFERENCE_NUMBER'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Reference Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31425147820227441)
,p_db_column_name=>'AMOUNT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31425269407227442)
,p_db_column_name=>'VALID_FROM'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Valid From'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31425371477227443)
,p_db_column_name=>'VALID_TO'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Valid To'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31425493001227444)
,p_db_column_name=>'NOTES'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31425591828227445)
,p_db_column_name=>'FILENAME'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Filename'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31425656800227446)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31425743213227447)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31425955127227449)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(20691219654288121)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31426062641227450)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(20691219654288121)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31452189340181401)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31452262273181402)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31452601893181406)
,p_db_column_name=>'ICON'
,p_display_order=>190
,p_column_identifier=>'T'
,p_column_label=>'Icon'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31452762991181407)
,p_db_column_name=>'ICON_COLOR'
,p_display_order=>200
,p_column_identifier=>'U'
,p_column_label=>'Icon Color'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31452847049181408)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>210
,p_column_identifier=>'V'
,p_column_label=>'File Blob'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'OTHER'
,p_rpt_show_filter_lov=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31452909478181409)
,p_db_column_name=>'VALIDITY'
,p_display_order=>220
,p_column_identifier=>'W'
,p_column_label=>'Validity'
,p_column_html_expression=>'<span class="#ICON#" style="color: #ICON_COLOR#"></span>'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(31471950571173816)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'314720'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CONTRACTUAL_SECURITY_ID:CONTRACT_REQUIRED:REFERENCE_NUMBER:AMOUNT:VALID_FROM:VALID_TO:NOTES:FILENAME:UPDATED_BY_PERSON_ID:UPDATED_DATE:ICON:ICON_COLOR:VALIDITY'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(39725357227361324)
,p_plug_name=>'Documents'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>80
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(24005544191643512)
,p_plug_name=>'Payments Recommendations Attachments'
,p_parent_plug_id=>wwv_flow_api.id(39725357227361324)
,p_icon_css_classes=>'fa-file-archive-o fam-check fam-is-success'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    id,',
'    row_version_number,',
'    payment_recommendation_id,',
'    pay_recommendation_num,',
'    contract_number,',
'    project_number,',
'    filename,',
'    file_mimetype,',
'    file_charset,',
'    file_blob,',
'    file_comments,',
'    tags,',
'    created,',
'    created_by,',
'    updated,',
'    updated_by,',
'    comment_id ,',
'    download',
'from (',
'            SELECT',
'                id,',
'                row_version_number,',
'                payment_recommendation_id,',
'                (select c.reference_number',
'                from cwip_payment_recommendation c',
'                where c.payment_recommendation_id = d.payment_recommendation_id) PAY_RECOMMENDATION_NUM,',
'                (select c.contract_number',
'                from cwip_payment_recommendation c',
'                where c.payment_recommendation_id = d.payment_recommendation_id) Contract_number,',
'                (select p.project_number',
'                    from cwip_contract_projects p',
'                    where p.contract_number = (select c.contract_number',
'                                                from cwip_payment_recommendation c',
'                                                where c.payment_recommendation_id = d.payment_recommendation_id)) Project_number,',
'                                                ',
'                filename,',
'                file_mimetype,',
'                file_charset,',
'                file_blob,',
'                file_comments,',
'                tags,',
'                created,',
'                created_by,',
'                updated,',
'                updated_by,',
'                comment_id,',
'       sys.dbms_lob.getlength(file_blob) as file_size,',
'       sys.dbms_lob.getlength(file_blob) as download',
'            FROM',
'                cwip_payment_recommendation_documents d',
')',
'where Contract_number = :P24_CONTRACT_NUMBER'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P24_CONTRACT_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Project Attachements'
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
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(24107767023388480)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No attachments available for this contract'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_show_flashback=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>24107767023388480
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12290806534309978)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>10
,p_column_identifier=>'F'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12290405439309978)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>20
,p_column_identifier=>'E'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12290054856309977)
,p_db_column_name=>'PAY_RECOMMENDATION_NUM'
,p_display_order=>30
,p_column_identifier=>'D'
,p_column_label=>'Payment Recommendation REF#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12291200284309978)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'G'
,p_column_label=>'File Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12292879965309979)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>60
,p_column_identifier=>'K'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12293214481309979)
,p_db_column_name=>'TAGS'
,p_display_order=>70
,p_column_identifier=>'L'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12288825251309976)
,p_db_column_name=>'ID'
,p_display_order=>80
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12289235462309977)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>90
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12289617373309977)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>100
,p_column_identifier=>'C'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12291692563309978)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>110
,p_column_identifier=>'H'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12292078031309979)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>120
,p_column_identifier=>'I'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12293676981309980)
,p_db_column_name=>'CREATED'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12294056238309980)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12294437087309980)
,p_db_column_name=>'UPDATED'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12294889329309980)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12295232553309981)
,p_db_column_name=>'COMMENT_ID'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Comment Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12292416078309979)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>180
,p_column_identifier=>'J'
,p_column_label=>'file blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12295681338309981)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>190
,p_column_identifier=>'R'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:CWIP_PAYMENT_RECOMMENDATION_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(24117892863394332)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'122960'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CONTRACT_NUMBER:PAY_RECOMMENDATION_NUM:FILENAME:FILE_COMMENTS:UPDATED:UPDATED_BY:DOWNLOAD:'
,p_sort_column_1=>'UPDATED'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(39725459252361325)
,p_plug_name=>'Contract Attachments'
,p_parent_plug_id=>wwv_flow_api.id(39725357227361324)
,p_icon_css_classes=>'fa-file-archive-o fam-check fam-is-success'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    id,',
'    row_version_number,',
'    payment_recommendation_id,',
'    pay_recommendation_num,',
'    contract_number,',
'    project_number,',
'    filename,',
'    file_mimetype,',
'    file_charset,',
'    file_blob,',
'    file_comments,',
'    tags,',
'    created,',
'    created_by,',
'    updated,',
'    updated_by,',
'    comment_id ,',
'    download',
'from (',
'            ',
'        select id,',
'                row_version_number,',
'                null  payment_recommendation_id,',
'                null  PAY_RECOMMENDATION_NUM,',
'                 Contract_number,',
'                 Project_number,                                ',
'                filename,',
'                file_mimetype,',
'                file_charset,',
'                file_blob,',
'                file_comments,',
'                tags,',
'                created,',
'                created_by,',
'                updated,',
'                updated_by,',
'                comment_id,',
'       sys.dbms_lob.getlength(file_blob) as file_size,',
'       sys.dbms_lob.getlength(file_blob) as download',
'    from cwip_contract_documents)',
'where Contract_number = :P24_CONTRACT_NUMBER',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P24_CONTRACT_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Project Attachements'
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
 p_id=>wwv_flow_api.id(39725680209361327)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No attachments available for this contract'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_show_flashback=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:49:&SESSION.::&DEBUG.:49:P49_ID,P49_PAGE_FROM:#ID#,24'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>39725680209361327
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39725774922361328)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39725849588361329)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39726091599361331)
,p_db_column_name=>'PAY_RECOMMENDATION_NUM'
,p_display_order=>40
,p_column_identifier=>'C'
,p_column_label=>'Payment Recommendation REF#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39726185052361332)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>50
,p_column_identifier=>'D'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39726221756361333)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39726303905361334)
,p_db_column_name=>'FILENAME'
,p_display_order=>70
,p_column_identifier=>'F'
,p_column_label=>'File Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39726429239361335)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>80
,p_column_identifier=>'G'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39726542008361336)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>90
,p_column_identifier=>'H'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39726641340361337)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>100
,p_column_identifier=>'I'
,p_column_label=>'file blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39726720761361338)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>110
,p_column_identifier=>'J'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39726834146361339)
,p_db_column_name=>'TAGS'
,p_display_order=>120
,p_column_identifier=>'K'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39726961217361340)
,p_db_column_name=>'CREATED'
,p_display_order=>130
,p_column_identifier=>'L'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39727082169361341)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>140
,p_column_identifier=>'M'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39727141451361342)
,p_db_column_name=>'UPDATED'
,p_display_order=>150
,p_column_identifier=>'N'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39727211279361343)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>160
,p_column_identifier=>'O'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39727385891361344)
,p_db_column_name=>'COMMENT_ID'
,p_display_order=>170
,p_column_identifier=>'P'
,p_column_label=>'Comment Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39727480882361345)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>180
,p_column_identifier=>'Q'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:CWIP_CONTRACT_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39727501626361346)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>190
,p_column_identifier=>'R'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(40061015508719016)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'400611'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:UPDATED:UPDATED_BY:DOWNLOAD:'
,p_sort_column_1=>'UPDATED_BY'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12228346191870872)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(12203945824870851)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10307273349597826)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_button_condition=>'P24_CONTRACT_NUMBER'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12227531966870871)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(12203945824870851)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10307273349597826)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition_type=>'NEVER'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12226703678870870)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(12203339883870627)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10307273349597826)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:&P24_PAGE_FROM.:&SESSION.::&DEBUG.::P21_PROJECT_NUMBER:&P24_PROJECT_NUMBER.'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12296470171309982)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(39725459252361325)
,p_button_name=>'Add_ATTACHEMENT'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10306520873597824)
,p_button_image_alt=>'Add Attachement'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:49:&SESSION.::&DEBUG.:49:P49_CONTRACT_NUMBER,P49_PAGE_FROM,P49_PROJECT_NUMBER:&P24_CONTRACT_NUMBER.,24,&P24_PROJECT_NUMBER.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12227988470870872)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(12203339883870627)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10307273349597826)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P24_CONTRACT_NUMBER'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(31452339593181403)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(31267781561762845)
,p_button_name=>'Add'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add'
,p_button_position=>'TOP_AND_BOTTOM'
,p_button_redirect_url=>'f?p=&APP_ID.:34:&SESSION.::&DEBUG.:34:P34_CONTRACT_NUMBER:&P24_CONTRACT_NUMBER.'
,p_icon_css_classes=>'fa-calendar-ban'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(12228642221870872)
,p_branch_name=>'Go To Page &P24_PAGE_FROM.'
,p_branch_action=>'f?p=&APP_ID.:&P24_PAGE_FROM.:&SESSION.::&DEBUG.::P21_PROJECT_NUMBER:&P24_PROJECT_NUMBER.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11871586624373947)
,p_name=>'P24_PROJECT_NUMBER'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12204226320870851)
,p_name=>'P24_CONTRACT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(12203945824870851)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Contract Number'
,p_source=>'CONTRACT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12204615933870854)
,p_name=>'P24_CONTRACT_DESCRIPTION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(12203945824870851)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Contract Description'
,p_source=>'CONTRACT_DESCRIPTION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12205007304870855)
,p_name=>'P24_CONTRACT_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(11870956278373941)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Revised Contract Amount'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'CONTRACT_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12205413243870855)
,p_name=>'P24_BILLED_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(11870956278373941)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Billed Amount'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'BILLED_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12205828046870855)
,p_name=>'P24_INITIAL_CONTRACT_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(11870956278373941)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Initial Contract Amount'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'INITIAL_CONTRACT_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12206295036870856)
,p_name=>'P24_CONTRACT_VARIATION_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(11870956278373941)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Contract Variation Amount'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'CONTRACT_VARIATION_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12206691855870856)
,p_name=>'P24_VENDOR_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(12203945824870851)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Vendor Name'
,p_source=>'VENDOR_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12207048767870856)
,p_name=>'P24_VENDOR_SITE_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Vendor Site Code'
,p_source=>'VENDOR_SITE_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12207474255870856)
,p_name=>'P24_CONTRACT_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Contract Type'
,p_source=>'CONTRACT_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12207817248870857)
,p_name=>'P24_CONTRACT_MODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Contract Mode'
,p_source=>'CONTRACT_MODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12208214103870857)
,p_name=>'P24_ATTRIBUTE_CATEGORY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Attribute Category'
,p_source=>'ATTRIBUTE_CATEGORY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12208621591870857)
,p_name=>'P24_BUYER_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Buyer Name'
,p_source=>'BUYER_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12209005126870857)
,p_name=>'P24_APPROVED_FLAG'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Approved ?'
,p_source=>'APPROVED_FLAG'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(10893109140999643)||'.'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12209413639870858)
,p_name=>'P24_APPROVED_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Approved Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'APPROVED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12209865570870858)
,p_name=>'P24_BILLING_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Billing Status'
,p_source=>'BILLING_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12210296253870858)
,p_name=>'P24_START_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Start Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'START_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12210626191870858)
,p_name=>'P24_END_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'End Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'END_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12211072095870859)
,p_name=>'P24_CONTRACT_DAYS'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Contract Days'
,p_format_mask=>'999G999G999G999G999G999G990'
,p_source=>'CONTRACT_DAYS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12211440345870859)
,p_name=>'P24_CURRENCY_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Currency Code'
,p_source=>'CURRENCY_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12211810783870859)
,p_name=>'P24_CANCEL_FLAG'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Cancel Flag'
,p_source=>'CANCEL_FLAG'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(10893109140999643)||'.'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12212284459870860)
,p_name=>'P24_CLOSED_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Closed Code'
,p_source=>'CLOSED_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12212635830870860)
,p_name=>'P24_CONTRACT_ADMIN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Contract Admin'
,p_source=>'CONTRACT_ADMIN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12213458566870860)
,p_name=>'P24_LAST_UPDATE_DATE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Last Update Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'LAST_UPDATE_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12213831292870861)
,p_name=>'P24_CREATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(12203945824870851)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12214284148870861)
,p_name=>'P24_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(12203945824870851)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12215094808870862)
,p_name=>'P24_UPDATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(12203945824870851)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12215498812870862)
,p_name=>'P24_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(12203945824870851)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12216286117870863)
,p_name=>'P24_VENDOR_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Vendor Number'
,p_source=>'VENDOR_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12216685786870863)
,p_name=>'P24_COMPLETION_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(11871042496373942)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Completion Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'COMPLETION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12217042014870863)
,p_name=>'P24_REVISED_COMPLETION_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(11871042496373942)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Revised Completion Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'REVISED_COMPLETION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12458681331889038)
,p_name=>'P24_CONTRACT_TITLE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(11871042496373942)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Contract Title'
,p_source=>'CONTRACT_TITLE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>1000
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29487067141468132)
,p_name=>'P24_DCT_CONTRACT_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(11871042496373942)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'DCT Contract Code'
,p_source=>'DCT_CONTRACT_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>15
,p_cMaxlength=>50
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29920917927177138)
,p_name=>'P24_DCT_COST_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(29920433504177133)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Cost Type:'
,p_source=>'DCT_COST_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'COST TYPES LOV'
,p_lov=>'.'||wwv_flow_api.id(30444530399539118)||'.'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(31890271424194104)
,p_name=>'P24_PAGE_FROM'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(12203339883870627)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(40072228628098344)
,p_name=>'P24_CONTRACT_REFERENCE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(11871042496373942)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Contract Reference'
,p_source=>'CONTRACT_REFERENCE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(12214796033870862)
,p_validation_name=>'P24_CREATED_ON must be timestamp'
,p_validation_sequence=>250
,p_validation=>'P24_CREATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(12214284148870861)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(12215976861870863)
,p_validation_name=>'P24_UPDATED_ON must be timestamp'
,p_validation_sequence=>270
,p_validation=>'P24_UPDATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(12215498812870862)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(12229501271870873)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(12203945824870851)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Contract Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Contract &P24_CONTRACT_NUMBER. Updated Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(12229140725870873)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(12203945824870851)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Contract Details'
);
wwv_flow_api.component_end;
end;
/
