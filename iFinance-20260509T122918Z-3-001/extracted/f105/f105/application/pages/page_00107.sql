prompt --application/pages/page_00107
begin
--   Manifest
--     PAGE: 00107
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
 p_id=>107
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Project Expenditures Details'
,p_alias=>'PROJECT-EXPENDITURES-DETAILS'
,p_page_mode=>'MODAL'
,p_step_title=>'Project Expenditures Details'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch:t-Dialog--noPadding'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230518113349'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(46101501774589221)
,p_plug_name=>'Project Expenditures Details &P107_ACCOUNTING_YEAR.'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(46101058081589220)
,p_plug_name=>'Project Expenditures Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(46211974563316321)
,p_plug_name=>'Project Expenditures Details Report'
,p_parent_plug_id=>wwv_flow_api.id(46101058081589220)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PROJECT_NUMBER,',
'       TASK_NUMBER,',
'       EXPENDITURE_TYPE,',
'       TASK_NAME,',
'       ACCOUNTING_YEAR,',
'       DOCUMENT_NUM,',
'       DOCUMENT_TYPE,',
'       CREATION_DATE,',
'       GL_DATE,',
'       VENDOR_NAME,',
'       COMMENTS,',
'       PO_NUM,',
'       DESCRIPTION,',
'       DOCUMENT_AMOUNT,',
'       ACTUAL_AMOUNT,',
'       GL_ACCOUNT',
'  from PROJECT_EXPENDITURES_DETAILS',
'  where accounting_year = :P107_ACCOUNTING_YEAR',
'  and project_number = :P107_PROJECT_NUMBER',
'  and task_number = :P107_TASK_NUMBER'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P107_ACCOUNTING_YEAR,P107_PROJECT_NUMBER,P107_TASK_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Project Expenditures Details Report'
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
 p_id=>wwv_flow_api.id(46211861049316320)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>167072171339868312
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46211822078316319)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46211718509316318)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46211606512316317)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46211529091316316)
,p_db_column_name=>'TASK_NAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Task Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46211409084316315)
,p_db_column_name=>'ACCOUNTING_YEAR'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Accounting Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46211245720316314)
,p_db_column_name=>'DOCUMENT_NUM'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Document Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46211187553316313)
,p_db_column_name=>'DOCUMENT_TYPE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Document Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46211081870316312)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46210962038316311)
,p_db_column_name=>'GL_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'GL Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46210888018316310)
,p_db_column_name=>'VENDOR_NAME'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Vendor Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46210789026316309)
,p_db_column_name=>'COMMENTS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46210651770316308)
,p_db_column_name=>'PO_NUM'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'PO Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46210544985316307)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46210466412316306)
,p_db_column_name=>'DOCUMENT_AMOUNT'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Document Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46210337529316305)
,p_db_column_name=>'ACTUAL_AMOUNT'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Actual Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46210304807316304)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'GL Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(46094389710561828)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1671897'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:DOCUMENT_NUM:DOCUMENT_TYPE:GL_DATE:VENDOR_NAME:COMMENTS:PO_NUM:DESCRIPTION:DOCUMENT_AMOUNT:ACTUAL_AMOUNT:'
,p_sum_columns_on_break=>'ACTUAL_AMOUNT'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(46210148564316303)
,p_name=>'P107_ACCOUNTING_YEAR'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(46101501774589221)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(46210034811316302)
,p_name=>'P107_PROJECT_NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(46101501774589221)
,p_prompt=>'Project Number'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(46209975466316301)
,p_name=>'P107_TASK_NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(46101501774589221)
,p_prompt=>'Task Number'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(46208803860316289)
,p_name=>'P107_PROJECT_NAME'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(46101501774589221)
,p_prompt=>'Project Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.component_end;
end;
/
