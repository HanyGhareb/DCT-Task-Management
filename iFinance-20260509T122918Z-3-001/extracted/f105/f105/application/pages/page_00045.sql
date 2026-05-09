prompt --application/pages/page_00045
begin
--   Manifest
--     PAGE: 00045
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
 p_id=>45
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Initiatives With Projects '
,p_alias=>'INITIATIVES-WITH-PROJECTS'
,p_step_title=>'Initiatives With Projects '
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220902063450'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(88297253317047869)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99766883142410755)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(99703488427410717)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(99820961719410781)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(88296729344047870)
,p_plug_name=>'Initiatives With Projects '
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ti.ID,',
'       ti.PROJECT_NUMBER,',
'       ti.TASK_NUMBER,',
'       ti.INITIATIVE_ID,',
'       (select x.INITIATIVE_CODE ',
'        from STRATEGIC_INITIATIVES x',
'        where x.INITIATIVE_ID = ti.INITIATIVE_ID) Initiative_code,',
'       (select x.INITIATIVE_NAME ',
'        from STRATEGIC_INITIATIVES x',
'        where x.INITIATIVE_ID = ti.INITIATIVE_ID) INITIATIVE_NAME,     ',
'       (select decode(x.INITIATIVE_TYPE , ''N'',''Non-Strategic'',''Y'',''Strategic'', ''NA'') s_type',
'        from STRATEGIC_INITIATIVES x',
'        where x.INITIATIVE_ID = ti.INITIATIVE_ID) INITIATIVE_TYPE,             ',
'       ti.START_DATE,',
'       ti.END_DATE,',
'       ti.STATUS,',
'       ti.CREATED_BY,',
'       ti.CREATED_ON,',
'       ti.UPDATED_BY,',
'       ti.UPDATED_ON,',
'       ti.rowid  ti_rowid,',
'       pb.BUDGET,',
'       pb.ACTUAL,',
'       pb.ENCUMBERANCE,',
'       pb.FUND_AVAILABLE',
'  from TASK_INITIATIVES  ti , ( select PROJECT_NUMBER, TASK_NUMBER, COST_CENTER ,sum(pb.BUDGET) BUDGET, ',
'                                    sum(pb.ACTUAL) ACTUAL, sum(pb.ENCUMBERANCE) ENCUMBERANCE, ',
'                                    sum(pb.FUND_AVAILABLE) FUND_AVAILABLE ',
'                                 from project_balances pb ',
'                                where pb.accounting_year = :CURRENT_YEAR',
'',
'                                 GROUP by PROJECT_NUMBER, TASK_NUMBER, COST_CENTER) pb',
'  where 1= 1',
'  and ti.PROJECT_NUMBER = pb.PROJECT_NUMBER',
'  and ti.TASK_NUMBER = pb.TASK_NUMBER;'))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A3'
,p_prn_width=>420
,p_prn_height=>297
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Initiatives With Projects '
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#FF0000'
,p_prn_header_font_color=>'#FFFFFF'
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
 p_id=>wwv_flow_api.id(88296621056047870)
,p_name=>'Initiatives With Projects '
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>124987411333136762
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88296224953047873)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88295806243047875)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88295430224047875)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88295004782047875)
,p_db_column_name=>'INITIATIVE_ID'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Initiative Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88294578747047876)
,p_db_column_name=>'INITIATIVE_CODE'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Initiative Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88294184281047876)
,p_db_column_name=>'INITIATIVE_NAME'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Initiative Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88293820113047876)
,p_db_column_name=>'INITIATIVE_TYPE'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Initiative Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88293424957047876)
,p_db_column_name=>'START_DATE'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88293019372047876)
,p_db_column_name=>'END_DATE'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88292550309047877)
,p_db_column_name=>'STATUS'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88292219965047877)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88291827699047877)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88291338668047877)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88290987818047877)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88290607572047878)
,p_db_column_name=>'TI_ROWID'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Ti Rowid'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'OTHER'
,p_rpt_show_filter_lov=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88290163437047878)
,p_db_column_name=>'BUDGET'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88289819590047878)
,p_db_column_name=>'ACTUAL'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Actual'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88289338625047878)
,p_db_column_name=>'ENCUMBERANCE'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Encumberance'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(88288952731047878)
,p_db_column_name=>'FUND_AVAILABLE'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Fund Available'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(88288559580048156)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1249955'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'INITIATIVE_CODE:INITIATIVE_NAME:INITIATIVE_TYPE:PROJECT_NUMBER:TASK_NUMBER:BUDGET:ACTUAL:ENCUMBERANCE:FUND_AVAILABLE:'
,p_sort_column_1=>'INITIATIVE_CODE'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'PROJECT_NUMBER'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'TASK_NUMBER'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_api.component_end;
end;
/
