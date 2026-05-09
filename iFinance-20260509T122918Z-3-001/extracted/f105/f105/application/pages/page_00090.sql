prompt --application/pages/page_00090
begin
--   Manifest
--     PAGE: 00090
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>90
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'DP Item Details'
,p_alias=>'DP-ITEM-DETAILS1'
,p_step_title=>'DP Item Details'
,p_autocomplete_on_off=>'OFF'
,p_css_file_urls=>'#WORKSPACE_IMAGES#main.css'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.t-Form-label {',
'    	color: #368ed2;',
'	font-weight: bold;',
'	font-size:12px;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230308101131'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(85569878277515386)
,p_plug_name=>'Participants'
,p_icon_css_classes=>'fa-universal-access'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>50
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(85570016353515387)
,p_plug_name=>'Participants Report'
,p_parent_plug_id=>wwv_flow_api.id(85569878277515386)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'DP_ITEM_PARTICIPANTS'
,p_query_where=>'item_id = :P90_ITEM_ID'
,p_query_order_by=>'ID'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P90_ITEM_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Participants Report'
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
 p_id=>wwv_flow_api.id(85570035936515388)
,p_max_row_count=>'1000000'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>298854068325700020
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58465386451454776)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58464964717454776)
,p_db_column_name=>'ITEM_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58464603702454775)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Name'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58464157470454775)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Role'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(64248654316166126)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58463758772454775)
,p_db_column_name=>'STATUS'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(780300318120911)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58463344308454775)
,p_db_column_name=>'START_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58462938942454775)
,p_db_column_name=>'END_DATE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58462593435454774)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58462183714454774)
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
 p_id=>wwv_flow_api.id(58461806961454774)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58461417537454774)
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
 p_id=>wwv_flow_api.id(58461011725454774)
,p_db_column_name=>'NOTES'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(86344361927855765)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1548234'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PERSON_ID:ROLE_ID:STATUS:START_DATE:END_DATE:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(58460174075454773)
,p_report_id=>wwv_flow_api.id(86344361927855765)
,p_name=>'Owner'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Active'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Active''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#D0F1CC'
,p_row_font_color=>'#000000'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(92681639198424148)
,p_plug_name=>'Warning'
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--warning:t-Alert--removeHeading:t-Form--slimPadding'
,p_plug_template=>wwv_flow_api.id(99726350799410732)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p>As per Supply chain management, SLA Day: <strong><span style="color: #0000ff;">&P90_SLA_DAYS.&nbsp;&nbsp;<span style="color: #000000;">days</span></span></strong>, The Scoping document should submitted by: <strong><span style="color: #0000ff;">&P9'
||'0_SLA_DATE.</span></strong></p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P90_SLA_DAYS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(214299365399273143)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99766883142410755)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(99703488427410717)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(99820961719410781)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(214299935171273141)
,p_plug_name=>'Main Details'
,p_icon_css_classes=>'fa-list-ul'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--noBorder:t-Region--scrollBody:margin-right-none'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(214300708552273140)
,p_plug_name=>'Audit Info'
,p_parent_plug_id=>wwv_flow_api.id(214299935171273141)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(214577855099298419)
,p_plug_name=>'Header Details'
,p_parent_plug_id=>wwv_flow_api.id(214299935171273141)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_grid_column_span=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(214578021464298421)
,p_plug_name=>'Summary'
,p_parent_plug_id=>wwv_flow_api.id(214299935171273141)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_new_grid_row=>false
,p_plug_display_column=>11
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(214578128931298422)
,p_plug_name=>'Status'
,p_parent_plug_id=>wwv_flow_api.id(214578021464298421)
,p_icon_css_classes=>'fa-suitcase'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody:t-Form--slimPadding:t-Form--large:t-Form--leftLabels:margin-left-none:margin-right-none'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(214301164830273140)
,p_plug_name=>'Documents'
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>70
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(214407452487838607)
,p_plug_name=>'Documents report'
,p_parent_plug_id=>wwv_flow_api.id(214301164830273140)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ROW_VERSION_NUMBER,',
'       DP_ITEMS_ID,',
'       FILENAME,',
'       FILE_MIMETYPE,',
'       FILE_CHARSET,',
'       FILE_BLOB,',
'       FILE_COMMENTS,',
'       TAGS,',
'       CREATED,',
'       CREATED_BY,',
'       UPDATED,',
'       UPDATED_BY,',
'       COMMENT_ID,',
'      sys.dbms_lob.getlength(file_blob) as file_size,',
'    sys.dbms_lob.getlength(file_blob) as download',
'  from DP_ITEMS_DOCUMENTS',
'  where dp_items_id = :P90_ITEM_ID',
'    order by UPDATED desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P90_ITEM_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Documents report'
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
 p_id=>wwv_flow_api.id(214407594646838608)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No documents available.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>427691627036023240
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58511347666454812)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58510933736454812)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58510622046454811)
,p_db_column_name=>'DP_ITEMS_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Dp Items Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58510201216454811)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'File Name'
,p_column_link=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.::P14_PAGE_FROM,P14_REVIEW_STATUS,P14_ID:11,&P11_REVIEW_STATUS.,#ID#'
,p_column_linktext=>'#FILENAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58509805269454810)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58509361498454810)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58509028100454810)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58508577120454810)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58508228281454810)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58507766926454809)
,p_db_column_name=>'CREATED'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58507332899454809)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58506981614454809)
,p_db_column_name=>'UPDATED'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58506610555454809)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58506135499454808)
,p_db_column_name=>'COMMENT_ID'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Comment Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58505760041454808)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58505388737454808)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:DP_ITEMS_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(214433107350553775)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1547790'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:TAGS:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(214301504875273140)
,p_plug_name=>'Review /Approval History'
,p_icon_css_classes=>'fa-users'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent13:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>80
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT 1',
'FROM    dp_items_approval_history h',
'where h.request_id = :P90_ITEM_ID;'))
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(214409553047838628)
,p_plug_name=>'Review History Report'
,p_parent_plug_id=>wwv_flow_api.id(214301504875273140)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    h.id,',
'    h.request_id,',
'    h.step_no,',
'    h.person_id,',
'    h.role_id,',
'    h.role_desc,',
'    h.action_required,',
'    h.recevied_date,',
'    h.status,',
'    h.action_date,',
'    h.comments,',
'    h.approval_type,',
'    case h.status',
'        When ''Rejected'' Then ''u-danger-text''',
'        when ''Approved'' Then ''u-success''',
'        When ''Accepted'' Then ''u-success''',
'    End status_class,',
'       ',
'    e.full_name_en || ''('' || e.user_name || '')'' as full_name_en,',
'    case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'       when 0  THEN',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'        else  ',
'            ',
'         ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'       end Photo',
'FROM',
'    dp_items_approval_history h, dct_employees_list2  e',
'where h.person_id = e.person_id (+)',
'and h.request_id = :P90_ITEM_ID',
'and h.status != ''Beaten''',
'order by h.STEP_NO ',
'--, h.ID',
';'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P90_ITEM_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Review History Report'
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
 p_id=>wwv_flow_api.id(214409667522838629)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>427693699912023261
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58504032326454807)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58503533640454806)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58503218622454806)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58502746308454806)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58502417057454806)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Role'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(64238386933166115)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58502001691454805)
,p_db_column_name=>'ROLE_DESC'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Role Desc'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58501565436454805)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58501133389454805)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58500755349454805)
,p_db_column_name=>'STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58500390075454805)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58499961514454804)
,p_db_column_name=>'COMMENTS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58499547622454804)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58499137232454804)
,p_db_column_name=>'STATUS_CLASS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Status Class'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58498791278454804)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58498339216454803)
,p_db_column_name=>'PHOTO'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(214676627415525998)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1547860'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:PHOTO:FULL_NAME_EN:ROLE_ID:ACTION_REQUIRED:RECEVIED_DATE:STATUS:ACTION_DATE:COMMENTS:'
,p_sort_column_1=>'STEP_NO'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(58497570249454802)
,p_report_id=>wwv_flow_api.id(214676627415525998)
,p_name=>'Pending'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Pending'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Pending''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#D0F1CC'
,p_row_font_color=>'#000000'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(214689659445608709)
,p_plug_name=>'Collaboration'
,p_icon_css_classes=>'fa-comments-o fa-anim-flash fam-sleep fam-is-success'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody:margin-left-none'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(214689827679608711)
,p_name=>'Comments Report'
,p_parent_plug_id=>wwv_flow_api.id(214689659445608709)
,p_template=>wwv_flow_api.id(99730028608410735)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Form--slimPadding:t-Form--large'
,p_component_template_options=>'#DEFAULT#:t-Comments--chat'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  ',
'        CASE',
'            WHEN dbms_lob.getlength(photo_blob) > 0 THEN',
'                ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(user_name)',
'     End   user_icon,',
'  updated_date  comment_date,',
'  full_name_en user_name,',
'  comment_text                    comment_text,',
'  null comment_modifiers,',
'   ''u-color-''||ora_hash(user_name,45) icon_modifier,',
'  ACTION     actions,',
'  ''''     attribute_1,',
'  ''''     attribute_2,',
'  ''''    attribute_3,',
'  sys.dbms_lob.getlength(file_blob)     attribute_4,',
'  comment_id,',
'  filename',
'  --',
',(Select e.full_name_en',
'                    from employees_v e',
'                    where e.person_id = comment_to_person_id)',
'         Comment_to',
'--',
'from   ',
'(SELECT',
'    c.comment_id,',
'    c.ITEM_ID,',
'    c.comment_text,',
'    c.created_by,',
'    c.updated_by,',
'    c.creation_date,',
'    c.updated_date,',
'    c.action        action,',
'    e.full_name_en,',
'    e.user_name,',
'    e.photo_blob,',
'    c.filename,',
'    c.file_blob,',
'    c.comment_to_person_id',
'FROM',
'    dp_items_comments c , dct_employees_list2 e',
'where c.updated_by = e.person_id',
')',
'where ITEM_ID = :P90_ITEM_ID',
'order by CREATION_DATE desc;'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P90_ITEM_ID'
,p_query_row_template=>wwv_flow_api.id(99786373050410764)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No Communications yet.'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(58496171153454800)
,p_query_column_id=>1
,p_column_alias=>'USER_ICON'
,p_column_display_sequence=>1
,p_column_heading=>'User Icon'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<img src="#USER_ICON#" alt="Image Not Found" height="40" width="40">'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(58495765025454800)
,p_query_column_id=>2
,p_column_alias=>'COMMENT_DATE'
,p_column_display_sequence=>2
,p_column_heading=>'Comment Date'
,p_use_as_row_header=>'N'
,p_column_format=>'SINCE'
,p_column_html_expression=>'<br>#COMMENT_DATE#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(58495410032454800)
,p_query_column_id=>3
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>3
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<span style="color:red">From: #USER_NAME# </span>'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(58490971231454797)
,p_query_column_id=>4
,p_column_alias=>'COMMENT_TEXT'
,p_column_display_sequence=>4
,p_column_heading=>'Comment Text'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:17:&SESSION.::&DEBUG.::P17_COMMENT_ID:#COMMENT_ID#'
,p_column_linktext=>'#COMMENT_TEXT#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(58494946552454799)
,p_query_column_id=>5
,p_column_alias=>'COMMENT_MODIFIERS'
,p_column_display_sequence=>5
,p_column_heading=>'Comment Modifiers'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(58494614134454799)
,p_query_column_id=>6
,p_column_alias=>'ICON_MODIFIER'
,p_column_display_sequence=>6
,p_column_heading=>'Icon Modifier'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(58494169467454799)
,p_query_column_id=>7
,p_column_alias=>'ACTIONS'
,p_column_display_sequence=>7
,p_column_heading=>'Actions'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(58493795454454799)
,p_query_column_id=>8
,p_column_alias=>'ATTRIBUTE_1'
,p_column_display_sequence=>8
,p_column_heading=>'Attribute 1'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(58493337070454799)
,p_query_column_id=>9
,p_column_alias=>'ATTRIBUTE_2'
,p_column_display_sequence=>9
,p_column_heading=>'Attribute 2'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(58492940749454798)
,p_query_column_id=>10
,p_column_alias=>'ATTRIBUTE_3'
,p_column_display_sequence=>10
,p_column_heading=>'Attribute 3'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(58492544172454798)
,p_query_column_id=>11
,p_column_alias=>'ATTRIBUTE_4'
,p_column_display_sequence=>11
,p_column_heading=>'Attribute 4'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(58492145671454798)
,p_query_column_id=>12
,p_column_alias=>'COMMENT_ID'
,p_column_display_sequence=>12
,p_column_heading=>'Comment Id'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(58491755750454798)
,p_query_column_id=>13
,p_column_alias=>'FILENAME'
,p_column_display_sequence=>13
,p_column_heading=>'Filename'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(58491386189454798)
,p_query_column_id=>14
,p_column_alias=>'COMMENT_TO'
,p_column_display_sequence=>14
,p_column_heading=>'Comment To'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(214694014641608753)
,p_plug_name=>'Review & Verification Partners'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:is-expanded:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>40
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(214577351357298414)
,p_name=>'Roles'
,p_parent_plug_id=>wwv_flow_api.id(214694014641608753)
,p_template=>wwv_flow_api.id(99757408152410744)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight:t-Report--horizontalBorders'
,p_grid_column_span=>8
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select role_id  , person_id',
'from DP_ITEM_ROLES',
'where item_id = :P90_ITEM_ID;'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P90_ITEM_ID'
,p_query_row_template=>wwv_flow_api.id(99783722631410762)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(58467145581454777)
,p_query_column_id=>1
,p_column_alias=>'ROLE_ID'
,p_column_display_sequence=>1
,p_column_heading=>'Role'
,p_use_as_row_header=>'N'
,p_column_alignment=>'RIGHT'
,p_display_as=>'TEXT_FROM_LOV_ESC'
,p_named_lov=>wwv_flow_api.id(64240590228166117)
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(58466741284454777)
,p_query_column_id=>2
,p_column_alias=>'PERSON_ID'
,p_column_display_sequence=>2
,p_column_heading=>'Employee'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_display_as=>'TEXT_FROM_LOV_ESC'
,p_named_lov=>wwv_flow_api.id(48836004784526)
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(214963043358685404)
,p_plug_name=>'Budget Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:is-expanded:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>60
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_read_only_when_type=>'PLSQL_EXPRESSION'
,p_plug_read_only_when=>':P90_ITEM_ID is not null and :P90_REVIEW_STATUS not in (''Draft'',''Withdraw'' , ''Return'')'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(93578633867600667)
,p_plug_name=>'Budget Details L'
,p_parent_plug_id=>wwv_flow_api.id(214963043358685404)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(93578746010600668)
,p_plug_name=>'Budget Details R'
,p_parent_plug_id=>wwv_flow_api.id(214963043358685404)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>5
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(94550503238821272)
,p_plug_name=>'Cashflow Details'
,p_parent_plug_id=>wwv_flow_api.id(214963043358685404)
,p_icon_css_classes=>'fa-money'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1',
'from cashflow_lines',
'where SOURCE = ''DP''',
'and REQUEST_ID = :P90_ITEM_ID;'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(94550609858821273)
,p_plug_name=>'Cashflow Details Report'
,p_parent_plug_id=>wwv_flow_api.id(94550503238821272)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select LINE_ID,',
'       BUDGET_ALLOCATION_PLAN_ID,',
'       ACCOUNTING_YEAR,',
'       MULTI_YEAR_YN,',
'       DISTRIBUTION_DATE,',
'       PROJECT_NUMBER,',
'       TASK_NUMBER,',
'       EXPENDITURE_TYPE,',
'       PROJECT_NAME_NEW,',
'       TASK_NUMBER_NEW,',
'       EXPENDITURE_TYPE_NEW,',
'       ENTITY_CODE,',
'       COST_CENTER,',
'       BUDGET_GROUB_CODE,',
'       GL_ACCOUNT,',
'       ACTIVITY,',
'       FUTURE1,',
'       FUTURE2,',
'       ENTITY_CODE_NEW,',
'       COST_CENTER_NEW,',
'       BUDGET_GROUB_CODE_NEW,',
'       GL_ACCOUNT_NEW,',
'       ACTIVITY_NEW,',
'       FUTURE1_NEW,',
'       FUTURE2_NEW,',
'       ALLOCATED_BUDGET,',
'       BUDGET,',
'       ENCUMBERANCE,',
'       ACTUAL,',
'       nvl(JAN,0)  JAN ,',
'       nvl(FEB,0)   FEB,',
'       nvl(MAR,0)   MAR,',
'       nvl(APR,0)   APR,',
'       nvl(MAY,0)   MAY,',
'       nvl(JUN,0)   JUN,',
'       nvl(JUL,0)   JUL,',
'       nvl(AUG,0)   AUG,',
'       nvl(SEP,0)   SEP,',
'       nvl(OCT,0)   OCT,',
'       nvl(NOV,0)   NOV,',
'       nvl(DEC,0)   DEC,',
'       LINE_TYPE,',
'       TOTAL_CF,',
'       NOTE,',
'       STATUS,',
'       FINAL_STATUS_ON,',
'       SOURCE,',
'       REQUEST_ID,',
'       REQUEST_LINE_ID,',
'       INITIATIVE_ID,',
'       INITIATIVE_NEW_NAME,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       TOTAL_CF_FORMAT',
'  from CASHFLOW_LINES',
'  where SOURCE = ''DP''',
'and REQUEST_ID = :P90_ITEM_ID;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P90_ITEM_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Cashflow Details Report'
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
 p_id=>wwv_flow_api.id(94550628028821274)
,p_max_row_count=>'1000000'
,p_allow_save_rpt_public=>'Y'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_rows_per_page=>'N'
,p_show_filter=>'N'
,p_show_control_break=>'N'
,p_show_flashback=>'N'
,p_show_reset=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:74:&SESSION.::&DEBUG.::P74_ITEM_ID:&P11_ITEM_ID.'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P11_REVIEW_STATUS in (''Draft'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>307834660418005906
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58543686825454845)
,p_db_column_name=>'LINE_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Line Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58542895863454840)
,p_db_column_name=>'ACCOUNTING_YEAR'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Budget Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58542125026454840)
,p_db_column_name=>'DISTRIBUTION_DATE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Distribution Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58541651522454839)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58541262733454839)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58540832999454839)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58540524132454839)
,p_db_column_name=>'PROJECT_NAME_NEW'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'New Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58540080898454838)
,p_db_column_name=>'TASK_NUMBER_NEW'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'New Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58539660790454838)
,p_db_column_name=>'EXPENDITURE_TYPE_NEW'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'New Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58539294043454838)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58538854899454838)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58538513378454838)
,p_db_column_name=>'BUDGET_GROUB_CODE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Budget Groub Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58538117241454837)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'GL Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58537657959454837)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58537297488454837)
,p_db_column_name=>'FUTURE1'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58536848655454837)
,p_db_column_name=>'FUTURE2'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58536527068454837)
,p_db_column_name=>'ENTITY_CODE_NEW'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'New Entity Code'
,p_column_type=>'STRING'
,p_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_display_condition=>'P90_PROJECT_NEW_YN'
,p_display_condition2=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58536047668454836)
,p_db_column_name=>'COST_CENTER_NEW'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'New Cost Center'
,p_column_type=>'STRING'
,p_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_display_condition=>'P90_PROJECT_NEW_YN'
,p_display_condition2=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58535645100454836)
,p_db_column_name=>'BUDGET_GROUB_CODE_NEW'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'New Budget Group Code'
,p_column_type=>'STRING'
,p_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_display_condition=>'P90_PROJECT_NEW_YN'
,p_display_condition2=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58535307008454836)
,p_db_column_name=>'GL_ACCOUNT_NEW'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'New GL Account'
,p_column_type=>'STRING'
,p_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_display_condition=>'P90_PROJECT_NEW_YN'
,p_display_condition2=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58534845359454836)
,p_db_column_name=>'ACTIVITY_NEW'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'New Activity'
,p_column_type=>'STRING'
,p_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_display_condition=>'P90_PROJECT_NEW_YN'
,p_display_condition2=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58534491228454835)
,p_db_column_name=>'FUTURE1_NEW'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'New Future1'
,p_column_type=>'STRING'
,p_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_display_condition=>'P90_PROJECT_NEW_YN'
,p_display_condition2=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58534128712454835)
,p_db_column_name=>'FUTURE2_NEW'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'New Future2'
,p_column_type=>'STRING'
,p_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_display_condition=>'P90_PROJECT_NEW_YN'
,p_display_condition2=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58532128605454834)
,p_db_column_name=>'JAN'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'01-&P90_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58531672205454834)
,p_db_column_name=>'FEB'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'02-&P90_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58531310416454834)
,p_db_column_name=>'MAR'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'03-&P90_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58530845823454833)
,p_db_column_name=>'APR'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'04-&P90_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58530481370454833)
,p_db_column_name=>'MAY'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'05-&P90_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58530115176454833)
,p_db_column_name=>'JUN'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'06-&P90_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58529714373454829)
,p_db_column_name=>'JUL'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'07-&P90_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58529237168454829)
,p_db_column_name=>'AUG'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'08-&P90_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58528909813454829)
,p_db_column_name=>'SEP'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'09-&P90_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58528450478454828)
,p_db_column_name=>'OCT'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'10-&P90_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58528042421454828)
,p_db_column_name=>'NOV'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'11-&P90_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58527699944454828)
,p_db_column_name=>'DEC'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'12-&P90_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58526493915454827)
,p_db_column_name=>'NOTE'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Note'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58526110045454827)
,p_db_column_name=>'STATUS'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58523379602454826)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>520
,p_column_identifier=>'AZ'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58523022627454825)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>530
,p_column_identifier=>'BA'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58522608491454825)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>540
,p_column_identifier=>'BB'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58522187105454825)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>550
,p_column_identifier=>'BC'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58521787074454825)
,p_db_column_name=>'TOTAL_CF_FORMAT'
,p_display_order=>560
,p_column_identifier=>'BD'
,p_column_label=>'Total Cf Format'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58524227027454826)
,p_db_column_name=>'INITIATIVE_ID'
,p_display_order=>570
,p_column_identifier=>'AX'
,p_column_label=>'Initiative Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58523802098454826)
,p_db_column_name=>'INITIATIVE_NEW_NAME'
,p_display_order=>580
,p_column_identifier=>'AY'
,p_column_label=>'Initiative New Name'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58526916132454828)
,p_db_column_name=>'TOTAL_CF'
,p_display_order=>590
,p_column_identifier=>'AQ'
,p_column_label=>'Total Cf'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58525716232454827)
,p_db_column_name=>'FINAL_STATUS_ON'
,p_display_order=>600
,p_column_identifier=>'AT'
,p_column_label=>'Final Status On'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58527257145454828)
,p_db_column_name=>'LINE_TYPE'
,p_display_order=>610
,p_column_identifier=>'AP'
,p_column_label=>'Line Type'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58533267453454835)
,p_db_column_name=>'BUDGET'
,p_display_order=>620
,p_column_identifier=>'AA'
,p_column_label=>'Budget'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58532863392454835)
,p_db_column_name=>'ENCUMBERANCE'
,p_display_order=>630
,p_column_identifier=>'AB'
,p_column_label=>'Encumberance'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58532506863454834)
,p_db_column_name=>'ACTUAL'
,p_display_order=>640
,p_column_identifier=>'AC'
,p_column_label=>'Actual'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58533731238454835)
,p_db_column_name=>'ALLOCATED_BUDGET'
,p_display_order=>650
,p_column_identifier=>'Z'
,p_column_label=>'Allocated Budget'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58525306135454827)
,p_db_column_name=>'SOURCE'
,p_display_order=>660
,p_column_identifier=>'AU'
,p_column_label=>'Source'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58543298446454840)
,p_db_column_name=>'BUDGET_ALLOCATION_PLAN_ID'
,p_display_order=>670
,p_column_identifier=>'B'
,p_column_label=>'Budget Allocation Plan Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58542435897454840)
,p_db_column_name=>'MULTI_YEAR_YN'
,p_display_order=>680
,p_column_identifier=>'D'
,p_column_label=>'Multi Year Yn'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58524584640454826)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>690
,p_column_identifier=>'AV'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58521397607454825)
,p_db_column_name=>'REQUEST_LINE_ID'
,p_display_order=>700
,p_column_identifier=>'BE'
,p_column_label=>'Request Line Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(94866921975853502)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1547630'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'JAN:FEB:MAR:APR:MAY:JUN:JUL:AUG:SEP:OCT:NOV:DEC:APXWS_CC_001:'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(58520547579454821)
,p_report_id=>wwv_flow_api.id(94866921975853502)
,p_db_column_name=>'APXWS_CC_001'
,p_column_identifier=>'C01'
,p_computation_expr=>'AD + AE + AF + AG + AH + AI + AJ + AK + AL + AM + AN + AO'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Total'
,p_report_label=>'Total'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(58519852748454819)
,p_button_sequence=>80
,p_button_plug_id=>wwv_flow_api.id(93578633867600667)
,p_button_name=>'Cashflow'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Cashflow'
,p_button_position=>'BODY'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count number;',
'begin',
'',
'select nvl(count(*) , 0)',
'into l_count',
'from cashflow_lines',
'where SOURCE = ''DP''',
'and REQUEST_ID = :P90_ITEM_ID;',
'',
'if (:P90_ESTIMATED_BUDGET is not null and l_count = 0 and :PERSON_ID = 680461)',
'    Then ',
'        return true;',
'    else',
'        return false;',
'end if;',
'',
'end;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_button_css_classes=>' class="t-Button t-Button--icon t-Button--success t-Button--iconLeft"'
,p_icon_css_classes=>'fa-money'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(58512127004454813)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(214301164830273140)
,p_button_name=>'New_document'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'New Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(58496931598454802)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(214689659445608709)
,p_button_name=>'AddComment'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Collaborate'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:17:&SESSION.::&DEBUG.::P17_ITEM_ID:&P90_ITEM_ID.'
,p_icon_css_classes=>'fa-envelope-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(58487497736454795)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(214299365399273143)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:&P90_PAGE_FROM.:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(58466086109454777)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(85569878277515386)
,p_button_name=>'Add'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Add Participant'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:59:&SESSION.::&DEBUG.::P59_ITEM_ID:&P90_ITEM_ID.'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(58489522666454796)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(214299365399273143)
,p_button_name=>'Scoping_Document'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Scoping Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P90_DP_SCOPING_ID is not null     and ',
':P90_APPROVAL_STATUS = ''Approved''  and',
'nvl(:P90_ESTIMATED_BUDGET_H,0) > 50000'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-file-word-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(58487115154454795)
,p_button_sequence=>80
,p_button_plug_id=>wwv_flow_api.id(214299365399273143)
,p_button_name=>'Create_Version'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Create Version'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-copy'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(58483974457454792)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(214299935171273141)
,p_button_name=>'Edit_Header'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--link'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Edit Header'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.::P10_ITEM_ID,P10_CHANGED:&P90_ITEM_ID.,N'
,p_button_condition=>':P90_REVIEW_STATUS in (''Draft'' , ''Withdraw'' , ''Return'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-pencil'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(58426852767454749)
,p_branch_name=>'GO TO Confirmation 13'
,p_branch_action=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.:13:P13_REVIEW_STATUS,P13_REQUEST_ID:&P11_REVIEW_STATUS.,&P11_ITEM_ID_H.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(58427274950454749)
,p_branch_name=>'Go To Cashflow - 73'
,p_branch_action=>'f?p=&APP_ID.:74:&SESSION.::&DEBUG.:74:P74_ITEM_ID:&P11_ITEM_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(58519852748454819)
,p_branch_sequence=>20
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(58426057273454749)
,p_branch_name=>'Go to Scoping document 28'
,p_branch_action=>'f?p=&APP_ID.:28:&SESSION.::&DEBUG.::P28_SCOPE_ID:&P11_DP_SCOPING_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(58489522666454796)
,p_branch_sequence=>30
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(58426469300454749)
,p_branch_name=>'Go to scoping confirmation 27'
,p_branch_action=>'f?p=&APP_ID.:27:&SESSION.::&DEBUG.::P27_ITEM_ID_H,P27_SCOPING_ID,P27_TEMPLATE,P27_TEMPLATE_ID:&P11_ITEM_ID.,&P11_DP_SCOPING_ID.,&P11_TEMPLATE.,&P11_TEMPLATE_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>40
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(58425636044454749)
,p_branch_name=>'Go to 11'
,p_branch_action=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.::P11_ITEM_ID:&P11_ITEM_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>50
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(58425316540454748)
,p_branch_name=>'Go to 14'
,p_branch_action=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.:14:P14_DP_ITEMS_ID,P14_PAGE_FROM,P14_REVIEW_STATUS:&P11_ITEM_ID.,11,&P11_REVIEW_STATUS.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(58512127004454813)
,p_branch_sequence=>60
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58519491201454819)
,p_name=>'P90_ESTIMATED_DATE_DEFINE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(93578633867600667)
,p_item_default=>'N'
,p_prompt=>'Estimated Date Define ?'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58519083676454818)
,p_name=>'P90_ESTIMATED_DATE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(93578633867600667)
,p_prompt=>'Project Delivery Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58518688984454817)
,p_name=>'P90_ESTIMATED_MONTH'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(93578633867600667)
,p_prompt=>'Estimated Month'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58518270045454817)
,p_name=>'P90_ESTIMATED_QUARTER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(93578633867600667)
,p_prompt=>'Estimated Quarter'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:1;1,2;2,3;3,4;4'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58517915569454817)
,p_name=>'P90_ESTIMATED_YEAR'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(93578633867600667)
,p_prompt=>'Estimated Year'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:2022;2022,2023;2023,2024;2024,2025;2025,2026;2026,2027;2027,2028;2028,2029;2029,2030;2030'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58517487391454817)
,p_name=>'P90_ESTIMATED_BUDGET_DEFINE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(93578633867600667)
,p_prompt=>'Estimated Budget Define ?'
,p_display_as=>'NATIVE_YES_NO'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58517124957454817)
,p_name=>'P90_ESTIMATED_BUDGET'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(93578633867600667)
,p_prompt=>'Estimated Budget'
,p_post_element_text=>'<p>&nbsp; AED</p>'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_colspan=>8
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58516710900454816)
,p_name=>'P90_ESTIMATED_BUDGET_H'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(93578633867600667)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58516267341454816)
,p_name=>'P90_TOTAL_PROJECT_BUDGET'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(93578633867600667)
,p_prompt=>'Total Project Budget'
,p_post_element_text=>'<p>&nbsp; AED</p>'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58515842069454816)
,p_name=>'P90_TOTAL_PROJECT_BUDGET_H'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(93578633867600667)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58515474165454816)
,p_name=>'P90_TASK_NEW_YN'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(93578633867600667)
,p_item_default=>'N'
,p_prompt=>'New Task ?'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>4
,p_display_when=>'P90_PROJECT_NEW_YN'
,p_display_when2=>'N'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58515070478454816)
,p_name=>'P90_TASK_NUMBER'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(93578633867600667)
,p_prompt=>'Task'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'TASKS BY PROJECT NUMBER PAGE11'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select TASK_NUMBER  Task, TASK_DESCRIPTION, COST_CENTER, FUTURE2',
'from tasks_all_v',
'where project_number = :P11_PROJECT_NUMBER_H ;'))
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_grid_label_column_span=>4
,p_display_when=>':P90_PROJECT_NEW_YN = ''N'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58514660889454815)
,p_name=>'P90_TASK_NUMBER_NEW'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(93578633867600667)
,p_prompt=>'New Task'
,p_display_as=>'NATIVE_AUTO_COMPLETE'
,p_named_lov=>'TASKS ALL (SAMPLE)'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct TASK_NUMBER d, TASK_NUMBER R',
'from tasks_all_v',
'where task_number not like ''?%''',
'order by 1;'))
,p_cSize=>30
,p_cMaxlength=>25
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_inline_help_text=>'Max 25 Character.'
,p_attribute_01=>'CONTAINS_IGNORE'
,p_attribute_04=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58514236814454815)
,p_name=>'P90_EXPENDITURE_TYPE'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(93578633867600667)
,p_prompt=>'Expenditure Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'EXPENDITURE TYPES BY PAGE 11'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select EXPENDITURE_TYPE, DESCRIPTION, GL_ACCOUNT, GL_ACCOUNT_NAME',
'from expenditures_v',
'where project_number = :P11_PROJECT_NUMBER_H',
'and TASK_NUMBER = :P11_TASK_NUMBER ;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P90_TASK_NUMBER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_grid_label_column_span=>4
,p_display_when=>':P90_PROJECT_NEW_YN = ''N'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58513913287454814)
,p_name=>'P90_EXPENDITURE_TYPE_NEW'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(93578633867600667)
,p_prompt=>'New Expenditure Type'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EXPENDITURES ALL'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct EXPENDITURE_TYPE d, EXPENDITURE_TYPE r',
'from expenditures_v',
'order by 1'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58513186840454813)
,p_name=>'P90_ESTIMATED'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(93578746010600668)
,p_prompt=>'Estimated Quarter-Year'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58512758154454813)
,p_name=>'P90_ESTIMATED_BUDGET_BRACKET_ID'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(93578746010600668)
,p_prompt=>'Estimated Budget Bracket'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'ESTIMATED BUDGET BRACKET LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  BRACKET_NAME , BRACKET_ID',
'from dp_budget_brackets',
'where status = ''A''',
'order by MIN_VALUE'))
,p_grid_label_column_span=>4
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'1'
,p_attribute_02=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58486653516454795)
,p_name=>'P90_PAGE_FROM'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(214299365399273143)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58486281441454794)
,p_name=>'P90_ITEM_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(214299365399273143)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58485923665454794)
,p_name=>'P90_ITEM_ID_H'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(214299365399273143)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58485433525454794)
,p_name=>'P90_DP_SCOPING_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(214299365399273143)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58482985463454790)
,p_name=>'P90_PLANNING_STATUS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(214578128931298422)
,p_prompt=>'Planning Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'DP ITEM PLANNING STATUS'
,p_lov=>'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 48 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10);'
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58482607659454790)
,p_name=>'P90_REVIEW_STATUS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(214578128931298422)
,p_prompt=>'Review Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58482207234454789)
,p_name=>'P90_REVIEW_REJECT_REASON'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(214578128931298422)
,p_prompt=>'Review Comment'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P90_REVIEW_STATUS'
,p_display_when2=>'Not Accepted'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58481832310454789)
,p_name=>'P90_APPROVAL_STATUS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(214578128931298422)
,p_prompt=>'Approval Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58481332816454789)
,p_name=>'P90_CUTT_OFF_DATE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(214578128931298422)
,p_prompt=>'Cut Off Date'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58481024120454789)
,p_name=>'P90_SLA_DAYS'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(214578128931298422)
,p_prompt=>'Total SLA Days'
,p_post_element_text=>'<b>&nbsp; days</b>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P90_SLA_DAYS'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Total SLA days is ....'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58480083218454788)
,p_name=>'P90_SLA_DATE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(214578128931298422)
,p_prompt=>'SLA Date'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P90_SLA_DATE'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'SLA date is ....'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58478909464454787)
,p_name=>'P90_CREATED_BY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(214300708552273140)
,p_prompt=>'Created By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58478488942454787)
,p_name=>'P90_CREATED_ON'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(214300708552273140)
,p_prompt=>'Created On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58478102815454787)
,p_name=>'P90_UPDATED_BY'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(214300708552273140)
,p_prompt=>'Updated By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58477714617454787)
,p_name=>'P90_UPDATED_ON'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(214300708552273140)
,p_prompt=>'Updated On'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58476944405454786)
,p_name=>'P90_DP_ITEM_CODE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(214577855099298419)
,p_prompt=>'DP Item Code'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58476614914454783)
,p_name=>'P90_DP_ITEM_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(214577855099298419)
,p_prompt=>'Demand Plan Item Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58476195452454783)
,p_name=>'P90_INITIATIVE_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(214577855099298419)
,p_prompt=>'Initiative'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'INITIATIVES POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select INITIATIVE_ID, INITIATIVE_CODE, INITIATIVE_NAME, ',
'    decode(INITIATIVE_TYPE, ''S'' , ''Strategic'' , ''N'', ''Non-Strategic'') INITIATIVE_TYPE',
'from strategic_initiatives;'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58475775690454783)
,p_name=>'P90_INITIATIVE_NEW_NAME'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(214577855099298419)
,p_prompt=>'New  Initiative Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58475430191454783)
,p_name=>'P90_INITIATIVE_NEW_YN'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(214577855099298419)
,p_prompt=>'New Initiative ?'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(782922329120916)||'.'
,p_begin_on_new_line=>'N'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58474965648454782)
,p_name=>'P90_PROJECT_NUMBER'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(214577855099298419)
,p_prompt=>'Project'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'OPERATIONAL PROJECTS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PROJECT_NUMBER || '' - '' || PROJECT_NAME  PROJECT_NAME , project_number ',
'from project',
'where PROJECT_TYPE = ''Operational'''))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58474603262454782)
,p_name=>'P90_PROJECT_NUMBER_H'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(214577855099298419)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58474215356454782)
,p_name=>'P90_PROJECT_NEW_YN'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(214577855099298419)
,p_prompt=>'New Project ?'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(782922329120916)||'.'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58473800739454782)
,p_name=>'P90_PROJECT_NEW_NAME'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(214577855099298419)
,p_prompt=>'New Project Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58473409246454782)
,p_name=>'P90_MAIN_CATEGORY_ID'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(214577855099298419)
,p_prompt=>'Main Category'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ITEM MAIN CATEGORIES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CATEGORY_NAME , CATEGORY_ID',
'from dp_item_categories',
'where ORDER_LEVEL = 231 ;'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58472966060454781)
,p_name=>'P90_CONTRACT_NO'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(214577855099298419)
,p_prompt=>'Contract No'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>'P90_CONTRACT_NO'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58472580150454781)
,p_name=>'P90_CATEGORY_ID'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(214577855099298419)
,p_prompt=>'Category'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ITEM CATEGORY  LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CATEGORY_NAME , CATEGORY_ID',
'from dp_item_categories',
'where ORDER_LEVEL = 232 ;'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58472227956454781)
,p_name=>'P90_DP_ITEM_TYPE_ID'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(214577855099298419)
,p_prompt=>'DP Item Type'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'DP ITEM TYPES LOV'
,p_lov=>'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 45 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10)'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58471769315454781)
,p_name=>'P90_SUB_CATEGORY_ID'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(214577855099298419)
,p_prompt=>'Sub-Category'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ITEM SUB CATEGORIES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CATEGORY_NAME , CATEGORY_ID',
'from dp_item_categories',
'where ORDER_LEVEL = 233 ;'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58471338620454781)
,p_name=>'P90_RISK_ID'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(214577855099298419)
,p_prompt=>'Risk'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'DP RISK LEVEL LOV'
,p_lov=>'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 46 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10);'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58471031673454780)
,p_name=>'P90_COST_CENTER'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(214577855099298419)
,p_prompt=>'Cost Center'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58470623806454780)
,p_name=>'P90_PRIORITY_ID'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(214577855099298419)
,p_prompt=>'Priority'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'PRIORITY LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id',
'from dct_lookup_values',
'where lookup_id = (Select x.lookup_id',
'                    from dct_lookups x',
'                    where x.LOOKUP_CODE = ''PRIORITY'');'))
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58470189511454780)
,p_name=>'P90_END_USER_ID'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(214577855099298419)
,p_prompt=>'End User'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58469790278454780)
,p_name=>'P90_DP_PROCUREMENT_METHOD'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(214577855099298419)
,p_prompt=>'Procurement Method'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'DP PROCUREMENT METHOD'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
' select TENDER_TYPE , ID',
' from DP_PROCUREMENT_METHOD',
' where status = ''A''',
' and sysdate between nvl(start_date , sysdate - 10)',
'                and nvl(End_date , sysdate + 10)',
' '))
,p_begin_on_new_line=>'N'
,p_display_when=>'P90_DP_PROCUREMENT_METHOD'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58469423203454780)
,p_name=>'P90_SECTOR_ID'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(214577855099298419)
,p_prompt=>'Sector'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'SECTORS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  NVL(SECTOR_NAME_USER , SECTOR_NAME) Name , SECTOR_ID',
'from dct_hr_sectors_v'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58469022076454779)
,p_name=>'P90_DEPARTMENT_ID'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(214577855099298419)
,p_prompt=>'Department'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ORGANIZATION NAME RETURN ORG_ID'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58468624856454779)
,p_name=>'P90_PROJECT_DESCRIPTION'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(214577855099298419)
,p_prompt=>'Project Description'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58468137463454779)
,p_name=>'P90_NOTES'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(214577855099298419)
,p_prompt=>'Notes'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>2
,p_read_only_when=>':P90_ITEM_ID is not null and :P90_REVIEW_STATUS not in (''Draft'',''Withdraw'' , ''Return'')'
,p_read_only_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(58457203584454768)
,p_validation_name=>'Check Budget'
,p_validation_sequence=>10
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'if :P90_ESTIMATED_BUDGET_DEFINE = ''Y'' and ',
'    :P90_ESTIMATED_BUDGET is null',
'    ',
'    Then',
'        return false;',
'      else',
'          return true;',
' end if;',
' end;'))
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'If The estimated Budget defined, Please enter it.'
,p_associated_item=>wwv_flow_api.id(58517487391454817)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(58457610967454768)
,p_validation_name=>'check Estimated Date '
,p_validation_sequence=>20
,p_validation=>' (:P90_ESTIMATED_DATE is not Null) or (:P90_ESTIMATED_QUARTER is not null and :P90_ESTIMATED_YEAR is not null)'
,p_validation_type=>'PLSQL_EXPRESSION'
,p_error_message=>'Please enter the estimated date'
,p_associated_item=>wwv_flow_api.id(58519083676454818)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(58458749694454769)
,p_validation_name=>'check Budget Required'
,p_validation_sequence=>30
,p_validation=>' :P90_ESTIMATED_BUDGET is not Null'
,p_validation_type=>'PLSQL_EXPRESSION'
,p_error_message=>'Please enter the estimated date'
,p_associated_item=>wwv_flow_api.id(58517124957454817)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(58458415845454769)
,p_validation_name=>'check New Task required'
,p_validation_sequence=>40
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(:P90_TASK_NEW_YN = ''Y'' and :P90_TASK_NUMBER_NEW is not Null) or ',
':P90_PROJECT_NEW_YN = ''Y'' or',
':P90_TASK_NEW_YN = ''N'''))
,p_validation_type=>'PLSQL_EXPRESSION'
,p_error_message=>'Please enter the new task'
,p_associated_item=>wwv_flow_api.id(58514660889454815)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(58457935179454768)
,p_validation_name=>'Check Cashflow Allocation process'
,p_validation_sequence=>50
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count       number;',
'l_allocate    number;',
'',
'begin',
'-- check allocation amount',
'',
'    select count(*)',
'    into l_count',
'    from cashflow_lines',
'    where source = ''DP''',
'    and request_id = :P90_ITEM_ID;',
'',
'if l_count > 0',
'    Then',
'                        select nvl(jan,0) +',
'                               nvl(FEB,0) +',
'                               nvl(MAR,0) +',
'                               nvl(APR,0) +',
'                               nvl(MAY,0) +',
'                               nvl(JUN,0) +',
'                               nvl(JUL,0) +',
'                               nvl(AUG,0) +',
'                               nvl(SEP,0) +',
'                               nvl(OCT,0) +',
'                               nvl(NOV,0) +',
'                               nvl(DEC,0)',
'                        into',
'                             l_allocate',
'                        from cashflow_lines',
'                        where source = ''DP''',
'                        and request_id = :P90_ITEM_ID;',
'    else',
'        l_allocate :=  0;',
'end if;',
'',
'-- ',
'if :P90_ESTIMATED_BUDGET_H = l_allocate and l_allocate != 0',
'    Then',
'        return true;',
'    else',
'        return false;',
'end if;',
'end;'))
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'Please enter the cashflow details to allocate the estimated budget.'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(58446454179454759)
,p_name=>'New Project DA'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P90_PROJECT_NEW_YN'
,p_condition_element=>'P90_PROJECT_NEW_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'N'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58445938719454758)
,p_event_id=>wwv_flow_api.id(58446454179454759)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_PROJECT_NEW_NAME'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58445472281454758)
,p_event_id=>wwv_flow_api.id(58446454179454759)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_PROJECT_NEW_NAME'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58444965324454758)
,p_event_id=>wwv_flow_api.id(58446454179454759)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_PROJECT_NUMBER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58444520640454758)
,p_event_id=>wwv_flow_api.id(58446454179454759)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_PROJECT_NUMBER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(58444114431454758)
,p_name=>'ESTIMATED_BUDGET DA'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P90_ESTIMATED_BUDGET'
,p_condition_element=>'P90_ESTIMATED_BUDGET'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58443561841454757)
,p_event_id=>wwv_flow_api.id(58444114431454758)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_ESTIMATED_BUDGET_H'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>'to_number(replace(nvl(:P90_ESTIMATED_BUDGET,0),'','',''''))'
,p_attribute_07=>'P90_ESTIMATED_BUDGET'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58442627624454757)
,p_event_id=>wwv_flow_api.id(58444114431454758)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_ESTIMATED_BUDGET_BRACKET_ID'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58442114359454756)
,p_event_id=>wwv_flow_api.id(58444114431454758)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_ESTIMATED_BUDGET_BRACKET_ID'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  BRACKET_ID',
'from dp_budget_brackets',
'where to_number(replace(nvl(:P90_ESTIMATED_BUDGET,0),'','','''')) between MIN_VALUE and  MAX_VALUE'))
,p_attribute_07=>'P90_ESTIMATED_BUDGET,P90_ESTIMATED_BUDGET_H'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58443065523454757)
,p_event_id=>wwv_flow_api.id(58444114431454758)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(58519852748454819)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(58438782933454755)
,p_name=>'ESTIMATED_DATE_DEFINE DA'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P90_ESTIMATED_DATE_DEFINE'
,p_condition_element=>'P90_ESTIMATED_DATE_DEFINE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'N'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58436734268454754)
,p_event_id=>wwv_flow_api.id(58438782933454755)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_ESTIMATED_DATE,P90_ESTIMATED'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58436232711454754)
,p_event_id=>wwv_flow_api.id(58438782933454755)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_ESTIMATED_DATE'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58438294449454755)
,p_event_id=>wwv_flow_api.id(58438782933454755)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_ESTIMATED_QUARTER,P90_ESTIMATED_YEAR'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58435757253454754)
,p_event_id=>wwv_flow_api.id(58438782933454755)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_ESTIMATED_DATE,P90_ESTIMATED'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58437803941454754)
,p_event_id=>wwv_flow_api.id(58438782933454755)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_ESTIMATED_QUARTER,P90_ESTIMATED_YEAR'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58437279044454754)
,p_event_id=>wwv_flow_api.id(58438782933454755)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_ESTIMATED_QUARTER,P90_ESTIMATED_YEAR'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(58435381247454753)
,p_name=>'get Quarter DA'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P90_ESTIMATED_DATE'
,p_condition_element=>'P90_ESTIMATED_DATE'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58434849932454753)
,p_event_id=>wwv_flow_api.id(58435381247454753)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_ESTIMATED'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Q'' || trim(to_char(to_date(:P90_ESTIMATED_DATE, ''dd-Mon-YYYY'' ) , ''Q''))',
'           || ''-'' ||',
'           trim(to_char(to_date(:P90_ESTIMATED_DATE, ''dd-Mon-YYYY'' ) , ''YYYY''))',
'           as xx',
'from dual;'))
,p_attribute_07=>'P90_ESTIMATED_DATE'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(58434484995454753)
,p_name=>'Budget Not Define DA'
,p_event_sequence=>60
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P90_ESTIMATED_BUDGET_DEFINE'
,p_condition_element=>'P90_ESTIMATED_BUDGET_DEFINE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'N'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58433988057454753)
,p_event_id=>wwv_flow_api.id(58434484995454753)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_ESTIMATED_BUDGET'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58433502108454753)
,p_event_id=>wwv_flow_api.id(58434484995454753)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_ESTIMATED_BUDGET'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58433012427454752)
,p_event_id=>wwv_flow_api.id(58434484995454753)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_ESTIMATED_BUDGET'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(58432535380454752)
,p_name=>'Dialog Close'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(58496931598454802)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58432061771454752)
,p_event_id=>wwv_flow_api.id(58432535380454752)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(214689827679608711)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(58431682977454752)
,p_name=>'Dialog Close 2'
,p_event_sequence=>80
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(214689827679608711)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58431208638454752)
,p_event_id=>wwv_flow_api.id(58431682977454752)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(214689827679608711)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(58430776762454751)
,p_name=>'Initiative DA'
,p_event_sequence=>90
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P90_INITIATIVE_NEW_YN'
,p_condition_element=>'P90_INITIATIVE_NEW_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'No'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
,p_display_when_type=>'NEVER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58430236162454751)
,p_event_id=>wwv_flow_api.id(58430776762454751)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_INITIATIVE_ID'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58429826264454751)
,p_event_id=>wwv_flow_api.id(58430776762454751)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_INITIATIVE_NEW_NAME'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58429241875454751)
,p_event_id=>wwv_flow_api.id(58430776762454751)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_INITIATIVE_ID'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58428799123454751)
,p_event_id=>wwv_flow_api.id(58430776762454751)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_INITIATIVE_NEW_NAME'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58428327015454750)
,p_event_id=>wwv_flow_api.id(58430776762454751)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_INITIATIVE_ID'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58427796991454750)
,p_event_id=>wwv_flow_api.id(58430776762454751)
,p_event_result=>'FALSE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_INITIATIVE_NEW_NAME'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(58454377809454763)
,p_name=>'Close DA'
,p_event_sequence=>100
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(58466086109454777)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58453894951454762)
,p_event_id=>wwv_flow_api.id(58454377809454763)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(85570016353515387)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(58453511183454762)
,p_name=>'Close2 DA'
,p_event_sequence=>110
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(85570016353515387)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58452991628454762)
,p_event_id=>wwv_flow_api.id(58453511183454762)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(85570016353515387)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(58452588753454762)
,p_name=>'ITEM LOSES FOCUS'
,p_event_sequence=>120
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(214963043358685404)
,p_bind_type=>'bind'
,p_bind_event_type=>'focusout'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58452103579454761)
,p_event_id=>wwv_flow_api.id(58452588753454762)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_REMOVE_CLASS'
,p_affected_elements_type=>'EVENT_SOURCE'
,p_attribute_01=>'showfocus'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(58451661580454761)
,p_name=>'etFOCU'
,p_event_sequence=>130
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(214963043358685404)
,p_bind_type=>'bind'
,p_bind_event_type=>'focusin'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58451182426454761)
,p_event_id=>wwv_flow_api.id(58451661580454761)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ADD_CLASS'
,p_affected_elements_type=>'EVENT_SOURCE'
,p_attribute_01=>'showfocus'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(58455331816454764)
,p_name=>'Total Project Budget DA'
,p_event_sequence=>140
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P90_TOTAL_PROJECT_BUDGET'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58454742874454763)
,p_event_id=>wwv_flow_api.id(58455331816454764)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_TOTAL_PROJECT_BUDGET_H'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>'to_number(replace(nvl(:P90_TOTAL_PROJECT_BUDGET,0),'','',''''))'
,p_attribute_07=>'P90_TOTAL_PROJECT_BUDGET'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(58450789679454761)
,p_name=>'New Task YN Changes'
,p_event_sequence=>150
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P90_TASK_NEW_YN'
,p_condition_element=>'P90_TASK_NEW_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58449763172454760)
,p_event_id=>wwv_flow_api.id(58450789679454761)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_TASK_NUMBER,P90_EXPENDITURE_TYPE'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58447770760454759)
,p_event_id=>wwv_flow_api.id(58450789679454761)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_TASK_NUMBER_NEW,P90_EXPENDITURE_TYPE_NEW'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58450237083454760)
,p_event_id=>wwv_flow_api.id(58450789679454761)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_TASK_NUMBER_NEW,P90_EXPENDITURE_TYPE_NEW'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58448294844454760)
,p_event_id=>wwv_flow_api.id(58450789679454761)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_TASK_NUMBER_NEW,P90_EXPENDITURE_TYPE_NEW'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58449272718454760)
,p_event_id=>wwv_flow_api.id(58450789679454761)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_TASK_NUMBER,P90_EXPENDITURE_TYPE'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58448740570454760)
,p_event_id=>wwv_flow_api.id(58450789679454761)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P90_TASK_NUMBER,P90_EXPENDITURE_TYPE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(58447376075454759)
,p_name=>'Task Number Changed DA'
,p_event_sequence=>160
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P90_EXPENDITURE_TYPE'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58446856929454759)
,p_event_id=>wwv_flow_api.id(58447376075454759)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count    number;',
'begin',
'',
'select nvl(count(*),0)',
'into l_count',
'from cashflow_lines',
'where source = ''DP''',
'and request_id = :P90_ITEM_ID;',
'',
'if l_count > 0',
'then',
'        update cashflow_lines',
'        set cost_center = PROJECTS_UTIL.task_cost_center(:P90_PROJECT_NUMBER, :P90_TASK_NUMBER),',
'            BUDGET_GROUB_CODE = PROJECTS_UTIL.task_budget_code(:P90_PROJECT_NUMBER, :P90_TASK_NUMBER),',
'            GL_ACCOUNT = PROJECTS_UTIL.expenditure_type_gl_account(:P90_PROJECT_NUMBER, :P90_TASK_NUMBER, :P90_EXPENDITURE_TYPE),',
'            activity = PROJECTS_UTIL.task_activity(:P90_PROJECT_NUMBER, :P90_TASK_NUMBER),',
'            future1  = PROJECTS_UTIL.task_future1(:P90_PROJECT_NUMBER, :P90_TASK_NUMBER),',
'            future2  = PROJECTS_UTIL.task_future2(:P90_PROJECT_NUMBER, :P90_TASK_NUMBER),',
'            entity_code = ''451'',',
'            task_number = :P90_TASK_NUMBER,',
'            expenditure_type = :P90_EXPENDITURE_TYPE',
'        where source = ''DP''',
'        and request_id = :P90_ITEM_ID;',
'',
'end if;',
'',
'end;'))
,p_attribute_02=>'P90_ITEM_ID,P90_PROJECT_NUMBER,P90_TASK_NUMBER,P90_EXPENDITURE_TYPE'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(58456516364454766)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialize DP Item Details'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    DP_ITEM_CODE,',
'    ITEM_ID,',
'    ITEM_ID item_id_h,',
'  --  DP_ITEM_NAME,',
'  --  INITIATIVE_NEW_YN,',
'    INITIATIVE_ID,',
'  --  INITIATIVE_NEW_NAME,',
'    decode(PROJECT_NEW_YN , ''N'' , PROJECT_NUMBER, ''Y'' ,PROJECT_NEW_NAME)	,',
'    PROJECT_NUMBER,',
'    PROJECT_NEW_YN,',
'    PROJECT_NEW_NAME,',
'    PROJECT_DESCRIPTION,',
'    main_category_id,',
'    CATEGORY_ID,',
'    SUB_CATEGORY_ID,',
'    END_USER_ID,',
'    SECTOR_ID,',
'    DEPARTMENT_ID,',
'    COST_CENTER,',
'    DP_ITEM_TYPE_ID,',
'    CONTRACT_NO,',
'    RISK_ID,',
'    PRIORITY_ID,',
'    DP_PROCUREMENT_METHOD,',
'    PLANNING_STATUS,',
'    REVIEW_STATUS,',
'    APPROVAL_STATUS,',
'    to_char(CUTT_OFF_DATE,''dd-Mon-YYYY''),',
'    CREATED_BY,',
'    to_char(CREATED_ON,''DD-MON-YYYY HH:MIPM''),',
'    UPDATED_BY,',
'    to_char(UPDATED_ON,''DD-MON-YYYY HH:MIPM''),',
'    to_char(ESTIMATED_DATE,''DD-MON-YYYY''),',
'    ESTIMATED_YEAR,',
'    ESTIMATED_QUARTER,',
'    trim(to_char(ESTIMATED_BUDGET,''99,999,999,999.99''))     ESTIMATED_BUDGET,',
'    ESTIMATED_BUDGET,',
'    ESTIMATED_BUDGET_BRACKET_ID,',
'    NOTES,',
'    REVIEW_REJECT_REASON,',
'    ESTIMATED_DATE_DEFINE,',
'    DP_SCOPING_ID,',
'    to_char(DP_ITEMS_UTIL.GET_SLA_DATE(DP_ITEMS_UTIL.get_first_day(item_id) , ',
'                                       DP_ITEMS_UTIL.GET_SLA_DAYS(ESTIMATED_BUDGET))',
'            , ''DD-Mon-YYYY'')                                            SLA_DATE,',
'    DP_ITEMS_UTIL.GET_SLA_DAYS(ESTIMATED_BUDGET)                        SAL_DAYS,',
'    TOTAL_PROJECT_BUDGET,',
'    trim(to_char(TOTAL_PROJECT_BUDGET,''99,999,999,999.99''))      TOTAL_PROJECT_BUDGET,',
'    TASK_NEW_YN,',
'    TASK_NUMBER,',
'    TASK_NUMBER_NEW,',
'    EXPENDITURE_TYPE,',
'    EXPENDITURE_TYPE_NEW',
'INTO',
'    :P90_DP_ITEM_CODE,',
'    :P90_ITEM_ID,',
'    :P90_ITEM_ID_H,',
'   -- :P90_DP_ITEM_NAME,',
'   -- :P90_INITIATIVE_NEW_YN,',
'    :P90_INITIATIVE_ID,',
'  --  :P90_INITIATIVE_NEW_NAME,',
'    :P90_PROJECT_NUMBER,',
'    :P90_PROJECT_NUMBER_H,',
'    :P90_PROJECT_NEW_YN,',
'    :P90_PROJECT_NEW_NAME,',
'    :P90_PROJECT_DESCRIPTION,',
'    :P90_MAIN_CATEGORY_ID,',
'    :P90_CATEGORY_ID,',
'    :P90_SUB_CATEGORY_ID,',
'    :P90_END_USER_ID,',
'    :P90_SECTOR_ID,',
'    :P90_DEPARTMENT_ID,',
'    :P90_COST_CENTER,',
'    :P90_DP_ITEM_TYPE_ID,',
'    :P90_CONTRACT_NO,',
'    :P90_RISK_ID,',
'    :P90_PRIORITY_ID,',
'    :P90_DP_PROCUREMENT_METHOD,',
'    :P90_PLANNING_STATUS,',
'    :P90_REVIEW_STATUS,',
'    :P90_APPROVAL_STATUS,',
'    :P90_CUTT_OFF_DATE,',
'    :P90_CREATED_BY,',
'    :P90_CREATED_ON,',
'    :P90_UPDATED_BY,',
'    :P90_UPDATED_ON,',
'    :P90_ESTIMATED_DATE,',
'    :P90_ESTIMATED_YEAR,',
'    :P90_ESTIMATED_QUARTER,',
'    :P90_ESTIMATED_BUDGET,',
'    :P90_ESTIMATED_BUDGET_H,',
'    :P90_ESTIMATED_BUDGET_BRACKET_ID,',
'    :P90_NOTES,',
'    :P90_REVIEW_REJECT_REASON,',
'    :P90_ESTIMATED_DATE_DEFINE,',
'    :P90_DP_SCOPING_ID,',
'    :P90_SLA_DATE,',
'    :P90_SLA_DAYS,',
'    :P90_TOTAL_PROJECT_BUDGET_H,',
'    :P90_TOTAL_PROJECT_BUDGET,',
'    :P90_TASK_NEW_YN,',
'    :P90_TASK_NUMBER,',
'    :P90_TASK_NUMBER_NEW,',
'    :P90_EXPENDITURE_TYPE,',
'    :P90_EXPENDITURE_TYPE_NEW',
'FROM',
'    DP_ITEMS',
'WHERE item_id = nvl(:P90_ITEM_ID  , (SELECT last_number',
'                                          FROM all_sequences',
'                                         WHERE sequence_owner = ''PROD''',
'                                           AND sequence_name = ''DP_ITEMS_SEQ'')',
'                        );',
'exception',
'    when others then null;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(58456037438454766)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_cutt_off_date    Date;',
'l_PLANNING_STATUS    Number;',
'begin',
'l_PLANNING_STATUS := DP_ITEMS_UTIL.GET_ITEM_PLANNING_STATUS(:P90_ITEM_ID , ''U'');',
'UPDATE dp_items',
'SET',
'    ESTIMATED_DATE_DEFINE = :P90_ESTIMATED_DATE_DEFINE,',
'    ESTIMATED_DATE            = to_date(:P90_ESTIMATED_DATE,''dd-Mon-YYYY''),',
'    ESTIMATED_QUARTER         = NVL(trim(to_char(to_date(:P90_ESTIMATED_DATE, ''dd-Mon-YYYY'' ) , ''Q'')) , :P90_ESTIMATED_QUARTER),',
'    ESTIMATED_YEAR            = NVL(trim(to_char(to_date(:P90_ESTIMATED_DATE, ''dd-Mon-YYYY'' ) , ''YYYY'')),:P90_ESTIMATED_YEAR),',
'    ESTIMATED_BUDGET_DEFINE = :P90_ESTIMATED_BUDGET_DEFINE,',
'    ESTIMATED_BUDGET            = :P90_ESTIMATED_BUDGET_H,',
'    ESTIMATED_BUDGET_BRACKET_ID = decode(:P90_ESTIMATED_BUDGET_H, Null,:P90_ESTIMATED_BUDGET_BRACKET_ID,',
'                                            (select  BRACKET_ID',
'                                            from dp_budget_brackets',
'                                            where :P90_ESTIMATED_BUDGET_H between MIN_VALUE and  MAX_VALUE)),',
'    DP_PROCUREMENT_METHOD       = :P90_DP_PROCUREMENT_METHOD,',
'    DP_ITEM_TYPE_ID             = :P90_DP_ITEM_TYPE_ID,',
'    RISK_ID                     = :P90_RISK_ID,',
'    PRIORITY_ID                 = :P90_PRIORITY_ID,',
'    NOTES                       = :P90_NOTES,',
'    --',
'    cutt_off_date               = dp_items_util.get_current_cuttoff_date(to_number(:CURRENT_YEAR)),',
'    PLANNING_STATUS             = l_PLANNING_STATUS,',
'    TOTAL_PROJECT_BUDGET        = :P90_TOTAL_PROJECT_BUDGET_H,',
'    TASK_NEW_YN                 = :P90_TASK_NEW_YN,',
'    TASK_NUMBER                 = :P90_TASK_NUMBER  , ',
'    TASK_NUMBER_NEW             = :P90_TASK_NUMBER_NEW,',
'    EXPENDITURE_TYPE            = :P90_EXPENDITURE_TYPE,',
'    EXPENDITURE_TYPE_NEW        = :P90_EXPENDITURE_TYPE_NEW',
'WHERE',
'    item_id = :P90_ITEM_ID;',
'end ;'))
,p_process_error_message=>'Changes not saved, Contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'UPDATE,Submit_REVIEW,New_document'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_process_success_message=>'Changes saved successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(58455698417454765)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'set Hidden Items process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
':P28_SCOPE_ID := :P90_DP_SCOPING_ID ;',
':P28_TEMPLATE_ID := :P90_TEMPLATE_ID;',
':P28_DP_ITEM_ID := :P90_ITEM_ID;',
'',
':P29_SCOPE_ID := :P90_DP_SCOPING_ID ;',
':P29_TEMPLATE_ID := :P90_TEMPLATE_ID;',
':P29_ITEM_ID := :P90_ITEM_ID;',
'',
':P30_SCOPE_ID := :P90_DP_SCOPING_ID ;',
':P30_TEMPLATE_ID := :P90_TEMPLATE_ID;',
':P30_ITEM_ID := :P90_ITEM_ID;',
'',
'',
':P31_SCOPE_ID := :P90_DP_SCOPING_ID ;',
':P31_TEMPLATE_ID := :P90_TEMPLATE_ID;',
':P31_ITEM_ID := :P90_ITEM_ID;',
'',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(58489522666454796)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(58456842552454768)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Create Version'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'L_ITEM_ID           Number;',
'l_COUNT_YEAR        Number;',
'l_COUNT_ITEM        Number;',
'--',
'l_INITIATIVE_ID     Number;',
'l_PROJECT_NUMBER    Number;',
'l_CATEGORY_ID       Number;',
'l_SUB_CATEGORY_ID   Number;',
'l_cost_center       Number;',
'Begin',
'',
' SELECT DP_ITEMS_SEQ.nextval',
'into L_ITEM_ID',
'FROM all_sequences',
' WHERE sequence_owner = ''PROD''',
'   AND sequence_name = ''DP_ITEMS_SEQ'';',
'',
'select user_details.get_cost_center(:PERSON_ID)',
'into l_cost_center',
'from dual;',
'',
'select NVL(Max(COUNT_YEAR),0)+1  ',
'into l_COUNT_YEAR',
'from dp_items',
'where dp_year = NV(''CURRENT_YEAR'');',
'',
'select INITIATIVE_ID  , PROJECT_NUMBER , CATEGORY_ID , SUB_CATEGORY_ID',
'into   l_INITIATIVE_ID  , l_PROJECT_NUMBER , l_CATEGORY_ID , l_SUB_CATEGORY_ID',
'from dp_items',
'where item_id = :P90_ITEM_ID;',
'',
'select NVL(Max(COUNT_ITEM),0)+1  ',
'into l_COUNT_ITEM',
'from dp_items',
'where dp_year = NV(''CURRENT_YEAR'')',
'and INITIATIVE_ID = l_INITIATIVE_ID',
'and project_number = l_PROJECT_NUMBER',
'and category_id = l_CATEGORY_ID',
'and SUB_CATEGORY_ID = l_SUB_CATEGORY_ID;',
'',
'INSERT INTO dp_items (',
'    initiative_id,',
'    project_number,',
'    project_new_yn,',
'    project_new_name,',
'    project_description,',
'    category_id,',
'    sub_category_id,',
'    estimated_date,',
'    estimated_month,',
'    estimated_year,',
'    estimated_quarter,',
'    end_user_id,',
'    sector_id,',
'    department_id,',
'    dp_item_type_id,',
'    risk_id,',
'    priority_id,',
'    dp_procurement_method,',
'    estimated_budget,',
'    estimated_budget_bracket_id,',
'    planning_status,',
'    review_status,',
'    approval_status,',
'    cutt_off_date,',
'    notes,',
'    cost_center,',
'    dp_item_name,',
'    count_year,',
'    count_item,',
'    dp_year,',
'    estimated_date_define,',
'    estimated_budget_define,',
'    initiative_new_yn,',
'    initiative_new_name,',
'    dp_item_code ,',
'    dp_scoping_id,',
'    main_category_id,',
'    contract_no',
') Select ',
'    initiative_id,',
'    project_number,',
'    project_new_yn,',
'    project_new_name,',
'    project_description,',
'    category_id,',
'    sub_category_id,',
'    estimated_date,',
'    estimated_month,',
'    estimated_year,',
'    estimated_quarter,',
'    end_user_id,',
'    sector_id,',
'    department_id,',
'    dp_item_type_id,',
'    risk_id,',
'    priority_id,',
'    dp_procurement_method,',
'    estimated_budget,',
'    estimated_budget_bracket_id,',
'    DP_ITEMS_UTIL.GET_ITEM_PLANNING_STATUS(:P90_ITEM_ID , ''I'') ,     --- planning_status,',
'    ''Draft'',           --  review_status,',
'    ''Required'',             -- approval_status,',
'    dp_items_util.get_current_cuttoff_date(to_number(:CURRENT_YEAR))    ,   --cutt_off_date,',
'    notes,',
'    cost_center,',
'    dp_item_name,',
'    count_year,',
'    l_COUNT_ITEM,',
'    NV(''CURRENT_YEAR''),',
'    estimated_date_define,',
'    estimated_budget_define,',
'    initiative_new_yn,',
'    initiative_new_name,',
'    dp_item_code || ''- V1'',',
'    Null,      --  dp_scoping_id,',
'    main_category_id,',
'    Null        -- contract_no',
'from dp_items',
'where item_id = :P90_ITEM_ID;',
'',
'',
'--',
'-- insert category role',
'if DP_ITEMS_UTIL.PBP_COUNT_BY_DP_CATEGORY_ID(L_SUB_CATEGORY_ID) > 0',
'then ',
'INSERT INTO dp_item_roles (item_id, role_id, person_id)',
'select L_ITEM_ID ,ROLE_ID, PERSON_ID ',
'from dp_item_category_roles',
'where CATEGORY_ID = L_SUB_CATEGORY_ID',
'and status = ''A''',
'and sysdate between nvl(START_DATE, sysdate - 10) and nvl(END_DATE , sysdate + 10) ;',
'',
'else',
'    -- insert PbP from cost center',
'    INSERT INTO dp_item_roles (item_id, role_id, person_id)',
'        select L_ITEM_ID ,108, PERSON_ID ',
'        from cost_centers_fbp',
'        where COST_CENTER = l_cost_center',
'        and status = ''A''',
'        and sysdate between nvl(START_DATE, sysdate - 10) and nvl(END_DATE , sysdate + 10) ',
'        and BP_TYPE = ''PBP'';',
'End if;        ',
'',
'-- insert finance BP',
'for emp in (select PERSON_ID ',
'            from cost_centers_fbp',
'            where COST_CENTER = l_cost_center ',
'            and STATUS = ''A''',
'            and sysdate between nvl(START_DATE , sysdate - 10) and nvl(END_DATE , sysdate + 10)',
'            and BP_TYPE = ''FBP'')',
'    loop',
'        INSERT INTO dp_item_roles (item_id, role_id, person_id)',
'        values (L_ITEM_ID , 227 , emp.person_id);',
'    end loop;',
'',
'-- Insert Participants',
'INSERT INTO dp_item_participants (item_id, person_id, role_id, status, start_date) ',
'VALUES (L_ITEM_ID, :PERSON_ID,',
'    241,    -- ROLE_id FOR OWNER (lOOKUP:DP_ITEM_PARTICIPANT_ROL)',
'    ''A'',sysdate);',
'',
'-- Copy Documents',
'INSERT INTO dp_items_documents (',
'    row_version_number,',
'    dp_items_id,',
'    filename,',
'    file_mimetype,',
'    file_charset,',
'    file_blob,',
'    file_comments,',
'    tags',
') Select',
'        row_version_number,',
'    dp_items_id,',
'    filename,',
'    file_mimetype,',
'    file_charset,',
'    file_blob,',
'    file_comments,',
'    tags',
'from dp_items_documents',
'where dp_items_id = :P90_ITEM_ID;',
'end;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(58487115154454795)
);
wwv_flow_api.component_end;
end;
/
