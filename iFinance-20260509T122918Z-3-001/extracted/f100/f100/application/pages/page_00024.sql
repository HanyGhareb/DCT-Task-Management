prompt --application/pages/page_00024
begin
--   Manifest
--     PAGE: 00024
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>24
,p_user_interface_id=>wwv_flow_api.id(1686359760302353)
,p_name=>'Finance Templates Report'
,p_alias=>'FINANCE-TEMPLATES-REPORT'
,p_step_title=>'Finance Templates Report'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210928211221'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(42063765752645915)
,p_plug_name=>'Documents Report'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(1599843476302282)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    id,',
'    row_version_number,',
'    filename_word,',
'    file_mimetype_word,',
'    file_charset',
'    ,sys.dbms_lob.getlength(file_blob_word) file_blob_word',
'    , sys.dbms_lob.getlength(file_blob_word) as download_word,',
'    filename_pdf,',
'    file_mimetype_pdf,',
'    file_charset_pdf',
'    ,sys.dbms_lob.getlength(file_blob_pdf)  file_blob_pdf',
'     , sys.dbms_lob.getlength(file_blob_pdf) as download_pdf',
'   , file_comments,',
'    tags,',
'    doc_type_id,',
'    created_by_person_id,',
'    created_on,',
'    updated_by_person_id,',
'    updated_on',
'FROM',
'    dct_templates;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Documents Report'
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
 p_id=>wwv_flow_api.id(42064130583645915)
,p_name=>'Report 1'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:25:&SESSION.::&DEBUG.:RP:P25_ID:\#ID#\'
,p_detail_link_text=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_owner=>'TCA9051'
,p_internal_uid=>42064130583645915
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42064242634645916)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42064639085645917)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42065816939645917)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42066684117645917)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Document'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42067061065645918)
,p_db_column_name=>'TAGS'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42067479618645918)
,p_db_column_name=>'DOC_TYPE_ID'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Document Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(42076767076676753)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42067812271645918)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(38872040010435083)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42068292456645918)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42068659657645918)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(38872040010435083)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42069007425645919)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42088338186952626)
,p_db_column_name=>'FILENAME_WORD'
,p_display_order=>23
,p_column_identifier=>'O'
,p_column_label=>'Filename Word'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42088426644952627)
,p_db_column_name=>'FILE_MIMETYPE_WORD'
,p_display_order=>33
,p_column_identifier=>'P'
,p_column_label=>'File Mimetype Word'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42088571541952628)
,p_db_column_name=>'FILE_BLOB_WORD'
,p_display_order=>43
,p_column_identifier=>'Q'
,p_column_label=>'File Blob Word'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42088688072952629)
,p_db_column_name=>'DOWNLOAD_WORD'
,p_display_order=>53
,p_column_identifier=>'R'
,p_column_label=>'Download Word'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DOWNLOAD:DCT_TEMPLATES:FILE_BLOB_WORD:ID::FILE_MIMETYPE_WORD:FILENAME_WORD:UPDATED_ON:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42088775825952630)
,p_db_column_name=>'FILENAME_PDF'
,p_display_order=>63
,p_column_identifier=>'S'
,p_column_label=>'File name Pdf'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42088897476952631)
,p_db_column_name=>'FILE_MIMETYPE_PDF'
,p_display_order=>73
,p_column_identifier=>'T'
,p_column_label=>'File Mimetype Pdf'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42088949708952632)
,p_db_column_name=>'FILE_CHARSET_PDF'
,p_display_order=>83
,p_column_identifier=>'U'
,p_column_label=>'File Charset Pdf'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42089079657952633)
,p_db_column_name=>'FILE_BLOB_PDF'
,p_display_order=>93
,p_column_identifier=>'V'
,p_column_label=>'File Blob Pdf'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42089167287952634)
,p_db_column_name=>'DOWNLOAD_PDF'
,p_display_order=>103
,p_column_identifier=>'W'
,p_column_label=>'Download  PDF'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DOWNLOAD:DCT_TEMPLATES:FILE_BLOB_PDF:ID::FILE_MIMETYPE_PDF:FILENAME_PDF:UPDATED_ON:FILE_CHARSET_PDF:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(42072455408646613)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'420725'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILE_COMMENTS:UPDATED_ON:DOWNLOAD_WORD:DOWNLOAD_PDF'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(42070610483645921)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(1611180433302287)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(1547752126302241)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(1665264360302322)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(42090502870952648)
,p_plug_name=>'Finance Documents'
,p_icon_css_classes=>'fa-file-word-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(1601776079302283)
,p_plug_display_sequence=>20
,p_plug_grid_column_span=>6
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    id,',
'    row_version_number,',
'    filename_word,',
'    file_mimetype_word,',
'    file_charset',
'    ,sys.dbms_lob.getlength(file_blob_word) file_blob_word',
'    , sys.dbms_lob.getlength(file_blob_word) as download_word,',
'    filename_pdf,',
'    file_mimetype_pdf,',
'    file_charset_pdf',
'    ,sys.dbms_lob.getlength(file_blob_pdf)  file_blob_pdf',
'     , sys.dbms_lob.getlength(file_blob_pdf) as download_pdf',
'   , file_comments,',
'    tags,',
'    doc_type_id,',
'    created_by_person_id,',
'    created_on,',
'    updated_by_person_id,',
'    updated_on',
'FROM',
'    dct_templates;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Finance Documents'
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
 p_id=>wwv_flow_api.id(42090726253952650)
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>42090726253952650
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42133975406136401)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42134035987136402)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42134176410136403)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42134265483136404)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Document'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42134332752136405)
,p_db_column_name=>'TAGS'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42134467764136406)
,p_db_column_name=>'DOC_TYPE_ID'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Document Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(42076767076676753)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42134506874136407)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(38872040010435083)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42134657385136408)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42134706378136409)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(38872040010435083)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42134833367136410)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42134933456136411)
,p_db_column_name=>'FILENAME_WORD'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Filename Word'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42135093078136412)
,p_db_column_name=>'FILE_MIMETYPE_WORD'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'File Mimetype Word'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42135113449136413)
,p_db_column_name=>'FILE_BLOB_WORD'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'File Blob Word'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42135222183136414)
,p_db_column_name=>'DOWNLOAD_WORD'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Download Word'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_allow_hide=>'N'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DOWNLOAD:DCT_TEMPLATES:FILE_BLOB_WORD:ID::FILE_MIMETYPE_WORD:FILENAME_WORD:UPDATED_ON:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42135346762136415)
,p_db_column_name=>'FILENAME_PDF'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'File name Pdf'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42135451256136416)
,p_db_column_name=>'FILE_MIMETYPE_PDF'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'File Mimetype Pdf'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42135556153136417)
,p_db_column_name=>'FILE_CHARSET_PDF'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'File Charset Pdf'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42135616005136418)
,p_db_column_name=>'FILE_BLOB_PDF'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'File Blob Pdf'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42135705231136419)
,p_db_column_name=>'DOWNLOAD_PDF'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Download  PDF'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_allow_hide=>'N'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DOWNLOAD:DCT_TEMPLATES:FILE_BLOB_PDF:ID::FILE_MIMETYPE_PDF:FILENAME_PDF:UPDATED_ON:FILE_CHARSET_PDF:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(42151723123138847)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'421518'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:FILE_COMMENTS:UPDATED_ON:DOWNLOAD_WORD:FILE_MIMETYPE_PDF:FILE_CHARSET_PDF:DOWNLOAD_PDF'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(42071878766645921)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(42063765752645915)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(1663835798302321)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:25:&SESSION.::&DEBUG.:25'
);
wwv_flow_api.component_end;
end;
/
