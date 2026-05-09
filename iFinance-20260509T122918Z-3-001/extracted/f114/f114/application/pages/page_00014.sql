prompt --application/pages/page_00014
begin
--   Manifest
--     PAGE: 00014
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>114
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>14
,p_user_interface_id=>wwv_flow_api.id(52958449993734913)
,p_name=>'Express Manager Cheque Approve / Reject'
,p_alias=>'EXPRESS-MANAGER-CHEQUE-APPROVE-REJECT'
,p_step_title=>'Express Manager Cheque Approve / Reject'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_step_template=>wwv_flow_api.id(52837709142734852)
,p_page_template_options=>'#DEFAULT#'
,p_page_is_public_y_n=>'Y'
,p_rejoin_existing_sessions=>'N'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230209090842'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(53685281721159640)
,p_plug_name=>'Comment '
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader:t-Region--noUI:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(52873880343734866)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P14_HISTORY_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(53685979030159647)
,p_plug_name=>'Bad Request, No longer available'
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--wizard:t-Alert--defaultIcons:t-Alert--danger'
,p_plug_template=>wwv_flow_api.id(52842746950734853)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NULL'
,p_plug_display_when_condition=>'P14_HISTORY_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(160284103942762901)
,p_plug_name=>'Check Details'
,p_icon_css_classes=>'fa-list-alt'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(52873880343734866)
,p_plug_display_sequence=>20
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'MANAGER_CHECKS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P14_HISTORY_ID'
,p_plug_read_only_when_type=>'ALWAYS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(160009744411438088)
,p_plug_name=>'Audit'
,p_parent_plug_id=>wwv_flow_api.id(160284103942762901)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noUI:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(52856874224734860)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(160352233922200246)
,p_plug_name=>'Attachements'
,p_parent_plug_id=>wwv_flow_api.id(160284103942762901)
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(52873880343734866)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P14_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(160352328961200247)
,p_plug_name=>'Documents Report'
,p_parent_plug_id=>wwv_flow_api.id(160352233922200246)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(52871984744734866)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'  SELECT',
'    id,',
'    row_version_number,',
'    check_id,',
'    filename,',
'    file_mimetype,',
'    file_charset,',
'    file_blob,',
'    file_comments,',
'    tags,',
'    created_by,',
'    created_on,',
'    updated_by,',
'    updated_on,',
'    sys.dbms_lob.getlength(file_blob) as file_size,',
'    sys.dbms_lob.getlength(file_blob) as download',
'FROM',
'    manager_checks_documents',
'where check_id = :P14_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P14_ID'
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
 p_id=>wwv_flow_api.id(160352424749200248)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>160352424749200248
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54078849624708509)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54079248253708510)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54079677243708510)
,p_db_column_name=>'CHECK_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Check Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54080026018708511)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'File name'
,p_column_link=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:3:P3_ID,P3_APPROVAL_STATUS,P3_PAGE_FROM:#ID#,&P2_STATUS.,6'
,p_column_linktext=>'#FILENAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54080414968708511)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54080855163708511)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54081254269708512)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>70
,p_column_identifier=>'G'
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
 p_id=>wwv_flow_api.id(54081661274708512)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'File Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54082065328708512)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54082494580708512)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(52986061814825111)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54082887475708512)
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
 p_id=>wwv_flow_api.id(54083250267708512)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(52986061814825111)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54083675830708513)
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
 p_id=>wwv_flow_api.id(54084030201708513)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54084423614708513)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:MANAGER_CHECKS_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED_ON:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(160362992839256504)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'540848'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:UPDATED_BY:UPDATED_ON:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(160354424965200268)
,p_plug_name=>'Other Details'
,p_parent_plug_id=>wwv_flow_api.id(160284103942762901)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(52856874224734860)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(160354767933200271)
,p_plug_name=>'Approval History'
,p_icon_css_classes=>'fa-user-edit'
,p_region_template_options=>'#DEFAULT#:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(52873880343734866)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P14_HISTORY_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(160354843579200272)
,p_plug_name=>'Approval History Report'
,p_parent_plug_id=>wwv_flow_api.id(160354767933200271)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(52871984744734866)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    h.id,',
'    h.check_id,',
'    h.step_no,',
'    h.person_id,',
'    h.role_id,',
'    h.role_desc,',
'    h.action_required,',
'    h.recevied_date,',
'    h.status,',
'    h.action_date,',
'    h.COMMENTs,',
'    h.approval_type,',
'    h.created_by_person_id,',
'    h.created_on,',
'    h.updated_by_person_id,',
'    h.updated_on,',
'   e.full_name_en,',
'    case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'       when 0  THEN',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'        else  ',
'            ',
'         ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'       end Photo',
'FROM',
'    manager_checks_approval_history h, dct_employees_list2  e',
'  where h.person_id = e.person_id (+)',
'  and h.check_id = :P14_ID',
'order by h.STEP_NO , h.ID;',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P14_ID'
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
 p_id=>wwv_flow_api.id(160354967925200273)
,p_max_row_count=>'1000000'
,p_allow_save_rpt_public=>'Y'
,p_show_display_row_count=>'Y'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_show_reset=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>160354967925200273
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54091351975708519)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54091704226708519)
,p_db_column_name=>'CHECK_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Check Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54092169535708520)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54097360661708522)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>40
,p_column_identifier=>'Q'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54093320321708520)
,p_db_column_name=>'ROLE_DESC'
,p_display_order=>50
,p_column_identifier=>'F'
,p_column_label=>'Role'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54092540135708520)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>60
,p_column_identifier=>'D'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54093729830708520)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>80
,p_column_identifier=>'G'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54094151340708521)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>90
,p_column_identifier=>'H'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54094590607708521)
,p_db_column_name=>'STATUS'
,p_display_order=>100
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54094975364708521)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>110
,p_column_identifier=>'J'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54095318343708521)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>130
,p_column_identifier=>'L'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54095701265708521)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>140
,p_column_identifier=>'M'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(52986061814825111)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54096102168708521)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>150
,p_column_identifier=>'N'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54096528710708522)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>160
,p_column_identifier=>'O'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(52986061814825111)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54096900757708522)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>170
,p_column_identifier=>'P'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54097764065708523)
,p_db_column_name=>'PHOTO'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="50" width="50">'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54092960269708520)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>190
,p_column_identifier=>'E'
,p_column_label=>'Role Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54098190380708523)
,p_db_column_name=>'COMMENTS'
,p_display_order=>200
,p_column_identifier=>'S'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(160428583458464484)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'540985'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:PHOTO:FULL_NAME_EN:ROLE_DESC:ACTION_REQUIRED:RECEVIED_DATE:STATUS:ACTION_DATE::COMMENTS'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(54098969161708523)
,p_report_id=>wwv_flow_api.id(160428583458464484)
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
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(213464198172719811)
,p_plug_name=>'Collaboration'
,p_icon_css_classes=>'fa-comments-o fam-sleep fam-is-success'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(52873880343734866)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P14_HISTORY_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(160354619472200270)
,p_name=>'Comments Report'
,p_parent_plug_id=>wwv_flow_api.id(213464198172719811)
,p_template=>wwv_flow_api.id(52846419027734856)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#'
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
'    END  user_icon,',
'  updated_on  comment_date,',
'  (select e.full_name_en',
'    from dct_employees_list2 e',
'    where e.person_id = created_by_person_id) user_name,',
'  comment_text                    comment_text,',
'  null comment_modifiers,',
'  ''u-color-''||ora_hash(created_by_person_id,45) icon_modifier,',
'  action     actions,',
'  ''''     attribute_1,',
'  ''''     attribute_2,',
'  ''''    attribute_3,',
'  ''''    attribute_4,',
'  comment_id',
'from',
'  (SELECT',
'    c.comment_id,',
'    c.check_id,',
'    c.comment_text,',
'    c.created_by_person_id,',
'    c.updated_by_person_id,',
'    c.created_on,',
'    c.updated_on,',
'    c.action,',
'    e.user_name,',
'    e.photo_blob    ',
'FROM',
'    manager_checks_comments c , dct_employees_list2 e',
'where c.updated_by_person_id = e.person_id    )',
'where check_id = :P14_ID',
'order by created_on desc;',
''))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P14_ID'
,p_query_row_template=>wwv_flow_api.id(52902760947734878)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No collaboration yet.'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(54100332343708526)
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
 p_id=>wwv_flow_api.id(54100785427708526)
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
 p_id=>wwv_flow_api.id(54101145725708527)
,p_query_column_id=>3
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>3
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(54101545625708527)
,p_query_column_id=>4
,p_column_alias=>'COMMENT_TEXT'
,p_column_display_sequence=>4
,p_column_heading=>'Comment Text'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(54101960600708527)
,p_query_column_id=>5
,p_column_alias=>'COMMENT_MODIFIERS'
,p_column_display_sequence=>5
,p_column_heading=>'Comment Modifiers'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(54102389742708527)
,p_query_column_id=>6
,p_column_alias=>'ICON_MODIFIER'
,p_column_display_sequence=>6
,p_column_heading=>'Icon Modifier'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(54102703092708528)
,p_query_column_id=>7
,p_column_alias=>'ACTIONS'
,p_column_display_sequence=>7
,p_column_heading=>'Actions'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(54103116894708528)
,p_query_column_id=>8
,p_column_alias=>'ATTRIBUTE_1'
,p_column_display_sequence=>8
,p_column_heading=>'Attribute 1'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(54103588987708528)
,p_query_column_id=>9
,p_column_alias=>'ATTRIBUTE_2'
,p_column_display_sequence=>9
,p_column_heading=>'Attribute 2'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(54103980575708528)
,p_query_column_id=>10
,p_column_alias=>'ATTRIBUTE_3'
,p_column_display_sequence=>10
,p_column_heading=>'Attribute 3'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(54104335166708528)
,p_query_column_id=>11
,p_column_alias=>'ATTRIBUTE_4'
,p_column_display_sequence=>11
,p_column_heading=>'Attribute 4'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(54104799871708528)
,p_query_column_id=>12
,p_column_alias=>'COMMENT_ID'
,p_column_display_sequence=>12
,p_column_heading=>'Comment Id'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(54106215167708529)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(53685281721159640)
,p_button_name=>'Approve'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft:t-Button--gapRight'
,p_button_template_id=>wwv_flow_api.id(52936058388734896)
,p_button_image_alt=>'&P14_APPROVE_LABEL.'
,p_button_position=>'ABOVE_BOX'
,p_icon_css_classes=>'fa-check-square'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(54106694690708530)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(53685281721159640)
,p_button_name=>'Reject'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--danger:t-Button--iconRight:t-Button--gapLeft:t-Button--gapRight'
,p_button_template_id=>wwv_flow_api.id(52936058388734896)
,p_button_image_alt=>'&P14_REJECT_LABEL.'
,p_button_position=>'ABOVE_BOX'
,p_icon_css_classes=>'fa-times-square'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(54078123633708504)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(160352233922200246)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--noUI:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(52935280371734895)
,p_button_image_alt=>'Add Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:3:P3_CHECK_ID,P3_PAGE_FROM:&P14_ID.,6'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(54099629680708524)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(213464198172719811)
,p_button_name=>'AddComment'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(52935280371734895)
,p_button_image_alt=>'New Message'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:5:P5_CHECK_ID:&P14_ID.'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-envelope-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(54105404705708529)
,p_button_sequence=>10
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large'
,p_button_template_id=>wwv_flow_api.id(52935963508734896)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:RP,6,1::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(54105851185708529)
,p_button_sequence=>40
,p_button_name=>'Delegate'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(52936058388734896)
,p_button_image_alt=>'Delegate'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:7:P7_ACTION,P7_CHECK_ID:Delegate,&P14_ID.'
,p_icon_css_classes=>'fa-sign-language'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(54119674468708546)
,p_branch_name=>'Go To Page 1'
,p_branch_action=>'f?p=100:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53684594881159633)
,p_name=>'P14_HASH'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(160284103942762901)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53684635061159634)
,p_name=>'P14_PERSON_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(160284103942762901)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53684798622159635)
,p_name=>'P14_APPROVE_LABEL'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(160284103942762901)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53684875724159636)
,p_name=>'P14_REJECT_LABEL'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(160284103942762901)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53685357631159641)
,p_name=>'P14_COMMENT'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(53685281721159640)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>2
,p_field_template=>wwv_flow_api.id(52934852790734894)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53685738913159645)
,p_name=>'P14_RECEIVING_PERSON_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(53685281721159640)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_prompt=>'Receiving Name'
,p_source=>'RECEIVING_PERSON_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>255
,p_display_when=>'P14_ROLE_DESC'
,p_display_when2=>'Treasury'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(52935104739734895)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53685873243159646)
,p_name=>'P14_EMIRATES_ID'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(53685281721159640)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_prompt=>'Emirates ID'
,p_source=>'EMIRATES_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>20
,p_display_when=>'P14_ROLE_DESC'
,p_display_when2=>'Treasury'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(52935104739734895)
,p_item_template_options=>'#DEFAULT#'
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
,p_default_application_id=>114
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53686056808159648)
,p_name=>'P14_FILE'
,p_source_data_type=>'BLOB'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(53685281721159640)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_prompt=>'File'
,p_source=>'FILE_BLOB'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_FILE'
,p_cSize=>30
,p_display_when=>'P14_ROLE_DESC'
,p_display_when2=>'Treasury'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(52934852790734894)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'DB_COLUMN'
,p_attribute_02=>'FILE_MIMETYPE'
,p_attribute_03=>'FILENAME'
,p_attribute_04=>'FILE_CHARSET'
,p_attribute_05=>'UPDATED_ON'
,p_attribute_06=>'Y'
,p_attribute_08=>'attachment'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54069969066708494)
,p_name=>'P14_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_is_query_only=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(160284103942762901)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_source=>'ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54070343603708497)
,p_name=>'P14_HISTORY_ID'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(160284103942762901)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54070728672708497)
,p_name=>'P14_ROLE_DESC'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(160284103942762901)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54071113462708497)
,p_name=>'P14_SUPPLIER_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(160284103942762901)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_prompt=>'Supplier Name'
,p_source=>'SUPPLIER_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_AUTO_COMPLETE'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct vendor_name',
'from  vendors'))
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(52934951552734894)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'CONTAINS_IGNORE'
,p_attribute_04=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54071516600708497)
,p_name=>'P14_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(160284103942762901)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_item_default=>'Hold'
,p_prompt=>'Status'
,p_source=>'STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54071927898708498)
,p_name=>'P14_PAYMENT_NO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(160284103942762901)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_prompt=>'Check Num'
,p_source=>'PAYMENT_NO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54072301888708498)
,p_name=>'P14_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(160284103942762901)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_prompt=>'Amount'
,p_post_element_text=>'&nbsp; &nbsp; <b>   &P14_CURRENCY.</b>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54072774003708498)
,p_name=>'P14_CURRENCY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(160284103942762901)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_source=>'CURRENCY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54073178881708499)
,p_name=>'P14_AMOUNT_IN_AED'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(160284103942762901)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_prompt=>'Amount (AED)'
,p_post_element_text=>'&nbsp; &nbsp; <b>AED</b>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'AMOUNT_IN_AED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54073545605708499)
,p_name=>'P14_END_USER_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(160284103942762901)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_prompt=>'Business Owner'
,p_source=>'END_USER_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'PERSONS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'    select full_name_en, person_id, email , employee_num, current_flag active',
'    from employees_v'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_10=>'EMAIL:P14_END_USER_EMAIL'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54073915123708499)
,p_name=>'P14_END_USER_EMAIL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(160284103942762901)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_source=>'END_USER_EMAIL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54074371771708499)
,p_name=>'P14_DESCRIPTIONS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(160284103942762901)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_prompt=>'Description'
,p_source=>'DESCRIPTIONS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>80
,p_cMaxlength=>4000
,p_cHeight=>2
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54074780631708499)
,p_name=>'P14_EMAIL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(160284103942762901)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_prompt=>'Email'
,p_source=>'EMAIL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>255
,p_cHeight=>4
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(52934852790734894)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54076243148708503)
,p_name=>'P14_UPLOADED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(160009744411438088)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_prompt=>'Created By'
,p_source=>'UPLOADED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'PERSONS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'    select full_name_en, person_id, email , employee_num, current_flag active',
'    from employees_v'))
,p_display_when=>'P14_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54076688828708503)
,p_name=>'P14_UPLOADED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(160009744411438088)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_prompt=>'Uploaded On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'UPLOADED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>'P14_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54077082364708503)
,p_name=>'P14_UPDATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(160009744411438088)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_prompt=>'Updated By'
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'PERSONS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'    select full_name_en, person_id, email , employee_num, current_flag active',
'    from employees_v'))
,p_display_when=>'P14_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54077458289708504)
,p_name=>'P14_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(160009744411438088)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_prompt=>'Updated On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>'P14_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54085542964708516)
,p_name=>'P14_PV'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(160354424965200268)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_prompt=>'PVs'
,p_source=>'PV'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>1000
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54085978279708517)
,p_name=>'P14_LIST'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(160354424965200268)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_prompt=>'List'
,p_source=>'LIST'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>5
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54086398190708517)
,p_name=>'P14_PAYMENT_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(160354424965200268)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_prompt=>'Payment Type'
,p_source=>'PAYMENT_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_AUTO_COMPLETE'
,p_lov=>'select distinct payment_type from manager_checks;'
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'CONTAINS_IGNORE'
,p_attribute_04=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54086710375708517)
,p_name=>'P14_MILESTONE_DESCRIPTION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(160354424965200268)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_prompt=>'Milestone Description'
,p_source=>'MILESTONE_DESCRIPTION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>4000
,p_cHeight=>3
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54087116317708517)
,p_name=>'P14_MILESTONE_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(160354424965200268)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_prompt=>'Milestone Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'MILESTONE_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54087514090708517)
,p_name=>'P14_PROJECT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(160354424965200268)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_prompt=>'Project'
,p_post_element_text=>'&nbsp; &nbsp; <b>&P14_PROJECT_NAME.</b>'
,p_source=>'PROJECT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  project_number, project_number r',
'from project'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54087958070708517)
,p_name=>'P14_PROJECT_NAME'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(160354424965200268)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select project_name',
'from project',
'where project_number = :P14_PROJECT'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54088396422708518)
,p_name=>'P14_TASK'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(160354424965200268)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_prompt=>'Task'
,p_source=>'TASK'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct task_number d , task_number',
'from task',
'where project_number = :P14_PROJECT '))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P14_PROJECT'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54088716670708518)
,p_name=>'P14_COST_CENTER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(160354424965200268)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_prompt=>'Cost Center'
,p_post_element_text=>'&nbsp; &nbsp; <b>&P14_COST_CENTER_NAME.</b>'
,p_source=>'COST_CENTER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_AUTO_COMPLETE'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct cost_center_code ',
'from  dct_gl_code_combinations_all'))
,p_cSize=>20
,p_cMaxlength=>7
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'CONTAINS_IGNORE'
,p_attribute_04=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54089181426708518)
,p_name=>'P14_COST_CENTER_NAME'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(160354424965200268)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct cost_center_description',
'from dct_gl_code_combinations_all',
'where cost_center_code = :P14_COST_CENTER'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54089567743708518)
,p_name=>'P14_GL_ACCOUNT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(160354424965200268)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_prompt=>'GL Account'
,p_post_element_text=>'&nbsp; &nbsp; <b>&P14_GL_ACCOUNT_NAME.</b>'
,p_source=>'GL_ACCOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_AUTO_COMPLETE'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct account_code',
'from  dct_gl_code_combinations_all'))
,p_cSize=>32
,p_cMaxlength=>6
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'CONTAINS_IGNORE'
,p_attribute_04=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54089939173708518)
,p_name=>'P14_GL_ACCOUNT_NAME'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(160354424965200268)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct account_description',
'from dct_gl_code_combinations_all',
'where account_code = :P14_GL_ACCOUNT;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54090393616708518)
,p_name=>'P14_COMMENTS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(160354424965200268)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_prompt=>'Comment'
,p_source=>'COMMENTS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>4000
,p_cHeight=>2
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54530266895073037)
,p_name=>'P14_BANK_GRANTEE_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(160284103942762901)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_prompt=>'Bank Grantee Number'
,p_source=>'BANK_GRANTEE_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>50
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54530335889073038)
,p_name=>'P14_CONTRACT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(160284103942762901)
,p_item_source_plug_id=>wwv_flow_api.id(160284103942762901)
,p_prompt=>'Contract Number'
,p_source=>'CONTRACT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>100
,p_field_template=>wwv_flow_api.id(52934641506734894)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(54116145881708544)
,p_validation_name=>'P14_UPLOADED_ON must be timestamp'
,p_validation_sequence=>180
,p_validation=>'P14_UPLOADED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(54076688828708503)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(54116514363708544)
,p_validation_name=>'P14_UPDATED_ON must be timestamp'
,p_validation_sequence=>200
,p_validation=>'P14_UPDATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(54077458289708504)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(54116817415708544)
,p_name=>'Refresh Documents report DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(54078123633708504)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54117306926708545)
,p_event_id=>wwv_flow_api.id(54116817415708544)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(160352328961200247)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(54117776940708545)
,p_name=>'Dialog Close Comment 2'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(54099629680708524)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54118203351708545)
,p_event_id=>wwv_flow_api.id(54117776940708545)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(160354619472200270)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(54118671639708546)
,p_name=>'Dialog Close Comment 1'
,p_event_sequence=>40
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(160354619472200270)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54119155432708546)
,p_event_id=>wwv_flow_api.id(54118671639708546)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(160354619472200270)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(53684969270159637)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Set Hash'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select h.id , h.check_id , h.person_id ,  ',
'case h.action_required when ''Endorsement''       Then ''Endorse''',
'                       when ''Approve/Reject''    Then ''Approve''',
'                       when ''Release Check''     Then ''Release''',
'End as approve_label',
',case h.action_required when ''Endorsement''       Then ''Not Endorse''',
'                        when ''Approve/Reject''    Then ''Reject''',
'                        when ''Release Check''     Then ''Reject''',
'End as reject_label',
',h.role_desc',
'into :P14_HISTORY_ID, :P14_ID , :P14_PERSON_ID , :P14_APPROVE_LABEL, :P14_REJECT_LABEL , :P14_ROLE_DESC',
'from manager_checks_approval_history h',
'where hash_code = :P14_Hash',
'and h.status = ''Pending'';',
'',
'exception',
'    When',
'     no_data_found then ',
'        null;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(54075597249708502)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(160284103942762901)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Check Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(54106215167708529)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(53685497803159642)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Approve Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'if :P14_ROLE_DESC = ''Treasury'' and (:P14_EMIRATES_ID is null or :P14_RECEIVING_PERSON_NAME is null or :P14_FILE is null)',
'    Then ',
'         apex_error.add_error(p_message => ''Please fill in the receiving name, Emirates ID and Company Letter. '',',
'                                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'   else                                     ',
'',
'manager_check_workflow.approve(:P14_ID ,  :P14_PERSON_ID, :P14_COMMENT);',
'end if;',
'end;',
''))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(54106215167708529)
,p_process_success_message=>'&P14_APPROVE_LABEL.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(53685608168159644)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Reject Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'if :P14_COMMENT is null Then ',
'      ',
'                    apex_error.add_error(p_message => ''Please tell us the rejection reason. '',',
'                                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'                ELSe',
'manager_check_workflow.reject(:P14_ID ,  :P14_PERSON_ID, :P14_COMMENT);',
'',
'',
'end if;',
'',
'end;	'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(54106694690708530)
,p_process_success_message=>'Rejected'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(54075123415708501)
,p_process_sequence=>10
,p_process_point=>'BEFORE_BOX_BODY'
,p_region_id=>wwv_flow_api.id(160284103942762901)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Check Details'
);
wwv_flow_api.component_end;
end;
/
