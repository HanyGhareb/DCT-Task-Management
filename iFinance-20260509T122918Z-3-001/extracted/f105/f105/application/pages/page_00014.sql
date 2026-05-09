prompt --application/pages/page_00014
begin
--   Manifest
--     PAGE: 00014
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
 p_id=>14
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Initiatives Report'
,p_alias=>'INITIATIVES-REPORT'
,p_step_title=>'Initiatives'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230716195125'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(32086129997698690)
,p_plug_name=>'All Initiatives'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select si.INITIATIVE_ID,',
'       si.INITIATIVE_CODE,',
'       si.INITIATIVE_NAME,',
'       si.DESCRIPTION,',
'       si.INITIATIVE_TYPE,',
'       si.START_DATE,',
'       si.END_DATE,',
'       si.STATUS,',
'       si.CREATED_BY,',
'       si.CREATED_ON,',
'       si.UPDATED_BY,',
'       si.UPDATED_ON,',
'       si.OBJECTIVE_ID,',
'       si.program_id',
'        ,so.objective_name',
'  from STRATEGIC_INITIATIVES si , strategic_objectives  so',
'  where si.objective_id = so.objective_id (+)',
'  order by si.INITIATIVE_CODE'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'All Initiatives'
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
 p_id=>wwv_flow_api.id(32085968313698689)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>181198064075485943
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32085892703698688)
,p_db_column_name=>'INITIATIVE_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Initiative Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32085777752698687)
,p_db_column_name=>'INITIATIVE_CODE'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Initiative Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32085718598698686)
,p_db_column_name=>'INITIATIVE_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Initiative Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32085623040698685)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32085519330698684)
,p_db_column_name=>'INITIATIVE_TYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Initiative Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(751483607077011)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32085384922698683)
,p_db_column_name=>'START_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32085303695698682)
,p_db_column_name=>'END_DATE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32040666108388531)
,p_db_column_name=>'STATUS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(780300318120911)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32040546824388530)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32040449141388529)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32040392881388528)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32040329494388527)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32040133806388526)
,p_db_column_name=>'OBJECTIVE_ID'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Objective'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(835817871529402)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32040109790388525)
,p_db_column_name=>'PROGRAM_ID'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Program'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(49925322344786792)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32040029368388524)
,p_db_column_name=>'OBJECTIVE_NAME'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Objective Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(32029845787383010)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1812542'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'INITIATIVE_CODE:INITIATIVE_NAME:INITIATIVE_TYPE:PROGRAM_ID:OBJECTIVE_ID:STATUS:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(765944659088061)
,p_plug_name=>'Initiatives Report'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select si.INITIATIVE_ID,',
'       si.INITIATIVE_CODE,',
'       si.INITIATIVE_NAME,',
'       si.DESCRIPTION,',
'       si.INITIATIVE_TYPE,',
'       si.START_DATE,',
'       si.END_DATE,',
'       si.STATUS,',
'       si.CREATED_BY,',
'       si.CREATED_ON,',
'       si.UPDATED_BY,',
'       si.UPDATED_ON,',
'       si.OBJECTIVE_ID,',
'       si.program_id,',
'       so.objective_name',
'      ,sum(pb.budget) budget',
'      ,sum(pb.actual) actual',
'      ,sum(pb.encumberance) encumberance',
'      ,sum(pb.fund_available) fund_available',
'  from STRATEGIC_INITIATIVES si , strategic_objectives  so,TASK_INITIATIVES  ti , project_balances pb',
'  where si.objective_id = so.objective_id (+)',
'  and si.initiative_id = ti.initiative_id (+)',
'--  and pb.accounting_year = :CURRENT_YEAR',
'  and ti.project_number = pb.project_number',
'  and ti.task_number = pb.task_number ',
'  group by si.INITIATIVE_ID, si.INITIATIVE_CODE, si.INITIATIVE_NAME, si.DESCRIPTION, si.INITIATIVE_TYPE, ',
'si.START_DATE, si.END_DATE, si.STATUS, si.CREATED_BY, si.CREATED_ON, ',
'si.UPDATED_BY, si.UPDATED_ON, si.OBJECTIVE_ID, si.program_id ,so.objective_name;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Initiatives Report'
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
 p_id=>wwv_flow_api.id(766270855088061)
,p_name=>'Report 1'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:15:&SESSION.::&DEBUG.:RP:P15_INITIATIVE_ID:\#INITIATIVE_ID#\'
,p_detail_link_text=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_owner=>'TCA9051'
,p_internal_uid=>106122600046451474
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(766451378088062)
,p_db_column_name=>'INITIATIVE_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Initiative Id'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(766775257088062)
,p_db_column_name=>'INITIATIVE_CODE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Code'
,p_column_link=>'f?p=&APP_ID.:15:&SESSION.::&DEBUG.::P15_INITIATIVE_ID:\#INITIATIVE_ID#\'
,p_column_linktext=>'#INITIATIVE_CODE#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(767231959088062)
,p_db_column_name=>'INITIATIVE_NAME'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(767582780088062)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(768059408088063)
,p_db_column_name=>'INITIATIVE_TYPE'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(751483607077011)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(768433313088063)
,p_db_column_name=>'START_DATE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(768793983088063)
,p_db_column_name=>'END_DATE'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(769246675088063)
,p_db_column_name=>'STATUS'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(780300318120911)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(769583864088063)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(769990557088063)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(770445316088064)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(770793315088064)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(669662634550313)
,p_db_column_name=>'OBJECTIVE_ID'
,p_display_order=>22
,p_column_identifier=>'M'
,p_column_label=>'Objective'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(835817871529402)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(669718246550314)
,p_db_column_name=>'OBJECTIVE_NAME'
,p_display_order=>32
,p_column_identifier=>'N'
,p_column_label=>'Objective Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(851619796863113)
,p_db_column_name=>'BUDGET'
,p_display_order=>42
,p_column_identifier=>'O'
,p_column_label=>'Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(851719866863114)
,p_db_column_name=>'ACTUAL'
,p_display_order=>52
,p_column_identifier=>'P'
,p_column_label=>'Actual'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(851771633863115)
,p_db_column_name=>'ENCUMBERANCE'
,p_display_order=>62
,p_column_identifier=>'Q'
,p_column_label=>'Encumberance'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(851962927863116)
,p_db_column_name=>'FUND_AVAILABLE'
,p_display_order=>72
,p_column_identifier=>'R'
,p_column_label=>'Fund Available'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50230592792855807)
,p_db_column_name=>'PROGRAM_ID'
,p_display_order=>82
,p_column_identifier=>'S'
,p_column_label=>'Program'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(49925322344786792)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(773955756089997)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1061303'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'INITIATIVE_CODE:INITIATIVE_NAME:OBJECTIVE_ID:PROGRAM_ID:INITIATIVE_TYPE:STATUS:BUDGET:ACTUAL:ENCUMBERANCE:FUND_AVAILABLE:'
,p_sort_column_1=>'INITIATIVE_CODE'
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
,p_sum_columns_on_break=>'BUDGET:ACTUAL:ENCUMBERANCE:FUND_AVAILABLE'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(772129615088067)
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
 p_id=>wwv_flow_api.id(773296768088068)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(772129615088067)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Initiative'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:15:&SESSION.::&DEBUG.:15'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.component_end;
end;
/
