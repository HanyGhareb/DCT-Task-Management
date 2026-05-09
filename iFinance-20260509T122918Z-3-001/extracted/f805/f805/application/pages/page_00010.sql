prompt --application/pages/page_00010
begin
--   Manifest
--     PAGE: 00010
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
 p_id=>10
,p_user_interface_id=>wwv_flow_api.id(36116058293523070)
,p_name=>'Service Agreement Details'
,p_alias=>'SERVICE-AGREEMENT-DETAILS'
,p_step_title=>'Service Agreement Details'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230710105536'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(36896617369332154)
,p_plug_name=>'Service Agreement Details'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'SERVICE_PROVIDERS_AGREEMENTS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(36732923078215628)
,p_plug_name=>'Audit Info'
,p_parent_plug_id=>wwv_flow_api.id(36896617369332154)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36014471908523151)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P10_SERVICE_AGREEMENT_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(36734831903215647)
,p_plug_name=>'Attachment'
,p_parent_plug_id=>wwv_flow_api.id(36896617369332154)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36014471908523151)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(37073461988729605)
,p_plug_name=>'Attachments Report'
,p_parent_plug_id=>wwv_flow_api.id(36734831903215647)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(36029582862523142)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       SERVICE_PROVIDER_ID,',
'       SERVICE_AGREEMENT_ID,',
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
'  from SERVICE_AGREEMENTS_DOCUMENTS',
' where SERVICE_AGREEMENT_ID = :P10_SERVICE_AGREEMENT_ID',
' order by UPDATED_ON DESC'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P10_SERVICE_AGREEMENT_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Attachments Report'
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
 p_id=>wwv_flow_api.id(37073526855729606)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.:11:P11_ID,P11_PAGE_FROM:#ID#,10'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>37073526855729606
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37073684453729607)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37073777898729608)
,p_db_column_name=>'SERVICE_PROVIDER_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Service Provider Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37073808874729609)
,p_db_column_name=>'SERVICE_AGREEMENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Service Agreement Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37074010605729611)
,p_db_column_name=>'MIMETYPE'
,p_display_order=>40
,p_column_identifier=>'E'
,p_column_label=>'Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37074164017729612)
,p_db_column_name=>'DOC_CHARSET'
,p_display_order=>50
,p_column_identifier=>'F'
,p_column_label=>'Doc Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37074349486729614)
,p_db_column_name=>'LAST_UPDATE_DATE'
,p_display_order=>60
,p_column_identifier=>'H'
,p_column_label=>'Last Update Date'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37073910910729610)
,p_db_column_name=>'FILENAME'
,p_display_order=>70
,p_column_identifier=>'D'
,p_column_label=>'File name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37074485049729615)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>80
,p_column_identifier=>'I'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(36664110333548073)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37074572797729616)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>90
,p_column_identifier=>'J'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37074637149729617)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>100
,p_column_identifier=>'K'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(36664110333548073)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37074716588729618)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>110
,p_column_identifier=>'L'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37074829613729619)
,p_db_column_name=>'NOTES'
,p_display_order=>120
,p_column_identifier=>'M'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37074912197729620)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>130
,p_column_identifier=>'N'
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
,p_format_mask=>'DOWNLOAD:SERVICE_AGREEMENTS_DOCUMENTS:DOC_BLOB:ID::MIMETYPE:FILENAME:LAST_UPDATE_DATE:DOC_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(37094629213615990)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'370947'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:SERVICE_PROVIDER_ID:SERVICE_AGREEMENT_ID:FILENAME:MIMETYPE:DOC_CHARSET:LAST_UPDATE_DATE:CREATED_BY:CREATED_ON:UPDATED_BY:UPDATED_ON:NOTES:DOWNLOAD'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(37073373198729604)
,p_plug_name=>'Finance Details'
,p_parent_plug_id=>wwv_flow_api.id(36896617369332154)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:is-expanded:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36014471908523151)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(36733264461215631)
,p_plug_name=>'Project Details'
,p_parent_plug_id=>wwv_flow_api.id(37073373198729604)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(37129985470203048)
,p_plug_name=>'Default Details'
,p_parent_plug_id=>wwv_flow_api.id(36733264461215631)
,p_region_template_options=>'#DEFAULT#:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(38396587393258104)
,p_plug_name=>'SP project Details '
,p_parent_plug_id=>wwv_flow_api.id(36733264461215631)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(36733346791215632)
,p_plug_name=>'General Ledger Details'
,p_parent_plug_id=>wwv_flow_api.id(37073373198729604)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(36936131783332118)
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
 p_id=>wwv_flow_api.id(37075271705729623)
,p_plug_name=>'Payment Requests'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(37075333142729624)
,p_plug_name=>'Payments Requests Report'
,p_parent_plug_id=>wwv_flow_api.id(37075271705729623)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(36029582862523142)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PAYMENT_REQUEST_ID,',
'       SERVICE_PROVIDER_ID,',
'       SERVICE_AGREEMENT_ID,',
'       PAYMENT_REQUEST_DATE,',
'       PLANNED_AMOUNT,',
'       DUE_AMOUNT,',
'       PAYMENT_REQUEST_NUMBER,',
'       PAYMENT_REQUEST_TYPE,',
'       DESCRIPTION,',
'       SERVICE_PROVIDER_BANK_ACCOUNT_ID,',
'       DUE_DATE,',
'       APPROVAL_STATUS,',
'       PO_NUMBER,',
'       SERVICE_PROVIDER_SIGNATURE_ID,',
'  --     FILENAME,',
'  --     MIMETYPE,',
'  --     CHARSET,',
'  --     INVOICE_BLOB,',
'  --     INVOICE_UPDATE_DATE,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       ORG_ID,',
'       COST_CENTER_CODE,',
'       GL_ACCOUNT,',
'       GL_ACTIVITY,',
'       GL_FUTURE1,',
'       GL_FUTURE2,',
'       GL_BUDGET_CODE,',
'       PROJECT_NUMBER,',
'       TASK_NUMBER,',
'       EXPENDITURE_TYPE,',
'       PAY_GROUP,',
'       CURRENCY_CODE',
'  from SERVICE_PROVIDERS_PAYMENT_REQUESTS',
' where service_agreement_id = :P10_SERVICE_AGREEMENT_ID',
' order by due_date '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P10_SERVICE_AGREEMENT_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Payments Requests Report'
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
 p_id=>wwv_flow_api.id(37075424777729625)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:12:P12_PAYMENT_REQUEST_ID,P12_PAGE_FROM:#PAYMENT_REQUEST_ID#,10'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>37075424777729625
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37075560585729626)
,p_db_column_name=>'PAYMENT_REQUEST_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Payment Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37075636998729627)
,p_db_column_name=>'SERVICE_PROVIDER_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Service Provider Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37075775799729628)
,p_db_column_name=>'SERVICE_AGREEMENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Service Agreement Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37075833844729629)
,p_db_column_name=>'PAYMENT_REQUEST_DATE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Payment Request Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37075902990729630)
,p_db_column_name=>'PLANNED_AMOUNT'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Planned Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37076063772729631)
,p_db_column_name=>'DUE_AMOUNT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Due Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37076115829729632)
,p_db_column_name=>'PAYMENT_REQUEST_NUMBER'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Payment Request Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37076283862729633)
,p_db_column_name=>'PAYMENT_REQUEST_TYPE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Payment Request Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37076391113729634)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37076450974729635)
,p_db_column_name=>'SERVICE_PROVIDER_BANK_ACCOUNT_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Service Provider Bank Account Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37076517140729636)
,p_db_column_name=>'DUE_DATE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Due Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37076684467729637)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37076724260729638)
,p_db_column_name=>'PO_NUMBER'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Po Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37076852626729639)
,p_db_column_name=>'SERVICE_PROVIDER_SIGNATURE_ID'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Service Provider Signature Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37077477643729645)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37077561071729646)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37077616275729647)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37077797997729648)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37077858943729649)
,p_db_column_name=>'ORG_ID'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Org Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37077922452729650)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Cost Center Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37125243369203001)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37125333725203002)
,p_db_column_name=>'GL_ACTIVITY'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Gl Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37125435876203003)
,p_db_column_name=>'GL_FUTURE1'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Gl Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37125547938203004)
,p_db_column_name=>'GL_FUTURE2'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Gl Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37125680618203005)
,p_db_column_name=>'GL_BUDGET_CODE'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Gl Budget Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37125738418203006)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37125859491203007)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37125928379203008)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37126069289203009)
,p_db_column_name=>'PAY_GROUP'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Pay Group'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37126160222203010)
,p_db_column_name=>'CURRENCY_CODE'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Currency Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(37174575887163675)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'371746'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PAYMENT_REQUEST_ID:SERVICE_PROVIDER_ID:SERVICE_AGREEMENT_ID:PAYMENT_REQUEST_DATE:PLANNED_AMOUNT:DUE_AMOUNT:PAYMENT_REQUEST_NUMBER:PAYMENT_REQUEST_TYPE:DESCRIPTION:SERVICE_PROVIDER_BANK_ACCOUNT_ID:DUE_DATE:APPROVAL_STATUS:PO_NUMBER:SERVICE_PROVIDER_SI'
||'GNATURE_ID:CREATED_BY:CREATED_ON:UPDATED_BY:UPDATED_ON:ORG_ID:COST_CENTER_CODE:GL_ACCOUNT:GL_ACTIVITY:GL_FUTURE1:GL_FUTURE2:GL_BUDGET_CODE:PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:PAY_GROUP:CURRENCY_CODE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(36918749179332139)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(36936131783332118)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(36093542201523097)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(37075019758729621)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(36734831903215647)
,p_button_name=>'Add_attachment'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(36093683257523097)
,p_button_image_alt=>'Add Attachment'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.:11:P11_PAGE_FROM,P11_SERVICE_PROVIDER_ID,P11_SERVICE_AGREEMENT_ID:10,&P10_SERVICE_PROVIDER_ID.,&P10_SERVICE_AGREEMENT_ID.'
,p_icon_css_classes=>'fa-file-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(37126251592203011)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(37075271705729623)
,p_button_name=>'New_Payment_request'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(36093683257523097)
,p_button_image_alt=>'New Payment Request'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.::P12_SERVICE_AGREEMENT_ID,P12_SERVICE_PROVIDER_ID,P12_PAGE_FROM:&P10_SERVICE_AGREEMENT_ID.,&P10_SERVICE_PROVIDER_ID.,10'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(36919567710332138)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(36936131783332118)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(36093542201523097)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition=>'P10_SERVICE_AGREEMENT_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(36919988410332138)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(36936131783332118)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(36093542201523097)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P10_SERVICE_AGREEMENT_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(36920325141332138)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(36936131783332118)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(36093542201523097)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P10_SERVICE_AGREEMENT_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(36920668961332137)
,p_branch_action=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36734383185215642)
,p_name=>'P10_COST_CENTER_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(36733346791215632)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT   COST_CENTER_DESCRIPTION',
'from dct_gl_code_combinations_all',
'where COST_CENTER_CODE = :P10_COST_CENTER_CODE;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36735088381215649)
,p_name=>'P10_SERVICE_AGREEMENT_BLOB'
,p_source_data_type=>'BLOB'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_prompt=>'Service Agreement document'
,p_source=>'SERVICE_AGREEMENT_BLOB'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_FILE'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'DB_COLUMN'
,p_attribute_02=>'SERVICE_AGREEMENT_MIMETYPE'
,p_attribute_03=>'SERVICE_AGREEMENT_FILENAME'
,p_attribute_04=>'SERVICE_AGREEMENT_CHARSET'
,p_attribute_05=>'SERVICE_AGREEMENT_LAST_UPDATE'
,p_attribute_06=>'Y'
,p_attribute_08=>'attachment'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36735159017215650)
,p_name=>'P10_SERVICE_AGREEMENT_FILENAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_source=>'SERVICE_AGREEMENT_FILENAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36897055236332153)
,p_name=>'P10_SERVICE_AGREEMENT_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Service Agreement Id'
,p_source=>'SERVICE_AGREEMENT_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_label_alignment=>'RIGHT'
,p_field_template=>wwv_flow_api.id(36092195023523100)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36897403985332152)
,p_name=>'P10_SERVICE_PROVIDER_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_prompt=>'Service Provider (Freelancer)'
,p_source=>'SERVICE_PROVIDER_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'SERVICE PROVIDERS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select SERVICE_PROVIDERS.FULL_NAME_EN as FULL_NAME_EN,',
'    SERVICE_PROVIDERS.SERVICE_PROVIDER_ID as SERVICE_PROVIDER_ID ',
' from SERVICE_PROVIDERS SERVICE_PROVIDERS',
' order by SERVICE_PROVIDERS.FULL_NAME_EN ASC'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(36092576667523099)
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
 p_id=>wwv_flow_api.id(36897847274332152)
,p_name=>'P10_AGREEMENT_TYPE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_prompt=>'Agreement Type'
,p_source=>'AGREEMENT_TYPE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'FL AGREEMENT TYPES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
' select value , value_id ',
' from DCT_LOOKUP_VALUES ',
' where lookup_id = (select l.lookup_id ',
'                    from dct_lookups l ',
'                    where l.lookup_code = ''FL_AGREEMENT_TYPE'') ',
'and status = ''A'' ',
'and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10) ',
'order by 2;'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36898242774332152)
,p_name=>'P10_SERVICE_AGREEMENT_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_prompt=>'Agreement Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'SERVICE_AGREEMENT_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>32
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
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
 p_id=>wwv_flow_api.id(36898619264332152)
,p_name=>'P10_SERVICE_AGREEMENT_NUM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_prompt=>'Service Agreement Number'
,p_source=>'SERVICE_AGREEMENT_NUM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>40
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
 p_id=>wwv_flow_api.id(36899010698332151)
,p_name=>'P10_REF_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_prompt=>'Reference Number'
,p_source=>'REF_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>255
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36899462570332151)
,p_name=>'P10_PAYMENT_PERIOD'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_default=>'111'
,p_prompt=>'Payment Period'
,p_source=>'PAYMENT_PERIOD'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'PAYMENTS PERIODS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
' select value , value_id ',
' from DCT_LOOKUP_VALUES ',
' where lookup_id = (select l.lookup_id ',
'                    from dct_lookups l ',
'                    where l.lookup_code = ''PAYMENT_PERIOD'') ',
'and status = ''A'' ',
'and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10) '))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36899872039332151)
,p_name=>'P10_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_prompt=>'Amount'
,p_post_element_text=>'&nbsp; &nbsp; &P10_CURRENCY_CODE.'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36900298729332151)
,p_name=>'P10_CURRENCY_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_default=>'AED'
,p_prompt=>'Currency :'
,p_source=>'CURRENCY_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'CURRENCY LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value  d , value r',
'from dct_lookup_values',
'where lookup_id = 11'))
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
 p_id=>wwv_flow_api.id(36900639309332150)
,p_name=>'P10_VAT_EXCLUDE_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_default=>'Y'
,p_prompt=>'Exclude VAT?'
,p_source=>'VAT_EXCLUDE_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'APPLICATION'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36901054236332150)
,p_name=>'P10_PAYMENT_TERM'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_default=>'119'
,p_prompt=>'Payment Term'
,p_source=>'PAYMENT_TERM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'FL PAYMENT TERMS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
' select value , value_id ',
' from DCT_LOOKUP_VALUES ',
' where lookup_id = (select l.lookup_id ',
'                    from dct_lookups l ',
'                    where l.lookup_code = ''FL_PAYMENT_TERM'') ',
'and status = ''A'' ',
'and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10) ',
'order by 2;'))
,p_lov_display_null=>'YES'
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
 p_id=>wwv_flow_api.id(36901410468332150)
,p_name=>'P10_START_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_prompt=>'Start Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'START_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36901867411332150)
,p_name=>'P10_END_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_prompt=>'End Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'END_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(36092576667523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36902257340332149)
,p_name=>'P10_APPROVAL_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_default=>'Approved'
,p_prompt=>'Approval Status'
,p_source=>'APPROVAL_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>20
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36902683169332149)
,p_name=>'P10_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
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
 p_id=>wwv_flow_api.id(36903009614332149)
,p_name=>'P10_CREATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(36732923078215628)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_prompt=>'Created By'
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMP FULL NAME BY PERSON ID LOV'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36903445164332149)
,p_name=>'P10_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(36732923078215628)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_prompt=>'Created On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36904129818332148)
,p_name=>'P10_UPDATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(36732923078215628)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_prompt=>'Updated By'
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMP FULL NAME BY PERSON ID LOV'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36904564762332148)
,p_name=>'P10_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(36732923078215628)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_prompt=>'Updated On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36905319835332147)
,p_name=>'P10_NOTES'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_prompt=>'Notes'
,p_source=>'NOTES'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>120
,p_cMaxlength=>4000
,p_cHeight=>4
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36905710419332147)
,p_name=>'P10_ORG_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(38396587393258104)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_prompt=>'Department'
,p_source=>'ORG_ID'
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
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36906163711332147)
,p_name=>'P10_COST_CENTER_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(36733346791215632)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_prompt=>'Cost Center'
,p_post_element_text=>'&nbsp. &P10_COST_CENTER_NAME.'
,p_source=>'COST_CENTER_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>18
,p_cMaxlength=>7
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_help_text=>'&P10_COST_CENTER_NAME.'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36906550712332146)
,p_name=>'P10_GL_ACCOUNT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(36733346791215632)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_prompt=>'Account'
,p_post_element_text=>'&nbsp. &P10_GL_ACCOUNT_H.'
,p_source=>'GL_ACCOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>18
,p_cMaxlength=>6
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36906968952332146)
,p_name=>'P10_GL_ACTIVITY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(36733346791215632)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_prompt=>'Activity'
,p_post_element_text=>'&nbsp. &P10_GL_ACTIVITY_H.'
,p_source=>'GL_ACTIVITY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>18
,p_cMaxlength=>6
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36907313590332146)
,p_name=>'P10_GL_FUTURE1'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(36733346791215632)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_prompt=>'Future1'
,p_post_element_text=>'&nbsp. &P10_GL_FUTURE1_H.'
,p_source=>'GL_FUTURE1'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>18
,p_cMaxlength=>6
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36907742230332146)
,p_name=>'P10_GL_FUTURE2'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(36733346791215632)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_prompt=>'Future2'
,p_post_element_text=>'&nbsp. &P10_GL_FUTURE2_H.'
,p_source=>'GL_FUTURE2'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>18
,p_cMaxlength=>6
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36908157442332145)
,p_name=>'P10_GL_BUDGET_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(36733346791215632)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select sp.gl_budget_code ',
'from service_providers sp',
'WHERE sp.service_provider_id = :P10_SERVICE_PROVIDER_ID'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Budget'
,p_post_element_text=>'&nbsp. &P10_GL_BUDGET_CODE_H.'
,p_source=>'GL_BUDGET_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>18
,p_cMaxlength=>1
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36908563864332145)
,p_name=>'P10_PROJECT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(38396587393258104)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_prompt=>'Project'
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
 p_id=>wwv_flow_api.id(36908927752332145)
,p_name=>'P10_TASK_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(38396587393258104)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_prompt=>'Task'
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
,p_lov_cascade_parent_items=>'P10_PROJECT_NUMBER'
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
 p_id=>wwv_flow_api.id(36909391265332145)
,p_name=>'P10_EXPENDITURE_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(38396587393258104)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_prompt=>'Expenditure Type'
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
,p_lov_cascade_parent_items=>'P10_TASK_NUMBER'
,p_ajax_items_to_submit=>'P10_PROJECT_NUMBER,P10_TASK_NUMBER'
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
 p_id=>wwv_flow_api.id(37073081852729601)
,p_name=>'P10_SERVICE_AGREEMENT_MIMETYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_source=>'SERVICE_AGREEMENT_MIMETYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(37073140358729602)
,p_name=>'P10_SERVICE_AGREEMENT_CHARSET'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_source=>'SERVICE_AGREEMENT_CHARSET'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(37073226520729603)
,p_name=>'P10_SERVICE_AGREEMENT_LAST_UPDATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'SERVICE_AGREEMENT_LAST_UPDATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(37129415634203043)
,p_name=>'P10_DEPARTMENT_D'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(36896617369332154)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(37129516929203044)
,p_name=>'P10_DEPARTMENT_H'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(36896617369332154)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(37129742193203046)
,p_name=>'P10_TASK_H'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(36896617369332154)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(37129899582203047)
,p_name=>'P10_DEFAULT_DEPT'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(37129985470203048)
,p_prompt=>'Department'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'       (Select org.org_name ',
'       from organizations_v org',
'       where org.org_id = sp.department_id) org_name',
'from service_providers sp',
'where  sp.service_provider_id =  :P10_SERVICE_PROVIDER_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Default Department as per freelancer record.'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(37130099986203049)
,p_name=>'P10_DEFAULT_PROJECT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(37129985470203048)
,p_prompt=>'Project'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select sp.project_number ||',
'        '' (''                    ||',
'        PROJECT.PROJECT_NUMBER  ||',
'        '')''                         as PROJECT',
'from service_providers sp , project',
'where sp.project_number = project.project_number ',
'and sp.service_provider_id =  :P10_SERVICE_PROVIDER_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Default Project as per freelancer record.'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(37130121250203050)
,p_name=>'P10_DEFAULT_TASK'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(37129985470203048)
,p_prompt=>'Task'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select sp.task_number',
'from service_providers sp',
'where  sp.service_provider_id =  :P10_SERVICE_PROVIDER_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Default Task number as per freelancer record.'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38396269114258101)
,p_name=>'P10_DEFAULT_EXPENDITURE_TYPE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(37129985470203048)
,p_prompt=>'Expenditure Type'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select sp.expenditure_type',
'from service_providers sp',
'where  sp.service_provider_id =  :P10_SERVICE_PROVIDER_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(36092465792523099)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Default Expenditure type as per freelancer record.'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38396433117258103)
,p_name=>'P10_EXPENDITURE_TYPE_H'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(36896617369332154)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38396614939258105)
,p_name=>'P10_PROJECT_H'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(36896617369332154)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38396748545258106)
,p_name=>'P10_TASK_H2'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(36896617369332154)
,p_item_source_plug_id=>wwv_flow_api.id(36896617369332154)
,p_source=>'TASK_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38398593891258124)
,p_name=>'P10_GL_BUDGET_CODE_H'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(36733346791215632)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT BUDGET_GROUP_DESCRIPTION ',
'from dct_gl_code_combinations_all',
'where BUDGET_CODE = :P10_GL_BUDGET_CODE'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38398638429258125)
,p_name=>'P10_GL_ACCOUNT_H'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(36733346791215632)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT  ACCOUNT_DESCRIPTION',
'from dct_gl_code_combinations_all',
'where ACCOUNT_CODE = :P10_GL_ACCOUNT;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38398722661258126)
,p_name=>'P10_GL_ACTIVITY_H'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(36733346791215632)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT  ACTIVITY_DESCRIPTION',
'from dct_gl_code_combinations_all',
'where ACTIVITY_CODE  = :P10_GL_ACTIVITY'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38398804062258127)
,p_name=>'P10_GL_FUTURE1_H'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(36733346791215632)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT  FUTURE1_DESCRIPTION',
'from dct_gl_code_combinations_all',
'where FUTURE1  = :P10_GL_FUTURE1'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38398912774258128)
,p_name=>'P10_GL_FUTURE2_H'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(36733346791215632)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT FUTURE2_DESCRIPTION',
'from dct_gl_code_combinations_all',
'where FUTURE2   = :P10_GL_FUTURE2'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(36903956146332148)
,p_validation_name=>'P10_CREATED_ON must be timestamp'
,p_validation_sequence=>160
,p_validation=>'P10_CREATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(36903445164332149)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(36905054346332147)
,p_validation_name=>'P10_UPDATED_ON must be timestamp'
,p_validation_sequence=>180
,p_validation=>'P10_UPDATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(36904564762332148)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(36733064865215629)
,p_name=>'set default finance details DA'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_SERVICE_PROVIDER_ID'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(36733156484215630)
,p_event_id=>wwv_flow_api.id(36733064865215629)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_DEPARTMENT_H,P10_DEPARTMENT_D,P10_PROJECT_NUMBER,P10_PROJECT_H,P10_TASK_H,P10_EXPENDITURE_TYPE_H,P10_COST_CENTER_CODE,P10_GL_BUDGET_CODE,P10_GL_ACTIVITY,P10_GL_FUTURE1,P10_GL_FUTURE2,P10_GL_ACCOUNT'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select sp.department_id,',
'       (Select org.org_name ',
'       from organizations_v org',
'       where org.org_id = sp.department_id) org_name,',
'       sp.project_number,',
'       sp.project_number ||',
'        '' (''                    ||',
'        sp.PROJECT_NUMBER  ||',
'        '')'' as project,',
'       sp.task_number,',
'       sp.expenditure_type',
'       , nvl(t.cost_center , sp.cost_center) cost_center',
'       , t.budget_group_code',
'       , t.activity',
'       , t.future1',
'       , t.future2',
'       , (select e.gl_account',
'        from expenditure e',
'        where e.expenditure_type = sp.expenditure_type',
'        and e.project_number = sp.project_number',
'        and e.task_number = sp.task_number',
'        and ROWNUM = 1) GL_Account',
'from service_providers sp , project p , task t',
'where sp.project_number = t.project_number',
'and sp.project_number = p.project_number',
'and sp.task_number = t.task_number',
'and sp.service_provider_id =  :P10_SERVICE_PROVIDER_ID;'))
,p_attribute_07=>'P10_SERVICE_PROVIDER_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(37129625646203045)
,p_event_id=>wwv_flow_api.id(36733064865215629)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.item(''P10_DEFAULT_DEPT'').setValue($v(''P10_DEPARTMENT_D''))',
'apex.item(''P10_DEFAULT_PROJECT'').setValue($v(''P10_PROJECT_H''))',
'apex.item(''P10_DEFAULT_TASK'').setValue($v(''P10_TASK_H''))',
'apex.item(''P10_TASK_H2'').setValue($v(''P10_TASK_H''))',
'apex.item(''P10_DEFAULT_EXPENDITURE_TYPE'').setValue($v(''P10_EXPENDITURE_TYPE_H''))',
'',
'apex.item(''P10_ORG_ID'').setValue($v(''P10_DEPARTMENT_H''),$v(''P10_DEPARTMENT_D''))',
'apex.item(''P10_PROJECT_NUMBER'').setValue($v(''P10_PROJECT_NUMBER''),$v(''P10_PROJECT_NUMBER''))',
'apex.item(''P10_TASK_NUMBER'').setValue($v(''P10_TASK_H''),$v(''P10_TASK_H''))',
'apex.item(''P10_EXPENDITURE_TYPE'').setValue($v(''P10_EXPENDITURE_TYPE''),$v(''P10_EXPENDITURE_TYPE''))'))
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
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(36733452497215633)
,p_name=>'Set GL details By Task Changed DA'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_TASK_NUMBER'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(36733502787215634)
,p_event_id=>wwv_flow_api.id(36733452497215633)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_COST_CENTER_CODE,P10_GL_BUDGET_CODE,P10_GL_ACTIVITY,P10_GL_FUTURE1,P10_GL_FUTURE2'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select t.cost_center',
'      , t.budget_group_code',
'      , t.activity',
'      , t.future1',
'      , t.future2',
'from task t',
'where t.project_number = :P10_PROJECT_NUMBER',
'and t.task_number = :P10_TASK_NUMBER',
'and ROWNUM = 1'))
,p_attribute_07=>'P10_PROJECT_NUMBER,P10_TASK_NUMBER'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(36733696044215635)
,p_event_id=>wwv_flow_api.id(36733452497215633)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ADD_CLASS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_COST_CENTER_CODE'
,p_attribute_01=>'u-color-5'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(36921523766332136)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(36896617369332154)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Service Agreement Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(36921163978332137)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(36896617369332154)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Service Agreement Details'
);
wwv_flow_api.component_end;
end;
/
