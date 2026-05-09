prompt --application/pages/page_00070
begin
--   Manifest
--     PAGE: 00070
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
 p_id=>70
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'DP Item Details'
,p_alias=>'DP-ITEM-DETAILS'
,p_step_title=>'DP Item Details'
,p_autocomplete_on_off=>'OFF'
,p_css_file_urls=>'#WORKSPACE_IMAGES#main.css'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.t-Form-label {',
'    	color: #368ed2;',
'	font-weight: bold;',
'	font-size:12px;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230209165902'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208513168576561793)
,p_plug_name=>'Main Details'
,p_icon_css_classes=>'fa-list-ul'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--noBorder:t-Region--scrollBody:margin-right-none'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208513941957561792)
,p_plug_name=>'Audit Info'
,p_parent_plug_id=>wwv_flow_api.id(208513168576561793)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208791088504587071)
,p_plug_name=>'Header Details'
,p_parent_plug_id=>wwv_flow_api.id(208513168576561793)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_grid_column_span=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(79783111682804038)
,p_plug_name=>'Participants'
,p_parent_plug_id=>wwv_flow_api.id(208791088504587071)
,p_icon_css_classes=>'fa-universal-access'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(79783249758804039)
,p_plug_name=>'Participants Report'
,p_parent_plug_id=>wwv_flow_api.id(79783111682804038)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'DP_ITEM_PARTICIPANTS'
,p_query_where=>'item_id = :P11_ITEM_ID'
,p_query_order_by=>'ID'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P70_ITEM_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Participants Report'
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
 p_id=>wwv_flow_api.id(79783269341804040)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:59:&SESSION.::&DEBUG.::P59_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>293067301730988672
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64283091810166164)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64282710421166164)
,p_db_column_name=>'ITEM_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64282238433166164)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Name'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64281872344166160)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Role'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(64248654316166126)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64281508788166160)
,p_db_column_name=>'STATUS'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(780300318120911)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64281068962166159)
,p_db_column_name=>'START_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64280638242166159)
,p_db_column_name=>'END_DATE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64280323462166159)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64279919343166159)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64279448032166159)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64279066188166159)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64278704131166158)
,p_db_column_name=>'NOTES'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(80557595333144417)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1490057'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PERSON_ID:ROLE_ID:STATUS:START_DATE:END_DATE:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(64277920156166158)
,p_report_id=>wwv_flow_api.id(80557595333144417)
,p_name=>'Owner'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Active'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Active''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#D0F1CC'
,p_row_font_color=>'#000000'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208907248046897405)
,p_plug_name=>'Review & Verification Partners'
,p_parent_plug_id=>wwv_flow_api.id(208791088504587071)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:is-expanded:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(208790584762587066)
,p_name=>'Roles'
,p_parent_plug_id=>wwv_flow_api.id(208907248046897405)
,p_template=>wwv_flow_api.id(99757408152410744)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight:t-Report--horizontalBorders'
,p_grid_column_span=>8
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select role_id  , person_id',
'from DP_ITEM_ROLES',
'where item_id = :P70_ITEM_ID;'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P70_ITEM_ID'
,p_query_row_template=>wwv_flow_api.id(99783722631410762)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(64284885001166166)
,p_query_column_id=>1
,p_column_alias=>'ROLE_ID'
,p_column_display_sequence=>1
,p_column_heading=>'Role'
,p_use_as_row_header=>'N'
,p_column_alignment=>'RIGHT'
,p_display_as=>'TEXT_FROM_LOV_ESC'
,p_named_lov=>wwv_flow_api.id(64240590228166117)
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(64284477250166165)
,p_query_column_id=>2
,p_column_alias=>'PERSON_ID'
,p_column_display_sequence=>2
,p_column_heading=>'Employee'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_display_as=>'TEXT_FROM_LOV_ESC'
,p_named_lov=>wwv_flow_api.id(48836004784526)
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(209176276763974056)
,p_plug_name=>'Budget Details'
,p_parent_plug_id=>wwv_flow_api.id(208791088504587071)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:is-expanded:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_read_only_when_type=>'PLSQL_EXPRESSION'
,p_plug_read_only_when=>':P70_ITEM_ID is not null and :P70_REVIEW_STATUS not in (''Draft'',''Withdraw'' , ''Return'')'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208791254869587073)
,p_plug_name=>'Summary'
,p_parent_plug_id=>wwv_flow_api.id(208513168576561793)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_new_grid_row=>false
,p_plug_display_column=>11
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208791362336587074)
,p_plug_name=>'Status'
,p_parent_plug_id=>wwv_flow_api.id(208791254869587073)
,p_icon_css_classes=>'fa-suitcase'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody:t-Form--slimPadding:t-Form--large:t-Form--leftLabels:margin-left-none:margin-right-none'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208514398235561792)
,p_plug_name=>'Documents'
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208620685893127259)
,p_plug_name=>'Documents report'
,p_parent_plug_id=>wwv_flow_api.id(208514398235561792)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where dp_items_id = :P70_ITEM_ID',
'    order by UPDATED desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P70_ITEM_ID'
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
 p_id=>wwv_flow_api.id(208620828052127260)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>421904860441311892
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64330411708166203)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64329964891166203)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64329560044166202)
,p_db_column_name=>'DP_ITEMS_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Dp Items Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64329192549166202)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'File Name'
,p_column_link=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.::P14_PAGE_FROM,P14_REVIEW_STATUS,P14_ID:11,&P11_REVIEW_STATUS.,#ID#'
,p_column_linktext=>'#FILENAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64328737080166202)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64328416494166201)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64328019890166201)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64327559555166201)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64327188339166201)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64326826615166201)
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
 p_id=>wwv_flow_api.id(64326352716166200)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64325997841166200)
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
 p_id=>wwv_flow_api.id(64325535758166200)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64325179028166200)
,p_db_column_name=>'COMMENT_ID'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Comment Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64324800378166200)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64324383423166199)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:DP_ITEMS_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(208646340755842427)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1489600'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:TAGS:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208514738280561792)
,p_plug_name=>'Review /Approval History'
,p_icon_css_classes=>'fa-users'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent13:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>40
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_plug_display_when_condition=>'P70_REVIEW_STATUS'
,p_plug_display_when_cond2=>'Draft'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208622786453127280)
,p_plug_name=>'Review History Report'
,p_parent_plug_id=>wwv_flow_api.id(208514738280561792)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'       ',
'    e.full_name_en || ''('' || e.user_name || '')'' as full_name_en,',
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
'and h.request_id = :P70_ITEM_ID',
'and h.status != ''Beaten''',
'order by h.STEP_NO ',
'--, h.ID',
';'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P70_ITEM_ID'
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
 p_id=>wwv_flow_api.id(208622900928127281)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>421906933317311913
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64323028374166196)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64322553308166196)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64322177564166196)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64321793705166195)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64321414086166195)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Role'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(64238386933166115)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64321029589166195)
,p_db_column_name=>'ROLE_DESC'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Role Desc'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64320581916166195)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64320203424166195)
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
 p_id=>wwv_flow_api.id(64319777972166194)
,p_db_column_name=>'STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64319402988166194)
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
 p_id=>wwv_flow_api.id(64318937406166194)
,p_db_column_name=>'COMMENTS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64318581931166194)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64318178384166194)
,p_db_column_name=>'STATUS_CLASS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Status Class'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64317819246166193)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64317418559166193)
,p_db_column_name=>'PHOTO'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(208889860820814650)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1489670'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:PHOTO:FULL_NAME_EN:ROLE_ID:ACTION_REQUIRED:RECEVIED_DATE:STATUS:ACTION_DATE:COMMENTS:'
,p_sort_column_1=>'STEP_NO'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(64316597521166192)
,p_report_id=>wwv_flow_api.id(208889860820814650)
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
 p_id=>wwv_flow_api.id(208902892850897361)
,p_plug_name=>'Collaboration'
,p_icon_css_classes=>'fa-comments-o fa-anim-flash fam-sleep fam-is-success'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody:margin-left-none'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(208903061084897363)
,p_name=>'Comments Report'
,p_parent_plug_id=>wwv_flow_api.id(208902892850897361)
,p_template=>wwv_flow_api.id(99730028608410735)
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
'where ITEM_ID = :P70_ITEM_ID',
'order by CREATION_DATE desc;'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P70_ITEM_ID'
,p_query_row_template=>wwv_flow_api.id(99786373050410764)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No Communications yet.'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(64315216598166190)
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
 p_id=>wwv_flow_api.id(64314792202166186)
,p_query_column_id=>2
,p_column_alias=>'COMMENT_DATE'
,p_column_display_sequence=>2
,p_column_heading=>'Comment Date'
,p_use_as_row_header=>'N'
,p_column_format=>'SINCE'
,p_column_html_expression=>'<br>#COMMENT_DATE#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(64314383055166185)
,p_query_column_id=>3
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>3
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<span style="color:red">From: #USER_NAME# </span>'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(64309975378166183)
,p_query_column_id=>4
,p_column_alias=>'COMMENT_TEXT'
,p_column_display_sequence=>4
,p_column_heading=>'Comment Text'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:17:&SESSION.::&DEBUG.::P17_COMMENT_ID:#COMMENT_ID#'
,p_column_linktext=>'#COMMENT_TEXT#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(64313955020166185)
,p_query_column_id=>5
,p_column_alias=>'COMMENT_MODIFIERS'
,p_column_display_sequence=>5
,p_column_heading=>'Comment Modifiers'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(64313616423166185)
,p_query_column_id=>6
,p_column_alias=>'ICON_MODIFIER'
,p_column_display_sequence=>6
,p_column_heading=>'Icon Modifier'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(64313155976166185)
,p_query_column_id=>7
,p_column_alias=>'ACTIONS'
,p_column_display_sequence=>7
,p_column_heading=>'Actions'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(64312801416166185)
,p_query_column_id=>8
,p_column_alias=>'ATTRIBUTE_1'
,p_column_display_sequence=>8
,p_column_heading=>'Attribute 1'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(64312347706166184)
,p_query_column_id=>9
,p_column_alias=>'ATTRIBUTE_2'
,p_column_display_sequence=>9
,p_column_heading=>'Attribute 2'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(64312028090166184)
,p_query_column_id=>10
,p_column_alias=>'ATTRIBUTE_3'
,p_column_display_sequence=>10
,p_column_heading=>'Attribute 3'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(64311607761166184)
,p_query_column_id=>11
,p_column_alias=>'ATTRIBUTE_4'
,p_column_display_sequence=>11
,p_column_heading=>'Attribute 4'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(64311225611166184)
,p_query_column_id=>12
,p_column_alias=>'COMMENT_ID'
,p_column_display_sequence=>12
,p_column_heading=>'Comment Id'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(64310740196166184)
,p_query_column_id=>13
,p_column_alias=>'FILENAME'
,p_column_display_sequence=>13
,p_column_heading=>'Filename'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(64310409211166183)
,p_query_column_id=>14
,p_column_alias=>'COMMENT_TO'
,p_column_display_sequence=>14
,p_column_heading=>'Comment To'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64331058000166207)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(208514398235561792)
,p_button_name=>'New_document'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'New Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64315861435166192)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(208902892850897361)
,p_button_name=>'AddComment'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Collaborate'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:17:&SESSION.::&DEBUG.::P17_ITEM_ID:&P70_ITEM_ID.'
,p_icon_css_classes=>'fa-envelope-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64306853715166181)
,p_button_sequence=>10
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:&P70_PAGE_FROM.:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64283773625166165)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(79783111682804038)
,p_button_name=>'Add'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Add Participant'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:59:&SESSION.::&DEBUG.::P59_ITEM_ID:&P70_ITEM_ID.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64309283353166183)
,p_button_sequence=>20
,p_button_name=>'Generate_Scoping'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Generate Scoping'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>':P70_DP_SCOPING_ID is null and :P70_TEMPLATE_ID is not null and :P70_APPROVAL_STATUS = ''Approved'''
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-clipboard-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64308880476166182)
,p_button_sequence=>30
,p_button_name=>'Scoping_Document'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Scoping Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>':P70_DP_SCOPING_ID is not null and :P70_APPROVAL_STATUS = ''Approved'''
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-file-word-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64308484456166182)
,p_button_sequence=>40
,p_button_name=>'Rollback'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Rollback'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition_type=>'NEVER'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64308059958166182)
,p_button_sequence=>50
,p_button_name=>'UPDATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Save'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P70_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'') and',
'(:P70_END_USER_ID = :PERSON_ID or :P70_CREATED_BY = :PERSON_ID)'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-save-as'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64307683363166182)
,p_button_sequence=>60
,p_button_name=>'Submit_REVIEW'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Submit For Review'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P70_ITEM_ID is not null ',
'and :P70_REVIEW_STATUS in (''Draft'',''Withdraw'' , ''Return'') and',
'(:P70_END_USER_ID = :PERSON_ID or :P70_CREATED_BY = :PERSON_ID or :PERSON_ID = 680461)'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64307321073166181)
,p_button_sequence=>70
,p_button_name=>'Withdraw'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Withdraw'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:12:P12_ACTION,P12_REQUEST_ID:Withdraw,&P70_ITEM_ID.'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(:P70_END_USER_ID = :PERSON_ID or :P70_CREATED_BY = :PERSON_ID )',
'and (:P70_REVIEW_STATUS not in (''Cancel'', ''Withdraw'' , ''Draft'' , ''Return'' , ''Not Accepted''))'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-undo'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64306507398166181)
,p_button_sequence=>80
,p_button_name=>'Create_Version'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Create Version'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-copy'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64303420953166178)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(208513168576561793)
,p_button_name=>'Edit_Header'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--link'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Edit Header'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.::P10_ITEM_ID,P10_CHANGED:&P70_ITEM_ID.,N'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-pencil'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(64250567510166129)
,p_branch_name=>'GO TO Confirmation 13'
,p_branch_action=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.:13:P13_REVIEW_STATUS,P13_REQUEST_ID:&P11_REVIEW_STATUS.,&P11_ITEM_ID_H.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(64307683363166182)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(64249822077166128)
,p_branch_name=>'Go to Scoping document 28'
,p_branch_action=>'f?p=&APP_ID.:28:&SESSION.::&DEBUG.::P28_SCOPE_ID:&P11_DP_SCOPING_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(64308880476166182)
,p_branch_sequence=>20
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(64250166018166129)
,p_branch_name=>'Go to scoping confirmation 27'
,p_branch_action=>'f?p=&APP_ID.:27:&SESSION.::&DEBUG.::P27_ITEM_ID_H,P27_SCOPING_ID,P27_TEMPLATE,P27_TEMPLATE_ID:&P11_ITEM_ID.,&P11_DP_SCOPING_ID.,&P11_TEMPLATE.,&P11_TEMPLATE_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(64309283353166183)
,p_branch_sequence=>30
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(64249339148166128)
,p_branch_name=>'Go to 11'
,p_branch_action=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.::P11_ITEM_ID:&P11_ITEM_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(64308059958166182)
,p_branch_sequence=>40
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(64248968908166128)
,p_branch_name=>'Go to 14'
,p_branch_action=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.:14:P14_DP_ITEMS_ID,P14_PAGE_FROM,P14_REVIEW_STATUS:&P11_ITEM_ID.,11,&P11_REVIEW_STATUS.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(64331058000166207)
,p_branch_sequence=>50
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64306038992166181)
,p_name=>'P70_PAGE_FROM'
,p_item_sequence=>10
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64305650570166180)
,p_name=>'P70_ITEM_ID'
,p_item_sequence=>20
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64305282996166179)
,p_name=>'P70_ITEM_ID_H'
,p_item_sequence=>30
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64304931287166179)
,p_name=>'P70_DP_SCOPING_ID'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64304490046166179)
,p_name=>'P70_TEMPLATE'
,p_item_sequence=>50
,p_use_cache_before_default=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select TEMPLATE_NAME',
'from dp_scope_templates',
'where template_id = (select TEMPLATE_ID',
'                    from dp_item_categories',
'                    where CATEGORY_ID = (select sub_category_id',
'                                          from dp_items  ',
'                                          where item_id = :P70_ITEM_ID))'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64304090725166178)
,p_name=>'P70_TEMPLATE_ID'
,p_item_sequence=>60
,p_use_cache_before_default=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select TEMPLATE_ID',
'from dp_item_categories',
'where CATEGORY_ID = (select sub_category_id',
'                      from dp_items  ',
'                      where item_id = :P70_ITEM_ID)'))
,p_source_type=>'QUERY_COLON'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64302363215166177)
,p_name=>'P70_PLANNING_STATUS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(208791362336587074)
,p_prompt=>'Planning Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'DP ITEM PLANNING STATUS'
,p_lov=>'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 48 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10);'
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64301997590166176)
,p_name=>'P70_REVIEW_STATUS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(208791362336587074)
,p_prompt=>'Review Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64301599784166176)
,p_name=>'P70_REVIEW_REJECT_REASON'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(208791362336587074)
,p_prompt=>'Review Comment'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P70_REVIEW_STATUS'
,p_display_when2=>'Not Accepted'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64301227844166176)
,p_name=>'P70_APPROVAL_STATUS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(208791362336587074)
,p_prompt=>'Approval Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64300789769166176)
,p_name=>'P70_CUTT_OFF_DATE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(208791362336587074)
,p_prompt=>'Cut Off Date'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64300129824166175)
,p_name=>'P70_CREATED_BY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(208513941957561792)
,p_prompt=>'Created By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64299680920166175)
,p_name=>'P70_CREATED_ON'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(208513941957561792)
,p_prompt=>'Created On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64299270106166175)
,p_name=>'P70_UPDATED_BY'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(208513941957561792)
,p_prompt=>'Updated By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64298861433166174)
,p_name=>'P70_UPDATED_ON'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(208513941957561792)
,p_prompt=>'Updated On'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64298156134166174)
,p_name=>'P70_DP_ITEM_CODE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(208791088504587071)
,p_prompt=>'DP Item Code'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64297760119166174)
,p_name=>'P70_DP_ITEM_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(208791088504587071)
,p_prompt=>'Demand Plan Item Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64297353480166173)
,p_name=>'P70_INITIATIVE_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(208791088504587071)
,p_prompt=>'Initiative'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'INITIATIVES POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select INITIATIVE_ID, INITIATIVE_CODE, INITIATIVE_NAME, ',
'    decode(INITIATIVE_TYPE, ''S'' , ''Strategic'' , ''N'', ''Non-Strategic'') INITIATIVE_TYPE',
'from strategic_initiatives;'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64296934664166173)
,p_name=>'P70_INITIATIVE_NEW_NAME'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(208791088504587071)
,p_prompt=>'New  Initiative Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64296625623166173)
,p_name=>'P70_INITIATIVE_NEW_YN'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(208791088504587071)
,p_prompt=>'New Initiative ?'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(782922329120916)||'.'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64296202088166173)
,p_name=>'P70_PROJECT_NUMBER'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(208791088504587071)
,p_prompt=>'Project'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'OPERATIONAL PROJECTS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PROJECT_NUMBER || '' - '' || PROJECT_NAME  PROJECT_NAME , project_number ',
'from project',
'where PROJECT_TYPE = ''Operational'''))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64295798629166173)
,p_name=>'P70_PROJECT_NEW_YN'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(208791088504587071)
,p_prompt=>'New Project ?'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(782922329120916)||'.'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64295388195166173)
,p_name=>'P70_PROJECT_NEW_NAME'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(208791088504587071)
,p_prompt=>'New Project Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64294968013166172)
,p_name=>'P70_MAIN_CATEGORY_ID'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(208791088504587071)
,p_prompt=>'Main Category'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ITEM MAIN CATEGORIES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CATEGORY_NAME , CATEGORY_ID',
'from dp_item_categories',
'where ORDER_LEVEL = 231 ;'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64294563858166172)
,p_name=>'P70_CONTRACT_NO'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(208791088504587071)
,p_prompt=>'Contract No'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>'P70_CONTRACT_NO'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64294187520166172)
,p_name=>'P70_CATEGORY_ID'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(208791088504587071)
,p_prompt=>'Category'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ITEM CATEGORY  LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CATEGORY_NAME , CATEGORY_ID',
'from dp_item_categories',
'where ORDER_LEVEL = 232 ;'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64293736950166172)
,p_name=>'P70_DP_ITEM_TYPE_ID'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(208791088504587071)
,p_prompt=>'DP Item Type'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'DP ITEM TYPES LOV'
,p_lov=>'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 45 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10)'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64293394505166172)
,p_name=>'P70_SUB_CATEGORY_ID'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(208791088504587071)
,p_prompt=>'Sub-Category'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ITEM SUB CATEGORIES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CATEGORY_NAME , CATEGORY_ID',
'from dp_item_categories',
'where ORDER_LEVEL = 233 ;'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64292969465166171)
,p_name=>'P70_RISK_ID'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(208791088504587071)
,p_prompt=>'Risk'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'DP RISK LEVEL LOV'
,p_lov=>'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 46 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10);'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64292542822166171)
,p_name=>'P70_COST_CENTER'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(208791088504587071)
,p_prompt=>'Cost Center'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64292188576166171)
,p_name=>'P70_PRIORITY_ID'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(208791088504587071)
,p_prompt=>'Priority'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'PRIORITY LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id',
'from dct_lookup_values',
'where lookup_id = (Select x.lookup_id',
'                    from dct_lookups x',
'                    where x.LOOKUP_CODE = ''PRIORITY'');'))
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64291831974166171)
,p_name=>'P70_END_USER_ID'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(208791088504587071)
,p_prompt=>'End User'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64291396730166171)
,p_name=>'P70_DP_PROCUREMENT_METHOD'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(208791088504587071)
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
,p_begin_on_new_line=>'N'
,p_display_when=>'P70_DP_PROCUREMENT_METHOD'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64291028372166171)
,p_name=>'P70_SECTOR_ID'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(208791088504587071)
,p_prompt=>'Sector'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'SECTORS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  NVL(SECTOR_NAME_USER , SECTOR_NAME) Name , SECTOR_ID',
'from dct_hr_sectors_v'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64290544265166170)
,p_name=>'P70_DEPARTMENT_ID'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(208791088504587071)
,p_prompt=>'Department'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ORGANIZATION NAME RETURN ORG_ID'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64290216329166170)
,p_name=>'P70_PROJECT_DESCRIPTION'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(208791088504587071)
,p_prompt=>'Project Description'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64289774522166170)
,p_name=>'P70_NOTES'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(208791088504587071)
,p_prompt=>'Notes'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>2
,p_read_only_when=>':P70_ITEM_ID is not null and :P70_REVIEW_STATUS not in (''Draft'',''Withdraw'' , ''Return'')'
,p_read_only_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64289071578166168)
,p_name=>'P70_ESTIMATED_DATE_DEFINE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(209176276763974056)
,p_item_default=>'N'
,p_prompt=>'Estimated Date Define ?'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64288636529166168)
,p_name=>'P70_ESTIMATED_DATE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(209176276763974056)
,p_prompt=>'Project Delivery Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64288326420166168)
,p_name=>'P70_ESTIMATED'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(209176276763974056)
,p_prompt=>'Estimated Quarter-Year'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64287878589166168)
,p_name=>'P70_ESTIMATED_MONTH'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(209176276763974056)
,p_prompt=>'Estimated Month'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64287470253166167)
,p_name=>'P70_ESTIMATED_QUARTER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(209176276763974056)
,p_prompt=>'Estimated Quarter'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:1;1,2;2,3;3,4;4'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64287045539166167)
,p_name=>'P70_ESTIMATED_YEAR'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(209176276763974056)
,p_prompt=>'Estimated Year'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:2022;2022,2023;2023,2024;2024,2025;2025,2026;2026,2027;2027,2028;2028,2029;2029,2030;2030'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64286726678166167)
,p_name=>'P70_ESTIMATED_BUDGET_DEFINE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(209176276763974056)
,p_item_default=>'N'
,p_prompt=>'Estimated Budget Define ?'
,p_display_as=>'NATIVE_YES_NO'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64286279031166167)
,p_name=>'P70_ESTIMATED_BUDGET'
,p_is_required=>true
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(209176276763974056)
,p_prompt=>'Estimated Budget'
,p_post_element_text=>'AED'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'1'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64285892849166167)
,p_name=>'P70_ESTIMATED_BUDGET_BRACKET_ID'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(209176276763974056)
,p_prompt=>'Estimated Budget Bracket'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'ESTIMATED BUDGET BRACKET LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  BRACKET_NAME , BRACKET_ID',
'from dp_budget_brackets',
'where status = ''A''',
'order by MIN_VALUE'))
,p_begin_on_new_line=>'N'
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'1'
,p_attribute_02=>'NONE'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(64272453882166148)
,p_validation_name=>'Check Budget'
,p_validation_sequence=>10
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'if :P70_ESTIMATED_BUDGET_DEFINE = ''Y'' and ',
'    :P70_ESTIMATED_BUDGET is null',
'    ',
'    Then',
'        return false;',
'      else',
'          return true;',
' end if;',
' end;'))
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'If The estimated Budget defined, Please enter it.'
,p_when_button_pressed=>wwv_flow_api.id(64308059958166182)
,p_associated_item=>wwv_flow_api.id(64286726678166167)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(64272919469166148)
,p_validation_name=>'check required Fields'
,p_validation_sequence=>20
,p_validation=>' (:P70_ESTIMATED_DATE is not Null) or (:P70_ESTIMATED_QUARTER is not null and :P70_ESTIMATED_YEAR is not null)'
,p_validation_type=>'PLSQL_EXPRESSION'
,p_error_message=>'Please enter the estimated date'
,p_when_button_pressed=>wwv_flow_api.id(64307683363166182)
,p_associated_item=>wwv_flow_api.id(64289071578166168)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(64268779915166141)
,p_name=>'New Project DA'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P70_PROJECT_NEW_YN'
,p_condition_element=>'P70_PROJECT_NEW_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'N'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64268328320166141)
,p_event_id=>wwv_flow_api.id(64268779915166141)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P70_PROJECT_NEW_NAME'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64267809351166141)
,p_event_id=>wwv_flow_api.id(64268779915166141)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P70_PROJECT_NEW_NAME'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64267301274166141)
,p_event_id=>wwv_flow_api.id(64268779915166141)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P70_PROJECT_NUMBER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64266803087166141)
,p_event_id=>wwv_flow_api.id(64268779915166141)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P70_PROJECT_NUMBER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(64266349613166140)
,p_name=>'ESTIMATED_BUDGET DA'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P70_ESTIMATED_BUDGET'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64265888834166140)
,p_event_id=>wwv_flow_api.id(64266349613166140)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P70_ESTIMATED_BUDGET_BRACKET_ID'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64265420409166140)
,p_event_id=>wwv_flow_api.id(64266349613166140)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P70_ESTIMATED_BUDGET_BRACKET_ID'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  BRACKET_ID',
'from dp_budget_brackets',
'where :P70_ESTIMATED_BUDGET between MIN_VALUE and  MAX_VALUE'))
,p_attribute_07=>'P70_ESTIMATED_BUDGET'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(64264942148166140)
,p_name=>'Rollback DA'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(64308484456166182)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64264435155166140)
,p_event_id=>wwv_flow_api.id(64264942148166140)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure to rollback?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64264000028166139)
,p_event_id=>wwv_flow_api.id(64264942148166140)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'delete from dp_items_APPROVAL_HISTORY where REQUEST_ID = :P70_ITEM_ID;',
'',
'update dp_items ',
'set REVIEW_STATUS = ''Draft'' , ',
'    APPROVAL_STATUS =  ''Required'' ,',
'    CONTRACT_NO = '''',',
'    DP_PROCUREMENT_METHOD = ''''',
'where item_ID = :P70_ITEM_ID;'))
,p_attribute_02=>'P70_ITEM_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64263483849166139)
,p_event_id=>wwv_flow_api.id(64264942148166140)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Rollback Done;'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64262972670166139)
,p_event_id=>wwv_flow_api.id(64264942148166140)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P70_PAGE_FROM'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'11'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64262441643166139)
,p_event_id=>wwv_flow_api.id(64264942148166140)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(64262071615166139)
,p_name=>'ESTIMATED_DATE_DEFINE DA'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P70_ESTIMATED_DATE_DEFINE'
,p_condition_element=>'P70_ESTIMATED_DATE_DEFINE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'N'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64260131584166138)
,p_event_id=>wwv_flow_api.id(64262071615166139)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P70_ESTIMATED_DATE,P70_ESTIMATED'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64259550250166137)
,p_event_id=>wwv_flow_api.id(64262071615166139)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P70_ESTIMATED_DATE'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64261581244166138)
,p_event_id=>wwv_flow_api.id(64262071615166139)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P70_ESTIMATED_QUARTER,P70_ESTIMATED_YEAR'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64259112205166137)
,p_event_id=>wwv_flow_api.id(64262071615166139)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P70_ESTIMATED_DATE,P70_ESTIMATED'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64261102412166138)
,p_event_id=>wwv_flow_api.id(64262071615166139)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P70_ESTIMATED_QUARTER,P70_ESTIMATED_YEAR'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64260602882166138)
,p_event_id=>wwv_flow_api.id(64262071615166139)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P70_ESTIMATED_QUARTER,P70_ESTIMATED_YEAR'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(64258674133166132)
,p_name=>'get Quarter DA'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P70_ESTIMATED_DATE'
,p_condition_element=>'P70_ESTIMATED_DATE'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64258223211166132)
,p_event_id=>wwv_flow_api.id(64258674133166132)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P70_ESTIMATED'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Q'' || trim(to_char(to_date(:P70_ESTIMATED_DATE, ''dd-Mon-YYYY'' ) , ''Q''))',
'           || ''-'' ||',
'           trim(to_char(to_date(:P70_ESTIMATED_DATE, ''dd-Mon-YYYY'' ) , ''YYYY''))',
'           as xx',
'from dual;'))
,p_attribute_07=>'P70_ESTIMATED_DATE'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(64257738051166132)
,p_name=>'Budget Not Define DA'
,p_event_sequence=>60
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P70_ESTIMATED_BUDGET_DEFINE'
,p_condition_element=>'P70_ESTIMATED_BUDGET_DEFINE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'N'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64257266673166131)
,p_event_id=>wwv_flow_api.id(64257738051166132)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P70_ESTIMATED_BUDGET'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64256734311166131)
,p_event_id=>wwv_flow_api.id(64257738051166132)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P70_ESTIMATED_BUDGET'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64256326848166131)
,p_event_id=>wwv_flow_api.id(64257738051166132)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P70_ESTIMATED_BUDGET'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(64255894382166131)
,p_name=>'Dialog Close'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(64315861435166192)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64255421931166131)
,p_event_id=>wwv_flow_api.id(64255894382166131)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(208903061084897363)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(64254935669166131)
,p_name=>'Dialog Close 2'
,p_event_sequence=>80
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(208903061084897363)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64254492421166130)
,p_event_id=>wwv_flow_api.id(64254935669166131)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(208903061084897363)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(64254101132166130)
,p_name=>'Initiative DA'
,p_event_sequence=>90
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P70_INITIATIVE_NEW_YN'
,p_condition_element=>'P70_INITIATIVE_NEW_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'No'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64253594691166130)
,p_event_id=>wwv_flow_api.id(64254101132166130)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P70_INITIATIVE_ID'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64253128617166130)
,p_event_id=>wwv_flow_api.id(64254101132166130)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P70_INITIATIVE_NEW_NAME'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64252630440166130)
,p_event_id=>wwv_flow_api.id(64254101132166130)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P70_INITIATIVE_ID'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64252052022166130)
,p_event_id=>wwv_flow_api.id(64254101132166130)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P70_INITIATIVE_NEW_NAME'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64251559118166129)
,p_event_id=>wwv_flow_api.id(64254101132166130)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P70_INITIATIVE_ID'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64251042342166129)
,p_event_id=>wwv_flow_api.id(64254101132166130)
,p_event_result=>'FALSE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P70_INITIATIVE_NEW_NAME'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(64270575814166144)
,p_name=>'Close DA'
,p_event_sequence=>100
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(64283773625166165)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64270116504166142)
,p_event_id=>wwv_flow_api.id(64270575814166144)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(79783249758804039)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(64269723596166142)
,p_name=>'Close2 DA'
,p_event_sequence=>110
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(79783249758804039)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64269208001166141)
,p_event_id=>wwv_flow_api.id(64269723596166142)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(79783249758804039)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(64271823023166146)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialize DP Item Details'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    DP_ITEM_CODE,',
'    ITEM_ID,',
'    ITEM_ID item_id_h,',
'    DP_ITEM_NAME,',
'    INITIATIVE_NEW_YN,',
'    INITIATIVE_ID,',
'    INITIATIVE_NEW_NAME,',
'    decode(PROJECT_NEW_YN , ''N'' , PROJECT_NUMBER, ''Y'' ,PROJECT_NEW_NAME)	,',
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
'    ESTIMATED_BUDGET,',
'    ESTIMATED_BUDGET_BRACKET_ID,',
'    NOTES,',
'    REVIEW_REJECT_REASON,',
'    ESTIMATED_DATE_DEFINE,',
'    DP_SCOPING_ID',
'INTO',
'    :P70_DP_ITEM_CODE,',
'    :P70_ITEM_ID,',
'    :P70_ITEM_ID_H,',
'    :P70_DP_ITEM_NAME,',
'    :P70_INITIATIVE_NEW_YN,',
'    :P70_INITIATIVE_ID,',
'    :P70_INITIATIVE_NEW_NAME,',
'    :P70_PROJECT_NUMBER,	',
'    :P70_PROJECT_NEW_YN,',
'    :P70_PROJECT_NEW_NAME,',
'    :P70_PROJECT_DESCRIPTION,',
'    :P70_MAIN_CATEGORY_ID,',
'    :P70_CATEGORY_ID,',
'    :P70_SUB_CATEGORY_ID,',
'    :P70_END_USER_ID,',
'    :P70_SECTOR_ID,',
'    :P70_DEPARTMENT_ID,',
'    :P70_COST_CENTER,',
'    :P70_DP_ITEM_TYPE_ID,',
'    :P70_CONTRACT_NO,',
'    :P70_RISK_ID,',
'    :P70_PRIORITY_ID,',
'    :P70_DP_PROCUREMENT_METHOD,',
'    :P70_PLANNING_STATUS,',
'    :P70_REVIEW_STATUS,',
'    :P70_APPROVAL_STATUS,',
'    :P70_CUTT_OFF_DATE,',
'    :P70_CREATED_BY,',
'    :P70_CREATED_ON,',
'    :P70_UPDATED_BY,',
'    :P70_UPDATED_ON,',
'    :P70_ESTIMATED_DATE,',
'    :P70_ESTIMATED_YEAR,',
'    :P70_ESTIMATED_QUARTER,',
'    :P70_ESTIMATED_BUDGET,',
'    :P70_ESTIMATED_BUDGET_BRACKET_ID,',
'    :P70_NOTES,',
'    :P70_REVIEW_REJECT_REASON,',
'    :P70_ESTIMATED_DATE_DEFINE,',
'    :P70_DP_SCOPING_ID',
'FROM',
'    DP_ITEMS',
'WHERE item_id = :P70_ITEM_ID ;',
'exception',
'    when others then null;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(64271409146166145)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_cutt_off_date    Date;',
'l_PLANNING_STATUS    Number;',
'begin',
'l_PLANNING_STATUS := DP_ITEMS_UTIL.GET_ITEM_PLANNING_STATUS(:P70_ITEM_ID , ''U'');',
'UPDATE dp_items',
'SET',
'    ESTIMATED_DATE_DEFINE = :P70_ESTIMATED_DATE_DEFINE,',
'    ESTIMATED_DATE            = to_date(:P70_ESTIMATED_DATE,''dd-Mon-YYYY''),',
'    ESTIMATED_QUARTER         = NVL(trim(to_char(to_date(:P70_ESTIMATED_DATE, ''dd-Mon-YYYY'' ) , ''Q'')) , :P70_ESTIMATED_QUARTER),',
'    ESTIMATED_YEAR            = NVL(trim(to_char(to_date(:P70_ESTIMATED_DATE, ''dd-Mon-YYYY'' ) , ''YYYY'')),:P70_ESTIMATED_YEAR),',
'    ESTIMATED_BUDGET_DEFINE = :P70_ESTIMATED_BUDGET_DEFINE,',
'    ESTIMATED_BUDGET            = :P70_ESTIMATED_BUDGET,',
'    ESTIMATED_BUDGET_BRACKET_ID = decode(:P70_ESTIMATED_BUDGET, Null,:P70_ESTIMATED_BUDGET_BRACKET_ID,',
'                                            (select  BRACKET_ID',
'                                            from dp_budget_brackets',
'                                            where :P70_ESTIMATED_BUDGET between MIN_VALUE and  MAX_VALUE)),',
'    DP_PROCUREMENT_METHOD       = :P70_DP_PROCUREMENT_METHOD,',
'    DP_ITEM_TYPE_ID             = :P70_DP_ITEM_TYPE_ID,',
'    RISK_ID                     = :P70_RISK_ID,',
'    PRIORITY_ID                 = :P70_PRIORITY_ID,',
'    NOTES                       = :P70_NOTES,',
'    --',
'    cutt_off_date               = dp_items_util.get_current_cuttoff_date(to_number(:CURRENT_YEAR)),',
'    PLANNING_STATUS             = l_PLANNING_STATUS',
'    ',
'WHERE',
'    item_id = :P70_ITEM_ID;',
'end ;    '))
,p_process_error_message=>'Changes not saved, Contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'UPDATE,Submit_REVIEW,New_document'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_process_success_message=>'Changes saved successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(64270959271166145)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'set Hidden Items process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
':P28_SCOPE_ID := :P70_DP_SCOPING_ID ;',
':P28_TEMPLATE_ID := :P70_TEMPLATE_ID;',
':P28_DP_ITEM_ID := :P70_ITEM_ID;',
'',
':P29_SCOPE_ID := :P70_DP_SCOPING_ID ;',
':P29_TEMPLATE_ID := :P70_TEMPLATE_ID;',
':P29_ITEM_ID := :P70_ITEM_ID;',
'',
':P30_SCOPE_ID := :P70_DP_SCOPING_ID ;',
':P30_TEMPLATE_ID := :P70_TEMPLATE_ID;',
':P30_ITEM_ID := :P70_ITEM_ID;',
'',
'',
':P31_SCOPE_ID := :P70_DP_SCOPING_ID ;',
':P31_TEMPLATE_ID := :P70_TEMPLATE_ID;',
':P31_ITEM_ID := :P70_ITEM_ID;',
'',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(64308880476166182)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(64272205262166148)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Create Version'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'L_ITEM_ID           Number;',
'l_COUNT_YEAR        Number;',
'l_COUNT_ITEM        Number;',
'--',
'l_INITIATIVE_ID     Number;',
'l_PROJECT_NUMBER    Number;',
'l_CATEGORY_ID       Number;',
'l_SUB_CATEGORY_ID   Number;',
'l_cost_center       Number;',
'Begin',
'',
' SELECT DP_ITEMS_SEQ.nextval',
'into L_ITEM_ID',
'FROM all_sequences',
' WHERE sequence_owner = ''PROD''',
'   AND sequence_name = ''DP_ITEMS_SEQ'';',
'',
'select user_details.get_cost_center(:PERSON_ID)',
'into l_cost_center',
'from dual;',
'',
'select NVL(Max(COUNT_YEAR),0)+1  ',
'into l_COUNT_YEAR',
'from dp_items',
'where dp_year = NV(''CURRENT_YEAR'');',
'',
'select INITIATIVE_ID  , PROJECT_NUMBER , CATEGORY_ID , SUB_CATEGORY_ID',
'into   l_INITIATIVE_ID  , l_PROJECT_NUMBER , l_CATEGORY_ID , l_SUB_CATEGORY_ID',
'from dp_items',
'where item_id = :P70_ITEM_ID;',
'',
'select NVL(Max(COUNT_ITEM),0)+1  ',
'into l_COUNT_ITEM',
'from dp_items',
'where dp_year = NV(''CURRENT_YEAR'')',
'and INITIATIVE_ID = l_INITIATIVE_ID',
'and project_number = l_PROJECT_NUMBER',
'and category_id = l_CATEGORY_ID',
'and SUB_CATEGORY_ID = l_SUB_CATEGORY_ID;',
'',
'INSERT INTO dp_items (',
'    initiative_id,',
'    project_number,',
'    project_new_yn,',
'    project_new_name,',
'    project_description,',
'    category_id,',
'    sub_category_id,',
'    estimated_date,',
'    estimated_month,',
'    estimated_year,',
'    estimated_quarter,',
'    end_user_id,',
'    sector_id,',
'    department_id,',
'    dp_item_type_id,',
'    risk_id,',
'    priority_id,',
'    dp_procurement_method,',
'    estimated_budget,',
'    estimated_budget_bracket_id,',
'    planning_status,',
'    review_status,',
'    approval_status,',
'    cutt_off_date,',
'    notes,',
'    cost_center,',
'    dp_item_name,',
'    count_year,',
'    count_item,',
'    dp_year,',
'    estimated_date_define,',
'    estimated_budget_define,',
'    initiative_new_yn,',
'    initiative_new_name,',
'    dp_item_code ,',
'    dp_scoping_id,',
'    main_category_id,',
'    contract_no',
') Select ',
'    initiative_id,',
'    project_number,',
'    project_new_yn,',
'    project_new_name,',
'    project_description,',
'    category_id,',
'    sub_category_id,',
'    estimated_date,',
'    estimated_month,',
'    estimated_year,',
'    estimated_quarter,',
'    end_user_id,',
'    sector_id,',
'    department_id,',
'    dp_item_type_id,',
'    risk_id,',
'    priority_id,',
'    dp_procurement_method,',
'    estimated_budget,',
'    estimated_budget_bracket_id,',
'    DP_ITEMS_UTIL.GET_ITEM_PLANNING_STATUS(:P70_ITEM_ID , ''I'') ,     --- planning_status,',
'    ''Draft'',           --  review_status,',
'    ''Required'',             -- approval_status,',
'    dp_items_util.get_current_cuttoff_date(to_number(:CURRENT_YEAR))    ,   --cutt_off_date,',
'    notes,',
'    cost_center,',
'    dp_item_name,',
'    count_year,',
'    l_COUNT_ITEM,',
'    NV(''CURRENT_YEAR''),',
'    estimated_date_define,',
'    estimated_budget_define,',
'    initiative_new_yn,',
'    initiative_new_name,',
'    dp_item_code || ''- V1'',',
'    Null,      --  dp_scoping_id,',
'    main_category_id,',
'    Null        -- contract_no',
'from dp_items',
'where item_id = :P70_ITEM_ID;',
'',
'',
'--',
'-- insert category role',
'if DP_ITEMS_UTIL.PBP_COUNT_BY_DP_CATEGORY_ID(L_SUB_CATEGORY_ID) > 0',
'then ',
'INSERT INTO dp_item_roles (item_id, role_id, person_id)',
'select L_ITEM_ID ,ROLE_ID, PERSON_ID ',
'from dp_item_category_roles',
'where CATEGORY_ID = L_SUB_CATEGORY_ID',
'and status = ''A''',
'and sysdate between nvl(START_DATE, sysdate - 10) and nvl(END_DATE , sysdate + 10) ;',
'',
'else',
'    -- insert PbP from cost center',
'    INSERT INTO dp_item_roles (item_id, role_id, person_id)',
'        select L_ITEM_ID ,108, PERSON_ID ',
'        from cost_centers_fbp',
'        where COST_CENTER = l_cost_center',
'        and status = ''A''',
'        and sysdate between nvl(START_DATE, sysdate - 10) and nvl(END_DATE , sysdate + 10) ',
'        and BP_TYPE = ''PBP'';',
'End if;        ',
'',
'-- insert finance BP',
'for emp in (select PERSON_ID ',
'            from cost_centers_fbp',
'            where COST_CENTER = l_cost_center ',
'            and STATUS = ''A''',
'            and sysdate between nvl(START_DATE , sysdate - 10) and nvl(END_DATE , sysdate + 10)',
'            and BP_TYPE = ''FBP'')',
'    loop',
'        INSERT INTO dp_item_roles (item_id, role_id, person_id)',
'        values (L_ITEM_ID , 227 , emp.person_id);',
'    end loop;',
'',
'-- Insert Participants',
'INSERT INTO dp_item_participants (item_id, person_id, role_id, status, start_date) ',
'VALUES (L_ITEM_ID, :PERSON_ID,',
'    241,    -- ROLE_id FOR OWNER (lOOKUP:DP_ITEM_PARTICIPANT_ROL)',
'    ''A'',sysdate);',
'',
'-- Copy Documents',
'INSERT INTO dp_items_documents (',
'    row_version_number,',
'    dp_items_id,',
'    filename,',
'    file_mimetype,',
'    file_charset,',
'    file_blob,',
'    file_comments,',
'    tags',
') Select',
'        row_version_number,',
'    dp_items_id,',
'    filename,',
'    file_mimetype,',
'    file_charset,',
'    file_blob,',
'    file_comments,',
'    tags',
'from dp_items_documents',
'where dp_items_id = :P70_ITEM_ID;',
'end;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(64306507398166181)
);
wwv_flow_api.component_end;
end;
/
