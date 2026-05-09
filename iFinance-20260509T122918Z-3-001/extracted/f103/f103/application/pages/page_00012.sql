prompt --application/pages/page_00012
begin
--   Manifest
--     PAGE: 00012
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>116806299474925354
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>12
,p_user_interface_id=>wwv_flow_api.id(23921013981372477)
,p_name=>'Credit Card Notification'
,p_alias=>'CREDIT-CARD-NOTIFICATION'
,p_step_title=>'Credit Card Notification'
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
,p_read_only_when_type=>'PLSQL_EXPRESSION'
,p_read_only_when=>':P12_DCT_APPROVAL_STATUS not in (''Draft'' , ''Withdraw'')'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220309090727'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(35043967287935303)
,p_plug_name=>'Approved Notification'
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--success:t-Alert--removeHeading'
,p_plug_template=>wwv_flow_api.id(23805367112372574)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>'<h3>The credit Card request is approved.</h3>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P12_DCT_APPROVAL_STATUS'
,p_plug_display_when_cond2=>'Approved'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(92571303121274228)
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
 p_id=>wwv_flow_api.id(92571852482274024)
,p_plug_name=>'Credit Card Details'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'CREDIT_CARDS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(92688711941428110)
,p_plug_name=>'Audit Info'
,p_parent_plug_id=>wwv_flow_api.id(92571852482274024)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noUI:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(23819444978372562)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P12_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(92689019827428113)
,p_plug_name=>'Personal Details'
,p_parent_plug_id=>wwv_flow_api.id(92571852482274024)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(92689631173428120)
,p_plug_name=>'Required Documents'
,p_parent_plug_id=>wwv_flow_api.id(92571852482274024)
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
'  and d.credit_card_id = :P12_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P12_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P12_ID'
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
 p_id=>wwv_flow_api.id(92689798060428121)
,p_max_row_count=>'1000000'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>92689798060428121
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34912590721716811)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34912991729716810)
,p_db_column_name=>'DOCUMENT_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Document Name'
,p_column_link=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.::P4_APPROVAL_STATUS,P4_ID:&P2_DCT_APPROVAL_STATUS.,#ID#'
,p_column_linktext=>'#DOCUMENT_NAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34913382789716810)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34913754759716809)
,p_db_column_name=>'CREDIT_CARD_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Credit Card Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34914133250716809)
,p_db_column_name=>'FILENAME'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Attached File'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34914593023716809)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34914993044716809)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34915323357716808)
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
 p_id=>wwv_flow_api.id(34915739818716808)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34916104478716808)
,p_db_column_name=>'TAGS'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34916592667716807)
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
 p_id=>wwv_flow_api.id(34916918979716807)
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
 p_id=>wwv_flow_api.id(34917377306716807)
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
 p_id=>wwv_flow_api.id(34917773937716807)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(24146885424244788)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34918155113716806)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34918593399716806)
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
 p_id=>wwv_flow_api.id(92809087503079927)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'349189'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'DOCUMENT_NAME:FILENAME:FILE_COMMENTS:UPDATED_ON:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(101933531103944409)
,p_plug_name=>'Approval History'
,p_parent_plug_id=>wwv_flow_api.id(92571852482274024)
,p_icon_css_classes=>'fa-list'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--noBorder:t-Region--scrollBody'
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
'and  cc.credit_card_id = :P12_ID',
'order by step_no , ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P12_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P12_ID Is not Null and :P12_DCT_APPROVAL_STATUS not in (''Draft'')'
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
 p_id=>wwv_flow_api.id(101933699228944410)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>101933699228944410
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34905428307716820)
,p_db_column_name=>'STEP_NO'
,p_display_order=>10
,p_column_identifier=>'C'
,p_column_label=>'Step No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34910651086716817)
,p_db_column_name=>'PHOTO'
,p_display_order=>20
,p_column_identifier=>'P'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34910260553716817)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>30
,p_column_identifier=>'O'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34906220915716820)
,p_db_column_name=>'USER_NAME'
,p_display_order=>40
,p_column_identifier=>'E'
,p_column_label=>'User Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34905862831716820)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>50
,p_column_identifier=>'D'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34907072956716819)
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
 p_id=>wwv_flow_api.id(34906697802716820)
,p_db_column_name=>'STATUS'
,p_display_order=>70
,p_column_identifier=>'F'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34907476115716819)
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
 p_id=>wwv_flow_api.id(34904659457716821)
,p_db_column_name=>'ID'
,p_display_order=>90
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34905024418716821)
,p_db_column_name=>'CREDIT_CARD_ID'
,p_display_order=>100
,p_column_identifier=>'B'
,p_column_label=>'Credit Card Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34907886006716819)
,p_db_column_name=>'COMMENTS'
,p_display_order=>110
,p_column_identifier=>'I'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34908277037716818)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>120
,p_column_identifier=>'J'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34908652500716818)
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
 p_id=>wwv_flow_api.id(34909007820716818)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>140
,p_column_identifier=>'L'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34909467472716818)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>150
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34909861894716817)
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
 p_id=>wwv_flow_api.id(34911058736716816)
,p_db_column_name=>'ROLE_DESC'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Role'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(101944844552706347)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'349114'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:PHOTO:FULL_NAME_EN:USER_NAME:ROLE_DESC:ACTION_REQUIRED:RECEVIED_DATE:STATUS:ACTION_DATE:COMMENTS:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(34911858638716813)
,p_report_id=>wwv_flow_api.id(101944844552706347)
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
 p_id=>wwv_flow_api.id(102456336338604721)
,p_plug_name=>'Collaboration'
,p_icon_css_classes=>'fa-comments-o fa-anim-flash fam-sleep fam-is-success'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody:t-Form--slimPadding:margin-left-none'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_column=>9
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P12_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(102456491158604722)
,p_name=>'Comments report'
,p_parent_plug_id=>wwv_flow_api.id(102456336338604721)
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
'where CREDIT_CARD_ID = :P12_ID',
'order by created_on desc;',
''))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P12_ID'
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
 p_id=>wwv_flow_api.id(34924900355716799)
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
 p_id=>wwv_flow_api.id(34925329829716798)
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
 p_id=>wwv_flow_api.id(34925792076716798)
,p_query_column_id=>3
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>3
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(34926107186716797)
,p_query_column_id=>4
,p_column_alias=>'COMMENT_TEXT'
,p_column_display_sequence=>4
,p_column_heading=>'Comment Text'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::P8_COMMENT_ID,P8_PAGE_FROM:#COMMENT_ID#,6'
,p_column_linktext=>'#COMMENT_TEXT#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(34926510024716797)
,p_query_column_id=>5
,p_column_alias=>'COMMENT_MODIFIERS'
,p_column_display_sequence=>5
,p_column_heading=>'Comment Modifiers'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(34926931991716797)
,p_query_column_id=>6
,p_column_alias=>'ICON_MODIFIER'
,p_column_display_sequence=>6
,p_column_heading=>'Icon Modifier'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(34927306481716796)
,p_query_column_id=>7
,p_column_alias=>'ACTIONS'
,p_column_display_sequence=>7
,p_column_heading=>'Actions'
,p_use_as_row_header=>'N'
,p_column_format=>'DOWNLOAD:CREDIT_CARDS_COMMENTS:FILE_BLOB:COMMENT_ID::FILE_MIMETYPE:FILENAME:UPDATED_ON:FILE_CHARSET:inline:#FILENAME#:'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(34927796099716796)
,p_query_column_id=>8
,p_column_alias=>'ATTRIBUTE_1'
,p_column_display_sequence=>8
,p_column_heading=>'Attribute 1'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(34928156385716796)
,p_query_column_id=>9
,p_column_alias=>'ATTRIBUTE_2'
,p_column_display_sequence=>9
,p_column_heading=>'Attribute 2'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(34928576150716796)
,p_query_column_id=>10
,p_column_alias=>'ATTRIBUTE_3'
,p_column_display_sequence=>10
,p_column_heading=>'Attribute 3'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(34928912194716795)
,p_query_column_id=>11
,p_column_alias=>'ATTRIBUTE_4'
,p_column_display_sequence=>11
,p_column_heading=>'Attribute 4'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(34929323113716795)
,p_query_column_id=>12
,p_column_alias=>'FILENAME'
,p_column_display_sequence=>12
,p_column_heading=>'Filename'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(34929707535716795)
,p_query_column_id=>13
,p_column_alias=>'COMMENT_ID'
,p_column_display_sequence=>13
,p_column_heading=>'Comment Id'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(34892867498716846)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(92571303121274228)
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
 p_id=>wwv_flow_api.id(34924281079716801)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(102456336338604721)
,p_button_name=>'Add_Comment'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_image_alt=>'New'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:8:P8_CREDIT_CARD_ID,P8_PAGE_FROM:&P12_ID.,6'
,p_icon_css_classes=>'fa-commenting-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(34892075037716846)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(92571303121274228)
,p_button_name=>'OK'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Ok'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_execute_validations=>'N'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-check'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(34946697910716778)
,p_branch_name=>'Go To Page 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34893905272716839)
,p_name=>'P12_HISTORY_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(92571852482274024)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34894316203716837)
,p_name=>'P12_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(92571852482274024)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
,p_source=>'ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34894703611716837)
,p_name=>'P12_CREATOR_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(92571852482274024)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
,p_item_default=>'PERSON_ID'
,p_item_default_type=>'ITEM'
,p_source=>'CREATOR_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34895160959716837)
,p_name=>'P12_REQUESTOR_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(92571852482274024)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
,p_item_default=>'PERSON_ID'
,p_item_default_type=>'ITEM'
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
,p_attribute_10=>'ORG_ID:P12_REQUESTOR_ORG_ID,DEPARTMENT_ID:P12_DEPARTMENT_ID,SECTOR_ID:P12_SECTOR_ID,DEPARTMENT_NAME:P12_REQUESTOR_ORG_NAME,SECTOR:P12_REQUESTOR_SECTOR_NAME,COST_CENTER_CODE:P12_COST_CENTER,EMAIL:P12_EMAIL,MOBILE:P12_MOBILE_NUMBER,POSITION_ID:P12_POSI'
||'TION_ID,POSITION:P12_POSITION_NAME,EMPLOYEE_NUM:P12_EMPLOYEE_NUMBER'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34895599369716835)
,p_name=>'P12_DCT_APPROVAL_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(92571852482274024)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
,p_item_default=>'Draft'
,p_prompt=>'Status :'
,p_source=>'DCT_APPROVAL_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
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
,p_default_id_offset=>116806299474925354
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34895986316716835)
,p_name=>'P12_REQUESTOR_ORG_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(92571852482274024)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
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
 p_id=>wwv_flow_api.id(34896370626716834)
,p_name=>'P12_DEPARTMENT_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(92571852482274024)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
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
 p_id=>wwv_flow_api.id(34896704370716834)
,p_name=>'P12_REQUESTOR_ORG_NAME'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(92571852482274024)
,p_prompt=>'Requestor Organization :'
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
 p_id=>wwv_flow_api.id(34897156276716834)
,p_name=>'P12_REQUESTED_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(92571852482274024)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
,p_prompt=>'Requested Amount :'
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
 p_id=>wwv_flow_api.id(34897582783716833)
,p_name=>'P12_REQUESTED_AMOUNT_H'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(92571852482274024)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
,p_source=>'REQUESTED_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34897942090716833)
,p_name=>'P12_SECTOR_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(92571852482274024)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
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
 p_id=>wwv_flow_api.id(34898374214716832)
,p_name=>'P12_REQUESTOR_SECTOR_NAME'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(92571852482274024)
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
 p_id=>wwv_flow_api.id(34898707225716832)
,p_name=>'P12_SUBMISSION_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(92571852482274024)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
,p_prompt=>'Submission Date :'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'SUBMISSION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>':P12_DCT_APPROVAL_STATUS not in (''Draft'' , ''Withdraw'')'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34899192460716831)
,p_name=>'P12_COST_CENTER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(92571852482274024)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
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
 p_id=>wwv_flow_api.id(34899544537716831)
,p_name=>'P12_PURPOSE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(92571852482274024)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
,p_prompt=>'Purpose :'
,p_placeholder=>'Please identify the purpose for your credit card request'
,p_source=>'PURPOSE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>120
,p_cMaxlength=>4000
,p_cHeight=>4
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34899981619716830)
,p_name=>'P12_NOTES'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(92571852482274024)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
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
 p_id=>wwv_flow_api.id(34900310551716830)
,p_name=>'P12_APPROVED_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(92571852482274024)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
,p_source=>'APPROVED_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34900728258716830)
,p_name=>'P12_EMPLOYEE_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(92571852482274024)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
,p_item_default=>'EMP_NUM'
,p_item_default_type=>'ITEM'
,p_source=>'EMPLOYEE_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34901110812716829)
,p_name=>'P12_ADCB_CUSTOMER_YN'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(92571852482274024)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
,p_prompt=>'ADCB Customer ? '
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
 p_id=>wwv_flow_api.id(34901579801716829)
,p_name=>'P12_ADCB_MOBILE_REGISTERED'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(92571852482274024)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
,p_prompt=>'ADCB Registered Mobile :'
,p_source=>'ADCB_MOBILE_REGISTERED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>20
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34901995452716829)
,p_name=>'P12_ADCB_EMAIL_REGISTERED'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(92571852482274024)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
,p_prompt=>'ADCB Registered Email :'
,p_source=>'ADCB_EMAIL_REGISTERED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>20
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34902328981716828)
,p_name=>'P12_BANK_APPROVAL_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(92571852482274024)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
,p_source=>'BANK_APPROVAL_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34902702347716828)
,p_name=>'P12_FINAL_DCT_APPROVAL'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>330
,p_item_plug_id=>wwv_flow_api.id(92571852482274024)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
,p_source=>'FINAL_DCT_APPROVAL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34903173466716828)
,p_name=>'P12_FINAL_BANK_APPROVAL'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>340
,p_item_plug_id=>wwv_flow_api.id(92571852482274024)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
,p_source=>'FINAL_BANK_APPROVAL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34919688262716805)
,p_name=>'P12_CREATED_BY_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>400
,p_item_plug_id=>wwv_flow_api.id(92688711941428110)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
,p_prompt=>'Created By Person Id'
,p_source=>'CREATED_BY_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(23897160841372512)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34920060365716805)
,p_name=>'P12_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>410
,p_item_plug_id=>wwv_flow_api.id(92688711941428110)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
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
 p_id=>wwv_flow_api.id(34920439128716804)
,p_name=>'P12_UPDATED_BY_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>420
,p_item_plug_id=>wwv_flow_api.id(92688711941428110)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
,p_prompt=>'Updated By Person Id'
,p_source=>'UPDATED_BY_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(23897160841372512)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34920832250716804)
,p_name=>'P12_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>430
,p_item_plug_id=>wwv_flow_api.id(92688711941428110)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
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
 p_id=>wwv_flow_api.id(34921580293716804)
,p_name=>'P12_MOTHER_NAME'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(92689019827428113)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
,p_prompt=>'Mother Name :'
,p_source=>'MOTHER_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
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
 p_id=>wwv_flow_api.id(34921928961716803)
,p_name=>'P12_EMAIL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(92689019827428113)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select   e.email',
'from employees_v e',
'where e.person_id = :PERSON_ID'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Email :'
,p_source=>'EMAIL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
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
 p_id=>wwv_flow_api.id(34922331296716803)
,p_name=>'P12_MOBILE_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(92689019827428113)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select   e.mobile',
'from employees_v e',
'where e.person_id = :PERSON_ID'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Mobile Number :'
,p_source=>'MOBILE_NUMBER'
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
 p_id=>wwv_flow_api.id(34922765406716803)
,p_name=>'P12_OFFICE_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(92689019827428113)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
,p_prompt=>'Office Number :'
,p_source=>'OFFICE_NUMBER'
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
 p_id=>wwv_flow_api.id(34923165369716802)
,p_name=>'P12_POSITION_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(92689019827428113)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
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
 p_id=>wwv_flow_api.id(34923512014716802)
,p_name=>'P12_POSITION_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(92689019827428113)
,p_item_source_plug_id=>wwv_flow_api.id(92571852482274024)
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
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(34940273118716784)
,p_computation_sequence=>10
,p_computation_item=>'P12_REQUESTOR_ORG_NAME'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select   e.department_name',
'from employees_v e',
'where e.person_id = :P12_REQUESTOR_PERSON_ID;'))
,p_computation_error_message=>'Error in Organization Name'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(34940606872716784)
,p_computation_sequence=>20
,p_computation_item=>'P12_REQUESTOR_SECTOR_NAME'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  sector',
'from employees_v e',
'where e.person_id = :P12_REQUESTOR_PERSON_ID;'))
,p_computation_error_message=>'error in Requestor Sector Name Item'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(34941025466716783)
,p_validation_name=>'P12_SUBMISSION_DATE must be timestamp'
,p_validation_sequence=>330
,p_validation=>'P12_SUBMISSION_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(34898707225716832)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(34941495213716782)
,p_validation_name=>'P12_FINAL_DCT_APPROVAL must be timestamp'
,p_validation_sequence=>340
,p_validation=>'P12_FINAL_DCT_APPROVAL'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(34902702347716828)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(34941856981716782)
,p_validation_name=>'P12_FINAL_BANK_APPROVAL must be timestamp'
,p_validation_sequence=>350
,p_validation=>'P12_FINAL_BANK_APPROVAL'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(34903173466716828)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(34942238476716782)
,p_validation_name=>'P12_CREATED_ON must be timestamp'
,p_validation_sequence=>370
,p_validation=>'P12_CREATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(34920060365716805)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(34942623263716782)
,p_validation_name=>'P12_UPDATED_ON must be timestamp'
,p_validation_sequence=>390
,p_validation=>'P12_UPDATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(34920832250716804)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(34945287417716779)
,p_name=>'set Request Amount Hidden'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P12_REQUESTED_AMOUNT'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(34945703187716779)
,p_event_id=>wwv_flow_api.id(34945287417716779)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_REQUESTED_AMOUNT_H'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>'to_number(:P12_REQUESTED_AMOUNT, ''99,999,999,999.99'')'
,p_attribute_07=>'P12_REQUESTED_AMOUNT'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(34943389218716781)
,p_name=>'Display ADCB Details'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P12_ADCB_CUSTOMER_YN'
,p_condition_element=>'P12_ADCB_CUSTOMER_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(34944305817716780)
,p_event_id=>wwv_flow_api.id(34943389218716781)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_ADCB_MOBILE_REGISTERED,P12_ADCB_EMAIL_REGISTERED'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(34944816891716780)
,p_event_id=>wwv_flow_api.id(34943389218716781)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_ADCB_MOBILE_REGISTERED,P12_ADCB_EMAIL_REGISTERED'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(34943819027716780)
,p_event_id=>wwv_flow_api.id(34943389218716781)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_ADCB_MOBILE_REGISTERED,P12_ADCB_EMAIL_REGISTERED'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(34283642075651547)
,p_name=>'Set Acknowledge '
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(34892075037716846)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(34283748120651548)
,p_event_id=>wwv_flow_api.id(34283642075651547)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update all_notifications',
'set ACKNOWLEDGE = ''Y''',
'where PERSON_ID = :PERSON_ID',
'and REQUEST_ID = :P12_ID',
'and id = :P12_HISTORY_ID;'))
,p_attribute_02=>'P12_ID,P12_HISTORY_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(34283834213651549)
,p_event_id=>wwv_flow_api.id(34283642075651547)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(34903940279716826)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(92571852482274024)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Credit Card Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(34903504893716828)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(92571852482274024)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Credit Card Details'
);
wwv_flow_api.component_end;
end;
/
