prompt --application/pages/page_00085
begin
--   Manifest
--     PAGE: 00085
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
 p_id=>85
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Budget Proposal Plan Details'
,p_alias=>'PROPOSAL-PLAN-DETAILS'
,p_step_title=>'Budget Proposal Plan Details'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'PLSQL_EXPRESSION'
,p_read_only_when=>':P85_STATUS not in (''Draft'' , ''Returned'')'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230518195801'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(54386535015888343)
,p_plug_name=>'Proposal Plan Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'BUDGET_PROPOSAL_PLANS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(54314523766782528)
,p_plug_name=>'Audit'
,p_parent_plug_id=>wwv_flow_api.id(54386535015888343)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noUI:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>80
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P85_PLAN_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(54311018870782493)
,p_plug_name=>'Details L'
,p_parent_plug_id=>wwv_flow_api.id(54386535015888343)
,p_icon_css_classes=>'fa-line-chart'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>8
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(54310814873782491)
,p_plug_name=>'<p><strong>Plan Control</strong></p>'
,p_parent_plug_id=>wwv_flow_api.id(54311018870782493)
,p_icon_css_classes=>'fa-braille'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(58290137447395283)
,p_plug_name=>'<p><strong>Chapter 1 (Man Power)</strong></p>'
,p_parent_plug_id=>wwv_flow_api.id(54310814873782491)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:t-Region--hideShowIconsMath:is-expanded:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P85_PLAN_TYPE = ''M'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(58290045759395282)
,p_plug_name=>'<p><strong>Chapter 2 (Opex)</strong></p>'
,p_parent_plug_id=>wwv_flow_api.id(54310814873782491)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:t-Region--hideShowIconsMath:is-expanded:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P85_PLAN_TYPE = ''E'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(54314762632782531)
,p_plug_name=>'<p><strong>Chapter 3 (Capx)</strong></p>'
,p_parent_plug_id=>wwv_flow_api.id(54310814873782491)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:t-Region--hideShowIconsMath:is-expanded:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P85_PLAN_TYPE = ''E'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(54314682230782530)
,p_plug_name=>'<p><strong>Chapter 6 (CWIP)</strong></p>'
,p_parent_plug_id=>wwv_flow_api.id(54310814873782491)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:t-Region--hideShowIconsMath:is-expanded:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P85_PLAN_TYPE = ''C'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(54314536291782529)
,p_plug_name=>'<p><strong>Revenue</strong></p>'
,p_parent_plug_id=>wwv_flow_api.id(54310814873782491)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:t-Region--hideShowIconsMath:is-expanded:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P85_PLAN_TYPE = ''R'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(54310877241782492)
,p_plug_name=>'Details R'
,p_parent_plug_id=>wwv_flow_api.id(54386535015888343)
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
 p_id=>wwv_flow_api.id(50265138488516629)
,p_plug_name=>'Departments / Cost Centers Plans'
,p_parent_plug_id=>wwv_flow_api.id(54386535015888343)
,p_icon_css_classes=>'fa-cc'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent13:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>'select 1 from budget_proposal_cost_centers_plans where plan_id =:P85_PLAN_ID;'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(50265113996516628)
,p_plug_name=>'Departments / Cost Centers Plan Report'
,p_parent_plug_id=>wwv_flow_api.id(50265138488516629)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       PLAN_ID,',
'       SECTOR_ID,',
'       COST_CENTER,',
'       user_details.get_cost_center_name(cost_center) cost_center_name,',
'       user_details.get_cc_director_person_id(COST_CENTER) DIRECTOR_NAME,',
'       user_details.get_cc_exec_dir_person_id(COST_CENTER) ED_NAME,',
'       CEILING_CH1_REQUIRED_YN,',
'       CEILING_CH1_AMOUNT,',
'       CEILING_CH2_REQUIRED_YN,',
'       CEILING_CH2_AMOUNT,',
'       BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated(PLAN_ID , COST_CENTER , 134) CH2_Allocation,',
'       CEILING_CH3_REQUIRED_YN,',
'       CEILING_CH3_AMOUNT,',
'       BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated(PLAN_ID , COST_CENTER , 135) CH3_Allocation,',
'       CEILING_CH6_REQUIRED_YN,',
'       CEILING_CH6_AMOUNT,',
'       STATUS,',
'       COST_CENTER_INSTRUCTIONS,',
'       COMMENTS,',
'       SUBMITTED_BY,',
'       SUBMITTED_ON,',
'       RECEIVED_ON,',
'       RECEIVED_BY,',
'       ALLOW_ADD_PROJECT_YN,',
'       ALLOW_ADD_TASK_YN,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       (select count (distinct p.project_number)',
'        from budget_proposal_projects_plans p',
'        where p.plan_id = cc.plan_id',
'        and p.sector_id = cc.sector_id',
'        and p.cost_center = cc.cost_center) projects_count,',
'      (select count (*)',
'        from budget_proposal_projects_plans p',
'        where p.plan_id = cc.plan_id',
'        and p.sector_id = cc.sector_id',
'        and p.cost_center = cc.cost_center) line_count  ',
'  from BUDGET_PROPOSAL_COST_CENTERS_PLANS cc',
'  where plan_id = :P85_PLAN_ID',
'  order by cost_center'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P85_PLAN_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Departments / Cost Centers Plan Report'
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
 p_id=>wwv_flow_api.id(50264962147516627)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_flashback=>'N'
,p_show_download=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>163019070241668005
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50264881060516626)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50264824335516625)
,p_db_column_name=>'PLAN_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Plan Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50264689298516624)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1216232005294941)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50264625912516623)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49200152369443409)
,p_db_column_name=>'COST_CENTER_NAME'
,p_display_order=>50
,p_column_identifier=>'AB'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50264502870516622)
,p_db_column_name=>'CEILING_CH1_REQUIRED_YN'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'Ceiling Ch1 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P85_PLAN_TYPE = ''M'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50264397735516621)
,p_db_column_name=>'CEILING_CH1_AMOUNT'
,p_display_order=>70
,p_column_identifier=>'F'
,p_column_label=>'Ceiling Ch1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P85_PLAN_TYPE = ''M'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50264299177516620)
,p_db_column_name=>'CEILING_CH2_REQUIRED_YN'
,p_display_order=>80
,p_column_identifier=>'G'
,p_column_label=>'Ceiling Ch2 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50264210597516619)
,p_db_column_name=>'CEILING_CH2_AMOUNT'
,p_display_order=>90
,p_column_identifier=>'H'
,p_column_label=>'Opex (CH2) Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47244050004850628)
,p_db_column_name=>'CH2_ALLOCATION'
,p_display_order=>100
,p_column_identifier=>'AC'
,p_column_label=>'Opex (CH2) Allocation'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50264090226516618)
,p_db_column_name=>'CEILING_CH3_REQUIRED_YN'
,p_display_order=>110
,p_column_identifier=>'I'
,p_column_label=>'Ceiling Ch3 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50263962411516617)
,p_db_column_name=>'CEILING_CH3_AMOUNT'
,p_display_order=>120
,p_column_identifier=>'J'
,p_column_label=>'Capex (CH3) Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47243985431850627)
,p_db_column_name=>'CH3_ALLOCATION'
,p_display_order=>130
,p_column_identifier=>'AD'
,p_column_label=>'Capex (CH3) Allocation'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50263908217516616)
,p_db_column_name=>'CEILING_CH6_REQUIRED_YN'
,p_display_order=>140
,p_column_identifier=>'K'
,p_column_label=>'Ceiling Ch6 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P85_PLAN_TYPE = ''C'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50263736169516615)
,p_db_column_name=>'CEILING_CH6_AMOUNT'
,p_display_order=>150
,p_column_identifier=>'L'
,p_column_label=>'Ceiling Ch6'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P85_PLAN_TYPE = ''C'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50263687783516614)
,p_db_column_name=>'STATUS'
,p_display_order=>160
,p_column_identifier=>'M'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50263550681516613)
,p_db_column_name=>'COST_CENTER_INSTRUCTIONS'
,p_display_order=>170
,p_column_identifier=>'N'
,p_column_label=>'Cost Center Instructions'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50263443347516612)
,p_db_column_name=>'COMMENTS'
,p_display_order=>180
,p_column_identifier=>'O'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50263372705516611)
,p_db_column_name=>'SUBMITTED_BY'
,p_display_order=>190
,p_column_identifier=>'P'
,p_column_label=>'Submitted By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50263288617516610)
,p_db_column_name=>'SUBMITTED_ON'
,p_display_order=>200
,p_column_identifier=>'Q'
,p_column_label=>'Submitted On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50263135160516609)
,p_db_column_name=>'RECEIVED_ON'
,p_display_order=>210
,p_column_identifier=>'R'
,p_column_label=>'Received On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50263072349516608)
,p_db_column_name=>'RECEIVED_BY'
,p_display_order=>220
,p_column_identifier=>'S'
,p_column_label=>'Received By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50263019716516607)
,p_db_column_name=>'ALLOW_ADD_PROJECT_YN'
,p_display_order=>230
,p_column_identifier=>'T'
,p_column_label=>'Allow Add Project ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50262925925516606)
,p_db_column_name=>'ALLOW_ADD_TASK_YN'
,p_display_order=>240
,p_column_identifier=>'U'
,p_column_label=>'Allow Add Task ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50262759702516605)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>250
,p_column_identifier=>'V'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50262649645516604)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>260
,p_column_identifier=>'W'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50262626282516603)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>270
,p_column_identifier=>'X'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50262512451516602)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>280
,p_column_identifier=>'Y'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50230951358855811)
,p_db_column_name=>'PROJECTS_COUNT'
,p_display_order=>290
,p_column_identifier=>'Z'
,p_column_label=>'Projects Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50230928363855810)
,p_db_column_name=>'LINE_COUNT'
,p_display_order=>300
,p_column_identifier=>'AA'
,p_column_label=>'Line Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46208729241316288)
,p_db_column_name=>'DIRECTOR_NAME'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Director'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46208558928316287)
,p_db_column_name=>'ED_NAME'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Executive Director'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(50241401484448280)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1630427'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SECTOR_ID:COST_CENTER:COST_CENTER_NAME:DIRECTOR_NAME:ED_NAME:CEILING_CH2_AMOUNT:CH2_ALLOCATION:CEILING_CH3_AMOUNT:CH3_ALLOCATION:PROJECTS_COUNT:LINE_COUNT:STATUS:'
,p_sort_column_1=>'COST_CENTER'
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
,p_sum_columns_on_break=>'CEILING_CH2_AMOUNT:CH2_ALLOCATION:CEILING_CH3_AMOUNT:CH3_ALLOCATION'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(45160633657368451)
,p_report_id=>wwv_flow_api.id(50241401484448280)
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
 p_id=>wwv_flow_api.id(45160279133368451)
,p_report_id=>wwv_flow_api.id(50241401484448280)
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(50262332794516601)
,p_plug_name=>'Sectors Plans'
,p_parent_plug_id=>wwv_flow_api.id(54386535015888343)
,p_icon_css_classes=>'fa-window-maximize'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P85_PLAN_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(56090729019222995)
,p_plug_name=>'Sectors Report'
,p_parent_plug_id=>wwv_flow_api.id(50262332794516601)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       PLAN_ID,',
'       SECTOR_ID,',
'       SECTOR_INSTRUCTIONS,',
'       COMMENTS,',
'       STATUS,',
'       ALLOW_ADD_COST_CENTER_YN,',
'       ALLOW_ADD_PROJECT_YN,',
'       ALLOW_ADD_TASK_YN,',
'       CEILING_CH1_REQUIRED_YN,',
'       CEILING_CH1_AMOUNT,',
'       CEILING_CH2_REQUIRED_YN,',
'       CEILING_CH2_AMOUNT,',
'       BUDGET_PROPOSAL_PKG.SECTOR_allocated(pLAN_ID, SECTOR_ID, 134) CH2_Allocated_Sector,',
'',
'       CEILING_CH3_REQUIRED_YN,',
'       CEILING_CH3_AMOUNT,',
'       BUDGET_PROPOSAL_PKG.SECTOR_allocated(pLAN_ID, SECTOR_ID, 135) CH3_Allocated_Sector,',
'',
'       CEILING_CH6_REQUIRED_YN,',
'       CEILING_CH6_AMOUNT,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       (select COUNT(*) ',
'       from budget_proposal_cost_centers_plans cc',
'       where cc.plan_id = p.plan_id',
'       and cc.sector_id = p.sector_id) Cost_centers_count',
'  from BUDGET_PROPOSAL_SECTORS_PLANS p',
'  where PLAN_ID = :P85_PLAN_ID;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P85_PLAN_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P85_PLAN_ID'
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
 p_id=>wwv_flow_api.id(51239052427570206)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>162044979961614426
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51238984011570205)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51238863819570204)
,p_db_column_name=>'PLAN_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Plan Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51238745174570203)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Sector'
,p_column_link=>'f?p=&APP_ID.:92:&SESSION.::&DEBUG.::P92_ID,P92_PROPOSAL_YEAR:#ID#,&P85_PROPOSAL_YEAR.'
,p_column_linktext=>'#SECTOR_ID#'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1216232005294941)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51238694554570202)
,p_db_column_name=>'SECTOR_INSTRUCTIONS'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Sector Instructions'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51238579111570201)
,p_db_column_name=>'COMMENTS'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51238458557570200)
,p_db_column_name=>'STATUS'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51238408073570199)
,p_db_column_name=>'ALLOW_ADD_COST_CENTER_YN'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Allow Add Cost Center ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51238283882570198)
,p_db_column_name=>'ALLOW_ADD_PROJECT_YN'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Allow Add Project ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51238229821570197)
,p_db_column_name=>'ALLOW_ADD_TASK_YN'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Allow Add Task ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51238076104570196)
,p_db_column_name=>'CEILING_CH1_REQUIRED_YN'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Ceiling Ch1 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P85_PLAN_TYPE = ''M'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51237934101570195)
,p_db_column_name=>'CEILING_CH1_AMOUNT'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'CH1 Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P85_PLAN_TYPE = ''M'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51237893548570194)
,p_db_column_name=>'CEILING_CH2_REQUIRED_YN'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Ceiling Ch2 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51237816310570193)
,p_db_column_name=>'CEILING_CH2_AMOUNT'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Opex (CH2) Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51237653130570192)
,p_db_column_name=>'CEILING_CH3_REQUIRED_YN'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Ceiling Ch3 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51237582649570191)
,p_db_column_name=>'CEILING_CH3_AMOUNT'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Capex (CH3) Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51237494885570190)
,p_db_column_name=>'CEILING_CH6_REQUIRED_YN'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Ceiling Ch6 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P85_PLAN_TYPE = ''C'''
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
 p_id=>wwv_flow_api.id(51237392040570189)
,p_db_column_name=>'CEILING_CH6_AMOUNT'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'CH6 Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P85_PLAN_TYPE = ''C'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51237276957570188)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51237194280570187)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51237088017570186)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51236958991570185)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50265300329516630)
,p_db_column_name=>'COST_CENTERS_COUNT'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Cost Centers'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47419774557149808)
,p_db_column_name=>'CH2_ALLOCATED_SECTOR'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Opex (CH2) Allocated'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47419707176149807)
,p_db_column_name=>'CH3_ALLOCATED_SECTOR'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Capex (CH3) Allocated'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(50799486499467586)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1624846'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SECTOR_ID:CEILING_CH2_AMOUNT:CH2_ALLOCATED_SECTOR:CEILING_CH3_AMOUNT:CH3_ALLOCATED_SECTOR:COST_CENTERS_COUNT:ALLOW_ADD_COST_CENTER_YN:ALLOW_ADD_PROJECT_YN:ALLOW_ADD_TASK_YN:STATUS:'
,p_sort_column_1=>'SECTOR_ID'
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
,p_sum_columns_on_break=>'CEILING_CH2_AMOUNT:CH2_ALLOCATED_SECTOR:CH3_ALLOCATED_SECTOR:CEILING_CH3_AMOUNT:COST_CENTERS_COUNT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(49277320486009306)
,p_plug_name=>'Plan Instructions'
,p_parent_plug_id=>wwv_flow_api.id(54386535015888343)
,p_icon_css_classes=>'fa-braille'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P85_PLAN_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(49277224893009305)
,p_plug_name=>'Plan Instructions Report'
,p_parent_plug_id=>wwv_flow_api.id(49277320486009306)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       PLAN_ID,',
'       rownum,',
'       INSTRUCTION,',
'       INSTRUCTION_AR,',
'       COMMENTS,',
'       STATUS,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON',
'  from BUDGET_PROPOSAL_SECTORS_PLAN_INSTRUCTIONS',
'  where plan_id = :P85_PLAN_ID',
'  order by id'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P85_PLAN_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Plan Instructions Report'
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
 p_id=>wwv_flow_api.id(49277127240009304)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_control_break=>'N'
,p_show_computation=>'N'
,p_show_aggregate=>'N'
,p_show_chart=>'N'
,p_show_group_by=>'N'
,p_show_pivot=>'N'
,p_show_flashback=>'N'
,p_show_help=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>164006905149175328
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49276958090009303)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49276860966009302)
,p_db_column_name=>'PLAN_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Plan'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(49565096744743668)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49275502982009288)
,p_db_column_name=>'ROWNUM'
,p_display_order=>30
,p_column_identifier=>'J'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49276829810009301)
,p_db_column_name=>'INSTRUCTION'
,p_display_order=>40
,p_column_identifier=>'C'
,p_column_label=>'Instruction'
,p_column_link=>'f?p=&APP_ID.:99:&SESSION.::&DEBUG.::P99_ID:#ID#'
,p_column_linktext=>'#INSTRUCTION#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46728851248448228)
,p_db_column_name=>'INSTRUCTION_AR'
,p_display_order=>50
,p_column_identifier=>'K'
,p_column_label=>'Instruction Arabic'
,p_column_type=>'STRING'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49276696299009300)
,p_db_column_name=>'COMMENTS'
,p_display_order=>60
,p_column_identifier=>'D'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49276610862009299)
,p_db_column_name=>'STATUS'
,p_display_order=>70
,p_column_identifier=>'E'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49276448405009298)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>80
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49276364698009297)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>90
,p_column_identifier=>'G'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49276293585009296)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>100
,p_column_identifier=>'H'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49276153824009295)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>110
,p_column_identifier=>'I'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(49210082026268680)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1640740'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ROWNUM:INSTRUCTION:INSTRUCTION_AR:COMMENTS:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(49275261408009286)
,p_plug_name=>'Plan Milestones'
,p_parent_plug_id=>wwv_flow_api.id(54386535015888343)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P85_PLAN_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(49275189091009285)
,p_plug_name=>'Plan Milestones Report'
,p_parent_plug_id=>wwv_flow_api.id(49275261408009286)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select MILESTONE_ID,',
'       PLAN_ID,',
'       MILESTONE_NAME,',
'       DESCRIPTION,',
'       MILESTONE_TRAGET_DATE,',
'       MILESTONE_CLOSE_DATE,',
'       MILESTONE_START_DATE,',
'       MILESTONE_END_DATE,',
'       MILESTONE_OWNER,',
'       CLOSE_NOTES,',
'       STATUS,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON',
'  from BUDGET_PROPOSAL_PLAN_MILESTONES',
'  where plan_id = :P85_PLAN_ID',
'  order by MILESTONE_TRAGET_DATE'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P85_PLAN_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Plan Milestones Report'
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
 p_id=>wwv_flow_api.id(49275117204009284)
,p_max_row_count=>'1000000'
,p_allow_save_rpt_public=>'Y'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_control_break=>'N'
,p_show_computation=>'N'
,p_show_aggregate=>'N'
,p_show_chart=>'N'
,p_show_group_by=>'N'
,p_show_pivot=>'N'
,p_show_notify=>'Y'
,p_show_flashback=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>164008915185175348
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49274956667009283)
,p_db_column_name=>'MILESTONE_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Milestone Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49274857626009282)
,p_db_column_name=>'PLAN_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Plan'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(49565096744743668)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49202385080443431)
,p_db_column_name=>'MILESTONE_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Milestone'
,p_column_link=>'f?p=&APP_ID.:100:&SESSION.::&DEBUG.::P100_MILESTONE_ID:#MILESTONE_ID#'
,p_column_linktext=>'#MILESTONE_NAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49202298725443430)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49202148360443429)
,p_db_column_name=>'MILESTONE_TRAGET_DATE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Target Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49202051668443428)
,p_db_column_name=>'MILESTONE_CLOSE_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Close Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49201951164443427)
,p_db_column_name=>'MILESTONE_START_DATE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Milestone Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49201869893443426)
,p_db_column_name=>'MILESTONE_END_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Milestone End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49201777698443425)
,p_db_column_name=>'MILESTONE_OWNER'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Owner'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49201634437443424)
,p_db_column_name=>'CLOSE_NOTES'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Close Note'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49201627684443423)
,p_db_column_name=>'STATUS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49201437763443422)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49201429388443421)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49201244687443420)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(49201171896443419)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(49168176968389352)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1641159'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'MILESTONE_NAME:MILESTONE_OWNER:MILESTONE_TRAGET_DATE:MILESTONE_CLOSE_DATE:CLOSE_NOTES:STATUS:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(47700701115036917)
,p_plug_name=>'Documents'
,p_parent_plug_id=>wwv_flow_api.id(54386535015888343)
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>70
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P85_PLAN_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(47700607684036916)
,p_plug_name=>'Documents report'
,p_parent_plug_id=>wwv_flow_api.id(47700701115036917)
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
'  where PLAN_ID = :P85_PLAN_ID',
'  and sector_id is null',
'  and cost_center is null',
'  order by UPDATED desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P85_PLAN_ID'
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
 p_id=>wwv_flow_api.id(47700510620036915)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No documents available'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>165583521769147717
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47700381810036914)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47699858081036909)
,p_db_column_name=>'FILENAME'
,p_display_order=>20
,p_column_identifier=>'F'
,p_column_label=>'File'
,p_column_link=>'f?p=&APP_ID.:102:&SESSION.::&DEBUG.::P102_ID,P102_STATUS:#ID#,&P85_STATUS.'
,p_column_linktext=>'#FILENAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47700243300036913)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>30
,p_column_identifier=>'B'
,p_column_label=>'Document Version'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47700226026036912)
,p_db_column_name=>'PLAN_ID'
,p_display_order=>40
,p_column_identifier=>'C'
,p_column_label=>'Proposal Plan'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(49565096744743668)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47700046134036911)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>50
,p_column_identifier=>'D'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1216232005294941)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47699978228036910)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47699791304036908)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47699641820036907)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47699629577036906)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47699497830036905)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47699368475036904)
,p_db_column_name=>'TAGS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47699259367036903)
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
 p_id=>wwv_flow_api.id(47699222214036902)
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
 p_id=>wwv_flow_api.id(47699073754036901)
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
 p_id=>wwv_flow_api.id(47698941089036900)
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
 p_id=>wwv_flow_api.id(47698858742036899)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47698810870036898)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DOWNLOAD:BUDGET_PROPOSAL_PLANS_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(47574988933128667)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1657091'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:ROW_VERSION_NUMBER:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(54340309161888305)
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
 p_id=>wwv_flow_api.id(54359713779888322)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(54340309161888305)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:84:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(51236882874570184)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(50262332794516601)
,p_button_name=>'ADD_SECTOR'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Add Sector'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:92:&SESSION.::&DEBUG.:92:P92_PLAN_ID,P92_PROPOSAL_YEAR:&P85_PLAN_ID.,&P85_PROPOSAL_YEAR.'
,p_button_condition=>':P85_STATUS  in (''Draft'' , ''Returned'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(49276034197009294)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(49277320486009306)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Add Instruction'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:99:&SESSION.::&DEBUG.::P99_PLAN_ID:&P85_PLAN_ID.'
,p_button_condition=>':P85_STATUS  in (''Draft'' , ''Returned'')'
,p_button_condition_type=>'SQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(49201129587443418)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(49275261408009286)
,p_button_name=>'New_MILESTONE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'New Milestone'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:100:&SESSION.::&DEBUG.:100:P100_PLAN_ID:&P85_PLAN_ID.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(47698635460036897)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(47700701115036917)
,p_button_name=>'New_document'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'New Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:102:&SESSION.::&DEBUG.:102:P102_PLAN_ID,P102_STATUS:&P85_PLAN_ID.,&P85_STATUS.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(54358893698888320)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(54340309161888305)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--large'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition=>':P85_STATUS in (''Draft'' , ''Returned'') and :P85_PLAN_ID is not null'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(54358442521888320)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(54340309161888305)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>':P85_STATUS in (''Draft'' , ''Returned'') and :P85_PLAN_ID is not null'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(54358091675888320)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(54340309161888305)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P85_PLAN_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(49200478702443412)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(54340309161888305)
,p_button_name=>'Submit'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Submit'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>':P85_STATUS in (''Draft'' , ''Returned'') and :P85_PLAN_ID is not null'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-send-o'
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
 p_id=>wwv_flow_api.id(47361538979656819)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(54340309161888305)
,p_button_name=>'Withdraw'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Withdraw'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>':P85_STATUS not in (''Draft'' , ''Returned'') and :P85_PLAN_ID is not null'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(50579341351911931)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(54386535015888343)
,p_button_name=>'PLAN_SCOPE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--link:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Plan Scope'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:93:&SESSION.::&DEBUG.::P93_PLAN_ID,P93_PAGE_FROM:&P85_PLAN_ID.,85'
,p_icon_css_classes=>'fa-file-text-o'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(47420005686149810)
,p_branch_name=>'Go to Submission Form 104'
,p_branch_action=>'f?p=&APP_ID.:104:&SESSION.::&DEBUG.:104:P104_PLAN_ID,P104_PLAN_NAME:&P85_PLAN_ID.,&P85_PLAN_NAME.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(49200478702443412)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(54357749049888320)
,p_branch_name=>'Go To Page 84'
,p_branch_action=>'f?p=&APP_ID.:84:&SESSION.::&DEBUG.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54386165233888343)
,p_name=>'P85_PLAN_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(54311018870782493)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_source=>'PLAN_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54385737795888339)
,p_name=>'P85_PLAN_NAME'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(54311018870782493)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_prompt=>'Plan Name'
,p_source=>'PLAN_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>128
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54385428175888337)
,p_name=>'P85_PROPOSAL_YEAR'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(54311018870782493)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select extract(Year from sysdate) + 1',
'from dual;'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Proposal Year'
,p_source=>'PROPOSAL_YEAR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>5
,p_cMaxlength=>4
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54385014275888337)
,p_name=>'P85_PLAN_DURATION'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(54311018870782493)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_item_default=>'4'
,p_prompt=>'Plan Duration'
,p_post_element_text=>'<p>&nbsp;<strong>Years</strong></p>'
,p_source=>'PLAN_DURATION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>5
,p_cMaxlength=>255
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54384584182888336)
,p_name=>'P85_PLAN_VERSION'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(54310877241782492)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_item_default=>'1'
,p_prompt=>'Version'
,p_source=>'PLAN_VERSION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54384148675888336)
,p_name=>'P85_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(54310877241782492)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_item_default=>'Draft'
,p_prompt=>'Status'
,p_source=>'STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54383786027888336)
,p_name=>'P85_SUBMITTED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>360
,p_item_plug_id=>wwv_flow_api.id(54310877241782492)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_prompt=>'Submitted By'
,p_source=>'SUBMITTED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_grid_label_column_span=>4
,p_display_when=>'P85_STATUS'
,p_display_when2=>'In Process'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54383365516888336)
,p_name=>'P85_SUBMITTED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>370
,p_item_plug_id=>wwv_flow_api.id(54310877241782492)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_prompt=>'Submitted On'
,p_source=>'SUBMITTED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>32
,p_cMaxlength=>255
,p_grid_label_column_span=>4
,p_display_when=>'P85_STATUS'
,p_display_when2=>'In Process'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'button'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54382586051888334)
,p_name=>'P85_FINAL_APPROVED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>380
,p_item_plug_id=>wwv_flow_api.id(54310877241782492)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_prompt=>'Final Approved By'
,p_source=>'FINAL_APPROVED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_grid_label_column_span=>4
,p_display_when=>'P85_STATUS'
,p_display_when2=>'Approved'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54382196639888334)
,p_name=>'P85_FINAL_APPROVED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>390
,p_item_plug_id=>wwv_flow_api.id(54310877241782492)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_prompt=>'Final Approved On'
,p_source=>'FINAL_APPROVED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>4
,p_display_when=>'P85_STATUS'
,p_display_when2=>'Approved'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54381393288888334)
,p_name=>'P85_CANCELLED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>400
,p_item_plug_id=>wwv_flow_api.id(54310877241782492)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_prompt=>'Cancelled By'
,p_source=>'CANCELLED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_grid_label_column_span=>4
,p_display_when=>'P85_STATUS'
,p_display_when2=>'Cancelled'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54380985624888334)
,p_name=>'P85_CANCELLED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>410
,p_item_plug_id=>wwv_flow_api.id(54310877241782492)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_prompt=>'Cancelled On'
,p_source=>'CANCELLED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>4
,p_display_when=>'P85_STATUS'
,p_display_when2=>'Cancelled'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54380203568888333)
,p_name=>'P85_CANCEL_REASON'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>420
,p_item_plug_id=>wwv_flow_api.id(54310877241782492)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_prompt=>'Cancel Reason'
,p_source=>'CANCEL_REASON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>4
,p_display_when=>'P85_STATUS'
,p_display_when2=>'Cancelled'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54379807082888333)
,p_name=>'P85_PLAN_CH1_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(58290137447395283)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_prompt=>'Propose For Chapter1 ?'
,p_source=>'PLAN_CH1_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54379375959888333)
,p_name=>'P85_CEILING_CH1_REQUIRED_YN'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(58290137447395283)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_item_default=>'N'
,p_prompt=>'Ceiling Required ?'
,p_source=>'CEILING_CH1_REQUIRED_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54379014446888333)
,p_name=>'P85_CEILING_CH1_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(58290137447395283)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_prompt=>'Ceiling Ch1 Amount'
,p_post_element_text=>'<p>&nbsp;<strong>AED</strong></p>'
,p_source=>'CEILING_CH1_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54378630901888332)
,p_name=>'P85_PLAN_CH2_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(58290045759395282)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_prompt=>'Propose For Chapter2 ?'
,p_source=>'PLAN_CH2_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54378149648888332)
,p_name=>'P85_CEILING_CH2_REQUIRED_YN'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(58290045759395282)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_item_default=>'N'
,p_prompt=>'Ceiling  Required ?'
,p_source=>'CEILING_CH2_REQUIRED_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54377787378888332)
,p_name=>'P85_CEILING_CH2_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(58290045759395282)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_prompt=>'Ceiling Ch2 Amount'
,p_post_element_text=>'<p>&nbsp;<strong>AED</strong></p>'
,p_source=>'CEILING_CH2_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54377425267888332)
,p_name=>'P85_PLAN_CH3_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(54314762632782531)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_prompt=>'Propose For Chapter3 ?'
,p_source=>'PLAN_CH3_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54376983898888332)
,p_name=>'P85_CEILING_CH3_REQUIRED_YN'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(54314762632782531)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_item_default=>'N'
,p_prompt=>'Ceiling Required ?'
,p_source=>'CEILING_CH3_REQUIRED_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54376554900888331)
,p_name=>'P85_CEILING_CH3_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(54314762632782531)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_prompt=>'Ceiling Ch3 Amount'
,p_post_element_text=>'<p>&nbsp;<strong>AED</strong></p>'
,p_source=>'CEILING_CH3_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54376197984888331)
,p_name=>'P85_PLAN_CH6_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(54314682230782530)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_prompt=>'Propose For Chapter6 ?'
,p_source=>'PLAN_CH6_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54375780715888331)
,p_name=>'P85_CEILING_CH6_REQUIRED_YN'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(54314682230782530)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_item_default=>'N'
,p_prompt=>'Ceiling Required ?'
,p_source=>'CEILING_CH6_REQUIRED_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54375384284888331)
,p_name=>'P85_CEILING_CH6_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(54314682230782530)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_prompt=>'Ceiling Ch6 Amount'
,p_post_element_text=>'<p>&nbsp;<strong>AED</strong></p>'
,p_source=>'CEILING_CH6_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54374975173888331)
,p_name=>'P85_PLAN_REVENUE_YN'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(54314536291782529)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_item_default=>'N'
,p_prompt=>'Plan For Revenue ?'
,p_source=>'PLAN_REVENUE_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54374606522888330)
,p_name=>'P85_FUTURE2_USED'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(54310814873782491)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_prompt=>'Future2 Used'
,p_source=>'FUTURE2_USED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'FUTURE2 LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct FUTURE2_DESCRIPTION ,FUTURE2 ',
'from dct_gl_code_combinations_all',
'order by 2'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_cMaxlength=>50
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'Y'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_11=>':'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54374149088888330)
,p_name=>'P85_ALLOW_ADD_COST_CENTER_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(54310814873782491)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_item_default=>'N'
,p_prompt=>'Allow Add Cost Center ?'
,p_source=>'ALLOW_ADD_COST_CENTER_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54373786831888330)
,p_name=>'P85_ALLOW_ADD_PROJECT_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(54310814873782491)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_item_default=>'N'
,p_prompt=>'Allow Add Project ?'
,p_source=>'ALLOW_ADD_PROJECT_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54373338790888330)
,p_name=>'P85_ALLOW_ADD_TASK_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(54310814873782491)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_item_default=>'N'
,p_prompt=>'Allow Add Task ?'
,p_source=>'ALLOW_ADD_TASK_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54372988928888330)
,p_name=>'P85_CREATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_api.id(54314523766782528)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_prompt=>'Created By'
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54372540453888329)
,p_name=>'P85_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>320
,p_item_plug_id=>wwv_flow_api.id(54314523766782528)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_prompt=>'Created On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54371825141888329)
,p_name=>'P85_UPDATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>330
,p_item_plug_id=>wwv_flow_api.id(54314523766782528)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_prompt=>'Updated By'
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54371367110888329)
,p_name=>'P85_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>340
,p_item_plug_id=>wwv_flow_api.id(54314523766782528)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_prompt=>'Updated On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54370625683888328)
,p_name=>'P85_COPY_FROM_PLAN_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(54311018870782493)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_prompt=>'Copy From'
,p_source=>'COPY_FROM_PLAN_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_grid_label_column_span=>3
,p_display_when=>'P85_COPY_FROM_PLAN_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50732799438315228)
,p_name=>'P85_PLAN_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(54311018870782493)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_prompt=>'Plan Type'
,p_source=>'PLAN_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'BUDGET PROPOSAL PLAN TYPES'
,p_lov=>'.'||wwv_flow_api.id(50661192721222067)||'.'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p><span style="color: #0000ff;"><strong>Expenses:</strong></span> Include Projects for Chapter 2 and 3 (Opex and Capex).&nbsp;</p>',
'<p><strong><span style="color: #0000ff;">Manpower:</span></strong> Include Chapter 1.</p>',
'<p><strong><span style="color: #0000ff;">Revenue:</span></strong> Include Ar Transaction types (By Cost Center) and revenue type (By GL).</p>',
'<p><strong><span style="color: #0000ff;">GL:</span></strong> include GL combinations By Cost center and GL Account without projects.</p>'))
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(49277416688009307)
,p_name=>'P85_DEADLINE_SUBMISSION_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(54311018870782493)
,p_item_source_plug_id=>wwv_flow_api.id(54386535015888343)
,p_prompt=>'Deadline Submission Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'DEADLINE_SUBMISSION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_help_text=>'<p>Submission of the budget proposal should be <span style="text-decoration: underline; color: #ff0000;"><em>no later than this date</em></span>, any late submission will not be considered part of the proposal</p>'
,p_attribute_04=>'both'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(54382901754888335)
,p_validation_name=>'P85_SUBMITTED_ON must be timestamp'
,p_validation_sequence=>70
,p_validation=>'P85_SUBMITTED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(54383365516888336)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(54381710286888334)
,p_validation_name=>'P85_FINAL_APPROVED_ON must be timestamp'
,p_validation_sequence=>90
,p_validation=>'P85_FINAL_APPROVED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(54382196639888334)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(54380478189888333)
,p_validation_name=>'P85_CANCELLED_ON must be timestamp'
,p_validation_sequence=>110
,p_validation=>'P85_CANCELLED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(54380985624888334)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(54372079829888329)
,p_validation_name=>'P85_CREATED_ON must be timestamp'
,p_validation_sequence=>310
,p_validation=>'P85_CREATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(54372540453888329)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(54370869732888329)
,p_validation_name=>'P85_UPDATED_ON must be timestamp'
,p_validation_sequence=>330
,p_validation=>'P85_UPDATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(54371367110888329)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(54314267364782526)
,p_name=>'PLAN_CH1_YN DA'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P85_PLAN_CH1_YN'
,p_condition_element=>'P85_PLAN_CH1_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
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
 p_id=>wwv_flow_api.id(54314142632782525)
,p_event_id=>wwv_flow_api.id(54314267364782526)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P85_CEILING_CH1_REQUIRED_YN'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54313884920782522)
,p_event_id=>wwv_flow_api.id(54314267364782526)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P85_CEILING_CH1_REQUIRED_YN'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54314037427782524)
,p_event_id=>wwv_flow_api.id(54314267364782526)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P85_CEILING_CH1_REQUIRED_YN'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(54313771650782521)
,p_name=>'CEILING_CH1_REQUIRED_YN DA'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P85_CEILING_CH1_REQUIRED_YN'
,p_condition_element=>'P85_CEILING_CH1_REQUIRED_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54313726021782520)
,p_event_id=>wwv_flow_api.id(54313771650782521)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P85_CEILING_CH1_AMOUNT'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54313590331782519)
,p_event_id=>wwv_flow_api.id(54313771650782521)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P85_CEILING_CH1_AMOUNT'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54313485870782518)
,p_event_id=>wwv_flow_api.id(54313771650782521)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P85_CEILING_CH1_AMOUNT'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(54313347819782517)
,p_name=>'PLAN_CH2_YN DA'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P85_PLAN_CH2_YN'
,p_condition_element=>'P85_PLAN_CH2_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54313295112782516)
,p_event_id=>wwv_flow_api.id(54313347819782517)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P85_CEILING_CH2_REQUIRED_YN'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54313194098782515)
,p_event_id=>wwv_flow_api.id(54313347819782517)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P85_CEILING_CH2_REQUIRED_YN'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54313056523782514)
,p_event_id=>wwv_flow_api.id(54313347819782517)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P85_CEILING_CH2_REQUIRED_YN'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(54313013179782513)
,p_name=>'CEILING_CH2_REQUIRED_YN DA'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P85_CEILING_CH2_REQUIRED_YN'
,p_condition_element=>'P85_CEILING_CH2_REQUIRED_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54312874677782512)
,p_event_id=>wwv_flow_api.id(54313013179782513)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P85_CEILING_CH2_AMOUNT'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54312764176782511)
,p_event_id=>wwv_flow_api.id(54313013179782513)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P85_CEILING_CH2_AMOUNT'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54312717898782510)
,p_event_id=>wwv_flow_api.id(54313013179782513)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P85_CEILING_CH2_AMOUNT'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(54312567984782509)
,p_name=>'PLAN_CH3_YN DA'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P85_PLAN_CH3_YN'
,p_condition_element=>'P85_PLAN_CH3_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54312451338782508)
,p_event_id=>wwv_flow_api.id(54312567984782509)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P85_CEILING_CH3_REQUIRED_YN'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54312405473782507)
,p_event_id=>wwv_flow_api.id(54312567984782509)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P85_CEILING_CH3_REQUIRED_YN'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54312270251782506)
,p_event_id=>wwv_flow_api.id(54312567984782509)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P85_CEILING_CH3_REQUIRED_YN'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(54312207986782505)
,p_name=>'CEILING_CH3_REQUIRED_YN DA'
,p_event_sequence=>60
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P85_CEILING_CH3_REQUIRED_YN'
,p_condition_element=>'P85_CEILING_CH3_REQUIRED_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54312059185782504)
,p_event_id=>wwv_flow_api.id(54312207986782505)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P85_CEILING_CH3_AMOUNT'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54311934851782503)
,p_event_id=>wwv_flow_api.id(54312207986782505)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P85_CEILING_CH3_AMOUNT'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54311859179782502)
,p_event_id=>wwv_flow_api.id(54312207986782505)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P85_CEILING_CH3_AMOUNT'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(54311761198782501)
,p_name=>'PLAN_CH6_YN DA'
,p_event_sequence=>70
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P85_PLAN_CH6_YN'
,p_condition_element=>'P85_PLAN_CH6_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54311672362782500)
,p_event_id=>wwv_flow_api.id(54311761198782501)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P85_CEILING_CH6_REQUIRED_YN'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54311548882782499)
,p_event_id=>wwv_flow_api.id(54311761198782501)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P85_CEILING_CH6_REQUIRED_YN'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54311460303782498)
,p_event_id=>wwv_flow_api.id(54311761198782501)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P85_CEILING_CH6_REQUIRED_YN'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(54311355732782497)
,p_name=>'CEILING_CH6_REQUIRED_YN DA'
,p_event_sequence=>80
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P85_CEILING_CH6_REQUIRED_YN'
,p_condition_element=>'P85_CEILING_CH6_REQUIRED_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54311293173782496)
,p_event_id=>wwv_flow_api.id(54311355732782497)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P85_CEILING_CH6_AMOUNT'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54311176980782495)
,p_event_id=>wwv_flow_api.id(54311355732782497)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P85_CEILING_CH6_AMOUNT'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(54311087616782494)
,p_event_id=>wwv_flow_api.id(54311355732782497)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P85_CEILING_CH6_AMOUNT'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(50730932593315210)
,p_name=>'ADD_SECTOR DA'
,p_event_sequence=>90
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(51236882874570184)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50265406861516631)
,p_event_id=>wwv_flow_api.id(50730932593315210)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(54386535015888343)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50730906415315209)
,p_event_id=>wwv_flow_api.id(50730932593315210)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(56090729019222995)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(49275423337009287)
,p_event_id=>wwv_flow_api.id(50730932593315210)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(50265113996516628)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(50544189032650683)
,p_name=>'Sectors DA'
,p_event_sequence=>100
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(56090729019222995)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50544106909650682)
,p_event_id=>wwv_flow_api.id(50544189032650683)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(56090729019222995)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(49277468252009308)
,p_event_id=>wwv_flow_api.id(50544189032650683)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(50265113996516628)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(49275979511009293)
,p_name=>'Plan Instructions DA'
,p_event_sequence=>110
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(49276034197009294)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(49275871861009292)
,p_event_id=>wwv_flow_api.id(49275979511009293)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(49277224893009305)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(49275772027009291)
,p_name=>'Plan Instructions DA2'
,p_event_sequence=>120
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(49277224893009305)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(49275632420009290)
,p_event_id=>wwv_flow_api.id(49275772027009291)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(49277224893009305)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(49201028631443417)
,p_name=>'New_MILESTONE DA'
,p_event_sequence=>130
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(49201129587443418)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(49200867590443416)
,p_event_id=>wwv_flow_api.id(49201028631443417)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(49275189091009285)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(49200798354443415)
,p_name=>'New_MILESTONE DA2'
,p_event_sequence=>140
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(49275189091009285)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(49200676068443414)
,p_event_id=>wwv_flow_api.id(49200798354443415)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(49275189091009285)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(47698419380036894)
,p_name=>'New_document DA'
,p_event_sequence=>150
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(47698635460036897)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(47698267791036893)
,p_event_id=>wwv_flow_api.id(47698419380036894)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(47700607684036916)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(47698145273036892)
,p_name=>'Documents report DA'
,p_event_sequence=>160
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(47700607684036916)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(47698074644036891)
,p_event_id=>wwv_flow_api.id(47698145273036892)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(47700607684036916)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(54356894415888319)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(54386535015888343)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Proposal Plan Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(54357260900888319)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(54386535015888343)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Proposal Plan Details'
);
wwv_flow_api.component_end;
end;
/
