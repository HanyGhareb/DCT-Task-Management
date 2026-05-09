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
,p_default_id_offset=>0
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
,p_last_updated_by=>'TCA1291'
,p_last_upd_yyyymmddhh24miss=>'20210829210540'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(20922350378859232)
,p_plug_name=>'Clarifications'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>50
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
'       CREATED_ON,',
'       CREATED_BY,',
'       CREATED_BY_PERSON_ID,',
'       UPDATED_BY,',
'       UPDATED_BY_PERSON_ID,',
'       UPDATED_ON',
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
 p_id=>wwv_flow_api.id(21864847064304250)
,p_plug_name=>'Invoice Details'
,p_parent_plug_id=>wwv_flow_api.id(23523242051013989)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(21961717762318805)
,p_plug_name=>'Audit Info'
,p_parent_plug_id=>wwv_flow_api.id(23523242051013989)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10228155320597771)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(23109308300713685)
,p_plug_name=>'Attachements'
,p_parent_plug_id=>wwv_flow_api.id(23523242051013989)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(23109402803713686)
,p_plug_name=>'Payment Recommendation Report'
,p_parent_plug_id=>wwv_flow_api.id(23109308300713685)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders:js-showMaximizeButton'
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
 p_id=>wwv_flow_api.id(23109500055713687)
,p_max_row_count=>'1000000'
,p_show_search_bar=>'N'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>23109500055713687
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12061951037523692)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12062374912523693)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12062723805523693)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12063118720523693)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Filename'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12063597180523693)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12063965809523694)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12064312875523694)
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
 p_id=>wwv_flow_api.id(12064773751523694)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'File Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12065102826523695)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12065508104523695)
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
 p_id=>wwv_flow_api.id(12065941426523695)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12066329213523695)
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
 p_id=>wwv_flow_api.id(12066762024523696)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12067136935523696)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12067570839523696)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:CWIP_PAYMENT_RECOMMENDATION_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(23576243384326212)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'120679'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:TAGS:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(23567132336321459)
,p_plug_name=>'Collaboration'
,p_icon_css_classes=>'fa-comments-o fa-anim-flash fam-sleep fam-is-success'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody:margin-left-none'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>30
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
'    c.creation_date,',
'    c.updated_date,',
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
,p_plug_display_sequence=>40
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
'       RECEVIED_DATE,',
'       STATUS,',
'       ACTION_DATE,',
'       COMMENTS,',
'       APPROVAL_TYPE,',
'       CREATED_ON,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       UPDATED_ON,',
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
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>0
,p_default_owner=>'PROD'
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
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(23943231946594923)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'120824'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:FULL_NAME:ROLE_NAME:ACTION_REQUIRED:RECEVIED_DATE:STATUS:ACTION_DATE:PHOTO:'
,p_sort_column_1=>'STEP_NO'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(29750082602773897)
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
'<b style="color:red;">Reference Number:  </b>&P15_LIST.'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P15_PREVIOUS_PAYMENT_APPROVED'
,p_plug_display_when_cond2=>'Y'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
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
 p_id=>wwv_flow_api.id(12061265752523686)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(23109308300713685)
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
 p_id=>wwv_flow_api.id(12699995082649323)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(23522576698013971)
,p_button_name=>'Approve'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--success:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'Approve'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:27:&SESSION.::&DEBUG.:27:P27_ID,P27_ACTION,P27_PREVIOUS_PAYMENT_APPROVED:&P15_ID.,Approve,&P15_PREVIOUS_PAYMENT_APPROVED.'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select * ',
'from cwip_payment_rec_approval_history',
'where person_id = :PERSON_ID',
'and status = ''Pending''',
'and PAYMENT_RECOMMENDATION_ID = :P15_PAYMENT_RECOMMENDATION_ID'))
,p_button_condition_type=>'EXISTS'
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
,p_button_image_alt=>'Reject'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:27:&SESSION.::&DEBUG.:27:P27_ID,P27_ACTION:&P15_ID.,Reject'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select * ',
'from cwip_payment_rec_approval_history',
'where person_id = :PERSON_ID',
'and status = ''Pending''',
'and PAYMENT_RECOMMENDATION_ID = :P15_PAYMENT_RECOMMENDATION_ID'))
,p_button_condition_type=>'EXISTS'
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
'select * ',
'from cwip_payment_rec_approval_history',
'where person_id = :PERSON_ID',
'and status = ''Pending''',
'and PAYMENT_RECOMMENDATION_ID = :P15_PAYMENT_RECOMMENDATION_ID'))
,p_button_condition_type=>'EXISTS'
,p_icon_css_classes=>'fa-sign-language'
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
'select * ',
'from cwip_payment_rec_approval_history',
'where person_id = :PERSON_ID',
'and status = ''Pending''',
'and PAYMENT_RECOMMENDATION_ID = :P15_PAYMENT_RECOMMENDATION_ID'))
,p_button_condition_type=>'EXISTS'
,p_icon_css_classes=>'fa-info'
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
 p_id=>wwv_flow_api.id(12052558395523676)
,p_name=>'P15_PAYMENT_RECOMMENDATION_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(23523242051013989)
,p_item_source_plug_id=>wwv_flow_api.id(23523242051013989)
,p_source=>'PAYMENT_RECOMMENDATION_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12052988373523678)
,p_name=>'P15_CONTRACT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(23523242051013989)
,p_item_source_plug_id=>wwv_flow_api.id(23523242051013989)
,p_prompt=>'Contract Number :'
,p_source=>'CONTRACT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>12
,p_read_only_when=>'P15_PAYMENT_RECOMMENDATION_ID'
,p_read_only_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12053340576523678)
,p_name=>'P15_REFERENCE_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(23523242051013989)
,p_item_source_plug_id=>wwv_flow_api.id(23523242051013989)
,p_prompt=>'Reference Number :'
,p_source=>'REFERENCE_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_cMaxlength=>50
,p_field_template=>wwv_flow_api.id(10306252784597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12053779536523679)
,p_name=>'P15_PAYMENT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(23523242051013989)
,p_item_source_plug_id=>wwv_flow_api.id(23523242051013989)
,p_prompt=>'Payment Number :'
,p_source=>'PAYMENT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_cMaxlength=>50
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12054167264523679)
,p_name=>'P15_PAYMENT_RECOMMENDATION_DATE'
,p_source_data_type=>'DATE'
,p_is_required=>true
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(23523242051013989)
,p_item_source_plug_id=>wwv_flow_api.id(23523242051013989)
,p_item_default=>'select sysdate from dual'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Date Prepared :'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'PAYMENT_RECOMMENDATION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10306252784597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12054587848523679)
,p_name=>'P15_PAYMENT_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(23523242051013989)
,p_item_source_plug_id=>wwv_flow_api.id(23523242051013989)
,p_prompt=>'Payment Type :'
,p_source=>'PAYMENT_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'PAYMENT TYPES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id',
'from cwip_lookup_values',
'where lookup_id = 2',
'and status = ''A'''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(10306252784597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12054919956523680)
,p_name=>'P15_APPROVAL_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(23523242051013989)
,p_item_source_plug_id=>wwv_flow_api.id(23523242051013989)
,p_item_default=>'Draft'
,p_prompt=>'Approval Status :'
,p_source=>'APPROVAL_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12055724447523681)
,p_name=>'P15_EVALUATION_METHOD'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(23523242051013989)
,p_item_source_plug_id=>wwv_flow_api.id(23523242051013989)
,p_prompt=>'Evaluation Method :'
,p_source=>'EVALUATION_METHOD'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'EVALUATION METHODS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id',
'from cwip_lookup_values',
'where lookup_id = 6',
'and status = ''A'''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12056176557523681)
,p_name=>'P15_CURRENT_VALUATION_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(23523242051013989)
,p_item_source_plug_id=>wwv_flow_api.id(23523242051013989)
,p_prompt=>'Current Valuation Amount :'
,p_post_element_text=>'&nbsp; &P15_CURRENCY.'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'CURRENT_VALUATION_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_tag_attributes=>'style="color: green;font-size: 12pt;font-style: bold;"'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12056525391523681)
,p_name=>'P15_PERIOD'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
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
 p_id=>wwv_flow_api.id(12056930766523682)
,p_name=>'P15_DEDUCTIONS'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(23523242051013989)
,p_item_source_plug_id=>wwv_flow_api.id(23523242051013989)
,p_prompt=>'Deductions :'
,p_post_element_text=>'&nbsp; &P15_CURRENCY.'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'DEDUCTIONS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_tag_attributes=>'onchange="this.value=Number(this.value).toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, ''$1,'')" style="color: red;font-size: 12pt;font-style: bold;"'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12057769512523682)
,p_name=>'P15_NET_AMOUNT_PAYABLE'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(23523242051013989)
,p_item_source_plug_id=>wwv_flow_api.id(23523242051013989)
,p_prompt=>'Net Amount Payable :'
,p_post_element_text=>'&nbsp; &P15_CURRENCY.'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'NET_AMOUNT_PAYABLE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_tag_attributes=>'style="color: green;font-size: 12pt;font-style: bold;"'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12058139760523683)
,p_name=>'P15_ATTACHEMENTS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(23523242051013989)
,p_item_source_plug_id=>wwv_flow_api.id(23523242051013989)
,p_prompt=>'Attachements :'
,p_source=>'ATTACHEMENTS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12058556302523683)
,p_name=>'P15_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(21961717762318805)
,p_item_source_plug_id=>wwv_flow_api.id(23523242051013989)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Created By :</span>'
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P15_PAYMENT_RECOMMENDATION_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12058980292523683)
,p_name=>'P15_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(21961717762318805)
,p_item_source_plug_id=>wwv_flow_api.id(23523242051013989)
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
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12059359969523684)
,p_name=>'P15_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(21961717762318805)
,p_item_source_plug_id=>wwv_flow_api.id(23523242051013989)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Updated By :</span>'
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P15_PAYMENT_RECOMMENDATION_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12059742919523684)
,p_name=>'P15_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(21961717762318805)
,p_item_source_plug_id=>wwv_flow_api.id(23523242051013989)
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
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21864072728304242)
,p_name=>'P15_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(23523242051013989)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21864674871304248)
,p_name=>'P15_CONTRACT_STAGE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(23523242051013989)
,p_item_source_plug_id=>wwv_flow_api.id(23523242051013989)
,p_prompt=>'Contract Stage :'
,p_source=>'CONTRACT_STAGE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_cMaxlength=>50
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21864759652304249)
,p_name=>'P15_CURRENCY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(23523242051013989)
,p_item_source_plug_id=>wwv_flow_api.id(23523242051013989)
,p_prompt=>'Currency :'
,p_source=>'CURRENCY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>10
,p_cMaxlength=>20
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21961420350318802)
,p_name=>'P15_INVOICE_NUM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(21864847064304250)
,p_item_source_plug_id=>wwv_flow_api.id(23523242051013989)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Invoice Num :</span>'
,p_source=>'INVOICE_NUM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>128
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21961548874318803)
,p_name=>'P15_INVOICE_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(21864847064304250)
,p_item_source_plug_id=>wwv_flow_api.id(23523242051013989)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Invoice Date :</span>'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'INVOICE_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21961693004318804)
,p_name=>'P15_TOTAL_INVOICE_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(21864847064304250)
,p_item_source_plug_id=>wwv_flow_api.id(23523242051013989)
,p_prompt=>'nvoice Amount (Including VAT):'
,p_post_element_text=>'&nbsp; &P15_CURRENCY.'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'TOTAL_INVOICE_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_tag_attributes=>'style="color: green;font-size: 12pt;font-style: bold;"'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
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
 p_id=>wwv_flow_api.id(29919237207177121)
,p_name=>'P15_VALUATION_PERIOD_FROM'
,p_source_data_type=>'DATE'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(23523242051013989)
,p_item_source_plug_id=>wwv_flow_api.id(23523242051013989)
,p_prompt=>'Valuation Period From'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'VALUATION_PERIOD_FROM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29919340493177122)
,p_name=>'P15_VALUATION_PERIOD_TO'
,p_source_data_type=>'DATE'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(23523242051013989)
,p_item_source_plug_id=>wwv_flow_api.id(23523242051013989)
,p_prompt=>'Valuation Period To'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'VALUATION_PERIOD_TO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29919456137177123)
,p_name=>'P15_SCOPE_OF_WORK'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(21864847064304250)
,p_prompt=>'Scope Of Work'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29919589970177124)
,p_name=>'P15_REMARK'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(21864847064304250)
,p_prompt=>'Remark'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
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
 p_id=>wwv_flow_api.id(29919702728177126)
,p_name=>'P15_PREVIOUS_PAYMENT_APPROVED'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(23522576698013971)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'l_count     number;',
'BEGIN',
'SELECT count(*)',
'into l_count',
'FROM cwip_payment_recommendation C',
'WHERE c.contract_number = :P15_CONTRACT_NUMBER',
'        AND c.seq_count < :p15_seq_count ',
'        AND c.approval_status not in (''Approved'' , ''Rejected'');',
'',
'if l_count > 0 then return ''Y'';',
'else return ''N'';',
'end if;',
'END;'))
,p_source_type=>'FUNCTION_BODY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
,p_item_comment=>'used to get the Pending previous payments applications '
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
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29920065657177129)
,p_name=>'P15_LIST'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(23522576698013971)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT c.reference_number',
'FROM cwip_payment_recommendation C',
'WHERE c.contract_number = :P15_CONTRACT_NUMBER',
'AND c.seq_count < :P15_SEQ_COUNT ',
'AND c.approval_status not in (''Approved'' , ''Rejected'')',
'order BY c.seq_count'))
,p_source_type=>'QUERY_COLON'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(32569824964581212)
,p_name=>'P15_PREVIOUSELY_CERIFIED_APPROVED'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(23523242051013989)
,p_prompt=>'Previousely Cerified Approved'
,p_post_element_text=>'&nbsp; &P15_CURRENCY.'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(Previousely_Cerified_Approved , ''99,999,999.99''))',
'from ',
'(SELECT',
'    payment_recommendation_id,',
'    (',
'    select nvl(sum(a.net_amount_payable),0)',
'    from cwip_payment_recommendation a',
'    where a.contract_number = c.contract_number',
'    and a.approval_status = ''Approved''',
'    and a.seq_count < c.seq_count',
'    ) Previousely_Cerified_Approved ',
'FROM',
'    cwip_payment_recommendation c',
'where contract_number = :P15_CONTRACT_NUMBER ',
'order by contract_number , seq_count)',
'where payment_recommendation_id = :P15_PAYMENT_RECOMMENDATION_ID ;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_tag_attributes=>'style="color: green;font-size: 12pt;font-style: bold;"'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(32569945359581213)
,p_name=>'P15_PPREVIOUSELY_CERIFIED_PENDING'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(23523242051013989)
,p_prompt=>'Previously Certified Pending'
,p_post_element_text=>'&nbsp; &P15_CURRENCY.'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(Previousely_Cerified_Pending,''99,999,999.99''))',
'from ',
'(SELECT',
'    payment_recommendation_id,',
'    (',
'    select nvl(sum(a.net_amount_payable),0)',
'    from cwip_payment_recommendation a',
'    where a.contract_number = c.contract_number',
'    and a.approval_status = ''In-Progress''',
'    and a.seq_count < c.seq_count',
'    ) Previousely_Cerified_Pending',
'FROM',
'    cwip_payment_recommendation c',
'where contract_number = :P15_CONTRACT_NUMBER ',
'order by contract_number , seq_count)',
'where payment_recommendation_id = :P15_PAYMENT_RECOMMENDATION_ID ;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_tag_attributes=>'style="color: green;font-size: 12pt;font-style: bold;"'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(32570068957581214)
,p_name=>'P15_CUMULATIVE_CERIFIED_AMOUNT'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(23523242051013989)
,p_prompt=>'Cumulative Certified Amount'
,p_post_element_text=>'&nbsp; &P15_CURRENCY.'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  trim(to_char(to_number(replace(nvl(:P15_PREVIOUSELY_CERIFIED_APPROVED,0),'','','''') )',
'+ to_number(replace(nvl(:P15_PREVIOUSELY_CERIFIED_PENDING,0),'','','''') )',
'+ to_number(replace(nvl(:P15_NET_AMOUNT_PAYABLE,0),'','','''') ),''99,999,999.99''))  as amount',
'from dual'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_tag_attributes=>'style="color: green;font-size: 12pt;font-style: bold;"'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
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
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(12089226638523732)
,p_validation_name=>'P15_CREATED_ON must be timestamp'
,p_validation_sequence=>150
,p_validation=>'P15_CREATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(12058980292523683)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(12089684743523732)
,p_validation_name=>'P15_UPDATED_ON must be timestamp'
,p_validation_sequence=>170
,p_validation=>'P15_UPDATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(12059742919523684)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
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
wwv_flow_api.component_end;
end;
/
