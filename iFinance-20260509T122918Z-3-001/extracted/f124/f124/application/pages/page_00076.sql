prompt --application/pages/page_00076
begin
--   Manifest
--     PAGE: 00076
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
 p_id=>76
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'Demand Planning Dashboard'
,p_alias=>'DEMAND-PLANNING-DASHBOARD'
,p_step_title=>'Demand Planning Dashboard'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230321184300'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11481297178932267)
,p_plug_name=>'DP Items Count By Sectors'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(11481381283932268)
,p_region_id=>wwv_flow_api.id(11481297178932267)
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
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function( options ){ ',
'        ',
'    // Setup a callback function which gets called when data is retrieved, it allows to manipulate the series ',
'    options.dataFilter = function( data ) { ',
'        data.series[ 0 ].items[0].color = "red";',
'        data.series[ 0 ].items[1].color = "green"; ',
'  ',
'        return data; ',
'    };',
'        ',
'    // Set chart initialization options ',
'    return options; ',
'}'))
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(11481545263932270)
,p_chart_id=>wwv_flow_api.id(11481381283932268)
,p_seq=>20
,p_name=>'Sector Count'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select user_details.org_name(sector_id) sector,  COUNT(*)',
'from dp_items',
'where dp_year = 2023',
'GROUP BY sector_id',
'order by 2 desc'))
,p_max_row_count=>20
,p_items_value_column_name=>'COUNT(*)'
,p_items_label_column_name=>'SECTOR'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'aboveMarker'
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(11481727198932271)
,p_chart_id=>wwv_flow_api.id(11481381283932268)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'auto'
,p_tick_label_rendered=>'on'
,p_tick_label_rotation=>'none'
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
 p_id=>wwv_flow_api.id(11481804560932272)
,p_chart_id=>wwv_flow_api.id(11481381283932268)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'top'
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11481881618932273)
,p_plug_name=>'Review Status'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>40
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(11482024039932274)
,p_region_id=>wwv_flow_api.id(11481881618932273)
,p_chart_type=>'pie'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_stack_label=>'off'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
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
,p_legend_rendered=>'off'
,p_legend_position=>'auto'
,p_overview_rendered=>'off'
,p_pie_other_threshold=>0
,p_pie_selection_effect=>'highlight'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(11482115042932275)
,p_chart_id=>wwv_flow_api.id(11482024039932274)
,p_seq=>10
,p_name=>'DP Items count by planning status'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- By review_status',
'select review_status,  COUNT(*)',
'from dp_items',
'where dp_year = 2023',
'GROUP BY review_status',
'order by 2 desc;',
''))
,p_max_row_count=>20
,p_items_value_column_name=>'COUNT(*)'
,p_items_label_column_name=>'REVIEW_STATUS'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'LABEL'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11482132134932276)
,p_plug_name=>'Approval Status'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>50
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(11482286273932277)
,p_region_id=>wwv_flow_api.id(11482132134932276)
,p_chart_type=>'pie'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_stack_label=>'off'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
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
,p_legend_rendered=>'off'
,p_legend_position=>'auto'
,p_overview_rendered=>'off'
,p_pie_other_threshold=>0
,p_pie_selection_effect=>'highlight'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(11482376289932278)
,p_chart_id=>wwv_flow_api.id(11482286273932277)
,p_seq=>10
,p_name=>'DP Items count by Approval status'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- By approval_status',
'Select APPROVAL_STATUS, total',
'        ,case approval_status',
'            when ''Approved'' then ''#008000''',
'            when ''Rejected'' then ''#ff0000''',
'            else  ''#ffff00',
'''',
'        end color',
'from',
'(select approval_status,',
'        COUNT(*) total',
'from dp_items',
'where dp_year = 2023',
'GROUP BY approval_status)',
'order by 2 desc;'))
,p_max_row_count=>20
,p_items_value_column_name=>'TOTAL'
,p_items_label_column_name=>'APPROVAL_STATUS'
,p_color=>'&COLOR.'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'LABEL'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11642662671478280)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127813188296449776)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(127749711524449850)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(127867332295449731)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11643303886478284)
,p_plug_name=>'DP Items Count By Main Categories '
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(11643653156478284)
,p_region_id=>wwv_flow_api.id(11643303886478284)
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
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function( options ){ ',
'        ',
'    // Setup a callback function which gets called when data is retrieved, it allows to manipulate the series ',
'    options.dataFilter = function( data ) { ',
'        data.series[ 0 ].items[0].color = "red"; ',
'        data.series[ 0 ].items[1].color = "blue"; ',
'        data.series[ 0 ].items[2].color = "yellow"; ',
'        data.series[ 0 ].items[3].color = "green"; ',
'        data.series[ 0 ].items[4].color = "purple"; ',
'        return data; ',
'    };',
'        ',
'    // Set chart initialization options ',
'    return options; ',
'}'))
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(11645334665478288)
,p_chart_id=>wwv_flow_api.id(11643653156478284)
,p_seq=>10
,p_name=>'Main Category Count'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DP_ITEMS_UTIL.get_item_category_name( main_category_id)  main_category_id,  COUNT(*)',
'from dp_items',
'where dp_year = 2023',
'GROUP BY main_category_id',
'order by 2 desc'))
,p_max_row_count=>20
,p_items_value_column_name=>'COUNT(*)'
,p_items_label_column_name=>'MAIN_CATEGORY_ID'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'aboveMarker'
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(11644189027478287)
,p_chart_id=>wwv_flow_api.id(11643653156478284)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'auto'
,p_tick_label_rendered=>'on'
,p_tick_label_rotation=>'none'
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
 p_id=>wwv_flow_api.id(11644790407478288)
,p_chart_id=>wwv_flow_api.id(11643653156478284)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'top'
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11646014834478293)
,p_plug_name=>'Planning Status'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(11646377108478293)
,p_region_id=>wwv_flow_api.id(11646014834478293)
,p_chart_type=>'pie'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_stack_label=>'off'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
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
 p_id=>wwv_flow_api.id(11646923501478294)
,p_chart_id=>wwv_flow_api.id(11646377108478293)
,p_seq=>10
,p_name=>'DP Items count by Review status'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- By Planning Status',
'select DP_ITEMS_UTIL.get_planning_status_name(planning_status) planning_status',
'        ,  COUNT(*)',
'from dp_items',
'where dp_year = 2023',
'GROUP BY planning_status',
'order by 2 desc;'))
,p_max_row_count=>20
,p_items_value_column_name=>'COUNT(*)'
,p_items_label_column_name=>'PLANNING_STATUS'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'LABEL'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11647498419478294)
,p_plug_name=>'Chart 3'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(11647892327478294)
,p_region_id=>wwv_flow_api.id(11647498419478294)
,p_chart_type=>'bar'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_stack_label=>'off'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
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
 p_id=>wwv_flow_api.id(11649579526478295)
,p_chart_id=>wwv_flow_api.id(11647892327478294)
,p_seq=>10
,p_name=>'Series 1'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Label 1'' label, 30 value from sys.dual',
'union all',
'select ''Label 2'' label, 20 value from sys.dual',
'union all',
'select ''Label 3'' label, 34 value from sys.dual',
'union all',
'select ''Label 4'' label, 6  value from sys.dual',
'union all',
'select ''Label 5'' label, 10 value from sys.dual'))
,p_max_row_count=>20
,p_series_type=>'bar'
,p_items_value_column_name=>'VALUE'
,p_items_label_column_name=>'LABEL'
,p_items_label_rendered=>false
,p_items_label_position=>'auto'
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(11648952482478294)
,p_chart_id=>wwv_flow_api.id(11647892327478294)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
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
 p_id=>wwv_flow_api.id(11648411535478294)
,p_chart_id=>wwv_flow_api.id(11647892327478294)
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(168730987957752607)
,p_plug_name=>'Risk Demand Planning Items'
,p_icon_css_classes=>'fa-clock-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent9:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>70
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select dp.ITEM_ID,',
'       INITIATIVE_ID,',
'       PROJECT_NUMBER,',
'       PROJECT_NEW_YN,',
'       decode(PROJECT_NEW_YN , ''Y'', PROJECT_NEW_NAME , PROJECT_NUMBER) Project,',
'       PROJECT_NEW_NAME,',
'       PROJECT_DESCRIPTION,',
'       CATEGORY_ID,',
'       SUB_CATEGORY_ID,',
'       ESTIMATED_DATE,',
'       ESTIMATED_MONTH,',
'       ESTIMATED_YEAR,',
'       ESTIMATED_QUARTER,',
'       END_USER_ID,',
'       SECTOR_ID,',
'       DEPARTMENT_ID,',
'       DP_ITEM_TYPE_ID,',
'       RISK_ID,',
'       PRIORITY_ID,',
'       DP_PROCUREMENT_METHOD,',
'       ESTIMATED_BUDGET,',
'       ESTIMATED_BUDGET_BRACKET_ID,',
'       PLANNING_STATUS,',
'       REVIEW_STATUS,',
'       APPROVAL_STATUS,',
'       CUTT_OFF_DATE,',
'       NOTES,',
'       dp.CREATED_BY,',
'       dp.CREATED_ON,',
'       dp.UPDATED_BY,',
'       dp.UPDATED_ON,',
'       COST_CENTER,',
'       REJECTED_BY,',
'       REVIEW_REJECTED_BY,',
'       REVIEW_REJECT_ON,',
'       REJECT_ON,',
'       REVIEW_REJECT_REASON,',
'       REJECT_REASON,',
'       FINAL_APPROVE_ON,',
'       REVIEW_APPROVE_ON,',
'       REVIEW_APPROVE_BY,',
'       FINAL_APPROVE_BY,',
'       SUBMIT_APPROVAL_ON,',
'       SUBMIT_REVIEW_ON,',
'       SUBMIT_REVIEW_BY,',
'       SUBMIT_APPROVAL_BY,',
'       DP_ITEM_NAME,',
'       COUNT_YEAR,',
'       COUNT_ITEM,',
'       DP_YEAR,',
'       CANCEL_ON,',
'       CANCELLED_BY,',
'       CANCEL_REASON,',
'       ESTIMATED_DATE_DEFINE,',
'       ESTIMATED_BUDGET_DEFINE,',
'       INITIATIVE_NEW_YN,',
'       INITIATIVE_NEW_NAME,',
'       DP_ITEM_CODE,',
'       DP_SCOPING_ID,',
'       MAIN_CATEGORY_ID,',
'       CONTRACT_NO,',
'       TOTAL_PROJECT_BUDGET,',
'       TASK_NUMBER,',
'       TASK_NUMBER_NEW,',
'       EXPENDITURE_TYPE,',
'       EXPENDITURE_TYPE_NEW,',
'       TASK_NEW_YN,',
'       sl.sla_date  due_date,',
'       trunc(sl.sla_date - sysdate )  Due_after,',
'       sl.sla_days  ',
'  from DP_ITEMS dp, dp_items_sla_fact sl',
'  where dp.item_id = sl.item_id (+)',
'  and REVIEW_STATUS = ''Reviewed''',
'  and APPROVAL_STATUS = ''Approved''',
'  and trunc((sl.sla_date - sysdate)) between  0 and 7',
'  order by trunc(sysdate - sl.sla_date) desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':IS_DP_ADMIN = ''Y'' and 1 =2'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'DP Items'
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
 p_id=>wwv_flow_api.id(168731082354752608)
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_allow_save_rpt_public=>'Y'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.::P11_ITEM_ID,P11_PAGE_FROM,P11_ITEM_ID_H:#ITEM_ID#,1,#ITEM_ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>312933251328808572
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13143901161190072)
,p_db_column_name=>'ITEM_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Item ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13144278694190072)
,p_db_column_name=>'CANCEL_REASON'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Cancel Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13144708410190072)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13145032282190073)
,p_db_column_name=>'ESTIMATED_DATE_DEFINE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Estimated Date Define ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13145468095190073)
,p_db_column_name=>'ESTIMATED_BUDGET_DEFINE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Estimated Budget Define ?'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13145892876190073)
,p_db_column_name=>'INITIATIVE_NEW_YN'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'New Initiative ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13146249164190073)
,p_db_column_name=>'INITIATIVE_NEW_NAME'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'New Initiative Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13146690057190074)
,p_db_column_name=>'DP_ITEM_CODE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'DP Item Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13147060155190074)
,p_db_column_name=>'DP_SCOPING_ID'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Dp Scoping Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13147468574190074)
,p_db_column_name=>'MAIN_CATEGORY_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Main Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(128449582832098954)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13147900727190074)
,p_db_column_name=>'CONTRACT_NO'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Contract No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13148266538190074)
,p_db_column_name=>'TOTAL_PROJECT_BUDGET'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Total Project Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13148633077190075)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13149058561190075)
,p_db_column_name=>'TASK_NUMBER_NEW'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'New Task'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13149492631190075)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13149915822190075)
,p_db_column_name=>'EXPENDITURE_TYPE_NEW'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'New Expenditure Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13150232584190076)
,p_db_column_name=>'TASK_NEW_YN'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Task New ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13150676398190076)
,p_db_column_name=>'PROJECT'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13151062740190076)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13151500711190076)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13151909657190076)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13152284323190077)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13152714466190077)
,p_db_column_name=>'REJECTED_BY'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Rejected By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13153117647190077)
,p_db_column_name=>'REVIEW_REJECTED_BY'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Review Rejected By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13153497651190077)
,p_db_column_name=>'REVIEW_REJECT_ON'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Review Reject On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13153873017190077)
,p_db_column_name=>'REJECT_ON'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Reject On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13154235094190078)
,p_db_column_name=>'REVIEW_REJECT_REASON'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Review Reject Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13154675174190078)
,p_db_column_name=>'CATEGORY_ID'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Main Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128449582832098954)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13155123751190078)
,p_db_column_name=>'REJECT_REASON'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Reject Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13155450899190078)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
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
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13155865708190078)
,p_db_column_name=>'REVIEW_APPROVE_ON'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Review Approve On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13156255911190079)
,p_db_column_name=>'REVIEW_APPROVE_BY'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Review Approve By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13156702843190079)
,p_db_column_name=>'FINAL_APPROVE_BY'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Final Approve By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13157098862190079)
,p_db_column_name=>'SUBMIT_APPROVAL_ON'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Submit Approval On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13157469001190079)
,p_db_column_name=>'SUBMIT_REVIEW_ON'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Submit Review On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13157851109190080)
,p_db_column_name=>'SUBMIT_REVIEW_BY'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Submit Review By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13158272975190080)
,p_db_column_name=>'SUBMIT_APPROVAL_BY'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Submit Approval By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13158665597190080)
,p_db_column_name=>'DP_ITEM_NAME'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Demand Planning Item Name'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13159074886190080)
,p_db_column_name=>'INITIATIVE_ID'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Initiative'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128335626861489802)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13159521245190080)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13159837805190081)
,p_db_column_name=>'PROJECT_NEW_YN'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Project New ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13160312227190081)
,p_db_column_name=>'PROJECT_NEW_NAME'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'New Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13160653665190081)
,p_db_column_name=>'PROJECT_DESCRIPTION'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Project Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13161127281190081)
,p_db_column_name=>'DUE_DATE'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Due Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13161466354190081)
,p_db_column_name=>'DUE_AFTER'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'Late Days'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13161842587190082)
,p_db_column_name=>'SLA_DAYS'
,p_display_order=>460
,p_column_identifier=>'AT'
,p_column_label=>'SLA Days'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13162283598190082)
,p_db_column_name=>'SUB_CATEGORY_ID'
,p_display_order=>470
,p_column_identifier=>'AU'
,p_column_label=>'Sub Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128449760929095476)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13162635029190082)
,p_db_column_name=>'ESTIMATED_DATE'
,p_display_order=>480
,p_column_identifier=>'AV'
,p_column_label=>'Estimated Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13163112038190082)
,p_db_column_name=>'ESTIMATED_MONTH'
,p_display_order=>490
,p_column_identifier=>'AW'
,p_column_label=>'Estimated Month'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13163457856190082)
,p_db_column_name=>'ESTIMATED_YEAR'
,p_display_order=>500
,p_column_identifier=>'AX'
,p_column_label=>'Estimated Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13163912371190083)
,p_db_column_name=>'ESTIMATED_QUARTER'
,p_display_order=>510
,p_column_identifier=>'AY'
,p_column_label=>'Estimated Quarter'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13164270518190083)
,p_db_column_name=>'END_USER_ID'
,p_display_order=>520
,p_column_identifier=>'AZ'
,p_column_label=>'End User'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13164655159190083)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>530
,p_column_identifier=>'BA'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128342316999489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13165122827190083)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>540
,p_column_identifier=>'BB'
,p_column_label=>'Department'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128341292413489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13165522207190083)
,p_db_column_name=>'DP_ITEM_TYPE_ID'
,p_display_order=>550
,p_column_identifier=>'BC'
,p_column_label=>'DP Item Type'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128416904318325983)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13165876173190084)
,p_db_column_name=>'RISK_ID'
,p_display_order=>560
,p_column_identifier=>'BD'
,p_column_label=>'Risk'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128420411111243936)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13166245132190084)
,p_db_column_name=>'PRIORITY_ID'
,p_display_order=>570
,p_column_identifier=>'BE'
,p_column_label=>'Priority'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128341720324489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13166711072190084)
,p_db_column_name=>'DP_PROCUREMENT_METHOD'
,p_display_order=>580
,p_column_identifier=>'BF'
,p_column_label=>'Procurement Method'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128420668962241785)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13167086176190084)
,p_db_column_name=>'ESTIMATED_BUDGET'
,p_display_order=>590
,p_column_identifier=>'BG'
,p_column_label=>'Estimated Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G999G999G999G999G999G990'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13167511716190085)
,p_db_column_name=>'ESTIMATED_BUDGET_BRACKET_ID'
,p_display_order=>600
,p_column_identifier=>'BH'
,p_column_label=>'Estimated Budget Bracket'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13167868472190085)
,p_db_column_name=>'PLANNING_STATUS'
,p_display_order=>610
,p_column_identifier=>'BI'
,p_column_label=>'Planning Status'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128420883056239409)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13168265082190085)
,p_db_column_name=>'REVIEW_STATUS'
,p_display_order=>620
,p_column_identifier=>'BJ'
,p_column_label=>'Review Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13168687014190085)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>630
,p_column_identifier=>'BK'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13169117975190085)
,p_db_column_name=>'CUTT_OFF_DATE'
,p_display_order=>640
,p_column_identifier=>'BL'
,p_column_label=>'Cutt-Off Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13169520964190086)
,p_db_column_name=>'NOTES'
,p_display_order=>650
,p_column_identifier=>'BM'
,p_column_label=>'Note'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13169881688190086)
,p_db_column_name=>'COUNT_YEAR'
,p_display_order=>660
,p_column_identifier=>'BN'
,p_column_label=>'Count Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13170287238190086)
,p_db_column_name=>'COUNT_ITEM'
,p_display_order=>670
,p_column_identifier=>'BO'
,p_column_label=>'Count Item'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13170654270190086)
,p_db_column_name=>'DP_YEAR'
,p_display_order=>680
,p_column_identifier=>'BP'
,p_column_label=>'Planning Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13171059332190086)
,p_db_column_name=>'CANCEL_ON'
,p_display_order=>690
,p_column_identifier=>'BQ'
,p_column_label=>'Cancel On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13171454266190087)
,p_db_column_name=>'CANCELLED_BY'
,p_display_order=>700
,p_column_identifier=>'BR'
,p_column_label=>'Cancelled By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(168850798952187997)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1573740'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'DP_ITEM_CODE:END_USER_ID:SECTOR_ID:ESTIMATED_BUDGET:DUE_DATE:DUE_AFTER:'
);
wwv_flow_api.component_end;
end;
/
