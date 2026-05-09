prompt --application/pages/page_00098
begin
--   Manifest
--     PAGE: 00098
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
 p_id=>98
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Budget Proposal - Project'
,p_alias=>'BUDGET-PROPOSAL-PROJECT'
,p_step_title=>'Budget Proposal - Project'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'PLSQL_EXPRESSION'
,p_read_only_when=>':P98_STATUS not in (''Available'' , ''Draft'' , ''Return'')'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230610060552'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(49436688906265095)
,p_plug_name=>'Budget Proposal - Project Line Details'
,p_icon_css_classes=>'fa-align-justify'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'BUDGET_PROPOSAL_PROJECTS_PLANS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(50228300400855784)
,p_plug_name=>'Hidden'
,p_parent_plug_id=>wwv_flow_api.id(49436688906265095)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(49198952851443397)
,p_plug_name=>'Audit'
,p_parent_plug_id=>wwv_flow_api.id(49436688906265095)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(49198890159443396)
,p_plug_name=>'Accounting Details'
,p_parent_plug_id=>wwv_flow_api.id(49436688906265095)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(48942496395033322)
,p_plug_name=>'Costing Details'
,p_parent_plug_id=>wwv_flow_api.id(49436688906265095)
,p_icon_css_classes=>'fa-credit-card'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(48942317765033320)
,p_plug_name=>'Costing Details R1'
,p_parent_plug_id=>wwv_flow_api.id(48942496395033322)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(48942169493033319)
,p_plug_name=>'Costing Details L1'
,p_parent_plug_id=>wwv_flow_api.id(48942496395033322)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(48942081020033318)
,p_plug_name=>'Cashflow'
,p_parent_plug_id=>wwv_flow_api.id(48942496395033322)
,p_icon_css_classes=>'fa-money'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(48941877605033316)
,p_plug_name=>'Previous Budget'
,p_parent_plug_id=>wwv_flow_api.id(48942081020033318)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(48941816725033315)
,p_plug_name=>'&P98_PROPOSAL_YEAR. Cashflow '
,p_parent_plug_id=>wwv_flow_api.id(48942081020033318)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(48942009170033317)
,p_plug_name=>'Strategy Planning Details'
,p_parent_plug_id=>wwv_flow_api.id(48942496395033322)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(38673531302494008)
,p_plug_name=>'Documents'
,p_parent_plug_id=>wwv_flow_api.id(49436688906265095)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent13:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(38673427345494007)
,p_plug_name=>'Documents Report'
,p_parent_plug_id=>wwv_flow_api.id(38673531302494008)
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
'  where PLAN_ID = :P98_PLAN_ID_H',
'  and COST_CENTER = :P97_COST_CENTER',
'  and project_number =  :P98_PROJECT_NUMBER',
'  and task_number = :P98_TASK_NUMBER',
'  order by UPDATED desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P98_PLAN_ID_H,P98_PROJECT_NUMBER,P98_TASK_NUMBER'
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
 p_id=>wwv_flow_api.id(38673267496494006)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_rows_per_page=>'N'
,p_show_filter=>'N'
,p_show_control_break=>'N'
,p_show_highlight=>'N'
,p_show_computation=>'N'
,p_show_aggregate=>'N'
,p_show_chart=>'N'
,p_show_group_by=>'N'
,p_show_pivot=>'N'
,p_show_flashback=>'N'
,p_show_reset=>'N'
,p_show_help=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>174610764892690626
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38673192653494005)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38673110004494004)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Document Version'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38672992874494003)
,p_db_column_name=>'PLAN_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Plan Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38672867247494002)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Sector Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38672744230494001)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38672689610494000)
,p_db_column_name=>'FILENAME'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Document Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38672600295493999)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38672519184493998)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38672343136493997)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38672239592493996)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38672166381493995)
,p_db_column_name=>'TAGS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38672070521493994)
,p_db_column_name=>'CREATED'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38671997624493993)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38671861609493992)
,p_db_column_name=>'UPDATED'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38671820843493991)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38671553564493989)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38671480042493988)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38671230564493985)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38671078012493984)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DOWNLOAD:BUDGET_PROPOSAL_PLANS_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(38645449279291147)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1746386'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:ROW_VERSION_NUMBER:FILE_COMMENTS:CREATED:CREATED_BY:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(38622289761086631)
,p_plug_name=>'Collaborations'
,p_parent_plug_id=>wwv_flow_api.id(49436688906265095)
,p_icon_css_classes=>'fa-comments-o'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(38622180775086630)
,p_name=>'Collaborations Report'
,p_parent_plug_id=>wwv_flow_api.id(38622289761086631)
,p_template=>wwv_flow_api.id(99730028608410735)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Form--slimPadding:t-Form--large'
,p_component_template_options=>'#DEFAULT#:t-Comments--chat'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select   CASE',
'            WHEN dbms_lob.getlength(photo_blob) > 0 THEN',
'                ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(user_name)',
'            ELSE',
'                 ''#WORKSPACE_IMAGES#no-photo(1).png''',
'       ',
'       END                                      user_icon,',
'       updated_date                             comment_date,',
'       full_name_en                             user_name,',
'       comment_text                             comment_text,',
'        null                                    comment_modifiers,',
'        ''u-color-''||ora_hash(user_name,45)      icon_modifier,',
'        ACTION                                  actions,',
'        ''''                                      attribute_1,',
'        ''''                                      attribute_2,',
'        ''''                                      attribute_3,',
'        sys.dbms_lob.getlength(file_blob)       attribute_4,',
'        comment_id,',
'        filename,',
'        comment_to_person_id                    Comment_to',
'',
'',
'',
'from(       ',
'SELECT',
'    c.comment_id,',
'    c.PLAN_ID,',
'    c.SECTOR_PLAN_ID,',
'    c.CC_PLAN_ID,',
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
'FROM BUDGET_PROPOSAL_PLAN_COMMENTS c , employees_v e',
'where c.updated_by = e.person_id',
'and c.plan_id = :P98_PLAN_ID_H',
'--and c.SECTOR_PLAN_ID = :P98_SECTOR_ID',
'and c.CC_PLAN_ID = :P98_CC_PLAN_ID_H',
'and c.project_number = :P98_PROJECT_NUMBER',
'and c.task_number = :P98_TASK_NUMBER)'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P98_PLAN_ID_H,P98_CC_PLAN_ID_H,P98_PROJECT_NUMBER,P98_TASK_NUMBER'
,p_query_row_template=>wwv_flow_api.id(99786373050410764)
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
 p_id=>wwv_flow_api.id(38621967434086628)
,p_query_column_id=>1
,p_column_alias=>'USER_ICON'
,p_column_display_sequence=>1
,p_column_heading=>'User Icon'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<img src="#USER_ICON#" alt="Image Not Found" height="40" width="40">'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(38621332020086621)
,p_query_column_id=>2
,p_column_alias=>'COMMENT_DATE'
,p_column_display_sequence=>2
,p_column_heading=>'Comment Date'
,p_use_as_row_header=>'N'
,p_column_format=>'DD-MON-YYYY HH:MIPM'
,p_column_html_expression=>'<br>#COMMENT_DATE#'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(38620645170086615)
,p_query_column_id=>3
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>3
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(38621666708086625)
,p_query_column_id=>4
,p_column_alias=>'COMMENT_TEXT'
,p_column_display_sequence=>4
,p_column_heading=>'Comment Text'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:116:&SESSION.::&DEBUG.::P116_COMMENT_ID:#COMMENT_ID#'
,p_column_linktext=>'#COMMENT_TEXT#'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(38620585407086614)
,p_query_column_id=>5
,p_column_alias=>'COMMENT_MODIFIERS'
,p_column_display_sequence=>5
,p_column_heading=>'Comment Modifiers'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(38620450890086613)
,p_query_column_id=>6
,p_column_alias=>'ICON_MODIFIER'
,p_column_display_sequence=>6
,p_column_heading=>'Icon Modifier'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(38621199269086620)
,p_query_column_id=>7
,p_column_alias=>'ACTIONS'
,p_column_display_sequence=>7
,p_column_heading=>'Actions'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(38621083595086619)
,p_query_column_id=>8
,p_column_alias=>'ATTRIBUTE_1'
,p_column_display_sequence=>9
,p_column_heading=>'Attribute 1'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(38621026219086618)
,p_query_column_id=>9
,p_column_alias=>'ATTRIBUTE_2'
,p_column_display_sequence=>10
,p_column_heading=>'Attribute 2'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(38620921205086617)
,p_query_column_id=>10
,p_column_alias=>'ATTRIBUTE_3'
,p_column_display_sequence=>11
,p_column_heading=>'Attribute 3'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(38620797413086616)
,p_query_column_id=>11
,p_column_alias=>'ATTRIBUTE_4'
,p_column_display_sequence=>12
,p_column_heading=>'Attribute 4'
,p_use_as_row_header=>'N'
,p_column_format=>'DOWNLOAD:BUDGET_PROPOSAL_PLAN_COMMENTS:FILE_BLOB:COMMENT_ID::FILE_MIMETYPE:FILENAME:UPDATED_DATE:FILE_CHARSET:attachment:Document #FILENAME#:'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(38621919018086627)
,p_query_column_id=>12
,p_column_alias=>'COMMENT_ID'
,p_column_display_sequence=>15
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(38620308816086611)
,p_query_column_id=>13
,p_column_alias=>'FILENAME'
,p_column_display_sequence=>13
,p_column_heading=>'Filename'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(38619953114086608)
,p_query_column_id=>14
,p_column_alias=>'COMMENT_TO'
,p_column_display_sequence=>14
,p_column_heading=>'Comment To'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(49346137453265037)
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
 p_id=>wwv_flow_api.id(49382009534265063)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(49346137453265037)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:&P98_PAGE_FROM.:&SESSION.::&DEBUG.:::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(38671022318493983)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(38673531302494008)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Add Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:102:&SESSION.::&DEBUG.:102:P102_PLAN_ID,P102_COST_CENTER,P102_PROJECT_NUMBER,P102_TASK_NUMBER:&P98_PLAN_ID_H.,&P98_COST_CENTER.,&P98_PROJECT_NUMBER.,&P98_TASK_NUMBER.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(38619733313086606)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(38622289761086631)
,p_button_name=>'New_COMMENT'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Comments'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:116:&SESSION.::&DEBUG.:116:P116_PLAN_ID,P116_CC_PLAN_ID,P116_PROJECT_NUMBER,P116_TASK_NUMBER,P116_PROJECT_PLAN_ID,P116_COST_CENTER:&P98_PLAN_ID_H.,&P98_CC_PLAN_ID_H.,&P98_PROJECT_NUMBER.,&P98_TASK_NUMBER.,&P98_ID.,&P98_COST_CENTER.'
,p_icon_css_classes=>'fa-commenting-o fa-anim-flash'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(49381160360265061)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(49346137453265037)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition=>':P98_STATUS  in (''Available'' , ''Draft'' , ''Return'', ''Rejected'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(49380771878265061)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(49346137453265037)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>':P98_STATUS  in (''Available'' , ''Draft'' , ''Return'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(49380053200265060)
,p_branch_action=>'f?p=&APP_ID.:97:&SESSION.::&DEBUG.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50228160423855783)
,p_name=>'P98_ACTUAL_Y1'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>500
,p_item_plug_id=>wwv_flow_api.id(48941877605033316)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Actual &P98_AY1.'
,p_post_element_text=>'<p><span style="color: #000000;">&nbsp;AED</span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'ACTUAL_Y1'
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
 p_id=>wwv_flow_api.id(50228048197855782)
,p_name=>'P98_ACTUAL_Y2'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>490
,p_item_plug_id=>wwv_flow_api.id(48941877605033316)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Actual &P98_AY2.'
,p_post_element_text=>'<p><span style="color: #000000;">&nbsp;AED</span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'ACTUAL_Y2'
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
 p_id=>wwv_flow_api.id(49436395249265095)
,p_name=>'P98_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(49436688906265095)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
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
 p_id=>wwv_flow_api.id(49435936645265092)
,p_name=>'P98_PLAN_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(49436688906265095)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Proposal Plan'
,p_source=>'PLAN_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'BUDGET PROPOSAL PLANS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PLAN_NAME , PLAN_ID',
'from budget_proposal_plans'))
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49435564043265090)
,p_name=>'P98_SECTOR_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(49436688906265095)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Sector'
,p_source=>'SECTOR_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'SECTORS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  NVL(SECTOR_NAME_USER , SECTOR_NAME) Name , SECTOR_ID',
'from dct_hr_sectors_v'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49435144075265090)
,p_name=>'P98_PROJECT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(49436688906265095)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Project Number'
,p_source=>'PROJECT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49434741494265089)
,p_name=>'P98_TASK_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(49436688906265095)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Task Number'
,p_source=>'TASK_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49434412689265089)
,p_name=>'P98_EXPENDITURE_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(49436688906265095)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Expenditure Type'
,p_source=>'EXPENDITURE_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
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
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49434021546265089)
,p_name=>'P98_ENTITY_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(49198890159443396)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Entity Code'
,p_source=>'ENTITY_CODE'
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
 p_id=>wwv_flow_api.id(49433540304265089)
,p_name=>'P98_COST_CENTER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(49198890159443396)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Cost Center'
,p_source=>'COST_CENTER'
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
 p_id=>wwv_flow_api.id(49433168128265089)
,p_name=>'P98_BUDGET_GROUB_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(49198890159443396)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Budget Groub Code'
,p_source=>'BUDGET_GROUB_CODE'
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
 p_id=>wwv_flow_api.id(49432820607265088)
,p_name=>'P98_GL_ACCOUNT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(49198890159443396)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'GL Account'
,p_source=>'GL_ACCOUNT'
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
 p_id=>wwv_flow_api.id(49432360285265088)
,p_name=>'P98_ACTIVITY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(49198890159443396)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Activity'
,p_source=>'ACTIVITY'
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
 p_id=>wwv_flow_api.id(49431987511265088)
,p_name=>'P98_FUTURE1'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(49198890159443396)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Future1'
,p_source=>'FUTURE1'
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
 p_id=>wwv_flow_api.id(49431629701265088)
,p_name=>'P98_FUTURE2'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(49198890159443396)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Future2'
,p_source=>'FUTURE2'
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
 p_id=>wwv_flow_api.id(49431202817265088)
,p_name=>'P98_PROJECT_NUMBER_NEW'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>770
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_source=>'PROJECT_NUMBER_NEW'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49430831934265087)
,p_name=>'P98_TASK_NUMBER_NEW'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>780
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_source=>'TASK_NUMBER_NEW'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49430372472265087)
,p_name=>'P98_EXPENDITURE_TYPE_NEW'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>790
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_source=>'EXPENDITURE_TYPE_NEW'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49429933262265087)
,p_name=>'P98_COST_CENTER_NEW'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>800
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_source=>'COST_CENTER_NEW'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49429627051265087)
,p_name=>'P98_BUDGET_GROUB_CODE_NEW'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>810
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_source=>'BUDGET_GROUB_CODE_NEW'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49429182511265087)
,p_name=>'P98_GL_ACCOUNT_NEW'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>820
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_source=>'GL_ACCOUNT_NEW'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49428791213265086)
,p_name=>'P98_ACTIVITY_NEW'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>830
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_source=>'ACTIVITY_NEW'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49428389856265086)
,p_name=>'P98_FUTURE1_NEW'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>840
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_source=>'FUTURE1_NEW'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49428019340265086)
,p_name=>'P98_FUTURE2_NEW'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>850
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_source=>'FUTURE2_NEW'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49427624137265086)
,p_name=>'P98_IT_BUDGET_RELATED_COST_CENTER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(48942169493033319)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'IT Budget Related Cost Center'
,p_source=>'IT_BUDGET_RELATED_COST_CENTER'
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
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49427220428265083)
,p_name=>'P98_OBJECTIVE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(48942009170033317)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_source=>'OBJECTIVE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49426748818265083)
,p_name=>'P98_PROGRAM_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(48942009170033317)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_source=>'PROGRAM_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49426373045265083)
,p_name=>'P98_INITIATIVE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(48942009170033317)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Initiative'
,p_source=>'INITIATIVE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'INITIATIVES POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select INITIATIVE_ID, INITIATIVE_CODE, INITIATIVE_NAME, ',
'    decode(INITIATIVE_TYPE, ''S'' , ''Strategic'' , ''N'', ''Non-Strategic'') INITIATIVE_TYPE',
'from strategic_initiatives;'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49425990768265083)
,p_name=>'P98_PROJECT_DESCRIPTION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(49436688906265095)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Project Description'
,p_source=>'PROJECT_DESCRIPTION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>4000
,p_cHeight=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49425562042265083)
,p_name=>'P98_OUTCOME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(48942009170033317)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Outcome'
,p_source=>'OUTCOME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>4000
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49425144197265082)
,p_name=>'P98_START_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(49436688906265095)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Start Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'START_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49424810300265082)
,p_name=>'P98_END_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(49436688906265095)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'End Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'END_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49424403057265082)
,p_name=>'P98_BP_EXPENSE_CATEGORY_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(48942317765033320)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Expense Category '
,p_source=>'BP_EXPENSE_CATEGORY_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'BP EXPENSE CATEGORY'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    value,',
'    value_id',
'FROM',
'    dct_lookup_values',
'WHERE',
'        lookup_id = (',
'            SELECT',
'                l.lookup_id',
'            FROM',
'                dct_lookups l',
'            WHERE',
'                l.lookup_code = ''BP_EXPENSE_CATEGORIES''',
'        )',
'    AND status = ''A''',
'    AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p><strong><span style="color: #0000ff;">BAU:</span> </strong>Continous operation project / strategic.</p>',
'<p><strong><span style="color: #0000ff;">New Project:</span></strong> Any new proposed project that is not part of previous years.</p>',
'<p><span style="color: #0000ff;"><strong>New Proposed Event:</strong></span> Any new proposed project that is not part of previous years.</p>',
'<p><strong><span style="color: #0000ff;">Operation:</span></strong> operational projects Running cost like FM, IT , HR&hellip;.</p>',
'<p><span style="color: #0000ff;"><strong>Resolution:</strong></span> Any project committed by ADEO circular.</p>'))
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49423960824265082)
,p_name=>'P98_BP_EXPENSE_CLASS_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(48942317765033320)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Expense Class'
,p_source=>'BP_EXPENSE_CLASS_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'BP EXPENSE CLASSES'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    value,',
'    value_id',
'FROM',
'    dct_lookup_values',
'WHERE',
'        lookup_id = (',
'            SELECT',
'                l.lookup_id',
'            FROM',
'                dct_lookups l',
'            WHERE',
'                l.lookup_code = ''BP_EXPENSE_CLASSES''',
'        )',
'    AND status = ''A''',
'    AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49423615053265082)
,p_name=>'P98_BP_COMMITMENT_TYPE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(48942317765033320)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Commitment Type'
,p_source=>'BP_COMMITMENT_TYPE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'BP COMMITMENT TYPES'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    value,',
'    value_id',
'FROM',
'    dct_lookup_values',
'WHERE',
'        lookup_id = (',
'            SELECT',
'                l.lookup_id',
'            FROM',
'                dct_lookups l',
'            WHERE',
'                l.lookup_code = ''BP_COMMITMENT_TYPES''',
'        )',
'    AND status = ''A''',
'    AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p><strong><span style="color: #0000ff;">Committed by Resolution: </span></strong><span style="color: #000000;">Decree issued by H.H the ruler of Abu Dhabi / H.H the Crown Prince of Abu Dhabi/ Executive council &amp; committee.</span></p>',
'<p><strong><span style="color: #0000ff;">Committed by Contract: </span></strong>Expenses that are obligated by contracts, agreements or resolutions of the competent authorities or it is nature as commitment to pay, this expense is necessary to the en'
||'tity.&nbsp;</p>',
'<p><strong><span style="color: #0000ff;">Un-specified:</span></strong> Expenditures which are not yet identified but entity wish to incur such expense are to be included.</p>'))
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49423214519265082)
,p_name=>'P98_BP_CLASSIFICATIONS_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(48942317765033320)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Classifications'
,p_source=>'BP_CLASSIFICATIONS_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'BP CLASSIFICATIONS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    value,',
'    value_id',
'FROM',
'    dct_lookup_values',
'WHERE',
'        lookup_id = (',
'            SELECT',
'                l.lookup_id',
'            FROM',
'                dct_lookups l',
'            WHERE',
'                l.lookup_code = ''BP_CLASSIFICATIONS''',
'        )',
'    AND status = ''A''',
'    AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p><strong><span style="color: #0000ff;">Non-Recurrent: </span></strong>Expenditure related to a specific period and not continuing.</p>',
'<p>Ex: Resolution issued to organize events for one year/ or two years.&nbsp;</p>',
'<p><strong><span style="color: #0000ff;">Recurrent:</span></strong> The continuous expenditure that has annual nature</p>',
'<p>Ex: - Water and electricity expenses.</p>',
'<p>&nbsp; &nbsp; &nbsp; - Security/ cleaning.</p>'))
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49422808456265081)
,p_name=>'P98_COST_DRIVER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(48942169493033319)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Cost Driver'
,p_source=>'COST_DRIVER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>4000
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49422406429265081)
,p_name=>'P98_COST_DRIVER_UOM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(48942169493033319)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Cost Driver - UOM'
,p_source=>'COST_DRIVER_UOM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>1000
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49421944203265081)
,p_name=>'P98_COST_DRIVER_QUANTITY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(48942169493033319)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Cost Driver- Quantity'
,p_source=>'COST_DRIVER_QUANTITY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>1000
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49421535844265081)
,p_name=>'P98_COST'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(48942169493033319)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Average Cost'
,p_source=>'COST'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49421134414265081)
,p_name=>'P98_TOTAL_COST'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(48942169493033319)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Total Cost'
,p_source=>'TOTAL_COST'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49420790598265080)
,p_name=>'P98_JUSTIFICATIONS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(48942169493033319)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Justification'
,p_source=>'JUSTIFICATIONS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>4000
,p_cHeight=>2
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49420415145265080)
,p_name=>'P98_CALCULATION_BASIS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(48942169493033319)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Calculation Basis'
,p_source=>'CALCULATION_BASIS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>1000
,p_cHeight=>2
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49420015310265080)
,p_name=>'P98_CEILING_CH1_REQUIRED_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>860
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_source=>'CEILING_CH1_REQUIRED_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49419537916265080)
,p_name=>'P98_CEILING_CH1_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>870
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_source=>'CEILING_CH1_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49419212077265080)
,p_name=>'P98_CEILING_CH2_REQUIRED_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>880
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_source=>'CEILING_CH2_REQUIRED_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49418831981265079)
,p_name=>'P98_CEILING_CH2_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>890
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_source=>'CEILING_CH2_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49418399480265079)
,p_name=>'P98_CEILING_CH3_REQUIRED_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>900
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_source=>'CEILING_CH3_REQUIRED_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49417959644265079)
,p_name=>'P98_CEILING_CH3_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>910
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_source=>'CEILING_CH3_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49417536112265079)
,p_name=>'P98_CEILING_CH6_REQUIRED_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>920
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_source=>'CEILING_CH6_REQUIRED_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49417178086265079)
,p_name=>'P98_CEILING_CH6_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>930
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_source=>'CEILING_CH6_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49416750647265079)
,p_name=>'P98_ALLOW_ADD_TASK_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>940
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_source=>'ALLOW_ADD_TASK_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49416429803265078)
,p_name=>'P98_COMMENTS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(48942169493033319)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Comment'
,p_source=>'COMMENTS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>4000
,p_cHeight=>2
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49415992119265078)
,p_name=>'P98_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(49436688906265095)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Status'
,p_source=>'STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_tag_css_classes=>'u-color-4'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49415536640265078)
,p_name=>'P98_PLAN_VERSION'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_source=>'PLAN_VERSION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49415133868265078)
,p_name=>'P98_BUDGET_Y1'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(48941816725033315)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Budget &P98_AB1.'
,p_post_element_text=>'<p><span style="color: #000000;">&nbsp;AED</span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'BUDGET_Y1'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_tag_css_classes=>'u-color-4-bg'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49414737908265078)
,p_name=>'P98_BUDGET_Y2'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>520
,p_item_plug_id=>wwv_flow_api.id(48941877605033316)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Budget &P98_AB2.'
,p_post_element_text=>'<p><span style="color: #000000;">&nbsp;AED</span></p>'
,p_source=>'BUDGET_Y2'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(99818276588410779)
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
 p_id=>wwv_flow_api.id(49414419531265077)
,p_name=>'P98_BUDGET_Y3'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>530
,p_item_plug_id=>wwv_flow_api.id(48941877605033316)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Budget &P98_AB3.'
,p_post_element_text=>'<p><span style="color: #000000;">&nbsp;AED</span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'BUDGET_Y3'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49413956027265077)
,p_name=>'P98_BUDGET_Y4'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>540
,p_item_plug_id=>wwv_flow_api.id(48941877605033316)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Budget &P98_AB4.'
,p_post_element_text=>'<p><span style="color: #000000;">&nbsp;AED</span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'BUDGET_Y4'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49413626823265077)
,p_name=>'P98_BUDGET_Y5'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>550
,p_item_plug_id=>wwv_flow_api.id(48941877605033316)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Budget &P98_AB5.'
,p_post_element_text=>'<p><span style="color: #000000;">&nbsp;AED</span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'BUDGET_Y5'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49413168748265077)
,p_name=>'P98_JAN'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(48941816725033315)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'01-&P98_PROPOSAL_YEAR.'
,p_post_element_text=>'<p><span style="color: #000000;">&nbsp;AED</span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'JAN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49412769506265077)
,p_name=>'P98_FEB'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(48941816725033315)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'02-&P98_PROPOSAL_YEAR.'
,p_post_element_text=>'<p><span style="color: #000000;">&nbsp;AED</span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'FEB'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49412332620265077)
,p_name=>'P98_MAR'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(48941816725033315)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'03-&P98_PROPOSAL_YEAR.'
,p_post_element_text=>'<p><span style="color: #000000;">&nbsp;AED</span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'MAR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49411992718265076)
,p_name=>'P98_APR'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(48941816725033315)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'04-&P98_PROPOSAL_YEAR.'
,p_post_element_text=>'<p><span style="color: #000000;">&nbsp;AED</span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'APR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49411556696265076)
,p_name=>'P98_MAY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(48941816725033315)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'05-&P98_PROPOSAL_YEAR.'
,p_post_element_text=>'<p><span style="color: #000000;">&nbsp;AED</span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'MAY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49411167189265076)
,p_name=>'P98_JUN'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(48941816725033315)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'06-&P98_PROPOSAL_YEAR.'
,p_post_element_text=>'<p><span style="color: #000000;">&nbsp;AED</span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'JUN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49410767182265076)
,p_name=>'P98_JUL'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(48941816725033315)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'07-&P98_PROPOSAL_YEAR.'
,p_post_element_text=>'<p><span style="color: #000000;">&nbsp;AED</span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'JUL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49410419385265076)
,p_name=>'P98_AUG'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(48941816725033315)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'08-&P98_PROPOSAL_YEAR.'
,p_post_element_text=>'<p><span style="color: #000000;">&nbsp;AED</span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'AUG'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49409956765265075)
,p_name=>'P98_SEP'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(48941816725033315)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'09-&P98_PROPOSAL_YEAR.'
,p_post_element_text=>'<p><span style="color: #000000;">&nbsp;AED</span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'SEP'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49409575866265075)
,p_name=>'P98_OCT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(48941816725033315)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'10-&P98_PROPOSAL_YEAR.'
,p_post_element_text=>'<p><span style="color: #000000;">&nbsp;AED</span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'OCT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49409217830265075)
,p_name=>'P98_NOV'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(48941816725033315)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'11-&P98_PROPOSAL_YEAR.'
,p_post_element_text=>'<p><span style="color: #000000;">&nbsp;AED</span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'NOV'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49408797280265075)
,p_name=>'P98_DEC'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(48941816725033315)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'12-&P98_PROPOSAL_YEAR.'
,p_post_element_text=>'<p><span style="color: #000000;">&nbsp;AED</span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'DEC'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49408421688265075)
,p_name=>'P98_SUBMITTED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(49436688906265095)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'SUBMITTED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_display_when=>'P98_STATUS'
,p_display_when2=>'Draft'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49407563703265074)
,p_name=>'P98_SUBMITTED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(49436688906265095)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_source=>'SUBMITTED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_display_when=>'P98_STATUS'
,p_display_when2=>'Draft'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49407202001265074)
,p_name=>'P98_CREATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>610
,p_item_plug_id=>wwv_flow_api.id(49198952851443397)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Created By'
,p_source=>'CREATED_BY'
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
 p_id=>wwv_flow_api.id(49406762032265074)
,p_name=>'P98_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>620
,p_item_plug_id=>wwv_flow_api.id(49198952851443397)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Created On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49405974150265073)
,p_name=>'P98_UPDATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>630
,p_item_plug_id=>wwv_flow_api.id(49198952851443397)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
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
 p_id=>wwv_flow_api.id(49405567586265073)
,p_name=>'P98_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>640
,p_item_plug_id=>wwv_flow_api.id(49198952851443397)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Updated On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49279766923009331)
,p_name=>'P98_ACTUAL_Y3'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>480
,p_item_plug_id=>wwv_flow_api.id(48941877605033316)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Actual &P98_AY3.'
,p_post_element_text=>'<p><span style="color: #000000;">&nbsp;AED</span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'ACTUAL_Y3'
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
 p_id=>wwv_flow_api.id(49279689560009330)
,p_name=>'P98_ACTUAL_Y4'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>470
,p_item_plug_id=>wwv_flow_api.id(48941877605033316)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Actual &P98_AY4.'
,p_post_element_text=>'<p><span style="color: #000000;">&nbsp;AED</span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'ACTUAL_Y4'
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
 p_id=>wwv_flow_api.id(49279631148009329)
,p_name=>'P98_ACTUAL_Y5'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>460
,p_item_plug_id=>wwv_flow_api.id(48941877605033316)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Actual &P98_AY5.'
,p_post_element_text=>'<p><span style="color: #000000;">&nbsp;AED</span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'ACTUAL_Y5'
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
 p_id=>wwv_flow_api.id(49199178914443399)
,p_name=>'P98_PROJECT_NAME'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Project Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49198797897443395)
,p_name=>'P98_PROPOSAL_YEAR'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(49436688906265095)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49198536888443393)
,p_name=>'P98_AY1'
,p_item_sequence=>950
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49198483168443392)
,p_name=>'P98_AY2'
,p_item_sequence=>960
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49198362266443391)
,p_name=>'P98_AY3'
,p_item_sequence=>970
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49198275377443390)
,p_name=>'P98_AY4'
,p_item_sequence=>980
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49198209296443389)
,p_name=>'P98_AY5'
,p_item_sequence=>990
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49198036117443388)
,p_name=>'P98_AB1'
,p_item_sequence=>1000
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49198021034443387)
,p_name=>'P98_AB2'
,p_item_sequence=>1010
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49197885966443386)
,p_name=>'P98_AB3'
,p_item_sequence=>1020
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49197734427443385)
,p_name=>'P98_AB4'
,p_item_sequence=>1030
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49197710816443384)
,p_name=>'P98_AB5'
,p_item_sequence=>1040
,p_item_plug_id=>wwv_flow_api.id(50228300400855784)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49197557627443383)
,p_name=>'P98_COST_CENTER_NAME'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Cost Center Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49197491573443382)
,p_name=>'P98_PRIORITY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(48942317765033320)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Priority'
,p_source=>'PRIORITY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'PRIORITY LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id',
'from dct_lookup_values',
'where lookup_id = (Select x.lookup_id',
'                    from dct_lookups x',
'                    where x.LOOKUP_CODE = ''PRIORITY'');'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p><strong><span style="color: #0000ff;">High: </span></strong>Committed contracts, Contracts under siganture, AMC, High priroty New Projects, Projects or CR''s that needs payment in 2024, Must to have</p>',
'<p><strong><span style="color: #0000ff;">Medium:</span></strong> Projects or CR''s that is of high priorty but not yet approved by business department</p>',
'<p><span style="color: #0000ff;"><strong>Low:</strong></span> Wishlist projects and not sure of execution in 2024</p>'))
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(48943121358033328)
,p_name=>'P98_DELIVERABLE1'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>360
,p_item_plug_id=>wwv_flow_api.id(48942009170033317)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Deliverable1'
,p_source=>'DELIVERABLE_1'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>1000
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(48942977276033327)
,p_name=>'P98_DELIVERABLE2'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>390
,p_item_plug_id=>wwv_flow_api.id(48942009170033317)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Deliverable2'
,p_source=>'DELIVERABLE_2'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>1000
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(48942858095033326)
,p_name=>'P98_DELIVERABLE3'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>420
,p_item_plug_id=>wwv_flow_api.id(48942009170033317)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Deliverable3'
,p_source=>'DELIVERABLE_3'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>1000
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(48942776102033325)
,p_name=>'P98_TRAGET1'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>370
,p_item_plug_id=>wwv_flow_api.id(48942009170033317)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Target 1'
,p_source=>'TRAGET_1'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(48942716334033324)
,p_name=>'P98_TRAGET2'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>400
,p_item_plug_id=>wwv_flow_api.id(48942009170033317)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Target 2'
,p_source=>'TARGET_2'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(48942564772033323)
,p_name=>'P98_TRAGET3'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>430
,p_item_plug_id=>wwv_flow_api.id(48942009170033317)
,p_item_source_plug_id=>wwv_flow_api.id(49436688906265095)
,p_prompt=>'Target 3'
,p_source=>'TRAGET_3'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(43740893763643629)
,p_name=>'P98_PAGE_FROM'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(49436688906265095)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38671395929493987)
,p_name=>'P98_PLAN_ID_H'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(49436688906265095)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38622125288086629)
,p_name=>'P98_CC_PLAN_ID_H'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(49436688906265095)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(49407873296265074)
,p_validation_name=>'P98_SUBMITTED_ON must be timestamp'
,p_validation_sequence=>700
,p_validation=>'P98_SUBMITTED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(49408421688265075)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(49406321124265074)
,p_validation_name=>'P98_CREATED_ON must be timestamp'
,p_validation_sequence=>730
,p_validation=>'P98_CREATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(49406762032265074)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(49405035322265073)
,p_validation_name=>'P98_UPDATED_ON must be timestamp'
,p_validation_sequence=>750
,p_validation=>'P98_UPDATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(49405567586265073)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(48943217552033329)
,p_validation_name=>'Check Proposal Budget Cashflow distribution'
,p_validation_sequence=>760
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
' to_number(replace(nvl(:P98_BUDGET_Y1,0),'','','''')) = (',
'                     to_number(replace(nvl(:P98_JAN,0),'','',''''))  +',
'                     to_number(replace(nvl(:P98_FEB,0),'','',''''))  +',
'                     to_number(replace(nvl(:P98_MAR,0),'','',''''))  +',
'                     to_number(replace(nvl(:P98_APR,0),'','',''''))  +',
'                     to_number(replace(nvl(:P98_MAY,0),'','',''''))  +',
'                     to_number(replace(nvl(:P98_JUN,0),'','',''''))  +',
'                     to_number(replace(nvl(:P98_JUL,0),'','',''''))  +',
'                     to_number(replace(nvl(:P98_AUG,0),'','',''''))  +',
'                     to_number(replace(nvl(:P98_SEP,0),'','',''''))  +',
'                     to_number(replace(nvl(:P98_OCT,0),'','',''''))  +',
'                     to_number(replace(nvl(:P98_NOV,0),'','',''''))  +',
'                     to_number(replace(nvl(:P98_DEC,0),'','',''''))  ',
'                      )'))
,p_validation_type=>'PLSQL_EXPRESSION'
,p_error_message=>'Total Cashflow must be equal to Budget &P98_PROPOSAL_YEAR.'
,p_when_button_pressed=>wwv_flow_api.id(49380771878265061)
,p_associated_item=>wwv_flow_api.id(49415133868265078)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(38619519635086603)
,p_name=>'New_COMMENT DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(38619733313086606)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(38619398211086602)
,p_event_id=>wwv_flow_api.id(38619519635086603)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(38622180775086630)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(38619252994086601)
,p_name=>'Collaborations Report DA'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(38622180775086630)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(38619177687086600)
,p_event_id=>wwv_flow_api.id(38619252994086601)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(38622180775086630)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(49379170016265059)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(49436688906265095)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Budget Proposal - Project'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(49379626063265060)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(49436688906265095)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Budget Proposal - Project'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(49199127737443398)
,p_process_sequence=>20
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get Display items'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    projects_util.project_name(:p98_project_number),',
'    budget_proposal_pkg.proposal_year(:p98_plan_id),',
'    user_details.get_cost_center_name(:P98_COST_CENTER)',
'INTO',
'    :p98_project_name,',
'    :p98_proposal_year,',
'    :P98_COST_CENTER_NAME',
'FROM',
'    dual;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(49198693452443394)
,p_process_sequence=>30
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'set years Labels'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P98_AY1 := :P98_PROPOSAL_YEAR - 1;',
':P98_AY2 := :P98_PROPOSAL_YEAR - 2;',
':P98_AY3 := :P98_PROPOSAL_YEAR - 3;',
':P98_AY4 := :P98_PROPOSAL_YEAR - 4;',
':P98_AY5 := :P98_PROPOSAL_YEAR - 5;',
':P98_AB1 := :P98_PROPOSAL_YEAR ;',
':P98_AB2 := :P98_PROPOSAL_YEAR + 1;',
':P98_AB3 := :P98_PROPOSAL_YEAR + 2;',
':P98_AB4 := :P98_PROPOSAL_YEAR + 3;',
':P98_AB5 := :P98_PROPOSAL_YEAR + 4;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
