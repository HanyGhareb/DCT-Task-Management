prompt --application/pages/page_00021
begin
--   Manifest
--     PAGE: 00021
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
 p_id=>21
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'Project Details'
,p_alias=>'PROJECT-DETAILS'
,p_step_title=>'Project Details'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231212182214'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11652030019014520)
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
 p_id=>wwv_flow_api.id(11652638582014566)
,p_plug_name=>'Project# &P21_PROJECT_NUMBER. Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'PROJECT'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11519729245797833)
,p_plug_name=>'DCT Details'
,p_parent_plug_id=>wwv_flow_api.id(11652638582014566)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10228155320597771)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11519807983797834)
,p_plug_name=>'ADERP Details'
,p_parent_plug_id=>wwv_flow_api.id(11652638582014566)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10228155320597771)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11821105469078525)
,p_plug_name=>'<span aria-hidden="true" class="fa fa-number-2-o "></span> Project Contracts'
,p_icon_css_classes=>'fa-file-word-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--noBorder:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    contract_number,',
'    contract_description,',
'    contract_amount,',
'    billed_amount,',
'    initial_contract_amount,',
'    contract_variation_amount,',
'    vendor_name,',
'    vendor_site_code,',
'    contract_type,',
'    contract_mode,',
'    attribute_category,',
'    buyer_name,',
'    approved_flag,',
'    approved_date,',
'    billing_status,',
'    start_date,',
'    end_date,',
'    contract_days,',
'    currency_code,',
'    cancel_flag,',
'    closed_code,',
'    contract_admin,',
'    creation_date,',
'    last_update_date,',
'    created_by,',
'    created_on,',
'    updated_by,',
'    updated_on,',
'    vendor_number,',
'    contract_title',
'from cwip_contract c',
'where c.contract_number in ',
'(SELECT',
'    contract_number',
'--    ,project_number,',
'--    task_number,',
'--    expenditure_type,',
'--    contract_amount,',
'--    billed_amount',
'FROM',
'    cwip_contract_projects',
'where project_number = :P21_PROJECT_NUMBER)',
'order by CONTRACT_NUMBER'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P21_PROJECT_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_document_header=>'SERVER'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A4'
,p_prn_width=>297
,p_prn_height=>210
,p_prn_orientation=>'HORIZONTAL'
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
 p_id=>wwv_flow_api.id(11821230108078526)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>11821230108078526
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11821316150078527)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Contract Number'
,p_column_link=>'f?p=&APP_ID.:24:&SESSION.::&DEBUG.::P24_CONTRACT_NUMBER,P24_PROJECT_NUMBER,P24_PAGE_FROM:#CONTRACT_NUMBER#,&P21_PROJECT_NUMBER.,21'
,p_column_linktext=>'#CONTRACT_NUMBER#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11821483663078528)
,p_db_column_name=>'CONTRACT_DESCRIPTION'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Contract Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11821536794078529)
,p_db_column_name=>'CONTRACT_AMOUNT'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'PO Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11821623891078530)
,p_db_column_name=>'BILLED_AMOUNT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Billed Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11821743966078531)
,p_db_column_name=>'INITIAL_CONTRACT_AMOUNT'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Initial Contract Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11821888649078532)
,p_db_column_name=>'CONTRACT_VARIATION_AMOUNT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Contract Variation Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11821998746078533)
,p_db_column_name=>'VENDOR_NAME'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Vendor Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11822098777078534)
,p_db_column_name=>'VENDOR_SITE_CODE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Vendor Site Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11822103003078535)
,p_db_column_name=>'CONTRACT_TYPE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Contract Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11822249476078536)
,p_db_column_name=>'CONTRACT_MODE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Contract Mode'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11822343882078537)
,p_db_column_name=>'ATTRIBUTE_CATEGORY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Attribute Category'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11822406079078538)
,p_db_column_name=>'BUYER_NAME'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Buyer Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11822521142078539)
,p_db_column_name=>'APPROVED_FLAG'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Approved Flag'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(10893109140999643)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11822664789078540)
,p_db_column_name=>'APPROVED_DATE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Approved Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11822724225078541)
,p_db_column_name=>'BILLING_STATUS'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Billing Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11822835167078542)
,p_db_column_name=>'START_DATE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11822982946078543)
,p_db_column_name=>'END_DATE'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11823090833078544)
,p_db_column_name=>'CONTRACT_DAYS'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Contract Days'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11823134012078545)
,p_db_column_name=>'CURRENCY_CODE'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Currency Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11823288111078546)
,p_db_column_name=>'CANCEL_FLAG'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Cancel Flag'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11823370371078547)
,p_db_column_name=>'CLOSED_CODE'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Closed Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11823446863078548)
,p_db_column_name=>'CONTRACT_ADMIN'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Contract Admin'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11823552151078549)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Creation Date'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11823640670078550)
,p_db_column_name=>'LAST_UPDATE_DATE'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Last Update Date'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11839298534243701)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11839360975243702)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11839447456243703)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11839559269243704)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11839615959243705)
,p_db_column_name=>'VENDOR_NUMBER'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Vendor Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12458502519889037)
,p_db_column_name=>'CONTRACT_TITLE'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Contract Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(11853648701253519)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'118537'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CONTRACT_NUMBER:VENDOR_NAME:CONTRACT_TITLE:CONTRACT_AMOUNT:BILLED_AMOUNT:INITIAL_CONTRACT_AMOUNT:CONTRACT_VARIATION_AMOUNT:BUYER_NAME'
,p_sort_column_1=>'CONTRACT_NUMBER'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(76541275957731066)
,p_application_user=>'TCA9051'
,p_name=>'Test'
,p_report_seq=>10
,p_report_columns=>'CONTRACT_NUMBER:VENDOR_NAME:CONTRACT_TITLE:CONTRACT_AMOUNT:BILLED_AMOUNT:INITIAL_CONTRACT_AMOUNT:CONTRACT_VARIATION_AMOUNT:BUYER_NAME:APPROVED_DATE:BILLING_STATUS:'
,p_sort_column_1=>'CONTRACT_NUMBER'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(93770311371498429)
,p_application_user=>'TCA1206'
,p_name=>'Temp1'
,p_report_seq=>10
,p_report_columns=>'CONTRACT_NUMBER:VENDOR_NAME:CONTRACT_TITLE:CONTRACT_AMOUNT:BILLED_AMOUNT:INITIAL_CONTRACT_AMOUNT:CONTRACT_VARIATION_AMOUNT:BUYER_NAME'
,p_sort_column_1=>'CONTRACT_NUMBER'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11841830312243727)
,p_plug_name=>'<span aria-hidden="true" class="fa fa-number-4-o "></span> Project Invoices'
,p_icon_css_classes=>'fa-money'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>70
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
'where inv.contract_number in (select c.contract_number',
'                                from cwip_contract_projects c',
'                                where c.project_number = :P21_PROJECT_NUMBER )',
'and inv.invoice_amount <> 0 ',
'order by inv.creation_date desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P21_PROJECT_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_document_header=>'SERVER'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A3'
,p_prn_width=>420
,p_prn_height=>297
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'<span aria-hidden="true" class="fa fa-number-4-o "></span> Project Invoices'
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
 p_id=>wwv_flow_api.id(11841942792243728)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>11841942792243728
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11842026595243729)
,p_db_column_name=>'INVOICE_NUMBER'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Invoice Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11842183807243730)
,p_db_column_name=>'VOUCHER_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Voucher Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11842217089243731)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11842305819243732)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11842462575243733)
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
 p_id=>wwv_flow_api.id(11842585817243734)
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
 p_id=>wwv_flow_api.id(11842666820243735)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11842793573243736)
,p_db_column_name=>'INVOICE_VALIDATION'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Invoice Validation'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11842833390243737)
,p_db_column_name=>'INVOICE_TYPE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Invoice Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11842988513243738)
,p_db_column_name=>'PAYMENT_METHOD'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Payment Method'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11843080559243739)
,p_db_column_name=>'SOURCE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Source'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11843182567243740)
,p_db_column_name=>'PAYMENT_STATUS'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Paid?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(10893109140999643)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11843270233243741)
,p_db_column_name=>'CURRENCY_CODE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11843360815243742)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11843451275243743)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11843546526243744)
,p_db_column_name=>'VALIDATION_DATE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Validation Date'
,p_column_type=>'STRING'
,p_format_mask=>'DD-MON-YYYY'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11843683107243745)
,p_db_column_name=>'VALIDATED_BY'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Validated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11843744534243746)
,p_db_column_name=>'VALIDATED_USER'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Validated User'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11843825719243747)
,p_db_column_name=>'FINAL_APPROVAL_DATE'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Final Approval Date'
,p_column_type=>'STRING'
,p_format_mask=>'DD-MON-YYYY'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11843903583243748)
,p_db_column_name=>'APPROVED_BY'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Approved By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11844019967243749)
,p_db_column_name=>'EXCHANGE_RATE'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Exchange Rate'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11844164795243750)
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
 p_id=>wwv_flow_api.id(11866965461373901)
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
 p_id=>wwv_flow_api.id(11867070251373902)
,p_db_column_name=>'INVOICE_AMOUNT'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Invoice Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11867158068373903)
,p_db_column_name=>'FUNCTIONAL_AMOUNT'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Functional Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(11882257168383622)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'118823'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>20
,p_report_columns=>'INVOICE_NUMBER:CONTRACT_NUMBER:INVOICE_AMOUNT:CURRENCY_CODE:DESCRIPTION:INVOICE_DATE:PAYMENT_METHOD:PAYMENT_STATUS:PAYMENT_DATE:'
,p_sort_column_1=>'INVOICE_DATE'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11871608497373948)
,p_plug_name=>'<span aria-hidden="true" class="fa fa-number-1-o "></span> Project Members'
,p_icon_css_classes=>'fa-emoji-unamused'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10228155320597771)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(11520040783797836)
,p_name=>'Internal Project Team'
,p_parent_plug_id=>wwv_flow_api.id(11871608497373948)
,p_template=>wwv_flow_api.id(10245193460597780)
,p_display_sequence=>20
,p_icon_css_classes=>'fa-chevron-circle-right'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight:t-Report--noBorders'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    t.id,',
'    t.project_number,',
'    t.task_number,',
'    t.contract_number,',
'    t.person_id,',
'    -- Persondetails',
'    e.full_name_en,',
'    CASE',
'        WHEN dbms_lob.getlength(e.photo_blob) > 0 THEN',
'          ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || e.user_name',
'        ELSE',
'           ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'    END PHOTO,',
'    -- role_destails',
'    t.role_id,',
'    r.role_name,',
'    r.description,',
'    r.category_id,',
'    t.person_type,',
'    t.start_date,',
'    t.end_date,',
'    t.status,',
'    t.notes,',
'    t.created_by,',
'    t.created_on,',
'    t.updated_by,',
'    t.updated_on',
'FROM',
'    cwip_team t , project_role r , dct_employees_list2 e',
'where t.project_number = :P21_PROJECT_NUMBER',
'and t.role_id = r.role_id',
'and t.person_id = e.person_id',
'and r.category_id = 2'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P21_PROJECT_NUMBER'
,p_query_row_template=>wwv_flow_api.id(10271480393597797)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No Team assined.'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11520173306797837)
,p_query_column_id=>1
,p_column_alias=>'ID'
,p_column_display_sequence=>1
,p_column_heading=>'<span class="u-VisuallyHidden">Edit Member</span>'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:22:&SESSION.::&DEBUG.::P22_ID,P22_PAGE_FROM:#ID#,21'
,p_column_linktext=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="Edit Project Member">'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11520232806797838)
,p_query_column_id=>2
,p_column_alias=>'PROJECT_NUMBER'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11520337817797839)
,p_query_column_id=>3
,p_column_alias=>'TASK_NUMBER'
,p_column_display_sequence=>13
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11520429630797840)
,p_query_column_id=>4
,p_column_alias=>'CONTRACT_NUMBER'
,p_column_display_sequence=>6
,p_column_heading=>'Contract Number'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11520546876797841)
,p_query_column_id=>5
,p_column_alias=>'PERSON_ID'
,p_column_display_sequence=>14
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11520619536797842)
,p_query_column_id=>6
,p_column_alias=>'FULL_NAME_EN'
,p_column_display_sequence=>3
,p_column_heading=>'Name'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11520774204797843)
,p_query_column_id=>7
,p_column_alias=>'PHOTO'
,p_column_display_sequence=>2
,p_column_heading=>'Photo'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="50" width="50"   style="border-radius:50%">'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11520879648797844)
,p_query_column_id=>8
,p_column_alias=>'ROLE_ID'
,p_column_display_sequence=>15
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11520978565797845)
,p_query_column_id=>9
,p_column_alias=>'ROLE_NAME'
,p_column_display_sequence=>8
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11521056786797846)
,p_query_column_id=>10
,p_column_alias=>'DESCRIPTION'
,p_column_display_sequence=>5
,p_column_heading=>'Description'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11521179448797847)
,p_query_column_id=>11
,p_column_alias=>'CATEGORY_ID'
,p_column_display_sequence=>16
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11521252184797848)
,p_query_column_id=>12
,p_column_alias=>'PERSON_TYPE'
,p_column_display_sequence=>17
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11521375534797849)
,p_query_column_id=>13
,p_column_alias=>'START_DATE'
,p_column_display_sequence=>11
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11521494746797850)
,p_query_column_id=>14
,p_column_alias=>'END_DATE'
,p_column_display_sequence=>12
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11713324847333501)
,p_query_column_id=>15
,p_column_alias=>'STATUS'
,p_column_display_sequence=>7
,p_column_heading=>'Status'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_display_as=>'TEXT_FROM_LOV_ESC'
,p_named_lov=>wwv_flow_api.id(10760317215192499)
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11713458524333502)
,p_query_column_id=>16
,p_column_alias=>'NOTES'
,p_column_display_sequence=>9
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11713557524333503)
,p_query_column_id=>17
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>18
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11713633379333504)
,p_query_column_id=>18
,p_column_alias=>'CREATED_ON'
,p_column_display_sequence=>19
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11713786007333505)
,p_query_column_id=>19
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>20
,p_hidden_column=>'Y'
,p_derived_column=>'N'
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
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11713893826333506)
,p_query_column_id=>20
,p_column_alias=>'UPDATED_ON'
,p_column_display_sequence=>21
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(11713985064333507)
,p_name=>'External Project Team'
,p_parent_plug_id=>wwv_flow_api.id(11871608497373948)
,p_template=>wwv_flow_api.id(10245193460597780)
,p_display_sequence=>40
,p_icon_css_classes=>'fa-chevron-circle-left'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight:t-Report--noBorders'
,p_new_grid_row=>false
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    t.id,',
'    t.project_number,',
'    t.task_number,',
'    t.contract_number,',
'    t.person_id,',
'    -- Persondetails',
'    e.full_name_en,',
'    CASE',
'        WHEN dbms_lob.getlength(e.photo_blob) > 0 THEN',
'          ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || e.user_name',
'        ELSE',
'           ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'    END PHOTO,',
'    -- role_destails',
'    t.role_id,',
'    r.role_name,',
'    r.description,',
'    r.category_id,',
'    t.person_type,',
'    t.start_date,',
'    t.end_date,',
'    t.status,',
'    t.notes,',
'    t.created_by,',
'    t.created_on,',
'    t.updated_by,',
'    t.updated_on',
'FROM',
'    cwip_team t , project_role r , dct_ext_users e',
'where t.project_number = :P21_PROJECT_NUMBER',
'and t.role_id = r.role_id',
'and t.person_id = e.user_id',
'and r.category_id = 1'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P21_PROJECT_NUMBER'
,p_query_row_template=>wwv_flow_api.id(10271480393597797)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No Team assined.'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11714028931333508)
,p_query_column_id=>1
,p_column_alias=>'ID'
,p_column_display_sequence=>1
,p_column_heading=>'<span class="u-VisuallyHidden">Edit Member</span>'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.::P23_ID,P23_PAGE_FROM:#ID#,21'
,p_column_linktext=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="Edit Project Member">'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11714111991333509)
,p_query_column_id=>2
,p_column_alias=>'PROJECT_NUMBER'
,p_column_display_sequence=>7
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11714286850333510)
,p_query_column_id=>3
,p_column_alias=>'TASK_NUMBER'
,p_column_display_sequence=>8
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11714317445333511)
,p_query_column_id=>4
,p_column_alias=>'CONTRACT_NUMBER'
,p_column_display_sequence=>5
,p_column_heading=>'Contract Number'
,p_use_as_row_header=>'N'
,p_column_alignment=>'CENTER'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11714478302333512)
,p_query_column_id=>5
,p_column_alias=>'PERSON_ID'
,p_column_display_sequence=>9
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11714564321333513)
,p_query_column_id=>6
,p_column_alias=>'FULL_NAME_EN'
,p_column_display_sequence=>3
,p_column_heading=>'Name'
,p_use_as_row_header=>'N'
,p_column_alignment=>'CENTER'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11714634123333514)
,p_query_column_id=>7
,p_column_alias=>'PHOTO'
,p_column_display_sequence=>2
,p_column_heading=>'Photo'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="50" width="50"   style="border-radius:50%">'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11714780700333515)
,p_query_column_id=>8
,p_column_alias=>'ROLE_ID'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11714807076333516)
,p_query_column_id=>9
,p_column_alias=>'ROLE_NAME'
,p_column_display_sequence=>11
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11714919199333517)
,p_query_column_id=>10
,p_column_alias=>'DESCRIPTION'
,p_column_display_sequence=>4
,p_column_heading=>'Role'
,p_use_as_row_header=>'N'
,p_column_alignment=>'CENTER'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11715058263333518)
,p_query_column_id=>11
,p_column_alias=>'CATEGORY_ID'
,p_column_display_sequence=>12
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11715108826333519)
,p_query_column_id=>12
,p_column_alias=>'PERSON_TYPE'
,p_column_display_sequence=>13
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11715293839333520)
,p_query_column_id=>13
,p_column_alias=>'START_DATE'
,p_column_display_sequence=>15
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11715304778333521)
,p_query_column_id=>14
,p_column_alias=>'END_DATE'
,p_column_display_sequence=>16
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11715455077333522)
,p_query_column_id=>15
,p_column_alias=>'STATUS'
,p_column_display_sequence=>6
,p_column_heading=>'Status'
,p_use_as_row_header=>'N'
,p_column_alignment=>'CENTER'
,p_disable_sort_column=>'N'
,p_display_as=>'TEXT_FROM_LOV_ESC'
,p_named_lov=>wwv_flow_api.id(10760317215192499)
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11715576461333523)
,p_query_column_id=>16
,p_column_alias=>'NOTES'
,p_column_display_sequence=>14
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11715604064333524)
,p_query_column_id=>17
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>17
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11715741301333525)
,p_query_column_id=>18
,p_column_alias=>'CREATED_ON'
,p_column_display_sequence=>18
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11715806239333526)
,p_query_column_id=>19
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>19
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11715922399333527)
,p_query_column_id=>20
,p_column_alias=>'UPDATED_ON'
,p_column_display_sequence=>20
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11871757825373949)
,p_plug_name=>'Selector'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--removeHeader:t-Region--noUI:t-Region--scrollBody'
,p_region_attributes=>'background-color: #0076df'
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
 p_id=>wwv_flow_api.id(22502941855061606)
,p_plug_name=>'<span aria-hidden="true" class="fa fa-number-3-o "></span> Payments Recommendations'
,p_icon_css_classes=>'fa-money'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    payment_recommendation_id,',
'    reference_number,',
'    payment_recommendation_date,',
'    contract_number,',
'    contract_title,',
'    contract_reference,',
'    contract_description,',
'    initial_contract_amount,',
'    contract_amount,',
'    contract_variation_amount,',
'    billed_amount,',
'    vendor_number,',
'    vendor_name,',
'    vendor_site_code,',
'    revised_completion_date,',
'    project_number,',
'    project_name,',
'    payment_number,',
'    payment_type,',
'    valuation_period,',
'    evaluation_method,',
'--    current_valuation_amount,',
'    period,',
'--    deductions,',
'--    previous_payments,',
'--    net_amount_payable,',
'--    attachements,',
'    created_by,',
'    created_on,',
'    updated_by,',
'    updated_on,',
'    approval_status,',
'    seq_count,',
'    final_approve_on,',
'    invoice_num,',
'    invoice_date,',
'    total_invoice_amount,',
'    currency,',
'    contract_stage',
'    ',
'        ,(',
'    select nvl(sum(a.net_amount_payable),0)',
'    from cwip_payment_recommendation a',
'    where a.contract_number = p.contract_number',
'    and a.approval_status = ''Approved''',
'    and a.seq_count < p.seq_count',
'    ) Previousely_Cerified_Approved ',
'    ,',
'    (select nvl(sum(a.net_amount_payable),0)',
'    from cwip_payment_recommendation a',
'    where a.contract_number = p.contract_number',
'     and a.approval_status = ''In-Progress''',
'    and a.seq_count < p.seq_count ',
'    )  Previousely_Cerified_Pending',
'',
'    ',
'    , current_valuation_amount',
'    , nvl(deductions,0)    deductions',
'    , net_amount_payable',
'    ,',
'    (',
'    (select nvl(sum(a.net_amount_payable),0)',
'    from cwip_payment_recommendation a',
'    where a.contract_number = p.contract_number',
'      and a.approval_status in (''In-Progress'',''Approved'')',
'    and a.seq_count < p.seq_count ',
'    ) + p.net_amount_payable',
'    ) Cumulative_Cerified_Amount',
'from cwip_payment_recommendation_v p',
'where p.contract_number in (select c.contract_number ',
'                            from cwip_contract_projects c',
'                            where c.project_number = :P21_PROJECT_NUMBER)',
'order by contract_number , seq_count'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P21_PROJECT_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'<span aria-hidden="true" class="fa fa-number-3-o "></span> Payments Recommendations'
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
 p_id=>wwv_flow_api.id(22503016510061607)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>22503016510061607
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22503185674061608)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22503229306061609)
,p_db_column_name=>'REFERENCE_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Reference Number'
,p_column_link=>'f?p=&APP_ID.:29:&SESSION.::&DEBUG.::P29_PAYMENT_RECOMMENDATION_ID,P29_PROJECT_NUMBER,P29_PAGE_FROM:#PAYMENT_RECOMMENDATION_ID#,&P21_PROJECT_NUMBER.,21'
,p_column_linktext=>'#REFERENCE_NUMBER#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22503312936061610)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_DATE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Payment Recommendation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22503423737061611)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22503586031061612)
,p_db_column_name=>'PAYMENT_NUMBER'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Payment Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22503619384061613)
,p_db_column_name=>'PAYMENT_TYPE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Payment Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22503732861061614)
,p_db_column_name=>'VALUATION_PERIOD'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Valuation Period'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22503895534061615)
,p_db_column_name=>'EVALUATION_METHOD'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Evaluation Method'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22503986545061616)
,p_db_column_name=>'CURRENT_VALUATION_AMOUNT'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Current Valuation Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22504063542061617)
,p_db_column_name=>'PERIOD'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Period'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22504143143061618)
,p_db_column_name=>'DEDUCTIONS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Deductions'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22504349934061620)
,p_db_column_name=>'NET_AMOUNT_PAYABLE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Net Amount Payable'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22504557551061622)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22504648059061623)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22504749460061624)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22504861626061625)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22504992703061626)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22505003587061627)
,p_db_column_name=>'CONTRACT_TITLE'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Contract Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22505178136061628)
,p_db_column_name=>'CONTRACT_REFERENCE'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Contract Reference'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22505202217061629)
,p_db_column_name=>'CONTRACT_DESCRIPTION'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Contract Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22505315287061630)
,p_db_column_name=>'INITIAL_CONTRACT_AMOUNT'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Initial Contract Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22505430026061631)
,p_db_column_name=>'CONTRACT_AMOUNT'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Contract Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22505590374061632)
,p_db_column_name=>'CONTRACT_VARIATION_AMOUNT'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Contract Variation Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22505629997061633)
,p_db_column_name=>'BILLED_AMOUNT'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Billed Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22505715481061634)
,p_db_column_name=>'VENDOR_NUMBER'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Vendor Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22505865090061635)
,p_db_column_name=>'VENDOR_NAME'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Vendor Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22505976930061636)
,p_db_column_name=>'VENDOR_SITE_CODE'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Vendor Site Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22506029651061637)
,p_db_column_name=>'REVISED_COMPLETION_DATE'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Revised Completion Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22506167773061638)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22506213483061639)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22506315279061640)
,p_db_column_name=>'SEQ_COUNT'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Seq Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22506474103061641)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22506571932061642)
,p_db_column_name=>'INVOICE_NUM'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Invoice Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22506625480061643)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22506775003061644)
,p_db_column_name=>'TOTAL_INVOICE_AMOUNT'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Total Invoice Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22506819428061645)
,p_db_column_name=>'CURRENCY'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22506937474061646)
,p_db_column_name=>'CONTRACT_STAGE'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Contract Stage'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(574788103608737)
,p_db_column_name=>'PREVIOUSELY_CERIFIED_APPROVED'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Previousely Cerified Approved'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(574884769608738)
,p_db_column_name=>'PREVIOUSELY_CERIFIED_PENDING'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Previousely Cerified Pending'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(574985637608739)
,p_db_column_name=>'CUMULATIVE_CERIFIED_AMOUNT'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'Cumulative Cerified Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(22540078165090509)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'225401'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CONTRACT_NUMBER:REFERENCE_NUMBER:PAYMENT_NUMBER:PAYMENT_RECOMMENDATION_DATE:PAYMENT_TYPE:CURRENT_VALUATION_AMOUNT:NET_AMOUNT_PAYABLE:APPROVAL_STATUS:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(174639256061296189)
,p_report_id=>wwv_flow_api.id(22540078165090509)
,p_name=>'Approved'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#27CF65'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(174639589090296190)
,p_report_id=>wwv_flow_api.id(22540078165090509)
,p_name=>'Rejected'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F44336'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(5824039912823258)
,p_application_user=>'TCA1399'
,p_name=>'in-Progress'
,p_report_seq=>10
,p_report_columns=>'CONTRACT_NUMBER:REFERENCE_NUMBER:PAYMENT_NUMBER:PAYMENT_RECOMMENDATION_DATE:PAYMENT_TYPE:CURRENT_VALUATION_AMOUNT:NET_AMOUNT_PAYABLE:APPROVAL_STATUS:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(5824163598823258)
,p_report_id=>wwv_flow_api.id(5824039912823258)
,p_name=>'Approved'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#27CF65'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(5824325241823258)
,p_report_id=>wwv_flow_api.id(5824039912823258)
,p_name=>'Rejected'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F44336'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(5824100906823258)
,p_report_id=>wwv_flow_api.id(5824039912823258)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>'"APPROVAL_STATUS" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(93773285832468052)
,p_application_user=>'TCA1206'
,p_name=>'Payment'
,p_report_seq=>10
,p_report_columns=>'CONTRACT_NUMBER:REFERENCE_NUMBER:PAYMENT_NUMBER:PAYMENT_RECOMMENDATION_DATE:PAYMENT_TYPE:CURRENT_VALUATION_AMOUNT:NET_AMOUNT_PAYABLE:APPROVAL_STATUS:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(93773394682468052)
,p_report_id=>wwv_flow_api.id(93773285832468052)
,p_name=>'Approved'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#27CF65'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(93773498776468052)
,p_report_id=>wwv_flow_api.id(93773285832468052)
,p_name=>'Rejected'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F44336'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(39727647887361347)
,p_plug_name=>'<span aria-hidden="true" class="fa fa-number-5-o "></span> Project Attachments'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>90
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11716949363333537)
,p_plug_name=>'Project Documents'
,p_parent_plug_id=>wwv_flow_api.id(39727647887361347)
,p_icon_css_classes=>'fa-file-archive-o  fam-check fam-is-success'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
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
'                ''''  payment_recommendation_id,',
'                ''''  PAY_RECOMMENDATION_NUM,',
'                ''''  Contract_number,',
'                project_number ,                 ',
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
'    sys.dbms_lob.getlength(file_blob) as download',
'            FROM',
'                project_documents d)',
'where project_number = :P21_PROJECT_NUMBER'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P21_PROJECT_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Project Documents'
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
 p_id=>wwv_flow_api.id(11819172195078505)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No attachments available for this project'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_show_flashback=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:50:&SESSION.::&DEBUG.::P50_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>11819172195078505
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11819727018078511)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>10
,p_column_identifier=>'F'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11819649321078510)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>20
,p_column_identifier=>'E'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
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
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11819505828078509)
,p_db_column_name=>'PAY_RECOMMENDATION_NUM'
,p_display_order=>30
,p_column_identifier=>'D'
,p_column_label=>'Payment Recommendation REF#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11819896329078512)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'G'
,p_column_label=>'File Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11820225576078516)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>60
,p_column_identifier=>'K'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11820351510078517)
,p_db_column_name=>'TAGS'
,p_display_order=>70
,p_column_identifier=>'L'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11819231988078506)
,p_db_column_name=>'ID'
,p_display_order=>80
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11819330316078507)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>90
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11819921188078513)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>110
,p_column_identifier=>'H'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11820012138078514)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>120
,p_column_identifier=>'I'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11820424106078518)
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
 p_id=>wwv_flow_api.id(11820559309078519)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11820648270078520)
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
 p_id=>wwv_flow_api.id(11820775993078521)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11820827844078522)
,p_db_column_name=>'COMMENT_ID'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Comment Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11820193366078515)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>180
,p_column_identifier=>'J'
,p_column_label=>'file blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11820994572078523)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>190
,p_column_identifier=>'R'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:PROJECT_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40071864267098340)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>200
,p_column_identifier=>'S'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(11829298035084357)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'118293'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:TAGS:UPDATED:UPDATED_BY:DOWNLOAD:'
,p_sort_column_1=>'UPDATED'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(39727705741361348)
,p_plug_name=>'Contracts Documents'
,p_parent_plug_id=>wwv_flow_api.id(39727647887361347)
,p_icon_css_classes=>'fa-file-archive-o  fam-check fam-is-success'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>30
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
'                ''''      payment_recommendation_id,',
'                ''''      PAY_RECOMMENDATION_NUM,',
'                 Contract_number,',
'                 Project_number,',
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
'    sys.dbms_lob.getlength(file_blob) as download',
'            FROM',
'                cwip_contract_documents d)',
'where project_number = :P21_PROJECT_NUMBER',
'order by contract_number'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P21_PROJECT_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Contracts Documents'
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
 p_id=>wwv_flow_api.id(39727909383361350)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No attachments available for any contracts for this project'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_show_flashback=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>39727909383361350
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40067955140098301)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40068020151098302)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40068238369098304)
,p_db_column_name=>'PAY_RECOMMENDATION_NUM'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Payment Recommendation REF#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40068356256098305)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40068430691098306)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40068520175098307)
,p_db_column_name=>'FILENAME'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40068693642098308)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40068762605098309)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40068862419098310)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'file blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40068931198098311)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40069064582098312)
,p_db_column_name=>'TAGS'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40069190075098313)
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
 p_id=>wwv_flow_api.id(40069252004098314)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40069366690098315)
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
 p_id=>wwv_flow_api.id(40069459561098316)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40069505885098317)
,p_db_column_name=>'COMMENT_ID'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Comment Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40069608231098318)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:CWIP_CONTRACT_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40072089391098342)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(40086038973089085)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'400861'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CONTRACT_NUMBER:FILENAME:FILE_COMMENTS:UPDATED:UPDATED_BY:DOWNLOAD'
,p_sort_column_1=>'UPDATED'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(40069796384098319)
,p_plug_name=>'Payments Recommendations Documents'
,p_parent_plug_id=>wwv_flow_api.id(39727647887361347)
,p_icon_css_classes=>'fa-file-archive-o  fam-check fam-is-success'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>40
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
'                nvl(project_number , (select p.project_number',
'                                        from cwip_contract_projects p',
'                                        where p.contract_number = (select c.contract_number',
'                                                                    from cwip_payment_recommendation c',
'                                                                    where c.payment_recommendation_id = d.payment_recommendation_id)',
'                                        and rownum = 1)) Project_number,',
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
'                sys.dbms_lob.getlength(file_blob) as file_size,',
'                sys.dbms_lob.getlength(file_blob) as download',
'            FROM',
'                cwip_payment_recommendation_documents d)',
'where project_number = :P21_PROJECT_NUMBER'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P21_PROJECT_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Payments Recommendations Documents'
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
 p_id=>wwv_flow_api.id(40069952456098321)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No attachments available for any Payments Recommendations for this project'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_show_flashback=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>40069952456098321
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40070089262098322)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40070155795098323)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40070280946098324)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40070339765098325)
,p_db_column_name=>'PAY_RECOMMENDATION_NUM'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Payment Recommendation REF#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40070408146098326)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40070566857098327)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40070624953098328)
,p_db_column_name=>'FILENAME'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40070797373098329)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40070862490098330)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40070912334098331)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'file blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40071047661098332)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40071197597098333)
,p_db_column_name=>'TAGS'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40071254654098334)
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
 p_id=>wwv_flow_api.id(40071344490098335)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40071444690098336)
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
 p_id=>wwv_flow_api.id(40071587610098337)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40071617493098338)
,p_db_column_name=>'COMMENT_ID'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Comment Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40071741054098339)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:CWIP_PAYMENT_RECOMMENDATION_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(40086640169089077)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'400867'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PAY_RECOMMENDATION_NUM:CONTRACT_NUMBER:FILENAME:FILE_COMMENTS:UPDATED:UPDATED_BY:DOWNLOAD:'
,p_sort_column_1=>'UPDATED'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(84310175444071036)
,p_plug_name=>'<span aria-hidden="true" class="fa fa-number-6-o "></span> DCT Finance'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--accent1:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>100
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':PERSON_ID in (680461,661109,1162666)'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(86725287221706339)
,p_plug_name=>'Project Dates'
,p_parent_plug_id=>wwv_flow_api.id(84310175444071036)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(86725650313706342)
,p_plug_name=>'Project Progress'
,p_parent_plug_id=>wwv_flow_api.id(84310175444071036)
,p_icon_css_classes=>'fa-calendar-clock'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>20
,p_plug_grid_column_span=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(86725736599706343)
,p_plug_name=>'Project Progress Report'
,p_parent_plug_id=>wwv_flow_api.id(86725650313706342)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10243288598597779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select rownum    No,',
'        ID,',
'       PROJECT_NUMBER,',
'       PROGRESS_DATE,',
'       PROGRESS_PCT,',
'       PROGRESS_PCT    pct,',
'       NOTES,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON',
'  from CWIP_PROJECT_PROGRESS',
' where project_number = :P21_PROJECT_NUMBER',
' order by PROGRESS_DATE'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P21_PROJECT_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Project Progress Report'
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
 p_id=>wwv_flow_api.id(86725782811706344)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:63:&SESSION.::&DEBUG.:63:P63_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>127161824640608614
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86725923477706345)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86726018809706346)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86726154214706347)
,p_db_column_name=>'PROGRESS_DATE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Progress Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86726163978706348)
,p_db_column_name=>'PROGRESS_PCT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Progress %'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86727552552706361)
,p_db_column_name=>'PCT'
,p_display_order=>50
,p_column_identifier=>'K'
,p_column_label=>'Progress'
,p_column_type=>'NUMBER'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'PCT_GRAPH::#4CD964:'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86726313113706349)
,p_db_column_name=>'NOTES'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'Note'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86726407029706350)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>70
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(20691219654288121)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86726539960706351)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>80
,p_column_identifier=>'G'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86726574902706352)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>90
,p_column_identifier=>'H'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(20691219654288121)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86726680198706353)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>100
,p_column_identifier=>'I'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86727373265706360)
,p_db_column_name=>'NO'
,p_display_order=>110
,p_column_identifier=>'J'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(87014664418342109)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1274508'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'NO:PROGRESS_DATE:PCT:PROGRESS_PCT:NOTES:UPDATED_BY:UPDATED_ON:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(86727662757706363)
,p_plug_name=>'Project Costs'
,p_parent_plug_id=>wwv_flow_api.id(84310175444071036)
,p_icon_css_classes=>'fa-dollar'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent5:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(86728069516706367)
,p_plug_name=>'Project Costs Adjustments'
,p_parent_plug_id=>wwv_flow_api.id(86727662757706363)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent2:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'CWIP_PROJECT_COST_ADJUSTMENT'
,p_query_where=>'project_number = :P21_PROJECT_NUMBER'
,p_query_order_by=>'ADJUSTMENT_DATE'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P21_PROJECT_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Project Costs Adjustments'
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
 p_id=>wwv_flow_api.id(86728173954706368)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Cost Adjustments'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:64:&SESSION.::&DEBUG.:64:P64_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>127164215783608638
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
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86728343420706369)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86728394706706370)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86728492766706371)
,p_db_column_name=>'ADJUSTMENT_DATE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Adjustment Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86728581537706372)
,p_db_column_name=>'SOFT_COST_ADJUSTED'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Soft Cost Adjusted'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86728710812706373)
,p_db_column_name=>'HARD_COST_ADJUSTED'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Hard Cost Adjusted'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86728768786706374)
,p_db_column_name=>'DECREE_NO'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Decree No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86728897504706375)
,p_db_column_name=>'NOTES'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Note'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86729016184706376)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(20691219654288121)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86729081195706377)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86729247231706378)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(20691219654288121)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86729344576706379)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(87057386144720252)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1274935'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ADJUSTMENT_DATE:SOFT_COST_ADJUSTED:HARD_COST_ADJUSTED:APXWS_CC_001:DECREE_NO:NOTES:UPDATED_BY:UPDATED_ON:'
,p_sum_columns_on_break=>'SOFT_COST_ADJUSTED:HARD_COST_ADJUSTED:APXWS_CC_001'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(87086269966635682)
,p_report_id=>wwv_flow_api.id(87057386144720252)
,p_db_column_name=>'APXWS_CC_001'
,p_column_identifier=>'C01'
,p_computation_expr=>'D  +  E'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Approved cost adjustments'
,p_report_label=>'Approved cost adjustments'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(87074239759696836)
,p_plug_name=>'Budget Split'
,p_parent_plug_id=>wwv_flow_api.id(84310175444071036)
,p_icon_css_classes=>'fa-money'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(87074275438696837)
,p_plug_name=>'Budget Split Report'
,p_parent_plug_id=>wwv_flow_api.id(87074239759696836)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10243288598597779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'CWIP_PROJECT_BUDGET_SPLIT'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P21_PROJECT_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Budget Split Report'
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
 p_id=>wwv_flow_api.id(87074430821696838)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:65:&SESSION.::&DEBUG.:65:P65_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>127510472650599108
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(87074519208696839)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(87074648049696840)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(87074727185696841)
,p_db_column_name=>'PACKAGE_DESCRIPTION'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Package Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(87074800505696842)
,p_db_column_name=>'PACKAGE_VALUE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Package Value'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(87074955310696843)
,p_db_column_name=>'PACKAGE_DATE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Package Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(87074970507696844)
,p_db_column_name=>'DECREE_NO'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Decree No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(87075122547696845)
,p_db_column_name=>'NOTES'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Note'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(87075231426696846)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(20691219654288121)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(87075277537696847)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(87075371664696848)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(20691219654288121)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(87075511520696849)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89026591375455376)
,p_db_column_name=>'REVISE_VALUE1'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Revise Value1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89026715794455377)
,p_db_column_name=>'REVISE_DATE1'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Revise Date1'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89026853069455378)
,p_db_column_name=>'REVISE_VALUE2'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Revise Value2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89026909631455379)
,p_db_column_name=>'REVISE_DATE2'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Revise Date2'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(87111189351565605)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1275473'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PACKAGE_DESCRIPTION:PACKAGE_VALUE:PACKAGE_DATE:DECREE_NO:REVISE_VALUE1:REVISE_DATE1:REVISE_VALUE2:REVISE_DATE2:NOTES:UPDATED_BY:UPDATED_ON:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(94909890409797371)
,p_plug_name=>'Assets'
,p_parent_plug_id=>wwv_flow_api.id(84310175444071036)
,p_icon_css_classes=>'fa-car'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(94909979417797372)
,p_plug_name=>'Assets Report'
,p_parent_plug_id=>wwv_flow_api.id(94909890409797371)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10243288598597779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select pa.ID, pa.PROJECT_NUMBER',
'     , pa.ASSET_ID',
'     , fa.asset_number',
'     , fa.description',
'     , fa.tag_number',
'     , pa.NOTES, pa.CREATED_BY, pa.CREATED_ON',
'     , pa.UPDATED_BY, pa.UPDATED_ON',
'from cwip_project_assets pa , fa_assets fa',
'where pa.asset_id = fa.asset_id',
'and project_number = :P21_PROJECT_NUMBER'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P21_PROJECT_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Assets Report'
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
 p_id=>wwv_flow_api.id(94910074968797373)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:67:&SESSION.::&DEBUG.::P67_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>135346116797699643
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(94910232418797374)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(94910261531797375)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(94910387021797376)
,p_db_column_name=>'ASSET_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Asset Number'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(94910550614797377)
,p_db_column_name=>'NOTES'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(94910590316797378)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(20691219654288121)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(94910666703797379)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(94910758374797380)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(20691219654288121)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95542299824923931)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95542518402923933)
,p_db_column_name=>'ASSET_NUMBER'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Asset Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95542636114923934)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95542661081923935)
,p_db_column_name=>'TAG_NUMBER'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Tag Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(95553297258910858)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1359894'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ASSET_ID:ASSET_NUMBER:DESCRIPTION:TAG_NUMBER:NOTES:UPDATED_BY:UPDATED_ON:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(95543289099923941)
,p_plug_name=>'Project Progress'
,p_parent_plug_id=>wwv_flow_api.id(84310175444071036)
,p_icon_css_classes=>'fa-percent'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(95543371484923942)
,p_plug_name=>'Project Progress Report'
,p_parent_plug_id=>wwv_flow_api.id(95543289099923941)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10243288598597779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       PROJECT_NUMBER,',
'       PROGRESS_DATE,',
'       PROGRESS_PCT,',
'       NOTES,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       REVISED_FORECASTED_OPENING,',
'       REVISED_FORECASTED_COMPLETION',
'  from CWIP_PROJECT_PROGRESS',
'  where project_number = :P21_PROJECT_NUMBER'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P21_PROJECT_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Project Progress Report'
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
 p_id=>wwv_flow_api.id(95543463458923943)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>135979505287826213
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95543610242923944)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95543673520923945)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95543761466923946)
,p_db_column_name=>'PROGRESS_DATE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Progress Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95543909010923947)
,p_db_column_name=>'PROGRESS_PCT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Progress Pct'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95543996265923948)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95544105413923949)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95544207069923950)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95544352100923951)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95544379910923952)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95544545187923953)
,p_db_column_name=>'REVISED_FORECASTED_OPENING'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Revised Forecasted Opening'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95544574537923954)
,p_db_column_name=>'REVISED_FORECASTED_COMPLETION'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Revised Forecasted Completion'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(99936242431717217)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1403723'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:PROJECT_NUMBER:PROGRESS_DATE:PROGRESS_PCT:NOTES:CREATED_BY:CREATED_ON:UPDATED_BY:UPDATED_ON:REVISED_FORECASTED_OPENING:REVISED_FORECASTED_COMPLETION'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11677781468014581)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(11652638582014566)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10307273349597826)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_button_condition=>'P21_PROJECT_NUMBER'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11676937612014581)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(11652638582014566)
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
 p_id=>wwv_flow_api.id(11676187276014581)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(11652638582014566)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10307273349597826)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.:::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11716088432333528)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(11520040783797836)
,p_button_name=>'Add_member'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI'
,p_button_template_id=>wwv_flow_api.id(10306520873597824)
,p_button_image_alt=>'Add Member'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:22:&SESSION.::&DEBUG.:22:P22_PROJECT_NUMBER,P22_PAGE_FROM:&P21_PROJECT_NUMBER.,21'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11716891952333536)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(11713985064333507)
,p_button_name=>'Add_External_Member'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI'
,p_button_template_id=>wwv_flow_api.id(10306520873597824)
,p_button_image_alt=>'Add External Team Member'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.:23:P23_PROJECT_NUMBER:&P21_PROJECT_NUMBER.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11821053435078524)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(11716949363333537)
,p_button_name=>'Add_ATTACHEMENT'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10306520873597824)
,p_button_image_alt=>'Add Attachement'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:50:&SESSION.::&DEBUG.:50:P50_PROJECT_NUMBER,P50_PAGE_FROM:&P21_PROJECT_NUMBER.,21'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(86726832397706354)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(86725650313706342)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10307273349597826)
,p_button_image_alt=>'New'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:63:&SESSION.::&DEBUG.:63:P63_PROJECT_NUMBER:&P21_PROJECT_NUMBER.'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(86729426369706380)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(86727662757706363)
,p_button_name=>'New_COST'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'Add Cost Adjustment'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:64:&SESSION.::&DEBUG.:64:P64_PROJECT_NUMBER:&P21_PROJECT_NUMBER.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(87075581429696850)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(87074239759696836)
,p_button_name=>'New_PACKAGE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10307273349597826)
,p_button_image_alt=>'New Package'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:65:&SESSION.::&DEBUG.:65:P65_PROJECT_NUMBER:&P21_PROJECT_NUMBER.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(95542390542923932)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(94909890409797371)
,p_button_name=>'Add_Asset'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'Add Asset'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:67:&SESSION.::&DEBUG.::P67_PROJECT_NUMBER:&P21_PROJECT_NUMBER.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11677385947014581)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(11652638582014566)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10307273349597826)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P21_PROJECT_NUMBER'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(11678016003014582)
,p_branch_action=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11652944922014566)
,p_name=>'P21_PROJECT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(11652638582014566)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'Project Number'
,p_source=>'PROJECT_NUMBER'
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
 p_id=>wwv_flow_api.id(11653376727014566)
,p_name=>'P21_PROJECT_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(11652638582014566)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'Project Code'
,p_source=>'PROJECT_CODE'
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
 p_id=>wwv_flow_api.id(11653780390014567)
,p_name=>'P21_PROJECT_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(11519807983797834)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'Project Name'
,p_source=>'PROJECT_NAME'
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
 p_id=>wwv_flow_api.id(11654169064014567)
,p_name=>'P21_PROJECT_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(11652638582014566)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'Project Type'
,p_source=>'PROJECT_TYPE'
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
 p_id=>wwv_flow_api.id(11654599783014567)
,p_name=>'P21_PROJECT_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(11652638582014566)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'Project Status'
,p_source=>'PROJECT_STATUS'
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
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11654948765014567)
,p_name=>'P21_TCA_DECISION_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(11519807983797834)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'Decision Number'
,p_source=>'TCA_DECISION_NUMBER'
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
 p_id=>wwv_flow_api.id(11655341662014568)
,p_name=>'P21_PROJECT_MODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(11519807983797834)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'Project Mode'
,p_source=>'PROJECT_MODE'
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
 p_id=>wwv_flow_api.id(11655757838014568)
,p_name=>'P21_TCA_PROJECT_PHASE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(11519807983797834)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'Project Phase'
,p_source=>'TCA_PROJECT_PHASE'
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
 p_id=>wwv_flow_api.id(11656176701014568)
,p_name=>'P21_START_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(11519807983797834)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
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
 p_id=>wwv_flow_api.id(11656599308014569)
,p_name=>'P21_END_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(11519807983797834)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
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
 p_id=>wwv_flow_api.id(11656967476014569)
,p_name=>'P21_TCA_PROJECT_LOCATION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(11519807983797834)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'Project Location'
,p_source=>'TCA_PROJECT_LOCATION'
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
 p_id=>wwv_flow_api.id(11657303146014569)
,p_name=>'P21_TCA_PROJECT_CATEGORY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(11519807983797834)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'Project Category'
,p_source=>'TCA_PROJECT_CATEGORY'
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
 p_id=>wwv_flow_api.id(11657778891014569)
,p_name=>'P21_TCA_PROJECT_ACTIVITY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(11519807983797834)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'Project Activity'
,p_source=>'TCA_PROJECT_ACTIVITY'
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
 p_id=>wwv_flow_api.id(11658111203014570)
,p_name=>'P21_TCA_STRATEGIC_PROJECTS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(11519807983797834)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'Strategic Project'
,p_source=>'TCA_STRATEGIC_PROJECTS'
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
 p_id=>wwv_flow_api.id(11658568065014570)
,p_name=>'P21_TCA_PROGRAMS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(11519807983797834)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'Program'
,p_source=>'TCA_PROGRAMS'
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
 p_id=>wwv_flow_api.id(11658909672014570)
,p_name=>'P21_TCA_OUTPUT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(11519807983797834)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'Output'
,p_source=>'TCA_OUTPUT'
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
 p_id=>wwv_flow_api.id(11659338601014570)
,p_name=>'P21_TCA_SECTOR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(11519807983797834)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'Sector'
,p_source=>'TCA_SECTOR'
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
 p_id=>wwv_flow_api.id(11659737663014571)
,p_name=>'P21_TCA_DEPARTMENT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(11519807983797834)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'Department'
,p_source=>'TCA_DEPARTMENT'
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
 p_id=>wwv_flow_api.id(11660125588014571)
,p_name=>'P21_DCT_SECTOR_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(11519729245797833)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_source=>'DCT_SECTOR_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11660597768014571)
,p_name=>'P21_DCT_DEPARTMENT_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(11519729245797833)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_source=>'DCT_DEPARTMENT_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11660975924014572)
,p_name=>'P21_DCT_SECTION_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(11519729245797833)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_source=>'DCT_SECTION_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11661327530014572)
,p_name=>'P21_DCT_UNIT_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(11519729245797833)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_source=>'DCT_UNIT_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11661742122014572)
,p_name=>'P21_DCT_PROJECT_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(11519729245797833)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'DCT Project Name'
,p_source=>'DCT_PROJECT_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>1020
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_help_text=>'alternative project name for reporting purpose '
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11662140837014572)
,p_name=>'P21_SERVICE_PROVIDER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(11519729245797833)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_source=>'SERVICE_PROVIDER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11662566313014573)
,p_name=>'P21_DCT_MPR_ALLOWED'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(11519729245797833)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_source=>'DCT_MPR_ALLOWED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11662989715014573)
,p_name=>'P21_DCT_MPO_ALLOWED'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(11519729245797833)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_source=>'DCT_MPO_ALLOWED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11663318447014573)
,p_name=>'P21_DCT_PROJECT_RATE'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(11519729245797833)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_source=>'DCT_PROJECT_RATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11663700554014573)
,p_name=>'P21_OU_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(11519807983797834)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_source=>'OU_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11664195270014573)
,p_name=>'P21_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(11652638582014566)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11664579570014574)
,p_name=>'P21_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(11652638582014566)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11665362501014574)
,p_name=>'P21_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(11652638582014566)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11665736579014575)
,p_name=>'P21_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(11652638582014566)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29486812457468130)
,p_name=>'P21_DCT_PROJECT_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(11519729245797833)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'DCT Project Code'
,p_source=>'DCT_PROJECT_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_cMaxlength=>50
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(84310303856071037)
,p_name=>'P21_CWIP_PROJECT_STATUS'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(84310175444071036)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'Project Status'
,p_source=>'CWIP_PROJECT_STATUS_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'CWIP PROJECT STATUS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CWIP_PROJECT_STATUS_LOOKUP.CWIP_PROJECT_STATUS as CWIP_PROJECT_STATUS,',
'    CWIP_PROJECT_STATUS_LOOKUP.CWIP_PROJECT_STATUS_ID as CWIP_PROJECT_STATUS_ID ',
' from CWIP_PROJECT_STATUS_LOOKUP CWIP_PROJECT_STATUS_LOOKUP'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(84310405291071038)
,p_name=>'P21_CWIP_STARTING_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(86725287221706339)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'Start Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'CWIP_STARTING_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(84310505112071039)
,p_name=>'P21_CWIP_ORIGINAL_FORECAST_OPEN_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(86725287221706339)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'Original forecasted opening Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'CWIP_ORIGINAL_FORECAST_OPEN_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(84310594058071040)
,p_name=>'P21_CWIP_REVISED_FORECAST_OPEN_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(86725287221706339)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'Revised forecasted opening Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'CWIP_REVISED_FORECAST_OPEN_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(84310732506071041)
,p_name=>'P21_ORIGINAL_SOFT_COST'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(86727662757706363)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'Original Soft Cost (Consultants)'
,p_post_element_text=>'AED'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'ORIGINAL_SOFT_COST'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>15
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(84310789360071042)
,p_name=>'P21_ORIGINAL_HARD_COST'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(86727662757706363)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'Original Hard Cost (Contractors)'
,p_post_element_text=>'AED'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'ORIGINAL_HARD_COST'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>15
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86724963024706336)
,p_name=>'P21_CWIP_PROJECT_PHASE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(84310175444071036)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'Project Phase'
,p_source=>'CWIP_PROJECT_PHASE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'CWIP PROJECT PHASES'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select VALUE , value_id ',
'from CWIP_LOOKUP_VALUES',
'where LOOKUP_ID = 7',
'and status = ''A''',
'and sysdate BETWEEN nvl(start_date,sysdate-10) ',
'    and NVL(end_date, sysdate + 10) ',
'order by value;'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86725176628706338)
,p_name=>'P21_CWIP_PROJECT_LOCATION_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(84310175444071036)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'Location'
,p_source=>'CWIP_PROJECT_LOCATION_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'CWIP PROJECTS LOCATIONS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  LOCATION_NAME , LOCATION_ID',
'from CWIP_PROJECT_LOCATIONS',
'where status = ''A''',
'and  sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10)'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86725423251706340)
,p_name=>'P21_CWIP_ORIGINAL_FORECAST_COMPLETE_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(86725287221706339)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'Original Forecasted Completion Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'CWIP_ORIGINAL_FORECAST_COMPLETE_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86725474552706341)
,p_name=>'P21_CWIP_REVISED_FORECAST_COMPLETE_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(86725287221706339)
,p_item_source_plug_id=>wwv_flow_api.id(11652638582014566)
,p_prompt=>'Revised Forecasted Completion Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'CWIP_REVISED_FORECAST_COMPLETE_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86727783647706364)
,p_name=>'P21_PROJECT_ORIGINAL_APPROVED_COST'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(86727662757706363)
,p_prompt=>'Project Original Approved Cost'
,p_post_element_text=>'AED'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(94909054876797362)
,p_name=>'P21_REVISED_SOFT_COST_CONSULTANTS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(86727662757706363)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Revised Soft Cost (Consultants)'
,p_post_element_text=>'AED'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(nvl(sum(SOFT_COST_ADJUSTED),0) + to_number(replace(nvl(:P21_ORIGINAL_SOFT_COST,0),'','','''')) , ''99,999,999,999.99''))  xx',
'from CWIP_PROJECT_COST_ADJUSTMENT',
'where PROJECT_NUMBER = :P21_PROJECT_NUMBER ;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(94909124147797363)
,p_name=>'P21_REVISED_HARD_COST_CONSULTANTS'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(86727662757706363)
,p_prompt=>'Revised Hard cost (Contractors)'
,p_post_element_text=>'AED'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(nvl(sum(HARD_COST_ADJUSTED),0) + to_number(replace(nvl(:P21_ORIGINAL_HARD_COST,0),'','','''')) , ''99,999,999,999.99'')) xx',
'from CWIP_PROJECT_COST_ADJUSTMENT',
'where PROJECT_NUMBER = :P21_PROJECT_NUMBER ;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(94909159753797364)
,p_name=>'P21_PROJECT_REVISED_APPROVED_COST'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(86727662757706363)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Project revised Approved Cost'
,p_post_element_text=>'AED'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(nvl(sum(HARD_COST_ADJUSTED),0) + to_number(replace(nvl(:P21_ORIGINAL_HARD_COST,0),'','','''')) +',
'            nvl(sum(SOFT_COST_ADJUSTED),0) + to_number(replace(nvl(:P21_ORIGINAL_SOFT_COST,0),'','','''')) ',
'            , ''99,999,999,999.99'')) xx',
'from CWIP_PROJECT_COST_ADJUSTMENT',
'where PROJECT_NUMBER = :P21_PROJECT_NUMBER ;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(11665072543014574)
,p_validation_name=>'P21_CREATED_ON must be timestamp'
,p_validation_sequence=>290
,p_validation=>'P21_CREATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(11664579570014574)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(11666275063014575)
,p_validation_name=>'P21_UPDATED_ON must be timestamp'
,p_validation_sequence=>310
,p_validation=>'P21_UPDATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(11665736579014575)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(12459035645889042)
,p_name=>'Dialog Close'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(11821053435078524)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12459100168889043)
,p_event_id=>wwv_flow_api.id(12459035645889042)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(11716949363333537)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(86727056007706356)
,p_name=>'New'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(86726832397706354)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(86727058525706357)
,p_event_id=>wwv_flow_api.id(86727056007706356)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(86725736599706343)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(86727175696706358)
,p_name=>'New_1'
,p_event_sequence=>30
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(86725736599706343)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(86727282434706359)
,p_event_id=>wwv_flow_api.id(86727175696706358)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(86725736599706343)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(86727863002706365)
,p_name=>'calc project Original'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P21_ORIGINAL_SOFT_COST,P21_ORIGINAL_HARD_COST'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(86727965445706366)
,p_event_id=>wwv_flow_api.id(86727863002706365)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>':P21_PROJECT_ORIGINAL_APPROVED_COST := trim(to_char(to_number(replace(nvl(:P21_ORIGINAL_SOFT_COST,0),'','','''')) + to_number(replace(nvl(:P21_ORIGINAL_HARD_COST,0),'','','''') ) , ''99,999,999,999.99'')) ;'
,p_attribute_02=>'P21_ORIGINAL_HARD_COST,P21_ORIGINAL_SOFT_COST'
,p_attribute_03=>'P21_PROJECT_ORIGINAL_APPROVED_COST'
,p_attribute_04=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(94909601239797368)
,p_event_id=>wwv_flow_api.id(86727863002706365)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P21_PROJECT_REVISED_APPROVED_COST'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(nvl(sum(HARD_COST_ADJUSTED),0) + to_number(replace(nvl(:P21_ORIGINAL_HARD_COST,0),'','','''')) +',
'            nvl(sum(SOFT_COST_ADJUSTED),0) + to_number(replace(nvl(:P21_ORIGINAL_SOFT_COST,0),'','','''')) ',
'            , ''99,999,999,999.99'')) xx',
'from CWIP_PROJECT_COST_ADJUSTMENT',
'where PROJECT_NUMBER = :P21_PROJECT_NUMBER ;'))
,p_attribute_07=>'P21_ORIGINAL_HARD_COST,P21_ORIGINAL_SOFT_COST,P21_PROJECT_NUMBER'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(94909753205797369)
,p_event_id=>wwv_flow_api.id(86727863002706365)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P21_REVISED_SOFT_COST_CONSULTANTS'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(nvl(sum(SOFT_COST_ADJUSTED),0) + to_number(replace(nvl(:P21_ORIGINAL_SOFT_COST,0),'','','''')) , ''99,999,999,999.99''))  xx',
'from CWIP_PROJECT_COST_ADJUSTMENT',
'where PROJECT_NUMBER = :P21_PROJECT_NUMBER ;'))
,p_attribute_07=>'P21_ORIGINAL_SOFT_COST,P21_PROJECT_NUMBER'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(94909800304797370)
,p_event_id=>wwv_flow_api.id(86727863002706365)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P21_REVISED_HARD_COST_CONSULTANTS'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(nvl(sum(HARD_COST_ADJUSTED),0) + to_number(replace(nvl(:P21_ORIGINAL_HARD_COST,0),'','','''')) , ''99,999,999,999.99'')) xx',
'from CWIP_PROJECT_COST_ADJUSTMENT',
'where PROJECT_NUMBER = :P21_PROJECT_NUMBER ;'))
,p_attribute_07=>'P21_ORIGINAL_HARD_COST,P21_PROJECT_NUMBER'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(87073770964696832)
,p_name=>'New_COST DA'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(86729426369706380)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(87073905195696833)
,p_event_id=>wwv_flow_api.id(87073770964696832)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(86728069516706367)
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
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(87074053862696834)
,p_name=>'New_COST DA2'
,p_event_sequence=>60
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(86728069516706367)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(87074072129696835)
,p_event_id=>wwv_flow_api.id(87074053862696834)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(86728069516706367)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(87075825821696852)
,p_name=>'New_PACKAGE DA'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(87075581429696850)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(87075928190696853)
,p_event_id=>wwv_flow_api.id(87075825821696852)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(87074275438696837)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(87075968587696854)
,p_name=>'New_PACKAGE DA2'
,p_event_sequence=>80
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(87074275438696837)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(87076099321696855)
,p_event_id=>wwv_flow_api.id(87075968587696854)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(87074275438696837)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(95542893045923937)
,p_name=>'Add Assets DA'
,p_event_sequence=>90
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(95542390542923932)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(95542968172923938)
,p_event_id=>wwv_flow_api.id(95542893045923937)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(94909979417797372)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(95543098418923939)
,p_name=>'Asset DA'
,p_event_sequence=>100
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(94909979417797372)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(95543238452923940)
,p_event_id=>wwv_flow_api.id(95543098418923939)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(94909979417797372)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(11678968764014582)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(11652638582014566)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Project Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(11678582424014582)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(11652638582014566)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Project Details'
);
wwv_flow_api.component_end;
end;
/
