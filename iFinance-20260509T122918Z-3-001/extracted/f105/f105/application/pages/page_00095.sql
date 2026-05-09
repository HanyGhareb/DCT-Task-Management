prompt --application/pages/page_00095
begin
--   Manifest
--     PAGE: 00095
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
 p_id=>95
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Sector Planner'
,p_alias=>'SECTOR-PLANNER'
,p_step_title=>'Sector Planner'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230430194833'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(50229900596855800)
,p_plug_name=>'Budget Proposal Plan'
,p_icon_css_classes=>'fa-search'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(49721753105526589)
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(49721141929526588)
,p_plug_name=>'Sector Planner'
,p_icon_css_classes=>'fa-creative-commons'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ps.ID,',
'       ps.PLAN_ID,',
'       ps.SECTOR_ID,',
'       ps.SECTOR_INSTRUCTIONS,',
'       ps.COMMENTS,',
'       ps.STATUS,',
'       ps.ALLOW_ADD_COST_CENTER_YN,',
'       ps.ALLOW_ADD_PROJECT_YN,',
'       ps.ALLOW_ADD_TASK_YN,',
'       ps.CEILING_CH1_REQUIRED_YN,',
'       ps.CEILING_CH1_AMOUNT,',
'       ps.CEILING_CH2_REQUIRED_YN,',
'       ps.CEILING_CH2_AMOUNT,',
'       ps.CEILING_CH3_REQUIRED_YN,',
'       ps.CEILING_CH3_AMOUNT,',
'       ps.CEILING_CH6_REQUIRED_YN,',
'       ps.CEILING_CH6_AMOUNT,',
'       ps.CREATED_BY,',
'       ps.CREATED_ON,',
'       ps.UPDATED_BY,',
'       ps.UPDATED_ON,',
'       (select COUNT(*) ',
'       from budget_proposal_cost_centers_plans cc',
'       where cc.plan_id = ps.plan_id',
'       and cc.sector_id = ps.sector_id) Cost_centers_count',
'  from BUDGET_PROPOSAL_SECTORS_PLANS ps',
'  where ps.plan_id = :P95_PLAN'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P95_PLAN'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Sector Planner'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(49721055876526588)
,p_name=>'Sector Planner'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>163562976512658044
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49720714543526586)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49720325950526585)
,p_db_column_name=>'PLAN_ID'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Plan'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(49565096744743668)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49719896178526585)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1216232005294941)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49719065044526585)
,p_db_column_name=>'CEILING_CH1_REQUIRED_YN'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Ceiling Ch1 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P95_PLAN) = ''M'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49718702154526585)
,p_db_column_name=>'CEILING_CH1_AMOUNT'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Ceiling Ch1 Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P95_PLAN) = ''M'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49718287773526584)
,p_db_column_name=>'CEILING_CH2_REQUIRED_YN'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Ceiling Ch2 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P95_PLAN) = ''E'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49717905294526584)
,p_db_column_name=>'CEILING_CH2_AMOUNT'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Ceiling Ch2 Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P95_PLAN) = ''E'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49717526512526584)
,p_db_column_name=>'CEILING_CH3_REQUIRED_YN'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Ceiling Ch3 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P95_PLAN) = ''E'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49717119781526584)
,p_db_column_name=>'CEILING_CH3_AMOUNT'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Ceiling Ch3 Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P95_PLAN) = ''E'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49716678014526584)
,p_db_column_name=>'CEILING_CH6_REQUIRED_YN'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Ceiling Ch6 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P95_PLAN) = ''C'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49716327768526583)
,p_db_column_name=>'CEILING_CH6_AMOUNT'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Ceiling Ch6 Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P95_PLAN) = ''C'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49715877667526583)
,p_db_column_name=>'STATUS'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49715104191526583)
,p_db_column_name=>'COMMENTS'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49713055881526582)
,p_db_column_name=>'ALLOW_ADD_PROJECT_YN'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Allow Add Project ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49712707727526582)
,p_db_column_name=>'ALLOW_ADD_TASK_YN'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Allow Add Task ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49712240874526581)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49711927626526581)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49711504552526581)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49711111845526581)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53929480202650292)
,p_db_column_name=>'SECTOR_INSTRUCTIONS'
,p_display_order=>35
,p_column_identifier=>'Z'
,p_column_label=>'Sector Instructions'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53929397847650291)
,p_db_column_name=>'ALLOW_ADD_COST_CENTER_YN'
,p_display_order=>45
,p_column_identifier=>'AA'
,p_column_label=>'Allow Add Cost Center ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49200086443443408)
,p_db_column_name=>'COST_CENTERS_COUNT'
,p_display_order=>55
,p_column_identifier=>'AB'
,p_column_label=>'Cost Centers Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(49623259135376339)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1636608'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SECTOR_ID:COST_CENTERS_COUNT:CEILING_CH2_REQUIRED_YN:CEILING_CH2_AMOUNT:CEILING_CH3_REQUIRED_YN:CEILING_CH3_AMOUNT:SECTOR_INSTRUCTIONS:ALLOW_ADD_COST_CENTER_YN:ALLOW_ADD_PROJECT_YN:ALLOW_ADD_TASK_YN:STATUS:'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50229828870855799)
,p_name=>'P95_PLAN'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(50229900596855800)
,p_prompt=>'Proposal Plan'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'BUDGET PROPOSAL PLANS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PLAN_NAME , PLAN_ID',
'from budget_proposal_plans'))
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(50229714533855798)
,p_name=>'P95_PLAN DA'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P95_PLAN'
,p_condition_element=>'P95_PLAN'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50229143742855793)
,p_event_id=>wwv_flow_api.id(50229714533855798)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(49721141929526588)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50229050572855792)
,p_event_id=>wwv_flow_api.id(50229714533855798)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(49721141929526588)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50229546064855797)
,p_event_id=>wwv_flow_api.id(50229714533855798)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(49721141929526588)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(50228951804855791)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'set Plan Id Default'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  PLAN_ID',
'into :P95_PLAN',
'from budget_proposal_plans',
'where ROWNUM = 1;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
