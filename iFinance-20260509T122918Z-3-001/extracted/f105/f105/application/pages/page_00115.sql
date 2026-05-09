prompt --application/pages/page_00115
begin
--   Manifest
--     PAGE: 00115
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
 p_id=>115
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'View document'
,p_alias=>'VIEW-DOCUMENT'
,p_page_mode=>'MODAL'
,p_step_title=>'View document'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230610102455'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(38677129177513030)
,p_plug_name=>'hidden'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(38676650793513009)
,p_plug_name=>'Documents'
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent13:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(40678940905038586)
,p_plug_name=>'Documents Report'
,p_parent_plug_id=>wwv_flow_api.id(38676650793513009)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ROW_VERSION_NUMBER,',
'       PLAN_ID,',
'       SECTOR_ID,',
'       COST_CENTER,',
'       project_number,',
'       task_number,',
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
'  from budget_proposal_plans_documents',
'  where PLAN_ID = :P115_PLAN_ID',
'  and COST_CENTER = :P115_COST_CENTER',
'  and project_number =  nvl(:P115_PROJECT_NUMBER,project_number)',
'  and task_number = nvl(:P115_TASK_NUMBER,task_number)',
'  order by UPDATED desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P115_PLAN_ID,P115_COST_CENTER,P115_PROJECT_NUMBER,P115_TASK_NUMBER'
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
 p_id=>wwv_flow_api.id(40678904979038585)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No documents attached for &P115_PROJECT_NUMBER. - Task: &P115_TASK_NUMBER.'
,p_allow_save_rpt_public=>'Y'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>172605127410146047
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38675721734494030)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38675446296494028)
,p_db_column_name=>'PLAN_ID'
,p_display_order=>20
,p_column_identifier=>'C'
,p_column_label=>'Plan Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38675590820494029)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>30
,p_column_identifier=>'B'
,p_column_label=>'Document Version'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38675377057494027)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Sector Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38675233164494026)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38675218350494025)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38675082758494024)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38674958406494023)
,p_db_column_name=>'FILENAME'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Document Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38674900402494022)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38674819499494021)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38674680170494020)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38674598366494019)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38674463807494018)
,p_db_column_name=>'TAGS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38674418541494017)
,p_db_column_name=>'CREATED'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38674281570494016)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38674170962494015)
,p_db_column_name=>'UPDATED'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38674068648494014)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38674021805494013)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38673876134494012)
,p_db_column_name=>'DOWNLOAD'
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
,p_format_mask=>'DOWNLOAD:BUDGET_PROPOSAL_PLANS_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(38663320612449210)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1746208'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'COST_CENTER:PROJECT_NUMBER:TASK_NUMBER:FILENAME:ROW_VERSION_NUMBER:FILE_COMMENTS:CREATED:CREATED_BY:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(38673799924494011)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(38676650793513009)
,p_button_name=>'Add'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Add document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:102:&SESSION.::&DEBUG.:102:P102_PLAN_ID,P102_SECTOR_ID,P102_COST_CENTER,P102_PROJECT_NUMBER,P102_TASK_NUMBER:&P115_PLAN_ID.,&P115_SECTOR_ID.,&P115_COST_CENTER.,&P115_PROJECT_NUMBER.,&P115_TASK_NUMBER.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(40678806503038584)
,p_name=>'P115_PLAN_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(38677129177513030)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(40678659683038583)
,p_name=>'P115_COST_CENTER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(38677129177513030)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(40678558761038582)
,p_name=>'P115_PROJECT_NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(38677129177513030)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38675801703494031)
,p_name=>'P115_TASK_NUMBER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(38677129177513030)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38673663064494010)
,p_name=>'P115_SECTOR_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(38677129177513030)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.component_end;
end;
/
