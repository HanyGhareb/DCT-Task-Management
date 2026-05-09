prompt --application/pages/page_00074
begin
--   Manifest
--     PAGE: 00074
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>74
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'DP Item Cashflow Details &P74_DP_ITEM_CODE.'
,p_alias=>'DP-ITEM-CASHFLOW-DETAILS'
,p_page_mode=>'MODAL'
,p_step_title=>'DP Item Cashflow Details'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240228230400'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(7920091464999551)
,p_plug_name=>'Button'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noBorder'
,p_plug_template=>wwv_flow_api.id(127777381735449810)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(7920435848999555)
,p_plug_name=>'Details'
,p_icon_css_classes=>'fa-design'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(8317868374981150)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127813188296449776)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(127749711524449850)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(127867332295449731)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'NEVER'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(8318479537981153)
,p_plug_name=>'DP Item Cashflow Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent14:t-Region--noBorder:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select LINE_ID,',
'       BUDGET_ALLOCATION_PLAN_ID,',
'       ACCOUNTING_YEAR,',
'       MULTI_YEAR_YN,',
'       DISTRIBUTION_DATE,',
'       PROJECT_NUMBER,',
'       TASK_NUMBER,',
'       EXPENDITURE_TYPE,',
'       PROJECT_NAME_NEW,',
'       TASK_NUMBER_NEW,',
'       EXPENDITURE_TYPE_NEW,',
'       ENTITY_CODE,',
'       COST_CENTER,',
'       BUDGET_GROUB_CODE,',
'       GL_ACCOUNT,',
'       ACTIVITY,',
'       FUTURE1,',
'       FUTURE2,',
'       ENTITY_CODE_NEW,',
'       COST_CENTER_NEW,',
'       BUDGET_GROUB_CODE_NEW,',
'       GL_ACCOUNT_NEW,',
'       ACTIVITY_NEW,',
'       FUTURE1_NEW,',
'       FUTURE2_NEW,',
'       ALLOCATED_BUDGET,',
'       BUDGET,',
'       ENCUMBERANCE,',
'       ACTUAL,',
'       JAN,',
'       FEB,',
'       MAR,',
'       APR,',
'       MAY,',
'       JUN,',
'       JUL,',
'       AUG,',
'       SEP,',
'       OCT,',
'       NOV,',
'       DEC,',
'       LINE_TYPE,',
'       TOTAL_CF,',
'       NOTE,',
'       STATUS,',
'       FINAL_STATUS_ON,',
'       SOURCE,',
'       REQUEST_ID,',
'       REQUEST_LINE_ID,',
'       INITIATIVE_ID,',
'       INITIATIVE_NEW_NAME,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       TOTAL_CF_FORMAT',
'  from CASHFLOW_LINES',
'  where SOURCE = ''DP''',
'  and REQUEST_ID = :P74_ITEM_ID;'))
,p_plug_source_type=>'NATIVE_IG'
,p_ajax_items_to_submit=>'P74_ITEM_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'DP Item Cashflow Details'
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8319694381981158)
,p_name=>'APEX$ROW_SELECTOR'
,p_item_type=>'NATIVE_ROW_SELECTOR'
,p_display_sequence=>10
,p_attribute_01=>'Y'
,p_attribute_02=>'Y'
,p_attribute_03=>'N'
,p_enable_hide=>true
,p_is_primary_key=>false
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8320064151981158)
,p_name=>'APEX$ROW_ACTION'
,p_item_type=>'NATIVE_ROW_ACTION'
,p_label=>'Actions'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>20
,p_value_alignment=>'CENTER'
,p_enable_hide=>true
,p_is_primary_key=>false
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8320675689981326)
,p_name=>'LINE_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'LINE_ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>30
,p_attribute_01=>'Y'
,p_enable_filter=>false
,p_enable_hide=>true
,p_is_primary_key=>true
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8321172990981327)
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8321765396981328)
,p_name=>'ACCOUNTING_YEAR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ACCOUNTING_YEAR'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Accounting Year'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>50
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>4
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_default_type=>'PLSQL_EXPRESSION'
,p_default_expression=>'to_number(DP_ITEMS_UTIL.get_active_year)'
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8322346427981328)
,p_name=>'MULTI_YEAR_YN'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MULTI_YEAR_YN'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>60
,p_attribute_01=>'Y'
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8323018551981328)
,p_name=>'DISTRIBUTION_DATE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DISTRIBUTION_DATE'
,p_data_type=>'DATE'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER'
,p_heading=>'Distribution Date'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>80
,p_value_alignment=>'CENTER'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
,p_format_mask=>'DD-MON-YYYY'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_default_type=>'SQL_QUERY'
,p_default_expression=>'select to_char(sysdate,''DD-MON-YYYY'') from dual'
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8323602664981329)
,p_name=>'PROJECT_NUMBER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PROJECT_NUMBER'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Project'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>90
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>12
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_default_type=>'ITEM'
,p_default_expression=>'P74_PROJECT_NUMBER_H'
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P11_PROJECT_NEW_YN = ''N'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8324142651981329)
,p_name=>'TASK_NUMBER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TASK_NUMBER'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_POPUP_LOV'
,p_heading=>'Task'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>100
,p_value_alignment=>'LEFT'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_is_required=>false
,p_max_length=>100
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_api.id(8386566515234533)
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_default_type=>'ITEM'
,p_default_expression=>'P74_TASK_H'
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P11_PROJECT_NEW_YN = ''N'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8324741497981329)
,p_name=>'EXPENDITURE_TYPE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'EXPENDITURE_TYPE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Expenditure Type'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>110
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>255
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_default_type=>'ITEM'
,p_default_expression=>'P74_EXPENDITURE_TYPE_H'
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P11_PROJECT_NEW_YN = ''N'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8325358184981330)
,p_name=>'PROJECT_NAME_NEW'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PROJECT_NAME_NEW'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'New Project'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>120
,p_value_alignment=>'LEFT'
,p_attribute_02=>'VALUE'
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_default_type=>'ITEM'
,p_default_expression=>'P74_PROJECT_NEW_H'
,p_duplicate_value=>true
,p_include_in_export=>false
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P11_PROJECT_NEW_YN = ''Y'''
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8325956702981330)
,p_name=>'TASK_NUMBER_NEW'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TASK_NUMBER_NEW'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'New Task'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>130
,p_value_alignment=>'LEFT'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_is_required=>false
,p_max_length=>100
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_default_type=>'ITEM'
,p_default_expression=>'P74_TASK_NEW_H'
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P11_PROJECT_NEW_YN = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8326590246981330)
,p_name=>'EXPENDITURE_TYPE_NEW'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'EXPENDITURE_TYPE_NEW'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'New Expenditure Type'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>140
,p_value_alignment=>'LEFT'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_is_required=>false
,p_max_length=>255
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_default_type=>'ITEM'
,p_default_expression=>'P74_EXPENDITURE_TYPE_NEW_H'
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P11_PROJECT_NEW_YN = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8327144672981330)
,p_name=>'ENTITY_CODE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ENTITY_CODE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>150
,p_attribute_01=>'Y'
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_default_type=>'STATIC'
,p_default_expression=>'451'
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8327733655981331)
,p_name=>'COST_CENTER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COST_CENTER'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Cost Center'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>70
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_default_type=>'SQL_QUERY'
,p_default_expression=>'select PROJECTS_UTIL.task_cost_center(project_number, TASK_NUMBER) from dp_items where item_id = :P74_ITEM_ID'
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P11_PROJECT_NEW_YN = ''N'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8328376697981331)
,p_name=>'BUDGET_GROUB_CODE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET_GROUB_CODE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Budget Groub Code'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>160
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P11_PROJECT_NEW_YN = ''N'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8328996388981331)
,p_name=>'GL_ACCOUNT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'GL_ACCOUNT'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Gl Account'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>170
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P11_PROJECT_NEW_YN = ''N'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8329573354981332)
,p_name=>'ACTIVITY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ACTIVITY'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Activity'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>180
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P11_PROJECT_NEW_YN = ''N'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8330138279981332)
,p_name=>'FUTURE1'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'FUTURE1'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Future1'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>190
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P11_PROJECT_NEW_YN = ''N'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8330792161981332)
,p_name=>'FUTURE2'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'FUTURE2'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Future2'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>200
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P11_PROJECT_NEW_YN = ''N'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8331420045981332)
,p_name=>'ENTITY_CODE_NEW'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ENTITY_CODE_NEW'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>210
,p_attribute_01=>'Y'
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_default_type=>'STATIC'
,p_default_expression=>'451'
,p_duplicate_value=>true
,p_include_in_export=>false
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P11_PROJECT_NEW_YN = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8331965054981333)
,p_name=>'COST_CENTER_NEW'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COST_CENTER_NEW'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'New Cost Center'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>220
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P11_PROJECT_NEW_YN = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8332572675981333)
,p_name=>'BUDGET_GROUB_CODE_NEW'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET_GROUB_CODE_NEW'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'New Budget Group Code'
,p_heading_alignment=>'CENTER'
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P11_PROJECT_NEW_YN = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8333218392981333)
,p_name=>'GL_ACCOUNT_NEW'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'GL_ACCOUNT_NEW'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'New GL Account'
,p_heading_alignment=>'CENTER'
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P11_PROJECT_NEW_YN = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8333736446981333)
,p_name=>'ACTIVITY_NEW'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ACTIVITY_NEW'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'New Activity'
,p_heading_alignment=>'CENTER'
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P11_PROJECT_NEW_YN = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8334427884981334)
,p_name=>'FUTURE1_NEW'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'FUTURE1_NEW'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'New Future1'
,p_heading_alignment=>'CENTER'
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P11_PROJECT_NEW_YN = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8334935653981334)
,p_name=>'FUTURE2_NEW'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'FUTURE2_NEW'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'New Future2'
,p_heading_alignment=>'CENTER'
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P11_PROJECT_NEW_YN = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8335617192981334)
,p_name=>'ALLOCATED_BUDGET'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ALLOCATED_BUDGET'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Allocated Budget'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>280
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_default_type=>'ITEM'
,p_default_expression=>'P74_ESTIMATED_BUDGET_H'
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8336142379981335)
,p_name=>'BUDGET'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Budget'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>290
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'NEVER'
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8336764591981335)
,p_name=>'ENCUMBERANCE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ENCUMBERANCE'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Encumberance'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>300
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'NEVER'
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8337401908981335)
,p_name=>'ACTUAL'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ACTUAL'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Actual'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>310
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'NEVER'
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8337997144981335)
,p_name=>'JAN'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'JAN'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'01-&P11_ESTIMATED_YEAR.'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>320
,p_value_alignment=>'RIGHT'
,p_value_css_classes=>'u-color-1 u-color-1-bg'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8338569465981336)
,p_name=>'FEB'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'FEB'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'02-&P11_ESTIMATED_YEAR.'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>330
,p_value_alignment=>'RIGHT'
,p_value_css_classes=>'u-color-1 u-color-1-bg'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8339203110981336)
,p_name=>'MAR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MAR'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'03-&P11_ESTIMATED_YEAR.'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>340
,p_value_alignment=>'RIGHT'
,p_value_css_classes=>'u-color-1 u-color-1-bg'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8339753002981336)
,p_name=>'APR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'APR'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'04-&P11_ESTIMATED_YEAR.'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>350
,p_value_alignment=>'RIGHT'
,p_value_css_classes=>'u-color-1 u-color-1-bg'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
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
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8340414581981337)
,p_name=>'MAY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MAY'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'05-&P11_ESTIMATED_YEAR.'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>360
,p_value_alignment=>'RIGHT'
,p_value_css_classes=>'u-color-1 u-color-1-bg'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8341009777981337)
,p_name=>'JUN'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'JUN'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'06-&P11_ESTIMATED_YEAR.'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>370
,p_value_alignment=>'RIGHT'
,p_value_css_classes=>'u-color-1 u-color-1-bg'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8341546985981337)
,p_name=>'JUL'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'JUL'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'07-&P11_ESTIMATED_YEAR.'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>380
,p_value_alignment=>'RIGHT'
,p_value_css_classes=>'u-color-1 u-color-1-bg'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8342179066981338)
,p_name=>'AUG'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'AUG'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'08-&P11_ESTIMATED_YEAR.'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>390
,p_value_alignment=>'RIGHT'
,p_value_css_classes=>'u-color-1 u-color-1-bg'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8342783353981338)
,p_name=>'SEP'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SEP'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'09-&P11_ESTIMATED_YEAR.'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>400
,p_value_alignment=>'RIGHT'
,p_value_css_classes=>'u-color-1 u-color-1-bg'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8343411328981338)
,p_name=>'OCT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'OCT'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'10-&P11_ESTIMATED_YEAR.'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>410
,p_value_alignment=>'RIGHT'
,p_value_css_classes=>'u-color-1 u-color-1-bg'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8344005129981338)
,p_name=>'NOV'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'NOV'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'11-&P11_ESTIMATED_YEAR.'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>420
,p_value_alignment=>'RIGHT'
,p_value_css_classes=>'u-color-1 u-color-1-bg'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8344581308981339)
,p_name=>'DEC'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DEC'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'12-&P11_ESTIMATED_YEAR.'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>430
,p_value_alignment=>'RIGHT'
,p_value_css_classes=>'u-color-1 u-color-1-bg'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8345178305981339)
,p_name=>'LINE_TYPE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'LINE_TYPE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>440
,p_attribute_01=>'Y'
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_default_type=>'STATIC'
,p_default_expression=>'A'
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8345797482981339)
,p_name=>'TOTAL_CF'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TOTAL_CF'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Total Cf'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>450
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8346422734981339)
,p_name=>'NOTE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'NOTE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Note'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>460
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
,p_filter_exact_match=>true
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_control_break=>false
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8347018527981340)
,p_name=>'STATUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'STATUS'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Status'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>470
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_default_type=>'STATIC'
,p_default_expression=>'Draft'
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8347568501981340)
,p_name=>'FINAL_STATUS_ON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'FINAL_STATUS_ON'
,p_data_type=>'TIMESTAMP'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Final Status ON'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>480
,p_value_alignment=>'LEFT'
,p_attribute_02=>'VALUE'
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8348211640981340)
,p_name=>'SOURCE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SOURCE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>490
,p_attribute_01=>'Y'
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_default_type=>'STATIC'
,p_default_expression=>'DP'
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8348732359981340)
,p_name=>'REQUEST_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'REQUEST_ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>500
,p_attribute_01=>'Y'
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_default_type=>'ITEM'
,p_default_expression=>'P74_ITEM_ID'
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8349407495981341)
,p_name=>'REQUEST_LINE_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'REQUEST_LINE_ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>510
,p_attribute_01=>'Y'
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8349973872981341)
,p_name=>'INITIATIVE_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'INITIATIVE_ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Initiative Id'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>520
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8350610240981341)
,p_name=>'INITIATIVE_NEW_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'INITIATIVE_NEW_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Initiative New Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>530
,p_value_alignment=>'LEFT'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_is_required=>false
,p_max_length=>255
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_control_break=>false
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8351175491981341)
,p_name=>'CREATED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATED_BY'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Created By'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>540
,p_value_alignment=>'LEFT'
,p_attribute_02=>'LOV'
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_api.id(128328640271489809)
,p_lov_display_extra=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8351746102981342)
,p_name=>'CREATED_ON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATED_ON'
,p_data_type=>'TIMESTAMP'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Created On'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>550
,p_value_alignment=>'LEFT'
,p_attribute_02=>'VALUE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8352364808981342)
,p_name=>'UPDATED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED_BY'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Updated By'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>560
,p_value_alignment=>'LEFT'
,p_attribute_02=>'LOV'
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_api.id(128328640271489809)
,p_lov_display_extra=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8352999993981342)
,p_name=>'UPDATED_ON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED_ON'
,p_data_type=>'TIMESTAMP'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Updated On'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>570
,p_value_alignment=>'LEFT'
,p_attribute_02=>'VALUE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(8353610946981342)
,p_name=>'TOTAL_CF_FORMAT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TOTAL_CF_FORMAT'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Total'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>580
,p_value_alignment=>'LEFT'
,p_value_css_classes=>'u-color-13 u-color-13-bg'
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_interactive_grid(
 p_id=>wwv_flow_api.id(8319006885981155)
,p_internal_uid=>152521175860037119
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_add_row_if_empty=>true
,p_submit_checked_rows=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>true
,p_fixed_row_height=>true
,p_pagination_type=>'SCROLL'
,p_show_total_row_count=>true
,p_show_toolbar=>true
,p_enable_save_public_report=>false
,p_enable_subscriptions=>true
,p_enable_flashback=>false
,p_define_chart_view=>true
,p_enable_download=>true
,p_enable_mail_download=>true
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function( options ) {',
'    options.toolbar = false;',
'    return options;',
'}'))
);
wwv_flow_api.create_ig_report(
 p_id=>wwv_flow_api.id(8319342016981155)
,p_interactive_grid_id=>wwv_flow_api.id(8319006885981155)
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_api.create_ig_report_view(
 p_id=>wwv_flow_api.id(8319457263981155)
,p_report_id=>wwv_flow_api.id(8319342016981155)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8320431610981159)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>0
,p_column_id=>wwv_flow_api.id(8320064151981158)
,p_is_visible=>false
,p_is_frozen=>true
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8320985602981327)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>1
,p_column_id=>wwv_flow_api.id(8320675689981326)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8321579702981328)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>2
,p_column_id=>wwv_flow_api.id(8321172990981327)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8322178068981328)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>3
,p_column_id=>wwv_flow_api.id(8321765396981328)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>103
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8322785006981328)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>4
,p_column_id=>wwv_flow_api.id(8322346427981328)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8323377669981329)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>5
,p_column_id=>wwv_flow_api.id(8323018551981328)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>141
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8324009835981329)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>7
,p_column_id=>wwv_flow_api.id(8323602664981329)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>204
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8324579447981329)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>8
,p_column_id=>wwv_flow_api.id(8324142651981329)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>216
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8325169239981329)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>9
,p_column_id=>wwv_flow_api.id(8324741497981329)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>193
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8325763067981330)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>6
,p_column_id=>wwv_flow_api.id(8325358184981330)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>208
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8326383416981330)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>7
,p_column_id=>wwv_flow_api.id(8325956702981330)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>127
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8326968034981330)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>8
,p_column_id=>wwv_flow_api.id(8326590246981330)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>203
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8327628118981331)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>12
,p_column_id=>wwv_flow_api.id(8327144672981330)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8328149095981331)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>6
,p_column_id=>wwv_flow_api.id(8327733655981331)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>114
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8328734281981331)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>10
,p_column_id=>wwv_flow_api.id(8328376697981331)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8329396065981331)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>12
,p_column_id=>wwv_flow_api.id(8328996388981331)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8329990007981332)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>13
,p_column_id=>wwv_flow_api.id(8329573354981332)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8330544077981332)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>14
,p_column_id=>wwv_flow_api.id(8330138279981332)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8331206572981332)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>16
,p_column_id=>wwv_flow_api.id(8330792161981332)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8331763540981333)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>19
,p_column_id=>wwv_flow_api.id(8331420045981332)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8332337342981333)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>9
,p_column_id=>wwv_flow_api.id(8331965054981333)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>142
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8333011818981333)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>10
,p_column_id=>wwv_flow_api.id(8332572675981333)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8333576446981333)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>12
,p_column_id=>wwv_flow_api.id(8333218392981333)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8334150274981334)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>13
,p_column_id=>wwv_flow_api.id(8333736446981333)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8334761772981334)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>14
,p_column_id=>wwv_flow_api.id(8334427884981334)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8335354710981334)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>15
,p_column_id=>wwv_flow_api.id(8334935653981334)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8335953706981335)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>15
,p_column_id=>wwv_flow_api.id(8335617192981334)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>66
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8336566414981335)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>27
,p_column_id=>wwv_flow_api.id(8336142379981335)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8337192853981335)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>28
,p_column_id=>wwv_flow_api.id(8336764591981335)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8337826204981335)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>29
,p_column_id=>wwv_flow_api.id(8337401908981335)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8338384061981336)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>17
,p_column_id=>wwv_flow_api.id(8337997144981335)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8339007958981336)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>18
,p_column_id=>wwv_flow_api.id(8338569465981336)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8339591238981336)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>19
,p_column_id=>wwv_flow_api.id(8339203110981336)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8340161228981337)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>20
,p_column_id=>wwv_flow_api.id(8339753002981336)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8340776333981337)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>21
,p_column_id=>wwv_flow_api.id(8340414581981337)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8341393890981337)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>22
,p_column_id=>wwv_flow_api.id(8341009777981337)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8341976970981337)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>23
,p_column_id=>wwv_flow_api.id(8341546985981337)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8342622873981338)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>24
,p_column_id=>wwv_flow_api.id(8342179066981338)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8343204776981338)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>25
,p_column_id=>wwv_flow_api.id(8342783353981338)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8343820974981338)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>26
,p_column_id=>wwv_flow_api.id(8343411328981338)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8344333313981338)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>27
,p_column_id=>wwv_flow_api.id(8344005129981338)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8344996669981339)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>28
,p_column_id=>wwv_flow_api.id(8344581308981339)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8345595102981339)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>42
,p_column_id=>wwv_flow_api.id(8345178305981339)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8346197853981339)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>30
,p_column_id=>wwv_flow_api.id(8345797482981339)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8346748614981340)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>29
,p_column_id=>wwv_flow_api.id(8346422734981339)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8347337598981340)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>31
,p_column_id=>wwv_flow_api.id(8347018527981340)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8347972523981340)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>32
,p_column_id=>wwv_flow_api.id(8347568501981340)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8348617929981340)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>47
,p_column_id=>wwv_flow_api.id(8348211640981340)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8349140124981341)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>48
,p_column_id=>wwv_flow_api.id(8348732359981340)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8349738337981341)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>49
,p_column_id=>wwv_flow_api.id(8349407495981341)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8350416810981341)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>33
,p_column_id=>wwv_flow_api.id(8349973872981341)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8350937109981341)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>34
,p_column_id=>wwv_flow_api.id(8350610240981341)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8351549768981342)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>35
,p_column_id=>wwv_flow_api.id(8351175491981341)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8352152003981342)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>36
,p_column_id=>wwv_flow_api.id(8351746102981342)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8352821384981342)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>37
,p_column_id=>wwv_flow_api.id(8352364808981342)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8353415051981342)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>38
,p_column_id=>wwv_flow_api.id(8352999993981342)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(8354009172981343)
,p_view_id=>wwv_flow_api.id(8319457263981155)
,p_display_seq=>39
,p_column_id=>wwv_flow_api.id(8353610946981342)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(7920399381999554)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(7920091464999551)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(127865952197449732)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(7920328447999553)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(7920091464999551)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(127865952197449732)
,p_button_image_alt=>'Save'
,p_button_position=>'REGION_TEMPLATE_CREATE'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(8893091267220168)
,p_branch_name=>'Go To 11'
,p_branch_action=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.::P11_ITEM_ID,P11_ITEM_ID_H:&P74_ITEM_ID.,&P74_ITEM_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(7920328447999553)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7920542303999556)
,p_name=>'P74_DP_ITEM_CODE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(7920435848999555)
,p_use_cache_before_default=>'NO'
,p_prompt=>'DP Item Code'
,p_source=>'P11_DP_ITEM_CODE'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7920870748999559)
,p_name=>'P74_PROJECT_NUMBER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(7920435848999555)
,p_use_cache_before_default=>'NO'
,p_source=>'NVL(:P11_PROJECT_NUMBER, :P11_PROJECT_NEW_NAME)'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7921008826999560)
,p_name=>'P74_ESTIMATED_BUDGET'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(7920435848999555)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Estimated Budget'
,p_post_element_text=>'<p>&nbsp;AED</p>'
,p_source=>':P11_ESTIMATED_BUDGET'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7921107228999561)
,p_name=>'P74_ESTIMATED_BUDGET_H'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(7920435848999555)
,p_use_cache_before_default=>'NO'
,p_source=>'P11_ESTIMATED_BUDGET_H'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8889958001220137)
,p_name=>'P74_PROJECT_NUMBER_H'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(7920435848999555)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8890048227220138)
,p_name=>'P74_TASK'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(7920435848999555)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8890222100220139)
,p_name=>'P74_EXPENDITURE_TYPE'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(7920435848999555)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8890261832220140)
,p_name=>'P74_TASK_NEW'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(7920435848999555)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8890334856220141)
,p_name=>'P74_EXPENDITURE_TYPE_NEW'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(7920435848999555)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8890468927220142)
,p_name=>'P74_TASK_H'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(7920435848999555)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8890619806220143)
,p_name=>'P74_TASK_NEW_H'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(7920435848999555)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8890699162220144)
,p_name=>'P74_EXPENDITURE_TYPE_H'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(7920435848999555)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8890796324220145)
,p_name=>'P74_EXPENDITURE_TYPE_NEW_H'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(7920435848999555)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8890838869220146)
,p_name=>'P74_PROJECT_NEW_YN'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(7920435848999555)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8890991994220147)
,p_name=>'P74_TASK_NEW_YN'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(7920435848999555)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8891073945220148)
,p_name=>'P74_PROJECT_NEW'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(7920435848999555)
,p_source=>'NVL(:P11_PROJECT_NUMBER, :P11_PROJECT_NEW_NAME)'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8891155384220149)
,p_name=>'P74_PROJECT_NEW_H'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(7920435848999555)
,p_use_cache_before_default=>'NO'
,p_source=>'NVL(:P11_PROJECT_NUMBER, :P11_PROJECT_NEW_NAME)'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8891309319220150)
,p_name=>'P74_ITEM_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(7920435848999555)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8891374154220151)
,p_name=>'P74_COST_CENTER'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(7920435848999555)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9190685330247778)
,p_name=>'P74_ESTIMATED_YEAR'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(7920435848999555)
,p_use_cache_before_default=>'NO'
,p_source=>'P11_ESTIMATED_BUDGET_H'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9527854135155837)
,p_name=>'P74_ALLOCATED'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(7920435848999555)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Allocated Cashflow'
,p_post_element_text=>'<p>&nbsp;AED</p>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(9191056642247782)
,p_tabular_form_region_id=>wwv_flow_api.id(8318479537981153)
,p_validation_name=>'check total Cashflow not Exceed '
,p_validation_sequence=>10
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
' to_number(replace(nvl(:jan,0),'','','''')) +',
'to_number(replace(nvl(:FEB,0),'','','''')) +',
'to_number(replace(nvl(:MAR,0),'','','''')) +',
'to_number(replace(nvl(:APR,0),'','','''')) +',
'to_number(replace(nvl(:MAY,0),'','','''')) +',
'to_number(replace(nvl(:JUN,0),'','','''')) +',
'to_number(replace(nvl(:JUL,0),'','','''')) +',
'to_number(replace(nvl(:AUG,0),'','','''')) +',
'to_number(replace(nvl(:SEP,0),'','','''')) +',
'to_number(replace(nvl(:OCT,0),'','','''')) +',
'to_number(replace(nvl(:NOV,0),'','','''')) +',
'to_number(replace(nvl(:DEC,0),'','','''')) = to_number(:P74_ESTIMATED_BUDGET_H)'))
,p_validation_type=>'PLSQL_EXPRESSION'
,p_error_message=>'you must allocate exactly the estimated budget &P74_ESTIMATED_BUDGET. AED'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(7920659382999557)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(7920399381999554)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7920796942999558)
,p_event_id=>wwv_flow_api.id(7920659382999557)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(9190741151247779)
,p_name=>'get Total'
,p_event_sequence=>20
,p_triggering_element_type=>'COLUMN'
,p_triggering_region_id=>wwv_flow_api.id(8318479537981153)
,p_triggering_element=>'JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(9190887509247780)
,p_event_id=>wwv_flow_api.id(9190741151247779)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'COLUMN'
,p_affected_elements=>'TOTAL_CF'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'to_number(replace(nvl(:jan,0),'','','''')) +',
'           to_number(replace(nvl(:FEB,0),'','','''')) +',
'           to_number(replace(nvl(:MAR,0),'','','''')) +',
'            to_number(replace(nvl(:APR,0),'','','''')) +',
'            to_number(replace(nvl(:MAY,0),'','','''')) +',
'            to_number(replace(nvl(:JUN,0),'','','''')) +',
'            to_number(replace(nvl(:JUL,0),'','','''')) +',
'            to_number(replace(nvl(:AUG,0),'','','''')) +',
'            to_number(replace(nvl(:SEP,0),'','','''')) +',
'            to_number(replace(nvl(:OCT,0),'','','''')) +',
'            to_number(replace(nvl(:NOV,0),'','','''')) +',
'            to_number(replace(nvl(:DEC,0),'','',''''))',
' '))
,p_attribute_07=>'JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(9191352082247785)
,p_event_id=>wwv_flow_api.id(9190741151247779)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P74_ALLOCATED'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'trim(to_char(to_number(replace(nvl(:JAN,0),'','','''')) +',
'            to_number(replace(nvl(:FEB,0),'','','''')) +',
'            to_number(replace(nvl(:MAR,0),'','','''')) +',
'            to_number(replace(nvl(:APR,0),'','','''')) +',
'            to_number(replace(nvl(:MAY,0),'','','''')) +',
'            to_number(replace(nvl(:JUN,0),'','','''')) +',
'            to_number(replace(nvl(:JUL,0),'','','''')) +',
'            to_number(replace(nvl(:AUG,0),'','','''')) +',
'            to_number(replace(nvl(:SEP,0),'','','''')) +',
'            to_number(replace(nvl(:OCT,0),'','','''')) +',
'            to_number(replace(nvl(:NOV,0),'','','''')) +',
'            to_number(replace(nvl(:DEC,0),'','',''''))',
'             ,',
'             ''99,999,999,999,999.99'')',
'     )',
' '))
,p_attribute_07=>'JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(9191020645247781)
,p_event_id=>wwv_flow_api.id(9190741151247779)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'COLUMN'
,p_affected_elements=>'TOTAL_CF_FORMAT'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'TRIM(TO_CHAR(to_number(replace(nvl(:jan,0),'','','''')) +',
'           to_number(replace(nvl(:FEB,0),'','','''')) +',
'           to_number(replace(nvl(:MAR,0),'','','''')) +',
'            to_number(replace(nvl(:APR,0),'','','''')) +',
'            to_number(replace(nvl(:MAY,0),'','','''')) +',
'            to_number(replace(nvl(:JUN,0),'','','''')) +',
'            to_number(replace(nvl(:JUL,0),'','','''')) +',
'            to_number(replace(nvl(:AUG,0),'','','''')) +',
'            to_number(replace(nvl(:SEP,0),'','','''')) +',
'            to_number(replace(nvl(:OCT,0),'','','''')) +',
'            to_number(replace(nvl(:NOV,0),'','','''')) +',
'            to_number(replace(nvl(:DEC,0),'','',''''))',
'  , ''99,999,999,999,999.99''))'))
,p_attribute_07=>'JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(9528214463155840)
,p_name=>'get Total_page load'
,p_event_sequence=>30
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
,p_display_when_type=>'EXISTS'
,p_display_when_cond=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1',
'from cashflow_lines',
'where request_id = :P74_ITEM_ID',
'and source = ''DP'''))
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(9528513745155843)
,p_event_id=>wwv_flow_api.id(9528214463155840)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P74_ALLOCATED'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'trim(to_char(to_number(replace(nvl(:JAN,0),'','','''')) +',
'            to_number(replace(nvl(:FEB,0),'','','''')) +',
'            to_number(replace(nvl(:MAR,0),'','','''')) +',
'            to_number(replace(nvl(:APR,0),'','','''')) +',
'            to_number(replace(nvl(:MAY,0),'','','''')) +',
'            to_number(replace(nvl(:JUN,0),'','','''')) +',
'            to_number(replace(nvl(:JUL,0),'','','''')) +',
'            to_number(replace(nvl(:AUG,0),'','','''')) +',
'            to_number(replace(nvl(:SEP,0),'','','''')) +',
'            to_number(replace(nvl(:OCT,0),'','','''')) +',
'            to_number(replace(nvl(:NOV,0),'','','''')) +',
'            to_number(replace(nvl(:DEC,0),'','',''''))',
'             ,',
'             ''99,999,999,999,999.99'')',
'     )',
' '))
,p_attribute_07=>'JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(9528301886155841)
,p_event_id=>wwv_flow_api.id(9528214463155840)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'COLUMN'
,p_affected_elements=>'TOTAL_CF'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'to_number(replace(nvl(:jan,0),'','','''')) +',
'           to_number(replace(nvl(:FEB,0),'','','''')) +',
'           to_number(replace(nvl(:MAR,0),'','','''')) +',
'            to_number(replace(nvl(:APR,0),'','','''')) +',
'            to_number(replace(nvl(:MAY,0),'','','''')) +',
'            to_number(replace(nvl(:JUN,0),'','','''')) +',
'            to_number(replace(nvl(:JUL,0),'','','''')) +',
'            to_number(replace(nvl(:AUG,0),'','','''')) +',
'            to_number(replace(nvl(:SEP,0),'','','''')) +',
'            to_number(replace(nvl(:OCT,0),'','','''')) +',
'            to_number(replace(nvl(:NOV,0),'','','''')) +',
'            to_number(replace(nvl(:DEC,0),'','',''''))',
' '))
,p_attribute_07=>'JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(9528430094155842)
,p_event_id=>wwv_flow_api.id(9528214463155840)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'COLUMN'
,p_affected_elements=>'TOTAL_CF_FORMAT'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'TRIM(TO_CHAR(to_number(replace(nvl(:jan,0),'','','''')) +',
'           to_number(replace(nvl(:FEB,0),'','','''')) +',
'           to_number(replace(nvl(:MAR,0),'','','''')) +',
'            to_number(replace(nvl(:APR,0),'','','''')) +',
'            to_number(replace(nvl(:MAY,0),'','','''')) +',
'            to_number(replace(nvl(:JUN,0),'','','''')) +',
'            to_number(replace(nvl(:JUL,0),'','','''')) +',
'            to_number(replace(nvl(:AUG,0),'','','''')) +',
'            to_number(replace(nvl(:SEP,0),'','','''')) +',
'            to_number(replace(nvl(:OCT,0),'','','''')) +',
'            to_number(replace(nvl(:NOV,0),'','','''')) +',
'            to_number(replace(nvl(:DEC,0),'','',''''))',
'  , ''99,999,999,999,999.99''))'))
,p_attribute_07=>'JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(8891527082220152)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialized'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    dp_item_code,',
'    project_new_yn,',
'    project_number,',
'    project_number n1,',
'    project_new_name,',
'    project_new_name n2,',
'    task_new_yn ,',
'    task_number,',
'    task_number n3,',
'    task_number_new,',
'    task_number_new n4,',
'    expenditure_type,',
'    expenditure_type n5,',
'    expenditure_type_new,',
'    expenditure_type_new n6,',
'    trim(to_char(estimated_budget,''99,999,999,999.99'')) estimated_budget,',
'    estimated_budget    h,',
'    PROJECTS_UTIL.task_cost_center(project_number, TASK_NUMBER) cost_center ',
'    ',
'into',
'    :P74_DP_ITEM_CODE,',
'    :P74_PROJECT_NEW_YN,',
'    :P74_PROJECT_NUMBER,',
'    :P74_PROJECT_NUMBER_H,',
'    :P74_PROJECT_NEW,',
'    :P74_PROJECT_NEW_H,',
'    :P74_TASK_NEW_YN,',
'    :P74_TASK,',
'    :P74_TASK_H,',
'    :P74_TASK_NEW,',
'    :P74_TASK_NEW_H,',
'    :P74_EXPENDITURE_TYPE,',
'    :P74_EXPENDITURE_TYPE_H,',
'    :P74_EXPENDITURE_TYPE_NEW,',
'    :P74_EXPENDITURE_TYPE_NEW_H,',
'    :P74_ESTIMATED_BUDGET,',
'    :P74_ESTIMATED_BUDGET_H,',
'    :P74_COST_CENTER',
'FROM',
'    dp_items',
'WHERE',
'    item_id = :p74_item_id;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(8354195694981343)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(8318479537981153)
,p_process_type=>'NATIVE_IG_DML'
,p_process_name=>'DP Item Cashflow Details - Save Interactive Grid Data'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(9528714638155845)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update Project Task GL Details'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update cashflow_lines',
'set cost_center = PROJECTS_UTIL.task_cost_center(project_number, TASK_NUMBER),',
'    BUDGET_GROUB_CODE = PROJECTS_UTIL.task_budget_code(project_number, TASK_NUMBER),',
'    GL_ACCOUNT = PROJECTS_UTIL.expenditure_type_gl_account(project_number, TASK_NUMBER, EXPENDITURE_TYPE),',
'    activity = PROJECTS_UTIL.task_activity(project_number, TASK_NUMBER),',
'    future1  = PROJECTS_UTIL.task_future1(project_number, TASK_NUMBER),',
'    future2  = PROJECTS_UTIL.task_future2(project_number, TASK_NUMBER),',
'    entity_code = ''451''',
'where source = ''DP''',
'and request_id = :P74_ITEM_ID;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(7920328447999553)
);
wwv_flow_api.component_end;
end;
/
