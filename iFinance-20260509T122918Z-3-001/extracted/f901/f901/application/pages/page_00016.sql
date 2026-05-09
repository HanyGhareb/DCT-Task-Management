prompt --application/pages/page_00016
begin
--   Manifest
--     PAGE: 00016
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
,p_last_upd_yyyymmddhh24miss=>'20200606134324'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(46344926684972790)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8067277693175509)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(8003821207175482)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(8121335853175533)
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
'select EXPENSE_REPORT_ID,',
'       PETTY_CASH_ID,',
'       (select pc.employee_num',
'        from hrss_petty_cash pc',
'        where pc.petty_cash_id = hrss_expense_reports.petty_cash_id) emp_num,',
'        (select e.full_name_en',
'        from dct_employees_list2 e',
'        where e.employee_num = (select pc.employee_num',
'                                from hrss_petty_cash pc',
'                                where pc.petty_cash_id = hrss_expense_reports.petty_cash_id)) emp_name, ',
'       EXPENSE_REPORT_DATE,',
'       PURPOSE,',
'       APPROVAL_STATUS,',
'       INVOICING_YN,',
'       PAID_YN,',
'       PRIORITY,',
'       JUSTIFICATION,',
'       COMMENT_TO_APPROVER,',
'       CREATION_DATE,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       UPDATED_DATE,',
'       YEAR,',
'       EXPENSE_REPORT_NUM',
'        ,(select sum(nvl(l.receipt_amount,0))',
'        from hrss_expense_report_lines l',
'        where l.expense_report_id = HRSS_EXPENSE_REPORTS.expense_report_id ) total_ampunt',
'  from HRSS_EXPENSE_REPORTS',
'    where :APP_USER in (select ''TCA''||pc.employee_num',
'        from hrss_petty_cash pc',
'        where pc.petty_cash_id = petty_cash_id)'))
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
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
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
 p_id=>wwv_flow_api.id(46347236796972793)
,p_db_column_name=>'PURPOSE'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Purpose'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_rpt_named_lov=>wwv_flow_api.id(8345862665015663)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46347647199972793)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46348031588972793)
,p_db_column_name=>'INVOICING_YN'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Invoiced ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46348468190972793)
,p_db_column_name=>'PRIORITY'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_rpt_named_lov=>wwv_flow_api.id(8338101286248980)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46348865954972794)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46349270592972794)
,p_db_column_name=>'COMMENT_TO_APPROVER'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Comment To Approver'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46349623804972794)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46350078763972794)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46350425514972794)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46350847685972794)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46351214985972794)
,p_db_column_name=>'YEAR'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
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
 p_id=>wwv_flow_api.id(43120684742427623)
,p_db_column_name=>'EMP_NUM'
,p_display_order=>25
,p_column_identifier=>'P'
,p_column_label=>'Employee No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43120784832427624)
,p_db_column_name=>'EMP_NAME'
,p_display_order=>35
,p_column_identifier=>'Q'
,p_column_label=>'Emp Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43120803377427625)
,p_db_column_name=>'TOTAL_AMPUNT'
,p_display_order=>45
,p_column_identifier=>'R'
,p_column_label=>'Total Ampunt'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43120992410427626)
,p_db_column_name=>'PAID_YN'
,p_display_order=>55
,p_column_identifier=>'S'
,p_column_label=>'Paid ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(46352040958973723)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'463521'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'EXPENSE_REPORT_NUM:EXPENSE_REPORT_DATE:EMP_NUM:EMP_NAME:PURPOSE:APPROVAL_STATUS:PRIORITY:JUSTIFICATION:TOTAL_AMPUNT:INVOICING_YN:PAID_YN:'
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
,p_button_redirect_url=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:25::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.component_end;
end;
/
