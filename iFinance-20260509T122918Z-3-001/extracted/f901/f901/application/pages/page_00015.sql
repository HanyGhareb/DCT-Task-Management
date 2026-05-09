prompt --application/pages/page_00015
begin
--   Manifest
--     PAGE: 00015
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>123
,p_default_id_offset=>6039605030667831
,p_default_owner=>'DEV'
);
wwv_flow_api.create_page(
 p_id=>15
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Payable Pending Tasls'
,p_alias=>'PAYABLE-PENDING-TASLS'
,p_step_title=>'Payable Pending Tasls'
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
,p_last_upd_yyyymmddhh24miss=>'20200606095138'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(61401710872263718)
,p_plug_name=>'Processed By Accounts Payable'
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
'-- and Paid_yn = nvl(:P15_PAID , paid_yn)',
'and invoicing_yn = nvl(:P15_INVOICED , invoicing_yn)',
'and petty_cash_type = nvl(:P15_TYPE , petty_Cash_type)',
'-- and extract(YEAR from payment_date ) = nvl(:P15_YEAR ,extract(YEAR from payment_date ) )',
'and extract(YEAR from invoice_date ) = nvl(:P15_YEAR ,extract(YEAR from invoice_date ) )'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P15_DISPLAY'
,p_plug_display_when_cond2=>'H'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Processed By Accounts Payable'
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
 p_id=>wwv_flow_api.id(61401821208263719)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>61401821208263719
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30837785895415221)
,p_db_column_name=>'PETTY_CASH_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Petty Cash Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30838185438415221)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30838599854415221)
,p_db_column_name=>'PV_NUMBER'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Pv Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30838948993415221)
,p_db_column_name=>'GL_DATE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Gl Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30839362713415222)
,p_db_column_name=>'PAYMENT_NUMBER'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Payment Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30839753154415222)
,p_db_column_name=>'PAYMENT_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Payment Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30840129929415222)
,p_db_column_name=>'PETTY_CASH_NO'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Petty Cash#'
,p_column_link=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::P3_PETTY_CASH_ID,P3_REQUEST:#PETTY_CASH_ID#,15'
,p_column_linktext=>'#PETTY_CASH_NO#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30840582325415222)
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
 p_id=>wwv_flow_api.id(30840945860415222)
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
 p_id=>wwv_flow_api.id(30841310455415222)
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
 p_id=>wwv_flow_api.id(30841781315415223)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Employee No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30842105622415223)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30842512211415223)
,p_db_column_name=>'TASK'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30842960189415223)
,p_db_column_name=>'AMOUNT'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30843324811415223)
,p_db_column_name=>'PURPOSE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Purpose'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30843725518415223)
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
 p_id=>wwv_flow_api.id(30844178908415223)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30844585223415224)
,p_db_column_name=>'STATUS'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30844930389415224)
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
 p_id=>wwv_flow_api.id(30845315598415224)
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
 p_id=>wwv_flow_api.id(30845767579415224)
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
 p_id=>wwv_flow_api.id(30846174679415224)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30846588788415224)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30846931922415225)
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
 p_id=>wwv_flow_api.id(30847337772415225)
,p_db_column_name=>'YEAR'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30847750333415225)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30848169643415225)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30848559329415225)
,p_db_column_name=>'COMMENT_TO_APPROVER'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Comment To Approver'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30848904861415225)
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
 p_id=>wwv_flow_api.id(30849315768415226)
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
 p_id=>wwv_flow_api.id(30849781252415226)
,p_db_column_name=>'INVOICE_NUMBER'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Invoice Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30850150955415226)
,p_db_column_name=>'EMPLOYEE_NAME'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Employee Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30850533708415226)
,p_db_column_name=>'EMPLOYEE_NAME_AR'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Employee Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(61437980249539636)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'308509'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PETTY_CASH_NO:PETTY_CASH_DATE:PETTY_CASH_TYPE:EMPLOYEE_NUM:EMPLOYEE_NAME:PROJECT_NUMBER:TASK:AMOUNT:CLOSING_DATE:APPROVAL_STATUS:PRIORITY:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(61408207027336570)
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
 p_id=>wwv_flow_api.id(91627302796520219)
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
'and Paid_yn = nvl(:P15_PAID , paid_yn)',
'and invoicing_yn = nvl(:P15_INVOICED , invoicing_yn)',
'and petty_cash_type = nvl(:P15_TYPE , petty_Cash_type)',
'-- and extract(YEAR from payment_date ) = nvl(:P15_YEAR ,extract(YEAR from payment_date ) )',
'-- and extract(YEAR from invoice_date ) = nvl(:P15_YEAR ,extract(YEAR from invoice_date ) )'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P15_DISPLAY'
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
 p_id=>wwv_flow_api.id(91627389075520220)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Pending Requests'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>91627389075520220
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30824624395415214)
,p_db_column_name=>'PETTY_CASH_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Petty Cash Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30825086630415215)
,p_db_column_name=>'PETTY_CASH_NO'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Petty Cash#'
,p_column_link=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::P3_PETTY_CASH_ID,P3_REQUEST:#PETTY_CASH_ID#,15'
,p_column_linktext=>'#PETTY_CASH_NO#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30825461954415215)
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
 p_id=>wwv_flow_api.id(30825841223415215)
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
 p_id=>wwv_flow_api.id(30826268214415215)
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
 p_id=>wwv_flow_api.id(30826649850415215)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Employee No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30827045523415216)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30827436497415216)
,p_db_column_name=>'TASK'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30827860262415216)
,p_db_column_name=>'AMOUNT'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30828209594415216)
,p_db_column_name=>'PURPOSE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Purpose'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30828698703415216)
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
 p_id=>wwv_flow_api.id(30829086555415216)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30829408555415217)
,p_db_column_name=>'STATUS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30829886679415217)
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
 p_id=>wwv_flow_api.id(30830292447415217)
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
 p_id=>wwv_flow_api.id(30830611672415217)
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
 p_id=>wwv_flow_api.id(30831098684415217)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30831476273415217)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30831832632415218)
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
 p_id=>wwv_flow_api.id(30832295796415218)
,p_db_column_name=>'YEAR'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30832638088415218)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30833031223415218)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30833420395415218)
,p_db_column_name=>'COMMENT_TO_APPROVER'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Comment To Approver'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30833871356415218)
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
 p_id=>wwv_flow_api.id(30834240749415219)
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
 p_id=>wwv_flow_api.id(30834616336415219)
,p_db_column_name=>'INVOICE_NUMBER'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Invoice Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30835016230415219)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30835486577415219)
,p_db_column_name=>'PV_NUMBER'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Pv Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30835811303415219)
,p_db_column_name=>'GL_DATE'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Gl Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30836200163415219)
,p_db_column_name=>'PAYMENT_NUMBER'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Payment Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30836694265415219)
,p_db_column_name=>'PAYMENT_DATE'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Payment Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30823816267415214)
,p_db_column_name=>'EMPLOYEE_NAME'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Employee Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30824295152415214)
,p_db_column_name=>'EMPLOYEE_NAME_AR'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Employee Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30624555207214722)
,p_db_column_name=>'ACTION'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Action'
,p_column_link=>'f?p=&APP_ID.:24:&SESSION.::&DEBUG.::P24_PETTY_CASH_ID,P24_TREASURY:#PETTY_CASH_ID#,N'
,p_column_linktext=>'Proccess'
,p_column_link_attr=>'class="t-Button t-Button--hot"'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(91776704584339666)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'308370'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PETTY_CASH_NO:PETTY_CASH_DATE:PETTY_CASH_TYPE:EMPLOYEE_NUM:EMPLOYEE_NAME:PROJECT_NUMBER:TASK:AMOUNT:CLOSING_DATE:APPROVAL_STATUS:PRIORITY::ACTION'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30820779592415211)
,p_name=>'P15_DISPLAY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(61408207027336570)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30821130401415212)
,p_name=>'P15_DISPLAY_B'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(61408207027336570)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30821551783415212)
,p_name=>'P15_TYPE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(61408207027336570)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30821995337415212)
,p_name=>'P15_TYPE_B'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(61408207027336570)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30822307184415212)
,p_name=>'P15_YEAR'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(61408207027336570)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30822730384415213)
,p_name=>'P15_PAID'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(61408207027336570)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30823133108415213)
,p_name=>'P15_INVOICED'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(61408207027336570)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(30851790729415229)
,p_computation_sequence=>10
,p_computation_item=>'P15_DISPLAY_B'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select case :P15_DISPLAY  ',
'                       when ''H''     then ''History''',
'                       when ''P''     then ''Pending''',
'       end display',
' from dual',
'  '))
,p_computation_error_message=>'erro while generate P15_DISPLAY page item'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(30852139403415229)
,p_computation_sequence=>10
,p_computation_item=>'P15_TYPE_B'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select case :P15_TYPE  ',
'                       when ''T''     then ''Temporary Petty Cash Requests ''',
'                       when ''P''     then ''Permanent Petty Cash Requests ''',
'       end display',
' from dual',
'  '))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(30852443811415229)
,p_name=>'Dialog Close'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(91627302796520219)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(30852938720415230)
,p_event_id=>wwv_flow_api.id(30852443811415229)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(91627302796520219)
);
wwv_flow_api.component_end;
end;
/
