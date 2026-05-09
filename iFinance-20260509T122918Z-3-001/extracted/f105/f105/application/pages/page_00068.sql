prompt --application/pages/page_00068
begin
--   Manifest
--     PAGE: 00068
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
 p_id=>68
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Projects Cashflow'
,p_alias=>'PROJECTS-CASHFLOW'
,p_step_title=>'Projects Cashflow'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230425090546'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(64423141588911848)
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
 p_id=>wwv_flow_api.id(59235294116520007)
,p_plug_name=>'Sectors Cashflow'
,p_icon_css_classes=>'fa-flag-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(59235156560520006)
,p_plug_name=>'Sectors Cashflow Report'
,p_parent_plug_id=>wwv_flow_api.id(59235294116520007)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'   SECTOR_ID,',
'    accounting_year,',
'    PROJECTS_UTIL.SECTOR_BALANCE(SECTOR_ID , 134 , accounting_year, ''A'') Actual_Opex, ',
'    PROJECTS_UTIL.SECTOR_BALANCE(SECTOR_ID , 135 , accounting_year, ''A'') Actual_Capex, ',
'    PROJECTS_UTIL.SECTOR_BALANCE(SECTOR_ID , 134 , accounting_year, ''E'') Encumberance_Opex, ',
'    PROJECTS_UTIL.SECTOR_BALANCE(SECTOR_ID , 135 , accounting_year, ''E'') Encumberance_Capex, ',
'    PROJECTS_UTIL.SECTOR_BALANCE(SECTOR_ID , 134 , accounting_year, ''B'') Budget_Opex, ',
'    PROJECTS_UTIL.SECTOR_BALANCE(SECTOR_ID , 135 , accounting_year, ''B'') Budget_Capex, ',
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
'WHERE  accounting_year  = :P68_ACCOUNTING_YEAR',
'and SECTOR_ID = nvl(:P68_SECTOR , SECTOR_ID)',
'and status = ''Approved''',
'-- and status in (select * from apex_string.split(:P68_STATUS , '':''))',
'and DP_ITEMS_UTIL.get_cashflow_source_code(source) in (select * from apex_string.split(:P68_SOURCE , '':''))',
'GROUP by ',
'    accounting_year,',
'    SECTOR_ID',
'order by sector_id;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P68_ACCOUNTING_YEAR,P68_SECTOR,P68_SOURCE'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'NEVER'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Sectors Cashflow Report &P68_ACCOUNTING_YEAR.',
'&P68_SECTOR.',
'&P68_COST_CENTER.'))
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Courier'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'14'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#FA0000'
,p_prn_header_font_color=>'#FFF7FF'
,p_prn_header_font_family=>'Courier'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'11'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Courier'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(59235084132520005)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>154048948256664627
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59234982023520004)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1216232005294941)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59234925935520003)
,p_db_column_name=>'ACCOUNTING_YEAR'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Budget Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59234732721520002)
,p_db_column_name=>'JAN'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'01-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59234680368520001)
,p_db_column_name=>'FEB'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'02-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59234552165520000)
,p_db_column_name=>'MAR'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'03-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59234452398519999)
,p_db_column_name=>'APR'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'04-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59234343191519998)
,p_db_column_name=>'MAY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'05-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59234240892519997)
,p_db_column_name=>'JUN'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'06-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59234150120519996)
,p_db_column_name=>'JUL'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'07-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59234053293519995)
,p_db_column_name=>'AUG'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'08-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59233976847519994)
,p_db_column_name=>'SEP'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'09-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59233872912519993)
,p_db_column_name=>'OCT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'10-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59233743002519992)
,p_db_column_name=>'NOV'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'11-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59233668349519991)
,p_db_column_name=>'DEC'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'12-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58964577762211991)
,p_db_column_name=>'ACTUAL_OPEX'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Actual Opex'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58964528236211990)
,p_db_column_name=>'ACTUAL_CAPEX'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Actual Capex'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58964335673211989)
,p_db_column_name=>'ENCUMBERANCE_OPEX'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Encumberance Opex'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58964280617211988)
,p_db_column_name=>'ENCUMBERANCE_CAPEX'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Encumberance Capex'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58964139581211987)
,p_db_column_name=>'BUDGET_OPEX'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Budget Opex'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58964093634211986)
,p_db_column_name=>'BUDGET_CAPEX'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Budget Capex'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(58315905947801300)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1549682'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SECTOR_ID:JAN:FEB:MAR:APR:MAY:JUN:JUL:AUG:SEP:OCT:NOV:DEC:APXWS_CC_001:APXWS_CC_002:APXWS_CC_004:APXWS_CC_003:APXWS_CC_005:BUDGET_OPEX:'
,p_sort_column_1=>'SECTOR_ID'
,p_sort_direction_1=>'ASC'
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
,p_sum_columns_on_break=>'JAN:FEB:MAR:APR:MAY:JUN:JUL:AUG:SEP:OCT:NOV:DEC:APXWS_CC_001:APXWS_CC_004:APXWS_CC_002:APXWS_CC_003:APXWS_CC_005'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(52263823416685200)
,p_report_id=>wwv_flow_api.id(58315905947801300)
,p_db_column_name=>'APXWS_CC_001'
,p_column_identifier=>'C01'
,p_computation_expr=>'C + D + E + F + G + H + I + J + K + L + M + N'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Total Cashflow'
,p_report_label=>'Total Cashflow'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(52263332640685199)
,p_report_id=>wwv_flow_api.id(58315905947801300)
,p_db_column_name=>'APXWS_CC_002'
,p_column_identifier=>'C02'
,p_computation_expr=>'NVL(S,0) + NVL(T,0)'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Budget'
,p_report_label=>'Budget'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(52262970419685199)
,p_report_id=>wwv_flow_api.id(58315905947801300)
,p_db_column_name=>'APXWS_CC_003'
,p_column_identifier=>'C03'
,p_computation_expr=>'NVL(Q , 0) + NVL(R,0)'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Encumerance'
,p_report_label=>'Encumerance'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(52262616310685199)
,p_report_id=>wwv_flow_api.id(58315905947801300)
,p_db_column_name=>'APXWS_CC_004'
,p_column_identifier=>'C04'
,p_computation_expr=>'NVL(P ,0)+ NVL(O,0)'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Actual'
,p_report_label=>'Actual'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(52262171164685199)
,p_report_id=>wwv_flow_api.id(58315905947801300)
,p_db_column_name=>'APXWS_CC_005'
,p_column_identifier=>'C05'
,p_computation_expr=>'( S + T ) - ( Q + R + O + P )'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Fund Available'
,p_report_label=>'Fund Available'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(59233580276519990)
,p_plug_name=>'Search For'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(57296891031282220)
,p_plug_name=>'Search Right'
,p_parent_plug_id=>wwv_flow_api.id(59233580276519990)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(57296736360282219)
,p_plug_name=>'Search Left '
,p_parent_plug_id=>wwv_flow_api.id(59233580276519990)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(59233050964519985)
,p_plug_name=>'Projects Cashflow'
,p_icon_css_classes=>'fa-taxi'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(58967143425212017)
,p_plug_name=>'Projects Cashflow Report'
,p_parent_plug_id=>wwv_flow_api.id(59233050964519985)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    accounting_year,',
'    sector_id,',
'    cost_center,',
'    user_details.get_cost_center_name(cost_center)  cost_center_name,',
'    project,',
'    project_number,',
'    projects_util.project_name(project_number) project_name,',
'    task,',
'    expenditure_type,',
'    Source,',
'    jan,',
'    feb,',
'    mar,',
'    apr,',
'    may,',
'    jun,',
'    jul,',
'    aug,',
'    sep,',
'    oct,',
'    nov,',
'    dec,',
'    PROJECTS_UTIL.EXPENDITURE_BALANCE(project_number ,task,  expenditure_type , :p68_accounting_year , ''B'') Budget,',
'    PROJECTS_UTIL.EXPENDITURE_BALANCE(project_number ,task,  expenditure_type , :p68_accounting_year , ''A'') Actual,',
'    PROJECTS_UTIL.EXPENDITURE_BALANCE(project_number ,task,  expenditure_type , :p68_accounting_year , ''E'') Encumberance,',
'    PROJECTS_UTIL.EXPENDITURE_BALANCE(project_number ,task,  expenditure_type , :p68_accounting_year , ''F'') Fund',
'FROM cashflow_lines_v',
'   -- cashflow_summary_v',
'WHERE',
'        accounting_year = :p68_accounting_year',
' --   AND sector_id = nvl(:p68_sector, sector_id)',
' --   AND cost_center = nvl(:p68_cost_center, cost_center)',
' --   and DP_ITEMS_UTIL.get_cashflow_source_code(source) in (select * from apex_string.split(:P68_SOURCE , '':''))',
'ORDER BY',
'    project_number, task;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P68_ACCOUNTING_YEAR,P68_SECTOR,P68_COST_CENTER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Projects Cashflow Report'
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
 p_id=>wwv_flow_api.id(58967066961212016)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>154316965427972616
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58966959203212015)
,p_db_column_name=>'ACCOUNTING_YEAR'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Accounting Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58966834838212014)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1216232005294941)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58966821121212013)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58965107133211996)
,p_db_column_name=>'COST_CENTER_NAME'
,p_display_order=>40
,p_column_identifier=>'T'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58966684669212012)
,p_db_column_name=>'PROJECT'
,p_display_order=>50
,p_column_identifier=>'D'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58966587702212011)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58965011130211995)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>70
,p_column_identifier=>'U'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58966451963212010)
,p_db_column_name=>'TASK'
,p_display_order=>80
,p_column_identifier=>'F'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58966405267212009)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>90
,p_column_identifier=>'G'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58966236128212008)
,p_db_column_name=>'JAN'
,p_display_order=>100
,p_column_identifier=>'H'
,p_column_label=>'01-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58966213324212007)
,p_db_column_name=>'FEB'
,p_display_order=>110
,p_column_identifier=>'I'
,p_column_label=>'02-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58966103819212006)
,p_db_column_name=>'MAR'
,p_display_order=>120
,p_column_identifier=>'J'
,p_column_label=>'03-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58965975762212005)
,p_db_column_name=>'APR'
,p_display_order=>130
,p_column_identifier=>'K'
,p_column_label=>'04-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58965852266212004)
,p_db_column_name=>'MAY'
,p_display_order=>140
,p_column_identifier=>'L'
,p_column_label=>'05-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58965814202212003)
,p_db_column_name=>'JUN'
,p_display_order=>150
,p_column_identifier=>'M'
,p_column_label=>'06-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58965645478212002)
,p_db_column_name=>'JUL'
,p_display_order=>160
,p_column_identifier=>'N'
,p_column_label=>'07-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58965545358212001)
,p_db_column_name=>'AUG'
,p_display_order=>170
,p_column_identifier=>'O'
,p_column_label=>'08-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58965465079212000)
,p_db_column_name=>'SEP'
,p_display_order=>180
,p_column_identifier=>'P'
,p_column_label=>'09-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58965333837211999)
,p_db_column_name=>'OCT'
,p_display_order=>190
,p_column_identifier=>'Q'
,p_column_label=>'10-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58965325921211998)
,p_db_column_name=>'NOV'
,p_display_order=>200
,p_column_identifier=>'R'
,p_column_label=>'11-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58965142894211997)
,p_db_column_name=>'DEC'
,p_display_order=>210
,p_column_identifier=>'S'
,p_column_label=>'12-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52827315121613195)
,p_db_column_name=>'BUDGET'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52827206645613194)
,p_db_column_name=>'ACTUAL'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Actual'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52827077170613193)
,p_db_column_name=>'ENCUMBERANCE'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Encumberance'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52827010996613192)
,p_db_column_name=>'FUND'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Fund'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52826860780613191)
,p_db_column_name=>'SOURCE'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Source'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(57982285631941211)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1553018'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>100
,p_report_columns=>'PROJECT_NUMBER:TASK:EXPENDITURE_TYPE:COST_CENTER:JAN:FEB:MAR:APR:MAY:JUN:JUL:AUG:SEP:OCT:NOV:DEC:APXWS_CC_001:BUDGET::APXWS_CC_002'
,p_sort_column_1=>'PROJECT_NUMBER'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'TASK'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
,p_sum_columns_on_break=>'JAN:FEB:MAR:APR:MAY:JUN:JUL:DEC:NOV:OCT:AUG:SEP:APXWS_CC_001'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(52180662638036740)
,p_report_id=>wwv_flow_api.id(57982285631941211)
,p_db_column_name=>'APXWS_CC_001'
,p_column_identifier=>'C01'
,p_computation_expr=>'H + I + J + K + L + M + N + O + P + Q + R + S'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Total Cashflow'
,p_report_label=>'Total Cashflow'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(52180263124036740)
,p_report_id=>wwv_flow_api.id(57982285631941211)
,p_db_column_name=>'APXWS_CC_002'
,p_column_identifier=>'C02'
,p_computation_expr=>'( H+ I+ J+ K+ L+ M+ N+ O+ P+ Q+ R+ S) -  V'
,p_column_type=>'NUMBER'
,p_column_label=>'Diff'
,p_report_label=>'Diff'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(59232770344519982)
,p_plug_name=>'Cost Center /Department Cashflow'
,p_icon_css_classes=>'fa-braille'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(58293301094395314)
,p_plug_name=>'Cost Center /Department Cashflow Report'
,p_parent_plug_id=>wwv_flow_api.id(59232770344519982)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'   SECTOR_ID,',
'   COST_CENTER,',
'    accounting_year,',
'    user_details.get_cost_center_name(cost_center)  cost_center_name,',
'    PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER,134, accounting_year , ''B'' ) Budget_Opex,',
'    PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER,135, accounting_year , ''B'' ) Budget_Capex,',
'    ',
'    PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER,134, accounting_year , ''A'' ) Actual_Opex,',
'    PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER,135, accounting_year , ''A'' ) Actual_Capex,',
'    ',
'    PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER,134, accounting_year , ''E'' ) Encumberance_Opex,',
'    PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER,135, accounting_year , ''E'' ) Encumberance_Capex,',
'    ',
'--    PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER,134, accounting_year , ''F'' ) Budget_Opex,',
'--    PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER,135, accounting_year , ''F'' ) Fund_Capex,',
'    ',
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
'FROM cashflow_summary_v',
'WHERE  accounting_year  = :P68_ACCOUNTING_YEAR',
'and SECTOR_ID = nvl(:P68_SECTOR , SECTOR_ID)',
'and cost_center = nvl(:P68_COST_CENTER , cost_center)',
'GROUP by ',
'    accounting_year,',
'    SECTOR_ID,',
'    cost_center',
'order by sector_id, cost_center;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P68_ACCOUNTING_YEAR,P68_SECTOR,P68_COST_CENTER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Cost Center / Department Cashflow &P68_ACCOUNTING_YEAR. Report ',
'&P68_COST_CENTER.'))
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Courier'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'14'
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
 p_id=>wwv_flow_api.id(58293230952395313)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>154990801436789319
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58293070287395312)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1216232005294941)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58291640592395298)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>20
,p_column_identifier=>'O'
,p_column_label=>'Cost Center / Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58292957449395311)
,p_db_column_name=>'ACCOUNTING_YEAR'
,p_display_order=>30
,p_column_identifier=>'B'
,p_column_label=>'Budget Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58292851039395310)
,p_db_column_name=>'JAN'
,p_display_order=>40
,p_column_identifier=>'C'
,p_column_label=>'01-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58292790175395309)
,p_db_column_name=>'FEB'
,p_display_order=>50
,p_column_identifier=>'D'
,p_column_label=>'02-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58292674257395308)
,p_db_column_name=>'MAR'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'03-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58292563208395307)
,p_db_column_name=>'APR'
,p_display_order=>70
,p_column_identifier=>'F'
,p_column_label=>'04-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58292487777395306)
,p_db_column_name=>'MAY'
,p_display_order=>80
,p_column_identifier=>'G'
,p_column_label=>'05-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58292401833395305)
,p_db_column_name=>'JUN'
,p_display_order=>90
,p_column_identifier=>'H'
,p_column_label=>'06-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58292311619395304)
,p_db_column_name=>'JUL'
,p_display_order=>100
,p_column_identifier=>'I'
,p_column_label=>'07-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58292223768395303)
,p_db_column_name=>'AUG'
,p_display_order=>110
,p_column_identifier=>'J'
,p_column_label=>'08-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58292127631395302)
,p_db_column_name=>'SEP'
,p_display_order=>120
,p_column_identifier=>'K'
,p_column_label=>'09-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58291935460395301)
,p_db_column_name=>'OCT'
,p_display_order=>130
,p_column_identifier=>'L'
,p_column_label=>'10-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58291905792395300)
,p_db_column_name=>'NOV'
,p_display_order=>140
,p_column_identifier=>'M'
,p_column_label=>'11-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58291781135395299)
,p_db_column_name=>'DEC'
,p_display_order=>150
,p_column_identifier=>'N'
,p_column_label=>'12-&P68_ACCOUNTING_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(58964754386211993)
,p_db_column_name=>'COST_CENTER_NAME'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(56092474132223013)
,p_db_column_name=>'BUDGET_OPEX'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Budget Opex'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(56092405194223012)
,p_db_column_name=>'BUDGET_CAPEX'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Budget Capex'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(56092286117223011)
,p_db_column_name=>'ACTUAL_OPEX'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Actual Opex'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(56092136644223010)
,p_db_column_name=>'ACTUAL_CAPEX'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Actual Capex'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(56092040972223009)
,p_db_column_name=>'ENCUMBERANCE_OPEX'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Encumberance Opex'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(56092013128223008)
,p_db_column_name=>'ENCUMBERANCE_CAPEX'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Encumberance Capex'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(58284984521377810)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1549991'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SECTOR_ID:COST_CENTER:COST_CENTER_NAME:JAN:FEB:MAR:APR:MAY:JUN:JUL:AUG:SEP:OCT:NOV:DEC:APXWS_CC_001:APXWS_CC_002:BUDGET_CAPEX:BUDGET_OPEX:APXWS_CC_003:APXWS_CC_004:'
,p_sort_column_1=>'SECTOR_ID'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'COST_CENTER'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
,p_sum_columns_on_break=>'JAN:JUN:JUL:AUG:SEP:OCT:NOV:DEC:APXWS_CC_001:FEB:MAR:APR:MAY:BUDGET_OPEX:BUDGET_CAPEX:ACTUAL_OPEX:ACTUAL_CAPEX:ENCUMBERANCE_OPEX:ENCUMBERANCE_CAPEX:APXWS_CC_002:APXWS_CC_003:APXWS_CC_004:APXWS_CC_005'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(52192919657321543)
,p_report_id=>wwv_flow_api.id(58284984521377810)
,p_db_column_name=>'APXWS_CC_001'
,p_column_identifier=>'C01'
,p_computation_expr=>'C + D + E + F + G + H + I + J + K + L + M + N'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Total Cashflow'
,p_report_label=>'Total Cashflow'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(52192443728321543)
,p_report_id=>wwv_flow_api.id(58284984521377810)
,p_db_column_name=>'APXWS_CC_002'
,p_column_identifier=>'C02'
,p_computation_expr=>'NVL(Q,0) + NVL(R,0)'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Budget'
,p_report_label=>'Budget'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(52192063595321542)
,p_report_id=>wwv_flow_api.id(58284984521377810)
,p_db_column_name=>'APXWS_CC_003'
,p_column_identifier=>'C03'
,p_computation_expr=>'NVL(S,0) + NVL(T,0)'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Actual'
,p_report_label=>'Actual'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(52191700465321539)
,p_report_id=>wwv_flow_api.id(58284984521377810)
,p_db_column_name=>'APXWS_CC_004'
,p_column_identifier=>'C04'
,p_computation_expr=>'NVL(U ,0) + NVL(V , 0)'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Encumberance'
,p_report_label=>'Encumberance'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(57297486389282226)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(59233580276519990)
,p_button_name=>'SEARCH'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Search'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-search'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(59233463069519989)
,p_name=>'P68_ACCOUNTING_YEAR'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(57296736360282219)
,p_prompt=>'Accounting Year'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC:2023;2023'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(59232984029519984)
,p_name=>'P68_SECTOR'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(57296736360282219)
,p_prompt=>'Sector'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT distinct user_details.org_name(SECTOR_ID) sector_name, SECTOR_ID',
'FROM cashflow_lines_v',
'where accounting_year = nvl(:P68_ACCOUNTING_YEAR,2023) '))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P68_ACCOUNTING_YEAR'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(59232842417519983)
,p_name=>'P68_COST_CENTER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(57296736360282219)
,p_prompt=>'Cost Center / Department'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT distinct user_details.get_cost_center_name(COST_CENTER)',
'       || ''(''',
'       || COST_CENTER',
'       || '')'' cc_name, COST_CENTER',
'FROM cashflow_lines_v',
'where accounting_year = nvl(:P68_ACCOUNTING_YEAR, accounting_year)',
'and sector_id = nvl(:P68_SECTOR ,sector_id )',
'and cost_center is not null',
'order by 1'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P68_SECTOR,P68_ACCOUNTING_YEAR'
,p_ajax_optimize_refresh=>'N'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(57296990442282221)
,p_name=>'P68_SOURCE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(57296891031282220)
,p_prompt=>'Source'
,p_display_as=>'NATIVE_CHECKBOX'
,p_named_lov=>'CASHFLOW LINES SOURCE'
,p_lov=>'.'||wwv_flow_api.id(63042438900901735)||'.'
,p_lov_cascade_parent_items=>'P68_ACCOUNTING_YEAR'
,p_ajax_optimize_refresh=>'Y'
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'1'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(59233420112519988)
,p_name=>'accounting_year DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(57297486389282226)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(59233259865519987)
,p_event_id=>wwv_flow_api.id(59233420112519988)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(59235156560520006)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58964725266211992)
,p_event_id=>wwv_flow_api.id(59233420112519988)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(58293301094395314)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58964839962211994)
,p_event_id=>wwv_flow_api.id(59233420112519988)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(58967143425212017)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(58967954374212025)
,p_name=>'accounting_year DA_1'
,p_event_sequence=>20
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
,p_display_when_type=>'NEVER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(58967803967212023)
,p_event_id=>wwv_flow_api.id(58967954374212025)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(59235156560520006)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(57297174008282223)
,p_name=>'Year Changed DA'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P68_ACCOUNTING_YEAR'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(57297116186282222)
,p_event_id=>wwv_flow_api.id(57297174008282223)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P68_STATUS'
);
wwv_flow_api.component_end;
end;
/
