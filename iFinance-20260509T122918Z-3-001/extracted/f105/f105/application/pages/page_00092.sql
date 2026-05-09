prompt --application/pages/page_00092
begin
--   Manifest
--     PAGE: 00092
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
 p_id=>92
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Budget Proposal Plan Sector Assignment'
,p_alias=>'BUDGET-PROPOSAL-PLAN-SECTOR-ASSIGNMENT'
,p_step_title=>'Budget Proposal Plan Sector Assignment'
,p_allow_duplicate_submissions=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'SQL_EXPRESSION'
,p_read_only_when=>':P92_STATUS not in (''Draft'' , ''Returned'')'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231105093729'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(50753206213315708)
,p_plug_name=>'Budget Proposal Plan Sector Assignment'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99730028608410735)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'BUDGET_PROPOSAL_SECTORS_PLANS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(50733061967315231)
,p_plug_name=>'H1'
,p_parent_plug_id=>wwv_flow_api.id(50753206213315708)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(50732972828315230)
,p_plug_name=>'Sector Plan Control'
,p_parent_plug_id=>wwv_flow_api.id(50753206213315708)
,p_icon_css_classes=>'fa-adjust'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(50732873761315229)
,p_plug_name=>'Audit'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P92_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(50231700078855818)
,p_plug_name=>'Sector Plan Scope'
,p_icon_css_classes=>'fa-list-ul'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--stacked:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(50730778100315208)
,p_plug_name=>'Sector Cost Centers'
,p_parent_plug_id=>wwv_flow_api.id(50231700078855818)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(50730643933315207)
,p_plug_name=>'Sector Cost Centers Report'
,p_parent_plug_id=>wwv_flow_api.id(50730778100315208)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    cc_plan_id,',
'    cc_plan_id cc_plan_id_h,',
'    cc_code,',
'    cc_name_en,',
'    ch2_ceiling,',
'    ch2_allocated,',
'    ch3_ceiling,',
'    ch3_allocated,',
'    round(ch2_allocated / decode(ch2_ceiling, 0, 1, ch2_ceiling)) * 100 ch2_pct,',
'    round(ch3_allocated / decode(ch3_ceiling, 0, 1, ch3_ceiling)) * 100 ch3_pct,',
'    status',
'FROM',
'    (',
'        SELECT',
'            id                                                                       cc_plan_id,',
'            cost_center                                                              cc_code,',
'            user_details.get_cost_center_name(cost_center)                           cc_name_en,',
'            budget_proposal_pkg.cc_chapter_celing(:p92_plan_id, cost_center, 134)    ch2_ceiling,',
'            budget_proposal_pkg.cc_chapter_allocated(:p92_plan_id, cost_center, 134) ch2_allocated,',
'            budget_proposal_pkg.cc_chapter_celing(:p92_plan_id, cost_center, 135)    ch3_ceiling,',
'            budget_proposal_pkg.cc_chapter_allocated(:p92_plan_id, cost_center, 135) ch3_allocated,',
'            status',
'        FROM',
'            budget_proposal_cost_centers_plans',
'        WHERE',
'            sector_id = :p92_sector_id',
'        ORDER BY',
'            cost_center',
'    );'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P92_SECTOR_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P92_ID'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Sector Cost Centers Report'
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
,p_plug_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/*',
'select CC_CODE, CC_NAME_EN, CH2_CEILING, CH2_ALLOCATED, CH3_CEILING, CH3_ALLOCATED, Round(CH2_ALLOCATED/decode(CH2_CEILING,0,1,CH2_CEILING)) CH2_PCT',
'                                                                                  , round(CH3_ALLOCATED/decode(CH3_CEILING,0,1,CH3_CEILING)) CH3_PCT',
'from ',
'(SELECT CC_CODE, CC_NAME_EN ',
'    , budget_proposal_pkg.cc_chapter_celing(:P92_PLAN_ID, CC_CODE, 134) CH2_Ceiling',
'    , budget_proposal_pkg.cc_chapter_allocated(:P92_PLAN_ID, CC_CODE, 134) CH2_Allocated',
'    ',
'    , budget_proposal_pkg.cc_chapter_celing(:P92_PLAN_ID, CC_CODE, 135) CH3_Ceiling',
'    , budget_proposal_pkg.cc_chapter_allocated(:P92_PLAN_ID, CC_CODE, 135) CH3_Allocated',
'FROM dct_cost_centers',
'WHERE SECTOR_ORG_ID   = :P92_SECTOR_ID',
'AND STATUS =  ''A''',
'and sysdate between nvl(start_date , sysdate - 10)',
'            and nvl(end_date , sysdate + 10)',
'order by cc_code)',
'*/'))
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(50730582099315206)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>162553450289869426
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47359661683656800)
,p_db_column_name=>'CC_PLAN_ID'
,p_display_order=>10
,p_column_identifier=>'I'
,p_column_label=>'Delete'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50730481592315205)
,p_db_column_name=>'CC_CODE'
,p_display_order=>20
,p_column_identifier=>'A'
,p_column_label=>'Cost Center Code'
,p_column_link=>'f?p=&APP_ID.:97:&SESSION.::&DEBUG.:97:P97_PLAN_ID,P97_COST_CENTER,P97_PAGE_FROM,P97_SECTOR_ID,P97_ID,P97_SECTOR_PLAN_ID,P97_CC_PLAN_ID:&P92_PLAN_ID.,#CC_CODE#,92,&P92_SECTOR_ID.,#CC_PLAN_ID#,&P92_ID.,#CC_PLAN_ID#'
,p_column_linktext=>'#CC_CODE#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50730388760315204)
,p_db_column_name=>'CC_NAME_EN'
,p_display_order=>30
,p_column_identifier=>'B'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47565994697766405)
,p_db_column_name=>'CH2_CEILING'
,p_display_order=>40
,p_column_identifier=>'C'
,p_column_label=>'Opex (CH2) Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47565872900766404)
,p_db_column_name=>'CH2_ALLOCATED'
,p_display_order=>50
,p_column_identifier=>'D'
,p_column_label=>'Opex (CH2) Allocated'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47565810685766403)
,p_db_column_name=>'CH3_CEILING'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'Capex (CH3) Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47565660820766402)
,p_db_column_name=>'CH3_ALLOCATED'
,p_display_order=>70
,p_column_identifier=>'F'
,p_column_label=>'Capex (CH3) Allocated'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47565593344766401)
,p_db_column_name=>'CH2_PCT'
,p_display_order=>80
,p_column_identifier=>'G'
,p_column_label=>'Opex Progress'
,p_column_type=>'NUMBER'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'PCT_GRAPH:::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47565438537766400)
,p_db_column_name=>'CH3_PCT'
,p_display_order=>90
,p_column_identifier=>'H'
,p_column_label=>'Capex Progress'
,p_column_type=>'NUMBER'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'PCT_GRAPH:::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47243869744850626)
,p_db_column_name=>'STATUS'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46726779141448207)
,p_db_column_name=>'CC_PLAN_ID_H'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Delete'
,p_column_link=>'#'
,p_column_linktext=>'<span aria-hidden="true" class="t-Icon fa fa-trash-o"></span>'
,p_column_link_attr=>'data-cc=#CC_CODE# data-id=#CC_PLAN_ID# title="Delete #CC_CODE# Cost Center" class="del t-Button t-Button--noLabel t-Button--icon"'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(50603401987888070)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1626807'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CC_CODE:CC_NAME_EN:CH2_CEILING:CH2_ALLOCATED:CH2_PCT:CH3_CEILING:CH3_ALLOCATED:CH3_PCT:STATUS::CC_PLAN_ID_H'
,p_sum_columns_on_break=>'CH2_CEILING:CH2_ALLOCATED:CH3_CEILING:CH3_ALLOCATED'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(50548342566650725)
,p_plug_name=>'Sector Planners'
,p_parent_plug_id=>wwv_flow_api.id(50730778100315208)
,p_icon_css_classes=>'fa-users'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(50548236689650724)
,p_plug_name=>'Sector Planners Report'
,p_parent_plug_id=>wwv_flow_api.id(50548342566650725)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PERSON_ID , ROLE_ID',
'from BUDGET_ALLOCATION_ROLE_USERS',
'where sector_id = :P92_SECTOR_ID',
'and status = ''A''',
'and sysdate between nvl(start_date , sysdate - 10) and nvl(end_date , sysdate + 10)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P92_SECTOR_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Sector Planners Report'
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
 p_id=>wwv_flow_api.id(50548196149650723)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>162735836239533909
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50548073190650722)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Name'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50548002394650721)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Role'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(71091855092180279)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(50331654185234265)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1629524'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PERSON_ID:ROLE_ID'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(47359434537656798)
,p_plug_name=>'Sector Cost Centers Report init'
,p_parent_plug_id=>wwv_flow_api.id(50730778100315208)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CC_CODE, CC_NAME_EN, CH2_CEILING, CH2_ALLOCATED, CH3_CEILING, CH3_ALLOCATED, Round(CH2_ALLOCATED/decode(CH2_CEILING,0,1,CH2_CEILING)) CH2_PCT',
'                                                                                  , round(CH3_ALLOCATED/decode(CH3_CEILING,0,1,CH3_CEILING)) CH3_PCT',
'from ',
'(SELECT CC_CODE, CC_NAME_EN ',
'    , budget_proposal_pkg.cc_chapter_celing(:P92_PLAN_ID, CC_CODE, 134) CH2_Ceiling',
'    , budget_proposal_pkg.cc_chapter_allocated(:P92_PLAN_ID, CC_CODE, 134) CH2_Allocated',
'    ',
'    , budget_proposal_pkg.cc_chapter_celing(:P92_PLAN_ID, CC_CODE, 135) CH3_Ceiling',
'    , budget_proposal_pkg.cc_chapter_allocated(:P92_PLAN_ID, CC_CODE, 135) CH3_Allocated',
'FROM dct_cost_centers',
'WHERE SECTOR_ORG_ID   = :P92_SECTOR_ID',
'AND STATUS =  ''A''',
'and sysdate between nvl(start_date , sysdate - 10)',
'            and nvl(end_date , sysdate + 10)',
'order by cc_code)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P92_SECTOR_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NULL'
,p_plug_display_when_condition=>'P92_ID'
,p_plug_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/*',
'select CC_CODE, CC_NAME_EN, CH2_CEILING, CH2_ALLOCATED, CH3_CEILING, CH3_ALLOCATED, Round(CH2_ALLOCATED/decode(CH2_CEILING,0,1,CH2_CEILING)) CH2_PCT',
'                                                                                  , round(CH3_ALLOCATED/decode(CH3_CEILING,0,1,CH3_CEILING)) CH3_PCT',
'from ',
'(SELECT CC_CODE, CC_NAME_EN ',
'    , budget_proposal_pkg.cc_chapter_celing(:P92_PLAN_ID, CC_CODE, 134) CH2_Ceiling',
'    , budget_proposal_pkg.cc_chapter_allocated(:P92_PLAN_ID, CC_CODE, 134) CH2_Allocated',
'    ',
'    , budget_proposal_pkg.cc_chapter_celing(:P92_PLAN_ID, CC_CODE, 135) CH3_Ceiling',
'    , budget_proposal_pkg.cc_chapter_allocated(:P92_PLAN_ID, CC_CODE, 135) CH3_Allocated',
'FROM dct_cost_centers',
'WHERE SECTOR_ORG_ID   = :P92_SECTOR_ID',
'AND STATUS =  ''A''',
'and sysdate between nvl(start_date , sysdate - 10)',
'            and nvl(end_date , sysdate + 10)',
'order by cc_code)',
'*/'))
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(47359352345656797)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>165924680043527835
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47359291580656796)
,p_db_column_name=>'CC_CODE'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Cost Center Code'
,p_column_link=>'f?p=&APP_ID.:97:&SESSION.::&DEBUG.::P97_PLAN_ID,P97_COST_CENTER,P97_PAGE_FROM,P97_SECTOR_ID,P97_ID:&P92_PLAN_ID.,#CC_CODE#,92,&P92_SECTOR_ID.,#CC_PLAN_ID#'
,p_column_linktext=>'#CC_CODE#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47359163258656795)
,p_db_column_name=>'CC_NAME_EN'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47359102308656794)
,p_db_column_name=>'CH2_CEILING'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Opex (CH2) Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47358956319656793)
,p_db_column_name=>'CH2_ALLOCATED'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Opex (CH2) Allocated'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47358851038656792)
,p_db_column_name=>'CH3_CEILING'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Capex (CH3) Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47358780323656791)
,p_db_column_name=>'CH3_ALLOCATED'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Capex (CH3) Allocated'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47358718999656790)
,p_db_column_name=>'CH2_PCT'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Opex Progress'
,p_column_type=>'NUMBER'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'PCT_GRAPH:::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47358557204656789)
,p_db_column_name=>'CH3_PCT'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Capex Progress'
,p_column_type=>'NUMBER'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'PCT_GRAPH:::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(47259007030839907)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1660251'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CC_CODE:CC_NAME_EN:CH2_CEILING:CH2_ALLOCATED:CH2_PCT:CH3_CEILING:CH3_ALLOCATED:CH3_PCT:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(50262254428516600)
,p_plug_name=>'Sector Projects'
,p_parent_plug_id=>wwv_flow_api.id(50231700078855818)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(50262185797516599)
,p_plug_name=>'Sector Projects Report'
,p_parent_plug_id=>wwv_flow_api.id(50262254428516600)
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
'    PROJECTS_UTIL.get_task_chapter(project_number ,task_number ) chapter,',
'    nvl(PROJECTS_UTIL.EXPENDITURE_BALANCE(project_number,task_number,expenditure_type, :P92_PROPOSAL_YEAR - 1 , ''B'' ),0)                 Budget,',
'    nvl(PROJECTS_UTIL.EXPENDITURE_BALANCE(project_number,task_number,expenditure_type, :P93_PROPOSAL_YEAR - 1 , ''A'' ),0)                 Actual',
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
'            sector_id = :P92_SECTOR_ID',
'            AND status = ''A''',
'            AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)',
'    )',
'    AND future2 IN (',
'        SELECT',
'            *',
'        FROM',
'            apex_string.split(:P92_FUTURE2_USED, '':'')',
'    )',
'ORDER BY',
'    project_number,',
'    task_number;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P92_SECTOR_ID,P92_PROPOSAL_YEAR,P92_FUTURE2_USED'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Sector Projects Report'
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
 p_id=>wwv_flow_api.id(50262086601516598)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>163021945787668034
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50262030081516597)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50261869983516596)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50261789839516595)
,p_db_column_name=>'PROJECT_CODE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Project Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50261692194516594)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50261553107516593)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50261508213516592)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50261412354516591)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'GL Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50261306611516590)
,p_db_column_name=>'GL_ACCOUNT_NAME'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'GL Account Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50261210989516589)
,p_db_column_name=>'TASK_NAME'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Task Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50261035102516588)
,p_db_column_name=>'TASK_DESCRIPTION'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Task Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50260980340516587)
,p_db_column_name=>'TASK_END_DATE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Task End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50260889268516586)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50260743338516585)
,p_db_column_name=>'COST_CENTER_NAME'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50260700663516584)
,p_db_column_name=>'BUDGET_GROUP_CODE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Budget Group Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50260532415516583)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50260435618516582)
,p_db_column_name=>'FUTURE1'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50233001014855831)
,p_db_column_name=>'FUTURE2'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50232860652855830)
,p_db_column_name=>'FUTURE2_NAME'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Future2 Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50232766717855829)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Sector Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50232709489855828)
,p_db_column_name=>'BUDGET'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50231367134855815)
,p_db_column_name=>'ACTUAL'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Actual'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46726869592448208)
,p_db_column_name=>'CHAPTER'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Chapter'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(71071651503392969)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(50216548742840640)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1630675'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PROJECT_NUMBER:PROJECT_NAME:TASK_NUMBER:EXPENDITURE_TYPE:CHAPTER:GL_ACCOUNT:GL_ACCOUNT_NAME:COST_CENTER:COST_CENTER_NAME:FUTURE2:FUTURE2_NAME:BUDGET:ACTUAL:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(47698017143036890)
,p_plug_name=>'Documents'
,p_parent_plug_id=>wwv_flow_api.id(50231700078855818)
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P92_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(47697860681036889)
,p_plug_name=>'Documents Report'
,p_parent_plug_id=>wwv_flow_api.id(47698017143036890)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders'
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
'  where PLAN_ID = :P92_PLAN_ID',
'  and sector_id = :P92_SECTOR_ID',
'  and cost_center is  null',
'  order by UPDATED desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P92_PLAN_ID,P92_SECTOR_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Documents Report'
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
 p_id=>wwv_flow_api.id(47697780835036888)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>165586251554147744
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47697686022036887)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47697583747036886)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Document Version'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47697506732036885)
,p_db_column_name=>'PLAN_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Plan'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(49565096744743668)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47697369634036884)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1216232005294941)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47697304003036883)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47697193826036882)
,p_db_column_name=>'FILENAME'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File'
,p_column_link=>'f?p=&APP_ID.:102:&SESSION.::&DEBUG.::P102_ID,P102_STATUS:#ID#,&P92_STATUS.'
,p_column_linktext=>'#FILENAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47568262083766428)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47568114077766426)
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
 p_id=>wwv_flow_api.id(47567951623766425)
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
 p_id=>wwv_flow_api.id(47567905559766424)
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
 p_id=>wwv_flow_api.id(47567827433766423)
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
 p_id=>wwv_flow_api.id(47567613439766421)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DOWNLOAD:BUDGET_PROPOSAL_PLANS_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47568553481766431)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>180
,p_column_identifier=>'G'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47568476274766430)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>190
,p_column_identifier=>'H'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47568404018766429)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>200
,p_column_identifier=>'I'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47568172478766427)
,p_db_column_name=>'TAGS'
,p_display_order=>210
,p_column_identifier=>'K'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47567664572766422)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>220
,p_column_identifier=>'P'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(47556156915731704)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1657279'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:ROW_VERSION_NUMBER:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(49957672816921151)
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
 p_id=>wwv_flow_api.id(50737013262315699)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(49957672816921151)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:85:&SESSION.::&DEBUG.::P85_PLAN_ID:&P92_PLAN_ID.'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(47567417965766419)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(47698017143036890)
,p_button_name=>'New_document'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'New Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:102:&SESSION.::&DEBUG.:102:P102_PLAN_ID,P102_SECTOR_ID,P102_STATUS:&P92_PLAN_ID.,&P92_SECTOR_ID.,&P92_STATUS.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(47566922159766414)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(50730778100315208)
,p_button_name=>'Set_Ceiling'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Set Ceiling'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:103:&SESSION.::&DEBUG.::P103_PLAN_ID,P103_SECTOR_ID:&P92_PLAN_ID.,&P92_SECTOR_ID.'
,p_button_condition=>':P92_STATUS in (''Draft'' , ''Return'') and :P92_ID is not null'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-lock'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(46728752000448227)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(50262254428516600)
,p_button_name=>'Add'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:106:&SESSION.::&DEBUG.:106:P106_PLAN_ID,P106_SECTOR_ID,P106_PROPSAL_YEAR,P106_SECTOR_PLAN_ID:&P92_PLAN_ID.,&P92_SECTOR_ID.,&P92_PROPOSAL_YEAR.,&P92_ID.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(43740952844643630)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(50732972828315230)
,p_button_name=>'CHANGE_CEILING'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Change Ceiling'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'Null'
,p_button_condition_type=>'PLSQL_EXPRESSION'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(50735363085315698)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(49957672816921151)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition=>':P92_STATUS in (''Draft'' , ''Returned'') and :P92_ID is not null'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(50734976318315698)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(49957672816921151)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>':P92_STATUS in (''Draft'' , ''Returned'') and :P92_ID is not null'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(50734556778315698)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(49957672816921151)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P92_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_icon_css_classes=>'fa-save'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(49965944341921162)
,p_branch_name=>'Go To Page 85'
,p_branch_action=>'f?p=&APP_ID.:85:&SESSION.::&DEBUG.::P85_PLAN_ID:&P92_PLAN_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50752855203315708)
,p_name=>'P92_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(50733061967315231)
,p_item_source_plug_id=>wwv_flow_api.id(50753206213315708)
,p_source=>'ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50752450858315707)
,p_name=>'P92_PLAN_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(50733061967315231)
,p_item_source_plug_id=>wwv_flow_api.id(50753206213315708)
,p_source=>'PLAN_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50752032752315707)
,p_name=>'P92_SECTOR_ID'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(50733061967315231)
,p_item_source_plug_id=>wwv_flow_api.id(50753206213315708)
,p_prompt=>'Sector'
,p_source=>'SECTOR_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(SECTOR_NAME_USER , SECTOR_NAME ) Sector ',
'       , sector_id',
'from dct_hr_sectors_v',
'',
'order by nvl(SECTOR_NAME_USER , SECTOR_NAME )'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_read_only_when=>'P92_ID'
,p_read_only_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50751699848315707)
,p_name=>'P92_SECTOR_INSTRUCTIONS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(50733061967315231)
,p_item_source_plug_id=>wwv_flow_api.id(50753206213315708)
,p_prompt=>'Sector Instructions'
,p_source=>'SECTOR_INSTRUCTIONS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>4000
,p_cHeight=>4
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50751309240315706)
,p_name=>'P92_COMMENTS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(50733061967315231)
,p_item_source_plug_id=>wwv_flow_api.id(50753206213315708)
,p_prompt=>'Comments'
,p_source=>'COMMENTS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>4000
,p_cHeight=>4
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50750840429315706)
,p_name=>'P92_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(50732972828315230)
,p_item_source_plug_id=>wwv_flow_api.id(50753206213315708)
,p_item_default=>'Draft'
,p_prompt=>'Status'
,p_source=>'STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50750518746315706)
,p_name=>'P92_ALLOW_ADD_COST_CENTER_YN'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(50732972828315230)
,p_item_source_plug_id=>wwv_flow_api.id(50753206213315708)
,p_item_default=>'N'
,p_prompt=>'Allow Add Cost Center ?'
,p_source=>'ALLOW_ADD_COST_CENTER_YN'
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
 p_id=>wwv_flow_api.id(50750109011315706)
,p_name=>'P92_ALLOW_ADD_PROJECT_YN'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(50732972828315230)
,p_item_source_plug_id=>wwv_flow_api.id(50753206213315708)
,p_item_default=>'N'
,p_prompt=>'Allow Add Project ?'
,p_source=>'ALLOW_ADD_PROJECT_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_display_when=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P92_PLAN_ID) in (''E'' , ''R'')'
,p_display_when_type=>'PLSQL_EXPRESSION'
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
 p_id=>wwv_flow_api.id(50749723258315705)
,p_name=>'P92_ALLOW_ADD_TASK_YN'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(50732972828315230)
,p_item_source_plug_id=>wwv_flow_api.id(50753206213315708)
,p_item_default=>'N'
,p_prompt=>'Allow Add Task ?'
,p_source=>'ALLOW_ADD_TASK_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_display_when=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P92_PLAN_ID) in (''E'' , ''R'')'
,p_display_when_type=>'PLSQL_EXPRESSION'
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
 p_id=>wwv_flow_api.id(50749233864315705)
,p_name=>'P92_CEILING_CH1_REQUIRED_YN'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(50732972828315230)
,p_item_source_plug_id=>wwv_flow_api.id(50753206213315708)
,p_item_default=>'N'
,p_prompt=>'CH1 Required Ceiling ?'
,p_source=>'CEILING_CH1_REQUIRED_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_display_when=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P92_PLAN_ID) = ''M'''
,p_display_when_type=>'PLSQL_EXPRESSION'
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
 p_id=>wwv_flow_api.id(50748930119315705)
,p_name=>'P92_CEILING_CH1_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(50732972828315230)
,p_item_source_plug_id=>wwv_flow_api.id(50753206213315708)
,p_prompt=>'CH1 Ceiling: '
,p_post_element_text=>'<p>&nbsp;<strong>AED</strong></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'CEILING_CH1_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>15
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_grid_label_column_span=>2
,p_display_when=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P92_PLAN_ID) = ''M'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50748502812315705)
,p_name=>'P92_CEILING_CH2_REQUIRED_YN'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(50732972828315230)
,p_item_source_plug_id=>wwv_flow_api.id(50753206213315708)
,p_item_default=>'N'
,p_prompt=>'CH2 Required Ceiling ?'
,p_source=>'CEILING_CH2_REQUIRED_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_display_when=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P92_PLAN_ID) = ''E'''
,p_display_when_type=>'PLSQL_EXPRESSION'
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
 p_id=>wwv_flow_api.id(50748051562315705)
,p_name=>'P92_CEILING_CH2_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(50732972828315230)
,p_item_source_plug_id=>wwv_flow_api.id(50753206213315708)
,p_prompt=>'CH2 Ceiling: '
,p_post_element_text=>'<p>&nbsp;<strong>AED</strong></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'CEILING_CH2_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>15
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_grid_label_column_span=>2
,p_display_when=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P92_PLAN_ID) = ''E'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50747696606315704)
,p_name=>'P92_CEILING_CH3_REQUIRED_YN'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(50732972828315230)
,p_item_source_plug_id=>wwv_flow_api.id(50753206213315708)
,p_item_default=>'N'
,p_prompt=>'CH3 Required Ceiling ?'
,p_source=>'CEILING_CH3_REQUIRED_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_display_when=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P92_PLAN_ID) = ''E'''
,p_display_when_type=>'PLSQL_EXPRESSION'
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
 p_id=>wwv_flow_api.id(50747235760315704)
,p_name=>'P92_CEILING_CH3_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(50732972828315230)
,p_item_source_plug_id=>wwv_flow_api.id(50753206213315708)
,p_prompt=>'CH3 Ceiling: '
,p_post_element_text=>'<p>&nbsp;<strong>AED</strong></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'CEILING_CH3_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>15
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_grid_label_column_span=>2
,p_display_when=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P92_PLAN_ID) = ''E'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50746890595315704)
,p_name=>'P92_CEILING_CH6_REQUIRED_YN'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(50732972828315230)
,p_item_source_plug_id=>wwv_flow_api.id(50753206213315708)
,p_item_default=>'N'
,p_prompt=>'CH6 Required Ceiling ?'
,p_source=>'CEILING_CH6_REQUIRED_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_display_when=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P92_PLAN_ID) = ''C'''
,p_display_when_type=>'PLSQL_EXPRESSION'
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
 p_id=>wwv_flow_api.id(50746518275315704)
,p_name=>'P92_CEILING_CH6_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_api.id(50732972828315230)
,p_item_source_plug_id=>wwv_flow_api.id(50753206213315708)
,p_prompt=>'CH6 Ceiling: '
,p_post_element_text=>'<p>&nbsp;<strong>AED</strong></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'CEILING_CH6_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>15
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_grid_label_column_span=>2
,p_display_when=>'BUDGET_PROPOSAL_PKG.PLAN_TYPE(:P92_PLAN_ID) = ''C'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50746098345315704)
,p_name=>'P92_CREATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>320
,p_item_plug_id=>wwv_flow_api.id(50732873761315229)
,p_item_source_plug_id=>wwv_flow_api.id(50753206213315708)
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
 p_id=>wwv_flow_api.id(50745632493315703)
,p_name=>'P92_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>330
,p_item_plug_id=>wwv_flow_api.id(50732873761315229)
,p_item_source_plug_id=>wwv_flow_api.id(50753206213315708)
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
 p_id=>wwv_flow_api.id(50744919553315703)
,p_name=>'P92_UPDATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>340
,p_item_plug_id=>wwv_flow_api.id(50732873761315229)
,p_item_source_plug_id=>wwv_flow_api.id(50753206213315708)
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
 p_id=>wwv_flow_api.id(50744473790315703)
,p_name=>'P92_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>350
,p_item_plug_id=>wwv_flow_api.id(50732873761315229)
,p_item_source_plug_id=>wwv_flow_api.id(50753206213315708)
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
 p_id=>wwv_flow_api.id(50232604626855827)
,p_name=>'P92_FUTURE2_USED'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(50733061967315231)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50232518595855826)
,p_name=>'P92_PROPOSAL_YEAR'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(50733061967315231)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(46726647848448206)
,p_name=>'P92_CC_PLAN_ID_H'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(50730643933315207)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
,p_item_comment=>'Used to capture the Cost center plan ID which will delete'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(46726343571448203)
,p_name=>'P92_CC_CODE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(50730643933315207)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
,p_item_comment=>'Used to capture the Cost center plan ID which will delete'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(50745161468315703)
,p_validation_name=>'P92_CREATED_ON must be timestamp'
,p_validation_sequence=>180
,p_validation=>'P92_CREATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(50745632493315703)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(50743962553315702)
,p_validation_name=>'P92_UPDATED_ON must be timestamp'
,p_validation_sequence=>200
,p_validation=>'P92_UPDATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(50744473790315703)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(50732675267315227)
,p_name=>'CEILING_CH1_REQUIRED_YN DA'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P92_CEILING_CH1_REQUIRED_YN'
,p_condition_element=>'P92_CEILING_CH1_REQUIRED_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50732611103315226)
,p_event_id=>wwv_flow_api.id(50732675267315227)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P92_CEILING_CH1_AMOUNT'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50732518500315225)
,p_event_id=>wwv_flow_api.id(50732675267315227)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P92_CEILING_CH1_AMOUNT'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50732423525315224)
,p_event_id=>wwv_flow_api.id(50732675267315227)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P92_CEILING_CH1_AMOUNT'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(50732313963315223)
,p_name=>'P92_CEILING_CH2_REQUIRED_YN DA'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P92_CEILING_CH2_REQUIRED_YN'
,p_condition_element=>'P92_CEILING_CH2_REQUIRED_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50732195097315222)
,p_event_id=>wwv_flow_api.id(50732313963315223)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P92_CEILING_CH2_AMOUNT'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50732101662315221)
,p_event_id=>wwv_flow_api.id(50732313963315223)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P92_CEILING_CH2_AMOUNT'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50731934894315220)
,p_event_id=>wwv_flow_api.id(50732313963315223)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P92_CEILING_CH2_AMOUNT'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(50731922519315219)
,p_name=>'P92_CEILING_CH3_REQUIRED_YN DA'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P92_CEILING_CH3_REQUIRED_YN'
,p_condition_element=>'P92_CEILING_CH3_REQUIRED_YN'
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
 p_id=>wwv_flow_api.id(50731734711315218)
,p_event_id=>wwv_flow_api.id(50731922519315219)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P92_CEILING_CH3_AMOUNT'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50731704417315217)
,p_event_id=>wwv_flow_api.id(50731922519315219)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P92_CEILING_CH3_AMOUNT'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50731590896315216)
,p_event_id=>wwv_flow_api.id(50731922519315219)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P92_CEILING_CH3_AMOUNT'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(50731529544315215)
,p_name=>'P92_CEILING_CH6_REQUIRED_YN DA'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P92_CEILING_CH6_REQUIRED_YN'
,p_condition_element=>'P92_CEILING_CH6_REQUIRED_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50731422874315214)
,p_event_id=>wwv_flow_api.id(50731529544315215)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P92_CEILING_CH6_AMOUNT'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50731330081315213)
,p_event_id=>wwv_flow_api.id(50731529544315215)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P92_CEILING_CH6_AMOUNT'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50731188014315212)
,p_event_id=>wwv_flow_api.id(50731529544315215)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P92_CEILING_CH6_AMOUNT'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(50730272248315203)
,p_name=>'Sector Selected DA'
,p_event_sequence=>60
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P92_SECTOR_ID'
,p_condition_element=>'P92_SECTOR_ID'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50231602600855817)
,p_event_id=>wwv_flow_api.id(50730272248315203)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(50231700078855818)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50231496504855816)
,p_event_id=>wwv_flow_api.id(50730272248315203)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(50231700078855818)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50730206764315202)
,p_event_id=>wwv_flow_api.id(50730272248315203)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(50730778100315208)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50232314132855824)
,p_event_id=>wwv_flow_api.id(50730272248315203)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(50262254428516600)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50730128688315201)
,p_event_id=>wwv_flow_api.id(50730272248315203)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(47359434537656798)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50547651113650718)
,p_event_id=>wwv_flow_api.id(50730272248315203)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(50548342566650725)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50729983452315200)
,p_event_id=>wwv_flow_api.id(50730272248315203)
,p_event_result=>'FALSE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(50730778100315208)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50547875868650720)
,p_event_id=>wwv_flow_api.id(50730272248315203)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(50548342566650725)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50547765835650719)
,p_event_id=>wwv_flow_api.id(50730272248315203)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(50548236689650724)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50232385353855825)
,p_event_id=>wwv_flow_api.id(50730272248315203)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(50262254428516600)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(50232132739855823)
,p_event_id=>wwv_flow_api.id(50730272248315203)
,p_event_result=>'TRUE'
,p_action_sequence=>70
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(50262185797516599)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(47567260565766418)
,p_name=>'New_document DA'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(47567417965766419)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(47567231590766417)
,p_event_id=>wwv_flow_api.id(47567260565766418)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(47697860681036889)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(47567070336766416)
,p_name=>'Documents Report DA'
,p_event_sequence=>80
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(47697860681036889)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(47567005275766415)
,p_event_id=>wwv_flow_api.id(47567070336766416)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(47697860681036889)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(46726584295448205)
,p_name=>'Delete Cost center plan record'
,p_event_sequence=>90
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.del'
,p_bind_type=>'live'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(46726464073448204)
,p_event_id=>wwv_flow_api.id(46726584295448205)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P92_CC_PLAN_ID_H'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>'this.triggeringElement.dataset.id;'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(46726296496448202)
,p_event_id=>wwv_flow_api.id(46726584295448205)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P92_CC_CODE'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>'this.triggeringElement.dataset.cc;'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(46725980682448199)
,p_event_id=>wwv_flow_api.id(46726584295448205)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'You are going to delete Cost Center &P92_CC_CODE. from the plan. Are you sure?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(46726161266448201)
,p_event_id=>wwv_flow_api.id(46726584295448205)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'delete budget_proposal_cost_centers_plans',
'where id = :P92_CC_PLAN_ID_H;',
'',
'delete from budget_proposal_plans_documents',
'where plan_id = :P92_PLAN_ID',
'and cost_center = :P92_CC_CODE;',
'',
'delete from budget_proposal_cost_centers_plans_approval_history',
'where REQUEST_ID = :P92_CC_PLAN_ID_H;',
'',
'delete from budget_proposal_projects_plans',
'where plan_id = :P92_PLAN_ID',
'and COST_CENTER = :P92_CC_CODE;'))
,p_attribute_02=>'P92_CC_PLAN_ID_H,P92_PLAN_ID,P92_CC_CODE'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(46726122126448200)
,p_event_id=>wwv_flow_api.id(46726584295448205)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(50730643933315207)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(50733789499315697)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(50753206213315708)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Budget Proposal Plan Sector Assignment'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(50544320170650684)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Add Plan Cost Centers Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'delete from budget_proposal_cost_centers_plans where plan_id = :P92_PLAN_ID and sector_id = :P92_SECTOR_ID;',
'',
'INSERT INTO budget_proposal_cost_centers_plans (',
'    plan_id,',
'    sector_id,',
'    cost_center,',
'    ceiling_ch1_required_yn,',
'    ceiling_ch1_amount,',
'    ceiling_ch2_required_yn,',
'    ceiling_ch2_amount,',
'    ceiling_ch3_required_yn,',
'    ceiling_ch3_amount,',
'    ceiling_ch6_required_yn,',
'    ceiling_ch6_amount,',
'    status,',
'    allow_add_project_yn,',
'    allow_add_task_yn',
')   ',
'select :P92_PLAN_ID,',
'       :P92_SECTOR_ID,',
'       cc.CC_CODE,',
'       :P92_CEILING_CH1_REQUIRED_YN,',
'            NULL,',
'            :P92_CEILING_CH2_REQUIRED_YN,',
'            NULL,',
'            :P92_CEILING_CH3_REQUIRED_YN,',
'            NULL,',
'            :P92_CEILING_CH6_REQUIRED_YN,',
'            NULL,',
'            ''Draft'',',
'            :P92_ALLOW_ADD_PROJECT_YN,',
'            :P92_ALLOW_ADD_TASK_YN',
'from dct_cost_centers cc',
'where cc.SECTOR_ORG_ID = :P92_SECTOR_ID',
'and STATUS =  ''A''',
'and sysdate between nvl(start_date , sysdate - 10)',
'            and nvl(end_date , sysdate + 10);'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(50734556778315698)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(50231235291855814)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Add Sector Projects'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'INSERT INTO budget_proposal_projects_plans (',
'    plan_id,',
'    sector_id,',
'    project_number,',
'    task_number,',
'    expenditure_type,',
'    entity_code,',
'    cost_center,',
'    budget_groub_code,',
'    gl_account,',
'    activity,',
'    future1,',
'    future2,',
'    objective_id,',
'    program_id,',
'    initiative_id,',
'    status,',
'    plan_version,',
'    PROPOSAL_YEAR,',
'    ACTUAL_Y1,',
'    ACTUAL_Y2,',
'    ACTUAL_Y3,',
'    ACTUAL_Y4,',
'    ACTUAL_Y5',
') ',
'    SELECT',
'    :P92_PLAN_ID,',
'    :P92_SECTOR_ID,',
'    project_number,',
'    task_number,',
'    expenditure_type,',
'    ''451'',',
'    PROJECTS_UTIL.task_cost_center(project_number ,task_number ),',
'    PROJECTS_UTIL.task_budget_code(project_number ,task_number ),',
'    PROJECTS_UTIL.expenditure_type_gl_account(project_number ,task_number,expenditure_type ),',
'    PROJECTS_UTIL.task_activity(project_number ,task_number ),',
'    PROJECTS_UTIL.task_future1(project_number ,task_number ),',
'    PROJECTS_UTIL.task_future2(project_number ,task_number ),',
'   null, -- objective',
'   null,    --Program',
'   PROJECTS_UTIL.TASK_INITIATIVE_ID(project_number ,task_number ),',
'   ''Draft'',',
'   1,',
'   :P92_PROPOSAL_YEAR,',
'   projects_util.EXPENDITURE_BALANCE(project_number ,task_number,expenditure_type, :P92_PROPOSAL_YEAR - 1 , ''A''),      -- current_budget year',
'   projects_util.EXPENDITURE_BALANCE(project_number ,task_number,expenditure_type, :P92_PROPOSAL_YEAR - 2 , ''A''),',
'   projects_util.EXPENDITURE_BALANCE(project_number ,task_number,expenditure_type, :P92_PROPOSAL_YEAR - 3 , ''A''),',
'   projects_util.EXPENDITURE_BALANCE(project_number ,task_number,expenditure_type, :P92_PROPOSAL_YEAR - 4 , ''A''),',
'   projects_util.EXPENDITURE_BALANCE(project_number ,task_number,expenditure_type, :P92_PROPOSAL_YEAR - 5 , ''A'')',
'FROM',
'    expenditures_v',
'WHERE',
'    cost_center IN ( select distinct   cc.CC_CODE',
'                    from dct_cost_centers cc',
'                    where cc.SECTOR_ORG_ID = :P92_SECTOR_ID',
'                    and STATUS =  ''A''',
'                    and sysdate between nvl(start_date , sysdate - 10)',
'                                and nvl(end_date , sysdate + 10)',
'    )',
'    AND future2 IN (',
'        SELECT',
'            *',
'        FROM',
'            apex_string.split(:P92_FUTURE2_USED, '':'')',
'    );'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(50734556778315698)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(49277592150009309)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delete Dependent Sector Plan'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'delete from BUDGET_PROPOSAL_COST_CENTERS_PLANS where plan_id = :P92_PLAN_ID and sector_id = :P92_SECTOR_ID;',
'delete from budget_proposal_projects_plans where plan_id = :P92_PLAN_ID and sector_id = :P92_SECTOR_ID;',
'',
'delete from BUDGET_PROPOSAL_PLANS_DOCUMENTS where plan_id = :P92_PLAN_ID and sector_id = :P92_SECTOR_ID;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(50735363085315698)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(50734155100315697)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(50753206213315708)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Budget Proposal Plan Sector Assignment'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(50232054062855822)
,p_process_sequence=>20
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Set Future2 Use'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select future2_used',
'into :P92_FUTURE2_USED',
'from budget_proposal_plans',
'where plan_id = :P92_PLAN_ID;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
