prompt --application/pages/page_00002
begin
--   Manifest
--     PAGE: 00002
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>219773596381898043
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>2
,p_user_interface_id=>wwv_flow_api.id(23921013981372477)
,p_name=>'Credit Card Details'
,p_alias=>'CREDIT-CARD-DETAILS'
,p_step_title=>'Credit Card Details'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if (document.getElementById("P2_REQUESTOR_ORG_NAME")){',
'document.getElementById("P2_REQUESTOR_ORG_NAME").readOnly = true;}',
'',
'if (document.getElementById("P2_REQUESTOR_SECTOR_NAME")) {',
'document.getElementById("P2_REQUESTOR_SECTOR_NAME").readOnly = true;}'))
,p_css_file_urls=>'#WORKSPACE_IMAGES#main.css'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.t-Form-label {',
'    	color: #368ed2;',
'	font-weight: bold;',
'	font-size:12px;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'PLSQL_EXPRESSION'
,p_read_only_when=>':P2_DCT_APPROVAL_STATUS not in (''Draft'' , ''Withdraw'' ,''Returned'')'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220313135026'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(18100022869298118)
,p_plug_name=>'Credit Card Replacement Request '
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P2_APPROVAL_TYPE'
,p_plug_display_when_cond2=>'21'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(18099260002298110)
,p_plug_name=>'Approval History'
,p_parent_plug_id=>wwv_flow_api.id(18100022869298118)
,p_icon_css_classes=>'fa-list'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CC.ID,',
'       cc.credit_card_id,',
'       STEP_NO,',
'       ACTION_REQUIRED,',
'       e.USER_NAME,',
'       STATUS,',
'       RECEVIED_DATE,',
'       ACTION_DATE,',
'       COMMENTS,',
'       ROLE_DESC,',
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
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'           end Photo',
'  from CREDIT_CARD_APPROVAL_HISTORY cc,  dct_employees_list2  e',
'  where cc.person_id = e.person_id (+)',
'and  cc.credit_card_id = :P2_ID2',
'order by step_no , ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P2_ID2'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(18099190791298109)
,p_max_row_count=>'1000000'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>98707108683627245
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18099083019298108)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18098985693298107)
,p_db_column_name=>'CREDIT_CARD_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Credit Card Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18098826290298106)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18098779580298105)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18098621354298104)
,p_db_column_name=>'USER_NAME'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'User Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17748566660098053)
,p_db_column_name=>'STATUS'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17748468503098052)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17748315032098051)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17748265506098050)
,p_db_column_name=>'COMMENTS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17748136653098049)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17748008110098048)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17747933074098047)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17747861546098046)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17747730699098045)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17747661184098044)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17747500170098043)
,p_db_column_name=>'PHOTO'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17747455810098042)
,p_db_column_name=>'ROLE_DESC'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Role'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(17737824575092533)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'990685'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:PHOTO:FULL_NAME_EN:USER_NAME:ROLE_DESC:ACTION_REQUIRED:RECEVIED_DATE:STATUS:ACTION_DATE:COMMENTS:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(17736130688075505)
,p_report_id=>wwv_flow_api.id(17737824575092533)
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
 p_id=>wwv_flow_api.id(24098473116338825)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23845862961372548)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(23782494216372596)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(23899958141372507)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(24099022477338621)
,p_plug_name=>'&P2_REQUEST_TYPE_NAME. Request'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody:margin-right-none'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'CREDIT_CARDS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_plug_display_when_condition=>'P2_APPROVAL_TYPE'
,p_plug_display_when_cond2=>'21'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(24215881936492707)
,p_plug_name=>'Audit Info'
,p_parent_plug_id=>wwv_flow_api.id(24099022477338621)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(23819444978372562)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P2_ID IS NOT NULL and :P2_APPROVAL_TYPE != 21'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(24216189822492710)
,p_plug_name=>'Cardholder Information'
,p_parent_plug_id=>wwv_flow_api.id(24099022477338621)
,p_icon_css_classes=>'fa-credit-card-terminal'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody:t-Form--large:t-Form--leftLabels'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_plug_display_when_condition=>'P2_APPROVAL_TYPE'
,p_plug_display_when_cond2=>'21'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(24216801168492717)
,p_plug_name=>'Required Documents'
,p_parent_plug_id=>wwv_flow_api.id(24099022477338621)
,p_icon_css_classes=>'fa-files-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select d.ID,',
'       nvl(cr.document_name,d.FILENAME) document_name,',
'       d.ROW_VERSION_NUMBER,',
'       d.credit_card_id,',
'       d.FILENAME,',
'       d.FILE_MIMETYPE,',
'       d.FILE_CHARSET,',
'       d.FILE_BLOB,',
'       d.FILE_COMMENTS,',
'       d.TAGS,',
'       d.created_on,',
'       d.CREATED_BY,',
'       d.updated_on,',
'       d.UPDATED_BY,',
'       sys.dbms_lob.getlength(d.file_blob) as file_size,',
'    sys.dbms_lob.getlength(d.file_blob) as download',
'  from credit_cards_documents d , credit_card_doc_required cr',
'  where d.doc_required_id = cr.id (+)',
'  and d.credit_card_id = :P2_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P2_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P2_ID IS NOT NULL and :P2_APPROVAL_TYPE != 21'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Required Documents'
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
 p_id=>wwv_flow_api.id(24216968055492718)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>24216968055492718
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24217024411492719)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24217170784492720)
,p_db_column_name=>'DOCUMENT_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Document Name'
,p_column_link=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.::P4_APPROVAL_STATUS,P4_ID,P4_PAGE_FROM:&P2_DCT_APPROVAL_STATUS.,#ID#,2'
,p_column_linktext=>'#DOCUMENT_NAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24217218246492721)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24217372594492722)
,p_db_column_name=>'CREDIT_CARD_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Credit Card Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24217462321492723)
,p_db_column_name=>'FILENAME'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Attached File'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24217593547492724)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24217665993492725)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24217772310492726)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>80
,p_column_identifier=>'H'
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
 p_id=>wwv_flow_api.id(24217840634492727)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24217939638492728)
,p_db_column_name=>'TAGS'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24218096354492729)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24218153437492730)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(24146885424244788)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24218276988492731)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24218361773492732)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24146885424244788)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24218431235492733)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24218562997492734)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:CREDIT_CARDS_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED_ON:FILE_CHARSET:attachment::'
,p_rpt_show_filter_lov=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(24336257498144524)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'243363'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'DOCUMENT_NAME:FILENAME:FILE_COMMENTS:UPDATED_ON:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(33460701099009006)
,p_plug_name=>'Approval History'
,p_parent_plug_id=>wwv_flow_api.id(24099022477338621)
,p_icon_css_classes=>'fa-list'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CC.ID,',
'       cc.credit_card_id,',
'       STEP_NO,',
'       ACTION_REQUIRED,',
'       e.USER_NAME,',
'       STATUS,',
'       RECEVIED_DATE,',
'       ACTION_DATE,',
'       COMMENTS,',
'       ROLE_DESC,',
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
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'           end Photo',
'  from CREDIT_CARD_APPROVAL_HISTORY cc,  dct_employees_list2  e',
'  where cc.person_id = e.person_id (+)',
'and  cc.credit_card_id = :P2_ID',
'order by step_no , ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P2_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P2_ID Is not Null and :P2_DCT_APPROVAL_STATUS not in (''Draft'')'
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
 p_id=>wwv_flow_api.id(33460869224009007)
,p_max_row_count=>'1000000'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>33460869224009007
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33461187748009010)
,p_db_column_name=>'STEP_NO'
,p_display_order=>10
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33462486309009023)
,p_db_column_name=>'PHOTO'
,p_display_order=>20
,p_column_identifier=>'P'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33462320583009022)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>30
,p_column_identifier=>'O'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33461303239009012)
,p_db_column_name=>'USER_NAME'
,p_display_order=>40
,p_column_identifier=>'E'
,p_column_label=>'User Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33461262045009011)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>50
,p_column_identifier=>'D'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33461510660009014)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>60
,p_column_identifier=>'G'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33461421739009013)
,p_db_column_name=>'STATUS'
,p_display_order=>70
,p_column_identifier=>'F'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33461619085009015)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33460969768009008)
,p_db_column_name=>'ID'
,p_display_order=>90
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33461032712009009)
,p_db_column_name=>'CREDIT_CARD_ID'
,p_display_order=>100
,p_column_identifier=>'B'
,p_column_label=>'Credit Card Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33461782063009016)
,p_db_column_name=>'COMMENTS'
,p_display_order=>110
,p_column_identifier=>'I'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33461873050009017)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>120
,p_column_identifier=>'J'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33461985376009018)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>130
,p_column_identifier=>'K'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33462025369009019)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>140
,p_column_identifier=>'L'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33462133485009020)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>150
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33462262276009021)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>160
,p_column_identifier=>'N'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33462541110009024)
,p_db_column_name=>'ROLE_DESC'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Role'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(33472014547770944)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'334721'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:PHOTO:FULL_NAME_EN:USER_NAME:ROLE_DESC:ACTION_REQUIRED:RECEVIED_DATE:STATUS:ACTION_DATE:COMMENTS:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(38566518280703439)
,p_report_id=>wwv_flow_api.id(33472014547770944)
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
 p_id=>wwv_flow_api.id(33700440750949708)
,p_plug_name=>'Collaboration'
,p_icon_css_classes=>'fa-comments-o fa-anim-flash fam-sleep fam-is-success'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody:t-Form--slimPadding:margin-left-none'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_column=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P2_ID IS NOT NULL and :P2_APPROVAL_TYPE != 21'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(33700595570949709)
,p_name=>'Comments report'
,p_parent_plug_id=>wwv_flow_api.id(33700440750949708)
,p_template=>wwv_flow_api.id(23836400541372553)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noUI:t-Region--scrollBody'
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
'    END                                             user_icon,',
'  updated_on                                      comment_date,',
'  (select e.full_name_en',
'    from dct_employees_list2 e',
'    where e.person_id = created_by_person_id)       user_name,',
'  comment_text                                      comment_text,',
'  null                                              comment_modifiers,',
'  ''u-color-''||ora_hash(created_by_person_id,45)     icon_modifier,',
'  sys.dbms_lob.getlength(file_blob)                 actions,',
'  ''''     attribute_1,',
'  ''''     attribute_2,',
'  ''''    attribute_3,',
'  ''''    attribute_4,',
'  filename,',
'  comment_id',
'from',
'  (SELECT',
'    c.comment_id,',
'    c.credit_card_id,',
'    c.comment_text,',
'    c.created_by_person_id,',
'    c.updated_by_person_id,',
'    c.created_on,',
'    c.updated_on,',
'    c.action,',
'    c.action,',
'    c.file_blob,',
'    c.filename,',
'    e.user_name,',
'    e.photo_blob    ',
'FROM',
'    CREDIT_CARDS_COMMENTS c , dct_employees_list2 e',
'where c.updated_by_person_id = e.person_id    )',
'where CREDIT_CARD_ID = :P2_ID',
'order by created_on desc;',
''))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P2_ID'
,p_query_row_template=>wwv_flow_api.id(23865372578372535)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No discussions yet'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(33700620550949710)
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
 p_id=>wwv_flow_api.id(33700754903949711)
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
 p_id=>wwv_flow_api.id(33700892906949712)
,p_query_column_id=>3
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>3
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(33700903725949713)
,p_query_column_id=>4
,p_column_alias=>'COMMENT_TEXT'
,p_column_display_sequence=>4
,p_column_heading=>'Comment Text'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::P8_COMMENT_ID,P8_PAGE_FROM:#COMMENT_ID#,2'
,p_column_linktext=>'#COMMENT_TEXT#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(33701056600949714)
,p_query_column_id=>5
,p_column_alias=>'COMMENT_MODIFIERS'
,p_column_display_sequence=>5
,p_column_heading=>'Comment Modifiers'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>219773596381898043
,p_default_owner=>'PROD'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(33701125160949715)
,p_query_column_id=>6
,p_column_alias=>'ICON_MODIFIER'
,p_column_display_sequence=>6
,p_column_heading=>'Icon Modifier'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(33701218212949716)
,p_query_column_id=>7
,p_column_alias=>'ACTIONS'
,p_column_display_sequence=>7
,p_column_heading=>'Actions'
,p_use_as_row_header=>'N'
,p_column_format=>'DOWNLOAD:CREDIT_CARDS_COMMENTS:FILE_BLOB:COMMENT_ID::FILE_MIMETYPE:FILENAME:UPDATED_ON:FILE_CHARSET:attachment:#FILENAME#:'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(33701342799949717)
,p_query_column_id=>8
,p_column_alias=>'ATTRIBUTE_1'
,p_column_display_sequence=>8
,p_column_heading=>'Attribute 1'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(33701478196949718)
,p_query_column_id=>9
,p_column_alias=>'ATTRIBUTE_2'
,p_column_display_sequence=>9
,p_column_heading=>'Attribute 2'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(33701537389949719)
,p_query_column_id=>10
,p_column_alias=>'ATTRIBUTE_3'
,p_column_display_sequence=>10
,p_column_heading=>'Attribute 3'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(33701627893949720)
,p_query_column_id=>11
,p_column_alias=>'ATTRIBUTE_4'
,p_column_display_sequence=>11
,p_column_heading=>'Attribute 4'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(33701735405949721)
,p_query_column_id=>12
,p_column_alias=>'FILENAME'
,p_column_display_sequence=>12
,p_column_heading=>'Filename'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(33701881759949722)
,p_query_column_id=>13
,p_column_alias=>'COMMENT_ID'
,p_column_display_sequence=>13
,p_column_heading=>'Comment Id'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(34057444681009628)
,p_plug_name=>'Instructions'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<marquee width="90%" direction="left" scrollamount="8" style="font-size:20px;">',
'(1) Use this form to &P2_REQUEST_TYPE_NAME. <b style="color:red;"> (2)Please make sure to attach all required documents.</b> (3)you will notified once the request is approved according to DOA. and you can check the current status.',
'</marquee>'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P2_DCT_APPROVAL_STATUS'
,p_plug_display_when_cond2=>'Draft'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(24129319021338597)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(24099022477338621)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(23898584035372508)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(23742550784932505)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(24098473116338825)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(23898584035372508)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:1::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(33701999076949723)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(33700440750949708)
,p_button_name=>'Add_Comment'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_image_alt=>'New'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:8:P8_CREDIT_CARD_ID,P8_PAGE_FROM:&P2_ID.,2'
,p_icon_css_classes=>'fa-commenting-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(34283057029651541)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(24216801168492717)
,p_button_name=>'Add_Attachment'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_image_alt=>'Add Attachment'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:4:P4_APPROVAL_STATUS,P4_CREDIT_CARD_ID,P4_PAGE_FROM:&P2_DCT_APPROVAL_STATUS.,&P2_ID.,2'
,p_icon_css_classes=>'fa-file-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(23742662323932506)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(24098473116338825)
,p_button_name=>'Submit'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Submit'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:5:P5_ID,P5_PERSON_ID,P5_APPROVAL_TYPE:&P2_ID.,&P2_REQUESTOR_PERSON_ID.,&P2_APPROVAL_TYPE.'
,p_button_condition=>':P2_ID is not null and :P2_DCT_APPROVAL_STATUS in (''Draft'' , ''Withdraw'' )'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(34057565523009629)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(24098473116338825)
,p_button_name=>'Submit_Finance'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Submit Finance'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.:14:P14_ID:&P2_ID.'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Declare',
'l_treasury_admin    number;',
'begin',
'SELECT count(*)',
'into l_treasury_admin',
'FROM dct_data_access_assignment ',
'where entity_type_id = ''ROLE'' ',
'and entity_id = 50  -- 50 for Treasury Admin',
'and status = ''A'' ',
'and person_id = :PERSON_ID',
'and sysdate BETWEEN start_date and nvl(end_date , sysdate + 10);',
'',
'if :P2_DCT_APPROVAL_STATUS = ''Approved'' and ',
'    l_treasury_admin > 0  and',
'    :P2_BANK_APPROVAL_STATUS in (''Not Started'' , ''Stopped'') ',
'  Then',
'      return True ;',
'      else ',
'      return false;',
'   End if;',
'End;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(24130181793338595)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(24098473116338825)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition=>':P2_ID is not null and :P2_DCT_APPROVAL_STATUS in (''Draft'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-trash-o'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(23742724131932507)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(24098473116338825)
,p_button_name=>'STOP_Approval'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Withdraw'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(:P2_ID is not null and :P2_DCT_APPROVAL_STATUS = ''In-Progress'' ',
'And (:P2_REQUESTOR_PERSON_ID = :PERSON_ID or :P2_CREATOR_PERSON_ID = :PERSON_ID))'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-remove'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(24130562674338595)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(24098473116338825)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save & Continue'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>':P2_ID is not null and :P2_DCT_APPROVAL_STATUS in (''Draft'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-save'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(24130932710338594)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_api.id(24098473116338825)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save and Continue'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P2_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_icon_css_classes=>'fa-save fa-anim-flash fam-check fam-is-success'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(33460224387009001)
,p_button_sequence=>80
,p_button_plug_id=>wwv_flow_api.id(24098473116338825)
,p_button_name=>'Rollback'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(23898584035372508)
,p_button_image_alt=>'Rollback'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'PERSON_ID'
,p_button_condition2=>'680461'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(35392739327055818)
,p_button_sequence=>90
,p_button_plug_id=>wwv_flow_api.id(24098473116338825)
,p_button_name=>'Print'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Print Bank Form'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>':P2_DCT_APPROVAL_STATUS = ''Approved'' and :P2_BANK_APPROVAL_STATUS = ''Approved'''
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-print'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(33462746955009026)
,p_branch_name=>'Go To Page 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(24130181793338595)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(24131204288338594)
,p_branch_name=>'Go To Page 2'
,p_branch_action=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.::P2_ID:&P2_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76111090000012538)
,p_name=>'P2_NATIONALITY'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(24216189822492710)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'Nationality'
,p_source=>'NATIONALITY_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'NATIONALITIES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_e_user ,desc_e) nationality_name_en , code nationality_code  ',
'from dct_employees_lookups',
'where lookup_number = 1;'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24678186916466147)
,p_name=>'P2_APPROVAL_TYPE'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_source=>'APPROVAL_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24677003599466136)
,p_name=>'P2_NEW'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24676824139466134)
,p_name=>'P2_REQUEST_TYPE_NAME'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT approval_type_name',
'',
'FROM approval_types ',
'where parent_id = 1',
'and approval_type_id = :p2_approval_type;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18099906349298117)
,p_name=>'P2_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(18100022869298118)
,p_prompt=>'Requestor'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18099896471298116)
,p_name=>'P2_DEPARTMENT'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(18100022869298118)
,p_prompt=>'Department'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18099643234298114)
,p_name=>'P2_COMMENT'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(18100022869298118)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18099302979298111)
,p_name=>'P2_ID2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(18100022869298118)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(17503952276239551)
,p_name=>'P2_CREATED_BY_REQUEST_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_source=>'CREATED_BY_REQUEST_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(23742830240932508)
,p_name=>'P2_REQUESTOR_ORG_NAME'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'Requestor Organization :'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>40
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(23742944267932509)
,p_name=>'P2_REQUESTOR_SECTOR_NAME'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'Requestor Sector  :'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>40
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(23743287898932512)
,p_name=>'P2_REQUESTED_AMOUNT_H'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_source=>'REQUESTED_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24099325672338621)
,p_name=>'P2_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_source=>'ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24099710428338618)
,p_name=>'P2_CREATOR_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_default=>'PERSON_ID'
,p_item_default_type=>'ITEM'
,p_source=>'CREATOR_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24100105668338617)
,p_name=>'P2_REQUESTOR_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'if :P2_APPROVAL_TYPE = 2  and :P2_ID is null Then',
' return :PERSON_ID;',
' ',
'End if;',
'end;'))
,p_item_default_type=>'PLSQL_FUNCTION_BODY'
,p_prompt=>'Applied For :'
,p_source=>'REQUESTOR_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'PERSON DETAILS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select e.employee_num || ''-'' || e.full_name_en  emp_name , e.person_id , e.org_id, e.department_name',
'        , e.sector ',
'        , e.department_id',
'        , e.sector_id',
'        , (select s.short_name_en',
'            from dct_hr_organizations s',
'            where s.org_id = e.sector_id) sector_code',
'        , cost_center_code    ',
'        , e.email',
'        , e.mobile',
'        , e.position',
'        , e.position_id',
'        , e.employee_num',
'        ,e.nationality_id',
'from employees_v e',
'where current_flag = ''Y'' ',
'ORDER BY employee_num;    '))
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_10=>'ORG_ID:P2_REQUESTOR_ORG_ID,DEPARTMENT_ID:P2_DEPARTMENT_ID,SECTOR_ID:P2_SECTOR_ID,DEPARTMENT_NAME:P2_REQUESTOR_ORG_NAME,SECTOR:P2_REQUESTOR_SECTOR_NAME,COST_CENTER_CODE:P2_COST_CENTER,EMAIL:P2_EMAIL,MOBILE:P2_MOBILE_NUMBER,POSITION_ID:P2_POSITION_ID,P'
||'OSITION:P2_POSITION_NAME,EMPLOYEE_NUM:P2_EMPLOYEE_NUMBER'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24100597266338617)
,p_name=>'P2_REQUESTOR_ORG_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select org_id',
'from employees_v ',
'where person_id = :PERSON_ID'))
,p_item_default_type=>'SQL_QUERY'
,p_source=>'REQUESTOR_ORG_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24100992228338617)
,p_name=>'P2_DEPARTMENT_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select department_id',
'from employees_v ',
'where person_id = :PERSON_ID'))
,p_item_default_type=>'SQL_QUERY'
,p_source=>'DEPARTMENT_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24101322445338616)
,p_name=>'P2_SECTOR_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select sector_id ',
'from employees_v ',
'where person_id = :PERSON_ID'))
,p_item_default_type=>'SQL_QUERY'
,p_source=>'SECTOR_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24101767308338616)
,p_name=>'P2_COST_CENTER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select cost_center_code ',
'from employees_v ',
'where person_id = :PERSON_ID'))
,p_item_default_type=>'SQL_QUERY'
,p_source=>'COST_CENTER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24102193398338616)
,p_name=>'P2_PURPOSE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'Purpose :'
,p_placeholder=>'Please identify the purpose for your credit card request'
,p_source=>'PURPOSE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>120
,p_cMaxlength=>4000
,p_cHeight=>4
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24102502848338616)
,p_name=>'P2_REQUESTED_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'Requested Amount :'
,p_post_element_text=>'<p>AED</p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'REQUESTED_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_tag_attributes=>'onchange="this.value=Number(this.value).toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, ''$1,'')"'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24102932455338615)
,p_name=>'P2_APPROVED_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_source=>'APPROVED_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24103371109338615)
,p_name=>'P2_EMPLOYEE_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_default=>'EMP_NUM'
,p_item_default_type=>'ITEM'
,p_source=>'EMPLOYEE_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24103719387338615)
,p_name=>'P2_MOTHER_NAME'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(24216189822492710)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'Mother Name :'
,p_source=>'MOTHER_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24104140937338615)
,p_name=>'P2_EMAIL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(24216189822492710)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select   e.email',
'from employees_v e',
'where e.person_id = :PERSON_ID'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Email :'
,p_source=>'EMAIL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>75
,p_cMaxlength=>100
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24104515611338614)
,p_name=>'P2_MOBILE_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(24216189822492710)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select   e.mobile',
'from employees_v e',
'where e.person_id = :PERSON_ID'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Mobile Number :'
,p_source=>'MOBILE_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>20
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24104931352338614)
,p_name=>'P2_OFFICE_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(24216189822492710)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'Office Number :'
,p_source=>'OFFICE_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>20
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24105313202338614)
,p_name=>'P2_POSITION_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(24216189822492710)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select   e.position',
'from employees_v e',
'where e.person_id = :PERSON_ID'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Position :'
,p_source=>'POSITION_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>120
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24105711994338614)
,p_name=>'P2_POSITION_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(24216189822492710)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select   e.position_id',
'from employees_v e',
'where e.person_id = :PERSON_ID'))
,p_item_default_type=>'SQL_QUERY'
,p_source=>'POSITION_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24106112369338613)
,p_name=>'P2_ADCB_CUSTOMER_YN'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'ADCB Existing Customer ? '
,p_source=>'ADCB_CUSTOMER_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24106529424338613)
,p_name=>'P2_ADCB_MOBILE_REGISTERED'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'ADCB Registered Mobile :'
,p_source=>'ADCB_MOBILE_REGISTERED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>20
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24106905128338613)
,p_name=>'P2_ADCB_EMAIL_REGISTERED'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'ADCB Registered Email :'
,p_source=>'ADCB_EMAIL_REGISTERED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'EMAIL'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24107330600338612)
,p_name=>'P2_DCT_APPROVAL_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_default=>'Draft'
,p_prompt=>'DOA Approval Status :'
,p_source=>'DCT_APPROVAL_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
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
,p_default_application_id=>103
,p_default_id_offset=>219773596381898043
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24107777059338612)
,p_name=>'P2_BANK_APPROVAL_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_default=>'Draft'
,p_prompt=>'Finance Approval Status :'
,p_source=>'BANK_APPROVAL_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>':P2_DCT_APPROVAL_STATUS =''Approved'' '
,p_display_when_type=>'SQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24108105429338612)
,p_name=>'P2_NOTES'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'Note :'
,p_source=>'NOTES'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>120
,p_cMaxlength=>4000
,p_cHeight=>4
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24112577790338609)
,p_name=>'P2_SUBMISSION_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'Submission Date :'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'SUBMISSION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>':P2_DCT_APPROVAL_STATUS not in (''Draft'' , ''Withdraw'')'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24113362735338608)
,p_name=>'P2_FINAL_DCT_APPROVAL'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'Final Approved ON :'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'FINAL_DCT_APPROVAL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_display_when=>':P2_DCT_APPROVAL_STATUS in (''Approved'' , ''Rejected'')'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_inline_help_text=>'&P2_FINAL_DCT_APPROVAL_DURATION.'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24114114988338607)
,p_name=>'P2_FINAL_BANK_APPROVAL'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_item_default=>'NA'
,p_prompt=>'Finance Approved ON :'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'FINAL_BANK_APPROVAL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>':P2_BANK_APPROVAL_STATUS in (''Approved'' , ''Rejected'')'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_inline_help_text=>'&P2_FINAL_BANK_APPROVAL_DURATION.'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24114914799338607)
,p_name=>'P2_CREATED_BY_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>400
,p_item_plug_id=>wwv_flow_api.id(24215881936492707)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'Created By'
,p_source=>'CREATED_BY_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEE NAME BY PERSONID LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en , person_id',
'from dct_employees_list2'))
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24115397561338607)
,p_name=>'P2_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>410
,p_item_plug_id=>wwv_flow_api.id(24215881936492707)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'Created On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24116161906338606)
,p_name=>'P2_UPDATED_BY_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>420
,p_item_plug_id=>wwv_flow_api.id(24215881936492707)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'Updated By'
,p_source=>'UPDATED_BY_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEE NAME BY PERSONID LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en , person_id',
'from dct_employees_list2'))
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24116567122338606)
,p_name=>'P2_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>430
,p_item_plug_id=>wwv_flow_api.id(24215881936492707)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'Updated On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34056467334009618)
,p_name=>'P2_DOC'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34058493184009638)
,p_name=>'P2_BIRTH_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(24216189822492710)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'Birth Date:'
,p_format_mask=>'DD-MM-YYYY'
,p_source=>'BIRTH_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34058556432009639)
,p_name=>'P2_GENDER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(24216189822492710)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'Gender :'
,p_source=>'SEX'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC2:Male;M,Female;F'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'2'
,p_attribute_02=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34058676037009640)
,p_name=>'P2_PASSPORT_NO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(24216189822492710)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'Passport No'
,p_source=>'PASSPORT_NO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>100
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34058760847009641)
,p_name=>'P2_PASSPORT_EXPIRE_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(24216189822492710)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'Passport Expire Date'
,p_format_mask=>'DD-MM-YYYY'
,p_source=>'PASSPORT_EXPIRE_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34058827252009642)
,p_name=>'P2_UAE_RESIDENCE_NO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(24216189822492710)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'Residence Visa No / Edbarah No:'
,p_source=>'UAE_RESIDENCE_NO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>100
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34058991638009643)
,p_name=>'P2_UAE_RESIDENCE_VISA_EXPIRE_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(24216189822492710)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'UAE Residence Visa Expiry Date:'
,p_format_mask=>'DD-MM-YYYY'
,p_source=>'UAE_RESIDENCE_EXPIRE_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34059002203009644)
,p_name=>'P2_EMIRATES_ID'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(24216189822492710)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'Emirates ID No.:'
,p_source=>'EMIRATES_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>20
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_restricted_characters=>'US_ONLY'
,p_help_text=>'Emirates ID number, without any special characters like: - , / ..etc '
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34059291903009646)
,p_name=>'P2_EMIRATES_ID_EXPIRY_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(24216189822492710)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'Emirates ID Expiry Date:'
,p_format_mask=>'DD-MM-YYYY'
,p_source=>'EMIRATES_ID_EXPIRE_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34059431957009648)
,p_name=>'P2_EMPLOYEE_ID'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(24216189822492710)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'Employee ID:'
,p_source=>'EMPLOYEE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>20
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34279324883651504)
,p_name=>'P2_FULL_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(24216189822492710)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'Full Name:'
,p_source=>'FULL_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>50
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34279443616651505)
,p_name=>'P2_NAME_TO_APPEAR_ON_CARD'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(24216189822492710)
,p_item_source_plug_id=>wwv_flow_api.id(24099022477338621)
,p_prompt=>'Name To Appear On Card:'
,p_source=>'PRINTED_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_cMaxlength=>19
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34283479369651545)
,p_name=>'P2_FINAL_DCT_APPROVAL_DURATION'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(35043772346935301)
,p_name=>'P2_FINAL_BANK_APPROVAL_DURATION'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(24099022477338621)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(34056524789009619)
,p_computation_sequence=>30
,p_computation_item=>'P2_DOC'
,p_computation_point=>'AFTER_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'l_nationality_id         varchar2(20);',
'l_req_doc_count          number;',
'l_attached_doc           number;',
'BEGIN',
'',
'select nationality_id',
'into l_nationality_id',
'from employees_v',
'where person_id = :P2_REQUESTOR_PERSON_ID;  -- 205',
'',
'select count(*)',
'into l_req_doc_count',
'from credit_card_doc_required',
'where LOCAL_EXPAT in (''B'' , decode(l_nationality_id , 101, ''L'' , ''E'')) ;',
'',
'select count(*)',
'into l_attached_doc',
'from credit_cards_documents d , credit_card_doc_required cr',
'where d.doc_required_id = cr.id',
'and d.credit_card_id = :P2_ID',
'and nvl(sys.dbms_lob.getlength(d.file_blob), 0) > 0 ;',
'',
'if l_attached_doc >= l_req_doc_count    Then',
'          return ''Y'' ;',
'          else ',
'          return ''N'' ;',
'',
'End if;  ',
'END;'))
,p_compute_when=>'P2_ID'
,p_compute_when_type=>'ITEM_IS_NOT_NULL'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(23743088654932510)
,p_computation_sequence=>10
,p_computation_item=>'P2_REQUESTOR_ORG_NAME'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select   e.department_name',
'from employees_v e',
'where e.person_id = :P2_REQUESTOR_PERSON_ID;'))
,p_computation_error_message=>'Error in Organization Name'
,p_compute_when_type=>'NEVER'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(23743107094932511)
,p_computation_sequence=>20
,p_computation_item=>'P2_REQUESTOR_SECTOR_NAME'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  sector',
'from employees_v e',
'where e.person_id = :P2_REQUESTOR_PERSON_ID;'))
,p_computation_error_message=>'error in Requestor Sector Name Item'
,p_compute_when_type=>'NEVER'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(34283523012651546)
,p_computation_sequence=>40
,p_computation_item=>'P2_FINAL_DCT_APPROVAL_DURATION'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Duration: '' ',
'        || extract(Day from (final_dct_approval - submission_date)) || '' Day'' ',
'        || ''-'' ',
'        || extract(hour from (final_dct_approval - submission_date)) || '' Hour''',
'        || ''-''',
'        || extract(minute from (final_dct_approval - submission_date)) || '' Min''  as d',
'from credit_cards',
'where id = :P2_ID'))
,p_compute_when=>':P2_DCT_APPROVAL_STATUS in (''Approved'' , ''Rejected'')'
,p_compute_when_type=>'PLSQL_EXPRESSION'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(35043871747935302)
,p_computation_sequence=>50
,p_computation_item=>'P2_FINAL_BANK_APPROVAL_DURATION'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Duration: '' ',
'        || extract(Day from (FINAL_BANK_APPROVAL - final_dct_approval)) || '' Day'' ',
'        || ''-'' ',
'        || extract(hour from (FINAL_BANK_APPROVAL - final_dct_approval)) || '' Hour''',
'        || ''-''',
'        || extract(minute from (FINAL_BANK_APPROVAL - final_dct_approval)) || '' Min''  as d',
'from credit_cards',
'where id = :P2_ID'))
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(24113007561338608)
,p_validation_name=>'P2_SUBMISSION_DATE must be timestamp'
,p_validation_sequence=>330
,p_validation=>'P2_SUBMISSION_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(24112577790338609)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(24113857622338608)
,p_validation_name=>'P2_FINAL_DCT_APPROVAL must be timestamp'
,p_validation_sequence=>340
,p_validation=>'P2_FINAL_DCT_APPROVAL'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(24113362735338608)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(24114650228338607)
,p_validation_name=>'P2_FINAL_BANK_APPROVAL must be timestamp'
,p_validation_sequence=>350
,p_validation=>'P2_FINAL_BANK_APPROVAL'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(24114114988338607)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(24115862184338606)
,p_validation_name=>'P2_CREATED_ON must be timestamp'
,p_validation_sequence=>370
,p_validation=>'P2_CREATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(24115397561338607)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(24117079750338606)
,p_validation_name=>'P2_UPDATED_ON must be timestamp'
,p_validation_sequence=>390
,p_validation=>'P2_UPDATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(24116567122338606)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(23743321444932513)
,p_name=>'set Request Amount Hidden'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P2_REQUESTED_AMOUNT'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(23743454430932514)
,p_event_id=>wwv_flow_api.id(23743321444932513)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_REQUESTED_AMOUNT_H'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>'to_number(:P2_REQUESTED_AMOUNT, ''99,999,999,999.99'')'
,p_attribute_07=>'P2_REQUESTED_AMOUNT'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(24216270868492711)
,p_name=>'Display ADCB Details'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P2_ADCB_CUSTOMER_YN'
,p_condition_element=>'P2_ADCB_CUSTOMER_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(24216390768492712)
,p_event_id=>wwv_flow_api.id(24216270868492711)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_ADCB_MOBILE_REGISTERED,P2_ADCB_EMAIL_REGISTERED'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(24216510937492714)
,p_event_id=>wwv_flow_api.id(24216270868492711)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_ADCB_MOBILE_REGISTERED,P2_ADCB_EMAIL_REGISTERED'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(24216411544492713)
,p_event_id=>wwv_flow_api.id(24216270868492711)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_ADCB_MOBILE_REGISTERED,P2_ADCB_EMAIL_REGISTERED'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(32805493122539645)
,p_name=>'Close Dialog - Submit'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(23742662323932506)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(32805875378539649)
,p_event_id=>wwv_flow_api.id(32805493122539645)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(33460361718009002)
,p_name=>'Rollback DA'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(33460224387009001)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33460468458009003)
,p_event_id=>wwv_flow_api.id(33460361718009002)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Rollback?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33460596234009004)
,p_event_id=>wwv_flow_api.id(33460361718009002)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Begin',
'delete from credit_card_approval_history where CREDIT_CARD_ID = :P2_ID;',
'update credit_cards set DCT_APPROVAL_STATUS = ''Draft'' , BANK_APPROVAL_STATUS = ''Draft'', SUBMISSION_DATE = '''', FINAL_DCT_APPROVAL = '''', FINAL_BANK_APPROVAL ='''' where id = :P2_ID;',
'delete from all_notifications where request_id = :P2_ID;',
'End;'))
,p_attribute_02=>'P2_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33460638809009005)
,p_event_id=>wwv_flow_api.id(33460361718009002)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(33463701687009036)
,p_name=>'Stop Approval'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(23742724131932507)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33463814115009037)
,p_event_id=>wwv_flow_api.id(33463701687009036)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'you are going to withdraw your credit card request, Are you sure that ? '
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33463927308009038)
,p_event_id=>wwv_flow_api.id(33463701687009036)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'credit_cards_workflow.stop(:P2_ID, :P2_APPROVAL_TYPE);',
'end;'))
,p_attribute_02=>'P2_ID,P2_APPROVAL_TYPE'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33464056430009039)
,p_event_id=>wwv_flow_api.id(33463701687009036)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'your credit card request withdrawed successfully.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33464119419009040)
,p_event_id=>wwv_flow_api.id(33463701687009036)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(33702016463949724)
,p_name=>'Dialog Close- Collaboration'
,p_event_sequence=>60
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(33701999076949723)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33702104066949725)
,p_event_id=>wwv_flow_api.id(33702016463949724)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(33700595570949709)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(33703671981949740)
,p_name=>'Dialog Close- Collaborations table'
,p_event_sequence=>70
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(33700595570949709)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33703776238949741)
,p_event_id=>wwv_flow_api.id(33703671981949740)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(33700595570949709)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(34057613310009630)
,p_name=>'Submit Finance DA'
,p_event_sequence=>80
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(34057565523009629)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
,p_display_when_type=>'NEVER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(34057797109009631)
,p_event_id=>wwv_flow_api.id(34057613310009630)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'you will submit this request to all finance managers for approval, Continue?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(34282794121651538)
,p_event_id=>wwv_flow_api.id(34057613310009630)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Begin',
'credit_cards_workflow.Submit_finance_approval(:P2_ID);',
'End;'))
,p_attribute_02=>'P2_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(34282806905651539)
,p_event_id=>wwv_flow_api.id(34057613310009630)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(34279025630651501)
,p_name=>'Set Emp Details when change requestor'
,p_event_sequence=>100
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P2_REQUESTOR_PERSON_ID'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(24677528124466141)
,p_event_id=>wwv_flow_api.id(34279025630651501)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_REQUESTOR_ORG_NAME,P2_REQUESTOR_SECTOR_NAME'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select e.department_name ',
'		, e.sector ',
'from employees_v e',
'where e.person_id = :P2_REQUESTOR_PERSON_ID;'))
,p_attribute_07=>'P2_REQUESTOR_PERSON_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(34279166048651502)
,p_event_id=>wwv_flow_api.id(34279025630651501)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_BIRTH_DATE,P2_GENDER,P2_EMIRATES_ID,P2_NATIONALITY,P2_REQUESTOR_ORG_ID,P2_DEPARTMENT_ID,P2_SECTOR_ID,P2_EMPLOYEE_ID,P2_FULL_NAME,P2_NAME_TO_APPEAR_ON_CARD'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'        substr(e.birth_date,1,10) birth_date ',
'		, e.sex Gender',
'		, e.national_identifier ',
'		, e.nationality_id ',
'		, e.org_id ',
'		, e.department_id ',
'		, e.sector_id ',
'		, employee_num',
'    , e.full_name_en full_name , e.first_name || '' '' || e.last_name as printed_name',
'from employees_v e',
'where e.person_id = :P2_REQUESTOR_PERSON_ID;'))
,p_attribute_07=>'P2_REQUESTOR_PERSON_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'Y'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(34283200175651543)
,p_name=>'New'
,p_event_sequence=>110
,p_condition_element=>'P2_DCT_APPROVAL_STATUS'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Approved'
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(34283328516651544)
,p_event_id=>wwv_flow_api.id(34283200175651543)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_CSS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'.T-FORM-INPUTCONTAINER SPAN.DISPLAY_ONLY'
,p_attribute_01=>'color'
,p_attribute_02=>'lightgreen'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(38397004957258109)
,p_name=>'Print Bank Form DA'
,p_event_sequence=>120
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(35392739327055818)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
,p_display_when_type=>'NEVER'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>219773596381898043
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(38397124048258110)
,p_event_id=>wwv_flow_api.id(38397004957258109)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'javaScript:window.open(''f?p=101:0:&SESSION.:PRINT_REPORT=Petty%20Cash%20Details'' , ''_blank'');'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(24678005650466146)
,p_process_sequence=>20
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'set Default Emp  Details process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select e.department_name , e.sector , substr(e.birth_date,1,10) birth_date , e.sex Gender',
'    ,e.national_identifier , e.nationality_id , e.org_id , e.department_id , e.sector_id , employee_num',
'    , e.full_name_en full_name , e.first_name || '' '' || e.last_name as printed_name',
'into :P2_REQUESTOR_ORG_NAME,:P2_REQUESTOR_SECTOR_NAME,:P2_BIRTH_DATE,:P2_GENDER',
'    ,:P2_EMIRATES_ID, :P2_NATIONALITY,:P2_REQUESTOR_ORG_ID,:P2_DEPARTMENT_ID,:P2_SECTOR_ID',
'    ,:P2_EMPLOYEE_ID, :P2_FULL_NAME, :P2_NAME_TO_APPEAR_ON_CARD',
'from employees_v e',
'where e.person_id = :P2_REQUESTOR_PERSON_ID;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>':P2_ID is null and :P2_APPROVAL_TYPE = 2'
,p_process_when_type=>'PLSQL_EXPRESSION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(24677129063466137)
,p_process_sequence=>30
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'set Default Emp  Details process for increase request'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    e.department_name,',
'    e.sector,',
'    substr(e.birth_date, 1, 10)           birth_date,',
'    e.sex                               gender,',
'    e.national_identifier,',
'    e.nationality_id,',
'    e.org_id,',
'    e.department_id,',
'    e.sector_id,',
'    employee_num,',
'    e.full_name_en                      full_name,',
'    e.first_name',
'    || '' ''',
'    || e.last_name                      AS printed_name,',
'    e.email,',
'    e.position,',
'    e.position_id,',
'    e.person_id',
'INTO',
'    :p2_requestor_org_name,',
'    :p2_requestor_sector_name,',
'    :p2_birth_date,',
'    :p2_gender,',
'    :p2_emirates_id,',
'    :p2_nationality,',
'    :p2_requestor_org_id,',
'    :p2_department_id,',
'    :p2_sector_id,',
'    :p2_employee_id,',
'    :p2_full_name,',
'    :p2_name_to_appear_on_card,',
'    :p2_email,',
'    :p2_position_name,',
'    :p2_position_id,',
'    :P2_REQUESTOR_PERSON_ID',
'FROM',
'    employees_v e',
'WHERE',
'    e.person_id = :p2_new;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>':P2_ID is null and :P2_APPROVAL_TYPE in (3, 4)'
,p_process_when_type=>'PLSQL_EXPRESSION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(76465599804948304)
,p_process_sequence=>40
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'set Default Emp  Details process for decrease request'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    e.department_name,',
'    e.sector,',
'    substr(e.birth_date, 1, 10)           birth_date,',
'    e.sex                               gender,',
'    e.national_identifier,',
'    e.nationality_id,',
'    e.org_id,',
'    e.department_id,',
'    e.sector_id,',
'    employee_num,',
'    e.full_name_en                      full_name,',
'    e.first_name',
'    || '' ''',
'    || e.last_name                      AS printed_name,',
'    e.email,',
'    e.position,',
'    e.position_id,',
'    e.person_id',
'INTO',
'    :p2_requestor_org_name,',
'    :p2_requestor_sector_name,',
'    :p2_birth_date,',
'    :p2_gender,',
'    :p2_emirates_id,',
'    :p2_nationality,',
'    :p2_requestor_org_id,',
'    :p2_department_id,',
'    :p2_sector_id,',
'    :p2_employee_id,',
'    :p2_full_name,',
'    :p2_name_to_appear_on_card,',
'    :p2_email,',
'    :p2_position_name,',
'    :p2_position_id,',
'    :P2_REQUESTOR_PERSON_ID',
'FROM',
'    employees_v e',
'WHERE',
'    e.person_id = :p2_new;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>':P2_ID is null and :P2_APPROVAL_TYPE = 5'
,p_process_when_type=>'PLSQL_EXPRESSION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(18099545221298113)
,p_process_sequence=>50
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get Replacement Details process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select e.full_name_en, e.department_name , cc.notes',
'  --  ID, REQUESTOR_PERSON_ID, DEPARTMENT_ID, NOTES',
' into  :P2_NAME, :P2_DEPARTMENT, :P2_COMMENT',
'from credit_cards cc, employees_v e',
'where cc.requestor_person_id = e.person_id',
'and cc.id = :P2_ID2;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P2_APPROVAL_TYPE'
,p_process_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_process_when2=>'21'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(24132123184338594)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(24099022477338621)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Credit Card Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(24216749912492716)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Insert Required Docuements'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'--credit_cards_workflow.INSERT_REQUIRED_DOC(:PERSON_ID , :P2_ID);',
'credit_cards_workflow.INSERT_REQUIRED_DOC(:P2_REQUESTOR_PERSON_ID , :P2_ID);',
'end;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(24130932710338594)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(24131708134338594)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(24099022477338621)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Credit Card Details'
);
wwv_flow_api.component_end;
end;
/
