prompt --application/pages/page_00028
begin
--   Manifest
--     PAGE: 00028
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
 p_id=>28
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Tasks Approvers'
,p_alias=>'TASKS-APPROVERS'
,p_step_title=>'Tasks Approvers'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220705123352'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(104984517173139188)
,p_plug_name=>'Task Approvers Report'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PROJECT_NUMBER,',
'       TASK_NUMBER,',
'       TASK_NAME,',
'       TASK_DESCRIPTION,',
'       TASK_START_DATE,',
'       TASK_END_DATE,',
'       COST_CENTER,',
'       BUDGET_GROUP_CODE,',
'       ACTIVITY,',
'       FUTURE1,',
'       FUTURE2,',
'       DCT_SECTOR_ID,',
'       DCT_DEPARTMENT_ID,',
'       DCT_SECTION_ID,',
'       DCT_UNIT_ID,',
'       DCT_TASK_NAME,',
'       DCT_SERVICE_PROVIDER,',
'       DCT_MPR_ALLOWED,',
'       DCT_MPO_ALLOWED,',
'       DCT_STATUS,',
'       DCT_TASK_RATE,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       DIRECTOR_PERSON_ID,',
'       ED_PERSON_ID,',
'              ''<span class="fa fa-copy" aria-hidden="true"></span>'' Copy',
'  from TASK',
' order by project_number, task_number'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Task Approvers Report'
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
 p_id=>wwv_flow_api.id(104984035549139188)
,p_name=>'Report 1'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:29:&SESSION.::&DEBUG.:RP:P29_PROJECT_NUMBER,P29_TASK_NUMBER:\#PROJECT_NUMBER#\,\#TASK_NUMBER#\'
,p_detail_link_text=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_owner=>'TCA9051'
,p_internal_uid=>108299996840045444
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104983999097139189)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104983621889139190)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104983185937139190)
,p_db_column_name=>'TASK_NAME'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Task Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104982786803139190)
,p_db_column_name=>'TASK_DESCRIPTION'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Task Description'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104982380633139191)
,p_db_column_name=>'TASK_START_DATE'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Task Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104981968355139191)
,p_db_column_name=>'TASK_END_DATE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Task End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104981541679139191)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104981137853139191)
,p_db_column_name=>'BUDGET_GROUP_CODE'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Budget Group Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104980741493139191)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104980371165139191)
,p_db_column_name=>'FUTURE1'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104979973834139192)
,p_db_column_name=>'FUTURE2'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104979589472139192)
,p_db_column_name=>'DCT_SECTOR_ID'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'DCT Sector'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104979171449139192)
,p_db_column_name=>'DCT_DEPARTMENT_ID'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'DCT Department'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104978807485139192)
,p_db_column_name=>'DCT_SECTION_ID'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'DCT Section'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104978392306139192)
,p_db_column_name=>'DCT_UNIT_ID'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'DCT Unit'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104977958509139192)
,p_db_column_name=>'DCT_TASK_NAME'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'DCT Task Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104977594529139193)
,p_db_column_name=>'DCT_SERVICE_PROVIDER'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Service Provider'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104977180533139193)
,p_db_column_name=>'DCT_MPR_ALLOWED'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'DCT MPR Allowed'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104976763736139193)
,p_db_column_name=>'DCT_MPO_ALLOWED'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'DCT MPO Allowed'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104976402139139193)
,p_db_column_name=>'DCT_STATUS'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'DCT Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104975987461139193)
,p_db_column_name=>'DCT_TASK_RATE'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'DCT Task Rate'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104975539958139193)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104975174725139194)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104974774906139194)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104974416842139194)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104974019495139194)
,p_db_column_name=>'DIRECTOR_PERSON_ID'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'Director'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104973623233139194)
,p_db_column_name=>'ED_PERSON_ID'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Eexcutive Director'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99508844008908483)
,p_db_column_name=>'COPY'
,p_display_order=>37
,p_column_identifier=>'AC'
,p_column_label=>'Copy'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(104935849319280129)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1083482'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PROJECT_NUMBER:TASK_NUMBER:COST_CENTER:FUTURE2:DIRECTOR_PERSON_ID:ED_PERSON_ID:UPDATED_BY:UPDATED_ON::COPY'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(104971334391139200)
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
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(104970175691139204)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(104984517173139188)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:29:&SESSION.::&DEBUG.:29'
,p_button_condition_type=>'NEVER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(104972443306139198)
,p_name=>'Edit Report - Dialog Closed'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(104984517173139188)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(104971959221139199)
,p_event_id=>wwv_flow_api.id(104972443306139198)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(104984517173139188)
);
wwv_flow_api.component_end;
end;
/
