prompt --application/pages/page_00058
begin
--   Manifest
--     PAGE: 00058
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
 p_id=>58
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Expense Reports Tracking Report'
,p_alias=>'EXPENSE-REPORTS-TRACKING-REPORT'
,p_step_title=>'Expense Reports Tracking Report'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210628200845'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(2547245593479912)
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
 p_id=>wwv_flow_api.id(2547889945479912)
,p_plug_name=>'Expense Reports Tracking Report'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8055912915175506)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select EXPENSE_REPORT_ID, EXPENSE_REPORT_NUM, EXPENSE_REPORT_DATE, EXPENSE_REPORT_TYPE',
'    , EXPENSE_REPORT_EMP_NAME, EXPENSE_REPORT_EMP_NUM, ORG_NAME, DEPARTMENT_NAME, SECTOR',
'    , COST_CENTER_CODE, PROJECT_NUMBER, TASK, GL_ACCOUNT, GL_ACCOUNT_NAME, EXPENSE_REPORT_AMOUNT',
'    , EXPENSE_REPORT_APPROVAL_STATUS, EXPENSE_REPORT_JUSTIFICATION, EXPENSE_REPORT_YEAR, LAST_TRACK_TEXT',
'    , LAST_TRACK_DATE, Track_by',
'From (',
'select er.expense_report_id , er.expense_report_num, er.expense_report_date, er.EXPENSE_REPORT_TYPE, er.EXPENSE_REPORT_EMP_NAME',
'    ,er.EXPENSE_REPORT_EMP_NUM, org.org_name, org.department_name',
'        ,org.sector, er.cost_center_code , er.project_number, er.task , er.gl_account , er.gl_account_name, er.expense_report_amount',
'        ,er.expense_report_approval_status , er.expense_report_justification , er.expense_report_year',
'        , (select comment_text',
'            from hrss_expense_reports_tracking x',
'            where last_track = (',
'            select  max(t.last_track) last_track ',
'            from hrss_expense_reports_tracking t',
'            where t.expense_report_id = x.expense_report_id',
'            and t.expense_report_id = er.expense_report_id',
'            GROUP By t.expense_report_id)) Last_track_text',
'        , (select x.updated_date',
'            from hrss_expense_reports_tracking x',
'            where last_track = (',
'            select  max(t.last_track) last_track ',
'            from hrss_expense_reports_tracking t',
'            where t.expense_report_id = x.expense_report_id',
'            and t.expense_report_id = er.expense_report_id',
'            GROUP By t.expense_report_id)) Last_track_Date',
'        , (select x.UPDATED_BY_PERSON_ID',
'            from hrss_expense_reports_tracking x',
'            where last_track = (',
'            select  max(t.last_track) last_track ',
'            from hrss_expense_reports_tracking t',
'            where t.expense_report_id = x.expense_report_id',
'            and t.expense_report_id = er.expense_report_id',
'            GROUP By t.expense_report_id)) Track_by',
'from expense_reports_all_v er , organizations_details_v org',
'where er.EXPENSE_REPORT_ORG_ID = org.org_id)',
'order by LAST_TRACK_DATE ;'))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_page_header=>'Expense Reports Tracking Report'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(2547915499479912)
,p_name=>'Expense Reports Tracking Report'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>35240013735942426
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2548340543479910)
,p_db_column_name=>'EXPENSE_REPORT_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Expense Report Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2548779596479909)
,p_db_column_name=>'EXPENSE_REPORT_NUM'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Expense Report#'
,p_column_link=>'f?p=&APP_ID.:44:&SESSION.::&DEBUG.:44:P44_EXPENSE_REPORT_ID,P44_PAGE_FROM:#EXPENSE_REPORT_ID#,58'
,p_column_linktext=>'#EXPENSE_REPORT_NUM#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2549142441479909)
,p_db_column_name=>'EXPENSE_REPORT_DATE'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2549586169479908)
,p_db_column_name=>'EXPENSE_REPORT_TYPE'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2549983600479908)
,p_db_column_name=>'EXPENSE_REPORT_EMP_NAME'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Employee Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2550310575479907)
,p_db_column_name=>'EXPENSE_REPORT_EMP_NUM'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Employee#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2550791588479907)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Organization'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2551110943479906)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Department '
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2551515104479906)
,p_db_column_name=>'SECTOR'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2551933792479906)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2552303445479905)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2552719609479905)
,p_db_column_name=>'TASK'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2553103806479904)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'GL Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2553559240479904)
,p_db_column_name=>'GL_ACCOUNT_NAME'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'GL Account Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2553976337479904)
,p_db_column_name=>'EXPENSE_REPORT_AMOUNT'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2554352281479903)
,p_db_column_name=>'EXPENSE_REPORT_APPROVAL_STATUS'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2554740520479902)
,p_db_column_name=>'EXPENSE_REPORT_JUSTIFICATION'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2555197239479902)
,p_db_column_name=>'EXPENSE_REPORT_YEAR'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2555570886479902)
,p_db_column_name=>'LAST_TRACK_TEXT'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2555998992479901)
,p_db_column_name=>'LAST_TRACK_DATE'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Comment ON'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2556351952479901)
,p_db_column_name=>'TRACK_BY'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Comment By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(1745094403973772)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(2562833872463375)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'352550'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'EXPENSE_REPORT_NUM:EXPENSE_REPORT_TYPE:EXPENSE_REPORT_EMP_NAME:EXPENSE_REPORT_AMOUNT:LAST_TRACK_TEXT:LAST_TRACK_DATE:TRACK_BY:'
);
wwv_flow_api.component_end;
end;
/
