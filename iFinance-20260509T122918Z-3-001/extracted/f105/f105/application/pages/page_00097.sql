prompt --application/pages/page_00097
begin
--   Manifest
--     PAGE: 00097
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
 p_id=>97
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Cost Center Plan'
,p_alias=>'COST-CENTER-PLAN'
,p_step_title=>'Cost Center / Department Plan'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230805204155'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(49378547048265057)
,p_plug_name=>'Projects Proposal Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       PLAN_ID,',
'       PLAN_ID    PLAN_ID_H,',
'       SECTOR_ID,',
'        SECTOR_ID SECTOR_ID_H,',
'       projects_util.PROJECT_Name(PROJECT_NUMBER) project_name,',
'       PROJECT_NUMBER,',
'       TASK_NUMBER,',
'       EXPENDITURE_TYPE,',
'       PROJECTS_UTIL.TASK_INITIATIVE_ID(PROJECT_NUMBER,TASK_NUMBER )    INITIATIVE,',
'       PROJECTS_UTIL.TASK_PROGRAM_ID(PROJECT_NUMBER,TASK_NUMBER ) program,',
'        PROJECTS_UTIL.TASK_OBJECTIVE_ID(PROJECT_NUMBER,TASK_NUMBER ) objective,',
'        PROJECTS_UTIL.get_task_chapter(PROJECT_NUMBER,TASK_NUMBER ) Chapter,',
'       ENTITY_CODE,',
'       COST_CENTER,',
'       BUDGET_GROUB_CODE,',
'       GL_ACCOUNT,',
'       ACTIVITY,',
'       FUTURE1,',
'       FUTURE2,',
'       PROJECT_NUMBER_NEW,',
'       TASK_NUMBER_NEW,',
'       EXPENDITURE_TYPE_NEW,',
'       COST_CENTER_NEW,',
'       BUDGET_GROUB_CODE_NEW,',
'       GL_ACCOUNT_NEW,',
'       ACTIVITY_NEW,',
'       FUTURE1_NEW,',
'       FUTURE2_NEW,',
'       IT_BUDGET_RELATED_COST_CENTER,',
'--       OBJECTIVE_ID,',
'--       PROGRAM_ID,',
'--       INITIATIVE_ID,',
'       PROJECT_DESCRIPTION,',
'       OUTCOME,',
'       START_DATE,',
'       END_DATE,',
'       BP_EXPENSE_CATEGORY_ID,',
'       BP_EXPENSE_CLASS_ID,',
'       BP_COMMITMENT_TYPE_ID,',
'       BP_CLASSIFICATIONS_ID,',
'       COST_DRIVER,',
'       COST_DRIVER_UOM,',
'       COST_DRIVER_QUANTITY,',
'       COST,',
'       TOTAL_COST,',
'       JUSTIFICATIONS,',
'       CALCULATION_BASIS,',
'--       CEILING_CH1_REQUIRED_YN,',
'--       CEILING_CH1_AMOUNT,',
'--       CEILING_CH2_REQUIRED_YN,',
'--       CEILING_CH2_AMOUNT,',
'--       CEILING_CH3_REQUIRED_YN,',
'--       CEILING_CH3_AMOUNT,',
'--       CEILING_CH6_REQUIRED_YN,',
'--       CEILING_CH6_AMOUNT,',
'       ALLOW_ADD_TASK_YN,',
'       COMMENTS,',
'       STATUS,',
'       PLAN_VERSION,',
'       BUDGET_Y1,',
'       BUDGET_Y2,',
'       BUDGET_Y3,',
'       BUDGET_Y4,',
'       BUDGET_Y5,',
'       ACTUAL_Y1,',
'       ACTUAL_Y2,',
'       ACTUAL_Y3,',
'       ACTUAL_Y4,',
'       ACTUAL_Y5,',
'       JAN,',
'       FEB,',
'       MAR,',
'       APR,',
'       MAY,',
'       JUN,',
'       JUL,',
'       AUG,',
'       SEP,',
'       OCT,',
'       NOV,',
'       DEC,',
'       SUBMITTED_ON,',
'       SUBMITTED_BY,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       PROPOSAL_YEAR,',
'       PRIORITY,',
'       DELIVERABLE_1,',
'       TRAGET_1,',
'       DELIVERABLE_2,',
'       TARGET_2,',
'       DELIVERABLE_3,',
'       TRAGET_3,',
'       new_line,',
'       FBP_COMMENT,',
'       FBP_COMMENT_BY,',
'       FBP_COMMENY_ON,',
'       PB_COMMENT,',
'       PB_COMMENT_BY,',
'       PB_COMMENT_ON,',
'       ID link,',
'       ID comment_link,',
'       Revised_Budget_FBP,',
'       Revised_Budget_Just_FBP,',
'       Revised_Budget_Remark_FBP,',
'       Revised_Budget_FPR,',
'       Revised_Budget_Just_FPR,',
'       Revised_Budget_Remark_FPR',
'       ',
'  from BUDGET_PROPOSAL_PROJECTS_PLANS',
'  where plan_id = :P97_PLAN_ID',
'  and cost_center = :P97_COST_CENTER ',
'  and cc_plan_id = :P97_CC_PLAN_ID;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P97_PLAN_ID,P97_COST_CENTER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P97_COST_CENTER not in (''4517010'' , ''4517100'', ''4517150'',''4517200'', ''4517250'')'
,p_prn_document_header=>'SERVER'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A3'
,p_prn_width=>297
,p_prn_height=>420
,p_prn_orientation=>'VERTICAL'
,p_prn_page_header=>'Projects Proposal Details'
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
 p_id=>wwv_flow_api.id(49378187930265057)
,p_name=>'Report 1'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_allow_save_rpt_public=>'Y'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:98:&SESSION.::&DEBUG.:RP,:P98_ID,P98_PAGE_FROM,P98_STATUS,P98_PLAN_ID_H,P98_CC_PLAN_ID_H:\#ID#\,97,#STATUS#,\#PLAN_ID_H#\,&P97_CC_PLAN_ID.'
,p_detail_link_text=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_owner=>'TCA9051'
,p_internal_uid=>163905844458919575
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49378128129265057)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49377641752265057)
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
 p_id=>wwv_flow_api.id(49377273713265056)
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
 p_id=>wwv_flow_api.id(49376834700265056)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49376469412265056)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49376050187265056)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49375707716265056)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49375267088265056)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49374873632265055)
,p_db_column_name=>'BUDGET_GROUB_CODE'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Budget Groub Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49374530228265055)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'GL Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49374083937265055)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49373717172265055)
,p_db_column_name=>'FUTURE1'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49373242763265055)
,p_db_column_name=>'FUTURE2'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49372870724265055)
,p_db_column_name=>'PROJECT_NUMBER_NEW'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Project Number New'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49372529162265054)
,p_db_column_name=>'TASK_NUMBER_NEW'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Task Number New'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49372096524265054)
,p_db_column_name=>'EXPENDITURE_TYPE_NEW'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Expenditure Type New'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49371718136265054)
,p_db_column_name=>'COST_CENTER_NEW'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Cost Center New'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49371316991265054)
,p_db_column_name=>'BUDGET_GROUB_CODE_NEW'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Budget Groub Code New'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49370889462265054)
,p_db_column_name=>'GL_ACCOUNT_NEW'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Gl Account New'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49370454883265054)
,p_db_column_name=>'ACTIVITY_NEW'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Activity New'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49370039203265053)
,p_db_column_name=>'FUTURE1_NEW'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Future1 New'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49369683512265053)
,p_db_column_name=>'FUTURE2_NEW'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Future2 New'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49369261586265053)
,p_db_column_name=>'IT_BUDGET_RELATED_COST_CENTER'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'IT Budget Related Cost Center'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49367675923265052)
,p_db_column_name=>'PROJECT_DESCRIPTION'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Project Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49367278432265052)
,p_db_column_name=>'OUTCOME'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'Outcome'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49366897409265052)
,p_db_column_name=>'START_DATE'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49366482770265052)
,p_db_column_name=>'END_DATE'
,p_display_order=>30
,p_column_identifier=>'AD'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49366125178265052)
,p_db_column_name=>'BP_EXPENSE_CATEGORY_ID'
,p_display_order=>31
,p_column_identifier=>'AE'
,p_column_label=>'Expense Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(54437167442944357)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49365674231265051)
,p_db_column_name=>'BP_EXPENSE_CLASS_ID'
,p_display_order=>32
,p_column_identifier=>'AF'
,p_column_label=>'Expense Class'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(54436748529917930)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49365316210265051)
,p_db_column_name=>'BP_COMMITMENT_TYPE_ID'
,p_display_order=>33
,p_column_identifier=>'AG'
,p_column_label=>'Commitment Type'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(54433518523880036)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49364868688265051)
,p_db_column_name=>'BP_CLASSIFICATIONS_ID'
,p_display_order=>34
,p_column_identifier=>'AH'
,p_column_label=>'Classifications'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(54432856102868605)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49364498991265051)
,p_db_column_name=>'COST_DRIVER'
,p_display_order=>35
,p_column_identifier=>'AI'
,p_column_label=>'Cost Driver'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49364107429265051)
,p_db_column_name=>'COST_DRIVER_UOM'
,p_display_order=>36
,p_column_identifier=>'AJ'
,p_column_label=>'Cost Driver - UOM'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49363639196265051)
,p_db_column_name=>'COST_DRIVER_QUANTITY'
,p_display_order=>37
,p_column_identifier=>'AK'
,p_column_label=>'Cost Driver - Quantity'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49363298237265050)
,p_db_column_name=>'COST'
,p_display_order=>38
,p_column_identifier=>'AL'
,p_column_label=>'Cost'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49362835309265050)
,p_db_column_name=>'TOTAL_COST'
,p_display_order=>39
,p_column_identifier=>'AM'
,p_column_label=>'Total Cost'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49362455379265050)
,p_db_column_name=>'JUSTIFICATIONS'
,p_display_order=>40
,p_column_identifier=>'AN'
,p_column_label=>'Justifications'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49362037544265050)
,p_db_column_name=>'CALCULATION_BASIS'
,p_display_order=>41
,p_column_identifier=>'AO'
,p_column_label=>'Calculation Basis'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49358510482265048)
,p_db_column_name=>'ALLOW_ADD_TASK_YN'
,p_display_order=>50
,p_column_identifier=>'AX'
,p_column_label=>'Allow Add Task Yn'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49358038791265048)
,p_db_column_name=>'COMMENTS'
,p_display_order=>51
,p_column_identifier=>'AY'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49357632790265048)
,p_db_column_name=>'STATUS'
,p_display_order=>52
,p_column_identifier=>'AZ'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49357287745265048)
,p_db_column_name=>'PLAN_VERSION'
,p_display_order=>53
,p_column_identifier=>'BA'
,p_column_label=>'Plan Version'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49356900369265048)
,p_db_column_name=>'BUDGET_Y1'
,p_display_order=>54
,p_column_identifier=>'BB'
,p_column_label=>'Budget 2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49356498945265048)
,p_db_column_name=>'BUDGET_Y2'
,p_display_order=>55
,p_column_identifier=>'BC'
,p_column_label=>'Budget 2025'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49356079599265047)
,p_db_column_name=>'BUDGET_Y3'
,p_display_order=>56
,p_column_identifier=>'BD'
,p_column_label=>'Budget 2026'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49355727631265047)
,p_db_column_name=>'BUDGET_Y4'
,p_display_order=>57
,p_column_identifier=>'BE'
,p_column_label=>'Budget 2027'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49355280093265047)
,p_db_column_name=>'BUDGET_Y5'
,p_display_order=>58
,p_column_identifier=>'BF'
,p_column_label=>'Budget 2028'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49354856780265047)
,p_db_column_name=>'JAN'
,p_display_order=>59
,p_column_identifier=>'BG'
,p_column_label=>'01-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49354495762265047)
,p_db_column_name=>'FEB'
,p_display_order=>60
,p_column_identifier=>'BH'
,p_column_label=>'02-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49354085379265047)
,p_db_column_name=>'MAR'
,p_display_order=>61
,p_column_identifier=>'BI'
,p_column_label=>'03-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49353691604265046)
,p_db_column_name=>'APR'
,p_display_order=>62
,p_column_identifier=>'BJ'
,p_column_label=>'04-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49353289694265046)
,p_db_column_name=>'MAY'
,p_display_order=>63
,p_column_identifier=>'BK'
,p_column_label=>'05-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49352867700265046)
,p_db_column_name=>'JUN'
,p_display_order=>64
,p_column_identifier=>'BL'
,p_column_label=>'06-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49352529080265046)
,p_db_column_name=>'JUL'
,p_display_order=>65
,p_column_identifier=>'BM'
,p_column_label=>'07-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49352038500265046)
,p_db_column_name=>'AUG'
,p_display_order=>66
,p_column_identifier=>'BN'
,p_column_label=>'08-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49351654737265046)
,p_db_column_name=>'SEP'
,p_display_order=>67
,p_column_identifier=>'BO'
,p_column_label=>'09-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49351325686265045)
,p_db_column_name=>'OCT'
,p_display_order=>68
,p_column_identifier=>'BP'
,p_column_label=>'10-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49350863856265045)
,p_db_column_name=>'NOV'
,p_display_order=>69
,p_column_identifier=>'BQ'
,p_column_label=>'11-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49350445779265045)
,p_db_column_name=>'DEC'
,p_display_order=>70
,p_column_identifier=>'BR'
,p_column_label=>'12-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49350069471265045)
,p_db_column_name=>'SUBMITTED_ON'
,p_display_order=>71
,p_column_identifier=>'BS'
,p_column_label=>'Submitted On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49349633002265045)
,p_db_column_name=>'SUBMITTED_BY'
,p_display_order=>72
,p_column_identifier=>'BT'
,p_column_label=>'Submitted By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49349280172265044)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>73
,p_column_identifier=>'BU'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49348871574265044)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>74
,p_column_identifier=>'BV'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49348513647265044)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>75
,p_column_identifier=>'BW'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49348071765265044)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>76
,p_column_identifier=>'BX'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50228771768855789)
,p_db_column_name=>'ACTUAL_Y1'
,p_display_order=>86
,p_column_identifier=>'BY'
,p_column_label=>'Budget 2023'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50228664365855788)
,p_db_column_name=>'ACTUAL_Y2'
,p_display_order=>96
,p_column_identifier=>'BZ'
,p_column_label=>'Actual 2022'
,p_column_link=>'f?p=&APP_ID.:107:&SESSION.::&DEBUG.::P107_ACCOUNTING_YEAR,P107_PROJECT_NUMBER,P107_TASK_NUMBER,P107_PROJECT_NAME:&P97_A2.,#PROJECT_NUMBER#,#TASK_NUMBER#,#PROJECT_NAME#'
,p_column_linktext=>'#ACTUAL_Y2#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50228541573855787)
,p_db_column_name=>'ACTUAL_Y3'
,p_display_order=>106
,p_column_identifier=>'CA'
,p_column_label=>'Actual 2021'
,p_column_link=>'f?p=&APP_ID.:107:&SESSION.::&DEBUG.::P107_ACCOUNTING_YEAR,P107_PROJECT_NUMBER,P107_TASK_NUMBER,P107_PROJECT_NAME:&P97_A3.,#PROJECT_NUMBER#,#TASK_NUMBER#,#PROJECT_NAME#'
,p_column_linktext=>'#ACTUAL_Y3#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50228459453855786)
,p_db_column_name=>'ACTUAL_Y4'
,p_display_order=>116
,p_column_identifier=>'CB'
,p_column_label=>'Actual 2020'
,p_column_link=>'f?p=&APP_ID.:107:&SESSION.::&DEBUG.::P107_ACCOUNTING_YEAR,P107_PROJECT_NUMBER,P107_TASK_NUMBER,P107_PROJECT_NAME:&P97_A4.,#PROJECT_NUMBER#,#TASK_NUMBER#,#PROJECT_NAME#'
,p_column_linktext=>'#ACTUAL_Y4#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50228401406855785)
,p_db_column_name=>'ACTUAL_Y5'
,p_display_order=>126
,p_column_identifier=>'CC'
,p_column_label=>'Actual 2019'
,p_column_link=>'f?p=&APP_ID.:107:&SESSION.::&DEBUG.::P107_ACCOUNTING_YEAR,P107_PROJECT_NUMBER,P107_TASK_NUMBER:&P97_A5.,#PROJECT_NUMBER#,#TASK_NUMBER#'
,p_column_linktext=>'#ACTUAL_Y5#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49199246316443400)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>136
,p_column_identifier=>'CD'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(48278616258525396)
,p_db_column_name=>'INITIATIVE'
,p_display_order=>146
,p_column_identifier=>'CE'
,p_column_label=>'Initiative'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(916102580051005)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(48278461856525395)
,p_db_column_name=>'PROGRAM'
,p_display_order=>156
,p_column_identifier=>'CF'
,p_column_label=>'Program'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(49925322344786792)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(48278408386525394)
,p_db_column_name=>'OBJECTIVE'
,p_display_order=>166
,p_column_identifier=>'CG'
,p_column_label=>'Objective'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(835817871529402)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(48278328174525393)
,p_db_column_name=>'CHAPTER'
,p_display_order=>176
,p_column_identifier=>'CH'
,p_column_label=>'Chapter'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(71071651503392969)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(48278196386525392)
,p_db_column_name=>'PROPOSAL_YEAR'
,p_display_order=>186
,p_column_identifier=>'CI'
,p_column_label=>'Proposal Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(48278042751525391)
,p_db_column_name=>'PRIORITY'
,p_display_order=>196
,p_column_identifier=>'CJ'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48255921784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(48277937338525390)
,p_db_column_name=>'DELIVERABLE_1'
,p_display_order=>206
,p_column_identifier=>'CK'
,p_column_label=>'Deliverable 1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(48277919044525389)
,p_db_column_name=>'TRAGET_1'
,p_display_order=>216
,p_column_identifier=>'CL'
,p_column_label=>'Target 1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(48277805862525388)
,p_db_column_name=>'DELIVERABLE_2'
,p_display_order=>226
,p_column_identifier=>'CM'
,p_column_label=>'Deliverable 2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(48277682143525387)
,p_db_column_name=>'TARGET_2'
,p_display_order=>236
,p_column_identifier=>'CN'
,p_column_label=>'Target 2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(48277615743525386)
,p_db_column_name=>'DELIVERABLE_3'
,p_display_order=>246
,p_column_identifier=>'CO'
,p_column_label=>'Deliverable 3'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(48277508995525385)
,p_db_column_name=>'TRAGET_3'
,p_display_order=>256
,p_column_identifier=>'CP'
,p_column_label=>'Target 3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41017688860580814)
,p_db_column_name=>'NEW_LINE'
,p_display_order=>266
,p_column_identifier=>'CQ'
,p_column_label=>'New Line'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38673621148494009)
,p_db_column_name=>'SECTOR_ID_H'
,p_display_order=>276
,p_column_identifier=>'CS'
,p_column_label=>'Sector Id H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38671323933493986)
,p_db_column_name=>'PLAN_ID_H'
,p_display_order=>296
,p_column_identifier=>'CT'
,p_column_label=>'Plan Id H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38618532740086594)
,p_db_column_name=>'FBP_COMMENT'
,p_display_order=>306
,p_column_identifier=>'CU'
,p_column_label=>'FBP Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38618522593086593)
,p_db_column_name=>'FBP_COMMENT_BY'
,p_display_order=>316
,p_column_identifier=>'CV'
,p_column_label=>'FBP Comment By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38618375333086592)
,p_db_column_name=>'FBP_COMMENY_ON'
,p_display_order=>326
,p_column_identifier=>'CW'
,p_column_label=>'FBP Comment On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38618234658086591)
,p_db_column_name=>'PB_COMMENT'
,p_display_order=>336
,p_column_identifier=>'CX'
,p_column_label=>'BP Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38618153962086590)
,p_db_column_name=>'PB_COMMENT_BY'
,p_display_order=>346
,p_column_identifier=>'CY'
,p_column_label=>'BP Comment By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
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
 p_id=>wwv_flow_api.id(38618042978086589)
,p_db_column_name=>'PB_COMMENT_ON'
,p_display_order=>356
,p_column_identifier=>'CZ'
,p_column_label=>'BP Comment On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40679113287038587)
,p_db_column_name=>'LINK'
,p_display_order=>366
,p_column_identifier=>'CR'
,p_column_label=>'Documents'
,p_column_link=>'f?p=&APP_ID.:115:&SESSION.::&DEBUG.:115:P115_PLAN_ID,P115_COST_CENTER,P115_PROJECT_NUMBER,P115_TASK_NUMBER,P115_SECTOR_ID:&P97_PLAN_ID.,#COST_CENTER#,#PROJECT_NUMBER#,#TASK_NUMBER#,#SECTOR_ID_H#'
,p_column_linktext=>'<span aria-hidden="true" class="fa fa-paperclip"></span>'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38617954726086588)
,p_db_column_name=>'COMMENT_LINK'
,p_display_order=>376
,p_column_identifier=>'DA'
,p_column_label=>'Comment'
,p_column_link=>'f?p=&APP_ID.:116:&SESSION.::&DEBUG.:116:P116_PLAN_ID,P116_CC_PLAN_ID,P116_PROJECT_NUMBER,P116_TASK_NUMBER,P116_PROJECT_PLAN_ID,P116_COST_CENTER:&P97_PLAN_ID.,&P97_CC_PLAN_ID.,#PROJECT_NUMBER#,#TASK_NUMBER#,#ID#,#COST_CENTER#'
,p_column_linktext=>'<span aria-hidden="true" class="fa fa-commenting-o fa-anim-flash"></span>'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31481508278124103)
,p_db_column_name=>'REVISED_BUDGET_FBP'
,p_display_order=>386
,p_column_identifier=>'DB'
,p_column_label=>'Revised Budget - FBP'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_BTF_QUERY_YN       = ''Y'' OR',
':IS_BUDGET_PLANNING_YN = ''Y'' OR',
':IS_IFINANCE_ADMIN     = ''Y'' OR',
':IS_SECTOR_PLANNER_YN  = ''Y'''))
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31481427979124102)
,p_db_column_name=>'REVISED_BUDGET_JUST_FBP'
,p_display_order=>396
,p_column_identifier=>'DC'
,p_column_label=>'Revised Budget Justification - FBP'
,p_column_type=>'STRING'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_BTF_QUERY_YN       = ''Y'' OR',
':IS_BUDGET_PLANNING_YN = ''Y'' OR',
':IS_IFINANCE_ADMIN     = ''Y'' OR',
':IS_SECTOR_PLANNER_YN  = ''Y'''))
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31481328014124101)
,p_db_column_name=>'REVISED_BUDGET_REMARK_FBP'
,p_display_order=>406
,p_column_identifier=>'DD'
,p_column_label=>'Revised Budget Remark - FBP'
,p_column_type=>'STRING'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_BTF_QUERY_YN       = ''Y'' OR',
':IS_BUDGET_PLANNING_YN = ''Y'' OR',
':IS_IFINANCE_ADMIN     = ''Y'' OR',
':IS_SECTOR_PLANNER_YN  = ''Y'''))
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31481137983124100)
,p_db_column_name=>'REVISED_BUDGET_FPR'
,p_display_order=>416
,p_column_identifier=>'DE'
,p_column_label=>'Revised Budget - Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_BTF_QUERY_YN       = ''Y'' OR',
':IS_BUDGET_PLANNING_YN = ''Y'' OR',
':IS_IFINANCE_ADMIN     = ''Y'' OR',
':IS_SECTOR_PLANNER_YN  = ''Y'''))
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31481069963124099)
,p_db_column_name=>'REVISED_BUDGET_JUST_FPR'
,p_display_order=>426
,p_column_identifier=>'DF'
,p_column_label=>'Revised Budget Justification - Budget'
,p_column_type=>'STRING'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_BTF_QUERY_YN       = ''Y'' OR',
':IS_BUDGET_PLANNING_YN = ''Y'' OR',
':IS_IFINANCE_ADMIN     = ''Y'' OR',
':IS_SECTOR_PLANNER_YN  = ''Y'''))
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31481012369124098)
,p_db_column_name=>'REVISED_BUDGET_REMARK_FPR'
,p_display_order=>436
,p_column_identifier=>'DG'
,p_column_label=>'Revised Budget Remark - Budget'
,p_column_type=>'STRING'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_BTF_QUERY_YN       = ''Y'' OR',
':IS_BUDGET_PLANNING_YN = ''Y'' OR',
':IS_IFINANCE_ADMIN     = ''Y'' OR',
':IS_SECTOR_PLANNER_YN  = ''Y'''))
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(49327062326228250)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1639570'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SECTOR_ID:PROJECT_NUMBER:PROJECT_NAME:TASK_NUMBER:EXPENDITURE_TYPE:INITIATIVE:PROGRAM:OBJECTIVE:CHAPTER:PROJECT_DESCRIPTION:OUTCOME:START_DATE:END_DATE:BP_EXPENSE_CATEGORY_ID:BP_EXPENSE_CLASS_ID:BP_COMMITMENT_TYPE_ID:BP_CLASSIFICATIONS_ID:PRIORITY:CA'
||'LCULATION_BASIS:JUSTIFICATIONS:COMMENTS:ACTUAL_Y5:ACTUAL_Y4:ACTUAL_Y3:ACTUAL_Y2:ACTUAL_Y1:BUDGET_Y1:JAN:FEB:MAR:APR:MAY:JUN:JUL:AUG:SEP:OCT:NOV:DEC:BUDGET_Y2:BUDGET_Y3:BUDGET_Y4:DELIVERABLE_1:TRAGET_1:DELIVERABLE_2:TARGET_2:DELIVERABLE_3:TRAGET_3:STA'
||'TUS:LINK::COMMENT_LINK:REVISED_BUDGET_FBP:REVISED_BUDGET_JUST_FBP:REVISED_BUDGET_REMARK_FBP:REVISED_BUDGET_FPR:REVISED_BUDGET_JUST_FPR:REVISED_BUDGET_REMARK_FPR'
,p_sort_column_1=>'PROJECT_NUMBER'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'TASK_NUMBER'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
,p_sum_columns_on_break=>'BUDGET_Y1:JAN:FEB:MAR:APR:MAY:JUN:JUL:AUG:SEP:OCT:NOV:DEC:BUDGET_Y2:BUDGET_Y3:BUDGET_Y4:REVISED_BUDGET_FBP:REVISED_BUDGET_FPR'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(43095814179761180)
,p_application_user=>'TCA9051'
,p_name=>'Check Missing Data'
,p_report_seq=>10
,p_report_alias=>'1703685'
,p_status=>'PUBLIC'
,p_report_columns=>'SECTOR_ID:PROJECT_NUMBER:PROJECT_NAME:TASK_NUMBER:EXPENDITURE_TYPE:INITIATIVE:PROGRAM:OBJECTIVE:CHAPTER:PROJECT_DESCRIPTION:OUTCOME:START_DATE:END_DATE:BP_EXPENSE_CATEGORY_ID:BP_EXPENSE_CLASS_ID:BP_COMMITMENT_TYPE_ID:BP_CLASSIFICATIONS_ID:PRIORITY:CA'
||'LCULATION_BASIS:JUSTIFICATIONS:COMMENTS:ACTUAL_Y5:ACTUAL_Y4:ACTUAL_Y3:ACTUAL_Y2:ACTUAL_Y1:BUDGET_Y1:JAN:FEB:MAR:APR:MAY:JUN:JUL:AUG:SEP:OCT:NOV:DEC:BUDGET_Y2:BUDGET_Y3:BUDGET_Y4:DELIVERABLE_1:TRAGET_1:DELIVERABLE_2:TARGET_2:DELIVERABLE_3:TRAGET_3:STA'
||'TUS:'
,p_sort_column_1=>'PROJECT_NUMBER'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'TASK_NUMBER'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
,p_sum_columns_on_break=>'BUDGET_Y1:JAN:FEB:MAR:APR:MAY:JUN:JUL:AUG:SEP:OCT:NOV:DEC:BUDGET_Y2:BUDGET_Y3:BUDGET_Y4'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(35854889121437211)
,p_report_id=>wwv_flow_api.id(43095814179761180)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'BP_CLASSIFICATIONS_ID'
,p_operator=>'is null'
,p_condition_sql=>' (case when ("BP_CLASSIFICATIONS_ID" is null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(35854477103437210)
,p_report_id=>wwv_flow_api.id(43095814179761180)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'BP_COMMITMENT_TYPE_ID'
,p_operator=>'is null'
,p_condition_sql=>' (case when ("BP_COMMITMENT_TYPE_ID" is null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(35854053371437209)
,p_report_id=>wwv_flow_api.id(43095814179761180)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'BP_EXPENSE_CATEGORY_ID'
,p_operator=>'is null'
,p_condition_sql=>' (case when ("BP_EXPENSE_CATEGORY_ID" is null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(35853690549437209)
,p_report_id=>wwv_flow_api.id(43095814179761180)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'BP_EXPENSE_CLASS_ID'
,p_operator=>'is null'
,p_condition_sql=>' (case when ("BP_EXPENSE_CLASS_ID" is null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(35853277878437208)
,p_report_id=>wwv_flow_api.id(43095814179761180)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'BUDGET_Y2'
,p_operator=>'is null'
,p_condition_sql=>' (case when ("BUDGET_Y2" is null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#E8E8E8'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(35852914714437208)
,p_report_id=>wwv_flow_api.id(43095814179761180)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'BUDGET_Y3'
,p_operator=>'is null'
,p_condition_sql=>' (case when ("BUDGET_Y3" is null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#CCE5FF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(35852501678437207)
,p_report_id=>wwv_flow_api.id(43095814179761180)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'BUDGET_Y4'
,p_operator=>'is null'
,p_condition_sql=>' (case when ("BUDGET_Y4" is null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(35852128621437206)
,p_report_id=>wwv_flow_api.id(43095814179761180)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'CALCULATION_BASIS'
,p_operator=>'is null'
,p_condition_sql=>' (case when ("CALCULATION_BASIS" is null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFD6D2'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(35851707182437206)
,p_report_id=>wwv_flow_api.id(43095814179761180)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'DELIVERABLE_1'
,p_operator=>'is null'
,p_condition_sql=>' (case when ("DELIVERABLE_1" is null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(35851256126437205)
,p_report_id=>wwv_flow_api.id(43095814179761180)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'END_DATE'
,p_operator=>'is null'
,p_condition_sql=>' (case when ("END_DATE" is null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(35850913517437204)
,p_report_id=>wwv_flow_api.id(43095814179761180)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'JUSTIFICATIONS'
,p_operator=>'is null'
,p_condition_sql=>' (case when ("JUSTIFICATIONS" is null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#CCE5FF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(35850472259437204)
,p_report_id=>wwv_flow_api.id(43095814179761180)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'OUTCOME'
,p_operator=>'is null'
,p_condition_sql=>' (case when ("OUTCOME" is null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(35850120338437203)
,p_report_id=>wwv_flow_api.id(43095814179761180)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'PRIORITY'
,p_operator=>'is null'
,p_condition_sql=>' (case when ("PRIORITY" is null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(35849664487437202)
,p_report_id=>wwv_flow_api.id(43095814179761180)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'PROJECT_DESCRIPTION'
,p_operator=>'is null'
,p_condition_sql=>' (case when ("PROJECT_DESCRIPTION" is null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFD6D2'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(35849326879437202)
,p_report_id=>wwv_flow_api.id(43095814179761180)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'START_DATE'
,p_operator=>'is null'
,p_condition_sql=>' (case when ("START_DATE" is null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(35848914539437201)
,p_report_id=>wwv_flow_api.id(43095814179761180)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'TRAGET_1'
,p_operator=>'is null'
,p_condition_sql=>' (case when ("TRAGET_1" is null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFD6D2'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(35855257166437211)
,p_report_id=>wwv_flow_api.id(43095814179761180)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'BUDGET_Y1'
,p_operator=>'>'
,p_expr=>'0'
,p_condition_sql=>'"BUDGET_Y1" > to_number(#APXWS_EXPR#)'
,p_condition_display=>'#APXWS_COL_NAME# > #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(39367044115108266)
,p_application_user=>'TCA9051'
,p_name=>'Budget Review'
,p_description=>'Used to review plan for FBP'
,p_report_seq=>10
,p_report_alias=>'1739170'
,p_status=>'PUBLIC'
,p_report_columns=>'PROJECT_NUMBER:PROJECT_NAME:TASK_NUMBER:EXPENDITURE_TYPE:BP_COMMITMENT_TYPE_ID:BP_EXPENSE_CLASS_ID:BP_CLASSIFICATIONS_ID:PRIORITY:CALCULATION_BASIS:JUSTIFICATIONS:COMMENTS:ACTUAL_Y5:ACTUAL_Y4:ACTUAL_Y3:ACTUAL_Y2:ACTUAL_Y1:BUDGET_Y1:DELIVERABLE_1:TRAG'
||'ET_1:'
,p_sort_column_1=>'PROJECT_NUMBER'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'TASK_NUMBER'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
,p_sum_columns_on_break=>'BUDGET_Y1:JAN:FEB:MAR:APR:MAY:JUN:JUL:AUG:SEP:OCT:NOV:DEC'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(38319258255856348)
,p_application_user=>'TCA9272'
,p_name=>'Review Version'
,p_report_seq=>10
,p_report_alias=>'1749648'
,p_status=>'PUBLIC'
,p_report_columns=>'PROJECT_NUMBER:PROJECT_NAME:TASK_NUMBER:EXPENDITURE_TYPE:CHAPTER:BUDGET_Y1:ACTUAL_Y1:ACTUAL_Y2:ACTUAL_Y3:PROJECT_DESCRIPTION:JUSTIFICATIONS:CALCULATION_BASIS:PRIORITY:BP_EXPENSE_CATEGORY_ID:BP_EXPENSE_CLASS_ID:BP_COMMITMENT_TYPE_ID:BP_CLASSIFICATIONS'
||'_ID:COMMENTS:LINK:COMMENT_LINK:FBP_COMMENT:'
,p_sort_column_1=>'PROJECT_NUMBER'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'TASK_NUMBER'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
,p_sum_columns_on_break=>'BUDGET_Y1:JAN:FEB:MAR:APR:MAY:JUN:JUL:AUG:SEP:OCT:NOV:DEC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(38106250219692994)
,p_report_id=>wwv_flow_api.id(38319258255856348)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'BUDGET_Y1'
,p_operator=>'>'
,p_expr=>'0'
,p_condition_sql=>'"BUDGET_Y1" > to_number(#APXWS_EXPR#)'
,p_condition_display=>'#APXWS_COL_NAME# > #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(49346793552265038)
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
 p_id=>wwv_flow_api.id(49279463267009328)
,p_plug_name=>'Plan: &P97_PLAN_NAME. - Department / Cost Center:  &P97_COST_CENTER. Plan Details'
,p_icon_css_classes=>'fa-list-alt'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(47565328332766398)
,p_plug_name=>'Department Instructions'
,p_parent_plug_id=>wwv_flow_api.id(49279463267009328)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>70
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(47358016585656783)
,p_plug_name=>'Budget Plan General Instructions'
,p_parent_plug_id=>wwv_flow_api.id(49279463267009328)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>80
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(46724486061448184)
,p_plug_name=>'Budget Instructions Report'
,p_parent_plug_id=>wwv_flow_api.id(47358016585656783)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--removeHeader:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select rownum No,',
'        ID,',
'       PLAN_ID,',
'       INSTRUCTION,',
'       COMMENTS,',
'       STATUS,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       INSTRUCTION_AR',
'  from BUDGET_PROPOSAL_SECTORS_PLAN_INSTRUCTIONS',
'  where plan_id = :P97_PLAN_ID',
'  order by ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P97_PLAN_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Budget Instructions Report'
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
 p_id=>wwv_flow_api.id(46724359842448183)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>166559672546736449
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46212098648316322)
,p_db_column_name=>'NO'
,p_display_order=>10
,p_column_identifier=>'K'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46212895180316330)
,p_db_column_name=>'INSTRUCTION'
,p_display_order=>20
,p_column_identifier=>'C'
,p_column_label=>'Instruction'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46212200758316323)
,p_db_column_name=>'INSTRUCTION_AR'
,p_display_order=>30
,p_column_identifier=>'J'
,p_column_label=>'Instruction Arabic'
,p_column_type=>'STRING'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46724294400448182)
,p_db_column_name=>'ID'
,p_display_order=>40
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46212984300316331)
,p_db_column_name=>'PLAN_ID'
,p_display_order=>50
,p_column_identifier=>'B'
,p_column_label=>'Plan Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46212745811316329)
,p_db_column_name=>'COMMENTS'
,p_display_order=>60
,p_column_identifier=>'D'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46212710658316328)
,p_db_column_name=>'STATUS'
,p_display_order=>70
,p_column_identifier=>'E'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46212582593316327)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>80
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46212464158316326)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>90
,p_column_identifier=>'G'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46212341401316325)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>100
,p_column_identifier=>'H'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46212302349316324)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>110
,p_column_identifier=>'I'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(46202483909306565)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1670816'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'NO:INSTRUCTION:INSTRUCTION_AR:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(30833947015351122)
,p_plug_name=>'Revise Budget Track'
,p_parent_plug_id=>wwv_flow_api.id(49279463267009328)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>90
,p_plug_grid_column_span=>4
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_FBP_EMP	       = ''Y'' OR	',
':IS_BUDGET_PLANNING_YN = ''Y'' OR',
':IS_IFINANCE_ADMIN     = ''Y'''))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(30833897446351121)
,p_name=>'Revise Budget Track Report'
,p_parent_plug_id=>wwv_flow_api.id(30833947015351122)
,p_template=>wwv_flow_api.id(99757408152410744)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select rownum ID,',
'       CC_PLAN_ID,',
'       COMMENTS,',
'       CREATED_BY,',
'       CREATED_ON,',
'       TEAM_CHANGE',
'  from BUDGET_PROPOSAL_COST_CENTERS_PLAN_REVISE_TRACKING',
'where cc_plan_id = :P97_CC_PLAN_ID'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P97_CC_PLAN_ID'
,p_query_row_template=>wwv_flow_api.id(99783722631410762)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(30833408697351116)
,p_query_column_id=>1
,p_column_alias=>'ID'
,p_column_display_sequence=>1
,p_column_heading=>'No'
,p_use_as_row_header=>'N'
,p_column_alignment=>'CENTER'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(30833330875351115)
,p_query_column_id=>2
,p_column_alias=>'CC_PLAN_ID'
,p_column_display_sequence=>2
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(30833229867351114)
,p_query_column_id=>3
,p_column_alias=>'COMMENTS'
,p_column_display_sequence=>3
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(30833048480351113)
,p_query_column_id=>4
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>4
,p_column_heading=>'Revised By'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_display_as=>'TEXT_FROM_LOV_ESC'
,p_named_lov=>wwv_flow_api.id(48836004784526)
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(30832950936351112)
,p_query_column_id=>5
,p_column_alias=>'CREATED_ON'
,p_column_display_sequence=>5
,p_column_heading=>'Revised On'
,p_use_as_row_header=>'N'
,p_column_format=>'DD-MON-YYYY HH:MIPM'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(30831323868351095)
,p_query_column_id=>6
,p_column_alias=>'TEAM_CHANGE'
,p_column_display_sequence=>6
,p_column_heading=>'Team Change'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(117344195474990233)
,p_plug_name=>'Opex (Chapter 2)'
,p_parent_plug_id=>wwv_flow_api.id(49279463267009328)
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(41550485939522308)
,p_plug_name=>'Opex (Chapter 2)- Baseline'
,p_parent_plug_id=>wwv_flow_api.id(117344195474990233)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(44490233953903313)
,p_plug_name=>'Opex Baseline Exceed'
,p_parent_plug_id=>wwv_flow_api.id(41550485939522308)
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--danger:t-Alert--removeHeading'
,p_plug_template=>wwv_flow_api.id(99726350799410732)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p><span style="color: #c0392b;"><em><strong><span style="font-size: 18px;"><span style="font-family: Courier New,Courier,monospace;">you Exceed Opex Baseline ceiling</span></span></strong></em></span></p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'to_number(:P97_ALL_BASELINE_CHAPTER2_H) > to_number(:P97_CHAPTER2_H)'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(41550407141522307)
,p_plug_name=>'Opex (Chapter 2)- Additional'
,p_parent_plug_id=>wwv_flow_api.id(117344195474990233)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(41550325214522306)
,p_plug_name=>'Opex Additional Exceed'
,p_parent_plug_id=>wwv_flow_api.id(41550407141522307)
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--danger:t-Alert--removeHeading'
,p_plug_template=>wwv_flow_api.id(99726350799410732)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p><span style="color: #c0392b;"><em><strong><span style="font-size: 18px;"><span style="font-family: Courier New,Courier,monospace;">you Exceed Opex Additional ceiling</span></span></strong></em></span></p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'to_number(:P97_ALL_ADDITIONAL_CHAPTER2_H) > to_number(:P97_CHAPTER2_ADD_H)'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(41019030852580827)
,p_plug_name=>'Ceiling Changes Track'
,p_parent_plug_id=>wwv_flow_api.id(117344195474990233)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':PERSON_ID = 680461 or :IS_BUDGET_PLANNING_YN = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
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
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(41018882029580826)
,p_name=>'Ceiling Changes Track'
,p_parent_plug_id=>wwv_flow_api.id(41019030852580827)
,p_template=>wwv_flow_api.id(99757408152410744)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       CC_PLAN_ID,',
'       CHANGE_DIRECTION,',
'       BASELINE_TYPE,',
'       AMOUNT,',
'       COMMENTS,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       CHAPTER',
'  from BUDGET_PROPOSAL_COST_CENTERS_PLAN_CEILING_CHANGES',
'  where cc_plan_id = :P97_ID',
'  and chapter = 134;'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'ID DESC'
,p_query_row_template=>wwv_flow_api.id(99783722631410762)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(41018831478580825)
,p_query_column_id=>1
,p_column_alias=>'ID'
,p_column_display_sequence=>1
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(41018671051580824)
,p_query_column_id=>2
,p_column_alias=>'CC_PLAN_ID'
,p_column_display_sequence=>2
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(41018547407580823)
,p_query_column_id=>3
,p_column_alias=>'CHANGE_DIRECTION'
,p_column_display_sequence=>3
,p_column_heading=>'Change Direction'
,p_use_as_row_header=>'N'
,p_column_alignment=>'CENTER'
,p_disable_sort_column=>'N'
,p_display_as=>'TEXT_FROM_LOV_ESC'
,p_named_lov=>wwv_flow_api.id(43753430507745382)
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(41018519530580822)
,p_query_column_id=>4
,p_column_alias=>'BASELINE_TYPE'
,p_column_display_sequence=>4
,p_column_heading=>'Baseline Type'
,p_use_as_row_header=>'N'
,p_column_alignment=>'CENTER'
,p_disable_sort_column=>'N'
,p_display_as=>'TEXT_FROM_LOV_ESC'
,p_inline_lov=>'STATIC:Additional Ceiling;A,Baseline Ceiling;B'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(41018410667580821)
,p_query_column_id=>5
,p_column_alias=>'AMOUNT'
,p_column_display_sequence=>5
,p_column_heading=>'Amount'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_column_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(41018328218580820)
,p_query_column_id=>6
,p_column_alias=>'COMMENTS'
,p_column_display_sequence=>6
,p_column_heading=>'Comment'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(41018224268580819)
,p_query_column_id=>7
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>7
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(41018096808580818)
,p_query_column_id=>8
,p_column_alias=>'CREATED_ON'
,p_column_display_sequence=>8
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(41017940220580817)
,p_query_column_id=>9
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>9
,p_column_heading=>'Updated By'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_display_as=>'TEXT_FROM_LOV_ESC'
,p_named_lov=>wwv_flow_api.id(48836004784526)
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(41017867162580816)
,p_query_column_id=>10
,p_column_alias=>'UPDATED_ON'
,p_column_display_sequence=>10
,p_column_heading=>'Updated On'
,p_use_as_row_header=>'N'
,p_column_format=>'DD-MON-YYYY HH:MIPM'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(41017824644580815)
,p_query_column_id=>11
,p_column_alias=>'CHAPTER'
,p_column_display_sequence=>11
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(30832101912351103)
,p_plug_name=>'Opex(Chapter 2) -Revised'
,p_parent_plug_id=>wwv_flow_api.id(117344195474990233)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_FBP_EMP	       = ''Y'' OR	',
':IS_BUDGET_PLANNING_YN = ''Y'' OR',
':IS_IFINANCE_ADMIN     = ''Y'''))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(117346109224992510)
,p_plug_name=>'Capex (Chapter 3)'
,p_parent_plug_id=>wwv_flow_api.id(49279463267009328)
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>50
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(41550184814522305)
,p_plug_name=>'Capex (Chapter 3) - Baseline'
,p_parent_plug_id=>wwv_flow_api.id(117346109224992510)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(44489934975903310)
,p_plug_name=>'Capex Baseline Exceed'
,p_parent_plug_id=>wwv_flow_api.id(41550184814522305)
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--danger:t-Alert--removeHeading'
,p_plug_template=>wwv_flow_api.id(99726350799410732)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p><span style="color: #c0392b;"><em><strong><span style="font-size: 18px;"><span style="font-family: Courier New,Courier,monospace;">you exceed The Baseline Capex ceiling</span></span></strong></em></span></p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'to_number(:P97_ALL_BASELINE_CHAPTER3_H) > to_number(:P97_CHAPTER3_H)'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(41550114266522304)
,p_plug_name=>'Capex (Chapter 3) - Additional'
,p_parent_plug_id=>wwv_flow_api.id(117346109224992510)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(41549967643522303)
,p_plug_name=>'Capex Additional Exceed'
,p_parent_plug_id=>wwv_flow_api.id(41550114266522304)
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--danger:t-Alert--removeHeading'
,p_plug_template=>wwv_flow_api.id(99726350799410732)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p><span style="color: #c0392b;"><em><strong><span style="font-size: 18px;"><span style="font-family: Courier New,Courier,monospace;">you exceed the Additional Capex ceiling</span></span></strong></em></span></p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'to_number(:P97_ALL_ADDITIONAL_CHAPTER3_H) > to_number(:P97_CHAPTER3_ADD_H)'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(41019098749580828)
,p_plug_name=>'Ceiling Changes Track'
,p_parent_plug_id=>wwv_flow_api.id(117346109224992510)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':PERSON_ID = 680461 or :IS_BUDGET_PLANNING_YN = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(41548789955522291)
,p_name=>'Ceiling Changes Track'
,p_parent_plug_id=>wwv_flow_api.id(41019098749580828)
,p_template=>wwv_flow_api.id(99757408152410744)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       CC_PLAN_ID,',
'       CHANGE_DIRECTION,',
'       BASELINE_TYPE,',
'       AMOUNT,',
'       COMMENTS,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       CHAPTER',
'  from BUDGET_PROPOSAL_COST_CENTERS_PLAN_CEILING_CHANGES',
'  where cc_plan_id = :P97_ID',
'  and chapter = 135;'))
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(99783722631410762)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(41548655555522290)
,p_query_column_id=>1
,p_column_alias=>'ID'
,p_column_display_sequence=>1
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(41548591724522289)
,p_query_column_id=>2
,p_column_alias=>'CC_PLAN_ID'
,p_column_display_sequence=>2
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(41548507553522288)
,p_query_column_id=>3
,p_column_alias=>'CHANGE_DIRECTION'
,p_column_display_sequence=>3
,p_column_heading=>'Change Direction'
,p_use_as_row_header=>'N'
,p_column_alignment=>'CENTER'
,p_disable_sort_column=>'N'
,p_display_as=>'TEXT_FROM_LOV_ESC'
,p_named_lov=>wwv_flow_api.id(43753430507745382)
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(41548405409522287)
,p_query_column_id=>4
,p_column_alias=>'BASELINE_TYPE'
,p_column_display_sequence=>4
,p_column_heading=>'Baseline Type'
,p_use_as_row_header=>'N'
,p_column_alignment=>'CENTER'
,p_disable_sort_column=>'N'
,p_display_as=>'TEXT_FROM_LOV_ESC'
,p_inline_lov=>'STATIC:Additional Ceiling;A,Baseline Ceiling;B'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(41548267237522286)
,p_query_column_id=>5
,p_column_alias=>'AMOUNT'
,p_column_display_sequence=>5
,p_column_heading=>'Amount'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_column_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(41548156199522285)
,p_query_column_id=>6
,p_column_alias=>'COMMENTS'
,p_column_display_sequence=>6
,p_column_heading=>'Comment'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(41548052965522284)
,p_query_column_id=>7
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>7
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(41547981952522283)
,p_query_column_id=>8
,p_column_alias=>'CREATED_ON'
,p_column_display_sequence=>8
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(41547900752522282)
,p_query_column_id=>9
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>9
,p_column_heading=>'Updated By'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_display_as=>'TEXT_FROM_LOV_ESC'
,p_named_lov=>wwv_flow_api.id(48836004784526)
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(41019354620580831)
,p_query_column_id=>10
,p_column_alias=>'UPDATED_ON'
,p_column_display_sequence=>10
,p_column_heading=>'Updated On'
,p_use_as_row_header=>'N'
,p_column_format=>'DD-MON-YYYY HH:MIPM'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(41019245581580830)
,p_query_column_id=>11
,p_column_alias=>'CHAPTER'
,p_column_display_sequence=>11
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(30831970796351102)
,p_plug_name=>'Capex (Chapter 3) - Revised Budget'
,p_parent_plug_id=>wwv_flow_api.id(117346109224992510)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_FBP_EMP	       = ''Y'' OR	',
':IS_BUDGET_PLANNING_YN = ''Y'' OR',
':IS_IFINANCE_ADMIN     = ''Y'''))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(47564889524766394)
,p_plug_name=>'Documents'
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(47564758292766393)
,p_plug_name=>'Documents report'
,p_parent_plug_id=>wwv_flow_api.id(47564889524766394)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ROW_VERSION_NUMBER,',
'       PLAN_ID,',
'       SECTOR_ID,',
'       COST_CENTER,',
'       project_number,',
'       task_number,',
'       FILENAME,',
'       FILE_MIMETYPE,',
'       FILE_CHARSET,',
'       FILE_BLOB,',
'       FILE_COMMENTS,',
'       TAGS,',
'       CREATED,',
'       CREATED_BY,',
'       UPDATED,',
'       UPDATED_BY,',
'       sys.dbms_lob.getlength(file_blob) as file_size,',
'    sys.dbms_lob.getlength(file_blob) as download',
'  from budget_proposal_plans_documents',
'  where PLAN_ID = :P97_PLAN_ID',
'  and COST_CENTER = :P97_COST_CENTER',
'  order by UPDATED desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Documents report'
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
 p_id=>wwv_flow_api.id(47564719858766392)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>165719312530418240
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47564558836766391)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47564437741766390)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Document Version'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47564367129766389)
,p_db_column_name=>'PLAN_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Plan'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47564260252766388)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47564199344766387)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47564061865766386)
,p_db_column_name=>'FILENAME'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File'
,p_column_link=>'f?p=&APP_ID.:102:&SESSION.::&DEBUG.::P102_ID,P102_STATUS:#ID#,&P97_STATUS.'
,p_column_linktext=>'#FILENAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47563686368766382)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47454080513466531)
,p_db_column_name=>'TAGS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47453964544466530)
,p_db_column_name=>'CREATED'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47453867789466529)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47453802564466528)
,p_db_column_name=>'UPDATED'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47453660881466527)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47453550518466526)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47563986672766385)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>170
,p_column_identifier=>'G'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47563928419766384)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>180
,p_column_identifier=>'H'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47563812837766383)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>190
,p_column_identifier=>'I'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47453484221466525)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>200
,p_column_identifier=>'Q'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DOWNLOAD:BUDGET_PROPOSAL_PLANS_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47361103406656814)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>210
,p_column_identifier=>'R'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47360947659656813)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>220
,p_column_identifier=>'S'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(47441957530438800)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1658421'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:PROJECT_NUMBER:TASK_NUMBER:FILE_COMMENTS:ROW_VERSION_NUMBER:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(47417701907149787)
,p_plug_name=>'Approval History'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent13:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>70
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P97_STATUS not in (''Draft'' , ''Available'')'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(47417582718149786)
,p_plug_name=>'Approval History Report'
,p_parent_plug_id=>wwv_flow_api.id(47417701907149787)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    h.id,',
'    h.request_id,',
'    h.step_no,',
'    h.person_id,',
'    h.role_id,',
'    h.role_desc,',
'    h.action_required,',
'    h.recevied_date,',
'    h.status,',
'    h.action_date,',
'    h.comments,',
'    h.approval_type,',
'    case h.status',
'        When ''Rejected'' Then ''u-danger-text''',
'        when ''Approved'' Then ''u-success''',
'        When ''Accepted'' Then ''u-success''',
'    End status_class,',
'       e.full_name_en,',
'    case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'       when 0  THEN',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'        else  ',
'            ',
'         ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'       end Photo',
'FROM',
'    budget_proposal_cost_centers_plans_approval_history h, dct_employees_list2  e',
'where h.person_id = e.person_id (+)',
'and h.request_id = nvl(:P97_ID, :P97_CC_PLAN_ID)',
'and h.status != ''Bateen''',
'order by h.STEP_NO , h.ID desc',
';'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P97_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Approval History Report'
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
 p_id=>wwv_flow_api.id(47417457772149785)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>165866574617034847
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47417363477149784)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47417312305149783)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47417205123149782)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47362806045656831)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47362727400656830)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Role '
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(64238386933166115)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47362608702656829)
,p_db_column_name=>'ROLE_DESC'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Role Desc'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47362500393656828)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47362354772656827)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47362273903656826)
,p_db_column_name=>'STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47362222131656825)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47362122379656824)
,p_db_column_name=>'COMMENTS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47361995088656823)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47361853236656822)
,p_db_column_name=>'STATUS_CLASS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Status Class'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47361791285656821)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47361724947656820)
,p_db_column_name=>'PHOTO'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(47349474157628418)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1659346'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:PHOTO:FULL_NAME_EN:ROLE_ID:ACTION_REQUIRED:RECEVIED_DATE:STATUS:ACTION_DATE:COMMENTS:'
,p_sort_column_1=>'STEP_NO'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'0'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(41032246811244036)
,p_report_id=>wwv_flow_api.id(47349474157628418)
,p_name=>'Pending'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Pending'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Pending''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#D0F1CC'
,p_row_font_color=>'#000000'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(43740808284643628)
,p_plug_name=>'GL Proposal Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       PLAN_ID,',
'       SECTOR_ID,',
'',
'        GL_UTIL.chapter_id_by_account(GL_ACCOUNT,BUDGET_GROUB_CODE ) Chapter,',
'       ENTITY_CODE,',
'       COST_CENTER,',
'       GL_UTIL.COST_CENTER_NAME(COST_CENTER)        COST_CENTER_NAME,',
'       BUDGET_GROUB_CODE,',
'       GL_ACCOUNT,',
'       GL_UTIL.ACCOUNT_NAME(GL_ACCOUNT)            GL_ACCOUNT_NAME,',
'       ACTIVITY,',
'       FUTURE1,',
'       GL_UTIL.FUTURE1_NAME(FUTURE1)            FUTURE1_NAME,',
'       FUTURE2,',
'       GL_UTIL.FUTURE2_NAME(FUTURE2)            FUTURE2_NAME,',
'--       OBJECTIVE_ID,',
'--       PROGRAM_ID,',
'--       INITIATIVE_ID,',
'       PROJECT_DESCRIPTION,',
'       OUTCOME,',
'       START_DATE,',
'       END_DATE,',
'       BP_EXPENSE_CATEGORY_ID,',
'       BP_EXPENSE_CLASS_ID,',
'       BP_COMMITMENT_TYPE_ID,',
'       BP_CLASSIFICATIONS_ID,',
'       JUSTIFICATIONS,',
'       CALCULATION_BASIS,',
'       COMMENTS,',
'       STATUS,',
'       PLAN_VERSION,',
'       BUDGET_Y1,',
'       BUDGET_Y2,',
'       BUDGET_Y3,',
'       BUDGET_Y4,',
'       BUDGET_Y5,',
'       ACTUAL_Y1,',
'       ACTUAL_Y2,',
'       ACTUAL_Y3,',
'       ACTUAL_Y4,',
'       ACTUAL_Y5,',
'       JAN,',
'       FEB,',
'       MAR,',
'       APR,',
'       MAY,',
'       JUN,',
'       JUL,',
'       AUG,',
'       SEP,',
'       OCT,',
'       NOV,',
'       DEC,',
'       SUBMITTED_ON,',
'       SUBMITTED_BY,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       PROPOSAL_YEAR,',
'       PRIORITY,',
'       DELIVERABLE_1,',
'       TRAGET_1,',
'       DELIVERABLE_2,',
'       TARGET_2,',
'       DELIVERABLE_3,',
'       TRAGET_3',
'  from BUDGET_PROPOSAL_PROJECTS_PLANS',
'  where plan_id = :P97_PLAN_ID',
'  and cost_center = :P97_COST_CENTER ',
'  and future1 = nvl(:P97_FUTURE1 , future1)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P97_PLAN_ID,P97_COST_CENTER,P97_FUTURE1'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P97_COST_CENTER  in (''4517010'' , ''4517100'', ''4517150'',''4517200'', ''4517250'')'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'GL Proposal Details'
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
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(43740696749643627)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>169543335639541005
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43740590980643626)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43740434619643625)
,p_db_column_name=>'PLAN_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Plan Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43740402639643624)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Sector Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43740202704643622)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43740080276643621)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43739975857643620)
,p_db_column_name=>'BUDGET_GROUB_CODE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Budget Groub Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43739878467643619)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'GL Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43739808383643618)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43739659160643617)
,p_db_column_name=>'FUTURE1'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43739605379643616)
,p_db_column_name=>'FUTURE2'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43739506133643615)
,p_db_column_name=>'PROJECT_DESCRIPTION'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Project Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43739432369643614)
,p_db_column_name=>'OUTCOME'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Outcome'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43739248858643613)
,p_db_column_name=>'START_DATE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43739198099643612)
,p_db_column_name=>'END_DATE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43739109528643611)
,p_db_column_name=>'BP_EXPENSE_CATEGORY_ID'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Expense Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(54437167442944357)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43738954745643610)
,p_db_column_name=>'BP_EXPENSE_CLASS_ID'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Expense Class'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(54436748529917930)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43738853894643609)
,p_db_column_name=>'BP_COMMITMENT_TYPE_ID'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Commitment Type'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(54433518523880036)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43738746200643608)
,p_db_column_name=>'BP_CLASSIFICATIONS_ID'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Classifications'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(54432856102868605)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43738682131643607)
,p_db_column_name=>'JUSTIFICATIONS'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Justifications'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43738572035643606)
,p_db_column_name=>'CALCULATION_BASIS'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Calculation Basis'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43738513083643605)
,p_db_column_name=>'COMMENTS'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43738376484643604)
,p_db_column_name=>'STATUS'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43738282993643603)
,p_db_column_name=>'PLAN_VERSION'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Plan Version'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43738206285643602)
,p_db_column_name=>'BUDGET_Y1'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Budget Y1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43738065185643601)
,p_db_column_name=>'BUDGET_Y2'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Budget Y2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43737932824643600)
,p_db_column_name=>'BUDGET_Y3'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Budget Y3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43737859720643599)
,p_db_column_name=>'BUDGET_Y4'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Budget Y4'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43737745061643598)
,p_db_column_name=>'BUDGET_Y5'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Budget Y5'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43737646745643597)
,p_db_column_name=>'ACTUAL_Y1'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Actual Y1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43737628387643596)
,p_db_column_name=>'ACTUAL_Y2'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Actual Y2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43737433995643595)
,p_db_column_name=>'ACTUAL_Y3'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Actual Y3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43737378972643594)
,p_db_column_name=>'ACTUAL_Y4'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Actual Y4'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43737313548643593)
,p_db_column_name=>'ACTUAL_Y5'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Actual Y5'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43737137369643592)
,p_db_column_name=>'JAN'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'01-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43737043750643591)
,p_db_column_name=>'FEB'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'02-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43736937926643590)
,p_db_column_name=>'MAR'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'03-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43736858767643589)
,p_db_column_name=>'APR'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'04-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43736826805643588)
,p_db_column_name=>'MAY'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'05-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43736659848643587)
,p_db_column_name=>'JUN'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'06-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43736558125643586)
,p_db_column_name=>'JUL'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'07-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43736491045643585)
,p_db_column_name=>'AUG'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'08-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43736377690643584)
,p_db_column_name=>'SEP'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'09-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43736296770643583)
,p_db_column_name=>'OCT'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'10-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43736153501643582)
,p_db_column_name=>'NOV'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'11-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42352550300605131)
,p_db_column_name=>'DEC'
,p_display_order=>460
,p_column_identifier=>'AT'
,p_column_label=>'12-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42352511988605130)
,p_db_column_name=>'SUBMITTED_ON'
,p_display_order=>470
,p_column_identifier=>'AU'
,p_column_label=>'Submitted On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42352335917605129)
,p_db_column_name=>'SUBMITTED_BY'
,p_display_order=>480
,p_column_identifier=>'AV'
,p_column_label=>'Submitted By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42352316086605128)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>490
,p_column_identifier=>'AW'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42352167028605127)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>500
,p_column_identifier=>'AX'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42352041595605126)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>510
,p_column_identifier=>'AY'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42351965837605125)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>520
,p_column_identifier=>'AZ'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42351869524605124)
,p_db_column_name=>'PROPOSAL_YEAR'
,p_display_order=>530
,p_column_identifier=>'BA'
,p_column_label=>'Proposal Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42351791723605123)
,p_db_column_name=>'PRIORITY'
,p_display_order=>540
,p_column_identifier=>'BB'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42351641315605122)
,p_db_column_name=>'DELIVERABLE_1'
,p_display_order=>550
,p_column_identifier=>'BC'
,p_column_label=>'Deliverable 1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42351533290605121)
,p_db_column_name=>'TRAGET_1'
,p_display_order=>560
,p_column_identifier=>'BD'
,p_column_label=>'Traget 1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42351442136605120)
,p_db_column_name=>'DELIVERABLE_2'
,p_display_order=>570
,p_column_identifier=>'BE'
,p_column_label=>'Deliverable 2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42351349848605119)
,p_db_column_name=>'TARGET_2'
,p_display_order=>580
,p_column_identifier=>'BF'
,p_column_label=>'Target 2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42351301500605118)
,p_db_column_name=>'DELIVERABLE_3'
,p_display_order=>590
,p_column_identifier=>'BG'
,p_column_label=>'Deliverable 3'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42351230533605117)
,p_db_column_name=>'TRAGET_3'
,p_display_order=>600
,p_column_identifier=>'BH'
,p_column_label=>'Traget 3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42351050275605116)
,p_db_column_name=>'CHAPTER'
,p_display_order=>610
,p_column_identifier=>'BI'
,p_column_label=>'Chapter'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(71071651503392969)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42350943445605115)
,p_db_column_name=>'COST_CENTER_NAME'
,p_display_order=>620
,p_column_identifier=>'BJ'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42350904681605114)
,p_db_column_name=>'GL_ACCOUNT_NAME'
,p_display_order=>630
,p_column_identifier=>'BK'
,p_column_label=>'Gl Account Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42350765974605113)
,p_db_column_name=>'FUTURE1_NAME'
,p_display_order=>640
,p_column_identifier=>'BL'
,p_column_label=>'Future1 Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(42350715631605112)
,p_db_column_name=>'FUTURE2_NAME'
,p_display_order=>650
,p_column_identifier=>'BM'
,p_column_label=>'Future2 Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(42317611701055913)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1709665'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'GL_ACCOUNT:GL_ACCOUNT_NAME:FUTURE1:FUTURE1_NAME:FUTURE2:CHAPTER:PROJECT_DESCRIPTION:OUTCOME:START_DATE:END_DATE:BP_EXPENSE_CATEGORY_ID:BP_EXPENSE_CLASS_ID:BP_COMMITMENT_TYPE_ID:BP_CLASSIFICATIONS_ID:JUSTIFICATIONS:CALCULATION_BASIS:COMMENTS:BUDGET_Y1'
||':BUDGET_Y2:BUDGET_Y3:BUDGET_Y4:BUDGET_Y5:ACTUAL_Y1:ACTUAL_Y2:ACTUAL_Y3:ACTUAL_Y4:ACTUAL_Y5:JAN:FEB:MAR:APR:MAY:JUN:JUL:AUG:SEP:OCT:NOV:DEC:PRIORITY:DELIVERABLE_1:TRAGET_1:DELIVERABLE_2:TARGET_2:DELIVERABLE_3:TRAGET_3:STATUS:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(38617437412086583)
,p_plug_name=>'Collaborations'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(38617704424086585)
,p_plug_name=>'Collaborations'
,p_parent_plug_id=>wwv_flow_api.id(38617437412086583)
,p_icon_css_classes=>'fa-commenting-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(136184796545776356)
,p_name=>'Collaborations Report'
,p_parent_plug_id=>wwv_flow_api.id(38617704424086585)
,p_template=>wwv_flow_api.id(99730028608410735)
,p_display_sequence=>90
,p_region_template_options=>'#DEFAULT#:t-Form--slimPadding:t-Form--large'
,p_component_template_options=>'#DEFAULT#:t-Comments--chat'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select   CASE',
'            WHEN dbms_lob.getlength(photo_blob) > 0 THEN',
'                ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(user_name)',
'            ELSE',
'                 ''#WORKSPACE_IMAGES#no-photo(1).png''',
'       ',
'       END                                      user_icon,',
'       updated_date                             comment_date,',
'       full_name_en                             user_name,',
'       comment_text                             comment_text,',
'        null                                    comment_modifiers,',
'        ''u-color-''||ora_hash(user_name,45)      icon_modifier,',
'        ACTION                                  actions,',
'        ''''                                      attribute_1,',
'        ''''                                      attribute_2,',
'        ''''                                      attribute_3,',
'        sys.dbms_lob.getlength(file_blob)       attribute_4,',
'        comment_id,',
'        filename,',
'        comment_to_person_id                    Comment_to',
'',
'',
'',
'from(       ',
'SELECT',
'    c.comment_id,',
'    c.PLAN_ID,',
'    c.SECTOR_PLAN_ID,',
'    c.CC_PLAN_ID,',
'    c.comment_text,',
'    c.created_by,',
'    c.updated_by,',
'    c.creation_date,',
'    c.updated_date,',
'    c.action        action,',
'    e.full_name_en,',
'    e.user_name,',
'    e.photo_blob,',
'    c.filename,',
'    c.file_blob,',
'    c.comment_to_person_id',
'FROM BUDGET_PROPOSAL_PLAN_COMMENTS c , employees_v e',
'where c.updated_by = e.person_id',
'and c.plan_id =  :P97_PLAN_ID',
'--and c.SECTOR_PLAN_ID = :P97_SECTOR_ID',
'and c.CC_PLAN_ID = :P97_CC_PLAN_ID)',
'order by updated_date  desc'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P97_PROJECT_NUMBER,P97_TASK_NUMBER,P97_CC_PLAN_ID,P97_PLAN_ID'
,p_query_row_template=>wwv_flow_api.id(99786373050410764)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(38476776473321642)
,p_query_column_id=>1
,p_column_alias=>'USER_ICON'
,p_column_display_sequence=>1
,p_column_heading=>'User Icon'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<img src="#USER_ICON#" alt="Image Not Found" height="40" width="40">'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(38475562796321637)
,p_query_column_id=>2
,p_column_alias=>'COMMENT_DATE'
,p_column_display_sequence=>2
,p_column_heading=>'Comment Date'
,p_use_as_row_header=>'N'
,p_column_format=>'DD-MON-YYYY HH:MIPM'
,p_column_html_expression=>'<br>#COMMENT_DATE#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(38473210184321635)
,p_query_column_id=>3
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>3
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(38475959209321637)
,p_query_column_id=>4
,p_column_alias=>'COMMENT_TEXT'
,p_column_display_sequence=>4
,p_column_heading=>'Comment Text'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:116:&SESSION.::&DEBUG.::P116_COMMENT_ID:#COMMENT_ID#'
,p_column_linktext=>'#COMMENT_TEXT#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(38472821659321635)
,p_query_column_id=>5
,p_column_alias=>'COMMENT_MODIFIERS'
,p_column_display_sequence=>5
,p_column_heading=>'Comment Modifiers'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(38472371951321635)
,p_query_column_id=>6
,p_column_alias=>'ICON_MODIFIER'
,p_column_display_sequence=>6
,p_column_heading=>'Icon Modifier'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(38475188727321636)
,p_query_column_id=>7
,p_column_alias=>'ACTIONS'
,p_column_display_sequence=>7
,p_column_heading=>'Actions'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(38474773283321636)
,p_query_column_id=>8
,p_column_alias=>'ATTRIBUTE_1'
,p_column_display_sequence=>8
,p_column_heading=>'Attribute 1'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(38474398646321636)
,p_query_column_id=>9
,p_column_alias=>'ATTRIBUTE_2'
,p_column_display_sequence=>9
,p_column_heading=>'Attribute 2'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(38474010981321636)
,p_query_column_id=>10
,p_column_alias=>'ATTRIBUTE_3'
,p_column_display_sequence=>10
,p_column_heading=>'Attribute 3'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(38473537483321635)
,p_query_column_id=>11
,p_column_alias=>'ATTRIBUTE_4'
,p_column_display_sequence=>11
,p_column_heading=>'Attribute 4'
,p_use_as_row_header=>'N'
,p_column_format=>'DOWNLOAD:BUDGET_PROPOSAL_PLAN_COMMENTS:FILE_BLOB:COMMENT_ID::FILE_MIMETYPE:FILENAME:UPDATED_DATE:FILE_CHARSET:attachment:Document #FILENAME#:'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(38476363362321637)
,p_query_column_id=>12
,p_column_alias=>'COMMENT_ID'
,p_column_display_sequence=>14
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(38471975550321635)
,p_query_column_id=>13
,p_column_alias=>'FILENAME'
,p_column_display_sequence=>12
,p_column_heading=>'Filename'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(38471613278321634)
,p_query_column_id=>14
,p_column_alias=>'COMMENT_TO'
,p_column_display_sequence=>13
,p_column_heading=>'Comment To'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(47701041271036921)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(49346793552265038)
,p_button_name=>'Submit'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Submit For Approval'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>':P97_STATUS in (''Available'' , ''Return'' , ''Withdraw'' , ''Rejected'' )'
,p_button_condition_type=>'PLSQL_EXPRESSION'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(47453371938466524)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(47564889524766394)
,p_button_name=>'New_document'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'New Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:102:&SESSION.::&DEBUG.:102:P102_PLAN_ID,P102_STATUS,P102_COST_CENTER,P102_SECTOR_ID:&P97_PLAN_ID.,&P97_STATUS.,&P97_COST_CENTER.,&P97_SECTOR_ID.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(43954252342021098)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(117344195474990233)
,p_button_name=>'CHANGE_OPEX_BASELINE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Change Opex Baseline Ceiling'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:109:&SESSION.::&DEBUG.:109:P109_CC_PLAN_ID,P109_COST_CENTER,P109_PLAN_ID,P109_SECTOR_ID,P109_CHAPTER,P109_CEILING_DISPLAY,P109_CEILING_TYPE:&P97_ID.,&P97_COST_CENTER.,&P97_PLAN_ID.,&P97_SECTOR_ID.,134,Change Baseline Ceiling,B'
,p_button_condition=>':PERSON_ID = 680461 or :IS_BUDGET_PLANNING_YN = ''Y'''
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-bold'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(43952941852021085)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(117346109224992510)
,p_button_name=>'CHANGE_CAPEX_BASELINE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Change Capex Baseline Ceiling'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:109:&SESSION.::&DEBUG.:109:P109_CC_PLAN_ID,P109_COST_CENTER,P109_PLAN_ID,P109_SECTOR_ID,P109_CHAPTER,P109_CEILING_DISPLAY,P109_CEILING_TYPE:&P97_ID.,&P97_COST_CENTER.,&P97_PLAN_ID.,&P97_SECTOR_ID.,135,Change Capex Baseline Ceiling,B'
,p_button_condition=>':PERSON_ID = 680461 or :IS_BUDGET_PLANNING_YN = ''Y'''
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-bold'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(42350276609605108)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(43740808284643628)
,p_button_name=>'Update_GL'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Update'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>':P97_STATUS in (''Returned'', ''Available'' , ''Draft'' ,''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(38617335376086582)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(38617704424086585)
,p_button_name=>'New_Comment'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'New Comment'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:116:&SESSION.::&DEBUG.:116:P116_PLAN_ID,P116_CC_PLAN_ID,P116_COST_CENTER:&P97_PLAN_ID.,&P97_CC_PLAN_ID.,&P97_COST_CENTER.'
,p_icon_css_classes=>'fa-commenting-o fa-anim-flash'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(41549312001522296)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(117344195474990233)
,p_button_name=>'CHANGE_OPEX_ADDITIONAL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--hoverIconSpin:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Change Opex Additional Ceiling'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:109:&SESSION.::&DEBUG.:109:P109_CEILING_DISPLAY,P109_CEILING_TYPE,P109_CC_PLAN_ID,P109_COST_CENTER,P109_PLAN_ID,P109_SECTOR_ID,P109_CHAPTER:Change Additional Ceiling,A,&P97_ID.,&P97_COST_CENTER.,&P97_PLAN_ID.,&P97_SECTOR_ID.,134'
,p_button_condition=>':PERSON_ID = 680461 or :IS_BUDGET_PLANNING_YN = ''Y'''
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-wrench'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(41549017106522293)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(117346109224992510)
,p_button_name=>'CHANGE_CAPEX_ADDITIONAL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--hoverIconSpin:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Change Capex Additional Ceiling'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:109:&SESSION.::&DEBUG.:109:P109_CC_PLAN_ID,P109_COST_CENTER,P109_PLAN_ID,P109_SECTOR_ID,P109_CHAPTER,P109_CEILING_DISPLAY,P109_CEILING_TYPE:&P97_ID.,&P97_COST_CENTER.,&P97_PLAN_ID.,&P97_SECTOR_ID.,135,Change Capex Additional Ceiling,A'
,p_button_condition=>':PERSON_ID = 680461 or :IS_BUDGET_PLANNING_YN = ''Y'''
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-wrench'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(37113396950435791)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(49346793552265038)
,p_button_name=>'download_zip'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Download Zip'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-file-archive-o'
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
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(48277304006525383)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(49346793552265038)
,p_button_name=>'Back'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(47359546628656799)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(49346793552265038)
,p_button_name=>'Withdraw'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Withdraw'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:111:&SESSION.::&DEBUG.:111:P111_REQUEST_ID,P111_ACTION:&P97_ID.,Withdraw'
,p_button_condition=>':P97_STATUS not in (''Draft'' , ''Return'', ''Available'' , ''Withdraw'' , ''Rejected'') and :P97_ID is not null and 1 = 2'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(45323360857071985)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(49378547048265057)
,p_button_name=>'Add'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--hoverIconPush:t-Button--gapRight'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:108:&SESSION.::&DEBUG.:108:P108_PLAN_ID,P108_COST_CENTER:&P97_PLAN_ID.,&P97_COST_CENTER.'
,p_button_condition=>'PERSON_ID'
,p_button_condition2=>'680461x'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(48941158924033309)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(49378547048265057)
,p_button_name=>'Update'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Update'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>':P97_STATUS in (''Return'', ''Available'' , ''Draft'' ,''Withdraw'' , ''Rejected'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(31480844751124097)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(49378547048265057)
,p_button_name=>'REVISE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Revise Budget'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:118:&SESSION.::&DEBUG.::P118_YEAR,P118_COST_CENTER,P118_PLAN_ID,P118_STATUS,P118_CC_PLAN_ID,P118_SECTOR_ID:&P97_YEAR.,&P97_COST_CENTER.,&P97_PLAN_ID.,&P97_STATUS.,&P97_ID.,&P97_SECTOR_ID.'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_FBP_EMP	       = ''Y'' OR	',
':IS_BUDGET_PLANNING_YN = ''Y'' OR',
':IS_IFINANCE_ADMIN     = ''Y'''))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(49345591892265037)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(49378547048265057)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:98:&SESSION.::&DEBUG.:98'
,p_button_condition_type=>'NEVER'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(48941094144033308)
,p_branch_name=>'Go to Update 101'
,p_branch_action=>'f?p=&APP_ID.:101:&SESSION.::&DEBUG.::P101_YEAR,P101_COST_CENTER,P101_PLAN_ID,P101_COST_CENTER_NAME,P101_STATUS,P101_CC_PLAN_ID,P101_SECTOR_ID:&P97_YEAR.,&P97_COST_CENTER.,&P97_PLAN_ID.,&P97_COST_CENTER_NAME.,&P97_STATUS.,&P97_ID.,&P97_SECTOR_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'REQUEST_IN_CONDITION'
,p_branch_condition=>'Update,Update_GL'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(47360423678656807)
,p_branch_name=>'Go To Submit 105'
,p_branch_action=>'f?p=&APP_ID.:105:&SESSION.::&DEBUG.::P105_CC_PLAN_ID,P105_COST_CENTER,P105_COST_CENTER_NAME,P105_PLAN_ID,P105_PLAN_NAME:&P97_ID.,&P97_COST_CENTER.,&P97_COST_CENTER_NAME.,&P97_PLAN_ID.,&P97_PLAN_NAME.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(47701041271036921)
,p_branch_sequence=>20
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(47701456969036925)
,p_branch_name=>'Back To 96 &PAGE_FROM.'
,p_branch_action=>'f?p=&APP_ID.:&P97_PAGE_FROM.:&SESSION.::&DEBUG.::P96_PLAN,P92_PLAN_ID,P92_SECTOR_ID,P92_ID,P92_PROPOSAL_YEAR:&P97_PLAN_ID.,&P97_PLAN_ID.,&P97_SECTOR_ID.,&P97_SECTOR_PLAN_ID.,&P97_YEAR.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(48277304006525383)
,p_branch_sequence=>30
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53929243669650290)
,p_name=>'P97_PAGE_FROM'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(49279463267009328)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49279363059009327)
,p_name=>'P97_PLAN_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(49279463267009328)
,p_display_as=>'NATIVE_HIDDEN'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49279109811009324)
,p_name=>'P97_YEAR'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(49279463267009328)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49278678765009320)
,p_name=>'P97_A1'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(49279463267009328)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49278547686009319)
,p_name=>'P97_A2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(49279463267009328)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49278502098009318)
,p_name=>'P97_A3'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(49279463267009328)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49278337532009317)
,p_name=>'P97_A4'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(49279463267009328)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49278272503009316)
,p_name=>'P97_A5'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(49279463267009328)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49278186234009315)
,p_name=>'P97_B1'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(49279463267009328)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49278103932009314)
,p_name=>'P97_B2'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(49279463267009328)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49277942475009313)
,p_name=>'P97_B3'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(49279463267009328)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49277914456009312)
,p_name=>'P97_B4'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(49279463267009328)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49277782985009311)
,p_name=>'P97_B5'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(49279463267009328)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49277720914009310)
,p_name=>'P97_B6'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(49279463267009328)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(48280285295525413)
,p_name=>'P97_COST_CENTER'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(49279463267009328)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(48277378335525384)
,p_name=>'P97_PLAN_NAME'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(49279463267009328)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(48277146936525382)
,p_name=>'P97_COST_CENTER_NAME'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(49279463267009328)
,p_prompt=>'Cost Center (Department)'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47702124537036931)
,p_name=>'P97_STATUS'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(49279463267009328)
,p_prompt=>'Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_css_classes=>'u-color-19-text'
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47660744544668999)
,p_name=>'P97_CHAPTER2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(41550485939522308)
,p_prompt=>'Baseline Ceiling'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'The Proposed budget ceiling as per previous budget year (with 8% reduction)'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47660379342668998)
,p_name=>'P97_ALL_ADDITIONAL_CHAPTER2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(41550407141522307)
,p_prompt=>'Additional Allocated'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47659992559668997)
,p_name=>'P97_CHAPTER2_H'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(41550485939522308)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47659579563668997)
,p_name=>'P97_ALL_CHAPTER2_H'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(41550407141522307)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47658908686666725)
,p_name=>'P97_CHAPTER3'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(41550184814522305)
,p_prompt=>'Baseline Ceiling'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47658483722666725)
,p_name=>'P97_ALL_BASELINE_CHAPTER3'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(41550184814522305)
,p_prompt=>'Baseline Allocated'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47658097372666724)
,p_name=>'P97_CHAPTER3_H'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(41550184814522305)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47657686320666724)
,p_name=>'P97_ALL_CHAPTER3_H'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(41550114266522304)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47565367113766399)
,p_name=>'P97_SECTOR_ID'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(49279463267009328)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47565216218766397)
,p_name=>'P97_COST_CENTER_INSTRUCTIONS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(47565328332766398)
,p_prompt=>'Instructions'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47565101843766396)
,p_name=>'P97_COMMENTS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(47565328332766398)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47361396670656817)
,p_name=>'P97_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(49279463267009328)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47244218142850629)
,p_name=>'P97_SECTOR_PLAN_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(49279463267009328)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(42350553495605111)
,p_name=>'P97_FUTURE1'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(43740808284643628)
,p_prompt=>'Filter By Future1'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct FUTURE1_DESCRIPTION || ',
'      '' (''                  ||',
'      FUTURE1               ||',
'      '')''       d',
'      , FUTURE1',
'from dct_gl_code_combinations_all',
'where cost_center_code = :P97_COST_CENTER',
'order by FUTURE1;'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(41552272748522326)
,p_name=>'P97_CHAPTER2_ADD_H'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(41550407141522307)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(41552139882522325)
,p_name=>'P97_CHAPTER2_ADD'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(41550407141522307)
,p_prompt=>'Additional Ceiling'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(41552113733522324)
,p_name=>'P97_CHAPTER3_ADD'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(41550114266522304)
,p_prompt=>'Additional Ceiling'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(41551953531522323)
,p_name=>'P97_CHAPTER3_ADD_H'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(41550114266522304)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(41551777948522321)
,p_name=>'P97_ALL_BASELINE_CHAPTER3_H'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(41550184814522305)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(41551674607522320)
,p_name=>'P97_ALL_ADDITIONAL_CHAPTER2_H'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(41550407141522307)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(41551564471522319)
,p_name=>'P97_ALL_ADDITIONAL_CHAPTER3_H'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(41550114266522304)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(41551464483522318)
,p_name=>'P97_ALL_BASELINE_CHAPTER2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(41550485939522308)
,p_prompt=>'Baseline Allocated'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(41550667683522310)
,p_name=>'P97_ALL_BASELINE_CHAPTER2_H'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(41550485939522308)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(41550571796522309)
,p_name=>'P97_ALL_ADDITIONAL_CHAPTER3'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(41550114266522304)
,p_prompt=>'Additional Allocated'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38670855384493982)
,p_name=>'P97_CC_PLAN_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(49279463267009328)
,p_display_as=>'NATIVE_HIDDEN'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30832345318351106)
,p_name=>'P97_CHAPTER2_REVISE_FBP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(30832101912351103)
,p_prompt=>'Revised By FBP '
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'The Proposed budget ceiling as per previous budget year (with 8% reduction)'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30832253314351105)
,p_name=>'P97_CHAPTER2_REVISE_FPR'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(30832101912351103)
,p_prompt=>'Revised By Budget Planning '
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'The Proposed budget ceiling as per previous budget year (with 8% reduction)'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30832147241351104)
,p_name=>'P97_CHAPTER3_REVISE_FBP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(30831970796351102)
,p_prompt=>'Revised By FBP '
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'The Proposed budget ceiling as per previous budget year (with 8% reduction)'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30831869992351101)
,p_name=>'P97_CHAPTER3_REVISE_FPR'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(30831970796351102)
,p_prompt=>'Revised By Budget Planning'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'The Proposed budget ceiling as per previous budget year (with 8% reduction)'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30536681486105726)
,p_name=>'P97_FBP_REVISE_STATUS'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(49279463267009328)
,p_prompt=>'Revise Status - FBP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_css_classes=>'u-color-19-text'
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30536552703105725)
,p_name=>'P97_FPR_REVISE_STATUS'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(49279463267009328)
,p_prompt=>'Revise Status - Budget Planning'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_css_classes=>'u-color-19-text'
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(47701837647036929)
,p_computation_sequence=>10
,p_computation_item=>'P97_COST_CENTER_NAME'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'PLSQL_EXPRESSION'
,p_computation=>'user_details.get_cost_center_name(:P97_COST_CENTER) '
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(47701009873036920)
,p_validation_name=>'Cost Center Submission Validation Process - CH2'
,p_validation_sequence=>10
,p_validation=>' BUDGET_PROPOSAL_PKG.CC_CHAPTER_CELING(:P97_PLAN_ID,:P97_COST_CENTER , 134 ) >= BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated(:P97_PLAN_ID,:P97_COST_CENTER , 134 )'
,p_validation_type=>'PLSQL_EXPRESSION'
,p_error_message=>'Total Allocated budget &P97_ALL_CHAPTER2. can not exceed the proposed budget &P97_CHAPTER2.'
,p_validation_condition_type=>'NEVER'
,p_associated_item=>wwv_flow_api.id(47660379342668998)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(41549872602522302)
,p_validation_name=>'Validate Opex Baseline Ceiling Process'
,p_validation_sequence=>20
,p_validation=>'to_number(:P97_ALL_BASELINE_CHAPTER2_H) <= to_number(:P97_CHAPTER2_H)'
,p_validation_type=>'PLSQL_EXPRESSION'
,p_error_message=>'Total Opex baseline allocated &P97_ALL_BASELINE_CHAPTER2. can not exceed Opex baseline ceiling &P97_CHAPTER2.'
,p_when_button_pressed=>wwv_flow_api.id(47701041271036921)
,p_associated_item=>wwv_flow_api.id(41551464483522318)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(41549831281522301)
,p_validation_name=>'Validate Opex Additional Ceiling Process'
,p_validation_sequence=>30
,p_validation=>'to_number(:P97_ALL_ADDITIONAL_CHAPTER2_H) <= to_number(:P97_CHAPTER2_ADD_H)'
,p_validation_type=>'PLSQL_EXPRESSION'
,p_error_message=>'Total Opex additional allocated &P97_ALL_ADDITIONAL_CHAPTER2. can not exceed Opex additional ceiling &P97_CHAPTER2_ADD.'
,p_when_button_pressed=>wwv_flow_api.id(47701041271036921)
,p_associated_item=>wwv_flow_api.id(47660379342668998)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(41549715995522300)
,p_validation_name=>'Validate Capex Baseline Ceiling Process'
,p_validation_sequence=>40
,p_validation=>'to_number(:P97_ALL_BASELINE_CHAPTER3_H) <= to_number(:P97_CHAPTER3_H)'
,p_validation_type=>'PLSQL_EXPRESSION'
,p_error_message=>'Total Capex baseline allocated &P97_ALL_BASELINE_CHAPTER3. can not exceed Capex baseline ceiling &P97_CHAPTER3.'
,p_when_button_pressed=>wwv_flow_api.id(47701041271036921)
,p_associated_item=>wwv_flow_api.id(47658483722666725)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(41549604613522299)
,p_validation_name=>'Validate Capex Additional Ceiling Process'
,p_validation_sequence=>50
,p_validation=>'to_number(:P97_ALL_ADDITIONAL_CHAPTER3_H) <= to_number(:P97_CHAPTER3_ADD_H)'
,p_validation_type=>'PLSQL_EXPRESSION'
,p_error_message=>'Total Capex additional allocated &P97_ALL_ADDITIONAL_CHAPTER3. can not exceed Capex additional ceiling &P97_CHAPTER3_ADD.'
,p_when_button_pressed=>wwv_flow_api.id(47701041271036921)
,p_associated_item=>wwv_flow_api.id(41550571796522309)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(47700860505036919)
,p_validation_name=>'Cost Center Submission Validation Process - CH3'
,p_validation_sequence=>60
,p_validation=>' BUDGET_PROPOSAL_PKG.CC_CHAPTER_CELING(:P97_PLAN_ID,:P97_COST_CENTER , 135 ) >= BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated(:P97_PLAN_ID,:P97_COST_CENTER , 135 )'
,p_validation_type=>'PLSQL_EXPRESSION'
,p_error_message=>'Total Allocated budget &P97_ALL_CHAPTER2. can not exceed the proposed budget &P97_CHAPTER2.'
,p_validation_condition_type=>'NEVER'
,p_associated_item=>wwv_flow_api.id(47658483722666725)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(47700749665036918)
,p_validation_name=>'Cost Center Submission Validation Process - Required Data'
,p_validation_sequence=>70
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count    number;',
'begin',
'',
'select nvl(count(ID),0)',
'into l_count',
'from BUDGET_PROPOSAL_PROJECTS_PLANS',
'where PLAN_ID = :P97_PLAN_ID',
'and cc_plan_id  = :P97_CC_PLAN_ID',
'and BUDGET_Y1 > 0',
'-- required data',
'and (',
'    PROJECT_DESCRIPTION               is null',
'    OR OUTCOME                        is null',
'    OR START_DATE                     is null',
'    OR START_DATE                     is null',
'    OR END_DATE                       is null',
'    OR BP_EXPENSE_CATEGORY_ID         is null',
'    OR BP_EXPENSE_CLASS_ID            is null',
'    OR BP_COMMITMENT_TYPE_ID          is null',
'    OR BP_CLASSIFICATIONS_ID          IS NULL',
'    OR CALCULATION_BASIS              IS NULL',
'    OR PRIORITY                       IS NULL',
'    OR DELIVERABLE_1                  IS NULL',
'    OR TRAGET_1                       IS NULL',
'    OR BUDGET_Y2                      IS NULL',
'    OR BUDGET_Y3                      IS NULL  ',
'    OR BUDGET_Y4                      IS NULL',
')',
';',
'',
'if l_count > 0 Then ',
'                    return false;',
'                else',
'                    return true;',
'End if;',
'',
'End ;'))
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'Please fill all the required data. Make sure you enter (Project description, outcome, Start Date, End Date, Expense Category, Expense Class, Commitment type, Classification, Calculation Basis, Prioirity, Budget 2024,Budget 2025,Budget 2026,Budget 202'
||'7, Deliverable1 and Target1)'
,p_when_button_pressed=>wwv_flow_api.id(47701041271036921)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(47453299920466523)
,p_name=>'New_document DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(47453371938466524)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(47453224523466522)
,p_event_id=>wwv_flow_api.id(47453299920466523)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(47564758292766393)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(47453071115466521)
,p_name=>'Documents report DA'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(47564758292766393)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(47452946740466520)
,p_event_id=>wwv_flow_api.id(47453071115466521)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(47564758292766393)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(44491756520903328)
,p_name=>'Add Project DA'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(45323360857071985)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(44491684445903327)
,p_event_id=>wwv_flow_api.id(44491756520903328)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(49378547048265057)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(43952849878021084)
,p_name=>'CHANGE_OPEX DA'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(43954252342021098)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(43952744965021083)
,p_event_id=>wwv_flow_api.id(43952849878021084)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(117344195474990233)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(43952713816021082)
,p_name=>'CHANGE_CAPEX DA'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(43952941852021085)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(43741120548643631)
,p_event_id=>wwv_flow_api.id(43952713816021082)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(117346109224992510)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(42350483499605110)
,p_name=>'P97_FUTURE1 DA'
,p_event_sequence=>60
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P97_FUTURE1'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(42350406609605109)
,p_event_id=>wwv_flow_api.id(42350483499605110)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(43740808284643628)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(38617918342086587)
,p_name=>'Closed DA'
,p_event_sequence=>70
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(49378547048265057)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
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
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(38617830704086586)
,p_event_id=>wwv_flow_api.id(38617918342086587)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(49378547048265057)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(38463094387266531)
,p_name=>'New_Comment DA'
,p_event_sequence=>80
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(38617335376086582)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(38462971806266530)
,p_event_id=>wwv_flow_api.id(38463094387266531)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(136184796545776356)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(38462921859266529)
,p_name=>'Collaborations Report Closed DA'
,p_event_sequence=>90
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(136184796545776356)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(38462768620266528)
,p_event_id=>wwv_flow_api.id(38462921859266529)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(136184796545776356)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(49278779444009321)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get Proposal Plan Details'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    plan_name,',
' --   status,',
'    proposal_year,',
'    proposal_year - 1,',
'    proposal_year - 2,',
'    proposal_year - 3,',
'    proposal_year - 4,',
'    proposal_year - 5,',
'    proposal_year,',
'    proposal_year + 1,',
'    proposal_year + 2,',
'    proposal_year + 3,',
'    proposal_year + 4,',
'    proposal_year + 5',
'INTO',
'    :P97_plan_name,',
'  --  :p97_status,',
'    :P97_year,',
'    :p97_a1,',
'    :p97_a2,',
'    :p97_a3,',
'    :p97_a4,',
'    :p97_a5,',
'    :p97_b1,',
'    :p97_b2,',
'    :p97_b3,',
'    :p97_b4,',
'    :p97_b5,',
'    :p97_b6',
'FROM',
'    budget_proposal_plans',
'WHERE',
'    plan_id = :P97_PLAN_ID; '))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(47701825985036928)
,p_process_sequence=>20
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'set Ceiling'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    nvl(ceiling_ch2_amount,0),',
'    TRIM(to_char(nvl(ceiling_ch2_amount, 0),',
'                 ''99,999,999,999.99''))',
'    || '' AED'',',
'    nvl(CEILING_CH2_ADDITIONAL,0),',
'    TRIM(to_char(nvl(CEILING_CH2_ADDITIONAL, 0),',
'                 ''99,999,999,999.99''))',
'    || '' AED'',',
'    ',
'    nvl(ceiling_ch3_amount,0),',
'    TRIM(to_char(nvl(ceiling_ch3_amount, 0),',
'                 ''99,999,999,999.99''))',
'    || '' AED'',',
'    nvl(CEILING_CH3_ADDITIONAL,0),',
'    TRIM(to_char(nvl(CEILING_CH3_ADDITIONAL, 0),',
'                 ''99,999,999,999.99''))',
'    || '' AED'',',
'    ',
'    COST_CENTER_INSTRUCTIONS,',
'    COMMENTS,',
'    STATUS,',
'    FBP_REVISE_STATUS,',
'    FPR_REVISE_STATUS',
'INTO',
'    :p97_chapter2_h,',
'    :p97_chapter2,',
'    :p97_chapter2_add_h,',
'    :p97_chapter2_add,',
'',
'    :p97_chapter3_h,',
'    :p97_chapter3,',
'    :p97_chapter3_add_h,',
'    :p97_chapter3_add,',
'    :P97_COST_CENTER_INSTRUCTIONS,',
'    :P97_COMMENTS,',
'    :p97_status,',
'    :p97_FBP_REVISE_STATUS,',
'    :p97_FPR_REVISE_STATUS',
'FROM',
'    budget_proposal_cost_centers_plans cc',
'WHERE',
'        cc.plan_id = :p97_plan_id',
'    AND cc.cost_center = :p97_cost_center',
'    and cc.id = :P97_CC_PLAN_ID;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(47361237992656816)
,p_process_sequence=>30
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get Allocated Balance'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'       ',
'       ch3_baseline_allocation , trim(to_char(nvl(ch3_baseline_allocation,0) , ''99,999,999,999.99'')) || '' AED'',',
'       ch2_baseline_allocation , trim(to_char(nvl(ch2_baseline_allocation,0) , ''99,999,999,999.99'')) || '' AED'',',
'       ',
'       ch3_additional_allocation , trim(to_char(nvl(ch3_additional_allocation,0) , ''99,999,999,999.99'')) || '' AED'',',
'       ch2_additional_allocation , trim(to_char(nvl(ch2_additional_allocation,0) , ''99,999,999,999.99'')) || '' AED''',
'       ',
'into ',
'     ',
'     :P97_ALL_BASELINE_CHAPTER3_H , :P97_ALL_BASELINE_CHAPTER3,',
'     :P97_ALL_BASELINE_CHAPTER2_H , :P97_ALL_BASELINE_CHAPTER2,',
'     ',
'     :P97_ALL_ADDITIONAL_CHAPTER3_H , :P97_ALL_ADDITIONAL_CHAPTER3,',
'     :P97_ALL_ADDITIONAL_CHAPTER2_H , :P97_ALL_ADDITIONAL_CHAPTER2',
'     ',
'     ',
'from',
'(',
'select BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated(:P97_PLAN_ID, :P97_COST_CENTER , 134) ch2_allocation,',
'       BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated(:P97_PLAN_ID, :P97_COST_CENTER , 135) ch3_allocation,',
'       ',
'       BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated_BY_LINE(:P97_PLAN_ID, :P97_COST_CENTER , 134 , ''N'') ch2_baseline_allocation,',
'       BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated_BY_LINE(:P97_PLAN_ID, :P97_COST_CENTER , 135 , ''N'') ch3_baseline_allocation,',
'       ',
'       BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated_BY_LINE(:P97_PLAN_ID, :P97_COST_CENTER , 134 , ''Y'') ch2_additional_allocation,',
'       BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated_BY_LINE(:P97_PLAN_ID, :P97_COST_CENTER , 135 , ''Y'') ch3_additional_allocation',
'from dual);',
''))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_type=>'NEVER'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(38090523833487407)
,p_process_sequence=>40
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get Allocated Balance_1'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'       ',
'       ch3_baseline_allocation , trim(to_char(nvl(ch3_baseline_allocation,0) , ''99,999,999,999.99'')) || '' AED'',',
'       ch2_baseline_allocation , trim(to_char(nvl(ch2_baseline_allocation,0) , ''99,999,999,999.99'')) || '' AED'',',
'       ',
'       ch3_additional_allocation , trim(to_char(nvl(ch3_additional_allocation,0) , ''99,999,999,999.99'')) || '' AED'',',
'       ch2_additional_allocation , trim(to_char(nvl(ch2_additional_allocation,0) , ''99,999,999,999.99'')) || '' AED'',',
'       ',
'       trim(to_char(nvl(CHAPTER2_REVISE_FBP,0) , ''99,999,999,999.99'')) || '' AED'',',
'       trim(to_char(nvl(CHAPTER3_REVISE_FBP,0) , ''99,999,999,999.99'')) || '' AED'',',
'       trim(to_char(nvl(CHAPTER2_REVISE_FPR,0) , ''99,999,999,999.99'')) || '' AED'',',
'       trim(to_char(nvl(CHAPTER3_REVISE_FPR,0) , ''99,999,999,999.99'')) || '' AED''',
'       ',
'into ',
'     ',
'     :P97_ALL_BASELINE_CHAPTER3_H , :P97_ALL_BASELINE_CHAPTER3,',
'     :P97_ALL_BASELINE_CHAPTER2_H , :P97_ALL_BASELINE_CHAPTER2,',
'     ',
'     :P97_ALL_ADDITIONAL_CHAPTER3_H , :P97_ALL_ADDITIONAL_CHAPTER3,',
'     :P97_ALL_ADDITIONAL_CHAPTER2_H , :P97_ALL_ADDITIONAL_CHAPTER2,',
'     ',
'     :P97_CHAPTER2_REVISE_FBP,',
'     :P97_CHAPTER3_REVISE_FBP,',
'     :P97_CHAPTER2_REVISE_FPR,',
'     :P97_CHAPTER3_REVISE_FPR',
'     ',
'     ',
'from(',
'select BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated_V2(:P97_PLAN_ID, :P97_CC_PLAN_ID , 134) ch2_allocation,',
'       BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated_v2(:P97_PLAN_ID, :P97_CC_PLAN_ID , 135) ch3_allocation,',
'       ',
'       BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated_BY_LINE_V2(:P97_PLAN_ID, :P97_CC_PLAN_ID , 134 , ''N'') ch2_baseline_allocation,',
'       BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated_BY_LINE_V2(:P97_PLAN_ID, :P97_CC_PLAN_ID , 135 , ''N'') ch3_baseline_allocation,',
'       ',
'       BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated_BY_LINE_V2(:P97_PLAN_ID, :P97_CC_PLAN_ID , 134 , ''Y'') ch2_additional_allocation,',
'       BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated_BY_LINE_v2(:P97_PLAN_ID, :P97_CC_PLAN_ID , 135 , ''Y'') ch3_additional_allocation,',
'       ',
'       ',
'       BUDGET_PROPOSAL_PKG.CC_BUDGET_REVISED_FBP(:P97_CC_PLAN_ID , 134) CHAPTER2_REVISE_FBP,',
'       BUDGET_PROPOSAL_PKG.CC_BUDGET_REVISED_FBP(:P97_CC_PLAN_ID , 135) CHAPTER3_REVISE_FBP,',
'       ',
'       BUDGET_PROPOSAL_PKG.CC_BUDGET_REVISED_FPR(:P97_CC_PLAN_ID , 134) CHAPTER2_REVISE_FPR,',
'       BUDGET_PROPOSAL_PKG.CC_BUDGET_REVISED_FPR(:P97_CC_PLAN_ID , 135) CHAPTER3_REVISE_FPR',
'from dual);',
''))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(37113274356435790)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Create Zip'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    var_zip blob;',
'     ',
'begin',
'     ',
'    -- Create/clear the ZIP collection',
'    APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(',
'        p_collection_name => ''ZIP'');',
'     ',
'    -- Loop through all the files in the database',
'    begin',
'        for var_file in (select fi.filename, fi.file_blob, fi.project_number',
'                         from budget_proposal_plans_documents fi',
'                         where cost_center  = :P97_COST_CENTER',
'                         and project_number is not null)',
'        loop',
'            -- Add each file to the var_zip file',
'            APEX_ZIP.ADD_FILE (',
'                p_zipped_blob => var_zip,',
'                p_file_name   => var_file.project_number || ''/'' || var_file.filename,',
'                p_content     => var_file.file_blob );',
'        end loop;',
'    exception when no_data_found then',
'        -- If there are no files in the database, handle error',
'        raise_application_error(-20001, ''No Files found!'');',
'    end;',
'     ',
'    -- Finish creating the zip file (var_zip)',
'    APEX_ZIP.FINISH(',
'        p_zipped_blob => var_zip);',
'     ',
'    -- Add var_zip to the blob column of the ZIP collection',
'    APEX_COLLECTION.ADD_MEMBER(',
'        p_collection_name => ''ZIP'',',
'        p_blob001            => var_zip);',
' ',
'end;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(37113396950435791)
);
wwv_flow_api.component_end;
end;
/
