prompt --application/pages/page_00025
begin
--   Manifest
--     PAGE: 00025
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>25
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Petty Cash Dashboard'
,p_alias=>'PETTY-CASH-DASHBOARD'
,p_step_title=>'Petty Cash Dashboard'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>wwv_flow_api.id(8015810857175492)
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210107161607'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(4254499643172414)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8067277693175509)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(8003821207175482)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(8121335853175533)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(4255064070172415)
,p_plug_name=>'Petty Cash Requests By Sectors - Amount'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--accent3:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(4255492063172415)
,p_region_id=>wwv_flow_api.id(4255064070172415)
,p_chart_type=>'bar'
,p_height=>'400'
,p_animation_on_display=>'alphaFade'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'dim'
,p_stack=>'on'
,p_stack_label=>'on'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
,p_sorting=>'value-desc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_show_label=>true
,p_show_row=>true
,p_show_start=>true
,p_show_end=>true
,p_show_progress=>true
,p_show_baseline=>true
,p_legend_rendered=>'on'
,p_legend_position=>'top'
,p_overview_rendered=>'off'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(4257211807172418)
,p_chart_id=>wwv_flow_api.id(4255492063172415)
,p_seq=>10
,p_name=>'Approved Open'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select sum(amount) value ',
'        , sector label ',
'        , ''Total petty cash requests amount Approved and Still open for '' || EXTRACT (Year from sysdate) || '' - Sector: '' || sector tooltip , ''Approved - Open'' Series',
'from petty_cash_all_v',
'where approval_status = ''Approved''',
'and extract(year from petty_cash_date ) = EXTRACT (Year from sysdate)',
'and status = ''Open''',
'group by sector , ''Total petty cash requests amount Approved and Still open for '' || EXTRACT (Year from sysdate) || '' - Sector: '' || sector , ''Approved - Open'''))
,p_max_row_count=>1000
,p_series_name_column_name=>'SERIES'
,p_items_value_column_name=>'VALUE'
,p_items_label_column_name=>'LABEL'
,p_items_short_desc_column_name=>'TOOLTIP'
,p_color=>'#0E6655'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'PERCENT'
,p_items_label_font_color=>'#FCFCFC'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(3989047893546483)
,p_chart_id=>wwv_flow_api.id(4255492063172415)
,p_seq=>20
,p_name=>'Approved Closed'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select sum(amount) value ',
'    , sector label ',
'    , ''Total petty cash requests amount Approved and Closed during '' || ',
'        EXTRACT (Year from sysdate) || '' - Sector: '' || sector tooltip ',
'    , ''Approved - Closed'' Series',
'from petty_cash_all_v',
'where approval_status = ''Approved''',
'and extract(year from petty_cash_date ) = EXTRACT (Year from sysdate)',
'and status = ''Closed''',
'group by sector , ''Total petty cash requests amount Approved and Closed during '' || ',
'        EXTRACT (Year from sysdate) || '' - Sector: '' || sector , ''Approved - Closed'';'))
,p_series_name_column_name=>'SERIES'
,p_items_value_column_name=>'VALUE'
,p_items_label_column_name=>'LABEL'
,p_items_short_desc_column_name=>'TOOLTIP'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(4255976098172417)
,p_chart_id=>wwv_flow_api.id(4255492063172415)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'auto'
,p_tick_label_rendered=>'on'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(4256658442172418)
,p_chart_id=>wwv_flow_api.id(4255492063172415)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'auto'
,p_tick_label_rendered=>'off'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(4257801230172419)
,p_plug_name=>'Petty Cash Requests By Sectors - Count'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent3:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>70
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(4258193943172419)
,p_region_id=>wwv_flow_api.id(4257801230172419)
,p_chart_type=>'bar'
,p_height=>'400'
,p_animation_on_display=>'alphaFade'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'dim'
,p_stack=>'on'
,p_stack_label=>'on'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
,p_sorting=>'value-asc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_show_label=>true
,p_show_row=>true
,p_show_start=>true
,p_show_end=>true
,p_show_progress=>true
,p_show_baseline=>true
,p_legend_rendered=>'on'
,p_legend_position=>'top'
,p_overview_rendered=>'off'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(4258684057172419)
,p_chart_id=>wwv_flow_api.id(4258193943172419)
,p_seq=>10
,p_name=>'Approved Open'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select count(*) value , sector label , ''Total petty cash requests count Approved and Still open for '' || EXTRACT (Year from sysdate) tooltip , ''Approved - Open'' Series',
'from petty_cash_all_v',
'where approval_status = ''Approved''',
'and extract(year from petty_cash_date ) = EXTRACT (Year from sysdate)',
'and status = ''Open''',
'group by sector , ''total Approved for '' || EXTRACT (Year from sysdate) , ''Approved - Open'''))
,p_max_row_count=>20
,p_series_name_column_name=>'SERIES'
,p_items_value_column_name=>'VALUE'
,p_items_label_column_name=>'LABEL'
,p_items_short_desc_column_name=>'TOOLTIP'
,p_color=>'#0E6655'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(4275202358384941)
,p_chart_id=>wwv_flow_api.id(4258193943172419)
,p_seq=>20
,p_name=>'Approved Closed'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select count(*) value , sector label , ''Total petty cash requests count Approved and closed during '' || EXTRACT (Year from sysdate) tooltip , ''Approved - Closed'' Series',
'from petty_cash_all_v',
'where approval_status = ''Approved''',
'and extract(year from petty_cash_date ) = EXTRACT (Year from sysdate)',
'and status = ''Closed''',
'group by sector , ''total Approved for '' || EXTRACT (Year from sysdate) , ''Approved - Closed'''))
,p_series_name_column_name=>'SERIES'
,p_items_value_column_name=>'VALUE'
,p_items_label_column_name=>'LABEL'
,p_items_short_desc_column_name=>'TOOLTIP'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(4275047300384939)
,p_chart_id=>wwv_flow_api.id(4258193943172419)
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
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(4275087620384940)
,p_chart_id=>wwv_flow_api.id(4258193943172419)
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
,p_tick_label_rendered=>'off'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(4259308755172420)
,p_plug_name=>'Top 5 Departments'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent3:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>80
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(4259740217172420)
,p_region_id=>wwv_flow_api.id(4259308755172420)
,p_chart_type=>'bar'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'on'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_stack_label=>'off'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_show_label=>true
,p_show_row=>true
,p_show_start=>true
,p_show_end=>true
,p_show_progress=>true
,p_show_baseline=>true
,p_legend_rendered=>'off'
,p_legend_position=>'auto'
,p_overview_rendered=>'off'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(4261427770172421)
,p_chart_id=>wwv_flow_api.id(4259740217172420)
,p_seq=>10
,p_name=>'Series 1'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select LABEL, VAL , ''Total Approved, Open petty cash Amount in '' || EXTRACT (Year from sysdate) || '' For '' || label tooltip',
'from (',
'select department_name label, sum(amount) val',
'from petty_cash_all_v',
'where petty_cash_all_v.approval_status  = ''Approved''',
'and petty_cash_all_v.status = ''Open''',
'and extract(year from petty_cash_date ) = EXTRACT (Year from sysdate)',
'group by department_name ) ',
'order by val desc',
'FETCH FIRST 5 ROWS ONLY;'))
,p_max_row_count=>20
,p_items_value_column_name=>'VAL'
,p_items_label_column_name=>'LABEL'
,p_items_short_desc_column_name=>'TOOLTIP'
,p_color=>'#0E6655'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'outsideBarEdge'
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(4260256254172420)
,p_chart_id=>wwv_flow_api.id(4259740217172420)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'auto'
,p_tick_label_rendered=>'on'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(4260800318172420)
,p_chart_id=>wwv_flow_api.id(4259740217172420)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'auto'
,p_tick_label_rendered=>'off'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(4262020724172421)
,p_plug_name=>'Top 10 Projects'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent3:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>90
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(4262446243172421)
,p_region_id=>wwv_flow_api.id(4262020724172421)
,p_chart_type=>'bar'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_stack_label=>'off'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_show_label=>true
,p_show_row=>true
,p_show_start=>true
,p_show_end=>true
,p_show_progress=>true
,p_show_baseline=>true
,p_legend_rendered=>'off'
,p_legend_position=>'auto'
,p_overview_rendered=>'off'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(4264105934172422)
,p_chart_id=>wwv_flow_api.id(4262446243172421)
,p_seq=>10
,p_name=>'Series 1'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select LABEL, VAL , ''Total Approved, Open petty cash Amount in '' || EXTRACT (Year from sysdate)  || '' for project: '' || label || ''-'' || project_name tooltip',
'from (',
'select petty_cash_all_v.project_number  label, petty_cash_all_v.project_name , sum(amount) val',
'from petty_cash_all_v',
'where petty_cash_all_v.approval_status  = ''Approved''',
'and petty_cash_all_v.status = ''Open''',
'and extract(year from petty_cash_date ) = EXTRACT (Year from sysdate)',
'group by petty_cash_all_v.project_number , petty_cash_all_v.project_name) ',
'order by val desc',
'FETCH FIRST 10 ROWS ONLY;'))
,p_max_row_count=>20
,p_items_value_column_name=>'VAL'
,p_items_label_column_name=>'LABEL'
,p_items_short_desc_column_name=>'TOOLTIP'
,p_color=>'#0E6655'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'outsideBarEdge'
,p_items_label_display_as=>'PERCENT'
,p_items_label_font_color=>'#000000'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(4262882950172421)
,p_chart_id=>wwv_flow_api.id(4262446243172421)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'auto'
,p_tick_label_rendered=>'on'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(4263489760172422)
,p_chart_id=>wwv_flow_api.id(4262446243172421)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'auto'
,p_tick_label_rendered=>'off'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(4275337609384942)
,p_plug_name=>'Total Approved  / open Amount'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(4275419820384943)
,p_region_id=>wwv_flow_api.id(4275337609384942)
,p_chart_type=>'dial'
,p_title=>'Open / Total'
,p_width=>'400'
,p_animation_on_display=>'alphaFade'
,p_animation_on_data_change=>'auto'
,p_stack=>'off'
,p_stack_label=>'off'
,p_connect_nulls=>'Y'
,p_value_text_type=>'number'
,p_value_position=>'auto'
,p_value_format_type=>'decimal'
,p_value_format_scaling=>'auto'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_show_label=>true
,p_show_row=>true
,p_show_start=>true
,p_show_end=>true
,p_show_progress=>true
,p_show_baseline=>true
,p_legend_rendered=>'on'
,p_legend_position=>'auto'
,p_overview_rendered=>'off'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'horizontal'
,p_gauge_indicator_size=>1
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(4275509881384944)
,p_chart_id=>wwv_flow_api.id(4275419820384943)
,p_seq=>10
,p_name=>'Total to Open Approved'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'(select sum (amount )',
'from petty_cash_all_v p',
'where 1 =1 ',
'and p.year =  ''2020''',
'--and p.year = EXTRACT (Year from sysdate)',
'and approval_status = ''Approved''',
'and status = ''Open'') value ,',
'(select sum (amount )',
'from petty_cash_all_v pc',
'where 1= 1',
'and pc.year = ''2020''',
'--and pc.year = EXTRACT (Year from sysdate)',
'and approval_status = ''Approved'') max_value',
', ''Open / total '' Label',
'from dual;'))
,p_items_value_column_name=>'VALUE'
,p_items_max_value=>'MAX_VALUE'
,p_items_label_column_name=>'LABEL'
,p_color=>'#0E6655'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'PERCENT'
,p_gauge_plot_area_color=>'#A7E33F'
,p_threshold_display=>'all'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(4275847215384947)
,p_plug_name=>'Total Approved  / open Count'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_new_grid_column=>false
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(4275940097384948)
,p_region_id=>wwv_flow_api.id(4275847215384947)
,p_chart_type=>'dial'
,p_title=>'Open / Total'
,p_width=>'400'
,p_animation_on_display=>'alphaFade'
,p_animation_on_data_change=>'auto'
,p_stack=>'off'
,p_stack_label=>'off'
,p_connect_nulls=>'Y'
,p_value_text_type=>'number'
,p_value_position=>'auto'
,p_value_format_type=>'decimal'
,p_value_format_scaling=>'auto'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_show_label=>true
,p_show_row=>true
,p_show_start=>true
,p_show_end=>true
,p_show_progress=>true
,p_show_baseline=>true
,p_legend_rendered=>'on'
,p_legend_position=>'auto'
,p_overview_rendered=>'off'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'horizontal'
,p_gauge_indicator_size=>1
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(4275988180384949)
,p_chart_id=>wwv_flow_api.id(4275940097384948)
,p_seq=>10
,p_name=>'Total to Open Approved'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'(select count (* )',
'from petty_cash_all_v p',
'where p.year = EXTRACT (Year from sysdate)',
'and approval_status = ''Approved''',
'and status = ''Open'') value ,',
'(select Count (* )',
'from petty_cash_all_v pc',
'where pc.year = EXTRACT (Year from sysdate)',
'and approval_status = ''Approved'') max_value',
', ''Open / total '' Label',
'from dual;'))
,p_items_value_column_name=>'VALUE'
,p_items_max_value=>'MAX_VALUE'
,p_items_label_column_name=>'LABEL'
,p_color=>'#0E6655'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'PERCENT'
,p_gauge_plot_area_color=>'#A7E33F'
,p_threshold_display=>'all'
,p_reference_line_values=>'400000'
,p_reference_line_colors=>'red'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(5543650519584660)
,p_name=>'Outstanding Petty Cash'
,p_region_name=>'outstanding'
,p_template=>wwv_flow_api.id(8057862405175507)
,p_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_template_options=>'#DEFAULT#:t-Region--accent3:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:u-colors:t-BadgeList--xxlarge:t-BadgeList--circular:t-BadgeList--fixed'
,p_new_grid_row=>false
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT nvl(sum(pc_count),0) pc_count , nvl(sum(amount),0) amount',
'FROM',
'    outstanding_petty_cash_mv',
'where year = nvl(:P25_YEAR, year)',
'and sector = nvl(:P25_SECTOR , Sector)'))
,p_header=>'total amount Sum of oustanding petty cash and count per year (Approved, Open) '
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P25_YEAR,P25_SECTOR'
,p_query_row_template=>wwv_flow_api.id(8080540928175514)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7072747757297537)
,p_query_column_id=>1
,p_column_alias=>'PC_COUNT'
,p_column_display_sequence=>2
,p_column_heading=>'Count'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G999G999G990'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5544088156584665)
,p_query_column_id=>2
,p_column_alias=>'AMOUNT'
,p_column_display_sequence=>1
,p_column_heading=>'Amount'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_column_html_expression=>'<span style="color: #FFF ; font-size: 20px">#AMOUNT#</span>'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(5544356226584667)
,p_name=>'Late Petty Cash'
,p_region_name=>'outstanding'
,p_template=>wwv_flow_api.id(8057862405175507)
,p_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_template_options=>'#DEFAULT#:t-Region--accent3:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:u-colors:t-BadgeList--xxlarge:t-BadgeList--circular:t-BadgeList--fixed'
,p_new_grid_row=>false
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT nvl(sum(pc_count),0) COUNT, nvl(Sum(amount),0) Amount',
'FROM  outstanding_late_petty_cash_mv',
'where year = nvl(:P25_YEAR , year);'))
,p_header=>'Sum of late petty cash and count per year (Approved, Open, Closed date past) '
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P25_YEAR'
,p_query_row_template=>wwv_flow_api.id(8080540928175514)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5544542862584669)
,p_query_column_id=>1
,p_column_alias=>'COUNT'
,p_column_display_sequence=>2
,p_column_heading=>'Count'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5544404921584668)
,p_query_column_id=>2
,p_column_alias=>'AMOUNT'
,p_column_display_sequence=>1
,p_column_heading=>'Amount'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_column_html_expression=>'<span style="color: #FFF ; font-size: 20px">#AMOUNT#</span>'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(7072942527297539)
,p_plug_name=>'Filter By'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>100
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7073029286297540)
,p_name=>'P25_YEAR'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(7072942527297539)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select TO_CHAR(SYSDATE,''YYYY'') Year',
'from dual;'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Year'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT TO_CHAR(SYSDATE,''YYYY'')-LEVEL+1  D , TO_CHAR(SYSDATE,''YYYY'')-LEVEL+1 R',
'FROM DUAL',
'CONNECT BY LEVEL <= 10;'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'All'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(8118554792175530)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7073538791297545)
,p_name=>'P25_SECTOR'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(7072942527297539)
,p_item_default=>'Null'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'Sector'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select Distinct Sector d, Sector r',
'from petty_cash_all_v'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'All'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(8118554792175530)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(7073085896297541)
,p_name=>'Select Year DA'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P25_YEAR'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7073164820297542)
,p_event_id=>wwv_flow_api.id(7073085896297541)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(5543650519584660)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(7600508100612643)
,p_name=>'Select Year DA_1'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P25_YEAR'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7600717676612645)
,p_event_id=>wwv_flow_api.id(7600508100612643)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(5544356226584667)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(7073629582297546)
,p_name=>'SelectSector'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P25_SECTOR'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7073668476297547)
,p_event_id=>wwv_flow_api.id(7073629582297546)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(5543650519584660)
);
wwv_flow_api.component_end;
end;
/
