prompt --application/pages/page_00004
begin
--   Manifest
--     PAGE: 00004
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
 p_id=>4
,p_user_interface_id=>wwv_flow_api.id(13327188105480887)
,p_name=>'Budget 4'
,p_alias=>'BUDGET-4'
,p_step_title=>'Budget 4'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>wwv_flow_api.id(13197741432480775)
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210105182800'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(13531209755566025)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(13251955757480809)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(13188546909480758)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(13306063834480855)
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(13531888123566026)
,p_name=>'Search Results'
,p_template=>wwv_flow_api.id(13242565869480804)
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--staticRowColors:t-Report--rowHighlight:t-Report--inline:t-Report--hideNoPagination'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select    CHAPTER',
'        , SECTOR',
'        , DEPARTMENT_NAME',
'        , COST_CENTER',
'        , ADERP_PROJECT_NAME',
'        , DCT_PROJECT_NAME',
'        , NEW_ASSETS',
'        , TYPE',
'        , EXPENSE_TYPE',
'        , ACCOUNT_NUMBER',
'        , ACCOUNT_NAME',
'        , BUDGET_2020',
'        , BUDGET_2021',
'        , BUDGET_2022',
'        , BUDGET_2023',
'        , ALLOCATION_2021',
'        , round((ALLOCATION_2021 /decode(BUDGET_2021,0 , 1,BUDGET_2021) )* 100,2) allocation_2021_PCT',
'        , (BUDGET_2021 - BUDGET_2020) budget_2020_2021_diff',
'from (select    CHAPTER',
'        , SECTOR',
'        , DEPARTMENT_NAME',
'        , COST_CENTER',
'        , ADERP_PROJECT_NAME',
'        , DCT_PROJECT_NAME',
'        , NEW_ASSETS',
'        , TYPE',
'        , EXPENSE_TYPE',
'        , ACCOUNT_NUMBER',
'        , ACCOUNT_NAME',
'        , sum(BUDGET_2020)      Budget_2020',
'        , sum(BUDGET_2021)      Budget_2021',
'        , sum(BUDGET_2022)      Budget_2022',
'        , sum(BUDGET_2023)      Budget_2023',
'        , sum(allocation_2021)  ALLOCATION_2021 ',
'from (',
'SELECT',
'     chapter',
'    ,sector',
'    ,department_name',
'    ,cost_center',
'    ,ADERP_PROJECT_NAME',
'    ,DCT_PROJECT_NAME',
'    ,new_assets',
'    ,exp_type Type',
'    ,expense_type',
'    ,account_number',
'    ,account_name',
'    ,nvl(budget_2020,0)     budget_2020',
'    ,nvl(budget_2021,0)     budget_2021',
'    ,nvl(budget_2022,0)     budget_2022',
'    ,nvl(budget_2023,0)     budget_2023',
'    ,(nvl(jan_21,0) + nvl(feb_21,0) + nvl(mar_21,0) + nvl(apr_21,0) + nvl(may_21,0) + nvl(jun_21,0) + nvl(jul_21,0) + nvl(aug_21,0) + nvl(sep_21,0) + nvl(oct_21,0) + nvl(nov_21,0) + nvl(dec_21,0))  allocation_2021',
'    ',
'FROM budget)',
'GROUP by CHAPTER, SECTOR, DEPARTMENT_NAME, COST_CENTER,ADERP_PROJECT_NAME, DCT_PROJECT_NAME, NEW_ASSETS, TYPE, EXPENSE_TYPE, ACCOUNT_NUMBER, ACCOUNT_NAME',
'ORDER by CHAPTER, SECTOR, DEPARTMENT_NAME)'))
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(13268868181480823)
,p_query_num_rows=>50
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'no data found'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_query_row_count_max=>100000
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_prn_output=>'N'
,p_prn_format=>'PDF'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13538104942566114)
,p_query_column_id=>1
,p_column_alias=>'CHAPTER'
,p_column_display_sequence=>2
,p_column_heading=>'Chapter'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13538572977566114)
,p_query_column_id=>2
,p_column_alias=>'SECTOR'
,p_column_display_sequence=>3
,p_column_heading=>'Sector'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13538968217566114)
,p_query_column_id=>3
,p_column_alias=>'DEPARTMENT_NAME'
,p_column_display_sequence=>4
,p_column_heading=>'Department Name'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13539370775566115)
,p_query_column_id=>4
,p_column_alias=>'COST_CENTER'
,p_column_display_sequence=>5
,p_column_heading=>'Cost Center'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13540576600566115)
,p_query_column_id=>5
,p_column_alias=>'ADERP_PROJECT_NAME'
,p_column_display_sequence=>6
,p_column_heading=>'Aderp Project Name'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13540944103566116)
,p_query_column_id=>6
,p_column_alias=>'DCT_PROJECT_NAME'
,p_column_display_sequence=>7
,p_column_heading=>'Dct Project Name'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13537717643566113)
,p_query_column_id=>7
,p_column_alias=>'NEW_ASSETS'
,p_column_display_sequence=>1
,p_column_heading=>'New Assets'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13463344373079133)
,p_query_column_id=>8
,p_column_alias=>'TYPE'
,p_column_display_sequence=>15
,p_column_heading=>'Type'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13542505432566117)
,p_query_column_id=>9
,p_column_alias=>'EXPENSE_TYPE'
,p_column_display_sequence=>10
,p_column_heading=>'Expense Type'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13541768278566116)
,p_query_column_id=>10
,p_column_alias=>'ACCOUNT_NUMBER'
,p_column_display_sequence=>8
,p_column_heading=>'Account Number'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13542129655566117)
,p_query_column_id=>11
,p_column_alias=>'ACCOUNT_NAME'
,p_column_display_sequence=>9
,p_column_heading=>'Account Name'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13544572033566118)
,p_query_column_id=>12
,p_column_alias=>'BUDGET_2020'
,p_column_display_sequence=>11
,p_column_heading=>'Budget 2020'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13544934597566119)
,p_query_column_id=>13
,p_column_alias=>'BUDGET_2021'
,p_column_display_sequence=>12
,p_column_heading=>'Budget 2021'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13545392555566119)
,p_query_column_id=>14
,p_column_alias=>'BUDGET_2022'
,p_column_display_sequence=>13
,p_column_heading=>'Budget 2022'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13545708011566119)
,p_query_column_id=>15
,p_column_alias=>'BUDGET_2023'
,p_column_display_sequence=>14
,p_column_heading=>'Budget 2023'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13463474643079134)
,p_query_column_id=>16
,p_column_alias=>'ALLOCATION_2021'
,p_column_display_sequence=>16
,p_column_heading=>'Allocation 2021'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13463587171079135)
,p_query_column_id=>17
,p_column_alias=>'ALLOCATION_2021_PCT'
,p_column_display_sequence=>17
,p_column_heading=>'Allocation 2021 Pct'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13463619349079136)
,p_query_column_id=>18
,p_column_alias=>'BUDGET_2020_2021_DIFF'
,p_column_display_sequence=>18
,p_column_heading=>'Budget 2020 2021 Diff'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(13531983246566026)
,p_plug_name=>'Search'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(13242565869480804)
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>4
,p_plug_display_point=>'REGION_POSITION_02'
,p_plug_source_type=>'NATIVE_FACETED_SEARCH'
,p_filtered_region_id=>wwv_flow_api.id(13531888123566026)
,p_attribute_01=>'N'
,p_attribute_06=>'E'
,p_attribute_07=>'Y'
,p_attribute_08=>'#active_facets'
,p_attribute_09=>'Y'
,p_attribute_12=>'10000'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(13536327179566030)
,p_plug_name=>'Button Bar'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noPadding:t-ButtonRegion--noUI'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(13216123905480789)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>'<div id="active_facets"></div>'
,p_plug_query_num_rows=>15
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(13536884766566030)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(13536327179566030)
,p_button_name=>'RESET'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(13304710257480854)
,p_button_image_alt=>'Reset'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:RR,4::'
,p_icon_css_classes=>'fa-undo'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13532455768566027)
,p_name=>'P4_SEARCH'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(13531983246566026)
,p_prompt=>'Search'
,p_source=>'SECTOR,DEPARTMENT_NAME,COST_CENTER,EXP_TYPE,ADERP_PROJECT_NUMBER,ADERP_PROJECT_NAME,DCT_PROJECT_NAME,NEW_ASSETS'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_SEARCH'
,p_attribute_01=>'ROW'
,p_attribute_02=>'FACET'
,p_fc_collapsible=>true
,p_fc_initial_collapsed=>false
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13532849728566027)
,p_name=>'P4_SECTOR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(13531983246566026)
,p_prompt=>'Sector'
,p_source=>'SECTOR'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_attribute_01=>'1'
,p_attribute_02=>'VERTICAL'
,p_fc_collapsible=>true
,p_fc_initial_collapsed=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>5
,p_fc_sort_by_top_counts=>true
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13533214855566027)
,p_name=>'P4_EXPENSE_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(13531983246566026)
,p_prompt=>'Expense Type'
,p_source=>'EXPENSE_TYPE'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_attribute_01=>'1'
,p_attribute_02=>'VERTICAL'
,p_fc_collapsible=>true
,p_fc_initial_collapsed=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>5
,p_fc_sort_by_top_counts=>true
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13534004073566028)
,p_name=>'P4_DEPARTMENT_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(13531983246566026)
,p_prompt=>'Department Name'
,p_source=>'DEPARTMENT_NAME'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_attribute_01=>'1'
,p_attribute_02=>'VERTICAL'
,p_fc_collapsible=>true
,p_fc_initial_collapsed=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>5
,p_fc_sort_by_top_counts=>true
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13534451152566028)
,p_name=>'P4_NEW_ASSETS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(13531983246566026)
,p_prompt=>'New Assets'
,p_source=>'NEW_ASSETS'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_attribute_01=>'1'
,p_attribute_02=>'NONE'
,p_attribute_03=>'Y'
,p_attribute_04=>'VERTICAL'
,p_attribute_05=>'N'
,p_fc_collapsible=>true
,p_fc_initial_collapsed=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>5
,p_fc_sort_by_top_counts=>true
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13534846335566029)
,p_name=>'P4_CHAPTER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(13531983246566026)
,p_prompt=>'Chapter'
,p_source=>'CHAPTER'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_attribute_01=>'1'
,p_attribute_02=>'NONE'
,p_attribute_03=>'Y'
,p_attribute_04=>'VERTICAL'
,p_attribute_05=>'N'
,p_fc_collapsible=>true
,p_fc_initial_collapsed=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>5
,p_fc_sort_by_top_counts=>true
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13535235641566029)
,p_name=>'P4_COST_CENTER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(13531983246566026)
,p_prompt=>'Cost Center'
,p_source=>'COST_CENTER'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_attribute_01=>'1'
,p_attribute_02=>'VERTICAL'
,p_fc_collapsible=>true
,p_fc_initial_collapsed=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>5
,p_fc_sort_by_top_counts=>true
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13535642904566029)
,p_name=>'P4_ADERP_PROJECT_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(13531983246566026)
,p_prompt=>'Aderp Project Name'
,p_source=>'ADERP_PROJECT_NAME'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_attribute_01=>'1'
,p_attribute_02=>'VERTICAL'
,p_fc_collapsible=>true
,p_fc_initial_collapsed=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>5
,p_fc_sort_by_top_counts=>true
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13536014171566029)
,p_name=>'P4_ACCOUNT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(13531983246566026)
,p_prompt=>'Account Number'
,p_source=>'ACCOUNT_NUMBER'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_attribute_01=>'1'
,p_attribute_02=>'VERTICAL'
,p_fc_collapsible=>true
,p_fc_initial_collapsed=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>5
,p_fc_sort_by_top_counts=>true
);
wwv_flow_api.component_end;
end;
/
