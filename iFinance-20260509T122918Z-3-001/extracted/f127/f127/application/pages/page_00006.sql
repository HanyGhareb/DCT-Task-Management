prompt --application/pages/page_00006
begin
--   Manifest
--     PAGE: 00006
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>116
,p_default_id_offset=>191955104108672310
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>6
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Bank Guarantee Approve/Reject'
,p_alias=>'BANK-GUARANTEE-APPROVE-REJECT'
,p_step_title=>'Bank Guarantee Approve/Reject'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'ALWAYS'
,p_last_updated_by=>'TCA899'
,p_last_upd_yyyymmddhh24miss=>'20230930074826'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(192910480629730409)
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(192911088191730557)
,p_plug_name=>'Bank Guarantee Details'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'BANK_GUARANTEE_ALL'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_read_only_when_type=>'PLSQL_EXPRESSION'
,p_plug_read_only_when=>':P6_RECEIVING_STATUS not in (''Draft'' , ''Withdraw'' )'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(192884074614663078)
,p_plug_name=>'Audit'
,p_parent_plug_id=>wwv_flow_api.id(192911088191730557)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P6_BG_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(192885393259663091)
,p_plug_name=>'Detail-L'
,p_parent_plug_id=>wwv_flow_api.id(192911088191730557)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(192885468077663092)
,p_plug_name=>'Detail-R'
,p_parent_plug_id=>wwv_flow_api.id(192911088191730557)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(192886388393663101)
,p_plug_name=>'Summary'
,p_parent_plug_id=>wwv_flow_api.id(192911088191730557)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--accent1:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>40
,p_plug_new_grid_row=>false
,p_plug_display_column=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(192886610095663103)
,p_plug_name=>'Details - buttom'
,p_parent_plug_id=>wwv_flow_api.id(192911088191730557)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(192886671183663104)
,p_plug_name=>'Documents'
,p_parent_plug_id=>wwv_flow_api.id(192911088191730557)
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>70
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P6_BG_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(192886911246663106)
,p_plug_name=>'Documents report'
,p_parent_plug_id=>wwv_flow_api.id(192886671183663104)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ROW_VERSION_NUMBER,',
'       BG_ID,',
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
'  from bank_guarantee_all_documents',
'  where BG_ID = :P6_BG_ID',
'  order by UPDATED desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P6_BG_ID'
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
 p_id=>wwv_flow_api.id(192886998268663107)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>384842102377335417
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(781388793287304)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(781709732287304)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Document Version Number'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(782166669287304)
,p_db_column_name=>'BG_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Bg Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(782561938287305)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'File Name'
,p_column_link=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::P3_PAGE_FROM,P3_RECEIVING_STATUS,P3_RELEASE_STATUS,P3_ID:2,&P2_RECEIVING_STATUS.,&P2_RELEASE_STATUS.,#ID#'
,p_column_linktext=>'#FILENAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(782947047287305)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(783299937287305)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(783759233287305)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(784158639287306)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(784555834287306)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(784923938287306)
,p_db_column_name=>'CREATED'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Created ON'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(785382585287306)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(9456343038697)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(785721747287306)
,p_db_column_name=>'UPDATED'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Updated ON'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(786130045287307)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(9456343038697)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(786583836287307)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(786926445287307)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DOWNLOAD:BANK_GUARANTEE_ALL_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(193412433767595824)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1927424'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:ROW_VERSION_NUMBER:FILE_COMMENTS:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(193401004925501573)
,p_plug_name=>'Approval History'
,p_parent_plug_id=>wwv_flow_api.id(192911088191730557)
,p_icon_css_classes=>'fa-users'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent13:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>80
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_plug_display_when_condition=>'P6_RECEIVING_STATUS'
,p_plug_display_when_cond2=>'Draft'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(193401071071501574)
,p_plug_name=>'Approval History Report'
,p_parent_plug_id=>wwv_flow_api.id(193401004925501573)
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
'       e.full_name_en,',
'    case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'       when 0  THEN',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'        else  ',
'            ',
'         ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'       end Photo',
'FROM',
'    bank_guarantee_all_approval_history h, dct_employees_list2  e',
'where h.person_id = e.person_id (+)',
'and h.request_id = :P6_BG_ID',
'and h.status != ''Bateen''',
'order by h.STEP_NO ',
'--, h.ID',
';'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P6_BG_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Approval History Report'
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
 p_id=>wwv_flow_api.id(193401169087501575)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>385356273196173885
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(788318057287312)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(788744812287312)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(789115050287312)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(789553716287312)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(789932436287312)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Role'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(15157168038702)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(790334520287313)
,p_db_column_name=>'ROLE_DESC'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Role Desc'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(790761285287313)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(791135697287313)
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
 p_id=>wwv_flow_api.id(791524845287313)
,p_db_column_name=>'STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(791936070287314)
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
 p_id=>wwv_flow_api.id(792353394287314)
,p_db_column_name=>'COMMENTS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(792697283287314)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(793173668287314)
,p_db_column_name=>'STATUS_CLASS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Status Class'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(793504850287314)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(793937808287315)
,p_db_column_name=>'PHOTO'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(193422936230644128)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1927494'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:PHOTO:FULL_NAME_EN:ROLE_ID:ACTION_REQUIRED:RECEVIED_DATE:STATUS:ACTION_DATE:COMMENTS:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(820581781450751)
,p_report_id=>wwv_flow_api.id(193422936230644128)
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
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(758959944287276)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(192910480629730409)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(780644215287299)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(192886671183663104)
,p_button_name=>'New_document'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'New Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:3:P3_BG_ID,P3_PAGE_FROM,P3_RECEIVING_STATUS,P3_RELEASE_STATUS:&P6_BG_ID.,2,&P6_RECEIVING_STATUS.,&P6_RELEASE_STATUS.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(748604730105311)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(192910480629730409)
,p_button_name=>'Approve'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Approve'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:5:P5_ACTION,P5_REQUEST_ID:Approve,&P6_BG_ID.'
,p_icon_css_classes=>'fa-thumbs-o-up'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(748818792105313)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(192910480629730409)
,p_button_name=>'Reject'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--danger:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Reject'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:5:P5_ACTION,P5_REQUEST_ID:Reject,&P6_BG_ID.'
,p_icon_css_classes=>'fa-thumbs-o-down'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(748988722105314)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(192910480629730409)
,p_button_name=>'Delegate'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Delegate'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:5:P5_ACTION,P5_REQUEST_ID:Delegate,&P6_BG_ID.'
,p_icon_css_classes=>'fa-sign-language'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(749056595105315)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(192910480629730409)
,p_button_name=>'Return'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Return'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:5:P5_ACTION,P5_REQUEST_ID:Return,&P6_BG_ID.'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(810672949287328)
,p_branch_name=>'Go to Submit 4 - Receiving'
,p_branch_action=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:4:P4_BG_ID,P4_APPROVAL_TYPE_ID:&P6_BG_ID.,241&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(811048307287328)
,p_branch_name=>'Go to Submit 4 - Release'
,p_branch_action=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:4:P4_BG_ID,P4_APPROVAL_TYPE_ID:&P6_BG_ID.,242&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(810281213287327)
,p_branch_name=>'Go To Page 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>30
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(748795213105312)
,p_name=>'P6_HISTORY_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(192910480629730409)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_source=>'BG_YEAR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(762054198287284)
,p_name=>'P6_BG_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(192910480629730409)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_source=>'BG_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(762464146287286)
,p_name=>'P6_COUNT_YEAR'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(192910480629730409)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_source=>'COUNT_YEAR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(762820850287286)
,p_name=>'P6_BG_YEAR'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(192910480629730409)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_source=>'BG_YEAR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(764316431287287)
,p_name=>'P6_CREATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>370
,p_item_plug_id=>wwv_flow_api.id(192884074614663078)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
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
 p_id=>wwv_flow_api.id(764779886287288)
,p_name=>'P6_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>380
,p_item_plug_id=>wwv_flow_api.id(192884074614663078)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
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
 p_id=>wwv_flow_api.id(765149406287288)
,p_name=>'P6_UPDATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>390
,p_item_plug_id=>wwv_flow_api.id(192884074614663078)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
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
 p_id=>wwv_flow_api.id(765518157287288)
,p_name=>'P6_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>400
,p_item_plug_id=>wwv_flow_api.id(192884074614663078)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
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
 p_id=>wwv_flow_api.id(766293078287289)
,p_name=>'P6_BG_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(192885393259663091)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_prompt=>'Bank Guarantee Code'
,p_source=>'BG_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(766652849287289)
,p_name=>'P6_BG_NO'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(192885393259663091)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_prompt=>'Bank Guarantee No'
,p_source=>'BG_NO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>128
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(766998185287289)
,p_name=>'P6_BG_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(192885393259663091)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_prompt=>'Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'BG_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(767442215287289)
,p_name=>'P6_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(192885393259663091)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_prompt=>'Amount'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
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
,p_default_application_id=>116
,p_default_id_offset=>191955104108672310
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(767855327287290)
,p_name=>'P6_CURRENCY'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(192885393259663091)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_item_default=>'AED'
,p_prompt=>'Currency'
,p_source=>'CURRENCY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'CURRENCY LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value  d , value r',
'from dct_lookup_values',
'where lookup_id = 11'))
,p_cHeight=>1
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(768271986287290)
,p_name=>'P6_VENDOR_NAME'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(192885393259663091)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_prompt=>'Vendor Name'
,p_source=>'VENDOR_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'VENDORS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select vendors.vendor_name , Vendor_site_code , vendor_number',
'from vendors',
'where vendor_site_status = ''Active'''))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_10=>'VENDOR_NUMBER:P6_VENDOR_NUMBER,VENDOR_SITE_CODE:P6_VENDOR_SITE_CODE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(768651427287291)
,p_name=>'P6_VENDOR_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(192885393259663091)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_prompt=>'Vendor Number'
,p_source=>'VENDOR_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>50
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(769020781287291)
,p_name=>'P6_VENDOR_SITE_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(192885393259663091)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_prompt=>'Vendor Site Code'
,p_source=>'VENDOR_SITE_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>50
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(769424587287291)
,p_name=>'P6_BANK_NAME'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(192885393259663091)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_prompt=>'Bank Name'
,p_source=>'BANK_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'BANKS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select BANK_NAME d, BANK_NAME r ',
'from banks',
'order by 1'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(769885147287291)
,p_name=>'P6_CONTRACT_NUM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(192885393259663091)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_prompt=>'Contract Number'
,p_source=>'CONTRACT_NUM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(770274904287292)
,p_name=>'P6_PO_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(192885393259663091)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_prompt=>'PO Number'
,p_source=>'PO_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>12
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(770984380287292)
,p_name=>'P6_BG_TYPE_ID'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(192885468077663092)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_prompt=>'Bank Guarantee Type'
,p_source=>'BG_TYPE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'BANK GUARANTEE TYPES LOV'
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
'                l.lookup_code = ''BANK_GUARANTEE_TYPE''',
'        )',
'    AND status = ''A''',
'    AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(771327997287293)
,p_name=>'P6_END_USER_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(192885468077663092)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_item_default=>'PERSON_ID'
,p_item_default_type=>'ITEM'
,p_prompt=>'End User'
,p_source=>'END_USER_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(771760884287293)
,p_name=>'P6_SECTOR_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(192885468077663092)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_item_default=>'user_details.get_emp_sector_id(:PERSON_ID)'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'Sector'
,p_source=>'SECTOR_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ORGANIZATION NAME RETURN ORG_ID'
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(772150948287294)
,p_name=>'P6_DEPARTMENT_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(192885468077663092)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_item_default=>'user_details.get_director_org_id(:PERSON_ID)'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'Department'
,p_source=>'DEPARTMENT_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ORGANIZATION NAME RETURN ORG_ID'
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(772535463287294)
,p_name=>'P6_ORG_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(192885468077663092)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_item_default=>'EMP_ORG_ID'
,p_item_default_type=>'ITEM'
,p_prompt=>'Organization'
,p_source=>'ORG_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ORGANIZATION NAME RETURN ORG_ID'
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(772897230287294)
,p_name=>'P6_COST_CENTER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(192885468077663092)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_item_default=>'user_details.get_cost_center(:PERSON_ID)'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'Cost Center'
,p_source=>'COST_CENTER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'COST CENTERS WITH NAMES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''('' || COST_CENTER_CODE || '') '' || COST_CENTER_DESCRIPTION Name, COST_CENTER_CODE',
'from(',
'select distinct  COST_CENTER_DESCRIPTION, COST_CENTER_CODE',
'from dct_gl_code_combinations_all',
'order by COST_CENTER_CODE)'))
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(773316164287294)
,p_name=>'P6_PRIORITY_ID'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(192885468077663092)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_prompt=>'Priority'
,p_source=>'PRIORITY_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'PRIORITY LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id',
'from dct_lookup_values',
'where lookup_id = (Select x.lookup_id',
'                    from dct_lookups x',
'                    where x.LOOKUP_CODE = ''PRIORITY'');'))
,p_cHeight=>1
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(774033088287295)
,p_name=>'P6_RECEIVING_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(192886388393663101)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_item_default=>'Draft'
,p_prompt=>'Receiving Status'
,p_source=>'RECEIVING_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(774400835287295)
,p_name=>'P6_RELEASE_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(192886388393663101)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_prompt=>'Release Status'
,p_source=>'RELEASE_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>4
,p_display_when=>'P6_RECEIVING_STATUS'
,p_display_when2=>'Received'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(774865369287295)
,p_name=>'P6_REJECTED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(192886388393663101)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_prompt=>'Rejected By'
,p_source=>'REJECTED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_grid_label_column_span=>4
,p_display_when=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P6_RECEIVING_STATUS = ''Rejected''',
'or',
':P6_RELEASE_STATUS = ''Rejected'''))
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(775219661287296)
,p_name=>'P6_REJECT_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(192886388393663101)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_prompt=>'Reject On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'REJECT_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>4
,p_display_when=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P6_RECEIVING_STATUS = ''Rejected''',
'or',
':P6_RELEASE_STATUS = ''Rejected'''))
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(775652023287296)
,p_name=>'P6_REJECT_REASON'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(192886388393663101)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_prompt=>'Reject Reason'
,p_source=>'REJECT_REASON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>4
,p_display_when=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P6_RECEIVING_STATUS = ''Rejected''',
'or',
':P6_RELEASE_STATUS = ''Rejected'''))
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(776013210287297)
,p_name=>'P6_SUBMIT_RECEIVE_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(192886388393663101)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_prompt=>'Submit Receive By'
,p_source=>'SUBMIT_RECEIVE_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_grid_label_column_span=>4
,p_display_when=>':P6_RECEIVING_STATUS = ''in-Progress'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(776448754287297)
,p_name=>'P6_SUBMIT_RECEIVE_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(192886388393663101)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_prompt=>'Submit Receive ON'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'SUBMIT_RECEIVE_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>4
,p_display_when=>':P6_RECEIVING_STATUS = ''in-Progress'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(776884852287297)
,p_name=>'P6_FINAL_RECEIVE_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(192886388393663101)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_prompt=>'Final Receive ON'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'FINAL_RECEIVE_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>4
,p_display_when=>':P6_RECEIVING_STATUS = ''Received'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(777262290287297)
,p_name=>'P6_SUBMIT_RELEASE_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_api.id(192886388393663101)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_prompt=>'Submit Release By'
,p_source=>'SUBMIT_RELEASE_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_grid_label_column_span=>4
,p_display_when=>':P6_RELEASE_STATUS not in (''Draft'' , ''Return'' , null)'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(777633634287297)
,p_name=>'P6_SUBMIT_RELEASE_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>320
,p_item_plug_id=>wwv_flow_api.id(192886388393663101)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_prompt=>'Submit Release ON'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'SUBMIT_RELEASE_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>4
,p_display_when=>':P6_RELEASE_STATUS not in (''Draft'' , ''Return'' , null)'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(778012044287298)
,p_name=>'P6_FINAL_RELEASE_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>330
,p_item_plug_id=>wwv_flow_api.id(192886388393663101)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_prompt=>'Final Release ON'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'FINAL_RELEASE_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>4
,p_display_when=>':P6_RELEASE_STATUS = ''Released'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(778401273287298)
,p_name=>'P6_CANCEL_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>340
,p_item_plug_id=>wwv_flow_api.id(192886388393663101)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_prompt=>'Cancel On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CANCEL_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>4
,p_display_when=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P6_RECEIVING_STATUS = ''Cancelled''',
'or',
':P6_RELEASE_STATUS = ''Cancelled'''))
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(778893764287298)
,p_name=>'P6_CANCELLED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>350
,p_item_plug_id=>wwv_flow_api.id(192886388393663101)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_prompt=>'Cancelled By'
,p_source=>'CANCELLED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_grid_label_column_span=>4
,p_display_when=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P6_RECEIVING_STATUS = ''Cancelled''',
'or',
':P6_RELEASE_STATUS = ''Cancelled'''))
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(779227178287298)
,p_name=>'P6_CANCEL_REASON'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>360
,p_item_plug_id=>wwv_flow_api.id(192886388393663101)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_prompt=>'Cancel Reason'
,p_source=>'CANCEL_REASON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>4
,p_display_when=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P6_RECEIVING_STATUS = ''Cancelled''',
'or',
':P6_RELEASE_STATUS = ''Cancelled'''))
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(779958456287299)
,p_name=>'P6_NOTES'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(192886610095663103)
,p_item_source_plug_id=>wwv_flow_api.id(192911088191730557)
,p_prompt=>'Notes'
,p_source=>'NOTES'
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
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(807079294287325)
,p_validation_name=>'P6_REJECT_ON must be timestamp'
,p_validation_sequence=>250
,p_validation=>'P6_REJECT_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(775219661287296)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(807454764287326)
,p_validation_name=>'P6_SUBMIT_RECEIVE_ON must be timestamp'
,p_validation_sequence=>280
,p_validation=>'P6_SUBMIT_RECEIVE_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(776448754287297)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(807886442287326)
,p_validation_name=>'P6_FINAL_RECEIVE_ON must be timestamp'
,p_validation_sequence=>290
,p_validation=>'P6_FINAL_RECEIVE_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(776884852287297)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(808275269287326)
,p_validation_name=>'P6_SUBMIT_RELEASE_ON must be timestamp'
,p_validation_sequence=>310
,p_validation=>'P6_SUBMIT_RELEASE_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(777633634287297)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(808674263287326)
,p_validation_name=>'P6_FINAL_RELEASE_ON must be timestamp'
,p_validation_sequence=>320
,p_validation=>'P6_FINAL_RELEASE_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(778012044287298)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(809076689287326)
,p_validation_name=>'P6_CANCEL_ON must be timestamp'
,p_validation_sequence=>330
,p_validation=>'P6_CANCEL_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(778401273287298)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(809411598287326)
,p_validation_name=>'P6_CREATED_ON must be timestamp'
,p_validation_sequence=>370
,p_validation=>'P6_CREATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(764779886287288)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(809814144287326)
,p_validation_name=>'P6_UPDATED_ON must be timestamp'
,p_validation_sequence=>390
,p_validation=>'P6_UPDATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(765518157287288)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(763602294287287)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(192911088191730557)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Bank Guarantee Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(763209033287286)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(192911088191730557)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Bank Guarantee Details'
);
wwv_flow_api.component_end;
end;
/
