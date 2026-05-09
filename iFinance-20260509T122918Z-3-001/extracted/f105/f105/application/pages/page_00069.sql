prompt --application/pages/page_00069
begin
--   Manifest
--     PAGE: 00069
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>69
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Project Cashflow Details'
,p_alias=>'PROJECT-CASHFLOW-DETAILS'
,p_step_title=>'Project Cashflow Details'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230307074134'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(64566232895892504)
,p_plug_name=>'Project Cashflow Full Details'
,p_icon_css_classes=>'fa-table-play'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    line_id,',
'    budget_allocation_plan_id,',
'    accounting_year,',
'    distribution_date,',
'    project,',
'    project_number,',
'    task,',
'    expenditure_type,',
'    nvl(jan,0)  jan,',
'    nvl(feb,0)  feb,',
'    nvl(mar,0)  mar,',
'    nvl(apr,0)  apr,',
'    nvl(may,0)  may,',
'    nvl(jun,0)  jun,',
'    nvl(jul,0)  jul,',
'    nvl(aug,0)  aug,',
'    nvl(sep,0)  sep,',
'    nvl(oct,0)  oct,',
'    nvl(nov,0)  nov,',
'    nvl(dec,0)  dec,',
'    entity_code,',
'    cost_center,',
'    budget_groub_code,',
'    gl_account,',
'    activity_new,',
'    future1,',
'    future2,',
'    line_type,',
'    note,',
'    source,',
'    request_id,',
'    request_id    request_id_h,',
'    allocated_budget,',
'    total_cf_format',
'FROM   cashflow_lines_v',
'where project = :P69_PROJECT',
'-- and accounting_year = :CURRENT_YEAR',
';',
'    '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P69_PROJECT'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Project Cashflow Full Details'
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
 p_id=>wwv_flow_api.id(64566180939892503)
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>148717851449292129
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64566076282892502)
,p_db_column_name=>'BUDGET_ALLOCATION_PLAN_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Budget Allocation Plan Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64566028807892501)
,p_db_column_name=>'ACCOUNTING_YEAR'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Accounting Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64565865908892500)
,p_db_column_name=>'PROJECT'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64565766778892499)
,p_db_column_name=>'TASK'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64565634164892498)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64565571917892497)
,p_db_column_name=>'JAN'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'01-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64565458635892496)
,p_db_column_name=>'FEB'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'02-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64565355759892495)
,p_db_column_name=>'MAR'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'03-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64565318583892494)
,p_db_column_name=>'APR'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'04-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64565182249892493)
,p_db_column_name=>'MAY'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'05-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64565075433892492)
,p_db_column_name=>'JUN'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'06-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64564950698892491)
,p_db_column_name=>'JUL'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'07-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64564928075892490)
,p_db_column_name=>'AUG'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'08-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64564775691892489)
,p_db_column_name=>'SEP'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'09-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64564645277892488)
,p_db_column_name=>'OCT'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'10-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64564574654892487)
,p_db_column_name=>'NOV'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'11-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64564465805892486)
,p_db_column_name=>'DEC'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'12-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64564425362892485)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64564323816892484)
,p_db_column_name=>'LINE_ID'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Line Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64564227422892483)
,p_db_column_name=>'DISTRIBUTION_DATE'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Distribution Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64564119385892482)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64355557799296131)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64355495583296130)
,p_db_column_name=>'BUDGET_GROUB_CODE'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Budget Groub Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64355405689296129)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64355232823296128)
,p_db_column_name=>'ACTIVITY_NEW'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Activity New'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64355203203296127)
,p_db_column_name=>'FUTURE1'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64355056564296126)
,p_db_column_name=>'FUTURE2'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64355000418296125)
,p_db_column_name=>'LINE_TYPE'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Line Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64354902436296124)
,p_db_column_name=>'NOTE'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Note'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64354787407296123)
,p_db_column_name=>'SOURCE'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Source'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64354690869296122)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Request '
,p_column_link=>'f?p=&APP_ID.:90:&SESSION.::&DEBUG.:90:P90_ITEM_ID,P90_PAGE_FROM:#REQUEST_ID_H#,69'
,p_column_linktext=>'#REQUEST_ID#'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(58378763409383394)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64354605836296121)
,p_db_column_name=>'ALLOCATED_BUDGET'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Allocated Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64354470436296120)
,p_db_column_name=>'TOTAL_CF_FORMAT'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Total'
,p_column_type=>'STRING'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64354212139296117)
,p_db_column_name=>'REQUEST_ID_H'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Request Id H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(64345479368294335)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1489386'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PROJECT_NUMBER:TASK:EXPENDITURE_TYPE:DISTRIBUTION_DATE:JAN:FEB:MAR:APR:MAY:JUN:JUL:AUG:SEP:OCT:NOV:DEC:ALLOCATED_BUDGET:SOURCE:REQUEST_ID:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(64397013302815833)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99766883142410755)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(99703488427410717)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(99820961719410781)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(64396421227815833)
,p_plug_name=>'Project Cashflow Details'
,p_icon_css_classes=>'fa-table-search'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    --budget_allocation_plan_id,',
'    accounting_year,',
'    project,',
'    nvl(project_number,''New'')    project_number,',
'    task,',
'    expenditure_type,',
'    sum(nvl(jan,0)) jan,',
'    sum(nvl(feb,0)) feb,',
'    sum(nvl(mar,0)) mar,',
'    sum(nvl(apr,0)) apr,',
'    sum(nvl(may,0)) may,',
'    sum(nvl(jun,0)) jun,',
'    sum(nvl(jul,0)) jul,',
'    sum(nvl(aug,0)) aug,',
'    sum(nvl(sep,0)) sep,',
'    sum(nvl(oct,0)) oct,',
'    sum(nvl(nov,0)) nov,',
'    sum(nvl(dec,0)) dec',
'FROM cashflow_lines_v',
'where project = :P69_PROJECT',
'-- and accounting_year = :CURRENT_YEAR',
'GROUP by ',
'    --budget_allocation_plan_id,',
'    accounting_year,',
'    project,',
'    project_number,',
'    task,',
'    expenditure_type',
'order by task',
'    ;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P69_PROJECT'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Project Cashflow Details'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(64396318087815833)
,p_name=>'Project Cashflow Details'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>148887714301368799
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64395525236815831)
,p_db_column_name=>'ACCOUNTING_YEAR'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Accounting Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64566705194892508)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>12
,p_column_identifier=>'R'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64395057417815831)
,p_db_column_name=>'PROJECT'
,p_display_order=>22
,p_column_identifier=>'C'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64394677819815831)
,p_db_column_name=>'TASK'
,p_display_order=>32
,p_column_identifier=>'D'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64394303974815831)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>42
,p_column_identifier=>'E'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64393843133815831)
,p_db_column_name=>'JAN'
,p_display_order=>52
,p_column_identifier=>'F'
,p_column_label=>'01-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64393466044815830)
,p_db_column_name=>'FEB'
,p_display_order=>62
,p_column_identifier=>'G'
,p_column_label=>'02-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64393053090815830)
,p_db_column_name=>'MAR'
,p_display_order=>72
,p_column_identifier=>'H'
,p_column_label=>'03-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64392685842815830)
,p_db_column_name=>'APR'
,p_display_order=>82
,p_column_identifier=>'I'
,p_column_label=>'04-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64392240219815830)
,p_db_column_name=>'MAY'
,p_display_order=>92
,p_column_identifier=>'J'
,p_column_label=>'05-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64391888270815830)
,p_db_column_name=>'JUN'
,p_display_order=>102
,p_column_identifier=>'K'
,p_column_label=>'06-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64391529518815829)
,p_db_column_name=>'JUL'
,p_display_order=>112
,p_column_identifier=>'L'
,p_column_label=>'07-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64391095229815829)
,p_db_column_name=>'AUG'
,p_display_order=>122
,p_column_identifier=>'M'
,p_column_label=>'08-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64390691286815829)
,p_db_column_name=>'SEP'
,p_display_order=>132
,p_column_identifier=>'N'
,p_column_label=>'09-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64390250266815829)
,p_db_column_name=>'OCT'
,p_display_order=>142
,p_column_identifier=>'O'
,p_column_label=>'10-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64389923406815829)
,p_db_column_name=>'NOV'
,p_display_order=>152
,p_column_identifier=>'P'
,p_column_label=>'11-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64389440016815828)
,p_db_column_name=>'DEC'
,p_display_order=>162
,p_column_identifier=>'Q'
,p_column_label=>'12-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(64383711808794796)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1489004'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PROJECT_NUMBER:TASK:EXPENDITURE_TYPE:JAN:FEB:MAR:APR:MAY:JUN:JUL:AUG:SEP:OCT:NOV:DEC:APXWS_CC_001'
,p_sum_columns_on_break=>'APXWS_CC_001'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(64336893250210674)
,p_report_id=>wwv_flow_api.id(64383711808794796)
,p_db_column_name=>'APXWS_CC_001'
,p_column_identifier=>'C01'
,p_computation_expr=>'F + G + H + I + J + K + L + M + N + O + P + Q'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Total'
,p_report_label=>'Total'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(64354244228296118)
,p_plug_name=>'Cashflow Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64353229411296107)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(64397013302815833)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:68:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64566460308892506)
,p_name=>'P69_PROJECT'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(64397013302815833)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64354358932296119)
,p_name=>'P69_PROJECT_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(64354244228296118)
,p_prompt=>'Project Name'
,p_source=>':P69_PROJECT'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64354112300296116)
,p_name=>'P69_SHOW'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(64354244228296118)
,p_item_default=>'N'
,p_prompt=>'Show / Hide Details'
,p_display_as=>'NATIVE_YES_NO'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(61161981400129119)
,p_name=>'P69_PROJECT_NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(64354244228296118)
,p_prompt=>'Project Number'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(64354018521296115)
,p_name=>'Show DA'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P69_SHOW'
,p_condition_element=>'P69_SHOW'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'N'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64353921473296114)
,p_event_id=>wwv_flow_api.id(64354018521296115)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(64396421227815833)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64353587104296111)
,p_event_id=>wwv_flow_api.id(64354018521296115)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(64566232895892504)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64353805829296113)
,p_event_id=>wwv_flow_api.id(64354018521296115)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(64566232895892504)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64353716340296112)
,p_event_id=>wwv_flow_api.id(64354018521296115)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(64396421227815833)
);
wwv_flow_api.component_end;
end;
/
