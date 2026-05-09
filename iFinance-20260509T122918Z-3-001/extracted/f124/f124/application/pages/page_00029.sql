prompt --application/pages/page_00029
begin
--   Manifest
--     PAGE: 00029
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
 p_id=>29
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'APPENDIX B - TECHNICAL EVALUATION CRITERIA'
,p_alias=>'APPENDIX-B-TECHNICAL-EVALUATION-CRITERIA'
,p_step_title=>'APPENDIX B - TECHNICAL EVALUATION CRITERIA'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231104141310'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(137983294112452579)
,p_plug_name=>'APPENDIX B - TECHNICAL EVALUATION CRITERIA'
,p_region_template_options=>'#DEFAULT#:t-Wizard--showTitle:t-Wizard--hideStepsXSmall'
,p_component_template_options=>'js-wizardProgressLinks:t-WizardSteps--displayLabels'
,p_plug_template=>wwv_flow_api.id(127814120729449775)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_list_id=>wwv_flow_api.id(137979330732452596)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(127843097216449755)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(680038871236381)
,p_plug_name=>'Note'
,p_parent_plug_id=>wwv_flow_api.id(137983294112452579)
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--info:t-Alert--removeHeading'
,p_plug_template=>wwv_flow_api.id(127772628480449819)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p><span style="color: #ff0000;">Please note that your technical evaluation criteria must total 100%. </span><br /><span style="color: #0000ff;"><strong><span style="text-decoration: underline;">Total Weight:</span></strong> &P29_TOTAL_WEIGHT. </span'
||'></p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(137983345169452579)
,p_plug_name=>'APPENDIX B - TECHNICAL EVALUATION CRITERIA'
,p_parent_plug_id=>wwv_flow_api.id(137983294112452579)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127776395121449810)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138126708074298902)
,p_plug_name=>'Technical Criteria - Compliance with SOW'
,p_parent_plug_id=>wwv_flow_api.id(137983345169452579)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P29_TEMPLATE_ID  , 16  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(140895853538593011)
,p_plug_name=>'Technical Criteria 1 - Compliance with SOW Report'
,p_parent_plug_id=>wwv_flow_api.id(138126708074298902)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_B_ID,',
'       COMPONENT_ID,',
'       CRITERION_TEXT,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       TEMPLATE_ID,',
'       DP_ITEM_ID,',
'       WEGHT',
'  from DP_SCOPING_B',
'    where COMPONENT_ID = :P29_TEMPLATE_COMPOENET_ID_16',
'  and DP_SCOPING_B_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_TEMPLATE_COMPOENET_ID_16,P28_DP_ITEM_ID,P28_TEMPLATE_ID,P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Technical Criteria 1 - Compliance with SOW Report'
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
 p_id=>wwv_flow_api.id(140895988429593012)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::P47_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>140895988429593012
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140896003275593013)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140896117690593014)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140896270842593015)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140896388307593016)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140896444682593017)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140896551225593018)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140896671266593019)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140896708378593020)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140896887331593021)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140896927760593022)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140897068878593023)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(679783224236378)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141001361674174904)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1410014'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:WEGHT:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138126822729298903)
,p_plug_name=>'Technical Criteria - Concept and Program Development  '
,p_parent_plug_id=>wwv_flow_api.id(137983345169452579)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P29_TEMPLATE_ID  , 17  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(140898218538593035)
,p_plug_name=>'Technical Criteria - Concept and Program Development Report'
,p_parent_plug_id=>wwv_flow_api.id(138126822729298903)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_B_ID,',
'       COMPONENT_ID,',
'       CRITERION_TEXT,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       TEMPLATE_ID,',
'       DP_ITEM_ID,',
'       WEGHT',
'  from DP_SCOPING_B',
'  where COMPONENT_ID = :P29_TEMPLATE_COMPOENET_ID_17',
'  and DP_SCOPING_B_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_TEMPLATE_COMPOENET_ID_17,P28_DP_ITEM_ID,P28_TEMPLATE_ID,P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Technical Criteria - Concept and Program Development Report'
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
 p_id=>wwv_flow_api.id(140898312305593036)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::P47_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>140898312305593036
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140898447743593037)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140898545787593038)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140898616314593039)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140898769644593040)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140898818077593041)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140898947664593042)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140899022979593043)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140899134759593044)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140899256288593045)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140899317968593046)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140899491542593047)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2239006001188052)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141034852191804299)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1410349'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138127078778298905)
,p_plug_name=>'Technical Criteria 3- Agency''s Experience '
,p_parent_plug_id=>wwv_flow_api.id(137983345169452579)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P29_TEMPLATE_ID  , 18  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141054060858920202)
,p_plug_name=>'Technical Criteria - Agency''s Experience'
,p_parent_plug_id=>wwv_flow_api.id(138127078778298905)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_B_ID,',
'       COMPONENT_ID,',
'       CRITERION_TEXT,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       TEMPLATE_ID,',
'       DP_ITEM_ID,',
'       WEGHT',
'  from DP_SCOPING_B',
'  where COMPONENT_ID = :P29_TEMPLATE_COMPOENET_ID_18',
'  and DP_SCOPING_B_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P28_DP_ITEM_ID,P28_TEMPLATE_ID,P28_SCOPE_ID,P29_TEMPLATE_COMPOENET_ID_18'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Technical Criteria - Agency''s Experience'
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
 p_id=>wwv_flow_api.id(141054135200920203)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::P47_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>141054135200920203
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141054215013920204)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141054386885920205)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141054411463920206)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141054573149920207)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141054649575920208)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141054745511920209)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141054882939920210)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141054949773920211)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141055016174920212)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141055190708920213)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141055286867920214)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2239094078188053)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141224706377531308)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1412248'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138127230733298907)
,p_plug_name=>'Technical Criteria  - Methodology and Technical Approach'
,p_parent_plug_id=>wwv_flow_api.id(137983345169452579)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P29_TEMPLATE_ID  , 19  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141055514094920217)
,p_plug_name=>'Technical Criteria - Methodology and Technical Approach Report'
,p_parent_plug_id=>wwv_flow_api.id(138127230733298907)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_B_ID,',
'       COMPONENT_ID,',
'       CRITERION_TEXT,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       TEMPLATE_ID,',
'       DP_ITEM_ID,',
'       WEGHT',
'  from DP_SCOPING_B',
'  where COMPONENT_ID = :P29_TEMPLATE_COMPOENET_ID_19',
'  and DP_SCOPING_B_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_TEMPLATE_COMPOENET_ID_19,P28_DP_ITEM_ID,P28_TEMPLATE_ID,P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Technical Criteria - Methodology and Technical Approach Report'
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
 p_id=>wwv_flow_api.id(141055654937920218)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::P47_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>141055654937920218
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141055728332920219)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141055848792920220)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141055929537920221)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141056090999920222)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141056152107920223)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141056241397920224)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141056368954920225)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141056413597920226)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141056589793920227)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141056668358920228)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141056748778920229)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2238883172188051)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141225369634531061)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1412254'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:WEGHT:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138127480491298909)
,p_plug_name=>'Technical Criteria  - Other Considerations'
,p_parent_plug_id=>wwv_flow_api.id(137983345169452579)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P29_TEMPLATE_ID  , 20  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141057054961920232)
,p_plug_name=>'Technical Criteria 5 - Other Considerations Report'
,p_parent_plug_id=>wwv_flow_api.id(138127480491298909)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_B_ID,',
'       COMPONENT_ID,',
'       CRITERION_TEXT,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       TEMPLATE_ID,',
'       DP_ITEM_ID,',
'       WEGHT',
'  from DP_SCOPING_B',
'  where COMPONENT_ID = :P29_TEMPLATE_COMPOENET_ID_20',
'  and DP_SCOPING_B_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_TEMPLATE_COMPOENET_ID_20,P28_DP_ITEM_ID,P28_TEMPLATE_ID,P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Technical Criteria 5 - Other Considerations Report'
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
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(141057112768920233)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::P47_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>141057112768920233
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141057232619920234)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141057352647920235)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141057452500920236)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141057589271920237)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141057627021920238)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141057778590920239)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141057848118920240)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141057999208920241)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141058018858920242)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141058191600920243)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141058251490920244)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2239217473188054)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141225945451530822)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1412260'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141058313899920245)
,p_plug_name=>'Technical Criteria - Corporate experience and resources'
,p_parent_plug_id=>wwv_flow_api.id(137983345169452579)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P29_TEMPLATE_ID  , 81  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141058630005920248)
,p_plug_name=>'Technical Criteria - Corporate experience and resources Report'
,p_parent_plug_id=>wwv_flow_api.id(141058313899920245)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_B_ID,',
'       COMPONENT_ID,',
'       CRITERION_TEXT,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       TEMPLATE_ID,',
'       DP_ITEM_ID,',
'       WEGHT',
'  from DP_SCOPING_B',
'  where COMPONENT_ID = :P29_TEMPLATE_COMPOENET_ID_81',
'  and DP_SCOPING_B_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_TEMPLATE_COMPOENET_ID_81,P28_DP_ITEM_ID,P28_TEMPLATE_ID,P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Technical Criteria - Corporate experience and resources Report'
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
 p_id=>wwv_flow_api.id(141058772743920249)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::P47_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>141058772743920249
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141058873050920250)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141073854971875101)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141073941218875102)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141074051265875103)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141074147263875104)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141074246126875105)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141074382857875106)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141074459026875107)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141074559282875108)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141074681059875109)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141074718890875110)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2239257011188055)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141226565521530583)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1412266'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:WEGHT:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141074841447875111)
,p_plug_name=>'Technical Criteria - Management approach'
,p_parent_plug_id=>wwv_flow_api.id(137983345169452579)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>70
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P29_TEMPLATE_ID  , 82  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141075110284875114)
,p_plug_name=>'Technical Criteria - Management approach Report'
,p_parent_plug_id=>wwv_flow_api.id(141074841447875111)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_B_ID,',
'       COMPONENT_ID,',
'       CRITERION_TEXT,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       TEMPLATE_ID,',
'       DP_ITEM_ID,',
'       WEGHT',
'  from DP_SCOPING_B',
'  where COMPONENT_ID = :P29_TEMPLATE_COMPOENET_ID_82',
'  and DP_SCOPING_B_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_TEMPLATE_COMPOENET_ID_82,P28_DP_ITEM_ID,P28_TEMPLATE_ID,P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Technical Criteria - Management approach Report'
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
 p_id=>wwv_flow_api.id(141075299559875115)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::P47_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>141075299559875115
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141075315506875116)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141075410679875117)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141075573834875118)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141075658218875119)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141075789122875120)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141075897164875121)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141075922911875122)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141076006384875123)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141076191508875124)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141076266541875125)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141076392711875126)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2239382044188056)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141227159345530343)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1412272'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:WEGHT:NOTES:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141076482333875127)
,p_plug_name=>'Technical Criteria - Project Solution'
,p_parent_plug_id=>wwv_flow_api.id(137983345169452579)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>80
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P29_TEMPLATE_ID  , 83  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141076736008875130)
,p_plug_name=>'Technical Criteria - Project Solution Report'
,p_parent_plug_id=>wwv_flow_api.id(141076482333875127)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_B_ID,',
'       COMPONENT_ID,',
'       CRITERION_TEXT,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       TEMPLATE_ID,',
'       DP_ITEM_ID,',
'       WEGHT',
'  from DP_SCOPING_B',
'  where COMPONENT_ID = :P29_TEMPLATE_COMPOENET_ID_83',
'  and DP_SCOPING_B_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_TEMPLATE_COMPOENET_ID_83,P28_DP_ITEM_ID,P28_TEMPLATE_ID,P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Technical Criteria - Project Solution Report'
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
 p_id=>wwv_flow_api.id(141076833526875131)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::P47_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>141076833526875131
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141076914365875132)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141077034378875133)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141077130856875134)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141077227573875135)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141077327921875136)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141077434792875137)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141077549053875138)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141077639753875139)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141077713663875140)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141077826502875141)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141077997722875142)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2239444054188057)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141227711875530103)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1412278'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:WEGHT:NOTES:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141078090682875143)
,p_plug_name=>'Technical Criteria - Detailed project plan, timeline and deliverables, to include quality assurance program'
,p_parent_plug_id=>wwv_flow_api.id(137983345169452579)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>90
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P29_TEMPLATE_ID  , 84  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141078334965875146)
,p_plug_name=>'Technical Criteria - Detailed project plan, timeline and deliverables, to include quality assurance program Report'
,p_parent_plug_id=>wwv_flow_api.id(141078090682875143)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_B_ID,',
'       COMPONENT_ID,',
'       CRITERION_TEXT,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       TEMPLATE_ID,',
'       DP_ITEM_ID,',
'       WEGHT',
'  from DP_SCOPING_B',
'  where COMPONENT_ID = :P29_TEMPLATE_COMPOENET_ID_84',
'  and DP_SCOPING_B_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_TEMPLATE_COMPOENET_ID_84,P28_DP_ITEM_ID,P28_TEMPLATE_ID,P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Technical Criteria - Detailed project plan, timeline and deliverables, to include quality assurance program Report'
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
 p_id=>wwv_flow_api.id(141078491442875147)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::P47_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>141078491442875147
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141078514415875148)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141078601434875149)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141078733507875150)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141094151697835401)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141094284231835402)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141094385592835403)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141094474390835404)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141094518190835405)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141094625721835406)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141094787532835407)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141094818002835408)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2239593554188058)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141228352036529857)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1412284'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:WEGHT:NOTES:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141094921271835409)
,p_plug_name=>'Technical Criteria - Project completion report'
,p_parent_plug_id=>wwv_flow_api.id(137983345169452579)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>100
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P29_TEMPLATE_ID  , 85  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141095283030835412)
,p_plug_name=>'Technical Criteria - Project completion report report'
,p_parent_plug_id=>wwv_flow_api.id(141094921271835409)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_B_ID,',
'       COMPONENT_ID,',
'       CRITERION_TEXT,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       TEMPLATE_ID,',
'       DP_ITEM_ID,',
'       WEGHT',
'  from DP_SCOPING_B',
'  where COMPONENT_ID = :P29_TEMPLATE_COMPOENET_ID_85',
'  and DP_SCOPING_B_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_TEMPLATE_COMPOENET_ID_85,P28_DP_ITEM_ID,P28_TEMPLATE_ID,P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Technical Criteria - Project completion report report'
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
 p_id=>wwv_flow_api.id(141095344984835413)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::P47_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>141095344984835413
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141095437994835414)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141095578976835415)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141095605019835416)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141095710570835417)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141095854700835418)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141095995686835419)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141096096165835420)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141096157828835421)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141096260858835422)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141096359781835423)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141096458560835424)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2239715887188059)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141228980695529617)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1412290'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:WEGHT:NOTES:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141096543921835425)
,p_plug_name=>'Technical Criteria - Innovation'
,p_parent_plug_id=>wwv_flow_api.id(137983345169452579)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>110
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P29_TEMPLATE_ID  , 86  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141096885328835428)
,p_plug_name=>'Technical Criteria - Innovation report'
,p_parent_plug_id=>wwv_flow_api.id(141096543921835425)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_B_ID,',
'       COMPONENT_ID,',
'       CRITERION_TEXT,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       TEMPLATE_ID,',
'       DP_ITEM_ID,',
'       WEGHT',
'  from DP_SCOPING_B',
'  where COMPONENT_ID = :P29_TEMPLATE_COMPOENET_ID_86',
'  and DP_SCOPING_B_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_TEMPLATE_COMPOENET_ID_86,P28_DP_ITEM_ID,P28_TEMPLATE_ID,P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Technical Criteria - Innovation report'
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
 p_id=>wwv_flow_api.id(141096949663835429)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::P47_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>141096949663835429
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141097038393835430)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141097154351835431)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141097201036835432)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141097385809835433)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141097407788835434)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141097561549835435)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141097636172835436)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141097776388835437)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141097893166835438)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141097913110835439)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141098036576835440)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2239735507188060)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141229503663529375)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1412296'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:WEGHT:NOTES:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141098152752835441)
,p_plug_name=>'Technical Criteria - Knowledge Transfer'
,p_parent_plug_id=>wwv_flow_api.id(137983345169452579)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>120
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P29_TEMPLATE_ID  , 87  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141098411233835444)
,p_plug_name=>'Technical Criteria - Knowledge Transfer report'
,p_parent_plug_id=>wwv_flow_api.id(141098152752835441)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_B_ID,',
'       COMPONENT_ID,',
'       CRITERION_TEXT,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       TEMPLATE_ID,',
'       DP_ITEM_ID,',
'       WEGHT',
'  from DP_SCOPING_B',
'  where COMPONENT_ID = :P29_TEMPLATE_COMPOENET_ID_87',
'  and DP_SCOPING_B_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_TEMPLATE_COMPOENET_ID_87,P28_DP_ITEM_ID,P28_TEMPLATE_ID,P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Technical Criteria - Knowledge Transfer report'
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
 p_id=>wwv_flow_api.id(141098564304835445)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::P47_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>141098564304835445
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141098699285835446)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141098714539835447)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141098822658835448)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141098974800835449)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141099082054835450)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141116133078808001)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141116209572808002)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141116358726808003)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141116416862808004)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141116529429808005)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141116681825808006)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2239831556188061)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141230181890529133)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1412302'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141116732308808007)
,p_plug_name=>'Technical Criteria - Stakeholder Engagement and Communication'
,p_parent_plug_id=>wwv_flow_api.id(137983345169452579)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>130
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P29_TEMPLATE_ID  , 88  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141117034923808010)
,p_plug_name=>'Technical Criteria - Stakeholder Engagement and Communication report'
,p_parent_plug_id=>wwv_flow_api.id(141116732308808007)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_B_ID,',
'       COMPONENT_ID,',
'       CRITERION_TEXT,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       TEMPLATE_ID,',
'       DP_ITEM_ID,',
'       WEGHT',
'  from DP_SCOPING_B',
'  where COMPONENT_ID = :P29_TEMPLATE_COMPOENET_ID_88',
'  and DP_SCOPING_B_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_TEMPLATE_COMPOENET_ID_88,P28_DP_ITEM_ID,P28_TEMPLATE_ID,P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Technical Criteria - Stakeholder Engagement and Communication report'
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
 p_id=>wwv_flow_api.id(141117175862808011)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::P47_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>141117175862808011
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141117298156808012)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141117347090808013)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141117417845808014)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141117530064808015)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141117662919808016)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141117748267808017)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141117835887808018)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141117970116808019)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141118042404808020)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141118150742808021)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141118276882808022)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2239995913188062)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141230746336528886)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1412308'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:WEGHT:NOTES:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141118324491808023)
,p_plug_name=>'Technical Criteria - Social and Environmental Value'
,p_parent_plug_id=>wwv_flow_api.id(137983345169452579)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>140
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P29_TEMPLATE_ID  , 89  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141118691176808026)
,p_plug_name=>'Technical Criteria - Social and Environmental Value report'
,p_parent_plug_id=>wwv_flow_api.id(141118324491808023)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_B_ID,',
'       COMPONENT_ID,',
'       CRITERION_TEXT,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       TEMPLATE_ID,',
'       DP_ITEM_ID,',
'       WEGHT',
'  from DP_SCOPING_B',
'  where COMPONENT_ID = :P29_TEMPLATE_COMPOENET_ID_89',
'  and DP_SCOPING_B_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_TEMPLATE_COMPOENET_ID_89,P28_DP_ITEM_ID,P28_TEMPLATE_ID,P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Technical Criteria - Social and Environmental Value report'
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
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(141118794696808027)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::P47_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>141118794696808027
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141118823741808028)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141118985866808029)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141119075263808030)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141119129200808031)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141119270214808032)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141119329675808033)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141119486726808034)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141119589127808035)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141119676643808036)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141119734689808037)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141119844192808038)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2240041226188063)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141231393359528647)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1412314'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:WEGHT:NOTES:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141119967984808039)
,p_plug_name=>'Technical Criteria - Value added features'
,p_parent_plug_id=>wwv_flow_api.id(137983345169452579)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>150
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P29_TEMPLATE_ID  , 90  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141120229166808042)
,p_plug_name=>'Technical Criteria - Value added features report'
,p_parent_plug_id=>wwv_flow_api.id(141119967984808039)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_B_ID,',
'       COMPONENT_ID,',
'       CRITERION_TEXT,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       TEMPLATE_ID,',
'       DP_ITEM_ID,',
'       WEGHT',
'  from DP_SCOPING_B',
'  where COMPONENT_ID = :P29_TEMPLATE_COMPOENET_ID_90',
'  and DP_SCOPING_B_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_TEMPLATE_COMPOENET_ID_90,P28_DP_ITEM_ID,P28_TEMPLATE_ID,P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Technical Criteria - Value added features report'
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
 p_id=>wwv_flow_api.id(141120357444808043)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::P47_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>141120357444808043
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141120408441808044)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141120503547808045)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141120657347808046)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141120756140808047)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141120894654808048)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141120998224808049)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141121048419808050)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141135561218788601)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141135698834788602)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141135785876788603)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141135836670788604)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2240132785188064)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141231970419528405)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1412320'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:WEGHT:NOTES:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141135927259788605)
,p_plug_name=>'Technical Criteria - Proof-of-Concept / Sample / Solution / Presentation'
,p_parent_plug_id=>wwv_flow_api.id(137983345169452579)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>160
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P29_TEMPLATE_ID  , 91  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141136219958788608)
,p_plug_name=>'Technical Criteria - Value added features report'
,p_parent_plug_id=>wwv_flow_api.id(141135927259788605)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_B_ID,',
'       COMPONENT_ID,',
'       CRITERION_TEXT,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       TEMPLATE_ID,',
'       DP_ITEM_ID,',
'       WEGHT',
'  from DP_SCOPING_B',
'  where COMPONENT_ID = :P29_TEMPLATE_COMPOENET_ID_91',
'  and DP_SCOPING_B_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_TEMPLATE_COMPOENET_ID_91,P28_DP_ITEM_ID,P28_TEMPLATE_ID,P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Technical Criteria - Value added features report'
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
 p_id=>wwv_flow_api.id(141136321203788609)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::P47_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>141136321203788609
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141136430923788610)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141136520568788611)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141136645871788612)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141136769755788613)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141136843075788614)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141136971795788615)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141137077941788616)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141137195800788617)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141137297270788618)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141137332332788619)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141137404543788620)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2240232396188065)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141232525360528166)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1412326'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:WEGHT:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141137598829788621)
,p_plug_name=>'Technical Criteria - Company Overview and Management Approach'
,p_parent_plug_id=>wwv_flow_api.id(137983345169452579)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>170
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P29_TEMPLATE_ID  , 92  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141137866911788624)
,p_plug_name=>'Technical Criteria - Company Overview and Management Approach report'
,p_parent_plug_id=>wwv_flow_api.id(141137598829788621)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_B_ID,',
'       COMPONENT_ID,',
'       CRITERION_TEXT,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       TEMPLATE_ID,',
'       DP_ITEM_ID,',
'       WEGHT',
'  from DP_SCOPING_B',
'  where COMPONENT_ID = :P29_TEMPLATE_COMPOENET_ID_92',
'  and DP_SCOPING_B_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_TEMPLATE_COMPOENET_ID_92,P28_DP_ITEM_ID,P28_TEMPLATE_ID,P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Technical Criteria - Company Overview and Management Approach report'
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
 p_id=>wwv_flow_api.id(141137989527788625)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::P47_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>141137989527788625
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141138089514788626)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141138130751788627)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141138249230788628)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141138303504788629)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141138443067788630)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141138536284788631)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141138618983788632)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141138727725788633)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141138829860788634)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141138933271788635)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141139041561788636)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2240336941188066)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141233184013527925)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1412332'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141139187302788637)
,p_plug_name=>'Technical Criteria - Program Management and Concept'
,p_parent_plug_id=>wwv_flow_api.id(137983345169452579)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>180
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P29_TEMPLATE_ID  , 93  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141139494249788640)
,p_plug_name=>'Technical Criteria - Program Management and Concept report'
,p_parent_plug_id=>wwv_flow_api.id(141139187302788637)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_B_ID,',
'       COMPONENT_ID,',
'       CRITERION_TEXT,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       TEMPLATE_ID,',
'       DP_ITEM_ID,',
'       WEGHT',
'  from DP_SCOPING_B',
'  where COMPONENT_ID = :P29_TEMPLATE_COMPOENET_ID_93',
'  and DP_SCOPING_B_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_TEMPLATE_COMPOENET_ID_93,P28_DP_ITEM_ID,P28_TEMPLATE_ID,P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Technical Criteria - Program Management and Concept report'
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
 p_id=>wwv_flow_api.id(141139580876788641)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::P47_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>141139580876788641
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141139679933788642)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141139798457788643)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141139873911788644)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141139959325788645)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141140002819788646)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141140120333788647)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141140208480788648)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141140305011788649)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141140459287788650)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141157880832681901)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141157905661681902)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2240503559188067)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141233709712527682)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1412338'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141158035726681903)
,p_plug_name=>'Technical Criteria - Business Requirement Compliance'
,p_parent_plug_id=>wwv_flow_api.id(137983345169452579)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>190
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P29_TEMPLATE_ID  , 94  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141158378057681906)
,p_plug_name=>'Technical Criteria - Business Requirement Compliance report'
,p_parent_plug_id=>wwv_flow_api.id(141158035726681903)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_B_ID,',
'       COMPONENT_ID,',
'       CRITERION_TEXT,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       TEMPLATE_ID,',
'       DP_ITEM_ID,',
'       WEGHT',
'  from DP_SCOPING_B',
'  where COMPONENT_ID = :P29_TEMPLATE_COMPOENET_ID_94',
'  and DP_SCOPING_B_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_TEMPLATE_COMPOENET_ID_94,P28_DP_ITEM_ID,P28_TEMPLATE_ID,P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Technical Criteria - Business Requirement Compliance report'
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
 p_id=>wwv_flow_api.id(141158442081681907)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::P47_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>141158442081681907
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141158585799681908)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141158629636681909)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141158715529681910)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141158842264681911)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141158909482681912)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141159046836681913)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141159119659681914)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141159228947681915)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141159322415681916)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141159464090681917)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141159596950681918)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2240537956188068)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141234305389527442)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1412344'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141159620255681919)
,p_plug_name=>'Technical Criteria - Technical Capability (Qualitative)'
,p_parent_plug_id=>wwv_flow_api.id(137983345169452579)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>200
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P29_TEMPLATE_ID  , 96  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141159915219681922)
,p_plug_name=>'Technical Criteria - Technical Capability (Qualitative) report'
,p_parent_plug_id=>wwv_flow_api.id(141159620255681919)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_B_ID,',
'       COMPONENT_ID,',
'       CRITERION_TEXT,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       TEMPLATE_ID,',
'       DP_ITEM_ID,',
'       WEGHT',
'  from DP_SCOPING_B',
'  where COMPONENT_ID = :P29_TEMPLATE_COMPOENET_ID_96',
'  and DP_SCOPING_B_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_TEMPLATE_COMPOENET_ID_96,P28_DP_ITEM_ID,P28_TEMPLATE_ID,P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Technical Criteria - Technical Capability (Qualitative) report'
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
 p_id=>wwv_flow_api.id(141160063610681923)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::P47_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>141160063610681923
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141160194792681924)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141160217026681925)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141160307150681926)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141160497782681927)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141160588750681928)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141160663858681929)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141160795822681930)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141160801304681931)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141160992281681932)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141161081151681933)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141161105446681934)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2240697697188069)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141234990412527183)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1412350'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141161226798681935)
,p_plug_name=>'Technical Criteria - Technical Capability (Quantitative)'
,p_parent_plug_id=>wwv_flow_api.id(137983345169452579)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>210
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P29_TEMPLATE_ID  , 97  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141161517008681938)
,p_plug_name=>'Technical Criteria - Technical Capability (Quantitative) report'
,p_parent_plug_id=>wwv_flow_api.id(141161226798681935)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_B_ID,',
'       COMPONENT_ID,',
'       CRITERION_TEXT,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       TEMPLATE_ID,',
'       DP_ITEM_ID,',
'       WEGHT',
'  from DP_SCOPING_B',
'  where COMPONENT_ID = :P29_TEMPLATE_COMPOENET_ID_97',
'  and DP_SCOPING_B_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_TEMPLATE_COMPOENET_ID_97,P28_DP_ITEM_ID,P28_TEMPLATE_ID,P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Technical Criteria - Technical Capability (Quantitative) report'
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
 p_id=>wwv_flow_api.id(141161624954681939)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::P47_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>141161624954681939
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141161716020681940)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141161828376681941)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141161906332681942)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141162037949681943)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141162157535681944)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141162275351681945)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141162390190681946)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141162475935681947)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141162597449681948)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141162684574681949)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141162760043681950)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2240776345188070)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141235571188526925)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1412356'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141182579111648401)
,p_plug_name=>'Technical Criteria - Team Capability'
,p_parent_plug_id=>wwv_flow_api.id(137983345169452579)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>220
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P29_TEMPLATE_ID  , 98  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141183128943648407)
,p_plug_name=>'Technical Criteria - Technical Criteria - Team Capability Report'
,p_parent_plug_id=>wwv_flow_api.id(141182579111648401)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_B_ID,',
'       COMPONENT_ID,',
'       CRITERION_TEXT,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       TEMPLATE_ID,',
'       DP_ITEM_ID,',
'       WEGHT',
'  from DP_SCOPING_B',
'  where COMPONENT_ID = :P29_TEMPLATE_COMPOENET_ID_98',
'  and DP_SCOPING_B_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_TEMPLATE_COMPOENET_ID_98,P28_DP_ITEM_ID,P28_TEMPLATE_ID,P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Technical Criteria - Technical Criteria - Team Capability Report'
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
 p_id=>wwv_flow_api.id(141183270566648408)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::P47_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>141183270566648408
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141183386257648409)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141183462777648410)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141183549160648411)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141183657506648412)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141183795328648413)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141183877238648414)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141183988132648415)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141184006686648416)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141184110643648417)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141184254429648418)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141184319903648419)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2240913267188071)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141236231084526689)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1412363'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141182826037648404)
,p_plug_name=>'Technical Criteria - Reporting and Delivery'
,p_parent_plug_id=>wwv_flow_api.id(137983345169452579)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>230
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P29_TEMPLATE_ID  , 99  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141184417942648420)
,p_plug_name=>'Technical Criteria - Reporting and Delivery Report'
,p_parent_plug_id=>wwv_flow_api.id(141182826037648404)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_B_ID,',
'       COMPONENT_ID,',
'       CRITERION_TEXT,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       TEMPLATE_ID,',
'       DP_ITEM_ID,',
'       WEGHT',
'  from DP_SCOPING_B',
'  where COMPONENT_ID = :P29_TEMPLATE_COMPOENET_ID_99',
'  and DP_SCOPING_B_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_TEMPLATE_COMPOENET_ID_99,P28_DP_ITEM_ID,P28_TEMPLATE_ID,P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Technical Criteria - Reporting and Delivery Report'
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
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(141184596981648421)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::P47_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>141184596981648421
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141184633340648422)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141184758376648423)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141184823765648424)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141184968060648425)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141185089801648426)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141185164557648427)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141185285589648428)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141185321497648429)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141185443223648430)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141185521896648431)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141185645510648432)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2240933886188072)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141236838003526453)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1412369'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141185774083648433)
,p_plug_name=>'Technical Criteria - Vendor Performance'
,p_parent_plug_id=>wwv_flow_api.id(137983345169452579)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>240
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P29_TEMPLATE_ID  , 100 ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141186007120648436)
,p_plug_name=>'Technical Criteria - Vendor Performance Report'
,p_parent_plug_id=>wwv_flow_api.id(141185774083648433)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_B_ID,',
'       COMPONENT_ID,',
'       CRITERION_TEXT,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       TEMPLATE_ID,',
'       DP_ITEM_ID,',
'       WEGHT',
'  from DP_SCOPING_B',
'  where COMPONENT_ID = :P29_TEMPLATE_COMPOENET_ID_100',
'  and DP_SCOPING_B_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_TEMPLATE_COMPOENET_ID_100,P28_DP_ITEM_ID,P28_TEMPLATE_ID,P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Technical Criteria - Vendor Performance Report'
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
 p_id=>wwv_flow_api.id(141186100466648437)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::P47_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>141186100466648437
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141186260868648438)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141186346305648439)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141186428806648440)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141186547062648441)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141186618069648442)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141186714627648443)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141186855012648444)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141186903526648445)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141187092868648446)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141187102108648447)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141187248005648448)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2241115801188073)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141237452558526218)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1412375'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141187344173648449)
,p_plug_name=>'Technical Criteria - Tourism Experience and Resources'
,p_parent_plug_id=>wwv_flow_api.id(137983345169452579)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>250
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P29_TEMPLATE_ID  , 101 ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141203363888606202)
,p_plug_name=>'Technical Criteria - Tourism Experience and Resources Report'
,p_parent_plug_id=>wwv_flow_api.id(141187344173648449)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_B_ID,',
'       COMPONENT_ID,',
'       CRITERION_TEXT,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       TEMPLATE_ID,',
'       DP_ITEM_ID,',
'       WEGHT',
'  from DP_SCOPING_B',
'  where COMPONENT_ID = :P29_TEMPLATE_COMPOENET_ID_101',
'  and DP_SCOPING_B_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_TEMPLATE_COMPOENET_ID_101,P28_DP_ITEM_ID,P28_TEMPLATE_ID,P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Technical Criteria - Tourism Experience and Resources Report'
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
 p_id=>wwv_flow_api.id(141203463652606203)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::P47_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>141203463652606203
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141203523242606204)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141203675690606205)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141203725634606206)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141203893589606207)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141203982988606208)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141204036606606209)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141204125234606210)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141204230954606211)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141204337539606212)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141204442244606213)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141204553456606214)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2241224228188074)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141238000032525976)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1412381'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141203227662606201)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(141187344173648449)
,p_button_name=>'New_101'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'BELOW_BOX'
,p_button_redirect_url=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.:47:P47_APPENDIX_ID,P47_COMPONENT_ID_H,P47_COMPONENT_ID,P47_TEMPLATE_ID,P47_TEMPLATE_ID_H,P47_DP_SCOPING_B_ID,P47_DP_ITEM_ID:B,101,&P29_TEMPLATE_COMPOENET_ID_101.,&P28_TEMPLATE_ID.,&P28_TEMPLATE_ID.,&P28_SCOPE_ID.,&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(2642218111162884)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(680038871236381)
,p_button_name=>'AppendixB_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--link:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Appendix B Help'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:68:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(137985015061452578)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(137983294112452579)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(127865952197449732)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(140897654886593029)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(138126708074298902)
,p_button_name=>'New_16'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.:47:P47_APPENDIX_ID,P47_COMPONENT_ID_H,P47_COMPONENT_ID,P47_TEMPLATE_ID,P47_TEMPLATE_ID_H,P47_DP_SCOPING_B_ID,P47_DP_ITEM_ID:B,16,&P29_TEMPLATE_COMPOENET_ID_16.,&P28_TEMPLATE_ID.,&P28_TEMPLATE_ID.,&P28_SCOPE_ID.,&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(140899525776593048)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(138126822729298903)
,p_button_name=>'New_17'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::P47_APPENDIX_ID,P47_COMPONENT_ID_H,P47_COMPONENT_ID,P47_TEMPLATE_ID,P47_TEMPLATE_ID_H,P47_DP_SCOPING_B_ID,P47_DP_ITEM_ID:B,17,&P29_TEMPLATE_COMPOENET_ID_17.,&P28_TEMPLATE_ID.,&P28_TEMPLATE_ID.,&P28_SCOPE_ID.,&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141053996126920201)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(138127078778298905)
,p_button_name=>'New_18'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.:47:P47_APPENDIX_ID,P47_COMPONENT_ID_H,P47_COMPONENT_ID,P47_TEMPLATE_ID,P47_TEMPLATE_ID_H,P47_DP_SCOPING_B_ID,P47_DP_ITEM_ID:B,18,&P29_TEMPLATE_COMPOENET_ID_18.,&P28_TEMPLATE_ID.,&P28_TEMPLATE_ID.,&P28_SCOPE_ID.,&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141056900329920231)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(138127480491298909)
,p_button_name=>'New_20'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.:47:P47_APPENDIX_ID,P47_COMPONENT_ID_H,P47_COMPONENT_ID,P47_TEMPLATE_ID,P47_TEMPLATE_ID_H,P47_DP_SCOPING_B_ID,P47_DP_ITEM_ID:B,20,&P29_TEMPLATE_COMPOENET_ID_20.,&P28_TEMPLATE_ID.,&P28_TEMPLATE_ID.,&P28_SCOPE_ID.,&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141058554722920247)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(141058313899920245)
,p_button_name=>'New_81'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.:47:P47_APPENDIX_ID,P47_COMPONENT_ID_H,P47_COMPONENT_ID,P47_TEMPLATE_ID,P47_TEMPLATE_ID_H,P47_DP_SCOPING_B_ID,P47_DP_ITEM_ID:B,81,&P29_TEMPLATE_COMPOENET_ID_81.,&P28_TEMPLATE_ID.,&P28_TEMPLATE_ID.,&P28_SCOPE_ID.,&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141075088392875113)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(141074841447875111)
,p_button_name=>'New_82'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.:47:P47_APPENDIX_ID,P47_COMPONENT_ID_H,P47_COMPONENT_ID,P47_TEMPLATE_ID,P47_TEMPLATE_ID_H,P47_DP_SCOPING_B_ID,P47_DP_ITEM_ID:B,82,&P29_TEMPLATE_COMPOENET_ID_82.,&P28_TEMPLATE_ID.,&P28_TEMPLATE_ID.,&P28_SCOPE_ID.,&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141076649573875129)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(141076482333875127)
,p_button_name=>'New_83'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.:47:P47_APPENDIX_ID,P47_COMPONENT_ID_H,P47_COMPONENT_ID,P47_TEMPLATE_ID,P47_TEMPLATE_ID_H,P47_DP_SCOPING_B_ID,P47_DP_ITEM_ID:B,83,&P29_TEMPLATE_COMPOENET_ID_83.,&P28_TEMPLATE_ID.,&P28_TEMPLATE_ID.,&P28_SCOPE_ID.,&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141078294460875145)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(141078090682875143)
,p_button_name=>'New_84'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.:47:P47_APPENDIX_ID,P47_COMPONENT_ID_H,P47_COMPONENT_ID,P47_TEMPLATE_ID,P47_TEMPLATE_ID_H,P47_DP_SCOPING_B_ID,P47_DP_ITEM_ID:B,84,&P29_TEMPLATE_COMPOENET_ID_84.,&P28_TEMPLATE_ID.,&P28_TEMPLATE_ID.,&P28_SCOPE_ID.,&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141095138760835411)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(141094921271835409)
,p_button_name=>'New_85'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.:47:P47_APPENDIX_ID,P47_COMPONENT_ID_H,P47_COMPONENT_ID,P47_TEMPLATE_ID,P47_TEMPLATE_ID_H,P47_DP_SCOPING_B_ID,P47_DP_ITEM_ID:B,85,&P29_TEMPLATE_COMPOENET_ID_85.,&P28_TEMPLATE_ID.,&P28_TEMPLATE_ID.,&P28_SCOPE_ID.,&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141096792627835427)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(141096543921835425)
,p_button_name=>'New_86'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.:47:P47_APPENDIX_ID,P47_COMPONENT_ID_H,P47_COMPONENT_ID,P47_TEMPLATE_ID,P47_TEMPLATE_ID_H,P47_DP_SCOPING_B_ID,P47_DP_ITEM_ID:B,86,&P29_TEMPLATE_COMPOENET_ID_86.,&P28_TEMPLATE_ID.,&P28_TEMPLATE_ID.,&P28_SCOPE_ID.,&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141098322422835443)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(141098152752835441)
,p_button_name=>'New_87'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.:47:P47_APPENDIX_ID,P47_COMPONENT_ID_H,P47_COMPONENT_ID,P47_TEMPLATE_ID,P47_TEMPLATE_ID_H,P47_DP_SCOPING_B_ID,P47_DP_ITEM_ID:B,87,&P29_TEMPLATE_COMPOENET_ID_87.,&P28_TEMPLATE_ID.,&P28_TEMPLATE_ID.,&P28_SCOPE_ID.,&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141120102376808041)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(141119967984808039)
,p_button_name=>'New_90'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.:47:P47_APPENDIX_ID,P47_COMPONENT_ID_H,P47_COMPONENT_ID,P47_TEMPLATE_ID,P47_TEMPLATE_ID_H,P47_DP_SCOPING_B_ID,P47_DP_ITEM_ID:B,90,&P29_TEMPLATE_COMPOENET_ID_90.,&P28_DP_ITEM_ID.,&P28_DP_ITEM_ID.,&P28_SCOPE_ID.,&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141136126460788607)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(141135927259788605)
,p_button_name=>'New_91'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.:47:P47_APPENDIX_ID,P47_COMPONENT_ID_H,P47_COMPONENT_ID,P47_TEMPLATE_ID,P47_TEMPLATE_ID_H,P47_DP_SCOPING_B_ID,P47_DP_ITEM_ID:B,91,&P29_TEMPLATE_COMPOENET_ID_91.,&P28_TEMPLATE_ID.,&P28_TEMPLATE_ID.,&P28_SCOPE_ID.,&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141137784083788623)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(141137598829788621)
,p_button_name=>'New_92'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.:47:P47_APPENDIX_ID,P47_COMPONENT_ID_H,P47_COMPONENT_ID,P47_TEMPLATE_ID,P47_TEMPLATE_ID_H,P47_DP_SCOPING_B_ID,P47_DP_ITEM_ID:B,92,&P29_TEMPLATE_COMPOENET_ID_92.,&P28_TEMPLATE_ID.,&P28_TEMPLATE_ID.,&P28_SCOPE_ID.,&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141139383712788639)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(141139187302788637)
,p_button_name=>'New_93'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.:47:P47_APPENDIX_ID,P47_COMPONENT_ID_H,P47_COMPONENT_ID,P47_TEMPLATE_ID,P47_TEMPLATE_ID_H,P47_DP_SCOPING_B_ID,P47_DP_ITEM_ID:B,93,&P29_TEMPLATE_COMPOENET_ID_93.,&P28_TEMPLATE_ID.,&P28_TEMPLATE_ID.,&P28_SCOPE_ID.,&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141158286850681905)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(141158035726681903)
,p_button_name=>'New_94'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.:47:P47_APPENDIX_ID,P47_COMPONENT_ID_H,P47_COMPONENT_ID,P47_TEMPLATE_ID,P47_TEMPLATE_ID_H,P47_DP_SCOPING_B_ID,P47_DP_ITEM_ID:B,94,&P29_TEMPLATE_COMPOENET_ID_94.,&P28_TEMPLATE_ID.,&P28_TEMPLATE_ID.,&P28_SCOPE_ID.,&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141159862448681921)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(141159620255681919)
,p_button_name=>'New_96'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.:47:P47_APPENDIX_ID,P47_COMPONENT_ID_H,P47_COMPONENT_ID,P47_TEMPLATE_ID,P47_TEMPLATE_ID_H,P47_DP_SCOPING_B_ID,P47_DP_ITEM_ID:B,96,&P29_TEMPLATE_COMPOENET_ID_96.,&P28_TEMPLATE_ID.,&P28_TEMPLATE_ID.,&P28_SCOPE_ID.,&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141161475015681937)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(141161226798681935)
,p_button_name=>'New_97'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.:47:P47_APPENDIX_ID,P47_COMPONENT_ID_H,P47_COMPONENT_ID,P47_TEMPLATE_ID,P47_TEMPLATE_ID_H,P47_DP_SCOPING_B_ID,P47_DP_ITEM_ID:B,97,&P29_TEMPLATE_COMPOENET_ID_97.,&P28_TEMPLATE_ID.,&P28_TEMPLATE_ID.,&P28_SCOPE_ID.,&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141182783158648403)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(141182579111648401)
,p_button_name=>'New_98'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.:47:P47_APPENDIX_ID,P47_COMPONENT_ID_H,P47_COMPONENT_ID,P47_TEMPLATE_ID,P47_TEMPLATE_ID_H,P47_DP_SCOPING_B_ID,P47_DP_ITEM_ID:B,98,&P29_TEMPLATE_COMPOENET_ID_98.,&P28_TEMPLATE_ID.,&P28_TEMPLATE_ID.,&P28_SCOPE_ID.,&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141183026689648406)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(141182826037648404)
,p_button_name=>'New_99'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.:47:P47_APPENDIX_ID,P47_COMPONENT_ID_H,P47_COMPONENT_ID,P47_TEMPLATE_ID,P47_TEMPLATE_ID_H,P47_DP_SCOPING_B_ID,P47_DP_ITEM_ID:B,99,&P29_TEMPLATE_COMPOENET_ID_99.,&P28_TEMPLATE_ID.,&P28_TEMPLATE_ID.,&P28_SCOPE_ID.,&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141185971997648435)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(141185774083648433)
,p_button_name=>'New_100'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.:47:P47_APPENDIX_ID,P47_COMPONENT_ID_H,P47_COMPONENT_ID,P47_TEMPLATE_ID,P47_TEMPLATE_ID_H,P47_DP_SCOPING_B_ID,P47_DP_ITEM_ID:B,100,&P29_TEMPLATE_COMPOENET_ID_100.,&P29_TEMPLATE_ID.,&P28_TEMPLATE_ID.,&P28_SCOPE_ID.,&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141055449374920216)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(138127230733298907)
,p_button_name=>'New_19'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.:47:P47_APPENDIX_ID,P47_COMPONENT_ID_H,P47_COMPONENT_ID,P47_TEMPLATE_ID,P47_TEMPLATE_ID_H,P47_DP_SCOPING_B_ID,P47_DP_ITEM_ID:B,19,&P29_TEMPLATE_COMPOENET_ID_19.,&P28_TEMPLATE_ID.,&P28_TEMPLATE_ID.,&P28_SCOPE_ID.,&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141116942636808009)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(141116732308808007)
,p_button_name=>'New_88'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.:47:P47_APPENDIX_ID,P47_COMPONENT_ID_H,P47_COMPONENT_ID,P47_TEMPLATE_ID,P47_TEMPLATE_ID_H,P47_DP_SCOPING_B_ID,P47_DP_ITEM_ID:B,88,&P29_TEMPLATE_COMPOENET_ID_88.,&P28_TEMPLATE_ID.,&P28_TEMPLATE_ID.,&P28_SCOPE_ID.,&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141118549783808025)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(141118324491808023)
,p_button_name=>'New_89'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.:47:P47_APPENDIX_ID,P47_COMPONENT_ID_H,P47_COMPONENT_ID,P47_TEMPLATE_ID,P47_TEMPLATE_ID_H,P47_DP_SCOPING_B_ID,P47_DP_ITEM_ID:B,89,&P29_TEMPLATE_COMPOENET_ID_89.,&P28_DP_ITEM_ID.,&P28_DP_ITEM_ID.,&P28_SCOPE_ID.,&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141326765742938542)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(138126708074298902)
,p_button_name=>'New_16_S'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add From Samples'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::P54_TEMPLATE_COMPOENET_ID,P54_TEMPLATE_ID,P54_ITEM_ID,P54_COMPOENET_ID,P54_APPENDIX_ID:&P29_TEMPLATE_COMPOENET_ID_16.,&P29_TEMPLATE_ID.,&P29_ITEM_ID.,16,B'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141587974145161533)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(138126822729298903)
,p_button_name=>'New_17_S'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add From Samples'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::P54_TEMPLATE_COMPOENET_ID,P54_TEMPLATE_ID,P54_ITEM_ID,P54_COMPOENET_ID,P54_APPENDIX_ID:&P29_TEMPLATE_COMPOENET_ID_17.,&P29_TEMPLATE_ID.,&P29_ITEM_ID.,17,B'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141588070783161534)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(138127078778298905)
,p_button_name=>'New_18_S'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add From Samples'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::P54_TEMPLATE_COMPOENET_ID,P54_TEMPLATE_ID,P54_ITEM_ID,P54_COMPOENET_ID,P54_APPENDIX_ID:&P29_TEMPLATE_COMPOENET_ID_18.,&P29_TEMPLATE_ID.,&P29_ITEM_ID.,18,B'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141588210457161536)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(138127480491298909)
,p_button_name=>'New_20_S'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add From Samples'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::P54_TEMPLATE_COMPOENET_ID,P54_TEMPLATE_ID,P54_ITEM_ID,P54_COMPOENET_ID,P54_APPENDIX_ID:&P29_TEMPLATE_COMPOENET_ID_20.,&P29_TEMPLATE_ID.,&P29_ITEM_ID.,20,B'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141588380087161537)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(141058313899920245)
,p_button_name=>'New_81_S'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add From Samples'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::P54_TEMPLATE_COMPOENET_ID,P54_TEMPLATE_ID,P54_ITEM_ID,P54_COMPOENET_ID,P54_APPENDIX_ID:&P29_TEMPLATE_COMPOENET_ID_81.,&P29_TEMPLATE_ID.,&P29_ITEM_ID.,81,B'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141588494441161538)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(141074841447875111)
,p_button_name=>'New_82_S'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add From Samples'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::P54_TEMPLATE_COMPOENET_ID,P54_TEMPLATE_ID,P54_ITEM_ID,P54_COMPOENET_ID,P54_APPENDIX_ID:&P29_TEMPLATE_COMPOENET_ID_82.,&P29_TEMPLATE_ID.,&P29_ITEM_ID.,82,B'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141588510289161539)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(141076482333875127)
,p_button_name=>'New_83_S'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add From Samples'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::P54_TEMPLATE_COMPOENET_ID,P54_TEMPLATE_ID,P54_ITEM_ID,P54_COMPOENET_ID,P54_APPENDIX_ID:&P29_TEMPLATE_COMPOENET_ID_83.,&P29_TEMPLATE_ID.,&P29_ITEM_ID.,83,B'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141588655724161540)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(141078090682875143)
,p_button_name=>'New_84_S'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add From Samples'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::P54_TEMPLATE_COMPOENET_ID,P54_TEMPLATE_ID,P54_ITEM_ID,P54_COMPOENET_ID,P54_APPENDIX_ID:&P29_TEMPLATE_COMPOENET_ID_84.,&P29_TEMPLATE_ID.,&P29_ITEM_ID.,84,B'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141588798650161541)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(141094921271835409)
,p_button_name=>'New_85_S'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add From Samples'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::P54_TEMPLATE_COMPOENET_ID,P54_TEMPLATE_ID,P54_ITEM_ID,P54_COMPOENET_ID,P54_APPENDIX_ID:&P29_TEMPLATE_COMPOENET_ID_85.,&P29_TEMPLATE_ID.,&P29_ITEM_ID.,85,B'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141588815049161542)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(141096543921835425)
,p_button_name=>'New_86_S'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add From Samples'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::P54_TEMPLATE_COMPOENET_ID,P54_TEMPLATE_ID,P54_ITEM_ID,P54_COMPOENET_ID,P54_APPENDIX_ID:&P29_TEMPLATE_COMPOENET_ID_86.,&P29_TEMPLATE_ID.,&P29_ITEM_ID.,86,B'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141588974039161543)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(141098152752835441)
,p_button_name=>'New_87_S'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add From Samples'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::P54_TEMPLATE_COMPOENET_ID,P54_TEMPLATE_ID,P54_ITEM_ID,P54_COMPOENET_ID,P54_APPENDIX_ID:&P29_TEMPLATE_COMPOENET_ID_87.,&P29_TEMPLATE_ID.,&P29_ITEM_ID.,87,B'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141589246514161546)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(141119967984808039)
,p_button_name=>'New_90_S'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add From Samples'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::P54_TEMPLATE_COMPOENET_ID,P54_TEMPLATE_ID,P54_ITEM_ID,P54_COMPOENET_ID,P54_APPENDIX_ID:&P29_TEMPLATE_COMPOENET_ID_90.,&P29_TEMPLATE_ID.,&P29_ITEM_ID.,90,B'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141589350263161547)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(141135927259788605)
,p_button_name=>'New_91_S'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add From Samples'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::P54_TEMPLATE_COMPOENET_ID,P54_TEMPLATE_ID,P54_ITEM_ID,P54_COMPOENET_ID,P54_APPENDIX_ID:&P29_TEMPLATE_COMPOENET_ID_91.,&P29_TEMPLATE_ID.,&P29_ITEM_ID.,91,B'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141589491596161548)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(141137598829788621)
,p_button_name=>'New_92_S'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add From Samples'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::P54_TEMPLATE_COMPOENET_ID,P54_TEMPLATE_ID,P54_ITEM_ID,P54_COMPOENET_ID,P54_APPENDIX_ID:&P29_TEMPLATE_COMPOENET_ID_92.,&P29_TEMPLATE_ID.,&P29_ITEM_ID.,92,B'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141589586125161549)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(141139187302788637)
,p_button_name=>'New_93_S'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add From Samples'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::P54_TEMPLATE_COMPOENET_ID,P54_TEMPLATE_ID,P54_ITEM_ID,P54_COMPOENET_ID,P54_APPENDIX_ID:&P29_TEMPLATE_COMPOENET_ID_93.,&P29_TEMPLATE_ID.,&P29_ITEM_ID.,93,B'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141589655998161550)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(141158035726681903)
,p_button_name=>'New_94_S'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add From Samples'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::P54_TEMPLATE_COMPOENET_ID,P54_TEMPLATE_ID,P54_ITEM_ID,P54_COMPOENET_ID,P54_APPENDIX_ID:&P29_TEMPLATE_COMPOENET_ID_94.,&P29_TEMPLATE_ID.,&P29_ITEM_ID.,94,B'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141648699999843901)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(141159620255681919)
,p_button_name=>'New_96_S'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add From Samples'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::P54_TEMPLATE_COMPOENET_ID,P54_TEMPLATE_ID,P54_ITEM_ID,P54_COMPOENET_ID,P54_APPENDIX_ID:&P29_TEMPLATE_COMPOENET_ID_96.,&P29_TEMPLATE_ID.,&P29_ITEM_ID.,96,B'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141648714039843902)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(141161226798681935)
,p_button_name=>'New_97_S'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add From Samples'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::P54_TEMPLATE_COMPOENET_ID,P54_TEMPLATE_ID,P54_ITEM_ID,P54_COMPOENET_ID,P54_APPENDIX_ID:&P29_TEMPLATE_COMPOENET_ID_97.,&P29_TEMPLATE_ID.,&P29_ITEM_ID.,97,B'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141648801150843903)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(141182579111648401)
,p_button_name=>'New_98_S'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add From Samples'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::P54_TEMPLATE_COMPOENET_ID,P54_TEMPLATE_ID,P54_ITEM_ID,P54_COMPOENET_ID,P54_APPENDIX_ID:&P29_TEMPLATE_COMPOENET_ID_98.,&P29_TEMPLATE_ID.,&P29_ITEM_ID.,98,B'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141648948110843904)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(141182826037648404)
,p_button_name=>'New_99_S'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add From Samples'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::P54_TEMPLATE_COMPOENET_ID,P54_TEMPLATE_ID,P54_ITEM_ID,P54_COMPOENET_ID,P54_APPENDIX_ID:&P29_TEMPLATE_COMPOENET_ID_99.,&P29_TEMPLATE_ID.,&P29_ITEM_ID.,99,B'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141649053517843905)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(141185774083648433)
,p_button_name=>'New_100_S'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add From Samples'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::P54_TEMPLATE_COMPOENET_ID,P54_TEMPLATE_ID,P54_ITEM_ID,P54_COMPOENET_ID,P54_APPENDIX_ID:&P29_TEMPLATE_COMPOENET_ID_100.,&P29_TEMPLATE_ID.,&P29_ITEM_ID.,100,B'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141649152686843906)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(141187344173648449)
,p_button_name=>'New_101_S'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add From Samples'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::P54_TEMPLATE_COMPOENET_ID,P54_TEMPLATE_ID,P54_ITEM_ID,P54_COMPOENET_ID,P54_APPENDIX_ID:&P29_TEMPLATE_COMPOENET_ID_101.,&P29_TEMPLATE_ID.,&P29_ITEM_ID.,101,B'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141588128297161535)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(138127230733298907)
,p_button_name=>'New_19_S'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add From Samples'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::P54_TEMPLATE_COMPOENET_ID,P54_TEMPLATE_ID,P54_ITEM_ID,P54_COMPOENET_ID,P54_APPENDIX_ID:&P29_TEMPLATE_COMPOENET_ID_19.,&P29_TEMPLATE_ID.,&P29_ITEM_ID.,19,B'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141589013724161544)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(141116732308808007)
,p_button_name=>'New_88_S'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add From Samples'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::P54_TEMPLATE_COMPOENET_ID,P54_TEMPLATE_ID,P54_ITEM_ID,P54_COMPOENET_ID,P54_APPENDIX_ID:&P29_TEMPLATE_COMPOENET_ID_88.,&P29_TEMPLATE_ID.,&P29_ITEM_ID.,88,B'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141589102212161545)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(141118324491808023)
,p_button_name=>'New_89_S'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add From Samples'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::P54_TEMPLATE_COMPOENET_ID,P54_TEMPLATE_ID,P54_ITEM_ID,P54_COMPOENET_ID,P54_APPENDIX_ID:&P29_TEMPLATE_COMPOENET_ID_89.,&P29_TEMPLATE_ID.,&P29_ITEM_ID.,89,B'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(144068029767480823)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(137983294112452579)
,p_button_name=>'Expand_ALL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Expand / Collapse'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-expand-collapse'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(137985343526452578)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(137983294112452579)
,p_button_name=>'NEXT'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Next'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_icon_css_classes=>'fa-chevron-right'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(137985273748452578)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(137983294112452579)
,p_button_name=>'PREVIOUS'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Previous'
,p_button_position=>'REGION_TEMPLATE_PREVIOUS'
,p_button_execute_validations=>'N'
,p_icon_css_classes=>'fa-chevron-left'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(137986732136452577)
,p_branch_name=>'Go To Page 30'
,p_branch_action=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.::P30_ITEM_ID,P30_SCOPE_ID,P30_SUB_CATEGORY_ID,P30_TEMPLATE_ID:&P28_DP_ITEM_ID.,&P28_SCOPE_ID.,&P29_SUB_CATEGORY_ID.,&P28_TEMPLATE_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(137985343526452578)
,p_branch_sequence=>20
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(137986081025452577)
,p_branch_action=>'f?p=&APP_ID.:28:&APP_SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'BEFORE_VALIDATION'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(137985273748452578)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(680215988236382)
,p_name=>'P29_TOTAL_WEIGHT'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(680038871236381)
,p_use_cache_before_default=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select TRIM(to_char(nvl(sum(WEGHT) , 0), ''999.99'')) || '' %''  amount',
'from dp_scoping_b',
'where dp_scoping_b_id = :P28_SCOPE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140897132794593024)
,p_name=>'P29_TEMPLATE_COMPOENET_ID_16'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(138126708074298902)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 16',
'AND template_id = :P29_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140897256120593025)
,p_name=>'P29_TEMPLATE_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(137983294112452579)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140897378072593026)
,p_name=>'P29_ITEM_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(137983294112452579)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140897437973593027)
,p_name=>'P29_SUB_CATEGORY_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(137983294112452579)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140898011637593033)
,p_name=>'P29_SCOPE_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(137983294112452579)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140899618930593049)
,p_name=>'P29_TEMPLATE_COMPOENET_ID_17'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(138126822729298903)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 17',
'AND template_id = :P29_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140899799528593050)
,p_name=>'P29_TEMPLATE_COMPOENET_ID_18'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(138127078778298905)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 18',
'AND template_id = :P29_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141055346956920215)
,p_name=>'P29_TEMPLATE_COMPOENET_ID_19'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(138127230733298907)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 19',
'AND template_id = :P29_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141056864405920230)
,p_name=>'P29_TEMPLATE_COMPOENET_ID_20'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(138127480491298909)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 20',
'AND template_id = :P29_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141058471295920246)
,p_name=>'P29_TEMPLATE_COMPOENET_ID_81'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(141058313899920245)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 81',
'AND template_id = :P29_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141074979269875112)
,p_name=>'P29_TEMPLATE_COMPOENET_ID_82'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(141074841447875111)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 82',
'AND template_id = :P29_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141076501803875128)
,p_name=>'P29_TEMPLATE_COMPOENET_ID_83'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(141076482333875127)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 83',
'AND template_id = :P29_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141078194213875144)
,p_name=>'P29_TEMPLATE_COMPOENET_ID_84'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(141078090682875143)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 84',
'AND template_id = :P29_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141095070462835410)
,p_name=>'P29_TEMPLATE_COMPOENET_ID_85'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(141094921271835409)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 85',
'AND template_id = :P29_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141096696673835426)
,p_name=>'P29_TEMPLATE_COMPOENET_ID_86'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(141096543921835425)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 86',
'AND template_id = :P29_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141098263689835442)
,p_name=>'P29_TEMPLATE_COMPOENET_ID_87'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(141098152752835441)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 87',
'AND template_id = :P29_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141116865185808008)
,p_name=>'P29_TEMPLATE_COMPOENET_ID_88'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(141116732308808007)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 88',
'AND template_id = :P29_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141118414425808024)
,p_name=>'P29_TEMPLATE_COMPOENET_ID_89'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(141118324491808023)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 89',
'AND template_id = :P29_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141120093284808040)
,p_name=>'P29_TEMPLATE_COMPOENET_ID_90'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(141119967984808039)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 90',
'AND template_id = :P29_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141136096628788606)
,p_name=>'P29_TEMPLATE_COMPOENET_ID_91'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(141135927259788605)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 91',
'AND template_id = :P29_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141137680956788622)
,p_name=>'P29_TEMPLATE_COMPOENET_ID_92'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(141137598829788621)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 92',
'AND template_id = :P29_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141139235004788638)
,p_name=>'P29_TEMPLATE_COMPOENET_ID_93'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(141139187302788637)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 93',
'AND template_id = :P29_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141158137405681904)
,p_name=>'P29_TEMPLATE_COMPOENET_ID_94'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(141158035726681903)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 94',
'AND template_id = :P29_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141159784766681920)
,p_name=>'P29_TEMPLATE_COMPOENET_ID_96'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(141159620255681919)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 96',
'AND template_id = :P29_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141161399822681936)
,p_name=>'P29_TEMPLATE_COMPOENET_ID_97'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(141161226798681935)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 97',
'AND template_id = :P29_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141182628187648402)
,p_name=>'P29_TEMPLATE_COMPOENET_ID_98'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(141182579111648401)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 98',
'AND template_id = :P29_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141182979510648405)
,p_name=>'P29_TEMPLATE_COMPOENET_ID_99'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(141182826037648404)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 99',
'AND template_id = :P29_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141185886564648434)
,p_name=>'P29_TEMPLATE_COMPOENET_ID_100'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(141185774083648433)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 100',
'AND template_id = :P29_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141187415085648450)
,p_name=>'P29_TEMPLATE_COMPOENET_ID_101'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(141187344173648449)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 101',
'AND template_id = :P29_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(144068350895480826)
,p_name=>'P29_EXPAND_ALL'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(137983294112452579)
,p_item_default=>'E'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(140897719891593030)
,p_name=>'New'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(140897654886593029)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(140897861820593031)
,p_event_id=>wwv_flow_api.id(140897719891593030)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(140895853538593011)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(144068167660480824)
,p_name=>'Expand All B'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(144068029767480823)
,p_condition_element=>'P29_EXPAND_ALL'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'E'
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144068201195480825)
,p_event_id=>wwv_flow_api.id(144068167660480824)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138126708074298902)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144068579417480828)
,p_event_id=>wwv_flow_api.id(144068167660480824)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138126708074298902)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144068720136480830)
,p_event_id=>wwv_flow_api.id(144068167660480824)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138127230733298907)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144068849028480831)
,p_event_id=>wwv_flow_api.id(144068167660480824)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138127230733298907)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144068673767480829)
,p_event_id=>wwv_flow_api.id(144068167660480824)
,p_event_result=>'FALSE'
,p_action_sequence=>50
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P29_EXPAND_ALL'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'E'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144068417670480827)
,p_event_id=>wwv_flow_api.id(144068167660480824)
,p_event_result=>'TRUE'
,p_action_sequence=>210
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P29_EXPAND_ALL'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'C'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.component_end;
end;
/
