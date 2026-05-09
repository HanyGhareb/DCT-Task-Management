prompt --application/pages/page_00038
begin
--   Manifest
--     PAGE: 00038
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
 p_id=>38
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Expense Report Details - Notifications'
,p_alias=>'EXPENSE-REPORT-DETAILS-NOTIFICATIONS'
,p_step_title=>'Expense Report Details - Notifications'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'		',
'		/* Scroll Results Only in Side Column */',
'.t-Body-side {',
'    display: flex;',
'    flex-direction: column;',
'    overflow: hidden;',
'}',
'.search-results {',
'    flex: 1;',
'    overflow: auto;',
'}',
'/* Format Search Region */',
'.search-region {',
'    border-bottom: 1px solid rgba(0,0,0,.1);',
'    flex-shrink: 0;',
'}',
'',
'.t-Region-header{',
'                background-color:#0e6655;',
'                color:black;',
'                }',
'.t-Region-title{',
'            color:black;',
'            font-weighfont-weight: bold;',
'                }',
'',
'/* Custom Header color */',
'#inside-page .t-Region-header{',
'    background-color :#81d0b5;',
'    font-weighfont-weight: bold;',
'}',
'',
'',
'/* Set Header Panel */',
'.t-Header-branding {',
'    background-color: #0e6655;',
'}',
'',
'',
'/* Set Breadcrumb   */',
'.t-Body-title {',
'',
'    background-color: #EEE;',
'    color:#404040;',
'}',
'',
'/* Add Button - White */',
'.t-Region-header, .t-Region-header .t-Button--link, .t-Region-header .t-Button--noUI {',
'    color:  #FFF;',
'}',
'',
'/* New Plan Button */',
'.a-Button--hot, .t-Button--hot:not(.t-Button--simple), body .ui-button.ui-button--hot, body .ui-state-default.ui-priority-primary {',
'',
'    background-color: #0e6655;',
'    color:#fff;',
'}',
'',
'',
'/*  Table Row Selected */',
'.a-GV-table tr.is-selected .a-GV-cell {',
'    background-color: #CEF6CE;',
'}',
'',
'/* Audit Region */',
'#history    .t-Region-header {',
'     background-color: #cae6e3;',
'    color:#000;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220218065945'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(7241474546148665)
,p_plug_name=>'Expense Report Details'
,p_region_name=>'inside-page'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'EXPENSE_REPORTS_ALL_V'
,p_include_rowid_column=>false
,p_is_editable=>false
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_read_only_when_type=>'ALWAYS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(15568970452901244)
,p_plug_name=>'Expense Report has been Rejected.'
,p_region_template_options=>'#DEFAULT#:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--danger'
,p_plug_template=>wwv_flow_api.id(8026775276175496)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P38_ID'
,p_plug_display_when_cond2=>'Rejected'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(39382822100375804)
,p_plug_name=>'Expense Report has been Invoiced.'
,p_region_template_options=>'#DEFAULT#:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--info'
,p_plug_template=>wwv_flow_api.id(8026775276175496)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P38_NOTE_HEADER'
,p_plug_display_when_cond2=>'Expense Report Invoiced'
,p_plug_read_only_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_read_only_when=>'P38_NOTE_HEADER'
,p_plug_read_only_when2=>'Expense Report Invoiced'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(39519923958190496)
,p_plug_name=>'Expense Report has been Paid Successfully..'
,p_region_template_options=>'#DEFAULT#:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--success'
,p_plug_template=>wwv_flow_api.id(8026775276175496)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P38_NOTE_HEADER'
,p_plug_display_when_cond2=>'Expense Report Paid'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(39520739973190505)
,p_plug_name=>'Expense Report has been Approved.'
,p_region_template_options=>'#DEFAULT#:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--success'
,p_plug_template=>wwv_flow_api.id(8026775276175496)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P38_ID'
,p_plug_display_when_cond2=>'Approved'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(47460346473249920)
,p_name=>'Lines'
,p_region_name=>'inside-page'
,p_template=>wwv_flow_api.id(8057862405175507)
,p_display_sequence=>70
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_css_classes=>'js-detail-region'
,p_icon_css_classes=>'fa-list'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'t-Report--stretch:#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight:t-Report--inline'
,p_grid_column_span=>9
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'HRSS_EXPENSE_REPORT_LINES'
,p_query_where=>'"EXPENSE_REPORT_ID" = :P38_EXPENSE_REPORT_ID'
,p_include_rowid_column=>true
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P38_EXPENSE_REPORT_ID'
,p_query_row_template=>wwv_flow_api.id(8084165237175515)
,p_query_num_rows=>100
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No data found.'
,p_query_row_count_max=>5000
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7449111257835482)
,p_query_column_id=>1
,p_column_alias=>'ROWID'
,p_column_display_sequence=>1
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7449547385835482)
,p_query_column_id=>2
,p_column_alias=>'LINE_ID'
,p_column_display_sequence=>2
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7449927912835483)
,p_query_column_id=>3
,p_column_alias=>'EXPENSE_REPORT_ID'
,p_column_display_sequence=>3
,p_column_heading=>'Expense Report Id'
,p_heading_alignment=>'LEFT'
,p_hidden_column=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7450296401835483)
,p_query_column_id=>4
,p_column_alias=>'EXPENSE_DATE'
,p_column_display_sequence=>4
,p_column_heading=>'Expense Date'
,p_use_as_row_header=>'N'
,p_column_format=>'DD-MON-YYYY'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7450739024835483)
,p_query_column_id=>5
,p_column_alias=>'RECEIPT_AMOUNT'
,p_column_display_sequence=>5
,p_column_heading=>'Receipt Amount'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7451100911835483)
,p_query_column_id=>6
,p_column_alias=>'EXPENSE_TYPE'
,p_column_display_sequence=>6
,p_column_heading=>'Expense Type'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7451475503835483)
,p_query_column_id=>7
,p_column_alias=>'JUSTIFICATION'
,p_column_display_sequence=>7
,p_column_heading=>'Justification'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7451863407835484)
,p_query_column_id=>8
,p_column_alias=>'COMMENT_TO_APPROVER'
,p_column_display_sequence=>8
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7452318134835484)
,p_query_column_id=>9
,p_column_alias=>'CREATION_DATE'
,p_column_display_sequence=>9
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7452748343835484)
,p_query_column_id=>10
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7453063761835484)
,p_query_column_id=>11
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>11
,p_column_heading=>'Updated By'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7453511944835484)
,p_query_column_id=>12
,p_column_alias=>'UPDATED_DATE'
,p_column_display_sequence=>12
,p_column_heading=>'Updated Date'
,p_use_as_row_header=>'N'
,p_column_format=>'DD-MON-YYYY HH:MIPM'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(76440385288829762)
,p_plug_name=>'Documents'
,p_region_name=>'inside-page'
,p_icon_css_classes=>'fa-book fa-anim-flash'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>80
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_span=>8
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(76440522441829763)
,p_plug_name=>'Documents Report'
,p_parent_plug_id=>wwv_flow_api.id(76440385288829762)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8055912915175506)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ROW_VERSION_NUMBER,',
'       EXPENSE_REPORT_ID,',
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
'       sys.dbms_lob.getlength(file_blob) as file_size,',
'    sys.dbms_lob.getlength(file_blob) as download',
'  from EXPENSE_REPORT_DOCUMENTS',
' where EXPENSE_REPORT_ID = ( select request_id',
'                         from all_notifications',
'                         where id = :P38_ID)',
' order by created desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P38_ID'
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
 p_id=>wwv_flow_api.id(76440729725829765)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'There is no attachments. '
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>78430768052893529
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7183163837130762)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7183568532130763)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7184020661130764)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'C'
,p_column_label=>'File Name'
,p_column_link=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.::P20_ID,P20_EXPENSE_REPORT_ID,P20_EXPENSE_REPORT_APPROVAL_STATUS:#ID#,#EXPENSE_REPORT_ID#,&P38_EXPENSE_REPORT_APPROVAL_STATUS.'
,p_column_linktext=>'#FILENAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7184391859130764)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'D'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7184780201130764)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7185249090130764)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>70
,p_column_identifier=>'F'
,p_column_label=>'File Blob'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'OTHER'
,p_rpt_show_filter_lov=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7185602371130765)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'G'
,p_column_label=>'File Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7185991336130765)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'H'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7186415401130765)
,p_db_column_name=>'CREATED'
,p_display_order=>100
,p_column_identifier=>'I'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7186769476130765)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'J'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7187222480130766)
,p_db_column_name=>'UPDATED'
,p_display_order=>120
,p_column_identifier=>'K'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7187571626130766)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'L'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7188038581130766)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>140
,p_column_identifier=>'M'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7188449643130767)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>150
,p_column_identifier=>'N'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:EXPENSE_REPORT_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7241362428148664)
,p_db_column_name=>'EXPENSE_REPORT_ID'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Expense Report Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(76577416608530897)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'91792'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(76442686235829785)
,p_plug_name=>'Collaboration'
,p_region_name=>'inside-page'
,p_icon_css_classes=>'fa-comments-o fa-anim-flash fam-sleep fam-is-success'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>60
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>4
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(76442851203829787)
,p_name=>'Messages Report'
,p_region_name=>'projectUpdates'
,p_parent_plug_id=>wwv_flow_api.id(76442686235829785)
,p_template=>wwv_flow_api.id(8030481219175499)
,p_display_sequence=>10
,p_region_css_classes=>'updates-region'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Comments--chat'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select',
'  CASE',
'        WHEN dbms_lob.getlength(photo_blob) > 0 THEN',
'          ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(user_name)',
'        ELSE',
'            ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'    END  user_icon,',
'  creation_date  comment_date,',
'  (select e.full_name_en',
'    from dct_employees_list2 e',
'    where e.user_name = created_by) user_name,',
'  comment_text                    comment_text,',
'  null comment_modifiers,',
'  ''u-color-''||ora_hash(created_by,45) icon_modifier,',
'  action     actions,',
'  ''''     attribute_1,',
'  ''''     attribute_2,',
'  ''''    attribute_3,',
'  ''''    attribute_4,',
'  comment_id',
'from',
'  (SELECT',
'    c.comment_id,',
'    c.expense_report_id,',
'    c.comment_text,',
'    c.created_by,',
'    c.updated_by,',
'    c.creation_date,',
'    c.updated_date,',
'    c.action,',
'    e.user_name,',
'    e.photo_blob    ',
'FROM',
'    hrss_expense_report_comments c , dct_employees_list2 e',
'where c.updated_by = e.user_name    )',
'where expense_report_id = :P38_EXPENSE_REPORT_ID',
'order by UPDATED_DATE desc;',
''))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P38_EXPENSE_REPORT_ID'
,p_query_row_template=>wwv_flow_api.id(8086778490175517)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No Communications yet.'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7190625184130771)
,p_query_column_id=>1
,p_column_alias=>'USER_ICON'
,p_column_display_sequence=>1
,p_column_heading=>'User Icon'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<img src="#USER_ICON#" alt="Image Not Found" height="40" width="40">'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7191000762130771)
,p_query_column_id=>2
,p_column_alias=>'COMMENT_DATE'
,p_column_display_sequence=>2
,p_column_heading=>'Comment Date'
,p_use_as_row_header=>'N'
,p_column_format=>'SINCE'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7191429004130772)
,p_query_column_id=>3
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>3
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7191794639130772)
,p_query_column_id=>4
,p_column_alias=>'COMMENT_TEXT'
,p_column_display_sequence=>4
,p_column_heading=>'Comment Text'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7192226163130773)
,p_query_column_id=>5
,p_column_alias=>'COMMENT_MODIFIERS'
,p_column_display_sequence=>5
,p_column_heading=>'Comment Modifiers'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7192654027130773)
,p_query_column_id=>6
,p_column_alias=>'ICON_MODIFIER'
,p_column_display_sequence=>6
,p_column_heading=>'Icon Modifier'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7193032621130773)
,p_query_column_id=>7
,p_column_alias=>'ACTIONS'
,p_column_display_sequence=>7
,p_column_heading=>'Actions'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7193365960130773)
,p_query_column_id=>8
,p_column_alias=>'ATTRIBUTE_1'
,p_column_display_sequence=>8
,p_column_heading=>'Attribute 1'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7193861583130774)
,p_query_column_id=>9
,p_column_alias=>'ATTRIBUTE_2'
,p_column_display_sequence=>9
,p_column_heading=>'Attribute 2'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7194194068130774)
,p_query_column_id=>10
,p_column_alias=>'ATTRIBUTE_3'
,p_column_display_sequence=>10
,p_column_heading=>'Attribute 3'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7194594093130774)
,p_query_column_id=>11
,p_column_alias=>'ATTRIBUTE_4'
,p_column_display_sequence=>11
,p_column_heading=>'Attribute 4'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7195050751130774)
,p_query_column_id=>12
,p_column_alias=>'COMMENT_ID'
,p_column_display_sequence=>12
,p_column_heading=>'Comment Id'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(76450987616846041)
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(76723605614529267)
,p_plug_name=>'Approval History'
,p_region_name=>'inside-page'
,p_icon_css_classes=>'fa-eye fa-anim-flash'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>90
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       REQUEST_ID,',
'       STEP_NO,',
'       ACTION_REQUIRED,',
'       pc.USER_NAME,',
'       STATUS,',
'       RECEVIED_DATE,',
'       ACTION_DATE,',
'       COMMENTS,',
'       APPROVAL_TYPE,',
'       CREATED_ON,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       (select e.full_name_en',
'        from dct_employees_list2 e',
'        where e.user_name = pc.UPDATED_BY) Employee_name',
'      , case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'           when 0  THEN',
'                ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'            else  ',
'                ',
'           ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(pc.user_name)',
'           end Photo  ',
'  from HRSS_EXPENSE_REPORT_APPROVAL_HISTORY pc , dct_employees_list2  e',
'where pc.user_name = e.user_name(+)',
'and REQUEST_ID = :P38_EXPENSE_REPORT_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Approval History'
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
 p_id=>wwv_flow_api.id(76723703294529268)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>78713741621593032
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7212581752130795)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7213028365130795)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7213390809130796)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Step No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7213802813130796)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7214251862130796)
,p_db_column_name=>'USER_NAME'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'User Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7214646955130797)
,p_db_column_name=>'STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7215039923130797)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7215383704130797)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7215786943130798)
,p_db_column_name=>'COMMENTS'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7216202326130798)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7216578297130798)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7216988270130798)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7217418435130799)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7217778501130799)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7218183875130800)
,p_db_column_name=>'EMPLOYEE_NAME'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Employee Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7218607271130800)
,p_db_column_name=>'PHOTO'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(97208124340703120)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'92090'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:ACTION_REQUIRED:EMPLOYEE_NAME:USER_NAME:STATUS:RECEVIED_DATE:ACTION_DATE::PHOTO'
,p_sort_column_1=>'STEP_NO'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'0'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(7219364082130801)
,p_report_id=>wwv_flow_api.id(97208124340703120)
,p_name=>'Current Status'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Pending'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Pending''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#D4F7D4'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(7181700432130756)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(76440385288829762)
,p_button_name=>'Add_File'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119283245175532)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add File'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.:20:P20_EXPENSE_REPORT_ID:&P38_EXPENSE_REPORT_ID.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(7189925228130768)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(76442686235829785)
,p_button_name=>'AddComment'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119283245175532)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Comment'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.::P21_EXPENSE_REPORT_ID,P5_ACTION:&P38_EXPENSE_REPORT_ID.,New'
,p_icon_css_classes=>'fa-envelope-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(7195750860130775)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(76450987616846041)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(7196069921130775)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(76450987616846041)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Ok'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-check'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(7238050581130829)
,p_branch_name=>'Go To Page 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7182100516130757)
,p_name=>'P38_NOTE_HEADER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(76440385288829762)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7182543936130760)
,p_name=>'P38_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(76440385288829762)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7241706353148667)
,p_name=>'P38_EXPENSE_REPORT_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'EXPENSE_REPORT_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7241774031148668)
,p_name=>'P38_PETTY_CASH_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'PETTY_CASH_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7241920718148669)
,p_name=>'P38_PETTY_CASH_NO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'PETTY_CASH_NO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7242037628148670)
,p_name=>'P38_PETTY_CASH_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Petty Cash Amount :</span>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'PETTY_CASH_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7242079748148671)
,p_name=>'P38_PETTY_CASH_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'PETTY_CASH_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7242246892148672)
,p_name=>'P38_PETTY_CASH_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'PETTY_CASH_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7242279742148673)
,p_name=>'P38_CLOSING_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'CLOSING_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7242411720148674)
,p_name=>'P38_EMPLOYEE_NUM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'EMPLOYEE_NUM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7242488432148675)
,p_name=>'P38_EMPLOYEE_SECTOR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'EMPLOYEE_SECTOR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7242591020148676)
,p_name=>'P38_EMPLOYEE_DEPARTMENT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'EMPLOYEE_DEPARTMENT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7242688576148677)
,p_name=>'P38_EMPLOYEE_ORGANIZATION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'EMPLOYEE_ORGANIZATION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7242820714148678)
,p_name=>'P38_EMPLOYEE_SUPERVISOR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'EMPLOYEE_SUPERVISOR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7242900415148679)
,p_name=>'P38_EMPLOYEE_SUPERVISOR_NUM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'EMPLOYEE_SUPERVISOR_NUM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7243036678148680)
,p_name=>'P38_GL_ACCOUNT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'GL_ACCOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7243084106148681)
,p_name=>'P38_GL_ACCOUNT_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'GL_ACCOUNT_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7243196747148682)
,p_name=>'P38_COST_CENTER_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'COST_CENTER_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7243275240148683)
,p_name=>'P38_GL_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'GL_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7243411204148684)
,p_name=>'P38_PROJECT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'PROJECT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7243510917148685)
,p_name=>'P38_TASK'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'TASK'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7243624239148686)
,p_name=>'P38_PETTY_CASH_PRIORITY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'PETTY_CASH_PRIORITY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7306689455469237)
,p_name=>'P38_PETTY_CASH_STATU'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>320
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'PETTY_CASH_STATU'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7306775229469238)
,p_name=>'P38_PETTY_CASH_APPROVAL_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>330
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'PETTY_CASH_APPROVAL_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7306899657469239)
,p_name=>'P38_PETTY_CASH_JUSTIFICATION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>340
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'PETTY_CASH_JUSTIFICATION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7307019197469240)
,p_name=>'P38_PETTY_CASH_PV_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>350
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'PETTY_CASH_PV_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7307148033469241)
,p_name=>'P38_PETTY_CASH_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>360
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'PETTY_CASH_CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7307201036469242)
,p_name=>'P38_PETTY_CASH_CREATION_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>370
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'PETTY_CASH_CREATION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7307353849469243)
,p_name=>'P38_PETTY_CASH_PAID_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>380
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'PETTY_CASH_PAID_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7307397213469244)
,p_name=>'P38_PETTY_CASH_INVOICING_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>390
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'PETTY_CASH_INVOICING_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7307543335469245)
,p_name=>'P38_PETTY_CASH_INVOICE_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>400
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'PETTY_CASH_INVOICE_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7307619758469246)
,p_name=>'P38_PETTY_CASH_INVOICE_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>410
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'PETTY_CASH_INVOICE_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7307677573469247)
,p_name=>'P38_PETTY_CASH_PAYMENT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>420
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'PETTY_CASH_PAYMENT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7307841197469248)
,p_name=>'P38_PETTY_CASH_PAYMENT_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>430
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'PETTY_CASH_PAYMENT_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7307922092469249)
,p_name=>'P38_EXPENSE_REPORT_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Date :</span>'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'EXPENSE_REPORT_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'button'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7307989988469250)
,p_name=>'P38_EXPENSE_REPORT_PURPOSE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'EXPENSE_REPORT_PURPOSE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7308149713469251)
,p_name=>'P38_EXPENSE_REPORT_APPROVAL_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Approval Status :</span>'
,p_source=>'EXPENSE_REPORT_APPROVAL_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7308174421469252)
,p_name=>'P38_EXPENSE_REPORT_INVOICING_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>440
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'EXPENSE_REPORT_INVOICING_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7308317219469253)
,p_name=>'P38_EXPENSE_REPORT_PRIORITY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'EXPENSE_REPORT_PRIORITY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7308438437469254)
,p_name=>'P38_EXPENSE_REPORT_JUSTIFICATION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Justification :</span>'
,p_source=>'EXPENSE_REPORT_JUSTIFICATION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>4000
,p_cHeight=>5
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7308528103469255)
,p_name=>'P38_EXPENSE_REPORT_COMMENT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>450
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'EXPENSE_REPORT_COMMENT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7308612366469256)
,p_name=>'P38_EXPENSE_REPORT_CREATION_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>460
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'EXPENSE_REPORT_CREATION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7308721133469257)
,p_name=>'P38_EXPENSE_REPORT_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>470
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'EXPENSE_REPORT_CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7308763296469258)
,p_name=>'P38_EXPENSE_REPORT_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>480
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'EXPENSE_REPORT_UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7308871906469259)
,p_name=>'P38_EXPENSE_REPORT_UPDATED_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>490
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'EXPENSE_REPORT_UPDATED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7308986212469260)
,p_name=>'P38_EXPENSE_REPORT_YEAR'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>500
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'EXPENSE_REPORT_YEAR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7309076240469261)
,p_name=>'P38_EXPENSE_REPORT_NUM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Expense Report# :</span>'
,p_source=>'EXPENSE_REPORT_NUM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>50
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7309239056469262)
,p_name=>'P38_EXPENSE_REPORT_PAID_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>510
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'EXPENSE_REPORT_PAID_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7309283748469263)
,p_name=>'P38_EXPENSE_REPORT_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>520
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'EXPENSE_REPORT_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7309417429469264)
,p_name=>'P38_EXPENSE_REPORT_ORG_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>530
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_source=>'EXPENSE_REPORT_ORG_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7309560753469265)
,p_name=>'P38_EXPENSE_REPORT_EMP_NUM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Emp# :</span>'
,p_source=>'EXPENSE_REPORT_EMP_NUM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>20
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7309603391469266)
,p_name=>'P38_EXPENSE_REPORT_EMP_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Name :</span>'
,p_source=>'EXPENSE_REPORT_EMP_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7309697951469267)
,p_name=>'P38_EXPENSE_REPORT_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_item_source_plug_id=>wwv_flow_api.id(7241474546148665)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Amount :</span>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'EXPENSE_REPORT_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7309859110469268)
,p_name=>'P38_PHOTO'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(7241474546148665)
,p_prompt=>'Photo'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'           when 0  THEN',
'                 ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'            else  ',
'                ',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'           end  Photo',
'from dct_employees_list2  e',
'where e.employee_num = :P38_EMPLOYEE_NUM'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_IMAGE'
,p_tag_attributes=>'style="border-radius: 50%;display: block;margin-right: auto;width: 40%;"'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(8118738374175531)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'URL'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(7228681724130821)
,p_name=>'Collaboration Dialog Close'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(76442686235829785)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7229251540130823)
,p_event_id=>wwv_flow_api.id(7228681724130821)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(76442851203829787)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(7229652753130824)
,p_name=>'Comments Dialog Closed'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(76442851203829787)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7230148800130824)
,p_event_id=>wwv_flow_api.id(7229652753130824)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(76442851203829787)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(7230466771130824)
,p_name=>'set approve color'
,p_event_sequence=>30
,p_condition_element=>'P38_ID'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Approved'
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7231028423130824)
,p_event_id=>wwv_flow_api.id(7230466771130824)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_CSS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P38_APPROVAL_STATUS'
,p_attribute_01=>'color'
,p_attribute_02=>'green'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7231466251130825)
,p_event_id=>wwv_flow_api.id(7230466771130824)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_CSS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P38_APPROVAL_STATUS'
,p_attribute_01=>'font-weight'
,p_attribute_02=>'bold'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(7231873010130825)
,p_name=>'set rejected color'
,p_event_sequence=>40
,p_condition_element=>'P38_ID'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Rejected'
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7232389458130825)
,p_event_id=>wwv_flow_api.id(7231873010130825)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_CSS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P38_APPROVAL_STATUS'
,p_attribute_01=>'color'
,p_attribute_02=>'red'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7232938372130825)
,p_event_id=>wwv_flow_api.id(7231873010130825)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_CSS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P38_APPROVAL_STATUS'
,p_attribute_01=>'font-weight'
,p_attribute_02=>'bolder'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(7233308807130826)
,p_name=>'set in-Progress color'
,p_event_sequence=>50
,p_condition_element=>'P38_ID'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'In-Progress'
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7233845128130826)
,p_event_id=>wwv_flow_api.id(7233308807130826)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_CSS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P38_APPROVAL_STATUS'
,p_attribute_01=>'color'
,p_attribute_02=>'GoldenRod'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7234338660130826)
,p_event_id=>wwv_flow_api.id(7233308807130826)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_CSS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P38_APPROVAL_STATUS'
,p_attribute_01=>'font-weight'
,p_attribute_02=>'bolder'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(7234663652130826)
,p_name=>'In-Progress'
,p_event_sequence=>70
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P38_APPROVAL_STATUS'
,p_condition_element=>'P38_APPROVAL_STATUS'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'In-progress'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7235257715130827)
,p_event_id=>wwv_flow_api.id(7234663652130826)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_CSS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P38_APPROVAL_STATUS'
,p_attribute_01=>'color'
,p_attribute_02=>'blue'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(7235617869130827)
,p_name=>'Close Notification'
,p_event_sequence=>80
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(7196069921130775)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7236108882130827)
,p_event_id=>wwv_flow_api.id(7235617869130827)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'UPDATE all_notifications',
'set acknowledge = ''Y''',
'where id = :P38_ID'))
,p_attribute_02=>'P38_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7236620722130827)
,p_event_id=>wwv_flow_api.id(7235617869130827)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'Close'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(7237039453130828)
,p_name=>'Closed Dialog Comments'
,p_event_sequence=>90
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(7189925228130768)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7237466202130828)
,p_event_id=>wwv_flow_api.id(7237039453130828)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(76442851203829787)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(7241587467148666)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(7241474546148665)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Expense Report Details - Notifications'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
