prompt --application/pages/page_09999
begin
--   Manifest
--     PAGE: 09999
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
 p_id=>9999
,p_user_interface_id=>wwv_flow_api.id(1686359760302353)
,p_name=>'Login Page'
,p_alias=>'LOGIN'
,p_step_title=>'i-finance - Sign In'
,p_warn_on_unsaved_changes=>'N'
,p_first_item=>'AUTO_FIRST_ITEM'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.t-Login-logo.fa {',
'	color: rgb(30, 30, 30);',
'}',
'',
'.t-Login-header {',
'	padding: 0px 0;',
'}',
'',
'.t-Login-region,',
'.t-MediaList {',
'	background: rgba(255, 255, 255, 0.65) !important;',
'}',
'',
'.t-Login-logo {',
'	background-image: url("&APP_IMAGES.contact.jpg");',
'	background-size: cover;',
'	border-radius: 50%;',
'	width: 100px;',
'	height: 100px;',
'	cursor: pointer;',
'}',
'',
'#fabe-img {',
'	width: 100%;',
'	height: 100%;',
'	background-image: url("#APP_IMAGES#fabe.PNG");',
'	background-position: center;',
'	background-size: contain;',
'	background-repeat: no-repeat;',
'}',
'',
'.t-Login-container{',
'		max-width: 90%;',
'		padding-left: 10%;',
'}',
'',
'.t-Login-containerBody{',
'display: table;',
'}',
''))
,p_step_template=>wwv_flow_api.id(1554403726302253)
,p_page_template_options=>'#DEFAULT#'
,p_page_is_public_y_n=>'Y'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231113215511'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1690327562302380)
,p_plug_name=>'i-finance'
,p_icon_css_classes=>'app-icon'
,p_region_template_options=>'#DEFAULT#:t-Login-region--headerTitle'
,p_plug_template=>wwv_flow_api.id(1600461131302282)
,p_plug_display_sequence=>20
,p_plug_grid_column_span=>4
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1695022676302390)
,p_plug_name=>'Language Selector'
,p_parent_plug_id=>wwv_flow_api.id(1690327562302380)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(1574322396302267)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_source=>'apex_lang.emit_language_selector_list;'
,p_plug_source_type=>'NATIVE_PLSQL'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1841568537558721)
,p_plug_name=>'Slider'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-cycle5s:t-Region--carouselSpin:i-h640:t-Region--hideHeader:t-Region--noBorder:t-Region--hiddenOverflow'
,p_plug_template=>wwv_flow_api.id(1577592004302269)
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>11
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1841675641558722)
,p_plug_name=>'S1'
,p_parent_plug_id=>wwv_flow_api.id(1841568537558721)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(1601776079302283)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source=>'<img src="#WORKSPACE_IMAGES#Qasr Al Hosn 2.jpg" width="100%" height="100%">'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1841773231558723)
,p_plug_name=>'S2'
,p_parent_plug_id=>wwv_flow_api.id(1841568537558721)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(1601776079302283)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_source=>'<img src="#WORKSPACE_IMAGES#Sheikh Zayed Bridge.jpg" width="100%" height="100%">'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1841866110558724)
,p_plug_name=>'S3'
,p_parent_plug_id=>wwv_flow_api.id(1841568537558721)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(1601776079302283)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_source=>'<img src="#WORKSPACE_IMAGES#Abu Dhabi Qasr Al Watan.jpg" width="100%" height="100%">'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1841976565558725)
,p_plug_name=>'S4'
,p_parent_plug_id=>wwv_flow_api.id(1841568537558721)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(1601776079302283)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_source=>'<img src="#WORKSPACE_IMAGES#Zayed-banner.png" width="100%" height="100%">'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(20783887485193930)
,p_plug_name=>'Help'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(1601776079302283)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(20783997639193931)
,p_plug_name=>'Image'
,p_parent_plug_id=>wwv_flow_api.id(20783887485193930)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noUI:t-Region--scrollBody:t-Form--noPadding:margin-right-none'
,p_plug_template=>wwv_flow_api.id(1601776079302283)
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>4
,p_plug_display_point=>'BODY'
,p_plug_source=>'<img src="#WORKSPACE_IMAGES#ask-for-help.jpg" style="width:100%;height:100%;>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(20784074409193932)
,p_plug_name=>'emails'
,p_parent_plug_id=>wwv_flow_api.id(20783887485193930)
,p_region_template_options=>'t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody:margin-left-none'
,p_plug_template=>wwv_flow_api.id(1601776079302283)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<h4>For any help, please contact:</h4>',
'<table style="border-collapse: collapse; width: 100%; height: 90px;" border="1">',
'<tbody>',
'<tr style="height: 18px;">',
'<td style="width: 20.5966%; height: 18px;">Petty Cash</td>',
'<td style="width: 79.4034%; height: 18px;"><a href="mailto:IMaharmeh@dctabudhabi.ae">Israa Imad Maharmeh</a> &nbsp;(AP Operations)</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 20.5966%; height: 18px;">Duty Hub</td>',
'<td style="width: 79.4034%; height: 18px;">',
'<p><a href="mailto:MANuaimi@dctabudhabi.ae">Maitha Ali AlNuaimi</a> &nbsp;(Rewards &amp; Recognition - P&amp;P)</p>',
'<p><a href="mailto:ahyhammadi@dctabudhabi.ae">Ahmed Younus Alhammadi</a> &nbsp;(Payroll - Finance)</p>',
'</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 20.5966%; height: 18px;">Credit Cards</td>',
'<td style="width: 79.4034%; height: 18px;"><a href="mailto:HSalim@dctabudhabi.ae">Hebah Omar Salim</a> &nbsp;(Treasury - Finance)</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 20.5966%; height: 18px;">Manual PR</td>',
'<td style="width: 79.4034%; height: 18px;"><a href="mailto:CSekhar@dctabudhabi.ae">Chandra Sekhar</a> &nbsp;(Supply Chain)</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 20.5966%; height: 18px;">System Admin</td>',
'<td style="width: 79.4034%; height: 18px;"><a href="mailto:Hghareb@dctabudhabi.ae">Hany Ghareb</a> (Finance)</td>',
'</tr>',
'</tbody>',
'</table>'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(84246486358149297)
,p_plug_name=>'Finance Documents'
,p_parent_plug_id=>wwv_flow_api.id(20783887485193930)
,p_icon_css_classes=>'fa-file-word-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--scrollBody:t-Form--slimPadding'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(1601776079302283)
,p_plug_display_sequence=>50
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
 p_id=>wwv_flow_api.id(84246709741149299)
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>84246709741149299
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42156229609196650)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42156617908196650)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42157081660196650)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42157499962196651)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Document'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42157895071196651)
,p_db_column_name=>'TAGS'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42158258675196651)
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
 p_id=>wwv_flow_api.id(42158641356196651)
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
 p_id=>wwv_flow_api.id(42159055764196651)
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
 p_id=>wwv_flow_api.id(42159404632196651)
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
 p_id=>wwv_flow_api.id(42160142491196652)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42160558478196652)
,p_db_column_name=>'FILENAME_WORD'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Filename Word'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42160960975196652)
,p_db_column_name=>'FILE_MIMETYPE_WORD'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'File Mimetype Word'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42161336503196652)
,p_db_column_name=>'FILE_BLOB_WORD'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'File Blob Word'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42161749084196652)
,p_db_column_name=>'DOWNLOAD_WORD'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Download'
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
,p_format_mask=>'DOWNLOAD:DCT_TEMPLATES:FILE_BLOB_WORD:ID::FILE_MIMETYPE_WORD:FILENAME_WORD:UPDATED_ON:FILE_CHARSET:attachment:Word:'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42162100078196653)
,p_db_column_name=>'FILENAME_PDF'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'File name Pdf'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42162534070196653)
,p_db_column_name=>'FILE_MIMETYPE_PDF'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'File Mimetype Pdf'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42162933569196653)
,p_db_column_name=>'FILE_CHARSET_PDF'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'File Charset Pdf'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42163376860196653)
,p_db_column_name=>'FILE_BLOB_PDF'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'File Blob Pdf'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42163708677196653)
,p_db_column_name=>'DOWNLOAD_PDF'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Download'
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
,p_format_mask=>'DOWNLOAD:DCT_TEMPLATES:FILE_BLOB_PDF:ID::FILE_MIMETYPE_PDF:FILENAME_PDF:UPDATED_ON:FILE_CHARSET_PDF:attachment:PDF:'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(84307706610335496)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'421641'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:FILE_COMMENTS:UPDATED_ON:DOWNLOAD_WORD:FILE_MIMETYPE_PDF:FILE_CHARSET_PDF:DOWNLOAD_PDF'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1755245885576602)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(1690327562302380)
,p_button_name=>'reset'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--danger:t-Button--link:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(1663835798302321)
,p_button_image_alt=>'forget your password ?'
,p_button_position=>'BODY'
,p_button_redirect_url=>'f?p=&APP_ID.:9998:&SESSION.::&DEBUG.:RR,9998::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1693160085302389)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(1690327562302380)
,p_button_name=>'LOGIN'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(1663835798302321)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Sign In'
,p_button_position=>'REGION_TEMPLATE_NEXT'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1690720202302382)
,p_name=>'P9999_USERNAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(1690327562302380)
,p_prompt=>'Username'
,p_placeholder=>'Username'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>40
,p_cMaxlength=>100
,p_field_template=>wwv_flow_api.id(1662433208302318)
,p_item_icon_css_classes=>'fa-user'
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1691127939302383)
,p_name=>'P9999_PASSWORD'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(1690327562302380)
,p_prompt=>'Password'
,p_placeholder=>'Password'
,p_display_as=>'NATIVE_PASSWORD'
,p_cSize=>40
,p_cMaxlength=>100
,p_field_template=>wwv_flow_api.id(1662433208302318)
,p_item_icon_css_classes=>'fa-key'
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1692261466302386)
,p_name=>'P9999_REMEMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(1690327562302380)
,p_prompt=>'Remember username'
,p_display_as=>'NATIVE_CHECKBOX'
,p_named_lov=>'LOGIN_REMEMBER_USERNAME'
,p_lov=>'.'||wwv_flow_api.id(1691451515302383)||'.'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(1662433208302318)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'If you select this checkbox, the application will save your username in a persistent browser cookie named "LOGIN_USERNAME_COOKIE".',
'When you go to the login page the next time,',
'the username field will be automatically populated with this value.',
'</p>',
'<p>',
'If you deselect this checkbox and your username is already saved in the cookie,',
'the application will overwrite it with an empty value.',
'You can also use your browser''s developer tools to completely remove the cookie.',
'</p>'))
,p_attribute_01=>'1'
,p_item_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'server condition was PL/SQL Expression:',
'apex_authentication.persistent_cookies_enabled'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1842132726558727)
,p_name=>'New'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1842260185558728)
,p_event_id=>wwv_flow_api.id(1842132726558727)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'PLUGIN_RW.APEX.VANTA.JS.PLUGIN'
,p_affected_elements_type=>'JQUERY_SELECTOR'
,p_affected_elements=>'body'
,p_attribute_01=>'cells'
,p_attribute_02=>wwv_flow_string.join(wwv_flow_t_varchar2(
'{',
'  "mouseControls": true,',
'  "touchControls": true,',
'  "minHeight": 200.00,',
'  "minWidth": 200.00,',
'  "scale": 1.00,',
'  "scaleMobile": 1.00',
'}'))
,p_attribute_07=>wwv_flow_string.join(wwv_flow_t_varchar2(
'{',
'  "color1": "#505f6d",',
'  "color2": "#296c9b",',
'  "size": 1.5,',
'  "speed": 0.9',
'}'))
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1693989489302389)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Set Username Cookie'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex_authentication.send_login_username_cookie (',
'    p_username => lower(:P9999_USERNAME),',
'    p_consent  => :P9999_REMEMBER = ''Y'' );'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1693549391302389)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Login'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex_authentication.login(',
'    p_username => :P9999_USERNAME,',
'    p_password => :P9999_PASSWORD,',
'    p_uppercase_username => TRUE);',
'    ',
''))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1694724592302390)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_SESSION_STATE'
,p_process_name=>'Clear Page(s) Cache'
,p_attribute_01=>'CLEAR_CACHE_CURRENT_PAGE'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1694355303302390)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Get Username Cookie'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P9999_USERNAME := apex_authentication.get_login_username_cookie;',
':P9999_REMEMBER := case when :P9999_USERNAME is not null then ''Y'' end;'))
);
wwv_flow_api.component_end;
end;
/
