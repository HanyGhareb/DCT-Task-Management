prompt --application/pages/page_00058
begin
--   Manifest
--     PAGE: 00058
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
 p_id=>58
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Budget Allocation Plans'
,p_alias=>'BUDGET-ALLOCATION-PLANS'
,p_step_title=>'Budget Allocation Plans'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230424132551'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(70945630783791702)
,p_plug_name=>'Budget Allocation Plans Report'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PLAN_ID,',
'       PLAN_NAME,',
'       BUDGET_YEAR,',
'       NVL(APPROVED_BUDGET_CH1,0)   APPROVED_BUDGET_CH1,',
'       NVL(APPROVED_BUDGET_CH2,0)   APPROVED_BUDGET_CH2,',
'       NVL(APPROVED_BUDGET_CH3,0)   APPROVED_BUDGET_CH3,',
'       NVL(APPROVED_BUDGET_CH6,0)   APPROVED_BUDGET_CH6,',
'       FUTURE_CHAR,',
'       FUTURE_CHAR2,',
'       SCENARIO_DESC,',
'       SCENARIO,',
'       FUTURE_NUMBER2,',
'       FUTURE_NUMBER3,',
'       STATUS,',
'       SUBMITTED_BY,',
'       SUBMITTED_ON,',
'       FINAL_APPROVED_BY,',
'       FINAL_APPROVED_ON,',
'       CANCELLED_BY,',
'       CANCELLED_ON,',
'       CANCEL_REASON,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       APPROVED_BUDGET_CH1_YN,',
'       APPROVED_BUDGET_CH2_YN,',
'       APPROVED_BUDGET_CH3_YN,',
'       APPROVED_BUDGET_CH6_YN,',
'       FIRST_DEAD_LINE',
'  from BUDGET_ALLOCATION_PLANS',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Budget Allocation Plans Report'
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
 p_id=>wwv_flow_api.id(70945173200791703)
,p_name=>'Report 1'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No Budget Allocation Plans found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:59:&SESSION.::&DEBUG.:RP:P59_PLAN_ID:\#PLAN_ID#\'
,p_detail_link_text=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_owner=>'TCA9051'
,p_internal_uid=>142338859188392929
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70945129480791703)
,p_db_column_name=>'PLAN_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Plan Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70944722663791703)
,p_db_column_name=>'PLAN_NAME'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Plan Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70944296452791703)
,p_db_column_name=>'BUDGET_YEAR'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Budget Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70943857868791703)
,p_db_column_name=>'APPROVED_BUDGET_CH1'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Approved Budget Ch1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70943459866791704)
,p_db_column_name=>'APPROVED_BUDGET_CH2'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Approved Budget Ch2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70943053354791704)
,p_db_column_name=>'APPROVED_BUDGET_CH3'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Approved Budget Ch3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70942671981791704)
,p_db_column_name=>'APPROVED_BUDGET_CH6'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Approved Budget Ch6'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70942330201791704)
,p_db_column_name=>'STATUS'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70941855845791704)
,p_db_column_name=>'SUBMITTED_BY'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Submitted By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70941515655791704)
,p_db_column_name=>'SUBMITTED_ON'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Submitted On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70941082536791705)
,p_db_column_name=>'FINAL_APPROVED_BY'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Final Approved By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70940709208791705)
,p_db_column_name=>'FINAL_APPROVED_ON'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Final Approved On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70940284337791705)
,p_db_column_name=>'CANCELLED_BY'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Cancelled By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70939894992791705)
,p_db_column_name=>'CANCELLED_ON'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Cancelled On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70939454497791705)
,p_db_column_name=>'CANCEL_REASON'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Cancel Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(65413483884155419)
,p_db_column_name=>'SCENARIO'
,p_display_order=>25
,p_column_identifier=>'W'
,p_column_label=>'Scenario'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(70830542814082706)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70939107453791705)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>35
,p_column_identifier=>'P'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70938696413791706)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>45
,p_column_identifier=>'Q'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70938271290791706)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>55
,p_column_identifier=>'R'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70937856906791706)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>65
,p_column_identifier=>'S'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(65413816596155422)
,p_db_column_name=>'FUTURE_CHAR'
,p_display_order=>75
,p_column_identifier=>'T'
,p_column_label=>'Future Char'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(65413715472155421)
,p_db_column_name=>'FUTURE_CHAR2'
,p_display_order=>85
,p_column_identifier=>'U'
,p_column_label=>'Future Char2'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(65413540246155420)
,p_db_column_name=>'SCENARIO_DESC'
,p_display_order=>95
,p_column_identifier=>'V'
,p_column_label=>'Scenario Desc'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(65413365302155418)
,p_db_column_name=>'FUTURE_NUMBER2'
,p_display_order=>105
,p_column_identifier=>'X'
,p_column_label=>'Future Number2'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(65413250131155417)
,p_db_column_name=>'FUTURE_NUMBER3'
,p_display_order=>115
,p_column_identifier=>'Y'
,p_column_label=>'Future Number3'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(65413165536155416)
,p_db_column_name=>'APPROVED_BUDGET_CH1_YN'
,p_display_order=>125
,p_column_identifier=>'Z'
,p_column_label=>'Approved Budget Ch1 Yn'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(65413046657155415)
,p_db_column_name=>'APPROVED_BUDGET_CH2_YN'
,p_display_order=>135
,p_column_identifier=>'AA'
,p_column_label=>'Approved Budget Ch2 Yn'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(65412972199155414)
,p_db_column_name=>'APPROVED_BUDGET_CH3_YN'
,p_display_order=>145
,p_column_identifier=>'AB'
,p_column_label=>'Approved Budget Ch3 Yn'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(65412931149155413)
,p_db_column_name=>'APPROVED_BUDGET_CH6_YN'
,p_display_order=>155
,p_column_identifier=>'AC'
,p_column_label=>'Approved Budget Ch6 Yn'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62056928466305617)
,p_db_column_name=>'FIRST_DEAD_LINE'
,p_display_order=>165
,p_column_identifier=>'AD'
,p_column_label=>'Deadline'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(70922232959846936)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1423618'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PLAN_NAME:BUDGET_YEAR:SCENARIO:FIRST_DEAD_LINE:APPROVED_BUDGET_CH1:APPROVED_BUDGET_CH2:APPROVED_BUDGET_CH3:APPROVED_BUDGET_CH6:APXWS_CC_001:STATUS:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(61664018942987463)
,p_report_id=>wwv_flow_api.id(70922232959846936)
,p_name=>'Draft'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Draft'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Draft''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#E8E8E8'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(61663626759987463)
,p_report_id=>wwv_flow_api.id(70922232959846936)
,p_name=>'In Process'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'In Process'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''In Process''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(61663162533987463)
,p_report_id=>wwv_flow_api.id(70922232959846936)
,p_db_column_name=>'APXWS_CC_001'
,p_column_identifier=>'C01'
,p_computation_expr=>'E  + F  +  D +  G'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Total Approved Budget'
,p_report_label=>'Total Approved Budget'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(70936541480791707)
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
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(70935405430791708)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(70936541480791707)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'New Allocation Plan'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:59:&SESSION.::&DEBUG.:59'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.component_end;
end;
/
