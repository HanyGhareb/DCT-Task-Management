prompt --application/pages/page_00083
begin
--   Manifest
--     PAGE: 00083
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
 p_id=>83
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Budget Allocation Plan Scope'
,p_alias=>'BUDGET-ALLOCATION-PLAN-SCOPE'
,p_step_title=>'Budget Allocation Plan Scope'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240118141203'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(62053373380305582)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99766883142410755)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_menu_id=>wwv_flow_api.id(99703488427410717)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(99820961719410781)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(61618839271376166)
,p_plug_name=>'Plan Criteria'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(61618494572376165)
,p_plug_name=>'Sectors'
,p_icon_css_classes=>'fa-number-1-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(61612464988333127)
,p_plug_name=>'Sectors'
,p_parent_plug_id=>wwv_flow_api.id(61618494572376165)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    bas.sector_id,',
'    nvl(bas.approved_budget_ch1,0)  approved_budget_ch1,',
'    nvl(bas.approved_budget_ch2,0)  approved_budget_ch2,',
'    nvl(bas.approved_budget_ch3,0)  approved_budget_ch3,',
'    nvl(bas.approved_budget_ch6,0)  approved_budget_ch6,',
'    (select count(distinct COST_CENTER_CODE)',
'      from  GL_CODE_COMBINATIONS_V ',
'      where SECTOR_ID = bas.sector_id',
'      and status = ''A''',
'      and sysdate between nvl(start_date , sysdate - 10)',
'            and nvl(end_date , sysdate + 10))               cost_centers_count',
', (select count (distinct PROJECT_NUMBER)',
'            from expenditures_v',
'            where cost_center in (select distinct COST_CENTER_CODE',
'                                  from  GL_CODE_COMBINATIONS_V ',
'                                  where SECTOR_ID = bas.sector_id',
'                                  and status = ''A''',
'                                  and sysdate between nvl(start_date , sysdate - 10)',
'                                        and nvl(end_date , sysdate + 10))',
'            and future2 in (select * from apex_string.split(p.future2_used,'':''))) projects_count,             ',
'            ',
'    bas.comments,',
'    bas.scenario,',
'    bas.scenario_desc',
'FROM',
'    budget_allocation_sectors_plans  bas, budget_allocation_plans p',
'WHERE  bas.budget_allocation_plan_id = p.plan_id',
'and     bas.budget_allocation_plan_id = :p83_plan_id',
'order by 1'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P83_PLAN_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Sectors'
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
 p_id=>wwv_flow_api.id(61612417317333126)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>151671615071851506
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61612261717333125)
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
 p_id=>wwv_flow_api.id(61612159277333124)
,p_db_column_name=>'APPROVED_BUDGET_CH1'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Approved Budget Ch1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P83_PLAN_ID,1) = ''Y'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61612084717333123)
,p_db_column_name=>'APPROVED_BUDGET_CH2'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Approved Budget Ch2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P83_PLAN_ID,2) = ''Y'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61611999552333122)
,p_db_column_name=>'APPROVED_BUDGET_CH3'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Approved Budget Ch3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P83_PLAN_ID,3) = ''Y'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61611883419333121)
,p_db_column_name=>'APPROVED_BUDGET_CH6'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Approved Budget Ch6'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P83_PLAN_ID,6) = ''Y'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61611801083333120)
,p_db_column_name=>'COST_CENTERS_COUNT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Cost Centers Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61611699790333119)
,p_db_column_name=>'PROJECTS_COUNT'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Projects Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61611578695333118)
,p_db_column_name=>'COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61611495738333117)
,p_db_column_name=>'SCENARIO'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Scenario'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(70830542814082706)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61611410204333116)
,p_db_column_name=>'SCENARIO_DESC'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Scenario Desc'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(61599486881096295)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1516846'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SECTOR_ID:APPROVED_BUDGET_CH2:APPROVED_BUDGET_CH3:APXWS_CC_001:COST_CENTERS_COUNT:PROJECTS_COUNT:COMMENTS:'
,p_sum_columns_on_break=>'APPROVED_BUDGET_CH2:APPROVED_BUDGET_CH3:APXWS_CC_001'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(61598630920079581)
,p_report_id=>wwv_flow_api.id(61599486881096295)
,p_db_column_name=>'APXWS_CC_001'
,p_column_identifier=>'C01'
,p_computation_expr=>'C + D'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Total Approved'
,p_report_label=>'Total Approved'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(61618101309376165)
,p_plug_name=>'Cost Centers / Departments'
,p_icon_css_classes=>'fa-number-2-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(61611264242333115)
,p_plug_name=>'Cost Centers Report'
,p_parent_plug_id=>wwv_flow_api.id(61618101309376165)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct COST_CENTER_CODE',
'       , user_details.get_cost_center_name(COST_CENTER_CODE) cost_center_name',
'       , (select count(distinct PROJECT_NUMBER)',
'            from expenditures_v',
'            where cost_center = COST_CENTER_CODE',
'            and future2 in (select * from apex_string.split(:P83_FUTURE2,'':''))) projects_count',
'from  GL_CODE_COMBINATIONS_V ',
'where SECTOR_ID in (select distinct sector_id',
'                              from budget_allocation_sectors_plans',
'                             where budget_allocation_plan_id = :P83_PLAN_ID)',
'and status = ''A''',
'and sysdate between nvl(start_date , sysdate - 10)',
'    and nvl(end_date , sysdate + 10)',
'order by 1'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P83_PLAN_ID,P83_FUTURE2'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Cost Centers Report'
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
 p_id=>wwv_flow_api.id(61611149220333114)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>151672883168851518
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61611058791333113)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Cost Center Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61610987443333112)
,p_db_column_name=>'COST_CENTER_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61610889383333111)
,p_db_column_name=>'PROJECTS_COUNT'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Projects Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(61595439828024378)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1516886'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'COST_CENTER_CODE:COST_CENTER_NAME:PROJECTS_COUNT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(61617650843376165)
,p_plug_name=>'Projects'
,p_icon_css_classes=>'fa-number-3-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(61610782949333110)
,p_plug_name=>'Projects Report'
,p_parent_plug_id=>wwv_flow_api.id(61617650843376165)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    project_number,',
'    PROJECTS_UTIL.project_name(project_number)  project_name,',
'    PROJECTS_UTIL.project_code(project_number)  project_code,',
'    task_number,',
'    expenditure_type,',
'    description,',
'    gl_account,',
'    gl_account_name,',
'    task_name,',
'    task_description,',
'    task_end_date,',
'    cost_center,',
'    cost_center_name,',
'    budget_group_code,',
'    activity,',
'    future1,',
'    future2,',
'    future2_name,',
'    user_details.sector_id_by_cc(cost_center, sysdate)  sector_id,',
'    nvl(PROJECTS_UTIL.EXPENDITURE_BALANCE(project_number,task_number,expenditure_type, :P83_BUDGET_YEAR, ''A'' ),0)                 Actual,',
'    nvl(PROJECTS_UTIL.EXPENDITURE_BALANCE(project_number,task_number,expenditure_type, :P83_BUDGET_YEAR, ''E'' ),0)                 Encumbrance,',
'    nvl(PROJECTS_UTIL.EXPENDITURE_BALANCE(project_number,task_number,expenditure_type, :P83_BUDGET_YEAR, ''F'' ),0)                 Fund_available,',
'---',
'    nvl(PROJECTS_UTIL.EXPENDITURE_BALANCE(project_number,task_number,expenditure_type, to_number(:P83_BUDGET_YEAR)-1, ''A'' ),0)                 Previous_Actual,',
'    nvl(PROJECTS_UTIL.EXPENDITURE_BALANCE(project_number,task_number,expenditure_type, to_number(:P83_BUDGET_YEAR)-1, ''E'' ),0)                 Previous_Encumbrance,',
'    nvl(PROJECTS_UTIL.EXPENDITURE_BALANCE(project_number,task_number,expenditure_type, to_number(:P83_BUDGET_YEAR)-1, ''F'' ),0)                 Previous_Fund_available,',
'    nvl(PROJECTS_UTIL.EXPENDITURE_BALANCE(project_number,task_number,expenditure_type, to_number(:P83_BUDGET_YEAR)-1, ''B'' ),0)                 Previous_Budget',
'FROM',
'    expenditures_v',
'WHERE',
'    cost_center IN (',
'        SELECT DISTINCT',
'            cost_center_code',
'        FROM',
'            gl_code_combinations_v',
'        WHERE',
'            sector_id IN (',
'                SELECT DISTINCT',
'                    sector_id',
'                FROM',
'                    budget_allocation_sectors_plans',
'                WHERE',
'                    budget_allocation_plan_id = :p83_plan_id',
'            )',
'            AND status = ''A''',
'            AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)',
'    )',
'    AND future2 IN (',
'        SELECT',
'            *',
'        FROM',
'            apex_string.split(:p83_future2, '':'')',
'    )',
'ORDER BY',
'    project_number,',
'    task_number;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P83_PLAN_ID,P83_FUTURE2,P83_BUDGET_YEAR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Projects Report'
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
 p_id=>wwv_flow_api.id(61610643217333109)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>151673389171851523
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61610570344333108)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61610520796333107)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61610348782333106)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61610248534333105)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61610220660333104)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61610069038333103)
,p_db_column_name=>'GL_ACCOUNT_NAME'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Gl Account Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61609976159333102)
,p_db_column_name=>'TASK_NAME'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Task Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61609857973333101)
,p_db_column_name=>'TASK_DESCRIPTION'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Task Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61609831381333100)
,p_db_column_name=>'TASK_END_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Task End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61609675535333099)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61609539614333098)
,p_db_column_name=>'COST_CENTER_NAME'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61609509670333097)
,p_db_column_name=>'BUDGET_GROUP_CODE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Budget Group Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61609403192333096)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61609279767333095)
,p_db_column_name=>'FUTURE1'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61609174321333094)
,p_db_column_name=>'FUTURE2'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61609113864333093)
,p_db_column_name=>'FUTURE2_NAME'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Future2 Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61609019831333092)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1216232005294941)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61608912816333091)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61608829010333090)
,p_db_column_name=>'PROJECT_CODE'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Project Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61608685410333089)
,p_db_column_name=>'ACTUAL'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'&P83_BUDGET_YEAR. Actual'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61608552615333088)
,p_db_column_name=>'ENCUMBRANCE'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'&P83_BUDGET_YEAR. Encumbrance'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61608498137333087)
,p_db_column_name=>'FUND_AVAILABLE'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'&P83_BUDGET_YEAR. Fund Available'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8505669617715681)
,p_db_column_name=>'PREVIOUS_ACTUAL'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Previous Actual'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8505841694715682)
,p_db_column_name=>'PREVIOUS_ENCUMBRANCE'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Previous Encumbrance'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8505925483715683)
,p_db_column_name=>'PREVIOUS_FUND_AVAILABLE'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Previous Fund Available'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8505991519715684)
,p_db_column_name=>'PREVIOUS_BUDGET'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Previous Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(61584319408890934)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1516998'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:COST_CENTER:GL_ACCOUNT:FUTURE2:SECTOR_ID:ACTUAL:ENCUMBRANCE:FUND_AVAILABLE::PREVIOUS_ACTUAL:PREVIOUS_ENCUMBRANCE:PREVIOUS_FUND_AVAILABLE:PREVIOUS_BUDGET'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(61608312888333085)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(62053373380305582)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:59:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(62053839565305587)
,p_name=>'P83_PLAN_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(61618839271376166)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(62053792243305586)
,p_name=>'P83_PLAN_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(61618839271376166)
,p_prompt=>'Plan Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(62053680388305585)
,p_name=>'P83_CHAPTERS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(61618839271376166)
,p_prompt=>'Chapters'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(62053598797305584)
,p_name=>'P83_FUTURE2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(61618839271376166)
,p_prompt=>'Future2 Used'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(62053447099305583)
,p_name=>'P83_TOTAL_APPROVED'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(61618839271376166)
,p_prompt=>'Total Approved'
,p_post_element_text=>'<p>&nbsp;AED</p>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(61612759145333130)
,p_name=>'P83_SECTORS_COUNT'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(61618839271376166)
,p_prompt=>'Sectors Count'
,p_post_element_text=>'<p>&nbsp;Sectors</p>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(61612668050333129)
,p_name=>'P83_COST_CENTERS_COUNT'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(61618839271376166)
,p_prompt=>'Cost Centers Count'
,p_post_element_text=>'<p>&nbsp;Cost centers</p>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(61612551388333128)
,p_name=>'P83_PROJECTS_COUNT'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(61618839271376166)
,p_prompt=>'Projects Count'
,p_post_element_text=>'<p>&nbsp;Projects</p>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(61608384120333086)
,p_name=>'P83_BUDGET_YEAR'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(61618839271376166)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(61612854870333131)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Plan Criteria Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PLAN_NAME    , decode(APPROVED_BUDGET_CH1_YN,''Y'',''CH1 '') || '' '' || ',
'                      decode(APPROVED_BUDGET_CH2_YN,''Y'',''CH2 '') || '' '' || ',
'                      decode(APPROVED_BUDGET_CH3_YN,''Y'',''CH3 '') || '' '' || ',
'                      decode(APPROVED_BUDGET_CH6_YN,''T'',''CH6 '')              chapters',
'       , FUTURE2_USED ',
'       , trim(to_char(',
'         NVL(APPROVED_BUDGET_CH1 , 0) +',
'         NVL(APPROVED_BUDGET_CH2 , 0) +',
'         NVL(APPROVED_BUDGET_CH3 , 0) +',
'         NVL(APPROVED_BUDGET_CH6 , 0),',
'         ''99,999,999,999,999.99''))                                                       total_approved',
'      , (select count(distinct sector_id)',
'         from budget_allocation_sectors_plans',
'         where budget_allocation_plan_id = :P83_PLAN_ID)            sectors_count   ',
'      , (select count(distinct COST_CENTER_CODE)',
'          from  GL_CODE_COMBINATIONS_V ',
'          where SECTOR_ID in (select distinct sector_id',
'                              from budget_allocation_sectors_plans',
'                             where budget_allocation_plan_id = :P83_PLAN_ID)',
'          and status = ''A''',
'          and sysdate between nvl(start_date , sysdate - 10)',
'                and nvl(end_date , sysdate + 10))               cost_centers_count ',
'      , (select count (distinct PROJECT_NUMBER)',
'            from expenditures_v',
'            where cost_center in (select distinct COST_CENTER_CODE',
'                                  from  GL_CODE_COMBINATIONS_V ',
'                                  where SECTOR_ID in (select distinct sector_id',
'                                                      from budget_allocation_sectors_plans',
'                                                     where budget_allocation_plan_id = :P83_PLAN_ID)',
'                                  and status = ''A''',
'                                  and sysdate between nvl(start_date , sysdate - 10)',
'                                        and nvl(end_date , sysdate + 10))',
'            and future2 in (select * from apex_string.split(budget_allocation_plans.future2_used,'':''))) projects_count',
'      , BUDGET_YEAR',
'into :P83_PLAN_NAME, :P83_CHAPTERS, :P83_FUTURE2, :P83_TOTAL_APPROVED, :P83_SECTORS_COUNT, :P83_COST_CENTERS_COUNT, :P83_PROJECTS_COUNT , :P83_BUDGET_YEAR',
'from budget_allocation_plans',
'where plan_id = :P83_PLAN_ID;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
