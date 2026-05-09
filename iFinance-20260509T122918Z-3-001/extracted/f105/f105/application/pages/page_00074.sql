prompt --application/pages/page_00074
begin
--   Manifest
--     PAGE: 00074
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
 p_id=>74
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Project Budget Allocation Plan Details'
,p_alias=>'PROJECT-BUDGET-ALLOCATION-PLAN-DETAILS'
,p_step_title=>'Project Budget Allocation Plan Details'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230213054857'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(232890886141527813)
,p_plug_name=>'Allocation Plan Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(233560784102234872)
,p_plug_name=>'Project Approved Budget'
,p_parent_plug_id=>wwv_flow_api.id(232890886141527813)
,p_icon_css_classes=>'fa-money'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent9:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(233560955797234873)
,p_plug_name=>'Project Allocated Budget'
,p_parent_plug_id=>wwv_flow_api.id(232890886141527813)
,p_icon_css_classes=>'fa-cart-check'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent5:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(233545125334189536)
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
 p_id=>wwv_flow_api.id(233545696732189537)
,p_plug_name=>'Projects Budget Allocation Plan Details IR'
,p_icon_css_classes=>'fa-money'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'  SELECT',
'    id,',
'    budget_allocation_plan_id,',
'    project_number,',
'    DP_ITEMS_UTIL.get_project_name(project_number) project_name,',
'    task_number,',
'    expenditure_type,',
'    entity_code,',
'    cost_center,',
'    budget_groub_code,',
'    gl_account,',
'    activity,',
'    future1,',
'    future2,',
'    NVL(APPROVED_BUDGET_CH1,0)    APPROVED_BUDGET_CH1,',
'    NVL(APPROVED_BUDGET_CH2,0)    APPROVED_BUDGET_CH2,',
'    NVL(APPROVED_BUDGET_CH3,0)    APPROVED_BUDGET_CH3,',
'    NVL(APPROVED_BUDGET_CH6,0)    APPROVED_BUDGET_CH6,',
'    sector_id,',
'    scenario,',
'    scenario_desc,',
'    status,',
'    comments,',
'    created_by,',
'    created_on,',
'    updated_by,',
'    updated_on',
'FROM   budget_allocation_projects_plans',
'where  BUDGET_ALLOCATION_PLAN_ID = :P74_PLAN_ID',
'  AND  SECTOR_ID = :P74_SECTOR_ID',
'  AND  cost_center = :P74_COST_CENTER',
'ORDER BY   project_number, task_number,  expenditure_type;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P74_PLAN_ID,P74_SCENARIO,P74_COST_CENTER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Sector Budget Allocation Plan Details IR'
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
 p_id=>wwv_flow_api.id(233545839710189537)
,p_name=>'Sector Budget Allocation Plan Details'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>446829872099374169
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63603319335149331)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63602896253149331)
,p_db_column_name=>'BUDGET_ALLOCATION_PLAN_ID'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Budget Allocation Plan Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63602530196149331)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Sector Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63602052043149331)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(71087570950221411)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63601684824149331)
,p_db_column_name=>'APPROVED_BUDGET_CH1'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Approved Budget Ch1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63601326565149330)
,p_db_column_name=>'APPROVED_BUDGET_CH2'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Approved Budget Ch2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63600932065149330)
,p_db_column_name=>'APPROVED_BUDGET_CH3'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Approved Budget Ch3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63600446240149330)
,p_db_column_name=>'APPROVED_BUDGET_CH6'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Approved Budget Ch6'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63600079021149330)
,p_db_column_name=>'STATUS'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63599707873149330)
,p_db_column_name=>'COMMENTS'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63599260933149329)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63598856361149329)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63598462196149329)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63598049234149329)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63597696815149329)
,p_db_column_name=>'SCENARIO'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Scenario'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(70830542814082706)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63597291284149328)
,p_db_column_name=>'SCENARIO_DESC'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Scenario Desc'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63606882095149337)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>26
,p_column_identifier=>'Q'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63606491899149337)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>36
,p_column_identifier=>'R'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63606129694149337)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>46
,p_column_identifier=>'S'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63605658391149337)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>56
,p_column_identifier=>'T'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63605299051149336)
,p_db_column_name=>'BUDGET_GROUB_CODE'
,p_display_order=>66
,p_column_identifier=>'U'
,p_column_label=>'Budget Groub Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63604874556149336)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>76
,p_column_identifier=>'V'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63604463438149332)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>86
,p_column_identifier=>'W'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63604077000149332)
,p_db_column_name=>'FUTURE1'
,p_display_order=>96
,p_column_identifier=>'X'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63603680174149332)
,p_db_column_name=>'FUTURE2'
,p_display_order=>106
,p_column_identifier=>'Y'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63596928958149328)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>116
,p_column_identifier=>'Z'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(233552760680192889)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1496875'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PROJECT_NUMBER:PROJECT_NAME:TASK_NUMBER:EXPENDITURE_TYPE:APPROVED_BUDGET_CH1:APPROVED_BUDGET_CH2:APPROVED_BUDGET_CH3:APPROVED_BUDGET_CH6:APXWS_CC_001:'
,p_sum_columns_on_break=>'APPROVED_BUDGET_CH1:APPROVED_BUDGET_CH2:APPROVED_BUDGET_CH3:APPROVED_BUDGET_CH6:APXWS_CC_001'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(63596061928149327)
,p_report_id=>wwv_flow_api.id(233552760680192889)
,p_db_column_name=>'APXWS_CC_001'
,p_column_identifier=>'C01'
,p_computation_expr=>'E + F + G + H'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Total'
,p_report_label=>'Total'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(233561457670234879)
,p_plug_name=>'Projects Budget Allocation Plan Details IG'
,p_icon_css_classes=>'fa-money'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'BUDGET_ALLOCATION_PROJECTS_PLANS'
,p_query_where=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BUDGET_ALLOCATION_PLAN_ID = :P67_PLAN_ID',
'  AND  SECTOR_ID = :P67_SECTOR_ID',
'  AND  cost_center = :P67_COST_CENTER'))
,p_query_order_by=>'project_number,  task_number,   expenditure_type'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IG'
,p_ajax_items_to_submit=>'P74_PLAN_ID,P74_SCENARIO,P74_COST_CENTER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'NEVER'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Sector Budget Allocation Plan Details IG'
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
,p_plug_comment=>'13-Jan-2023: disables'
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(84953844102701405)
,p_name=>'PROJECT_NUMBER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PROJECT_NUMBER'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Project Number'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>190
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>48
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(84953891779701406)
,p_name=>'TASK_NUMBER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TASK_NUMBER'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Task Number'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>200
,p_value_alignment=>'LEFT'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_is_required=>false
,p_max_length=>400
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(84954057117701407)
,p_name=>'EXPENDITURE_TYPE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'EXPENDITURE_TYPE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Expenditure Type'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>210
,p_value_alignment=>'LEFT'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_is_required=>false
,p_max_length=>1020
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(84954096179701408)
,p_name=>'ENTITY_CODE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ENTITY_CODE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Entity Code'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>220
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>3
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(84954222750701409)
,p_name=>'BUDGET_GROUB_CODE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET_GROUB_CODE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Budget Groub Code'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>230
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>1
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(85103220376142760)
,p_name=>'GL_ACCOUNT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'GL_ACCOUNT'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Gl Account'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>240
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>6
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(85103348873142761)
,p_name=>'ACTIVITY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ACTIVITY'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Activity'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>250
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>6
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(85103423809142762)
,p_name=>'FUTURE1'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'FUTURE1'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Future1'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>260
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>6
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(85103505006142763)
,p_name=>'FUTURE2'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'FUTURE2'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Future2'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>270
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>6
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(233563387872234898)
,p_name=>'ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>true
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>30
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>true
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>true
,p_include_in_export=>false
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(233563513909234899)
,p_name=>'BUDGET_ALLOCATION_PLAN_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET_ALLOCATION_PLAN_ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>40
,p_attribute_01=>'Y'
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(233563576796234900)
,p_name=>'SECTOR_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SECTOR_ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>50
,p_attribute_01=>'Y'
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(233563700303234901)
,p_name=>'COST_CENTER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COST_CENTER'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Cost Center'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>60
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>7
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(233563785054234902)
,p_name=>'APPROVED_BUDGET_CH1'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'APPROVED_BUDGET_CH1'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Approved Budget Ch1'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>70
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(233563907322234903)
,p_name=>'APPROVED_BUDGET_CH2'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'APPROVED_BUDGET_CH2'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Approved Budget Ch2'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>80
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(233564020543234904)
,p_name=>'APPROVED_BUDGET_CH3'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'APPROVED_BUDGET_CH3'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Approved Budget Ch3'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>90
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(233564129822234905)
,p_name=>'APPROVED_BUDGET_CH6'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'APPROVED_BUDGET_CH6'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Approved Budget Ch6'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>100
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(233564232195234906)
,p_name=>'STATUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'STATUS'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Status'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>110
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>50
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(233564302770234907)
,p_name=>'COMMENTS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COMMENTS'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Comments'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>120
,p_value_alignment=>'LEFT'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_is_required=>false
,p_max_length=>4000
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(233564406019234908)
,p_name=>'CREATED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATED_BY'
,p_data_type=>'NUMBER'
,p_is_query_only=>true
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Created By'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>130
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(233564468384234909)
,p_name=>'CREATED_ON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATED_ON'
,p_data_type=>'TIMESTAMP'
,p_is_query_only=>true
,p_item_type=>'NATIVE_DATE_PICKER'
,p_heading=>'Created On'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>140
,p_value_alignment=>'CENTER'
,p_attribute_04=>'button'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(233564599789234910)
,p_name=>'UPDATED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED_BY'
,p_data_type=>'NUMBER'
,p_is_query_only=>true
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Updated By'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>150
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(233564666701234911)
,p_name=>'UPDATED_ON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED_ON'
,p_data_type=>'TIMESTAMP'
,p_is_query_only=>true
,p_item_type=>'NATIVE_DATE_PICKER'
,p_heading=>'Updated On'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>160
,p_value_alignment=>'CENTER'
,p_attribute_04=>'button'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_include_in_export=>true
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
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(233564776486234912)
,p_name=>'SCENARIO'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SCENARIO'
,p_data_type=>'NUMBER'
,p_is_query_only=>true
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Scenario'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>170
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(233564886504234913)
,p_name=>'SCENARIO_DESC'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SCENARIO_DESC'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>180
,p_attribute_01=>'Y'
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(233577830730349264)
,p_name=>'APEX$ROW_ACTION'
,p_item_type=>'NATIVE_ROW_ACTION'
,p_display_sequence=>20
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(233577940056349265)
,p_name=>'APEX$ROW_SELECTOR'
,p_item_type=>'NATIVE_ROW_SELECTOR'
,p_display_sequence=>10
,p_attribute_01=>'Y'
,p_attribute_02=>'Y'
,p_attribute_03=>'N'
);
wwv_flow_api.create_interactive_grid(
 p_id=>wwv_flow_api.id(233563307693234897)
,p_internal_uid=>446847340082419529
,p_is_editable=>true
,p_edit_operations=>'u:d'
,p_lost_update_check_type=>'VALUES'
,p_submit_checked_rows=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>false
,p_pagination_type=>'SCROLL'
,p_show_total_row_count=>true
,p_show_toolbar=>true
,p_toolbar_buttons=>'ACTIONS_MENU:RESET:SAVE'
,p_enable_save_public_report=>false
,p_enable_subscriptions=>true
,p_enable_flashback=>true
,p_define_chart_view=>true
,p_enable_download=>true
,p_enable_mail_download=>true
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
);
wwv_flow_api.create_ig_report(
 p_id=>wwv_flow_api.id(233583738480351514)
,p_interactive_grid_id=>wwv_flow_api.id(233563307693234897)
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>false
);
wwv_flow_api.create_ig_report_view(
 p_id=>wwv_flow_api.id(233583762480351515)
,p_report_id=>wwv_flow_api.id(233583738480351514)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(85109258992151442)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_display_seq=>5
,p_column_id=>wwv_flow_api.id(84953844102701405)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>110.703
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(85109691630151443)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_display_seq=>5
,p_column_id=>wwv_flow_api.id(84953891779701406)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(85110229124151444)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_display_seq=>7
,p_column_id=>wwv_flow_api.id(84954057117701407)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>189.699
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(85110761285151446)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_display_seq=>21
,p_column_id=>wwv_flow_api.id(84954096179701408)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(85111276894151447)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_display_seq=>22
,p_column_id=>wwv_flow_api.id(84954222750701409)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(85111724847151448)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_display_seq=>23
,p_column_id=>wwv_flow_api.id(85103220376142760)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(85112273820151450)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_display_seq=>24
,p_column_id=>wwv_flow_api.id(85103348873142761)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(85112722030151451)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_display_seq=>25
,p_column_id=>wwv_flow_api.id(85103423809142762)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(85113252738151452)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_display_seq=>9
,p_column_id=>wwv_flow_api.id(85103505006142763)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>77.71100000000001
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(233584280847351518)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_display_seq=>1
,p_column_id=>wwv_flow_api.id(233563387872234898)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(233584806190351521)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_display_seq=>2
,p_column_id=>wwv_flow_api.id(233563513909234899)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(233585347544351523)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_display_seq=>3
,p_column_id=>wwv_flow_api.id(233563576796234900)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(233585786887351525)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_display_seq=>8
,p_column_id=>wwv_flow_api.id(233563700303234901)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>97.71100000000001
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(233586295656351526)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_display_seq=>9
,p_column_id=>wwv_flow_api.id(233563785054234902)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(233586780719351528)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_display_seq=>10
,p_column_id=>wwv_flow_api.id(233563907322234903)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(233587310824351529)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_display_seq=>12
,p_column_id=>wwv_flow_api.id(233564020543234904)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>167.715
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(233587821072351530)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_display_seq=>12
,p_column_id=>wwv_flow_api.id(233564129822234905)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(233588280841351532)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_display_seq=>13
,p_column_id=>wwv_flow_api.id(233564232195234906)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(233588775250351533)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_display_seq=>14
,p_column_id=>wwv_flow_api.id(233564302770234907)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(233589283580351534)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_display_seq=>15
,p_column_id=>wwv_flow_api.id(233564406019234908)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(233589855840351536)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_display_seq=>16
,p_column_id=>wwv_flow_api.id(233564468384234909)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(233590275051351537)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_display_seq=>18
,p_column_id=>wwv_flow_api.id(233564599789234910)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(233590825082351539)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_display_seq=>19
,p_column_id=>wwv_flow_api.id(233564666701234911)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(233591348863351540)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_display_seq=>20
,p_column_id=>wwv_flow_api.id(233564776486234912)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(233591800833351541)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_display_seq=>16
,p_column_id=>wwv_flow_api.id(233564886504234913)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(233592291532351543)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_display_seq=>0
,p_column_id=>wwv_flow_api.id(233577830730349264)
,p_is_visible=>true
,p_is_frozen=>true
);
wwv_flow_api.create_ig_report_aggregate(
 p_id=>wwv_flow_api.id(85023090583650672)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_function=>'SUM'
,p_column_id=>wwv_flow_api.id(233563785054234902)
,p_show_grand_total=>false
,p_is_enabled=>true
);
wwv_flow_api.create_ig_report_aggregate(
 p_id=>wwv_flow_api.id(85023167335652735)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_function=>'SUM'
,p_column_id=>wwv_flow_api.id(233563907322234903)
,p_show_grand_total=>true
,p_is_enabled=>true
);
wwv_flow_api.create_ig_report_aggregate(
 p_id=>wwv_flow_api.id(85023264665652735)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_function=>'SUM'
,p_column_id=>wwv_flow_api.id(233564020543234904)
,p_show_grand_total=>true
,p_is_enabled=>true
);
wwv_flow_api.create_ig_report_aggregate(
 p_id=>wwv_flow_api.id(85023393035652735)
,p_view_id=>wwv_flow_api.id(233583762480351515)
,p_function=>'SUM'
,p_column_id=>wwv_flow_api.id(233564129822234905)
,p_show_grand_total=>true
,p_is_enabled=>true
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(63611217544149340)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(233545125334189536)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:66:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(63610009786149339)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(233545125334189536)
,p_button_name=>'Allocate'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Allocate'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-fit-to-size'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(63610352584149339)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(233545125334189536)
,p_button_name=>'GET_PROJECTS'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Update Projects Details'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-bolt'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(63610829470149339)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(233545125334189536)
,p_button_name=>'Submit_PROJECTS_Planners'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Submit to Approve'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P74_STATUS'
,p_button_condition2=>'Draft'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(63609550723149339)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(233545125334189536)
,p_button_name=>'Return'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Return'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P74_STATUS'
,p_button_condition2=>'Active'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(63569788546149306)
,p_branch_name=>'Go to Submit to Projects Planners 72'
,p_branch_action=>'f?p=&APP_ID.:72:&SESSION.::&DEBUG.:72:P72_BUDGET_ALLOCATION_PLAN_ID,P72_PLAN_NAME,P72_COST_CENTER,P72_SECTOR_ID:&P74_PLAN_ID.,&P74_PLAN_ID.,&P74_COST_CENTER.,&P74_SECTOR_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(63610829470149339)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63693324140492919)
,p_name=>'P74_PROJECT'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(233545125334189536)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63609228649149339)
,p_name=>'P74_PLAN_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(233545125334189536)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63608799681149338)
,p_name=>'P74_SECTOR_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(233545125334189536)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63608359113149338)
,p_name=>'P74_COST_CENTER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(233545125334189536)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63607932908149338)
,p_name=>'P74_SCENARIO'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(233545125334189536)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63607577549149338)
,p_name=>'P74_EDIT'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(233545125334189536)
,p_item_default=>'N'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63595041185149326)
,p_name=>'P74_TOTAL_APPROVED_BUDGET_CH1'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(233560784102234872)
,p_prompt=>'Chapter 1'
,p_post_element_text=>'<p>&nbsp;<strong>AED</strong></p>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63594722984149326)
,p_name=>'P74_TOTAL_APPROVED_BUDGET_CH2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(233560784102234872)
,p_prompt=>'Chapter 2'
,p_post_element_text=>'<p>&nbsp;<strong>AED</strong></p>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63594281789149325)
,p_name=>'P74_TOTAL_APPROVED_BUDGET_CH3'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(233560784102234872)
,p_prompt=>'Chapter 3'
,p_post_element_text=>'<p>&nbsp;<strong>AED</strong></p>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63593929060149325)
,p_name=>'P74_TOTAL_APPROVED_BUDGET_CH6'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(233560784102234872)
,p_prompt=>'Chapter 6'
,p_post_element_text=>'<p>&nbsp;<strong>AED</strong></p>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63593181040149325)
,p_name=>'P74_TOTAL_ALLOCATED_BUDGET_CH1'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(233560955797234873)
,p_prompt=>'Chapter 1'
,p_post_element_text=>'<p>&nbsp;<strong>AED</strong></p>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63592761184149325)
,p_name=>'P74_STATUS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(233560955797234873)
,p_prompt=>'Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63592372984149324)
,p_name=>'P74_TOTAL_ALLOCATED_BUDGET_CH2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(233560955797234873)
,p_prompt=>'Chapter 2'
,p_post_element_text=>'<p>&nbsp;<strong>AED</strong></p>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63591938629149324)
,p_name=>'P74_TOTAL_ALLOCATED_BUDGET_CH3'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(233560955797234873)
,p_prompt=>'Chapter 3'
,p_post_element_text=>'<p>&nbsp;<strong>AED</strong></p>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63591536392149324)
,p_name=>'P74_TOTAL_ALLOCATED_BUDGET_CH6'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(233560955797234873)
,p_prompt=>'Chapter 6'
,p_post_element_text=>'<p>&nbsp;<strong>AED</strong></p>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63578072916149310)
,p_name=>'Allocate DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(63610009786149339)
,p_condition_element=>'P74_EDIT'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'N'
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63577610256149310)
,p_event_id=>wwv_flow_api.id(63578072916149310)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(233545696732189537)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63575548992149308)
,p_event_id=>wwv_flow_api.id(63578072916149310)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(233561457670234879)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63577108492149309)
,p_event_id=>wwv_flow_api.id(63578072916149310)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(233545696732189537)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63576033092149309)
,p_event_id=>wwv_flow_api.id(63578072916149310)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(233561457670234879)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63575111116149308)
,p_event_id=>wwv_flow_api.id(63578072916149310)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P74_EDIT'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63574629524149308)
,p_event_id=>wwv_flow_api.id(63578072916149310)
,p_event_result=>'FALSE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P74_EDIT'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'N'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63574101801149308)
,p_event_id=>wwv_flow_api.id(63578072916149310)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(233545696732189537)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63573588908149308)
,p_event_id=>wwv_flow_api.id(63578072916149310)
,p_event_result=>'FALSE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(233545696732189537)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63576574981149309)
,p_event_id=>wwv_flow_api.id(63578072916149310)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P74_TOTAL_APPROVED_BUDGET_CH1 := trim(to_char(budget_allocation_pkg.GET_APPROVED_BUDGET_BY_SEC_CH(:P74_PLAN_ID, 1, :P74_SECTOR_ID),''99,999,999,999.99''));',
':P74_TOTAL_APPROVED_BUDGET_CH2 := trim(to_char(budget_allocation_pkg.GET_APPROVED_BUDGET_BY_SEC_CH(:P74_PLAN_ID, 2, :P74_SECTOR_ID),''99,999,999,999.99''));',
':P74_TOTAL_APPROVED_BUDGET_CH3 := trim(to_char(budget_allocation_pkg.GET_APPROVED_BUDGET_BY_SEC_CH(:P74_PLAN_ID, 3, :P74_SECTOR_ID),''99,999,999,999.99''));',
':P74_TOTAL_APPROVED_BUDGET_CH6 := trim(to_char(budget_allocation_pkg.GET_APPROVED_BUDGET_BY_SEC_CH(:P74_PLAN_ID, 6, :P74_SECTOR_ID),''99,999,999,999.99''));',
'',
'-- ',
':P74_TOTAL_ALLOCATED_BUDGET_CH1 := trim(to_char(budget_allocation_pkg.get_allocated_budget_by_sec_ch(:P74_PLAN_ID, 1, :P74_SECTOR_ID),''99,999,999,999.99''));',
':P74_TOTAL_ALLOCATED_BUDGET_CH2 := trim(to_char(budget_allocation_pkg.get_allocated_budget_by_sec_ch(:P74_PLAN_ID, 2, :P74_SECTOR_ID),''99,999,999,999.99''));',
':P74_TOTAL_ALLOCATED_BUDGET_CH3 := trim(to_char(budget_allocation_pkg.get_allocated_budget_by_sec_ch(:P74_PLAN_ID, 3, :P74_SECTOR_ID),''99,999,999,999.99''));',
':P74_TOTAL_ALLOCATED_BUDGET_CH6 := trim(to_char(budget_allocation_pkg.get_allocated_budget_by_sec_ch(:P74_PLAN_ID, 6, :P74_SECTOR_ID),''99,999,999,999.99''));',
''))
,p_attribute_02=>'P74_TOTAL_APPROVED_BUDGET_CH1,P74_TOTAL_ALLOCATED_BUDGET_CH1,P74_TOTAL_ALLOCATED_BUDGET_CH2,P74_TOTAL_APPROVED_BUDGET_CH2,P74_TOTAL_ALLOCATED_BUDGET_CH3,P74_TOTAL_APPROVED_BUDGET_CH3,P74_TOTAL_ALLOCATED_BUDGET_CH6,P74_TOTAL_APPROVED_BUDGET_CH6'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63573147421149307)
,p_name=>'Get Project Details DA'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(63610352584149339)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
,p_display_when_type=>'NEVER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63572690258149307)
,p_event_id=>wwv_flow_api.id(63573147421149307)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Get Projects details for your department/Cost center?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63572145592149307)
,p_event_id=>wwv_flow_api.id(63573147421149307)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'INSERT INTO budget_allocation_projects_plans (',
'                                                budget_allocation_plan_id,',
'                                                project_number,',
'                                                task_number,',
'                                                expenditure_type,',
'                                                entity_code,',
'                                                cost_center,',
'                                                budget_groub_code,',
'                                                gl_account,',
'                                                activity,',
'                                                future1,',
'                                                future2,',
'                                                sector_id,',
'                                                scenario,',
'                                                approved_budget_ch1,',
'                                                approved_budget_ch2,',
'                                                approved_budget_ch3,',
'                                                approved_budget_ch6,',
'                                                status,',
'                                                comments',
') select ',
'        :P74_PLAN_ID',
'       , PROJECT_NUMBER',
'       , TASK_NUMBER',
'       , EXPENDITURE_TYPE',
'       , ''451''',
'       , :P74_COST_CENTER',
'       , BUDGET_GROUP_CODE',
'       , GL_ACCOUNT',
'       , ACTIVITY',
'       , FUTURE1',
'       , FUTURE2 ',
'       , :P74_SECTOR_ID',
'       , :P74_SCENARIO',
'       , 0',
'       , 0',
'       , 0',
'       , 0',
'       , ''Draft''',
'       , null',
'    FROM',
'        (select  distinct pb.PROJECT_NUMBER',
'               , pb.TASK_NUMBER',
'               , pb.EXPENDITURE_TYPE',
'               , t.budget_group_code',
'               , (select distinct e.gl_account',
'                  from expenditure e',
'                  where e.project_number = pb.project_number',
'                  and   e.task_number = pb.task_number',
'                  and   e.expenditure_type = pb.expenditure_type) GL_ACCOUNT',
'               , t.activity',
'               , t.future1',
'               , t.future2   ',
'        from project_balances pb, task t ',
'        where pb.PROJECT_NUMBER = t.project_number ',
'        and pb.cost_center = :P74_COST_CENTER);'))
,p_attribute_02=>'P74_PLAN_ID,P74_SECTOR_ID,P74_COST_CENTER,P74_SCENARIO'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63571195837149306)
,p_event_id=>wwv_flow_api.id(63573147421149307)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Updated Successfully.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63571646555149306)
,p_event_id=>wwv_flow_api.id(63573147421149307)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63570757962149306)
,p_name=>'Return DA'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(63609550723149339)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63570264463149306)
,p_event_id=>wwv_flow_api.id(63570757962149306)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'your are going to return your budget allocation plan, Are you sure? '
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(63578871536149311)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get plan approved budget details'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P74_TOTAL_APPROVED_BUDGET_CH1 := trim(to_char(budget_allocation_pkg.GET_APPROVED_BUDGET_BY_SEC_CH(:P74_PLAN_ID, 1, :P74_SECTOR_ID),''99,999,999,999.99''));',
':P74_TOTAL_APPROVED_BUDGET_CH2 := trim(to_char(budget_allocation_pkg.GET_APPROVED_BUDGET_BY_SEC_CH(:P74_PLAN_ID, 2, :P74_SECTOR_ID),''99,999,999,999.99''));',
':P74_TOTAL_APPROVED_BUDGET_CH3 := trim(to_char(budget_allocation_pkg.GET_APPROVED_BUDGET_BY_SEC_CH(:P74_PLAN_ID, 3, :P74_SECTOR_ID),''99,999,999,999.99''));',
':P74_TOTAL_APPROVED_BUDGET_CH6 := trim(to_char(budget_allocation_pkg.GET_APPROVED_BUDGET_BY_SEC_CH(:P74_PLAN_ID, 6, :P74_SECTOR_ID),''99,999,999,999.99''));',
'',
'-- ',
':P74_TOTAL_ALLOCATED_BUDGET_CH1 := trim(to_char(budget_allocation_pkg.get_allocated_budget_by_sec_ch(:P74_PLAN_ID, 1, :P74_SECTOR_ID),''99,999,999,999.99''));',
':P74_TOTAL_ALLOCATED_BUDGET_CH2 := trim(to_char(budget_allocation_pkg.get_allocated_budget_by_sec_ch(:P74_PLAN_ID, 2, :P74_SECTOR_ID),''99,999,999,999.99''));',
':P74_TOTAL_ALLOCATED_BUDGET_CH3 := trim(to_char(budget_allocation_pkg.get_allocated_budget_by_sec_ch(:P74_PLAN_ID, 3, :P74_SECTOR_ID),''99,999,999,999.99''));',
':P74_TOTAL_ALLOCATED_BUDGET_CH6 := trim(to_char(budget_allocation_pkg.get_allocated_budget_by_sec_ch(:P74_PLAN_ID, 6, :P74_SECTOR_ID),''99,999,999,999.99''));',
''))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(63579442789149312)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(233561457670234879)
,p_process_type=>'NATIVE_IG_DML'
,p_process_name=>'Sector Budget Allocation Plan Details - Save Interactive Grid Data'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(63578525418149311)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get Projects process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'INSERT INTO budget_allocation_projects_plans (',
'                                                budget_allocation_plan_id,',
'                                                project_number,',
'                                                task_number,',
'                                                expenditure_type,',
'                                                entity_code,',
'                                                cost_center,',
'                                                budget_groub_code,',
'                                                gl_account,',
'                                                activity,',
'                                                future1,',
'                                                future2,',
'                                                sector_id,',
'                                                scenario,',
'                                                approved_budget_ch1,',
'                                                approved_budget_ch2,',
'                                                approved_budget_ch3,',
'                                                approved_budget_ch6,',
'                                                status,',
'                                                comments',
') select ',
'        :P74_PLAN_ID',
'       , PROJECT_NUMBER',
'       , TASK_NUMBER',
'       , EXPENDITURE_TYPE',
'       , ''451''',
'       , :P74_COST_CENTER',
'       , BUDGET_GROUP_CODE',
'       , GL_ACCOUNT',
'       , ACTIVITY',
'       , FUTURE1',
'       , FUTURE2 ',
'       , :P74_SECTOR_ID',
'       , :P74_SCENARIO',
'       , 0',
'       , 0',
'       , 0',
'       , 0',
'       , ''Draft''',
'       , null',
'    FROM',
'        (select  distinct pb.PROJECT_NUMBER',
'               , pb.TASK_NUMBER',
'               , pb.EXPENDITURE_TYPE',
'               , t.budget_group_code',
'               , (select distinct e.gl_account',
'                  from expenditure e',
'                  where e.project_number = pb.project_number',
'                  and   e.task_number = pb.task_number',
'                  and   e.expenditure_type = pb.expenditure_type) GL_ACCOUNT',
'               , t.activity',
'               , t.future1',
'               , t.future2   ',
'        from project_balances pb, task t ',
'        where pb.PROJECT_NUMBER = t.project_number ',
'        and pb.cost_center = :P74_COST_CENTER);'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_type=>'NEVER'
);
wwv_flow_api.component_end;
end;
/
