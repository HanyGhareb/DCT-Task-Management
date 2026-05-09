prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>1
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'Home'
,p_alias=>'HOME'
,p_step_title=>'CWIP Dev'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210607095410'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(10343490474597919)
,p_plug_name=>'CWIP Dev'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_plug_template=>wwv_flow_api.id(10254567086597785)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(22582803977288908)
,p_plug_name=>'Payments Recommendations'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(22507035300061647)
,p_plug_name=>'REC count By Year'
,p_parent_plug_id=>wwv_flow_api.id(22582803977288908)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noUI:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT  count(payment_recommendation_id), vendor_name',
'FROM    cwip_payment_recommendation_v',
'where extract(YEAR from payment_recommendation_date) = 2021',
'and project_number in ( select PROJECT_NUMBER',
'                          from CWIP_TEAM',
'                         where 1=1',
'                         and role_id in (Select r.role_id from project_role r where r.category_id = 2)',
'                         and status = ''A''',
'                         and sysdate BETWEEN nvl(start_date , sysdate -1) and nvl(end_date, sysdate +10)',
'                         and person_type = ''INT''',
'                         and person_id = :PERSON_ID)',
'OR project_number in (select x.project_number ',
'from project x',
'where project_type = ''Capital''',
'and exists (select 1 ',
'            from cwip_team',
'            where cwip_team.person_id = :PERSON_ID',
'            and cwip_team.project_number is null) )    ',
'or project_number in (select x.project_number',
'                        from project x',
'                        where :PERSON_ID = 680461 )',
'GROUP by vendor_name;'))
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(22507122717061648)
,p_region_id=>wwv_flow_api.id(22507035300061647)
,p_chart_type=>'bar'
,p_title=>'Count By Vendor'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
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
,p_legend_rendered=>'off'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(22507298775061649)
,p_chart_id=>wwv_flow_api.id(22507122717061648)
,p_seq=>10
,p_name=>'Count'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select VALUE, LABEL        ',
'        ,''Total Payments Recommendation in '' ',
'        || for_year',
'        || '' for '' || LABEL  as tooltip',
'from (SELECT',
'    count(payment_recommendation_id)  value,',
'    vendor_name                        label,',
'    extract(YEAR from payment_recommendation_date) for_year',
'FROM',
'    cwip_payment_recommendation_v',
'where extract(YEAR from payment_recommendation_date) = 2021',
'and project_number in ( select PROJECT_NUMBER',
'                          from CWIP_TEAM',
'                         where 1=1',
'                         and role_id in (Select r.role_id from project_role r where r.category_id = 2)',
'                         and status = ''A''',
'                         and sysdate BETWEEN nvl(start_date , sysdate -1) and nvl(end_date, sysdate +10)',
'--                         and person_type = ''INT''',
'                         and person_id = :PERSON_ID)',
'OR project_number in (select x.project_number ',
'from project x',
'where project_type = ''Capital''',
'and exists (select 1 ',
'            from cwip_team',
'            where cwip_team.person_id = :PERSON_ID',
'            and cwip_team.project_number is null) )    ',
'or project_number in (select x.project_number',
'                        from project x',
'                        where :PERSON_ID = 680461 )',
'GROUP by vendor_name , extract(YEAR from payment_recommendation_date));'))
,p_items_value_column_name=>'VALUE'
,p_items_label_column_name=>'LABEL'
,p_items_short_desc_column_name=>'TOOLTIP'
,p_color=>'#4E8DD9'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'outsideBarEdge'
,p_items_label_font_family=>'Courier'
,p_items_label_font_style=>'normal'
,p_items_label_font_size=>'18'
,p_items_label_font_color=>'#14199E'
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(22582142407288901)
,p_chart_id=>wwv_flow_api.id(22507122717061648)
,p_axis=>'y'
,p_is_rendered=>'off'
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
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(22507363598061650)
,p_chart_id=>wwv_flow_api.id(22507122717061648)
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(22582301886288903)
,p_plug_name=>'Amount By Year'
,p_parent_plug_id=>wwv_flow_api.id(22582803977288908)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    count(payment_recommendation_id),',
'    vendor_name',
'FROM',
'    cwip_payment_recommendation_v',
'where extract(YEAR from payment_recommendation_date) = 2021',
'GROUP by vendor_name;'))
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(22582438326288904)
,p_region_id=>wwv_flow_api.id(22582301886288903)
,p_chart_type=>'bar'
,p_title=>'Net Amount By Vendor'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
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
,p_legend_rendered=>'off'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(22582502512288905)
,p_chart_id=>wwv_flow_api.id(22582438326288904)
,p_seq=>10
,p_name=>'Count'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select VALUE, LABEL        ',
'        ,''Total Payments Recommendation Net amount paid in '' ',
'        || for_year',
'        || '' for '' || LABEL  as tooltip',
'from (SELECT',
'    sum(cwip_payment_recommendation_v.net_amount_payable) value,',
'    vendor_name                        label,',
'    extract(YEAR from payment_recommendation_date) for_year',
'FROM',
'    cwip_payment_recommendation_v',
'where extract(YEAR from payment_recommendation_date) = 2021',
'and project_number in ( select PROJECT_NUMBER',
'                          from CWIP_TEAM',
'                         where 1=1',
'                         and role_id in (Select r.role_id from project_role r where r.category_id = 2)',
'                         and status = ''A''',
'                         and sysdate BETWEEN nvl(start_date , sysdate -1) and nvl(end_date, sysdate +10)',
'--                         and person_type = ''INT''',
'                         and person_id = :PERSON_ID)',
'OR project_number in (select x.project_number ',
'from project x',
'where project_type = ''Capital''',
'and exists (select 1 ',
'            from cwip_team',
'            where cwip_team.person_id = :PERSON_ID',
'            and cwip_team.project_number is null) )    ',
'or project_number in (select x.project_number',
'                        from project x',
'                        where :PERSON_ID = 680461 )',
'GROUP by vendor_name , extract(YEAR from payment_recommendation_date));'))
,p_items_value_column_name=>'VALUE'
,p_items_label_column_name=>'LABEL'
,p_items_short_desc_column_name=>'TOOLTIP'
,p_color=>'#207D30'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'outsideBarEdge'
,p_items_label_font_family=>'Courier New'
,p_items_label_font_style=>'normal'
,p_items_label_font_size=>'14'
,p_items_label_font_color=>'#207D30'
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(22582670810288906)
,p_chart_id=>wwv_flow_api.id(22582438326288904)
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
 p_id=>wwv_flow_api.id(22582787175288907)
,p_chart_id=>wwv_flow_api.id(22582438326288904)
,p_axis=>'y'
,p_is_rendered=>'off'
,p_format_type=>'decimal'
,p_decimal_places=>0
,p_format_scaling=>'none'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_tick_label_font_family=>'Courier New'
,p_tick_label_font_style=>'normal'
,p_tick_label_font_size=>'14'
,p_tick_label_font_color=>'#0B6619'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(22582954013288909)
,p_plug_name=>'Count By Approval Status'
,p_parent_plug_id=>wwv_flow_api.id(22582803977288908)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>30
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(22583018452288910)
,p_region_id=>wwv_flow_api.id(22582954013288909)
,p_chart_type=>'donut'
,p_title=>'Count By Approval Status'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_value_format_type=>'decimal'
,p_value_decimal_places=>0
,p_value_format_scaling=>'none'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_value=>true
,p_legend_rendered=>'off'
,p_pie_other_threshold=>0
,p_pie_selection_effect=>'highlight'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(22583173770288911)
,p_chart_id=>wwv_flow_api.id(22583018452288910)
,p_seq=>10
,p_name=>'Approval Status'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select COUNT(payment_recommendation_id) value,',
'      approval_status',
'from cwip_payment_recommendation_v',
'where project_number in ( select PROJECT_NUMBER',
'                          from CWIP_TEAM',
'                         where 1=1',
'                         and role_id in (Select r.role_id from project_role r where r.category_id = 2)',
'                         and status = ''A''',
'                         and sysdate BETWEEN nvl(start_date , sysdate -1) and nvl(end_date, sysdate +10)',
'--                         and person_type = ''INT''',
'                         and person_id = :PERSON_ID)',
'OR project_number in (select x.project_number ',
'from project x',
'where project_type = ''Capital''',
'and exists (select 1 ',
'            from cwip_team',
'            where cwip_team.person_id = :PERSON_ID',
'            and cwip_team.project_number is null) )    ',
'or project_number in (select x.project_number',
'                        from project x',
'                        where :PERSON_ID = 680461 )',
'GROUP BY approval_status'))
,p_items_value_column_name=>'VALUE'
,p_items_label_column_name=>'APPROVAL_STATUS'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'LBL_VAL'
);
wwv_flow_api.component_end;
end;
/
