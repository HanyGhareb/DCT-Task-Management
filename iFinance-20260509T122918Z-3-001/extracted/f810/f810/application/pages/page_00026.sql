prompt --application/pages/page_00026
begin
--   Manifest
--     PAGE: 00026
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>26
,p_user_interface_id=>wwv_flow_api.id(12983317716762193)
,p_name=>'Default Options'
,p_alias=>'DEFAULT-OPTIONS'
,p_step_title=>'Default Options'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230907185138'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1283606752674872)
,p_plug_name=>'Default Options Report'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12896834679762110)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       AP_TRX_CODE,',
'       SUPPLIER_NAME,',
'       SUPPLIER_NUM,',
'       SITE_NAME,',
'       INVOICE_TYPE,',
'       OU_NAME,',
'       CURRENCY,',
'       PAYMENT_METHOD,',
'       PAY_GROUP,',
'       PAYMENT_TERM,',
'       PROJECT_ORG,',
'       VERSION,',
'       STATUS,',
'       START_DATE,',
'       END_DATE,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       HEADER_CONTEXT,',
'       PAY_ALONE,',
'       CREATE_PV_AFTER_CONFIRM,',
'       ALLOW_MULTI_REQUESTS,',
'       MISSION_EXCEPTION_YN',
'  from AP_DEFAULT_OPTIONS'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Default Options Report'
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
 p_id=>wwv_flow_api.id(1283984922674872)
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
,p_internal_uid=>111894861412681849
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1284095125674871)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1284427138674871)
,p_db_column_name=>'AP_TRX_CODE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'AP Trx Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1284878581674871)
,p_db_column_name=>'SUPPLIER_NAME'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Supplier Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1285285207674871)
,p_db_column_name=>'SUPPLIER_NUM'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Supplier Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1285666964674870)
,p_db_column_name=>'SITE_NAME'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Site Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1286086361674870)
,p_db_column_name=>'INVOICE_TYPE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Invoice Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1327179333432795)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1286442408674870)
,p_db_column_name=>'OU_NAME'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'OU Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1286844171674870)
,p_db_column_name=>'CURRENCY'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1287245664674870)
,p_db_column_name=>'PAYMENT_METHOD'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Payment Method'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1319083099548486)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1287638059674870)
,p_db_column_name=>'PAY_GROUP'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Pay Group'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1319474532498846)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1288067857674869)
,p_db_column_name=>'PAYMENT_TERM'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Payment Term'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1322776634467569)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1288447716674869)
,p_db_column_name=>'PROJECT_ORG'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Project Org'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1288878446674869)
,p_db_column_name=>'VERSION'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Version'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1289266102674869)
,p_db_column_name=>'STATUS'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109817458020935965)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1289716287674869)
,p_db_column_name=>'START_DATE'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1290043604674869)
,p_db_column_name=>'END_DATE'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1290428766674868)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48056159040127691)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1290862069674868)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48056159040127691)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1291323279674868)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1291685283674868)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7077308569800425)
,p_db_column_name=>'HEADER_CONTEXT'
,p_display_order=>30
,p_column_identifier=>'U'
,p_column_label=>'Header Context'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7077333665800426)
,p_db_column_name=>'PAY_ALONE'
,p_display_order=>40
,p_column_identifier=>'V'
,p_column_label=>'Pay Alone'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7077487789800427)
,p_db_column_name=>'CREATE_PV_AFTER_CONFIRM'
,p_display_order=>50
,p_column_identifier=>'W'
,p_column_label=>'Create Pv After Confirm'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7077597133800428)
,p_db_column_name=>'ALLOW_MULTI_REQUESTS'
,p_display_order=>60
,p_column_identifier=>'X'
,p_column_label=>'Allow Multi Requests'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(109820486212935961)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(72139632931071961)
,p_db_column_name=>'MISSION_EXCEPTION_YN'
,p_display_order=>70
,p_column_identifier=>'Y'
,p_column_label=>'Mission Exception ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(109820486212935961)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(1302584852654932)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1119135'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'AP_TRX_CODE:SUPPLIER_NAME:SUPPLIER_NUM:SITE_NAME:INVOICE_TYPE:OU_NAME:CURRENCY:PAYMENT_METHOD:PAY_GROUP:PAYMENT_TERM:PROJECT_ORG:VERSION:STATUS:START_DATE:END_DATE::HEADER_CONTEXT:PAY_ALONE:CREATE_PV_AFTER_CONFIRM:ALLOW_MULTI_REQUESTS:MISSION_EXCEPTI'
||'ON_YN'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1292981538674865)
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
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1294188112674864)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(1283606752674872)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12960857103762161)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:27:&SESSION.::&DEBUG.:27'
);
wwv_flow_api.component_end;
end;
/
