prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
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
 p_id=>1
,p_user_interface_id=>wwv_flow_api.id(1686359760302353)
,p_name=>'Home'
,p_alias=>'HOME'
,p_step_title=>'i-finance'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230926145917'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1697198465302398)
,p_plug_name=>'i-finance Home'
,p_icon_css_classes=>'app-icon'
,p_region_template_options=>'#DEFAULT#:t-HeroRegion--hideIcon'
,p_plug_template=>wwv_flow_api.id(1592170296302278)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_source=>'Smart Finance Solution'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(4167429088848401)
,p_name=>'Home Menu'
,p_template=>wwv_flow_api.id(1601776079302283)
,p_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--hiddenOverflow'
,p_component_template_options=>'#DEFAULT#:u-colors:t-Cards--displaySubtitle:t-Cards--featured t-Cards--block force-fa-lg:t-Cards--displayIcons:t-Cards--4cols:t-Cards--animColorFill'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CARD_TITLE, CARD_SUBTITLE, CARD_TEXT, CARD_SUBTEXT, CARD_MODIFIERS, APP_ID, PAGE_ID, CARD_LINK, CARD_COLOR, CARD_ICON, CARD_INITIALS, STATUS, DESCRIPTION, CREATED, CREATED_BY, UPDATED, UPDATED_BY',
'from',
'(select ',
'       CARD_TITLE,',
'       CARD_SUBTITLE,',
'       CARD_TEXT,',
'       CARD_SUBTEXT,',
'       nvl(CARD_MODIFIERS,''ss'') CARD_MODIFIERS,',
'       APP_ID,',
'       PAGE_ID,',
'       apex_page.get_url(  p_application  =>  APP_ID , p_page   =>  PAGE_ID  )    CARD_LINK,',
'       CARD_COLOR,',
'       CARD_ICON,',
'       CARD_INITIALS,',
'       STATUS,',
'       DESCRIPTION,',
'       CREATED,',
'       CREATED_BY,',
'       UPDATED,',
'       UPDATED_BY,',
'       order_no',
'  from MENUS m',
'  where m.menu_id in (  select mr.menu_id ',
'                        from MENU_ROLES mr',
'                        where mr.menu_id = m.menu_id',
'                        and mr.role_id in (SELECT entity_id',
'                                            FROM DCT_DATA_ACCESS_ASSIGNMENT',
'                                            where person_id  = :PERSON_ID',
'                                            and entity_type_id = ''ROLE''',
'                                            and DCT_DATA_ACCESS_ASSIGNMENT.status = ''A''',
'                                            and sysdate between nvl(START_DATE, sysdate -10) and nvl(END_DATE,sysdate +10)',
'                                            )',
'                        and mr.status = ''A''',
'                         )',
'    and m.status = ''A''          ',
'UNION',
'-- to show manager checks for end users person_id in Managers_checks table',
'select       CARD_TITLE,',
'       CARD_SUBTITLE,',
'       CARD_TEXT,',
'       CARD_SUBTEXT,',
'       nvl(CARD_MODIFIERS,''ss'') CARD_MODIFIERS,',
'       APP_ID,',
'       PAGE_ID,',
'       apex_page.get_url(  p_application  =>  APP_ID , p_page   =>  PAGE_ID  )    CARD_LINK,',
'       CARD_COLOR,',
'       CARD_ICON,',
'       CARD_INITIALS,',
'       STATUS,',
'       DESCRIPTION,',
'       CREATED,',
'       CREATED_BY,',
'       UPDATED,',
'       UPDATED_BY,',
'       order_no',
'  from MENUS m',
'WHERE m.menu_id = 81',
' and status = ''A''',
'and EXISTS (select 1  from manager_checks where manager_checks.end_user_person_id = :PERSON_ID)',
')',
'',
'  order by order_no;',
''))
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(1617641641302292)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4169659294848423)
,p_query_column_id=>1
,p_column_alias=>'CARD_TITLE'
,p_column_display_sequence=>1
,p_column_heading=>'Card Title'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4169788318848424)
,p_query_column_id=>2
,p_column_alias=>'CARD_SUBTITLE'
,p_column_display_sequence=>2
,p_column_heading=>'Card Subtitle'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4169873776848425)
,p_query_column_id=>3
,p_column_alias=>'CARD_TEXT'
,p_column_display_sequence=>3
,p_column_heading=>'Card Text'
,p_use_as_row_header=>'N'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4169974066848426)
,p_query_column_id=>4
,p_column_alias=>'CARD_SUBTEXT'
,p_column_display_sequence=>4
,p_column_heading=>'Card Subtext'
,p_use_as_row_header=>'N'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4170099404848427)
,p_query_column_id=>5
,p_column_alias=>'CARD_MODIFIERS'
,p_column_display_sequence=>5
,p_column_heading=>'Card Modifiers'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5067995645045109)
,p_query_column_id=>6
,p_column_alias=>'APP_ID'
,p_column_display_sequence=>10
,p_column_heading=>'App Id'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5068004203045110)
,p_query_column_id=>7
,p_column_alias=>'PAGE_ID'
,p_column_display_sequence=>11
,p_column_heading=>'Page Id'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5067839930045108)
,p_query_column_id=>8
,p_column_alias=>'CARD_LINK'
,p_column_display_sequence=>9
,p_column_heading=>'Card Link'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4170249198848429)
,p_query_column_id=>9
,p_column_alias=>'CARD_COLOR'
,p_column_display_sequence=>6
,p_column_heading=>'Card Color'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4170334883848430)
,p_query_column_id=>10
,p_column_alias=>'CARD_ICON'
,p_column_display_sequence=>7
,p_column_heading=>'Card Icon'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4170489240848431)
,p_query_column_id=>11
,p_column_alias=>'CARD_INITIALS'
,p_column_display_sequence=>8
,p_column_heading=>'Card Initials'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5068176465045111)
,p_query_column_id=>12
,p_column_alias=>'STATUS'
,p_column_display_sequence=>12
,p_column_heading=>'Status'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5068240437045112)
,p_query_column_id=>13
,p_column_alias=>'DESCRIPTION'
,p_column_display_sequence=>13
,p_column_heading=>'Description'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5068389393045113)
,p_query_column_id=>14
,p_column_alias=>'CREATED'
,p_column_display_sequence=>14
,p_column_heading=>'Created'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5068432478045114)
,p_query_column_id=>15
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>15
,p_column_heading=>'Created By'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5068535673045115)
,p_query_column_id=>16
,p_column_alias=>'UPDATED'
,p_column_display_sequence=>16
,p_column_heading=>'Updated'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5068626092045116)
,p_query_column_id=>17
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>17
,p_column_heading=>'Updated By'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(40338582710977029)
,p_plug_name=>'Petty cash Availability'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noUI:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(1601776079302283)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'	<marquee width="90%" direction="left" scrollamount="8">',
'<b style="color:red;"> As per DOF Instructions, The last day to process Petty cash requests and reimbursement requests will be by Monday 20-Dec-2021. Please make sure to process all your requests before.</B> For any help, please contact: <a href="mai'
||'lto:HSleiman@dctabudhabi.ae">Hiba Hassan Sleiman</a>.',
'</marquee>'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'NEVER'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(84256970700189775)
,p_plug_name=>'Finance Documents'
,p_icon_css_classes=>'fa-file-word-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(1601776079302283)
,p_plug_display_sequence=>30
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
 p_id=>wwv_flow_api.id(84257194083189777)
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>84257194083189777
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42166751445237127)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42167103669237128)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42167577769237128)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42167944220237128)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Document'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42168344634237128)
,p_db_column_name=>'TAGS'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42168781321237128)
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
 p_id=>wwv_flow_api.id(42169166826237128)
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
 p_id=>wwv_flow_api.id(42169567852237129)
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
 p_id=>wwv_flow_api.id(42169925349237129)
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
 p_id=>wwv_flow_api.id(42170345895237129)
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
 p_id=>wwv_flow_api.id(42170716027237129)
,p_db_column_name=>'FILENAME_WORD'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Filename Word'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42171120937237129)
,p_db_column_name=>'FILE_MIMETYPE_WORD'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'File Mimetype Word'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42171584663237130)
,p_db_column_name=>'FILE_BLOB_WORD'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'File Blob Word'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42171931196237130)
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
 p_id=>wwv_flow_api.id(42172346397237130)
,p_db_column_name=>'FILENAME_PDF'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'File name Pdf'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42172784849237130)
,p_db_column_name=>'FILE_MIMETYPE_PDF'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'File Mimetype Pdf'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42173105775237130)
,p_db_column_name=>'FILE_CHARSET_PDF'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'File Charset Pdf'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42173535956237130)
,p_db_column_name=>'FILE_BLOB_PDF'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'File Blob Pdf'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42173954803237131)
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
 p_id=>wwv_flow_api.id(84318190952375974)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'421743'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:FILE_COMMENTS:UPDATED_ON:DOWNLOAD_WORD:FILE_MIMETYPE_PDF:FILE_CHARSET_PDF:DOWNLOAD_PDF'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(7950097388144835)
,p_branch_name=>'Go To Change Password'
,p_branch_action=>'f?p=&APP_ID.:9996:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'BEFORE_HEADER'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'FUNCTION_BODY'
,p_branch_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_change    varchar2(1);',
'begin',
'',
'select change_password',
'into l_change',
'from dct_employees_list2',
'where user_name = :APP_USER;',
'',
'    if l_change = ''Y'' then',
'        return true;',
'    else',
'        return false;',
'    end if;',
'end;'))
);
wwv_flow_api.component_end;
end;
/
