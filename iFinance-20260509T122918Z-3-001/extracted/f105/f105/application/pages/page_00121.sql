prompt --application/pages/page_00121
begin
--   Manifest
--     PAGE: 00121
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
 p_id=>121
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Budget Proposal Line Details'
,p_alias=>'BUDGET-PROPOSAL-LINE-DETAILS'
,p_step_title=>'Budget Proposal Line Details'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230723135013'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(38462699849266527)
,p_plug_name=>'Search Criteria'
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
 p_id=>wwv_flow_api.id(38461780989266518)
,p_plug_name=>'Search L'
,p_parent_plug_id=>wwv_flow_api.id(38462699849266527)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(38461653046266517)
,p_plug_name=>'Search R'
,p_parent_plug_id=>wwv_flow_api.id(38462699849266527)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(38455827686166148)
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
 p_id=>wwv_flow_api.id(125456127007757534)
,p_plug_name=>'Projects Proposal Details'
,p_icon_css_classes=>'fa-list-ul'
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
'       user_details.get_cost_center_name(COST_CENTER) COST_CENTER_name,',
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
'       nvl(BUDGET_Y1,0) BUDGET_Y1,',
'       BUDGET_Y2,',
'       BUDGET_Y3,',
'       BUDGET_Y4,',
'       BUDGET_Y5,',
'       nvl(projects_util.expenditure_balance(project_number, trim(task_number), trim(expenditure_type), ''2023'' , ''A''),0) Actual_YTD,',
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
'       REVISED_BUDGET_FBP, ',
'       REVISED_BUDGET_FPR, ',
'       REVISED_BUDGET_JUST_FBP, ',
'       REVISED_BUDGET_JUST_FPR, ',
'       REVISED_BUDGET_REMARK_FBP, ',
'       REVISED_BUDGET_REMARK_FPR',
'       ,ID link',
' --      ID comment_link',
'  from BUDGET_PROPOSAL_PROJECTS_PLANS',
'  where plan_id = :P121_BUDGET_PROPOSAL_PLAN',
'  and nvl(budget_y1,0) >0',
'  ',
'  and sector_id = nvl(:P121_SECTOR  , sector_id)',
'  and cost_center = nvl(:P121_COST_CENTER , cost_center)',
'--  and nvl(bp_expense_class_id, -1) = nvl(:P121_EXPENSE_CLASS , -1)',
'--  and nvl(bp_expense_category_id,-1) = nvl(:P121_EXPENSE_CATEGORY , -1)',
'--  and nvl(bp_commitment_type_id , -1) = nvl(:P121_COMMITMENT_TYPE , -1)',
'--  and nvl(bp_classifications_id,-1) = nvl(:P121_CLASSIFICATION , -1)',
'  and project_number = nvl(:P121_PROJECT , project_number)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P121_BUDGET_PROPOSAL_PLAN,P121_SECTOR,P121_COST_CENTER,P121_EXPENSE_CLASS,P121_EXPENSE_CATEGORY,P121_COMMITMENT_TYPE,P121_CLASSIFICATION,P121_PROJECT'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
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
 p_id=>wwv_flow_api.id(125456486125757534)
,p_name=>'Report 1'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_allow_save_rpt_public=>'Y'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:98:&SESSION.::&DEBUG.:RP,:P98_ID,P98_PAGE_FROM,P98_STATUS,P98_PLAN_ID_H,P98_CC_PLAN_ID_H:\#ID#\,121,#STATUS#,\#PLAN_ID_H#\,&P97_CC_PLAN_ID.'
,p_detail_link_text=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_owner=>'TCA9051'
,p_internal_uid=>338740518514942166
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38447053919162028)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38446636817162027)
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
 p_id=>wwv_flow_api.id(38446290325162027)
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
 p_id=>wwv_flow_api.id(38445839125162024)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38445506705162023)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38445076216162023)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38444635402162022)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38444278344162022)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38443919374162021)
,p_db_column_name=>'BUDGET_GROUB_CODE'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Budget Groub Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38443513155162020)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'GL Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38443041414162020)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38442649648162019)
,p_db_column_name=>'FUTURE1'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38442254391162019)
,p_db_column_name=>'FUTURE2'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38441863180162018)
,p_db_column_name=>'PROJECT_NUMBER_NEW'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Project Number New'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38441520326162014)
,p_db_column_name=>'TASK_NUMBER_NEW'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Task Number New'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38441127439162014)
,p_db_column_name=>'EXPENDITURE_TYPE_NEW'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Expenditure Type New'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38440644689162013)
,p_db_column_name=>'COST_CENTER_NEW'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Cost Center New'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38440285671162012)
,p_db_column_name=>'BUDGET_GROUB_CODE_NEW'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Budget Groub Code New'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38439865034162012)
,p_db_column_name=>'GL_ACCOUNT_NEW'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Gl Account New'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38439498883162011)
,p_db_column_name=>'ACTIVITY_NEW'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Activity New'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38439049134162011)
,p_db_column_name=>'FUTURE1_NEW'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Future1 New'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38438673088162010)
,p_db_column_name=>'FUTURE2_NEW'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Future2 New'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38438262974162009)
,p_db_column_name=>'IT_BUDGET_RELATED_COST_CENTER'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'IT Budget Related Cost Center'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38437852996162009)
,p_db_column_name=>'PROJECT_DESCRIPTION'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Project Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38437517128162008)
,p_db_column_name=>'OUTCOME'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'Outcome'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38437090556162007)
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
 p_id=>wwv_flow_api.id(38436669569162007)
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
 p_id=>wwv_flow_api.id(38436310536162006)
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
 p_id=>wwv_flow_api.id(38435874020162004)
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
 p_id=>wwv_flow_api.id(38435514138162003)
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
 p_id=>wwv_flow_api.id(38435123705162002)
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
 p_id=>wwv_flow_api.id(38434728972162002)
,p_db_column_name=>'COST_DRIVER'
,p_display_order=>35
,p_column_identifier=>'AI'
,p_column_label=>'Cost Driver'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38434289569162001)
,p_db_column_name=>'COST_DRIVER_UOM'
,p_display_order=>36
,p_column_identifier=>'AJ'
,p_column_label=>'Cost Driver - UOM'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38433841208162001)
,p_db_column_name=>'COST_DRIVER_QUANTITY'
,p_display_order=>37
,p_column_identifier=>'AK'
,p_column_label=>'Cost Driver - Quantity'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38433527138162000)
,p_db_column_name=>'COST'
,p_display_order=>38
,p_column_identifier=>'AL'
,p_column_label=>'Cost'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38433048095161999)
,p_db_column_name=>'TOTAL_COST'
,p_display_order=>39
,p_column_identifier=>'AM'
,p_column_label=>'Total Cost'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38432815129161999)
,p_db_column_name=>'JUSTIFICATIONS'
,p_display_order=>40
,p_column_identifier=>'AN'
,p_column_label=>'Justifications'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38432375890161996)
,p_db_column_name=>'CALCULATION_BASIS'
,p_display_order=>41
,p_column_identifier=>'AO'
,p_column_label=>'Calculation Basis'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38431941758161995)
,p_db_column_name=>'ALLOW_ADD_TASK_YN'
,p_display_order=>50
,p_column_identifier=>'AX'
,p_column_label=>'Allow Add Task Yn'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38431533794161995)
,p_db_column_name=>'COMMENTS'
,p_display_order=>51
,p_column_identifier=>'AY'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38431220238161993)
,p_db_column_name=>'STATUS'
,p_display_order=>52
,p_column_identifier=>'AZ'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38430776645161993)
,p_db_column_name=>'PLAN_VERSION'
,p_display_order=>53
,p_column_identifier=>'BA'
,p_column_label=>'Plan Version'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38430394531161992)
,p_db_column_name=>'BUDGET_Y1'
,p_display_order=>54
,p_column_identifier=>'BB'
,p_column_label=>'Budget 2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38429965883161992)
,p_db_column_name=>'BUDGET_Y2'
,p_display_order=>55
,p_column_identifier=>'BC'
,p_column_label=>'Budget 2025'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38429618173161991)
,p_db_column_name=>'BUDGET_Y3'
,p_display_order=>56
,p_column_identifier=>'BD'
,p_column_label=>'Budget 2026'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38429161549161990)
,p_db_column_name=>'BUDGET_Y4'
,p_display_order=>57
,p_column_identifier=>'BE'
,p_column_label=>'Budget 2027'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38428779701161990)
,p_db_column_name=>'BUDGET_Y5'
,p_display_order=>58
,p_column_identifier=>'BF'
,p_column_label=>'Budget 2028'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38428416080161989)
,p_db_column_name=>'JAN'
,p_display_order=>59
,p_column_identifier=>'BG'
,p_column_label=>'01-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38428012074161985)
,p_db_column_name=>'FEB'
,p_display_order=>60
,p_column_identifier=>'BH'
,p_column_label=>'02-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38427559681161984)
,p_db_column_name=>'MAR'
,p_display_order=>61
,p_column_identifier=>'BI'
,p_column_label=>'03-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38427143950161983)
,p_db_column_name=>'APR'
,p_display_order=>62
,p_column_identifier=>'BJ'
,p_column_label=>'04-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38426823988161983)
,p_db_column_name=>'MAY'
,p_display_order=>63
,p_column_identifier=>'BK'
,p_column_label=>'05-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38426427881161982)
,p_db_column_name=>'JUN'
,p_display_order=>64
,p_column_identifier=>'BL'
,p_column_label=>'06-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38425958557161982)
,p_db_column_name=>'JUL'
,p_display_order=>65
,p_column_identifier=>'BM'
,p_column_label=>'07-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38425542790161981)
,p_db_column_name=>'AUG'
,p_display_order=>66
,p_column_identifier=>'BN'
,p_column_label=>'08-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38425137640161980)
,p_db_column_name=>'SEP'
,p_display_order=>67
,p_column_identifier=>'BO'
,p_column_label=>'09-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38424818675161980)
,p_db_column_name=>'OCT'
,p_display_order=>68
,p_column_identifier=>'BP'
,p_column_label=>'10-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38424417228161979)
,p_db_column_name=>'NOV'
,p_display_order=>69
,p_column_identifier=>'BQ'
,p_column_label=>'11-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38423957512161979)
,p_db_column_name=>'DEC'
,p_display_order=>70
,p_column_identifier=>'BR'
,p_column_label=>'12-2024'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38423595652161978)
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
 p_id=>wwv_flow_api.id(38423194461161977)
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
 p_id=>wwv_flow_api.id(38422776337161977)
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
 p_id=>wwv_flow_api.id(38422391109161976)
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
 p_id=>wwv_flow_api.id(38421968340161975)
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
 p_id=>wwv_flow_api.id(38421595996161975)
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
 p_id=>wwv_flow_api.id(38449069601162034)
,p_db_column_name=>'ACTUAL_Y1'
,p_display_order=>86
,p_column_identifier=>'BY'
,p_column_label=>'Budget 2023'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38448719028162030)
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
 p_id=>wwv_flow_api.id(38448251838162030)
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
 p_id=>wwv_flow_api.id(38447866060162029)
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
 p_id=>wwv_flow_api.id(38447506623162029)
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
 p_id=>wwv_flow_api.id(38421145876161974)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>136
,p_column_identifier=>'CD'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38420735272161973)
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
 p_id=>wwv_flow_api.id(38420397048161972)
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
 p_id=>wwv_flow_api.id(38419968704161972)
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
 p_id=>wwv_flow_api.id(38419599130161971)
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
 p_id=>wwv_flow_api.id(38419202654161970)
,p_db_column_name=>'PROPOSAL_YEAR'
,p_display_order=>186
,p_column_identifier=>'CI'
,p_column_label=>'Proposal Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38418752373161970)
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
 p_id=>wwv_flow_api.id(38418412422161969)
,p_db_column_name=>'DELIVERABLE_1'
,p_display_order=>206
,p_column_identifier=>'CK'
,p_column_label=>'Deliverable 1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38418007956161968)
,p_db_column_name=>'TRAGET_1'
,p_display_order=>216
,p_column_identifier=>'CL'
,p_column_label=>'Target 1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38417572910161968)
,p_db_column_name=>'DELIVERABLE_2'
,p_display_order=>226
,p_column_identifier=>'CM'
,p_column_label=>'Deliverable 2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38417220832161967)
,p_db_column_name=>'TARGET_2'
,p_display_order=>236
,p_column_identifier=>'CN'
,p_column_label=>'Target 2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38416750620161966)
,p_db_column_name=>'DELIVERABLE_3'
,p_display_order=>246
,p_column_identifier=>'CO'
,p_column_label=>'Deliverable 3'
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
 p_id=>wwv_flow_api.id(38416354078161966)
,p_db_column_name=>'TRAGET_3'
,p_display_order=>256
,p_column_identifier=>'CP'
,p_column_label=>'Target 3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38416000970161963)
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
 p_id=>wwv_flow_api.id(38415182658161961)
,p_db_column_name=>'SECTOR_ID_H'
,p_display_order=>276
,p_column_identifier=>'CS'
,p_column_label=>'Sector Id H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38414764043161961)
,p_db_column_name=>'PLAN_ID_H'
,p_display_order=>296
,p_column_identifier=>'CT'
,p_column_label=>'Plan Id H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38414398312161960)
,p_db_column_name=>'FBP_COMMENT'
,p_display_order=>306
,p_column_identifier=>'CU'
,p_column_label=>'FBP Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38413999280161959)
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
 p_id=>wwv_flow_api.id(38413615986161959)
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
 p_id=>wwv_flow_api.id(38413134913161958)
,p_db_column_name=>'PB_COMMENT'
,p_display_order=>336
,p_column_identifier=>'CX'
,p_column_label=>'BP Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38412799442161957)
,p_db_column_name=>'PB_COMMENT_BY'
,p_display_order=>346
,p_column_identifier=>'CY'
,p_column_label=>'BP Comment By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38412360973161957)
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
 p_id=>wwv_flow_api.id(38460184547266502)
,p_db_column_name=>'COST_CENTER_NAME'
,p_display_order=>366
,p_column_identifier=>'DA'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43470968323345614)
,p_db_column_name=>'LINK'
,p_display_order=>376
,p_column_identifier=>'DB'
,p_column_label=>'Documents'
,p_column_link=>'f?p=&APP_ID.:115:&SESSION.::&DEBUG.:115:P115_PLAN_ID,P115_COST_CENTER,P115_SECTOR_ID:#PLAN_ID_H#,#COST_CENTER#,#SECTOR_ID_H#'
,p_column_linktext=>'<span aria-hidden="true" class="fa fa-paperclip"></span>'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38090377969487406)
,p_db_column_name=>'ACTUAL_YTD'
,p_display_order=>386
,p_column_identifier=>'DC'
,p_column_label=>'Actual YTD'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30831171183351094)
,p_db_column_name=>'REVISED_BUDGET_FBP'
,p_display_order=>396
,p_column_identifier=>'DD'
,p_column_label=>'Revised Budget - FBP'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30831121734351093)
,p_db_column_name=>'REVISED_BUDGET_FPR'
,p_display_order=>406
,p_column_identifier=>'DE'
,p_column_label=>'Revised Budget - Budget Planning'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30830968266351092)
,p_db_column_name=>'REVISED_BUDGET_JUST_FBP'
,p_display_order=>416
,p_column_identifier=>'DF'
,p_column_label=>'Revised Budget Just - FBP'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30830851725351091)
,p_db_column_name=>'REVISED_BUDGET_JUST_FPR'
,p_display_order=>426
,p_column_identifier=>'DG'
,p_column_label=>'Revised Budget Just - Budget Planning'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30830781414351090)
,p_db_column_name=>'REVISED_BUDGET_REMARK_FBP'
,p_display_order=>436
,p_column_identifier=>'DH'
,p_column_label=>'Revised Budget Remark - FBP'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30830684879351089)
,p_db_column_name=>'REVISED_BUDGET_REMARK_FPR'
,p_display_order=>446
,p_column_identifier=>'DI'
,p_column_label=>'Revised Budget Remark - Budget Planning'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(125507611729794341)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1748724'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SECTOR_ID:PROJECT_NUMBER:PROJECT_NAME:TASK_NUMBER:EXPENDITURE_TYPE:INITIATIVE:PROGRAM:OBJECTIVE:CHAPTER:PROJECT_DESCRIPTION:OUTCOME:START_DATE:END_DATE:BP_EXPENSE_CATEGORY_ID:BP_EXPENSE_CLASS_ID:BP_COMMITMENT_TYPE_ID:BP_CLASSIFICATIONS_ID:PRIORITY:CA'
||'LCULATION_BASIS:JUSTIFICATIONS:COMMENTS:ACTUAL_Y5:ACTUAL_Y4:ACTUAL_Y3:ACTUAL_Y2:ACTUAL_Y1:BUDGET_Y1:JAN:FEB:MAR:APR:MAY:JUN:JUL:AUG:SEP:OCT:NOV:DEC:BUDGET_Y2:BUDGET_Y3:BUDGET_Y4:DELIVERABLE_1:TRAGET_1:DELIVERABLE_2:TARGET_2:DELIVERABLE_3:TRAGET_3:STA'
||'TUS:COST_CENTER_NAME:LINK:ACTUAL_YTD:REVISED_BUDGET_FBP:REVISED_BUDGET_FPR:REVISED_BUDGET_JUST_FBP:REVISED_BUDGET_JUST_FPR:REVISED_BUDGET_REMARK_FBP:REVISED_BUDGET_REMARK_FPR'
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
 p_id=>wwv_flow_api.id(38344108235540824)
,p_application_user=>'TCA9051'
,p_name=>'Review Version'
,p_report_seq=>10
,p_report_alias=>'1749400'
,p_status=>'PUBLIC'
,p_report_columns=>'SECTOR_ID:COST_CENTER_NAME:COST_CENTER:PROJECT_NUMBER:PROJECT_NAME:TASK_NUMBER:EXPENDITURE_TYPE:CHAPTER:BUDGET_Y1:ACTUAL_Y1:ACTUAL_YTD:ACTUAL_Y2:PROJECT_DESCRIPTION:BP_EXPENSE_CATEGORY_ID:BP_EXPENSE_CLASS_ID:BP_COMMITMENT_TYPE_ID:BP_CLASSIFICATIONS_I'
||'D:PRIORITY:CALCULATION_BASIS:JUSTIFICATIONS:COMMENTS:STATUS:LINK:FBP_COMMENT:'
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
 p_id=>wwv_flow_api.id(38286183775440811)
,p_application_user=>'TCA9272'
,p_name=>'Review Version'
,p_report_seq=>10
,p_report_alias=>'1749979'
,p_status=>'PUBLIC'
,p_report_columns=>'SECTOR_ID:COST_CENTER_NAME:COST_CENTER:PROJECT_NUMBER:PROJECT_NAME:TASK_NUMBER:EXPENDITURE_TYPE:CHAPTER:BUDGET_Y1:ACTUAL_Y1:ACTUAL_Y2:PROJECT_DESCRIPTION:BP_EXPENSE_CATEGORY_ID:BP_EXPENSE_CLASS_ID:BP_COMMITMENT_TYPE_ID:BP_CLASSIFICATIONS_ID:PRIORITY:'
||'CALCULATION_BASIS:JUSTIFICATIONS:COMMENTS:STATUS:LINK:FBP_COMMENT:'
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
 p_id=>wwv_flow_api.id(36346511756741177)
,p_application_user=>'TCA9272'
,p_name=>'Diff 2024 '
,p_description=>'diff from budget 2024 - budget 2023'
,p_report_seq=>10
,p_report_alias=>'1769376'
,p_status=>'PUBLIC'
,p_report_columns=>'SECTOR_ID:COST_CENTER_NAME:COST_CENTER:PROJECT_NUMBER:PROJECT_NAME:TASK_NUMBER:EXPENDITURE_TYPE:CHAPTER:BUDGET_Y1:ACTUAL_Y1:ACTUAL_Y2:PROJECT_DESCRIPTION:BP_EXPENSE_CATEGORY_ID:BP_EXPENSE_CLASS_ID:BP_COMMITMENT_TYPE_ID:BP_CLASSIFICATIONS_ID:PRIORITY:'
||'CALCULATION_BASIS:JUSTIFICATIONS:COMMENTS:STATUS:LINK:FBP_COMMENT::APXWS_CC_001'
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
 p_id=>wwv_flow_api.id(36346085386741160)
,p_report_id=>wwv_flow_api.id(36346511756741177)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'NEW_LINE'
,p_operator=>'='
,p_expr=>'No'
,p_condition_sql=>'"NEW_LINE" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''No''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(36345689907741159)
,p_report_id=>wwv_flow_api.id(36346511756741177)
,p_db_column_name=>'APXWS_CC_001'
,p_column_identifier=>'C01'
,p_computation_expr=>'BB - BY'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'diff.'
,p_report_label=>'diff.'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(37252807794958119)
,p_application_user=>'TCA282'
,p_name=>'ZNM Budget'
,p_report_seq=>10
,p_report_columns=>'COST_CENTER:SECTOR_ID:PROJECT_NUMBER:PROJECT_NAME:TASK_NUMBER:EXPENDITURE_TYPE:INITIATIVE:PROGRAM:OBJECTIVE:CHAPTER:PROJECT_DESCRIPTION:OUTCOME:START_DATE:END_DATE:BP_EXPENSE_CATEGORY_ID:BP_EXPENSE_CLASS_ID:BP_COMMITMENT_TYPE_ID:BP_CLASSIFICATIONS_ID'
||':PRIORITY:CALCULATION_BASIS:JUSTIFICATIONS:COMMENTS:ACTUAL_Y5:ACTUAL_Y4:ACTUAL_Y3:ACTUAL_Y2:ACTUAL_Y1:BUDGET_Y1:JAN:FEB:MAR:APR:MAY:JUN:JUL:AUG:SEP:OCT:NOV:DEC:BUDGET_Y2:BUDGET_Y3:BUDGET_Y4:DELIVERABLE_1:TRAGET_1:DELIVERABLE_2:TARGET_2:DELIVERABLE_3:'
||'TRAGET_3:STATUS:COST_CENTER_NAME:LINK:ACTUAL_YTD:'
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
 p_id=>wwv_flow_api.id(37252728428958118)
,p_report_id=>wwv_flow_api.id(37252807794958119)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'COST_CENTER'
,p_operator=>'in'
,p_expr=>'4510180,4510182,4510183,4510184,4510185,4510186'
,p_condition_sql=>'"COST_CENTER" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#, #APXWS_EXPR_VAL3#, #APXWS_EXPR_VAL4#, #APXWS_EXPR_VAL5#, #APXWS_EXPR_VAL6#)'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''4510180, 4510182, 4510183, 4510184, 4510185, 4510186''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(37252327517940429)
,p_application_user=>'TCA282'
,p_name=>'AFH Budget'
,p_report_seq=>10
,p_report_columns=>'COST_CENTER:SECTOR_ID:PROJECT_NUMBER:PROJECT_NAME:TASK_NUMBER:EXPENDITURE_TYPE:INITIATIVE:PROGRAM:OBJECTIVE:CHAPTER:PROJECT_DESCRIPTION:OUTCOME:START_DATE:END_DATE:BP_EXPENSE_CATEGORY_ID:BP_EXPENSE_CLASS_ID:BP_COMMITMENT_TYPE_ID:BP_CLASSIFICATIONS_ID'
||':PRIORITY:CALCULATION_BASIS:JUSTIFICATIONS:COMMENTS:ACTUAL_Y5:ACTUAL_Y4:ACTUAL_Y3:ACTUAL_Y2:ACTUAL_Y1:BUDGET_Y1:JAN:FEB:MAR:APR:MAY:JUN:JUL:AUG:SEP:OCT:NOV:DEC:BUDGET_Y2:BUDGET_Y3:BUDGET_Y4:DELIVERABLE_1:TRAGET_1:DELIVERABLE_2:TARGET_2:DELIVERABLE_3:'
||'TRAGET_3:STATUS:COST_CENTER_NAME:LINK:ACTUAL_YTD:'
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
 p_id=>wwv_flow_api.id(37252173299940429)
,p_report_id=>wwv_flow_api.id(37252327517940429)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'PROJECT_NUMBER'
,p_operator=>'in'
,p_expr=>'4514000051,4514000054,4514000055'
,p_condition_sql=>'"PROJECT_NUMBER" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#, #APXWS_EXPR_VAL3#)'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''4514000051, 4514000054, 4514000055''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(32554402104429055)
,p_application_user=>'TCA9028'
,p_name=>'Review Version'
,p_report_seq=>10
,p_report_columns=>'SECTOR_ID:COST_CENTER_NAME:COST_CENTER:PROJECT_NUMBER:PROJECT_NAME:TASK_NUMBER:EXPENDITURE_TYPE:CHAPTER:BUDGET_Y1:ACTUAL_Y1:ACTUAL_YTD:ACTUAL_Y2:PROJECT_DESCRIPTION:BP_EXPENSE_CATEGORY_ID:BP_EXPENSE_CLASS_ID:BP_COMMITMENT_TYPE_ID:BP_CLASSIFICATIONS_I'
||'D:PRIORITY:CALCULATION_BASIS:JUSTIFICATIONS:COMMENTS:STATUS:LINK:FBP_COMMENT:'
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
 p_id=>wwv_flow_api.id(32554266734429054)
,p_report_id=>wwv_flow_api.id(32554402104429055)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'COST_CENTER'
,p_operator=>'contains'
,p_expr=>'4510195'
,p_condition_sql=>'upper("COST_CENTER") like ''%''||upper(#APXWS_EXPR#)||''%'''
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''4510195''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(28190520377245054)
,p_application_user=>'TCA9059'
,p_name=>'Saleh'
,p_description=>'Saleh review'
,p_report_seq=>10
,p_report_columns=>'SECTOR_ID:PROJECT_NUMBER:PROJECT_NAME:COST_CENTER:TASK_NUMBER:EXPENDITURE_TYPE:INITIATIVE:PROGRAM:OBJECTIVE:CHAPTER:PROJECT_DESCRIPTION:OUTCOME:START_DATE:END_DATE:BP_EXPENSE_CATEGORY_ID:BP_EXPENSE_CLASS_ID:BP_COMMITMENT_TYPE_ID:BP_CLASSIFICATIONS_ID'
||':PRIORITY:CALCULATION_BASIS:JUSTIFICATIONS:COMMENTS:ACTUAL_Y5:ACTUAL_Y4:ACTUAL_Y3:ACTUAL_Y2:ACTUAL_Y1:BUDGET_Y1:JAN:FEB:MAR:APR:MAY:JUN:JUL:AUG:SEP:OCT:NOV:DEC:BUDGET_Y2:BUDGET_Y3:BUDGET_Y4:DELIVERABLE_1:TRAGET_1:DELIVERABLE_2:TARGET_2:DELIVERABLE_3:'
||'TRAGET_3:STATUS:COST_CENTER_NAME:LINK:ACTUAL_YTD:REVISED_BUDGET_FBP:REVISED_BUDGET_FPR:REVISED_BUDGET_JUST_FBP:REVISED_BUDGET_JUST_FPR:REVISED_BUDGET_REMARK_FBP:REVISED_BUDGET_REMARK_FPR:'
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
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(38461578576266516)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(38462699849266527)
,p_button_name=>'Search'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Search'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-search'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(38460530964266505)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(38462699849266527)
,p_button_name=>'Clear'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Clear'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38462564332266526)
,p_name=>'P121_SECTOR'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(38461780989266518)
,p_prompt=>'Sector'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select SECOR_NAME, SECTOR_ID',
'from(',
'select distinct SECTOR_ID , user_details.org_name(Sector_id) secor_name',
'from BUDGET_PROPOSAL_PROJECTS_PLANS)'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38462475261266525)
,p_name=>'P121_COST_CENTER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(38461780989266518)
,p_prompt=>'Cost Center'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select COST_CENTER_NAME || ',
'        ''(''             ||',
'        COST_CENTER     ||',
'        '')''     COST_CENTER_NAME',
'        , COST_CENTER',
'from(',
'select distinct COST_CENTER , user_details.get_cost_center_name(cost_center) cost_center_name',
'from BUDGET_PROPOSAL_PROJECTS_PLANS',
'where SECTOR_ID = nvl(:P121_SECTOR , SECTOR_ID))',
'order by COST_CENTER'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P121_SECTOR'
,p_ajax_optimize_refresh=>'N'
,p_cSize=>40
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38462383255266524)
,p_name=>'P121_EXPENSE_CLASS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(38461653046266517)
,p_prompt=>'Expense Class'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'BP EXPENSE CLASSES'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    value,',
'    value_id',
'FROM',
'    dct_lookup_values',
'WHERE',
'        lookup_id = (',
'            SELECT',
'                l.lookup_id',
'            FROM',
'                dct_lookups l',
'            WHERE',
'                l.lookup_code = ''BP_EXPENSE_CLASSES''',
'        )',
'    AND status = ''A''',
'    AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38462311715266523)
,p_name=>'P121_EXPENSE_CATEGORY'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(38461653046266517)
,p_prompt=>'Expense Category'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'BP EXPENSE CATEGORY'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    value,',
'    value_id',
'FROM',
'    dct_lookup_values',
'WHERE',
'        lookup_id = (',
'            SELECT',
'                l.lookup_id',
'            FROM',
'                dct_lookups l',
'            WHERE',
'                l.lookup_code = ''BP_EXPENSE_CATEGORIES''',
'        )',
'    AND status = ''A''',
'    AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38462166246266522)
,p_name=>'P121_COMMITMENT_TYPE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(38461653046266517)
,p_prompt=>'Commitment Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'BP COMMITMENT TYPES'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    value,',
'    value_id',
'FROM',
'    dct_lookup_values',
'WHERE',
'        lookup_id = (',
'            SELECT',
'                l.lookup_id',
'            FROM',
'                dct_lookups l',
'            WHERE',
'                l.lookup_code = ''BP_COMMITMENT_TYPES''',
'        )',
'    AND status = ''A''',
'    AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38462048612266521)
,p_name=>'P121_CLASSIFICATION'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(38461653046266517)
,p_prompt=>'Classification'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'BP CLASSIFICATIONS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    value,',
'    value_id',
'FROM',
'    dct_lookup_values',
'WHERE',
'        lookup_id = (',
'            SELECT',
'                l.lookup_id',
'            FROM',
'                dct_lookups l',
'            WHERE',
'                l.lookup_code = ''BP_CLASSIFICATIONS''',
'        )',
'    AND status = ''A''',
'    AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38461939802266520)
,p_name=>'P121_PROJECT'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(38461780989266518)
,p_prompt=>'Project'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select project_number ||',
'        ''(''         ||',
'        project_name  ||',
'        '')''      project_name ',
'        , project_number',
'from(',
'select distinct project_number , projects_util.project_name(project_number) project_name',
'from BUDGET_PROPOSAL_PROJECTS_PLANS',
'where SECTOR_ID = nvl(:P121_SECTOR , SECTOR_ID)',
'and cost_center = nvl(:P121_COST_CENTER, cost_center))',
'order by project_number'))
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38461890365266519)
,p_name=>'P121_BUDGET_PROPOSAL_PLAN'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(38461780989266518)
,p_prompt=>'Budget Proposal Plan'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT PLAN_NAME , PLAN_ID',
'FROM(',
'SELECT distinct plan_id  , budget_proposal_pkg.plan_name(plan_id) plan_name',
'FROM BUDGET_PROPOSAL_PROJECTS_PLANS',
'ORDER BY PLAN_ID)'))
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(38461451416266515)
,p_name=>'Search Da'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(38461578576266516)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(38461431711266514)
,p_event_id=>wwv_flow_api.id(38461451416266515)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(125456127007757534)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(38460432120266504)
,p_name=>'Clear DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(38460530964266505)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(38460286080266503)
,p_event_id=>wwv_flow_api.id(38460432120266504)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P121_SECTOR,P121_EXPENSE_CLASS,P121_COST_CENTER,P121_EXPENSE_CATEGORY,P121_COMMITMENT_TYPE,P121_CLASSIFICATION,P121_PROJECT'
);
wwv_flow_api.component_end;
end;
/
