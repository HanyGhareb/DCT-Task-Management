prompt --application/pages/page_00018
begin
--   Manifest
--     PAGE: 00018
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
 p_id=>18
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'DP Item Approve/Reject'
,p_alias=>'DP-ITEM-APPROVE-REJECT'
,p_step_title=>'DP Item Approve/Reject'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240226220105'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(257770386960002428)
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(257770956732002426)
,p_plug_name=>'Main Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(514982453845263495)
,p_plug_name=>'Budget Details'
,p_parent_plug_id=>wwv_flow_api.id(257770956732002426)
,p_icon_css_classes=>'fa-number-2-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_read_only_when_type=>'ALWAYS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(514982282878263494)
,p_plug_name=>'Details L2'
,p_parent_plug_id=>wwv_flow_api.id(514982453845263495)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(514982255009263493)
,p_plug_name=>'Details R2'
,p_parent_plug_id=>wwv_flow_api.id(514982453845263495)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(514982042511263491)
,p_plug_name=>'Details Notes'
,p_parent_plug_id=>wwv_flow_api.id(514982453845263495)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(514981766187263489)
,p_plug_name=>'Header Details'
,p_parent_plug_id=>wwv_flow_api.id(257770956732002426)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(528640860976468651)
,p_plug_name=>'Project Details'
,p_parent_plug_id=>wwv_flow_api.id(514981766187263489)
,p_icon_css_classes=>'fa-number-1-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(528640826900468650)
,p_plug_name=>'Details L1'
,p_parent_plug_id=>wwv_flow_api.id(528640860976468651)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(528640670982468649)
,p_plug_name=>'Details R1'
,p_parent_plug_id=>wwv_flow_api.id(528640860976468651)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(514982666343263498)
,p_plug_name=>'Details L1'
,p_parent_plug_id=>wwv_flow_api.id(528640860976468651)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_read_only_when_type=>'ALWAYS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(514982641984263497)
,p_plug_name=>'Details R1'
,p_parent_plug_id=>wwv_flow_api.id(528640860976468651)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>40
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(129563376783892644)
,p_plug_name=>'Review & Verification Partners'
,p_parent_plug_id=>wwv_flow_api.id(257770956732002426)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:is-expanded:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(258888659381449652)
,p_name=>'Roles'
,p_parent_plug_id=>wwv_flow_api.id(129563376783892644)
,p_template=>wwv_flow_api.id(127803777897449779)
,p_display_sequence=>60
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight:t-Report--horizontalBorders'
,p_grid_column_span=>8
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select role_id  , person_id',
'from DP_ITEM_ROLES',
'where item_id = :P18_ITEM_ID;'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P18_ITEM_ID'
,p_query_row_template=>wwv_flow_api.id(127830010182449763)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129968994085752336)
,p_query_column_id=>1
,p_column_alias=>'ROLE_ID'
,p_column_display_sequence=>1
,p_column_heading=>'Role'
,p_use_as_row_header=>'N'
,p_column_alignment=>'RIGHT'
,p_display_as=>'TEXT_FROM_LOV_ESC'
,p_named_lov=>wwv_flow_api.id(129038068099971033)
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129969388704752336)
,p_query_column_id=>2
,p_column_alias=>'PERSON_ID'
,p_column_display_sequence=>2
,p_column_heading=>'Employee'
,p_use_as_row_header=>'N'
,p_column_alignment=>'CENTER'
,p_heading_alignment=>'LEFT'
,p_display_as=>'TEXT_FROM_LOV_ESC'
,p_named_lov=>wwv_flow_api.id(128328640271489809)
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(257771730113002425)
,p_plug_name=>'Audit Info'
,p_parent_plug_id=>wwv_flow_api.id(257770956732002426)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(258049043025027706)
,p_plug_name=>'Summary'
,p_parent_plug_id=>wwv_flow_api.id(257770956732002426)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>30
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(258049150492027707)
,p_plug_name=>'Statuses'
,p_parent_plug_id=>wwv_flow_api.id(258049043025027706)
,p_icon_css_classes=>'fa-suitcase'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(257772186391002425)
,p_plug_name=>'Documents'
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>50
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(257878474048567892)
,p_plug_name=>'Documents report'
,p_parent_plug_id=>wwv_flow_api.id(257772186391002425)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
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
'  where dp_items_id = :P18_ITEM_ID',
'    order by UPDATED desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P18_ITEM_ID'
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
 p_id=>wwv_flow_api.id(257878616207567893)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>257878616207567893
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129149566531330355)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129149965177330355)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129150338834330354)
,p_db_column_name=>'DP_ITEMS_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Dp Items Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129150709278330354)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'File Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129151161916330354)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129151540571330354)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129151905795330353)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129152359663330353)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129152786469330353)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129153152774330353)
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
 p_id=>wwv_flow_api.id(129153525369330353)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129153916304330352)
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
 p_id=>wwv_flow_api.id(129154311911330352)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129154789808330352)
,p_db_column_name=>'COMMENT_ID'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Comment Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129155192148330352)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129155514388330352)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:DP_ITEMS_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(257904128911283060)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1291559'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(257772526436002425)
,p_plug_name=>'Review /Approval History'
,p_icon_css_classes=>'fa-users'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent13:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>60
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_plug_display_when_condition=>'P18_REVIEW_STATUS'
,p_plug_display_when_cond2=>'Draft'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(257880574608567913)
,p_plug_name=>'Review History Report'
,p_parent_plug_id=>wwv_flow_api.id(257772526436002425)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
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
'      e.full_name_en || ''('' || e.user_name || '')'' as full_name_en,',
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
'and h.request_id = :P18_ITEM_ID',
'and h.status != ''Beaten''',
'order by h.STEP_NO ',
'--, h.ID',
';'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P18_ITEM_ID'
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
 p_id=>wwv_flow_api.id(257880689083567914)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>257880689083567914
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129156946415330348)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129157396787330347)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129157719819330347)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129158165011330347)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129158512675330347)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Role'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(129038068099971033)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129158961075330347)
,p_db_column_name=>'ROLE_DESC'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Role Desc'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129159392861330346)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129159741465330346)
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
 p_id=>wwv_flow_api.id(129160149428330346)
,p_db_column_name=>'STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129160598151330346)
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
 p_id=>wwv_flow_api.id(129160900200330346)
,p_db_column_name=>'COMMENTS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129161360330330345)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129161757209330345)
,p_db_column_name=>'STATUS_CLASS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Status Class'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129162109807330345)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129162513550330345)
,p_db_column_name=>'PHOTO'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(258147648976255283)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1291629'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:PHOTO:FULL_NAME_EN:ROLE_ID:ACTION_REQUIRED:RECEVIED_DATE:STATUS:ACTION_DATE:COMMENTS:'
,p_sort_column_1=>'STEP_NO'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(129202749229108362)
,p_report_id=>wwv_flow_api.id(258147648976255283)
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
 p_id=>wwv_flow_api.id(258160681006337994)
,p_plug_name=>'Collaboration'
,p_icon_css_classes=>'fa-comments-o fa-anim-flash fam-sleep fam-is-success'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(258160849240337996)
,p_name=>'Comments Report'
,p_parent_plug_id=>wwv_flow_api.id(258160681006337994)
,p_template=>wwv_flow_api.id(127776395121449810)
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
'where ITEM_ID = :P18_ITEM_ID',
'order by CREATION_DATE desc;'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P18_ITEM_ID'
,p_query_row_template=>wwv_flow_api.id(127832693224449762)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No Communications yet.'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129164765412330343)
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
 p_id=>wwv_flow_api.id(129165155182330342)
,p_query_column_id=>2
,p_column_alias=>'COMMENT_DATE'
,p_column_display_sequence=>2
,p_column_heading=>'Comment Date'
,p_use_as_row_header=>'N'
,p_column_format=>'DD-MON-YYYY HH:MIPM'
,p_column_html_expression=>'<br>#COMMENT_DATE#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129165562664330342)
,p_query_column_id=>3
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>3
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<span style="color:blue">From: </span>#USER_NAME#, <br><span style="color:blue">To: </span>#COMMENT_TO#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129165964050330342)
,p_query_column_id=>4
,p_column_alias=>'COMMENT_TEXT'
,p_column_display_sequence=>4
,p_column_heading=>'Comment Text'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129166324041330342)
,p_query_column_id=>5
,p_column_alias=>'COMMENT_MODIFIERS'
,p_column_display_sequence=>5
,p_column_heading=>'Comment Modifiers'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129166701808330342)
,p_query_column_id=>6
,p_column_alias=>'ICON_MODIFIER'
,p_column_display_sequence=>6
,p_column_heading=>'Icon Modifier'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129167169184330341)
,p_query_column_id=>7
,p_column_alias=>'ACTIONS'
,p_column_display_sequence=>7
,p_column_heading=>'Actions'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129167530525330341)
,p_query_column_id=>8
,p_column_alias=>'ATTRIBUTE_1'
,p_column_display_sequence=>8
,p_column_heading=>'Attribute 1'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129167920867330341)
,p_query_column_id=>9
,p_column_alias=>'ATTRIBUTE_2'
,p_column_display_sequence=>9
,p_column_heading=>'Attribute 2'
,p_use_as_row_header=>'N'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<br>',
'<hr>'))
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
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129168322475330341)
,p_query_column_id=>10
,p_column_alias=>'ATTRIBUTE_3'
,p_column_display_sequence=>10
,p_column_heading=>'Attribute 3'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129168798028330341)
,p_query_column_id=>11
,p_column_alias=>'ATTRIBUTE_4'
,p_column_display_sequence=>11
,p_column_heading=>'Attribute 4'
,p_use_as_row_header=>'N'
,p_column_format=>'DOWNLOAD:DP_ITEMS_COMMENTS:FILE_BLOB:COMMENT_ID::FILE_MIMETYPE:FILENAME:UPDATED_DATE::attachment:Document #FILENAME#:'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129169126787330340)
,p_query_column_id=>12
,p_column_alias=>'COMMENT_ID'
,p_column_display_sequence=>12
,p_column_heading=>'Comment Id'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129169589832330340)
,p_query_column_id=>13
,p_column_alias=>'FILENAME'
,p_column_display_sequence=>13
,p_column_heading=>'Filename'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129169990875330340)
,p_query_column_id=>14
,p_column_alias=>'COMMENT_TO'
,p_column_display_sequence=>14
,p_column_heading=>'Comment To'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(283235431585762537)
,p_plug_name=>'Budget Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:is-expanded:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>40
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_read_only_when_type=>'PLSQL_EXPRESSION'
,p_plug_read_only_when=>':P18_ITEM_ID is not null and :P18_REVIEW_STATUS not in (''Draft'',''Withdraw'' , ''Return'')'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(161851022094677800)
,p_plug_name=>'Budget Details L'
,p_parent_plug_id=>wwv_flow_api.id(283235431585762537)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(161851134237677801)
,p_plug_name=>'Budget Details R'
,p_parent_plug_id=>wwv_flow_api.id(283235431585762537)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>5
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(162822891465898405)
,p_plug_name=>'Cashflow Details'
,p_parent_plug_id=>wwv_flow_api.id(283235431585762537)
,p_icon_css_classes=>'fa-money'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1',
'from cashflow_lines',
'where SOURCE = ''DP''',
'and REQUEST_ID = :P18_ITEM_ID;'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(162822998085898406)
,p_plug_name=>'Cashflow Details Report'
,p_parent_plug_id=>wwv_flow_api.id(162822891465898405)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
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
'and REQUEST_ID = :P18_ITEM_ID;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P18_ITEM_ID'
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
 p_id=>wwv_flow_api.id(162823016255898407)
,p_max_row_count=>'1000000'
,p_allow_save_rpt_public=>'Y'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_rows_per_page=>'N'
,p_show_filter=>'N'
,p_show_control_break=>'N'
,p_show_flashback=>'N'
,p_show_reset=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>307025185229954371
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9728381543622286)
,p_db_column_name=>'LINE_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Line Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9729139829622287)
,p_db_column_name=>'ACCOUNTING_YEAR'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Budget Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9730007045622287)
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
 p_id=>wwv_flow_api.id(9730367915622288)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9730749122622288)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9731171684622288)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9731583865622288)
,p_db_column_name=>'PROJECT_NAME_NEW'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'New Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9732009824622288)
,p_db_column_name=>'TASK_NUMBER_NEW'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'New Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9732397326622289)
,p_db_column_name=>'EXPENDITURE_TYPE_NEW'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'New Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9732771508622289)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9733171588622295)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9733613802622296)
,p_db_column_name=>'BUDGET_GROUB_CODE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Budget Groub Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9733936946622296)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'GL Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9734334063622296)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9734741892622296)
,p_db_column_name=>'FUTURE1'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9735145277622297)
,p_db_column_name=>'FUTURE2'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9735615106622297)
,p_db_column_name=>'ENTITY_CODE_NEW'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'New Entity Code'
,p_column_type=>'STRING'
,p_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_display_condition=>'P18_PROJECT_NEW_YN'
,p_display_condition2=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9735977978622297)
,p_db_column_name=>'COST_CENTER_NEW'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'New Cost Center'
,p_column_type=>'STRING'
,p_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_display_condition=>'P18_PROJECT_NEW_YN'
,p_display_condition2=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9736344228622297)
,p_db_column_name=>'BUDGET_GROUB_CODE_NEW'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'New Budget Group Code'
,p_column_type=>'STRING'
,p_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_display_condition=>'P18_PROJECT_NEW_YN'
,p_display_condition2=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9736746025622298)
,p_db_column_name=>'GL_ACCOUNT_NEW'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'New GL Account'
,p_column_type=>'STRING'
,p_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_display_condition=>'P18_PROJECT_NEW_YN'
,p_display_condition2=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9737153323622298)
,p_db_column_name=>'ACTIVITY_NEW'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'New Activity'
,p_column_type=>'STRING'
,p_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_display_condition=>'P18_PROJECT_NEW_YN'
,p_display_condition2=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9737573417622298)
,p_db_column_name=>'FUTURE1_NEW'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'New Future1'
,p_column_type=>'STRING'
,p_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_display_condition=>'P18_PROJECT_NEW_YN'
,p_display_condition2=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9737948556622298)
,p_db_column_name=>'FUTURE2_NEW'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'New Future2'
,p_column_type=>'STRING'
,p_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_display_condition=>'P18_PROJECT_NEW_YN'
,p_display_condition2=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9740019249622299)
,p_db_column_name=>'JAN'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'01-&P18_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9740416810622300)
,p_db_column_name=>'FEB'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'02-&P18_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9740764172622300)
,p_db_column_name=>'MAR'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'03-&P18_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9741182506622300)
,p_db_column_name=>'APR'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'04-&P18_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9741630557622300)
,p_db_column_name=>'MAY'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'05-&P18_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9741971922622300)
,p_db_column_name=>'JUN'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'06-&P18_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9742339414622301)
,p_db_column_name=>'JUL'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'07-&P18_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9742791869622301)
,p_db_column_name=>'AUG'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'08-&P18_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9743174757622301)
,p_db_column_name=>'SEP'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'09-&P18_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9743598436622301)
,p_db_column_name=>'OCT'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'10-&P18_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9744017130622302)
,p_db_column_name=>'NOV'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'11-&P18_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9744391724622302)
,p_db_column_name=>'DEC'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'12-&P18_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9745604215622303)
,p_db_column_name=>'NOTE'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Note'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9745996219622303)
,p_db_column_name=>'STATUS'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9748347345622304)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>520
,p_column_identifier=>'AZ'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9748772632622305)
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
 p_id=>wwv_flow_api.id(9749131717622305)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>540
,p_column_identifier=>'BB'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9749610305622305)
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
 p_id=>wwv_flow_api.id(9749939529622305)
,p_db_column_name=>'TOTAL_CF_FORMAT'
,p_display_order=>560
,p_column_identifier=>'BD'
,p_column_label=>'Total Cf Format'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9747553798622304)
,p_db_column_name=>'INITIATIVE_ID'
,p_display_order=>570
,p_column_identifier=>'AX'
,p_column_label=>'Initiative Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9747948867622304)
,p_db_column_name=>'INITIATIVE_NEW_NAME'
,p_display_order=>580
,p_column_identifier=>'AY'
,p_column_label=>'Initiative New Name'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9745201393622303)
,p_db_column_name=>'TOTAL_CF'
,p_display_order=>590
,p_column_identifier=>'AQ'
,p_column_label=>'Total Cf'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9746414479622303)
,p_db_column_name=>'FINAL_STATUS_ON'
,p_display_order=>600
,p_column_identifier=>'AT'
,p_column_label=>'Final Status On'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9744734229622302)
,p_db_column_name=>'LINE_TYPE'
,p_display_order=>610
,p_column_identifier=>'AP'
,p_column_label=>'Line Type'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9738776595622299)
,p_db_column_name=>'BUDGET'
,p_display_order=>620
,p_column_identifier=>'AA'
,p_column_label=>'Budget'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9739226352622299)
,p_db_column_name=>'ENCUMBERANCE'
,p_display_order=>630
,p_column_identifier=>'AB'
,p_column_label=>'Encumberance'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9739533433622299)
,p_db_column_name=>'ACTUAL'
,p_display_order=>640
,p_column_identifier=>'AC'
,p_column_label=>'Actual'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9738349170622299)
,p_db_column_name=>'ALLOCATED_BUDGET'
,p_display_order=>650
,p_column_identifier=>'Z'
,p_column_label=>'Allocated Budget'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9746778334622303)
,p_db_column_name=>'SOURCE'
,p_display_order=>660
,p_column_identifier=>'AU'
,p_column_label=>'Source'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9728759728622287)
,p_db_column_name=>'BUDGET_ALLOCATION_PLAN_ID'
,p_display_order=>670
,p_column_identifier=>'B'
,p_column_label=>'Budget Allocation Plan Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9729618333622287)
,p_db_column_name=>'MULTI_YEAR_YN'
,p_display_order=>680
,p_column_identifier=>'D'
,p_column_label=>'Multi Year Yn'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9747147252622304)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>690
,p_column_identifier=>'AV'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9750388994622305)
,p_db_column_name=>'REQUEST_LINE_ID'
,p_display_order=>700
,p_column_identifier=>'BE'
,p_column_label=>'Request Line Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(163139310202930635)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1539529'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'JAN:FEB:MAR:APR:MAY:JUN:JUL:AUG:SEP:OCT:NOV:DEC:APXWS_CC_001:'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(9751200990622308)
,p_report_id=>wwv_flow_api.id(163139310202930635)
,p_db_column_name=>'APXWS_CC_001'
,p_column_identifier=>'C01'
,p_computation_expr=>'AD + AE + AF + AG + AH + AI + AJ + AK + AL + AM + AN + AO'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Total'
,p_report_label=>'Total'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(129129343496330383)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(257770386960002428)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(129148828438330358)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(257772186391002425)
,p_button_name=>'New_document'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'New Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.:18:P14_DP_ITEMS_ID,P14_PAGE_FROM,P14_REVIEW_STATUS:&P18_ITEM_ID.,18,&P18_REVIEW_STATUS.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(129164007420330343)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(258160681006337994)
,p_button_name=>'AddComment'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Collaborate'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:17:&SESSION.::&DEBUG.::P17_ITEM_ID:&P18_ITEM_ID.'
,p_icon_css_classes=>'fa-envelope-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(129034646013007629)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(257770386960002428)
,p_button_name=>'Approve'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'&P18_APPROVE_LABEL.'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:12:P12_ACTION,P12_HISTORY_ID,P12_REQUEST_ID:Approve,&P18_HISTORY_ID.,&P18_ITEM_ID.'
,p_icon_css_classes=>'fa-thumbs-o-up'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(129034715130007630)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(257770386960002428)
,p_button_name=>'Reject'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--danger:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'&P18_REJECT_LABEL.'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:12:P12_ACTION,P12_HISTORY_ID,P12_REQUEST_ID:Reject,&P18_HISTORY_ID.,&P18_ITEM_ID.'
,p_icon_css_classes=>'fa-thumbs-o-down'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(129034858203007631)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(257770386960002428)
,p_button_name=>'Delegate'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Delegate'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:12:P12_ACTION,P12_HISTORY_ID,P12_REQUEST_ID:Delegate,&P18_HISTORY_ID.,&P18_ITEM_ID.'
,p_icon_css_classes=>'fa-sign-language'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(129034935594007632)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(257770386960002428)
,p_button_name=>'Return'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Return'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:12:P12_ACTION,P12_HISTORY_ID,P12_REQUEST_ID:Return,&P18_HISTORY_ID.,&P18_ITEM_ID.'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(129187293738330321)
,p_branch_name=>'GO TO 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(514982511518263496)
,p_name=>'P18_PROJECT_TITLE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(514982666343263498)
,p_prompt=>'Project Title'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(514982098067263492)
,p_name=>'P18_PROJECT_END_DATE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(514982255009263493)
,p_prompt=>'Project End Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(514981885039263490)
,p_name=>'P18_EXPECTED_DELIVERY_DATE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(258049150492027707)
,p_prompt=>'Expected Delivery ON'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(32628522265261115)
,p_name=>'P18_DP_ITEM_CODE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(514982666343263498)
,p_prompt=>'Item Code'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(87687117085720)
,p_name=>'P18_MAIN_CATEGORY_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(528640826900468650)
,p_prompt=>'Category Level 1'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ITEM MAIN CATEGORIES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CATEGORY_NAME , CATEGORY_ID',
'from dp_item_categories',
'where ORDER_LEVEL = 231 ;'))
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(678933653236370)
,p_name=>'P18_CONTRACT_NO'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(528640670982468649)
,p_prompt=>'Contract No'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_display_when=>'P18_CONTRACT_NO'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9752273211622311)
,p_name=>'P18_ESTIMATED_DATE_DEFINE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(514982255009263493)
,p_item_default=>'N'
,p_prompt=>'Estimated Date Define ?'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9752694173622313)
,p_name=>'P18_ESTIMATED_DATE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(514982255009263493)
,p_prompt=>'Project Start Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_grid_label_column_span=>4
,p_display_when=>'P18_ESTIMATED_DATE_DEFINE'
,p_display_when2=>'Y'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9753113831622313)
,p_name=>'P18_ESTIMATED_MONTH'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(514982255009263493)
,p_prompt=>'Estimated Month'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_grid_label_column_span=>4
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9753529540622314)
,p_name=>'P18_ESTIMATED_QUARTER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(514982255009263493)
,p_prompt=>'Estimated Quarter'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:1;1,2;2,3;3,4;4'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9753837271622314)
,p_name=>'P18_ESTIMATED_YEAR'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(514982255009263493)
,p_prompt=>'Estimated Year'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:2022;2022,2023;2023,2024;2024,2025;2025,2026;2026,2027;2027,2028;2028,2029;2029,2030;2030'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9754310987622314)
,p_name=>'P18_ESTIMATED_BUDGET_DEFINE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(514982255009263493)
,p_prompt=>'Estimated Budget Define ?'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>4
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9754688725622315)
,p_name=>'P18_ESTIMATED_BUDGET'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(514982255009263493)
,p_prompt=>'Current Year Budget'
,p_post_element_text=>'<p>&nbsp; AED</p>'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_colspan=>8
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9755059814622315)
,p_name=>'P18_ESTIMATED_BUDGET_H'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(514982255009263493)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9755440654622315)
,p_name=>'P18_TOTAL_PROJECT_BUDGET'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(514982255009263493)
,p_prompt=>'Total Project Budget'
,p_post_element_text=>'<p>&nbsp; AED</p>'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9755839240622315)
,p_name=>'P18_TOTAL_PROJECT_BUDGET_H'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(514982255009263493)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9756248719622315)
,p_name=>'P18_TASK_NEW_YN'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(514982282878263494)
,p_item_default=>'N'
,p_prompt=>'New Task ?'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_display_when=>'P18_PROJECT_NEW_YN'
,p_display_when2=>'N'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9756632662622316)
,p_name=>'P18_TASK_NUMBER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(514982282878263494)
,p_prompt=>'Task'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'TASKS BY PROJECT NUMBER PAGE11'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select TASK_NUMBER  Task, TASK_DESCRIPTION, COST_CENTER, FUTURE2',
'from tasks_all_v',
'where project_number = :P11_PROJECT_NUMBER_H ;'))
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_grid_label_column_span=>3
,p_display_when=>':P18_TASK_NEW_YN = ''N'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9757104739622316)
,p_name=>'P18_TASK_NUMBER_NEW'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(514982282878263494)
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
,p_grid_label_column_span=>3
,p_display_when=>':P18_TASK_NEW_YN = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'CONTAINS_IGNORE'
,p_attribute_04=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9757466261622316)
,p_name=>'P18_EXPENDITURE_TYPE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(514982282878263494)
,p_prompt=>'Expenditure Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'EXPENDITURE TYPES BY PAGE 11'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select EXPENDITURE_TYPE, DESCRIPTION, GL_ACCOUNT, GL_ACCOUNT_NAME',
'from expenditures_v',
'where project_number = :P11_PROJECT_NUMBER_H',
'and TASK_NUMBER = :P11_TASK_NUMBER ;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P18_TASK_NUMBER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_display_when=>':P18_TASK_NEW_YN = ''N'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9757875646622317)
,p_name=>'P18_EXPENDITURE_TYPE_NEW'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(514982282878263494)
,p_prompt=>'New Expenditure Type'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EXPENDITURES ALL'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct EXPENDITURE_TYPE d, EXPENDITURE_TYPE r',
'from expenditures_v',
'order by 1'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_grid_label_column_span=>3
,p_display_when=>':P18_TASK_NEW_YN = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9758577936622318)
,p_name=>'P18_ESTIMATED'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(161851134237677801)
,p_prompt=>'Estimated Quarter-Year'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9759023114622318)
,p_name=>'P18_ESTIMATED_BUDGET_BRACKET_ID'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(161851134237677801)
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
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'1'
,p_attribute_02=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129034457747007627)
,p_name=>'P18_HISTORY_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(257770386960002428)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129034510815007628)
,p_name=>'P18_SEQ'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(257770386960002428)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129035504976007638)
,p_name=>'P18_APPROVE_LABEL'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(257770386960002428)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129035641791007639)
,p_name=>'P18_REJECT_LABEL'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(257770386960002428)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129130932841330380)
,p_name=>'P18_PAGE_FROM'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(257770386960002428)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129131261276330379)
,p_name=>'P18_ITEM_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(257770386960002428)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129133094287330376)
,p_name=>'P18_INITIATIVE_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(514982666343263498)
,p_prompt=>'Initiative'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'INITIATIVES POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select INITIATIVE_ID, INITIATIVE_CODE, INITIATIVE_NAME, ',
'    decode(INITIATIVE_TYPE, ''S'' , ''Strategic'' , ''N'', ''Non-Strategic'') INITIATIVE_TYPE',
'from strategic_initiatives;'))
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129133437385330375)
,p_name=>'P18_PROJECT_NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(514982282878263494)
,p_prompt=>'Project'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'OPERATIONAL PROJECTS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PROJECT_NUMBER || '' - '' || PROJECT_NAME  PROJECT_NAME , project_number ',
'from project',
'where PROJECT_TYPE = ''Operational'''))
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129133854097330375)
,p_name=>'P18_PROJECT_NEW_YN'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(514982282878263494)
,p_prompt=>'New Project ?'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(128345817677489797)||'.'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129134292376330375)
,p_name=>'P18_PROJECT_NEW_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(514982282878263494)
,p_prompt=>'New Project Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129134617496330375)
,p_name=>'P18_CATEGORY_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(528640826900468650)
,p_prompt=>'Category Level 2'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ITEM CATEGORY  LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CATEGORY_NAME , CATEGORY_ID',
'from dp_item_categories',
'where ORDER_LEVEL = 232 ;'))
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129135062836330374)
,p_name=>'P18_SUB_CATEGORY_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(528640826900468650)
,p_prompt=>'Category Level 3'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ITEM CATEGORIES ALL LOV'
,p_lov=>'select  CATEGORY_NAME , CATEGORY_ID from dp_item_categories'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129135409578330374)
,p_name=>'P18_PROJECT_DESCRIPTION'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(514982666343263498)
,p_prompt=>'Project Brief'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129135845160330374)
,p_name=>'P18_END_USER_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(514982641984263497)
,p_prompt=>'End User'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e',
'where person_id > 10'))
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129136207388330374)
,p_name=>'P18_SECTOR_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(514982641984263497)
,p_prompt=>'Sector'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'SECTORS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  NVL(SECTOR_NAME_USER , SECTOR_NAME) Name , SECTOR_ID',
'from dct_hr_sectors_v'))
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129136637069330374)
,p_name=>'P18_DEPARTMENT_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(514982641984263497)
,p_prompt=>'Department'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ORGANIZATION NAME RETURN ORG_ID'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129137098119330374)
,p_name=>'P18_COST_CENTER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(514982641984263497)
,p_prompt=>'Cost Center'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129139154269330371)
,p_name=>'P18_PLANNING_STATUS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(258049150492027707)
,p_prompt=>'Planning Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'DP ITEM PLANNING STATUS'
,p_lov=>'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 48 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10);'
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129139591340330371)
,p_name=>'P18_REVIEW_STATUS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(258049150492027707)
,p_prompt=>'Review Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129139959211330371)
,p_name=>'P18_APPROVAL_STATUS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(258049150492027707)
,p_prompt=>'Approval Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129140323693330371)
,p_name=>'P18_CUTT_OFF_DATE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(258049150492027707)
,p_prompt=>'Cut Off Date'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129144603124330360)
,p_name=>'P18_DP_PROCUREMENT_METHOD'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(514982641984263497)
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
,p_grid_label_column_span=>3
,p_display_when=>'P18_DP_PROCUREMENT_METHOD'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129145039415330360)
,p_name=>'P18_DP_ITEM_TYPE_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(528640670982468649)
,p_prompt=>'Project Item Type'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'DP ITEM TYPES LOV'
,p_lov=>'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 45 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10)'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129145493884330360)
,p_name=>'P18_RISK_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(528640670982468649)
,p_prompt=>'Risk'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'DP RISK LEVEL LOV'
,p_lov=>'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 46 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10);'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129145833853330360)
,p_name=>'P18_PRIORITY_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(528640670982468649)
,p_prompt=>'Priority'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'PRIORITY LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id',
'from dct_lookup_values',
'where lookup_id = (Select x.lookup_id',
'                    from dct_lookups x',
'                    where x.LOOKUP_CODE = ''PRIORITY'');'))
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129146278575330359)
,p_name=>'P18_NOTES'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(514982042511263491)
,p_prompt=>'Notes'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>2
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129146989663330359)
,p_name=>'P18_CREATED_BY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(257771730113002425)
,p_prompt=>'Created By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e',
'where person_id > 10'))
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129147341794330359)
,p_name=>'P18_CREATED_ON'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(257771730113002425)
,p_prompt=>'Created On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129147765474330359)
,p_name=>'P18_UPDATED_BY'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(257771730113002425)
,p_prompt=>'Updated By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e',
'where person_id > 10'))
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129148107505330358)
,p_name=>'P18_UPDATED_ON'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(257771730113002425)
,p_prompt=>'Updated On'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(129035778235007640)
,p_computation_sequence=>10
,p_computation_item=>'P18_APPROVE_LABEL'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  case action_required when ''Approve/Reject''   then ''Approve''',
'                                                when ''Recommend/Return'' then ''Recommend''',
'                                                when ''Forward/Return'' then ''Forward''',
'                                                when ''Review/Return''  then ''Review''',
'                                                else ''Approve''',
'        end approve_action',
'from dp_items_approval_history',
'where REQUEST_ID = :P18_ITEM_ID',
'and person_id = :PERSON_ID',
'and status = ''Pending''',
'and ROWNUM = 1'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(129035810732007641)
,p_computation_sequence=>20
,p_computation_item=>'P18_REJECT_LABEL'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  case action_required when ''Approve/Reject''   then ''Reject''',
'                                                when ''Recommend/Return'' then ''Return''',
'                                                when  ''Forward/Return''     then ''Returned''',
'                                                when ''Review/Return''  then ''Not Accepted''',
'                                                else ''Reject''',
'        end reject_action',
'from dp_items_approval_history',
'where REQUEST_ID = :P18_ITEM_ID',
'and person_id = :PERSON_ID',
'and status = ''Pending''',
'and ROWNUM = 1;'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(129182340365330323)
,p_name=>'New Project DA'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P18_PROJECT_NEW_YN'
,p_condition_element=>'P18_PROJECT_NEW_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'N'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(129183365242330323)
,p_event_id=>wwv_flow_api.id(129182340365330323)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P18_PROJECT_NEW_NAME'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(129184363008330322)
,p_event_id=>wwv_flow_api.id(129182340365330323)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P18_PROJECT_NEW_NAME'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(129182847272330323)
,p_event_id=>wwv_flow_api.id(129182340365330323)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P18_PROJECT_NUMBER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(129183813210330322)
,p_event_id=>wwv_flow_api.id(129182340365330323)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P18_PROJECT_NUMBER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(129184745720330322)
,p_name=>'ESTIMATED_BUDGET DA'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P18_ESTIMATED_BUDGET'
,p_condition_element=>'P18_ESTIMATED_BUDGET'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(129185265596330322)
,p_event_id=>wwv_flow_api.id(129184745720330322)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P18_ESTIMATED_BUDGET_BRACKET_ID'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  BRACKET_ID',
'from dp_budget_brackets',
'where :P18_ESTIMATED_BUDGET_H between MIN_VALUE and  MAX_VALUE'))
,p_attribute_07=>'P18_ESTIMATED_BUDGET_H'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(129186212118330321)
,p_event_id=>wwv_flow_api.id(129184745720330322)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P18_ESTIMATED_BUDGET_BRACKET_ID'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(129185790079330322)
,p_event_id=>wwv_flow_api.id(129184745720330322)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P18_ESTIMATED_BUDGET_BRACKET_ID'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(129186715350330321)
,p_event_id=>wwv_flow_api.id(129184745720330322)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P18_ESTIMATED_BUDGET_BRACKET_ID'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(129171466948330333)
,p_name=>'ESTIMATED_DATE_DEFINE DA'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P18_ESTIMATED_DATE_DEFINE'
,p_condition_element=>'P18_ESTIMATED_DATE_DEFINE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'N'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(129171928310330332)
,p_event_id=>wwv_flow_api.id(129171466948330333)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P18_ESTIMATED_DATE,P18_ESTIMATED'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(129173478844330332)
,p_event_id=>wwv_flow_api.id(129171466948330333)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P18_ESTIMATED_DATE'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(129172967451330332)
,p_event_id=>wwv_flow_api.id(129171466948330333)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P18_ESTIMATED_DATE,P18_ESTIMATED'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(129173993087330331)
,p_event_id=>wwv_flow_api.id(129171466948330333)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P18_ESTIMATED_QUARTER,P18_ESTIMATED_YEAR'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(129172452011330332)
,p_event_id=>wwv_flow_api.id(129171466948330333)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P18_ESTIMATED_QUARTER,P18_ESTIMATED_YEAR'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(129174498748330331)
,p_event_id=>wwv_flow_api.id(129171466948330333)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P18_ESTIMATED_QUARTER,P18_ESTIMATED_YEAR'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(129174844946330331)
,p_name=>'get Quarter DA'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P18_ESTIMATED_DATE'
,p_condition_element=>'P18_ESTIMATED_DATE'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(129175306319330331)
,p_event_id=>wwv_flow_api.id(129174844946330331)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P18_ESTIMATED'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Q'' || trim(to_char(to_date(:P18_ESTIMATED_DATE, ''dd-Mon-YYYY'' ) , ''Q''))',
'           || ''-'' ||',
'           trim(to_char(to_date(:P18_ESTIMATED_DATE, ''dd-Mon-YYYY'' ) , ''YYYY''))',
'           as xx',
'from dual;'))
,p_attribute_07=>'P18_ESTIMATED_DATE'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(129175757923330331)
,p_name=>'Budget Not Define DA'
,p_event_sequence=>60
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P18_ESTIMATED_BUDGET_DEFINE'
,p_condition_element=>'P18_ESTIMATED_BUDGET_DEFINE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'N'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(129176247072330330)
,p_event_id=>wwv_flow_api.id(129175757923330331)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P18_ESTIMATED_BUDGET'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(129177264231330330)
,p_event_id=>wwv_flow_api.id(129175757923330331)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P18_ESTIMATED_BUDGET'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(129176716663330330)
,p_event_id=>wwv_flow_api.id(129175757923330331)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P18_ESTIMATED_BUDGET'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(129177672980330330)
,p_name=>'Dialog Close'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(129164007420330343)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(129178132138330329)
,p_event_id=>wwv_flow_api.id(129177672980330330)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(258160849240337996)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(129178595048330329)
,p_name=>'Dialog Close 2'
,p_event_sequence=>80
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(258160849240337996)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(129179043320330324)
,p_event_id=>wwv_flow_api.id(129178595048330329)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(258160849240337996)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(129170622086330336)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialize DP Item Details'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    ITEM_ID,',
'    DP_ITEM_CODE,',
'--    DP_ITEM_NAME,',
'    INITIATIVE_ID,',
'    decode(PROJECT_NEW_YN, ''Y'', PROJECT_NEW_NAME, ''N'', PROJECT_NUMBER),	',
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
'    to_char(ESTIMATED_BUDGET,''99,999,999,999.99'') ESTIMATED_BUDGET,',
'    ESTIMATED_BUDGET,',
'    ESTIMATED_BUDGET_BRACKET_ID,',
'    NOTES,',
'    ESTIMATED_QUARTER',
'    || ''-'' ||',
'    ESTIMATED_YEAR estimated,',
'    trim(to_char(TOTAL_PROJECT_BUDGET,''99,999,999,999.99''))      TOTAL_PROJECT_BUDGET,',
'    TASK_NEW_YN,',
'    TASK_NUMBER,',
'    TASK_NUMBER_NEW,',
'    EXPENDITURE_TYPE,',
'    EXPENDITURE_TYPE_NEW,',
'-----',
'    PROJECT_TITLE,',
'    to_char(dct_util.add_bus_days(SUBMIT_REVIEW_ON, DP_ITEMS_UTIL.GET_SLA_DAYS(ESTIMATED_BUDGET)),''dd-MON-yyyy'')  expected_delivery_date,',
'    to_char(PROJECT_END_DATE , ''dd-MON-yyyy'')  PROJECT_END_DATE',
'    ',
'INTO',
'    :P18_ITEM_ID,',
'    :P18_DP_ITEM_CODE,',
' --   :P18_DP_ITEM_NAME,',
'    :P18_INITIATIVE_ID,',
'    :P18_PROJECT_NUMBER,	',
'    :P18_PROJECT_NEW_YN,',
'    :P18_PROJECT_NEW_NAME,',
'    :P18_PROJECT_DESCRIPTION,',
'    :P18_MAIN_CATEGORY_ID,',
'    :P18_CATEGORY_ID,',
'    :P18_SUB_CATEGORY_ID,',
'    :P18_END_USER_ID,',
'    :P18_SECTOR_ID,',
'    :P18_DEPARTMENT_ID,',
'    :P18_COST_CENTER,',
'    :P18_DP_ITEM_TYPE_ID,',
'    :P18_CONTRACT_NO,',
'    :P18_RISK_ID,',
'    :P18_PRIORITY_ID,',
'    :P18_DP_PROCUREMENT_METHOD,',
'    :P18_PLANNING_STATUS,',
'    :P18_REVIEW_STATUS,',
'    :P18_APPROVAL_STATUS,',
'    :P18_CUTT_OFF_DATE,',
'    :P18_CREATED_BY,',
'    :P18_CREATED_ON,',
'    :P18_UPDATED_BY,',
'    :P18_UPDATED_ON,',
'    :P18_ESTIMATED_DATE,',
'    :P18_ESTIMATED_YEAR,',
'    :P18_ESTIMATED_QUARTER,',
'    :P18_ESTIMATED_BUDGET,',
'    :P18_ESTIMATED_BUDGET_H,',
'    :P18_ESTIMATED_BUDGET_BRACKET_ID,',
'    :P18_NOTES,',
'    :P18_ESTIMATED,',
'    :P18_TOTAL_PROJECT_BUDGET,',
'    :P18_TASK_NEW_YN,',
'    :P18_TASK_NUMBER,',
'    :P18_TASK_NUMBER_NEW,',
'    :P18_EXPENDITURE_TYPE,',
'    :P18_EXPENDITURE_TYPE_NEW,',
'----',
'    :P18_PROJECT_TITLE,',
'    :P18_expected_delivery_date,',
'    :P18_PROJECT_END_DATE',
'FROM',
'    DP_ITEMS',
'WHERE item_id = :P18_ITEM_ID  ;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
