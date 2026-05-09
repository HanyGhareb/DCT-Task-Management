prompt --application/pages/page_00110
begin
--   Manifest
--     PAGE: 00110
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
 p_id=>110
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Budget Proposal Cost Center Approve/Reject'
,p_alias=>'BUDGET-PROPOSAL-COST-CENTER-APPROVE-REJECT'
,p_step_title=>'Budget Proposal Cost Center Approve/Reject'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230710055654'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(116806438913585023)
,p_plug_name=>'Plan: &P110_PLAN_NAME. - Department / Cost Center:  &P110_COST_CENTER. Projects Proposal Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       PLAN_ID,',
'       SECTOR_ID,',
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
'       TRAGET_3',
'  from BUDGET_PROPOSAL_PROJECTS_PLANS',
'  where CC_PLAN_ID = :P110_REQUEST_ID --:P110_PLAN_ID',
'  and cost_center = :P110_COST_CENTER ',
'  and (BUDGET_Y1 > 0 or BUDGET_Y1 is not null)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P110_PLAN_ID,P110_COST_CENTER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Plan: &P97_PLAN_NAME. - Department / Cost Center:  &P97_COST_CENTER. Projects Proposal Details'
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
 p_id=>wwv_flow_api.id(116806798031585023)
,p_name=>'Report 1'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:98:&SESSION.::&DEBUG.:RP,98:P98_ID,P98_PAGE_FROM:\#ID#\,110'
,p_detail_link_text=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_owner=>'TCA9051'
,p_internal_uid=>330090830420769655
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47066580759334508)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47066210947334508)
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
 p_id=>wwv_flow_api.id(47065818293334507)
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
 p_id=>wwv_flow_api.id(47065394590334507)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47064991501334506)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47064568836334506)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47064189086334505)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47063734859334504)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47063362199334504)
,p_db_column_name=>'BUDGET_GROUB_CODE'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Budget Groub Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47062977751334503)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'GL Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47062587160334503)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47062187747334502)
,p_db_column_name=>'FUTURE1'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47061732834334501)
,p_db_column_name=>'FUTURE2'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47061340267334501)
,p_db_column_name=>'PROJECT_NUMBER_NEW'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Project Number New'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47060961259334500)
,p_db_column_name=>'TASK_NUMBER_NEW'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Task Number New'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47060536641334500)
,p_db_column_name=>'EXPENDITURE_TYPE_NEW'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Expenditure Type New'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47060181804334499)
,p_db_column_name=>'COST_CENTER_NEW'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Cost Center New'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47059813454334498)
,p_db_column_name=>'BUDGET_GROUB_CODE_NEW'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Budget Groub Code New'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47059389553334498)
,p_db_column_name=>'GL_ACCOUNT_NEW'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Gl Account New'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47059000298334497)
,p_db_column_name=>'ACTIVITY_NEW'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Activity New'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47058550942334496)
,p_db_column_name=>'FUTURE1_NEW'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Future1 New'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47058134335334495)
,p_db_column_name=>'FUTURE2_NEW'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Future2 New'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47057735491334494)
,p_db_column_name=>'IT_BUDGET_RELATED_COST_CENTER'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'IT Budget Related Cost Center'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47057405324334487)
,p_db_column_name=>'PROJECT_DESCRIPTION'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Project Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47057006247334487)
,p_db_column_name=>'OUTCOME'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'Outcome'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47056574215334486)
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
 p_id=>wwv_flow_api.id(47056170009334485)
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
 p_id=>wwv_flow_api.id(47055746278334484)
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
 p_id=>wwv_flow_api.id(47055344114334484)
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
 p_id=>wwv_flow_api.id(47055029825334483)
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
 p_id=>wwv_flow_api.id(47054617916334482)
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
 p_id=>wwv_flow_api.id(47054225341334482)
,p_db_column_name=>'COST_DRIVER'
,p_display_order=>35
,p_column_identifier=>'AI'
,p_column_label=>'Cost Driver'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47053784939334481)
,p_db_column_name=>'COST_DRIVER_UOM'
,p_display_order=>36
,p_column_identifier=>'AJ'
,p_column_label=>'Cost Driver - UOM'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47053349749334481)
,p_db_column_name=>'COST_DRIVER_QUANTITY'
,p_display_order=>37
,p_column_identifier=>'AK'
,p_column_label=>'Cost Driver - Quantity'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47052954073334480)
,p_db_column_name=>'COST'
,p_display_order=>38
,p_column_identifier=>'AL'
,p_column_label=>'Cost'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47052559811334480)
,p_db_column_name=>'TOTAL_COST'
,p_display_order=>39
,p_column_identifier=>'AM'
,p_column_label=>'Total Cost'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47052173067334479)
,p_db_column_name=>'JUSTIFICATIONS'
,p_display_order=>40
,p_column_identifier=>'AN'
,p_column_label=>'Justifications'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47051790914334478)
,p_db_column_name=>'CALCULATION_BASIS'
,p_display_order=>41
,p_column_identifier=>'AO'
,p_column_label=>'Calculation Basis'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47051340607334478)
,p_db_column_name=>'ALLOW_ADD_TASK_YN'
,p_display_order=>50
,p_column_identifier=>'AX'
,p_column_label=>'Allow Add Task Yn'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47050955949334477)
,p_db_column_name=>'COMMENTS'
,p_display_order=>51
,p_column_identifier=>'AY'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47050631103334477)
,p_db_column_name=>'STATUS'
,p_display_order=>52
,p_column_identifier=>'AZ'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47050179752334476)
,p_db_column_name=>'PLAN_VERSION'
,p_display_order=>53
,p_column_identifier=>'BA'
,p_column_label=>'Plan Version'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47049801304334476)
,p_db_column_name=>'BUDGET_Y1'
,p_display_order=>54
,p_column_identifier=>'BB'
,p_column_label=>'Budget &P110_B1.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47049422741334475)
,p_db_column_name=>'BUDGET_Y2'
,p_display_order=>55
,p_column_identifier=>'BC'
,p_column_label=>'Budget &P110_B2.'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47048990486334474)
,p_db_column_name=>'BUDGET_Y3'
,p_display_order=>56
,p_column_identifier=>'BD'
,p_column_label=>'Budget &P110_B3.'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47048566376334474)
,p_db_column_name=>'BUDGET_Y4'
,p_display_order=>57
,p_column_identifier=>'BE'
,p_column_label=>'Budget &P110_B4.'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47048192465334473)
,p_db_column_name=>'BUDGET_Y5'
,p_display_order=>58
,p_column_identifier=>'BF'
,p_column_label=>'Budget &P110_B5.'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47047821038334473)
,p_db_column_name=>'JAN'
,p_display_order=>59
,p_column_identifier=>'BG'
,p_column_label=>'01-&P110_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47047378300334471)
,p_db_column_name=>'FEB'
,p_display_order=>60
,p_column_identifier=>'BH'
,p_column_label=>'02-&P110_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47046987198334470)
,p_db_column_name=>'MAR'
,p_display_order=>61
,p_column_identifier=>'BI'
,p_column_label=>'03-&P110_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47046603111334469)
,p_db_column_name=>'APR'
,p_display_order=>62
,p_column_identifier=>'BJ'
,p_column_label=>'04-&P110_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47046135547334469)
,p_db_column_name=>'MAY'
,p_display_order=>63
,p_column_identifier=>'BK'
,p_column_label=>'05-&P110_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47045744240334468)
,p_db_column_name=>'JUN'
,p_display_order=>64
,p_column_identifier=>'BL'
,p_column_label=>'06-&P110_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47045413389334467)
,p_db_column_name=>'JUL'
,p_display_order=>65
,p_column_identifier=>'BM'
,p_column_label=>'07-&P110_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47044964418334467)
,p_db_column_name=>'AUG'
,p_display_order=>66
,p_column_identifier=>'BN'
,p_column_label=>'08-&P110_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47044582256334466)
,p_db_column_name=>'SEP'
,p_display_order=>67
,p_column_identifier=>'BO'
,p_column_label=>'09-&P110_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47044146388334463)
,p_db_column_name=>'OCT'
,p_display_order=>68
,p_column_identifier=>'BP'
,p_column_label=>'10-&P110_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47043811134334463)
,p_db_column_name=>'NOV'
,p_display_order=>69
,p_column_identifier=>'BQ'
,p_column_label=>'11-&P110_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47043340863334462)
,p_db_column_name=>'DEC'
,p_display_order=>70
,p_column_identifier=>'BR'
,p_column_label=>'12-&P110_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47043029013334461)
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
 p_id=>wwv_flow_api.id(47042556865334461)
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
 p_id=>wwv_flow_api.id(47042219268334460)
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
 p_id=>wwv_flow_api.id(47041776406334460)
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
 p_id=>wwv_flow_api.id(47041339603334459)
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
 p_id=>wwv_flow_api.id(47040992594334458)
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
 p_id=>wwv_flow_api.id(47068509394334511)
,p_db_column_name=>'ACTUAL_Y1'
,p_display_order=>86
,p_column_identifier=>'BY'
,p_column_label=>'Actual &P110_A1.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47068225811334511)
,p_db_column_name=>'ACTUAL_Y2'
,p_display_order=>96
,p_column_identifier=>'BZ'
,p_column_label=>'Actual &P110_A2.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47067824244334510)
,p_db_column_name=>'ACTUAL_Y3'
,p_display_order=>106
,p_column_identifier=>'CA'
,p_column_label=>'Actual &P110_A3.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47067423632334510)
,p_db_column_name=>'ACTUAL_Y4'
,p_display_order=>116
,p_column_identifier=>'CB'
,p_column_label=>'Actual &P110_A4.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47066986807334509)
,p_db_column_name=>'ACTUAL_Y5'
,p_display_order=>126
,p_column_identifier=>'CC'
,p_column_label=>'Actual &P110_A5.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47040603814334458)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>136
,p_column_identifier=>'CD'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47040195617334457)
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
 p_id=>wwv_flow_api.id(47039803991334456)
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
 p_id=>wwv_flow_api.id(47039336663334456)
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
 p_id=>wwv_flow_api.id(47038953497334454)
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
 p_id=>wwv_flow_api.id(47038543214334453)
,p_db_column_name=>'PROPOSAL_YEAR'
,p_display_order=>186
,p_column_identifier=>'CI'
,p_column_label=>'Proposal Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47038219721334452)
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
 p_id=>wwv_flow_api.id(47037828776334452)
,p_db_column_name=>'DELIVERABLE_1'
,p_display_order=>206
,p_column_identifier=>'CK'
,p_column_label=>'Deliverable 1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47037407732334451)
,p_db_column_name=>'TRAGET_1'
,p_display_order=>216
,p_column_identifier=>'CL'
,p_column_label=>'Target 1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47036933116334450)
,p_db_column_name=>'DELIVERABLE_2'
,p_display_order=>226
,p_column_identifier=>'CM'
,p_column_label=>'Deliverable 2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47036569781334450)
,p_db_column_name=>'TARGET_2'
,p_display_order=>236
,p_column_identifier=>'CN'
,p_column_label=>'Target 2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47036176641334449)
,p_db_column_name=>'DELIVERABLE_3'
,p_display_order=>246
,p_column_identifier=>'CO'
,p_column_label=>'Deliverable 3'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47035792901334448)
,p_db_column_name=>'TRAGET_3'
,p_display_order=>256
,p_column_identifier=>'CP'
,p_column_label=>'Target 3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(116857923635621830)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1662486'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SECTOR_ID:PROJECT_NUMBER:PROJECT_NAME:TASK_NUMBER:EXPENDITURE_TYPE:INITIATIVE:PROGRAM:OBJECTIVE:CHAPTER:IT_BUDGET_RELATED_COST_CENTER:PROJECT_DESCRIPTION:OUTCOME:START_DATE:END_DATE:BP_EXPENSE_CATEGORY_ID:BP_EXPENSE_CLASS_ID:BP_COMMITMENT_TYPE_ID:BP_'
||'CLASSIFICATIONS_ID:PRIORITY:COST_DRIVER:COST_DRIVER_UOM:COST_DRIVER_QUANTITY:COST:TOTAL_COST:CALCULATION_BASIS:JUSTIFICATIONS:COMMENTS:ACTUAL_Y5:ACTUAL_Y4:ACTUAL_Y3:ACTUAL_Y2:ACTUAL_Y1:BUDGET_Y1:JAN:FEB:MAR:APR:MAY:JUN:JUL:AUG:SEP:OCT:NOV:DEC:BUDGET_'
||'Y2:BUDGET_Y3:BUDGET_Y4:DELIVERABLE_1:TRAGET_1:DELIVERABLE_2:TARGET_2:DELIVERABLE_3:TRAGET_3:'
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(116838192409585042)
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
 p_id=>wwv_flow_api.id(116905522694840752)
,p_plug_name=>'Plan: &P110_PLAN_NAME. - Department / Cost Center:  &P110_COST_CENTER. Plan Details'
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
 p_id=>wwv_flow_api.id(118619657629083682)
,p_plug_name=>'Details'
,p_parent_plug_id=>wwv_flow_api.id(116905522694840752)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>80
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(292377783200223429)
,p_plug_name=>'Opex (Chapter 2)'
,p_parent_plug_id=>wwv_flow_api.id(116905522694840752)
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(133483101785710888)
,p_plug_name=>'Opex (Chapter 2)- Baseline'
,p_parent_plug_id=>wwv_flow_api.id(292377783200223429)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(133483180583710889)
,p_plug_name=>'Opex (Chapter 2)- Additional'
,p_parent_plug_id=>wwv_flow_api.id(292377783200223429)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(292390349902228452)
,p_plug_name=>'Capex (Chapter 3)'
,p_parent_plug_id=>wwv_flow_api.id(116905522694840752)
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>70
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(133494055862713637)
,p_plug_name=>'Capex (Chapter 3) - Baseline'
,p_parent_plug_id=>wwv_flow_api.id(292390349902228452)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(133494126410713638)
,p_plug_name=>'Capex (Chapter 3) - Additional'
,p_parent_plug_id=>wwv_flow_api.id(292390349902228452)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(118620096437083686)
,p_plug_name=>'Documents'
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(118620227669083687)
,p_plug_name=>'Documents report'
,p_parent_plug_id=>wwv_flow_api.id(118620096437083686)
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
'  where PLAN_ID = :P110_PLAN_ID',
'  and COST_CENTER = :P110_COST_CENTER',
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
 p_id=>wwv_flow_api.id(118620266103083688)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>331904298492268320
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47090369745334527)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47089958816334526)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Document Version'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47089594570334526)
,p_db_column_name=>'PLAN_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Plan'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47089152914334526)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47088762650334526)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47088416290334525)
,p_db_column_name=>'FILENAME'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47086744403334524)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47086387346334524)
,p_db_column_name=>'TAGS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47085958539334524)
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
 p_id=>wwv_flow_api.id(47085574449334524)
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
 p_id=>wwv_flow_api.id(47085202391334524)
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
 p_id=>wwv_flow_api.id(47084799633334523)
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
 p_id=>wwv_flow_api.id(47084347748334523)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47087995993334525)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>170
,p_column_identifier=>'G'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47087565952334525)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>180
,p_column_identifier=>'H'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47087227145334525)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>190
,p_column_identifier=>'I'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47084001910334523)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>200
,p_column_identifier=>'Q'
,p_column_label=>'Document'
,p_column_type=>'NUMBER'
,p_format_mask=>'DOWNLOAD:BUDGET_PROPOSAL_PLANS_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment:#FILENAME#:'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47083563775334523)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>210
,p_column_identifier=>'R'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47083147517334523)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>220
,p_column_identifier=>'S'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(118743028431411280)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1662012'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'DOWNLOAD:PROJECT_NUMBER:TASK_NUMBER:FILE_COMMENTS:ROW_VERSION_NUMBER:UPDATED:UPDATED_BY:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(118767284054700293)
,p_plug_name=>'Approval History'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent13:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P110_STATUS not in (''Draft'' , ''Available'')'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(118767403243700294)
,p_plug_name=>'Approval History Report'
,p_parent_plug_id=>wwv_flow_api.id(118767284054700293)
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
'and h.request_id = :P110_ID',
'and h.status != ''Bateen''',
'order by to_number(h.STEP_NO) ',
'--, h.ID',
';'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P110_ID'
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
 p_id=>wwv_flow_api.id(118767528189700295)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>332051560578884927
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47098154497334536)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47097806908334535)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47097423923334535)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47097025851334534)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47096614655334534)
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
 p_id=>wwv_flow_api.id(47096133345334534)
,p_db_column_name=>'ROLE_DESC'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Role Desc'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47095768146334534)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47095422974334534)
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
 p_id=>wwv_flow_api.id(47094943515334533)
,p_db_column_name=>'STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47094583586334533)
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
 p_id=>wwv_flow_api.id(47094217544334533)
,p_db_column_name=>'COMMENTS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47093757051334533)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47093416778334533)
,p_db_column_name=>'STATUS_CLASS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Status Class'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47093031827334532)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47092543467334532)
,p_db_column_name=>'PHOTO'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(118835511804221662)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1661918'
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
 p_id=>wwv_flow_api.id(46968445584322737)
,p_report_id=>wwv_flow_api.id(118835511804221662)
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
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(47091128558334528)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(118620096437083686)
,p_button_name=>'New_document'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'New Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:102:&SESSION.::&DEBUG.:102:P102_PLAN_ID,P102_STATUS,P102_COST_CENTER,P102_SECTOR_ID:&P110_PLAN_ID.,&P110_STATUS.,&P110_COST_CENTER.,&P110_SECTOR_ID.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(47033841836334446)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(116838192409585042)
,p_button_name=>'Back'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(47243721206850624)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(116838192409585042)
,p_button_name=>'Approve'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Approve'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:111:&SESSION.::&DEBUG.:111:P111_ACTION,P111_HISTORY_ID,P111_REQUEST_ID:Approve,&P110_HISTORY_ID.,&P110_ID.'
,p_icon_css_classes=>'fa-thumbs-o-up'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(47241644399850604)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(116838192409585042)
,p_button_name=>'Reject'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--danger:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Reject'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:111:&SESSION.::&DEBUG.:111:P111_ACTION,P111_HISTORY_ID,P111_PERSON_ID,P111_REQUEST_ID:Reject,&P110_HISTORY_ID.,&PERSON_ID.,&P110_ID.'
,p_icon_css_classes=>'fa-thumbs-o-down'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(47241288749850600)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(116838192409585042)
,p_button_name=>'Delegate'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Delegate'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:111:&SESSION.::&DEBUG.:111:P111_ACTION,P111_HISTORY_ID,P111_REQUEST_ID:Delegate,&P110_HISTORY_ID.,&P110_ID.'
,p_icon_css_classes=>'fa-sign-language'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(47241220151850599)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(116838192409585042)
,p_button_name=>'Return'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Return'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:111:&SESSION.::&DEBUG.:111:P111_ACTION,P111_HISTORY_ID,P111_REQUEST_ID:Return,&P110_HISTORY_ID.,&P110_ID.'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(47034623556334446)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(116806438913585023)
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
 p_id=>wwv_flow_api.id(47026896701334434)
,p_branch_name=>'Go to Update 101'
,p_branch_action=>'f?p=&APP_ID.:101:&SESSION.::&DEBUG.::P101_YEAR,P101_COST_CENTER,P101_PLAN_ID,P101_COST_CENTER_NAME,P101_STATUS,P101_CC_PLAN_ID:&P110_YEAR.,&P110_COST_CENTER.,&P110_PLAN_ID.,&P110_COST_CENTER_NAME.,&P110_STATUS.,&P110_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(47026046239334434)
,p_branch_name=>'Go To Submit 105'
,p_branch_action=>'f?p=&APP_ID.:105:&SESSION.::&DEBUG.::P105_CC_PLAN_ID,P105_COST_CENTER,P105_COST_CENTER_NAME,P105_PLAN_ID,P105_PLAN_NAME:&P110_ID.,&P110_COST_CENTER.,&P110_COST_CENTER_NAME.,&P110_PLAN_ID.,&P110_PLAN_NAME.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(47026494450334434)
,p_branch_name=>'Back To 96 &PAGE_FROM.'
,p_branch_action=>'f?p=&APP_ID.:&P110_PAGE_FROM.:&SESSION.::&DEBUG.::P96_PLAN,P92_PLAN_ID,P92_SECTOR_ID,P92_ID,P92_PROPOSAL_YEAR:&P110_PLAN_ID.,&P110_PLAN_ID.,&P110_SECTOR_ID.,&P110_SECTOR_PLAN_ID.,&P110_YEAR.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(47033841836334446)
,p_branch_sequence=>30
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47241586207850603)
,p_name=>'P110_SEQ'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(116838192409585042)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47241442436850602)
,p_name=>'P110_REQUEST_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(116838192409585042)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47241378033850601)
,p_name=>'P110_HISTORY_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(116838192409585042)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47082096668334522)
,p_name=>'P110_PLAN_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(116905522694840752)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47081636861334520)
,p_name=>'P110_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(116905522694840752)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47081277044334520)
,p_name=>'P110_SECTOR_PLAN_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(116905522694840752)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47080836240334520)
,p_name=>'P110_PAGE_FROM'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(116905522694840752)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47080525613334520)
,p_name=>'P110_PLAN_NAME'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(116905522694840752)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47080041284334520)
,p_name=>'P110_SECTOR_ID'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(116905522694840752)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47079726910334519)
,p_name=>'P110_COST_CENTER'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(116905522694840752)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47079310803334519)
,p_name=>'P110_COST_CENTER_NAME'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(116905522694840752)
,p_prompt=>'Cost Center (Department)'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47078917949334519)
,p_name=>'P110_STATUS'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(116905522694840752)
,p_prompt=>'Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_tag_css_classes=>'u-color-20-text'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47078512222334519)
,p_name=>'P110_YEAR'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(116905522694840752)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47078044735334519)
,p_name=>'P110_A1'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(116905522694840752)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47077633229334518)
,p_name=>'P110_A2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(116905522694840752)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47077295873334518)
,p_name=>'P110_A3'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(116905522694840752)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47076899679334518)
,p_name=>'P110_A4'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(116905522694840752)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47076513806334518)
,p_name=>'P110_A5'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(116905522694840752)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47076040040334518)
,p_name=>'P110_B1'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(116905522694840752)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47075681850334518)
,p_name=>'P110_B2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(116905522694840752)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47075250686334517)
,p_name=>'P110_B3'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(116905522694840752)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47074889474334517)
,p_name=>'P110_B4'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(116905522694840752)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47074465929334517)
,p_name=>'P110_B5'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(116905522694840752)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47074059273334517)
,p_name=>'P110_B6'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(116905522694840752)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47073350826334516)
,p_name=>'P110_COST_CENTER_INSTRUCTIONS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(118619657629083682)
,p_prompt=>'Instructions'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47073021854334516)
,p_name=>'P110_COMMENTS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(118619657629083682)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38249903004951432)
,p_name=>'P110_CHAPTER2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(133483101785710888)
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
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38248998043951421)
,p_name=>'P110_CHAPTER2_H'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(133483101785710888)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38248615089951420)
,p_name=>'P110_ALL_BASELINE_CHAPTER2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(133483101785710888)
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
 p_id=>wwv_flow_api.id(38248186776951420)
,p_name=>'P110_ALL_BASELINE_CHAPTER2_H'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(133483101785710888)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38247211311951419)
,p_name=>'P110_CHAPTER2_ADD'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(133483180583710889)
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
 p_id=>wwv_flow_api.id(38246828081951419)
,p_name=>'P110_CHAPTER2_ADD_H'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(133483180583710889)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38246379232951419)
,p_name=>'P110_ALL_CHAPTER2_H'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(133483180583710889)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38245947682951419)
,p_name=>'P110_ALL_ADDITIONAL_CHAPTER2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(133483180583710889)
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
 p_id=>wwv_flow_api.id(38245588749951419)
,p_name=>'P110_ALL_ADDITIONAL_CHAPTER2_H'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(133483180583710889)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38239194317948690)
,p_name=>'P110_CHAPTER3'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(133494055862713637)
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
 p_id=>wwv_flow_api.id(38238784880948689)
,p_name=>'P110_CHAPTER3_H'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(133494055862713637)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38238368310948689)
,p_name=>'P110_ALL_BASELINE_CHAPTER3'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(133494055862713637)
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
 p_id=>wwv_flow_api.id(38238020119948689)
,p_name=>'P110_ALL_BASELINE_CHAPTER3_H'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(133494055862713637)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38237004745948688)
,p_name=>'P110_CHAPTER3_ADD'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(133494126410713638)
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
 p_id=>wwv_flow_api.id(38236593772948688)
,p_name=>'P110_CHAPTER3_ADD_H'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(133494126410713638)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38236219036948688)
,p_name=>'P110_ALL_CHAPTER3_H'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(133494126410713638)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38235830651948688)
,p_name=>'P110_ALL_ADDITIONAL_CHAPTER3'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(133494126410713638)
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
 p_id=>wwv_flow_api.id(38235343725948688)
,p_name=>'P110_ALL_ADDITIONAL_CHAPTER3_H'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(133494126410713638)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(47032325581334440)
,p_computation_sequence=>10
,p_computation_item=>'P110_COST_CENTER_NAME'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'PLSQL_EXPRESSION'
,p_computation=>'user_details.get_cost_center_name(:P110_COST_CENTER) '
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(47031080053334439)
,p_validation_name=>'Cost Center Submission Validation Process - Required Data'
,p_validation_sequence=>30
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count    number;',
'begin',
'',
'select nvl(count(ID),0)',
'into l_count',
'from BUDGET_PROPOSAL_PROJECTS_PLANS',
'where PLAN_ID = :P110_PLAN_ID',
'and cost_center = :P110_COST_CENTER',
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
,p_error_message=>'Missing Required Data. Make sure you enter (Project description, outcome, Start Date, End Date, Expense Category, Expense Class, Commitment type, Classification, Calculation Basis, Prioirity, Deliverable, Target)'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(47028734319334437)
,p_name=>'New_document DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(47091128558334528)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(47028299077334435)
,p_event_id=>wwv_flow_api.id(47028734319334437)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(118620227669083687)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(47027925460334435)
,p_name=>'Documents report DA'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(118620227669083687)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(47027401259334435)
,p_event_id=>wwv_flow_api.id(47027925460334435)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(118620227669083687)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(47030779516334439)
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
'    :P110_plan_name,',
'  --  :p110_status,',
'    :P110_year,',
'    :p110_a1,',
'    :p110_a2,',
'    :p110_a3,',
'    :p110_a4,',
'    :p110_a5,',
'    :p110_b1,',
'    :p110_b2,',
'    :p110_b3,',
'    :p110_b4,',
'    :p110_b5,',
'    :p110_b6',
'FROM',
'    budget_proposal_plans',
'WHERE',
'    plan_id = :P110_PLAN_ID; '))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(47030334282334438)
,p_process_sequence=>20
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'set Ceiling'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    ceiling_ch2_amount,',
'    TRIM(to_char(nvl(ceiling_ch2_amount, 0),',
'                 ''99,999,999,999.99''))',
'    || '' AED'',',
'    ceiling_ch3_amount,',
'    TRIM(to_char(nvl(ceiling_ch3_amount, 0),',
'                 ''99,999,999,999.99''))',
'    || '' AED'',',
'    COST_CENTER_INSTRUCTIONS,',
'    COMMENTS,',
'    STATUS',
'INTO',
'    :p110_chapter2_h,',
'    :p110_chapter2,',
'    :p110_chapter3_h,',
'    :p110_chapter3,',
'    :P110_COST_CENTER_INSTRUCTIONS,',
'    :P110_COMMENTS,',
'    :p110_status',
'FROM',
'    budget_proposal_cost_centers_plans cc',
'WHERE',
'        cc.plan_id = :p110_plan_id',
'    AND cc.cost_center = :p110_cost_center;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_type=>'NEVER'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(38459692489266497)
,p_process_sequence=>30
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'set Ceiling_1'
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
'    STATUS',
'INTO',
'    :p110_chapter2_h,',
'    :p110_chapter2,',
'    :p110_chapter2_add_h,',
'    :p110_chapter2_add,',
'',
'    :p110_chapter3_h,',
'    :p110_chapter3,',
'    :p110_chapter3_add_h,',
'    :p110_chapter3_add,',
'    :P110_COST_CENTER_INSTRUCTIONS,',
'    :P110_COMMENTS,',
'    :p110_status',
'FROM',
'    budget_proposal_cost_centers_plans cc',
'WHERE',
'        cc.plan_id = :p110_plan_id',
'    AND cc.cost_center = :p110_cost_center',
'    and rownum =1;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(47029143696334437)
,p_process_sequence=>40
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get Allocated Balance'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ch3_allocation , trim(to_char(nvl(ch3_allocation,0) , ''99,999,999,999.99'')) || '' AED'',',
'       ch2_allocation , trim(to_char(nvl(ch2_allocation,0) , ''99,999,999,999.99'')) || '' AED''',
'into :P110_ALL_CHAPTER3_H , :P110_ALL_CHAPTER3 ,',
'     :P110_ALL_CHAPTER2_H , :P110_ALL_CHAPTER2',
'from',
'(',
'select BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated(:P110_PLAN_ID, :P110_COST_CENTER , 134) ch2_allocation,',
'       BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated(:P110_PLAN_ID, :P110_COST_CENTER , 135) ch3_allocation',
'from dual);'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_type=>'NEVER'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(38459594313266496)
,p_process_sequence=>50
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get Allocated Balance_1'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'',
'       ch3_baseline_allocation , trim(to_char(nvl(ch3_baseline_allocation,0) , ''99,999,999,999.99'')) || '' AED'',',
'       ch2_baseline_allocation , trim(to_char(nvl(ch2_baseline_allocation,0) , ''99,999,999,999.99'')) || '' AED'',',
'       ',
'       ch3_additional_allocation , trim(to_char(nvl(ch3_additional_allocation,0) , ''99,999,999,999.99'')) || '' AED'',',
'       ch2_additional_allocation , trim(to_char(nvl(ch2_additional_allocation,0) , ''99,999,999,999.99'')) || '' AED''',
'       ',
'into ',
'     :P110_ALL_BASELINE_CHAPTER3_H , :P110_ALL_BASELINE_CHAPTER3,',
'     :P110_ALL_BASELINE_CHAPTER2_H , :P110_ALL_BASELINE_CHAPTER2,',
'     ',
'     :P110_ALL_ADDITIONAL_CHAPTER3_H , :P110_ALL_ADDITIONAL_CHAPTER3,',
'     :P110_ALL_ADDITIONAL_CHAPTER2_H , :P110_ALL_ADDITIONAL_CHAPTER2    ',
'     ',
'from',
'(',
'select BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated(:P110_PLAN_ID, :P110_COST_CENTER , 134) ch2_allocation,',
'       BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated(:P110_PLAN_ID, :P110_COST_CENTER , 135) ch3_allocation,',
'       ',
'       BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated_BY_LINE(:P110_PLAN_ID, :P110_COST_CENTER , 134 , ''N'') ch2_baseline_allocation,',
'       BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated_BY_LINE(:P110_PLAN_ID, :P110_COST_CENTER , 135 , ''N'') ch3_baseline_allocation,',
'       ',
'       BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated_BY_LINE(:P110_PLAN_ID, :P110_COST_CENTER , 134 , ''Y'') ch2_additional_allocation,',
'       BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated_BY_LINE(:P110_PLAN_ID, :P110_COST_CENTER , 135 , ''Y'') ch3_additional_allocation',
'from dual);',
''))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(47029959839334438)
,p_process_sequence=>60
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get Allocated Chapter 3'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- Chapter 3',
'SELECT AMOUNT , trim(to_char(nvl(amount,0) , ''99,999,999,999.99'')) || '' AED''',
'into :P110_ALL_CHAPTER3_H , :P110_ALL_CHAPTER3',
'from',
'(',
'select Sum(nvl(BUDGET_Y1,0)) AMOUNT',
'from budget_proposal_projects_plans',
'where plan_id = :P110_PLAN',
'and cost_center = :P110_COST_CENTER',
'AND PROJECTS_UTIL.get_task_chapter(PROJECT_NUMBER,TASK_NUMBER ) = 135);'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_type=>'NEVER'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(47029554652334438)
,p_process_sequence=>70
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get Allocated Chapter 2'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- Chapter 2',
'SELECT AMOUNT , trim(to_char(nvl(amount,0) , ''99,999,999,999.99'')) || '' AED''',
'into :P110_ALL_CHAPTER2_H , :P110_ALL_CHAPTER2',
'from',
'(',
'select Sum(nvl(BUDGET_Y1,0)) AMOUNT',
'from budget_proposal_projects_plans',
'where plan_id = :P110_PLAN',
'and cost_center = :P110_COST_CENTER',
'AND PROJECTS_UTIL.get_task_chapter(PROJECT_NUMBER,TASK_NUMBER ) = 134);'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_type=>'NEVER'
);
wwv_flow_api.component_end;
end;
/
