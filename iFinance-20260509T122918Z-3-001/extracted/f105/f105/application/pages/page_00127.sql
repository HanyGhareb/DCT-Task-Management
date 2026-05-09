prompt --application/pages/page_00127
begin
--   Manifest
--     PAGE: 00127
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
 p_id=>127
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Budget Allocation - Cost-Center-Projects'
,p_alias=>'BUDGET-ALLOCATION-CC-PROJECTS'
,p_step_title=>'Budget Allocation - Cost Center Projects'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240214134753'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(10351773071613919)
,p_plug_name=>'Budget Allocation - Project Report'
,p_icon_css_classes=>'fa-window-play'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       FISICAL_YEAR,',
'       COST_CENTER_CODE,',
'       PROJECT_NUMBER,',
'       PROJECTS_UTIL.project_name(PROJECT_NUMBER) project_name,',
'       TASK_NUMBER,',
'       EXPENDITURE_TYPE,',
'       INITIATIVE_CODE,',
'       CHAPTER,',
'       EXPENSE_CLASS,',
'       REQUESTED_BUDGET,',
'       APPROVED_BUDGET,',
'       ALLOCATED_BUDGET_EU,',
'       JAN_EU,',
'       FEB_EU,',
'       MAR_EU,',
'       APR_EU,',
'       MAY_EU,',
'       JUN_EU,',
'       JUL_EU,',
'       AUG_EU,',
'       SEP_EU,',
'       OCT_EU,',
'       NOV_EU,',
'       DEC_EU,',
'       ALLOCATED_BUDGET_FBP,',
'       JAN_FBP,',
'       FEB_FBP,',
'       MAR_FBP,',
'       APR_FBP,',
'       MAY_FBP,',
'       JUN_FBP,',
'       JUL_FBP,',
'       AUG_FBP,',
'       SEP_FBP,',
'       OCT_FBP,',
'       NOV_FBP,',
'       DEC_FBP,',
'       COMMENTS_EU,',
'       COMMENTS_FBP,',
'       ITEM_CATEGORY1,',
'       ITEM_CATEGORY2,',
'       ITEM_CATEGORY3,',
'       CREATED,',
'       CREATED_BY,',
'       UPDATED,',
'       UPDATED_BY',
'  from BA_PROJECTS_ALLOCATION',
'  WHERE FISICAL_YEAR = :P127_YEAR',
'  AND COST_CENTER_CODE = NVL( :P127_COST_CENTER , COST_CENTER_CODE)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P127_YEAR,P127_COST_CENTER_H'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Budget Allocation - Project Report'
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
 p_id=>wwv_flow_api.id(10352210941613920)
,p_name=>'Report 1'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:128:&SESSION.::&DEBUG.:RP,128:P128_ID,P128_STATUS,P128_CC_CODE_H:\#ID#\,&P127_STATUS.,#COST_CENTER_CODE#'
,p_detail_link_text=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_owner=>'TCA9051'
,p_internal_uid=>223636243330798552
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10352332413613920)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10352719644613920)
,p_db_column_name=>'FISICAL_YEAR'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Fisical Year'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10353140912613920)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10353528932613920)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10353912093613921)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10354329544613921)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10354717892613921)
,p_db_column_name=>'INITIATIVE_CODE'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Initiative'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10355161046613921)
,p_db_column_name=>'CHAPTER'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Chapter'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10355904494613929)
,p_db_column_name=>'REQUESTED_BUDGET'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Requested Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10356365050613930)
,p_db_column_name=>'ALLOCATED_BUDGET_EU'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Allocated Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10356708958613930)
,p_db_column_name=>'JAN_EU'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Jan-24'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10357156983613930)
,p_db_column_name=>'FEB_EU'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Feb-24'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10357551076613930)
,p_db_column_name=>'MAR_EU'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Mar-24'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10357886181613930)
,p_db_column_name=>'APR_EU'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Apr-24'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10358282430613930)
,p_db_column_name=>'MAY_EU'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'May-24'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10358668836613931)
,p_db_column_name=>'JUN_EU'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Jun-24'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10359071819613931)
,p_db_column_name=>'JUL_EU'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Jul-24'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10359479794613931)
,p_db_column_name=>'AUG_EU'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Aug-24'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10359927182613931)
,p_db_column_name=>'SEP_EU'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Sep-24'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10360274748613931)
,p_db_column_name=>'OCT_EU'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Oct-24'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10360757833613932)
,p_db_column_name=>'NOV_EU'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Nov-24'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10361127576613932)
,p_db_column_name=>'DEC_EU'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Dec-24'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10361493371613932)
,p_db_column_name=>'ALLOCATED_BUDGET_FBP'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Allocated Budget - FBP'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_FBP_EMP = ''Y'' or',
':PERSON_ID = 680461 or',
':IS_BUDGET_PLANNING_YN = ''Y'' or',
':IS_SECTOR_PLANNER_YN = ''Y'' or',
':IS_COST_CENTER_PLANNER_YN	 = ''Y''',
''))
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10361900490613932)
,p_db_column_name=>'JAN_FBP'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'Jan - FBP'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_FBP_EMP = ''Y'' or',
':PERSON_ID = 680461 or',
':IS_BUDGET_PLANNING_YN = ''Y'' or',
':IS_SECTOR_PLANNER_YN = ''Y'' or',
':IS_COST_CENTER_PLANNER_YN	 = ''Y''',
''))
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10362355415613932)
,p_db_column_name=>'FEB_FBP'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'Feb Fbp'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_FBP_EMP = ''Y'' or',
':PERSON_ID = 680461 or',
':IS_BUDGET_PLANNING_YN = ''Y'' or',
':IS_SECTOR_PLANNER_YN = ''Y'' or',
':IS_COST_CENTER_PLANNER_YN	 = ''Y''',
''))
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10362680211613933)
,p_db_column_name=>'MAR_FBP'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Mar Fbp'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_FBP_EMP = ''Y'' or',
':PERSON_ID = 680461 or',
':IS_BUDGET_PLANNING_YN = ''Y'' or',
':IS_SECTOR_PLANNER_YN = ''Y'' or',
':IS_COST_CENTER_PLANNER_YN	 = ''Y''',
''))
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10363127012613933)
,p_db_column_name=>'APR_FBP'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'Apr Fbp'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_FBP_EMP = ''Y'' or',
':PERSON_ID = 680461 or',
':IS_BUDGET_PLANNING_YN = ''Y'' or',
':IS_SECTOR_PLANNER_YN = ''Y'' or',
':IS_COST_CENTER_PLANNER_YN	 = ''Y''',
''))
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10363478868613933)
,p_db_column_name=>'MAY_FBP'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'May Fbp'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_FBP_EMP = ''Y'' or',
':PERSON_ID = 680461 or',
':IS_BUDGET_PLANNING_YN = ''Y'' or',
':IS_SECTOR_PLANNER_YN = ''Y'' or',
':IS_COST_CENTER_PLANNER_YN	 = ''Y''',
''))
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10363885103613933)
,p_db_column_name=>'JUN_FBP'
,p_display_order=>30
,p_column_identifier=>'AD'
,p_column_label=>'Jun Fbp'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_FBP_EMP = ''Y'' or',
':PERSON_ID = 680461 or',
':IS_BUDGET_PLANNING_YN = ''Y'' or',
':IS_SECTOR_PLANNER_YN = ''Y'' or',
':IS_COST_CENTER_PLANNER_YN	 = ''Y''',
''))
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10364281527613933)
,p_db_column_name=>'JUL_FBP'
,p_display_order=>31
,p_column_identifier=>'AE'
,p_column_label=>'Jul Fbp'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_FBP_EMP = ''Y'' or',
':PERSON_ID = 680461 or',
':IS_BUDGET_PLANNING_YN = ''Y'' or',
':IS_SECTOR_PLANNER_YN = ''Y'' or',
':IS_COST_CENTER_PLANNER_YN	 = ''Y''',
''))
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10364699932613934)
,p_db_column_name=>'AUG_FBP'
,p_display_order=>32
,p_column_identifier=>'AF'
,p_column_label=>'Aug Fbp'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_FBP_EMP = ''Y'' or',
':PERSON_ID = 680461 or',
':IS_BUDGET_PLANNING_YN = ''Y'' or',
':IS_SECTOR_PLANNER_YN = ''Y'' or',
':IS_COST_CENTER_PLANNER_YN	 = ''Y''',
''))
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10365124453613934)
,p_db_column_name=>'SEP_FBP'
,p_display_order=>33
,p_column_identifier=>'AG'
,p_column_label=>'Sep Fbp'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_FBP_EMP = ''Y'' or',
':PERSON_ID = 680461 or',
':IS_BUDGET_PLANNING_YN = ''Y'' or',
':IS_SECTOR_PLANNER_YN = ''Y'' or',
':IS_COST_CENTER_PLANNER_YN	 = ''Y''',
''))
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10365473638613934)
,p_db_column_name=>'OCT_FBP'
,p_display_order=>34
,p_column_identifier=>'AH'
,p_column_label=>'Oct Fbp'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_FBP_EMP = ''Y'' or',
':PERSON_ID = 680461 or',
':IS_BUDGET_PLANNING_YN = ''Y'' or',
':IS_SECTOR_PLANNER_YN = ''Y'' or',
':IS_COST_CENTER_PLANNER_YN	 = ''Y''',
''))
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10365966702613934)
,p_db_column_name=>'NOV_FBP'
,p_display_order=>35
,p_column_identifier=>'AI'
,p_column_label=>'Nov Fbp'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_FBP_EMP = ''Y'' or',
':PERSON_ID = 680461 or',
':IS_BUDGET_PLANNING_YN = ''Y'' or',
':IS_SECTOR_PLANNER_YN = ''Y'' or',
':IS_COST_CENTER_PLANNER_YN	 = ''Y''',
''))
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10366339037613934)
,p_db_column_name=>'DEC_FBP'
,p_display_order=>36
,p_column_identifier=>'AJ'
,p_column_label=>'Dec Fbp'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_FBP_EMP = ''Y'' or',
':PERSON_ID = 680461 or',
':IS_BUDGET_PLANNING_YN = ''Y'' or',
':IS_SECTOR_PLANNER_YN = ''Y'' or',
':IS_COST_CENTER_PLANNER_YN	 = ''Y''',
''))
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10366669886613934)
,p_db_column_name=>'COMMENTS_EU'
,p_display_order=>37
,p_column_identifier=>'AK'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10367137973613935)
,p_db_column_name=>'COMMENTS_FBP'
,p_display_order=>38
,p_column_identifier=>'AL'
,p_column_label=>'Comment - FBP'
,p_column_type=>'STRING'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_FBP_EMP = ''Y'' or',
':PERSON_ID = 680461 or',
':IS_BUDGET_PLANNING_YN = ''Y'' or',
':IS_SECTOR_PLANNER_YN = ''Y'' or',
':IS_COST_CENTER_PLANNER_YN	 = ''Y''',
''))
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10367467648613935)
,p_db_column_name=>'CREATED'
,p_display_order=>39
,p_column_identifier=>'AM'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10367946536613936)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>40
,p_column_identifier=>'AN'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10368335898613936)
,p_db_column_name=>'UPDATED'
,p_display_order=>41
,p_column_identifier=>'AO'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10368695026613936)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>42
,p_column_identifier=>'AP'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8506955968715693)
,p_db_column_name=>'APPROVED_BUDGET'
,p_display_order=>52
,p_column_identifier=>'AQ'
,p_column_label=>'Approved Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8507021364715694)
,p_db_column_name=>'ITEM_CATEGORY1'
,p_display_order=>62
,p_column_identifier=>'AR'
,p_column_label=>'Category Level1'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(11362076622127119)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8507107243715695)
,p_db_column_name=>'ITEM_CATEGORY2'
,p_display_order=>72
,p_column_identifier=>'AS'
,p_column_label=>'Category Level2'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(11362076622127119)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8507259268715696)
,p_db_column_name=>'ITEM_CATEGORY3'
,p_display_order=>82
,p_column_identifier=>'AT'
,p_column_label=>'Category Level3'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(11362076622127119)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8507458318715698)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>92
,p_column_identifier=>'AU'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8507514883715699)
,p_db_column_name=>'EXPENSE_CLASS'
,p_display_order=>102
,p_column_identifier=>'AV'
,p_column_label=>'Expense Class'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(10489206735843455)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'2237733'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PROJECT_NUMBER:PROJECT_NAME:TASK_NUMBER:EXPENDITURE_TYPE:EXPENSE_CLASS:INITIATIVE_CODE:ITEM_CATEGORY1:ITEM_CATEGORY2:ITEM_CATEGORY3:CHAPTER:REQUESTED_BUDGET:APPROVED_BUDGET:ALLOCATED_BUDGET_EU:JAN_EU:FEB_EU:MAR_EU:APR_EU:MAY_EU:JUN_EU:JUL_EU:AUG_EU:S'
||'EP_EU:OCT_EU:NOV_EU:DEC_EU:ALLOCATED_BUDGET_FBP:JAN_FBP:FEB_FBP:MAR_FBP:APR_FBP:MAY_FBP:JUN_FBP:JUL_FBP:AUG_FBP:SEP_FBP:OCT_FBP:NOV_FBP:DEC_FBP:COMMENTS_EU:COMMENTS_FBP:UPDATED:UPDATED_BY:'
,p_sort_column_1=>'PROJECT_NUMBER'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'CHAPTER'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'TASK_NUMBER'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
,p_sum_columns_on_break=>'REQUESTED_BUDGET:APPROVED_BUDGET:ALLOCATED_BUDGET_EU:JAN_EU:FEB_EU:APR_EU:MAY_EU:JUN_EU:JUL_EU:AUG_EU:SEP_EU:OCT_EU:NOV_EU:DEC_EU:ALLOCATED_BUDGET_FBP:JAN_FBP:FEB_FBP:MAR_FBP:APR_FBP:MAY_FBP:JUN_FBP:JUL_FBP:AUG_FBP:SEP_FBP:OCT_FBP:NOV_FBP:DEC_FBP:MAR'
||'_EU'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(10369320317613936)
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
 p_id=>wwv_flow_api.id(10525311640009975)
,p_plug_name=>'Detail'
,p_icon_css_classes=>'fa-bars'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(10525408328009976)
,p_plug_name=>'Chapter 2'
,p_parent_plug_id=>wwv_flow_api.id(10525311640009975)
,p_icon_css_classes=>'fa-number-2-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(10525550136009977)
,p_plug_name=>'Chapter 3'
,p_parent_plug_id=>wwv_flow_api.id(10525311640009975)
,p_icon_css_classes=>'fa-number-3-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11301358890277000)
,p_plug_name=>'Cost Center Documents'
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
 p_id=>wwv_flow_api.id(11301401753277001)
,p_plug_name=>'Documents report'
,p_parent_plug_id=>wwv_flow_api.id(11301358890277000)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ROW_VERSION_NUMBER,',
'       BA_PROJECTS_ALLOCATION_ID,',
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
'  from ba_projects_allocation_documents',
'  where BA_PROJECTS_ALLOCATION_ID in (select ID from ba_projects_allocation where FISICAL_YEAR = :P127_YEAR and  COST_CENTER_CODE =  :P127_COST_CENTER)',
'  order by UPDATED desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P127_COST_CENTER,P127_YEAR'
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
 p_id=>wwv_flow_api.id(11301518835277002)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>224585551224461634
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11301573406277003)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11301711305277004)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11301858929277005)
,p_db_column_name=>'BA_PROJECTS_ALLOCATION_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Ba Projects Allocation Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11301930869277006)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Document Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11302012878277007)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11302164087277008)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11302244573277009)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11302296878277010)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11302429286277011)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11302521638277012)
,p_db_column_name=>'CREATED'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11302605028277013)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11302689545277014)
,p_db_column_name=>'UPDATED'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11302829815277015)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11302876447277016)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11303038191277017)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:BA_PROJECTS_ALLOCATION_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(12039660987403305)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'2253237'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:ROW_VERSION_NUMBER:TAGS:UPDATED:UPDATED_BY:DOWNLOAD:'
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
 p_id=>wwv_flow_api.id(10527306035009995)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(10369320317613936)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(10527385375009996)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(10369320317613936)
,p_button_name=>'Submit'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Submit'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:135:&SESSION.::&DEBUG.::P135_COST_CENTER:&P127_COST_CENTER_H.'
,p_button_condition=>':P127_STATUS  = ''Draft'''
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(10370562738613937)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(10351773071613919)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--link'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Add Project Line'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:134:&SESSION.::&DEBUG.:134:P134_COST_CENTER_CODE:&P127_COST_CENTER_H.'
,p_button_condition=>':PERSON_ID in ( 680461, 128383) or :IS_FBP_EMP = ''Y'''
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12322864203351090)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(10369320317613936)
,p_button_name=>'Return'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Return'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:136:&SESSION.::&DEBUG.:::'
,p_button_condition=>':PERSON_ID in ( 680461 , 1634334) and :P127_STATUS != ''Draft'''
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12323929234351101)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(10351773071613919)
,p_button_name=>'Copy'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Copy From End User'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:137:&SESSION.::&DEBUG.:::'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_FBP_EMP = ''Y'' or ',
':PERSON_ID in ( 680461 , 1634334)'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-copy'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8506751749715691)
,p_name=>'P127_YEAR'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(10369320317613936)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8506850161715692)
,p_name=>'P127_COST_CENTER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(10369320317613936)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10525582227009978)
,p_name=>'P127_SECTOR'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(10525311640009975)
,p_prompt=>'Sector'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ORGANIZATION NAME RETURN ORG_ID'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10525746298009979)
,p_name=>'P127_DEPARTMENT'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(10525311640009975)
,p_prompt=>'Department'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ORGANIZATION NAME RETURN ORG_ID'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10525900894009981)
,p_name=>'P127_COST_CENTER_H'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(10525311640009975)
,p_prompt=>'Cost Center'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10526014298009982)
,p_name=>'P127_REQUESTED_BUDGET_CH2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(10525408328009976)
,p_prompt=>'Requested Budget'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10526119402009983)
,p_name=>'P127_APPROVED_BUDGET_CH2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(10525408328009976)
,p_prompt=>'Approved Budget'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10526242449009984)
,p_name=>'P127_ALLOCATED_BUDGET_CH2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(10525408328009976)
,p_prompt=>'Allocated Budget'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10526275031009985)
,p_name=>'P127_REQUESTED_BUDGET_CH3'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(10525550136009977)
,p_prompt=>'Requested Budget'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10526456336009986)
,p_name=>'P127_APPROVED_BUDGET_CH3'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(10525550136009977)
,p_prompt=>'Approved Budget'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10526550028009987)
,p_name=>'P127_ALLOCATED_BUDGET_CH3'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(10525550136009977)
,p_prompt=>'Allocated Budget'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10526588103009988)
,p_name=>'P127_STATUS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(10525311640009975)
,p_prompt=>'Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10526681405009989)
,p_name=>'P127_CEILING_CH2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(10525408328009976)
,p_prompt=>'Ceiling'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10526850573009990)
,p_name=>'P127_CEILING_CH3'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(10525550136009977)
,p_prompt=>'Ceiling'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10527063785009992)
,p_name=>'P127_ALLOCATED_BUDGET_FBP_CH2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(10525408328009976)
,p_prompt=>'Allocated Budget By FBP'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10527092834009993)
,p_name=>'P127_ALLOCATED_BUDGET_FBP_CH3'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(10525550136009977)
,p_prompt=>'Allocated Budget By FBP'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11300090120276988)
,p_name=>'P127_AVAILABLE_BUDGET_FBP_CH2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(10525408328009976)
,p_prompt=>'Available Budget'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11300205303276989)
,p_name=>'P127_AVAILABLE_BUDGET_FBP_CH3'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(10525550136009977)
,p_prompt=>'Available Budget'
,p_post_element_text=>'<p>&nbsp;<span style="color: #3366ff;"><strong>AED</strong></span></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(8903798074781718)
,p_name=>'DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(10370562738613937)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12232709574045369)
,p_event_id=>wwv_flow_api.id(8903798074781718)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(10351773071613919)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(10527210185009994)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialized Header'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  cost_center_code',
'       ,user_details.sector_id_by_cc(COST_CENTER_CODE , sysdate) sector',
'       ,user_details.get_cost_center_name(COST_CENTER_CODE)     department',
'       ,approval_status',
'into',
'      :P127_COST_CENTER_H',
'     ,:P127_SECTOR',
'     ,:P127_DEPARTMENT',
'     ,:P127_STATUS',
'from ba_cost_centers_ceilling',
'where cost_center_code = :P127_COST_CENTER',
'and fisical_year = :P127_YEAR;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(10526919078009991)
,p_process_sequence=>20
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialized'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select   trim(to_char(nvl(CHAPTER2,0),''99,999,999,999,999.99''))',
'        ,trim(to_char(nvl(CHAPTER3,0),''99,999,999,999,999.99''))',
'        ,trim(to_char(nvl(BA_ALLOCATION.requested_budget (:P127_COST_CENTER, ''2'', :P127_YEAR),0),''99,999,999,999,999.99''))  project_requested_budget_2',
'        ,trim(to_char(nvl(BA_ALLOCATION.approved_budget (:P127_COST_CENTER, ''2'', :P127_YEAR),0),''99,999,999,999,999.99''))  project_approved_budget_2',
'        ,trim(to_char(nvl(BA_ALLOCATION.allocated_budget (:P127_COST_CENTER, ''2'', :P127_YEAR),0),''99,999,999,999,999.99''))  project_allocated_budget_2',
'        ,trim(to_char(nvl(BA_ALLOCATION.allocated_budget_fbp (:P127_COST_CENTER, ''2'', :P127_YEAR),0),''99,999,999,999,999.99''))  project_allocated_budget_fbp_2',
'        ,trim(to_char(nvl(BA_ALLOCATION.approved_budget (:P127_COST_CENTER, ''2'', :P127_YEAR),0)',
'                        -',
'                      nvl(BA_ALLOCATION.allocated_budget (:P127_COST_CENTER, ''2'', :P127_YEAR),0)  ',
'                    ,''99,999,999,999,999.99''))  AVAILABLE_BUDGET_FBP_CH2',
'        ',
'        ,trim(to_char(nvl(BA_ALLOCATION.requested_budget (:P127_COST_CENTER, ''3'', :P127_YEAR),0),''99,999,999,999,999.99''))  project_requested_budget_3',
'        ,trim(to_char(nvl(BA_ALLOCATION.approved_budget (:P127_COST_CENTER, ''3'', :P127_YEAR),0),''99,999,999,999,999.99''))  project_approved_budget_3',
'        ,trim(to_char(nvl(BA_ALLOCATION.allocated_budget (:P127_COST_CENTER, ''3'', :P127_YEAR),0),''99,999,999,999,999.99''))  project_allocated_budget_3',
'        ,trim(to_char(nvl(BA_ALLOCATION.allocated_budget_fbp (:P127_COST_CENTER, ''3'', :P127_YEAR),0),''99,999,999,999,999.99''))  project_allocated_budget_fbp_3',
'        ,trim(to_char(nvl(BA_ALLOCATION.approved_budget (:P127_COST_CENTER, ''3'', :P127_YEAR),0)',
'                        -',
'                      nvl(BA_ALLOCATION.allocated_budget (:P127_COST_CENTER, ''3'', :P127_YEAR),0)  ',
'                    ,''99,999,999,999,999.99''))  AVAILABLE_BUDGET_FBP_CH3',
'into',
'      :P127_CEILING_CH2',
'     ,:P127_CEILING_CH3',
'     ',
'     ,:P127_REQUESTED_BUDGET_CH2',
'     ,:P127_APPROVED_BUDGET_CH2',
'     ,:P127_ALLOCATED_BUDGET_CH2',
'     ,:P127_ALLOCATED_BUDGET_FBP_CH2',
'     ,:P127_AVAILABLE_BUDGET_FBP_CH2',
'     ',
'     ,:P127_REQUESTED_BUDGET_CH3',
'     ,:P127_APPROVED_BUDGET_CH3',
'     ,:P127_ALLOCATED_BUDGET_CH3',
'     ,:P127_ALLOCATED_BUDGET_FBP_CH3',
'     ,:P127_AVAILABLE_BUDGET_FBP_CH3',
'from ba_cost_centers_ceilling',
'where cost_center_code = :P127_COST_CENTER',
'and fisical_year = :P127_YEAR;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
