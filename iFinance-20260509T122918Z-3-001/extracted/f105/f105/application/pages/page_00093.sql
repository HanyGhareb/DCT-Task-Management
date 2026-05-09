prompt --application/pages/page_00093
begin
--   Manifest
--     PAGE: 00093
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
 p_id=>93
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Budget Proposal Plan Scope'
,p_alias=>'BUDGET-PROPOSAL-PLAN-SCOPE'
,p_step_title=>'Budget Proposal Plan Scope'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230430190452'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(50594008206653286)
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
 p_id=>wwv_flow_api.id(50593336520653285)
,p_plug_name=>'Plan Criteria'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(50593009510653285)
,p_plug_name=>'Sectors'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(50729853924315199)
,p_plug_name=>'Sectors Report'
,p_parent_plug_id=>wwv_flow_api.id(50593009510653285)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    s.sector_id,',
'    s.sector_instructions,',
'    s.comments,',
'    s.status,',
'    s.allow_add_cost_center_yn,',
'    s.allow_add_project_yn,',
'    s.allow_add_task_yn,',
'    s.ceiling_ch1_required_yn,',
'    s.ceiling_ch1_amount,',
'    s.ceiling_ch2_required_yn,',
'    s.ceiling_ch2_amount,',
'    s.ceiling_ch3_required_yn,',
'    s.ceiling_ch3_amount',
'    ',
'--   ,(select count(distinct COST_CENTER_CODE)',
'--      from  GL_CODE_COMBINATIONS_V ',
'--      where SECTOR_ID = s.sector_id',
'--      and status = ''A''',
'--      and sysdate between nvl(start_date , sysdate - 10)',
'--            and nvl(end_date , sysdate + 10))               cost_centers_count',
'   , (select count(DISTINCT Ps.cost_center)',
'      from budget_proposal_cost_centers_plans ps',
'      where ps.plan_id = p.plan_id',
'      and ps.sector_id = s.sector_id)      cost_centers_count  ',
'--  , (select count (distinct PROJECT_NUMBER)',
'--            from expenditures_v',
'--            where cost_center in (select distinct COST_CENTER_CODE',
'--                                  from  GL_CODE_COMBINATIONS_V ',
'--                                  where SECTOR_ID = s.sector_id',
'--                                  and status = ''A''',
'--                                  and sysdate between nvl(start_date , sysdate - 10)',
'--                                        and nvl(end_date , sysdate + 10))',
'--            and future2 in (select * from apex_string.split(p.future2_used,'':''))) projects_count ',
'    ',
'    , (select count(distinct pp.project_number)',
'        from budget_proposal_projects_plans pp',
'        where pp.plan_id = p.plan_id',
'        and pp.sector_id = s.sector_id) projects_count',
'        ',
'       , (select count(distinct pp.ID)',
'        from budget_proposal_projects_plans pp',
'        where pp.plan_id = p.plan_id',
'        and pp.sector_id = s.sector_id) Tasks_count     ',
'FROM',
'    budget_proposal_sectors_plans s, budget_proposal_plans p',
'where s.plan_id = p.plan_id',
'and p.plan_id = :P93_PLAN_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P93_PLAN_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Sectors Report'
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
 p_id=>wwv_flow_api.id(50729811129315198)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>162554221259869434
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50729673297315197)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1216232005294941)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50729631696315196)
,p_db_column_name=>'SECTOR_INSTRUCTIONS'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Sector Instructions'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50729449513315195)
,p_db_column_name=>'COMMENTS'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50729335521315194)
,p_db_column_name=>'STATUS'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50729313746315193)
,p_db_column_name=>'ALLOW_ADD_COST_CENTER_YN'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Allow Add Cost Center ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50729137935315192)
,p_db_column_name=>'ALLOW_ADD_PROJECT_YN'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Allow Add Project ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50729041687315191)
,p_db_column_name=>'ALLOW_ADD_TASK_YN'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Allow Add Task ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50729024842315190)
,p_db_column_name=>'CEILING_CH1_REQUIRED_YN'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Ceiling Ch1 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P93_PLAN_TYPE = ''M'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50728852951315189)
,p_db_column_name=>'CEILING_CH1_AMOUNT'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Ceiling Ch1 Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P93_PLAN_TYPE = ''M'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50728735432315188)
,p_db_column_name=>'CEILING_CH2_REQUIRED_YN'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Ceiling Ch2 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P93_PLAN_TYPE = ''E'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50728647199315187)
,p_db_column_name=>'CEILING_CH2_AMOUNT'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Ceiling Ch2 Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P93_PLAN_TYPE = ''E'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50728586941315186)
,p_db_column_name=>'CEILING_CH3_REQUIRED_YN'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Ceiling Ch3 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P93_PLAN_TYPE = ''E'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50728489948315185)
,p_db_column_name=>'CEILING_CH3_AMOUNT'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Ceiling Ch3 Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P93_PLAN_TYPE = ''E'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50728397343315184)
,p_db_column_name=>'COST_CENTERS_COUNT'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Cost Centers Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50728264202315183)
,p_db_column_name=>'PROJECTS_COUNT'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Projects Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49200346884443411)
,p_db_column_name=>'TASKS_COUNT'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Tasks Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(50574013130902392)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1627101'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SECTOR_ID:SECTOR_INSTRUCTIONS:COMMENTS:STATUS:ALLOW_ADD_COST_CENTER_YN:ALLOW_ADD_PROJECT_YN:ALLOW_ADD_TASK_YN:CEILING_CH1_REQUIRED_YN:CEILING_CH1_AMOUNT:CEILING_CH2_REQUIRED_YN:CEILING_CH2_AMOUNT:CEILING_CH3_REQUIRED_YN:CEILING_CH3_AMOUNT:COST_CENTER'
||'S_COUNT:PROJECTS_COUNT:TASKS_COUNT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(50592550565653284)
,p_plug_name=>'Cost Centers / Departments'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(50578152148911919)
,p_plug_name=>'Cost Centers / Departments Report'
,p_parent_plug_id=>wwv_flow_api.id(50592550565653284)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct pc.cost_center              COST_CENTER_CODE',
'       , user_details.get_cost_center_name(pc.cost_center) cost_center_name',
'       , (select count(distinct pp.project_number)',
'          from budget_proposal_projects_plans pp',
'          where pp.plan_id = pc.plan_id',
'          and pp.cost_center = pc.cost_center) projects_count',
'       ',
'       , (select count(distinct pp.ID)',
'          from budget_proposal_projects_plans pp',
'          where pp.plan_id = pc.plan_id',
'          and pp.cost_center = pc.cost_center) Tasks_count   ',
'          ',
'from BUDGET_PROPOSAL_COST_CENTERS_PLANS pc',
'where pc.plan_id = :P93_PLAN_ID',
'order by 1'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P93_PLAN_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Cost Centers / Departments Report'
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
 p_id=>wwv_flow_api.id(50578044871911918)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>162705987517272714
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50577960601911917)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Cost Center Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50577926149911916)
,p_db_column_name=>'COST_CENTER_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50577771036911915)
,p_db_column_name=>'PROJECTS_COUNT'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Projects Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49200317245443410)
,p_db_column_name=>'TASKS_COUNT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Tasks Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(50552575393730322)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1627315'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'COST_CENTER_CODE:COST_CENTER_NAME:PROJECTS_COUNT:TASKS_COUNT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(50592155149653284)
,p_plug_name=>'Projects'
,p_icon_css_classes=>'fa-archive'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(50577637337911914)
,p_plug_name=>'Projects Report'
,p_parent_plug_id=>wwv_flow_api.id(50592155149653284)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    project_number,',
'    PROJECTS_UTIL.project_name(project_number)  project_name,',
'    PROJECTS_UTIL.project_code(project_number)  project_code,',
'    task_number,',
'    expenditure_type,',
'    description,',
'    gl_account,',
'    gl_account_name,',
'    task_name,',
'    task_description,',
'    task_end_date,',
'    cost_center,',
'    cost_center_name,',
'    budget_group_code,',
'    activity,',
'    future1,',
'    future2,',
'    future2_name,',
'    user_details.sector_id_by_cc(cost_center, sysdate)  sector_id,',
'    nvl(PROJECTS_UTIL.EXPENDITURE_BALANCE(project_number,task_number,expenditure_type, :P93_PROPOSAL_YEAR - 1 , ''B'' ),0)                 Budget',
'--    nvl(PROJECTS_UTIL.EXPENDITURE_BALANCE(project_number,task_number,expenditure_type, :P93_PROPOSAL_YEAR, ''E'' ),0)                 Encumbrance,',
'--    nvl(PROJECTS_UTIL.EXPENDITURE_BALANCE(project_number,task_number,expenditure_type, :P93_PROPOSAL_YEAR, ''F'' ),0)                 Fund_available',
'FROM',
'    expenditures_v',
'WHERE',
'    cost_center IN (',
'        SELECT DISTINCT',
'            cost_center_code',
'        FROM',
'            gl_code_combinations_v',
'        WHERE',
'            sector_id IN (',
'                SELECT DISTINCT',
'                    sector_id',
'                FROM',
'                    budget_proposal_plans',
'                WHERE',
'                    plan_id = :P93_PLAN_ID',
'            )',
'            AND status = ''A''',
'            AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)',
'    )',
'    AND future2 IN (',
'        SELECT',
'            *',
'        FROM',
'            apex_string.split(:P93_FUTURE2_USED, '':'')',
'    )',
'ORDER BY',
'    project_number,',
'    task_number;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P93_PLAN_ID,P93_FUTURE2_USED,P93_PROPOSAL_YEAR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Projects Report'
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
 p_id=>wwv_flow_api.id(50577618325911913)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>162706414063272719
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50577464425911912)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50577399541911911)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50577308092911910)
,p_db_column_name=>'PROJECT_CODE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Project Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50577155174911909)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50577111749911908)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50576989622911907)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50576843829911906)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50576804838911905)
,p_db_column_name=>'GL_ACCOUNT_NAME'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Gl Account Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50576636766911904)
,p_db_column_name=>'TASK_NAME'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Task Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50576590276911903)
,p_db_column_name=>'TASK_DESCRIPTION'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Task Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50576441222911902)
,p_db_column_name=>'TASK_END_DATE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Task End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50576349331911901)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50576295324911900)
,p_db_column_name=>'COST_CENTER_NAME'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50576199492911899)
,p_db_column_name=>'BUDGET_GROUP_CODE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Budget Group Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50576084567911898)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50575951758911897)
,p_db_column_name=>'FUTURE1'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50575925701911896)
,p_db_column_name=>'FUTURE2'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50575747579911895)
,p_db_column_name=>'FUTURE2_NAME'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Future2 Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50575644361911894)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1216232005294941)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50575537659911893)
,p_db_column_name=>'BUDGET'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'&CURRENT_YEAR. Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(50551951490730281)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1627321'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PROJECT_NUMBER:PROJECT_NAME:TASK_NUMBER:COST_CENTER:EXPENDITURE_TYPE:GL_ACCOUNT:FUTURE2:BUDGET:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(50591766645653284)
,p_plug_name=>'GL Accounts'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(50575510218911892)
,p_plug_name=>'GL Accounts Report'
,p_parent_plug_id=>wwv_flow_api.id(50591766645653284)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    ''451''       Entity,',
'    cost_center,',
'    cost_center_name,',
'    budget_group_code,',
'    activity,',
'    gl_account,',
'    gl_account_name,',
'    future1,',
'    future2,',
'    future2_name,',
'    user_details.sector_id_by_cc(cost_center, sysdate)  sector_id,',
'    sum(nvl(PROJECTS_UTIL.EXPENDITURE_BALANCE(project_number,task_number,expenditure_type, :P93_PROPOSAL_YEAR - 1 , ''B'' ),0))                 Budget',
'--    nvl(PROJECTS_UTIL.EXPENDITURE_BALANCE(project_number,task_number,expenditure_type, :P93_PROPOSAL_YEAR, ''E'' ),0)                 Encumbrance,',
'--    nvl(PROJECTS_UTIL.EXPENDITURE_BALANCE(project_number,task_number,expenditure_type, :P93_PROPOSAL_YEAR, ''F'' ),0)                 Fund_available',
'FROM',
'    expenditures_v',
'WHERE',
'    cost_center IN (',
'        SELECT DISTINCT',
'            cost_center_code',
'        FROM',
'            gl_code_combinations_v',
'        WHERE',
'            sector_id IN (',
'                SELECT DISTINCT',
'                    sector_id',
'                FROM',
'                    budget_proposal_sectors_plans',
'                WHERE',
'                    plan_id = :P93_PLAN_ID',
'            )',
'            AND status = ''A''',
'            AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)',
'    )',
'    AND future2 IN (',
'        SELECT',
'            *',
'        FROM',
'            apex_string.split(:P93_FUTURE2_USED, '':'')',
'    )',
'group BY ''451'' ,',
'    cost_center,',
'    cost_center_name,',
'    budget_group_code,',
'    activity,',
'    gl_account,',
'    gl_account_name,',
'    future1,',
'    future2,',
'    future2_name,',
'    user_details.sector_id_by_cc(cost_center, sysdate) ',
'ORDER BY',
'    cost_center,',
'    gl_account;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P93_PLAN_ID,P93_FUTURE2_USED,P93_PROPOSAL_YEAR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'GL Accounts Report'
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
 p_id=>wwv_flow_api.id(50575361807911891)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>162708670581272741
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50575288864911890)
,p_db_column_name=>'ENTITY'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Entity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50575191518911889)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50575118658911888)
,p_db_column_name=>'COST_CENTER_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50574935656911887)
,p_db_column_name=>'BUDGET_GROUP_CODE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Budget Group Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50574921703911886)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50574793733911885)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'GL Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50574675921911884)
,p_db_column_name=>'GL_ACCOUNT_NAME'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'GL Account Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50574550341911883)
,p_db_column_name=>'FUTURE1'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50574462392911882)
,p_db_column_name=>'FUTURE2'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50548950616650731)
,p_db_column_name=>'FUTURE2_NAME'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Future2 Name'
,p_column_type=>'STRING'
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
 p_id=>wwv_flow_api.id(50548835553650730)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1216232005294941)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50548758406650729)
,p_db_column_name=>'BUDGET'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(50539837702647011)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1627442'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SECTOR_ID:ENTITY:COST_CENTER:COST_CENTER_NAME:GL_ACCOUNT:GL_ACCOUNT_NAME:FUTURE2:FUTURE2_NAME:BUDGET:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(50578289680911920)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(50594008206653286)
,p_button_name=>'Back'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(50548461037650726)
,p_branch_name=>'Go To Page_From'
,p_branch_action=>'f?p=&APP_ID.:&P93_PAGE_FROM.:&SESSION.::&DEBUG.::P85_PLAN_ID:&P93_PLAN_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50728198060315182)
,p_name=>'P93_PLAN_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(50593336520653285)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50579273912911930)
,p_name=>'P93_PLAN_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(50593336520653285)
,p_prompt=>'Plan Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50579154107911929)
,p_name=>'P93_PLAN_TYPE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(50593336520653285)
,p_prompt=>'Plan Type'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'BUDGET PROPOSAL PLAN TYPES'
,p_lov=>'.'||wwv_flow_api.id(50661192721222067)||'.'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50579071706911928)
,p_name=>'P93_PROPOSAL_YEAR'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(50593336520653285)
,p_prompt=>'Proposal Year'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50578994817911927)
,p_name=>'P93_PLAN_DURATION'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(50593336520653285)
,p_prompt=>'Proposal Plan duration'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50578860267911926)
,p_name=>'P93_FUTURE2_USED'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(50593336520653285)
,p_prompt=>'Future2 Used'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'FUTURE2 LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct FUTURE2_DESCRIPTION ,FUTURE2 ',
'from dct_gl_code_combinations_all',
'order by 2'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50578776101911925)
,p_name=>'P93_ALLOW_ADD_COST_CENTER_YN'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(50593336520653285)
,p_prompt=>'Allow Add Cost Center ?'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(782922329120916)||'.'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50578639685911924)
,p_name=>'P93_ALLOW_ADD_PROJECT_YN'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(50593336520653285)
,p_prompt=>'Allow Add Project ?'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(782922329120916)||'.'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50578542468911923)
,p_name=>'P93_ALLOW_ADD_TASK_YN'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(50593336520653285)
,p_prompt=>'Allow Add Task ?'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(782922329120916)||'.'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50578455889911922)
,p_name=>'P93_STATUS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(50593336520653285)
,p_prompt=>'Plan Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50548570525650727)
,p_name=>'P93_PAGE_FROM'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(50593336520653285)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(50578425923911921)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'init Plan Details'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    plan_name,',
'    PLAN_TYPE,',
'    proposal_year,',
'    plan_duration || '' years''     plan_duration,',
'    status,',
'    future2_used,',
'    allow_add_cost_center_yn,',
'    allow_add_project_yn,',
'    allow_add_task_yn',
'into',
'    :P93_PLAN_NAME,',
'    :P93_PLAN_TYPE,',
'    :P93_PROPOSAL_YEAR,',
'    :P93_PLAN_DURATION,',
'    :P93_STATUS,',
'    :P93_FUTURE2_USED,',
'    :P93_ALLOW_ADD_COST_CENTER_YN,',
'    :P93_ALLOW_ADD_PROJECT_YN,',
'    :P93_ALLOW_ADD_TASK_YN',
'FROM budget_proposal_plans',
'where plan_id = :P93_PLAN_ID;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
