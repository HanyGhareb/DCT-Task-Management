prompt --application/pages/page_00003
begin
--   Manifest
--     PAGE: 00003
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
 p_id=>3
,p_user_interface_id=>wwv_flow_api.id(13327188105480887)
,p_name=>'Budget 2'
,p_alias=>'BUDGET-2'
,p_step_title=>'Budget 2'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>wwv_flow_api.id(13197741432480775)
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20221101163719'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(13461499634079114)
,p_plug_name=>'Summary'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(13242565869480804)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(13462110669079121)
,p_plug_name=>'By Sector'
,p_parent_plug_id=>wwv_flow_api.id(13461499634079114)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(13242565869480804)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(13462279261079122)
,p_region_id=>wwv_flow_api.id(13462110669079121)
,p_chart_type=>'pie'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'dim'
,p_value_format_type=>'decimal'
,p_value_decimal_places=>0
,p_value_format_scaling=>'none'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_value=>true
,p_legend_rendered=>'on'
,p_legend_position=>'auto'
,p_pie_other_threshold=>0
,p_pie_selection_effect=>'highlight'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(13462304766079123)
,p_chart_id=>wwv_flow_api.id(13462279261079122)
,p_seq=>10
,p_name=>'New'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select Sector , sum(BUDGET_2020) ',
'from table(get_budget_faceted_search_data(:APP_PAGE_ID, ''FC_BUDGET''))',
'group by sector;'))
,p_ajax_items_to_submit=>'P3_SECTOR,P3_CHAPTER,P3_DEPARTMENT_NAME'
,p_items_value_column_name=>'SUM(BUDGET_2020)'
,p_items_label_column_name=>'SECTOR'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'LABEL'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(13462804741079128)
,p_plug_name=>'By Sector'
,p_parent_plug_id=>wwv_flow_api.id(13461499634079114)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody:t-Form--noPadding'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(13242565869480804)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(13462940742079129)
,p_region_id=>wwv_flow_api.id(13462804741079128)
,p_chart_type=>'bar'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_connect_nulls=>'Y'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_legend_rendered=>'on'
,p_legend_position=>'auto'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(13463033555079130)
,p_chart_id=>wwv_flow_api.id(13462940742079129)
,p_seq=>10
,p_name=>'New'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select Sector , sum(BUDGET_2020) ',
'from table(get_budget_faceted_search_data(:APP_PAGE_ID, ''FC_BUDGET''))',
'group by sector;'))
,p_ajax_items_to_submit=>'P3_SECTOR,P3_CHAPTER,P3_DEPARTMENT_NAME'
,p_items_value_column_name=>'SUM(BUDGET_2020)'
,p_items_label_column_name=>'SECTOR'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(13463171300079131)
,p_chart_id=>wwv_flow_api.id(13462940742079129)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_tick_label_rotation=>'auto'
,p_tick_label_position=>'outside'
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(13463283764079132)
,p_chart_id=>wwv_flow_api.id(13462940742079129)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_format_type=>'decimal'
,p_decimal_places=>0
,p_format_scaling=>'none'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(13470041670104050)
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
 p_id=>wwv_flow_api.id(13470691471104052)
,p_name=>'Search Results'
,p_region_name=>'FC_BUDGET'
,p_template=>wwv_flow_api.id(13242565869480804)
,p_display_sequence=>30
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--hideHeader:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight:t-Report--inline:t-Report--hideNoPagination'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       NEW_ASSETS,',
'       CHAPTER,',
'       SECTOR,',
'       DEPARTMENT_NAME,',
'       COST_CENTER,',
'       EXP_TYPE,',
'       ADERP_PROJECT_NUMBER,',
'       ADERP_PROJECT_NAME,',
'       DCT_PROJECT_NAME,',
'       TASK_NAME,',
'       ACCOUNT_NUMBER,',
'       ACCOUNT_NAME,',
'       EXPENSE_TYPE,',
'       PROJECT_DESCRIPTION,',
'       DELIVERABLES_OUTCOMES,',
'       START_DATE,',
'       END_DATE,',
'       BUDGET_2020,',
'       BUDGET_2021,',
'       BUDGET_2022,',
'       BUDGET_2023,',
'       BASIS_OF_CALCULATION,',
'       JAN_21,',
'       FEB_21,',
'       MAR_21,',
'       APR_21,',
'       MAY_21,',
'       JUN_21,',
'       JUL_21,',
'       AUG_21,',
'       SEP_21,',
'       OCT_21,',
'       NOV_21,',
'       DEC_21,',
'       TOTAL,',
'       ERROR_CHECKER',
'  from BUDGET'))
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(13268868181480823)
,p_query_num_rows=>50
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'no data found'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_query_row_count_max=>100000
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'Y'
,p_prn_format=>'PDF'
,p_prn_output_link_text=>'Print'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width_units=>'PERCENTAGE'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Search Results'
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
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13476269769104102)
,p_query_column_id=>1
,p_column_alias=>'ID'
,p_column_display_sequence=>1
,p_column_heading=>'ID'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13476642451104102)
,p_query_column_id=>2
,p_column_alias=>'NEW_ASSETS'
,p_column_display_sequence=>2
,p_column_heading=>'New Assets'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13477085632104102)
,p_query_column_id=>3
,p_column_alias=>'CHAPTER'
,p_column_display_sequence=>3
,p_column_heading=>'Chapter'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13477447815104103)
,p_query_column_id=>4
,p_column_alias=>'SECTOR'
,p_column_display_sequence=>4
,p_column_heading=>'Sector'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13477819965104103)
,p_query_column_id=>5
,p_column_alias=>'DEPARTMENT_NAME'
,p_column_display_sequence=>5
,p_column_heading=>'Department Name'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13478223487104103)
,p_query_column_id=>6
,p_column_alias=>'COST_CENTER'
,p_column_display_sequence=>6
,p_column_heading=>'Cost Center'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13478624177104103)
,p_query_column_id=>7
,p_column_alias=>'EXP_TYPE'
,p_column_display_sequence=>7
,p_column_heading=>'Exp Type'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13479050813104103)
,p_query_column_id=>8
,p_column_alias=>'ADERP_PROJECT_NUMBER'
,p_column_display_sequence=>8
,p_column_heading=>'Aderp Project Number'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13479456973104104)
,p_query_column_id=>9
,p_column_alias=>'ADERP_PROJECT_NAME'
,p_column_display_sequence=>9
,p_column_heading=>'Aderp Project Name'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13479821306104104)
,p_query_column_id=>10
,p_column_alias=>'DCT_PROJECT_NAME'
,p_column_display_sequence=>10
,p_column_heading=>'Dct Project Name'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13480201951104104)
,p_query_column_id=>11
,p_column_alias=>'TASK_NAME'
,p_column_display_sequence=>11
,p_column_heading=>'Task Name'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13480649151104105)
,p_query_column_id=>12
,p_column_alias=>'ACCOUNT_NUMBER'
,p_column_display_sequence=>12
,p_column_heading=>'Account Number'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13481054527104105)
,p_query_column_id=>13
,p_column_alias=>'ACCOUNT_NAME'
,p_column_display_sequence=>13
,p_column_heading=>'Account Name'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13481434429104105)
,p_query_column_id=>14
,p_column_alias=>'EXPENSE_TYPE'
,p_column_display_sequence=>14
,p_column_heading=>'Expense Type'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13481886496104105)
,p_query_column_id=>15
,p_column_alias=>'PROJECT_DESCRIPTION'
,p_column_display_sequence=>15
,p_column_heading=>'Project Description'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13482208815104105)
,p_query_column_id=>16
,p_column_alias=>'DELIVERABLES_OUTCOMES'
,p_column_display_sequence=>16
,p_column_heading=>'Deliverables Outcomes'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13482634403104106)
,p_query_column_id=>17
,p_column_alias=>'START_DATE'
,p_column_display_sequence=>17
,p_column_heading=>'Start Date'
,p_column_alignment=>'CENTER'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13483014129104106)
,p_query_column_id=>18
,p_column_alias=>'END_DATE'
,p_column_display_sequence=>18
,p_column_heading=>'End Date'
,p_column_alignment=>'CENTER'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13483423245104106)
,p_query_column_id=>19
,p_column_alias=>'BUDGET_2020'
,p_column_display_sequence=>19
,p_column_heading=>'Budget 2020'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13483850771104106)
,p_query_column_id=>20
,p_column_alias=>'BUDGET_2021'
,p_column_display_sequence=>20
,p_column_heading=>'Budget 2021'
,p_column_format=>'999G999G999G999G999G999G999G999G999G990'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13484269786104107)
,p_query_column_id=>21
,p_column_alias=>'BUDGET_2022'
,p_column_display_sequence=>21
,p_column_heading=>'Budget 2022'
,p_column_format=>'999G999G999G999G999G999G999G999G999G990'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13484650381104107)
,p_query_column_id=>22
,p_column_alias=>'BUDGET_2023'
,p_column_display_sequence=>22
,p_column_heading=>'Budget 2023'
,p_column_format=>'999G999G999G999G999G999G999G999G999G990'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13485031421104107)
,p_query_column_id=>23
,p_column_alias=>'BASIS_OF_CALCULATION'
,p_column_display_sequence=>23
,p_column_heading=>'Basis of Calculation'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13485481314104107)
,p_query_column_id=>24
,p_column_alias=>'JAN_21'
,p_column_display_sequence=>24
,p_column_heading=>'Jan 21'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13485892764104107)
,p_query_column_id=>25
,p_column_alias=>'FEB_21'
,p_column_display_sequence=>25
,p_column_heading=>'Feb 21'
,p_column_format=>'999G999G999G999G999G999G999G999G999G990'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13486210789104108)
,p_query_column_id=>26
,p_column_alias=>'MAR_21'
,p_column_display_sequence=>26
,p_column_heading=>'Mar 21'
,p_column_format=>'999G999G999G999G999G999G999G999G999G990'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13486612020104108)
,p_query_column_id=>27
,p_column_alias=>'APR_21'
,p_column_display_sequence=>27
,p_column_heading=>'Apr 21'
,p_column_format=>'999G999G999G999G999G999G999G999G999G990'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13487034197104108)
,p_query_column_id=>28
,p_column_alias=>'MAY_21'
,p_column_display_sequence=>28
,p_column_heading=>'May 21'
,p_column_format=>'999G999G999G999G999G999G999G999G999G990'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13487452379104108)
,p_query_column_id=>29
,p_column_alias=>'JUN_21'
,p_column_display_sequence=>29
,p_column_heading=>'Jun 21'
,p_column_format=>'999G999G999G999G999G999G999G999G999G990'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13487898211104109)
,p_query_column_id=>30
,p_column_alias=>'JUL_21'
,p_column_display_sequence=>30
,p_column_heading=>'Jul 21'
,p_column_format=>'999G999G999G999G999G999G999G999G999G990'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13488222602104109)
,p_query_column_id=>31
,p_column_alias=>'AUG_21'
,p_column_display_sequence=>31
,p_column_heading=>'Aug 21'
,p_column_format=>'999G999G999G999G999G999G999G999G999G990'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13488695313104109)
,p_query_column_id=>32
,p_column_alias=>'SEP_21'
,p_column_display_sequence=>32
,p_column_heading=>'Sep 21'
,p_column_format=>'999G999G999G999G999G999G999G999G999G990'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13489018546104109)
,p_query_column_id=>33
,p_column_alias=>'OCT_21'
,p_column_display_sequence=>33
,p_column_heading=>'Oct 21'
,p_column_format=>'999G999G999G999G999G999G999G999G999G990'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13489494795104109)
,p_query_column_id=>34
,p_column_alias=>'NOV_21'
,p_column_display_sequence=>34
,p_column_heading=>'Nov 21'
,p_column_format=>'999G999G999G999G999G999G999G999G999G990'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13489848218104110)
,p_query_column_id=>35
,p_column_alias=>'DEC_21'
,p_column_display_sequence=>35
,p_column_heading=>'Dec 21'
,p_column_format=>'999G999G999G999G999G999G999G999G999G990'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13490270869104110)
,p_query_column_id=>36
,p_column_alias=>'TOTAL'
,p_column_display_sequence=>36
,p_column_heading=>'Total'
,p_column_format=>'999G999G999G999G999G999G999G999G999G990'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13490619033104110)
,p_query_column_id=>37
,p_column_alias=>'ERROR_CHECKER'
,p_column_display_sequence=>37
,p_column_heading=>'Error Checker'
,p_column_format=>'999G999G999G999G999G999G999G999G999G990'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_hidden_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(13470791908104052)
,p_plug_name=>'Search'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(13242565869480804)
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>4
,p_plug_display_point=>'REGION_POSITION_02'
,p_plug_source_type=>'NATIVE_FACETED_SEARCH'
,p_filtered_region_id=>wwv_flow_api.id(13470691471104052)
,p_attribute_01=>'N'
,p_attribute_06=>'E'
,p_attribute_07=>'Y'
,p_attribute_08=>'#active_facets'
,p_attribute_09=>'Y'
,p_attribute_12=>'10000'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(13475105636104055)
,p_plug_name=>'Button Bar'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noPadding:t-ButtonRegion--noUI'
,p_plug_template=>wwv_flow_api.id(13216123905480789)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_source=>'<div id="active_facets"></div>'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(13475611713104055)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(13475105636104055)
,p_button_name=>'RESET'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(13304710257480854)
,p_button_image_alt=>'Reset'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:RR,3::'
,p_icon_css_classes=>'fa-undo'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13471202269104052)
,p_name=>'P3_SEARCH'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(13470791908104052)
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
 p_id=>wwv_flow_api.id(13471679234104052)
,p_name=>'P3_SECTOR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(13470791908104052)
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
 p_id=>wwv_flow_api.id(13472076160104053)
,p_name=>'P3_EXPENSE_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(13470791908104052)
,p_prompt=>'Expense Type'
,p_source=>'EXPENSE_TYPE'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_fc_collapsible=>true
,p_fc_initial_collapsed=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>5
,p_fc_filter_values=>false
,p_fc_sort_by_top_counts=>true
,p_fc_show_selected_first=>false
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13472490126104053)
,p_name=>'P3_EXP_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(13470791908104052)
,p_prompt=>'Exp Type'
,p_source=>'EXP_TYPE'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_fc_collapsible=>true
,p_fc_initial_collapsed=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>5
,p_fc_filter_values=>false
,p_fc_sort_by_top_counts=>true
,p_fc_show_selected_first=>false
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13472867399104053)
,p_name=>'P3_DEPARTMENT_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(13470791908104052)
,p_prompt=>'Department Name'
,p_source=>'DEPARTMENT_NAME'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_fc_collapsible=>true
,p_fc_initial_collapsed=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>5
,p_fc_filter_values=>false
,p_fc_sort_by_top_counts=>true
,p_fc_show_selected_first=>false
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13473270524104053)
,p_name=>'P3_NEW_ASSETS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(13470791908104052)
,p_prompt=>'New Assets'
,p_source=>'NEW_ASSETS'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_attribute_05=>'N'
,p_fc_collapsible=>true
,p_fc_initial_collapsed=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>5
,p_fc_filter_values=>false
,p_fc_sort_by_top_counts=>true
,p_fc_show_selected_first=>false
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13473600916104054)
,p_name=>'P3_CHAPTER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(13470791908104052)
,p_prompt=>'Chapter'
,p_source=>'CHAPTER'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_attribute_05=>'N'
,p_fc_collapsible=>true
,p_fc_initial_collapsed=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>5
,p_fc_filter_values=>false
,p_fc_sort_by_top_counts=>true
,p_fc_show_selected_first=>false
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13474034350104054)
,p_name=>'P3_COST_CENTER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(13470791908104052)
,p_prompt=>'Cost Center'
,p_source=>'COST_CENTER'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_fc_collapsible=>true
,p_fc_initial_collapsed=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>5
,p_fc_filter_values=>false
,p_fc_sort_by_top_counts=>true
,p_fc_show_selected_first=>false
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13474429218104054)
,p_name=>'P3_ADERP_PROJECT_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(13470791908104052)
,p_prompt=>'Aderp Project Name'
,p_source=>'ADERP_PROJECT_NAME'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_fc_collapsible=>true
,p_fc_initial_collapsed=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>5
,p_fc_filter_values=>false
,p_fc_sort_by_top_counts=>true
,p_fc_show_selected_first=>false
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13474850803104055)
,p_name=>'P3_ACCOUNT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(13470791908104052)
,p_prompt=>'Account Number'
,p_source=>'ACCOUNT_NUMBER'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_fc_collapsible=>true
,p_fc_initial_collapsed=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>5
,p_fc_filter_values=>false
,p_fc_sort_by_top_counts=>true
,p_fc_show_selected_first=>false
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(13462651144079126)
,p_name=>'New'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(13470791908104052)
,p_bind_type=>'bind'
,p_bind_event_type=>'custom'
,p_bind_event_type_custom=>'facetschange'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(13462707513079127)
,p_event_id=>wwv_flow_api.id(13462651144079126)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(13462110669079121)
);
wwv_flow_api.component_end;
end;
/
