prompt --application/pages/page_00015
begin
--   Manifest
--     PAGE: 00015
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>15
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'Payment Recommendation Approve / Reject'
,p_alias=>'PAYMENT-RECOMMENDATION-APPROVE-REJECT'
,p_step_title=>'Payment Recommendation Approve / Reject'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_css_file_urls=>'#WORKSPACE_IMAGES#main.css'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.t-Form-label {',
'    	color: #368ed2;',
'	font-weight: bold;',
'	font-size:12px;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230408111048'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(20922350378859232)
,p_plug_name=>'Clarifications'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>70
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'       ID,',
'       rownum,',
'       PAYMENT_RECOMMENDATION_ID,',
'       FROM_PERSON_ID,',
'       (case FROM_PERSON_TYPE when ''INT''  THEN  (select e.full_name_en ',
'                                                 from employees_v e',
'                                                 where e.person_id = FROM_PERSON_ID)',
'                              else (select u.first_name||'' ''|| u.last_name',
'                                    from DCT_EXT_USERS u',
'                                    where u.user_id =FROM_PERSON_ID)',
'        End) From_person_name,',
'       FROM_PERSON_TYPE,',
'       TO_PERSON_ID,',
'       (case TO_PERSON_TYPE when ''INT''  THEN  (select e.full_name_en ',
'                                                 from employees_v e',
'                                                 where e.person_id = TO_PERSON_ID)',
'                              else (select u.first_name||'' ''|| u.last_name',
'                                    from DCT_EXT_USERS u',
'                                    where u.user_id =TO_PERSON_ID)',
'        End) TO_person_name,',
'       TO_PERSON_TYPE,',
'       ACTION_REQUIRED,',
'       PRIORITY,',
'       COMMENTS,',
'       CREATED_ON + INTERVAL ''0 04:00:00.0'' DAY TO SECOND   as    CREATED_ON,',
'       CREATED_BY,',
'       CREATED_BY_PERSON_ID,',
'       UPDATED_BY,',
'       UPDATED_BY_PERSON_ID,',
'       UPDATED_ON + INTERVAL ''0 04:00:00.0'' DAY TO SECOND   as    UPDATED_ON',
'from CWIP_PAYMENT_REC_MORE_INFO',
' where PAYMENT_RECOMMENDATION_ID = :P15_PAYMENT_RECOMMENDATION_ID',
' order by CREATED_ON;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P15_PAYMENT_RECOMMENDATION_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select *',
'from CWIP_PAYMENT_REC_MORE_INFO',
'where PAYMENT_RECOMMENDATION_ID = :P15_PAYMENT_RECOMMENDATION_ID'))
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Clarifications'
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
 p_id=>wwv_flow_api.id(20922434155859233)
,p_max_row_count=>'1000000'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_control_break=>'N'
,p_show_computation=>'N'
,p_show_aggregate=>'N'
,p_show_chart=>'N'
,p_show_pivot=>'N'
,p_show_flashback=>'N'
,p_show_reset=>'N'
,p_show_help=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>20922434155859233
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(20988962719289650)
,p_db_column_name=>'ROWNUM'
,p_display_order=>10
,p_column_identifier=>'R'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(20922519146859234)
,p_db_column_name=>'ID'
,p_display_order=>20
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(20922646706859235)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>30
,p_column_identifier=>'B'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(20922766876859236)
,p_db_column_name=>'FROM_PERSON_ID'
,p_display_order=>40
,p_column_identifier=>'C'
,p_column_label=>'FROM_PERSON_ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(20922845257859237)
,p_db_column_name=>'FROM_PERSON_TYPE'
,p_display_order=>50
,p_column_identifier=>'D'
,p_column_label=>'From Person Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(20922989440859238)
,p_db_column_name=>'TO_PERSON_ID'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'TO_PERSON_ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(20923084666859239)
,p_db_column_name=>'TO_PERSON_TYPE'
,p_display_order=>70
,p_column_identifier=>'F'
,p_column_label=>'To Person Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(20923139810859240)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>80
,p_column_identifier=>'G'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(20923296957859241)
,p_db_column_name=>'PRIORITY'
,p_display_order=>90
,p_column_identifier=>'H'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(20923395542859242)
,p_db_column_name=>'COMMENTS'
,p_display_order=>100
,p_column_identifier=>'I'
,p_column_label=>'Message'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(20923439320859243)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>110
,p_column_identifier=>'J'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(20923586774859244)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>120
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(20923667005859245)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>130
,p_column_identifier=>'L'
,p_column_label=>'Created By Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(20923789185859246)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>140
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(20923845187859247)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>150
,p_column_identifier=>'N'
,p_column_label=>'Updated By Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(20923905993859248)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>160
,p_column_identifier=>'O'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(20924054180859249)
,p_db_column_name=>'FROM_PERSON_NAME'
,p_display_order=>170
,p_column_identifier=>'P'
,p_column_label=>'From'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(20924135723859250)
,p_db_column_name=>'TO_PERSON_NAME'
,p_display_order=>180
,p_column_identifier=>'Q'
,p_column_label=>'To'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(20977778627939994)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'209778'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FROM_PERSON_NAME:TO_PERSON_NAME:PRIORITY:COMMENTS:UPDATED_ON:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(23522576698013971)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10254567086597785)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(10191147067597728)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(10308621936597827)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(23523242051013989)
,p_plug_name=>'Payment Recommendation Details'
,p_icon_css_classes=>'fa-file-text-o fa-2x fam-information fam-is-success'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody:margin-right-none'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>20
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'CWIP_PAYMENT_RECOMMENDATION'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_read_only_when_type=>'PLSQL_EXPRESSION'
,p_plug_read_only_when=>':P15_APPROVAL_STATUS not in (''Draft'' , ''Stoped'')'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(213869192364743783)
,p_plug_name=>'Payment Recommendation Details 2'
,p_parent_plug_id=>wwv_flow_api.id(23523242051013989)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>5
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(172338997090809762)
,p_plug_name=>'Attachements'
,p_parent_plug_id=>wwv_flow_api.id(213869192364743783)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>80
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(172339091593809763)
,p_plug_name=>'Payment Recommendation Report'
,p_parent_plug_id=>wwv_flow_api.id(172338997090809762)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10243288598597779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ROW_VERSION_NUMBER,',
'       payment_recommendation_id,',
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
'  from cwip_payment_recommendation_documents',
' where payment_recommendation_id = :P15_PAYMENT_RECOMMENDATION_ID',
' order by created desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P15_PAYMENT_RECOMMENDATION_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Payment Recommendation Report'
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
 p_id=>wwv_flow_api.id(172339188845809764)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>212775230674712034
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86789712866571570)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86790074704571569)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86790500825571569)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86790884971571569)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Filename'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86791262633571568)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86791684371571568)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86792090093571568)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>70
,p_column_identifier=>'G'
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
 p_id=>wwv_flow_api.id(86792549904571568)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'File Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86792927531571568)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86793312692571568)
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
 p_id=>wwv_flow_api.id(86793730437571567)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86794128358571567)
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
 p_id=>wwv_flow_api.id(86794482402571567)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86794858829571567)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86795313301571567)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:CWIP_PAYMENT_RECOMMENDATION_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(172805932174422289)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1272317'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:TAGS:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(213869229341743784)
,p_plug_name=>'IPC Details1'
,p_parent_plug_id=>wwv_flow_api.id(213869192364743783)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(213872300904743814)
,p_plug_name=>'IPC Details2'
,p_parent_plug_id=>wwv_flow_api.id(213869192364743783)
,p_region_template_options=>'#DEFAULT#:t-Region--hideHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(213872420028743815)
,p_plug_name=>'IPC Details3'
,p_parent_plug_id=>wwv_flow_api.id(213869192364743783)
,p_region_template_options=>'#DEFAULT#:t-Region--hideHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(213872501670743816)
,p_plug_name=>'IPC Details4'
,p_parent_plug_id=>wwv_flow_api.id(213869192364743783)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader:t-Region--stacked:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(213872534992743817)
,p_plug_name=>'IPC Details5'
,p_parent_plug_id=>wwv_flow_api.id(213869192364743783)
,p_region_template_options=>'#DEFAULT#:t-Region--hideHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(213873266993743824)
,p_plug_name=>'Audit Info'
,p_parent_plug_id=>wwv_flow_api.id(213869192364743783)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10228155320597771)
,p_plug_display_sequence=>70
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(23567132336321459)
,p_plug_name=>'Collaboration'
,p_icon_css_classes=>'fa-comments-o fa-anim-flash fam-sleep fam-is-success'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody:margin-left-none'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(23567233414321460)
,p_name=>'Comments'
,p_parent_plug_id=>wwv_flow_api.id(23567132336321459)
,p_template=>wwv_flow_api.id(10217787920597763)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Comments--chat'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select',
'    CASE when user_type = ''Internal'' Then',
'        CASE',
'            WHEN dbms_lob.getlength(photo_blob) > 0 THEN',
'                ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(user_name)',
'            ELSE',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'        END ',
'    when user_type = ''External'' Then',
'         CASE when dbms_lob.getlength(photo_blob) > 0 THEN',
'                ''https://ifinance.dct.gov.ae:8004/dct/prod/ExtUser/view/'' || upper(user_name)',
'            ELSE',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/ExtUser/view/'' || ''U0000''',
'        End ',
'     End   user_icon,',
'  updated_date  comment_date,',
'  case when user_type = ''Internal'' Then',
'        (select e.full_name_en',
'            from dct_employees_list2 e',
'            where e.user_name = created_by)',
'        when user_type = ''External'' Then    ',
'            (select u.first_name || '' '' || u.last_name',
'                from dct_ext_users u',
'                where u.user_name = created_by)',
'        End user_name,',
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
'    c.payment_recommendation_id,',
'    c.comment_text,',
'    c.created_by,',
'    c.updated_by,',
'    c.creation_date,',
'    c.updated_date,',
'    c.action,',
'    e.user_name,',
'    e.photo_blob,',
'    ''Internal''  user_type',
'FROM',
'    cwip_payment_recommendation_comments c , dct_employees_list2 e',
'where c.updated_by = e.user_name',
'UNION all',
'SELECT',
'    c.comment_id,',
'    c.payment_recommendation_id,',
'    c.comment_text,',
'    c.created_by,',
'    c.updated_by,',
'    c.creation_date + INTERVAL ''0 04:00:00.0'' DAY TO SECOND   as    creation_date,',
'    c.updated_date + INTERVAL ''0 04:00:00.0'' DAY TO SECOND   as    updated_date ,',
'    c.action,',
'    e.user_name,',
'    e.photo_blob,',
'    ''External''  user_type',
'FROM',
'    cwip_payment_recommendation_comments c , dct_ext_users e',
'where c.updated_by = e.user_name )',
'where payment_recommendation_id = :P15_PAYMENT_RECOMMENDATION_ID',
'order by CREATION_DATE desc;',
''))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P15_PAYMENT_RECOMMENDATION_ID'
,p_query_row_template=>wwv_flow_api.id(10274016461597799)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No Communications yet.'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(12069355050523704)
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
 p_id=>wwv_flow_api.id(12069726059523704)
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
 p_id=>wwv_flow_api.id(12070111878523705)
,p_query_column_id=>3
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>3
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(12070538250523706)
,p_query_column_id=>4
,p_column_alias=>'COMMENT_TEXT'
,p_column_display_sequence=>4
,p_column_heading=>'Message'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:18:&SESSION.::&DEBUG.:18:P18_COMMENT_ID,P18_ACTION:#COMMENT_ID#,Edited'
,p_column_linktext=>'#COMMENT_TEXT#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(12070967077523706)
,p_query_column_id=>5
,p_column_alias=>'COMMENT_MODIFIERS'
,p_column_display_sequence=>5
,p_column_heading=>'Comment Modifiers'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(12071307900523707)
,p_query_column_id=>6
,p_column_alias=>'ICON_MODIFIER'
,p_column_display_sequence=>6
,p_column_heading=>'Icon Modifier'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(12071764376523707)
,p_query_column_id=>7
,p_column_alias=>'ACTIONS'
,p_column_display_sequence=>7
,p_column_heading=>'Actions'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(12072156209523708)
,p_query_column_id=>8
,p_column_alias=>'ATTRIBUTE_1'
,p_column_display_sequence=>8
,p_column_heading=>'Attribute 1'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(12072588301523708)
,p_query_column_id=>9
,p_column_alias=>'ATTRIBUTE_2'
,p_column_display_sequence=>9
,p_column_heading=>'Attribute 2'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(12072928011523709)
,p_query_column_id=>10
,p_column_alias=>'ATTRIBUTE_3'
,p_column_display_sequence=>10
,p_column_heading=>'Attribute 3'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(12073399773523709)
,p_query_column_id=>11
,p_column_alias=>'ATTRIBUTE_4'
,p_column_display_sequence=>11
,p_column_heading=>'Attribute 4'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(12073726833523710)
,p_query_column_id=>12
,p_column_alias=>'COMMENT_ID'
,p_column_display_sequence=>12
,p_column_heading=>'Comment Id'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(23917350505897558)
,p_plug_name=>'Approval History'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    id,',
'    payment_recommendation_id,',
'    step_no,',
'    person_id,',
'    full_name,',
'    person_type,',
'    role_id,',
'    case on_behalf when ''Y'' then ''on-behalf '' || role_name',
'                        else role_name',
'    end role_name,',
'    action_required,',
'    recevied_date,',
'    status,',
'    action_date,',
'    comments,',
'    approval_type,',
'    created_on,',
'    created_by,',
'    updated_by,',
'    updated_on,',
'    photo_blob,',
'     reminder_count,',
'    reminder_by,',
'    (case person_type when ''INT''  Then',
'                                CASE',
'                                    WHEN dbms_lob.getlength(photo_blob) > 0 THEN',
'                                      ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || User_name',
'                                    ELSE',
'                                       ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'                                END ',
'                         when ''EXT''  Then',
'                                CASE',
'                                    WHEN dbms_lob.getlength(photo_blob) > 0 THEN',
'                                      ''https://ifinance.dct.gov.ae:8004/dct/prod/ExtUser/view/'' || User_name',
'                                    ELSE',
'                                       ''https://ifinance.dct.gov.ae:8004/dct/prod/ExtUser/view/U0000''',
'                                END',
'    End ) PHOTO',
'from (select ID,',
'       PAYMENT_RECOMMENDATION_ID,',
'       STEP_NO,',
'       PERSON_ID,',
'       (case person_type when ''INT''  Then',
'                                (select initcap(e.full_name_en) from employees_v e where e.person_id = h.person_id)',
'                         when ''EXT''  Then',
'                                (select initcap(u.first_name || '' '' || u.last_name) from dct_ext_users u where u.user_id = h.person_id)',
'           End                      ) Full_name,',
'           ',
'       (case person_type when ''INT''  Then',
'                                (select e.user_name from employees_v e where e.person_id = h.person_id)',
'                         when ''EXT''  Then',
'                                (select u.user_name from dct_ext_users u where u.user_id = h.person_id)',
'           End                      ) User_name,    ',
'       PERSON_TYPE,',
'       ROLE_ID,',
'       (select r.role_name from project_role r where r.role_id = h.role_id) Role_Name,',
'       ACTION_REQUIRED,',
'       recevied_date + INTERVAL ''0 04:00:00.0'' DAY TO SECOND   as recevied_date ,',
'       STATUS,',
'       action_date + INTERVAL ''0 04:00:00.0'' DAY TO SECOND   as    action_date,',
'       COMMENTS,',
'       APPROVAL_TYPE,',
'       CREATED_ON,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'      nvl(h.reminder_count,0) reminder_count,',
'       h.reminder_by,',
'       (case person_type when ''INT''  Then',
'                                (select e.photo_blob from employees_v e where e.person_id = h.person_id)',
'                         when ''EXT''  Then',
'                                (select u.photo_blob from dct_ext_users u where u.user_id = h.person_id)',
'           End                      ) PHOTO_BLOB',
'      , h.on_behalf     ',
'  from CWIP_PAYMENT_REC_APPROVAL_HISTORY h',
'  where PAYMENT_RECOMMENDATION_ID = :P15_PAYMENT_RECOMMENDATION_ID)',
'  order by step_no , id '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P15_PAYMENT_RECOMMENDATION_ID'
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
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(23917523085897559)
,p_max_row_count=>'1000000'
,p_show_search_bar=>'N'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>23917523085897559
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12074497148523711)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12074842273523712)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12075235890523712)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12075653534523713)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12076077364523713)
,p_db_column_name=>'PERSON_TYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Person Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12076472811523714)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Role Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12076882411523714)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12077232743523714)
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
 p_id=>wwv_flow_api.id(12077665067523715)
,p_db_column_name=>'STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12078022379523715)
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
 p_id=>wwv_flow_api.id(12078467359523716)
,p_db_column_name=>'COMMENTS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12078802857523716)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12079264819523717)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12079698086523717)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12080059367523718)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12080472854523718)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12080875060523719)
,p_db_column_name=>'FULL_NAME'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12081234473523719)
,p_db_column_name=>'ROLE_NAME'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Role'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12081621155523720)
,p_db_column_name=>'PHOTO_BLOB'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Photo Blob'
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
 p_id=>wwv_flow_api.id(12082083685523721)
,p_db_column_name=>'PHOTO'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_display_condition_type=>'NEVER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(14934349517770879)
,p_db_column_name=>'REMINDER_COUNT'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Reminder Count'
,p_column_link=>'f?p=&APP_ID.:55:&SESSION.::&DEBUG.:55:P55_PAYMENT_RECOMMENDATION_ID,P55_PPERSON_ID:#PAYMENT_RECOMMENDATION_ID#,#PERSON_ID#'
,p_column_linktext=>'#REMINDER_COUNT#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(14934377298770880)
,p_db_column_name=>'REMINDER_BY'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Reminder By'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(23943231946594923)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'120824'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:FULL_NAME:ROLE_NAME:ACTION_REQUIRED:RECEVIED_DATE:STATUS:ACTION_DATE:REMINDER_COUNT:COMMENTS:'
,p_sort_column_1=>'STEP_NO'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(54942452994684959)
,p_report_id=>wwv_flow_api.id(23943231946594923)
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
 p_id=>wwv_flow_api.id(29919830658177127)
,p_plug_name=>'Previous Payments not approved'
,p_icon_css_classes=>'fa-warning'
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--customIcons:t-Alert--warning:t-Alert--removeHeading'
,p_plug_template=>wwv_flow_api.id(10214032995597758)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<b style="color:red;">There are pending payments applications </b> </br>',
'<b style="color:red;">Reference Number:  </b>&P15_LIST.',
'</br>',
'<b> Please approve the previous payment application to proceed with this payment application. </b>'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P15_LIST'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(86569271487893535)
,p_plug_name=>'Payment Applications History'
,p_icon_css_classes=>'fa-history'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>80
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CV.PAYMENT_RECOMMENDATION_ID,',
'       CV.REFERENCE_NUMBER,',
'       CV.PAYMENT_RECOMMENDATION_DATE,',
'       CV.CONTRACT_NUMBER,',
'       CV.PERIOD,',
'       CV.CONTRACT_TITLE,',
'       CV.CONTRACT_REFERENCE,',
'       CV.CONTRACT_DESCRIPTION,',
'       CV.INITIAL_CONTRACT_AMOUNT,',
'       CV.CONTRACT_AMOUNT,',
'       CV.CONTRACT_VARIATION_AMOUNT,',
'       CV.DCT_CONTRACT_VARIATION_AMOUNT,',
'       CV.BILLED_AMOUNT,',
'       CV.VENDOR_NUMBER,',
'       CV.VENDOR_NAME,',
'       CV.VENDOR_SITE_CODE,',
'       CV.REVISED_COMPLETION_DATE,',
'       CV.PROJECT_NUMBER,',
'       CV.PROJECT_NAME,',
'       CV.DCT_PROJECT_CODE,',
'       CV.PAYMENT_NUMBER,',
'       CV.PAYMENT_TYPE,',
'       CV.VALUATION_PERIOD,',
'       CV.EVALUATION_METHOD,',
'       CV.PREVIOUSELY_CERIFIED_APPROVED,',
'       CV.PREVIOUSELY_CERIFIED_PENDING,',
'       CV.CURRENT_VALUATION_AMOUNT,',
'       CV.DEDUCTIONS,',
'       CV.CUMULATIVE_CERIFIED_AMOUNT,',
'       CV.NET_AMOUNT_PAYABLE,',
'       CV.ATTACHEMENTS,',
'       CV.CREATED_BY,',
'       CV.CREATED_ON,',
'       CV.UPDATED_BY,',
'       CV.UPDATED_ON,',
'       CV.APPROVAL_STATUS,',
'       CV.SEQ_COUNT,',
'       CV.FINAL_APPROVE_ON,',
'       CV.INVOICE_NUM,',
'       CV.INVOICE_DATE,',
'       CV.TOTAL_INVOICE_AMOUNT,',
'       CV.CURRENCY,',
'       CV.CONTRACT_STAGE,',
'       CV.SCOPE_OF_WORK,',
'       CV.REMARK,',
'       CV.VALUATION_PERIOD_FROM,',
'       CV.VALUATION_PERIOD_TO,',
'       CV.IPC_NUMBER,',
'       CV.PREVIOUS_PAYMENTS,',
'       XX.received_date,',
'       XX.emp',
'  from CWIP_PAYMENT_RECOMMENDATION_V  cv,',
'    (select h.PAYMENT_RECOMMENDATION_ID , max(h.RECEVIED_DATE)  received_date,',
'            LISTAGG( e.first_name || '' '' || e.last_name , ''; '') WITHIN GROUP (ORDER BY hire_date) emp',
'        from cwip_payment_rec_approval_history h, dct_employees_list2 e, cwip_payment_recommendation m',
'        where h.person_id = e.person_id',
'        and m.PAYMENT_RECOMMENDATION_ID = h.PAYMENT_RECOMMENDATION_ID',
'        and h.STATUS = ''Pending''',
'        and m.APPROVAL_STATUS in (''In-Progress'' , ''Hold'')',
'        group by h.PAYMENT_RECOMMENDATION_ID) XX',
' where CV.PAYMENT_RECOMMENDATION_ID = xx.payment_recommendation_id (+)',
'--and CV.project_number = nvl(:P43_PROJECT , CV.project_number)',
'and CV.contract_number = nvl(:P15_CONTRACT_NUMBER, CV.contract_number)',
'and CV.PAYMENT_RECOMMENDATION_ID != :P15_PAYMENT_RECOMMENDATION_ID',
'order by to_number(CV.PAYMENT_NUMBER) desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P15_PAYMENT_RECOMMENDATION_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Payment Applications History'
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
 p_id=>wwv_flow_api.id(86569420309893536)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>127005462138795806
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86569544001893537)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86569621587893538)
,p_db_column_name=>'REFERENCE_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Reference Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86569668780893539)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_DATE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Payment Recommendation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86569803559893540)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86569876232893541)
,p_db_column_name=>'PERIOD'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Period'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86569993513893542)
,p_db_column_name=>'CONTRACT_TITLE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Contract Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86570088120893543)
,p_db_column_name=>'CONTRACT_REFERENCE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Contract Reference'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86570189750893544)
,p_db_column_name=>'CONTRACT_DESCRIPTION'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Contract Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86570333101893545)
,p_db_column_name=>'INITIAL_CONTRACT_AMOUNT'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Initial Contract Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86570385768893546)
,p_db_column_name=>'CONTRACT_AMOUNT'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Contract Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86570513376893547)
,p_db_column_name=>'CONTRACT_VARIATION_AMOUNT'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Contract Variation Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86570608972893548)
,p_db_column_name=>'DCT_CONTRACT_VARIATION_AMOUNT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Dct Contract Variation Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86570660953893549)
,p_db_column_name=>'BILLED_AMOUNT'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Billed Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86570774787893550)
,p_db_column_name=>'VENDOR_NUMBER'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Vendor Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86570952049893551)
,p_db_column_name=>'VENDOR_NAME'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Vendor Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86571006733893552)
,p_db_column_name=>'VENDOR_SITE_CODE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Vendor Site Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86571102531893553)
,p_db_column_name=>'REVISED_COMPLETION_DATE'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Revised Completion Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86571255964893554)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86571288761893555)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86571407289893556)
,p_db_column_name=>'DCT_PROJECT_CODE'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'DCT Project Code'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86571514770893557)
,p_db_column_name=>'PAYMENT_NUMBER'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Payment Number'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86571598048893558)
,p_db_column_name=>'PAYMENT_TYPE'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Payment Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86571705915893559)
,p_db_column_name=>'VALUATION_PERIOD'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Valuation Period'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86571839642893560)
,p_db_column_name=>'EVALUATION_METHOD'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Evaluation Method'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86571895033893561)
,p_db_column_name=>'PREVIOUSELY_CERIFIED_APPROVED'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Previousely Cerified Approved'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86571981594893562)
,p_db_column_name=>'PREVIOUSELY_CERIFIED_PENDING'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Previousely Cerified Pending'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86572121065893563)
,p_db_column_name=>'CURRENT_VALUATION_AMOUNT'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Current Valuation Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86572217390893564)
,p_db_column_name=>'DEDUCTIONS'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Deductions'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86572319437893565)
,p_db_column_name=>'CUMULATIVE_CERIFIED_AMOUNT'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Cumulative Cerified Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86572394481893566)
,p_db_column_name=>'NET_AMOUNT_PAYABLE'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Net Amount Payable'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86572545430893567)
,p_db_column_name=>'ATTACHEMENTS'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Attachements'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86572568112893568)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86572752663893569)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86572848795893570)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86572907954893571)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86573048283893572)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86573133852893573)
,p_db_column_name=>'SEQ_COUNT'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Seq Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86573163259893574)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86573335835893575)
,p_db_column_name=>'INVOICE_NUM'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Invoice Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86573410986893576)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86573517974893577)
,p_db_column_name=>'TOTAL_INVOICE_AMOUNT'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Total Invoice Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86573627056893578)
,p_db_column_name=>'CURRENCY'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86573754641893579)
,p_db_column_name=>'CONTRACT_STAGE'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Contract Stage'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86573800714893580)
,p_db_column_name=>'SCOPE_OF_WORK'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Scope Of Work'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86644043726269931)
,p_db_column_name=>'REMARK'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'Remark'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86644130232269932)
,p_db_column_name=>'VALUATION_PERIOD_FROM'
,p_display_order=>460
,p_column_identifier=>'AT'
,p_column_label=>'Valuation Period From'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86644226661269933)
,p_db_column_name=>'VALUATION_PERIOD_TO'
,p_display_order=>470
,p_column_identifier=>'AU'
,p_column_label=>'Valuation Period To'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86644285350269934)
,p_db_column_name=>'IPC_NUMBER'
,p_display_order=>480
,p_column_identifier=>'AV'
,p_column_label=>'Ipc Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86644448494269935)
,p_db_column_name=>'PREVIOUS_PAYMENTS'
,p_display_order=>490
,p_column_identifier=>'AW'
,p_column_label=>'Previous Payments'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86644490970269936)
,p_db_column_name=>'RECEIVED_DATE'
,p_display_order=>500
,p_column_identifier=>'AX'
,p_column_label=>'Received Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86644600772269937)
,p_db_column_name=>'EMP'
,p_display_order=>510
,p_column_identifier=>'AY'
,p_column_label=>'Pending With'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(86664731186268098)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1271008'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REFERENCE_NUMBER:CONTRACT_NUMBER:CONTRACT_AMOUNT:VENDOR_NAME:DCT_PROJECT_CODE:PAYMENT_NUMBER:PREVIOUSELY_CERIFIED_APPROVED:PREVIOUSELY_CERIFIED_PENDING:CURRENT_VALUATION_AMOUNT:CUMULATIVE_CERIFIED_AMOUNT:NET_AMOUNT_PAYABLE:APPROVAL_STATUS:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12050544618523673)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(23522576698013971)
,p_button_name=>'back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:&P15_PAGE_FROM.:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12068656751523701)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(23567132336321459)
,p_button_name=>'AddComment'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10306520873597824)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Collaborate '
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:18:&SESSION.::&DEBUG.:18:P18_PAYMENT_RECOMMENDATION_ID,P18_ACTION:&P15_PAYMENT_RECOMMENDATION_ID.,New'
,p_icon_css_classes=>'fa-envelope-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(86789034134571571)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(172338997090809762)
,p_button_name=>'Add_Attachement'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10306520873597824)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Attachement'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:17:&SESSION.::&DEBUG.::P17_PAYMENT_RECOMMENDATION_ID,P17_ALLOW_INSERT,P17_CONTRACT_NUMBER:&P15_PAYMENT_RECOMMENDATION_ID.,Y,&P15_CONTRACT_NUMBER.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12699995082649323)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(23522576698013971)
,p_button_name=>'Approve'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--success:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'&P15_APPROVE_LABEL.'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:27:&SESSION.::&DEBUG.::P27_ID,P27_ACTION,P27_APPROVE_LABEL,P27_REJECT_LABEL,P27_PREVIOUS_PAYMENT_APPROVED:&P15_ID.,Approve,&P15_APPROVE_LABEL.,&P15_REJECT_LABEL.,&P15_PREVIOUS_PAYMENT_APPROVED.'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  c.reference_number',
'from cwip_payment_rec_approval_history h , cwip_payment_recommendation c',
'where h.payment_recommendation_id = c.payment_recommendation_id',
'and person_id = :PERSON_ID',
'and c.contract_number = (Select x.contract_number',
'                        from cwip_payment_recommendation x',
'                        where x.payment_recommendation_id = :P15_PAYMENT_RECOMMENDATION_ID)',
'and c.APPROVAL_STATUS in (''Pending'', ''Rejected'' , ''Returned'', ''Hold'')',
'and h.id <> :P15_ID',
'and c.seq_count < :P15_SEQ_COUNT'))
,p_button_condition_type=>'NOT_EXISTS'
,p_icon_css_classes=>'fa-check-square'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12700080465649324)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(23522576698013971)
,p_button_name=>'Reject'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--danger:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'&P15_REJECT_LABEL.'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:27:&SESSION.::&DEBUG.::P27_ID,P27_ACTION,P27_APPROVE_LABEL,P27_REJECT_LABEL,P27_PREVIOUS_PAYMENT_APPROVED:&P15_ID.,Reject,&P15_APPROVE_LABEL.,&P15_REJECT_LABEL.,&P15_PREVIOUS_PAYMENT_APPROVED.'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  c.reference_number',
'from cwip_payment_rec_approval_history h , cwip_payment_recommendation c',
'where h.payment_recommendation_id = c.payment_recommendation_id',
'and person_id = :PERSON_ID',
'and c.contract_number = (Select x.contract_number',
'                        from cwip_payment_recommendation x',
'                        where x.payment_recommendation_id = :P15_PAYMENT_RECOMMENDATION_ID)',
'and c.APPROVAL_STATUS in (''Pending'', ''Hold'')',
'and h.id <> :P15_ID',
'and c.seq_count < :P15_SEQ_COUNT'))
,p_button_condition_type=>'NOT_EXISTS'
,p_icon_css_classes=>'fa-times-square'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12700192827649325)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(23522576698013971)
,p_button_name=>'Delegate'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--warning:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'Delegate'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:19:&SESSION.::&DEBUG.:19:P19_ID,P19_FROM_PERSON_ID,P19_HSITORY_ID:&P15_PAYMENT_RECOMMENDATION_ID.,&PERSON_ID.,&P15_ID.'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  c.PAYMENT_RECOMMENDATION_ID',
'from cwip_payment_rec_approval_history h , cwip_payment_recommendation c',
'where h.payment_recommendation_id = c.payment_recommendation_id',
'and person_id = :PERSON_ID',
'and c.contract_number = (Select x.contract_number',
'                        from cwip_payment_recommendation x',
'                        where x.payment_recommendation_id = :P15_PAYMENT_RECOMMENDATION_ID)',
'and c.APPROVAL_STATUS in (''Pending'' , ''Hold'')',
'--and h.STATUS in (''Pending'' , ''Hold'')',
'and h.id <> :P15_ID',
'and c.seq_count < :P15_SEQ_COUNT'))
,p_button_condition_type=>'NOT_EXISTS'
,p_icon_css_classes=>'fa-sign-language'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12700278038649326)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(23522576698013971)
,p_button_name=>'More_Info'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'More Info'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:26:&SESSION.::&DEBUG.:26:P26_PAYMENT_RECOMMENDATION_ID,P26_PAYMENT_RECOMMENDATION_ID_H:&P15_PAYMENT_RECOMMENDATION_ID.,&P15_PAYMENT_RECOMMENDATION_ID.'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  c.reference_number',
'from cwip_payment_rec_approval_history h , cwip_payment_recommendation c',
'where h.payment_recommendation_id = c.payment_recommendation_id',
'and person_id = :PERSON_ID',
'and c.contract_number = (Select x.contract_number',
'                        from cwip_payment_recommendation x',
'                        where x.payment_recommendation_id = :P15_PAYMENT_RECOMMENDATION_ID)',
'and c.APPROVAL_STATUS in (''Pending'' ,''Hold'')',
'and h.id <> :P15_ID',
'and c.seq_count < :P15_SEQ_COUNT'))
,p_button_condition_type=>'NOT_EXISTS'
,p_icon_css_classes=>'fa-info'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(14393546302263276)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(23522576698013971)
,p_button_name=>'Hold'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--warning:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'Hold'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:27:&SESSION.::&DEBUG.::P27_ID,P27_ACTION,P27_PREVIOUS_PAYMENT_APPROVED:&P15_ID.,Hold,&P15_PREVIOUS_PAYMENT_APPROVED.'
,p_button_condition=>'P15_APPROVAL_STATUS2'
,p_button_condition2=>'Hold'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_icon_css_classes=>'fa-pause'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(12094206424523738)
,p_branch_name=>'Go To Page 3'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4999758650563957)
,p_name=>'P15_APPROVE_LABEL'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(23523242051013989)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4999950563563958)
,p_name=>'P15_REJECT_LABEL'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(23523242051013989)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12052558395523676)
,p_name=>'P15_PAYMENT_RECOMMENDATION_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>1
,p_item_plug_id=>wwv_flow_api.id(23522576698013971)
,p_item_source_plug_id=>wwv_flow_api.id(23523242051013989)
,p_source=>'PAYMENT_RECOMMENDATION_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12056525391523681)
,p_name=>'P15_PERIOD'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(23523242051013989)
,p_item_source_plug_id=>wwv_flow_api.id(23523242051013989)
,p_prompt=>'Period'
,p_source=>'PERIOD'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_cMaxlength=>50
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21864072728304242)
,p_name=>'P15_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(23523242051013989)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21963866936318826)
,p_name=>'P15_PAGE_FROM'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(23522576698013971)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29919645743177125)
,p_name=>'P15_SEQ_COUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(23522576698013971)
,p_item_source_plug_id=>wwv_flow_api.id(23523242051013989)
,p_source=>'SEQ_COUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29920065657177129)
,p_name=>'P15_LIST'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(23523242051013989)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  c.reference_number',
'from cwip_payment_rec_approval_history h , cwip_payment_recommendation c',
'where h.payment_recommendation_id = c.payment_recommendation_id',
'and person_id = :PERSON_ID',
'and c.contract_number = (Select x.contract_number',
'                        from cwip_payment_recommendation x',
'                        where x.payment_recommendation_id = :P15_PAYMENT_RECOMMENDATION_ID)',
'and h.status = ''Pending''',
'and h.id <> :P15_ID'))
,p_source_type=>'QUERY_COLON'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86796412733571566)
,p_name=>'P15_INVOICE_NUM2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(213872300904743814)
,p_prompt=>'Invoice Ref :'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:margin-left-none'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86796773459571564)
,p_name=>'P15_INVOICE_DATE2'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(213872300904743814)
,p_prompt=>'Dated :'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:margin-left-none'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86797255676571564)
,p_name=>'P15_TOTAL_INVOICE_AMOUNT2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(213872300904743814)
,p_prompt=>'Invoice Amount (Including VAT) :'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:margin-left-none'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86797899165571563)
,p_name=>'P15_PAYMENT_TYPE2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(213872420028743815)
,p_prompt=>'Payment Type :'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:margin-left-none'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86798333513571563)
,p_name=>'P15_CUMULATIVE_CERTIFIED_TO_DATE'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(213872420028743815)
,p_prompt=>'Cumulative Certified to date :'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:margin-left-none'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86798756581571563)
,p_name=>'P15_CERTIFIED_DATE'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(213872420028743815)
,p_prompt=>'Certified Date :'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:margin-left-none'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86799071711571563)
,p_name=>'P15_PREVIOUSLY_CERTIFIED'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(213872420028743815)
,p_prompt=>'Previously Certified :'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:margin-left-none'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86799471931571563)
,p_name=>'P15_CURRENCY2'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(213872420028743815)
,p_prompt=>'Currency :'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:margin-left-none'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86799866193571563)
,p_name=>'P15_DUE_AMOUNT_WITHOUT_VAT'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(213872420028743815)
,p_prompt=>'Due Amount :'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:margin-left-none'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86800612909571562)
,p_name=>'P15_DUE_AMOUNT_WITH_VAT_WORDS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(213872501670743816)
,p_prompt=>'Due Amount (including VAT)  :'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:margin-left-none'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86801044959571562)
,p_name=>'P15_TOTAL_INVOICE_AMOUNT3'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(213872501670743816)
,p_prompt=>'Total Invoice Amount3'
,p_source=>'P15_TOTAL_INVOICE_AMOUNT2'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_grid_column=>9
,p_field_template=>wwv_flow_api.id(10305891232597821)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86801718697571562)
,p_name=>'P15_SCOPE_OF_WORK2'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(213872534992743817)
,p_prompt=>'Scope Of Work :'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:margin-left-none'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86802128975571561)
,p_name=>'P15_REMARK2'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(213872534992743817)
,p_prompt=>'Remark :'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:margin-left-none'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86802763383571561)
,p_name=>'P15_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(213873266993743824)
,p_item_source_plug_id=>wwv_flow_api.id(45528463563636221)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Created By :</span>'
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P15_PAYMENT_RECOMMENDATION_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86803205316571560)
,p_name=>'P15_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(213873266993743824)
,p_item_source_plug_id=>wwv_flow_api.id(45528463563636221)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Created On :</span>'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>'P15_PAYMENT_RECOMMENDATION_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86803618656571560)
,p_name=>'P15_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(213873266993743824)
,p_item_source_plug_id=>wwv_flow_api.id(45528463563636221)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Updated By :</span>'
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P15_PAYMENT_RECOMMENDATION_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86803988980571560)
,p_name=>'P15_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(213873266993743824)
,p_item_source_plug_id=>wwv_flow_api.id(45528463563636221)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Updated On :</span>'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>'P15_PAYMENT_RECOMMENDATION_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86804748409571559)
,p_name=>'P15_REFERENCE_NUMBER2'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(213869229341743784)
,p_item_source_plug_id=>wwv_flow_api.id(45528463563636221)
,p_prompt=>'REC Ref :'
,p_source=>'REFERENCE_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86805152908571559)
,p_name=>'P15_DATE_PREPARED'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(213869229341743784)
,p_item_source_plug_id=>wwv_flow_api.id(45528463563636221)
,p_prompt=>'Date Prepared :'
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:margin-left-none'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86805509054571559)
,p_name=>'P15_PROJECT_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(213869229341743784)
,p_prompt=>'Project :'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:margin-left-none'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86805866581571559)
,p_name=>'P15_EFFECTIVE_DATE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(213869229341743784)
,p_prompt=>'Effective Date :'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:margin-left-none'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86806299633571559)
,p_name=>'P15_CONTRACTING_PARTY'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(213869229341743784)
,p_prompt=>'Contracting Party :'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:margin-left-none'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86806723282571559)
,p_name=>'P15_AGREEMENT_PERIOD'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(213869229341743784)
,p_prompt=>'Agreement Period :'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:margin-left-none'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86807145789571558)
,p_name=>'P15_CONTRACT_TITLE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(213869229341743784)
,p_prompt=>'Contract Title :'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:margin-left-none'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86807493011571558)
,p_name=>'P15_ORIGINAL_AGREEMENT_FEE'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(213869229341743784)
,p_prompt=>'Original Agreement Fee :'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:margin-left-none'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86807876152571558)
,p_name=>'P15_AGREEMENT_REF'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(213869229341743784)
,p_prompt=>'Agreement Ref :'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:margin-left-none'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86808281122571558)
,p_name=>'P15_APPROVED_VARIATION'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(213869229341743784)
,p_prompt=>'Approved Variation :'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:margin-left-none'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86808683421571558)
,p_name=>'P15_PURCHASE_ORDER'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(213869229341743784)
,p_prompt=>'Purchase Order :'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:margin-left-none'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86809064319571558)
,p_name=>'P15_REVISED_AGREEMENT_FEE'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(213869229341743784)
,p_prompt=>'Revised Agreement Fee :'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:margin-left-none'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86809464210571557)
,p_name=>'P15_CURRENT_VALUATION_AMOUNT2'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(213869229341743784)
,p_prompt=>'Current Valuation Amount :'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:margin-left-none'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86809945603571557)
,p_name=>'P15_PERIOD2'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(213869229341743784)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86810320254571557)
,p_name=>'P15_DEDUCTIONS2'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(213869229341743784)
,p_prompt=>'Deductions :'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:margin-left-none'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86810731205571557)
,p_name=>'P15_APPROVAL_STATUS2'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(213869229341743784)
,p_prompt=>'Approval Status :'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:margin-left-none'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(21864117490304243)
,p_computation_sequence=>10
,p_computation_item=>'P15_ID'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select id',
'from cwip_payment_rec_approval_history',
'where payment_recommendation_id = :P15_PAYMENT_RECOMMENDATION_ID',
'and person_id = :PERSON_ID',
'and status = ''Pending'''))
,p_computation_error_message=>'Error in P15_ID item'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(5000035868563959)
,p_computation_sequence=>10
,p_computation_item=>'P15_APPROVE_LABEL'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  case action_required when ''Approve/Reject''   then ''Approve''',
'                                                when ''Recommend/Return'' then ''Recommend''',
'                                                when ''Forward/Return'' then ''Forward''',
'                                                else ''Approve''',
'        end approve_action',
'from cwip_payment_rec_approval_history',
'where payment_recommendation_id = :P15_PAYMENT_RECOMMENDATION_ID',
'and person_id = :PERSON_ID',
'and status = ''Pending''',
'and ROWNUM = 1'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(5000072678563960)
,p_computation_sequence=>20
,p_computation_item=>'P15_REJECT_LABEL'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  case action_required when ''Approve/Reject''   then ''Reject''',
'                                                when ''Recommend/Return'' then ''Return''',
'                                                when  ''Forward/Return''     then ''Returned''',
'                                                else ''Reject''',
'        end reject_action',
'from cwip_payment_rec_approval_history',
'where payment_recommendation_id = :P15_PAYMENT_RECOMMENDATION_ID',
'and person_id = :PERSON_ID',
'and status = ''Pending''',
'and ROWNUM = 1'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(12089973157523733)
,p_name=>'Dialog Close'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(12068656751523701)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12090475467523735)
,p_event_id=>wwv_flow_api.id(12089973157523733)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(23567233414321460)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(12090850400523735)
,p_name=>'Comments Dialog Closed'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(23567233414321460)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12091366666523735)
,p_event_id=>wwv_flow_api.id(12090850400523735)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(23567233414321460)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(12700381780649327)
,p_name=>'Approve DA'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(12699995082649323)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
,p_display_when_type=>'NEVER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12700491417649328)
,p_event_id=>wwv_flow_api.id(12700381780649327)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'you are going to approve Payment recommendation# &P15_REFERENCE_NUMBER., Are you sure?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12700512443649329)
,p_event_id=>wwv_flow_api.id(12700381780649327)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'cwip_rec_payment_workflow.approve(:P15_PAYMENT_RECOMMENDATION_ID,:PERSON_ID);',
'End;'))
,p_attribute_02=>'P15_PAYMENT_RECOMMENDATION_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12700603576649330)
,p_event_id=>wwv_flow_api.id(12700381780649327)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Payment recommendation# &P15_REFERENCE_NUMBER. Approved Successfully.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12700784473649331)
,p_event_id=>wwv_flow_api.id(12700381780649327)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(12700851489649332)
,p_name=>'Reject DA'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(12700080465649324)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
,p_display_when_type=>'NEVER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12700906600649333)
,p_event_id=>wwv_flow_api.id(12700851489649332)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'you are going to reject, Are you sure?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12701063331649334)
,p_event_id=>wwv_flow_api.id(12700851489649332)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'cwip_rec_payment_workflow.REJECTED(:P15_PAYMENT_RECOMMENDATION_ID,:PERSON_ID);',
'End;'))
,p_attribute_02=>'P15_PAYMENT_RECOMMENDATION_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12701187764649335)
,p_event_id=>wwv_flow_api.id(12700851489649332)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'The Payment Recommendation &P15_REFERENCE_NUMBER. has been rejected'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12701221671649336)
,p_event_id=>wwv_flow_api.id(12700851489649332)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(5000966807563969)
,p_name=>'Show Previous Payments not approved DA'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P15_PREVIOUS_PAYMENT_APPROVED'
,p_condition_element=>'P15_PREVIOUS_PAYMENT_APPROVED'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5001105046563970)
,p_event_id=>wwv_flow_api.id(5000966807563969)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(29919830658177127)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5001195587563971)
,p_event_id=>wwv_flow_api.id(5000966807563969)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(29919830658177127)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(14391459927263256)
,p_process_sequence=>20
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get contract details'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select    VENDOR_NAME ',
'        , nvl(CONTRACT_TITLE , CONTRACT_DESCRIPTION)',
'--        , CONTRACT_TITLE  dct_description',
'  --      , trim(to_char(INITIAL_CONTRACT_AMOUNT, ''99,999,999,999,999.99''))    INITIAL_CONTRACT_AMOUNT',
'     --   , trim(to_char(NVL(CONTRACT_VARIATION_AMOUNT, nvl(DCT_CONTRACT_VARIATION_AMOUNT, 0)), ''99,999,999,999,999.99''))    variation_amount',
'    --    , trim(to_char(nvl(INITIAL_CONTRACT_AMOUNT,0) + NVL(CONTRACT_VARIATION_AMOUNT, nvl(DCT_CONTRACT_VARIATION_AMOUNT, 0)), ''99,999,999,999,999.99''))  CONTRACT_AMOUNT',
'into :P15_VENDOR_NAME, ',
'     :P15_CONTRACT_DESCRIPTION',
'--    , DCT_DESCRIPTION, ',
' --    :P15_INITIAL_CONTRACT_AMOUNT',
'     -- ,:P15_VARIATION_AMOUNT',
'   --  ,:P15_CONTRACT_AMOUNT',
'from cwip_contracts_v',
'where CONTRACT_NUMBER = (select x.CONTRACT_NUMBER',
'                        from cwip_payment_recommendation x',
'                        where x.payment_recommendation_id = :P15_PAYMENT_RECOMMENDATION_ID);'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_type=>'NEVER'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(12060572154523686)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(23523242051013989)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Payment Recommendation Form'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(12060100650523684)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(23523242051013989)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Payment Recommendation Form'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(71136915123892572)
,p_process_sequence=>20
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialized Payment details - new'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  cpr.reference_number',
'        ,to_char(cpr.created_on,''DD-MON-YYYY'')            Date_Prepared',
'        ,(select nvl(p.dct_project_name,p.project_name)',
'          from project p',
'          where p.project_number = (select cp.project_number',
'                                    from cwip_contract_projects cp',
'                                    where cp.contract_number = cpr.contract_number',
'                                   and rownum = 1)) Project_name',
'       ,to_char(cpr.final_approve_on,''DD-MON-YYYY'')        Effective_date',
'       ,nvl(c.VENDOR_NAME , (select v.vendor_name',
'        from vendors v',
'        where v.vendor_number = c.vendor_number',
'        and v.vendor_site_code = c.vendor_site_code)) Contracting_Party',
'      ,to_char(cpr.VALUATION_PERIOD_FROM ,''DD-MON-YYYY'')                       Agreement_period',
'      ,c.contract_title',
'      ,trim(to_char(nvl(c.initial_contract_amount,0),''99,999,999,999.99''))      Original_agreement_fee',
'      ,c.contract_reference             Agreement_REF',
'      ,trim(to_char(nvl(nvl(c.dct_contract_variation_amount, c.contract_variation_amount),0),''99,999,999,999.99''))      Approved_Variation',
'      ,cpr.contract_number                                                               Purchase_order              -- XXX',
'    --  ,trim(to_char(nvl(c.INITIAL_CONTRACT_AMOUNT ,0),''99,999,999,999.99''))               Revised_agreement_fee',
'     ,trim(to_char(nvl(c.INITIAL_CONTRACT_AMOUNT ,0)',
'	                    + nvl(CWIP_REC_PAYMENT_UTIL.get_CONTRACT_VARIATION_AMOUNT(cpr.contract_number),0)',
'                    ,''99,999,999,999.99''))               Revised_agreement_fee',
'      ',
'    -- 2nd Part  ',
'      ,cpr.invoice_num                                                  invoice_num',
'      ,to_char(cpr.invoice_date,''DD-MON-YYYY'')                          invoice_date',
'      ,trim(to_char(nvl(cpr.total_invoice_amount,0),''99,999,999,999.99''))         total_invoice_amount',
'      ',
'    --3rd Part  ',
'      ,(select l.value ',
'        from cwip_lookup_values l',
'        where lookup_id = 2',
'        and l.value_id = cpr.payment_type)                               Payment_type',
'      ,trim(to_char((',
'        (select nvl(sum(a.net_amount_payable),0)',
'        from cwip_payment_recommendation a',
'        where a.contract_number = cpr.contract_number',
'        and a.seq_count < cpr.seq_count ',
'        ) + cpr.net_amount_payable',
'        ),''99,999,999,999.99''))                                            Cumulative_Certified_to_date  -- XXXX',
'      ,to_char(cpr.VALUATION_PERIOD_FROM,''DD-MON-YYYY'')                             Certified_Date                -- XXX',
'      ,trim(to_char((',
'    select nvl(sum(a.net_amount_payable),0)',
'    from cwip_payment_recommendation a',
'    where a.contract_number = cpr.contract_number',
'--    and a.approval_status = ''Approved''',
'    and a.seq_count < cpr.seq_count',
'    ),''99,999,999,999.99''))            Previously_certified',
'      ,cpr.currency                                                             Currency',
'      ,trim(to_char(nvl(cpr.current_valuation_amount,0),''99,999,999,999.99''))     Due_amount_without_VAT',
'      ',
'     --4th Part',
' --    ,dct_util.spell_number(cpr.net_amount_payable) || '' Only Including VAT''   Due_amount_With_VAT_words',
'     ,dct_util.spell_number(cpr.total_invoice_amount) || '' Only Including VAT''   Due_amount_With_VAT_words',
'      ,trim(to_char(nvl(cpr.current_valuation_amount,0),''99,999,999,999.99''))     current_valuation_amount',
'      ,cpr.period',
'      ,trim(to_char(nvl(cpr.deductions,0),''99,999,999,999.99''))                   deductions',
'    -- 5th Part',
'      ,cpr.scope_of_work',
'      ,cpr.remark',
'',
'      ,cpr.approval_status',
'      ,cpr.created_by',
'      ,to_char(cpr.created_on,''DD-MON-YYYY HH:MIPM'')',
'      ,cpr.updated_by',
'      ,to_char(cpr.updated_on, ''DD-MON-YYYY HH:MIPM'')',
'into',
'    :P15_REFERENCE_NUMBER2,',
'    :P15_DATE_PREPARED,',
'    :P15_PROJECT_NAME,',
'    :P15_EFFECTIVE_DATE,',
'    :P15_CONTRACTING_PARTY,',
'    :P15_AGREEMENT_PERIOD,',
'    :P15_CONTRACT_TITLE,',
'    :P15_ORIGINAL_AGREEMENT_FEE,',
'    :P15_AGREEMENT_REF,',
'    :P15_APPROVED_VARIATION,',
'    :P15_PURCHASE_ORDER,',
'    :P15_REVISED_AGREEMENT_FEE,',
'    :P15_INVOICE_NUM2,',
'    :P15_INVOICE_DATE2,',
'    :P15_TOTAL_INVOICE_AMOUNT2,',
'    :P15_PAYMENT_TYPE2,',
'    :P15_CUMULATIVE_CERTIFIED_TO_DATE,',
'    :P15_CERTIFIED_DATE,',
'    :P15_PREVIOUSLY_CERTIFIED,',
'    :P15_CURRENCY2,',
'    :P15_DUE_AMOUNT_WITHOUT_VAT,',
'    :P15_DUE_AMOUNT_WITH_VAT_WORDS,',
'    :P15_CURRENT_VALUATION_AMOUNT2,',
'    :P15_PERIOD2,',
'    :P15_DEDUCTIONS2,',
'    :P15_SCOPE_OF_WORK2,',
'    :P15_REMARK2,',
'    :P15_APPROVAL_STATUS2',
'    ,:P15_CREATED_BY',
'	,:P15_CREATED_ON',
'	,:P15_UPDATED_BY',
'	,:P15_UPDATED_ON',
'from cwip_payment_recommendation cpr, cwip_contract c',
'where cpr.payment_recommendation_id = :P15_PAYMENT_RECOMMENDATION_ID',
'and cpr.contract_number = c.contract_number;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
