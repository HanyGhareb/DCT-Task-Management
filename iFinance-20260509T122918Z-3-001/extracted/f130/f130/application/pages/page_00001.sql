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
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>1
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'Home'
,p_alias=>'HOME'
,p_step_title=>'CWIP Payments Home'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20221003094152'
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
 p_id=>wwv_flow_api.id(86569086359893533)
,p_plug_name=>'Dashboard'
,p_icon_css_classes=>'fa-area-chart'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent2:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(259371050010548)
,p_plug_name=>'Display For'
,p_parent_plug_id=>wwv_flow_api.id(86569086359893533)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--stacked:t-Region--scrollBody:t-Form--slimPadding:margin-top-none:margin-bottom-none:margin-left-none:margin-right-none'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(22582803977288908)
,p_plug_name=>'Payments Recommendations'
,p_parent_plug_id=>wwv_flow_api.id(86569086359893533)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(22507035300061647)
,p_plug_name=>'count By Vendor, Year'
,p_parent_plug_id=>wwv_flow_api.id(22582803977288908)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT  count(payment_recommendation_id), vendor_name',
'FROM    cwip_payment_recommendation_v',
'where extract(YEAR from payment_recommendation_date) = nvl(:P1_YEAR ,extract(YEAR from payment_recommendation_date) )',
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
'GROUP by vendor_name',
'order by 1;'))
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_ajax_items_to_submit=>'P1_YEAR,P1_PROJECT'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'NEVER'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(22507122717061648)
,p_region_id=>wwv_flow_api.id(22507035300061647)
,p_chart_type=>'bar'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_connect_nulls=>'Y'
,p_sorting=>'value-asc'
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
'where extract(YEAR from payment_recommendation_date) = :P1_YEAR --2021',
'and project_number = nvl(:P1_PROJECT , project_number)',
'and contract_number = nvl(:P1_CONTRACT , contract_number) ',
'and approval_status = NVL(:P1_STATUS , Approval_status)',
'and (project_number in ( select PROJECT_NUMBER',
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
'                        where :PERSON_ID = 680461 ))',
'GROUP by vendor_name , extract(YEAR from payment_recommendation_date))',
'where for_year = :P1_YEAR',
'order by 1 desc;'))
,p_ajax_items_to_submit=>'P1_YEAR,P1_PROJECT,P1_CONTRACT,P1_STATUS'
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
,p_link_target=>'f?p=&APP_ID.:43:&SESSION.::&DEBUG.:43:P43_YEAR,P43_PROJECT,P43_CONTRACT,P43_STATUS,P43_VENDOR:&P1_YEAR.,&P1_PROJECT.,&P1_CONTRACT.,&P1_STATUS.,&LABEL.'
,p_link_target_type=>'REDIRECT_PAGE'
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
 p_id=>wwv_flow_api.id(22582301886288903)
,p_plug_name=>'Net Amount By Vendor, Year'
,p_parent_plug_id=>wwv_flow_api.id(22582803977288908)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>40
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    count(payment_recommendation_id),',
'    vendor_name',
'FROM',
'    cwip_payment_recommendation_v',
'where extract(YEAR from payment_recommendation_date) = :P1_YEAR --2021',
'and project_number = nvl(:P1_PROJECT , project_number)',
'GROUP by vendor_name;'))
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_ajax_items_to_submit=>'P1_YEAR,P1_PROJECT'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(22582438326288904)
,p_region_id=>wwv_flow_api.id(22582301886288903)
,p_chart_type=>'bar'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_connect_nulls=>'Y'
,p_sorting=>'value-asc'
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
,p_name=>'Amount'
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
'where extract(YEAR from payment_recommendation_date) = :P1_YEAR',
'and project_number = nvl(:P1_PROJECT , project_number)',
'and contract_number = nvl(:P1_CONTRACT , contract_number) ',
'and approval_status = NVL(:P1_STATUS , Approval_status)',
'and (project_number in ( select PROJECT_NUMBER',
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
'                        where :PERSON_ID = 680461 ))',
'GROUP by vendor_name , extract(YEAR from payment_recommendation_date))',
'where for_year = :P1_YEAR',
'order by 1 desc;'))
,p_ajax_items_to_submit=>'P1_YEAR,P1_PROJECT,P1_CONTRACT,P1_STATUS'
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
,p_link_target=>'f?p=&APP_ID.:43:&SESSION.::&DEBUG.:43:P43_CONTRACT,P43_PROJECT,P43_STATUS,P43_VENDOR,P43_YEAR:&P1_CONTRACT.,&P1_PROJECT.,&P1_STATUS.,&LABEL.,&P1_YEAR.'
,p_link_target_type=>'REDIRECT_PAGE'
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
 p_id=>wwv_flow_api.id(89125161697990353)
,p_plug_name=>'New'
,p_parent_plug_id=>wwv_flow_api.id(22582803977288908)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>6
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(89125296065990354)
,p_region_id=>wwv_flow_api.id(89125161697990353)
,p_chart_type=>'bar'
,p_title=>'Contract Value and Paid to Date'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_connect_nulls=>'N'
,p_sorting=>'value-desc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_legend_rendered=>'on'
,p_legend_position=>'bottom'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(89125414376990355)
,p_chart_id=>wwv_flow_api.id(89125296065990354)
,p_seq=>10
,p_name=>'Contracts Value'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT  project_name , sum(CONTRACT_AMOUNT) contact_amount ',
'FROM    cwip_payment_recommendation_v',
'where extract(YEAR from payment_recommendation_date) = nvl(:P1_YEAR ,extract(YEAR from payment_recommendation_date) )',
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
'GROUP by project_name',
'order by 1;'))
,p_ajax_items_to_submit=>'P1_YEAR'
,p_items_value_column_name=>'CONTACT_AMOUNT'
,p_items_label_column_name=>'PROJECT_NAME'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'outsideBarEdge'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(89125736376990358)
,p_chart_id=>wwv_flow_api.id(89125296065990354)
,p_seq=>20
,p_name=>'Paid to Date'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT  project_name ,sum(CUMULATIVE_CERIFIED_AMOUNT) paid_amount',
'FROM    cwip_payment_recommendation_v',
'where extract(YEAR from payment_recommendation_date) = nvl(:P1_YEAR ,extract(YEAR from payment_recommendation_date) )',
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
'GROUP by project_name',
'order by 1;'))
,p_items_value_column_name=>'PAID_AMOUNT'
,p_items_label_column_name=>'PROJECT_NAME'
,p_color=>'#C4A527'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'outsideBarEdge'
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(89125481296990356)
,p_chart_id=>wwv_flow_api.id(89125296065990354)
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
 p_id=>wwv_flow_api.id(89125581011990357)
,p_chart_id=>wwv_flow_api.id(89125296065990354)
,p_axis=>'y'
,p_is_rendered=>'off'
,p_format_type=>'decimal'
,p_decimal_places=>0
,p_format_scaling=>'billion'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(89125813485990359)
,p_plug_name=>'New2'
,p_parent_plug_id=>wwv_flow_api.id(22582803977288908)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>30
,p_plug_new_grid_row=>false
,p_plug_new_grid_column=>false
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(89125859076990360)
,p_region_id=>wwv_flow_api.id(89125813485990359)
,p_chart_type=>'bar'
,p_title=>'Contract Value and Paid to Date'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_connect_nulls=>'N'
,p_sorting=>'value-desc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_legend_rendered=>'on'
,p_legend_position=>'bottom'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(89125982303990361)
,p_chart_id=>wwv_flow_api.id(89125859076990360)
,p_seq=>10
,p_name=>'Contracts Value'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PROJECT_NUMBER,Project_name, count(CONTRACT_NUMBER) contracts_count, round(Sum(CONTRACT_AMOUNT)/1000000, 1) contracts_amount',
'from ',
'        (select      ccp.project_number ',
'                     ,(select nvl(p.dct_project_name , p.project_name)',
'                        from project p',
'                        where p.project_number = ccp.project_number',
'                                                    ) Project_name   ',
'                   ,ccp.contract_number ',
'                   ,(select cc.contract_amount',
'                      from cwip_contract cc',
'                      where cc.contract_number = ccp.contract_number ) contract_amount',
'        from cwip_contract_projects ccp',
'        Where ccp.project_number in ( select ct.PROJECT_NUMBER',
'                                      from CWIP_TEAM ct',
'                                     where 1=1',
'                                     and ct.role_id in (Select r.role_id from project_role r where r.category_id = 2)',
'                                     and status = ''A''',
'                                     and sysdate BETWEEN nvl(start_date , sysdate -1) and nvl(end_date, sysdate +10)',
'                                     and ct.person_type = ''INT''',
'                                     and ct.person_id = :PERSON_ID)',
'        OR ccp.project_number in (select x.project_number ',
'                            from project x',
'                            where x.project_type = ''Capital''',
'                            and exists (select 1 ',
'                                        from cwip_team',
'                                        where cwip_team.person_id = :PERSON_ID',
'                                        and cwip_team.project_number is null) )                             ',
'        or ccp.project_number in (select x.project_number',
'                                    from project x',
'                                    where :PERSON_ID = 680461 )                             ',
'                                     ',
'        )',
'GROUP By project_number , Project_name',
'order by 1;'))
,p_ajax_items_to_submit=>'P1_YEAR'
,p_items_value_column_name=>'CONTRACTS_AMOUNT'
,p_items_label_column_name=>'PROJECT_NAME'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'outsideBarEdge'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(89126111020990362)
,p_chart_id=>wwv_flow_api.id(89125859076990360)
,p_seq=>20
,p_name=>'Paid to Date'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT  project_name ,round(sum(CURRENT_VALUATION_AMOUNT)/1000000 , 1) paid_amount',
'FROM    cwip_payment_recommendation_v',
'where  project_number in ( select PROJECT_NUMBER',
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
'GROUP by project_name',
'order by 1;'))
,p_items_value_column_name=>'PAID_AMOUNT'
,p_items_label_column_name=>'PROJECT_NAME'
,p_color=>'#C4A527'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'outsideBarEdge'
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(89126244971990363)
,p_chart_id=>wwv_flow_api.id(89125859076990360)
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
 p_id=>wwv_flow_api.id(89126344102990364)
,p_chart_id=>wwv_flow_api.id(89125859076990360)
,p_axis=>'y'
,p_is_rendered=>'off'
,p_format_type=>'decimal'
,p_decimal_places=>0
,p_format_scaling=>'billion'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(86569166559893534)
,p_plug_name=>'Actions Center'
,p_icon_css_classes=>'fa-feed'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_span=>7
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(86568888325893531)
,p_plug_name=>'Worklist'
,p_parent_plug_id=>wwv_flow_api.id(86569166559893534)
,p_region_template_options=>'#DEFAULT#:t-TabsRegion-mod--simple:t-TabsRegion-mod--large'
,p_plug_template=>wwv_flow_api.id(10251984453597784)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(85779040798733247)
,p_plug_name=>'My Worklist'
,p_parent_plug_id=>wwv_flow_api.id(86568888325893531)
,p_icon_css_classes=>'fa-braille'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--removeHeader:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    ''fa-file-text-o fa-anim-flash fam-check fam-is-success'' AS         NOTE_ICON,',
'    ''rgb(50,208,45)'' AS                                                NOTE_ICON_COLOR, ',
'    ''REC# ''                         || ',
'     c.reference_number              AS                  NOTE_HEADER,',
'',
'    ''Payment Amount: ''                ||',
'    (trim(to_char(c.CURRENT_VALUATION_AMOUNT,''99,999,999,999.99'') )',
'         ||',
'    '' AED'')',
'    ||',
'     '' ,IPC: ''                       ||',
'     c.ipc_number   AS                                                           NOTE_TEXT,',
'',
'    CASE V(''PERSON_TYPE'')',
'        WHEN ''EXT''  THEN ''<a href="'' || apex_util.prepare_url(''f?p=''',
'                          || v(''APP_ID'')',
'                          || '':8:''',
'                          || V(''APP_SESSION'')',
'                          || ''::NO::P8_PAYMENT_RECOMMENDATION_ID:''',
'                          || h.PAYMENT_RECOMMENDATION_ID)',
'                          || ''" class="t-Button t-Button--small t-Button--hot t-Button--simple t-Button--stretch">'' ',
'                          || c.reference_number',
'                          || ''</a>''',
'        WHEN ''INT''  THEN  ''<a href="'' || apex_util.prepare_url(''f?p=''',
'                          || ''130''    --NV(''APP_ID'')',
'                          || '':15:''',
'                          || V(''APP_SESSION'')',
'                          || ''::NO::P15_PAYMENT_RECOMMENDATION_ID:''',
'                          || h.PAYMENT_RECOMMENDATION_ID)',
'                          || ''" class="t-Button t-Button--small t-Button--hot t-Button--simple t-Button--stretch">'' ',
'                          || c.reference_number',
'                          || ''</a>''',
'    End     ',
'                                                            AS NOTE_LINK, ',
'',
'    ''rgb(50,208,45)'' AS NOTE_COLOR,',
'   -- ''javascript:alert("Accepted");void(0);'' AS NOTE_ACCEPT,',
'    ''javascript:alert("Please open the notification to check the payment details before take action.");void(0);'' AS NOTE_ACCEPT,',
'    ''javascript:alert("Please open the notification to check the payment details before take action.");void(0);'' AS NOTE_DECLINE,',
'    /* When enable Browser Notifications in ConfigJSON then you can select which notifications should not be fire browser not. */',
'    0 AS NO_BROWSER_NOTIFICATION,',
'    h.UPDATED_ON,',
'-- to add worklist table',
'    c.REFERENCE_NUMBER,',
'    c.contract_number,',
'    c.contract_amount,',
'    c.vendor_name,',
'    c.DCT_PROJECT_CODE,',
'    c.Project_number,',
'    c.project_name,',
'    c.PAYMENT_NUMBER,',
'    c.PREVIOUSELY_CERIFIED_APPROVED,',
'    c.PREVIOUSELY_CERIFIED_PENDING,',
'    c.CURRENT_VALUATION_AMOUNT,',
'    c.DEDUCTIONS,',
'    c.CUMULATIVE_CERIFIED_AMOUNT,',
'    c.NET_AMOUNT_PAYABLE,',
'    c.INVOICE_NUM,',
'    c.INVOICE_DATE,',
'    c.TOTAL_INVOICE_AMOUNT,',
'    c.CURRENCY,',
'    c.CONTRACT_STAGE,',
'    c.SCOPE_OF_WORK,',
'    c.REMARK,',
'    c.VALUATION_PERIOD_FROM,',
'    c.PREVIOUS_PAYMENTS,',
'    c.DCT_CONTRACT_VARIATION_AMOUNT,',
'    h.RECEVIED_DATE',
'from cwip_payment_rec_approval_history h , CWIP_PAYMENT_RECOMMENDATION_V c',
'where person_id = NV(''PERSON_ID'')',
'and h.payment_recommendation_id = c.payment_recommendation_id',
'and h.status = ''Pending''',
'and h.action_required in (''Approve/Reject'',''Recommend/Return'' , ''Forward/Return'')',
'',
'UNION All',
'',
'SELECT  ',
'    ''fa-info-circle-o fa-anim-flash'' AS         NOTE_ICON,',
'--    ''fa-info fa-x fa-anim-flash fam-check fam-is-info'' AS         NOTE_ICON,',
'    ''rgb(50,208,45)'' AS                                                NOTE_ICON_COLOR, ',
'    ''Info required for REC# ''   || ',
'     c.reference_number             AS                  NOTE_HEADER,                     ',
'',
'    ''Payment Amount: ''                ||',
'    (trim(to_char(c.CURRENT_VALUATION_AMOUNT,''99,999,999,999.99'') )',
'         ||',
'    '' AED'')',
'    ||',
'     '' ,IPC: ''                       ||',
'     c.ipc_number       AS                                 NOTE_TEXT,',
'',
'    CASE V(''PERSON_TYPE'')',
'        WHEN ''EXT''  THEN ''<a href="'' || apex_util.prepare_url(''f?p=''',
'                          || v(''APP_ID'')',
'                          || '':28:''',
'                          || V(''APP_SESSION'')',
'                          || ''::NO::P28_PAYMENT_RECOMMENDATION_ID:''',
'                          || h.PAYMENT_RECOMMENDATION_ID)',
'                          || ''" class="t-Button t-Button--small t-Button--hot t-Button--simple t-Button--stretch">'' ',
'                          || c.reference_number',
'                          || ''</a>''                          ',
'        WHEN ''INT''  THEN  ''<a href="'' || apex_util.prepare_url(''f?p=130''',
'                    --      || NV(''APP_ID'')',
'                          || '':28:''',
'                          || V(''APP_SESSION'')',
'                          || ''::NO::P28_PAYMENT_RECOMMENDATION_ID:''',
'                          || h.PAYMENT_RECOMMENDATION_ID)',
'                          || ''" class="t-Button t-Button--small t-Button--hot t-Button--simple t-Button--stretch">'' ',
'                          || c.reference_number',
'                          || ''</a>''                          ',
'    End     ',
'                                                            AS NOTE_LINK, ',
'',
'    ''rgb(50,208,45)'' AS NOTE_COLOR,',
'    ''javascript:alert("Please open the notification to check the payment details before take action.");void(0);'' AS NOTE_ACCEPT,',
'    ''javascript:alert("Please open the notification to check the payment details before take action.");void(0);'' AS NOTE_DECLINE,',
'    /* When enable Browser Notifications in ConfigJSON then you can select which notifications should not be fire browser not. */',
'    0 AS NO_BROWSER_NOTIFICATION,',
'    h.UPDATED_ON,',
'-- to add worklist table    ',
'    c.REFERENCE_NUMBER,',
'    c.contract_number,',
'    c.contract_amount,',
'    c.vendor_name,',
'    c.DCT_PROJECT_CODE,',
'    c.Project_number,',
'    c.project_name,',
'    c.PAYMENT_NUMBER,',
'    c.PREVIOUSELY_CERIFIED_APPROVED,',
'    c.PREVIOUSELY_CERIFIED_PENDING,',
'    c.CURRENT_VALUATION_AMOUNT,',
'    c.DEDUCTIONS,',
'    c.CUMULATIVE_CERIFIED_AMOUNT,',
'    c.NET_AMOUNT_PAYABLE,',
'    c.INVOICE_NUM,',
'    c.INVOICE_DATE,',
'    c.TOTAL_INVOICE_AMOUNT,',
'    c.CURRENCY,',
'    c.CONTRACT_STAGE,',
'    c.SCOPE_OF_WORK,',
'    c.REMARK,',
'    c.VALUATION_PERIOD_FROM,',
'    c.PREVIOUS_PAYMENTS,',
'    c.DCT_CONTRACT_VARIATION_AMOUNT,',
'    h.RECEVIED_DATE',
'from cwip_payment_rec_approval_history h , CWIP_PAYMENT_RECOMMENDATION_V c',
'where person_id = NV(''PERSON_ID'')',
'and h.payment_recommendation_id = c.payment_recommendation_id',
'and h.status = ''Pending''',
'and h.action_required = ''Additional Info'''))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'My Worklist'
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
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(85779074026733248)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No action pending'
,p_allow_save_rpt_public=>'Y'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>126215115855635518
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85782319112733280)
,p_db_column_name=>'REFERENCE_NUMBER'
,p_display_order=>10
,p_column_identifier=>'AF'
,p_column_label=>'Reference Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85780249701733259)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>20
,p_column_identifier=>'K'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85780259254733260)
,p_db_column_name=>'CONTRACT_AMOUNT'
,p_display_order=>30
,p_column_identifier=>'L'
,p_column_label=>'PO Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85780413138733261)
,p_db_column_name=>'VENDOR_NAME'
,p_display_order=>40
,p_column_identifier=>'M'
,p_column_label=>'Vendor Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85780460987733262)
,p_db_column_name=>'DCT_PROJECT_CODE'
,p_display_order=>50
,p_column_identifier=>'N'
,p_column_label=>'DCT Project Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85780597176733263)
,p_db_column_name=>'PAYMENT_NUMBER'
,p_display_order=>60
,p_column_identifier=>'O'
,p_column_label=>'Payment Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85780694738733264)
,p_db_column_name=>'PREVIOUSELY_CERIFIED_APPROVED'
,p_display_order=>70
,p_column_identifier=>'P'
,p_column_label=>'Previousely Cerified Approved'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85780835512733265)
,p_db_column_name=>'PREVIOUSELY_CERIFIED_PENDING'
,p_display_order=>80
,p_column_identifier=>'Q'
,p_column_label=>'Previousely Cerified Pending'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85780941122733266)
,p_db_column_name=>'CURRENT_VALUATION_AMOUNT'
,p_display_order=>90
,p_column_identifier=>'R'
,p_column_label=>'Current Valuation Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85781012211733267)
,p_db_column_name=>'DEDUCTIONS'
,p_display_order=>100
,p_column_identifier=>'S'
,p_column_label=>'Deductions'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85781074403733268)
,p_db_column_name=>'CUMULATIVE_CERIFIED_AMOUNT'
,p_display_order=>110
,p_column_identifier=>'T'
,p_column_label=>'Cumulative Cerified Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85781230529733269)
,p_db_column_name=>'NET_AMOUNT_PAYABLE'
,p_display_order=>120
,p_column_identifier=>'U'
,p_column_label=>'Net Amount Payable'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85781273750733270)
,p_db_column_name=>'INVOICE_NUM'
,p_display_order=>130
,p_column_identifier=>'V'
,p_column_label=>'Invoice Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85781377558733271)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>140
,p_column_identifier=>'W'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85781537545733272)
,p_db_column_name=>'TOTAL_INVOICE_AMOUNT'
,p_display_order=>150
,p_column_identifier=>'X'
,p_column_label=>'Total Invoice Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85781631922733273)
,p_db_column_name=>'CURRENCY'
,p_display_order=>160
,p_column_identifier=>'Y'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85781705780733274)
,p_db_column_name=>'CONTRACT_STAGE'
,p_display_order=>170
,p_column_identifier=>'Z'
,p_column_label=>'Contract Stage'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85781785175733275)
,p_db_column_name=>'SCOPE_OF_WORK'
,p_display_order=>180
,p_column_identifier=>'AA'
,p_column_label=>'Scope Of Work'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85781889350733276)
,p_db_column_name=>'REMARK'
,p_display_order=>190
,p_column_identifier=>'AB'
,p_column_label=>'Remark'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85781997984733277)
,p_db_column_name=>'VALUATION_PERIOD_FROM'
,p_display_order=>200
,p_column_identifier=>'AC'
,p_column_label=>'Valuation Period From'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85782157362733278)
,p_db_column_name=>'PREVIOUS_PAYMENTS'
,p_display_order=>210
,p_column_identifier=>'AD'
,p_column_label=>'Previous Payments'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85782204382733279)
,p_db_column_name=>'DCT_CONTRACT_VARIATION_AMOUNT'
,p_display_order=>220
,p_column_identifier=>'AE'
,p_column_label=>'Dct Contract Variation Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85779195653733249)
,p_db_column_name=>'NOTE_ICON'
,p_display_order=>230
,p_column_identifier=>'A'
,p_column_label=>'Note Icon'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85779353177733250)
,p_db_column_name=>'NOTE_ICON_COLOR'
,p_display_order=>240
,p_column_identifier=>'B'
,p_column_label=>'Note Icon Color'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85779361780733251)
,p_db_column_name=>'NOTE_HEADER'
,p_display_order=>250
,p_column_identifier=>'C'
,p_column_label=>'Note Header'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85779471352733252)
,p_db_column_name=>'NOTE_TEXT'
,p_display_order=>260
,p_column_identifier=>'D'
,p_column_label=>'Note Text'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85779587978733253)
,p_db_column_name=>'NOTE_LINK'
,p_display_order=>270
,p_column_identifier=>'E'
,p_column_label=>'Reference Number'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_format_mask=>'PCT_GRAPH:::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85779711619733254)
,p_db_column_name=>'NOTE_COLOR'
,p_display_order=>280
,p_column_identifier=>'F'
,p_column_label=>'Note Color'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85779831457733255)
,p_db_column_name=>'NOTE_ACCEPT'
,p_display_order=>290
,p_column_identifier=>'G'
,p_column_label=>'Note Accept'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85779882543733256)
,p_db_column_name=>'NOTE_DECLINE'
,p_display_order=>300
,p_column_identifier=>'H'
,p_column_label=>'Note Decline'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85779976726733257)
,p_db_column_name=>'NO_BROWSER_NOTIFICATION'
,p_display_order=>310
,p_column_identifier=>'I'
,p_column_label=>'No Browser Notification'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85780156259733258)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>320
,p_column_identifier=>'J'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89124669925990348)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89124815781990349)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89124931075990350)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Pending Since'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(86545393726110172)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1269815'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PROJECT_NAME:VENDOR_NAME:PAYMENT_NUMBER:CURRENT_VALUATION_AMOUNT:RECEVIED_DATE:NOTE_LINK:'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(178212636119489556)
,p_application_user=>'TCA1206'
,p_name=>'2023_Payments'
,p_description=>'Payments'
,p_report_seq=>10
,p_report_columns=>'PROJECT_NAME:VENDOR_NAME:PAYMENT_NUMBER:CURRENT_VALUATION_AMOUNT:RECEVIED_DATE:NOTE_LINK:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(149162782770496957)
,p_plug_name=>'My Actions History'
,p_parent_plug_id=>wwv_flow_api.id(86568888325893531)
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton'
,p_plug_template=>wwv_flow_api.id(10243288598597779)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'        h.id',
'       ,pr.payment_recommendation_id ',
'       ,pr.reference_number',
'       ,pr.payment_number',
'       ,pr.payment_recommendation_date',
'       ,pr.invoice_num',
'       ,pr.invoice_date',
'       ,pr.total_invoice_amount',
'       ,pr.vendor_name',
'       ,pr.contract_number',
'       ,pr.contract_amount',
'       ,pr.contract_title',
'       ,pr.contract_description',
'       ,pr.contract_reference',
'       ,pr.project_number',
'       ,pr.project_name',
'       ,h.role_id',
'       ,h.action_required',
'       ,h.action_date',
'       ,h.recevied_date',
'       ,h.status',
'       ,h.comments  "comment"',
'       ,h.approval_type',
'       ,pr.CURRENT_VALUATION_AMOUNT',
'from cwip_payment_rec_approval_history h , cwip_payment_recommendation_v pr',
'where h.payment_recommendation_id = pr.payment_recommendation_id',
'and h.person_type = ''INT''',
'and h.person_id = :PERSON_ID  ',
'and h.status not in ( ''Future'' , ''Pending'')',
'order by h.action_date desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Notifications History'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(149162961286496957)
,p_name=>'Notifications History'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:56:&SESSION.::&DEBUG.::P56_PAYMENT_RECOMMENDATION_ID,P56_PAGE_FROM,P56_ID:#PAYMENT_RECOMMENDATION_ID#,32,#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>189599003115399227
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86577061266868184)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86577536674868183)
,p_db_column_name=>'REFERENCE_NUMBER'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Reference Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86577899979868183)
,p_db_column_name=>'PAYMENT_NUMBER'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Payment Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86578284047868183)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_DATE'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'REC Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86578733747868183)
,p_db_column_name=>'INVOICE_NUM'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Invoice Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86579111957868183)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86579460113868182)
,p_db_column_name=>'TOTAL_INVOICE_AMOUNT'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Total Invoice Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86579942830868182)
,p_db_column_name=>'VENDOR_NAME'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Vendor Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86580276684868182)
,p_db_column_name=>'CONTRACT_AMOUNT'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Contract Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86580687541868182)
,p_db_column_name=>'CONTRACT_TITLE'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Contract Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86581119712868182)
,p_db_column_name=>'CONTRACT_DESCRIPTION'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Contract Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86581470542868181)
,p_db_column_name=>'CONTRACT_REFERENCE'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Contract Reference'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86581915670868181)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86582282807868181)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86582684483868181)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Role Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86583122321868181)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86583535137868181)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86583908358868180)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86584336616868180)
,p_db_column_name=>'STATUS'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86584725132868180)
,p_db_column_name=>'comment'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86585073756868180)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86576349179868184)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>31
,p_column_identifier=>'V'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86576752239868184)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>41
,p_column_identifier=>'W'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89124983205990351)
,p_db_column_name=>'CURRENT_VALUATION_AMOUNT'
,p_display_order=>51
,p_column_identifier=>'X'
,p_column_label=>'Current Valuation Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(149171767159498813)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1270215'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>5
,p_report_columns=>'PROJECT_NAME:VENDOR_NAME:PAYMENT_NUMBER:REFERENCE_NUMBER:CURRENT_VALUATION_AMOUNT:ACTION_DATE:STATUS:'
,p_sort_column_1=>'ACTION_DATE'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(89125153611990352)
,p_plug_name=>'Pie'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(22582954013288909)
,p_plug_name=>'Count By Approval Status'
,p_parent_plug_id=>wwv_flow_api.id(89125153611990352)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>10
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select COUNT(payment_recommendation_id) value,',
'      approval_status,',
'      case approval_status',
'        when ''Approved''',
'            then ''#008000''',
'        when ''Rejected''',
'            then    ''#FF0000''',
'        when ''In-Progress''',
'            then    ''#FFFF00''',
'        when ''Hold''',
'            then    ''#D0D09A''    ',
'    End status_color',
'from cwip_payment_recommendation_v',
'where 1=1 ',
'and project_number = nvl(:P1_PROJECT , project_number)',
'and extract(YEAR from payment_recommendation_date) = :P1_YEAR',
'and (project_number in ( select PROJECT_NUMBER',
'                          from CWIP_TEAM',
'                         where 1=1',
'                         and role_id in (Select r.role_id from project_role r where r.category_id = 2)',
'                         and status = ''A''',
'                         and sysdate BETWEEN nvl(start_date , sysdate -1) and nvl(end_date, sysdate +10)',
'--                         and person_type = ''INT''',
'                         and person_id = :PERSON_ID)',
'OR project_number in (select x.project_number ',
'                        from project x',
'                        where project_type = ''Capital''',
'                        and exists (select 1 ',
'                                    from cwip_team',
'                                    where cwip_team.person_id = :PERSON_ID',
'                                    and cwip_team.project_number is null) )    ',
'or project_number in (select x.project_number',
'                        from project x',
'                        where :PERSON_ID = 680461 ))',
'GROUP BY approval_status'))
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_ajax_items_to_submit=>'P1_YEAR,P1_PROJECT'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(22583018452288910)
,p_region_id=>wwv_flow_api.id(22582954013288909)
,p_chart_type=>'donut'
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
'      approval_status,',
'      case approval_status',
'        when ''Approved''',
'            then ''#008000''',
'        when ''Rejected''',
'            then    ''#FF0000''',
'        when ''In-Progress''',
'            then    ''#f5ec11''',
'        when ''Hold''',
'            then    ''#5ac0e2''',
'       when ''Returned''',
'            then    ''#5ac0e2''     ',
'    End status_color',
'from cwip_payment_recommendation_v',
'where 1=1 ',
'and project_number = nvl(:P1_PROJECT , project_number)',
'--and extract(YEAR from nvl(payment_recommendation_date,SUBMITTED_ON)) = :P1_YEAR',
'and (project_number in ( select PROJECT_NUMBER',
'                          from CWIP_TEAM',
'                         where 1=1',
'                         and role_id in (Select r.role_id from project_role r where r.category_id = 2)',
'                         and status = ''A''',
'                         and sysdate BETWEEN nvl(start_date , sysdate -1) and nvl(end_date, sysdate +10)',
'--                         and person_type = ''INT''',
'                         and person_id = :PERSON_ID)',
'OR project_number in (select x.project_number ',
'                        from project x',
'                        where project_type = ''Capital''',
'                        and exists (select 1 ',
'                                    from cwip_team',
'                                    where cwip_team.person_id = :PERSON_ID',
'                                    and cwip_team.project_number is null) )    ',
'or project_number in (select x.project_number',
'                        from project x',
'                        where :PERSON_ID = 680461 ))',
'GROUP BY approval_status'))
,p_ajax_items_to_submit=>'P1_YEAR,P1_PROJECT,P1_CONTRACT,P1_STATUS'
,p_items_value_column_name=>'VALUE'
,p_items_label_column_name=>'APPROVAL_STATUS'
,p_color=>'&STATUS_COLOR.'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'LBL_VAL'
,p_link_target=>'f?p=&APP_ID.:43:&SESSION.::&DEBUG.:43:P43_CONTRACT,P43_PROJECT,P43_STATUS,P43_YEAR:&P1_CONTRACT.,&P1_PROJECT.,&APPROVAL_STATUS.,&P1_YEAR.'
,p_link_target_type=>'REDIRECT_PAGE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(261617608010570)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(259371050010548)
,p_button_name=>'Clear'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconLeft:t-Button--hoverIconSpin:t-Button--gapRight:t-Button--gapBottom'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'Clear'
,p_button_position=>'BODY'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-refresh'
,p_grid_new_row=>'Y'
,p_grid_column=>12
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(259629345010550)
,p_name=>'P1_YEAR'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(259371050010548)
,p_prompt=>'Year'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select extract(year from sysdate) y ',
'from dual'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:2015;2015,2016;2016,2017;2017,2018;2018,2019;2019,2020;2020,2021;2021,2022;2022,2023;2023,To-Date;1000'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10306029722597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large:margin-left-lg:margin-right-none'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(260141445010555)
,p_name=>'P1_PROJECT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(259371050010548)
,p_item_default=>'NULL'
,p_prompt=>'Project'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct cpr.project_number  ||',
'    '' - ''                           ||',
'    (select p.dct_project_code',
'     from project p',
'     where p.project_number = cpr.project_number) d,',
'     cpr.project_number',
'from cwip_payment_recommendation_v cpr',
'where cpr.project_number in (select PROJECT_NUMBER',
'   from CWIP_TEAM',
'     where 1=1',
'     and role_id in (Select r.role_id from project_role r where r.category_id = 2)',
'     and status = ''A''',
'     and sysdate BETWEEN nvl(start_date , sysdate -1) and nvl(end_date, sysdate +10)',
'--                         and person_type = ''INT''',
'     and person_id = :PERSON_ID',
'UNION ALL',
'select x.project_number ',
'from project x',
'where project_type = ''Capital''',
'and exists (select 1 ',
'            from cwip_team',
'            where cwip_team.person_id = :PERSON_ID',
'            and cwip_team.project_number is null) ',
'UNION ALL    ',
'select x.project_number',
'    from project x',
'    where :PERSON_ID = 680461 ',
'    and project_type = ''Capital'')',
'order by 2;'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- All -'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10306029722597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large:margin-left-none:margin-right-none'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(260891394010563)
,p_name=>'P1_CONTRACT'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(259371050010548)
,p_prompt=>'Contract'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select D, CONTRACT_NUMBER',
'from ',
'(select distinct cpr.contract_number  ||',
'    '' - ''                           ||',
'    (select cp.contract_reference',
'     from cwip_contract cp',
'     where cp.contract_number = cpr.contract_number) d,',
'     cpr.contract_number',
'from cwip_payment_recommendation_v cpr',
'where (cpr.project_number in (select PROJECT_NUMBER',
'                           from CWIP_TEAM',
'                             where 1=1',
'                             and role_id in (Select r.role_id ',
'                                            from project_role r ',
'                                            where r.category_id = 2)',
'                             and status = ''A''',
'                             and sysdate BETWEEN nvl(start_date , sysdate -1) ',
'                                            and nvl(end_date, sysdate +10)',
'                        --                         and person_type = ''INT''',
'                             and person_id = :PERSON_ID',
'UNION ALL',
'select x.project_number ',
'from project x',
'where project_type = ''Capital''',
'and exists (select 1 ',
'            from cwip_team',
'            where cwip_team.person_id = :PERSON_ID',
'            and cwip_team.project_number is null) ',
'UNION ALL    ',
'select x.project_number',
'    from project x',
'    where :PERSON_ID = 680461 ',
'    and project_type = ''Capital''))',
'and cpr.project_number = NVL(:P1_PROJECT, cpr.project_number))',
'order by 2;    '))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- All -'
,p_lov_cascade_parent_items=>'P1_PROJECT'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10306029722597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(261114814010565)
,p_name=>'P1_STATUS'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(259371050010548)
,p_item_default=>'NULL'
,p_prompt=>'Status'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT APPROVAL_STATUS d, APPROVAL_STATUS',
'from cwip_payment_recommendation cpr'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- All -'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10306029722597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(259723277010551)
,p_name=>'Year -Refresh Chart'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1_YEAR'
,p_condition_element=>'P1_YEAR'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'1000'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(89126434707990365)
,p_event_id=>wwv_flow_api.id(259723277010551)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(89125813485990359)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(89126686822990368)
,p_event_id=>wwv_flow_api.id(259723277010551)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(89125161697990353)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(89126836131990369)
,p_event_id=>wwv_flow_api.id(259723277010551)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(89125813485990359)
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(89126957719990370)
,p_event_id=>wwv_flow_api.id(259723277010551)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(89125161697990353)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(89126488050990366)
,p_event_id=>wwv_flow_api.id(259723277010551)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(89125813485990359)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(89126657950990367)
,p_event_id=>wwv_flow_api.id(259723277010551)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(89125161697990353)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(260282278010557)
,p_name=>'Project Refresh Chart DA'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1_PROJECT'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(260385367010558)
,p_event_id=>wwv_flow_api.id(260282278010557)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(22582954013288909)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(260732054010561)
,p_event_id=>wwv_flow_api.id(260282278010557)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(22582301886288903)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(260815688010562)
,p_event_id=>wwv_flow_api.id(260282278010557)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(22507035300061647)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(260972084010564)
,p_event_id=>wwv_flow_api.id(260282278010557)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1_CONTRACT'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(261180099010566)
,p_name=>'Contract Refresh Chart DA'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1_CONTRACT'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(261327269010567)
,p_event_id=>wwv_flow_api.id(261180099010566)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(22582954013288909)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(261394109010568)
,p_event_id=>wwv_flow_api.id(261180099010566)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(22507035300061647)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(261495104010569)
,p_event_id=>wwv_flow_api.id(261180099010566)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(22582301886288903)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(261720505010571)
,p_name=>'Approval Status Refresh Chart DA'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1_STATUS'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(261792908010572)
,p_event_id=>wwv_flow_api.id(261720505010571)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(22582954013288909)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(261912593010573)
,p_event_id=>wwv_flow_api.id(261720505010571)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(22507035300061647)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(262003003010574)
,p_event_id=>wwv_flow_api.id(261720505010571)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(22582301886288903)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(262128834010575)
,p_name=>'Clear DA'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(261617608010570)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(262232974010576)
,p_event_id=>wwv_flow_api.id(262128834010575)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1_PROJECT,P1_CONTRACT,P1_STATUS'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(262329173010577)
,p_event_id=>wwv_flow_api.id(262128834010575)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1_YEAR'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select extract(year from sysdate) y ',
'from dual'))
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.component_end;
end;
/
