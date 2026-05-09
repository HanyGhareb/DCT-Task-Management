prompt --application/pages/page_00066
begin
--   Manifest
--     PAGE: 00066
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
 p_id=>66
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Cost Centers Planners'
,p_alias=>'COST-CENTERS-PLANNERS'
,p_step_title=>'Cost Centers Planners'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230209174623'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(83773397129578598)
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
 p_id=>wwv_flow_api.id(83773975546578599)
,p_plug_name=>'Cost Center Planner'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select     id,',
'    budget_allocation_plan_id,',
'    budget_allocation_plan_id    budget_allocation_plan_id_h,',
'    sector_id,',
'    sector_id                    sector_id_h,',
'    cost_center,',
'    cost_center                    cost_center_h,',
'    nvl(approved_budget_ch1,0)    approved_budget_ch1,',
'    nvl(approved_budget_ch2,0)    approved_budget_ch2,',
'    nvl(approved_budget_ch3,0)    approved_budget_ch3,',
'    nvl(approved_budget_ch6,0)    approved_budget_ch6,',
'    status,',
'    comments,',
'    created_by,',
'    created_on,',
'    updated_by,',
'    updated_on,',
'    scenario,',
'    scenario_desc',
'from budget_allocation_cost_centers_plans',
'where cost_center in (select distinct  budget_allocation_role_users.cost_center  ',
'                        from BUDGET_ALLOCATION_ROLE_USERS',
'                        where PERSON_ID = :PERSON_ID',
'                        and status = ''A''',
'                        and sysdate between nvl(start_date , sysdate - 10)',
'                            and nvl(end_date , sysdate + 10));'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Sector Planners'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(83774130497578599)
,p_name=>'Sector Planners'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>297058162886763231
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64673735188592909)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64673341033592909)
,p_db_column_name=>'BUDGET_ALLOCATION_PLAN_ID'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Budget Allocation Plan'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(70889094180742864)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64673023867592908)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1187523989265150)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64672617367592908)
,p_db_column_name=>'APPROVED_BUDGET_CH1'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Approved Budget Ch1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64672228997592908)
,p_db_column_name=>'APPROVED_BUDGET_CH2'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Approved Budget Ch2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64671815805592908)
,p_db_column_name=>'APPROVED_BUDGET_CH3'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Approved Budget Ch3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64671401886592908)
,p_db_column_name=>'APPROVED_BUDGET_CH6'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Approved Budget Ch6'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64670996181592907)
,p_db_column_name=>'STATUS'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(780300318120911)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64670582999592907)
,p_db_column_name=>'COMMENTS'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64670184795592907)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64669795542592907)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64669383801592907)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64668984425592907)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64668545888592906)
,p_db_column_name=>'SCENARIO'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Scenario'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(70830542814082706)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64668230159592906)
,p_db_column_name=>'SCENARIO_DESC'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Scenario Desc'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64719759885333900)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>25
,p_column_identifier=>'R'
,p_column_label=>'Department / Cost Center'
,p_column_link=>'f?p=&APP_ID.:67:&SESSION.::&DEBUG.:67:P67_PLAN_ID,P67_SECTOR_ID,P67_COST_CENTER,P67_STATUS:#BUDGET_ALLOCATION_PLAN_ID_H#,#SECTOR_ID_H#,#COST_CENTER_H#,#STATUS#'
,p_column_linktext=>'#COST_CENTER#'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(71087570950221411)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64719543995333898)
,p_db_column_name=>'BUDGET_ALLOCATION_PLAN_ID_H'
,p_display_order=>35
,p_column_identifier=>'S'
,p_column_label=>'Budget Allocation Plan Id H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64719463760333897)
,p_db_column_name=>'SECTOR_ID_H'
,p_display_order=>45
,p_column_identifier=>'T'
,p_column_label=>'Sector Id H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64719343381333896)
,p_db_column_name=>'COST_CENTER_H'
,p_display_order=>55
,p_column_identifier=>'U'
,p_column_label=>'Cost Center H'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(83783730059589228)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1486162'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'COST_CENTER:BUDGET_ALLOCATION_PLAN_ID:SCENARIO:APPROVED_BUDGET_CH1:APPROVED_BUDGET_CH2:APPROVED_BUDGET_CH3:APPROVED_BUDGET_CH6:APXWS_CC_001:STATUS:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(64531404191215076)
,p_report_id=>wwv_flow_api.id(83783730059589228)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APXWS_CC_001'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ((#APXWS_CC_EXPR#) is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(64530961061215076)
,p_report_id=>wwv_flow_api.id(83783730059589228)
,p_name=>'Active'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Active'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Active''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#D0F1CC'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(64530555078215076)
,p_report_id=>wwv_flow_api.id(83783730059589228)
,p_db_column_name=>'APXWS_CC_001'
,p_column_identifier=>'C01'
,p_computation_expr=>'D + E + F + G'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Total'
,p_report_label=>'Total'
);
wwv_flow_api.component_end;
end;
/
