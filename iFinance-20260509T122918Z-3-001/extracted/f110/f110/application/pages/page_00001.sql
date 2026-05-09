prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
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
 p_id=>1
,p_user_interface_id=>wwv_flow_api.id(13327188105480887)
,p_name=>'Home'
,p_alias=>'HOME'
,p_step_title=>'Budget Allocation'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function fnc_calcTotalSal() {',
'    var n_salary, n_bonus, n_total;',
'    ',
'    n_salary = parseFloat($v("P1_SAL"), 10) ? parseFloat($v("P1_SAL"), 10) : 0;',
'    ',
'    n_bonus = parseFloat($v("P1_BOUNS"), 10) ? parseFloat($v("P1_BOUNS"), 10) : 0; ',
'    ',
'    n_total = n_salary + n_bonus;  ',
'    ',
'    $s("P1_TOTAL", parseFloat(n_total, 10));',
'',
'}'))
,p_step_template=>wwv_flow_api.id(13200569725480777)
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210112080943'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(13338048015480947)
,p_plug_name=>'Budget Allocation'
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
 p_id=>wwv_flow_api.id(18677854379804840)
,p_plug_name=>'Chapter 2'
,p_icon_css_classes=>'fa-number-2-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(13242565869480804)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CHAPTER, SECTOR, APPROVED_AMOUNT, PROPOSAL_2021, DEPARTMENT_ALLOCATED_2021, PROJECT_ALLOCATED_2021',
'from ',
'(select      d.CHAPTER',
'           ,d.SECTOR',
'           ,d.approved_amount',
'           ,(select round(sum(nvl(p.budget_2021,0)),2) ',
'                   from proposed_budget p',
'                  where p.scenario_name = :P1_SCENARIO',
'                  and p.scenario_year = :P1_BUDGET_YEAR',
'                  and p.sector = d.SECTOR',
'                  and p.chapter  = d.CHAPTER)  proposal_2021',
'            ,(select round(sum(nvl(dept.approved_amount,0)),2) ',
'                from approved_budget_by_department dept',
'                where dept.chapter = d.chapter',
'                and dept.sector = d.sector',
'                and dept.proposed_scenario = :P1_SCENARIO',
'                and dept.budget_year = :P1_BUDGET_YEAR',
'                and dept.budget_version = :P1_VERSION ) Department_allocated_2021',
'             ,(select round(sum(nvl(proj.approved_amount,0)),2) ',
'                from approved_budget_by_project proj',
'                where proj.chapter = d.chapter',
'                and proj.sector = d.sector',
'                and proj.proposed_scenario = :P1_SCENARIO',
'                and proj.budget_year = :P1_BUDGET_YEAR',
'                and proj.budget_version = :P1_VERSION ) project_allocated_2021     ',
'                  ',
'from ',
'(select CHAPTER,',
'       SECTOR,',
'       sum(nvl(APPROVED_AMOUNT,0)) approved_amount',
'  from APPROVED_BUDGET',
' where BUDGET_YEAR = :P1_BUDGET_YEAR',
'and PROPOSED_SCENARIO = :P1_SCENARIO',
'and BUDGET_VERSION = :P1_VERSION',
'GROUP BY chapter , sector) d',
'order by d.chapter , d.sector)',
'where CHAPTER = 2'))
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_ajax_items_to_submit=>'P1_BUDGET_YEAR,P1_VERSION,P1_SCENARIO'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(18677942698804841)
,p_region_id=>wwv_flow_api.id(18677854379804840)
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
,p_legend_position=>'top'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(18678094894804842)
,p_chart_id=>wwv_flow_api.id(18677942698804841)
,p_seq=>10
,p_name=>'proposal'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'PROPOSAL_2021'
,p_items_label_column_name=>'SECTOR'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(18678431185804846)
,p_chart_id=>wwv_flow_api.id(18677942698804841)
,p_seq=>20
,p_name=>'Approved'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'APPROVED_AMOUNT'
,p_items_label_column_name=>'SECTOR'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(18678660461804848)
,p_chart_id=>wwv_flow_api.id(18677942698804841)
,p_seq=>30
,p_name=>'Departments Allocated'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'DEPARTMENT_ALLOCATED_2021'
,p_items_label_column_name=>'SECTOR'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(18678786489804849)
,p_chart_id=>wwv_flow_api.id(18677942698804841)
,p_seq=>40
,p_name=>'Projects Allocated'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'PROJECT_ALLOCATED_2021'
,p_items_label_column_name=>'SECTOR'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(18678106610804843)
,p_chart_id=>wwv_flow_api.id(18677942698804841)
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
 p_id=>wwv_flow_api.id(18678294028804844)
,p_chart_id=>wwv_flow_api.id(18677942698804841)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_format_type=>'decimal'
,p_decimal_places=>0
,p_format_scaling=>'million'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'top'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(18678332518804845)
,p_plug_name=>'Filter By'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(13242565869480804)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(18678801735804850)
,p_plug_name=>'Chapter 3'
,p_icon_css_classes=>'fa-number-3-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(13242565869480804)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CHAPTER, SECTOR, APPROVED_AMOUNT, PROPOSAL_2021, DEPARTMENT_ALLOCATED_2021, PROJECT_ALLOCATED_2021',
'from ',
'(select      d.CHAPTER',
'           ,d.SECTOR',
'           ,d.approved_amount',
'           ,(select round(sum(nvl(p.budget_2021,0)),2) ',
'                   from proposed_budget p',
'                  where p.scenario_name = :P1_SCENARIO',
'                  and p.scenario_year = :P1_BUDGET_YEAR',
'                  and p.sector = d.SECTOR',
'                  and p.chapter  = d.CHAPTER)  proposal_2021',
'            ,(select round(sum(nvl(dept.approved_amount,0)),2) ',
'                from approved_budget_by_department dept',
'                where dept.chapter = d.chapter',
'                and dept.sector = d.sector',
'                and dept.proposed_scenario = :P1_SCENARIO',
'                and dept.budget_year = :P1_BUDGET_YEAR',
'                and dept.budget_version = :P1_VERSION ) Department_allocated_2021',
'             ,(select round(sum(nvl(proj.approved_amount,0)),2) ',
'                from approved_budget_by_project proj',
'                where proj.chapter = d.chapter',
'                and proj.sector = d.sector',
'                and proj.proposed_scenario = :P1_SCENARIO',
'                and proj.budget_year = :P1_BUDGET_YEAR',
'                and proj.budget_version = :P1_VERSION ) project_allocated_2021     ',
'                  ',
'from ',
'(select CHAPTER,',
'       SECTOR,',
'       sum(nvl(APPROVED_AMOUNT,0)) approved_amount',
'  from APPROVED_BUDGET',
' where BUDGET_YEAR = :P1_BUDGET_YEAR',
'and PROPOSED_SCENARIO = :P1_SCENARIO',
'and BUDGET_VERSION = :P1_VERSION',
'GROUP BY chapter , sector) d',
'order by d.chapter , d.sector)',
'where CHAPTER = 3'))
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_ajax_items_to_submit=>'P1_BUDGET_YEAR,P1_VERSION,P1_SCENARIO'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(18754230095094101)
,p_region_id=>wwv_flow_api.id(18678801735804850)
,p_chart_type=>'bar'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'on'
,p_data_cursor_behavior=>'smooth'
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
,p_legend_position=>'top'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(18754337696094102)
,p_chart_id=>wwv_flow_api.id(18754230095094101)
,p_seq=>10
,p_name=>'proposal'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'PROPOSAL_2021'
,p_items_label_column_name=>'SECTOR'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(18754491331094103)
,p_chart_id=>wwv_flow_api.id(18754230095094101)
,p_seq=>20
,p_name=>'Approved'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'APPROVED_AMOUNT'
,p_items_label_column_name=>'SECTOR'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(18754590798094104)
,p_chart_id=>wwv_flow_api.id(18754230095094101)
,p_seq=>30
,p_name=>'Departments Allocated'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'DEPARTMENT_ALLOCATED_2021'
,p_items_label_column_name=>'SECTOR'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(18754616111094105)
,p_chart_id=>wwv_flow_api.id(18754230095094101)
,p_seq=>40
,p_name=>'Projects Allocated'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'PROJECT_ALLOCATED_2021'
,p_items_label_column_name=>'SECTOR'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(18754760722094106)
,p_chart_id=>wwv_flow_api.id(18754230095094101)
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
 p_id=>wwv_flow_api.id(18754824373094107)
,p_chart_id=>wwv_flow_api.id(18754230095094101)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_format_type=>'decimal'
,p_decimal_places=>0
,p_format_scaling=>'million'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'top'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18738807699240775)
,p_name=>'P1_BUDGET_YEAR'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(18678332518804845)
,p_prompt=>'Budget Year'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct budget_year d, budget_year r',
'from approved_budget'))
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(13303519834480852)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18739122360243117)
,p_name=>'P1_VERSION'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(18678332518804845)
,p_prompt=>'Version'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct BUDGET_VERSION d, BUDGET_VERSION r',
'from approved_budget'))
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(13303519834480852)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18739469649247045)
,p_name=>'P1_SCENARIO'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(18678332518804845)
,p_prompt=>'Scenario'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct PROPOSED_SCENARIO d, PROPOSED_SCENARIO r',
'from approved_budget'))
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(13303519834480852)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(18493498277956108)
,p_name=>'New'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1_SAL,P1_BOUNS'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(18493566149956109)
,p_event_id=>wwv_flow_api.id(18493498277956108)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1_TOTAL'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>'to_number(replace(nvl(:P1_SAL,0),'','','''')) + to_number(replace(nvl(:P1_BOUNS,0),'','','''') )'
,p_attribute_07=>'P1_SAL,P1_BOUNS'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.component_end;
end;
/
