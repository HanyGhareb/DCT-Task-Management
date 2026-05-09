prompt --application/pages/page_00007
begin
--   Manifest
--     PAGE: 00007
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
 p_id=>7
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'All Expense Reports - AP'
,p_alias=>'ALL-EXPENSE-REPORTS-AP'
,p_step_title=>'All Expense Reports - AP'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'		',
'		/* Scroll Results Only in Side Column */',
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
'                background-color:#0e6655;',
'                color:black;',
'                }',
'.t-Region-title{',
'            color:black;',
'            font-weight: bold;',
'                }',
'',
'/* Custom Header color */',
'#inside-page .t-Region-header{',
'    background-color :#81d0b5;',
'    font-weight: bold;',
'}',
'',
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
'     background-color: #cae6e3;',
'    color:#000;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231115112952'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(93173781067448731)
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
 p_id=>wwv_flow_api.id(93174315128448732)
,p_plug_name=>'All Expense Reports - AP'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8055912915175506)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    ex.expense_report_id,',
'    petty_cash_id,',
'    petty_cash_no,',
'    petty_cash_amount,',
'    petty_cash_date,',
'    petty_cash_type,',
'    closing_date,',
'    ex.employee_num,',
'    e.full_name_en Employee_name,',
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
'    case petty_cash_approval_status',
'        WHEN    ''Approved''  THEN ''green''',
'        WHEN    ''Rejected''   Then  ''red''',
'        When    ''In-Progress''   Then ''GoldenRod''',
'        ELSE    ''black''',
'       end    as  "PC_STATUS_COLOR",',
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
'     case expense_report_approval_status',
'        WHEN    ''Approved''  THEN ''green''',
'        WHEN    ''Rejected''   Then  ''red''',
'        When    ''In-Progress''   Then ''GoldenRod''',
'        ELSE    ''black''',
'       end    as  "IE_STATUS_COLOR",',
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
'FROM',
'    expense_reports_all_v ex , employees_v e',
'where ex.employee_num = e.employee_num',
'and EXPENSE_REPORT_TYPE = nvl(:P7_EXPENSE_REPORT_TYPE , EXPENSE_REPORT_TYPE )    '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P7_EXPENSE_REPORT_TYPE'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'All Expense Reports - AP'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(93174462110448732)
,p_name=>'All Expense Reports - AP'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:35:&SESSION.::&DEBUG.:35:P35_EXPENSE_REPORT_ID,P35_ID,P35_PAGE_FROM:#EXPENSE_REPORT_ID#,#EXPENSE_REPORT_ID#,7'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>93174462110448732
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46595979101233258)
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
 p_id=>wwv_flow_api.id(46596328171233258)
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
 p_id=>wwv_flow_api.id(46596721884233258)
,p_db_column_name=>'PETTY_CASH_NO'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Petty Cash No'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46597101156233258)
,p_db_column_name=>'PETTY_CASH_TYPE'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Petty Cash Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8333351243197780)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46597949624233259)
,p_db_column_name=>'PETTY_CASH_AMOUNT'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Petty Cash Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46599147259233259)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Employee #'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46600303318233260)
,p_db_column_name=>'PETTY_CASH_PAYMENT_DATE'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Petty Cash Payment Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46602765989233261)
,p_db_column_name=>'PETTY_CASH_PRIORITY'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Petty Cash Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_rpt_named_lov=>wwv_flow_api.id(8338101286248980)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46603117479233261)
,p_db_column_name=>'PETTY_CASH_JUSTIFICATION'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Petty Cash Justification'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46603506289233261)
,p_db_column_name=>'EXPENSE_REPORT_NUM'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Expense Report Num#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46603999424233261)
,p_db_column_name=>'EXPENSE_REPORT_PURPOSE'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Expense Report Purpose'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46604323148233261)
,p_db_column_name=>'EXPENSE_REPORT_APPROVAL_STATUS'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Expense Report Approval Status'
,p_column_html_expression=>'<span style="font-weight:bold;color:#IE_STATUS_COLOR#">#EXPENSE_REPORT_APPROVAL_STATUS#</span>'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46605165024233262)
,p_db_column_name=>'EXPENSE_REPORT_PRIORITY'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Expense Report Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_rpt_named_lov=>wwv_flow_api.id(8338101286248980)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46605541848233262)
,p_db_column_name=>'EXPENSE_REPORT_JUSTIFICATION'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'Expense Report Justification'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46606335740233262)
,p_db_column_name=>'EXPENSE_REPORT_CREATION_DATE'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Expense Report Creation Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46606723529233262)
,p_db_column_name=>'EXPENSE_REPORT_CREATED_BY'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'Expense Report Created By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46607107672233263)
,p_db_column_name=>'EXPENSE_REPORT_UPDATED_BY'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'Expense Report Updated By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46607530289233263)
,p_db_column_name=>'EXPENSE_REPORT_UPDATED_DATE'
,p_display_order=>30
,p_column_identifier=>'AD'
,p_column_label=>'Expense Report Updated Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46607964453233263)
,p_db_column_name=>'EXPENSE_REPORT_YEAR'
,p_display_order=>31
,p_column_identifier=>'AE'
,p_column_label=>'Expense Report Year'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46608722190233263)
,p_db_column_name=>'EXPENSE_REPORT_TYPE'
,p_display_order=>33
,p_column_identifier=>'AG'
,p_column_label=>'Expense Report Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46609186918233263)
,p_db_column_name=>'EXPENSE_REPORT_AMOUNT'
,p_display_order=>34
,p_column_identifier=>'AH'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5398757908457475)
,p_db_column_name=>'PETTY_CASH_DATE'
,p_display_order=>44
,p_column_identifier=>'AL'
,p_column_label=>'Petty Cash Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5398772937457476)
,p_db_column_name=>'CLOSING_DATE'
,p_display_order=>54
,p_column_identifier=>'AM'
,p_column_label=>'Closing Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5398897003457477)
,p_db_column_name=>'EMPLOYEE_SECTOR'
,p_display_order=>64
,p_column_identifier=>'AN'
,p_column_label=>'Employee Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5399028037457478)
,p_db_column_name=>'EMPLOYEE_DEPARTMENT'
,p_display_order=>74
,p_column_identifier=>'AO'
,p_column_label=>'Employee Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5399131137457479)
,p_db_column_name=>'EMPLOYEE_ORGANIZATION'
,p_display_order=>84
,p_column_identifier=>'AP'
,p_column_label=>'Employee Organization'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5399209747457480)
,p_db_column_name=>'EMPLOYEE_SUPERVISOR'
,p_display_order=>94
,p_column_identifier=>'AQ'
,p_column_label=>'Employee Supervisor'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5399335841457481)
,p_db_column_name=>'EMPLOYEE_SUPERVISOR_NUM'
,p_display_order=>104
,p_column_identifier=>'AR'
,p_column_label=>'Employee Supervisor Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5399432500457482)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>114
,p_column_identifier=>'AS'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5399487672457483)
,p_db_column_name=>'GL_ACCOUNT_NAME'
,p_display_order=>124
,p_column_identifier=>'AT'
,p_column_label=>'Gl Account Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5399579969457484)
,p_db_column_name=>'GL_DATE'
,p_display_order=>134
,p_column_identifier=>'AU'
,p_column_label=>'Gl Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5399671398457485)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>144
,p_column_identifier=>'AV'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5399829416457486)
,p_db_column_name=>'TASK'
,p_display_order=>154
,p_column_identifier=>'AW'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5541307656584637)
,p_db_column_name=>'PETTY_CASH_STATU'
,p_display_order=>164
,p_column_identifier=>'AX'
,p_column_label=>'Petty Cash Statu'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5541379665584638)
,p_db_column_name=>'PETTY_CASH_APPROVAL_STATUS'
,p_display_order=>174
,p_column_identifier=>'AY'
,p_column_label=>'Petty Cash Approval Status'
,p_column_html_expression=>'<span style="font-weight:bold;color:#PC_STATUS_COLOR#">#PETTY_CASH_APPROVAL_STATUS#</span>'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5541475064584639)
,p_db_column_name=>'PETTY_CASH_PV_NUMBER'
,p_display_order=>184
,p_column_identifier=>'AZ'
,p_column_label=>'Petty Cash Pv Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5541593710584640)
,p_db_column_name=>'PETTY_CASH_CREATED_BY'
,p_display_order=>194
,p_column_identifier=>'BA'
,p_column_label=>'Petty Cash Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5541745953584641)
,p_db_column_name=>'PETTY_CASH_CREATION_DATE'
,p_display_order=>204
,p_column_identifier=>'BB'
,p_column_label=>'Petty Cash Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5541830022584642)
,p_db_column_name=>'PETTY_CASH_PAID_YN'
,p_display_order=>214
,p_column_identifier=>'BC'
,p_column_label=>'Petty Cash Paid ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5541953241584643)
,p_db_column_name=>'PETTY_CASH_INVOICING_YN'
,p_display_order=>224
,p_column_identifier=>'BD'
,p_column_label=>'Petty Cash Inviced ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5542017178584644)
,p_db_column_name=>'PETTY_CASH_INVOICE_DATE'
,p_display_order=>234
,p_column_identifier=>'BE'
,p_column_label=>'Petty Cash Invoice Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5542116299584645)
,p_db_column_name=>'PETTY_CASH_INVOICE_NUMBER'
,p_display_order=>244
,p_column_identifier=>'BF'
,p_column_label=>'Petty Cash Invoice Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5542202625584646)
,p_db_column_name=>'PETTY_CASH_PAYMENT_NUMBER'
,p_display_order=>254
,p_column_identifier=>'BG'
,p_column_label=>'Petty Cash Payment Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5542322330584647)
,p_db_column_name=>'EXPENSE_REPORT_DATE'
,p_display_order=>264
,p_column_identifier=>'BH'
,p_column_label=>'Expense Report Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5542451337584648)
,p_db_column_name=>'EXPENSE_REPORT_INVOICING_YN'
,p_display_order=>274
,p_column_identifier=>'BI'
,p_column_label=>'Expense Report Invoiced ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5542477128584649)
,p_db_column_name=>'EXPENSE_REPORT_COMMENT'
,p_display_order=>284
,p_column_identifier=>'BJ'
,p_column_label=>'Expense Report Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5542644514584650)
,p_db_column_name=>'EXPENSE_REPORT_PAID_YN'
,p_display_order=>294
,p_column_identifier=>'BK'
,p_column_label=>'Expense Report Paid ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5542696689584651)
,p_db_column_name=>'EXPENSE_REPORT_ORG_ID'
,p_display_order=>304
,p_column_identifier=>'BL'
,p_column_label=>'Expense Report Org Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5542811647584652)
,p_db_column_name=>'EXPENSE_REPORT_EMP_NUM'
,p_display_order=>314
,p_column_identifier=>'BM'
,p_column_label=>'Expense Report Emp Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5542897837584653)
,p_db_column_name=>'PHOTO'
,p_display_order=>324
,p_column_identifier=>'BN'
,p_column_label=>'Photo'
,p_column_html_expression=>'<br><img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_hide=>'N'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5542972280584654)
,p_db_column_name=>'PC_STATUS_COLOR'
,p_display_order=>334
,p_column_identifier=>'BO'
,p_column_label=>'Pc Status Color'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5543087223584655)
,p_db_column_name=>'IE_STATUS_COLOR'
,p_display_order=>344
,p_column_identifier=>'BP'
,p_column_label=>'Ie Status Color'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7119681839400569)
,p_db_column_name=>'EMPLOYEE_NAME'
,p_display_order=>354
,p_column_identifier=>'BQ'
,p_column_label=>'Employee Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(46611804050236524)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'466119'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'EMPLOYEE_NUM:EMPLOYEE_NAME:EXPENSE_REPORT_NUM:EXPENSE_REPORT_AMOUNT:EXPENSE_REPORT_TYPE:EMPLOYEE_SECTOR:EMPLOYEE_DEPARTMENT:PROJECT_NUMBER:EXPENSE_REPORT_DATE:EXPENSE_REPORT_APPROVAL_STATUS:PETTY_CASH_NO:PETTY_CASH_AMOUNT:CLOSING_DATE:PHOTO:'
,p_sort_column_1=>'EXPENSE_REPORT_DATE'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(37294980536577594)
,p_application_user=>'TCA9025'
,p_name=>'Last Approved IE'
,p_description=>'Last updated expense'
,p_report_seq=>10
,p_report_columns=>'EMPLOYEE_NUM:EMPLOYEE_NAME:EXPENSE_REPORT_NUM:EXPENSE_REPORT_AMOUNT:EXPENSE_REPORT_TYPE:EMPLOYEE_SECTOR:EMPLOYEE_DEPARTMENT:PROJECT_NUMBER:EXPENSE_REPORT_DATE:EXPENSE_REPORT_APPROVAL_STATUS:PETTY_CASH_AMOUNT:CLOSING_DATE:PHOTO:EXPENSE_REPORT_UPDATED_'
||'DATE:'
,p_sort_column_1=>'EXPENSE_REPORT_UPDATED_DATE'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'0'
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
 p_id=>wwv_flow_api.id(37294007713604183)
,p_report_id=>wwv_flow_api.id(37294980536577594)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'EXPENSE_REPORT_APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>'"EXPENSE_REPORT_APPROVAL_STATUS" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(37294525653588838)
,p_application_user=>'TCA9025'
,p_name=>'In-progress'
,p_report_seq=>10
,p_report_columns=>'EMPLOYEE_NUM:EMPLOYEE_NAME:EXPENSE_REPORT_NUM:EXPENSE_REPORT_AMOUNT:EXPENSE_REPORT_TYPE:EMPLOYEE_SECTOR:EMPLOYEE_DEPARTMENT:PROJECT_NUMBER:EXPENSE_REPORT_DATE:EXPENSE_REPORT_APPROVAL_STATUS:PETTY_CASH_AMOUNT:CLOSING_DATE:PHOTO:EXPENSE_REPORT_UPDATED_'
||'DATE:'
,p_sort_column_1=>'EXPENSE_REPORT_UPDATED_DATE'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'0'
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
 p_id=>wwv_flow_api.id(37294468069588838)
,p_report_id=>wwv_flow_api.id(37294525653588838)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'EXPENSE_REPORT_APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>'"EXPENSE_REPORT_APPROVAL_STATUS" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(37293168250640177)
,p_application_user=>'TCA9025'
,p_name=>'Expense 2021'
,p_description=>'Expense 2021'
,p_report_seq=>10
,p_report_columns=>'EMPLOYEE_NUM:EMPLOYEE_NAME:EXPENSE_REPORT_NUM:EXPENSE_REPORT_AMOUNT:EXPENSE_REPORT_TYPE:EMPLOYEE_SECTOR:EMPLOYEE_DEPARTMENT:PROJECT_NUMBER:EXPENSE_REPORT_DATE:EXPENSE_REPORT_APPROVAL_STATUS:PETTY_CASH_AMOUNT:CLOSING_DATE:PHOTO:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(37293071811640177)
,p_report_id=>wwv_flow_api.id(37293168250640177)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'EXPENSE_REPORT_CREATION_DATE'
,p_operator=>'>='
,p_expr=>'20210101010000'
,p_condition_sql=>'"EXPENSE_REPORT_CREATION_DATE" >= to_date(#APXWS_EXPR#,''YYYYMMDDHH24MISS'')'
,p_condition_display=>'#APXWS_COL_NAME# >= #APXWS_EXPR_DATE#  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(37291922257697335)
,p_application_user=>'TCA9025'
,p_name=>'Pending with AP'
,p_report_seq=>10
,p_report_columns=>'EMPLOYEE_NUM:EMPLOYEE_NAME:EXPENSE_REPORT_NUM:EXPENSE_REPORT_AMOUNT:EXPENSE_REPORT_TYPE:EMPLOYEE_SECTOR:EMPLOYEE_DEPARTMENT:PROJECT_NUMBER:EXPENSE_REPORT_DATE:EXPENSE_REPORT_APPROVAL_STATUS:PETTY_CASH_AMOUNT:CLOSING_DATE:PHOTO:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(37291240325710305)
,p_report_id=>wwv_flow_api.id(37291922257697335)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'EXPENSE_REPORT_CREATION_DATE'
,p_operator=>'>='
,p_expr=>'20210101010000'
,p_condition_sql=>'"EXPENSE_REPORT_CREATION_DATE" >= to_date(#APXWS_EXPR#,''YYYYMMDDHH24MISS'')'
,p_condition_display=>'#APXWS_COL_NAME# >= #APXWS_EXPR_DATE#  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(37291117942710305)
,p_report_id=>wwv_flow_api.id(37291922257697335)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'EXPENSE_REPORT_NUM'
,p_operator=>'in'
,p_expr=>'TCA197/2019/P1/IE3'
,p_condition_sql=>'"EXPENSE_REPORT_NUM" in (#APXWS_EXPR_VAL1#)'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''TCA197/2019/P1/IE3''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2351974029472790)
,p_name=>'P7_EXPENSE_REPORT_TYPE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(93173781067448731)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.component_end;
end;
/
