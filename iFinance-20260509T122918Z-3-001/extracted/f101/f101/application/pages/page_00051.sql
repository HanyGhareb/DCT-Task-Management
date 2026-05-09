prompt --application/pages/page_00051
begin
--   Manifest
--     PAGE: 00051
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
 p_id=>51
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'DCT IMPREST Accounts'
,p_alias=>'DCT-IMPREST-ACCOUNTS'
,p_step_title=>'DCT IMPREST Accounts'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210628111710'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(31973339739704971)
,p_plug_name=>'DCT IMPREST List'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders'
,p_plug_template=>wwv_flow_api.id(8055912915175506)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select VENDOR_NAME,',
'       VENDOR_NUM,',
'       VENDOR_SITE_CODE,',
'       VENDOR_STATUS,',
'       BANK_ACCOUNT,',
'       BANK_ACCOUNT_NAME,',
'       START_DATE_ACTIVE,',
'       END_DATE_ACTIVE,',
'       ENABLED_FLAG,',
'       HOLD_FLAG,',
'       CREATED_BY,',
'       CREATION_DATE,',
'       LAST_UPDATE_DATE,',
'       LAST_UPDATED_BY,',
'       EMPLOYEE_NUMBER,',
'       (select count(*)',
'        from employees_invoices ei',
'        where ei.VENDOR_NUM = ev.VENDOR_NUM',
'         and ei.vendor_site_code = ev.vendor_site_code',
'         ) inv_count',
'  from EMPLOYEE_VENDORS ev',
'where vendor_name = ''ABU DHABI TOURISM & CULTURE AUTHORITY - IMPREST''; '))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'FAB DEBIT CARD List'
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
 p_id=>wwv_flow_api.id(31973755283704970)
,p_name=>'Report 1'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:50:&SESSION.::&DEBUG.:RP,:P50_VENDOR_NUM,P50_VENDOR_SITE_CODE,P50_PAGE_FROM:\#VENDOR_NUM#\,\#VENDOR_SITE_CODE#\,51'
,p_detail_link_text=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_owner=>'TCA9051'
,p_internal_uid=>64665853520167484
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(331746594970632)
,p_db_column_name=>'VENDOR_NAME'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Vendor Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(331375595970633)
,p_db_column_name=>'VENDOR_NUM'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Vendor Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(330995205970633)
,p_db_column_name=>'VENDOR_SITE_CODE'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Vendor Site Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(326137362970636)
,p_db_column_name=>'EMPLOYEE_NUMBER'
,p_display_order=>13
,p_column_identifier=>'O'
,p_column_label=>'Employee'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(354964510862994)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(330575824970633)
,p_db_column_name=>'VENDOR_STATUS'
,p_display_order=>23
,p_column_identifier=>'D'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(330163171970633)
,p_db_column_name=>'BANK_ACCOUNT'
,p_display_order=>33
,p_column_identifier=>'E'
,p_column_label=>'Bank Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(329775166970634)
,p_db_column_name=>'BANK_ACCOUNT_NAME'
,p_display_order=>43
,p_column_identifier=>'F'
,p_column_label=>'Bank Account Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(329384526970634)
,p_db_column_name=>'START_DATE_ACTIVE'
,p_display_order=>53
,p_column_identifier=>'G'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(328921665970634)
,p_db_column_name=>'END_DATE_ACTIVE'
,p_display_order=>63
,p_column_identifier=>'H'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(328564725970635)
,p_db_column_name=>'ENABLED_FLAG'
,p_display_order=>73
,p_column_identifier=>'I'
,p_column_label=>'Enabled ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(328137219970635)
,p_db_column_name=>'HOLD_FLAG'
,p_display_order=>83
,p_column_identifier=>'J'
,p_column_label=>'Hold ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(327796145970635)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>93
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(327321661970636)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>103
,p_column_identifier=>'L'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(326916810970636)
,p_db_column_name=>'LAST_UPDATE_DATE'
,p_display_order=>113
,p_column_identifier=>'M'
,p_column_label=>'Last Update Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(326522664970636)
,p_db_column_name=>'LAST_UPDATED_BY'
,p_display_order=>123
,p_column_identifier=>'N'
,p_column_label=>'Last Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(518553852973693)
,p_db_column_name=>'INV_COUNT'
,p_display_order=>133
,p_column_identifier=>'P'
,p_column_label=>'Invoices Count'
,p_column_link=>'f?p=&APP_ID.:52:&SESSION.::&DEBUG.::P52_VENDOR_NUM,P52_VENDOR_SITE_CODE,EMPLOYEE_NAME:#VENDOR_NUM#,#VENDOR_SITE_CODE#,#EMPLOYEE_NUMBER#'
,p_column_linktext=>'#INV_COUNT#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(31982604281704277)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'323663'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'VENDOR_NAME:VENDOR_SITE_CODE:EMPLOYEE_NUMBER:VENDOR_STATUS:ENABLED_FLAG:BANK_ACCOUNT:BANK_ACCOUNT_NAME:START_DATE_ACTIVE::INV_COUNT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(31980716623704958)
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
 p_id=>wwv_flow_api.id(325312983970641)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(31973339739704971)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:50:&SESSION.::&DEBUG.:50'
,p_button_condition_type=>'NEVER'
);
wwv_flow_api.component_end;
end;
/
