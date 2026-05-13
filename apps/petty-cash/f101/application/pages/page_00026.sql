prompt --application/pages/page_00026
begin
--   Manifest
--     PAGE: 00026
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>26
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Treasury Pending Tasks'
,p_alias=>'TREASURY-PENDING-TASKS'
,p_step_title=>'Treasury Pending Tasks'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* Scroll Results Only in Side Column */',
'.t-Body-side {',
'    display: flex;',
'    flex-direction: column;',
'    overflow: hidden;',
'}',
'.search-results {',
'    flex: 1;',
'    overflow: auto;',
'}',
'/* Format Search Region */',
'.search-region {',
'    border-bottom: 1px solid rgba(0,0,0,.1);',
'    flex-shrink: 0;',
'}',
'',
'.t-Region-header{',
'background-color:#0e6655;',
'    color:#FFFFFF;',
'}',
'.t-Region-title{',
'    color:#FFFFFF;',
'    font-weighfont-weight: bold;',
'}',
'',
'/* Set Header Panel */',
'.t-Header-branding {',
'    background-color: #0e6655;',
'}',
'',
'',
'/* Set Breadcrumb   */',
'.t-Body-title {',
'',
'    background-color: #EEE;',
'    color:#404040;',
'}',
'',
'/* Add Button - White */',
'.t-Region-header, .t-Region-header .t-Button--link, .t-Region-header .t-Button--noUI {',
'    color:  #FFF;',
'}',
'',
'/* New Plan Button */',
'.a-Button--hot, .t-Button--hot:not(.t-Button--simple), body .ui-button.ui-button--hot, body .ui-state-default.ui-priority-primary {',
'',
'    background-color: #0e6655;',
'    color:#fff;',
'}',
'',
'',
'/*  Table Row Selected */',
'.a-GV-table tr.is-selected .a-GV-cell {',
'    background-color: #CEF6CE;',
'}',
'',
'/* Audit Region */',
'#history    .t-Region-header {',
'     background-color: #f3f0ef;',
'    color:#000;',
'}',
''))
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200606084205'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(30581603832848512)
,p_plug_name=>'Processed By Treasury'
,p_region_name=>'inside-page'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8055912915175506)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    petty_cash_id,',
'    petty_cash_no,',
'    petty_cash_date,',
'    due_date,',
'    petty_cash_type,',
'    pc.employee_num,',
'    project_number,',
'    task,',
'    amount,',
'    purpose,',
'    closing_date,',
'    approval_status,',
'    status,',
'    reconciled_date,',
'    priority,',
'    creation_date,',
'    created_by,',
'    updated_by,',
'    updated_date,',
'    year,',
'    gl_account,',
'    justification,',
'    comment_to_approver,',
'    invoicing_yn,',
'    paid_yn,',
'    invoice_number,',
'    invoice_date,',
'    pv_number,',
'    gl_date,',
'    payment_number,',
'    payment_date',
'   , e.full_name_en employee_name',
'   , e.full_name_ar   employee_name_ar',
'FROM',
'    hrss_petty_cash pc , dct_employees_list2 e',
'where pc.employee_num = e.employee_num (+)',
'and approval_status = ''Approved''',
'and Paid_yn = nvl(:P26_PAID , paid_yn)',
'and invoicing_yn = nvl(:P26_INVOICED , invoicing_yn)',
'and petty_cash_type = nvl(:P26_TYPE , petty_Cash_type)',
'and extract(YEAR from payment_date ) = nvl(:P26_YEAR ,extract(YEAR from payment_date ) )',
'and extract(YEAR from invoice_date ) = nvl(:P26_YEAR ,extract(YEAR from invoice_date ) )'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P26_DISPLAY'
,p_plug_display_when_cond2=>'H'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Processed By Treasury'
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
 p_id=>wwv_flow_api.id(30581714168848513)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>30581714168848513
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30581878575848514)
,p_db_column_name=>'PETTY_CASH_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Petty Cash Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30581992181848515)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30582014903848516)
,p_db_column_name=>'PV_NUMBER'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Pv Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30582151818848517)
,p_db_column_name=>'GL_DATE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Gl Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30582279882848518)
,p_db_column_name=>'PAYMENT_NUMBER'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Payment Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30582397689848519)
,p_db_column_name=>'PAYMENT_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Payment Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30582458496848520)
,p_db_column_name=>'PETTY_CASH_NO'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Petty Cash#'
,p_column_link=>'f?p=&APP_ID.:24:&SESSION.::&DEBUG.::P24_PETTY_CASH_ID,P24_TREASURY:#PETTY_CASH_ID#,Y'
,p_column_linktext=>'#PETTY_CASH_NO#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30582566084848521)
,p_db_column_name=>'PETTY_CASH_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30582627226848522)
,p_db_column_name=>'DUE_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Due Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30582731624848523)
,p_db_column_name=>'PETTY_CASH_TYPE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8333351243197780)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30582802519848524)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Employee No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30582937190848525)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30583035622848526)
,p_db_column_name=>'TASK'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30583113021848527)
,p_db_column_name=>'AMOUNT'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30583216485848528)
,p_db_column_name=>'PURPOSE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Purpose'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30583387512848529)
,p_db_column_name=>'CLOSING_DATE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Closing Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30583413367848530)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30583592359848531)
,p_db_column_name=>'STATUS'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30583635407848532)
,p_db_column_name=>'RECONCILED_DATE'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Reconciled Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30583731962848533)
,p_db_column_name=>'PRIORITY'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8338101286248980)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30583869395848534)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30583987826848535)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30584022579848536)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30584180743848537)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30584273107848538)
,p_db_column_name=>'YEAR'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30584303156848539)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30584405683848540)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30584551442848541)
,p_db_column_name=>'COMMENT_TO_APPROVER'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Comment To Approver'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30584626357848542)
,p_db_column_name=>'INVOICING_YN'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Invoicing ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30584737454848543)
,p_db_column_name=>'PAID_YN'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Paid?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30584879012848544)
,p_db_column_name=>'INVOICE_NUMBER'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Invoice Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30622480305214701)
,p_db_column_name=>'EMPLOYEE_NAME'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Employee Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30622569545214702)
,p_db_column_name=>'EMPLOYEE_NAME_AR'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Employee Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(30617873210124430)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'306179'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PETTY_CASH_NO:PETTY_CASH_DATE:PETTY_CASH_TYPE:EMPLOYEE_NUM:EMPLOYEE_NAME:PROJECT_NUMBER:TASK:AMOUNT:CLOSING_DATE:APPROVAL_STATUS:PRIORITY:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(30588099987921364)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8067277693175509)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(8003821207175482)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(8121335853175533)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(60807195757105013)
,p_plug_name=>'To Be Processed By Treasury'
,p_region_name=>'inside-page'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8055912915175506)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    petty_cash_id,',
'    petty_cash_no,',
'    petty_cash_date,',
'    due_date,',
'    petty_cash_type,',
'    pc.employee_num,',
'    project_number,',
'    task,',
'    amount,',
'    purpose,',
'    closing_date,',
'    approval_status,',
'    status,',
'    reconciled_date,',
'    priority,',
'    creation_date,',
'    created_by,',
'    updated_by,',
'    updated_date,',
'    year,',
'    gl_account,',
'    justification,',
'    comment_to_approver,',
'    invoicing_yn,',
'    paid_yn,',
'    invoice_number,',
'    invoice_date,',
'    pv_number,',
'    gl_date,',
'    payment_number,',
'    payment_date',
'    , e.full_name_en employee_name',
'    , e.full_name_ar   employee_name_ar',
'    , 1 Action',
'FROM',
'    hrss_petty_cash pc , dct_employees_list2 e',
'where pc.employee_num = e.employee_num (+)',
'and approval_status = ''Approved''',
'and Paid_yn = ''N''',
'and invoicing_yn =''Y''',
'and petty_cash_type = nvl(:P26_TYPE , petty_Cash_type)',
'-- and extract(YEAR from payment_date ) = nvl(:P26_YEAR ,extract(YEAR from payment_date ) )',
'-- and extract(YEAR from invoice_date ) = nvl(:P26_YEAR ,extract(YEAR from invoice_date ) )'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P26_DISPLAY'
,p_plug_display_when_cond2=>'P'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'To Be Processed By Treasury'
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
 p_id=>wwv_flow_api.id(60807282036105014)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>60807282036105014
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30588975039923680)
,p_db_column_name=>'PETTY_CASH_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Petty Cash Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30589332554923681)
,p_db_column_name=>'PETTY_CASH_NO'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Petty Cash#'
,p_column_link=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::P3_PETTY_CASH_ID,P3_REQUEST:#PETTY_CASH_ID#,26'
,p_column_linktext=>'#PETTY_CASH_NO#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30589794059923681)
,p_db_column_name=>'PETTY_CASH_DATE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30590164861923682)
,p_db_column_name=>'DUE_DATE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Due Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30590520154923682)
,p_db_column_name=>'PETTY_CASH_TYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8333351243197780)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30590986149923682)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Employee No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30591321456923682)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30591793999923682)
,p_db_column_name=>'TASK'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30592198208923682)
,p_db_column_name=>'AMOUNT'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30592512732923683)
,p_db_column_name=>'PURPOSE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Purpose'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30592960707923683)
,p_db_column_name=>'CLOSING_DATE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Closing Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30593321449923683)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30593776920923683)
,p_db_column_name=>'STATUS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30594106126923683)
,p_db_column_name=>'RECONCILED_DATE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Reconciled Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30594579879923684)
,p_db_column_name=>'PRIORITY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8338101286248980)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30594988612923684)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30595310229923684)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30595705593923684)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30596123817923684)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30596596862923684)
,p_db_column_name=>'YEAR'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30596907274923685)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30597346487923685)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30597730666923685)
,p_db_column_name=>'COMMENT_TO_APPROVER'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Comment To Approver'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30598194759923685)
,p_db_column_name=>'INVOICING_YN'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Invoicing ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30598570218923685)
,p_db_column_name=>'PAID_YN'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Paid?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30598939614923685)
,p_db_column_name=>'INVOICE_NUMBER'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Invoice Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30599376317923686)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30599799768923686)
,p_db_column_name=>'PV_NUMBER'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Pv Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30600143398923686)
,p_db_column_name=>'GL_DATE'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Gl Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30600523436923686)
,p_db_column_name=>'PAYMENT_NUMBER'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Payment Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30600955435923686)
,p_db_column_name=>'PAYMENT_DATE'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Payment Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30585320014848549)
,p_db_column_name=>'EMPLOYEE_NAME'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Employee Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30585445461848550)
,p_db_column_name=>'EMPLOYEE_NAME_AR'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Employee Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30624969536214726)
,p_db_column_name=>'ACTION'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Action'
,p_column_link=>'f?p=&APP_ID.:24:&SESSION.::&DEBUG.::P24_PETTY_CASH_ID,P24_TREASURY:#PETTY_CASH_ID#,Y'
,p_column_linktext=>'Process Payment'
,p_column_link_attr=>'class="t-Button t-Button--hot"'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(60956597544924460)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'306013'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PETTY_CASH_NO:PETTY_CASH_DATE:PETTY_CASH_TYPE:EMPLOYEE_NUM:EMPLOYEE_NAME:PROJECT_NUMBER:TASK:AMOUNT:CLOSING_DATE:APPROVAL_STATUS:PRIORITY::ACTION'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30585011731848546)
,p_name=>'P26_DISPLAY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(30588099987921364)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30585110703848547)
,p_name=>'P26_DISPLAY_B'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(30588099987921364)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30623497513214711)
,p_name=>'P26_TYPE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(30588099987921364)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30623851431214715)
,p_name=>'P26_PAID'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(30588099987921364)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30623965006214716)
,p_name=>'P26_INVOICED'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(30588099987921364)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30624184214214718)
,p_name=>'P26_YEAR'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(30588099987921364)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30624395368214720)
,p_name=>'P26_TYPE_B'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(30588099987921364)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(30585254088848548)
,p_computation_sequence=>10
,p_computation_item=>'P26_DISPLAY_B'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select case :P26_DISPLAY  ',
'                       when ''H''     then ''History''',
'                       when ''P''     then ''Pending''',
'       end display',
' from dual',
'  '))
,p_computation_error_message=>'erro while generate P26_DISPLAY page item'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(30624416673214721)
,p_computation_sequence=>10
,p_computation_item=>'P26_TYPE_B'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select case :P26_TYPE  ',
'                       when ''T''     then ''Temporary Petty Cash Requests ''',
'                       when ''P''     then ''Permanent Petty Cash Requests ''',
'       end display',
' from dual',
'  '))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(30580766603848503)
,p_name=>'Dialog Close'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(60807195757105013)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(30580850431848504)
,p_event_id=>wwv_flow_api.id(30580766603848503)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(60807195757105013)
);
wwv_flow_api.component_end;
end;
/
