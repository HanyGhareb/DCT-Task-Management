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
,p_default_id_offset=>100034894930602818
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>6
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Payment Request Approve/Reject'
,p_alias=>'PAYMENT-REQUEST-APPROVE-REJECT'
,p_step_title=>'Payment Request Approve/Reject'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'PLSQL_EXPRESSION'
,p_read_only_when=>':P6_STATUS not in (''Draft'' , ''Withdraw'' ,''Returned'')'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220414103503'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1706619039397884)
,p_plug_name=>'Lines - Direct'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_plug_comment=>'For Non PO Invoices '
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1706760029397885)
,p_plug_name=>'Lines Report'
,p_parent_plug_id=>wwv_flow_api.id(1706619039397884)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select prl.LINE_ID,',
'       prl.PAYMENT_REQUEST_ID,',
'       prl.PO_AVAILABLE_YN,',
'       prl.PO_NUMBER,',
'       prl.RECEIVING_NUMBER,',
'       prl.AMOUNT,',
'       prl.LINE_DESCRIPTION,',
'       prl.ENTITY_CODE,',
'       prl.COST_CENTER,',
'       prl.BUDGET_GROUP_CODE,',
'       prl.GL_ACCOUNT,',
'       prl.ACTIVITY,',
'       prl.FUTURE1,',
'       prl.FUTURE2,',
'       prl.PROJECT_NUMBER,',
'       prl.TASK_NUMBER,',
'       prl.EXPENDITURE_TYPE,',
'       prl.NOTES,',
'       prl.CREATED_BY,',
'       prl.CREATED_ON,',
'       prl.UPDATED_BY,',
'       prl.UPDATED_ON,',
'       prl.PO_LINE_NUM,',
'       prl.SHIPMENT_NUM,',
'       prl.RECEIPT_KEY,',
'       glc.full_code_combination,',
'       glc.full_code_combination_description  ,',
'',
'       ''   <i class="fa fa-trash" aria-hidden="true"></i>'' Del',
'  from PAYMENT_REQUEST_LINES prl , gl_code_combinations_v glc',
' where PAYMENT_REQUEST_ID = :P6_PAYMENT_REQUEST_ID',
' and prl.entity_code = glc.ENTITY_CODE (+)',
' and prl.cost_center = glc.cost_center_code(+)',
' and prl.budget_group_code = glc.budget_code(+)',
' and prl.gl_account = glc.account_code(+)',
' and prl.activity = glc.activity_code(+)',
' and prl.future1 = glc.future1(+)',
' and prl.future2 = glc.future2(+)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P6_PAYMENT_REQUEST_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Lines Report'
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
 p_id=>wwv_flow_api.id(1706832561397886)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>101741727492000704
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1706953207397887)
,p_db_column_name=>'LINE_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Line Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1707051890397888)
,p_db_column_name=>'FULL_CODE_COMBINATION'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Full Code Combination'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1707118621397889)
,p_db_column_name=>'FULL_CODE_COMBINATION_DESCRIPTION'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Full Code Combination Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1707292435397890)
,p_db_column_name=>'PAYMENT_REQUEST_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Payment Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1707397698397891)
,p_db_column_name=>'PO_AVAILABLE_YN'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'PO Available ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(66771378171803)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1707408721397892)
,p_db_column_name=>'PO_NUMBER'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'PO Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1707557867397893)
,p_db_column_name=>'RECEIVING_NUMBER'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Receipt Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1707652504397894)
,p_db_column_name=>'AMOUNT'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1707785728397895)
,p_db_column_name=>'LINE_DESCRIPTION'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1707813623397896)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1707933272397897)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1708079555397898)
,p_db_column_name=>'BUDGET_GROUP_CODE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Budget Group Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1708123706397899)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1708280779397900)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1708397189397901)
,p_db_column_name=>'FUTURE1'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1708435814397902)
,p_db_column_name=>'FUTURE2'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1708579412397903)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1708660030397904)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1708735683397905)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1708828750397906)
,p_db_column_name=>'NOTES'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1708954942397907)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(76622441183899)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1709094337397908)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1709144542397909)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(76622441183899)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1709298909397910)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1709324142397911)
,p_db_column_name=>'PO_LINE_NUM'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Po Line Num'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1709487626397912)
,p_db_column_name=>'SHIPMENT_NUM'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Shipment Num'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1709536505397913)
,p_db_column_name=>'RECEIPT_KEY'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Receipt Key'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1709644095397914)
,p_db_column_name=>'DEL'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Remove'
,p_column_link=>'javascript:void(0);'
,p_column_linktext=>'   <i class="fa fa-trash" aria-hidden="true"></i>'
,p_column_link_attr=>'onclick="delete_rec(this, #LINE_ID#)" title="Click to remove this line"'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_display_condition_type=>'NEVER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(1729794733494789)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1017647'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:FULL_CODE_COMBINATION:AMOUNT:LINE_DESCRIPTION:UPDATED_BY:UPDATED_ON:DEL:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(101578070083114839)
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
 p_id=>wwv_flow_api.id(101578729039114936)
,p_plug_name=>'Payment Request Details'
,p_icon_css_classes=>'fa-forms'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'PAYMENT_REQUESTS_ALL'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(101066365943300584)
,p_plug_name=>'Audit'
,p_parent_plug_id=>wwv_flow_api.id(101578729039114936)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P6_PAYMENT_REQUEST_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(102500618488797013)
,p_plug_name=>'Lines'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_plug_comment=>'For Matched Invoices'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(102500741719797014)
,p_plug_name=>'Lines Report'
,p_parent_plug_id=>wwv_flow_api.id(102500618488797013)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select prl.LINE_ID,',
'       prl.PAYMENT_REQUEST_ID,',
'       prl.PO_AVAILABLE_YN,',
'       prl.PO_NUMBER,',
'       prl.RECEIVING_NUMBER,',
'       prl.AMOUNT,',
'       prl.LINE_DESCRIPTION,',
'       prl.ENTITY_CODE,',
'       prl.COST_CENTER,',
'       prl.BUDGET_GROUP_CODE,',
'       prl.GL_ACCOUNT,',
'       prl.ACTIVITY,',
'       prl.FUTURE1,',
'       prl.FUTURE2,',
'       prl.PROJECT_NUMBER,',
'       prl.TASK_NUMBER,',
'       prl.EXPENDITURE_TYPE,',
'       prl.NOTES,',
'       prl.CREATED_BY,',
'       prl.CREATED_ON,',
'       prl.UPDATED_BY,',
'       prl.UPDATED_ON,',
'       prl.PO_LINE_NUM,',
'       prl.SHIPMENT_NUM,',
'       prl.RECEIPT_KEY,',
'       glc.full_code_combination,',
'       glc.full_code_combination_description  ,',
'',
'       ''   <i class="fa fa-trash" aria-hidden="true"></i>'' Del',
'  from PAYMENT_REQUEST_LINES prl , gl_code_combinations_v glc',
' where PAYMENT_REQUEST_ID = :P6_PAYMENT_REQUEST_ID',
' and prl.entity_code = glc.ENTITY_CODE (+)',
' and prl.cost_center = glc.cost_center_code(+)',
' and prl.budget_group_code = glc.budget_code(+)',
' and prl.gl_account = glc.account_code(+)',
' and prl.activity = glc.activity_code(+)',
' and prl.future1 = glc.future1(+)',
' and prl.future2 = glc.future2(+)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P6_PAYMENT_REQUEST_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Lines Report'
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
 p_id=>wwv_flow_api.id(102500820792797015)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>202535715723399833
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1458487226006689)
,p_db_column_name=>'LINE_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Line Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1458862378006689)
,p_db_column_name=>'PAYMENT_REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Payment Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1459262400006690)
,p_db_column_name=>'PO_AVAILABLE_YN'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'PO Available ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(66771378171803)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1459620861006690)
,p_db_column_name=>'PO_NUMBER'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'PO Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1460039986006690)
,p_db_column_name=>'RECEIVING_NUMBER'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Receipt Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1460491223006690)
,p_db_column_name=>'AMOUNT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1460894630006690)
,p_db_column_name=>'LINE_DESCRIPTION'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1461209263006691)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1461628938006691)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1462048629006691)
,p_db_column_name=>'BUDGET_GROUP_CODE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Budget Group Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1462450788006691)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1462873740006691)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1463228104006691)
,p_db_column_name=>'FUTURE1'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1463626939006692)
,p_db_column_name=>'FUTURE2'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1464025661006692)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1464491452006692)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1464890695006692)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1465300329006692)
,p_db_column_name=>'NOTES'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1465622769006693)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(76622441183899)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1466076273006693)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1466444608006693)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(76622441183899)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1466899110006693)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1467260569006693)
,p_db_column_name=>'PO_LINE_NUM'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Po Line Num'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1467650097006693)
,p_db_column_name=>'SHIPMENT_NUM'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Shipment Num'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1468012415006694)
,p_db_column_name=>'RECEIPT_KEY'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Receipt Key'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1468425606006694)
,p_db_column_name=>'DEL'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Remove'
,p_column_link=>'javascript:void(0);'
,p_column_linktext=>'   <i class="fa fa-trash" aria-hidden="true"></i>'
,p_column_link_attr=>'onclick="delete_rec(this, #LINE_ID#)" title="Click to remove this line"'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1468897723006694)
,p_db_column_name=>'FULL_CODE_COMBINATION'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Full Code Combination'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1469242755006695)
,p_db_column_name=>'FULL_CODE_COMBINATION_DESCRIPTION'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Full Code Combination Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(102579053059547820)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1015045'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PO_NUMBER:RECEIVING_NUMBER:PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:FULL_CODE_COMBINATION:NOTES:AMOUNT:DEL:'
,p_sum_columns_on_break=>'AMOUNT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(102567228125517906)
,p_plug_name=>'Attachments'
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P6_PAYMENT_REQUEST_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(102567274688517907)
,p_plug_name=>'Documents Report'
,p_parent_plug_id=>wwv_flow_api.id(102567228125517906)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'  SELECT',
'    id,',
'    PAYMENT_REQUEST_ID,',
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
'    payment_request_documents',
'where PAYMENT_REQUEST_ID = :P6_PAYMENT_REQUEST_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P6_PAYMENT_REQUEST_ID'
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
 p_id=>wwv_flow_api.id(102567371440517908)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No documents attached.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>202602266371120726
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1479249253006704)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1479641357006704)
,p_db_column_name=>'PAYMENT_REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Payment Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1480084937006705)
,p_db_column_name=>'FILENAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'File name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1480407630006705)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1480896335006705)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1481222564006705)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>60
,p_column_identifier=>'F'
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
 p_id=>wwv_flow_api.id(1481684397006706)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1482056323006706)
,p_db_column_name=>'TAGS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1482503335006706)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(76622441183899)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1482822792006706)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1483272707006706)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(76622441183899)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1483611802006706)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1484025749006707)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1484463003006707)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:PAYMENT_REQUEST_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED_ON:FILE_CHARSET:attachment::'
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
,p_default_id_offset=>100034894930602818
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(102767744864864537)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1015197'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:UPDATED_BY:UPDATED_ON:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(102771636887875899)
,p_plug_name=>'Approval History'
,p_icon_css_classes=>'fa-list'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_plug_display_when_condition=>'P6_STATUS'
,p_plug_display_when_cond2=>'Draft'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(102771681430875900)
,p_plug_name=>'Approval history Report'
,p_parent_plug_id=>wwv_flow_api.id(102771636887875899)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CC.ID,',
'       cc.PAYMENT_REQUEST_ID,',
'       STEP_NO,',
'       ACTION_REQUIRED,',
'       e.USER_NAME,',
'       STATUS,',
'       RECEVIED_DATE,',
'       ACTION_DATE,',
'       COMMENTS,',
'       ROLE_ID,',
'       cc.approval_type_id,',
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
'  from payment_request_APPROVAL_HISTORY cc,  dct_employees_list2  e',
'  where cc.person_id = e.person_id (+)',
'and  cc.payment_request_id = :P6_PAYMENT_REQUEST_ID',
'order by step_no , ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P6_PAYMENT_REQUEST_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Approval history Report'
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
 p_id=>wwv_flow_api.id(102771799217875901)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>202806694148478719
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1470627631006699)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1471056470006699)
,p_db_column_name=>'PAYMENT_REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Payment Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1471450979006699)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1471877930006699)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1472273582006700)
,p_db_column_name=>'USER_NAME'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'User Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1472641862006700)
,p_db_column_name=>'STATUS'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1473080810006700)
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
 p_id=>wwv_flow_api.id(1473424048006700)
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
 p_id=>wwv_flow_api.id(1473884693006700)
,p_db_column_name=>'COMMENTS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1474266229006701)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Role'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1331628103907598)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1474655673006701)
,p_db_column_name=>'APPROVAL_TYPE_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Approval Type Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1475104315006701)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1475450473006701)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1475822907006701)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1476292925006701)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1476663224006702)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1477053379006702)
,p_db_column_name=>'PHOTO'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(102819652119463368)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1015123'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:PHOTO:FULL_NAME_EN:ACTION_REQUIRED:ROLE_ID:USER_NAME:STATUS:RECEVIED_DATE:ACTION_DATE:COMMENTS:'
,p_sort_column_1=>'STEP_NO'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'ID'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(1585818475088688)
,p_report_id=>wwv_flow_api.id(102819652119463368)
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
 p_id=>wwv_flow_api.id(102836172918793176)
,p_plug_name=>'Instructions'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--stacked:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<table style="font-family: arial, sans-serif; border-collapse: collapse; width: 97.9661%; font-size: 18px; height: 147px;">',
'<tbody>',
'<tr style="height: 18px;">',
'<td style="font-family: arial, sans-serif; border-collapse: collapse; width: 50%; border: 1px none #dddddd; padding: 8px; color: red; height: 18px; text-align: left;"><strong>General Instructions:</strong></td>',
'</tr>',
'<tr style="height: 129px;">',
'<td style="text-align: left; vertical-align: text-top; width: 50%; height: 129px;">',
'<p>To accelerate the payment process and avoid the reject for the payment request, please make sure you are follow below instructions:</p>',
'<ol>',
'<li>you have attach a clear invoice scan copy.</li>',
'<li>you have attache any supported documents like: delivery note,..etc</li>',
'</ol>',
'</td>',
'</tr>',
'</tbody>',
'</table>'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P6_STATUS  in (''Draft'' , ''Withdraw'' ,''Returned'')'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1489391743006722)
,p_button_sequence=>220
,p_button_plug_id=>wwv_flow_api.id(101578729039114936)
,p_button_name=>'Save_and_Select_Receiving_Numbers_new'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Save And Select Receiving Numbers'
,p_button_position=>'BODY'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-save'
,p_grid_new_row=>'N'
,p_grid_column=>4
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1489783920006723)
,p_button_sequence=>230
,p_button_plug_id=>wwv_flow_api.id(101578729039114936)
,p_button_name=>'Save_and_Select_Receiving_Numbers_update'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--padRight:t-Button--padTop'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Save And Select Receiving Numbers u'
,p_button_position=>'BODY'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-save'
,p_grid_new_row=>'N'
,p_grid_column=>4
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1478556138006703)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(102567228125517906)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--noUI:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Add Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:4:P4_PAYMENT_REQUEST_ID,P4_PAGE_FROM:&P6_PAYMENT_REQUEST_ID.,2'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1487091071006719)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(101578070083114839)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1348346648183729)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(101578070083114839)
,p_button_name=>'Send_Update'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Send Update'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:7:P7_ACTION,P7_HISTORY_ID,P7_PAYMENT_REQUEST_ID,P7_ROLE_ID,P7_STEP_NO:MORE_INFO,&P6_HISTORY_ID.,&P6_PAYMENT_REQUEST_ID.,&P6_ROLE_ID.,&P6_STEP_NO.'
,p_button_condition=>'P6_MORE_INFO'
,p_button_condition2=>'Y'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1344260338183688)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(101578070083114839)
,p_button_name=>'Approve'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'&P6_APPROVE_LABEL.'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:7:P7_ACTION,P7_APPROVAL_LABEL,P7_HISTORY_ID,P7_PAYMENT_REQUEST_ID,P7_REJECT_LABEL,P7_ROLE_ID,P7_STEP_NO:Approve,&P6_APPROVE_LABEL.,&P6_HISTORY_ID.,&P6_PAYMENT_REQUEST_ID.,&P6_REJECT_LABEL.,&P6_ROLE_ID.,&P6_STEP_NO.'
,p_button_condition=>'P6_MORE_INFO'
,p_button_condition2=>'Y'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_icon_css_classes=>'fa-thumbs-up fa-anim-flash'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1344628087183692)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(101578070083114839)
,p_button_name=>'Reject'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--danger:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'&P6_REJECT_LABEL.'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.::P7_ACTION,P7_APPROVAL_LABEL,P7_HISTORY_ID,P7_PAYMENT_REQUEST_ID,P7_REJECT_LABEL,P7_ROLE_ID,P7_STEP_NO:Reject,&P6_APPROVE_LABEL.,&P6_HISTORY_ID.,&P6_PAYMENT_REQUEST_ID.,&P6_REJECT_LABEL.,&P6_ROLE_ID.,&P6_STEP_NO.'
,p_button_condition=>'P6_MORE_INFO'
,p_button_condition2=>'Y'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_icon_css_classes=>'fa-thumbs-o-down fa-anim-flash'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1344783240183693)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(101578070083114839)
,p_button_name=>'Delegate'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Delegate'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:7:P7_ACTION,P7_HISTORY_ID,P7_PAYMENT_REQUEST_ID,P7_ROLE_ID,P7_STEP_NO:Delegate,&P6_HISTORY_ID.,&P6_PAYMENT_REQUEST_ID.,&P6_ROLE_ID.,&P6_STEP_NO.'
,p_button_condition=>'P6_MORE_INFO'
,p_button_condition2=>'Y'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_icon_css_classes=>'fa-sign-language'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1344819630183694)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(101578070083114839)
,p_button_name=>'Return'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Return'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:7:P7_ACTION,P7_HISTORY_ID,P7_PAYMENT_REQUEST_ID,P7_ROLE_ID,P7_STEP_NO:Return,&P6_HISTORY_ID.,&P6_PAYMENT_REQUEST_ID.,&P6_ROLE_ID.,&P6_STEP_NO.'
,p_button_condition=>'P6_MORE_INFO'
,p_button_condition2=>'Y'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_icon_css_classes=>'fa-info'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(1538547301006752)
,p_branch_name=>'Go to 3- select PO lines New'
,p_branch_action=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:3:P3_PAYMENT_REQUEST_ID,P3_CURRENCY,P3_VENDOR_NUMBER,P3_VENDOR_SITE_CODE:&P6_PAYMENT_REQUEST_ID.,&P6_CURRENCY_CODE.,&P6_VENDOR_NUMBER.,&P6_VENDOR_SITE_CODE.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(1489391743006722)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(1539365442006753)
,p_branch_name=>'stay in 2'
,p_branch_action=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.::P6_PAYMENT_REQUEST_ID:&P6_PAYMENT_REQUEST_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
,p_branch_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_branch_condition=>'remove_line'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(1538941638006753)
,p_branch_name=>'Go to 3- select PO lines update'
,p_branch_action=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:3:P3_PAYMENT_REQUEST_ID,P3_VENDOR_NUMBER,P3_VENDOR_SITE_CODE,P3_CURRENCY:&P6_PAYMENT_REQUEST_ID.,&P6_VENDOR_NUMBER.,&P6_VENDOR_SITE_CODE.,&P6_CURRENCY_CODE.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(1489783920006723)
,p_branch_sequence=>30
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(1539717750006753)
,p_branch_name=>'Go To Declaration Page'
,p_branch_action=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:5:P5_APPROVAL_TYPE,P5_PAYMENT_REQUEST_ID:41,&P6_PAYMENT_REQUEST_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>40
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(1538108721006752)
,p_branch_name=>'Go To Page 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>50
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1343880297183684)
,p_name=>'P6_ROLE_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(101578070083114839)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1344069985183686)
,p_name=>'P6_ACTION_REQUIRED'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(101578070083114839)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1344347600183689)
,p_name=>'P6_APPROVE_LABEL'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(101578070083114839)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1344448507183690)
,p_name=>'P6_REJECT_LABEL'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(101578070083114839)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1348199135183727)
,p_name=>'P6_STEP_NO'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(101578070083114839)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1348218741183728)
,p_name=>'P6_MORE_INFO'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(101578070083114839)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1488621234006720)
,p_name=>'P6_HISTORY_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(101578070083114839)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1490120337006723)
,p_name=>'P6_PAYMENT_REQUEST_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Payment Request Id'
,p_source=>'PAYMENT_REQUEST_ID'
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
 p_id=>wwv_flow_api.id(1490560488006723)
,p_name=>'P6_REQUESTOR_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_default=>'PERSON_ID'
,p_item_default_type=>'ITEM'
,p_prompt=>'Request For'
,p_source=>'REQUESTOR_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1490956851006724)
,p_name=>'P6_REQUEST_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Request Number'
,p_source=>'REQUEST_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>50
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1491323158006724)
,p_name=>'P6_VENDOR_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
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
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_10=>'VENDOR_SITE_CODE:P6_VENDOR_SITE_CODE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1491758753006724)
,p_name=>'P6_REQUEST_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_default=>'SYSDATE'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'Request Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'REQUEST_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1492142002006725)
,p_name=>'P6_VENDOR_SITE_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Vendor Site Code'
,p_source=>'VENDOR_SITE_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>50
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1492505365006725)
,p_name=>'P6_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_default=>'Draft'
,p_prompt=>'Status'
,p_source=>'STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1492963902006725)
,p_name=>'P6_INVOICE_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Invoice Number'
,p_source=>'INVOICE_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>50
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1493347942006725)
,p_name=>'P6_PRIORITY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_default=>'122'
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
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1493803830006726)
,p_name=>'P6_INVOICE_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Invoice Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'INVOICE_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1494163535006726)
,p_name=>'P6_INVOICE_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Invoice Amount'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'INVOICE_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_help_text=>'Total invoice amount including VAT, if applicable.'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1495028527006727)
,p_name=>'P6_TOTAL_LINE_AMUNT'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Total Line Amunt'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(nvl(sum(amount),0), ''99,999,999,999.99''))',
'from payment_request_lines',
'where payment_request_id = :P6_PAYMENT_REQUEST_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1495459436006727)
,p_name=>'P6_AMOUNT_STATUS'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_line_total    number;',
'l_return           varchar2(512);',
'begin',
'',
'select sum(amount) * decode(:P6_VAT_APPLIED_YN , ''Y'', 1.05, 1)',
'into l_line_total',
'from payment_request_lines',
'where payment_request_id = :P6_payment_request_id;',
'',
'if l_line_total  = REPLACE(:P6_INVOICE_AMOUNT,'','','''')',
'    Then ',
'    l_return := ''<span aria-hidden="true" class="fa fa-check fam-check fam-is-success"></span>'';',
'    else',
'    l_return := ''<span aria-hidden="true" class="fa fa-times fam-check fam-is-danger"></span>'';',
'End if;',
'',
'return l_return;',
'',
'end;'))
,p_source_type=>'FUNCTION_BODY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
,p_item_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_line_total    number;',
'l_return           varchar2(50);',
'begin',
'',
'select sum(amount) * decode(:P6_VAT_APPLIED_YN , ''Y'', 1.05, 1)',
'into l_line_total',
'from payment_request_lines',
'where payment_request_id = :P6_payment_request_id;',
'',
'if l_line_total  = REPLACE(:P6_INVOICE_AMOUNT,'','','''')',
'    Then ',
'    l_return := ''fa fa-check-circle'';',
'    else',
'    l_return := ''<span aria-hidden="true" class="fa fa-times fam-check fam-is-danger"></span>'';',
'End if;',
'',
'end;'))
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1495896038006728)
,p_name=>'P6_CURRENCY_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_default=>'AED'
,p_prompt=>'Currency'
,p_source=>'CURRENCY_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'CURRENCY LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value  d , value r',
'from dct_lookup_values',
'where lookup_id = 11'))
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
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
,p_default_id_offset=>100034894930602818
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1496255248006728)
,p_name=>'P6_IBAN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'IBAN'
,p_source=>'IBAN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>50
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1496626962006729)
,p_name=>'P6_BANK_ACCOUNT_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Bank Account Name'
,p_source=>'BANK_ACCOUNT_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1497100388006729)
,p_name=>'P6_BANK_ACCOUNT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Bank Account'
,p_source=>'BANK_ACCOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1497457420006729)
,p_name=>'P6_BANK_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Bank Name'
,p_source=>'BANK_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>40
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1497807192006729)
,p_name=>'P6_VAT_APPLIED_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_default=>'Y'
,p_prompt=>'VAT Applied ?'
,p_source=>'VAT_APPLIED_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(66771378171803)||'.'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1498212974006730)
,p_name=>'P6_INVOICE_DESCRIPTION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Invoice Description'
,p_source=>'INVOICE_DESCRIPTION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>255
,p_cHeight=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1498700644006730)
,p_name=>'P6_PO_AVAILABLE_YN'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_default=>'N'
,p_prompt=>'I have PO /Receiving :'
,p_source=>'PO_AVAILABLE_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_colspan=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1499011774006730)
,p_name=>'P6_MULTIPLE_PO_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_default=>'N'
,p_prompt=>'I have multiple PO'
,p_source=>'MULTIPLE_PO_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1499416354006730)
,p_name=>'P6_OU_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_default=>'Tourism and Culture Authority OU'
,p_source=>'OU_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1499747107006730)
,p_name=>'P6_VENDOR_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_source=>'VENDOR_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1500173573006730)
,p_name=>'P6_ADVANCE_PAYMENT_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_default=>'N'
,p_prompt=>'It''s Advance Payment ?'
,p_source=>'ADVANCE_PAYMENT_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1500557778006731)
,p_name=>'P6_BANK_GURANTEE_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Bank Guarantee Number'
,p_source=>'BANK_GURANTEE_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>128
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1500973933006731)
,p_name=>'P6_NOTES'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Note to Account Payables'
,p_source=>'NOTES'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>4000
,p_cHeight=>4
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1501379100006731)
,p_name=>'P6_SUBMITTED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Submitted On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'SUBMITTED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P6_STATUS'
,p_display_when2=>'in-Progress'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1501787695006731)
,p_name=>'P6_SUBMITTED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Submitted By'
,p_source=>'SUBMITTED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'Employee FULL NAME RETURN PERSON ID'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en , person_id',
'from employees_v',
''))
,p_display_when=>'P6_STATUS'
,p_display_when2=>'in-Progress'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1502186926006731)
,p_name=>'P6_FINAL_APPROVED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>320
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Final Approved On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'FINAL_APPROVED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P6_STATUS'
,p_display_when2=>'Approved'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1502554806006732)
,p_name=>'P6_FINAL_APPROVED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>330
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Final Approved By'
,p_source=>'FINAL_APPROVED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'Employee FULL NAME RETURN PERSON ID'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en , person_id',
'from employees_v',
''))
,p_display_when=>'P6_STATUS'
,p_display_when2=>'Approved'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1502973365006732)
,p_name=>'P6_REJECT_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>340
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Reject By'
,p_source=>'REJECT_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'Employee FULL NAME RETURN PERSON ID'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en , person_id',
'from employees_v',
''))
,p_display_when=>'P6_STATUS'
,p_display_when2=>'Rejected'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1503384284006732)
,p_name=>'P6_REJECT_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>350
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Rejected On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'REJECT_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P6_STATUS'
,p_display_when2=>'Rejected'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1503766436006732)
,p_name=>'P6_REJECT_REASON'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>360
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Reject Reason'
,p_source=>'REJECT_REASON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>1000
,p_cHeight=>2
,p_display_when=>'P6_STATUS'
,p_display_when2=>'Rejected'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1504157098006732)
,p_name=>'P6_VOUCHER_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>370
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Voucher Number'
,p_source=>'VOUCHER_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1504603908006732)
,p_name=>'P6_PV_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>380
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'PV Status'
,p_source=>'PV_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1504956360006733)
,p_name=>'P6_PAYMENT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>390
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Payment Number'
,p_source=>'PAYMENT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1505354411006733)
,p_name=>'P6_PAYMENT_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>400
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Payment Status'
,p_source=>'PAYMENT_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1505780823006733)
,p_name=>'P6_CLEAR_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>410
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Clear Status'
,p_source=>'CLEAR_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1506175174006733)
,p_name=>'P6_CLEAR_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>420
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Clear Date'
,p_source=>'CLEAR_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1506506728006733)
,p_name=>'P6_ENTITY_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>430
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Entity Code'
,p_source=>'ENTITY_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>7
,p_cMaxlength=>3
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1506994144006734)
,p_name=>'P6_COST_CENTER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>440
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Cost Center'
,p_source=>'COST_CENTER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>7
,p_cMaxlength=>7
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1507327111006734)
,p_name=>'P6_BUDGET_GROUP_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>450
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Budget Group Code'
,p_source=>'BUDGET_GROUP_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>7
,p_cMaxlength=>1
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1507747888006734)
,p_name=>'P6_GL_ACCOUNT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>460
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Gl Account'
,p_source=>'GL_ACCOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>7
,p_cMaxlength=>6
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1508108183006734)
,p_name=>'P6_ACTIVITY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>470
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Activity'
,p_source=>'ACTIVITY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>7
,p_cMaxlength=>6
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1508543482006734)
,p_name=>'P6_FUTURE1'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>480
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Future1'
,p_source=>'FUTURE1'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>7
,p_cMaxlength=>6
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1508935683006734)
,p_name=>'P6_FUTURE2'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>490
,p_item_plug_id=>wwv_flow_api.id(101578729039114936)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Future2'
,p_source=>'FUTURE2'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>7
,p_cMaxlength=>6
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1510493003006736)
,p_name=>'P6_CREATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>390
,p_item_plug_id=>wwv_flow_api.id(101066365943300584)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Created By'
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'Employee FULL NAME RETURN PERSON ID'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en , person_id',
'from employees_v',
''))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1510855164006736)
,p_name=>'P6_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>400
,p_item_plug_id=>wwv_flow_api.id(101066365943300584)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Created On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1511258338006736)
,p_name=>'P6_UPDATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>410
,p_item_plug_id=>wwv_flow_api.id(101066365943300584)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Updated By'
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'Employee FULL NAME RETURN PERSON ID'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en , person_id',
'from employees_v',
''))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1511621630006736)
,p_name=>'P6_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>420
,p_item_plug_id=>wwv_flow_api.id(101066365943300584)
,p_item_source_plug_id=>wwv_flow_api.id(101578729039114936)
,p_prompt=>'Updated On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(1527181254006746)
,p_validation_name=>'P6_SUBMITTED_ON must be timestamp'
,p_validation_sequence=>310
,p_validation=>'P6_SUBMITTED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(1501379100006731)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(1527533314006746)
,p_validation_name=>'P6_FINAL_APPROVED_ON must be timestamp'
,p_validation_sequence=>330
,p_validation=>'P6_FINAL_APPROVED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(1502186926006731)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(1527924121006747)
,p_validation_name=>'P6_REJECT_ON must be timestamp'
,p_validation_sequence=>360
,p_validation=>'P6_REJECT_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(1503384284006732)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(1528322781006747)
,p_validation_name=>'P6_CREATED_ON must be timestamp'
,p_validation_sequence=>390
,p_validation=>'P6_CREATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(1510855164006736)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(1528754686006747)
,p_validation_name=>'P6_UPDATED_ON must be timestamp'
,p_validation_sequence=>410
,p_validation=>'P6_UPDATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(1511621630006736)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1532708169006750)
,p_name=>'Bank Guarantee Display Control DA'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P6_ADVANCE_PAYMENT_YN'
,p_condition_element=>'P6_ADVANCE_PAYMENT_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'N'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1533240125006750)
,p_event_id=>wwv_flow_api.id(1532708169006750)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P6_BANK_GURANTEE_NUMBER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1533779658006750)
,p_event_id=>wwv_flow_api.id(1532708169006750)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P6_BANK_GURANTEE_NUMBER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1534152934006750)
,p_name=>'Multiple PO Display Control DA '
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P6_PO_AVAILABLE_YN'
,p_condition_element=>'P6_PO_AVAILABLE_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1535629431006751)
,p_event_id=>wwv_flow_api.id(1534152934006750)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(1489783920006723)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1710054061397918)
,p_event_id=>wwv_flow_api.id(1534152934006750)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(1706619039397884)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1534621007006751)
,p_event_id=>wwv_flow_api.id(1534152934006750)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(1489391743006722)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1709986890397917)
,p_event_id=>wwv_flow_api.id(1534152934006750)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(102500618488797013)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1535105602006751)
,p_event_id=>wwv_flow_api.id(1534152934006750)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(1489391743006722)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1709725026397915)
,p_event_id=>wwv_flow_api.id(1534152934006750)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(102500618488797013)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1537647892006752)
,p_event_id=>wwv_flow_api.id(1534152934006750)
,p_event_result=>'FALSE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(1489783920006723)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1709845093397916)
,p_event_id=>wwv_flow_api.id(1534152934006750)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(1706619039397884)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1536138285006751)
,p_event_id=>wwv_flow_api.id(1534152934006750)
,p_event_result=>'FALSE'
,p_action_sequence=>50
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P6_MULTIPLE_PO_YN'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1536690281006751)
,p_event_id=>wwv_flow_api.id(1534152934006750)
,p_event_result=>'FALSE'
,p_action_sequence=>60
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'delete from payment_request_lines where payment_request_id = :P6_PAYMENT_REQUEST_ID and PO_AVAILABLE_YN = ''Y''; '
,p_attribute_02=>'P6_PAYMENT_REQUEST_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1537108685006752)
,p_event_id=>wwv_flow_api.id(1534152934006750)
,p_event_result=>'FALSE'
,p_action_sequence=>70
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(102500741719797014)
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
,p_default_id_offset=>100034894930602818
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1531874573006749)
,p_name=>'Refresh Documents report DA'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(1478556138006703)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1532325814006749)
,p_event_id=>wwv_flow_api.id(1531874573006749)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(102567274688517907)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1344177452183687)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'set history details'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ROLE_ID, ACTION_REQUIRED , step_no, MORE_INFO',
'into :P6_ROLE_ID, :P6_ACTION_REQUIRED, :P6_STEP_NO, :P6_MORE_INFO',
'from payment_request_approval_history',
'where id = :P6_HISTORY_ID;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1344508980183691)
,p_process_sequence=>20
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get Approve reject labels'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  case action_required when ''Approve/Reject''   then ''Approve''',
'                             when ''Endorse/Return'' then ''Endorse''',
'                             else ''Approve''',
'        end,',
'        case action_required when ''Approve/Reject''   then ''Reject''',
'                             when ''Endorse/Return'' then ''Return''',
'                             else ''Reject''',
'        end',
'into :P6_APPROVE_LABEL, :P6_REJECT_LABEL',
'from payment_request_approval_history',
'where id = :P6_HISTORY_ID',
'and person_id = :PERSON_ID',
'and status = ''Pending''',
'and ROWNUM = 1;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1509787613006735)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(101578729039114936)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Payment Request Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1509314981006735)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(101578729039114936)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Payment Request Details'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1529066699006747)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delete From Line'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
' DELETE FROM payment_request_lines',
'  WHERE LINE_ID =  apex_application.g_x01;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
