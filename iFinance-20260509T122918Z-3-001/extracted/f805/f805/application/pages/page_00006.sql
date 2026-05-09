prompt --application/pages/page_00006
begin
--   Manifest
--     PAGE: 00006
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
 p_id=>6
,p_user_interface_id=>wwv_flow_api.id(36116058293523070)
,p_name=>'Service Provider Details'
,p_alias=>'SERVICE-PROVIDER-DETAILS'
,p_step_title=>'Service Provider Details'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_javascript_code_onload=>'document.getElementById("P6_VENDOR_SITE_CODE").readOnly = true;'
,p_step_template=>wwv_flow_api.id(35989466215523169)
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210824131351'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(36394443100061910)
,p_plug_name=>'Audit Info'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36014471908523151)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(36395752280061923)
,p_plug_name=>'Photo'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(36519023324372142)
,p_plug_name=>'Service Provider Details'
,p_icon_css_classes=>'fa-info-circle-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'SERVICE_PROVIDERS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(36394098036061906)
,p_plug_name=>'<span aria-hidden="true" class="fa fa-number-5-o "> Basic Details</span>'
,p_parent_plug_id=>wwv_flow_api.id(36519023324372142)
,p_region_template_options=>'#DEFAULT#:t-Region--accent1:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(36394231257061908)
,p_plug_name=>'Address'
,p_parent_plug_id=>wwv_flow_api.id(36394098036061906)
,p_icon_css_classes=>'fa-address-card-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>70
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(36394142728061907)
,p_plug_name=>'<span aria-hidden="true" class="fa fa-number-4-o "> Contact Details</span>'
,p_parent_plug_id=>wwv_flow_api.id(36519023324372142)
,p_region_template_options=>'#DEFAULT#:t-Region--accent1:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(36394543904061911)
,p_plug_name=>'<span aria-hidden="true" class="fa fa-number-3-o "> Vendor Details</span>'
,p_parent_plug_id=>wwv_flow_api.id(36519023324372142)
,p_region_template_options=>'#DEFAULT#:t-Region--accent1:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(36395806025061924)
,p_plug_name=>'<span aria-hidden="true" class="fa fa-number-6-o "> Documents</span>'
,p_parent_plug_id=>wwv_flow_api.id(36519023324372142)
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--accent1:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>70
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P6_SERVICE_PROVIDER_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(36398126481061947)
,p_plug_name=>'Documents Report'
,p_parent_plug_id=>wwv_flow_api.id(36395806025061924)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(36029582862523142)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       SERVICE_PROVIDER_ID,',
'       FILENAME,',
'       MIMETYPE,',
'       DOC_CHARSET,',
'       sys.dbms_lob.getlength(DOC_BLOB) as download,',
'       LAST_UPDATE_DATE,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       NOTES',
'  from SERVICE_PROVIDER_DOCUMENTS',
' where SERVICE_PROVIDER_ID = :P6_SERVICE_PROVIDER_ID',
' order by Updated_ON'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P6_SERVICE_PROVIDER_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
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
 p_id=>wwv_flow_api.id(36398317544061949)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No documents attached.'
,p_show_search_bar=>'N'
,p_show_detail_link=>'C'
,p_detail_link=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::P8_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>36398317544061949
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36398466970061950)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36730213109215601)
,p_db_column_name=>'SERVICE_PROVIDER_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Service Provider Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36730346671215602)
,p_db_column_name=>'FILENAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'File name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36730468569215603)
,p_db_column_name=>'MIMETYPE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36730588680215604)
,p_db_column_name=>'DOC_CHARSET'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Doc Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36730729534215606)
,p_db_column_name=>'LAST_UPDATE_DATE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Update ON'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36730832811215607)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(36664110333548073)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36730994978215608)
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
 p_id=>wwv_flow_api.id(36731030813215609)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(36664110333548073)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36731141777215610)
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
 p_id=>wwv_flow_api.id(36731205040215611)
,p_db_column_name=>'NOTES'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36732290255215621)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>130
,p_column_identifier=>'M'
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
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:SERVICE_PROVIDER_DOCUMENTS:DOC_BLOB:ID::MIMETYPE:FILENAME:LAST_UPDATE_DATE:DOC_CHARSET:inline::'
,p_rpt_show_filter_lov=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(36739620896209992)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'367397'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:SERVICE_PROVIDER_ID:FILENAME:MIMETYPE:DOC_CHARSET:LAST_UPDATE_DATE:CREATED_BY:CREATED_ON:UPDATED_BY:UPDATED_ON:NOTES:DOWNLOAD'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(36395905449061925)
,p_plug_name=>'<span aria-hidden="true" class="fa fa-number-2-o "> Bank Accounts</span>'
,p_parent_plug_id=>wwv_flow_api.id(36519023324372142)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--accent1:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P6_SERVICE_PROVIDER_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(36396047580061926)
,p_plug_name=>'Bank Account Report'
,p_parent_plug_id=>wwv_flow_api.id(36395905449061925)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(36029582862523142)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       SERVICE_PROVIDER_ID,',
'       BANK_NAME,',
'       IBAN,',
'       BANK_LETTER_FILENAME,',
'       BANK_LETTER_MIMETYPE,',
'       BANK_LETTER_CHARSET,',
'       sys.dbms_lob.getlength(BANK_LETTER_BLOB) as download,',
'       BANK_LETTER_UPDATE_DATE,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       BRANCH_NAME,',
'       ACCOUNT_NUMBER',
'  from SERVICE_PROVIDER_BANK_ACCOUNTS',
' where SERVICE_PROVIDER_ID = :P6_SERVICE_PROVIDER_ID',
' order by updated_on'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P6_SERVICE_PROVIDER_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Bank Account Report'
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
 p_id=>wwv_flow_api.id(36396127038061927)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Bank accounts defined'
,p_show_search_bar=>'N'
,p_show_detail_link=>'C'
,p_detail_link=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.::P7_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>36396127038061927
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36396286106061928)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36396388644061929)
,p_db_column_name=>'SERVICE_PROVIDER_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Service Provider Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36396427324061930)
,p_db_column_name=>'BANK_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Bank Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36396505672061931)
,p_db_column_name=>'IBAN'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'IBAN'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36396616780061932)
,p_db_column_name=>'BANK_LETTER_FILENAME'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Bank Letter Filename'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36396758959061933)
,p_db_column_name=>'BANK_LETTER_MIMETYPE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Bank Letter Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36396874085061934)
,p_db_column_name=>'BANK_LETTER_CHARSET'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Bank Letter Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36397018365061936)
,p_db_column_name=>'BANK_LETTER_UPDATE_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Bank Letter Update Date'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36397116139061937)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(36664110333548073)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36397243185061938)
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
 p_id=>wwv_flow_api.id(36397321792061939)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(36664110333548073)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36397410669061940)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36397541113061941)
,p_db_column_name=>'BRANCH_NAME'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Branch Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36397665208061942)
,p_db_column_name=>'ACCOUNT_NUMBER'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Account Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36732300618215622)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>160
,p_column_identifier=>'P'
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
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:SERVICE_PROVIDER_BANK_ACCOUNTS:BANK_LETTER_BLOB:ID::BANK_LETTER_MIMETYPE:BANK_LETTER_FILENAME:BANK_LETTER_UPDATE_DATE:BANK_LETTER_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(36698012830291192)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'366981'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'BANK_NAME:IBAN:ACCOUNT_NUMBER:UPDATED_BY:UPDATED_ON::DOWNLOAD'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(36732473764215623)
,p_plug_name=>'<span aria-hidden="true" class="fa fa-number-7-o "> Others</span>'
,p_parent_plug_id=>wwv_flow_api.id(36519023324372142)
,p_region_template_options=>'#DEFAULT#:t-Region--accent1:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>80
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(36732848406215627)
,p_plug_name=>'<span aria-hidden="true" class="fa fa-number-1-o "> Finance Details</span>'
,p_parent_plug_id=>wwv_flow_api.id(36519023324372142)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--accent1:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(37127044517203019)
,p_plug_name=>'Display Selector'
,p_parent_plug_id=>wwv_flow_api.id(36519023324372142)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_DISPLAY_SELECTOR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'STANDARD'
,p_attribute_02=>'Y'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(36575435655372078)
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
 p_id=>wwv_flow_api.id(38431280996545422)
,p_plug_name=>'Actions'
,p_icon_css_classes=>'fa-arrow-circle-o-right'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-LinksList--actions:t-LinksList--showIcons'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_03'
,p_list_id=>wwv_flow_api.id(38429843679545426)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(36090533719523101)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(36394870493061914)
,p_button_sequence=>410
,p_button_plug_id=>wwv_flow_api.id(36394543904061911)
,p_button_name=>'CLEAR_VENDOR'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link'
,p_button_template_id=>wwv_flow_api.id(36092801396523098)
,p_button_image_alt=>'Clear Vendor'
,p_button_position=>'BODY'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-undo'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(36397775969061943)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(36395905449061925)
,p_button_name=>'Add'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(36093683257523097)
,p_button_image_alt=>'New Bank Account'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:6:P7_SERVICE_PROVIDER_ID,P7_PAGE_FROM:&P6_SERVICE_PROVIDER_ID.,6'
,p_icon_css_classes=>'fa-plus-square-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(36398004567061946)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(36395806025061924)
,p_button_name=>'Add_Attachement'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(36093683257523097)
,p_button_image_alt=>'Add document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:8:P8_SERVICE_PROVIDER_ID:&P6_SERVICE_PROVIDER_ID.'
,p_icon_css_classes=>'fa-files-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(36552016006372108)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(36575435655372078)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(36093542201523097)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(36552842266372106)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(36575435655372078)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(36093542201523097)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition=>'P6_SERVICE_PROVIDER_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(36553258501372105)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(36575435655372078)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(36093542201523097)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P6_SERVICE_PROVIDER_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(36553657442372105)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(36575435655372078)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(36093542201523097)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P6_SERVICE_PROVIDER_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(36553918805372105)
,p_branch_action=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36394647247061912)
,p_name=>'P6_VENDOR_SITE_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>420
,p_item_plug_id=>wwv_flow_api.id(36394543904061911)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Vendor Site Code'
,p_source=>'VENDOR_SITE_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>50
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36394742930061913)
,p_name=>'P6_VENDOR_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>400
,p_item_plug_id=>wwv_flow_api.id(36394543904061911)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Vendor'
,p_source=>'VENDOR_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'VENDORS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select vendors.vendor_name , Vendor_site_code , vendor_number',
'from vendors',
'where vendor_site_status = ''Active'''))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_cMaxlength=>50
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_07=>'Select Vendor'
,p_attribute_10=>'VENDOR_SITE_CODE:P6_VENDOR_SITE_CODE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36395551116061921)
,p_name=>'P6_PHOTO'
,p_source_data_type=>'BLOB'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(36395752280061923)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Photo'
,p_source=>'PHOTO_BLOB'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_IMAGE'
,p_field_template=>wwv_flow_api.id(36092359100523099)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'DB_COLUMN'
,p_attribute_04=>'PHOTO_FILENAME'
,p_attribute_05=>'PHOTO_LAST_UPDATE'
,p_attribute_07=>'PHOTO_MIMETYPE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36519371320372141)
,p_name=>'P6_SERVICE_PROVIDER_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(36519023324372142)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_source=>'SERVICE_PROVIDER_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36519742068372135)
,p_name=>'P6_FIRST_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(36732473764215623)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'First Name'
,p_source=>'FIRST_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36520131874372133)
,p_name=>'P6_SECOND_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(36732473764215623)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Second Name'
,p_source=>'SECOND_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36520551712372133)
,p_name=>'P6_LAST_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(36732473764215623)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Last Name'
,p_source=>'LAST_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36520972226372132)
,p_name=>'P6_FIRST_NAME_AR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(36732473764215623)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'First Name Ar'
,p_source=>'FIRST_NAME_AR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
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
 p_id=>wwv_flow_api.id(36521351037372132)
,p_name=>'P6_SECOND_NAME_AR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(36732473764215623)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Second Name Ar'
,p_source=>'SECOND_NAME_AR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36521798901372132)
,p_name=>'P6_LAST_NAME_AR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(36732473764215623)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Last Name Ar'
,p_source=>'LAST_NAME_AR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36522184738372132)
,p_name=>'P6_FULL_NAME_EN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(36519023324372142)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Full Name'
,p_source=>'FULL_NAME_EN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36522540915372131)
,p_name=>'P6_FULL_NAME_AR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(36732473764215623)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Full Name Ar'
,p_source=>'FULL_NAME_AR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36522904103372131)
,p_name=>'P6_TITLE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(36732473764215623)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Title'
,p_source=>'TITLE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'TITLE LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct DCT_EMPLOYEES_LIST2.TITLE as TITLE ,',
'        DCT_EMPLOYEES_LIST2.TITLE as Return',
' from DCT_EMPLOYEES_LIST2 DCT_EMPLOYEES_LIST2'))
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36523369578372131)
,p_name=>'P6_NATIONAL_IDENTIFIER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(36394098036061906)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'National Identifier'
,p_source=>'NATIONAL_IDENTIFIER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>50
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36523730545372130)
,p_name=>'P6_PASSPORT_NUM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(36394098036061906)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Passport Num'
,p_source=>'PASSPORT_NUM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>50
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36524184571372130)
,p_name=>'P6_EMAIL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(36394142728061907)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Email'
,p_source=>'EMAIL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36524501411372130)
,p_name=>'P6_MOBILE_NO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(36394142728061907)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Mobile No'
,p_source=>'MOBILE_NO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>20
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36524937661372130)
,p_name=>'P6_NATIONALITY_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(36394098036061906)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Nationality'
,p_source=>'NATIONALITY_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'NATIONALITY LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_e_user , desc_e) display ',
'        ,code return ',
'from dct_employees_lookups where lookup_name = ''Nationality Code''',
'order by 1'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_cMaxlength=>20
,p_field_template=>wwv_flow_api.id(36092465792523099)
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
 p_id=>wwv_flow_api.id(36525327922372129)
,p_name=>'P6_ACTIVITIES'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(36732473764215623)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Activities'
,p_source=>'ACTIVITIES'
,p_source_type=>'REGION_SOURCE_COLUMN'
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
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--xlarge'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'1'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36525769842372129)
,p_name=>'P6_OTHER_ACTIVITY_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(36732473764215623)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Other Activity Name'
,p_source=>'OTHER_ACTIVITY_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--xlarge'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36526115045372129)
,p_name=>'P6_EVENT_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(36732473764215623)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Event Name'
,p_source=>'EVENT_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36526540171372128)
,p_name=>'P6_ORG_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(36394543904061911)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Organization'
,p_source=>'ORG_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36526922197372128)
,p_name=>'P6_DEPARTMENT_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(36732848406215627)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Department / Organization'
,p_source=>'DEPARTMENT_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'ORGANIZATIONS WITH COST CENTER- ALL LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
' select nvl(org_name_en_user ,org_name_en ) org_name',
'        , org_id',
'        , cost_center_code ',
' from dct_hr_organizations;'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_07=>'Select Department'
,p_attribute_10=>'COST_CENTER_CODE:P6_COST_CENTER'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36527306228372128)
,p_name=>'P6_PO_BOX'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(36394231257061908)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'P.O Box'
,p_source=>'PO_BOX'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>15
,p_cMaxlength=>20
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36527717278372128)
,p_name=>'P6_ADDRESS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(36394231257061908)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Address'
,p_source=>'ADDRESS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>120
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36528113651372127)
,p_name=>'P6_CITY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(36394231257061908)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'City'
,p_source=>'CITY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_AUTO_COMPLETE'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select SERVICE_PROVIDERS.CITY as CITY ',
' from SERVICE_PROVIDERS SERVICE_PROVIDERS'))
,p_cSize=>60
,p_cMaxlength=>128
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'CONTAINS_IGNORE'
,p_attribute_04=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36528515842372127)
,p_name=>'P6_EMIRATE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(36394231257061908)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Emirate'
,p_source=>'EMIRATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>128
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36528911366372127)
,p_name=>'P6_COUNTRY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(36394231257061908)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Country'
,p_source=>'COUNTRY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'COUNTRIES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(DESC_E_USER ,DESC_E ) Country, nvl(DESC_A_USER ,DESC_A ) Country_ar, CODE r',
'from dct_employees_lookups',
'where LOOKUP_NUMBER = 1',
''))
,p_lov_display_null=>'YES'
,p_cSize=>32
,p_cMaxlength=>20
,p_field_template=>wwv_flow_api.id(36092465792523099)
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
 p_id=>wwv_flow_api.id(36529390316372126)
,p_name=>'P6_PHOTO_FILENAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(36395752280061923)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_source=>'PHOTO_FILENAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36529797844372126)
,p_name=>'P6_PHOTO_MIMETYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(36395752280061923)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_source=>'PHOTO_MIMETYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36530132155372126)
,p_name=>'P6_PHOTO_CHARSET'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(36395752280061923)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_source=>'PHOTO_CHARSET'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36530517537372125)
,p_name=>'P6_PHOTO_BLOB'
,p_source_data_type=>'BLOB'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(36395752280061923)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Browse'
,p_source=>'PHOTO_BLOB'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_FILE'
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'DB_COLUMN'
,p_attribute_02=>'PHOTO_MIMETYPE'
,p_attribute_03=>'PHOTO_FILENAME'
,p_attribute_04=>'PHOTO_CHARSET'
,p_attribute_05=>'PHOTO_LAST_UPDATE'
,p_attribute_06=>'Y'
,p_attribute_08=>'attachment'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36530987889372125)
,p_name=>'P6_PHOTO_LAST_UPDATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(36395752280061923)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Photo Last Update'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'PHOTO_LAST_UPDATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36531743396372122)
,p_name=>'P6_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(36519023324372142)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_item_default=>'A'
,p_prompt=>'Status'
,p_source=>'STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'STATUS LOV'
,p_lov=>'.'||wwv_flow_api.id(36332269880816961)||'.'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36532156879372122)
,p_name=>'P6_SEX'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>330
,p_item_plug_id=>wwv_flow_api.id(36394098036061906)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Gender'
,p_source=>'SEX'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'GENDER LOV'
,p_lov=>'.'||wwv_flow_api.id(36649721030297905)||'.'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36532553949372122)
,p_name=>'P6_PERSON_TYPE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>340
,p_item_plug_id=>wwv_flow_api.id(36394098036061906)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_item_default=>'106'
,p_prompt=>'Person Type'
,p_source=>'PERSON_TYPE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'DCT PERSON TYPES - ALL LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id ',
'from DCT_LOOKUP_VALUES ',
'where lookup_id = 21;'))
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36532948667372121)
,p_name=>'P6_USER_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(36519023324372142)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'User Name'
,p_source=>'USER_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36533300473372121)
,p_name=>'P6_PASSWORD'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(36519023324372142)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Password'
,p_source=>'PASSWORD'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_PASSWORD'
,p_cSize=>60
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36534100483372121)
,p_name=>'P6_CHANGE_PASSWORD'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(36519023324372142)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Change Password'
,p_source=>'CHANGE_PASSWORD'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>1
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36534565428372120)
,p_name=>'P6_COST_CENTER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>390
,p_item_plug_id=>wwv_flow_api.id(36732848406215627)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Cost Center'
,p_source=>'COST_CENTER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>10
,p_cMaxlength=>7
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36534935849372120)
,p_name=>'P6_CREATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>400
,p_item_plug_id=>wwv_flow_api.id(36394443100061910)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Created By'
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMP FULL NAME BY PERSON ID LOV'
,p_display_when=>'P6_SERVICE_PROVIDER_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36535352878372120)
,p_name=>'P6_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>410
,p_item_plug_id=>wwv_flow_api.id(36394443100061910)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Created On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P6_SERVICE_PROVIDER_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36536133525372119)
,p_name=>'P6_UPDATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>420
,p_item_plug_id=>wwv_flow_api.id(36394443100061910)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Updated By'
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMP FULL NAME BY PERSON ID LOV'
,p_display_when=>'P6_SERVICE_PROVIDER_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36536546248372119)
,p_name=>'P6_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>430
,p_item_plug_id=>wwv_flow_api.id(36394443100061910)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Updated On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P6_SERVICE_PROVIDER_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36537378922372119)
,p_name=>'P6_SOURCE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>440
,p_item_plug_id=>wwv_flow_api.id(36732473764215623)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Source'
,p_source=>'SOURCE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36538154428372118)
,p_name=>'P6_PERSON_CATEGORY_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>350
,p_item_plug_id=>wwv_flow_api.id(36394098036061906)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Category'
,p_source=>'PERSON_CATEGORY_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'FREELANCER CATEGORIES- ACTIVE LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id ',
'from DCT_LOOKUP_VALUES ',
'where lookup_id = 22',
'and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10);'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select Category -'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36732524353215624)
,p_name=>'P6_PROJECT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>430
,p_item_plug_id=>wwv_flow_api.id(36732848406215627)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Default Project'
,p_source=>'PROJECT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'NON CWIP PROJECTS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  PROJECT.PROJECT_NAME    ||',
'        '' (''                    ||',
'        PROJECT.PROJECT_NUMBER  ||',
'        '')''                         as PROJECT_NAME,',
'    PROJECT.PROJECT_NUMBER as PROJECT_NUMBER ',
' from PROJECT PROJECT',
' where project_type in (''Operational'' , ''Non GL Integrated'')',
' order by project_number;'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_cMaxlength=>12
,p_field_template=>wwv_flow_api.id(36092465792523099)
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
 p_id=>wwv_flow_api.id(36732640956215625)
,p_name=>'P6_TASK_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>440
,p_item_plug_id=>wwv_flow_api.id(36732848406215627)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Default Task'
,p_source=>'TASK_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'TASK NUMBER BY P6_PROJECT LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select task_number Task_number,',
'        task_number r',
'from task',
'WHERE project_number = nvl(:P6_PROJECT_NUMBER , :P10_PROJECT_NUMBER)'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P6_PROJECT_NUMBER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36732780254215626)
,p_name=>'P6_EXPENDITURE_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>450
,p_item_plug_id=>wwv_flow_api.id(36732848406215627)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'Default Expenditure Type'
,p_source=>'EXPENDITURE_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'EXPENDITURE BY P6_PROJECT AND P6_TASK LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select description , ',
'        description d,',
'        gl_account,',
'        GL_ACCOUNT_DESCRIPTION',
'from expenditure',
'where project_number = nvl(:P6_PROJECT_NUMBER , :P10_PROJECT_NUMBER)',
'and task_number = nvl(:P6_TASK_NUMBER , :P10_TASK_NUMBER)',
'order by 1'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P6_TASK_NUMBER'
,p_ajax_items_to_submit=>'P6_PROJECT_NUMBER,P6_TASK_NUMBER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38397292023258111)
,p_name=>'P6_GL_ACCOUNT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>460
,p_item_plug_id=>wwv_flow_api.id(36732848406215627)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'GL Account'
,p_post_element_text=>'&nbsp; &P6_GL_ACCOUNT_H.'
,p_source=>'GL_ACCOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>6
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38397339517258112)
,p_name=>'P6_GL_BUDGET_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>480
,p_item_plug_id=>wwv_flow_api.id(36732848406215627)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'GL Budget Code'
,p_post_element_text=>'&nbsp; &P6_GL_BUDGET_CODE_H.'
,p_source=>'GL_BUDGET_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>1
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38397414556258113)
,p_name=>'P6_GL_ACTIVITY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>500
,p_item_plug_id=>wwv_flow_api.id(36732848406215627)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'GL Activity'
,p_post_element_text=>'&nbsp; &P6_GL_ACTIVITY_H.'
,p_source=>'GL_ACTIVITY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>6
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
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
 p_id=>wwv_flow_api.id(38397582756258114)
,p_name=>'P6_GL_FUTURE1'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>520
,p_item_plug_id=>wwv_flow_api.id(36732848406215627)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'GL Future1'
,p_post_element_text=>'&nbsp; &P6_GL_FUTURE1_H.'
,p_source=>'GL_FUTURE1'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>6
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38397642576258115)
,p_name=>'P6_GL_FUTURE2'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>540
,p_item_plug_id=>wwv_flow_api.id(36732848406215627)
,p_item_source_plug_id=>wwv_flow_api.id(36519023324372142)
,p_prompt=>'GL Future2'
,p_post_element_text=>'&nbsp; &P6_GL_FUTURE2_H.'
,p_source=>'GL_FUTURE2'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>6
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38397786198258116)
,p_name=>'P6_GL_BUDGET_CODE_H'
,p_item_sequence=>490
,p_item_plug_id=>wwv_flow_api.id(36732848406215627)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT BUDGET_GROUP_DESCRIPTION ',
'from dct_gl_code_combinations_all',
'where BUDGET_CODE = :P6_GL_BUDGET_CODE'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38398101820258120)
,p_name=>'P6_GL_ACCOUNT_H'
,p_item_sequence=>470
,p_item_plug_id=>wwv_flow_api.id(36732848406215627)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT  ACCOUNT_DESCRIPTION',
'from dct_gl_code_combinations_all',
'where ACCOUNT_CODE = :P6_GL_ACCOUNT'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38398233413258121)
,p_name=>'P6_GL_ACTIVITY_H'
,p_item_sequence=>510
,p_item_plug_id=>wwv_flow_api.id(36732848406215627)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT  ACTIVITY_DESCRIPTION',
'from dct_gl_code_combinations_all',
'where ACTIVITY_CODE  = :P6_GL_ACTIVITY'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38398397010258122)
,p_name=>'P6_GL_FUTURE1_H'
,p_item_sequence=>530
,p_item_plug_id=>wwv_flow_api.id(36732848406215627)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT  FUTURE1_DESCRIPTION',
'from dct_gl_code_combinations_all',
'where FUTURE1  = :P6_GL_FUTURE1'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38398477589258123)
,p_name=>'P6_GL_FUTURE2_H'
,p_item_sequence=>550
,p_item_plug_id=>wwv_flow_api.id(36732848406215627)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT FUTURE2_DESCRIPTION',
'from dct_gl_code_combinations_all',
'where FUTURE2   = :P6_GL_FUTURE2'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(36531463107372122)
,p_validation_name=>'P6_PHOTO_LAST_UPDATE must be timestamp'
,p_validation_sequence=>290
,p_validation=>'P6_PHOTO_LAST_UPDATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(36530987889372125)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(36535862516372119)
,p_validation_name=>'P6_CREATED_ON must be timestamp'
,p_validation_sequence=>390
,p_validation=>'P6_CREATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(36535352878372120)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(36537023643372119)
,p_validation_name=>'P6_UPDATED_ON must be timestamp'
,p_validation_sequence=>410
,p_validation=>'P6_UPDATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(36536546248372119)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(36394947708061915)
,p_name=>'Clear Vendor DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(36394870493061914)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(36395063411061916)
,p_event_id=>wwv_flow_api.id(36394947708061915)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P6_VENDOR_SITE_CODE,P6_VENDOR_NUMBER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(36395166546061917)
,p_name=>'Display Other Activity DA'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P6_ACTIVITIES'
,p_condition_element=>'P6_ACTIVITIES'
,p_triggering_condition_type=>'IN_LIST'
,p_triggering_expression=>'105'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(36395290695061918)
,p_event_id=>wwv_flow_api.id(36395166546061917)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P6_OTHER_ACTIVITY_NAME'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(36395497555061920)
,p_event_id=>wwv_flow_api.id(36395166546061917)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P6_OTHER_ACTIVITY_NAME'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(36395302407061919)
,p_event_id=>wwv_flow_api.id(36395166546061917)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P6_OTHER_ACTIVITY_NAME'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(36731648870215615)
,p_name=>'Dialog Close'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(36398004567061946)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(36731730156215616)
,p_event_id=>wwv_flow_api.id(36731648870215615)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(36398126481061947)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(36731898211215617)
,p_name=>'Dialog Close Bank Account'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(36397775969061943)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(36731949362215618)
,p_event_id=>wwv_flow_api.id(36731898211215617)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(36396047580061926)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(36732038252215619)
,p_name=>'Dialog Close Bank Report'
,p_event_sequence=>50
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(36396047580061926)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(36732124201215620)
,p_event_id=>wwv_flow_api.id(36732038252215619)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(36396047580061926)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(37129262233203041)
,p_name=>'Dialog Close -document  report'
,p_event_sequence=>60
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(36398126481061947)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(37129307039203042)
,p_event_id=>wwv_flow_api.id(37129262233203041)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(36398126481061947)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(38397820982258117)
,p_name=>'New'
,p_event_sequence=>70
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P6_GL_BUDGET_CODE'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(38397943717258118)
,p_event_id=>wwv_flow_api.id(38397820982258117)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P6_GL_BUDGET_CODE_H'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT BUDGET_GROUP_DESCRIPTION ',
'from dct_gl_code_combinations_all',
'where BUDGET_CODE = :P6_GL_BUDGET_CODE'))
,p_attribute_07=>'P6_GL_BUDGET_CODE'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(38398031444258119)
,p_event_id=>wwv_flow_api.id(38397820982258117)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P6_GL_BUDGET_CODE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(36554863592372103)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(36519023324372142)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Service Provider Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(36554471450372103)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(36519023324372142)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Service Provider Details'
);
wwv_flow_api.component_end;
end;
/
