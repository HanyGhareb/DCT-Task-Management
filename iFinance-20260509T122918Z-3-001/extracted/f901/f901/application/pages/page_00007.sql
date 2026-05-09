prompt --application/pages/page_00007
begin
--   Manifest
--     PAGE: 00007
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
 p_id=>7
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'All Expense Reports - AP'
,p_alias=>'ALL-EXPENSE-REPORTS-AP'
,p_step_title=>'All Expense Reports - AP'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200607065737'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(93173781067448731)
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
 p_id=>wwv_flow_api.id(93174315128448732)
,p_plug_name=>'All Expense Reports - AP'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8055912915175506)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    er.expense_report_id,',
'    er.petty_cash_id,',
'    pc.petty_cash_no,',
'    pc.petty_cash_type,',
'    pc.year                     Petty_cash_year,',
'    pc.amount                   Petty_cash_Amount,',
'    pc.closing_date            Petty_cash_clsoing_date    ,',
'    pc.approval_status          Petty_cash__approval_status,',
'    pc.employee_num ,',
'    pc.invoicing_yn             Petty_cash__invoicing,',
'    pc.paid_yn                  Petty_cash_paid,',
'    pc.payment_date             Petty_cash_Payment_date,',
'    pc.project_number           Petty_cash__project,',
'    pc.task                     Petty_cash_Task,',
'        (Select f.tca_sector',
'        from f_projectbudget f',
'        where f.project_number = pc.project_number',
'        and f.task_number   = pc.task',
'        and ROWNUM =1)          Sector,',
'    (select v.organization_name_en_user',
'        from dct_bi_employees_v v',
'        where v.employee_num = pc.employee_num) Emp_org,',
'   (select v.department',
'        from dct_bi_employees_v v',
'        where v.employee_num = pc.employee_num) Department,  ',
'    pc.purpose                  Petty_cash_Purpose,',
'    pc.status                   Petty_cash_Status,',
'    pc.pv_number                Petty_cash_PV,',
'    pc.priority                 Petty_cash_Priority,',
'    pc.justification            Petty_cash_Justification,',
'    er.expense_report_num       ,',
'    er.purpose                  Expense_report_Purpose,',
'    er.approval_status          Expense_report_Approval_status,',
'    er.invoicing_yn             Expense_report_invoicing,',
'    er.priority                 Expense_report_priority,',
'    er.justification            Expense_report_Justification,',
'    er.comment_to_approver      Expense_report_comment_to_approver,',
'    er.creation_date            Expense_report_creation_date,',
'    er.created_by               Expense_report_created_by,',
'    er.updated_by               Expense_report_updated_by,',
'    er.updated_date             Expense_report_updated_date,',
'    er.year                     Expense_report_year,',
'    er.paid_yn                  Expense_report_Paid,',
'    decode(er.type, ''C'',''Clearing'',''Reimbursement'')                      Expense_report_type,',
'    (select sum(nvl(l.receipt_amount,0))',
'        from hrss_expense_report_lines l',
'        where l.expense_report_id = er.expense_report_id)  Expense_report_amount',
'FROM',
'    hrss_expense_reports er , hrss_petty_cash pc',
'where er.petty_cash_id = pc.petty_cash_id    '))
,p_plug_source_type=>'NATIVE_IR'
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
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
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
 p_id=>wwv_flow_api.id(46597527171233259)
,p_db_column_name=>'PETTY_CASH_YEAR'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Petty Cash Year'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
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
 p_id=>wwv_flow_api.id(46598345997233259)
,p_db_column_name=>'PETTY_CASH_CLSOING_DATE'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Petty Cash Clsoing Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46598729309233259)
,p_db_column_name=>'PETTY_CASH__APPROVAL_STATUS'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Petty Cash  Approval Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46599147259233259)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46599579859233259)
,p_db_column_name=>'PETTY_CASH__INVOICING'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Petty Cash  Invoicing'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46599911663233260)
,p_db_column_name=>'PETTY_CASH_PAID'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Petty Cash Paid'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
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
 p_id=>wwv_flow_api.id(46600776039233260)
,p_db_column_name=>'PETTY_CASH__PROJECT'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Petty Cash  Project'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46601150745233260)
,p_db_column_name=>'PETTY_CASH_TASK'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Petty Cash Task'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46601573128233260)
,p_db_column_name=>'PETTY_CASH_PURPOSE'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Petty Cash Purpose'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46601929843233260)
,p_db_column_name=>'PETTY_CASH_STATUS'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Petty Cash Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46602311690233261)
,p_db_column_name=>'PETTY_CASH_PV'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Petty Cash Pv'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
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
,p_column_label=>'Expense Report Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
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
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46604798756233262)
,p_db_column_name=>'EXPENSE_REPORT_INVOICING'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Expense Report Invoicing'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
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
 p_id=>wwv_flow_api.id(46605936079233262)
,p_db_column_name=>'EXPENSE_REPORT_COMMENT_TO_APPROVER'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'Expense Report Comment To Approver'
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
 p_id=>wwv_flow_api.id(46608351726233263)
,p_db_column_name=>'EXPENSE_REPORT_PAID'
,p_display_order=>32
,p_column_identifier=>'AF'
,p_column_label=>'Expense Report Paid'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
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
,p_column_label=>'Expense Report Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46553365378858719)
,p_db_column_name=>'SECTOR'
,p_display_order=>44
,p_column_identifier=>'AI'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46553498519858720)
,p_db_column_name=>'EMP_ORG'
,p_display_order=>54
,p_column_identifier=>'AJ'
,p_column_label=>'Emp Org'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46553558951858721)
,p_db_column_name=>'DEPARTMENT'
,p_display_order=>64
,p_column_identifier=>'AK'
,p_column_label=>'Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(46611804050236524)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'466119'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'EXPENSE_REPORT_NUM:PETTY_CASH_NO:PETTY_CASH_TYPE:PETTY_CASH_AMOUNT:EMPLOYEE_NUM:PETTY_CASH__PROJECT:PETTY_CASH_TASK:EXPENSE_REPORT_TYPE:EXPENSE_REPORT_AMOUNT::SECTOR:EMP_ORG:DEPARTMENT'
);
wwv_flow_api.component_end;
end;
/
