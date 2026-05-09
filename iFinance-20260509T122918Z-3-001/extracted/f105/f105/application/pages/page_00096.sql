prompt --application/pages/page_00096
begin
--   Manifest
--     PAGE: 00096
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
 p_id=>96
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Cost Center Planner'
,p_alias=>'COST-CENTER-PLANNER'
,p_step_title=>'Cost Center Planner'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230724081500'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(50230508925855806)
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
 p_id=>wwv_flow_api.id(49706276592512178)
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
 p_id=>wwv_flow_api.id(49705647611512175)
,p_plug_name=>'Cost Center Plans'
,p_icon_css_classes=>'fa-align-center'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select pc.ID,',
'       pc.PLAN_ID,',
'       pc.PLAN_ID    PLAN_ID_H,',
'       pc.SECTOR_ID,',
'       pc.SECTOR_ID    sector_id_H,',
'       pc.COST_CENTER,',
'       user_details.get_cost_center_name(pc.COST_CENTER) cost_center_name,',
'       pc.CEILING_CH1_REQUIRED_YN,',
'       pc.CEILING_CH1_AMOUNT,',
'       pc.CEILING_CH2_REQUIRED_YN,',
'       pc.CEILING_CH2_AMOUNT,',
'       nvl(PC.CEILING_CH2_ADDITIONAL,0) CEILING_CH2_ADDITIONAL,',
'       budget_proposal_pkg.cc_chapter_allocated(pc.PLAN_ID, pc.COST_CENTER, 134) CH2_Allocated,',
'       pc.CEILING_CH3_REQUIRED_YN,',
'       nvl(pc.CEILING_CH3_ADDITIONAL,0) CEILING_CH3_ADDITIONAL,',
'       pc.CEILING_CH3_AMOUNT,',
'       budget_proposal_pkg.cc_chapter_allocated(pc.PLAN_ID, pc.COST_CENTER, 135) CH3_Allocated,',
'       pc.CEILING_CH6_REQUIRED_YN,',
'       pc.CEILING_CH6_AMOUNT,',
'       pc.STATUS,',
'       pc.COST_CENTER_INSTRUCTIONS,',
'       pc.COMMENTS,',
'       pc.SUBMITTED_BY,',
'       pc.SUBMITTED_ON,',
'       pc.RECEIVED_ON,',
'       pc.RECEIVED_BY,',
'       pc.ALLOW_ADD_PROJECT_YN,',
'       pc.ALLOW_ADD_TASK_YN,',
'       pc.CREATED_BY,',
'       pc.CREATED_ON,',
'       pc.UPDATED_BY,',
'       pc.UPDATED_ON,',
'       pc.INITIAL_OPEX_CEILING,',
'       pc.INITIAL_CAPEX_CEILING,',
'       (select count (distinct p.project_number)',
'        from budget_proposal_projects_plans p',
'        where p.plan_id = pc.plan_id',
'        and p.sector_id = pc.sector_id',
'        and p.cost_center = pc.cost_center) projects_count,',
'      (select count (*)',
'        from budget_proposal_projects_plans p',
'        where p.plan_id = pc.plan_id',
'        and p.sector_id = pc.sector_id',
'        and p.cost_center = pc.cost_center) line_count  ',
'  from BUDGET_PROPOSAL_COST_CENTERS_PLANS pc',
'  where pc.plan_id = :P96_PLAN',
'  and pc.COST_CENTER in (select COST_CENTER',
'from BUDGET_ALLOCATION_ROLE_USERS',
'where role_id = 114        -- Cost center planner 114',
'and status = ''A''',
'and sysdate between nvl(start_date , sysdate - 10) and nvl(end_date, sysdate + 10)',
'and person_id = :PERSON_ID)',
'  order by pc.cost_center'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P96_PLAN'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Cost Center Plans'
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
 p_id=>wwv_flow_api.id(49705590472512175)
,p_name=>'Cost Center Planner'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>163578441916672457
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49705179083512173)
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
 p_id=>wwv_flow_api.id(49704756752512173)
,p_db_column_name=>'PLAN_ID'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Plan Name'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(49565096744743668)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49704379686512172)
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
 p_id=>wwv_flow_api.id(49703988960512172)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Cost Center'
,p_column_link=>'f?p=&APP_ID.:97:&SESSION.::&DEBUG.::P97_PLAN_ID,P97_COST_CENTER,P97_PAGE_FROM,P97_SECTOR_ID,P97_ID,P97_CC_PLAN_ID:#PLAN_ID_H#,#COST_CENTER#,96,#SECTOR_ID_H#,#ID#,\#ID#\'
,p_column_linktext=>'#COST_CENTER#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50229982826855801)
,p_db_column_name=>'COST_CENTER_NAME'
,p_display_order=>14
,p_column_identifier=>'Z'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49703567248512172)
,p_db_column_name=>'CEILING_CH1_REQUIRED_YN'
,p_display_order=>24
,p_column_identifier=>'E'
,p_column_label=>'Ceiling Ch1 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P96_PLAN) = ''M'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49703226495512172)
,p_db_column_name=>'CEILING_CH1_AMOUNT'
,p_display_order=>34
,p_column_identifier=>'F'
,p_column_label=>'Ceiling Ch1 Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P96_PLAN) = ''M'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49702825113512171)
,p_db_column_name=>'CEILING_CH2_REQUIRED_YN'
,p_display_order=>44
,p_column_identifier=>'G'
,p_column_label=>'Ceiling Ch2 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P96_PLAN) = ''E'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49702365548512171)
,p_db_column_name=>'CEILING_CH2_AMOUNT'
,p_display_order=>54
,p_column_identifier=>'H'
,p_column_label=>'Opex Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P96_PLAN) = ''E'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49702027175512171)
,p_db_column_name=>'CEILING_CH3_REQUIRED_YN'
,p_display_order=>64
,p_column_identifier=>'I'
,p_column_label=>'Ceiling Ch3 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P96_PLAN) = ''E'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49701617107512171)
,p_db_column_name=>'CEILING_CH3_AMOUNT'
,p_display_order=>74
,p_column_identifier=>'J'
,p_column_label=>'Capex Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P96_PLAN) = ''E'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49701178201512171)
,p_db_column_name=>'CEILING_CH6_REQUIRED_YN'
,p_display_order=>84
,p_column_identifier=>'K'
,p_column_label=>'Ceiling Ch6 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P96_PLAN) = ''C'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49700752801512171)
,p_db_column_name=>'CEILING_CH6_AMOUNT'
,p_display_order=>94
,p_column_identifier=>'L'
,p_column_label=>'Ceiling Ch6 Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P96_PLAN) = ''C'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49700425158512170)
,p_db_column_name=>'STATUS'
,p_display_order=>104
,p_column_identifier=>'M'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49699985564512170)
,p_db_column_name=>'COST_CENTER_INSTRUCTIONS'
,p_display_order=>114
,p_column_identifier=>'N'
,p_column_label=>'Cost Center Instructions'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49699569269512170)
,p_db_column_name=>'COMMENTS'
,p_display_order=>124
,p_column_identifier=>'O'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49699191889512170)
,p_db_column_name=>'SUBMITTED_BY'
,p_display_order=>134
,p_column_identifier=>'P'
,p_column_label=>'Submitted By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49698770430512170)
,p_db_column_name=>'SUBMITTED_ON'
,p_display_order=>144
,p_column_identifier=>'Q'
,p_column_label=>'Submitted On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49698405696512169)
,p_db_column_name=>'RECEIVED_ON'
,p_display_order=>154
,p_column_identifier=>'R'
,p_column_label=>'Received On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49698007136512169)
,p_db_column_name=>'RECEIVED_BY'
,p_display_order=>164
,p_column_identifier=>'S'
,p_column_label=>'Received By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49697619021512169)
,p_db_column_name=>'ALLOW_ADD_PROJECT_YN'
,p_display_order=>174
,p_column_identifier=>'T'
,p_column_label=>'Allow Add Project ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49697230558512169)
,p_db_column_name=>'ALLOW_ADD_TASK_YN'
,p_display_order=>184
,p_column_identifier=>'U'
,p_column_label=>'Allow Add Task ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49696805590512169)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>194
,p_column_identifier=>'V'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49696383629512168)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>204
,p_column_identifier=>'W'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49696018384512168)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>214
,p_column_identifier=>'X'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49695623114512168)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>224
,p_column_identifier=>'Y'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49199933571443407)
,p_db_column_name=>'PROJECTS_COUNT'
,p_display_order=>234
,p_column_identifier=>'AA'
,p_column_label=>'Projects Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49199836433443406)
,p_db_column_name=>'LINE_COUNT'
,p_display_order=>244
,p_column_identifier=>'AB'
,p_column_label=>'Line Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47701934453036930)
,p_db_column_name=>'PLAN_ID_H'
,p_display_order=>254
,p_column_identifier=>'AC'
,p_column_label=>'Plan Id H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47452861421466519)
,p_db_column_name=>'SECTOR_ID_H'
,p_display_order=>264
,p_column_identifier=>'AD'
,p_column_label=>'Sector Id H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47358397625656787)
,p_db_column_name=>'CH2_ALLOCATED'
,p_display_order=>274
,p_column_identifier=>'AE'
,p_column_label=>'Opex Allocated'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47358298285656786)
,p_db_column_name=>'CH3_ALLOCATED'
,p_display_order=>284
,p_column_identifier=>'AF'
,p_column_label=>'Capex Allocated'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41552640019522330)
,p_db_column_name=>'CEILING_CH2_ADDITIONAL'
,p_display_order=>294
,p_column_identifier=>'AG'
,p_column_label=>'Additional Opex Ceiling '
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41552603112522329)
,p_db_column_name=>'CEILING_CH3_ADDITIONAL'
,p_display_order=>304
,p_column_identifier=>'AH'
,p_column_label=>'Additional Capex Ceiling '
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38459839965266499)
,p_db_column_name=>'INITIAL_OPEX_CEILING'
,p_display_order=>314
,p_column_identifier=>'AI'
,p_column_label=>'Initial Opex Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38459774640266498)
,p_db_column_name=>'INITIAL_CAPEX_CEILING'
,p_display_order=>324
,p_column_identifier=>'AJ'
,p_column_label=>'Initial Capex Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(49566605643755913)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1637175'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'COST_CENTER:COST_CENTER_NAME:INITIAL_OPEX_CEILING:CEILING_CH2_AMOUNT:CEILING_CH2_ADDITIONAL:CH2_ALLOCATED:INITIAL_CAPEX_CEILING:CEILING_CH3_AMOUNT:CEILING_CH3_ADDITIONAL:CH3_ALLOCATED:COST_CENTER_INSTRUCTIONS:COMMENTS:PROJECTS_COUNT:LINE_COUNT:STATUS'
||':'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(38221731358805086)
,p_report_id=>wwv_flow_api.id(49566605643755913)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(38221324689805086)
,p_report_id=>wwv_flow_api.id(49566605643755913)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Available'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Available''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(38220907994805086)
,p_report_id=>wwv_flow_api.id(49566605643755913)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(46208433488316286)
,p_plug_name=>'All - Cost Center Plans'
,p_icon_css_classes=>'fa-align-center'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select pc.ID,',
'       pc.PLAN_ID,',
'       pc.PLAN_ID    PLAN_ID_H,',
'       pc.SECTOR_ID,',
'       pc.SECTOR_ID    sector_id_H,',
'       pc.COST_CENTER,',
'       nvl(dct_cost_center, user_details.get_cost_center_name(pc.COST_CENTER)) cost_center_name,',
'       pc.CEILING_CH1_REQUIRED_YN,',
'       pc.CEILING_CH1_AMOUNT,',
'       pc.INITIAL_OPEX_CEILING,',
'       pc.INITIAL_CAPEX_CEILING ,',
'       nvl(PC.CEILING_CH2_ADDITIONAL,0) CEILING_CH2_ADDITIONAL,',
'       pc.CEILING_CH2_REQUIRED_YN,',
'       pc.CEILING_CH2_AMOUNT,',
'       budget_proposal_pkg.cc_chapter_allocated(pc.PLAN_ID, pc.COST_CENTER, 134) CH2_Allocated,',
'       pc.CEILING_CH3_REQUIRED_YN,',
'       pc.CEILING_CH3_AMOUNT,',
'       nvl(PC.CEILING_CH3_ADDITIONAL,0) CEILING_CH3_ADDITIONAL,',
'       budget_proposal_pkg.cc_chapter_allocated(pc.PLAN_ID, pc.COST_CENTER, 135) CH3_Allocated,',
'       pc.CEILING_CH6_REQUIRED_YN,',
'       pc.CEILING_CH6_AMOUNT,',
'  -- Revise Budget',
'    BUDGET_PROPOSAL_PKG.CC_BUDGET_REVISED_FBP(pc.id , 134)  CH2_REVISE_FBP,',
'    BUDGET_PROPOSAL_PKG.CC_BUDGET_REVISED_FBP(pc.id , 135)  CH3_REVISE_FBP,',
'    BUDGET_PROPOSAL_PKG.CC_BUDGET_REVISED_FPR(pc.id , 134)  CH2_REVISE_FPR,',
'    BUDGET_PROPOSAL_PKG.CC_BUDGET_REVISED_FPR(pc.id , 135)  CH3_REVISE_FPR,',
'    FBP_REVISE_STATUS,',
'    FPR_REVISE_STATUS,',
' --   ',
'       pc.STATUS,',
'       pc.COST_CENTER_INSTRUCTIONS,',
'       pc.COMMENTS,',
'       pc.SUBMITTED_BY,',
'       pc.SUBMITTED_ON,',
'       pc.RECEIVED_ON,',
'       pc.RECEIVED_BY,',
'       pc.ALLOW_ADD_PROJECT_YN,',
'       pc.ALLOW_ADD_TASK_YN,',
'       pc.CREATED_BY,',
'       pc.CREATED_ON,',
'       pc.UPDATED_BY,',
'       pc.UPDATED_ON,',
'       (select count (distinct p.project_number)',
'        from budget_proposal_projects_plans p',
'        where p.plan_id = pc.plan_id',
'        and p.sector_id = pc.sector_id',
'        and p.cost_center = pc.cost_center) projects_count,',
'      (select count (*)',
'        from budget_proposal_projects_plans p',
'        where p.plan_id = pc.plan_id',
'        and p.sector_id = pc.sector_id',
'        and p.cost_center = pc.cost_center) line_count ,',
'       case when pc.CEILING_CH2_AMOUNT <  budget_proposal_pkg.cc_chapter_allocated(pc.PLAN_ID, pc.COST_CENTER, 134)',
'                Then  ''red''',
'            when pc.CEILING_CH2_AMOUNT =  budget_proposal_pkg.cc_chapter_allocated(pc.PLAN_ID, pc.COST_CENTER, 134)',
'                Then  ''green''    ',
'        end as "STATUS_COLOR"',
'  from BUDGET_PROPOSAL_COST_CENTERS_PLANS pc',
'  where pc.plan_id = :P96_PLAN',
'  order by pc.cost_center'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P96_PLAN'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_SECTOR_PLANNER_YN = ''Y''',
'or :IS_IFINANCE_ADMIN = ''Y''',
'or :IS_BUDGET_PLANNING_YN = ''Y''',
'or :IS_SPMO_YN = ''Y''',
'or :IS_FBP_EMP = ''Y'''))
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'All - Cost Center Plans'
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
 p_id=>wwv_flow_api.id(46208418373316285)
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>167075614015868347
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46208283419316284)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46208222430316283)
,p_db_column_name=>'PROJECTS_COUNT'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Projects Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46208089163316282)
,p_db_column_name=>'LINE_COUNT'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Line Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45327971439072031)
,p_db_column_name=>'PLAN_ID_H'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Plan Id H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45327845647072030)
,p_db_column_name=>'SECTOR_ID_H'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Sector Id H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45327748608072029)
,p_db_column_name=>'CH2_ALLOCATED'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Opex Allocated'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45327686417072028)
,p_db_column_name=>'CH3_ALLOCATED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Capex Allocated'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45327628717072027)
,p_db_column_name=>'PLAN_ID'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Plan Name'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(49565096744743668)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45327501240072026)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1216232005294941)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45327349958072025)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Cost Center'
,p_column_link=>'f?p=&APP_ID.:97:&SESSION.::&DEBUG.::P97_PLAN_ID,P97_COST_CENTER,P97_PAGE_FROM,P97_SECTOR_ID,P97_ID,P97_CC_PLAN_ID:#PLAN_ID_H#,#COST_CENTER#,96,#SECTOR_ID_H#,#ID#,\#ID#\'
,p_column_linktext=>'#COST_CENTER#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45327302810072024)
,p_db_column_name=>'CEILING_CH1_REQUIRED_YN'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Ceiling Ch1 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P96_PLAN) = ''M'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45327228155072023)
,p_db_column_name=>'CEILING_CH1_AMOUNT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Ceiling Ch1 Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P96_PLAN) = ''M'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45327072402072022)
,p_db_column_name=>'CEILING_CH2_REQUIRED_YN'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Ceiling Ch2 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P96_PLAN) = ''E'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45326971454072021)
,p_db_column_name=>'CEILING_CH2_AMOUNT'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Current Opex Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P96_PLAN) = ''E'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45326918408072020)
,p_db_column_name=>'CEILING_CH3_REQUIRED_YN'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Ceiling Ch3 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P96_PLAN) = ''E'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45326812817072019)
,p_db_column_name=>'CEILING_CH3_AMOUNT'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Current Capex Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P96_PLAN) = ''E'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45326725472072018)
,p_db_column_name=>'CEILING_CH6_REQUIRED_YN'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Ceiling Ch6 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P96_PLAN) = ''C'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45326561382072017)
,p_db_column_name=>'CEILING_CH6_AMOUNT'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Ceiling Ch6 Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P96_PLAN) = ''C'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45326492892072016)
,p_db_column_name=>'STATUS'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45326400203072015)
,p_db_column_name=>'COST_CENTER_INSTRUCTIONS'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Cost Center Instructions'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45326242568072014)
,p_db_column_name=>'COMMENTS'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45326215493072013)
,p_db_column_name=>'SUBMITTED_BY'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Submitted By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45326061728072012)
,p_db_column_name=>'SUBMITTED_ON'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Submitted On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45325982919072011)
,p_db_column_name=>'RECEIVED_ON'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Received On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45325848258072010)
,p_db_column_name=>'RECEIVED_BY'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Received By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45325813231072009)
,p_db_column_name=>'ALLOW_ADD_PROJECT_YN'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Allow Add Project ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45325661893072008)
,p_db_column_name=>'ALLOW_ADD_TASK_YN'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Allow Add Task ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45325540354072007)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45325468601072006)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45325422195072005)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45325260093072004)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45325181007072003)
,p_db_column_name=>'COST_CENTER_NAME'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(44489473118903305)
,p_db_column_name=>'STATUS_COLOR'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Status Color'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41552514839522328)
,p_db_column_name=>'CEILING_CH2_ADDITIONAL'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Additional Opex Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41552391578522327)
,p_db_column_name=>'CEILING_CH3_ADDITIONAL'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Additional Capex Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38460104767266501)
,p_db_column_name=>'INITIAL_OPEX_CEILING'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Initial Opex Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38459977728266500)
,p_db_column_name=>'INITIAL_CAPEX_CEILING'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Initial Capex Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30830153083351084)
,p_db_column_name=>'CH2_REVISE_FBP'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Opex Revise - FBP'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30830037551351083)
,p_db_column_name=>'CH3_REVISE_FBP'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Capex Revise - FBP'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30829941874351082)
,p_db_column_name=>'CH2_REVISE_FPR'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Opex Revise - Budget Planning'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30537156573105731)
,p_db_column_name=>'CH3_REVISE_FPR'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Capex Revise - Budget Planning'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30537083723105730)
,p_db_column_name=>'FBP_REVISE_STATUS'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'Revise Status - FBP'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30537008386105729)
,p_db_column_name=>'FPR_REVISE_STATUS'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Revise Status - Budget Planning'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(45312414756060203)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1679717'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>100
,p_report_columns=>'SECTOR_ID:COST_CENTER:COST_CENTER_NAME:INITIAL_OPEX_CEILING:CEILING_CH2_AMOUNT:CEILING_CH2_ADDITIONAL:APXWS_CC_001:CH2_ALLOCATED:INITIAL_CAPEX_CEILING:CEILING_CH3_AMOUNT:CEILING_CH3_ADDITIONAL:APXWS_CC_002:CH3_ALLOCATED:CH2_REVISE_FBP:CH3_REVISE_FBP:'
||'CH2_REVISE_FPR:CH3_REVISE_FPR:STATUS::FBP_REVISE_STATUS:FPR_REVISE_STATUS'
,p_sum_columns_on_break=>'CEILING_CH2_AMOUNT:CH2_ALLOCATED:CEILING_CH3_AMOUNT:CH3_ALLOCATED:CEILING_CH3_ADDITIONAL:CEILING_CH2_ADDITIONAL:APXWS_CC_001:APXWS_CC_002:CH2_REVISE_FBP:CH3_REVISE_FBP:CH2_REVISE_FPR:CH3_REVISE_FPR'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(30514360774885375)
,p_report_id=>wwv_flow_api.id(45312414756060203)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(30513961285885374)
,p_report_id=>wwv_flow_api.id(45312414756060203)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F44336'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(30513535802885374)
,p_report_id=>wwv_flow_api.id(45312414756060203)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Return'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Return''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#ED76B0'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(30513195513885373)
,p_report_id=>wwv_flow_api.id(45312414756060203)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Withdraw'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Withdraw''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#CCE5FF'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(30512792470885372)
,p_report_id=>wwv_flow_api.id(45312414756060203)
,p_db_column_name=>'APXWS_CC_001'
,p_column_identifier=>'C01'
,p_computation_expr=>'N + AH'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Total Opex Ceiling'
,p_report_label=>'Total Opex Ceiling'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(30512360943885372)
,p_report_id=>wwv_flow_api.id(45312414756060203)
,p_db_column_name=>'APXWS_CC_002'
,p_column_identifier=>'C02'
,p_computation_expr=>'P + AI'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Total Capex Ceiling'
,p_report_label=>'Total Capex Ceiling'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(38459433980266495)
,p_plug_name=>'AFH Plan'
,p_icon_css_classes=>'fa-align-center'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select pc.ID,',
'       pc.PLAN_ID,',
'       pc.PLAN_ID    PLAN_ID_H,',
'       pc.SECTOR_ID,',
'       pc.SECTOR_ID    sector_id_H,',
'       pc.COST_CENTER,',
'       nvl(dct_cost_center ,user_details.get_cost_center_name(pc.COST_CENTER)) cost_center_name,',
'       pc.CEILING_CH1_REQUIRED_YN,',
'       pc.CEILING_CH1_AMOUNT,',
'       pc.CEILING_CH2_REQUIRED_YN,',
'       pc.CEILING_CH2_AMOUNT,',
'       nvl(PC.CEILING_CH2_ADDITIONAL,0) CEILING_CH2_ADDITIONAL,',
'       budget_proposal_pkg.cc_chapter_allocated(pc.PLAN_ID, pc.COST_CENTER, 134) CH2_Allocated,',
'       pc.CEILING_CH3_REQUIRED_YN,',
'       nvl(pc.CEILING_CH3_ADDITIONAL,0) CEILING_CH3_ADDITIONAL,',
'       pc.CEILING_CH3_AMOUNT,',
'       budget_proposal_pkg.cc_chapter_allocated(pc.PLAN_ID, pc.COST_CENTER, 135) CH3_Allocated,',
'       pc.CEILING_CH6_REQUIRED_YN,',
'       pc.CEILING_CH6_AMOUNT,',
'       pc.STATUS,',
'       pc.COST_CENTER_INSTRUCTIONS,',
'       pc.COMMENTS,',
'       pc.SUBMITTED_BY,',
'       pc.SUBMITTED_ON,',
'       pc.RECEIVED_ON,',
'       pc.RECEIVED_BY,',
'       pc.ALLOW_ADD_PROJECT_YN,',
'       pc.ALLOW_ADD_TASK_YN,',
'       pc.CREATED_BY,',
'       pc.CREATED_ON,',
'       pc.UPDATED_BY,',
'       pc.UPDATED_ON,',
'       pc.INITIAL_OPEX_CEILING,',
'       pc.INITIAL_CAPEX_CEILING,',
'       (select count (distinct p.project_number)',
'        from budget_proposal_projects_plans p',
'        where p.plan_id = pc.plan_id',
'        and p.sector_id = pc.sector_id',
'        and p.cost_center = pc.cost_center',
'        and p.cc_plan_id = 365) projects_count,',
'      (select count (*)',
'        from budget_proposal_projects_plans p',
'        where p.plan_id = pc.plan_id',
'        and p.sector_id = pc.sector_id',
'        and p.cost_center = pc.cost_center',
'        and p.cc_plan_id = 365) line_count  ',
'  from BUDGET_PROPOSAL_COST_CENTERS_PLANS pc',
'  where pc.plan_id = :P96_PLAN',
'  and pc.id = 365'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P96_PLAN'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':PERSON_ID in (1611494,653552,747343,128067,282809) or ',
':IS_BUDGET_PLANNING_YN = ''Y'' or',
'--:IS_COST_CENTER_PLANNER_YN = ''Y'' OR',
':IS_FBP_EMP = ''Y'' OR',
'--:IS_FBP_YN = ''Y'' OR',
':IS_IFINANCE_ADMIN = ''Y'''))
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'AFH Plan'
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
 p_id=>wwv_flow_api.id(38459424799266494)
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>174824607589918138
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38459245475266493)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38459158867266492)
,p_db_column_name=>'PROJECTS_COUNT'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Projects Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38459060536266491)
,p_db_column_name=>'LINE_COUNT'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Line Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38458934607266490)
,p_db_column_name=>'PLAN_ID_H'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Plan Id H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38458894585266489)
,p_db_column_name=>'SECTOR_ID_H'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Sector Id H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38458831396266488)
,p_db_column_name=>'CH2_ALLOCATED'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Opex Allocated'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38458720148266487)
,p_db_column_name=>'CH3_ALLOCATED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Capex Allocated'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38458549625266486)
,p_db_column_name=>'CEILING_CH2_ADDITIONAL'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Additional Opex Ceiling '
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38458437016266485)
,p_db_column_name=>'CEILING_CH3_ADDITIONAL'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Additional Capex Ceiling '
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38458363008266484)
,p_db_column_name=>'INITIAL_OPEX_CEILING'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Initial Opex Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38458238498266483)
,p_db_column_name=>'INITIAL_CAPEX_CEILING'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Initial Capex Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38458153816266482)
,p_db_column_name=>'PLAN_ID'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Plan Name'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(49565096744743668)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38092881679487431)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1216232005294941)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38092826287487430)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Cost Center'
,p_column_link=>'f?p=&APP_ID.:97:&SESSION.::&DEBUG.::P97_PLAN_ID,P97_COST_CENTER,P97_PAGE_FROM,P97_SECTOR_ID,P97_ID,P97_CC_PLAN_ID:#PLAN_ID_H#,#COST_CENTER#,96,#SECTOR_ID_H#,#ID#,\#ID#\'
,p_column_linktext=>'#COST_CENTER#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38092678477487429)
,p_db_column_name=>'CEILING_CH1_REQUIRED_YN'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Ceiling Ch1 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P96_PLAN) = ''M'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38092607536487428)
,p_db_column_name=>'CEILING_CH1_AMOUNT'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Ceiling Ch1 Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P96_PLAN) = ''M'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38092483388487427)
,p_db_column_name=>'CEILING_CH2_REQUIRED_YN'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Ceiling Ch2 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P96_PLAN) = ''E'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38092415277487426)
,p_db_column_name=>'CEILING_CH2_AMOUNT'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Opex Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P96_PLAN) = ''E'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38092297711487425)
,p_db_column_name=>'CEILING_CH3_REQUIRED_YN'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Ceiling Ch3 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P96_PLAN) = ''E'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38092182638487424)
,p_db_column_name=>'CEILING_CH3_AMOUNT'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Capex Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P96_PLAN) = ''E'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38092057195487423)
,p_db_column_name=>'CEILING_CH6_REQUIRED_YN'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Ceiling Ch6 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P96_PLAN) = ''C'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38091995033487422)
,p_db_column_name=>'CEILING_CH6_AMOUNT'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Ceiling Ch6 Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P96_PLAN) = ''C'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38091925889487421)
,p_db_column_name=>'STATUS'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38091758710487420)
,p_db_column_name=>'COST_CENTER_INSTRUCTIONS'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Cost Center Instructions'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38091712182487419)
,p_db_column_name=>'COMMENTS'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38091607760487418)
,p_db_column_name=>'SUBMITTED_BY'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Submitted By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38091468073487417)
,p_db_column_name=>'SUBMITTED_ON'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Submitted On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38091413022487416)
,p_db_column_name=>'RECEIVED_ON'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Received On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38091237554487415)
,p_db_column_name=>'RECEIVED_BY'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Received By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38091221499487414)
,p_db_column_name=>'ALLOW_ADD_PROJECT_YN'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Allow Add Project ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38091065255487413)
,p_db_column_name=>'ALLOW_ADD_TASK_YN'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Allow Add Task ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38090955892487412)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38090896350487411)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38090757223487410)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38090648334487409)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38090611782487408)
,p_db_column_name=>'COST_CENTER_NAME'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(38076207060381082)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1752079'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SECTOR_ID:COST_CENTER:COST_CENTER_NAME:INITIAL_OPEX_CEILING:CEILING_CH2_AMOUNT:CEILING_CH2_ADDITIONAL:CH2_ALLOCATED:INITIAL_CAPEX_CEILING:CEILING_CH3_AMOUNT:CEILING_CH3_ADDITIONAL:CH3_ALLOCATED:PROJECTS_COUNT:LINE_COUNT:STATUS:'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50230418354855805)
,p_name=>'P96_PLAN'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(50230508925855806)
,p_prompt=>'Proposal Plan'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'BUDGET PROPOSAL PLANS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PLAN_NAME , PLAN_ID',
'from budget_proposal_plans'))
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(50230320412855804)
,p_name=>'P96_PLAN DA'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P96_PLAN'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50230205305855803)
,p_event_id=>wwv_flow_api.id(50230320412855804)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(49705647611512175)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(50228893590855790)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Set Default Plan ID'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  PLAN_ID',
'into :P96_PLAN',
'from budget_proposal_plans',
'where ROWNUM = 1;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
