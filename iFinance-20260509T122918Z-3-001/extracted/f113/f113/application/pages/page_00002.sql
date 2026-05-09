prompt --application/pages/page_00002
begin
--   Manifest
--     PAGE: 00002
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
 p_id=>2
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Payment Request Details'
,p_alias=>'PAYMENT-REQUEST-DETAILS'
,p_step_title=>'Payment Request Details'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';',
'',
'function delete_rec(p_val, p_row) {',
'    var rec = $(p_val).closest(''tr'');',
'    apex.server.process(',
'        ''Delete From Line'', // Process or AJAX Callback name',
'    {',
'        x01: p_row',
'    }, // Parameter "x01"',
'    {',
'        beforeSend: function () {',
'            alert(''Are you sure want to delete this line'' + p_row);',
'            rec.removeClass(''vikas'');',
'            rec.removeClass(''pandey'');',
'            rec.children().hover(function () {',
'                rec.children().animate({',
'                    ''backgroundColor'': ''#71e817''',
'                }, 300);',
'            },',
'                function () {',
'                rec.children().animate({',
'                    ''backgroundColor'': ''#71e817''',
'                }, 300);',
'            });',
'            rec.children().animate({',
'                ''backgroundColor'': ''#71e817''',
'            }, 300);',
'        },',
'',
'        success: function (pData) {',
'',
'            // Success Javascript',
'            rec.children().wrapInner(''<div>'').children().fadeOut(500,',
'                function () {',
'                rec.remove(); // visually remove the row from the report',
'            });',
'        },',
'        dataType: "text" // Response type (here: plain text)',
'',
'    });',
'	',
'	//apex.submit( ''DELETE'' );',
'    apex.submit(''remove_line'');',
'}'))
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'document.getElementById("P2_VENDOR_SITE_CODE").readOnly = true;',
'document.getElementById("P2_BANK_ACCOUNT_NAME").readOnly = true;',
'document.getElementById("P2_BANK_ACCOUNT").readOnly = true;',
'document.getElementById("P2_BANK_NAME").readOnly = true;'))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'PLSQL_EXPRESSION'
,p_read_only_when=>':P2_STATUS not in (''Draft'' , ''Withdraw'' ,''Returned'')'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220411100027'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(85623998505346)
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
 p_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(426080141308909)
,p_plug_name=>'Audit'
,p_parent_plug_id=>wwv_flow_api.id(86282954505443)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P2_PAYMENT_REQUEST_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1008172404187520)
,p_plug_name=>'Lines'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1',
'from payment_request_lines',
'where payment_request_id = :P2_PAYMENT_REQUEST_ID;'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1008295635187521)
,p_plug_name=>'Lines Report'
,p_parent_plug_id=>wwv_flow_api.id(1008172404187520)
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
' where PAYMENT_REQUEST_ID = :P2_PAYMENT_REQUEST_ID',
' and prl.entity_code = glc.ENTITY_CODE (+)',
' and prl.cost_center = glc.cost_center_code(+)',
' and prl.budget_group_code = glc.budget_code(+)',
' and prl.gl_account = glc.account_code(+)',
' and prl.activity = glc.activity_code(+)',
' and prl.future1 = glc.future1(+)',
' and prl.future2 = glc.future2(+)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P2_PAYMENT_REQUEST_ID'
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
 p_id=>wwv_flow_api.id(1008374708187522)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>101043269638790340
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1008501502187523)
,p_db_column_name=>'LINE_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Line Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1008573651187524)
,p_db_column_name=>'PAYMENT_REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Payment Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1008621875187525)
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
 p_id=>wwv_flow_api.id(1008762193187526)
,p_db_column_name=>'PO_NUMBER'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'PO Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1008816802187527)
,p_db_column_name=>'RECEIVING_NUMBER'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Receipt Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1008922976187528)
,p_db_column_name=>'AMOUNT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1009084298187529)
,p_db_column_name=>'LINE_DESCRIPTION'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1009118503187530)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1009266239187531)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1009384309187532)
,p_db_column_name=>'BUDGET_GROUP_CODE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Budget Group Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1071768633908383)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1071829512908384)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1071983323908385)
,p_db_column_name=>'FUTURE1'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1072009488908386)
,p_db_column_name=>'FUTURE2'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1072134085908387)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1072229574908388)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1072402118908389)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1072432809908390)
,p_db_column_name=>'NOTES'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1072593249908391)
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
 p_id=>wwv_flow_api.id(1072658625908392)
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
 p_id=>wwv_flow_api.id(1072730779908393)
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
 p_id=>wwv_flow_api.id(1072839109908394)
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
 p_id=>wwv_flow_api.id(1072930103908395)
,p_db_column_name=>'PO_LINE_NUM'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Po Line Num'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1073007951908396)
,p_db_column_name=>'SHIPMENT_NUM'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Shipment Num'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1073150612908397)
,p_db_column_name=>'RECEIPT_KEY'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Receipt Key'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1073257663908398)
,p_db_column_name=>'DEL'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Remove'
,p_column_link=>'javascript:void(0);'
,p_column_linktext=>'   <i class="fa fa-trash" aria-hidden="true"></i>'
,p_column_link_attr=>'onclick="delete_rec(this, #LINE_ID#)" title="Click to remove this line"'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P2_STATUS in (''Draft'' , ''Returned'' , ''Withdraw'')'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1073311126908399)
,p_db_column_name=>'FULL_CODE_COMBINATION'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Full Code Combination'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1073418882908400)
,p_db_column_name=>'FULL_CODE_COMBINATION_DESCRIPTION'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Full Code Combination Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(1086606974938327)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1011216'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PO_NUMBER:RECEIVING_NUMBER:PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:FULL_CODE_COMBINATION:NOTES:AMOUNT:DEL:'
,p_sum_columns_on_break=>'AMOUNT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1074782040908413)
,p_plug_name=>'Attachments'
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P2_PAYMENT_REQUEST_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1074828603908414)
,p_plug_name=>'Documents Report'
,p_parent_plug_id=>wwv_flow_api.id(1074782040908413)
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
'where PAYMENT_REQUEST_ID = :P2_PAYMENT_REQUEST_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P2_PAYMENT_REQUEST_ID'
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
 p_id=>wwv_flow_api.id(1074925355908415)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No documents attached.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>101109820286511233
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1075035940908416)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1075117649908417)
,p_db_column_name=>'PAYMENT_REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Payment Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1075275497908418)
,p_db_column_name=>'FILENAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'File name'
,p_column_link=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:4:P4_ID,P4_APPROVAL_STATUS,P4_PAGE_FROM:#ID#,&P2_STATUS.,2'
,p_column_linktext=>'#FILENAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1075392779908419)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1075488391908420)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1075594828908421)
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
 p_id=>wwv_flow_api.id(1075614976908422)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1075763690908423)
,p_db_column_name=>'TAGS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1075829778908424)
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
 p_id=>wwv_flow_api.id(1075993942908425)
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
 p_id=>wwv_flow_api.id(1076008973908426)
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
 p_id=>wwv_flow_api.id(1076172731908427)
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
 p_id=>wwv_flow_api.id(1076206063908428)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1076324235908429)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:PAYMENT_REQUEST_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED_ON:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(1275298780255044)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1013102'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:UPDATED_BY:UPDATED_ON:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1279190803266406)
,p_plug_name=>'Approval History'
,p_icon_css_classes=>'fa-list'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_plug_display_when_condition=>'P2_STATUS'
,p_plug_display_when_cond2=>'Draft'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1279235346266407)
,p_plug_name=>'Approval history Report'
,p_parent_plug_id=>wwv_flow_api.id(1279190803266406)
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
'and  cc.payment_request_id = :P2_PAYMENT_REQUEST_ID',
'order by step_no , ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P2_PAYMENT_REQUEST_ID'
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
 p_id=>wwv_flow_api.id(1279353133266408)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>101314248063869226
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1279436759266409)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1279523294266410)
,p_db_column_name=>'PAYMENT_REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Payment Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1279689080266411)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1279772243266412)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1279903479266413)
,p_db_column_name=>'USER_NAME'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'User Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1279920670266414)
,p_db_column_name=>'STATUS'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1280062494266415)
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
 p_id=>wwv_flow_api.id(1280153739266416)
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
 p_id=>wwv_flow_api.id(1280261628266417)
,p_db_column_name=>'COMMENTS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1280382551266418)
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
 p_id=>wwv_flow_api.id(1280460364266419)
,p_db_column_name=>'APPROVAL_TYPE_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Approval Type Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1280584660266420)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1280630451266421)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1280726990266422)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1280821442266423)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1280967662266424)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1281024530266425)
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
 p_id=>wwv_flow_api.id(1327206034853875)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1013622'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:PHOTO:FULL_NAME_EN:ACTION_REQUIRED:ROLE_ID:USER_NAME:STATUS:RECEVIED_DATE:ACTION_DATE:COMMENTS:'
,p_sort_column_1=>'STEP_NO'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(2729007524317268)
,p_report_id=>wwv_flow_api.id(1327206034853875)
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1343726834183683)
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
'<p>To accelerate the payment process and avoid any delay to process your payment request, please make sure you are follow below instructions:</p>',
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
,p_plug_display_when_condition=>':P2_STATUS  in (''Draft'' , ''Withdraw'' ,''Returned'')'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1710439748397922)
,p_plug_name=>'Lines - Direct'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1',
'from payment_request_lines',
'where payment_request_id = :P2_PAYMENT_REQUEST_ID;'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1710593824397923)
,p_plug_name=>'Lines Report'
,p_parent_plug_id=>wwv_flow_api.id(1710439748397922)
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
' where PAYMENT_REQUEST_ID = :P2_PAYMENT_REQUEST_ID',
' and prl.entity_code = glc.ENTITY_CODE (+)',
' and prl.cost_center = glc.cost_center_code(+)',
' and prl.budget_group_code = glc.budget_code(+)',
' and prl.gl_account = glc.account_code(+)',
' and prl.activity = glc.activity_code(+)',
' and prl.future1 = glc.future1(+)',
' and prl.future2 = glc.future2(+)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P2_PAYMENT_REQUEST_ID'
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
 p_id=>wwv_flow_api.id(1710661688397924)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>101745556619000742
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1710728283397925)
,p_db_column_name=>'LINE_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Line Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1710867857397926)
,p_db_column_name=>'FULL_CODE_COMBINATION'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'GL Code Combination'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1710913355397927)
,p_db_column_name=>'FULL_CODE_COMBINATION_DESCRIPTION'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'GL Code Combination Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1711025243397928)
,p_db_column_name=>'PAYMENT_REQUEST_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Payment Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1711196397397929)
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
 p_id=>wwv_flow_api.id(1711304078397930)
,p_db_column_name=>'PO_NUMBER'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'PO Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1711328899397931)
,p_db_column_name=>'RECEIVING_NUMBER'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Receipt Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1711488010397932)
,p_db_column_name=>'AMOUNT'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1740464051943083)
,p_db_column_name=>'LINE_DESCRIPTION'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1740559087943084)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1740623566943085)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1740771657943086)
,p_db_column_name=>'BUDGET_GROUP_CODE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Budget Group Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1740832079943087)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1740950952943088)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1741054049943089)
,p_db_column_name=>'FUTURE1'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1741177258943090)
,p_db_column_name=>'FUTURE2'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1741286567943091)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1741343968943092)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1741438915943093)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1741562511943094)
,p_db_column_name=>'NOTES'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1741686234943095)
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
 p_id=>wwv_flow_api.id(1741796872943096)
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
 p_id=>wwv_flow_api.id(1741899313943097)
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
 p_id=>wwv_flow_api.id(1741940121943098)
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
 p_id=>wwv_flow_api.id(1742031172943099)
,p_db_column_name=>'PO_LINE_NUM'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Po Line Num'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1742193801943100)
,p_db_column_name=>'SHIPMENT_NUM'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Shipment Num'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1742300942943101)
,p_db_column_name=>'RECEIPT_KEY'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Receipt Key'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1742309897943102)
,p_db_column_name=>'DEL'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Remove'
,p_column_link=>'javascript:void(0);'
,p_column_linktext=>'   <i class="fa fa-trash" aria-hidden="true"></i>'
,p_column_link_attr=>'onclick="delete_rec(this, #LINE_ID#)" title="Click to remove this line"'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P2_STATUS in (''Draft'' , ''Returned'' , ''Withdraw'')'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(1758964791949508)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1017939'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:FULL_CODE_COMBINATION:AMOUNT:NOTES:UPDATED_BY:UPDATED_ON:'
,p_sum_columns_on_break=>'AMOUNT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(574925029419916)
,p_button_sequence=>270
,p_button_plug_id=>wwv_flow_api.id(86282954505443)
,p_button_name=>'Save_and_Select_Receiving_Numbers_new'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Save And Select Receiving Numbers'
,p_button_position=>'BODY'
,p_button_condition=>'P2_PAYMENT_REQUEST_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_icon_css_classes=>'fa-save'
,p_grid_new_row=>'N'
,p_grid_column=>4
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1006071401187499)
,p_button_sequence=>280
,p_button_plug_id=>wwv_flow_api.id(86282954505443)
,p_button_name=>'Save_and_Select_Receiving_Numbers_update'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--padRight:t-Button--padTop'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Save And Select Receiving Numbers u'
,p_button_position=>'BODY'
,p_button_condition=>':P2_PAYMENT_REQUEST_ID is not null and :P2_STATUS = ''Draft'''
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-save'
,p_grid_new_row=>'N'
,p_grid_column=>4
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(119333227505461)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(85623998505346)
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
 p_id=>wwv_flow_api.id(1076614980908432)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(1074782040908413)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--noUI:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Add Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:4:P4_PAYMENT_REQUEST_ID,P4_PAGE_FROM:&P2_PAYMENT_REQUEST_ID.,2'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(120135949505462)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(85623998505346)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--large'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition=>':P2_STATUS  =''Draft'' and :P2_PAYMENT_REQUEST_ID  is not null'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(120535180505462)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(85623998505346)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>':P2_APPROVAL_STATUS  in (''Draft'' , ''Withdraw'' ,''Returned'') and :P2_PAYMENT_REQUEST_ID is not null'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(120981708505462)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(85623998505346)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save & Continue'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P2_PAYMENT_REQUEST_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1277136478266386)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(85623998505346)
,p_button_name=>'Submit'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Submit'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count     number;',
'l_result    boolean;',
'begin',
'',
'',
'if :P2_STATUS in (''Draft'',''Returned'') and :P2_PAYMENT_REQUEST_ID is not null',
'-- and :P2_END_USER_PERSON_ID is not null',
'',
'',
'    then     ',
'        l_result := true;',
'     else',
'       l_result := false;',
'    End if;',
'    ',
'    return l_result;',
'',
'End;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_icon_css_classes=>'fa-send-o'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1281804933266432)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(85623998505346)
,p_button_name=>'Withdraw'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Withdraw'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(:P2_PAYMENT_REQUEST_ID is not null and :P2_STATUS = ''In-Progress'' ',
'And (:P2_REQUESTOR_PERSON_ID = :PERSON_ID or :P2_CREATED_BY = :PERSON_ID))'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-remove'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1281154509266426)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_api.id(85623998505346)
,p_button_name=>'Rollback'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Rollback'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-repeat'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(1005910493187498)
,p_branch_name=>'Go to 3- select PO lines New'
,p_branch_action=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:3:P3_PAYMENT_REQUEST_ID,P3_CURRENCY,P3_VENDOR_NUMBER,P3_VENDOR_SITE_CODE:&P2_PAYMENT_REQUEST_ID.,&P2_CURRENCY_CODE.,&P2_VENDOR_NUMBER.,&P2_VENDOR_SITE_CODE.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(574925029419916)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(1073678947908402)
,p_branch_name=>'stay in 2'
,p_branch_action=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.::P2_PAYMENT_REQUEST_ID:&P2_PAYMENT_REQUEST_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
,p_branch_condition_type=>'REQUEST_IN_CONDITION'
,p_branch_condition=>'remove_line, CREATE'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(1006155890187500)
,p_branch_name=>'Go to 3- select PO lines update'
,p_branch_action=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:3:P3_PAYMENT_REQUEST_ID,P3_VENDOR_NUMBER,P3_VENDOR_SITE_CODE,P3_CURRENCY:&P2_PAYMENT_REQUEST_ID.,&P2_VENDOR_NUMBER.,&P2_VENDOR_SITE_CODE.,&P2_CURRENCY_CODE.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(1006071401187499)
,p_branch_sequence=>30
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(1278530836266400)
,p_branch_name=>'Go To Declaration Page'
,p_branch_action=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:5:P5_APPROVAL_TYPE,P5_PAYMENT_REQUEST_ID:41,&P2_PAYMENT_REQUEST_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(1277136478266386)
,p_branch_sequence=>40
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(121252357505463)
,p_branch_name=>'Go To Page 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>50
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(426188600308910)
,p_name=>'P2_PAGE_FROM'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(85623998505346)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86525208505443)
,p_name=>'P2_PAYMENT_REQUEST_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(86923584505446)
,p_name=>'P2_REQUEST_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''APPR'' || ''/'' || :P2_Year || ''/'' || :P2_SEQ_COUNT',
'from dual;'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Request Number'
,p_source=>'REQUEST_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
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
 p_id=>wwv_flow_api.id(87395584505446)
,p_name=>'P2_REQUEST_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(87763847505446)
,p_name=>'P2_VENDOR_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
,p_attribute_10=>'VENDOR_SITE_CODE:P2_VENDOR_SITE_CODE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(88109667505446)
,p_name=>'P2_VENDOR_SITE_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(88577071505447)
,p_name=>'P2_OU_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_default=>'Tourism and Culture Authority OU'
,p_source=>'OU_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(88973545505447)
,p_name=>'P2_VENDOR_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
,p_source=>'VENDOR_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89392236505447)
,p_name=>'P2_INVOICE_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(89773797505447)
,p_name=>'P2_INVOICE_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(90200575505447)
,p_name=>'P2_INVOICE_DESCRIPTION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(90520576505448)
,p_name=>'P2_CURRENCY_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(90974339505448)
,p_name=>'P2_INVOICE_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(91339022505448)
,p_name=>'P2_PO_AVAILABLE_YN'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(91769211505448)
,p_name=>'P2_MULTIPLE_PO_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(92122040505448)
,p_name=>'P2_ADVANCE_PAYMENT_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>320
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(92514063505449)
,p_name=>'P2_BANK_GURANTEE_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>330
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(92932219505449)
,p_name=>'P2_NOTES'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>340
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(93354344505449)
,p_name=>'P2_VOUCHER_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>430
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(93792607505449)
,p_name=>'P2_PV_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>440
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(94142964505449)
,p_name=>'P2_PAYMENT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>450
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(94549311505450)
,p_name=>'P2_PAYMENT_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>460
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(94962997505450)
,p_name=>'P2_CLEAR_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>470
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(95398691505450)
,p_name=>'P2_CLEAR_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>480
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(95726676505450)
,p_name=>'P2_ENTITY_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>490
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(96130720505450)
,p_name=>'P2_COST_CENTER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>500
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(96514231505451)
,p_name=>'P2_BUDGET_GROUP_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>510
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(96997255505451)
,p_name=>'P2_GL_ACCOUNT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>520
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(97310471505451)
,p_name=>'P2_ACTIVITY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>530
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(97710636505451)
,p_name=>'P2_FUTURE1'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>540
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(98198687505451)
,p_name=>'P2_FUTURE2'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>550
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(98603427505451)
,p_name=>'P2_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(98907650505452)
,p_name=>'P2_SUBMITTED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>350
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
,p_prompt=>'Submitted On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'SUBMITTED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P2_STATUS'
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
 p_id=>wwv_flow_api.id(99797835505452)
,p_name=>'P2_SUBMITTED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>360
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
,p_prompt=>'Submitted By'
,p_source=>'SUBMITTED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'Employee FULL NAME RETURN PERSON ID'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en , person_id',
'from employees_v',
''))
,p_display_when=>'P2_STATUS'
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
 p_id=>wwv_flow_api.id(100193519505452)
,p_name=>'P2_FINAL_APPROVED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>370
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
,p_prompt=>'Final Approved On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'FINAL_APPROVED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P2_STATUS'
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
 p_id=>wwv_flow_api.id(100958230505453)
,p_name=>'P2_FINAL_APPROVED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>380
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
,p_prompt=>'Final Approved By'
,p_source=>'FINAL_APPROVED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'Employee FULL NAME RETURN PERSON ID'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en , person_id',
'from employees_v',
''))
,p_display_when=>'P2_STATUS'
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
 p_id=>wwv_flow_api.id(101314900505453)
,p_name=>'P2_REJECT_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>390
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
,p_prompt=>'Reject By'
,p_source=>'REJECT_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'Employee FULL NAME RETURN PERSON ID'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en , person_id',
'from employees_v',
''))
,p_display_when=>'P2_STATUS'
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
 p_id=>wwv_flow_api.id(101772112505453)
,p_name=>'P2_REJECT_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>400
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
,p_prompt=>'Rejected On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'REJECT_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P2_STATUS'
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
 p_id=>wwv_flow_api.id(102518341505453)
,p_name=>'P2_REJECT_REASON'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>410
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
,p_prompt=>'Reject Reason'
,p_source=>'REJECT_REASON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>1000
,p_cHeight=>2
,p_display_when=>'P2_STATUS'
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
 p_id=>wwv_flow_api.id(102996373505454)
,p_name=>'P2_CREATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>390
,p_item_plug_id=>wwv_flow_api.id(426080141308909)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(103399910505454)
,p_name=>'P2_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>400
,p_item_plug_id=>wwv_flow_api.id(426080141308909)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(104134459505454)
,p_name=>'P2_UPDATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>410
,p_item_plug_id=>wwv_flow_api.id(426080141308909)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(104557523505454)
,p_name=>'P2_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>420
,p_item_plug_id=>wwv_flow_api.id(426080141308909)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(105384441505455)
,p_name=>'P2_REQUESTOR_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(105728865505455)
,p_name=>'P2_PRIORITY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(1073715219908403)
,p_name=>'P2_TOTAL_LINE_AMUNT'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_prompt=>'Line Amount'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(nvl(sum(amount),0), ''99,999,999,999.99''))',
'from payment_request_lines',
'where payment_request_id = :P2_PAYMENT_REQUEST_ID'))
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
 p_id=>wwv_flow_api.id(1073818763908404)
,p_name=>'P2_VAT_APPLIED_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(1073984631908405)
,p_name=>'P2_AMOUNT_STATUS'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_line_total    number;',
'l_return           varchar2(512);',
'begin',
'',
'select sum(amount) * decode(:P2_VAT_APPLIED_YN , ''Y'', 1.05, 1)',
'into l_line_total',
'from payment_request_lines',
'where payment_request_id = :P2_payment_request_id;',
'',
'if l_line_total  = REPLACE(:P2_INVOICE_AMOUNT,'','','''')',
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
'select sum(amount) * decode(:P2_VAT_APPLIED_YN , ''Y'', 1.05, 1)',
'into l_line_total',
'from payment_request_lines',
'where payment_request_id = :P2_payment_request_id;',
'',
'if l_line_total  = REPLACE(:P2_INVOICE_AMOUNT,'','','''')',
'    Then ',
'    l_return := ''fa fa-check-circle'';',
'    else',
'    l_return := ''<span aria-hidden="true" class="fa fa-times fam-check fam-is-danger"></span>'';',
'End if;',
'',
'end;'))
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1074091091908406)
,p_name=>'P2_BANK_ACCOUNT_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(1074180516908407)
,p_name=>'P2_BANK_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(1074231982908408)
,p_name=>'P2_BANK_ACCOUNT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
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
 p_id=>wwv_flow_api.id(1074333015908409)
,p_name=>'P2_IBAN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
,p_prompt=>'IBAN'
,p_source=>'IBAN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'BANK ACCOUNTS - VENDOR'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select   IBAN  , BANK_ACCOUNT, BANK_NAME, BANK_ACCOUNT_NAME',
'from vendors_bank_accounts',
'where VENDOR_NUMBER =  :P2_VENDOR_NUMBER',
'and VENDOR_SITE_CODE = :P2_VENDOR_SITE_CODE',
'and ACC_END_DATED is null'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P2_VENDOR_NUMBER'
,p_ajax_items_to_submit=>'P2_VENDOR_NUMBER,P2_VENDOR_SITE_CODE'
,p_ajax_optimize_refresh=>'Y'
,p_cSize=>30
,p_cMaxlength=>50
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_10=>'BANK_ACCOUNT_NAME:P2_BANK_ACCOUNT_NAME,BANK_NAME:P2_BANK_NAME,BANK_ACCOUNT:P2_BANK_ACCOUNT'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1742860070943107)
,p_name=>'P2_NET_LINE_AMOUNT'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_prompt=>'Total Lines With VAT'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select decode(:P2_VAT_APPLIED_YN, ''Y'' ,',
'              trim(to_char(nvl(sum(amount * 1.05),0), ''99,999,999,999.99'')),',
'              trim(to_char(nvl(sum(amount ),0), ''99,999,999,999.99''))',
'             ) v',
'from payment_request_lines',
'where payment_request_id = :P2_PAYMENT_REQUEST_ID'))
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
 p_id=>wwv_flow_api.id(1743031004943109)
,p_name=>'P2_REQUESTOR_COST_CENTER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>420
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select cost_center_code  ',
'from employees_v ',
'where person_id = :PERSON_ID;'))
,p_item_default_type=>'SQL_QUERY'
,p_source=>'REQUESTOR_COST_CENTER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1743131709943110)
,p_name=>'P2_YEAR'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_default=>'select extract(Year from sysdate) from dual;'
,p_item_default_type=>'SQL_QUERY'
,p_source=>'YEAR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1743572571943114)
,p_name=>'P2_SEQ_COUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(max(seq_count),0) + 1',
'from payment_requests_all',
'where year = EXTRACT(YEAR FROM sysdate);'))
,p_item_default_type=>'SQL_QUERY'
,p_source=>'SEQ_COUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1744712821943126)
,p_name=>'P2_INVOICE_NUMBER_EXIST'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2958440943574285)
,p_name=>'P2_COMPLETION_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(86282954505443)
,p_item_source_plug_id=>wwv_flow_api.id(86282954505443)
,p_prompt=>'Completion Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'COMPLETION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(99494855505452)
,p_validation_name=>'P2_SUBMITTED_ON must be timestamp'
,p_validation_sequence=>310
,p_validation=>'P2_SUBMITTED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(98907650505452)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(100694875505453)
,p_validation_name=>'P2_FINAL_APPROVED_ON must be timestamp'
,p_validation_sequence=>330
,p_validation=>'P2_FINAL_APPROVED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(100193519505452)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(102209057505453)
,p_validation_name=>'P2_REJECT_ON must be timestamp'
,p_validation_sequence=>360
,p_validation=>'P2_REJECT_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(101772112505453)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(103879954505454)
,p_validation_name=>'P2_CREATED_ON must be timestamp'
,p_validation_sequence=>390
,p_validation=>'P2_CREATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(103399910505454)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(105093192505454)
,p_validation_name=>'P2_UPDATED_ON must be timestamp'
,p_validation_sequence=>410
,p_validation=>'P2_UPDATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(104557523505454)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(425984938308908)
,p_name=>'Bank Guarantee Display Control DA'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P2_ADVANCE_PAYMENT_YN'
,p_condition_element=>'P2_ADVANCE_PAYMENT_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'N'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
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
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(425807179308907)
,p_event_id=>wwv_flow_api.id(425984938308908)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_BANK_GURANTEE_NUMBER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(425748037308906)
,p_event_id=>wwv_flow_api.id(425984938308908)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_BANK_GURANTEE_NUMBER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(425659989308905)
,p_name=>'Multiple PO Display Control DA '
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P2_PO_AVAILABLE_YN'
,p_condition_element=>'P2_PO_AVAILABLE_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(425542523308904)
,p_event_id=>wwv_flow_api.id(425659989308905)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(1006071401187499)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1742766970943106)
,p_event_id=>wwv_flow_api.id(425659989308905)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(1710439748397922)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(575012452419917)
,p_event_id=>wwv_flow_api.id(425659989308905)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(574925029419916)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1742695780943105)
,p_event_id=>wwv_flow_api.id(425659989308905)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(1008172404187520)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(575119453419918)
,p_event_id=>wwv_flow_api.id(425659989308905)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(574925029419916)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1742461149943103)
,p_event_id=>wwv_flow_api.id(425659989308905)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(1008172404187520)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1074650400908412)
,p_event_id=>wwv_flow_api.id(425659989308905)
,p_event_result=>'FALSE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(1006071401187499)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1742565318943104)
,p_event_id=>wwv_flow_api.id(425659989308905)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(1710439748397922)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(425441277308903)
,p_event_id=>wwv_flow_api.id(425659989308905)
,p_event_result=>'FALSE'
,p_action_sequence=>50
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_MULTIPLE_PO_YN'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1074501779908410)
,p_event_id=>wwv_flow_api.id(425659989308905)
,p_event_result=>'FALSE'
,p_action_sequence=>60
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'delete from payment_request_lines where payment_request_id = :P2_PAYMENT_REQUEST_ID and PO_AVAILABLE_YN = ''Y''; '
,p_attribute_02=>'P2_PAYMENT_REQUEST_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1074556598908411)
,p_event_id=>wwv_flow_api.id(425659989308905)
,p_event_result=>'FALSE'
,p_action_sequence=>70
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(1008295635187521)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1276831090266383)
,p_name=>'Refresh Documents report DA'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(1076614980908432)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1276966932266384)
,p_event_id=>wwv_flow_api.id(1276831090266383)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(1074828603908414)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1281226704266427)
,p_name=>'rollback DA'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(1281154509266426)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1281394502266428)
,p_event_id=>wwv_flow_api.id(1281226704266427)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Rollback, Are you Sure !!!!!'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1281420682266429)
,p_event_id=>wwv_flow_api.id(1281226704266427)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'delete from payment_request_approval_history where payment_request_id = :P2_PAYMENT_REQUEST_ID;',
'update payment_requests_all set status = ''Draft'' where payment_request_id = :P2_PAYMENT_REQUEST_ID;',
'delete from EMAIL_APPROVAL_RECORDS where request_id = :P2_PAYMENT_REQUEST_ID;'))
,p_attribute_02=>'P2_PAYMENT_REQUEST_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1281566585266430)
,p_event_id=>wwv_flow_api.id(1281226704266427)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Rollback, Success'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1281669901266431)
,p_event_id=>wwv_flow_api.id(1281226704266427)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1744179993943120)
,p_name=>'Invoice Number enabled when vendor selected'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P2_VENDOR_NUMBER'
,p_condition_element=>'P2_VENDOR_NUMBER'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1744214548943121)
,p_event_id=>wwv_flow_api.id(1744179993943120)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_INVOICE_NUMBER,P2_IBAN'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1744396542943122)
,p_event_id=>wwv_flow_api.id(1744179993943120)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_INVOICE_NUMBER,P2_IBAN'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1744522308943124)
,p_name=>'set invoice_number-exist'
,p_event_sequence=>60
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P2_INVOICE_NUMBER'
,p_condition_element=>'P2_INVOICE_NUMBER'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1744656516943125)
,p_event_id=>wwv_flow_api.id(1744522308943124)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_INVOICE_NUMBER_EXIST'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(count(*),0)',
'from ap_invoices_all',
'where VENDOR_NUMBER = :P2_VENDOR_NUMBER',
'and VENDOR_SITE_CODE = :P2_VENDOR_SITE_CODE',
'and INVOICE_NUM = :P2_INVOICE_NUMBER',
''))
,p_attribute_07=>'P2_VENDOR_NUMBER,P2_VENDOR_SITE_CODE,P2_INVOICE_NUMBER'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1744847044943127)
,p_name=>'error if value 1'
,p_event_sequence=>70
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P2_INVOICE_NUMBER_EXIST'
,p_condition_element=>'P2_INVOICE_NUMBER_EXIST'
,p_triggering_condition_type=>'GREATER_THAN'
,p_triggering_expression=>'0'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1744961788943128)
,p_event_id=>wwv_flow_api.id(1744847044943127)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'This invoice already registered.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1745075909943129)
,p_event_id=>wwv_flow_api.id(1744847044943127)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_INVOICE_NUMBER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1745185716943130)
,p_event_id=>wwv_flow_api.id(1744847044943127)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_INVOICE_NUMBER'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(122123490505463)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(86282954505443)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Payment Request Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(121781681505463)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(86282954505443)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Payment Request Details'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1073539600908401)
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
