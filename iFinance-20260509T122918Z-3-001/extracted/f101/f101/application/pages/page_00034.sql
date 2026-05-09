prompt --application/pages/page_00034
begin
--   Manifest
--     PAGE: 00034
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
 p_id=>34
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Petty Cash Cleared Details - Report'
,p_alias=>'PETTY-CASH-CLEARED-DETAILS-REPORT'
,p_page_mode=>'MODAL'
,p_step_title=>'Petty Cash Cleared Details - Report'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200913060028'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(5506894148049003)
,p_plug_name=>'Petty Cash Cleared Details - Report'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8055912915175506)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select *',
'from expense_reports_all_v',
'where petty_cash_id = :P34_petty_cash_id'))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_page_header=>'Petty Cash Cleared Details - Report'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(5506966517049003)
,p_name=>'Petty Cash Cleared Details - Report'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>7497004844112767
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5507416744049008)
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
 p_id=>wwv_flow_api.id(5507823688049008)
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
 p_id=>wwv_flow_api.id(5508245185049009)
,p_db_column_name=>'PETTY_CASH_NO'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Petty Cash No'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5508603388049009)
,p_db_column_name=>'PETTY_CASH_AMOUNT'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Petty Cash Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5509060916049009)
,p_db_column_name=>'PETTY_CASH_DATE'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Petty Cash Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5509369216049010)
,p_db_column_name=>'PETTY_CASH_TYPE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Petty Cash Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5509769910049010)
,p_db_column_name=>'CLOSING_DATE'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Closing Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5510251172049010)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5510650760049010)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5511023048049011)
,p_db_column_name=>'GL_DATE'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Gl Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5511397006049011)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5511766239049011)
,p_db_column_name=>'TASK'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Task'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5512219121049012)
,p_db_column_name=>'PETTY_CASH_PRIORITY'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Petty Cash Priority'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5512600268049012)
,p_db_column_name=>'PETTY_CASH_STATU'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Petty Cash Statu'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5513041178049012)
,p_db_column_name=>'PETTY_CASH_APPROVAL_STATUS'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Petty Cash Approval Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5513400142049013)
,p_db_column_name=>'PETTY_CASH_JUSTIFICATION'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Petty Cash Justification'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5513790735049013)
,p_db_column_name=>'PETTY_CASH_PV_NUMBER'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Petty Cash Pv Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5514171978049013)
,p_db_column_name=>'PETTY_CASH_CREATED_BY'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Petty Cash Created By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5514640347049013)
,p_db_column_name=>'PETTY_CASH_CREATION_DATE'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Petty Cash Creation Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5514979530049014)
,p_db_column_name=>'PETTY_CASH_PAID_YN'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Petty Cash Paid Yn'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5515393203049014)
,p_db_column_name=>'PETTY_CASH_INVOICING_YN'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Petty Cash Invoicing Yn'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5515763317049014)
,p_db_column_name=>'PETTY_CASH_INVOICE_DATE'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Petty Cash Invoice Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5516178502049014)
,p_db_column_name=>'PETTY_CASH_INVOICE_NUMBER'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Petty Cash Invoice Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5516634586049015)
,p_db_column_name=>'PETTY_CASH_PAYMENT_NUMBER'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Petty Cash Payment Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5517021732049015)
,p_db_column_name=>'PETTY_CASH_PAYMENT_DATE'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'Petty Cash Payment Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5517415436049015)
,p_db_column_name=>'EXPENSE_REPORT_DATE'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'Expense Report Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5517824844049016)
,p_db_column_name=>'EXPENSE_REPORT_PURPOSE'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Expense Report Purpose'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5518227309049016)
,p_db_column_name=>'EXPENSE_REPORT_APPROVAL_STATUS'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'Expense Report Approval Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5518660343049016)
,p_db_column_name=>'EXPENSE_REPORT_INVOICING_YN'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'Expense Report Invoicing Yn'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5519038498049016)
,p_db_column_name=>'EXPENSE_REPORT_PRIORITY'
,p_display_order=>30
,p_column_identifier=>'AD'
,p_column_label=>'Expense Report Priority'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5519456353049017)
,p_db_column_name=>'EXPENSE_REPORT_JUSTIFICATION'
,p_display_order=>31
,p_column_identifier=>'AE'
,p_column_label=>'Expense Report Justification'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5519835658049017)
,p_db_column_name=>'EXPENSE_REPORT_COMMENT'
,p_display_order=>32
,p_column_identifier=>'AF'
,p_column_label=>'Expense Report Comment'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5520182787049017)
,p_db_column_name=>'EXPENSE_REPORT_CREATION_DATE'
,p_display_order=>33
,p_column_identifier=>'AG'
,p_column_label=>'Expense Report Creation Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5520655375049017)
,p_db_column_name=>'EXPENSE_REPORT_CREATED_BY'
,p_display_order=>34
,p_column_identifier=>'AH'
,p_column_label=>'Expense Report Created By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5521010424049018)
,p_db_column_name=>'EXPENSE_REPORT_UPDATED_BY'
,p_display_order=>35
,p_column_identifier=>'AI'
,p_column_label=>'Expense Report Updated By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5521439597049018)
,p_db_column_name=>'EXPENSE_REPORT_UPDATED_DATE'
,p_display_order=>36
,p_column_identifier=>'AJ'
,p_column_label=>'Expense Report Updated Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5521823860049018)
,p_db_column_name=>'EXPENSE_REPORT_YEAR'
,p_display_order=>37
,p_column_identifier=>'AK'
,p_column_label=>'Expense Report Year'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5522187422049018)
,p_db_column_name=>'EXPENSE_REPORT_NUM'
,p_display_order=>38
,p_column_identifier=>'AL'
,p_column_label=>'Expense Report Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5522651393049019)
,p_db_column_name=>'EXPENSE_REPORT_PAID_YN'
,p_display_order=>39
,p_column_identifier=>'AM'
,p_column_label=>'Expense Report Paid Yn'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5523024698049019)
,p_db_column_name=>'EXPENSE_REPORT_TYPE'
,p_display_order=>40
,p_column_identifier=>'AN'
,p_column_label=>'Expense Report Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5523397702049019)
,p_db_column_name=>'EXPENSE_REPORT_ORG_ID'
,p_display_order=>41
,p_column_identifier=>'AO'
,p_column_label=>'Expense Report Org Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5523791181049020)
,p_db_column_name=>'EXPENSE_REPORT_EMP_NUM'
,p_display_order=>42
,p_column_identifier=>'AP'
,p_column_label=>'Expense Report Emp Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5524205212049020)
,p_db_column_name=>'EXPENSE_REPORT_AMOUNT'
,p_display_order=>43
,p_column_identifier=>'AQ'
,p_column_label=>'Expense Report Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(5524996242056934)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'75151'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'EXPENSE_REPORT_NUM:EXPENSE_REPORT_TYPE:EXPENSE_REPORT_AMOUNT:EXPENSE_REPORT_DATE:EXPENSE_REPORT_JUSTIFICATION:GL_ACCOUNT:GL_DATE:PROJECT_NUMBER:TASK:PETTY_CASH_NO:'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5397932789457467)
,p_name=>'P34_PETTY_CASH_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(5506894148049003)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.component_end;
end;
/
