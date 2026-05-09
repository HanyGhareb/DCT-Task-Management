prompt --application/pages/page_00122
begin
--   Manifest
--     PAGE: 00122
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
 p_id=>122
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Budget Proposal Plan By Cost Center'
,p_alias=>'BUDGET-PROPOSAL-PLAN-BY-COST-CENTER'
,p_step_title=>'Budget Proposal Plan By Cost Center'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230724115106'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(38460973948266510)
,p_plug_name=>'Search'
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
 p_id=>wwv_flow_api.id(38386489260743506)
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
 p_id=>wwv_flow_api.id(128695470811127477)
,p_plug_name=>'Cost Center Plans'
,p_icon_css_classes=>'fa-align-center'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
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
'',
'      initial_opex_ceiling,',
'       nvl(PC.CEILING_CH2_ADDITIONAL,0) CEILING_CH2_ADDITIONAL,',
'       pc.CEILING_CH2_AMOUNT,',
'       budget_proposal_pkg.cc_chapter_allocated(pc.PLAN_ID, pc.COST_CENTER, 134) CH2_Allocated,',
'       ',
'       initial_capex_ceiling,',
'       pc.CEILING_CH3_AMOUNT,',
'       nvl(PC.CEILING_CH3_ADDITIONAL,0) CEILING_CH3_ADDITIONAL,',
'       budget_proposal_pkg.cc_chapter_allocated(pc.PLAN_ID, pc.COST_CENTER, 135) CH3_Allocated,',
'   ',
'     ',
'       pc.STATUS,',
'       pc.COST_CENTER_INSTRUCTIONS,',
'       pc.COMMENTS,',
'       pc.SUBMITTED_BY,',
'       pc.SUBMITTED_ON,',
'       pc.RECEIVED_ON,',
'       pc.RECEIVED_BY,',
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
'    -- revise    ',
'    start_REVISE_BY_FBP,',
'    start_REVISE_ON_FBP,',
'    start_REVISE_BY_FPR,',
'    start_REVISE_ON_FPR,  ',
'    FBP_REVISE_COMPLETE_ON, ',
'    FBP_REVISE_COMPLETE_BY, ',
'    FPR_REVISE_COMPLETE_ON, ',
'    FPR_REVISE_COMPLETE_BY,',
'    -- Revise',
'    ',
'       case when pc.CEILING_CH2_AMOUNT <  budget_proposal_pkg.cc_chapter_allocated(pc.PLAN_ID, pc.COST_CENTER, 134)',
'                Then  ''red''',
'            when pc.CEILING_CH2_AMOUNT =  budget_proposal_pkg.cc_chapter_allocated(pc.PLAN_ID, pc.COST_CENTER, 134)',
'                Then  ''green''    ',
'        end as "STATUS_COLOR"',
'        ',
'  from BUDGET_PROPOSAL_COST_CENTERS_PLANS pc',
'  where pc.plan_id = :P122_PLAN',
'  order by pc.cost_center'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P122_PLAN'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_document_header=>'SERVER'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A3'
,p_prn_width=>420
,p_prn_height=>297
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
 p_id=>wwv_flow_api.id(128695485926127478)
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>341979518315312110
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38379764657740868)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38379409043740867)
,p_db_column_name=>'PROJECTS_COUNT'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Projects Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38378978534740867)
,p_db_column_name=>'LINE_COUNT'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Line Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38378586866740867)
,p_db_column_name=>'PLAN_ID_H'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Plan Id H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38378189572740867)
,p_db_column_name=>'SECTOR_ID_H'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Sector Id H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38377812665740867)
,p_db_column_name=>'CH2_ALLOCATED'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Opex Allocated'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38377396603740866)
,p_db_column_name=>'CH3_ALLOCATED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Capex Allocated'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38376957635740866)
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
 p_id=>wwv_flow_api.id(38376597054740866)
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
 p_id=>wwv_flow_api.id(38376143369740860)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Cost Center'
,p_column_link=>'f?p=&APP_ID.:97:&SESSION.::&DEBUG.::P97_PLAN_ID,P97_COST_CENTER,P97_PAGE_FROM,P97_SECTOR_ID,P97_ID,P97_CC_PLAN_ID:#PLAN_ID_H#,#COST_CENTER#,96,#SECTOR_ID_H#,#ID#,\#ID#\'
,p_column_linktext=>'#COST_CENTER#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38374568858740856)
,p_db_column_name=>'CEILING_CH2_AMOUNT'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Current Opex Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38373766363740856)
,p_db_column_name=>'CEILING_CH3_AMOUNT'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Current Capex Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38372598487740855)
,p_db_column_name=>'STATUS'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38372168146740855)
,p_db_column_name=>'COST_CENTER_INSTRUCTIONS'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Cost Center Instructions'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38371804306740855)
,p_db_column_name=>'COMMENTS'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38371382163740855)
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
 p_id=>wwv_flow_api.id(38371005737740851)
,p_db_column_name=>'SUBMITTED_ON'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Submitted On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38370620733740851)
,p_db_column_name=>'RECEIVED_ON'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Received On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38370166349740851)
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
 p_id=>wwv_flow_api.id(38368994389740845)
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
 p_id=>wwv_flow_api.id(38368535863740845)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38368212033740845)
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
 p_id=>wwv_flow_api.id(38367780753740844)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38367368513740844)
,p_db_column_name=>'COST_CENTER_NAME'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38366996636740844)
,p_db_column_name=>'STATUS_COLOR'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Status Color'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38366629705740844)
,p_db_column_name=>'CEILING_CH2_ADDITIONAL'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Additional Opex Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38366138449740844)
,p_db_column_name=>'CEILING_CH3_ADDITIONAL'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Additional Capex Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38461202029266512)
,p_db_column_name=>'INITIAL_OPEX_CEILING'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Initial Opex Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38461096275266511)
,p_db_column_name=>'INITIAL_CAPEX_CEILING'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Initial Capex Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30534712203105706)
,p_db_column_name=>'START_REVISE_BY_FBP'
,p_display_order=>380
,p_column_identifier=>'AQ'
,p_column_label=>'Start Revise By - FBP'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30534609666105705)
,p_db_column_name=>'START_REVISE_ON_FBP'
,p_display_order=>390
,p_column_identifier=>'AR'
,p_column_label=>'Start Revise On- FBP'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30534522470105704)
,p_db_column_name=>'START_REVISE_BY_FPR'
,p_display_order=>400
,p_column_identifier=>'AS'
,p_column_label=>'Start Revise By -Budget Planning'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30534394661105703)
,p_db_column_name=>'START_REVISE_ON_FPR'
,p_display_order=>410
,p_column_identifier=>'AT'
,p_column_label=>'Start Revise On -Budget Planning'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30534249383105702)
,p_db_column_name=>'FBP_REVISE_COMPLETE_ON'
,p_display_order=>420
,p_column_identifier=>'AU'
,p_column_label=>'Complete Revise On- FBP'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30534208888105701)
,p_db_column_name=>'FBP_REVISE_COMPLETE_BY'
,p_display_order=>430
,p_column_identifier=>'AV'
,p_column_label=>'Complete Revise By - FBP'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30534088563105700)
,p_db_column_name=>'FPR_REVISE_COMPLETE_ON'
,p_display_order=>440
,p_column_identifier=>'AW'
,p_column_label=>'Complete Revise On -Budget Planning'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30533932750105699)
,p_db_column_name=>'FPR_REVISE_COMPLETE_BY'
,p_display_order=>450
,p_column_identifier=>'AX'
,p_column_label=>'Complete Revise By -Budget Planning'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(129591489543383560)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1749182'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>100
,p_report_columns=>'COST_CENTER:COST_CENTER_NAME:CEILING_CH2_AMOUNT:CEILING_CH2_ADDITIONAL:APXWS_CC_001:CH2_ALLOCATED:CEILING_CH3_AMOUNT:CEILING_CH3_ADDITIONAL:APXWS_CC_002:CH3_ALLOCATED:COST_CENTER_INSTRUCTIONS:COMMENTS:PROJECTS_COUNT:LINE_COUNT:STATUS:INITIAL_OPEX_CEI'
||'LING:INITIAL_CAPEX_CEILING:'
,p_sum_columns_on_break=>'CEILING_CH2_AMOUNT:CH2_ALLOCATED:CEILING_CH3_AMOUNT:CH3_ALLOCATED:CEILING_CH3_ADDITIONAL:CEILING_CH2_ADDITIONAL:APXWS_CC_001:APXWS_CC_002'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(30414397936125529)
,p_report_id=>wwv_flow_api.id(129591489543383560)
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
 p_id=>wwv_flow_api.id(30413943177125528)
,p_report_id=>wwv_flow_api.id(129591489543383560)
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
 p_id=>wwv_flow_api.id(30413615922125527)
,p_report_id=>wwv_flow_api.id(129591489543383560)
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
 p_id=>wwv_flow_api.id(30413174771125526)
,p_report_id=>wwv_flow_api.id(129591489543383560)
,p_db_column_name=>'APXWS_CC_001'
,p_column_identifier=>'C01'
,p_computation_expr=>'N + AH'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Total Opex Ceiling'
,p_report_label=>'Total Opex Ceiling'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(30412767417125525)
,p_report_id=>wwv_flow_api.id(129591489543383560)
,p_db_column_name=>'APXWS_CC_002'
,p_column_identifier=>'C02'
,p_computation_expr=>'P + AI'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Total Capex Ceiling'
,p_report_label=>'Total Capex Ceiling'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(38460753586266508)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(38460973948266510)
,p_button_name=>'Seach'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Seach'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-search'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38460895446266509)
,p_name=>'P122_PLAN'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(38460973948266510)
,p_prompt=>'Budget Proposal Plan'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'BUDGET PROPOSAL PLANS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PLAN_NAME , PLAN_ID',
'from budget_proposal_plans'))
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(38460723626266507)
,p_name=>'Search DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(38460753586266508)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(38460571032266506)
,p_event_id=>wwv_flow_api.id(38460723626266507)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(128695470811127477)
);
wwv_flow_api.component_end;
end;
/
