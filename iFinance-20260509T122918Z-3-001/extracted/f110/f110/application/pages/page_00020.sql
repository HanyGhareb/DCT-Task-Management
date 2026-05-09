prompt --application/pages/page_00020
begin
--   Manifest
--     PAGE: 00020
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
 p_id=>20
,p_user_interface_id=>wwv_flow_api.id(13327188105480887)
,p_name=>'Approved Budget'
,p_alias=>'APPROVED-BUDGET'
,p_step_title=>'Approved Budget'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_api.id(18536481291491103)
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20221101205908'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(18417153290212856)
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(18417730835212857)
,p_plug_name=>'Approved Budget'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(13240610854480803)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select SCENARIO_YEAR, CH2, CH3, NEW_SCENARIO , round(CH2,1) ch2_h , round(CH3,1) ch3_h',
'from (',
'select distinct SCENARIO_YEAR ,  (select DISTINCT XX from (select sum(budget_2021) OVER (PARTITION BY scenario_year  ) xx ',
'                            from proposed_budget',
'                            where chapter = 2)) ch2',
'                            ,  (select DISTINCT XX from (select sum(budget_2021) OVER (PARTITION BY scenario_year  ) xx ',
'                            from proposed_budget',
'                            where chapter = 3)) ch3',
'                      , ''<span aria-hidden="true" class="fa fa-copy fa-2x"></span>'' New_scenario    ',
'from proposed_budget',
')',
'/*',
'',
'select SCENARIO_YEAR , chapter , sum(BUDGET_2020) BUDGET_2020, sum(BUDGET_2021) BUDGET_2021, sum(BUDGET_2021) BUDGET_2021_H ,sum(BUDGET_2022) BUDGET_2022 , sum(BUDGET_2023) BUDGET_2023, ',
'    sum(JAN_21) JAN_21, sum(FEB_21) FEB_21, sum(MAR_21) MAR_21, sum(APR_21) APR_21, sum(MAY_21) MAY_21, ',
'    sum(JUN_21) JUN_21, sum(JUL_21) JUL_21, ',
'    sum(AUG_21) AUG_21, sum(SEP_21) SEP_21, sum(OCT_21) OCT_21, ',
'    sum(NOV_21) NOV_21, sum(DEC_21) DEC_21, sum(TOTAL) TOTAL',
'    , ''<span aria-hidden="true" class="fa fa-copy fa-2x"></span>'' New_scenario',
'-- , ''<span aria-hidden="true" class="fa fa-copy fa-2x"></span>'' New_version',
'from proposed_budget ',
'where status = ''Approved''',
'GROUP by SCENARIO_YEAR , chapter',
'',
'/*',
'select budget_year , BUDGET_VERSION ,status , start_date , end_date , proposed_scenario , approved_amount_ch2, approved_amount_ch3',
',(select round(sum(nvl(BUDGET_2021,0)),1)',
'from proposed_budget',
'where CHAPTER  =2) pro_ch2',
',(select round(sum(nvl(BUDGET_2021,0)),1)',
'from proposed_budget',
'where CHAPTER  = 3) pro_ch3',
', ''<span aria-hidden="true" class="fa fa-copy fa-2x"></span>'' New_scenario',
', ''<span aria-hidden="true" class="fa fa-copy fa-2x"></span>'' New_version',
'from approved_budget_summary',
'-- GROUP BY budget_year , BUDGET_VERSION ,status, start_date , end_date , proposed_scenario ',
'',
'*/'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Approved Budget'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(18417847560212857)
,p_name=>'Approved Budget'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>18417847560212857
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(134343083444125406)
,p_db_column_name=>'SCENARIO_YEAR'
,p_display_order=>10
,p_column_identifier=>'X'
,p_column_label=>'Budget Year'
,p_column_link=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.::P9_YEAR:#SCENARIO_YEAR#'
,p_column_linktext=>'#SCENARIO_YEAR#'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(134345746307125433)
,p_db_column_name=>'CH2'
,p_display_order=>210
,p_column_identifier=>'AS'
,p_column_label=>'Proposal Chapter 2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(134345856502125434)
,p_db_column_name=>'CH3'
,p_display_order=>220
,p_column_identifier=>'AT'
,p_column_label=>'Proposal  Chapter 3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(134346087710125436)
,p_db_column_name=>'NEW_SCENARIO'
,p_display_order=>230
,p_column_identifier=>'AU'
,p_column_label=>'New Scenario'
,p_column_link=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:6:P6_BUDGET_YEAR,P6_CH2,P6_CH3:#SCENARIO_YEAR#,#CH2_H#,#CH3_H#'
,p_column_linktext=>'#NEW_SCENARIO#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(134346171079125437)
,p_db_column_name=>'CH2_H'
,p_display_order=>240
,p_column_identifier=>'AV'
,p_column_label=>'Ch2 H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(134346252103125438)
,p_db_column_name=>'CH3_H'
,p_display_order=>250
,p_column_identifier=>'AW'
,p_column_label=>'Ch3 H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(18423451696216011)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'184235'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>':SCENARIO_YEAR:CH2:CH3:NEW_SCENARIO:CH2_H:CH3_H'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(18308029898742144)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(18417730835212857)
,p_button_name=>'Add'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(13304710257480854)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add'
,p_button_position=>'TOP'
,p_button_redirect_url=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.:21::'
,p_icon_css_classes=>'fa-clipboard-plus'
);
wwv_flow_api.component_end;
end;
/
