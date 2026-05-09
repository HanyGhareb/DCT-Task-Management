prompt --application/pages/page_00059
begin
--   Manifest
--     PAGE: 00059
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
 p_id=>59
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Budget Allocation Plan Details'
,p_alias=>'BUDGET-ALLOCATION-PLAN-DETAILS'
,p_step_title=>'Budget Allocation Plan Details'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240118132044'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(70964637266791682)
,p_plug_name=>'Budget Allocation Plan Details'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'BUDGET_ALLOCATION_PLANS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_read_only_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_plug_read_only_when=>'P59_STATUS'
,p_plug_read_only_when2=>'Draft'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(71030793431770916)
,p_plug_name=>'Audit'
,p_parent_plug_id=>wwv_flow_api.id(70964637266791682)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P59_PLAN_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(71028678468770895)
,p_plug_name=>'Sectors'
,p_parent_plug_id=>wwv_flow_api.id(70964637266791682)
,p_icon_css_classes=>'fa-copyright'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    id,',
'    budget_allocation_plan_id,',
'    sector_id,',
'    approved_budget_ch1,',
'    allocated_budget_ch1,',
'    approved_budget_ch2,',
'    allocated_budget_ch2,',
'    approved_budget_ch3,',
'    allocated_budget_ch3,',
'    approved_budget_ch6,',
'    allocated_budget_ch6,',
'    approved_budget_ch1 + approved_budget_ch2 + approved_budget_ch3 + approved_budget_ch6 Total_Approved,',
'    allocated_budget_ch1+ allocated_budget_ch2+allocated_budget_ch3+allocated_budget_ch6  Total_allocated,',
'    status,',
'    comments,',
'    created_by,',
'    created_on,',
'    updated_by,',
'    updated_on,',
'    --live data',
'    Current_budget_ch1,',
'    Current_Encumberance_ch1,',
'    Current_actual_ch1,',
'    Current_fund_ch1,',
'    ',
'    Current_budget_ch2,',
'    Current_Encumberance_ch2,',
'    Current_actual_ch2,',
'    Current_fund_ch2,',
'    ',
'    Current_budget_ch3,',
'    Current_Encumberance_ch3,',
'    Current_actual_ch3,',
'    Current_fund_ch3,',
'    ',
'    Current_budget_ch6,',
'    Current_Encumberance_ch6,',
'    Current_actual_ch6,',
'    Current_fund_ch6',
'FROM',
'    (',
'        SELECT',
'            id,',
'            budget_allocation_plan_id,',
'            sector_id,',
'            nvl(approved_budget_ch1, 0)                                                                            approved_budget_ch1,',
'            budget_allocation_pkg.get_allocated_budget_by_sec_ch(budget_allocation_plan_id, 1, sector_id)         allocated_budget_ch1,',
'            nvl(approved_budget_ch2, 0)                                                                            approved_budget_ch2,',
'            budget_allocation_pkg.get_allocated_budget_by_sec_ch(budget_allocation_plan_id, 2, sector_id)         allocated_budget_ch2,',
'            nvl(approved_budget_ch3, 0)                                                                            approved_budget_ch3,',
'            budget_allocation_pkg.get_allocated_budget_by_sec_ch(budget_allocation_plan_id, 3, sector_id)         allocated_budget_ch3,',
'            nvl(approved_budget_ch6, 0)                                                                            approved_budget_ch6,',
'            budget_allocation_pkg.get_allocated_budget_by_sec_ch(budget_allocation_plan_id, 6, sector_id)         allocated_budget_ch6,',
'            status,',
'            comments,',
'            created_by,',
'            created_on,',
'            updated_by,',
'            updated_on',
'            ',
'            -- GET LIVE DETAILS',
'           ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 133 ,:P59_BUDGET_YEAR , ''B'' )                              Current_budget_ch1',
'           ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 133 ,:P59_BUDGET_YEAR , ''E'' )                              Current_Encumberance_ch1',
'           ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 133 ,:P59_BUDGET_YEAR , ''A'' )                              Current_actual_ch1',
'           ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 133 ,:P59_BUDGET_YEAR , ''F'' )                              Current_fund_ch1',
'           ',
'           ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 134 ,:P59_BUDGET_YEAR , ''B'' )                              Current_budget_ch2',
'           ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 134 ,:P59_BUDGET_YEAR , ''E'' )                              Current_Encumberance_ch2',
'           ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 134 ,:P59_BUDGET_YEAR , ''A'' )                              Current_actual_ch2',
'           ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 134 ,:P59_BUDGET_YEAR , ''F'' )                              Current_fund_ch2',
'           ',
'           ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 135 ,:P59_BUDGET_YEAR , ''B'' )                              Current_budget_ch3',
'           ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 135 ,:P59_BUDGET_YEAR , ''E'' )                              Current_Encumberance_ch3',
'           ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 135 ,:P59_BUDGET_YEAR , ''A'' )                              Current_actual_ch3',
'           ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 135 ,:P59_BUDGET_YEAR , ''F'' )                              Current_fund_ch3',
'           ',
'           ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 136 ,:P59_BUDGET_YEAR , ''B'' )                              Current_budget_ch6',
'           ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 136 ,:P59_BUDGET_YEAR , ''E'' )                              Current_Encumberance_ch6',
'           ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 136 ,:P59_BUDGET_YEAR , ''A'' )                              Current_actual_ch6',
'           ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 136 ,:P59_BUDGET_YEAR , ''F'' )                              Current_fund_ch6',
'           ',
'        FROM',
'            budget_allocation_sectors_plans',
'        WHERE',
'            budget_allocation_plan_id = :p59_plan_id',
'    )'))
,p_plug_source_type=>'NATIVE_IG'
,p_ajax_items_to_submit=>'P59_PLAN_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P59_PLAN_ID'
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
wwv_flow_api.create_region_column_group(
 p_id=>wwv_flow_api.id(62740310104055085)
,p_heading=>'chapter 1'
);
wwv_flow_api.create_region_column_group(
 p_id=>wwv_flow_api.id(62740210963055084)
,p_heading=>'chapter 2'
);
wwv_flow_api.create_region_column_group(
 p_id=>wwv_flow_api.id(62740074410055083)
,p_heading=>'chapter 3'
);
wwv_flow_api.create_region_column_group(
 p_id=>wwv_flow_api.id(62739954501055082)
,p_heading=>'chapter 6'
);
wwv_flow_api.create_region_column_group(
 p_id=>wwv_flow_api.id(62057162855305620)
,p_heading=>'Total'
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62742020561055102)
,p_name=>'ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_LINK'
,p_heading=>'edit'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>10
,p_value_alignment=>'CENTER'
,p_link_target=>'f?p=&APP_ID.:61:&SESSION.::&DEBUG.::P61_ID,P61_PLAN_ID_H:&ID.,&BUDGET_ALLOCATION_PLAN_ID.'
,p_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil-alt.png" class="apex-edit-pencil-alt" alt="">'
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
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P59_STATUS in (''Draft'' ,''Returned'')'
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62741892222055101)
,p_name=>'BUDGET_ALLOCATION_PLAN_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET_ALLOCATION_PLAN_ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Budget Allocation Plan Id'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>20
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62741793668055100)
,p_name=>'SECTOR_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SECTOR_ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Sector'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>30
,p_value_alignment=>'LEFT'
,p_is_required=>false
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_api.id(1216232005294941)
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_link_target=>'f?p=&APP_ID.:61:&SESSION.::&DEBUG.::P61_ID,P61_PLAN_ID_H:&ID.,&BUDGET_ALLOCATION_PLAN_ID.'
,p_link_text=>'&SECTOR_ID.'
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62741651451055099)
,p_name=>'APPROVED_BUDGET_CH1'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'APPROVED_BUDGET_CH1'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Approved'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>40
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(62740310104055085)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P59_PLAN_ID,1) = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62741613078055098)
,p_name=>'APPROVED_BUDGET_CH2'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'APPROVED_BUDGET_CH2'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Approved'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>60
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(62740210963055084)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P59_PLAN_ID,2) = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62741474479055097)
,p_name=>'APPROVED_BUDGET_CH3'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'APPROVED_BUDGET_CH3'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Approved'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>80
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(62740074410055083)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P59_PLAN_ID,3) = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62741390015055096)
,p_name=>'APPROVED_BUDGET_CH6'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'APPROVED_BUDGET_CH6'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Approved'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>100
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(62739954501055082)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P59_PLAN_ID,6) = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62741319580055095)
,p_name=>'STATUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'STATUS'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Status'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>140
,p_value_alignment=>'CENTER'
,p_attribute_02=>'VALUE'
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62741215284055094)
,p_name=>'COMMENTS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COMMENTS'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Comments'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>150
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62741035299055093)
,p_name=>'CREATED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATED_BY'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Created By'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>160
,p_value_alignment=>'LEFT'
,p_attribute_02=>'LOV'
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_api.id(48836004784526)
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62740992955055092)
,p_name=>'CREATED_ON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATED_ON'
,p_data_type=>'TIMESTAMP'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Created On'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>170
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62740879066055091)
,p_name=>'UPDATED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED_BY'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Updated By'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>180
,p_value_alignment=>'LEFT'
,p_attribute_02=>'LOV'
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_api.id(48836004784526)
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62740815457055090)
,p_name=>'UPDATED_ON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED_ON'
,p_data_type=>'TIMESTAMP'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Updated On'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>190
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62740731193055089)
,p_name=>'ALLOCATED_BUDGET_CH1'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ALLOCATED_BUDGET_CH1'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Allocated'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>50
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(62740310104055085)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P59_PLAN_ID,1) = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62740584088055088)
,p_name=>'ALLOCATED_BUDGET_CH2'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ALLOCATED_BUDGET_CH2'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Allocated'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>70
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(62740210963055084)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P59_PLAN_ID,2) = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62740439790055087)
,p_name=>'ALLOCATED_BUDGET_CH3'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ALLOCATED_BUDGET_CH3'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Allocated'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>90
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(62740074410055083)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P59_PLAN_ID,3) = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62740403763055086)
,p_name=>'ALLOCATED_BUDGET_CH6'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ALLOCATED_BUDGET_CH6'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Allocated'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>110
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(62739954501055082)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P59_PLAN_ID,6) = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62057416019305622)
,p_name=>'TOTAL_APPROVED'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TOTAL_APPROVED'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Approved'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>120
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(62057162855305620)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62057265586305621)
,p_name=>'TOTAL_ALLOCATED'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TOTAL_ALLOCATED'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Allocated'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>130
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(62057162855305620)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(61608186327333084)
,p_name=>'CURRENT_BUDGET_CH1'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_BUDGET_CH1'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Budget Ch1'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>200
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(62740310104055085)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P59_PLAN_ID,1) = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(61608049230333083)
,p_name=>'CURRENT_ENCUMBERANCE_CH1'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_ENCUMBERANCE_CH1'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Encumberance Ch1'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>210
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(62740310104055085)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P59_PLAN_ID,1) = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(61607956192333082)
,p_name=>'CURRENT_ACTUAL_CH1'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_ACTUAL_CH1'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Actual Ch1'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>220
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(62740310104055085)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P59_PLAN_ID,1) = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(61372254130166031)
,p_name=>'CURRENT_FUND_CH1'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_FUND_CH1'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Fund Ch1'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>230
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(62740310104055085)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P59_PLAN_ID,1) = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(61372184448166030)
,p_name=>'CURRENT_BUDGET_CH2'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_BUDGET_CH2'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Budget Ch2'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>240
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(62740210963055084)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P59_PLAN_ID,2) = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(61372111544166029)
,p_name=>'CURRENT_ENCUMBERANCE_CH2'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_ENCUMBERANCE_CH2'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Encumberance Ch2'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>250
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(62740210963055084)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P59_PLAN_ID,2) = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(61371985010166028)
,p_name=>'CURRENT_ACTUAL_CH2'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_ACTUAL_CH2'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Actual Ch2'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>260
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(62740210963055084)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P59_PLAN_ID,2) = ''Y'''
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
 p_id=>wwv_flow_api.id(61371898679166027)
,p_name=>'CURRENT_FUND_CH2'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_FUND_CH2'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Fund Ch2'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>270
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(62740210963055084)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P59_PLAN_ID,2) = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(61371768839166026)
,p_name=>'CURRENT_BUDGET_CH3'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_BUDGET_CH3'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Budget Ch3'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>280
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(62740074410055083)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P59_PLAN_ID,3) = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(61371654069166025)
,p_name=>'CURRENT_ENCUMBERANCE_CH3'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_ENCUMBERANCE_CH3'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Encumberance Ch3'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>290
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(62740074410055083)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P59_PLAN_ID,3) = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(61371612695166024)
,p_name=>'CURRENT_ACTUAL_CH3'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_ACTUAL_CH3'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Actual Ch3'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>300
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(62740074410055083)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P59_PLAN_ID,3) = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(61371463439166023)
,p_name=>'CURRENT_FUND_CH3'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_FUND_CH3'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Fund Ch3'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>310
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(62740074410055083)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P59_PLAN_ID,3) = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(61371365967166022)
,p_name=>'CURRENT_BUDGET_CH6'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_BUDGET_CH6'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Budget Ch6'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>320
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(62739954501055082)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P59_PLAN_ID,6) = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(61371255873166021)
,p_name=>'CURRENT_ENCUMBERANCE_CH6'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_ENCUMBERANCE_CH6'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Encumberance Ch6'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>330
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(62739954501055082)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P59_PLAN_ID,6) = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(61371143307166020)
,p_name=>'CURRENT_ACTUAL_CH6'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_ACTUAL_CH6'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Actual Ch6'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>340
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(62739954501055082)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P59_PLAN_ID,6) = ''Y'''
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(61371075080166019)
,p_name=>'CURRENT_FUND_CH6'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_FUND_CH6'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Fund Ch6'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>350
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(62739954501055082)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P59_PLAN_ID,6) = ''Y'''
);
wwv_flow_api.create_interactive_grid(
 p_id=>wwv_flow_api.id(62742067659055103)
,p_internal_uid=>150541964730129529
,p_is_editable=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>false
,p_pagination_type=>'SCROLL'
,p_show_total_row_count=>true
,p_show_toolbar=>true
,p_enable_save_public_report=>true
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
 p_id=>wwv_flow_api.id(62733573302045942)
,p_interactive_grid_id=>wwv_flow_api.id(62742067659055103)
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>false
);
wwv_flow_api.create_ig_report_view(
 p_id=>wwv_flow_api.id(62733463866045942)
,p_report_id=>wwv_flow_api.id(62733573302045942)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62732949278045941)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>0
,p_column_id=>wwv_flow_api.id(62742020561055102)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62732446651045940)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>1
,p_column_id=>wwv_flow_api.id(62741892222055101)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62731973323045937)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>2
,p_column_id=>wwv_flow_api.id(62741793668055100)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>179
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62731481527045935)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>3
,p_column_id=>wwv_flow_api.id(62741651451055099)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>86
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62730947318045933)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>4
,p_column_id=>wwv_flow_api.id(62741613078055098)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>110.993
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62730501811045932)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>10
,p_column_id=>wwv_flow_api.id(62741474479055097)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>123.52800000000002
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62730011743045930)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>9
,p_column_id=>wwv_flow_api.id(62741390015055096)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62729507514045929)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>18
,p_column_id=>wwv_flow_api.id(62741319580055095)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>89
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62728946995045927)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>17
,p_column_id=>wwv_flow_api.id(62741215284055094)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62728438597045926)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>19
,p_column_id=>wwv_flow_api.id(62741035299055093)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62728015125045920)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>20
,p_column_id=>wwv_flow_api.id(62740992955055092)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62727511378045918)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>21
,p_column_id=>wwv_flow_api.id(62740879066055091)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62726936804045917)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>22
,p_column_id=>wwv_flow_api.id(62740815457055090)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62726437688045915)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>4
,p_column_id=>wwv_flow_api.id(62740731193055089)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>87
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62725944340045913)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>5
,p_column_id=>wwv_flow_api.id(62740584088055088)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>118
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62725524275045912)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>11
,p_column_id=>wwv_flow_api.id(62740439790055087)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>123.53800000000001
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62725083818045910)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>10
,p_column_id=>wwv_flow_api.id(62740403763055086)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(61676462770331638)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>16
,p_column_id=>wwv_flow_api.id(62057416019305622)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>123.53500000000003
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(61675907036331635)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>19
,p_column_id=>wwv_flow_api.id(62057265586305621)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>138.406
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(61366360419165806)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>15
,p_column_id=>wwv_flow_api.id(61608186327333084)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(61365903762165800)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>16
,p_column_id=>wwv_flow_api.id(61608049230333083)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(61365338834165797)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>17
,p_column_id=>wwv_flow_api.id(61607956192333082)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(61364858110165795)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>18
,p_column_id=>wwv_flow_api.id(61372254130166031)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(61364424096165790)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>5
,p_column_id=>wwv_flow_api.id(61372184448166030)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(61363922303165788)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>6
,p_column_id=>wwv_flow_api.id(61372111544166029)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(61363367139165786)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>7
,p_column_id=>wwv_flow_api.id(61371985010166028)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(61362875535165766)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>8
,p_column_id=>wwv_flow_api.id(61371898679166027)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(61362423747165763)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>11
,p_column_id=>wwv_flow_api.id(61371768839166026)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(61361904642165761)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>12
,p_column_id=>wwv_flow_api.id(61371654069166025)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(61361396352165758)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>13
,p_column_id=>wwv_flow_api.id(61371612695166024)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(61360923883165756)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>14
,p_column_id=>wwv_flow_api.id(61371463439166023)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(61360381506165749)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>27
,p_column_id=>wwv_flow_api.id(61371365967166022)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(61359890703165740)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>28
,p_column_id=>wwv_flow_api.id(61371255873166021)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(61359332718165737)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>29
,p_column_id=>wwv_flow_api.id(61371143307166020)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(61358855216165734)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_display_seq=>30
,p_column_id=>wwv_flow_api.id(61371075080166019)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_highlight(
 p_id=>wwv_flow_api.id(213283893973184632)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_execution_seq=>5
,p_name=>'ch1 eq 0'
,p_column_id=>wwv_flow_api.id(62740731193055089)
,p_background_color=>'#69FFD0'
,p_condition_type=>'COLUMN'
,p_condition_column_id=>wwv_flow_api.id(62740731193055089)
,p_condition_operator=>'EQ'
,p_condition_is_case_sensitive=>false
,p_condition_expression=>'0'
,p_is_enabled=>true
);
wwv_flow_api.create_ig_report_aggregate(
 p_id=>wwv_flow_api.id(213284001008184632)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_function=>'SUM'
,p_column_id=>wwv_flow_api.id(62741651451055099)
,p_show_grand_total=>false
,p_is_enabled=>true
);
wwv_flow_api.create_ig_report_aggregate(
 p_id=>wwv_flow_api.id(213283933487184632)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_function=>'SUM'
,p_column_id=>wwv_flow_api.id(62057416019305622)
,p_show_grand_total=>true
,p_is_enabled=>true
);
wwv_flow_api.create_ig_report_aggregate(
 p_id=>wwv_flow_api.id(213283766526183012)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_function=>'SUM'
,p_column_id=>wwv_flow_api.id(62057265586305621)
,p_show_grand_total=>true
,p_is_enabled=>true
);
wwv_flow_api.create_ig_report_aggregate(
 p_id=>wwv_flow_api.id(213283523697175010)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_function=>'SUM'
,p_column_id=>wwv_flow_api.id(62740731193055089)
,p_show_grand_total=>true
,p_is_enabled=>true
);
wwv_flow_api.create_ig_report_aggregate(
 p_id=>wwv_flow_api.id(213283474341173073)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_function=>'SUM'
,p_column_id=>wwv_flow_api.id(62741613078055098)
,p_show_grand_total=>true
,p_is_enabled=>true
);
wwv_flow_api.create_ig_report_aggregate(
 p_id=>wwv_flow_api.id(213283359878172028)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_function=>'SUM'
,p_column_id=>wwv_flow_api.id(62740584088055088)
,p_show_grand_total=>true
,p_is_enabled=>true
);
wwv_flow_api.create_ig_report_aggregate(
 p_id=>wwv_flow_api.id(213283270762170777)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_function=>'SUM'
,p_column_id=>wwv_flow_api.id(62741474479055097)
,p_show_grand_total=>true
,p_is_enabled=>true
);
wwv_flow_api.create_ig_report_aggregate(
 p_id=>wwv_flow_api.id(213283160148168744)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_function=>'SUM'
,p_column_id=>wwv_flow_api.id(62740439790055087)
,p_show_grand_total=>true
,p_is_enabled=>true
);
wwv_flow_api.create_ig_report_aggregate(
 p_id=>wwv_flow_api.id(213283028886167383)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_function=>'SUM'
,p_column_id=>wwv_flow_api.id(62741390015055096)
,p_show_grand_total=>true
,p_is_enabled=>true
);
wwv_flow_api.create_ig_report_aggregate(
 p_id=>wwv_flow_api.id(213282960906166264)
,p_view_id=>wwv_flow_api.id(62733463866045942)
,p_function=>'SUM'
,p_column_id=>wwv_flow_api.id(62740403763055086)
,p_show_grand_total=>true
,p_is_enabled=>true
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(66441274849965800)
,p_plug_name=>'Detail 1'
,p_parent_plug_id=>wwv_flow_api.id(70964637266791682)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>8
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(66441159277965799)
,p_plug_name=>'Detail 2'
,p_parent_plug_id=>wwv_flow_api.id(70964637266791682)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(65412175852155406)
,p_plug_name=>'Cost Centers'
,p_parent_plug_id=>wwv_flow_api.id(70964637266791682)
,p_icon_css_classes=>'fa-pie-chart-65'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P59_PLAN_ID is not null and :P59_STATUS not in ( ''Draft'')'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(65412053440155405)
,p_plug_name=>'Cost Centers report'
,p_parent_plug_id=>wwv_flow_api.id(65412175852155406)
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       BUDGET_ALLOCATION_PLAN_ID,',
'       SECTOR_ID,',
'       COST_CENTER,',
'       nvl(approved_budget_ch1, 0)                                                                            approved_budget_ch1,',
'        budget_allocation_pkg.GET_ALLOCATED_BUDGET_BY_COST_CENTER_CH(budget_allocation_plan_id, 1, COST_CENTER)         allocated_budget_ch1,',
'        nvl(approved_budget_ch2, 0)                                                                            approved_budget_ch2,',
'        budget_allocation_pkg.GET_ALLOCATED_BUDGET_BY_COST_CENTER_CH(budget_allocation_plan_id, 2, COST_CENTER)         allocated_budget_ch2,',
'        nvl(approved_budget_ch3, 0)                                                                            approved_budget_ch3,',
'        budget_allocation_pkg.GET_ALLOCATED_BUDGET_BY_COST_CENTER_CH(budget_allocation_plan_id, 3, COST_CENTER)         allocated_budget_ch3,',
'        nvl(approved_budget_ch6, 0)                                                                            approved_budget_ch6,',
'        budget_allocation_pkg.GET_ALLOCATED_BUDGET_BY_COST_CENTER_CH(budget_allocation_plan_id, 6, COST_CENTER)         allocated_budget_ch6',
'       ',
'     -- GET LIVE DETAILS',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 133 ,:P59_BUDGET_YEAR , ''B'' )                              Current_budget_ch1',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 133 ,:P59_BUDGET_YEAR , ''E'' )                              Current_Encumberance_ch1',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 133 ,:P59_BUDGET_YEAR , ''A'' )                              Current_actual_ch1',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 133 ,:P59_BUDGET_YEAR , ''F'' )                              Current_fund_ch1',
'       ',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 134 ,:P59_BUDGET_YEAR , ''B'' )                              Current_budget_ch2',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 134 ,:P59_BUDGET_YEAR , ''E'' )                              Current_Encumberance_ch2',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 134 ,:P59_BUDGET_YEAR , ''A'' )                              Current_actual_ch2',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 134 ,:P59_BUDGET_YEAR , ''F'' )                              Current_fund_ch2',
'       ',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 135 ,:P59_BUDGET_YEAR , ''B'' )                              Current_budget_ch3',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 135 ,:P59_BUDGET_YEAR , ''E'' )                              Current_Encumberance_ch3',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 135 ,:P59_BUDGET_YEAR , ''A'' )                              Current_actual_ch3',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 135 ,:P59_BUDGET_YEAR , ''F'' )                              Current_fund_ch3',
'       ',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 136 ,:P59_BUDGET_YEAR , ''B'' )                              Current_budget_ch6',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 136 ,:P59_BUDGET_YEAR , ''E'' )                              Current_Encumberance_ch6',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 136 ,:P59_BUDGET_YEAR , ''A'' )                              Current_actual_ch6',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 136 ,:P59_BUDGET_YEAR , ''F'' )                              Current_fund_ch6',
'       ,STATUS,',
'       COMMENTS,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       SCENARIO,',
'       SCENARIO_DESC',
'  from BUDGET_ALLOCATION_COST_CENTERS_PLANS',
'  where BUDGET_ALLOCATION_PLAN_ID = :P59_PLAN_ID',
'  order by SECTOR_ID , COST_CENTER'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P59_PLAN_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Cost Centers report'
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
 p_id=>wwv_flow_api.id(63690224825492888)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>149593807563691744
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63690061415492887)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63689962042492886)
,p_db_column_name=>'BUDGET_ALLOCATION_PLAN_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Budget Allocation Plan'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(70889094180742864)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63689920354492885)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1216232005294941)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63689800703492884)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(71087570950221411)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63689703171492883)
,p_db_column_name=>'APPROVED_BUDGET_CH1'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Approved Budget Ch1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63689537448492882)
,p_db_column_name=>'APPROVED_BUDGET_CH2'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Approved Budget Ch2'
,p_column_html_expression=>'<span class="u-success">#APPROVED_BUDGET_CH2#</span>'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63209578261019631)
,p_db_column_name=>'APPROVED_BUDGET_CH3'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Approved Budget Ch3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63209442328019630)
,p_db_column_name=>'APPROVED_BUDGET_CH6'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Approved Budget Ch6'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63209341487019629)
,p_db_column_name=>'STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(780300318120911)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63209277243019628)
,p_db_column_name=>'COMMENTS'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63209230061019627)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
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
 p_id=>wwv_flow_api.id(63209109129019626)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63208984883019625)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63208877158019624)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63208746727019623)
,p_db_column_name=>'SCENARIO'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Scenario'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(70830542814082706)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63208716469019622)
,p_db_column_name=>'SCENARIO_DESC'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Scenario Desc'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59552807415972819)
,p_db_column_name=>'ALLOCATED_BUDGET_CH1'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Allocated Budget Ch1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59552640214972818)
,p_db_column_name=>'ALLOCATED_BUDGET_CH2'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Allocated Budget Ch2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59552598860972817)
,p_db_column_name=>'ALLOCATED_BUDGET_CH3'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Allocated Budget Ch3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59552435316972816)
,p_db_column_name=>'ALLOCATED_BUDGET_CH6'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Allocated Budget Ch6'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59552413698972815)
,p_db_column_name=>'CURRENT_BUDGET_CH1'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Current Budget Ch1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59552272882972814)
,p_db_column_name=>'CURRENT_ENCUMBERANCE_CH1'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Current Encumberance Ch1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59552150027972813)
,p_db_column_name=>'CURRENT_ACTUAL_CH1'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Current Actual Ch1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59552035243972812)
,p_db_column_name=>'CURRENT_FUND_CH1'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Current Fund Ch1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59551940481972811)
,p_db_column_name=>'CURRENT_BUDGET_CH2'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Current Budget Ch2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59551871112972810)
,p_db_column_name=>'CURRENT_ENCUMBERANCE_CH2'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Current Encumberance Ch2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59551776755972809)
,p_db_column_name=>'CURRENT_ACTUAL_CH2'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Current Actual Ch2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59551699667972808)
,p_db_column_name=>'CURRENT_FUND_CH2'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Current Fund Ch2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59551549639972807)
,p_db_column_name=>'CURRENT_BUDGET_CH3'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Current Budget Ch3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59551521086972806)
,p_db_column_name=>'CURRENT_ENCUMBERANCE_CH3'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Current Encumberance Ch3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59551351842972805)
,p_db_column_name=>'CURRENT_ACTUAL_CH3'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Current Actual Ch3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59551275348972804)
,p_db_column_name=>'CURRENT_FUND_CH3'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Current Fund Ch3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59551172375972803)
,p_db_column_name=>'CURRENT_BUDGET_CH6'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Current Budget Ch6'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59551082560972802)
,p_db_column_name=>'CURRENT_ENCUMBERANCE_CH6'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Current Encumberance Ch6'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59550985514972801)
,p_db_column_name=>'CURRENT_ACTUAL_CH6'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Current Actual Ch6'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(59550899501972800)
,p_db_column_name=>'CURRENT_FUND_CH6'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Current Fund Ch6'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(63192213759019322)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1500919'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SECTOR_ID:COST_CENTER:APPROVED_BUDGET_CH2:ALLOCATED_BUDGET_CH2:CURRENT_BUDGET_CH2:CURRENT_FUND_CH2:APPROVED_BUDGET_CH3:ALLOCATED_BUDGET_CH3:CURRENT_BUDGET_CH3:CURRENT_FUND_CH3:STATUS:'
,p_sum_columns_on_break=>'APPROVED_BUDGET_CH2:ALLOCATED_BUDGET_CH2:CURRENT_BUDGET_CH2:CURRENT_FUND_CH2:APPROVED_BUDGET_CH3:ALLOCATED_BUDGET_CH3:CURRENT_BUDGET_CH3:CURRENT_FUND_CH3'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(62693434351889531)
,p_plug_name=>'Cost Centers report'
,p_parent_plug_id=>wwv_flow_api.id(65412175852155406)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       BUDGET_ALLOCATION_PLAN_ID,',
'       SECTOR_ID,',
'       COST_CENTER,',
'       nvl(approved_budget_ch1, 0)                                                                            approved_budget_ch1,',
'        budget_allocation_pkg.GET_ALLOCATED_BUDGET_BY_COST_CENTER_CH(budget_allocation_plan_id, 1, COST_CENTER)         allocated_budget_ch1,',
'        nvl(approved_budget_ch2, 0)                                                                            approved_budget_ch2,',
'        budget_allocation_pkg.GET_ALLOCATED_BUDGET_BY_COST_CENTER_CH(budget_allocation_plan_id, 2, COST_CENTER)         allocated_budget_ch2,',
'        nvl(approved_budget_ch3, 0)                                                                            approved_budget_ch3,',
'        budget_allocation_pkg.GET_ALLOCATED_BUDGET_BY_COST_CENTER_CH(budget_allocation_plan_id, 3, COST_CENTER)         allocated_budget_ch3,',
'        nvl(approved_budget_ch6, 0)                                                                            approved_budget_ch6,',
'        budget_allocation_pkg.GET_ALLOCATED_BUDGET_BY_COST_CENTER_CH(budget_allocation_plan_id, 6, COST_CENTER)         allocated_budget_ch6',
'       ',
'     -- GET LIVE DETAILS',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 133 ,:P59_BUDGET_YEAR , ''B'' )                              Current_budget_ch1',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 133 ,:P59_BUDGET_YEAR , ''E'' )                              Current_Encumberance_ch1',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 133 ,:P59_BUDGET_YEAR , ''A'' )                              Current_actual_ch1',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 133 ,:P59_BUDGET_YEAR , ''F'' )                              Current_fund_ch1',
'       ',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 134 ,:P59_BUDGET_YEAR , ''B'' )                              Current_budget_ch2',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 134 ,:P59_BUDGET_YEAR , ''E'' )                              Current_Encumberance_ch2',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 134 ,:P59_BUDGET_YEAR , ''A'' )                              Current_actual_ch2',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 134 ,:P59_BUDGET_YEAR , ''F'' )                              Current_fund_ch2',
'       ',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 135 ,:P59_BUDGET_YEAR , ''B'' )                              Current_budget_ch3',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 135 ,:P59_BUDGET_YEAR , ''E'' )                              Current_Encumberance_ch3',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 135 ,:P59_BUDGET_YEAR , ''A'' )                              Current_actual_ch3',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 135 ,:P59_BUDGET_YEAR , ''F'' )                              Current_fund_ch3',
'       ',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 136 ,:P59_BUDGET_YEAR , ''B'' )                              Current_budget_ch6',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 136 ,:P59_BUDGET_YEAR , ''E'' )                              Current_Encumberance_ch6',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 136 ,:P59_BUDGET_YEAR , ''A'' )                              Current_actual_ch6',
'       ,PROJECTS_UTIL.COST_CENTER_BALANCE(COST_CENTER , 136 ,:P59_BUDGET_YEAR , ''F'' )                              Current_fund_ch6',
'       ,STATUS,',
'       COMMENTS,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       SCENARIO,',
'       SCENARIO_DESC',
'  from BUDGET_ALLOCATION_COST_CENTERS_PLANS',
'  where BUDGET_ALLOCATION_PLAN_ID = :P59_PLAN_ID'))
,p_plug_source_type=>'NATIVE_IG'
,p_ajax_items_to_submit=>'P59_PLAN_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Cost Centers report'
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
wwv_flow_api.create_region_column_group(
 p_id=>wwv_flow_api.id(59549190900972783)
,p_heading=>'Chapter 1'
);
wwv_flow_api.create_region_column_group(
 p_id=>wwv_flow_api.id(59549107699972782)
,p_heading=>'Chapter 2'
);
wwv_flow_api.create_region_column_group(
 p_id=>wwv_flow_api.id(58968543386212031)
,p_heading=>'Chapter 3'
);
wwv_flow_api.create_region_column_group(
 p_id=>wwv_flow_api.id(58968461046212030)
,p_heading=>'Chapter 6'
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62691625936889512)
,p_name=>'ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Id'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>10
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62691444698889511)
,p_name=>'BUDGET_ALLOCATION_PLAN_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET_ALLOCATION_PLAN_ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Budget Allocation Plan Id'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>20
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62691424496889510)
,p_name=>'SECTOR_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SECTOR_ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Sector'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>30
,p_value_alignment=>'LEFT'
,p_attribute_02=>'LOV'
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_api.id(1216232005294941)
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62691330705889509)
,p_name=>'COST_CENTER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COST_CENTER'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Cost Center'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>40
,p_value_alignment=>'LEFT'
,p_attribute_02=>'LOV'
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_api.id(71087570950221411)
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62691167206889508)
,p_name=>'APPROVED_BUDGET_CH1'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'APPROVED_BUDGET_CH1'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Approved Budget Ch1'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>50
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62691086908889507)
,p_name=>'APPROVED_BUDGET_CH2'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'APPROVED_BUDGET_CH2'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Approved Budget Ch2'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>60
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(59549107699972782)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62690985393889506)
,p_name=>'APPROVED_BUDGET_CH3'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'APPROVED_BUDGET_CH3'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Approved Budget Ch3'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>70
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62690930463889505)
,p_name=>'APPROVED_BUDGET_CH6'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'APPROVED_BUDGET_CH6'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Approved Budget Ch6'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>80
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62690764410889504)
,p_name=>'STATUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'STATUS'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Status'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>90
,p_value_alignment=>'CENTER'
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62690705810889503)
,p_name=>'COMMENTS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COMMENTS'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Comments'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>100
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62690607206889502)
,p_name=>'CREATED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATED_BY'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Created By'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>110
,p_value_alignment=>'LEFT'
,p_attribute_02=>'LOV'
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_api.id(48836004784526)
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62690486887889501)
,p_name=>'CREATED_ON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATED_ON'
,p_data_type=>'TIMESTAMP'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Created On'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>120
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62690372231889500)
,p_name=>'UPDATED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED_BY'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Updated By'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>130
,p_value_alignment=>'LEFT'
,p_attribute_02=>'LOV'
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_api.id(48836004784526)
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62690287484889499)
,p_name=>'UPDATED_ON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED_ON'
,p_data_type=>'TIMESTAMP'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Updated On'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>140
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62690176675889498)
,p_name=>'SCENARIO'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SCENARIO'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Scenario'
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62690070763889497)
,p_name=>'SCENARIO_DESC'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SCENARIO_DESC'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Scenario Desc'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>160
,p_value_alignment=>'LEFT'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_is_required=>false
,p_max_length=>1000
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
 p_id=>wwv_flow_api.id(62689941244889496)
,p_name=>'ALLOCATED_BUDGET_CH1'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ALLOCATED_BUDGET_CH1'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Allocated Budget Ch1'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>170
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(59549190900972783)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62689882352889495)
,p_name=>'ALLOCATED_BUDGET_CH2'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ALLOCATED_BUDGET_CH2'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Allocated Budget Ch2'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>180
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(59549107699972782)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62689772271889494)
,p_name=>'ALLOCATED_BUDGET_CH3'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ALLOCATED_BUDGET_CH3'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Allocated Budget Ch3'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>190
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(58968543386212031)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(62689714557889493)
,p_name=>'ALLOCATED_BUDGET_CH6'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ALLOCATED_BUDGET_CH6'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Allocated Budget Ch6'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>200
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(58968461046212030)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(59550740693972799)
,p_name=>'CURRENT_BUDGET_CH1'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_BUDGET_CH1'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Budget Ch1'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>210
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(59549190900972783)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(59550730669972798)
,p_name=>'CURRENT_ENCUMBERANCE_CH1'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_ENCUMBERANCE_CH1'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Encumberance Ch1'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>220
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(59549190900972783)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(59550583702972797)
,p_name=>'CURRENT_ACTUAL_CH1'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_ACTUAL_CH1'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Actual Ch1'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>230
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(59549190900972783)
,p_use_group_for=>'BOTH'
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
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(59550499089972796)
,p_name=>'CURRENT_FUND_CH1'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_FUND_CH1'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Fund Ch1'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>240
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(59549190900972783)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(59550382140972795)
,p_name=>'CURRENT_BUDGET_CH2'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_BUDGET_CH2'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Budget Ch2'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>250
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(59549107699972782)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(59550271110972794)
,p_name=>'CURRENT_ENCUMBERANCE_CH2'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_ENCUMBERANCE_CH2'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Encumberance Ch2'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>260
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(59549107699972782)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(59550198720972793)
,p_name=>'CURRENT_ACTUAL_CH2'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_ACTUAL_CH2'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Actual Ch2'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>270
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(59549107699972782)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(59550110823972792)
,p_name=>'CURRENT_FUND_CH2'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_FUND_CH2'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Fund Ch2'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>280
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(59549107699972782)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(59549944256972791)
,p_name=>'CURRENT_BUDGET_CH3'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_BUDGET_CH3'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Budget Ch3'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>290
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(58968543386212031)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(59549834240972790)
,p_name=>'CURRENT_ENCUMBERANCE_CH3'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_ENCUMBERANCE_CH3'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Encumberance Ch3'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>300
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(58968543386212031)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(59549794106972789)
,p_name=>'CURRENT_ACTUAL_CH3'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_ACTUAL_CH3'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Actual Ch3'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>310
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(58968543386212031)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(59549725310972788)
,p_name=>'CURRENT_FUND_CH3'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_FUND_CH3'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Fund Ch3'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>320
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(58968543386212031)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(59549564982972787)
,p_name=>'CURRENT_BUDGET_CH6'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_BUDGET_CH6'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Budget Ch6'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>330
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(58968461046212030)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(59549479598972786)
,p_name=>'CURRENT_ENCUMBERANCE_CH6'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_ENCUMBERANCE_CH6'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Encumberance Ch6'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>340
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(58968461046212030)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(59549379517972785)
,p_name=>'CURRENT_ACTUAL_CH6'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_ACTUAL_CH6'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Actual Ch6'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>350
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(58968461046212030)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(59549274237972784)
,p_name=>'CURRENT_FUND_CH6'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CURRENT_FUND_CH6'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Current Fund Ch6'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>360
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(58968461046212030)
,p_use_group_for=>'BOTH'
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_interactive_grid(
 p_id=>wwv_flow_api.id(62691681101889513)
,p_internal_uid=>150592351287295119
,p_is_editable=>false
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
 p_id=>wwv_flow_api.id(62687894320886214)
,p_interactive_grid_id=>wwv_flow_api.id(62691681101889513)
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_api.create_ig_report_view(
 p_id=>wwv_flow_api.id(62687752442886214)
,p_report_id=>wwv_flow_api.id(62687894320886214)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62687278133886213)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>0
,p_column_id=>wwv_flow_api.id(62691625936889512)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62686900535886212)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>1
,p_column_id=>wwv_flow_api.id(62691444698889511)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62686406854886210)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>3
,p_column_id=>wwv_flow_api.id(62691424496889510)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>163.672
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62685915356886209)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>4
,p_column_id=>wwv_flow_api.id(62691330705889509)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>413.676
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62685386095886207)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>4
,p_column_id=>wwv_flow_api.id(62691167206889508)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62684895801886206)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>14
,p_column_id=>wwv_flow_api.id(62691086908889507)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>191
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62684381551886204)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>26
,p_column_id=>wwv_flow_api.id(62690985393889506)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>171.2656
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62683855925886202)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>6
,p_column_id=>wwv_flow_api.id(62690930463889505)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62683368584886201)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>32
,p_column_id=>wwv_flow_api.id(62690764410889504)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62682850939886200)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>17
,p_column_id=>wwv_flow_api.id(62690705810889503)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62682386840886198)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>7
,p_column_id=>wwv_flow_api.id(62690607206889502)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62681883878886197)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>8
,p_column_id=>wwv_flow_api.id(62690486887889501)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62681352280886195)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>9
,p_column_id=>wwv_flow_api.id(62690372231889500)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62680880522886194)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>10
,p_column_id=>wwv_flow_api.id(62690287484889499)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62680428822886193)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>11
,p_column_id=>wwv_flow_api.id(62690176675889498)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62679847862886191)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>12
,p_column_id=>wwv_flow_api.id(62690070763889497)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62679347021886190)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>13
,p_column_id=>wwv_flow_api.id(62689941244889496)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62678926546886188)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>15
,p_column_id=>wwv_flow_api.id(62689882352889495)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62678335133886187)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>27
,p_column_id=>wwv_flow_api.id(62689772271889494)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>139.629
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(62677845846886186)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>16
,p_column_id=>wwv_flow_api.id(62689714557889493)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(58986289490223856)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>18
,p_column_id=>wwv_flow_api.id(59550740693972799)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(58985738219223853)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>19
,p_column_id=>wwv_flow_api.id(59550730669972798)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(58985320191223851)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>20
,p_column_id=>wwv_flow_api.id(59550583702972797)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(58984804732223849)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>21
,p_column_id=>wwv_flow_api.id(59550499089972796)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(58984267886223848)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>22
,p_column_id=>wwv_flow_api.id(59550382140972795)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(58983749248223846)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>24
,p_column_id=>wwv_flow_api.id(59550271110972794)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(58983245477223844)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>23
,p_column_id=>wwv_flow_api.id(59550198720972793)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(58982784831223842)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>25
,p_column_id=>wwv_flow_api.id(59550110823972792)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(58982325373223840)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>28
,p_column_id=>wwv_flow_api.id(59549944256972791)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(58981774844223838)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>28
,p_column_id=>wwv_flow_api.id(59549834240972790)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(58981296546223835)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>29
,p_column_id=>wwv_flow_api.id(59549794106972789)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(58980758581223833)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>31
,p_column_id=>wwv_flow_api.id(59549725310972788)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(58980254406223831)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>32
,p_column_id=>wwv_flow_api.id(59549564982972787)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(58979749198223829)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>33
,p_column_id=>wwv_flow_api.id(59549479598972786)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(58979289103223827)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>34
,p_column_id=>wwv_flow_api.id(59549379517972785)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(58978739182223825)
,p_view_id=>wwv_flow_api.id(62687752442886214)
,p_display_seq=>35
,p_column_id=>wwv_flow_api.id(59549274237972784)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(62743710643055119)
,p_plug_name=>'Sectors IR'
,p_parent_plug_id=>wwv_flow_api.id(70964637266791682)
,p_icon_css_classes=>'fa-copyright'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       BUDGET_ALLOCATION_PLAN_ID,',
'       SECTOR_ID,',
'       NVL(APPROVED_BUDGET_CH1,0)    APPROVED_BUDGET_CH1,',
'       NVL(APPROVED_BUDGET_CH2,0)    APPROVED_BUDGET_CH2,',
'       NVL(APPROVED_BUDGET_CH3,0)    APPROVED_BUDGET_CH3,',
'       NVL(APPROVED_BUDGET_CH6,0)    APPROVED_BUDGET_CH6,',
'       STATUS,',
'       COMMENTS,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON',
'  from BUDGET_ALLOCATION_SECTORS_PLANS',
'  where BUDGET_ALLOCATION_PLAN_ID = :P59_PLAN_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P59_PLAN_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'NEVER'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Sectors IR'
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
,p_plug_comment=>'this is duplicate report for sectors plan using IR, it''s disabled'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(62743518129055117)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:61:&SESSION.::&DEBUG.::P61_ID,P61_PLAN_ID_H:#ID#,#BUDGET_ALLOCATION_PLAN_ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>150540514260129515
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62743405870055116)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62743296164055115)
,p_db_column_name=>'BUDGET_ALLOCATION_PLAN_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Budget Allocation Plan Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62743132978055114)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1216232005294941)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62743108750055113)
,p_db_column_name=>'APPROVED_BUDGET_CH1'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Approved Budget CH1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62742973190055112)
,p_db_column_name=>'APPROVED_BUDGET_CH2'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Approved Budget CH2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62742918852055111)
,p_db_column_name=>'APPROVED_BUDGET_CH3'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Approved Budget CH3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62742829856055110)
,p_db_column_name=>'APPROVED_BUDGET_CH6'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Approved Budget CH6'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62742695181055109)
,p_db_column_name=>'STATUS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(780300318120911)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62742630571055108)
,p_db_column_name=>'COMMENTS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62742462249055107)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62742376804055106)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62742263031055105)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62742205852055104)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(62708912244031135)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1505752'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:BUDGET_ALLOCATION_PLAN_ID:SECTOR_ID:APPROVED_BUDGET_CH1:APPROVED_BUDGET_CH2:APPROVED_BUDGET_CH3:APPROVED_BUDGET_CH6:STATUS:COMMENTS:CREATED_BY:CREATED_ON:UPDATED_BY:UPDATED_ON'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(62056771490305616)
,p_plug_name=>'Documents'
,p_parent_plug_id=>wwv_flow_api.id(70964637266791682)
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>70
,p_plug_grid_column_span=>8
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P59_PLAN_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(62056475241305613)
,p_plug_name=>'Documents Report'
,p_parent_plug_id=>wwv_flow_api.id(62056771490305616)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'  SELECT',
'    id,',
'    row_version_number,',
'    plan_id,',
'    sector_id,',
'    cost_center,',
'    filename,',
'    file_mimetype,',
'    file_charset,',
'    file_blob,',
'    file_comments,',
'    tags,',
'    created_by,',
'    created,',
'    updated_by,',
'    updated,',
'    sys.dbms_lob.getlength(file_blob) as file_size,',
'    sys.dbms_lob.getlength(file_blob) as download',
'FROM',
'    budget_allocation_plans_documents',
'where plan_id = :P59_PLAN_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P59_PLAN_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Documents Report'
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
 p_id=>wwv_flow_api.id(62056428017305612)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:82:&SESSION.::&DEBUG.::P82_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>151227604371879020
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62056271781305611)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62056150175305610)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Version'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62056123690305609)
,p_db_column_name=>'PLAN_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Plan Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62055957611305608)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>40
,p_column_identifier=>'D'
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
 p_id=>wwv_flow_api.id(62055874372305607)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(71087570950221411)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62055760364305606)
,p_db_column_name=>'FILENAME'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62055638874305605)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62055598006305604)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62055510701305603)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62055408405305602)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62055305480305601)
,p_db_column_name=>'TAGS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62055178505305600)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62055049188305599)
,p_db_column_name=>'CREATED'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62055022757305598)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62054900226305597)
,p_db_column_name=>'UPDATED'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62054769355305596)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62054648839305595)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:BUDGET_ALLOCATION_PLANS_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(61624265970718152)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1516598'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:SECTOR_ID:COST_CENTER:ROW_VERSION_NUMBER:FILE_COMMENTS:TAGS:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(70936000870791708)
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
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(62743571171055118)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(62743710643055119)
,p_button_name=>'Add_1'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Add'
,p_button_position=>'BELOW_BOX'
,p_button_redirect_url=>'f?p=&APP_ID.:61:&SESSION.::&DEBUG.::P61_BUDGET_ALLOCATION_PLAN_ID,P61_SCENARIO,P61_PLAN_ID_H:&P59_PLAN_ID.,&P59_SCENARIO.,&P59_PLAN_ID.'
,p_button_condition=>':P59_PLAN_ID is not null and :P59_STATUS in (''Returned'' , ''Draft'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(70948940474791694)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(70936000870791708)
,p_button_name=>'BACK'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:58:&SESSION.::&DEBUG.:::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(70880018895360830)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(71028678468770895)
,p_button_name=>'Add'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:61:&SESSION.::&DEBUG.::P61_BUDGET_ALLOCATION_PLAN_ID,P61_SCENARIO,P61_PLAN_ID_H:&P59_PLAN_ID.,&P59_SCENARIO.,&P59_PLAN_ID.'
,p_button_condition=>':P59_PLAN_ID is not null and :P59_STATUS in (''Returned'' , ''Draft'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(62056650671305615)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(62056771490305616)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Add Attachment'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:82:&SESSION.::&DEBUG.::P82_PLAN_ID:&P59_PLAN_ID.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(70948185508791695)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(70936000870791708)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition=>':P59_PLAN_ID is not null and :person_id = 680461 and :P59_STATUS in (''Draft'' ,  ''Returned'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-trash-o'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(70947802122791695)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(70936000870791708)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>':P59_PLAN_ID is not null and :P59_STATUS in (''Returned'' , ''Draft'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(70947413198791701)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(70936000870791708)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save & Add Sectors'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P59_PLAN_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(71030626477770914)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(70936000870791708)
,p_button_name=>'Submit_sectors'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Submit to Sectors'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>':P59_STATUS = ''Draft'' and :P59_PLAN_ID is not null'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-caret-square-o-right'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(62053968173305588)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(70964637266791682)
,p_button_name=>'PLAN_SCOPE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--link:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Plan Scope'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:83:&SESSION.::&DEBUG.:83:P83_PLAN_ID,P83_PLAN_NAME,P83_TOTAL_APPROVED:&P59_PLAN_ID.,&P59_PLAN_NAME.,&P59_TOTAL.'
,p_icon_css_classes=>'fa-file-text-o'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(70878459939360815)
,p_branch_name=>'Stay in 59'
,p_branch_action=>'f?p=&APP_ID.:59:&SESSION.::&DEBUG.::P59_PLAN_ID:&P59_PLAN_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(70947413198791701)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(70879821730360828)
,p_branch_name=>'Go to 61'
,p_branch_action=>'f?p=&APP_ID.:61:&SESSION.::&DEBUG.:61:P61_BUDGET_ALLOCATION_PLAN_ID:&P59_PLAN_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(70880018895360830)
,p_branch_sequence=>20
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(71028819127770896)
,p_branch_name=>'Go To Allocation By Sector 60'
,p_branch_action=>'f?p=&APP_ID.:60:&SESSION.::&DEBUG.:60:P60_BUDGET_ALLOCATION_PLAN_ID,P60_PLAN_NAME,P60_TOTAL_APPROVED_BUDGET_CH1,P60_TOTAL_APPROVED_BUDGET_CH2,P60_TOTAL_APPROVED_BUDGET_CH3,P60_TOTAL_APPROVED_BUDGET_CH6:&P59_PLAN_ID.,&P59_PLAN_NAME.,&P59_APPROVED_BUDGET_CH1.,&P59_APPROVED_BUDGET_CH2.,&P59_APPROVED_BUDGET_CH3.,&P59_APPROVED_BUDGET_CH6.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(71030626477770914)
,p_branch_sequence=>30
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(70947078509791701)
,p_branch_name=>'Go To Page 58'
,p_branch_action=>'f?p=&APP_ID.:58:&SESSION.::&DEBUG.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>40
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(71030684156770915)
,p_name=>'P59_TOTAL'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(66441159277965799)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Total'
,p_post_element_text=>'&nbsp; AED'
,p_source=>'trim(to_char(to_number(replace(nvl(:P59_APPROVED_BUDGET_CH2,0),'','','''')) + to_number(replace(nvl(:P59_APPROVED_BUDGET_CH3,0),'','','''')) + to_number(replace(nvl(:P59_APPROVED_BUDGET_CH1,0),'','','''')) + to_number(replace(nvl(:P59_APPROVED_BUDGET_CH6,0),'','','
||''''')) , ''99,999,999,999,999.99''))'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_grid_column_css_classes=>'u-color-13'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70964314659791682)
,p_name=>'P59_PLAN_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(70964637266791682)
,p_item_source_plug_id=>wwv_flow_api.id(70964637266791682)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Plan Id'
,p_source=>'PLAN_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_label_alignment=>'RIGHT'
,p_field_template=>wwv_flow_api.id(99818469241410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70963851540791683)
,p_name=>'P59_PLAN_NAME'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(66441274849965800)
,p_item_source_plug_id=>wwv_flow_api.id(70964637266791682)
,p_prompt=>'Plan Name'
,p_source=>'PLAN_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>40
,p_cMaxlength=>128
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70963450675791683)
,p_name=>'P59_BUDGET_YEAR'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(66441159277965799)
,p_item_source_plug_id=>wwv_flow_api.id(70964637266791682)
,p_item_default=>'select extract(YEAR from sysdate) from dual;'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Budget Year'
,p_source=>'BUDGET_YEAR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>10
,p_cMaxlength=>4
,p_begin_on_new_line=>'N'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70963108435791683)
,p_name=>'P59_APPROVED_BUDGET_CH1'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(66441274849965800)
,p_item_source_plug_id=>wwv_flow_api.id(70964637266791682)
,p_prompt=>'Approved Budget Ch1'
,p_post_element_text=>'&nbsp; AED'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'APPROVED_BUDGET_CH1'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70962713302791683)
,p_name=>'P59_APPROVED_BUDGET_CH2'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(66441274849965800)
,p_item_source_plug_id=>wwv_flow_api.id(70964637266791682)
,p_prompt=>'Approved Budget Ch2'
,p_post_element_text=>'&nbsp; AED'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'APPROVED_BUDGET_CH2'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70962279457791683)
,p_name=>'P59_APPROVED_BUDGET_CH3'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(66441274849965800)
,p_item_source_plug_id=>wwv_flow_api.id(70964637266791682)
,p_prompt=>'Approved Budget Ch3'
,p_post_element_text=>'&nbsp; AED'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'APPROVED_BUDGET_CH3'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70961915468791684)
,p_name=>'P59_APPROVED_BUDGET_CH6'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(66441274849965800)
,p_item_source_plug_id=>wwv_flow_api.id(70964637266791682)
,p_prompt=>'Approved Budget Ch6'
,p_post_element_text=>'&nbsp; AED'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'APPROVED_BUDGET_CH6'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70961442636791684)
,p_name=>'P59_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(66441159277965799)
,p_item_source_plug_id=>wwv_flow_api.id(70964637266791682)
,p_item_default=>'Draft'
,p_prompt=>'Status'
,p_source=>'STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_grid_column_css_classes=>'u-success-text'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p><strong><span style="color: #0000ff;">Draft:</span></strong> initial plan status created by budget planning team. the plan will not displayed to any other planners. any changes can be done.</p>',
'<p><strong><span style="color: #0000ff;">In Process:</span></strong> The plan is submitted to sectors planners. No changes allowed.</p>',
'<p><strong><span style="color: #0000ff;">Approved:</span></strong></p>',
'<p><strong><span style="color: #0000ff;">Returned:</span></strong> Budget Planning team can return the plan for modification, changes can be done.</p>',
'<p><strong><span style="color: #0000ff;">Processed</span></strong>: The budget allocation plan is approved and uplaoded to ADERP. No changes allowed.</p>'))
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70961086391791684)
,p_name=>'P59_SUBMITTED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(66441274849965800)
,p_item_source_plug_id=>wwv_flow_api.id(70964637266791682)
,p_prompt=>'Submitted By'
,p_source=>'SUBMITTED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_grid_label_column_span=>3
,p_display_when=>'P59_STATUS'
,p_display_when2=>'Draft'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70960677231791684)
,p_name=>'P59_SUBMITTED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(66441274849965800)
,p_item_source_plug_id=>wwv_flow_api.id(70964637266791682)
,p_prompt=>'Submitted On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'SUBMITTED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_display_when=>'P59_STATUS'
,p_display_when2=>'Draft'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70959931321791690)
,p_name=>'P59_FINAL_APPROVED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(66441274849965800)
,p_item_source_plug_id=>wwv_flow_api.id(70964637266791682)
,p_prompt=>'Final Approved By'
,p_source=>'FINAL_APPROVED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_grid_label_column_span=>3
,p_display_when=>'P59_STATUS'
,p_display_when2=>'Approved'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70959434406791690)
,p_name=>'P59_FINAL_APPROVED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(66441274849965800)
,p_item_source_plug_id=>wwv_flow_api.id(70964637266791682)
,p_prompt=>'Final Approved On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'FINAL_APPROVED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_display_when=>'P59_STATUS'
,p_display_when2=>'Approved'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70958633389791690)
,p_name=>'P59_CANCELLED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(66441274849965800)
,p_item_source_plug_id=>wwv_flow_api.id(70964637266791682)
,p_prompt=>'Cancelled By'
,p_source=>'CANCELLED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_grid_label_column_span=>3
,p_display_when=>'P59_STATUS'
,p_display_when2=>'Cancelled'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70958242649791690)
,p_name=>'P59_CANCELLED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(66441274849965800)
,p_item_source_plug_id=>wwv_flow_api.id(70964637266791682)
,p_prompt=>'Cancelled On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CANCELLED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_display_when=>'P59_STATUS'
,p_display_when2=>'Cancelled'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70957516473791691)
,p_name=>'P59_CANCEL_REASON'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(66441274849965800)
,p_item_source_plug_id=>wwv_flow_api.id(70964637266791682)
,p_prompt=>'Cancel Reason'
,p_source=>'CANCEL_REASON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_display_when=>'P59_STATUS'
,p_display_when2=>'Cancelled'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70957064197791691)
,p_name=>'P59_CREATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(71030793431770916)
,p_item_source_plug_id=>wwv_flow_api.id(70964637266791682)
,p_prompt=>'Created By'
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70956685418791691)
,p_name=>'P59_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(71030793431770916)
,p_item_source_plug_id=>wwv_flow_api.id(70964637266791682)
,p_prompt=>'Created On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70955911169791691)
,p_name=>'P59_UPDATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(71030793431770916)
,p_item_source_plug_id=>wwv_flow_api.id(70964637266791682)
,p_prompt=>'Updated By'
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70955459353791691)
,p_name=>'P59_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(71030793431770916)
,p_item_source_plug_id=>wwv_flow_api.id(70964637266791682)
,p_prompt=>'Updated On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70878673252360817)
,p_name=>'P59_SCENARIO'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(66441159277965799)
,p_item_source_plug_id=>wwv_flow_api.id(70964637266791682)
,p_item_default=>'234'
,p_prompt=>'Scenario'
,p_source=>'SCENARIO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'BA SCENARIO LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 53 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10)',
''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70878622114360816)
,p_name=>'P59_SCENARIO_DESC'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(66441274849965800)
,p_item_source_plug_id=>wwv_flow_api.id(70964637266791682)
,p_prompt=>'Scenario Purpose'
,p_source=>'SCENARIO_DESC'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>1000
,p_cHeight=>2
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(69700494542622227)
,p_name=>'P59_APPROVED_BUDGET_CH1_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(66441274849965800)
,p_item_source_plug_id=>wwv_flow_api.id(70964637266791682)
,p_item_default=>'Y'
,p_prompt=>'Allocate for Chapter1 ?'
,p_source=>'APPROVED_BUDGET_CH1_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(69700354320622226)
,p_name=>'P59_APPROVED_BUDGET_CH2_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(66441274849965800)
,p_item_source_plug_id=>wwv_flow_api.id(70964637266791682)
,p_item_default=>'Y'
,p_prompt=>'Allocate for Chapter2 ?'
,p_source=>'APPROVED_BUDGET_CH2_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(69700268524622225)
,p_name=>'P59_APPROVED_BUDGET_CH3_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(66441274849965800)
,p_item_source_plug_id=>wwv_flow_api.id(70964637266791682)
,p_item_default=>'Y'
,p_prompt=>'Allocate for Chapter3 ?'
,p_source=>'APPROVED_BUDGET_CH3_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(69700194086622224)
,p_name=>'P59_APPROVED_BUDGET_CH6_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(66441274849965800)
,p_item_source_plug_id=>wwv_flow_api.id(70964637266791682)
,p_item_default=>'Y'
,p_prompt=>'Allocate for Chapter6 ?'
,p_source=>'APPROVED_BUDGET_CH6_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
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
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63208546982019621)
,p_name=>'P59_FUTURE2_USED'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(66441274849965800)
,p_item_source_plug_id=>wwv_flow_api.id(70964637266791682)
,p_prompt=>'Future2 Used'
,p_source=>'FUTURE2_USED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'FUTURE2 LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct FUTURE2_DESCRIPTION ,FUTURE2 ',
'from dct_gl_code_combinations_all',
'order by 2'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_cMaxlength=>50
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'Y'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_11=>':'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(62056983886305618)
,p_name=>'P59_FIRST_DEAD_LINE'
,p_source_data_type=>'DATE'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(66441274849965800)
,p_item_source_plug_id=>wwv_flow_api.id(70964637266791682)
,p_prompt=>'Deadline'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'FIRST_DEAD_LINE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_02=>'+1d'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(70960172733791685)
,p_validation_name=>'P59_SUBMITTED_ON must be timestamp'
,p_validation_sequence=>90
,p_validation=>'P59_SUBMITTED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(70960677231791684)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(70959014192791690)
,p_validation_name=>'P59_FINAL_APPROVED_ON must be timestamp'
,p_validation_sequence=>110
,p_validation=>'P59_FINAL_APPROVED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(70959434406791690)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(70957758468791691)
,p_validation_name=>'P59_CANCELLED_ON must be timestamp'
,p_validation_sequence=>130
,p_validation=>'P59_CANCELLED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(70958242649791690)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(70956143233791691)
,p_validation_name=>'P59_CREATED_ON must be timestamp'
,p_validation_sequence=>160
,p_validation=>'P59_CREATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(70956685418791691)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(70954945130791692)
,p_validation_name=>'P59_UPDATED_ON must be timestamp'
,p_validation_sequence=>180
,p_validation=>'P59_UPDATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(70955459353791691)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(66441076215965798)
,p_validation_name=>'Validate approved amount for selected chapters'
,p_validation_sequence=>190
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_error_msg    varchar2(1000);',
'begin',
'',
'if :P59_APPROVED_BUDGET_CH1_YN = ''Y'' and :P59_APPROVED_BUDGET_CH1 is null',
'    Then ',
'        l_error_msg := ''Please enter the approved budget for chapter 1'';',
'End if;',
'',
'if :P59_APPROVED_BUDGET_CH2_YN = ''Y'' and :P59_APPROVED_BUDGET_CH2 is null',
'    Then ',
'        l_error_msg := ''Please enter the approved budget for chapter 2'';',
'End if;',
'',
'if :P59_APPROVED_BUDGET_CH3_YN = ''Y'' and :P59_APPROVED_BUDGET_CH3 is null',
'    Then ',
'        l_error_msg := ''Please enter the approved budget for chapter 3'';',
'End if;',
'',
'if :P59_APPROVED_BUDGET_CH6_YN = ''Y'' and :P59_APPROVED_BUDGET_CH6 is null',
'    Then ',
'        l_error_msg := ''Please enter the approved budget for chapter 6'';',
'End if;',
'',
'return l_error_msg;',
'',
'End ;'))
,p_validation_type=>'FUNC_BODY_RETURNING_ERR_TEXT'
,p_when_button_pressed=>wwv_flow_api.id(70947413198791701)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(65412667252155411)
,p_validation_name=>'Allocated sector budget not exceed approved budget'
,p_validation_sequence=>200
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_error_msg    varchar2(1000) ;',
'begin',
'  ',
'  if to_number(replace(nvl(:P59_APPROVED_BUDGET_CH1,0),'','','''')) < budget_allocation_pkg.GET_ALLOCATED_BUDGET_BY_CH(:P59_PLAN_ID,1)',
'        Then    ',
'            l_error_msg := ''Allocate budget can not exceed the approved budget for chapter 1'';',
'  end if;        ',
'    ',
'  if to_number(replace(nvl(:P59_APPROVED_BUDGET_CH2,0),'','','''')) < budget_allocation_pkg.GET_ALLOCATED_BUDGET_BY_CH(:P59_PLAN_ID,2)',
'        Then    ',
'            l_error_msg := l_error_msg || '' - '' || ''Allocate budget can not exceed the approved budget for chapter 2'';',
'  end if;    ',
'        ',
'  if to_number(replace(nvl(:P59_APPROVED_BUDGET_CH3,0),'','','''')) < budget_allocation_pkg.GET_ALLOCATED_BUDGET_BY_CH(:P59_PLAN_ID,3)',
'        Then    ',
'            l_error_msg := l_error_msg || '' - '' ||''Allocate budget can not exceed the approved budget for chapter 3'';',
'  end if;',
'    ',
'  if to_number(replace(nvl(:P59_APPROVED_BUDGET_CH6,0),'','','''')) < budget_allocation_pkg.GET_ALLOCATED_BUDGET_BY_CH(:P59_PLAN_ID,6)',
'        Then    ',
'            l_error_msg := l_error_msg || '' - '' ||''Allocate budget can not exceed the approved budget for chapter 6'';',
'  end if;',
'  ',
'return l_error_msg;',
'End ;'))
,p_validation_type=>'FUNC_BODY_RETURNING_ERR_TEXT'
,p_when_button_pressed=>wwv_flow_api.id(70947802122791695)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(66440812081965795)
,p_validation_name=>'Validate Sectors Submission Process'
,p_validation_sequence=>210
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_error_msg    varchar2(1000) ;',
'begin',
'  ',
'  if budget_allocation_pkg.GET_APPROVED_BUDGET_BY_CH(:P59_PLAN_ID,1) != budget_allocation_pkg.GET_ALLOCATED_BUDGET_BY_CH(:P59_PLAN_ID,1)',
'        Then    ',
'            l_error_msg := ''Please allocate the approved budget for chapter 1'';',
'  end if;        ',
'    ',
'  if budget_allocation_pkg.GET_APPROVED_BUDGET_BY_CH(:P59_PLAN_ID,2) != budget_allocation_pkg.GET_ALLOCATED_BUDGET_BY_CH(:P59_PLAN_ID,2)',
'        Then    ',
'            l_error_msg := l_error_msg || '' - '' || ''Please allocate the approved budget for chapter 2'';',
'  end if;    ',
'        ',
'  if budget_allocation_pkg.GET_APPROVED_BUDGET_BY_CH(:P59_PLAN_ID,3) != budget_allocation_pkg.GET_ALLOCATED_BUDGET_BY_CH(:P59_PLAN_ID,3)',
'        Then    ',
'            l_error_msg := l_error_msg || '' - '' ||''Please allocate the approved budget for chapter 3'';',
'  end if;',
'    ',
'  if budget_allocation_pkg.GET_APPROVED_BUDGET_BY_CH(:P59_PLAN_ID,6) != budget_allocation_pkg.GET_ALLOCATED_BUDGET_BY_CH(:P59_PLAN_ID,6)',
'        Then    ',
'            l_error_msg := l_error_msg || '' - '' ||''Please allocate the approved budget for chapter 6'';',
'  end if;',
'  ',
'return l_error_msg;',
'End ;'))
,p_validation_type=>'FUNC_BODY_RETURNING_ERR_TEXT'
,p_when_button_pressed=>wwv_flow_api.id(71030626477770914)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(70879671402360827)
,p_name=>'Add Dialog DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(70880018895360830)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(70879540502360826)
,p_event_id=>wwv_flow_api.id(70879671402360827)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(71028678468770895)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(70879465599360825)
,p_name=>'Dialog Close 2'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(71028678468770895)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(70879347210360824)
,p_event_id=>wwv_flow_api.id(70879465599360825)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(71028678468770895)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(66442912416965816)
,p_name=>'APPROVED_BUDGET_CH1_YN DA'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P59_APPROVED_BUDGET_CH1_YN'
,p_condition_element=>'P59_APPROVED_BUDGET_CH1_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66442752150965815)
,p_event_id=>wwv_flow_api.id(66442912416965816)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P59_APPROVED_BUDGET_CH1'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66442617159965813)
,p_event_id=>wwv_flow_api.id(66442912416965816)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P59_APPROVED_BUDGET_CH1'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66442697501965814)
,p_event_id=>wwv_flow_api.id(66442912416965816)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P59_APPROVED_BUDGET_CH1'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(66442477737965812)
,p_name=>'APPROVED_BUDGET_CH2_YN DA'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P59_APPROVED_BUDGET_CH2_YN'
,p_condition_element=>'P59_APPROVED_BUDGET_CH2_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66442394147965811)
,p_event_id=>wwv_flow_api.id(66442477737965812)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P59_APPROVED_BUDGET_CH2'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66442148668965809)
,p_event_id=>wwv_flow_api.id(66442477737965812)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'APPROVED_BUDGET_CH2'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66442301452965810)
,p_event_id=>wwv_flow_api.id(66442477737965812)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P59_APPROVED_BUDGET_CH2'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(66442065051965808)
,p_name=>'APPROVED_BUDGET_CH3_YN DA'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P59_APPROVED_BUDGET_CH3_YN'
,p_condition_element=>'P59_APPROVED_BUDGET_CH3_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66442012327965807)
,p_event_id=>wwv_flow_api.id(66442065051965808)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P59_APPROVED_BUDGET_CH3'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66441817692965805)
,p_event_id=>wwv_flow_api.id(66442065051965808)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'APPROVED_BUDGET_CH3'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66441841664965806)
,p_event_id=>wwv_flow_api.id(66442065051965808)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P59_APPROVED_BUDGET_CH3'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(66441645592965804)
,p_name=>'P59_APPROVED_BUDGET_CH6_YN DA'
,p_event_sequence=>60
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P59_APPROVED_BUDGET_CH6_YN'
,p_condition_element=>'P59_APPROVED_BUDGET_CH6_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66441554419965803)
,p_event_id=>wwv_flow_api.id(66441645592965804)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P59_APPROVED_BUDGET_CH6'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66441343013965801)
,p_event_id=>wwv_flow_api.id(66441645592965804)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P59_APPROVED_BUDGET_CH6'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66441495652965802)
,p_event_id=>wwv_flow_api.id(66441645592965804)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P59_APPROVED_BUDGET_CH6'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(66441001970965797)
,p_name=>'Amount Changed'
,p_event_sequence=>70
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P59_APPROVED_BUDGET_CH2,P59_APPROVED_BUDGET_CH1,P59_APPROVED_BUDGET_CH3,P59_APPROVED_BUDGET_CH6'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66440868472965796)
,p_event_id=>wwv_flow_api.id(66441001970965797)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P59_TOTAL'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>'trim(to_char(to_number(replace(nvl(:P59_APPROVED_BUDGET_CH2,0),'','','''')) + to_number(replace(nvl(:P59_APPROVED_BUDGET_CH3,0),'','','''')) + to_number(replace(nvl(:P59_APPROVED_BUDGET_CH1,0),'','','''')) + to_number(replace(nvl(:P59_APPROVED_BUDGET_CH6,0),'','','
||''''')) , ''99,999,999,999,999.99''))'
,p_attribute_07=>'P59_APPROVED_BUDGET_CH1,P59_APPROVED_BUDGET_CH2,P59_APPROVED_BUDGET_CH3,P59_APPROVED_BUDGET_CH6'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(62054574998305594)
,p_name=>'Add attachments DA'
,p_event_sequence=>80
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(62056650671305615)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(62054472666305593)
,p_event_id=>wwv_flow_api.id(62054574998305594)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(62056475241305613)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(62054430102305592)
,p_name=>'Attachments Updates DA'
,p_event_sequence=>90
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(62056475241305613)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(62054244888305591)
,p_event_id=>wwv_flow_api.id(62054430102305592)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(62056475241305613)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(70946140297791702)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(70964637266791682)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Budget Allocation Plan Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(70946536950791702)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(70964637266791682)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Budget Allocation Plan Details'
);
wwv_flow_api.component_end;
end;
/
