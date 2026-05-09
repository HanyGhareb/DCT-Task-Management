prompt --application/pages/page_00040
begin
--   Manifest
--     PAGE: 00040
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>40
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'Data Points All Report'
,p_alias=>'DATA-POINTS-ALL-REPORT'
,p_step_title=>'Data Points All Report'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20221213073408'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(139612773954195970)
,p_plug_name=>'Data Points All Report'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DATA_POINT_ID,',
'       DATA_POINT_NAME,',
'       COMPONENT_ID,',
'       ORDER_NUM,',
'       APPENDIX_ID,',
'       DEFAULT_TEXT,',
'       ALLOW_EDIT,',
'       STATUS,',
'       START_DATE,',
'       END_DATE,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       GUIDELINE,',
'       CUSTOM_LABEL',
'  from DP_SCOPE_DATA_POINTS',
'  order by APPENDIX_ID, COMPONENT_ID, ORDER_NUM'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Data Points All Report'
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
 p_id=>wwv_flow_api.id(139613131633195970)
,p_name=>'Report 1'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:41:&SESSION.::&DEBUG.:RP:P41_DATA_POINT_ID:\#DATA_POINT_ID#\'
,p_detail_link_text=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_owner=>'TCA9051'
,p_internal_uid=>139613131633195970
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(139613296787195969)
,p_db_column_name=>'DATA_POINT_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Data Point Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(139613650708195968)
,p_db_column_name=>'DATA_POINT_NAME'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Data Point Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(139614866231195968)
,p_db_column_name=>'APPENDIX_ID'
,p_display_order=>12
,p_column_identifier=>'E'
,p_column_label=>'Appendix'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(136727294356003195)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(139614007894195968)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>22
,p_column_identifier=>'C'
,p_column_label=>'Component'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(139639858043057475)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(139614443193195968)
,p_db_column_name=>'ORDER_NUM'
,p_display_order=>32
,p_column_identifier=>'D'
,p_column_label=>'Order Num'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(139615227607195967)
,p_db_column_name=>'DEFAULT_TEXT'
,p_display_order=>42
,p_column_identifier=>'F'
,p_column_label=>'Default Text'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(139615659837195967)
,p_db_column_name=>'ALLOW_EDIT'
,p_display_order=>52
,p_column_identifier=>'G'
,p_column_label=>'Allow Edit'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(139616081804195967)
,p_db_column_name=>'STATUS'
,p_display_order=>62
,p_column_identifier=>'H'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128342850308489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(139616456043195967)
,p_db_column_name=>'START_DATE'
,p_display_order=>72
,p_column_identifier=>'I'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(139616878235195967)
,p_db_column_name=>'END_DATE'
,p_display_order=>82
,p_column_identifier=>'J'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(139617214206195967)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>92
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(139617665952195966)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>102
,p_column_identifier=>'L'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(139618020411195966)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>112
,p_column_identifier=>'M'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(139618460290195959)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>122
,p_column_identifier=>'N'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(139618814551195959)
,p_db_column_name=>'GUIDELINE'
,p_display_order=>132
,p_column_identifier=>'O'
,p_column_label=>'Guideline'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(139619242388195952)
,p_db_column_name=>'CUSTOM_LABEL'
,p_display_order=>142
,p_column_identifier=>'P'
,p_column_label=>'Custom Label'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(139637928122134045)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1396380'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'DATA_POINT_NAME:CUSTOM_LABEL:APPENDIX_ID:COMPONENT_ID:ORDER_NUM:ALLOW_EDIT:STATUS:START_DATE:END_DATE:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(139620566673195947)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127813188296449776)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(127749711524449850)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(127867332295449731)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(139621789124195946)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(139612773954195970)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'New Data Point'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:41:&SESSION.::&DEBUG.:41'
,p_icon_css_classes=>'fa-window-plus'
);
wwv_flow_api.component_end;
end;
/
