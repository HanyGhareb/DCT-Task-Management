prompt --application/pages/page_00024
begin
--   Manifest
--     PAGE: 00024
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>110
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>24
,p_user_interface_id=>wwv_flow_api.id(13327188105480887)
,p_name=>'Approved Budget By Projects'
,p_alias=>'APPROVED-BUDGET-BY-PROJECTS'
,p_step_title=>'Approved Budget By Projects'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(function($) {',
'    function update(model) {',
'        var budgetKey = model.getFieldKey("APPROVED_AMOUNT"), ',
'           a = $v("P24_TOTAL_DEPT_APPROVED_BUDGET_H"),',
'           b=0,',
'            total = 0;',
'',
'        console.log(">> starting sum APPROVED_AMOUNT column")',
'        model.forEach(function(record, index, id) {',
'            var APPROVED_AMOUNT = parseFloat(record[budgetKey]),  ',
'                meta = model.getRecordMetadata(id);',
'',
'            if (!isNaN(APPROVED_AMOUNT) && !meta.deleted && !meta.agg) {',
'                ',
'                total += APPROVED_AMOUNT;',
'              ',
'            }',
'        });',
'        console.log(">> setting sum APPROVED_AMOUNT column to " + total)',
'        $s("P24_TOTAL_ALLOCATED", Number(total).toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, ''$1,'')); ',
'        b = a - total;',
'        $s("P24_REMAINING" , Number(b).toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, ''$1,''))',
'    }',
'',
'    $(function() {',
'    ',
'        $("#budget_ig").on("interactivegridviewmodelcreate", function(event, ui) {',
'            var sid,',
'                model = ui.model;',
'            if ( ui.viewId === "grid" ) {',
'                sid = model.subscribe( {',
'                    onChange: function(type, change) {',
'                        console.log(">> model changed ", type, change);',
'                        if ( type === "set" ) {',
'                            if (change.field === "APPROVED_AMOUNT" ) {',
'                                update( model );',
'                            }',
'                        } else if (type !== "move" && type !== "metaChange") {',
'                            update( model );',
'                        }',
'                    },',
'                    progressView: $("#P24_TOTAL_ALLOCATED") ',
'                } );',
'',
'                update( model ); ',
'',
'                model.fetchAll(function() {});',
'            }',
'        });',
'',
'    });',
'',
'})(apex.jQuery);'))
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210112132726'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(18614027501507355)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(13251955757480809)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(13188546909480758)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(13306063834480855)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(18614601782507358)
,p_plug_name=>'Approved Budget By Projects'
,p_region_name=>'budget_ig'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(13240610854480803)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       CHAPTER,',
'       SECTOR,',
'       DEPARTMENT_NAME,',
'       PROJECT_NUMBER,',
'       PROJECT_NAME,',
'       DCT_PROJECT_NAME,',
'       COST_CENTER,',
'       TASK_NAME,',
'       ACCOUNT_NUMBER,',
'       BUDGET_YEAR,',
'       PROPOSED_SCENARIO,',
'       BUDGET_VERSION,',
'       APPROVED_AMOUNT,',
'       STATUS,',
'       START_DATE,',
'       END_DATE,',
'       CREATED_ON,',
'       CREATED_BY,',
'       UPDATED_ON,',
'       UPDATED_BY',
'      , (select round(sum(nvl(budget_2020,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P24_SCENARIO',
'          and proposed_budget.scenario_year = :P24_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET_BY_PROJECT.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET_BY_PROJECT.CHAPTER',
'          and proposed_budget.department_name = APPROVED_BUDGET_BY_PROJECT.department_name',
'          and aderp_project_number = APPROVED_BUDGET_BY_PROJECT.project_number',
'          AND cost_center = APPROVED_BUDGET_BY_PROJECT.cost_center',
'          AND task_name = APPROVED_BUDGET_BY_PROJECT.task_name)  Budget_2020',
'    , (select round(sum(nvl(budget_2021,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P24_SCENARIO',
'          and proposed_budget.scenario_year = :P24_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET_BY_PROJECT.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET_BY_PROJECT.CHAPTER',
'          and proposed_budget.department_name = APPROVED_BUDGET_BY_PROJECT.department_name',
'          and aderp_project_number = APPROVED_BUDGET_BY_PROJECT.project_number',
'          AND cost_center = APPROVED_BUDGET_BY_PROJECT.cost_center',
'          AND task_name = APPROVED_BUDGET_BY_PROJECT.task_name)  Budget_2021',
'    , (select round(sum(nvl(budget_2022,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P24_SCENARIO',
'          and proposed_budget.scenario_year = :P24_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET_BY_PROJECT.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET_BY_PROJECT.CHAPTER',
'          and proposed_budget.department_name = APPROVED_BUDGET_BY_PROJECT.department_name',
'          and aderp_project_number = APPROVED_BUDGET_BY_PROJECT.project_number',
'          AND cost_center = APPROVED_BUDGET_BY_PROJECT.cost_center',
'          AND task_name = APPROVED_BUDGET_BY_PROJECT.task_name)  Budget_2022',
'   , (select round(sum(nvl(budget_2023,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P24_SCENARIO',
'          and proposed_budget.scenario_year = :P24_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET_BY_PROJECT.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET_BY_PROJECT.CHAPTER',
'          and proposed_budget.department_name = APPROVED_BUDGET_BY_PROJECT.department_name',
'          and aderp_project_number = APPROVED_BUDGET_BY_PROJECT.project_number',
'          AND cost_center = APPROVED_BUDGET_BY_PROJECT.cost_center',
'          AND task_name = APPROVED_BUDGET_BY_PROJECT.task_name)  Budget_2023       ',
'  from APPROVED_BUDGET_BY_PROJECT',
'   where SECTOR = :P24_SECTOR',
'AND PROPOSED_SCENARIO = :P24_SCENARIO',
'AND BUDGET_VERSION = :P24_VERSION',
'AND BUDGET_YEAR = :P24_BUDGET_YEAR',
'AND CHAPTER = :P24_CHAPTER',
'AND DEPARTMENT_NAME = :P24_DEPARTMENT_NAME'))
,p_plug_source_type=>'NATIVE_IG'
,p_ajax_items_to_submit=>'P24_SECTOR,P24_CHAPTER,P24_BUDGET_YEAR,P24_SCENARIO,P24_VERSION,P24_DEPARTMENT_NAME'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Approved Budget By Projects'
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18496723574956141)
,p_name=>'BUDGET_2020'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET_2020'
,p_data_type=>'NUMBER'
,p_is_query_only=>true
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Budget 2020'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>240
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_format_mask=>'999G999G999G999G990D00'
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
 p_id=>wwv_flow_api.id(18496993398956143)
,p_name=>'BUDGET_2021'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET_2021'
,p_data_type=>'NUMBER'
,p_is_query_only=>true
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Budget 2021'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>250
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_format_mask=>'999G999G999G999G990D00'
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
 p_id=>wwv_flow_api.id(18497069807956144)
,p_name=>'BUDGET_2022'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET_2022'
,p_data_type=>'NUMBER'
,p_is_query_only=>true
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Budget 2022'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>260
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_format_mask=>'999G999G999G999G990D00'
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
 p_id=>wwv_flow_api.id(18497171778956145)
,p_name=>'BUDGET_2023'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET_2023'
,p_data_type=>'NUMBER'
,p_is_query_only=>true
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Budget 2023'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>270
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_format_mask=>'999G999G999G999G990D00'
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
 p_id=>wwv_flow_api.id(18497281268956146)
,p_name=>'APEX$ROW_ACTION'
,p_item_type=>'NATIVE_ROW_ACTION'
,p_display_sequence=>20
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18497309068956147)
,p_name=>'APEX$ROW_SELECTOR'
,p_item_type=>'NATIVE_ROW_SELECTOR'
,p_display_sequence=>10
,p_attribute_01=>'Y'
,p_attribute_02=>'Y'
,p_attribute_03=>'N'
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18616450225507462)
,p_name=>'ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Id'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>30
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_is_required=>true
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>true
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18616931054507462)
,p_name=>'CHAPTER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CHAPTER'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Chapter'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>40
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
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18617587952507463)
,p_name=>'SECTOR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SECTOR'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Sector'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>50
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
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18618151677507463)
,p_name=>'DEPARTMENT_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DEPARTMENT_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Department Name'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>60
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
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18618785460507463)
,p_name=>'PROJECT_NUMBER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PROJECT_NUMBER'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Project Number'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>70
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>20
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
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18619383678507464)
,p_name=>'PROJECT_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PROJECT_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Project Name'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>80
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18619977180507464)
,p_name=>'DCT_PROJECT_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DCT_PROJECT_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'DCT Project Name'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>90
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18620592449507465)
,p_name=>'COST_CENTER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COST_CENTER'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Cost Center'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>100
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>28
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
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18621184221507465)
,p_name=>'TASK_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TASK_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Task Name'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>110
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>1020
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18621739163507465)
,p_name=>'ACCOUNT_NUMBER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ACCOUNT_NUMBER'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Account Number'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>120
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>24
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
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18622300880507466)
,p_name=>'BUDGET_YEAR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET_YEAR'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Budget Year'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>130
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
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18622988460507466)
,p_name=>'PROPOSED_SCENARIO'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PROPOSED_SCENARIO'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Proposed Scenario'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>140
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
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18623574885507466)
,p_name=>'BUDGET_VERSION'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET_VERSION'
,p_data_type=>'NUMBER'
,p_is_query_only=>true
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Budget Version'
,p_heading_alignment=>'CENTER'
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18624139205507467)
,p_name=>'APPROVED_AMOUNT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'APPROVED_AMOUNT'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Allocated Amount'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>160
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
 p_id=>wwv_flow_api.id(18624742544507467)
,p_name=>'STATUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'STATUS'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Status'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>170
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
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18625319467507467)
,p_name=>'START_DATE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'START_DATE'
,p_data_type=>'DATE'
,p_is_query_only=>true
,p_item_type=>'NATIVE_DATE_PICKER'
,p_heading=>'Start Date'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>180
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18625931992507468)
,p_name=>'END_DATE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'END_DATE'
,p_data_type=>'DATE'
,p_is_query_only=>true
,p_item_type=>'NATIVE_DATE_PICKER'
,p_heading=>'End Date'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>190
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18626535988507468)
,p_name=>'CREATED_ON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATED_ON'
,p_data_type=>'TIMESTAMP'
,p_is_query_only=>true
,p_item_type=>'NATIVE_DATE_PICKER'
,p_heading=>'Created On'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>200
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18627115102507469)
,p_name=>'CREATED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATED_BY'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Created By'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>210
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
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18627737122507469)
,p_name=>'UPDATED_ON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED_ON'
,p_data_type=>'TIMESTAMP'
,p_is_query_only=>true
,p_item_type=>'NATIVE_DATE_PICKER'
,p_heading=>'Updated On'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>220
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18628381266507469)
,p_name=>'UPDATED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED_BY'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Updated By'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>230
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
,p_include_in_export=>true
);
wwv_flow_api.create_interactive_grid(
 p_id=>wwv_flow_api.id(18615195202507359)
,p_internal_uid=>18615195202507359
,p_is_editable=>true
,p_edit_operations=>'u'
,p_lost_update_check_type=>'VALUES'
,p_submit_checked_rows=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>false
,p_fixed_row_height=>true
,p_pagination_type=>'SCROLL'
,p_show_total_row_count=>true
,p_show_toolbar=>true
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
 p_id=>wwv_flow_api.id(18615582107507359)
,p_interactive_grid_id=>wwv_flow_api.id(18615195202507359)
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_api.create_ig_report_view(
 p_id=>wwv_flow_api.id(18615605024507359)
,p_report_id=>wwv_flow_api.id(18615582107507359)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18616737908507462)
,p_view_id=>wwv_flow_api.id(18615605024507359)
,p_display_seq=>1
,p_column_id=>wwv_flow_api.id(18616450225507462)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18617396047507463)
,p_view_id=>wwv_flow_api.id(18615605024507359)
,p_display_seq=>2
,p_column_id=>wwv_flow_api.id(18616931054507462)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18617958776507463)
,p_view_id=>wwv_flow_api.id(18615605024507359)
,p_display_seq=>3
,p_column_id=>wwv_flow_api.id(18617587952507463)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18618548216507463)
,p_view_id=>wwv_flow_api.id(18615605024507359)
,p_display_seq=>4
,p_column_id=>wwv_flow_api.id(18618151677507463)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18619142754507464)
,p_view_id=>wwv_flow_api.id(18615605024507359)
,p_display_seq=>5
,p_column_id=>wwv_flow_api.id(18618785460507463)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>117.44399999999999
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18619775187507464)
,p_view_id=>wwv_flow_api.id(18615605024507359)
,p_display_seq=>7
,p_column_id=>wwv_flow_api.id(18619383678507464)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18620366794507464)
,p_view_id=>wwv_flow_api.id(18615605024507359)
,p_display_seq=>8
,p_column_id=>wwv_flow_api.id(18619977180507464)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18620909549507465)
,p_view_id=>wwv_flow_api.id(18615605024507359)
,p_display_seq=>8
,p_column_id=>wwv_flow_api.id(18620592449507465)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>102.88900000000001
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18621516831507465)
,p_view_id=>wwv_flow_api.id(18615605024507359)
,p_display_seq=>10
,p_column_id=>wwv_flow_api.id(18621184221507465)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18622174943507466)
,p_view_id=>wwv_flow_api.id(18615605024507359)
,p_display_seq=>10
,p_column_id=>wwv_flow_api.id(18621739163507465)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>119.55600000000001
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18622735926507466)
,p_view_id=>wwv_flow_api.id(18615605024507359)
,p_display_seq=>11
,p_column_id=>wwv_flow_api.id(18622300880507466)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18623377823507466)
,p_view_id=>wwv_flow_api.id(18615605024507359)
,p_display_seq=>12
,p_column_id=>wwv_flow_api.id(18622988460507466)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18623981822507467)
,p_view_id=>wwv_flow_api.id(18615605024507359)
,p_display_seq=>13
,p_column_id=>wwv_flow_api.id(18623574885507466)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18624570343507467)
,p_view_id=>wwv_flow_api.id(18615605024507359)
,p_display_seq=>15
,p_column_id=>wwv_flow_api.id(18624139205507467)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18625156830507467)
,p_view_id=>wwv_flow_api.id(18615605024507359)
,p_display_seq=>25
,p_column_id=>wwv_flow_api.id(18624742544507467)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>55.5556
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18625768878507468)
,p_view_id=>wwv_flow_api.id(18615605024507359)
,p_display_seq=>16
,p_column_id=>wwv_flow_api.id(18625319467507467)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18626314709507468)
,p_view_id=>wwv_flow_api.id(18615605024507359)
,p_display_seq=>17
,p_column_id=>wwv_flow_api.id(18625931992507468)
,p_is_visible=>false
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
,p_default_application_id=>110
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18626912618507468)
,p_view_id=>wwv_flow_api.id(18615605024507359)
,p_display_seq=>18
,p_column_id=>wwv_flow_api.id(18626535988507468)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18627553842507469)
,p_view_id=>wwv_flow_api.id(18615605024507359)
,p_display_seq=>19
,p_column_id=>wwv_flow_api.id(18627115102507469)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18628116156507469)
,p_view_id=>wwv_flow_api.id(18615605024507359)
,p_display_seq=>20
,p_column_id=>wwv_flow_api.id(18627737122507469)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18628704753507469)
,p_view_id=>wwv_flow_api.id(18615605024507359)
,p_display_seq=>21
,p_column_id=>wwv_flow_api.id(18628381266507469)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18635674917548880)
,p_view_id=>wwv_flow_api.id(18615605024507359)
,p_display_seq=>15
,p_column_id=>wwv_flow_api.id(18496723574956141)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>120
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18653564619588838)
,p_view_id=>wwv_flow_api.id(18615605024507359)
,p_display_seq=>22
,p_column_id=>wwv_flow_api.id(18496993398956143)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18654037208588841)
,p_view_id=>wwv_flow_api.id(18615605024507359)
,p_display_seq=>23
,p_column_id=>wwv_flow_api.id(18497069807956144)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18654552563588843)
,p_view_id=>wwv_flow_api.id(18615605024507359)
,p_display_seq=>24
,p_column_id=>wwv_flow_api.id(18497171778956145)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18659414784657855)
,p_view_id=>wwv_flow_api.id(18615605024507359)
,p_display_seq=>0
,p_column_id=>wwv_flow_api.id(18497281268956146)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(18872003860282047)
,p_plug_name=>'Approved Budget By Projects - IR'
,p_region_name=>'budget_ir2'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(13240610854480803)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       CHAPTER,',
'       SECTOR,',
'       DEPARTMENT_NAME,',
'       PROJECT_NUMBER,',
'       PROJECT_NAME,',
'       DCT_PROJECT_NAME,',
'       COST_CENTER,',
'       TASK_NAME,',
'       ACCOUNT_NUMBER,',
'       BUDGET_YEAR,',
'       PROPOSED_SCENARIO,',
'       BUDGET_VERSION,',
'       APPROVED_AMOUNT,',
'       STATUS,',
'       START_DATE,',
'       END_DATE,',
'       CREATED_ON,',
'       CREATED_BY,',
'       UPDATED_ON,',
'       UPDATED_BY',
'      , (select round(sum(nvl(budget_2020,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P24_SCENARIO',
'          and proposed_budget.scenario_year = :P24_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET_BY_PROJECT.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET_BY_PROJECT.CHAPTER',
'          and proposed_budget.department_name = APPROVED_BUDGET_BY_PROJECT.department_name',
'          and aderp_project_number = APPROVED_BUDGET_BY_PROJECT.project_number',
'          AND cost_center = APPROVED_BUDGET_BY_PROJECT.cost_center',
'          AND task_name = APPROVED_BUDGET_BY_PROJECT.task_name)  Budget_2020',
'    , (select round(sum(nvl(budget_2021,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P24_SCENARIO',
'          and proposed_budget.scenario_year = :P24_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET_BY_PROJECT.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET_BY_PROJECT.CHAPTER',
'          and proposed_budget.department_name = APPROVED_BUDGET_BY_PROJECT.department_name',
'          and aderp_project_number = APPROVED_BUDGET_BY_PROJECT.project_number',
'          AND cost_center = APPROVED_BUDGET_BY_PROJECT.cost_center',
'          AND task_name = APPROVED_BUDGET_BY_PROJECT.task_name)  Budget_2021',
'    , (select round(sum(nvl(budget_2022,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P24_SCENARIO',
'          and proposed_budget.scenario_year = :P24_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET_BY_PROJECT.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET_BY_PROJECT.CHAPTER',
'          and proposed_budget.department_name = APPROVED_BUDGET_BY_PROJECT.department_name',
'          and aderp_project_number = APPROVED_BUDGET_BY_PROJECT.project_number',
'          AND cost_center = APPROVED_BUDGET_BY_PROJECT.cost_center',
'          AND task_name = APPROVED_BUDGET_BY_PROJECT.task_name)  Budget_2022',
'   , (select round(sum(nvl(budget_2023,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P24_SCENARIO',
'          and proposed_budget.scenario_year = :P24_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET_BY_PROJECT.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET_BY_PROJECT.CHAPTER',
'          and proposed_budget.department_name = APPROVED_BUDGET_BY_PROJECT.department_name',
'          and aderp_project_number = APPROVED_BUDGET_BY_PROJECT.project_number',
'          AND cost_center = APPROVED_BUDGET_BY_PROJECT.cost_center',
'          AND task_name = APPROVED_BUDGET_BY_PROJECT.task_name)  Budget_2023       ',
'  from APPROVED_BUDGET_BY_PROJECT',
'   where SECTOR = :P24_SECTOR',
'AND PROPOSED_SCENARIO = :P24_SCENARIO',
'AND BUDGET_VERSION = :P24_VERSION',
'AND BUDGET_YEAR = :P24_BUDGET_YEAR',
'AND CHAPTER = :P24_CHAPTER',
'AND DEPARTMENT_NAME = :P24_DEPARTMENT_NAME'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P24_SECTOR,P24_CHAPTER,P24_BUDGET_YEAR,P24_SCENARIO,P24_VERSION,P24_DEPARTMENT_NAME'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Approved Budget By Projects - IR'
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
 p_id=>wwv_flow_api.id(18914075828166331)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>18914075828166331
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18914168003166332)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18914202431166333)
,p_db_column_name=>'CHAPTER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Chapter'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18914341269166334)
,p_db_column_name=>'SECTOR'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18914461536166335)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Department Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18914533229166336)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18914690092166337)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18914799648166338)
,p_db_column_name=>'DCT_PROJECT_NAME'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Dct Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18914872370166339)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18914936885166340)
,p_db_column_name=>'TASK_NAME'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Task Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18915071789166341)
,p_db_column_name=>'ACCOUNT_NUMBER'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Account Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18915111859166342)
,p_db_column_name=>'BUDGET_YEAR'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Budget Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18915248425166343)
,p_db_column_name=>'PROPOSED_SCENARIO'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Proposed Scenario'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18915394355166344)
,p_db_column_name=>'BUDGET_VERSION'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Budget Version'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18915441156166345)
,p_db_column_name=>'APPROVED_AMOUNT'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Approved Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18915564741166346)
,p_db_column_name=>'STATUS'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18915638494166347)
,p_db_column_name=>'START_DATE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18915781485166348)
,p_db_column_name=>'END_DATE'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18915807851166349)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18915959438166350)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18932640068243901)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18932743766243902)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18932832247243903)
,p_db_column_name=>'BUDGET_2020'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Budget 2020'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18932931934243904)
,p_db_column_name=>'BUDGET_2021'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Budget 2021'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18933010437243905)
,p_db_column_name=>'BUDGET_2022'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Budget 2022'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18933175791243906)
,p_db_column_name=>'BUDGET_2023'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Budget 2023'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(18957112957244663)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'189572'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PROJECT_NUMBER:PROJECT_NAME:COST_CENTER:TASK_NAME:ACCOUNT_NUMBER:APPROVED_AMOUNT:BUDGET_2020:BUDGET_2021:BUDGET_2022:BUDGET_2023:STATUS:START_DATE:END_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(37124112101467861)
,p_plug_name=>'Summary'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--noUI:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(13242565869480804)
,p_plug_display_sequence=>5
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(18674013145804802)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(18614027501507355)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(13304710257480854)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18496879292956142)
,p_name=>'P24_DEPARTMENT_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(37124112101467861)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Department :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(13303312112480851)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18629117874511740)
,p_name=>'P24_SECTOR'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(37124112101467861)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Sector :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(13303312112480851)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18629519036511741)
,p_name=>'P24_TOTAL_DEPT_APPROVED_BUDGET'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(37124112101467861)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Total Department Approved Budget: </span>'
,p_post_element_text=>'AED'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_tag_attributes=>'style="color:#33cc33"'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(13303312112480851)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18629996364511741)
,p_name=>'P24_TOTAL_DEPT_APPROVED_BUDGET_H'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(37124112101467861)
,p_item_default=>'P24_TOTAL_DEPT_APPROVED_BUDGET'
,p_item_default_type=>'ITEM'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18630359572511742)
,p_name=>'P24_CHAPTER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(37124112101467861)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Chapter :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(13303312112480851)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18630787401511743)
,p_name=>'P24_TOTAL_ALLOCATED'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(37124112101467861)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Total Budget Allocated :</span>'
,p_post_element_text=>'AED'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_tag_attributes=>'style="color:#DC0909" '
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(13303312112480851)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18631144817511743)
,p_name=>'P24_BUDGET_YEAR'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(37124112101467861)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Year Budget :</span>'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(13303312112480851)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18631541651511743)
,p_name=>'P24_REMAINING'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(37124112101467861)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Remaining :</span>'
,p_post_element_text=>'AED'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_tag_attributes=>'style="color:#DC0909" '
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(13303312112480851)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18632095059516268)
,p_name=>'P24_SCENARIO'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(18614027501507355)
,p_display_as=>'NATIVE_HIDDEN'
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18632336964518454)
,p_name=>'P24_VERSION'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(18614027501507355)
,p_display_as=>'NATIVE_HIDDEN'
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18930400236171233)
,p_name=>'P24_UPDATE'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(37124112101467861)
,p_item_default=>'N'
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Enable Update :</span>'
,p_display_as=>'NATIVE_YES_NO'
,p_read_only_when=>'P22_STATUS'
,p_read_only_when2=>'Draft'
,p_read_only_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_field_template=>wwv_flow_api.id(13303312112480851)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'APPLICATION'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(18497535796956149)
,p_computation_sequence=>10
,p_computation_item=>'P24_TOTAL_DEPT_APPROVED_BUDGET'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  to_char(sum(nvl(APPROVED_AMOUNT,0)),''99,999,999,999,999.99'')',
'          ',
'  from APPROVED_BUDGET_by_department',
' where BUDGET_YEAR = :P24_BUDGET_YEAR',
'and PROPOSED_SCENARIO = :P24_SCENARIO',
'and BUDGET_VERSION = :P24_VERSION',
'and sector = :P24_SECTOR',
'and chapter = :P24_CHAPTER',
'and department_name = :P24_DEPARTMENT_NAME'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(18497690439956150)
,p_computation_sequence=>20
,p_computation_item=>'P24_TOTAL_ALLOCATED'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  to_char(sum(nvl(APPROVED_AMOUNT,0)),''99,999,999,999,999.99'') || '' AED'' ',
'          ',
'  from approved_budget_by_department',
' where BUDGET_YEAR = :P24_BUDGET_YEAR',
'and PROPOSED_SCENARIO = :P24_SCENARIO',
'and BUDGET_VERSION = :P24_VERSION',
'and sector = :P24_SECTOR',
'and chapter = :P24_CHAPTER'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(18673917734804801)
,p_computation_sequence=>30
,p_computation_item=>'P24_TOTAL_DEPT_APPROVED_BUDGET_H'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  to_char(sum(nvl(APPROVED_AMOUNT,0)),''99,999,999,999,999.99'')',
'          ',
'  from APPROVED_BUDGET_by_department',
' where BUDGET_YEAR = :P24_BUDGET_YEAR',
'and PROPOSED_SCENARIO = :P24_SCENARIO',
'and BUDGET_VERSION = :P24_VERSION',
'and sector = :P24_SECTOR',
'and chapter = :P24_CHAPTER',
'and department_name = :P24_DEPARTMENT_NAME'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(18913585239166326)
,p_name=>'Enable Updates'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P24_UPDATE'
,p_condition_element=>'P24_UPDATE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'N'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(18913647594166327)
,p_event_id=>wwv_flow_api.id(18913585239166326)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(18872003860282047)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(18913920790166330)
,p_event_id=>wwv_flow_api.id(18913585239166326)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(18614601782507358)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(18913731016166328)
,p_event_id=>wwv_flow_api.id(18913585239166326)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(18872003860282047)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(18913897551166329)
,p_event_id=>wwv_flow_api.id(18913585239166326)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(18614601782507358)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(18497401282956148)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(18614601782507358)
,p_process_type=>'NATIVE_IG_DML'
,p_process_name=>'Approved Budget By Projects - Save Interactive Grid Data'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
