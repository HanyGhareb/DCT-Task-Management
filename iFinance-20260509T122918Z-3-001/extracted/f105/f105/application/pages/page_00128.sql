prompt --application/pages/page_00128
begin
--   Manifest
--     PAGE: 00128
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
 p_id=>128
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Budget Allocation - Project Details'
,p_alias=>'BUDGET-ALLOCATION-PROJECT-DETAILS'
,p_step_title=>'Budget Allocation - Project Details'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240214134648'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(10317917512613901)
,p_plug_name=>'Budget Allocation - Project Details'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'BA_PROJECTS_ALLOCATION'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(8507711279715701)
,p_plug_name=>'L1'
,p_parent_plug_id=>wwv_flow_api.id(10317917512613901)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_read_only_when_type=>'PLSQL_EXPRESSION'
,p_plug_read_only_when=>':P128_ID is not null and :P128_STATUS not in (''Draft'' , ''Withdraw'' , ''Return'')'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(8507861234715702)
,p_plug_name=>'R1'
,p_parent_plug_id=>wwv_flow_api.id(10317917512613901)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_read_only_when_type=>'PLSQL_EXPRESSION'
,p_plug_read_only_when=>':P128_ID is not null and :P128_STATUS not in (''Draft'' , ''Withdraw'' , ''Return'')'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(8508011324715704)
,p_plug_name=>'End User'
,p_parent_plug_id=>wwv_flow_api.id(10317917512613901)
,p_icon_css_classes=>'fa-user'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p><strong><span style="color: #ff0000;">&nbsp; &nbsp; &nbsp; *hint: Allocated Budget must be equal to total of monthly amount</span></strong></p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_read_only_when_type=>'PLSQL_EXPRESSION'
,p_plug_read_only_when=>':P128_ID is not null and :P128_STATUS not in (''Draft'' , ''Withdraw'' , ''Return'')'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(10527619787009998)
,p_plug_name=>'End User-L'
,p_parent_plug_id=>wwv_flow_api.id(8508011324715704)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(10527730159009999)
,p_plug_name=>'End User-R'
,p_parent_plug_id=>wwv_flow_api.id(8508011324715704)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(8508141091715705)
,p_plug_name=>'Finance Business Partner'
,p_parent_plug_id=>wwv_flow_api.id(10317917512613901)
,p_icon_css_classes=>'fa-user-graduate'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent4:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>60
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_read_only_when_type=>'PLSQL_EXPRESSION'
,p_plug_read_only_when=>'(:P128_ID is not null and :P128_STATUS not in (''Draft'' , ''Withdraw'' , ''Return'')) and :IS_FBP_EMP = ''N'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(8508188379715706)
,p_plug_name=>'Audit'
,p_parent_plug_id=>wwv_flow_api.id(10317917512613901)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>80
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(10524868399009971)
,p_plug_name=>'Documents'
,p_parent_plug_id=>wwv_flow_api.id(10317917512613901)
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>70
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(10528316035010005)
,p_plug_name=>'Documents report'
,p_parent_plug_id=>wwv_flow_api.id(10524868399009971)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ROW_VERSION_NUMBER,',
'       BA_PROJECTS_ALLOCATION_ID,',
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
'  from ba_projects_allocation_documents',
'  where BA_PROJECTS_ALLOCATION_ID = :P128_ID',
'  order by UPDATED desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P128_ID'
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
 p_id=>wwv_flow_api.id(10528371545010006)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>223812403934194638
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10528476947010007)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10528598996010008)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Version Number'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10528685822010009)
,p_db_column_name=>'BA_PROJECTS_ALLOCATION_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Ba Projects Allocation Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10528799466010010)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'File Name'
,p_column_link=>'f?p=&APP_ID.:133:&SESSION.::&DEBUG.:133:P133_ID,P133_STATUS:#ID#,&P128_STATUS.'
,p_column_linktext=>'#FILENAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10528868896010011)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10529001668010012)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10529096073010013)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10529266926010014)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10529294066010015)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10529436690010016)
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
 p_id=>wwv_flow_api.id(10529536220010017)
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
 p_id=>wwv_flow_api.id(10529572200010018)
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
 p_id=>wwv_flow_api.id(11298201916276969)
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
 p_id=>wwv_flow_api.id(11298333104276970)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11298399149276971)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DOWNLOAD:BA_PROJECTS_ALLOCATION_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(11336792051375265)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'2246209'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:TAGS:ROW_VERSION_NUMBER:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(10527928291010001)
,p_plug_name=>'Additional Details'
,p_parent_plug_id=>wwv_flow_api.id(10317917512613901)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11299674231276984)
,p_plug_name=>'Cost Center Summary'
,p_parent_plug_id=>wwv_flow_api.id(10317917512613901)
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
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
 p_id=>wwv_flow_api.id(10369888717613937)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99766883142410755)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(99703488427410717)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(99820961719410781)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(10348391670613916)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(10369888717613937)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:127:&SESSION.::&DEBUG.:::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(10527516864009997)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(10369888717613937)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:127:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11298506601276972)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(10524868399009971)
,p_button_name=>'New_document'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Add Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:133:&SESSION.::&DEBUG.::P133_BA_PROJECTS_ALLOCATION_ID,P133_STATUS:&P128_ID.,'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(10349243072613917)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(10369888717613937)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition=>':PERSON_ID in ( 680461 , 1634334 , 128383)'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-trash-o'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(10349574477613917)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(10369888717613937)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P128_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-save-as'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(10350034207613917)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(10369888717613937)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P128_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_icon_css_classes=>'fa-save'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(10350317119613917)
,p_branch_action=>'f?p=&APP_ID.:127:&SESSION.::&DEBUG.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8903046169781710)
,p_name=>'P128_STATUS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(8507861234715702)
,p_prompt=>'Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8903119193781711)
,p_name=>'P128_APPROVED_BUDGET'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(8507861234715702)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Approved Budget'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'APPROVED_BUDGET'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10318265862613901)
,p_name=>'P128_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(10317917512613901)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Id'
,p_source=>'ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_label_alignment=>'RIGHT'
,p_field_template=>wwv_flow_api.id(99818469241410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10318598159613901)
,p_name=>'P128_FISICAL_YEAR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(10317917512613901)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_source=>'FISICAL_YEAR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10319032223613902)
,p_name=>'P128_COST_CENTER_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(8507711279715701)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Cost Center'
,p_source=>'COST_CENTER_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'COST CENTERS WITH NAMES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''('' || COST_CENTER_CODE || '') '' || COST_CENTER_DESCRIPTION Name, COST_CENTER_CODE',
'from(',
'select distinct  COST_CENTER_DESCRIPTION, COST_CENTER_CODE',
'from dct_gl_code_combinations_all',
'order by COST_CENTER_CODE)'))
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10319388493613902)
,p_name=>'P128_PROJECT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(8507711279715701)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Project'
,p_source=>'PROJECT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'PROJECTS NUMBERS WITH NAME LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''('' || PROJECT_NUMBER || '') '' || PROJECT_CODE Name, PROJECT_NUMBER',
'from(',
'select distinct  PROJECT_CODE, PROJECT_NUMBER',
'from project',
'order by PROJECT_NUMBER);'))
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10319842270613902)
,p_name=>'P128_TASK_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(8507711279715701)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Task'
,p_source=>'TASK_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10320244310613902)
,p_name=>'P128_EXPENDITURE_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(8507711279715701)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Expenditure Type'
,p_source=>'EXPENDITURE_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10320637138613903)
,p_name=>'P128_INITIATIVE_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(8507861234715702)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Initiative'
,p_source=>'INITIATIVE_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10321053322613903)
,p_name=>'P128_CHAPTER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(8507861234715702)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Chapter'
,p_source=>'CHAPTER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10321467209613903)
,p_name=>'P128_EXPENSE_CLASS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(8507861234715702)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Expense Class'
,p_source=>'EXPENSE_CLASS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10321860936613903)
,p_name=>'P128_REQUESTED_BUDGET'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(8507861234715702)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Requested Budget'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'REQUESTED_BUDGET'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10322191821613903)
,p_name=>'P128_ALLOCATED_BUDGET_EU'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(10527619787009998)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Allocated Budget'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'ALLOCATED_BUDGET_EU'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10322599702613904)
,p_name=>'P128_JAN_EU'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(10527619787009998)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Jan-24'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'JAN_EU'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10323005104613904)
,p_name=>'P128_FEB_EU'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(10527619787009998)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Feb-24'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'FEB_EU'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10323426989613904)
,p_name=>'P128_MAR_EU'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(10527619787009998)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Mar-24'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'MAR_EU'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10323854789613904)
,p_name=>'P128_APR_EU'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(10527619787009998)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Apr-24'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'APR_EU'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10324180166613904)
,p_name=>'P128_MAY_EU'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(10527619787009998)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'May-24'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'MAY_EU'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10324578069613905)
,p_name=>'P128_JUN_EU'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(10527619787009998)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Jun-24'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'JUN_EU'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10324976050613905)
,p_name=>'P128_JUL_EU'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(10527619787009998)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Jul-24'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'JUL_EU'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10325441180613905)
,p_name=>'P128_AUG_EU'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(10527619787009998)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Aug-24'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'AUG_EU'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
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
 p_id=>wwv_flow_api.id(10325812691613905)
,p_name=>'P128_SEP_EU'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(10527619787009998)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Sep-24'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'SEP_EU'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10326223729613905)
,p_name=>'P128_OCT_EU'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(10527619787009998)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Oct-24'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'OCT_EU'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10326596358613906)
,p_name=>'P128_NOV_EU'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(10527619787009998)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Nov-24'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'NOV_EU'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10327065160613906)
,p_name=>'P128_DEC_EU'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(10527619787009998)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Dec-24'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'DEC_EU'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10327405935613906)
,p_name=>'P128_ALLOCATED_BUDGET_FBP'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(8508141091715705)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Allocated Budget'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'ALLOCATED_BUDGET_FBP'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10327866276613906)
,p_name=>'P128_JAN_FBP'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(8508141091715705)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Jan-24'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'JAN_FBP'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10328216612613907)
,p_name=>'P128_FEB_FBP'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(8508141091715705)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Feb-24'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'FEB_FBP'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10328659650613907)
,p_name=>'P128_MAR_FBP'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(8508141091715705)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Mar-24'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'MAR_FBP'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10329058977613907)
,p_name=>'P128_APR_FBP'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(8508141091715705)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Apr-24'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'APR_FBP'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10329459269613907)
,p_name=>'P128_MAY_FBP'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(8508141091715705)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'May-24'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'MAY_FBP'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10329827037613907)
,p_name=>'P128_JUN_FBP'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(8508141091715705)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Jun-24'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'JUN_FBP'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10330173367613908)
,p_name=>'P128_JUL_FBP'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_api.id(8508141091715705)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Jul-24'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'JUL_FBP'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10330580346613908)
,p_name=>'P128_AUG_FBP'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>320
,p_item_plug_id=>wwv_flow_api.id(8508141091715705)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Aug-24'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'AUG_FBP'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10330989718613908)
,p_name=>'P128_SEP_FBP'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>330
,p_item_plug_id=>wwv_flow_api.id(8508141091715705)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Sep-24'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'SEP_FBP'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10331401729613908)
,p_name=>'P128_OCT_FBP'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>340
,p_item_plug_id=>wwv_flow_api.id(8508141091715705)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Oct-24'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'OCT_FBP'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10331790460613908)
,p_name=>'P128_NOV_FBP'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>350
,p_item_plug_id=>wwv_flow_api.id(8508141091715705)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Nov-24'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'NOV_FBP'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10332193702613909)
,p_name=>'P128_DEC_FBP'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>360
,p_item_plug_id=>wwv_flow_api.id(8508141091715705)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Dec-24'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'DEC_FBP'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10332585081613909)
,p_name=>'P128_COMMENTS_EU'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(10527730159009999)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Comment'
,p_source=>'COMMENTS_EU'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>4000
,p_cHeight=>2
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10333049540613909)
,p_name=>'P128_COMMENTS_FBP'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>380
,p_item_plug_id=>wwv_flow_api.id(8508141091715705)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Comment'
,p_source=>'COMMENTS_FBP'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>4000
,p_cHeight=>2
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10333419296613909)
,p_name=>'P128_CREATED'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>390
,p_item_plug_id=>wwv_flow_api.id(8508188379715706)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_source=>'CREATED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10334246191613910)
,p_name=>'P128_CREATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>400
,p_item_plug_id=>wwv_flow_api.id(8508188379715706)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10334568022613910)
,p_name=>'P128_UPDATED'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>410
,p_item_plug_id=>wwv_flow_api.id(8508188379715706)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Updated'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'UPDATED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10335449102613910)
,p_name=>'P128_UPDATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>420
,p_item_plug_id=>wwv_flow_api.id(8508188379715706)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Updated By'
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10527785345010000)
,p_name=>'P128_ITEM_CATEGORY1'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(8507711279715701)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Category Level 1'
,p_source=>'ITEM_CATEGORY1'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'ITEM MAIN CATEGORIES POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  CATEGORY_NAME , CATEGORY_ID , CATEGORY_DESCRIPTION ',
'from dp_item_categories',
'where ORDER_LEVEL = 231 ;'))
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10527994534010002)
,p_name=>'P128_ITEM_CATEGORY2'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(8507711279715701)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Category Level 2'
,p_source=>'ITEM_CATEGORY2'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'ITEM CATEGORIES POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CATEGORY_ID, CATEGORY_NAME , CATEGORY_DESCRIPTION ',
'from dp_item_categories',
'where ORDER_LEVEL = 232 ',
'and parent_category_id = :P128_ITEM_CATEGORY1;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P128_ITEM_CATEGORY1'
,p_ajax_items_to_submit=>'P128_ITEM_CATEGORY1'
,p_ajax_optimize_refresh=>'Y'
,p_cSize=>30
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10528128729010003)
,p_name=>'P128_ITEM_CATEGORY3'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(8507711279715701)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'Category Level 3'
,p_source=>'ITEM_CATEGORY3'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'ITEM SUB_CSTEGORIES POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CATEGORY_ID  , CATEGORY_NAME ,CATEGORY_DESCRIPTION ',
'from dp_item_categories',
'where PARENT_CATEGORY_ID = :P128_ITEM_CATEGORY2',
'and status = ''A''',
'and sysdate between nvl(START_DATE , sysdate - 10 ) and nvl(END_DATE , sysdate + 10)'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P128_ITEM_CATEGORY2'
,p_ajax_items_to_submit=>'P128_ITEM_CATEGORY2'
,p_ajax_optimize_refresh=>'Y'
,p_cSize=>30
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10528191346010004)
,p_name=>'P128_SMD_CATEGORY'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(8507861234715702)
,p_item_source_plug_id=>wwv_flow_api.id(10317917512613901)
,p_prompt=>'SMD Category'
,p_source=>'SMD_CATEGORY_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'SMD CATEGORY'
,p_lov=>'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = (select l.lookup_id from dct_lookups l where l.lookup_code = ''SMD_CATEGORY'') and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10) '
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p><span style="text-decoration: underline;"><strong><span style="color: #0000ff; text-decoration: underline;">SMD Category:</span></strong></span></p>',
'<ul>',
'<li><strong>Demand:</strong> Not covered by an existing contracts and requires procurement process.</li>',
'<li><strong>Non-Demand:</strong> Covered by an existing contracts for the entire year.</li>',
'<li><strong>Partially Demand</strong>: If a mix of demand and non-demand items are under the same budget line or if the current year is not fully covered by the existing contracts (Requires extension/renewal).</li>',
'</ul>'))
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11299210145276979)
,p_name=>'P128_CC_APPROVED_BUDGET'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(10317917512613901)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11299272424276980)
,p_name=>'P128_CC_ALLOCATED_BUDGET'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(10317917512613901)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11299414104276981)
,p_name=>'P128_CC_ALLOCATED_BUDGET_FBP'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(10317917512613901)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11299645958276983)
,p_name=>'P128_CC_CODE_H'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(10317917512613901)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11299855395276985)
,p_name=>'P128_CC_APPROVED_BUDGET_L'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(11299674231276984)
,p_prompt=>'Total Approved Budget'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'trim(to_char(:P128_CC_APPROVED_BUDGET, ''99,999,999,999.99''))'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11299870697276986)
,p_name=>'P128_CC_ALLOCATED_BUDGET_L'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(11299674231276984)
,p_prompt=>'Total Allocated Budget'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'trim(to_char(:P128_CC_ALLOCATED_BUDGET, ''99,999,999,999.99''))'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11299996190276987)
,p_name=>'P128_CC_AVAILABLE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(11299674231276984)
,p_prompt=>'Available Budget'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_source=>'trim(to_char(:P128_CC_APPROVED_BUDGET - :P128_CC_ALLOCATED_BUDGET, ''99,999,999,999.99''))'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(10525112584009973)
,p_validation_name=>'Validate total Amount'
,p_validation_sequence=>10
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'nvl(:P128_ALLOCATED_BUDGET_EU,0) =',
'(nvl(:P128_JAN_EU , 0) +',
'nvl(:P128_FEB_EU , 0) +',
'nvl(:P128_MAR_EU , 0) +',
'nvl(:P128_APR_EU , 0) +',
'nvl(:P128_MAY_EU , 0) +',
'nvl(:P128_JUN_EU , 0) +',
'nvl(:P128_JUL_EU , 0) +',
'nvl(:P128_AUG_EU , 0) +',
'nvl(:P128_SEP_EU , 0) +',
'nvl(:P128_OCT_EU , 0) +',
'nvl(:P128_NOV_EU , 0) +',
'nvl(:P128_DEC_EU , 0) )'))
,p_validation_type=>'PLSQL_EXPRESSION'
,p_error_message=>'<p><strong><span style="color: #ff0000;">&nbsp; Allocated Budget must be equal to total of monthly amount</span></strong></p>'
,p_always_execute=>'Y'
,p_when_button_pressed=>wwv_flow_api.id(10349574477613917)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(10525243703009974)
,p_validation_name=>'Validate total Amount_FBP'
,p_validation_sequence=>20
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'nvl(:P128_ALLOCATED_BUDGET_FBP,0) =',
'(nvl(:P128_JAN_FBP , 0) +',
'nvl(:P128_FEB_FBP , 0) +',
'nvl(:P128_MAR_FBP , 0) +',
'nvl(:P128_APR_FBP , 0) +',
'nvl(:P128_MAY_FBP , 0) +',
'nvl(:P128_JUN_FBP , 0) +',
'nvl(:P128_JUL_FBP , 0) +',
'nvl(:P128_AUG_FBP , 0) +',
'nvl(:P128_SEP_FBP , 0) +',
'nvl(:P128_OCT_FBP , 0) +',
'nvl(:P128_NOV_FBP , 0) +',
'nvl(:P128_DEC_FBP , 0) )'))
,p_validation_type=>'PLSQL_EXPRESSION'
,p_error_message=>'<p><strong><span style="color: #ff0000;">&nbsp; Allocated Budget must be equal to total of monthly amount</span></strong></p>'
,p_always_execute=>'Y'
,p_when_button_pressed=>wwv_flow_api.id(10349574477613917)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(10333880331613910)
,p_validation_name=>'P128_CREATED must be timestamp'
,p_validation_sequence=>30
,p_validation=>'P128_CREATED'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(10333419296613909)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(10335131123613910)
,p_validation_name=>'P128_UPDATED must be timestamp'
,p_validation_sequence=>40
,p_validation=>'P128_UPDATED'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(10334568022613910)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(8903740434781717)
,p_validation_name=>'Validate Allocated Budget EU not Exceed Cost Center  ceiling'
,p_validation_sequence=>50
,p_validation=>'BA_ALLOCATION.validate_user_allocation(:P128_CC_CODE_H ,:P128_CHAPTER , :P128_FISICAL_YEAR, :P128_ID, :P128_ALLOCATED_BUDGET_EU) = ''Y'''
,p_validation_type=>'PLSQL_EXPRESSION'
,p_error_message=>'you can''t exceed the cost center ceiling &P128_CC_APPROVED_BUDGET_L. AED'
,p_always_execute=>'Y'
,p_validation_condition_type=>'NEVER'
,p_associated_item=>wwv_flow_api.id(10322191821613903)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(11298824566276975)
,p_name=>'New_document DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(11298506601276972)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(11298896739276976)
,p_event_id=>wwv_flow_api.id(11298824566276975)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(10528316035010005)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(11299051857276977)
,p_name=>'Documents report DA'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(10528316035010005)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(11299124115276978)
,p_event_id=>wwv_flow_api.id(11299051857276977)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(10528316035010005)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(10351261687613918)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(10317917512613901)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Budget Allocation - Project Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(10350798929613918)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(10317917512613901)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Budget Allocation - Project Details'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(11299550350276982)
,p_process_sequence=>20
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get Cost Center Budgets amount'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select BA_ALLOCATION.approved_budget       (:P128_CC_CODE_H, :P128_CHAPTER ,''2024'') cc_approved_budget,',
'       BA_ALLOCATION.allocated_budget      (:P128_CC_CODE_H, :P128_CHAPTER ,''2024'') cc_allocated_budget,',
'       BA_ALLOCATION.allocated_budget_fbp  (:P128_CC_CODE_H, :P128_CHAPTER ,''2024'') cc_allocated_budget_fbp',
'into ',
'    :P128_CC_APPROVED_BUDGET,',
'    :P128_CC_ALLOCATED_BUDGET,',
'    :P128_CC_ALLOCATED_BUDGET_FBP',
'from dual;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
