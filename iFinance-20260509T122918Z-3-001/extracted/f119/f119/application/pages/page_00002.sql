prompt --application/pages/page_00002
begin
--   Manifest
--     PAGE: 00002
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>119
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>2
,p_user_interface_id=>wwv_flow_api.id(113032535677949805)
,p_name=>'Duty Travel Details'
,p_alias=>'DUTY-TRAVEL-DETAILS'
,p_step_title=>'Duty Travel Details'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>wwv_flow_api.id(112911855690949897)
,p_page_template_options=>'#DEFAULT#'
,p_deep_linking=>'Y'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220626122329'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(444329769090698625)
,p_plug_name=>'Main Details'
,p_icon_css_classes=>'fa-list-alt'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(112947951445949865)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(444330176869698624)
,p_plug_name=>'Summary'
,p_parent_plug_id=>wwv_flow_api.id(444329769090698625)
,p_icon_css_classes=>'fa-file-o'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(112947951445949865)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(444378946299509227)
,p_plug_name=>'Header Details'
,p_parent_plug_id=>wwv_flow_api.id(444329769090698625)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(112947951445949865)
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>7
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(444414299971382730)
,p_plug_name=>'Audit'
,p_parent_plug_id=>wwv_flow_api.id(444378946299509227)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(112930923413949881)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(444330566782698624)
,p_plug_name=>'Budget Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(112947951445949865)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(444417055032382758)
,p_plug_name=>'Budget Report'
,p_parent_plug_id=>wwv_flow_api.id(444330566782698624)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(112946076615949866)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       REQUEST_ID,',
'       ENTITY_CODE,',
'       COST_CENTER,',
'       BUDGET_GROUP_CODE,',
'       GL_ACCOUNT,',
'       ACTIVITY,',
'       FUTURE1,',
'       FUTURE2,',
'       PROJECT_NUMBER,',
'       TASK_NUMBER,',
'       EXPENDITURE_TYPE,',
'       AMOUNT,',
'       COMMENTS,',
'       ACTION_BY,',
'       CREATED_ON,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'              (ENTITY_CODE',
'       ||''.'' ||',
'       COST_CENTER',
'       ||''.'' ||',
'       BUDGET_GROUP_CODE',
'       ||''.'' ||',
'       GL_ACCOUNT',
'       ||''.'' ||',
'       ACTIVITY',
'       ||''.'' ||',
'       FUTURE1',
'       ||''.'' ||',
'       FUTURE2) gl_combination',
'  from MISSION_DISTRIBUTIONS',
'  where REQUEST_ID = :P2_REQUEST_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P2_REQUEST_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Budget Report'
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
 p_id=>wwv_flow_api.id(444417164619382759)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>444417164619382759
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113191053262909017)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113191496579909016)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113191889588909016)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113192260205909016)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113192613263909016)
,p_db_column_name=>'BUDGET_GROUP_CODE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Budget Group Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113193064279909016)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113193463233909015)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113193834896909015)
,p_db_column_name=>'FUTURE1'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113194231461909015)
,p_db_column_name=>'FUTURE2'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113194628417909015)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113195046175909015)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113195487281909015)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113195805591909014)
,p_db_column_name=>'AMOUNT'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113196218054909014)
,p_db_column_name=>'COMMENTS'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113196609209909014)
,p_db_column_name=>'ACTION_BY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Action By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113197044749909014)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113197417852909014)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(113226560822908985)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113197830479909013)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(113226560822908985)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113198234457909013)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113190664827909017)
,p_db_column_name=>'GL_COMBINATION'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'GL Combination'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(444610572822114100)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1131986'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:GL_COMBINATION:AMOUNT:COMMENTS:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(444330934677698624)
,p_plug_name=>'Legs'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(112947951445949865)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P2_OVERSEAS_YN'
,p_plug_display_when_cond2=>'Y'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(444414934927382737)
,p_plug_name=>'Legs Report'
,p_parent_plug_id=>wwv_flow_api.id(444330934677698624)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(112946076615949866)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       REQUEST_ID,',
'       SEQ,',
'       COUNTRY,',
'       CITY,',
'       NO_OF_DAYS,',
'       START_DATE,',
'       END_DATE,',
'       SELF_HOSPITALITY_YN,',
'       TICKET_REQUEST,',
'       NOTES,',
'       CREATED_BY_PERSON_ID,',
'       UPDATED_BY_PERSON_ID,',
'       CREATION_DATE,',
'       UPDATED_DATE',
'  from MISSION_LEGS',
'  where REQUEST_ID = :P2_REQUEST_ID',
'  order by SEQ;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P2_REQUEST_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Legs Report'
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
 p_id=>wwv_flow_api.id(444415029938382738)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>444415029938382738
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113200037952909009)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113200479373909009)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113200829036909009)
,p_db_column_name=>'SEQ'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113201202942909009)
,p_db_column_name=>'COUNTRY'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Country'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(113239155443908974)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113201691332909008)
,p_db_column_name=>'CITY'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'City'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113202024471909008)
,p_db_column_name=>'NO_OF_DAYS'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Days'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113202446569909008)
,p_db_column_name=>'START_DATE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113202846032909008)
,p_db_column_name=>'END_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113203234478909008)
,p_db_column_name=>'SELF_HOSPITALITY_YN'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Self Hospitality ?'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(113233637876908976)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113203620117909007)
,p_db_column_name=>'TICKET_REQUEST'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Ticket Request'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(113236889573908975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113204068437909007)
,p_db_column_name=>'NOTES'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113204478915909007)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(113226560822908985)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113204876979909007)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(113226560822908985)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113205263994909007)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113205672711909006)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(444518515865773661)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1132060'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SEQ:COUNTRY:CITY:NO_OF_DAYS:START_DATE:END_DATE:SELF_HOSPITALITY_YN:TICKET_REQUEST:NOTES:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(444569497988247629)
,p_plug_name=>'Documents'
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(112947951445949865)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(444569573869247630)
,p_plug_name=>'Documents report'
,p_parent_plug_id=>wwv_flow_api.id(444569497988247629)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(112946076615949866)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ROW_VERSION_NUMBER,',
'       REQUEST_ID,',
'       FILENAME,',
'       FILE_MIMETYPE,',
'       FILE_CHARSET,',
'       FILE_BLOB,',
'       FILE_COMMENTS,',
'       TAGS,',
'       CREATED,',
'       CREATED_BY_PERSON_ID,',
'       UPDATED,',
'       UPDATED_BY_PERSON_ID,',
'       sys.dbms_lob.getlength(file_blob) as file_size,',
'    sys.dbms_lob.getlength(file_blob) as download',
'  from mission_documents',
'  where REQUEST_ID = :P2_REQUEST_ID',
'  order by UPDATED desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P2_REQUEST_ID'
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
 p_id=>wwv_flow_api.id(444569645877247631)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No attachments available. '
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>444569645877247631
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113207432087909005)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113207820453909005)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113208280416909005)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113208676830909005)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'File Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113209033347909004)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113209484665909004)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113209853911909004)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113210249806909004)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113210674626909004)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113211009605909003)
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
 p_id=>wwv_flow_api.id(113211480838909003)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(113226560822908985)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113211815231909003)
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
 p_id=>wwv_flow_api.id(113212220100909003)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(113226560822908985)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113212647319909003)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113213018642909002)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:MISSION_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(444611119727113866)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1132134'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:UPDATED:UPDATED_BY_PERSON_ID:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(444571580575247650)
,p_plug_name=>'Approval History'
,p_icon_css_classes=>'fa-users'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(112947951445949865)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_plug_display_when_condition=>'P2_REQUEST_STATUS'
,p_plug_display_when_cond2=>'Draft'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(444571694382247651)
,p_plug_name=>'Approval History Report'
,p_parent_plug_id=>wwv_flow_api.id(444571580575247650)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(112946076615949866)
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
' --   h.approval_type,',
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
'    mission_approval_history h, dct_employees_list2  e',
'where h.person_id = e.person_id (+)',
'and h.request_id = :P2_REQUEST_ID',
'order by h.STEP_NO ',
'--, h.ID',
';'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P2_REQUEST_ID'
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
 p_id=>wwv_flow_api.id(444571787942247652)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>444571787942247652
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113214444874909001)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113214892221909001)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113215297811909001)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113215686701909000)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113216000007909000)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Role'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(113233008623908977)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113216490392909000)
,p_db_column_name=>'ROLE_DESC'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Role Desc'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113216894991909000)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113217244662909000)
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
 p_id=>wwv_flow_api.id(113217669860909000)
,p_db_column_name=>'STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>119
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113218002295908999)
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
 p_id=>wwv_flow_api.id(113218443838908999)
,p_db_column_name=>'COMMENTS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113218811647908999)
,p_db_column_name=>'STATUS_CLASS'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Status Class'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113219249215908999)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113219699185908998)
,p_db_column_name=>'PHOTO'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(444625594988940261)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1132200'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:PHOTO:FULL_NAME_EN:ROLE_ID:ACTION_REQUIRED:RECEVIED_DATE:STATUS:ACTION_DATE:COMMENTS:'
,p_sort_column_1=>'STEP_NO'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(113220436992908998)
,p_report_id=>wwv_flow_api.id(444625594988940261)
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
 p_id=>wwv_flow_api.id(113206753606909006)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(444569497988247629)
,p_button_name=>'New_document'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI'
,p_button_template_id=>wwv_flow_api.id(113009327738949830)
,p_button_image_alt=>'New Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:15:&SESSION.::&DEBUG.::P15_REQUEST_ID,P15_PAGE_FROM:&P2_REQUEST_ID.,13'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(113226278597908989)
,p_branch_name=>'Go to 18'
,p_branch_action=>'f?p=&APP_ID.:18:&SESSION.::&DEBUG.::P18_REQUEST_ID:&P20_REQUEST_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(113225808389908989)
,p_branch_name=>'Go to  &P13_PAGE_FROM.'
,p_branch_action=>'f?p=&APP_ID.:&P20_PAGE_FROM.:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(112464389814303340)
,p_name=>'P2_HASH_CODE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(444329769090698625)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113171699420909031)
,p_name=>'P2_REQUEST_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(444329769090698625)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113172010690909030)
,p_name=>'P2_YEAR'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(444329769090698625)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113172458260909030)
,p_name=>'P2_SEQ'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(444329769090698625)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113172802756909030)
,p_name=>'P2_HISTORY_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(444329769090698625)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113173231028909029)
,p_name=>'P2_PAGE_FROM'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(444329769090698625)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113173658750909029)
,p_name=>'P2_APPROVAL_TYPE_ID'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(444329769090698625)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113174642569909027)
,p_name=>'P2_REQUEST_STATUS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(444330176869698624)
,p_prompt=>'Request Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113175074045909027)
,p_name=>'P2_COMPLETE_STATUS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(444330176869698624)
,p_prompt=>'Complete Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P2_REQUEST_STATUS'
,p_display_when2=>'Approved'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113175497295909027)
,p_name=>'P2_GRADE_CODE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(444330176869698624)
,p_prompt=>'Grade'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113175884122909026)
,p_name=>'P2_GRADE_RATE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(444330176869698624)
,p_prompt=>'Grade Rate'
,p_post_element_text=>'&nbsp; &nbsp; <b>AED</b>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113176259654909026)
,p_name=>'P2_DAYS'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(444330176869698624)
,p_prompt=>'Mission Days'
,p_post_element_text=>'&nbsp; &nbsp; <b>Days</b>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113176632211909026)
,p_name=>'P2_ADDITIONAL_DAYS'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(444330176869698624)
,p_prompt=>'Additional Days'
,p_post_element_text=>'&nbsp; &nbsp; <b>Days</b>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113177052707909026)
,p_name=>'P2_ELIGIBLE_PCT'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(444330176869698624)
,p_prompt=>'Eligible %'
,p_post_element_text=>'&nbsp; &nbsp; <b>%</b>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113177481685909026)
,p_name=>'P2_AMOUNT'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(444330176869698624)
,p_prompt=>'Eligible Amount '
,p_post_element_text=>'&nbsp; &nbsp; <b>AED</b>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113177856470909025)
,p_name=>'P2_SUBMITTED_ON'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(444330176869698624)
,p_prompt=>'Submitted On'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P2_REQUEST_STATUS'
,p_display_when2=>'Draft'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113178266215909025)
,p_name=>'P2_SUBMITTED_BY'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(444330176869698624)
,p_prompt=>'Submitted By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name , user_details.get_emp_emirate(person_id) Emirate',
'FROM employees_v e',
'where CURRENT_FLAG = ''Y'''))
,p_display_when=>'P2_REQUEST_STATUS'
,p_display_when2=>'Draft'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113178661815909025)
,p_name=>'P2_REJECTED_BY'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(444330176869698624)
,p_prompt=>'Rejected By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name , user_details.get_emp_emirate(person_id) Emirate',
'FROM employees_v e',
'where CURRENT_FLAG = ''Y'''))
,p_display_when=>'P2_REQUEST_STATUS'
,p_display_when2=>'Rejected'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113179030776909025)
,p_name=>'P2_FINAL_REJECT_ON'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(444330176869698624)
,p_prompt=>'Final Reject On'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P2_REQUEST_STATUS'
,p_display_when2=>'Rejected'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113179490009909025)
,p_name=>'P2_REJECT_REASON'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(444330176869698624)
,p_prompt=>'Reject Reason'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P2_REQUEST_STATUS'
,p_display_when2=>'Rejected'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113180191113909024)
,p_name=>'P2_REQUEST_NO'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(444378946299509227)
,p_prompt=>'Request No'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113180583977909024)
,p_name=>'P2_REQUEST_TYPE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(444378946299509227)
,p_prompt=>'Request Type'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'MISSION REQUEST TYPES'
,p_lov=>'.'||wwv_flow_api.id(113237722857908974)||'.'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113180993949909024)
,p_name=>'P2_REQUEST_FOR'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(444378946299509227)
,p_prompt=>'Request For'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113181309838909024)
,p_name=>'P2_REQUEST_DATE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(444378946299509227)
,p_prompt=>'Request Date'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113181788833909024)
,p_name=>'P2_START_DATE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(444378946299509227)
,p_prompt=>'Start Date'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113182107047909023)
,p_name=>'P2_END_DATE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(444378946299509227)
,p_prompt=>'End Date'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113182501413909023)
,p_name=>'P2_OVERSEAS_YN'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(444378946299509227)
,p_prompt=>'Overseas ?'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(113233637876908976)||'.'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113182938841909023)
,p_name=>'P2_PRIORITY'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(444378946299509227)
,p_prompt=>'Priority'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'PRIORITY LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id',
'from dct_lookup_values',
'where lookup_id = (Select x.lookup_id',
'                    from dct_lookups x',
'                    where x.LOOKUP_CODE = ''PRIORITY'');'))
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113183362230909023)
,p_name=>'P2_EMIRATE'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(444378946299509227)
,p_prompt=>'Emirate'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMIRATES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    value,',
'    value_id',
'FROM',
'    dct_lookup_values',
'WHERE',
'        lookup_id = 35',
'    AND status = ''A''',
'    AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)',
'order by 1'))
,p_display_when=>'P2_OVERSEAS_YN'
,p_display_when2=>'N'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113183762995909023)
,p_name=>'P2_FULL_DAY_YN'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(444378946299509227)
,p_prompt=>'Full Day ?'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(113233637876908976)||'.'
,p_display_when=>'P2_OVERSEAS_YN'
,p_display_when2=>'N'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113184114185909023)
,p_name=>'P2_TRAVEL_ABOVE_10HR_YN'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(444378946299509227)
,p_prompt=>'Travel Above 10hr ?'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(113233637876908976)||'.'
,p_display_when=>'P2_OVERSEAS_YN'
,p_display_when2=>'Y'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113184557802909022)
,p_name=>'P2_TICKET_REQUEST'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(444378946299509227)
,p_prompt=>'Ticket Request ?'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'TICKET REQUEST CHOICES'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    value,',
'    value_id',
'FROM',
'    dct_lookup_values',
'WHERE',
'        lookup_id = 36',
'    AND status = ''A''',
'    AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)',
'order by 1'))
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113184992633909022)
,p_name=>'P2_HOSPITALITY_YN'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(444378946299509227)
,p_prompt=>'Hospitality'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(113233637876908976)||'.'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113185321203909022)
,p_name=>'P2_TRANSPORTATION'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(444378946299509227)
,p_prompt=>'Transportation'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113185751855909022)
,p_name=>'P2_JUSTIFICATION'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(444378946299509227)
,p_prompt=>'Justification'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113186122620909022)
,p_name=>'P2_PURPOSE_EU'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(444378946299509227)
,p_prompt=>'Purpose'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113186583049909021)
,p_name=>'P2_FINAL_APPROVE_ON'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(444378946299509227)
,p_prompt=>'Final Approve On'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P2_REQUEST_STATUS'
,p_display_when2=>'Approved'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113186980970909021)
,p_name=>'P2_CANCEL_ON'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(444378946299509227)
,p_prompt=>'Cancel on'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P2_REQUEST_STATUS'
,p_display_when2=>'Cancel'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113187352607909021)
,p_name=>'P2_CANCELLED_BY'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(444378946299509227)
,p_prompt=>'Cancel By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name , user_details.get_emp_emirate(person_id) Emirate',
'FROM employees_v e',
'where CURRENT_FLAG = ''Y'''))
,p_display_when=>'P2_REQUEST_STATUS'
,p_display_when2=>'Cancel'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113187769013909021)
,p_name=>'P2_CANCEL_REASON'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(444378946299509227)
,p_prompt=>'Reason'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P2_REQUEST_STATUS'
,p_display_when2=>'Cancel'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113188494221909020)
,p_name=>'P2_CREATED_BY_PERSON_ID'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(444414299971382730)
,p_prompt=>'Created By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name , user_details.get_emp_emirate(person_id) Emirate',
'FROM employees_v e',
'where CURRENT_FLAG = ''Y'''))
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113188872111909020)
,p_name=>'P2_CREATION_DATE'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_api.id(444414299971382730)
,p_prompt=>'Created on'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113189258568909020)
,p_name=>'P2_UPDATED_BY_PERSON_ID'
,p_item_sequence=>320
,p_item_plug_id=>wwv_flow_api.id(444414299971382730)
,p_prompt=>'Updated By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name , user_details.get_emp_emirate(person_id) Emirate',
'FROM employees_v e',
'where CURRENT_FLAG = ''Y'''))
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(113189652510909020)
,p_name=>'P2_UPDATED_DATE'
,p_item_sequence=>330
,p_item_plug_id=>wwv_flow_api.id(444414299971382730)
,p_prompt=>'Update on'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(113008783738949831)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(113224802221908991)
,p_name=>'New'
,p_event_sequence=>40
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(444414934927382737)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(113225322825908990)
,p_event_id=>wwv_flow_api.id(113224802221908991)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(444414934927382737)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(113224463734908992)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialize Mission details'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    request_id,',
'    request_no,',
'    to_char(request_date,''DD-MON-YYYY'')                     request_date,',
'    user_details.get_full_name(request_for)                 request_for,',
'    MISSION_UTIL.get_grade(grade_code)                      grade_code,',
'    to_char(MISSION_UTIL.get_mission_rate(grade_code,overseas_yn),''99,999,999.99'')   grade_rate,',
'    overseas_yn,',
'    emirate,',
'    full_day_yn,',
'    travel_above_10hr_yn,',
'    ticket_request,',
'    hospitality_yn,',
'    transportation,',
'    to_char(start_date,''DD-MON-YYYY'')                       start_date,',
'    to_char(end_date,''DD-MON-YYYY'')                         end_date,',
'    request_status,',
'    complete_status,',
'    justification,',
'    year,',
'    purpose_eu,',
'    priority,',
'    to_char(submitted_on,''DD-MON-YYYY HH:MIPM'')             submitted_on,',
'    submitted_by,',
'    seq,',
'    to_char(final_approve_on,''DD-MON-YYYY HH:MIPM'')         final_approve_on,',
'    request_type,',
'    to_char(final_reject_on,''DD-MON-YYYY HH:MIPM'')          final_reject_on,',
'    rejected_by,',
'    reject_reason,',
'    to_char(cancel_on,''DD-MON-YYYY HH:MIPM'')                cancel_on,',
'    cancelled_by,',
'    cancel_reason,',
'    approval_type_id,',
'    created_by_person_id,',
'    updated_by_person_id,',
'    to_char(creation_date,''DD-MON-YYYY HH:MIPM'')            creation_date,',
'    to_char(updated_date,''DD-MON-YYYY HH:MIPM'')             updated_date,',
' --   to_char(amount , ''99,999,999,999.99'')                   amount,',
'    (end_date - start_date) + 1                             Mission_days,',
'    case when overseas_yn = ''Y'' and travel_above_10hr_yn = ''Y''',
'            Then 4',
'         when overseas_yn = ''Y'' and travel_above_10hr_yn = ''N''  ',
'            Then 2',
'         else',
'            0',
'    End                                                 additional_days,',
'    to_char(MISSION_UTIL.get_mission_amount(request_id) , ''99,999,999,999.99'')         mission_amount,',
'    MISSION_UTIL.get_Eligible_pct(overseas_yn, full_day_yn, hospitality_yn)              eligible_pct',
'into',
'    :P2_REQUEST_ID,',
'    :P2_REQUEST_NO,',
'    :P2_REQUEST_DATE,',
'    :P2_REQUEST_FOR,',
'    :P2_GRADE_CODE,',
'    :P2_GRADE_RATE,',
'    :P2_OVERSEAS_YN,',
'    :P2_EMIRATE,',
'    :P2_FULL_DAY_YN,',
'    :P2_TRAVEL_ABOVE_10HR_YN,',
'    :P2_TICKET_REQUEST,',
'    :P2_HOSPITALITY_YN,',
'    :P2_TRANSPORTATION,',
'    :P2_START_DATE,',
'    :P2_END_DATE,',
'    :P2_REQUEST_STATUS,',
'    :P2_COMPLETE_STATUS,',
'    :P2_JUSTIFICATION,',
'    :P2_YEAR,',
'    :P2_PURPOSE_EU,',
'    :P2_PRIORITY,',
'    :P2_SUBMITTED_ON,',
'    :P2_SUBMITTED_BY,',
'    :P2_SEQ,',
'    :P2_FINAL_APPROVE_ON,',
'    :P2_REQUEST_TYPE,',
'    :P2_FINAL_REJECT_ON,',
'    :P2_REJECTED_BY,',
'    :P2_REJECT_REASON,',
'    :P2_CANCEL_ON,',
'    :P2_CANCELLED_BY,',
'    :P2_CANCEL_REASON,',
'    :P2_APPROVAL_TYPE_ID,',
'    :P2_CREATED_BY_PERSON_ID,',
'    :P2_UPDATED_BY_PERSON_ID,',
'    :P2_CREATION_DATE,',
'    :P2_UPDATED_DATE,',
'--    :P2_AMOUNT,',
'    :P2_DAYS,',
'    :P2_ADDITIONAL_DAYS,',
'    :P2_AMOUNT,',
'    :P2_ELIGIBLE_PCT',
'FROM    ',
'    mission_header',
'WHERE hash_code = :P2_HASH_CODE;',
''))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
