prompt --application/pages/page_00030
begin
--   Manifest
--     PAGE: 00030
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
 p_id=>30
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'APPENDIX C - COMMERCIAL EVALUATION CRITERIA'
,p_alias=>'APPENDIX-C-COMMERCIAL-EVALUATION-CRITERIA'
,p_step_title=>'APPENDIX C - COMMERCIAL EVALUATION CRITERIA'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230207172710'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(137987429890452576)
,p_plug_name=>'APPENDIX C - COMMERCIAL EVALUATION CRITERIA'
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
 p_id=>wwv_flow_api.id(137987505702452576)
,p_plug_name=>'APPENDIX C - COMMERCIAL EVALUATION CRITERIA'
,p_parent_plug_id=>wwv_flow_api.id(137987429890452576)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127776395121449810)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138127686873298911)
,p_plug_name=>'Commercial Criterion'
,p_parent_plug_id=>wwv_flow_api.id(137987505702452576)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''C'' , :P29_TEMPLATE_ID  , 21  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141204874430606217)
,p_plug_name=>'Commercial Criterion 1 Report'
,p_parent_plug_id=>wwv_flow_api.id(138127686873298911)
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_C_ID,',
'       COMPONENT_ID,',
'       TEMPLATE_ID,',
'       DP_ITEM_ID,',
'       CRITERION_TEXT,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE',
'from DP_SCOPING_C',
'where COMPONENT_ID = :P30_TEMPLATE_COMPOENET_ID_21',
'  and DP_SCOPING_C_ID =  :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P28_SCOPE_ID,P30_TEMPLATE_COMPOENET_ID_21,P28_TEMPLATE_ID,P28_DP_ITEM_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Commercial Criterion 1 Report'
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
 p_id=>wwv_flow_api.id(141204930709606218)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Commercial Criterion Available'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:57:&SESSION.::&DEBUG.::P57_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>141204930709606218
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141205084131606219)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141205158645606220)
,p_db_column_name=>'DP_SCOPING_C_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping C Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141205254257606221)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141205386187606222)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141205448367606223)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141205575953606224)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Criterion Text'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141205612087606225)
,p_db_column_name=>'NOTES'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141205764613606226)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141205856775606227)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141205977013606228)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141206002661606229)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141320022331215800)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1413201'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:NOTES:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138127730478298912)
,p_plug_name=>'Commercial Criterion 2'
,p_parent_plug_id=>wwv_flow_api.id(137987505702452576)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'NEVER'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_plug_comment=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''C'' , :P29_TEMPLATE_ID  , 22  ) = ''Y'''
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141206722307606236)
,p_plug_name=>'Commercial Criterion 2 Report'
,p_parent_plug_id=>wwv_flow_api.id(138127730478298912)
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_C_ID,',
'       COMPONENT_ID,',
'       TEMPLATE_ID,',
'       DP_ITEM_ID,',
'       CRITERION_TEXT,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE',
'from DP_SCOPING_C',
'where COMPONENT_ID = :P30_TEMPLATE_COMPOENET_ID_22',
'  and DP_SCOPING_C_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P28_SCOPE_ID,P30_TEMPLATE_COMPOENET_ID_21,P28_TEMPLATE_ID,P28_DP_ITEM_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Commercial Criterion 2 Report'
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
 p_id=>wwv_flow_api.id(141206857857606237)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Commercial Criterion Available'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:57:&SESSION.::&DEBUG.::P57_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>141206857857606237
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141206993215606238)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141207013490606239)
,p_db_column_name=>'DP_SCOPING_C_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping C Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141207190179606240)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141207282366606241)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141207316606606242)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141207442716606243)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Criterion Text'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141207546146606244)
,p_db_column_name=>'NOTES'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141207609432606245)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141207791210606246)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141207871631606247)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141207998435606248)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141320639475215567)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1413207'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_C_ID:COMPONENT_ID:TEMPLATE_ID:DP_ITEM_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(137989222116452575)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(137987429890452576)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(127865952197449732)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(2642248235162885)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(138127686873298911)
,p_button_name=>'P31_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--link:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Commercial Evaluation Guidance'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:69:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141204702504606216)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(138127730478298912)
,p_button_name=>'New_2'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:57:&SESSION.::&DEBUG.:57:P57_APPENDIX_ID,P57_COMPONENT_ID_H,P57_COMPONENT_ID,P57_TEMPLATE_ID,P57_TEMPLATE_ID_H,P57_DP_SCOPING_C_ID,P57_DP_ITEM_ID:C,22,&P30_TEMPLATE_COMPOENET_ID_22.,&P28_TEMPLATE_ID.,&P28_TEMPLATE_ID.,&P28_SCOPE_ID.,&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141204696440606215)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(138127686873298911)
,p_button_name=>'New_1'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:57:&SESSION.::&DEBUG.::P57_APPENDIX_ID,P57_COMPONENT_ID_H,P57_COMPONENT_ID,P57_TEMPLATE_ID,P57_TEMPLATE_ID_H,P57_DP_SCOPING_C_ID,P57_DP_ITEM_ID:C,21,&P30_TEMPLATE_COMPOENET_ID_21.,&P28_TEMPLATE_ID.,&P28_TEMPLATE_ID.,&P28_SCOPE_ID.,&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(144110381537970203)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(137987429890452576)
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
 p_id=>wwv_flow_api.id(137989570126452575)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(137987429890452576)
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
 p_id=>wwv_flow_api.id(137989480896452575)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(137987429890452576)
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
 p_id=>wwv_flow_api.id(137990994540452575)
,p_branch_name=>'Go To Page 31'
,p_branch_action=>'f?p=&APP_ID.:31:&SESSION.::&DEBUG.::P31_ITEM_ID,P31_SCOPE_ID,P31_SUB_CATEGORY_ID,P31_TEMPLATE_ID:&P28_DP_ITEM_ID.,&P28_SCOPE_ID.,&P30_SUB_CATEGORY_ID.,&P28_TEMPLATE_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(137989570126452575)
,p_branch_sequence=>20
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(137990256558452575)
,p_branch_action=>'f?p=&APP_ID.:29:&APP_SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'BEFORE_VALIDATION'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(137989480896452575)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141206185965606230)
,p_name=>'P30_SCOPE_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(137987429890452576)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141206264903606231)
,p_name=>'P30_TEMPLATE_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(137987429890452576)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141206391250606232)
,p_name=>'P30_ITEM_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(137987429890452576)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141206418550606233)
,p_name=>'P30_SUB_CATEGORY_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(137987429890452576)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141206511032606234)
,p_name=>'P30_TEMPLATE_COMPOENET_ID_21'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(138127686873298911)
,p_use_cache_before_default=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 21',
'AND template_id = :P30_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141206611286606235)
,p_name=>'P30_TEMPLATE_COMPOENET_ID_22'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(138127730478298912)
,p_use_cache_before_default=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 22',
'AND template_id = :P30_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(144110738692970207)
,p_name=>'P30_EXPAND'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(137987429890452576)
,p_item_default=>'E'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(144110569896970205)
,p_name=>'Expand DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(144110381537970203)
,p_condition_element=>'P30_EXPAND'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'E'
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144110624948970206)
,p_event_id=>wwv_flow_api.id(144110569896970205)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138127686873298911)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144110888345970208)
,p_event_id=>wwv_flow_api.id(144110569896970205)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138127730478298912)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144111112667970211)
,p_event_id=>wwv_flow_api.id(144110569896970205)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138127730478298912)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144110964522970209)
,p_event_id=>wwv_flow_api.id(144110569896970205)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_EXPAND'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'C'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144111006233970210)
,p_event_id=>wwv_flow_api.id(144110569896970205)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138127686873298911)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144111213577970212)
,p_event_id=>wwv_flow_api.id(144110569896970205)
,p_event_result=>'FALSE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_EXPAND'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'E'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.component_end;
end;
/
