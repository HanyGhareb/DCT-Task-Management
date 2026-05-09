prompt --application/pages/page_00045
begin
--   Manifest
--     PAGE: 00045
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>45
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'KPI Templates All'
,p_alias=>'KPI-TEMPLATES-ALL'
,p_step_title=>'KPI Templates All'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20221221102456'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(140430154274497673)
,p_plug_name=>'KPI Templates All Report'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'DP_SCOPE_TEMPLATE_KPI'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A3'
,p_prn_width=>420
,p_prn_height=>297
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'KPI Templates All Report'
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
 p_id=>wwv_flow_api.id(140430523774497673)
,p_name=>'Report 1'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:46:&SESSION.::&DEBUG.:RP:P46_SCOPE_TEMPLATE_KPI_ID:\#SCOPE_TEMPLATE_KPI_ID#\'
,p_detail_link_text=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_owner=>'TCA9051'
,p_internal_uid=>140430523774497673
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140430634943497672)
,p_db_column_name=>'SCOPE_TEMPLATE_KPI_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Scope Template Kpi Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140431018037497671)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Template'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(138404640303341881)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140431444314497671)
,p_db_column_name=>'KPI_CODE'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'KPI Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140431839724497671)
,p_db_column_name=>'KPI_NAME'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'KPI Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140432254768497670)
,p_db_column_name=>'KPI_DESCRIPTION'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'KPI Description'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140432660007497670)
,p_db_column_name=>'MEASURE_DESC'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Measure'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140433057483497670)
,p_db_column_name=>'SERVICE_CREDITS_PCT'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Service Credits %'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140433481658497670)
,p_db_column_name=>'SERVICE_CREDITS'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Service Credits'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140433813687497670)
,p_db_column_name=>'TARGET_VALUE'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Target Value'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140434211315497670)
,p_db_column_name=>'TARGET_DATE'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Target Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140434620196497669)
,p_db_column_name=>'TREND_DIRECTION'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Trend Direction'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140435029260497669)
,p_db_column_name=>'SERVICE_LEVEL'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Service Level'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140435415376497669)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140435877370497669)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140436245429497669)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140436683412497669)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140895226174593005)
,p_db_column_name=>'SUB_CATEGORY_ID'
,p_display_order=>26
,p_column_identifier=>'Q'
,p_column_label=>'Item Sub-Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(140845235127023726)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(140450601656187735)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1404507'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'TEMPLATE_ID:KPI_DESCRIPTION:MEASURE_DESC:SERVICE_CREDITS_PCT:UPDATED_BY:UPDATED_DATE::SUB_CATEGORY_ID'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(140437919663497664)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127813188296449776)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(127749711524449850)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(127867332295449731)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(140439121671497664)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(140430154274497673)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New KPI'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:46:&SESSION.::&DEBUG.:46'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.component_end;
end;
/
