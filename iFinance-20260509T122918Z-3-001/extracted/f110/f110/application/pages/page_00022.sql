prompt --application/pages/page_00022
begin
--   Manifest
--     PAGE: 00022
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
 p_id=>22
,p_user_interface_id=>wwv_flow_api.id(13327188105480887)
,p_name=>'Approved Budget Details'
,p_alias=>'APPROVED-BUDGET-DETAILS'
,p_step_title=>'Approved Budget Details'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_api.id(18536481291491103)
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(function($) {',
'    function update(model) {',
'        var budgetKey = model.getFieldKey("APPROVED_AMOUNT"), ',
'            total = 0;',
'',
'        console.log(">> starting sum APPROVED_AMOUNT column")',
'        model.forEach(function(record, index, id) {',
'            var APPROVED_AMOUNT = parseFloat(record[budgetKey]),  ',
'                meta = model.getRecordMetadata(id);',
'',
'            if (!isNaN(APPROVED_AMOUNT) && !meta.deleted && !meta.agg) {',
'                total += APPROVED_AMOUNT;',
'            }',
'        });',
'        console.log(">> setting sum APPROVED_AMOUNT column to " + total)',
'        $s("P22_TOTAL_BUDGET", Number(total).toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, ''$1,''));  ',
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
'                    progressView: $("#P22_TOTAL_BUDGET") ',
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
,p_last_upd_yyyymmddhh24miss=>'20210112133050'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(18454175054871323)
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
 p_id=>wwv_flow_api.id(18454758010871324)
,p_plug_name=>'Approved Budget Details IG'
,p_region_name=>'budget_ig'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(13240610854480803)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       CHAPTER,',
'       SECTOR,',
'       STATUS,',
'       START_DATE,',
'       END_DATE,',
'       BUDGET_YEAR,',
'       PROPOSED_SCENARIO,',
'       APPROVED_AMOUNT,',
'       CREATED_ON,',
'       CREATED_BY,',
'       UPDATED_ON,',
'       UPDATED_BY,',
'       UPDATE_ALLOWED,',
'       BUDGET_VERSION   ',
'       , (select round(sum(nvl(budget_2020,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P22_SCENARIO',
'          and proposed_budget.scenario_year = :P22_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET.CHAPTER)  Budget_2020',
'      , (select round(sum(nvl(budget_2021,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P22_SCENARIO',
'          and proposed_budget.scenario_year = :P22_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET.CHAPTER)  Budget_2021',
'     , (select round(sum(nvl(budget_2022,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P22_SCENARIO',
'          and proposed_budget.scenario_year = :P22_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET.CHAPTER)  Budget_2022',
'     , (select round(sum(nvl(budget_2023,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P22_SCENARIO',
'          and proposed_budget.scenario_year = :P22_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET.CHAPTER)  Budget_2023           ',
'  from APPROVED_BUDGET',
' where BUDGET_YEAR = :P22_BUDGET_YEAR',
'and PROPOSED_SCENARIO = :P22_SCENARIO',
'and BUDGET_VERSION = :P22_VERSION'))
,p_plug_source_type=>'NATIVE_IG'
,p_ajax_items_to_submit=>'P22_BUDGET_YEAR,P22_VERSION,P22_SCENARIO'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Approved Budget Details IG'
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
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18432397476280640)
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
,p_is_primary_key=>true
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18432468632280641)
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
,p_is_primary_key=>false
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18432550797280642)
,p_name=>'SECTOR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SECTOR'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_LINK'
,p_heading=>'Sector'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>50
,p_value_alignment=>'LEFT'
,p_link_target=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.:23:P23_SECTOR,P23_SCENARIO,P23_BUDGET_YEAR,P23_VERSION,P23_CHAPTER:&SECTOR.,&PROPOSED_SCENARIO.,&BUDGET_YEAR.,&BUDGET_VERSION.,&CHAPTER.'
,p_link_text=>'&SECTOR.'
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18432616202280643)
,p_name=>'STATUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'STATUS'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Status'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>70
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
 p_id=>wwv_flow_api.id(18432781334280644)
,p_name=>'START_DATE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'START_DATE'
,p_data_type=>'DATE'
,p_is_query_only=>true
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Start Date'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>80
,p_value_alignment=>'LEFT'
,p_attribute_02=>'VALUE'
,p_format_mask=>'DD-MON-YYYY'
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
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18432868416280645)
,p_name=>'END_DATE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'END_DATE'
,p_data_type=>'DATE'
,p_is_query_only=>true
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'End Date'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>90
,p_value_alignment=>'LEFT'
,p_attribute_02=>'VALUE'
,p_format_mask=>'DD-MON-YYYY'
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
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18432925434280646)
,p_name=>'BUDGET_YEAR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET_YEAR'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Budget Year'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>100
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
,p_is_primary_key=>false
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18433011140280647)
,p_name=>'PROPOSED_SCENARIO'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PROPOSED_SCENARIO'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Proposed Scenario'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>110
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
,p_is_primary_key=>false
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18433174835280648)
,p_name=>'APPROVED_AMOUNT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'APPROVED_AMOUNT'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Approved Amount'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>60
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
 p_id=>wwv_flow_api.id(18433243541280649)
,p_name=>'CREATED_ON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATED_ON'
,p_data_type=>'TIMESTAMP'
,p_is_query_only=>true
,p_item_type=>'NATIVE_DATE_PICKER'
,p_heading=>'Created On'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>120
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
 p_id=>wwv_flow_api.id(18433303188280650)
,p_name=>'CREATED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATED_BY'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Created By'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>130
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
 p_id=>wwv_flow_api.id(18492765528956101)
,p_name=>'UPDATED_ON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED_ON'
,p_data_type=>'TIMESTAMP'
,p_is_query_only=>true
,p_item_type=>'NATIVE_DATE_PICKER'
,p_heading=>'Updated On'
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
 p_id=>wwv_flow_api.id(18492884264956102)
,p_name=>'UPDATED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED_BY'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Updated By'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>150
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
 p_id=>wwv_flow_api.id(18492945363956103)
,p_name=>'BUDGET_VERSION'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET_VERSION'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Budget Version'
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18493064888956104)
,p_name=>'APEX$ROW_ACTION'
,p_item_type=>'NATIVE_ROW_ACTION'
,p_display_sequence=>20
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18493108619956105)
,p_name=>'APEX$ROW_SELECTOR'
,p_item_type=>'NATIVE_ROW_SELECTOR'
,p_display_sequence=>10
,p_attribute_01=>'Y'
,p_attribute_02=>'Y'
,p_attribute_03=>'N'
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(18493722816956111)
,p_name=>'BUDGET_2020'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET_2020'
,p_data_type=>'NUMBER'
,p_is_query_only=>true
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Proposal 2020'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>170
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
 p_id=>wwv_flow_api.id(18493800288956112)
,p_name=>'BUDGET_2021'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET_2021'
,p_data_type=>'NUMBER'
,p_is_query_only=>true
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Proposal 2021'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>180
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
 p_id=>wwv_flow_api.id(18493926312956113)
,p_name=>'BUDGET_2022'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET_2022'
,p_data_type=>'NUMBER'
,p_is_query_only=>true
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Proposal 2022'
,p_heading_alignment=>'CENTER'
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
 p_id=>wwv_flow_api.id(18494034418956114)
,p_name=>'BUDGET_2023'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET_2023'
,p_data_type=>'NUMBER'
,p_is_query_only=>true
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Proposal 2023'
,p_heading_alignment=>'CENTER'
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
 p_id=>wwv_flow_api.id(18677509606804837)
,p_name=>'UPDATE_ALLOWED'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATE_ALLOWED'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>210
,p_attribute_01=>'Y'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_api.create_interactive_grid(
 p_id=>wwv_flow_api.id(18432208342280639)
,p_internal_uid=>18432208342280639
,p_is_editable=>true
,p_edit_operations=>'u:d'
,p_edit_row_operations_column=>'UPDATE_ALLOWED'
,p_lost_update_check_type=>'VALUES'
,p_submit_checked_rows=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>true
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
 p_id=>wwv_flow_api.id(18498938822957978)
,p_interactive_grid_id=>wwv_flow_api.id(18432208342280639)
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>false
);
wwv_flow_api.create_ig_report_view(
 p_id=>wwv_flow_api.id(18499083151957979)
,p_report_id=>wwv_flow_api.id(18498938822957978)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18499523871957984)
,p_view_id=>wwv_flow_api.id(18499083151957979)
,p_display_seq=>1
,p_column_id=>wwv_flow_api.id(18432397476280640)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18500083999957986)
,p_view_id=>wwv_flow_api.id(18499083151957979)
,p_display_seq=>5
,p_column_id=>wwv_flow_api.id(18432468632280641)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>91.333
,p_sort_order=>1
,p_sort_direction=>'ASC'
,p_sort_nulls=>'LAST'
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18500585172957989)
,p_view_id=>wwv_flow_api.id(18499083151957979)
,p_display_seq=>6
,p_column_id=>wwv_flow_api.id(18432550797280642)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>199.5556
,p_sort_order=>2
,p_sort_direction=>'ASC'
,p_sort_nulls=>'LAST'
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18501029451957991)
,p_view_id=>wwv_flow_api.id(18499083151957979)
,p_display_seq=>12
,p_column_id=>wwv_flow_api.id(18432616202280643)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>109.25
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18501572967957993)
,p_view_id=>wwv_flow_api.id(18499083151957979)
,p_display_seq=>13
,p_column_id=>wwv_flow_api.id(18432781334280644)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>167.5
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18502085456957995)
,p_view_id=>wwv_flow_api.id(18499083151957979)
,p_display_seq=>14
,p_column_id=>wwv_flow_api.id(18432868416280645)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18502542178957997)
,p_view_id=>wwv_flow_api.id(18499083151957979)
,p_display_seq=>2
,p_column_id=>wwv_flow_api.id(18432925434280646)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18503084678957999)
,p_view_id=>wwv_flow_api.id(18499083151957979)
,p_display_seq=>15
,p_column_id=>wwv_flow_api.id(18433011140280647)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18503587015958001)
,p_view_id=>wwv_flow_api.id(18499083151957979)
,p_display_seq=>7
,p_column_id=>wwv_flow_api.id(18433174835280648)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>150.22199999999998
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18504026313958003)
,p_view_id=>wwv_flow_api.id(18499083151957979)
,p_display_seq=>16
,p_column_id=>wwv_flow_api.id(18433243541280649)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18504582772958005)
,p_view_id=>wwv_flow_api.id(18499083151957979)
,p_display_seq=>17
,p_column_id=>wwv_flow_api.id(18433303188280650)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18505040294958007)
,p_view_id=>wwv_flow_api.id(18499083151957979)
,p_display_seq=>18
,p_column_id=>wwv_flow_api.id(18492765528956101)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18505566396958009)
,p_view_id=>wwv_flow_api.id(18499083151957979)
,p_display_seq=>19
,p_column_id=>wwv_flow_api.id(18492884264956102)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18506064526958011)
,p_view_id=>wwv_flow_api.id(18499083151957979)
,p_display_seq=>3
,p_column_id=>wwv_flow_api.id(18492945363956103)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18506546572958013)
,p_view_id=>wwv_flow_api.id(18499083151957979)
,p_display_seq=>0
,p_column_id=>wwv_flow_api.id(18493064888956104)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18529659189427957)
,p_view_id=>wwv_flow_api.id(18499083151957979)
,p_display_seq=>8
,p_column_id=>wwv_flow_api.id(18493722816956111)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18532315739452174)
,p_view_id=>wwv_flow_api.id(18499083151957979)
,p_display_seq=>9
,p_column_id=>wwv_flow_api.id(18493800288956112)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18532807319452176)
,p_view_id=>wwv_flow_api.id(18499083151957979)
,p_display_seq=>10
,p_column_id=>wwv_flow_api.id(18493926312956113)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18533393429452177)
,p_view_id=>wwv_flow_api.id(18499083151957979)
,p_display_seq=>11
,p_column_id=>wwv_flow_api.id(18494034418956114)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(18725668158314917)
,p_view_id=>wwv_flow_api.id(18499083151957979)
,p_display_seq=>20
,p_column_id=>wwv_flow_api.id(18677509606804837)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_aggregate(
 p_id=>wwv_flow_api.id(88805000001)
,p_view_id=>wwv_flow_api.id(18499083151957979)
,p_function=>'SUM'
,p_column_id=>wwv_flow_api.id(18433174835280648)
,p_show_grand_total=>false
,p_is_enabled=>true
);
wwv_flow_api.create_ig_report_aggregate(
 p_id=>wwv_flow_api.id(104233000000)
,p_view_id=>wwv_flow_api.id(18499083151957979)
,p_function=>'SUM'
,p_column_id=>wwv_flow_api.id(18493722816956111)
,p_show_grand_total=>false
,p_is_enabled=>true
);
wwv_flow_api.create_ig_report_aggregate(
 p_id=>wwv_flow_api.id(242617000462)
,p_view_id=>wwv_flow_api.id(18499083151957979)
,p_function=>'SUM'
,p_column_id=>wwv_flow_api.id(18493800288956112)
,p_show_grand_total=>false
,p_is_enabled=>true
);
wwv_flow_api.create_ig_report_aggregate(
 p_id=>wwv_flow_api.id(354370000841)
,p_view_id=>wwv_flow_api.id(18499083151957979)
,p_function=>'SUM'
,p_column_id=>wwv_flow_api.id(18493926312956113)
,p_show_grand_total=>false
,p_is_enabled=>true
);
wwv_flow_api.create_ig_report_aggregate(
 p_id=>wwv_flow_api.id(441055001181)
,p_view_id=>wwv_flow_api.id(18499083151957979)
,p_function=>'SUM'
,p_column_id=>wwv_flow_api.id(18494034418956114)
,p_show_grand_total=>false
,p_is_enabled=>true
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(18677697956804838)
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
 p_id=>wwv_flow_api.id(18755484426094113)
,p_plug_name=>'Approved Budget Details IR'
,p_region_name=>'budget_ig2'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(13240610854480803)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       CHAPTER,',
'       SECTOR,',
'       STATUS,',
'       START_DATE,',
'       END_DATE,',
'       BUDGET_YEAR,',
'       PROPOSED_SCENARIO,',
'       APPROVED_AMOUNT,',
'       CREATED_ON,',
'       CREATED_BY,',
'       UPDATED_ON,',
'       UPDATED_BY,',
'       UPDATE_ALLOWED,',
'       BUDGET_VERSION   ',
'       , (select round(sum(nvl(budget_2020,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P22_SCENARIO',
'          and proposed_budget.scenario_year = :P22_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET.CHAPTER)  Budget_2020',
'      , (select round(sum(nvl(budget_2021,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P22_SCENARIO',
'          and proposed_budget.scenario_year = :P22_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET.CHAPTER)  Budget_2021',
'     , (select round(sum(nvl(budget_2022,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P22_SCENARIO',
'          and proposed_budget.scenario_year = :P22_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET.CHAPTER)  Budget_2022',
'     , (select round(sum(nvl(budget_2023,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P22_SCENARIO',
'          and proposed_budget.scenario_year = :P22_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET.CHAPTER)  Budget_2023           ',
'  from APPROVED_BUDGET',
' where BUDGET_YEAR = :P22_BUDGET_YEAR',
'and PROPOSED_SCENARIO = :P22_SCENARIO',
'and BUDGET_VERSION = :P22_VERSION'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P22_BUDGET_YEAR,P22_VERSION,P22_SCENARIO'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Approved Budget Details IR'
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
 p_id=>wwv_flow_api.id(18757771082094136)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>18757771082094136
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18757854506094137)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18757971835094138)
,p_db_column_name=>'CHAPTER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Chapter'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18758098114094139)
,p_db_column_name=>'SECTOR'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Sector'
,p_column_link=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.:23:P23_SECTOR,P23_SCENARIO,P23_BUDGET_YEAR,P23_VERSION,P23_CHAPTER:#SECTOR#,#PROPOSED_SCENARIO#,#BUDGET_YEAR#,#BUDGET_VERSION#,#CHAPTER#'
,p_column_linktext=>'#SECTOR#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18758186771094140)
,p_db_column_name=>'STATUS'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18758274741094141)
,p_db_column_name=>'START_DATE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18758340344094142)
,p_db_column_name=>'END_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18758460433094143)
,p_db_column_name=>'BUDGET_YEAR'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Budget Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18758598076094144)
,p_db_column_name=>'PROPOSED_SCENARIO'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Proposed Scenario'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18758624038094145)
,p_db_column_name=>'APPROVED_AMOUNT'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Approved Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18758703825094146)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18758829420094147)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18758978724094148)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18759014238094149)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18759190865094150)
,p_db_column_name=>'UPDATE_ALLOWED'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Update Allowed'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18770684748160501)
,p_db_column_name=>'BUDGET_VERSION'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Budget Version'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18770774697160502)
,p_db_column_name=>'BUDGET_2020'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Budget 2020'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18770820201160503)
,p_db_column_name=>'BUDGET_2021'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Budget 2021'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18770918961160504)
,p_db_column_name=>'BUDGET_2022'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Budget 2022'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18771000828160505)
,p_db_column_name=>'BUDGET_2023'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Budget 2023'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(18781849974161432)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'187819'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CHAPTER:SECTOR:APPROVED_AMOUNT:BUDGET_2020:BUDGET_2021:BUDGET_2022:BUDGET_2023:STATUS:START_DATE:END_DATE:'
,p_sum_columns_on_break=>'APPROVED_AMOUNT:BUDGET_2020:BUDGET_2021:BUDGET_2022:BUDGET_2023'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(18676875795804830)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(18454175054871323)
,p_button_name=>'Delete'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(13304710257480854)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_PREVIOUS'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P22_STATUS'
,p_button_condition2=>'Draft'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-trash-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(18674945260804811)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(18454175054871323)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(13304710257480854)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.:20::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(18774552124160540)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(18454175054871323)
,p_button_name=>'Sumit'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(13304710257480854)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Sumit'
,p_button_position=>'REGION_TEMPLATE_PREVIOUS'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-send'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(18677455916804836)
,p_branch_name=>'Go to 20'
,p_branch_action=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.:20::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18430918018280626)
,p_name=>'P22_BUDGET_YEAR'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(18454175054871323)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18431047491280627)
,p_name=>'P22_VERSION'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(18454175054871323)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18431190818280628)
,p_name=>'P22_SCENARIO'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(18454175054871323)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18677715031804839)
,p_name=>'P22_TOTAL_BUDGET'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(18677697956804838)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Total Budget :</span>'
,p_post_element_text=>'AED'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_tag_attributes=>'style="color:#33cc33"'
,p_field_template=>wwv_flow_api.id(13303312112480851)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18773820467160533)
,p_name=>'P22_UPDATE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(18677697956804838)
,p_item_default=>'N'
,p_prompt=>'Enable Update :'
,p_display_as=>'NATIVE_YES_NO'
,p_begin_on_new_line=>'N'
,p_read_only_when=>'P22_STATUS'
,p_read_only_when2=>'Draft'
,p_read_only_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_field_template=>wwv_flow_api.id(13303312112480851)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'APPLICATION'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18774401777160539)
,p_name=>'P22_STATUS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(18454175054871323)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(18676992519804831)
,p_name=>'Delete Approved Budget DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(18676875795804830)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(18677065473804832)
,p_event_id=>wwv_flow_api.id(18676992519804831)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'you are going to delete all approved budget records,Are you sure?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(18677129071804833)
,p_event_id=>wwv_flow_api.id(18676992519804831)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'delete from approved_budget',
'where budget_year = :P22_BUDGET_YEAR',
'and budget_version = :P22_VERSION',
'and proposed_scenario = :P22_SCENARIO;',
'',
'delete from approved_budget_by_department',
'where budget_year = :P22_BUDGET_YEAR',
'and budget_version = :P22_VERSION',
'and proposed_scenario = :P22_SCENARIO;',
'',
'delete from approved_budget_by_project',
'where budget_year = :P22_BUDGET_YEAR',
'and budget_version = :P22_VERSION',
'and proposed_scenario = :P22_SCENARIO;',
'',
'end ;'))
,p_attribute_02=>'P22_BUDGET_YEAR,P22_VERSION,P22_SCENARIO'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(18677266382804834)
,p_event_id=>wwv_flow_api.id(18676992519804831)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Deleted Successflly.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(18677360767804835)
,p_event_id=>wwv_flow_api.id(18676992519804831)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(18773931196160534)
,p_name=>'Show Hide IG'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P22_UPDATE'
,p_condition_element=>'P22_UPDATE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'N'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(18774081637160535)
,p_event_id=>wwv_flow_api.id(18773931196160534)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(18755484426094113)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(18774347020160538)
,p_event_id=>wwv_flow_api.id(18773931196160534)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(18454758010871324)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(18774171265160536)
,p_event_id=>wwv_flow_api.id(18773931196160534)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(18454758010871324)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(18774253899160537)
,p_event_id=>wwv_flow_api.id(18773931196160534)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(18755484426094113)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(18774611083160541)
,p_name=>'Submit budget'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(18774552124160540)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(18774718050160542)
,p_event_id=>wwv_flow_api.id(18774611083160541)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'you are going to submit the budget for approval before it''s published, No updates allowed after submitting. are you sure?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(18774858670160543)
,p_event_id=>wwv_flow_api.id(18774611083160541)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Begin',
'budget_allocation_pkg.submit_Approved_Budget(:P22_SCENARIO,:P22_BUDGET_YEAR,:P22_VERSION, ''Submitted'', null);',
'',
'End;'))
,p_attribute_02=>'P22_BUDGET_YEAR,P22_VERSION,P22_SCENARIO'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(18775084785160545)
,p_event_id=>wwv_flow_api.id(18774611083160541)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(18774997366160544)
,p_event_id=>wwv_flow_api.id(18774611083160541)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Budget has been submitted successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(18493246038956106)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(18454758010871324)
,p_process_type=>'NATIVE_IG_DML'
,p_process_name=>'Approved Budget Details - Save Interactive Grid Data'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
