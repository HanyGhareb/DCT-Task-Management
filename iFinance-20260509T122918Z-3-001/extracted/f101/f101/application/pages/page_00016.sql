prompt --application/pages/page_00016
begin
--   Manifest
--     PAGE: 00016
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
 p_id=>16
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Expense Reports - User'
,p_alias=>'EXPENSE-REPORTS-USER'
,p_step_title=>'Expense Reports - User'
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
,p_last_upd_yyyymmddhh24miss=>'20211221061349'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(46344926684972790)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
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
 p_id=>wwv_flow_api.id(46345593748972790)
,p_plug_name=>'Expense Reports - User'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8055912915175506)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    expense_report_id,',
'    petty_cash_id,',
'    petty_cash_no,',
'    petty_cash_amount,',
'    petty_cash_date,',
'    petty_cash_type,',
'    closing_date,',
'    employee_num,',
'    employee_sector,',
'    employee_department,',
'    employee_organization,',
'    employee_supervisor,',
'    employee_supervisor_num,',
'    gl_account,',
'    gl_account_name,',
'    gl_date,',
'    project_number,',
'    task,',
'    petty_cash_priority,',
'    petty_cash_statu,',
'    petty_cash_approval_status,',
'    petty_cash_justification,',
'    petty_cash_pv_number,',
'    petty_cash_created_by,',
'    petty_cash_creation_date,',
'    petty_cash_paid_yn,',
'    petty_cash_invoicing_yn,',
'    petty_cash_invoice_date,',
'    petty_cash_invoice_number,',
'    petty_cash_payment_number,',
'    petty_cash_payment_date,',
'    expense_report_date,',
'    expense_report_purpose,',
'    expense_report_approval_status,',
'    case expense_report_approval_status',
'        WHEN    ''Approved''  THEN ''green''',
'        WHEN    ''Rejected''   Then  ''red''',
'        When    ''In-Progress''   Then ''GoldenRod''',
'        ELSE    ''black''',
'       end    as  "STATUS_COLOR",',
'    expense_report_invoicing_yn,',
'    expense_report_priority,',
'    expense_report_justification,',
'    expense_report_comment,',
'    expense_report_creation_date,',
'    expense_report_created_by,',
'    expense_report_updated_by,',
'    expense_report_updated_date,',
'    expense_report_year,',
'    expense_report_num,',
'    expense_report_paid_yn,',
'    expense_report_type,',
'    expense_report_org_id,',
'    expense_report_emp_num,',
'    expense_report_amount,',
'    photo',
'    ,''<span aria-hidden="true" class="fa fa-copy fa-2x"></span>'' Copy',
'FROM',
'    expense_reports_all_v',
'where employee_num = :EMP_NUM',
'and expense_report_type =  NVL(:P16_TYPE , expense_report_type)'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Expense Reports - User'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(46345698639972790)
,p_name=>'Expense Reports - User'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:35:&SESSION.::&DEBUG.:16:P35_EXPENSE_REPORT_ID,P35_PAGE_FROM,P35_PETTY_CASH_TYPE:#EXPENSE_REPORT_ID#,16,#PETTY_CASH_TYPE#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>46345698639972790
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46346097996972792)
,p_db_column_name=>'EXPENSE_REPORT_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Expense Report Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46346460220972793)
,p_db_column_name=>'PETTY_CASH_ID'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Petty Cash Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46346834920972793)
,p_db_column_name=>'EXPENSE_REPORT_DATE'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46351638777972795)
,p_db_column_name=>'EXPENSE_REPORT_NUM'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Expense Report#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5544598184584670)
,p_db_column_name=>'PETTY_CASH_NO'
,p_display_order=>25
,p_column_identifier=>'T'
,p_column_label=>'Petty Cash No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5544698034584671)
,p_db_column_name=>'PETTY_CASH_AMOUNT'
,p_display_order=>35
,p_column_identifier=>'U'
,p_column_label=>'Petty Cash Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5544796797584672)
,p_db_column_name=>'PETTY_CASH_DATE'
,p_display_order=>45
,p_column_identifier=>'V'
,p_column_label=>'Petty Cash Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5544906286584673)
,p_db_column_name=>'PETTY_CASH_TYPE'
,p_display_order=>55
,p_column_identifier=>'W'
,p_column_label=>'Petty Cash Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5544995244584674)
,p_db_column_name=>'CLOSING_DATE'
,p_display_order=>65
,p_column_identifier=>'X'
,p_column_label=>'Closing Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5545102643584675)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>75
,p_column_identifier=>'Y'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5545173577584676)
,p_db_column_name=>'EMPLOYEE_SECTOR'
,p_display_order=>85
,p_column_identifier=>'Z'
,p_column_label=>'Employee Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5545264032584677)
,p_db_column_name=>'EMPLOYEE_DEPARTMENT'
,p_display_order=>95
,p_column_identifier=>'AA'
,p_column_label=>'Employee Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5545408529584678)
,p_db_column_name=>'EMPLOYEE_ORGANIZATION'
,p_display_order=>105
,p_column_identifier=>'AB'
,p_column_label=>'Employee Organization'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5545483422584679)
,p_db_column_name=>'EMPLOYEE_SUPERVISOR'
,p_display_order=>115
,p_column_identifier=>'AC'
,p_column_label=>'Employee Supervisor'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5545626987584680)
,p_db_column_name=>'EMPLOYEE_SUPERVISOR_NUM'
,p_display_order=>125
,p_column_identifier=>'AD'
,p_column_label=>'Employee Supervisor Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5545697179584681)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>135
,p_column_identifier=>'AE'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5545828666584682)
,p_db_column_name=>'GL_ACCOUNT_NAME'
,p_display_order=>145
,p_column_identifier=>'AF'
,p_column_label=>'Gl Account Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5545904763584683)
,p_db_column_name=>'GL_DATE'
,p_display_order=>155
,p_column_identifier=>'AG'
,p_column_label=>'Gl Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5545990311584684)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>165
,p_column_identifier=>'AH'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5546113299584685)
,p_db_column_name=>'TASK'
,p_display_order=>175
,p_column_identifier=>'AI'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5546218355584686)
,p_db_column_name=>'PETTY_CASH_PRIORITY'
,p_display_order=>185
,p_column_identifier=>'AJ'
,p_column_label=>'Petty Cash Priority'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5607676191965837)
,p_db_column_name=>'PETTY_CASH_STATU'
,p_display_order=>195
,p_column_identifier=>'AK'
,p_column_label=>'Petty Cash Statu'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5607811632965838)
,p_db_column_name=>'PETTY_CASH_APPROVAL_STATUS'
,p_display_order=>205
,p_column_identifier=>'AL'
,p_column_label=>'Petty Cash Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5607879464965839)
,p_db_column_name=>'PETTY_CASH_JUSTIFICATION'
,p_display_order=>215
,p_column_identifier=>'AM'
,p_column_label=>'Petty Cash Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5608046822965840)
,p_db_column_name=>'PETTY_CASH_PV_NUMBER'
,p_display_order=>225
,p_column_identifier=>'AN'
,p_column_label=>'Petty Cash Pv Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5608065642965841)
,p_db_column_name=>'PETTY_CASH_CREATED_BY'
,p_display_order=>235
,p_column_identifier=>'AO'
,p_column_label=>'Petty Cash Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5608175190965842)
,p_db_column_name=>'PETTY_CASH_CREATION_DATE'
,p_display_order=>245
,p_column_identifier=>'AP'
,p_column_label=>'Petty Cash Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5608351115965843)
,p_db_column_name=>'PETTY_CASH_PAID_YN'
,p_display_order=>255
,p_column_identifier=>'AQ'
,p_column_label=>'Petty Cash Paid ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5608428289965844)
,p_db_column_name=>'PETTY_CASH_INVOICING_YN'
,p_display_order=>265
,p_column_identifier=>'AR'
,p_column_label=>'Petty Cash Invoiced ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5608500883965845)
,p_db_column_name=>'PETTY_CASH_INVOICE_DATE'
,p_display_order=>275
,p_column_identifier=>'AS'
,p_column_label=>'Petty Cash Invoice Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5608626561965846)
,p_db_column_name=>'PETTY_CASH_INVOICE_NUMBER'
,p_display_order=>285
,p_column_identifier=>'AT'
,p_column_label=>'Petty Cash Invoice Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5608683235965847)
,p_db_column_name=>'PETTY_CASH_PAYMENT_NUMBER'
,p_display_order=>295
,p_column_identifier=>'AU'
,p_column_label=>'Petty Cash Payment Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5608845796965848)
,p_db_column_name=>'PETTY_CASH_PAYMENT_DATE'
,p_display_order=>305
,p_column_identifier=>'AV'
,p_column_label=>'Petty Cash Payment Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5608936417965849)
,p_db_column_name=>'EXPENSE_REPORT_PURPOSE'
,p_display_order=>315
,p_column_identifier=>'AW'
,p_column_label=>'Expense Report Purpose'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5609009473965850)
,p_db_column_name=>'EXPENSE_REPORT_APPROVAL_STATUS'
,p_display_order=>325
,p_column_identifier=>'AX'
,p_column_label=>'Expense Report Approval Status'
,p_column_html_expression=>'<span style="font-weight:bold;color:#STATUS_COLOR#">#EXPENSE_REPORT_APPROVAL_STATUS#</span>'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5609148524965851)
,p_db_column_name=>'EXPENSE_REPORT_INVOICING_YN'
,p_display_order=>335
,p_column_identifier=>'AY'
,p_column_label=>'Expense Report Invoiced ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5609228490965852)
,p_db_column_name=>'EXPENSE_REPORT_PRIORITY'
,p_display_order=>345
,p_column_identifier=>'AZ'
,p_column_label=>'Expense Report Priority'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5609311655965853)
,p_db_column_name=>'EXPENSE_REPORT_JUSTIFICATION'
,p_display_order=>355
,p_column_identifier=>'BA'
,p_column_label=>'Expense Report Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5609428449965854)
,p_db_column_name=>'EXPENSE_REPORT_COMMENT'
,p_display_order=>365
,p_column_identifier=>'BB'
,p_column_label=>'Expense Report Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5609510672965855)
,p_db_column_name=>'EXPENSE_REPORT_CREATION_DATE'
,p_display_order=>375
,p_column_identifier=>'BC'
,p_column_label=>'Expense Report Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5609640351965856)
,p_db_column_name=>'EXPENSE_REPORT_CREATED_BY'
,p_display_order=>385
,p_column_identifier=>'BD'
,p_column_label=>'Expense Report Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5609736458965857)
,p_db_column_name=>'EXPENSE_REPORT_UPDATED_BY'
,p_display_order=>395
,p_column_identifier=>'BE'
,p_column_label=>'Expense Report Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5609793012965858)
,p_db_column_name=>'EXPENSE_REPORT_UPDATED_DATE'
,p_display_order=>405
,p_column_identifier=>'BF'
,p_column_label=>'Expense Report Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5609924976965859)
,p_db_column_name=>'EXPENSE_REPORT_YEAR'
,p_display_order=>415
,p_column_identifier=>'BG'
,p_column_label=>'Expense Report Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5610006601965860)
,p_db_column_name=>'EXPENSE_REPORT_PAID_YN'
,p_display_order=>425
,p_column_identifier=>'BH'
,p_column_label=>'Expense Report Paid ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5610094033965861)
,p_db_column_name=>'EXPENSE_REPORT_TYPE'
,p_display_order=>435
,p_column_identifier=>'BI'
,p_column_label=>'Expense Report Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5610182461965862)
,p_db_column_name=>'EXPENSE_REPORT_ORG_ID'
,p_display_order=>445
,p_column_identifier=>'BJ'
,p_column_label=>'Expense Report Org Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5610358495965863)
,p_db_column_name=>'EXPENSE_REPORT_EMP_NUM'
,p_display_order=>455
,p_column_identifier=>'BK'
,p_column_label=>'Expense Report Emp Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5610387771965864)
,p_db_column_name=>'EXPENSE_REPORT_AMOUNT'
,p_display_order=>465
,p_column_identifier=>'BL'
,p_column_label=>'Expense Report Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5610462205965865)
,p_db_column_name=>'PHOTO'
,p_display_order=>475
,p_column_identifier=>'BM'
,p_column_label=>'Photo'
,p_column_html_expression=>'<br><img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5610640590965866)
,p_db_column_name=>'STATUS_COLOR'
,p_display_order=>485
,p_column_identifier=>'BN'
,p_column_label=>'Status Color'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2354541675472816)
,p_db_column_name=>'COPY'
,p_display_order=>495
,p_column_identifier=>'BO'
,p_column_label=>'Copy'
,p_column_link=>'f?p=&APP_ID.:59:&SESSION.::&DEBUG.:59:P59_ID,P59_TRX,P59_REQUEST_NUM:#EXPENSE_REPORT_ID#,ER,#EXPENSE_REPORT_NUM#'
,p_column_linktext=>'#COPY#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(46352040958973723)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'463521'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'EXPENSE_REPORT_NUM:EXPENSE_REPORT_TYPE:EXPENSE_REPORT_DATE:EXPENSE_REPORT_APPROVAL_STATUS:EXPENSE_REPORT_AMOUNT:EMPLOYEE_NUM:PROJECT_NUMBER:TASK:EMPLOYEE_SECTOR:EMPLOYEE_DEPARTMENT:GL_ACCOUNT:EXPENSE_REPORT_PAID_YN:PHOTO:COPY'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(43121051503427627)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(46344926684972790)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Expense Report'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:35:&SESSION.::&DEBUG.:35:P35_PAGE_FROM:16'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'',
'l_enable_clearing    varchar2(1);',
'',
'begin',
'',
'select enable_clearing',
'into l_enable_clearing',
'from hrss_configurations',
'where id = 1;',
'',
'',
'    if l_enable_clearing = ''Y'' then',
'        return true;',
'    else',
'        return false;',
'    end if;',
'end;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(16283125206544339)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(46344926684972790)
,p_button_name=>'New_1'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Expense Report'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:61:&SESSION.::&DEBUG.:::'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'',
'l_enable_clearing    varchar2(1);',
'',
'begin',
'',
'select enable_clearing',
'into l_enable_clearing',
'from hrss_configurations',
'where id = 1;',
'',
'',
'    if l_enable_clearing = ''N'' then',
'        return true;',
'    else',
'        return false;',
'    end if;',
'end;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4584615384120858)
,p_name=>'P16_TYPE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(46344926684972790)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.component_end;
end;
/
