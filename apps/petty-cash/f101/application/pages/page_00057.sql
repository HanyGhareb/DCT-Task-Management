prompt --application/pages/page_00057
begin
--   Manifest
--     PAGE: 00057
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
 p_id=>57
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Petty cash Tracking Report'
,p_alias=>'PETTY-CASH-TRACKING-REPORT'
,p_step_title=>'Petty cash Tracking Report'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210630061646'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(2522996810060663)
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
 p_id=>wwv_flow_api.id(2523517075060661)
,p_plug_name=>'Petty cash Tracking Report'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8055912915175506)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PETTY_CASH_ID, PETTY_CASH_NO, PETTY_CASH_DATE, PETTY_CASH_TYPE, EMP_NAME, ORG_NAME, DEPARTMENT_NAME, SECTOR, COST_CENTER_CODE, PROJECT_NUMBER, PROJECT_NAME, TASK, GL_ACCOUNT, AMOUNT, APPROVAL_STATUS, PRIORITY, JUSTIFICATION, LAST_TRACK_DATE, Y'
||'EAR, LAST_TRACK_TEXT',
'from (select pc.PETTY_CASH_ID, pc.PETTY_CASH_NO, pc.PETTY_CASH_DATE, pc.PETTY_CASH_TYPE, pc.EMP_NAME',
'        ,pc.ORG_NAME, pc.DEPARTMENT_NAME',
'        ,pc.SECTOR, pc.COST_CENTER_CODE, pc.PROJECT_NUMBER, pc.PROJECT_NAME, pc.TASK, pc.GL_ACCOUNT, pc.AMOUNT',
'        ,pc.APPROVAL_STATUS, pc.PRIORITY, pc.JUSTIFICATION, pc.year',
'        , (select comment_text',
'            from hrss_petty_cash_tracking x',
'            where last_track = (',
'            select  max(t.last_track) last_track ',
'            from hrss_petty_cash_tracking t',
'            where t.petty_cash_id = x.petty_cash_id',
'            and t.petty_cash_id = pc.petty_cash_id',
'            GROUP By t.petty_cash_id)) Last_track_text',
'        , (select x.updated_date',
'            from hrss_petty_cash_tracking x',
'            where last_track = (',
'            select  max(t.last_track) last_track ',
'            from hrss_petty_cash_tracking t',
'            where t.petty_cash_id = x.petty_cash_id',
'            and t.petty_cash_id = pc.petty_cash_id',
'            GROUP By t.petty_cash_id)) Last_track_Date',
'from petty_cash_all_v pc )',
'order by LAST_TRACK_DATE ,PETTY_CASH_DATE desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Petty cash Tracking Report'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(2523690244060661)
,p_name=>'Petty cash Tracking Report'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>35215788480523175
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2524050851060656)
,p_db_column_name=>'PETTY_CASH_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Petty Cash Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2524426068060656)
,p_db_column_name=>'PETTY_CASH_NO'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Petty Cash#'
,p_column_link=>'f?p=&APP_ID.:41:&SESSION.::&DEBUG.:57:P41_PETTY_CASH_ID,P41_PAGE_FROM:#PETTY_CASH_ID#,57'
,p_column_linktext=>'#PETTY_CASH_NO#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2524892491060655)
,p_db_column_name=>'PETTY_CASH_DATE'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2525258863060655)
,p_db_column_name=>'PETTY_CASH_TYPE'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2525641025060655)
,p_db_column_name=>'EMP_NAME'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Employee Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2526069797060654)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Org Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2526411702060654)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2526876830060654)
,p_db_column_name=>'SECTOR'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2527267230060653)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2527602079060653)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2528090870060653)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2528416916060652)
,p_db_column_name=>'TASK'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2528859073060652)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'GL Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2529272625060652)
,p_db_column_name=>'AMOUNT'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2529621585060651)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2530079596060651)
,p_db_column_name=>'PRIORITY'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2530467363060650)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2530832688060650)
,p_db_column_name=>'YEAR'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2531267649060650)
,p_db_column_name=>'LAST_TRACK_TEXT'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Last update'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2353996877472810)
,p_db_column_name=>'LAST_TRACK_DATE'
,p_display_order=>29
,p_column_identifier=>'T'
,p_column_label=>'Last update on'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(2532494430026204)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'352246'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PETTY_CASH_ID:PETTY_CASH_NO:PETTY_CASH_DATE:PETTY_CASH_TYPE:EMP_NAME:DEPARTMENT_NAME:AMOUNT:LAST_TRACK_TEXT:LAST_TRACK_DATE:'
);
wwv_flow_api.component_end;
end;
/
