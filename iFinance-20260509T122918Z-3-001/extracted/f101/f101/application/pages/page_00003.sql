prompt --application/pages/page_00003
begin
--   Manifest
--     PAGE: 00003
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
 p_id=>3
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Petty Cash Details'
,p_alias=>'PETTY-CASH-DETAILS'
,p_step_title=>'Petty Cash Details'
,p_allow_duplicate_submissions=>'N'
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
'            font-weight: bold;',
'                }',
'',
'/* Custom Header color */',
'#inside-page .t-Region-header{',
'    background-color :#81d0b5;',
'    font-weight: bold;',
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
,p_deep_linking=>'Y'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231120225615'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(534928395427145)
,p_plug_name=>'Approval History'
,p_region_name=>'inside-page'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>60
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
'       e.full_name_en,',
'       case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'           when 0  THEN',
'                 ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'            else  ',
'                ',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(pc.user_name)',
'           end Photo',
'  from HRSS_APPROVAL_HISTORY pc,  dct_employees_list2  e',
'  where pc.user_name = e.user_name (+)',
'and  REQUEST_ID = :P3_PETTY_CASH_ID',
'order by step_no , ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P3_PETTY_CASH_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_plug_display_when_condition=>'P3_APPROVAL_STATUS'
,p_plug_display_when_cond2=>'Draft'
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
 p_id=>wwv_flow_api.id(535030081427146)
,p_max_row_count=>'1000000'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'ADMIN'
,p_internal_uid=>2525068408490910
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(535080437427147)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(535200971427148)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(535343002427149)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Step No'
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
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(536765236427164)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>40
,p_column_identifier=>'R'
,p_column_label=>'Name'
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
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(535704377427153)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>80
,p_column_identifier=>'G'
,p_column_label=>'Action Required'
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
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(535843865427154)
,p_db_column_name=>'USER_NAME'
,p_display_order=>90
,p_column_identifier=>'H'
,p_column_label=>'User Name'
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
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(535917877427155)
,p_db_column_name=>'STATUS'
,p_display_order=>100
,p_column_identifier=>'I'
,p_column_label=>'Status'
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
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(536040449427156)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>110
,p_column_identifier=>'J'
,p_column_label=>'Recevied Date'
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
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(536075305427157)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>120
,p_column_identifier=>'K'
,p_column_label=>'Action Date'
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
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(536168463427158)
,p_db_column_name=>'COMMENTS'
,p_display_order=>130
,p_column_identifier=>'L'
,p_column_label=>'Comments'
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
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(536272513427159)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>140
,p_column_identifier=>'M'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(536378200427160)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>150
,p_column_identifier=>'N'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(536501046427161)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>160
,p_column_identifier=>'O'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(536637575427162)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>170
,p_column_identifier=>'P'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(536750577427163)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>180
,p_column_identifier=>'Q'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(536871244427165)
,p_db_column_name=>'PHOTO'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
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
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(597933843867910)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'25880'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:FULL_NAME_EN:USER_NAME:ACTION_REQUIRED:STATUS:RECEVIED_DATE:ACTION_DATE:PHOTO'
,p_sort_column_1=>'STEP_NO'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(599938326893371)
,p_report_id=>wwv_flow_api.id(597933843867910)
,p_name=>'Current'
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
 p_id=>wwv_flow_api.id(537003356427166)
,p_plug_name=>'Alert - Missing HR Data'
,p_region_template_options=>'#DEFAULT#:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--warning'
,p_plug_template=>wwv_flow_api.id(8026775276175496)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>'you have incomplete HR Data (ex: Director , Executive Director..etc), <br> Please contact the system administrator.'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'NEVER'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(8217441661432624)
,p_plug_name=>'Documents'
,p_region_name=>'inside-page'
,p_icon_css_classes=>'fa-book fa-anim-flash'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P3_PETTY_CASH_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(8217578814432625)
,p_plug_name=>'Petty Cash Documents Report'
,p_parent_plug_id=>wwv_flow_api.id(8217441661432624)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8055912915175506)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ROW_VERSION_NUMBER,',
'       PETTY_CASH_ID,',
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
'  from HRSS_PETTY_CASH_DOCUMENTS',
' where PETTY_CASH_ID = :P3_PETTY_CASH_ID',
' order by created desc',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P3_PETTY_CASH_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1',
'  from HRSS_PETTY_CASH_DOCUMENTS',
' where PETTY_CASH_ID = :P3_PETTY_CASH_ID'))
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Petty Cash Documents Report'
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
 p_id=>wwv_flow_api.id(8217786098432627)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'There is no attachments. '
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>8217786098432627
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8217853096432628)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8217904459432629)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8218114702432631)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'C'
,p_column_label=>'File Name'
,p_column_link=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.::P4_ID,P4_PETTY_CASH_NO,P4_APPROVAL_STATUS,P4_ALLOW_INSERT,P4_FROM_PAGE:#ID#,&P3_PETTY_CASH_NO.,&P3_APPROVAL_STATUS.,N,3'
,p_column_linktext=>'#FILENAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8218281017432632)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'D'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8218383804432633)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8218426867432634)
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
 p_id=>wwv_flow_api.id(8218596050432635)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'G'
,p_column_label=>'File Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8218692192432636)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'H'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8218780758432637)
,p_db_column_name=>'CREATED'
,p_display_order=>100
,p_column_identifier=>'I'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8218833590432638)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'J'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8218984651432639)
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
 p_id=>wwv_flow_api.id(8219089015432640)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'L'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8219127302432641)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>140
,p_column_identifier=>'M'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8219208771432642)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>150
,p_column_identifier=>'N'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:HRSS_PETTY_CASH_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8219355815432643)
,p_db_column_name=>'PETTY_CASH_ID'
,p_display_order=>160
,p_column_identifier=>'O'
,p_column_label=>'Petty Cash Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(8354472981133759)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'83545'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(8219742608432647)
,p_plug_name=>'Collaboration'
,p_region_name=>'inside-page'
,p_icon_css_classes=>'fa-comments-o fa-anim-flash fam-sleep fam-is-success'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>40
,p_plug_new_grid_row=>false
,p_plug_display_column=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P3_PETTY_CASH_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(8219907576432649)
,p_name=>'Messages Report'
,p_region_name=>'projectUpdates'
,p_parent_plug_id=>wwv_flow_api.id(8219742608432647)
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
'            ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(user_name)',
'        ELSE',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'    END  user_icon,',
'  updated_date  comment_date,',
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
'    c.petty_cash_id,',
'    c.comment_text,',
'    c.created_by,',
'    c.updated_by,',
'    c.creation_date,',
'    c.updated_date,',
'    c.action,',
'    e.user_name,',
'    e.photo_blob    ',
'FROM',
'    hrss_petty_cash_comments c , dct_employees_list2 e',
'where c.updated_by = e.user_name    )',
'where PETTY_CASH_ID = :P3_PETTY_CASH_ID',
'order by CREATION_DATE desc;',
''))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P3_PETTY_CASH_ID'
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
 p_id=>wwv_flow_api.id(8220048101432650)
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
 p_id=>wwv_flow_api.id(8394503991387901)
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
 p_id=>wwv_flow_api.id(8394619252387902)
,p_query_column_id=>3
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>3
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(8394748448387903)
,p_query_column_id=>4
,p_column_alias=>'COMMENT_TEXT'
,p_column_display_sequence=>4
,p_column_heading=>'Comment Text'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.::P5_COMMENT_ID,P5_ACTION:#COMMENT_ID#,Edited'
,p_column_linktext=>'#COMMENT_TEXT#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(8394867630387904)
,p_query_column_id=>5
,p_column_alias=>'COMMENT_MODIFIERS'
,p_column_display_sequence=>5
,p_column_heading=>'Comment Modifiers'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(8394961771387905)
,p_query_column_id=>6
,p_column_alias=>'ICON_MODIFIER'
,p_column_display_sequence=>6
,p_column_heading=>'Icon Modifier'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(8395021747387906)
,p_query_column_id=>7
,p_column_alias=>'ACTIONS'
,p_column_display_sequence=>7
,p_column_heading=>'Actions'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(8395102878387907)
,p_query_column_id=>8
,p_column_alias=>'ATTRIBUTE_1'
,p_column_display_sequence=>8
,p_column_heading=>'Attribute 1'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(8395242322387908)
,p_query_column_id=>9
,p_column_alias=>'ATTRIBUTE_2'
,p_column_display_sequence=>9
,p_column_heading=>'Attribute 2'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(8395360410387909)
,p_query_column_id=>10
,p_column_alias=>'ATTRIBUTE_3'
,p_column_display_sequence=>10
,p_column_heading=>'Attribute 3'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(8395443541387910)
,p_query_column_id=>11
,p_column_alias=>'ATTRIBUTE_4'
,p_column_display_sequence=>11
,p_column_heading=>'Attribute 4'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(8395567135387911)
,p_query_column_id=>12
,p_column_alias=>'COMMENT_ID'
,p_column_display_sequence=>12
,p_column_heading=>'Comment Id'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(8228043989448903)
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
 p_id=>wwv_flow_api.id(8228661486448940)
,p_plug_name=>'Petty Cash Details'
,p_region_name=>'inside-page'
,p_icon_css_classes=>'fa-file-text-o fa-anim-flash fam-check fam-is-success'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody:margin-left-sm'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'HRSS_PETTY_CASH'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_read_only_when_type=>'PLSQL_EXPRESSION'
,p_plug_read_only_when=>':P3_APPROVAL_STATUS not in (''Draft'' , ''Stopped'')'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3526993311745646)
,p_plug_name=>'Project Financial Details:'
,p_parent_plug_id=>wwv_flow_api.id(8228661486448940)
,p_region_template_options=>'#DEFAULT#:t-Region--hideShowIconsMath:is-collapsed:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8040898187175502)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_plug_display_when_condition=>'P3_EMPLOYEE_NUM'
,p_plug_display_when_cond2=>'&EMP_NUM.'
,p_plug_header=>'<b>below information''s to be fill by finance business partners</b><br><br><br>'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(29270743915292327)
,p_plug_name=>'Alert'
,p_region_template_options=>'#DEFAULT#:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--warning'
,p_plug_template=>wwv_flow_api.id(8026775276175496)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>'Please Attache the supported documents'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'FUNCTION_BODY'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Declare',
'l_count number;',
'l_req    varchar2(1);',
'begin',
'',
'select TEMP_DOC_REQ_YN',
'into l_req',
'from hrss_configurations',
'where id = 1;',
'',
' if :P3_PETTY_CASH_ID is null then ',
'    return ',
'        false;',
'    ELSE    ',
'         if l_req = ''Y'' then ',
'                     select count(*)',
'                     into l_count',
'                      from HRSS_PETTY_CASH_DOCUMENTS',
'                     where PETTY_CASH_ID = :P3_PETTY_CASH_ID ;',
'             if  l_count = 0',
'                 then ',
'                     return true;',
'                  else',
'                      return false;',
'            end if;',
'         end if;   ',
'    End if;',
'end;'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(60917995802526932)
,p_plug_name=>'Full History Report'
,p_region_name=>'inside-page'
,p_icon_css_classes=>'fa-history'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>90
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    ROWNUM,',
'    pc.id,',
'    pc.request_type,',
'    pc.request_id,',
'    pc.action_type,',
'    pc.created_by,',
'    pc.created_date,',
'    pc.updated_by,',
'    pc.updated_date,',
'        (select e.full_name_en',
'        from dct_employees_list2 e',
'        where e.user_name = pc.UPDATED_BY) Employee_name',
'  ,   case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'           when 0  THEN',
'                  ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'            else  ',
'                ',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(pc.created_by)',
'           end Photo',
'      ',
'FROM',
'    petty_cash_all_actions pc , dct_employees_list2  e',
'where pc.created_by = e.user_name (+)',
'and request_id = :P3_PETTY_CASH_ID',
'order by UPDATED_DATE desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P3_PETTY_CASH_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'NEVER'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Full History Report'
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
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(60918029831526933)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>60918029831526933
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30561714838530897)
,p_db_column_name=>'ROWNUM'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'No.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30562193232530898)
,p_db_column_name=>'ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30562548928530898)
,p_db_column_name=>'REQUEST_TYPE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Request Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30562935414530898)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Request Id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30563378264530898)
,p_db_column_name=>'ACTION_TYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Action Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30563740662530898)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30564199822530899)
,p_db_column_name=>'CREATED_DATE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Created Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30564566036530899)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30564961384530899)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30565374027530899)
,p_db_column_name=>'EMPLOYEE_NAME'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Employee Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30565763942530899)
,p_db_column_name=>'PHOTO'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(61099342606932121)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'305661'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ROWNUM:ACTION_TYPE:EMPLOYEE_NAME:UPDATED_BY:UPDATED_DATE::PHOTO'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(27680180089234545)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(8228043989448903)
,p_button_name=>'Cancel'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_image_alt=>'Cancel Request'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_Reimburacement_amount         number;',
'begin',
'',
'select sum(nvl(l.receipt_amount,0))',
'into l_Reimburacement_amount',
'from hrss_expense_report_lines l',
'where l.expense_report_id in (select er.expense_report_id',
'                                from hrss_expense_reports er',
'                                where er.petty_cash_id = :P3_PETTY_CASH_ID',
'--                                and er.type = ''R''',
'                                and er.approval_status = ''Approved'');',
'',
'',
'',
'if :EMP_NUM in (9051 , 9033',
'                -- , 9025',
'               -- , 593',
'               ) ',
'--and :P3_APPROVAL_STATUS= ''Approved'' and :P3_INVOICING_YN = ''N'' and l_Reimburacement_amount > 0 or l_Reimburacement_amount is null',
'Then ',
'return true;',
'else',
'return false;',
'End if ;',
'',
'End;'))
,p_button_condition_type=>'FUNCTION_BODY'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(8219432203432644)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(8217441661432624)
,p_button_name=>'Add_File'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119283245175532)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add File'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.::P4_PETTY_CASH_ID,P4_APPROVAL_STATUS,P4_PETTY_CASH_NO,P4_ALLOW_INSERT,P4_FROM_PAGE:&P3_PETTY_CASH_ID.,&P3_APPROVAL_STATUS.,&P3_PETTY_CASH_NO.,Y,3'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(8219895970432648)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(8219742608432647)
,p_button_name=>'AddComment'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119283245175532)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Comment'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.::P5_PETTY_CASH_ID,P5_ACTION:&P3_PETTY_CASH_ID.,New'
,p_button_condition=>'P3_PETTY_CASH_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-envelope-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(30625316700214730)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(8228043989448903)
,p_button_name=>'STOP_Approval'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Stop Approval'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'(:P3_PETTY_CASH_ID is not null and :P3_APPROVAL_STATUS = ''In-Progress'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-remove'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(29271194348292331)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(8228043989448903)
,p_button_name=>'Expense-Report'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Expense Report'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:17:&SESSION.::&DEBUG.:::'
,p_button_condition_type=>'NEVER'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(43120473272427621)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(8228043989448903)
,p_button_name=>'Clear_Request'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Clearing Request'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:17:&SESSION.::&DEBUG.:::'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-check fa-anim-flash'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(8245353199448953)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(8228043989448903)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition=>':P3_PETTY_CASH_ID is not null and :P3_APPROVAL_STATUS = ''Draft'''
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-trash-o fam-x fam-is-danger'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(8245737703448954)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_api.id(8228043989448903)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>':P3_APPROVAL_STATUS  in (''Draft'' , ''Stoped'') and :P3_PETTY_CASH_ID is not null'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-save fam-check fam-is-success'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(8246196147448954)
,p_button_sequence=>80
,p_button_plug_id=>wwv_flow_api.id(8228043989448903)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition_type=>'NEVER'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(8399306288387949)
,p_button_sequence=>90
,p_button_plug_id=>wwv_flow_api.id(8228043989448903)
,p_button_name=>'CREATE_CONTINUE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save and Continue'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P3_PETTY_CASH_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_icon_css_classes=>'fa-save fa-anim-flash fam-check fam-is-success'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(8497875108132101)
,p_button_sequence=>100
,p_button_plug_id=>wwv_flow_api.id(8228043989448903)
,p_button_name=>'Submit'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Submit'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'declare',
'l_doc_count number;',
'l_req       varchar2(1);',
'Begin',
'',
'-- check if doc required',
'select TEMP_DOC_REQ_YN',
'into l_req',
'from hrss_configurations',
'where id = 1;',
'',
'if (l_req = ''N'') then',
'           if      :P3_PETTY_CASH_ID is not null ',
'                    and :P3_APPROVAL_STATUS in (''Draft'' , ''Stopped'')',
'                then ',
'                    return true;',
'                else',
'                    return false;',
'         end if;',
'            ',
'else',
'',
'select nvl(count(ID),0) as ID',
'into l_doc_count',
' from HRSS_PETTY_CASH_DOCUMENTS',
' where PETTY_CASH_ID = :P3_PETTY_CASH_ID;',
'',
'if      :P3_PETTY_CASH_ID is not null ',
'    and :P3_APPROVAL_STATUS in (''Draft'' , ''Stopped'')',
'    and l_doc_count > 0',
'then ',
'    return true;',
'else',
'    return false;',
' end if;',
' end if;',
'end;'))
,p_button_condition_type=>'FUNCTION_BODY'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(30624793916214724)
,p_button_sequence=>110
,p_button_plug_id=>wwv_flow_api.id(8228043989448903)
,p_button_name=>'OK'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Ok'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P3_REQUEST'
,p_button_condition2=>'15'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(30625039948214727)
,p_button_sequence=>120
,p_button_plug_id=>wwv_flow_api.id(8228043989448903)
,p_button_name=>'OK_26'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Ok'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P3_REQUEST'
,p_button_condition2=>'26'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4394738958542043)
,p_button_sequence=>130
,p_button_plug_id=>wwv_flow_api.id(8228043989448903)
,p_button_name=>'Expense-Report2'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Expense Report'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.::P30_PETTY_CASH_ID,P30_PETTY_CASH_NO,P30_PETTY_CASH_TYPE:&P3_PETTY_CASH_ID.,&P3_PETTY_CASH_NO.,&P3_PETTY_CASH_TYPE.'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-credit-card-terminal'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(7563843415586963)
,p_button_sequence=>140
,p_button_plug_id=>wwv_flow_api.id(8228043989448903)
,p_button_name=>'Print'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Print'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'EMP_NUM'
,p_button_condition2=>'9051:593:9071:9033:9025'
,p_button_condition_type=>'VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST'
,p_icon_css_classes=>'fa-print'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(8244598013448952)
,p_button_sequence=>150
,p_button_plug_id=>wwv_flow_api.id(8228043989448903)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(30624863679214725)
,p_branch_name=>'Go To 15'
,p_branch_action=>'f?p=&APP_ID.:15:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(30624793916214724)
,p_branch_sequence=>10
,p_branch_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_branch_condition=>'P3_REQUEST'
,p_branch_condition_text=>'15'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(30625154395214728)
,p_branch_name=>'Go To 26'
,p_branch_action=>'f?p=&APP_ID.:26:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
,p_branch_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_branch_condition=>'P3_REQUEST'
,p_branch_condition_text=>'26'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(8246459901448954)
,p_branch_name=>'Go To Page 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(8246196147448954)
,p_branch_sequence=>30
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(8399480753387950)
,p_branch_name=>'Stay in 3'
,p_branch_action=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::P3_PETTY_CASH_ID:&P3_PETTY_CASH_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(8399306288387949)
,p_branch_sequence=>40
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(30625223103214729)
,p_branch_name=>'Go TO 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(8245353199448953)
,p_branch_sequence=>50
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(27291284295489463)
,p_name=>'P3_CANCELLED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_prompt=>'Cancelled By'
,p_source=>'CANCEL_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEE NAME BY PERSONID LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en , person_id',
'from dct_employees_list2'))
,p_display_when=>'P3_APPROVAL_STATUS'
,p_display_when2=>'Cancelled'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(27291158850489462)
,p_name=>'P3_CANCEL_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_prompt=>'Cancel On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CANCEL_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P3_APPROVAL_STATUS'
,p_display_when2=>'Cancelled'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(146877640505027)
,p_name=>'P3_UPDATED_VIEW'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_prompt=>'Updated View'
,p_source=>'''Updated on: '' || :P3_UPDATED_DATE || '' - By: '' || :P3_UPDATED_BY'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_tag_attributes=>'style="border: 1px solid powderblue;padding: 2px;"'
,p_begin_on_new_line=>'N'
,p_grid_label_column_span=>0
,p_display_when=>'P3_PETTY_CASH_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(8118738374175531)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(146762707505026)
,p_name=>'P3_CREATED_VIEW'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_prompt=>'Created View'
,p_source=>'''Created on: '' || :P3_CREATION_DATE || '' - By: '' || :P3_CREATED_BY'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_tag_attributes=>'style="border: 1px solid powderblue;padding: 2px;"'
,p_grid_label_column_span=>0
,p_display_when=>'P3_PETTY_CASH_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(8118738374175531)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3528452105745660)
,p_name=>'P3_CREATE_BTR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(3526993311745646)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_default=>'N'
,p_prompt=>'Auto create budget transfer request'
,p_source=>'CREATE_BTR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_help_text=>'Auto create Budget Transfer request if there is no fund available'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3530056246745676)
,p_name=>'P3_EMP_ORG_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select e.org_id as org_id ',
' from employees_v e',
' where user_name = :APP_USER;'))
,p_item_default_type=>'SQL_QUERY'
,p_source=>'EMP_ORG_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3530125716745677)
,p_name=>'P3_EMP_ORG'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
' select org.org_name',
' from organizations_v org',
' where org.org_id = (select e.org_id as org_id ',
' from employees_v e',
' where user_name = :APP_USER)'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;display: block;margin-left: auto;">Organization :</span>'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select org_name',
'from employees_v',
'where employee_num = :P3_EMPLOYEE_NUM'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4585141114120863)
,p_name=>'P3_IMAGE'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_prompt=>'Image'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'           when 0  THEN',
'                 ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'            else  ',
'                ',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'           end  Photo',
'from dct_employees_list2  e',
'where e.employee_num = :P3_EMPLOYEE_NUM'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_IMAGE'
,p_tag_attributes=>'style="border-radius: 50%;display: block;margin-right: auto;width: 40%;"'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(8118738374175531)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'URL'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7311527546469285)
,p_name=>'P3_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8215662662432606)
,p_name=>'P3_EMPLOYEE_NAME'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DCT_EMPLOYEES_LIST2.full_name_en as EMPLOYEE_NUM ',
' from DCT_EMPLOYEES_LIST2 DCT_EMPLOYEES_LIST2',
' where person_id = :PERSON_ID'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;display: block;margin-left: auto;">Employee Name :</span>'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en',
'from employees_v',
'where employee_num = :P3_EMPLOYEE_NUM'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8215750170432607)
,p_name=>'P3_SECTOR'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(3526993311745646)
,p_prompt=>'Sector'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select F_PROJECTBUDGET.TCA_SECTOR',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where F_PROJECTBUDGET.PROJECT_NUMBER = :P3_PROJECT_NUMBER'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8215842922432608)
,p_name=>'P3_DEPARTMENT'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(3526993311745646)
,p_prompt=>'Department'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select F_PROJECTBUDGET.DEPARTMENT',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where F_PROJECTBUDGET.PROJECT_NUMBER = :P3_PROJECT_NUMBER'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8215959924432609)
,p_name=>'P3_PROJECT_NAME'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(3526993311745646)
,p_prompt=>'Project Name'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select F_PROJECTBUDGET.PROJECT_NAME as PROJECT_NAME',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where F_PROJECTBUDGET.PROJECT_NUMBER = :P3_PROJECT_NUMBER'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8216013489432610)
,p_name=>'P3_ACCOUNT_NAME'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(3526993311745646)
,p_prompt=>'Account Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8216141257432611)
,p_name=>'P3_JUSTIFICATION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Justification :</span>'
,p_source=>'JUSTIFICATION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>120
,p_cMaxlength=>4000
,p_cHeight=>3
,p_field_template=>wwv_flow_api.id(8118975198175531)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'Y'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8216286035432612)
,p_name=>'P3_COMMENT_TO_APPROVER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Comment to Approver :</span>'
,p_source=>'COMMENT_TO_APPROVER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>4000
,p_cHeight=>3
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'Y'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8229005675448940)
,p_name=>'P3_PETTY_CASH_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_source=>'PETTY_CASH_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8229453474448943)
,p_name=>'P3_PETTY_CASH_NO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Petty Cash No :</span>'
,p_source=>'PETTY_CASH_NO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_cMaxlength=>50
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118975198175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8229824967448944)
,p_name=>'P3_PETTY_CASH_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_default=>'select sysdate from dual'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Request Date :</span>'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'PETTY_CASH_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118975198175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8230263822448945)
,p_name=>'P3_DUE_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_default=>'select sysdate + 3 from dual'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Due Date :</span>'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'DUE_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118975198175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8230630312448945)
,p_name=>'P3_PETTY_CASH_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_prompt=>'Petty Cash Type :'
,p_source=>'PETTY_CASH_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Permanent;P,Temporary;T'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-- (1) Select Petty Cash Type'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(8118975198175531)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large:margin-left-none'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8231067245448945)
,p_name=>'P3_EMPLOYEE_NUM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DCT_EMPLOYEES_LIST2.EMPLOYEE_NUM as EMPLOYEE_NUM ',
' from DCT_EMPLOYEES_LIST2 DCT_EMPLOYEES_LIST2',
' where person_id  = :PERSON_ID'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Employee Num :</span>'
,p_source=>'EMPLOYEE_NUM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_tag_attributes=>'style="display: block;margin-right: auto;"'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
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
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8231420735448945)
,p_name=>'P3_PROJECT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(3526993311745646)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_prompt=>'Project Number'
,p_source=>'PROJECT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'PROJECTS BY DEPARTMENTS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct p.PROJECT_NUMBER as PROJECT_NUMBER,',
'PROJECTS_UTIL.project_name(PROJECT_NUMBER) project_name',
'--    p.PROJECT_NUMBER as PROJECT_NUM',
'--    p.  as PROJECT_NAME    ',
'   -- F_PROJECTBUDGET.DEPARTMENT as DEPARTMENT,',
'--    F_PROJECTBUDGET.TCA_SECTOR as      SECTOR ',
'--    ,F_PROJECTBUDGET.DEPARTMENT as DEPARTMENT_d',
' from project_balances_v p  '))
,p_lov_display_null=>'YES'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_07=>'Select Project'
,p_attribute_08=>'500'
,p_attribute_09=>'500'
,p_attribute_10=>'SECTOR:P3_SECTOR,DEPARTMENT:P3_DEPARTMENT,PROJECT_NAME:P3_PROJECT_NAME'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8231876844448945)
,p_name=>'P3_TASK'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(3526993311745646)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_prompt=>'Task'
,p_source=>'TASK'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'TASKS BY PROJECT'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct  F_PROJECTBUDGET.TASK_NUMBER as TASK_NUMBER',
'    ,F_PROJECTBUDGET.TASK_NUMBER as TASK    ',
' --   F_PROJECTBUDGET.ACCOUNT_NAME as ACCOUNT_NAME,',
' --   F_PROJECTBUDGET.NATURAL_ACCOUNT as NATURAL_ACCOUNT ',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where project_number = :P3_PROJECT_NUMBER'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P3_PROJECT_NUMBER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8232243853448946)
,p_name=>'P3_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Amount :</span>'
,p_post_element_text=>'<b>AED</b>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_tag_attributes=>'style="color:#33cc33 ;" onfocusout="this.value=Number(this.value).toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, ''$1,'')"'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118975198175531)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'1'
,p_attribute_02=>'100000'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8232653282448946)
,p_name=>'P3_PURPOSE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Purpose :</span>'
,p_source=>'PURPOSE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'PETTY CASH PURPOSE-NEW'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id ',
'from dct_lookup_values',
'where lookup_id = (select dct_lookups.lookup_id',
'                    from dct_lookups',
'                    where dct_lookups.lookup_code = ''HRSS-PC'')',
'and dct_lookup_values.status = ''A'''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8233034983448946)
,p_name=>'P3_CLOSING_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Closing Date :</span>'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'CLOSING_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118975198175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8233416373448946)
,p_name=>'P3_APPROVAL_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_default=>'Draft'
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Approval Status :</span>'
,p_source=>'APPROVAL_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_tag_attributes=>'style="color:#33cc33"'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8233815262448947)
,p_name=>'P3_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_default=>'Open'
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Status :</span>'
,p_source=>'STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_tag_attributes=>'style="color:#33cc33"'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_display_when=>'P3_APPROVAL_STATUS'
,p_display_when2=>'Approved'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8234265171448947)
,p_name=>'P3_RECONCILED_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Reconciled Date :</span>'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'RECONCILED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>32
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_display_when=>'P3_STATUS'
,p_display_when2=>'Reconciled'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(8118975198175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'button'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8234606616448947)
,p_name=>'P3_PRIORITY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_default=>'L'
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Priority :</span>'
,p_source=>'PRIORITY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Low;L,Medium;M,High;H'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118975198175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8235028904448947)
,p_name=>'P3_CREATION_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>320
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CREATION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8235878807448949)
,p_name=>'P3_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8236277909448949)
,p_name=>'P3_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>330
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8236680447448949)
,p_name=>'P3_UPDATED_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>340
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'UPDATED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8237479408448949)
,p_name=>'P3_YEAR'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>350
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_default=>'select extract(year from sysdate) year from dual'
,p_item_default_type=>'SQL_QUERY'
,p_source=>'YEAR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8237842088448949)
,p_name=>'P3_GL_ACCOUNT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(3526993311745646)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_prompt=>'GL Account'
,p_source=>'GL_ACCOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select F_PROJECTBUDGET.NATURAL_ACCOUNT || '' - '' || ACCOUNT_NAME  acc',
'    --|| ''(Budget: '' || trim(TO_CHAR(BUDGET,''999999999D99'')) || '', Available: '' || trim(TO_CHAR(FUND_AVAILABLE,''999999999D99'')) || '')'' acc ',
'    , NATURAL_ACCOUNT as NATURAL_ACCOUNT ',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where PROJECT_NUMBER = :P3_PROJECT_NUMBER',
' and TASK_NUMBER = :P3_TASK;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P3_PROJECT_NUMBER,P3_TASK'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(8118975198175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8497972664132102)
,p_name=>'P3_DOCUMENT_COUNT'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_use_cache_before_default=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(count(ID),0) as ID',
' from HRSS_PETTY_CASH_DOCUMENTS',
' where PETTY_CASH_ID = :P3_PETTY_CASH_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29270894181292328)
,p_name=>'P3_INVOICING_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_default=>'N'
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Invoicing ? :</span>'
,p_source=>'INVOICING_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_display_when=>'P3_APPROVAL_STATUS'
,p_display_when2=>'Approved'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29270950052292329)
,p_name=>'P3_PAID_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_default=>'N'
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Paid ? :</span>'
,p_source=>'PAID_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_display_when=>'P3_APPROVAL_STATUS'
,p_display_when2=>'Approved'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30624665389214723)
,p_name=>'P3_REQUEST'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(33792363065143657)
,p_name=>'P3_REQUESTOR_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_default=>'PERSON_ID'
,p_item_default_type=>'ITEM'
,p_source=>'REQUESTOR_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(137912632419969768)
,p_name=>'P3_COST_CENTER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_source_plug_id=>wwv_flow_api.id(8228661486448940)
,p_item_default=>'user_details.get_cost_center(:person_id)'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;display: block;margin-left: auto;">Cost Center:</span>'
,p_source=>'COST_CENTER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'COST CENTERS WITH NAMES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''('' || COST_CENTER_CODE || '') '' || COST_CENTER_DESCRIPTION Name, COST_CENTER_CODE',
'from(',
'select distinct  COST_CENTER_DESCRIPTION, COST_CENTER_CODE',
'from dct_gl_code_combinations_all',
'order by COST_CENTER_CODE)'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_cMaxlength=>7
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(8235517353448948)
,p_validation_name=>'P3_CREATION_DATE must be timestamp'
,p_validation_sequence=>150
,p_validation=>'P3_CREATION_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(8235028904448947)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(8237100717448949)
,p_validation_name=>'P3_UPDATED_DATE must be timestamp'
,p_validation_sequence=>180
,p_validation=>'P3_UPDATED_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(8236680447448949)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(5396562881457454)
,p_validation_name=>'Closing Date not Before Due Date'
,p_validation_sequence=>190
,p_validation=>':P3_CLOSING_DATE >= :P3_DUE_DATE'
,p_validation_type=>'PLSQL_EXPRESSION'
,p_error_message=>'Closing Date must be after due date.'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(8395656043387912)
,p_name=>'Collaboration Dialog Close'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(8219742608432647)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(8395744502387913)
,p_event_id=>wwv_flow_api.id(8395656043387912)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(8219907576432649)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(8395828762387914)
,p_name=>'Comments Dialog Closed'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(8219907576432649)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(8395932922387915)
,p_event_id=>wwv_flow_api.id(8395828762387914)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(8219907576432649)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(77037023254932911)
,p_name=>'set approve color'
,p_event_sequence=>30
,p_condition_element=>'P3_APPROVAL_STATUS'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Approved'
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(77037121330932912)
,p_event_id=>wwv_flow_api.id(77037023254932911)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_CSS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P3_APPROVAL_STATUS'
,p_attribute_01=>'color'
,p_attribute_02=>'green'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(77037600378932917)
,p_event_id=>wwv_flow_api.id(77037023254932911)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_CSS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P3_APPROVAL_STATUS'
,p_attribute_01=>'font-weight'
,p_attribute_02=>'bold'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(77037213038932913)
,p_name=>'set rejected color'
,p_event_sequence=>40
,p_condition_element=>'P3_APPROVAL_STATUS'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Rejected'
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(77037399340932914)
,p_event_id=>wwv_flow_api.id(77037213038932913)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_CSS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P3_APPROVAL_STATUS'
,p_attribute_01=>'color'
,p_attribute_02=>'red'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(77037772279932918)
,p_event_id=>wwv_flow_api.id(77037213038932913)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_CSS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P3_APPROVAL_STATUS'
,p_attribute_01=>'font-weight'
,p_attribute_02=>'bolder'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(77037436436932915)
,p_name=>'set in-Progress color'
,p_event_sequence=>50
,p_condition_element=>'P3_APPROVAL_STATUS'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'In-Progress'
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(77037565413932916)
,p_event_id=>wwv_flow_api.id(77037436436932915)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_CSS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P3_APPROVAL_STATUS'
,p_attribute_01=>'color'
,p_attribute_02=>'GoldenRod'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(77037827836932919)
,p_event_id=>wwv_flow_api.id(77037436436932915)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_CSS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P3_APPROVAL_STATUS'
,p_attribute_01=>'font-weight'
,p_attribute_02=>'bolder'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3529104332745667)
,p_name=>'Submit Petty Cash'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(8497875108132101)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3529205711745668)
,p_event_id=>wwv_flow_api.id(3529104332745667)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'you are going to submit your Petty cash# &P3_PETTY_CASH_NO. for approval, Are you sure?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3529295694745669)
,p_event_id=>wwv_flow_api.id(3529104332745667)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'',
' petty_cash_workflow.SUBMIT_PETTY_CASH(:P3_PETTY_CASH_ID);',
'END;'))
,p_attribute_02=>'P3_PETTY_CASH_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3529373026745670)
,p_event_id=>wwv_flow_api.id(3529104332745667)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Petty cash# &P3_PETTY_CASH_NO. Successfully Submitted.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3529481271745671)
,p_event_id=>wwv_flow_api.id(3529104332745667)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(28989108023398913)
,p_name=>'In-Progress'
,p_event_sequence=>80
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P3_APPROVAL_STATUS'
,p_condition_element=>'P3_APPROVAL_STATUS'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'In-progress'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(28989235183398914)
,p_event_id=>wwv_flow_api.id(28989108023398913)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_CSS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P3_APPROVAL_STATUS'
,p_attribute_01=>'color'
,p_attribute_02=>'blue'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(30625485953214731)
,p_name=>'Stop Approval'
,p_event_sequence=>90
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(30625316700214730)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(30625598512214732)
,p_event_id=>wwv_flow_api.id(30625485953214731)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure that you want to withdraw your petty cash request ? '
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3984917672546442)
,p_event_id=>wwv_flow_api.id(30625485953214731)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'petty_cash_WORKFLOW.stop_petty_cash(:P3_PETTY_CASH_ID );',
'',
'end;'))
,p_attribute_02=>'P3_PETTY_CASH_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3984988005546443)
,p_event_id=>wwv_flow_api.id(30625485953214731)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'your petty cash request has been stopped.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3985152403546444)
,p_event_id=>wwv_flow_api.id(30625485953214731)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(30625783231214734)
,p_name=>'Dialog Close'
,p_event_sequence=>100
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(8219895970432648)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(30625864362214735)
,p_event_id=>wwv_flow_api.id(30625783231214734)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(8219907576432649)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(43120190984427618)
,p_name=>'Hide Expense Report'
,p_event_sequence=>110
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'$v(''P3_PAID_YN'') == ''Y'' '
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(43120299750427619)
,p_event_id=>wwv_flow_api.id(43120190984427618)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(29271194348292331)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(43120354365427620)
,p_event_id=>wwv_flow_api.id(43120190984427618)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(29271194348292331)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(43122363716427640)
,p_name=>'Set Petty Cash Number'
,p_event_sequence=>120
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P3_PETTY_CASH_TYPE'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(43122485393427641)
,p_event_id=>wwv_flow_api.id(43122363716427640)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P3_PETTY_CASH_NO'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select :APP_USER ||',
'        ''/''      ||',
'        Extract(YEAR from sysdate)',
'        ||',
'        ''/''',
'        ||',
'        :P3_PETTY_CASH_TYPE',
'        ||',
'        lpad(PETTY_CASH_NO_SEQ.nextval,4,0)',
'from dual'))
,p_attribute_07=>'P3_PETTY_CASH_TYPE'
,p_attribute_08=>'N'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4586476266120877)
,p_name=>'Hide Success Message'
,p_event_sequence=>130
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4586598478120878)
,p_event_id=>wwv_flow_api.id(4586476266120877)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
' setTimeout(function() {',
'    $(''#APEX_SUCCESS_MESSAGE'').fadeOut(''fast'');',
'}, 3000);'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(7311301099469283)
,p_name=>'Print'
,p_event_sequence=>140
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(7563843415586963)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7311438949469284)
,p_event_id=>wwv_flow_api.id(7311301099469283)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'javaScript:window.open(''f?p=101:0:&SESSION.:PRINT_REPORT=Petty%20Cash%20Details'' , ''_blank'');'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(27680089628234544)
,p_name=>'Cancel DA'
,p_event_sequence=>150
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(27680180089234545)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(27679918189234543)
,p_event_id=>wwv_flow_api.id(27680089628234544)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure to cancel this request?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(27679835202234542)
,p_event_id=>wwv_flow_api.id(27680089628234544)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update hrss_petty_cash',
'set amount = 0, approval_status = ''Cancelled'', STATUS = ''Closed'', CANCEL_ON = systimestamp , cancel_by = :PERSON_ID',
'where petty_cash_id = :P3_PETTY_CASH_ID;',
'',
'delete from hrss_approval_history where request_id = :P3_PETTY_CASH_ID and STATUS  in (''Pending'' , ''Future'');'))
,p_attribute_02=>'P3_PETTY_CASH_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(27679757060234541)
,p_event_id=>wwv_flow_api.id(27680089628234544)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Cancelled Success.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(27679091414234534)
,p_event_id=>wwv_flow_api.id(27680089628234544)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(8247383998448955)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(8228661486448940)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Petty Cash Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_process_error_message=>'Error while process petty cash &P3_PETTY_CASH_NO., contact your system administrator.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Petty Cash Number &P3_PETTY_CASH_NO. updated successfully'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(8246903952448955)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(8228661486448940)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Petty Cash Details'
);
wwv_flow_api.component_end;
end;
/
