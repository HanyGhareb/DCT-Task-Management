prompt --application/pages/page_00030
begin
--   Manifest
--     PAGE: 00030
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>805
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>30
,p_user_interface_id=>wwv_flow_api.id(36116058293523070)
,p_name=>'Freelancer Details'
,p_alias=>'FREELANCER-DETAILS'
,p_step_title=>'Freelancer Details'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231003111211'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(181719981586785638)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(36040859506523136)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(35977418184523185)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(36094925762523096)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(181720599617785647)
,p_plug_name=>'Main Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(169814523942839033)
,p_plug_name=>'Personal Details'
,p_parent_plug_id=>wwv_flow_api.id(181720599617785647)
,p_icon_css_classes=>'fa-user'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(181672840230656240)
,p_plug_name=>'Personal Details - L'
,p_parent_plug_id=>wwv_flow_api.id(169814523942839033)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>5
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(181800436961060508)
,p_plug_name=>'Audit'
,p_parent_plug_id=>wwv_flow_api.id(181672840230656240)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36014471908523151)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P30_FREELANCER_REQUEST_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(181672965396656241)
,p_plug_name=>'Personal Details - R'
,p_parent_plug_id=>wwv_flow_api.id(169814523942839033)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(169814609109839034)
,p_plug_name=>'Contract Details'
,p_parent_plug_id=>wwv_flow_api.id(181720599617785647)
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(169814747297839035)
,p_plug_name=>'Contract Details - L'
,p_parent_plug_id=>wwv_flow_api.id(169814609109839034)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(169814886798839036)
,p_plug_name=>'Contract Details - R'
,p_parent_plug_id=>wwv_flow_api.id(169814609109839034)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(169815287428839040)
,p_plug_name=>'Attachements'
,p_parent_plug_id=>wwv_flow_api.id(181720599617785647)
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>90
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P30_FREELANCER_REQUEST_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(169815491701839042)
,p_plug_name=>'Documents report'
,p_parent_plug_id=>wwv_flow_api.id(169815287428839040)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(36029582862523142)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ROW_VERSION_NUMBER,',
'       REQUEST_ID,',
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
'  from freelancer_requests_documents',
'  where REQUEST_ID = :P30_FREELANCER_REQUEST_ID',
'  order by UPDATED desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P30_FREELANCER_REQUEST_ID'
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
 p_id=>wwv_flow_api.id(169815515347839043)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>169815515347839043
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169815649694839044)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169815782952839045)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Document Version'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169815801128839046)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169815933728839047)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'File Name'
,p_column_link=>'f?p=&APP_ID.:24:&SESSION.::&DEBUG.::P24_PAGE_FROM,P24_STATUS,P24_ID:30,&P30_STATUS.,#ID#'
,p_column_linktext=>'#FILENAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169816063888839048)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169816166169839049)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169816246088839050)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(193279124817873401)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(193279236236873402)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(193279369621873403)
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
 p_id=>wwv_flow_api.id(193279414880873404)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(181755193271897536)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(193279556329873405)
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
 p_id=>wwv_flow_api.id(193279606086873406)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(181755193271897536)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(193279757384873407)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(193279844372873408)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DOWNLOAD:FREELANCER_REQUESTS_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(193332176090920966)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1933322'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:ROW_VERSION_NUMBER:REQUEST_ID:FILENAME:FILE_MIMETYPE:FILE_CHARSET:FILE_BLOB:FILE_COMMENTS:TAGS:CREATED:CREATED_BY:UPDATED:UPDATED_BY:FILE_SIZE:DOWNLOAD'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(181672619777656238)
,p_plug_name=>'Hidden'
,p_parent_plug_id=>wwv_flow_api.id(181720599617785647)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(181673095273656242)
,p_plug_name=>'Additional Details'
,p_parent_plug_id=>wwv_flow_api.id(181720599617785647)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(181728590056831429)
,p_plug_name=>'Status Overview'
,p_parent_plug_id=>wwv_flow_api.id(181720599617785647)
,p_icon_css_classes=>'fa-info-square-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>40
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>2
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(181729358448831437)
,p_plug_name=>'Security Clearance'
,p_parent_plug_id=>wwv_flow_api.id(181720599617785647)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>70
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P30_SECURITY_CLEARANCE_STATUS not in (''Required'' , ''Not Required'')'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(181730191168831445)
,p_plug_name=>'Service Agreement'
,p_parent_plug_id=>wwv_flow_api.id(181720599617785647)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>80
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P30_SERVICE_AGREEMENT_STATUS not in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(193280258162873412)
,p_plug_name=>'Approval History'
,p_parent_plug_id=>wwv_flow_api.id(181720599617785647)
,p_icon_css_classes=>'fa-users'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent13:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>100
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_plug_display_when_condition=>'P30_STATUS'
,p_plug_display_when_cond2=>'Draft'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(193280303492873413)
,p_plug_name=>'Approval History Report'
,p_parent_plug_id=>wwv_flow_api.id(193280258162873412)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(36029582862523142)
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
'    btf_end_users_req_approval_history h, dct_employees_list2  e',
'where h.person_id = e.person_id (+)',
'and h.request_id = :P30_FREELANCER_REQUEST_ID',
'and h.status != ''Bateen''',
'order by h.STEP_NO ',
'--, h.ID',
';'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P30_FREELANCER_REQUEST_ID'
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
 p_id=>wwv_flow_api.id(193280471968873414)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>193280471968873414
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(193280597736873415)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(193280672927873416)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(193280720916873417)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(193280852536873418)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(193280917125873419)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Role Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(181742380603868399)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(193281000873873420)
,p_db_column_name=>'ROLE_DESC'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Role Desc'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(193281111801873421)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(193281253650873422)
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
 p_id=>wwv_flow_api.id(193281372656873423)
,p_db_column_name=>'STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(193281420686873424)
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
 p_id=>wwv_flow_api.id(193281560814873425)
,p_db_column_name=>'COMMENTS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(193281696988873426)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(193281709109873427)
,p_db_column_name=>'STATUS_CLASS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Status Class'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(193281833872873428)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(193281968640873429)
,p_db_column_name=>'PHOTO'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(193352650683109352)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1933527'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:PHOTO:FULL_NAME_EN:ROLE_ID:ACTION_REQUIRED:RECEVIED_DATE:STATUS:ACTION_DATE:COMMENTS:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(193358719864231574)
,p_report_id=>wwv_flow_api.id(193352650683109352)
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
 p_id=>wwv_flow_api.id(169815316432839041)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(169815287428839040)
,p_button_name=>'New_document'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(36092801396523098)
,p_button_image_alt=>'New Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:24:&SESSION.::&DEBUG.:24:P24_REQUEST_ID,P24_PAGE_FROM,P24_STATUS:&P30_FREELANCER_REQUEST_ID.,30,&P30_STATUS.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(181801181859060515)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(181719981586785638)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(36093683257523097)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(181801286492060516)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(181719981586785638)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(36093683257523097)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P30_FREELANCER_REQUEST_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_icon_css_classes=>'fa-save'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(181801389000060517)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(181719981586785638)
,p_button_name=>'UPDATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(36093683257523097)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P30_FREELANCER_REQUEST_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-save-as'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(193282046607873430)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(181719981586785638)
,p_button_name=>'Submit'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(36093683257523097)
,p_button_image_alt=>'Submit'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>':P30_FREELANCER_REQUEST_ID is not null and :P30_STATUS in (''Draft'',''Withdraw'' , ''Return'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(193282167453873431)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(181719981586785638)
,p_button_name=>'Cancel'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(36093683257523097)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P8_CREATED_BY = :PERSON_ID or',
':P30_STATUS not in (''Draft'' , ''Cancel'' , ''Rejected'')'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(193282269756873432)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(181719981586785638)
,p_button_name=>'Withdraw'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(36093683257523097)
,p_button_image_alt=>'Withdraw'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P8_CREATED_BY = :PERSON_ID ',
'or :P30_STATUS not in (''Cancel'', ''Withdraw'' , ''Draft'' , ''Approved'')'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-undo'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(169814907378839037)
,p_name=>'P30_ORG_ID'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(181673095273656242)
,p_item_default=>'select org_id from employees_v where person_id = :PERSON_ID;'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Organization'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ORGANIZATION NAME RETURN ORG_ID'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181672739369656239)
,p_name=>'P30_FREELANCER_REQUEST_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(181672619777656238)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181673140437656243)
,p_name=>'P30_REQUEST_NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(181672840230656240)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_total_count       number;',
'l_request_no        varchar2(50);',
'BEGIN',
'',
'    -- get total Count By Year',
'        select nvl(max(SEQ),0) + 1',
'        into l_total_count',
'        from FREELANCER_REQUESTS;',
'        ',
'l_request_no := ''FL'' ',
'                || to_char(sysdate, ''yyyymmdd'') || ''/'' ',
'                  || to_char(l_total_count);',
'                  ',
'   return  l_request_no    ;',
'   ',
'end;   '))
,p_item_default_type=>'PLSQL_FUNCTION_BODY'
,p_prompt=>'Request Number'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181673285023656244)
,p_name=>'P30_NEW_FREELANCER_YN'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(181672840230656240)
,p_item_default=>'Y'
,p_prompt=>'New Freelancer ?'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'APPLICATION'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181673368431656245)
,p_name=>'P30_FIRST_NAME'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(181672840230656240)
,p_prompt=>'First Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181673426707656246)
,p_name=>'P30_SECOND_NAME'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(181672840230656240)
,p_prompt=>'Second Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181673529102656247)
,p_name=>'P30_THIRD_NAME'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(181672840230656240)
,p_prompt=>'Third Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181673620282656248)
,p_name=>'P30_LAST_NAME'
,p_is_required=>true
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(181672840230656240)
,p_prompt=>'Last Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>805
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181673712327656249)
,p_name=>'P30_FULL_NAME'
,p_is_required=>true
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(181672840230656240)
,p_prompt=>'Full Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181673821832656250)
,p_name=>'P30_LICENSE_AVAILABLE_YN'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(169814747297839035)
,p_prompt=>'License Available ?'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>5
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'APPLICATION'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181725795065831401)
,p_name=>'P30_LICENSE_EXEMPTION_YN'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(169814747297839035)
,p_prompt=>'License Exemption ?'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>5
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'APPLICATION'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181725801058831402)
,p_name=>'P30_CONTRACT_CLASS'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(169814747297839035)
,p_prompt=>'Contract Class'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'YES_LOV'
,p_lov=>'.'||wwv_flow_api.id(36335922833816959)||'.'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>5
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181725941851831403)
,p_name=>'P30_END_USER_ID'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(181673095273656242)
,p_item_default=>'PERSON_ID'
,p_item_default_type=>'ITEM'
,p_prompt=>'End User'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMP FULL NAME BY PERSON ID LOV'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181726052659831404)
,p_name=>'P30_COST_CENTER'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(181673095273656242)
,p_item_default=>'user_details.get_cost_center(:PERSON_ID)'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'Cost Center'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'COST CENTERS WITH NAMES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''('' || COST_CENTER_CODE || '') '' || COST_CENTER_DESCRIPTION Name, COST_CENTER_CODE',
'from(',
'select distinct  COST_CENTER_DESCRIPTION, COST_CENTER_CODE',
'from dct_gl_code_combinations_all',
'order by COST_CENTER_CODE)'))
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181726115773831405)
,p_name=>'P30_SECTOR_ID'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(181673095273656242)
,p_item_default=>'user_details.get_emp_sector_id(:PERSON_ID)'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'Sector'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ORGANIZATION NAME RETURN ORG_ID'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181726295773831406)
,p_name=>'P30_CONVERSION_ID'
,p_is_required=>true
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(169814747297839035)
,p_prompt=>'Conversion'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'FL_CONVSERTION'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id',
'from DCT_LOOKUP_VALUES where lookup_id = (select l.lookup_id',
'                                          from dct_lookups l ',
'                                          where l.lookup_code = ''FL_CONVERSION'') ',
'                                          and status = ''A'' ',
'                                          and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10)',
'                                  ;  '))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>5
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181726370347831407)
,p_name=>'P30_LOCATION_ID'
,p_is_required=>true
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(169814747297839035)
,p_prompt=>'Location'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'FL_LOCATIONS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id',
'from DCT_LOOKUP_VALUES where lookup_id = (select l.lookup_id',
'                                          from dct_lookups l ',
'                                          where l.lookup_code = ''FL_LOCATION'') ',
'                                          and status = ''A'' ',
'                                          and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10)',
'                                  ;                                 '))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>5
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181726441803831408)
,p_name=>'P30_LINE_MAANAGER_ID'
,p_is_required=>true
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(181672840230656240)
,p_item_default=>'PERSON_ID'
,p_item_default_type=>'ITEM'
,p_prompt=>'Line Manager'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181726569373831409)
,p_name=>'P30_PROJECT_DESCRIPTION'
,p_is_required=>true
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(181672840230656240)
,p_prompt=>'Project Description'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>2
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181726629945831410)
,p_name=>'P30_CONTRACT_DURATION_ID'
,p_is_required=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(169814747297839035)
,p_prompt=>'Contract Duration'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'FL_CONTRACT_DURATION'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
' select value , value_id ',
' from DCT_LOOKUP_VALUES ',
' where lookup_id = (select l.lookup_id ',
'                    from dct_lookups l ',
'                    where l.lookup_code = ''FL_CONTRACT_DURATION'') ',
'and status = ''A'' ',
'and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10) ',
'order by 2;'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>5
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181726774325831411)
,p_name=>'P30_SECURITY_CLEARANCE_REQUIRED_YN'
,p_is_required=>true
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(169814747297839035)
,p_prompt=>'Security Clearance Required ?'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>5
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'APPLICATION'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181726818378831412)
,p_name=>'P30_IT_REQUIRED_YN'
,p_is_required=>true
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(169814747297839035)
,p_prompt=>'IT Required ?'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>5
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'APPLICATION'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181726998015831413)
,p_name=>'P30_IT_ACCESS_CARD_REQUIRED_YN'
,p_is_required=>true
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(169814747297839035)
,p_prompt=>'Access Card Required ?'
,p_display_as=>'NATIVE_YES_NO'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'APPLICATION'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181727063947831414)
,p_name=>'P30_PASSPORT_NUM'
,p_is_required=>true
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(181672965396656241)
,p_prompt=>'Passport Num'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181727111175831415)
,p_name=>'P30_EMAIL'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(181672965396656241)
,p_prompt=>'Email'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'EMAIL'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181727262265831416)
,p_name=>'P30_MOBILE_NO'
,p_is_required=>true
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(181672965396656241)
,p_prompt=>'Mobile No'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181727335526831417)
,p_name=>'P30_NATIONALITY'
,p_is_required=>true
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(181672965396656241)
,p_prompt=>'Nationality'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'NATIONALITY LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_e_user , desc_e) display ',
'        ,code return ',
'from dct_employees_lookups where lookup_name = ''Nationality Code''',
'order by 1'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181727476564831418)
,p_name=>'P30_ACTIVITIES'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(169814886798839036)
,p_prompt=>'Activities'
,p_display_as=>'NATIVE_CHECKBOX'
,p_named_lov=>'FREELANCERS ACTIVITIES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id ',
'from DCT_LOOKUP_VALUES ',
'where lookup_id = (select l.lookup_id ',
'                    from dct_lookups l ',
'                    where l.lookup_code = ''FLACTIVITES'') ',
'                    and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10)'))
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'1'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181727511602831419)
,p_name=>'P30_OTHER_ACTIVITY'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(169814886798839036)
,p_prompt=>'Other Activity'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181727656284831420)
,p_name=>'P30_PO_BOX'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(181672965396656241)
,p_prompt=>'PO Box'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181727796419831421)
,p_name=>'P30_ADDRESS'
,p_is_required=>true
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(181672965396656241)
,p_prompt=>'Address'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>120
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181727835545831422)
,p_name=>'P30_CITY'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(181672965396656241)
,p_prompt=>'City'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181727978134831423)
,p_name=>'P30_EMIRATE'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(181672965396656241)
,p_prompt=>'Emirate'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181728067265831424)
,p_name=>'P30_COUNTRY'
,p_is_required=>true
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(181672965396656241)
,p_prompt=>'Country'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'COUNTRIES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(DESC_E_USER ,DESC_E ) Country, nvl(DESC_A_USER ,DESC_A ) Country_ar, CODE r',
'from dct_employees_lookups',
'where LOOKUP_NUMBER = 1',
''))
,p_lov_display_null=>'YES'
,p_cSize=>40
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181728148369831425)
,p_name=>'P30_FIRST_DEAL_WITH_DCT'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(169814747297839035)
,p_item_default=>'Y'
,p_prompt=>'First Deal With DCT ?'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>5
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'APPLICATION'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181728273127831426)
,p_name=>'P30_NOTES'
,p_is_required=>true
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(181672840230656240)
,p_prompt=>'Note'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>2
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181728371658831427)
,p_name=>'P30_FL_YEAR'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(181672619777656238)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181728490543831428)
,p_name=>'P30_COUNT_YEAR'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(181672619777656238)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181728669551831430)
,p_name=>'P30_STATUS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(181728590056831429)
,p_item_default=>'Draft'
,p_prompt=>'Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181728790969831431)
,p_name=>'P30_SUBMITTED_ON'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(181728590056831429)
,p_prompt=>'Submitted ON'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>':P30_STATUS not in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(36092643254523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181728897498831432)
,p_name=>'P30_SUBMITTED_BY'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(181728590056831429)
,p_prompt=>'Submitted By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMP FULL NAME BY PERSON ID LOV'
,p_display_when=>':P30_STATUS not in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(36092643254523099)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181728988647831433)
,p_name=>'P30_FINAL_APPROVED_ON'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(181728590056831429)
,p_prompt=>'Final Approved ON'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>':P30_STATUS = ''Approved'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(36092643254523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181729000963831434)
,p_name=>'P30_FINAL_APPROVED_BY'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(181728590056831429)
,p_prompt=>'Approved By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMP FULL NAME BY PERSON ID LOV'
,p_display_when=>':P30_STATUS = ''Approved'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(36092643254523099)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181729192762831435)
,p_name=>'P30_REJECTED_ON'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(181728590056831429)
,p_prompt=>'Rejected ON'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>':P30_STATUS = ''Rejected'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(36092643254523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181729275612831436)
,p_name=>'P30_REJECTED_BY'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(181728590056831429)
,p_prompt=>'Rejected By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMP FULL NAME BY PERSON ID LOV'
,p_display_when=>':P30_STATUS = ''Rejected'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(36092643254523099)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181729485489831438)
,p_name=>'P30_SECURITY_CLEARANCE_STATUS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(181728590056831429)
,p_prompt=>'Security Clearance'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181729597014831439)
,p_name=>'P30_SECURITY_CLEARANCE_SUBMITTED_ON'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(181729358448831437)
,p_prompt=>'Security Clearance Submitted ON'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181729683054831440)
,p_name=>'P30_SECURITY_CLEARANCE_SUBMITTED_BY'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(181729358448831437)
,p_prompt=>'Security Clearance Submitted By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181729771588831441)
,p_name=>'P30_SECURITY_CLEARANCE_FINAL_APPROVED_ON'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(181729358448831437)
,p_prompt=>'Security Clearance Approved ON'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181729889888831442)
,p_name=>'P30_SECURITY_CLEARANCE_FINAL_APPROVED_BY'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(181729358448831437)
,p_prompt=>'Security Clearance Approved By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181729967654831443)
,p_name=>'P30_SECURITY_CLEARANCE_REJECTED_ON'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(181729358448831437)
,p_prompt=>'Security Clearance Rejected ON'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181730064529831444)
,p_name=>'P30_SECURITY_CLEARANCE_REJECTED_BY'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(181729358448831437)
,p_prompt=>'Security Clearance Rejected By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181730281999831446)
,p_name=>'P30_SERVICE_AGREEMENT_STATUS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(181728590056831429)
,p_item_default=>'Draft'
,p_prompt=>'Service Agreement'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181730380118831447)
,p_name=>'P30_SERVICE_AGREEMENT_SUBMITTED_ON'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(181730191168831445)
,p_prompt=>'Service Agreement Submitted On'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181730416224831448)
,p_name=>'P30_SERVICE_AGREEMENT_SUBMITTED_BY'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(181730191168831445)
,p_prompt=>'Service Agreement Submitted By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181730553443831449)
,p_name=>'P30_SERVICE_AGREEMENT_FINAL_APPROVED_ON'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(181730191168831445)
,p_prompt=>'Service Agreement Approved On'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181730693456831450)
,p_name=>'P30_SERVICE_AGREEMENT_REJECTED_ON'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(181730191168831445)
,p_prompt=>'Service Agreement Reject On'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181799756744060501)
,p_name=>'P30_SERVICE_AGREEMENT_FINAL_APPROVED_BY'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(181730191168831445)
,p_prompt=>'Service Agreement Approved By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181799881253060502)
,p_name=>'P30_SERVICE_AGREEMENT_REJECTED_BY'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(181730191168831445)
,p_prompt=>'Service Agreement Reject By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181799951920060503)
,p_name=>'P30_CANCEL_ON'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(181728590056831429)
,p_prompt=>'Cancel ON'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>':P30_STATUS = ''Cancelled'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(36092643254523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181800050579060504)
,p_name=>'P30_CANCELLED_BY'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(181728590056831429)
,p_prompt=>'Cancelled By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMP FULL NAME BY PERSON ID LOV'
,p_display_when=>':P30_STATUS = ''Cancelled'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(36092643254523099)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181800124017060505)
,p_name=>'P30_CANCEL_REASON'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(181728590056831429)
,p_prompt=>'Cancel Reason'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>':P30_STATUS = ''Cancelled'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(36092643254523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181800217921060506)
,p_name=>'P30_TITLE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(181672840230656240)
,p_prompt=>'Title'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'TITLE LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct DCT_EMPLOYEES_LIST2.TITLE as TITLE ,',
'        DCT_EMPLOYEES_LIST2.TITLE as Return',
' from DCT_EMPLOYEES_LIST2 DCT_EMPLOYEES_LIST2'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181800370750060507)
,p_name=>'P30_SEX'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(181672965396656241)
,p_prompt=>'Gender'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'GENDER LOV'
,p_lov=>'.'||wwv_flow_api.id(36649721030297905)||'.'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181800644921060510)
,p_name=>'P30_CREATED_BY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(181800436961060508)
,p_prompt=>'Created By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMP FULL NAME BY PERSON ID LOV'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181800769156060511)
,p_name=>'P30_UPDATED_BY'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(181800436961060508)
,p_prompt=>'Updated By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMP FULL NAME BY PERSON ID LOV'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
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
,p_default_application_id=>805
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181800850846060512)
,p_name=>'P30_CREATED_ON'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(181800436961060508)
,p_prompt=>'Created On'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(181800954993060513)
,p_name=>'P30_UPDATED_ON'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(181800436961060508)
,p_prompt=>'Updated On'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(192705213557777636)
,p_name=>'P30_IT_EQUIPMENT_REQUIRED'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(169814747297839035)
,p_prompt=>'IT Equipments'
,p_display_as=>'NATIVE_CHECKBOX'
,p_named_lov=>'FL_TECHNOLOGY_REQUIRED'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id',
'from DCT_LOOKUP_VALUES where lookup_id = (select l.lookup_id',
'                                          from dct_lookups l ',
'                                          where l.lookup_code = ''FL_TECHNOLOGY_REQUIRED'') ',
'                                          and status = ''A'' ',
'                                          and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10)',
'                                  ;       '))
,p_grid_label_column_span=>5
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'1'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(192704971134777633)
,p_name=>'Display Others DA'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P30_ACTIVITIES'
,p_condition_element=>'P30_ACTIVITIES'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'105'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(192705005514777634)
,p_event_id=>wwv_flow_api.id(192704971134777633)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_OTHER_ACTIVITY'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(192705124366777635)
,p_event_id=>wwv_flow_api.id(192704971134777633)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_OTHER_ACTIVITY'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(192705381704777637)
,p_name=>'P30_IT_REQUIRED_YN DA'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P30_IT_REQUIRED_YN'
,p_condition_element=>'P30_IT_REQUIRED_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(192705477958777638)
,p_event_id=>wwv_flow_api.id(192705381704777637)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_IT_EQUIPMENT_REQUIRED'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(192705597003777639)
,p_event_id=>wwv_flow_api.id(192705381704777637)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_IT_EQUIPMENT_REQUIRED'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(192705674302777640)
,p_name=>'P30_LICENSE_AVAILABLE_YN DA'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P30_LICENSE_AVAILABLE_YN'
,p_condition_element=>'P30_LICENSE_AVAILABLE_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'N'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(192705717598777641)
,p_event_id=>wwv_flow_api.id(192705674302777640)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_LICENSE_EXEMPTION_YN'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(192705839520777642)
,p_event_id=>wwv_flow_api.id(192705674302777640)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_LICENSE_EXEMPTION_YN'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(169814230405839030)
,p_name=>'Contract Duration Changes DA'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P30_CONTRACT_DURATION_ID'
,p_condition_element=>'P30_CONTRACT_DURATION_ID'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'278'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(169814322139839031)
,p_event_id=>wwv_flow_api.id(169814230405839030)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_SECURITY_CLEARANCE_REQUIRED_YN'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'N'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(169814495667839032)
,p_event_id=>wwv_flow_api.id(169814230405839030)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_SECURITY_CLEARANCE_REQUIRED_YN'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(169815022705839038)
,p_event_id=>wwv_flow_api.id(169814230405839030)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_SECURITY_CLEARANCE_STATUS'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'Not Required'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(169815134585839039)
,p_event_id=>wwv_flow_api.id(169814230405839030)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_SECURITY_CLEARANCE_STATUS'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'Required'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(192704545456777629)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialize Freelancer Request Details'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select',
'    id,',
'    request_number,',
'    new_freelancer_yn,',
'    first_name,',
'    second_name,',
'    third_name,',
'    last_name,',
'    full_name,',
'    license_available_yn,',
'    license_exemption_yn,',
'    contract_class,',
'    end_user_id,',
'    cost_center,',
'    sector_id,',
'    conversion_id,',
'    location_id,',
'    line_maanager_id,',
'--    payment_type_id,',
'    project_description,',
'    contract_duration_id,',
'    security_clearance_required_yn,',
'    it_required_yn,',
'    access_card_required_yn,',
'    passport_num,',
'    email,',
'    mobile_no,',
'    nationality,',
'    activities,',
'    other_activity,',
'    po_box,',
'    address,',
'    city,',
'    emirate,',
'    country,',
'    first_deal_with_dct,',
'    notes,',
'    fl_year,',
'    count_year,',
'    status,',
'    submitted_on,',
'    submitted_by,',
'    final_approved_on,',
'    final_approved_by,',
'    rejected_on,',
'    rejected_by,',
'    security_clearance_status,',
'    security_clearance_submitted_on,',
'    security_clearance_submitted_by,',
'    security_clearance_final_approved_on,',
'    security_clearance_final_approved_by,',
'    security_clearance_rejected_on,',
'    security_clearance_rejected_by,',
'    service_agreement_status,',
'    service_agreement_submitted_on,',
'    service_agreement_submitted_by,',
'    service_agreement_final_approved_on,',
'    service_agreement_final_approved_by,',
'    service_agreement_rejected_on,',
'    service_agreement_rejected_by,',
'    cancel_on,',
'    cancelled_by,',
'    cancel_reason,',
'    created_by,',
'    created_on,',
'    updated_by,',
'    updated_on,',
'    title,',
'    sex',
'--    ,person_type_id,',
'--    person_category_id,',
'--    reject_reason',
'    , IT_EQUIPMENT_REQUIRED',
'into',
'    :P30_FREELANCER_REQUEST_ID,',
'    :P30_REQUEST_NUMBER,',
'    :P30_NEW_FREELANCER_YN,',
'    :P30_FIRST_NAME,',
'    :P30_SECOND_NAME,',
'    :P30_THIRD_NAME,',
'    :P30_LAST_NAME,',
'    :P30_FULL_NAME,',
'    :P30_LICENSE_AVAILABLE_YN,',
'    :P30_LICENSE_EXEMPTION_YN,',
'    :P30_CONTRACT_CLASS,',
'    :P30_END_USER_ID,',
'    :P30_COST_CENTER,',
'    :P30_SECTOR_ID,',
'    :P30_CONVERSION_ID,',
'    :P30_LOCATION_ID,',
'    :P30_LINE_MAANAGER_ID,',
'    --null,   -- payment_type_id',
'    :P30_PROJECT_DESCRIPTION,',
'    :P30_CONTRACT_DURATION_ID,',
'    :P30_SECURITY_CLEARANCE_REQUIRED_YN,',
'    :P30_IT_REQUIRED_YN,',
'    :P30_IT_ACCESS_CARD_REQUIRED_YN,',
'    :P30_PASSPORT_NUM,',
'    :P30_EMAIL,',
'    :P30_MOBILE_NO,',
'    :P30_NATIONALITY,',
'    :P30_ACTIVITIES,',
'    :P30_OTHER_ACTIVITY,',
'    :P30_PO_BOX,',
'    :P30_ADDRESS,',
'    :P30_CITY,',
'    :P30_EMIRATE,',
'    :P30_COUNTRY,',
'    :P30_FIRST_DEAL_WITH_DCT,',
'    :P30_NOTES,',
'    :P30_FL_YEAR,',
'    :P30_COUNT_YEAR,',
'    :P30_STATUS,',
'    :P30_SUBMITTED_ON,',
'    :P30_SUBMITTED_BY,',
'    :P30_FINAL_APPROVED_ON,',
'    :P30_FINAL_APPROVED_BY,',
'    :P30_REJECTED_ON,',
'    :P30_REJECTED_BY,',
'    :P30_SECURITY_CLEARANCE_STATUS,',
'    :P30_SECURITY_CLEARANCE_SUBMITTED_ON,',
'    :P30_SECURITY_CLEARANCE_SUBMITTED_BY,',
'    :P30_SECURITY_CLEARANCE_FINAL_APPROVED_ON,',
'    :P30_SECURITY_CLEARANCE_FINAL_APPROVED_BY,',
'    :P30_SECURITY_CLEARANCE_REJECTED_ON,',
'    :P30_SECURITY_CLEARANCE_REJECTED_BY,',
'    :P30_SERVICE_AGREEMENT_STATUS,',
'    :P30_SERVICE_AGREEMENT_SUBMITTED_ON,',
'    :P30_SERVICE_AGREEMENT_SUBMITTED_BY,',
'    :P30_SERVICE_AGREEMENT_FINAL_APPROVED_ON,',
'    :P30_SERVICE_AGREEMENT_FINAL_APPROVED_BY,',
'    :P30_SERVICE_AGREEMENT_REJECTED_ON,',
'    :P30_SERVICE_AGREEMENT_REJECTED_BY,',
'    :P30_CANCEL_ON,',
'    :P30_CANCELLED_BY,',
'    :P30_CANCEL_REASON,',
'    :P30_CREATED_BY,',
'    :P30_CREATED_ON,',
'    :P30_UPDATED_BY,',
'    :P30_UPDATED_ON,',
'    :P30_TITLE,',
'    :P30_SEX',
'--    null,   -- person_type_id,',
'--    null,   -- person_category_id,',
'--    null   -- reject_reason',
'    , :P30_IT_EQUIPMENT_REQUIRED',
'from FREELANCER_REQUESTS',
'where id = :P30_FREELANCER_REQUEST_ID;',
'',
'exception',
'    when others then null;  '))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(192704721018777631)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Insert New Reuest'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_type              varchar2(1);',
'l_total_count       number;',
'l_request_no        varchar2(50);',
'l_grade            varchar2(50);',
'l_count            Number;',
'BEGIN',
'',
'      ',
'    -- get total Count By Year',
'        select nvl(max(SEQ),0) + 1',
'        into l_total_count',
'        from FREELANCER_REQUESTS',
'--        where fl_year = EXTRACT(year from sysdate)',
'        ;',
'    ',
'l_request_no := ''FL'' ',
'                || to_char(sysdate, ''yyyymmdd'') || ''/'' ',
'--                || user_details.get_username(:P12_REQUEST_FOR)  || ''/''   ',
'--                || :P12_REQUEST_TYPE              ||',
'                  || to_char(l_total_count);',
'                   ',
'    SELECT FREELANCER_REQUESTS_SEQ.nextval',
'    into :P30_FREELANCER_REQUEST_ID',
'    FROM all_sequences',
'    WHERE sequence_owner = ''PROD''',
'    AND sequence_name = ''FREELANCER_REQUESTS_SEQ'';',
'   ',
'   INSERT INTO freelancer_requests (',
'    id,',
'    request_number,',
'    new_freelancer_yn,',
'    first_name,',
'    second_name,',
'    third_name,',
'    last_name,',
'    full_name,',
'    license_available_yn,',
'    license_exemption_yn,',
'    contract_class,',
'    end_user_id,',
'    cost_center,',
'    sector_id,',
'    conversion_id,',
'    location_id,',
'    line_maanager_id,',
'    payment_type_id,',
'    project_description,',
'    contract_duration_id,',
'    security_clearance_required_yn,',
'    SECURITY_CLEARANCE_STATUS,',
'    it_required_yn,',
'    access_card_required_yn,',
'    passport_num,',
'    email,',
'    mobile_no,',
'    nationality,',
'    activities,',
'    other_activity,',
'    po_box,',
'    address,',
'    city,',
'    emirate,',
'    country,',
'    first_deal_with_dct,',
'    notes,',
'    fl_year,',
'    count_year,',
'    status,',
'    title,',
'    sex,',
'--    person_type_id,',
'--    person_category_id,',
'--    reject_reason,',
'    seq,',
'      IT_EQUIPMENT_REQUIRED',
'                                ',
') VALUES (',
'    :P30_FREELANCER_REQUEST_ID,',
'    l_request_no,',
'    :P30_NEW_FREELANCER_YN,',
'    :P30_FIRST_NAME,',
'    :P30_SECOND_NAME,',
'    :P30_THIRD_NAME,',
'    :P30_LAST_NAME,',
'    :P30_FULL_NAME,',
'    :P30_LICENSE_AVAILABLE_YN,',
'    :P30_LICENSE_EXEMPTION_YN,',
'    :P30_CONTRACT_CLASS,',
'    :P30_END_USER_ID,',
'    :P30_COST_CENTER,',
'    :P30_SECTOR_ID,',
'    :P30_CONVERSION_ID,',
'    :P30_LOCATION_ID,',
'    :P30_LINE_MAANAGER_ID,',
'    Null, --payment_type_id',
'    :P30_PROJECT_DESCRIPTION,',
'    :P30_CONTRACT_DURATION_ID,',
'    case :P30_CONTRACT_DURATION_ID',
'        when ''278'' then ''N''',
'        else    ''Y'' ',
'     end,   --:P30_SECURITY_CLEARANCE_REQUIRED_YN,',
'     case :P30_CONTRACT_DURATION_ID',
'            when ''Not Required'' then ''N''',
'            else ''Required'' ',
'         end,           -- SECURITY_CLEARANCE_STATUS',
'    :P30_IT_REQUIRED_YN,',
'    :P30_IT_ACCESS_CARD_REQUIRED_YN,',
'    :P30_PASSPORT_NUM,',
'    :P30_EMAIL,',
'    :P30_MOBILE_NO,',
'    :P30_NATIONALITY,',
'    :P30_ACTIVITIES,',
'    :P30_OTHER_ACTIVITY,',
'    :P30_PO_BOX,',
'    :P30_ADDRESS,',
'    :P30_CITY,',
'    :P30_EMIRATE,',
'    :P30_COUNTRY,',
'    :P30_FIRST_DEAL_WITH_DCT,',
'    :P30_NOTES,',
'    extract(year from sysdate),',
'    l_total_count,',
'    :P30_STATUS,',
'    :P30_TITLE,',
'    :P30_SEX,',
'    l_total_count,',
'    :P30_IT_EQUIPMENT_REQUIRED',
');',
'',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(181801286492060516)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(192704891549777632)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update  Freelancer Request'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count            Number;',
'l_grade            varchar2(50);',
'BEGIN',
'',
'UPDATE freelancer_requests',
'SET',
'    new_freelancer_yn = :P30_NEW_FREELANCER_YN,',
'    first_name = :P30_FIRST_NAME,',
'    second_name = :P30_SECOND_NAME,',
'    third_name = :P30_THIRD_NAME,',
'    last_name = :P30_LAST_NAME,',
'    full_name = :P30_FULL_NAME,',
'    license_available_yn = :P30_LICENSE_AVAILABLE_YN,',
'    license_exemption_yn = :P30_LICENSE_EXEMPTION_YN,',
'    contract_class = :P30_CONTRACT_CLASS,',
'    end_user_id = :P30_END_USER_ID,',
'    cost_center = :P30_COST_CENTER,',
'    sector_id = :P30_SECTOR_ID,',
'    conversion_id = :P30_CONVERSION_ID,',
'    location_id = :P30_LOCATION_ID,',
'    line_maanager_id = :P30_LINE_MAANAGER_ID,',
'--    payment_type_id = :v17',
'    project_description = :P30_PROJECT_DESCRIPTION,',
'    contract_duration_id = :P30_CONTRACT_DURATION_ID,',
'--    security_clearance_required_yn = :P30_SECURITY_CLEARANCE_REQUIRED_YN,',
'    security_clearance_required_yn = case :P30_CONTRACT_DURATION_ID',
'                                        when ''278'' then ''N''',
'                                        else    ''Y'' ',
'                                     end,   --:P30_SECURITY_CLEARANCE_REQUIRED_YN,',
'    SECURITY_CLEARANCE_STATUS = case :P30_CONTRACT_DURATION_ID',
'                                        when ''Not Required'' then ''N''',
'                                        else ''Required'' ',
'                                     end,',
'    it_required_yn = :P30_IT_REQUIRED_YN,',
'    access_card_required_yn = :P30_IT_ACCESS_CARD_REQUIRED_YN,',
'    passport_num = :P30_PASSPORT_NUM,',
'    email = :P30_EMAIL,',
'    mobile_no = :P30_MOBILE_NO,',
'    nationality = :P30_NATIONALITY,',
'    activities = :P30_ACTIVITIES,',
'    other_activity = :P30_OTHER_ACTIVITY,',
'    po_box = :P30_PO_BOX,',
'    address = :P30_ADDRESS,',
'    city = :P30_CITY,',
'    emirate = :P30_EMIRATE,',
'    country = :P30_COUNTRY,',
'    first_deal_with_dct = :P30_FIRST_DEAL_WITH_DCT,',
'    notes = :P30_NOTES,',
'    title = :P30_TITLE,',
'    sex = :P30_SEX',
'--    AND person_type_id = :v73',
'--    AND person_category_id = :v74',
'    , IT_EQUIPMENT_REQUIRED = :P30_IT_EQUIPMENT_REQUIRED',
'',
'WHERE',
'        id = :P30_FREELANCER_REQUEST_ID  ;',
'        ',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(181801389000060517)
);
wwv_flow_api.component_end;
end;
/
