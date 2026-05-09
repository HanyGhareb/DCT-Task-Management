prompt --application/pages/page_00023
begin
--   Manifest
--     PAGE: 00023
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
 p_id=>23
,p_user_interface_id=>wwv_flow_api.id(13327188105480887)
,p_name=>'Approved Budget By Departments'
,p_alias=>'APPROVED-BUDGET-BY-DEPARTMENTS'
,p_step_title=>'Approved Budget By Departments'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(function($) {',
'    function update(model) {',
'        var budgetKey = model.getFieldKey("APPROVED_AMOUNT"), ',
'           a = $v("P23_TOTAL_SECTOR_APPROVED_BUDGET_H"),',
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
'        $s("P23_TOTAL_ALLOCATED", Number(total).toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, ''$1,'')); ',
'        $s("P23_TOTAL_ALLOCATED_H", Number(total).toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, ''$1,'')); ',
'        b = a - total;',
'        $s("P23_REMAINING" , Number(b).toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, ''$1,''));',
'        $s("P23_REMAINING_H" , b);',
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
'                    progressView: $("#P23_TOTAL_ALLOCATED") ',
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
,p_last_upd_yyyymmddhh24miss=>'20210112131138'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(18495225626956126)
,p_plug_name=>'Summary'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--noUI:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(13242565869480804)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(18539593933687493)
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
 p_id=>wwv_flow_api.id(18540188627687494)
,p_plug_name=>'Approved Budget By Departments'
,p_region_name=>'budget_ig'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(13242565869480804)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ROWID,',
'       ID,',
'       CHAPTER,',
'       SECTOR,',
'       DEPARTMENT_NAME,',
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
'       , (select round(sum(nvl(budget_2020,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P23_SCENARIO',
'          and proposed_budget.scenario_year = :P23_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET_BY_DEPARTMENT.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET_BY_DEPARTMENT.CHAPTER',
'          and proposed_budget.department_name = APPROVED_BUDGET_BY_DEPARTMENT.department_name)  Budget_2020',
'  , (select round(sum(nvl(budget_2021,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P23_SCENARIO',
'          and proposed_budget.scenario_year = :P23_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET_BY_DEPARTMENT.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET_BY_DEPARTMENT.CHAPTER',
'          and proposed_budget.department_name = APPROVED_BUDGET_BY_DEPARTMENT.department_name)  Budget_2021',
' , (select round(sum(nvl(budget_2022,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P23_SCENARIO',
'          and proposed_budget.scenario_year = :P23_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET_BY_DEPARTMENT.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET_BY_DEPARTMENT.CHAPTER',
'          and proposed_budget.department_name = APPROVED_BUDGET_BY_DEPARTMENT.department_name)  Budget_2022',
' , (select round(sum(nvl(budget_2023,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P23_SCENARIO',
'          and proposed_budget.scenario_year = :P23_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET_BY_DEPARTMENT.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET_BY_DEPARTMENT.CHAPTER',
'          and proposed_budget.department_name = APPROVED_BUDGET_BY_DEPARTMENT.department_name)  Budget_2023',
'          ',
'  from APPROVED_BUDGET_BY_DEPARTMENT',
' where SECTOR = :P23_SECTOR',
'AND PROPOSED_SCENARIO = :P23_SCENARIO',
'AND BUDGET_VERSION = :P23_VERSION',
'AND BUDGET_YEAR = :P23_BUDGET_YEAR',
'AND CHAPTER = :P23_CHAPTER'))
,p_plug_source_type=>'NATIVE_IG'
,p_ajax_items_to_submit=>'P23_SECTOR,P23_SCENARIO,P23_VERSION,P23_BUDGET_YEAR,P23_CHAPTER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Approved Budget By Departments'
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18494864859956122)
,p_name=>'BUDGET_2020'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET_2020'
,p_data_type=>'NUMBER'
,p_is_query_only=>true
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Budget 2020'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>190
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
 p_id=>wwv_flow_api.id(18494991886956123)
,p_name=>'BUDGET_2021'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET_2021'
,p_data_type=>'NUMBER'
,p_is_query_only=>true
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Budget 2021'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>200
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
 p_id=>wwv_flow_api.id(18495000904956124)
,p_name=>'BUDGET_2022'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET_2022'
,p_data_type=>'NUMBER'
,p_is_query_only=>true
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Budget 2022'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>210
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
 p_id=>wwv_flow_api.id(18495108222956125)
,p_name=>'BUDGET_2023'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET_2023'
,p_data_type=>'NUMBER'
,p_is_query_only=>true
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Budget 2023'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>220
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
 p_id=>wwv_flow_api.id(18541382912687498)
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
 p_id=>wwv_flow_api.id(18541821934687498)
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
 p_id=>wwv_flow_api.id(18542440330687499)
,p_name=>'ROWID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ROWID'
,p_data_type=>'ROWID'
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>30
,p_attribute_01=>'Y'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_control_break=>false
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>true
,p_include_in_export=>false
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18543075027687700)
,p_name=>'ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Id'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>40
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18543544889687701)
,p_name=>'CHAPTER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CHAPTER'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Chapter'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>50
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
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18544115668687701)
,p_name=>'SECTOR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SECTOR'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Sector'
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
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18544786833687702)
,p_name=>'DEPARTMENT_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DEPARTMENT_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_LINK'
,p_heading=>'Department Name'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>70
,p_value_alignment=>'LEFT'
,p_link_target=>'f?p=&APP_ID.:24:&SESSION.::&DEBUG.:24:P24_SECTOR,P24_CHAPTER,P24_BUDGET_YEAR,P24_SCENARIO,P24_VERSION,P24_DEPARTMENT_NAME:&SECTOR.,&CHAPTER.,&BUDGET_YEAR.,&PROPOSED_SCENARIO.,&BUDGET_VERSION.,&DEPARTMENT_NAME.'
,p_link_text=>'&DEPARTMENT_NAME.'
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
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18545359564687702)
,p_name=>'BUDGET_YEAR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET_YEAR'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Budget Year'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>80
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
 p_id=>wwv_flow_api.id(18545932412687702)
,p_name=>'PROPOSED_SCENARIO'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PROPOSED_SCENARIO'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Proposed Scenario'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>90
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
 p_id=>wwv_flow_api.id(18546573220687703)
,p_name=>'BUDGET_VERSION'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET_VERSION'
,p_data_type=>'NUMBER'
,p_is_query_only=>true
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Budget Version'
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
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18547188568687703)
,p_name=>'APPROVED_AMOUNT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'APPROVED_AMOUNT'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Allocated Amount'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>110
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
 p_id=>wwv_flow_api.id(18547788265687703)
,p_name=>'STATUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'STATUS'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Status'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>120
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
 p_id=>wwv_flow_api.id(18548345795687704)
,p_name=>'START_DATE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'START_DATE'
,p_data_type=>'DATE'
,p_is_query_only=>true
,p_item_type=>'NATIVE_DATE_PICKER'
,p_heading=>'Start Date'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>130
,p_value_alignment=>'CENTER'
,p_attribute_04=>'button'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
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
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18548998515687704)
,p_name=>'END_DATE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'END_DATE'
,p_data_type=>'DATE'
,p_is_query_only=>true
,p_item_type=>'NATIVE_DATE_PICKER'
,p_heading=>'End Date'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>140
,p_value_alignment=>'CENTER'
,p_attribute_04=>'button'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
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
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18549501874687704)
,p_name=>'CREATED_ON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATED_ON'
,p_data_type=>'TIMESTAMP'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER'
,p_heading=>'Created On'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>150
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18550182027687705)
,p_name=>'CREATED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATED_BY'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Created By'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>160
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18550727325687705)
,p_name=>'UPDATED_ON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED_ON'
,p_data_type=>'TIMESTAMP'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER'
,p_heading=>'Updated On'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>170
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18551392865687705)
,p_name=>'UPDATED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED_BY'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Updated By'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>180
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_interactive_grid(
 p_id=>wwv_flow_api.id(18540683728687495)
,p_internal_uid=>18540683728687495
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
 p_id=>wwv_flow_api.id(18541046023687495)
,p_interactive_grid_id=>wwv_flow_api.id(18540683728687495)
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_api.create_ig_report_view(
 p_id=>wwv_flow_api.id(18541147030687495)
,p_report_id=>wwv_flow_api.id(18541046023687495)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18542202102687499)
,p_view_id=>wwv_flow_api.id(18541147030687495)
,p_display_seq=>0
,p_column_id=>wwv_flow_api.id(18541821934687498)
,p_is_visible=>false
,p_is_frozen=>true
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18542854131687500)
,p_view_id=>wwv_flow_api.id(18541147030687495)
,p_display_seq=>1
,p_column_id=>wwv_flow_api.id(18542440330687499)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18543396163687701)
,p_view_id=>wwv_flow_api.id(18541147030687495)
,p_display_seq=>2
,p_column_id=>wwv_flow_api.id(18543075027687700)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18543919899687701)
,p_view_id=>wwv_flow_api.id(18541147030687495)
,p_display_seq=>4
,p_column_id=>wwv_flow_api.id(18543544889687701)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>68.25
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18544507936687702)
,p_view_id=>wwv_flow_api.id(18541147030687495)
,p_display_seq=>5
,p_column_id=>wwv_flow_api.id(18544115668687701)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18545108769687702)
,p_view_id=>wwv_flow_api.id(18541147030687495)
,p_display_seq=>6
,p_column_id=>wwv_flow_api.id(18544786833687702)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>323.75
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18545763582687702)
,p_view_id=>wwv_flow_api.id(18541147030687495)
,p_display_seq=>7
,p_column_id=>wwv_flow_api.id(18545359564687702)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18546396590687703)
,p_view_id=>wwv_flow_api.id(18541147030687495)
,p_display_seq=>8
,p_column_id=>wwv_flow_api.id(18545932412687702)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18546945272687703)
,p_view_id=>wwv_flow_api.id(18541147030687495)
,p_display_seq=>9
,p_column_id=>wwv_flow_api.id(18546573220687703)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18547551941687703)
,p_view_id=>wwv_flow_api.id(18541147030687495)
,p_display_seq=>10
,p_column_id=>wwv_flow_api.id(18547188568687703)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>194.75
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18548142714687704)
,p_view_id=>wwv_flow_api.id(18541147030687495)
,p_display_seq=>19
,p_column_id=>wwv_flow_api.id(18547788265687703)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>65
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18548773673687704)
,p_view_id=>wwv_flow_api.id(18541147030687495)
,p_display_seq=>20
,p_column_id=>wwv_flow_api.id(18548345795687704)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18549325669687704)
,p_view_id=>wwv_flow_api.id(18541147030687495)
,p_display_seq=>21
,p_column_id=>wwv_flow_api.id(18548998515687704)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18549991829687705)
,p_view_id=>wwv_flow_api.id(18541147030687495)
,p_display_seq=>11
,p_column_id=>wwv_flow_api.id(18549501874687704)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18550562044687705)
,p_view_id=>wwv_flow_api.id(18541147030687495)
,p_display_seq=>12
,p_column_id=>wwv_flow_api.id(18550182027687705)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18551176821687705)
,p_view_id=>wwv_flow_api.id(18541147030687495)
,p_display_seq=>13
,p_column_id=>wwv_flow_api.id(18550727325687705)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18551773534687706)
,p_view_id=>wwv_flow_api.id(18541147030687495)
,p_display_seq=>14
,p_column_id=>wwv_flow_api.id(18551392865687705)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18562794502155174)
,p_view_id=>wwv_flow_api.id(18541147030687495)
,p_display_seq=>15
,p_column_id=>wwv_flow_api.id(18494864859956122)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18563219484155177)
,p_view_id=>wwv_flow_api.id(18541147030687495)
,p_display_seq=>16
,p_column_id=>wwv_flow_api.id(18494991886956123)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18563776874155178)
,p_view_id=>wwv_flow_api.id(18541147030687495)
,p_display_seq=>17
,p_column_id=>wwv_flow_api.id(18495000904956124)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18564260166155181)
,p_view_id=>wwv_flow_api.id(18541147030687495)
,p_display_seq=>18
,p_column_id=>wwv_flow_api.id(18495108222956125)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(18775261882160547)
,p_plug_name=>'Approved Budget By Departments - IR'
,p_region_name=>'budget_ig2'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton'
,p_plug_template=>wwv_flow_api.id(13240610854480803)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ROWID,',
'       ID,',
'       CHAPTER,',
'       SECTOR,',
'       DEPARTMENT_NAME,',
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
'       , (select round(sum(nvl(budget_2020,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P23_SCENARIO',
'          and proposed_budget.scenario_year = :P23_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET_BY_DEPARTMENT.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET_BY_DEPARTMENT.CHAPTER',
'          and proposed_budget.department_name = APPROVED_BUDGET_BY_DEPARTMENT.department_name)  Budget_2020',
'  , (select round(sum(nvl(budget_2021,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P23_SCENARIO',
'          and proposed_budget.scenario_year = :P23_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET_BY_DEPARTMENT.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET_BY_DEPARTMENT.CHAPTER',
'          and proposed_budget.department_name = APPROVED_BUDGET_BY_DEPARTMENT.department_name)  Budget_2021',
' , (select round(sum(nvl(budget_2022,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P23_SCENARIO',
'          and proposed_budget.scenario_year = :P23_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET_BY_DEPARTMENT.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET_BY_DEPARTMENT.CHAPTER',
'          and proposed_budget.department_name = APPROVED_BUDGET_BY_DEPARTMENT.department_name)  Budget_2022',
' , (select round(sum(nvl(budget_2023,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P23_SCENARIO',
'          and proposed_budget.scenario_year = :P23_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET_BY_DEPARTMENT.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET_BY_DEPARTMENT.CHAPTER',
'          and proposed_budget.department_name = APPROVED_BUDGET_BY_DEPARTMENT.department_name)  Budget_2023',
'          ',
'  from APPROVED_BUDGET_BY_DEPARTMENT',
' where SECTOR = :P23_SECTOR',
'AND PROPOSED_SCENARIO = :P23_SCENARIO',
'AND BUDGET_VERSION = :P23_VERSION',
'AND BUDGET_YEAR = :P23_BUDGET_YEAR',
'AND CHAPTER = :P23_CHAPTER'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P23_SECTOR,P23_SCENARIO,P23_VERSION,P23_BUDGET_YEAR,P23_CHAPTER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Approved Budget By Departments - IR'
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
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(18869617786282023)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>18869617786282023
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18869825687282025)
,p_db_column_name=>'ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18869994318282026)
,p_db_column_name=>'CHAPTER'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Chapter'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18870036440282027)
,p_db_column_name=>'SECTOR'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18870156234282028)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Department Name'
,p_column_link=>'f?p=&APP_ID.:24:&SESSION.::&DEBUG.:24:P24_SECTOR,P24_CHAPTER,P24_BUDGET_YEAR,P24_SCENARIO,P24_VERSION,P24_DEPARTMENT_NAME:#SECTOR#,#CHAPTER#,#BUDGET_YEAR#,#PROPOSED_SCENARIO#,#BUDGET_VERSION#,#DEPARTMENT_NAME#'
,p_column_linktext=>'#DEPARTMENT_NAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18870217469282029)
,p_db_column_name=>'BUDGET_YEAR'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Budget Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18870345326282030)
,p_db_column_name=>'PROPOSED_SCENARIO'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Proposed Scenario'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18870435241282031)
,p_db_column_name=>'BUDGET_VERSION'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Budget Version'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18870570945282032)
,p_db_column_name=>'APPROVED_AMOUNT'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Approved Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18870685897282033)
,p_db_column_name=>'STATUS'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18870768091282034)
,p_db_column_name=>'START_DATE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18870859974282035)
,p_db_column_name=>'END_DATE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18870999690282036)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18871092561282037)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18871182295282038)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18871217216282039)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18871353305282040)
,p_db_column_name=>'BUDGET_2020'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Budget 2020'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18871499159282041)
,p_db_column_name=>'BUDGET_2021'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Budget 2021'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18871546363282042)
,p_db_column_name=>'BUDGET_2022'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Budget 2022'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18871637272282043)
,p_db_column_name=>'BUDGET_2023'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Budget 2023'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(18905970424128576)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'189060'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CHAPTER:DEPARTMENT_NAME:APPROVED_AMOUNT:BUDGET_2020:BUDGET_2021:BUDGET_2022:BUDGET_2023:STATUS:START_DATE:END_DATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(18674377480804805)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(18539593933687493)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(13304710257480854)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:22:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18494329083956117)
,p_name=>'P23_SECTOR'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(18495225626956126)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Sector :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(13303312112480851)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18494517796956119)
,p_name=>'P23_SCENARIO'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(18539593933687493)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18494651815956120)
,p_name=>'P23_VERSION'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(18539593933687493)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18494717924956121)
,p_name=>'P23_BUDGET_YEAR'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(18495225626956126)
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
 p_id=>wwv_flow_api.id(18495310604956127)
,p_name=>'P23_TOTAL_SECTOR_APPROVED_BUDGET'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(18495225626956126)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Total Sector Approved Budget: </span>'
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
 p_id=>wwv_flow_api.id(18495466908956128)
,p_name=>'P23_TOTAL_ALLOCATED'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(18495225626956126)
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
 p_id=>wwv_flow_api.id(18495586434956129)
,p_name=>'P23_CHAPTER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(18495225626956126)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Chapter :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(13303312112480851)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18496274253956136)
,p_name=>'P23_REMAINING'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(18495225626956126)
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
 p_id=>wwv_flow_api.id(18496330092956137)
,p_name=>'P23_TOTAL_SECTOR_APPROVED_BUDGET_H'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(18495225626956126)
,p_item_default=>'P23_TOTAL_SECTOR_APPROVED_BUDGET'
,p_item_default_type=>'ITEM'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18675234288804814)
,p_name=>'P23_TOTAL_ALLOCATED_H'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(18495225626956126)
,p_display_as=>'NATIVE_HIDDEN'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18675428911804816)
,p_name=>'P23_REMAINING_H'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(18495225626956126)
,p_display_as=>'NATIVE_HIDDEN'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18866749724261710)
,p_name=>'P23_UPDATE'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(18495225626956126)
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
 p_id=>wwv_flow_api.id(18495667399956130)
,p_computation_sequence=>10
,p_computation_item=>'P23_TOTAL_SECTOR_APPROVED_BUDGET'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  to_char(sum(nvl(APPROVED_AMOUNT,0)),''99,999,999,999,999.99'')',
'          ',
'  from APPROVED_BUDGET',
' where BUDGET_YEAR = :P23_BUDGET_YEAR',
'and PROPOSED_SCENARIO = :P23_SCENARIO',
'and BUDGET_VERSION = :P23_VERSION',
'and sector = :P23_SECTOR',
'and chapter = :P23_CHAPTER'))
,p_computation_error_message=>'error while calculate P23_TOTAL_SECTOR_APPROVED_BUDGET'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(18675336794804815)
,p_computation_sequence=>10
,p_computation_item=>'P23_TOTAL_ALLOCATED_H'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  sum(nvl(APPROVED_AMOUNT,0))',
'          ',
'  from approved_budget_by_department',
' where BUDGET_YEAR = :P23_BUDGET_YEAR',
'and PROPOSED_SCENARIO = :P23_SCENARIO',
'and BUDGET_VERSION = :P23_VERSION',
'and sector = :P23_SECTOR',
'and chapter = :P23_CHAPTER'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(18495703961956131)
,p_computation_sequence=>20
,p_computation_item=>'P23_TOTAL_ALLOCATED'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  to_char(sum(nvl(APPROVED_AMOUNT,0)),''99,999,999,999,999.99'') || '' AED'' ',
'          ',
'  from approved_budget_by_department',
' where BUDGET_YEAR = :P23_BUDGET_YEAR',
'and PROPOSED_SCENARIO = :P23_SCENARIO',
'and BUDGET_VERSION = :P23_VERSION',
'and sector = :P23_SECTOR',
'and chapter = :P23_CHAPTER'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(18496671486956140)
,p_computation_sequence=>30
,p_computation_item=>'P23_TOTAL_SECTOR_APPROVED_BUDGET_H'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  sum(nvl(APPROVED_AMOUNT,0))',
'          ',
'  from APPROVED_BUDGET',
' where BUDGET_YEAR = :P23_BUDGET_YEAR',
'and PROPOSED_SCENARIO = :P23_SCENARIO',
'and BUDGET_VERSION = :P23_VERSION',
'and sector = :P23_SECTOR',
'and chapter = :P23_CHAPTER'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(18675629853804818)
,p_name=>'New_1'
,p_event_sequence=>20
,p_triggering_element_type=>'COLUMN'
,p_triggering_region_id=>wwv_flow_api.id(18540188627687494)
,p_triggering_element=>'APPROVED_AMOUNT'
,p_bind_type=>'bind'
,p_bind_event_type=>'focusout'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(18675711602804819)
,p_event_id=>wwv_flow_api.id(18675629853804818)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_REMAINING_H'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(18675085570804812)
,p_name=>'New'
,p_event_sequence=>30
,p_triggering_element_type=>'COLUMN'
,p_triggering_region_id=>wwv_flow_api.id(18540188627687494)
,p_triggering_element=>'APPROVED_AMOUNT'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'Number($v("P23_REMAINING_H")) > 0'
,p_bind_type=>'live'
,p_bind_event_type=>'focusout'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(18675172527804813)
,p_event_id=>wwv_flow_api.id(18675085570804812)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Warning, you are exceed the total department approved budget amount.',
'please review your budget distribution'))
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(18675811337804820)
,p_event_id=>wwv_flow_api.id(18675085570804812)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'False, Warning, you are exceed the total department approved budget amount.',
'please review your budget distribution'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(18869451861282021)
,p_name=>'Enable IG'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P23_UPDATE'
,p_condition_element=>'P23_UPDATE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'N'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(18869518033282022)
,p_event_id=>wwv_flow_api.id(18869451861282021)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(18775261882160547)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(18871983732282046)
,p_event_id=>wwv_flow_api.id(18869451861282021)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(18540188627687494)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(18871738636282044)
,p_event_id=>wwv_flow_api.id(18869451861282021)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(18775261882160547)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(18871891652282045)
,p_event_id=>wwv_flow_api.id(18869451861282021)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(18540188627687494)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(18551956164687706)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(18540188627687494)
,p_process_type=>'NATIVE_IG_DML'
,p_process_name=>'Approved Budget By Departments - Save Interactive Grid Data'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
