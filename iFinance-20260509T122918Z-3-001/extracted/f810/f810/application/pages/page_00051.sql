prompt --application/pages/page_00051
begin
--   Manifest
--     PAGE: 00051
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>51
,p_user_interface_id=>wwv_flow_api.id(12983317716762193)
,p_name=>'Duty Travel View'
,p_alias=>'DUTY-TRAVEL-VIEW'
,p_step_title=>'Duty Travel View'
,p_allow_duplicate_submissions=>'N'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_deep_linking=>'Y'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231102222318'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(199839200145443263)
,p_plug_name=>'Payroll Details'
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT person_id  ',
'FROM dct_data_access_assignment ',
'where entity_type_id = ''ROLE'' ',
'and entity_id = 96 ',
'and status = ''A'' ',
'and sysdate BETWEEN start_date ',
'and nvl(end_date , sysdate + 10)',
'and person_id = :PERSON_ID;'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(199839309020443264)
,p_plug_name=>'Payroll report'
,p_parent_plug_id=>wwv_flow_api.id(199839200145443263)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12896834679762110)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select id,',
'    request_id,',
'    ou_name,',
'    invoice_type,',
'    supplier_name,',
'    site_name,',
'    invoice_date,',
'    received_date,',
'    gl_date,',
'    invoice_num,',
'    currency,',
'    amount,',
'    payment_method,',
'    invoice_description,',
'    bank_account_num,',
'    inv_context,',
'    emp_name,',
'    emp_num,',
'    bank_name,',
'    bank_acc_num,',
'    pay_group,',
'    payment_term,',
'    gl_account,',
'    line_desc,',
'    project,',
'    task,',
'    expenditure_type,',
'    project_org,',
'    status,',
'    PV_NUMBER,',
'    BATCH_NUMBER',
'from mission_invoices    ',
'where REQUEST_ID = :P51_REQUEST_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P51_REQUEST_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Payroll report'
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
 p_id=>wwv_flow_api.id(199839391512443265)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:28:&SESSION.::&DEBUG.::P28_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>310450268002450242
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88990913978863289)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'AJ'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88979716403863282)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88980114349863283)
,p_db_column_name=>'OU_NAME'
,p_display_order=>30
,p_column_identifier=>'I'
,p_column_label=>'Ou Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88980471574863283)
,p_db_column_name=>'INVOICE_TYPE'
,p_display_order=>40
,p_column_identifier=>'J'
,p_column_label=>'Invoice Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88980917783863283)
,p_db_column_name=>'SUPPLIER_NAME'
,p_display_order=>50
,p_column_identifier=>'K'
,p_column_label=>'Supplier Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88981229922863283)
,p_db_column_name=>'SITE_NAME'
,p_display_order=>60
,p_column_identifier=>'L'
,p_column_label=>'Site Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88981688497863284)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>70
,p_column_identifier=>'M'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88982087333863284)
,p_db_column_name=>'RECEIVED_DATE'
,p_display_order=>80
,p_column_identifier=>'N'
,p_column_label=>'Received Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88982518865863284)
,p_db_column_name=>'GL_DATE'
,p_display_order=>90
,p_column_identifier=>'O'
,p_column_label=>'Gl Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88982870152863284)
,p_db_column_name=>'INVOICE_NUM'
,p_display_order=>100
,p_column_identifier=>'P'
,p_column_label=>'Invoice Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88983298353863285)
,p_db_column_name=>'CURRENCY'
,p_display_order=>110
,p_column_identifier=>'Q'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88983636192863285)
,p_db_column_name=>'AMOUNT'
,p_display_order=>120
,p_column_identifier=>'R'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88984057786863285)
,p_db_column_name=>'PAYMENT_METHOD'
,p_display_order=>130
,p_column_identifier=>'S'
,p_column_label=>'Payment Method'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88984482239863285)
,p_db_column_name=>'INVOICE_DESCRIPTION'
,p_display_order=>140
,p_column_identifier=>'T'
,p_column_label=>'Invoice Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88984829803863285)
,p_db_column_name=>'BANK_ACCOUNT_NUM'
,p_display_order=>150
,p_column_identifier=>'U'
,p_column_label=>'Bank Account Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88985282483863286)
,p_db_column_name=>'INV_CONTEXT'
,p_display_order=>160
,p_column_identifier=>'V'
,p_column_label=>'Inv Context'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88985643430863286)
,p_db_column_name=>'EMP_NAME'
,p_display_order=>170
,p_column_identifier=>'W'
,p_column_label=>'Employee Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88986079221863286)
,p_db_column_name=>'EMP_NUM'
,p_display_order=>180
,p_column_identifier=>'X'
,p_column_label=>'Employee Number'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88986470473863286)
,p_db_column_name=>'BANK_NAME'
,p_display_order=>190
,p_column_identifier=>'Y'
,p_column_label=>'Bank Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88986828023863286)
,p_db_column_name=>'BANK_ACC_NUM'
,p_display_order=>200
,p_column_identifier=>'Z'
,p_column_label=>'Bank Acc Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88987225638863287)
,p_db_column_name=>'PAY_GROUP'
,p_display_order=>210
,p_column_identifier=>'AA'
,p_column_label=>'Pay Group'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88987631335863287)
,p_db_column_name=>'PAYMENT_TERM'
,p_display_order=>220
,p_column_identifier=>'AB'
,p_column_label=>'Payment Term'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88988094071863287)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>230
,p_column_identifier=>'AC'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88988456027863287)
,p_db_column_name=>'LINE_DESC'
,p_display_order=>240
,p_column_identifier=>'AD'
,p_column_label=>'Line Desc'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88988870700863287)
,p_db_column_name=>'PROJECT'
,p_display_order=>250
,p_column_identifier=>'AE'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88989283745863288)
,p_db_column_name=>'TASK'
,p_display_order=>260
,p_column_identifier=>'AF'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88989635762863288)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>270
,p_column_identifier=>'AG'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88990095728863288)
,p_db_column_name=>'PROJECT_ORG'
,p_display_order=>280
,p_column_identifier=>'AH'
,p_column_label=>'Project Org'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88990504589863288)
,p_db_column_name=>'STATUS'
,p_display_order=>290
,p_column_identifier=>'AI'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88991243765863289)
,p_db_column_name=>'PV_NUMBER'
,p_display_order=>300
,p_column_identifier=>'AK'
,p_column_label=>'PV Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88991650665863289)
,p_db_column_name=>'BATCH_NUMBER'
,p_display_order=>310
,p_column_identifier=>'AL'
,p_column_label=>'Batch Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(199893083992661005)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1996029'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'INVOICE_NUM:SUPPLIER_NAME:INVOICE_DATE:AMOUNT:BANK_ACCOUNT_NUM:EMP_NAME:EMP_NUM:BANK_NAME:PV_NUMBER:STATUS:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(88992481954863292)
,p_report_id=>wwv_flow_api.id(199893083992661005)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Pending'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Pending''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(88992860401863292)
,p_report_id=>wwv_flow_api.id(199893083992661005)
,p_name=>'Running'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Running'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Running''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#D0F1CC'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(88993297820863292)
,p_report_id=>wwv_flow_api.id(199893083992661005)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Success'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Success''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#3BAA2C'
,p_row_font_color=>'#FFFFFF'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(309640753997923837)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12908155528762118)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(12844716791762062)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(12962203224762162)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(309641362176923837)
,p_plug_name=>'Main Details'
,p_icon_css_classes=>'fa-list-alt'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(309641769955923836)
,p_plug_name=>'Summary'
,p_parent_plug_id=>wwv_flow_api.id(309641362176923837)
,p_icon_css_classes=>'fa-file-o'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(309690539385734439)
,p_plug_name=>'Header Details'
,p_parent_plug_id=>wwv_flow_api.id(309641362176923837)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>7
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(204583980451280562)
,p_plug_name=>'Payment Details'
,p_parent_plug_id=>wwv_flow_api.id(309690539385734439)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12881785965762100)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P51_CAR_REQUEST_YN != ''C'' or :P51_CAR_REQUEST_YN  is null'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(309725893057607942)
,p_plug_name=>'Audit'
,p_parent_plug_id=>wwv_flow_api.id(309690539385734439)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12881785965762100)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(309642159868923836)
,p_plug_name=>'Budget Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1',
'  from MISSION_DISTRIBUTIONS',
'  where REQUEST_ID = :P51_REQUEST_ID'))
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(309728648118607970)
,p_plug_name=>'Budget Report'
,p_parent_plug_id=>wwv_flow_api.id(309642159868923836)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12896834679762110)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       REQUEST_ID,',
'       ENTITY_CODE,',
'       COST_CENTER,',
'       BUDGET_GROUP_CODE,',
'       GL_ACCOUNT,',
'       ACTIVITY,',
'       FUTURE1,',
'       FUTURE2,',
'       PROJECT_NUMBER,',
'       TASK_NUMBER,',
'       EXPENDITURE_TYPE,',
'       AMOUNT,',
'       COMMENTS,',
'       ACTION_BY,',
'       CREATED_ON,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       (ENTITY_CODE',
'       ||''.'' ||',
'       COST_CENTER',
'       ||''.'' ||',
'       BUDGET_GROUP_CODE',
'       ||''.'' ||',
'       GL_ACCOUNT',
'       ||''.'' ||',
'       ACTIVITY',
'       ||''.'' ||',
'       FUTURE1',
'       ||''.'' ||',
'       FUTURE2) gl_combination',
'  from MISSION_DISTRIBUTIONS',
'  where REQUEST_ID = :P51_REQUEST_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P51_REQUEST_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Budget Report'
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
 p_id=>wwv_flow_api.id(309728757705607971)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>420339634195614948
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89022643473863324)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89023061222863325)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89023503989863325)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89023900486863325)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89024231323863325)
,p_db_column_name=>'BUDGET_GROUP_CODE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Budget Group Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89024676001863325)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89025113138863326)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89025505274863326)
,p_db_column_name=>'FUTURE1'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89025828205863326)
,p_db_column_name=>'FUTURE2'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89026256401863326)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89026698868863326)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89027038965863327)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89027458506863327)
,p_db_column_name=>'AMOUNT'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89027882588863327)
,p_db_column_name=>'COMMENTS'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89028269869863327)
,p_db_column_name=>'ACTION_BY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Action By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89028625462863328)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89029033174863328)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89029471944863328)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89029839922863328)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89022237195863324)
,p_db_column_name=>'GL_COMBINATION'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'GL Combination'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(309922165908339312)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1996411'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:GL_COMBINATION:AMOUNT:COMMENTS:UPDATED_BY:UPDATED_ON:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(309642527763923836)
,p_plug_name=>'Destinations'
,p_icon_css_classes=>'fa-space-shuttle'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P51_OVERSEAS_YN'
,p_plug_display_when_cond2=>'Y'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(309726528013607949)
,p_plug_name=>'Legs Report'
,p_parent_plug_id=>wwv_flow_api.id(309642527763923836)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12896834679762110)
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>8
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       REQUEST_ID,',
'       SEQ,',
'       COUNTRY,',
'       CITY,',
'       NO_OF_DAYS,',
'       START_DATE,',
'       END_DATE,',
'       SELF_HOSPITALITY_YN,',
'       TICKET_REQUEST,',
'       NOTES,',
'       CREATED_BY_PERSON_ID,',
'       UPDATED_BY_PERSON_ID,',
'       CREATION_DATE,',
'       UPDATED_DATE',
'  from MISSION_LEGS',
'  where REQUEST_ID = :P51_REQUEST_ID',
'  order by SEQ;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P51_REQUEST_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Legs Report'
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
 p_id=>wwv_flow_api.id(309726623024607950)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.::P14_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P13_REQUEST_STATUS in (''Draft'' , ''Stop'' , ''Withdraw'' , ''Return'')'
,p_owner=>'TCA9051'
,p_internal_uid=>420337499514614927
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89031668468863330)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89032042613863330)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89032488176863331)
,p_db_column_name=>'SEQ'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89032840665863331)
,p_db_column_name=>'COUNTRY'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Country'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(110195700317850373)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89033299154863331)
,p_db_column_name=>'CITY'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'City'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89033721251863331)
,p_db_column_name=>'NO_OF_DAYS'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Days'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89034028779863331)
,p_db_column_name=>'START_DATE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89034516238863332)
,p_db_column_name=>'END_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89034907653863332)
,p_db_column_name=>'SELF_HOSPITALITY_YN'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Self Hospitality ?'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89035304776863332)
,p_db_column_name=>'TICKET_REQUEST'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Ticket Request'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89035639435863332)
,p_db_column_name=>'NOTES'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89036056387863332)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89036461992863333)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89036835340863333)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89037283108863333)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(309830108951998873)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1996485'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SEQ:COUNTRY:CITY:START_DATE:END_DATE:NOTES:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(309881091074472841)
,p_plug_name=>'Documents'
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(309881166955472842)
,p_plug_name=>'Documents report'
,p_parent_plug_id=>wwv_flow_api.id(309881091074472841)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12896834679762110)
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
'       CREATED_BY_PERSON_ID,',
'       UPDATED,',
'       UPDATED_BY_PERSON_ID,',
'       sys.dbms_lob.getlength(file_blob) as file_size,',
'    sys.dbms_lob.getlength(file_blob) as download',
'  from mission_documents',
'  where REQUEST_ID = :P51_REQUEST_ID',
'  order by UPDATED desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P51_REQUEST_ID'
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
 p_id=>wwv_flow_api.id(309881238963472843)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No attachments available. '
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>420492115453479820
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89039102936863335)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89039500626863335)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89039916722863335)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89040261060863335)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'File Name'
,p_column_link=>'f?p=&APP_ID.:15:&SESSION.::&DEBUG.::P15_ID,P15_PAGE_FROM,P15_STATUS:#ID#,13,&P13_REQUEST_STATUS.'
,p_column_linktext=>'#FILENAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89040693613863336)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89041034364863336)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89041441026863336)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89041839294863336)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89042248917863337)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89042676801863337)
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
 p_id=>wwv_flow_api.id(89043057429863337)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89043474701863337)
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
 p_id=>wwv_flow_api.id(89043868033863337)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89044288638863338)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89044649553863338)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:MISSION_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(309922712813339078)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1996559'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:CREATED:UPDATED_BY_PERSON_ID:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(309883173661472862)
,p_plug_name=>'Approval History'
,p_icon_css_classes=>'fa-users'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P51_REQUEST_STATUS != ''Draft'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_plug_comment=>'or :person_id = 680461'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(309883287468472863)
,p_plug_name=>'Approval History Report'
,p_parent_plug_id=>wwv_flow_api.id(309883173661472862)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12896834679762110)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    h.id,',
'    h.request_id,',
'    h.step_no,',
'    h.person_id,',
'    e.full_name_en || '' ('' || upper(e.user_name) || '')'' Name,',
'    h.role_id,',
'    h.role_desc,',
'    h.action_required,',
'    h.recevied_date,',
'    h.status,',
'    h.action_date,',
'    h.comments,',
' --   h.approval_type,',
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
'    mission_approval_history h, dct_employees_list2  e',
'where h.person_id = e.person_id (+)',
'and h.request_id = :P51_REQUEST_ID',
'and h.status != ''Bateen''',
'order by h.STEP_NO ',
', h.ID',
';'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P51_REQUEST_ID'
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
 p_id=>wwv_flow_api.id(309883381028472864)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>420494257518479841
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89046427411863339)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89046884488863340)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89047268928863340)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89047708836863340)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89048051506863340)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Role'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109816436157935965)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89048454426863340)
,p_db_column_name=>'ROLE_DESC'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Role Desc'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89048841323863341)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89049312915863341)
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
 p_id=>wwv_flow_api.id(89049710777863341)
,p_db_column_name=>'STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89050033431863341)
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
 p_id=>wwv_flow_api.id(89050499253863341)
,p_db_column_name=>'COMMENTS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89050860039863342)
,p_db_column_name=>'STATUS_CLASS'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Status Class'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89051263404863342)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89051671944863342)
,p_db_column_name=>'PHOTO'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89046057384863339)
,p_db_column_name=>'NAME'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(309937188075165473)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1996629'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:PHOTO:NAME:ROLE_ID:ACTION_REQUIRED:RECEVIED_DATE:STATUS:ACTION_DATE:COMMENTS:'
,p_sort_column_1=>'STEP_NO'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(89052450641863343)
,p_report_id=>wwv_flow_api.id(309937188075165473)
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
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(88979001928863274)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(199839200145443263)
,p_button_name=>'Refresh'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--link:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Refresh'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(89030926567863329)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(309642527763923836)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI'
,p_button_template_id=>wwv_flow_api.id(12960115165762160)
,p_button_image_alt=>'New'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.:14:P14_REQUEST_ID:&P51_REQUEST_ID.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(89038368472863334)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(309881091074472841)
,p_button_name=>'New_document'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI'
,p_button_template_id=>wwv_flow_api.id(12960115165762160)
,p_button_image_alt=>'New Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:15:&SESSION.::&DEBUG.::P15_REQUEST_ID,P15_PAGE_FROM:&P51_REQUEST_ID.,13'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(88996368048863296)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_api.id(309640753997923837)
,p_button_name=>'Print'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Print'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P51_REQUEST_STATUS != ''Draft'' and ',
'(:IS_COMPENSATION_BENIFIT_YN = ''Y'' or',
' :IS_PAYROLL_ADMIN =  ''Y'')'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-print'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(88996792395863296)
,p_button_sequence=>80
,p_button_plug_id=>wwv_flow_api.id(309640753997923837)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(89000297095863299)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(309641362176923837)
,p_button_name=>'edit_header'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--link'
,p_button_template_id=>wwv_flow_api.id(12960115165762160)
,p_button_image_alt=>'Edit Header'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.::P12_REQUEST_ID:&P51_REQUEST_ID.'
,p_button_condition=>':P51_REQUEST_STATUS in (''Draft'' , ''Stop'' , ''Withdraw'' , ''Return'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-pencil'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(89065913082863356)
,p_branch_name=>'Go to 23 Confirm Submission'
,p_branch_action=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.:23:P23_REQUEST_ID:&P51_REQUEST_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(89066643828863356)
,p_branch_name=>'Go to 18'
,p_branch_action=>'f?p=&APP_ID.:18:&SESSION.::&DEBUG.:18:P18_REQUEST_ID:&P51_REQUEST_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(89066289439863356)
,p_branch_name=>'Go to  &P13_PAGE_FROM.'
,p_branch_action=>'f?p=&APP_ID.:&P51_PAGE_FROM.:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>30
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(84399751892618548)
,p_name=>'P51_HASH_CODE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(309640753997923837)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(88997125934863296)
,p_name=>'P51_REQUEST_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(309640753997923837)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(88997604424863298)
,p_name=>'P51_YEAR'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(309640753997923837)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(88997998052863298)
,p_name=>'P51_SEQ'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(309640753997923837)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(88998417440863298)
,p_name=>'51_REQUEST_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(309640753997923837)
,p_source=>'P51_REQUEST_ID'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(88998741164863298)
,p_name=>'P51_PAGE_FROM'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(309640753997923837)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(88999143737863298)
,p_name=>'P51_APPROVAL_TYPE_ID'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(309640753997923837)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(88999591460863299)
,p_name=>'P51_REQUEST_TYPE_DISPLAY'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(309640753997923837)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89000965886863300)
,p_name=>'P51_REQUEST_STATUS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(309641769955923836)
,p_prompt=>'Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89001325377863300)
,p_name=>'P51_COMPLETE_STATUS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(309641769955923836)
,p_prompt=>'Confirmation Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P51_REQUEST_STATUS'
,p_display_when2=>'Approved'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89001796351863300)
,p_name=>'P51_GRADE_CODE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(309641769955923836)
,p_prompt=>'Grade'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89002221949863300)
,p_name=>'P51_GRADE_RATE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(309641769955923836)
,p_prompt=>'Grade Rate'
,p_post_element_text=>'&nbsp; &nbsp; <b>AED</b>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89002611693863300)
,p_name=>'P51_DAYS'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(309641769955923836)
,p_prompt=>'Mission Days'
,p_post_element_text=>'&nbsp; &nbsp; <b>Days</b>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89002999294863301)
,p_name=>'P51_ADDITIONAL_DAYS'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(309641769955923836)
,p_prompt=>'Travel Days'
,p_post_element_text=>'&nbsp; &nbsp; <b>Days</b>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89003414899863301)
,p_name=>'P51_TOTAL_DAYS'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(309641769955923836)
,p_prompt=>'Total Days'
,p_post_element_text=>'&nbsp; &nbsp; <b>Days</b>'
,p_source=>':P51_ADDITIONAL_DAYS + :P51_DAYS'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89003732053863301)
,p_name=>'P51_ELIGIBLE_PCT'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(309641769955923836)
,p_prompt=>'Eligible PCT'
,p_post_element_text=>'&nbsp; &nbsp; <b>%</b>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89004199352863301)
,p_name=>'P51_CAR_REQUEST_YN'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(309641769955923836)
,p_prompt=>'Car / Per Diem'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'PER DIEM / CARE LOV'
,p_lov=>'.'||wwv_flow_api.id(81269959753991779)||'.'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89004576187863301)
,p_name=>'P51_AMOUNT'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(309641769955923836)
,p_prompt=>'Eligible Amount '
,p_post_element_text=>'&nbsp; &nbsp; <b>AED</b>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89005011140863302)
,p_name=>'P51_SUBMITTED_ON'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(309641769955923836)
,p_prompt=>'Submitted On'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P51_SUBMITTED_ON'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89005364259863302)
,p_name=>'P51_SUBMITTED_BY'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(309641769955923836)
,p_prompt=>'Submitted By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name , user_details.get_emp_emirate(person_id) Emirate',
'FROM employees_v e',
'where CURRENT_FLAG = ''Y'''))
,p_display_when=>'P51_SUBMITTED_BY'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89005752411863303)
,p_name=>'P51_REJECTED_BY'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(309641769955923836)
,p_prompt=>'Rejected By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name , user_details.get_emp_emirate(person_id) Emirate',
'FROM employees_v e',
'where CURRENT_FLAG = ''Y'''))
,p_display_when=>'P51_REQUEST_STATUS'
,p_display_when2=>'Rejected'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89006132737863303)
,p_name=>'P51_FINAL_REJECT_ON'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(309641769955923836)
,p_prompt=>'Final Reject On'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P51_REQUEST_STATUS'
,p_display_when2=>'Rejected'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89006568423863303)
,p_name=>'P51_REJECT_REASON'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(309641769955923836)
,p_prompt=>'Reject Reason'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P51_REQUEST_STATUS'
,p_display_when2=>'Rejected'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89007250910863304)
,p_name=>'P51_REQUEST_NO'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(309690539385734439)
,p_prompt=>'Request No'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89007700792863304)
,p_name=>'P51_REQUEST_TYPE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(309690539385734439)
,p_prompt=>'Request Type'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'MISSION REQUEST TYPES'
,p_lov=>'.'||wwv_flow_api.id(110033950814469886)||'.'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89008103021863304)
,p_name=>'P51_REQUEST_FOR'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(309690539385734439)
,p_prompt=>'Request For'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
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
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89008432416863304)
,p_name=>'P51_REQUEST_DATE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(309690539385734439)
,p_prompt=>'Request Date'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89008921403863304)
,p_name=>'P51_START_DATE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(309690539385734439)
,p_prompt=>'Start Date'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89009307350863305)
,p_name=>'P51_END_DATE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(309690539385734439)
,p_prompt=>'End Date'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>':P51_CAR_REQUEST_YN != ''C'' or :P51_CAR_REQUEST_YN is null'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89009680419863305)
,p_name=>'P51_OVERSEAS_YN'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(309690539385734439)
,p_prompt=>'Overseas ?'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(109820486212935961)||'.'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_help_text=>unistr('<p><span style="color: #ff0000;"><strong>Yes: Mission outside UAE&nbsp;&nbsp;<span style="color: #0000ff;"> \0646\0639\0645 : \0625\0630\0627 \0643\0627\0646 \062C\0647\0629 \0627\0644\0633\0641\0631 \062E\0627\0631\062C \0627\0644\062F\0648\0644\0629</span></strong></span></p>')
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89010526350863307)
,p_name=>'P51_PRIORITY'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(309690539385734439)
,p_prompt=>'Priority'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'PRIORITY LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id',
'from dct_lookup_values',
'where lookup_id = (Select x.lookup_id',
'                    from dct_lookups x',
'                    where x.LOOKUP_CODE = ''PRIORITY'');'))
,p_begin_on_new_line=>'N'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89010957464863308)
,p_name=>'P51_EMIRATE'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(309690539385734439)
,p_prompt=>'Emirate'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMIRATES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    value,',
'    value_id',
'FROM',
'    dct_lookup_values',
'WHERE',
'        lookup_id = 35',
'    AND status = ''A''',
'    AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)',
'order by 1'))
,p_display_when=>'P51_OVERSEAS_YN'
,p_display_when2=>'N'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89011361963863308)
,p_name=>'P51_FULL_DAY_YN'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(309690539385734439)
,p_prompt=>'Full Day ?'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(109820486212935961)||'.'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89011812568863308)
,p_name=>'P51_TRAVEL_ABOVE_10HR_YN'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(309690539385734439)
,p_prompt=>'Travel Above 10hr ?'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(109820486212935961)||'.'
,p_display_when=>'P51_OVERSEAS_YN'
,p_display_when2=>'Y'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89012141943863308)
,p_name=>'P51_TICKET_REQUEST'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(309690539385734439)
,p_prompt=>'Ticket Request ?'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'TICKET REQUEST CHOICES'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    value,',
'    value_id',
'FROM',
'    dct_lookup_values',
'WHERE',
'        lookup_id = 36',
'    AND status = ''A''',
'    AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)',
'order by 1'))
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89012528715863309)
,p_name=>'P51_HOSPITALITY_YN'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(309690539385734439)
,p_prompt=>'Hospitality'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(109820486212935961)||'.'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_help_text=>'if Yes, Hospitality hosted from other organization'
,p_inline_help_text=>'if Yes, Hospitality hosted from other organization'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89013466433863309)
,p_name=>'P51_TRANSPORTATION'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(309690539385734439)
,p_prompt=>'Transportation'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89013840118863310)
,p_name=>'P51_JUSTIFICATION'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(309690539385734439)
,p_prompt=>'Justification'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89014313429863310)
,p_name=>'P51_PURPOSE_EU'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(309690539385734439)
,p_prompt=>'Purpose'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89014632079863310)
,p_name=>'P51_FINAL_APPROVE_ON'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(309690539385734439)
,p_prompt=>'Final Approve On'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P51_REQUEST_STATUS'
,p_display_when2=>'Approved'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89015070698863310)
,p_name=>'P51_CANCEL_ON'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(309690539385734439)
,p_prompt=>'Cancel on'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P51_REQUEST_STATUS'
,p_display_when2=>'Cancel'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89015478233863310)
,p_name=>'P51_CANCELLED_BY'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(309690539385734439)
,p_prompt=>'Cancel By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name , user_details.get_emp_emirate(person_id) Emirate',
'FROM employees_v e',
'where CURRENT_FLAG = ''Y'''))
,p_display_when=>'P51_REQUEST_STATUS'
,p_display_when2=>'Cancel'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89015872791863311)
,p_name=>'P51_CANCEL_REASON'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(309690539385734439)
,p_prompt=>'Reason'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P51_REQUEST_STATUS'
,p_display_when2=>'Cancel'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89016564937863311)
,p_name=>'P51_CREATED_BY_PERSON_ID'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(309725893057607942)
,p_prompt=>'Created By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name , user_details.get_emp_emirate(person_id) Emirate',
'FROM employees_v e',
'where CURRENT_FLAG = ''Y'''))
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89016981750863312)
,p_name=>'P51_CREATION_DATE'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_api.id(309725893057607942)
,p_prompt=>'Created on'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89017327248863312)
,p_name=>'P51_UPDATED_BY_PERSON_ID'
,p_item_sequence=>320
,p_item_plug_id=>wwv_flow_api.id(309725893057607942)
,p_prompt=>'Updated By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name , user_details.get_emp_emirate(person_id) Emirate',
'FROM employees_v e',
'where CURRENT_FLAG = ''Y'''))
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89017804459863316)
,p_name=>'P51_UPDATED_DATE'
,p_item_sequence=>330
,p_item_plug_id=>wwv_flow_api.id(309725893057607942)
,p_prompt=>'Update on'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89018453208863316)
,p_name=>'P51_EMPLOYEE_NUM'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(204583980451280562)
,p_prompt=>'Employee Number'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89018900610863317)
,p_name=>'P51_SUPPLIER_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(204583980451280562)
,p_prompt=>'Supplier Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89019260367863317)
,p_name=>'P51_SITE_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(204583980451280562)
,p_prompt=>'Supplier Site Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89019653677863317)
,p_name=>'P51_PAYMENT_METHOD'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(204583980451280562)
,p_prompt=>'Payment Method'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89020096084863322)
,p_name=>'P51_PAY_ALONE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(204583980451280562)
,p_prompt=>'Pay Alone?'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(109820486212935961)||'.'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89020438430863323)
,p_name=>'P51_INVOICE_TYPE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(204583980451280562)
,p_prompt=>'Invoice Type'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89020857456863323)
,p_name=>'P51_BANK_NAME'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(204583980451280562)
,p_prompt=>'Bank Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89021299755863323)
,p_name=>'P51_IBAN'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(204583980451280562)
,p_prompt=>'IBAN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(89059368170863352)
,p_name=>'Print DA'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(88996368048863296)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(89059884505863352)
,p_event_id=>wwv_flow_api.id(89059368170863352)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'javaScript:window.open(''f?p=&APP_ID.:0:&SESSION.:PRINT_REPORT=MISSION_QUERY'', ''_blank'');'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(89060292817863352)
,p_name=>'New'
,p_event_sequence=>40
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(309726528013607949)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(89060780686863353)
,p_event_id=>wwv_flow_api.id(89060292817863352)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(309726528013607949)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(89061149382863353)
,p_name=>'Full Day DA'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P51_FULL_DAY_YN'
,p_condition_element=>'P51_FULL_DAY_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
,p_display_when_type=>'NEVER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(89061672159863353)
,p_event_id=>wwv_flow_api.id(89061149382863353)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P51_HOSPITALITY_YN'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(89062129877863353)
,p_event_id=>wwv_flow_api.id(89061149382863353)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P51_HOSPITALITY_YN'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(89062600990863353)
,p_name=>'Refresh DA'
,p_event_sequence=>60
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(89030926567863329)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(89063031110863354)
,p_event_id=>wwv_flow_api.id(89062600990863353)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(309726528013607949)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(89064850633863354)
,p_name=>'RefreshDA'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(88979001928863274)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(89065342616863355)
,p_event_id=>wwv_flow_api.id(89064850633863354)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(199839309020443264)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(89063517517863354)
,p_name=>'Check Per Diem / Car '
,p_event_sequence=>80
,p_condition_element=>'P51_CAR_REQUEST_YN'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(89063969143863354)
,p_event_id=>wwv_flow_api.id(89063517517863354)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P51_CAR_REQUEST_YN'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(89064504787863354)
,p_event_id=>wwv_flow_api.id(89063517517863354)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P51_CAR_REQUEST_YN'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(89053212700863346)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialize Mission details'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    request_id,',
'    request_no,',
'    to_char(request_date,''DD-MON-YYYY'')                     request_date,',
'    user_details.get_full_name(request_for)                 request_for,',
'    MISSION_UTIL.get_grade(grade_code)                      grade_code,',
'    to_char(MISSION_UTIL.get_mission_rate(grade_code,overseas_yn),''99,999,999.99'')   grade_rate,',
'    overseas_yn,',
'    emirate,',
'    full_day_yn,',
'    travel_above_10hr_yn,',
'    ticket_request,',
'    hospitality_yn,',
'    transportation,',
'    to_char(start_date,''DD-MON-YYYY'')                       start_date,',
'    to_char(end_date,''DD-MON-YYYY'')                         end_date,',
'    request_status,',
'    complete_status,',
'    justification,',
'    year,',
'    purpose_eu,',
'    priority,',
'    to_char(submitted_on,''DD-MON-YYYY HH:MIPM'')             submitted_on,',
'    submitted_by,',
'    seq,',
'    to_char(final_approve_on,''DD-MON-YYYY HH:MIPM'')         final_approve_on,',
'    request_type,',
'    to_char(final_reject_on,''DD-MON-YYYY HH:MIPM'')          final_reject_on,',
'    rejected_by,',
'    reject_reason,',
'    to_char(cancel_on,''DD-MON-YYYY HH:MIPM'')                cancel_on,',
'    cancelled_by,',
'    cancel_reason,',
'    approval_type_id,',
'    created_by_person_id,',
'    updated_by_person_id,',
'    to_char(creation_date,''DD-MON-YYYY HH:MIPM'')            creation_date,',
'    to_char(updated_date,''DD-MON-YYYY HH:MIPM'')             updated_date,',
' --   to_char(amount , ''99,999,999,999.99'')                   amount,',
'    (end_date - start_date) + 1                             Mission_days,',
'    case when overseas_yn = ''Y'' and travel_above_10hr_yn = ''Y''',
'            Then 4',
'         when overseas_yn = ''Y'' and travel_above_10hr_yn = ''N''  ',
'            Then 2',
'         else',
'            0',
'    End                                                 additional_days,',
'    to_char(MISSION_UTIL.get_mission_amount(request_id) , ''99,999,999,999.99'')         mission_amount,',
'    MISSION_UTIL.get_Eligible_pct(overseas_yn, full_day_yn, hospitality_yn , REQUEST_ID)              eligible_pct,',
' ---',
'    SUPPLIER_NAME, ',
'    SITE_NAME,',
'    PAYMENT_METHOD,',
'    PAY_ALONE, ',
'    INVOICE_TYPE,',
'    MISSION_UTIL.get_mission_bank_name(request_id),',
'    MISSION_UTIL.get_mission_IBAN(request_id),',
'    user_details.get_emp_num(REQUEST_FOR),',
'    CAR_REQUEST_YN',
'into',
'    :P51_REQUEST_ID,',
'    :P51_REQUEST_NO,',
'    :P51_REQUEST_DATE,',
'    :P51_REQUEST_FOR,',
'    :P51_GRADE_CODE,',
'    :P51_GRADE_RATE,',
'    :P51_OVERSEAS_YN,',
'    :P51_EMIRATE,',
'    :P51_FULL_DAY_YN,',
'    :P51_TRAVEL_ABOVE_10HR_YN,',
'    :P51_TICKET_REQUEST,',
'    :P51_HOSPITALITY_YN,',
'    :P51_TRANSPORTATION,',
'    :P51_START_DATE,',
'    :P51_END_DATE,',
'    :P51_REQUEST_STATUS,',
'    :P51_COMPLETE_STATUS,',
'    :P51_JUSTIFICATION,',
'    :P51_YEAR,',
'    :P51_PURPOSE_EU,',
'    :P51_PRIORITY,',
'    :P51_SUBMITTED_ON,',
'    :P51_SUBMITTED_BY,',
'    :P51_SEQ,',
'    :P51_FINAL_APPROVE_ON,',
'    :P51_REQUEST_TYPE,',
'    :P51_FINAL_REJECT_ON,',
'    :P51_REJECTED_BY,',
'    :P51_REJECT_REASON,',
'    :P51_CANCEL_ON,',
'    :P51_CANCELLED_BY,',
'    :P51_CANCEL_REASON,',
'    :P51_APPROVAL_TYPE_ID,',
'    :P51_CREATED_BY_PERSON_ID,',
'    :P51_UPDATED_BY_PERSON_ID,',
'    :P51_CREATION_DATE,',
'    :P51_UPDATED_DATE,',
'--    :P51_AMOUNT,',
'    :P51_DAYS,',
'    :P51_ADDITIONAL_DAYS,',
'    :P51_AMOUNT,',
'    :P51_ELIGIBLE_PCT,',
'--',
'   :P51_SUPPLIER_NAME,',
'   :P51_SITE_NAME,',
'   :P51_PAYMENT_METHOD,',
'   :P51_PAY_ALONE,',
'   :P51_INVOICE_TYPE,',
'   :P51_BANK_NAME,',
'   :P51_IBAN,',
'   :P51_EMPLOYEE_NUM,',
'   :P51_CAR_REQUEST_YN',
'FROM    ',
'    mission_header',
'WHERE mission_header.hash_code = :P51_HASH_CODE;',
'',
''))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
