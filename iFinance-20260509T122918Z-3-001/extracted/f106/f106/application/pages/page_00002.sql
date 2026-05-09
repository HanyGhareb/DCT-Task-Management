prompt --application/pages/page_00002
begin
--   Manifest
--     PAGE: 00002
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>227103249168277234
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>2
,p_user_interface_id=>wwv_flow_api.id(12983317716762193)
,p_name=>'Insurance Statement'
,p_alias=>'INSURANCE-STATEMENT'
,p_step_title=>'Insurance Statement'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20201230070214'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12701433883649338)
,p_plug_name=>'Search criteria'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12996971416767878)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12908155528762118)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(12844716791762062)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(12962203224762162)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12997575282767878)
,p_plug_name=>'Insurance Statement'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton'
,p_plug_template=>wwv_flow_api.id(12896834679762110)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    invoice_num,',
'    description,',
'    invoice_date,',
'    invoice_amount,',
'    CASE',
'        WHEN check_date <= :p2_as_of THEN',
'            invoice_payment_amount',
'        ELSE',
'            0',
'    END  paid_amount,',
'    CASE',
'        WHEN check_date <= :p2_as_of THEN',
'            check_date',
'        ELSE',
'            NULL',
'    END  payment_date,',
'      CASE',
'        WHEN CLEAR_DATE <= :p2_as_of THEN',
'            invoice_payment_amount',
'        ELSE',
'            0',
'    END  deposit_amount,',
'    CLEAR_DATE',
'FROM',
'    (',
'        SELECT',
'            *',
'        FROM',
'            insurance_invoices',
'        WHERE',
'                invoice_date <= :p2_as_of',
'            AND vendor_name = :p2_vendor_name',
'    )'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P2_AS_OF,P2_VENDOR_NAME'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A4'
,p_prn_width=>297
,p_prn_height=>210
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Account Statement',
'For: &P2_VENDOR_NAME.',
'As of &P2_AS_OF.'))
,p_prn_page_header_font_color=>'#023B05'
,p_prn_page_header_font_family=>'Courier'
,p_prn_page_header_font_weight=>'bold'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#023B05'
,p_prn_header_font_color=>'#FFFFFF'
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
 p_id=>wwv_flow_api.id(12997675491767878)
,p_name=>'Insurance Statement'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>12997675491767878
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12998051136767883)
,p_db_column_name=>'INVOICE_NUM'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Invoice Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12998463307767885)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12998842665767885)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12999270586767886)
,p_db_column_name=>'INVOICE_AMOUNT'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Invoice Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00PR'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12999656161767886)
,p_db_column_name=>'PAID_AMOUNT'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Paid Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00PR'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13000003228767886)
,p_db_column_name=>'PAYMENT_DATE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Payment Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12702338195649347)
,p_db_column_name=>'CLEAR_DATE'
,p_display_order=>16
,p_column_identifier=>'G'
,p_column_label=>'Deposit Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12702473182649348)
,p_db_column_name=>'DEPOSIT_AMOUNT'
,p_display_order=>26
,p_column_identifier=>'H'
,p_column_label=>'Deposit Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(13002219463783708)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'130023'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'INVOICE_NUM:DESCRIPTION:INVOICE_DATE:INVOICE_AMOUNT:APXWS_CC_001:'
,p_sort_column_1=>'CLEAR_DATE'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'INVOICE_DATE'
,p_sort_direction_2=>'ASC'
,p_sum_columns_on_break=>'INVOICE_AMOUNT:PAID_AMOUNT:APXWS_CC_001'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(13065824641626981)
,p_report_id=>wwv_flow_api.id(13002219463783708)
,p_db_column_name=>'APXWS_CC_001'
,p_column_identifier=>'C01'
,p_computation_expr=>'D  - H'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Balance'
,p_report_label=>'Balance'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12701831304649342)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(12997575282767878)
,p_button_name=>'Print'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Print'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-print'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12701375714649337)
,p_name=>'P2_AS_OF'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(12701433883649338)
,p_item_default=>'select sysdate from dual'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Account Statement As Of'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12701798749649341)
,p_name=>'P2_VENDOR_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(12701433883649338)
,p_prompt=>'Vendor Name'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'SELECT DISTINCT VENDOR_NAME D , VENDOR_NAME R FROM INSURANCE_INVOICES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(12701523538649339)
,p_name=>'refresh report'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P2_AS_OF,P2_VENDOR_NAME'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12701655067649340)
,p_event_id=>wwv_flow_api.id(12701523538649339)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(12997575282767878)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(12701909345649343)
,p_name=>'Print Statement'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(12701831304649342)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12702070861649344)
,p_event_id=>wwv_flow_api.id(12701909345649343)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'javaScript:window.open(''f?p=106:0:&SESSION.:PRINT_REPORT=insurance%20statement'' , ''_blank'');'
);
wwv_flow_api.component_end;
end;
/
